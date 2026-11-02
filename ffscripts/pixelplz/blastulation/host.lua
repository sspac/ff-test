local mod = FiendFolio

local embryo = {
	Variant = mod.FF.Blastulation.Host.Variant,

	PancakeDuration = 2.5 * 30,
}
mod:AddEmbryo(embryo)



function embryo:Update(entity)
	local sprite = entity:GetSprite()

	-- Awesome sounds
	if sprite:IsEventTriggered("Vulnerable") then
		mod:PlaySoundCool(nil, SoundEffect.SOUND_ANIMAL_SQUISH, 0.7, 1.05)
	end

	-- Pancake mode
	if entity.State == NpcState.STATE_STOMP then
		entity.Velocity = mod:StopLerp(entity.Velocity, 0.2)
		mod:LoopingAnim(sprite, "Bombed")

		if entity.StateFrame <= 0 then
			entity.State = NpcState.STATE_IDLE
		else
			entity.StateFrame = entity.StateFrame - 1
		end

		return true
	end
end

-- Only take damage when jumping
function embryo:DMG(entity, damageAmount, damageFlags, damageSource, damageCountdownFrames)
	if entity.SubType == mod.FF.Blastulation.Host.SubTypes.Regular then
		local sprite = entity:GetSprite()

		if not (sprite:WasEventTriggered("Vulnerable") and not sprite:WasEventTriggered("Landed")) then
			-- Get flattened from too much damage
			if damageAmount >= entity.MaxHitPoints then
				entity.State = NpcState.STATE_STOMP
				entity.StateFrame = embryo.PancakeDuration

				-- Sexy Reworked Foes compatibility
				if ReworkedFoes and ReworkedFoes.Config.BreakableHosts then
					entity:Morph(entity.Type, entity.Variant, mod.FF.Blastulation.Host.SubTypes.Red, -1)
					mod:GetEntityData(entity).FutureStageSkinKey = nil
					mod:PlaySoundCool(nil, SoundEffect.SOUND_ROCK_CRUMBLE, 0.9)

					-- Rock particles
					for i = 1, 2 do
						local speed = math.random(2, 4)
						local velocity = mod:RandomVector(speed)
						Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ROCK_PARTICLE, 65537, entity.Position, velocity, entity):Update()
					end

					-- Dust
					local speed = math.random(2, 4)
					local velocity = mod:RandomVector(speed)
					mod:SpawnDust(entity.Position, velocity)
				end
			end

			return false
		end
	end
end