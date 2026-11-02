local mod = FiendFolio

local Settings = {
	Cooldown = 0.5 * 30,
	RevealRange = 3 * 40,
	StartSmallThreshold = 5 * 40,
	FullRangeTime = 3 * 30,
	SelfRevealDelay = 6 * 30,
	MoveSpeed = 5.25,
	ChaseRange = 6.5 * 40,

	-- Grid types that can't be used as disguises
	GridTypeBlacklist = {
		[ GridEntityType.GRID_DECORATION ] = true,
		[ GridEntityType.GRID_WALL ] 	   = true,
		[ GridEntityType.GRID_DOOR ] 	   = true,
		[ GridEntityType.GRID_GRAVITY ]    = true,
		[ GridEntityType.GRID_STATUE ] 	   = true,
	},

	-- Unique grid types for certain champions if not defined
	ChampionGridTypes = {
		[ ChampionColor.ORANGE ]  = GridEntityType.GRID_ROCK_GOLD,
		[ ChampionColor.BLACK ]   = GridEntityType.GRID_ROCK_BOMB,
		[ ChampionColor.PURPLE ]  = GridEntityType.GRID_ROCK_SPIKED,
		[ ChampionColor.BROWN ]   = GridEntityType.GRID_POOP,
		[ ChampionColor.RAINBOW ] = GridEntityType.GRID_ROCKT,
	},

	-- The entity flags to add when hidden
	HiddenFlags =
		EntityFlag.FLAG_NO_TARGET |
		EntityFlag.FLAG_NO_KNOCKBACK |
		EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK |
		EntityFlag.FLAG_DONT_COUNT_BOSS_HP |
		EntityFlag.FLAG_HIDE_HP_BAR,

	-- Grid types that should use the background sorting layer
	BackgroundSorting = {
		[ GridEntityType.GRID_DECORATION ] = true,
		[ GridEntityType.GRID_PIT ] 	   = true,
		[ GridEntityType.GRID_TRAPDOOR ]   = true,
		[ GridEntityType.GRID_STAIRS ] 	   = true,
	},
	-- The grid path to set for certain disguises (the default is 1000)
	GridPaths = {
		[ GridEntityType.GRID_DECORATION ] 	   = 0,
		[ GridEntityType.GRID_PIT ] 		   = 3000,
		[ GridEntityType.GRID_SPIKES ] 		   = 999,
		[ GridEntityType.GRID_SPIKES_ONOFF ]   = 999,
		[ GridEntityType.GRID_SPIDERWEB ] 	   = 0,
		[ GridEntityType.GRID_LOCK ] 		   = 4000,
		[ GridEntityType.GRID_TRAPDOOR ] 	   = 0,
		[ GridEntityType.GRID_STAIRS ] 		   = 0,
		[ GridEntityType.GRID_GRAVITY ] 	   = 0,
		[ GridEntityType.GRID_PRESSURE_PLATE ] = 300,
		[ GridEntityType.GRID_TELEPORTER ] 	   = 999,
	},
}



-- Get the type and variant for the grid entity to use as the disguise
function mod:GetToadsieDisguiseType(entity)
	local gridType = entity.SubType & 31
	local gridVariant = (entity.SubType >> 5) & 15
	return gridType, gridVariant
end



-- Enter the disguised form
function mod:ToadsieDisguise(entity)
	entity.Position = entity.TargetPosition
	entity.Velocity = Vector.Zero

	entity.State = NpcState.STATE_IDLE
	entity.Visible = not PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_GUPPYS_EYE)
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
	entity:AddEntityFlags(Settings.HiddenFlags)
	entity.ProjectileCooldown = Settings.Cooldown


	-- Set the depth offset and sorting layer
	local gridType, gridVariant = mod:GetToadsieDisguiseType(entity)

	if gridType == GridEntityType.GRID_SPIDERWEB then
		entity.DepthOffset = -1000
		entity:SetWaterClipFlags(WaterClipFlag.DISABLE_RENDER_ABOVE_WATER | WaterClipFlag.ENABLE_RENDER_BELOW_WATER | WaterClipFlag.DISABLE_RENDER_REFLECTION)

	elseif Settings.BackgroundSorting[gridType] then
		entity.DepthOffset = 1000
		entity.SortingLayer = SortingLayer.SORTING_DOOR
		entity:SetWaterClipFlags(WaterClipFlag.DISABLE_RENDER_ABOVE_WATER | WaterClipFlag.ENABLE_RENDER_BELOW_WATER | WaterClipFlag.DISABLE_RENDER_REFLECTION)

	else
		entity.DepthOffset = gridType == GridEntityType.GRID_PILLAR and 20 or -1000
		entity:SetWaterClipFlags(WaterClipFlag.DISABLE_RENDER_BELOW_WATER | WaterClipFlag.DISABLE_RENDER_REFLECTION)
	end


	-- Create the disguise sprite if it doesn't exist
	local data = mod:GetEntityData(entity)

	if not data.ToadsieDisguiseSprite then
		local room = Game():GetRoom()
		local grindex = room:GetGridIndex(entity.TargetPosition)
		local grid = room:GetGridEntity(grindex)

		-- Create a real grid entity to copy
		if not grid or grid:GetType() ~= gridType or grid:GetVariant() ~= gridVariant then
			grid = Isaac.GridSpawn(gridType, gridVariant, entity.TargetPosition, true)
			grid:PostInit()
			StageAPI.UpdateGrids()

			-- Make sure it doesn't connect to other rocks
			local rock = grid:ToRock()

			if rock and gridType == GridEntityType.GRID_ROCK and rock:GetVariant() >= 1000 then
				rock:UpdateNeighbors()
				rock:SetBigRockFrame(-1)
			end
		end


		local sprite = grid:GetSprite()

		-- Pit tiling and bridge fix
		if gridType == GridEntityType.GRID_PIT then
			sprite:SetFrame(0)
			sprite:GetLayer("bridge"):SetVisible(false)

		-- Trapdoor animation fix
		elseif gridType == GridEntityType.GRID_TRAPDOOR or gridType == GridEntityType.GRID_STAIRS then
			sprite:Play("Open Animation", true)

		-- Pillar overlay fix
		elseif gridType == GridEntityType.GRID_PILLAR and sprite:GetLayer("top") then
			sprite:GetLayer("top"):SetVisible(true)
		end

		data.ToadsieDisguiseSprite = sprite:Copy()


		-- Get the grid path to use
		local gridPath = Settings.GridPaths[gridType] or 1000

		-- Remove custom grid entities and store their data
		local customGrid = StageAPI and StageAPI.GetCustomGrid(grindex)

		if customGrid then
			Isaac.RunCallbackWithParam("FF_TOADSIE_DISGUISE_GET", customGrid.GridConfig.Name, entity, customGrid)
			gridPath = customGrid.GridPath or gridPath

			data.ToadsieCustomGrid = mod:CopyTable(customGrid)
			customGrid:Remove()
		end

		-- Remove the regular grid entity
		room:RemoveGridEntityImmediate(grindex, 0, false)
		entity.I1 = gridPath
	end


	-- Custom grid script
	if data.ToadsieCustomGrid then
		local param = data.ToadsieCustomGrid.GridConfig.Name
		Isaac.RunCallbackWithParam("FF_TOADSIE_DISGUISE_ENTER", param, entity, data.ToadsieCustomGrid, data.ToadsieDisguiseSprite)
	end
end



-- Transform poof effect
local function poof(entity)
	local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, Vector.Zero, entity)
	effect:GetSprite().PlaybackSpeed = 1.25
	effect:Update()
end



-- Come out of the diguised form
function mod:ToadsieReveal(entity)
	if entity.ProjectileCooldown <= 0 then
		entity.Position = entity.TargetPosition
		entity.Velocity = Vector.Zero

		entity.State = entity.StateFrame <= 0 and NpcState.STATE_SPECIAL or NpcState.STATE_JUMP
		entity.Visible = true
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
		entity:ClearEntityFlags(Settings.HiddenFlags)
		mod.QuickSetEntityGridPath(entity, 0, true)
		entity.StateFrame = Settings.SelfRevealDelay

		-- Reset the depth offset and sorting layer
		entity.DepthOffset = 0
		entity.SortingLayer = SortingLayer.SORTING_NORMAL
		entity:ResetWaterClipFlags()

		-- Reveal animation
		entity:GetSprite():Play("Reveal", true)
		poof(entity)
		mod:PlaySoundCool(nil, SoundEffect.SOUND_BIGHORN_HAND_APPEAR, 0.9)

		-- Custom grid script
		local data = mod:GetEntityData(entity)

		if data.ToadsieCustomGrid then
			local param = data.ToadsieCustomGrid.GridConfig.Name
			Isaac.RunCallbackWithParam("FF_TOADSIE_DISGUISE_LEAVE", param, entity, data.ToadsieCustomGrid, data.ToadsieDisguiseSprite)
		end
	end
end





function mod:ToadsieInit(entity)
	-- Get the grid type to disguise as if not defined
	if mod:GetToadsieDisguiseType(entity) == GridEntityType.GRID_NULL then
		local room = Game():GetRoom()
		local grindex = room:GetGridIndex(entity.Position)
		local grid = room:GetGridEntity(grindex)

		-- Spawned on a valid grid entity
		local customGrid = StageAPI and StageAPI.GetCustomGrid(grindex)

		if grid and (customGrid or not Settings.GridTypeBlacklist[grid:GetType()]) then
			entity.SubType = grid:GetType() + (grid:GetVariant() * 32)

		-- Use rocks as the default otherwise
		else
			entity.SubType = GridEntityType.GRID_ROCK
		end
	end

	-- Pointless unique replacements for champion rocks
	local color = entity:GetChampionColorIdx()

	if mod:GetToadsieDisguiseType(entity) == GridEntityType.GRID_ROCK and Settings.ChampionGridTypes[color] then
		entity.SubType = Settings.ChampionGridTypes[color]
	end

	-- Start disguised
	entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	entity.TargetPosition = mod:GetGridAlignedPos(entity.Position)
	mod:ToadsieDisguise(entity)
	entity.StateFrame = Settings.SelfRevealDelay

	-- Start with a small reveal range if spawned near players
	local nearest = Game():GetNearestPlayer(entity.Position)

	if entity.Position:Distance(nearest.Position) <= Settings.StartSmallThreshold then
		entity.I2 = 1
	end
end

function mod:ToadsieUpdate(entity)
	local sprite = entity:GetSprite()
	local data = mod:GetEntityData(entity)
	local target = entity:GetPlayerTarget()
	local pathfinder = entity:GetPathfinder()
	local room = Game():GetRoom()


	--[[ Disguising ]]--
	if entity.State == NpcState.STATE_STOMP then
		entity.Position = mod:Lerp(entity.Position, entity.TargetPosition, 0.5)
		entity.Velocity = mod:StopLerp(entity.Velocity, 0.5)

		if sprite:IsFinished() then
			mod:ToadsieDisguise(entity)
			poof(entity)
			mod:PlaySoundCool(nil, SoundEffect.SOUND_BIGHORN_HAND_HIDE, 0.9)
		end



	--[[ Disguised ]]--
	elseif entity.State == NpcState.STATE_IDLE then
		entity.Position = entity.TargetPosition
		entity.Velocity = Vector.Zero
		mod.NegateKnockoutDrops(entity)

		mod:LoopingAnim(sprite, "Idle")
		data.ToadsieDisguiseSprite:Update()

		-- Reset the grid path so we can use check line and pathfinder stuff
		mod.QuickSetEntityGridPath(entity, 0, true)


		-- Guppy's Eye interaction
		if PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_GUPPYS_EYE) then
			entity.Visible = true
			entity:SetColor(Color(1,1,1, 0.25), 2, 0, false, false)
		else
			entity.Visible = false
		end


		-- Custom grid scripts
		if data.ToadsieCustomGrid then
			local param = data.ToadsieCustomGrid.GridConfig.Name
			Isaac.RunCallbackWithParam("FF_TOADSIE_DISGUISE_UPDATE", param, entity, data.ToadsieCustomGrid, data.ToadsieDisguiseSprite)
		end


		-- Try to come out of hiding if alone
		if entity:GetAliveEnemyCount() <= 1
		and (entity:IsFlying() or pathfinder:HasPathToPos(target.Position, false))
		and (not room:HasTriggerPressurePlates() or Game():GetLevel():GetCurrentRoomDesc().PressurePlatesTriggered) then
			entity.StateFrame = math.max(0, entity.StateFrame - 1)
		else
			entity.StateFrame = Settings.SelfRevealDelay
		end


		-- Try to jumpscare if close enough
		local revealRangeMulti = entity.I2 == 1 and math.min(entity.FrameCount / Settings.FullRangeTime, 1) or 1
		local revealRange = revealRangeMulti * Settings.RevealRange
		local nearest = Game():GetNearestPlayer(entity.Position)

		local nearTarget = nearest.Position:Distance(entity.Position) <= revealRange
		and (nearest:IsFlying() or room:CheckLine(entity.Position, nearest.Position, LineCheckMode.ENTITY, 1000))


		-- Reveal if either of the conditions are met
		entity.ProjectileCooldown = math.max(0, entity.ProjectileCooldown - 1)

		if nearTarget or entity.StateFrame <= 0 then
			mod:ToadsieReveal(entity)

		-- Set the grid path
		else
			mod.QuickSetEntityGridPath(entity, entity.I1, true)
		end



	--[[ Revealing ]]--
	elseif entity.State == NpcState.STATE_JUMP then
		entity.Velocity = mod:StopLerp(entity.Velocity)

		if sprite:IsFinished() then
			entity.State = NpcState.STATE_MOVE
		end

	--[[ Chasing ]]--
	elseif entity.State == NpcState.STATE_MOVE or entity.State == NpcState.STATE_SPECIAL then
		mod:ChasePlayerCool(entity, Settings.MoveSpeed)
		entity:AnimWalkFrame("WalkHori", "WalkVert", 0.1)

		-- Stop chasing if the target is far enough away from our home
		if entity.State == NpcState.STATE_MOVE and target.Position:Distance(entity.TargetPosition) > Settings.ChaseRange then
			entity.State = NpcState.STATE_SUICIDE
		end



	--[[ Returning to its home ]]--
	elseif entity.State == NpcState.STATE_SUICIDE then
		if room:GetGridCollisionAtPos(entity.TargetPosition) <= GridCollisionClass.COLLISION_NONE -- Our home is free
		and (entity:IsFlying() or pathfinder:HasPathToPos(entity.TargetPosition, false)) then -- Can get to our home
			pathfinder:FindGridPath(entity.TargetPosition, Settings.MoveSpeed * 0.15, 500, true)

		-- Uh oh, I'm stuck! Let's make this our new home
		else
			entity.TargetPosition = room:FindFreePickupSpawnPosition(entity.Position)
		end

		entity:AnimWalkFrame("WalkHori", "WalkVert", 0.1)

		-- Disguise if back at our home
		if entity.Position:Distance(entity.TargetPosition) <= 10 then
			entity.State = NpcState.STATE_STOMP
			sprite:Play("Transform", true)
		end
	end
end

-- Render the disguise separately
function mod:ToadsiePreRender(entity, offset)
	local data = mod:GetEntityData(entity)

	if entity.State == NpcState.STATE_IDLE and data.ToadsieDisguiseSprite then
		local renderPos = entity.Position + entity.PositionOffset + entity.V1
		renderPos = Isaac.WorldToRenderPosition(renderPos) + offset
		data.ToadsieDisguiseSprite:Render(renderPos)
	end
end

-- Reveal if attacked
function mod:ToadsiePreDMG(entity, damageAmount, damageFlags, damageSource, damageCountdownFrames)
	entity = entity:ToNPC()

	if entity.State == NpcState.STATE_IDLE then
		if not (damageFlags & DamageFlag.DAMAGE_POISON_BURN > 0) then
			mod:ToadsieReveal(entity)
		end

		return false
	end
end

-- Ignore collision with our home's grid path
function mod:ToadsiePreGridCollision(entity, grindex, grid)
	if entity.State == NpcState.STATE_IDLE then
		local room = Game():GetRoom()
		local homeGrindex = room:GetGridIndex(entity.TargetPosition)

		if grindex == homeGrindex then
			return true
		end
	end
end

-- Reset the grid path if removed in any way
function mod:ToadsieRemove(entity)
	mod.QuickSetEntityGridPath(entity, 0, true)
end





-- Fire Pot
function mod:ToadsieEnterFirePot(entity, grid, disguise)
	grid.GridEntity = { Position = entity.Position, }
	mod.firepotSpawn(grid)
end
mod:AddCallback("FF_TOADSIE_DISGUISE_ENTER", mod.ToadsieEnterFirePot, "FFFirePot")

function mod:ToadsieLeaveFirePot(entity, grid, disguise)
	mod.firepotRemove(grid)
end
mod:AddCallback("FF_TOADSIE_DISGUISE_GET", 	 mod.ToadsieLeaveFirePot, "FFFirePot")
mod:AddCallback("FF_TOADSIE_DISGUISE_LEAVE", mod.ToadsieLeaveFirePot, "FFFirePot")



-- Lily Pad
function mod:ToadsieGetLilyPad(entity, grid)
	grid.GridPath = 0
	mod.lilyPadRemove(grid)
end
mod:AddCallback("FF_TOADSIE_DISGUISE_GET", mod.ToadsieGetLilyPad, "FFLilyPad")

function mod:ToadsieEnterLilyPad(entity, grid, disguise)
	grid.GridEntity = { Position = entity.Position, }
	mod.lilyPadSpawn(grid)
end
mod:AddCallback("FF_TOADSIE_DISGUISE_ENTER", mod.ToadsieEnterLilyPad, "FFLilyPad")

function mod:ToadsieLeaveLilyPad(entity, grid, disguise)
	mod.lilyPadRemove(grid)
end
mod:AddCallback("FF_TOADSIE_DISGUISE_LEAVE", mod.ToadsieLeaveLilyPad, "FFLilyPad")



-- Totems
function mod:ToadsieGetTotemInactive(entity, grid)
	grid.GridPath = 0
end
mod:AddCallback("FF_TOADSIE_DISGUISE_GET", mod.ToadsieGetTotemInactive, "FFTotemBlue")
mod:AddCallback("FF_TOADSIE_DISGUISE_GET", mod.ToadsieGetTotemInactive, "FFLilTotemBlue")

-- Totem buttons
function mod:ToadsieGetTotemButton(entity, grid)
	grid.GridPath = 950
end
mod:AddCallback("FF_TOADSIE_DISGUISE_GET", mod.ToadsieGetTotemButton, "FFTotemSwitch")
mod:AddCallback("FF_TOADSIE_DISGUISE_GET", mod.ToadsieGetTotemButton, "FFTotemTimedButton")



-- Platinum Poop
function mod:ToadsieUpdatePlatinumPoop(entity, grid, disguise)
	local data = grid.Data

	-- Create and update the shimmer timer
	if not data.ShimmerTime then
		data.ShimmerTime = grid.RNG:RandomInt(60) + 45
	end
	data.ShimmerTime = data.ShimmerTime - 1

	-- Do the shimmer
	if data.ShimmerTime <= 0 then
		local suffix = string.sub(disguise:GetAnimation(), -1)

		if tonumber(suffix) and suffix ~= "5" and disguise:IsFinished() then
			disguise:Play("Shimmer" .. suffix, true)
		end
		data.ShimmerTime = nil
	end
end
mod:AddCallback("FF_TOADSIE_DISGUISE_UPDATE", mod.ToadsieUpdatePlatinumPoop, "FFPlatinumPoop")



-- Uranium
function mod:ToadsieGetUranium(entity, grid)
	if grid.ffRadioactiveAura then
		for i, effect in pairs( Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.EMBER_PARTICLE) ) do
			if effect.SpawnerEntity and effect.SpawnerEntity.Index == grid.ffRadioactiveAura.Index then
				effect:Remove()
			end
		end

		grid.ffRadioactiveAura:Remove()
	end
end
mod:AddCallback("FF_TOADSIE_DISGUISE_GET", mod.ToadsieGetUranium, "FFUranium")



-- FFG Mud Tile
function mod:ToadsieEnterMudTile(entity, grid, disguise)
	disguise.PlaybackSpeed = 0
	disguise:SetFrame(0)
end
mod:AddCallback("FF_TOADSIE_DISGUISE_ENTER", mod.ToadsieEnterMudTile, "FFGRACEMudTile")



-- FFG Giant Mushroom
function mod:ToadsieGetGiantMushroom(entity, grid)
	local parentCorner = grid
	local data = grid.PersistentData

	-- Remove the extra corners
	if data.ExtraCorners then
		for i, grindex in pairs(data.ExtraCorners) do
			local corner = StageAPI.GetCustomGrid(grindex)

			if corner then
				corner:Remove()
			end
		end

	-- Remove the parent corner
	elseif data.ParentCorner then
		parentCorner = data.ParentCorner
		data.ParentCorner:Remove()
	end

	-- Update the target position to align better
	local offset = Vector(20, 40)
	entity.TargetPosition = parentCorner.Position + offset
	entity.V1 = -offset
end
mod:AddCallback("FF_TOADSIE_DISGUISE_GET", mod.ToadsieGetGiantMushroom, "FFGRACEGiantMushroom")



-- FFG Glowing Mushroom
function mod:ToadsieEnterGlowingMushroom(entity, grid, disguise)
	grid.IsOnGrid = function() return false end
	StageAPI.CallCallbacksWithParams("POST_SPAWN_CUSTOM_GRID", true, "FFGRACEGlowingMushroom", grid)
end
mod:AddCallback("FF_TOADSIE_DISGUISE_ENTER", mod.ToadsieEnterGlowingMushroom, "FFGRACEGlowingMushroom")

function mod:ToadsieLeaveGlowingMushroom(entity, grid, disguise)
	StageAPI.CallCallbacksWithParams("POST_REMOVE_CUSTOM_GRID", true, "FFGRACEGlowingMushroom", grid)
end
mod:AddCallback("FF_TOADSIE_DISGUISE_LEAVE", mod.ToadsieLeaveGlowingMushroom, "FFGRACEGlowingMushroom")