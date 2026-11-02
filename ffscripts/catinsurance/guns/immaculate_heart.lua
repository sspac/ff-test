local mod = FiendFolio
local synergy = {}

---@param player EntityPlayer
function synergy:OnImmaculateTear(tear, player, owner, params)
    if not params.FriendGun then
        return
    end

	tear.Velocity = tear.Velocity * 0.8
	local ammo = params.FriendAmmoUsed[mod:RandomInt(1, #params.FriendAmmoUsed)]
	if ammo.HeartKey == "IMMORAL_HEART" or ammo.ForceImmoral then
		local newammo = mod:makeCopiedTable(ammo)
		newammo.Crit = mod:RandomInt(100) < mod:GetFriendCritChance(player)
		ammo = newammo
	end
	mod:HandleFriendTears(player, params.FriendGun, tear, ammo)
end

mod:AddCallback(FiendFolio.CALLBACK.FF_POST_IMMACULATE_HEART, synergy.OnImmaculateTear)