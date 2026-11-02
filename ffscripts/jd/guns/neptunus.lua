local mod = FiendFolio

--[[FiendFolio.AddItemPickupCallback(function(player)
    mod:CheckAgainstCurrentGun(player, CollectibleType.COLLECTIBLE_NEPTUNUS)
end, nil, CollectibleType.COLLECTIBLE_NEPTUNUS)]]

mod:AddCallback("POST_GUN_FIRE_TEAR", function(_, gun, player, tear)
    if mod:ShouldRunSynergy(player, gun, CollectibleType.COLLECTIBLE_NEPTUNUS) then
		local pd = mod:GetEntityData(player)
		local maxammo = #mod:GetFriendAmmo(gun)
		local ammo = #pd.FriendHeldGuns[gun.InitSeed].Ammo
		local ammopercent = ammo/maxammo
		local rng = gun:GetDropRNG()
		
		if ammo ~= maxammo then
			tear.Velocity = tear.Velocity+mod:TrueRandomVector(rng):Resized(4.4*ammopercent-(player.TearRange*0.007))
		end
	end
end)

mod:AddCallback("PRE_GUN_FIRE_CONSUME_AMMO", function(_, gun, player, shot, gd)
    if mod:ShouldRunSynergy(player, gun, CollectibleType.COLLECTIBLE_NEPTUNUS) then
		local pd = mod:GetEntityData(player)
		local maxammo = #mod:GetFriendAmmo(gun)
		local ammo = #pd.FriendHeldGuns[gun.InitSeed].Ammo
		local rng = gun:GetDropRNG()
		if rng:RandomFloat() < 0.33 and ammo < maxammo then
			gd.FriendConserveAmmo = gd.FriendConserveAmmo or 0
			gd.FriendConserveAmmo = gd.FriendConserveAmmo + 1
		end
	end
end)

mod:AddCallback("POST_GUN_FIRE", function (_, gun, player, aim, ammoUsed)
    if mod:ShouldRunSynergy(player, gun, CollectibleType.COLLECTIBLE_NEPTUNUS) then
		local pd = mod:GetEntityData(player)
		local maxammo = #mod:GetFriendAmmo(gun)
		local ammo = #pd.FriendHeldGuns[gun.InitSeed].Ammo
		local ammopercent = ammo/maxammo
		pd.FriendHeldGuns[gun.InitSeed].LastFrameFired = pd.FriendHeldGuns[gun.InitSeed].LastFrameFired - math.ceil(ammopercent*5)
	end
end)