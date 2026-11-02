local mod = FiendFolio

function mod:HingeCache(player, data)
    local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.HINGE)
    if not data.ffsavedata.HingeFamiliar then
        --local fMult = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.LIL_FIEND)+player:GetEffects():GetCollectibleEffectNum(mod.ITEM.COLLECTIBLE.LIL_FIEND)
        --player:CheckFamiliar(mod.ITEM.FAMILIAR.LIL_FIEND, mult+fMult, player:GetTrinketRNG(mod.ITEM.TRINKET.HINGE), Isaac:GetItemConfig():GetTrinket(mod.ITEM.TRINKET.HINGE), 0)
        data.ffsavedata.HingeFamiliar = 0

        player:CheckFamiliar(mod.ITEM.FAMILIAR.LIL_FIEND, mod.GetExpectedFamiliarNum(player, mod.ITEM.COLLECTIBLE.LIL_FIEND)+mult, 
            player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.LIL_FIEND), Isaac.GetItemConfig():GetCollectible(mod.ITEM.COLLECTIBLE.LIL_FIEND))
    else
        if data.ffsavedata.HingeFamiliar == 1 then
            player:CheckFamiliar(mod.ITEM.FAMILIAR.LIL_FRIEND, mod.GetExpectedFamiliarNum(player, mod.ITEM.COLLECTIBLE.LIL_FRIEND)+mult, 
                player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.LIL_FRIEND), Isaac.GetItemConfig():GetCollectible(mod.ITEM.COLLECTIBLE.LIL_FRIEND))
            --local frMult = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.LIL_FRIEND)+player:GetEffects():GetCollectibleEffectNum(mod.ITEM.COLLECTIBLE.LIL_FRIEND)
            --player:CheckFamiliar(mod.ITEM.FAMILIAR.LIL_FRIEND, mult+frMult, player:GetTrinketRNG(mod.ITEM.TRINKET.HINGE), Isaac:GetItemConfig():GetTrinket(mod.ITEM.TRINKET.HINGE), 0)
        else
            player:CheckFamiliar(mod.ITEM.FAMILIAR.LIL_FIEND, mod.GetExpectedFamiliarNum(player, mod.ITEM.COLLECTIBLE.LIL_FIEND)+mult, 
                player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.LIL_FIEND), Isaac.GetItemConfig():GetCollectible(mod.ITEM.COLLECTIBLE.LIL_FIEND))
            --[[local fMult = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.LIL_FIEND)+player:GetEffects():GetCollectibleEffectNum(mod.ITEM.COLLECTIBLE.LIL_FIEND)
            player:CheckFamiliar(mod.ITEM.FAMILIAR.LIL_FIEND, mult+fMult, player:GetTrinketRNG(mod.ITEM.TRINKET.HINGE), Isaac:GetItemConfig():GetTrinket(mod.ITEM.TRINKET.HINGE), 0)]]
        end
    end
end

function mod:HingeNewRoom(player, data)
    if player:HasTrinket(mod.ITEM.TRINKET.HINGE) then
        data.ffsavedata.HingeFamiliar = data.ffsavedata.HingeFamiliar or 0
        if data.ffsavedata.HingeFamiliar == 0 then
            data.ffsavedata.HingeFamiliar = 1
        else
            data.ffsavedata.HingeFamiliar = 0
        end
        player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS)
        player:EvaluateItems()
    end
end
mod:AddTrinketCallback("FF_NEW_ROOM_PLAYER_FERRIUM", mod.ITEM.TRINKET.HINGE, mod.HingeNewRoom)