local mod = FiendFolio

local embryo = {
	Variant = mod.FF.Blastulation.Gagger,
	Special = true,

	MoveSpeed = 2.5,
	Cooldown = {3, 6},
	MaxShotSpeed = 10,

	ExplosionDamage = 40,
	CreepScale = 2.5,
	CreepDuration = 240,
	SplatterCount = 10,
}
mod:AddEmbryo(embryo)



function embryo:Init(entity)
	entity.ProjectileCooldown = mod:Random(embryo.Cooldown[1], embryo.Cooldown[2])
end

function embryo:Update(entity)
	local sprite = entity:GetSprite()


	--[[ Idle ]]--
	if entity.State == NpcState.STATE_IDLE then
		mod:LoopingAnim(sprite, "Walk Sad")

		-- Movement
		if sprite:WasEventTriggered("Landed") then
			entity.Velocity = mod:StopLerp(entity.Velocity)
		else
			mod:WanderAroundCool(entity, embryo.MoveSpeed, true)
			mod:FlipTowardsMovement(entity, sprite)
		end

		if sprite:IsEventTriggered("Landed") then
			entity.Velocity = Vector.Zero
			mod:PlaySoundCool(nil, SoundEffect.SOUND_GOOATTACH0, 0.6)

			-- Attack
			if Game():GetRoom():GetAliveEnemiesCount() > 0 then
				if entity.ProjectileCooldown <= 0 then
					entity.ProjectileCooldown = mod:Random(embryo.Cooldown[1], embryo.Cooldown[2])
					entity.State = NpcState.STATE_ATTACK
					entity.StateFrame = 0
				else
					entity.ProjectileCooldown = entity.ProjectileCooldown - 1
				end
			end
		end



	--[[ Attacking ]]--
	elseif entity.State == NpcState.STATE_ATTACK then
		entity.Velocity = mod:StopLerp(entity.Velocity)

		-- Wait for the current animation to finish
		if entity.StateFrame == 0 then
			if sprite:IsFinished() then
				entity.StateFrame = 1
				sprite:Play("AttackStart", true)
			end


		-- Gag up the machine
		elseif entity.StateFrame == 1 then
			-- Sounding
			if sprite:IsEventTriggered("Sound1") or sprite:IsEventTriggered("Sound2") then
				mod:PlaySoundCool(entity, SoundEffect.SOUND_WORM_SPIT, 1, 1.03)

				if sprite:IsEventTriggered("Sound2") then
					mod:PlaySoundCool(nil, SoundEffect.SOUND_SKIN_PULL, 0.9)
				end
			end

			if sprite:IsFinished() then
				entity.StateFrame = 2
				sprite:Play("AttackStop", true)

				local target = entity:GetPlayerTarget()
				entity.TargetPosition = target.Position - entity.Position
				mod:FlipTowardsTarget(entity, sprite)
			end


		-- Spit that thang
		elseif entity.StateFrame == 2 then
			if sprite:IsEventTriggered("Landed") then
				local params = ProjectileParams()
				params.Variant = mod.FF.Blastulation.BloodDonationMachineProjectile
				params.FallingAccelModifier = 1.25
				params.FallingSpeedModifier = -18

				local nullOffset = entity:GetNullOffset("Machine")
				local pos = entity.Position + Vector(nullOffset.X, 0)
				local speed = math.min(embryo.MaxShotSpeed, entity.TargetPosition:Length() / 20)
				local projectile = entity:FireProjectilesEx(pos, entity.TargetPosition:Resized(speed), ProjectileMode.SINGLE, params)[1]
				projectile.PositionOffset = Vector(0, nullOffset.Y)
				projectile:Update()


				-- Effects
				mod:PlaySoundCool(entity, SoundEffect.SOUND_BOSS_LITE_GURGLE, 1, 1.03)

				for i = 1, math.random(3, 4) do
					local multi = math.random(40, 80) / 100
					local angle = math.random(-30, 30)
					local vector = projectile.Velocity:Rotated(angle) * multi

					local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WATER_SPLASH, 1, projectile.Position, vector, entity):ToEffect()
					effect.m_Height = nullOffset.Y - 5
					effect.FallingAcceleration = 1
					effect.FallingSpeed = -math.random(6, 12)

					local effectSprite = effect:GetSprite()
					effectSprite.Color = Color(0.4,0.42,0.25, 1)
					effectSprite.Scale = (1 + math.random()) * Vector.One
					effect:Update()
				end
			end

			if sprite:IsFinished() then
				entity.State = NpcState.STATE_IDLE
			end
		end
	end


	-- Disable default AI
	if entity.FrameCount > 1 then
		return true
	end
end

-- Drop the machine on death
function embryo:Death(entity)
	local nullFrame = entity:GetSprite():GetNullFrame("Machine")

	if nullFrame and nullFrame:IsVisible() then
		local func = function()
			local params = ProjectileParams()
			params.Variant = mod.FF.Blastulation.BloodDonationMachineProjectile
			params.FallingAccelModifier = 1.25
			params.FallingSpeedModifier = -10

			local nullOffset = entity:GetNullOffset("Machine")
			local projectile = entity:FireProjectilesEx(entity.Position,entity.Velocity, ProjectileMode.SINGLE, params)[1]
			projectile.PositionOffset = Vector(0, nullOffset.Y)
			projectile:Update()
		end
		Isaac.CreateTimer(func, 1, 1, false)
	end
end



-- Blood Donation Machine projectile
function mod:BloodDonationMachineProjectileUpdate(projectile)
	local sprite = projectile:GetSprite()
	mod:LoopingAnim(sprite, "Idle")
	mod:FlipTowardsMovement(projectile, sprite)
end
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, mod.BloodDonationMachineProjectileUpdate, mod.FF.Blastulation.BloodDonationMachineProjectile)

function mod:BloodDonationMachineProjectilePop(projectile)
	local spawner = projectile.SpawnerEntity

	-- Explosion + creep
	Game():BombExplosionEffects(projectile.Position, embryo.ExplosionDamage, TearFlags.TEAR_NORMAL, projectile.Color, spawner, 1, true, true, DamageFlag.DAMAGE_EXPLOSION)
	mod:QuickCreep(EffectVariant.CREEP_RED, spawner, projectile.Position, embryo.CreepScale, embryo.CreepDuration)
	Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 4, projectile.Position, Vector.Zero, projectile)

	-- Projectiles
	if spawner and spawner:ToNPC() then
		local params = ProjectileParams()
		params.FallingAccelModifier = 1.5

		for i = 1, embryo.SplatterCount do
			params.FallingSpeedModifier = -mod:Random(10, 25)
			params.Scale = 1 + mod:Random()

			local speed = mod:Random(2, 10)
			local velocity = mod:RandomVector(speed) + projectile.Velocity:Resized(2)
			spawner:ToNPC():FireProjectilesEx(projectile.Position, velocity, ProjectileMode.SINGLE, params)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_DEATH, mod.BloodDonationMachineProjectilePop, mod.FF.Blastulation.BloodDonationMachineProjectile)