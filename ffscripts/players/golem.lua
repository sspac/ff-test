local mod = FiendFolio

local game = Game()
local sfx = SFXManager()
local ItemConfig = Isaac.GetItemConfig()
local ItemPool = game:GetItemPool()

local GameJustStarted = false

local grng = RNG()
local nilvector = FiendFolio.nilvector

-- Map of trinket type -> rarity
-- -2 = don't put in pool
-- -1 = extremely rare (1)
-- 0 = common (100)
-- 1 = Rare (50)
-- 2 = Fiendish (25)
-- 3 = self insert (3)
FiendFolio.RockTrinkets = {
    [FiendFolio.ITEM.ROCK.DIRT_CLUMP]           = -1,
    [FiendFolio.ITEM.ROCK.ROLLING_ROCK]         = -1,
    [FiendFolio.ITEM.ROCK.TROLLITE]             = -1,
    [FiendFolio.ITEM.ROCK.POCKET_SAND]          = -2,
	[FiendFolio.ITEM.ROCK.UNOBTAINIUM]          = -2,
	[FiendFolio.ITEM.ROCK.FULL_VESSEL_ROCK]     = -2,
	[FiendFolio.ITEM.ROCK.VESSEL_ROCK]          = -2,
	[FiendFolio.ITEM.ROCK.DOGROCK_ROCK]         = -2,
	[FiendFolio.ITEM.ROCK.DAMAGED_SAND_CASTLE]  = -2,
	[FiendFolio.ITEM.ROCK.BROKEN_SAND_CASTLE]   = -2,
	[FiendFolio.ITEM.ROCK.FOOLS_UNOBTAINIUM]    = -2,
    [FiendFolio.ITEM.ROCK.GAY_GARNET]           = -2,
    [FiendFolio.ITEM.ROCK.MIXED_PEBBLE_1]       = -2,
    [FiendFolio.ITEM.ROCK.MIXED_PEBBLE_2]       = -2,
    [FiendFolio.ITEM.ROCK.MIXED_PEBBLE_3]       = -2,
    [FiendFolio.ITEM.ROCK.MIXED_PEBBLE_4]       = -2,
    [FiendFolio.ITEM.ROCK.MIXED_PEBBLE_5]       = -2,
    [FiendFolio.ITEM.ROCK.MIXED_PEBBLE_6]       = -2,
    [FiendFolio.ITEM.ROCK.ROUGH_ROCK]           =  0,
    [FiendFolio.ITEM.ROCK.BLOODY_ROCK]          =  0,
    [FiendFolio.ITEM.ROCK.SPIKED_ROCK]          =  0,
    [FiendFolio.ITEM.ROCK.SLIPPY_ROCK]          =  0,
    [FiendFolio.ITEM.ROCK.ARCANE_ROCK]          =  0,
    [FiendFolio.ITEM.ROCK.MINERAL_ROCK]         =  0,
    [FiendFolio.ITEM.ROCK.LEAKY_ROCK]           =  0,
    [FiendFolio.ITEM.ROCK.TWIN_TUFFS]           =  0,
    [FiendFolio.ITEM.ROCK.RIBBED_ROCK]          =  0,
	[FiendFolio.ITEM.ROCK.STURDY_ROCK]          =  0,
	[FiendFolio.ITEM.ROCK.BRICK_ROCK]           =  0,
	[FiendFolio.ITEM.ROCK.SAPPHIC_SAPPHIRE]     =  0,
	[FiendFolio.ITEM.ROCK.BLOOD_DIAMOND]        =  0,
	[FiendFolio.ITEM.ROCK.SCENTED_ROCK]         =  0,
	[FiendFolio.ITEM.ROCK.ARCADE_ROCK]          =  0,
	[FiendFolio.ITEM.ROCK.TINTED_HEART]         =  0,
	[FiendFolio.ITEM.ROCK.ROSE_QUARTZ]          =  0,
	[FiendFolio.ITEM.ROCK.SANDSTONE]            =  0,
	[FiendFolio.ITEM.ROCK.FAKE_ROCK]            =  0,
	[FiendFolio.ITEM.ROCK.CITRINE_PULP]         =  0,
	[FiendFolio.ITEM.ROCK.GRIMACE_ROCK1]        =  0, --Grimace
	[FiendFolio.ITEM.ROCK.GRIMACE_ROCK4]        =  0, --Constant
	[FiendFolio.ITEM.ROCK.GRIMACE_ROCK10]       =  0, --Gaping
	[FiendFolio.ITEM.ROCK.FOCUS_CRYSTAL]        =  0,
	[FiendFolio.ITEM.ROCK.MOONSTONE]            =  0,
	[FiendFolio.ITEM.ROCK.LIMESTONE]            =  0,
	[FiendFolio.ITEM.ROCK.CARNAL_CARNELIAN]     =  0,
	[FiendFolio.ITEM.ROCK.REBAR_ROCK]           =  0,
	[FiendFolio.ITEM.ROCK.STALACTITE]           =  0,
	[FiendFolio.ITEM.ROCK.SMOKY_QUARTZ]         =  0,
	[FiendFolio.ITEM.ROCK.TWINKLING_ROCK]       =  0,
	[FiendFolio.ITEM.ROCK.ROCK_CAKE]            =  0,
	[FiendFolio.ITEM.ROCK.CHARCOAL]             =  0,
	[FiendFolio.ITEM.ROCK.KNIFE_PEBBLE]         =  0,
	[FiendFolio.ITEM.ROCK.TEARDROP_PEBBLE]      =  0,
	[FiendFolio.ITEM.ROCK.ARROW_PEBBLE]         =  0,
	[FiendFolio.ITEM.ROCK.CLOVER_PEBBLE]        =  0,
	[FiendFolio.ITEM.ROCK.SHOE_PEBBLE]          =  0,
	[FiendFolio.ITEM.ROCK.FRUITY_PEBBLE]        =  0,
	[FiendFolio.ITEM.ROCK.ACHILLES_ROCK]        =  0,
	[FiendFolio.ITEM.ROCK.SAND_CASTLE]          =  0,
	[FiendFolio.ITEM.ROCK.GUARDED_GARNET]       =  0,
	[FiendFolio.ITEM.ROCK.SHAMROCK]             =  0,
	[FiendFolio.ITEM.ROCK.GAS_POCKET]           =  0,
	[FiendFolio.ITEM.ROCK.SOAP_STONE]           =  0,
	[FiendFolio.ITEM.ROCK.SPIRIT_URN]           =  0,
    [FiendFolio.ITEM.ROCK.RAI_STONE]            =  0,
    [FiendFolio.ITEM.ROCK.HEAVY_METAL]          =  0,
    [FiendFolio.ITEM.ROCK.GROSSULAR]            =  0,
    [FiendFolio.ITEM.ROCK.THROWLOMITE]          =  0,
    [FiendFolio.ITEM.ROCK.HEARTHSTONE]          =  0,
    [FiendFolio.ITEM.ROCK.MAGNETIC_SAND]        =  0,
    [FiendFolio.ITEM.ROCK.SMALLER_ROCK]         =  0,
    [FiendFolio.ITEM.ROCK.ROCK_WORM]            =  0,
    [FiendFolio.ITEM.ROCK.HIDDENITE]            =  0,
    [FiendFolio.ITEM.ROCK.ARACHNITE]            =  0,
    [FiendFolio.ITEM.ROCK.LITHOPEDIAN]          =  0,
    [FiendFolio.ITEM.ROCK.WETSTONE]             =  0,
    [FiendFolio.ITEM.ROCK.CHUNK_OF_GALLIUM]     =  0,
    [FiendFolio.ITEM.ROCK.SHROOMITE]            =  0,
    [FiendFolio.ITEM.ROCK.FULGURITE]            =  0,
    [FiendFolio.ITEM.ROCK.BOOSTER_ROCK]         =  0,
    [FiendFolio.ITEM.ROCK.MALACHITE]            =  0,
    [FiendFolio.ITEM.ROCK.QUICKSILVER]          =  0,
    [FiendFolio.ITEM.ROCK.THORNY_ROCK]          =  1,
    [FiendFolio.ITEM.ROCK.STROMATOLITE]         =  1,
	[FiendFolio.ITEM.ROCK.HAILSTONE]            =  1,
	[FiendFolio.ITEM.ROCK.SAND_DOLLAR]          =  1,
	[FiendFolio.ITEM.ROCK.SALT_LAMP]            =  1,
	[FiendFolio.ITEM.ROCK.MOLTEN_SLAG]          =  1,
	[FiendFolio.ITEM.ROCK.THUNDER_EGG]          =  1,
	[FiendFolio.ITEM.ROCK.BLOODSTONE]           =  1,
	[FiendFolio.ITEM.ROCK.EMETIC_ANTIMONY]      =  1,
	[FiendFolio.ITEM.ROCK.DOUBLE_RUBBLE]        =  1,
	[FiendFolio.ITEM.ROCK.ROCK_FROM_AN_ABYSS]   =  1,
    [FiendFolio.ITEM.ROCK.HECTOR]               =  1,
	[FiendFolio.ITEM.ROCK.HALF_VESSEL_ROCK]     =  1,
	[FiendFolio.ITEM.ROCK.CONSTANT_ROCK_SHOOTER]=  1,
	[FiendFolio.ITEM.ROCK.ROBOT_ROCK]           =  1,
	[FiendFolio.ITEM.ROCK.ROCK_CANDY]           =  1,
	[FiendFolio.ITEM.ROCK.KEYSTONE]             =  1,
	[FiendFolio.ITEM.ROCK.SILVER_TONGUE]        =  1,
	[FiendFolio.ITEM.ROCK.MEAT_SLAB]            =  1,
	[FiendFolio.ITEM.ROCK.SHEEP_ROCK]           =  1,
	[FiendFolio.ITEM.ROCK.REBELLION_ROCK]       =  1,
	[FiendFolio.ITEM.ROCK.BEDROCK]              =  1,
	[FiendFolio.ITEM.ROCK.SHEETROCK]            =  1,
	[FiendFolio.ITEM.ROCK.FETAL_STONE]          =  1,
	[FiendFolio.ITEM.ROCK.GRIMACE_ROCK2]        =  1, --Vomit
	[FiendFolio.ITEM.ROCK.GRIMACE_ROCK3]        =  1, --Wetstone
	[FiendFolio.ITEM.ROCK.GRIMACE_ROCK5]        =  1, --Broken Gaping
	[FiendFolio.ITEM.ROCK.GRIMACE_ROCK7]        =  1, --Cross
	[FiendFolio.ITEM.ROCK.GRIMACE_ROCK11]       =  1, --Triple
	[FiendFolio.ITEM.ROCK.GRIMACE_ROCK12]       =  1, --Sensory
	[FiendFolio.ITEM.ROCK.GRIMACE_ROCK8]        =  1, --Eye
	[FiendFolio.ITEM.ROCK.CAST_GEM]             =  1,
	[FiendFolio.ITEM.ROCK.ELECTRUM]             =  1,
	[FiendFolio.ITEM.ROCK.PURE_QUARTZ]          =  1,
	[FiendFolio.ITEM.ROCK.AMAZONITE]            =  1,
	[FiendFolio.ITEM.ROCK.STAR_SAPPHIRE]        =  1,
	[FiendFolio.ITEM.ROCK.GRAVESTONE]           =  1,
    [FiendFolio.ITEM.ROCK.STEADFAST_STONE]      =  1,
    [FiendFolio.ITEM.ROCK.ORE_PENNY]            =  1,
    [FiendFolio.ITEM.ROCK.SULFUR_CRYSTAL]       =  1,
    [FiendFolio.ITEM.ROCK.POWER_ROCK]           =  1,
    [FiendFolio.ITEM.ROCK.TIGERS_EYE]           =  1,
    [FiendFolio.ITEM.ROCK.NITRO_CRYSTAL]        =  1,
    [FiendFolio.ITEM.ROCK.HOMOEROTIC_RUBY]      =  1,
    [FiendFolio.ITEM.ROCK.JESUS_ROCK]           =  1,
    [FiendFolio.ITEM.ROCK.PAPERWEIGHT]          =  1,
    [FiendFolio.ITEM.ROCK.AZERITE]              =  1,
    [FiendFolio.ITEM.ROCK.PIG_IRON]             =  1,
    [FiendFolio.ITEM.ROCK.ROCKY]                =  1,
    [FiendFolio.ITEM.ROCK.GRAVEL]               =  1,
    [FiendFolio.ITEM.ROCK.FURNACE_ROCK]         =  1,
    [FiendFolio.ITEM.ROCK.ONYX]                 =  1,
    [FiendFolio.ITEM.ROCK.HELLVITE]             =  1,
    [FiendFolio.ITEM.ROCK.FISH_ROCK]            =  1,
    [FiendFolio.ITEM.ROCK.TRIANGULAR_GEM]       =  1,
    [FiendFolio.ITEM.ROCK.NON_EUCLIDEAN_ROCK]   =  1,
    [FiendFolio.ITEM.ROCK.SACRED_SOIL]          =  1,
    [FiendFolio.ITEM.ROCK.MIRROR_SLATE]         =  1,
    [FiendFolio.ITEM.ROCK.HAMMER_HEAD]          =  1,
    [FiendFolio.ITEM.ROCK.URANIUM]              =  1,
    [FiendFolio.ITEM.ROCK.ANCIENT_EFFIGY]       =  1,
    [FiendFolio.ITEM.ROCK.TIME_LOST_DIAMOND]    =  2,
    [FiendFolio.ITEM.ROCK.OBSIDIAN_GRINDSTONE]  =  2,
    [FiendFolio.ITEM.ROCK.GODS_MARBLE]          =  2,
    [FiendFolio.ITEM.ROCK.TWENTY_SIDED_EMERALD] =  2,
    [FiendFolio.ITEM.ROCK.TECHNOLOGICAL_RUBY_2] =  2,
    [FiendFolio.ITEM.ROCK.FIENDISH_AMETHYST]    =  2,
	[FiendFolio.ITEM.ROCK.RAMBLIN_OPAL]         =  2,
	[FiendFolio.ITEM.ROCK.HENGE_ROCK]           =  2,
	[FiendFolio.ITEM.ROCK.DADS_LEGENDARY_GOLDEN_ROCK] =  2,
	[FiendFolio.ITEM.ROCK.GRIMACE_ROCK6]        =  2, --Brimstone
	[FiendFolio.ITEM.ROCK.GRIMACE_ROCK9]        =  2, --Cauldron
	[FiendFolio.ITEM.ROCK.SHARD_OF_GOLGOTHA]    =  2,
    [FiendFolio.ITEM.ROCK.SUN_SHARD]            =  2,
    [FiendFolio.ITEM.ROCK.INSATIABLE_APATITE]   =  2,
    [FiendFolio.ITEM.ROCK.SHARD_OF_GOLEM]       =  2,
    [FiendFolio.ITEM.ROCK.FRIENDLY_RAPID_FIRE_OPAL] =  2,
    [FiendFolio.ITEM.ROCK.ATLAS_BURDEN]         =  2,
    [FiendFolio.ITEM.ROCK.POCKET_ROCKIT]        =  2,
    [FiendFolio.ITEM.ROCK.WORMHOLE_ROCK]        =  2,
    [FiendFolio.ITEM.ROCK.LOST_ARTIFACT]        =  2,
    [FiendFolio.ITEM.ROCK.RIDICULOUS_METAL]     =  2,
    --[FiendFolio.ITEM.ROCK.TOP_ROCK]           =  2,
    [FiendFolio.ITEM.ROCK.ONION_ROCK]           =  2,
    [FiendFolio.ITEM.ROCK.ODDLY_SMOOTH_STONE]   =  2,
    [FiendFolio.ITEM.ROCK.ROCKETTE_DRAGOON]     =  2,
    [FiendFolio.ITEM.ROCK.ETERNAL_CRYSTAL]      =  2,
    [FiendFolio.ITEM.ROCK.MINICHIBISIDIAN]      =  3,

    -- Fossils
    [FiendFolio.ITEM.ROCK.BREAKFAST_FOSSIL]     = -2,
	[FiendFolio.ITEM.ROCK.VINYL_GEODE_B]        = -2,
    [FiendFolio.ITEM.ROCK.SACK_FOSSIL]          =  0,
    [FiendFolio.ITEM.ROCK.COPROLITE_FOSSIL]     =  0,
	[FiendFolio.ITEM.ROCK.FOSSILIZED_FOSSIL]    =  0,
	[FiendFolio.ITEM.ROCK.RUNIC_FOSSIL]         =  0,
	[FiendFolio.ITEM.ROCK.FISH_FOSSIL]          =  0,
	[FiendFolio.ITEM.ROCK.CANNED_FOSSIL]        =  0,
	[FiendFolio.ITEM.ROCK.BALANCED_FOSSIL]      =  0,
	[FiendFolio.ITEM.ROCK.VALUE_FOSSIL]         =  0,
	[FiendFolio.ITEM.ROCK.CORAL_FOSSIL]         =  0,
    [FiendFolio.ITEM.ROCK.LEFT_FOSSIL]          =  0,
    [FiendFolio.ITEM.ROCK.THANK_YOU_FOSSIL]     =  0,
    [FiendFolio.ITEM.ROCK.ELEPHANT_FOSSIL]      =  0,
    [FiendFolio.ITEM.ROCK.GOLDEN_FOSSIL]        =  0,
    [FiendFolio.ITEM.ROCK.FOSSILIZED_COIN]      =  0,
    [FiendFolio.ITEM.TRINKET.FOSSILIZED_EYE]    =  0,
    [FiendFolio.ITEM.ROCK.BEETER_FOSSIL]        =  1,
    [FiendFolio.ITEM.ROCK.FLY_FOSSIL]           =  1,
    [FiendFolio.ITEM.ROCK.GMO_FOSSIL]           =  1,
    [FiendFolio.ITEM.ROCK.SWORD_FOSSIL]         =  1,
    [FiendFolio.ITEM.ROCK.FORTUNE_WORM_FOSSIL]  =  1,
    [FiendFolio.ITEM.ROCK.PRIMORDIAL_FOSSIL]    =  1,
    [FiendFolio.ITEM.ROCK.REROLLIGAN_FOSSIL]    =  1,
	[FiendFolio.ITEM.ROCK.BURIED_FOSSIL]        =  1,
	[FiendFolio.ITEM.ROCK.TRIPPY_FOSSIL]        =  1,
	[FiendFolio.ITEM.ROCK.MAXS_FOSSIL]          =  1,
	[FiendFolio.ITEM.ROCK.BOMB_SACK_FOSSIL]     =  1,
	[FiendFolio.ITEM.ROCK.DEATH_CAP_FOSSIL]     =  1,
	[FiendFolio.ITEM.ROCK.EXPLOSIVE_FOSSIL]     =  1,
	[FiendFolio.ITEM.ROCK.COLOSSAL_FOSSIL]      =  1,
	[FiendFolio.ITEM.ROCK.SKUZZ_FOSSIL]         =  1,
	[FiendFolio.ITEM.ROCK.FOSSILIZED_BLESSING]  =  1,
	[FiendFolio.ITEM.ROCK.PETRIFIED_SOCK]       =  1,
	[FiendFolio.ITEM.ROCK.MOLTEN_FOSSIL]        =  1,
	[FiendFolio.ITEM.ROCK.NECROMANTIC_FOSSIL]   =  1,
	[FiendFolio.ITEM.ROCK.BRAIN_FOSSIL]         =  1,
    [FiendFolio.ITEM.ROCK.REFUND_FOSSIL]        =  2,
    [FiendFolio.ITEM.ROCK.HOLLOW_FOSSIL]        =  2,

    -- Geodes
    [FiendFolio.ITEM.ROCK.CURVED_GEODE]         =  0,
    [FiendFolio.ITEM.ROCK.HAUNTED_GEODE]        =  0,
    [FiendFolio.ITEM.ROCK.HEALTH_GEODE]         =  0,
    [FiendFolio.ITEM.ROCK.LITTLE_GEODE]         =  0,
    [FiendFolio.ITEM.ROCK.QUICK_GEODE]          =  0,
    [FiendFolio.ITEM.ROCK.WEBBY_GEODE]          =  0,
    [FiendFolio.ITEM.ROCK.LOB_GEODE]            =  0,
	[FiendFolio.ITEM.ROCK.WARM_GEODE]           =  0,
	[FiendFolio.ITEM.ROCK.CHAIN_GEODE]          =  0,
	[FiendFolio.ITEM.ROCK.RUSTY_GEODE]          =  0,
	[FiendFolio.ITEM.ROCK.RUBBER_GEODE]         =  0,
    [FiendFolio.ITEM.ROCK.SWALLOWED_GEODE]      =  0,
    [FiendFolio.ITEM.ROCK.VOODOO_GEODE]         =  0,
    [FiendFolio.ITEM.ROCK.UMBILICAL_GEODE]      =  0,
    [FiendFolio.ITEM.ROCK.LIBERTY_GEODE]        =  0,
    [FiendFolio.ITEM.ROCK.LUCKY_GEODE]          =  1,
    [FiendFolio.ITEM.ROCK.PHLEGMY_GEODE]        =  1,
    [FiendFolio.ITEM.ROCK.SODALITE_GEODE]       =  1,
	[FiendFolio.ITEM.ROCK.FRAGMENTED_ONYX_GEODE]=  1,
	[FiendFolio.ITEM.ROCK.TECHNOLOGICAL_GEODE]  =  1,
	[FiendFolio.ITEM.ROCK.CALZONE_GEODE]        =  1,
	[FiendFolio.ITEM.ROCK.TOUGH_GEODE]          =  1,
	[FiendFolio.ITEM.ROCK.TIPSY_GEODE]          =  1,
	[FiendFolio.ITEM.ROCK.VINYL_GEODE_A]        =  1,
    [FiendFolio.ITEM.ROCK.FRACTAL_GEODE]        =  1,
    [FiendFolio.ITEM.ROCK.AAA_GEODE]            =  1,
    [FiendFolio.ITEM.ROCK.NONAGON_GEODE]        =  1,
    [FiendFolio.ITEM.ROCK.PLACEBEODE]           =  2,
    [FiendFolio.ITEM.ROCK.PRISMATIC_GEODE]      =  2,
    [FiendFolio.ITEM.ROCK.GMO_GEODE]            =  2,
    [FiendFolio.ITEM.ROCK.QUANTUM_GEODE]        =  2,
    [FiendFolio.ITEM.ROCK.DEVOURING_GEODE]      =  2,
    [FiendFolio.ITEM.ROCK.THE_STRONGEST_GEODE]  =  2,

    -- Geode Fossil
    [FiendFolio.ITEM.ROCK.GEODE_FOSSIL]         =  2,
}

-- Non rock trinkets to whitelist; these will not be rerolled for other players
FiendFolio.GolemTrinketWhitelist = {
    [TrinketType.TRINKET_PETRIFIED_POOP]        = 1,
    [TrinketType.TRINKET_LUCKY_ROCK]            = 1,
    [TrinketType.TRINKET_SHINY_ROCK]            = 1,
    [FiendFolio.ITEM.TRINKET.MASSIVE_AMETHYST]  = 1,
    [FiendFolio.ITEM.TRINKET.FOOLS_GOLD]        = 1,
    [FiendFolio.ITEM.ROCK.TOP_ROCK]             = 2,
    [FiendFolio.ITEM.TRINKET.SOLEMN_VOW]        = 2,
    [FiendFolio.ITEM.TRINKET.WAVEBREAKER]       = 1,
    [FiendFolio.ITEM.TRINKET.EVIOLITE]          = 1,
    [FiendFolio.ITEM.TRINKET.SISYPHEAN_BOULDER] = 1,
}

-- I didn't really know where to put this so I figured near the top would make it easiest to find
FiendFolio.TwinTuffsTransmutationTable = { -- Assume type is pickup, only work with variant and subtype
    [PickupVariant.PICKUP_HEART] = {
        [HeartSubType.HEART_HALF] = {HeartSubType.HEART_FULL}, -- If only 1 entry, assume variant == template variant
        [HeartSubType.HEART_FULL] = {HeartSubType.HEART_DOUBLEPACK},
        [HeartSubType.HEART_HALF_SOUL] = {HeartSubType.HEART_SOUL},
    },
    [mod.PICKUP.VARIANT.HALF_BLACK_HEART] = { -- And this is why we needed the tabled values
        ["-1"] = {PickupVariant.PICKUP_HEART, HeartSubType.HEART_BLACK} -- Template subtype doesn't matter
    },
    [mod.PICKUP.VARIANT.HALF_IMMORAL_HEART] = { -- And this is why we needed the tabled values
        ["-1"] = {mod.PICKUP.VARIANT.IMMORAL_HEART, 0} -- Template subtype doesn't matter
    },
    [PickupVariant.PICKUP_COIN] = {
        [CoinSubType.COIN_PENNY] = {CoinSubType.COIN_DOUBLEPACK},
    },
    [PickupVariant.PICKUP_KEY] = {
        [KeySubType.KEY_NORMAL] = {KeySubType.KEY_DOUBLEPACK},
        [mod.PICKUP.KEY.SPICY_PERM] = {mod.PICKUP.KEY.SUPERSPICY_PERM},
    },
    [PickupVariant.PICKUP_BOMB] = {
        [BombSubType.BOMB_NORMAL] = {BombSubType.BOMB_DOUBLEPACK},
    },
}

function FiendFolio.IsRockTrinket(trinketId)
    return not not FiendFolio.GetRockRarity(trinketId)
end

function FiendFolio.GetRockRarity(trinketId)
    return FiendFolio.RockTrinkets[mod:GetRealTrinketId(trinketId)] or FiendFolio.GolemTrinketWhitelist[mod:GetRealTrinketId(trinketId)]
end

function FiendFolio.GetHeldRockCount(player, ignoreTrinkets)
    local held = 0
    for i = 0, 1 do
        local trinket = player:GetTrinket(i)
        if FiendFolio.IsRockTrinket(trinket)
        and not FiendFolio.findKey(ignoreTrinkets, function(trink)
            return trinket == trink
        end) then
            held = held + 1
        end
    end

    return held
end

function FiendFolio.GetMostRecentTrinket(player)
    local newTrinket = player:GetTrinket(1)
    if newTrinket > 0 then
        return newTrinket
    end

    local oldTrinket = player:GetTrinket(0)
    if oldTrinket > 0 then
        return oldTrinket
    end

    return -1
end

function FiendFolio.GetMostRecentRockTrinket(player, doProcHector, ignoreGolden)
    local newTrinket = player:GetTrinket(1)
    local hectordead

    if doProcHector then
        hectordead = (mod:RandomInt(1,5) == 1)
    end

    if newTrinket > 0 and FiendFolio.IsRockTrinket(newTrinket) and not (ignoreGolden and mod:IsGoldTrinket(newTrinket)) then
        if newTrinket == FiendFolio.ITEM.ROCK.HECTOR and doProcHector then
            if hectordead then
                sfx:Play(SoundEffect.SOUND_THUMBS_DOWN)
                return newTrinket, 1
            else
                mod:DropHector(player)
                sfx:Play(SoundEffect.SOUND_THUMBSUP)
            end
        else
            return newTrinket, 1, mod:IsPlayerTrinketBlasphemous(player,1)
        end
    end

    local oldTrinket = player:GetTrinket(0)
    if oldTrinket > 0 and FiendFolio.IsRockTrinket(oldTrinket) and not (ignoreGolden and mod:IsGoldTrinket(oldTrinket)) then
        if oldTrinket == FiendFolio.ITEM.ROCK.HECTOR and doProcHector then
            if hectordead then
                sfx:Play(SoundEffect.SOUND_THUMBS_DOWN)
                return oldTrinket, 0
            else
                mod:DropHector(player)
                sfx:Play(SoundEffect.SOUND_THUMBSUP)
            end
        else
            return oldTrinket, 0, mod:IsPlayerTrinketBlasphemous(player,0)
        end
    end

    return -1, -1, false
end

function FiendFolio.IsFossil(trinketId)
    trinketId = mod:GetRealTrinketId(trinketId)

    return not not FiendFolio.FossilBreakEffects[trinketId]
end

function FiendFolio.IsGeode(trinketId)
    if trinketId <= 0 then return false end

    trinketId = mod:GetRealTrinketId(trinketId)

    local config = ItemConfig:GetTrinket(trinketId)
    return string.find(config.Name, " Geode$") or trinketId == FiendFolio.ITEM.ROCK.GEODE_FOSSIL or trinketId == FiendFolio.ITEM.ROCK.PLACEBEODE
end

function FiendFolio.HasTwoGeodes(player)
    local newTrinket = player:GetTrinket(1)
    local oldTrinket = player:GetTrinket(0)

    local newIsGeode = newTrinket > 0 and FiendFolio.IsGeode(newTrinket)
    local oldIsGeode = oldTrinket > 0 and FiendFolio.IsGeode(oldTrinket)

    return (newIsGeode and oldIsGeode) or (newTrinket ~= FiendFolio.ITEM.ROCK.PLACEBEODE and oldTrinket ~= FiendFolio.ITEM.ROCK.PLACEBEODE and player:HasTrinket(FiendFolio.ITEM.ROCK.PLACEBEODE))
end

function FiendFolio.GetGeodeCount(player)
	--Doesn't do anything yet
	--Unsure whether geodes should be like this or not yet
end

function FiendFolio.GetGolemsRockWispsPower(player)
	local numWisps = 0
	local wisps = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.WISP, FiendFolio.ITEM.COLLECTIBLE.GOLEMS_ROCK, true)

	for _, wisp in ipairs(wisps) do
		if not wisp:IsDead() then
			local fplayer = wisp:ToFamiliar().Player
			if fplayer and
			   fplayer.Index == player.Index and
			   fplayer.InitSeed == player.InitSeed
			then
				numWisps = numWisps + 1
			end
		end
	end

	return math.min(8, numWisps) * 0.0625
end

--[[
Trinket Power!
- Held trinkets count for full power, golden trinkets double, mom's box + 1 like usual
- Smelted trinkets count for 1/3rd power, smelted golden trinkets 2/3rds, and mom's box does nothing for smelted trinkets
- Geode bonus is granted even for smelted trinkets so long as you are HOLDING (not smelted) one other geode trinket
- Pak Choi multiplies the total Rock Power
]]
function FiendFolio.GetGolemTrinketPower(player, trinketId)
	local golemsRockWispsPower = 0
    local smeltPercent = 0.66
    local pakChoiMult = 1.09 ^ player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.PAK_CHOI)
    local data = mod:GetEntityData(player)
	if player:HasTrinket(trinketId) then
		golemsRockWispsPower = FiendFolio.GetGolemsRockWispsPower(player)
	end

	local playerType = player:GetPlayerType()
	if playerType ~= FiendFolio.PLAYER.GOLEM and playerType ~= FiendFolio.PLAYER.BOLEM then
        local heldCount = 0
        for i = 0, 1 do
            local trinket = player:GetTrinket(i)
            if trinket == trinketId then
                heldCount = heldCount + 1
            elseif trinket == (trinketId + TrinketType.TRINKET_GOLDEN_FLAG) then
                heldCount = heldCount + 2
            end
        end

        local totalCopies = player:GetTrinketMultiplier(trinketId)
        if totalCopies > 0 and player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) then
            totalCopies = totalCopies - 1
            if heldCount > 0 then
                heldCount = heldCount + 1
            end
        end

        local notHeld = math.max(0, totalCopies - heldCount)

        if trinketId ~= FiendFolio.ITEM.ROCK.HENGE_ROCK and player:HasTrinket(FiendFolio.ITEM.ROCK.HENGE_ROCK) then
			local queuedItem = player.QueuedItem
			local mult = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.HENGE_ROCK)
			if queuedItem.Item ~= nil and queuedItem.Item:IsTrinket() and mod:GetRealTrinketId(queuedItem.Item.ID) == FiendFolio.ITEM.ROCK.HENGE_ROCK then
				mult = mult-1
			end
			heldCount = heldCount + 0.3*mult
		end
        local moltenFossil = 0
		if trinketId ~= FiendFolio.ITEM.ROCK.MOLTEN_FOSSIL and trinketId ~= FiendFolio.ITEM.ROCK.HENGE_ROCK and player:HasTrinket(FiendFolio.ITEM.ROCK.MOLTEN_FOSSIL) then
			local queuedItem = player.QueuedItem
			local mult = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.MOLTEN_FOSSIL)
			if queuedItem.Item ~= nil and queuedItem.Item:IsTrinket() and mod:GetRealTrinketId(queuedItem.Item.ID) == FiendFolio.ITEM.ROCK.MOLTEN_FOSSIL then
				mult = mult-1
			end
			moltenFossil = 0.15*mult
		end
        if data.OverclockTime and data.OverclockTime > 0 then
            heldCount = heldCount*2
            smeltPercent = 1
        end

        local power = (heldCount + (notHeld * (1 + moltenFossil)) + golemsRockWispsPower) * pakChoiMult
		return power, FiendFolio.HasTwoGeodes(player)
	elseif player:HasTrinket(trinketId) then
        local heldCount = 0
        for i = 0, 1 do
            local trinket = player:GetTrinket(i)
            if trinket == trinketId then
                heldCount = heldCount + 1
            elseif trinket == (trinketId + TrinketType.TRINKET_GOLDEN_FLAG) then
                heldCount = heldCount + 2
            end
        end

        local totalCopies = player:GetTrinketMultiplier(trinketId)
        if totalCopies > 0 and player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) then
            totalCopies = totalCopies - 1
            if heldCount > 0 then
                heldCount = heldCount + 1
            end
        end

        local notHeld = math.max(0, totalCopies - heldCount)

		if heldCount > 0 and playerType == FiendFolio.PLAYER.GOLEM and mod:playerHasBirthcake(player) then
			local cakeCount = 0
			for i = 0, 1 do
				local trinket = player:GetTrinket(i)
				if trinket == BirthcakeRebaked.Birthcake.ID then
					cakeCount = cakeCount + 1
				elseif trinket == (BirthcakeRebaked.Birthcake.ID + TrinketType.TRINKET_GOLDEN_FLAG) then
					cakeCount = cakeCount + 2
				end
			end

			local totalCakeCopies = player:GetTrinketMultiplier(BirthcakeRebaked.Birthcake.ID)
			if totalCakeCopies > 0 and player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) then
				totalCakeCopies = totalCakeCopies - 1
				if cakeCount > 0 then
					cakeCount = cakeCount + 1
				end
			end

			local smeltedCakes = math.max(0, totalCakeCopies - cakeCount)
			heldCount = heldCount + cakeCount + smeltedCakes / 2
		end
		if trinketId ~= FiendFolio.ITEM.ROCK.HENGE_ROCK and player:HasTrinket(FiendFolio.ITEM.ROCK.HENGE_ROCK) then
			local queuedItem = player.QueuedItem
			local mult = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.HENGE_ROCK)
			if queuedItem.Item ~= nil and queuedItem.Item:IsTrinket() and mod:GetRealTrinketId(queuedItem.Item.ID) == FiendFolio.ITEM.ROCK.HENGE_ROCK then
				mult = mult-0.66
			end
			heldCount = heldCount + 0.3*mult
		end
		local moltenFossil = 0
		if trinketId ~= FiendFolio.ITEM.ROCK.MOLTEN_FOSSIL and trinketId ~= FiendFolio.ITEM.ROCK.HENGE_ROCK and player:HasTrinket(FiendFolio.ITEM.ROCK.MOLTEN_FOSSIL) then
			local queuedItem = player.QueuedItem
			local mult = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.MOLTEN_FOSSIL)
			if queuedItem.Item ~= nil and queuedItem.Item:IsTrinket() and mod:GetRealTrinketId(queuedItem.Item.ID) == FiendFolio.ITEM.ROCK.MOLTEN_FOSSIL then
				mult = mult-0.66
			end
			moltenFossil = 0.15*mult
		end
        if data.OverclockTime and data.OverclockTime > 0 then
            heldCount = heldCount*2
            smeltPercent = 1
        end

        local power = (heldCount + (notHeld * (smeltPercent + moltenFossil)) + golemsRockWispsPower) * pakChoiMult
        return power, FiendFolio.HasTwoGeodes(player)
    else
        return 0
    end
end

function FiendFolio.GetGolemTrinketPowerAcrossAllPlayers(trinketId)
    local mult = 0
    for i = 1, game:GetNumPlayers() do
		local p = Isaac.GetPlayer(i - 1)
        mult = mult + FiendFolio.GetGolemTrinketPower(p, trinketId)
    end
    return mult
end

--for getting only the extra
function FiendFolio.GetGolemBonusTrinketPower(player, trinketId)
    local heldCount = 0
    local multiplier = 0
    local data = mod:GetEntityData(player)
	local playerType = player:GetPlayerType()
    if playerType ~= FiendFolio.PLAYER.GOLEM and playerType ~= FiendFolio.PLAYER.BOLEM then
        multiplier = 1
    else
        multiplier = 0.66
    end
	if playerType == FiendFolio.PLAYER.GOLEM and mod:playerHasBirthcake(player) and
	   (player:GetTrinket(0) % TrinketType.TRINKET_GOLDEN_FLAG == trinketId or player:GetTrinket(1) % TrinketType.TRINKET_GOLDEN_FLAG == trinketId)
	then
		local cakeCount = 0
        for i = 0, 1 do
            local trinket = player:GetTrinket(i)
            if trinket == BirthcakeRebaked.Birthcake.ID then
                cakeCount = cakeCount + 1
            elseif trinket == (BirthcakeRebaked.Birthcake.ID + TrinketType.TRINKET_GOLDEN_FLAG) then
                cakeCount = cakeCount + 2
            end
        end

        local totalCakeCopies = player:GetTrinketMultiplier(BirthcakeRebaked.Birthcake.ID)
        if totalCakeCopies > 0 and player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) then
            totalCakeCopies = totalCakeCopies - 1
            if cakeCount > 0 then
                cakeCount = cakeCount + 1
            end
        end

        local smeltedCakes = math.max(0, totalCakeCopies - cakeCount)
		heldCount = heldCount + cakeCount + smeltedCakes / 2
	end
    if player:HasTrinket(FiendFolio.ITEM.ROCK.HENGE_ROCK) then
        local queuedItem = player.QueuedItem
        local mult = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.HENGE_ROCK)
        if queuedItem.Item ~= nil and queuedItem.Item:IsTrinket() and mod:GetRealTrinketId(queuedItem.Item.ID) == FiendFolio.ITEM.ROCK.HENGE_ROCK then
            mult = mult-multiplier
        end
        heldCount = heldCount + 0.3*mult
    end
    if data.OverclockTime and data.OverclockTime > 0 then
        heldCount = math.max(1, heldCount*2)
    end
    return heldCount
end

function FiendFolio.GetRandomGolemTrinket(trinket, skipTrinket)
    local maxIters = 2000
    trinket = trinket or 0
    while not FiendFolio.IsRockTrinket(trinket) or trinket == skipTrinket or
	      (BirthcakeRebaked and trinket == BirthcakeRebaked.Birthcake.ID and not (PlayerManager.AnyoneIsPlayerType(FiendFolio.PLAYER.GOLEM) or PlayerManager.AnyoneIsPlayerType(FiendFolio.PLAYER.BOLEM)))
	do
		mod.gettingGolemTrinket = true
        trinket = ItemPool:GetTrinket()
		mod.gettingGolemTrinket = false
        maxIters = maxIters - 1
        if maxIters == 0 then break end
    end
    return trinket
end

local function AddTableToPool(tab, pool)
    for id, rarity in pairs(tab) do
        local weight
        if rarity == -1 then
            weight = 1
        elseif rarity == 0 then
            weight = 100
        elseif rarity == 1 then
            weight = 50
        elseif rarity == 2 then
            weight = 25
        elseif rarity == 3 then
            weight = 3
        end

        if weight then
            table.insert(pool, { id, weight })
        end
    end
end

-- Starting = rarity -1, all in pool with weight 0.01
-- Common = rarity 0, all in pool with weight 1
-- Rare = rarity 1, half in pool with weight 0.5
function FiendFolio.GenerateGolemTrinketPool()
    local pool = {}
    AddTableToPool(FiendFolio.RockTrinkets, pool)
    AddTableToPool(FiendFolio.GolemTrinketWhitelist, pool)

    for id,rarity in pairs(FiendFolio.RockTrinkets) do
        if rarity == -2 then
            FiendFolio.TrinketPoolBlacklist[id] = true
        end
    end

    --Remove trinkets that aren't unlocked from the pools
    local culledEntries = {}
    for i = 1, #pool do
        local trink = ItemConfig:GetTrinket(pool[i][1])
        if trink ~= nil then
            if FiendFolio.IsTrinketLocked(pool[i][1]) or (not trink:IsAvailable()) then
                table.insert(culledEntries, 1, i)
            end
        else
            print("Please restart the game, your constants and loaded items are mismatched.")
        end
    end
    if #culledEntries > 0 then
        for i = 1, #culledEntries do
            table.remove(pool, culledEntries[i])
        end
    end

    -- shuffle the pool
    for i = 1, #pool * 2 do
        local a = math.random(#pool)
        local b = math.random(#pool)
        pool[a], pool[b] = pool[b], pool[a]
    end

    return pool
end

FiendFolio.GolemTrinketPoolRNG = RNG()
FiendFolio.savedata.GolemPoolData = {
    Trinkets = nil,
    RNGUses = 0,
}

-- Category takes: "Basic", "Fossil", "Geode", or "All"/nil
-- CategoryBreakfast takes: true/false - should breakfast fossil be selected if pool is empty of categorised trinkets (otherwise a random trinket of that category)
function FiendFolio.GetGolemTrinket(rarities, category, categorybreakfast)
    if not FiendFolio.savedata.GolemPoolData.Trinkets then
        -- this allows save data to sync up the rng
        error("Tried to use golem pool too early! Wait for POST_GAME_STARTED")
    end

    if #FiendFolio.savedata.GolemPoolData.Trinkets == 0 then
        FiendFolio.savedata.GolemPoolData.Trinkets = FiendFolio.GenerateGolemTrinketPool()
        return FiendFolio.ITEM.ROCK.BREAKFAST_FOSSIL
    end

    local pool = FiendFolio.savedata.GolemPoolData.Trinkets
    local rarityfilter = function(entry)
        local id = table.unpack(entry)
        local rarity = FiendFolio.GetRockRarity(id)
        return FiendFolio.findKey(rarities, function(item) return item == rarity end)
    end

    if rarities then
        pool = FiendFolio.filter(FiendFolio.savedata.GolemPoolData.Trinkets, rarityfilter)

        if #pool == 0 then
            pool = FiendFolio.savedata.GolemPoolData.Trinkets
            rarities = nil
        end
    end

    if category then -- Don't think it's even possible for this to mess up existing uses of this function, since I ask if the new argument exists first
        local typefilter
        if category == "Basic" then
            typefilter = function(id)
                return not (FiendFolio.IsFossil(id) or FiendFolio.IsGeode(id))
            end
        else
            typefilter = function(entry) return FiendFolio["Is"..category](table.unpack(entry)) end
        end
        typefilter = typefilter or function(id) return true end

        pool = FiendFolio.filter(pool, typefilter)

        if #pool == 0 then
            if categorybreakfast then
                return FiendFolio.ITEM.ROCK.BREAKFAST_FOSSIL
            else
                if rarities then
                    pool = FiendFolio.filter(FiendFolio.GenerateGolemTrinketPool(), function(entry) return rarityfilter(entry) and typefilter(entry) end)

                    if #pool == 0 then
                        pool = FiendFolio.savedata.GolemPoolData.Trinkets
                        rarities = nil
                    end
                else
                    pool = FiendFolio.filter(FiendFolio.GenerateGolemTrinketPool(), typefilter)
                end
            end
        end
    end

    local id, idx = StageAPI.WeightedRNG(pool, FiendFolio.GolemTrinketPoolRNG)
    FiendFolio.savedata.GolemPoolData.RNGUses = (FiendFolio.savedata.GolemPoolData.RNGUses or 0) + 1

    if rarities or category then
        FiendFolio.TryRemoveGolemTrinketFromPool(id)
    else
        ItemPool:RemoveTrinket(idx)
        table.remove(FiendFolio.savedata.GolemPoolData.Trinkets, idx)
    end

	if BirthcakeRebaked and id == BirthcakeRebaked.Birthcake.ID and not (PlayerManager.AnyoneIsPlayerType(FiendFolio.PLAYER.GOLEM) or PlayerManager.AnyoneIsPlayerType(FiendFolio.PLAYER.BOLEM)) then
		id = FiendFolio.GetGolemTrinket(rarities, category, categorybreakfast)
	end
    return id
end

function FiendFolio.TryRemoveGolemTrinketFromPool(trinketId)
    if not FiendFolio.savedata.GolemPoolData.Trinkets then
        error("Tried to use golem pool too early! Wait for POST_GAME_STARTED")
    end

    ItemPool:RemoveTrinket(trinketId)
    for i, entry in pairs(FiendFolio.savedata.GolemPoolData.Trinkets) do
        local id = table.unpack(entry)
        if id == trinketId then
            table.remove(FiendFolio.savedata.GolemPoolData.Trinkets, i)
            return true
        end
    end

    return false
end

local function AnyGolemDo(foo)
    mod.AnyPlayerDo(function(player)
        if player:GetPlayerType() == FiendFolio.PLAYER.GOLEM then
            foo(player)
        end
    end)
end

local function DoubleUpVariable(var)
    return var, var
end

function FiendFolio.GolemExists()
    local numPlayers = game:GetNumPlayers()

    local numGolems = 0
    local hasNonGolem = false
    for i = 0, numPlayers - 1 do
        local player = Isaac.GetPlayer(i)
        if player:GetPlayerType() == FiendFolio.PLAYER.GOLEM or player:GetPlayerType() == FiendFolio.PLAYER.BOLEM then
            numGolems = numGolems + 1
        elseif player.Variant == 0 then
            hasNonGolem = true
        end
    end

    local isAnyGolem = numGolems > 0
    local isMixedGolem = isAnyGolem and hasNonGolem


    return isAnyGolem, isMixedGolem
end

-- pocket sand should never appear naturally
FiendFolio.TrinketPoolBlacklist[FiendFolio.ITEM.ROCK.POCKET_SAND] = true

--Replacements for forced trinket spawns
FiendFolio.RockTrinketReplacements = {
    [TrinketType.TRINKET_COUNTERFEIT_PENNY]     = FiendFolio.ITEM.ROCK.ORE_PENNY,
    [TrinketType.TRINKET_BUTT_PENNY]            = FiendFolio.ITEM.ROCK.ORE_PENNY,
    [TrinketType.TRINKET_BURNT_PENNY]           = FiendFolio.ITEM.ROCK.ORE_PENNY,
    [TrinketType.TRINKET_ROTTEN_PENNY]          = FiendFolio.ITEM.ROCK.ORE_PENNY,
    [TrinketType.TRINKET_SWALLOWED_PENNY]       = FiendFolio.ITEM.ROCK.SWALLOWED_GEODE,
    [TrinketType.TRINKET_LEFT_HAND]             = FiendFolio.ITEM.ROCK.LEFT_FOSSIL,
    [TrinketType.TRINKET_UMBILICAL_CORD]        = FiendFolio.ITEM.ROCK.UMBILICAL_GEODE,
    [TrinketType.TRINKET_AAA_BATTERY]           = FiendFolio.ITEM.ROCK.AAA_GEODE,
    [TrinketType.TRINKET_WATCH_BATTERY]         = FiendFolio.ITEM.ROCK.AAA_GEODE,
    [TrinketType.TRINKET_WIGGLE_WORM]           = FiendFolio.ITEM.ROCK.ROCK_WORM,
    [TrinketType.TRINKET_PULSE_WORM]            = FiendFolio.ITEM.ROCK.ROCK_WORM,
    [TrinketType.TRINKET_RING_WORM]             = FiendFolio.ITEM.ROCK.ROCK_WORM,
    [TrinketType.TRINKET_FLAT_WORM]             = FiendFolio.ITEM.ROCK.ROCK_WORM,
    [TrinketType.TRINKET_HOOK_WORM]             = FiendFolio.ITEM.ROCK.ROCK_WORM,
    [TrinketType.TRINKET_RAINBOW_WORM]          = FiendFolio.ITEM.ROCK.ROCK_WORM,
    [TrinketType.TRINKET_WHIP_WORM]             = FiendFolio.ITEM.ROCK.ROCK_WORM,
    [TrinketType.TRINKET_LAZY_WORM]             = FiendFolio.ITEM.ROCK.ROCK_WORM,
    [TrinketType.TRINKET_TAPE_WORM]             = FiendFolio.ITEM.ROCK.ROCK_WORM,
    [TrinketType.TRINKET_OUROBOROS_WORM]        = FiendFolio.ITEM.ROCK.ROCK_WORM,
    [FiendFolio.ITEM.TRINKET.TRINITY_WORM]      = FiendFolio.ITEM.ROCK.ROCK_WORM,
    [FiendFolio.ITEM.TRINKET.FORTUNE_WORM]      = FiendFolio.ITEM.ROCK.FORTUNE_WORM_FOSSIL,
    [TrinketType.TRINKET_LIBERTY_CAP]           = FiendFolio.ITEM.ROCK.LIBERTY_GEODE,
    [TrinketType.TRINKET_PAPER_CLIP]            = FiendFolio.ITEM.ROCK.PAPERWEIGHT,
    [TrinketType.TRINKET_CHILDS_HEART]          = FiendFolio.ITEM.ROCK.HEALTH_GEODE,
    [TrinketType.TRINKET_MATCH_STICK]           = FiendFolio.ITEM.ROCK.EXPLOSIVE_FOSSIL,
    [TrinketType.TRINKET_FISH_HEAD]             = FiendFolio.ITEM.ROCK.FISH_FOSSIL,
    [TrinketType.TRINKET_FISH_TAIL]             = FiendFolio.ITEM.ROCK.FISH_ROCK,
    [FiendFolio.ITEM.TRINKET.RAINBOW_BEAN]      = FiendFolio.ITEM.ROCK.CANNED_FOSSIL,
}

-- Remove all non golem trinkets when playing only as golem
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
    local trinket = pickup.SubType
    if not FiendFolio.IsRockTrinket(trinket) then
        local isAnyGolem, isMixedGolem = FiendFolio.GolemExists()
        if not isAnyGolem or isMixedGolem then return end

        if game:IsGreedMode() then
            local newRock = FiendFolio.GetGolemTrinket()
            if mod:IsGoldTrinket(trinket) then
                newRock = newRock + TrinketType.TRINKET_GOLDEN_FLAG
            end

            pickup:Morph(EntityType.ENTITY_PICKUP, 350, newRock, true)
        else
            local rand = math.random()
            if mod.RockTrinketReplacements[mod:GetRealTrinketId(trinket)] ~= nil then
                local sub = mod.RockTrinketReplacements[mod:GetRealTrinketId(trinket)]
                if mod:IsGoldTrinket(trinket) then
                    sub = sub+TrinketType.TRINKET_GOLDEN_FLAG
                end
                pickup:Morph(EntityType.ENTITY_PICKUP, 350, sub, true)
            elseif rand < 0.5 and not FiendFolio.anyPlayerHas(FiendFolio.ITEM.ROCK.RUNIC_FOSSIL, true) then
                pickup:Morph(EntityType.ENTITY_PICKUP, 0, 4, true)
            else
                local rune = ItemPool:GetCard(pickup.InitSeed, false, true, true)
                pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, rune, true)
            end
        end
    end
end, PickupVariant.PICKUP_TRINKET)

-- Initialize golem trinket pool rng
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    local level = game:GetLevel()
    local seeds = game:GetSeeds()
    FiendFolio.GolemTrinketPoolRNG:SetSeed(seeds:GetStageSeed(level:GetStage()), 0)
    if FiendFolio.savedata.GolemPoolData then
        FiendFolio.savedata.GolemPoolData.RNGUses = 0
    end
end)

-- Golem init code
function mod:GolemInit(player)
    mod:TryInitGolemSubway()
	mod:TrySpawnGolemSubwayTrapdoor(true)

    local sprite = player:GetSprite()
    sprite:Load("gfx/characters/player_golem.anm2", true)
    sprite:Play(sprite:GetDefaultAnimationName(), true)

    player:AddTrinket(FiendFolio.ITEM.ROCK.ROLLING_ROCK)
    player:AddTrinket(FiendFolio.ITEM.ROCK.DIRT_CLUMP)

    ItemPool:RemoveTrinket(FiendFolio.ITEM.ROCK.ROLLING_ROCK)
    ItemPool:RemoveTrinket(FiendFolio.ITEM.ROCK.DIRT_CLUMP)
end
mod:AddCallback(ModCallbacks.MC_PLAYER_INIT_POST_LEVEL_INIT_STATS, mod.GolemInit, mod.PLAYER.GOLEM)

if StageAPI then
    StageAPI.AddPlayerGraphicsInfo(FiendFolio.PLAYER.GOLEM, {
        Name = "gfx/ui/boss/playername_golem.png",
        Portrait = "gfx/ui/stage/playerportrait_golem_rep.png",
        NoShake = true
    })
    StageAPI.AddPlayerGraphicsInfo(FiendFolio.PLAYER.BOLEM, {
        Name = "gfx/ui/boss/playername_golem.png",
        Portrait = "gfx/ui/stage/playerportrait_taintedgolem.png",
        NoShake = true
    })
end

if ModReloadDetector.GameStarted and not FiendFolio.savedata.GolemPoolData.Trinkets then
    FiendFolio.savedata.GolemPoolData.Trinkets = FiendFolio.GenerateGolemTrinketPool()
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, continued)
    if not continued then
        GameJustStarted = true

        FiendFolio.savedata.GolemPoolData = {
            Trinkets = FiendFolio.GenerateGolemTrinketPool(),
            RNGUses = 0,
        }
    elseif FiendFolio.savedata.GolemPoolData and FiendFolio.savedata.GolemPoolData.RNGUses then
        -- sync pool rng with savedata
        for i = 1, FiendFolio.savedata.GolemPoolData.RNGUses do
            FiendFolio.GolemTrinketPoolRNG:Next()
        end
    end
end)

FiendFolio.RockStatSaveKeys = {
    [FiendFolio.ITEM.ROCK.SWORD_FOSSIL] = 'BrokenSwordFossils'
}

function mod.golemDiminishingDamage(player)
	local data = mod:GetEntityData(player)
	local savedata = data.ffsavedata
	local damage = 0

	if player:HasTrinket(FiendFolio.ITEM.ROCK.MINERAL_ROCK) then
		if data.RubbingRock then
			local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.MINERAL_ROCK)
			damage = damage + trinketPower * 1.5
		end
	end

	if player:HasTrinket(FiendFolio.ITEM.ROCK.SWORD_FOSSIL) then
		local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.SWORD_FOSSIL)
		damage = damage + trinketPower
	end

    if not savedata.RunEffects then return end

	local brokenSwordFossils = savedata.RunEffects.Trinkets.BrokenSwordFossils
	if brokenSwordFossils and brokenSwordFossils > 0 then
		damage = damage + brokenSwordFossils * 0.5
	end

	if player:HasTrinket(FiendFolio.ITEM.ROCK.WARM_GEODE) and data.warmGeodeBonus then
		local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.WARM_GEODE)
        damage = damage + (data.warmGeodeDamage or 2) * trinketPower
	end

	if player:HasTrinket(FiendFolio.ITEM.ROCK.BLOODSTONE) and data.bloodstoneBonus then
		damage = damage + data.bloodstoneBonus
	end

	local rustyBonus = savedata.rustyGeodeBonus
	if player:HasTrinket(FiendFolio.ITEM.ROCK.RUSTY_GEODE) and rustyBonus and rustyBonus > 0 then
		damage = damage + rustyBonus
	end

    if player:HasTrinket(FiendFolio.ITEM.ROCK.HECTOR) then
        local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.HECTOR)
        damage = damage + trinketPower
    end

	local deathCapRooms = savedata.RunEffects.DeathCapFossilCount
	local deathCapBonus = savedata.RunEffects.DeathCapFossilBoost
	if player:HasTrinket(FiendFolio.ITEM.ROCK.DEATH_CAP_FOSSIL) and deathCapRooms and deathCapRooms > 0 then
		damage = damage - math.min(3, deathCapRooms*0.1)
	end
	if deathCapBonus then
		damage = damage + deathCapBonus*0.09
	end

	if player:HasTrinket(FiendFolio.ITEM.ROCK.CARNAL_CARNELIAN) and data.carnalCarnelianDist then
		local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.CARNAL_CARNELIAN)
		damage = damage + 5*mult*data.carnalCarnelianDist
	end

	if player:HasTrinket(FiendFolio.ITEM.ROCK.KNIFE_PEBBLE) then
		local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.KNIFE_PEBBLE)
		damage = damage + 1*mult
	end

	if player:HasTrinket(FiendFolio.ITEM.ROCK.FRUITY_PEBBLE) then
		local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.FRUITY_PEBBLE)
		damage = damage + 0.3*mult
	end

    if player:HasTrinket(FiendFolio.ITEM.ROCK.MIXED_PEBBLE_1) then
		local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.MIXED_PEBBLE_1)
		damage = damage + 0.5*mult
	end

    if player:HasTrinket(FiendFolio.ITEM.ROCK.MIXED_PEBBLE_4) then
		local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.MIXED_PEBBLE_4)
		damage = damage + 0.5*mult
	end

	if player:HasTrinket(FiendFolio.ITEM.ROCK.TIPSY_GEODE) then
		local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.TIPSY_GEODE)
		local extra = 2*mult
		if mod.HasTwoGeodes(player) then
			extra = 3.5*mult
		end
		damage = damage + extra
	end

	if player:HasTrinket(FiendFolio.ITEM.ROCK.VINYL_GEODE_A) then
		local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.VINYL_GEODE_A)
		damage = damage+1*mult
	end
	if player:HasTrinket(FiendFolio.ITEM.ROCK.VINYL_GEODE_B) then
		local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.VINYL_GEODE_B)
		if mod.HasTwoGeodes(player) then
			damage = damage+0.3*mult
		end
	end
    if player:HasTrinket(FiendFolio.ITEM.ROCK.HEAVY_METAL) then
        data.heavyMetalSpeedBoost = data.heavyMetalSpeedBoost or 0
        local mult = 1+data.heavyMetalSpeedBoost*3
        damage = damage+data.heavyMetalSpeedBoost*mult
    end
    if player:HasTrinket(FiendFolio.ITEM.ROCK.MAGNETIC_SAND) then
        damage = damage-0.35
    end

    if player:HasTrinket(FiendFolio.ITEM.ROCK.ROCK_WORM) then
        damage = damage + 0.2 * mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.ROCK_WORM)
    end

    if player:HasTrinket(FiendFolio.ITEM.ROCK.VOODOO_GEODE) then
        local mult, geodeB = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.VOODOO_GEODE)
        local dam = 0
        if data.voodooGeodeCurse then
            dam = 1.5
        end
        dam = dam+0.35*(savedata.voodooGeodeCurseRooms or 0)
        if geodeB then
            dam = dam*1.5
        end
        damage = damage + dam*mult
    end

    if player:HasTrinket(FiendFolio.ITEM.ROCK.HOLLOW_FOSSIL) then
        damage = damage + 1.35 * mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.HOLLOW_FOSSIL)
    end

    if player:HasTrinket(FiendFolio.ITEM.ROCK.AZERITE) then
        local d = savedata.RunEffects.azeriteStats
        if d and d.damage then
            local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.AZERITE)
            damage = damage + 0.16*mult*d.damage
        end
    end

    if player:HasTrinket(FiendFolio.ITEM.ROCK.HELLVITE) then
        local d = savedata.RunEffects.HellviteKills
        damage = damage + 0.01*(d or 0)
    end
    if player:HasTrinket(FiendFolio.ITEM.ROCK.BOOSTER_ROCK) then
        if data.BoosterRockStats and data.BoosterRockStats[1] == "Damage" then
            local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.BOOSTER_ROCK)
            damage = damage + data.BoosterRockStats[2]*mult
        else
            mod:BoosterRockNewRoom(player, data)
        end
    end
    if player:HasTrinket(FiendFolio.ITEM.ROCK.NON_EUCLIDEAN_ROCK) then
        if savedata.RunEffects.NonEuclideanData then
            local boost = savedata.RunEffects.NonEuclideanData.Damage
            if savedata.RunEffects.NonEuclideanData.CurrentRoom then
                boost = boost*savedata.RunEffects.NonEuclideanData.Mult
            end
            damage = damage+boost
        end
    end
    if player:HasTrinket(FiendFolio.ITEM.ROCK.HAMMER_HEAD) and data.HammerHeadDamageBuff then
        damage = damage+data.HammerHeadDamageBuff
    end

	return damage
end

function mod.GolemTearsUp(player, baseData, saveData, baseTears)
    local tears = baseTears
    if player:HasTrinket(FiendFolio.ITEM.ROCK.OBSIDIAN_GRINDSTONE) then
        local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.OBSIDIAN_GRINDSTONE)
        tears = tears + (0.36 * trinketPower)
    end

    if player:HasTrinket(FiendFolio.ITEM.ROCK.MINERAL_ROCK) then
        if baseData.RubbingRock then
            local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.MINERAL_ROCK)
            tears = tears + (0.72 * trinketPower)
        end
    end

    if player:HasTrinket(FiendFolio.ITEM.ROCK.HECTOR) then
        local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.HECTOR)
        tears = tears + (0.27 * trinketPower)
    end

    if player:HasTrinket(FiendFolio.ITEM.ROCK.SWORD_FOSSIL) then
        local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.SWORD_FOSSIL)
        tears = tears + (0.27 * trinketPower)
    end

    if player:HasTrinket(FiendFolio.ITEM.ROCK.CONSTANT_ROCK_SHOOTER) then
        local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.CONSTANT_ROCK_SHOOTER)
        tears = tears + (0.8 * trinketPower)
    end

    if player:HasTrinket(FiendFolio.ITEM.ROCK.FOSSILIZED_BLESSING) then
        local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.FOSSILIZED_BLESSING)
        tears = tears + (0.4 * mult)
    end

    if player:HasTrinket(FiendFolio.ITEM.ROCK.TEARDROP_PEBBLE) then
        local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.TEARDROP_PEBBLE)
        tears = tears + (0.4 * mult)
    end

    if player:HasTrinket(FiendFolio.ITEM.ROCK.FRUITY_PEBBLE) then
        local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.FRUITY_PEBBLE)
        tears = tears + (0.15 * mult)
    end

    if player:HasTrinket(FiendFolio.ITEM.ROCK.MIXED_PEBBLE_3) then
        local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.MIXED_PEBBLE_3)
        tears = tears + (0.15 * mult)
    end

    if player:HasTrinket(FiendFolio.ITEM.ROCK.VINYL_GEODE_A) then
        if mod.HasTwoGeodes(player) then
            local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.VINYL_GEODE_A)
            tears = tears + (0.2 * mult)
        end
    end

    if player:HasTrinket(FiendFolio.ITEM.ROCK.VINYL_GEODE_B) then
        local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.VINYL_GEODE_B)
        tears = tears + (0.66 * mult)
    end

    if player:HasTrinket(FiendFolio.ITEM.ROCK.MAGNETIC_SAND) then
        tears = tears + 0.45
    end

    if baseData.QuicksilverRockBonus then
        tears = tears + baseData.QuicksilverRockBonus.Tears
    end

    if saveData then
        if player:HasTrinket(FiendFolio.ITEM.ROCK.KEYSTONE) then
            local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.KEYSTONE)
            tears = tears + ((0.1*(saveData.RunEffects.keystoneCount or 0)) * trinketPower)
        end

        if player:HasTrinket(FiendFolio.ITEM.ROCK.MOONSTONE) then
			if saveData.RunEffects.moonstoneStats then
				--tears = tears + (0.6 * saveData.RunEffects.moonstoneStats.tears)
                tears = tears + (saveData.RunEffects.moonstoneStats.tears * 0.3)
			end
        end

        if saveData.RunEffects.NonEuclideanData and saveData.RunEffects.NonEuclideanData.CurrentRoom then
            tears = tears + saveData.RunEffects.NonEuclideanData.Tears
        end

        local azeriteStats = saveData.RunEffects.azeriteStats
        if azeriteStats and azeriteStats.tears then
            local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.AZERITE)
            tears = tears + (0.1 * mult * azeriteStats.tears)
        end

        local brokenSwordFossils = saveData.RunEffects.Trinkets.BrokenSwordFossils
        if brokenSwordFossils and brokenSwordFossils > 0 then
            tears = tears + (0.135 * brokenSwordFossils)
        end
    end

    return tears
end

function mod.GolemFlatTears(player, baseData, saveData, baseTears)
    local tears = baseTears
    if player:HasTrinket(FiendFolio.ITEM.ROCK.OBSIDIAN_GRINDSTONE) then
        local heldRocks = FiendFolio.GetHeldRockCount(player, {
            FiendFolio.ITEM.ROCK.OBSIDIAN_GRINDSTONE, FiendFolio.ITEM.ROCK.POCKET_SAND
        })
        local mul = heldRocks > 0 and 0.1 or 0.05
        mul = 1 + mul
		tears = tears * mul
    end

    return tears
end

function mod.obsidianGrindStoneDamage(player)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.OBSIDIAN_GRINDSTONE) then
		local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.OBSIDIAN_GRINDSTONE)
		local heldRocks = FiendFolio.GetHeldRockCount(player, {
			FiendFolio.ITEM.ROCK.OBSIDIAN_GRINDSTONE, FiendFolio.ITEM.ROCK.POCKET_SAND
		})
		local mul = heldRocks > 0 and 1 or 0.5
		return 5 * mul * trinketPower
	end
	return 0
end

function mod.curvedGeodeDamage(player)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.CURVED_GEODE) then
		local trinketPower, geodeBonus = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.CURVED_GEODE)
		if geodeBonus then
			trinketPower = trinketPower * 1.5
		end

		return trinketPower
	end
	return 0
end

FiendFolio.GolemRockStats = {
    [CacheFlag.CACHE_FIREDELAY] = {
        -- Remains here because changing the method in which it decreases tears has balancing concerns
        -- MC_EVALUATE_STAT uses the tears stat and there's not really an equivalent way of decreasing to match this behavior
		[FiendFolio.ITEM.ROCK.DEATH_CAP_FOSSIL] = function(player, d)
			local tearCap = (player.MaxFireDelay < 5 and player.MaxFireDelay) or 5
            player.MaxFireDelay = math.max(tearCap, player.MaxFireDelay + 0.4*(d.RunEffects.DeathCapFossilCount or 0))
		end,
    },
    [CacheFlag.CACHE_RANGE] = {
        [FiendFolio.ITEM.ROCK.MINERAL_ROCK] = function(player)
            if mod:GetEntityData(player).RubbingRock then
				local basemulti = player:GetD8RangeModifier()
				if player:HasCollectible(CollectibleType.COLLECTIBLE_NUMBER_ONE) then
					basemulti = basemulti * 0.8
				end
				if player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) or
				   player:HasCollectible(CollectibleType.COLLECTIBLE_HAEMOLACRIA) or
				   player:HasCollectible(CollectibleType.COLLECTIBLE_CRICKETS_BODY)
				then
					basemulti = basemulti * 0.8
				end

                local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.MINERAL_ROCK)
                player.TearRange = player.TearRange + (40 * trinketPower * basemulti)
            end
        end,
        [FiendFolio.ITEM.ROCK.SWORD_FOSSIL] = function(player, savedata)
			local basemulti = player:GetD8RangeModifier()
			if player:HasCollectible(CollectibleType.COLLECTIBLE_NUMBER_ONE) then
				basemulti = basemulti * 0.8
			end
			if player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) or
			   player:HasCollectible(CollectibleType.COLLECTIBLE_HAEMOLACRIA) or
			   player:HasCollectible(CollectibleType.COLLECTIBLE_CRICKETS_BODY)
			then
				basemulti = basemulti * 0.8
			end

            if player:HasTrinket(FiendFolio.ITEM.ROCK.SWORD_FOSSIL) then
                local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.SWORD_FOSSIL)
                player.TearRange = player.TearRange + (30 * trinketPower * basemulti)
            end

            local brokenSwordFossils = savedata.RunEffects.Trinkets.BrokenSwordFossils
            if brokenSwordFossils and brokenSwordFossils > 0 then
                player.TearRange = player.TearRange + (15 * brokenSwordFossils * basemulti)
            end
        end,
        [FiendFolio.ITEM.ROCK.GEODE_FOSSIL] = function(player)
			local basemulti = player:GetD8RangeModifier()
			if player:HasCollectible(CollectibleType.COLLECTIBLE_NUMBER_ONE) then
				basemulti = basemulti * 0.8
			end
			if player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) or
			   player:HasCollectible(CollectibleType.COLLECTIBLE_HAEMOLACRIA) or
			   player:HasCollectible(CollectibleType.COLLECTIBLE_CRICKETS_BODY)
			then
				basemulti = basemulti * 0.8
			end

            local trinketPower, geodeBonus = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.GEODE_FOSSIL)
            if geodeBonus then
                trinketPower = trinketPower * 1.5
            end

            player.TearRange = player.TearRange + (60 * trinketPower * basemulti)
        end,
        [FiendFolio.ITEM.ROCK.LOB_GEODE] = function(player)
			local basemulti = player:GetD8RangeModifier()
			if player:HasCollectible(CollectibleType.COLLECTIBLE_NUMBER_ONE) then
				basemulti = basemulti * 0.8
			end
			if player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) or
			   player:HasCollectible(CollectibleType.COLLECTIBLE_HAEMOLACRIA) or
			   player:HasCollectible(CollectibleType.COLLECTIBLE_CRICKETS_BODY)
			then
				basemulti = basemulti * 0.8
			end

            local trinketPower, geodeBonus = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.LOB_GEODE)
            if geodeBonus then
                trinketPower = trinketPower * 1.5
            end

            player.TearHeight = player.TearHeight - (6 * trinketPower)
            player.TearRange = player.TearRange + (40 * trinketPower * basemulti)
			player.TearFallingSpeed = player.TearFallingSpeed + player.TearHeight * -0.5
			player.TearFallingAcceleration = math.max(player.TearFallingAcceleration, 0.5)
        end,
		[FiendFolio.ITEM.ROCK.DEATH_CAP_FOSSIL] = function(player, d)
			local basemulti = player:GetD8RangeModifier()
			if player:HasCollectible(CollectibleType.COLLECTIBLE_NUMBER_ONE) then
				basemulti = basemulti * 0.8
			end
			if player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) or
			   player:HasCollectible(CollectibleType.COLLECTIBLE_HAEMOLACRIA) or
			   player:HasCollectible(CollectibleType.COLLECTIBLE_CRICKETS_BODY)
			then
				basemulti = basemulti * 0.8
			end

			player.TearRange = player.TearRange - math.min(player.TearRange/2, 5*(d.RunEffects.DeathCapFossilCount or 0) * basemulti)
		end,
		[FiendFolio.ITEM.ROCK.MOONSTONE] = function(player, d)
			if d.RunEffects.moonstoneStats then
				local basemulti = player:GetD8RangeModifier()
				if player:HasCollectible(CollectibleType.COLLECTIBLE_NUMBER_ONE) then
					basemulti = basemulti * 0.8
				end
				if player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) or
				   player:HasCollectible(CollectibleType.COLLECTIBLE_HAEMOLACRIA) or
				   player:HasCollectible(CollectibleType.COLLECTIBLE_CRICKETS_BODY)
				then
					basemulti = basemulti * 0.8
				end

				player.TearRange = player.TearRange + 15*(d.RunEffects.moonstoneStats.range or 0) * basemulti
			end
		end,
		[FiendFolio.ITEM.ROCK.ARROW_PEBBLE] = function(player)
			local basemulti = player:GetD8RangeModifier()
			if player:HasCollectible(CollectibleType.COLLECTIBLE_NUMBER_ONE) then
				basemulti = basemulti * 0.8
			end
			if player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) or
			   player:HasCollectible(CollectibleType.COLLECTIBLE_HAEMOLACRIA) or
			   player:HasCollectible(CollectibleType.COLLECTIBLE_CRICKETS_BODY)
			then
				basemulti = basemulti * 0.8
			end

			local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.ARROW_PEBBLE)
			player.TearRange = player.TearRange + 50*mult * basemulti
		end,
		[FiendFolio.ITEM.ROCK.FRUITY_PEBBLE] = function(player)
			local basemulti = player:GetD8RangeModifier()
			if player:HasCollectible(CollectibleType.COLLECTIBLE_NUMBER_ONE) then
				basemulti = basemulti * 0.8
			end
			if player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) or
			   player:HasCollectible(CollectibleType.COLLECTIBLE_HAEMOLACRIA) or
			   player:HasCollectible(CollectibleType.COLLECTIBLE_CRICKETS_BODY)
			then
				basemulti = basemulti * 0.8
			end

			local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.FRUITY_PEBBLE)
			player.TearRange = player.TearRange + 30*mult * basemulti
		end,
        [FiendFolio.ITEM.ROCK.MIXED_PEBBLE_4] = function(player)
			local basemulti = player:GetD8RangeModifier()
			if player:HasCollectible(CollectibleType.COLLECTIBLE_NUMBER_ONE) then
				basemulti = basemulti * 0.8
			end
			if player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) or
			   player:HasCollectible(CollectibleType.COLLECTIBLE_HAEMOLACRIA) or
			   player:HasCollectible(CollectibleType.COLLECTIBLE_CRICKETS_BODY)
			then
				basemulti = basemulti * 0.8
			end

			local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.MIXED_PEBBLE_4)
			player.TearRange = player.TearRange + 30*mult * basemulti
		end,
        [FiendFolio.ITEM.ROCK.MIXED_PEBBLE_5] = function(player)
			local basemulti = player:GetD8RangeModifier()
			if player:HasCollectible(CollectibleType.COLLECTIBLE_NUMBER_ONE) then
				basemulti = basemulti * 0.8
			end
			if player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) or
			   player:HasCollectible(CollectibleType.COLLECTIBLE_HAEMOLACRIA) or
			   player:HasCollectible(CollectibleType.COLLECTIBLE_CRICKETS_BODY)
			then
				basemulti = basemulti * 0.8
			end

			local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.MIXED_PEBBLE_5)
			player.TearRange = player.TearRange + 30*mult * basemulti
		end,
        [FiendFolio.ITEM.ROCK.MIXED_PEBBLE_6] = function(player)
			local basemulti = player:GetD8RangeModifier()
			if player:HasCollectible(CollectibleType.COLLECTIBLE_NUMBER_ONE) then
				basemulti = basemulti * 0.8
			end
			if player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) or
			   player:HasCollectible(CollectibleType.COLLECTIBLE_HAEMOLACRIA) or
			   player:HasCollectible(CollectibleType.COLLECTIBLE_CRICKETS_BODY)
			then
				basemulti = basemulti * 0.8
			end

			local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.MIXED_PEBBLE_6)
			player.TearRange = player.TearRange + 30*mult * basemulti
		end,
        [FiendFolio.ITEM.ROCK.AZERITE] = function(player, data)
            local d = data.RunEffects.azeriteStats
            if d and d.range then
				local basemulti = player:GetD8RangeModifier()
				if player:HasCollectible(CollectibleType.COLLECTIBLE_NUMBER_ONE) then
					basemulti = basemulti * 0.8
				end
				if player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) or
				   player:HasCollectible(CollectibleType.COLLECTIBLE_HAEMOLACRIA) or
				   player:HasCollectible(CollectibleType.COLLECTIBLE_CRICKETS_BODY)
				then
					basemulti = basemulti * 0.8
				end

                local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.AZERITE)
                player.TearRange = player.TearRange + 16*mult*d.range * basemulti
            end
        end,
    },
    [CacheFlag.CACHE_SHOTSPEED] = {
        [FiendFolio.ITEM.ROCK.MINERAL_ROCK] = function(player)
            if mod:GetEntityData(player).RubbingRock then
                local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.MINERAL_ROCK)
                player.ShotSpeed = player.ShotSpeed + math.min(0.2 * trinketPower, 0.4)
            end
        end,
        [FiendFolio.ITEM.ROCK.SWORD_FOSSIL] = function(player, savedata)
            if player:HasTrinket(FiendFolio.ITEM.ROCK.SWORD_FOSSIL) then
                local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.SWORD_FOSSIL)
                player.ShotSpeed = player.ShotSpeed + math.min(0.2 * trinketPower, 0.4)
            end

            local brokenSwordFossils = savedata.RunEffects.Trinkets.BrokenSwordFossils
            if brokenSwordFossils and brokenSwordFossils > 0 then
                player.ShotSpeed = player.ShotSpeed + 0.1 * brokenSwordFossils
            end
        end,
        [FiendFolio.ITEM.ROCK.FORTUNE_WORM_FOSSIL] = function(player)
            local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.FORTUNE_WORM_FOSSIL)
            player.ShotSpeed = player.ShotSpeed + math.min(0.2 * trinketPower, 0.4)
        end,
		[FiendFolio.ITEM.ROCK.WARM_GEODE] = function(player, _, d)
			if d.warmGeodeBonus then
				local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.WARM_GEODE)
                player.ShotSpeed = player.ShotSpeed + math.min(0.2 * trinketPower, 0.4)
			end
		end,
		[FiendFolio.ITEM.ROCK.DEATH_CAP_FOSSIL] = function(player, d)
			player.ShotSpeed = player.ShotSpeed - math.min(player.ShotSpeed/2, 0.05*(d.RunEffects.DeathCapFossilCount or 0))
		end,
		[FiendFolio.ITEM.ROCK.MOONSTONE] = function(player, d)
			if d.RunEffects.moonstoneStats then
				player.ShotSpeed = player.ShotSpeed + 0.3*(d.RunEffects.moonstoneStats.shotSpeed or 0)
			end
		end,
		[FiendFolio.ITEM.ROCK.ARROW_PEBBLE] = function(player)
			local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.ARROW_PEBBLE)
			player.ShotSpeed = player.ShotSpeed + math.min(0.3*mult, 0.5)
		end,
		[FiendFolio.ITEM.ROCK.FRUITY_PEBBLE] = function(player)
			local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.FRUITY_PEBBLE)
			player.ShotSpeed = player.ShotSpeed + math.min(0.18*mult, 0.5)
		end,
		[FiendFolio.ITEM.ROCK.VINYL_GEODE_A] = function(player)
			local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.VINYL_GEODE_A)
			player.ShotSpeed = player.ShotSpeed + math.min(0.24*mult, 0.5)
		end,
		[FiendFolio.ITEM.ROCK.VINYL_GEODE_B] = function(player)
			local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.VINYL_GEODE_B)
			if mod.HasTwoGeodes(player) then
				player.ShotSpeed = player.ShotSpeed + math.min(0.08*mult, 0.5)
			end
		end,
        [FiendFolio.ITEM.ROCK.AZERITE] = function(player, data)
            local d = data.RunEffects.azeriteStats
            if d and d.shotspeed then
                local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.AZERITE)
                player.ShotSpeed = player.ShotSpeed + math.min(0.15*mult*d.shotspeed, 0.8)
            end
        end,
    },
    [CacheFlag.CACHE_SPEED] = {
        [FiendFolio.ITEM.ROCK.ROLLING_ROCK] = function(player, savedata)
            local data = savedata
            if data.RoomsClearedWithoutDamage and data.RoomsClearedWithoutDamage > 0
            and data.RunEffects.RoomClearCounts.RollingRock then
                local roomsCleared = data.RoomsClearedWithoutDamage - data.RunEffects.RoomClearCounts.RollingRock
                local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.ROLLING_ROCK)
                local cap = 0.15
                if trinketPower >= 2 then
                    cap = 0.3
                end

                player.MoveSpeed = player.MoveSpeed + math.min(roomsCleared * 0.05 * trinketPower, cap)
            end
        end,
        [FiendFolio.ITEM.ROCK.HECTOR] = function(player)
            player.MoveSpeed = player.MoveSpeed - 0.1 * player:GetTrinketMultiplier(FiendFolio.ITEM.ROCK.HECTOR)
        end,
        [FiendFolio.ITEM.ROCK.SLIPPY_ROCK] = function(player)
            local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.SLIPPY_ROCK)
            player.MoveSpeed = player.MoveSpeed + (0.15 * trinketPower)
        end,
        [FiendFolio.ITEM.ROCK.QUICK_GEODE] = function(player)
            local data = mod:GetEntityData(player)

            local trinketPower, geodeBonus = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.QUICK_GEODE)
            if geodeBonus then
                player.MoveSpeed = player.MoveSpeed + (0.10 * trinketPower)
            end

            if not FiendFolio.IsActiveRoom() then
                data.QuickGeodeCleared = true
                local topSpeed = 1.75
                if trinketPower >= 2 then
                    topSpeed = 1.85
                elseif trinketPower < 1 then
                    topSpeed = 1.2
                end

                player.MoveSpeed = math.max(player.MoveSpeed, topSpeed)
            else
                data.QuickGeodeCleared = false
            end
        end,
        [FiendFolio.ITEM.ROCK.MINERAL_ROCK] = function(player)
            if mod:GetEntityData(player).RubbingRock then
                local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.MINERAL_ROCK)
                player.MoveSpeed = player.MoveSpeed + (0.2 * trinketPower)
            end
        end,
		[FiendFolio.ITEM.ROCK.THUNDER_EGG] = function(player)
			player.MoveSpeed = player.MoveSpeed-0.1
		end,
		[FiendFolio.ITEM.ROCK.KEYSTONE] = function(player, d)
			local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.KEYSTONE)
			player.MoveSpeed = player.MoveSpeed + (0.1 * (d.RunEffects.keystoneCount or 0)*trinketPower)
		end,
		[FiendFolio.ITEM.ROCK.DEATH_CAP_FOSSIL] = function(player, d)
			if player.MoveSpeed > 0.5 then
				player.MoveSpeed = math.max(0.5, player.MoveSpeed - (0.04 * (d.RunEffects.DeathCapFossilCount or 0)))
			end
		end,
		[FiendFolio.ITEM.ROCK.CARNAL_CARNELIAN] = function(player, _, d)
			if d.carnalCarnelianDist then
				player.MoveSpeed = player.MoveSpeed + 1*d.carnalCarnelianDist
			end
		end,
		[FiendFolio.ITEM.ROCK.SHOE_PEBBLE] = function(player)
			local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.SHOE_PEBBLE)
			player.MoveSpeed = player.MoveSpeed + 0.3*mult
		end,
		[FiendFolio.ITEM.ROCK.FRUITY_PEBBLE] = function(player)
			local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.FRUITY_PEBBLE)
			player.MoveSpeed = player.MoveSpeed + 0.15*mult
		end,
        [FiendFolio.ITEM.ROCK.MIXED_PEBBLE_1] = function(player)
			local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.MIXED_PEBBLE_1)
			player.MoveSpeed = player.MoveSpeed + 0.15*mult
		end,
        [FiendFolio.ITEM.ROCK.MIXED_PEBBLE_2] = function(player)
			local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.MIXED_PEBBLE_2)
			player.MoveSpeed = player.MoveSpeed + 0.15*mult
		end,
        [FiendFolio.ITEM.ROCK.MIXED_PEBBLE_6] = function(player)
			local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.MIXED_PEBBLE_6)
			player.MoveSpeed = player.MoveSpeed + 0.15*mult
		end,
		[FiendFolio.ITEM.ROCK.VINYL_GEODE_A] = function(player)
			local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.VINYL_GEODE_A)
			if mod.HasTwoGeodes(player) then
				player.MoveSpeed = player.MoveSpeed + 0.07*mult
			end
		end,
		[FiendFolio.ITEM.ROCK.VINYL_GEODE_B] = function(player)
			local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.VINYL_GEODE_B)
			player.MoveSpeed = player.MoveSpeed + 0.2*mult
		end,
        [FiendFolio.ITEM.ROCK.AZERITE] = function(player, data)
            local d = data.RunEffects.azeriteStats
            if d and d.speed then
                local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.AZERITE)
			    player.MoveSpeed = player.MoveSpeed + 0.07*mult*d.speed
            end
        end,
        [FiendFolio.ITEM.ROCK.QUICKSILVER] = function(player, _, d)
            if d.QuicksilverRockBonus then
                player.MoveSpeed = player.MoveSpeed + d.QuicksilverRockBonus.Speed
            end
        end,
    },
    [CacheFlag.CACHE_LUCK] = {
        [FiendFolio.ITEM.ROCK.MINERAL_ROCK] = function(player)
            if mod:GetEntityData(player).RubbingRock then
                local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.MINERAL_ROCK)
                local baseLuck = 0
                if trinketPower >= 1 then
                    baseLuck = 2
                end

                player.Luck = player.Luck + baseLuck + (2 * trinketPower)
            end
        end,
        [FiendFolio.ITEM.ROCK.FORTUNE_WORM_FOSSIL] = function(player)
            local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.FORTUNE_WORM_FOSSIL)
            local baseLuck = 0
            if trinketPower >= 1 then
                baseLuck = 1
            end

            player.Luck = player.Luck + baseLuck + trinketPower
        end,
        [FiendFolio.ITEM.ROCK.LUCKY_GEODE] = function(player)
            local trinketPower, geodeBonus = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.LUCKY_GEODE)
            --[[if geodeBonus then
                trinketPower = trinketPower * 1.5
            end]]

            local baseLuck = 0
            if trinketPower >= 1 then
                baseLuck = (geodeBonus and 2) or 0
            end

            player.Luck = player.Luck + baseLuck + (trinketPower)
        end,
		[FiendFolio.ITEM.ROCK.DEATH_CAP_FOSSIL] = function(player, d)
			player.Luck = player.Luck - math.ceil((d.RunEffects.DeathCapFossilCount or 0)/3)
		end,
		[FiendFolio.ITEM.ROCK.MOONSTONE] = function(player, d)
			if d.RunEffects.moonstoneStats then
				player.Luck = player.Luck + 1*(d.RunEffects.moonstoneStats.luck or 0)
			end
		end,
		[FiendFolio.ITEM.ROCK.CLOVER_PEBBLE] = function(player)
			local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.CLOVER_PEBBLE)
			player.Luck = player.Luck + (mult*2)
		end,
		[FiendFolio.ITEM.ROCK.FRUITY_PEBBLE] = function(player)
			local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.FRUITY_PEBBLE)
			player.Luck = player.Luck + math.max(1, mult)
		end,
        [FiendFolio.ITEM.ROCK.MIXED_PEBBLE_2] = function(player)
			local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.MIXED_PEBBLE_2)
			player.Luck = player.Luck + math.max(1, mult)
		end,
        [FiendFolio.ITEM.ROCK.MIXED_PEBBLE_3] = function(player)
			local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.MIXED_PEBBLE_3)
			player.Luck = player.Luck + math.max(1, mult)
		end,
        [FiendFolio.ITEM.ROCK.MIXED_PEBBLE_5] = function(player)
			local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.MIXED_PEBBLE_5)
			player.Luck = player.Luck + math.max(1, mult)
		end,
		[FiendFolio.ITEM.ROCK.SHAMROCK] = function(player, d)
			player.Luck = player.Luck + 5 - (d.RunEffects.shamrockCount or 0)
		end,
    },
	[CacheFlag.CACHE_SIZE] = { -- Note: Size is now calculated based on SpriteScale.X in Rep
		[FiendFolio.ITEM.ROCK.LITTLE_GEODE] = function(player)
			local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.LITTLE_GEODE)
			local amount = (FiendFolio.HasTwoGeodes(player) and 2) or 1

			local currSize = math.min(10, player.SpriteScale.X * 160 / 15)
			local newSize = math.max(0, currSize - amount * trinketPower)

			local newSpriteScale = newSize * 0.09375
			if player.SpriteScale.X ~= 0 then
				player.SpriteScale = player.SpriteScale / player.SpriteScale.X * newSpriteScale
			else
				player.SpriteScale = Vector(0, math.min(player.SpriteScale.Y, newSpriteScale))
			end
		end,
	},
}

FiendFolio.FossilBreakEffects = {
    [FiendFolio.ITEM.ROCK.BREAKFAST_FOSSIL] = function(player)
        player:AddMaxHearts(2)
        player:AddHearts(2)
    end,
    [FiendFolio.ITEM.ROCK.SACK_FOSSIL] = function(player, spawner)
        Isaac.Spawn(5, PickupVariant.PICKUP_GRAB_BAG, 0,
                    spawner and spawner.Position or player.Position, RandomVector() * 5, spawner)
    end,
    [FiendFolio.ITEM.ROCK.COPROLITE_FOSSIL] = function(player, spawner)
        player:AddBlueFlies(12, spawner and spawner.Position or player.Position, player)
    end,
    [FiendFolio.ITEM.ROCK.BEETER_FOSSIL] = function(player, spawner)
        local beeter = Isaac.Spawn(FiendFolio.FF.Beeter.ID, FiendFolio.FF.Beeter.Var, 0, spawner.Position, RandomVector() * 7, spawner):ToNPC()
        beeter:AddCharmed(EntityRef(player), -1)
    end,
    [FiendFolio.ITEM.ROCK.FLY_FOSSIL] = function(player)
        player:AddPrettyFly()
    end,
    [FiendFolio.ITEM.ROCK.GMO_FOSSIL] = function(player)
        FiendFolio.QueuePills(player, 3)
    end,
    [FiendFolio.ITEM.ROCK.SWORD_FOSSIL] = function(player)
        local savedata = mod:GetEntityData(player).ffsavedata
        savedata.RunEffects.Trinkets.BrokenSwordFossils = (savedata.RunEffects.Trinkets.BrokenSwordFossils or 0) + 1
        player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
    end,
    [FiendFolio.ITEM.ROCK.FORTUNE_WORM_FOSSIL] = function(player, spawner)
        Isaac.Spawn(5, 10, 3, spawner.Position, RandomVector() * 5, spawner)
        FiendFolio.QueueFortunes(3)
    end,
    [FiendFolio.ITEM.ROCK.PRIMORDIAL_FOSSIL] = function(player, spawner)
        Isaac.Spawn(5, 350, FiendFolio.ITEM.ROCK.DIRT_CLUMP, spawner.Position, RandomVector() * 5, spawner)
        Isaac.Spawn(5, 350, FiendFolio.ITEM.ROCK.ROLLING_ROCK, spawner.Position, RandomVector() * 5, spawner)

        FiendFolio.savedata.GolemPoolData.Trinkets = FiendFolio.filter(FiendFolio.savedata.GolemPoolData.Trinkets, function(entry)
            local id = table.unpack(entry)
            return id ~= FiendFolio.ITEM.ROCK.DIRT_CLUMP and id ~= FiendFolio.ITEM.ROCK.ROLLING_ROCK
        end)
    end,
    [FiendFolio.ITEM.ROCK.GEODE_FOSSIL] = function(player, spawner)
        local n = FiendFolio.IsGeode(player:GetTrinket(0)) and 2 or 1

        for i = 1, n do
            Isaac.Spawn(5, 350, FiendFolio.GetGolemTrinket({0, 1}, "Geode", false), spawner.Position, RandomVector() * 5, spawner)
        end
    end,
    [TrinketType.TRINKET_PETRIFIED_POOP] = function(player, spawner, isGoldRepeat)
        if not isGoldRepeat then
            player:UseCard(Card.CARD_HUMANITY)
        end
    end,
	[FiendFolio.ITEM.ROCK.FOSSILIZED_FOSSIL] = function(player, spawner, isGoldRepeat)
		local trinket = player:GetTrinket(0)
		if trinket ~= FiendFolio.ITEM.ROCK.FOSSILIZED_FOSSIL and FiendFolio.IsFossil(trinket) then
			FiendFolio.FossilBreakEffects[trinket](player, spawner, isGoldRepeat)
		elseif trinket == FiendFolio.ITEM.ROCK.FOSSILIZED_FOSSIL then
			Game():ButterBeanFart(spawner.Position, 0, player, true, false)
		end
	end,
	[FiendFolio.ITEM.ROCK.FISH_FOSSIL] = function(player, spawner)
		local portal = Isaac.Spawn(306, 0, 0, spawner.Position, Vector.Zero, spawner):ToNPC()
        portal:AddCharmed(EntityRef(player), -1)
		portal.HitPoints = portal.HitPoints*2
	end,
	[FiendFolio.ITEM.ROCK.RUNIC_FOSSIL] = function(player, spawner)
		for i=1,4 do
			Isaac.Spawn(5, 300, 55, spawner.Position, RandomVector()*4, spawner)
		end
	end,
	[FiendFolio.ITEM.ROCK.CANNED_FOSSIL] = function(player, spawner)
		game:ButterBeanFart(spawner.Position, 0, spawner, true, false)
		local litter = Isaac.Spawn(FiendFolio.FF.LitterBugCharmed.ID, FiendFolio.FF.LitterBugCharmed.Var, 0, spawner.Position, Vector.Zero, spawner):ToNPC()
        litter:AddCharmed(EntityRef(player), -1)
		litter.HitPoints = 20
	end,
	[FiendFolio.ITEM.ROCK.BALANCED_FOSSIL] = function(player, spawner)
		local pickup = 30
		if player:GetNumKeys() > player:GetNumBombs() then
			pickup = 40
		end
		if pickup == 30 and player:GetNumCoins() < player:GetNumKeys() then
			pickup = 20
		elseif pickup == 40 and player:GetNumCoins() < player:GetNumBombs() then
			pickup = 20
		end

		if player:GetNumKeys() == player:GetNumBombs() and player:GetNumKeys() == player:GetNumCoins() then
			Isaac.Spawn(5, 20, 0, spawner.Position, RandomVector()*4, spawner)
			Isaac.Spawn(5, 30, 0, spawner.Position, RandomVector()*4, spawner)
			Isaac.Spawn(5, 40, 1, spawner.Position, RandomVector()*4, spawner)
		elseif pickup == 40 then
			for i=1,3 do
				Isaac.Spawn(5, 40, 1, spawner.Position, RandomVector()*4, spawner)
			end
		else
			for i=1,3 do
				Isaac.Spawn(5, pickup, 0, spawner.Position, RandomVector()*4, spawner)
			end
		end
	end,
	[FiendFolio.ITEM.ROCK.BURIED_FOSSIL] = function(player, spawner)
		local fossil = Isaac.Spawn(5, 350, mod.GetGolemTrinket(nil, "Fossil", true), spawner.Position, RandomVector()*4, spawner):ToPickup()
		mod:GetEntityData(fossil).playFossilSound = true
	end,
	[FiendFolio.ITEM.ROCK.TRIPPY_FOSSIL] = function(player, spawner)
		player.SpriteScale = player.SpriteScale*0.9
		for i=1,20 do
			local ember = Isaac.Spawn(1000,66,0, player.Position, RandomVector()*math.random(15,55)/10, nil):ToEffect()
			ember.Color = Color(0,0,0,0.5,(150+math.random(100))/255,(150+math.random(100))/255,(150+math.random(100))/255)
			ember.SpriteScale = Vector(1,1)*math.random(20,120)/100
			ember:SetTimeout(5)
			ember:Update()
		end
	end,
	[FiendFolio.ITEM.ROCK.MAXS_FOSSIL] = function(player, spawner)
		local data = mod:GetEntityData(player)
		if not data.ffsavedata.RunEffects.storedDogsHowls then
			data.ffsavedata.RunEffects.storedDogsHowls = 0
		end
		data.ffsavedata.RunEffects.storedDogsHowls = data.ffsavedata.RunEffects.storedDogsHowls+1
	end,
	[FiendFolio.ITEM.ROCK.BOMB_SACK_FOSSIL] = function(player, spawner)
		for i=1,3 do
			Isaac.Spawn(5, 40, 1, spawner.Position, RandomVector()*4, spawner)
		end
	end,
	[FiendFolio.ITEM.ROCK.DEATH_CAP_FOSSIL] = function(player, spawner)
		local runEffects = mod:GetEntityData(player).ffsavedata.RunEffects
		if runEffects.DeathCapFossilCount then
			runEffects.DeathCapFossilBoost = (runEffects.DeathCapFossilBoost or 0)+math.floor(runEffects.DeathCapFossilCount*0.66)
			if runEffects.DeathCapFossilBoost > 30 then
				runEffects.DeathCapFossilBoost = 30
			end
		else
			runEffects.DeathCapFossilBoost = (runEffects.DeathCapFossilBoost or 0)+0.1
		end
		player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
	end,
	[FiendFolio.ITEM.ROCK.EXPLOSIVE_FOSSIL] = function(player, spawner)
		local runEffects = mod:GetEntityData(player).ffsavedata.RunEffects
		if not runEffects.MamaMegaBlasts then
			runEffects.MamaMegaBlasts = 0
		end
		runEffects.MamaMegaBlasts = runEffects.MamaMegaBlasts+3
		sfx:Play(SoundEffect.SOUND_GOLDENBOMB, 1, 0, false, 1)
	end,
	[FiendFolio.ITEM.ROCK.COLOSSAL_FOSSIL] = function(player, spawner, isGoldRepeat)
		for i=1,3 do
			FiendFolio.FossilBreakEffects[mod.GetGolemTrinket(nil, "Fossil", true)](player, spawner, isGoldRepeat)
		end
	end,
	[FiendFolio.ITEM.ROCK.SKUZZ_FOSSIL] = function(player, spawner)
		local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.SKUZZ_FOSSIL)
		for i=1,mod:getRoll(5,7,rng) do
			local flea = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.ATTACK_SKUZZ, 0, spawner.Position, Vector.Zero, player):ToFamiliar()
			flea.Player = player
			flea:Update()
		end
	end,
	[FiendFolio.ITEM.ROCK.FOSSILIZED_BLESSING] = function(player)
		player:AnimateHappy()
		sfx:Play(SoundEffect.SOUND_DIMEPICKUP, 1, 0, false, 2)
        if not game:AchievementUnlocksDisallowed() then
            if not FiendFolio.savedata.playerHadFossilizedBlessing then
                FiendFolio.savedata.playerHadFossilizedBlessing = 1
            else
                FiendFolio.savedata.playerHadFossilizedBlessing = FiendFolio.savedata.playerHadFossilizedBlessing+1
            end
        end
	end,
	[FiendFolio.ITEM.ROCK.PETRIFIED_SOCK] = function(player)
		player:UseCard(Card.CARD_SOUL_LILITH, UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOANIM)
		local splat = Isaac.Spawn(1000, 7, 0, player.Position, Vector.Zero, player):ToEffect()
		local color = Color(0.6, 0.6, 0.6, 1, 0.35, 0.35, 0.35)
		color:SetColorize(0.7,0.7,0.7,0.5)
		splat.Color = color
		splat.SpriteScale = Vector(1.2,1.2)
	end,
	[FiendFolio.ITEM.ROCK.MOLTEN_FOSSIL] = function(player)
		local t0 = player:GetTrinket(0)
        local t1 = player:GetTrinket(1)
        if t1 > 0 then
            player:TryRemoveTrinket(t1)
        end
        if t0 > 0 then
            player:TryRemoveTrinket(t0)
        end
		player:AddTrinket(mod.GetGolemTrinket({0}, nil, true))
		player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, false, false, true, false)
		sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS, 1, 0, false, 1.5)
		for i=1,10 do
			local ember = Isaac.Spawn(1000, 66, 0, player.Position+Vector(math.random(-5,5), math.random(-5,5)), Vector(0,-math.random(1,5)):Rotated(math.random(-40,40)), player)
			ember.DepthOffset = 20
			ember.SpriteOffset = Vector(0,-10)
			ember.SpriteScale = Vector(math.random(10,20)/10, math.random(10,20)/10)
			ember:Update()
		end
		if t0 > 0 then
            player:AddTrinket(t0)
        end
        if t1 > 0 then
            player:AddTrinket(t1)
        end
	end,
	[FiendFolio.ITEM.ROCK.VALUE_FOSSIL] = function(player, spawner)
		sfx:Play(SoundEffect.SOUND_CASH_REGISTER, 1, 0, false, 1)
		local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.VALUE_FOSSIL)
		for i=1,3 do
			Isaac.Spawn(5, 20, 1, spawner.Position, Vector(0,5):Rotated(-30+rng:RandomInt(60)), spawner)
		end
	end,
	[FiendFolio.ITEM.ROCK.CORAL_FOSSIL] = function(player, spawner)
		mod:coralFossilFire(player, spawner.Position, 1, Vector.Zero)
		for i=1,3 do
			local charger = Isaac.Spawn(23, 1, 0, spawner.Position, Vector.Zero, player)
			charger:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			charger:AddCharmed(EntityRef(player), -1)
		end
		player:AddHearts(2)
		SFXManager():Play(SoundEffect.SOUND_VAMP_GULP, 1, 0, false, 1)
		local poof = Isaac.Spawn(1000, 49, 0, player.Position, Vector.Zero, player):ToEffect()
		poof.SpriteOffset = Vector(0,-33*player.SpriteScale.Y)
		poof:FollowParent(player)
		poof.DepthOffset = 50
		poof:Update()
	end,
	[FiendFolio.ITEM.ROCK.NECROMANTIC_FOSSIL] = function(player, spawner)
		local fossils = FiendFolio.savedata.run.brokenFossils
		local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.NECROMANTIC_FOSSIL)
		local id
		if fossils then
			id = fossils[rng:RandomInt(#fossils)+1]
		end
		if id == nil or id == FiendFolio.ITEM.ROCK.NECROMANTIC_FOSSIL then
			id = mod.GetGolemTrinket(nil, "Fossil", true)
		end
		local trinket = Isaac.Spawn(5, 350, id, spawner.Position, Vector(0,5):Rotated(mod:getRoll(-40,40,rng)), player)
		sfx:Play(SoundEffect.SOUND_DEATH_CARD, 1, 0, false, 1.2)
		for i=1,3 do
			local smoke = Isaac.Spawn(1000, 88, 0, spawner.Position, Vector(0,3):Rotated(mod:getRoll(-40,40,rng)), spawner):ToEffect()
			smoke.Parent = smoke
			smoke:SetTimeout(40)
		end
	end,
	[FiendFolio.ITEM.ROCK.BRAIN_FOSSIL] = function(player, spawner)
		local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.BRAIN_FOSSIL)
		local card = Isaac.Spawn(5, 300, Card.CARD_MAGICIAN, spawner.Position, Vector(0,5):Rotated(mod:getRoll(-40,40,rng)), spawner)
	end,
    [FiendFolio.ITEM.ROCK.REFUND_FOSSIL] = function(player, spawner)
        local refundRNG = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.REFUND_FOSSIL)
        for i=1,2 do
            Isaac.Spawn(5, 350, FiendFolio.ITEM.ROCK.POCKET_SAND, spawner.Position, Vector(0,4):Rotated(mod:getRoll(-40,40,refundRNG)), spawner)
        end
    end,
    [FiendFolio.ITEM.ROCK.LEFT_FOSSIL] = function(player, spawner)
        local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.LEFT_FOSSIL)
        Isaac.Spawn(5, 360, 0, spawner.Position, Vector(0,10):Rotated(mod:getRoll(-40,40,rng)), spawner)
    end,
    [FiendFolio.ITEM.ROCK.THANK_YOU_FOSSIL] = function(player, spawner)
        local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.THANK_YOU_FOSSIL)
        Isaac.Spawn(5, 300, 21, spawner.Position, Vector(0,4):Rotated(mod:getRoll(-40,40,rng)), spawner)
    end,
    [FiendFolio.ITEM.ROCK.HOLLOW_FOSSIL] = function(player, spawner)
        mod:AddInnateCollectibleForFloor(player, CollectibleType.COLLECTIBLE_GOAT_HEAD, 1, false)

        sfx:Play(SoundEffect.SOUND_DEVIL_CARD, 1)
        for i = 0, 10 do
            local smoke = Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.FF.FFWhiteSmoke.Var, mod.FF.FFWhiteSmoke.Sub, player.Position, Vector(mod:RandomInt(-1, 1), -1*i)+player.Velocity, player):ToEffect()
            smoke.Color = Color(0, 0, 0, 1, 0, 0, 0)
            mod:GetEntityData(smoke).longonly = true
        end
        --[[local trail = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HAEMO_TRAIL, 0, player.Position, Vector.Zero, player):ToEffect()
        trail.Color = Color(0, 0, 0, 1, 0, 0, 0)
        trail:FollowParent(player)
        trail:Update()]]
    end,
    [FiendFolio.ITEM.ROCK.ELEPHANT_FOSSIL] = function(player, spawner)
        local bony = Isaac.Spawn(EntityType.ENTITY_BONY, 0, 0, spawner.Position+Vector(0,20), Vector.Zero, player):ToNPC()
        bony.SpriteScale = Vector(2, 2)
        bony.Scale = 2
        bony.Size = bony.Size*2
        bony.MaxHitPoints = bony.MaxHitPoints*3
        bony.HitPoints = bony.HitPoints*3
        bony:AddCharmed(EntityRef(player), -1)
        bony:Update()
    end,
    [FiendFolio.ITEM.ROCK.GOLDEN_FOSSIL] = function(player, spawner)
        local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.GOLDEN_FOSSIL)
        Isaac.Spawn(5, 60, 0, spawner.Position, Vector(0,10):Rotated(mod:getRoll(-40,40,rng)), spawner)
    end,
    [FiendFolio.ITEM.ROCK.FOSSILIZED_COIN] = function(player, spawner)
        local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.FOSSILIZED_COIN)
        Isaac.Spawn(5, mod.PICKUP.VARIANT.SHOP_CHEST, 0, spawner.Position, Vector(0,10):Rotated(mod:getRoll(-40,40,rng)), spawner)
    end,
    [FiendFolio.ITEM.TRINKET.FOSSILIZED_EYE] = function(player, spawner)
        local eye = Isaac.Spawn(EntityType.ENTITY_EYE, 1, 0, spawner.Position+Vector(0, 35), Vector.Zero, player):ToNPC()
        eye:AddCharmed(EntityRef(player), -1)
        eye:Update()
    end,
}

FiendFolio.PostRoomCompleteEffects = { -- Procs *after* the room has spawned rewards
    [FiendFolio.ITEM.ROCK.TWIN_TUFFS] = function(player)
        local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.TWIN_TUFFS)
        local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.TWIN_TUFFS)
        local baseChance = 0.15 * trinketPower
        local luckChance = 0.015 * trinketPower
        if rng:RandomFloat() < baseChance + (luckChance * math.max(0, player.Luck)) then
            for _, p in pairs(Isaac.FindByType(5, -1, -1)) do
                if p.Variant ~= 100 and p.FrameCount <= 1 then
                    local off = RandomVector():Resized(10)
                    Isaac.Spawn(5, p.Variant, p.SubType, p.Position + off, nilvector, nil)
                    p.Position = p.Position - off
                end
            end
        end
    end,
}

FiendFolio.PostRockBreakEffects = { -- Runs once for each broken rock, passes broken rock, and player, to arguments. Triggers on rocks, tinted rocks, bomb rocks, alt rocks, and super secret rocks
    [FiendFolio.ITEM.ROCK.STROMATOLITE] = function(grid, player)
        local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.STROMATOLITE)
        local r = rng:RandomFloat()
        local typ = grid:GetType()
        local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.STROMATOLITE)
        local redChance = 0.025 * trinketPower
        local soulChance = 0.25 * trinketPower
        if typ == GridEntityType.GRID_ROCKT or typ == GridEntityType.GRID_ROCK_SS then
            if r < soulChance then
                mod:TrySpawnHeart(
                    {
                        {PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF_SOUL},
                        {PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL}
                    },
                    grid.Position, RandomVector():Resized(5), nil
                )
            end
        elseif r < redChance then
            Isaac.Spawn(5, 10, 2, grid.Position, RandomVector():Resized(5), nil) -- Half
        end
    end,
}

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, flag)
	if player:GetPlayerType() == FiendFolio.PLAYER.GOLEM then
        if flag == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = player.MoveSpeed - 0.15 -- base speed 0.85
        elseif flag == CacheFlag.CACHE_RANGE then
			local basemulti = player:GetD8RangeModifier()
			if player:HasCollectible(CollectibleType.COLLECTIBLE_NUMBER_ONE) then
				basemulti = basemulti * 0.8
			end
			if player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) or
			   player:HasCollectible(CollectibleType.COLLECTIBLE_HAEMOLACRIA) or
			   player:HasCollectible(CollectibleType.COLLECTIBLE_CRICKETS_BODY)
			then
				basemulti = basemulti * 0.8
			end

            --player.TearHeight = player.TearHeight + 1.25 -- base range 22.5
			player.TearRange = player.TearRange - 20 * basemulti
        elseif flag == CacheFlag.CACHE_LUCK then
            if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
                player.Luck = player.Luck + 1
            else
                player.Luck = player.Luck - 1 -- base luck -1
            end
        end
    end

    local stats = FiendFolio.GolemRockStats[flag]
    local basedata = mod:GetEntityData(player)
    local data = basedata.ffsavedata
    if stats and data and data.RunEffects then
        for rock, callback in pairs(stats) do
            if player:HasTrinket(rock) or data.RunEffects.Trinkets[FiendFolio.RockStatSaveKeys[rock]] then
                callback(player, data, basedata)
            end
        end
    end
end)

-- ROCKS -----------------------------------------

function FiendFolio.IsReplaceablePickup(pickup)
    if pickup.Type ~= EntityType.ENTITY_PICKUP then return false end

    return pickup.Variant == PickupVariant.PICKUP_HEART
    or pickup.Variant == PickupVariant.PICKUP_COIN
    or pickup.Variant == PickupVariant.PICKUP_KEY
    or pickup.Variant == PickupVariant.PICKUP_BOMB
    or pickup.Variant == PickupVariant.PICKUP_TAROTCARD
    or pickup.Variant == PickupVariant.PICKUP_PILL
    or pickup.Variant == PickupVariant.PICKUP_LIL_BATTERY
    or pickup.Variant == 0
end

function FiendFolio.BreakRockTrinket(player, trinketId, customColor, customSound, pitch, gibsMin, gibsMax, overridePos, dontRemove)
	if not dontRemove then
		player:TryRemoveTrinket(trinketId)
	end
    sfx:Play(customSound or SoundEffect.SOUND_ROCK_CRUMBLE, 1, 0, false, pitch or 1)
    local particleColor = customColor or Color(1, 1, 1, 1, 0, 0, 0)
    local numGibs = math.random(gibsMin or 4, gibsMax or 7)
    game:SpawnParticles(overridePos or player.Position, EffectVariant.ROCK_PARTICLE, numGibs, 5, particleColor, -5)
end

function FiendFolio.CrushRockTrinket(player, trinketId, crusher)
    local isGold = mod:IsGoldTrinket(trinketId)
    trinketId = mod:GetRealTrinketId(trinketId)

    local fossilEffect = FiendFolio.FossilBreakEffects[trinketId]
    if fossilEffect then
        fossilEffect(player, crusher)
        if isGold then
            fossilEffect(player, crusher, true)
        end
		if player:HasTrinket(FiendFolio.ITEM.ROCK.FOSSILIZED_FOSSIL) or (mod:GetEntityData(player).OverclockTime and mod:GetEntityData(player).OverclockTime > 0) then
			local mult = math.min(1, math.floor(FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.FOSSILIZED_FOSSIL)))
            if mod:GetEntityData(player).OverclockTime and mod:GetEntityData(player).OverclockTime > 0 then
                mult = mult + 1
            end
			for i=1,mult do
				fossilEffect(player, crusher, true)
			end
		end
        if player:HasTrinket(FiendFolio.ITEM.ROCK.REFUND_FOSSIL) then
            local refundRNG = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.REFUND_FOSSIL)
            Isaac.Spawn(5, 350, FiendFolio.ITEM.ROCK.POCKET_SAND, crusher.Position, Vector(0,4):Rotated(mod:getRoll(-40,40,refundRNG)), crusher)
        end
		if not FiendFolio.savedata.run.brokenFossils then
			FiendFolio.savedata.run.brokenFossils = {}
		end
		table.insert(FiendFolio.savedata.run.brokenFossils, trinketId)
    elseif trinketId == FiendFolio.ITEM.ROCK.TOUGH_GEODE or player:HasTrinket(FiendFolio.ITEM.ROCK.TOUGH_GEODE) then
		local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.TOUGH_GEODE)
		local chance = 0
		local t0 = player:GetTrinket(0)
		local geode0 = t0 > 0 and mod.IsGeode(t0)
		local geode1 = mod.IsGeode(trinketId)
		local realGeodes = false
		if (geode0 and geode1) or (t0 ~= FiendFolio.ITEM.ROCK.PLACEBEODE and player:HasTrinket(FiendFolio.ITEM.ROCK.PLACEBEODE)) then
			realGeodes = true
		end
		if trinketId == FiendFolio.ITEM.ROCK.TOUGH_GEODE then
			chance = 30
			if realGeodes == true then
				chance = chance+20
			end
		else
			chance = 20
			if geode1 then
				chance = chance+20
			end
		end
		if rng:RandomInt(100) < chance then
			player:AnimateHappy()
			Isaac.Spawn(5, 350, trinketId, crusher.Position, Vector(0,4):Rotated(rng:RandomInt(20)-10), crusher)
		end
	end
    if player:HasTrinket(FiendFolio.ITEM.ROCK.GRAVEL) then
        local playersavedata = mod:GetEntityData(player).ffsavedata.RunEffects
        local mult = mod.GetGolemTrinketPower(player, mod.ITEM.ROCK.GRAVEL)
        playersavedata.gravelCount = (playersavedata.gravelCount or 0)+0.8*mult
    end

    FiendFolio.BreakRockTrinket(player, trinketId, nil, SoundEffect.SOUND_POT_BREAK, 0.7,
                                nil, nil, crusher and crusher.Position, true)
end

function FiendFolio.GetTwinTuffsReplacement(pickup) -- Takes a pickup entity or a table with Variant & SubType
    if FiendFolio.TwinTuffsTransmutationTable[pickup.Variant] and (FiendFolio.TwinTuffsTransmutationTable[pickup.Variant][pickup.SubType] or FiendFolio.TwinTuffsTransmutationTable[pickup.Variant]["-1"]) then
        local tbl = FiendFolio.TwinTuffsTransmutationTable[pickup.Variant][pickup.SubType] or FiendFolio.TwinTuffsTransmutationTable[pickup.Variant]["-1"]
        local copy = {table.unpack(tbl)}

        if #copy == 1 then table.insert(copy, 1, pickup.Variant) end
        return table.unpack(copy)
    else
        return nil, nil
    end
end

-- reset whether damage was done in this room
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    mod.AnyPlayerDo(function(player)
        local basedata = mod:GetEntityData(player)
        local data = basedata.ffsavedata
        data.HasBeenDamagedInRoom = false
        basedata.RoomsClearedWithoutDamageUpdate = true
    end)
end)

-- Keep track of rooms cleared without damage
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, function()
    local room = game:GetRoom()
    local rtype = room:GetType()
    mod.AnyPlayerDo(function(player)
        local basedata = mod:GetEntityData(player)
        local data = basedata.ffsavedata

        if not data.HasBeenDamagedInRoom then
            data.RoomsClearedWithoutDamage = (data.RoomsClearedWithoutDamage or 0) + 1
            basedata.RoomsClearedWithoutDamageUpdate = true
        end

        if player:HasTrinket(FiendFolio.ITEM.ROCK.GMO_FOSSIL) then
            if rtype == RoomType.ROOM_BOSS
            or rtype == RoomType.ROOM_MINIBOSS
            or rtype == RoomType.ROOM_BOSSRUSH then
				local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.GMO_FOSSIL)
                FiendFolio.QueuePills(player, math.ceil(trinketPower * 2))
            end
        end
		if player:HasTrinket(FiendFolio.ITEM.ROCK.THUNDER_EGG) then
			local mult = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.THUNDER_EGG)
			local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.THUNDER_EGG)
			data.RunEffects.TrueRoomClearCounts.ThunderEgg = (data.RunEffects.TrueRoomClearCounts.ThunderEgg or 0) + mult

			if rng:RandomInt(2+math.floor(math.max(0, 15-data.RunEffects.TrueRoomClearCounts.ThunderEgg))) == 0 then
				sfx:Play(SoundEffect.SOUND_BONE_SNAP, 1, 0, false, 1.7)
				sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 1, 0, false, 1)
				for i=0,4 do
					local gibs = Isaac.Spawn(1000, 35, 0, player.Position+Vector(0,5), RandomVector():Resized(math.random(10,20)/6), player):ToEffect()
					gibs.Color = mod.ColorRockGibs
					gibs:Update()
				end
				local smoke = Isaac.Spawn(1000, EffectVariant.DUST_CLOUD, 0, player.Position+Vector(math.random(-5,5),10), Vector(0,-4.5):Rotated(math.random(-45,45)), player):ToEffect()
				smoke:SetTimeout(15)
				smoke.SpriteScale = Vector(0.05,0.05)
				smoke:Update()
				local rarity = {1}
				if rng:RandomInt(5) == 0 or mult >= 2 then
					rarity = {2}
				end

				local newTrinket = FiendFolio.GetGolemTrinket(rarity, nil, true)
                --FiendFolio.TryRemoveGolemTrinketFromPool(newTrinket)
				newTrinket = mod.tryMakeTrinketGolden(newTrinket)

				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, newTrinket, player.Position, RandomVector()*5, player)
				data.RunEffects.TrueRoomClearCounts.ThunderEgg = 0
				player:TryRemoveTrinket(FiendFolio.ITEM.ROCK.THUNDER_EGG)
			elseif data.RunEffects.TrueRoomClearCounts.ThunderEgg > 10 then
				sfx:Play(SoundEffect.SOUND_POT_BREAK, 0.35, 0, false, math.random(65,75)/70)
			end
		end
		if player:HasTrinket(FiendFolio.ITEM.ROCK.DEATH_CAP_FOSSIL) then
			local mult = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.DEATH_CAP_FOSSIL)
			data.RunEffects.DeathCapFossilCount = (data.RunEffects.DeathCapFossilCount or 0) + mult
			if data.RunEffects.DeathCapFossilCount > 30 then
				data.RunEffects.DeathCapFossilCount = 30
			end
			player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
		end
		if player:HasTrinket(FiendFolio.ITEM.ROCK.SOAP_STONE) then
			for _,proj in ipairs(Isaac.FindByType(9,-1,-1,false,true)) do
				proj:Die()
			end
		end
        if player:HasTrinket(FiendFolio.ITEM.ROCK.ONION_ROCK) then
            if data.RunEffects.brickminData and data.RunEffects.brickminData.roomClear then
                data.RunEffects.brickminData.roomClear = data.RunEffects.brickminData.roomClear+1

                local spawnNew = 3
                local maxBrickmins = 4
                local mult = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.ONION_ROCK)
                if mult < 1 then
                    spawnNew = 4
                    maxBrickmins = 2
                elseif mult > 1 then
                    spawnNew = 2
                    maxBrickmins = math.max(10, maxBrickmins+mult)
                end

                if data.RunEffects.brickminData.roomClear > spawnNew and #data.RunEffects.brickminData.brickmins < maxBrickmins then
                    local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.ONION_ROCK)
                    table.insert(data.RunEffects.brickminData.brickmins, rng:RandomInt(2))
                    data.RunEffects.brickminData.roomClear = 0
                    player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS, true)
                end
            end
        end
    end)
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    mod.AnyPlayerDo(function(player)
        local data = mod:GetEntityData(player).ffsavedata
        data.RunEffects.Trinkets.TimeLostDiamondRooms = nil
        data.RunEffects.Trinkets.ObsidianGrindstoneBreaks = nil
		--Sturdy Rock Trinket Code
		if player:HasTrinket(FiendFolio.ITEM.ROCK.STURDY_ROCK) then
            local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.STURDY_ROCK)
            if trinketPower < 1 then
                player:AddSoulHearts(1)
            elseif trinketPower >= 2 then
                player:AddSoulHearts(4)
            else
                player:AddSoulHearts(2)
            end
        end
	end)

    mod.savedata.GolemEmeraldData = {}
    mod.savedata.run.HurryUpSourPuss = false
end)

-- Spiked Rock
mod:AddPriorityTrinketCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, -10, FiendFolio.ITEM.ROCK.SPIKED_ROCK, function(_, ent, amt, flags, source)
    local player = ent:ToPlayer()
    if player:HasTrinket(FiendFolio.ITEM.ROCK.SPIKED_ROCK) then
        local basedata = mod:GetEntityData(player)
        local data = basedata.ffsavedata

        if data.RunEffects.Trinkets.SpikeRockDmg
        and flags & (DamageFlag.DAMAGE_SPIKES | DamageFlag.DAMAGE_CHEST) ~= 0 and (source and not (source.Type == 0 and source.Variant == 10003)) then
            local room = game:GetRoom()
            local isSacrificeSpikes = false
            if room:GetType() == RoomType.ROOM_SACRIFICE then
                local gent = room:GetGridEntityFromPos(player.Position)
                isSacrificeSpikes = gent and gent:GetType() == GridEntityType.GRID_SPIKES
            end

            if not isSacrificeSpikes then
                return false
            end
        end
    end
end, EntityType.ENTITY_PLAYER)

-- Time-Lost Diamond
mod:AddPriorityTrinketCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, -10, FiendFolio.ITEM.ROCK.TIME_LOST_DIAMOND, function(_, ent, amt, flags, source)
    local player = ent:ToPlayer()
    if player:HasTrinket(FiendFolio.ITEM.ROCK.TIME_LOST_DIAMOND) and game:GetRoom():IsFirstVisit() then
        local basedata = mod:GetEntityData(player)
        local data = basedata.ffsavedata

        local roomId = game:GetLevel():GetCurrentRoomDesc().SafeGridIndex
        if not data.RunEffects.Trinkets.TimeLostDiamondRooms then
            data.RunEffects.Trinkets.TimeLostDiamondRooms = {}
        end

        if not data.RunEffects.Trinkets.TimeLostDiamondRooms[roomId] then
            local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.TIME_LOST_DIAMOND)
            local activate = true
            if trinketPower < 1 then
                activate = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.TIME_LOST_DIAMOND):RandomFloat() < trinketPower
            end

            if activate then
                player:UseActiveItem(CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS, false, true, true, false)
                player:AnimateTrinket(FiendFolio.ITEM.ROCK.TIME_LOST_DIAMOND, "UseItem", "PlayerPickup")
                data.RunEffects.Trinkets.TimeLostDiamondRooms[roomId] = true
                return false
            end
        end
    end
end, EntityType.ENTITY_PLAYER)

-- Thorny Rock
mod:AddTrinketCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, FiendFolio.ITEM.ROCK.THORNY_ROCK, function(_, ent, amt, flags, source)
    if flags & DamageFlag.DAMAGE_FAKE ~= 0 or not FiendFolio.IsActiveRoom() then return end

    local player = ent:ToPlayer()
    if player:HasTrinket(FiendFolio.ITEM.ROCK.THORNY_ROCK) then
        local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.THORNY_ROCK)
        local activate = true
        if trinketPower < 1 then
            activate = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.THORNY_ROCK):RandomFloat() < trinketPower
        end

        if activate then
            local wave = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SHOCKWAVE, 0,
                                     player.Position, nilvector, player):ToEffect()
            wave.Parent = player
            local powerOverOne = math.max(0, trinketPower - 1)
            wave.MaxRadius = 50 + (30 * powerOverOne)
        end
    end
end, EntityType.ENTITY_PLAYER)

-- Wetstone (on damage)
mod:AddTrinketCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, FiendFolio.ITEM.ROCK.WETSTONE, function(_, ent, amt, flags, source)
    if flags & DamageFlag.DAMAGE_FAKE ~= 0 or not FiendFolio.IsActiveRoom() then return end

    local player = ent:ToPlayer()
    if player:HasTrinket(FiendFolio.ITEM.ROCK.WETSTONE) then
        local mult = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.WETSTONE)
        local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.WETSTONE)
        for i=1,9+mult do
            mod.scheduleForUpdate(function()
                local size = rng:RandomInt(4)
                local velocity = Vector(0,math.max(0.3, rng:RandomInt(10)/3)):Rotated(rng:RandomInt(360))
                local bubble = Isaac.Spawn(150, 1, size, player.Position, velocity, player)
                bubble:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
                bubble:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                bubble:Update()
                local word = {[0] = "tiny", [1] = "small", [2] = "medium", [3] = "large"}
                bubble:GetSprite():Load("gfx/projectiles/bubble/bubble_" .. word[size] .. "_friendly.anm2", true)
                bubble:GetSprite():Play("Idle", true)
                bubble:GetSprite():LoadGraphics()
            end, i*2+rng:RandomInt(2))
        end
    end
end, EntityType.ENTITY_PLAYER)

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, function(_, ent, amt, flags)
    local player = ent:ToPlayer()

    local basedata = mod:GetEntityData(player)
    local data = basedata.ffsavedata

    if player:GetPlayerType() == FiendFolio.PLAYER.GOLEM or player:GetPlayerType() == FiendFolio.PLAYER.BOLEM then
         if flags == flags | DamageFlag.DAMAGE_EXPLOSION then
            basedata.golemHurtByExplosionRecently = player.FrameCount
         end
    end

    if not data.HasBeenDamagedInRoom and flags & DamageFlag.DAMAGE_FAKE == 0 and FiendFolio.IsActiveRoom() then
        data.HasBeenDamagedInRoom = true
        data.RoomsClearedWithoutDamage = 0

        local clearCounts = data.RunEffects.RoomClearCounts
        for key, _ in pairs(clearCounts) do
            clearCounts[key] = 0
        end

        basedata.RoomsClearedWithoutDamageUpdate = true
    end
end, EntityType.ENTITY_PLAYER)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local p1 = Isaac.GetPlayer(0)
    local d = mod:GetEntityData(p1)

    local room = game:GetRoom()

    if d.golemroomclear == nil then d.golemroomclear =  room:IsClear() end

    if room:IsClear() and not d.golemroomclear then
        for trink, func in pairs(FiendFolio.PostRoomCompleteEffects) do
            mod.AnyPlayerDo(function(player)
                if player:HasTrinket(trink) then func(player) end
            end)
        end
    end

    d.golemroomclear = room:IsClear()
end)

mod:AddCallback(ModCallbacks.MC_POST_GRID_ROCK_DESTROY, function(_, gridEnt, gridEntType, immediate, source)
	-- Golem Birthright
	if (gridEntType == GridEntityType.GRID_ROCKT or gridEntType == GridEntityType.GRID_ROCK_SS)
	and PlayerManager.AnyPlayerTypeHasBirthright(FiendFolio.PLAYER.GOLEM) then
		local trinket = FiendFolio.GetGolemTrinket()
		local spawnVel = EntityPickup.GetRandomPickupVelocity(gridEnt.Position)
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, trinket, gridEnt.Position, spawnVel, nil)
	end

	-- Trigger PostRockBreakEffects
	mod.AnyPlayerDo(function(player)
		for t, f in pairs(FiendFolio.PostRockBreakEffects) do
			if player:HasTrinket(t) then f(gridEnt, player) end
		end
	end)
end)

-- Ribbed Rock
function mod:RibbedRockUpdate(player)
    local d = mod:GetEntityData(player)

    if player:HasTrinket(FiendFolio.ITEM.ROCK.RIBBED_ROCK) then
        local nowhealth = player:GetMaxHearts()
        d.golemprevioushealth = d.golemprevioushealth or nowhealth

        if d.golemprevioushealth < nowhealth then
            local hearts = player:GetHearts()
            player:AddMaxHearts(d.golemprevioushealth - nowhealth)
            player:AddBoneHearts((nowhealth - d.golemprevioushealth) / 2)
            player:AddHearts(hearts - player:GetHearts())

            local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.RIBBED_ROCK)
            if trinketPower > 1 then
                player:AddBoneHearts(1)
                player:AddHearts(2)
            end
        end

        d.golemprevioushealth = nowhealth
    else
        d.golemprevioushealth = nil
    end
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, FiendFolio.ITEM.ROCK.RIBBED_ROCK, mod.RibbedRockUpdate)
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, mod.RibbedRockUpdate, FiendFolio.ITEM.ROCK.RIBBED_ROCK)

-- Quick Geode
mod:AddTrinketCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, FiendFolio.ITEM.ROCK.QUICK_GEODE, function(_, player)
    if player:HasTrinket(FiendFolio.ITEM.ROCK.QUICK_GEODE) then
        local data = mod:GetEntityData(player)
        if data.QuickGeodeCleared ~= not FiendFolio.IsActiveRoom() then
            player:AddCacheFlags(CacheFlag.CACHE_SPEED, true)
        end
    end
end)

-- Mineral Rock
mod:AddTrinketCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, FiendFolio.ITEM.ROCK.MINERAL_ROCK, function(_, player)
    if not player:HasTrinket(FiendFolio.ITEM.ROCK.MINERAL_ROCK) then return end

    local data = mod:GetEntityData(player)

    local isRubbingRock = false

    local room = game:GetRoom()
    local movedir = player:GetMovementVector()
    local checkDirs = {}
    if movedir.X ~= 0 then
        table.insert(checkDirs, Vector(FiendFolio.sign(movedir.X), 0))
    end
    if movedir.Y ~= 0 then
        table.insert(checkDirs, Vector(0, FiendFolio.sign(movedir.Y)))
    end
    if #checkDirs == 2 then
        table.insert(checkDirs, Vector(FiendFolio.sign(movedir.X), FiendFolio.sign(movedir.Y)))
    end

    for _, dir in ipairs(checkDirs) do
        local nextGrid = room:GetGridEntity(room:GetGridIndex(player.Position + dir * 40))
        if nextGrid and nextGrid:ToRock() and nextGrid.State ~= 2 then
            local nextGridPos = nextGrid.Position
            local delta = nextGridPos - player.Position

            isRubbingRock = math.abs(dir.X == 0 and delta.Y or delta.X) <= (20 + player.Size + 1)
            if isRubbingRock then break end
        end
    end

    if data.RubbingRock ~= isRubbingRock then
        data.RubbingRock = isRubbingRock
        player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
    end
end)

-- Health Geode
mod:AddTrinketCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, FiendFolio.ITEM.ROCK.HEALTH_GEODE, function(_, player)
    if not player:HasTrinket(FiendFolio.ITEM.ROCK.HEALTH_GEODE) then return end

    local basedata = mod:GetEntityData(player)
    local savedata = basedata.ffsavedata

    if not savedata then return end

    if savedata.RunEffects.Trinkets.HealthGeodeHeal then
        if player:GetSoulHearts() + player:GetHearts() <= 2 and not player:HasFullHearts() then
            player:SetFullHearts()
            sfx:Play(SoundEffect.SOUND_VAMP_GULP, 1, 0, false, 1)
            savedata.RunEffects.Trinkets.HealthGeodeHeal = false

            if FiendFolio.HasTwoGeodes(player) then
                local numHearts = 2
                if player:GetTrinket(0) == FiendFolio.ITEM.ROCK.HEALTH_GEODE + TrinketType.TRINKET_GOLDEN_FLAG or
                   player:GetTrinket(1) == FiendFolio.ITEM.ROCK.HEALTH_GEODE + TrinketType.TRINKET_GOLDEN_FLAG
                then
                    numHearts = 4
                end

                player:AddSoulHearts(numHearts)
            end

            FiendFolio.BreakRockTrinket(player, FiendFolio.ITEM.ROCK.HEALTH_GEODE, Color(1.4, 0.8, 1, 1, 0, 0, 0))
        end
    end
end)

-- Twenty Sided Emerald
mod:AddTrinketCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, FiendFolio.ITEM.ROCK.TWENTY_SIDED_EMERALD, function(_, player)
    if not player:HasTrinket(FiendFolio.ITEM.ROCK.TWENTY_SIDED_EMERALD) then return end

    local basedata = mod:GetEntityData(player)
    local savedata = basedata.ffsavedata

    if not savedata then return end

    local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.TWENTY_SIDED_EMERALD)
    local rerollCap = 3
    if trinketPower < 1 then
        rerollCap = 1
    elseif trinketPower >= 2 then
        rerollCap = 3 + math.floor(trinketPower - 1)
    end

    savedata.lastmoved = savedata.lastmoved or player.FrameCount
    if player.Velocity:Length() > 0.1 then savedata.lastmoved = player.FrameCount end
    if savedata.lastmoved ~= player.FrameCount and (player.FrameCount - savedata.lastmoved) % 90 == 0 then
        FiendFolio.savedata.GolemEmeraldData = FiendFolio.savedata.GolemEmeraldData or {}
        for _, pickup in pairs(Isaac.FindInRadius(player.Position, player.Size + 32, EntityPartition.PICKUP)) do
            local level = game:GetLevel()
            local index = tostring(level:GetCurrentRoomDesc().SafeGridIndex)..pickup.InitSeed
            FiendFolio.savedata.GolemEmeraldData[index] = FiendFolio.savedata.GolemEmeraldData[index] or 0

            if FiendFolio.savedata.GolemEmeraldData[index] < rerollCap and (FiendFolio.IsReplaceablePickup(pickup) or pickup.Variant == 350) then
                pickup:ToPickup():Morph(5, 0, 1, true)
                Isaac.Spawn(1000, 15, 0, pickup.Position, nilvector, nil)

                FiendFolio.savedata.GolemEmeraldData[tostring(level:GetCurrentRoomDesc().SafeGridIndex)..pickup.InitSeed] = FiendFolio.savedata.GolemEmeraldData[index] + 1
                FiendFolio.savedata.GolemEmeraldData[index] = nil
            end
        end
    end
end)

-- Technological Ruby 2.0
mod:AddTrinketCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, FiendFolio.ITEM.ROCK.TECHNOLOGICAL_RUBY_2, function(_, player)
    if not player:HasTrinket(FiendFolio.ITEM.ROCK.TECHNOLOGICAL_RUBY_2) then return end

    local d = mod:GetEntityData(player)

    local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.TECHNOLOGICAL_RUBY_2)
    local numLasers = 2
    if trinketPower < 1 then
        numLasers = 1
    elseif trinketPower >= 2 then
        numLasers = 3
    end

    if not d.TechRubyLasers or #d.TechRubyLasers ~= numLasers then
        d.TechRubyLasers = {}

        local radii = {player.Size + 15, player.Size + 40, player.Size + 65}
        local damages = {0.25, 0.1, 0.05}

        for i = 1, numLasers do
            local radius = radii[i]
            local damage = damages[i]
            if numLasers == 1 then
                damage = damages[2]
            end

            mod.IgnoreSecondaryFireEffects = true
            local laser = player:FireTechXLaser(player.Position, nilvector, radius, player, damage)
            mod.IgnoreSecondaryFireEffects = false

            mod:GetEntityData(laser).BaseRadius = radius
            laser.PositionOffset = Vector(0, -5)
            laser.DepthOffset = player.DepthOffset - 10
            laser.Mass = 0
            laser:Update()
            -- The weird laser squiggle in the middle of the circles look *gross*
            if laser.Child and laser.Child.Type == EntityType.ENTITY_EFFECT and laser.Child.Variant == EffectVariant.LASER_IMPACT then
                laser.Child.Visible = false
                laser.Child:Remove()
            end

            d.TechRubyLasers[i] = EntityPtr(laser)
        end

        sfx:Play(SoundEffect.SOUND_REDLIGHTNING_ZAP, 1, 0, false, 1)
    end

    for _, laserPtr in ipairs(d.TechRubyLasers) do
        local laser = mod:GetPointee(laserPtr)
        if not laser or not laser:Exists() then
            for _, l2p in ipairs(d.TechRubyLasers) do
                local l2 = mod:GetPointee(l2p)
                if l2 and l2:Exists() then
                    l2:Remove()
                end
            end

            d.TechRubyLasers = nil
            break
        else
            laser:SetTimeout(4)
            laser.SpriteScale = Vector.One
            laser.Velocity = (player.Position + player.Velocity * 3.5) - laser.Position
            local baseRadius = mod:GetEntityData(laser).BaseRadius
            local twoPi = math.pi * 2
            local pulse = (math.sin(twoPi * (laser.FrameCount / 60)) + 1) / 2
            laser.Radius = mod:Lerp(baseRadius * 0.5, baseRadius * 1.2, pulse)
        end
    end
end)

-- Leaky Rock
mod:AddTrinketCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, FiendFolio.ITEM.ROCK.LEAKY_ROCK, function(_, player)
    if not player:HasTrinket(FiendFolio.ITEM.ROCK.LEAKY_ROCK) then return end

    local d = mod:GetEntityData(player)

    d.leakyrockcooldown = d.leakyrockcooldown or 0

    local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.LEAKY_ROCK)

    if d.leakyrockcooldown <= 0 and player.Velocity:Length() > 0.1 then
        local t = Isaac.Spawn(2, 0, 0, player.Position, nilvector, player):ToTear()
        t.CollisionDamage = player.Damage
        t.Scale = (player.Damage / 3.5)^0.5
        t.Height = t.Height * 1.5
        d.leakyrockcooldown = (player.MaxFireDelay^0.5) * 4 * (1 / trinketPower)
    end

    d.leakyrockcooldown = math.max(0, d.leakyrockcooldown - 1)
end)

function mod:RollingRockUpdate(player, basedata, data)
    if not basedata.RoomsClearedWithoutDamageUpdate then return end

    basedata.RoomsClearedWithoutDamageUpdate = false

    if player:HasTrinket(FiendFolio.ITEM.ROCK.ROLLING_ROCK) then
		if not data.HasBeenDamagedInRoom or game:GetRoom():GetFrameCount() < 5 then
            player:AddCacheFlags(CacheFlag.CACHE_SPEED, true)
        end
    end
end

function mod:GolemRockForcedCacheUpdate(player, data)
    local trinketA = player:GetTrinket(0)
    local trinketB = player:GetTrinket(1)
    local heldTrinkets = { trinketA, trinketB }

    if not data.HeldTrinkets
    or data.HeldTrinkets[1] ~= heldTrinkets[1]
    or data.HeldTrinkets[2] ~= heldTrinkets[2] then
        local oldVal = data.HeldTrinkets

        data.HeldTrinkets = heldTrinkets
        if not oldVal then return end

        -- get the set of changed trinkets
        local changedTrinkets = {}
        for _, p in pairs({
            { heldTrinkets, oldVal },
            { oldVal, heldTrinkets }
        }) do
            local delta = FiendFolio.filter(p[1], function(newTrink)
                return newTrink ~= 0 and not FiendFolio.findKey(p[2], function(oldTrink)
                    return oldTrink == newTrink
                end)
            end)
            FiendFolio.append(changedTrinkets, delta)
        end

        local cacheUpdate = 0

        -- for geodes, always force a cache eval if any geode changed hands
        if FiendFolio.findKey(changedTrinkets, function(trink) return FiendFolio.IsGeode(trink) end) then
            cacheUpdate = cacheUpdate | CacheFlag.CACHE_ALL
        end

        --[[if player:HasTrinket(FiendFolio.ITEM.ROCK.LITTLE_GEODE) then
            local oldSize = data.ffsavedata.RunEffects.Trinkets.LittleGeodeSize
            if oldSize then
                data.ffsavedata.RunEffects.Trinkets.LittleGeodeSize =
                    FiendFolio.HasTwoGeodes(player, FiendFolio.ITEM.ROCK.LITTLE_GEODE) and 2 or 1
                local diff = oldSize - data.ffsavedata.RunEffects.Trinkets.LittleGeodeSize
                if diff ~= 0 then
                    player.SpriteScale = player.SpriteScale + Vector(0.2, 0.2) * diff
                end
            end
        end]]--

        if player:HasTrinket(FiendFolio.ITEM.ROCK.OBSIDIAN_GRINDSTONE) then
            cacheUpdate = cacheUpdate | CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY
        end

        if cacheUpdate > 0 then
            player:AddCacheFlags(cacheUpdate, true)
        end
    end
end

-- Bloody Rock
mod:AddTrinketCallback(ModCallbacks.MC_POST_FIRE_TEAR, FiendFolio.ITEM.ROCK.BLOODY_ROCK, function(_, tear)
    local player = tear.Parent and tear.Parent:ToPlayer()
    if not player then return end

    if player:HasTrinket(FiendFolio.ITEM.ROCK.BLOODY_ROCK) then
        local data = mod:GetEntityData(player)

        data.ffBloodyRockTearFiredCount = (data.ffBloodyRockTearFiredCount or 0) + 1

        local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.BLOODY_ROCK)
        local bloodyRate = 4
        if trinketPower < 1 then
            bloodyRate = 8
        elseif trinketPower >= 2 then
            bloodyRate = math.ceil(bloodyRate * (1 / trinketPower))
        end

        if data.ffBloodyRockTearFiredCount % bloodyRate == 0 then
			mod:makeTearBloody(tear)

            local color = tear.Color
            color.R = color.R * 0.6
            color.G = color.G * 0.2
            color.B = color.B * 0.2
            tear.Color = color

            tear.CollisionDamage = tear.CollisionDamage * 2
            tear.Scale = tear.Scale * 1.5
        end
    end
end)

-- Arcane Rock
mod:AddTrinketCallback(ModCallbacks.MC_POST_FIRE_TEAR, FiendFolio.ITEM.ROCK.ARCANE_ROCK, function(_, tear)
    local player = tear.Parent and tear.Parent:ToPlayer()
    if not player then return end

    if player:HasTrinket(FiendFolio.ITEM.ROCK.ARCANE_ROCK) then
        local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.ARCANE_ROCK)
        local chance = math.min(5 + player.Luck * 2, 20) * trinketPower

        grng:SetSeed(tear.InitSeed, 0)
        if grng:RandomInt(100) < chance then
            tear.TearFlags = tear.TearFlags | TearFlags.TEAR_HOMING
            tear.Color = Color(0.4, 0.15, 0.37, 1, 71 / 255, 0, 116 / 255)
        end

        if tear.TearFlags & TearFlags.TEAR_HOMING ~= TearFlags.TEAR_NORMAL then
            local addDamage = math.min(2 * trinketPower, 2)
            local prop = (tear.CollisionDamage + addDamage) / tear.CollisionDamage * 0.7
            tear.CollisionDamage = tear.CollisionDamage + addDamage
            tear.Scale = tear.Scale * prop
        end
    end
end)

-- Webby Geode
mod:AddTrinketCallback(ModCallbacks.MC_POST_FIRE_TEAR, FiendFolio.ITEM.ROCK.WEBBY_GEODE, function(_, tear)
    local player = tear.Parent and tear.Parent:ToPlayer()
    if not player then return end

    if player:HasTrinket(FiendFolio.ITEM.ROCK.WEBBY_GEODE) then
        local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.WEBBY_GEODE)
        local chance = (20 + player.Luck * 2) * trinketPower
        grng:SetSeed(tear.InitSeed, 0)
        if grng:RandomInt(100) < chance then
            tear.TearFlags = tear.TearFlags | TearFlags.TEAR_SLOW
            tear.Color = Color(2, 2, 2, 1, 50 / 255, 50 / 255, 50 / 255)
        end
        mod:GetEntityData(tear).webbygeode = true
    end
end)

-- Phlegmy Geode
mod:AddTrinketCallback(ModCallbacks.MC_POST_FIRE_TEAR, FiendFolio.ITEM.ROCK.PHLEGMY_GEODE, function(_, tear)
    local player = tear.Parent and tear.Parent:ToPlayer()
    if not player then return end

    if player:HasTrinket(FiendFolio.ITEM.ROCK.PHLEGMY_GEODE) then
        local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.PHLEGMY_GEODE)
        local chance = (10 + player.Luck) * trinketPower
        grng:SetSeed(tear.InitSeed, 0)
        if grng:RandomInt(100) < chance then
            if tear.Variant ~= TearVariant.BOOGER then
                tear:ChangeVariant(TearVariant.BOOGER)
            end

            tear.TearFlags = tear.TearFlags | TearFlags.TEAR_BOOGER
            tear.Color = Color(1, 1, 1, 1, 0, 0, 0)
        end

        if tear.Variant == TearVariant.BOOGER and FiendFolio.HasTwoGeodes(player) then
            mod:GetEntityData(tear).phlegmygeode = true
        end
    end
end)

function mod:doObsidianGrindstone(player, data)
	local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.OBSIDIAN_GRINDSTONE)
    local activationTime = 10
    if trinketPower < 1 then
        activationTime = 30
    end

	data.obsidianCounter = (data.obsidianCounter or 0) + 1
    if data.obsidianCounter % activationTime == 0 then
        local slot = FiendFolio.GetOtherTrinketSlot(player, FiendFolio.ITEM.ROCK.OBSIDIAN_GRINDSTONE)
        local trink = slot >= 0 and player:GetTrinket(slot)
        if trink and trink ~= FiendFolio.ITEM.ROCK.POCKET_SAND then
            local trinkData = data.ffsavedata.RunEffects.Trinkets
            local color = Color(0.3, 0.2, 0.3, 1, 0, 0, 0)
            if math.random(100) <= 15
            --[[and (not trinkData.ObsidianGrindstoneBreaks or trinkData.ObsidianGrindstoneBreaks < 2)]] then
                trinkData.ObsidianGrindstoneBreaks = (trinkData.ObsidianGrindstoneBreaks or 0) + 1
                FiendFolio.BreakRockTrinket(player, trink, color, nil, nil, 7, 12)
                player:AddTrinket(FiendFolio.ITEM.ROCK.POCKET_SAND)
            else
                local newTrinket = FiendFolio.GetRandomGolemTrinket(nil, FiendFolio.ITEM.ROCK.OBSIDIAN_GRINDSTONE)
                FiendFolio.BreakRockTrinket(player, trink, color,
                                            SoundEffect.SOUND_HELLBOSS_GROUNDPOUND, 0.6)
                player:AddTrinket(newTrinket)
                FiendFolio.TryRemoveGolemTrinketFromPool(newTrinket)
				ItemPool:RemoveTrinket(newTrinket)
            end
        end
		return true
    end
end

mod:AddTrinketCallback(FiendFolio.CALLBACK.FF_SECONDARY_FIRE, mod.ITEM.ROCK.OBSIDIAN_GRINDSTONE, function(_, player, dir, amount, owner, params)
	local mainplayer = (player:GetPlayerType() == mod.PLAYER.BRIEND and player:GetMainTwin()) or player
	if mainplayer:HasTrinket(mod.ITEM.ROCK.OBSIDIAN_GRINDSTONE) then
		for i = 1, params.NumTears do
			if mod:doObsidianGrindstone(mainplayer, mod:GetEntityData(mainplayer)) then return end
		end
	end
end)

function mod:fireBeeterFossil(player, num, data)
	data.ffBeeterFossilTearFiredCount = (data.ffBeeterFossilTearFiredCount or 0) + 1

	local tearsFired = 0
	for i = 1, num do
		local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.BEETER_FOSSIL)
		local shouldShoot = true
		local tearCount = 1
		if trinketPower < 1 then
			shouldShoot = data.ffBeeterFossilTearFiredCount % 3 == 0
		elseif trinketPower > 1 then
			tearCount = math.floor(trinketPower)
		end
		local maxTears = math.max(18, tearCount * 6)

		if shouldShoot then
			if data.BeeterFossilAngle ~= nil then
				data.BeeterFossilAngle = data.BeeterFossilAngle + math.min(20, 360 / tearCount / 6)
			else
				data.BeeterFossilAngle = -90
			end
			for i = 1, tearCount do
				local vel = Vector.FromAngle(data.BeeterFossilAngle + (360 / tearCount) * i) * 8 * player.ShotSpeed

				local beetertear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLOOD, 0,
											   player.Position, vel, player):ToTear()
				beetertear.FallingSpeed = player.TearFallingSpeed
				beetertear.Height = player.TearHeight
				beetertear.CollisionDamage = player.Damage * 0.3

				tearsFired = tearsFired + 1
				if tearsFired >= maxTears then return end
			end
		end
    end
end

mod:AddTrinketCallback(FiendFolio.CALLBACK.FF_SECONDARY_FIRE, FiendFolio.ITEM.ROCK.BEETER_FOSSIL, function(_, player, dir, amount, owner, params)
	if player:HasTrinket(mod.ITEM.ROCK.BEETER_FOSSIL) then
		mod:fireBeeterFossil(player, params.NumTears, mod:GetEntityData(player))
	end
end)

local primordialFlag = mod:AddSecondaryFireTearFlag("PRIMORDIAL")
function mod:makeTearPrimordial(tear, player)
	tear.Scale = tear.Scale * math.random(8, 10)/10
	mod:changeTearVariant(tear, TearVariant.MYSTERIOUS)
	if not (tear:HasTearFlags(TearFlags.TEAR_POP) or tear:HasTearFlags(TearFlags.TEAR_ABSORB)) then
		tear.FallingSpeed = -15 - math.random(20)/10
		tear.FallingAcceleration = 0.9 + math.random(10)/10
		if player:HasCollectible(CollectibleType.COLLECTIBLE_EYE_OF_THE_OCCULT) then
			tear.FallingAcceleration = tear.FallingAcceleration * 0.705
		end
	end
    tear.TearFlags = tear.TearFlags | TearFlags.TEAR_MYSTERIOUS_LIQUID_CREEP
	tear.Velocity = tear.Velocity:Resized(tear.Velocity:Length() + math.random(-2, 2)):Rotated(math.random(-20, 20))
	tear:ResetSpriteScale()
end

function mod:firePrimordialTear(player, vel, source, flags, posOffset)
	local flags = flags or 0
	if flags & mod.SecondaryFireTearFlags.RECURSIVE ~= 0 then return false end

	local tear = mod:SpawnPlayerTear(player, ((source and source.Position) or player.Position) + (posOffset or Vector(0,0)), vel)
	mod:makeTearPrimordial(tear, player)
	mod:checkReplaceableSecondaryFiredTears(tear, player, source, mod.SecondaryFireTearFlags.RECURSIVE | primordialFlag)
	Isaac.RunCallback(FiendFolio.CALLBACK.FF_POST_FIRE_SECONDARY_TEAR, tear, player)
	tear:Update()
	return true
end

mod:AddTrinketCallback(FiendFolio.CALLBACK.FF_SECONDARY_FIRE_TEAR_EFFECTS, FiendFolio.ITEM.ROCK.PRIMORDIAL_FOSSIL, function(_, tear, player, vel, source, flags)
	if flags & primordialFlag == 0 and player:HasTrinket(FiendFolio.ITEM.ROCK.PRIMORDIAL_FOSSIL) then
        local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.PRIMORDIAL_FOSSIL)
        local chance = (1 / 15) * trinketPower
        if grng:RandomFloat() < chance then
			local extraTears = 10
			local didPrimordial = false
			if not mod:HasUnstackableSecondaryFlag(flags) then
				mod:makeTearPrimordial(tear, player)
				didPrimordial = true
				extraTears = 9
			end
			for i = 1, extraTears do
				if mod:firePrimordialTear(player, vel, source, flags) then
					didPrimordial = true
				end
			end
			if didPrimordial then
				sfx:Play(FiendFolio.Sounds.SpitumShoot, 0.6, 0, false, math.random(95,105)/100)
				return flags | primordialFlag
			end
		end
	end
end)

mod:AddTrinketCallback(FiendFolio.CALLBACK.FF_SECONDARY_FIRE, FiendFolio.ITEM.ROCK.PRIMORDIAL_FOSSIL, function(_, player, dir, amount, owner, params)
	if player:HasTrinket(mod.ITEM.ROCK.PRIMORDIAL_FOSSIL) then
		local weaponType = params.WeaponType
		local modifiers = params.WeaponModifiers
		local charge = params.WeaponCharge
		local maxFireDelay = params.WeaponMaxFireDelay
		local numTears = params.NumTears
		if not params.ForceTearEffects and
		   ((weaponType == WeaponType.WEAPON_TEARS and not (params.GatlingGun or params.SwallowedM90 or params.RapidFireOpal)) or
		    (weaponType == WeaponType.WEAPON_MONSTROS_LUNGS and not player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS)) or
		    (weaponType == WeaponType.WEAPON_BONE and modifiers & WeaponModifier.MONSTROS_LUNG == WeaponModifier.MONSTROS_LUNG and charge >= maxFireDelay * 2) or
		    (weaponType == WeaponType.WEAPON_SPIRIT_SWORD and params.FriendGun and params.IsFriendChargedSlash))
		then
			return
		end
		local isMonstrosLung = (weaponType == WeaponType.WEAPON_MONSTROS_LUNGS or modifiers & WeaponModifier.MONSTROS_LUNG == WeaponModifier.MONSTROS_LUNG) and
		                       weaponType ~= WeaponType.WEAPON_URN_OF_SOULS and weaponType ~= WeaponType.WEAPON_SPIRIT_SWORD and weaponType ~= WeaponType.WEAPON_FETUS

        local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.PRIMORDIAL_FOSSIL)
        local chance = (1 / 15) * trinketPower
		local numProcs = 0
		for i = 1, numTears do
			if grng:RandomFloat() < chance then
				numProcs = numProcs + 1
			end
		end

		for i = 1, numProcs do
			local pos = Vector(0,0)
			local vel = nil
			if isMonstrosLung then
				local a = mod:getSign(rng) * rng:RandomFloat()
				local b = (mod:getSign(rng) * rng:RandomFloat() * math.pi) * 2

				local x = math.cos(b) * a * 3.5 + player.ShotSpeed * dir:Resized(player.TearRange / 20).X;
				local y = math.sin(b) * a * 3.5 + player.ShotSpeed * dir:Resized(player.TearRange / 20).Y;

				vel = Vector(x,y)
			else
				pos, vel = mod:GetMultiShotPositionVelocityBasic(dir * 10 + player:GetTearMovementInheritance(dir), player.ShotSpeed, numProcs, i - 1)
			end

			sfx:Play(FiendFolio.Sounds.SpitumShoot, 0.6, 0, false, math.random(95,105)/100)
			for i = 1, 10 do
				mod:firePrimordialTear(player, vel, player, nil, pos)
			end
		end

		if numProcs > 0 then
			local d = mod:GetEntityData(player)
			d.preventFushigiFire = d.preventFushigiFire or numProcs
		end
	end
end)

-- Lob Geode
mod:AddTrinketCallback(ModCallbacks.MC_POST_TEAR_UPDATE, FiendFolio.ITEM.ROCK.LOB_GEODE, function(_, tear)
    local player = tear.Parent and tear.Parent:ToPlayer()
    if not player then return end

    if player:HasTrinket(FiendFolio.ITEM.ROCK.LOB_GEODE) and tear.TearFlags & (TearFlags.TEAR_CONTINUUM | TearFlags.TEAR_SPECTRAL) == 0 then
		local room = game:GetRoom()
	   local gcoll = room:GetGridCollisionAtPos(tear.Position)
        tear.GridCollisionClass = (tear.Height < -50 and gcoll ~= GridCollisionClass.COLLISION_WALL and gcoll ~= GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER) and 0 or 4
    end
end)

mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, function(_, tear, collider)
    local player = tear.Parent and tear.Parent:ToPlayer()
    if not player then return end

    local tdata = mod:GetEntityData(tear)
    tdata.colliderblacklist = tdata.colliderblacklist or {} -- On collision effects shouldn't proc an unreasonable amount of times on a single enemy if you have piercing

    if not tdata.colliderblacklist[tostring(collider.InitSeed)] then
        if tdata.webbygeode then
            if tear.TearFlags & TearFlags.TEAR_SLOW ~= TearFlags.TEAR_NORMAL and FiendFolio.HasTwoGeodes(player) then
                local c = Isaac.Spawn(1000, 44, 0, tear.Position, nilvector, tear):ToEffect()
                c.SpriteScale = c.SpriteScale * 3
                c:Update()
            end
        end

        if tdata.phlegmygeode then
            collider:AddSlowing(EntityRef(player), 120, 2, Color(2, 2, 2, 1, 50 / 255, 50 / 255, 50 / 255))
        end

        tdata.colliderblacklist[tostring(collider.InitSeed)] = true
    end
end)

FiendFolio.AddTrinketPickupCallback(function(player)
    local data = mod:GetEntityData(player).ffsavedata
    data.RunEffects.RoomClearCounts.RollingRock = data.RoomsClearedWithoutDamage or 0
end, function(player)
    local data = mod:GetEntityData(player).ffsavedata
    data.RunEffects.RoomClearCounts.RollingRock = nil
end, FiendFolio.ITEM.ROCK.ROLLING_ROCK)

FiendFolio.AddTrinketPickupCallback(function(player)
    local data = mod:GetEntityData(player).ffsavedata
    data.RunEffects.Trinkets.HealthGeodeHeal = true
end, function(player)
    local data = mod:GetEntityData(player).ffsavedata
    data.RunEffects.Trinkets.HealthGeodeHeal = false
end, FiendFolio.ITEM.ROCK.HEALTH_GEODE)

--[[FiendFolio.AddTrinketPickupCallback(function(player)
    local data = mod:GetEntityData(player).ffsavedata
    data.RunEffects.Trinkets.LittleGeodeSize =
        FiendFolio.HasTwoGeodes(player, FiendFolio.ITEM.ROCK.LITTLE_GEODE) and 2 or 1
    player.SpriteScale = player.SpriteScale - Vector(0.2, 0.2) * data.RunEffects.Trinkets.LittleGeodeSize
end, function(player)
    local data = mod:GetEntityData(player).ffsavedata
    player.SpriteScale = player.SpriteScale + Vector(0.2, 0.2) * data.RunEffects.Trinkets.LittleGeodeSize
    data.RunEffects.Trinkets.LittleGeodeSize = nil
end, FiendFolio.ITEM.ROCK.LITTLE_GEODE)]]--

FiendFolio.AddTrinketPickupCallback(function(player)
    local data = mod:GetEntityData(player).ffsavedata
    data.FrictionMod = data.FrictionMod + 0.1
end, function(player)
    local data = mod:GetEntityData(player).ffsavedata
    data.FrictionMod = data.FrictionMod - 0.1
end, FiendFolio.ITEM.ROCK.SLIPPY_ROCK)

FiendFolio.AddTrinketPickupCallback(function(player)
    local d = mod:GetEntityData(player).ffsavedata
    if not d then return end

    if not d.RunEffects.Trinkets.RibbedRockBonus then
        player:AddBoneHearts(1)
        d.RunEffects.Trinkets.RibbedRockBonus = true
    end
end, nil, FiendFolio.ITEM.ROCK.RIBBED_ROCK)

--[[mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
    if not FiendFolio.IsReplaceablePickup(pickup) then return end

    local hasSackFossil = false
	local totalSackFossilChance = 0
    mod.AnyPlayerDo(function(player)
        if player:HasTrinket(FiendFolio.ITEM.ROCK.SACK_FOSSIL) then
            hasSackFossil = true

            local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.SACK_FOSSIL)
			totalSackFossilChance = totalSackFossilChance + 10 * trinketPower
        end
    end)
	totalSackFossilChance = math.ceil(totalSackFossilChance)

    if hasSackFossil then
        grng:SetSeed(pickup.InitSeed, 0)
        if grng:RandomInt(100) < totalSackFossilChance then
            pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_GRAB_BAG, 0)
        end
    end
end)]]

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
    if pickup.SubType == CoinSubType.COIN_PENNY then
        local luckyGolem = false
        local luckyGolemPlayer
        AnyGolemDo(function(player)
            if player:HasTrinket(TrinketType.TRINKET_LUCKY_ROCK) then
                luckyGolem = true
                luckyGolemPlayer = player
            end
        end)

        if luckyGolem then
            grng:SetSeed(pickup.InitSeed, 0)
            local trinketPower = FiendFolio.GetGolemTrinketPower(luckyGolemPlayer, TrinketType.TRINKET_LUCKY_ROCK)
            local chance = math.max(1, 1 * trinketPower)
            if grng:RandomInt(100) < chance then
                pickup:Morph(pickup.Type, pickup.Variant, CoinSubType.COIN_LUCKYPENNY)
            end
        end
    end
end, PickupVariant.PICKUP_COIN)

mod:AddCallback(mod.CALLBACK.FF_PLAYER_POST_START_GREED_WAVE, function(_, player, data, waveNumber, isBossWave)
    if player:HasTrinket(FiendFolio.ITEM.ROCK.COPROLITE_FOSSIL) then
        local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.COPROLITE_FOSSIL)
        local spawn = true
        if trinketPower < 1 then
            spawn = grng:RandomFloat() < trinketPower
        end

        if spawn then
            player:AddBlueFlies(math.ceil(trinketPower), player.Position, player)
        end
    end

    if player:HasTrinket(FiendFolio.ITEM.ROCK.FLY_FOSSIL) then
        local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.FLY_FOSSIL)
        local spawn = true
        if trinketPower < 1 then
            spawn = grng:RandomFloat() < trinketPower
        end

        if spawn then
            local count = math.ceil(trinketPower)
            for i = 1, count do
                local locust =
                    Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, LocustSubtypes.LOCUST_OF_FAMINE,
                                player.Position, nilvector, player):ToFamiliar()
                locust.Player = player
                locust:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            end
        end
    end

    if player:HasTrinket(FiendFolio.ITEM.ROCK.WETSTONE) then
        local mult = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.WETSTONE)
        local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.WETSTONE)
        for i=0,5+mult do
            local size = rng:RandomInt(4)
            local velocity = Vector(0,math.max(0.3, rng:RandomInt(10)/3)):Rotated(rng:RandomInt(360))
            local bubble = Isaac.Spawn(150, 1, size, player.Position, velocity, player)
            bubble:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
            bubble:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            bubble:Update()
            local word = {[0] = "tiny", [1] = "small", [2] = "medium", [3] = "large"}
            bubble:GetSprite():Load("gfx/projectiles/bubble/bubble_" .. word[size] .. "_friendly.anm2", true)
            bubble:GetSprite():Play("Idle", true)
            bubble:GetSprite():LoadGraphics()
        end
    end

    if player:HasTrinket(FiendFolio.ITEM.ROCK.FIENDISH_AMETHYST) then
        local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.FIENDISH_AMETHYST)
        local count = 4
        if trinketPower < 0.5 then
            count = 1
        elseif trinketPower < 1 then
            count = 2
        elseif trinketPower >= 2 then
            count = 4 + (trinketPower - 1) * 2
        end

        if player:HasTrinket(mod.ITEM.ROCK.FRIENDLY_RAPID_FIRE_OPAL) then
            count = count + math.random(2)
        end

        for i = 1, count do
            local minion = Isaac.Spawn(1000, 1736, 10, player.Position + RandomVector() * math.random(1,100)/10, nilvector, player)
            minion:Update()
        end
    end
end)

-- Coprolite Fossil
mod:AddTrinketCallback(ModCallbacks.MC_POST_NEW_ROOM, FiendFolio.ITEM.ROCK.COPROLITE_FOSSIL, function()
    local room = game:GetRoom()
    if room:IsFirstVisit() then
        mod.AnyPlayerDo(function(player)
            if player:HasTrinket(FiendFolio.ITEM.ROCK.COPROLITE_FOSSIL) then
                local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.COPROLITE_FOSSIL)
                local spawn = true
                if trinketPower < 1 then
                    spawn = grng:RandomFloat() < trinketPower
                end

                if spawn then
                    player:AddBlueFlies(math.ceil(trinketPower), player.Position, player)
                end
            end
        end)
    end
end)

-- Fly Fossil
mod:AddTrinketCallback(ModCallbacks.MC_POST_NEW_ROOM, FiendFolio.ITEM.ROCK.FLY_FOSSIL, function()
    local room = game:GetRoom()
    if room:IsFirstVisit() then
        mod.AnyPlayerDo(function(player)
            if player:HasTrinket(FiendFolio.ITEM.ROCK.FLY_FOSSIL) then
                local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.FLY_FOSSIL)
                local spawn = true
                if trinketPower < 1 then
                    spawn = grng:RandomFloat() < trinketPower
                end

                if spawn then
                    local count = math.ceil(trinketPower)
                    for i = 1, count do
                        local locust =
                            Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, LocustSubtypes.LOCUST_OF_FAMINE,
                                        player.Position, nilvector, player):ToFamiliar()
                        locust.Player = player
                        locust:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                    end
                end
            end
        end)
    end
end)

-- Fiendish Amethyst
mod:AddTrinketCallback(ModCallbacks.MC_POST_NEW_ROOM, FiendFolio.ITEM.ROCK.FIENDISH_AMETHYST, function()
    local room = game:GetRoom()
    if not room:IsClear() then
        mod.AnyPlayerDo(function(player)
            if player:HasTrinket(FiendFolio.ITEM.ROCK.FIENDISH_AMETHYST) then
                local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.FIENDISH_AMETHYST)
                local count = 4
                if trinketPower < 0.5 then
                    count = 1
                elseif trinketPower < 1 then
                    count = 2
                elseif trinketPower >= 2 then
                    count = 4 + (trinketPower - 1) * 2
                end

                if player:HasTrinket(mod.ITEM.ROCK.FRIENDLY_RAPID_FIRE_OPAL) then
                    count = count + math.random(2)
                end

				for i = 1, count do
					local minion = Isaac.Spawn(1000, 1736, 10, player.Position + RandomVector() * math.random(1,100)/10, nilvector, player)
					minion:Update()
				end
            end
        end)
    end
end)

-- Wetstone (on new room)
mod:AddTrinketCallback(ModCallbacks.MC_POST_NEW_ROOM, FiendFolio.ITEM.ROCK.WETSTONE, function()
    local room = game:GetRoom()
    if not room:IsClear() then
        mod.AnyPlayerDo(function(player)
            if player:HasTrinket(FiendFolio.ITEM.ROCK.WETSTONE) then
                local mult = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.WETSTONE)
                local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.WETSTONE)
                for i=0,5+mult do
                    local size = rng:RandomInt(4)
                    local velocity = Vector(0,math.max(0.3, rng:RandomInt(10)/3)):Rotated(rng:RandomInt(360))
                    local bubble = Isaac.Spawn(150, 1, size, player.Position, velocity, player)
					bubble:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
					bubble:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
					bubble:Update()
                    local word = {[0] = "tiny", [1] = "small", [2] = "medium", [3] = "large"}
                    bubble:GetSprite():Load("gfx/projectiles/bubble/bubble_" .. word[size] .. "_friendly.anm2", true)
					bubble:GetSprite():Play("Idle", true)
					bubble:GetSprite():LoadGraphics()
                end
            end
        end)
    end
end)

-- MACHINES

function FiendFolio.RemoveRecentRewards(pos)
    for _, pickup in ipairs(Isaac.FindByType(5, -1, -1)) do
        if pickup.FrameCount <= 1 and pickup.SpawnerType == 0
        and pickup.Position:DistanceSquared(pos) <= 400 then
            pickup:Remove()
        end
    end

    for _, trollbomb in ipairs(Isaac.FindByType(4, -1, -1)) do
        if (trollbomb.Variant == 3 or trollbomb.Variant == 4)
        and trollbomb.FrameCount <= 1 and trollbomb.SpawnerType == 0
        and trollbomb.Position:DistanceSquared(pos) <= 400 then
            trollbomb:Remove()
        end
    end
end

function FiendFolio.CloneEntity(ent, anims)
    local newEnt = Isaac.Spawn(ent.Type, ent.Variant, ent.SubType,
                                   ent.Position, ent.Velocity, ent.SpawnerEntity)
    newEnt:AddEntityFlags(ent:GetEntityFlags())
    newEnt:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

    local sprite, data = newEnt:GetSprite(), newEnt:GetData()

    local oldSprite = ent:GetSprite()
    for _, anim in ipairs(anims) do
        if oldSprite:IsPlaying(anim) then
            sprite:Play(anim)
            for i = 1, oldSprite:GetFrame() do sprite:Update() end
            break
        end
    end

    for key, val in pairs(ent:GetData()) do
        data[key] = val
    end

    return newEnt
end

function FiendFolio.OverrideExplosionHack(machine, dontRemove)
    local asploded = machine.GridCollisionClass == EntityGridCollisionClass.GRIDCOLL_GROUND
    if not asploded then return end

    FiendFolio.RemoveRecentRewards(machine.Position)

    local data = mod:GetEntityData(machine)
    if data.DropFunc then
        data.DropFunc()
    end

	if not dontRemove then
		machine:BloodExplode()
		machine:Remove()
	end
end

function FiendFolio.StopExplosionHack(machine)
    local asploded = machine.GridCollisionClass == EntityGridCollisionClass.GRIDCOLL_GROUND
    if not asploded then return end

    FiendFolio.RemoveRecentRewards(machine.Position)

    FiendFolio.CloneEntity(machine, mod:GetEntityData(machine).Anims)

    machine:Remove()
end

function FiendFolio.GetGrindPriceForTrinket(trinket, player)
    if mod:GetRealTrinketId(trinket)  == FiendFolio.ITEM.ROCK.DIRT_CLUMP then
        return 0
    elseif mod:GetRealTrinketId(trinket) == FiendFolio.ITEM.ROCK.POCKET_SAND then
        if player:HasTrinket(FiendFolio.ITEM.ROCK.REFUND_FOSSIL) then
            return 0
        end
    end

    return 3
end

function FiendFolio.GetNextMiningMachineTrinket(trinket, player)
    local rarities
	local rockType
	local gold
    if tonumber(trinket) then
        if mod:GetRealTrinketId(trinket) == FiendFolio.ITEM.ROCK.ROUGH_ROCK or mod:GetRealTrinketId(trinket) == FiendFolio.ITEM.ROCK.SACRED_SOIL then
            rarities = { 1, 2, 3 }
			if mod:IsGoldTrinket(trinket) then
				gold = true
			end
        elseif mod:GetRealTrinketId(trinket) == FiendFolio.ITEM.ROCK.DOUBLE_RUBBLE then
            rarities = { 0, 1 }
			if mod:IsGoldTrinket(trinket) then
				gold = true
			end
        elseif mod:GetRealTrinketId(trinket) == FiendFolio.ITEM.ROCK.DADS_LEGENDARY_GOLDEN_ROCK then
            rarities = { 1, 2, 3}
            sfx:Play(SoundEffect.SOUND_ULTRA_GREED_PULL_SLOT, 1.2, 0, false, 0.8)
            player:AnimateHappy()
			if mod:IsGoldTrinket(trinket) then
				gold = true
			end
        elseif mod:GetRealTrinketId(trinket)  == FiendFolio.ITEM.ROCK.TWINKLING_ROCK then
			rarities = { 0, 1}
			rockType = "Geode"
			if mod:IsGoldTrinket(trinket) then
				gold = true
			end
		end

    end

    local newTrink = FiendFolio.GetGolemTrinket(rarities, rockType)
    if newTrink == trinket then
        newTrink = FiendFolio.GetGolemTrinket(rarities, rockType)
    end
	newTrink = mod.tryMakeTrinketGolden(newTrink)

	if gold or ((tonumber(trinket) and mod:GetRealTrinketId(trinket) == FiendFolio.ITEM.ROCK.DADS_LEGENDARY_GOLDEN_ROCK)) then
		newTrink = mod.makeTrinketGolden(newTrink)
	end

    return newTrink
end

FiendFolio.onMachineTouch(mod.FF.MiningMachine.Var, function(player, slot)
    local sprite, data = slot:GetSprite(), mod:GetEntityData(slot)

    if sprite:IsPlaying('Idle') then
        local trinket = FiendFolio.GetMostRecentRockTrinket(player, true)
        if trinket > 0 then
            local price = FiendFolio.GetGrindPriceForTrinket(trinket, player)
			if player:HasTrinket(FiendFolio.ITEM.ROCK.SILVER_TONGUE) and price > 0 and player:GetNumCoins() >= price then
				local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.SILVER_TONGUE)
				local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.SILVER_TONGUE)
				local chance = 100
				if mult < 1 then
					chance = 50
				end
				if rng:RandomInt(100) < chance then
                    local discount = 1
                    if mult > 1 then
                        discount = math.floor(mult)
                    end
					price = math.max(0,price-discount)
				end
			end
            if player:GetNumCoins() >= price then
                data.GrindingTrinket = trinket
                data.NextTrinket = FiendFolio.GetNextMiningMachineTrinket(trinket, player)
                player:AddCoins(-price)
                sfx:Play(SoundEffect.SOUND_COIN_SLOT, 1, 0, false, 1)

                player:TryRemoveTrinket(trinket)

                mod:ferriumOnGrind(player, slot, data, trinket, price)

                sprite:ReplaceSpritesheet(5, ItemConfig:GetTrinket(trinket).GfxFileName)
                sprite:LoadGraphics()
                sprite:Play('Initiate', true)

                --Running after just in case anything relies on data.NextTrinket
                slot.SubType = data.NextTrinket
            end
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, function(_, slot)
    local sprite, data = slot:GetSprite(), mod:GetEntityData(slot)
    local pdata = EntitySaveStateManager.GetEntityData(mod, slot)

    if not data.init then
        slot:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
        data.NoDestroy = true
        data.Anims = { 'Idle', 'Initiate', 'Grind', 'Prize' }
        data.init = true
        if slot.SubType ~= 0 then
            sprite:Play('Prize', true)
        end
    end

    if sprite:IsPlaying('Idle') then  -- luacheck: ignore 542
        -- pass
    elseif sprite:IsPlaying('Initiate') then
        if sprite:IsEventTriggered('Gulp') then
            -- play gulping sound
            sfx:Play(SoundEffect.SOUND_SINK_DRAIN_GURGLE, 1, 0, false, 1)
        end
    elseif sprite:IsFinished('Initiate') then
        sprite:Play('Grind', true)
        data.FramesToGrind = 30
    elseif sprite:IsPlaying('Grind') then
        if not sfx:IsPlaying(FiendFolio.Sounds.Hoot6) then
            sfx:Play(FiendFolio.Sounds.Hoot6, 0.8, 0, false, math.random() * 0.2 + 0.8)
        end
        -- spawn smoke effect that travels up, get larger, and fades out from smoke stacks
        if slot.FrameCount % 2 == 0 then
            local smoke = Isaac.Spawn(1000, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0,
                                      slot.Position + Vector(12, 0), Vector(3, -3), slot):ToEffect()
            smoke:GetSprite().PlaybackSpeed = 0.5
            smoke.DepthOffset = 1000
            local dat = mod:GetEntityData(smoke)
            smoke.FallingSpeed = -5
            smoke.FallingAcceleration = 0
            smoke.m_Height = -44
            dat.IsGravityEff = true
            smoke.SpriteScale = Vector(0.9, 0.9)
            smoke.Scale = 1.1
            smoke.Timeout = 5
            smoke.LifeSpan = 12
            dat.IsScaledEff = true
        end
        -- spawn rock gibs at random frame intervals
        if slot.FrameCount % 7  == 0 then
            local r = math.min(math.max(0.8, math.random() * 2), 1.2)
            local g = math.min(math.max(0.8, math.random() * 2), 1.2)
            local b = math.min(math.max(0.8, math.random() * 2), 1.2)
            game:SpawnParticles(slot.Position, EffectVariant.ROCK_PARTICLE,
                                math.random(3, 4), 5, Color(r, g, b, 1, 0, 0, 0), -5)
        end
        -- play clanking noise if not playing
        if slot.FrameCount % 8 == 0 then
            sfx:Play(FiendFolio.Sounds.Bouja, 1, 0, false, math.min(math.max(0.4, math.random()), 0.8))
        end

        data.FramesToGrind = data.FramesToGrind - 1
        if data.FramesToGrind < 0 then
            sprite:Play('Prize', true)
        end
    elseif sprite:IsPlaying('Prize') then
        if sprite:IsEventTriggered('Prize') then
           sfx:Stop(FiendFolio.Sounds.Hoot6)
           sfx:Play(SoundEffect.SOUND_WHEEZY_COUGH, 1, 0, false, 1.2)
            -- emit dust clouds
            for i = 1, 4 do
                local dust = Isaac.Spawn(1000, EffectVariant.DUST_CLOUD, 0,
                                         slot.Position, RandomVector() * 3, slot):ToEffect()
                dust.Timeout = 7
                dust.LifeSpan = 10
                dust.m_Height = -20
                dust.FallingSpeed = 0
                dust.FallingAcceleration = 0
                mod:GetEntityData(dust).IsGravityEff = true
            end

            --Changed to use subtype
            local newTrinket = slot.SubType
            slot.SubType = 0

            if newTrinket == 0 then
                Isaac.DebugString("GOLEM MACHINE FAILED TO STORE TRINKET DATA")
                print("Golem Machine failed to store trinket data, please report this")
                newTrinket = FiendFolio.GetNextMiningMachineTrinket(1, Isaac.GetPlayer())
            end

            local trink = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, newTrinket,
                                      slot.Position, Vector.FromAngle(math.random(30, 150)) * 7, slot)
            local s = trink:GetSprite()
            for i = 1, 10 do
                s:Update()
            end

            --Sadly can't all be kept after exiting and re-entering the room
			if data.DoubledTrinket then
				local trink = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, data.DoubledTrinket,
                                      slot.Position, Vector.FromAngle(math.random(30, 150)) * 7, slot)
				local s = trink:GetSprite()
				for i = 1, 10 do
					s:Update()
				end
				data.DoubledTrinket = nil
			end
            sfx:Play(SoundEffect.SOUND_SLOTSPAWN, 1, 0, false, 1)

            if data.GrindingTrinket then
                if mod:GetRealTrinketId(data.GrindingTrinket) == FiendFolio.ITEM.ROCK.DADS_LEGENDARY_GOLDEN_ROCK then
                    for i=0,6 do
                        Isaac.Spawn(1000, EffectVariant.COIN_PARTICLE, 0, slot.Position, RandomVector()*math.random(1,6), slot)
                    end
                    for i = 30, 360, 40 do
                        local expvec = Vector(0,math.random(10,35)):Rotated(i+math.random(-10,10))
                        local sparkle = Isaac.Spawn(1000, 1727, 0, slot.Position + expvec * 0.1, expvec * 0.2, slot):ToEffect()
                        sparkle.SpriteOffset = Vector(0,-7)
                        sparkle.SpriteScale = Vector(0.8, 0.8)
                        sparkle:SetColor(Color(1,1,1,1,1,1,0), 100, 1, false, false)
                        sparkle:Update()
                    end
                end

                if mod:GetRealTrinketId(data.GrindingTrinket) == FiendFolio.ITEM.ROCK.TROLLITE then
                    Isaac.Explode(slot.Position, slot, 1)
                    slot:Remove()
                end
            end
        end
    elseif sprite:IsFinished('Prize') then
        sprite:Play('Idle', true)
    end

    FiendFolio.StopExplosionHack(slot)
end, mod.FF.MiningMachine.Var)

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, ent)
    local data = mod:GetEntityData(ent)
    if not (data.NoDestroy or data.DropFunc) then return end

    local spawnedItems = FiendFolio.filter(Isaac.FindByType(5, 100, -1), function(item)
        return item.FrameCount == 0 and item.Position.X == ent.Position.X and item.Position.Y == ent.Position.Y
    end)

    for _, item in pairs(spawnedItems) do
        item:Remove()
    end

    if #spawnedItems > 0 then
        if data.NoDestroy then
            FiendFolio.CloneEntity(ent, data.Anims)
        elseif data.DropFunc then
            data.DropFunc()
        end
    end
end, EntityType.ENTITY_SLOT)

FiendFolio.onMachineTouch(mod.FF.BismuthBeggar.Var, function(player, slot)
    local sprite, data = slot:GetSprite(), mod:GetEntityData(slot)

    if sprite:IsPlaying('Idle') then
        local trinket = FiendFolio.GetMostRecentRockTrinket(player, true)
        if trinket > 0 then
            data.CrushingTrinket = trinket
            data.CrushingPlayer = player
            player:TryRemoveTrinket(trinket)

            sfx:Play(SoundEffect.SOUND_SCAMPER, 1, 0, false, 1)

            sprite:ReplaceSpritesheet(2, ItemConfig:GetTrinket(trinket).GfxFileName)
            sprite:LoadGraphics()
            sprite:Play('PayOut', true)
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, function(_, slot)
    local sprite, data = slot:GetSprite(), mod:GetEntityData(slot)

    if not data.init then
        slot.SplatColor = Color(0, 1, 0.8, 1, 0, 120 / 255, 40 / 255)

        data.DropFunc = function()
            grng:SetSeed(slot.DropSeed, 0)

            local isCh6 = game:GetLevel():GetStage() == 11

            if not isCh6 and grng:RandomInt(4) == 0 then
                for i = 1, grng:RandomInt(3) + 1 do
                    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0,
                            slot.Position, Vector.FromAngle(math.random(30, 150)) * 4, slot)
                end
            elseif isCh6 or grng:RandomInt(10) == 0 then
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, FiendFolio.GetGolemTrinket(),
                            slot.Position, Vector.FromAngle(math.random(30, 150)) * 4, slot)
            end
        end

        data.init = true
    end

    if sprite:IsPlaying('Idle') then  -- luacheck: ignore 542
        -- pass
    elseif sprite:IsPlaying('PayOut') then
        if sprite:IsEventTriggered('Munch') then
            FiendFolio.CrushRockTrinket(data.CrushingPlayer, data.CrushingTrinket, slot)

            if mod:GetRealTrinketId(data.CrushingTrinket) == FiendFolio.ITEM.ROCK.ROCKY then
                sfx:Play(mod.Sounds.RockyCrush)
            end
        elseif sprite:IsEventTriggered('PayOut') then
            if mod:GetRealTrinketId(data.CrushingTrinket) == FiendFolio.ITEM.ROCK.TROLLITE then
                for i=1,2 do
                    Isaac.Spawn(4, 3, 0, slot.Position, Vector.FromAngle(math.random(30,150))*10, slot)
                end
            elseif mod:GetRealTrinketId(data.CrushingTrinket) == FiendFolio.ITEM.ROCK.HOLLOW_FOSSIL then
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_BLACK,
                        slot.Position, Vector.FromAngle(math.random(30, 150)) * 4, slot)
            else
                --[[if FiendFolio.BolemExists() then
                    if math.random() < 0.66 then
                        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL,
                                    slot.Position, Vector.FromAngle(math.random(30, 150)) * 4, slot)
                    else
                        for i = 1, 2 do
                            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY,
                                        slot.Position, Vector.FromAngle(math.random(30, 150)) * 4, slot)
                        end
                                    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF_SOUL,
                                    slot.Position, Vector.FromAngle(math.random(30, 150)) * 4, slot)
                    end
                else]]
                    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL,
                                slot.Position, Vector.FromAngle(math.random(30, 150)) * 4, slot)

                    if math.random() < 0.33 then
                        mod:TrySpawnHeart(
                            {
                                {PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF_SOUL},
                                {PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL}
                            },
                            slot.Position, Vector.FromAngle(math.random(30, 150)) * 4, slot
                        )
                    end
                --end
            end

            sfx:Play(SoundEffect.SOUND_SLOTSPAWN, 1, 0, false, 1)
        end
    elseif sprite:IsFinished('PayOut') then
        sprite:Play('Idle', true)
    end

    FiendFolio.OverrideExplosionHack(slot)
end, mod.FF.BismuthBeggar.Var)

FiendFolio.onMachineTouch(mod.FF.Sourpuss.Var, function(player, slot)
    local sprite, data = slot:GetSprite(), mod:GetEntityData(slot)

    if sprite:IsPlaying('Idle') or sprite:IsPlaying('IdleRandom') then
        local trinket, _, blasphemous = FiendFolio.GetMostRecentRockTrinket(player, true)

        if trinket > 0 then
            local price = FiendFolio.BolemExists() and 2 or 3

			if player:GetSoulHearts() >= price then
				data.CrushingTrinket = { id = trinket, blasphemous = blasphemous }
				data.CrushingPlayer = player
				player:TryRemoveTrinket(trinket)
				player:AddSoulHearts(-price)

                local anim = "Chisel"
                if mod.savedata.run.HurryUpSourPuss then
                    anim = math.random(1,2) == 2 and "ChiselFastAlt" or "ChiselFast"
                end
				sprite:Play(anim, true)
                mod.savedata.run.HurryUpSourPuss = true

                data.CrushingPlayer.Position = slot.Position + Vector(0, 40)
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, data.CrushingPlayer.Position, Vector.Zero, nil)
                data.CrushingPlayer.Velocity = Vector.Zero
                data.CrushingPlayer.ControlsCooldown = 2

                sfx:Play(SoundEffect.SOUND_SCAMPER, 1, 0, false, 1)
			end
        end
    end
end)

function mod:gulpTrinket(player, trinket, blasphemous)
    local data = mod:GetEntityData(player)
    local t0 = player:GetTrinket(0)
    local t1 = player:GetTrinket(1)

    data.GulpingTrinket = true

    if t1 > 0 then
        player:TryRemoveTrinket(t1)
    end
    if t0 > 0 then
        player:TryRemoveTrinket(t0)
    end

    player:AddTrinket(trinket)
    if blasphemous then
      mod:MakePlayerTrinketBlasphemous(player, 0)
    end
    player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, false, false, true, false)

    if t0 > 0 then
        player:AddTrinket(t0)
    end
    if t1 > 0 then
        player:AddTrinket(t1)
    end

    data.GulpingTrinket = false
end

mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, function(_, slot)
    local sprite, data = slot:GetSprite(), mod:GetEntityData(slot)

    local signCrop = FiendFolio.BolemExists() and Vector(0, 32) or Vector.Zero
    sprite:GetLayer("sign"):SetCropOffset(signCrop)

    if not data.init then
        data.DropFunc = function()
            grng:SetSeed(slot.DropSeed, 0)

            local isCh6 = game:GetLevel():GetStage() == 11

            if not isCh6 and grng:RandomInt(4) == 0 then
                for i = 1, grng:RandomInt(3) + 1 do
                    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0,
                            slot.Position, Vector.FromAngle(math.random(30, 150)) * 4, slot)
                end
            elseif isCh6 or grng:RandomInt(10) == 0 then
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, FiendFolio.GetGolemTrinket(),
                            slot.Position, Vector.FromAngle(math.random(30, 150)) * 4, slot)
            end
        end

		sprite:Play('Idle')
        data.init = true
        data.idleanimtimer = math.random() * 120
    end

    if sprite:IsPlaying('Idle') or sprite:IsPlaying("IdleRandom") then  -- luacheck: ignore 542
        if sprite:IsPlaying("Idle") then
            data.idleanimtimer = data.idleanimtimer - 1
            if data.idleanimtimer <= 0 then
                 data.idleanimtimer = (math.random() * 150) + 60
                 sprite:Play("IdleRandom", true)
             end
         end

        -- pass
    elseif sprite:IsPlaying("Chisel") or sprite:IsPlaying("ChiselFast") or sprite:IsPlaying("ChiselFastAlt") then
        data.CrushingPlayer.ControlsCooldown = 2

    elseif sprite:IsFinished('Chisel') or sprite:IsFinished('ChiselFast') or sprite:IsFinished("ChiselFastAlt") then
        local player = data.CrushingPlayer
        mod:gulpTrinket(player, data.CrushingTrinket.id, data.CrushingTrinket.blasphemous)

        sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE,1,2,false,1.2)
        for i = 30, 360, 30 do
            local smoke = Isaac.Spawn(1000, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, player.Position + Vector(0, 10), Vector(0,-10):Rotated(i), slot)
            smoke.SpriteOffset = Vector(0, -20)
            smoke.Color = Color(1,1,1,1,100 / 255,100 / 255,100 / 255)
            smoke:Update()
        end

        if mod:GetRealTrinketId(data.CrushingTrinket.id) == FiendFolio.ITEM.ROCK.TROLLITE then
            Isaac.Explode(player.Position, slot, 1)
        end

        sprite:Play('Idle', true)

    elseif sprite:IsFinished("IdleRandom") then
        sprite:Play("Idle", true)
    end

    if sprite:IsEventTriggered('Chisel') then
        game:SpawnParticles(slot.Position-Vector(0,-10), EffectVariant.ROCK_PARTICLE, math.random(1, 2), 5, Color.Default, -5,32)
        sfx:Play(SoundEffect.SOUND_SCYTHE_BREAK, 1, 0, false, 1)
    end

    FiendFolio.OverrideExplosionHack(slot)
end, mod.FF.Sourpuss.Var)

-- unfinished golem
mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, function(_, slot)
    local sprite, data = slot:GetSprite(), mod:GetEntityData(slot)

    if not data.init then
        data.DropFunc = function()
            grng:SetSeed(slot.DropSeed, 0)

            for i = 30, 360, 30 do
                local smoke = Isaac.Spawn(1000, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, slot.Position + Vector(0, 10), Vector(0,-10):Rotated(i), slot)
                smoke.SpriteOffset = Vector(0, -20)
                smoke.Color = Color(1,1,1,1,100 / 255,100 / 255,100 / 255)
                smoke:Update()
            end

            if mod:IsGolemUnlockRoom() then
                mod:TriggerGolemUnlockEvent(slot.Position)
            else
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, FiendFolio.GetGolemTrinket(),
                            slot.Position, Vector.Zero, slot)
            end
        end

        data.init = true
        slot.SplatColor = Color(1, 1, 1, 0, 0, 0, 0)
    end

    sprite:Play("Idle", false)

    FiendFolio.OverrideExplosionHack(slot)
end, mod.FF.UnfinishedGolem.Var)

-- geode golem
FiendFolio.onMachineTouch(mod.FF.GeodeGolem.Var, function(player, slot)
    local sprite, data = slot:GetSprite(), mod:GetEntityData(slot)

    if sprite:IsPlaying("Idle") then
        local trinket = FiendFolio.GetMostRecentRockTrinket(player, true)
        if trinket > 0 then
            data.TakenTrinket = trinket
            data.TakenFromPlayer = player
            player:TryRemoveTrinket(trinket)

            sfx:Play(SoundEffect.SOUND_SCAMPER, 1, 0, false, 1)

            sprite:ReplaceSpritesheet(1, ItemConfig:GetTrinket(trinket).GfxFileName)
            sprite:LoadGraphics()

            if slot.SubType == 0 then
                sprite:Play("Reward", true)
            else
                sprite:Play("Reject", true)
            end
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, function(_, slot)
    local sprite, data = slot:GetSprite(), mod:GetEntityData(slot)

    if not data.init then
        data.DropFunc = function()
            grng:SetSeed(slot.DropSeed, 0)

            for i = 30, 360, 30 do
                local smoke = Isaac.Spawn(1000, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, slot.Position + Vector(0, 10), Vector(0,-10):Rotated(i), slot)
                smoke.SpriteOffset = Vector(0, -20)
                smoke.Color = Color(1,1,1,1,100 / 255,100 / 255,100 / 255)
                smoke:Update()
            end

            if data.TakenTrinket then
                return
            end

            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, FiendFolio.GetGolemTrinket(nil, "Geode", false),
                            slot.Position, Vector.Zero, slot)
        end

        slot.FlipX = slot.Position.X > game:GetRoom():GetCenterPos().X
        data.init = true
        slot.SplatColor = Color(1, 1, 1, 0, 0, 0, 0)
    end

    if sprite:IsFinished() then
        sprite:Play("Idle", true)
    end

    local spawnOffset = Vector((slot.FlipX and -1) or 1, 0)
    local spawnPos = slot.Position + spawnOffset * 16
    if sprite:IsEventTriggered("Crush") then
        FiendFolio.CrushRockTrinket(data.TakenFromPlayer, data.TakenTrinket, slot)
    elseif sprite:IsEventTriggered("Reward") then
        slot.SubType = 1

        if FiendFolio.IsGeode(data.TakenTrinket) then
            for i = 1, 2 do
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, data.TakenTrinket,
                spawnPos, Vector.FromAngle(math.random(30, 150)) * 4, slot)
            end
        else
            for i = 1, 2 do
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, FiendFolio.GetGolemTrinket(nil, "Geode", false),
                spawnPos, Vector.FromAngle(math.random(30, 150)) * 4, slot)
            end
        end
    elseif sprite:IsEventTriggered("Reject") then
        local t = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, data.TakenTrinket,
        spawnPos, Vector.FromAngle(math.random(30, 150)) * 4, slot):ToPickup()
        t.Touched = true
    end

    FiendFolio.OverrideExplosionHack(slot)
end, mod.FF.GeodeGolem.Var)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    local room = game:GetRoom()
    if not room:IsFirstVisit() then return end

    local isAnyGolem = FiendFolio.GolemExists()
    if not isAnyGolem then return end

    local rtype = room:GetType()
    if rtype == RoomType.ROOM_SECRET or (game:IsGreedMode() and (rtype == RoomType.ROOM_SUPERSECRET or rtype == RoomType.ROOM_GREED_EXIT)) then
        -- WE GOT A SUBWAY NOW!
        --[[ spawn slot + beggar in secret room
        local pos = room:FindFreePickupSpawnPosition(room:GetGridPosition(25), 0, true)
        Isaac.Spawn(EntityType.ENTITY_SLOT, mod.FF.MiningMachine.Var, 0, pos, nilvector, nil)
        pos = room:FindFreePickupSpawnPosition(room:GetGridPosition(19), 0, true)
        Isaac.Spawn(EntityType.ENTITY_SLOT, mod.FF.BismuthBeggar.Var, 0, pos, nilvector, nil)
        pos = room:FindFreePickupSpawnPosition(room:GetGridPosition(156), 0, true)
        Isaac.Spawn(EntityType.ENTITY_SLOT, mod.FF.Sourpuss.Var, 0, pos, nilvector, nil)]]

        -- spawn a golem trinket in the not super secret just normal secret room
        local trinket = FiendFolio.GetGolemTrinket()
        local pos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 0, false)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, trinket, pos, nilvector, nil)
    --elseif rtype == RoomType.ROOM_SUPERSECRET then
    end
end)

local lastGolemBossRemovedPos
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    if lastGolemBossRemovedPos then
        local room = game:GetRoom()
        if room:GetType() == RoomType.ROOM_BOSS and room:GetFrameCount() > 0 then
            local bossCount = 0
            for _, entity in ipairs(Isaac.GetRoomEntities()) do
                if entity:ToNPC() and entity:IsBoss() then
                    bossCount = bossCount + 1
                end
            end

            if bossCount == 0 then
                local trinket = FiendFolio.GetGolemTrinket()
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, trinket, lastGolemBossRemovedPos, RandomVector() * 2, nil)
            end
        end

        lastGolemBossRemovedPos = nil
    end

    for _, player in ipairs(PlayerManager.GetPlayers()) do
        local data = mod:GetEntityData(player).ffsavedata
        if not data then return end

        if not data.RunEffects.Trinkets.SpikeRockDmg and player:HasTrinket(FiendFolio.ITEM.ROCK.SPIKED_ROCK) and player:IsItemQueueEmpty() then
            player:TakeDamage(1, DamageFlag.DAMAGE_NOKILL | DamageFlag.DAMAGE_SPIKES | DamageFlag.DAMAGE_INVINCIBLE, EntityRef(player), 0)
            data.RunEffects.Trinkets.SpikeRockDmg = true
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, entity)
    local npc = entity:ToNPC()
    if not npc or not npc:IsBoss() or not FiendFolio.GolemExists() then return end

    local room = game:GetRoom()
    if room:GetType() == RoomType.ROOM_BOSS and room:GetFrameCount() > 0 then
        lastGolemBossRemovedPos = entity.Position
    end
end)

-- Returns any flags applied to the trinket ID, such as TrinketType.TRINKET_GOLDEN_FLAG
-- Normally TrinketType.TRINKET_GOLDEN_FLAG is the only one, but now there is at least one mod that adds more
function mod:GetTrinketFlags(id)
	return id & ~TrinketType.TRINKET_ID_MASK
end

-- Strips away any flags like TrinketType.TRINKET_GOLDEN_FLAG that might be present on the trinket ID
-- Normally just removes TrinketType.TRINKET_GOLDEN_FLAG but there is now at least one mod that adds trinket flags
function mod:GetRealTrinketId(id)
	return id & TrinketType.TRINKET_ID_MASK
end

function mod:IsGoldTrinket(id)
	if id & TrinketType.TRINKET_GOLDEN_FLAG ~= 0 then
		return true
	else
		return false
	end
end

------------------------------------------------------------------------------
-- Code for holding rocks above Golem's head when near a machine that will
-- consume a rock trinket, to visually show which one will be consumed.
------------------------------------------------------------------------------

-- Distance from rock-crushing machines that will trigger the holding up animation.
local holdUpRockRange = 100

-- Detects when a player is near an appropriate machine.
function mod:DetectNearbyPlayerWithRock(slot)
	local anim = slot:GetSprite():GetAnimation()

	for i=0, game:GetNumPlayers()-1 do
		local player = game:GetPlayer(i)
		local data = mod:GetEntityData(player)

		if player and player:Exists() then
			local trinket
            if slot.Variant == mod.FF.Midarizer.Var then
                trinket = FiendFolio.GetMostRecentRockTrinket(player, nil, true)
            else
                trinket = FiendFolio.GetMostRecentRockTrinket(player)
            end
			local price = FiendFolio.GetGrindPriceForTrinket(trinket, player)

			local smeltprice = 3
			if mod.BolemExists() then
				smeltprice = 2
			end

			local shouldHoldUpRockTrinket = trinket > 0
					and (data.holdingUpRockTouchingPickup or 0) == 0
					and not player:IsHoldingItem()
					and (anim == 'Idle' or anim == 'IdleRandom' or anim == 'IdleB' or anim == 'IdleRandomB')
					and player.Position:Distance(slot.Position) < holdUpRockRange
					and player:GetShootingInput():Length() < 0.1
					and not (slot.Variant == mod.FF.MiningMachine.Var and player:GetNumCoins() < price)
					and not (slot.Variant == mod.FF.Sourpuss.Var and player:GetSoulHearts() < 2)
                    and not (slot.Variant == mod.FF.Midarizer.Var and player:GetNumCoins() < 10)

			if not data.nearbyRockCrushers then
				data.nearbyRockCrushers = {}
			end

			if shouldHoldUpRockTrinket then
				if not next(data.nearbyRockCrushers) then
					data.doHoldUpRockBounce = true
				end
				data.nearbyRockCrushers[slot.InitSeed] = slot
			else
				data.nearbyRockCrushers[slot.InitSeed] = nil
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, mod.DetectNearbyPlayerWithRock, mod.FF.MiningMachine.Var)
mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, mod.DetectNearbyPlayerWithRock, mod.FF.BismuthBeggar.Var)
mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, mod.DetectNearbyPlayerWithRock, mod.FF.Sourpuss.Var)
mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, mod.DetectNearbyPlayerWithRock, mod.FF.GeodeGolem.Var)
mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, mod.DetectNearbyPlayerWithRock, mod.FF.Midarizer.Var)
mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, mod.DetectNearbyPlayerWithRock, mod.FF.Sweetpuss.Var)

-- Disables holding up rocks while touching pickups.
function mod:HoldingUpRocksDetectPickupCollision(pickup, player)
	if not player or not player:ToPlayer() then return end
	mod:GetEntityData(player).holdingUpRockTouchingPickup = 2
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.HoldingUpRocksDetectPickupCollision, PickupVariant.PICKUP_TRINKET)
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.HoldingUpRocksDetectPickupCollision, PickupVariant.PICKUP_TAROTCARD)
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.HoldingUpRocksDetectPickupCollision, PickupVariant.PICKUP_COLLECTIBLE)
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.HoldingUpRocksDetectPickupCollision, PickupVariant.PICKUP_PILL)

-- Handles the little bounce animation when the player starts holding up a rock.
local holdUpRockBounceX = 0.25
local holdUpRockBounceY = 0.25
local holdUpRockBounceDuration = 5

local function HandleHoldUpRockBounce(player, data)
	if not data.doHoldUpRockBounce then return end

	if not data.holdUpRockBounceOriginalScale then
		data.holdUpRockBounceOriginalScale = player.SpriteScale
	end

	data.holdUpRockBounceTime = (data.holdUpRockBounceTime or 0) + 1

	local n = data.holdUpRockBounceTime / holdUpRockBounceDuration

	local xMult = (holdUpRockBounceX * math.sin(2 * math.pi * n) + 1)
	local yMult = (-holdUpRockBounceY * math.sin(2 * math.pi * n) + 1)

	data.holdUpRockBounce = Vector(xMult, yMult)

	local x = data.holdUpRockBounceOriginalScale.X * xMult
	local y = data.holdUpRockBounceOriginalScale.Y * yMult

	player.SpriteScale = Vector(x, y)

	if n >= 1 then
		player:AddCacheFlags(CacheFlag.CACHE_SIZE, true)
		data.doHoldUpRockBounce = false
		data.holdUpRockBounceOriginalScale = nil
		data.holdUpRockBounceTime = nil
		data.holdUpRockBounce = nil
	end
end

-- Handles the animation of holding a rock trinket above the head.
local RelevantAnims = {
	[Direction.NO_DIRECTION] = { Walk = "PickupWalkDown", Head = "HeadDown" },
	[Direction.UP] = { Walk = "PickupWalkUp", Head = "HeadUp" },
	[Direction.DOWN] = { Walk = "PickupWalkDown", Head = "HeadDown" },
	[Direction.LEFT] = { Walk = "PickupWalkLeft", Head = "HeadLeft" },
	[Direction.RIGHT] = { Walk = "PickupWalkRight", Head = "HeadRight" },
}

function mod:HoldUpTrinket(player, data)
	local sprite = player:GetSprite()

	if data.holdingUpRockTouchingPickup and data.holdingUpRockTouchingPickup > 0 then
		data.holdingUpRockTouchingPickup = data.holdingUpRockTouchingPickup - 1
	end

	HandleHoldUpRockBounce(player, data)

	if player:IsHoldingItem() then
		data.isHoldingUpRockTrinket = false
		return
	end

	if data.nearbyRockCrushers then
		for k, v in pairs(data.nearbyRockCrushers) do
			if not v:Exists() then
				data.nearbyRockCrushers[k] = nil
			end
		end
	end

	if data.nearbyRockCrushers and next(data.nearbyRockCrushers) then
		local dir = player:GetMovementDirection()
		local anim = RelevantAnims[dir].Walk
		if dir == Direction.NO_DIRECTION or not sprite:IsPlaying(anim) then
			player:PlayExtraAnimation(anim)
		end
		data.isHoldingUpRockTrinket = true
	elseif data.isHoldingUpRockTrinket then
		local dir = player:GetMovementDirection()
		sprite:PlayOverlay(RelevantAnims[dir].Head)
		player:StopExtraAnimation()
		data.isHoldingUpRockTrinket = false
		if game:GetRoom():GetFrameCount() > 1 then
			data.doHoldUpRockBounce = true
		end
	end
end

-- For rendering the sprite of the rock trinket above the player's head.
--local heldUpRockDummyGoldenTrinket
local heldUpRockTrinketSprite = Sprite()
heldUpRockTrinketSprite:Load("gfx/005.350_trinket.anm2", true)
heldUpRockTrinketSprite:Play("Idle", true)
local currentHeldUpRock = 0

local function GetHeldUpRockSprite(trinket, playerType)
	-- Dummy entity no longer needed to utilize the gold shader, thanks to REPENTOGON
	--[[
	if mod:IsGoldTrinket(trinket) then
		if heldUpRockDummyGoldenTrinket and heldUpRockDummyGoldenTrinket.SubType ~= trinket then
			heldUpRockDummyGoldenTrinket:Remove()
			heldUpRockDummyGoldenTrinket = nil
		end

		if not heldUpRockDummyGoldenTrinket or not heldUpRockDummyGoldenTrinket:Exists() then
			heldUpRockDummyGoldenTrinket = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, trinket, nilvector, nilvector, nil):ToPickup()
			heldUpRockDummyGoldenTrinket.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			mod:GetEntityData(heldUpRockDummyGoldenTrinket).isDummyForHeldUpGolemRock = true
			heldUpRockDummyGoldenTrinket:GetSprite():Play("Idle", true)
			heldUpRockDummyGoldenTrinket:AddEntityFlags(EntityFlag.FLAG_NO_QUERY)
			heldUpRockDummyGoldenTrinket.Visible = false

			currentHeldUpRock = trinket
		end

		heldUpRockDummyGoldenTrinket.Timeout = 5
		return heldUpRockDummyGoldenTrinket:GetSprite()
	end
	]]

	if trinket ~= currentHeldUpRock then
		local gfx = Isaac.GetItemConfig():GetTrinket(trinket).GfxFileName
		if BirthcakeRebaked and trinket == BirthcakeRebaked.Birthcake.ID then
			local useDefaultSprite = BirthcakeRebaked.GetSetting(BirthcakeRebaked.Setting.UniqueSprite) == false
			local player = Isaac.GetPlayer()
			local spriteConfig = BirthcakeRebaked.BirthcakeSprite[playerType]
			local trinketPath = "gfx/items/trinkets/"
			gfx = trinketPath .. "0_isaac_birthcake.png"

			if not useDefaultSprite then
				if spriteConfig then
					if spriteConfig.PickupSpritePath then
						gfx = spriteConfig.PickupSpritePath
					elseif spriteConfig.SpritePath then
						gfx = spriteConfig.SpritePath
					end
				end
				if not spriteConfig and Birthcake.BirthcakeDescs[playerType] then
					gfx = trinketPath .. player:GetName():lower() .. "_birthcake.png"
				end
			end
		end
		heldUpRockTrinketSprite:ReplaceSpritesheet(0, gfx)
		heldUpRockTrinketSprite:LoadGraphics()

		if mod:IsGoldTrinket(trinket) then
			heldUpRockTrinketSprite:SetRenderFlags(heldUpRockTrinketSprite:GetRenderFlags() | AnimRenderFlags.GOLDEN)
		else
			heldUpRockTrinketSprite:SetRenderFlags(heldUpRockTrinketSprite:GetRenderFlags() & ~AnimRenderFlags.GOLDEN)
		end

		currentHeldUpRock = trinket
	end

	return heldUpRockTrinketSprite
end

-- Cancel the animation if you somehow leave the room while it's happening
-- This can occur in super niche scenarios like holding up a rock during the Dad's Note transition
function mod:GolemHoldUpRockFailsafe(player, data)
    if data.isHoldingUpRockTrinket then
	    local sprite = player:GetSprite()
        local dir = player:GetMovementDirection()
		sprite:PlayOverlay(RelevantAnims[dir].Head)

		player:StopExtraAnimation()
		data.isHoldingUpRockTrinket = false
		if game:GetRoom():GetFrameCount() > 1 then
			data.doHoldUpRockBounce = true
		end
	end
end

--[[
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
	if mod:GetEntityData(pickup).isDummyForHeldUpGolemRock then
		pickup.Position = nilvector
		pickup.Visible = false
	end
end)
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup)
	if mod:GetEntityData(pickup).isDummyForHeldUpGolemRock then
		return true
	end
end)
]]

local heldUpRockOffset = Vector(0, 43)

local function RenderRockHeldAboveHead(player)
	local data = mod:GetEntityData(player)
	local trinket, slot = FiendFolio.GetMostRecentRockTrinket(player)

	if data.isHoldingUpRockTrinket and trinket > 0 then
		local sprite = GetHeldUpRockSprite(trinket, player:GetPlayerType())

		if data.holdUpRockBounce then
			sprite.Scale = data.holdUpRockBounce
		else
			sprite.Scale = Vector.One
		end

		local offset = heldUpRockOffset * player.SpriteScale.Y
		local pos = Isaac.WorldToScreen(player.Position - offset)

		if mod:IsPlayerTrinketBlasphemous(player, slot) then
			if not mod:HasBlasphemousShader(sprite) then
				mod:AddBlasphemousShader(sprite)
			end
			mod:PreRenderBlasphemousShader(sprite, pos)
		elseif mod:HasBlasphemousShader(sprite) then
			mod:RemoveBlasphemousShader(sprite)
		end

		sprite:Render(pos, nilvector, nilvector)
	else
		currentHeldUpRock = 0
	end
end

-- Using MC_POST_RENDER instead of MC_POST_PLAYER_RENDER so that rocks render above most other things, like grimlins.
mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
	for i=0, game:GetNumPlayers()-1 do
		local player = game:GetPlayer(i)

		if player and player:Exists() then
			RenderRockHeldAboveHead(player)
		end
	end
end)

mod:AddCallback("FF_PLAYER_HURT_SOUND", function()
    sfx:Play(mod.Sounds.GolemHurt, 1, 0, false, 1)
    return true
end, mod.PLAYER.GOLEM)

mod:AddCallback("FF_PLAYER_HURT_SOUND", function()
    sfx:Play(mod.Sounds.GolemHurt, 1, 0, false, 1)
    return true
end, mod.PLAYER.BOLEM)

mod:AddCallback("FF_PLAYER_DEATH_SOUND", function()
    sfx:Stop(mod.Sounds.GolemHurt)
    sfx:Play(mod.Sounds.GolemDeath, 0.8, 0, false, 1)
    return true
end, mod.PLAYER.GOLEM)

mod:AddCallback("FF_PLAYER_DEATH_SOUND", function()
    sfx:Stop(mod.Sounds.GolemHurt)
    sfx:Play(mod.Sounds.GolemDeath, 0.8, 0, false, 1)
    return true
end, mod.PLAYER.BOLEM)