local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

-- Idle Movement
local TARGET_DISTANCE = 100
local MIN_MOVE_DELAY = 30
local MAX_MOVE_DELAY = 60
local MAX_MOVE_ANGLE = 90
local MAX_MOVE_SPEED = 10

-- Time between attacks
local MIN_ATTACK_DELAY_FRAMES = 80
local MAX_ATTACK_DELAY_FRAMES = 160

-- Attack
local ATTACK_CHARGE_SPEED = 14
local ATTACK_SLOWDOWN_HEIGHT = 100
local ATTACK_SLOWDOWN_DIST = 50
local ATTACK_PLAYER_TRACKING_DELAY = 10
local ATTACK_PLAYER_TRACKING_MIN_HEIGHT = 30
local ATTACK_START_FALLING_SPEED = -3.5
local ATTACK_FALLING_ACCELERATION = 0.05
local ATTACK_FALLING_ACCELERATION_ACCELERATION = 0.0003

-- Flame Jets
local FLAMES_DELAY = 4
local FLAMES_SPEED = 30
local FLAMES_CURVE = 9
local FLAMES_START_SCALE = 1.0
local FLAMES_SHRINK_BY = 0.1

local STATE = {
	IDLE = 0,
	ATTACK_PREPARE = 1,
	ATTACK = 2,
}

local function PlayAnim(npc, anim)
	if not npc:GetSprite():IsPlaying(anim) then
		npc:GetSprite():Play(anim, true)
	end
end

function mod:PickNewYearTargetPos(npc)
	local target = npc:GetPlayerTarget()
	
	local straightTarget = (npc.Position - target.Position):Resized(TARGET_DISTANCE)
	local angle = -MAX_MOVE_ANGLE + Random() % (MAX_MOVE_ANGLE * 2 + 1)
	npc.TargetPosition = target.Position + straightTarget:Rotated(angle)
	
	mod:GetEntityData(npc).nyTargetPosDelay = MIN_MOVE_DELAY + Random() % (MAX_MOVE_DELAY - MIN_MOVE_DELAY + 1)
end

local function SpawnFire(ptr, pos, vel, scale, flipCurve)
	if game:GetRoom():GetGridCollisionAtPos(pos) ~= GridCollisionClass.COLLISION_NONE then return end
	
	local npc = ptr and ptr.Ref or nil
	scale = scale or FLAMES_START_SCALE
	
	local flame = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FIRE_JET, 0, pos, Vector.Zero, npc)
	flame:GetSprite():Load("gfx/enemies/new year/new_year_fire_jet.anm2", true)
	flame:GetSprite().Scale = Vector(scale, scale)
	flame:GetSprite():Play("Idle", true)
	
	local newPos = pos + vel
	local newScale = scale - FLAMES_SHRINK_BY
	
	if game:GetRoom():IsPositionInRoom(newPos, 0) and newScale > 0.3 then
		mod.scheduleForUpdate(function()
			local curve = FLAMES_CURVE * (flipCurve and -1 or 1)
			SpawnFire(ptr, newPos, vel:Rotated(curve), newScale, flipCurve)
		end, FLAMES_DELAY)
	end
end

function mod:NewYearTakeDmg(npc, damageAmount, damageFlags, damageSource)
	if npc.Variant ~= mod.FF.NewYear.Var then return end
	
	if mod:GetEntityData(npc).State == STATE.ATTACK then
		return false
	end
	
	if damageSource and damageSource.Type == EntityType.ENTITY_EFFECT
			and damageSource.Variant == EffectVariant.FIRE_JET
			and damageSource.SpawnerType == mod.FF.NewYear.ID
			and damageSource.SpawnerVariant == mod.FF.NewYear.Var then
		return false
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CallbackPriority.EARLY, mod.NewYearTakeDmg, mod.FF.NewYear.ID)

function mod:NewYearCollision(npc)
	if mod:GetEntityData(npc).State == STATE.ATTACK then
		return true
	end
end

function mod:NewYearOtherCollision(entity, collider)
	if collider and collider.Type == mod.FF.NewYear.ID and collider.Variant == mod.FF.NewYear.Var then
		return mod:NewYearCollision(collider)
	end
end
for _, callbackid in pairs({
			ModCallbacks.MC_PRE_NPC_COLLISION,
			ModCallbacks.MC_PRE_FAMILIAR_COLLISION,
			ModCallbacks.MC_PRE_PLAYER_COLLISION,
			ModCallbacks.MC_PRE_PICKUP_COLLISION,
			ModCallbacks.MC_PRE_TEAR_COLLISION,
			ModCallbacks.MC_PRE_PROJECTILE_COLLISION,
			ModCallbacks.MC_PRE_KNIFE_COLLISION,
			ModCallbacks.MC_PRE_BOMB_COLLISION,
		}) do
	mod:AddPriorityCallback(callbackid, CallbackPriority.EARLY, mod.NewYearOtherCollision)
end

local function SpawnPoof(npc)
	local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, npc.Position, Vector.Zero, npc):ToEffect()
	poof:GetSprite():Load("gfx/1000.144_enemy ghost.anm2", true)
	poof:GetSprite():Play("Explosion")
	return poof
end

function mod:NewYearImpact(npc)
	npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
	npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
	
	--npc:PlaySound(mod.Sounds.NewYearLand, 1, 0, false, 1)
	npc:PlaySound(mod.Sounds.ExcelsiorBoom, 1.2, 0, false, 1)
	
	SpawnPoof(npc)
	
	mod.XalumDamageInArea(npc, 40)
	
	local ptr = EntityPtr(npc)
	local angle = Random() % 360
	local flipCurve = (Random() % 2 == 0)
	for i=1,3 do
		local vel = Vector(FLAMES_SPEED, 0):Rotated(angle + i*120)
		SpawnFire(ptr, npc.Position + vel, vel, FLAMES_START_SCALE, flipCurve)
		local poof = SpawnPoof(npc)
		poof.SpriteScale = Vector(0.5, 0.5)
		poof.Position = npc.Position + vel * 1.5
	end
	
	for i = 1, 10 do
		local vel = RandomVector():Resized(mod:RandomInt(5, 15))
		local particle = Isaac.Spawn(EntityType.ENTITY_EFFECT, 7003, 2, npc.Position, vel, npc)
	end
end

function mod:NewYearUpdate(npc)
	local data = mod:GetEntityData(npc)
	local sprite = npc:GetSprite()
	local target = npc:GetPlayerTarget()
	
	if not data.State then
		data.State = STATE.IDLE
	end
	
	if sprite:IsPlaying("Land") then
		npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.1)
	elseif data.State == STATE.IDLE then
		if (data.nyTargetPosDelay or 0) == 0 then
			mod:PickNewYearTargetPos(npc)
		end
		
		data.nyTargetPosDelay = data.nyTargetPosDelay - 1
		data.attackCountdown = (data.attackCountdown or mod:RandomInt(MIN_ATTACK_DELAY_FRAMES, MAX_ATTACK_DELAY_FRAMES)) - 1
		
		local distFromTargetPos = npc.Position:Distance(npc.TargetPosition)
		local targetVelocity = (npc.TargetPosition - npc.Position):Resized(math.min(MAX_MOVE_SPEED, distFromTargetPos * 3))
		npc.Velocity = mod:Lerp(npc.Velocity, targetVelocity, 0.05)
		
		if data.attackCountdown <= 0 and not (target:ToPlayer() and mod:isFriend(npc)) then
			data.attackCountdown = nil
			data.State = STATE.ATTACK_PREPARE
			PlayAnim(npc, "Attack_Prepare")
		else
			PlayAnim(npc, "Idle")
		end
	end
	
	if data.State == STATE.ATTACK_PREPARE then
		if sprite:IsEventTriggered("Twinkle") then
			npc:PlaySound(mod.Sounds.NewYearTell, 1.2, 0, false, 0.7)
		end
		if not sprite:IsPlaying("Attack_Prepare") then
			data.State = STATE.ATTACK
			--npc:PlaySound(mod.Sounds.NewYearJump, 1, 0, false, 1)
			npc:PlaySound(mod.Sounds.ExcelsiorShoot, 1.2, 0, false, 1)
			
			data.FallingSpeed = ATTACK_START_FALLING_SPEED
			data.FallingAcceleration = ATTACK_FALLING_ACCELERATION
			data.FallingAccelerationAcceleration = ATTACK_FALLING_ACCELERATION_ACCELERATION
			
			local eff = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, npc.Position, Vector.Zero, npc)
			eff:GetSprite():Load(sprite:GetFilename(), true)
			eff:GetSprite():Play("Jump", true)
			eff.SortingLayer = SortingLayer.SORTING_DOOR
			eff.SpriteScale = npc.SpriteScale
			eff.Color = npc:GetColor()
			
			for i = 1, 10 do
				local vel = RandomVector():Resized(mod:RandomInt(5, 15))
				local particle = Isaac.Spawn(EntityType.ENTITY_EFFECT, 7003, 2, npc.Position, vel, npc)
			end
			
			npc.PositionOffset = npc.PositionOffset + Vector(0, -45 * npc.SpriteScale.Y)
			npc.TargetPosition = target.Position
			data.TargetPositionHistory = {}
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
		else
			npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.1)
		end
	end
	
	if data.State == STATE.ATTACK then
		local height = math.abs(npc.PositionOffset.Y)
		local isFalling = (data.FallingSpeed > 0)
		
		table.insert(data.TargetPositionHistory, Vector(target.Position.X, target.Position.Y))
		while #data.TargetPositionHistory > ATTACK_PLAYER_TRACKING_DELAY do
			table.remove(data.TargetPositionHistory, 1)
		end
		if not isFalling or height > ATTACK_PLAYER_TRACKING_MIN_HEIGHT then
			npc.TargetPosition = data.TargetPositionHistory[1]
		end
		
		local targetSpeed = ATTACK_CHARGE_SPEED
		
		if isFalling then
			if height < ATTACK_SLOWDOWN_HEIGHT then
				targetSpeed = mod:Lerp(ATTACK_CHARGE_SPEED * 0.2, ATTACK_CHARGE_SPEED, height / ATTACK_SLOWDOWN_HEIGHT)
			end
			
			local dist = npc.Position:Distance(npc.TargetPosition)
			if dist < ATTACK_SLOWDOWN_DIST then
				targetSpeed = mod:Lerp(0, targetSpeed, dist / ATTACK_SLOWDOWN_DIST)
			end
		end
		
		local targetVelocity = (npc.TargetPosition - npc.Position):Resized(targetSpeed)
		npc.Velocity = mod:Lerp(npc.Velocity, targetVelocity, isFalling and 0.15 or 0.03)
		
		if isFalling and not data.wasFalling then
			npc:PlaySound(mod.Sounds.NewYearFall, 1, 0, false, 1)
		end
		
		if npc.FrameCount % 3 == 0 then
			local particlePos = npc.Position + npc.PositionOffset
			local angle = 30
			local particleVel = npc.Velocity:Rotated(mod:RandomInt(180-angle, 180+angle)) * 0.75
			local particle = Isaac.Spawn(EntityType.ENTITY_EFFECT, 7003, 2, particlePos, particleVel, npc)
		end
		
		data.wasFalling = isFalling
		
		PlayAnim(npc, "Charge")
	end
end

local function UpdateNewYearHeight(npc)
	if game:IsPaused() then return end
	
	local data = mod:GetEntityData(npc)
	
	if data.LastUpdate == Isaac.GetFrameCount() then return end
	
	data.LastUpdate = Isaac.GetFrameCount()
	
	local target = npc:GetPlayerTarget()
	local sprite = npc:GetSprite()
	
	if data.State == STATE.ATTACK then
		local height = -npc.PositionOffset.Y
		
		height = height - data.FallingSpeed
		data.FallingSpeed = data.FallingSpeed + data.FallingAcceleration
		data.FallingAcceleration = data.FallingAcceleration + data.FallingAccelerationAcceleration
		
		if height <= 0 then
			data.State = STATE.IDLE
			PlayAnim(npc, "Land")
			npc.Velocity = Vector.Zero
			height = 0
			mod:ClearTrailPath(npc)
			mod:NewYearImpact(npc)
		end
		
		npc.PositionOffset = Vector(npc.PositionOffset.X, -height)
	end
end

function mod:NewYearRender(npc)
	if npc:GetSprite():GetAnimation() == "Charge" then
		mod:RenderTrail(npc, {
			Spacing = 12,
			TrailAnim = "Charge_Trail",
			TrailOutlineAnim = "Charge_Trail_Outline",
			RenderEntity = true,
			EntityOutlineAnim = "Charge_Outline"
		})
	else
		mod:ClearTrailPath(npc)
	end
	
	UpdateNewYearHeight(npc)
end
