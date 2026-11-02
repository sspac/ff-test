-- Rubber Bullets --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

mod.RubberBulletsBal = {}
mod.RubberBulletsBal.BaseDuration = 90
mod.RubberBulletsBal.ChanceDivider = 25
mod.RubberBulletsBal.BaseChanceVal = 5
mod.RubberBulletsBal.MinChanceVal = 1
mod.RubberBulletsBal.MaxChanceVal = 12.5
mod.RubberBulletsBal.MaxChanceAtLuck = 10
mod.RubberBulletsBal.ScaledChanceMult = (mod.RubberBulletsBal.MaxChanceVal - mod.RubberBulletsBal.BaseChanceVal) / mod.RubberBulletsBal.MaxChanceAtLuck

local tearcolor = Color(0.5, 0.3, 0.5, 1.0, 40/255, 0/255, 40/255)
local lasercolor = Color(1.0, 1.0, 1.0, 1.0, 0/255, 0/255, 0/255, 1.8, 0.2, 2.9, 1)

function mod:rubberBulletsLaserColor(player)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.RUBBER_BULLETS) then
		player.LaserColor = player.LaserColor * lasercolor
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_EVALUATE_CACHE, FiendFolio.ITEM.COLLECTIBLE.RUBBER_BULLETS, mod.rubberBulletsLaserColor, CacheFlag.CACHE_TEARCOLOR)

local function isRubberBulletsUseSuccessful(player)
	local chance = (mod.RubberBulletsBal.BaseChanceVal * player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.RUBBER_BULLETS)) + player.Luck * mod.RubberBulletsBal.ScaledChanceMult
	chance = math.min(math.max(mod.RubberBulletsBal.MinChanceVal, chance), mod.RubberBulletsBal.MaxChanceVal)
	if math.random() * mod.RubberBulletsBal.ChanceDivider <= chance then
		return true
	end
end

local function getStackedRubberBulletsDuration(player, secondHandMultiplier)
	local base = mod.RubberBulletsBal.BaseDuration
	local result = math.ceil(base * (math.log(math.max(1, player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.RUBBER_BULLETS)), 5) + 1))
	return result * secondHandMultiplier
end

function mod:rubberBulletsFlagGeneric(entity, player, weaponFlag)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.RUBBER_BULLETS) then
		if isRubberBulletsUseSuccessful(player) then
			local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
			FiendFolio.FlagBruise(entity, getStackedRubberBulletsDuration(player, secondHandMultiplier), 1, 1)
			
			if weaponFlag == TearFlagsLib.WeaponFlag.TEAR then
				if FiendFolio.HasBeansFlag(entity) then 
					TearFlagsLib.SetTearFlagParams(entity, TearFlagsLib.Flag.BEANS, {IsBlackEyedPea = true})
				else
					entity.Color = tearcolor
				end
				if not FiendFolio.HasCetusFlag(entity) then
					TearFlagsLib.AddTearFlags(entity, mod.FriendBulletFlags.NO_FALL_TEAR)
					sfx:Play(mod.Sounds.ShotgunBlast,0.4,0,false,math.random(60,80)/100)
					entity:ToTear():SetInitSound(SoundEffect.SOUND_NULL)
					
					if not TearFlagsLib.HasTearFlags(entity, mod.FriendBulletFlags.AMMO_CLIP) then
						mod:changeTearVariant(entity, mod.TEAR.M90_BULLET)
						if not mod.PreventBulletMuzzleAndSpeedUpFromRandom then
							entity.Velocity = entity.Velocity * (1 + mod.FriendBalancing.Shotspeed)
							
							local flash = Isaac.Spawn(mod.FF.MuzzleFlash.ID, mod.FF.MuzzleFlash.Var, mod.FF.MuzzleFlash.Sub, player.Position, Vector.Zero, player):ToEffect()
							local flashSprite = flash:GetSprite()
							flashSprite.PlaybackSpeed = math.random(50, 150)/100
							flash.SpriteScale = Vector(1, 1) * entity:ToTear().Scale
							flashSprite.Color = mod:ColorHSV(0.0, 0.0, 1.0, 1, 0.1, 1.0, 0.9)
							
							local angle = entity.Velocity:GetAngleDegrees()
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
				end
			elseif weaponFlag == TearFlagsLib.WeaponFlag.LUDOVICO_TEAR then
				if FiendFolio.HasBeansFlag(entity) then 
					TearFlagsLib.SetTearFlagParams(entity, TearFlagsLib.Flag.BEANS, {IsBlackEyedPea = true})
				else
					entity.Color = tearcolor
				end
				mod:changeTearVariant(entity, mod.TEAR.M90_BULLET)
			elseif weaponFlag == TearFlagsLib.WeaponFlag.BOBS_ROTTEN_HEAD or weaponFlag == TearFlagsLib.WeaponFlag.SHARP_KEY then
				TearFlagsLib.AddTearFlags(entity, mod.FriendBulletFlags.NO_FALL_TEAR)
				if FiendFolio.HasBeansFlag(entity) then 
					TearFlagsLib.SetTearFlagParams(entity, TearFlagsLib.Flag.BEANS, {IsBlackEyedPea = true})
				end
				if not TearFlagsLib.HasTearFlags(entity, mod.FriendBulletFlags.AMMO_CLIP) then
					entity.Velocity = entity.Velocity * (1 + mod.FriendBalancing.Shotspeed)
				end
			elseif weaponFlag == TearFlagsLib.WeaponFlag.AQUARIUS then
				mod:GetEntityData(entity).FFAquariusTearColor = tearcolor
			elseif weaponFlag == TearFlagsLib.WeaponFlag.DR_FETUS then
				entity.Color = tearcolor
				if not TearFlagsLib.HasTearFlags(entity, mod.FriendBulletFlags.AMMO_CLIP) and not mod.PreventBulletMuzzleAndSpeedUpFromRandom then
					entity.Velocity = entity.Velocity * (1 + mod.FriendBalancing.Shotspeed)
				end
			elseif weaponFlag == TearFlagsLib.WeaponFlag.EPIC_FETUS or weaponFlag == TearFlagsLib.WeaponFlag.CLUB_EPIC_FETUS then
				mod:GetEntityData(entity).FFExplosionColor = tearcolor
			elseif weaponFlag == TearFlagsLib.WeaponFlag.FF_PLANET_X then
				entity.Color = tearcolor
				if not TearFlagsLib.HasTearFlags(entity, mod.FriendBulletFlags.AMMO_CLIP) then
					mod:GetEntityData(entity).ShotSpeedMult = 1 + mod.FriendBalancing.Shotspeed
				end
			elseif weaponFlag == TearFlagsLib.WeaponFlag.LASER or
			       weaponFlag == TearFlagsLib.WeaponFlag.KNIFE or
			       weaponFlag == TearFlagsLib.WeaponFlag.ANTI_GRAV_LASER or
			       weaponFlag == TearFlagsLib.WeaponFlag.DARK_ARTS or
			       weaponFlag == TearFlagsLib.WeaponFlag.LOCUST or
			       weaponFlag == TearFlagsLib.WeaponFlag.UMBILICAL_WHIP or
			       weaponFlag == TearFlagsLib.WeaponFlag.BRIMSTONE_BALL or
			       weaponFlag == TearFlagsLib.WeaponFlag.OCULAR_RIFT or
			       weaponFlag == TearFlagsLib.WeaponFlag.HEMOPTYSIS
			then
				return
			else
				entity.Color = tearcolor
			end
		end
	end
end
mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, FiendFolio.ITEM.COLLECTIBLE.RUBBER_BULLETS, mod.rubberBulletsFlagGeneric)

function mod:rubberBulletsFlagLocust(entity, player, weaponFlag)
	if player:GetCollectibleRNG(FiendFolio.ITEM.COLLECTIBLE.RUBBER_BULLETS):RandomFloat() < 0.2 then
		local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
		FiendFolio.FlagBruise(entity, mod.RubberBulletsBal.BaseDuration * secondHandMultiplier, 1, 1)
	end
end
mod:AddEntityCallback(TearFlagsLib.Callback.POLL_LOCUST_TEARFLAGS, EntityType.ENTITY_FAMILIAR, FamiliarVariant.ABYSS_LOCUST, 
                      FiendFolio.ITEM.COLLECTIBLE.RUBBER_BULLETS, mod.rubberBulletsFlagLocust, FiendFolio.ITEM.COLLECTIBLE.RUBBER_BULLETS)

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.RUBBER_BULLETS] = {
	BodyColor = Color(1,1,1,1,36.929/255,-24.575/255,-17.159/255,0.761,0.434,0.212,1),
	EyeAColor = Color(1,1,1,1,-67.814/255,-12.982/255,17.832/255,0.752,0.310,0.558,1),
	EyeBColor = Color(1,1,1,1,-67.814/255,-12.982/255,17.832/255,0.752,0.310,0.558,1)}

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	if math.random() * 25 <= 5 then
		local player = familiar.Player
		local secondHandMultiplier = ((player and player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND)) or 0) + 1
		FiendFolio.FlagBruise(tear, mod.RubberBulletsBal.BaseDuration * secondHandMultiplier, 1, 1)
		
		tear.Color = tearcolor
		
		TearFlagsLib.AddTearFlags(tear, mod.FriendBulletFlags.NO_FALL_TEAR)
		sfx:Play(mod.Sounds.ShotgunBlast,0.4,0,false,math.random(60,80)/100)
		tear:SetInitSound(SoundEffect.SOUND_NULL)
					
		mod:changeTearVariant(tear, mod.TEAR.M90_BULLET)
		tear.Velocity = tear.Velocity * (1 + mod.FriendBalancing.Shotspeed)
		
		if familiar.Player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
			local tearcolor = Color(0.4, 0.15, 0.38, 1, 55/255, 5/255, 95/255)
			tear.Color = tearcolor
		end
		if mod:isSuperpositionedPlayer(familiar.Player) then
			local tearcolor = Color.Lerp(tear.Color, Color(1,1,1,1,0,0,0), 0)
			tearcolor.A = tearcolor.A / 4
			tear.Color = tearcolor
		end
	end
end, FiendFolio.ITEM.COLLECTIBLE.RUBBER_BULLETS)