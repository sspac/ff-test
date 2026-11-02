-- Baby Sensory --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local function getLabyrinthAdjustedLevelStage()
	local level = game:GetLevel()
	local levelstage = level:GetStage()
	if levelstage % 2 == 1 and levelstage <= LevelStage.STAGE4_1 and 
	   (level:GetCurses() & LevelCurse.CURSE_OF_LABYRINTH == LevelCurse.CURSE_OF_LABYRINTH or game:IsGreedMode()) then
		levelstage = levelstage + 1
	end
	return levelstage
end

mod:AddCallback(ModCallbacks.MC_PLAYER_INIT_POST_LEVEL_INIT_STATS, function(_, player)
	if player:GetPlayerType() == FiendFolio.PLAYER.IMAGE then
		--stage 1 effects
		player:AddSmeltedTrinket(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE)
		--jevilstail effects
		--thumbs up
		mod.SetChallengeDestinationIcon(mod.DestinationIcon.PROPAGANDA)
	end
end)

function mod:imageAddSensory(player)
	local levelstage = getLabyrinthAdjustedLevelStage()
	local smeltedTrinkets
	if levelstage >= LevelStage.STAGE1_2 then
		smeltedTrinkets = smeltedTrinkets or player:GetSmeltedTrinkets()
	
		--stage 2 effects
		if smeltedTrinkets[mod.ITEM.TRINKET.FORTUNE_WORM].trinketAmount + smeltedTrinkets[mod.ITEM.TRINKET.FORTUNE_WORM].goldenTrinketAmount <= 0 then
			player:AddSmeltedTrinket(mod.ITEM.TRINKET.FORTUNE_WORM)
		end
		if smeltedTrinkets[mod.ITEM.TRINKET.PSYCHOLOGICAL_TORTURE].trinketAmount + smeltedTrinkets[mod.ITEM.TRINKET.PSYCHOLOGICAL_TORTURE].goldenTrinketAmount <= 0 then
			player:AddSmeltedTrinket(mod.ITEM.TRINKET.PSYCHOLOGICAL_TORTURE)
		end
		if smeltedTrinkets[TrinketType.TRINKET_MYSTERIOUS_CANDY].trinketAmount + smeltedTrinkets[TrinketType.TRINKET_MYSTERIOUS_CANDY].goldenTrinketAmount <= 0 then
			player:AddSmeltedTrinket(TrinketType.TRINKET_MYSTERIOUS_CANDY)
		end
	end
	if levelstage >= LevelStage.STAGE2_1 then
		smeltedTrinkets = smeltedTrinkets or player:GetSmeltedTrinkets()
		
		--stage 3 effects
		--scared hearts
		--micro pennies
		if smeltedTrinkets[mod.ITEM.TRINKET.WACKEY].trinketAmount + smeltedTrinkets[mod.ITEM.TRINKET.WACKEY].goldenTrinketAmount <= 0 then
			player:AddSmeltedTrinket(mod.ITEM.TRINKET.WACKEY)
		end
		if smeltedTrinkets[mod.ITEM.TRINKET.DUDS_FLOWER].trinketAmount + smeltedTrinkets[mod.ITEM.TRINKET.DUDS_FLOWER].goldenTrinketAmount <= 0 then
			player:AddSmeltedTrinket(mod.ITEM.TRINKET.DUDS_FLOWER)
		end
		if smeltedTrinkets[mod.ITEM.ROCK.NITRO_CRYSTAL].trinketAmount + smeltedTrinkets[mod.ITEM.ROCK.NITRO_CRYSTAL].goldenTrinketAmount <= 0 then
			player:AddSmeltedTrinket(mod.ITEM.ROCK.NITRO_CRYSTAL)
		end
	end
	if levelstage >= LevelStage.STAGE2_2 then
		--stage 4 effects
		if not player:HasCollectible(mod.ITEM.COLLECTIBLE.EMPTY_GAZE, true, true) then
			player:AddCollectible(mod.ITEM.COLLECTIBLE.EMPTY_GAZE)
		end
		
		if not player:HasCollectible(mod.ITEM.COLLECTIBLE.PET_ROCK, true, true) then
			player:AddCollectible(mod.ITEM.COLLECTIBLE.PET_ROCK)
		end
		if not player:HasCollectible(mod.ITEM.COLLECTIBLE.PLASMA_BALL, true, true) then
			player:AddCollectible(mod.ITEM.COLLECTIBLE.PLASMA_BALL)
		end
		
		if getLabyrinthAdjustedLevelStage() >= LevelStage.STAGE2_2 and
		   Isaac.CountEnemies() < 1
		then
			local hasSoccer = false
			for _, ball in ipairs(Isaac.FindByType(915, 1)) do
				if ball.SubType - (ball.SubType % 8) == mod.FF.RockBallFootball.Sub then
					hasSoccer = true
					break
				end
			end
			if not hasSoccer then
				local ball = Isaac.Spawn(915, 1, mod.FF.RockBallFootball.Sub + 5, player.Position, nilvector, player)
				ball.Parent = npc
				ball.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				ball:Update()
			end
		end
	end
	if levelstage >= LevelStage.STAGE3_1 then
		--stage 5 effects
		if not player:HasCollectible(mod.ITEM.COLLECTIBLE.DAYDREAM, true, true) then
			player:AddCollectible(mod.ITEM.COLLECTIBLE.DAYDREAM)
		end
		--women mode
	end
	if levelstage >= LevelStage.STAGE3_2 then
		--stage 6 effects
		if not player:HasCollectible(mod.ITEM.COLLECTIBLE.CRAZY_JACKPOT, true, true) then
			player:AddCollectible(mod.ITEM.COLLECTIBLE.CRAZY_JACKPOT)
		end
		--golden slots
	end
	if levelstage >= LevelStage.STAGE4_1 then
		--stage 7 effects
		if not player:HasCollectible(mod.ITEM.COLLECTIBLE.EMOJI_GLASSES, true, true) then
			player:AddCollectible(mod.ITEM.COLLECTIBLE.EMOJI_GLASSES)
		end
	end
	if levelstage >= LevelStage.STAGE4_2 then
		--stage 8 effects
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_ROBO_BABY_2, true, true) then
			player:AddCollectible(CollectibleType.COLLECTIBLE_ROBO_BABY_2)
		end
		--fat man arrive
	end
	if levelstage >= LevelStage.STAGE4_3 then
		-- further beyond effects
		if not player:HasCollectible(mod.ITEM.COLLECTIBLE.REPENTANCE_PLUS, true, true) then
			player:AddCollectible(mod.ITEM.COLLECTIBLE.REPENTANCE_PLUS)
		end
	end
	player:RemoveCostume(Isaac.GetItemConfig():GetCollectible(mod.ITEM.COLLECTIBLE.EMPTY_GAZE))
	player:RemoveCostume(Isaac.GetItemConfig():GetCollectible(mod.ITEM.COLLECTIBLE.DAYDREAM))
	player:RemoveCostume(Isaac.GetItemConfig():GetCollectible(mod.ITEM.COLLECTIBLE.CRAZY_JACKPOT))
	player:RemoveCostume(Isaac.GetItemConfig():GetCollectible(mod.ITEM.COLLECTIBLE.EMOJI_GLASSES))
	player:RemoveCostume(Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_ROBO_BABY_2))
end
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.imageAddSensory, FiendFolio.PLAYER.IMAGE)

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_TRIGGER_ROOM_CLEAR, function(_, player)
    if player:GetPlayerType() == FiendFolio.PLAYER.IMAGE then
		player:AnimateHappy()
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
	if PlayerManager.AnyoneIsPlayerType(FiendFolio.PLAYER.IMAGE) and 
	   getLabyrinthAdjustedLevelStage() >= LevelStage.STAGE2_1 and 
	   pickup.SubType ~= mod.PICKUP.COIN.LIL_PENNY 
	then
		for i = 0, 10 do
			mod.scheduleForUpdate(function()
				local vec = RandomVector()*mod:RandomInt(50,100)/10
				Isaac.Spawn(5, 20, FiendFolio.PICKUP.COIN.LIL_PENNY, pickup.Position, vec, nil)
			end, i, nil, true)
		end
		pickup:Remove()
	end
end, PickupVariant.PICKUP_COIN)

function mod:imageHeartPreSpawn(id, var, subtype, pos, vel, spawner, seed)
	if PlayerManager.AnyoneIsPlayerType(FiendFolio.PLAYER.IMAGE) and 
	   getLabyrinthAdjustedLevelStage() >= LevelStage.STAGE2_1 
	then
		if subtype == HeartSubType.HEART_FULL or subtype == HeartSubType.HEART_HALF or HeartSubType.HEART_DOUBLEPACK then
			return {5, 10, HeartSubType.HEART_SCARED, seed}
		end
	end
end

mod:AddChallengeCallback(ModCallbacks.MC_PRE_LEVEL_SELECT, mod.challenges.babySensory, function(_, levelstage, stagetype)
	if levelstage == LevelStage.STAGE4_2 then
		return {LevelStage.STAGE4_2, StageType.STAGETYPE_AFTERBIRTH}
	end
end) 

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
	if PlayerManager.AnyoneIsPlayerType(FiendFolio.PLAYER.IMAGE) and 
	   getLabyrinthAdjustedLevelStage() >= LevelStage.STAGE4_2 and
	   ((mod.FatManArrive or -400) <= -400)
	then
		mod.FatManArrive = 400
	end
	
	for i = 1, game:GetNumPlayers() do
		local p = Isaac.GetPlayer(i - 1)
		if p:GetPlayerType() == FiendFolio.PLAYER.IMAGE then
			mod:imageAddSensory(p)
		end
	end
end)

mod:AddChallengeCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.challenges.babySensory, function()
	local level = game:GetLevel()
	local stagetype = level:GetStageType()
	if level:GetStage() == LevelStage.STAGE4_1 and 
	   (stagetype == StageType.STAGETYPE_ORIGINAL or stagetype == StageType.STAGETYPE_WOTL) and
	   level:GetCurses() & LevelCurse.CURSE_OF_LABYRINTH == LevelCurse.CURSE_OF_LABYRINTH
	then
		Isaac.ExecuteCommand("reseed")
		return
	elseif getLabyrinthAdjustedLevelStage() == LevelStage.STAGE4_2 then
		local rooms = level:GetRooms()
		for i = 0, rooms.Size - 1 do
			local roomDesc = rooms:Get(i)
			local roomData = roomDesc.Data
			if roomData.Type == RoomType.ROOM_BOSS and (roomData.Subtype == BossType.MOMS_HEART or roomData.Subtype == BossType.IT_LIVES) then
				newRoom = StageAPI.GenerateBossRoom({
					BossID = "Propaganda",
					NoPlayBossAnim = true,
					CheckEncountered = false,
				}, {
					RoomDescriptor = roomDesc
				})
				
				local overwritableRoomDesc = level:GetRoomByIdx(roomDesc.SafeGridIndex, Dimension.NORMAL)
				local replaceData = StageAPI.GetGotoDataForTypeShape(RoomType.ROOM_BOSS, roomDesc.Data.Shape)
				overwritableRoomDesc.Data = replaceData
				
				local listIndex = roomDesc.ListIndex
				StageAPI.SetLevelRoom(newRoom, listIndex, Dimension.NORMAL)
			end
		end
	end
end)

FiendFolio.AddItemPickupCallback(function(player, added)
    if player:GetPlayerType() == FiendFolio.PLAYER.IMAGE then
		mod.Fiendish = true
		mod.cheatModeOn = true
	end
end, nil, CollectibleType.COLLECTIBLE_BIRTHRIGHT)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	if PlayerManager.AnyoneIsPlayerType(FiendFolio.PLAYER.IMAGE) and 
	   getLabyrinthAdjustedLevelStage() >= LevelStage.STAGE3_2
	then
		local room = game:GetRoom()
		if room:IsFirstVisit() then
			local level = game:GetLevel()
			if level:GetCurrentRoomIndex() == level:GetStartingRoomIndex() then
				local slot = Isaac.Spawn(6,1040,20, game:GetRoom():FindFreePickupSpawnPosition(Vector(0, 40)), nilvector, nil)
				mod:GetEntityData(slot).player = Isaac.GetPlayer()
			end
		end
	end
end)