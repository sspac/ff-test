local mod = FiendFolio
local game = Game()
local bifurcatedStars = mod.ITEM.TRINKET.BIFURCATED_STARS

-- todo:
--[[
	Devils Crown: Red Door Sprite
	2 Power: Alt-Path Semi-Hidden Multiple Choice
	3 Power: Reveal both items
]]

-- Returns a list of valid roomIndexes, which may be empty if there are no valid rooms
function mod.GoodQueryRoomTypeIndex(roomType, visited, returnListIndexInsteadOfSafeGridIndex)
	local valids = {}
	local ignoreVisisted = visited == nil
	local roomsList = game:GetLevel():GetRooms()

	for i = 1, #roomsList do
		local roomDesc = roomsList:Get(i-1)
		if roomDesc.Data.Type == roomType then
			if ignoreVisisted or (visited and roomDesc.VisitedCount > 0) or (not visited and roomDesc.VisitedCount == 0) then
				table.insert(valids, returnListIndexInsteadOfSafeGridIndex and roomDesc.ListIndex or roomDesc.SafeGridIndex)
			end
		end
	end

	return valids
end

local function revealBossRoom()
	local indexes = mod.GoodQueryRoomTypeIndex(RoomType.ROOM_BOSS, nil, true)
	local roomsList = game:GetLevel():GetRooms()
	for _, i in pairs(indexes) do
		local desc = roomsList:Get(i)
		desc.DisplayFlags = desc.DisplayFlags | 5 -- Visibility + "revealed"
	end

	game:GetLevel():UpdateVisibility()
end

local function getDefaultRoomDoor()
	local room = game:GetRoom()
	for i = 0, 7 do
		local door = room:GetDoor(i)
		if door and door.TargetRoomType == RoomType.ROOM_DEFAULT then
			return i
		end
	end
end

local function repositionPlayersAtDoor(door)
	if not door then return end -- Fuck you Curse of the Maze, eat shit and die

	for _, player in pairs(PlayerManager.GetPlayers()) do
		player.Position = door.Position + Vector(0, 40):Rotated(90 * (door.Direction - 1))
	end
end

mod:AddTrinketCallback(ModCallbacks.MC_POST_NEW_LEVEL, bifurcatedStars, revealBossRoom)
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, revealBossRoom, bifurcatedStars)
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, revealBossRoom, bifurcatedStars + TrinketType.TRINKET_GOLDEN_FLAG)

mod:AddTrinketCallback(ModCallbacks.MC_POST_ROOM_TRIGGER_CLEAR, bifurcatedStars, function()
	if game:GetRoom():GetType() ~= RoomType.ROOM_BOSS then return end

	local slot = getDefaultRoomDoor()
	if not slot then return end -- Triggers in the first boss room of an XL floor, not the 2nd

	for i = 1, 2 do
		for _, roomType in pairs({RoomType.ROOM_PLANETARIUM, RoomType.ROOM_TREASURE}) do
			local visited = i == 1 or nil
			local rooms = mod.GoodQueryRoomTypeIndex(roomType, visited)
			if #rooms > 0 then
				local rng = Isaac.GetPlayer():GetTrinketRNG(bifurcatedStars)
				local index = rooms[rng:RandomInt(#rooms) + 1]
				local door = game:GetRoom():GetDoor(slot)
				door:SetRoomTypes(RoomType.ROOM_BOSS, roomType)

				mod.savedata.run.level.bifurcation = {
					Source = game:GetLevel():GetCurrentRoomDesc().SafeGridIndex,
					SourceDoor = slot,
					TeleportOverride = door.TargetRoomIndex,
					TeleportTarget = index,
					TargetRoomType = roomType,
				}

				door.TargetRoomIndex = index

				return
			end
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_PRE_CHANGE_ROOM, function(_, index, dimension)
	if mod.savedata.run.level.bifurcation and mod.savedata.run.level.bifurcation.TeleportTarget == index then
		if game:GetRoom():GetType() == RoomType.ROOM_BOSS then
			mod.savedata.run.level.bifurcation.TeleportOverride = nil
			return {mod.savedata.run.level.bifurcation.TeleportTarget, dimension}
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	if mod.savedata.run.level.bifurcation then
		local currentRoom = game:GetLevel():GetCurrentRoomDesc().SafeGridIndex

		if currentRoom == mod.savedata.run.level.bifurcation.Source then
			game:GetRoom():GetDoor(mod.savedata.run.level.bifurcation.SourceDoor):SetRoomTypes(RoomType.ROOM_BOSS, mod.savedata.run.level.bifurcation.TargetRoomType) -- I hate writing readable code
		elseif currentRoom == mod.savedata.run.level.bifurcation.TeleportTarget then
			local slot = getDefaultRoomDoor() or level.EnterDoor
			if not slot then return end
			repositionPlayersAtDoor(game:GetRoom():GetDoor(slot))
		end
	end
end)