local mod = FiendFolio

function mod:EvioliteUpdate(player)
    if player:HasTrinket(mod.ITEM.TRINKET.EVIOLITE) then
        local d = mod:GetEntityData(player)
        local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.TRINKET.EVIOLITE)

        local count = player:GetCollectibleCount()
        if not d.EvioliteItemCount or d.EvioliteItemCount ~= count then
            local decayModifier = 1/(10+10*(math.max(0, mult-1)))
            d.EvioliteItemCount = count
            d.EvioliteItemDecay = math.max(0, 1-decayModifier*count)

            player:AddCacheFlags(CacheFlag.CACHE_ALL)
		    player:EvaluateItems()
        end
    end
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.TRINKET.EVIOLITE, mod.EvioliteUpdate)