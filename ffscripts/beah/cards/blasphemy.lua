local mod = FiendFolio
local sfx = SFXManager()

local function useCard(_, _, player, flags)
    mod:AddInnateCollectibleForFloor(player, CollectibleType.COLLECTIBLE_DAMOCLES_PASSIVE)
    sfx:Play(SoundEffect.SOUND_POWERUP_SPEWER, 1, 0)

    player:TakeDamage(1, 0, EntityRef(Isaac.FindByType(1000)[1]), 0)
    mod:trySayAnnouncerLine(mod.Sounds.VACardSlayTheSpireBlasphemy, flags, 35)
end

mod:AddCallback(ModCallbacks.MC_USE_CARD, useCard, mod.ITEM.CARD.BLASPHEMY)