local mod = FiendFolio



-- Spawn the wanted poster on a valid wall position
function mod:SpawnFriendWantedPoster()
	local level = Game():GetLevel()
	local roomIdx = level:GetCurrentRoomIndex()

	local runData = mod.savedata.run
	runData.WantedPosterSpawns = runData.WantedPosterSpawns or {}

	local floorData = runData.WantedPosterSpawns
	local saveIndex = tostring(roomIdx)


	-- Get a new valid position if there isn't one saved
	if not floorData[saveIndex] then
		local room = Game():GetRoom()
		local validPositions = {}
		local highestPriority = 0

		local npc = Isaac.Spawn(EntityType.ENTITY_SHOPKEEPER, 0, 0, Vector.Zero, Vector.Zero, nil):ToNPC()
		local pathfinder = npc:GetPathfinder()


		-- Find valid walls to put the poster on
		for grindex = 0, room:GetGridSize() - 1 do
			local grid = room:GetGridEntity(grindex)

			if grid and grid:GetType() == GridEntityType.GRID_WALL and not StageAPI.GetCustomGrid(grindex) then
				local closeToDoor = false

				-- Avoid positions right next to valid door slots
				for slot = 0, DoorSlot.NUM_DOOR_SLOTS - 1 do
					local doorPos = room:GetDoorSlotPosition(slot)
					local canHaveDoor = room:GetDoor(slot) or level:CanSpawnDoorOutline(roomIdx, slot)

					if canHaveDoor and grid.Position:Distance(doorPos) <= 40 then
						closeToDoor = true
						break
					end
				end

				-- Check the neighbouring positions
				for angle = 90, 360, 90 do
					local offset = Vector.FromAngle(angle):Resized(21)
					local testPos = grid.Position + offset
					npc.Position = testPos

					if room:IsPositionInRoom(testPos, 0) then
						local obstructed = false

						if angle == 90 then
							local potentialPillar = room:GetGridEntityFromPos(testPos)

							-- Avoid positions that are obstructed by pillars
							if potentialPillar and potentialPillar:GetType() == GridEntityType.GRID_PILLAR then
								obstructed = true

							-- Avoid positions that are obstructed by slots
							else
								for i, slot in pairs( Isaac.FindByType(EntityType.ENTITY_SLOT) ) do
									local xDistance = Vector(testPos.X, 0):Distance(Vector(slot.Position.X, 0))
									local yDistance = Vector(0, testPos.Y):Distance(Vector(0, slot.Position.Y))

									if xDistance <= 20
									and slot.Position.Y >= testPos.Y and yDistance <= 60 then
										obstructed = true
										break
									end
								end
							end
						end

						if not obstructed then
							local data = { X = testPos.X, Y = testPos.Y, Angle = angle, }
							local priority = 0

							-- Prioritize positions that...
							local checks = {
								grindex < room:GetGridWidth(), -- Are on the top wall
								not closeToDoor, -- Are not too close to doors
								pathfinder:HasPathToPos(Isaac.GetPlayer().Position, true), -- The player can get to
							}
							for i, check in ipairs(checks) do
								if check then
									local addedPriority = 2 ^ (i - 1)
									priority = priority + addedPriority
								end
							end

							-- Only save positions with the highest priority
							if priority >= highestPriority then
								if priority > highestPriority then
									validPositions = {}
									highestPriority = priority
								end

								table.insert(validPositions, data)
							end
						end
					end
				end
			end
		end


		-- Pick the position to use
		if #validPositions > 0 then
			local rng = RNG( room:GetSpawnSeed() )
			floorData[saveIndex] = mod:RandomIndex(validPositions, rng)
		end

		npc:Remove()
	end


	-- Spawn the poster in the saved position
	if floorData[saveIndex] then
		local data = floorData[saveIndex]
		local poster = Isaac.Spawn(mod.FF.FriendWantedPoster.ID, mod.FF.FriendWantedPoster.Var, 0, Vector(data.X, data.Y), Vector.Zero, nil)
		poster.TargetPosition = poster.Position
		poster.SpriteRotation = data.Angle - 90


	-- Failsafe (this should never happen)
	else
		local pos = FiendFolio:FindNearestReachableTile(Isaac.GetPlayer(), room:GetCenterPos(), true) or Isaac.GetPlayer().Position
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, mod.ITEM.TRINKET.WANTED_POSTER, pos, Vector.Zero, nil)
		runData.SpecialWantedPosterSpawned = true
	end
end

-- Reset the saved wanted poster spawns
function mod:ResetFriendWantedPosterSave()
	mod.savedata.run.WantedPosterSpawns = nil
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.ResetFriendWantedPosterSave)



function mod:FriendWantedPosterInit(entity)
	entity:AddEntityFlags(
		EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK |
		EntityFlag.FLAG_NO_KNOCKBACK |
		EntityFlag.FLAG_NO_STATUS_EFFECTS |
		EntityFlag.FLAG_NO_TARGET |
		EntityFlag.FLAG_DONT_OVERWRITE |
		EntityFlag.FLAG_NO_BLOOD_SPLASH
	)
	entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
	entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
	entity.SortingLayer = SortingLayer.SORTING_DOOR

	entity.State = NpcState.STATE_IDLE
	entity:SetInvincible(false)
end

function mod:FriendWantedPosterUpdate(entity)
	local sprite = entity:GetSprite()

	entity.Position = entity.TargetPosition
	entity.Velocity = Vector.Zero


	-- Idle
	if entity.State == NpcState.STATE_IDLE then
		mod:spritePlay(sprite, "Idle")

	-- Hit
	elseif entity.State == NpcState.STATE_ATTACK then
		if sprite:IsFinished() then
			entity.State = NpcState.STATE_IDLE
		end


	-- Taken down
	elseif entity.State == NpcState.STATE_SUMMON then
		if sprite:IsFinished() then
			local velocity = Vector.FromAngle(entity.SpriteRotation + 90):Resized(3)
			local poster = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, mod.ITEM.TRINKET.WANTED_POSTER, entity.Position, velocity, entity)
			mod.savedata.run.SpecialWantedPosterSpawned = true

			local posterSprite = poster:GetSprite()
			posterSprite:Play("Appear", true)
			posterSprite:SetFrame(7)
			poster:Update()

			SFXManager():Play(SoundEffect.SOUND_MENU_NOTE_HIDE, 4)
			entity:Remove()
		end
	end
end



-- Used in Fiend's fireball code to detect nearby posters :)
function mod:TakeDownFriendWantedPoster(pos)
	for i, poster in pairs( Isaac.FindByType(mod.FF.FriendWantedPoster.ID, mod.FF.FriendWantedPoster.Var) ) do
		poster = poster:ToNPC()

		if poster.State ~= NpcState.STATE_SUMMON and poster.Position:Distance(pos) <= 80 then
			poster.State = NpcState.STATE_SUMMON
			poster:GetSprite():Play("TakeDown", true)
		end
	end
end

function mod:FriendWantedPosterDMG(entity, damage, flags, source, countdown)
	entity = entity:ToNPC()

	if entity.State ~= NpcState.STATE_SUMMON and damage > 0 then
		local sprite = entity:GetSprite()

		-- Get taken down by explosions
		if (flags & DamageFlag.DAMAGE_EXPLOSION > 0) then
			entity.State = NpcState.STATE_SUMMON
			sprite:Play("TakeDown", true)

		-- Shrug off everything else
		elseif entity.State == NpcState.STATE_IDLE then
			entity.State = NpcState.STATE_ATTACK
			sprite:Play("Hit", true)
			SFXManager():Play(SoundEffect.SOUND_MENU_NOTE_APPEAR, 3)
		end
	end

	return false
end

-- Ignore tear effects like Euthanasia
function mod:FriendWantedPosterTearFlags(entity, pos, flags, source, damage)
	if entity.Type == mod.FF.FriendWantedPoster.ID and entity.Variant == mod.FF.FriendWantedPoster.Var then
		return false
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_APPLY_TEARFLAG_EFFECTS, mod.FriendWantedPosterTearFlags)



-- Ignore collision with everything
function mod:FriendWantedPosterCollision(entity, collider, bool)
	return true
end

-- Ignore collision with Chaos Card
function mod:FriendWantedPosterTearCollision(tear, collider, bool)
	if collider.Type == mod.FF.FriendWantedPoster.ID and collider.Variant == mod.FF.FriendWantedPoster.Var then
		return true
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, mod.FriendWantedPosterTearCollision, TearVariant.CHAOS_CARD)