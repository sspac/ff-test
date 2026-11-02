local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local itemConfig = Isaac.GetItemConfig()
local flagsManager = TearFlagsLib
flagsManager.RegisterTearFlag("KALU")

local DEAD_DOG_REVIVE = mod.ITEM.NULL.DEAD_DOG_REVIVE

local function GetDogSpriteFromDogFolderForTheDoubleDogErrorRoomDogAkaDogDogDogDog()
	local numDogs = #mod.DogPictures
	local dog = (Random() % numDogs) + 1
	return "gfx/effects/dogs/" .. mod.DogPictures[dog] .. ".png"
end

local function RerollDogDogDogDogItemSpriteToARandomDog()
	Isaac.GetItemConfig():GetCollectible(mod.ITEM.COLLECTIBLE.DOG_DOG_DOG_DOG).GfxFileName = GetDogSpriteFromDogFolderForTheDoubleDogErrorRoomDogAkaDogDogDogDog()
end

local DOUBLE_DOG_DOG_ITEMS = {
	[mod.ITEM.COLLECTIBLE.DEFAULT_DOG] = {
		DogDamage = 3.5,
		DogFireCooldown = 16,
		DogTearHeight = -10,
		DogTearFallingSpeed = -1.5,
	},
	[mod.ITEM.COLLECTIBLE.DAUNTING_DOG] = {
		DogSpritesheet = "daunting_dog",
		DogAddedTearSize = 0.2,
		DogDamage = 5,
		DogFireCooldown = 30,
		DogTearInit = function(dog, tear, data)
			FiendFolio.FlagBruise(tear, 90, 1, 1)
		end,
		DogTearColor = Color(0.5, 0.4, 0.5, 1.0, 0.1, 0, 0.1),
	},
	[mod.ITEM.COLLECTIBLE.DESTINED_DOG] = {
		DogSpritesheet = "destined_double_dog_dog",
		DogDamage = 4,
		DogAddedTearSize = 0.2,
		DogFireCooldown = 16,
		DogTearVariant = TearVariant.BLOOD,
	},
	[mod.ITEM.COLLECTIBLE.DEVIL_DOG] = {
		DogSpritesheet = "devil_dog",
		DogDamage = 6.66,
		DogAddedTearSize = 0.2,
		DogFireCooldown = 33,
		DogTearVariant = TearVariant.BLOOD,
		DogTearInit = function(dog, tear, data)
			FiendFolio.FlagDoom(tear, 180, 3, dog.Player.Damage * 4, -1)
		end,
		DogTearColor = Color(0.30, 0.30, 0.30, 1.0, 10/255, -25/255, -25/255),
	},
	[mod.ITEM.COLLECTIBLE.DIVINE_DOG] = {
		DogSpritesheet = "divine_dog",
		DogDamage = 5,
		DogFireCooldown = 14,
		DogTearHeight = -24,
		DogTearInit = function(dog, tear, data)
			FiendFolio.FlagMartyr(tear, 150)
		end,
		DogTearColor = Color(1.0, 1.0, 1.0, 1.0, 25/255, 60/255, 80/255),
	},
	[mod.ITEM.COLLECTIBLE.DEAD_DOG] = {
		DogSpritesheet = "dead_dog",
		DogDamage = 4,
		DogFireCooldown = 13,
		DogTearVariant = TearVariant.BONE,
		DogTearFlags = TearFlags.TEAR_BONE,
		DogPickup = function(player, firstTime, charge)
			if firstTime or charge > 0 then
				player:GetEffects():AddNullEffect(mod.ITEM.NULL.DEAD_DOG_REVIVE)
			end
		end,
	},
	[mod.ITEM.COLLECTIBLE.DISCOUNT_DOG] = {
		DogSpritesheet = "discount_dog",
		DogTearVariant = TearVariant.COIN,
		DogPickup = function(player, firstTime)
			if not firstTime then return end
			local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.DISCOUNT_DOG)
			local numcoins = mod:RandomInt(2, 4, rng)
			local numbombs = 1
			local numkeys = 1
			local roll = rng:RandomInt(3)
			if roll == 0 then
				numbombs = numbombs + 1
			elseif roll == 1 then
				numkeys = numkeys + 1
			end
			local spawnFunc = function(pickupVariant, t)
				mod.scheduleForUpdate(function()
					local pos = game:GetRoom():FindFreePickupSpawnPosition(player.Position, 20)
					Isaac.Spawn(EntityType.ENTITY_PICKUP, pickupVariant, 1, pos, mod.nilvector, nil)
				end, t)
			end
			for i=1, numcoins do
				spawnFunc(PickupVariant.PICKUP_COIN, i*2)
			end
			for i=1, numbombs do
				spawnFunc(PickupVariant.PICKUP_BOMB, 3 + i*2)
			end
			for i=1, numkeys do
				spawnFunc(PickupVariant.PICKUP_KEY, 1 + i*3)
			end
		end,
	},
	[mod.ITEM.COLLECTIBLE.KALU] = {
		DogSpritesheet = "kalu",
		DogDamage = 7,
		DogAddedTearSize = 0.4,
		DogTearInit = function(dog, tear, data)
			flagsManager.AddTearFlags(tear, flagsManager.Flag.KALU)
		end,
	},
	[mod.ITEM.COLLECTIBLE.DEWEY_DECIMAL_DOG] = {
		DogSpritesheet = "dewey_decimal_dog",
		DogFireCooldown = 14,
		DogTearHeight = -24,
		DogTearFlags = TearFlags.TEAR_TURN_HORIZONTAL,
	},
	[mod.ITEM.COLLECTIBLE.DWARF_DOG] = {
		DogDamage = 3,
		DogSpritesheet = "dwarf_dog",
		DogFireCooldown = 21,
		DogTearFlags = TearFlags.TEAR_ORBIT_ADVANCED | TearFlags.TEAR_SPECTRAL,
		DogTearFallingSpeed = -10,
	},
	[mod.ITEM.COLLECTIBLE.DOG_DOG_DOG_DOG] = {
		DogPickup = function(player)
			RerollDogDogDogDogItemSpriteToARandomDog()
		end,
	},
}

mod:AddCallback(ModCallbacks.MC_PRE_PLANETARIUM_APPLY_TELESCOPE_LENS, function(_, chance)
	if PlayerManager.AnyoneHasCollectible(mod.ITEM.COLLECTIBLE.DWARF_DOG) then
		return chance + 0.15
	end
end)

local DOUBLE_DOG_DOGS_BY_DOG_POOL = {
	[ItemPoolType.POOL_BOSS] = mod.ITEM.COLLECTIBLE.DAUNTING_DOG,
	[ItemPoolType.POOL_GREED_BOSS] = mod.ITEM.COLLECTIBLE.DAUNTING_DOG,
	[ItemPoolType.POOL_DEVIL] = mod.ITEM.COLLECTIBLE.DEVIL_DOG,
	[ItemPoolType.POOL_GREED_DEVIL] = mod.ITEM.COLLECTIBLE.DEVIL_DOG,
	[ItemPoolType.POOL_ANGEL] = mod.ITEM.COLLECTIBLE.DIVINE_DOG,
	[ItemPoolType.POOL_GREED_ANGEL] = mod.ITEM.COLLECTIBLE.DIVINE_DOG,
	[ItemPoolType.POOL_SECRET] = mod.ITEM.COLLECTIBLE.DEAD_DOG,
	[ItemPoolType.POOL_GREED_SECRET] = mod.ITEM.COLLECTIBLE.DEAD_DOG,
	[ItemPoolType.POOL_ULTRA_SECRET] = mod.ITEM.COLLECTIBLE.DESTINED_DOG,
	[ItemPoolType.POOL_SHOP] = mod.ITEM.COLLECTIBLE.DISCOUNT_DOG,
	[ItemPoolType.POOL_BABY_SHOP] = mod.ITEM.COLLECTIBLE.DISCOUNT_DOG,
	[ItemPoolType.POOL_GREED_SHOP] = mod.ITEM.COLLECTIBLE.DISCOUNT_DOG,
	[ItemPoolType.POOL_CURSE] = mod.ITEM.COLLECTIBLE.KALU,
	[ItemPoolType.POOL_GREED_CURSE] = mod.ITEM.COLLECTIBLE.KALU,
	[ItemPoolType.POOL_PLANETARIUM] = mod.ITEM.COLLECTIBLE.DWARF_DOG,
	[ItemPoolType.POOL_LIBRARY] = mod.ITEM.COLLECTIBLE.DEWEY_DECIMAL_DOG,
}

local DOUBLE_DOG_DOGS_BY_DOG_ROOM = {
	[RoomType.ROOM_BOSS] = mod.ITEM.COLLECTIBLE.DAUNTING_DOG,
	[RoomType.ROOM_MINIBOSS] = mod.ITEM.COLLECTIBLE.DAUNTING_DOG,
	[RoomType.ROOM_CHALLENGE] = mod.ITEM.COLLECTIBLE.DAUNTING_DOG,
	[RoomType.ROOM_DEVIL] = mod.ITEM.COLLECTIBLE.DEVIL_DOG,
	[RoomType.ROOM_ANGEL] = mod.ITEM.COLLECTIBLE.DIVINE_DOG,
	[RoomType.ROOM_SECRET] = mod.ITEM.COLLECTIBLE.DEAD_DOG,
	[RoomType.ROOM_SUPERSECRET] = mod.ITEM.COLLECTIBLE.DEAD_DOG,
	[RoomType.ROOM_ULTRASECRET] = mod.ITEM.COLLECTIBLE.DESTINED_DOG,
	[RoomType.ROOM_BLACK_MARKET] = mod.ITEM.COLLECTIBLE.DEAD_DOG,
	[RoomType.ROOM_SHOP] = mod.ITEM.COLLECTIBLE.DISCOUNT_DOG,
	[RoomType.ROOM_ARCADE] = mod.ITEM.COLLECTIBLE.DISCOUNT_DOG,
	[RoomType.ROOM_CURSE] = mod.ITEM.COLLECTIBLE.KALU,
	[RoomType.ROOM_SACRIFICE] = mod.ITEM.COLLECTIBLE.KALU,
	[RoomType.ROOM_ERROR] = mod.ITEM.COLLECTIBLE.DOG_DOG_DOG_DOG,
	[RoomType.ROOM_PLANETARIUM] = mod.ITEM.COLLECTIBLE.DWARF_DOG,
	[RoomType.ROOM_LIBRARY] = mod.ITEM.COLLECTIBLE.DEWEY_DECIMAL_DOG,
}

local function DoubleDogDogFamiliarToDoubleDogDogItem(dogFamiliarID)
	return dogFamiliarID + mod.ITEM.COLLECTIBLE.DEFAULT_DOG
end

local function DoubleDogDogItemToDoubleDogDogFamiliar(dogItemID)
	return dogItemID - mod.ITEM.COLLECTIBLE.DEFAULT_DOG
end

local function GetDoubleDogDogForRoom()
	local room = game:GetRoom()
	local roomType = room:GetType()
	if roomType == RoomType.ROOM_ERROR then
		-- Override any pool being active in the error room specifically
		return mod.ITEM.COLLECTIBLE.DOG_DOG_DOG_DOG
	end
	local pool = room:GetItemPool()
	return DOUBLE_DOG_DOGS_BY_DOG_POOL[pool] or DOUBLE_DOG_DOGS_BY_DOG_ROOM[roomType] or mod.ITEM.COLLECTIBLE.DEFAULT_DOG
end

local DOG_REPLACEMENT_BLACKLIST = {
	[mod.ITEM.COLLECTIBLE.DOUBLE_DOG] = true,
}
for dogItemID, dogInfo in pairs(DOUBLE_DOG_DOG_ITEMS) do
	DOG_REPLACEMENT_BLACKLIST[dogItemID] = true
end

local function AllowDogReplacement(queuedItemBeingAttackedByADog)
	return queuedItemBeingAttackedByADog.Item
			and not queuedItemBeingAttackedByADog.Touched
			and not queuedItemBeingAttackedByADog.Item:HasTags(ItemConfig.TAG_QUEST)
			and not DOG_REPLACEMENT_BLACKLIST[queuedItemBeingAttackedByADog.Item.ID]
end

local DOG_ATTACK_DELAY = 8
local DOG_ATTACK_DISTANCE = 125
local DOG_ATTACK_MID = DOG_ATTACK_DISTANCE * 0.4
local DOG_ATTACK_SPEED = 9

local ERROR_DOG_TEAR_VARIANTS = {
	TearVariant.TOOTH,
	TearVariant.CUPID_BLUE,
	TearVariant.PUPULA,
	TearVariant.COIN,
	TearVariant.NAIL,
	TearVariant.BLACK_TOOTH,
	TearVariant.BONE,
	TearVariant.RAZOR,
	TearVariant.BOOGER,
	TearVariant.EYE,
	TearVariant.FIST,
	TearVariant.ICE,
	TearVariant.ROCK,
}

local ERROR_DOG_TEAR_FLAGS = {
	TearFlags.TEAR_SPECTRAL,
	TearFlags.TEAR_PIERCING,
	TearFlags.TEAR_HOMING,
	TearFlags.TEAR_SLOW,
	TearFlags.TEAR_POISON,
	TearFlags.TEAR_FREEZE,
	TearFlags.TEAR_GROW,
	TearFlags.TEAR_BOOMERANG,
	TearFlags.TEAR_CHARM,
	TearFlags.TEAR_CONFUSION,
	TearFlags.TEAR_ORBIT,
	TearFlags.TEAR_BOUNCE,
	TearFlags.TEAR_FEAR,
	TearFlags.TEAR_SHRINK,
	TearFlags.TEAR_BURN,
	TearFlags.TEAR_MYSTERIOUS_LIQUID_CREEP,
	TearFlags.TEAR_LIGHT_FROM_HEAVEN,
	TearFlags.TEAR_GODS_FLESH,
	TearFlags.TEAR_BOOGER,
	TearFlags.TEAR_POP,
	TearFlags.TEAR_BAIT,
	TearFlags.TEAR_DECELERATE,
	TearFlags.TEAR_ACCELERATE,
	TearFlags.TEAR_BOUNCE_WALLSONLY,
	TearFlags.TEAR_BACKSTAB,
	TearFlags.TEAR_RAINBOW,
}

local function GetDoubleDogData(player, basedata)
	local dogdata = basedata or mod:GetEntityData(player)
	local dogsavedata = dogdata.ffsavedata
	
	if not dogdata.ffDoubleDogDogData then
		dogdata.ffDoubleDogDogData = {}
	end
	
	if not dogsavedata.PersistentDoubleDogDogData then
		dogsavedata.PersistentDoubleDogDogData = {
			RealDogsToDouble = 0,
			FakeDogsDoubled = 0,
		}
	end
	
	return dogdata.ffDoubleDogDogData, dogsavedata.PersistentDoubleDogDogData
end

mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, function(_, id, charge, firstTime, slot, vardata, player)
	local dogInfo = DOUBLE_DOG_DOG_ITEMS[id]
	if dogInfo and dogInfo.DogPickup then
		dogInfo.DogPickup(player, firstTime, charge)
	end
end)

mod:AddCallback(flagsManager.Callback.APPLY_TEARFLAG_EFFECT, function(_, entity, player, source)
	if entity:ToNPC() and not entity:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) and mod:RandomFloat() < 0.3 then
		if not entity:HasEntityFlags(EntityFlag.FLAG_FREEZE) then
			sfx:Play(mod.Sounds.BlackMoonEnd, 1.2)
		end
		entity:AddFreeze(EntityRef(player), 120)
		mod:GetEntityData(entity).KaluHeadFrozen = player
	end
end, flagsManager.Flag.KALU)

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tear)
	if flagsManager.HasTearFlags(tear, flagsManager.Flag.KALU) then
		local lightness = 0.5
		local redness = math.sin(tear.FrameCount / 3) / 5
		local blueness = math.cos(tear.FrameCount / 3) / 5
		tear.Color = Color(lightness, lightness, lightness, 0.75, 0.1 + redness, 0, 0.1 + blueness)
	end
end)

local DogSniffedItems = {}  -- Sniff
local DoggedItems = {}  -- Bark

mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, function(_, itemID, charge, firstTime, slot, varData, player)
	local dogdata, dogsavedata = GetDoubleDogData(player)
	dogsavedata.RealDogsToDouble = dogsavedata.RealDogsToDouble + 1
end, mod.ITEM.COLLECTIBLE.DOUBLE_DOG)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	DogSniffedItems = {}
end)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, CallbackPriority.EARLY, function(_, pickup, collider)
	local player = collider:ToPlayer()
	if player and mod:IsBriendTwin(player) then
		player = player:GetOtherTwin()
	end
	if player and pickup.SubType ~= 0 and not player.QueuedItem.Item then
		DogSniffedItems[GetPtrHash(pickup)] = pickup.SubType
	end
end, PickupVariant.PICKUP_COLLECTIBLE)

mod:AddPriorityCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, CallbackPriority.EARLY, function(_, pickup, collider)
	local player = collider:ToPlayer()
	if player and mod:IsBriendTwin(player) then
		player = player:GetOtherTwin()
	end
	local dogsniff = DogSniffedItems[GetPtrHash(pickup)]
	if player and dogsniff and AllowDogReplacement(player.QueuedItem) and dogsniff == player.QueuedItem.Item.ID then
		local dogdata = GetDoubleDogData(player)
		dogdata.DogTarget = dogsniff
	end
end, PickupVariant.PICKUP_COLLECTIBLE)

-- Called from `ffscripts/revives.lua`
function mod.TryDeadDogRevive(player, data, effects)
	if effects:HasNullEffect(DEAD_DOG_REVIVE) then
		player:Revive()
		player:AddMaxHearts(-999)
		player:AddMaxHearts(2)
		player:AddHearts(2)

		effects:RemoveNullEffect(mod.ITEM.NULL.DEAD_DOG_REVIVE)
		if not (game:GetLevel():GetStage() == LevelStage.STAGE8 and game:GetRoom():GetType() == RoomType.ROOM_DUNGEON) then
			game:StartRoomTransition(game:GetLevel():GetLastRoomDesc().SafeGridIndex, -1, 0, player)
		else
			player:SetMinDamageCooldown(90)
		end
		sfx:Play(SoundEffect.SOUND_DOG_HOWELL, 0.7, 0, false, 1.2)
	end
end

-- Whine
function mod:CheckDoubleDogDeadDogDogRevives(player)
	local effects = player:GetEffects()
	local revives = effects:GetNullEffectNum(mod.ITEM.NULL.DEAD_DOG_REVIVE)
	local deadDogs = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.DEAD_DOG, true)
	if revives > deadDogs then
		local toRemove = revives - deadDogs
		effects:RemoveNullEffect(mod.ITEM.NULL.DEAD_DOG_REVIVE, toRemove)

		-- Remember unused dead dog revives if they are dropped (ie, tainted isaac)
		mod.scheduleForUpdate(function()
			for _, pickup in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, mod.ITEM.COLLECTIBLE.DEAD_DOG)) do
				pickup = pickup:ToPickup()
				if toRemove > 0 and pickup.Touched and pickup.Charge < 1 then
					pickup.Charge = pickup.Charge + 1
					toRemove = toRemove - 1
				end
			end
		end, 0)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, mod.CheckDoubleDogDeadDogDogRevives, mod.ITEM.COLLECTIBLE.DEAD_DOG)

-- Woof
mod:AddPriorityCollectibleCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, CallbackPriority.EARLY, mod.ITEM.COLLECTIBLE.DOUBLE_DOG, function(_, player)
	if mod:IsBriendTwin(player) then
		return
	end

	local dogdata, dogsavedata = GetDoubleDogData(player, basedata)

	local fullDoubleDogCount = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.DOUBLE_DOG)
	local realDoubleDogCount = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.DOUBLE_DOG, true)

	if player:GetPlayerType() == mod.PLAYER.BRIEND then
		local twin = player:GetOtherTwin()
		fullDoubleDogCount = fullDoubleDogCount + twin:GetCollectibleNum(mod.ITEM.COLLECTIBLE.DOUBLE_DOG)
		realDoubleDogCount = realDoubleDogCount + twin:GetCollectibleNum(mod.ITEM.COLLECTIBLE.DOUBLE_DOG, true)

		local twindogdata, twindogsavedata = GetDoubleDogData(twin)
		if twindogsavedata.RealDogsToDouble > 0 then
			dogsavedata.RealDogsToDouble = dogsavedata.RealDogsToDouble + twindogsavedata.RealDogsToDouble
			twindogsavedata.RealDogsToDouble = 0
		end
	end

	local fakeDoubleDogCount = fullDoubleDogCount - realDoubleDogCount

	if dogsavedata.RealDogsToDouble > 0 then
		if realDoubleDogCount < dogsavedata.RealDogsToDouble then
			dogsavedata.RealDogsToDouble = realDoubleDogCount
		end
	end

	dogdata.DogIncoming = AllowDogReplacement(player.QueuedItem) and player.QueuedItem.Item.ID == dogdata.DogTarget and (dogsavedata.RealDogsToDouble > 0 or allowFakeDogTrigger)
	dogdata.AllowFakeDogTrigger = fakeDoubleDogCount > dogsavedata.FakeDogsDoubled
end)

-- Bark bark bark
function mod:DoubleDogPeffect(player, basedata)
	local dogdata, dogsavedata = GetDoubleDogData(player, basedata)
	
	if (dogdata.DogIncoming or dogsavedata.RealDogsToDouble > 0) then
		local hasDoubleDog = player:HasCollectible(mod.ITEM.COLLECTIBLE.DOUBLE_DOG)
		if not hasDoubleDog and player:GetPlayerType() == mod.PLAYER.BRIEND then
			hasDoubleDog = player:GetOtherTwin():HasCollectible(mod.ITEM.COLLECTIBLE.DOUBLE_DOG)
		end
		if not hasDoubleDog then
			dogdata.DogIncoming = nil
			dogdata.AllowFakeDogTrigger = nil
			dogsavedata.RealDogsToDouble = 0
		end
	end
	
	if not dogdata.DogIncoming then
		if dogdata.DogTarget then
			dogdata.DogTarget = nil
		end
		if dogdata.IncomingDog and dogdata.IncomingDog.Distance > DOG_ATTACK_DISTANCE then
			dogdata.IncomingDog = nil
		end
	elseif not dogdata.IncomingDog then
		local dogItemID = GetDoubleDogDogForRoom()
		if dogItemID == mod.ITEM.COLLECTIBLE.DOG_DOG_DOG_DOG then
			RerollDogDogDogDogItemSpriteToARandomDog()
		end
		local dogItem = itemConfig:GetCollectible(dogItemID)
		
		local sprite = Sprite()
		sprite:Load("gfx/005.100_collectible.anm2", false)
		sprite:Play("PlayerPickup")
		sprite:ReplaceSpritesheet(1, dogItem.GfxFileName, true)
		sprite.Offset = Vector(0, -4)
		sprite.Color.A = 0
		
		dogdata.IncomingDog = {
			Item = dogItem,
			Speed = 0,
			Distance = DOG_ATTACK_DISTANCE,
			Delay = DOG_ATTACK_DELAY,
			Sprite = sprite,
		}
		
		sfx:Play(SoundEffect.SOUND_DOG_BARK, 0.9, 0, false, 1.1)
	end
	
	if dogdata.IncomingDog and dogdata.IncomingDog.Delay > 0 then
		dogdata.IncomingDog.Delay = dogdata.IncomingDog.Delay - 1
	end
	
	if dogdata.DogIncoming and dogdata.IncomingDog and dogdata.IncomingDog.Distance <= 0 then
		local originalItem = itemConfig:GetCollectible(player.QueuedItem.Item.ID)
		local dogItem = dogdata.IncomingDog.Item
		local heldSprite = player:GetHeldSprite()
		local heldSpriteOffset = Vector(heldSprite.Offset.X, heldSprite.Offset.Y)
		
		dogdata.DogIncoming = nil
		dogdata.IncomingDog = nil
		
		if allowFakeDogTrigger then
			dogsavedata.FakeDogsDoubled = dogsavedata.FakeDogsDoubled + 1
		elseif dogsavedata.RealDogsToDouble > 0 then
			dogsavedata.RealDogsToDouble = dogsavedata.RealDogsToDouble - 1
		else
			print('epic dog failure')
			return
		end
		
		player:ClearQueueItem()
		player:QueueItem(dogItem)
		heldSprite:Load("gfx/005.100_collectible.anm2", false)
		heldSprite:Play("PlayerPickupSparkle")
		heldSprite:ReplaceSpritesheet(1, dogItem.GfxFileName, true)
		heldSprite.Offset = heldSpriteOffset
		game:GetHUD():ShowItemText(player, dogItem)
		
		local sprite = Sprite()
		sprite:Load("gfx/005.100_collectible.anm2", false)
		sprite:Play("Alternates")
		sprite:ReplaceSpritesheet(5, originalItem.GfxFileName, true)
		sprite.Offset = Vector(0, -4)
		
		table.insert(DoggedItems, {
			Pos = Vector(player.Position.X, player.Position.Y - 38.5 * player.SpriteScale.Y),
			Vel = Vector(-5, 0),
			Sprite = sprite,
		})
		mod:EnableManualCallback(ModCallbacks.MC_POST_RENDER, mod.doggedItemRender)
	end
end

function mod:DoubleDogRender(player, basedata)
	local dogdata, dogsavedata = GetDoubleDogData(player, basedata)
	
	if dogdata.IncomingDog then
		if not game:IsPaused() and dogdata.IncomingDog.Delay <= 0 then
			local t = math.min(math.max(0, dogdata.IncomingDog.Distance / DOG_ATTACK_DISTANCE), 1.0)
			local speed = 0.05*DOG_ATTACK_SPEED + 0.95*DOG_ATTACK_SPEED * math.sin(math.pi * t)^0.5
			dogdata.IncomingDog.Distance = math.max(dogdata.IncomingDog.Distance + (dogdata.DogIncoming and -speed or speed), 0)
		end
		local renderPos = Isaac.WorldToScreen(player.Position + Vector(dogdata.IncomingDog.Distance, -38.5 * player.SpriteScale.Y))
		local a = 1.0
		if dogdata.IncomingDog.Distance > DOG_ATTACK_MID then
			a = mod:Lerp(1.0, 0.0, (dogdata.IncomingDog.Distance - DOG_ATTACK_MID) / (DOG_ATTACK_DISTANCE - DOG_ATTACK_MID))
		end
		dogdata.IncomingDog.Sprite.Color.A = a
		dogdata.IncomingDog.Sprite:Render(renderPos)
	end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	DoggedItems = {}
	mod:DisableManualCallback(ModCallbacks.MC_POST_RENDER, mod.doggedItemRender)
end)

function mod:doggedItemRender()
	for i=#DoggedItems,1,-1 do
		local doggedItem = DoggedItems[i]
		local sprite = doggedItem.Sprite
		if not game:IsPaused() then
			sprite.Rotation = sprite.Rotation - 10
			doggedItem.Pos = doggedItem.Pos + doggedItem.Vel
			doggedItem.Vel.X = doggedItem.Vel.X * 0.94
			doggedItem.Vel.Y = doggedItem.Vel.Y * 1.04 + 0.05
			if doggedItem.Vel.X > -2 then
				sprite.Color.A = sprite.Color.A * 0.90
			end
		end
		sprite:Render(Isaac.WorldToScreen(doggedItem.Pos))
		if sprite.Color.A < 0.1 then
			table.remove(DoggedItems, i)
			if #DoggedItems <= 0 then
				mod:DisableManualCallback(ModCallbacks.MC_POST_RENDER, mod.doggedItemRender)
			end
		end
	end
end
mod:AddManualCallback(ModCallbacks.MC_POST_RENDER, mod.doggedItemRender)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, dog)
	dog.IsFollower = true

	local dogItemID = DoubleDogDogFamiliarToDoubleDogDogItem(dog.SubType)
	local dogInfo = DOUBLE_DOG_DOG_ITEMS[dogItemID]
	if dogInfo and dogInfo.DogSpritesheet then
		dog:GetSprite():ReplaceSpritesheet(0, "gfx/familiar/dogs/double dog/double dog dogs/" .. dogInfo.DogSpritesheet .. ".png", true)
	end
end, mod.ITEM.FAMILIAR.DOUBLE_DOG_DOG)

local DESTINED_DOG_EFFECTS = {
	DEFAULT = {},
	HAEMO = {
		DogTearHeight = -32,
		DogTearFallingSpeed = -9,
		DogTearFallingAccel = 0.8,
		DogTearFlags = TearFlags.TEAR_BURSTSPLIT,
		DogTearVariant = TearVariant.BALLOON,
		DogAddedTearSize = 0.5,
		DogDamageMult = 2,
	},
	ROTTEN_TOMATO = {
		DogTearFlags = TearFlags.TEAR_BAIT,
		DogTearColor = Color(0.7, 0.14, 0.1, 1, 0.3, 0, 0),
	},
	EYE_OF_BELIAL = {
		DogTearFlags = TearFlags.TEAR_BELIAL | TearFlags.TEAR_PIERCING,
		DogTearVariant = TearVariant.BLOOD,
	},
	TECHNOLOGY = {
		OverrideOne = function(dog, dogTearVel, dogTearDamage)
			local laser = EntityLaser.ShootAngle(LaserVariant.THIN_RED, dog.Position, dogTearVel:GetAngleDegrees(), 3, Vector(0, -20), dog):ToLaser()
			laser.CollisionDamage = dogTearDamage
			return laser
		end,
	},
	TECH_X = {
		OverrideOne = function(dog, dogTearVel, dogTearDamage)
			local laser = EntityLaser.ShootAngle(LaserVariant.THIN_RED, dog.Position, dogTearVel:GetAngleDegrees(), 20, Vector(0, -20), dog):ToLaser()
			laser.Velocity = dogTearVel
			laser.Radius = laser.Radius * 0.75
			laser.SubType = LaserSubType.LASER_SUBTYPE_RING_PROJECTILE
			laser.CollisionDamage = dogTearDamage * 0.5
			return laser
		end,
	},
	MONSTROS_LUNG = {
		OverrideAll = function(dog, dogTearVel, dogTearDamage)
			return mod:FireMonstroBurst(dog, dog.Position, dogTearVel, 14, dogTearDamage, TearVariant.BLOOD)
		end,
	},
	MONSTROS_LUNG_TECH = {
		OverrideAll = function(dog, dogTearVel, dogTearDamage)
			return mod:FireMonstroLaserBurst(dog, dog.Position, dogTearVel, 6, dogTearDamage)
		end,
	},
	BOILED_BABY = {
		OverrideAll = function(dog, dogTearVel, dogTearDamage)
			local tears = mod:FireMonstroBurst(dog, dog.Position, dogTearVel, mod:RandomInt(4, 8), dogTearDamage, TearVariant.BLOOD)
			for _, tear in ipairs(tears) do
				tear.FallingSpeed = tear.FallingSpeed * 2
				tear.FallingAcceleration = tear.FallingAcceleration * 0.75
				tear.Velocity = tear.Velocity:Rotated(mod:RandomFloat(360)) * 0.75
			end
			return tears
		end,
	},
	LIL_LOKI = {
		NumDogTears=4,
		DogTearsInitialAngle=0,
		DogTearsAddAngle=90,
		NoMovementInheritance=true,
	},
	HARLEQUIN_BABY = {
		NumDogTears=2,
		DogTearsInitialAngle=-10,
		DogTearsAddAngle=20,
	},
}

local DESTINED_DOG_BASES = {
	{ DESTINED_DOG_EFFECTS.DEFAULT, 125 },
	{ DESTINED_DOG_EFFECTS.LIL_LOKI, 40 },
	{ DESTINED_DOG_EFFECTS.HARLEQUIN_BABY, 85 },
	{ DESTINED_DOG_EFFECTS.MONSTROS_LUNG, 30 },
	{ DESTINED_DOG_EFFECTS.BOILED_BABY, 50 },
}

local DESTINED_DOG_MODIFIERS = {
	{ DESTINED_DOG_EFFECTS.DEFAULT, 125 },
	{ DESTINED_DOG_EFFECTS.HAEMO, 50 },
	{ DESTINED_DOG_EFFECTS.ROTTEN_TOMATO, 50 },
	{ DESTINED_DOG_EFFECTS.EYE_OF_BELIAL, 50 },
	{ DESTINED_DOG_EFFECTS.TECHNOLOGY, 50 },
	{ DESTINED_DOG_EFFECTS.TECH_X, 50 },
}

local function PostFireDogTear(player, dog, dogMult, dogInfo, dogData, tear)
	local laser = tear:ToLaser()
	if dogInfo.DogTearFlags then
		tear.TearFlags = tear.TearFlags | dogInfo.DogTearFlags
	end
	if dogData.DogTearFlags and (not dogData.DogTearFlagsChance or mod:RandomFloat() <= dogData.DogTearFlagsChance) then
		tear.TearFlags = tear.TearFlags | dogData.DogTearFlags
	end
	local scaleMult = 0.5 + 0.3 * dogMult + (dogData.DogAddedTearSize or dogInfo.DogAddedTearSize or 0)
	if Sewn_API then
		if Sewn_API:IsUltra(dogData) then
			tear.CollisionDamage = tear.CollisionDamage * 1.5
			scaleMult = scaleMult * 1.1
		elseif Sewn_API:IsSuper(dogData) then
			tear.CollisionDamage = tear.CollisionDamage * 1.25
			scaleMult = scaleMult * 1.05
		end
	end
	if laser then
		laser:SetScale(laser:GetScale() * scaleMult * dogMult)
	else
		tear.Scale = tear.Scale * scaleMult
	end
	if player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
		tear:AddTearFlags(TearFlags.TEAR_HOMING)
		tear.Color = Color.TearHoming
	elseif dogData.DogTearColor then
		tear.Color = dogData.DogTearColor
	elseif dogInfo.DogTearColor then
		tear.Color = dogInfo.DogTearColor
	end
	if mod:isSuperpositionedPlayer(dog.Player) then
		tear.Color.A = tear.Color.A/4
		tear.CollisionDamage = tear.CollisionDamage/4
	end
	if dogInfo.DogTearInit and not laser then
		dogInfo.DogTearInit(dog, tear, mod:GetEntityData(tear))
	end
	if not laser then
		tear:ResetSpriteScale()
	end
end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, dog)
	local player = dog.Player
	local dogSprite = dog:GetSprite()
	local dogData = mod:GetEntityData(dog)

	local dogItemID = DoubleDogDogFamiliarToDoubleDogDogItem(dog.SubType)
	local dogRNG = player:GetCollectibleRNG(dogItemID)

	local isDogDogDogDog = (dogItemID == mod.ITEM.COLLECTIBLE.DOG_DOG_DOG_DOG)
	local dogInfo = DOUBLE_DOG_DOG_ITEMS[dogItemID] or {}
	local defaultDogInfo = DOUBLE_DOG_DOG_ITEMS[mod.ITEM.COLLECTIBLE.DEFAULT_DOG]

	local isSuperpositioned = mod:isSuperpositionedPlayer(player)
	local isSirenCharmed = mod:isSirenCharmed(dog)

	if not dogData.state then
		dog.FireCooldown = dogInfo.DogFireCooldown or defaultDogInfo.DogFireCooldown
		dogData.state = "Float"
		dogData.stateframe = 0
	else
		dog.FireCooldown = dog.FireCooldown - ((player and player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) and 2) or 1)
		dog.FireCooldown = math.max(0, dog.FireCooldown)
		
		dogData.stateframe = dogData.stateframe + 1
	end

	if isDogDogDogDog and dog.FrameCount >= (dogData.ErrorDogTransformAt or 0) then
		dogSprite:ReplaceSpritesheet(0, GetDogSpriteFromDogFolderForTheDoubleDogErrorRoomDogAkaDogDogDogDog(), true)
		local layer = dogSprite:GetLayer(0)
		layer:SetSize(Vector(0.75, 0.75))
		layer:SetWrapSMode(0)
		layer:SetWrapTMode(0)

		dogData.DogFollowerPriority = mod:RandomInt(0, 11, dogRNG)
		dogData.DogTearHeight = mod:RandomInt(-20, -10, dogRNG)

		local n = dogRNG:RandomFloat()
		dogData.DogDamage = mod:Lerp(1.5, 6.5, n)
		dogData.DogFireCooldown = math.floor(mod:Lerp(8, 30, n))
		dogData.DogAddedTearSize = mod:Lerp(-0.2, 0.4, n)

		dogData.DogTearVariant = TearVariant.BLUE
		if dogRNG:RandomInt(3) == 0 then
			dogData.DogTearVariant = ERROR_DOG_TEAR_VARIANTS[mod:RandomInt(1, #ERROR_DOG_TEAR_VARIANTS, dogRNG)]
		end

		dogData.DogTearFlags = 0
		for i=1,2 do
			if dogRNG:RandomInt(2) == 0 then
				dogData.DogTearFlags = dogData.DogTearFlags | ERROR_DOG_TEAR_FLAGS[mod:RandomInt(1, #ERROR_DOG_TEAR_FLAGS, dogRNG)]
			end
		end
		dogData.DogTearFlagsChance = 0.25

		local minute = 30*60
		dogData.ErrorDogTransformAt = dog.FrameCount + mod:RandomInt(minute, minute*5, dogRNG)
	end

	local playerCanShoot = player.ControlsCooldown == 0 and not player:HasEntityFlags(EntityFlag.FLAG_FEAR)
	local direction = playerCanShoot and player:GetFireDirection() or Direction.NO_DIRECTION
	dogData.lastdirection = (direction ~= Direction.NO_DIRECTION and direction) or dogData.lastdirection or direction

	if playerCanShoot and dog.FireCooldown == 0 and mod.IsPlayerTryingToShoot(player) then
		dogData.stateframe = 0
		dogData.state = "Shoot"
		dog.FireCooldown = dogData.DogFireCooldown or dogInfo.DogFireCooldown or defaultDogInfo.DogFireCooldown

		local baseDogTearVel = mod.GetFamiliarShootingDirection(dog):Resized(10)
		local allowMovementInheritance = true

		local dogMult = dog:GetMultiplier()
		local dogTearDamage = (dogData.DogDamage or dogInfo.DogDamage or defaultDogInfo.DogDamage) * dogMult

		local numDogTears = (dogItemID == mod.ITEM.COLLECTIBLE.DEWEY_DECIMAL_DOG and dogRNG:RandomInt(3) == 0) and 2 or 1
		local dogTearsInitialAngle = 0
		local dogTearsAddAngle = 0
		local dogTearOverrideAll = nil
		local dogTearOverrideOne = nil

		if dogItemID == mod.ITEM.COLLECTIBLE.DWARF_DOG then
			numDogTears = 2
			dogTearsAddAngle = 180
		elseif dogItemID == mod.ITEM.COLLECTIBLE.DEWEY_DECIMAL_DOG and dogRNG:RandomInt(3) == 0 then
			numDogTears = 2
		end

		if isSirenCharmed then
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, dog.Position, baseDogTearVel, dog):ToProjectile()
			numDogTears = 0
			allowMovementInheritance = false
		elseif dogItemID == mod.ITEM.COLLECTIBLE.DESTINED_DOG then
			local base =  StageAPI.WeightedRNG(DESTINED_DOG_BASES, dogRNG)
			local modifier =  StageAPI.WeightedRNG(DESTINED_DOG_MODIFIERS, dogRNG)
			if base == DESTINED_DOG_EFFECTS.MONSTROS_LUNG and modifier == DESTINED_DOG_EFFECTS.TECHNOLOGY then
				base = DESTINED_DOG_EFFECTS.MONSTROS_LUNG_TECH
				modifier = {}
			elseif base.OverrideAll then
				modifier = {}
			end
			for _, attr in ipairs({"DogTearHeight", "DogTearFallingSpeed", "DogTearFallingAccel", "DogTearFlags", "DogTearVariant", "DogAddedTearSize", "DogTearColor"}) do
				dogData[attr] = modifier[attr] or base[attr]
			end
			numDogTears = modifier.NumDogTears or base.NumDogTears or numDogTears
			dogTearsInitialAngle = modifier.DogTearsInitialAngle or base.DogTearsInitialAngle or dogTearsInitialAngle
			dogTearsAddAngle = modifier.DogTearsAddAngle or base.DogTearsAddAngle or dogTearsAddAngle
			dogTearDamage = dogTearDamage * (base.DogDamageMult or 1) * (modifier.DogDamageMult or 1)
			allowMovementInheritance = not base.NoMovementInheritance and not modifier.NoMovementInheritance
			dogTearOverrideAll = base.OverrideAll
			dogTearOverrideOne = modifier.OverrideOne
		end

		if allowMovementInheritance then
			baseDogTearVel = baseDogTearVel + player:GetTearMovementInheritance(baseDogTearVel)
		end

		if Sewn_API then
			if Sewn_API:IsUltra(dogData) then
				dog.FireCooldown = math.ceil(dog.FireCooldown * 0.5)
			elseif Sewn_API:IsSuper(dogData) then
				dog.FireCooldown = math.ceil(dog.FireCooldown * 0.75)
			end
		end

		if dogTearOverrideAll then
			for _, tear in ipairs(dogTearOverrideAll(dog, baseDogTearVel, dogTearDamage)) do
				PostFireDogTear(player, dog, dogMult, dogInfo, dogData, tear)
			end
		else
			for i=1, numDogTears do
				local dogTearPos = dog.Position
				local dogTearVel = baseDogTearVel:Rotated(dogTearsInitialAngle)
				if numDogTears > 1 then
					if dogTearsAddAngle > 0 then
						dogTearVel = dogTearVel:Rotated(dogTearsAddAngle * (i-1))
					else
						local totalDogTearSpacing = (numDogTears-1)*14
						local thisDogTearSpacing = totalDogTearSpacing * (i-1) / (numDogTears-1) - totalDogTearSpacing * 0.5
						dogTearPos = dogTearPos + dogTearVel:Resized(thisDogTearSpacing):Rotated(90)
					end
				end
				if dogTearOverrideOne then
					local tear = dogTearOverrideOne(dog, dogTearVel, dogTearDamage)
					PostFireDogTear(player, dog, dogMult, dogInfo, dogData, tear)
				else
					local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, dogData.DogTearVariant or dogInfo.DogTearVariant or 0, 0, dogTearPos + dogTearVel:Resized(10), dogTearVel, dog):ToTear()
					tear.CollisionDamage = dogTearDamage
					tear.Height = dogData.DogTearHeight or dogInfo.DogTearHeight or defaultDogInfo.DogTearHeight
					tear.FallingSpeed = (dogData.DogTearFallingSpeed or dogInfo.DogTearFallingSpeed or defaultDogInfo.DogTearFallingSpeed) + mod:RandomFloat(0, 0.2, dogRNG)
					tear.FallingAcceleration = dogData.DogTearFallingAccel or dogInfo.DogTearFallingAccel or defaultDogInfo.DogTearFallingAccel or 0
					PostFireDogTear(player, dog, dogMult, dogInfo, dogData, tear)
				end
			end
		end
	end

	local dogAnim = "FloatDown"

	if dogData.state == "Float" then
		if direction == Direction.LEFT then
			dogAnim = "FloatLeft"
		elseif direction == Direction.RIGHT then
			dogAnim = "FloatRight"
		elseif direction == Direction.UP then
			dogAnim = "FloatUp"
		elseif direction == Direction.DOWN then
			dogAnim = "FloatDown"
		end

		if isDogDogDogDog then
			dogSprite:GetLayer(0):SetCropOffset(Vector(8,8))
		end
	elseif dogData.state == "Shoot" then
		if dogData.lastdirection == Direction.LEFT then
			dogAnim = "FloatShootLeft"
		elseif dogData.lastdirection == Direction.RIGHT then
			dogAnim = "FloatShootRight"
		elseif dogData.lastdirection == Direction.UP then
			dogAnim = "FloatShootUp"
		elseif dogData.lastdirection == Direction.DOWN then
			dogAnim = "FloatShootDown"
		end

		if (direction ~= Direction.NO_DIRECTION and dogData.stateframe >= 9) or dogData.stateframe >= 17 then
			dogData.state = "Float"
			dogData.stateframe = 0
		end

		if isDogDogDogDog then
			dogSprite:GetLayer(0):SetCropOffset(Vector(0,0))
		end
	end

	dogSprite:SetAnimation(dogAnim, false)

	if not dogSprite:IsPlaying() then
		dogSprite:Continue()
	end

	dog:FollowParent()
end, mod.ITEM.FAMILIAR.DOUBLE_DOG_DOG)
--[[
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_, tear)
	print("tear.Height = " .. tear.Height)
	print("tear.FallingSpeed = " .. tear.FallingSpeed)
	print("tear.FallingAcceleration = " .. tear.FallingAcceleration)
end)
]]
mod:AddCallback(ModCallbacks.MC_GET_FOLLOWER_PRIORITY, function(_, dog)
	local dogItemID = DoubleDogDogFamiliarToDoubleDogDogItem(dog.SubType)
	if dogItemID == mod.ITEM.COLLECTIBLE.DOG_DOG_DOG_DOG then
		return mod:GetEntityData(dog).DogFollowerPriority or mod:RandomInt(0, 11, dog.Player:GetCollectibleRNG(dogItemID))
	end
end, mod.ITEM.FAMILIAR.DOUBLE_DOG_DOG)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player)
	for dogItemID, dogInfo in pairs(DOUBLE_DOG_DOG_ITEMS) do
		local dogItemConf = itemConfig:GetCollectible(dogItemID)
		local numDogs = mod.GetExpectedFamiliarNum(player, dogItemID)
		if dogItemID == mod.ITEM.COLLECTIBLE.DOG_DOG_DOG_DOG then
			numDogs = numDogs * 5
		end
		local dogFamiliarID = DoubleDogDogItemToDoubleDogDogFamiliar(dogItemID)
		player:CheckFamiliar(mod.ITEM.FAMILIAR.DOUBLE_DOG_DOG, numDogs, player:GetCollectibleRNG(dogItemID), dogItemConf, dogFamiliarID)
	end
end, CacheFlag.CACHE_FAMILIARS)

mod:AddPriorityCallback(ModCallbacks.MC_GET_SHOP_ITEM_PRICE, CallbackPriority.LATE, function(_, pickupVariant, pickupSubType, shopItemID, price)
	if price > 0 then
		for i=0, game:GetNumPlayers()-1 do
			local player = game:GetPlayer(i)
			if player and player:Exists() and player:HasCollectible(mod.ITEM.COLLECTIBLE.DISCOUNT_DOG) then
				return math.ceil(price * 0.75)
			end
		end
	end
end)
