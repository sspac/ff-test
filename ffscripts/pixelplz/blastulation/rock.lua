local mod = FiendFolio

local embryo = {
	Variant = mod.FF.Blastulation.Rock.Variant,

	RockSpeed = 2.5,
	CoalSpeed = 3.5,
	CoalCount = 3,
}
mod:AddEmbryo(embryo)



-- Splat color
function embryo:Init(entity)
	if entity.SubType == mod.FF.Blastulation.Rock.SubTypes.Coal then
		entity.SplatColor = Color.EmberFade
	else
		entity.SplatColor = Color(0,0,0, 1, 0.12,0.09,0.07)
	end
end

function embryo:Update(entity)
	local sprite = entity:GetSprite()
	local isCoal = entity.SubType == mod.FF.Blastulation.Rock.SubTypes.Coal


	-- Movement
	if sprite:WasEventTriggered("Landed") then
		entity.Velocity = mod:StopLerp(entity.Velocity)
	else
		local speed = isCoal and embryo.CoalSpeed or embryo.RockSpeed
		mod:WanderAroundCool(entity, speed)
		mod:FlipTowardsMovement(entity, sprite)
	end

	-- Landed
	if sprite:IsEventTriggered("Landed") then
		entity.Velocity = Vector.Zero
		mod:PlaySoundCool(nil, SoundEffect.SOUND_STONE_IMPACT, 0.7, math.random(100, 110) / 100)
	end


	-- Embers
	if isCoal and entity:IsFrame(math.random(4, 6), 0) then
		local distance = math.random(0, entity.Size)
		local pos = entity.Position + mod:RandomVector(distance)
		local angle = math.random(-30, 30)
		local velocity = -entity.Velocity:Rotated(angle) / 2

		local ember = Isaac.Spawn(1000, EffectVariant.EMBER_PARTICLE, 0, pos, velocity, entity)
		ember.SpriteOffset = Vector(0, -15)
	end


	-- Disable default AI
	if entity.FrameCount > 1 then
		mod:LoopingAnim(sprite, "Walk Sad")
		return true
	end
end

-- Turn into coal embryos when ignited
function embryo:DMG(entity, damageAmount, damageFlags, damageSource, damageCountdownFrames)
	if damageFlags & DamageFlag.DAMAGE_FIRE > 0 then
		if entity.SubType == mod.FF.Blastulation.Rock.SubTypes.Rock and not Game():GetRoom():HasWater() then
			entity:Morph(entity.Type, entity.Variant, mod.FF.Blastulation.Rock.SubTypes.Coal, -1)
			entity.SplatColor = Color.EmberFade
		end

		return false
	end
end

function embryo:Death(entity)
	-- Turn into coals
	if entity.SubType == mod.FF.Blastulation.Rock.SubTypes.Coal then
		local offset = mod:Random(359)
		local baseAngle = 360 / embryo.CoalCount

		for i = 1, 3 do
			local angle = offset + (i * baseAngle)
			local speed = mod:Random(60, 120) / 10
			local velocity = Vector.FromAngle(angle):Resized(speed)
			local spawn = Isaac.Spawn(EntityType.ENTITY_FIREPLACE, 11, 0, entity.Position, velocity, entity)
			spawn:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		end

	-- Turn into a regular embryo
	else
		local spawn = Isaac.Spawn(EntityType.ENTITY_EMBRYO, 0, 0, entity.Position, entity.Velocity, entity)
		spawn:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	end
end