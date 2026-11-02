local mod = FiendFolio

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player, flags)
    player:UseActiveItem(CollectibleType.COLLECTIBLE_D10, UseFlag.USE_NOANIM)
    player:UseActiveItem(CollectibleType.COLLECTIBLE_D12, UseFlag.USE_NOANIM)

    mod:trySayAnnouncerLine(SoundEffect.SOUND_DICE_SHARD, flags, 20)
end, mod.ITEM.CARD.D10_SHARD)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player, flags)
    player:UseActiveItem(CollectibleType.COLLECTIBLE_ETERNAL_D6, UseFlag.USE_NOANIM)
    player:UseActiveItem(mod.ITEM.COLLECTIBLE.ETERNAL_D10, UseFlag.USE_NOANIM)
    player:UseActiveItem(mod.ITEM.COLLECTIBLE.ETERNAL_D12, UseFlag.USE_NOANIM)

    mod:trySayAnnouncerLine(SoundEffect.SOUND_DICE_SHARD, flags, 20)
end, mod.ITEM.CARD.ETERNAL_SHARD)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player, flags)
    player:UseActiveItem(CollectibleType.COLLECTIBLE_D8, UseFlag.USE_NOANIM)
    player:UseActiveItem(CollectibleType.COLLECTIBLE_D4, UseFlag.USE_NOANIM)

    mod:trySayAnnouncerLine(SoundEffect.SOUND_DICE_SHARD, flags, 20)
end, mod.ITEM.CARD.D8_SHARD)

local function addDiceShard(_, _, pickup)
    if pickup.SubType == mod.ITEM.CARD.D10_SHARD
    or pickup.SubType == mod.ITEM.CARD.ETERNAL_SHARD
    or pickup.SubType == mod.ITEM.CARD.D8_SHARD then
        return {
            BagOfCraftingPickup.BOC_DICE_SHARD
        }
    end
end
mod:AddCallback(ModCallbacks.MC_TRY_ADD_TO_BAG_OF_CRAFTING, addDiceShard, PickupVariant.PICKUP_TAROTCARD)