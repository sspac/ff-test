local mod = FiendFolio
local IMMACULATE_BITS = 1984 -- dw about it

mod.ImmaculateConceptionItems = {
	mod.ITEM.COLLECTIBLE.CHERUB_CHUBBY,
	mod.ITEM.COLLECTIBLE.PAPAL_PAL,
	mod.ITEM.COLLECTIBLE.BABY_BELL,
}

local function getVanillaWeight(player)
	local weight = 5
	local owned = player:GetConceptionFamiliarFlags() & IMMACULATE_BITS
	return weight - mod.CountBits(owned)
end

local function getCustomWeight(player)
	local options = {}
	local given = player:GetInnateCollectibleGroup("FF_IMMACULATE")

	for _, item in pairs(mod.ImmaculateConceptionItems) do
		if not given[item] and mod.IsItemUnlocked(item) then
			table.insert(options, item)
		end
	end

	return #options, options
end

mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_GIVE_BIRTH_IMMACULATE, function(_, player, familiarFlag)
	if not mod.DoVanillaItemTweaks then return end

	local data = mod.GetPersistentPlayerData(player)
	local vanillaWeight = getVanillaWeight(player)
	local customWeight, options = getCustomWeight(player)
	local totalWeight = vanillaWeight + customWeight

	local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_IMMACULATE_CONCEPTION)
	local roll = rng:RandomFloat() * totalWeight

	if roll < customWeight then
		local choice = options[rng:RandomInt(customWeight) + 1]
		player:AddInnateCollectible(choice, 1, "FF_IMMACULATE")
		return false
	end
end)