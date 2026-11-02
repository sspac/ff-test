local game = Game()
local itemConfig = Isaac.GetItemConfig()

local statParams = {
    ["Chapter 1"] = {},
    ["Basement"] = {},
    ["Cellar"] = {},
    ["Burning Basement"] = {},
    ["Chapter 1.5"] = {},
    ["Downpour"] = {},
    ["Dross"] = {},

    ["Chapter 2"] = {},
    ["Caves"] = {},
    ["Catacombs"] = {},
    ["Flooded Caves"] = {},
    ["Chapter 2.5 Damage"] = {CollectibleType.COLLECTIBLE_PENTAGRAM},
    ["Mines Damage"] = {CollectibleType.COLLECTIBLE_PENTAGRAM},
    ["Ashpit Damage"] = {CollectibleType.COLLECTIBLE_PENTAGRAM},
    
    ["Chapter 2.5 Tears"] = {CollectibleType.COLLECTIBLE_SAD_ONION},
    ["Mines Tears"] = {CollectibleType.COLLECTIBLE_SAD_ONION},
    ["Ashpit Tears"] = {CollectibleType.COLLECTIBLE_SAD_ONION},

    ["Chapter 3"] = {CollectibleType.COLLECTIBLE_PENTAGRAM},

    ["Chapter 3 Damage"] = {CollectibleType.COLLECTIBLE_PENTAGRAM},
    ["Depths Damage"] = {CollectibleType.COLLECTIBLE_PENTAGRAM},
    ["Necropolis Damage"] = {CollectibleType.COLLECTIBLE_PENTAGRAM},
    ["Dank Depths Damage"] = {CollectibleType.COLLECTIBLE_PENTAGRAM},
    ["Chapter 3.5"] = {CollectibleType.COLLECTIBLE_SAD_ONION, CollectibleType.COLLECTIBLE_SAD_ONION, CollectibleType.COLLECTIBLE_PENTAGRAM},
    ["Mausoleum"] = {CollectibleType.COLLECTIBLE_SAD_ONION, CollectibleType.COLLECTIBLE_SAD_ONION, CollectibleType.COLLECTIBLE_PENTAGRAM},
    ["Gehenna"] = {CollectibleType.COLLECTIBLE_SAD_ONION, CollectibleType.COLLECTIBLE_SAD_ONION, CollectibleType.COLLECTIBLE_PENTAGRAM},

    ["Chapter 3 Tears"] = {CollectibleType.COLLECTIBLE_SAD_ONION},
    ["Depths Tears"] = {CollectibleType.COLLECTIBLE_SAD_ONION},
    ["Necropolis Tears"] = {CollectibleType.COLLECTIBLE_SAD_ONION},
    ["Dank Depths Tears"] = {CollectibleType.COLLECTIBLE_SAD_ONION},

    ["Chapter 4"] = {CollectibleType.COLLECTIBLE_PENTAGRAM, CollectibleType.COLLECTIBLE_SAD_ONION},
    ["Womb"] = {CollectibleType.COLLECTIBLE_PENTAGRAM, CollectibleType.COLLECTIBLE_SAD_ONION},
    ["Utero"] = {CollectibleType.COLLECTIBLE_PENTAGRAM, CollectibleType.COLLECTIBLE_SAD_ONION},
    ["Scarred Womb"] = {CollectibleType.COLLECTIBLE_PENTAGRAM, CollectibleType.COLLECTIBLE_SAD_ONION},
    ["Corpse"] = {CollectibleType.COLLECTIBLE_SAD_ONION, CollectibleType.COLLECTIBLE_SAD_ONION, CollectibleType.COLLECTIBLE_PENTAGRAM, CollectibleType.COLLECTIBLE_PENTAGRAM},

    ["Blue Womb"] = {CollectibleType.COLLECTIBLE_STEVEN, CollectibleType.COLLECTIBLE_STEVEN, CollectibleType.COLLECTIBLE_STEVEN,
        CollectibleType.COLLECTIBLE_MEAT, CollectibleType.COLLECTIBLE_MEAT, CollectibleType.COLLECTIBLE_SAD_ONION, CollectibleType.COLLECTIBLE_SAD_ONION},
    ["???"] = {CollectibleType.COLLECTIBLE_STEVEN, CollectibleType.COLLECTIBLE_STEVEN, CollectibleType.COLLECTIBLE_STEVEN,
    CollectibleType.COLLECTIBLE_MEAT, CollectibleType.COLLECTIBLE_MEAT, CollectibleType.COLLECTIBLE_SAD_ONION, CollectibleType.COLLECTIBLE_SAD_ONION},

    ["Chapter 5"] = {CollectibleType.COLLECTIBLE_PENTAGRAM, CollectibleType.COLLECTIBLE_PENTAGRAM, CollectibleType.COLLECTIBLE_SAD_ONION, CollectibleType.COLLECTIBLE_SAD_ONION},
    ["Cathedral"] = {CollectibleType.COLLECTIBLE_PENTAGRAM, CollectibleType.COLLECTIBLE_PENTAGRAM, CollectibleType.COLLECTIBLE_SAD_ONION, CollectibleType.COLLECTIBLE_SAD_ONION},
    ["Sheol"] = {CollectibleType.COLLECTIBLE_PENTAGRAM, CollectibleType.COLLECTIBLE_PENTAGRAM, CollectibleType.COLLECTIBLE_SAD_ONION, CollectibleType.COLLECTIBLE_SAD_ONION},

    ["Chapter 6"] = {CollectibleType.COLLECTIBLE_PENTAGRAM, CollectibleType.COLLECTIBLE_PENTAGRAM, CollectibleType.COLLECTIBLE_SAD_ONION, 
        CollectibleType.COLLECTIBLE_SAD_ONION, CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM},
    ["Chest"] = {CollectibleType.COLLECTIBLE_PENTAGRAM, CollectibleType.COLLECTIBLE_PENTAGRAM, CollectibleType.COLLECTIBLE_SAD_ONION, 
    CollectibleType.COLLECTIBLE_SAD_ONION, CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM},
    ["Dark Room"] = {CollectibleType.COLLECTIBLE_PENTAGRAM, CollectibleType.COLLECTIBLE_PENTAGRAM, CollectibleType.COLLECTIBLE_SAD_ONION, 
    CollectibleType.COLLECTIBLE_SAD_ONION, CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM},
    
    ["Void"] = {CollectibleType.COLLECTIBLE_CHAMPION_BELT, CollectibleType.COLLECTIBLE_PENTAGRAM, CollectibleType.COLLECTIBLE_SAD_ONION,
    CollectibleType.COLLECTIBLE_SAD_ONION, CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM},
    ["Ascent"] = {CollectibleType.COLLECTIBLE_SAD_ONION, CollectibleType.COLLECTIBLE_SAD_ONION, CollectibleType.COLLECTIBLE_PENTAGRAM, CollectibleType.COLLECTIBLE_PENTAGRAM},
}

local stbToStats = {
    [StbType.BASEMENT] = statParams["Chapter 1"],
    [StbType.CELLAR] = statParams["Chapter 1"],
    [StbType.BURNING_BASEMENT] = statParams["Chapter 1"],

    [StbType.CAVES] = statParams["Chapter 2"],
    [StbType.CATACOMBS] = statParams["Chapter 2"],
    [StbType.FLOODED_CAVES] = statParams["Chapter 2"],

    [StbType.DEPTHS] = statParams["Chapter 3 Damage"],
    [StbType.NECROPOLIS] = statParams["Chapter 3 Damage"],
    [StbType.DANK_DEPTHS] = statParams["Chapter 3 Damage"],

    [StbType.WOMB] = statParams["Chapter 4"],
    [StbType.UTERO] = statParams["Chapter 4"],
    [StbType.SCARRED_WOMB] = statParams["Chapter 4"],

    [StbType.BLUE_WOMB] = statParams["Blue Womb"],

    [StbType.SHEOL] = statParams["Chapter 5"],
    [StbType.CATHEDRAL] = statParams["Chapter 5"],

    [StbType.DARK_ROOM] = statParams["Chapter 6"],
    [StbType.CHEST] = statParams["Chapter 6"],

    [StbType.DOWNPOUR] = statParams["Chapter 1"],
    [StbType.DROSS] = statParams["Chapter 1"],

    [StbType.MINES] = statParams["Mines Damage"],
    [StbType.ASHPIT] = statParams["Ashpit Damage"],

    [StbType.MAUSOLEUM] = statParams["Mausoleum"],
    [StbType.GEHENNA] = statParams["Gehenna"],

    [StbType.CORPSE] = statParams["Corpse"],

    [StbType.VOID] = statParams["Void"],

    [StbType.ASCENT] = statParams["Ascent"],
    [StbType.HOME] = statParams["Ascent"]
}

local function statsCommand(_, command, parameters)
    local player = Isaac.GetPlayer()
    if command == "stats" then
        for name, items in pairs(statParams) do
            if parameters and parameters ~= "" and parameters:lower() == name:lower() then
                for _, item in ipairs(items) do
                    player:AddCollectible(item)
                end

                print("Added", #items, "item(s) to player one! Type \"clearitems\" to remove all items.")
                return
            elseif not parameters or parameters == "" then
                local stageStb = Isaac.GetCurrentStageConfigId()
                if BasementRenovator and stageStb == StbType.BLUE_WOMB then
                    stageStb = StbType.ASCENT
                end
                local itemsToUse = stbToStats[stageStb]
                for _, item in ipairs(itemsToUse) do
                    player:AddCollectible(item)
                end

                print("Added", #itemsToUse, "item(s) to player one! Type \"clearitems\" to remove all items.")
                return
            end
        end
    end

    if command == "clearitems" then
        local history = player:GetHistory():GetCollectiblesHistory()
        for _, item in ipairs(history) do
            if item:IsTrinket() then
                player:TryRemoveSmeltedTrinket(item:GetItemID())
            else
                player:RemoveCollectible(item:GetItemID())
            end
        end

        print("Cleared", #history, "item(s) from player one!")
    end

    if command == "lagthefuckoutoftheroomwithcreep" then
        local fly = Isaac.Spawn(EntityType.ENTITY_FLY, 0, 0, game:GetRoom():GetCenterPos(), Vector.Zero, nil)
        for index = 0, game:GetRoom():GetGridSize() do
            local pos = game:GetRoom():GetGridPosition(index)
            if game:GetRoom():IsPositionInRoom(pos, 0) then
                for _ = 1, 30 do
                    local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, pos, Vector.Zero, fly):ToEffect()
                    creep:SetTimeout(999999999999)
                end
            end
        end
    end

    if command == "blasphemous" then
		local id = tonumber(parameters)
		if id and itemConfig:GetTrinket(id) then
            local slot = player:GetTrinket(1) ~= 0 and 1 or 0
            if player:GetMaxTrinkets() > 1 and slot == 0 then
                slot = 1 
            else
                player:TryRemoveTrinket(player:GetTrinket(0))
            end
            player:AddTrinket(id, true)
            FiendFolio:MakePlayerTrinketBlasphemous(player, slot)
        end
	end
end

FiendFolio:AddCallback(ModCallbacks.MC_EXECUTE_CMD, statsCommand)

local function handleStatsAutocomplete(_, command, params)
    local t = {}
    for name in pairs(statParams) do
        t[#t+1] = name
    end

    return t
end

FiendFolio:AddCallback(ModCallbacks.MC_CONSOLE_AUTOCOMPLETE, handleStatsAutocomplete, "stats")

local function handleBlasphemousAutocomplete(_, command, params)
    local t = {}
    local trinkets = itemConfig:GetTrinkets()
    for id = 0, trinkets.Size do
        local trinket = itemConfig:GetTrinket(id)
        if trinket and trinket:IsTrinket() then
            local name = Isaac.GetString("Items", trinket.Name)
            if name == "StringTable::InvalidKey" then
                name = trinket.Name
            end
            t[#t+1] = {trinket.ID, name}
        end
    end

    return t
end

FiendFolio:AddCallback(ModCallbacks.MC_CONSOLE_AUTOCOMPLETE, handleBlasphemousAutocomplete, "blasphemous")

Console.RegisterCommand(
    "stats",
    "Give items for a good stat reference for the given floor",
    "stats <floor>",
    true,
    AutocompleteType.CUSTOM
)

Console.RegisterCommand(
    "clearitems",
    "Clears all items from your inventory",
    "clearitems",
    true,
    AutocompleteType.NONE
)

Console.RegisterCommand(
    "blasphemous",
    "Gives a blasphemous trinket, as long as the trinket is allowed to be one.",
    "blashphemous <trinketId>",
    true,
    AutocompleteType.CUSTOM

)