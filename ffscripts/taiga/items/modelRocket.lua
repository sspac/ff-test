-- Model Rocket oh god oh fuck not again nightmare nightmare nightmare --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local ACCEL_MAX_MULTIPLIER = 2 -- The maximum multiplier that can applied to velocity and falling acceleration
local ACCEL_MAX_TICK = 15 -- The accelerate tick at which the accelerate multiplier reaches maximum
local ACCEL_ROOT = 2 -- The root of the multiplier; can be thought of as the tick difference between a multiplier with the value of 1 and the maximum multiplier
local ACCEL_TEAR_DAMAGE_BONUS_BASE = 1.25 -- The base damage of accelerate bonus damage
local ACCEL_PLANET_DAMAGE_BONUS_BASE = 3 -- The base damage of accelerate bonus damage

local flag = TearFlagsLib.RegisterTearFlag("MODEL_ROCKET")
mod.PocketRockitDisallowedCustomFlags = (mod.PocketRockitDisallowedCustomFlags or TearFlagsLib.BitSetInfinity.Zero) | flag

mod.ModelRocketResetOnSplit = {
	[SplitTearType.QUAD] = true,
	[SplitTearType.ABSORB] = true,
	[SplitTearType.SPORE] = true,
	[SplitTearType.STICKY] = true,
	[SplitTearType.BURST] = true,
	[SplitTearType.POP] = true,
	[SplitTearType.SWORD_BEAM] = true,
	["FF_WNIC"] = true,
	["FF_YAAI"] = true,
	["FF_PARANOIA"] = true,
}

local function determineMultiplier(currentTick)
  -- Returns the FLAG_ACCEL multiplier for the given FLAG_ACCEL logic tick

  return ACCEL_MAX_MULTIPLIER ^ ((currentTick - (ACCEL_MAX_TICK - ACCEL_ROOT)) / ACCEL_ROOT)
end

function mod.getCurrentModelRocketMultiplier(ent)
	if TearFlagsLib.HasTearFlags(ent, flag) then
		return 1
	else
		return math.min(determineMultiplier(params.Frame), ACCEL_MAX_MULTIPLIER) / ACCEL_MAX_MULTIPLIER
	end
end

local function reverseFallingSpeed(speed, accel)
  -- Reverses the falling speed based upon a given falling acceleration

  return (speed - 0.1 - accel) / 0.9
end

local function forwardFallingSpeed(speed, accel)
  -- Forwards the falling speed based upon a given falling acceleration

  return 0.1 + accel + 0.9 * speed
end

local divlog = math.log(0.9)
local function getAddedHeightAtPeak(initialFallingSpeed, fallingAccel)
	local peakAtTick = math.floor(math.log(1 - 1 / ((((fallingAccel + 0.1) * 10) / initialFallingSpeed / -1) + 1)) / divlog)
	local exptick = (9/10) ^ peakAtTick - 1
	return -9 * initialFallingSpeed * exptick + (9 * exptick + peakAtTick) * ((0.1 + fallingAccel) * 10)
end

function mod:updateModelRocketTear(ent)
	local tear = ent:ToTear()
	if tear and TearFlagsLib.HasTearFlags(tear, flag) then
		local params = TearFlagsLib.GetTearFlagParams(tear, flag)
		params.Init = true
		
		if tear.StickTarget == nil then
			params.DisableDamageOnStick = false
		end
		
		if params.DisableMovementOnStick or
		   tear.WaitFrames > 0 or
		   tear.StickTarget or 
		   tear:HasTearFlags(TearFlags.TEAR_LUDOVICO) or
		   (TearFlagsLib.HasTearFlags(ent, TearFlagsLib.Flag.WORMHOLE) and TearFlagsLib.GetTearFlagParams(ent, TearFlagsLib.Flag.WORMHOLE).enteredPortalAt)
		then
			TearFlagsLib.SetTearFlagParams(tear, flag, params)
			return
		end
	
		if params.LastUpdate ~= game:GetFrameCount() then
			if params.Frame == nil or params.Frame == false then
				if tear.FallingAcceleration > -0.1 and reverseFallingSpeed(tear.FallingSpeed, tear.FallingAcceleration) < 0 then
					params.FramesToPeak = ACCEL_MAX_TICK
					params.PeakAddedHeight = getAddedHeightAtPeak(reverseFallingSpeed(tear.FallingSpeed, tear.FallingAcceleration), 
					                                              tear.FallingAcceleration)
					params.FallingMultiplier = (tear.SpawnerEntity and mod:GetEntityData(tear.SpawnerEntity).ModelRocketArcingTearsFallingSpeedModifier) or 1
				else
					params.FramesToPeak = 0
					params.FallingMultiplier = 1
				end
				
				params.Frame = 0
			else
				params.Frame = params.Frame + 1
			end
			local multiplier = math.min(determineMultiplier(params.Frame), ACCEL_MAX_MULTIPLIER) / ACCEL_MAX_MULTIPLIER
			
			tear.Position = tear.Position - tear.Velocity
			if params.Frame <= ACCEL_MAX_TICK and params.Pop then
				tear.Velocity = tear.Velocity - (tear.Velocity * 0.04 * multiplier)
			end
			tear.Velocity = tear.Velocity * multiplier
			tear.Position = tear.Position + tear.Velocity
			
			params.ShouldRevert = game:GetFrameCount()
			
			if params.Frame >= ACCEL_MAX_TICK then
				if params.Pop then
					tear.TearFlags = tear.TearFlags | TearFlags.TEAR_POP
					params.Pop = false
					
					tear.FallingAcceleration = params.InitFallAccel
				end
			elseif tear.TearFlags & TearFlags.TEAR_POP == TearFlags.TEAR_POP then
				tear.TearFlags = tear.TearFlags ~ TearFlags.TEAR_POP
				params.Pop = true
				
				params.InitFallAccel = tear.FallingAcceleration
				tear.FallingSpeed = 0
				tear.FallingAcceleration = -0.1
			end
			
			if params.Frame >= ACCEL_MAX_TICK - 1 then
				if params.TurnHorizontal then
					tear.TearFlags = tear.TearFlags | TearFlags.TEAR_TURN_HORIZONTAL
					params.TurnHorizontal = false
				end
			end
			
			if not params.Pop and
			   tear.TearFlags & TearFlags.TEAR_POP ~= TearFlags.TEAR_POP and
			   tear.TearFlags & TearFlags.TEAR_ABSORB ~= TearFlags.TEAR_ABSORB and 
			   not mod:tearHasCustomNoFallEffects(tear) and
			   not TearFlagsLib.HasTearFlags(tear, mod.FriendBulletFlags.BLACK)
			then
				if params.FramesToPeak and params.FramesToPeak > 0 then
					tear.Height = tear.Height - tear.FallingSpeed
					tear.FallingSpeed = params.PeakAddedHeight / 120 * params.FramesToPeak
					tear.Height = tear.Height + tear.FallingSpeed
					
					params.FramesToPeak = params.FramesToPeak - 1
				elseif tear.Height < -5 then
					params.IntendedFallingSpeed = tear.FallingSpeed
					tear.Height = tear.Height - tear.FallingSpeed
					params.FallingMultiplier = params.FallingMultiplier or 1
					tear.FallingSpeed = tear.FallingSpeed * multiplier * params.FallingMultiplier
					if tear.Height + tear.FallingSpeed > 0 then
						tear.FallingSpeed = -1 * tear.Height
						tear.Height = 0
						params.IntendedFallingSpeed = false
					else
						tear.Height = tear.Height + tear.FallingSpeed
					end
				end
			end
			
			--params.LastUpdate = game:GetFrameCount()
		end

		TearFlagsLib.SetTearFlagParams(tear, flag, params)
	end
end

function mod:revertModelRocketTear(ent)
	local tear = ent:ToTear()
	if tear and TearFlagsLib.HasTearFlags(tear, flag) then
		local params = TearFlagsLib.GetTearFlagParams(tear, flag)
		if params.ForceToVel then
			tear.Velocity = params.ForceToVel
			params.ForceToVel = false
		end
		if params.Init and params.ShouldRevert ~= game:GetFrameCount() then
			params.ShouldRevert = false
			
			if params.DisableMovementOnStick or
			   tear.WaitFrames > 0 or
			   tear.StickTarget or 
			   tear:HasTearFlags(TearFlags.TEAR_LUDOVICO)
			then
				TearFlagsLib.SetTearFlagParams(tear, flag, params)
				return
			end
			
			if params.LastReversion ~= game:GetFrameCount() then
				params.Frame = params.Frame or 0
				local multiplier = math.min(determineMultiplier(params.Frame), ACCEL_MAX_MULTIPLIER) / ACCEL_MAX_MULTIPLIER
				
				tear.Velocity = tear.Velocity / multiplier
				
				if params.IntendedFallingSpeed then
					tear.FallingSpeed = params.IntendedFallingSpeed
					local oldFallSpeed = reverseFallingSpeed(tear.FallingSpeed, tear.FallingAcceleration)
					params.FallingMultiplier = params.FallingMultiplier or 1
					tear.FallingSpeed = (tear.FallingSpeed - oldFallSpeed) * multiplier * params.FallingMultiplier + oldFallSpeed
					params.IntendedFallingSpeed = false
				end
				
				--params.LastReversion = game:GetFrameCount()
			end
		end
		TearFlagsLib.SetTearFlagParams(tear, flag, params)
	end
end

function mod:updateModelRocketStats(player, flag)
	if flag == CacheFlag.CACHE_SHOTSPEED then
		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.MODEL_ROCKET) then
            player.ShotSpeed = player.ShotSpeed * ACCEL_MAX_MULTIPLIER
        end
	end
	
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.MODEL_ROCKET) and (flag == CacheFlag.CACHE_SHOTSPEED or flag == CacheFlag.CACHE_RANGE) then
		mod:GetEntityData(player).FFUpdatedRange = true
	end
end

local risingElapsedSteps = ACCEL_MAX_MULTIPLIER ^ (-1 * ACCEL_MAX_TICK / ACCEL_ROOT) * (ACCEL_MAX_MULTIPLIER ^ (ACCEL_MAX_TICK / ACCEL_ROOT) - 1) / (ACCEL_MAX_MULTIPLIER ^ (1 / ACCEL_ROOT) - 1)
function mod:modelRocketRecalculateTearFallingSpeedModifier(player)
	mod:GetEntityData(player).FFUpdatedRange = nil
	mod:GetEntityData(player).ModelRocketArcingTearsFallingSpeedModifier = nil
	
	local fallingSpeed = -1 * player.TearFallingSpeed
	local fallingAccel = player.TearFallingAcceleration
	
	if fallingAccel > -0.1 and fallingSpeed < 0 then
		local desiredsteps = 0
		local desiredheight = player.TearHeight
		local desiredfallingspeed = fallingSpeed
		while (desiredheight < -5 and desiredsteps < 1000) do
			desiredfallingspeed = forwardFallingSpeed(desiredfallingspeed, fallingAccel)
			desiredheight = desiredheight + desiredfallingspeed
			desiredsteps = desiredsteps + 1
		end
		if desiredsteps >= 1000 or desiredsteps == 0 then
			return
		end
		
		local actualsteps = 0
		local actualheight = player.TearHeight + getAddedHeightAtPeak(fallingSpeed, fallingAccel)
		local actualfallingspeed = 0
		while (actualheight < -5 and actualsteps < 1000) do
			actualfallingspeed = forwardFallingSpeed(actualfallingspeed, fallingAccel)
			actualheight = actualheight + actualfallingspeed
			actualsteps = actualsteps + 1
		end
		if actualsteps >= 1000 or actualsteps == 0 then
			return
		end
		
		mod:GetEntityData(player).ModelRocketArcingTearsFallingSpeedModifier = actualsteps / (desiredsteps - risingElapsedSteps)
		--print(desiredsteps, actualsteps, mod:GetEntityData(player).ModelRocketArcingTearsFallingSpeedModifier)
	end
end

function mod:modelRocketOnTearInit(tear)
	if tear.SpawnerEntity and tear.SpawnerEntity.Type == EntityType.ENTITY_PLAYER and mod:GetEntityData(tear.SpawnerEntity).FFUpdatedRange then
		mod:modelRocketRecalculateTearFallingSpeedModifier(tear.SpawnerEntity:ToPlayer())
	end
end

function mod:modelRocketPostPlayerUpdate(player)
	if mod:GetEntityData(player).FFUpdatedRange then
		mod:modelRocketRecalculateTearFallingSpeedModifier(player)
	end
end

mod:AddPriorityCallback(ModCallbacks.MC_POST_TEAR_UPDATE, CallbackPriority.LATE, FiendFolio.updateModelRocketTear, -1)
mod:AddPriorityCallback(ModCallbacks.MC_PRE_TEAR_UPDATE, CallbackPriority.IMPORTANT, FiendFolio.revertModelRocketTear, -1)
mod:AddPriorityCallback(ModCallbacks.MC_POST_TEAR_INIT, CallbackPriority.LATE, FiendFolio.modelRocketOnTearInit, -1)
mod:AddPriorityCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, CallbackPriority.LATE, FiendFolio.modelRocketPostPlayerUpdate, -1)
mod:AddPriorityCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, CallbackPriority.LATE, FiendFolio.modelRocketPostPlayerUpdate, -1)

function mod:modelRocketSetVariant(entity, player, weaponFlag)
	if entity.Type == EntityType.ENTITY_TEAR and player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.MODEL_ROCKET) then
		local tear = entity:ToTear()
		mod:changeTearVariant(tear, mod.TEAR.MODEL_ROCKET)
	end
end
mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, FiendFolio.ITEM.COLLECTIBLE.MODEL_ROCKET, mod.modelRocketSetVariant)
mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_CHANCELESS_TEARFLAGS, FiendFolio.ITEM.COLLECTIBLE.MODEL_ROCKET, mod.modelRocketSetVariant)

function mod:modelRocketFlagGeneric(entity, player, weaponFlag)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.MODEL_ROCKET) then
		TearFlagsLib.AddTearFlags(entity, flag)
		
		if entity.Type == EntityType.ENTITY_TEAR then
			local tear = entity:ToTear()
			mod:changeTearVariant(tear, mod.TEAR.MODEL_ROCKET)
			tear.Mass = tear.Mass / 4

			-- look i really need this thing to just not move before it starts updating regularly
			-- and i really need velocity and fallingspeed to stay intact especially because of people changing it after firetear
			-- so this is the best i can come up with
			-- i hope this isnt too awful
			-- this shit resets itself on update anyways so anyone actually messing with it for real should be doing it in post_update anyhow
			tear:SetSpeedMultiplier(0)
			
			if not tear:HasTearFlags(TearFlags.TEAR_LUDOVICO) then
				if tear:HasTearFlags(TearFlags.TEAR_POP) then
					tear:ClearTearFlags(TearFlags.TEAR_POP)
					TearFlagsLib.SetTearFlagParams(tear, flag, {
						Pop = true,
						InitFallAccel = tear.FallingAcceleration,
					})
					tear.FallingSpeed = 0
					tear.FallingAcceleration = -0.1
				end
				
				if tear:HasTearFlags(TearFlags.TEAR_TURN_HORIZONTAL) then
					tear:ClearTearFlags(TearFlags.TEAR_TURN_HORIZONTAL)
					TearFlagsLib.SetTearFlagParams(tear, flag, {TurnHorizontal = true})
				end
			end
		end
	end
end
mod:AddPriorityCollectibleCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, math.huge, FiendFolio.ITEM.COLLECTIBLE.MODEL_ROCKET, mod.modelRocketFlagGeneric)
mod:AddPriorityCollectibleCallback(TearFlagsLib.Callback.POLL_CHANCELESS_TEARFLAGS, math.huge, FiendFolio.ITEM.COLLECTIBLE.MODEL_ROCKET, mod.modelRocketFlagGeneric)

function mod:modelRocketRevertFireTearVel(tear)
	if TearFlagsLib.WasEntityFiredByPlayerMimic(tear) then
		local player = TearFlagsLib.GetTearPlayer(tear)
		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.MODEL_ROCKET) then
			-- wanna completely undo the first step of movement that happens on fire tear
			tear.Position = tear.Position - tear.Velocity
			tear.Height = tear.Height - tear.FallingSpeed
			tear.FallingSpeed = reverseFallingSpeed(tear.FallingSpeed, tear.FallingAcceleration)
		end
	end
end
mod:AddPriorityCollectibleCallback(ModCallbacks.MC_POST_FIRE_TEAR, -1 * math.huge, FiendFolio.ITEM.COLLECTIBLE.MODEL_ROCKET, mod.modelRocketRevertFireTearVel)

function mod:modelRocketFixWeaponFiredTears(tear)
	if TearFlagsLib.HasTearFlags(tear, flag) then
		-- if this is a basegame fired tear, need to stop it from being moved around by weapon firedelay handling
		-- if somebody else is tracking this tear and changing it from post update or smth, imma be honest, theres nothing i can do to be compatible with you
		-- this is the best i can come up with
		-- i really need rgon to add PRE_WEAPON_FIRE_TEAR or smth
		if mod.IsModdedFireTear <= 0 then
			TearFlagsLib.SetTearFlagParams(tear, flag, {ForceToVel = tear.Velocity})
			tear.Velocity = nilvector
		end
	end
end
mod:AddPriorityCollectibleCallback(ModCallbacks.MC_POST_FIRE_TEAR, math.huge, FiendFolio.ITEM.COLLECTIBLE.MODEL_ROCKET, mod.modelRocketFixWeaponFiredTears)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	mod.IsModdedFireTear = 0
end)

mod:AddCallback(ModCallbacks.MC_POST_FIRE_SPLIT_TEAR, function(_, new, old, splittype)
	if mod.ModelRocketResetOnSplit[splittype] and TearFlagsLib.HasTearFlags(new, flag) then
		mod:revertModelRocketTear(new)
		TearFlagsLib.SetTearFlagParams(new, flag, {Frame = false})
		mod:updateModelRocketTear(new)
	else
		mod:revertModelRocketTear(new)
		TearFlagsLib.SetTearFlagParams(new, flag, {LastUpdate = false})
		mod:updateModelRocketTear(new)
	end
end)

function mod:updateModelRocketRange(player, basemulti)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.MODEL_ROCKET) then
        player.TearRange = player.TearRange + 60 * basemulti
    end
end

function mod:modelRocketOnTearDamage(entity, amount, flags, source, cooldown)
	if flags & DamageFlag.DAMAGE_CLONES ~= 0 or not entity:ToNPC() then return end
	
	if source.Entity and TearFlagsLib.HasTearFlags(source.Entity, flag) then
		if source.Type == EntityType.ENTITY_TEAR then
			local tear = source.Entity:ToTear()
			local params = TearFlagsLib.GetTearFlagParams(tear, flag)
		
			if params.Init and not params.DisableDamageOnStick then
				if tear.StickTarget ~= nil then
					TearFlagsLib.SetTearFlagParams(tear, flag, {
						DisableMovementOnStick = true,
						DisableDamageOnStick = true,
					})
				end
				return {Damage = amount + tear.Velocity:Length() / 10 * ACCEL_TEAR_DAMAGE_BONUS_BASE}
			end
		elseif source.Type == EntityType.ENTITY_FAMILIAR and source.Variant == mod.ITEM.FAMILIAR.PLANET_X then
			return {Damage = amount + source.Entity.Velocity:Length() / 10 * ACCEL_PLANET_DAMAGE_BONUS_BASE}
		end
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, -250, mod.modelRocketOnTearDamage)

local function ludoTearHasDirection(tear)
	local player = nil
	if not tear.Parent then
		return false
	elseif tear.Parent:ToPlayer() then
		player = tear.Parent:ToPlayer()
	elseif tear.Parent:ToFamiliar() and tear.Parent:ToFamiliar().Player then
		local familiar = tear.Parent:ToFamiliar()

		if familiar.Variant == FamiliarVariant.INCUBUS or
		   familiar.Variant == FamiliarVariant.SPRINKLER or
		   familiar.Variant == FamiliarVariant.TWISTED_BABY or
		   familiar.Variant == FamiliarVariant.BLOOD_BABY or
		   familiar.Variant == FamiliarVariant.UMBILICAL_BABY or
		   familiar.Variant == FamiliarVariant.CAINS_OTHER_EYE
		then
			player = familiar.Player
		else
			return false
		end
	else
		return false
	end

	return player:GetFireDirection() ~= Direction.NO_DIRECTION
end

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.MODEL_ROCKET] = {
	TearFallingSpeed = 1.356,
	TearVelocity = 20.0,
	BodyColor = Color(1,1,1,1,-15.796/255,-15.796/255,-15.796/255,1.062,1.062,1.062,1),
	EyeAColor = Color(1,1,1,1,-99.212/255,0,0,1.283,0,0,1),
	EyeBColor = Color(1,1,1,1,-99.212/255,0,0,1.283,0,0,1)}

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	TearFlagsLib.AddTearFlags(tear, flag)
	tear.Mass = tear.Mass / 4
	mod:changeTearVariant(tear, mod.TEAR.MODEL_ROCKET)
end, FiendFolio.ITEM.COLLECTIBLE.MODEL_ROCKET)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_TEAR_RENDER, -1 * math.huge, function(_, tear)
	-- ugh okay
	-- because of needing to not change velocity/fallingspeed at all until the first update
	-- the rotation of model rocket tears will be off until the first update
	-- and the best way i can think of to make this not suck
	-- is to just make the tear invisible until it is init'd
	-- this item just keeps getting jankier and jankier
	if tear and TearFlagsLib.HasTearFlags(tear, flag) then
		local params = TearFlagsLib.GetTearFlagParams(tear, flag)
		if not params.Init then
			return false
		end
	end
end)

function mod:rocketTearRender(tear, var, data, offset)
	local sprite = tear:GetSprite()
	local scale = tear.Scale
	local flags = tear.TearFlags
	
	local animPrefix
	if scale <= 0.675 then
		animPrefix = "Rocket1"
	elseif scale <= 0.925 then
		animPrefix = "Rocket2"
	elseif scale <= 1.175 then
		animPrefix = "Rocket3"
	elseif scale <= 1.675 then
		animPrefix = "Rocket4"
	elseif scale <= 2.175 then
		animPrefix = "Rocket5"
	else
		animPrefix = "Rocket6"
	end

	local lastLength = data.RocketTearPreviousLength or 0
	local lastSuffix = data.RocketTearPreviousSuffix or "Idle"

	local velLength = tear.Velocity:Length()
	local animSuffix = ""

	if flags & TearFlags.TEAR_BOUNCE == TearFlags.TEAR_BOUNCE and tear:CollidesWithGrid() then
		animSuffix = lastSuffix
	elseif flags & TearFlags.TEAR_LUDOVICO == TearFlags.TEAR_LUDOVICO and ludoTearHasDirection(tear) then
		animSuffix = "Move"
	elseif math.abs(velLength - lastLength) < 0.001 then
		animSuffix = lastSuffix
	elseif velLength < lastLength then
		animSuffix = "Idle"
	elseif velLength > lastLength then
		animSuffix = "Move"
	else
		animSuffix = lastSuffix
	end

	data.RocketTearPreviousLength = velLength
	data.RocketTearPreviousSuffix = animSuffix
	
	local anim = animPrefix .. animSuffix
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
mod:AddCallback("FF_CUSTOM_TEAR_RENDER", mod.rocketTearRender, FiendFolio.TEAR.MODEL_ROCKET)

-- moving fire color code into their own priority callbacks to avoid issues with other stuff cancelling the callback affecting how sprite color is stored and used
-- sorry about the lag the extra getdata/sprite calls will make but at least it will only be for this tear variant
mod:AddPriorityCallback(ModCallbacks.MC_PRE_TEAR_RENDER, math.huge, function(_, tear)
	local data = mod:GetEntityData(tear)
	local sprite = tear:GetSprite()
	
	local fireLayer = sprite:GetLayer(1)
	local rocketLayer = sprite:GetLayer(2)
	if fireLayer then
		fireLayer:SetColor(Color(1, 1, 1, sprite.Color.A, 0, 0, 0))
	end
	if rocketLayer then
		rocketLayer:SetColor(sprite.Color)
	end
	data.RocketTearCurrentColor = Color.Lerp(sprite.Color, sprite.Color, 1) -- need a copy of the color for some reason, otherwise it doesn't work
	sprite.Color = Color(1, 1, 1, 1, 0, 0, 0)
end, FiendFolio.TEAR.MODEL_ROCKET)

mod:AddPriorityCallback(ModCallbacks.MC_POST_TEAR_RENDER, -1 * math.huge, function(_, tear)
	local data = mod:GetEntityData(tear)
	local sprite = tear:GetSprite()
	
	sprite.Color = data.RocketTearCurrentColor or sprite.Color
	data.RocketTearCurrentColor = nil
end, FiendFolio.TEAR.MODEL_ROCKET)

function mod:rocketTearSplat(tear, var, data)
	sfx:Play(SoundEffect.SOUND_POT_BREAK, 0.5, 0, false, 3)
	
	if tear.TearFlags & TearFlags.TEAR_EXPLOSIVE == TearFlags.TEAR_EXPLOSIVE then return end

	local scale = tear.Scale
	local color = tear:GetSprite().Color
	
	local poof = Isaac.Spawn(1000, EffectVariant.IMPACT, 0, tear.Position, nilvector, tear)
	poof:GetSprite().Color = color
	poof.SpriteScale = Vector(scale * 0.8, scale * 0.8)
	poof.PositionOffset = tear.PositionOffset
	
	for i = 1, 5 do
		local gib = Isaac.Spawn(1000, EffectVariant.TOOTH_PARTICLE, 921, tear.Position, RandomVector()*2, tear):ToEffect()
		gib.m_Height = math.min(-5, tear.Height)
		gib:GetSprite().Color = color
		gib.State = 2
	end
end
mod:AddCallback("FF_CUSTOM_TEAR_SPLAT", mod.rocketTearSplat, FiendFolio.TEAR.MODEL_ROCKET)