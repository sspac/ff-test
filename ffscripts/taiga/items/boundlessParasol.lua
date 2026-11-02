-- Boundless Parasol --

-- TODO: door to error room at edge of map handling

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local BOUNDARY_DOOR_MAX_ALPHA = 0.5

local BoundaryDoorAllowed = {
	NEVER = 0,
	ALWAYS = 1,
	VISITED = 2,
	VISITED_IGNORE_FIRST_FLOOR = 3,
}

local ValidBoundaryRoomTypes = {}
ValidBoundaryRoomTypes[RoomType.ROOM_NULL] = BoundaryDoorAllowed.NEVER
ValidBoundaryRoomTypes[RoomType.ROOM_DEFAULT] = BoundaryDoorAllowed.ALWAYS
ValidBoundaryRoomTypes[RoomType.ROOM_SHOP] = BoundaryDoorAllowed.VISITED_IGNORE_FIRST_FLOOR
ValidBoundaryRoomTypes[RoomType.ROOM_ERROR] = BoundaryDoorAllowed.NEVER
ValidBoundaryRoomTypes[RoomType.ROOM_TREASURE] = BoundaryDoorAllowed.VISITED_IGNORE_FIRST_FLOOR
ValidBoundaryRoomTypes[RoomType.ROOM_BOSS] = BoundaryDoorAllowed.NEVER --unless i figure out a good way to handle the temporary offgrid doors (deals, alt path, boss rush, etc.)
ValidBoundaryRoomTypes[RoomType.ROOM_MINIBOSS] = BoundaryDoorAllowed.ALWAYS
ValidBoundaryRoomTypes[RoomType.ROOM_SECRET] = BoundaryDoorAllowed.VISITED
ValidBoundaryRoomTypes[RoomType.ROOM_SUPERSECRET] = BoundaryDoorAllowed.VISITED
ValidBoundaryRoomTypes[RoomType.ROOM_ARCADE] = BoundaryDoorAllowed.VISITED
ValidBoundaryRoomTypes[RoomType.ROOM_CURSE] = BoundaryDoorAllowed.ALWAYS
ValidBoundaryRoomTypes[RoomType.ROOM_CHALLENGE] = BoundaryDoorAllowed.VISITED
ValidBoundaryRoomTypes[RoomType.ROOM_LIBRARY] = BoundaryDoorAllowed.VISITED
ValidBoundaryRoomTypes[RoomType.ROOM_SACRIFICE] = BoundaryDoorAllowed.ALWAYS
ValidBoundaryRoomTypes[RoomType.ROOM_DEVIL] = BoundaryDoorAllowed.ALWAYS --this should only be relevant for red rooms
ValidBoundaryRoomTypes[RoomType.ROOM_ANGEL] = BoundaryDoorAllowed.ALWAYS --this should only be relevant for red rooms
ValidBoundaryRoomTypes[RoomType.ROOM_DUNGEON] = BoundaryDoorAllowed.NEVER
ValidBoundaryRoomTypes[RoomType.ROOM_BOSSRUSH] = BoundaryDoorAllowed.NEVER
ValidBoundaryRoomTypes[RoomType.ROOM_ISAACS] = BoundaryDoorAllowed.VISITED
ValidBoundaryRoomTypes[RoomType.ROOM_BARREN] = BoundaryDoorAllowed.VISITED
ValidBoundaryRoomTypes[RoomType.ROOM_CHEST] = BoundaryDoorAllowed.VISITED
ValidBoundaryRoomTypes[RoomType.ROOM_DICE] = BoundaryDoorAllowed.VISITED
ValidBoundaryRoomTypes[RoomType.ROOM_BLACK_MARKET] = BoundaryDoorAllowed.NEVER
ValidBoundaryRoomTypes[RoomType.ROOM_GREED_EXIT] = BoundaryDoorAllowed.NEVER
ValidBoundaryRoomTypes[RoomType.ROOM_PLANETARIUM] = BoundaryDoorAllowed.VISITED
ValidBoundaryRoomTypes[RoomType.ROOM_TELEPORTER] = BoundaryDoorAllowed.NEVER
ValidBoundaryRoomTypes[RoomType.ROOM_TELEPORTER_EXIT] = BoundaryDoorAllowed.NEVER
ValidBoundaryRoomTypes[RoomType.ROOM_SECRET_EXIT] = BoundaryDoorAllowed.NEVER
ValidBoundaryRoomTypes[RoomType.ROOM_BLUE] = BoundaryDoorAllowed.NEVER
ValidBoundaryRoomTypes[RoomType.ROOM_ULTRASECRET] = BoundaryDoorAllowed.VISITED

local currentMap = {}
local currentMapSeed = {}
local needToDisableBoundlessMirrorSound = false
local nextExitDoorSlot = DoorSlot.NO_DOOR_SLOT
local forceFadeIn = false
local boundlessDoorFrameTimer = 0

local function handleBoundlessDoorTransition(door, data, sprite, doorData, persistData)
	sfx:Play(mod.Sounds.BoundlessDoorTransition, 1, 0, false, math.random(19,21)/20)
	needToDisableBoundlessMirrorSound = true
	nextExitDoorSlot = data.DoorGridData.ExitSlot

	--lol same-room-transitions are weird in stageapi but not basegame for some reason? so we override it
	if data.DoorGridData.LeadsTo == game:GetLevel():GetCurrentRoomDesc().SafeGridIndex then
		data.DoorGridData.LeadsTo = nil
		data.DoorGridData.BoundlessLeadsTo = game:GetLevel():GetCurrentRoomDesc().SafeGridIndex
	end
	if data.DoorGridData.BoundlessLeadsTo then
		StageAPI.ForcePlayerDoorSlot = data.DoorGridData.ExitSlot
		game:StartRoomTransition(data.DoorGridData.BoundlessLeadsTo, StageAPI.DoorSlotToDirection[data.DoorGridData.Slot], data.DoorGridData.TransitionAnim)
	end
end

local function handleBoundlessMirrorSoundStopping()
	if needToDisableBoundlessMirrorSound then
		sfx:Stop(SoundEffect.SOUND_MIRROR_ENTER)
		sfx:Stop(SoundEffect.SOUND_MIRROR_EXIT)
	end
	needToDisableBoundlessMirrorSound = false
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_UPDATE, math.huge, handleBoundlessMirrorSoundStopping)
mod:AddPriorityCallback(ModCallbacks.MC_POST_RENDER, math.huge, handleBoundlessMirrorSoundStopping)

local DoorSlotFlag = {
  LEFT0 = 1 << DoorSlot.LEFT0,
  UP0 = 1 << DoorSlot.UP0,
  RIGHT0 = 1 << DoorSlot.RIGHT0,
  DOWN0 = 1 << DoorSlot.DOWN0,
  LEFT1 = 1 << DoorSlot.LEFT1,
  UP1 = 1 << DoorSlot.UP1,
  RIGHT1 = 1 << DoorSlot.RIGHT1,
  DOWN1 = 1 << DoorSlot.DOWN1,
}

local RoomDisplayFlags = {
	VISIBLE = 1 << 0,
	ROOM_SHADOW = 1 << 1,
	SHOW_ICON = 1 << 2,
}

local function initializeMap()
	local level = game:GetLevel()
	local dimension = level:GetDimension()

	currentMap[dimension] = {}
	for i = 0, 12 do
		currentMap[dimension][i] = {}
	end

	for y = 0, 12 do
		for x = 0, 12 do
			if currentMap[dimension][y][x] ~= nil then
				goto continueA
			end

			local roomDesc = level:GetRoomByIdx(y * 13 + x)
			local roomData = roomDesc.Data
			if roomData ~= nil then
				local roomDoors = roomData.Doors
				local roomShape = roomData.Shape
				local safeIndex = roomDesc.SafeGridIndex
				local safeY = math.floor(safeIndex / 13)
				local safeX = safeIndex % 13

				if roomShape == RoomShape.ROOMSHAPE_1x2 or
				   roomShape == RoomShape.ROOMSHAPE_IIV
				then
					currentMap[dimension][safeY][safeX] = {
						Desc = roomDesc,
						SafeGridIndex = safeIndex,
						NorthDoorSlot = DoorSlot.UP0,
						SouthDoorSlot = DoorSlot.NO_DOOR_SLOT,
						WestDoorSlot = DoorSlot.LEFT0,
						EastDoorSlot = DoorSlot.RIGHT0,
						NorthCanDoor = roomDoors & DoorSlotFlag.UP0 ~= 0,
						SouthCanDoor = false,
						WestCanDoor = roomDoors & DoorSlotFlag.LEFT0 ~= 0,
						EastCanDoor = roomDoors & DoorSlotFlag.RIGHT0 ~= 0,
						NorthDoorIndex = 7,
						SouthDoorIndex = -1,
						WestDoorIndex = 60,
						EastDoorIndex = 74,
					}
					currentMap[dimension][safeY + 1][safeX] = {
						Desc = roomDesc,
						SafeGridIndex = safeIndex,
						NorthDoorSlot = DoorSlot.NO_DOOR_SLOT,
						SouthDoorSlot = DoorSlot.DOWN0,
						WestDoorSlot = DoorSlot.LEFT1,
						EastDoorSlot = DoorSlot.RIGHT1,
						NorthCanDoor = false,
						SouthCanDoor = roomDoors & DoorSlotFlag.DOWN0 ~= 0,
						WestCanDoor = roomDoors & DoorSlotFlag.LEFT1 ~= 0,
						EastCanDoor = roomDoors & DoorSlotFlag.RIGHT1 ~= 0,
						NorthDoorIndex = -1,
						SouthDoorIndex = 232,
						WestDoorIndex = 165,
						EastDoorIndex = 179,
					}
				elseif roomShape == RoomShape.ROOMSHAPE_2x1 or
					   roomShape == RoomShape.ROOMSHAPE_IIH
				then
					currentMap[dimension][safeY][safeX] = {
						Desc = roomDesc,
						SafeGridIndex = safeIndex,
						NorthDoorSlot = DoorSlot.UP0,
						SouthDoorSlot = DoorSlot.DOWN0,
						WestDoorSlot = DoorSlot.LEFT0,
						EastDoorSlot = DoorSlot.NO_DOOR_SLOT,
						NorthCanDoor = roomDoors & DoorSlotFlag.UP0 ~= 0,
						SouthCanDoor = roomDoors & DoorSlotFlag.DOWN0 ~= 0,
						WestCanDoor = roomDoors & DoorSlotFlag.LEFT0 ~= 0,
						EastCanDoor = false,
						NorthDoorIndex = 7,
						SouthDoorIndex = 231,
						WestDoorIndex = 112,
						EastDoorIndex = -1,
					}
					currentMap[dimension][safeY][safeX + 1] = {
						Desc = roomDesc,
						SafeGridIndex = safeIndex,
						NorthDoorSlot = DoorSlot.UP1,
						SouthDoorSlot = DoorSlot.DOWN1,
						WestDoorSlot = DoorSlot.NO_DOOR_SLOT,
						EastDoorSlot = DoorSlot.RIGHT0,
						NorthCanDoor = roomDoors & DoorSlotFlag.UP1 ~= 0,
						SouthCanDoor = roomDoors & DoorSlotFlag.DOWN1 ~= 0,
						WestCanDoor = false,
						EastCanDoor = roomDoors & DoorSlotFlag.RIGHT0 ~= 0,
						NorthDoorIndex = 20,
						SouthDoorIndex = 244,
						WestDoorIndex = -1,
						EastDoorIndex = 139,
					}
				elseif roomShape == RoomShape.ROOMSHAPE_2x2 then
					currentMap[dimension][safeY][safeX] = {
						Desc = roomDesc,
						SafeGridIndex = safeIndex,
						NorthDoorSlot = DoorSlot.UP0,
						SouthDoorSlot = NO_DOOR_SLOT,
						WestDoorSlot = DoorSlot.LEFT0,
						EastDoorSlot = NO_DOOR_SLOT,
						NorthCanDoor = roomDoors & DoorSlotFlag.UP0 ~= 0,
						SouthCanDoor = false,
						WestCanDoor = roomDoors & DoorSlotFlag.LEFT0 ~= 0,
						EastCanDoor = false,
						NorthDoorIndex = 7,
						SouthDoorIndex = -1,
						WestDoorIndex = 112,
						EastDoorIndex = -1,
					}
					currentMap[dimension][safeY][safeX + 1] = {
						Desc = roomDesc,
						SafeGridIndex = safeIndex,
						NorthDoorSlot = DoorSlot.UP1,
						SouthDoorSlot = DoorSlot.NO_DOOR_SLOT,
						WestDoorSlot = DoorSlot.NO_DOOR_SLOT,
						EastDoorSlot = DoorSlot.RIGHT0,
						NorthCanDoor = roomDoors & DoorSlotFlag.UP1 ~= 0,
						SouthCanDoor = false,
						WestCanDoor = false,
						EastCanDoor = roomDoors & DoorSlotFlag.RIGHT0 ~= 0,
						NorthDoorIndex = 20,
						SouthDoorIndex = -1,
						WestDoorIndex = -1,
						EastDoorIndex = 139,
					}
					currentMap[dimension][safeY + 1][safeX] = {
						Desc = roomDesc,
						SafeGridIndex = safeIndex,
						NorthDoorSlot = DoorSlot.NO_DOOR_SLOT,
						SouthDoorSlot = DoorSlot.DOWN0,
						WestDoorSlot = DoorSlot.LEFT1,
						EastDoorSlot = DoorSlot.NO_DOOR_SLOT,
						NorthCanDoor = false,
						SouthCanDoor = roomDoors & DoorSlotFlag.DOWN0 ~= 0,
						WestCanDoor = roomDoors & DoorSlotFlag.LEFT1 ~= 0,
						EastCanDoor = false,
						NorthDoorIndex = -1,
						SouthDoorIndex = 427,
						WestDoorIndex = 308,
						EastDoorIndex = -1,
					}
					currentMap[dimension][safeY + 1][safeX + 1] = {
						Desc = roomDesc,
						SafeGridIndex = safeIndex,
						NorthDoorSlot = DoorSlot.NO_DOOR_SLOT,
						SouthDoorSlot = DoorSlot.DOWN1,
						WestDoorSlot = DoorSlot.NO_DOOR_SLOT,
						EastDoorSlot = DoorSlot.RIGHT1,
						NorthCanDoor = false,
						SouthCanDoor = roomDoors & DoorSlotFlag.DOWN1 ~= 0,
						WestCanDoor = false,
						EastCanDoor = roomDoors & DoorSlotFlag.RIGHT1 ~= 0,
						NorthDoorIndex = -1,
						SouthDoorIndex = 440,
						WestDoorIndex = -1,
						EastDoorIndex = 335,
					}
				elseif roomShape == RoomShape.ROOMSHAPE_LTL then
					currentMap[dimension][safeY][safeX] = {
						Desc = roomDesc,
						SafeGridIndex = safeIndex,
						NorthDoorSlot = DoorSlot.UP1,
						SouthDoorSlot = DoorSlot.NO_DOOR_SLOT,
						WestDoorSlot = DoorSlot.LEFT0,
						EastDoorSlot = DoorSlot.RIGHT0,
						NorthCanDoor = roomDoors & DoorSlotFlag.UP1 ~= 0,
						SouthCanDoor = false,
						WestCanDoor = roomDoors & DoorSlotFlag.LEFT0 ~= 0,
						EastCanDoor = roomDoors & DoorSlotFlag.RIGHT0 ~= 0,
						NorthDoorIndex = 20,
						SouthDoorIndex = -1,
						WestDoorIndex = 125,
						EastDoorIndex = 139,
					}
					currentMap[dimension][safeY + 1][safeX - 1] = {
						Desc = roomDesc,
						SafeGridIndex = safeIndex,
						NorthDoorSlot = DoorSlot.UP0,
						SouthDoorSlot = DoorSlot.DOWN0,
						WestDoorSlot = DoorSlot.LEFT1,
						EastDoorSlot = DoorSlot.NO_DOOR_SLOT,
						NorthCanDoor = roomDoors & DoorSlotFlag.UP0 ~= 0,
						SouthCanDoor = roomDoors & DoorSlotFlag.DOWN0 ~= 0,
						WestCanDoor = roomDoors & DoorSlotFlag.LEFT1 ~= 0,
						EastCanDoor = false,
						NorthDoorIndex = 203,
						SouthDoorIndex = 427,
						WestDoorIndex = 308,
						EastDoorIndex = -1,
					}
					currentMap[dimension][safeY + 1][safeX] = {
						Desc = roomDesc,
						SafeGridIndex = safeIndex,
						NorthDoorSlot = DoorSlot.NO_DOOR_SLOT,
						SouthDoorSlot = DoorSlot.DOWN1,
						WestDoorSlot = DoorSlot.NO_DOOR_SLOT,
						EastDoorSlot = DoorSlot.RIGHT1,
						NorthCanDoor = false,
						SouthCanDoor = roomDoors & DoorSlotFlag.DOWN1 ~= 0,
						WestCanDoor = false,
						EastCanDoor = roomDoors & DoorSlotFlag.RIGHT1 ~= 0,
						NorthDoorIndex = -1,
						SouthDoorIndex = 440,
						WestDoorIndex = -1,
						EastDoorIndex = 335,
					}
				elseif roomShape == RoomShape.ROOMSHAPE_LTR then
					currentMap[dimension][safeY][safeX] = {
						Desc = roomDesc,
						SafeGridIndex = safeIndex,
						NorthDoorSlot = DoorSlot.UP0,
						SouthDoorSlot = DoorSlot.NO_DOOR_SLOT,
						WestDoorSlot = DoorSlot.LEFT0,
						EastDoorSlot = DoorSlot.RIGHT0,
						NorthCanDoor = roomDoors & DoorSlotFlag.UP0 ~= 0,
						SouthCanDoor = false,
						WestCanDoor = roomDoors & DoorSlotFlag.LEFT0 ~= 0,
						EastCanDoor = roomDoors & DoorSlotFlag.RIGHT0 ~= 0,
						NorthDoorIndex = 7,
						SouthDoorIndex = -1,
						WestDoorIndex = 112,
						EastDoorIndex = 126,
					}
					currentMap[dimension][safeY + 1][safeX] = {
						Desc = roomDesc,
						SafeGridIndex = safeIndex,
						NorthDoorSlot = DoorSlot.NO_DOOR_SLOT,
						SouthDoorSlot = DoorSlot.DOWN0,
						WestDoorSlot = DoorSlot.LEFT1,
						EastDoorSlot = DoorSlot.NO_DOOR_SLOT,
						NorthCanDoor = false,
						SouthCanDoor = roomDoors & DoorSlotFlag.DOWN0 ~= 0,
						WestCanDoor = roomDoors & DoorSlotFlag.LEFT1 ~= 0,
						EastCanDoor = false,
						NorthDoorIndex = -1,
						SouthDoorIndex = 427,
						WestDoorIndex = 308,
						EastDoorIndex = -1,
					}
					currentMap[dimension][safeY + 1][safeX + 1] = {
						Desc = roomDesc,
						SafeGridIndex = safeIndex,
						NorthDoorSlot = DoorSlot.UP1,
						SouthDoorSlot = DoorSlot.DOWN1,
						WestDoorSlot = DoorSlot.NO_DOOR_SLOT,
						EastDoorSlot = DoorSlot.RIGHT1,
						NorthCanDoor = roomDoors & DoorSlotFlag.UP1 ~= 0,
						SouthCanDoor = roomDoors & DoorSlotFlag.DOWN1 ~= 0,
						WestCanDoor = false,
						EastCanDoor = roomDoors & DoorSlotFlag.RIGHT1 ~= 0,
						NorthDoorIndex = 216,
						SouthDoorIndex = 440,
						WestDoorIndex = -1,
						EastDoorIndex = 335,
					}
				elseif roomShape == RoomShape.ROOMSHAPE_LBL then
					currentMap[dimension][safeY][safeX] = {
						Desc = roomDesc,
						SafeGridIndex = safeIndex,
						NorthDoorSlot = DoorSlot.UP0,
						SouthDoorSlot = DoorSlot.DOWN0,
						WestDoorSlot = DoorSlot.LEFT0,
						EastDoorSlot = DoorSlot.NO_DOOR_SLOT,
						NorthCanDoor = roomDoors & DoorSlotFlag.UP0 ~= 0,
						SouthCanDoor = roomDoors & DoorSlotFlag.DOWN0 ~= 0,
						WestCanDoor = roomDoors & DoorSlotFlag.LEFT0 ~= 0,
						EastCanDoor = false,
						NorthDoorIndex = 7,
						SouthDoorIndex = 231,
						WestDoorIndex = 112,
						EastDoorIndex = -1,
					}
					currentMap[dimension][safeY][safeX + 1] = {
						Desc = roomDesc,
						SafeGridIndex = safeIndex,
						NorthDoorSlot = DoorSlot.UP1,
						SouthDoorSlot = DoorSlot.NO_DOOR_SLOT,
						WestDoorSlot = DoorSlot.NO_DOOR_SLOT,
						EastDoorSlot = DoorSlot.RIGHT0,
						NorthCanDoor = roomDoors & DoorSlotFlag.UP1 ~= 0,
						SouthCanDoor = false,
						WestCanDoor = false,
						EastCanDoor = roomDoors & DoorSlotFlag.RIGHT0 ~= 0,
						NorthDoorIndex = 20,
						SouthDoorIndex = -1,
						WestDoorIndex = -1,
						EastDoorIndex = 139,
					}
					currentMap[dimension][safeY + 1][safeX + 1] = {
						Desc = roomDesc,
						SafeGridIndex = safeIndex,
						NorthDoorSlot = DoorSlot.NO_DOOR_SLOT,
						SouthDoorSlot = DoorSlot.DOWN1,
						WestDoorSlot = DoorSlot.LEFT1,
						EastDoorSlot = DoorSlot.RIGHT1,
						NorthCanDoor = false,
						SouthCanDoor = roomDoors & DoorSlotFlag.DOWN1 ~= 0,
						WestCanDoor = roomDoors & DoorSlotFlag.LEFT1 ~= 0,
						EastCanDoor = roomDoors & DoorSlotFlag.RIGHT1 ~= 0,
						NorthDoorIndex = -1,
						SouthDoorIndex = 440,
						WestDoorIndex = 321,
						EastDoorIndex = 335,
					}
				elseif roomShape == RoomShape.ROOMSHAPE_LBR then
					currentMap[dimension][safeY][safeX] = {
						Desc = roomDesc,
						SafeGridIndex = safeIndex,
						NorthDoorSlot = DoorSlot.UP0,
						SouthDoorSlot = NO_DOOR_SLOT,
						WestDoorSlot = DoorSlot.LEFT0,
						EastDoorSlot = NO_DOOR_SLOT,
						NorthCanDoor = roomDoors & DoorSlotFlag.UP0 ~= 0,
						SouthCanDoor = false,
						WestCanDoor = roomDoors & DoorSlotFlag.LEFT0 ~= 0,
						EastCanDoor = false,
						NorthDoorIndex = 7,
						SouthDoorIndex = -1,
						WestDoorIndex = 112,
						EastDoorIndex = -1,
					}
					currentMap[dimension][safeY][safeX + 1] = {
						Desc = roomDesc,
						SafeGridIndex = safeIndex,
						NorthDoorSlot = DoorSlot.UP1,
						SouthDoorSlot = DoorSlot.DOWN1,
						WestDoorSlot = DoorSlot.NO_DOOR_SLOT,
						EastDoorSlot = DoorSlot.RIGHT0,
						NorthCanDoor = roomDoors & DoorSlotFlag.UP1 ~= 0,
						SouthCanDoor = roomDoors & DoorSlotFlag.DOWN1 ~= 0,
						WestCanDoor = false,
						EastCanDoor = roomDoors & DoorSlotFlag.RIGHT0 ~= 0,
						NorthDoorIndex = 20,
						SouthDoorIndex = 244,
						WestDoorIndex = -1,
						EastDoorIndex = 139,
					}
					currentMap[dimension][safeY + 1][safeX] = {
						Desc = roomDesc,
						SafeGridIndex = safeIndex,
						NorthDoorSlot = DoorSlot.NO_DOOR_SLOT,
						SouthDoorSlot = DoorSlot.DOWN0,
						WestDoorSlot = DoorSlot.LEFT1,
						EastDoorSlot = DoorSlot.RIGHT1,
						NorthCanDoor = false,
						SouthCanDoor = roomDoors & DoorSlotFlag.DOWN0 ~= 0,
						WestCanDoor = roomDoors & DoorSlotFlag.LEFT1 ~= 0,
						EastCanDoor = roomDoors & DoorSlotFlag.RIGHT1 ~= 0,
						NorthDoorIndex = -1,
						SouthDoorIndex = 427,
						WestDoorIndex = 308,
						EastDoorIndex = 322,
					}
				else
					currentMap[dimension][safeY][safeX] = {
						Desc = roomDesc,
						SafeGridIndex = safeIndex,
						NorthDoorSlot = DoorSlot.UP0,
						SouthDoorSlot = DoorSlot.DOWN0,
						WestDoorSlot = DoorSlot.LEFT0,
						EastDoorSlot = DoorSlot.RIGHT0,
						NorthCanDoor = roomDoors & DoorSlotFlag.UP0 ~= 0,
						SouthCanDoor = roomDoors & DoorSlotFlag.DOWN0 ~= 0,
						WestCanDoor = roomDoors & DoorSlotFlag.LEFT0 ~= 0,
						EastCanDoor = roomDoors & DoorSlotFlag.RIGHT0 ~= 0,
						NorthDoorIndex = 7,
						SouthDoorIndex = 127,
						WestDoorIndex = 60,
						EastDoorIndex = 74,
					}
				end
			end

			::continueA::
		end
	end

	for y = 0, 12 do
		local westmostRoomX = nil
		local westmostRoomSafeIndex = nil
		local eastmostRoomX = nil
		local eastmostRoomSafeIndex = nil

		local lastRoomX = nil
		local hasHitGap = false
		for x = 0, 12 do
			if currentMap[dimension][y][x] ~= nil then
				local safeIndex = currentMap[dimension][y][x].SafeGridIndex
				if westmostRoomX == nil then
					westmostRoomX = x
					westmostRoomSafeIndex = safeIndex
				end
				eastmostRoomX = x
				eastmostRoomSafeIndex = safeIndex

				if hasHitGap then
					local westRoom = currentMap[dimension][y][lastRoomX]
					local eastRoom = currentMap[dimension][y][x]
					if westRoom.EastCanDoor and eastRoom.WestCanDoor then
						westRoom.EastDoorRoomIndex = y * 13 + x
						westRoom.EastExitDoorSlot = eastRoom.WestDoorSlot
						eastRoom.WestDoorRoomIndex = y * 13 + lastRoomX
						eastRoom.WestExitDoorSlot = westRoom.EastDoorSlot
					end
				end
				lastRoomX = x
				hasHitGap = false
			elseif lastRoomX ~= nil then
				hasHitGap = true
			end
		end

		if westmostRoomX == nil or
		   eastmostRoomX == nil or
		   westmostRoomSafeIndex == eastmostRoomSafeIndex
		then
			goto continueB
		end

		local westmostRoom = currentMap[dimension][y][westmostRoomX]
		local eastmostRoom = currentMap[dimension][y][eastmostRoomX]
		if westmostRoom.WestCanDoor and eastmostRoom.EastCanDoor then
			westmostRoom.WestDoorRoomIndex = y * 13 + eastmostRoomX
			westmostRoom.WestExitDoorSlot = eastmostRoom.EastDoorSlot
			eastmostRoom.EastDoorRoomIndex = y * 13 + westmostRoomX
			eastmostRoom.EastExitDoorSlot = westmostRoom.WestDoorSlot
		end

		::continueB::
	end

	for x = 0, 12 do
		local northmostRoomY = nil
		local northmostRoomSafeIndex = nil
		local southmostRoomY = nil
		local southmostRoomSafeIndex = nil

		local lastRoomY = nil
		local hasHitGap = false
		for y = 0, 12 do
			if currentMap[dimension][y][x] ~= nil then
				local safeIndex = currentMap[dimension][y][x].SafeGridIndex
				if northmostRoomY == nil then
					northmostRoomY = y
					northmostRoomSafeIndex = safeIndex
				end
				southmostRoomY = y
				southmostRoomSafeIndex = safeIndex

				if hasHitGap then
					local northRoom = currentMap[dimension][lastRoomY][x]
					local southRoom = currentMap[dimension][y][x]
					if northRoom.SouthCanDoor and southRoom.NorthCanDoor then
						northRoom.SouthDoorRoomIndex = y * 13 + x
						northRoom.SouthExitDoorSlot = southRoom.NorthDoorSlot
						southRoom.NorthDoorRoomIndex = lastRoomY * 13 + x
						southRoom.NorthExitDoorSlot = northRoom.SouthDoorSlot
					end
				end
				lastRoomY = y
				hasHitGap = false
			elseif lastRoomY ~= nil then
				hasHitGap = true
			end
		end

		if northmostRoomY == nil or
		   southmostRoomY == nil or
		   northmostRoomSafeIndex == southmostRoomSafeIndex
		then
			goto continueC
		end

		local northmostRoom = currentMap[dimension][northmostRoomY][x]
		local southmostRoom = currentMap[dimension][southmostRoomY][x]
		if northmostRoom.NorthCanDoor and southmostRoom.SouthCanDoor then
			northmostRoom.NorthDoorRoomIndex = southmostRoomY * 13 + x
			northmostRoom.NorthExitDoorSlot = southmostRoom.SouthDoorSlot
			southmostRoom.SouthDoorRoomIndex = northmostRoomY * 13 + x
			southmostRoom.SouthExitDoorSlot = northmostRoom.NorthDoorSlot
		end

		::continueC::
	end
end

local function resyncBoundlessDoor(door, data, room)
	local doorSlot = data.DoorGridData.Slot
	local leadsTo = data.DoorGridData.LeadsTo
	--local exitDoorSlot = data.DoorGridData.ExitSlot

	local intendedSlot = nil
	local intendedLeadsTo = nil
	local intendedExitDoorSlot = nil
	if doorSlot == DoorSlot.LEFT0 or doorSlot == DoorSlot.LEFT1 then
		intendedSlot = room.WestDoorSlot
		intendedLeadsTo = room.WestDoorRoomIndex
		intendedExitDoorSlot = room.WestExitDoorSlot
	elseif doorSlot == DoorSlot.UP0 or doorSlot == DoorSlot.UP1 then
		intendedSlot = room.NorthDoorSlot
		intendedLeadsTo = room.NorthDoorRoomIndex
		intendedExitDoorSlot = room.NorthExitDoorSlot
	elseif doorSlot == DoorSlot.RIGHT0 or doorSlot == DoorSlot.RIGHT1 then
		intendedSlot = room.EastDoorSlot
		intendedLeadsTo = room.EastDoorRoomIndex
		intendedExitDoorSlot = room.EastExitDoorSlot
	elseif doorSlot == DoorSlot.DOWN0 or doorSlot == DoorSlot.DOWN1 then
		intendedSlot = room.SouthDoorSlot
		intendedLeadsTo = room.SouthDoorRoomIndex
		intendedExitDoorSlot = room.SouthExitDoorSlot
	end

	if doorSlot == intendedSlot then
		if intendedLeadsTo == nil then
			local gameRoom = game:GetRoom()
			local gridindex = gameRoom:GetGridIndex(gameRoom:GetDoorSlotPosition(doorSlot))
			local grid = gameRoom:GetGridEntity(gridindex)
			door:Remove(true)
			if not (grid and grid:GetType() == GridEntityType.GRID_DOOR) then
				gameRoom:SetGridPath(gridindex, 0)
                Isaac.GridSpawn(GridEntityType.GRID_WALL, 0, gameRoom:GetGridPosition(gridindex), true)
			end
			return
		elseif leadsTo ~= intendedLeadsTo then
			data.DoorGridData.LeadsTo = intendedLeadsTo
			data.DoorGridData.ExitSlot = intendedExitDoorSlot
		end

		local level = game:GetLevel()
		local targetRoomDesc = level:GetRoomByIdx(intendedLeadsTo)
		local targetRoomType = targetRoomDesc.Data.Type

		local boundaryRoomType = ValidBoundaryRoomTypes[targetRoomType]
		local targetRoomWasVisited = targetRoomDesc.VisitedCount > 0
		local isFirstFloor = level:GetStage() == LevelStage.STAGE1_1
		if not (boundaryRoomType == BoundaryDoorAllowed.ALWAYS or
		        (boundaryRoomType == BoundaryDoorAllowed.VISITED and targetRoomWasVisited) or
		        (boundaryRoomType == BoundaryDoorAllowed.VISITED_IGNORE_FIRST_FLOOR and (targetRoomWasVisited or isFirstFloor)))
		then
			local gameRoom = game:GetRoom()
			local gridindex = gameRoom:GetGridIndex(gameRoom:GetDoorSlotPosition(doorSlot))
			local grid = gameRoom:GetGridEntity(gridindex)
			door:Remove(true)
			if not (grid and grid:GetType() == GridEntityType.GRID_DOOR) then
				gameRoom:SetGridPath(gridindex, 0)
                Isaac.GridSpawn(GridEntityType.GRID_WALL, 0, gameRoom:GetGridPosition(gridindex), true)
			end
			return
		end
	end
end

local function handleBoundlessDoorResyncing(door, data, room)
	local level = game:GetLevel()
	local levelSeed = level:GetDungeonPlacementSeed()
	local dimension = level:GetDimension()
	if currentMap[dimension] == nil or currentMapSeed[dimension] ~= levelSeed then
		initializeMap()
		currentMapSeed[dimension] = levelSeed
	end

	local roomDesc = level:GetCurrentRoomDesc()
	local roomData = roomDesc.Data
	local roomShape = roomData.Shape

	local safeIndex = roomDesc.SafeGridIndex
	local safeY = math.floor(safeIndex / 13)
	local safeX = safeIndex % 13

	if safeIndex < 0 or safeIndex > 168 then -- offgrid room
		return
	end

	if roomShape == RoomShape.ROOMSHAPE_1x2 or
	   roomShape == RoomShape.ROOMSHAPE_IIV
	then
		resyncBoundlessDoor(door, data, currentMap[dimension][safeY][safeX])
		resyncBoundlessDoor(door, data, currentMap[dimension][safeY + 1][safeX])
	elseif roomShape == RoomShape.ROOMSHAPE_2x1 or
		   roomShape == RoomShape.ROOMSHAPE_IIH
	then
		resyncBoundlessDoor(door, data, currentMap[dimension][safeY][safeX])
		resyncBoundlessDoor(door, data, currentMap[dimension][safeY][safeX + 1])
	elseif roomShape == RoomShape.ROOMSHAPE_2x2 then
		resyncBoundlessDoor(door, data, currentMap[dimension][safeY][safeX])
		resyncBoundlessDoor(door, data, currentMap[dimension][safeY][safeX + 1])
		resyncBoundlessDoor(door, data, currentMap[dimension][safeY + 1][safeX])
		resyncBoundlessDoor(door, data, currentMap[dimension][safeY + 1][safeX + 1])
	elseif roomShape == RoomShape.ROOMSHAPE_LTL then
		resyncBoundlessDoor(door, data, currentMap[dimension][safeY][safeX])
		resyncBoundlessDoor(door, data, currentMap[dimension][safeY + 1][safeX - 1])
		resyncBoundlessDoor(door, data, currentMap[dimension][safeY + 1][safeX])
	elseif roomShape == RoomShape.ROOMSHAPE_LTR then
		resyncBoundlessDoor(door, data, currentMap[dimension][safeY][safeX])
		resyncBoundlessDoor(door, data, currentMap[dimension][safeY + 1][safeX])
		resyncBoundlessDoor(door, data, currentMap[dimension][safeY + 1][safeX + 1])
	elseif roomShape == RoomShape.ROOMSHAPE_LBL then
		resyncBoundlessDoor(door, data, currentMap[dimension][safeY][safeX])
		resyncBoundlessDoor(door, data, currentMap[dimension][safeY][safeX + 1])
		resyncBoundlessDoor(door, data, currentMap[dimension][safeY + 1][safeX + 1])
	elseif roomShape == RoomShape.ROOMSHAPE_LBR then
		resyncBoundlessDoor(door, data, currentMap[dimension][safeY][safeX])
		resyncBoundlessDoor(door, data, currentMap[dimension][safeY][safeX + 1])
		resyncBoundlessDoor(door, data, currentMap[dimension][safeY + 1][safeX])
	else
		resyncBoundlessDoor(door, data, currentMap[dimension][safeY][safeX])
	end
end

local BoundlessParasolDoor = StageAPI.CustomDoor(
	"BoundlessParasolDoor",
	"gfx/grid/door_boundless.anm2",
	nil, nil, nil, nil,
	true,
	false,
	handleBoundlessDoorTransition,
	nil,
	RoomTransitionAnim.FADE_MIRROR
)

StageAPI.AddCallback("FiendFolio", "POST_SPAWN_CUSTOM_DOOR", 1, function(door, data, sprite, doorData, customGrid, force, respawning)
	local room = game:GetRoom()
	local isClear = room:IsClear() and not FiendFolio.GateCurseRoomShouldBeBarred
	StageAPI.SetDoorOpen(data.BoundlessParasolIsForcedOpen or isClear, door)

	if not sprite:IsPlaying("Idle") then
		sprite:Play("Idle", true)
	end
	sprite:SetFrame(boundlessDoorFrameTimer % 60)

	if forceFadeIn then
		data.BoundlessParasolFade = 0
	elseif isClear or data.DoorGridData.Slot == nextExitDoorSlot then
		data.BoundlessParasolFade = 1
	else
		data.BoundlessParasolFade = 0
	end
	sprite.Color = Color(1, 1, 1, data.BoundlessParasolFade * BOUNDARY_DOOR_MAX_ALPHA, 0, 0, 0)

	if data.DoorGridData.Slot == nextExitDoorSlot then
		nextExitDoorSlot = DoorSlot.NO_DOOR_SLOT
	end

	if respawning then
		handleBoundlessDoorResyncing(door, data, room)
	end
end, BoundlessParasolDoor.Name)

StageAPI.AddCallback("FiendFolio", "POST_CUSTOM_DOOR_UPDATE", 1, function(door, data, sprite, doorData, persistData)
	local room = game:GetRoom()
	local isClear = room:IsClear() and not FiendFolio.GateCurseRoomShouldBeBarred
	StageAPI.SetDoorOpen(data.BoundlessParasolIsForcedOpen or isClear, door)

	if not sprite:IsPlaying("Idle") then
		sprite:Play("Idle", true)
	end
	sprite:SetFrame(boundlessDoorFrameTimer % 60)

	if isClear then
		data.BoundlessParasolFade = math.min((data.BoundlessParasolFade or 0) + 1/30, 1)
	else
		data.BoundlessParasolFade = math.max((data.BoundlessParasolFade or 0) - 1/30, 0)
	end
	sprite.Color = Color(1, 1, 1, (data.BoundlessParasolFade or 0) * BOUNDARY_DOOR_MAX_ALPHA, 0, 0, 0)

	handleBoundlessDoorResyncing(door, data, room)
end, BoundlessParasolDoor.Name)

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function()
	local doors = Isaac.FindByType(EntityType.ENTITY_EFFECT, StageAPI.E.Door.V, -1, false, false)
	for _, door in ipairs(doors) do
		--Unsure if this is meant to be for doors? It was v:GetData() before and I have no clue what V actually is
		local data = mod:GetEntityData(door)
		if data.DoorGridData and data.DoorGridData.DoorDataName == BoundlessParasolDoor.Name then
			mod:GetEntityData(door).BoundlessParasolIsForcedOpen = true
		end
	end
end, CollectibleType.COLLECTIBLE_DADS_KEY)

local function makeBoundlessDoor(targetRoomIndex, targetDoorSlot, targetDoorIndex, targetExitDoorSlot)
	StageAPI.SpawnCustomDoor(
		targetDoorSlot,
		targetRoomIndex,
		nil,
		BoundlessParasolDoor.Name,
		nil,
		targetExitDoorSlot,
		nil, nil, nil,
		false
	)
end

local function hasBasegameOffgridDoor(index, doorSlot)
	local level = game:GetLevel()
	local levelStage = level:GetStage()
	local hasLabyrinthCurse = level:GetCurses() & LevelCurse.CURSE_OF_LABYRINTH == LevelCurse.CURSE_OF_LABYRINTH

	if index == level:GetStartingRoomIndex() and doorSlot == DoorSlot.UP0 then
		if ((levelStage == LevelStage.STAGE3_1 and hasLabyrinthCurse) or levelStage == LevelStage.STAGE3_2) and
		   Isaac.GetPersistentGameData():Unlocked(Achievement.A_STRANGE_DOOR) and not game:GetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH)
		then
			return true
		elseif levelStage == LevelStage.STAGE6 and Isaac.GetPersistentGameData():Unlocked(Achievement.ANGELS) then
			return true
		end
	end

	local levelStageType = level:GetStageType()
	local isAltPath = levelStageType == StageType.STAGETYPE_REPENTANCE or levelStageType == StageType.STAGETYPE_REPENTANCE_B
	if isAltPath then
		if ((levelStage == LevelStage.STAGE1_1 and hasLabyrinthCurse) or levelStage == LevelStage.STAGE1_2) then
			local roomDesc = level:GetRoomByIdx(index)
			local roomData = roomDesc.data
			if roomData == nil then return false end

			if roomData.Subtype == 34 then
				local roomSpawns = roomData.Spawns
				local doorSpawns = nil
				if doorSlot == DoorSlot.UP0 then
					doorSpawns = roomSpawns:Get(7)
				elseif doorSlot == DoorSlot.DOWN0 then
					doorSpawns = roomSpawns:Get(127)
				elseif doorSlot == DoorSlot.LEFT0 then
					doorSpawns = roomSpawns:Get(60)
				elseif doorSlot == DoorSlot.RIGHT0 then
					doorSpawns = roomSpawns:Get(74)
				end
				if doorSpawns == nil then return false end

				local doorEntry = doorSpawns:PickEntry(0)
				if doorEntry and
				   doorEntry.Type == EntityType.ENTITY_ENVIRONMENT and
				   doorEntry.Variant == 2
				then
					return true
				end
			end
		elseif ((levelStage == LevelStage.STAGE2_1 and hasLabyrinthCurse) or levelStage == LevelStage.STAGE2_2) then
			local roomDesc = level:GetRoomByIdx(index)
			local roomData = roomDesc.data
			if roomData == nil then return false end

			if roomData.Subtype == 10 then
				return doorSlot == DoorSlot.UP0
			end
		end
	end

	return false
end

local function checkIfBoundlessDoor(index, targetDoorSlot, targetDoorIndex, targetExitDoorSlot)
	if index ~= nil and targetDoorIndex ~= nil and targetDoorIndex > -1 then
		local room = game:GetRoom()
		local grid = room:GetGridEntity(targetDoorIndex)
		if (grid and grid:ToDoor()) or StageAPI.GetCustomDoorDataAtSlot(targetDoorSlot) or hasBasegameOffgridDoor(index, targetExitDoorSlot) then
			return
		end

		local level = game:GetLevel()
		local targetRoomDesc = level:GetRoomByIdx(index)
		local targetRoomType = targetRoomDesc.Data.Type

		local boundaryRoomType = ValidBoundaryRoomTypes[targetRoomType]
		local targetRoomWasVisited = targetRoomDesc.VisitedCount > 0
		local isFirstFloor = level:GetStage() == LevelStage.STAGE1_1
		if boundaryRoomType == BoundaryDoorAllowed.ALWAYS or
		   (boundaryRoomType == BoundaryDoorAllowed.VISITED and targetRoomWasVisited) or
		   (boundaryRoomType == BoundaryDoorAllowed.VISITED_IGNORE_FIRST_FLOOR and (targetRoomWasVisited or isFirstFloor))
		then
			if targetRoomType == RoomType.ROOM_MINIBOSS or
			   targetRoomType == RoomType.ROOM_ISAACS or
			   targetRoomType == RoomType.ROOM_BARREN
			then
				targetRoomDesc.DisplayFlags = targetRoomDesc.DisplayFlags | RoomDisplayFlags.VISIBLE
				targetRoomDesc.DisplayFlags = targetRoomDesc.DisplayFlags | RoomDisplayFlags.ROOM_SHADOW
				level:UpdateVisibility()

				makeBoundlessDoor(index, targetDoorSlot, targetDoorIndex, targetExitDoorSlot)
			else
				targetRoomDesc.DisplayFlags = targetRoomDesc.DisplayFlags | RoomDisplayFlags.VISIBLE
				targetRoomDesc.DisplayFlags = targetRoomDesc.DisplayFlags | RoomDisplayFlags.SHOW_ICON
				level:UpdateVisibility()

				makeBoundlessDoor(index, targetDoorSlot, targetDoorIndex, targetExitDoorSlot)
			end
		end
	end
end

local function checkIfBoundlessDoors(room)
	if room == nil then
		return
	end

	checkIfBoundlessDoor(room.NorthDoorRoomIndex, room.NorthDoorSlot, room.NorthDoorIndex, room.NorthExitDoorSlot)
	checkIfBoundlessDoor(room.SouthDoorRoomIndex, room.SouthDoorSlot, room.SouthDoorIndex, room.SouthExitDoorSlot)
	checkIfBoundlessDoor(room.WestDoorRoomIndex, room.WestDoorSlot, room.WestDoorIndex, room.WestExitDoorSlot)
	checkIfBoundlessDoor(room.EastDoorRoomIndex, room.EastDoorSlot, room.EastDoorIndex, room.EastExitDoorSlot)
end

local function handleBoundlessDoorSpawning()
	local level = game:GetLevel()
	local levelSeed = level:GetDungeonPlacementSeed()
	local dimension = level:GetDimension()
	if currentMap[dimension] == nil or currentMapSeed[dimension] ~= levelSeed then
		initializeMap()
	end
	currentMapSeed[dimension] = levelSeed

	local roomDesc = level:GetCurrentRoomDesc()
	local roomData = roomDesc.Data

	local roomType = roomData.Type
	if ValidBoundaryRoomTypes[roomType] == BoundaryDoorAllowed.NEVER then
		return
	end

	local roomShape = roomData.Shape
	local safeIndex = roomDesc.SafeGridIndex
	local safeY = math.floor(safeIndex / 13)
	local safeX = safeIndex % 13

	if safeIndex < 0 or safeIndex > 168 then -- offgrid room
		return
	end

	if roomShape == RoomShape.ROOMSHAPE_1x2 or
	   roomShape == RoomShape.ROOMSHAPE_IIV
	then
		checkIfBoundlessDoors(currentMap[dimension][safeY][safeX])
		checkIfBoundlessDoors(currentMap[dimension][safeY + 1][safeX])
	elseif roomShape == RoomShape.ROOMSHAPE_2x1 or
		   roomShape == RoomShape.ROOMSHAPE_IIH
	then
		checkIfBoundlessDoors(currentMap[dimension][safeY][safeX])
		checkIfBoundlessDoors(currentMap[dimension][safeY][safeX + 1])
	elseif roomShape == RoomShape.ROOMSHAPE_2x2 then
		checkIfBoundlessDoors(currentMap[dimension][safeY][safeX])
		checkIfBoundlessDoors(currentMap[dimension][safeY][safeX + 1])
		checkIfBoundlessDoors(currentMap[dimension][safeY + 1][safeX])
		checkIfBoundlessDoors(currentMap[dimension][safeY + 1][safeX + 1])
	elseif roomShape == RoomShape.ROOMSHAPE_LTL then
		checkIfBoundlessDoors(currentMap[dimension][safeY][safeX])
		checkIfBoundlessDoors(currentMap[dimension][safeY + 1][safeX - 1])
		checkIfBoundlessDoors(currentMap[dimension][safeY + 1][safeX])
	elseif roomShape == RoomShape.ROOMSHAPE_LTR then
		checkIfBoundlessDoors(currentMap[dimension][safeY][safeX])
		checkIfBoundlessDoors(currentMap[dimension][safeY + 1][safeX])
		checkIfBoundlessDoors(currentMap[dimension][safeY + 1][safeX + 1])
	elseif roomShape == RoomShape.ROOMSHAPE_LBL then
		checkIfBoundlessDoors(currentMap[dimension][safeY][safeX])
		checkIfBoundlessDoors(currentMap[dimension][safeY][safeX + 1])
		checkIfBoundlessDoors(currentMap[dimension][safeY + 1][safeX + 1])
	elseif roomShape == RoomShape.ROOMSHAPE_LBR then
		checkIfBoundlessDoors(currentMap[dimension][safeY][safeX])
		checkIfBoundlessDoors(currentMap[dimension][safeY][safeX + 1])
		checkIfBoundlessDoors(currentMap[dimension][safeY + 1][safeX])
	else
		checkIfBoundlessDoors(currentMap[dimension][safeY][safeX])
	end
end

mod:AddPriorityCallback(ModCallbacks.MC_POST_UPDATE, CallbackPriority.LATE + 1, function()
	local isGreedMode = game:IsGreedMode()
	local levelStage = game:GetLevel():GetStage()
	local isBlacklistedFloor = levelStage == LevelStage.STAGE4_3 or levelStage == LevelStage.STAGE8
	if not (isGreedMode or isBlacklistedFloor or game.Challenge == FiendFolio.challenges.theGauntlet) and mod.anyPlayerHas(mod.ITEM.COLLECTIBLE.BOUNDLESS_PARASOL) then
		forceFadeIn = true
		handleBoundlessDoorSpawning()
		forceFadeIn = false
	end

	boundlessDoorFrameTimer = boundlessDoorFrameTimer + 1
end)

mod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_ROOM, CallbackPriority.LATE + 1, function()
	if game:GetLevel():GetCurses() & LevelCurse.CURSE_OF_MAZE == LevelCurse.CURSE_OF_MAZE then
		-- lol
		currentMap = {}
		currentMapSeed = {}
	end

	local isGreedMode = game:IsGreedMode()
	local levelStage = game:GetLevel():GetStage()
	local isBlacklistedFloor = levelStage == LevelStage.STAGE4_3 or levelStage == LevelStage.STAGE8
	if not (isGreedMode or isBlacklistedFloor or game.Challenge == FiendFolio.challenges.theGauntlet) and mod.anyPlayerHas(mod.ITEM.COLLECTIBLE.BOUNDLESS_PARASOL) then
		local room = game:GetRoom()
		local customDoors = Isaac.FindByType(EntityType.ENTITY_EFFECT, StageAPI.E.Door.V)
		for _, door in ipairs(customDoors) do
			local data = mod:GetEntityData(door)
			if data.DoorGridData and data.DoorGridData.DoorDataName == "BoundlessParasolDoor" then
				handleBoundlessDoorResyncing(door, data, room)
			end
		end

		forceFadeIn = false
		handleBoundlessDoorSpawning()
	end
end)

mod:AddCallback(ModCallbacks.MC_PRE_LEVEL_PLACE_ROOM, function()
	currentMap = {}
	currentMapSeed = {}
end)