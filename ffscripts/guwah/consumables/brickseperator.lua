local mod = FiendFolio
local game = Game()
local rng = RNG()
local sfx = SFXManager()

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player)
    mod:GetEntityData(player).BrickSeperatorBuff = true
    player:UseActiveItem(CollectibleType.COLLECTIBLE_MEAT_CLEAVER, false, false, true, false, -1)
    player:AddCacheFlags(CacheFlag.CACHE_TEARFLAG | CacheFlag.CACHE_TEARCOLOR)
    player:EvaluateItems()
end, mod.ITEM.CARD.BRICK_SEPERATOR)

function mod:brickSeparatorTearHitParams(player, tearparams, weapontype, damagescale, teardisplacement, source)
	if mod:GetEntityData(player).BrickSeperatorBuff then
		mod:changeTearParamsVariant(tearparams, TearVariant.CUPID_BLUE, TearVariant.CUPID_BLOOD)
	end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_TEAR_HIT_PARAMS, mod.brickSeparatorTearHitParams)