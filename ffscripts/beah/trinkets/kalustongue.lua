local mod = FiendFolio

local variants = {
    [HeartSubType.HEART_HALF] = true,
    [HeartSubType.HEART_FULL]  = true,
    [HeartSubType.HEART_DOUBLEPACK] = true,
    [HeartSubType.HEART_BLENDED] = true,
    [HeartSubType.HEART_SCARED] = true,
}

mod:AddTrinketCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, mod.ITEM.TRINKET.KALUS_TONGUE, function (_, pickup, p)
    if not variants[pickup.SubType] then
        return
    end

    p = p:ToPlayer()
    if pickup:IsDead() and p then
        local data = mod:GetEntityData(p).ffsavedata.RunEffects
        data.kalusTongueBuff = math.min(10, (data.kalusTongueBuff or 0) + 1)
    end
end, PickupVariant.PICKUP_HEART)


local function applyDevil(_,chance)
    for index, player in ipairs(mod:GetAllPlayers()) do
        if player:HasTrinket(mod.ITEM.TRINKET.KALUS_TONGUE) then
            local data = mod:GetEntityData(player).ffsavedata.RunEffects
            if data.kalusTongueBuff then
                chance = chance+(data.kalusTongueBuff*0.015*player:GetTrinketMultiplier(mod.ITEM.TRINKET.KALUS_TONGUE))
            end
        end
    end
    return chance
end
mod:AddTrinketCallback(ModCallbacks.MC_PRE_DEVIL_APPLY_ITEMS, mod.ITEM.TRINKET.KALUS_TONGUE, applyDevil)