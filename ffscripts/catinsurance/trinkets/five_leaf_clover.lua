local mod = FiendFolio
local dontEval = false

function mod:FiveLeafCloverCache(player, flag)
    if player:HasTrinket(FiendFolio.ITEM.TRINKET.FIVE_LEAF_CLOVER) and not dontEval then
        dontEval = true
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        player:EvaluateItems()
        dontEval = false
    end
end

mod:AddTrinketCallback(ModCallbacks.MC_EVALUATE_CACHE, FiendFolio.ITEM.TRINKET.FIVE_LEAF_CLOVER, mod.FiveLeafCloverCache, CacheFlag.CACHE_LUCK)