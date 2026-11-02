-- Lawn Darts --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local baseDuration = 90

local chanceDivider = 8
local baseChanceVal = 2
local minChanceVal = 0.5
local maxChanceVal = 8
local maxChanceAtLuck = 15
local scaledChanceMult = (maxChanceVal - baseChanceVal) / maxChanceAtLuck

local tearcolor = Color(1.0, 1.0, 1.0, 1.0, 80/255, 0/255, -25/255, 0.7, 0.4, 0.5, 1)
local lasercolor = Color(1.0, 1.0, 1.0, 1.0, 0/255, 0/255, 0/255, 4.8, 1.6, 1.4, 1)

local function isLawnDartsUseSuccessful(player)
	local chance = (baseChanceVal * player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.LAWN_DARTS)) + player.Luck * scaledChanceMult
	chance = math.min(math.max(minChanceVal, chance), maxChanceVal)
	if math.random() * chanceDivider <= chance then
		return true
	end
end

local function getStackedLawnDartsDuration(player, secondHandMultiplier)
	local base = baseDuration
	local result = math.ceil(base * (math.log(math.max(1, player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.LAWN_DARTS)), 5) + 1))
	return result * secondHandMultiplier
end

function mod:lawnDartsLaserColor(player, flag)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.LAWN_DARTS) then
		player.LaserColor = player.LaserColor * lasercolor
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_EVALUATE_CACHE, FiendFolio.ITEM.COLLECTIBLE.LAWN_DARTS, mod.lawnDartsLaserColor, CacheFlag.CACHE_TEARCOLOR)

function mod:lawnDartsFlagGeneric(entity, player, weaponFlag)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.LAWN_DARTS) then
		if isLawnDartsUseSuccessful(player) then
			local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
			FiendFolio.FlagHemorrhage(entity, getStackedLawnDartsDuration(player, secondHandMultiplier), player.Damage * 0.5)
			
			if weaponFlag == TearFlagsLib.WeaponFlag.TEAR then
				if FiendFolio.HasCetusFlag(entity) then
					entity.Color = tearcolor
				else
					mod:changeTearVariant(entity, mod.TEAR.LAWN_DART)
					sfx:Play(SoundEffect.SOUND_SHELLGAME, 0.5, 0, false, 1 / entity.Scale)
					entity:ToTear():SetInitSound(SoundEffect.SOUND_NULL)
					if FiendFolio.HasBeansFlag(entity) then
						entity.Color = tearcolor
					end
				end
			elseif weaponFlag == TearFlagsLib.WeaponFlag.LUDOVICO_TEAR then
				mod:changeTearVariant(entity, mod.TEAR.LAWN_DART)
			elseif weaponFlag == TearFlagsLib.WeaponFlag.AQUARIUS then
				mod:GetEntityData(entity).FFAquariusTearColor = tearcolor
			elseif weaponFlag == TearFlagsLib.WeaponFlag.EPIC_FETUS or weaponFlag == TearFlagsLib.WeaponFlag.CLUB_EPIC_FETUS then
				mod:GetEntityData(entity).FFExplosionColor = tearcolor
			elseif weaponFlag == TearFlagsLib.WeaponFlag.LASER or 
			       weaponFlag == TearFlagsLib.WeaponFlag.ANTI_GRAV_LASER or 
			       weaponFlag == TearFlagsLib.WeaponFlag.KNIFE or
			       weaponFlag == TearFlagsLib.WeaponFlag.DARK_ARTS or
			       weaponFlag == TearFlagsLib.WeaponFlag.LOCUST or
			       weaponFlag == TearFlagsLib.WeaponFlag.UMBILICAL_WHIP or
			       weaponFlag == TearFlagsLib.WeaponFlag.BRIMSTONE_BALL or
			       weaponFlag == TearFlagsLib.WeaponFlag.BOBS_ROTTEN_HEAD or
			       weaponFlag == TearFlagsLib.WeaponFlag.SHARP_KEY or
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
mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, FiendFolio.ITEM.COLLECTIBLE.LAWN_DARTS, mod.lawnDartsFlagGeneric)

function mod:lawnDartsFlagLocust(entity, player, weaponFlag)
	if player:GetCollectibleRNG(FiendFolio.ITEM.COLLECTIBLE.LAWN_DARTS):RandomFloat() < 0.2 then
		local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
		FiendFolio.FlagHemorrhage(entity, baseDuration * secondHandMultiplier, player.Damage * 0.5)
	end
end
mod:AddEntityCallback(TearFlagsLib.Callback.POLL_LOCUST_TEARFLAGS, EntityType.ENTITY_FAMILIAR, FamiliarVariant.ABYSS_LOCUST, 
                      FiendFolio.ITEM.COLLECTIBLE.LAWN_DARTS, mod.lawnDartsFlagLocust, FiendFolio.ITEM.COLLECTIBLE.LAWN_DARTS)

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.LAWN_DARTS] = {
	BodyColor = Color(1,1,1,1,-89.133/255,-89.133/255,-89.133/255,1.177,1.177,1.177,1),
	EyeAColor = Color(1,1,1,1,-33.637/255,-58.478/255,-58.478/255,0.850,0.637,0.637,1),
	EyeBColor = Color(1,1,1,1,-17.434/255,-61.027/255,-80.274/255,0.912,1.035,0.699,1)}

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	if math.random() * 8 <= 2 then
		local player = familiar.Player
		local secondHandMultiplier = ((player and player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND)) or 0) + 1
		FiendFolio.FlagHemorrhage(tear, baseDuration * secondHandMultiplier, player.Damage * 0.5)
			
		mod:changeTearVariant(tear, mod.TEAR.LAWN_DART)
		sfx:Play(SoundEffect.SOUND_SHELLGAME, 0.5, 0, false, 1 / tear.Scale)
		if FiendFolio.HasBeansFlag(tear) then
			tear.Color = tearcolor
		end
	end
end, FiendFolio.ITEM.COLLECTIBLE.LAWN_DARTS)

function mod:lawnDartTearRender(tear, tvar, data, offset)
	local sprite = tear:GetSprite()
	local scale = tear.Scale
	local flags = tear.TearFlags
	
	local anim
	if scale <= 0.3 then
		anim = "RegularTear1"
	elseif scale <= 0.55 then
		anim = "RegularTear2"
	elseif scale <= 0.675 then
		anim = "RegularTear3"
	elseif scale <= 0.8 then
		anim = "RegularTear4"
	elseif scale <= 0.925 then
		anim = "RegularTear5"
	elseif scale <= 1.05 then
		anim = "RegularTear6"
	elseif scale <= 1.175 then
		anim = "RegularTear7"
	elseif scale <= 1.425 then
		anim = "RegularTear8"
	elseif scale <= 1.675 then
		anim = "RegularTear9"
	elseif scale <= 1.925 then
		anim = "RegularTear10"
	elseif scale <= 2.175 then
		anim = "RegularTear11"
	elseif scale <= 2.55 then
		anim = "RegularTear12"
	else
		anim = "RegularTear13"
	end
	
	if not sprite:IsPlaying(anim) then
		local frame = sprite:GetFrame()
		sprite:Play(anim, true)
		sprite:SetFrame(frame)
	end

	local spritescale = mod:getTearScale13(tear)
	local layers = sprite:GetAllLayers()
	for _, layer in ipairs(layers) do
		layer:SetSize(spritescale)
	end
	
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
end
mod:AddCallback("FF_CUSTOM_TEAR_RENDER", mod.lawnDartTearRender, FiendFolio.TEAR.LAWN_DART)

function mod:lawnDartTearSplat(tear, var, data)
	sfx:Play(SoundEffect.SOUND_POT_BREAK, 0.5, 0, false, 3)
	
	if tear.TearFlags & TearFlags.TEAR_EXPLOSIVE == TearFlags.TEAR_EXPLOSIVE then return end

	local scale = tear.Scale
	local color = tear:GetSprite().Color
	
	local poof = Isaac.Spawn(1000, EffectVariant.IMPACT, 0, tear.Position, nilvector, tear)
	poof:GetSprite().Color = color
	poof.SpriteScale = Vector(scale * 0.8, scale * 0.8)
	poof.PositionOffset = tear.PositionOffset
	
	for i = 1, 5 do
		local gib = Isaac.Spawn(1000, EffectVariant.NAIL_PARTICLE, 0, tear.Position, RandomVector()*2, tear):ToEffect()
		gib.m_Height = math.min(-5, tear.Height)
		gib:GetSprite().Color = color
		gib.State = 2
	end
end
mod:AddCallback("FF_CUSTOM_TEAR_SPLAT", mod.lawnDartTearSplat, FiendFolio.TEAR.LAWN_DART)