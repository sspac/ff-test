local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local roomsList = StageAPI.RoomsList("TheFinalOptionRooms", include("resources.luarooms.thefinaloption"))
local finalOption = mod.ITEM.COLLECTIBLE.THE_FINAL_OPTION
local incrementation = 0 -- Just in case. I'm very aware of Diplo existing

-- levelMap:RemoveRoom(removeRoomData: LevelMap.RoomData, noUpdateDoors: bool, noRemoveLevelData: bool)
-- levelMap:GetRoomDataFromRoomID(roomID: int) -> LevelMap.RoomData

local poolsOrder = {
	ItemPoolType.POOL_TREASURE,
	ItemPoolType.POOL_SHOP,
	ItemPoolType.POOL_LIBRARY,
	ItemPoolType.POOL_TREASURE,
	ItemPoolType.POOL_DEVIL,
	ItemPoolType.POOL_ANGEL,
	ItemPoolType.POOL_PLANETARIUM,
	ItemPoolType.POOL_ULTRA_SECRET,
}

local roomDoorSlotToFinalDoorSlot = {
	[DoorSlot.LEFT0] = DoorSlot.RIGHT0,
	[DoorSlot.LEFT1] = DoorSlot.RIGHT0,
	[DoorSlot.UP0] = DoorSlot.DOWN0,
	[DoorSlot.UP1] = DoorSlot.DOWN0,
	[DoorSlot.RIGHT0] = DoorSlot.LEFT0,
	[DoorSlot.RIGHT1] = DoorSlot.LEFT0,
	[DoorSlot.DOWN0] = DoorSlot.UP0,
	[DoorSlot.DOWN1] = DoorSlot.UP0,
}

local bannedRoomTypes = {
	[RoomType.ROOM_SHOP] = true,
	[RoomType.ROOM_TREASURE] = true,
	[RoomType.ROOM_LIBRARY] = true,
	[RoomType.ROOM_DEVIL] = true,
	[RoomType.ROOM_ANGEL] = true,
	[RoomType.ROOM_PLANETARIUM] = true,
	[RoomType.ROOM_ULTRASECRET] = true,
}

mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, function(_, item, charge, first, slot, varData, player)
	if not first then return end

	local level = game:GetLevel()
	local room = game:GetRoom()
	local roomID = "FinalOptionRoom" .. incrementation
	incrementation = incrementation + 1

	if room:GetType() == RoomType.ROOM_ERROR and not mod.ACHIEVEMENT.THE_FINAL_OPTION:IsUnlocked(true) then
		mod.ACHIEVEMENT.THE_FINAL_OPTION:Unlock()
	end

	local defaultMap = StageAPI.GetDefaultLevelMap()
	local optionRoom = StageAPI.LevelRoom{
		RoomsList = roomsList,
		HasWaterPits = false,
		IgnoreDoors = true,
		IgnoreShape = true,
		RoomType = RoomType.ROOM_SUPERSECRET,
		IsExtraRoom = true,
	}

	local returnMap = nil
	local returnIndex = game:GetLevel():GetCurrentRoomDesc().SafeGridIndex
	local selectedDoorSlot = 0
	local doorSet = level:GetCurrentRoomDesc().Data.Doors

	for i = 0, 7 do
		if doorSet & (1 << i) ~= 0 then
			selectedDoorSlot = i
			break
		end
	end

	if StageAPI.CurrentLevelMapRoomID then
		returnMap = StageAPI.CurrentLevelMapID
		returnIndex = StageAPI.CurrentLevelMapRoomID

		local currentMap = StageAPI.GetCurrentLevelMap()
		local currentRoomData = currentMap:GetRoom(currentMap:GetRoomDataFromRoomID(StageAPI.GetCurrentRoomID()))
		local doorSet = currentRoomData.Doors

		for i = 0, #doorSet - 1 do
			if doorSet[i] then
				selectedDoorSlot = i
				break
			end
		end
	end

	optionRoom.PersistentData.ReturnData = {
		Key = "FF_FinalOptionDoor",
		DoorSlot = roomDoorSlotToFinalDoorSlot[selectedDoorSlot],
		ReturnSlot = selectedDoorSlot,
		ReturnMap = returnMap,
		ReturnIndex = returnIndex,
	}

	defaultMap:AddRoom(optionRoom, {RoomID = roomID}, true)
	local roomData = defaultMap:GetRoomDataFromRoomID(roomID)
	StageAPI.ExtraRoomTransition(roomData.MapID, nil, RoomTransitionAnim.PIXELATION, StageAPI.DefaultLevelMapID, selectedDoorSlot, roomDoorSlotToFinalDoorSlot[selectedDoorSlot])
end, finalOption)

local function sortFunction(a, b)
	return a.Position.Y == b.Position.Y and a.Position.X < b.Position.X or a.Position.Y < b.Position.Y -- Why can't this just be an if/else lua :((((
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	if string.sub(StageAPI.GetCurrentRoomID(), 1, 15) == "FinalOptionRoom" then
		game:GetRoom():SetBackdropType(BackdropType.DARK_CLOSET, 1)
		mod.SetTaintedCainCanPickCollectiblesInRoom()
		
		if game:GetRoom():IsFirstVisit() then
			local pool = game:GetItemPool()
			local rng = Isaac.GetPlayer():GetCollectibleRNG(finalOption)

			local items = Isaac.FindByType(5, 100) -- why aren't they sorted by position, how tf does findbytype even work man
			table.sort(items, sortFunction)

			for i, pickup in ipairs(items) do
				pickup = pickup:ToPickup()

				local index = ((i - 1) % #poolsOrder) + 1
				local removeNO = false

				if poolsOrder[index] ~= ItemPoolType.POOL_LIBRARY then
					if not PlayerManager.AnyoneHasTrinket(TrinketType.TRINKET_NO) then
						removeNO = Isaac.GetPlayer():AddSmeltedTrinket(TrinketType.TRINKET_NO, false)
					end
				end

				local item = pool:GetCollectible(poolsOrder[index], true, rng:Next())
				pickup:Morph(5, 100, item)
			
				if removeNO then
					Isaac.GetPlayer():TryRemoveSmeltedTrinket(TrinketType.TRINKET_NO)
				end
			end

			local defaultMap = StageAPI.GetDefaultLevelMap()
			local roomData = defaultMap:GetRoomDataFromRoomID(StageAPI.GetCurrentRoomID())
			local data = defaultMap:GetRoom(roomData).PersistentData.ReturnData
			StageAPI.SpawnCustomDoor(data.DoorSlot, data.ReturnIndex, data.ReturnMap, "FF_FinalOptionDoor", nil, data.ReturnSlot)
		end
	end
end)

local function allowPickup(_, pickup, collider)
	if not collider:ToPlayer() or collider:ToPlayer():GetPlayerType() ~= PlayerType.PLAYER_CAIN_B then return end

	local challengeCache = game.Challenge
	game.Challenge = Challenge.CHALLENGE_CANTRIPPED

	mod:AddOneTimeCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, function()
		game.Challenge = challengeCache
	end, 100)

	Isaac.CreateTimer(function() -- Fallback
		game.Challenge = challengeCache
	end, 0, 1)
end

local function resetAllowPickup()
	mod:DisableManualCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, allowPickup)
	mod:DisableManualCallback(ModCallbacks.MC_POST_NEW_ROOM, resetAllowPickup)
end

mod:AddPriorityManualCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, CallbackPriority.LATE, allowPickup, 100)
mod:AddManualCallback(ModCallbacks.MC_POST_NEW_ROOM, resetAllowPickup)

function mod.SetTaintedCainCanPickCollectiblesInRoom(b)
	if b or b == nil then
		mod:EnableManualCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, allowPickup)
		mod:EnableManualCallback(ModCallbacks.MC_POST_NEW_ROOM, resetAllowPickup)
	elseif not b then
		resetAllowPickup()
	end
end

mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, function(_, item, charge, first, slot, varData, player)
	if item == finalOption or not first then return end
	if string.match(StageAPI.GetCurrentRoomID(), "FinalOptionRoom") and not mod.savedata.run.FinalOptionUsed then
		mod.savedata.run.FinalOptionUsed = true

		game:ShakeScreen(30)
		game:Darken(1, 150)
		game:GetHUD():ShowItemText("Your Fate is Sealed...", "")

		sfx:Play(SoundEffect.SOUND_SIREN_MINION_SMOKE, 5, 0, false, 0.3)
		sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 0.7, 0, false, 0.6)
	end
end)

StageAPI.AddCallback("FiendFolio", "POST_SPAWN_CUSTOM_DOOR", 1, function(door, data, sprite, doorData, customGrid)
	sprite:Load("gfx/grid/door_house.anm2", false)
	for i = 0, 4 do sprite:ReplaceSpritesheet(i, "gfx/grid/door_closet_red.png") end
	sprite:LoadGraphics()
end, "FF_FinalOptionDoor")

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
	incrementation = 0
end)

mod:AddCallback(ModCallbacks.MC_PRE_LEVEL_PLACE_ROOM, function(_, generatorRoomSlot, roomConfig, seed)
	if mod.savedata and mod.savedata.run and mod.savedata.run.FinalOptionUsed then
		if bannedRoomTypes[roomConfig.Type] then
			local stage = Isaac.GetCurrentStageConfigId()
			-- If Void then choose a random stage instead, because Void doesn't have rooms
			if stage == StbType.VOID then
				local randomFloors = {}
				for stb = StbType.BASEMENT, StbType.CHEST do
					table.insert(randomFloors, stb)
				end
			
				-- REPENTOGON lets you have alt path rooms but 
				if Options.BetterVoidGeneration then
					for stb = StbType.DOWNPOUR, StbType.CORPSE do
						table.insert(randomFloors, stb)
					end
				end

				stage = mod:RandomIndex(randomFloors)
			end
			return RoomConfigHolder.GetRandomRoom(seed, true, stage, RoomType.ROOM_DEFAULT, roomConfig.Shape, 0, -1, 0, 10, roomConfig.Doors)
		end
	end
end)

mod:AddPriorityCallback(ModCallbacks.MC_POST_DEVIL_CALCULATE, CallbackPriority.LATE, function()
	if mod.savedata and mod.savedata.run and mod.savedata.run.FinalOptionUsed then
		return 0
	end
end)

mod:AddCallback(ModCallbacks.MC_PRE_CHANGE_ROOM, function(_, targetIndex, dimension)
	if targetIndex == GridRooms.ROOM_DEVIL_IDX and mod.savedata and mod.savedata.run and mod.savedata.run.FinalOptionUsed then
		local level = game:GetLevel()
		local newIndex = level:QueryRoomTypeIndex(RoomType.ROOM_DEFAULT, false, Isaac.GetPlayer():GetCollectibleRNG(finalOption))
		return {newIndex, dimension}
	end
end)

-- As it currently stands, the game will only offer you The Final Option as an unlock once per each time the game is launched
local glitchState = 0
local function areRequiredRoomTypesUnlocked()
	local gameData = Isaac.GetPersistentGameData()

	return (
		gameData:Unlocked(Achievement.PLANETARIUMS) and
		gameData:Unlocked(Achievement.RED_KEY) -- Ultra Secret Room
	)
end

mod:AddCallback(ModCallbacks.MC_PRE_GET_COLLECTIBLE, function(_, pool, decrease, seed)
	if game:GetRoom():GetType() == RoomType.ROOM_ERROR and glitchState == 0 and game.Difficulty <= Difficulty.DIFFICULTY_HARD and game.Challenge == 0 then
		if not mod.ACHIEVEMENT.THE_FINAL_OPTION:IsUnlocked(true) then
			if areRequiredRoomTypesUnlocked() then
				glitchState = 1
			end
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
	if glitchState == 1 then
		pickup:AddEntityFlags(EntityFlag.FLAG_GLITCH)
		sfx:Play(SoundEffect.SOUND_EDEN_GLITCH)
		glitchState = 2
	end
end, 100)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
	if pickup.SubType > 4294967000 and glitchState == 2 and pickup.FrameCount > 5 then -- I'm going to just assume you haven't made more than 300 glitch items this run
		pickup:Morph(5, 100, finalOption, true, true, true)
		glitchState = 3
	end
end, 100)