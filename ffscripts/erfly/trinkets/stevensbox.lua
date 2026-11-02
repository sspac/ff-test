local mod = FiendFolio

local lootListPickups = {
	[PickupVariant.PICKUP_CHEST] = true,
	[PickupVariant.PICKUP_BOMBCHEST] = true,
	[PickupVariant.PICKUP_SPIKEDCHEST] = true,
	[PickupVariant.PICKUP_ETERNALCHEST] = true,
	[PickupVariant.PICKUP_MIMICCHEST] = true,
	[PickupVariant.PICKUP_MEGACHEST] = true,
	[PickupVariant.PICKUP_HAUNTEDCHEST] = true,
	[PickupVariant.PICKUP_HAUNTEDCHEST] = true,
}
function mod:stevensBoxLootList(pickup, lootlist, shouldAdvance, rng)
	if lootListPickups[pickup.Variant] then
		local boxMult = mod.getTrinketMultiplierAcrossAllPlayers(mod.ITEM.TRINKET.STEVENS_BOX)
		local stevenChance = boxMult/3
        if rng:RandomFloat() <= stevenChance then
            lootlist:PushEntry(5, FiendFolio.PICKUP.VARIANT.STEVEN_HEART, 0)
        end
	end
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_PICKUP_GET_LOOT_LIST, mod.ITEM.TRINKET.STEVENS_BOX, mod.stevensBoxLootList)

mod.AddItemPickupCallback(function(player, added)
    if player:HasTrinket(mod.ITEM.TRINKET.STEVENS_BOX) then
        local hearts = Isaac.FindByType(5, -1, -1, false, false)
        for _, pickup in pairs(hearts) do
            if mod.HeartVariants[pickup.Variant] and pickup.Variant ~= FiendFolio.PICKUP.VARIANT.STEVEN_HEART then
                if pickup.FrameCount == 0 then
                    pickup:ToPickup():Morph(5, FiendFolio.PICKUP.VARIANT.STEVEN_HEART, 0, true)
                end
            end
        end
    end
end, nil, CollectibleType.COLLECTIBLE_BOX)