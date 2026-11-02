local mod = FiendFolio
local game = Game()
local map = include("resources.luarooms.ff_bossrush_challenge")
local mapList = StageAPI.RoomsList("FFTheGauntlet", map)
local doOnFirstUpdate

--If you boot the game up, and start gauntlet straight away you're in basement
--So uh, I just... restart the run if that happens

--There was also an issue where sometimes it would work on FIRST entry only
--If you entered a normal run, exited out instantly, and went to gauntlet, it'd also cock up

--So if you make my hacky fix better and less hacky, uh, make sure after you boot the game, both work
if GauntletHasntDoneFirstNewRoom == nil then
    GauntletHasntDoneFirstNewRoom = true
end

mod:AddChallengeCallback(ModCallbacks.MC_POST_GAME_STARTED, FiendFolio.challenges.theGauntlet, function(_, continued)
    doOnFirstUpdate = nil
    if not continued and game.Challenge == FiendFolio.challenges.theGauntlet then
        doOnFirstUpdate = true
        local player = Isaac.GetPlayer()
        player:AddBombs(-1)
        player:AddCoins(3)
        mod.SetChallengeDestinationIcon(mod.DestinationIcon.GAUNTLET)
    end
end)

mod:AddChallengeCallback(ModCallbacks.MC_POST_RENDER, FiendFolio.challenges.theGauntlet, function()
    if doOnFirstUpdate then
        local map = StageAPI.CreateMapFromRoomsList(mapList, nil, {NoChampions = true})
        StageAPI.InitCustomLevel(map, true)
        doOnFirstUpdate = nil
    end

    if game.Challenge == FiendFolio.challenges.theGauntlet then
        local room = game:GetRoom()
        for i = 0, room:GetGridSize() do
            local grid = room:GetGridEntity(i)
            if grid and (grid.Desc.Type == GridEntityType.GRID_TRAPDOOR or grid.Desc.Type == GridEntityType.GRID_STAIRS) then -- i hate you crawlspaces!!
                room:RemoveGridEntity(i, 0, false)
            end
        end

        local currentRoom = StageAPI.GetCurrentRoom()
        if currentRoom and currentRoom.Layout.Name == "Cacophobia Gateway" then
            game:Darken(1, 30)
        end
    end
end)

mod:AddChallengeCallback(ModCallbacks.MC_PRE_MUSIC_PLAY, FiendFolio.challenges.theGauntlet, function(_, id)
    if game.Challenge == FiendFolio.challenges.theGauntlet then
        local level = game:GetLevel()
		local stage = level:GetStage()
		if (stage ~= LevelStage.STAGE2_1 and stage ~= LevelStage.STAGE2_2) or level:GetStageType() ~= StageType.STAGETYPE_WOTL then
			return false
		end
	end
end, Music.MUSIC_CATACOMBS)

mod:AddChallengeCallback(ModCallbacks.MC_USE_ITEM, FiendFolio.challenges.theGauntlet, function()
    if game.Challenge == FiendFolio.challenges.theGauntlet then
        local items = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)
        for _, item in ipairs(items) do
            if item.FrameCount <= 1 then
                game:GetHUD():ShowItemText("Whoops", "Looks like you dropped something!")
                item:Remove()
            end
        end
    end
end, CollectibleType.COLLECTIBLE_BAG_OF_CRAFTING)

mod:AddChallengeCallback("FF_PLAYER_INPUT_ACTION", FiendFolio.challenges.theGauntlet, function(_, player, data, inputHook, action)
    if game.Challenge == FiendFolio.challenges.theGauntlet then
        if action == ButtonAction.ACTION_PILLCARD then
            if player:GetCard(0) == Card.CARD_ACE_OF_HEARTS then
                local room = game:GetRoom()
                if not room:IsClear() then
                    if inputHook == InputHook.GET_ACTION_VALUE then
                        return 0
                    else
                        return false
                    end
                end
            end
        end
    end
end)

mod:AddChallengeCallback(ModCallbacks.MC_POST_NEW_ROOM, FiendFolio.challenges.theGauntlet, function()
    if doOnFirstUpdate and GauntletHasntDoneFirstNewRoom then
        doOnFirstUpdate = nil
        GauntletHasntDoneFirstNewRoom = false
        Isaac.ExecuteCommand('restart') --This is stupid
        return
    end
    if game.Challenge == FiendFolio.challenges.theGauntlet then
        local currentRoom = StageAPI.GetCurrentRoom()
        if currentRoom then
            local sadOnions = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_SAD_ONION)
            local setOnionItem
            if currentRoom.Layout.Name == "Secreter Shop" then
                setOnionItem = FiendFolio.ITEM.COLLECTIBLE.WHITE_PEPPER
            elseif currentRoom.Layout.Name == "How'd You Get Here?" then
                setOnionItem = FiendFolio.ITEM.COLLECTIBLE.FIEND_FOLIO
            end

            if setOnionItem then
                for _, onion in ipairs(sadOnions) do
                    local price = onion:ToPickup().Price
                    onion:ToPickup():Morph(onion.Type, onion.Variant, setOnionItem, true, true, true)
                    onion:ToPickup().AutoUpdatePrice = false
                    onion:ToPickup().Price = price
                end
            end

			-- doing what can't be done using the normal methods cause water/lava/ash enablers/disablers dont work in stageapi rooms
			-- have to handle ashpit this way cause it doesn't seem to respect changing the alt-backdrop flag otherwise
			if REPENTOGON then
				local room = game:GetRoom()
				local roomdesc = game:GetLevel():GetCurrentRoomDesc()
				local seed = room:GetDecorationSeed()
				if seed == 0 then seed = 1 end
				if currentRoom.Layout.Name == "High Amon Gateway" or currentRoom.Layout.Name == "High Amon" then
					roomdesc.Flags = roomdesc.Flags | RoomDescriptor.FLAG_USE_ALTERNATE_BACKDROP
					room:SetBackdropType(BackdropType.ASHPIT, seed)
				end
			end
        end
    end
end)

mod:AddChallengeCallback(ModCallbacks.MC_PRE_BACKDROP_CHANGE, FiendFolio.challenges.theGauntlet, function()
    if game.Challenge == FiendFolio.challenges.theGauntlet then
        local currentRoom = StageAPI.GetCurrentRoom()
        if currentRoom then
			local room = game:GetRoom()
			local roomdesc = game:GetLevel():GetCurrentRoomDesc()

			-- doing what can't be done using the normal methods cause water/lava/ash enablers/disablers dont work in stageapi rooms
			if currentRoom.RoomType == RoomType.ROOM_BOSS and currentRoom.Layout.Name == "New Room (copy)" then
				return BackdropType.ERROR_ROOM
			elseif currentRoom.Layout.Name == "Towards Corpse Bosses" then
				room:SetWaterAmount(0)
				roomdesc.Flags = roomdesc.Flags & ~(RoomDescriptor.FLAG_HAS_WATER | RoomDescriptor.FLAG_USE_ALTERNATE_BACKDROP)
				return BackdropType.CORPSE
			elseif currentRoom.Layout.Name == "Mr Dead Gateway" or currentRoom.Layout.Name == "Mr Dead" then
				room:SetWaterAmount(0)
				roomdesc.Flags = roomdesc.Flags & ~(RoomDescriptor.FLAG_HAS_WATER | RoomDescriptor.FLAG_USE_ALTERNATE_BACKDROP)
				return BackdropType.CORPSE
			elseif currentRoom.Layout.Name == "Baby Bubbles Gateway" or currentRoom.Layout.Name == "Baby Bubbles" then
				room:SetWaterAmount(1)
				roomdesc.Flags = roomdesc.Flags
				return BackdropType.CORPSE3
			end
		end
	end
end)

mod:AddChallengeCallback(ModCallbacks.MC_PRE_GRID_ENTITY_SPAWN, FiendFolio.challenges.theGauntlet, function()
    if game.Challenge == FiendFolio.challenges.theGauntlet then
        local currentRoom = StageAPI.GetCurrentRoom()
        if currentRoom then
			local room = game:GetRoom()
			local roomdesc = game:GetLevel():GetCurrentRoomDesc()

			-- doing what can't be done using the normal methods cause water/lava/ash enablers/disablers dont work in stageapi rooms
			-- haswater gets reset sometime after pre_backdrop_change so here we are
			if currentRoom.Layout.Name == "Towards Mines/Ashpit Bosses" then
				roomdesc.HasWater = false
				currentRoom.HasWaterPits = false
			end
		end
	end
end)

mod:AddChallengeCallback(ModCallbacks.MC_GET_PILL_EFFECT, FiendFolio.challenges.theGauntlet, function()
    if game.Challenge == FiendFolio.challenges.theGauntlet then
        return PillEffect.PILLEFFECT_POWER
    end
end)

-- No heart drops from bosses in this one!!
mod:AddPriorityChallengeCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, CallbackPriority.EARLY, FiendFolio.challenges.theGauntlet, function(_, id, var, sub, pos, vel, spawner, seed)
    if game.Challenge == FiendFolio.challenges.theGauntlet then
        if id == EntityType.ENTITY_PICKUP then
            local room = game:GetRoom()
            local bossRoom = room:GetType() == RoomType.ROOM_BOSS
            local delete
            if bossRoom
            and spawner
            and spawner.Type >= 10
            and (var == PickupVariant.PICKUP_HEART
            or (var >= FiendFolio.PICKUP.VARIANT.IMMORAL_HEART and var <= FiendFolio.PICKUP.VARIANT.IMMORAL_HEART)
            or (var >= FiendFolio.PICKUP.VARIANT.MORBID_HEART and var <= FiendFolio.PICKUP.VARIANT.THIRD_MORBID_HEART))
            then
                delete = true
            end

            if var == PickupVariant.PICKUP_TRINKET
            and sub ~= TrinketType.TRINKET_PERFECTION then
                delete = true
            end

            if (not bossRoom or not room:IsClear()) and game:GetRoom():GetFrameCount() > 0 and (not spawner or spawner.Type ~= EntityType.ENTITY_PLAYER) then
                if var == PickupVariant.PICKUP_BOMB then
                    if #Isaac.FindByType(FiendFolio.FF.Buck.ID, FiendFolio.FF.Buck.Var) == 0 then
                        delete = true
                    end
                elseif var ~= PickupVariant.PICKUP_COLLECTIBLE then
                    delete = true
                else
                    local isBadgeOrReward = sub == FiendFolio.ITEM.COLLECTIBLE.YOUR_ETERNAL_REWARD
                    for _, collect in ipairs(FiendFolio.RewardBadges) do
                        if sub == collect then
                            isBadgeOrReward = true
                            break
                        end
                    end

                    if not isBadgeOrReward then
                        delete = true
                    end
                end
            end

            if var == 370 then --NEVER delete the trophy
                delete = false
            end

            if delete then
                return {
                    1000,
                    StageAPI.E.DeleteMeEffect.V,
                    0,
                    seed
                }
            elseif (var == PickupVariant.PICKUP_HEART and sub == HeartSubType.HEART_GOLDEN) then -- no golden ace of hearts
                return {
                    id,
                    var,
                    HeartSubType.HEART_SOUL
                }
            end
        end
    end
end)

mod:AddChallengeCallback(ModCallbacks.MC_POST_CURSE_EVAL, FiendFolio.challenges.theGauntlet, function()
    if game.Challenge == FiendFolio.challenges.theGauntlet then
        return 0
    end
end)

local badgesNeeded = {
    Ch2 = {FiendFolio.ITEM.COLLECTIBLE.SPATULA_BADGE, FiendFolio.ITEM.COLLECTIBLE.COMMISSIONED_BADGE, FiendFolio.ITEM.COLLECTIBLE.MYSTERY_BADGE},
    Ch3 = {FiendFolio.ITEM.COLLECTIBLE.BABY_BADGE, FiendFolio.ITEM.COLLECTIBLE.DRIPPING_BADGE},
    Ch4 = {FiendFolio.ITEM.COLLECTIBLE.HAUNTED_BADGE}
}

local function hasAllItems(player, list)
    for _, id in ipairs(list) do
        if not player:HasCollectible(id) then
            return false
        end
    end

    return true
end

local badgeDoorStates = {
    Default = "Hidden",
    Hidden = {
        Anim = "Hidden",
        Triggers = {
            EnteredThrough = {
                State = "Opened",
                Anim = "Opened"
            },
            DadsKey = {
                State = "Opened",
                ForcedOpen = true,
                Check = function(door, data, sprite, doorData, doorGridData)
                    local leadsToMap = doorGridData.LevelMapID
                    local leadsTo = doorGridData.LeadsTo
                    local levelMap = StageAPI.LevelMaps[leadsToMap]
                    local leadsToRoom = levelMap:GetRoom(leadsTo)

                    if leadsToRoom then
                        local player = Isaac.GetPlayer()
                        if leadsToRoom.Layout.Name == "How'd You Get Here?" then
                            return hasAllItems(player, badgesNeeded.Ch2)
                        elseif leadsToRoom.Layout.Name == "Take This, You'll Need It" then
                            return hasAllItems(player, badgesNeeded.Ch3)
                        elseif leadsToRoom.Layout.Name == "The Collector's Gambit" then
                            return hasAllItems(player, badgesNeeded.Ch4)
                        end
                    end

                    return true
                end
            }
        }
    },
    Closed = StageAPI.SecretDoorClosedState,
    Opened = StageAPI.SecretDoorOpenedState
}

local badgeDoor = StageAPI.CustomStateDoor("FFGauntletBadgeDoor", "gfx/grid/door_08_holeinwall.anm2", badgeDoorStates, nil, nil, StageAPI.SecretDoorOffsetsByDirection)
local regularDoor = StageAPI.CustomDoor("HIS DOOR", "gfx/grid/door_10_bossroomdoor.anm2")

StageAPI.AddCallback("FiendFolio", "PRE_LEVELMAP_SPAWN_DOOR", 1, function(slot, doorData, levelRoom, targetLevelRoom, roomData, levelMap)
    if game.Challenge == FiendFolio.challenges.theGauntlet then
        local currentRoom = StageAPI.GetCurrentRoom()
        if targetLevelRoom.RoomType == RoomType.ROOM_SECRET then
            StageAPI.SpawnCustomDoor(slot, doorData.ExitRoom, levelMap, "FFGauntletBadgeDoor", nil, doorData.ExitSlot, "Secret")
            return true
        elseif targetLevelRoom.RoomType == RoomType.ROOM_BOSS and targetLevelRoom.Layout.Name == "New Room (copy)" then
            StageAPI.SpawnCustomDoor(slot, doorData.ExitRoom, levelMap, "HIS DOOR", nil, doorData.ExitSlot)
            return true
		elseif currentRoom and currentRoom.RoomType == RoomType.ROOM_BOSS and currentRoom.Layout.Name == "New Room (copy)" then
			return true
        end
    end
end)

local HISDOORFrameTimer = 0
StageAPI.AddCallback("FiendFolio", "POST_SPAWN_CUSTOM_DOOR", 1, function(door, data, sprite, doorData, customGrid, force, respawning)
	local room = game:GetRoom()
	local isClear = room:IsClear()
	StageAPI.SetDoorOpen(data.HISDOORIsForcedOpen or isClear, door)

	if not sprite:IsPlaying("Opened") then
		sprite:Play("Opened", true)
	end
	sprite:SetFrame(HISDOORFrameTimer % 60)

	if forceFadeIn then
		data.HISDOORFade = 0
	elseif isClear or data.DoorGridData.Slot == nextExitDoorSlot then
		data.HISDOORFade = 1
	else
		data.HISDOORFade = 0
	end
	sprite.Color = Color(1, 1, 1, data.HISDOORFade, 0, 0, 0)
end, regularDoor.Name)

StageAPI.AddCallback("FiendFolio", "POST_CUSTOM_DOOR_UPDATE", 1, function(door, data, sprite, doorData, persistData)
	local room = game:GetRoom()
	local isClear = room:IsClear()
	StageAPI.SetDoorOpen(data.HISDOORIsForcedOpen or isClear, door)

	if not sprite:IsPlaying("Opened") then
		sprite:Play("Opened", true)
	end
	sprite:SetFrame(HISDOORFrameTimer % 60)

	if isClear then
		data.HISDOORFade = math.min(data.HISDOORFade + 1/30, 1)
	else
		data.HISDOORFade = math.max(data.HISDOORFade - 1/30, 0)
	end
	sprite.Color = Color(1, 1, 1, data.HISDOORFade, 0, 0, 0)
end, regularDoor.Name)

mod:AddChallengeCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, FiendFolio.challenges.theGauntlet, function(_, p, collider, low)
    if game.Challenge == FiendFolio.challenges.theGauntlet and not p:IsShopItem() then
        return false
    end
end, PickupVariant.PICKUP_BOMB)

mod:AddChallengeCallback(ModCallbacks.MC_POST_PICKUP_INIT, FiendFolio.challenges.theGauntlet, function(_, p)
	-- Lazy quick fix to prevent this from triggering within the gauntlet.
	mod:GetEntityData(p).StageAPIDontCheckThemedDrop = true
end)

--[[
FiendFolio.savedata.gauntletPlaceboCoins = 0

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, p)
    if p.Type == 5 and p.Variant == 20 and game.Challenge == FiendFolio.challenges.theGauntlet then
        --print(p.Price)
        if not (Game():GetRoom():GetType() == 5 and Game():GetRoom():IsClear()) then
            mod:GetEntityData(p).gauntletPlaceboCoin = true
        end
    end
end)

local function gauntletUpdatePrices()
    local pickups = Isaac.FindByType(5, -1, -1, false, false)
    for _, p in ipairs(pickups) do
        p = p:ToPickup()
        if p.Price and p.Price > 0 then
            p.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            for i=1, FiendFolio.savedata.gauntletPlaceboCoins do
                mod.scheduleForUpdate(function()
                    if p:Exists() then
                        p.Price = p.Price+1
                        p.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                    end
                end, 30+(i*3))
            end
            mod.scheduleForUpdate(function()
                if p:Exists() then p.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY end
            end, 30+(FiendFolio.savedata.gauntletPlaceboCoins+1)*3)
        end
    end
    for i=1, FiendFolio.savedata.gauntletPlaceboCoins do
        mod.scheduleForUpdate(function()
            pickups = Isaac.FindByType(5, -1, -1, false, false)
            for _, p in ipairs(pickups) do
                p = p:ToPickup()
                if p.Price and p.Price > 0 then
                    FiendFolio.savedata.gauntletPlaceboCoins = FiendFolio.savedata.gauntletPlaceboCoins-1
                    SFXManager():Play(mod.Sounds.CursedPennyPositive, 1, 0, false, 1)
                    break
                end
            end
        end, 30+(i*3))
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    if game.Challenge == FiendFolio.challenges.theGauntlet then
        local c = 0
        local coins = Isaac.FindByType(5, 20, -1, false, false)
        for _, coin in ipairs(coins) do
            c = c+1
            if c>7 then
                mod:GetEntityData(coin).gauntletPlaceboCoin = true
            end
        end
        --print("p: " .. FiendFolio.savedata.gauntletPlaceboCoins)
        if FiendFolio.savedata.gauntletPlaceboCoins > 0 then
            gauntletUpdatePrices()
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, p, collider, low)
    if game.Challenge == FiendFolio.challenges.theGauntlet and mod:GetEntityData(p).gauntletPlaceboCoin then
        FiendFolio.savedata.gauntletPlaceboCoins = FiendFolio.savedata.gauntletPlaceboCoins + p:GetCoinValue()
    end
end, 20)

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, collider, low)
    if game.Challenge == FiendFolio.challenges.theGauntlet then
        if pickup.Price and pickup.Price > 0 and collider.Type == 1 and collider:ToPlayer():GetNumCoins() >= pickup.Price then
            mod.scheduleForUpdate(function()

                if pickup:Exists() then return end

                local rPrice
                if pickup.Variant == 100 then
                    rPrice = pickup.Price - 15
                elseif pickup.Variant == 10 and pickup.SubType == 1 then
                    rPrice = pickup.Price - 3
                else
                    rPrice = pickup.Price - 5
                end

                local pickups = Isaac.FindByType(5, -1, -1, false, false)
                for _, p in ipairs(pickups) do
                    p = p:ToPickup()
                    if p.Price and p.Price > 0 then
                        p.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                        for i=1, rPrice do
                            mod.scheduleForUpdate(function()
                                if p:Exists() then
                                    p.Price = p.Price-1
                                    p.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                                end
                            end, 5+i)
                        end
                        mod.scheduleForUpdate(function()
                            if p:Exists() then p.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY end
                        end, 5+(rPrice+1))
                    end
                end
            end, 1)
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, function()
    if game.Challenge == FiendFolio.challenges.theGauntlet then
        local pickups = Isaac.FindByType(5, -1, -1, false, false)
        for _, p in ipairs(pickups) do
            p = p:ToPickup()
            if p.Price then
                mod:GetEntityData(p).couponPrevPrice = p.Price
            end
        end
    end
end, 521)

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function()
    if game.Challenge == FiendFolio.challenges.theGauntlet then
        local pickups = Isaac.FindByType(5, -1, -1, false, false)
        for _, p in ipairs(pickups) do
            p = p:ToPickup()
            if p.Price ~= mod:GetEntityData(p).couponPrevPrice then
                local rPrice
                if p.Variant == 100 then
                    rPrice = 15
                elseif p.Variant == 10 and p.SubType == 1 then
                    rPrice = 3
                else
                    rPrice = 5
                end
                FiendFolio.savedata.gauntletPlaceboCoins = FiendFolio.savedata.gauntletPlaceboCoins + rPrice
                gauntletUpdatePrices()
            end
        end
    end
end, 521)]]