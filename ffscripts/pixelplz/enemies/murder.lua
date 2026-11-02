local mod = FiendFolio

local Settings = {
	DefaultBirdAmount = 6,

	FlockCombineDistance = 80,
	MaxFlockDistance = 120,

	FlockSpeed = 6,
	BirdSpeed = 10,
	FlockOffset = {10, 30},

	DisperseDelay = 5 * 30,
	DespawnMargin = 200,
}



function mod:MurderInit(entity)
	entity.State = NpcState.STATE_MOVE
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
	entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	entity.SplatColor = Color(0,0,0, 1)
	mod:PlaySoundCool(entity, mod.Sounds.Crow, 2, 0.85, 2)

	-- Spawn extra copies
	local amount = entity.SubType == 0 and Settings.DefaultBirdAmount or entity.SubType

	for i = 1, amount - 1 do
		Isaac.Spawn(entity.Type, entity.Variant, 1, entity.Position, entity.Velocity, entity)
	end

	-- Enable the flock combining callback
	mod:EnableManualCallback(ModCallbacks.MC_PRE_UPDATE, 	mod.CombineMurderFlocks)
	mod:EnableManualCallback(ModCallbacks.MC_PRE_ROOM_EXIT, mod.DisableMurderCallbacks)
end

function mod:MurderUpdate(entity)
	local data = mod:GetEntityData(entity)
	local flockPosition = entity.Position
	local multipleBirds = false


	if data.FlockData then
		local flock = data.FlockData

		-- Update the flock only once per frame and only if at least one bird is active
		local targetFrame = Game():GetFrameCount()

		if flock.LastUpdate ~= targetFrame then
			flock.LastUpdate = targetFrame
			flock.Duration = math.max(flock.Duration - 1)


			-- Update every bird
			for i = #flock.Birds, 1, -1 do
				local bird = flock.Birds[i]

				-- Remove far away or dead birds from the flock
				if not mod:IsTangible(bird) or bird.Position:Distance(flock.Position) > Settings.MaxFlockDistance then
					table.remove(flock.Birds, i)
					mod:GetEntityData(bird).FlockData = nil

				else
					-- Make all the birds have the same status effects
					mod:copyStatusEffects(entity, bird)
					mod:copyStatusEffects(bird, entity)

					-- Start dispersing
					if flock.Duration <= 0 then
						bird.State = NpcState.STATE_SUICIDE
						bird.TargetPosition = flock.Position
						bird.CanShutDoors = false
					end
				end
			end


			-- Handle the flock's movement
			local velocity = Vector.Zero

			if flock.Duration > 0 then
				local target = entity:GetPlayerTarget()
				local vector = target.Position - flock.Position
				local wanderAround = mod:isConfuse(entity) or (mod:isScare(entity) and flock.Position:Distance(target.Position) > 160)

				-- Wander around if confused or feared but not close
				if wanderAround then
					vector = mod:RandomVector()

				-- Fly away if feared and close
				elseif mod:isScare(entity) then
					vector = -vector
				end

				velocity = vector:Resized(Settings.FlockSpeed)
			end

			flock.Velocity = mod:Lerp(flock.Velocity, velocity, 0.25)
			flock.Position = flock.Position + flock.Velocity
		end


		-- Set this bird's target position
		flockPosition = flock.Position
		multipleBirds = mod:GetTableLength(flock.Birds) > 1
	end



	--[[ Chasing in a flock ]]--
	if entity.State == NpcState.STATE_MOVE then
		local targetPos = flockPosition

		-- Extra offset if the flock has multiple birds
		if multipleBirds then
			targetPos = flockPosition + entity.V1

			if entity.Position:Distance(targetPos) <= entity.Size then
				local distance = mod:Random(Settings.FlockOffset[1], Settings.FlockOffset[2])
				entity.V1 = mod:RandomVector(distance)
				targetPos = flockPosition + entity.V1
			end
		end

		local vector = targetPos - entity.Position
		local speed = math.min(Settings.BirdSpeed, vector:Length())
		local velocity = vector:Resized(speed)
		entity.Velocity = mod:Lerp(entity.Velocity, velocity, 0.15)



	--[[ Leaving ]]--
	elseif entity.State == NpcState.STATE_SUICIDE then
		local velocity = entity.Position - entity.TargetPosition
		entity.Velocity = mod:Lerp(entity.Velocity, velocity:Resized(Settings.BirdSpeed), 0.15)

		-- Despawn if far enough outside the room
		if not Game():GetRoom():IsPositionInRoom(entity.Position, -Settings.DespawnMargin) then
			entity:Remove()
		end
	end


	-- Update the animation
	local sprite = entity:GetSprite()
	mod:LoopingAnim(sprite, "Flying")
	mod:FlipTowardsMovement(entity, sprite, true)
end



-- Try to combine flocks if possible
function mod:CombineMurderFlocks()
	-- Get every unique flock
	local flocks = {}

	for i, bird in pairs( Isaac.FindByType(mod.FF.Murder.ID, mod.FF.Murder.Var) ) do
		bird = bird:ToNPC()

		if bird.State ~= NpcState.STATE_SUICIDE then
			local data = mod:GetEntityData(bird)

			-- Create a flock for this bird if it doesn't have one
			if not data.FlockData then
				data.FlockData = {
					LastUpdate = -1,
					Birds 	   = { bird, },
					Position   = bird.Position,
					Velocity   = bird.Velocity,
					Duration   = Settings.DisperseDelay,
				}
			end
			local flock = data.FlockData

			-- Check if it's already been added
			local add = true

			for j, otherFlock in pairs(flocks) do
				if otherFlock == flock then
					add = false
					break
				end
			end

			if add then
				table.insert(flocks, flock)
			end
		end
	end


	-- Check if any of the flocks are close enough to each other
	for i = #flocks, 1, -1 do
		local flock = flocks[i]

		if flock then
			for j = #flocks, 1, -1 do
				local otherFlock = flocks[j]

				if otherFlock ~= flock and otherFlock.Position:Distance(flock.Position) <= Settings.FlockCombineDistance then
					local newPos = mod:GetMeanPos({ flock.Position, otherFlock.Position, })
					local newVelocity = mod:GetMeanPos({ flock.Velocity, otherFlock.Velocity, })
					local newDuration = mod:Lerp(flock.Duration, otherFlock.Duration, 0.5)

					-- Create the new tracker
					local newFlockData = {
						LastUpdate = -1,
						Birds 	   = {},
						Position   = newPos,
						Velocity   = newVelocity,
						Duration   = math.ceil(newDuration),
					}

					-- Copy over both flocks' birds
					for flockIndex = 1, 2 do
						local flockToUse = flockIndex == 2 and otherFlock or flock

						for k, bird in pairs(flockToUse.Birds) do
							table.insert(newFlockData.Birds, bird)
						end
					end

					-- Set their trackers
					for k, bird in pairs(newFlockData.Birds) do
						mod:GetEntityData(bird).FlockData = newFlockData
					end

					table.remove(flocks, i)
					table.remove(flocks, j)
					break
				end
			end
		end
	end
end
mod:AddManualCallback(ModCallbacks.MC_PRE_UPDATE, mod.CombineMurderFlocks)



-- Disable the flock combining callback when exiting the room
function mod:DisableMurderCallbacks()
	mod:DisableManualCallback(ModCallbacks.MC_PRE_UPDATE, 	 mod.CombineMurderFlocks)
	mod:DisableManualCallback(ModCallbacks.MC_PRE_ROOM_EXIT, mod.DisableMurderCallbacks)
end
mod:AddManualCallback(ModCallbacks.MC_PRE_ROOM_EXIT, mod.DisableMurderCallbacks)