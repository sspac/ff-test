local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local PROJ_SPEED = 8
local MIN_PROJ_COOLDOWN = 30
local MAX_PROJ_COOLDOWN = 60
local MOVE_SPEED = 3
local EVADE_SPEED = 6
local RANGE = 240
local MELTED_RANGE = 480
local MELTED_BURST = 1
local MELTED_ATTACK_MIN_COOLDOWN = 10
local MELTED_ATTACK_MAX_COOLDOWN = 20

function mod:FluxInit(npc)
	mod:GetEntityData(npc).ffRadioactiveEnemy = true
	mod:GetEntityData(npc).ffAbsorbRadiation = true
	npc.SplatColor = mod.ColorBobsGreen
end

function mod:FluxUpdate(npc)
	local spr = npc:GetSprite()
	local data = mod:GetEntityData(npc)
	
	if npc.ProjectileCooldown > 0 then
		npc.ProjectileCooldown = npc.ProjectileCooldown - 1
	end
	
	local target = npc:GetPlayerTarget()
	local friendlyTargetingPlayer = mod:isFriend(npc) and target.Type == EntityType.ENTITY_PLAYER
	local targetPos = target.Position
	local targetDist = targetPos:Distance(npc.Position)
	
	if spr:IsFinished("Attack") then
		spr:Play("Evade", true)
		npc.I1 = mod:RandomInt(60, 120)
		if Random() % 2 == 0 then
			npc.I1 = npc.I1 * -1
		end
	elseif spr:IsPlaying("Idle") then
		if mod:GetRadiationPercent(npc, data) > 0.7 then
			spr:Play("Melt", true)
			npc.Mass = 30
			data.ffAbsorbRadiation = false
			npc:PlaySound(SoundEffect.SOUND_DEATH_REVERSE, 1.0, 0, false, 1.0)
			npc.I1 = 0
		elseif not friendlyTargetingPlayer and (targetDist < RANGE * 0.33 or (data.lastHp and data.lastHp > npc.HitPoints)) then
			spr:Play("Evade", true)
			npc.I1 = mod:RandomInt(-60, 60)
		elseif npc.ProjectileCooldown <= 0 and targetDist < RANGE and game:GetRoom():CheckLine(npc.Position, targetPos, 1, 0) then
			spr:Play("Attack", true)
		end
		data.lastHp = npc.HitPoints
	elseif (spr:GetAnimation() == "IdleMelted" or spr:IsFinished("AttackMelted")) and not mod:IsEnemyExposedToRadiation(npc, true, data) then
		spr:Play("Unmelt", true)
		npc.Mass = 3
		data.ffAbsorbRadiation = true
		npc:PlaySound(SoundEffect.SOUND_DEATH_REVERSE, 1.0, 0, false, 1.0)
		npc.I1 = 0
	elseif spr:IsFinished("Melt") or spr:IsFinished("AttackMelted") or (spr:GetAnimation() == "IdleMelted" and npc.ProjectileCooldown <= 0) then
		if npc.I1 >= MELTED_BURST or targetDist > MELTED_RANGE or not game:GetRoom():CheckLine(npc.Position, targetPos, 1, 0) then
			spr:Play("IdleMelted", false)
			npc.I1 = 0
			npc.ProjectileCooldown = mod:RandomInt(MELTED_ATTACK_MIN_COOLDOWN, MELTED_ATTACK_MAX_COOLDOWN)
		else
			spr:Play("AttackMelted", true)
			npc.I1 = npc.I1 + 1
		end
	elseif not spr:IsPlaying() then
		data.ffAbsorbRadiation = true
		spr:Play("Idle", true)
	end
	
	if spr:IsEventTriggered("Splat") then
		npc:PlaySound(SoundEffect.SOUND_ANIMAL_SQUISH, 1.0, 0, false, 1.0)
	elseif spr:IsEventTriggered("Splat2") then
		npc:PlaySound(SoundEffect.SOUND_ANIMAL_SQUISH, 0.85, 0, false, 1.15)
	elseif spr:IsEventTriggered("ShootFire") then
		npc:PlaySound(SoundEffect.SOUND_FLAMETHROWER_END, 1.0, 0, false, 1.5)
		local firewave = Isaac.Spawn(mod.FF.RadioactiveFireWave.ID, mod.FF.RadioactiveFireWave.Var, mod.FF.RadioactiveFireWave.Sub, npc.Position, mod.nilvector, npc):ToEffect()
		firewave.Rotation = (targetPos - npc.Position):GetAngleDegrees()
		firewave:Update()
	elseif spr:IsEventTriggered("Shoot") then
		local shotVel = (targetPos - npc.Position):Resized(PROJ_SPEED)
		local shotPos = npc.Position + shotVel
		local proj = mod:FireProjectiles(npc, shotPos, shotVel, 0, ProjectileParams())
		proj:GetSprite():ReplaceSpritesheet(0, "gfx/projectiles/radioactive.png")
		proj:GetSprite():LoadGraphics()
		mod:GetEntityData(proj).customProjSplat = "gfx/projectiles/radioactiveSplat.png"
		npc.ProjectileCooldown = mod:RandomInt(MIN_PROJ_COOLDOWN, MAX_PROJ_COOLDOWN)
		npc:PlaySound(SoundEffect.SOUND_LITTLE_SPIT, 1.0, 0, false, 1.0)
	end
	
	if spr:IsPlaying("Evade") then
		npc.Velocity = mod:Lerp(npc.Velocity, (npc.Position - targetPos):Resized(EVADE_SPEED):Rotated(npc.I1), 0.15)
	elseif not spr:IsPlaying("Idle") or (friendlyTargetingPlayer and targetDist < 30) then
		npc.Velocity = mod:Lerp(npc.Velocity, mod.nilvector, 0.15)
	elseif game:GetRoom():CheckLine(npc.Position, targetPos, 1, 900) then
		npc.Velocity = mod:Lerp(npc.Velocity, (targetPos - npc.Position):Resized(MOVE_SPEED), 0.15)
	else
		npc.Pathfinder:FindGridPath(targetPos, MOVE_SPEED / 9.5, 900, true)
	end
end

-- Allied radioactive enemies do not take damage from Flux's fire waves.
mod:AddPreNpcTakeDmgFromSourceCallback(function(_, npc, data, damage, damageFlags, sourceEnt, sourceData, sourceRef)
	if not mod:AllowRadioactiveExplosionFireDamage(npc, data, sourceRef) then
		return false
	end
end, mod.FF.RadioactiveFireJet.ID, mod.FF.RadioactiveFireJet.Var, mod.FF.RadioactiveFireJet.Sub)
