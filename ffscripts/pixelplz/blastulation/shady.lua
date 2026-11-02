local mod = FiendFolio

local embryo = {
	Variant = mod.FF.Blastulation.Shady,
	Special = true,

	MoveSpeed = 3.5,
	Cooldown = {3, 6},
	JumpDistance = 80,
	JumpSpeed = 12,

	Delay = 7,
	Radius = 60,
	Damage = 30,
}
mod:AddEmbryo(embryo)



function embryo:Init(entity)
	entity.ProjectileCooldown = mod:Random(embryo.Cooldown[1], embryo.Cooldown[2])
	entity.SplatColor = Color(0,0,0, 1)
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
		-- Wait for the current animation to finish
		if entity.StateFrame == 0 then
			entity.Velocity = mod:StopLerp(entity.Velocity)

			if sprite:IsFinished() then
				entity.StateFrame = 1
				sprite:Play("Attack", true)
			end


		elseif entity.StateFrame == 1 then
			-- Jump towards the target
			if sprite:IsEventTriggered("Jump") then
				local target = entity:GetPlayerTarget()
				local pos = entity.Position + (target.Position - entity.Position):Resized(embryo.JumpDistance)
				entity.TargetPosition = Game():GetRoom():FindFreePickupSpawnPosition(pos)
				entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS


			-- Stompy time
			elseif sprite:IsEventTriggered("Landed") then
				entity.Velocity = Vector.Zero
				entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND

				-- Effects
				Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 3, entity.Position, Vector.Zero, entity)
				mod:PlaySoundCool(nil, SoundEffect.SOUND_GOOATTACH0, 0.6)


				-- Create the explosion waves
				local func = function(pos, spawner, timer)
					local friendly = entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)
					local partitions = EntityPartition.FAMILIAR | EntityPartition.ENEMY | EntityPartition.PLAYER
					local colliders = Isaac.FindInRadius(pos, embryo.Radius, partitions)

					for i, collider in pairs(colliders) do
						if collider.EntityCollisionClass >= EntityCollisionClass.ENTCOLL_ENEMIES
						and (not friendly or not collider:HasEntityFlags(EntityFlag.FLAG_FRIENDLY))
						and collider.Index ~= entity.Index then -- Don't kill yourself dummy
							local damage = collider:ToPlayer() and 1 or embryo.Damage
							collider:TakeDamage(damage, DamageFlag.DAMAGE_IGNORE_ARMOR, EntityRef(spawner), 0)
						end
					end

					-- Effects
					local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ENEMY_GHOST, 1, pos, Vector.Zero, spawner)
					effect:GetSprite().Scale = Vector.One * 0.8
					mod:PlaySoundCool(nil, SoundEffect.SOUND_DEMON_HIT, 0.75, 1, 2)
					Game():ShakeScreen(5)
				end

				for i = 1, 4 do
					mod:CreateSpawnWave(func, entity, entity.Position, i * 90, embryo.Radius, embryo.Delay, 2, true)
				end
			end


			-- Movement
			if sprite:WasEventTriggered("Jump") and not sprite:WasEventTriggered("Stop") then
				local targetVector = (entity.TargetPosition - entity.Position) / 5
				entity.Velocity = mod:Lerp(entity.Velocity, targetVector, 0.25)
				mod:FlipTowardsMovement(entity, sprite)
			else
				entity.Velocity = mod:StopLerp(entity.Velocity, 0.5)
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