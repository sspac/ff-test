local mod = FiendFolio

local embryo = {
	Variant = mod.FF.Blastulation.Dr,
	Special = true,

	MoveSpeed = 3,
	Cooldown = {3, 6},
	MarkerDuration = 45,
	LaunchTime = 10,
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
			mod:AvoidPlayerCool(entity, embryo.MoveSpeed, true)
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
				sprite:Play("Attack", true)
				mod:FlipTowardsTarget(entity, sprite)
			end


		-- Extremely rude gesture
		elseif entity.StateFrame == 1 then
			if sprite:IsEventTriggered("Landed") then
				mod:PlaySoundCool(nil, SoundEffect.SOUND_FETUS_JUMP)

				-- Create the marker
				local target = entity:GetPlayerTarget()
				local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TARGET, 0, target.Position, Vector.Zero, entity):ToEffect()
				effect.Timeout = embryo.MarkerDuration
				effect.DepthOffset = -1000

				-- Schedule the rocket
				local func = function()
					local rocket = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ROCKET, 0, effect.Position, Vector.Zero, entity):ToEffect()
					rocket.Parent = effect
					rocket.PositionOffset = Vector(0, -1000)
					rocket.LifeSpan = embryo.LaunchTime
					rocket.Timeout = embryo.LaunchTime
				end

				local delay = embryo.MarkerDuration - embryo.LaunchTime
				Isaac.CreateTimer(func, delay, 1, false)
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