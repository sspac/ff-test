local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local BrandonTooth = {
	NORMAL = 1,
	TINY = 2,
	LONG = 3,
}

local TOOTH_ODDS = {
	{ BrandonTooth.NORMAL, 60 },
	{ BrandonTooth.TINY, 10 },
	{ BrandonTooth.LONG, 40 },
}

local EMBEDDED_TEETH_SOFT_CAP = 10

local MOVE_SPEED = 3
local PROJ_SPEED = 10
local LONG_TOOTH_SPEED_MULT = 1.3
local PROJ_COOLDOWN = 3
local PROJ_ARC = 8
local TURN_STRENGTH = 0.25

local MIN_STEPS_BEFORE_ATTACK = 3
local MAX_STEPS_BEFORE_ATTACK = 6

local IDLE_TIME = 30
local MOVE_TIME = 120
local ATTACK_TIME = 90
local RECOVER_TIME = 60

local TIMER_VARIANCE = 0.2

local function VaryTimer(timer)
	return mod:RandomInt(math.ceil(timer * 1-TIMER_VARIANCE), math.ceil(timer * 1+TIMER_VARIANCE))
end

local function MaybeStartAttack(npc)
	local target = npc:GetPlayerTarget()
	if npc.I1 <= 0 and not mod:isScareOrConfuse(npc) and not (mod:isFriend(npc) and target.Type == EntityType.ENTITY_PLAYER)
			and game:GetRoom():CheckLine(npc.Position, target.Position, 3) then
		npc.State = NpcState.STATE_ATTACK
		npc:GetSprite():Play("ShootStart", true)
		npc:GetSprite().FlipX = target.Position.X > npc.Position.X
		mod:PlaySound(SoundEffect.SOUND_LOW_INHALE, npc, 1.1, 0.6)
		npc.StateFrame = VaryTimer(ATTACK_TIME)
		npc.V2 = (target.Position - npc.Position):Normalized()
		mod:GetEntityData(npc).brandonAllowSmallTeeth = #Isaac.FindByType(mod.FF.SlingerTooth.ID, mod.FF.SlingerTooth.Var) < EMBEDDED_TEETH_SOFT_CAP
		return true
	end
	return false
end

function mod:GetBrandonStepDirection(npc, chaseTarget)
	chaseTarget = chaseTarget or mod:isFriend(npc)
	
	local target = npc:GetPlayerTarget()
	
	if mod:isConfuse(npc) then
		return RandomVector()
	elseif mod:isScare(npc) then
		return (npc.Position - target.Position):Normalized()
	elseif chaseTarget and game:GetRoom():CheckLine(npc.Position, target.Position, 1, 900) then
		return (target.Position - npc.Position):Normalized()
	elseif chaseTarget and npc.Pathfinder:HasPathToPos(target.Position, false) then
		local currentVel = Vector(npc.Velocity.X, npc.Velocity.Y)
		npc.Velocity = mod.nilvector
		npc.Pathfinder:FindGridPath(target.Position, 1, 900, true)
		local dir = npc.Velocity:Normalized()
		npc.Velocity = currentVel
		return dir
	else
		local wanderDirection = mod:GetEntityData(npc).ffBrandonWanderDirection
		if not wanderDirection or wanderDirection:Length() == 0 or Random() % 10 == 0 then
			wanderDirection = RandomVector()
		end
		local TURN_RADIUS = 45
		local TURN_ATTEMPTS = 8
		local turnDir = (Random() % 2 == 0) and -1 or 1
		wanderDirection = wanderDirection:Rotated(mod:RandomInt(0, TURN_RADIUS) * turnDir)
		local attempts = 0
		while attempts < TURN_ATTEMPTS and not game:GetRoom():CheckLine(npc.Position, npc.Position + wanderDirection:Resized(40), 0) do
			local otherWay = wanderDirection:Rotated(0.5 * TURN_RADIUS * turnDir * -1)
			attempts = attempts + 1
		end
		if attempts >= TURN_ATTEMPTS then
			wanderDirection = RandomVector()
		end
		mod:GetEntityData(npc).ffBrandonWanderDirection = wanderDirection
		return wanderDirection
	end
	
	return RandomVector()
end

function mod:BrandonUpdate(npc)
	local spr = npc:GetSprite()
	local data = mod:GetEntityData(npc)
	local target = npc:GetPlayerTarget()
	local movin = false
	local anim
	
	if not data.Init then
		spr:Play("Idle", true)
		npc.State = NpcState.STATE_IDLE
		npc.StateFrame = VaryTimer(IDLE_TIME)
		npc.I1 = mod:RandomInt(MIN_STEPS_BEFORE_ATTACK, MAX_STEPS_BEFORE_ATTACK)
		data.Init = true
	end
	
	if npc.StateFrame > 0 then
		npc.StateFrame = npc.StateFrame - 1
	end
	
	if npc.State == NpcState.STATE_ATTACK2 then
		if spr:IsFinished("Recover") then
			npc.State = NpcState.STATE_IDLE
			npc.StateFrame = math.floor(VaryTimer(IDLE_TIME) * 0.5)
		elseif spr:IsFinished("ShootEnd") then
			anim = "Idle02"
		elseif npc.StateFrame <= 0 and not spr:IsPlaying("Recover") then
			anim = "Recover"
			mod:PlaySound(SoundEffect.SOUND_MOUTH_FULL, npc, 1.0, 0.6)
		end
	elseif npc.State == NpcState.STATE_ATTACK then
		if npc.StateFrame <= 0 then
			anim = "ShootEnd"
			mod:PlaySound(SoundEffect.SOUND_MONSTER_GRUNT_4, npc, 1.1, 0.6)
			npc.State = NpcState.STATE_ATTACK2
			npc.StateFrame = VaryTimer(RECOVER_TIME)
			npc.I1 = mod:RandomInt(MIN_STEPS_BEFORE_ATTACK, MAX_STEPS_BEFORE_ATTACK)
			npc.V2 = mod.nilvector
		elseif not spr:IsPlaying("ShootStart") then
			local aimDir = npc.V2
			local targetDir = (target.Position - npc.Position):Normalized()
			if npc.V2:Length() == 0 then
				aimDir = targetDir
			end
			local angle = npc.V2:GetAngleDegrees()
			local targetAngle = targetDir:GetAngleDegrees()
			local rotateBy = mod.RotateTowardsTarget(angle, targetAngle, TURN_STRENGTH)
			aimDir = aimDir:Rotated(rotateBy)
			npc.V2 = aimDir
			angle = aimDir:GetAngleDegrees() % 360
			if angle >= 30 and angle < 90 then
				anim = "ShootLoopDown"
				spr.FlipX = true
			elseif angle >= 90 and angle < 150 then
				anim = "ShootLoopDown"
				spr.FlipX = false
			elseif angle >= 150 and angle < 210 then
				anim = "ShootLoopHori"
				spr.FlipX = false
			elseif angle >= 210 and angle < 270 then
				anim = "ShootLoopUp"
				spr.FlipX = false
			elseif angle >= 270 and angle < 330 then
				anim = "ShootLoopUp"
				spr.FlipX = true
			else  -- Angle >= 300 or angle < 30
				anim = "ShootLoopHori"
				spr.FlipX = true
			end
			if npc.ProjectileCooldown <= 0 then
				local toothType = StageAPI.WeightedRNG(TOOTH_ODDS)
				if toothType == BrandonTooth.TINY and not mod:GetEntityData(npc).brandonAllowSmallTeeth then
					toothType = BrandonTooth.NORMAL
				end
				local params = ProjectileParams()
				params.Variant = ProjectileVariant.PROJECTILE_BONE
				if toothType == BrandonTooth.TINY then
					params.BulletFlags = ProjectileFlags.BOUNCE
				elseif toothType == BrandonTooth.LONG then
					params.VelocityMulti = LONG_TOOTH_SPEED_MULT
				end
				mod:SetGatheredProjectiles()
				local vel = aimDir:Resized(PROJ_SPEED):Rotated(mod:RandomInt(-PROJ_ARC, PROJ_ARC))
				npc:FireProjectiles(npc.Position + aimDir:Resized(npc.Size * 0.5), vel, 0, params)
				for _, proj in pairs(mod:GetGatheredProjectiles()) do
					local projSpr = proj:GetSprite()
					projSpr:Load("gfx/enemies/brandon/projectile_tooth.anm2", true)
					local anim = "Large01"
					if toothType == BrandonTooth.TINY then
						anim = "Tiny01"
					elseif toothType == BrandonTooth.LONG then
						anim = (Random() % 2 == 0) and "Long01" or "Long02"
					end
					projSpr:Play(anim, true)
					mod:GetEntityData(proj).BrandonTooth = toothType
					mod:GetEntityData(proj).tooth = true
					proj:Update()
				end
				mod:PlaySound(SoundEffect.SOUND_LITTLE_SPIT, npc, 1.2, 0.6)
				npc.ProjectileCooldown = PROJ_COOLDOWN
			else
				npc.ProjectileCooldown = npc.ProjectileCooldown - 1
			end
		end
	elseif npc.State == NpcState.STATE_MOVE then
		anim = "Walk"
		if spr:IsEventTriggered("StartStep") then
			if MaybeStartAttack(npc) then
				anim = nil
			elseif npc.StateFrame > 0 then
				npc.V1 = mod:GetBrandonStepDirection(npc, false)
				spr.FlipX = npc.V1.X > 0
			else
				npc.V1 = mod.nilvector
				npc.State = NpcState.STATE_IDLE
				npc.StateFrame = VaryTimer(IDLE_TIME)
			end
		elseif spr:IsEventTriggered("StopStep") then
			npc.V1 = mod.nilvector
			npc.I1 = npc.I1 - 1
		end
	elseif npc.State ~= NpcState.STATE_IDLE then
		npc.State = NpcState.STATE_IDLE
		npc.StateFrame = VaryTimer(IDLE_TIME)
	end
	
	if spr:IsEventTriggered("StopStep") then
		npc:PlaySound(SoundEffect.SOUND_SCAMPER, 0.5, 0, false, 0.5)
	end
	
	if npc.State == NpcState.STATE_IDLE then
		if npc.StateFrame <= 0 then
			if not MaybeStartAttack(npc) then
				npc.State = NpcState.STATE_MOVE
				npc.StateFrame = VaryTimer(MOVE_TIME)
			end
		else
			anim = "Idle"
		end
	end
	
	if anim and spr:GetAnimation() ~= anim then
		spr:Play(anim, true)
	end
	
	local targetVel = mod.nilvector
	if npc.State == NpcState.STATE_MOVE and npc.V1:Length() > 0 then
		targetVel = npc.V1:Resized(MOVE_SPEED)
	end
	npc.Velocity = mod:Lerp(npc.Velocity, targetVel, 0.25)
end

mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, function(_, proj)
	local data = mod:GetEntityData(proj)
	if data.BrandonTooth == BrandonTooth.LONG and proj.Velocity:Length() > 0 then
		proj:GetSprite().Rotation = proj.Velocity:GetAngleDegrees() + 90
	end
	if proj:IsDead() and data.BrandonTooth == BrandonTooth.TINY and proj.Variant == ProjectileVariant.PROJECTILE_BONE and proj:ToProjectile().Height > -5 then
		proj.Variant = ProjectileVariant.PROJECTILE_PUKE
		data.tooth = nil
		mod:PlaySound(SoundEffect.SOUND_MEATY_DEATHS, npc, 1.5, 0.4)
		Isaac.Spawn(mod.FF.SlingerTooth.ID, mod.FF.SlingerTooth.Var, 2, proj.Position, mod.nilvector, proj.SpawnerEntity or proj)
		local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 1, proj.Position, mod.nilvector, proj)
		poof.Color = FiendFolio.ColorCorpseGreen
		poof.DepthOffset = 1
	end
end, ProjectileVariant.PROJECTILE_BONE)

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, proj)
	if proj:IsDead() and mod:GetEntityData(proj).BrandonTooth == BrandonTooth.TINY and proj.Variant ~= ProjectileVariant.PROJECTILE_BONE then
		for _, splat in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.BULLET_POOF, 0)) do
			if splat.FrameCount <= 0 and splat.Position:Distance(proj.Position) == 0 then
				splat:Remove()
			end
		end
	end
end, EntityType.ENTITY_PROJECTILE)
