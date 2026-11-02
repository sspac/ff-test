local mod = FiendFolio

local Settings = {
	Cooldown = {90, 150},
	FleeRange = 180,
	MoveSpeed = 7.5,
	AttackRange = 110,
	AttackFailsafeTime = 90,

	ProjectileCount = 3,
	ShotSpeed = 10,
	TargetHeight = -5.5,
	RotationDuration = 150,
	RotationSpeed = 6.5,
	ExpandSpeed = 1.2,
}



function mod:TiyanakInit(entity)
	entity.State = NpcState.STATE_APPEAR_CUSTOM
	entity:GetSprite():Play("Appear", true)
	entity.ProjectileCooldown = mod:Random(Settings.Cooldown[1], Settings.Cooldown[2])
end

function mod:WaitingTiyanakInit(entity)
	entity.State = NpcState.STATE_IDLE
	entity.StateFrame = 0
	entity.ProjectileCooldown = mod:Random(Settings.Cooldown[1], Settings.Cooldown[2])
	entity:Update()
	entity:GetSprite():SetFrame(2)
end

function mod:TiyanakUpdate(entity)
	local sprite = entity:GetSprite()
	local target = entity:GetPlayerTarget()



	--[[ Appearing ]]--
	if entity.State == NpcState.STATE_APPEAR_CUSTOM then
		entity.Velocity = mod:StopLerp(entity.Velocity)

		if sprite:IsFinished() then
			entity.State = NpcState.STATE_IDLE
		end



	--[[ Coward mode ]]--
	elseif entity.State == NpcState.STATE_IDLE then
		-- Observing...
		if entity.StateFrame == 0 then
			entity.Velocity = mod:StopLerp(entity.Velocity)
			mod:LoopingAnim(sprite, "Idle")
			mod:FlipTowardsTarget(entity, sprite)

			if mod:isConfuse(entity) or target.Position:Distance(entity.Position) <= Settings.FleeRange then
				entity.StateFrame = 1
				sprite:Play("IdleStop", true)
			end


		-- Start fleeing
		elseif entity.StateFrame == 1 then
			entity.Velocity = mod:StopLerp(entity.Velocity)
			mod:FlipTowardsTarget(entity, sprite)

			if sprite:IsFinished() then
				entity.StateFrame = 2
				sprite:Play("FleeingStart", true)
			end


		-- Fleeing
		elseif entity.StateFrame == 2 then
			-- Run around randomly if confused
			if mod:isConfuse(entity) then
				mod:WanderAroundCool(entity, Settings.MoveSpeed)
				entity.I1 = 0

			-- Stop fleeing if no longer in range
			elseif target.Position:Distance(entity.Position) > Settings.FleeRange + 10 then
				entity.StateFrame = 3
				sprite:Play("FleeingStop", true)
				entity.I1 = 0


			-- Panic mode
			else
				local room = Game():GetRoom()
				local lineCheckMode = entity:IsFlying() and LineCheckMode.EXPLOSION or LineCheckMode.ENTITY

				-- Trying to escape
				if entity.I1 == 1 then
					local velocity = (entity.TargetPosition - entity.Position):Resized(Settings.MoveSpeed)
					entity.Velocity = mod:Lerp(entity.Velocity, velocity, 0.25)

					-- Stop escaping
					if entity.Position:Distance(entity.TargetPosition) <= entity.Size
					or not room:CheckLine(entity.Position, entity.TargetPosition, lineCheckMode) then
						entity.I1 = 0
					end


				-- Running away
				else
					local avoidVector = entity.Position - target.Position
					local targetPos = entity.Position + avoidVector:Resized(entity.Size + 10)
					local velocity = (targetPos - entity.Position):Resized(Settings.MoveSpeed)
					entity.Velocity = mod:Lerp(entity.Velocity, velocity, 0.25)

					-- Try to escape if cornered
					if not room:CheckLine(entity.Position, targetPos, lineCheckMode) then
						local angle = mod:RandomSign() * mod:Random(30, 60)
						entity.TargetPosition = entity.Position + -avoidVector:Rotated(angle):Resized(Settings.FleeRange)
						entity.I1 = 1
					end
				end
			end


			-- Set the animation
			if not sprite:IsPlaying("FleeingStart") and entity.StateFrame == 2 then
				mod:LoopingAnim(sprite, "Fleeing")
			end
			mod:FlipTowardsMovement(entity, sprite)


		-- Back to idle
		elseif entity.StateFrame == 3 then
			entity.Velocity = mod:StopLerp(entity.Velocity)

			if sprite:IsFinished() then
				entity.StateFrame = 0
			end
		end


		-- Become brave
		if entity.ProjectileCooldown <= 0
		and not mod:isScare(entity) and entity:GetPathfinder():HasPathToPos(target.Position) then
			entity.State = NpcState.STATE_MOVE
			entity.StateFrame = 0
			entity.ProjectileDelay = Settings.AttackFailsafeTime
			entity.I1 = 0

			-- Set the animation if it's not already playing one of the valid ones
			if not sprite:IsPlaying("IdleStop") and not sprite:IsPlaying("FleeingStop") then
				local anim = sprite:IsPlaying("Fleeing") and "Fleeing" or "Idle"
				sprite:Play(anim .. "Stop", true)
			end

			entity.ProjectileCooldown = mod:Random(Settings.Cooldown[1], Settings.Cooldown[2])
		else
			entity.ProjectileCooldown = entity.ProjectileCooldown - 1
		end



	--[[ Brave mode ]]--
	elseif entity.State == NpcState.STATE_MOVE then
		-- Stop if feared
		if mod:isScare(entity) then
			entity.State = NpcState.STATE_IDLE
			entity.StateFrame = 3
			sprite:Play("ChasingStop", true)


		-- Start chasing
		elseif entity.StateFrame == 0 then
			entity.Velocity = mod:StopLerp(entity.Velocity)

			if sprite:IsFinished() then
				entity.StateFrame = 1
				sprite:Play("ChasingStart", true)
				mod:PlaySoundCool(entity, SoundEffect.SOUND_MONSTER_ROAR_0, 0.7, 1.15)
			end


		-- Chasing
		elseif entity.StateFrame == 1 then
			mod:ChasePlayerCool(entity, Settings.MoveSpeed)

			-- Set the animation
			if not sprite:IsPlaying("ChasingStart") then
				local anim = entity.Velocity:Length() >= 0.25 and "Chasing" or "Idle"
				mod:LoopingAnim(sprite, anim)
			end
			mod:FlipTowardsMovement(entity, sprite)


			-- Attac if close enough or if it's been chasing for too long
			if entity.ProjectileDelay <= 0
			or target.Position:Distance(entity.Position) <= Settings.AttackRange then
				entity.State = NpcState.STATE_ATTACK
				entity.StateFrame = 0
				sprite:Play("Shoot", true)
				sprite.FlipX = false
			else
				entity.ProjectileDelay = entity.ProjectileDelay - 1
			end
		end



	--[[ Attacking ]]--
	elseif entity.State == NpcState.STATE_ATTACK then
		entity.Velocity = mod:StopLerp(entity.Velocity)

		if sprite:IsEventTriggered("Shoot") then
			local params = ProjectileParams()
			params.Variant = ProjectileVariant.PROJECTILE_PEEP
			params.Scale = 1.5
			params.BulletFlags = ProjectileFlags.NO_WALL_COLLIDE | ProjectileFlags.DECELERATE
			params.Acceleration = 1.1
			params.HeightModifier = -22

			local velocity = Vector(Settings.ShotSpeed, Settings.ProjectileCount)
			local projectiles = entity:FireProjectilesEx(entity.Position, velocity, ProjectileMode.CIRCLE_CUSTOM, params)


			-- Set the projectiles' sprites and data
			local orbitDirection = mod:RandomSign()

			for i, projectile in pairs(projectiles) do
				local rng = RNG(projectile.InitSeed)

				mod:GetEntityData(projectile).TiyanakProjectile = {
					Activated = false,
					Duration = Settings.RotationDuration,
					Direction = orbitDirection,
					Angle = mod:Random(nil, nil, rng) * 360,
					Distance = 0,
				}

				projectile.FallingSpeed = 2.5
				projectile:GetSprite():ReplaceSpritesheet(0, "gfx/enemies/tiyanak/eyeball_projectile.png", true)
			end


			-- Effects
			mod:PlaySoundCool(entity, mod.Sounds.FlashShakeyKidRoar, 2, 0.9)
			mod:PlaySoundCool(nil, SoundEffect.SOUND_BLOODSHOOT, 0.9, 0.9)

			local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 2, entity.Position, Vector.Zero, entity):ToEffect()
			effect:FollowParent(entity)
			effect.SpriteOffset = sprite:GetNullFrame("ShootPos"):GetPos()
			effect.DepthOffset = entity.DepthOffset + 1

		elseif sprite:IsFinished() then
			entity.State = NpcState.STATE_IDLE
		end
	end


	-- Set the crop offset based on the sprite's direction
	local cropOffsetY = sprite.FlipX and 64 or 0
	sprite:GetLayer("dynamic"):SetCropOffset(Vector(0, cropOffsetY))
end



function mod:TiyanakProjectileUpdate(projectile, data)
	data = data.TiyanakProjectile

	if data then
		-- Orbiting
		if data.Activated then
			local add = Vector.FromAngle(data.Angle):Resized(data.Distance)
			projectile.Velocity = (projectile.TargetPosition + add) - projectile.Position

			-- Advance the pattern
			data.Angle = data.Angle + (Settings.RotationSpeed * data.Direction)
			data.Distance = data.Distance + Settings.ExpandSpeed

			-- Don't fall down
			projectile.Height = Settings.TargetHeight
			projectile.FallingSpeed = 0
			projectile.FallingAccel = 0

			-- Disappear after the delay
			data.Duration = data.Duration - 1

			if data.Duration <= 0 then
				projectile:Die()
			end


		-- Stopping
		else
			projectile.Height = math.min(projectile.Height, Settings.TargetHeight)

			-- Activate when it "lands"
			if projectile.Height == Settings.TargetHeight then
				data.Activated = true
				mod:PlaySoundCool(nil, SoundEffect.SOUND_BLOODSHOOT, 0.75, 1.1, 2)

				projectile.Velocity = Vector.Zero
				projectile.TargetPosition = projectile.Position
				projectile:ClearProjectileFlags(ProjectileFlags.DECELERATE)
				projectile.FallingSpeed = 0
				projectile.FallingAccel = 0

				-- Poof
				local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 5, projectile.Position, Vector.Zero, projectile)
				effect.PositionOffset = projectile.PositionOffset
				effect.Color = projectile.Color

				local sprite = effect:GetSprite()
				sprite.PlaybackSpeed = 1.5
				sprite.Scale = projectile:GetSprite().Scale * 0.75
				sprite.Rotation = projectile.Velocity:GetAngleDegrees() - 90
			end
		end
	end
end