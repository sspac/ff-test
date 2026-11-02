local mod = FiendFolio

local embryo = {
	Variant = mod.FF.Blastulation.Mr.Variant,

	MoveSpeed = 4.25,
	SpawnDelay = 30,
	AttackDistance = 120,
	JumpSpeed = 10,
	Gravity = 1.5,
}
mod:AddEmbryo(embryo)

-- Spawn a Gusher with the unique colors
function embryo:SpawnGusher(entity)
	local gusher = Isaac.Spawn(EntityType.ENTITY_GUSHER, 0, 0, entity.Position, entity.Velocity, entity)
	gusher:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	gusher:GetSprite():ReplaceSpritesheet(0, "gfx/enemies/blastulation/mr_gusher.png", true)
end



function embryo:Update(entity)
	local sprite = entity:GetSprite()
	local cancelUpdate = true


	--[[ On body ]]--
	if entity.SubType == mod.FF.Blastulation.Mr.SubTypes.Attached then
		local target = entity:GetPlayerTarget()
		local vector = target.Position - entity.Position


		-- Chasing
		if entity.State == NpcState.STATE_IDLE then
			mod:ChasePlayerCool(entity, embryo.MoveSpeed)
			entity:AnimWalkFrame("WalkHori", "WalkVert", 0.1)

			if entity.FrameCount >= embryo.SpawnDelay -- Spawn delay
			and (not target:ToPlayer() or not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)) -- The target isn't a player if friendly
			and vector:Length() <= embryo.AttackDistance then -- Close enough to the target
				entity.State = NpcState.STATE_JUMP
				sprite:Play("Jump", true)
			end


		-- Detaching
		elseif entity.State == NpcState.STATE_JUMP then
			entity.Velocity = mod:StopLerp(entity.Velocity)
			mod:FlipTowardsTarget(entity, sprite)

			if sprite:IsFinished() then
				embryo:SpawnGusher(entity)

				-- Effects
				mod:PlaySoundCool(nil, SoundEffect.SOUND_DEATH_BURST_SMALL)
				mod:PlaySoundCool(nil, SoundEffect.SOUND_MEATHEADSHOOT)

				local velocity = vector:Resized(embryo.JumpSpeed / 3)
				local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 2, entity.Position, velocity, entity)
				effect:GetSprite().Offset = sprite:GetNullFrame("ShootPos"):GetPos()
				effect.Color = entity.SplatColor

				-- Turn into the detached version
				entity.Velocity = vector:Resized(embryo.JumpSpeed)
				entity.PositionOffset = entity:GetNullOffset("ShootPos")
				entity.TargetPosition = Vector(0, -embryo.JumpSpeed)

				entity:Morph(entity.Type, entity.Variant, mod.FF.Blastulation.Mr.SubTypes.Detached, -1)
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			end
		end



	--[[ Detached ]]--
	elseif entity.SubType == mod.FF.Blastulation.Mr.SubTypes.Detached then
		-- Midair
		if entity.State == NpcState.STATE_JUMP then
			mod:LoopingAnim(sprite, "Midair")
			mod:FlipTowardsMovement(entity, sprite)
			sprite.PlaybackSpeed = mod:ClampNumber(entity.Velocity:Length() * 0.16, 0.5, 2)

			-- Update height
			entity.TargetPosition = entity.TargetPosition + Vector(0, embryo.Gravity)
			entity.PositionOffset = entity.PositionOffset + Vector(0, entity.TargetPosition.Y)

			-- Land
			if entity.PositionOffset.Y >= -8 then
				entity.State = NpcState.STATE_STOMP
				sprite:Play("Land", true)
				mod:PlaySoundCool(nil, SoundEffect.SOUND_GOOATTACH0, 0.6)

				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
				entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
				entity.PositionOffset = Vector.Zero
				sprite.PlaybackSpeed = 1
			end


		-- Act like a regular Embryo after landing
		elseif entity.State == NpcState.STATE_STOMP then
			entity.Velocity = mod:StopLerp(entity.Velocity)

			if sprite:IsFinished() then
				entity.State = NpcState.STATE_IDLE
			end

		else
			cancelUpdate = false
		end
	end


	-- Disable default AI
	if cancelUpdate and entity.FrameCount > 1 then
		return true
	end
end

-- Spawn a Gusher if it dies before the Embryo detaches
function embryo:Death(entity)
	if entity.SubType == mod.FF.Blastulation.Mr.SubTypes.Attached then
		embryo:SpawnGusher(entity)
	end
end