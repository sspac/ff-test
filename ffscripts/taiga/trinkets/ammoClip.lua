-- Ammo Clip --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local chanceDivider = 6
local baseChanceVal = 1
local minChanceVal = 0.5
local maxChanceVal = 6
local maxChanceAtLuck = 20
local scaledChanceMult = (maxChanceVal - baseChanceVal) / maxChanceAtLuck

mod.FriendBulletFlags = mod.FriendBulletFlags or {}
mod.FriendBulletFlags.AMMO_CLIP = TearFlagsLib.RegisterTearFlag("AMMO_CLIP")

mod.AMMO_CLIP = {}
mod.AMMO_CLIP.PARTIAL_IF_FETAL_FRIEND = TearFlagsLib.BitSetInfinity.Zero

function mod:PreventRemovingAmmoClipFlag(entity, player, flag)
	if TearFlagsLib.GetTearFlagParams(entity, flag).NoRemove then
		return true
	end
end
mod:AddCallback(TearFlagsLib.Callback.PRE_REMOVE_TEARFLAG, mod.PreventRemovingAmmoClipFlag, mod.FriendBulletFlags.AMMO_CLIP)

local function isAmmoClipUseSuccessful(player)
	local playerType = player:GetPlayerType()
	if playerType == mod.PLAYER.FRIEND or
	   playerType == mod.PLAYER.BRIEND
	then
		return false
	end
	
	local chance = (baseChanceVal * player:GetTrinketMultiplier(mod.ITEM.TRINKET.AMMO_CLIP)) + player.Luck * scaledChanceMult
	chance = math.min(math.max(minChanceVal, chance), maxChanceVal)
	if math.random() * chanceDivider <= chance then
		return true
	end
end

local function getAmmoClipShot(ammo, player)
	local shot = ammo[math.random(#ammo)]

    if (shot.OverlayKeys and shot.OverlayKeys["FOOLS_GOLD_HEART"] and shot.LastInHeart) then
        if math.random() <= mod.FriendBalancing.FoolsGoldChance then
            shot.ForceImmoral = false
            shot.ForceGold = true
        else
            shot.ForceGold = false
            shot.ForceImmoral = true
        end
    end
	
	if not shot.ForceGold and (not (shot.OverlayKeys and shot.OverlayKeys["GOLDEN_HEART"] and shot.LastInHeart) or mod:RandomFloat() > mod.FriendBalancing.GoldHeartChance) then
		if shot.OverlayKeys then
			shot.OverlayKeys["GOLDEN_HEART"] = nil
		end
	end

	shot.Crit = (shot.HeartKey == "IMMORAL_HEART" or shot.ForceImmoral) and mod:RandomInt(100) < mod:GetFriendCritChance(player)
	
	return shot
end

function mod:ammoClipFlagGeneric(entity, player, weaponFlag)
	if weaponFlag == TearFlagsLib.WeaponFlag.DARK_ARTS or weaponFlag == TearFlagsLib.WeaponFlag.OCULAR_RIFT then return end
	
	if player:HasTrinket(FiendFolio.ITEM.TRINKET.AMMO_CLIP) then
		if isAmmoClipUseSuccessful(player) then
			local hasFetalFriend = player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.FETAL_FRIEND)
			local ammo
			if player:GetPlayerType() == FiendFolio.PLAYER.CHINA then
				ammo = {{Index = 1, HeartKey = "RED_HEART", LastInHeart = true, HealthPosition = {1, 1}, HeartType = "Red"}}
			elseif player:GetHealthType() == HealthType.COIN then
				ammo = {{Index = 1, HeartKey = "RED_HEART", LastInHeart = true, HealthPosition = {1, 1}, HeartType = "Red"}}
			elseif player:GetHealthType() == HealthType.NO_HEALTH then
				ammo = {{Index = 1, HeartKey = "SOUL_HEART", LastInHeart = true, HealthPosition = {1, 1}, HeartType = "Other"}}
			else
				ammo = mod:GetFriendAmmo(player)
			end
			local shot = getAmmoClipShot(ammo, player)
			local flat, mult, crit = mod:GetFriendShotDamageBonus(nil, player, shot)
			
			TearFlagsLib.AddTearFlags(entity, mod.FriendBulletFlags.AMMO_CLIP)
			TearFlagsLib.SetTearFlagParams(entity, mod.FriendBulletFlags.AMMO_CLIP, {Shot = shot})
			
			if weaponFlag == TearFlagsLib.WeaponFlag.TEAR then
				local tear = entity:ToTear()
				local td = mod:GetEntityData(tear)
				
				if not hasFetalFriend then
					tear.CollisionDamage = tear.CollisionDamage * mod.FriendBalancing.Damage
					tear.CollisionDamage = (tear.CollisionDamage + flat) * mult
					
					mod:ApplyFriendTearShotEffects(tear, player, shot, crit)
				end
				
				if not FiendFolio.HasCetusFlag(tear) then
					if not tear:HasTearFlags(TearFlags.TEAR_HYDROBOUNCE) then
						tear.FallingSpeed = -0.1
						tear.FallingAcceleration = -0.05
					else
						tear.FallingSpeed = -22
					end
					tear.Height = mod.FriendBalancing.DefaultTearHeight
					
					mod:changeTearVariant(tear, mod.TEAR.FRIEND_BULLET)
					sfx:Play(mod.Sounds.RevolverShoot, 0.5 + math.random() * 0.2, 0, false, 0.95 + math.random() * 0.05)
					tear:SetInitSound(SoundEffect.SOUND_NULL)
					if not mod.PreventBulletMuzzleAndSpeedUpFromRandom then
						tear.Velocity = tear.Velocity * (1 + mod.FriendBalancing.Shotspeed)
						
						local flash = Isaac.Spawn(mod.FF.MuzzleFlash.ID, mod.FF.MuzzleFlash.Var, mod.FF.MuzzleFlash.Sub, player.Position, Vector.Zero, player):ToEffect()
						local flashSprite = flash:GetSprite()
						flashSprite.PlaybackSpeed = math.random(50, 150)/100
						flash.SpriteScale = Vector(1, 1) * tear.Scale
						flashSprite.Color = mod:ColorHSV(0.0, 0.0, 1.0, 1, 0.1, 1.0, 0.9)
						
						local angle = tear.Velocity:GetAngleDegrees()
						if angle < 0 then
							flash.SpriteOffset = Vector(6.5,0):Rotated(angle) * (1 - math.abs(math.sin(math.rad(angle))) * 0.8) + Vector(0,-16.25)
						else
							flash.SpriteOffset = Vector(6.5 * (1 - math.abs(math.sin(math.rad(angle)))) * ((angle > 90 and -1) or 1),0) + Vector(0,-16.25)
						end
						if -179 < angle and angle < -1 then
							flash.DepthOffset = -75
						else
							flash.DepthOffset = 75
						end
						if angle > 90 or angle < -90 then
							angle = (-angle + 180) % 360
							flash.FlipX = true
							flash.SpriteOffset = flash.SpriteOffset * Vector(-1,1)
						end
						flash.SpriteRotation = angle
						flash:FollowParent(player)
					end
				end
			elseif weaponFlag == TearFlagsLib.WeaponFlag.LUDOVICO_TEAR then
				if not hasFetalFriend then
					entity.CollisionDamage = entity.CollisionDamage * mod.FriendBalancing.Damage
					entity.CollisionDamage = (entity.CollisionDamage + flat) * mult
					
					mod:ApplyFriendTearShotEffects(entity:ToTear(), player, shot, crit)
				end
			elseif weaponFlag == TearFlagsLib.WeaponFlag.BOBS_ROTTEN_HEAD then
				local tear = entity:ToTear()
				local td = mod:GetEntityData(tear)
				
				if not hasFetalFriend then
					mod.scheduleForUpdate(function()
						tear.CollisionDamage = tear.CollisionDamage - 185
						tear.CollisionDamage = tear.CollisionDamage * mod.FriendBalancing.Damage
						tear.CollisionDamage = (tear.CollisionDamage + flat) * mult
						tear.CollisionDamage = tear.CollisionDamage + 185
					end, 1)
					
					local color = tear.Color
					mod:ApplyFriendTearShotEffects(tear, player, shot, crit)
					tear.Color = color
				end
				
				if not tear:HasTearFlags(TearFlags.TEAR_HYDROBOUNCE) then
					tear.FallingSpeed = -0.1
					tear.FallingAcceleration = -0.05
				else
					tear.FallingSpeed = -22
				end
				tear.Height = mod.FriendBalancing.DefaultTearHeight

				tear.Velocity = tear.Velocity * (1 + mod.FriendBalancing.Shotspeed)
			elseif weaponFlag == TearFlagsLib.WeaponFlag.SHARP_KEY then
				local tear = entity:ToTear()
				local td = mod:GetEntityData(tear)
				
				if not hasFetalFriend then
					mod.scheduleForUpdate(function()
						tear.CollisionDamage = tear.CollisionDamage - 30
						tear.CollisionDamage = tear.CollisionDamage * mod.FriendBalancing.Damage
						tear.CollisionDamage = (tear.CollisionDamage + flat) * mult
						tear.CollisionDamage = tear.CollisionDamage + 30
					end, 1)
					
					local color = tear.Color
					mod:ApplyFriendTearShotEffects(tear, player, shot, crit)
					tear.Color = color
				end
				
				if not tear:HasTearFlags(TearFlags.TEAR_HYDROBOUNCE) then
					tear.FallingSpeed = -0.1
					tear.FallingAcceleration = -0.05
				else
					tear.FallingSpeed = -22
				end
				tear.Height = mod.FriendBalancing.DefaultTearHeight

				tear.Velocity = tear.Velocity * (1 + mod.FriendBalancing.Shotspeed)
			elseif weaponFlag == TearFlagsLib.WeaponFlag.LASER then
				if not hasFetalFriend then
					local color = entity.Color
					mod:ApplyFriendLaserShotEffects(entity:ToLaser(), player, shot, crit, false, true)
					entity.Color = color
				end
			elseif weaponFlag == TearFlagsLib.WeaponFlag.KNIFE then
				if not hasFetalFriend then
					mod:ApplyFriendGenericShotEffects(entity, player, shot, shot.Crit)
				end
			elseif weaponFlag == TearFlagsLib.WeaponFlag.CLUB then
				if not hasFetalFriend then
					mod:ApplyFriendGenericShotEffects(entity, player, shot, shot.Crit)
				end
			elseif weaponFlag == TearFlagsLib.WeaponFlag.AQUARIUS then
				mod:ApplyFriendGenericShotEffects(entity, player, shot, shot.Crit)
				if REPENTOGON.MeetsVersion("1.1.2") and (TearFlagsLib.HasTearFlags(entity, mod.FriendBulletFlags.ETERNAL) or TearFlagsLib.HasTearFlags(entity, mod.FriendBulletFlags.STEVEN)) then
					entity:ToEffect():AddTearFlags(TearFlags.TEAR_HOMING)
				end
			elseif weaponFlag == TearFlagsLib.WeaponFlag.DR_FETUS then
				local bomb = entity:ToBomb()
				local bd = mod:GetEntityData(entity)
				
				if not hasFetalFriend then
					bomb.ExplosionDamage = bomb.ExplosionDamage * mod.FriendBalancing.Damage
				end
				if not mod.PreventBulletMuzzleAndSpeedUpFromRandom then
					bomb:SetExplosionCountdown(bomb:GetExplosionCountdown() + mod:RandomInt(-5,5))
					bomb.SpriteOffset = Vector(0, -10)
					local flatStone = bomb:HasTearFlags(TearFlags.TEAR_HYDROBOUNCE)
					if flatStone then
						bomb:ClearTearFlags(TearFlags.TEAR_HYDROBOUNCE)
						bomb:SetExplosionCountdown(bomb:GetExplosionCountdown() * 2)
					end
					TearFlagsLib.AddTearFlags(bomb, mod.FriendBulletFlags.GRENADE)
					TearFlagsLib.SetTearFlagParams(bomb, mod.FriendBulletFlags.GRENADE, {
						FlatStone = flatStone,
						Height = -10,
						FallingSpeed = flatStone and -6 or mod:RandomFloat(-4, -2),
						FallingAcceleration = flatStone and 0.75 or 0.2,
						InitialSpeed = bomb.Velocity:Length(),
					})
				end

				if not hasFetalFriend then
					local flat, mult, crit = mod:GetFriendShotDamageBonus(nil, player, shot)
					bomb.ExplosionDamage = (bomb.ExplosionDamage + flat) * mult

					mod:ApplyFriendBombShotEffects(bomb, player, shot, crit)
				end

				if not mod.PreventBulletMuzzleAndSpeedUpFromRandom then
					local isCrit = TearFlagsLib.HasTearFlags(bomb, mod.CritFlag)
					if isCrit then
						mod:FriendPlaySound(CollectibleType.COLLECTIBLE_DR_FETUS, "BombCrit", 1)
					else
						mod:FriendPlaySound(CollectibleType.COLLECTIBLE_DR_FETUS, "Bomb", 1)
					end
				
					bomb.Velocity = bomb.Velocity * (1 + mod.FriendBalancing.Shotspeed)
				end
			elseif weaponFlag == TearFlagsLib.WeaponFlag.EPIC_FETUS then
				if not hasFetalFriend then
					mod:ApplyFriendGenericShotEffects(entity, player, shot, shot.Crit)
					mod:GetEntityData(entity).FFExplosionColor = mod:GetFriendShotTearColor(entity)
				end
			elseif weaponFlag == TearFlagsLib.WeaponFlag.UMBILICAL_WHIP then
				if not hasFetalFriend then
					mod:ApplyFriendGenericShotEffects(entity, player, shot, shot.Crit)
				end
			elseif weaponFlag == TearFlagsLib.WeaponFlag.BRIMSTONE_BALL then
				if not hasFetalFriend then
					mod:ApplyFriendGenericShotEffects(entity, player, shot, shot.Crit)
					if REPENTOGON.MeetsVersion("1.1.2") and (TearFlagsLib.HasTearFlags(entity, mod.FriendBulletFlags.ETERNAL) or TearFlagsLib.HasTearFlags(entity, mod.FriendBulletFlags.STEVEN)) then
						entity:ToEffect():AddTearFlags(TearFlags.TEAR_HOMING)
					end
				end
			elseif weaponFlag == TearFlagsLib.WeaponFlag.ANTI_GRAV_LASER then
				if not hasFetalFriend then
					mod:ApplyFriendGenericShotEffects(entity, player, shot, shot.Crit)
				end
			elseif weaponFlag == TearFlagsLib.WeaponFlag.SWORD then
				if not hasFetalFriend then
					entity.CollisionDamage = entity.CollisionDamage * mod.FriendBalancing.Damage
					entity.CollisionDamage = (entity.CollisionDamage + flat) * mult
					mod:ApplyFriendGenericShotEffects(entity, player, shot, shot.Crit)
				end
			elseif weaponFlag == TearFlagsLib.WeaponFlag.CLUB_EPIC_FETUS then
				if not hasFetalFriend then
					mod:ApplyFriendGenericShotEffects(entity, player, shot, shot.Crit)
					mod:GetEntityData(entity).FFExplosionColor = mod:GetFriendShotTearColor(entity)
				end
			elseif weaponFlag == TearFlagsLib.WeaponFlag.HEMOPTYSIS then
				mod:ApplyFriendGenericShotEffects(entity, player, shot, shot.Crit)
			else
				if not (mod.AMMO_CLIP.PARTIAL_IF_FETAL_FRIEND:HasAnyFlag(weaponFlag) and hasFetalFriend) then
					if not hasFetalFriend then 
						entity.CollisionDamage = entity.CollisionDamage * mod.FriendBalancing.Damage
					end
					entity.CollisionDamage = (entity.CollisionDamage + flat) * mult

					mod:ApplyFriendGenericShotEffects(entity, player, shot, shot.Crit)
				end
				if weaponFlag == TearFlagsLib.WeaponFlag.FF_PLANET_X then
					mod:GetEntityData(entity).ShotSpeedMult = 1 + mod.FriendBalancing.Shotspeed
				end
			end
		end
	end
end
mod:AddPriorityTrinketCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, -300, FiendFolio.ITEM.TRINKET.AMMO_CLIP, mod.ammoClipFlagGeneric)

function mod:handleAquariusAmmoClipDamage(creep)
	local shot = TearFlagsLib.GetTearFlagParams(creep, mod.FriendBulletFlags.AMMO_CLIP).Shot
	if shot then
		local player = TearFlagsLib.GetTearPlayer(creep)
		if player then
			local flat, mult, crit = mod:GetFriendShotDamageBonus(nil, player, shot)
			creep.CollisionDamage = creep.CollisionDamage * 3/2
			creep.CollisionDamage = creep.CollisionDamage * mod.FriendBalancing.Damage
			creep.CollisionDamage = (creep.CollisionDamage + flat) * mult
			creep.CollisionDamage = creep.CollisionDamage * 2/3
		end
	end
end

mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, -300, function(_, entity, amount, flags, source, cooldown, extraSource)
	if flags & DamageFlag.DAMAGE_CLONES ~= 0 or not entity:ToNPC() then return end
	
	local source = extraSource or source
	local hitter = nil
	if source.Type == 0 and flags & DamageFlag.DAMAGE_LASER > 0 then
		local potential = mod.CheckingForDmg[#mod.CheckingForDmg]
		if potential and TearFlagsLib.IsEntityOcularRift(potential) then
			hitter = potential
		end
	elseif source.Entity and TearFlagsLib.IsEntityOcularRift(source.Entity) then
		hitter = source.Entity
	elseif source.Type == EntityType.ENTITY_EFFECT and source.Variant == EffectVariant.DARK_SNARE and source.Entity and source.Entity.SpawnerEntity then
		hitter = source.Entity
	else
		return
	end
	if hitter == nil then return end
	
	-- this is technically not accurate for ocular rift since it rolls every hit instead of every frame but idc
	-- this functions nicer for can of beans purposes
	-- i'll leave tearflagslib generally as it is but for weird stuff like this imma do this instead
	local player = TearFlagsLib.GetTearPlayer(hitter)
	if not player then return end
	
	local data = mod:GetEntityData(hitter)
	local frame = game:GetFrameCount()
	if data.RolledForAmmoClip ~= frame then
		mod:ResetFriendShotEffects(hitter, data.AppliedCrit == frame)
		TearFlagsLib.SetTearFlagParams(hitter, mod.FriendBulletFlags.AMMO_CLIP, {NoRemove = false})
		TearFlagsLib.ClearTearFlags(hitter, mod.FriendBulletFlags.AMMO_CLIP)
		if player:HasTrinket(FiendFolio.ITEM.TRINKET.AMMO_CLIP) and isAmmoClipUseSuccessful(player) then
			local ammo
			if player:GetPlayerType() == FiendFolio.PLAYER.CHINA then
				ammo = {{Index = 1, HeartKey = "RED_HEART", LastInHeart = true, HealthPosition = {1, 1}, HeartType = "Red"}}
			elseif player:GetHealthType() == HealthType.COIN then
				ammo = {{Index = 1, HeartKey = "RED_HEART", LastInHeart = true, HealthPosition = {1, 1}, HeartType = "Red"}}
			elseif player:GetHealthType() == HealthType.NO_HEALTH then
				ammo = {{Index = 1, HeartKey = "SOUL_HEART", LastInHeart = true, HealthPosition = {1, 1}, HeartType = "Other"}}
			else
				ammo = mod:GetFriendAmmo(player)
			end
			local shot = getAmmoClipShot(ammo, player)
			TearFlagsLib.AddTearFlags(hitter, mod.FriendBulletFlags.AMMO_CLIP)
			TearFlagsLib.SetTearFlagParams(hitter, mod.FriendBulletFlags.AMMO_CLIP, {Shot = shot, NoRemove = true})
			mod:ApplyFriendGenericShotEffects(hitter, player, shot, shot.Crit, true)
			if shot.Crit then
				data.AppliedCrit = frame
			end
		end
		data.RolledForAmmoClip = frame
	end
	if TearFlagsLib.HasTearFlags(hitter, mod.FriendBulletFlags.AMMO_CLIP) then
		local shot = TearFlagsLib.GetTearFlagParams(hitter, mod.FriendBulletFlags.AMMO_CLIP).Shot
		if shot then
			local flat, mult, crit = mod:GetFriendShotDamageBonus(nil, player, shot)
			if hitter.Type == EntityType.ENTITY_EFFECT and hitter.Variant == EffectVariant.DARK_SNARE then
				local bonusDamage = 3.5 * hitter.SubType
				return {Damage = ((amount - bonusDamage) * mod.FriendBalancing.Damage + flat) * mult + bonusDamage}
			else
				return {Damage = (amount * mod.FriendBalancing.Damage + flat) * mult}
			end
		end
	end
end)