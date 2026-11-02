local mod = FiendFolio
local game = Game()

local overwritableGrids = {
	[ GridEntityType.GRID_DECORATION ] = true,
	[ GridEntityType.GRID_SPIDERWEB ] = true,
	[ GridEntityType.GRID_GRAVITY ] = true,
}

local function canOverwriteGridAtPos(pos)
	local room = game:GetRoom()
	local grid = room:GetGridEntityFromPos(pos)

	if not room:IsPositionInRoom(pos, 20) then
		return false

	elseif not grid then
		return true

	else
		local gridType = grid:GetType()

		return overwritableGrids[gridType]
		or grid.State == StageAPI.DefaultBrokenGridStateByType[gridType]
	end
end

mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, function(_, proj)
	local sprite = proj:GetSprite()
	local data = mod:GetEntityData(proj)

	if data.projAnim then
		mod:spritePlay(sprite, data.projAnim)
	end

	if data.gridProjectile then
		if data.leaveCustomGrid then
			data.leaveCustomGrid.PersistentData.Destroyed = true
		end

		if proj:IsDead() then
			local room = game:GetRoom()
			local index = room:GetGridIndex(proj.Position)
			local anim = sprite:GetAnimation()
			local frame = sprite:GetFrame()
			local flipX = sprite.FlipX

			if data.leaveGrid ~= nil and canOverwriteGridAtPos(proj.Position) then
				proj.SubType = 0
				data.leavingGrid = true
				if data.leaveCustomGrid then
					--data.leaveCustomGrid.GridConfig:Spawn(index, false, false, data.leaveCustomGrid.PersistentData)
					if data.leaveCustomGrid.Data.Effect then
						if data.leaveCustomGrid.Data.Effect:Exists() then
							data.leaveCustomGrid.Data.Effect:Remove()
						end

						data.leaveCustomGrid.Data.Effect = nil
					end
					local newGrid = data.leaveCustomGrid.GridConfig:Spawn(index, false, false, nil)
					local gridEnt = room:GetGridEntity(index)
					if gridEnt then
						if data.customAltRock and sprite:GetFilename() == "gfx/grid/grid_rock.anm2" then
							local roomgfx = mod:getCurrentRoomGfx()
							local backdropType = room:GetBackdropType()
							local rSprite = gridEnt:GetSprite()
							if roomgfx and roomgfx.Grids and roomgfx.Grids.Rocks then
								rSprite:ReplaceSpritesheet(0, roomgfx.Grids.Rocks)
								rSprite:LoadGraphics()
							elseif mod.backdropRockSpritesheets[backdropType] then
								rSprite:ReplaceSpritesheet(0, mod.backdropRockSpritesheets[backdropType])
								rSprite:LoadGraphics()
							end
						end
						gridEnt:GetSprite():SetFrame(anim, frame)
						gridEnt:GetSprite().FlipX = flipX
						gridEnt.State = data.gridState
					end
					data.leaveCustomGrid:Remove(true)
				else
					Isaac.GridSpawn(data.leaveGrid[1], data.leaveGrid[2], proj.Position, true)
					local gridEnt = room:GetGridEntity(index)
					if gridEnt then
						gridEnt:GetSprite():SetFrame(anim, frame)
						gridEnt:GetSprite().FlipX = flipX
						gridEnt.State = data.gridState

						local gridType = gridEnt:GetType()
						if gridType < 7 or gridType == 22 or gridType == 25 or gridType == 26 or gridType == 27 then
							local roomgfx = mod:getCurrentRoomGfx()
							local backdropType = room:GetBackdropType()
							local rSprite = gridEnt:GetSprite()

							if data.d12 then
								if data.d12 == 1 then
									rSprite:ReplaceSpritesheet(0, "gfx/grid/rocks_d12.png")
								elseif data.d12 == 2 then
									rSprite:ReplaceSpritesheet(0, "gfx/grid/rocks_ed12.png")
								end
								rSprite:LoadGraphics()
							elseif roomgfx and roomgfx.Grids and roomgfx.Grids.Rocks then
								rSprite:ReplaceSpritesheet(0, roomgfx.Grids.Rocks)
								rSprite:LoadGraphics()
							elseif mod.backdropRockSpritesheets[backdropType] then
								rSprite:ReplaceSpritesheet(0, mod.backdropRockSpritesheets[backdropType])
								rSprite:LoadGraphics()
							end
						end
					end
				end
			elseif data.leaveCustomGrid then
				local Callbacks = require("scripts.stageapi.enums.Callbacks")
				data.leaveCustomGrid:CallCallbacks(Callbacks.POST_CUSTOM_GRID_DESTROY, proj)
			elseif data.specialGridDeath then
				data.specialGridDeath(proj)
				if data.d122Wisp and data.d122Wisp:Exists() then
					local wisp = Isaac.Spawn(3, 206, 604, proj.Position, Vector.Zero, data.d122Wisp):ToFamiliar()
					wisp.Player = data.d122Wisp
					wisp.TargetPosition = proj.Position
					wisp:Update()
				end
			else
				if data.d122Wisp and data.d122Wisp:Exists() then
					local wisp = Isaac.Spawn(3, 206, 604, proj.Position, Vector.Zero, data.d122Wisp):ToFamiliar()
					wisp.Player = data.d122Wisp
					wisp.TargetPosition = proj.Position
					wisp:Update()
				end
			end
		end
	elseif data.enemyTurnedProjectile then
		if proj:IsDead() then
			local game = Game()
			local room = game:GetRoom()
			local index = room:GetGridIndex(proj.Position)

			if room:GetGridCollisionAtPos(proj.Position) == GridCollisionClass.COLLISION_NONE and data.leaveEnemy then
				local spawn = Isaac.Spawn(data.leaveEnemy.Type, data.leaveEnemy.Variant, data.leaveEnemy.SubType, room:GetGridPosition(room:GetGridIndex(proj.Position)), Vector.Zero, proj)
				spawn:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				--spawn.State = data.enemyState
				spawn.HitPoints = data.hitPoints
				spawn:Update()
			elseif data.enemyProjDeath then
				data.enemyProjDeath(data.enemyProjEnt, proj)
			end
		end
	end
end, 8)

mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, function(_, proj)
	local data = mod:GetEntityData(proj)
	if data.gridProjectile then
		if data.leaveCustomGrid then
			local Callbacks = require("scripts.stageapi.enums.Callbacks")
			data.leaveCustomGrid:CallCallbacks(Callbacks.POST_CUSTOM_GRID_DESTROY, proj)
		elseif data.specialGridDeath then
			data.specialGridDeath(proj)
		end
	elseif data.enemyTurnedProjectile then
		if data.enemyProjDeath then
			data.enemyProjDeath(data.enemyProjEnt, proj)
		end
	end
end, 8)

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, proj)
	local sprite = proj:GetSprite()
	local data = mod:GetEntityData(proj)

	if data.projAnim then
		mod:spritePlay(sprite, data.projAnim)
		if data.projAnimOverlay then
			mod:spriteOverlayPlay(sprite, data.projAnimOverlay)
		end
	end

	if data.gridProjectile then
		if data.leaveCustomGrid then
			data.leaveCustomGrid.PersistentData.Destroyed = true
		end

		if proj:IsDead() then
			local room = game:GetRoom()
			local index = room:GetGridIndex(proj.Position)
			local anim = sprite:GetAnimation()
			local frame = sprite:GetFrame()
			local flipX = sprite.FlipX

			if data.leaveGrid ~= nil and canOverwriteGridAtPos(proj.Position) then
				proj.SubType = 0
				data.leavingGrid = true
				if data.leaveCustomGrid then
					--data.leaveCustomGrid.GridConfig:Spawn(index, false, false, data.leaveCustomGrid.PersistentData)
					if data.leaveCustomGrid.Data.Effect then
						if data.leaveCustomGrid.Data.Effect:Exists() then
							data.leaveCustomGrid.Data.Effect:Remove()
						end

						data.leaveCustomGrid.Data.Effect = nil
					end
					local newGrid = data.leaveCustomGrid.GridConfig:Spawn(index, false, false, nil)
					local gridEnt = room:GetGridEntity(index)
					if gridEnt then
						if data.customAltRock and sprite:GetFilename() == "gfx/grid/grid_rock.anm2" then
							local roomgfx = mod:getCurrentRoomGfx()
							local backdropType = room:GetBackdropType()
							local rSprite = gridEnt:GetSprite()
							if roomgfx and roomgfx.Grids and roomgfx.Grids.Rocks then
								rSprite:ReplaceSpritesheet(0, roomgfx.Grids.Rocks)
								rSprite:LoadGraphics()
							elseif mod.backdropRockSpritesheets[backdropType] then
								rSprite:ReplaceSpritesheet(0, mod.backdropRockSpritesheets[backdropType])
								rSprite:LoadGraphics()
							end
						end
						gridEnt:GetSprite():SetFrame(anim, frame)
						gridEnt:GetSprite().FlipX = flipX
						gridEnt.State = data.gridState
					end
					data.leaveCustomGrid:Remove(true)
				else
					Isaac.GridSpawn(data.leaveGrid[1], data.leaveGrid[2], proj.Position, true)
					local gridEnt = room:GetGridEntity(index)
					if gridEnt then
						gridEnt:GetSprite():SetFrame(anim, frame)
						gridEnt:GetSprite().FlipX = flipX
						gridEnt.State = data.gridState

						local gridType = gridEnt:GetType()
						if gridType < 7 or gridType == 22 or gridType == 25 or gridType == 26 or gridType == 27 then
							local roomgfx = mod:getCurrentRoomGfx()
							local backdropType = room:GetBackdropType()
							local rSprite = gridEnt:GetSprite()

							if data.d12 then
								if data.d12 == 1 then
									rSprite:ReplaceSpritesheet(0, "gfx/grid/rocks_d12.png")
								elseif data.d12 == 2 then
									rSprite:ReplaceSpritesheet(0, "gfx/grid/rocks_ed12.png")
								end
								rSprite:LoadGraphics()
							elseif roomgfx and roomgfx.Grids and roomgfx.Grids.Rocks then
								rSprite:ReplaceSpritesheet(0, roomgfx.Grids.Rocks)
								rSprite:LoadGraphics()
							elseif mod.backdropRockSpritesheets[backdropType] then
								rSprite:ReplaceSpritesheet(0, mod.backdropRockSpritesheets[backdropType])
								rSprite:LoadGraphics()
							end
						end
					end
				end
			elseif data.leaveCustomGrid then
				local Callbacks = require("scripts.stageapi.enums.Callbacks")
				data.leaveCustomGrid:CallCallbacks(Callbacks.POST_CUSTOM_GRID_DESTROY, proj)
				--[[if data.d122Wisp then
					local wisp = Isaac.Spawn(3, FamiliarVariant.WISP, CollectibleType.COLLECTIBLE_D12_2, proj.Position, Vector.Zero, proj):ToFamiliar()
					wisp.Player = data.d122WispSpawner
				end]]
			elseif data.specialGridDeath then
				data.specialGridDeath(proj)
				--[[if data.d122Wisp then
					local wisp = Isaac.Spawn(3, FamiliarVariant.WISP, CollectibleType.COLLECTIBLE_D12_2, proj.Position, Vector.Zero, proj):ToFamiliar()
					wisp.Player = data.d122WispSpawner
				end]]
			end
		end
	elseif data.enemyTurnedProjectile then
		if proj:IsDead() then
			local game = Game()
			local room = game:GetRoom()
			local index = room:GetGridIndex(proj.Position)

			if room:GetGridCollisionAtPos(proj.Position) == GridCollisionClass.COLLISION_NONE and data.leaveEnemy then
				local spawn = Isaac.Spawn(data.leaveEnemy.Type, data.leaveEnemy.Variant, data.leaveEnemy.SubType, room:GetGridPosition(room:GetGridIndex(proj.Position)), Vector.Zero, proj)
				spawn:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				--spawn.State = data.enemyState
				spawn.HitPoints = data.hitPoints
				spawn:Update()
			elseif data.enemyProjDeath then
				data.enemyProjDeath(data.enemyProjEnt, proj)
			end
		end
	end
end, 40)

mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, function(_, proj)
	local data = mod:GetEntityData(proj)
	if data.gridProjectile then
		if data.leaveCustomGrid then
			local Callbacks = require("scripts.stageapi.enums.Callbacks")
			data.leaveCustomGrid:CallCallbacks(Callbacks.POST_CUSTOM_GRID_DESTROY, proj)
		elseif data.specialGridDeath then
			data.specialGridDeath(proj)
		end
	elseif data.enemyTurnedProjectile then
		if data.enemyProjDeath then
			data.enemyProjDeath(data.enemyProjEnt, proj)
		end
	end
end, 40)


--Decoration remover for removed grids
function mod:makeDecorInvisible(index)
	local data = FiendFolio.savedata.run
	local level = game:GetLevel()
	local currentRoom = level:GetCurrentRoomDesc().ListIndex

	if not data.invisibleDecor then
		data.invisibleDecor = {}
	end
	if data.invisibleDecor[currentRoom] == nil then
		data.invisibleDecor[currentRoom] = {}
	end
	table.insert(data.invisibleDecor[currentRoom], index)
end

function mod:makeRockForRoomOnly(index)
	local data = FiendFolio.savedata.run
	local level = game:GetLevel()
	local currentRoom = level:GetCurrentRoomDesc().ListIndex

	if not data.currentRoomTempRock then
		data.currentRoomTempRock = {}
	end
	if data.currentRoomTempRock[currentRoom] == nil then
		data.currentRoomTempRock[currentRoom] = {}
	end
	table.insert(data.currentRoomTempRock[currentRoom], index)
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	local data = FiendFolio.savedata.run
	local level = game:GetLevel()
	local room = game:GetRoom()
	if data.invisibleDecor then
		for list,rooms in pairs(data.invisibleDecor) do
			if level:GetCurrentRoomDesc().ListIndex == list then
				for key,index in pairs(rooms) do
					local deco = room:GetGridEntity(index)
					if deco and deco:GetType() == 1 then
						local sprite = deco:GetSprite()
						sprite:ReplaceSpritesheet(0, "gfx/nothing.png")
						sprite:LoadGraphics()
					else
						rooms[key] = nil
					end
				end
			end
		end
	end
	if data.currentRoomTempRock then
		for list,rooms in pairs(data.currentRoomTempRock) do
			if level:GetCurrentRoomDesc().ListIndex == list then
				for key,index in pairs(rooms) do
					local grid = room:GetGridEntity(index)
					if grid and grid.CollisionClass ~= GridCollisionClass.COLLISION_NONE then
						room:RemoveGridEntity(index, 0, false)
						FiendFolio.scheduleForUpdate(function()
							room:SpawnGridEntity(index, 1, 0, 0, 0)
							local newRock = room:GetGridEntity(index)
							local temp = newRock:GetSprite()
							temp:ReplaceSpritesheet(0, "gfx/nothing.png")
							temp:LoadGraphics()
							mod:makeDecorInvisible(index)
						end, 2)
					else
						rooms[key] = nil
					end
				end
			end
		end
	end
end)

function mod.setRockTable()
	mod.roomRockTable = {}
	mod.roomRockPitTable = {}
	mod.smallerRockRocks = {}
	local validTypes = {2, 4, 5, 6, 22, 25, 26, 27}
	for _,grid in ipairs(mod.GetGridEntities()) do
		if grid.CollisionClass == GridCollisionClass.COLLISION_SOLID then
			for i=1,#validTypes do
				if grid:GetType() == validTypes[i] then
					mod.roomRockTable[grid:GetGridIndex()] = validTypes[i]
					mod.roomRockPitTable[grid:GetGridIndex()] = validTypes[i]
				end
			end
			if grid:GetType() == GridEntityType.GRID_ROCKT then
				mod.smallerRockRocks[grid:GetGridIndex()] = 4
				--mod.perfectVermin[grid:GetGridIndex()] = 4
				--mod.shampooBottleRocks[grid:GetGridIndex()] = 4
			end
		end
		if grid:GetType() == 7 and grid.State == 0 then
			mod.roomRockPitTable[grid:GetGridIndex()] = 7
		end
	end

	mod.chainGeodeRocks = mod.roomRockPitTable
	mod.fakeRockRocks = mod:makeCopiedTable(mod.roomRockTable)
	mod.gravestoneRocks = mod:makeCopiedTable(mod.roomRockTable)
	mod.gasPocketRocks = mod:makeCopiedTable(mod.roomRockTable)
	mod.powerRockRocks = mod:makeCopiedTable(mod.roomRockTable)
	mod.GenericRockBreakRocks = mod:makeCopiedTable(mod.roomRockTable)
	return mod.roomRockTable
end