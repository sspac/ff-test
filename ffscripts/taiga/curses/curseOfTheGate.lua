-- Curse of the Gate --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

--local gatelock = Sprite()
--gatelock:Load("gfx/grid/gatecurse_lock.anm2", true)

local bars = Sprite()
bars:Load("gfx/grid/door_17_bardoor.anm2", true)

local checkMovingBox = 0
local disableMovingBoxCheckNextUpdate = false

function mod:isCurseOfTheGateRoom(roomdesc)
	roomDesc = roomdesc or game:GetLevel():GetCurrentRoomDesc()
	if roomDesc and roomDesc.Data and roomDesc.Data.Type == RoomType.ROOM_DEFAULT and roomDesc.Data.Subtype == 920 then
		return true
	end
end

function mod:trySpawnGateKeyIfNeeded()
	local save = mod:GetGateCurseRoomSave()
	if not save.GateCurseRoomKeySpawned then
		save.GateCurseRoomKeySpawned = true
		local level = game:GetLevel()
		local room = game:GetRoom()
		local spawnPos = room:FindFreeTilePosition(room:GetCenterPos(), 1000)
		if level:GetCurrentRoomDesc().Flags & RoomDescriptor.FLAG_RED_ROOM > 0 then
			local key = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_CRACKED_KEY, spawnPos, Vector.Zero, nil):ToPickup()
			mod:GetEntityData(key).gateKeyReplacement = true
		else
			local key = Isaac.Spawn(EntityType.ENTITY_PICKUP, FiendFolio.PICKUP.VARIANT.GATECURSE_KEY, 0, spawnPos, Vector.Zero, nil):ToPickup()
		end
	end
end

--[[local GateCurseRooms = {
	BASEMENT = StageAPI.RoomsList("FFGateCurseBasement", require("resources.luarooms.gatecurse.ch1.gatecurse_basement")),
	CELLAR = StageAPI.RoomsList("FFGateCurseCellar", require("resources.luarooms.gatecurse.ch1.gatecurse_cellar")),
	BURNING_BASEMENT = StageAPI.RoomsList("FFGateCurseBurningBasement", require("resources.luarooms.gatecurse.ch1.gatecurse_burning")),
	CAVES = StageAPI.RoomsList("FFGateCurseCaves", require("resources.luarooms.gatecurse.ch2.gatecurse_caves")),
	CATACOMBS = StageAPI.RoomsList("FFGateCurseCatacombs", require("resources.luarooms.gatecurse.ch2.gatecurse_catacombs")),
	FLOODED_CAVES = StageAPI.RoomsList("FFGateCurseFloodedCaves", require("resources.luarooms.gatecurse.ch2.gatecurse_flooded")),
	DEPTHS = StageAPI.RoomsList("FFGateCurseDepths", require("resources.luarooms.gatecurse.ch3.gatecurse_depths")),
	NECROPOLIS = StageAPI.RoomsList("FFGateCurseNecropolis", require("resources.luarooms.gatecurse.ch3.gatecurse_necropolis")),
	DANK_DEPTHS = StageAPI.RoomsList("FFGateCurseDankDepths", require("resources.luarooms.gatecurse.ch3.gatecurse_dank")),
	WOMB = StageAPI.RoomsList("FFGateCurseWomb", require("resources.luarooms.gatecurse.ch4.gatecurse_womb")),
	UTERO = StageAPI.RoomsList("FFGateCurseUtero", require("resources.luarooms.gatecurse.ch4.gatecurse_utero")),
	SCARRED_WOMB = StageAPI.RoomsList("FFGateCurseScarredWomb", require("resources.luarooms.gatecurse.ch4.gatecurse_scarred")),
	SHEOL = StageAPI.RoomsList("FFGateCurseSheol", require("resources.luarooms.gatecurse.ch5.gatecurse_sheol")),
	CATHEDRAL = StageAPI.RoomsList("FFGateCurseCathedral", require("resources.luarooms.gatecurse.ch5.gatecurse_cathedral")),
	DARK_ROOM = StageAPI.RoomsList("FFGateCurseDarkRoom", require("resources.luarooms.gatecurse.ch6.gatecurse_dark")),
	CHEST = StageAPI.RoomsList("FFGateCurseChest", require("resources.luarooms.gatecurse.ch6.gatecurse_chest")),
	DOWNPOUR = StageAPI.RoomsList("FFGateCurseDownpour", require("resources.luarooms.gatecurse.ch15.gatecurse_downpour")),
	DROSS = StageAPI.RoomsList("FFGateCurseDross", require("resources.luarooms.gatecurse.ch15.gatecurse_dross")),
	MINES = StageAPI.RoomsList("FFGateCurseMines", require("resources.luarooms.gatecurse.ch25.gatecurse_mines")),
	ASHPIT = StageAPI.RoomsList("FFGateCurseAshpit", require("resources.luarooms.gatecurse.ch25.gatecurse_ashpit")),
	MAUSOLEUM = StageAPI.RoomsList("FFGateCurseMausoleum", require("resources.luarooms.gatecurse.ch35.gatecurse_mausoleum")),
	GEHENNA = StageAPI.RoomsList("FFGateCurseGehenna", require("resources.luarooms.gatecurse.ch35.gatecurse_gehenna")),
	CORPSE = StageAPI.RoomsList("FFGateCurseCorpse", require("resources.luarooms.gatecurse.ch45.gatecurse_corpse")),
}]]--

local function stageEnumToStbAndSubtype(levelstage, stagetype)
	local callbackReturns = Isaac.RunCallback(mod.CALLBACK.SELECT_CURSE_GATE_ROOMS, game:GetLevel())
	if callbackReturns ~= nil then
		return callbackReturns.StbType, callbackReturns.Subtype
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
	return stbType, 920
end

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

local function roomHasBeenVisited(index)
	local level = game:GetLevel()
	local targetRoomDesc = level:GetRoomByIdx(index)
	return targetRoomDesc.VisitedCount > 0
end

local function doorGoesToVisitedRoom(door)
	local index = door.TargetRoomIndex
	return roomHasBeenVisited(index)
end

local function roomIsBaseFloorBossRoom(index)
	local level = game:GetLevel()
	local currentRoomDesc = level:GetCurrentRoomDesc()
	local targetRoomDesc = level:GetRoomByIdx(index)
	return index >= 0 and index <= 168 and
	       level:GetDimension() == Dimension.NORMAL and
		   targetRoomDesc.Data.Type == RoomType.ROOM_BOSS and
	       targetRoomDesc.Data.Subtype ~= BossType.MOMS_HEART_MAUSOLEUM and
		   targetRoomDesc.Flags & 1024 ~= 1024 and
	       currentRoomDesc.Data.Subtype ~= BossType.MOMS_HEART_MAUSOLEUM
end

local function doorGoesToBaseFloorBossRoom(door)
	if not door:IsRoomType(RoomType.ROOM_BOSS) then return false end
	local index = door.TargetRoomIndex
	return roomIsBaseFloorBossRoom(index)
end

local function levelHasCurse(curse)
    local level = game:GetLevel()
	return level:GetCurses() & (1 << curse - 1) >= (1 << curse - 1)
end

-- Stores data related to different gate key rooms.
-- Because gate rooms can appear in red rooms, it's possible for multiple gate rooms to appear in a floor.
-- Because of this, we have to store data related to spawning the key in a place specific to the room.
function mod:GetGateCurseRoomSave(forceIndex)
	local save = mod.getFieldInit(FiendFolio.savedata, 'run', 'level', 'gateCurse', {})

	local index
	if forceIndex then
		index = tostring(forceIndex)
	else
		local level = game:GetLevel()
		index = tostring(level:GetCurrentRoomDesc().ListIndex)
	end

	if not save[index] then
		save[index] = {}
	end

	return save[index]
end

--[[function mod:removeBossKeyghost(player)
	player:GetEffects():RemoveNullEffect(FiendFolio.ITEM.NULL.BOSS_KEYGHOST, -1)
end]]

function mod:isInvalidGateFloor(inCurseEval)
	local level = game:GetLevel()
	local levelstage = level:GetStage()
	local isGreedMode = game:IsGreedMode()
	local isAscent = game:GetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH)
	local isCustomStage
	if not StageAPI then
		isCustomStage = false
	elseif inCurseEval then
		isCustomStage = StageAPI.NextStage ~= nil
	else
		isCustomStage = StageAPI:InNewStage()
	end
	local allowedByCallbacks = Isaac.RunCallback(mod.CALLBACK.PRE_EVAL_CURSE_GATE, level)
	if allowedByCallbacks == true then return false end
	return isGreedMode or isAscent or isCustomStage or allowedByCallbacks == false or levelstage == LevelStage.STAGE4_3 or levelstage == LevelStage.STAGE7 or levelstage == LevelStage.STAGE8
end

mod.InvalidGateChallenges = {
	[FiendFolio.challenges.theGauntlet] = true,
	[FiendFolio.challenges.dadsHomePlus] = true,
	[FiendFolio.challenges.craigChallenge] = true,
	[FiendFolio.challenges.allowEnemyReplacements] = true,
	[Challenge.CHALLENGE_CURSED] = true,
	[Challenge.CHALLENGE_BACKASSWARDS] = true,
	[Challenge.CHALLENGE_RED_REDEMPTION] = true,
}

function mod:isInvalidGateChallenge()
	return mod.InvalidGateChallenges[game.Challenge]
end

-- spawns a cracked key in red rooms
local function spawnGateKey(pos, spawner)
	local debugSpawnRedKey = false
	local level = game:GetLevel()

	local newPos = pos
	for _, pickup in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP)) do
		if (pickup.Position - pos):Length() < 20 then
			newPos = game:GetRoom():FindFreePickupSpawnPosition(pos, 0)
			break
		end
	end

	local save = mod:GetGateCurseRoomSave()
	save.GateCurseRoomKeySpawning = nil
	save.GateCurseRoomKeySpawned = true
	save.GateCurseKeyRemoved = nil

	if debugSpawnRedKey or level:GetCurrentRoomDesc().Flags & RoomDescriptor.FLAG_RED_ROOM > 0 then
		local key = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_CRACKED_KEY, newPos, nilvector, nil):ToPickup()
		mod:GetEntityData(key).gateKeyReplacement = true
		return key, true
	else
		local key = Isaac.Spawn(EntityType.ENTITY_PICKUP, FiendFolio.PICKUP.VARIANT.GATECURSE_KEY, 0, newPos, nilvector, spawner):ToPickup()
		return key, false
	end
end

mod:AddPriorityCallback(ModCallbacks.MC_POST_CURSE_EVAL, CallbackPriority.EARLY, function(_, curses)
	if (not FiendFolio.CustomCursesEnabled or
	   mod.anyPlayerHas(CollectibleType.COLLECTIBLE_BLACK_CANDLE) or
	   mod.anyPlayerHas(FiendFolio.ITEM.COLLECTIBLE.BLACK_LANTERN) or
	   mod.anyPlayerHas(FiendFolio.ITEM.COLLECTIBLE.BLACK_CANDELABRA)) and
	   (Isaac.GetChallenge() ~= mod.challenges.blursed)
	then
		return
	end

	local basechance
	if game.Difficulty == Difficulty.DIFFICULTY_NORMAL or game.Difficulty == Difficulty.DIFFICULTY_GREED then
		local gameData = Isaac.GetPersistentGameData()
		if gameData:GetEventCounter(EventCounter.ISAAC_KILLS) > 0 then
			basechance = 1/5
		elseif gameData:Unlocked(Achievement.EVERYTHING_IS_TERRIBLE) then
			basechance = 1/10
		elseif gameData:GetEventCounter(EventCounter.MOM_KILLS) > 0 then
			basechance = 1/30
		else
			basechance = 1/80
		end
	else
		local gameData = Isaac.GetPersistentGameData()
		if gameData:GetEventCounter(EventCounter.ISAAC_KILLS) > 0 then
			basechance = 1/3
		elseif gameData:Unlocked(Achievement.EVERYTHING_IS_TERRIBLE) then
			basechance = 1/3
		elseif gameData:GetEventCounter(EventCounter.MOM_KILLS) > 0 then
			basechance = 1/5
		else
			basechance = 1/10
		end
	end

	-- all curses have an equal chance of occurring
	-- this is set-up so curses will follow this logic
	local numFFCurses = 2
	local curseChance = 1 / (6 + numFFCurses)

	local curseRNG = game:GetLevel():GetGenerationRNG()

	if Isaac.GetChallenge() == mod.challenges.blursed then
		local appliedCurses = 0
		for i = 1, #FiendFolio.SunCurses do
			appliedCurses = appliedCurses | 1 << (FiendFolio.SunCurses[i] - 1)
		end
		appliedCurses = appliedCurses | 1 << (FiendFolio.curses.gateCurse - 1)
		appliedCurses = appliedCurses | 1 << (FiendFolio.curses.veilCurse - 1)
		return appliedCurses
	elseif curseRNG:RandomFloat() <= basechance then
		local randCurse = curseRNG:RandomFloat()
		if randCurse < curseChance then
			-- Curse of the Gate
			if not (mod:isInvalidGateFloor(true) or mod:isInvalidGateChallenge()) then
				return 1 << (FiendFolio.curses.gateCurse - 1)
			end
		elseif randCurse < curseChance * 2 then
			-- Curse of the Veil
			if not (mod.anyPlayerHas(CollectibleType.COLLECTIBLE_GUPPYS_EYE)) then
				return 1 << (FiendFolio.curses.veilCurse - 1)
			end
		end
	end
end)

local hasSetBossDoorGraphic = false
local isPlayingKeyOpen = false
local shouldOpenIfLeftRoom = false
local hadGateCurse = false
mod:AddCallback(ModCallbacks.MC_PRE_GRID_ENTITY_DOOR_RENDER, function(_, door)
	if FiendFolio.GateCurseRoomShouldBeBarred then
		local sprite = door:GetSprite()
		if not sprite:IsPlaying("Closed") then
			door:GetSprite():Play("Closed", true)
			sprite:GetLayer(4):SetVisible(true)
		end

		door.ExtraVisible = false
	elseif levelHasCurse(FiendFolio.curses.gateCurse) then -- or (BasementRenovator and BasementRenovator.InTestRoom and BasementRenovator:InTestRoom()) then
		if doorGoesToBaseFloorBossRoom(door) then
			local sprite
			if not hasSetBossDoorGraphic then
				sprite = door:GetSprite()
				local anim = sprite:GetAnimation()
				local frame = sprite:GetFrame()
				sprite:Load("gfx/grid/gatecurse_bossdoor.anm2", true)
				sprite:Play(anim, true)
				sprite:SetFrame(frame)
				hasSetBossDoorGraphic = true
			end

			if not isPlayingKeyOpen and (FiendFolio.savedata.GateCurseDoorIsUnlocked or doorGoesToVisitedRoom(door)) then
				return
			end

			sprite = sprite or door:GetSprite()
			if isPlayingKeyOpen then
				if sprite:IsFinished("KeyOpen") then
					sprite:Play("Opened", true)
					isPlayingKeyOpen = false
				elseif not sprite:IsPlaying("KeyOpen") then
					sprite:Play("KeyOpen", true)
					sprite:GetLayer(4):SetVisible(true)
				end

				if sprite:IsEventTriggered("Sound") then
					sfx:Play(FiendFolio.Sounds.LockBreak1Copy, 1, 0, false, 1)
				end
			else
				if not sprite:IsPlaying("KeyClosed") then
					sprite:Play("KeyClosed", true)
					sprite:GetLayer(4):SetVisible(true)
				end
			end
		end
	elseif hadGateCurse then
		if doorGoesToBaseFloorBossRoom(door) and hasSetBossDoorGraphic then
			local sprite = door:GetSprite()
			if sprite:IsPlaying("KeyClosed") or sprite:IsFinished("KeyClosed") or
			   sprite:IsPlaying("Open") or sprite:IsFinished("Open")
			then
				isPlayingKeyOpen = true
			end

			if isPlayingKeyOpen then
				if sprite:IsFinished("KeyOpen") then
					sprite:Play("Opened", true)
					sprite:GetLayer(4):SetVisible(true)
					isPlayingKeyOpen = false
				elseif not sprite:IsPlaying("KeyOpen") then
					sprite:Play("KeyOpen", true)
					sprite:GetLayer(4):SetVisible(false)
				end

				if sprite:IsEventTriggered("Sound") then
					sfx:Play(FiendFolio.Sounds.LockBreak1Copy, 1, 0, false, 1)
				end
			end
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_GRID_ENTITY_DOOR_RENDER, function(_, door)
	local renderMode = game:GetRoom():GetRenderMode()
	if not (renderMode == RenderMode.RENDER_NORMAL or renderMode == RenderMode.RENDER_WATER_ABOVE) then
		return
	end

	if FiendFolio.GateCurseRoomShouldBeBarred then
		bars:Play("Idle", true)
		local pos = door.Position
		if door.Slot == DoorSlot.LEFT0 or door.Slot == DoorSlot.LEFT1 then
			bars.Rotation = 270
			bars.Offset = Vector(2,0)
			pos = pos + Vector(20, 0)
		elseif door.Slot == DoorSlot.UP0 or door.Slot == DoorSlot.UP1 then
			bars.Rotation = 0
			bars.Offset = Vector(0,2)
			pos = pos + Vector(0, 20)
		elseif door.Slot == DoorSlot.RIGHT0 or door.Slot == DoorSlot.RIGHT1 then
			bars.Rotation = 90
			bars.Offset = Vector(-2,0)
			pos = pos + Vector(-20, 0)
		elseif door.Slot == DoorSlot.DOWN0 or door.Slot == DoorSlot.DOWN1 then
			bars.Rotation = 180
			bars.Offset = Vector(0,-2)
			pos = pos + Vector(0, -20)
		end
		bars:Render(Isaac.WorldToScreen(pos))
	elseif levelHasCurse(FiendFolio.curses.gateCurse) then -- or (BasementRenovator and BasementRenovator.InTestRoom and BasementRenovator:InTestRoom()) then
		if doorGoesToBaseFloorBossRoom(door) then
			if FiendFolio.savedata.GateCurseDoorIsUnlocked or doorGoesToVisitedRoom(door) then
				return
			end

			--[[gatelock:Play("Idle", true)
			if door.Slot == DoorSlot.LEFT0 or door.Slot == DoorSlot.LEFT1 then
				gatelock.Rotation = 270
			elseif door.Slot == DoorSlot.UP0 or door.Slot == DoorSlot.UP1 then
				gatelock.Rotation = 0
			elseif door.Slot == DoorSlot.RIGHT0 or door.Slot == DoorSlot.RIGHT1 then
				gatelock.Rotation = 90
			elseif door.Slot == DoorSlot.DOWN0 or door.Slot == DoorSlot.DOWN1 then
				gatelock.Rotation = 180
			end
			gatelock:Render(Isaac.WorldToScreen(door.Position))]]--
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_GRID_ENTITY_DOOR_UPDATE, function(_, door)
	if FiendFolio.GateCurseRoomShouldBeBarred and FiendFolio.savedata.GateCurseKeyCollected then
		FiendFolio.GateCurseRoomShouldBeBarred = false
	end
	if FiendFolio.GateCurseRoomShouldBeBarred then
		door:Close(true)
		door:Bar()
		door.State = 1
		door.CollisionClass = GridCollisionClass.COLLISION_WALL
	elseif levelHasCurse(FiendFolio.curses.gateCurse) then -- or (BasementRenovator and BasementRenovator.InTestRoom and BasementRenovator:InTestRoom()) then
		if doorGoesToBaseFloorBossRoom(door) then
			if FiendFolio.savedata.GateCurseDoorIsUnlocked or doorGoesToVisitedRoom(door) then
				return
			end

			door:Close(true)
			door.State = 1
			door.CollisionClass = GridCollisionClass.COLLISION_WALL

			if game:GetRoom():IsClear() then
				local bossKeyGhosts = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.BOSS_KEYGHOST)

				-- FAILSAFE: Detect and attempt to resolve missing key ghosts
				if #bossKeyGhosts == 0 and FiendFolio.savedata.GateCurseKeyCollected then
					if not FiendFolio.savedata.TriggeredGateDoorFailsafe then
						Console.PrintError("[FF] ERROR: Curse of the Gate Boss Key Ghost missing! Failsafe triggered, attempting to respawn ghost...")
						FiendFolio.savedata.TriggeredGateDoorFailsafe = true
						Isaac.GetPlayer(FiendFolio.savedata.GateCurseKeyCollected or 0):AddCacheFlags(CacheFlag.CACHE_FAMILIARS, true)
						bossKeyGhosts = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.BOSS_KEYGHOST)
					end
					if #bossKeyGhosts == 0 then
						-- Just unlock the damn door
						FiendFolio.savedata.GateCurseDoorIsUnlocked = true
						Console.PrintError("[FF] ERROR: Curse of the Gate Boss Key Ghost STILL missing!! Failsafe triggered, unlocking gate...")
						sfx:Play(SoundEffect.SOUND_UNLOCK00, 1.2, 2, false, math.random(120,140)/100)
						return
					end
				end

				for _, keyghost in ipairs(bossKeyGhosts) do
					local data = mod:GetEntityData(keyghost)
					if not data.target then
						local player = keyghost:ToFamiliar().Player
						if (player.Position - door.Position):Length() <= 40 then
							data.target = door
							shouldOpenIfLeftRoom = true
						end
					end
				end
			end
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	hasSetBossDoorGraphic = false
	isPlayingKeyOpen = false
	hadGateCurse = false

	if levelHasCurse(FiendFolio.curses.gateCurse) then
		local level = game:GetLevel()
		if roomIsBaseFloorBossRoom(level:GetCurrentRoomIndex()) then
			FiendFolio.savedata.GateCurseDoorIsUnlocked = true
		end
		hadGateCurse = true

		mod:CheckGateCurseKeyFailsafeCallback()
	end

	local save = mod:GetGateCurseRoomSave()
	if save.CrackedKeyToRemove then
		local wasRemoved = false
		for _, v in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_CRACKED_KEY)) do
			if v.InitSeed == save.CrackedKeyToRemove then
				v:Remove()
				wasRemoved = true
			end
		end

		save.CrackedKeyToRemove = nil

		if wasRemoved then
			save.GateCurseRoomKeySpawned = nil
		end
	end

	if shouldOpenIfLeftRoom and not FiendFolio.savedata.GateCurseDoorIsUnlocked then
		FiendFolio.savedata.GateCurseDoorIsUnlocked = true
		Isaac.GetPlayer(FiendFolio.savedata.GateCurseKeyCollected or 0):AddCacheFlags(CacheFlag.CACHE_FAMILIARS)

		--[[for _, player in ipairs(PlayerManager.GetPlayers()) do
			mod:removeBossKeyghost(player)
		end]]
	end

	shouldOpenIfLeftRoom = false
end)

function mod:openAnyGateCurseDoor()
	if levelHasCurse(FiendFolio.curses.gateCurse) then
		for _, grid in ipairs(mod.GetGridEntities()) do
			local door = grid:ToDoor()
			if door and doorGoesToBaseFloorBossRoom(door) then
				FiendFolio.savedata.GateCurseDoorIsUnlocked = true
				isPlayingKeyOpen = true
				shouldOpenIfLeftRoom = true
			end
		end
	end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function()
	mod:openAnyGateCurseDoor()
end, CollectibleType.COLLECTIBLE_DADS_KEY)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function()
	mod:openAnyGateCurseDoor()
end, Card.CARD_SOUL_CAIN)

function mod:isCurseOfTheGateKeySpawner(npc)
	return npc.Type == mod.FF.CurseOfTheGateKeySpawner.ID and npc.Variant == mod.FF.CurseOfTheGateKeySpawner.Var
end

function mod:curseOfTheGateKeySpawnerAI(npc)
	local data = mod:GetEntityData(npc)
	if not data.init then
		local xOffset = (((npc.SubType >> 1) & 63) - 32) * 40
		local yOffset = (((npc.SubType >> 7) & 63) - 32) * 40
		npc.Position = npc.Position + Vector(xOffset, yOffset)
		npc.TargetPosition = npc.Position
		data.init = true
	end

	local save = mod:GetGateCurseRoomSave()
	if not npc.Child and not save.GateCurseRoomKeySpawned and not data.SpawnedRedKey then
		local pedestals = Isaac.FindByType(mod.FF.CurseOfTheGatePedestal.ID, mod.FF.CurseOfTheGatePedestal.Var, mod.FF.CurseOfTheGatePedestal.Sub)
		if #pedestals == 1 then
			local pedestal = pedestals[1]
			if (
				Isaac.CountEntities(nil, EntityType.ENTITY_PICKUP, mod.PICKUP.VARIANT.GATECURSE_KEY) == 0
				and ((not mod:GetEntityData(pedestal).Triggerable) or save.GateCurseKeyRemoved)
			) then
				local key, wasRedKey = spawnGateKey(npc.Position, npc)
				key.Parent = npc
				npc.Child = key
				if wasRedKey then
					data.SpawnedRedKey = true
				end
			end
		elseif npc.FrameCount > 0 then -- delay a frame to fix the issue with stageapi red rooms deleting the cracked key (why????)
			local key, wasRedKey = spawnGateKey(npc.Position, npc)
			key.Parent = npc
			npc.Child = key
			if wasRedKey then
				data.SpawnedRedKey = true
			end
		end
	end

	-- Prevent softlocks with Moving Box or anything that removes the key.
	if save.GateCurseRoomKeySpawned and not npc.Child and not save.GateCurseRoomCollectedKey and not data.SpawnedRedKey then
		save.GateCurseRoomKeySpawned = nil
		save.GateCurseKeyRemoved = true
	end

	npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS)
	npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
	npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	npc.Visible = false
	npc.SplatColor = FiendFolio.ColorInvisible

	npc.Position = npc.TargetPosition

	if FiendFolio.savedata.GateCurseKeyCollected or data.SpawnedRedKey then
		npc.CanShutDoors = false
	end
end

-- Handle room clear trigger on post update instead of on the spawner's update
-- This prevents a frame perfect bug where you teleport out and can get softlocked
mod:AddEntityCallback(ModCallbacks.MC_POST_UPDATE, mod.FF.CurseOfTheGatePedestal.ID, mod.FF.CurseOfTheGatePedestal.Var, mod.FF.CurseOfTheGatePedestal.Sub, function ()
	local pedestals = Isaac.FindByType(mod.FF.CurseOfTheGatePedestal.ID, mod.FF.CurseOfTheGatePedestal.Var, mod.FF.CurseOfTheGatePedestal.Sub)
	if #pedestals >= 1 then
		local save = mod:GetGateCurseRoomSave()
		local pedestal = pedestals[1]
		local pdata = mod:GetEntityData(pedestal)
		local spawners = Isaac.FindByType(mod.FF.CurseOfTheGateKeySpawner.ID, mod.FF.CurseOfTheGateKeySpawner.Var)
		if (
			pdata.Triggerable
			and (#spawners > 0 or not mod.IsActiveRoom())
			and not pdata.Triggered
			and not save.GateCurseRoomKeySpawned
		) then
			pdata.Triggered = true
			pdata.TriggeredBy = spawners[1]

			save.GateCurseRoomKeySpawning = true

			local sprite = pedestal:GetSprite()
			local anim = "RoomClear"
			if game:GetLevel():GetCurrentRoomDesc().Flags & RoomDescriptor.FLAG_RED_ROOM > 0 then
				anim = "RedRoomClear"
			end
			if not (sprite:IsPlaying(anim) or sprite:IsFinished(anim)) then
				sprite:Play(anim, true)
			end

			pedestal:Update()
		end
	end
end)

-- Handle moving box tracking
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function ()
	if disableMovingBoxCheckNextUpdate or checkMovingBox == 0 then
		disableMovingBoxCheckNextUpdate = false
		checkMovingBox = 0
	end
	checkMovingBox = math.max(checkMovingBox - 1, 0)
end)

-- Handles spawning the key
function mod:GatePedestalUpdate(effect)
	if effect.SubType == mod.FF.CurseOfTheGatePedestal.Sub then
		local data = mod:GetEntityData(effect)
		local sprite = effect:GetSprite()

		effect.Position = effect.TargetPosition
		effect.Velocity = Vector(0,0)
		effect.SortingLayer = SortingLayer.SORTING_BACKGROUND

		if data.Triggerable then
			if not data.Triggered then
				local save = mod:GetGateCurseRoomSave()
				if save.GateCurseRoomKeySpawned and (save.GateCurseRoomCollectedKey or game:GetLevel():GetCurrentRoomDesc().Flags & RoomDescriptor.FLAG_RED_ROOM ~= 0) then
					sprite:Play("IdleRoomClear", true)
				else
					sprite:Play("IdleOff", true)
				end
			end
		else
			sprite:Play("IdleRoomClear", true)
		end

		if effect:GetSprite():IsEventTriggered("Appear") or data.SpawnImmediately then
			local key, wasRedKey = spawnGateKey(effect.Position, nil)
			if data.TriggeredBy and data.TriggeredBy:Exists() then
				key.Parent = data.TriggeredBy
				data.TriggeredBy.Child = key
				if wasRedKey then
					mod:GetEntityData(data.TriggeredBy).SpawnedRedKey = true
				end
			end

			data.SpawnImmediately = nil
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.GatePedestalUpdate, mod.FF.CurseOfTheGatePedestal.Var)

mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, npc)
	if npc.Variant == mod.FF.CurseOfTheGateKeySpawner.Var then
		local save = mod:GetGateCurseRoomSave()
		if save.GateCurseRoomCollectedKey then
			return
		end

		npc.CanShutDoors = npc.SubType & 1 == 0
	end
end, mod.FF.CurseOfTheGateKeySpawner.ID)

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc)
	if npc.Variant == mod.FF.CurseOfTheGateKeySpawner.Var then
		return false
	end
end, mod.FF.CurseOfTheGateKeySpawner.ID)

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, minecart)
	local child = minecart.Child
	if child and child.Type == mod.FF.CurseOfTheGateKeySpawner.ID and child.Variant == mod.FF.CurseOfTheGateKeySpawner.Var then
		if not child.Child then
			local key, wasRedKey = spawnGateKey(child.Position, child)
			key.Parent = child
			child.Child = key
			if wasRedKey then
				mod:GetEntityData(child).SpawnedRedKey = true
			end
		end
		mod:swapMinecartContents(child, child.Child, EntityGridCollisionClass.GRIDCOLL_NONE, EntityGridCollisionClass.GRIDCOLL_GROUND)
	end

	local data = mod:GetEntityData(minecart)
	if child then
		if child.Type == EntityType.ENTITY_PICKUP  then
			if child.Variant == FiendFolio.PICKUP.VARIANT.GATECURSE_KEY then
				data.minecartContainedGateKey = true
			elseif child.Variant == PickupVariant.PICKUP_TAROTCARD
			and child.SubType == Card.CARD_CRACKED_KEY
			and mod:GetEntityData(child).gateKeyReplacement then
				data.minecartContainedGateKey = true
			end
		end
	end

	if data.minecartContainedGateKey then
		minecart.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	end
end, EntityType.ENTITY_MINECART)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
	local save = mod:GetGateCurseRoomSave()
	local removeKey = false

	-- Check for existing gate curse keys and remove if they exist
	if Isaac.CountEntities(nil, EntityType.ENTITY_PICKUP, mod.PICKUP.VARIANT.GATECURSE_KEY) > 1 then
		removeKey = true
	end

	if save.GateCurseRoomCollectedKey then
		removeKey = true
	end

	if removeKey then
		--print("removed immediately")
		pickup:Remove()
	else
		-- Avoid dupes with Jera
		pickup:AddEntityFlags(EntityFlag.FLAG_NO_QUERY)
	end
end, FiendFolio.PICKUP.VARIANT.GATECURSE_KEY)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
	if FiendFolio.savedata.GateCurseKeyCollected then
		pickup:Remove()
		return
	end

	local sprite = pickup:GetSprite()
    if sprite:IsFinished("Appear") then
        sprite:Play("Idle", false)
    end
    if sprite:IsPlaying("Collect") and sprite:GetFrame() == 5 then
		if pickup.Parent then
			pickup.Parent:Remove()
		end
		pickup:Remove()
    end
    if sprite:IsEventTriggered("DropSound") then
        sfx:Play(SoundEffect.SOUND_KEY_DROP0, 1, 0, false, 1.25)
    end

	-- Remove if spawned by moving box
	if checkMovingBox > 0 and pickup.FrameCount <= 1 then
		disableMovingBoxCheckNextUpdate = true
		pickup:Remove()
	end
end, FiendFolio.PICKUP.VARIANT.GATECURSE_KEY)

function mod.CollectGateCursePuzzleKey(player, pickup)
    local sprite = pickup:GetSprite()
    if sprite:WasEventTriggered("DropSound") or sprite:IsPlaying("Idle") then
		-- Prevent issues where this code runs every frame when leaving the room
		-- frame perfectly while the door is getting unlocked.
		if pickup:IsDead() then
			return
		end

        pickup.Touched = true
		pickup.Velocity = Vector.Zero
		pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		pickup:Die()
        sprite:Play("Collect")
        sfx:Play(SoundEffect.SOUND_KEYPICKUP_GAUNTLET, 1, 0, false, math.random(147,153)/100)

		local save = mod:GetGateCurseRoomSave()
		FiendFolio.GateCurseRoomShouldBeBarred = false
		save.GateCurseRoomCollectedKey = true

		FiendFolio.savedata.GateCurseKeyCollected = player:GetPlayerIndex()
		player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS, true)

        --[[local effects = player:GetEffects()
		if not FiendFolio.savedata.GateCurseDoorIsUnlocked and not effects:HasNullEffect(FiendFolio.ITEM.NULL.BOSS_KEYGHOST) then
			effects:AddNullEffect(FiendFolio.ITEM.NULL.BOSS_KEYGHOST)
		end]]

		-- Just remove any spawners
		-- Only one gate key can exist in a room at a time anyway so this is fine and prevents issues
		for _, spawner in ipairs(Isaac.FindByType(mod.FFID.Tech, mod.FF.CurseOfTheGateKeySpawner.Var)) do
			spawner:Remove()
		end
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, collider)
    if collider.Type == EntityType.ENTITY_PLAYER then
		collider = collider:ToPlayer()
		local keyOwner = FiendFolio:GetMainPlayer(collider, true)
        mod.CollectGateCursePuzzleKey(keyOwner, pickup)
		return true
	end
end, FiendFolio.PICKUP.VARIANT.GATECURSE_KEY)

--[[
-- Keep the key status between different forms
function mod:TransferGateKeyNullItem(originalForm, newForm)
	local originalEffects = originalForm:GetEffects()
	local originalHasKey = originalEffects:HasNullEffect(FiendFolio.ITEM.NULL.BOSS_KEYGHOST)

	local newEffects = newForm:GetEffects()
	local newHasKey = newEffects:HasNullEffect(FiendFolio.ITEM.NULL.BOSS_KEYGHOST)

	-- Add it to the new form if the previous one had it
	if originalHasKey and not newHasKey then
		newEffects:AddNullEffect(FiendFolio.ITEM.NULL.BOSS_KEYGHOST)

	-- Remove it from the new form if the previous one didn't have it
	elseif not originalHasKey and newHasKey then
		newEffects:RemoveNullEffect(FiendFolio.ITEM.NULL.BOSS_KEYGHOST, -1)
	end
end
mod:AddCallback(mod.CALLBACK.ESAU_JR_SWITCH_FORM,  mod.TransferGateKeyNullItem)
mod:AddCallback(mod.CALLBACK.TLAZARUS_SWITCH_FORM, mod.TransferGateKeyNullItem)
]]

function mod:IsGateCurseCrackedKey(pickup)
	return (
		pickup.Variant == PickupVariant.PICKUP_TAROTCARD
		and pickup.SubType == Card.CARD_CRACKED_KEY
		and mod:GetEntityData(pickup).gateKeyReplacement
	)
end

-- Handles room clear prevention on a cracked key gate key.
function mod:HandleGateCurseRedKey(_, pickup)
	if mod:IsGateCurseCrackedKey(pickup) then
		FiendFolio.GateCurseRoomShouldBeBarred = false

		local save = mod:GetGateCurseRoomSave()
		save.GateCurseRoomCollectedKey = true

		if pickup.Parent then
			pickup.Parent:Remove()
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_COLLECT_CARD, mod.HandleGateCurseRedKey, Card.CARD_CRACKED_KEY)

function mod:PreventCrackedKeyCompost(pickup)
	if pickup.Variant == mod.PICKUP.VARIANT.GATECURSE_KEY or mod:IsGateCurseCrackedKey(pickup) then
		return false
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COMPOSTED, mod.PreventCrackedKeyCompost, PickupVariant.PICKUP_TAROTCARD)
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COMPOSTED, mod.PreventCrackedKeyCompost, mod.PICKUP.VARIANT.GATECURSE_KEY)
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_VOIDED, mod.PreventCrackedKeyCompost, PickupVariant.PICKUP_TAROTCARD)
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_VOIDED, mod.PreventCrackedKeyCompost, mod.PICKUP.VARIANT.GATECURSE_KEY)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, familiar)
    familiar.IsFollower = true
	familiar:AddEntityFlags(EntityFlag.FLAG_DONT_OVERWRITE)
end, mod.ITEM.FAMILIAR.BOSS_KEYGHOST)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, familiar)
    local data = mod:GetEntityData(familiar)
    local sprite = familiar:GetSprite()
	local player = familiar.Player

    if sprite:IsFinished("Poof") then
        --mod:removeBossKeyghost(player)
        familiar:Remove()
        return
    end
    sprite.Offset = Vector(0, -10)
    sprite.FlipX = familiar.Velocity.X <= 0

    if sprite:IsEventTriggered("UseKey") and not isPlayingKeyOpen then
        FiendFolio.savedata.GateCurseDoorIsUnlocked = true
		isPlayingKeyOpen = true
		sfx:Play(SoundEffect.SOUND_UNLOCK00, 1.2, 2, false, math.random(120,140)/100)

		if not FiendFolio.ACHIEVEMENT.SPECTRAL_KEYCHAIN:IsUnlocked(true) then
			FiendFolio.ACHIEVEMENT.SPECTRAL_KEYCHAIN:Unlock()
		end
    end
    if data.target then
		familiar.IsFollower = false
        familiar.Velocity = (data.target.Position - familiar.Position) * 0.2
        if familiar.Position:DistanceSquared(data.target.Position) <= 15 then
            sprite:Play("Poof", false)
        end
    else
		familiar.IsFollower = true
        familiar:FollowParent()
		if not (sprite:IsPlaying("Appear") or sprite:IsPlaying("Move")) then
			sprite:Play("Move")
		end
    end
end, mod.ITEM.FAMILIAR.BOSS_KEYGHOST)

local function isTriggerAdjacentToIndex(x, y, triggerIndices)
	for _, triggerIndex in ipairs(triggerIndices) do
		local triggerX = triggerIndex.X
		local triggerY = triggerIndex.Y

		if triggerX == x and (triggerY == y-1 or triggerY == y+1) then
			return true
		elseif triggerY == y and (triggerX == x-1 or triggerX == x+1) then
			return true
		end
	end
	return false
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	local bossKeyGhosts = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.BOSS_KEYGHOST)
	for _, keyghost in ipairs(bossKeyGhosts) do
		mod:GetEntityData(keyghost).target = nil
	end

	--if BasementRenovator and BasementRenovator.InTestRoom and BasementRenovator:InTestRoom() then
	local room = game:GetRoom()
	local roomDesc = game:GetLevel():GetCurrentRoomDesc()
	local save = mod:GetGateCurseRoomSave()
	local alreadySummonedPedestal = false
	if room:GetType() == RoomType.ROOM_DEFAULT and roomDesc and roomDesc.Data then -- and roomDesc.Data.Subtype == 920 then
		local gateKeyIndexX = -1
		local gateKeyIndexY = -1
		local gateKeyPositionOffset = Vector(0,0)
		local triggerIndices = {}

		local spawns = roomDesc.Data.Spawns
		for i = 0, spawns.Size - 1 do
			local spawn = spawns:Get(i)
			if spawn then
				for j = 0, spawn.Entries.Size - 1 do
					local entry = spawn.Entries:Get(j)
					if entry and entry.Type == mod.FF.CurseOfTheGateKeySpawner.ID and entry.Variant == mod.FF.CurseOfTheGateKeySpawner.Var then
						gateKeyIndexX = spawn.X
						gateKeyIndexY = spawn.Y

						local xOffset = (((entry.Subtype >> 1) & 63) - 32) * 40
						local yOffset = (((entry.Subtype >> 7) & 63) - 32) * 40
						gateKeyPositionOffset = Vector(xOffset, yOffset)
					elseif entry and entry.Type == EntityType.ENTITY_TRIGGER_OUTPUT then
						table.insert(triggerIndices, {X = spawn.X, Y = spawn.Y})
					end
				end
			end
		end

		if gateKeyIndexX ~= -1 and gateKeyIndexY ~= -1 then
			local isSpawningViaTrigger = isTriggerAdjacentToIndex(gateKeyIndexX, gateKeyIndexY, triggerIndices)

			local gateKeyIndex = (gateKeyIndexY + 1) * room:GetGridWidth() + (gateKeyIndexX + 1)
			local gateKeyPosition = room:GetGridPosition(gateKeyIndex) + gateKeyPositionOffset

			local pedestal = Isaac.Spawn(mod.FF.CurseOfTheGatePedestal.ID, mod.FF.CurseOfTheGatePedestal.Var, mod.FF.CurseOfTheGatePedestal.Sub, gateKeyPosition, nilvector, nil)
			pedestal:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			pedestal.TargetPosition = gateKeyPosition

			local pedestalData = mod:GetEntityData(pedestal)
			pedestalData.Triggerable = isSpawningViaTrigger

			pedestalData.SpawnImmediately = (
				save.GateCurseRoomKeySpawning
				and not save.GateCurseRoomKeySpawned
				and isSpawningViaTrigger
			)

			save.GateCurseSpawnedViaTrigger = isSpawningViaTrigger

			pedestal:Update()

			alreadySummonedPedestal = true

			if roomDesc.Flags & RoomDescriptor.FLAG_RED_ROOM == 0 then
				FiendFolio.GateCurseRoomShouldBeBarred = not save.GateCurseRoomCollectedKey
			end
		end
	end

	local currentRoom = StageAPI.GetCurrentRoom()
	if currentRoom then
		local isSpawningViaTrigger = false

		local metadataEntities = currentRoom.Metadata:Search({Tag = "StageAPIEditorFeature"})
		for _, metadataEntity in ipairs(metadataEntities) do
			if metadataEntity.Name == "Spawner" then
				local persistData = currentRoom:GetPersistenceData(metadataEntity)
				if not persistData or not persistData.NoTrigger then
					local blockedEntities = currentRoom.Metadata:GetBlockedEntities(metadataEntity.Index)
					if blockedEntities and #blockedEntities > 0 then
						local spawnAll = metadataEntity.BitValues.SpawnAll == 1
						local toSpawn = {}
						if spawnAll then
							toSpawn = blockedEntities
						else
							toSpawn[#toSpawn + 1] = blockedEntities[StageAPI.Random(1, #blockedEntities)]
						end

						for _, spawn in ipairs(toSpawn) do
							if (spawn.Type == mod.FF.CurseOfTheGateKeySpawner.ID and spawn.Variant == mod.FF.CurseOfTheGateKeySpawner.Var) or
							   (spawn.Type == EntityType.ENTITY_PICKUP and spawn.Variant == FiendFolio.PICKUP.VARIANT.GATECURSE_KEY)
							then
								isSpawningViaTrigger = true
								goto endOfMetadataCheckForGatecurse
							end
						end
					end
				end
			end
		end
		::endOfMetadataCheckForGatecurse::

		if alreadySummonedPedestal then
			goto endOfEntitiesByIndexCheckForGatecurse
		end

		local layout = currentRoom.Layout
		local entitiesByIndex = layout.EntitiesByIndex

		for index, entityList in pairs(entitiesByIndex) do
			for _, entity in ipairs(entityList) do
				if entity.Type == mod.FF.CurseOfTheGateKeySpawner.ID and entity.Variant == mod.FF.CurseOfTheGateKeySpawner.Var then
					local xOffset = (((entity.SubType >> 1) & 63) - 32) * 40
					local yOffset = (((entity.SubType >> 7) & 63) - 32) * 40
					local gateKeyPosition = room:GetGridPosition(index) + Vector(xOffset, yOffset)

					local pedestal = Isaac.Spawn(mod.FF.CurseOfTheGatePedestal.ID, mod.FF.CurseOfTheGatePedestal.Var, mod.FF.CurseOfTheGatePedestal.Sub, gateKeyPosition, nilvector, nil)
					pedestal:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
					pedestal.TargetPosition = gateKeyPosition

					local pedestalData = mod:GetEntityData(pedestal)
					pedestalData.Triggerable = isSpawningViaTrigger

					pedestalData.SpawnImmediately = (
						save.GateCurseRoomKeySpawning
						and not save.GateCurseRoomKeySpawned
						and isSpawningViaTrigger
					)

					save.GateCurseSpawnedViaTrigger = isSpawningViaTrigger

					if roomDesc.Flags & RoomDescriptor.FLAG_RED_ROOM == 0 then
						FiendFolio.GateCurseRoomShouldBeBarred = not save.GateCurseRoomCollectedKey
					end

					goto endOfEntitiesByIndexCheckForGatecurse
				end
			end
		end
		::endOfEntitiesByIndexCheckForGatecurse::
	end
end)

StageAPI.AddCallback("FiendFolio", "PRE_SPAWN_ENTITY_LIST", -1 * math.huge, function(entityList, spawnIndex, doGrids, doPersistentOnly, doAutoPersistent, avoidSpawning, persistenceData)
	if FiendFolio.GateCurseRoomShouldBeBarred == nil then
		for _, entityInfo in ipairs(entityList) do
			if (entityInfo.Data.Type == mod.FF.CurseOfTheGateKeySpawner.ID and entityInfo.Data.Variant == mod.FF.CurseOfTheGateKeySpawner.Var) or
			   (entityInfo.Data.Type == EntityType.ENTITY_PICKUP and entityInfo.Data.Variant == FiendFolio.PICKUP.VARIANT.GATECURSE_KEY)
			then
				local shouldSpawnEntity = true

				if shouldSpawnEntity and avoidSpawning and avoidSpawning[entityInfo.PersistentIndex] then
					shouldSpawnEntity = false
				end

				local entityPersistData, persistData
				local persistType = entityInfo.Data.Type
				local persistVariant = entityInfo.Data.Variant
				local persistSubType = entityInfo.Data.SubType
				if entityInfo.Persistent and persistenceData then
					if entityInfo.PersistentIndex then
						entityPersistData = persistenceData[entityInfo.PersistentIndex]
						if entityPersistData then
							persistType = entityPersistData.Type or entityInfo.Data.Type
							persistVariant = entityPersistData.Variant or entityInfo.Data.Variant
							persistSubType = entityPersistData.SubType or entityInfo.Data.SubType

							if not ((persistType == mod.FF.CurseOfTheGateKeySpawner.ID and persistVariant == mod.FF.CurseOfTheGateKeySpawner.Var) or
							        (persistType == EntityType.ENTITY_PICKUP and persistVariant == FiendFolio.PICKUP.VARIANT.GATECURSE_KEY))
							then
								goto continueGateCurseEntityInfoLoop
							end
						end
					end

					persistData = StageAPI.CheckPersistence(persistType, persistVariant, persistSubType)
				end

				if shouldSpawnEntity and doPersistentOnly and not persistData then
					shouldSpawnEntity = false
				end

				if shouldSpawnEntity and persistData and StageAPI.ShouldAutoPersist(persistData, persistType, persistVariant, persistSubType) and not doAutoPersistent then
					shouldSpawnEntity = false
				end

				local roomDesc = game:GetLevel():GetCurrentRoomDesc()
				if shouldSpawnEntity and roomDesc.Flags & RoomDescriptor.FLAG_RED_ROOM == 0 then
					local save = mod:GetGateCurseRoomSave()
					FiendFolio.GateCurseRoomShouldBeBarred = not save.GateCurseRoomCollectedKey
					return
				end

				::continueGateCurseEntityInfoLoop::
			end
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_PRE_NEW_ROOM, function()
	FiendFolio.GateCurseRoomShouldBeBarred = nil
end)

mod:AddCallback(ModCallbacks.MC_PRE_ROOM_EXIT, function()
	-- Update all key spawners to prevent the bug that is caused by leaving the frame the room is cleared
	-- This bug will make the key never spawn
	for _, spawner in ipairs(Isaac.FindByType(mod.FF.CurseOfTheGatePedestal.ID, mod.FF.CurseOfTheGatePedestal.Var, mod.FF.CurseOfTheGatePedestal.Sub)) do
		spawner:Update()
	end

	for _, key in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_CRACKED_KEY)) do
		if mod:IsGateCurseCrackedKey(key) and mod.IsActiveRoom() then
			-- Remove this cracked key when we re-enter the room.
			-- Also removes Jera dupes, which is good because we dont want hypothetical infinite Cracked Keys.
			local save = mod:GetGateCurseRoomSave()
			save.CrackedKeyToRemove = key.InitSeed
		end
	end

	mod:CheckGateCurseRoomFailsafe()
end)

-- Check when moving box is used to prevent another key from spawning
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, function ()
	checkMovingBox = 0
	disableMovingBoxCheckNextUpdate = false
end)

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function (_, _, _, player)
	checkMovingBox = 2
	disableMovingBoxCheckNextUpdate = false
end, CollectibleType.COLLECTIBLE_MOVING_BOX)

local futureEntranceRooms = {}
StageAPI.AddCallback("FiendFolio", "POST_SET_LEVEL_ROOM", 1, function(levelRoom, roomID, dimension)
	if TheFuture and levelRoom and dimension == Dimension.NORMAL then
		local level = game:GetLevel()
		if not game:IsGreedMode() and Isaac.GetChallenge() == Challenge.CHALLENGE_NULL and level:GetStage() == LevelStage.STAGE2_2 --and not BasementRenovator
		   and not (StageAPI.InOverriddenStage() and not (StageAPI.GetCurrentStage().Name == "Catacombs 2" or StageAPI.GetCurrentStage().StageHPNumber == 4))
		then
			if levelRoom.RoomsListName and levelRoom.RoomsListName == "FutureStevenRooms" then
				futureEntranceRooms[roomID] = true
			end
		end
	end
end)

local function findGateRoomLocation()
	local floorLayout = {}
	for i = -2, 14 do
		floorLayout[i] = {}
	end
	local bossRoomX = 0
	local bossRoomY = 0

	local level = game:GetLevel()
	local startingRoomIndex = level:GetStartingRoomIndex()
	for y = 0, 12 do
		for x = 0, 12 do
			local index = y * 13 + x
			local roomDesc = level:GetRoomByIdx(index)
			local roomData = roomDesc.Data
			if roomData and index == roomDesc.SafeGridIndex then
				local doors = roomData.Doors
				local roomShape = roomData.Shape
				local roomType = roomData.Type
				local roomVariant = roomData.Variant
				local roomSubtype = roomData.Subtype
				local roomListIndex = roomDesc.ListIndex

				if roomShape == RoomShape.ROOMSHAPE_1x2 or roomShape == RoomShape.ROOMSHAPE_IIV	then
					floorLayout[y][x] = {Column = x, Row = y, Doors = doors, Shape = roomShape, Type = roomType, Variant = roomVariant, Subtype = roomSubtype, ListIndex = roomListIndex}
					floorLayout[y+1][x] = {Column = x, Row = y, Doors = doors, Shape = roomShape, Type = roomType, Variant = roomVariant, Subtype = roomSubtype, ListIndex = roomListIndex}
				elseif roomShape == RoomShape.ROOMSHAPE_2x1 or roomShape == RoomShape.ROOMSHAPE_IIH	then
					floorLayout[y][x] = {Column = x, Row = y, Doors = doors, Shape = roomShape, Type = roomType, Variant = roomVariant, Subtype = roomSubtype, ListIndex = roomListIndex}
					floorLayout[y][x+1] = {Column = x, Row = y, Doors = doors, Shape = roomShape, Type = roomType, Variant = roomVariant, Subtype = roomSubtype, ListIndex = roomListIndex}
				elseif roomShape == RoomShape.ROOMSHAPE_2x2 then
					floorLayout[y][x] = {Column = x, Row = y, Doors = doors, Shape = roomShape, Type = roomType, Variant = roomVariant, Subtype = roomSubtype, ListIndex = roomListIndex}
					floorLayout[y][x+1] = {Column = x, Row = y, Doors = doors, Shape = roomShape, Type = roomType, Variant = roomVariant, Subtype = roomSubtype, ListIndex = roomListIndex}
					floorLayout[y+1][x] = {Column = x, Row = y, Doors = doors, Shape = roomShape, Type = roomType, Variant = roomVariant, Subtype = roomSubtype, ListIndex = roomListIndex}
					floorLayout[y+1][x+1] = {Column = x, Row = y, Doors = doors, Shape = roomShape, Type = roomType, Variant = roomVariant, Subtype = roomSubtype, ListIndex = roomListIndex}
				elseif roomShape == RoomShape.ROOMSHAPE_LTL then
					floorLayout[y][x] = {Column = x, Row = y, Doors = doors, Shape = roomShape, Type = roomType, Variant = roomVariant, Subtype = roomSubtype, ListIndex = roomListIndex}
					floorLayout[y+1][x-1] = {Column = x, Row = y, Doors = doors, Shape = roomShape, Type = roomType, Variant = roomVariant, Subtype = roomSubtype, ListIndex = roomListIndex}
					floorLayout[y+1][x] = {Column = x, Row = y, Doors = doors, Shape = roomShape, Type = roomType, Variant = roomVariant, Subtype = roomSubtype, ListIndex = roomListIndex}
				elseif roomShape == RoomShape.ROOMSHAPE_LTR then
					floorLayout[y][x] = {Column = x, Row = y, Doors = doors, Shape = roomShape, Type = roomType, Variant = roomVariant, Subtype = roomSubtype, ListIndex = roomListIndex}
					floorLayout[y+1][x] = {Column = x, Row = y, Doors = doors, Shape = roomShape, Type = roomType, Variant = roomVariant, Subtype = roomSubtype, ListIndex = roomListIndex}
					floorLayout[y+1][x+1] = {Column = x, Row = y, Doors = doors, Shape = roomShape, Type = roomType, Variant = roomVariant, Subtype = roomSubtype, ListIndex = roomListIndex}
				elseif roomShape == RoomShape.ROOMSHAPE_LBL then
					floorLayout[y][x] = {Column = x, Row = y, Doors = doors, Shape = roomShape, Type = roomType, Variant = roomVariant, Subtype = roomSubtype, ListIndex = roomListIndex}
					floorLayout[y][x+1] = {Column = x, Row = y, Doors = doors, Shape = roomShape, Type = roomType, Variant = roomVariant, Subtype = roomSubtype, ListIndex = roomListIndex}
					floorLayout[y+1][x+1] = {Column = x, Row = y, Doors = doors, Shape = roomShape, Type = roomType, Variant = roomVariant, Subtype = roomSubtype, ListIndex = roomListIndex}
				elseif roomShape == RoomShape.ROOMSHAPE_LBR then
					floorLayout[y][x] = {Column = x, Row = y, Doors = doors, Shape = roomShape, Type = roomType, Variant = roomVariant, Subtype = roomSubtype, ListIndex = roomListIndex}
					floorLayout[y][x+1] = {Column = x, Row = y, Doors = doors, Shape = roomShape, Type = roomType, Variant = roomVariant, Subtype = roomSubtype, ListIndex = roomListIndex}
					floorLayout[y+1][x] = {Column = x, Row = y, Doors = doors, Shape = roomShape, Type = roomType, Variant = roomVariant, Subtype = roomSubtype, ListIndex = roomListIndex}
				else
					floorLayout[y][x] = {Column = x, Row = y, Doors = doors, Shape = roomShape, Type = roomType, Variant = roomVariant, Subtype = roomSubtype, ListIndex = roomListIndex}
				end

				if roomType == RoomType.ROOM_BOSS then
					bossRoomX = x
					bossRoomY = y
				end
			end
		end
	end

	local possibleLocations = {}
	for y = 0, 12 do
		for x = 0, 12 do
			if not floorLayout[y][x] then
				local adjacentRoom = nil
				local adjacentRoomNum = 0
				local adjacentRoomIsNotDefault = false
				local adjacentToStartingRoom = false
				local adjacentToMirrorRoom = false
				local adjacentToMinesEscape = false
				local adjacentToFutureEntrance = false
				local adjacentToFerrymanRoom = false
				if floorLayout[y-1][x] then
					adjacentRoom = floorLayout[y-1][x]
					adjacentRoomNum = adjacentRoomNum + 1
					adjacentRoomIsNotDefault = adjacentRoomIsNotDefault or floorLayout[y-1][x].Type ~= RoomType.ROOM_DEFAULT
					adjacentToStartingRoom = adjacentToStartingRoom or ((y-1) * 13 + x) == startingRoomIndex
					adjacentToMirrorRoom = adjacentToMirrorRoom or (floorLayout[y-1][x].Type == RoomType.ROOM_DEFAULT and floorLayout[y-1][x].Subtype == 34)
					adjacentToMinesEscape = adjacentToMinesEscape or (floorLayout[y-1][x].Type == RoomType.ROOM_DEFAULT and floorLayout[y-1][x].Subtype == 10)
					adjacentToFutureEntrance = adjacentToFutureEntrance or (TheFuture and futureEntranceRooms[floorLayout[y-1][x].ListIndex])
					adjacentToFerrymanRoom = adjacentToFerrymanRoom or (SamaelMod and 61900 <= floorLayout[y-1][x].Variant and floorLayout[y-1][x].Variant <= 61940)
				end
				if floorLayout[y+1][x] then
					adjacentRoom = floorLayout[y+1][x]
					adjacentRoomNum = adjacentRoomNum + 1
					adjacentRoomIsNotDefault = adjacentRoomIsNotDefault or floorLayout[y+1][x].Type ~= RoomType.ROOM_DEFAULT
					adjacentToStartingRoom = adjacentToStartingRoom or ((y+1) * 13 + x) == startingRoomIndex
					adjacentToMirrorRoom = adjacentToMirrorRoom or (floorLayout[y+1][x].Type == RoomType.ROOM_DEFAULT and floorLayout[y+1][x].Subtype == 34)
					adjacentToMinesEscape = adjacentToMinesEscape or (floorLayout[y+1][x].Type == RoomType.ROOM_DEFAULT and floorLayout[y+1][x].Subtype == 10)
					adjacentToFutureEntrance = adjacentToFutureEntrance or (TheFuture and futureEntranceRooms[floorLayout[y+1][x].ListIndex])
					adjacentToFerrymanRoom = adjacentToFerrymanRoom or (SamaelMod and 61900 <= floorLayout[y+1][x].Variant and floorLayout[y+1][x].Variant <= 61940)
				end
				if floorLayout[y][x-1] then
					adjacentRoom = floorLayout[y][x-1]
					adjacentRoomNum = adjacentRoomNum + 1
					adjacentRoomIsNotDefault = adjacentRoomIsNotDefault or floorLayout[y][x-1].Type ~= RoomType.ROOM_DEFAULT
					adjacentToStartingRoom = adjacentToStartingRoom or (y * 13 + (x-1)) == startingRoomIndex
					adjacentToMirrorRoom = adjacentToMirrorRoom or (floorLayout[y][x-1].Type == RoomType.ROOM_DEFAULT and floorLayout[y][x-1].Subtype == 34)
					adjacentToMinesEscape = adjacentToMinesEscape or (floorLayout[y][x-1].Type == RoomType.ROOM_DEFAULT and floorLayout[y][x-1].Subtype == 10)
					adjacentToFutureEntrance = adjacentToFutureEntrance or (TheFuture and futureEntranceRooms[floorLayout[y][x-1].ListIndex])
					adjacentToFerrymanRoom = adjacentToFerrymanRoom or (SamaelMod and 61900 <= floorLayout[y][x-1].Variant and floorLayout[y][x-1].Variant <= 61940)
				end
				if floorLayout[y][x+1] then
					adjacentRoom = floorLayout[y][x+1]
					adjacentRoomNum = adjacentRoomNum + 1
					adjacentRoomIsNotDefault = adjacentRoomIsNotDefault or floorLayout[y][x+1].Type ~= RoomType.ROOM_DEFAULT
					adjacentToStartingRoom = adjacentToStartingRoom or (y * 13 + (x+1)) == startingRoomIndex
					adjacentToMirrorRoom = adjacentToMirrorRoom or (floorLayout[y][x+1].Type == RoomType.ROOM_DEFAULT and floorLayout[y][x+1].Subtype == 34)
					adjacentToMinesEscape = adjacentToMinesEscape or (floorLayout[y][x+1].Type == RoomType.ROOM_DEFAULT and floorLayout[y][x+1].Subtype == 10)
					adjacentToFutureEntrance = adjacentToFutureEntrance or (TheFuture and futureEntranceRooms[floorLayout[y][x+1].ListIndex])
					adjacentToFerrymanRoom = adjacentToFerrymanRoom or (SamaelMod and 61900 <= floorLayout[y][x+1].Variant and floorLayout[y][x+1].Variant <= 61940)
				end

				if adjacentRoomNum == 1 and not (adjacentRoomIsNotDefault or adjacentToStartingRoom or adjacentToMirrorRoom or adjacentToMinesEscape or adjacentToFutureEntrance or adjacentToFerrymanRoom) then
					local adjacentColumn = adjacentRoom.Column
					local adjacentRow = adjacentRoom.Row
					local adjacentDoors = adjacentRoom.Doors
					local adjacentShape = adjacentRoom.Shape

					if adjacentShape == RoomShape.ROOMSHAPE_1x2 or adjacentShape == RoomShape.ROOMSHAPE_IIV	then
						if y == adjacentRow - 1 and x == adjacentColumn then
							if adjacentDoors & (1 << DoorSlot.UP0) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.UP0})
								end
							end
						elseif y == adjacentRow + 2 and x == adjacentColumn then
							if adjacentDoors & (1 << DoorSlot.DOWN0) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.DOWN0})
								end
							end
						elseif y == adjacentRow and x == adjacentColumn - 1 then
							if adjacentDoors & (1 << DoorSlot.LEFT0) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.LEFT0})
								end
							end
						elseif y == adjacentRow + 1 and x == adjacentColumn - 1 then
							if adjacentDoors & (1 << DoorSlot.LEFT1) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.LEFT1})
								end
							end
						elseif y == adjacentRow and x == adjacentColumn + 1 then
							if adjacentDoors & (1 << DoorSlot.RIGHT0) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.RIGHT0})
								end
							end
						elseif y == adjacentRow + 1 and x == adjacentColumn + 1 then
							if adjacentDoors & (1 << DoorSlot.RIGHT1) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.RIGHT1})
								end
							end
						end
					elseif adjacentShape == RoomShape.ROOMSHAPE_2x1 or adjacentShape == RoomShape.ROOMSHAPE_IIH	then
						if y == adjacentRow - 1 and x == adjacentColumn then
							if adjacentDoors & (1 << DoorSlot.UP0) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.UP0})
								end
							end
						elseif y == adjacentRow - 1 and x == adjacentColumn + 1 then
							if adjacentDoors & (1 << DoorSlot.UP1) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.UP1})
								end
							end
						elseif y == adjacentRow + 1 and x == adjacentColumn then
							if adjacentDoors & (1 << DoorSlot.DOWN0) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.DOWN0})
								end
							end
						elseif y == adjacentRow + 1 and x == adjacentColumn + 1 then
							if adjacentDoors & (1 << DoorSlot.DOWN1) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.DOWN1})
								end
							end
						elseif y == adjacentRow and x == adjacentColumn - 1 then
							if adjacentDoors & (1 << DoorSlot.LEFT0) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.LEFT0})
								end
							end
						elseif y == adjacentRow and x == adjacentColumn + 2 then
							if adjacentDoors & (1 << DoorSlot.RIGHT0) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.RIGHT0})
								end
							end
						end
					elseif adjacentShape == RoomShape.ROOMSHAPE_2x2 then
						if y == adjacentRow - 1 and x == adjacentColumn then
							if adjacentDoors & (1 << DoorSlot.UP0) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.UP0})
								end
							end
						elseif y == adjacentRow - 1 and x == adjacentColumn + 1 then
							if adjacentDoors & (1 << DoorSlot.UP1) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.UP1})
								end
							end
						elseif y == adjacentRow + 2 and x == adjacentColumn then
							if adjacentDoors & (1 << DoorSlot.DOWN0) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.DOWN0})
								end
							end
						elseif y == adjacentRow + 2 and x == adjacentColumn + 1 then
							if adjacentDoors & (1 << DoorSlot.DOWN1) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.DOWN1})
								end
							end
						elseif y == adjacentRow and x == adjacentColumn - 1 then
							if adjacentDoors & (1 << DoorSlot.LEFT0) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.LEFT0})
								end
							end
						elseif y == adjacentRow + 1 and x == adjacentColumn - 1 then
							if adjacentDoors & (1 << DoorSlot.LEFT1) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.LEFT1})
								end
							end
						elseif y == adjacentRow and x == adjacentColumn + 2 then
							if adjacentDoors & (1 << DoorSlot.RIGHT0) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.RIGHT0})
								end
							end
						elseif y == adjacentRow + 1 and x == adjacentColumn + 2 then
							if adjacentDoors & (1 << DoorSlot.RIGHT1) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.RIGHT1})
								end
							end
						end
					elseif adjacentShape == RoomShape.ROOMSHAPE_LTL then
						if y == adjacentRow and x == adjacentColumn - 1 then
							-- CANNOT GO HERE
						elseif y == adjacentRow - 1 and x == adjacentColumn then
							if adjacentDoors & (1 << DoorSlot.UP1) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.UP1})
								end
							end
						elseif y == adjacentRow + 2 and x == adjacentColumn - 1 then
							if adjacentDoors & (1 << DoorSlot.DOWN0) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.DOWN0})
								end
							end
						elseif y == adjacentRow + 2 and x == adjacentColumn then
							if adjacentDoors & (1 << DoorSlot.DOWN1) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.DOWN1})
								end
							end
						elseif y == adjacentRow and x == adjacentColumn - 1 then
							-- CANNOT GO HERE
						elseif y == adjacentRow + 1 and x == adjacentColumn - 2 then
							if adjacentDoors & (1 << DoorSlot.LEFT1) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.LEFT1})
								end
							end
						elseif y == adjacentRow and x == adjacentColumn + 1 then
							if adjacentDoors & (1 << DoorSlot.RIGHT0) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.RIGHT0})
								end
							end
						elseif y == adjacentRow + 1 and x == adjacentColumn + 1 then
							if adjacentDoors & (1 << DoorSlot.RIGHT1) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.RIGHT1})
								end
							end
						end
					elseif adjacentShape == RoomShape.ROOMSHAPE_LTR then
						if y == adjacentRow - 1 and x == adjacentColumn then
							if adjacentDoors & (1 << DoorSlot.UP0) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.UP0})
								end
							end
						elseif y == adjacentRow and x == adjacentColumn + 1 then
							-- CANNOT GO HERE
						elseif y == adjacentRow + 2 and x == adjacentColumn then
							if adjacentDoors & (1 << DoorSlot.DOWN0) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.DOWN0})
								end
							end
						elseif y == adjacentRow + 2 and x == adjacentColumn + 1 then
							if adjacentDoors & (1 << DoorSlot.DOWN1) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.DOWN1})
								end
							end
						elseif y == adjacentRow and x == adjacentColumn - 1 then
							if adjacentDoors & (1 << DoorSlot.LEFT0) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.LEFT0})
								end
							end
						elseif y == adjacentRow + 1 and x == adjacentColumn - 1 then
							if adjacentDoors & (1 << DoorSlot.LEFT1) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.LEFT1})
								end
							end
						elseif y == adjacentRow and x == adjacentColumn + 1 then
							-- CANNOT GO HERE
						elseif y == adjacentRow + 1 and x == adjacentColumn + 2 then
							if adjacentDoors & (1 << DoorSlot.RIGHT1) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.RIGHT1})
								end
							end
						end
					elseif adjacentShape == RoomShape.ROOMSHAPE_LBL then
						if y == adjacentRow - 1 and x == adjacentColumn then
							if adjacentDoors & (1 << DoorSlot.UP0) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.UP0})
								end
							end
						elseif y == adjacentRow - 1 and x == adjacentColumn + 1 then
							if adjacentDoors & (1 << DoorSlot.UP1) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.UP1})
								end
							end
						elseif y == adjacentRow + 1 and x == adjacentColumn then
							-- CANNOT GO HERE
						elseif y == adjacentRow + 2 and x == adjacentColumn + 1 then
							if adjacentDoors & (1 << DoorSlot.DOWN1) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.DOWN1})
								end
							end
						elseif y == adjacentRow and x == adjacentColumn - 1 then
							if adjacentDoors & (1 << DoorSlot.LEFT0) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.LEFT0})
								end
							end
						elseif y == adjacentRow + 1 and x == adjacentColumn then
							-- CANNOT GO HERE
						elseif y == adjacentRow and x == adjacentColumn + 2 then
							if adjacentDoors & (1 << DoorSlot.RIGHT0) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.RIGHT0})
								end
							end
						elseif y == adjacentRow + 1 and x == adjacentColumn + 2 then
							if adjacentDoors & (1 << DoorSlot.RIGHT1) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.RIGHT1})
								end
							end
						end
					elseif adjacentShape == RoomShape.ROOMSHAPE_LBR then
						if y == adjacentRow - 1 and x == adjacentColumn then
							if adjacentDoors & (1 << DoorSlot.UP0) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.UP0})
								end
							end
						elseif y == adjacentRow - 1 and x == adjacentColumn + 1 then
							if adjacentDoors & (1 << DoorSlot.UP1) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.UP1})
								end
							end
						elseif y == adjacentRow + 2 and x == adjacentColumn then
							if adjacentDoors & (1 << DoorSlot.DOWN0) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.DOWN0})
								end
							end
						elseif y == adjacentRow + 1 and x == adjacentColumn + 1 then
							-- CANNOT GO HERE
						elseif y == adjacentRow and x == adjacentColumn - 1 then
							if adjacentDoors & (1 << DoorSlot.LEFT0) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.LEFT0})
								end
							end
						elseif y == adjacentRow + 1 and x == adjacentColumn - 1 then
							if adjacentDoors & (1 << DoorSlot.LEFT1) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.LEFT1})
								end
							end
						elseif y == adjacentRow and x == adjacentColumn + 2 then
							if adjacentDoors & (1 << DoorSlot.RIGHT0) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.RIGHT0})
								end
							end
						elseif y == adjacentRow + 1 and x == adjacentColumn + 1 then
							-- CANNOT GO HERE
						end
					else
						if y == adjacentRow - 1 and x == adjacentColumn then
							if adjacentDoors & (1 << DoorSlot.UP0) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.UP0})
								end
							end
						elseif y == adjacentRow + 1 and x == adjacentColumn then
							if adjacentDoors & (1 << DoorSlot.DOWN0) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.DOWN0})
								end
							end
						elseif y == adjacentRow and x == adjacentColumn - 1 then
							if adjacentDoors & (1 << DoorSlot.LEFT0) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.LEFT0})
								end
							end
						elseif y == adjacentRow and x == adjacentColumn + 1 then
							if adjacentDoors & (1 << DoorSlot.RIGHT0) ~= 0 then
								for i = 1, math.abs(y - bossRoomY) + math.abs(x - bossRoomX) do
									table.insert(possibleLocations, {Index = adjacentRow * 13 + adjacentColumn, NewIndex = y * 13 + x, DoorSlot = DoorSlot.RIGHT0})
								end
							end
						end
					end
				end
			end
		end
	end

	if #possibleLocations == 0 then
		return
	end
	local rng = RNG()
	rng:SetSeed(math.max(1, game:GetLevel():GetDungeonPlacementSeed()), 37)
	return possibleLocations[rng:RandomInt(#possibleLocations) + 1]
end

local function getLeaveDoorSlot(enter)
	if enter == DoorSlot.UP0 or enter == DoorSlot.UP1 then
		return DoorSlot.DOWN0
	elseif enter == DoorSlot.DOWN0 or enter == DoorSlot.DOWN1 then
		return DoorSlot.UP0
	elseif enter == DoorSlot.LEFT0 or enter == DoorSlot.LEFT1 then
		return DoorSlot.RIGHT0
	elseif enter == DoorSlot.RIGHT0 or enter == DoorSlot.RIGHT1 then
		return DoorSlot.LEFT0
	end
end

mod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_LEVEL, -1 * math.huge, function()
	futureEntranceRooms = {}
end)

mod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_LEVEL, CallbackPriority.LATE, function()
	FiendFolio.savedata.GateCurseRoomListIndex = nil
	FiendFolio.savedata.GateCurseRoomSubtype = nil

	if FiendFolio.GatedBosses and not (mod:isInvalidGateFloor(false) or mod:isInvalidGateChallenge()) then
		local level = game:GetLevel()
		level:AddCurse(1 << (FiendFolio.curses.gateCurse - 1), false)
	end

	if Isaac.CountEntities(nil, EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.BOSS_KEYGHOST) > 0 then
		for _, player in ipairs(PlayerManager.GetPlayers()) do
			player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS, true)
			--mod:removeBossKeyghost(player)
		end
	end

	if levelHasCurse(FiendFolio.curses.gateCurse) then
		local level = game:GetLevel()
		if game:IsGreedMode() or game:GetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH) or game.Challenge == FiendFolio.challenges.theGauntlet then
			level:RemoveCurses(1 << (FiendFolio.curses.gateCurse - 1))
			return
		end

		local roomLocation = findGateRoomLocation()
		if roomLocation == nil then
			--print("GATECURSE: COULDN'T FIND ANYWHERE TO PLACE ROOM")
			if FiendFolio.GatedBosses or Isaac.GetChallenge() == mod.challenges.blursed then
				Isaac.ExecuteCommand("reseed")
			else
				level:RemoveCurses(1 << (FiendFolio.curses.gateCurse - 1))
			end
			return
		end

		local levelstage = level:GetStage()
		local stagetype = level:GetStageType()
		local gamemode = game.Difficulty
		local stbType, subtype = stageEnumToStbAndSubtype(levelstage, stagetype)

		local seed = math.max(1, game:GetLevel():GetDungeonPlacementSeed())
		local minDifficulty, maxDifficulty = getRoomDifficulties(levelstage, gamemode)
		local newDoorSlot = getLeaveDoorSlot(roomLocation.DoorSlot)
		local room = RoomConfigHolder.GetRandomRoom(seed, false,
		                                            stbType, RoomType.ROOM_DEFAULT, RoomShape.ROOMSHAPE_1x1,
		                                            0, -1,
		                                            minDifficulty, maxDifficulty,
		                                            1 << newDoorSlot, subtype, -1)

		if room and room.Subtype == subtype and level:MakeRedRoomDoor(roomLocation.Index, roomLocation.DoorSlot) then
			local overwriteRoom = level:GetRoomByIdx(roomLocation.NewIndex)
			overwriteRoom.Data = room
			overwriteRoom.Flags = 0

			local overwriteX = roomLocation.NewIndex % 13
			local overwriteY = math.floor(roomLocation.NewIndex / 13)
			local currentX = level:GetCurrentRoomIndex() % 13
			local currentY = math.floor(level:GetCurrentRoomIndex() / 13)
			local roomDist = math.abs(overwriteX - currentX) + math.abs(overwriteY - currentY)

			if mod.anyPlayerHas(CollectibleType.COLLECTIBLE_SPELUNKER_HAT) and roomDist <= 2 then
				overwriteRoom.DisplayFlags = RoomDisplayFlags.VISIBLE | RoomDisplayFlags.SHOW_ICON
			elseif roomDist <= 1 then
				overwriteRoom.DisplayFlags = RoomDisplayFlags.VISIBLE | RoomDisplayFlags.SHOW_ICON
			elseif level:GetStateFlag(LevelStateFlag.STATE_FULL_MAP_EFFECT) then
				overwriteRoom.DisplayFlags = RoomDisplayFlags.VISIBLE | RoomDisplayFlags.SHOW_ICON
			else
				local flags = 0
				if level:GetStateFlag(LevelStateFlag.STATE_COMPASS_EFFECT) then
					flags = flags | RoomDisplayFlags.SHOW_ICON
				end
				if level:GetStateFlag(LevelStateFlag.STATE_MAP_EFFECT) then
					flags = flags | RoomDisplayFlags.VISIBLE
				end
				overwriteRoom.DisplayFlags = flags
			end
			level:UpdateVisibility()

			-- old system based on stageapi but it wasn't consistent so oops repentogon
			--[[local gatecurseRooms = stageEnumToGatecurseRooms(levelstage, stagetype)
			local gatecurseRoom = StageAPI.LevelRoom{
				RoomType = RoomType.ROOM_DEFAULT,
				RequireRoomType = true,
				RoomsList = gatecurseRooms,
				RoomDescriptor = overwriteRoom
			}
			StageAPI.SetLevelRoom(gatecurseRoom, overwriteRoom.ListIndex)]]--

			FiendFolio.savedata.GateCurseRoomListIndex = overwriteRoom.ListIndex
			FiendFolio.savedata.GateCurseRoomSubtype = subtype
			if gt then
				gt:new_level()
			end

			--print("GATECURSE: PLACED ROOM AT " .. roomLocation.NewIndex % 13 .. "," .. math.floor(roomLocation.NewIndex / 13))
		else
			--print("GATECURSE: FAILED TO PLACE ROOM AT " .. roomLocation.NewIndex % 13 .. "," .. math.floor(roomLocation.NewIndex / 13))
			level:RemoveCurses(1 << (FiendFolio.curses.gateCurse - 1))
			return
		end
	end
end)

if MinimapAPI then
mod:AddPriorityCallback(ModCallbacks.MC_POST_RENDER, CallbackPriority.IMPORTANT - 2, function()
	-- i dunno what minimapapi is doing to lose the minimap after POST_NEW_LEVEL at the start of every game, but it's doing it
	-- as a result this code gets to exist
	-- also manually handling displayflags as a failsafe for stuff like save/continue
	if levelHasCurse(FiendFolio.curses.gateCurse) then
		local level = game:GetLevel()
		if level:GetDimension() ~= Dimension.NORMAL then
			return
		end

		local minimapRoom = MinimapAPI:GetRoomByID("FFGateCurseRoom")
		if not minimapRoom then
			local roomlist = level:GetRooms()

			for i = roomlist:__len() - 1, 0, -1 do
				local room = roomlist:Get(i)
				if room.ListIndex == FiendFolio.savedata.GateCurseRoomListIndex then
					minimapRoom = MinimapAPI:GetRoomAtPosition(MinimapAPI:GridIndexToVector(room.GridIndex))
					break
				end
			end
		end

		if minimapRoom then
			minimapRoom.ID = "FFGateCurseRoom"
			minimapRoom.PermanentIcons = {"FFGateCurseRoom"}

			minimapRoom.AdjacentDisplayFlags = 1
			minimapRoom.IgnoreDescriptorFlags = true
			if not minimapRoom.Visited and minimapRoom.DisplayFlags & 4 > 0 and
			   not (level:GetStateFlag(LevelStateFlag.STATE_FULL_MAP_EFFECT) or level:GetStateFlag(LevelStateFlag.STATE_COMPASS_EFFECT))
			then
				minimapRoom.DisplayFlags = minimapRoom.DisplayFlags & ~4
			end

			minimapRoom.Color = nil
		end
	end
end)
end

function mod:FindGateCurseRoom()
	if FiendFolio.savedata.GateCurseRoomListIndex then
		local room = game:GetLevel():GetRoomByIdx(FiendFolio.savedata.GateCurseRoomListIndex)
		if room and mod:isCurseOfTheGateRoom(room) and room.Flags & RoomDescriptor.FLAG_RED_ROOM == 0 then
			return room
		end
	end
	local rooms = game:GetLevel():GetRooms()
	for i = 0, rooms.Size-1 do
		local room = rooms:Get(i)
		if mod:isCurseOfTheGateRoom(room) and room.Flags & RoomDescriptor.FLAG_RED_ROOM == 0 then
			FiendFolio.savedata.GateCurseRoomListIndex = room.GridIndex
			FiendFolio.savedata.GateCurseRoomSubtype = room.Data.Subtype
			return room
		end
	end
end

-- FAILSAFE: If the player is in the key room but there is no key, no spawner and no pedestal, spawn the key OR consider the key obtained.
function mod:CurseOfTheGateKeyFailsafeChecker()
	local room = game:GetLevel():GetCurrentRoomDesc()
	if not FiendFolio.savedata.GateCurseKeyCollected and game:GetRoom():GetFrameCount() > 1
	and mod:isCurseOfTheGateRoom(room) and room.Flags & RoomDescriptor.FLAG_RED_ROOM == 0 then
		if mod:GetGateCurseRoomSave().GateCurseRoomCollectedKey then
			FiendFolio.GateCurseRoomShouldBeBarred = false
			FiendFolio.savedata.GateCurseKeyCollected = 0
			Isaac.GetPlayer():AddCacheFlags(CacheFlag.CACHE_FAMILIARS, true)
		elseif Isaac.CountEntities(nil, EntityType.ENTITY_PICKUP, mod.PICKUP.VARIANT.GATECURSE_KEY) == 0
		and (
			Isaac.CountEntities(nil, mod.FF.CurseOfTheGatePedestal.ID, mod.FF.CurseOfTheGatePedestal.Var, mod.FF.CurseOfTheGatePedestal.Sub) == 0
			or (mod:GetGateCurseRoomSave().GateCurseRoomKeySpawned and not mod.IsActiveRoom())
		) and Isaac.CountEntities(nil, mod.FFID.Tech, mod.FF.CurseOfTheGateKeySpawner.Var) == 0 then
			if FiendFolio.savedata.TriggeredGateKeySpawnFailsafe then
				Console.PrintError("[FF] ERROR: Curse of the Gate Key missing, again!! Failsafe triggered, considering key collected...")
				mod:GetGateCurseRoomSave().GateCurseRoomCollectedKey = true
				FiendFolio.GateCurseRoomShouldBeBarred = false
				FiendFolio.savedata.GateCurseKeyCollected = 0
				Isaac.GetPlayer():AddCacheFlags(CacheFlag.CACHE_FAMILIARS, true)
			else
				Console.PrintError("[FF] ERROR: Curse of the Gate Key missing! Failsafe triggered, spawning key...")
				FiendFolio.savedata.TriggeredGateKeySpawnFailsafe = true
				local e = Isaac.FindByType(mod.FF.CurseOfTheGatePedestal.ID, mod.FF.CurseOfTheGatePedestal.Var, mod.FF.CurseOfTheGatePedestal.Sub)[1] or Isaac.GetPlayer()
				spawnGateKey(e.Position)
			end
		end
	end
end
mod:AddManualCallback(ModCallbacks.MC_POST_UPDATE, mod.CurseOfTheGateKeyFailsafeChecker)

function mod:CheckGateCurseKeyFailsafeCallback()
	if levelHasCurse(FiendFolio.curses.gateCurse) and not FiendFolio.savedata.GateCurseKeyCollected and mod:isCurseOfTheGateRoom() then
		mod:EnableManualCallback(ModCallbacks.MC_POST_UPDATE, mod.CurseOfTheGateKeyFailsafeChecker)
	else
		mod:DisableManualCallback(ModCallbacks.MC_POST_UPDATE, mod.CurseOfTheGateKeyFailsafeChecker)
	end
end
if Isaac.IsInGame() then
	mod:CheckGateCurseKeyFailsafeCallback()
end

-- FAILSAFE: If the gate room is somehow nonexistent or replaced (before the key is obtained), remove the curse.
function mod:CheckGateCurseRoomFailsafe()
	if levelHasCurse(FiendFolio.curses.gateCurse) and not FiendFolio.savedata.GateCurseKeyCollected and not mod:FindGateCurseRoom() then
		Console.PrintError("[FF] ERROR: Failed to locate Curse of the Gate key room! Failsafe triggered, removing curse...")
		game:GetLevel():RemoveCurses(1 << (FiendFolio.curses.gateCurse - 1))
	end
end
