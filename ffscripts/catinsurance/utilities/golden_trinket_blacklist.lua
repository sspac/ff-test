local mod = FiendFolio
-- unfinished
function mod:SetSpecialTrinketBlacklisted(trinketId, bool)
    local realId = mod:GetRealTrinketId(trinketId)
    if bool then
        mod.SpecialTrinketBlacklist[realId] = true
    else
        mod.SpecialTrinketBlacklist[realId] = nil
    end
end

function mod:IsSpecialTrinketBlacklisted(trinketId)
    local realId = mod:GetRealTrinketId(trinketId)
    return mod.SpecialTrinketBlacklist[realId] == true
end

---@param pickup EntityPickup
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function (_, pickup)
    local realId = mod:GetRealTrinketId(pickup.SubType)
    if realId ~= pickup.SubType then
        pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, realId, true, true, false)
        
        local sprite = pickup:GetSprite()
        sprite:SetRenderFlags(sprite:GetRenderFlags() ~ AnimRenderFlags.GOLDEN)
    end
end, PickupVariant.PICKUP_TRINKET)

---@param player EntityPlayer
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, function(_, player, trinketId, firstTimePickingUp)
    local realId = mod:GetRealTrinketId(trinketId)
    if realId ~= trinketId then
        player:TryRemoveTrinket(trinketId)
        player:AddTrinket(realId, firstTimePickingUp)
    end
end)