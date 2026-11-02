local mod = FiendFolio



-- Get the real center of the room (for L shaped rooms)
---@return Vector
function FiendFolio:GetRoomCenter()
	local room = Game():GetRoom()

	if room:GetRoomShape() > RoomShape.ROOMSHAPE_2x2 then
		return Vector(580, 420)
	else
		return room:GetCenterPos()
	end
end



-- Align the given position to the center of the grid
---@return Vector
function FiendFolio:GetGridAlignedPos(pos)
	local room = Game():GetRoom()
	local grindex = room:GetGridIndex(pos)
	return room:GetGridPosition(grindex)
end



-- Get the mirrored version of the given position
---@param position Vector The position to mirror.
---@param center Vector? The point to mirror the position around. Defaults to the room's center.
---@return Vector
function FiendFolio:GetMirroredPosition(position, center)
	center = center or mod:GetRoomCenter()
	return (center - position) + center
end



-- Check if the room is thin
---@return boolean
function FiendFolio:IsRoomThin()
	local shape = Game():GetRoom():GetRoomShape()

	return shape == RoomShape.ROOMSHAPE_IH  or shape == RoomShape.ROOMSHAPE_IV
		or shape == RoomShape.ROOMSHAPE_IIV or shape == RoomShape.ROOMSHAPE_IIH
end



-- Check if the current floor has Mom as the boss
---@return boolean
function FiendFolio:IsMomFloor()
	local level = Game():GetLevel()

	if level:GetCurses() & LevelCurse.CURSE_OF_LABYRINTH > 0 then
		return level:GetStage() == LevelStage.STAGE3_1
	else
		return level:GetStage() == LevelStage.STAGE3_2
	end
end