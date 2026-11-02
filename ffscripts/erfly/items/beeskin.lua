local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local flag = TearFlagsLib.RegisterTearFlag("BEE_SKIN") -- mostly cosmetic flag used mainly to mark point of origin for some stuff that cares about reducing damage

mod:AddCallback(TearFlagsLib.Callback.PRE_REMOVE_TEARFLAG, function()
	return true
end, flag)

mod:AddCollectibleCallback(FiendFolio.CALLBACK.FF_SECONDARY_FIRE, mod.ITEM.COLLECTIBLE.BEE_SKIN, function(_, player, dir, amount, owner, params)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.BEE_SKIN) then
		local weaponType = params.WeaponType
		if weaponType == WeaponType.WEAPON_BRIMSTONE or 
		   weaponType == WeaponType.WEAPON_ROCKETS or
		   (weaponType == WeaponType.WEAPON_URN_OF_SOULS and player:GetPlayerType() == PlayerType.PLAYER_JUDAS and player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)) 
		then
			return
		end
		
		local pdata = mod:GetEntityData(player)
		local charge = params.WeaponCharge
		local maxFireDelay = params.WeaponMaxFireDelay
		local numTears = params.NumTears
		if weaponType == WeaponType.WEAPON_BOMBS or (weaponType == WeaponType.WEAPON_MONSTROS_LUNGS and player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS)) then
			mod:beeSkinFireBombs(player, math.min(numTears, 6), pdata, params)
		elseif weaponType == WeaponType.WEAPON_KNIFE then
			local knifecharge = charge / (maxFireDelay * 4)
			if params.WeaponModifiers & WeaponModifier.LUDOVICO_TECHNIQUE ~= 0 then
				knifecharge = 0.25
			end
			mod:beeSkinFireKnives(player, math.min(numTears, 6), knifecharge, pdata)
		elseif weaponType == WeaponType.WEAPON_LASER then
			mod:beeskinFireLasers(player, math.min(numTears, 6), pdata, params)
		elseif weaponType == WeaponType.WEAPON_TECH_X then
			local techcharge = charge / (maxFireDelay * 3)
			mod:beeskinFireTechX(player, math.min(numTears, 6), techcharge, pdata, params)
		else
			mod:beeSkinFireTears(player, math.min(numTears, 6), pdata, params)
		end
	end
end)

function mod:beeSkinFireTears(player, num, pdata, params)
	local isSpiritSword = params.WeaponType == WeaponType.WEAPON_SPIRIT_SWORD and not params.BinabaSatellite
	local isFetus = params.WeaponType == WeaponType.WEAPON_FETUS or params.WeaponModifiers & WeaponModifier.C_SECTION ~= 0
	local isUrn = params.WeaponType == WeaponType.WEAPON_URN_OF_SOULS
	local isGatling = params.WeaponType == WeaponType.WEAPON_TEARS and params.GatlingGun
	local isM90 = params.WeaponType == WeaponType.WEAPON_TEARS and params.SwallowedM90
	for i = 1, math.min(num, 6) do
		local numberOfBees = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.BEE_SKIN)
		local numshots = math.min(2 + numberOfBees, 8)
		local vel
		if params.FriendGun and params.IsSpinAttack then
			numshots = 6
			vel = Vector.FromAngle((360 / numshots) * 0.5) * 8 * player.ShotSpeed
		else
			if pdata.BeeSkinAngle ~= nil then
				pdata.BeeSkinAngle = pdata.BeeSkinAngle + 360 / numshots / 6
			else
				pdata.BeeSkinAngle = -90
			end
			vel = Vector.FromAngle(pdata.BeeSkinAngle) * ((isSpiritSword and not params.FriendGun and params.IsSpinAttack and 16) or 8) * player.ShotSpeed
			if isSpiritSword and params.IsSpinAttack then
				numshots = numshots + 3
			end
		end

		local fetusCostumePath
		if isFetus then
			local ptype = player:GetPlayerType()
			local skinColor = player:GetBodyColor()
			fetusCostumePath = Isaac.RunCallbackWithParam(FiendFolio.CALLBACK.FF_GET_C_SECTION_TEAR_COSTUME, ptype, ptype, skinColor, player)
			if fetusCostumePath == nil then
				local costumeSuffix = EntityConfig.GetPlayer(ptype):GetCostumeSuffix()
				if costumeSuffix == "forgotten" then
					fetusCostumePath = "gfx/characters/costumes_forgotten/fetus_tears.png"
				elseif costumeSuffix == "shadow" then
					fetusCostumePath = "gfx/characters/costumes_shadow/fetus_tears.png"
				elseif costumeSuffix == "fiend" then
					fetusCostumePath = "gfx/characters/costumes_fiend/fetus_tears.png"
				elseif costumeSuffix == "friend" then
					fetusCostumePath = "gfx/characters/costumes_friend/fetus_tears.png"
				else
					fetusCostumePath = "gfx/characters/costumes/fetus_tears" .. mod:GetSkinColorSuffix(skinColor) .. ".png"
				end
			end
		end
		for i = 1, numshots do
			if isM90 then
				local shotvel = vel:Rotated((360 / numshots) * i):Resized(8 * (1 + mod.FriendBalancing.Shotspeed))
				shotvel = shotvel + player:GetTearMovementInheritance(shotvel)
				local tear = Isaac.Spawn(2, mod.TEAR.M90_BULLET, 0, player.Position, shotvel, player):ToTear()
                tear.SpawnerEntity = player
                tear.TearFlags = tear.TearFlags | TearFlags.TEAR_PIERCING
                tear.CollisionDamage = math.max(player.Damage, 3.5) * (pdata.swallowedM90Multi or 3.5)
				TearFlagsLib.AddTearFlags(tear, mod.FriendBulletFlags.NO_FALL_TEAR)
				if player:HasCollectible(mod.ITEM.COLLECTIBLE.RUBBER_BULLETS) then
					local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
					FiendFolio.FlagBruise(tear, mod.RubberBulletsBal.BaseDuration * secondHandMultiplier, 1, 1)
					tear.Color = Color(0.5, 0.3, 0.5, 1.0, 40/255, 0/255, 40/255)
				end
				if player:HasTrinket(mod.ITEM.ROCK.SHROOMITE) then
					tear.CollisionDamage = tear.CollisionDamage*2
				end
				tear.CollisionDamage = tear.CollisionDamage * 0.3
				tear.Scale = 0.8
				tear:ResetSpriteScale()
			elseif isGatling then
				local shotvel = vel:Rotated((360 / numshots) * i):Resized(mod.GRANDPAS_GATLING_GUN.Constants.SHOT_SPEED * 0.8)
				shotvel = shotvel + player:GetTearMovementInheritance(shotvel)
				
				local tear = Isaac.Spawn(
					EntityType.ENTITY_TEAR,
					mod.TEAR.FRIEND_BULLET,
					0,
					player.Position,
					shotvel,
					player
				):ToTear()
				tear:SetInitSound(SoundEffect.SOUND_NULL)

				-- some flashes dont get deleted properly when you spin down while shooting, idk how to fix it but its not a big deal i think, urp
				--mod:MakeMuzzleFlashFriend(gatlingGun, player, mod:GetFriendGunShootPos(gatlingGun, vecMuzzle), vecMuzzle)
				TearFlagsLib.AddTearFlags(tear, mod.FriendBulletFlags.NO_FALL_TEAR)
				TearFlagsLib.AddTearFlags(tear, TearFlagsLib.Flag.BULLET_GATLING)

				if mod:playerIsBelialMode(player) then
					tear:AddTearFlags(TearFlags.TEAR_BURN)
					tear:Update()
				end

				tear.FallingSpeed = -0.1
				tear.FallingAcceleration = -0.05
				tear.Height = -6
				tear.Scale = 0.8
				tear:ResetSpriteScale()

				tear.CollisionDamage = (player.Damage * mod.GRANDPAS_GATLING_GUN.Constants.DAMAGE_MULT + mod.GRANDPAS_GATLING_GUN.Constants.FLAT_DAMAGE) * 0.3

				if mod:GetEntityData(player).TrickyCherryCrit then
					tear.Color = Color(1, 1, 1, 1, 0.25, 0, 0)
				end
			elseif isUrn then
				local shotvel = vel:Rotated((360 / numshots) * i):Resized(6)
				shotvel = shotvel + player:GetTearMovementInheritance(shotvel)
				local fire = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.FIRE, 0, player.Position, shotvel, player):ToTear()
				fire.Parent = player
				fire:AddTearFlags(TearFlags.TEAR_PIERCING)
				if math.random(8) == 0 then
					fire:AddTearFlags(TearFlags.TEAR_SHIELDED)
				end
				TearFlagsLib.AddTearFlags(fire, flag)
				local level = game:GetLevel()
				local stage = level:GetStage()
				local stagetype = level:GetStageType()
				if stagetype == StageType.STAGETYPE_REPENTANCE or stagetype == StageType.STAGETYPE_REPENTANCE_B then
					stage = stage + 1
				end
				fire.CollisionDamage = (stage * 0.3 + 2.3) * 0.8 * 0.3
				fire.Scale = 0.7 * 0.8
				fire:ResetSpriteScale()
				fire.FallingAcceleration = 0.1
				fire.Mass = 0
				fire:Update()
			else
				local shotvel = vel:Rotated((360 / numshots) * i)
				shotvel = shotvel + player:GetTearMovementInheritance(shotvel)
				mod.RerollFetalFriendAmmo = true
				local beeskintear = mod:SpawnPlayerTear(player, player.Position, shotvel, function(tear, player)
					if isSpiritSword and not params.FriendGun then
						if params.IsSpinAttack then
							tear.CollisionDamage = tear.CollisionDamage * 4 + 4
						else
							tear.CollisionDamage = tear.CollisionDamage + 2
						end
					end
					tear.CollisionDamage = tear.CollisionDamage * ((isFetus and 0.75) or 1)
					if params.BinabaSatellite then
						tear.CollisionDamage = tear.CollisionDamage * (params.BinabaDamageMulti or 1)
						tear.Scale = mod:getTearParamsScale(player, tear.CollisionDamage, tear.TearFlags)
					end
					tear.CollisionDamage = tear.CollisionDamage * 0.3 * ((params.IsFriendChargedSlash and 2) or 1)
					tear.Parent = player
					
					if isSpiritSword and not params.FriendGun then
						if player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY) then
							mod:changeTearVariant(tear, TearVariant.TECH_SWORD_BEAM, nil, true)
						else
							mod:changeTearVariant(tear, TearVariant.SWORD_BEAM, nil, true)
						end
					end
					tear.Scale = tear.Scale * 0.8 * ((params.IsFriendChargedSlash and 1.5) or 1)
					tear:ResetSpriteScale()
					if isFetus then
						local scaleBefore = tear.Scale
						mod:tryAppendCSection(player, tear)
						mod:changeTearVariant(tear, TearVariant.FETUS, nil, true)
						local sprite = tear:GetSprite()
						sprite:ReplaceSpritesheet(0, fetusCostumePath, true)
						tear.Scale = scaleBefore
					end
					
					tear.CanTriggerStreakEnd = false
					TearFlagsLib.AddTearFlags(tear, flag)
				end)
				mod.RerollFetalFriendAmmo = false
				if not isFetus then
					if params.FriendGun then
						local ammo = params.FriendAmmoUsed[mod:RandomInt(1, #params.FriendAmmoUsed)]
						if ammo.HeartKey == "IMMORAL_HEART" or ammo.ForceImmoral then
							local newammo = mod:makeCopiedTable(ammo)
							newammo.Crit = mod:RandomInt(100) < mod:GetFriendCritChance(player)
							ammo = newammo
						end
						mod:HandleFriendTears(player, params.FriendGun, beeskintear, ammo)
					end
					if params.RapidFireOpal then
						TearFlagsLib.AddTearFlags(beeskintear, TearFlagsLib.Flag.GOLEMS_AR_BULLET)
						TearFlagsLib.AddTearFlags(beeskintear, mod.FriendBulletFlags.NO_FALL_TEAR)
						mod:changeTearVariant(beeskintear, mod.TEAR.GOLEMS_AR_BULLET)
						if player:HasCollectible(mod.ITEM.COLLECTIBLE.RUBBER_BULLETS) then
							FiendFolio.FlagBruise(beeskintear, mod.RubberBulletsBal.BaseDuration * secondHandMultiplier, 1, 1)
							if FiendFolio.HasBeansFlag(beeskintear) then 
								TearFlagsLib.SetTearFlagParams(beeskintear, TearFlagsLib.Flag.BEANS, {IsBlackEyedPea = true})
							else
								beeskintear.Color = Color(0.5, 0.3, 0.5, 1.0, 40/255, 0/255, 40/255)
							end
						end
						if player:HasTrinket(mod.ITEM.ROCK.SHROOMITE) then
							beeskintear.CollisionDamage = beeskintear.CollisionDamage*2
						end
					end
				end
				if params.BinabaSatellite then
					beeskintear.Color = mod:GetInabaTearColor(true, params.BinabaSatellite, params.BinabaMigraine, beeskintear.Color)
					
					if params.BinabaOcularSpectrumBuff then
						beeskintear:SetDeadEyeIntensity(beeskintear:GetDeadEyeIntensity() + 0.2)
						if mod.InabaBal.B_OcularSpectrumBuffAddsHoming then
							beeskintear:AddTearFlags(TearFlags.TEAR_HOMING)
						end
					end
					
					if params.BinabaMigraine then
						beeskintear.FallingSpeed = mod:RandomFloat(beeskintear.FallingSpeed * 0.8, beeskintear.FallingSpeed * 1.2)
						beeskintear.FallingAcceleration = mod:RandomFloat(beeskintear.FallingAcceleration * 0.8, beeskintear.FallingAcceleration * 1.2)
						beeskintear.Height = mod:RandomFloat(beeskintear.Height * 0.9, beeskintear.Height * 1.1)
						beeskintear.Scale = beeskintear.Scale / 1.25 * mod:RandomFloat(0.9, 1.1)
						beeskintear:ResetSpriteScale()
						
						if not isFetus then
							local hasBirthcake, birthcakeMult = mod:playerHasBirthcake(player)
							if hasBirthcake then
								if not beeskintear:HasTearFlags(TearFlags.TEAR_PIERCING) then
									TearFlagsLib.AddTearFlags(beeskintear, TearFlagsLib.Flag.MIND_RAZOR)
									TearFlagsLib.SetTearFlagParams(beeskintear, TearFlagsLib.Flag.MIND_RAZOR, {BirthcakeMult = birthcakeMult})
								end
								beeskintear.Scale = (beeskintear.Scale + mod.InabaBal.MigraineTearScaleFlat) * mod.InabaBal.MigraineTearScaleMult
								beeskintear:AddTearFlags(TearFlags.TEAR_PIERCING)
								if beeskintear.Variant ~= TearVariant.PUPULA then
									mod:changeTearVariant(beeskintear, TearVariant.PUPULA)
								end
							end
						end
					end
				end
				beeskintear:Update()
			end
		end
	end
end

function mod:beeSkinFireBombs(player, num, pdata, params)
	for i = 1, math.min(num, 6) do
		local numberOfBees = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.BEE_SKIN)
		local numshots = math.min(2 + numberOfBees, 8)
		if pdata.BeeSkinAngle ~= nil then
			pdata.BeeSkinAngle = pdata.BeeSkinAngle + 360 / numshots / 6
		else
			pdata.BeeSkinAngle = -90
		end
		local vel = Vector.FromAngle(pdata.BeeSkinAngle) * 8 * player.ShotSpeed

		for i = 1, numshots do
			local shotvel = vel:Rotated((360 / numshots) * i)
			shotvel = shotvel + player:GetTearMovementInheritance(shotvel)
			mod.IgnoreTelebombs = true
			mod.RerollFetalFriendAmmo = true
			local beebomb = player:FireBomb(player.Position, shotvel, player)
			mod.IgnoreTelebombs = false
			mod.RerollFetalFriendAmmo = false
			beebomb.Position = beebomb.Position + shotvel:Resized(beebomb.Size + 5)
			mod:GetEntityData(beebomb).beeSkinBomb = true
            beebomb:SetScale(0.5)
            beebomb.RadiusMultiplier = 0.6
			beebomb:ClearTearFlags(TearFlags.TEAR_SCATTER_BOMB)
			if params.FriendGun then
				local ammo = params.FriendAmmoUsed[mod:RandomInt(1, #params.FriendAmmoUsed)]
				if ammo.HeartKey == "IMMORAL_HEART" or ammo.ForceImmoral then
					local newammo = mod:makeCopiedTable(ammo)
					newammo.Crit = mod:RandomInt(100) < mod:GetFriendCritChance(player)
					ammo = newammo
				end
				mod:HandleFriendBombs(player, params.FriendGun, beebomb, ammo)
			end
			if params.BinabaSatellite then
				beebomb.ExplosionDamage = beebomb.ExplosionDamage * (params.BinabaDamageMulti or 1)
				if params.BinabaOcularSpectrumSats then
					beebomb.RadiusMultiplier = beebomb.RadiusMultiplier * 0.5
				end
				beebomb.Color = mod:GetInabaTearColor(true, params.BinabaSatellite, params.BinabaMigraine, beebomb.Color)
				
				if params.BinabaMigraine then
					local hasBirthcake, birthcakeMult = mod:playerHasBirthcake(player)
					if hasBirthcake then
						if not beebomb:HasTearFlags(TearFlags.TEAR_PIERCING) then
							local data = mod:GetEntityData(beebomb)
							TearFlagsLib.AddTearFlags(beebomb, TearFlagsLib.Flag.MIND_RAZOR)
							TearFlagsLib.SetTearFlagParams(beebomb, mindRazorFlag, {BirthcakeMult = birthcakeMult})
						end
						beebomb:AddTearFlags(TearFlags.TEAR_PIERCING)
						beebomb.CollisionDamage = player.Damage * 2.5 * (params.BinabaDamageMulti or 1)
					end
				end
			end
			mod:GetEntityData(beebomb).FFIsScatter = true
			beebomb.CollisionDamage = beebomb.CollisionDamage * 0.3
			beebomb.ExplosionDamage = beebomb.ExplosionDamage * 0.3
			TearFlagsLib.AddTearFlags(beebomb, flag)
		end
    end
end

function mod:beeSkinFireKnives(player, num, charge, pdata)
	for i = 1, math.min(num, 6) do
		local numberOfBees = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.BEE_SKIN)
		local numshots = math.min(2 + numberOfBees, 8)
		if pdata.BeeSkinAngle ~= nil then
			pdata.BeeSkinAngle = pdata.BeeSkinAngle + 360 / numshots / 6
		else
			pdata.BeeSkinAngle = -90
		end
		
		for i = 1, numshots do
			local ang = (360/numshots) * i
			mod.RerollFetalFriendAmmo = true
			local newknife = player:FireKnife(player, (pdata.BeeSkinAngle + ang) % 360, false, 0, 0):ToKnife()
			mod.RerollFetalFriendAmmo = false
			newknife.CollisionDamage = newknife.CollisionDamage * 0.3
			newknife.Rotation = (pdata.BeeSkinAngle + ang) % 360
			newknife.RotationOffset = 0
			newknife:Shoot(charge, player.TearRange)
			mod:GetEntityData(newknife).RemoveOnReturn = true
			mod:GetEntityData(newknife).WasFlying = true
			newknife.Scale = newknife.Scale * 0.5
			newknife.SpriteScale = newknife.SpriteScale * 0.5
			newknife:AddEntityFlags(EntityFlag.FLAG_DONT_OVERWRITE)
			TearFlagsLib.AddTearFlags(newknife, flag)
			newknife:Update()
		end
	end
end

function mod:beeskinFireLasers(player, num, pdata, params)
	for i = 1, math.min(num, 6) do
		local numberOfBees = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.BEE_SKIN)
		local numshots = math.min(2 + numberOfBees, 8)
		if pdata.BeeSkinAngle ~= nil then
			pdata.BeeSkinAngle = pdata.BeeSkinAngle + 360 / numshots / 6
		else
			pdata.BeeSkinAngle = -90
		end
		
		for i = 1, numshots do
			local angle = pdata.BeeSkinAngle + ((360/numshots) * i)
			mod.RerollFetalFriendAmmo = true
			local newlaser = player:FireTechLaser(player.Position, LaserOffset.LASER_TECH1_OFFSET, Vector.FromAngle(angle), false, true, player, 0.3 * (params.BinabaDamageMulti or 1))
			mod.RerollFetalFriendAmmo = false
			newlaser.OneHit = true
			newlaser.Timeout = 1
			TearFlagsLib.AddTearFlags(newlaser, flag)
			
			-- i still want this to use the tech.5 offset but APPARENTLY rep+ says if you use this you get fruit cake effects so here we are
			local laserOffset = player:GetLaserOffset(LaserOffset.LASER_TECH5_OFFSET, Vector.FromAngle(angle))
			newlaser.Position = newlaser.Position - Vector(newlaser.ParentOffset.X, 0) + Vector(laserOffset.X, 0)
			newlaser.ParentOffset = Vector(laserOffset.X, 0)
			newlaser.PositionOffset = Vector(0, laserOffset.Y * 0.75)
			
			if params.FriendGun then
				local ammo = params.FriendAmmoUsed[mod:RandomInt(1, #params.FriendAmmoUsed)]
				if ammo.HeartKey == "IMMORAL_HEART" or ammo.ForceImmoral then
					local newammo = mod:makeCopiedTable(ammo)
					newammo.Crit = mod:RandomInt(100) < mod:GetFriendCritChance(player)
					ammo = newammo
				end
				mod:HandleFriendLasers(player, params.FriendGun, newlaser, ammo)
			end
			if params.BinabaSatellite then
				newlaser.MaxDistance = player.TearRange
				if params.BinabaOcularSpectrumSats then
					newlaser.MaxDistance = newlaser.MaxDistance * 0.5
				end
				newlaser.Color = mod:GetInabaLaserColor(true, params.BinabaSatellite, params.BinabaMigraine, newlaser.Color)
			end
		end
	end
end

function mod:beeskinFireTechX(player, num, charge, pdata, params)
	for i = 1, math.min(num, 6) do
		local numberOfBees = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.BEE_SKIN)
		local numshots = math.min(2 + numberOfBees, 8)
		if pdata.BeeSkinAngle ~= nil then
			pdata.BeeSkinAngle = pdata.BeeSkinAngle + 360 / numshots / 6
		else
			pdata.BeeSkinAngle = -90
		end
		local vel = Vector.FromAngle(pdata.BeeSkinAngle) * ((params.FriendGun and 4) or 8) * player.ShotSpeed
		
		for i = 1, numshots do
			local damMult = 1
			local scale = 1
			local flat, mult, crit
			local ammo
			if params.FriendGun then
				ammo = params.FriendAmmoUsed[mod:RandomInt(1, #params.FriendAmmoUsed)]
				if ammo.HeartKey == "IMMORAL_HEART" or ammo.ForceImmoral then
					local newammo = mod:makeCopiedTable(ammo)
					newammo.Crit = mod:RandomInt(100) < mod:GetFriendCritChance(player)
					ammo = newammo
				end
				
				flat, mult, crit = mod:GetFriendShotDamageBonus(params.FriendGun, player, ammo)
				local newDamage = (player.Damage + flat)*mult
				damMult = newDamage/player.Damage
				scale = 0.75
			end
			
			local shotvel = vel:Rotated((360 / numshots) * i)
			shotvel = shotvel + player:GetTearMovementInheritance(shotvel)
			mod.RerollFetalFriendAmmo = true
			local newlaser = player:FireTechXLaser(player.Position, shotvel, math.max(6, 20 * charge) * ((params.BinabaSatellite and params.BinabaMigraine and mod:RandomFloat(0.6, 1.0)) or 1), player, math.sqrt(damMult) * (params.BinabaDamageMulti or 1))
			mod.RerollFetalFriendAmmo = false
			newlaser:SetDamageMultiplier(damMult * 0.3 * (params.BinabaDamageMulti or 1))
			if params.BinabaSatellite then
				local powerScale = math.min(math.max(0, (params.BinabaPower - 100) / 300), 1)
				scale = scale * (1 + 0.5 * powerScale)
			end
			newlaser:SetScale(newlaser:GetScale()*scale*0.85)
			TearFlagsLib.AddTearFlags(newlaser, flag)
				
			if params.FriendGun then
				newlaser.Parent = params.FriendGun
				TearFlagsLib.AddTearFlags(newlaser, mod.FriendBulletFlags.FRIEND)
				TearFlagsLib.SetTearFlagParams(newlaser, mod.FriendBulletFlags.FRIEND, {NoRemove = true, Shot = ammo, Gun = params.FriendGun, NoLasers = true})

				mod:ApplyFriendLaserShotEffects(newlaser, player, ammo, crit)
			end
			if params.BinabaSatellite then
				newlaser.Color = mod:GetInabaLaserColor(true, params.BinabaSatellite, params.BinabaMigraine, newlaser.Color)
			end
			
			newlaser:Update()
			if newlaser.Child and newlaser.Child.Type == EntityType.ENTITY_EFFECT and newlaser.Child.Variant == EffectVariant.LASER_IMPACT then
				newlaser.Child.Visible = false
				newlaser.Child:Remove()
			end
		end
	end
end

function mod:beeSkinlocustAI(fam, sub)
	if fam.FireCooldown == -1 then
		local d = mod:GetEntityData(fam)
		local p = fam.Player or Isaac.GetPlayer()
		if fam.FrameCount % 5 == 1 then
			d.BeeSkinAngle = (d.BeeSkinAngle or -110) + 20
			local vel = Vector.FromAngle(d.BeeSkinAngle):Resized(8) + (fam.Velocity)
			local beeskintear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, fam.Position + fam.Velocity, vel, fam):ToTear()
			--print(fam.FireCooldown)
			beeskintear.CollisionDamage = mod:getLocustDamage(fam) * 0.1
			beeskintear.Scale = beeskintear.Scale * 0.3
			beeskintear:Update()
		end
	end
end

function mod:fireBeeSkinBrimstone(player, timeout, damagemult, params)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.BEE_SKIN) then
		local data = mod:GetEntityData(player)
		data.BeeSkinBrimstone = data.BeeSkinBrimstone or {}
		local beedata = data.BeeSkinBrimstone
		params = params or {}

		local numberOfBees = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.BEE_SKIN)
		local numshots = math.min(2 + numberOfBees, 8)

		beedata.Angle = beedata.Angle or math.random(360)
		beedata.Lasers = beedata.Lasers or {}
		beedata.FriendGun = params.FriendGun or beedata.FriendGun
		beedata.FriendShot = params.FriendShot or beedata.FriendShot
		
		for i = 1, math.max(numshots, #beedata.Lasers) do
			if not (beedata.Lasers[i] and beedata.Lasers[i]:Exists() and beedata.Lasers[i].Timeout > 0) then
				if beedata.Lasers[i] and beedata.Lasers[i]:Exists() then
					beedata.Lasers[i]:Remove()
				end
				local angle = beedata.Angle + 360 / numshots * i
				local vel = Vector.FromAngle(angle)
				
				local sizemulti = 1.0
				if params.BinabaSatellite then
					if params.BinabaMigraine then
						sizemulti = 1.0 + params.BinabaPower / 100
					end
					if params.BinabaOcularSpectrumSats then
						sizemulti = sizemulti * 0.25
					end
				end
				beedata.Lasers[i] = player:FireBrimstone(vel, player, 0.3 * damagemult * sizemulti)
				if params.BinabaSatellite and params.BinabaDamageMulti then
					beedata.Lasers[i]:SetDamageMultiplier(0.3 * params.BinabaDamageMulti)
				end
				TearFlagsLib.AddTearFlags(beedata.Lasers[i], flag)
				
				if params.BinabaSatellite then
					if params.BinabaOcularSpectrumSats then
						beedata.Lasers[i].MaxDistance = (player.TearRange / 2)
					end
					beedata.Lasers[i].Color = mod:GetInabaLaserColor(true, params.BinabaSatellite, params.BinabaMigraine, beedata.Lasers[i].Color)
				end
			end
			
			local brim = beedata.Lasers[i]
			brim.PositionOffset = Vector(0, brim.PositionOffset.Y)
			brim.Timeout = timeout
			brim.DepthOffset = -5
			
			if params.FriendShot then
				local ammo = params.FriendShot
				if ammo.HeartKey == "IMMORAL_HEART" or ammo.ForceImmoral then
					local newammo = mod:makeCopiedTable(ammo)
					newammo.Crit = mod:RandomInt(100) < mod:GetFriendCritChance(player)
					ammo = newammo
				end
				
				local flat, mult, crit = mod:GetFriendShotDamageBonus(beedata.FriendGun, player, ammo)
				local newDamage = (player.Damage + flat)*mult
				local shotMult = newDamage/player.Damage
				brim:SetDamageMultiplier(0.3 * damagemult * shotMult)

				mod:ApplyFriendLaserShotEffects(brim, player, ammo, crit, true)
				local ld = mod:GetEntityData(brim)
				if ld.FriendLaserSwirl and ld.FriendLaserSwirl:Exists() then
					local swirl = ld.FriendLaserSwirl
					mod:ApplyFriendGenericShotEffects(swirl, player, ammo, ammo.Crit, true, true)
					swirl.Color = mod:GetFriendShotLaserColor(swirl, player)
				end
			end
		end
	end
end

function mod:triggerBeeSkinBrimstone(weapon)
	local player = weapon:GetOwner()
	if player.Type == EntityType.ENTITY_FAMILIAR then
		player = player:ToFamiliar().Player
	end
	player = player:ToPlayer()
	if not player then return end
	
	local data = mod:GetEntityData(player)
	local charge = weapon:GetCharge()
	local maxFireDelay = weapon:GetMaxFireDelay()
	local fireDirection = player:GetFireDirection()
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.BEE_SKIN) then
		local isIndefinite = maxFireDelay <= 1 or (player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) and charge == 0 and data.FFLastBrimstoneWeaponCharge ~= nil and (data.FFLastBrimstoneWeaponCharge >= data.FFLastBrimstoneWeaponMaxFireDelay or data.FFBrimstoneWeaponWasFiring))
		if (isIndefinite and fireDirection ~= Direction.NO_DIRECTION) or 
		   (not (maxFireDelay <= 1) and charge == 0 and data.FFLastBrimstoneWeaponCharge ~= nil and (data.FFLastBrimstoneWeaponCharge >= data.FFLastBrimstoneWeaponMaxFireDelay))
		then
			local isAzazelWeakBrim = player:GetPlayerType() == PlayerType.PLAYER_AZAZEL_B and not (player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) or player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_BRIMSTONE))
			mod:fireBeeSkinBrimstone(player, (isAzazelWeakBrim and not isIndefinite and 1) or 9, (isAzazelWeakBrim and 0.5) or 1)
			data.FFBrimstoneWeaponWasFiring = true
		else
			data.FFBrimstoneWeaponWasFiring = false
		end
	end
	data.FFLastBrimstoneWeaponCharge = charge
	data.FFLastBrimstoneWeaponMaxFireDelay = maxFireDelay
	data.FFLastBrimstoneWeaponFireDirection = fireDirection
end
mod:AddCallback(ModCallbacks.MC_POST_WEAPON_FIRE, mod.triggerBeeSkinBrimstone, WeaponType.WEAPON_BRIMSTONE)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, urn)
	if urn.SubType == 1 then
		local player = urn.Parent
		if not (player and player.Type == EntityType.ENTITY_PLAYER) then return end
		player = player:ToPlayer()
		
		if urn.State == 2 or urn.State == 3 then
			mod:fireBeeSkinBrimstone(player, 8, 1)
		end
	end
end, EffectVariant.URN_OF_SOULS)

function mod:beeSkinBrimstone(player, data)
	if data.BeeSkinBrimstone then
		local beedata = data.BeeSkinBrimstone
		local ptype = player:GetPlayerType()
		beedata.Angle = (beedata.Angle or math.random(360)) + 3 * player.ShotSpeed * (((ptype == mod.PLAYER.FRIEND or ptype == mod.PLAYER.BRIEND) and 0.5) or 1)
		
		local someExists = false
		for i = 1, #beedata.Lasers do
			if beedata.Lasers[i] and beedata.Lasers[i]:Exists() then
				local brim = beedata.Lasers[i]
				
				local angle = beedata.Angle + 360 / #beedata.Lasers * i
				brim.Angle = angle
				brim.PositionOffset = Vector(0, beedata.Lasers[i].PositionOffset.Y)
				
				someExists = true
			end
		end
		if not someExists then
			data.BeeSkinBrimstone = nil
		end
	end
end

function mod:fireBeeSkinEpicFetus(target, player)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.BEE_SKIN) then
		local tdata = mod:GetEntityData(target)
		if not (tdata.FFIsDoctorsRemote or tdata.InabaFollowIndex or tdata.VinetaArtillery or tdata.beeSkinTarget or tdata.StoredBeeSkinTargets) then
			local numberOfBees = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.BEE_SKIN)
			local numshots = math.min(2 + numberOfBees, 8)
			local angle = math.random(360)

			tdata.StoredBeeSkinTargets = {}
			for i = 1, numshots do
				local tangle = angle + 360 / numshots * i
				local offset = Vector.FromAngle(tangle):Resized(40)
				local newTarget = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TARGET, 0, target.Position + offset, nilvector, player):ToEffect()
				local ntdata = mod:GetEntityData(newTarget)
				ntdata.beeSkinTarget = true
				newTarget.Parent = target
				ntdata.beeSkinTargetAngle = tangle
				newTarget.SpriteScale = Vector(0.5,0.5)
				newTarget:SetTimeout(target:ToEffect().Timeout + 1)
				if tdata.binabaFetusRocket then
					local sprite = newTarget:GetSprite()
					sprite:ReplaceSpritesheet(0, "gfx/effects/effect_inaba_rocket_target.png")
					sprite:LoadGraphics()
					newTarget.SpriteScale = Vector.Zero
					ntdata.binabaFetusRocket = true
				end
				newTarget:Update()
				table.insert(tdata.StoredBeeSkinTargets, newTarget)
			end
		end
	end
end

function mod:triggerBeeSkinEpicFetus(weapon)
	local player = weapon:GetOwner()
	if player.Type == EntityType.ENTITY_FAMILIAR then
		player = player:ToFamiliar().Player
	end
	player = player:ToPlayer()
	if not player then return end
	
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.BEE_SKIN) then
		local targets = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.TARGET)
		for _, target in ipairs(targets) do
			if target.FrameCount == 0 and target.SubType ~= 4 and target.SpawnerEntity and
			   target.SpawnerEntity.Index == player.Index and target.SpawnerEntity.InitSeed == player.InitSeed
			then
				mod:fireBeeSkinEpicFetus(target, player)
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_WEAPON_FIRE, mod.triggerBeeSkinEpicFetus, WeaponType.WEAPON_ROCKETS)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
    local data = mod:GetEntityData(eff)
    if data.beeSkinTarget then
		eff:GetSprite():RemoveOverlay()
		if not eff.Parent then
			eff:Remove() 
			return 
		end
		local player = eff.SpawnerEntity:ToPlayer()
        data.beeSkinTargetAngle = data.beeSkinTargetAngle + -3 * player.ShotSpeed * (((ptype == mod.PLAYER.FRIEND or ptype == mod.PLAYER.BRIEND) and 0.5) or 1)
		local offset = Vector.FromAngle(data.beeSkinTargetAngle):Resized(40)
		if data.binabaFetusRocket then
			offset = offset * (eff.SpriteScale.X / 0.5)
		end
		eff.Velocity = (eff.Parent.Position + eff.Parent.Velocity + offset) - eff.Position
    end
end, EffectVariant.TARGET)

function mod:handleBeeSkinRockets(rocketdata, targetdata, rocket, target, player)
    if targetdata.StoredBeeSkinTargets and not targetdata.binabaFetusRocket then
        for _, beeTarg in pairs (targetdata.StoredBeeSkinTargets) do
			mod.RerollFetalFriendAmmo = true
			mod.NoFireFetalFriend = true
			mod.CurrentRocketTarget = beeTarg
            local newRocket = Isaac.Spawn(1000, EffectVariant.ROCKET, 0, beeTarg.Position, Vector.Zero, player):ToEffect()
			mod.RerollFetalFriendAmmo = false
			mod.NoFireFetalFriend = false
			mod.CurrentRocketTarget = nil
            newRocket:FollowParent(beeTarg)
            newRocket.Timeout = math.floor(rocket.Timeout + 1)
            newRocket.SpriteScale = newRocket.SpriteScale * 0.5
            TearFlagsLib.AddTearFlags(newRocket, flag)
            newRocket:Update()
        end
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_EFFECT_UPDATE, function(_, rocket)
	-- rgon doesnt have any callbacks for bomb_explosion_effects rn and i need to shrink the scale of the explosion so
	if rocket:IsDead() and rocket:Exists() and TearFlagsLib.HasTearFlags(rocket, flag) then
		local player = rocket.SpawnerEntity
		if not (player and player.Type == EntityType.ENTITY_PLAYER) then
			game:BombExplosionEffects(rocket.Position, 24, TearFlags.TEAR_NORMAL, Color.Default, rocket, 0.5)
		else
			player = player:ToPlayer()
			local params = player:GetTearHitParams(WeaponType.WEAPON_ROCKETS, 1, (math.random(2) == 1 and 1) or -1, player)
			if player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) or
			   player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) or
			   player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) or
			   player:HasWeaponType(WeaponType.WEAPON_KNIFE) or
			   player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY) or
			   player:HasWeaponType(WeaponType.WEAPON_LASER) or
			   player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_X) or
			   player:HasWeaponType(WeaponType.WEAPON_TECH_X)
			then
				params.TearFlags = params.TearFlags | TearFlags.TEAR_SAD_BOMB
			end
			game:BombExplosionEffects(rocket.Position, params.TearDamage * 20 * 0.3, params.TearFlags, params.TearColor, rocket, 0.5)
		end
		rocket:Remove()
		return true
	end
end, EffectVariant.ROCKET)