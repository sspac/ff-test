local mod = FiendFolio
local sfx = SFXManager()

function mod:StainedCardHurt(player, damage, flag, source)
    if player:HasTrinket(mod.ITEM.TRINKET.STAINED_CARD) and not mod:isDamageSelfInflicted(flag, source) then
        local sd = mod:GetEntityData(player).ffsavedata.RunEffects
        local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.STAINED_CARD)
        sd.StainedCardDamage = (sd.StainedCardDamage or 0)+1/mult
        sfx:Play(SoundEffect.SOUND_MIRROR_BREAK, 0.5, 0, false, 3)
		player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
		player:EvaluateItems()
    end
end