local mod = FiendFolio
local game = Game()
local conjoinedCard = mod.ITEM.TRINKET.CONJOINED_CARD

-- Room subtypes that can be picked
local normalSinsIndexes = {
	RoomSubType.MINIBOSS_SLOTH,
	RoomSubType.MINIBOSS_LUST,
	RoomSubType.MINIBOSS_WRATH,
	RoomSubType.MINIBOSS_GLUTTONY,
	RoomSubType.MINIBOSS_ENVY,
	RoomSubType.MINIBOSS_PRIDE,
}

local superSinsIndexes = {
	RoomSubType.MINIBOSS_SUPER_SLOTH,
	RoomSubType.MINIBOSS_SUPER_LUST,
	RoomSubType.MINIBOSS_SUPER_WRATH,
	RoomSubType.MINIBOSS_SUPER_GLUTTONY,
	RoomSubType.MINIBOSS_SUPER_ENVY,
	RoomSubType.MINIBOSS_SUPER_PRIDE,
	RoomSubType.MINIBOSS_ULTRA_PRIDE,
}

local allSinsIndexes = {}
for _, index in pairs(normalSinsIndexes) do table.insert(allSinsIndexes, index) end
for _, index in pairs(superSinsIndexes)  do table.insert(allSinsIndexes, index) end

-- Spawn conditions in order of priority
local searchConditions = {
	{ 1 }, 					   -- Adjacent to only 1 Default room, ignores Secret rooms
	{ 4 }, 					   -- Adjacent to n Default rooms, ignores Secret rooms
	{ 4, true }, 			   -- Adjacent at least one Default room & n Special rooms, excludes SS/US Rooms & Boss Rooms, ignores Secret rooms
	{ 4, true, true }, 		   -- Adjacent to n Special rooms, excludes SS/US Rooms & Boss Rooms, ignores Secret rooms
	{ 9e9, true, true, true }, -- Adjacent to any room
}

local function getIdealSeeders()
	local output = {}
	local roomsList = game:GetLevel():GetRooms()

	for i = 0, #roomsList - 1 do
		local room = roomsList:Get(i)
		if room.Data.Type == RoomType.ROOM_DEFAULT then
			table.insert(output, room)
		end
	end

	return output
end

local function getSpecialSeeders()
	local output = {}
	local roomsList = game:GetLevel():GetRooms()

	for i = 0, #roomsList - 1 do
		local room = roomsList:Get(i)
		if room.Data.Type ~= RoomType.ROOM_BOSS and room.Data.Type ~= RoomType.ROOM_SUPERSECRET and room.Data.Type ~= RoomType.ROOM_ULTRASECRET then
			table.insert(output, room)
		end
	end

	return output
end

local function getTableRoomsList()
	local output = {}
	local roomsList = game:GetLevel():GetRooms()
	
	for i = 0, #roomsList - 1 do
		table.insert(output, roomsList:Get(i))
	end

	return output
end

local function getNumRoomConnections(index, ignoreSpecialRooms)
	local level = game:GetLevel()
	local connections = 0

	for _, shift in pairs({1, -1, 13, -13}) do
		local desc = level:GetRoomByIdx(index + shift)
		if desc.Data then
			if desc.Data.Type == RoomType.ROOM_ULTRASECRET then
				connections = connections + 999
			else
				if desc.Data.Type == RoomType.ROOM_DEFAULT then
					connections = connections + 1
				elseif desc.Data.Type ~= RoomType.ROOM_SECRET and not ignoreSpecialRooms then
					connections = connections + 999
				end
			end
		end
	end

	return connections
end

local function getIndexSlotPairs(maxConnections, permitSpecialRooms, useExpandedRoomSet, useUnlimitedRoomSet)
	local rooms = useExpandedRoomSet and (useUnlimitedRoomSet and getTableRoomsList() or getSpecialSeeders()) or getIdealSeeders()
	local output = {}

	for _, roomDesc in pairs(rooms) do
		for doorSlot = 0, DoorSlot.NUM_DOOR_SLOTS - 1 do
			if roomDesc.Data.Doors & (1 << doorSlot) > 0 and mod.CanDoorSlotMakeRedRoom(doorSlot, roomDesc.SafeGridIndex) then
				local targetIndex = mod.GetTargetRoomIndex(doorSlot, roomDesc.SafeGridIndex)

				if getNumRoomConnections(targetIndex, permitSpecialRooms) <= maxConnections then
					local data = { Index = roomDesc.SafeGridIndex, DoorSlot = doorSlot, }
					table.insert(output, data)
				end
			end
		end
	end

	return output
end

local function canConjoinedCardTrigger()
	local levelStage = game:GetLevel():GetStage()

	return not game:IsGreedMode()
	and not game:GetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH)
	and levelStage < LevelStage.STAGE7
	and levelStage ~= LevelStage.STAGE4_3
end

local function getMinibossRoom(rng)
	local level = game:GetLevel()
	local levelStage = level:GetStage()
	local validSubTypes = levelStage >= LevelStage.STAGE2_1 and allSinsIndexes or normalSinsIndexes

	-- Try and avoid picking the same sin multiple times
	local testSubTypes = mod:CopyTable(validSubTypes)
	local roomsList = level:GetRooms()

	for i = 0, #roomsList - 1 do
		local room = roomsList:Get(i)
		if room.Data.Type == RoomType.ROOM_MINIBOSS then
			for j, subType in pairs(testSubTypes) do
				if room.Data.Subtype == subType then
					table.remove(testSubTypes, j)
					break
				end
			end

			-- No more sins left
			if #testSubTypes <= 0 then
				testSubTypes = mod:CopyTable(validSubTypes)
				break
			end
		end
	end

	-- Try and get a valid miniboss room for a random sin
	local tries = 0
	while tries < 100 do
		local subType = mod:RandomIndex(testSubTypes, rng)
		local roomConfig = RoomConfig.GetRandomRoom(
			rng:GetSeed(),
			false,
			StbType.SPECIAL_ROOMS,
			RoomType.ROOM_MINIBOSS,
			RoomShape.ROOMSHAPE_1x1,
			nil, nil,
			nil, nil,
			(DoorMask.LEFT0 | DoorMask.UP0 | DoorMask.RIGHT0 | DoorMask.DOWN0),
			subType,
			0
		)

		if roomConfig then
			return roomConfig
		end

		rng:Next()
		tries = tries + 1
	end
end

function mod.MakeNewMinibossRoom(rng)
	local level = game:GetLevel()
	local roomConfig = getMinibossRoom(rng)

	if roomConfig then
		for i = 1, #searchConditions do
			local roomSet = getIndexSlotPairs(table.unpack(searchConditions[i]))

			while #roomSet > 0 do
				local roll = rng:RandomInt(#roomSet) + 1
				local chosen = roomSet[roll]

				-- Try placing a room at this spot
				local neighbor = level:GetRoomByIdx(chosen.Index)
				local doorSlot = chosen.DoorSlot
				local roomDesc = level:TryPlaceRoomAtDoor(roomConfig, neighbor, doorSlot, rng:GetSeed(), true, true)

				if roomDesc then
					return roomDesc
				else
					table.remove(roomSet, roll)
				end
			end
		end
	end

	return false
end

mod:AddPriorityTrinketCallback(ModCallbacks.MC_POST_NEW_LEVEL, CallbackPriority.IMPORTANT, conjoinedCard, function()
	local multiplier = PlayerManager.GetTotalTrinketMultiplier(conjoinedCard)

	if multiplier > 0 and canConjoinedCardTrigger() then
		local player = PlayerManager.FirstTrinketOwner(conjoinedCard)
		local rng = player:GetTrinketRNG(conjoinedCard)

		local generatedRoom = false
		for i = 1, multiplier do
			generatedRoom = mod.MakeNewMinibossRoom(rng) or generatedRoom
		end

		if generatedRoom then
			game:GetLevel():UpdateVisibility()
			if MinimapAPI then
				MinimapAPI:CheckForNewRedRooms()
			end
		end
	end
end)