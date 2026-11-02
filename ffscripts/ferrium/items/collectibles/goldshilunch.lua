local mod = FiendFolio

function mod:goldShiLunchUpdate(player)
    if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.GOLDSHI_LUNCH) then
        local data = mod:GetEntityData(player)
        if data.GoldShipLunchCleared ~= not FiendFolio.IsActiveRoom() then
            player:AddCacheFlags(CacheFlag.CACHE_SPEED | CacheFlag.CACHE_SHOTSPEED)
            player:EvaluateItems()
        end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.COLLECTIBLE.GOLDSHI_LUNCH, mod.goldShiLunchUpdate)