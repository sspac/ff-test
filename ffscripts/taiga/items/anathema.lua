-- Anathema --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

mod.AnathemaBal = {}
mod.AnathemaBal.BaseDuration = 90
mod.AnathemaBal.NonRandomWeapons = TearFlagsLib.WeaponFlag.TEAR |
                                   TearFlagsLib.WeaponFlag.CLUB |
                                   TearFlagsLib.WeaponFlag.DR_FETUS |
                                   TearFlagsLib.WeaponFlag.EPIC_FETUS |
                                   TearFlagsLib.WeaponFlag.UMBILICAL_WHIP |
                                   TearFlagsLib.WeaponFlag.SWORD
mod.AnathemaBal.EveryXShots = 7
mod.AnathemaBal.ChanceDivider = 21
mod.AnathemaBal.BaseChanceVal = 3
mod.AnathemaBal.MinChanceVal = 1
mod.AnathemaBal.MaxChanceVal = 7
mod.AnathemaBal.MaxChanceAtLuck = 10
mod.AnathemaBal.ScaledChanceMult = (mod.AnathemaBal.MaxChanceVal - mod.AnathemaBal.BaseChanceVal) / mod.AnathemaBal.MaxChanceAtLuck

local tearcolor = Color(1.3, 1.3, 1.3, 1.0, 0/255, 30/255, 45/255, 1.0, 1.0, 1.0, 1)
local lasercolor = Color(6.8, 6.8, 6.8, 1.0, -50/255, -50/255, -50/255, 0.9, 1.0, 1.2, 1)

local function isAnathemaUseSuccessful(player, entity, weaponFlag)
	if mod.AnathemaBal.NonRandomWeapons:HasAnyFlag(weaponFlag) then
		local source = (entity.Type == EntityType.ENTITY_FAMILIAR and entity) or mod.FireTearSource or mod.IsSprinklerTear or mod.IsHatredTear or entity.SpawnerEntity
		if source then
			local sdata = mod:GetEntityData(source)
			local frame = game:GetFrameCount()
			if sdata.LastFramePolledForAnathema == frame then
				return (sdata.TimesPolledForAnathema or 0) % mod.AnathemaBal.EveryXShots == 0
			end
			sdata.LastFramePolledForAnathema = frame
			sdata.TimesPolledForAnathema = (sdata.TimesPolledForAnathema or 0) + 1
			return sdata.TimesPolledForAnathema % mod.AnathemaBal.EveryXShots == 0
		end
	end
	
	if math.random() * mod.AnathemaBal.ChanceDivider <= mod.AnathemaBal.BaseChanceVal then
		return true
	end
end

local function getStackedAnathemaDuration(player, secondHandMultiplier)
	local base = mod.AnathemaBal.BaseDuration 
	local result = math.ceil(base * (math.log(math.max(1, player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.ANATHEMA)), 5) + 1))
	return result * secondHandMultiplier
end

function mod:anathemaLaserColor(player, flag)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.ANATHEMA) then
		player.LaserColor = player.LaserColor * lasercolor
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_EVALUATE_CACHE, FiendFolio.ITEM.COLLECTIBLE.ANATHEMA, mod.anathemaLaserColor, CacheFlag.CACHE_TEARCOLOR)

function mod:anathemaFlagGeneric(entity, player, weaponFlag)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.ANATHEMA) then
		if isAnathemaUseSuccessful(player, entity, weaponFlag) then
			local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
			FiendFolio.FlagExcommunicate(entity, getStackedAnathemaDuration(player, secondHandMultiplier), player.Damage)
			
			if weaponFlag == TearFlagsLib.WeaponFlag.TEAR or weaponFlag == TearFlagsLib.WeaponFlag.LUDOVICO_TEAR then
				if FiendFolio.HasBeansFlag(entity) then
					TearFlagsLib.SetTearFlagParams(entity, TearFlagsLib.Flag.BEANS, {IsHolyBean = true})
				elseif FiendFolio.HasCetusFlag(entity) then
					entity.Color = tearcolor
				end
				mod:changeTearVariant(entity, mod.TEAR.ANATHEMA)
			elseif weaponFlag == TearFlagsLib.WeaponFlag.BOBS_ROTTEN_HEAD or weaponFlag == TearFlagsLib.WeaponFlag.SHARP_KEY then
				if FiendFolio.HasBeansFlag(entity) then
					TearFlagsLib.SetTearFlagParams(entity, TearFlagsLib.Flag.BEANS, {IsHolyBean = true})
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
mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, FiendFolio.ITEM.COLLECTIBLE.ANATHEMA, mod.anathemaFlagGeneric)

function mod:anathemaFlagLocust(entity, player, weaponFlag)
	if player:GetCollectibleRNG(FiendFolio.ITEM.COLLECTIBLE.ANATHEMA):RandomFloat() < 0.2 then
		local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
		FiendFolio.FlagExcommunicate(entity, mod.AnathemaBal.BaseDuration * secondHandMultiplier, player.Damage)
		
		if FiendFolio.HasBeansFlag(entity) then
			TearFlagsLib.SetTearFlagParams(entity, TearFlagsLib.Flag.BEANS, {IsHolyBean = true})
		end
	end
end
mod:AddEntityCallback(TearFlagsLib.Callback.POLL_LOCUST_TEARFLAGS, EntityType.ENTITY_FAMILIAR, FamiliarVariant.ABYSS_LOCUST, 
                      FiendFolio.ITEM.COLLECTIBLE.ANATHEMA, mod.anathemaFlagLocust, FiendFolio.ITEM.COLLECTIBLE.ANATHEMA)

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.ANATHEMA] = {
	BodyColor = Color(1,1,1,1,45.442/255,45.442/255,45.442/255,0.743,0.743,0.743,1),
	EyeAColor = Color(1,1,1,1,146.359/255,3.828/255,285.-219/255,0.359,0.828,1.781,1),
	EyeBColor = Color(1,1,1,1,-40.109/255,-87.047/255,-77.172/255,0.891,0.953,0.828,1)}

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	if math.random() * 21 <= 3 then
		local player = familiar.Player
		local secondHandMultiplier = ((player and player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND)) or 0) + 1
		FiendFolio.FlagExcommunicate(tear, mod.AnathemaBal.BaseDuration * secondHandMultiplier, player.Damage)
		
		if FiendFolio.HasBeansFlag(tear) then
			TearFlagsLib.SetTearFlagParams(tear, TearFlagsLib.Flag.BEANS, {IsHolyBean = true})
		end
		mod:changeTearVariant(tear, mod.TEAR.ANATHEMA)
	end
end, FiendFolio.ITEM.COLLECTIBLE.ANATHEMA)

function mod:anathemaTearRender(tear, var, data, offset)
	local sprite = tear:GetSprite()
	local scale = tear.Scale
	local flags = tear.TearFlags
	
	local prefix = "Regular"
	
	local anim
	if scale <= 0.3 then
		anim = prefix .. "Tear1"
	elseif scale <= 0.55 then
		anim = prefix .. "Tear2"
	elseif scale <= 0.675 then
		anim = prefix .. "Tear3"
	elseif scale <= 0.8 then
		anim = prefix .. "Tear4"
	elseif scale <= 0.925 then
		anim = prefix .. "Tear5"
	elseif scale <= 1.05 then
		anim = prefix .. "Tear6"
	elseif scale <= 1.175 then
		anim = prefix .. "Tear7"
	elseif scale <= 1.425 then
		anim = prefix .. "Tear8"
	elseif scale <= 1.675 then
		anim = prefix .. "Tear9"
	elseif scale <= 1.925 then
		anim = prefix .. "Tear10"
	elseif scale <= 2.175 then
		anim = prefix .. "Tear11"
	elseif scale <= 2.55 then
		anim = prefix .. "Tear12"
	else
		anim = prefix .. "Tear13"
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
mod:AddCallback("FF_CUSTOM_TEAR_RENDER", mod.anathemaTearRender, FiendFolio.TEAR.ANATHEMA)

function mod:anathemaTearSplat(tear, var, data)
	if not data.denySound then
        sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 0.1, 0, false, 2.5 - math.max(math.min(tear.Scale, 1.5), 0))
    end
	if tear.TearFlags & TearFlags.TEAR_EXPLOSIVE == TearFlags.TEAR_EXPLOSIVE then return end
	
	local scale = tear.Scale
	local color = tear:GetSprite().Color

	local smoke = Isaac.Spawn(1000, mod.FF.FFWhiteSmoke.Var, mod.FF.FFWhiteSmoke.Sub, tear.Position, tear.Velocity:Resized(3), tear)
	--smoke.SpriteScale = Vector(1,1)
	mod:GetEntityData(smoke).longonly = true
	smoke.SpriteScale = Vector(scale * 0.8, scale * 0.8)
	smoke.PositionOffset = tear.PositionOffset
    smoke:Update()
end
mod:AddCallback("FF_CUSTOM_TEAR_SPLAT", mod.anathemaTearSplat, FiendFolio.TEAR.ANATHEMA)