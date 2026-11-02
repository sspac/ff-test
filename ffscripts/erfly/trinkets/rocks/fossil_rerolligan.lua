local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local flag = TearFlagsLib.RegisterTearFlag("REROLLIGAN")
local tearcolor = Color(1.0, 1.0, 1.0, 1.0, 50/255, 30/255, 10/255, 0.7, 0.45, 0.35, 1)
local lasercolor = Color(1.0, 1.0, 1.0, 1.0, 0/255, 0/255, 0/255, 3.5, 2.3, 1.5, 1)

function mod:updateRerolliganFossilLaserColor(player)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.REROLLIGAN_FOSSIL) then
		player.LaserColor = player.LaserColor * lasercolor
	end
end
mod:AddTrinketCallback(ModCallbacks.MC_EVALUATE_CACHE, FiendFolio.ITEM.ROCK.REROLLIGAN_FOSSIL, mod.updateRerolliganFossilLaserColor, CacheFlag.CACHE_TEARCOLOR)

function mod:rerolliganFossilFlagGeneric(entity, player, weaponFlag)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.REROLLIGAN_FOSSIL) then
        local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.REROLLIGAN_FOSSIL)
        local chance = math.min(5 + player.Luck * 2, 20) * trinketPower

        if player:GetTrinketRNG(FiendFolio.ITEM.ROCK.REROLLIGAN_FOSSIL):RandomInt(50) < chance then
			TearFlagsLib.AddTearFlags(entity, flag)

			if weaponFlag == TearFlagsLib.WeaponFlag.TEAR or weaponFlag == TearFlagsLib.WeaponFlag.LUDOVICO_TEAR then
				if FiendFolio.HasCetusFlag(entity) then
					entity.Color = tearcolor
				else
					mod:changeTearVariant(entity, mod.TEAR.D10)
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
end
mod:AddTrinketCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, FiendFolio.ITEM.ROCK.REROLLIGAN_FOSSIL, mod.rerolliganFossilFlagGeneric)

local checkingForRerolledEnts = false
local rerolledEnts = {}
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, npc)
	if checkingForRerolledEnts then
		table.insert(rerolledEnts, npc)
	end
end)

local flushingDamageCache = false
mod:AddPriorityCallback(ModCallbacks.MC_PRE_NPC_UPDATE, -1 * math.huge, function(_, npc)
	if flushingDamageCache then return true end
end)

function mod:applyRerolliganFossilFlag(entity, player, source)
	if entity.Type ~= EntityType.ENTITY_FROZEN_ENEMY and
	   entity:IsVulnerableEnemy() and
	   entity:ToNPC():CanReroll()
	then
		local edata = mod:GetEntityData(entity)
		if edata.lastRerolliganFrame == nil or game:GetFrameCount() - edata.lastRerolliganFrame >= 60 then
			mod.scheduleForUpdate(function()
				if entity:Exists() and not entity:HasMortalDamage() then
					flushingDamageCache = true
					entity:Update()
					flushingDamageCache = false

					checkingForRerolledEnts = true
					game:RerollEnemy(entity)
					sfx:Play(SoundEffect.SOUND_EDEN_GLITCH, 1, 0, false, 1)
					checkingForRerolledEnts = false

					for _, rerolledEnt in pairs(rerolledEnts) do
						mod:GetEntityData(rerolledEnt).lastRerolliganFrame = game:GetFrameCount()
						TearFlagsLib.GetSafeData(source).entityBlacklist[rerolledEnt.InitSeed] = true
						mod:applyFakeDamageFlash(rerolledEnt)
					end
					rerolledEnts = {}
				end
			end, 0, ModCallbacks.MC_POST_UPDATE)

			if source.Type == EntityType.ENTITY_TEAR and not source:ToTear():HasTearFlags(BitSet128(0, 1 << (127 - 64))) then -- Ludo
				mod.scheduleForUpdate(function()
					mod:GetEntityData(source).denySound = true
					source:Die()
				end, 0, ModCallbacks.MC_POST_TEAR_COLLISION)
			end
		end
	end
end
mod:AddPriorityCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, math.huge, mod.applyRerolliganFossilFlag, flag)

FiendFolio.FossilBreakEffects[FiendFolio.ITEM.ROCK.REROLLIGAN_FOSSIL] = function(player, spawner)
    Isaac.Spawn(5, 300, mod.ITEM.CARD.GLASS_D10, spawner.Position, RandomVector() * 5, spawner)
    for i = 1, 2 do
        local r = spawner:GetDropRNG()
        local rand = mod:GetRandomGlassDice(r)
        Isaac.Spawn(5, 300, rand, spawner.Position, RandomVector() * 5, spawner)
    end
end

function mod:d10TearRender(tear, var, data, offset)
	local sprite = tear:GetSprite()
	local scale = tear.Scale
	local flags = tear.TearFlags

	local anim
	if scale <= 0.675 then
		anim = "Stone1Move"
	elseif scale <= 0.925 then
		anim = "Stone2Move"
	elseif scale <= 1.175 then
		anim = "Stone3Move"
	elseif scale <= 1.675 then
		anim = "Stone4Move"
	elseif scale <= 2.175 then
		anim = "Stone5Move"
	else
		anim = "Stone6Move"
	end

	if not sprite:IsPlaying(anim) then
		local frame = sprite:GetFrame()
		sprite:Play(anim, true)
		sprite:SetFrame(frame)
	end

	local spritescale = mod:getTearScale6(tear)
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
mod:AddCallback("FF_CUSTOM_TEAR_RENDER", mod.d10TearRender, FiendFolio.TEAR.D10)

function mod:d10TearSplat(tear, var, data)
    if not data.denySound then
        sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 0.3, 0, false, 2.5 - math.max(math.min(tear.Scale, 1.5), 0))
    end

	if tear.TearFlags & TearFlags.TEAR_EXPLOSIVE == TearFlags.TEAR_EXPLOSIVE then return end

	local scale = tear.Scale
	local color = tear:GetSprite().Color

---@diagnostic disable-next-line: param-type-mismatch
    local smoke = Isaac.Spawn(1000, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, tear.Position, tear.Velocity * 0.1, tear):ToEffect()
    smoke.Color = Color(1,1,1,1,0.7,0.4,0.3)
	smoke.SpriteScale = Vector(scale * 0.8, scale * 0.8)
	smoke.PositionOffset = tear.PositionOffset
    smoke:Update()

	for i = 1, 5 do
		local gib = Isaac.Spawn(1000, EffectVariant.TOOTH_PARTICLE, 920, tear.Position, RandomVector()*2, tear):ToEffect()
		gib.m_Height = math.min(-5, tear.Height)
		gib:GetSprite().Color = color
		gib.State = 2
	end
end
mod:AddCallback("FF_CUSTOM_TEAR_SPLAT", mod.d10TearSplat, FiendFolio.TEAR.D10)