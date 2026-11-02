local mod = FiendFolio
local sfx = SFXManager()
local game = Game()

function mod:CalzoneGeodeOnAdd(player, id)
	if not player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION) then
		player:AddCostume(Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_C_SECTION))
	end
end

function mod:CalzoneGeodeOnRemove(player, id)
	if not player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION) then
		player:RemoveCostume(Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_C_SECTION))
	end
end

local secondaryFlag = mod:AddSecondaryFireTearFlag("CALZONE")
mod:AddPriorityTrinketCallback(FiendFolio.CALLBACK.FF_SECONDARY_FIRE_TEAR_EFFECTS, CallbackPriority.LATE, FiendFolio.ITEM.ROCK.CALZONE_GEODE, function(_, tear, player, dir, source, flags)
	if flags & secondaryFlag == 0 and player:HasTrinket(FiendFolio.ITEM.ROCK.CALZONE_GEODE) then
		local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.CALZONE_GEODE)
		local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.CALZONE_GEODE)
		local chance = math.min(50,10+5*mult+player.Luck)
		if mod.HasTwoGeodes(player) then
			chance = chance+10
		end
		if rng:RandomInt(100) < chance then
			mod:fireChubberTear(player, tear, dir, source, flags ~= 0, flags)
			return flags | secondaryFlag
		end
	end
end)

mod:AddTrinketCallback(FiendFolio.CALLBACK.FF_SECONDARY_FIRE, FiendFolio.ITEM.ROCK.CALZONE_GEODE, function(_, player, dir, amount, owner, params)
	if player:HasTrinket(mod.ITEM.ROCK.CALZONE_GEODE) then
		local weaponType = params.WeaponType
		local modifiers = params.WeaponModifiers
		local charge = params.WeaponCharge
		local maxFireDelay = params.WeaponMaxFireDelay
		local numTears = params.NumTears
		if not params.ForceTearEffects and
		   ((weaponType == WeaponType.WEAPON_TEARS and not (params.GatlingGun or params.SwallowedM90 or params.RapidFireOpal)) or 
		    (weaponType == WeaponType.WEAPON_MONSTROS_LUNGS and not player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS)) or
		    (weaponType == WeaponType.WEAPON_BONE and modifiers & WeaponModifier.MONSTROS_LUNG == WeaponModifier.MONSTROS_LUNG and charge >= maxFireDelay * 2) or
		    (weaponType == WeaponType.WEAPON_SPIRIT_SWORD and params.FriendGun and params.IsFriendChargedSlash))
		then 
			return 
		end
		local isMonstrosLung = (weaponType == WeaponType.WEAPON_MONSTROS_LUNGS or modifiers & WeaponModifier.MONSTROS_LUNG == WeaponModifier.MONSTROS_LUNG) and 
		                       weaponType ~= WeaponType.WEAPON_URN_OF_SOULS and weaponType ~= WeaponType.WEAPON_SPIRIT_SWORD and weaponType ~= WeaponType.WEAPON_FETUS
		
		local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.CALZONE_GEODE)
		local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.CALZONE_GEODE)
		local chance = math.min(50,10+5*mult+player.Luck)
		if mod.HasTwoGeodes(player) then
			chance = chance+10
		end
		local numProcs = 0
		for i = 1, numTears do
			if rng:RandomInt(100) < chance then
				numProcs = numProcs + 1
			end
		end
		
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
			mod:fireChubberTear(player, nil, vel, owner, nil, nil, pos)
		end
	end
end)

function mod:fireChubberTear(player, tear, dir, source, spawnNew, flags, posOffset)
	local flags = flags or 0
	
	local isNewTear = tear == nil or spawnNew
	if isNewTear then
		if flags & mod.SecondaryFireTearFlags.RECURSIVE ~= 0 then return end
		tear = mod:SpawnPlayerTear(player, ((source and source.Position) or player.Position) + (posOffset or Vector(0,0)), dir:Resized(18))
	end
	
	tear:ChangeVariant(mod.FF.ChubberTear.Var)
	tear:AddTearFlags(TearFlags.TEAR_PIERCING | TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_BAIT)
	mod:GetEntityData(tear).chubberPlayer = source or player
	tear.Velocity = dir:Resized(18)
	sfx:Play(SoundEffect.SOUND_DEATH_BURST_LARGE, 0.4, 0, false, 1.4)
	for i=1,2 do
		Isaac.Spawn(1000, 5, 0, (source and source.Position) or player.Position, dir:Resized(math.random(5,9)):Rotated(math.random(-10,10)), player)
	end
	if FiendFolio.HasBeansFlag(tear) then
		tear.Color = Color(0.85, 0.57, 0.55, 1.0, 0.15, 0.0, 0.0)
	end
	
	if isNewTear then
		Isaac.RunCallback(FiendFolio.CALLBACK.FF_POST_FIRE_SECONDARY_TEAR, tear, player)
		tear:Update()
	end
end

function mod.chubberTear(tear)
	if tear.Variant ~= mod.FF.ChubberTear.Var then return end
	
	local sprite = tear:GetSprite()
	local data = mod:GetEntityData(tear)
	if math.abs(tear.Velocity.X) > math.abs(tear.Velocity.Y) then
		if tear.Velocity.X > 0 then
			tear.FlipX = false
		else
			tear.FlipX = true
		end
		mod:spritePlay(sprite, "Side")
	else
		if tear.Velocity.Y > 0 then
			mod:spritePlay(sprite, "Down")
		else
			mod:spritePlay(sprite, "Up")
		end
	end
	
	tear.FallingSpeed = 0
	tear.FallingAcceleration = -0.05
	tear.Height = -5
	
	if tear.FrameCount > 18 and data.chubberPlayer then
		tear.Velocity = mod:Lerp(tear.Velocity, (data.chubberPlayer.Position-tear.Position):Resized(18), 0.3)
		if tear.Position:Distance(data.chubberPlayer.Position) < 10 then
			tear:Remove()
		end
	elseif tear.FrameCount > 8 and data.chubberPlayer then
		tear.Velocity = mod:Lerp(tear.Velocity, (data.chubberPlayer.Position-tear.Position):Resized(18), 0.05)
	end

	if not data.chubberPlayer and tear.FrameCount ~= 0 then
		tear:Die()
	end
end

mod:AddCallback(ModCallbacks.MC_POST_FIRE_SPLIT_TEAR, function(_, new, old, splitType)
	local chubberPlayer = mod:GetEntityData(old).chubberPlayer
	if chubberPlayer then
		mod:GetEntityData(new).chubberPlayer = chubberPlayer
	end
end)