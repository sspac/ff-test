local mod = FiendFolio
local game = Game()

-- === Pandora's Box + Judas Birthright ===
-- Grants one of the following on use:
	-- Blood Puppy
	-- Dark Bum
	-- Demon Baby
	-- Incubus
	-- Lil Abaddon
	-- Lil Brimstone
	-- Succubus
	-- Twisted Pair

-- Removes items from the itempool on spawning
-- Checks against unlocks
-- If there are no valid items left to spawn, spawns Demon Baby

mod.JudasPandorasBoxAdditions = {
	mod.ITEM.COLLECTIBLE.LIL_LAMB,
	mod.ITEM.COLLECTIBLE.LIL_FIEND,
	mod.ITEM.COLLECTIBLE.LIL_FRIEND,
	mod.ITEM.COLLECTIBLE.SOUL_EXTRACTION_BUM,

	-- Love you <3
	CollectibleType.COLLECTIBLE_LIL_LOKI,
}

local vanillaItems = {
	CollectibleType.COLLECTIBLE_BLOOD_PUPPY,
	CollectibleType.COLLECTIBLE_DARK_BUM,
	CollectibleType.COLLECTIBLE_DEMON_BABY,
	CollectibleType.COLLECTIBLE_INCUBUS,
	CollectibleType.COLLECTIBLE_LIL_ABADDON,
	CollectibleType.COLLECTIBLE_LIL_BRIMSTONE,
	CollectibleType.COLLECTIBLE_SUCCUBUS,
	CollectibleType.COLLECTIBLE_TWISTED_PAIR,
}

local function getVanillaWeight()
	local weight = 0

	for _, item in pairs(vanillaItems) do
		if mod.IsItemUnlocked(item) and game:GetItemPool():HasCollectible(item) and not mod.MatchesAnyValue(item, mod.savedata.run.spawnedJudasPandoras or {}) then
			weight = weight + 1
		end
	end

	return weight
end

local function getCustomWeight()
	local options = {}

	for _, item in pairs(mod.JudasPandorasBoxAdditions) do
		if mod.IsItemUnlocked(item) and game:GetItemPool():HasCollectible(item) then
			table.insert(options, item)
		end
	end

	return #options, options
end

mod:AddPriorityCallback(ModCallbacks.MC_PRE_USE_ITEM, CallbackPriority.LATE, function(_, item, rng, player)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE) then
		mod.CatchJudasPandorasBox = player
	end
end, CollectibleType.COLLECTIBLE_BLUE_BOX)

mod:AddPriorityCallback(ModCallbacks.MC_USE_ITEM, CallbackPriority.IMPORTANT, function(_, item, rng, player)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE) then
		mod.CatchJudasPandorasBox = nil
	end
end, CollectibleType.COLLECTIBLE_BLUE_BOX)

mod:AddCollectibleCallback(ModCallbacks.MC_POST_PICKUP_INIT, CollectibleType.COLLECTIBLE_BIRTHRIGHT, function(_, pickup)
	if not mod.DoVanillaItemTweaks then return end

	if mod.CatchJudasPandorasBox then
		local vanillaWeight = getVanillaWeight()
		local customWeight, options = getCustomWeight()
		local totalWeight = vanillaWeight + customWeight

		local rng = mod.CatchJudasPandorasBox:GetCollectibleRNG(CollectibleType.COLLECTIBLE_BLUE_BOX)
		local roll = rng:RandomFloat() * totalWeight
		mod.CatchJudasPandorasBox = nil

		if roll < customWeight then
			local choice = options[rng:RandomInt(customWeight) + 1]
			local old = pickup.SubType
			pickup:Morph(pickup.Type, pickup.Variant, choice, true, true, false)

			local itempool = game:GetItemPool()
			itempool:RemoveCollectible(choice)
			itempool:ResetCollectible(old)
		else
			mod.savedata.run.spawnedJudasPandoras = mod.savedata.run.spawnedJudasPandoras or {}
			table.insert(mod.savedata.run.spawnedJudasPandoras, pickup.SubType)
		end
	end
end, PickupVariant.PICKUP_COLLECTIBLE)