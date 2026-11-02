local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

function mod:updateTimeItselfLaserColor(player)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.TIME_ITSELF) then
		player.LaserColor = Color(-2,-2,-2,1,1,1,1,1,1,1,1)
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_EVALUATE_CACHE, FiendFolio.ITEM.COLLECTIBLE.TIME_ITSELF, mod.updateTimeItselfLaserColor, CacheFlag.CACHE_TEARCOLOR)

function mod:timeItselfLocustAI(locust)
	local s = math.sin(game:GetFrameCount()/20*math.pi)
	local multiEuclidColor = Color(-s*2, -s*2, -s*2, 1, (s+1)/2, (s+1)/2, (s+1)/2)
	multiEuclidColor:SetColorize(1, 1, 1, 1)
	locust.Color = multiEuclidColor
end

function mod:timeItselfFlagGeneric(entity, player, weaponFlag)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.TIME_ITSELF) then
		if math.random() * 8 <= 2 + player.Luck * 0.4 then
			local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
			FiendFolio.FlagMultiEuclidean(entity, 180 * secondHandMultiplier)
			
			if weaponFlag == TearFlagsLib.WeaponFlag.TEAR or weaponFlag == TearFlagsLib.WeaponFlag.LUDOVICO_TEAR then
				if FiendFolio.HasCetusFlag(entity) then
					entity.Color = Color(-2,-2,-2,1,1,1,1,1,1,1,1)
				else
					mod:changeTearVariant(entity, mod.TEAR.MULTI_EUCLIDEAN)
					if FiendFolio.HasBeansFlag(entity) then
						TearFlagsLib.SetTearFlagParams(entity, TearFlagsLib.Flag.BEANS, {UseMultieuclideanFart = true})
					end
				end
			elseif weaponFlag == TearFlagsLib.WeaponFlag.AQUARIUS then
				mod:GetEntityData(entity).FFAquariusTearColor = Color(-2,-2,-2,1,1,1,1,1,1,1,1)
			elseif weaponFlag == TearFlagsLib.WeaponFlag.EPIC_FETUS or weaponFlag == TearFlagsLib.WeaponFlag.CLUB_EPIC_FETUS then
				mod:GetEntityData(entity).FFExplosionColor = Color(-2,-2,-2,1,1,1,1,1,1,1,1)
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
				entity.Color = Color(-2,-2,-2,1,1,1,1,1,1,1,1)
			end
		end
	end
end
mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, FiendFolio.ITEM.COLLECTIBLE.TIME_ITSELF, mod.timeItselfFlagGeneric)

function mod:timeItselfFlagLocust(entity, player, weaponFlag)
	if player:GetCollectibleRNG(FiendFolio.ITEM.COLLECTIBLE.TIME_ITSELF):RandomFloat() < 0.2 then
		local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
		FiendFolio.FlagMultiEuclidean(entity, 180 * secondHandMultiplier)
	end
end
mod:AddEntityCallback(TearFlagsLib.Callback.POLL_LOCUST_TEARFLAGS, EntityType.ENTITY_FAMILIAR, FamiliarVariant.ABYSS_LOCUST, 
                      FiendFolio.ITEM.COLLECTIBLE.TIME_ITSELF, mod.timeItselfFlagLocust, FiendFolio.ITEM.COLLECTIBLE.TIME_ITSELF)

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.TIME_ITSELF] = {
	BodyColor = Color(1,1,1,1,-14.265/255,-14.265/255,-14.265/255,0.347,0.347,0.347,1)}

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, familiar)
	if familiar.SubType == FiendFolio.ITEM.COLLECTIBLE.TIME_ITSELF then
		local sprite = familiar:GetSprite()
		
        local s = math.sin(game:GetFrameCount()/20*math.pi)
		local multiEuclidColor = Color(-s*2, -s*2, -s*2, 1, (s+1)/2, (s+1)/2, (s+1)/2)
        multiEuclidColor:SetColorize(1, 1, 1, 1)
		
		local eyeALayer = sprite:GetLayer("eyeA")
		if eyeALayer then
			eyeALayer:SetColor(multiEuclidColor)
		end
		
		local eyeBLayer = sprite:GetLayer("eyeB")
		if eyeBLayer then
			eyeBLayer:SetColor(multiEuclidColor)
		end
	end
end, FiendFolio.ITEM.FAMILIAR.SEWING_MANUAL_DOLL)

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	if math.random() * 8 <= 2 then
		local player = familiar.Player
		local secondHandMultiplier = ((player and player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND)) or 0) + 1
		FiendFolio.FlagMultiEuclidean(tear, 180 * secondHandMultiplier)
			
		mod:changeTearVariant(tear, mod.TEAR.MULTI_EUCLIDEAN)
		if FiendFolio.HasBeansFlag(tear) then
			TearFlagsLib.SetTearFlagParams(tear, TearFlagsLib.Flag.BEANS, {UseMultieuclideanFart = true})
		end
	end
end, FiendFolio.ITEM.COLLECTIBLE.TIME_ITSELF)

function mod:multiEuclideanTearRender(tear, var, data, offset)
	local data = mod:GetEntityData(tear)
	
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
mod:AddCallback("FF_CUSTOM_TEAR_RENDER", mod.multiEuclideanTearRender, FiendFolio.TEAR.MULTI_EUCLIDEAN)

function mod:multiEuclideanTearSplat(tear, var, data)
	sfx:Play(SoundEffect.SOUND_SPLATTER, 1, 0, false, 1.0)
	
	if tear.TearFlags & TearFlags.TEAR_EXPLOSIVE == TearFlags.TEAR_EXPLOSIVE then return end

	local scale = tear.Scale

	local poof = Isaac.Spawn(1000, mod:getNormalTearPoofVariant(tear.Scale, tear.Height), 0, tear.Position, nilvector, tear)	
	--poof:GetSprite():ReplaceSpritesheet(0, "gfx/projectiles/multieuclidean_tears_tearpoof.png")
	--poof:GetSprite():LoadGraphics()
	local s = math.sin(tear.FrameCount/24*math.pi)
    local multiEuclidColor = Color(-s*2, -s*2, -s*2, 1, (s+1)/2, (s+1)/2, (s+1)/2)
    multiEuclidColor:SetColorize(1, 1, 1, 1)
	poof:GetSprite().Color = multiEuclidColor
	if scale > 0.8 then
		poof.SpriteScale = Vector(scale * 0.8, scale * 0.8)
	end
	poof.PositionOffset = tear.PositionOffset
end
mod:AddCallback("FF_CUSTOM_TEAR_SPLAT", mod.multiEuclideanTearSplat, FiendFolio.TEAR.MULTI_EUCLIDEAN)