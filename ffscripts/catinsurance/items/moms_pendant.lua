local mod = FiendFolio
local game = Game()

-- mods can add their own curses to this
-- you can add either a curse id (Isaac.GetCurseIdByName) or a function
-- if you add a function, return the curse id for the item to use that curse
-- return nil or false for it to not use that curse 
mod.ValidMomsPendantCurses = {
    LevelCurse.CURSE_OF_DARKNESS,
    LevelCurse.CURSE_OF_BLIND,
    LevelCurse.CURSE_OF_MAZE,
    LevelCurse.CURSE_OF_THE_LOST,
    LevelCurse.CURSE_OF_THE_UNKNOWN
}

FiendFolio.AddItemPickupCallback(function (player)
    local effects = player:GetEffects()
    effects:AddCollectibleEffect(mod.ITEM.COLLECTIBLE.MOMS_PENDANT, 1)
end, nil, mod.ITEM.COLLECTIBLE.MOMS_PENDANT)

function mod:GetMomsPendantCurse()
    local curseRNG = PlayerManager.FirstCollectibleOwner(mod.ITEM.COLLECTIBLE.MOMS_PENDANT):GetCollectibleRNG(mod.ITEM.COLLECTIBLE.MOMS_PENDANT)

    -- handle custom curses first

    -- all curses have an equal chance of occurring
    -- this is set-up so curses will follow this logic
    local numFFCurses = 2
    local curseChance = 1 / (6 + numFFCurses)

    local randCurse = curseRNG:RandomFloat()
    if FiendFolio.CustomCursesEnabled and randCurse < curseChance then
        -- Curse of the Gate
        if not (mod:isInvalidGateFloor(false) or mod:isInvalidGateChallenge()) then
            return 1 << (FiendFolio.curses.gateCurse - 1)
        end
    elseif FiendFolio.CustomCursesEnabled and randCurse < curseChance * 2 then
        -- Curse of the Veil
        if not (mod.anyPlayerHas(CollectibleType.COLLECTIBLE_GUPPYS_EYE)) then
            return 1 << (FiendFolio.curses.veilCurse - 1)
        end
    else
        -- roll for a vanilla curse until we have a valid one
        local valid = {table.unpack(mod.ValidMomsPendantCurses)}
        while true do
            if #valid == 0 then
                return    
            end

            local choiceIdx = curseRNG:RandomInt(#valid) + 1
            local nominee = valid[choiceIdx]
            local choice
            if type(nominee) == "function" then
                nominee = choice()
                if type(nominee) == "number" then
                    choice = nominee
                end
            else
                choice = nominee
            end

            if choice then
                return choice
            else
                table.remove(valid, choiceIdx)
            end
        end
    end
end

function mod:AddMomsPendantCurse()
    local addCurses = 0
    for _, player in ipairs(PlayerManager.GetPlayers()) do
        local effects = player:GetEffects()
        if effects:HasCollectibleEffect(mod.ITEM.COLLECTIBLE.MOMS_PENDANT) and player:HasCollectible(mod.ITEM.COLLECTIBLE.MOMS_PENDANT) then
            local count = effects:GetCollectibleEffectNum(mod.ITEM.COLLECTIBLE.MOMS_PENDANT)
            addCurses = addCurses + count

            effects:RemoveCollectibleEffect(mod.ITEM.COLLECTIBLE.MOMS_PENDANT, -1)
        end
    end

    -- Don't do the effect with Black Candle or Black Candelabra
    if FiendFolio:HasCurseImmunity() then
        return
    end

    if addCurses > 0 then
        local curse = mod:GetMomsPendantCurse()
        if curse then
            local level = game:GetLevel()
            level:AddCurse(curse, false)
        end
    end
end
-- Run this early so that other curse-initializing callbacks can run
mod:AddPriorityCollectibleCallback(ModCallbacks.MC_POST_NEW_LEVEL, CallbackPriority.IMPORTANT, mod.ITEM.COLLECTIBLE.MOMS_PENDANT, mod.AddMomsPendantCurse)