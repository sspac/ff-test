local mod = FiendFolio
mod.RawItemPoolData = {
	InternalData = {},
	ExternalData = {},
}

function mod.AddItemsToCustomPool(pool, itemList)
	for _, item in pairs(itemList) do
		table.insert(mod.RawItemPoolData.ExternalData[pool].Collectibles, item)
	end
end

function mod.AddTrinketsToCustomPool(pool, itemList)
	for _, item in pairs(itemList) do
		table.insert(mod.RawItemPoolData.ExternalData[pool].Trinkets, item)
	end
end

local pools = {
	ERROR = { -- Test Pool
		FilePath = "error_room",
		PoolType = mod.CustomItemPoolType.COLLECTIBLE,
	},

	CONTRABAND = {
		FilePath = "drug_dealer",
		PoolType = mod.CustomItemPoolType.COLLECTIBLE,
		Aliases = {"DRUG_DEALER"},
	},

	BLACKSMITH = {
		FilePath = "blacksmith",
		PoolType = mod.CustomItemPoolType.COLLECTIBLE,
	},

	ZODIAC_BEGGAR = {
		FilePath = "zodiac_beggar",
		PoolType = mod.CustomItemPoolType.COLLECTIBLE,
	},

	DIRE_CHEST = {
		FilePath = "dire_chest",
		PoolType = mod.CustomItemPoolType.COLLECTIBLE,
	},

	DIRE_CHEST_TRINKET = {
		FilePath = "dire_chest_trinket",
		PoolType = mod.CustomItemPoolType.TRINKET,
	},

	GLASS_CHEST_COMMON = {
		FilePath = "glass_chest_common",
		PoolType = mod.CustomItemPoolType.COLLECTIBLE,
	},

	GLASS_CHEST_RARE = {
		FilePath = "glass_chest_rare",
		PoolType = mod.CustomItemPoolType.COLLECTIBLE,
	},

	GLASS_CHEST_TRINKET = {
		FilePath = "glass_chest_trinket",
		PoolType = mod.CustomItemPoolType.TRINKET,
	},

	ROBO_TELLER = {
		FilePath = "robo_teller",
		PoolType = mod.CustomItemPoolType.MIXED,
	},

	PENNY_ROLL = {
		FilePath = "penny_roll",
		PoolType = mod.CustomItemPoolType.TRINKET,
		Aliases = {"PENNY_TRINKETS"},
	},

	MISPRINTED_THREE_OF_DIAMONDS = {
		FilePath = "misprinted_three_of_diamonds",
		PoolType = mod.CustomItemPoolType.TRINKET,
		Aliases = {"MISPRINTED_PENNY_TRINKETS"},
	},

	TORTURE_COOKIE = {
		FilePath = "torture_cookie",
		PoolType = mod.CustomItemPoolType.TRINKET,
		Aliases = {"TORTURE_COOKIE_TRINKETS"},
	},

	SURREAL_SHEOL_EGG = {
		FilePath = "surreal_sheol_egg",
		PoolType = mod.CustomItemPoolType.MIXED,
	},

	ELECTRUM_MYSTERY_GIFT = {
		FilePath = "electrum_mystery_gift",
		PoolType = mod.CustomItemPoolType.COLLECTIBLE,
		Aliases = {"TECHNOLOGY_ITEMS"},
	},

	ENGINE_CHEST = {
		FilePath = "engine_chest",
		PoolType = mod.CustomItemPoolType.COLLECTIBLE,
	},

	DICE_ITEMS = {
		FilePath = "dice_items",
		PoolType = mod.CustomItemPoolType.COLLECTIBLE,
	},
}

for name, data in pairs(pools) do
	local contentsCollectibles, contentsTrinkets = include("ffscripts.constants.itempools.pools." .. data.FilePath)

	if data.PoolType == mod.CustomItemPoolType.TRINKET then
		local tempHold = contentsCollectibles
		contentsCollectibles = contentsTrinkets
		contentsTrinkets = tempHold
	end

	mod.RawItemPoolData.InternalData[name] = {
		Collectibles = contentsCollectibles or {},
		Trinkets = contentsTrinkets or {},
	}

	mod.RawItemPoolData.ExternalData[name] = {
		Collectibles = {},
		Trinkets = {},
	}

	mod.RegisterCustomItemPool(name, data.PoolType, {
		mod.RawItemPoolData.InternalData[name],
		mod.RawItemPoolData.ExternalData[name],
	})

	for _, alias in pairs(data.Aliases or {}) do
		mod.CustomPool[alias] = mod.CustomPool[name]
	end
end

-- Compatibility Wrappers
function mod.AddItemsToErrorRoomPool(itemList)			mod.AddItemsToCustomPool("ERROR", itemList) end
function mod.AddItemsToContrabandPool(itemList)			mod.AddItemsToCustomPool("CONTRABAND", itemList) end
function mod.AddItemsToBlacksmithPool(itemList)			mod.AddItemsToCustomPool("BLACKSMITH", itemList) end
function mod.AddItemsToZodiacBeggarPool(itemList)		mod.AddItemsToCustomPool("ZODIAC_BEGGAR", itemList) end
function mod.AddItemsToDireChestPool(itemList)			mod.AddItemsToCustomPool("DIRE_CHEST", itemList) end
function mod.AddItemsToGlassChestCommonPool(itemList)	mod.AddItemsToCustomPool("GLASS_CHEST_COMMON", itemList) end
function mod.AddItemsToGlassChestRarePool(itemList)		mod.AddItemsToCustomPool("GLASS_CHEST_RARE", itemList) end
function mod.AddItemsToRoboTellerPool(itemList)			mod.AddItemsToCustomPool("ROBO_TELLER", itemList) end
function mod.AddItemsToTechnologyPool(itemList)			mod.AddItemsToCustomPool("ELECTRUM_MYSTERY_GIFT", itemList) end

function mod.AddItemsToDireChestTrinketPool(itemList)	mod.AddTrinketsToCustomPool("DIRE_CHEST_TRINKET", itemList) end
function mod.AddItemsToGlassChestTrinketPool(itemList)	mod.AddTrinketsToCustomPool("GLASS_CHEST_TRINKET", itemList) end
function mod.AddTrinketsToRoboTellerPool(itemList)		mod.AddTrinketsToCustomPool("ROBO_TELLER", itemList) end
function mod.AddItemsToPennyTrinketPool(itemList)		mod.AddTrinketsToCustomPool("PENNY_ROLL", itemList) end
function mod.AddItemsToTortureCookieTrinketPool(itemList)	mod.AddTrinketsToCustomPool("TORTURE_COOKIE", itemList) end

-- Add support for mods that would add to these now non-existant tables directly.
-- 
-- They weren't supposed to be doing this, but it was necessary for `AddItemsToContrabandPool` specifically,
-- as that had a typo that made it not actually add items to the right pool. Because of that, there
-- was a reason for some mods (namely "Battle Fantasy") to not use the old functions.
--
-- Just add support for all of these old tables, just in case.
local legacyCompatItems = {
	["ExternalErrorRoomPoolAdditions"] = "ERROR",
	["ExternalDrugDealerPoolAdditions"] = "CONTRABAND",
	["ExternalBlacksmithPoolAdditions"] = "BLACKSMITH",
	["ExternalZodiacBeggarPoolAdditions"] = "ZODIAC_BEGGAR",
	["ExternalDireChestPoolAdditions"] = "DIRE_CHEST",
	["ExternalGlassChestCommonPoolAdditions"] = "GLASS_CHEST_COMMON",
	["ExternalGlassChestRarePoolAdditions"] = "GLASS_CHEST_RARE",
	["ExternalRoboTellerPoolAdditions"] = "ROBO_TELLER",
	["ExternalTechnologyPoolAdditions"] = "ELECTRUM_MYSTERY_GIFT",
}

local legacyCompatTrinkets = {
	["ExternalDireChestTrinketPoolAdditions"] = "DIRE_CHEST_TRINKET",
	["ExternalGlassChestTrinketPoolAdditions"] = "GLASS_CHEST_TRINKET",
	["ExternalRoboTellerTrinketPoolAdditions"] = "ROBO_TELLER",
	["ExternalPennyTrinketPoolAdditions"] = "PENNY_ROLL",
	["ExternalTortureCookieTrinketPoolAdditions"] = "TORTURE_COOKIE",
}

for tabName, poolName in pairs(legacyCompatItems) do
	FiendFolio[tabName] = setmetatable({}, {
		__newindex = function (_, k, v)
			table.insert(mod.RawItemPoolData.ExternalData[poolName].Collectibles, v)
		end
	})
end

for tabName, poolName in pairs(legacyCompatTrinkets) do
	FiendFolio[tabName] = setmetatable({}, {
		__newindex = function (_, k, v)
			table.insert(mod.RawItemPoolData.ExternalData[poolName].Trinkets, v)
		end
	})
end

--ENCYCLOPEDIA COMPAT (moving this here so i can just use the tables)
if Encyclopedia then
	-- Pools
	local FFItemPoolType = {
		POOL_DIRE_CHEST = Encyclopedia.GetItemPoolIdByName("POOL_DIRE_CHEST"),
		POOL_DEALER = Encyclopedia.GetItemPoolIdByName("POOL_DEALER"),
		POOL_ZODIAC_BEGGAR = Encyclopedia.GetItemPoolIdByName("POOL_ZODIAC_BEGGAR"),
		POOL_PUZZLE_PIECE = Encyclopedia.GetItemPoolIdByName("POOL_PUZZLE_PIECE"),
		POOL_BLACKSMITH = Encyclopedia.GetItemPoolIdByName("POOL_BLACKSMITH"),
		POOL_GLASS_CHEST = Encyclopedia.GetItemPoolIdByName("POOL_GLASS_CHEST"),
		POOL_ROBO_TELLER = Encyclopedia.GetItemPoolIdByName("POOL_ROBO_TELLER"),
	}

	local direSprite = Encyclopedia.RegisterSprite("gfx/ui/ff_encyclo_itempools.anm2", "Idle", 0)
	Encyclopedia.AddItemPoolSprite(FFItemPoolType.POOL_DIRE_CHEST, direSprite)

	local contraSprite = Encyclopedia.RegisterSprite("gfx/ui/ff_encyclo_itempools.anm2", "Idle", 1)
	Encyclopedia.AddItemPoolSprite(FFItemPoolType.POOL_DEALER, contraSprite)

	local zodiacSprite = Encyclopedia.RegisterSprite("gfx/ui/ff_encyclo_itempools.anm2", "Idle", 2)
	Encyclopedia.AddItemPoolSprite(FFItemPoolType.POOL_ZODIAC_BEGGAR, zodiacSprite)

	local puzzleSprite = Encyclopedia.RegisterSprite("gfx/ui/ff_encyclo_itempools.anm2", "Idle", 3)
	Encyclopedia.AddItemPoolSprite(FFItemPoolType.POOL_PUZZLE_PIECE, puzzleSprite)

	local smithSprite = Encyclopedia.RegisterSprite("gfx/ui/ff_encyclo_itempools.anm2", "Idle", 4)
	Encyclopedia.AddItemPoolSprite(FFItemPoolType.POOL_BLACKSMITH, smithSprite)

	local glassSprite = Encyclopedia.RegisterSprite("gfx/ui/ff_encyclo_itempools.anm2", "Idle", 5)
	Encyclopedia.AddItemPoolSprite(FFItemPoolType.POOL_GLASS_CHEST, glassSprite)

	local roboSprite = Encyclopedia.RegisterSprite("gfx/ui/ff_encyclo_itempools.anm2", "Idle", 6)
	Encyclopedia.AddItemPoolSprite(FFItemPoolType.POOL_ROBO_TELLER, roboSprite)

	for i, item in ipairs(mod.RawItemPoolData.InternalData.DIRE_CHEST.Collectibles) do
		local entry = Encyclopedia.GetItem(item) or {}
		entry.Pools = entry.Pools or {}
		table.insert(entry.Pools, FFItemPoolType.POOL_DIRE_CHEST)
	end

	for i, item in ipairs(mod.RawItemPoolData.InternalData.CONTRABAND.Collectibles) do
		local entry = Encyclopedia.GetItem(item) or {}
		entry.Pools = entry.Pools or {}
		table.insert(entry.Pools, FFItemPoolType.POOL_DEALER)
	end

	for i, item in ipairs(mod.RawItemPoolData.InternalData.ZODIAC_BEGGAR.Collectibles) do
		local entry = Encyclopedia.GetItem(item) or {}
		entry.Pools = entry.Pools or {}
		table.insert(entry.Pools, FFItemPoolType.POOL_ZODIAC_BEGGAR)
	end

	local EncycloPuzzle = {
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_BOBS_BRAIN),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_DEAD_CAT),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_TAMMYS_HEAD),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_YO_LISTEN),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_LITTLE_CHAD),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_BLOOD_PUPPY),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_PONY),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_GUPPYS_PAW),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_GOAT_HEAD),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_PUNCHING_BAG),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_DEAD_BIRD),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_SMART_FLY),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_GUARDIAN_ANGEL),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_ANGRY_FLY),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_RAZOR_BLADE),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_YUCK_HEART),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_DEPRESSION),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_NECRONOMICON),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_ABEL),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_PURITY),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_ROSARY),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_BETRAYAL),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_FRIEND_BALL),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_MY_SHADOW),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_ISAACS_HEART),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_BLANKET),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_FRIEND_FINDER),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_BLOOD_OATH),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_FATES_REWARD),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_MYSTERY_EGG),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_FATE),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_BOOK_OF_REVELATIONS),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_INTRUDER),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_SACRIFICIAL_DAGGER),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_SHADE),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_2SPOOKY),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_MOMS_WIG),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_LEPROSY),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_NIGHT_LIGHT),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_MOMS_PERFUME),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_CAMBION_CONCEPTION),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_ASTRAL_PROJECTION),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_BUDDY_IN_A_BOX),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_BLUE_BOX),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_SPIDER_MOD),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_ACT_OF_CONTRITION),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_VOODOO_HEAD),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_BIBLE),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_DARK_BUM),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_PACT),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_FRUITY_PLUM),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_BUMBO),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_BIG_FAN),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_SWORN_PROTECTOR),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_CHAMPION_BELT),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_APPLE),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_MYSTERIOUS_LIQUID),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_BIRDS_EYE),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_RED_STEW),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_SAUSAGE),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_BREAKFAST),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_ALMOND_MILK),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_MOMS_BOTTLE_OF_PILLS),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_SOY_MILK),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_ROTTEN_TOMATO),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_WAIT_WHAT),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_CRACK_JACKS),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_MILK),
		Encyclopedia.GetItem(CollectibleType.COLLECTIBLE_BUTTER_BEAN),
		Encyclopedia.GetItem(mod.ITEM.COLLECTIBLE.BACON_GREASE),
		Encyclopedia.GetItem(mod.ITEM.COLLECTIBLE.PET_ROCK),
	}

	for i, item in ipairs(EncycloPuzzle) do
		EncycloPuzzle[i].Pools = EncycloPuzzle[i].Pools or {}
		table.insert(EncycloPuzzle[i].Pools, FFItemPoolType.POOL_PUZZLE_PIECE)
	end

	for i, item in ipairs(mod.RawItemPoolData.InternalData.BLACKSMITH.Collectibles) do
		local entry = Encyclopedia.GetItem(item) or {}
		entry.Pools = entry.Pools or {}
		table.insert(entry.Pools, FFItemPoolType.POOL_BLACKSMITH)
	end

	for i, item in ipairs(mod.RawItemPoolData.InternalData.GLASS_CHEST_COMMON.Collectibles) do
		local entry = Encyclopedia.GetItem(item) or {}
		entry.Pools = entry.Pools or {}
		table.insert(entry.Pools, FFItemPoolType.POOL_GLASS_CHEST)
	end

	for i, item in ipairs(mod.RawItemPoolData.InternalData.GLASS_CHEST_RARE.Collectibles) do
		local entry = Encyclopedia.GetItem(item) or {}
		entry.Pools = entry.Pools or {}
		table.insert(entry.Pools, FFItemPoolType.POOL_GLASS_CHEST)
	end

	for i, item in ipairs(mod.RawItemPoolData.InternalData.ROBO_TELLER.Collectibles) do
		local entry = Encyclopedia.GetItem(item) or {}
		entry.Pools = entry.Pools or {}
		table.insert(entry.Pools, FFItemPoolType.POOL_ROBO_TELLER)
	end
end
