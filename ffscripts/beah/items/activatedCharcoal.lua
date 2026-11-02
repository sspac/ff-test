local mod = FiendFolio
local sfx = SFXManager()

local function useItem(_, id, rng, player, flags)
    mod:AddInnateCollectibleForRoom(player, CollectibleType.COLLECTIBLE_IPECAC)
    mod:CheckAgainstCurrentGun(player, CollectibleType.COLLECTIBLE_IPECAC)
    sfx:Play(SoundEffect.SOUND_POWERUP1, 1, 0)

    --dmg up is handled in xml
    return true
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, useItem, mod.ITEM.COLLECTIBLE.ACTIVATED_CHARCOAL)