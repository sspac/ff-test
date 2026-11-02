-- Room Blocking --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

mod.RoomBlockingEntities = {
	-- Vending Machines
	[mod.FF.VendingMachine.ID .. " " .. mod.FF.VendingMachine.Var] = {Func = mod.IsVendingMachineLocked},
	[mod.FF.VendingMachine.ID .. " " .. mod.FF.VendingMachineFF.Var] = {Func = mod.IsVendingMachineLocked},
	
	-- The Gate is Open
	[EntityType.ENTITY_STONEY] = {VanillaAchievement = Achievement.THE_GATE_IS_OPEN},
	[EntityType.ENTITY_MUSHROOM] = {VanillaAchievement = Achievement.THE_GATE_IS_OPEN},
	[mod.FF.MobileMushroom.ID .. " " .. mod.FF.MobileMushroom.Var] = {VanillaAchievement = Achievement.THE_GATE_IS_OPEN},
	[EntityType.ENTITY_POISON_MIND] = {VanillaAchievement = Achievement.THE_GATE_IS_OPEN},
	[mod.FF.ToxicKnight.ID .. " " .. mod.FF.ToxicKnight.Var] = {VanillaAchievement = Achievement.THE_GATE_IS_OPEN},
	[mod.FF.FloatingToxicKnight.ID .. " " .. mod.FF.FloatingToxicKnight.Var] = {VanillaAchievement = Achievement.THE_GATE_IS_OPEN},
	[EntityType.ENTITY_BLISTER] = {VanillaAchievement = Achievement.THE_GATE_IS_OPEN},
	[EntityType.ENTITY_THE_THING] = {VanillaAchievement = Achievement.THE_GATE_IS_OPEN},
	[EntityType.ENTITY_MINISTRO] = {VanillaAchievement = Achievement.THE_GATE_IS_OPEN},
	[EntityType.ENTITY_PORTAL] = {VanillaAchievement = Achievement.THE_GATE_IS_OPEN},
	[EntityType.ENTITY_NERVE_ENDING .. " " .. 1] = {VanillaAchievement = Achievement.THE_GATE_IS_OPEN},
}

local function getRoomDifficulties(levelstage, gamemode)
	if gamemode == Difficulty.DIFFICULTY_NORMAL then
		if levelstage == LevelStage.STAGE1_1 or levelstage == LevelStage.STAGE2_1 or
		   levelstage == LevelStage.STAGE3_1 or levelstage == LevelStage.STAGE4_1
		then
			return 1, 5
		elseif levelstage == LevelStage.STAGE1_2 or levelstage == LevelStage.STAGE2_2 or
		       levelstage == LevelStage.STAGE3_2 or levelstage == LevelStage.STAGE4_2
		then
			return 5, 10
		else
			return 1, 10
		end
	else
		if levelstage == LevelStage.STAGE1_1 or levelstage == LevelStage.STAGE2_1 or
		   levelstage == LevelStage.STAGE3_1 or levelstage == LevelStage.STAGE4_1
		then
			return 5, 10
		elseif levelstage == LevelStage.STAGE1_2 or levelstage == LevelStage.STAGE2_2 or
		       levelstage == LevelStage.STAGE3_2 or levelstage == LevelStage.STAGE4_2
		then
			return 10, 15
		else
			return 5, 15
		end
	end
end

local function stageEnumToStbAndSubtype(levelstage, stagetype)
	local callbackReturns = Isaac.RunCallback(mod.CALLBACK.GET_STAGE_STBTYPE, game:GetLevel())
	if callbackReturns ~= nil then
		return callbackReturns.StbType
	end

	local stbType = StbType.BASEMENT
	if levelstage == LevelStage.STAGE1_1 or levelstage == LevelStage.STAGE1_2 then
		if stagetype == StageType.STAGETYPE_ORIGINAL then
			stbType = StbType.BASEMENT
		elseif stagetype == StageType.STAGETYPE_WOTL then
			stbType = StbType.CELLAR
		elseif stagetype == StageType.STAGETYPE_AFTERBIRTH then
			stbType = StbType.BURNING_BASEMENT
		elseif stagetype == StageType.STAGETYPE_REPENTANCE then
			stbType = StbType.DOWNPOUR
		elseif stagetype == StageType.STAGETYPE_REPENTANCE_B then
			stbType = StbType.DROSS
		end
	elseif levelstage == LevelStage.STAGE2_1 or levelstage == LevelStage.STAGE2_2 then
		if stagetype == StageType.STAGETYPE_ORIGINAL then
			stbType = StbType.CAVES
		elseif stagetype == StageType.STAGETYPE_WOTL then
			stbType = StbType.CATACOMBS
		elseif stagetype == StageType.STAGETYPE_AFTERBIRTH then
			stbType = StbType.FLOODED_CAVES
		elseif stagetype == StageType.STAGETYPE_REPENTANCE then
			stbType = StbType.MINES
		elseif stagetype == StageType.STAGETYPE_REPENTANCE_B then
			stbType = StbType.ASHPIT
		end
	elseif levelstage == LevelStage.STAGE3_1 or levelstage == LevelStage.STAGE3_2 then
		if stagetype == StageType.STAGETYPE_ORIGINAL then
			stbType = StbType.DEPTHS
		elseif stagetype == StageType.STAGETYPE_WOTL then
			stbType = StbType.NECROPOLIS
		elseif stagetype == StageType.STAGETYPE_AFTERBIRTH then
			stbType = StbType.DANK_DEPTHS
		elseif stagetype == StageType.STAGETYPE_REPENTANCE then
			stbType = StbType.MAUSOLEUM
		elseif stagetype == StageType.STAGETYPE_REPENTANCE_B then
			stbType = StbType.GEHENNA
		end
	elseif levelstage == LevelStage.STAGE4_1 or levelstage == LevelStage.STAGE4_2 then
		if stagetype == StageType.STAGETYPE_ORIGINAL then
			stbType = StbType.WOMB
		elseif stagetype == StageType.STAGETYPE_WOTL then
			stbType = StbType.UTERO
		elseif stagetype == StageType.STAGETYPE_AFTERBIRTH then
			stbType = StbType.SCARRED_WOMB
		elseif stagetype == StageType.STAGETYPE_REPENTANCE then
			stbType = StbType.CORPSE
		end
	elseif levelstage == LevelStage.STAGE5 then
		if stagetype == StageType.STAGETYPE_ORIGINAL then
			stbType = StbType.SHEOL
		elseif stagetype == StageType.STAGETYPE_WOTL then
			stbType = StbType.CATHEDRAL
		end
	elseif levelstage == LevelStage.STAGE6 then
		if stagetype == StageType.STAGETYPE_ORIGINAL then
			stbType = StbType.DARK_ROOM
		elseif stagetype == StageType.STAGETYPE_WOTL then
			stbType = StbType.CHEST
		end
	end
	return stbType
end

function mod:roomHasBlockingEntity(roomConfig)
	local spawns = roomConfig.Spawns
	if spawns then
		for i = 0, spawns.Size - 1 do
			local spawnlist = spawns:Get(i)
			if spawnlist then
				local entries = spawnlist.Entries
				if entries then
					for j = 0, entries.Size - 1 do
						local entry = entries:Get(j)
						if entry then
							local blockingInfo = mod.RoomBlockingEntities[entry.Type .. " " .. entry.Variant .. " " .. entry.Subtype] or
							                     mod.RoomBlockingEntities[entry.Type .. " " .. entry.Variant] or
							                     mod.RoomBlockingEntities[entry.Type]
							if blockingInfo then
								if blockingInfo.Achievement and not blockingInfo.Achievement:IsUnlocked() then
									return true
								elseif blockingInfo.VanillaAchievement and not Isaac.GetPersistentGameData():Unlocked(blockingInfo.VanillaAchievement) then
									return true
								elseif blockingInfo.Func and blockingInfo.Func(entry) then
									return true
								end
							end
						end
					end
				end
			end
		end
	end
	return false
end

local failedToGenerate = false
mod:AddPriorityCallback(ModCallbacks.MC_PRE_LEVEL_PLACE_ROOM, CallbackPriority.LATE, function(_, slot, roomConfig, seed)
	if failedToGenerate or game:IsGreedMode() then return end

	if slot:GenerationIndex() ~= 0 then
		local stbtype = roomConfig.StageID
		local roomType = roomConfig.Type
		local subtype = roomConfig.Subtype
		local gamemode = game.Difficulty
		local roomShape = roomConfig.Shape
		local difficulty = roomConfig.Difficulty
		local doors = roomConfig.Doors
		
		local newRoomConfig = roomConfig
		local attempts = 0
		while attempts < 1000 do
			if not mod:roomHasBlockingEntity(newRoomConfig) then
				if attempts > 0 then
					return newRoomConfig
				else
					return
				end
			else
				if stbtype == StbType.VOID then -- temp measure cause rgon bug
					stbtype = StbType.BASEMENT
				end
				newRoomConfig = RoomConfigHolder.GetRandomRoom(math.max(1, seed + attempts*2000000 % math.maxinteger), true, 
															   stbtype, roomType, roomShape, 0, -1, 
															   difficulty, difficulty, doors, subtype)
				attempts = attempts + 1
			end
		end
		failedToGenerate = true
	end
end)

mod:AddCallback(ModCallbacks.MC_PRE_LEVEL_INIT, function()
	failedToGenerate = false
end)

mod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_LEVEL, CallbackPriority.LATE, function()
	if failedToGenerate then
		failedToGenerate = false
		Isaac.ExecuteCommand("reseed")
	end
end)
