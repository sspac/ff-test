local mod = FiendFolio
local card = mod.ITEM.CARD.REDACTED_TRIANGLE

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, _, player, flags)
	local itemConfig = Isaac.GetItemConfig()

	for _, item in pairs(Isaac.FindByType(5, 100)) do
		if item.SubType > 0 then
			local configItem = itemConfig:GetCollectible(item.SubType)

			if configItem.Type == ItemType.ITEM_ACTIVE then
				player:UseActiveItem(item.SubType, UseFlag.USE_NOANIM)
			elseif configItem:HasTags(ItemConfig.TAG_SUMMONABLE) then
				FiendFolio:AddInnateCollectibleForFloor(player, item.SubType, 1, true)
			end
		end

		Isaac.Spawn(1000, 15, 0, item.Position, Vector.Zero, nil)
	end
	mod:trySayAnnouncerLine(mod.Sounds.VACardRedactedTriangle, flags, 30)
end, card)