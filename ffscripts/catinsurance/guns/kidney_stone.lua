local mod = FiendFolio
local synergy = {}

---@param player EntityPlayer
function synergy:PostFire(e, player)
    if player:GetPeeBurstCooldown() > 0 then
        return true
    end
end

mod:AddCallback("PRE_GUN_FIRE_CONSUME_AMMO", synergy.PostFire)

---@param player EntityPlayer
function synergy:UrethraBlocked(e, player)
    if player:IsUrethraBlocked() then
        return true
    end
end

mod:AddCallback("PRE_GUN_FIRE", synergy.UrethraBlocked)