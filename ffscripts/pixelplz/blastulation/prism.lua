local mod = FiendFolio

local embryo = {
	Variant = mod.FF.Blastulation.Prism,

	MoveSpeed = 3,

	ExtraAmount = 3,
	Colors = {
		Color(1,1,1, 1, 0.6,-0.4,-0.4),  -- Red
		Color(1,1,1, 1, 0.54,0.6,-0.4),  -- Yellow
		Color(1,1,1, 1, -0.4,0.6,-0.26), -- Green
		Color(1,1,1, 1, -0.4,0.4,0.6),   -- Blue
	},
}
mod:AddEmbryo(embryo)



function embryo:Init(entity)
	entity:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
end

function embryo:Update(entity)
	local sprite = entity:GetSprite()


	-- Movement
	if sprite:WasEventTriggered("Landed") then
		entity.Velocity = mod:StopLerp(entity.Velocity)
	else
		mod:WanderAroundCool(entity, embryo.MoveSpeed, true)
		mod:FlipTowardsMovement(entity, sprite)
	end

	-- Landed
	if sprite:IsEventTriggered("Landed") then
		entity.Velocity = Vector.Zero
		mod:PlaySoundCool(nil, SoundEffect.SOUND_URN_CLOSE, 0.75)
	end


	-- Duplicate projectiles that pass through it
	local friendly = entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)
	local capsule = entity:GetCollisionCapsule()
	local projectiles = Isaac.FindInCapsule(capsule, EntityPartition.BULLET)

	for i, projectile in pairs(projectiles) do
		local data = mod:GetEntityData(projectile)

		if (not friendly or (projectile.SpawnerEntity and friendly == projectile.SpawnerEntity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)))
		and not data.PrismEmbryo and (not EvenPlayfield or not EvenPlayfield:GetData(projectile).AngelicPrism) then
			local originalVelocity = projectile.Velocity
			local baseAngle = 45 / (1 + embryo.ExtraAmount) * 2

			for j = 0, embryo.ExtraAmount do
				local multi = j - (embryo.ExtraAmount / 2)
				local velocity = originalVelocity:Rotated(baseAngle * multi)
				local color = embryo.Colors[j + 1]

				-- Set the original projectile's velocity and color
				if j == 0 then
					projectile.Velocity = velocity
					projectile.Color = projectile.Color * color
					data.PrismEmbryo = true

					if EvenPlayfield then
						EvenPlayfield:GetData(projectile).AngelicPrism = true
					end

				-- Create the new projectiles
				else
					projectile = projectile:ToProjectile()

					local new = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, projectile.Variant, projectile.SubType, projectile.Position, velocity, projectile.SpawnerEntity):ToProjectile()
					new.Color = new.Color * color
					new.Scale = projectile.Scale
					new.Height = projectile.Height
					new.FallingAccel = projectile.FallingAccel
					new.FallingSpeed = projectile.FallingSpeed
					new.ProjectileFlags = projectile.ProjectileFlags
					mod:GetEntityData(new).PrismEmbryo = true

					if EvenPlayfield then
						EvenPlayfield:GetData(new).AngelicPrism = true
					end
					new:Update()
				end
			end
		end
	end


	-- Disable default AI
	if entity.FrameCount > 1 then
		mod:LoopingAnim(sprite, "Walk Sad")
		return true
	end
end

function embryo:Death(entity)
	mod:PlaySoundCool(nil, SoundEffect.SOUND_GLASS_BREAK, 0.75, math.random(95, 105) / 100)

	-- Flash
	local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.IMPACT, 0, entity.Position, Vector.Zero, entity)
	effect:GetSprite().Offset = Vector(0, -10)

	-- Glass gibs
	for i = 1, 4 do
		local speed = math.random(3, 5)
		local vector = mod:RandomVector(speed)
		local gib = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CHAIN_GIB, 0, entity.Position, vector, entity):ToEffect()
		gib.m_Height = -10
		gib:GetSprite():ReplaceSpritesheet(0, "gfx/enemies/blastulation/prism_gibs.png", true)
		gib:Update()
	end
end



-- Duplicate tears that collide with it
function mod:PrismEmbryoTearCollision(tear, target, bool)
	if target.Type == EntityType.ENTITY_EMBRYO and target.Variant == embryo.Variant
	and target:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and not tear:IsPrismTouched() then
		local originalVelocity = tear.Velocity
		local baseAngle = 45 / (1 + embryo.ExtraAmount) * 2

		for j = 0, embryo.ExtraAmount do
			local multi = j - (embryo.ExtraAmount / 2)
			local velocity = originalVelocity:Rotated(baseAngle * multi)
			local color = embryo.Colors[j + 1]

			-- Set the original tear's velocity and color
			if j == 0 then
				tear.Velocity = velocity
				tear.Color = tear.Color * color
				tear:SetPrismTouched(true)

			-- Stupid hacky way to duplicate tears
			else
				local new = tear:MakeMultidimensionalCopy()
				new:SetMultidimensionalTouched(false)
				new:SetPrismTouched(true)
				new:ChangeVariant(tear.Variant)

				new.Velocity = velocity
				new.Color = new.Color * color

				new.SpawnerEntity = tear.SpawnerEntity
				new.SpawnerType = tear.SpawnerType
				new.SpawnerVariant = tear.SpawnerVariant
			end
		end

		return true
	end
end