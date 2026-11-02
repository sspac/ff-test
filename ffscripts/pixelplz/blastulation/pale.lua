local mod = FiendFolio

local embryo = {
	Variant = mod.FF.Blastulation.Pale.Variant,

	PaleSpeed = 3.5,
	HeadlessSpeed = 2.5,

	ShootDelay = {30, 60},
	SprayCount = 3,
}
mod:AddEmbryo(embryo)



-- Headless cooldown
function embryo:Init(entity)
	if entity.SubType == mod.FF.Blastulation.Pale.SubTypes.Headless then
		entity.ProjectileCooldown = mod:Random(embryo.ShootDelay[1], embryo.ShootDelay[2])
	end
end

function embryo:Update(entity)
	local sprite = entity:GetSprite()


	--[[ Pale ]]--
	if entity.SubType == mod.FF.Blastulation.Pale.SubTypes.Pale then
		-- Movement
		if sprite:WasEventTriggered("Landed") then
			entity.Velocity = mod:StopLerp(entity.Velocity)
		else
			mod:WanderAroundCool(entity, embryo.PaleSpeed)
			mod:FlipTowardsMovement(entity, sprite)
		end

		-- Landed
		if sprite:IsEventTriggered("Landed") then
			entity.Velocity = Vector.Zero
			mod:PlaySoundCool(nil, SoundEffect.SOUND_GOOATTACH0, 0.6)
		end



	--[[ Headless ]]--
	elseif entity.SubType == mod.FF.Blastulation.Pale.SubTypes.Headless then
		-- Movement
		if sprite:WasEventTriggered("Landed") then
			entity.Velocity = mod:StopLerp(entity.Velocity)
		else
			mod:WanderAroundCool(entity, embryo.HeadlessSpeed, true)
			mod:FlipTowardsMovement(entity, sprite)
		end

		-- Landed
		if sprite:IsEventTriggered("Landed") then
			entity.Velocity = Vector.Zero
			mod:PlaySoundCool(nil, SoundEffect.SOUND_GOOATTACH0, 0.4, 1.05)
		end

		-- Projectiles
		if entity.ProjectileCooldown <= 0 then
			local params = ProjectileParams()
			params.FallingAccelModifier = 1.25
			params.HeightModifier = 20

			for i = 1, embryo.SprayCount do
				params.FallingSpeedModifier = -mod:Random(10, 15)
				params.Scale = 0.5 + mod:Random()

				local speed = mod:Random(4, 8)
				local velocity = mod:RandomVector(speed)
				entity:FireProjectilesEx(entity.Position, velocity, ProjectileMode.SINGLE, params)
			end

			mod:PlaySoundCool(nil, SoundEffect.SOUND_BLOODSHOOT, 0.75, 1.05)
			entity.ProjectileCooldown = mod:Random(embryo.ShootDelay[1], embryo.ShootDelay[2])

		else
			entity.ProjectileCooldown = entity.ProjectileCooldown - 1
		end
	end


	-- Disable default AI
	if entity.FrameCount > 1 then
		mod:LoopingAnim(sprite, "Walk Sad")
		return true
	end
end

-- Turn Pale ones into Headless ones
function embryo:Death(entity)
	if entity.SubType == mod.FF.Blastulation.Pale.SubTypes.Pale and mod:Random(1, 2) <= 1 then
		entity:Morph(entity.Type, entity.Variant, mod.FF.Blastulation.Pale.SubTypes.Headless, -1)
		entity.HitPoints = entity.MaxHitPoints
		entity:SetDead(false)
	end
end