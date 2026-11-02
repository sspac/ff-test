local mod = FiendFolio

--See examples of how to use these at the bottom of the file
--FiendFolio:AddShampooBottleItemText(typeString, id, textTable)
--FiendFolio:AddShampooBottleEnemyText(enemyType, enemyVariant, enemySubType, textTable)
--FiendFolio:AddShampooBottlePlayerText(playerType, textTable)

local validTypeStrings = {
    "collectible",  --CollectibleType.COLLECTIBLE_SAD_ONION
    "trinket",      --TrinketType.TRINKET_SWALLOWED_PENNY
    "card",         --Card.CARD_FOOL
    "cardback",     --CardPickupSubtype.TAROT
    "pilleffect",   --PillEffect.PILLEFFECT_BAD_GAS
    "pillcolor",    --PillColor.PILL_BLUE_BLUE
}

local typeStringToIndex = {
    --Items have four response types
    --Found triggers when discovered
    --PickedUp triggers when, well, picked up by the player
    --Idle triggers randomly while held (only for Items and Trinkets)
    --Used triggers when used (active items, cards, pills)

    --Text table format:
    --{Found = {}, PickedUp = {}, Idle = {}, Used = {}}
    --Each trigger is a table itself, for multiple responses, such as
    --[[
        Found = {
            {"line 1"},
            {"line 2"},
        }
    ]]

    --{Found = {}, PickedUp = {}, Idle = {}, Used = {}}
    ["collectible"] = "Collectibles",

    --{Found = {}, PickedUp = {}, Idle = {}}
    ["trinket"]     = "Trinkets",

    --This refers to cards when held, you can see specifically what they are
    --{PickedUp = {}, Used = {}}
    ["card"]        = "Cards",

    --This refers to cards on the ground, being the back of the card
    --The expected ID is whatever "pickup" is set to in the pocketitems xml
    --{} --Just goes in as is, it triggers like Found
    ["cardback"]    = "CardBacks",

    --This is pill effects, like bad gas, tears up, etc.
    --{} --Just goes in as is, it triggers like Used
    ["pilleffect"]  = "Pills",

    --The variant of the pill's pickup itself,
    --Typically unneeded, but useful for stuff like the cyanide pill
    --{} --Just goes in as is, it triggers like Found
    ["pillcolor"]   = "PillColor",
}

local awkwardIndexes = {
    ["CardBacks"] = true,
    ["Pills"] = true,
    ["PillColor"] = true,
}

local ItemTriggers = {
    "Found",
    "PickedUp",
    "Idle",
    "Used",
}
function FiendFolio:AddShampooBottleItemText(typeString, id, textTable)
    local index = typeStringToIndex[typeString]
    if FiendFolio.ShampooBottleTextItems[index] then
        FiendFolio.ShampooBottleTextItems[index][id] = FiendFolio.ShampooBottleTextItems[index][id] or {}
        if awkwardIndexes[index] then
            for k = 1, #textTable do
                table.insert(FiendFolio.ShampooBottleTextItems[index][id], textTable[k])
            end
        else
            for i = 1, #ItemTriggers do
                local triggerString = ItemTriggers[i]
                if textTable[triggerString] then
                    FiendFolio.ShampooBottleTextItems[index][id][triggerString] = FiendFolio.ShampooBottleTextItems[index][id][triggerString] or {}
                    for k = 1, #textTable[triggerString] do
                        table.insert(FiendFolio.ShampooBottleTextItems[index][id][triggerString], textTable[triggerString][k])
                    end
                end
            end
        end
    end
end

local EnemyTriggers = {
    "Idle",
    "Killed",
    "HitBy",
}
--You can add response lines gradually
--Something more specific overrides others
--ie. A 10.12.1 Gaper has specific lines for only it
--    A 10.12.2 Gaper otherwise can use the generic lines other gapers with variant 12 use
--    A 10.13 Gaper otherwise can use the generic lines other enemies under type 10 use
function FiendFolio:AddShampooBottleEnemyText(enemyType, enemyVariant, enemySubType, textTable)
    FiendFolio.ShampooBottleTextEnemies[enemyType] = FiendFolio.ShampooBottleTextEnemies[enemyType] or {}
    local usedTable = FiendFolio.ShampooBottleTextEnemies[enemyType]
    if enemyVariant then
        FiendFolio.ShampooBottleTextEnemies[enemyType][enemyVariant] = FiendFolio.ShampooBottleTextEnemies[enemyType][enemyVariant] or {}
        usedTable = FiendFolio.ShampooBottleTextEnemies[enemyType][enemyVariant]
        if enemySubType then
            FiendFolio.ShampooBottleTextEnemies[enemyType][enemyVariant][enemySubType] = FiendFolio.ShampooBottleTextEnemies[enemyType][enemyVariant][enemySubType] or {}
            usedTable = FiendFolio.ShampooBottleTextEnemies[enemyType][enemyVariant][enemySubType]
        end
    end
    for i = 1, #EnemyTriggers do
        local triggerString = EnemyTriggers[i]
        if textTable[triggerString] then
            usedTable[triggerString] = usedTable[triggerString] or {}
            for k = 1, #textTable[triggerString] do
                table.insert(usedTable[triggerString], textTable[triggerString][k])
            end
        end
    end
end

function FiendFolio:AddShampooBottlePlayerText(playerType, textTable)
    FiendFolio.ShampooBottleTextItems.Players[playerType] = FiendFolio.ShampooBottleTextItems.Players[playerType] or {}
    for k = 1, #textTable do
        table.insert(FiendFolio.ShampooBottleTextItems.Players[playerType], textTable[k])
    end
end

--Using some other mods for examples
FiendFolio.scheduleForUpdate(function()
    if battleFantasy then
        FiendFolio:AddShampooBottleItemText("collectible", battleFantasy.Items.BF_MOMS_SHAMPOO,
        {
            Found = {
                {"woah, look at that bottle...", "she's so gorgeous..."},
                {"woah uh, forgive me for getting flustered", "but... look at that bottle..."},
                {"phew, i'm getting hot under my cap", "that's the prettiest bottle i ever saw"},
            },
            PickedUp = {
                {"dude... you know mom", "can you tell me about her?"},
                {"hey uh, you belong to mom, right?", "how do i get that gig?"},
                {"hey um, i just want to say", "you're the nicest bottle i ever saw"},
                {"forgive me for being forward", "but i'd really like to get to know you..."},
                {"hey um, i like your suds...", "they're really cool..."},
                {"hey um, mom's shampoo, is it?", "i'm the shampoo bottle, nice to, uh, meet you"},
            },
            Idle = {
                {"don't worry about me", "i'm getting to know mom's shampoo back here"},
                {"hey, mom's shampoo smells so nice...", "i'll never forget it"},
                {"i'm just leaning on mom's shampoo back here", "she's super comfortable..."},
                {"i could stay here forever", "sitting next to mom's shampoo..."},
                {"this is a comfortable spot", "i'm right next to mom's shampoo..."},
                {"hey uh, mind closing the game soon?", "let me just have a quiet moment with mom's shampoo", "nothing crazy just, y'know, i like her presence..."},
            },
        })
        --Using Isaac an an example, put your custom characters in here, generally!
        FiendFolio:AddShampooBottlePlayerText(PlayerType.PLAYER_ISAAC, {
            {"It feels like we're in some kind of...", "battle fantasy?"},
            {"I can't wait to battle fantasies with you!"},
        })
    end

    if SomethingWicked then
        FiendFolio:AddShampooBottleItemText("collectible", SomethingWicked.ITEMS.BOTTLE_OF_SHAMPOO,
        {
            Found = {
                {"i don't want to sound too harsh", "but that's one chopped shampoo bottle..."},
                {"hey uh, is that a shampoo bottle?", "or like, a surface cleaner"},
            },
            PickedUp = {
                {"they do give a tears up", "i shouldn't be mean"},
                {"hey well, a tears and speed up", "that is pretty good, i guess"},
                {"i bet this one doesn't give advice", "meaning i'm the better bottle..."},
                {"but i'm still the better shampoo bottle", "right?"},
            },
            --You don't need to include all the categories
            --You can just leave any out, like this!
        })
        --Using Isaac an an example, put your custom characters in here, generally!
        FiendFolio:AddShampooBottlePlayerText(PlayerType.PLAYER_ISAAC, {
            {"Something wicked is going on!"},
            {"Did you do something wicked?", "Things feel... off!"},
        })
        --Using Frowning Gaper as an example, generally use this for your own custom foes!
        FiendFolio:AddShampooBottleEnemyText(EntityType.ENTITY_GAPER, 0, nil, {
            Idle = {
                {"you see that gaper?", "he did something wicked..."},
                {"that's a wicked looking gaper!"},
            },
            Killed = {
                {"that's what you get for being wicked!"}
            },
            HitBy = {
                {"that gaper... it's far too wicked..."}
            },
        })
    end
end, 1, ModCallbacks.MC_INPUT_ACTION, true)