local mod = FiendFolio
local game = Game()

function mod:SacrificeRoomItem(player)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.DISCIPLINE) then
        local spike = nil
        for i = 0, room:GetGridSize(), 1 do
            local g = room:GetGridEntity(i)
            if g and g:GetType() == GridEntityType.GRID_SPIKES then
                spike = g
            end
        end

        if spike then
            local returnFlight
            for i = 1, 4, 1 do
                --Ensure player can be hit by spikes
                if player.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_GROUND then
                    returnFlight = player.GridCollisionClass
                    player.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
                end
                spike:HurtDamage(player, 1, DamageFlag.DAMAGE_INVINCIBLE | DamageFlag.DAMAGE_FAKE | DamageFlag.DAMAGE_SPIKES, 0, false)
                player:ResetDamageCooldown()
            end
            --If changed, go back to what it was before
            if returnFlight then
                player.GridCollisionClass = returnFlight
            end
        end
    end
end

FiendFolio.AddItemPickupCallback(function(player)
	local room = game:GetRoom()
    local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.RED_NIGHTMARE)
    for i = 1, 1 + rng:RandomInt(3), 1 do
        local p = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_CRACKED_KEY,
			room:FindFreePickupSpawnPosition(player.Position), Vector.Zero, player):ToPickup()
        p:SetDropDelay(i)
    end
end, nil, mod.ITEM.COLLECTIBLE.RED_NIGHTMARE)

--floor gen
--a lot of this is repurpsed TT code, so thanks JD[?]
local adjindexes = {
	[RoomShape.ROOMSHAPE_1x1] = {
		[DoorSlot.LEFT0] = -1,
		[DoorSlot.UP0] = -13,
		[DoorSlot.RIGHT0] = 1,
		[DoorSlot.DOWN0] = 13
	},
	[RoomShape.ROOMSHAPE_IH] = {
		[DoorSlot.LEFT0] = -1,
		[DoorSlot.RIGHT0] = 1
	},
	[RoomShape.ROOMSHAPE_IV] = {
		[DoorSlot.UP0] = -13,
		[DoorSlot.DOWN0] = 13
	},
	[RoomShape.ROOMSHAPE_1x2] = {
		[DoorSlot.LEFT0] = -1,
		[DoorSlot.UP0] = -13,
		[DoorSlot.RIGHT0] = 1,
		[DoorSlot.DOWN0] = 26,
		[DoorSlot.LEFT1] = 12,
		[DoorSlot.RIGHT1] = 14
	},
	[RoomShape.ROOMSHAPE_IIV] = {
		[DoorSlot.UP0] = -13,
		[DoorSlot.DOWN0] = 26
	},
	[RoomShape.ROOMSHAPE_2x1] = {
		[DoorSlot.LEFT0] = -1,
		[DoorSlot.UP0] = -13,
		[DoorSlot.RIGHT0] = 2,
		[DoorSlot.DOWN0] = 13,
		[DoorSlot.UP1] = -12,
		[DoorSlot.DOWN1] = 14
	},
	[RoomShape.ROOMSHAPE_IIH] = {
		[DoorSlot.LEFT0] = -1,
		[DoorSlot.RIGHT0] = 3
	},
	[RoomShape.ROOMSHAPE_2x2] = {
		[DoorSlot.LEFT0] = -1,
		[DoorSlot.UP0] = -13,
		[DoorSlot.RIGHT0] = 2,
		[DoorSlot.DOWN0] = 26,
		[DoorSlot.LEFT1] = 12,
		[DoorSlot.UP1] = -12,
		[DoorSlot.RIGHT1] = 15,
		[DoorSlot.DOWN1] = 27
	},
	[RoomShape.ROOMSHAPE_LTL] = {
		[DoorSlot.LEFT0] = -1,
		[DoorSlot.UP0] = -1,
		[DoorSlot.RIGHT0] = 1,
		[DoorSlot.DOWN0] = 25,
		[DoorSlot.LEFT1] = 11,
		[DoorSlot.UP1] = -13,
		[DoorSlot.RIGHT1] = 14,
		[DoorSlot.DOWN1] = 26
	},
	[RoomShape.ROOMSHAPE_LTR] = {
		[DoorSlot.LEFT0] = -1,
		[DoorSlot.UP0] = -13,
		[DoorSlot.RIGHT0] = 1,
		[DoorSlot.DOWN0] = 26,
		[DoorSlot.LEFT1] = 12,
		[DoorSlot.UP1] = 1,
		[DoorSlot.RIGHT1] = 15,
		[DoorSlot.DOWN1] = 27
	},
	[RoomShape.ROOMSHAPE_LBL] = {
		[DoorSlot.LEFT0] = -1,
		[DoorSlot.UP0] = -13,
		[DoorSlot.RIGHT0] = 2,
		[DoorSlot.DOWN0] = 13,
		[DoorSlot.LEFT1] = 13,
		[DoorSlot.UP1] = -12,
		[DoorSlot.RIGHT1] = 15,
		[DoorSlot.DOWN1] = 27
	},
	[RoomShape.ROOMSHAPE_LBR] = {
		[DoorSlot.LEFT0] = -1,
		[DoorSlot.UP0] = -13,
		[DoorSlot.RIGHT0] = 2,
		[DoorSlot.DOWN0] = 26,
		[DoorSlot.LEFT1] = 12,
		[DoorSlot.UP1] = -12,
		[DoorSlot.RIGHT1] = 14,
		[DoorSlot.DOWN1] = 14
	}
}
local oppslots = {
	[DoorSlot.LEFT0] = DoorSlot.RIGHT0,
	[DoorSlot.UP0] = DoorSlot.DOWN0,
	[DoorSlot.RIGHT0] = DoorSlot.LEFT0,
	[DoorSlot.LEFT1] = DoorSlot.RIGHT0,
	[DoorSlot.DOWN0] = DoorSlot.UP0,
	[DoorSlot.UP1] = DoorSlot.DOWN0,
	[DoorSlot.RIGHT1] = DoorSlot.LEFT0,
	[DoorSlot.DOWN1] = DoorSlot.UP0
}

local function IsRoomDeadEnd(roomIdx)
    local level = game:GetLevel()
    local adjRooms = 0
    local adjindex = adjindexes[RoomShape.ROOMSHAPE_1x1]
    for key, value in pairs(adjindex) do
        if level:GetRoomByIdx(roomIdx+value).GridIndex ~= -1 then
            adjRooms = adjRooms + 1
        end
        if adjRooms > 1 then
            return false
        end
    end
    return true
end

local function GetAllDeadEnds()
	local level = game:GetLevel()
	local floordeadends = {}

	for i = level:GetRooms().Size, 0, -1 do
		local roomdesc = level:GetRooms():Get(i-1)
		if roomdesc then --Subtype checks protect against generation off of Mirror or Mineshaft entrance rooms
			if roomdesc.Data.Type == RoomType.ROOM_DEFAULT and (roomdesc.Data.Subtype ~= 34 and roomdesc.Data.Subtype ~= 10) and roomdesc.Data.Shape == RoomShape.ROOMSHAPE_1x1 then
                if IsRoomDeadEnd(roomdesc.GridIndex) then
                    table.insert(floordeadends, {idx = roomdesc.GridIndex})
                end
			end
		end
	end

    return floordeadends
end

local function updateRoomFlags(roomdesc)
    local level = game:GetLevel()
    roomdesc.Flags = 0
	local roomdata = roomdesc.Data
    if level:GetStateFlag(LevelStateFlag.STATE_FULL_MAP_EFFECT) and roomdata.Type ~= RoomType.ROOM_ULTRASECRET then
        roomdesc.DisplayFlags = RoomDescriptor.DISPLAY_ALL
    elseif roomdata.Type ~= RoomType.ROOM_DEFAULT and roomdata.Type ~= RoomType.ROOM_SECRET and roomdata.Type ~= RoomType.ROOM_SUPERSECRET and roomdata.Type ~= RoomType.ROOM_ULTRASECRET and level:GetStateFlag(LevelStateFlag.STATE_COMPASS_EFFECT) then
        roomdesc.DisplayFlags = RoomDescriptor.DISPLAY_ALL
    elseif roomdata and level:GetStateFlag(LevelStateFlag.STATE_BLUE_MAP_EFFECT) and (roomdata.Type == RoomType.ROOM_SECRET or roomdata.Type == RoomType.ROOM_SUPERSECRET) then
        roomdesc.DisplayFlags = RoomDescriptor.DISPLAY_ALL
    elseif level:GetStateFlag(LevelStateFlag.STATE_MAP_EFFECT) and roomdata.Type ~= RoomType.ROOM_ULTRASECRET then
        roomdesc.DisplayFlags = RoomDescriptor.DISPLAY_BOX
    else
        roomdesc.DisplayFlags = RoomDescriptor.DISPLAY_NONE
    end

    if MinimapAPI then
		local minimaproom = MinimapAPI:GetRoomByIdx(roomdesc.GridIndex)
		if minimaproom then
			minimaproom:SyncRoomDescriptor()
		end
    end
end

mod.DisciplineLevelStageBlacklist = {
    [LevelStage.STAGE8] = true, --Home
}

function mod:MakeNewSacRoomSometimes()
    if mod:RoomTypeCurrentlyExists(RoomType.ROOM_SACRIFICE) then
        return
    end
    local c_rng = Isaac.GetPlayer(0):GetCollectibleRNG(mod.ITEM.COLLECTIBLE.DISCIPLINE)
    if c_rng:RandomFloat() >= 0.33 then
        return
    end
    local level = game:GetLevel()
    local stage = level:GetStage()
    --Don't replace on certain floors
    if mod.DisciplineLevelStageBlacklist[stage] then
        return
    end

    local deadEnds = GetAllDeadEnds()
    mod:Shuffle(deadEnds)

    for key, value in pairs(deadEnds) do
        local newroomdesc = level:GetRoomByIdx(value.idx, 0)
        local seed = math.max(1, level:GetDungeonPlacementSeed())
        local room = RoomConfigHolder.GetRandomRoom(seed, false, StbType.SPECIAL_ROOMS, RoomType.ROOM_SACRIFICE, RoomShape.ROOMSHAPE_1x1)
        newroomdesc.Data = room

        updateRoomFlags(newroomdesc)
        level:UpdateVisibility()
        return
    end
end

--red

local rBlacklist = {
    RoomType.ROOM_SECRET,
    RoomType.ROOM_SUPERSECRET,
    RoomType.ROOM_ULTRASECRET,
    RoomType.ROOM_BOSS
}
local borderrooms = {
	[DoorSlot.LEFT0] = {0, 13, 26, 39, 52, 65, 78, 91, 104, 117, 130, 143, 156},
	[DoorSlot.UP0] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12},
	[DoorSlot.RIGHT0] = {12, 25, 38, 51, 64, 77, 90, 103, 116, 129, 142, 155, 168},
	[DoorSlot.DOWN0] = {156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168},
	[DoorSlot.LEFT1] = {0, 13, 26, 39, 52, 65, 78, 91, 104, 117, 130, 143, 156},
	[DoorSlot.UP1] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12},
	[DoorSlot.RIGHT1] = {12, 25, 38, 51, 64, 77, 90, 103, 116, 129, 142, 155, 168},
	[DoorSlot.DOWN1] = {156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168}
}
local function GetAllDeadEndsRed()
	local level = game:GetLevel()
	local floordeadends = {}

	for i = level:GetRooms().Size, 0, -1 do
		local roomdesc = level:GetRooms():Get(i-1)
		if roomdesc then
			local shape = roomdesc.Data.Shape
			local adjindex = adjindexes[shape]
			local roomidx = roomdesc.GridIndex
			for j, entry in pairs(adjindex) do
				if level:GetRoomByIdx(roomidx).Data and not mod:Contains(borderrooms[j], roomidx) then
					if roomdesc.Data.Doors & (1 << j) > 0 and level:GetRoomByIdx(roomidx+adjindex[j]).GridIndex == -1 then
						table.insert(floordeadends, {Slot = j, idx = roomidx+adjindex[j], sourceIDX = roomidx})
					end
				end
			end
		end
	end

    return floordeadends
end
local function GetTargetIDX(deadend, roomdesc, rslot)
    --print(rslot, roomdesc.Data.Shape)
    return deadend.sourceIDX + (adjindexes[roomdesc.Data.Shape][deadend.Slot])
    + (adjindexes[RoomShape.ROOMSHAPE_1x1][rslot])
end
local function IsValidRedRoomSpot(level, RRidx, func)
	func = func or function()
		return false
	end

    local roomDesc = level:GetRoomByIdx(RRidx)
	if not roomDesc or roomDesc.GridIndex <= 0 then
        for i = 1, 4, 1 do
            local rslot = i - 1
            if rslot < 0 then rslot = 3 end
            if rslot >= 4 then rslot = 0 end
            local oslot = oppslots[rslot]

            local trIDX = RRidx + adjindexes[RoomShape.ROOMSHAPE_1x1][rslot]
            local realRoom = level:GetRoomByIdx(trIDX)

            if realRoom and realRoom.GridIndex > 0 then
                if realRoom.Data.Doors & 1 << oslot == 0
                or realRoom.Data.Type == RoomType.ROOM_BOSS
                or func(level, realRoom) then
                    return false
                end
            end
        end
    else
        return false
    end

    return true
end
local function IsValidUSRSpot(idx, game)
    local level = game:GetLevel()

    for j = 1, 4, 1 do
        j = j - 1
        local RRidx = idx + adjindexes[RoomShape.ROOMSHAPE_1x1][j]
        local validRedRoomFunc = function (level, realroom)
            return mod:Contains(rBlacklist, realroom.Data.Type)
        end
        if not IsValidRedRoomSpot(level, RRidx, validRedRoomFunc) then
            return false
        end
    end
    return true
end
local function redRoomExists(lvel)
    for i = 1, 169 do
        local redRoom = lvel:GetRoomByIdx(i)

        if redRoom.Data
        and redRoom.Data.Type == RoomType.ROOM_ULTRASECRET
        and redRoom.DisplayFlags & 1 << 2 == 0 then
            --redRoom.DisplayFlags = (redRoom.DisplayFlags or 0) | 1 << 2
            return true
        end
    end
end
local function onNewFloor()
	local level = game:GetLevel()
	if not redRoomExists(level) then
		return
	end
    local deadends = GetAllDeadEndsRed()
    local availableIDXs = {}
    local unavailableIDXs = {}

    for _, deadend in ipairs(deadends) do
        --print(deadend.roomidx)
        local roomdesc = level:GetRoomByIdx(deadend.sourceIDX)
        if roomdesc and roomdesc.Data
        and not mod:Contains(rBlacklist, roomdesc.Data.Type) then
            --print(roomdesc.Data.Type, SomethingWicked:UtilTableHasValue(rBlacklist, roomdesc.Data.Type))
            --print(rBlacklist[1], rBlacklist[2], rBlacklist[3], rBlacklist[4])
            for i = 1, 3, 1 do
                local rslot = deadend.Slot - 2 + i
                if rslot < 0 then rslot = 3 end
                if rslot >= 4 then rslot = 0 end
                local targetIDX = GetTargetIDX(deadend, roomdesc, rslot)

                if not mod:Contains(unavailableIDXs, targetIDX) then
                    local flag = IsValidUSRSpot(targetIDX, game)
                    if flag then
                        availableIDXs[targetIDX] = (availableIDXs[targetIDX] or 0) + 1
                    else
                        table.insert(unavailableIDXs, targetIDX)
                        --do removal stuff
                        availableIDXs[targetIDX] = nil
                    end
                end
            end
        end
    end

    local heighestWeight = -1 local currentTable = {}
    for IDXs, weight in pairs(availableIDXs) do
        if weight > heighestWeight then
            heighestWeight = weight
        end

        currentTable[weight] = currentTable[weight] or {}
        table.insert(currentTable[weight], IDXs)
    end

    --i referenced this part from segmented mauseum although inhindsight part of me feels that wont even be neecessary?
	local oldchallenge = game.Challenge
	game.Challenge = Challenge.CHALLENGE_RED_REDEMPTION

    local flag = false local currWeight = heighestWeight
    while not flag and currWeight > 0 do
        if currentTable[currWeight] then
            mod:Shuffle(currentTable[currWeight])

            for _, value in pairs(currentTable[currWeight]) do
                local roomdesc = level:GetRoomByIdx(value)
                if not roomdesc.Data then
	                level:MakeRedRoomDoor(value-13, DoorSlot.DOWN0)
	                local roomdesc = level:GetRoomByIdx(value)
	                local nflag = roomdesc ~= nil and roomdesc.Flags & RoomDescriptor.FLAG_RED_ROOM ~= 0
	                flag = flag or nflag

                	if flag then
                    	--mod:ReplaceRoomFromDataset(mod.UltraSecretRoomsSet, value, collectibleRNG)
        				local seed = math.max(1, level:GetDungeonPlacementSeed())
        				local room = RoomConfigHolder.GetRandomRoom(seed, false, StbType.SPECIAL_ROOMS, RoomType.ROOM_ULTRASECRET, RoomShape.ROOMSHAPE_1x1)
        				roomdesc.Data = room

    	    			updateRoomFlags(roomdesc)
	        			level:UpdateVisibility()
                    	break
                	end
                end
            end
        end
        currWeight = currWeight - 1
    end
	game.Challenge = oldchallenge
    level:UpdateVisibility()
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.ITEM.COLLECTIBLE.RED_NIGHTMARE, onNewFloor)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, familiar)
	local data = mod:GetEntityData(familiar)
	local sprite = familiar:GetSprite()

	if not data.init then
		familiar:AddToFollowers()
		data.init = true
	end
	familiar:FollowParent()

	if not sprite:IsPlaying("Float") then
		sprite:Play("Float", true)
	end
	familiar.SpriteOffset = Vector(0,-3)
end, FiendFolio.ITEM.FAMILIAR.RED)