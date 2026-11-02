local mod = FiendFolio

local embryo = {
	Variant = mod.FF.Blastulation.Grudge,
	Special = true,

	MoveSpeed = 3,
	ChargeSpeed = 15,

	DragAngleThreshold = 80,
	DragDamage = 5,
	DragDamageCooldown = 10,
	CrushDamage = 80,
}
mod:AddEmbryo(embryo)



function embryo:Init(entity)
	entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_BLOOD_SPLASH)
end

function embryo:Update(entity)
	local sprite = entity:GetSprite()
	local data = mod:GetEntityData(entity)
	local target = entity:GetPlayerTarget()


	--[[ Hopping ]]--
	if entity.State == NpcState.STATE_IDLE then
		mod:LoopingAnim(sprite, "Walk Sad")

		-- Movement
		if sprite:WasEventTriggered("Landed") then
			entity.Velocity = mod:StopLerp(entity.Velocity)
		else
			mod:WanderAroundCool(entity, embryo.MoveSpeed)
			mod:FlipTowardsMovement(entity, sprite)
		end

		-- Start sliding
		if sprite:IsEventTriggered("Landed") then
			entity.State = NpcState.STATE_MOVE
			data.Dragged = {}
			mod:PlaySoundCool(nil, SoundEffect.SOUND_STONE_IMPACT, 0.6, 1.05)

			-- Get the direction
			if entity.Velocity:Length() >= 0.1 then
				entity.TargetPosition = entity.Velocity
			else
				entity.TargetPosition = target.Position - entity.Position
			end
			entity.TargetPosition = mod:ClampVector(entity.TargetPosition, 15)
		end



	--[[ Sliding ]]--
	elseif entity.State == NpcState.STATE_MOVE then
		local velocity = entity.TargetPosition:Resized(embryo.ChargeSpeed)
		entity.Velocity = mod:Lerp(entity.Velocity, velocity, 0.25)

		if not sprite:IsPlaying("Walk Sad") then
			mod:LoopingAnim(sprite, "Sliding")
		end


		-- Dust trail
		if entity:IsFrame(3, 0) then
			local angle = math.random(-30, 30)
			local vector = entity.Velocity:Rotated(angle) / 10
			mod:SpawnDust(entity.Position, vector, 0.5, Color(0.45,0.45,0.45, 0.5))
		end


		-- Update the dragged enemies
		for i = #data.Dragged, 1, -1 do
			local entry = data.Dragged[i]
			local distance = entity.Size + entry.Size - 1

			-- Stop dragging them if they're too far or intangible
			if entry.Position:Distance(entity.Position) >= distance + 20
			or entry.EntityCollisionClass == EntityCollisionClass.ENTCOLL_NONE then
				table.remove(data.Dragged, i)
				mod:GetEntityData(entry).GrudgeEmbryoDragged = nil

			-- Set their position
			else
				entry.Position = entity.Position + entity.Velocity:Resized(distance)
				entry.Velocity = entity.Velocity
			end
		end


		-- Stop when hitting a wall
		if entity:CollidesWithGrid() or data.ShouldStop then
			entity.State = NpcState.STATE_STOMP
			sprite:Play("Stop", true)
			entity.Velocity = Vector.Zero
			data.ShouldStop = nil

			for i, entry in pairs(data.Dragged) do
				mod:GetEntityData(entry).GrudgeEmbryoDragged = nil

				-- Explode dragged bombs
				if entry:ToBomb() then
					entry:ToBomb():SetExplosionCountdown(0)

				-- Damage dragged enemies
				else
					entry:TakeDamage(embryo.CrushDamage, DamageFlag.DAMAGE_CRUSH, EntityRef(entity), 0)
					entry:AddEntityFlags(EntityFlag.FLAG_EXTRA_GORE)
				end
			end

			-- Effects
			Game():ShakeScreen(4)
			mod:PlaySoundCool(nil, SoundEffect.SOUND_STONE_IMPACT, 0.8, 0.95)

		else
			mod:FlipTowardsMovement(entity, sprite)
		end



	--[[ Stopped ]]--
	elseif entity.State == NpcState.STATE_STOMP then
		entity.Velocity = mod:StopLerp(entity.Velocity)

		if sprite:IsFinished() then
			entity.State = NpcState.STATE_IDLE
		end
	end



	-- Look at its target
	local vector = (target.Position - entity.Position):Normalized()
	local multi = -mod:GetSign(sprite.FlipX)
	sprite:GetLayer("pupil"):SetPos(vector * Vector(multi, 1))


	-- Disable default AI
	if entity.FrameCount > 1 then
		return true
	end
end

function embryo:Collision(entity, target, bool)
	if target:ToNPC() then
		local friendly = entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)

		-- Uncharmed collision damage
		if not entity:HasEntityFlags(EntityFlag.FLAG_CHARM) then
			target:TakeDamage(embryo.DragDamage, DamageFlag.DAMAGE_COUNTDOWN, EntityRef(entity), embryo.DragDamageCooldown)
		end


		-- Ignore physical collision with dragged enemies
		if mod:GetEntityData(target).GrudgeEmbryoDragged then
			return { Collide = false, }

		elseif entity.State == NpcState.STATE_MOVE
		and (not friendly or friendly ~= target:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)) then
			local data = mod:GetEntityData(entity)

			-- Stop if it slides into another Grudge
			if target.Type == EntityType.ENTITY_GRUDGE
			or (target.Type == entity.Type and target.Variant == entity.Variant) then
				data.ShouldStop = true


			-- Drag along enemies if they can take knockback
			elseif not entity:HasEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK) and target.Mass < 100 then
				local collisionAngle = target.Position - entity.Position
				local angleDifference = mod:GetAngleDifferenceDead(entity.Velocity, collisionAngle)

				if angleDifference <= embryo.DragAngleThreshold then
					table.insert(data.Dragged, target)
					mod:GetEntityData(target).GrudgeEmbryoDragged = true
				end
			end
		end
	end
end

function embryo:DMG(entity, damageAmount, damageFlags, damageSource, damageCountdownFrames)
	-- Don't take damage from its besties
	if damageSource.Type == EntityType.ENTITY_GRUDGE
	or (damageSource.Type == entity.Type and damageSource.Variant == entity.Variant) then
		return false

	-- Don't take damage from enemies it's dragging
	elseif entity.State == NpcState.STATE_MOVE
	and damageSource.Entity and mod:GetEntityData(damageSource.Entity).GrudgeEmbryoDragged then
		return false
	end
end