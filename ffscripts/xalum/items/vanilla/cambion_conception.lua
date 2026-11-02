local mod = FiendFolio
local CAMBION_BITS = 30783 -- dw about it

mod.CambionConceptionItems = {
	CollectibleType.COLLECTIBLE_LIL_LOKI,
	mod.ITEM.COLLECTIBLE.LIL_LAMB,
	mod.ITEM.COLLECTIBLE.LIL_FIEND,
	mod.ITEM.COLLECTIBLE.LIL_FRIEND,
	mod.ITEM.COLLECTIBLE.SOUL_EXTRACTION_BUM,
}

local function getVanillaWeight(player)
	local weight = 6
	local gameData = Isaac.GetPersistentGameData()

	-- Idk why these are the only ones that need their unlocks to be added. Seems like an oversight but that's not my call
	if gameData:Unlocked(Achievement.LIL_ABADDON) then weight = weight + 1 end
	if gameData:Unlocked(Achievement.TWISTED_PAIR) then weight = weight + 1 end

	local owned = player:GetConceptionFamiliarFlags() & CAMBION_BITS
	return weight - mod.CountBits(owned)
end

local function getCustomWeight(player)
	local options = {}
	local given = player:GetInnateCollectibleGroup("FF_CAMBION")

	for _, item in pairs(mod.CambionConceptionItems) do
		if not given[item] and mod.IsItemUnlocked(item) then
			table.insert(options, item)
		end
	end

	return #options, options
end

mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_GIVE_BIRTH_CAMBION, function(_, player, familiarFlag)
	if not mod.DoVanillaItemTweaks then return end

	local data = mod.GetPersistentPlayerData(player)
	local vanillaWeight = getVanillaWeight(player)
	local customWeight, options = getCustomWeight(player)
	local totalWeight = vanillaWeight + customWeight

	local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_CAMBION_CONCEPTION)
	local roll = rng:RandomFloat() * totalWeight

	if roll < customWeight then
		local choice = options[rng:RandomInt(customWeight) + 1]
		player:AddInnateCollectible(choice, 1, "FF_CAMBION")
		return false
	end
end)