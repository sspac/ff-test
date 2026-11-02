local mod = FiendFolio

local PENNY_MIN = 1
local PENNY_MAX = 4

local DIME_MIN = 4
local DIME_MAX = 12

function mod:pennyPickupStack(player, pickup, value)
	if player:HasTrinket(mod.ITEM.TRINKET.STACK_OF_PENNY) and pickup.SubType ~= mod.PICKUP.COIN.LIL_PENNY then
		value = math.max(0, math.min(value, 10))
		
		local minSpawn, maxSpawn
		
		if value < 1 then
			minSpawn = 0
			maxSpawn = math.ceil(value * PENNY_MAX)
		else
			local n = (value-1) / 9
			minSpawn = math.ceil(mod:Lerp(PENNY_MIN, DIME_MIN, n))
			maxSpawn = math.ceil(mod:Lerp(PENNY_MAX, DIME_MAX, n))
		end
		
		local bonus = (player:GetTrinketMultiplier(mod.ITEM.TRINKET.STACK_OF_PENNY) - 1)
		local numToSpawn = minSpawn + (pickup.InitSeed % (maxSpawn - minSpawn + 1)) + bonus
		
		for i=1, numToSpawn do
			local speed = 1.5 + 2.5 * pickup:GetDropRNG():RandomFloat()
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, mod.PICKUP.COIN.LIL_PENNY, pickup.Position, RandomVector() * speed, nil)
		end
	end
end
