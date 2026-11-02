local mod = FiendFolio

local embryo = {
	Variant = mod.FF.Blastulation.Embryobot,

	MoveSpeed = 3,
	ExplosionDamage = 20,
	ExplosionScale = 0.65,

	Offset = Vector(0, -10),
	HostileRange = 160,
	FriendlyRange = 240,
	LaserDamage = 5,
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
		mod:PlaySoundCool(nil, SoundEffect.SOUND_POT_BREAK, 0.35, 1.05)
	end


	-- Connect to nearby friends with a laser
	if entity.State == NpcState.STATE_IDLE then
		local nearest

		-- Try to connect to players first if friendly
		if entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
			local nearestPlayer = Game():GetNearestPlayer(entity.Position)

			if nearestPlayer.Position:Distance(entity.Position) <= embryo.FriendlyRange then
				nearest = nearestPlayer
			end
		end

		-- Try to connect to enemies
		if not nearest then
			local nearestDistance = 9999
			local others = Isaac.FindInRadius(entity.Position, embryo.HostileRange, EntityPartition.ENEMY)

			for i, other in pairs(others) do
				local distance = other.Position:Distance(entity.Position)

				if other.Index ~= entity.Index
				and other:ToNPC() and other:IsActiveEnemy(false) -- Is actually an NPC
				and other.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_NONE -- Is tangible
				and entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) == other:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) -- On the same team
				and distance < nearestDistance then
					nearest = other
					nearestDistance = distance
				end
			end
		end


		-- Handle the laser
		if nearest then
			local startPos = entity.Position + entity.PositionOffset
			local targetPos = nearest.Position + nearest.PositionOffset

			-- Get the angle and length
			local angle = (targetPos - startPos):GetAngleDegrees()
			local length = startPos:Distance(targetPos)
			length = math.max(1, length)

			-- Create the laser if it doesn't exist
			if not entity.Child or not entity.Child:Exists() or entity.Child:IsDead() then
				local laser = EntityLaser.ShootAngle(LaserVariant.THIN_RED, startPos, angle, 2, embryo.Offset, entity)
				laser.CollisionDamage = entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and embryo.LaserDamage or 0
				laser.Mass = 0
				laser.DepthOffset = entity.DepthOffset - 10
				entity.Child = laser
			end

			-- Update the laser
			local laser = entity.Child:ToLaser()
			laser.Angle = angle
			laser:SetMaxDistance(length)
			laser:SetTimeout(2)
		end
	end


	-- Disable default AI
	if entity.FrameCount > 1 then
		mod:LoopingAnim(sprite, "Walk Sad")
		return true
	end
end

-- Explode on death
function embryo:Death(entity)
	Game():BombExplosionEffects(entity.Position, embryo.ExplosionDamage, TearFlags.TEAR_NORMAL, entity.Color, entity, embryo.ExplosionScale, true, true, DamageFlag.DAMAGE_EXPLOSION)
	mod:PlaySoundCool(nil, SoundEffect.SOUND_POT_BREAK)

	-- Gibs
	for i = 1, 4 do
		local speed = math.random(3, 5)
		local vector = mod:RandomVector(speed)
		local gib = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ROCK_PARTICLE, 65537, entity.Position, vector, entity):ToEffect()
		gib.m_Height = -10
		gib:Update()
	end
end