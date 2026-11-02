local mod = FiendFolio
local sfx = SFXManager()

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, card, player, flags)
    player:AddBlueFlies(3, player.Position, player)
    for _ = 1, 3 do
        player:ThrowBlueSpider(player.Position, player.Position + RandomVector() * 6)
        mod.ThrowFriendlySkuzz(player, RandomVector() * 2)
        mod:ThrowBlueBeetle(player)
        Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_SPIDER, mod.ITEM.FAMILIAR.BLUE_BABY_SPIDER_SUBTYPE, player.Position, Vector.Zero, player)
    end

    sfx:Play(SoundEffect.SOUND_BOIL_HATCH, 0.6, 0, false, 1.5)
    mod:trySayAnnouncerLine(mod.Sounds.VAObjectEggSack, flags, 20)
end, mod.ITEM.CARD.EGG_SACK)