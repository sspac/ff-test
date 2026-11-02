-- Pinhead --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local baseDuration = 120

local tearcolor = Color(0.5, 0.25, 0.10, 1.0, 30/255, 15/255, 0/255)
local lasercolor = Color(1.0, 1.0, 1.0, 1.0, 0/255, 0/255, 0/255, 3.1, 1.6, 0.7, 1)

local function getStackedPinheadDuration(player, secondHandMultiplier)
	local base = baseDuration
	local result = math.ceil(base * (math.log(math.max(1, player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.PINHEAD)), 5) + 1))
	return result * secondHandMultiplier
end

function mod:pinheadLaserColor(player)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.PINHEAD) then
		player.LaserColor = player.LaserColor * lasercolor
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_EVALUATE_CACHE, FiendFolio.ITEM.COLLECTIBLE.PINHEAD, mod.pinheadLaserColor, CacheFlag.CACHE_TEARCOLOR)

function mod:pinheadFlagGeneric(entity, player, weaponFlag)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.PINHEAD) then
		local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
		FiendFolio.FlagSew(entity, getStackedPinheadDuration(player, secondHandMultiplier), 0.5)
		
		local typ = entity.Type
		if typ == EntityType.ENTITY_TEAR then
			entity:ToTear():AddTearFlags(TearFlags.TEAR_PIERCING)
			if weaponFlag == TearFlagsLib.WeaponFlag.BOBS_ROTTEN_HEAD or weaponFlag == TearFlagsLib.WeaponFlag.SHARP_KEY then
				mod.scheduleForUpdate(function()
					entity:ToTear():AddTearFlags(TearFlags.TEAR_PIERCING)
				end, 0)
			end
		elseif typ == EntityType.ENTITY_BOMB then
			entity:ToBomb():AddTearFlags(TearFlags.TEAR_PIERCING)
		elseif typ == EntityType.ENTITY_LASER then
			entity:ToLaser():AddTearFlags(TearFlags.TEAR_PIERCING)
		elseif typ == EntityType.ENTITY_KNIFE then
			entity:ToKnife():AddTearFlags(TearFlags.TEAR_PIERCING)
		elseif typ == EntityType.ENTITY_EFFECT then
			entity:ToEffect():AddTearFlags(TearFlags.TEAR_PIERCING)
		else
			TearFlagsLib.AddCustomVanillaTearFlags(entity, TearFlags.TEAR_PIERCING)
		end
		
		if weaponFlag == TearFlagsLib.WeaponFlag.TEAR or weaponFlag == TearFlagsLib.WeaponFlag.LUDOVICO_TEAR then
			if FiendFolio.HasCetusFlag(entity) then
				entity.Color = tearcolor
			else
				mod:changeTearVariant(entity, mod.TEAR.PIN, mod.TEAR.PIN_BLOOD)
				if FiendFolio.HasBeansFlag(entity) then
					entity.Color = tearcolor
				end
			end
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
mod:AddPriorityCollectibleCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, CallbackPriority.EARLY, FiendFolio.ITEM.COLLECTIBLE.PINHEAD, mod.pinheadFlagGeneric)
mod:AddPriorityCollectibleCallback(TearFlagsLib.Callback.POLL_CHANCELESS_TEARFLAGS, CallbackPriority.EARLY, FiendFolio.ITEM.COLLECTIBLE.PINHEAD, mod.pinheadFlagGeneric)

function mod:pinheadFlagLocust(entity, player, weaponFlag)
	if player:GetCollectibleRNG(FiendFolio.ITEM.COLLECTIBLE.PINHEAD):RandomFloat() < 0.2 then
		local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
		FiendFolio.FlagSew(entity, baseDuration * secondHandMultiplier, 0.5)
	end
end
mod:AddEntityCallback(TearFlagsLib.Callback.POLL_LOCUST_TEARFLAGS, EntityType.ENTITY_FAMILIAR, FamiliarVariant.ABYSS_LOCUST, 
                      FiendFolio.ITEM.COLLECTIBLE.PINHEAD, mod.pinheadFlagLocust, FiendFolio.ITEM.COLLECTIBLE.PINHEAD)

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.PINHEAD] = {
	BodyColor = Color(1,1,1,1,-4.628/255,-27.115/255,-15.265/255,0.504,0.487,0.354,1),
	EyeAColor = Color(1,1,1,1,-38.239/255,-53.354/255,-25.097/255,0.319,0.805,0.796,1),
	EyeBColor = Color(1,1,1,1,-21.487/255,-70.637/255,-26.009/255,0.982,0.850,0.345,1)}

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	local player = familiar.Player
	local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
	FiendFolio.FlagSew(tear, baseDuration * secondHandMultiplier, 0.5)
	mod:changeTearVariant(tear, mod.TEAR.PIN, mod.TEAR.PIN_BLOOD)
	tear.TearFlags = tear.TearFlags | TearFlags.TEAR_PIERCING
end, FiendFolio.ITEM.COLLECTIBLE.PINHEAD)

function mod:pinTearRender(tear, var, data, offset)
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
mod:AddCallback("FF_CUSTOM_TEAR_RENDER", mod.pinTearRender, FiendFolio.TEAR.PIN)
mod:AddCallback("FF_CUSTOM_TEAR_RENDER", mod.pinTearRender, FiendFolio.TEAR.PIN_BLOOD)

function mod:pinTearSplat(tear, var, data)
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
mod:AddCallback("FF_CUSTOM_TEAR_SPLAT", mod.pinTearSplat, FiendFolio.TEAR.PIN)
mod:AddCallback("FF_CUSTOM_TEAR_SPLAT", mod.pinTearSplat, FiendFolio.TEAR.PIN_BLOOD)