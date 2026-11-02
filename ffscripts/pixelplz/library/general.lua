local mod = FiendFolio



-- Lerp to `Vector.Zero`
---@param vector Vector
---@param percent number? Defaults to `0.25`.
---@return Vector
function FiendFolio:StopLerp(vector, percent)
	---@type Vector
	return mod:Lerp(vector, Vector.Zero, percent or 0.25)
end



-- Get sign from a number / boolean
---@param value number | boolean
---@return integer sign 1 or -1
function FiendFolio:GetSign(value)
	if (type(value) == "number"  and value >= 1)
	or (type(value) == "boolean" and value == true) then
		return 1
	else
		return -1
	end
end



-- Clamp a vector
---@param vector Vector
---@param clampDegrees number
---@return Vector
function FiendFolio:ClampVector(vector, clampDegrees)
	local length = vector:Length()
	local timesClampDegree = vector:GetAngleDegrees() / clampDegrees
	timesClampDegree = mod:GoRoundNumber(timesClampDegree)
	return Vector.FromAngle(clampDegrees * timesClampDegree):Resized(length)
end



-- Get the mean of the given positions
---@param positions table Can be either entities or vectors.
---@return Vector
function FiendFolio:GetMeanPos(positions)
	local mean = Vector.Zero

	for i, entry in pairs(positions) do
		local pos = entry.Position or entry
		mean = mean + pos
	end
	return mean / #positions
end



-- Get the length of a table properly
---@param tbl table
---@return integer
function FiendFolio:GetTableLength(tbl)
	local amount = 0

	for _ in pairs(tbl) do
		amount = amount + 1
	end
	return amount
end



-- Better sound function (cool)
---@param entity EntityNPC? Optionally provide `nil` to play sound from SFXManager.
---@param id integer
---@param volume number? Default is `1`.
---@param pitch number? Default is `1`.
---@param cooldown integer? Also known as `FrameDelay`, default is `0`.
---@param loop boolean? Default is `false`.
---@param pan number? Default is `0`.
function FiendFolio:PlaySoundCool(entity, id, volume, pitch, cooldown, loop, pan)
	volume = volume or 1
	pitch = pitch or 1
	cooldown = cooldown or 0
	pan = pan or 0

	if entity then
		entity:ToNPC():PlaySound(id, volume, cooldown, loop or false, pitch)
	else
		SFXManager():Play(id, volume, cooldown, loop, pitch, pan)
	end
end



-- Approach a number with diminishing increase
---@param n number
---@param min_in number
---@param max_in number
---@param min_out number
---@param max_out number
---@param exponent number
---@return number
function FiendFolio:DiminishingValue(n, min_in, max_in, min_out, max_out, exponent)
	-- Unscale input
	n = n - min_in
	n = n / max_in - min_in

	n = n ^ exponent

	-- Scale output
	n = n * (max_out - min_out)
	n = n + min_out
	return n
end



-- Get a grid of positions based on the length of the given number
---@param length number
---@param gapSize? number The distance between each position. Default is `40`.
---@param maxPerRow? number The max number of positions in a row. Default is `10`.
---@param maxPerColumn? number The max number of positions in a column. Default is `10`.
---@return table
function FiendFolio:GetGridPositions(length, gapSize, maxPerRow, maxPerColumn)
	gapSize = gapSize or 40
	maxPerRow = maxPerRow or 10
	maxPerColumn = maxPerColumn or 10

	local positions = {}

	-- Get the number of rows
	local rows = math.ceil(length / maxPerRow)
	rows = math.min(maxPerColumn, rows)

	for y = 0, rows - 1 do
		local yOffset = y - (rows - 1) / 2
		yOffset = gapSize * yOffset

		-- Get the number of entries in this row
		local rowEntries = length - (y * maxPerRow)
		rowEntries = math.min(maxPerRow, rowEntries)

		for x = 1, rowEntries do
			local xOffset = gapSize * (x - rowEntries / 2) - (gapSize / 2)
			table.insert(positions, Vector(xOffset, yOffset))
		end
	end

	return positions
end