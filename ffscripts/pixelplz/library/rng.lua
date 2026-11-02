local mod = FiendFolio



-- Global, generic RNG
mod.GlobalRNG = RNG()

local function postGameStarted()
	local seed = Game():GetSeeds():GetStartSeed()
	mod.GlobalRNG:SetSeed(seed)
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, postGameStarted)



-- General RNG function
---@param min number? You may only omit this if you're also omitting `max`, which will make it use `RandomFloat()`.
---@param max number? Omit when providing a `min` for `rng:RandomInt(min + 1)`.
---@param rng RNG? Omit to use a generic RNG object.
function FiendFolio:Random(min, max, rng)
	rng = rng or mod.GlobalRNG

	-- Float
	if not min and not max then
		return rng:RandomFloat()

	-- Integer
	elseif min and not max then
		return rng:RandomInt(min + 1)

	-- Range
	else
		local difference = math.abs(min)

		-- For ranges with negative numbers
		if min < 0 then
			max = max + difference
			return rng:RandomInt(max + 1) - difference
		-- For positive only
		else
			max = max - difference
			return rng:RandomInt(max + 1) + difference
		end
	end
end



-- Get a vector with a random angle
---@param length number? Omit to get a unit vector.
function FiendFolio:RandomVector(length)
	local vector = RandomVector()

	if length then
		vector = vector:Resized(length)
	end
	return vector
end



-- Get a random sign
---@return integer -1 or 1.
function FiendFolio:RandomSign()
	if mod:Random(1) == 0 then
		return -1
	end
	return 1
end



-- Get a random index from a table
---@param fromTable table An array.
---@param rng RNG? Omit to use a generic RNG object.
---@return any
function FiendFolio:RandomIndex(fromTable, rng)
	return fromTable[ mod:Random(1, #fromTable, rng) ]
end