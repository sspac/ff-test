-- Secondary Fire Callbacks

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero
mod.IgnoreSecondaryFireEffects = false

function mod:SpawnPlayerTear(player, pos, vel, modifierFunc)
	if player == nil then return end
	
	local tearparams = player:GetTearHitParams(WeaponType.WEAPON_TEARS, 1)
	local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, tearparams.TearVariant, 0, pos, vel, player):ToTear()
	tear.Parent = player
	
	tear.Height = tearparams.TearHeight
	tear.PositionOffset = Vector(0, tear.Height)
	tear.FallingSpeed = -1 * player.TearFallingSpeed
	tear.FallingAcceleration = player.TearFallingAcceleration
	
	tear.CollisionDamage = tearparams.TearDamage
	tear.Scale = tearparams.TearScale
	tear:SetDeadEyeIntensity(math.max(tear:GetDeadEyeIntensity(), player:GetDeadEyeCharge() / 8))
	tear:ResetSpriteScale(true)
	tear.CanTriggerStreakEnd = false
	
	--[[local mass = 8
	local knockbackmult = 1
	if player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK) then
		mass = 2.4
	elseif player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
		mass = 1.6
	end
	if player:HasTrinket(TrinketType.TRINKET_BLISTER) then
		mass = mass * 3
		knockbackmult = 3
	elseif player:HasCollectible(CollectibleType.COLLECTIBLE_8_INCH_NAILS) then
		mass = mass * 3
		knockbackmult = 2
	elseif player:HasCollectible(CollectibleType.COLLECTIBLE_PISCES) then
		mass = mass * 3
	end]]--
	tear.Mass = 8 * tearparams.MassMultiplier
	tear.KnockbackMultiplier = tearparams.KnockbackMultiplier
	
	tear.Color = tearparams.TearColor
	tear.TearFlags = tearparams.TearFlags
	tear:ClearTearFlags(TearFlags.TEAR_LUDOVICO | TearFlags.TEAR_FETUS | TearFlags.TEAR_FETUS_BOMBER |
	                    TearFlags.TEAR_FETUS_BRIMSTONE | TearFlags.TEAR_FETUS_TECH | TearFlags.TEAR_FETUS_TECHX |
	                    TearFlags.TEAR_FETUS_KNIFE | TearFlags.TEAR_FETUS_BONE | TearFlags.TEAR_FETUS_SWORD |
	                    TearFlags.TEAR_CHAIN)
	
	if modifierFunc then 
		modifierFunc(tear, player) 
	end
	
	TearFlagsLib.CallPollTearFlagCallback(tear, player, TearFlagsLib.WeaponFlag.TEAR)
	
	return tear
end

mod:AddCallback(ModCallbacks.MC_POST_FIRE_BRIMSTONE, function(_, laser)
	if mod.IgnoreSecondaryFireEffects then return end
	
	local var = laser.Variant
	if var == 4 or var == 7 or var == 8 or var == 13 then -- Pride, Tractor Beam, Circle of Protection and Beast Lasers
		return
	end
	
	local player = nil
	if not laser.SpawnerEntity then
		return
	elseif laser.SpawnerType == EntityType.ENTITY_PLAYER then
		player = laser.SpawnerEntity:ToPlayer()
	elseif laser.SpawnerType == EntityType.ENTITY_FAMILIAR then
		local familiar = laser.SpawnerEntity:ToFamiliar()

		if not familiar.Player then
			return
		elseif familiar.Variant == FamiliarVariant.INCUBUS or familiar.Variant == FamiliarVariant.SPRINKLER or
		       familiar.Variant == FamiliarVariant.TWISTED_BABY or familiar.Variant == FamiliarVariant.BLOOD_BABY or
		       familiar.Variant == FamiliarVariant.UMBILICAL_BABY or familiar.Variant == FamiliarVariant.CAINS_OTHER_EYE
		then
			player = familiar.Player
		else
			return
		end
	else
		return
	end
	
	local data = mod:GetEntityData(laser)
	data.PlayerFiredLaser = player
end)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_FAMILIAR_UPDATE, math.huge, function(_, familiar)
	if not familiar:HasEntityFlags(EntityFlag.FLAG_APPEAR) or familiar.FrameCount >= 5 then
		mod.FireTearSource = familiar
	end
end, FamiliarVariant.INCUBUS)

mod:AddPriorityCallback(ModCallbacks.MC_FAMILIAR_UPDATE, -1 * math.huge, function()
	mod.FireTearSource = nil
end, FamiliarVariant.INCUBUS)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_FAMILIAR_UPDATE, math.huge, function(_, familiar)
	if not familiar:HasEntityFlags(EntityFlag.FLAG_APPEAR) or familiar.FrameCount >= 5 then
		mod.FireTearSource = familiar
	end
end, FamiliarVariant.TWISTED_BABY)

mod:AddPriorityCallback(ModCallbacks.MC_FAMILIAR_UPDATE, -1 * math.huge, function()
	mod.FireTearSource = nil
end, FamiliarVariant.TWISTED_BABY)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_FAMILIAR_UPDATE, math.huge, function(_, familiar)
	if not familiar:HasEntityFlags(EntityFlag.FLAG_APPEAR) or familiar.FrameCount >= 5 then
		mod.FireTearSource = familiar
	end
end, FamiliarVariant.BLOOD_BABY)

mod:AddPriorityCallback(ModCallbacks.MC_FAMILIAR_UPDATE, -1 * math.huge, function()
	mod.FireTearSource = nil
end, FamiliarVariant.BLOOD_BABY)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_FAMILIAR_UPDATE, math.huge, function(_, familiar)
	if not familiar:HasEntityFlags(EntityFlag.FLAG_APPEAR) or familiar.FrameCount >= 5 then
		mod.FireTearSource = familiar
	end
end, FamiliarVariant.UMBILICAL_BABY)

mod:AddPriorityCallback(ModCallbacks.MC_FAMILIAR_UPDATE, -1 * math.huge, function()
	mod.FireTearSource = nil
end, FamiliarVariant.UMBILICAL_BABY)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_FAMILIAR_UPDATE, math.huge, function(_, familiar)
	if not familiar:HasEntityFlags(EntityFlag.FLAG_APPEAR) or familiar.FrameCount >= 5 then
		mod.FireTearSource = familiar
	end
end, FamiliarVariant.CAINS_OTHER_EYE)

mod:AddPriorityCallback(ModCallbacks.MC_FAMILIAR_UPDATE, -1 * math.huge, function()
	mod.FireTearSource = nil
end, FamiliarVariant.CAINS_OTHER_EYE)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_FAMILIAR_UPDATE, math.huge, function(_, familiar)
	if not familiar:HasEntityFlags(EntityFlag.FLAG_APPEAR) or familiar.FrameCount >= 5 then
		mod.IsSprinklerTear = familiar
	end
end, FamiliarVariant.SPRINKLER)

mod:AddPriorityCallback(ModCallbacks.MC_FAMILIAR_UPDATE, -1 * math.huge, function()
	mod.IsSprinklerTear = nil
end, FamiliarVariant.SPRINKLER)

function mod:tearIsReplaceableBySecondaryFire(tear)
	return (tear.CanTriggerStreakEnd and not tear:HasTearFlags(TearFlags.TEAR_FETUS)) or mod.IsHatredTear
end

mod.SecondaryFireTearFlags = {}
mod.UnstackableSecondaryFireTearFlags = {}
local numFlags = 0
function mod:AddSecondaryFireTearFlag(key, stackable)
	mod.SecondaryFireTearFlags[key] = 1 << numFlags
	numFlags = numFlags + 1
	if not stackable then table.insert(mod.UnstackableSecondaryFireTearFlags, key) end
	return mod.SecondaryFireTearFlags[key]
end
mod:AddSecondaryFireTearFlag("RECURSIVE")

function mod:HasUnstackableSecondaryFlag(flags)
	for _, key in ipairs(mod.UnstackableSecondaryFireTearFlags) do
		if flags & mod.SecondaryFireTearFlags[key] ~= 0 then
			return true
		end
	end
	return false
end

function mod:checkReplaceableSecondaryFiredTears(tear, player, forceSource, flags)
	if forceSource or mod:tearIsReplaceableBySecondaryFire(tear) then
		local flags = flags or 0
		local vel = tear.Velocity
		local callbacks = Isaac.GetCallbacks(FiendFolio.CALLBACK.FF_SECONDARY_FIRE_TEAR_EFFECTS, true)
		for _, v in ipairs(callbacks) do
			local result = v.Function(v.Mod, tear, player, vel, forceSource or mod.FireTearSource or mod.IsHatredTear or player, flags)
			if result then
				flags = result
			end
		end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_WEAPON_FIRED, function(_, fireDir, amount, owner, weapon)
	if amount <= 0 or mod.IgnoreSecondaryFireEffects then return end
	
	local player
	if owner.Type == EntityType.ENTITY_PLAYER then
		player = owner:ToPlayer()
	elseif owner.Type == EntityType.ENTITY_FAMILIAR then
		player = owner:ToFamiliar().Player
	end
	if player == nil then return end
	
	local params = {}
	params.WeaponType = weapon:GetWeaponType()
	params.WeaponModifiers = weapon:GetModifiers()
	params.WeaponMaxFireDelay = weapon:GetMaxFireDelay()
	params.WeaponCharge = weapon:GetCharge()
	local dir = fireDir
	if dir.X == 0.0 and dir.Y == 0.0 then
		dir = player:GetAimDirection()
		if dir.X == 0.0 and dir.Y == 0.0 then
			dir = weapon:GetDirection()
		end
	end
	
	local func = function()
		params.NumTears = player:GetMultiShotParams(params.WeaponType):GetNumTears()
		params.IsSpinAttack = false
		if params.WeaponType == WeaponType.WEAPON_URN_OF_SOULS then
			params.NumTears = 1
		elseif params.WeaponType == WeaponType.WEAPON_SPIRIT_SWORD then
			for _, knife in ipairs(Isaac.FindByType(EntityType.ENTITY_KNIFE)) do
				if knife.SubType == 0 and knife.Parent and GetPtrHash(knife.Parent) == GetPtrHash(owner) and knife:ToKnife():GetIsSpinAttack() then
					params.IsSpinAttack = true
					break
				end
			end
			if not params.IsSpinAttack then
				params.NumTears = 1
			end
		end
		local isMonstrosLung = (params.WeaponType == WeaponType.WEAPON_MONSTROS_LUNGS or params.WeaponModifiers & WeaponModifier.MONSTROS_LUNG == WeaponModifier.MONSTROS_LUNG) and 
		                       params.WeaponType ~= WeaponType.WEAPON_URN_OF_SOULS and params.WeaponType ~= WeaponType.WEAPON_SPIRIT_SWORD and params.WeaponType ~= WeaponType.WEAPON_FETUS
		if isMonstrosLung then
			params.NumTears = 12 + math.floor(2.4 * params.NumTears)
		end
		
		Isaac.RunCallback(FiendFolio.CALLBACK.FF_SECONDARY_FIRE_INCLUDE_LUDO_IN_CLEARED_ROOM, player, dir, amount, owner, params)
		if (params.WeaponType == WeaponType.WEAPON_LUDOVICO_TECHNIQUE or params.WeaponModifiers & WeaponModifier.LUDOVICO_TECHNIQUE ~= 0) and game:GetRoom():IsClear() then 
			if (not (player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS) or 
					 player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_X) or
					 player:HasCollectible(CollectibleType.COLLECTIBLE_SPIRIT_SWORD) or
					 player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION) or
					 player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN or 
					 player:GetPlayerType() == PlayerType.PLAYER_LILITH_B) or 
				player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE)) 
			then
				return
			end
		end
		Isaac.RunCallback(FiendFolio.CALLBACK.FF_SECONDARY_FIRE, player, dir, amount, owner, params)
	end
	
	if params.WeaponType == WeaponType.WEAPON_SPIRIT_SWORD then
		mod.scheduleForUpdate(func, 1)
	else
		func()
	end
end)

function mod:SecondaryFire(player, dir, amount, owner, params)
	if amount <= 0 or mod.IgnoreSecondaryFireEffects then return end

	local dir = dir:Normalized()
	local owner = owner or player
	local params = params or {}
	params.WeaponType = params.WeaponType or WeaponType.WEAPON_TEARS
	params.WeaponModifiers = params.WeaponModifiers or 0
	params.WeaponMaxFireDelay = params.WeaponMaxFireDelay or player.MaxFireDelay
	params.WeaponCharge = params.WeaponCharge or 0
	params.NumTears = params.NumTears or amount
	params.IsSpinAttack = params.IsSpinAttack or false
	
	if params.DoBasegameEffects then
		local mainplayer = (player:GetPlayerType() == mod.PLAYER.BRIEND and player:GetMainTwin()) or player
		
		if mainplayer:HasCollectible(CollectibleType.COLLECTIBLE_ISAACS_TEARS) then
			for i = ActiveSlot.SLOT_PRIMARY, ActiveSlot.SLOT_POCKET2 do
				local active = mainplayer:GetActiveItem(i)
				if active == CollectibleType.COLLECTIBLE_ISAACS_TEARS then
					mainplayer:AddActiveCharge(amount, i, false, false, true)
				end
			end
		end
		
		local hasMomsWig = player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_WIG)
		local hasImmaculateHeart = player:HasCollectible(CollectibleType.COLLECTIBLE_IMMACULATE_HEART)
		local hasTornCard = player:HasTrinket(TrinketType.TRINKET_TORN_CARD)
		local hasBirdsEye = player:HasCollectible(CollectibleType.COLLECTIBLE_BIRDS_EYE)
		local hasGhostPepper = player:HasCollectible(CollectibleType.COLLECTIBLE_GHOST_PEPPER)
		local hasEyeOfGreed = player:HasCollectible(CollectibleType.COLLECTIBLE_EYE_OF_GREED)
		local hasLeadPencil = player:HasCollectible(CollectibleType.COLLECTIBLE_LEAD_PENCIL)
		for i = 1, amount do
			local data = mod:GetEntityData(owner)
			data.FFSecondaryFiredNum = (data.FFSecondaryFiredNum or 0) + 1
			
			if hasMomsWig then
				if Isaac.CountEntities(player, EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_SPIDER) < ((player:HasCollectible(CollectibleType.COLLECTIBLE_HIVE_MIND) and 10) or 5) then
					if math.random() < 1 / math.max(1, 20 - math.floor(player.Luck * 2)) then
						local pos = game:GetRoom():FindFreePickupSpawnPosition(owner.Position)
						player:ThrowBlueSpider(player.Position, pos)
					end
				end
			end
			
			if hasImmaculateHeart and math.random() < 1/3 then
				local dir = Isaac.GetAxisAlignedUnitVectorFromDir(player:GetHeadDirection())
				local vel = dir * 10
				vel = (vel + player:GetTearMovementInheritance(vel)) * player.ShotSpeed
				
				local tear = player:FireTear(owner.Position, vel, true, false, false, owner)
				if not tear:HasTearFlags(TearFlags.TEAR_ORBIT) then
					tear.FallingSpeed = tear.FallingSpeed - 7
					tear.FallingAcceleration = tear.FallingAcceleration * 0.01
				end
				tear:ClearTearFlags(TearFlags.TEAR_BOOMERANG | TearFlags.TEAR_OCCULT)
				tear:AddTearFlags(TearFlags.TEAR_ORBIT_ADVANCED | TearFlags.TEAR_SPECTRAL)
				tear.Color = tear.Color * Color(1.5, 2, 2, 1)
				tear.SpawnerEntity = owner
				
				if params.Hatred then
					tear.CollisionDamage = tear.CollisionDamage * 0.55 * params.Hatred:ToFamiliar():GetMultiplier()
					tear:AddTearFlags(TearFlags.TEAR_SLOW | TearFlags.TEAR_GISH)
					mod:makeTearBloody(tear)
					tear.Color = mod.ColorDankBlackReal
				end
				
				Isaac.RunCallback(FiendFolio.CALLBACK.FF_POST_IMMACULATE_HEART, tear, player, owner, params)
			end
			
			local tearDisplacement = (math.random(2) == 1 and 1) or -1
			if hasTornCard and data.FFSecondaryFiredNum % 15 == 1 then
				local tearparams = player:GetTearHitParams(WeaponType.WEAPON_TEARS, 1, tearDisplacement)
				
				local damage = tearparams.TearDamage
				local scale = tearparams.TearScale
				if not player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) then
					damage = damage + 40
					scale = scale + 0.3
				end
				local color = Color(0.5, 0.9, 0.4, 1)
				local flags = tearparams.TearFlags | TearFlags.TEAR_EXPLOSIVE | TearFlags.TEAR_POISON | TearFlags.TEAR_BOOMERANG
				
				local dir = Isaac.GetAxisAlignedUnitVectorFromDir(player:GetHeadDirection())
				local vel = dir * 16
				vel = vel + player:GetTearMovementInheritance(vel)
				
				local tear = mod:SpawnPlayerTear(player, owner.Position, vel, function(tear, player)
					if not player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) then
						tear.CollisionDamage = tear.CollisionDamage + 40
						tear.Scale = tear.Scale + 0.3
					end
					tear:ResetSpriteScale(true)
					tear.Color = color
					tear:AddTearFlags(TearFlags.TEAR_EXPLOSIVE | TearFlags.TEAR_POISON | TearFlags.TEAR_BOOMERANG)
					
					tear.CanTriggerStreakEnd = false
					tear.FallingAcceleration = 0.8
					tear.FallingSpeed = ((-5.0 - tear.Height) - (50 - 9.442306) * 9) / 9.442306 -- man idk
				end)
				if params.FriendGun then
					local ammo = params.FriendAmmoUsed[mod:RandomInt(1, #params.FriendAmmoUsed)]
					if ammo.HeartKey == "IMMORAL_HEART" or ammo.ForceImmoral then
						local newammo = mod:makeCopiedTable(ammo)
						newammo.Crit = mod:RandomInt(100) < mod:GetFriendCritChance(player)
						ammo = newammo
					end
					mod:HandleFriendTears(player, params.FriendGun, tear, ammo)
				end
				if params.Hatred then
					tear.CollisionDamage = tear.CollisionDamage * 0.75 * 0.55 * params.Hatred:ToFamiliar():GetMultiplier()
					tear:AddTearFlags(TearFlags.TEAR_SLOW | TearFlags.TEAR_GISH)
					mod:makeTearBloody(tear)
					tear.Color = mod.ColorDankBlackReal
				end
				Isaac.RunCallback(FiendFolio.CALLBACK.FF_POST_TORN_CARD, tear, player, owner, params)
				tear:Update()
			end
			
			if hasBirdsEye and hasGhostPepper then
				if math.random() < math.min(0.5, 1 / math.max(1, 8 - math.floor(player.Luck))) then
					if math.random() < 0.5 then 
						player:ShootRedCandle(dir)
					else
						player:ShootBlueCandle(dir)
					end
					data.FFSecondaryFiredNum = (data.FFSecondaryFiredNum or 0) + 1 -- ??? why does it work like this
				end
			elseif hasGhostPepper then
				if math.random() < math.min(0.5, 1 / math.max(1, 12 - math.floor(player.Luck))) then
					player:ShootBlueCandle(dir)
					data.FFSecondaryFiredNum = (data.FFSecondaryFiredNum or 0) + 1 -- ??? why does it work like this
				end
			elseif hasBirdsEye then
				if math.random() < math.min(0.5, 1 / math.max(1, 12 - math.floor(player.Luck))) then
					player:ShootRedCandle(dir)
					data.FFSecondaryFiredNum = (data.FFSecondaryFiredNum or 0) + 1 -- ??? why does it work like this
				end
			end
			
			if hasEyeOfGreed and data.FFSecondaryFiredNum % 20 == 0 then
				local tearparams = player:GetTearHitParams(WeaponType.WEAPON_TEARS, 1, tearDisplacement)
				local vel = dir * 10
				vel = (vel + player:GetTearMovementInheritance(vel)) * player.ShotSpeed
				
				local tear = mod:SpawnPlayerTear(player, owner.Position, vel, function(tear, player)
					if player:GetNumCoins() <= 0 then
						tear:AddTearFlags(TearFlags.TEAR_MIDAS)
					else
						player:AddCoins(-1)
						tear.CollisionDamage = tear.CollisionDamage * 1.5 + 10
						tear:AddTearFlags(TearFlags.TEAR_MIDAS | TearFlags.TEAR_COIN_DROP)
					end
					
					tear.CanTriggerStreakEnd = false
					tear.FallingSpeed = tear.FallingSpeed - 7
					tear.FallingAcceleration = tear.FallingAcceleration * 0.01
				end)
				if params.FriendGun then
					local ammo = params.FriendAmmoUsed[mod:RandomInt(1, #params.FriendAmmoUsed)]
					if ammo.HeartKey == "IMMORAL_HEART" or ammo.ForceImmoral then
						local newammo = mod:makeCopiedTable(ammo)
						newammo.Crit = mod:RandomInt(100) < mod:GetFriendCritChance(player)
						ammo = newammo
					end
					mod:HandleFriendTears(player, params.FriendGun, tear, ammo)
				end
				if params.Hatred then
					tear.CollisionDamage = tear.CollisionDamage * 0.75 * 0.55 * params.Hatred:ToFamiliar():GetMultiplier()
					tear:AddTearFlags(TearFlags.TEAR_SLOW | TearFlags.TEAR_GISH)
					mod:makeTearBloody(tear)
					tear.Color = mod.ColorDankBlackReal
				end
				if tear.Variant ~= TearVariant.COIN then
					tear:ChangeVariant(TearVariant.COIN)
					tear:ResetSpriteScale(true)
				end
				tear.Color = Color()
				Isaac.RunCallback(FiendFolio.CALLBACK.FF_POST_EYE_OF_GREED, tear, player, owner, params)
				tear:Update()
				sfx:Play(SoundEffect.SOUND_CASH_REGISTER)
			end
			
			if hasLeadPencil and data.FFSecondaryFiredNum % 15 == 0 then
				if not Isaac.RunCallback(FiendFolio.CALLBACK.FF_PRE_LEAD_PENCIL_FIRE_BURST, player, dir, owner, params) then
					local dir = Isaac.GetAxisAlignedUnitVectorFromDir(player:GetHeadDirection())
					local vel = dir * 10
					vel = (vel + player:GetTearMovementInheritance(vel)) * player.ShotSpeed
					
					mod:GetMonstroBurstInfo(owner.Position, vel, 12)
					
					local hasIpecac = player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC)
					for _, tearInfo in ipairs(mod:GetMonstroBurstInfo(owner.Position, vel, 12, -1 * player.TearFallingSpeed, player.TearFallingAcceleration)) do
						local tearparams = player:GetTearHitParams(WeaponType.WEAPON_TEARS, 1, tearDisplacement)
						
						local tear = mod:SpawnPlayerTear(player, tearInfo.Pos, tearInfo.Vel, function(tear, player)
							mod:makeTearBloody(tear)
							tear.Scale = math.max(tear.Scale * tearInfo.ScaleMult, 0.01)
							tear:ResetSpriteScale(true)
							
							tear.CanTriggerStreakEnd = false
							tear.FallingSpeed = mod:RandomFloat(0, 0.2) - player.TearFallingSpeed
							
							if not hasIpecac then
								tear.FallingAcceleration = tear.FallingAcceleration + 0.5
								tear.FallingSpeed = (player.TearFallingSpeed - mod:RandomFloat() * 15) + 5
							end
						end)
						mod:makeTearBloody(tear)
						if params.Hatred then
							tear.CollisionDamage = tear.CollisionDamage * 0.75 * 0.55 * params.Hatred:ToFamiliar():GetMultiplier()
							tear:AddTearFlags(TearFlags.TEAR_SLOW | TearFlags.TEAR_GISH)
							tear.Color = mod.ColorDankBlackReal
						end
						Isaac.RunCallback(FiendFolio.CALLBACK.FF_POST_LEAD_PENCIL_FIRE_TEAR, tear, player, owner, params)
						tear:Update()
					end
					Isaac.RunCallback(FiendFolio.CALLBACK.FF_POST_LEAD_PENCIL_FIRE_BURST, player, dir, owner, params)
				end
			end
		end
	end
	
	Isaac.RunCallback(FiendFolio.CALLBACK.FF_SECONDARY_FIRE_INCLUDE_LUDO_IN_CLEARED_ROOM, player, dir, amount, owner, params)
	if params.WeaponType == WeaponType.WEAPON_LUDOVICO_TECHNIQUE and game:GetRoom():IsClear() then 
		if (not (player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS) or 
				 player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_X) or
				 player:HasCollectible(CollectibleType.COLLECTIBLE_SPIRIT_SWORD) or
				 player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION) or
				 player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN or 
				 player:GetPlayerType() == PlayerType.PLAYER_LILITH_B) or 
			player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE)) 
		then
			return
		end
	end
	Isaac.RunCallback(FiendFolio.CALLBACK.FF_SECONDARY_FIRE, player, dir, amount, owner, params)
end