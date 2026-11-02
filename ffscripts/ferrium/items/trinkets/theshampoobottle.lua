local mod = FiendFolio
local theShampooBottle
local game = Game()
local sfx = SFXManager()

mod.shampooDialogue = {}
mod.shampooWaitingDialogue = {}
mod.shampooRobobabyTalking = false
mod.ShampooTesting = false

local shampooOpacity = 0

local font = Font()
font:Load("font/upheaval.fnt")

local textbox = Sprite()
textbox:Load("gfx/effects/shampoo_talking.anm2", true)
textbox.Scale = textbox.Scale
textbox.Color = Color(1,1,1,0)
local textBoxVec = Vector(-7, 48)

mod.ShampooTextbox = textbox

local hasSaidTimeText = false

--Testing
local forceDate = false
local forcedDate = {
    day = 5,
    month = 8
}

local SHAMPOOOFFSET = {
    ROBOBABY   = Vector(0,128),
    CHRISTMAS  = Vector(32,0),
    VALENTINES = Vector(64,0),
    HALLOWEEN  = Vector(96,0),
    BIRTHDAY   = Vector(128,0),
    RELEASE   = Vector(128,0),
}

--His birthday is the 24th of February!

local function getShampooCropOffset(dateTime, offset, isTrinket)
    offset = offset or Vector.Zero
    dateTime = dateTime or os.date("*t")
    if forceDate then
        --dateTime = {day = forcedDate.day, month = forcedDate.month}
        dateTime.day = forcedDate.day
        dateTime.month = forcedDate.month
    end
    mod.ShampooDateCache = dateTime

    if (dateTime.day == 24 and dateTime.month == 2)
    or (dateTime.day == 5 and dateTime.month == 8)
    then
        return offset + SHAMPOOOFFSET.BIRTHDAY
    elseif dateTime.day == 14 and dateTime.month == 2 then
        return offset + SHAMPOOOFFSET.VALENTINES
    elseif dateTime.day == 25 and dateTime.month == 12
    or game:GetSeeds():HasSeedEffect(SeedEffect.SEED_CHRISTMAS) then
        return offset + SHAMPOOOFFSET.CHRISTMAS
    elseif mod.SpookingOfIsaacActivated
    or dateTime.day == 31 and dateTime.month == 10
    then
        return offset + SHAMPOOOFFSET.HALLOWEEN
    end
    if isTrinket then
        offset = offset + Vector(-32,0)
    end
    return offset
end

do
    local dateTime = os.date("*t")
    if forceDate then
        --dateTime = {day = forcedDate.day, month = forcedDate.month}
        dateTime.day = forcedDate.day
        dateTime.month = forcedDate.month
    end
    mod.ShampooDateCache = dateTime
    if not mod.shampooRobobabyTalking then
        textbox:GetLayer("icon"):SetCropOffset(getShampooCropOffset(dateTime))
    end
end

function mod:shampooBottleCrop(slot, pos, scale, player, cropOffset)
    if mod:GetRealTrinketId(player:GetTrinket(slot)) == mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE then
        if slot == 1 then
            if mod:GetRealTrinketId(player:GetTrinket(0)) == mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE then
                return {CropOffset = Vector(32,0)}
            end
        end
        mod.ShampooDateCache = mod.ShampooDateCache or os.date("*t")
        return {CropOffset = getShampooCropOffset(mod.ShampooDateCache, Vector(32,0), true)}
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_TRINKET_RENDER, mod.shampooBottleCrop)


StageAPI.AddCallback("FiendFolio", "POST_HUD_RENDER", 1, function(isPauseMenuOpen, pauseMenuDarkPct)
    if (StageAPI ~= nil and StageAPI.PlayingBossSprite) then return end
    if mod.shampooDialogue.Dialogue then
        if mod.shampooRobobabyTalking then
            if not mod.loadedShampooRobobaby then
                mod.loadedShampooRobobaby = true
                textbox:GetLayer("box"):SetCropOffset(SHAMPOOOFFSET.ROBOBABY)
                textbox:GetLayer("icon"):SetCropOffset(SHAMPOOOFFSET.ROBOBABY)
            end
        else
            if mod.loadedShampooRobobaby then
                mod.loadedShampooRobobaby = false
                textbox:GetLayer("box"):SetCropOffset(Vector.Zero)
                textbox:GetLayer("icon"):SetCropOffset(getShampooCropOffset())
            end
        end
        local middlePos = Vector(StageAPI.GetScreenCenterPosition().X, 0)
        local renderpos = middlePos + textBoxVec
        textbox.Color = Color(1,1,1,shampooOpacity * mod:GetFortuneOpacity())
        textbox:Render(renderpos, Vector.Zero, Vector.Zero)

        if mod.shampooDialogue.Dialogue and mod.shampooDialogue.Dialogue[mod.shampooDialogue.TextLine] then
            local dialougetosplit
            local tripsing
            local rendertext = string.sub(mod.shampooDialogue.Dialogue[mod.shampooDialogue.TextLine], 1, math.floor(mod.shampooDialogue.TextCharacters))
            if #mod.shampooDialogue.Dialogue[mod.shampooDialogue.TextLine] > 20 then
                if #mod.shampooDialogue.Dialogue[mod.shampooDialogue.TextLine] > 30 then
                    tripsing = true
                end
                dialougetosplit = mod.shampooDialogue.Dialogue[mod.shampooDialogue.TextLine]
            end

            local blackLerpNess = 0
            blackLerpNess = math.min(1,((1 - mod:GetFortuneOpacity()) * 1.5))
            local xOff = -30
            local kCol = KColor(
                mod:Lerp(51/256, 0, blackLerpNess),
                mod:Lerp(49/256, 0, blackLerpNess),
                mod:Lerp(62/256, 0, blackLerpNess),
            1)

            if dialougetosplit then
                if tripsing then
                    local cutoffspace
                    for j = 2, 8 do
                        for i = math.floor((1 + (j/10))*(#dialougetosplit/3)), 1, -1 do
                            local str = string.sub(dialougetosplit, i, i)
                            --print(i, str, #str)
                            if str == " " then
                                cutoffspace = i
                                break
                            end
                        end
                        if cutoffspace then
                            break
                        end
                    end
                    local targetpos = middlePos + Vector(xOff, textBoxVec.Y - 32)
                    font:DrawStringScaled(string.sub(rendertext, 1, cutoffspace-1), targetpos.X,targetpos.Y,1,1,kCol,50,true)

                    local dialougetosplit2 = string.sub(dialougetosplit, cutoffspace+1, #dialougetosplit)
                    if #dialougetosplit2 > 0 then
                        for j = 2, 8 do
                            for i = math.floor((1 + (j/10))*#dialougetosplit2/2), 1, -1 do
                                local str = string.sub(dialougetosplit2, i, i)
                                --print(i, str, #str)
                                if str == " " then
                                    cutoffspace2 = i
                                    break
                                end
                            end
                            if cutoffspace then
                                break
                            end
                        end
                        cutoffspace2 = cutoffspace2 + cutoffspace

                        targetpos = middlePos + Vector(xOff, textBoxVec.Y - 12)
                        font:DrawStringScaled(string.sub(rendertext, cutoffspace+1, cutoffspace2-1), targetpos.X,targetpos.Y,1,1,kCol,50,true)

                        targetpos = middlePos + Vector(xOff, textBoxVec.Y + 8)
                        font:DrawStringScaled(string.sub(rendertext, cutoffspace2+1, #rendertext), targetpos.X,targetpos.Y,1,1,kCol,50,true)
                    end
                else
                    local cutoffspace
                    for j = 2, 8 do
                        for i = math.floor((1 + (j/10))*#dialougetosplit/2), 1, -1 do
                            local str = string.sub(dialougetosplit, i, i)
                            --print(i, str, #str)
                            if str == " " then
                                cutoffspace = i
                                break
                            end
                        end
                        if cutoffspace then
                            break
                        end
                    end

                    local targetpos = middlePos + Vector(xOff, textBoxVec.Y - 22)
                    font:DrawStringScaled(string.sub(rendertext, 1, cutoffspace-1), targetpos.X,targetpos.Y,1,1,kCol,50,true)

                    targetpos = middlePos + Vector(xOff, textBoxVec.Y - 2)
                    font:DrawStringScaled(string.sub(rendertext, cutoffspace+1, #rendertext), targetpos.X,targetpos.Y,1,1,kCol,50,true)
                end
            else
                local targetpos = middlePos + Vector(xOff, textBoxVec.Y - 12)
                font:DrawStringScaled(rendertext, targetpos.X,targetpos.Y,1,1,kCol,50,true)
            end
        end
    else
        mod.shampooDialogue = {}
        if shampooOpacity > 0 then
            textbox.Color = Color(1,1,1,shampooOpacity * mod:GetFortuneOpacity())
            local middlePos = Vector(StageAPI.GetScreenCenterPosition().X, 0)
            local renderpos = middlePos + textBoxVec
            textbox:Render(renderpos, Vector.Zero, Vector.Zero)
        end
    end
end)

function mod:activateRobobaby(rng, forceRare)
    mod.shampooRobobabyTalking = true
    rng = rng or Isaac.GetPlayer():GetTrinketRNG(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE)
    if rng:RandomInt(7) == 1 or forceRare then
        mod.shampooDialogue.Dialogue = mod.ShampooBottleText.Robobaby2HighPriority[rng:RandomInt(#mod.ShampooBottleText.Robobaby2HighPriority)+1]
    else
        mod.shampooDialogue.Dialogue = mod.ShampooBottleText.Robobaby2Bullshit[rng:RandomInt(#mod.ShampooBottleText.Robobaby2Bullshit)+1]
    end
end

local function eliminateRoboBaby()
    if mod.shampooRobobabyTalking then
        mod.shampooRobobabyTalking = nil
        shampooOpacity = 0
    end
end

local function shampooSetTintedRocks()
    mod.shampooBottleRocks = {}
	for _,grid in ipairs(mod.GetGridEntities()) do
		if grid.CollisionClass == GridCollisionClass.COLLISION_SOLID then
			if grid:GetType() == GridEntityType.GRID_ROCKT then
				mod.shampooBottleRocks[grid:GetGridIndex()] = 4
			end
		end
	end
	return mod.shampooBottleRocks
end

local vowels = {
    ["a"] = true,
    ["e"] = true,
    ["i"] = true,
    ["o"] = true,
    ["u"] = true
}

local function getTextPiece(rng, keystring)
    rng = rng or Isaac.GetPlayer():GetTrinketRNG(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE)
    return FiendFolio.ShampooBottleTextIdle[keystring][rng:RandomInt(#mod.ShampooBottleTextIdle[keystring])+1]
end

function mod:makeIdleComment(rng)
    if not rng then
        rng = Isaac.GetPlayer():GetTrinketRNG(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE)
    end
    if rng:RandomInt(3) == 1 then
        mod:makeShampooText("Idle", rng)
    else
        --Construct a comment
        mod.shampooDialogue = {}
        mod.shampooWaitingDialogue = {}
        local rand = rng:RandomInt(20)
        --rand = 0
        local newStr
        if rand == 0 then
            newStr = getTextPiece(rng, "Starter")
            rand = rng:RandomInt(2)
            if rand == 1 then
                local newAdj = getTextPiece(rng, "Adjectives")
                if string.sub(newStr,#newStr - 1) == " a" and vowels[string.sub(newAdj, 1,1)] then
                    newStr = newStr .. "n " .. newAdj
                else
                    newStr = newStr .. " " .. newAdj
                end
            end
            local newNoun = getTextPiece(rng, "Noun")
            if rand ~= 1 and string.sub(newStr,#newStr - 1) == " a" and vowels[string.sub(newNoun, 1,1)] then
                newStr = newStr .. "n " .. newNoun
            else
                newStr = newStr .. " " .. newNoun
            end
        elseif rand == 1 then
            newStr = getTextPiece(rng, "StarterPlural")
            rand = rng:RandomInt(2)
            if rand == 1 then
                local newAdj = getTextPiece(rng, "Adjectives")
                newStr = newStr .. " " .. newAdj
            end
            newStr = newStr .. " " .. getTextPiece(rng, "Plurals")
        elseif rand == 2 then
            newStr = getTextPiece(rng, "StarterDescriber")
            newStr = newStr .. " " .. getTextPiece(rng, "Adjectives")
            if rng:RandomInt(2) == 1 then
                local newConnector = getTextPiece(rng, "StarterConnector")
                newStr = newStr .. " " .. newConnector .. " " .. getTextPiece(rng, "Adjectives")
            end
        elseif rand == 3 then
            newStr = getTextPiece(rng, "Plurals")
            rand = rng:RandomInt(2)
            if rand == 1 then
                local newAdj = getTextPiece(rng, "Adjectives")
                newStr = newAdj .. " " .. newStr
            end
            newStr = newStr .. " " .. getTextPiece(rng, "EnderPlural")
        elseif rand == 4 then
            if rng:RandomInt(2) == 1 then
                if rng:RandomInt(3) == 1 then
                    newStr = getTextPiece(rng, "ProperNouns")
                else
                    newStr = getTextPiece(rng, "Uncountables")
                end
            else
                newStr = getTextPiece(rng, "Adjectives")
            end
            rand = rng:RandomInt(2)
            newStr = newStr .. " " .. getTextPiece(rng, "EnderDescriber")
        elseif rand == 5 then
            local rando = rng:RandomInt(3)
            if rando == 1 then
                if rng:RandomInt(3) == 1 then
                    newStr = getTextPiece(rng, "ProperNouns") .. " is "
                else
                    newStr = getTextPiece(rng, "Uncountables") .. " is "
                end
            elseif rando == 2 then
                newStr = getTextPiece(rng, "Adjectives") .. " is "
            else
                newStr = getTextPiece(rng, "Plurals") .. " are "
            end
            newStr = newStr .. getTextPiece(rng, "Adjectives")
            if rng:RandomInt(2) == 1 then
                newStr = newStr .. " and " .. getTextPiece(rng, "Adjectives")
            end
        elseif rand == 6 then
            newStr = getTextPiece(rng, "Starter")
            rand = rng:RandomInt(2)
            local newNoun = getTextPiece(rng, "Noun")
            local newAdj = getTextPiece(rng, "Adjectives")
            if string.sub(newStr,#newStr - 1) == " a" and vowels[string.sub(newNoun, 1,1)] then
                newStr = newStr .. "n " .. newNoun
            else
                newStr = newStr .. " " .. newNoun
            end
            newStr = newStr .. " " .. getTextPiece(rng, "NounConnectors")
            newNoun = getTextPiece(rng, "Noun")
            if string.sub(newStr,#newStr - 1) == " a" and vowels[string.sub(newNoun, 1,1)] then
                newStr = newStr .. "n " .. newNoun
            else
                newStr = newStr .. " " .. newNoun
            end
        elseif rand == 7 then
            newStr = getTextPiece(rng, "StarterVerb")
            newStr = newStr .. " " .. getTextPiece(rng, "Verbs")
            rand = rng:RandomInt(3)
            if rand == 2 then
                local newNoun = getTextPiece(rng, "Noun")
                rand = rng:RandomInt(2)
                if rand == 1 then
                    local newAdj = getTextPiece(rng, "Adjectives")
                    newNoun = newAdj .. " " .. newNoun
                end
                if vowels[string.sub(newNoun, 1,1)] then
                    newStr = newStr .. " an " .. newNoun
                else
                    newStr = newStr .. " a " .. newNoun
                end
            elseif rand == 1 then
                local newPlural = getTextPiece(rng, "Plurals")
                rand = rng:RandomInt(2)
                if rand == 1 then
                    local newAdj = getTextPiece(rng, "Adjectives")
                    newPlural = newAdj .. " " .. newPlural
                end
                newStr = newStr .. " " .. newPlural
            else
                rand = rng:RandomInt(3)
                if rand == 1 then
                    newStr = newStr .. " " .. getTextPiece(rng, "ProperNouns")
                else
                    local newUncountable = getTextPiece(rng, "Uncountables")
                    rand = rng:RandomInt(2)
                    if rand == 1 then
                        local newAdj = getTextPiece(rng, "Adjectives")
                        newUncountable = newAdj .. " " .. newUncountable
                    end
                    newStr = newStr .. " " .. newUncountable
                end
            end
        elseif rand == 8 then
            newStr = getTextPiece(rng, "StarterVerbSolo")
            newStr = newStr .. " " .. getTextPiece(rng, "Verbs")
        elseif rand == 9 then
            newStr = getTextPiece(rng, "StarterPluralVerb")
            local adjPlacement = rng:RandomInt(3)
            if adjPlacement == 1 then
                newStr = newStr .. " " .. getTextPiece(rng, "Adjectives")
            end
            newStr = newStr .. " " .. getTextPiece(rng, "Plurals")
            newStr = newStr .. " " .. getTextPiece(rng, "Verbs")
            rand = rng:RandomInt(3)
            if rand == 1 then
                if adjPlacement == 2 then
                    newStr = newStr .. " " .. getTextPiece(rng, "Adjectives")
                end
                newStr = newStr .. " " .. getTextPiece(rng, "Plurals")
            elseif rand == 2 then
                if adjPlacement == 2 then
                    newStr = newStr .. " " .. getTextPiece(rng, "Adjectives")
                end
                newStr = newStr .. " " .. getTextPiece(rng, "Uncountables")
            else
                newStr = newStr .. " " .. getTextPiece(rng, "ProperNouns")
            end
        elseif rand == 10 then
            newStr = ""
            local itMode
            if rng:RandomInt(2) == 0 then
                itMode = getTextPiece(rng, "Pronoun")
            end
            if rng:RandomInt(5) ~= 0 then
                newStr = getTextPiece(rng, "StarterVerb") .. " "
            end
            newStr = newStr .. getTextPiece(rng, "Verbs")
            if itMode then
                if rng:RandomInt(2) == 0 then
                    if rng:RandomInt(2) == 0 then
                        newStr = newStr .. " " .. getTextPiece(rng, "Pronoun")
                    else
                        newStr = newStr .. " " .. itMode
                    end
                end
            end
            newStr = newStr .. " " .. getTextPiece(rng, "StarterConnector")
            newStr = newStr .. " " .. getTextPiece(rng, "Verbs")
            if itMode then
                newStr = newStr .. " " .. itMode
            end
        elseif rand == 11 then
            newStr = getTextPiece(rng, "StarterUncountable")
            rand = rng:RandomInt(3)
            if rand == 3 then
                newStr = newStr .. " " .. getTextPiece(rng, "ProperNouns")
            else
                if rand == 1 then
                    local newAdj = getTextPiece(rng, "Adjectives")
                    newStr = newStr .. " " .. newAdj
                end
                local newPlural = getTextPiece(rng, "Uncountables")
                newStr = newStr .. " " .. newPlural
            end
        elseif rand == 12 then
            newStr = getTextPiece(rng, "Starter")
            local newNoun = getTextPiece(rng, "Noun")
            local adjChoice = rng:RandomInt(4)
            if adjChoice == 1 then
                newNoun = getTextPiece(rng, "Adjectives") .. " " .. newNoun
            end
            if string.sub(newStr,#newStr - 1) == " a" and vowels[string.sub(newNoun, 1,1)] then
                newStr = newStr .. "n " .. newNoun
            else
                newStr = newStr .. " " .. newNoun
            end
            rand = rng:RandomInt(3)
            if rand == 1 then
                newStr = newStr .. " of "
                if adjChoice == 2 then
                    newStr = newStr .. getTextPiece(rng, "Adjectives") .. " "
                end
                newStr = newStr .. getTextPiece(rng, "Plurals")
            elseif rand == 2 then
                newStr = newStr .. " of "
                if adjChoice == 2 then
                    newStr = newStr .. getTextPiece(rng, "Adjectives") .. " "
                end
                newStr = newStr .. getTextPiece(rng, "Uncountables")
            else
                newStr = newStr .. " of " .. getTextPiece(rng, "ProperNouns")
            end
        elseif rand == 13 then
            newStr = getTextPiece(rng, "StarterUncountable")
            rand = rng:RandomInt(3)
            local adjPlacement = rng:RandomInt(3)
            if rand == 1 then
                newStr = newStr .. " " .. getTextPiece(rng, "ProperNouns")
            else
                if adjPlacement == 1 then
                    newStr = newStr .. " " .. getTextPiece(rng, "Adjectives")
                end
                newStr = newStr .. " " .. getTextPiece(rng, "Uncountables")
            end
            newStr = newStr .. "'s "
            rand = rng:RandomInt(2)
            if rand == 1 then
                if adjPlacement == 2 then
                    newStr = newStr .. getTextPiece(rng, "Adjectives")
                end
                newStr = newStr .. " " .. getTextPiece(rng, "Noun")
            else
                rand = rng:RandomInt(3)
                if rand == 1 then
                    newStr = newStr .. " " .. getTextPiece(rng, "ProperNouns")
                else
                    if adjPlacement == 2 then
                        newStr = newStr .. getTextPiece(rng, "Adjectives")
                    end
                    newStr = newStr .. " " .. getTextPiece(rng, "Uncountables")
                end
            end
        elseif rand == 14 then
            local adjPlacement = rng:RandomInt(3)
            rand = rng:RandomInt(2)
            newStr = ""
            if rand == 1 then
                if adjPlacement == 1 then
                    newStr = newStr .. " " .. getTextPiece(rng, "Adjectives") .. " "
                end
                newStr = newStr .. getTextPiece(rng, "Plurals")
            else
                if rng:RandomInt(3) == 1 then
                    newStr = newStr .. " " .. getTextPiece(rng, "ProperNouns")
                else
                    if adjPlacement == 1 then
                        newStr = newStr .. getTextPiece(rng, "Adjectives") .. " "
                    end
                    newStr = newStr .. getTextPiece(rng, "Uncountables")
                end
                newStr = newStr .. " " .. getTextPiece(rng, "ConnectorEfficacy")
            end
            newStr = newStr .. " " .. getTextPiece(rng, "Verbs")

            rand = rng:RandomInt(3)
            if rand == 1 then
                if adjPlacement == 2 then
                    newStr = newStr .. " " .. getTextPiece(rng, "Adjectives")
                end
                newStr = newStr .. " " .. getTextPiece(rng, "Plurals")
            elseif rand == 2 then
                if rng:RandomInt(3) == 1 then
                    newStr = newStr .. " " .. getTextPiece(rng, "ProperNouns")
                else
                    if adjPlacement == 2 then
                        newStr = newStr .. " " .. getTextPiece(rng, "Adjectives")
                    end
                    newStr = newStr .. " " .. getTextPiece(rng, "Uncountables")
                end
            else
                newStr = newStr .. " the " .. getTextPiece(rng, "Adjectives")
            end
        elseif rand == 15 then
            if rng:RandomInt(3) == 1 then
                newStr = ""
            else
                newStr = getTextPiece(rng, "StarterUncountableVerb") .. " "
            end
            local adjPlacement = rng:RandomInt(3)
            if rng:RandomInt(3) == 1 then
                newStr = newStr .. getTextPiece(rng, "ProperNouns")
            else
                if adjPlacement == 1 then
                    newStr = newStr .. getTextPiece(rng, "Adjectives") .. " "
                end
                newStr = newStr .. getTextPiece(rng, "Uncountables")
            end
            newStr = newStr .. " " .. getTextPiece(rng, "ConnectorEfficacy") .. " " .. getTextPiece(rng, "Verbs")
            rand = rng:RandomInt(3)
            if rand == 1 then
                if adjPlacement == 2 then
                    newStr = newStr .. " " .. getTextPiece(rng, "Adjectives")
                end
                newStr = newStr .. " " .. getTextPiece(rng, "Plurals")
            elseif rand == 2 then
                if adjPlacement == 2 then
                    newStr = newStr .. " " .. getTextPiece(rng, "Adjectives")
                end
                newStr = newStr .. " " .. getTextPiece(rng, "Uncountables")
            else
                newStr = newStr .. " " .. getTextPiece(rng, "ProperNouns")
            end
        elseif rand == 16 then
            newStr = getTextPiece(rng, "StarterDesignator")
            rand = rng:RandomInt(3)
            if rand == 1 then
                newStr = newStr .. " " .. getTextPiece(rng, "ProperNouns")
            elseif rand == 2 then
                newStr = newStr .. " " .. getTextPiece(rng, "Noun")
            else
                newStr = newStr .. " " .. getTextPiece(rng, "Uncountables")
            end
            newStr = newStr .. " the"
            if rng:RandomInt(2) == 1 then
                newStr = newStr .. " " .. getTextPiece(rng, "Adjectives")
            end
            newStr = newStr .. " " .. getTextPiece(rng, "Noun")
        elseif rand == 17 then
            newStr = getTextPiece(rng, "StarterUncountable")
            if rng:RandomInt(2) == 1 then
                newStr = newStr .. " " .. getTextPiece(rng, "Adjectives")
            end
            newStr = newStr .. " " .. getTextPiece(rng, "Noun")
            newStr = newStr .. " " .. getTextPiece(rng, "Uncountables")
        elseif rand == 18 then
            newStr = getTextPiece(rng, "StarterPlural")
            local choice = rng:RandomInt(3)
            if choice == 1 then
                if rng:RandomInt(2) == 1 then
                    newStr = newStr .. " " .. getTextPiece(rng, "Adjectives")
                end
                newStr = newStr .. " " .. getTextPiece(rng, "Uncountables")
            elseif choice == 2 then
                if rng:RandomInt(2) == 1 then
                    newStr = newStr .. " " .. getTextPiece(rng, "Adjectives")
                end
                newStr = newStr .. " " .. getTextPiece(rng, "Noun")
            else
                newStr = newStr .. " " .. getTextPiece(rng, "ProperNouns")
            end
            newStr = newStr .. " " .. getTextPiece(rng, "Plurals")
        elseif rand == 19 then
            newStr = getTextPiece(rng, "Starter")
            local adjPlacement = rng:RandomInt(3)
            if adjPlacement == 1 then
                local newAdj = getTextPiece(rng, "Adjectives")
                if string.sub(newStr,#newStr - 1) == " a" and vowels[string.sub(newAdj, 1,1)] then
                    newStr = newStr .. "n " .. newAdj
                else
                    newStr = newStr .. " " .. newAdj
                end
            end
            local newNoun = getTextPiece(rng, "Noun")
            if adjPlacement ~= 1 and string.sub(newStr,#newStr - 1) == " a" and vowels[string.sub(newNoun, 1,1)] then
                newStr = newStr .. "n " .. newNoun
            else
                newStr = newStr .. " " .. newNoun
            end
            newStr = newStr .. " of"
            local choice = rng:RandomInt(3)
            if choice == 1 then
                if adjPlacement == 2 then
                    newStr = newStr .. " " .. getTextPiece(rng, "Adjectives")
                end
                newStr = newStr .. " " .. getTextPiece(rng, "Uncountables")
            elseif choice == 2 then
                if adjPlacement == 2 then
                    newStr = newStr .. " " .. getTextPiece(rng, "Adjectives")
                end
                newStr = newStr .. " " .. getTextPiece(rng, "Noun")
            else
                newStr = newStr .. " " .. getTextPiece(rng, "ProperNouns")
            end
        end
        mod.shampooDialogue.Dialogue = {newStr}
    end
end

function mod:makeShampooText(name, rng, noSound, dontInterrupt, conjoinString)
    eliminateRoboBaby()
    if mod.shampooVenusInRoom then return end
    if mod.anyPlayerHas(mod.ITEM.TRINKET.ADBLOCKER, true) then
        mod:adBlocked()
        return
    end
    mod.shampooBottleIdleCommentPerRoom = true
    if not rng then
        rng = Isaac.GetPlayer():GetTrinketRNG(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE)
    end
    if not noSound then
        --sfx:Play(mod.Sounds.TheShampooBottleColon, 3, 0, false, mod:getRoll(90,110,rng)/100)
    end
    mod.shampooWaitingDialogue = {}
    mod.shampooDialogue = {}
    mod.shampooDialogue.Dialogue = mod.ShampooBottleText[name][rng:RandomInt(#mod.ShampooBottleText[name])+1]
    if conjoinString then
        mod.shampooDialogue.Dialogue[1] = mod.shampooDialogue.Dialogue[1] .. conjoinString
    end
end

function mod:makeShampooDelayedText(name, rng, delay, noConnector, checkNotTalking, force)
    delay = delay or 1
	rng = rng or Isaac.GetPlayer():GetTrinketRNG(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE)
	local randA = rng:RandomInt(#mod.ShampooBottleText.Connectors)
	local randB = (type(name) == "string" and rng:RandomInt(#mod.ShampooBottleText[name])) or nil
    mod.scheduleForUpdate(function()
        if force or mod.anyPlayerHas(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE, true) then
            if (not checkNotTalking) or (not mod:IsShampooBottleTalking()) then
                if (not noConnector) and ((mod.shampooDialogue and mod.shampooDialogue.Dialogue) or #mod.shampooWaitingDialogue > 0) then
                    table.insert(mod.shampooWaitingDialogue, mod.ShampooBottleText.Connectors[randA+1])
                end
                if type(name) == "string" then
                    table.insert(mod.shampooWaitingDialogue, mod.ShampooBottleText[name][randB+1])
                else
                    table.insert(mod.shampooWaitingDialogue, {table.unpack(name)})
                end
            end
        end
    end, delay, ModCallbacks.MC_POST_UPDATE, true)
end

function mod:makeShampooDelayedTextScheduleless(name, rng, noConnector)
    rng = rng or Isaac.GetPlayer():GetTrinketRNG(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE)
    if (not noConnector) and ((mod.shampooDialogue and mod.shampooDialogue.Dialogue) or #mod.shampooWaitingDialogue > 0) then
        table.insert(mod.shampooWaitingDialogue, mod.ShampooBottleText.Connectors[rng:RandomInt(#mod.ShampooBottleText.Connectors)+1])
    end
    if type(name) == "string" then
        table.insert(mod.shampooWaitingDialogue, mod.ShampooBottleText[name][rng:RandomInt(#mod.ShampooBottleText[name])+1])
    else
        table.insert(mod.shampooWaitingDialogue, {table.unpack(name)})
    end
end

local function findEnemyCommentary(npc, context)
    local tabLoc
    if mod.ShampooBottleTextEnemies[npc.Type] then
        if mod.ShampooBottleTextEnemies[npc.Type][npc.Variant] then
            if mod.ShampooBottleTextEnemies[npc.Type][npc.Variant][npc.SubType] and mod.ShampooBottleTextEnemies[npc.Type][npc.Variant][npc.SubType][context] then
                tabLoc = 3
            elseif mod.ShampooBottleTextEnemies[npc.Type][npc.Variant][context] then
                tabLoc = 2
            elseif mod.ShampooBottleTextEnemies[npc.Type][context] then
                tabLoc = 1
            end
        elseif mod.ShampooBottleTextEnemies[npc.Type][context] then
            tabLoc = 1
        end
    end
    return tabLoc
end

function mod:shampooBottleEnemyCommentary(context, rng, npc)
    eliminateRoboBaby()
    if mod.shampooVenusInRoom then return end
    if mod.shampooWaitingForSteven then return end
    if mod.anyPlayerHas(mod.ITEM.TRINKET.ADBLOCKER, true) then
        mod:adBlocked()
        return
    end
    if mod.shampooBottleIdleCommentPerRoom and not mod.ShampooTesting then return end
    mod.shampooBottleIdleCommentPerRoom = true

    if not rng then
        rng = Isaac.GetPlayer():GetTrinketRNG(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE)
    end
    context = context or "Idle"
    --Bunch of synonyms (mostly to help with the shampoo console function)
    if context == "idle" then
        context = "Idle"
    elseif context == "hit" or context == "hitby" then
        context = "HitBy"
    elseif context == "killed" or context == "kill" then
        context = "Killed"
    end

    local validIndexes = {}
    if npc then
        local index = findEnemyCommentary(npc, context)
        if index then
            table.insert(validIndexes, {index, npc.Type, npc.Variant, npc.SubType})
        end
    else
        local checkedEntityTypes = {}
        for _, npc in pairs(Isaac.GetRoomEntities()) do
            if not checkedEntityTypes[npc.Type .. "." .. npc.Variant .. "." ..  npc.SubType] then
                --Ignore friendly enemies
                if (not npc:ToNPC()) or (npc:ToNPC() and not mod:isFriend(npc:ToNPC())) then
                    checkedEntityTypes[npc.Type .. "." .. npc.Variant .. "." ..  npc.SubType] = true
                    local index = findEnemyCommentary(npc, context)
                    if index then
                        table.insert(validIndexes, {index, npc.Type, npc.Variant, npc.SubType})
                    end
                end
            end
        end
    end
    --print(#validIndexes)

    if #validIndexes > 0 then
        local readIndex = validIndexes[rng:RandomInt(#validIndexes) + 1]
        local dialogue = FiendFolio.ShampooBottleTextEnemies
        for i = 1, readIndex[1] do
            --print(readIndex[1 + i])
            dialogue = dialogue[readIndex[1 + i]]
        end
        mod.shampooDialogue = {}
        mod.shampooWaitingDialogue = {}
        mod.shampooDialogue.Dialogue = dialogue[context][rng:RandomInt(#dialogue[context]) + 1]
        sfx:Play(mod.Sounds.TheShampooBottleColon, 1.5, 0, false, mod:getRoll(90,110,rng)/100)
    else
        if context == "Idle" then
            mod:makeIdleComment(rng)
        elseif context == "HitBy" then
            mod:makeShampooText("TakeDamage", rng)
        elseif context == "Killed" then
            mod:makeShampooText("KilledEnemy", rng)
        end
    end
end

function mod:shampooBottleItemCommentary(context, rng, itemID, isTrinket, scheduleLess, force, checkNoTalk)
    if mod.shampooVenusInRoom then return end
    if mod.shampooWaitingForSteven then return end
    context = context or "Found"
    --Bunch of synonyms (mostly to help with the shampoo console function)
    if context == "found" then
        context = "Found"
    elseif context == "picked" or context == "pickedup" then
        context = "PickedUp"
    elseif context == "use" or context == "used" then
        context = "Used"
    elseif context == "idle" then
        context = "Idle"
    end

    if isTrinket then
        if mod.ShampooBottleTextItems.Trinkets[itemID] and mod.ShampooBottleTextItems.Trinkets[itemID][context] then
            mod:makeShampooDelayedText(mod.ShampooBottleTextItems.Trinkets[itemID][context][rng:RandomInt(#mod.ShampooBottleTextItems.Trinkets[itemID][context]) + 1], rng, 5, nil, checkNoTalk, force)
            return true
        end
    else
        if mod.ShampooBottleTextItems.Collectibles[itemID] and mod.ShampooBottleTextItems.Collectibles[itemID][context] then
            if scheduleLess then
                mod:makeShampooDelayedTextScheduleless(mod.ShampooBottleTextItems.Collectibles[itemID][context][rng:RandomInt(#mod.ShampooBottleTextItems.Collectibles[itemID][context]) + 1], rng)
            else
                mod:makeShampooDelayedText(mod.ShampooBottleTextItems.Collectibles[itemID][context][rng:RandomInt(#mod.ShampooBottleTextItems.Collectibles[itemID][context]) + 1], rng, 5, nil, checkNoTalk, force)
            end
            return true
        end
    end
end

function mod:shampooBottleIdleThought(player, rng, isActiveRoom, force)
    player = player or Isaac.GetPlayer()
    rng = rng or player:GetTrinketRNG(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE)
    local itemSuccessful
    local history = player:GetHistory():GetCollectiblesHistory()
    local validCollectibles = {}
    for i = 1, #history do
        local item = history[i]
        local id = item:GetItemID()
        --print(id)
        local isTrinket = false
        if item:IsTrinket() then
            isTrinket = true
            if mod.ShampooBottleTextItems.Trinkets[id] and mod.ShampooBottleTextItems.Trinkets[id]["Idle"] then
                table.insert(validCollectibles, {id, isTrinket})
            end
        else
            if mod.ShampooBottleTextItems.Collectibles[id] and mod.ShampooBottleTextItems.Collectibles[id]["Idle"] then
                table.insert(validCollectibles, {id, isTrinket})
            end
        end
    end
    for i = 0, 1 do
        local id = player:GetTrinket(i)
        if mod.ShampooBottleTextItems.Trinkets[id] and mod.ShampooBottleTextItems.Trinkets[id]["Idle"] then
            table.insert(validCollectibles, {id, true})
        end
    end
    local numValid = #validCollectibles
    if numValid > 0 then
        local chance = 6 - math.min(4, numValid)
        --Less chance to talk about items when fighting enemies
        if isActiveRoom then
            chance = chance + 5
        end
        if rng:RandomInt(chance) == 0 then
            local selectedCollectible = validCollectibles[rng:RandomInt(numValid) + 1]
            mod:shampooBottleItemCommentary("idle", rng, selectedCollectible[1], selectedCollectible[2], nil, true)
            itemSuccessful = true
        end
    end
    if not itemSuccessful then
        mod:shampooBottleEnemyCommentary("Idle", rng)
    end
end

local formToTransformation = {
    [PlayerForm.PLAYERFORM_GUPPY]               = "Guppy",
    [PlayerForm.PLAYERFORM_LORD_OF_THE_FLIES]   = "Beelzebub",
    [PlayerForm.PLAYERFORM_MUSHROOM]            = "FunGuy",
    [PlayerForm.PLAYERFORM_ANGEL]               = "Seraphim",
    [PlayerForm.PLAYERFORM_BOB]                 = "Bob",
    [PlayerForm.PLAYERFORM_DRUGS]               = "Spun",
    [PlayerForm.PLAYERFORM_MOM]                 = "YesMother",
    [PlayerForm.PLAYERFORM_BABY]                = "Conjoined",
    [PlayerForm.PLAYERFORM_EVIL_ANGEL]          = "Leviathan",
    [PlayerForm.PLAYERFORM_POOP]                = "OhCrap",
    [PlayerForm.PLAYERFORM_BOOK_WORM]           = "Bookworm",
    [PlayerForm.PLAYERFORM_ADULTHOOD]           = "Adult",
    [PlayerForm.PLAYERFORM_SPIDERBABY]          = "Spiderbaby",
    [PlayerForm.PLAYERFORM_STOMPY]              = "Stompy",
}

function mod:theShampooBottleUpdate(player)
    if player:HasTrinket(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE) then
        local room = game:GetRoom()
        local level = game:GetLevel()
        local data = mod:GetEntityData(player)
        if (not data.ffsavedata) or (data.ffsavedata and not data.ffsavedata.RunEffects) then return end
        local savedata = data.ffsavedata.RunEffects
        local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE)

        --the grid stuff
        local bombedTinted
        for index,num in pairs(mod.shampooBottleRocks) do
            local grid = room:GetGridEntity(index)
            local gone = false
            if grid and grid:GetType() ~= num then
                gone = true
            end
            if not grid or grid.CollisionClass == GridCollisionClass.COLLISION_NONE then
                gone = true
                bombedTinted = true
            end
            if gone then
                mod.shampooBottleRocks[index] = nil
            end
        end
        if bombedTinted then
            --Could probably be changed to use room:IsFirstVisit() honestly
            if not savedata.theShampooBottleTintedRoom then
                savedata.theShampooBottleTintedRoom = {}
            end
            local listIndex = level:GetCurrentRoomDesc().ListIndex
            if not savedata.theShampooBottleTintedRoom[tostring(listIndex)] then
                mod:makeShampooText("FoundTintedRockFirst", rng)
            else
                mod:makeShampooText("GotBackToTintedRock", rng)
                savedata.theShampooBottleTintedRoom[tostring(listIndex)] = nil
            end
        end

        local randCheck = 2000
        local isActiveRoom
        if mod.IsActiveRoom() then
            randCheck = 1000
            isActiveRoom = true
        end
        local rand = rng:RandomInt(randCheck)
        if not mod.shampooDialogue.Dialogue and (rand == 1 or (mod.ShampooTesting and game:GetFrameCount() % 120 == 0)) then
            mod:shampooBottleIdleThought(player, rng, isActiveRoom)
        end

        --Torture Cookie Response
        if data.theShampooBottleRespondToTortureCookie then
            if data.theShampooBottleRespondToTortureCookie > 0 then
                data.theShampooBottleRespondToTortureCookie = data.theShampooBottleRespondToTortureCookie-1
            else
                mod:makeShampooText("TortureCookieResponse", rng)
                data.theShampooBottleRespondToTortureCookie = nil
            end
        end

        if data.doShampooTreasureDistCheck then
            local roomDesc = level:GetCurrentRoomDesc()
            local roomIndex = roomDesc.SafeGridIndex
            FiendFolio.savedata.run.level.ShampooDoorChecks = FiendFolio.savedata.run.level.ShampooDoorChecks or {}
            if not FiendFolio.savedata.run.level.ShampooDoorChecks[tostring(roomIndex)] then

                local nearTreasure
                for i = 1, #data.doShampooTreasureDistCheck do
                    if player.Position:Distance(data.doShampooTreasureDistCheck[i]) < 200 then
                        nearTreasure = data.doShampooTreasureDistCheck[i]
                        break
                    end
                end
                if nearTreasure then
                    data.doShampooTreasureDistCheck = nil
                    --Literally can't be arsed to account for red rooms leading to multiple doors
                    FiendFolio.savedata.run.level.ShampooDoorChecks[tostring(roomIndex)] = true
                    if not (player:GetNumKeys() > 0 or player:HasGoldenKey()) then
                        if not FiendFolio.savedata.run.cashedInOnShampooKey then
                            mod:makeShampooText("TreasureRoomNoKeyFirstTime", rng)
                            Isaac.Spawn(5,30,1,room:FindFreePickupSpawnPosition(nearTreasure,40,true),Vector.Zero,player)
                            FiendFolio.savedata.run.cashedInOnShampooKey = true
                        else
                            mod:makeShampooText("TreasureRoomNoKey", rng)
                        end
                    end
                end
            else
                data.doShampooTreasureDistCheck = nil
            end
        end

        savedata.shampooTransformations = savedata.shampooTransformations or {}
        for i = 1, PlayerForm.NUM_PLAYER_FORMS do
            local form = i - 1
            if formToTransformation[form] then
                if player:HasPlayerForm(form) then
                    if not savedata.shampooTransformations[tostring(form)] then
                        savedata.shampooTransformations[tostring(form)] = 2
                    elseif savedata.shampooTransformations[tostring(form)] == 1 then
                        mod:makeShampooText("TransformationTriggered" .. formToTransformation[form], rng)
                        savedata.shampooTransformations[tostring(form)] = 2
                    end
                else
                    if not savedata.shampooTransformations[tostring(form)] then
                        savedata.shampooTransformations[tostring(form)] = 1
                    end
                end
            end
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BUM_FRIEND)
        and player:HasCollectible(CollectibleType.COLLECTIBLE_DARK_BUM)
        and player:HasCollectible(CollectibleType.COLLECTIBLE_KEY_BUM)
        then
            if not savedata.shampooTransformations.SuperBum then
                savedata.shampooTransformations.SuperBum = 2
            elseif savedata.shampooTransformations.SuperBum == 1 then
                mod:makeShampooText("TransformationTriggeredSuperBum", rng)
                savedata.shampooTransformations.SuperBum = 2
            end
        else
            if not savedata.shampooTransformations.SuperBum then
                savedata.shampooTransformations.SuperBum = 1
            end
        end

        if player:HasCollectible(CollectibleType.COLLECTIBLE_KNIFE_PIECE_2) then
            if savedata.shampooWaitingForKnifePiece then
                savedata.shampooWaitingForKnifePiece = nil
                savedata.shampooSawYouAlreadyHadKnifePiece = true
                mod:shampooBottleItemCommentary("PickedUp", rng, CollectibleType.COLLECTIBLE_KNIFE_PIECE_2)
            else
                savedata.shampooSawYouAlreadyHadKnifePiece = true
            end
        elseif not savedata.shampooSawYouAlreadyHadKnifePiece then
            savedata.shampooWaitingForKnifePiece = true
        end

        if player:HasCollectible(CollectibleType.COLLECTIBLE_DARK_BUM)
        and player:HasCollectible(CollectibleType.COLLECTIBLE_SISSY_LONGLEGS)
        then
            if not savedata.shampooTransformations.RedditShip then
                mod:makeShampooText("SissyAndDarkBum", rng)
                savedata.shampooTransformations.RedditShip = true
            end
        end

        local heldItem = player.QueuedItem.Item
        if heldItem and (heldItem:IsCollectible() or heldItem:IsTrinket()) then
            data.lastHeldItemShampooBotID = {heldItem.ID, heldItem:IsCollectible()}
        else
            if data.lastHeldItemShampooBotID then
                if data.lastHeldItemShampooBotID[2] then
                    mod:shampooBottleItemCommentary("PickedUp", rng, data.lastHeldItemShampooBotID[1])
                else
                    mod:shampooBottleItemCommentary("PickedUp", rng, data.lastHeldItemShampooBotID[1], true)
                end
                data.lastHeldItemShampooBotID = nil
            end
        end

        if mod.shampooWaitingForSteven then
            if TheFuture.HasSpokenToSteven then
                mod.shampooWaitingForSteven = nil
                mod.scheduleForUpdate(function()
                    mod:makeShampooText("StevenInterrupts", rng)
                end, 30, ModCallbacks.MC_POST_UPDATE, true)
            end
        end

        if mod.IsActiveRoom() then
            if not data.shampooBottleActiveRoomDamageCheck then
                data.shampooBottleActiveRoomDamageCheck = 0
            end
        else
            local roomType = room:GetType()
            if roomType == RoomType.ROOM_BOSS then
                if not FiendFolio.savedata.run.level.ShampooBottleHasRespondedToAltPathDoorYet then
                    for i = 0, 7 do
                        local door = game:GetRoom():GetDoor(i)
                        if door then
                            if door:IsRoomType(RoomType.ROOM_SECRET_EXIT) then
                                if door.Position:Distance(player.Position) < 75 then
                                    if door:GetVariant() == DoorVariant.DOOR_LOCKED then
                                        if level:GetStage() < LevelStage.STAGE2_1 then
                                            --Downpour door
                                            if FiendFolio.savedata.run.cashedInOnShampooKey then
                                                mod:makeShampooText("DownpourEntranceNoKeys", rng)
                                            else
                                                mod:makeShampooText("TreasureRoomNoKeyFirstTime", rng)
                                                Isaac.Spawn(5,PickupVariant.PICKUP_KEY,1,room:FindFreePickupSpawnPosition(player.Position,40,true),Vector.Zero,player)
                                                FiendFolio.savedata.run.cashedInOnShampooKey = true
                                            end
                                            FiendFolio.savedata.run.level.ShampooBottleHasRespondedToAltPathDoorYet = true
                                        else
                                            --Maus door
                                            if FiendFolio.savedata.run.cashedInOnShampooHeart then
                                                if not (FiendFolio.savedata.run.shampooNoticesYoureCloseToTheMausDoor or FiendFolio.savedata.run.cashedInOnShampooSoulHeart) then
                                                    if player:HasFullHearts() and player:GetSoulHearts() + player:GetHearts() <= 2 then
                                                        mod:makeShampooText("MausEntranceSoulHeartNeeded", rng)
                                                        Isaac.Spawn(5,PickupVariant.PICKUP_HEART,HeartSubType.HEART_SOUL,room:FindFreePickupSpawnPosition(player.Position,40,true),Vector.Zero,player)
                                                        FiendFolio.savedata.run.cashedInOnShampooSoulHeart = true
                                                        FiendFolio.savedata.run.level.ShampooBottleHasRespondedToAltPathDoorYet = true
                                                    end
                                                end
                                            else
                                                if player:GetSoulHearts() + player:GetHearts() <= 2 then
                                                    mod:makeShampooText("MausEntranceNoHealth", rng)
                                                    Isaac.Spawn(5,PickupVariant.PICKUP_HEART,HeartSubType.HEART_FULL,room:FindFreePickupSpawnPosition(player.Position,40,true),Vector.Zero,player)
                                                    FiendFolio.savedata.run.cashedInOnShampooHeart = true
                                                    FiendFolio.savedata.run.shampooNoticesYoureCloseToTheMausDoor = true
                                                end
                                            end
                                        end
                                    elseif door:GetVariant() == DoorVariant.DOOR_LOCKED_CRACKED then
                                        --Mines door
                                        if player:GetNumBombs() < 1 then
                                            if mod.GetEntityCount(5,PickupVariant.PICKUP_BOMB) + mod.GetEntityCount(4) + mod.GetEntityCount(1000,1) < 1 then
                                                if FiendFolio.savedata.run.cashedInOnShampooBomb then
                                                    mod:makeShampooText("MinesEntranceFreshOut", rng)
                                                    FiendFolio.savedata.run.level.ShampooBottleHasRespondedToAltPathDoorYet = true
                                                else
                                                    mod:makeShampooText("MinesEntranceNoBombs", rng)
                                                    Isaac.Spawn(5,PickupVariant.PICKUP_BOMB,1,room:FindFreePickupSpawnPosition(player.Position,40,true),Vector.Zero,player)
                                                    FiendFolio.savedata.run.cashedInOnShampooBomb = true
                                                end
                                            end
                                        end
                                    end
                                else
                                    FiendFolio.savedata.run.shampooNoticesYoureCloseToTheMausDoor = nil
                                end
                            end
                        end
                    end
                end
            end
            if data.shampooBottleActiveRoomDamageCheck and not mod.shampooVenusInRoom then
                if data.shampooBottleActiveRoomDamageCheck == 0 then
                    if room:GetType() == RoomType.ROOM_BOSS then
                        mod:makeShampooDelayedText("FlawlessBoss", rng, 1)
                    else
                        if data.recentFlawlessRoom then
                            data.recentFlawlessRoom = data.recentFlawlessRoom - 1
                            if data.recentFlawlessRoom <= 0 then
                                data.recentFlawlessRoom = nil
                            end
                        else
                            data.recentFlawlessRoom = mod:RandomInt(10,20,rng)
                            mod:makeShampooDelayedText("FlawlessRoom", rng, 1)
                        end
                    end
                end
                data.shampooBottleActiveRoomDamageCheck = nil
            end
        end

        --Favourite enemy
        if mod.SquareFlyPosChecked then
            mod:makeShampooText("PosChecked", rng)
            mod.SquareFlyPosChecked = nil
        end

        if FannyMOD then
            if FannyMOD.IS_SPEAKING then
                data.shampooBottleListeningToFanny = 120
            elseif data.shampooBottleListeningToFanny then
                data.shampooBottleListeningToFanny = data.shampooBottleListeningToFanny - 1
                if data.shampooBottleListeningToFanny <= 0 then
                    data.shampooBottleListeningToFanny = nil
                end
                if not mod.shampooDialogue.Dialogue then
                    data.shampooBottleRespondedToFanny = data.shampooBottleRespondedToFanny or 0
                    data.shampooBottleRespondedToFanny = data.shampooBottleRespondedToFanny + 1
                    if rng:RandomInt(2) == 1 then
                        if FannyMOD.IS_UNDERWATER then
                            mod:makeShampooText("FannyCatResponseUnderwater", rng)
                        elseif data.shampooBottleRespondedToFanny >= 10 then
                            mod:makeShampooText("FannyCatResponse", rng)
                        else
                            mod:makeShampooText("FannyCatResponseInitial", rng)
                        end
                    else
                        if mod.anyPlayerHas(CollectibleType.COLLECTIBLE_ROBO_BABY_2) then
                            mod:activateRobobaby(rng)
                        end
                    end
                    data.shampooBottleListeningToFanny = nil
                end
            end
        end

        mod.shampooBottleMultipleItemCheck = 0
        mod.shampooBottleMultipleItemTracked = nil
    end
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE, mod.theShampooBottleUpdate)

local tryCheckSourceEnts = {
    [9] = true,
    [4] = true,
    [mod.FFID.Tech] = true,
    [1000] = true
}

function mod:shampooBottlePlayerHurt(player, damage, flag, source)
    if player:HasTrinket(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE) then
        if source and source.Entity then
            local returnedEnt = source.Entity
            if tryCheckSourceEnts[returnedEnt.Type] then
                if returnedEnt.SpawnerEntity then
                    returnedEnt = returnedEnt.SpawnerEntity
                elseif returnedEnt.SpawnerType then
                    returnedEnt = {Type = returnedEnt.SpawnerType, Variant = returnedEnt.SpawnerVariant, SubType = 0}
                end
            end
            local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE)
            local rand = rng:RandomInt(5)
            if (not mod.shampooDialogue.Dialogue and rand == 1) or mod.ShampooTesting then
                mod:shampooBottleEnemyCommentary("hit", rng, returnedEnt)
            end
        end
        local data = mod:GetEntityData(player)
        if data.shampooBottleActiveRoomDamageCheck then
            data.shampooBottleActiveRoomDamageCheck = data.shampooBottleActiveRoomDamageCheck + 1
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_SANGUINE_BOND) then
            if flag == flag | DamageFlag.DAMAGE_SPIKES
            and game:GetRoom():GetType() == RoomType.ROOM_DEVIL
            then
                mod.scheduleForUpdate(function()
                    local found = Isaac.FindByType(5, 100,-1, false, false)
                    for _, collectible in ipairs(found) do
                        if collectible.FrameCount == 0 then
                            mod:makeShampooDelayedTextScheduleless("SanguineBondItem")
                        end
                    end
                end, 1)
            end
        end
    end
end

function mod:shampooBottleOnEnemyDeath(entity)
    if mod.anyPlayerHas(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE, true) then
        local randVal = 75
        local force
        if entity:IsBoss() then
            randVal = 35
            if game:GetRoom():GetType() == RoomType.ROOM_BOSS then
                local foundOtherBoss
                for _, otherEnt in ipairs(Isaac.GetRoomEntities()) do
                    if otherEnt:IsBoss() and not otherEnt:IsDead() then
                        if GetPtrHash(entity) ~= GetPtrHash(otherEnt) then
                            foundOtherBoss = true
                            break
                        end
                    end
                end
                if not foundOtherBoss then
                    force = true
                end
            end
        end
        local rand = mod:RandomInt(randVal)
        if force or (not mod.shampooDialogue.Dialogue and rand == 1) or mod.ShampooTesting then
            mod:shampooBottleEnemyCommentary("kill", nil, entity)
        end
    end
end

function mod:IsShampooBottleTalking()
    if mod.shampooDialogue.Dialogue or (mod.shampooWaitingDialogue and #mod.shampooWaitingDialogue > 0) then
        return true
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function() -- eugh
    if mod.shampooDialogue.Dialogue then
        if shampooOpacity >= 1 then
            mod.shampooDialogue.TextLine = mod.shampooDialogue.TextLine or 1
            mod.shampooDialogue.TextCharacters = mod.shampooDialogue.TextCharacters or 0
            local speed = 1
            if not mod.shampooDialogue.IsRantingAboutSteven then
                if #mod.shampooDialogue.Dialogue >= 6 then
                    speed = 2
                elseif #mod.shampooDialogue.Dialogue > 2 then
                    speed = 1.5
                end
            end
            --print(speed)
            mod.shampooDialogue.TextCharacters = mod.shampooDialogue.TextCharacters + speed
            mod.shampooDialogue.TextCharacters = math.min(mod.shampooDialogue.TextCharacters, #mod.shampooDialogue.Dialogue[mod.shampooDialogue.TextLine])

            if #string.sub(mod.shampooDialogue.Dialogue[mod.shampooDialogue.TextLine], 1, math.floor(mod.shampooDialogue.TextCharacters)) == #mod.shampooDialogue.Dialogue[mod.shampooDialogue.TextLine] then
                textbox:SetFrame("Idle", 0)
                if #mod.shampooDialogue.Dialogue == mod.shampooDialogue.TextLine then
                    if #mod.shampooWaitingDialogue > 0 then
                        mod.shampooDialogue.TextDelay = mod.shampooDialogue.TextDelay or 25
                    else
                        mod.shampooDialogue.TextDelay = mod.shampooDialogue.TextDelay or 40
                    end
                else
                    mod.shampooDialogue.TextDelay = mod.shampooDialogue.TextDelay or (40 - (speed * 15))
                end
                mod.shampooDialogue.TextDelay = mod.shampooDialogue.TextDelay - 1

                if mod.shampooDialogue.TextDelay <= 0 then
                    if mod.shampooDialogue.Dialogue[mod.shampooDialogue.TextLine + 1] then
                        mod.shampooDialogue.TextLine = mod.shampooDialogue.TextLine + 1
                        mod.shampooDialogue.TextCharacters = 0
                    else
                        mod.shampooDialogue.Dialogue = nil
                        if not mod.shampooRobobabyTalking then
                            mod.shampooJustFinished = true
                        end
                    end
                    mod.shampooDialogue.TextDelay = nil
                end
            else
                textbox:SetFrame("Idle", (math.floor((mod.shampooDialogue.TextCharacters % 10) / 5)) % 2)
                local rendertext = string.sub(mod.shampooDialogue.Dialogue[mod.shampooDialogue.TextLine], 1, math.floor(mod.shampooDialogue.TextCharacters))
                --print(#rendertext)
                if #rendertext % (6 * speed) == 1 or #rendertext % (6 * speed) == speed then
                    if mod.shampooRobobabyTalking then
                        sfx:Play(SoundEffect.SOUND_REDLIGHTNING_ZAP_WEAK, 0.75, 0, false, mod:getRoll(150,200)/100)
                    else
                        sfx:Play(mod.Sounds.TheShampooBottleColon, 0.75, 0, false, mod:getRoll(90,110)/100)
                    end
                end
            end
            if mod.shampooDialogue.IsRantingAboutSteven then
                if TheFuture then
                    local stevens = Isaac.FindByType(1000, TheFuture.Effects.StevenNPC.Var, -1, false, false)
                    local interruptingSteven
                    for _, steven in pairs(stevens) do
                        if mod:GetEntityData(steven).Dialogue then
                            interruptingSteven = true
                            break
                        end
                    end
                    if interruptingSteven then
                        mod.shampooDialogue = {}
                        mod.shampooWaitingDialogue = {}
                        mod.shampooWaitingForSteven = true
                        shampooOpacity = 0
                    end
                end
            end
        else
            if mod.shampooDialogue.Dialogue then
                mod.shampooDialogue.AnimFrame = mod.shampooDialogue.AnimFrame or -1
                mod.shampooDialogue.AnimFrame = mod.shampooDialogue.AnimFrame + 1
                textbox:SetFrame("Appear", mod.shampooDialogue.AnimFrame)
                local wait = 10
                local alpha = math.min(((1/wait) * mod.shampooDialogue.AnimFrame), 1)
                shampooOpacity = alpha
            end
        end
    else
        if #mod.shampooWaitingDialogue > 0 and not mod.shampooRobobabyTalking then
            mod.shampooDialogue.Dialogue = {table.unpack(mod.shampooWaitingDialogue[1])}
            table.remove(mod.shampooWaitingDialogue, 1)
        else
            if shampooOpacity > 0 then
                local wait = 10
                local alpha = math.max(shampooOpacity - (1/wait), 0)
                textbox:SetFrame("Disappear", wait - math.floor((alpha * wait)))
                shampooOpacity = alpha
            else
                mod.shampooRobobabyTalking = false
                if mod.shampooJustFinished then
                    mod.shampooJustFinished = false
                    local rng
                    mod.AnyPlayerDo(function(player)
                        if player:HasCollectible(CollectibleType.COLLECTIBLE_ROBO_BABY_2) then
                            rng = player:GetTrinketRNG(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE)
                        end
                    end)
                    if rng and (rng:RandomInt(2) == 0 or not FiendFolio.savedata.run.ShampooMentionedRoboBabyYet) then
                        mod:activateRobobaby(rng)
                        FiendFolio.savedata.run.ShampooMentionedRoboBabyYet = true
                    end
                end
            end
        end
    end
end)

function mod:theShampooBottleNewRoom(player, data)
    mod.shampooBottleIdleCommentPerRoom = nil
    mod.shampooWaitingForSteven = nil
    if mod.shampooDialogue.IsRantingAboutSteven then
        local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE)
        mod:makeShampooText("StevenBored", rng)
    end
    if player:HasTrinket(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE) then
        if not data.ffsavedata then return end
        local savedata = data.ffsavedata.RunEffects
        savedata.theShampooBottleOneOffs = savedata.theShampooBottleOneOffs or {}
        local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE)
        local found
        for index,rock in pairs(mod.shampooBottleRocks) do
            found = true
        end
        if found then
            local level = game:GetLevel()
            local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE)
            local listIndex = level:GetRoomByIdx(level:GetPreviousRoomIndex()).ListIndex
            if not savedata.theShampooBottleTintedRoom then
                savedata.theShampooBottleTintedRoom = {}
            end
            if not savedata.theShampooBottleTintedRoom[tostring(listIndex)] then
                mod:makeShampooText("MissedTintedRock", rng)
                savedata.theShampooBottleTintedRoom[tostring(listIndex)] = true
            end
        end
        shampooSetTintedRocks()

        mod.shampooBottleMultipleItemCheck = 0
        mod.shampooBottleMultipleItemTracked = nil

        --Enjoys arcades
        local room = game:GetRoom()
        local roomType = room:GetType()
        if roomType == RoomType.ROOM_ARCADE then
            if not savedata.theShampooBottleOneOffs.enteredArcade then
                mod:makeShampooDelayedTextScheduleless("ArcadeEntry", rng)
                savedata.theShampooBottleOneOffs.enteredArcade = true
            end
        elseif roomType == RoomType.ROOM_ISAACS or roomType == RoomType.ROOM_BARREN then
            if mod:IsSaloonRoom() then
                if not savedata.theShampooBottleOneOffs.enteredSaloon then
                    mod:makeShampooDelayedTextScheduleless("SaloonEntry", rng)
                    savedata.theShampooBottleOneOffs.enteredSaloon = true
                end
            else
                if not savedata.theShampooBottleOneOffs.enteredBedroom then
                    mod:makeShampooDelayedTextScheduleless("BedroomEntry", rng)
                    savedata.theShampooBottleOneOffs.enteredBedroom = true
                end
            end
        elseif roomType == RoomType.ROOM_SHOP then
            if room:IsFirstVisit() and not savedata.theShampooBottleOneOffs.enteredShopDeadBroke then
                local coins = player:GetNumCoins()
                if coins <= 0 then
                    mod:makeShampooDelayedTextScheduleless("PennyForYourTroubles", rng)
                    savedata.theShampooBottleOneOffs.enteredShopDeadBroke = true
                    local pennySub = 1
                    if rng:RandomInt(10) == 0 then
                        pennySub = mod.PICKUP.COIN.LIL_PENNY
                    end
                    Isaac.Spawn(5,20,pennySub,room:FindFreePickupSpawnPosition(player.Position,40,true),Vector.Zero,player)
                end
            end
        end

        --Planetarium
        local foundPlanetarium
        local foundTreasure = {}
        for i = 0, 7 do
            local door = game:GetRoom():GetDoor(i)
            if door then
                if door:IsRoomType(RoomType.ROOM_PLANETARIUM) then
                    foundPlanetarium = true
                end
                if door:IsRoomType(RoomType.ROOM_TREASURE) then
                    if door:IsLocked() then
                        table.insert(foundTreasure, door.Position)
                    end
                end
            end
        end

        if foundPlanetarium then
            if not savedata.theShampooBottleOneOffs.FoundPlanetarium then
                mod:makeShampooText("FoundPlanetarium", rng)
                savedata.theShampooBottleOneOffs.FoundPlanetarium = true
            end
        end
        if #foundTreasure > 0 then
            data.doShampooTreasureDistCheck = {table.unpack(foundTreasure)}
        end

        --Steven (future) check
        if TheFuture then
            if not FiendFolio.savedata.run.ShampooBottleDidStevenRant then
                if #Isaac.FindByType(1000, TheFuture.Effects.StevenNPC.Var, -1, false, false) > 0 then
                    mod:makeShampooText("StevenSpotted", rng)
                    mod.shampooDialogue.IsRantingAboutSteven = true
                    FiendFolio.savedata.run.ShampooBottleDidStevenRant = true
                end
            end
        end

        mod.shampooVenusInRoom = nil
        local venus = Isaac.FindByType(mod.FF.CacophobiaVenus.ID, mod.FF.CacophobiaVenus.Var, -1)
        if #venus > 0 then
            FiendFolio.scheduleForUpdate(function()
                mod:makeShampooText("CacophobiaSpotted", rng)
                mod.shampooVenusInRoom = true
            end, 40)
        end

        if mod.OddFeeling then
            mod:makeShampooText("OddFeeling", rng)
            mod.OddFeeling = nil
        end
    end
end

local stageTable = { --Why the hell are stages so weird man
    [LevelStage.STAGE1_1] = {
        [StageType.STAGETYPE_ORIGINAL] = "Basement",
        [StageType.STAGETYPE_WOTL] = "Cellar",
        [StageType.STAGETYPE_AFTERBIRTH] = "Burning",
        [StageType.STAGETYPE_REPENTANCE] = "Downpour",
        [StageType.STAGETYPE_REPENTANCE_B] = "Dross",
    },
    [LevelStage.STAGE2_1] = {
        [StageType.STAGETYPE_ORIGINAL] = "Caves",
        [StageType.STAGETYPE_WOTL] = "Catacombs",
        [StageType.STAGETYPE_AFTERBIRTH] = "Flooded",
        [StageType.STAGETYPE_REPENTANCE] = "Mines",
        [StageType.STAGETYPE_REPENTANCE_B] = "Ashpit",
    },
    [LevelStage.STAGE3_1] = {
        [StageType.STAGETYPE_ORIGINAL] = "Depths",
        [StageType.STAGETYPE_WOTL] = "Necropolis",
        [StageType.STAGETYPE_AFTERBIRTH] = "Dank",
        [StageType.STAGETYPE_REPENTANCE] = "Mausoleum",
        [StageType.STAGETYPE_REPENTANCE_B] = "Gehenna",
    },
    [LevelStage.STAGE4_1] = {
        [StageType.STAGETYPE_ORIGINAL] = "Womb",
        [StageType.STAGETYPE_WOTL] = "Utero",
        [StageType.STAGETYPE_AFTERBIRTH] = "Scarred",
        [StageType.STAGETYPE_REPENTANCE] = "Corpse",
        [StageType.STAGETYPE_REPENTANCE_B] = "Mortis",
    },
    [LevelStage.STAGE4_3] = {
        [StageType.STAGETYPE_ORIGINAL] = "Hush",
    },
    [LevelStage.STAGE5] = {
        [StageType.STAGETYPE_ORIGINAL] = "Sheol",
        [StageType.STAGETYPE_WOTL] = "Cathedral",
    },
    [LevelStage.STAGE6] = {
        [StageType.STAGETYPE_ORIGINAL] = "DarkRoom",
        [StageType.STAGETYPE_WOTL] = "Chest",
    },
    [LevelStage.STAGE7] = {
        [StageType.STAGETYPE_ORIGINAL] = "Void",
    },
    [LevelStage.STAGE8] = {
        [StageType.STAGETYPE_ORIGINAL] = "Home",
        [StageType.STAGETYPE_WOTL] = "Home",
    },
}
stageTable[LevelStage.STAGE1_2] = stageTable[LevelStage.STAGE1_1]
stageTable[LevelStage.STAGE2_2] = stageTable[LevelStage.STAGE2_1]
stageTable[LevelStage.STAGE3_2] = stageTable[LevelStage.STAGE3_1]
stageTable[LevelStage.STAGE4_2] = stageTable[LevelStage.STAGE4_1]

local function getCurrentFloorName()
    local level = game:GetLevel()
    local levelNum = level:GetStage()
    local stageType = level:GetStageType()

    if stageTable[levelNum] then
        return stageTable[levelNum][stageType]
    end
end

function mod:theShampooBottleLevelStart()
    if game:GetFrameCount() == 0 then return end
    mod.scheduleForUpdate(function()
        if mod.anyPlayerHas(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE, true) then
            local useText
            if game:GetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH) then
                --Eh
            elseif StageAPI and StageAPI.InNewStage() then
                local isRevStage, revStage = mod.IsRevelationsStage()
                local isFFGraceStage, FFGraceStage = mod.IsFFGraceStage()
                local isFuture, FutureStage = mod.IsTheFuture()
                local isLastJudgementStage, LastJudgementStage = mod.IsLastJudgementStage()
                if isRevStage then
                    useText = "Enter" .. revStage.Name
                elseif isFFGraceStage then
                    useText = "Enter" .. FFGraceStage.Name
                elseif isFuture then
                    useText = "EnterTheFuture"
                elseif isLastJudgementStage then
                    useText = "Enter" .. LastJudgementStage.Name
                end
            else
                local name = getCurrentFloorName()
                useText = "Enter" .. name
            end
            if useText and mod.ShampooBottleText[useText] then
                mod:makeShampooDelayedText(useText)
            end
        end
    end, 1, nil, true)
end

local function IsTaintedChar(player)
	return player:GetPlayerType() == Isaac.GetPlayerTypeByName(player:GetName(), true)
end



local function onAdd(_, player, trinketType, firstTime)
    eliminateRoboBaby()
    mod.shampooWaitingDialogue = {}
    mod.shampooDialogue = {}
    local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE)
    local dateTime = os.date("*t")
    if forceDate then
        --dateTime = {day = forcedDate.day, month = forcedDate.month}
        dateTime.day = forcedDate.day
        dateTime.month = forcedDate.month
    end
    mod.ShampooDateCache = dateTime
    if not mod.shampooRobobabyTalking then
        textbox:GetLayer("icon"):SetCropOffset(getShampooCropOffset(dateTime))
    end

    local bottleAlreadySpoke = false

    -- birthday
    if dateTime.day == 24 and dateTime.month == 2 then
        mod:makeShampooDelayedTextScheduleless("PickupShampooBirthday", rng)

    -- valentine's
    elseif dateTime.day == 14 and dateTime.month == 2 then
        mod:makeShampooDelayedTextScheduleless("PickupShampooValentines", rng)

    -- christmas
    elseif dateTime.day == 25 and dateTime.month == 12
    or game:GetSeeds():HasSeedEffect(SeedEffect.SEED_CHRISTMAS) then
        mod:makeShampooDelayedTextScheduleless("PickupShampooChristmas", rng)

    -- halloween
    elseif mod.SpookingOfIsaacActivated
    or dateTime.day == 31 and dateTime.month == 10
    then
        mod:makeShampooDelayedTextScheduleless("PickupShampooHalloween", rng)

    -- release day!
    elseif dateTime.day == 5 and dateTime.month == 8 then
        mod:makeShampooDelayedTextScheduleless("PickupShampooReleaseAnniversary", rng)
    else
        if not hasSaidTimeText then
            hasSaidTimeText = true
            bottleAlreadySpoke = true

            if rng:RandomInt(3) == 0 then
                -- check time of day
                if dateTime.hour >= 6 and dateTime.hour < 11 then
                    mod:makeShampooDelayedTextScheduleless("PickupShampooMorning", rng)
                elseif dateTime.hour >= 11 and dateTime.hour < 19 then
                    mod:makeShampooDelayedTextScheduleless("PickupShampooAfternoon", rng)
                elseif dateTime.hour >= 19 then
                    mod:makeShampooDelayedTextScheduleless("PickupShampooNight", rng)
                else
                    mod:makeShampooDelayedTextScheduleless("PickupShampooVeryLate", rng)
                end
            end
        end
    end

    local runData = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', {})
    if not runData.PickedUpShampooBottleBefore then
        runData.PickedUpShampooBottleBefore = true
        bottleAlreadySpoke = true
        local playerType = player:GetPlayerType()
        if FiendFolio:IsEsauJr(player) then
            playerType = -103
        elseif Isaac.GetChallenge() == Challenge.CHALLENGE_GUARDIAN then
            playerType = -101
        elseif Isaac.GetChallenge() == Challenge.CHALLENGE_HOT_POTATO then
            playerType = -102
        end
        local charText = FiendFolio.ShampooBottleTextItems.Players[playerType]
        --If not a number spot, check through string name
        if not charText then
            local playername = player:GetName()
            if IsTaintedChar(player) then
                charText = FiendFolio.ShampooBottleTextItems.Players.Tainted[playername]
            else
                charText = FiendFolio.ShampooBottleTextItems.Players.Normal[playername]
            end
        end
        --Probably don't know them then
        if not charText then
            charText = FiendFolio.ShampooBottleTextItems.Players[-100]
        end
        if charText then
            local choice = rng:RandomInt(#charText) + 1
            mod:makeShampooDelayedTextScheduleless(charText[choice],rng,true)
        end
    end

    if not bottleAlreadySpoke then
        if player:GetInnateTrinketCount(trinketType, "FF_LILGOLEM") > 0 then
            mod:makeShampooDelayedText("PickupShampooLilGolem", rng)
        elseif trinketType & TrinketType.TRINKET_GOLDEN_FLAG == TrinketType.TRINKET_GOLDEN_FLAG then
            if mod:IsPlayerTrinketBlasphemous(player, 0) then
                mod:makeShampooDelayedText("GoldenBlasphemousBottle", rng)
            else
                mod:makeShampooDelayedText("GoldenBottle", rng)
            end
        elseif mod:IsPlayerTrinketBlasphemous(player, 0) then
            mod:makeShampooDelayedText("BlasphemousBottle", rng)
        else
            mod:makeShampooDelayedText("PickupShampoo", rng)
        end
    end

    --Keeping this here cos it's historical
    --[[
    mod.shampooWaitingDialogue = {}
    table.insert(mod.shampooWaitingDialogue, {"hey"})
    table.insert(mod.shampooWaitingDialogue, {"only a week now until reloaded releases"})
    table.insert(mod.shampooWaitingDialogue, {"pretty crazy"})
    table.insert(mod.shampooWaitingDialogue, {"look forward to some daily teasers and stuff"})
    table.insert(mod.shampooWaitingDialogue, {"..."})
    table.insert(mod.shampooWaitingDialogue, {"yep"})
    table.insert(mod.shampooWaitingDialogue, {"i'm the teaser"})
    table.insert(mod.shampooWaitingDialogue, {"the shampoo bottle"})
    ]]

end

mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, onAdd, mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE)
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, onAdd, mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE + TrinketType.TRINKET_GOLDEN_FLAG)

local function onRemove()
	for _,trinket in ipairs(Isaac.FindByType(5,350,-1,false,false)) do
		if trinket.SubType % TrinketType.TRINKET_GOLDEN_FLAG == mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE and trinket.FrameCount < 2 then
            --mod:makeShampooText("DroppedShampooBottle", player:GetTrinketRNG(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE))
            mod:GetEntityData(trinket).droppingShampoo = true
		end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, onRemove, mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE)
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, onRemove, mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE + TrinketType.TRINKET_GOLDEN_FLAG)

local function onGulp(player)
    local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE)
    sfx:Play(mod.Sounds.TheShampooBottleSmelt, 2, 0, false, mod:getRoll(90, 110, rng)/100)
    --sfx:Play(mod.Sounds.TheShampooBottleSmelt, 1, 0, false, 1)
    mod:makeShampooText("GulpedShampooBottle", rng, true)
end

mod.AddTrinketPickupCallback(nil, nil, mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE, onGulp)

function mod:theShampooBottleTrinketUpdate(trinket, data)
    if mod:GetRealTrinketId(trinket.SubType) == FiendFolio.ITEM.TRINKET.THE_SHAMPOO_BOTTLE then
        local sprite = trinket:GetSprite()
        local rng = trinket:GetDropRNG()
        --Whole bunch of nonsense to determine if he should have sunglasses
        --if trinket.FrameCount <= 1 then
            local playerWithShampoo = mod.anyPlayerHas(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE, true)
            local isThereRealShampoo
            if not playerWithShampoo then
                local otherShampoos = Isaac.FindByType(5, 350, -1, false, false)
                for _, shampoo in pairs(otherShampoos) do
                    if shampoo.SubType % TrinketType.TRINKET_GOLDEN_FLAG == mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE then
                        if shampoo.InitSeed ~= trinket.InitSeed then
                            if not mod:GetEntityData(shampoo).replacedSprite then
                                isThereRealShampoo = true
                            end
                        end
                    end
                end
            end
            --Here's where i'm like, ok replace the sprite then.
            if (playerWithShampoo or isThereRealShampoo) and not data.replacedSprite then
                sprite:GetLayer(0):SetCropOffset(Vector(32,0))
                data.replacedSprite = true
            else
                if not isThereRealShampoo then
                    mod.ShampooDateCache = mod.ShampooDateCache or os.date("*t")
                    sprite:GetLayer(0):SetCropOffset(getShampooCropOffset(mod.ShampooDateCache, Vector(32,0), true))
                end
            end
        --end
        if data.replacedSprite then
            sprite:GetLayer(0):SetCropOffset(Vector(32,0))
        end
        if data.droppingShampoo and sprite:IsEventTriggered("DropSound") then
            mod:makeShampooText("DroppedShampooBottle", rng)
        end

        if not data.playerLeavingRoom and trinket.FrameCount > 8 then
            local room = game:GetRoom()
            if not data.playerLeavingRoomDoors then
                data.playerLeavingRoomDoors = {}
                local doors = mod.availableDoors[room:GetRoomShape()]
                for _,checkDoor in ipairs(doors) do
                    local checkedDoor = room:GetDoorSlotPosition(checkDoor)
                    table.insert(data.playerLeavingRoomDoors, checkedDoor)
                end
            end

            for i = 1, game:GetNumPlayers() do
                local player = Isaac.GetPlayer(i - 1)
                local near
                for _,door in ipairs(data.playerLeavingRoomDoors) do
                    if player.Position:Distance(door) < 20 then
                        mod:makeShampooText("LeavingBottleInRoom", rng)
                        data.playerLeavingRoom = true
                        break
                    end
                end
            end
        end
        if not FiendFolio.savedata.run.SeenShampooBottleBefore then
            FiendFolio.savedata.run.SeenShampooBottleBefore = true
            sfx:Play(mod.Sounds.TheShampooBottleAppear, 2, 0, false, mod:getRoll(90,110,rng)/100)
        end
    end
    if trinket:GetSprite():IsEventTriggered("DropSound") then
        if mod.anyPlayerHas(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE, true) then
            if not mod:levelHasCurse(game:GetLevel(), mod.curses.veilCurse) then
                mod:shampooBottleItemCommentary("Found", trinket:GetDropRNG(), trinket.SubType, true)
            end
        end
    end
end

function mod:theShampooBottleNewLevel(player)
    local savedata = mod:GetEntityData(player).ffsavedata.RunEffects

    if savedata.theShampooBottleTintedRoom then
        savedata.theShampooBottleTintedRoom = {}
    end
    if savedata.theShampooBottleOneOffs then
        savedata.theShampooBottleOneOffs = {}
    end
    mod.shampooBottleItemChoiceTracker = nil
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, id, rng, player)
	if player:HasTrinket(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE) then
        mod.savedata.run.ShampooBottleItemUseChance = mod.savedata.run.ShampooBottleItemUseChance or {}
        mod.savedata.run.ShampooBottleItemUseChance[id] = mod.savedata.run.ShampooBottleItemUseChance[id] or 1
        if rng:RandomFloat() < mod.savedata.run.ShampooBottleItemUseChance[id] then
            mod:shampooBottleItemCommentary("Used", rng, id, nil, nil, nil, true)
            mod.savedata.run.ShampooBottleItemUseChance[id] = mod.savedata.run.ShampooBottleItemUseChance[id] * 0.75
        end
    end
end)

local function getShampooBottleChoiceRoomOpinion(pickup, rng, numPickups)
    if mod.shampooBottleMultipleItemTracked and mod.shampooBottleMultipleItemTracked:Exists() then
        local applicableTable = {}
        if numPickups >= 4 then
            return "ChoiceRoomMore"
        elseif numPickups >= 3 then
            table.insert(applicableTable, "ChoiceRoomMiddle")
        end
        --print(pickup.Position, mod.shampooBottleMultipleItemTracked.Position)
        if pickup.Position.X ~= mod.shampooBottleMultipleItemTracked.Position.X then
            table.insert(applicableTable, "ChoiceRoomHorizontal")
        end
        if pickup.Position.Y ~= mod.shampooBottleMultipleItemTracked.Position.Y then
            verticalApplicable = true
            table.insert(applicableTable, "ChoiceRoomVertical")
        end
        return applicableTable[rng:RandomInt(#applicableTable) + 1]
    end
end

mod:AddTrinketCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE, function(_, pickup)
    if pickup.SubType ~= 0
    and pickup.FrameCount == 1
    and not pickup.Touched
    and game:GetRoom():IsFirstVisit() then
        if mod.anyPlayerHas(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE, true) then
            mod.shampooBottleMultipleItemCheck = mod.shampooBottleMultipleItemCheck or 0
            mod.shampooBottleMultipleItemCheck = mod.shampooBottleMultipleItemCheck + 1
            local rng = pickup:GetDropRNG()
            --Item check seenness
            mod.savedata.run.ShampooBottleItemsSeen = mod.savedata.run.ShampooBottleItemsSeen or {}

            local curses = game:GetLevel():GetCurses()
            local isCurseBlind = curses == curses | LevelCurse.CURSE_OF_BLIND
            if mod.shampooBottleMultipleItemCheck > 1 then
                local level = game:GetLevel()
                local roomDesc = level:GetCurrentRoomDesc()
                mod.shampooBottleItemChoiceTracker = mod.shampooBottleItemChoiceTracker or {}
                if not mod.shampooBottleItemChoiceTracker[roomDesc.SafeGridIndex] then
                    mod.savedata.run.ShampooBottleItemsSeen[tostring(pickup.InitSeed)] = true
                    local roomsub = roomDesc.Data.Subtype
                    --Messy af but it works
                    if level:GetStage() == LevelStage.STAGE3_2 and game:GetRoom():GetType() == RoomType.ROOM_BOSS and roomsub == 6 then
                        mod:makeShampooDelayedTextScheduleless("ChoiceRoomMom", rng)
                        if isCurseBlind then
                            mod:makeShampooDelayedText("ChoiceRoomMomBlind",rng,3,true)
                            mod.shampooBottleItemChoiceTracker[roomDesc.SafeGridIndex] = true
                        else
                            local delayedText = getShampooBottleChoiceRoomOpinion(pickup, rng, mod.shampooBottleMultipleItemCheck)
                            if delayedText then
                                mod:makeShampooDelayedText(delayedText,rng,3,true)
                                mod.shampooBottleItemChoiceTracker[roomDesc.SafeGridIndex] = true
                            end
                        end
                        return
                    else
                        mod:makeShampooText("ChoiceRoomGeneric", rng)
                        mod.shampooBottleItemChoiceTracker[roomDesc.SafeGridIndex] = true
                    end
                    local delayedText = getShampooBottleChoiceRoomOpinion(pickup, rng, mod.shampooBottleMultipleItemCheck)
                    if delayedText then
                        mod:makeShampooDelayedTextScheduleless(delayedText,rng,true)
                        mod.shampooBottleItemChoiceTracker[roomDesc.SafeGridIndex] = true
                    end
                end
            else
                mod.shampooBottleMultipleItemTracked = pickup
                if isCurseBlind or pickup:IsBlind() then
                    mod:makeShampooText("BlindItem", rng)
                    mod.savedata.run.ShampooBottleItemsSeen[tostring(pickup.InitSeed)] = true
                elseif (not mod.savedata.run.ShampooBottleItemsSeen[tostring(pickup.InitSeed)]) then
                    mod.savedata.run.ShampooBottleItemsSeen[tostring(pickup.InitSeed)] = true
                    if not mod:shampooBottleItemCommentary("Found", rng, pickup.SubType, nil, true) then
                        local itemConfig = Isaac:GetItemConfig()
                        local item = itemConfig:GetCollectible(pickup.SubType)
                        local quality = item.Quality
                        if pickup.SubType > 4000000000 then
                            mod:makeShampooText("GlitchItem", rng)
                        else
                            --print(item.ShopPrice, pickup:IsShopItem())
                            if quality >= 4 then
                                if pickup:IsShopItem() then
                                    local price = item.ShopPrice
                                    if price >= 0 then
                                        --print(price)
                                        if price > Isaac.GetPlayer():GetNumCoins() then
                                            mod:makeShampooText("Quality4ItemCantBuy", rng)
                                        else
                                            mod:makeShampooText("Quality4Item", rng)
                                        end
                                    end
                                else
                                    mod:makeShampooText("Quality4Item", rng)
                                end
                            elseif quality <= 0 then
                                if pickup:IsShopItem() then
                                    mod:makeShampooText("Quality0ItemShop", rng)
                                else
                                    mod:makeShampooText("Quality0Item", rng)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end, PickupVariant.PICKUP_COLLECTIBLE)

mod:AddTrinketCallback(ModCallbacks.MC_USE_ITEM, mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE, function(_,item,rng,player)
    mod.scheduleForUpdate(function()
        local roomType = game:GetRoom():GetType()
        if roomType == RoomType.ROOM_ERROR then
            mod:makeShampooText("Teleport2Error", rng)
        elseif roomType == RoomType.ROOM_DEVIL or roomType == RoomType.ROOM_ANGEL then
            mod:makeShampooText("Teleport2AngelDevil", rng)
        end
    end, 1, nil, true)
end, CollectibleType.COLLECTIBLE_TELEPORT_2)

mod:AddTrinketCallback(ModCallbacks.MC_POST_SLOT_UPDATE, mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE, function(_, slot)
    local d = mod:GetEntityData(slot)
    local state = slot:GetState()
    if state > 1 then
        state = 2
    else
        state = 1
    end
    if d.ShampooTrackingPrevState then
        if state == 1 and state ~= d.ShampooTrackingPrevState[2] then
            if slot.FrameCount - d.ShampooTrackingPrevState[1] < 5 then
                local player = mod:getClosestPlayer(slot.Position, 999999999999)
                local numCoins = player:GetNumCoins()
                if numCoins < 1 then
                    --Dead broke
                    local room = game:GetRoom()
                    local savedata = mod:GetEntityData(player).ffsavedata.RunEffects
                    savedata.theShampooBottleOneOffs = savedata.theShampooBottleOneOffs or {}
                    if not savedata.theShampooBottleOneOffs.gamblingDeadBroke then
                        savedata.theShampooBottleOneOffs.gamblingDeadBroke = true
                        mod:makeShampooText("GamblersFallacy", slot:GetDropRNG())
                        Isaac.Spawn(5,20,1,room:FindFreePickupSpawnPosition(player.Position,40,true),Vector.Zero,player)
                    end
                end
            end
        end
    end
    d.ShampooTrackingPrevState = {slot.FrameCount, slot:GetState()}
end, SlotVariant.SLOT_MACHINE)

mod:AddTrinketCallback(ModCallbacks.MC_PRE_SLOT_COLLISION, mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE, function(_, slot, collider)
    if slot:GetState() == SlotState.IDLE then
        if collider.Type == 1 then
            local player = collider:ToPlayer()
            if player:HasInvincibility() then
                mod:makeShampooText("CheatBlood", slot:GetDropRNG())
            end
        end
    end
end, SlotVariant.BLOOD_DONATION_MACHINE)

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_MORPH, function(_, pickup)
    if pickup.Type == EntityType.ENTITY_PICKUP
    and pickup.Variant == PickupVariant.PICKUP_TRINKET
    and mod:GetRealTrinketId(pickup.SubType) == mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE
    then
        mod:makeShampooText("Deletion")
    end
end)

mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, function()
    hasSaidTimeText = false
    --Wipe out any trace of shampoo bottle, otherwise his textbox closes on new runs and such
    mod.shampooDialogue = {}
    mod.shampooWaitingDialogue = {}
    mod.shampooRobobabyTalking = false
    shampooOpacity = 0
end)

mod:AddTrinketCallback(ModCallbacks.MC_POST_PLAYER_REVIVE, mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE, function(_, revivedDude)
    mod:makeShampooText("PlayerRevive", revivedDude:GetTrinketRNG(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE))
end)

mod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, function (_, cmd, str)
    if cmd == "shampooitem" and Isaac.IsInGame() then
        local rng = Isaac.GetPlayer():GetTrinketRNG(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE)
        local args = mod:SplitString(str, " ")
        local id = args[1]
        local context = args[2]
        print(mod:shampooBottleItemCommentary(context, rng, tonumber(id)))
    end
end)

function mod:ChatMessageSafetyAnalyser(userName)
    if mod.anyPlayerHas(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE, true) then
        if not FiendFolio.savedata.run.ShampooHasAcknowledgedRepentancePlus then
            mod:makeShampooText("RepentancePlusItemChatMemberNotice", nil, nil, nil, " " .. userName .. "?")
            mod:makeShampooDelayedTextScheduleless("RepentancePlusItemChatMemberNoticePost", nil, true)
            FiendFolio.savedata.run.ShampooHasAcknowledgedRepentancePlus = true
        else
            FiendFolio.savedata.run.ShampooRepentancePlusResponseChance = FiendFolio.savedata.run.ShampooRepentancePlusResponseChance or 0.75
            if math.random() < FiendFolio.savedata.run.ShampooRepentancePlusResponseChance then
                FiendFolio.savedata.run.ShampooRepentancePlusResponseChance = FiendFolio.savedata.run.ShampooRepentancePlusResponseChance * 0.75
                mod:makeShampooDelayedText("RepentancePlusItemChatMemberResponse", nil, 30)
            end
        end
    end
end

mod:AddTrinketCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE, function(_, pickup)
    if pickup.SubType ~= 0
    and pickup.FrameCount == 1
    and not pickup.Touched
    and game:GetRoom():IsFirstVisit() then
        if mod.anyPlayerHas(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE, true)
        and (not mod:IsShampooBottleTalking())
        then
            local pillColor = pickup.SubType % PillColor.PILL_GIANT_FLAG
            if mod.ShampooBottleTextItems.PillColor[pillColor] then
                local rng = Isaac.GetPlayer():GetTrinketRNG(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE)
                mod:makeShampooDelayedTextScheduleless(mod.ShampooBottleTextItems.PillColor[pillColor][rng:RandomInt(#mod.ShampooBottleTextItems.PillColor[pillColor]) + 1], rng)
            end
        end
    end
end, PickupVariant.PICKUP_PILL)

mod:AddTrinketCallback(ModCallbacks.MC_USE_PILL, mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE, function(_, effect, player, flags)
    if player:HasTrinket(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE)
    and (not mod:IsShampooBottleTalking())
    then
        if mod.ShampooBottleTextItems.Pills[effect] then
            mod.savedata.run.ShampooBottlePillUseChance = mod.savedata.run.ShampooBottlePillUseChance or {}
            mod.savedata.run.ShampooBottlePillUseChance[effect] = mod.savedata.run.ShampooBottlePillUseChance[effect] or 1
            local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE)
            if rng:RandomFloat() < mod.savedata.run.ShampooBottlePillUseChance[effect] then
                mod:makeShampooDelayedText(mod.ShampooBottleTextItems.Pills[effect][rng:RandomInt(#mod.ShampooBottleTextItems.Pills[effect]) + 1], rng, 30, nil, true)
                mod.savedata.run.ShampooBottlePillUseChance[effect] = mod.savedata.run.ShampooBottlePillUseChance[effect] * 0.75
            end
        end
    end
end)

mod:AddTrinketCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE, function(_, pickup)
    if pickup.SubType ~= 0
    and pickup.FrameCount == 1
    and not pickup.Touched
    and pickup.SpawnerType ~= 1
    and game:GetRoom():IsFirstVisit()
    and not mod:GetEntityData(pickup).ReplacedByVeil then
        if mod.anyPlayerHas(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE, true)
        and (not mod:IsShampooBottleTalking())
        then
            local config = Isaac.GetItemConfig()
            local cardConfig = config:GetCard(pickup.SubType)
            if cardConfig then
                if mod.ShampooBottleTextItems.CardBacks[cardConfig.PickupSubtype] then
                    local rng = Isaac.GetPlayer():GetTrinketRNG(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE)
                    mod:makeShampooDelayedTextScheduleless(mod.ShampooBottleTextItems.CardBacks[cardConfig.PickupSubtype][rng:RandomInt(#mod.ShampooBottleTextItems.CardBacks[cardConfig.PickupSubtype]) + 1], rng)
                end
            end
        end
    end
end, PickupVariant.PICKUP_TAROTCARD)

mod:AddTrinketCallback(ModCallbacks.MC_USE_CARD, mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE, function(_, card, player, flags)
    if player:HasTrinket(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE) then
        if mod.ShampooBottleTextItems.Cards[card]
        and mod.ShampooBottleTextItems.Cards[card].Used then
            mod.savedata.run.ShampooBottleCardsUseChance = mod.savedata.run.ShampooBottleCardsUseChance or {}
            mod.savedata.run.ShampooBottleCardsUseChance[card] = mod.savedata.run.ShampooBottleCardsUseChance[card] or 1
            local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE)
            if rng:RandomFloat() < mod.savedata.run.ShampooBottleCardsUseChance[card] then
                mod:makeShampooDelayedText(mod.ShampooBottleTextItems.Cards[card].Used[rng:RandomInt(#mod.ShampooBottleTextItems.Cards[card].Used) + 1], rng, 10, nil, true)
                mod.savedata.run.ShampooBottleCardsUseChance[card] = mod.savedata.run.ShampooBottleCardsUseChance[card] * 0.75
            end
        end
    end
end)

mod:AddTrinketCallback(ModCallbacks.MC_POST_PLAYER_ADD_CARD, mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE, function(_, player, card, slot)
    if player:HasTrinket(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE) then
        mod.savedata.run.ShampooBottleCardsSeen = mod.savedata.run.ShampooBottleCardsSeen or {}
        if not mod.savedata.run.ShampooBottleCardsSeen[card] then
            if mod.ShampooBottleTextItems.Cards[card]
            and mod.ShampooBottleTextItems.Cards[card].PickedUp then
                local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE)
                mod:makeShampooDelayedText(mod.ShampooBottleTextItems.Cards[card].PickedUp[rng:RandomInt(#mod.ShampooBottleTextItems.Cards[card].PickedUp) + 1], rng, 10)
                mod.savedata.run.ShampooBottleCardsSeen[card] = true
            end
        end
    end
end)

mod:AddTrinketCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE, function(_, pickup)
    if not mod.ACHIEVEMENT.DIRE_CHEST:IsUnlocked()
    and pickup.FrameCount == 1
    and not pickup.Touched
    and pickup.SpawnerType ~= 1
    and game:GetRoom():IsFirstVisit()
    and not mod:GetEntityData(pickup).ReplacedByVeil then
        if mod.anyPlayerHas(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE, true)
        and (not mod:IsShampooBottleTalking())
        then
            if game:GetRoom():GetType() == RoomType.ROOM_CURSE then
                mod:makeShampooDelayedTextScheduleless("DireHint")
            end
        end
    end
end, PickupVariant.PICKUP_REDCHEST)