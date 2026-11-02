local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local amonCave = StageAPI.RoomsList("FFAmonCave", include("resources.luarooms.amonsecret"))

function mod.SpawnAmonManCave()
	local defaultMap = StageAPI.GetDefaultLevelMap()
	local hubRoom = StageAPI.LevelRoom{
		RoomsList = amonCave,
		IgnoreDoors = true,
		IgnoreShape = true,
		RoomType = RoomType.ROOM_DEFAULT,
		RequireRoomType = true,
		IsExtraRoom = true,
	}

	hubRoom.PersistentData.ReturnData = {
		DoorSlot = DoorSlot.DOWN0,
		ReturnSlot = DoorSlot.UP0,
		ReturnIndex = game:GetLevel():GetCurrentRoomDesc().SafeGridIndex,
	}

	defaultMap:AddRoom(hubRoom, {RoomID = "AmonHub"}, true)
	local hubData = defaultMap:GetRoomDataFromRoomID("AmonHub")

	local treasureRoom = StageAPI.LevelRoom{
		RoomsList = amonCave,
		IgnoreDoors = true,
		IgnoreShape = true,
		Shape = RoomShape.ROOMSHAPE_1x1,
		RoomType = RoomType.ROOM_TREASURE,
		RequireRoomType = true,
		IsExtraRoom = true,
	}

	treasureRoom.PersistentData.ReturnData = {
		DoorSlot = DoorSlot.RIGHT0,
		ReturnSlot = DoorSlot.LEFT0,
		ReturnIndex = hubData.MapID,
	}

	local challengeRoom = StageAPI.LevelRoom{
		RoomsList = amonCave,
		IgnoreDoors = true,
		IgnoreShape = true,
		RoomType = RoomType.ROOM_CHALLENGE,
		RequireRoomType = true,
		IsExtraRoom = true,
	}

	challengeRoom.PersistentData.ReturnData = {
		DoorSlot = DoorSlot.LEFT0,
		ReturnSlot = DoorSlot.RIGHT0,
		ReturnIndex = hubData.MapID,
	}
	
	defaultMap:AddRoom(treasureRoom, {RoomID = "AmonTreasure"}, true)
	defaultMap:AddRoom(challengeRoom, {RoomID = "AmonChallenge"}, true)
	StageAPI.SpawnCustomDoor(DoorSlot.UP0, hubData.MapID, StageAPI.DefaultLevelMapID, "FF_AmonHole", nil, DoorSlot.DOWN0, nil, nil, nil, true)
	mod:EnableManualCallback(ModCallbacks.MC_POST_UPDATE, mod.AmonZoneOnUpdate)
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	if StageAPI.GetCurrentRoomID() == "AmonHub" then
		local room = game:GetRoom()

		if room:IsFirstVisit() then
			local defaultMap = StageAPI:GetDefaultLevelMap()
			local hubRoomData = defaultMap:GetRoomDataFromRoomID("AmonHub")
			local hubData = defaultMap:GetRoom(hubRoomData).PersistentData.ReturnData
			StageAPI.SpawnCustomDoor(hubData.DoorSlot, hubData.ReturnIndex, nil, "FF_AmonHole", nil, hubData.ReturnSlot)

			local treasureRoomData = defaultMap:GetRoomDataFromRoomID("AmonTreasure")
			StageAPI.SpawnCustomDoor(DoorSlot.LEFT0, treasureRoomData.MapID, StageAPI.DefaultLevelMapID, "SecretDoor", nil, DoorSlot.RIGHT0, nil, nil, nil, true)

			local challengeRoomData = defaultMap:GetRoomDataFromRoomID("AmonChallenge")
			StageAPI.SpawnCustomDoor(DoorSlot.RIGHT0, challengeRoomData.MapID, StageAPI.DefaultLevelMapID, "BossDoor", nil, DoorSlot.LEFT0, nil, nil, nil, true)
		end

		if mod.savedata.run.AmonChallengeFinished then
			mod.savedata.run.AmonChallengeFinished = nil
			Isaac.Spawn(5, 100, mod.ITEM.COLLECTIBLE.COOL_SKULL_INSIGNIA, Vector(320, 280), Vector.Zero, nil)
		end
	elseif StageAPI.GetCurrentRoomID() == "AmonTreasure" then
		if game:GetRoom():IsFirstVisit() then
			local defaultMap = StageAPI:GetDefaultLevelMap()
			local roomData = defaultMap:GetRoomDataFromRoomID("AmonTreasure")
			local data = defaultMap:GetRoom(roomData).PersistentData.ReturnData
			StageAPI.SpawnCustomDoor(data.DoorSlot, data.ReturnIndex, StageAPI.DefaultLevelMapID, "SecretDoor", nil, data.ReturnSlot)
		end
	elseif StageAPI.GetCurrentRoomID() == "AmonChallenge" then
		if game:GetRoom():IsFirstVisit() then
			local defaultMap = StageAPI:GetDefaultLevelMap()
			local roomData = defaultMap:GetRoomDataFromRoomID("AmonChallenge")
			local data = defaultMap:GetRoom(roomData).PersistentData.ReturnData
			StageAPI.SpawnCustomDoor(data.DoorSlot, data.ReturnIndex, StageAPI.DefaultLevelMapID, "BossDoor", nil, data.ReturnSlot)
		end
	end
end)

-- So I can't figure out how to modify the behaviour of the actual StageAPI ambush door
-- So I'm just using a door with the behaviour I want and reskinning it to look like an ambush door
StageAPI.AddCallback("FiendFolio", "POST_SPAWN_CUSTOM_DOOR", 1, function(door, data, sprite, doorData, customGrid)
	local roomID = StageAPI.GetCurrentRoomID()
	if roomID == "AmonHub" or roomID == "AmonChallenge" then
		sprite:Load("gfx/grid/door_03_ambushroomdoor.anm2", true)
	end
end, "BossDoor")

StageAPI.AddCallback("FiendFolio", "POST_SPAWN_CUSTOM_DOOR", 1, function(door, data, sprite, doorData, customGrid)
	sprite:Load("gfx/grid/amonholedoor.anm2", true)
end, "FF_AmonHole")

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, function()
	if StageAPI:GetCurrentRoomID() == "AmonChallenge" then 
		mod.savedata.run.AmonChallengeFailed = true
	end
end, 1)

StageAPI.AddCallback("FiendFolio", "POST_ROOM_CLEAR", 1, function()
	if StageAPI:GetCurrentRoomID() == "AmonChallenge" then 
		if not mod.savedata.run.AmonChallengeFailed then
			mod.savedata.run.AmonChallengeFinished = true

			game:ShakeScreen(30)
			sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 0.7, 0, false, 0.6)
			sfx:Play(mod.Sounds.BadToTheBone, 0.5)
		end
	end
end)

local function isRoomAnyAmonZone(roomID)
	return (
		roomID == "AmonHub" or
		roomID == "AmonTreasure" or 
		roomID == "AmonChallenge"
	)
end

function mod.AmonZoneOnUpdate() -- StageAPI is going to ruin my life
	if StageAPI:GetCurrentRoomID() == "AmonTreasure" then
		local room = game:GetRoom()
		if room:GetFrameCount() > 0 and not room:IsClear() and room:GetAliveEnemiesCount() == 0 then
			room:SetClear(true)
			room:TriggerClear()
		end
	end

	if isRoomAnyAmonZone(StageAPI:GetCurrentRoomID()) then
		game:Darken(1, 1)
	end
end
mod:AddManualCallback(ModCallbacks.MC_POST_UPDATE, mod.AmonZoneOnUpdate)

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
	mod:DisableManualCallback(ModCallbacks.MC_POST_UPDATE, mod.AmonZoneOnUpdate)
end)