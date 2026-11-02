local mod = FiendFolio
local game = Game()

local secondaryFlag = mod:AddSecondaryFireTearFlag("FUSHIGI", true)
mod:AddPriorityTrinketCallback(FiendFolio.CALLBACK.FF_SECONDARY_FIRE_TEAR_EFFECTS, 1, FiendFolio.ITEM.TRINKET.FUSHIGI, function(_, tear, player, dir, source, flags)
	if flags & secondaryFlag == 0 and player:HasTrinket(FiendFolio.ITEM.TRINKET.FUSHIGI) then
		if mod:BasicRoll(player.Luck, 9, 0.4 + player:GetTrinketMultiplier(mod.ITEM.TRINKET.FUSHIGI)*0.1) then
			mod:FireFushigiTear(tear, player, source, nil, dir, flags)
			return flags | secondaryFlag
		end
	end
end)

mod:AddPriorityTrinketCallback(FiendFolio.CALLBACK.FF_SECONDARY_FIRE, 1, FiendFolio.ITEM.TRINKET.FUSHIGI, function(_, player, dir, amount, owner, params)
	if player:HasTrinket(mod.ITEM.TRINKET.FUSHIGI) then
		local weaponType = params.WeaponType
		local modifiers = params.WeaponModifiers
		local charge = params.WeaponCharge
		local maxFireDelay = params.WeaponMaxFireDelay
		local numTears = params.NumTears
		local d = mod:GetEntityData(player)
		if d.preventFushigiFire == true then
			d.preventFushigiFire = nil
			return
		end
		if not params.ForceTearEffects and
		   ((weaponType == WeaponType.WEAPON_TEARS and not (params.GatlingGun or params.SwallowedM90 or params.RapidFireOpal)) or 
		    weaponType == WeaponType.WEAPON_TEARS or 
		    weaponType == WeaponType.WEAPON_BOMBS or
		    weaponType == WeaponType.WEAPON_MONSTROS_LUNGS or
		    (weaponType == WeaponType.WEAPON_BONE and modifiers & WeaponModifier.MONSTROS_LUNG == WeaponModifier.MONSTROS_LUNG and charge >= maxFireDelay * 2) or
		    (weaponType == WeaponType.WEAPON_SPIRIT_SWORD and params.FriendGun and params.IsFriendChargedSlash))
		then
			d.preventFushigiFire = nil
			return 
		end
		local isMonstrosLung = (weaponType == WeaponType.WEAPON_MONSTROS_LUNGS or modifiers & WeaponModifier.MONSTROS_LUNG == WeaponModifier.MONSTROS_LUNG) and 
		                       weaponType ~= WeaponType.WEAPON_URN_OF_SOULS and weaponType ~= WeaponType.WEAPON_SPIRIT_SWORD and weaponType ~= WeaponType.WEAPON_FETUS
		
		local numProcs = 0
		for i = 1, numTears do
			if mod:BasicRoll(player.Luck, 9, 0.4 + player:GetTrinketMultiplier(mod.ITEM.TRINKET.FUSHIGI)*0.1) then
				numProcs = numProcs + 1
			end
		end
		numProcs = math.max(numProcs - (d.preventFushigiFire or 0), 0)
		
		for i = 1, numProcs do
			local pos = Vector(0,0)
			local vel = nil
			if isMonstrosLung then
				local a = mod:getSign(rng) * rng:RandomFloat()
				local b = (mod:getSign(rng) * rng:RandomFloat() * math.pi) * 2
				
				local x = math.cos(b) * a * 3.5 + player.ShotSpeed * dir:Resized(player.TearRange / 20).X;
				local y = math.sin(b) * a * 3.5 + player.ShotSpeed * dir:Resized(player.TearRange / 20).Y;
				
				vel = Vector(x,y)
			else
				pos, vel = mod:GetMultiShotPositionVelocityBasic(dir * 10 + player:GetTearMovementInheritance(dir), player.ShotSpeed, numProcs, i - 1)
			end
			mod:FireFushigiTear(nil, player, owner, nil, vel, nil, pos)
		end
		
		d.preventFushigiFire = nil
	end
end)

function mod:FushigiOnFireBomb(player, bomb)
	if player:HasTrinket(mod.ITEM.TRINKET.FUSHIGI) and mod:BasicRoll(player.Luck, 9, 0.4 + player:GetTrinketMultiplier(mod.ITEM.TRINKET.FUSHIGI)*0.1) then
		bomb:SetExplosionCountdown(60)
		bomb:AddTearFlags(TearFlags.TEAR_OCCULT)
		bomb.ExplosionDamage = bomb.ExplosionDamage * 2
	end
end

function mod:FireFushigiTear(tear, player, source, spawnNew, dir, flags, posOffset)
	local flags = flags or 0
	local aimdirection = dir or player:GetAimDirection()
	local isNewTear = tear == nil or spawnNew
	if isNewTear then
		if flags & mod.SecondaryFireTearFlags.RECURSIVE ~= 0 then return end
		tear = mod:SpawnPlayerTear(player, ((source and source.Position) or player.Position) + (posOffset or Vector(0,0)), aimdirection:Resized(player.ShotSpeed * 10))
	end

	tear:ChangeVariant(TearVariant.METALLIC)
	tear:AddTearFlags(TearFlags.TEAR_OCCULT)
	if not player:HasCollectible(CollectibleType.COLLECTIBLE_EYE_OF_THE_OCCULT) then
		tear.FallingAcceleration = tear.FallingAcceleration * 0.705
	end
	tear.Velocity = aimdirection:Resized(player.ShotSpeed * 10)
	tear.CollisionDamage = tear.CollisionDamage * 2
	tear.Scale = tear.Scale * 1.25
	tear.Height = tear.Height * 2
	
	if isNewTear then
		mod:checkReplaceableSecondaryFiredTears(tear, player, source, mod.SecondaryFireTearFlags.RECURSIVE | secondaryFlag)
		Isaac.RunCallback(FiendFolio.CALLBACK.FF_POST_FIRE_SECONDARY_TEAR, tear, player)
		tear:Update()
	end
end