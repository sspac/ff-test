local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

mod:AddCallback(FiendFolio.CALLBACK.FF_PRE_LEAD_PENCIL_FIRE_BURST, function(_, player, dir, owner, params)
	if not params.FriendGun then return end
	local gun = params.FriendGun
	local ammoUsed = params.FriendAmmoUsed
	
	local pData = mod:GetEntityData(player)

	-- Only trigger off friend's "primary" gun.
	if #ammoUsed == 0 or not pData.FriendsRevolver or gun.InitSeed ~= pData.FriendsRevolver.InitSeed then return end

	sfx:Play(mod.Sounds.ShotgunBlast, 1.0, 0, false, 1.0)
	for i=1,12 do
		local vel = dir:Resized(player.ShotSpeed * 10 * mod:RandomFloat(0.7, 0.8)):Rotated(mod:RandomInt(-20, 20))
		local ammo = params.FriendAmmoUsed[mod:RandomInt(1, #params.FriendAmmoUsed)]
		if ammo.HeartKey == "IMMORAL_HEART" or ammo.ForceImmoral then
			local newammo = mod:makeCopiedTable(ammo)
			newammo.Crit = mod:RandomInt(100) < mod:GetFriendCritChance(player)
			ammo = newammo
		end
		local tear = mod:FireFriendTear(gun, player, dir:Normalized(), mod.nilvector, vel, ammo, false)
	end
	return true
end)
