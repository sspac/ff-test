local mod = FiendFolio
local sfx = SFXManager()

mod:AddCallback(ModCallbacks.MC_USE_PILL, function(_, effect, player, flags, pillColor)
    player:AnimateHappy()
    local useTimes = 1
    local holdingHorsePill = pillColor & PillColor.PILL_GIANT_FLAG > 0
    if holdingHorsePill then
        sfx:Play(SoundEffect.SOUND_THUMBSUP_AMPLIFIED, 1, 0, false, 1)
        sfx:Play(SoundEffect.SOUND_POWERUP_SPEWER_AMPLIFIED, 1, 0, false, 1)
        mod:trySayAnnouncerLine(mod.Sounds.VAPillHorseMorningAfter, flags, 60)
    else
        mod:trySayAnnouncerLine(mod.Sounds.VAPillMorningAfter, flags, 40)
    end
    local rng = player:GetPillRNG(effect)
    while rng:RandomInt(10) == 1 do
        useTimes = useTimes + 1
    end
    for i = 1, useTimes do
        if holdingHorsePill then
            player:AddInnateCollectible(CollectibleType.COLLECTIBLE_BROTHER_BOBBY, 1, mod.Name)
        else
            local bobby = Isaac.Spawn(3, mod.ITEM.FAMILIAR.FRAGILE_BOBBY, 0, player.Position, Vector.Zero, player)
            bobby:Update()
        end
        mod.scheduleForUpdate(function()
            sfx:Play(SoundEffect.SOUND_DERP, 1, 0, false, math.random(140,160)/100)
        end, 10 + (i * 10))
    end
end, mod.ITEM.PILL.MORNING_AFTER_PILL)
