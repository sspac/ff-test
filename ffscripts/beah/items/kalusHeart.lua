local mod = FiendFolio
local chance = 0.17

local function evalTearHitParam(_, player, tearParams)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.KALUS_HEART) then
        local rhearts = player:GetRottenHearts()
        local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.KALUS_HEART)
        if rng:RandomFloat() < chance*rhearts then
            tearParams.TearFlags = tearParams.TearFlags | TearFlags.TEAR_POISON
            tearParams.TearColor = tearParams.TearColor * Color.TearCommonCold
        end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_EVALUATE_TEAR_HIT_PARAMS, mod.ITEM.COLLECTIBLE.KALUS_HEART, evalTearHitParam)

FiendFolio.AddItemPickupCallback(function(player)
    player:AddRottenHearts(2)
end, nil, mod.ITEM.COLLECTIBLE.KALUS_HEART)

--heart replacement in replacements.lua