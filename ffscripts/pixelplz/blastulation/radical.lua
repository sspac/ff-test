local mod = FiendFolio

local embryo = {
	Variant = mod.FF.Blastulation.Radical,

	MoveSpeed = 10,
	Cooldown = {5, 20},

	FlipChance = 25,
	FlipThreshold = {50, 75},

	GrindChance = 25,
	MaxGrindStartDistance = 40,
	GrindSpeed = 4.5,
}
mod:AddEmbryo(embryo)



-- Check if the given index contains a grindable grid
local function checkGrindex(pos)
	local grid = Game():GetRoom():GetGridEntityFromPos(pos)

	return grid -- Has a grid entity
	and (grid.CollisionClass == GridCollisionClass.COLLISION_OBJECT or grid.CollisionClass == GridCollisionClass.COLLISION_SOLID) -- Is solid
	and (not grid:ToPoop() or grid:GetVariant() ~= GridPoopVariant.RED) -- Not a red poop
	and grid:GetType() ~= GridEntityType.GRID_ROCK_SPIKED -- Not a spike rock
end

-- Check if it can continue grinding on the current path
local function checkGrindPath(currentPos, moveDirection, gridSide)
	local gridSideOffset = Vector.FromAngle(gridSide):Resized(40)
	local nextGrindPos

	for i = 0, 1 do
		local distance = i * 30
		local grindPos = currentPos + moveDirection:Resized(distance)
		local potentialWall = grindPos + gridSideOffset

		-- Stop if there are no more grids to grind on or there is something blocking the way
		if not checkGrindex(grindPos) or checkGrindex(potentialWall) then
			return false
		else
			nextGrindPos = grindPos
		end
	end

	return nextGrindPos
end



function embryo:Init(entity)
	entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
	entity.ProjectileCooldown = mod:Random(embryo.Cooldown[1], embryo.Cooldown[2])
end

function embryo:Update(entity)
	local sprite = entity:GetSprite()
	local data = mod:GetEntityData(entity)
	local room = Game():GetRoom()


	--[[ Idle ]]--
	if entity.State == NpcState.STATE_IDLE then
		entity.Velocity = mod:StopLerp(entity.Velocity)

		if not sprite:IsPlaying("Kickflip") then
			mod:LoopingAnim(sprite, "Idle")
		end

		-- Pick the next move
		if entity.ProjectileCooldown <= 0 then
			local grind = mod:Random() < embryo.GrindChance / 100

			-- Try to grind
			if grind then
				local grindSpots = {}

				-- Look for nearby grids
				for i = 0, 7 do
					local testVector = Vector.FromAngle(i * 45):Resized(embryo.MaxGrindStartDistance)
					local grindex = room:GetGridIndex(entity.Position + testVector)
					local gridPos = room:GetGridPosition(grindex) -- Center it on the tile

					-- Valid grid found
					if checkGrindex(gridPos) then
						local closestSide
						local closestDistance = 9999

						-- Get the closest side of the grid
						for j = 0, 3 do
							local sideAngle = j * 90
							local sideOffset = Vector.FromAngle(sideAngle):Resized(20)
							local sideDistance = entity.Position:Distance(gridPos + sideOffset)

							if sideDistance < closestDistance then
								closestSide = sideAngle
								closestDistance = sideDistance
							end
						end

						-- Check both grind directions
						for j = -1, 1, 2 do
							local moveAngle = closestSide + (j * 90)
							local moveDirection = Vector.FromAngle(moveAngle)

							-- Save paths that aren't blocked and are at least 2 tiles long
							if checkGrindPath(gridPos, moveDirection, closestSide) then
								local grindData = {
									TargetPosition = gridPos,
									MoveDirection = moveDirection,
									GrindSide = closestSide,
								}
								table.insert(grindSpots, grindData)
							end
						end
					end
				end


				if #grindSpots > 0 then
					entity.State = NpcState.STATE_JUMP
					sprite:Play("GrindStart", true)

					-- Pick the closest grind path
					table.sort(grindSpots, function(entry1, entry2)
						local distance1 = entry1.TargetPosition:Distance(entity.Position)
						local distance2 = entry2.TargetPosition:Distance(entity.Position)
						return distance1 < distance2
					end)
					local first = grindSpots[1]

					-- Copy its data
					data.Grind = {}

					for i, entry in pairs(first) do
						data.Grind[i] = entry
					end

				else
					grind = false
				end
			end


			-- Default rolling
			if not grind then
				entity.State = NpcState.STATE_MOVE
				sprite:Play("Move", true)
			end

			entity.StateFrame = 0
			entity.ProjectileCooldown = mod:Random(embryo.Cooldown[1], embryo.Cooldown[2])
		else
			entity.ProjectileCooldown = entity.ProjectileCooldown - 1
		end



	--[[ Moving ]]--
	elseif entity.State == NpcState.STATE_MOVE then
		-- Start
		if entity.StateFrame == 0 then
			entity.Velocity = mod:StopLerp(entity.Velocity)

			if sprite:IsEventTriggered("Jump") then
				entity.StateFrame = 1
				mod:PlaySoundCool(nil, SoundEffect.SOUND_FETUS_FEET, 0.9, 1.1)

				-- Get the roll direction
				local target = entity:GetPlayerTarget()
				local targetVector = target.Position - entity.Position

				if not mod:IsCharmedCool(entity) then
					if mod:isScare(entity) then
						targetVector = -targetVector
					else
						targetVector = mod:RandomVector()
					end
				end
				entity.Velocity = targetVector:Resized(embryo.MoveSpeed)

				-- Try to do a sick flip
				if mod:Random() <= embryo.FlipChance / 100 then
					local threshold = mod:Random(embryo.FlipThreshold[1], embryo.FlipThreshold[2])
					data.Flip = embryo.MoveSpeed * (threshold / 100)
				end
			end


		-- Move until its speed becomes too low
		elseif entity.StateFrame == 1 then
			if entity.GridCollisionClass == EntityGridCollisionClass.GRIDCOLL_GROUND then
				entity.Velocity = mod:StopLerp(entity.Velocity, 0.05)

				-- Rolling sound
				local volume = mod:ClampNumber(entity.Velocity:Length() / 10, 0.2, 0.6)

				if not SFXManager():IsPlaying(mod.Sounds.RadicalEmbryoRoll) then
					mod:PlaySoundCool(nil, mod.Sounds.RadicalEmbryoRoll, volume, 1, 0, true)
				end
				SFXManager():AdjustVolume(mod.Sounds.RadicalEmbryoRoll, volume)
			end


			-- Start the animation
			if not sprite:IsPlaying("Move") and not sprite:IsPlaying("Kickflip") then
				mod:LoopingAnim(sprite, "Rolling")
				sprite.PlaybackSpeed = mod:ClampNumber(entity.Velocity:Length() / 5, 0.5, 2)
			end
			mod:FlipTowardsMovement(entity, sprite)


			-- Stop moving
			if entity.Velocity:Length() < 1 then
				entity.State = NpcState.STATE_IDLE
				sprite.PlaybackSpeed = 1
				SFXManager():Stop(mod.Sounds.RadicalEmbryoRoll)

			-- Flippin' awesome
			elseif data.Flip and entity.Velocity:Length() <= data.Flip then
				sprite:Play("Kickflip", true)
				sprite.PlaybackSpeed = 1
				data.Flip = nil
			end
		end



	--[[ Grinding of Isaac ]]--
	elseif entity.State == NpcState.STATE_JUMP then
		-- Jump on the grid
		if entity.StateFrame == 0 then
			local hasGrid = checkGrindex(data.Grind.TargetPosition)

			-- Move to the grid
			if hasGrid and sprite:WasEventTriggered("Jump") then
				local offset = Vector.FromAngle(data.Grind.GrindSide):Resized(20)
				entity.TargetPosition = data.Grind.TargetPosition + offset

				local targetVector = (entity.TargetPosition - entity.Position) / 5
				entity.Velocity = mod:Lerp(entity.Velocity, targetVector, 0.25)
				sprite.FlipX = data.Grind.MoveDirection.X <= -1 or data.Grind.GrindSide == 180

			else
				entity.Velocity = mod:StopLerp(entity.Velocity)
			end


			-- Jump / land
			if sprite:IsEventTriggered("Jump") then
				entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
				mod:PlaySoundCool(nil, mod.Sounds.RadicalEmbryoOllie)

			elseif sprite:IsEventTriggered("Landed") then
				mod:PlaySoundCool(nil, mod.Sounds.RadicalEmbryoLand)

				if hasGrid then
					entity.StateFrame = 1
				else
					entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
				end
			end

			-- Change to the regular jump if the grid is gone
			if not hasGrid then
				sprite:SetAnimation("JumpNoGrind", false)

				if sprite:IsFinished() then
					entity.State = NpcState.STATE_IDLE
				end
			end


		-- Grinding
		elseif entity.StateFrame == 1 then
			local offset = Vector.FromAngle(data.Grind.GrindSide):Resized(20)
			local checkPos = entity.Position - offset
			local hasPath = checkGrindPath(checkPos, data.Grind.MoveDirection, data.Grind.GrindSide)

			-- Moving along the path
			if hasPath then
				local targetPos = hasPath + offset
				entity.Velocity = (targetPos - entity.Position):Resized(embryo.GrindSpeed)

				-- Start the animation
				if not sprite:IsPlaying("GrindStart") then
					mod:LoopingAnim(sprite, "GrindLoop")
				end
				sprite.FlipX = data.Grind.MoveDirection.X <= -1 or data.Grind.GrindSide == 180


				-- Grinding sound
				local volume = mod:ClampNumber(entity.Velocity:Length() / 8, 0.25, 0.75)

				if not SFXManager():IsPlaying(mod.Sounds.RadicalEmbryoGrind) then
					mod:PlaySoundCool(nil, mod.Sounds.RadicalEmbryoGrind, volume, 1, 0, true)
				end
				SFXManager():AdjustVolume(mod.Sounds.RadicalEmbryoGrind, volume)

				-- Dust trail
				if entity:IsFrame(4, 0) then
					local angle = math.random(-30, 30)
					local vector = -entity.Velocity:Rotated(angle) / 2
					local dust = mod:SpawnDust(entity.Position, vector, 0.4, Color(0.45,0.45,0.45, 0.5))
					dust:GetSprite().Offset = Vector(0, -10)
				end


			-- Jump off if the path ends
			else
				entity.StateFrame = 2
				sprite:Play("GrindStop", true)
				SFXManager():Stop(mod.Sounds.RadicalEmbryoGrind)

				-- Get the land position
				local vector = data.Grind.MoveDirection:Resized(20)
				entity.TargetPosition = room:FindFreePickupSpawnPosition(checkPos + vector)
			end


		-- Jump back down
		elseif entity.StateFrame == 2 then
			-- Movement
			if sprite:WasEventTriggered("Jump") and not sprite:WasEventTriggered("Landed") then
				local targetVector = (entity.TargetPosition - entity.Position) / 5
				entity.Velocity = mod:Lerp(entity.Velocity, targetVector, 0.25)
				mod:FlipTowardsMovement(entity, sprite)
			else
				entity.Velocity = mod:StopLerp(entity.Velocity)
			end

			-- Jump / land
			if sprite:IsEventTriggered("Jump") then
				mod:PlaySoundCool(nil, mod.Sounds.RadicalEmbryoOllie)

			elseif sprite:IsEventTriggered("Landed") then
				entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
				mod:PlaySoundCool(nil, mod.Sounds.RadicalEmbryoLand)
			end

			if sprite:IsFinished() then
				entity.State = NpcState.STATE_IDLE
			end
		end
	end



	-- Kickflip sounds
	if sprite:IsPlaying("Kickflip") then
		if sprite:IsEventTriggered("Jump") then
			entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS
			mod:PlaySoundCool(nil, mod.Sounds.RadicalEmbryoOllie)
			SFXManager():Stop(mod.Sounds.RadicalEmbryoRoll)
			SFXManager():Stop(mod.Sounds.RadicalEmbryoGrind)

		elseif sprite:IsEventTriggered("Landed") then
			entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
			mod:PlaySoundCool(nil, mod.Sounds.RadicalEmbryoLand)
		end
	end


	-- Disable default AI
	if entity.FrameCount > 1 then
		return true
	end
end



-- Stop grinding when entering a new room
function mod:ResetRadicalEmbryos(room, roomDesc)
	local embryos = Isaac.FindByType(EntityType.ENTITY_EMBRYO, embryo.Variant)

	for i, entity in pairs(embryos) do
		entity = entity:ToNPC()

		if entity.State == NpcState.STATE_JUMP then
			entity.State = NpcState.STATE_IDLE
			entity:GetSprite():Play("Idle", true)
			entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_NEW_ROOM, mod.ResetRadicalEmbryos)

-- Stop looping sounds
function mod:RadicalEmbryoRemove(entity)
	if entity.Variant == embryo.Variant then
		SFXManager():Stop(mod.Sounds.RadicalEmbryoRoll)
		SFXManager():Stop(mod.Sounds.RadicalEmbryoGrind)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, mod.RadicalEmbryoRemove, EntityType.ENTITY_EMBRYO)