local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

-- TODO: For some reason when I tested this on a blank save I still unlocked delirious and d-infinity after killing delirium
-- I thought enabling the dummy challenge would disable achievements, it even has the little icon but IDK. Need to look into it
mod.challenges.followTheRabbit = Isaac.GetChallengeIdByName("[FFBonus!] Follow the Rabbit")

mod.ITEM.PILL.RABBIT_PILL = Isaac.GetPillEffectByName("?????")
mod.PICKUP.PILLCOLOR.RABBIT_PILL = Isaac.GetEntitySubTypeByName("Rabbit Pill")

-- Track if the run STARTED as the challenge, instead of being triggered by the quest.
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, isContinued)
    if not isContinued and game.Challenge == mod.challenges.followTheRabbit then
        local savedata = FiendFolio.savedata
        if savedata and savedata.run then
            savedata.run.isTrueFollowTheRabbitChallenge = true
        end
    end
end)

-- Replaces trapdoors with void portals from Depths II onwards
mod:AddCallback(ModCallbacks.MC_PRE_GRID_ENTITY_SPAWN, function(_, gType, gVariant, vardata, gridIdx, seed, desc)
    if game.Challenge == mod.challenges.followTheRabbit and game:GetLevel():GetStage() >= LevelStage.STAGE3_2 then
        return {gType, 1, 1, seed}
    end
end, GridEntityType.GRID_TRAPDOOR)

-- While the challenge is active, make sure one (and only one) rabbit persists, unless it is killed.
local CHECK_WHITE_RABBITS = false
local function FixWhiteRabbits()
    local savedata = FiendFolio.savedata
    if savedata and savedata.run and (savedata.run.isTrueFollowTheRabbitChallengeAndTheRabbitIsDEAD or savedata.run.followTheRabbitSpawnedPill or savedata.run.followTheRabbitFadeoutDelay) then
        return
    end
    local rabbits = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.WHITE_RABBIT)
    if #rabbits == 0 then
        local player = Isaac.GetPlayer()
        player:AddNullItemEffect(mod.ITEM.NULL.ANNOYING_WHITE_RABBIT)
        player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS, true)
    elseif #rabbits > 1 then
        for i, fam in ipairs(rabbits) do
            if i > 1 then
                if fam.Player then
                    local eff = fam.Player:GetEffects()
                    eff:RemoveNullEffect(mod.ITEM.NULL.ANNOYING_WHITE_RABBIT, eff:GetNullEffectNum(mod.ITEM.NULL.ANNOYING_WHITE_RABBIT))
                else
                    fam:Remove()
                end
            end
        end
    end
end

-- Check if the rabbit pill exists.
local function FindRabbitPill()
    if #Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, mod.PICKUP.PILLCOLOR.RABBIT_PILL) > 0 then
        return true
    end
    for _, player in ipairs(PlayerManager.GetPlayers()) do
        for slot=0,3 do
            if player:GetPill(slot) == mod.PICKUP.PILLCOLOR.RABBIT_PILL then
                return true
            end
        end
    end
    return false
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    if game.Challenge == mod.challenges.followTheRabbit then
        if CHECK_WHITE_RABBITS then
            FixWhiteRabbits()
            CHECK_WHITE_RABBITS = false
        end
        local savedata = FiendFolio.savedata
        if savedata and savedata.run then
            if savedata.run.followTheRabbitFadeoutDelay then
                savedata.run.followTheRabbitFadeoutDelay = savedata.run.followTheRabbitFadeoutDelay - 1
                if savedata.run.followTheRabbitFadeoutDelay <= 0 then
                    savedata.run.followTheRabbitFadeoutDelay = nil
                    game:FinishChallenge()
                end
            elseif savedata.run.followTheRabbitSpawnedPill and not FindRabbitPill() and not savedata.run.followTheRabbitFailsafe then
                -- FAILSAFE, if the rabbit pill disappears without being used.
                savedata.run.followTheRabbitFailsafe = true
                if not FiendFolio.ACHIEVEMENT.INABA:IsUnlocked(true) then
                    FiendFolio.ACHIEVEMENT.INABA:Unlock(true, true)
                    FiendFolio.justUnlockedInaba = true
                end
                for _, player in ipairs(PlayerManager.GetPlayers()) do
                    player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/inaba_ears.anm2"))
                end
                game:FinishChallenge()
            end
        end
    end
end)
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, function()
    if FiendFolio.justUnlockedInaba and game.Challenge == mod.challenges.followTheRabbit then
        local rgonachievement = Isaac.GetAchievementIdByName("FF_INABA")
        if rgonachievement > 0 then
            -- Force the paper to appear
            Isaac.ExecuteCommand("lockachievement " .. rgonachievement)
            Isaac.GetPersistentGameData():Unlock(rgonachievement, false)
        end
        FiendFolio.justUnlockedInaba = nil
    end
end)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    if game.Challenge == mod.challenges.followTheRabbit then
        FixWhiteRabbits()
    end
end)
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, fam)
    if fam.Variant == mod.ITEM.FAMILIAR.WHITE_RABBIT then
        CHECK_WHITE_RABBITS = true
    end
end, EntityType.ENTITY_FAMILIAR)
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function()
    CHECK_WHITE_RABBITS = true
end, mod.ITEM.FAMILIAR.WHITE_RABBIT)

local function isMechaSatanMarkAchieved(playertype)
	local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, playertype)
	local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(playertype):IsTainted() and "-Tainted") or "")
    return FiendFolio.savedata.mechaSatanCompletion[saveID] and FiendFolio.savedata.mechaSatanCompletion[saveID] > 0
end

-- Spawn the rabbit in the super secret room of the first floor when conditions are met
local function CanTriggerInabaQuest()
    local level = game:GetLevel()

    local canLock, canUnlockAchievements = FiendFolio.AreAchievementsEnabled()

    canLock = true  -- IGNORE achievements being disabled. At least initially. Could remove later alongside the exception made for inaba in `achievements/repentogon.lua`

    if level:GetStage() == LevelStage.STAGE1_1 and level:GetStageType() <= StageType.STAGETYPE_AFTERBIRTH and canLock and canUnlockAchievements then
		return not mod.ACHIEVEMENT.INABA:IsUnlocked(true)
            and mod.ACHIEVEMENT.FIEND:IsUnlocked()
            and mod.ACHIEVEMENT.GOLEM:IsUnlocked()
            and mod.ACHIEVEMENT.FRIEND:IsUnlocked()
			and (isMechaSatanMarkAchieved(FiendFolio.PLAYER.FIEND) or isMechaSatanMarkAchieved(FiendFolio.PLAYER.BIEND))
			and (isMechaSatanMarkAchieved(FiendFolio.PLAYER.GOLEM) or isMechaSatanMarkAchieved(FiendFolio.PLAYER.BOLEM))
			and (isMechaSatanMarkAchieved(FiendFolio.PLAYER.FRIEND) or isMechaSatanMarkAchieved(FiendFolio.PLAYER.BRIEND))
            and Isaac.GetPersistentGameData():Unlocked(Achievement.DELIRIOUS)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    if CanTriggerInabaQuest() then
        local rooms = Game():GetLevel():GetRooms()
        for i = 0, rooms.Size-1 do
            local room = rooms:Get(i)
            if room.Data and room.Data.Type == RoomType.ROOM_SUPERSECRET then
                if StageAPI.GetLevelRoom(room.ListIndex, dimension) then
                    StageAPI.SetLevelRoom(nil, room.ListIndex, dimension)
                end
                -- TODO: Replace with a specific custom room, then remove the MC_PRE_ROOM_ENTITY_SPAWN callback below.
                room.Data = RoomConfig.GetRoomByStageTypeAndVariant(StbType.SPECIAL_ROOMS, RoomType.ROOM_SUPERSECRET, 3)
            end
        end
    end
end)
-- TEMP: Lazy temporary way to set up the rabbit room, this should be replaced with a custom room.
-- TODO: Remove this when the rabbit has a custom room
mod:AddCallback(ModCallbacks.MC_PRE_ROOM_ENTITY_SPAWN, function(_, id, var, subt, idx, seed)
    if id == EntityType.ENTITY_SLOT and idx == 67 and CanTriggerInabaQuest() then
        local room = game:GetRoom()
        if room:GetType() == RoomType.ROOM_SUPERSECRET then
            local roomData = game:GetLevel():GetCurrentRoomDesc().Data
            if roomData and roomData.Variant == 3 then
                return {EntityType.ENTITY_PICKUP, mod.PICKUP.VARIANT.ANNOYING_WHITE_RABBIT_IDLE, 0}
            end
        end
    end
end)

-- Trigger the ending events when the player touches the trophy
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, collider)
    if collider:ToPlayer() then
        if game.Challenge == mod.challenges.followTheRabbit then
            local rabbit = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.WHITE_RABBIT)[1]
            if rabbit then
                mod:GetEntityData(rabbit).state = "eattrophy"
                return false
            end
        end
    end
end, PickupVariant.PICKUP_TROPHY)

-- Hide the delirium target on the HUD.
local QUEST_SPRITE = Sprite()
QUEST_SPRITE:Load("gfx/ui/inaba_quest_icon.anm2", true)
QUEST_SPRITE:Play("Destination")
mod:AddCallback(ModCallbacks.MC_POST_HUD_RENDER, function()
    local trueChallenge = mod.savedata and mod.savedata.run and mod.savedata.run.isTrueFollowTheRabbitChallenge
    if game.Challenge == mod.challenges.followTheRabbit and not trueChallenge and game:GetLevel():GetStage() ~= LevelStage.STAGE7 and game:GetHUD():IsVisible() then
        local hudPos = Vector(Options.HUDOffset * 20, Options.HUDOffset * 12) + Vector(0, 6)
        local iconOffset = Vector(16, 72) + Vector(8, 3)
        QUEST_SPRITE:Render(hudPos + iconOffset)
    end
end)

-- Protect the RABBIT PILL
mod:AddPriorityCallback(ModCallbacks.MC_POST_PICKUP_SELECTION, CallbackPriority.IMPORTANT, function(_, pickup, var, subt, requestedVariant, requestedSubtype, rng)
    if requestedVariant == PickupVariant.PICKUP_PILL and requestedSubtype == mod.PICKUP.PILLCOLOR.RABBIT_PILL then
        return {requestedVariant, requestedSubtype}
    end
end)
mod:AddPriorityCallback(ModCallbacks.MC_PRE_PICKUP_MORPH, CallbackPriority.IMPORTANT, function(_, pickup)
    if pickup.Variant == PickupVariant.PICKUP_PILL and pickup.SubType == mod.PICKUP.PILLCOLOR.RABBIT_PILL then
        return false
    end
end)
mod:AddPriorityCallback(ModCallbacks.MC_GET_PILL_EFFECT, CallbackPriority.IMPORTANT, function(_, pillEffect, pillColor)
    if pillColor % 2048 == mod.PICKUP.PILLCOLOR.RABBIT_PILL then
        return mod.ITEM.PILL.RABBIT_PILL
    end
end)
mod:AddCallback(ModCallbacks.MC_USE_PILL, function(_, pillEffect, player, flags, pillColor)
    if pillEffect == mod.ITEM.PILL.RABBIT_PILL or pillColor == mod.PICKUP.PILLCOLOR.RABBIT_PILL then
        local savedata = FiendFolio.savedata
        if game.Challenge == mod.challenges.followTheRabbit then
            if not FiendFolio.ACHIEVEMENT.INABA:IsUnlocked(true) then
                FiendFolio.ACHIEVEMENT.INABA:Unlock(true, true)
                if savedata and savedata.run then
                    FiendFolio.justUnlockedInaba = true
                end
            end
            Isaac.ClearChallenge(mod.challenges.followTheRabbit)
        end
        sfx:Play(SoundEffect.SOUND_POWERUP_SPEWER)
        player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/inaba_ears.anm2"))
        if game.Challenge == mod.challenges.followTheRabbit then
            if savedata and savedata.run then
                savedata.run.followTheRabbitFadeoutDelay = 240
            else
                game:FinishChallenge()
            end
        end
    end
end)

-- Rabbit familiar stuff
local RStats = {
    BASE_SPEED = 10,
    SPEED_LOGVAL = 1000,
    SPEED_DOUBLE_CHANCE = 20, --1 / val
    FUN_ODDS_INCREASE = 6, --double chance / odds increase

    MIN_WAIT_TIME = 30, --time before choosing a new walktarg
    MAX_WAIT_TIME = 400, --Guarantees a new walktarg

    PAIN_WAIT = 200, --time before stopping running away

    BOMBS_TO_KILL = 2,

    PICKUP_BOREDNESS_COUNT = 60, --After holding a pickup for this many frames, can become bored
    PICKUP_INTEREST_COUNT = 120, --How many frames needed until it might become interested in pickups
}

local RidleyPickups = {
    [PickupVariant.PICKUP_BIGCHEST] = true,
    [PickupVariant.PICKUP_BED] = true,
    [PickupVariant.PICKUP_MOMSCHEST] = true,
}

local PickupPriorities = {
    [PickupVariant.PICKUP_PILL] = 100,
}

local function findNearestPickup(fam)
    local famPos = fam.Position
    local dist = 999999
    local closestPickup
    local currentPriority = -500
    for _, pickup in pairs(Isaac.FindByType(5, -1, -1, false, false)) do
        if not RidleyPickups[pickup.Variant] then
            local newDist = pickup.Position:Distance(famPos)
            local prioritisedAlready
            if closestPickup then
                local newPriority = PickupPriorities[pickup.Variant]
                if newPriority and newPriority > currentPriority then
                    currentPriority = newPriority
                    closestPickup = pickup
                    dist = newDist
                    prioritisedAlready = true
                end
            end

            if newDist < dist then
                closestPickup = pickup
                dist = newDist
            end
        end
    end
    if closestPickup then
        return closestPickup.Position
    end
end

local function findDoor(player, rng)
    local doors = {}
    for i = 0, DoorSlot.NUM_DOOR_SLOTS - 1, 1 do
        local door = game:GetRoom():GetDoor(i)
        if door then
            table.insert(doors, door)
        end
    end
    if #doors > 0 then
        return doors[rng:RandomInt(#doors) + 1].Position
    end
end

local function tryFlipPickupBoredness(cap, rng, d)
    d.pickupHeldCount = d.pickupHeldCount or 0
    d.pickupHeldCount = d.pickupHeldCount + 1
    if d.pickupHeldCount > cap and rng:RandomInt(50) == 0 then
        d.boredOfPickups = not d.boredOfPickups
        d.pickupHeldCount = 0
    end
end

local rabbitSlots = {
    [SlotVariant.SLOT_MACHINE] = true,
    [SlotVariant.FORTUNE_TELLING_MACHINE] = true,
    [SlotVariant.SHOP_RESTOCK_MACHINE] = true,
    [SlotVariant.CRANE_GAME] = true,
    [mod.FF.GoldenSlotMachine.Var] = true,
    [mod.FF.RobotTeller.Var] = true,
    [mod.FF.DiceDispenser.Var] = true,
    [mod.FF.PennyPress.Var] = true,
    [mod.FF.MilkFlavorContainer.Var] = true,
    [mod.FF.MilkQualityModulator.Var] = true,
    [mod.FF.VendingMachine.Var] = true,
    [mod.FF.VendingMachineFF.Var] = true,
}

local function FindClosestSlotMachine(pos,path)
	local radius = 99999
	local target = nil
	for index,entity in ipairs(Isaac.FindByType(6, -1, -1, false, false)) do
        if rabbitSlots[entity.Variant] then
			local distance = pos:Distance(entity.Position)
			if distance < radius then
				if path:HasPathToPos(entity.Position, false) then
					radius = distance
					target = entity
				end
			end
		end
	end
	return target
end

local PlaceRabbitsHere = nil

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, fam)
	local sprite = fam:GetSprite()
	local d = mod:GetEntityData(fam)
	local path = fam:GetPathfinder()
    local rng = fam:GetDropRNG()
    local player = fam.Player
    local room = game:GetRoom()

    fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
    fam.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL

    local inNewRoom = (room:GetFrameCount() == 0)
    if not d.StateFrame or inNewRoom then
        d.StateFrame = 0
        if not d.state or (d.state and d.state == "hurt") then
		    d.state = "idle"
        end
        d.walktarg = nil
		d.init = true
        fam.Keys = 0
        if inNewRoom then
            local posAttempt = room:FindFreePickupSpawnPosition(player.Position + RandomVector()*20, 40, true)
            if path:HasPathToPos(posAttempt, false) and rng:RandomInt(10) ~= 1 then
                fam.Position = posAttempt
            else
                fam.Position = mod:FindRandomValidPathPosition(fam, nil, nil, nil, nil, nil, path)
            end
        end
	else
		d.StateFrame = d.StateFrame + 1
	end

    if fam.FrameCount > 0 then
        PlaceRabbitsHere = fam.Position
    elseif game:GetFrameCount() == 0 then
        fam.Position = Game():GetRoom():GetCenterPos()
        return
    elseif PlaceRabbitsHere then
        fam.Position = PlaceRabbitsHere
    end

    if d.state == "atetrophy" then
        fam.Velocity = mod:Lerp(fam.Velocity, mod.nilvector, 0.3)
        if d.StateFrame > 60 then
            local blood = Isaac.Spawn(1000,77,0,fam.Position,Vector.Zero,fam)
            blood:Update()
            for i = 1, 10 do
                local gib = Isaac.Spawn(1000,5,0,fam.Position,RandomVector():Resized(rng:RandomFloat() * 5),fam)
            end
            sfx:Play(SoundEffect.SOUND_DEATH_BURST_LARGE)
            game:ShakeScreen(15)
            player:GetEffects():RemoveNullEffect(mod.ITEM.NULL.ANNOYING_WHITE_RABBIT, 1)
            d.isDead = true
            fam:Remove()
            if game.Challenge == mod.challenges.followTheRabbit then
                local savedata = FiendFolio.savedata
                if savedata and savedata.run then
                    savedata.run.followTheRabbitSpawnedPill = true
                end
            end
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, mod.PICKUP.PILLCOLOR.RABBIT_PILL, fam.Position, mod.nilvector, nil)
        end
    elseif d.state == "hurt" then
        if d.StateFrame < 5 and d.StateFrame % 2 == 0 then
            mod:applyFakeDamageFlash(fam)
        end
        if fam.Keys >= RStats.BOMBS_TO_KILL then
            local blood = Isaac.Spawn(1000,77,0,fam.Position,Vector.Zero,fam)
            blood:Update()
            for i = 1, 10 do
                local gib = Isaac.Spawn(1000,5,0,fam.Position,RandomVector():Resized(rng:RandomFloat() * 5),fam)
            end
            sfx:Play(SoundEffect.SOUND_DEATH_BURST_LARGE)
            game:ShakeScreen(15)
            player:GetEffects():RemoveNullEffect(mod.ITEM.NULL.ANNOYING_WHITE_RABBIT, 1)
            d.isDead = true
            fam:Remove()
            if game.Challenge == mod.challenges.followTheRabbit then
                local savedata = FiendFolio.savedata
                if savedata and savedata.run and savedata.run.isTrueFollowTheRabbitChallenge then
                    savedata.run.isTrueFollowTheRabbitChallengeAndTheRabbitIsDEAD = true
                    Isaac.GetPlayer():UseActiveItem(CollectibleType.COLLECTIBLE_PLAN_C, UseFlag.USE_NOANIM)
                    for _, player in ipairs(PlayerManager.GetPlayers()) do
                        player:SetPlanCKillCountdown(90)
                    end
                else
                    game.Challenge = Challenge.CHALLENGE_NULL
                end
            end
        else
            mod:spritePlay(sprite, "Walk")
            local targetvel = (player.Position - fam.Position):Resized(-10)
            fam.Velocity = mod:Lerp(fam.Velocity, targetvel,0.2)

            if d.StateFrame > RStats.PAIN_WAIT then
                d.StateFrame = 0
                d.state = "idle"
                d.walktarg = nil
                d.init = true
            end
        end
    elseif d.state == "eattrophy" then
        local trophy = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TROPHY)[1]
        if not trophy then
            d.StateFrame = 0
            d.state = "idle"
            d.walktarg = nil
            d.init = true
        elseif trophy.Position:Distance(fam.Position) < 20 then
            d.StateFrame = 0
            d.state = "atetrophy"
            trophy:Remove()
            sfx:Play(mod.Sounds.Monch, 1, 0, false, rng:RandomInt(70,120)/100)
        else
            local trophyPos = trophy.Position
            local speed = mod:Lerp(fam.Velocity:Length(), RStats.BASE_SPEED * 2, 0.2)
            if room:CheckLine(fam.Position,trophyPos,0,1,false,false) then
                local targetvel = (trophyPos - fam.Position):Resized(speed)
                fam.Velocity = mod:Lerp(fam.Velocity, targetvel,0.2)
            else
                path:FindGridPath(trophyPos, speed/10, 900, true)
            end
        end
    elseif d.state == "idle" then
        if d.StateFrame > RStats.MAX_WAIT_TIME
        or ((d.StateFrame > RStats.MIN_WAIT_TIME) and (rng:RandomInt(100) == 0))
        or not d.walktarg then
            d.pursuePlayer = nil
            d.foundSlot = nil
            local targetingSomethingFun
            d.funPity = d.funPity or 7
            d.funPity = d.funPity - 1
            if rng:RandomInt(d.funPity) <= 1 then
                d.funPity = 7
                targetingSomethingFun = true
                local foundPos
                if rng:RandomInt(2) == 1 then
                    local slot = FindClosestSlotMachine(fam.Position, path)
                    if slot then
                        d.foundSlot = slot:ToSlot()
                        foundPos = slot.Position
                    end
                end
                if not foundPos and rng:RandomInt(3) == 0 then
                    foundPos = findNearestPickup(fam)
                end
                if not foundPos then
                    if room:IsClear() then
                        if rng:RandomInt(2) == 0 then
                            local door = findDoor(player, rng)
                            if door then
                                local newpos = room:GetClampedPosition(door, 5)
                                if room:IsPositionInRoom(newpos, 5) then
                                    foundPos = newpos
                                end
                            end
                        end
                    else
                        if rng:RandomInt(3) == 0 then
                            local playerAim = FiendFolio.GetCorrectedFiringInput(player)
                            local newpos = room:GetClampedPosition(player.Position + playerAim:Resized(rng:RandomInt(200)), 5)
                            if room:IsPositionInRoom(newpos, 5) then
                                foundPos = newpos
                            end
                            if rng:RandomInt(2) == 1 then
                                d.pursuePlayer = "BlockShots"
                            end
                        end
                    end
                end
                if foundPos then
                    d.walktarg = foundPos
                else
                    --Target player
                    d.walktarg = player.Position
                    if rng:RandomInt(2) == 1 then
                        d.pursuePlayer = true
                    end
                end
            else
			    d.walktarg = mod:FindRandomValidPathPosition(fam, nil, nil, nil, nil, nil, path)
            end
			d.StateFrame = 0
            d.walkspeed = (RStats.BASE_SPEED - math.log(rng:RandomInt(RStats.SPEED_LOGVAL) + 1))
            local doubleChance = RStats.SPEED_DOUBLE_CHANCE
            if targetingSomethingFun then
                doubleChance = math.floor(doubleChance / RStats.FUN_ODDS_INCREASE)
            end
            if rng:RandomInt(doubleChance) == 1 then
                d.walkspeed = d.walkspeed * 2
            end
		end
        if d.pursuePlayer then
            if d.pursuePlayer == "BlockShots" then
                local playerAim = FiendFolio.GetCorrectedFiringInput(player)
                local newpos = room:GetClampedPosition(player.Position + playerAim:Resized(100), 5)
                if room:IsPositionInRoom(newpos, 5) then
                    d.walktarg = newpos
                else
                    d.walktarg = player.Position
                end
            else
                d.walktarg = player.Position
            end
        end
		if fam.Position:Distance(d.walktarg) > 30 then
            d.walkspeed = d.walkspeed or 5
			if room:CheckLine(fam.Position,d.walktarg,0,1,false,false) then
				local targetvel = (d.walktarg - fam.Position):Resized(d.walkspeed)
				fam.Velocity = mod:Lerp(fam.Velocity, targetvel,0.2)
			else
				path:FindGridPath(d.walktarg, d.walkspeed/10, 900, true)
			end
		else
			fam.Velocity = fam.Velocity * 0.8
			d.StateFrame = d.StateFrame + 2
            if d.foundSlot and d.foundSlot:Exists() and d.foundSlot.Type == EntityType.ENTITY_SLOT then
                if d.foundSlot.Position:Distance(fam.Position) < 30 then
                    if d.foundSlot.Variant == SlotVariant.SLOT_MACHINE
                    or d.foundSlot.Variant == SlotVariant.FORTUNE_TELLING_MACHINE
                    or d.foundSlot.Variant == SlotVariant.SHOP_RESTOCK_MACHINE
                    then
                        if d.foundSlot:GetState() == SlotState.IDLE and player:GetNumCoins() > 0 then
                            player:ForceCollide(d.foundSlot)
                            player:AddCoins(-1)
                        end
                    elseif d.foundSlot.Variant == SlotVariant.CRANE_GAME then
                        if d.foundSlot:GetState() == SlotState.IDLE and player:GetNumCoins() >= 5 then
                            player:ForceCollide(d.foundSlot)
                            player:AddCoins(-5)
                        end
                    else
                        player:ForceCollide(d.foundSlot)
                    end
                end
            else
                d.foundSlot = nil
            end
		end
	end
	if fam.Velocity:Length() > 0.5 then
		mod:spritePlay(sprite, "Walk")
        if math.abs(fam.Velocity.X) > 1 then
            if fam.Velocity.X < 0 then
                sprite.FlipX = true
            else
                sprite.FlipX = false
            end
        end
	else
		mod:spritePlay(sprite, "Idle")
	end

    for _, tear in pairs(Isaac.FindInRadius(fam.Position, fam.Size, EntityPartition.TEAR))  do
        if tear.Type == 2 then
            tear:Die()
        end
    end

    --Laser blocking code
    --I'm lazy so mostly stole it from psi hunter
    mod.scheduleForUpdate(function()
		for _, laser in pairs(Isaac.FindByType(7, 1, -1, false, false)) do

			laser = laser:ToLaser()
            if laser.SpawnerEntity and (laser.SpawnerEntity.Type == 1 or laser.SpawnerEntity.Type == 3) then
                local laserVec = laser:GetEndPoint() - (laser.Position + laser.PositionOffset)
                if (laser.Position + laserVec:Normalized()):Distance(fam.Position) < laser.Position:Distance(fam.Position) then
                    local beingHit
                    if math.abs(math.abs(laser.Position.X) - math.abs(fam.Position.X)) < 30 and math.abs(laserVec.Y) > math.abs(laserVec.X) then
                        beingHit = true
                    elseif math.abs(math.abs(laser.Position.Y) - math.abs(fam.Position.Y)) < 30 and math.abs(laserVec.X) > math.abs(laserVec.Y)then
                        beingHit = true
                    end
                    if beingHit and not d.isDead then
                        if not mod:GetEntityData(laser).hittingPsiHunter then
                            mod:GetEntityData(laser).hittingPsiHunter = laser.MaxDistance
                        end
                        local lengthcalc = (fam.Position - laser.Position):Length()
                        lengthcalc = math.max(1,lengthcalc)
                        --print(lengthcalc)
                        if mod:GetEntityData(laser).hittingPsiHunter > 0 then
                            laser:SetMaxDistance(math.min(lengthcalc, mod:GetEntityData(laser).hittingPsiHunter))
                        else
                            laser:SetMaxDistance(lengthcalc)
                        end
                        laser:Update()

                        if mod:GetEntityData(laser).hittingPsiHunter and (lengthcalc < mod:GetEntityData(laser).hittingPsiHunter or mod:GetEntityData(laser).hittingPsiHunter == 0) then
                            if sprite:IsFinished("Shield") then
                                mod:spritePlay(sprite, "Shielded")
                            elseif not sprite:IsPlaying("Shielded") then
                                mod:spritePlay(sprite, "Shield")
                            end
                            if laser.Position.X < fam.Position.X then
                                sprite.FlipX = true
                            else
                                sprite.FlipX = false
                            end
                            fam.Velocity = fam.Velocity + laserVec:Resized(1)

                            local vec = (laserVec * -1):Rotated(-90 + math.random(180)):Resized(math.random(10,15))
                            local brimDrops = Isaac.Spawn(1000, 70, 0, laser:GetEndPoint(), vec, nil):ToEffect()
                            brimDrops.FallingAcceleration = 1.3
                            brimDrops.FallingSpeed = -3
                            brimDrops.PositionOffset = Vector(vec.X, math.abs(vec.Y) * -1)
                            brimDrops:Update()
                        end
                    else
                        if mod:GetEntityData(laser).hittingPsiHunter then
                            laser:SetMaxDistance(mod:GetEntityData(laser).hittingPsiHunter)
                            mod:GetEntityData(laser).hittingPsiHunter = nil
                            laser:Update()
                        end
                    end
                end
            end
		end
	end, 1, ModCallbacks.MC_POST_UPDATE)

    if d.state ~= "hurt" then
        local partitions = {
            EntityPartition.ENEMY,
            EntityPartition.PLAYER,
            EntityPartition.FAMILIAR,
        }

        local yummyFamiliars = {
            [FamiliarVariant.BLUE_FLY] = true,
            [FamiliarVariant.BLUE_SPIDER] = true,
            [FamiliarVariant.LEPROSY] = true,
            [mod.ITEM.FAMILIAR.ATTACK_SKUZZ] = true,
            [mod.ITEM.FAMILIAR.BLUE_BEETLE] = true,
            [mod.ITEM.FAMILIAR.FAIRY_FLY_1] = true,
            [mod.ITEM.FAMILIAR.FRAGILE_BOBBY] = true,
            [mod.ITEM.FAMILIAR.MORBID_CHUNK] = true,
            [mod.ITEM.FAMILIAR.MINI_LEVEL_0_FLY] = true,
        }

        for i = 1, #partitions do
            for _, entity in pairs(Isaac.FindInRadius(fam.Position, fam.Size, partitions[i]))  do
                if entity.Type == EntityType.ENTITY_FAMILIAR then
                    if yummyFamiliars[entity.Variant] then
                        if entity.Variant == mod.ITEM.FAMILIAR.FRAGILE_BOBBY then
                            sfx:Play(mod.Sounds.GnawfulBite, 1, 0, false, rng:RandomInt(90,110)/100)
                            sfx:Play(mod.Sounds.Monch, 0.25, 0, false, rng:RandomInt(50,60)/100)
                            sfx:Play(mod.Sounds.MeatySquish, 0.2, 0, false, rng:RandomInt(60,80)/100)
                        else
                            sfx:Play(mod.Sounds.Monch, 0.5, 0, false, rng:RandomInt(70,120)/100)
                        end
                        entity:Remove()
                    end
                else
                    local dist = fam.Size - entity.Position:Distance(fam.Position)
                    local vec = (entity.Position - fam.Position) * 0.1
                    entity.Velocity = entity.Velocity + vec
                    fam.Velocity = fam.Velocity - vec
                end
            end
        end
    end
    if d.boredOfPickups then
        tryFlipPickupBoredness(RStats.PICKUP_INTEREST_COUNT, rng, d)
    else
        local grabbingPickup
        for _, entity in pairs(Isaac.FindInRadius(fam.Position, fam.Size, EntityPartition.PICKUP)) do
            local pickup = entity:ToPickup()
            if pickup
            and pickup.EntityCollisionClass > EntityCollisionClass.ENTCOLL_NONE
            then
                if pickup:IsShopItem() then
                    if pickup.Price > 0 then
                        local playerGot = Isaac.GetPlayer()
                        local coins = playerGot:GetNumCoins()
                        if coins >= pickup.Price then
                            playerGot:AddCoins(-pickup.Price)
                            pickup.Price = 0
                            sfx:Play(SoundEffect.SOUND_CASH_REGISTER)
                            grabbingPickup = true
                        end
                    end
                else
                    grabbingPickup = true
                    local vec = (fam.Position - pickup.Position) * 0.1
                    pickup.Velocity = pickup.Velocity + vec
                    if pickup.Variant == PickupVariant.PICKUP_PILL then
                        local isHorsePill = pickup.SubType & PillColor.PILL_GIANT_FLAG > 0
                        if isHorsePill then
                            sfx:Play(SoundEffect.SOUND_POWERUP_SPEWER_AMPLIFIED, 0.3, 0, false, 1.5)
                        else
                            sfx:Play(SoundEffect.SOUND_POWERUP_SPEWER, 0.3, 0, false, 1.5)
                        end
                        pickup:GetSprite():Play("Collect", true)
                        pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                        pickup:Die()
                    end
                    if pickup.Variant == 100 then
                        if fam.Velocity:Length() > 1 then
                            pickup.TargetPosition = pickup.Position + fam.Velocity
                            local smoke = Isaac.Spawn(1000, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, pickup.Position, (pickup.Velocity * -0.3):Rotated(-20 + math.random(40)), pickup):ToEffect()
                            smoke.Color = Color(1,1,1,1,0.3,0.3,0.3)
                            smoke:Update()
                        end
                    end
                end
            end
        end
        if grabbingPickup then
            tryFlipPickupBoredness(RStats.PICKUP_BOREDNESS_COUNT, rng, d)
        else
            d.pickupHeldCount = d.pickupHeldCount or 0
            if d.pickupHeldCount > 0 then
                d.pickupHeldCount = d.pickupHeldCount - 1
            end
        end
    end

    --Poop
    if fam.FrameCount % 30 == 0 and rng:RandomInt(1000) == 1 then
        local offset = fam:GetNullOffset("butthole")
        local shootVec = offset:Resized(rng:RandomFloat() * 5)
        local poop = Isaac.Spawn(5,42,rng:RandomInt(5) == 1 and 1 or 0, fam.Position + offset, shootVec:Rotated(-10 + rng:RandomInt(21)), fam)
        for i = 1, rng:RandomInt(5) + 1 do
            local targetposition = fam.Position + shootVec + mod:TrueRandomVector(rng):Resized(mod:RandomInt(3,5))
            local effect = Isaac.Spawn(1000, EffectVariant.BLOOD_DROP, 0, fam.Position + offset, (targetposition-fam.Position):Resized(10*0.2+mod:getRoll(30,55,rng)/10):Rotated(mod:getRoll(-30,30,rng)), fam):ToEffect()
            effect.Color = FiendFolio.ColorPoop
            effect.Scale = 0.5
            effect.PositionOffset = Vector(0, -20-mod:RandomInt(1, 10))
            effect:Update()
            effect.FallingSpeed = -mod:getRoll(6,10,rng)
        end
        sfx:Play(SoundEffect.SOUND_FART, 0.4, 0, false, 1.5)
        sfx:Play(SoundEffect.SOUND_LITTLE_SPIT, 0.4, 0, false, 1.5)
    end
end, mod.ITEM.FAMILIAR.WHITE_RABBIT)

mod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, function(_, f, c)

end, mod.ITEM.FAMILIAR.WHITE_RABBIT)

mod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_UPDATE, function(_, f, c)
    f:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
end, mod.ITEM.FAMILIAR.WHITE_RABBIT)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
	local sprite = pickup:GetSprite()
    mod:spritePlay(sprite, "Idle")
    pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
end, mod.PICKUP.VARIANT.ANNOYING_WHITE_RABBIT_IDLE)

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, collider)
    if collider.Type == EntityType.ENTITY_PLAYER then
        local player = collider:ToPlayer()
        PlaceRabbitsHere = pickup.Position
        player:AddNullItemEffect(mod.ITEM.NULL.ANNOYING_WHITE_RABBIT)
        player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS, true)
        pickup:Remove()
        if game.Challenge == Challenge.CHALLENGE_NULL then
            game.Challenge = mod.challenges.followTheRabbit
        end
    end
end, mod.PICKUP.VARIANT.ANNOYING_WHITE_RABBIT_IDLE)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, flag)
    local itemconfig = Isaac.GetItemConfig()
    local rabbits = player:CheckFamiliarEx(mod.ITEM.FAMILIAR.WHITE_RABBIT, player:GetEffects():HasNullEffect(mod.ITEM.NULL.ANNOYING_WHITE_RABBIT) and 1 or 0, player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.DUMB_BUNNY), itemconfig:GetNullItem(mod.ITEM.NULL.ANNOYING_WHITE_RABBIT))
    for i = 1, #rabbits do
        if PlaceRabbitsHere then
            rabbits[i].Position = PlaceRabbitsHere
            --rabbits[i]:SetColor(Color(1,1,1,1,1,1,1), 10, 100, true)
        end
    end
end, CacheFlag.CACHE_FAMILIARS)

mod:AddPlayerTempEffectCallback(ModCallbacks.MC_POST_EFFECT_INIT, Isaac.GetItemConfig():GetNullItem(mod.ITEM.NULL.ANNOYING_WHITE_RABBIT), function(_, explosion)
    local level = game:GetLevel()
    local levelNum = level:GetStage()
    if levelNum ~= LevelStage.STAGE7 then
        local fromPlayerBomb = explosion.SpawnerType == EntityType.ENTITY_BOMBDROP and explosion.SpawnerEntity and explosion.SpawnerEntity:ToBomb() and explosion.SpawnerEntity.SpawnerType == EntityType.ENTITY_PLAYER
        if fromPlayerBomb then
            for _, fam in pairs(Isaac.FindInRadius(explosion.Position, 80, EntityPartition.FAMILIAR))  do
                if fam.Variant == mod.ITEM.FAMILIAR.WHITE_RABBIT then
                    local bun = fam:ToFamiliar()
                    bun.Keys = bun.Keys + 1
                    if bun.Keys >= RStats.BOMBS_TO_KILL then
                        sfx:Play(mod.Sounds.InabaHurt, 1, 0, false, 0.2)
                    else
                        sfx:Play(mod.Sounds.InabaHurt, 1, 0, false, mod:RandomInt(40,50)/100)
                    end
                    mod:GetEntityData(bun).state = "hurt"
                    mod:GetEntityData(bun).StateFrame = 0
                end
            end
        end
    end
end, EffectVariant.BOMB_EXPLOSION)

mod:AddPlayerTempEffectCallback(ModCallbacks.MC_POST_NEW_LEVEL, Isaac.GetItemConfig():GetNullItem(mod.ITEM.NULL.ANNOYING_WHITE_RABBIT), function()
    local level = game:GetLevel()
    local levelNum = level:GetStage()
    if levelNum == LevelStage.STAGE7 then
        local room = level:GetCurrentRoom()
        local tl = room:GetTopLeftPos()
        local br = room:GetBottomRightPos()
        Isaac.Spawn(5, FiendFolio.PICKUP.VARIANT.SHOP_CHEST, 0, Vector(tl.X,tl.Y) + Vector(150,  50),Vector.Zero, nil)
        Isaac.Spawn(5, FiendFolio.PICKUP.VARIANT.SHOP_CHEST, 0, Vector(tl.X,br.Y) + Vector(150, -50),Vector.Zero, nil)
        Isaac.Spawn(5, FiendFolio.PICKUP.VARIANT.SHOP_CHEST, 0, Vector(br.X,tl.Y) + Vector(-150, 50),Vector.Zero, nil)
        Isaac.Spawn(5, FiendFolio.PICKUP.VARIANT.SHOP_CHEST, 0, Vector(br.X,br.Y) + Vector(-150,-50),Vector.Zero, nil)
    end
end)