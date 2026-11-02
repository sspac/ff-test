local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

mod.CardNamePickups = {
    ["Clubs"] = 40,
    ["Diamonds"] = 20,
    ["Spades"] = 30,
    ["Hearts"] = 10,
    ["Pentacles"] = 350,
    ["Cups"] = 70,
    }
    mod.UnbiasedPickups = {
        ["Clubs"] = {
            {ID = BombSubType.BOMB_NORMAL,              Unlocked = function() return true end},
            {ID = BombSubType.BOMB_DOUBLEPACK,          Unlocked = function() return true end},
            {ID = BombSubType.BOMB_TROLL,               Unlocked = function() return true end},
            {ID = BombSubType.BOMB_GOLDEN,              Unlocked = function() return Isaac.GetPersistentGameData():Unlocked(Achievement.GOLDEN_BOMBS) end},
            {ID = BombSubType.BOMB_SUPERTROLL,          Unlocked = function() return true end},
            {ID = BombSubType.BOMB_GOLDENTROLL,         Unlocked = function() return true end},
            {ID = FiendFolio.PICKUP.BOMB.COPPER,        Unlocked = function() return true end},
            {ID = FiendFolio.PICKUP.BOMB.DOUBLE_COPPER, Unlocked = function() return true end},
            {ID = FiendFolio.PICKUP.BOMB.MIXED_DOUBLE,  Unlocked = function() return true end},
            {ID = FiendFolio.PICKUP.BOMB.COPPER_TROLL,  Unlocked = function() return true end},
        },
        ["Diamonds"] = {
            {ID = CoinSubType.COIN_PENNY,               Unlocked = function() return true end},
            {ID = CoinSubType.COIN_NICKEL,              Unlocked = function() return true end},
            {ID = CoinSubType.COIN_DIME,                Unlocked = function() return true end},
            {ID = CoinSubType.COIN_DOUBLEPACK,          Unlocked = function() return true end},
            {ID = CoinSubType.COIN_LUCKYPENNY,          Unlocked = function() return Isaac.GetPersistentGameData():Unlocked(Achievement.LUCKY_PENNIES) end},
            {ID = CoinSubType.COIN_STICKYNICKEL,        Unlocked = function() return Isaac.GetPersistentGameData():Unlocked(Achievement.STICKY_NICKELS) end},
            {ID = CoinSubType.COIN_GOLDEN,              Unlocked = function() return Isaac.GetPersistentGameData():Unlocked(Achievement.GOLDEN_PENNIES) end},
            {ID = mod.PICKUP.COIN.CURSED,               Unlocked = function() return true end},
            {ID = mod.PICKUP.COIN.HAUNTED,              Unlocked = function() return mod.ACHIEVEMENT.HAUNTED_PENNY:IsUnlocked() end},
            {ID = mod.PICKUP.COIN.HONEY,                Unlocked = function() return Isaac.GetPersistentGameData():Unlocked(Achievement.THE_CELLAR) end},
            {ID = mod.PICKUP.COIN.GOLDENCURSED,         Unlocked = function() return mod.ACHIEVEMENT.GOLDEN_CURSED_PENNY:IsUnlocked() end},
            {ID = mod.PICKUP.COIN.LEGOSTUD,             Unlocked = function() return true end},
            {ID = mod.PICKUP.COIN.MEDLEY_STICKY,        Unlocked = function() return mod.CanSpawnMedleyPenny() end, Chance = 0.01},
            {ID = mod.PICKUP.COIN.PLATINUM,             Unlocked = function() return true end},
            {ID = mod.PICKUP.COIN.LIL_PENNY,            Unlocked = function() return true end},
        },
        --Be careful if adding tables, wackey only reads subtypes atm and will crash
        ["Spades"] = {
            {ID = KeySubType.KEY_NORMAL,                Unlocked = function() return true end},
            {ID = KeySubType.KEY_GOLDEN,                Unlocked = function() return true end},
            {ID = KeySubType.KEY_DOUBLEPACK,            Unlocked = function() return true end},
            {ID = KeySubType.KEY_CHARGED,               Unlocked = function() return Isaac.GetPersistentGameData():Unlocked(Achievement.CHARGED_KEY) end},
            {ID = mod.PICKUP.KEY.SPICY_PERM,            Unlocked = function() return true end},
            {ID = mod.PICKUP.KEY.SUPERSPICY_PERM,       Unlocked = function() return true end},
            {ID = mod.PICKUP.KEY.CHARGEDSPICY_PERM,     Unlocked = function() return Isaac.GetPersistentGameData():Unlocked(Achievement.CHARGED_KEY) end},
            {ID = 2551,                                 Unlocked = function() return dvneha end},
            {ID = 2552,                                 Unlocked = function() return dvneha end},
        },
        ["SpadesBetter"] = {
            {ID = KeySubType.KEY_GOLDEN,                Unlocked = function() return true end},
            {ID = KeySubType.KEY_DOUBLEPACK,            Unlocked = function() return true end},
            {ID = KeySubType.KEY_CHARGED,               Unlocked = function() return Isaac.GetPersistentGameData():Unlocked(Achievement.CHARGED_KEY) end},
            {ID = mod.PICKUP.KEY.SUPERSPICY_PERM,       Unlocked = function() return true end},
            {ID = mod.PICKUP.KEY.CHARGEDSPICY_PERM,     Unlocked = function() return Isaac.GetPersistentGameData():Unlocked(Achievement.CHARGED_KEY) end},
        },
        ["SpadesBest"] = {
            {ID = KeySubType.KEY_GOLDEN,                Unlocked = function() return true end},
            {ID = KeySubType.KEY_DOUBLEPACK,            Unlocked = function() return true end},
            {ID = KeySubType.KEY_CHARGED,               Unlocked = function() return Isaac.GetPersistentGameData():Unlocked(Achievement.CHARGED_KEY) end},
        },
        ["Hearts"] = {
            {ID = HeartSubType.HEART_FULL,              Unlocked = function() return true end},
            {ID = HeartSubType.HEART_HALF,              Unlocked = function() return true end},
            {ID = HeartSubType.HEART_SOUL,              Unlocked = function() return true end},
            {ID = HeartSubType.HEART_ETERNAL,           Unlocked = function() return true end},
            {ID = HeartSubType.HEART_DOUBLEPACK,        Unlocked = function() return true end},
            {ID = HeartSubType.HEART_BLACK,             Unlocked = function() return true end},
            {ID = HeartSubType.HEART_GOLDEN,            Unlocked = function() return Isaac.GetPersistentGameData():Unlocked(Achievement.GOLDEN_HEARTS) end},
            {ID = HeartSubType.HEART_HALF_SOUL,         Unlocked = function() return Isaac.GetPersistentGameData():Unlocked(Achievement.EVERYTHING_IS_TERRIBLE) end},
            {ID = HeartSubType.HEART_SCARED,            Unlocked = function() return Isaac.GetPersistentGameData():Unlocked(Achievement.SCARED_HEART) end},
            {ID = HeartSubType.HEART_BLENDED,           Unlocked = function() return true end},
            {ID = HeartSubType.HEART_BONE,              Unlocked = function() return Isaac.GetPersistentGameData():Unlocked(Achievement.BONE_HEARTS) end},
            {ID = HeartSubType.HEART_ROTTEN,            Unlocked = function() return Isaac.GetPersistentGameData():Unlocked(Achievement.ROTTEN_HEARTS) end},
            {ID = {Var = mod.PICKUP.VARIANT.HALF_BLACK_HEART,       Sub = 0},   Unlocked = function() return true end},
            {ID = {Var = mod.PICKUP.VARIANT.BLENDED_BLACK_HEART,    Sub = 0},   Unlocked = function() return true end},
            {ID = {Var = mod.PICKUP.VARIANT.IMMORAL_HEART,          Sub = 0},   Unlocked = function() return mod.ACHIEVEMENT.IMMORAL_HEART:IsUnlocked() end},
            {ID = {Var = mod.PICKUP.VARIANT.HALF_IMMORAL_HEART,     Sub = 0},   Unlocked = function() return mod.ACHIEVEMENT.IMMORAL_HEART:IsUnlocked() end},
            {ID = {Var = mod.PICKUP.VARIANT.BLENDED_IMMORAL_HEART,  Sub = 0},   Unlocked = function() return mod.ACHIEVEMENT.IMMORAL_HEART:IsUnlocked() end},
            {ID = {Var = mod.PICKUP.VARIANT.MORBID_HEART,           Sub = 0},   Unlocked = function() return mod.ACHIEVEMENT.MORBID_HEART:IsUnlocked() end},
            {ID = {Var = mod.PICKUP.VARIANT.TWOTHIRDS_MORBID_HEART, Sub = 0},   Unlocked = function() return mod.ACHIEVEMENT.MORBID_HEART:IsUnlocked() end},
            {ID = {Var = mod.PICKUP.VARIANT.THIRD_MORBID_HEART,     Sub = 0},   Unlocked = function() return mod.ACHIEVEMENT.MORBID_HEART:IsUnlocked() end},
            {ID = {Var = mod.PICKUP.VARIANT.FOOLS_GOLD_HEART,       Sub = 0},   Unlocked = function() return mod.ACHIEVEMENT.FOOLS_GOLD_HEART:IsUnlocked() end},
            {ID = {Var = mod.PICKUP.VARIANT.STEVEN_HEART,           Sub = 0},   Unlocked = function() return Isaac.GetPersistentGameData():Unlocked(Achievement.STEVEN) end},
        },
        ["HeartsNoBlack"] = {
            {ID = HeartSubType.HEART_FULL,              Unlocked = function() return true end},
            {ID = HeartSubType.HEART_HALF,              Unlocked = function() return true end},
            {ID = HeartSubType.HEART_SOUL,              Unlocked = function() return true end},
            {ID = HeartSubType.HEART_ETERNAL,           Unlocked = function() return true end},
            {ID = HeartSubType.HEART_DOUBLEPACK,        Unlocked = function() return true end},
            {ID = HeartSubType.HEART_GOLDEN,            Unlocked = function() return Isaac.GetPersistentGameData():Unlocked(Achievement.GOLDEN_HEARTS) end},
            {ID = HeartSubType.HEART_HALF_SOUL,         Unlocked = function() return Isaac.GetPersistentGameData():Unlocked(Achievement.EVERYTHING_IS_TERRIBLE) end},
            {ID = HeartSubType.HEART_SCARED,            Unlocked = function() return Isaac.GetPersistentGameData():Unlocked(Achievement.SCARED_HEART) end},
            {ID = HeartSubType.HEART_BLENDED,           Unlocked = function() return true end},
            {ID = HeartSubType.HEART_BONE,              Unlocked = function() return Isaac.GetPersistentGameData():Unlocked(Achievement.BONE_HEARTS) end},
            {ID = HeartSubType.HEART_ROTTEN,            Unlocked = function() return Isaac.GetPersistentGameData():Unlocked(Achievement.ROTTEN_HEARTS) end},
            {ID = {Var = mod.PICKUP.VARIANT.IMMORAL_HEART,          Sub = 0},   Unlocked = function() return mod.ACHIEVEMENT.IMMORAL_HEART:IsUnlocked() end},
            {ID = {Var = mod.PICKUP.VARIANT.HALF_IMMORAL_HEART,     Sub = 0},   Unlocked = function() return mod.ACHIEVEMENT.IMMORAL_HEART:IsUnlocked() end},
            {ID = {Var = mod.PICKUP.VARIANT.BLENDED_IMMORAL_HEART,  Sub = 0},   Unlocked = function() return mod.ACHIEVEMENT.IMMORAL_HEART:IsUnlocked() end},
            {ID = {Var = mod.PICKUP.VARIANT.MORBID_HEART,           Sub = 0},   Unlocked = function() return mod.ACHIEVEMENT.MORBID_HEART:IsUnlocked() end},
            {ID = {Var = mod.PICKUP.VARIANT.TWOTHIRDS_MORBID_HEART, Sub = 0},   Unlocked = function() return mod.ACHIEVEMENT.MORBID_HEART:IsUnlocked() end},
            {ID = {Var = mod.PICKUP.VARIANT.THIRD_MORBID_HEART,     Sub = 0},   Unlocked = function() return mod.ACHIEVEMENT.MORBID_HEART:IsUnlocked() end},
            {ID = {Var = mod.PICKUP.VARIANT.STEVEN_HEART,           Sub = 0},   Unlocked = function() return Isaac.GetPersistentGameData():Unlocked(Achievement.STEVEN) end},
            {ID = {Var = mod.PICKUP.VARIANT.FOOLS_GOLD_HEART,       Sub = 0},   Unlocked = function() return mod.ACHIEVEMENT.FOOLS_GOLD_HEART:IsUnlocked() end},

        },
    }
    
    function mod:useThreeCard(card, player, flags)
        local name = string.sub(Isaac.GetItemConfig():GetCard(card).Name, 10)
        local r = player:GetCardRNG(card)
        local Vec = RandomVector():Resized(40)
        local persistentData = Isaac.GetPersistentGameData()

        for i = 120, 360, 120 do
            local pickupChoice
            if mod.UnbiasedPickups[name] then
                local dynamicPool = {}
                for _, data in pairs(mod.UnbiasedPickups[name]) do
                    if data.Unlocked() then
                        if not data.Chance or r:RandomFloat() < data.Chance then -- Biased unbiased pickups??
                            table.insert(dynamicPool, data.ID)
                        end
                    end
                end
                pickupChoice = dynamicPool[r:RandomInt(#dynamicPool) + 1]
            elseif name == "Cups" then
                local coloursNum = persistentData:Unlocked(Achievement.GOLDEN_PILLS) and 14 or 13
                pickupChoice = r:RandomInt(coloursNum) + 1
                if r:RandomInt(2) == 1 and persistentData:Unlocked(Achievement.HORSE_PILLS) then
                    pickupChoice = pickupChoice + 2048
                end
            elseif name == "Pentacles" then
                pickupChoice = 0
                FiendFolio.UsedPentacles = true
            end
            local pickup
            if tonumber(pickupChoice) then
                pickup = Isaac.Spawn(5, mod.CardNamePickups[name], pickupChoice, Game():GetRoom():FindFreePickupSpawnPosition(player.Position + Vec:Rotated(i)), nilvector, player)
            else
                pickup = Isaac.Spawn(5, pickupChoice.Var, pickupChoice.Sub, Game():GetRoom():FindFreePickupSpawnPosition(player.Position + Vec:Rotated(i)), nilvector, player)
            end
            if name == "Pentacles" then
                local randChance = 1
                local tryGold, tryBlaspheme
                if persistentData:Unlocked(Achievement.GOLDEN_TRINKETS) then
                    randChance = randChance + 1
                    tryGold = true
                end
                if mod.ACHIEVEMENT.BLASPHEMOUS_TRINKETS:IsUnlocked() then
                    randChance = randChance + 1
                    tryBlaspheme = true
                end
                if tryGold then
                    pickup = pickup:ToPickup()
                    if r:RandomInt(randChance) == 1 then
                        pickup:Morph(5, 350, pickup.SubType + TrinketType.TRINKET_GOLDEN_FLAG, false)
                    end
                end
                if tryBlaspheme then
                    pickup = pickup:ToPickup()
                    if r:RandomInt(randChance) == 1 then
                        mod:MakePickupTrinketBlasphemous(pickup)
                    end
                end
            end
        end
        if name == "Clubs" then
            FiendFolio:trySayAnnouncerLine(mod.Sounds.VACardPlayingThreeClubs, flags, 40)
        elseif name == "Cups" then
            FiendFolio:trySayAnnouncerLine(mod.Sounds.VACardPlayingThreeCups, flags, 40)
        elseif name == "Diamonds" then
            FiendFolio:trySayAnnouncerLine(mod.Sounds.VACardPlayingThreeDiamonds, flags, 40)
        elseif name == "Hearts" then
            FiendFolio:trySayAnnouncerLine(mod.Sounds.VACardPlayingThreeHearts, flags, 40)
        elseif name == "Pentacles" then
            FiendFolio:trySayAnnouncerLine(mod.Sounds.VACardPlayingThreePentacles, flags, 40)
        elseif name == "Spades" then
            FiendFolio:trySayAnnouncerLine(mod.Sounds.VACardPlayingThreeSpades, flags, 40)
        end
    end
    
    mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.useThreeCard, mod.ITEM.CARD.THREE_OF_CLUBS)
    mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.useThreeCard, mod.ITEM.CARD.THREE_OF_DIAMONDS)
    mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.useThreeCard, mod.ITEM.CARD.THREE_OF_SPADES)
    mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.useThreeCard, mod.ITEM.CARD.THREE_OF_HEARTS)
    
    mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.useThreeCard, mod.ITEM.CARD.THREE_OF_PENTACLES)
    mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.useThreeCard, mod.ITEM.CARD.THREE_OF_CUPS)
    
    mod.threeSwordsFams = {
        43, 73, 201, 228, mod.ITEM.FAMILIAR.ATTACK_SKUZZ, mod.ITEM.FAMILIAR.BLUE_BEETLE, mod.ITEM.FAMILIAR.FRAGILE_BOBBY, mod.ITEM.FAMILIAR.FAIRY_FLY_1
    }
    mod.threeSwordsPoops = {
        0, 1, 2, 3, 4, 5, 6, 12, 13, 14, 20, 666, 667, 668, 669, 670, 671, 672, 673, 674, 675
    }
    
    function mod:useThreeSwords(card, player, flags)
        local r = player:GetCardRNG(card)
        local Vec = RandomVector():Resized(40)
        for i = 120, 360, 120 do
            local choiceVar = mod.threeSwordsFams[r:RandomInt(#mod.threeSwordsFams) + 1]
            local choiceSub = 0
    
            --Attack Flies
            if choiceVar == 43 then
                local subChoice = r:RandomInt(7)
                if subChoice == 6 then
                    choiceSub = mod.ITEM.FAMILIAR.MINI_LEVEL_0_FLY
                else
                    choiceSub = subChoice
                end
            --Blue Spiders
            elseif choiceVar == 73 then
                if r:RandomInt(2) == 1 then
                    choiceSub = mod.ITEM.FAMILIAR.BLUE_BABY_SPIDER_SUBTYPE
                end
            --Poopies
            elseif choiceVar == 201 then
                choiceSub = mod.threeSwordsPoops[r:RandomInt(#mod.threeSwordsPoops) + 1]
            elseif choiceVar == mod.ITEM.FAMILIAR.ATTACK_SKUZZ then
                choiceSub = r:RandomInt(5)
            elseif choiceVar == mod.ITEM.FAMILIAR.FAIRY_FLY_1 then
                local rand = r:RandomInt(3)
                if rand == 1 then
                    choiceVar = mod.ITEM.FAMILIAR.FAIRY_FLY_2
                elseif rand == 2 then
                    choiceVar = mod.ITEM.FAMILIAR.FAIRY_FLY_3
                end
            elseif choiceVar == mod.ITEM.FAMILIAR.FRAGILE_BOBBY then
                choiceSub = r:RandomInt(2)
            elseif choiceVar == mod.ITEM.FAMILIAR.BLUE_BEETLE then
                choiceSub = r:RandomInt(5)
            end
            local pickup = Isaac.Spawn(3, choiceVar, choiceSub, Game():GetRoom():FindFreePickupSpawnPosition(player.Position + Vec:Rotated(i)), nilvector, player)
        end
        FiendFolio:trySayAnnouncerLine(mod.Sounds.VACardPlayingThreeSwords, flags, 40)
    end
    mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.useThreeSwords, mod.ITEM.CARD.THREE_OF_SWORDS)
    