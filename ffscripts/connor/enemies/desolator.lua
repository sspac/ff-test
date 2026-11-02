local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local RADIATION_RADIUS = 70
local RADIATION_DURATION = 30 * 10

local WALK_SPEED = 3
local MIN_STEPS_BEFORE_ATTACK = 3
local MAX_STEPS_BEFORE_ATTACK = 5

local PROJ_PARAMS = ProjectileParams()
PROJ_PARAMS.HeightModifier = -15
PROJ_PARAMS.FallingSpeedModifier = -10
PROJ_PARAMS.FallingAccelModifier = 0.5
PROJ_PARAMS.Scale = 2
PROJ_PARAMS.Damage = 1
PROJ_PARAMS.BulletFlags = ProjectileFlags.EXPLODE

-- Projectile speed will be adjusted to hit a target closer or further away.
-- The amount of time the projectile is airborne does not change.
local MIN_PROJ_SPEED = 3.5
local MAX_PROJ_SPEED = 8.5

local MIN_RANGE = mod:PredictProjectileRangeFromParams(PROJ_PARAMS, MIN_PROJ_SPEED)
local MAX_RANGE = mod:PredictProjectileRangeFromParams(PROJ_PARAMS, MAX_PROJ_SPEED)

function mod:DesolatorInit(npc)
	npc.SplatColor = mod.ColorBobsGreen
	mod:GetEntityData(npc).ffRadioactiveEnemy = true
end

local function MaybeAttack(npc)
	local target = npc:GetPlayerTarget()
	
	if mod:isFriend(npc) and target.Type == EntityType.ENTITY_PLAYER then
		return false
	end
	
	local targetInRange = target.Position:Distance(npc.Position) <= MAX_RANGE
	
	if targetInRange then
		npc.Target = target
		npc.TargetPosition = target.Position
		npc.State = NpcState.STATE_ATTACK
		npc:GetSprite():Play("Shoot", true)
		npc:GetSprite().FlipX = target.Position.X > npc.Position.X
		npc:PlaySound(SoundEffect.SOUND_MONSTER_GRUNT_4, 1, 0, false, 1)
		return true
	end
	
	return false
end

function mod:DesolatorUpdate(npc)
	local data = mod:GetEntityData(npc)
	local spr = npc:GetSprite()
	
	if npc.State < 3 then
		npc.State = NpcState.STATE_IDLE
		npc.StateFrame = 20
	end
	
	if npc.StateFrame > 0 then
		npc.StateFrame = npc.StateFrame - 1
	elseif npc.State == NpcState.STATE_IDLE then
		if Random() % 6 ~= 0 or not MaybeAttack(npc) then
			npc.State = NpcState.STATE_MOVE
			npc.I1 = mod:RandomInt(MIN_STEPS_BEFORE_ATTACK, MAX_STEPS_BEFORE_ATTACK)
			spr:Play("Walk", true)
		end
	end
	
	local anim = "Idle"
	
	if npc.State == NpcState.STATE_MOVE then
		anim = "Walk"
		
		if spr:IsEventTriggered("StepStart") then
			if npc.I1 > 0 or not MaybeAttack(npc) then
				npc.V1 = mod:GetBrandonStepDirection(npc, true):Resized(WALK_SPEED)
				spr.FlipX = npc.V1.X > 0
			end
		elseif spr:IsEventTriggered("StepEnd") then
			npc:PlaySound(SoundEffect.SOUND_SCAMPER, 0.5, 0, false, 0.5)
			npc.V1 = mod.nilvector
			npc.I1 = npc.I1 - 1
		end
	end
	
	if npc.State == NpcState.STATE_ATTACK then
		anim = nil
		
		if npc.Target and npc.Target:Exists() then
			npc.TargetPosition = npc.Target.Position
		end
		
		if not spr:IsPlaying("Shoot") then
			spr:Play("Idle", true)
			npc.State = NpcState.STATE_IDLE
			npc.StateFrame = 15
		elseif spr:IsEventTriggered("Shoot") then
			npc:PlaySound(SoundEffect.SOUND_BULLET_SHOT, 1, 0, false, 1)
			local shootPos = npc.Position + Vector(-40 * (spr.FlipX and -1 or 1), 0)
			local dist = shootPos:Distance(npc.TargetPosition)
			
			local n
			if dist <= MIN_RANGE then
				n = 0.0
			elseif dist >= MAX_RANGE then
				n = 1.0
			else
				n = (dist - MIN_RANGE) / (MAX_RANGE - MIN_RANGE)
			end
			
			local shotSpeed = mod:Lerp(MIN_PROJ_SPEED, MAX_PROJ_SPEED, n)
			local vel = (npc.TargetPosition - shootPos):Resized(shotSpeed)
			
			local proj = mod:FireProjectiles(npc, shootPos, vel, 0, PROJ_PARAMS)
			proj:GetSprite():Load("gfx/projectiles/radioactive_glowing.anm2", true)
			mod:GetEntityData(proj).customProjSplat = "gfx/projectiles/radioactiveSplat.png"
			mod:GetEntityData(proj).isDesolatorProjectile = true
			
			local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 5, shootPos, mod.nilvector, npc):ToEffect()
			--effect.DepthOffset = proj.Position.Y * 1.25
			effect.SpriteScale = effect.SpriteScale * 0.4
			effect.Color = Color(0,1,0, 0.2, 0,1,0)
			effect.SpriteOffset = Vector(0, PROJ_PARAMS.HeightModifier - 23)
			effect:GetSprite().PlaybackSpeed = 1.25
			effect:Update()
			
			npc.Target = nil
		elseif not spr:WasEventTriggered("Shoot") then
			spr.FlipX = npc.TargetPosition.X > npc.Position.X
		end
	end
	
	if anim and not spr:IsPlaying(anim) then
		spr:Play(anim, true)
	end
	
	npc.Velocity = mod:Lerp(npc.Velocity, npc.V1, 0.2)
end

function mod:DesolatorProjectileUpdate(proj, data)
	if not data.isDesolatorProjectile then return end
	
	if proj.FrameCount % 2 == 0 then
		local pos = (proj.Position - proj.Velocity) + RandomVector() * 15 * ((Random() % 101)/100)
		local vel = mod.nilvector
		local trail = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HAEMO_TRAIL, 0, pos, vel, proj):ToEffect()
		trail:GetSprite().PlaybackSpeed = 0.5
		trail.SpriteScale = Vector(0.2, 0.2) * proj.Scale
		trail.PositionOffset = Vector(0, proj.Height - proj.FallingSpeed)
		local color = Color(1,1,1,0.5,0.3,1,0)
		color:SetColorize(1,1,1,1)
		trail.Color = color
		trail:Update()
	end
end

function mod:DesolatorProjectileDeath(proj, data)
	if data.isDesolatorProjectile then
		mod:SpawnRadioactiveAura(proj.SpawnerEntity, proj.Position, RADIATION_RADIUS, RADIATION_DURATION)
	end
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, eff)
	for _, proj in ipairs(Isaac.FindByType(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL)) do
		if mod:GetEntityData(proj).isDesolatorProjectile and eff.Position:Distance(proj.Position) == 0 then
			mod:GetEntityData(eff).isRadioactiveExplosion = true
		end
	end
end, EffectVariant.BOMB_EXPLOSION)

-- Allied radioactive enemies do not take damage from Desolator's projectile explosion.
mod:AddPreNpcTakeDmgFromSourceCallback(function(_, npc, data, damage, damageFlags, proj, projData, sourceRef)
	if projData.isDesolatorProjectile and damageFlags & DamageFlag.DAMAGE_EXPLOSION ~= 0 and not mod:AllowRadioactiveExplosionFireDamage(npc, data, sourceRef) then
		return false
	end
end, EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL)
