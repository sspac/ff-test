local mod = FiendFolio

local embryo = {
	Variant = mod.FF.Blastulation.Steven,

	Cooldown = {15, 45},
	HorizontalSpeed = {3, 6},
	VerticalSpeed = {12, 15},
	Gravity = 1,
}
mod:AddEmbryo(embryo)



function embryo:Init(entity)
	entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_SPIKE_DAMAGE)
	entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	entity.SplatColor = Color(0,0,0, 1)
	entity.ProjectileCooldown = mod:Random(embryo.Cooldown[1], embryo.Cooldown[2])

	-- Reverse gravity if spawned in the upper half of the room
	if entity.SubType == 0 and entity.Position.Y < mod:GetRoomCenter().Y then
		entity.SubType = 1
	end
end

function embryo:Update(entity)
	local sprite = entity:GetSprite()
	local room = Game():GetRoom()


	-- Set the gravity direction
	local gravityMulti = mod:GetSign(entity.SubType % 2 == 0)
	sprite.FlipY = gravityMulti == -1

	-- Get the attach position
	local xOffset = entity.Size * entity.SizeMulti.X * 0.8
	local attachDistance = entity.Size * entity.SizeMulti.Y
	local attachPos = nil

	for i = -1, 1 do
		local startPos = entity.Position + Vector(i * xOffset, 0)
		local testPos = room:GetLaserTarget(startPos, Vector(0, gravityMulti))

		if testPos:Distance(entity.Position) <= attachDistance + 1 then
			attachPos = testPos - Vector(i * xOffset, gravityMulti * attachDistance)
			break
		end
	end

	-- Fall if it's not attached to a valid position
	local function checkDetach()
		if not attachPos then
			entity.State = NpcState.STATE_JUMP
			sprite:Play("JumpDown", true)
		end
	end



	--[[ Idle ]]--
	if entity.State == NpcState.STATE_IDLE then
		entity.Velocity = mod:StopLerp(entity.Velocity)
		mod:LoopingAnim(sprite, "Idle")
		checkDetach()

		if entity.ProjectileCooldown <= 0 then
			entity.State = NpcState.STATE_ATTACK
			sprite:Play("JumpUp", true)
		else
			entity.ProjectileCooldown = entity.ProjectileCooldown - 1
		end



	--[[ Preparing ]]--
	elseif entity.State == NpcState.STATE_ATTACK then
		entity.Velocity = mod:StopLerp(entity.Velocity)
		checkDetach()

		if sprite:IsEventTriggered("Jump") then
			entity.State = NpcState.STATE_JUMP
			entity.StateFrame = 2

			-- Get the horizontal direction
			local target = entity:GetPlayerTarget()
			local direction = mod:GetSign(target.Position.X > entity.Position.X)

			if not mod:IsCharmedCool(entity) then
				if mod:isScare(entity) then
					direction = -direction
				else
					direction = mod:RandomSign()
				end
			end

			-- Set the velocity
			local xSpeed = direction * mod:Random(embryo.HorizontalSpeed[1], embryo.HorizontalSpeed[2])
			local ySpeed = -gravityMulti * mod:Random(embryo.VerticalSpeed[1], embryo.VerticalSpeed[2])
			entity.Velocity = Vector(xSpeed, ySpeed)
		end



	--[[ Jumping ]]--
	elseif entity.State == NpcState.STATE_JUMP then
		-- Start the falling animation
		if sprite:GetAnimation() ~= "JumpDown"
		and ((gravityMulti ==  1 and entity.Velocity.Y > 0)
		  or (gravityMulti == -1 and entity.Velocity.Y < 0)) then
			sprite:Play("JumpDown", true)
		end
		mod:FlipTowardsMovement(entity, sprite)

		-- Update the "height"
		local gravity = gravityMulti * embryo.Gravity
		entity.Velocity = entity.Velocity + Vector(0, gravity)

		-- Land
		entity.StateFrame = entity.StateFrame - 1

		if attachPos and entity.StateFrame <= 0 then
			entity.State = NpcState.STATE_STOMP
			sprite:Play("Land", true)
			entity.Position = attachPos + Vector(entity.Velocity.X, 0)
			entity.Velocity = Vector.Zero
			mod:PlaySoundCool(nil, SoundEffect.SOUND_GOOATTACH0, 0.6)
		end



	--[[ Landed ]]--
	elseif entity.State == NpcState.STATE_STOMP then
		entity.Velocity = mod:StopLerp(entity.Velocity)
		checkDetach()

		if sprite:IsFinished() then
			entity.State = NpcState.STATE_IDLE
			entity.ProjectileCooldown = mod:Random(embryo.Cooldown[1], embryo.Cooldown[2])
		end
	end


	-- Disable default AI
	if entity.FrameCount > 1 then
		return true
	end
end