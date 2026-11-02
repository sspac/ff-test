-- Stardust --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local flag = TearFlagsLib.RegisterTearFlag("STARDUST")
mod.IgnoreStardust = false

local chanceDivider = 16
local baseChanceVal = 4
local minChanceVal = 1
local maxChanceVal = 6.4
local maxChanceAtLuck = 16
local scaledChanceMult = (maxChanceVal - baseChanceVal) / maxChanceAtLuck

local starInitVel = 2
local starInitHeight = -23.75
local starInitFallingSpeed = -20
local starRandFallingSpeed = -0.2
local starInitFallingAccel = 0.45
local starFramesTilBurst = 15

local dustDamageMult = 1/3
local dustBaseMass = 1
local dustOffsetDist = 45
local dustRandDist = 17.5
local numDust = 6
local dustVelOffsets = {}
for i = 1, numDust do
	dustVelOffsets[i] = Vector(dustOffsetDist,0):Rotated(360/numDust*i)
end

mod.PreventStardust = false
local function isStardustUseSuccessful(player)
	if mod.PreventStardust then return false end

	local chance = baseChanceVal + player.Luck * scaledChanceMult
	chance = math.min(math.max(minChanceVal, chance), maxChanceVal)
	if math.random() * chanceDivider <= chance then
		return true
	end
end

mod:AddPriorityCallback(ModCallbacks.MC_PRE_USE_ITEM, math.huge, function()
	mod.PreventStardust = true
end, CollectibleType.COLLECTIBLE_ISAACS_TEARS)

mod:AddPriorityCallback(ModCallbacks.MC_USE_ITEM, -1 * math.huge, function()
	mod.PreventStardust = false
end, CollectibleType.COLLECTIBLE_ISAACS_TEARS)

local function reverseFallingSpeed(speed, accel)
    return (speed - 0.1 - accel) / 0.9
end

local function forwardFallingSpeed(speed, accel)
	return 0.1 + accel + 0.9 * speed
end

local isCrawlspace = false
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	local room = game:GetRoom()
	isCrawlspace = room:GetType() == RoomType.ROOM_DUNGEON
end)

local function calculateStardustMovementParams(star, player, overrideDist, overrideSteps, isOrbit, isBoomerang)
	local basedist = player.ShotSpeed * 10
	local baseheight = player.TearHeight
	local basespeed = ((isOrbit and (player.TearFallingSpeed > 0) and 3) or 1) * ((isBoomerang and 0.5) or 1) * -1 * player.TearFallingSpeed
	local baseaccel = player.TearFallingAcceleration
	if isBoomerang then
		baseaccel = (baseaccel + 0.08) / 4 - 0.08
	end
	
	local estimatedheight = baseheight
	local estimatedspeed = basespeed
	local estimateddist = 0.0
	local estimatedsteps = 0
	while (estimatedheight < -5 and estimatedsteps < 1000) do
		estimatedspeed = forwardFallingSpeed(estimatedspeed, baseaccel)
		estimatedheight = estimatedheight + estimatedspeed
		estimatedsteps = estimatedsteps + 1
		estimateddist = estimateddist + basedist
	end
	if estimatedsteps >= 1000 or estimatedsteps == 0 or estimateddist == 0.0 then
		return 0, 1, 1/5
	end
	estimateddist = estimateddist + basedist -- tears still move on the dead frame
	
	local starbasedist = star.Velocity:Length()
	local starheight = star.Height
	local starspeed = star.FallingSpeed
	local staraccel = star.FallingAcceleration
	local starsteps = 0
	local stardist = 0.0
	while (starheight < -5 and starspeed < 0.0 and starsteps < starFramesTilBurst) do
		starspeed = forwardFallingSpeed(starspeed, staraccel)
		starheight = starheight + starspeed
		starsteps = starsteps + 1
		stardist = stardist + starbasedist
	end
	if starheight >= -5 then
		return 0, 1, 1/5
	end
	
	local targetsteps = math.max(5, overrideSteps or 0, estimatedsteps - starsteps)
	local targetdist = overrideDist or (estimateddist - stardist - basedist / 2)
	
	local dustheight = (isOrbit and ((starheight + 15) / 0.4)) or starheight
	local dustspeed = starspeed
	local dustdist = 0.0
	local duststeps = 0
	while (duststeps < targetsteps and duststeps < 1000) do
		dustspeed = forwardFallingSpeed(dustspeed, staraccel)
		dustheight = dustheight + dustspeed
		duststeps = duststeps + 1
		dustdist = dustdist + basedist
	end
	if duststeps >= 1000 or duststeps == 0 or dustdist == 0.0 then
		return 0, 1, 1 / ((duststeps > 0 and duststeps) or 5)
	end
	dustdist = dustdist + basedist -- tears still move on the dead frame
	
	local fallspeedbonus = (dustheight + 5) / targetsteps * -1
	local velmult = targetdist / dustdist
	return fallspeedbonus, velmult, 1 / duststeps
end

function mod:spawnStardust(player, pos, dir, includeMiddle, overrideDist, overrideSteps, extraInfo)
	local starparams = player:GetTearHitParams(WeaponType.WEAPON_TEARS)
	
	local velocity = dir:Resized(player.ShotSpeed * 10)
	
	local star = Isaac.Spawn(EntityType.ENTITY_TEAR, FiendFolio.TEAR.STAR, 0, pos, velocity:Resized(starInitVel), player):ToTear()
	TearFlagsLib.AddTearFlags(star, flag)
	
	star.Height = starInitHeight
	star.FallingSpeed = starInitFallingSpeed + math.random() * starRandFallingSpeed
	star.FallingAcceleration = starInitFallingAccel
	
	star.CollisionDamage = player.Damage
	star.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
	star.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
	star.Scale = starparams.TearScale
	
	if not star.Variant == FiendFolio.TEAR.STAR then
		mod:changeTearVariant(star, FiendFolio.TEAR.STAR, nil, true)
	end
	star:ResetSpriteScale()
	
	local params = {}
	local sdata = mod:GetEntityData(star)
	local crawlspaceMult = ((isCrawlspace and 0.5) or 1)
	
	sdata.FFStardustFramesTilBurst = starFramesTilBurst
	params.IncludeMiddle = includeMiddle
	
	local fallspeedbonus, velmult, offsetmult = calculateStardustMovementParams(star, player, overrideDist, overrideSteps)
	params.DustVelocity = velocity * velmult * crawlspaceMult
	params.DustFallSpeedBonus = fallspeedbonus
	params.DustOffsetMult = offsetmult
	
	local orbitfallspeedbonus, orbitvelmult, orbitoffsetmult = calculateStardustMovementParams(star, player, overrideDist, overrideSteps, true, false)
	params.DustOrbitVelocity = velocity * orbitvelmult
	params.DustOrbitFallSpeedBonus = orbitfallspeedbonus
	params.DustOrbitOffsetMult = orbitoffsetmult
	
	local boomerangfallspeedbonus, boomerangvelmult, boomerangeoffsetmult = calculateStardustMovementParams(star, player, overrideDist, overrideSteps, false, true)
	params.DustBoomerangVelocity = velocity * boomerangvelmult
	params.DustBoomerangFallSpeedBonus = boomerangfallspeedbonus
	params.DustBoomerangOffsetMult = boomerangeoffsetmult
	
	local boomerangorbitfallspeedbonus, boomerangorbitvelmult, boomerangeorbitoffsetmult = calculateStardustMovementParams(star, player, overrideDist, overrideSteps, true, true)
	params.DustBoomerangOrbitVelocity = velocity * boomerangorbitvelmult
	params.DustBoomerangOrbitFallSpeedBonus = boomerangorbitfallspeedbonus
	params.DustBoomerangOrbitOffsetMult = boomerangeorbitoffsetmult
	
	params.DustVelocityNoMult = velocity
	params.PlayerHadLachryphagy = player:HasCollectible(CollectibleType.COLLECTIBLE_LACHRYPHAGY)
	params.PlayerHadPop = player:HasCollectible(CollectibleType.COLLECTIBLE_POP)
	
	if isCrawlspace and (params.PlayerHadLachryphagy or params.PlayerHadPop) then
		star.FallingSpeed = 0
		star.FallingAcceleration = 0
	end
	
	params.FriendGun = extraInfo.Gun
	params.FriendAmmoUsed = extraInfo.AmmoUsed or (mod:ShouldMimicFriendBehaviour(player) and {mod.GetLastFetalFriendAmmo(player)})
	params.Hatred = extraInfo.Hatred
	
	TearFlagsLib.SetTearFlagParams(star, flag, params)
	star:Update()
end

function mod:burstStardust(star, starparams, noDie)
	local player = star.Player or (star.SpawnerEntity and star.SpawnerEntity:ToPlayer()) or nil
	if not player then return end
	
	local mass = dustBaseMass
	if player:HasTrinket(TrinketType.TRINKET_BLISTER) or 
	   player:HasCollectible(CollectibleType.COLLECTIBLE_8_INCH_NAILS) or 
	   player:HasCollectible(CollectibleType.COLLECTIBLE_PISCES)
	then
		mass = mass * 3
	end
	
	local baseVel = starparams.DustVelocity
	local randrot = 360 * math.random()
	local crawlspaceMult = ((isCrawlspace and 0.5) or 1)
	for i = 1, #dustVelOffsets + ((starparams.IncludeMiddle and 1) or 0) do
		local veloffset = (dustVelOffsets[i] or Vector(0,0)):Rotated(randrot) + Vector(dustRandDist * math.random(), 0):Rotated(360 * math.random())
		veloffset = veloffset * crawlspaceMult
		mod.RerollFetalFriendAmmo = true
		mod.OverrideFetalFriendAmmo = starparams.FriendAmmoUsed and starparams.FriendAmmoUsed[mod:RandomInt(1, #starparams.FriendAmmoUsed)]
		local dust = mod:SpawnPlayerTear(player, star.Position, baseVel + veloffset * starparams.DustOffsetMult, function(tear, player)
			tear.Height = star.Height
			tear.FallingSpeed = star.FallingSpeed
			tear.FallingAcceleration = (isCrawlspace and starInitFallingAccel) or star.FallingAcceleration
			tear.PositionOffset = Vector(0, star.Height)
			
			tear.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
			tear.Scale = tear.Scale * 0.5
		end)
		mod.RerollFetalFriendAmmo = false
		mod.OverrideFetalFriendAmmo = nil
		
		dust.Mass = mass
		TearFlagsLib.AddTearFlags(dust, flag)
		if dust.Variant ~= FiendFolio.TEAR.STAR then
			mod:changeTearVariant(dust, FiendFolio.TEAR.STAR, nil, true)
		end
		dust:SetDeadEyeIntensity(player:GetDeadEyeCharge() / 8)
		dust:ResetSpriteScale(true)
		
		local params = {
			IsDust = true,
		}
		params.DustFallSpeedBonus = starparams.DustFallSpeedBonus
		
		-- handling tear init shenanigans
		if not dust:HasTearFlags(TearFlags.TEAR_HYDROBOUNCE) then
			if dust:HasTearFlags(TearFlags.TEAR_ORBIT) and dust:HasTearFlags(TearFlags.TEAR_BOOMERANG) then
				dust.Parent = player
				
				-- undo the position offset change
				dust.Height = (dust.Height + 15) / 0.4
				
				-- undo the falling speed change
				if dust.FallingSpeed < 0 then
					dust.FallingSpeed = dust.FallingSpeed / 3
				end
				dust.FallingSpeed = dust.FallingSpeed * 2
				
				-- undo the falling acceleration change
				dust.FallingAcceleration = (dust.FallingAcceleration + 0.08) * 4 - 0.08
				
				params.DustFallSpeedBonus = starparams.DustBoomerangOrbitFallSpeedBonus
				dust.Velocity = starparams.DustBoomerangOrbitVelocity + veloffset * starparams.DustBoomerangOrbitOffsetMult
			elseif dust:HasTearFlags(TearFlags.TEAR_ORBIT) then
				dust.Parent = player
				
				-- undo the position offset change
				dust.Height = (dust.Height + 15) / 0.4
				
				-- undo the falling speed change
				if dust.FallingSpeed < 0 then
					dust.FallingSpeed = dust.FallingSpeed / 3
				end
				
				params.DustFallSpeedBonus = starparams.DustOrbitFallSpeedBonus
				dust.Velocity = starparams.DustOrbitVelocity + veloffset * starparams.DustOrbitOffsetMult
			elseif dust:HasTearFlags(TearFlags.TEAR_BOOMERANG) then
				dust.Parent = player
				
				-- undo the falling speed change
				dust.FallingSpeed = dust.FallingSpeed * 2
				
				-- undo the falling acceleration change
				dust.FallingAcceleration = (dust.FallingAcceleration + 0.08) * 4 - 0.08
				
				params.DustFallSpeedBonus = starparams.DustBoomerangFallSpeedBonus
				dust.Velocity = starparams.DustBoomerangVelocity + veloffset * starparams.DustBoomerangOffsetMult
			end
		end
		if dust:HasTearFlags(TearFlags.TEAR_WAIT) then
			dust.Parent = player
		end
		
		-- fuck fruit cake all my homies hate fruit cake
		if starparams.PlayerHadLachryphagy then
			dust:AddTearFlags(TearFlags.TEAR_ABSORB)
		else
			dust:ClearTearFlags(TearFlags.TEAR_ABSORB)
		end
		
		if starparams.PlayerHadPop then
			dust:AddTearFlags(TearFlags.TEAR_POP)
		else
			dust:ClearTearFlags(TearFlags.TEAR_POP)
		end
		
		if dust:HasTearFlags(TearFlags.TEAR_POP) or dust:HasTearFlags(TearFlags.TEAR_ABSORB) then
			dust.Velocity = starparams.DustVelocityNoMult + veloffset * starparams.DustOffsetMult
		end
		
		if starparams.FriendGun then
			local ammo = starparams.FriendAmmoUsed[mod:RandomInt(1, #starparams.FriendAmmoUsed)]
			if ammo.HeartKey == "IMMORAL_HEART" or ammo.ForceImmoral then
				local newammo = mod:makeCopiedTable(ammo)
				newammo.Crit = mod:RandomInt(100) < mod:GetFriendCritChance(player)
				ammo = newammo
			end
			local flat, mult, crit = mod:GetFriendShotDamageBonus(nil, player, ammo)
			dust.CollisionDamage = (dust.CollisionDamage + flat) * mult
			TearFlagsLib.AddTearFlags(dust, mod.FriendBulletFlags.FRIEND)
			TearFlagsLib.SetTearFlagParams(dust, mod.FriendBulletFlags.FRIEND, {Shot = ammo, Gun = starparams.FriendGun})
			mod:ApplyFriendTearShotEffects(dust, player, ammo, crit)
			mod:ApplyFriendTearColor(dust)
		end
		if starparams.Hatred then
			dust.CollisionDamage = dust.CollisionDamage * 0.75 * 0.55 * starparams.Hatred:ToFamiliar():GetMultiplier()
			dust:AddTearFlags(TearFlags.TEAR_SLOW | TearFlags.TEAR_GISH)
			dust.Color = mod.ColorDankBlackReal
		end
		
		dust.CollisionDamage = dust.CollisionDamage * dustDamageMult
		TearFlagsLib.SetTearFlagParams(dust, flag, params)
		dust:Update()
	end
	
	if not noDie then star:Die() end
end

mod:AddPriorityCollectibleCallback(FiendFolio.CALLBACK.FF_SECONDARY_FIRE_TEAR_EFFECTS, CallbackPriority.IMPORTANT, FiendFolio.ITEM.COLLECTIBLE.STARDUST, function(_, tear, player, dir, source, flags)
	if flags & mod.SecondaryFireTearFlags.RECURSIVE == 0 and not mod.IgnoreStardust and player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.STARDUST) then
		if isStardustUseSuccessful(player) then
			-- have to schedule this so blacklisted tear effects are actually applied by the time we check for them
			local pos, vel = tear.Position, tear.Velocity
			local gun, ammoUsed, hatred = mod.SecondaryFireTearEffectFriendGun, mod.SecondaryFireTearEffectFriendAmmoUsed, mod.IsHatredTear
			mod.scheduleForUpdate(function()
				-- ignore saturnus, immaculate heart, akeldama and ludovico technique
				if not (tear:HasTearFlags(TearFlags.TEAR_ORBIT_ADVANCED) or tear:HasTearFlags(TearFlags.TEAR_CHAIN) or tear:HasTearFlags(TearFlags.TEAR_LUDOVICO)) then
					mod:spawnStardust(player, pos, vel, true, nil, nil, {Gun = gun, AmmoUsed = ammoUsed, Hatred = hatred})
				end
			end, 0)
		end
	end
end)

local ludoTears = {}
mod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, function(_, tear)
	local ptrhash = GetPtrHash(tear)
	ludoTears[ptrhash] = tear
	mod.scheduleForUpdate(function()
		if not tear:HasTearFlags(TearFlags.TEAR_LUDOVICO) then
			ludoTears[ptrhash] = nil
		end
	end, 0)
end)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	ludoTears = {}
end)

mod:AddCollectibleCallback(FiendFolio.CALLBACK.FF_SECONDARY_FIRE, FiendFolio.ITEM.COLLECTIBLE.STARDUST, function(_, player, dir, amount, owner, params)
	if not mod.IgnoreStardust and player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.STARDUST) then
		local weaponType = params.WeaponType
		local modifiers = params.WeaponModifiers
		local charge = params.WeaponCharge
		local maxFireDelay = params.WeaponMaxFireDelay
		local numTears = params.NumTears
		if not params.ForceTearEffects and
		   ((weaponType == WeaponType.WEAPON_TEARS and not (params.GatlingGun or params.SwallowedM90 or params.RapidFireOpal)) or 
		    (weaponType == WeaponType.WEAPON_MONSTROS_LUNGS and not player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS)) or
		    (weaponType == WeaponType.WEAPON_BONE and modifiers & WeaponModifier.MONSTROS_LUNG == WeaponModifier.MONSTROS_LUNG and charge >= maxFireDelay * 2))
		then 
			return 
		end
		local isMonstrosLung = (weaponType == WeaponType.WEAPON_MONSTROS_LUNGS or modifiers & WeaponModifier.MONSTROS_LUNG == WeaponModifier.MONSTROS_LUNG) and 
		                       weaponType ~= WeaponType.WEAPON_URN_OF_SOULS and weaponType ~= WeaponType.WEAPON_SPIRIT_SWORD and weaponType ~= WeaponType.WEAPON_FETUS
		
		local numProcs = 0
		for i = 1, numTears do
			if isStardustUseSuccessful(player) then
				numProcs = numProcs + 1
			end
		end
		
		local overrideDist, overrideSteps = nil, nil
		if numProcs > 0 then
			if weaponType == WeaponType.WEAPON_ROCKETS then
				local targets = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.TARGET)
				for _, target in ipairs(targets) do
					if target.SpawnerEntity and GetPtrHash(target.SpawnerEntity) == GetPtrHash(owner) then
						local dist = target.Position - owner.Position
						if math.abs(dist:GetAngleDegrees() - dir:GetAngleDegrees()) < 0.00001 then
							overrideDist = dist:Length()
							overrideSteps = 5
							goto afterStardustLudoRocketCheck
						end
					end
				end
				return
			elseif weaponType == WeaponType.WEAPON_LUDOVICO_TECHNIQUE and 
			       (not (player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS) or 
			             player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_X) or
			             player:HasCollectible(CollectibleType.COLLECTIBLE_SPIRIT_SWORD) or
			             player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION) or
			             player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN or 
			             player:GetPlayerType() == PlayerType.PLAYER_LILITH_B) or 
			       player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE))
			then
				for _, tear in pairs(ludoTears) do
					if tear:ToTear():HasTearFlags(TearFlags.TEAR_LUDOVICO) and tear.SpawnerEntity and GetPtrHash(tear.SpawnerEntity) == GetPtrHash(owner) then
						local dist = tear.Position - owner.Position
						if math.abs(dist:GetAngleDegrees() - dir:GetAngleDegrees()) < 0.00001 then
							overrideDist = dist:Length()
							overrideSteps = 5
							goto afterStardustLudoRocketCheck
						end
					end
				end
				
				local lasers = Isaac.FindByType(EntityType.ENTITY_LASER, -1, LaserSubType.LASER_SUBTYPE_RING_LUDOVICO)
				for _, laser in ipairs(lasers) do
					if laser.SpawnerEntity and GetPtrHash(laser.SpawnerEntity) == GetPtrHash(owner) then
						local dist = laser.Position - owner.Position
						if math.abs(dist:GetAngleDegrees() - dir:GetAngleDegrees()) < 0.00001 then
							overrideDist = dist:Length()
							overrideSteps = 5
							goto afterStardustLudoRocketCheck
						end
					end
				end
				
				local knives = Isaac.FindByType(EntityType.ENTITY_KNIFE)
				for _, knife in ipairs(knives) do
					if knife:ToKnife():HasTearFlags(TearFlags.TEAR_LUDOVICO) and knife.SpawnerEntity and GetPtrHash(knife.SpawnerEntity) == GetPtrHash(owner) then
						local dist = knife.Position - owner.Position
						if math.abs(dist:GetAngleDegrees() - dir:GetAngleDegrees()) < 0.00001 then
							overrideDist = dist:Length()
							overrideSteps = 5
							goto afterStardustLudoRocketCheck
						end
					end
				end
				
				return
			end
		end
		::afterStardustLudoRocketCheck::
		
		local rng = player:GetCollectibleRNG(FiendFolio.ITEM.COLLECTIBLE.STARDUST)
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
			
			mod:spawnStardust(player, owner.Position + pos, vel, true, overrideDist, overrideSteps, {Gun = params.FriendGun, AmmoUsed = params.FriendAmmoUsed, Hatred = params.Hatred})
		end
	end
end)

--[[mod:AddCollectibleCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, FiendFolio.ITEM.COLLECTIBLE.STARDUST, function(_, rocket)
	if rocket.FrameCount == 8 then -- frame it locks in where it falls, makes this quite a bit delayed honestly but oh well
		local target = rocket.Parent
		if target and target.SpawnerEntity and not mod:GetEntityData(target).FFIsDoctorsRemote then
			local player = target.SpawnerEntity:ToPlayer()
			if player == nil then return end
			
			if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.STARDUST) then
				if isStardustUseSuccessful(player) then
					local dir = rocket.Position - player.Position
					mod:spawnStardust(player, player.Position, dir, true, dir:Length(), 5)
				end
			end
		end
	end
end, EffectVariant.ROCKET)]]--

mod:AddCollectibleCallback(FiendFolio.CALLBACK.POST_GKUN_RAIN_TEAR, FiendFolio.ITEM.COLLECTIBLE.STARDUST, function(_, tear, player)
	if mod.IgnoreSecondaryFireEffects or mod.IgnoreStardust then return end
	
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.STARDUST) then
		if isStardustUseSuccessful(player) then
			local params = {}
			params.IncludeMiddle = true
			
			local baseaccel = tear.FallingAcceleration
			local estimatedheight = tear.Height
			local estimatedspeed = tear.FallingSpeed
			local estimatedsteps = 0
			while (estimatedheight < -5 and estimatedsteps < 1000) do
				estimatedspeed = forwardFallingSpeed(estimatedspeed, baseaccel)
				estimatedheight = estimatedheight + estimatedspeed
				estimatedsteps = estimatedsteps + 1
			end
			local offsetMult = 1 / math.max(1, estimatedsteps)
			
			params.DustVelocity = tear.Velocity
			params.DustFallSpeedBonus = 0
			params.DustOffsetMult = offsetMult
			
			params.DustOrbitVelocity = tear.Velocity
			params.DustOrbitFallSpeedBonus = 0
			params.DustOrbitOffsetMult = offsetMult
			
			params.DustBoomerangVelocity = tear.Velocity
			params.DustBoomerangFallSpeedBonus = 0
			params.DustBoomerangOffsetMult = offsetMult
			
			params.DustBoomerangOrbitVelocity = tear.Velocity
			params.DustBoomerangOrbitFallSpeedBonus = 0
			params.DustBoomerangOrbitOffsetMult = offsetMult
			
			params.DustVelocityNoMult = tear.Velocity
			params.PlayerHadLachryphagy = false
			params.PlayerHadPop = false
			
			mod:burstStardust(tear, params, true)
			sfx:Play(mod.Sounds.DevilDaggerGemCollect, 0.6, 0, false, math.random(110,125)/100)
		end
	end
end)

mod:AddCollectibleCallback(FiendFolio.CALLBACK.POST_GKUN_RAIN_BOMB, FiendFolio.ITEM.COLLECTIBLE.STARDUST, function(_, bomb, player)
	if mod.IgnoreSecondaryFireEffects or mod.IgnoreStardust then return end
	
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.STARDUST) then
		if isStardustUseSuccessful(player) then
			local starInfo = {Player = player, 
			                  Position = bomb.Position, 
			                  Height = -115, 
			                  FallingSpeed = player.ShotSpeed * 10, 
			                  FallingAcceleration = 0.1}
			
			local params = {}
			params.IncludeMiddle = true
			
			local baseaccel = starInfo.FallingAcceleration
			local estimatedheight = starInfo.Height
			local estimatedspeed = starInfo.FallingSpeed
			local estimatedsteps = 0
			while (estimatedheight < -5 and estimatedsteps < 1000) do
				estimatedspeed = forwardFallingSpeed(estimatedspeed, baseaccel)
				estimatedheight = estimatedheight + estimatedspeed
				estimatedsteps = estimatedsteps + 1
			end
			local offsetMult = 1 / math.max(1, estimatedsteps)
			
			params.DustVelocity = bomb.Velocity
			params.DustFallSpeedBonus = 0
			params.DustOffsetMult = offsetMult
			
			params.DustOrbitVelocity = bomb.Velocity
			params.DustOrbitFallSpeedBonus = 0
			params.DustOrbitOffsetMult = offsetMult
			
			params.DustBoomerangVelocity = bomb.Velocity
			params.DustBoomerangFallSpeedBonus = 0
			params.DustBoomerangOffsetMult = offsetMult
			
			params.DustBoomerangOrbitVelocity = bomb.Velocity
			params.DustBoomerangOrbitFallSpeedBonus = 0
			params.DustBoomerangOrbitOffsetMult = offsetMult
			
			params.DustVelocityNoMult = bomb.Velocity
			params.PlayerHadLachryphagy = false
			params.PlayerHadPop = false
			
			mod:burstStardust(starInfo, params, true)
			sfx:Play(mod.Sounds.DevilDaggerGemCollect, 0.6, 0, false, math.random(110,125)/100)
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_PRE_TEAR_UPDATE, function(_, tear)
	if TearFlagsLib.HasTearFlags(tear, flag) then
		local data = mod:GetEntityData(tear)
		if data.FFStardustIntendedFallingSpeed ~= nil then
			tear.FallingSpeed = data.FFStardustIntendedFallingSpeed
		end
		
		if data.FFStardustFramesTilBurst ~= nil then
			if data.FFStardustFramesTilBurst <= 0 or (not isCrawlspace and tear.FallingSpeed >= 0.0) then
				mod:burstStardust(tear, TearFlagsLib.GetTearFlagParams(tear, flag))
			end
			data.FFStardustFramesTilBurst = data.FFStardustFramesTilBurst - 1
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tear)
	if not (tear.StickTarget or tear.WaitFrames > 0 or tear:HasTearFlags(TearFlags.TEAR_LUDOVICO)) and 
	   TearFlagsLib.HasTearFlags(tear, flag) 
	then
		local data = mod:GetEntityData(tear)
		local params = TearFlagsLib.GetTearFlagParams(tear, flag)
		if params.IsDust then
			if not (tear:HasTearFlags(TearFlags.TEAR_POP) or tear:HasTearFlags(TearFlags.TEAR_ABSORB)) then
				-- i get to do this now to maintain range
				-- nothing i havent done before but its always goofy
				if tear.Height < -5 then
					data.FFStardustIntendedFallingSpeed = tear.FallingSpeed
					tear.Height = tear.Height - tear.FallingSpeed
					tear.FallingSpeed = tear.FallingSpeed + params.DustFallSpeedBonus
					tear.Height = tear.Height + tear.FallingSpeed
				end
				if tear.Height >= -5.01 then
					-- to prevent large positive heights, especially for orbiting tears
					data.FFStardustIntendedFallingSpeed = data.FFStardustIntendedFallingSpeed or tear.FallingSpeed
					tear.Height = tear.Height - tear.FallingSpeed
					tear.FallingSpeed = -4.99 - tear.Height
					tear.Height = tear.Height + tear.FallingSpeed
				end
			end
		else
			-- pop/lachryphagy want to stay at specific tear heights so we force the star to do so
			-- otherwise you get teleporting tears for lachryphagy and collisions between tears at ridiculously different heights for pop
			-- unfortunately not as nice looking for the star but it's the lesser of two evils
			if params.PlayerHadLachryphagy then
				local player = (tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()) or nil
				if player then
					tear.Height = player.TearHeight
				else
					tear.Height = starInitHeight
				end
				data.FFStardustIntendedFallingSpeed = tear.FallingSpeed
				tear.FallingSpeed = 0
			elseif params.PlayerHadPop then
				tear.Height = starInitHeight
				data.FFStardustIntendedFallingSpeed = tear.FallingSpeed
				tear.FallingSpeed = 0
			end
		end
	end
end)

function mod:copyStardustFlag(copy, source)
	local sdata = mod:GetEntityData(source)
	local cdata = mod:GetEntityData(copy)
	cdata.FFStardustFramesTilBurst = sdata.FFStardustFramesTilBurst
	cdata.FFStardustIntendedFallingSpeed = sdata.FFStardustIntendedFallingSpeed
end
mod:AddCallback(TearFlagsLib.Callback.POST_COPY_TEARFLAGS, mod.copyStardustFlag, flag)

mod:AddCallback(ModCallbacks.MC_POST_TEAR_COLLISION, function(_, tear)
	-- ugh fix for belial tear aura not responding to changes in scale on frame 0
	-- cant have shit in detroit
	if tear.FrameCount == 0 then
		tear:ResetSpriteScale(true)
	end
end, TearVariant.BELIAL)

local function spawnSparkle(tear, positionOverride, velocityOverride)
	local sparkle = Isaac.Spawn(1000, 1727, 0, positionOverride or tear.Position, velocityOverride or Vector.Zero, tear):ToEffect()
	local sdata = mod:GetEntityData(sparkle)
	sdata.RenderZOffset = -5
	sparkle.PositionOffset = tear.PositionOffset + Vector(math.random(), math.random()) * 5
	sparkle.SpriteScale = Vector(tear.Scale, tear.Scale) * 0.8
	sdata.SparkleValue = 5
	sparkle.Color = tear.Color
	return sparkle
end

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tear)
	if tear.FrameCount % 4 == 0 + tear.InitSeed % 4 then
		spawnSparkle(tear)
	end
end, FiendFolio.TEAR.STAR)

function mod:starTearRender(tear, tvar, data, offset)
	local sprite = tear:GetSprite()
	local scale = tear.Scale
	local flags = tear.TearFlags
	
	local anim = "spin"
	if not sprite:IsPlaying(anim) then
		local frame = sprite:GetFrame()
		sprite:Play(anim, true)
		sprite:SetFrame(frame)
	end

	local spritescale = mod:getTearScale1(tear) * 1.25
	local layers = sprite:GetAllLayers()
	for _, layer in ipairs(layers) do
		layer:SetSize(spritescale)
	end
	
	if flags & TearFlags.TEAR_FLAT == TearFlags.TEAR_FLAT then
		local adjustedVelocity = tear.Velocity
		if tear.WaitFrames > 0 then
			adjustedVelocity = tear.ContinueVelocity
		elseif (tear.FallingSpeed < 0 or 0.2 < tear.FallingSpeed) and 
		       flags & TearFlags.TEAR_LUDOVICO ~= TearFlags.TEAR_LUDOVICO and
		       ((flags & TearFlags.TEAR_ABSORB ~= TearFlags.TEAR_ABSORB and flags & TearFlags.TEAR_POP ~= TearFlags.TEAR_POP) or tear.Velocity:Length() <= 0.1) 
		then
			adjustedVelocity = adjustedVelocity + Vector(0, tear.FallingSpeed)
		end
		
		sprite.Rotation = adjustedVelocity:GetAngleDegrees()
		sprite.FlipX = false
		sprite.FlipY = false
	else
		sprite.Rotation = 0
		sprite.FlipX = false
		sprite.FlipY = false
	end
end
mod:AddCallback("FF_CUSTOM_TEAR_RENDER", mod.starTearRender, FiendFolio.TEAR.STAR)

function mod:starTearSplat(tear, var, data)
	if TearFlagsLib.GetTearFlagParams(tear, flag).IsDust then
		if tear.Scale >= 0.425 then
			sfx:Play(mod.Sounds.DevilDaggerGemCollect2, 0.1, 0, false, math.random(150,165)/100) -- duping sound so the big split and small impact don't erase each other
		else
			sfx:Play(mod.Sounds.DevilDaggerGemTing, 0.15, 0, false, math.random(130,145)/100)
		end
	else
		sfx:Play(mod.Sounds.DevilDaggerGemCollect, 0.35, 0, false, math.random(110,125)/100)
	end
	
	if tear.TearFlags & TearFlags.TEAR_EXPLOSIVE == TearFlags.TEAR_EXPLOSIVE then return end

	local color = tear:GetSprite().Color
	if TearFlagsLib.GetTearFlagParams(tear, flag).IsDust then
		color.A = color.A * 0.4
	end
	
	local poof = Isaac.Spawn(1000, EffectVariant.IMPACT, 0, tear.Position, nilvector, tear)
	local psprite = poof:GetSprite()
	psprite:Load("gfx/projectiles/Projectile_star.anm2", true)
	psprite:Play("impact", true)
	psprite.Color = color
	poof.SpriteScale = mod:getTearScale1(tear) * 1.25
	poof.PositionOffset = tear.PositionOffset
end
mod:AddCallback("FF_CUSTOM_TEAR_SPLAT", mod.starTearSplat, FiendFolio.TEAR.STAR)