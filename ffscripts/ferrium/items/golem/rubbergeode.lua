local mod = FiendFolio
local sfx = SFXManager()
local tearflag = TearFlagsLib.RegisterTearFlag("FF_FAKE_KNOCKBACK")

function mod:rubberGeodeFlagGeneric(entity, player, weaponFlag)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.RUBBER_GEODE) then
		local geode = 0
		if mod.HasTwoGeodes(player) then
			geode = 1
		end
	
		local mult = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.RUBBER_GEODE)
		local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.RUBBER_GEODE)
		local chance = 10+5*mult+(2*player.Luck)+15*geode
		
		if rng:RandomInt(100) < math.min(chance, 50) then
			local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
			FiendFolio.FlagBruise(entity, 100 * secondHandMultiplier, 1, 1)
			
			TearFlagsLib.AddTearFlags(entity, tearflag)
			TearFlagsLib.SetTearFlagParams(entity, tearflag, {Amount = 6+10*geode})
			--data.fakeKnockbackApply = 6+10*geode
			
			if weaponFlag == TearFlagsLib.WeaponFlag.TEAR then
				entity.TearFlags = entity.TearFlags | TearFlags.TEAR_BOUNCE
				if FiendFolio.HasCetusFlag(entity) then
					entity.Color = Color(1,1,1,1,0,0,0,0.624,0.939,0.475,1)
				else
					mod:changeTearVariant(entity, mod.TEAR.TENNIS_BALL)
					entity.Velocity = entity.Velocity * (1.25+0.5*geode)
					sfx:Play(mod.Sounds.TennisHit, 5, 0, false, math.random(90,110)/100)
				end
			elseif weaponFlag == TearFlagsLib.WeaponFlag.LUDOVICO_TEAR then
				mod:changeTearVariant(entity, mod.TEAR.TENNIS_BALL)
				entity.TearFlags = entity.TearFlags | TearFlags.TEAR_BOUNCE
			elseif weaponFlag == TearFlagsLib.WeaponFlag.BOBS_ROTTEN_HEAD or weaponFlag == TearFlagsLib.WeaponFlag.SHARP_KEY then
				-- have to schedule this cause otherwise it gets overwritten
				mod.scheduleForUpdate(function()
					entity.TearFlags = entity.TearFlags | TearFlags.TEAR_BOUNCE
				end, 0)
				entity.Velocity = entity.Velocity * (1.25+0.5*geode)
			elseif weaponFlag == TearFlagsLib.WeaponFlag.AQUARIUS then
				mod:GetEntityData(entity).FFAquariusTearColor = Color(1,1,1,1,0,0,0,0.624,0.939,0.475,1)
			elseif weaponFlag == TearFlagsLib.WeaponFlag.DR_FETUS then
				entity.Flags = entity.Flags | TearFlags.TEAR_BOUNCE
				entity.Velocity = entity.Velocity * (1.25+0.5*geode)
				entity.Color = Color(1,1,1,1,0,0,0,0.624,0.939,0.475,1)
			elseif weaponFlag == TearFlagsLib.WeaponFlag.EPIC_FETUS or weaponFlag == TearFlagsLib.WeaponFlag.CLUB_EPIC_FETUS then
				mod:GetEntityData(entity).FFExplosionColor = Color(1,1,1,1,0,0,0,0.624,0.939,0.475,1)
			elseif weaponFlag == TearFlagsLib.WeaponFlag.FF_PLANET_X then
				mod:GetEntityData(entity).ShotSpeedMult = 1.25+0.5*geode
				entity.Color = Color(1,1,1,1,0,0,0,0.624,0.939,0.475,1)
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
				--entity.Color = tearcolor
			end
		end
	end
end
mod:AddTrinketCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, FiendFolio.ITEM.ROCK.RUBBER_GEODE, mod.rubberGeodeFlagGeneric)

mod:AddPostNpcTakeDmgFromSourceCallback(function(_, npc, data, damage, damageFlags, tear, tearData)
	if tearData.fakeKnockbackApply then
		npc.Velocity = (npc.Position-tear.Position):Resized(tearData.fakeKnockbackApply)
	end
end, 2)

function mod:applyFakeKnockbackFlag(entity, player, source, weaponFlag)
	--[[if tearData.fakeKnockbackApply then
		npc.Velocity = (npc.Position-tear.Position):Resized(tearData.fakeKnockbackApply)
	end]]--
	
	--local data = mod:GetEntityData(entity)
	local sdata = mod:GetEntityData(source)
	
	local vec = entity.Position-source.Position
	if weaponFlag == TearFlagsLib.WeaponFlag.FF_PLANET_X then
		vec = source.Position - source.Player.Position
	end
	entity.Velocity = vec:Resized(TearFlagsLib.GetTearFlagParams(source, tearflag).Amount or 6)
	
	--[[data.fakeKnockbackEffect = true
	data.fakeKnockbackData = {vec, 5, 5,}]]--
end
mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, mod.applyFakeKnockbackFlag, tearflag)

function mod:tennisBallTearRender(tear, var, data, offset)
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
mod:AddCallback("FF_CUSTOM_TEAR_RENDER", mod.tennisBallTearRender, FiendFolio.TEAR.TENNIS_BALL)

function mod:tennisBallTearSplat(tear, var, data)
	sfx:Play(SoundEffect.SOUND_SPLATTER, 1, 0, false, 1.0)
	
	if tear.TearFlags & TearFlags.TEAR_EXPLOSIVE == TearFlags.TEAR_EXPLOSIVE then return end

	local scale = tear.Scale

	local poof = Isaac.Spawn(1000, EffectVariant.TEAR_POOF_A, 0, tear.Position, Vector(0,0), tear)	
	poof:GetSprite():ReplaceSpritesheet(0, "gfx/projectiles/tear_tennis_splat.png")
	poof:GetSprite():LoadGraphics()
	poof.SpriteScale = Vector(scale * 0.8, scale * 0.8)
	poof.PositionOffset = tear.PositionOffset
end
mod:AddCallback("FF_CUSTOM_TEAR_SPLAT", mod.tennisBallTearSplat, FiendFolio.TEAR.TENNIS_BALL)