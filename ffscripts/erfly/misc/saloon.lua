local mod = FiendFolio
local sfx = SFXManager()
local game = Game()

--Little example callback if anyone needs to disable saloons
--Return true to try forcing it to appear (I'd generally prefer you don't)
--Return false to prevent it from appearing
--[[
mod:AddCallback(FiendFolio.CALLBACK.FF_PRE_SALOON_GENERATE, function()
    if playing_my_cool_character or in_my_cool_challenge then
        return false
    end
end)
]]

--Stealing a lot of code from God's Gambit <3

mod.SaloonRNG = RNG()

function mod:IsSaloonRoom(roomDesc)
    roomDesc = roomDesc or game:GetLevel():GetCurrentRoomDesc()
    if roomDesc and roomDesc.Data then
        if StageAPI.GetLevelRoom(roomDesc.ListIndex, roomDesc:GetDimension()) then
            local levelRoom = StageAPI.GetLevelRoom(roomDesc.ListIndex, roomDesc:GetDimension())
            return levelRoom.RoomType == FiendFolio.SpecialRooms.Saloon.SubType
        end
        return roomDesc.Data.Type == FiendFolio.SpecialRooms.Saloon.RoomType and roomDesc.Data.Subtype == FiendFolio.SpecialRooms.Saloon.SubType
    end
    return false
end

function mod:IsSaloonRoomDoor(door)
    if mod:IsPlayerWithCollectible(mod.ITEM.COLLECTIBLE.TOO_MANY_OPTIONS) then
        return false
    end
    if mod:IsSaloonRoom() and door.TargetRoomType ~= RoomType.ROOM_SECRET and door.TargetRoomType ~= RoomType.ROOM_SUPERSECRET and door.TargetRoomType ~= RoomType.ROOM_ULTRASECRET then
        return true
    elseif door.TargetRoomType == RoomType.ROOM_ISAACS and mod:IsSaloonRoom(game:GetLevel():GetRoomByIdx(door.TargetRoomIndex)) then
        return true
    end
end

--does he know about the d o r e?
mod:AddCallback(ModCallbacks.MC_POST_GRID_ENTITY_DOOR_UPDATE, function(_, door)
    if mod:IsSaloonRoomDoor(door) then
        local sprite, room = door:GetSprite(), game:GetRoom()
        local showOverlay = true
        --print(door.State)
        if room:GetFrameCount() <= 0 then
            local animation = sprite:GetAnimation()
            sprite:Load("gfx/grid/door_saloon_yeehaw.anm2", true)
            if mod.roomBackdrop == 3 then
                for i = 0, 4 do
                    sprite:ReplaceSpritesheet(i, "gfx/grid/pipe_door_saloon_yeehaw.png")
                end
                sprite:LoadGraphics()
            end
            if door:CanBlowOpen() then
                sprite:Play("Closed", true)
                door.State = 4
            else
                sprite:Play("BrokenOpen", true)
                door.State = 2
            end
        end
        --Setting it to State 4 is an easy way to make it only take one hit instead of two
        if door.State == 1 then
            door.State = 4
        end
        if mod:IsPlayerWithCollectible(mod.ITEM.COLLECTIBLE.TOO_MANY_OPTIONS) then
            door.State = 2
        end
        if not door:CanBlowOpen() then
            showOverlay = false
        end
        if showOverlay then
            sprite:SetOverlayFrame("Plank" .. sprite:GetAnimation(), sprite:GetFrame())
        else
            sprite:RemoveOverlay()
        end
        door.ExtraVisible = false
    end
end)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_BACKDROP_CHANGE, CallbackPriority.LATE, function(_, backdropType)
    if mod:IsSaloonRoom() then
        return mod.Backdrops.SALOON
    end
end)

if StageAPI then
    StageAPI.AddCallback("FiendFolio", "PRE_CHANGE_ROOM_GFX", -1, function(currentRoom, usingGfx, onRoomLoad)
        if usingGfx and mod:IsSaloonRoom() then
            return true
        end
    end)
    StageAPI.AddCallback("FiendFolio", "PRE_UPDATE_GRID_GFX", -1, function()
        if game:GetRoom():GetFrameCount() <= 1 and mod:IsSaloonRoom() then
            return true
        end
    end)
end

local function GetLevelStage()
    if StageAPI and StageAPI.GetCurrentStage() then
        local customStage = StageAPI.GetCurrentStage()
        if customStage.StageHPNumber then
            return customStage.StageHPNumber
        elseif customStage.StageNumber then
            return customStage.StageNumber
        else
            return 1
        end
    else
        return game:GetLevel():GetStage()
    end
end

function mod:ShouldSaloonRoomGenerate(levelStage)
    levelStage = levelStage or GetLevelStage()
    return mod.ACHIEVEMENT.SALOON:IsUnlocked() and
    not (game:IsGreedMode()
    or game:GetLevel():IsAscent()
    or levelStage == LevelStage.STAGE1_1 --First Floor
    or levelStage == LevelStage.STAGE4_3 --Blue Womb
    or levelStage == LevelStage.STAGE6 --Chest / Dark Room
    or levelStage == LevelStage.STAGE7 --Void
    or levelStage == LevelStage.STAGE8) --Home
end

function mod:GetSaloonRoomLayout()
    return RoomConfigHolder.GetRandomRoom(mod.SaloonRNG:GetSeed(),true,StbType.SPECIAL_ROOMS,FiendFolio.SpecialRooms.Saloon.RoomType,RoomShape.ROOMSHAPE_1x1,nil,nil,nil,nil,0,FiendFolio.SpecialRooms.Saloon.SubType)
end

function mod:TryGenerateSaloonRooms(levelStage, rng)
    levelStage = levelStage or GetLevelStage()
    rng = rng or mod.SaloonRNG
    local level = game:GetLevel()
    local generatedRooms = false
    local layout = mod:GetSaloonRoomLayout()
    if layout then
        local indexes = level:FindValidRoomPlacementLocations(layout, 0, false, false)
        if #indexes > 0 then
            local index = indexes[rng:RandomInt(#indexes) + 1]
            local room = level:TryPlaceRoom(layout, index, 0, rng:GetSeed(), true, true, true)
            if room then
                --print("Saloon room generated")
                generatedRooms = true

                local overwriteX = index % 13
                local overwriteY = math.floor(index / 13)
                local currentX = level:GetCurrentRoomIndex() % 13
                local currentY = math.floor(level:GetCurrentRoomIndex() / 13)
                local roomDist = math.abs(overwriteX - currentX) + math.abs(overwriteY - currentY)

                if mod.anyPlayerHas(CollectibleType.COLLECTIBLE_SPELUNKER_HAT) and roomDist <= 2 then
                    room.DisplayFlags = RoomDisplayFlags.VISIBLE | RoomDisplayFlags.SHOW_ICON
                elseif roomDist <= 1 then
                    room.DisplayFlags = RoomDisplayFlags.VISIBLE | RoomDisplayFlags.SHOW_ICON
                elseif level:GetStateFlag(LevelStateFlag.STATE_FULL_MAP_EFFECT) then
                    room.DisplayFlags = RoomDisplayFlags.VISIBLE | RoomDisplayFlags.SHOW_ICON
                elseif level:GetStateFlag(LevelStateFlag.STATE_COMPASS_EFFECT) then
                    room.DisplayFlags = RoomDisplayFlags.VISIBLE
                else
                    room.DisplayFlags = 0
                end
                level:UpdateVisibility()
                if MinimapAPI then
                    --Just ensures it's on the map idk
                    MinimapAPI:CheckForNewRedRooms()
                end
            end
        end

    end
    return generatedRooms
end

local SaloonRoomsForced = false

function mod:SaloonRoomRoll()
    local initialChance = 10
    if mod.anyPlayerHas(TrinketType.TRINKET_GOLDEN_HORSE_SHOE, true) then
        initialChance = initialChance - 3
    end
    local roll = mod.SaloonRNG:RandomInt(initialChance)
    return roll
end

function mod:NewFloorSaloonRoomGeneration()
    local levelStage = GetLevelStage()
    mod.SaloonRNG:SetSeed(game:GetSeeds():GetStageSeed(levelStage), 35)
    local callback = Isaac.RunCallback(mod.CALLBACK.FF_PRE_SALOON_GENERATE)
    if (mod:ShouldSaloonRoomGenerate(levelStage)
    and Isaac.GetPlayer():GetNumCoins() >= 10
    and mod:SaloonRoomRoll() == 1)
    and not (callback == false)
    or SaloonRoomsForced
    or callback == true
    then
        --Spawns way too often atm intentionally
        -- Just so people can test with these things
        generatedRooms = mod:TryGenerateSaloonRooms(levelStage)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    mod:NewFloorSaloonRoomGeneration()
end)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, e)
    if mod:IsSaloonRoom() then
        e:Remove()
    end
end, EffectVariant.ISAACS_CARPET)

if MinimapAPI then
mod:AddPriorityCallback(ModCallbacks.MC_POST_RENDER, CallbackPriority.IMPORTANT - 2, function()
	-- Kinda just stealing this from the Curse of the Gate code
    local level = game:GetLevel()
    if level:GetDimension() ~= Dimension.NORMAL then
        return
    end

    local minimapRoom = MinimapAPI:GetRoomByID("FFSaloonYeehaw")
    if not minimapRoom then
        local roomlist = level:GetRooms()

        for i = roomlist:__len() - 1, 0, -1 do
            local room = roomlist:Get(i)
            if mod:IsSaloonRoom(room) then
                minimapRoom = MinimapAPI:GetRoomAtPosition(MinimapAPI:GridIndexToVector(room.GridIndex))
                break
            end
        end
    end

    if minimapRoom then
        minimapRoom.ID = "FFSaloonYeehaw"
        minimapRoom.PermanentIcons = {"FFSaloonYeehaw"}
        minimapRoom.LockedIcons = {"FFSaloonYeehaw"}

        minimapRoom.AdjacentDisplayFlags = 1
        minimapRoom.IgnoreDescriptorFlags = true
        if not minimapRoom.Visited and minimapRoom.DisplayFlags & 4 > 0 and
            not (level:GetStateFlag(LevelStateFlag.STATE_FULL_MAP_EFFECT) or level:GetStateFlag(LevelStateFlag.STATE_COMPASS_EFFECT))
        then
            minimapRoom.DisplayFlags = minimapRoom.DisplayFlags & ~4
        end

        minimapRoom.Color = nil
    end
end)
end

function mod:saloonBucketBreak(gridpos, gridvar, brokenData, customGrid, room, rng)
    --Stop it making pot sounds, make the bucket sound (the old pot sound lol)
    sfx:Stop(SoundEffect.SOUND_POT_BREAK_2, 1)
    sfx:Play(SoundEffect.SOUND_POT_BREAK, 1)

    --Milk projectiles from filled buckets
    if gridvar == 1 then
        for i = 1, mod:RandomInt(4,6) do
            local projectile = mod:LazySpawnProjectile(4, 0, gridpos, Vector.One:Resized(mod:RandomInt(4,6)):Rotated(mod:RandomAngle()), nil):ToProjectile()
            projectile.FallingSpeed = mod:RandomInt(-25,-10)
            projectile.FallingAccel = 1.2
            projectile.Color = mod.ColorBishopWhite
            local d = mod:GetEntityData(projectile)
            d.projType = "Peepisser"
            d.detail = "Milk"
            d.creepTimeout = 90
            d.water = room:HasWater()
            projectile:Update()
        end
    end
    --Random Drops
    local roll = rng:RandomInt(200)
    if roll < 10 then --Penny
        Isaac.Spawn(5,20,0,gridpos,Vector.One:Resized(mod:RandomInt(1,3)):Rotated(mod:RandomAngle()),nil)
    elseif roll < 20 then --2 Pennies
        for i = 1, 2 do
            Isaac.Spawn(5,20,0,gridpos,Vector.One:Resized(mod:RandomInt(1,3)):Rotated(mod:RandomAngle()),nil)
        end
    elseif roll < 25 then --Bone Heart
        Isaac.Spawn(5,PickupVariant.PICKUP_HEART,HeartSubType.HEART_BONE,gridpos,Vector.One:Resized(mod:RandomInt(1,3)):Rotated(mod:RandomAngle()),nil)
    elseif roll < 26 then --Milk Item
        Isaac.Spawn(5,100,436,gridpos,Vector.Zero,nil)
    elseif roll < 51 then --1 Maggot
        local maggot = EntityNPC.ThrowMaggot(gridpos, Vector.One:Resized(mod:RandomInt(1,3)):Rotated(mod:RandomAngle()))
        maggot.MaxHitPoints = 6.5
        maggot.HitPoints = maggot.MaxHitPoints
    elseif roll < 64 then --2 Maggot
        for i = 1, 2 do
            local maggot = EntityNPC.ThrowMaggot(gridpos, Vector.One:Resized(mod:RandomInt(1,3)):Rotated(mod:RandomAngle()))
            maggot.MaxHitPoints = 6.5
            maggot.HitPoints = maggot.MaxHitPoints
        end
    end
end