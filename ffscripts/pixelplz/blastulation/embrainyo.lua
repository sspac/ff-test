local mod = FiendFolio

local embryo = {
	Variant = mod.FF.Blastulation.Embrainyo,
	Special = true,

	MoveSpeed = 3,
	Radius = 60,
}
mod:AddEmbryo(embryo)



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
		mod:PlaySoundCool(nil, SoundEffect.SOUND_GOOATTACH0, 0.6)
	end


	-- Turn nearby tears / projectiles homing
	if entity.State == NpcState.STATE_IDLE then
		local friendly = entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)
		local partitions = EntityPartition.BULLET | EntityPartition.TEAR
		local colliders = Isaac.FindInRadius(entity.Position, embryo.Radius, partitions)

		for i, collider in pairs(colliders) do
			local tear = collider:ToTear()
			local projectile = collider:ToProjectile()

			-- Tears
			if tear and friendly
			and not tear:HasTearFlags(TearFlags.TEAR_HOMING)
			and not tear:HasTearFlags(TearFlags.TEAR_BELIAL) then
				tear:AddTearFlags(TearFlags.TEAR_HOMING)
				tear.Color = Color.TearHoming

			-- Projectiles
			elseif projectile
			and (not friendly or (projectile.SpawnerEntity and friendly == projectile.SpawnerEntity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)))
			and not projectile:HasProjectileFlags(ProjectileFlags.SMART)
			and not projectile:HasProjectileFlags(ProjectileFlags.SMART_PERFECT) then
				projectile:AddProjectileFlags(ProjectileFlags.SMART)
			end
		end


		-- Create the aura if it doesn't exist
		if not entity.Child then
			local aura = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HALO, 3, entity.Position, Vector.Zero, entity):ToEffect()
			aura.Parent = entity
			aura:FollowParent(entity)
			aura.DepthOffset = -1000

			-- Set the sprite
			local auraSprite = aura:GetSprite()
			auraSprite:Load("gfx/enemies/blastulation/homing_aura.anm2", true)
			auraSprite:Play("Idle", true)
			auraSprite:GetLayer(0):GetBlendMode():SetMode(BlendType.NORMAL)

			entity.Child = aura
		end

		-- Set the aura scale
		local scale = (embryo.Radius / 50) * 0.65
		entity.Child:GetSprite().Scale = Vector.One * scale
	end


	-- Disable default AI
	if entity.FrameCount > 1 then
		mod:LoopingAnim(sprite, "Walk Sad")
		return true
	end
end