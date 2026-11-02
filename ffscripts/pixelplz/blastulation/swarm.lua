local mod = FiendFolio

local embryo = {
	Variant = mod.FF.Blastulation.Swarm,

	DefaultAmount = 4,
	MoveSpeed = 4,
}
mod:AddEmbryo(embryo)



-- Spawn the extra copies
function embryo:Init(entity)
	local amount = entity.SubType == 0 and embryo.DefaultAmount or entity.SubType

	for i = 1, amount - 1 do
		local distance = (1 + mod:Random()) * entity.Size
		local pos = entity.Position + mod:RandomVector(distance)
		Isaac.Spawn(entity.Type, entity.Variant, 1, pos, Vector.Zero, entity)
	end
end

function embryo:Update(entity)
	local sprite = entity:GetSprite()


	-- Movement
	if sprite:WasEventTriggered("Landed") then
		entity.Velocity = mod:StopLerp(entity.Velocity)
	else
		local wander = entity.StateFrame == 1
		mod:WanderAroundCool(entity, embryo.MoveSpeed, wander)
		mod:FlipTowardsMovement(entity, sprite)
	end

	-- Landed
	if sprite:IsEventTriggered("Landed") then
		entity.Velocity = Vector.Zero
		entity.StateFrame = mod:Random(2)
		mod:PlaySoundCool(nil, SoundEffect.SOUND_GOOATTACH0, 0.4, 1.05)
	end


	-- Set the color
	local animData = sprite:GetAnimationData("Blinking")
	local blinkFrame = entity.FrameCount % animData:GetLength()
	local color = animData:GetLayer(0):GetFrame(blinkFrame):GetColor()
	sprite:GetLayer("body"):SetColor(color)


	-- Disable default AI
	if entity.FrameCount > 1 then
		mod:LoopingAnim(sprite, "Walk Sad")
		return true
	end
end