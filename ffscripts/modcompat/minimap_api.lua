local mod = FiendFolio
local game = Game()

--Unimplemented currently
--ffcandyhearthalf
--ffstonecoin
--ffcopperbombdud --Don't want to add this anyway
--ffrisksrewardportalroom

--MINIMAP API COMPAT
if MinimapAPI then
	mod.MinimapAPISprite = Sprite()
	mod.MinimapAPISprite:Load("gfx/ui/minimapapi/icons_ff.anm2", true)

	local function isCanTripped()
		return MinimapAPI.isRepentance and Isaac.GetChallenge() == Challenge.CHALLENGE_CANTRIPPED
	end

    local function isShopChestActive(p)
        return (p.SubType == 1 or p.SubType == 2)
    end

    local function roomIs(roomEnum)
        return (game:GetRoom():GetType() == roomEnum)
    end

    local function engineChargeIs(p, num)
        local chestseed = tostring(p.InitSeed)
        local d = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'ChestData', chestseed, {})
        if d.Charges then
            return d.Charges == num
        end
    end

    local function engineChestChargeIsOne(p)
        return engineChargeIs(p, 1)
    end

    local function engineChestChargeIsTwo(p)
        return engineChargeIs(p, 2)
    end

    local function redRibbonTwo(p)
        return mod.getTrinketMultiplierAcrossAllPlayers(mod.ITEM.TRINKET.RED_RIBBON) > 1
    end

    local function redRibbonOne(p)
        return mod.getTrinketMultiplierAcrossAllPlayers(mod.ITEM.TRINKET.RED_RIBBON) == 1
    end

    local itemConfig = Isaac.GetItemConfig()

    local ADDITIONAL_WEIGHTS = {
        HORSE = 9050
    }

    local GROUPS = {
        {
            ID = "hearts",
            Anim = "Hearts",
            Weight = 15000,
            Var = PickupVariant.PICKUP_HEART,
        },
        {
            ID = "coins",
            Anim = "Coins",
            Weight = 5000,
            Var = PickupVariant.PICKUP_COIN
        },
        {
            ID = "keys",
            Anim = "Keys",
            Weight = 8000,
            Var = PickupVariant.PICKUP_KEY
        },
        --[[{
            ID = "ffkeys",
            Anim = "Keys",
            Weight = 10501,
            Var = mod.PICKUP.KEY.PUZZLE_KEY
        },]]
        {
            ID = "bombs",
            Anim = "Bombs",
            Weight = 7000,
            Var = PickupVariant.PICKUP_BOMB
        },
        {
            ID = "batteries",
            Anim = "Batteries",
            Weight = 4000,
            Var = PickupVariant.PICKUP_LIL_BATTERY
        },
        {
            ID = "ffbatteries",
            Anim = "Batteries",
            Weight = 10250,
            Var = PickupVariant.PICKUP_TAROTCARD,
            Sub = -1,
            CardBack = 1,
        },
        {
            ID = "chests", --Includes sacks
            Anim = "Chests",
            Weight = 12000,
            Var = PickupVariant.PICKUP_CHEST
        },
        {
            ID = "pills",
            Anim = "Pills",
            Weight = 9001,
            Var = PickupVariant.PICKUP_PILL
        },
        {
            ID = "cards",
            Anim = "Cards",
            Weight = 10000,
            Var = PickupVariant.PICKUP_TAROTCARD,
            Sub = -1,
            CardBack = 1,
        },
        {
            ID = "runes",
            Anim = "Runes",
            Weight = 11000,
            Var = PickupVariant.PICKUP_TAROTCARD,
            Sub = -1,
            CardBack = 1,
        },
        {
            ID = "ffobjects",
            Anim = "Objects",
            Weight = 10500,
            Var = PickupVariant.PICKUP_TAROTCARD,
            Sub = -1,
            CardBack = 1,
        },
        {
            ID = "ffdice",
            Anim = "GlassDice",
            Weight = 10500,
            Var = PickupVariant.PICKUP_TAROTCARD,
            Sub = -1,
            CardBack = 1,
        },
        {
            ID = "ffdiscs",
            Anim = "Discs",
            Weight = 10500,
            Var = PickupVariant.PICKUP_TAROTCARD,
            Sub = -1,
            CardBack = 1,
        },
        {
            ID = "beggars",
            Anim = "Beggars",
            Weight = 3000,
            Type = EntityType.ENTITY_SLOT,
            Func = MinimapAPI.PickupSlotMachineNotBroken,
        },
        {
            ID = "slots",
            Anim = "Slots",
            Weight = 2000,
            Type = EntityType.ENTITY_SLOT,
            Func = MinimapAPI.PickupSlotMachineNotBroken,
        },
        {
            ID = "ffstuff",
            Anim = "Other",
        },
    }

    local iconsTable = {
     ["hearts"] = {
        {
            ID = "ffimmoralheart",
            Var = mod.PICKUP.VARIANT.IMMORAL_HEART,
            Frame = 0,
            Weight = 15550,
        },
        {
            ID = "ffimmoralhearthalf",
            Var = mod.PICKUP.VARIANT.HALF_IMMORAL_HEART,
            Frame = 1,
            Weight = 15545,
        },
        {
            ID = "ffimmolraheartblended",
            Var = mod.PICKUP.VARIANT.BLENDED_IMMORAL_HEART,
            Frame = 2,
            Weight = 15575,
        },
        {
            ID = "ffblackhearthalf",
            Var = mod.PICKUP.VARIANT.HALF_BLACK_HEART,
            Frame = 3,
            Weight = 15599,
        },
        {
            ID = "ffblackheartblended",
            Var = mod.PICKUP.VARIANT.BLENDED_BLACK_HEART,
            Frame = 4,
            Weight = 15650,
        },
        {
            ID = "ffmorbidheartfull",
            Var = mod.PICKUP.VARIANT.MORBID_HEART,
            Frame = 7,
            Weight = 15250,
        },
        {
            ID = "ffmorbidhearttwothirds",
            Var = mod.PICKUP.VARIANT.TWOTHIRDS_MORBID_HEART,
            Frame = 8,
            Weight = 15240,
        },
        {
            ID = "ffmorbidheartthird",
            Var = mod.PICKUP.VARIANT.THIRD_MORBID_HEART,
            Frame = 9,
            Weight = 15230,
        },
        {
            ID = "fffoolsgoldheart",
            Var = mod.PICKUP.VARIANT.FOOLS_GOLD_HEART,
            Frame = 10,
            Weight = 15900,
        },
        {
            ID = "ffsoulshard",
            Var = mod.PICKUP.VARIANT.SOUL_SHARD,
            Frame = 11,
            Weight = 16500,
        },
        {
            ID = "ffstevenheart",
            Var = mod.PICKUP.VARIANT.STEVEN_HEART,
            Frame = 12,
            Weight = 15300,
        },
        {
            ID = "ffbombheart",
            Var = mod.PICKUP.VARIANT.BOMB_HEART,
            Frame = 12,
            Weight = 15500,
        },
        {
            ID = "fffulleternalheart",
            Sub = HeartSubType.HEART_ETERNAL,
            Frame = 5,
            Weight = 16000,
            CondFunc = redRibbonOne
        },
        {
            ID = "ffdoubleeternalheart",
            Sub = HeartSubType.HEART_ETERNAL,
            Frame = 6,
            Weight = 16100,
            CondFunc = redRibbonTwo
        },
     },
     ["coins"] = {
        {
            ID = "ffcursecoin",
            Sub = mod.PICKUP.COIN.CURSED,
            Frame = 0,
            Weight = 5005
        },
        {
            ID = "ffhauntedpenny",
            Sub = mod.PICKUP.COIN.HAUNTED,
            Frame = 3,
            Weight = 5020
        },
        {
            ID = "ffhoneypenny",
            Sub = mod.PICKUP.COIN.HONEY,
            Frame = 4,
            Weight = 5010
        },
        {
            ID = "ffgoldencursedpenny",
            Sub = mod.PICKUP.COIN.GOLDENCURSED,
            Frame = 1,
            Weight = 5290
        },
        {
            ID = "ffstudcoin",
            Sub = mod.PICKUP.COIN.LEGOSTUD,
            Frame = 6,
            Weight = 5010
        },
        {
            ID = "ffmedleypenny",
            Sub = mod.PICKUP.COIN.MEDLEY,
            Frame = 9,
            Weight = 5999
        },
        {
            ID = "ffmedleypennysticky",
            Sub = mod.PICKUP.COIN.MEDLEY_STICKY,
            IconID = "ffmedleypenny",
            Weight = 5999,
            NoIcon = true
        },
        {
            ID = "ffplatinumpenny",
            Sub = mod.PICKUP.COIN.PLATINUM,
            Frame = 5,
            Weight = 5500
        },
        {
            ID = "ffsmallcoin",
            Sub = mod.PICKUP.COIN.LIL_PENNY,
            Frame = 2,
            Weight = 5001
        },
        {
            ID = "fftoken",
            Var = mod.PICKUP.VARIANT.TOKEN,
            Frame = 7,
            Group = "fftoken",
            Weight = 20000
        },
     },
     ["keys"] = {
        {
            ID = "ffspicy2",
            Sub = mod.PICKUP.KEY.SPICY,
            Frame = 0,
            Weight = 8049,
        },
        {
            ID = "ffspicy2perma",
            IconID = "ffspicy2",
            Sub = mod.PICKUP.KEY.SPICY_PERM,
            Weight = 8049,
            NoIcon = true,
        },
        {
            ID = "ffspicychargedkeydouble",
            Sub = mod.PICKUP.KEY.CHARGEDSPICY,
            Frame = 3,
            Weight = 8250,
        },
        {
            ID = "ffspicychargedkeydoubleperma",
            IconID = "ffspicychargedkeydouble",
            Sub = mod.PICKUP.KEY.CHARGEDSPICY_PERM,
            Weight = 8250,
            NoIcon = true,
        },
        {
            ID = "ffspicy3",
            Sub = mod.PICKUP.KEY.SUPERSPICY,
            Frame = 1,
            Weight = 8085,
        },
        {
            ID = "ffspicy3box",
            IconID = "ffspicy3",
            Sub = mod.PICKUP.KEY.SPICY_BOX,
            Weight = 8085,
            NoIcon = true,
        },
        {
            ID = "ffspicy3perma",
            IconID = "ffspicy3",
            Sub = mod.PICKUP.KEY.SUPERSPICY_PERM,
            Weight = 8085,
            NoIcon = true,
        },
        {
            ID = "ffspicychargedkeytriple",
            Sub = mod.PICKUP.KEY.CHARGEDSPICY_BOX,
            Frame = 4,
            Weight = 8350,
        },
        {
            ID = "ffspicy4",
            Sub = mod.PICKUP.KEY.SUPERSPICY_BOX,
            Frame = 2,
            Weight = 8090,
        },
     },
     --[[["ffkeys"] = {
        {
            ID = "ffredkey",
            Sub = mod.PICKUP.KEY.RED,
            Frame = 5,
            Weight = 9000,
        },
        {
            ID = "ffbluekey",
            Sub = mod.PICKUP.KEY.BLUE,
            Frame = 6,
            Weight = 9010,
        },
        {
            ID = "ffgreenkey",
            Sub = mod.PICKUP.KEY.GREEN,
            Frame = 7,
            Weight = 9020,
        },
        {
            ID = "ffbosskey",
            Var = mod.PICKUP.VARIANT.GATECURSE_KEY,
            Frame = 9,
            Weight = 9050,
        },
     },]]
     ["bombs"] = {
        {
            ID = "ffcopperbombpickup",
            Sub = mod.PICKUP.BOMB.COPPER,
            Frame = 0,
            Weight = 7025,
        },
        {
            ID = "ffcopperbombblended",
            Sub = mod.PICKUP.BOMB.MIXED_DOUBLE,
            Frame = 2,
            Weight = 7090,
        },
        {
            ID = "ffcopperbombdouble",
            Sub = mod.PICKUP.BOMB.DOUBLE_COPPER,
            Frame = 3,
            Weight = 7095,
        },
     },
     ["batteries"] = {
        {
            ID = "ffbatterypotato",
            Var = mod.PICKUP.VARIANT.POTATO_BATTERY,
            Frame = 8,
            Weight = 3900,
        },
        {
            ID = "ffcursedbattery",
            Var = mod.PICKUP.VARIANT.CURSED_BATTERY,
            Frame = 9,
            Weight = 4050,
        },
        {
            ID = "ffbatteryexcelsior",
            Var = mod.PICKUP.VARIANT.FIREWORK_BATTERY,
            Frame = 10,
            Weight = 4060,
        },
        {
            ID = "ffbatteryholy",
            Var = mod.PICKUP.VARIANT.VIRTUOUS_BATTERY,
            Frame = 11,
            Weight = 4070,
        },
     },
     ["ffbatteries"] = {
        {
            ID = "ffstoragebattery0",
            CardBack = mod.PICKUP.CARDBACK.STORAGE_BATTERY_0,
            Frame = 0,
        },
        {
            ID = "ffstoragebattery1",
            CardBack = mod.PICKUP.CARDBACK.STORAGE_BATTERY_1,
            Frame = 1,
        },
        {
            ID = "ffstoragebattery2",
            CardBack = mod.PICKUP.CARDBACK.STORAGE_BATTERY_2,
            Frame = 2,
        },
        {
            ID = "ffstoragebattery3",
            CardBack = mod.PICKUP.CARDBACK.STORAGE_BATTERY_3,
            Frame = 3,
        },
        {
            ID = "ffcorrodedbattery0",
            CardBack = mod.PICKUP.CARDBACK.CORRODED_BATTERY_0,
            Frame = 4,
        },
        {
            ID = "ffcorrodedbattery1",
            CardBack = mod.PICKUP.CARDBACK.CORRODED_BATTERY_1,
            Frame = 5,
        },
        {
            ID = "ffcorrodedbattery2",
            CardBack = mod.PICKUP.CARDBACK.CORRODED_BATTERY_2,
            Frame = 6,
        },
        {
            ID = "ffcorrodedbattery3",
            CardBack = mod.PICKUP.CARDBACK.CORRODED_BATTERY_3,
            Frame = 7,
        },
     },
     ["chests"] = {
        {
            ID = "ffcursedchest",
            Var = mod.PICKUP.VARIANT.DIRE_CHEST,
            Frame = 1,
            Weight = 12650,
            Func = function (p) return p.SubType == 0 end
        },
        {
            ID = "ffshopchestclosed",
            Var = mod.PICKUP.VARIANT.SHOP_CHEST,
            Sub = 0,
            Frame = 0,
            Weight = 12850,
            CondFunc = function (p) return p.SubType == 0 end
        },
        {
            ID = "ffshopchestopenregular",
            Var = mod.PICKUP.VARIANT.SHOP_CHEST,
            Sub = -1,
            Anim = "Beggars",
            Frame = 17,
            Weight = 12855,
            CondFunc = isShopChestActive,
        },
        {
            ID = "ffshopchestopenangel",
            Var = mod.PICKUP.VARIANT.SHOP_CHEST,
            Sub = -1,
            Anim = "Beggars",
            Frame = 18,
            Weight = 12860,
            CondFunc = isShopChestActive,
            RoomCheck = RoomType.ROOM_ANGEL
        },
        {
            ID = "ffshopchestopenblackmarket",
            Var = mod.PICKUP.VARIANT.SHOP_CHEST,
            Sub = -1,
            Anim = "Beggars",
            Frame = 19,
            Weight = 12860,
            CondFunc = isShopChestActive,
            RoomCheck = RoomType.ROOM_BLACK_MARKET
        },
        {
            ID = "ffshopchestopenboss",
            Var = mod.PICKUP.VARIANT.SHOP_CHEST,
            Sub = -1,
            Anim = "Beggars",
            Frame = 20,
            Weight = 12860,
            CondFunc = isShopChestActive,
            RoomCheck = RoomType.ROOM_BOSS
        },
        {
            ID = "ffshopchestopenchest",
            Var = mod.PICKUP.VARIANT.SHOP_CHEST,
            Sub = -1,
            Anim = "Beggars",
            Frame = 21,
            Weight = 12860,
            CondFunc = isShopChestActive,
            RoomCheck = RoomType.ROOM_CHEST
        },
        {
            ID = "ffshopchestopendevil",
            Var = mod.PICKUP.VARIANT.SHOP_CHEST,
            Sub = -1,
            Anim = "Beggars",
            Frame = 22,
            Weight = 12860,
            CondFunc = isShopChestActive,
            RoomCheck = RoomType.ROOM_DEVIL
        },
        {
            ID = "ffshopchestopenlibrary",
            Var = mod.PICKUP.VARIANT.SHOP_CHEST,
            Sub = -1,
            Anim = "Beggars",
            Frame = 23,
            Weight = 12860,
            CondFunc = isShopChestActive,
            RoomCheck = RoomType.ROOM_LIBRARY
        },
        {
            ID = "ffshopchestopenplanetarium",
            Var = mod.PICKUP.VARIANT.SHOP_CHEST,
            Sub = -1,
            Anim = "Beggars",
            Frame = 24,
            Weight = 12860,
            CondFunc = isShopChestActive,
            RoomCheck = RoomType.ROOM_PLANETARIUM
        },
        {
            ID = "ffshopchestopensecret",
            Var = mod.PICKUP.VARIANT.SHOP_CHEST,
            Sub = -1,
            Anim = "Beggars",
            Frame = 25,
            Weight = 12860,
            CondFunc = isShopChestActive,
            RoomCheck = RoomType.ROOM_SECRET
        },
        {
            ID = "ffshopchestopenshop",
            Var = mod.PICKUP.VARIANT.SHOP_CHEST,
            Sub = -1,
            Anim = "Beggars",
            Frame = 26,
            Weight = 12860,
            CondFunc = isShopChestActive,
            RoomCheck = RoomType.ROOM_SHOP
        },
        {
            ID = "ffshopchestopenultrasecret",
            Var = mod.PICKUP.VARIANT.SHOP_CHEST,
            Sub = -1,
            Anim = "Beggars",
            Frame = 27,
            Weight = 12860,
            CondFunc = isShopChestActive,
            RoomCheck = RoomType.ROOM_ULTRASECRET
        },
        {
            ID = "ffenginechest0",
            Var = mod.PICKUP.VARIANT.ENGINE_CHEST,
            Frame = 2,
            Weight = 12450,
            Func = function (p) return p.SubType == 0 end
        },
        {
            ID = "ffenginechest1",
            Var = mod.PICKUP.VARIANT.ENGINE_CHEST,
            Frame = 3,
            Weight = 12450,
            CondFunc = engineChestChargeIsOne,
            Func = function (p) return p.SubType == 0 end
        },
        {
            ID = "ffenginechest2",
            Var = mod.PICKUP.VARIANT.ENGINE_CHEST,
            Frame = 4,
            Weight = 12450,
            CondFunc = engineChestChargeIsTwo,
            Func = function (p) return p.SubType == 0 end
        },
        {
            ID = "ffglasschest",
            Var = mod.PICKUP.VARIANT.GLASS_CHEST,
            Frame = 6,
            Weight = 12870,
            Func = function (p) return p.SubType == 0 end
        },
        {
            ID = "ffgimickogift",
            Var = mod.PICKUP.VARIANT.UTILITY_POLE_BOX,
            Frame = 8,
            Weight = 12999,
            Func = function (p) return p.SubType == 0 end
        },
        --[[{
            ID = "ffpizzabox",
            Type = mod.FF.PizzaBox.ID,
            Var = mod.FF.PizzaBox.Var,
            Sub = mod.FF.PizzaBox.Sub,
            Frame = 9,
        },]]
        {
            ID = "ffbloodbag",
            Var = mod.PICKUP.VARIANT.FFSACK,
            Sub = mod.PICKUP.SACK.BLOOD,
            Anim = "Sacks",
            Frame = 0,
            Weight = 12250,
        },
        {
            ID = "fftrashbag",
            Var = mod.PICKUP.VARIANT.FFSACK,
            Sub = mod.PICKUP.SACK.TRASH,
            Anim = "Sacks",
            Frame = 3,
            Weight = 12251,
        },
        {
            ID = "ff52deck",
            Var = mod.PICKUP.VARIANT.FFSACK,
            Sub = mod.PICKUP.SACK.DECK_52,
            Anim = "Sacks",
            Frame = 4,
            Weight = 12252,
        },
        {
            ID = "ffpotatosack",
            Var = mod.PICKUP.VARIANT.FFSACK,
            Sub = mod.PICKUP.SACK.POTATO_SACK,
            Anim = "Sacks",
            Frame = 5,
            Weight = 12253,
        },
        {
            ID = "ffdrugbaggie",
            Var = mod.PICKUP.VARIANT.FFSACK,
            Sub = mod.PICKUP.SACK.DRUG_BAGGIE,
            Anim = "Sacks",
            Frame = 1,
            Weight = 12249,
        },
     },
     ["pills"] = {
        {
            ID = "ffpillblackpurple",
            Frame = 0,
            Sub = mod.PICKUP.PILLCOLOR.BLACKPURPLE,
        },
        {
            ID = "ffpillpurpleorange",
            Frame = 1,
            Sub = mod.PICKUP.PILLCOLOR.PURPLEORANGE,
        },
        {
            ID = "ffpillsimpsons",
            Frame = 2,
            Sub = mod.PICKUP.PILLCOLOR.BLUEYELLOW,
        },
        {
            ID = "ffpillbluegray",
            Frame = 3,
            Sub = mod.PICKUP.PILLCOLOR.BLUESILVER,
        },
        {
            ID = "ffpillpurplesprinkles",
            Frame = 4,
            Sub = mod.PICKUP.PILLCOLOR.DOTSVIOLET,
        },
        {
            ID = "ffpillsalmonblack",
            Frame = 5,
            Sub = mod.PICKUP.PILLCOLOR.MAROONSHADOW,
        },
        {
            ID = "ffpillgreensprinkles",
            Frame = 6,
            Sub = mod.PICKUP.PILLCOLOR.DOTSLIME,
        },
        {
            ID = "ffpillbluewhite",
            Frame = 7,
            Sub = mod.PICKUP.PILLCOLOR.EMERALDBEIGE,
        },
        {
            ID = "ffpillfullblack",
            Frame = 8,
            Sub = mod.PICKUP.PILLCOLOR.BLACKBLACK,
        },
        {
            ID = "ffpillblueblacksprinkles",
            Frame = 9,
            Sub = mod.PICKUP.PILLCOLOR.DOTSBLUE,
        },
        {
            ID = "ffpillwhitepurple",
            Frame = 10,
            Sub = mod.PICKUP.PILLCOLOR.IVORYBYZANTIUM,
        },
        {
            ID = "ffpilbronzeburgundy",
            Frame = 11,
            Sub = mod.PICKUP.PILLCOLOR.REDRED,
        },
        {
            ID = "ffpillmissingtexture",
            Frame = 12,
            Sub = mod.PICKUP.PILLCOLOR.DOTSPINK,
        },
        {
            ID = "ffpillwhiteyellow",
            Frame = 13,
            Sub = mod.PICKUP.PILLCOLOR.WHITEORANGE,
        },
        {
            ID = "ffpillblacksprinkles",
            Frame = 14,
            Sub = mod.PICKUP.PILLCOLOR.DOTSBLACK,
        },
        {
            ID = "ffpillgraycolourfulsprinkles",
            Frame = 15,
            Sub = mod.PICKUP.PILLCOLOR.RAINBOWGREY,
        },
        {
            ID = "ffpillgrayblue",
            Frame = 16,
            Sub = mod.PICKUP.PILLCOLOR.GREYTEAL,
        },
        {
            ID = "ffpillyellowblacksprinkles",
            Frame = 17,
            Sub = mod.PICKUP.PILLCOLOR.DOTSYELLOW,
        },
        {
            ID = "ffpillcowpeepy",
            Frame = 18,
            Sub = mod.PICKUP.PILLCOLOR.YELLOWCOW,
        },
        {
            ID = "ffpillivoryblack",
            Frame = 19,
            Sub = mod.PICKUP.PILLCOLOR.TAUPEOFFBLACK,
        },
        {
            ID = "ffpillcyanide",
            Frame = 20,
            Group = "ffcyanide",
            Sub = mod.PICKUP.PILLCOLOR.CYANIDE,
        },
        {
            ID = "ffpillcyanidegold",
            Frame = 21,
            Group = "ffcyanide",
            Sub = mod.PICKUP.PILLCOLOR.GOLD_CYANIDE,
            Weight = 9100,
        },
        {
            ID = "ffpillcowcow",
            Frame = 44,
            Sub = mod.PICKUP.PILLCOLOR.COWCOW,
        },
        {
            ID = "ffpillstrawberrycow",
            Frame = 45,
            Sub = mod.PICKUP.PILLCOLOR.STRAWBERRYCOW,
        },
        {
            ID = "ffpillchocolatecow",
            Frame = 46,
            Sub = mod.PICKUP.PILLCOLOR.CHOCOLATECOW,
        },
        {
            ID = "ffpillgreenbrown",
            Frame = 50,
            Sub = mod.PICKUP.PILLCOLOR.GREENBROWN,
        },
        --HORSE PILLS
        {
            ID = "ffhorsepillblackpurple",
            Frame = 22,
            Sub = mod.PICKUP.PILLCOLOR.BLACKPURPLE | PillColor.PILL_GIANT_FLAG,
            Weight = ADDITIONAL_WEIGHTS.HORSE,
        },
        {
            ID = "ffhorsepillpurpleorange",
            Frame = 23,
            Sub = mod.PICKUP.PILLCOLOR.PURPLEORANGE | PillColor.PILL_GIANT_FLAG,
            Weight = ADDITIONAL_WEIGHTS.HORSE,
        },
        {
            ID = "ffhorsepillsimpsons",
            Frame = 24,
            Sub = mod.PICKUP.PILLCOLOR.BLUEYELLOW | PillColor.PILL_GIANT_FLAG,
            Weight = ADDITIONAL_WEIGHTS.HORSE,
        },
        {
            ID = "ffhorsepillbluegray",
            Frame = 25,
            Sub = mod.PICKUP.PILLCOLOR.BLUESILVER | PillColor.PILL_GIANT_FLAG,
            Weight = ADDITIONAL_WEIGHTS.HORSE,
        },
        {
            ID = "ffhorsepillpurplesprinkles",
            Frame = 26,
            Sub = mod.PICKUP.PILLCOLOR.DOTSVIOLET | PillColor.PILL_GIANT_FLAG,
            Weight = ADDITIONAL_WEIGHTS.HORSE,
        },
        {
            ID = "ffhorsepillsalmonblack",
            Frame = 27,
            Sub = mod.PICKUP.PILLCOLOR.MAROONSHADOW | PillColor.PILL_GIANT_FLAG,
            Weight = ADDITIONAL_WEIGHTS.HORSE,
        },
        {
            ID = "ffhorsepillgreensprinkles",
            Frame = 28,
            Sub = mod.PICKUP.PILLCOLOR.DOTSLIME | PillColor.PILL_GIANT_FLAG,
            Weight = ADDITIONAL_WEIGHTS.HORSE,
        },
        {
            ID = "ffhorsepillbluewhite",
            Frame = 29,
            Sub = mod.PICKUP.PILLCOLOR.EMERALDBEIGE | PillColor.PILL_GIANT_FLAG,
            Weight = ADDITIONAL_WEIGHTS.HORSE,
        },
        {
            ID = "ffhorsepillfullblack",
            Frame = 30,
            Sub = mod.PICKUP.PILLCOLOR.BLACKBLACK | PillColor.PILL_GIANT_FLAG,
            Weight = ADDITIONAL_WEIGHTS.HORSE,
        },
        {
            ID = "ffhorsepillblueblacksprinkles",
            Frame = 31,
            Sub = mod.PICKUP.PILLCOLOR.DOTSBLUE | PillColor.PILL_GIANT_FLAG,
            Weight = ADDITIONAL_WEIGHTS.HORSE,
        },
        {
            ID = "ffhorsepillwhitepurple",
            Frame = 32,
            Sub = mod.PICKUP.PILLCOLOR.IVORYBYZANTIUM | PillColor.PILL_GIANT_FLAG,
            Weight = ADDITIONAL_WEIGHTS.HORSE,
        },
        {
            ID = "ffhorsepilbronzeburgundy",
            Frame = 33,
            Sub = mod.PICKUP.PILLCOLOR.REDRED | PillColor.PILL_GIANT_FLAG,
            Weight = ADDITIONAL_WEIGHTS.HORSE,
        },
        {
            ID = "ffhorsepillmissingtexture",
            Frame = 34,
            Sub = mod.PICKUP.PILLCOLOR.DOTSPINK | PillColor.PILL_GIANT_FLAG,
            Weight = ADDITIONAL_WEIGHTS.HORSE,
        },
        {
            ID = "ffhorsepillwhiteyellow",
            Frame = 35,
            Sub = mod.PICKUP.PILLCOLOR.WHITEORANGE | PillColor.PILL_GIANT_FLAG,
            Weight = ADDITIONAL_WEIGHTS.HORSE,
        },
        {
            ID = "ffhorsepillblacksprinkles",
            Frame = 36,
            Sub = mod.PICKUP.PILLCOLOR.DOTSBLACK | PillColor.PILL_GIANT_FLAG,
            Weight = ADDITIONAL_WEIGHTS.HORSE,
        },
        {
            ID = "ffhorsepillgraycolourfulsprinkles",
            Frame = 37,
            Sub = mod.PICKUP.PILLCOLOR.RAINBOWGREY | PillColor.PILL_GIANT_FLAG,
            Weight = ADDITIONAL_WEIGHTS.HORSE,
        },
        {
            ID = "ffhorsepillgrayblue",
            Frame = 38,
            Sub = mod.PICKUP.PILLCOLOR.GREYTEAL | PillColor.PILL_GIANT_FLAG,
            Weight = ADDITIONAL_WEIGHTS.HORSE,
        },
        {
            ID = "ffhorsepillyellowblacksprinkles",
            Frame = 39,
            Sub = mod.PICKUP.PILLCOLOR.DOTSYELLOW | PillColor.PILL_GIANT_FLAG,
            Weight = ADDITIONAL_WEIGHTS.HORSE,
        },
        {
            ID = "ffhorsepillcowpeepy",
            Frame = 40,
            Sub = mod.PICKUP.PILLCOLOR.YELLOWCOW | PillColor.PILL_GIANT_FLAG,
            Weight = ADDITIONAL_WEIGHTS.HORSE,
        },
        {
            ID = "ffhorsepillivoryblack",
            Frame = 41,
            Sub = mod.PICKUP.PILLCOLOR.TAUPEOFFBLACK | PillColor.PILL_GIANT_FLAG,
            Weight = ADDITIONAL_WEIGHTS.HORSE,
        },
        {
            ID = "ffhorsepillcyanide",
            Frame = 42,
            Sub = mod.PICKUP.PILLCOLOR.CYANIDE | PillColor.PILL_GIANT_FLAG,
            Group = "ffcyanide",
            Weight = ADDITIONAL_WEIGHTS.HORSE,
        },
        {
            ID = "ffhorsepillcyanidegold",
            Frame = 43,
            Sub = mod.PICKUP.PILLCOLOR.GOLD_CYANIDE | PillColor.PILL_GIANT_FLAG,
            Group = "ffcyanide",
            Weight = ADDITIONAL_WEIGHTS.HORSE + 100,
        },
        {
            ID = "ffhorsepillcowcow",
            Frame = 47,
            Sub = mod.PICKUP.PILLCOLOR.COWCOW | PillColor.PILL_GIANT_FLAG,
            Weight = ADDITIONAL_WEIGHTS.HORSE,
        },
        {
            ID = "ffhorsepillstrawberrycow",
            Frame = 48,
            Sub = mod.PICKUP.PILLCOLOR.STRAWBERRYCOW | PillColor.PILL_GIANT_FLAG,
            Weight = ADDITIONAL_WEIGHTS.HORSE,
        },
        {
            ID = "ffhorsepillchocolatecow",
            Frame = 49,
            Sub = mod.PICKUP.PILLCOLOR.CHOCOLATECOW | PillColor.PILL_GIANT_FLAG,
            Weight = ADDITIONAL_WEIGHTS.HORSE,
        },
        {
            ID = "ffhorsepillgrenbrown",
            Frame = 51,
            Sub = mod.PICKUP.PILLCOLOR.GREENBROWN | PillColor.PILL_GIANT_FLAG,
            Weight = ADDITIONAL_WEIGHTS.HORSE,
        },
     },
     ["cards"] = {
        {
            ID = "ffreversefireballcard",
            CardBack = mod.PICKUP.CARDBACK.REVERSE_MAGIC,
            Frame = 11,
        },
        {
            ID = "ffhearthstonecard",
            CardBack = mod.PICKUP.CARDBACK.HEARTHSTONE,
            Frame = 24,
        },
        {
            ID = "ffplayingtarotcard",
            CardBack = mod.PICKUP.CARDBACK.MISPRINTED_PLAYING_TAROT,
            Frame = 25,
        },
        {
            ID = "ffsimpsonstarotcard",
            CardBack = mod.PICKUP.CARDBACK.SIMPSONS_TAROT,
            Frame = 26,
        },
        {
            ID = "ffnekonyanquizcard",
            CardBack = mod.PICKUP.CARDBACK.NEKO_CARD,
            Frame = 27,
        },
        {
            ID = "fffoursoulslootcard",
            CardBack = mod.PICKUP.CARDBACK.FOUR_SOULS_LOOT_CARD,
            Frame = 29,
        },
        {
            ID = "ffreverseminorarcanacard",
            CardBack = mod.PICKUP.CARDBACK.REVERSE_MINOR_ARCANA,
            Frame = 31,
        },
        {
            ID = "ffmisprintedminormajorcard",
            CardBack = mod.PICKUP.CARDBACK.MISPRINTED_MINORMAJOR,
            Frame = 30,
        },
        {
            ID = "ffshadowversecard",
            CardBack = mod.PICKUP.CARDBACK.SHADOWVERSE,
            Frame = 32,
        },
        {
            ID = "ffslaythespirecard",
            CardBack = mod.PICKUP.CARDBACK.SLAY_THE_SPIRE,
            Frame = 33,
        },
        {
            ID = "fftouhoucard",
            CardBack = mod.PICKUP.CARDBACK.TOUHOU,
            Frame = 34,
        },
        {
            ID = "fforangejuicecard",
            CardBack = mod.PICKUP.CARDBACK.ORANGE_JUICE,
            Frame = 35,
        },
        {
            ID = "ffcallingcard",
            CardBack = mod.PICKUP.CARDBACK.CALLING_CARD,
            Frame = 2,
        },
        {
            ID = "ffgrottobeast",
            CardBack = mod.PICKUP.CARDBACK.GROTTO_CARD,
            Frame = 5,
        },
        {
            ID = "ffdownloadfailurecard",
            CardBack = mod.PICKUP.CARDBACK.JPEG,
            Frame = 10,
        },
        {
            ID = "ffcakecard",
            CardBack = mod.PICKUP.CARDBACK.SUMMONER_BATTLEGROUNDS,
            Frame = 16,
        },
        {
            ID = "ffdefusecard",
            CardBack = mod.PICKUP.CARDBACK.EXPLODING_KITTENS,
            Frame = 7,
        },
        {
            ID = "ffdrugscard",
            CardBack = mod.PICKUP.CARDBACK.SMALL_CONTRABAND,
            Frame = 12,
        },
        {
            ID = "ffskipcard",
            CardBack = mod.PICKUP.CARDBACK.PHASE_10,
            Frame = 3,
        },
        {
            ID = "ffyugiohcard",
            CardBack = mod.PICKUP.CARDBACK.YUGIOH,
            Frame = 21,
        },
        {
            ID = "ffclubpenguincard",
            CardBack = mod.PICKUP.CARDBACK.CARD_JITSU,
            Frame = 14,
        },
        {
            ID = "ffgiftcard",
            CardBack = mod.PICKUP.CARDBACK.GIFT_CARD,
            Frame = 8,
        },
        {
            ID = "ffsorrycard",
            CardBack = mod.PICKUP.CARDBACK.SORRY,
            Frame = 1,
        },
        {
            ID = "ffmisprintedgishcard",
            CardBack = mod.PICKUP.CARDBACK.MISPRINTED_GISH,
            Frame = 18,
        },
        {
            ID = "ffaberrantarcanacard",
            CardBack = mod.PICKUP.CARDBACK.ABBERANT,
            Frame = 23,
        },
        {
            ID = "ffmisprintedplayingcard",
            CardBack = mod.PICKUP.CARDBACK.MISPRINTED_PLAYING,
            Frame = 20,
        },
        {
            ID = "ff13ofstarscard",
            CardBack = mod.PICKUP.CARDBACK.SPECIAL_PLAYING,
            Frame = 17,
        },
        {
            ID = "ffminorarcanacard",
            CardBack = mod.PICKUP.CARDBACK.MINOR_ARCANA,
            Frame = 19,
        },
        {
            ID = "ffreversecard",
            CardBack = mod.PICKUP.CARDBACK.REVERSE_PLAYING,
            Frame = 6,
        },
        {
            ID = "ffpokemoncard",
            CardBack = mod.PICKUP.CARDBACK.FRIENDLYMON,
            Frame = 4,
        },
     },
     ["runes"] = {
        {
            ID = "ffsouloffiend",
            CardBack = mod.PICKUP.CARDBACK.SOUL_OF_FIEND,
            Frame = 2,
        },
        {
            ID = "ffsoulofgolem",
            CardBack = mod.PICKUP.CARDBACK.SOUL_OF_GOLEM,
            Frame = 5,
        },
        {
            ID = "ffsoulofrandom",
            CardBack = mod.PICKUP.CARDBACK.SOUL_OF_RANDOM,
            Frame = 6,
        },
        {
            ID = "ffsoulofcraig",
            CardBack = mod.PICKUP.CARDBACK.SOUL_OF_CRAIG,
            Frame = 1,
        },
        {
            ID = "ffsouloffriend",
            CardBack = mod.PICKUP.CARDBACK.SOUL_OF_FRIEND,
            Frame = 4,
        },
        {
            ID = "ffsoulofslippy",
            CardBack = mod.PICKUP.CARDBACK.SOUL_OF_SLIPPY,
            Frame = 7,
        },
        {
            ID = "ffsoulofinaba",
            CardBack = mod.PICKUP.CARDBACK.SOUL_OF_INABA,
            Frame = 8,
        },
     },
     ["ffobjects"] = {
        {
            ID = "ffdiceshardd10",
            CardBack = mod.PICKUP.CARDBACK.D10_SHARD,
            Frame = 17,
        },
        {
            ID = "ffdiceshardeternal",
            CardBack = mod.PICKUP.CARDBACK.DE_SHARD,
            Frame = 18,
        },
        {
            ID = "ffdiceshardd8",
            CardBack = mod.PICKUP.CARDBACK.D8_SHARD,
            Frame = 19,
        },
        {
            ID = "ffyellowcar",
            CardBack = mod.PICKUP.CARDBACK.YELLOW_CAR,
            Frame = 20,
        },
        {
            ID = "ffluckyduck",
            CardBack = mod.PICKUP.CARDBACK.LUCKY_DUCK,
            Frame = 21,
        },
        {
            ID = "ffcomicalroundglasses",
            CardBack = mod.PICKUP.CARDBACK.COMICAL_ROUND_GLASSES,
            Frame = 22,
        },
        {
            ID = "ffeggsack",
            CardBack = mod.PICKUP.CARDBACK.EGG_SACK,
            Frame = 23,
        },
        {
            ID = "ffpigobject",
            CardBack = mod.PICKUP.CARDBACK.PINK_COW,
            Frame = 16,
        },
        {
            ID = "ffpuzzle",
            CardBack = mod.PICKUP.CARDBACK.PUZZLE_PIECE,
            Frame = 7,
        },
        {
            ID = "ffgreenhouse",
            CardBack = mod.PICKUP.CARDBACK.GREEN_HOUSE,
            Frame = 10,
        },
        {
            ID = "ffcoolphoto",
            CardBack = mod.PICKUP.CARDBACK.COOL_PHOTO,
            Frame = 12,
        },
        {
            ID = "ffbrickseparator",
            CardBack = mod.PICKUP.CARDBACK.BRICK_SEPERATOR,
            Frame = 14,
        },
        {
            ID = "ffblanktile",
            CardBack = mod.PICKUP.CARDBACK.BLANK_LETTER_TILE,
            Frame = 8,
        },
        {
            ID = "ffhorsepaste",
            CardBack = mod.PICKUP.CARDBACK.HORSE_PUSHPOP,
            Frame = 15,
        },
        {
            ID = "fftophat",
            CardBack = mod.PICKUP.CARDBACK.TOP_HAT,
            Frame = 9,
        },
        {
            ID = "fffirecracker",
            CardBack = mod.PICKUP.CARDBACK.CHRISTMAS_CRACKER,
            Frame = 13,
        },
        {
            ID = "ffstud_1",
            CardBack = mod.PICKUP.CARDBACK.STUD_1,
            Frame = 1,
        },
        {
            ID = "ffstud_2",
            CardBack = mod.PICKUP.CARDBACK.STUD_2,
            Frame = 2,
        },
        {
            ID = "ffstud_3",
            CardBack = mod.PICKUP.CARDBACK.STUD_3,
            Frame = 3,
        },
        {
            ID = "ffstud_4",
            CardBack = mod.PICKUP.CARDBACK.STUD_4,
            Frame = 4,
        },
        {
            ID = "ffstud_5",
            CardBack = mod.PICKUP.CARDBACK.STUD_5,
            Frame = 5,
        },
        {
            ID = "ffstud_6",
            CardBack = mod.PICKUP.CARDBACK.STUD_6,
            Frame = 6,
        },
     },
     ["ffdice"] = {
        {
            ID = "ffglassd6",
            CardBack = mod.PICKUP.CARDBACK.GLASS_D6,
            Frame = 0,
        },
        {
            ID = "ffglassd4",
            CardBack = mod.PICKUP.CARDBACK.GLASS_D4,
            Frame = 1,
        },
        {
            ID = "ffglassd8",
            CardBack = mod.PICKUP.CARDBACK.GLASS_D8,
            Frame = 2,
        },
        {
            ID = "ffglassd100",
            CardBack = mod.PICKUP.CARDBACK.GLASS_D100,
            Frame = 3,
        },
        {
            ID = "ffglassd10",
            CardBack = mod.PICKUP.CARDBACK.GLASS_D10,
            Frame = 4,
        },
        {
            ID = "ffglassd20",
            CardBack = mod.PICKUP.CARDBACK.GLASS_D20,
            Frame = 5,
        },
        {
            ID = "ffglassd12",
            CardBack = mod.PICKUP.CARDBACK.GLASS_D12,
            Frame = 6,
        },
        {
            ID = "ffglassd2",
            CardBack = mod.PICKUP.CARDBACK.GLASS_D2,
            Frame = 8,
        },
        {
            ID = "ffglassspindown",
            CardBack = mod.PICKUP.CARDBACK.GLASS_SPINDOWN,
            Frame = 7,
        },
        {
            ID = "ffglassazurite",
            CardBack = mod.PICKUP.CARDBACK.GLASS_AZURITE_SPINDOWN,
            Frame = 9,
        },
        {
            ID = "ffglassd5",
            CardBack = mod.PICKUP.CARDBACK.GLASS_D5,
            Frame = 10,
        },
        {
            ID = "ffglassd3",
            CardBack = mod.PICKUP.CARDBACK.GLASS_D3,
            Frame = 11,
        },
     },
     ["ffdiscs"] = {
        {
            ID = "ffdisctreasure",
            CardBack = mod.PICKUP.CARDBACK.DISC_TREASURE,
            Frame = 1,
        },
        {
            ID = "ffdiscshop",
            CardBack = mod.PICKUP.CARDBACK.DISC_SHOP,
            Frame = 2,
        },
        {
            ID = "ffdiscboss",
            CardBack = mod.PICKUP.CARDBACK.DISC_BOSS,
            Frame = 6,
        },
        {
            ID = "ffdiscsecret",
            CardBack = mod.PICKUP.CARDBACK.DISC_SECRET,
            Frame = 5,
        },
        {
            ID = "ffdiscdevil",
            CardBack = mod.PICKUP.CARDBACK.DISC_DEVIL,
            Frame = 0,
        },
        {
            ID = "ffdiscangel",
            CardBack = mod.PICKUP.CARDBACK.DISC_ANGEL,
            Frame = 3,
        },
        {
            ID = "ffdiscplanetarium",
            CardBack = mod.PICKUP.CARDBACK.DISC_PLANETARIUM,
            Frame = 4,
        },
        {
            ID = "ffdiscrainbowgay",
            CardBack = mod.PICKUP.CARDBACK.DISC_CHAOS,
            Frame = 8,
        },
        {
            ID = "ffdisccracked",
            CardBack = mod.PICKUP.CARDBACK.DISC_BROKEN,
            Frame = 7,
        },
        {
            ID = "ffdisctainted",
            CardBack = mod.PICKUP.CARDBACK.DISC_TAINTED,
            Frame = 9,
        },
     },
     ["beggars"] = {
        {
            ID = "ffbabi",
            Frame = 1,
            Var = mod.FF.Babi.Var,
            Weight = 4500,
        },
        {
            ID = "ffbismuthguy",
            Frame = 2,
            Var = mod.FF.BismuthBeggar.Var,
            Weight = 4000,
        },
        {
            ID = "ffgeodegolem",
            Frame = 3,
            Var = mod.FF.GeodeGolem.Var,
            Weight = 4500,
        },
        {
            ID = "ffmidarizer",
            Frame = 4,
            Var = mod.FF.Midarizer.Var,
            Weight = 4500,
        },
        {
            ID = "ffunfinishedgolem",
            Frame = 5,
            Var = mod.FF.UnfinishedGolem.Var,
            Weight = 4000,
        },
        {
            ID = "ffsculpteur",
            Frame = 6,
            Var = mod.FF.Sourpuss.Var,
            Weight = 4000,
        },
        {
            ID = "ffsweetpuss",
            Frame = 7,
            Var = mod.FF.Sweetpuss.Var,
            Weight = 4500,
        },
        {
            ID = "ffcellgame",
            Frame = 11,
            Var = mod.FF.CellGame.Var,
            Weight = 3050,
        },
        {
            ID = "ffhomestuckbeggar",
            Frame = 12,
            Var = mod.FF.CosplayBeggar.Var,
            Weight = 10000,
        },
        {
            ID = "ffhugbeggar",
            Frame = 8,
            Var = mod.FF.HugBeggar.Var,
            Weight = 3001,
        },
        {
            ID = "ffmugbeggar",
            Frame = 29,
            Var = mod.FF.HugBeggar.Var,
            Sub = 1,
            Weight = 3002,
        },
        {
            ID = "ffhoroscopebeggar",
            Frame = 9,
            Var = mod.FF.ZodiacBeggar.Var,
            Weight = 3600,
        },
        {
            ID = "ffblacksmith",
            Frame = 10,
            Var = mod.FF.Blacksmith.Var,
            Weight = 3550,
            Func = function(s) return not mod:GetEntityData(s).DidDropFunc end
        },
        {
            ID = "ffdrugdealer",
            Frame = 13,
            Var = mod.FF.Dealer.Var,
            Weight = 3150,
        },
        {
            ID = "ffregularbeggarcopy4drug",
            Frame = 0,
            Var = mod.FF.FakeBeggar.Var,
            Weight = 3000,
        },
        {
            ID = "ffevilbeggar",
            Frame = 14,
            Var = mod.FF.EvilBeggar.Var,
            Weight = 3500,
        },
        {
            ID = "ffrobotfortuneteller",
            Frame = 15,
            Var = mod.FF.RobotTeller.Var,
            Weight = 2550,
            Func = function(s) return not mod:GetEntityData(s).DidDropFunc end
        },
        {
            ID = "ffpokertable",
            Frame = 16,
            Var = mod.FF.PokerTable.Var,
            Weight = 3090,
            Func = function(s) return not mod:GetEntityData(s).DidDropFunc end
        },
     },
     ["slots"] = {
        {
            ID = "ffminingmachine",
            Frame = 0,
            Var = mod.FF.MiningMachine.Var,
            Weight = 4000,
        },
        {
            ID = "ffmilkmachineslot",
            Frame = 1,
            Var = mod.FF.MilkMachine.Var,
            Sub = -1,
            Weight = 2650,
            Func = function(s) return not mod:GetEntityData(s).DidDropFunc end
        },
        {
            ID = "ffvendingmachineregular",
            Frame = 2,
            Var = mod.FF.VendingMachine.Var,
            Sub = -1,
            Weight = 2650,
            Func = function(s) return not mod:GetEntityData(s).DidDropFunc end
        },
        {
            ID = "ffvendingmachineoneuse",
            Frame = 3,
            Var = mod.FF.VendingMachine.Var,
            Sub = -1,
            Weight = 2655,
            CondFunc = function(p) return p.SubType % 2 == 1 end,
            Func = function(s) return not mod:GetEntityData(s).DidDropFunc end
        },
        {
            ID = "ffvendingmachineregularffpool",
            IconID = "ffvendingmachineregular",
            NoIcon = true,
            Var = mod.FF.VendingMachineFF.Var,
            Sub = -1,
            Weight = 2650,
            Func = function(s) return not mod:GetEntityData(s).DidDropFunc end,
        },
        {
            ID = "ffvendingmachineoneuseffpool",
            IconID = "ffvendingmachineoneuse",
            NoIcon = true,
            Var = mod.FF.VendingMachineFF.Var,
            Sub = -1,
            Weight = 2655,
            CondFunc = function(p) return p.SubType % 2 == 1 end,
            Func = function(s) return not mod:GetEntityData(s).DidDropFunc end
        },
        {
            ID = "ffsecretbenphone",
            Frame = 4,
            Var = mod.FF.PhoneBooth.Var,
            Weight = 9001,
            Func = function(s) return not mod:GetEntityData(s).DidDropFunc end
        },
        {
            ID = "ffdicedispenser",
            Frame = 5,
            Var = mod.FF.DiceDispenser.Var,
            Weight = 2650,
            Func = function(s) return not mod:GetEntityData(s).DidDropFunc end
        },
        {
            ID = "ffgoldenmachine",
            Frame = 6,
            Var = mod.FF.GoldenSlotMachine.Var,
            Weight = 5000,
            Func = function(s) return not mod:GetEntityData(s).removeOnReentry end
        },
        {
            ID = "ffgridrestockmachine",
            Frame = 7,
            Var = mod.FF.GridRestock.Var,
            Weight = 2250,
            Func = function(s) return not mod:GetEntityData(s).DidDropFunc end
        },
        {
            ID = "ffjukebox",
            Frame = 8,
            Var = mod.FF.Jukebox.Var,
            Weight = 2000,
            Func = function(s) return not mod:GetEntityData(s).DidDropFunc end
        },
        {
            ID = "ffpennypress",
            Frame = 9,
            Var = mod.FF.PennyPress.Var,
            Weight = 2550,
            Func = function(s) return not mod:GetEntityData(s).DidDropFunc end
        },
     },
     ["ffstuff"] = {
        {
            ID = "ffberrysingular",
            Frame = 1,
            Var = mod.PICKUP.VARIANT.SWEET_RED_BERRY,
            Weight = 4005,
        },
        {
            ID = "ffberrybunch",
            Frame = 2,
            Var = mod.PICKUP.VARIANT.SWEET_RED_BERRY,
            Sub = 1,
            Weight = 4010,
        },
        {
            ID = "ffshardblue",
            Frame = 3,
            Var = mod.PICKUP.VARIANT.PRISM_SHARD,
            Sub = mod.PICKUP.PRISM_SHARD.BLUE,
            Weight = 4000,
        },
        {
            ID = "ffshardgreen",
            Frame = 4,
            Var = mod.PICKUP.VARIANT.PRISM_SHARD,
            Sub = mod.PICKUP.PRISM_SHARD.GREEN,
            Weight = 4000,
        },
        {
            ID = "ffshardpurple",
            Frame = 5,
            Var = mod.PICKUP.VARIANT.PRISM_SHARD,
            Sub = mod.PICKUP.PRISM_SHARD.PURPLE,
            Weight = 4000,
        },
        {
            ID = "ffshardred",
            Frame = 6,
            Var = mod.PICKUP.VARIANT.PRISM_SHARD,
            Sub = mod.PICKUP.PRISM_SHARD.RED,
            Weight = 4000,
        },
        {
            ID = "ffshardorange",
            Frame = 7,
            Var = mod.PICKUP.VARIANT.PRISM_SHARD,
            Sub = mod.PICKUP.PRISM_SHARD.YELLOW,
            Weight = 4000,
        },
        {
            ID = "ffshardrainbow",
            Frame = 8,
            Var = mod.PICKUP.VARIANT.PRISM_SHARD,
            Sub = mod.PICKUP.PRISM_SHARD.RAINBOW,
            Weight = 4000,
        },
        {
            ID = "ffspareeraser",
            Frame = 9,
            Var = mod.PICKUP.VARIANT.SPARE_ERASER,
            Weight = 4000,
        },
        {
            ID = "ffbriendgun",
            Frame = 10,
            Var = mod.PICKUP.VARIANT.BRIEND_BIRTHRIGHT_GUN,
            Sub = -1,
            Weight = 4000,
        },
        {
            ID = "ffamethystkeeper",
            Frame = 0,
            Type = EntityType.ENTITY_SLOT,
            Var = mod.FF.Amethyst.Var,
            Weight = 4500,
        },
        {
            ID = "ffamethystkeeperfloat",
            IconID = "ffamethystkeeper",
            NoIcon = true,
            Type = EntityType.ENTITY_SLOT,
            Var = mod.FF.FloatingAmethyst.Var,
            Weight = 4500,
        },
        {
            ID = "ffgolemrock",
            Type = EntityType.ENTITY_PICKUP,
            Var = PickupVariant.PICKUP_TRINKET,
            Sub = -1,
            Anim = "Trinkets",
            Frame = 0,
            Group = "trinkets",
            Weight = 50000,
            CondFunc = function(p) return mod.RockTrinkets[mod:GetRealTrinketId(p.SubType)] end
        },
     },
    }

    for i = 1, #GROUPS do
        local groupName = GROUPS[i].ID
        local defaultWeight = GROUPS[i].Weight or 0
        local defaultType = GROUPS[i].Type or EntityType.ENTITY_PICKUP
        local defaultVar = GROUPS[i].Var or 0
        local defaultSub = GROUPS[i].Sub or 0
        local defaultAnimation = GROUPS[i].Anim or "Trinkets"
        local isCardBack = GROUPS[i].CardBack

        for k = 1, #iconsTable[groupName] do
            local entry = iconsTable[groupName][k]
            if not entry.NoIcon then
                MinimapAPI:AddIcon(
                    entry.IconID or entry.ID,
                    mod.MinimapAPISprite,
                    entry.Anim or defaultAnimation,
                    entry.Frame or 0)
            end

            local conditionalFunc
            if isCardBack or entry.isCardBack then
                conditionalFunc = function (p) return (not isCanTripped() and itemConfig:GetCard(p.SubType).PickupSubtype == entry.CardBack) end
            elseif entry.RoomCheck then
                conditionalFunc = function (p) return (entry.CondFunc(p) and roomIs(entry.RoomCheck)) end
            else
                conditionalFunc = entry.CondFunc
            end

            MinimapAPI:AddPickup(
                entry.ID,
                entry.IconID or entry.ID,
                entry.Type or defaultType,
                entry.Var or defaultVar,
                entry.Sub or defaultSub,
                entry.Func or MinimapAPI.PickupNotCollected,
                entry.Group or groupName,
                entry.Weight or defaultWeight,
                conditionalFunc
            )
        end
    end

    mod.scheduleForUpdate(function()
        local level = game:GetLevel()

        local function ImpCurse()
            return mod:levelHasCurse(level, FiendFolio.curses.impCurse)
        end
        local function StoneCurse()
            return mod:levelHasCurse(level, FiendFolio.curses.stoneCurse)
        end
        local function SunCurse()
            return mod:levelHasCurse(level, FiendFolio.curses.sunCurse)
        end
        local function SwineCurse()
            return mod:levelHasCurse(level, FiendFolio.curses.swineCurse)
        end
        local function ScytheCurse()
            return mod:levelHasCurse(level, FiendFolio.curses.scytheCurse)
        end
        local function GhostCurse()
            return mod:levelHasCurse(level, FiendFolio.curses.ghostCurse)
        end
        local function MasterCurse()
            return mod:levelHasCurse(level, FiendFolio.curses.masterCurse)
        end
        local function VeilCurse()
            return mod:levelHasCurse(level, FiendFolio.curses.veilCurse)
        end
        local function GateCurse()
            return mod:levelHasCurse(level, FiendFolio.curses.gateCurse)
        end
        local function DynamoCurse()
            return mod:levelHasCurse(level, FiendFolio.curses.dynamoCurse)
        end
        local function LunacyCurse()
            return mod:levelHasCurse(level, FiendFolio.curses.lunacyCurse)
        end

        MinimapAPI:AddMapFlag("ImpCurse", ImpCurse, mod.MinimapAPISprite, "Curses", 0)
        MinimapAPI:AddMapFlag("StoneCurse", StoneCurse, mod.MinimapAPISprite, "Curses", 1)
        MinimapAPI:AddMapFlag("SunCurse", SunCurse, mod.MinimapAPISprite, "Curses", 2)
        MinimapAPI:AddMapFlag("SwineCurse", SwineCurse, mod.MinimapAPISprite, "Curses", 3)
        MinimapAPI:AddMapFlag("ScytheCurse", ScytheCurse, mod.MinimapAPISprite, "Curses", 5)
        MinimapAPI:AddMapFlag("GhostCurse", GhostCurse, mod.MinimapAPISprite, "Curses", 4)
        MinimapAPI:AddMapFlag("MasterCurse", MasterCurse, mod.MinimapAPISprite, "Curses", 6)
        MinimapAPI:AddMapFlag("DynamoCurse", DynamoCurse, mod.MinimapAPISprite, "Curses", 9)
        MinimapAPI:AddMapFlag("LunacyCurse", LunacyCurse, mod.MinimapAPISprite, "Curses", 10)
        MinimapAPI:AddMapFlag("VeilCurse", VeilCurse, mod.MinimapAPISprite, "Curses", 7)
        MinimapAPI:AddMapFlag("GateCurse", GateCurse, mod.MinimapAPISprite, "Curses", 8)

        MinimapAPI:AddIcon("FFGateCurseRoom", mod.MinimapAPISprite, "Rooms", 0)
    end, 0, ModCallbacks.MC_POST_RENDER, true)

    MinimapAPI:AddIcon("VeilQuestionIcon", mod.MinimapAPISprite, "CursePickups", 1)
    MinimapAPI:AddIcon("VeilQuestionChestIcon", mod.MinimapAPISprite, "CursePickups", 0)

    MinimapAPI:AddIcon("FFSaloonYeehaw", mod.MinimapAPISprite, "Rooms", 4)
end