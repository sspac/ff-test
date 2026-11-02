local mod = FiendFolio

local embryo = {
	Variant = mod.FF.Blastulation.Blastocyst.Variant,

	SmallSpeed = 3.5,
}
mod:AddEmbryo(embryo)



-- Faster movement for Embryo Embryo
function embryo:Update(entity)
	if entity.SubType == mod.FF.Blastulation.Blastocyst.SubTypes.Small then
		local sprite = entity:GetSprite()

		-- Movement
		if sprite:WasEventTriggered("Landed") then
			entity.Velocity = mod:StopLerp(entity.Velocity)
		else
			mod:WanderAroundCool(entity, embryo.SmallSpeed)
			mod:FlipTowardsMovement(entity, sprite)
		end

		-- Landed
		if sprite:IsEventTriggered("Landed") then
			entity.Velocity = Vector.Zero
			mod:PlaySoundCool(nil, SoundEffect.SOUND_GOOATTACH0, 0.4, 1.05)
		end

		-- Disable default AI
		if entity.FrameCount > 1 then
			mod:LoopingAnim(sprite, "Walk Sad")
			return true
		end
	end
end

-- Split into 2 Embryo Embryos
function embryo:Death(entity)
	if entity.SubType == mod.FF.Blastulation.Blastocyst.SubTypes.Big then
		for i = -1, 1, 2 do
			local velocity = entity.Velocity:Rotated(i * 90):Resized(10)
			local spawn = Isaac.Spawn(entity.Type, entity.Variant, mod.FF.Blastulation.Blastocyst.SubTypes.Small, entity.Position, velocity, entity)
			spawn:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		end
	end
end