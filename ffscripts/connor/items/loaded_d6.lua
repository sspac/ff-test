local mod = FiendFolio
local game = Game()

function mod:getLoadedDiceCandidateItems(player)
	local itemConfig = Isaac.GetItemConfig()

	local candidateItems = {}

	-- Get all stackable items that the player is holding.
	for id, _ in pairs(mod:GetStackableItemsTable()) do
		if player:HasCollectible(id, true) then
			table.insert(candidateItems, id)
		end
	end

	if #candidateItems == 0 then
		-- Player has no confirmed "stackable" items. Fall back to any items that they're holding.
		for id=1, itemConfig:GetCollectibles().Size-1 do
			local item = itemConfig:GetCollectible(id)
			if item and item.Type ~= ItemType.ITEM_ACTIVE and not item:HasTags(ItemConfig.TAG_QUEST) and player:HasCollectible(id, true) then
				table.insert(candidateItems, id)
			end
		end
	end

	return candidateItems
end

function mod:loadedD6(_, rng, player, useFlags, activeSlot)
	local itemConfig = Isaac.GetItemConfig()

	-- Get all the items we could choose to "reroll" into.
	local candidateItems = mod:getLoadedDiceCandidateItems(player)

	-- Find all item pedestals that we can reroll.
	local pedestalsToReroll = {}
	for _, pedestal in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
		local pedestal = pedestal:ToPickup()
		if pedestal.SubType > 0 and pedestal:CanReroll() and pedestal.SubType ~= CollectibleType.COLLECTIBLE_DADS_NOTE then
			table.insert(pedestalsToReroll, pedestal)
		end
	end

	if #pedestalsToReroll > 0 and #candidateItems > 0 then
		-- Reroll all eligible pedestals into copies of items the player is already holding.
		for _, pedestal in pairs(pedestalsToReroll) do
			local roll = rng:RandomInt(#candidateItems)+1
			local newItem = candidateItems[roll]

			if newItem == pedestal.SubType and #candidateItems > 0 then
				-- Rolled the same item as whats already on the pedestal.
				-- Try to just use the next candidate in the list.
				roll = (roll == #candidateItems) and 1 or (roll+1)
				newItem = candidateItems[roll]
			end

			-- Morph removes the effects of Tainted Isaac and Glitched Crown entirely.
			-- That is acceptable in this case.
			pedestal.Touched = false
			pedestal:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, newItem, true, true, true)

			Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, pedestal.Position, Vector.Zero, nil)
		end
	end

	SFXManager():Play(mod.TempSoundEnums.D6Roll)
	return {ShowAnim = true}
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.loadedD6, mod.ITEM.COLLECTIBLE.LOADED_D6)
