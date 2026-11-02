local mod = FiendFolio

local Settings = {
	Cooldown = {90, 150},
	MinDistance = 6.9 * 40,
	ShotSpeed = 12,
}



function mod:PokiInit(entity)
	if entity.Variant == 0 and entity.SubType == mod.FF.Poki.Sub then
		entity:GetSprite():Play("Wake", true)
		entity.ProjectileCooldown = mod:Random(Settings.Cooldown[1], Settings.Cooldown[2])
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.PokiInit, EntityType.ENTITY_POKY)

function mod:PokiUpdate(entity)
	if entity.Variant == 0 and entity.SubType == mod.FF.Poki.Sub then
		local sprite = entity:GetSprite()

		if sprite:IsEventTriggered("Sound") then
			mod:PlaySoundCool(entity, SoundEffect.SOUND_GOOATTACH0, 0.6)
		end


		-- Blood trail
		local interval = math.random(6, 9)

		if entity:IsFrame(interval, 0) and entity.Velocity:Length() >= 0.1 then
			entity:MakeSplat(entity.Scale * 0.75)
		end


		-- Attacking
		if entity.State == NpcState.STATE_ATTACK5 then
			entity.Velocity = mod:StopLerp(entity.Velocity)

			if sprite:IsEventTriggered("Shoot") then
				local mode = entity.I2 % 2 == 1 and ProjectileMode.CROSS or ProjectileMode.PLUS
				entity:FireProjectiles(entity.Position, Vector(Settings.ShotSpeed, 4), mode, ProjectileParams())
				entity.I2 = entity.I2 + 1

				-- Sounds
				mod:PlaySoundCool(entity, SoundEffect.SOUND_CUTE_GRUNT)

				if SoundEffect.SOUND_LOKI_SHOOT then
					mod:PlaySoundCool(nil, SoundEffect.SOUND_LOKI_SHOOT)
				end

				-- Splish splash
				local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 3, entity.Position, Vector.Zero, entity):ToEffect()
				effect:FollowParent(entity)
				effect.DepthOffset = entity.DepthOffset - 10
			end

			if sprite:IsFinished() then
				entity.State = NpcState.STATE_MOVE
			end


		-- Attack if close enough
		elseif entity.State ~= NpcState.STATE_SPECIAL then
			if entity.ProjectileCooldown <= 0 then
				local nearest = Game():GetNearestPlayer(entity.Position)

				if Game():GetRoom():CheckLine(entity.Position, nearest.Position, LineCheckMode.PROJECTILE)
				and entity.Position:Distance(nearest.Position) <= Settings.MinDistance then
					entity.State = NpcState.STATE_ATTACK5
					sprite:Play("Attack", true)
					entity.ProjectileCooldown = mod:Random(Settings.Cooldown[1], Settings.Cooldown[2])
					entity.I2 = 0
				end

			else
				entity.ProjectileCooldown = entity.ProjectileCooldown - 1
			end
		end


		-- Deactivation animation
		if entity.State == NpcState.STATE_SPECIAL and (entity.I1 == 0 or entity.I1 == 1) then
			entity.Velocity = mod:StopLerp(entity.Velocity)

			-- Start the animation
			if entity.I1 == 0 then
				sprite:Play("Sleep", true)
				entity.I1 = 1

			-- Go back to default behaviour
			elseif sprite:IsFinished() then
				entity.I1 = 2
			end

			return true
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.PokiUpdate, EntityType.ENTITY_POKY)

function mod:PokiKill(entity)
	if entity.Variant == 0 and entity.SubType == mod.FF.Poki.Sub then
		entity:ClearEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
		entity.SplatColor = Color.Default
	end
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.PokiKill, EntityType.ENTITY_POKY)