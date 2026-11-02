local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

mod.HAPPY_SQUIRREL_ARCADE_SUB = 523

function mod:IsInHappySquirrelArcade()
	local level = game:GetLevel()
	local desc = level:GetCurrentRoomDesc()
	return (
		desc.Data
		and desc.Data.Type == RoomType.ROOM_ARCADE
		and desc.Data.Subtype == mod.HAPPY_SQUIRREL_ARCADE_SUB
	)
end

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player, flags)
	Isaac.Spawn(5, 40, FiendFolio.PICKUP.BOMB.COPPER, player.Position + Vector(40, 0), Vector.Zero, nil)
	Isaac.Spawn(5, 20, FiendFolio.PICKUP.COIN.CURSED, player.Position + Vector(0, 40), Vector.Zero, nil)
	Isaac.Spawn(5, 30, FiendFolio.PICKUP.KEY.SPICY_PERM, player.Position + Vector(-40, 0), Vector.Zero, nil)

	if mod.ACHIEVEMENT.IMMORAL_HEART:IsUnlocked() then
		Isaac.Spawn(5, FiendFolio.PICKUP.VARIANT.IMMORAL_HEART, 0, player.Position + Vector(0, -40), Vector.Zero, nil)
	end

	sfx:Play(SoundEffect.SOUND_BLACK_POOF, 1.5, 1, false, 2)
	local effect = Isaac.Spawn(1000, 16, 0, player.Position, Vector.Zero, nil):ToEffect() 
	effect.Color = mod.ColorDarkPurple
	effect:Update()
end, mod.ITEM.CARD.MISPRINTED_JUSTICEJACK)

-- happy squirrel
mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player, flags)
	local rng = player:GetCardRNG(mod.ITEM.CARD.HAPPY_SQUIRREL)
	local roomLayout = RoomConfig.GetRandomRoom(
		rng:Next(), -- Seed
		false, -- Decrease weight
		StbType.SPECIAL_ROOMS, -- Stage type
		RoomType.ROOM_ARCADE, -- Room type
		nil, -- Shape
		nil, nil, -- Variant
		nil, nil, -- Difficulty
		nil, -- Required doors
		mod.HAPPY_SQUIRREL_ARCADE_SUB, -- Subtype
		0 -- Game mode (0 = normal, 1 = greed)
	)

	-- hi sunil -cat
	if roomLayout then
		local debugRoom = game:GetLevel():GetRoomByIdx(GridRooms.ROOM_DEBUG_IDX)
		debugRoom:InitSeeds(rng)
		debugRoom.Data = roomLayout
		debugRoom.Clear = false
		game:StartRoomTransition(GridRooms.ROOM_DEBUG_IDX, Direction.NO_DIRECTION, RoomTransitionAnim.TELEPORT, player)

		sfx:Play(mod.Sounds.HappySquirrel)
		mod:trySayAnnouncerLine(mod.Sounds.VACardHappySquirrel, flags, 30)
	end
end, mod.ITEM.CARD.HAPPY_SQUIRREL)

-- neko nyan quiz card (goby?!)
local NYAN_TIME_MAX = 900
local RARE_GOBY_MEOW = 0.05
local SUPERRARE_GOBY_MEOW = 0.001
mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player, flags)
	local savedata = mod:GetEntityData(player).ffsavedata
	savedata.NyanTime = game:GetFrameCount()
	
	local effects = player:GetEffects()
	effects:AddNullEffect(mod.ITEM.NULL.GOBY)

	-- cool effects...
	Isaac.Spawn(1000, 15, 0, player.Position, Vector.Zero, nil) 
	game:GetHUD():ShowItemText("Goby?!")
	sfx:Play(SoundEffect.SOUND_POWERUP_SPEWER)

	-- play a random goby meow
	local roll = math.random()
	if roll > RARE_GOBY_MEOW then
		sfx:Play(mod.Sounds.GobyCommon)
	elseif roll > SUPERRARE_GOBY_MEOW then
		sfx:Play(mod.Sounds.GobyRare)
	else
		sfx:Play(mod.Sounds.GobySuperSpecialAwesome)
	end

	mod:trySayAnnouncerLine(mod.Sounds.VACardNekoNyan, flags, 60)
end, mod.ITEM.CARD.NEKO_NYAN_QUIZ_CARD)

-- effect removals on new room:
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	for _, player in ipairs(PlayerManager.GetPlayers()) do
		local effects = player:GetEffects()
		local save = mod:GetEntityData(player).ffsavedata

		-- check for goby
		if save.NyanTime and game:GetFrameCount() - save.NyanTime > NYAN_TIME_MAX then
			effects:RemoveNullEffect(mod.ITEM.NULL.GOBY, -1)
			save.NyanTime = nil
		end
	end

	-- also handle the happy squirrel failsafe in here
	if mod:IsInHappySquirrelArcade() then
		local level = game:GetLevel()
		if level:GetPreviousRoomIndex() == level:GetCurrentRoomIndex() then
			-- Impossible to leave, make the door take you to the starting room
			local startingRoom = level:GetStartingRoomIndex()
			game:ChangeRoom(startingRoom)
		end
	end
end)

function mod:GobyFlightCache(player, flag)
	local effects = player:GetEffects()
    if effects:HasNullEffect(mod.ITEM.NULL.GOBY) then
		player.CanFly = true
	end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.GobyFlightCache, CacheFlag.CACHE_FLYING)

-- eye of TRUTH!!!!
-- i'm still doing the hacky wisp thingy for most effects cause either AddCollectibleEffect doesn't seem to work properly for most things or i'm not sure how to use it correctly yet
mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player, flags)
	sfx:Play(SoundEffect.SOUND_PLOP, 1, 1, false, 0.33)
	mod:AddInnateCollectibleForRoom(player, CollectibleType.COLLECTIBLE_GUPPYS_EYE)
	mod:trySayAnnouncerLine(mod.Sounds.VACardEyeOfTruth, flags, 30)
end, mod.ITEM.CARD.EYE_OF_TRUTH)

-- mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player, flags)
	-- sfx:Play(mod.Sounds.SunilMeow) -- fun fact: my voice :3
	-- local buddy = Isaac.Spawn(891, 0, 0, player.Position + RandomVector():Resized(20), Vector.Zero, player):ToNPC()
	-- buddy:AddCharmed(EntityRef(player), -1)
	-- buddy.SpawnerEntity = player
	-- buddy:Update()
	-- local buddy2 = Isaac.Spawn(891, 1, 0, player.Position + RandomVector():Resized(20), Vector.Zero, player):ToNPC()
	-- buddy2:AddCharmed(EntityRef(player), -1)
	-- buddy2.SpawnerEntity = player
	-- buddy2:Update()
-- end, mod.ITEM.CARD.RESCUE_CAT)

-- friendly fire
mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player, flags)
	sfx:Play(mod.Sounds.FireballLand, 1, 1, false, 1.33)
	mod:AddInnateCollectibleForRoom(player, mod.ITEM.COLLECTIBLE.FRIENDS_FIREBALL_FORMULA)
    local effect = Isaac.Spawn(1000, 15, 0, player.Position, Vector.Zero, nil):ToEffect() 
    effect.Color = mod.ColorDarkPurple
    effect:Update()
end, mod.ITEM.CARD.FRIENDLY_FIRE)


-- yellow car stuff
local YELLOW_CAR_SPEED_BONUS = 1
local YELLOW_CAR_SPEED_MINUS = 0.15

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player, flags, cache)
	local savedata = mod:GetEntityData(player).ffsavedata
	savedata.YellowCarSpeed = YELLOW_CAR_SPEED_BONUS
	player:AddCacheFlags(CacheFlag.CACHE_SPEED, true)

	-- COOL effects...
	for i = 1, 10 do
		local effect = Isaac.Spawn(1000, 66, 0, player.Position + Vector(7, 0), Vector.Zero, nil):ToEffect() 
		effect.Color = mod.ColorCarrotOrange
		effect.SpriteScale = Vector(1,1)
		effect:Update()
	end
	for i = 1, 10 do
		local effect2 = Isaac.Spawn(1000, 66, 0, player.Position + Vector(-14, 0), Vector.Zero, nil):ToEffect() 
		effect2.Color = mod.ColorCarrotOrange
		effect2.SpriteScale = Vector(1,1)
		effect2:Update()
	end
	sfx:Play(mod.Sounds.CarWheel)
	mod:trySayAnnouncerLine(mod.Sounds.VAObjectYellowCar, flags, 60)
end, mod.ITEM.CARD.YELLOW_CAR)

-- toy lucky paw stuff
local usedBunoy = 0
local bunbunLuck = 7.77

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player, flags, cache)
	local effects = player:GetEffects()
	effects:AddNullEffect(mod.ITEM.NULL.BUNBUN_LUCK)

	-- COOL!!!! effects
	sfx:Play(mod.Sounds.PlasticCrunch)
	-- local savedata = mod:GetEntityData(player).ffsavedata
	-- savedata.playerThatUsedToyBunny = player
	for i = 1, 5 do
		local effect = Isaac.Spawn(1000, 27, 0, player.Position + Vector(0, 5), Vector.Zero, nil):ToEffect() 
		effect.Color = mod.ColorSpittyGreen
		-- effect.SpriteScale = Vector(1.5,1.5)
		effect:Update()
	end
	mod:trySayAnnouncerLine(mod.Sounds.VAObjectLuckyDuck, flags, 30)
end, mod.ITEM.CARD.LUCKY_DUCK)

-- round glasses
mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player, flags)
	mod:AddInnateCollectibleForRoom(player, CollectibleType.COLLECTIBLE_20_20)
	mod:AddInnateCollectibleForRoom(player, CollectibleType.COLLECTIBLE_TROPICAMIDE)
	
	local effects = player:GetEffects()
	effects:AddNullEffect(mod.ITEM.NULL.COMICAL_ROUND_GLASSES_COSTUME)

	-- coooooool effects B)
	sfx:Play(mod.Sounds.AnimeShine)

	local effect = Isaac.Spawn(1000, 173, 0, player.Position + Vector(-5, 2), Vector.Zero, player):ToEffect() 
	-- effect.SpriteScale = Vector(0.5,0.5)
	effect:FollowParent(player)
	effect:Update()

	mod:trySayAnnouncerLine(mod.Sounds.VAObjectComicalRoundGlasses, flags, 30)
end, mod.ITEM.CARD.COMICAL_ROUND_GLASSES)

-- room clear stuff
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, function()
    for _, player in ipairs(PlayerManager.GetPlayers()) do
		local save = mod:GetEntityData(player).ffsavedata

		-- yellow car speed
		if save.YellowCarSpeed then
			save.YellowCarSpeed = save.YellowCarSpeed - YELLOW_CAR_SPEED_MINUS
			if save.YellowCarSpeed <= 0 then
				save.YellowCarSpeed = nil
			end

			player:AddCacheFlags(CacheFlag.CACHE_SPEED, true)
		end
    end
end)

-- effect removals on new floor:
-- mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    -- for _, player in ipairs(PlayerManager.GetPlayers()) do
		-- usedCar = 0
		-- player:AddCacheFlags(CacheFlag.CACHE_SPEED)
		-- player:EvaluateItems()
    -- end
-- end)

-- scrapped alt idea for happy squirrel, would have spawned a golden slot machine but that's a bit boring/would make it less special
-- mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player, flags)
		-- Isaac.Spawn(6, 1040, 0, player.Position + Vector(0, 40), Vector.Zero, nil)
		-- sfx:Play(SoundEffect.SOUND_SLOTSPAWN, 1.5, 0, false, 1)
		-- sfx:Play(SoundEffect.SOUND_GOLD_HEART_DROP, 1.5, 0, false, 1)
		-- Isaac.Spawn(1000, 40, 0, player.Position + Vector(0, 43), Vector.Zero, nil):ToEffect()
        -- local effect = Isaac.Spawn(1000, 15, 0, player.Position + Vector(0, 41), Vector.Zero, nil):ToEffect() 
        -- effect.Color = mod.ColorHoneyYellow
        -- effect:Update()
-- end, mod.ITEM.CARD.HAPPY_SQUIRREL)
