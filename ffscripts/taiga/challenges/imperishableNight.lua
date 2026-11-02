-- Imperishable Night --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

mod:AddChallengeCallback(ModCallbacks.MC_POST_GAME_STARTED, FiendFolio.challenges.imperishableNight, function(_, continued)
	local itempool = game:GetItemPool()
	itempool:RemoveCollectible(CollectibleType.COLLECTIBLE_FORGET_ME_NOW)
	itempool:RemoveCollectible(CollectibleType.COLLECTIBLE_EPIC_FETUS)
	itempool:RemoveCollectible(CollectibleType.COLLECTIBLE_R_KEY)
	itempool:RemoveCollectible(FiendFolio.ITEM.COLLECTIBLE.WRONG_WARP)
end)

local imperishableStageProgression = {
	{LevelStage.STAGE1_1, StageType.STAGETYPE_ORIGINAL},
	{LevelStage.STAGE2_1, StageType.STAGETYPE_ORIGINAL},
	{LevelStage.STAGE3_1, StageType.STAGETYPE_ORIGINAL},
	{LevelStage.STAGE3_2, StageType.STAGETYPE_ORIGINAL},
	{LevelStage.STAGE4_1, StageType.STAGETYPE_AFTERBIRTH},
	{LevelStage.STAGE5, StageType.STAGETYPE_ORIGINAL},
	{LevelStage.STAGE6, StageType.STAGETYPE_ORIGINAL},
}

mod:AddChallengeCallback(ModCallbacks.MC_PRE_LEVEL_SELECT, FiendFolio.challenges.imperishableNight, function(_, level, stage)
	local savedata = FiendFolio.savedata
    if savedata and savedata.run and savedata.run.imperishableNextStage then
		savedata.run.imperishableNextStage = math.min(savedata.run.imperishableNextStage + 1, 7)
		return imperishableStageProgression[savedata.run.imperishableNextStage]
	else
		return imperishableStageProgression[1]
	end
end)

mod:AddChallengeCallback(ModCallbacks.MC_POST_NEW_LEVEL, FiendFolio.challenges.imperishableNight, function()
	local savedata = FiendFolio.savedata
	savedata.run.imperishableNextStage = savedata.run.imperishableNextStage or 1
end)

local imperishableStageBoss = {
	"Baby Plum",
	"Battie",
	"Loki",
	"Isaac",
	"Cacophobia",
	"The Lamb",
	"Mega Satan",
}

function mod:getImperishableBossPool()
    local levelstage = game:GetLevel():GetStage()
    if levelstage == LevelStage.STAGE1_1 or levelstage == LevelStage.STAGE1_2 then
		return {Pool = {{BossID = "Baby Plum", Weight = 657382}}}
    elseif levelstage == LevelStage.STAGE2_1 or levelstage == LevelStage.STAGE2_2 then
		return {Pool = {{BossID = "Battie", Weight = 657382}}}
    elseif levelstage == LevelStage.STAGE3_1 then
		return {Pool = {{BossID = "Loki", Weight = 657382}}}
    elseif levelstage == LevelStage.STAGE4_1 then
		return {Pool = {{BossID = "Cacophobia", Weight = 657382}}}
	end
end

local function getRoomDifficulties(gamemode)
	if gamemode == Difficulty.DIFFICULTY_NORMAL then
		return 5, 10
	else
		return 10, 15
	end
end

local function getBossRoomInfo()
	local level = game:GetLevel()
	for y = 0, 12 do
		for x = 0, 12 do
			local index = y * 13 + x
			local roomDesc = level:GetRoomByIdx(index)
			local roomData = roomDesc.Data
			if roomData and index == roomDesc.SafeGridIndex then
				local roomType = roomData.Type
				if roomType == RoomType.ROOM_BOSS then
					return roomData, index
				end
			end
		end
	end
end

mod:AddChallengeCallback(ModCallbacks.MC_POST_NEW_LEVEL, FiendFolio.challenges.imperishableNight, function()
	local level = game:GetLevel()
	local levelstage = level:GetStage()
	local subtype
	if levelstage == LevelStage.STAGE1_1 or levelstage == LevelStage.STAGE1_2 then
		subtype = BossType.BABY_PLUM
	elseif levelstage == LevelStage.STAGE3_1 then
		subtype = BossType.LOKI
	elseif levelstage == LevelStage.STAGE3_2 then
		subtype = BossType.ISAAC
	elseif levelstage == LevelStage.STAGE5 then
		subtype = BossType.LAMB
	else
		return
	end
	
	local bossRoomData, bossIndex = getBossRoomInfo()
	if bossRoomData == nil then return end
	
	local minDifficulty, maxDifficulty = getRoomDifficulties(game.Difficulty)
	local seed = math.max(1, level:GetDungeonPlacementSeed())
	local room = RoomConfigHolder.GetRandomRoom(seed, false, 
	                                            StbType.SPECIAL_ROOMS, RoomType.ROOM_BOSS, RoomShape.ROOMSHAPE_1x1,
	                                            nil, nil, nil, nil, nil, subtype)
	if room then
		local bossroom = level:GetRoomByIdx(bossIndex)
		bossroom.Data = room
	end
end)

mod:AddChallengeCallback("SATELLITE_POST_FIRE_TEAR", FiendFolio.challenges.imperishableNight, function(_, player, tear)
	local randval = 30
	local luck = math.max(math.min(math.floor(player.Luck), 7), -1)
	if math.random(randval) < 5 + (luck * 2) then
		tear.Scale = tear.Scale * (1 + 0.25 * math.max(player:GetTrinketMultiplier(mod.ITEM.TRINKET.YIN_YANG_ORB) - 1, 0))
		tear.CollisionDamage = tear.CollisionDamage * (1.25 + 0.50 * math.max(player:GetTrinketMultiplier(mod.ITEM.TRINKET.YIN_YANG_ORB) - 1, 0))
		tear.TearFlags = tear.TearFlags | TearFlags.TEAR_HOMING
		TearFlagsLib.AddTearFlags(tear, TearFlagsLib.Flag.YIN_YANG)
		mod:changeTearVariant(tear, mod.TEAR.HOMING_AMULET, mod.TEAR.HOMING_AMULET_BLOOD)
	end
end)