local mod = FiendFolio

function mod:SideWaysOnionUpdate(player)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.SIDEWAYS_ONION) then
        local d = mod:GetEntityData(player)
        local headDir = player:GetHeadDirection()
        local real = headDir % 2 == 0
        if real then
            if not d.SidewaysOnionActive then
                d.SidewaysOnionActive = true
                player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
                player:EvaluateItems()
            end
        elseif d.SidewaysOnionActive then
            d.SidewaysOnionActive = nil
            player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
            player:EvaluateItems()
        end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.COLLECTIBLE.SIDEWAYS_ONION, mod.SideWaysOnionUpdate)