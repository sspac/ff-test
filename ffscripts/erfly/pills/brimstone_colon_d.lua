local mod = FiendFolio
local sfx = SFXManager()

--Shitpost
mod:AddCallback(ModCallbacks.MC_USE_PILL, function(_, effect, player, flags, pillColor)
    player:AnimateHappy()
    local useTimes = 1
    local holdingHorsePill = pillColor & PillColor.PILL_GIANT_FLAG > 0
    if holdingHorsePill then
        useTimes = 2
        sfx:Play(SoundEffect.SOUND_POWERUP_SPEWER_AMPLIFIED, 1, 0, false, 1)
        mod:trySayAnnouncerLine(mod.Sounds.VAPillHorseBrimstone, flags, 50)
    else
        mod:trySayAnnouncerLine(mod.Sounds.VAPillBrimstone, flags, 30)
    end
    player:AddInnateCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE, useTimes, mod.Name)
end, mod.ITEM.PILL.BRIMSTONE)