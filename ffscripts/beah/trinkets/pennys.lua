local mod = FiendFolio

local stewPennies = { mod.ITEM.TRINKET.TEARS_PENNY, mod.ITEM.TRINKET.DAMAGE_PENNY, mod.ITEM.TRINKET.LUCK_PENNY }
function mod:BeahPennyPickup(pickup, player, value)
    local vmult = math.max(1, value/2.7)
    for _, t in ipairs(stewPennies) do
        if player:HasTrinket(t) then
            local effects = player:GetEffects()
            effects:AddTrinketEffect(t, true, math.floor(30*vmult*player:GetTrinketMultiplier(t)))
        end 
    end

    if player:HasTrinket(mod.ITEM.TRINKET.CONSTELLATION_PENNY) then
        local m = player:GetTrinketMultiplier(mod.ITEM.TRINKET.CONSTELLATION_PENNY)
		local p_data = mod:GetEntityData(player).ffsavedata.RunEffects
        p_data.constellationPennyBoosts = (p_data.constellationPennyBoosts or 0) + math.max(1,m)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function (_, player)
    if player.FrameCount % 30 ~= 0 then
        return
    end
    local effects = player:GetEffects()
    for index, value in ipairs(stewPennies) do
        effects:RemoveTrinketEffect(value, 1)
    end
end)

mod:AddCallback(ModCallbacks.MC_PRE_PLANETARIUM_APPLY_ITEMS, function(_, chance)
    local c = 0
    for _, player in ipairs(mod:GetAllPlayers()) do
		local p_data = mod:GetEntityData(player).ffsavedata.RunEffects
        if p_data.constellationPennyBoosts then
            c = c + p_data.constellationPennyBoosts*0.004
        end
    end
    return chance+c
end)
