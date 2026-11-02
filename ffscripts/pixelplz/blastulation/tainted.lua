local mod = FiendFolio

local embryo = {
	Variant = mod.FF.Blastulation.Tainted,
	Special = true,

	MoveSpeed = 2.5,
	LandCreepScale = 1.5,
	CreepDuration = 240,
	LandSplatterCount = 6,
	Cooldown = {3, 6},

	CoinCount = 12,
	CoinDelay = 2,
	ShotSpeed = 10,

	ExplosionDamage = 40,
	DeathCreepScale = 2.5,
	DeathSplatterCount = 10,
}
mod:AddEmbryo(embryo)



function embryo:Init(entity)
	entity.ProjectileCooldown = mod:Random(embryo.Cooldown[1], embryo.Cooldown[2])
	entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
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
			mod:WanderAroundCool(entity, embryo.MoveSpeed)
			mod:FlipTowardsMovement(entity, sprite)
		end

		if sprite:IsEventTriggered("Landed") then
			entity.Velocity = Vector.Zero
			mod:QuickCreep(EffectVariant.CREEP_RED, entity, entity.Position, embryo.LandCreepScale, embryo.CreepDuration)


			-- Projectiles
			local params = ProjectileParams()
			params.FallingAccelModifier = 1.5

			for i = 1, embryo.LandSplatterCount do
				params.FallingSpeedModifier = -mod:Random(10, 15)
				params.Scale = 1 + mod:Random()

				local speed = mod:Random(4, 8)
				entity:FireProjectilesEx(entity.Position, mod:RandomVector(speed), ProjectileMode.SINGLE, params)
			end


			-- Effects
			mod:PlaySoundCool(nil, SoundEffect.SOUND_MEAT_IMPACTS, 1.5)
			mod:PlaySoundCool(nil, SoundEffect.SOUND_POT_BREAK, 0.6)

			local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 4, entity.Position, Vector.Zero, entity):GetSprite()
			effect.Offset = Vector(0, -17)
			effect.Scale = Vector.One * 0.5
			effect.PlaybackSpeed = 1.5


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


		-- Donating blood
		elseif entity.StateFrame == 1 then
			if sprite:IsEventTriggered("Landed") then
				mod:PlaySoundCool(entity, SoundEffect.SOUND_ANGRY_GURGLE)
				mod:PlaySoundCool(nil, SoundEffect.SOUND_BLOODBANK_TOUCHED, 1.5)
			end

			if sprite:IsFinished() then
				entity.StateFrame = 2
				entity.I1 = embryo.CoinDelay
				entity.I2 = embryo.CoinCount + 1
				entity.TargetPosition = Vector(mod:Random(359), mod:RandomSign())
			end


		-- Making it rain
		elseif entity.StateFrame == 2 then
			mod:LoopingAnim(sprite, "AttackLoop")

			if entity.I1 <= 0 then
				entity.I1 = embryo.CoinDelay

				-- Stop
				if entity.I2 <= 0 then
					entity.StateFrame = 3
					sprite:Play("AttackStop", true)

				else
					local params = ProjectileParams()
					params.Variant = ProjectileVariant.PROJECTILE_COIN
					params.Scale = 0.9

					-- Main coins
					local baseAngle = 360 / embryo.CoinCount
					local add = entity.I2 * baseAngle * entity.TargetPosition.Y
					local angle = entity.TargetPosition.X + add
					local velocity = Vector.FromAngle(angle):Resized(embryo.ShotSpeed)
					local projectile = entity:FireProjectilesEx(entity.Position, velocity, ProjectileMode.SINGLE, params)[1]


					-- Extra coins
					if mod:Random(1) == 1 then
						params.FallingAccelModifier = 1.25
						params.FallingSpeedModifier = -mod:Random(15, 20)
						local speed = mod:Random(4, 8)
						entity:FireProjectilesEx(entity.Position, mod:RandomVector(speed), 0, params)
					end


					-- Effects
					mod:PlaySoundCool(nil, SoundEffect.SOUND_BLOODBANK_SPAWN, 1.1, 1, embryo.CoinDelay + 2)

					local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 2, entity.Position, velocity / 2, entity)
					effect.PositionOffset = Vector(0, projectile.Height)

					entity.I2 = entity.I2 - 1
				end

			else
				entity.I1 = entity.I1 - 1
			end


		-- Stopping
		elseif entity.StateFrame == 3 then
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

-- Freakin' explode
function embryo:Death(entity)
	Game():BombExplosionEffects(entity.Position, embryo.ExplosionDamage, TearFlags.TEAR_NORMAL, entity.Color, entity, 1, true, true, DamageFlag.DAMAGE_EXPLOSION)
	mod:QuickCreep(EffectVariant.CREEP_RED, entity, entity.Position, embryo.DeathCreepScale, embryo.CreepDuration)

	-- Projectiles
	local params = ProjectileParams()
	params.FallingAccelModifier = 1.5

	for i = 1, embryo.DeathSplatterCount do
		params.FallingSpeedModifier = -mod:Random(10, 25)
		params.Scale = 1 + mod:Random()

		local speed = mod:Random(4, 12)
		local velocity = mod:RandomVector(speed)
		entity:FireProjectilesEx(entity.Position, velocity, ProjectileMode.SINGLE, params)
	end
end