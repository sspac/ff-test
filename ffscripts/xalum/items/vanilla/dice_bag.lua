local mod = FiendFolio

mod.DiceBagAdditions = {
	{ID = mod.ITEM.COLLECTIBLE.D2},
	{ID = mod.ITEM.COLLECTIBLE.LOADED_D6},
	{ID = mod.ITEM.COLLECTIBLE.ETERNAL_D10, Weight = 0.5},
	{ID = mod.ITEM.COLLECTIBLE.DUSTY_D10, Weight = 0.25},
	{ID = mod.ITEM.COLLECTIBLE.AZURITE_SPINDOWN},

	-- Welcome Homer
	{ID = CollectibleType.COLLECTIBLE_SPINDOWN_DICE},
}

local function getUnlockedAdditionsTableWeight()
	local new = {}
	local weight = 0

	for _, data in pairs(mod.DiceBagAdditions) do
		if mod.IsItemUnlocked(data.ID) then
			table.insert(new, data)
			weight = weight + (data.Weight or 1)
		end
	end

	return new, weight
end

local function getWeightedEntry(pool, poolWeight, rng) -- God how many times must this kind of function exist in this mod lmao
	local roll = rng:RandomFloat() * poolWeight
	local item

	repeat
		item = pool[1].ID
		roll = roll - (pool[1].Weight or 1)
		table.remove(pool, 1)
	until roll < 0 or #pool == 0

	return item
end

mod.DICE_BAG_VANILLA_WEIGHT = 10
-- D1, D4, D6, D7, D8, D10, D12, D20, D100
-- Eternal D6

-- Excluded by Dice Bag:
--[[
	Spindown 
	D Infinity
]]

mod:AddCallback(ModCallbacks.MC_PRE_ADD_COLLECTIBLE, function(_, item, charge, first, slot, varData, player)
	if mod.DoVanillaItemTweaks and slot == ActiveSlot.SLOT_POCKET2 and player:HasTrinket(TrinketType.TRINKET_DICE_BAG) then
		local customPool, customWeight = getUnlockedAdditionsTableWeight()
		local poolWeight = mod.DICE_BAG_VANILLA_WEIGHT + customWeight
		local chance = customWeight / poolWeight
		local rng = player:GetTrinketRNG(TrinketType.TRINKET_DICE_BAG)

		if rng:RandomFloat() < chance then
			local newItem = getWeightedEntry(customPool, customWeight, rng) or item

			Isaac.CreateTimer(function()
				player:AnimateCollectible(newItem, "UseItem")
			end, 1, 1, false)

			return {newItem, charge, false, slot, varData}
		end
	end
end)