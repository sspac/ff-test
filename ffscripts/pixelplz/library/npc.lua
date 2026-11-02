local mod = FiendFolio



-- Check if the given entity is Ultra Greed in his golden statue form
local function isUltraGreedStatue(entity)
	if entity.Type == EntityType.ENTITY_ULTRA_GREED then
		return entity.State >= 9000 or (entity.Variant == 1 and entity.State == NpcState.STATE_SPECIAL)
	end
	return false
end

-- Check if an NPC is tangible and visible
---@param entity Entity The NPC to check.
---@return boolean
function FiendFolio:IsTangible(entity)
	if not entity or not entity:Exists()
	or (entity.State ~= NpcState.STATE_APPEAR and not entity.Visible) or entity.EntityCollisionClass == EntityCollisionClass.ENTCOLL_NONE
	or mod:IsReallyDead(entity) or entity:HasEntityFlags(EntityFlag.FLAG_BOSSDEATH_TRIGGERED) or isUltraGreedStatue(entity) then
		return false
	end
	return true
end



-- Check if the entity is charmed or friendly
---@param entity Entity
---@param ignoreFriendly? boolean
---@return boolean
function FiendFolio:IsCharmedCool(entity, ignoreFriendly)
	if entity:HasEntityFlags(EntityFlag.FLAG_CHARM)
	and (not ignoreFriendly or not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)) then
		return true
	end
	return false
end



-- Chase players
---@param entity EntityNPC
---@param speed number
function FiendFolio:ChasePlayerCool(entity, speed)
	if not mod:IsCharmedCool(entity) then
		-- Run away if feared
		if mod:isScare(entity) then
			return mod:AvoidPlayerCool(entity, speed)

		-- Move randomly if confused
		elseif mod:isConfuse(entity) then
			return mod:WanderAroundCool(entity, speed)
		end
	end

	-- Go towards the target
	local pathfinder = entity:GetPathfinder()
	local target = entity:GetPlayerTarget()
	pathfinder:FindGridPath(target.Position, speed * 0.15, 500, true)
end



-- Wander around randomly
---@param entity EntityNPC
---@param speed number
---@param ignoreFriendly? boolean
---@param fromAvoidMovement? boolean Avoids infinite loops with feared wandering movement.
function FiendFolio:WanderAroundCool(entity, speed, ignoreFriendly, fromAvoidMovement)
	-- Chase if charmed
	if mod:IsCharmedCool(entity, ignoreFriendly) then
		mod:ChasePlayerCool(entity, speed)

	-- Run away if feared
	elseif mod:isScare(entity) and not fromAvoidMovement then
		mod:AvoidPlayerCool(entity, speed, ignoreFriendly)


	else
		local data = mod:GetEntityData(entity)

		-- Get the direction to move in and for how long
		if not data.WanderData or data.WanderData.Timer <= 0 then
			data.WanderData = { Vector = mod:RandomVector(), Timer = mod:Random(15, 45), }
		end

		-- Turn around when colliding with an obstacle
		if entity:CollidesWithGrid() then
			data.WanderData.Vector = entity.Velocity:Normalized()
		end

		local velocity = data.WanderData.Vector:Resized(speed)
		entity.Velocity = mod:Lerp(entity.Velocity, velocity, 0.25)

		data.WanderData.Timer = data.WanderData.Timer - 1
	end
end



-- Run away from players
---@param entity EntityNPC
---@param speed number
---@param ignoreFriendly? boolean
function FiendFolio:AvoidPlayerCool(entity, speed, ignoreFriendly)
	-- Chase if charmed
	if mod:IsCharmedCool(entity, ignoreFriendly) then
		mod:ChasePlayerCool(entity, speed)


	else
		local data = mod:GetEntityData(entity)
		local target = entity:GetPlayerTarget()
		local radius = 160
		local hasNearby = target.Position:Distance(entity.Position) <= radius

		-- Wander around if safe / confused
		if not hasNearby
		or (mod:isConfuse(entity) and not mod:isScare(entity)) then
			mod:WanderAroundCool(entity, speed, ignoreFriendly, true)
			data.CorneredTimer = nil
			data.EscapePos = nil


		else
			local room = Game():GetRoom()
			local lineCheckMode = entity:IsFlying() and LineCheckMode.EXPLOSION or LineCheckMode.ENTITY

			-- Trying to escape
			if data.EscapePos then
				local velocity = (data.EscapePos - entity.Position):Resized(speed)
				entity.Velocity = mod:Lerp(entity.Velocity, velocity, 0.25)

				-- Stop escaping
				if entity.Position:Distance(data.EscapePos) <= entity.Size
				or not room:CheckLine(entity.Position, data.EscapePos, lineCheckMode) then
					data.CorneredTimer = nil
					data.EscapePos = nil
				end


			-- Running away
			else
				local avoidVector = entity.Position - target.Position
				local targetPos = entity.Position + avoidVector:Resized(entity.Size + 10)
				local velocity = (targetPos - entity.Position):Resized(speed)
				entity.Velocity = mod:Lerp(entity.Velocity, velocity, 0.25)

				-- Cornered
				if not room:CheckLine(entity.Position, targetPos, lineCheckMode) then
					data.CorneredTimer = data.CorneredTimer or 0
					data.CorneredTimer = data.CorneredTimer + 1

					-- Try to escape
					if data.CorneredTimer >= 10 then
						local angle = mod:RandomSign() * mod:Random(30, 60)
						data.EscapePos = entity.Position + -avoidVector:Rotated(angle):Resized(radius)
					end

				else
					data.CorneredTimer = nil
				end
			end
		end
	end
end



-- Changes the entity out of its "init" state once the appear animation is finished since NPCs with custom IDs don't automatically do it
---@param entity EntityNPC
---@param changeTo NpcState? Defaults to `NpcState.STATE_IDLE`.
function FiendFolio:ChangeFromInit(entity, changeTo)
	if not entity:GetSprite():IsPlaying("Appear") and entity.State == NpcState.STATE_INIT then
		entity.State = changeTo or NpcState.STATE_IDLE
	end
end