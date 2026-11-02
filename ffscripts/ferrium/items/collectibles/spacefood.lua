local mod = FiendFolio

function mod:SpaceFoodOnAdd(_, _, firstTime, _, _, player)
    if firstTime then
        local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.SPACE_FOOD)
        if rng:RandomInt(2) == 0 then
            local allergicDurationMinutes = 3
            player:AddInnateCollectible(CollectibleType.COLLECTIBLE_EVIL_CHARM, 1, "FF_SPACE_FOOD", 30 * 60 * allergicDurationMinutes, false)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.SpaceFoodOnAdd, mod.ITEM.COLLECTIBLE.SPACE_FOOD)

mod:AddCallback(ModCallbacks.MC_PRE_PLANETARIUM_APPLY_ITEMS, function(_, chance)
    local mult = mod.getCollectibleMultiplierAcrossAllPlayers(mod.ITEM.COLLECTIBLE.SPACE_FOOD, false)
    return chance + 0.1*mult
end)
