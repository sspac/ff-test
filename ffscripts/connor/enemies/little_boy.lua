local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local RADIATION_RADIUS = 80
local RADIATION_DURATION = 30 * 10 -- 10 seconds
local TARGET_RADIUS = 60 -- Radius around the player's current position to randomly pick a spot to land.
local ATTACK_DELAY = 20 -- Added delay (in frames) between ascent and descent, not including travel time.
local MAX_HEIGHT = 1000 -- How high is considered high enough to be "off-screen". Implicitly affects how long the attack takes.

function mod:LittleBoyInit(npc)
	if npc.Variant ~= mod.FF.LittleBoy.Var then return end
	
	npc.SplatColor = Color(0,1,0,1)
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.LittleBoyInit, mod.FF.LittleBoy.ID)

function mod:LittleBoyUpdate(npc)
	if npc.Variant ~= mod.FF.LittleBoy.Var then return end
	
	local data = mod:GetEntityData(npc)
	
	local currentFrame = Isaac.GetFrameCount()
	if game:IsPaused() or data.ffLittleBoyEffectLastUpdate == currentFrame then return end
	data.ffLittleBoyEffectLastUpdate = currentFrame
	
	local spr = npc:GetSprite()
	
	if spr:IsPlaying("Flying") then
		data.ffLittleBoyFlight = (data.ffLittleBoyFlight or 0) + 1
		
		if not data.ffLittleBoyDescending and npc.PositionOffset.Y < -MAX_HEIGHT then
			data.ffLittleBoyDescending = true
			npc.Visible = false
			
			local pos = npc:GetPlayerTarget().Position + RandomVector() * (TARGET_RADIUS % npc.InitSeed)
			npc.TargetPosition = game:GetRoom():GetClampedPosition(pos, 20)
			npc.PositionOffset = Vector(0, -MAX_HEIGHT)
			spr.Rotation = 180
			
			local target = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, npc.TargetPosition, mod.nilvector, npc):ToEffect()
			mod:GetEntityData(target).ffLittleBoyEffect = true
			target.SortingLayer = SortingLayer.SORTING_BACKGROUND
			target.Parent = npc
			target.IsFollowing = false
			target:GetSprite():Load("gfx/enemies/littleboy/effect_little_boy_target.anm2", true)
			target:GetSprite():Play("Blink", true)
			
			data.ffLittleBoyFlight = 0
		end
		
		if not data.ffLittleBoyDescending then
			-- Ascent
			data.ffLittleBoyVelocity = (data.ffLittleBoyVelocity or Vector(0, -0.2)) * 1.1
		elseif data.ffLittleBoyFlight < ATTACK_DELAY then
			-- Waiting to descend
			data.ffLittleBoyVelocity = mod.nilvector
		else
			-- Descent
			data.ffLittleBoyVelocity = Vector(0, 20)
			npc.Visible = true
		end
		npc.PositionOffset = npc.PositionOffset + data.ffLittleBoyVelocity
		
		if data.ffLittleBoyDescending and npc.PositionOffset.Y >= -data.ffLittleBoyVelocity.Y then
			npc.PositionOffset = mod.nilvector
			spr:Play("Impact", true)
			spr.Rotation = 0
			npc:Kill()
		end
	end
	
	if data.ffLittleBoyTriggered and spr:IsPlaying("Flying") then
		npc.Position = npc.TargetPosition
		npc.Velocity = mod.nilvector
	end
	
	if not data.ffLittleBoyShadow then
		local shadow = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, npc.Position, mod.nilvector, npc):ToEffect()
		shadow:GetSprite():Load("gfx/effects/effect_shadowlessrockshadow.anm2", true)
		shadow:GetSprite():Play("Idle", true)
		shadow.SortingLayer = SortingLayer.SORTING_BACKGROUND
		shadow:FollowParent(npc)
		mod:GetEntityData(shadow).ffLittleBoyEffect = true
		data.ffLittleBoyShadow = shadow
	end
	
	data.ffLittleBoyShadow.ParentOffset = npc.PositionOffset * -1
	local n = 1 - math.min(math.abs(npc.PositionOffset.Y) / 1000, 1)
	
	data.ffLittleBoyShadow.SpriteScale = Vector(n,n)
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.LittleBoyUpdate, mod.FF.LittleBoy.ID)

function mod:LittleBoyPreUpdate(npc)
	if npc.Variant ~= mod.FF.LittleBoy.Var then return end
	
	local spr = npc:GetSprite()
	local data = mod:GetEntityData(npc)
	
	if spr:IsFinished("Drop") then
		npc.GridCollisionClass = 0
		npc.TargetPosition = npc.Position
		spr:Play("Flying")
		npc:PlaySound(SoundEffect.SOUND_ROCKET_LAUNCH_TINY, 1, 0, false, 1)
		npc:PlaySound(SoundEffect.SOUND_GFUEL_ROCKETLAUNCHER, 1, 0, false, 1)
	elseif spr:IsPlaying("Drop") then
		npc.Velocity = mod:Lerp(npc.Velocity, mod.nilvector, 0.1)
	end
	
	mod:LittleBoyUpdate(npc)
	
	if spr:IsPlaying("Flying") then
		local eff = Isaac.Spawn(EntityType.ENTITY_EFFECT, 59, 0, npc.Position + npc.PositionOffset, mod.nilvector, npc):ToEffect()
		eff.LifeSpan = 10
		eff.Timeout = 10
		eff:Update()
		eff.Color = Color(0.7, 0.7, 0.7, 1.0)
		eff.SpriteScale = Vector(0.1, 0.1)
	end
	
	if data.ffLittleBoyTriggered then
		if spr:GetAnimation() == "Appear" then
			spr:Play("Drop")
		end
		return true
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.LittleBoyPreUpdate, mod.FF.LittleBoy.ID)

-- Green champion safety
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, eff)
	if eff.SpawnerEntity and eff.SpawnerEntity.Type == mod.FF.LittleBoy.ID and eff.SpawnerEntity.Variant == mod.FF.LittleBoy.Var and mod:GetEntityData(eff.SpawnerEntity).ffLittleBoyDescending then
		eff:Remove()
	end
end, EffectVariant.CREEP_GREEN)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	if mod:GetEntityData(eff).ffLittleBoyEffect and (not eff.Parent or not eff.Parent:Exists() or eff.Parent:IsDead()) then
		eff:Remove()
	end
end, EffectVariant.POOF01)

function mod:LittleBoyDie(npc)
	if npc.Variant ~= mod.FF.LittleBoy.Var then return end
	
	-- Calling Explode in this callback creates rendering weirdness in the minimap.
	-- CreateTimer will defer the explosion until the next update callback.
	Isaac.CreateTimer(function ()
		Isaac.Explode(npc.Position, npc, 100)
	end, 0, 1, false)
	
	local radiation = mod:SpawnRadioactiveAura(npc, npc.Position, RADIATION_RADIUS, RADIATION_DURATION)
	radiation.Size = RADIATION_RADIUS * 0.5
	
	sfx:Stop(SoundEffect.SOUND_GFUEL_ROCKETLAUNCHER)
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.LittleBoyDie, mod.FF.LittleBoy.ID)

function mod:LittleBoyTakeDamage(npc, damageAmount)
	if npc.Variant ~= mod.FF.LittleBoy.Var then return end
	
	if mod:GetEntityData(npc).ffLittleBoyDone then return end
	
	if mod:GetEntityData(npc).ffLittleBoyTriggered then
		return false
	end
	
	if damageAmount >= npc.HitPoints then
		npc = npc:ToNPC()
		npc.EntityCollisionClass = 0
		npc.HitPoints = 1
		npc:GetSprite():Play("Drop")
		npc.Velocity = RandomVector() * (6 % npc.InitSeed)
		npc.TargetPosition = npc.Position
		npc:PlaySound(SoundEffect.SOUND_DEATH_BURST_SMALL, 1, 0, false, 1.0)
		local eff = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FLY_EXPLOSION, 0, npc.Position, mod.nilvector, npc):ToEffect()
		eff.Color = npc.SplatColor
		mod:GetEntityData(npc).ffLittleBoyTriggered = true
		return false
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CallbackPriority.LATE, mod.LittleBoyTakeDamage, mod.FF.LittleBoy.ID)

function mod:LittleBoyEarlyCollision(npc, collider)
	if npc.Variant == mod.FF.LittleBoy.Var and mod:GetEntityData(npc).ffLittleBoyTriggered then
		return true
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_NPC_COLLISION, CallbackPriority.EARLY, mod.LittleBoyEarlyCollision, mod.FF.LittleBoy.ID)

function mod:LittleBoyLateCollision(npc, collider)
	if npc.Variant ~= mod.FF.LittleBoy.Var then return end
	
	if (collider:IsActiveEnemy() and mod:isFriend(npc) and not mod:isFriend(collider)) or (not mod:isFriend(npc) and collider:ToPlayer()) then
		npc:Kill()
		return false
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_NPC_COLLISION, CallbackPriority.LATE, mod.LittleBoyLateCollision, mod.FF.LittleBoy.ID)

-- Allied radioactive enemies do not take damage from Little Boy's explosion.
mod:AddPreNpcTakeDmgFromSourceCallback(function(_, npc, data, damage, damageFlags, sourceEnt, sourceData, sourceRef)
	if damageFlags & DamageFlag.DAMAGE_EXPLOSION ~= 0 and not mod:AllowRadioactiveExplosionFireDamage(npc, data, sourceRef) then
		return false
	end
end, mod.FF.LittleBoy.ID, mod.FF.LittleBoy.Var)
