local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

FiendFolio.MILK = {}

mod.MILK.NUMBERFIDDLING = {
    QualityRoll = 6, --Modulator rolls this number, if the roll is less than current quality (1-4) it fails (max quality is 5 but you can't roll on that)
}

--Won't break anything if you swap these out
mod.MILK.RANKS = {
    [0] = "Abhorrent", --Only if you break quality modulator
    [1] = "Rotten",
    [2] = "Crappy",
    [3] = "Decent",
    [4] = "Tasty",
    [5] = "Perfect",
}

--Affects how many null items are applied in a milk, determined by quality
--KEEP THESE NUMBERS INTEGERS, IT PROBABLY BREAKS (never tested it tho)
--UpString and DownString are used for the item description
--Think Tears *pretty* up, Damage *a lil* down, leave blank for nothing
mod.MILK.BALANCE = {
    [0] = { --Abhorrent Milk
        UP = 1,
        UPMULT = 0,
        DOWN = 2,
        DOWNMULT = 2,

        UpString = "a lil",
        DownString = "way",
    },
    [1] = { --Rotten Milk
        UP = 1,
        UPMULT = 0,
        DOWN = 2,
        DOWNMULT = 1,

        UpString = "a lil",
        DownString = "pretty",
    },
    [2] = { --Crappy Milk
        UP = 1,
        UPMULT = 0,
        DOWN = 2,
        DOWNMULT = 0,

        UpString = "a lil",
        DownString = "",
    },
    [3] = { --Decent Milk
        UP = 1,
        UPMULT = 0,
        DOWN = 1,
        DOWNMULT = 0,

        UpString = "a lil",
        DownString = "a lil",
    },
    [4] = { --Tasty Milk
        UP = 2,
        UPMULT = 0,
        DOWN = 1,
        DOWNMULT = 0,

        UpString = "",
        DownString = "a lil",
    },
    [5] = { --Perfect Milk
        UP = 2,
        UPMULT = 1,
        DOWN = 1,
        DOWNMULT = 0,

        UpString = "pretty",
        DownString = "a lil",
    },
}

--Little helper function to just make milk colours match RGB values you enter!
local function easyColor(r,g,b)
    return Color(r/255,g/255,b/255,1)
end

mod.MILK.COLORS = {
    TEARS = {   --Blue
        UP = {
            Name = "Blueberry",
            Color = easyColor(0,180,216),
            Stat = "Tears",
        },
        DOWN = {
            Name = "Bantha",
            Color = easyColor(6,49,70),
            Stat = "tears",
        },
        IconOffset = Vector(-20,-10),
    },
    DAMAGE = {  --Red
        UP = {
            Name = "Strawberry",
            Color = easyColor(209,65,82),
            Stat = "Damage",
        },
        DOWN = {
            Name = "Raspberry",
            Color = easyColor(78,15,24),
            Stat = "damage",
        },
        IconOffset = Vector(-40,0),
    },
    SPEED = {   --Brown
        UP = {
            Name = "Coffee",
            Color = easyColor(179,138,102),
            Stat = "Speed",
        },
        DOWN = {
            Name = "Brown",
            Color = easyColor(95,62,42),
            Stat = "speed",
        },
        IconOffset = Vector(-40,-10),
    },
    RANGE = {   --Orange
        UP = {
            Name = "Banana",
            Color = easyColor(255,227,109),
            Stat = "Range",
        },
        DOWN = {
            Name = "Papaya",
            Color = easyColor(229,103,23),
            Stat = "range",
        },
        IconOffset = Vector(-30,-10),
    },
    SHOTSPEED = {--White
        UP = {
            Name = "Coconut",
            Color = easyColor(255,255,255),
            Stat = "Shot speed",
        },
        DOWN = {
            Name = "Anise",
            Color = easyColor(59,68,75),
            Stat = "shot speed",
        },
        IconOffset = Vector(-10,-10),
    },
    LUCK = {    --Green
        UP = {
            Name = "Shamrock",
            Color = easyColor(168,225,160),
            Stat = "Luck",
        },
        DOWN = {
            Name = "Pistachio",
            Color = easyColor(43,88,32),
            Stat = "luck",
        },
        IconOffset = Vector(-30,0),
    },

    --CURRENTLY UNIMPLEMENTED
    RANDOM = {  --Purple
        UP = {
            Name = "Wacky",
            Color = easyColor(255,255,255),
            Stat = "Random stat",
        },
        DOWN = {
            Name = "Lumpy",
            Color = easyColor(255,255,255),
            Stat = "random stat",
        },
    },
    ALL = { --Rainbow
        UP = {
            Name = "Rainbow",
            Color = easyColor(255,255,255),
            Stat = "All stats",
        },
        DOWN = {
            Name = "Unicorn",
            Color = easyColor(255,255,255),
            Stat = "all stats",
        },
    },
}

--Adjust the specific numbers for these in the items.xml
mod.MILK.STATS = {
    TEARS = {
        UP = mod.ITEM.NULL.MILK_TEARS_UP,
        DOWN = mod.ITEM.NULL.MILK_TEARS_DOWN,
        UPMULT = mod.ITEM.NULL.MILK_TEARS_UP_MULT,
        DOWNMULT = mod.ITEM.NULL.MILK_TEARS_DOWN_MULT,
    },
    DAMAGE = {
        UP = mod.ITEM.NULL.MILK_DAMAGE_UP,
        DOWN = mod.ITEM.NULL.MILK_DAMAGE_DOWN,
        UPMULT = mod.ITEM.NULL.MILK_DAMAGE_UP_MULT,
        DOWNMULT = mod.ITEM.NULL.MILK_DAMAGE_DOWN_MULT,
    },
    SPEED = {
        UP = mod.ITEM.NULL.MILK_SPEED_UP,
        DOWN = mod.ITEM.NULL.MILK_SPEED_DOWN,
        UPMULT = mod.ITEM.NULL.MILK_SPEED_UP_MULT,
        DOWNMULT = mod.ITEM.NULL.MILK_SPEED_DOWN_MULT,
    },
    RANGE = {
        UP = mod.ITEM.NULL.MILK_RANGE_UP,
        DOWN = mod.ITEM.NULL.MILK_RANGE_DOWN,
        UPMULT = mod.ITEM.NULL.MILK_RANGE_UP_MULT,
        DOWNMULT = mod.ITEM.NULL.MILK_RANGE_DOWN_MULT,
    },
    SHOTSPEED = {
        UP = mod.ITEM.NULL.MILK_SHOTSPEED_UP,
        DOWN = mod.ITEM.NULL.MILK_SHOTSPEED_DOWN,
        UPMULT = mod.ITEM.NULL.MILK_SHOTSPEED_UP_MULT,
        DOWNMULT = mod.ITEM.NULL.MILK_SHOTSPEED_DOWN_MULT,
    },
    LUCK = {
        UP = mod.ITEM.NULL.MILK_LUCK_UP,
        DOWN = mod.ITEM.NULL.MILK_LUCK_DOWN,
        UPMULT = mod.ITEM.NULL.MILK_LUCK_UP_MULT,
        DOWNMULT = mod.ITEM.NULL.MILK_LUCK_DOWN_MULT,
    },
}

mod.MILK.WEIGHTS = {
    COMMON = 5,
    UNCOMMON = 3,
    RARE = 1,
}

mod.MILK.OPTIONS = {
    {Stat = "TEARS",    PosWeight = mod.MILK.WEIGHTS.UNCOMMON,NegWeight = mod.MILK.WEIGHTS.UNCOMMON},
    {Stat = "DAMAGE",   PosWeight = mod.MILK.WEIGHTS.UNCOMMON,NegWeight = mod.MILK.WEIGHTS.UNCOMMON},
    {Stat = "SPEED",    PosWeight = mod.MILK.WEIGHTS.COMMON,  NegWeight = mod.MILK.WEIGHTS.RARE},
    {Stat = "RANGE",    PosWeight = mod.MILK.WEIGHTS.COMMON,  NegWeight = mod.MILK.WEIGHTS.RARE},
    {Stat = "SHOTSPEED",PosWeight = mod.MILK.WEIGHTS.UNCOMMON,NegWeight = mod.MILK.WEIGHTS.UNCOMMON},
    {Stat = "LUCK",     PosWeight = mod.MILK.WEIGHTS.UNCOMMON,NegWeight = mod.MILK.WEIGHTS.UNCOMMON},
}

function mod:handleMilkRandomization(rng, negative)
    local wop = WeightedOutcomePicker()
    for i = 1, #mod.MILK.OPTIONS do
        if negative then
            wop:AddOutcomeWeight(i, mod.MILK.OPTIONS[i].NegWeight)
        else
            wop:AddOutcomeWeight(i, mod.MILK.OPTIONS[i].PosWeight)
        end
    end
    return mod.MILK.OPTIONS[wop:PickOutcome(rng)].Stat
end

function mod:selectMilk(rng)
    local pos = mod:handleMilkRandomization(rng)
    local neg = pos
    while neg == pos do
        neg = mod:handleMilkRandomization(rng, true)
    end
    return pos, neg
end

local MODULE_SPAWN_OFFSET = Vector(-45,0)
local MODULE_DEPTH_OFFSET = -3
local SPLATCOLOR = Color(1,1,1,1,1,1,1)

local function setMilkMachineSize(slot, d)
    slot:SetSize(9, Vector(2.2,1), 24)
    d.sizeMulti = Vector(2.2,1)
end

mod.MILK.BAPHOMETQUALITIES = {
    {Quality = 1, Weight = 1},
    {Quality = 2, Weight = 2},
    {Quality = 3, Weight = 4},
    {Quality = 4, Weight = 4},
    {Quality = 5, Weight = 4},
}

function mod:handleBaphometQualityRandomization(rng)
    local wop = WeightedOutcomePicker()
    for i = 1, #mod.MILK.BAPHOMETQUALITIES do
        wop:AddOutcomeWeight(i, mod.MILK.BAPHOMETQUALITIES[i].Weight)
    end
    return mod.MILK.BAPHOMETQUALITIES[wop:PickOutcome(rng)].Quality
end

-----------------------------------------------------------------------

local function getSlotSave(slot)
    return FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'SlotData', tostring(slot.InitSeed), {})
end

local function slotIsDead(slot)
    return slot:GetSprite():IsPlaying("Destroyed")
end

local function calcMilkColor(pos,neg,quality)
    local col1 = mod.MILK.COLORS[pos].UP.Color
    local col2 = mod.MILK.COLORS[neg].DOWN.Color
    quality = quality or 1
    return Color.Lerp(col2,col1,quality * 1/6)
end

local function getMilkColor(slot, d)
    local flavorModule = d.FlavorContainer
    if flavorModule and flavorModule:Exists() and not slotIsDead(flavorModule) then
        local flavaSave = getSlotSave(flavorModule)
        return flavaSave.containedPosMilk, flavaSave.containedNegMilk
    else
        local milk1, milk2 = mod:selectMilk(slot:GetDropRNG())
        return milk1, milk2
    end
end

local function getMilkQuality(slot, d)
    local qualityModule = d.QualityModulator
    if qualityModule and qualityModule:Exists() and not slotIsDead(qualityModule) then
        local qualitySave = getSlotSave(qualityModule)
        return qualitySave.QualityLevel
    else
        return 0
    end
end

local MC_TOSTAT = {
    "UP","UPMULT","DOWN","DOWNMULT"
}

local function deathDust(slot)
    for i=1,3 do
        local smoke = Isaac.Spawn(1000, EffectVariant.DUST_CLOUD, 0, slot.Position, RandomVector()*3, slot):ToEffect()
        smoke:SetTimeout(15)
        smoke.SpriteScale = Vector(0.05,0.05)
    end
end

local function HandleJam(slot, saveData, player)
    saveData.Insertions = saveData.Insertions or 0
    saveData.Insertions = saveData.Insertions + 1
    saveData.MilkDrunk = saveData.MilkDrunk or 0

    local hasLuckFoot = player:HasCollectible(CollectibleType.COLLECTIBLE_LUCKY_FOOT)

    local safetyCount = 3
    if hasLuckFoot then
        safetyCount = safetyCount + 1
    end
    safetyCount = safetyCount - saveData.MilkDrunk
    if saveData.Insertions > 2 then
        local chanceVal = 50
        chanceVal = chanceVal - (math.min(saveData.MilkDrunk * 2, 2) * 15)
        if hasLuckFoot then
            chanceVal = chanceVal + 6
        end

        local rando = slot:GetDropRNG()
        if rando:RandomInt(chanceVal) == 0 then
            if rando:RandomInt(7) == 0 then
                saveData.ShouldExplode = true
            else
                saveData.ShouldJam = true
            end
        end
    end
end

local function HandleJamDispenser(slot, saveData, player)
    saveData.MilkDrunk = saveData.MilkDrunk or 0

    local hasLuckFoot = player:HasCollectible(CollectibleType.COLLECTIBLE_LUCKY_FOOT)
    local jamTries = saveData.MilkDrunk
    if hasLuckFoot then
        jamTries = jamTries - 1
    end

    if jamTries >= 1 then
        for i = 1, jamTries do
            local rando = slot:GetDropRNG()
            if rando:RandomInt(5) == 0 then
                saveData.ShouldJam = true
            end
        end
    end
end

local function DestroySelf(slot, d)
    slot:SetState(SlotState.DESTROYED)
    slot.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
    d.DropFunc()
    sfx:Play(SoundEffect.SOUND_BOSS1_EXPLOSIONS)
    Isaac.Spawn(1000,1,0,slot.Position,Vector.Zero,nil)
end

local function tryDestroySelf(slot, d, saveData)
    if saveData.ShouldExplode and (not d.DidDropFunc) then
        DestroySelf(slot, d)
        return true
    end
end

function mod:applyMilkConcoction(player,pos,neg,quality)
    if not Isaac.RunCallbackWithParam(mod.CALLBACK.FF_PRE_ADD_MILK, player, pos, neg, quality) then
        Isaac.DebugString("------")
        Isaac.DebugString("Applying new milk:")
        for MilkApplicator = 1, 4 do
            local statChoice = MC_TOSTAT[MilkApplicator]
            local appliedCount = mod.MILK.BALANCE[quality][statChoice]
            for i = 1, appliedCount do
                local stat = pos
                if MilkApplicator >= 3 then
                    stat = neg
                end

                Isaac.DebugString(stat, statChoice)
                local NullItem = mod.MILK.STATS[stat][statChoice]
                player:AddNullItemEffect(NullItem)
                Isaac.RunCallbackWithParam(mod.CALLBACK.FF_POST_ADD_MILK_NULLITEM, player, NullItem)
            end
        end
    end
end

function mod:playerDrinkMilk(player, rng, quality, upColor, downColor)
    local milkSprite = Sprite()
    milkSprite:Load("gfx/items/slots/milk machine/little_milk.anm2")
    milkSprite:SetFrame("Idle", 0)
    local milkColor = calcMilkColor(upColor,downColor,quality)
    milkSprite:GetLayer("CupMilk"):SetColor(milkColor)
    player:AnimatePickup(milkSprite)
    sfx:Play(SoundEffect.SOUND_SHELLGAME, 0.3, 0, false, 0.75)
    sfx:Play(mod.Sounds.MilkGulp, 1, 0, false, 0.9 + rng:RandomInt(200)/1000)
    local ItemName = mod.MILK.RANKS[quality]
    local up = mod.MILK.COLORS[upColor].UP
    local down = mod.MILK.COLORS[downColor].DOWN
    local MilkNamePos = up.Name
    local MilkNameNeg = down.Name
    if MilkNamePos then
        ItemName = ItemName .. " " .. MilkNamePos .. " + " .. MilkNameNeg
    end
    ItemName = ItemName .. " Milk"
    local desc
    desc = up.Stat
    if mod.MILK.BALANCE[quality].UpString and #mod.MILK.BALANCE[quality].UpString > 0 then
        desc = desc .. " " .. mod.MILK.BALANCE[quality].UpString
    end
    desc = desc .. " up, "
    desc = desc .. down.Stat
    if mod.MILK.BALANCE[quality].UpString and #mod.MILK.BALANCE[quality].DownString > 0 then
        desc = desc .. " " .. mod.MILK.BALANCE[quality].DownString
    end
    desc = desc .. " down"
    game:GetHUD():ShowItemText(ItemName, desc)

    mod.GetPersistentPlayerData(player).MilkMachineGulp = {
        Quality = quality,
        StatUp = upColor,
        StatDown = downColor,
    }
end

function mod:playerDrinkRandomMilk(player, rng, mode)
    local rng = rng or player:GetCollectibleRNG(FiendFolio.ITEM.COLLECTIBLE.BAPHOMETS_EXCHANGE)
    local upColor, downColor
    if mode == "flip up/down" then
        downColor, upColor = mod:selectMilk(rng)
    elseif mode == "no weighting" then
        upColor = mod.MILK.OPTIONS[rng:RandomInt(#mod.MILK.OPTIONS) + 1].Stat
        downColor = upColor
        while downColor == upColor do
            downColor = mod.MILK.OPTIONS[rng:RandomInt(#mod.MILK.OPTIONS) + 1].Stat
        end
    else
        upColor, downColor = mod:selectMilk(rng)
    end
    local quality = mod:handleBaphometQualityRandomization(rng)
    mod:playerDrinkMilk(player, rng, quality, upColor, downColor)
end

mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, function(_, slot)
    local sprite, d = slot:GetSprite(), mod:GetEntityData(slot)
	local saveData = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'SlotData', tostring(slot.InitSeed), {})

    slot.DepthOffset = 5
    setMilkMachineSize(slot, d)
    slot.SplatColor = SPLATCOLOR

    if d.FlavorContainer and not d.FlavorContainer:Exists()
    or d.QualityModulator and not d.QualityModulator:Exists()
    then
        if d.FlavorContainer and not d.FlavorContainer:Exists() then
            d.QualityModulator.Parent = nil
        end
        if d.QualityModulator and not d.QualityModulator:Exists() then
            d.FlavorContainer.Parent = nil
        end
        d.FlavorContainer = nil
        d.QualityModulator = nil
        if d.state ~= "idleMilk" and d.state ~= "pour" then
            d.state = nil
        end
    end

    if not d.init then
        d.init = true
        if saveData.MilkDeets then
            d.state = "idleMilk"
            sprite:GetLayer("CupMilk"):SetColor(calcMilkColor(saveData.MilkDeets.ColorPos,saveData.MilkDeets.ColorNeg,saveData.MilkDeets.Quality))
        end
        if saveData.ShouldJam then
            saveData.Jammed = true
            saveData.ShouldJam = nil
        end
    end

    if not d.DropFunc then
		function d.DropFunc()
			if not d.DidDropFunc then
                deathDust(slot)
                d.DidDropFunc = true
                saveData.Jammed = false
            end
		end
	end

    if d.DidDropFunc then
        mod:spritePlay(sprite, "Destroyed")
    elseif d.state == "insertCoin" then
        mod:spritePlay(sprite, "Idle")
        if sprite:IsOverlayFinished("CoinInsert") then
            if saveData.ShouldJam then
                saveData.Jammed = true
                saveData.ShouldJam = nil
            end
            sprite:RemoveOverlay()
            mod:spritePlay(sprite, "IdleMilk")
            d.state = "activateOthers"
            local colpos, colneg = getMilkColor(slot, d)
            saveData.MilkDeets = {
                ColorPos = colpos,
                ColorNeg = colneg,
                Quality = getMilkQuality(slot, d)
            }
            sprite:GetLayer("CupMilk"):SetColor(mod.ColorInvisible)
            sprite:GetLayer("CupMilk"):SetRenderFlags(0)

            saveData.MilkDrunk = saveData.MilkDrunk or 0
            saveData.MilkDrunk = saveData.MilkDrunk + 1

            if d.FlavorContainer and d.FlavorContainer:Exists() and not slotIsDead(d.FlavorContainer) then
                local flavaData = mod:GetEntityData(d.FlavorContainer)
                local flavaSave = getSlotSave(d.FlavorContainer)
                flavaData.state = "wiggleFull"
                flavaSave.WipeMilk = true
                flavaSave.MilkDrunk = saveData.MilkDrunk
            end

            if d.QualityModulator and d.QualityModulator:Exists() and not slotIsDead(d.QualityModulator) then
                local modulatorSave = getSlotSave(d.QualityModulator)
                local modulatorData = mod:GetEntityData(d.QualityModulator)
                modulatorSave.storedQualityLevel = 1
                modulatorSave.ClearJam = true
                modulatorData.state = "wiggle"
                modulatorData.customCounter = 33
                modulatorSave.MilkDrunk = saveData.MilkDrunk
            end
        elseif sprite:IsOverlayEventTriggered("CoinInsert") then
            sfx:Play(SoundEffect.SOUND_COIN_SLOT, 1, 0, false, 1)
        else
            mod:spriteOverlayPlay(sprite, "CoinInsert")
        end
    elseif d.state == "activateOthers" then
        mod:spritePlay(sprite, "IdleMilk")

        d.Counter = d.Counter or 0
        d.Counter = d.Counter + 1
        if d.Counter > 33 then
            d.Counter = nil
            if saveData.Jammed then
                sprite:Play("ActivateShake", true)
            else
                sprite:Play("Activate", true)
            end
            local milkColor = calcMilkColor(saveData.MilkDeets.ColorPos,saveData.MilkDeets.ColorNeg,saveData.MilkDeets.Quality)
            sprite:GetLayer("MilkStream"):SetColor(milkColor)
            sprite:GetLayer("CupMilk"):SetColor(milkColor)
            d.state = "pour"
        end
    elseif d.state == "pour" then
        local activateAnim = "Activate"
        if saveData.Jammed then
            activateAnim = activateAnim .. "Shake"
        end
        if sprite:IsFinished(activateAnim) then
            d.state = "idleMilk"
            sfx:Stop(mod.Sounds.PeeLong2)
        elseif sprite:IsEventTriggered("MilkFlow") then
            sfx:Play(mod.Sounds.PeeLong2, 1.5, 0, false, 2)
        else
            mod:spritePlay(sprite, activateAnim)
        end
    elseif d.state == "idleMilk" then
        if saveData.Jammed then
            mod:spritePlay(sprite, "IdleMilkShake")
        else
            mod:spritePlay(sprite, "IdleMilk")
        end
    elseif d.state == "blowup" then
        mod:spritePlay(sprite, "IdleShake")
        d.blowupTimer = d.blowupTimer or 0
        d.blowupTimer = d.blowupTimer + 1
        if d.blowupTimer >= 30 then
            saveData.Jammed = nil
            DestroySelf(slot, d)
            local item = Isaac.Spawn(5, 100, mod.ITEM.COLLECTIBLE.BAPHOMETS_EXCHANGE, slot.Position + Vector(0,-10), Vector.Zero, slot):ToPickup()
            item.DepthOffset = 10
			if not FiendFolio.ACHIEVEMENT.BAPHOMETS_EXCHANGE:IsUnlocked(true) then
				FiendFolio.ACHIEVEMENT.BAPHOMETS_EXCHANGE:Unlock()
			end
            slot:Remove()
        end
    else
        mod:spritePlay(sprite, "Idle")
    end

    if d.cooldown then
        d.cooldown = d.cooldown - 1
        if d.cooldown <= 0 then
            d.cooldown = nil
        end
    end

    local jamOffset = 0
    if saveData.Jammed then
        jamOffset = 112
    end
    local baseMachine = sprite:GetLayer(1)
    baseMachine:SetCropOffset(Vector(0,jamOffset))

    FiendFolio.OverrideExplosionHack(slot, true)
end, mod.FF.MilkMachine.Var)

function mod:milkMachinePedestal(pickup)
	if pickup.Variant == 100 then
        local d = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'PedestalData', tostring(pickup.InitSeed), {})
		if d.explodedMilkPedestal or pickup.SpawnerEntity then
			if d.explodedMilkPedestal or (pickup.SpawnerEntity.Type == 6 and pickup.SpawnerEntity.Variant == mod.FF.MilkMachine.Var) then
				pickup:GetSprite():ReplaceSpritesheet(5, "gfx/items/slots/ff_chest_pedestals.png")
				pickup:GetSprite():LoadGraphics()
				pickup:GetSprite():SetOverlayFrame("Alternates", 2)
                d.explodedMilkPedestal = true
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.milkMachinePedestal)

mod:AddCallback(ModCallbacks.MC_POST_SLOT_INIT, function(_, slot)
    local sprite, d = slot:GetSprite(), mod:GetEntityData(slot)
	local saveData = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'SlotData', tostring(slot.InitSeed), {})
    slot.DepthOffset = 5
    if not saveData.init then
        saveData.init = true
        d.FlavorContainer = Isaac.Spawn(mod.FF.MilkFlavorContainer.ID, mod.FF.MilkFlavorContainer.Var,0,slot.Position + MODULE_SPAWN_OFFSET, Vector.Zero, slot)
        d.FlavorContainer.Parent = slot
        d.QualityModulator = Isaac.Spawn(mod.FF.MilkQualityModulator.ID, mod.FF.MilkQualityModulator.Var,0,slot.Position - MODULE_SPAWN_OFFSET, Vector.Zero, slot)
        d.QualityModulator.Parent = slot
    else
        local nearestContainer
        local containerDist = 50
        local nearestModulator
        local modulatorDist = 50
        for _, slotSearch in pairs(Isaac.FindByType(6, -1, -1, false, false)) do
            if slotSearch.Variant == mod.FF.MilkFlavorContainer.Var then
                local pos = slot.Position + MODULE_SPAWN_OFFSET
                local dist = pos:Distance(slotSearch.Position)
                if dist < containerDist then
                    dist = containerDist
                    nearestContainer = slotSearch
                end
            elseif slotSearch.Variant == mod.FF.MilkQualityModulator.Var then
                local pos = slot.Position - MODULE_SPAWN_OFFSET
                local dist = pos:Distance(slotSearch.Position)
                if dist < modulatorDist then
                    dist = modulatorDist
                    nearestModulator = slotSearch
                end
            end
        end
        if nearestContainer and nearestModulator then
            d.FlavorContainer = nearestContainer
            d.FlavorContainer.Parent = slot
            d.QualityModulator = nearestModulator
            d.QualityModulator.Parent = slot
        end
    end
end, mod.FF.MilkMachine.Var)

FiendFolio.onMachineTouch(mod.FF.MilkMachine.Var, function(player, slot)
    local sprite, d = slot:GetSprite(), mod:GetEntityData(slot)
	local saveData = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'SlotData', tostring(slot.InitSeed), {})

    if (not (d.state or d.cooldown))
    and (not slotIsDead(slot))
    --and d.FlavorContainer and d.FlavorContainer:Exists()
    --and d.QualityModulator and d.QualityModulator:Exists()
    then
        local milkColorPos, milkColorNeg = getMilkColor(slot, d)
        local milkQuality = getMilkQuality(slot, d)
        --Weirdo stuff
        local flavaData = {}
        local modulatorData = {}
        if d.FlavorContainer and d.FlavorContainer:Exists() and not slotIsDead(d.FlavorContainer) then
            flavaData = mod:GetEntityData(d.FlavorContainer)
        end
        if d.QualityModulator and d.QualityModulator:Exists() and not slotIsDead(d.QualityModulator) then
            modulatorData = mod:GetEntityData(d.QualityModulator)
        end

        if milkColorPos and milkColorNeg and milkQuality
        and flavaData.state == nil
        and modulatorData.state == nil then
            if player:GetNumCoins() >= 5 then
                player:AddCoins(-5)
                d.state = "insertCoin"
                sprite:GetLayer("MilkStream"):SetColor(mod.ColorNormal)
                sprite:GetLayer("MilkStream"):SetRenderFlags(0)
                sprite:GetLayer("CupMilk"):SetColor(mod.ColorInvisible)
                flavaData.state = "Waiting"
                modulatorData.state = "Waiting"
                HandleJamDispenser(slot, saveData, player)
            end
        end
    elseif d.state == "idleMilk" and (not slotIsDead(slot)) then
        if player:IsExtraAnimationFinished() then
            d.state = nil
            d.cooldown = 30

            mod:playerDrinkMilk(player, slot:GetDropRNG(), saveData.MilkDeets.Quality, saveData.MilkDeets.ColorPos, saveData.MilkDeets.ColorNeg)

            saveData.MilkDeets = nil
            sprite:GetLayer("CupMilk"):SetRenderFlags(0)

            if saveData.Jammed then
                d.state = "blowup"
            end
        end
    end
end)

function mod:milkPlayerUpdate(player, data, sdata)
    if sdata.MilkMachineGulp then
        if player:IsExtraAnimationFinished() then
            sfx:Play(mod.Sounds.MilkSigh, 1, 0, false, 0.9 + player:GetDropRNG():RandomInt(200)/1000)
            mod:applyMilkConcoction(player,sdata.MilkMachineGulp.StatUp,sdata.MilkMachineGulp.StatDown,sdata.MilkMachineGulp.Quality)
            sdata.MilkMachineGulp = nil
        end
    end
end

-----------------------------------------------------------------------

local function updateFlavorContainerStats(slot, saveData, sprite)
    local posMilk = saveData.containedPosMilk
    local negMilk = saveData.containedNegMilk
    if posMilk and negMilk then
        local posIndicator = sprite:GetLayer("StatPositive")
        local negIndicator = sprite:GetLayer("StatNegative")
        posIndicator:SetCropOffset(mod.MILK.COLORS[posMilk].IconOffset)
        negIndicator:SetCropOffset(mod.MILK.COLORS[negMilk].IconOffset)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, function(_, slot)
    local sprite, d = slot:GetSprite(), mod:GetEntityData(slot)
	local saveData = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'SlotData', tostring(slot.InitSeed), {})

    slot.DepthOffset = MODULE_DEPTH_OFFSET
    setMilkMachineSize(slot, d)
    slot.SplatColor = SPLATCOLOR

	if not d.DropFunc then
		function d.DropFunc()
			if not d.DidDropFunc then
                deathDust(slot)
                d.DidDropFunc = true
                saveData.Jammed = false
                if saveData.containedPosMilk and saveData.containedNegMilk then
                    local expectedQuality
                    if slot.Parent then
                        local quality = getMilkQuality(slot.Parent, mod:GetEntityData(slot.Parent))
                        if quality then
                            expectedQuality = quality
                        end
                    end
                    local targetCol = calcMilkColor(saveData.containedPosMilk, saveData.containedNegMilk, expectedQuality)
                    local creep = Isaac.Spawn(1000,90,0,slot.Position,Vector.Zero,slot)
                    creep.Color = targetCol
                    creep:Update()
                    sfx:Play(SoundEffect.SOUND_HEARTIN, 0.6,0,false,0.8)
                end
            end
		end
	end

    if not d.init then
        d.init = true
        if saveData.WipeMilk then
            saveData.containedPosMilk = nil
            saveData.containedNegMilk = nil
            saveData.storedPosMilk = nil
            saveData.storedNegMilk = nil
            saveData.WipeMilk = nil
            saveData.Jammed = nil
        else
            if saveData.storedPosMilk then
                saveData.containedPosMilk = saveData.storedPosMilk
            end
            if saveData.storedNegMilk then
                saveData.containedNegMilk = saveData.storedNegMilk
            end
            if saveData.containedPosMilk and saveData.containedNegMilk then
                local milk = sprite:GetLayer(1)
                milk:SetColor(calcMilkColor(saveData.containedPosMilk, saveData.containedNegMilk))
                updateFlavorContainerStats(slot, saveData, sprite)
                --[[if milkType.Special == "Golden" then
                    milk:SetRenderFlags(AnimRenderFlags.GOLDEN)
                    d.IsGolden = true
                else
                    milk:SetRenderFlags(0)
                    d.IsGolden = false
                end]]
            end
        end
        if saveData.ShouldJam then
            saveData.Jammed = true
            saveData.ShouldJam = nil
        end
        tryDestroySelf(slot, d, saveData)
    end

    if (slot.Parent and slotIsDead(slot.Parent)) or (not slot.Parent) then
        if not d.DidDropFunc then
            slot:SetState(SlotState.DESTROYED)
            slot.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
            d.DropFunc()
        end
    end

    if d.DidDropFunc then
        mod:spritePlay(sprite, "Destroyed")
    elseif d.state == "insertCoin" then
        if sprite:IsOverlayFinished("CoinInsert") then
            if saveData.ShouldJam then
                saveData.Jammed = true
                saveData.ShouldJam = nil
            end
            sprite:RemoveOverlay()
            if saveData.containedPosMilk or saveData.containedNegMilk then
                d.state = "wiggleFull"
            else
                d.state = "wiggleEmpty"
            end
        elseif sprite:IsOverlayEventTriggered("CoinInsert") then
            sfx:Play(SoundEffect.SOUND_COIN_SLOT, 1, 0, false, 1)
        else
            mod:spriteOverlayPlay(sprite, "CoinInsert")
        end
    elseif d.state == "wiggleFull" then
        mod:spritePlay(sprite, "WiggleFilled")
        d.Counter = d.Counter or 0
        d.Counter = d.Counter + 1
        if d.Counter > 10 then
            d.Counter = nil
            d.state = "drain"
            sfx:Play(SoundEffect.SOUND_GASCAN_POUR, 0.3,0,false,1)
            tryDestroySelf(slot, d, saveData)
        end
    elseif d.state == "wiggleEmpty" then
        mod:spritePlay(sprite, "WiggleEmpty")
        d.Counter = d.Counter or 0
        d.Counter = d.Counter + 1
        if d.Counter > 10 then
            d.Counter = nil
            sfx:Stop(SoundEffect.SOUND_GASCAN_POUR)
            if saveData.WipeMilk then
                saveData.containedPosMilk = nil
                saveData.containedNegMilk = nil
                saveData.storedPosMilk = nil
                saveData.storedNegMilk = nil
                saveData.WipeMilk = nil
                saveData.Jammed = nil
                d.state = "wiggleEnd"
            else
                d.state = "fill"
                sfx:Play(SoundEffect.SOUND_BLOODBANK_TOUCHED, 0.3,0,false,1.3)
                saveData.containedPosMilk = saveData.storedPosMilk
                saveData.containedNegMilk = saveData.storedNegMilk
                saveData.storedPosMilk = nil
                saveData.storedNegMilk = nil
                local milk = sprite:GetLayer(1)
                milk:SetColor(calcMilkColor(saveData.containedPosMilk, saveData.containedNegMilk))
            end
            tryDestroySelf(slot, d, saveData)
        end
    elseif d.state == "fill" then
        if sprite:IsFinished("Fill") then
            d.state = "wiggleFillEnd"
            --sfx:Stop(SoundEffect.SOUND_BLOODBANK_TOUCHED)
            --sfx:Play(SoundEffect.SOUND_BOSS2_BUBBLES,0.3,0,false,0.7)
        else
            mod:spritePlay(sprite, "Fill")
        end
    elseif d.state == "wiggleFillEnd" then
        if sprite:IsFinished("WiggleEndFilled") then
            d.state = nil
            sprite:Play("FilledBubble", true)
            sfx:Play(SoundEffect.SOUND_BEEP,1,0,false,0.2 + slot:GetDropRNG():RandomInt(100)/1000)
            sfx:Play(mod.Sounds.WaterSwish,1,0,false,0.9 + slot:GetDropRNG():RandomInt(200)/1000)
        elseif sprite:IsEventTriggered("LightsOn") then
            updateFlavorContainerStats(slot, saveData, sprite)
        else
            mod:spritePlay(sprite, "WiggleEndFilled")
        end
    elseif d.state == "wiggleEnd" then
        if sprite:IsFinished("WiggleEndEmpty") then
            d.state = nil
        else
            mod:spritePlay(sprite, "WiggleEndEmpty")
        end
    elseif d.state == "drain" then
        if sprite:IsFinished("Drain") then
            d.state = "wiggleEmpty"
        else
            mod:spritePlay(sprite, "Drain")
        end
    else
        if saveData.containedPosMilk or saveData.containedNegMilk then
            if not sprite:IsPlaying("FilledBubble") then
                mod:spritePlay(sprite, "IdleFilled")
                if slot.FrameCount % 120 == 0 and slot:GetDropRNG():RandomInt(3) == 1 then
                    sprite:Play("FilledBubble", true)
                    sfx:Play(mod.Sounds.WaterSwish,0.3,0,false,0.9 + slot:GetDropRNG():RandomInt(200)/1000)
                end
            end
            local expectedQuality
            if slot.Parent then
                local quality = getMilkQuality(slot.Parent, mod:GetEntityData(slot.Parent))
                if quality then
                    expectedQuality = quality
                end
            end
            --print(expectedQuality)
            local targetCol = calcMilkColor(saveData.containedPosMilk, saveData.containedNegMilk, expectedQuality)
            local milk = sprite:GetLayer(1)
            local currentCol = milk:GetColor()
            local newCol = Color.Lerp(currentCol, targetCol, 0.1)
            milk:SetColor(newCol)
        else
            mod:spritePlay(sprite, "IdleEmpty")
        end
    end

    local jamOffset = 0
    if saveData.Jammed then
        jamOffset = 160
    end
    local baseMachine = sprite:GetLayer(0)
    baseMachine:SetCropOffset(Vector(0,jamOffset))

    FiendFolio.OverrideExplosionHack(slot, true)
end, mod.FF.MilkFlavorContainer.Var)

FiendFolio.onMachineTouch(mod.FF.MilkFlavorContainer.Var, function(player, slot)
    local sprite, d = slot:GetSprite(), mod:GetEntityData(slot)
	local saveData = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'SlotData', tostring(slot.InitSeed), {})

    if (not d.state)
    and (not slotIsDead(slot))
    and slot.Parent
    and (not mod:GetEntityData(slot.Parent).state)
    and (not slotIsDead(slot.Parent))
    and (not saveData.Jammed) then
        if player:GetNumCoins() >= 1 then
            player:AddCoins(-1)
            d.state = "insertCoin"
            local rng = slot:GetDropRNG()
            --saveData.storedMilk = mod:selectMilk(rng)
            saveData.storedPosMilk, saveData.storedNegMilk = mod:selectMilk(rng)
            HandleJam(slot, saveData, player)
        end
    end
end)

-----------------------------------------------------------------------

local function updateDialVal(slot,d,saveData)
    local dialLevel = saveData.QualityLevel
    local targVal = (dialLevel - 1) * 2
    d.currentDialVal = d.currentDialVal or targVal
    if slot.FrameCount % 2 == 0 then
        if targVal > d.currentDialVal then
            d.currentDialVal = d.currentDialVal + 1
        elseif targVal < d.currentDialVal then
            d.currentDialVal = d.currentDialVal - 1
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, function(_, slot)
    local sprite, d = slot:GetSprite(), mod:GetEntityData(slot)
	local saveData = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'SlotData', tostring(slot.InitSeed), {})

    slot.DepthOffset = MODULE_DEPTH_OFFSET
    setMilkMachineSize(slot, d)
    slot.SplatColor = SPLATCOLOR

    if not d.init then
        d.init = true
        if saveData.storedQualityLevel then
            saveData.QualityLevel = saveData.storedQualityLevel
        end
        if saveData.ShouldJam then
            saveData.Jammed = true
            saveData.ShouldJam = nil
        end
        tryDestroySelf(slot, d, saveData)
        if saveData.ClearJam then
            saveData.ClearJam = nil
            saveData.Jammed = nil
        end
    end

    saveData.QualityLevel = saveData.QualityLevel or 1

	if not d.DropFunc then
		function d.DropFunc()
			if not d.DidDropFunc then
                deathDust(slot)
                d.DidDropFunc = true
                saveData.Jammed = false
            end
		end
	end

    if (slot.Parent and slotIsDead(slot.Parent)) or (not slot.Parent) then
        slot:SetState(SlotState.DESTROYED)
        slot.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
        d.DropFunc()
    end

    if d.DidDropFunc then
        mod:spritePlay(sprite, "Destroyed")
    elseif d.state == "insertCoin" then
        if sprite:IsOverlayFinished("CoinInsert") then
            if saveData.ShouldJam then
                saveData.Jammed = true
                saveData.ShouldJam = nil
            end
            sprite:RemoveOverlay()
            d.state = "wiggle"
        elseif sprite:IsOverlayEventTriggered("CoinInsert") then
            sfx:Play(SoundEffect.SOUND_COIN_SLOT, 1, 0, false, 1)
        else
            mod:spriteOverlayPlay(sprite, "CoinInsert")
        end
    elseif d.state == "wiggle" then
        mod:spritePlay(sprite, "Wiggle")
        d.Counter = d.Counter or 0
        d.Counter = d.Counter + 1
        if d.Counter > (d.customCounter and d.customCounter or 10) then
            d.Counter = nil
            d.customCounter = nil
            if saveData.ClearJam then
                saveData.ClearJam = nil
                saveData.Jammed = nil
            end
            d.state = "wiggleOver"
            tryDestroySelf(slot, d, saveData)
        end
    elseif d.state == "wiggleOver" then
        if sprite:IsFinished("WiggleEnd") then
            d.state = nil
            if d.storedPlayer and d.storedPlayer:Exists() then
                if (saveData.storedQualityLevel == 1) or (saveData.storedQualityLevel < saveData.QualityLevel) then
                    d.storedPlayer:AnimateSad()
                else
                    d.storedPlayer:AnimateHappy()
                end
                d.storedPlayer = nil
            end
            saveData.QualityLevel = saveData.storedQualityLevel
            saveData.storedQualityLevel = nil
            sprite:SetFrame("IdleLevel" .. saveData.QualityLevel, 0)
        else
            mod:spritePlay(sprite, "WiggleEnd")
        end
        updateDialVal(slot,d,saveData)
    else
        if (not slot.Parent) or slotIsDead(slot.Parent) or (slot.Parent and mod:GetEntityData(slot.Parent).state and sprite:GetFrame() <= 1) then
            sprite:SetFrame("IdleLevel1", 0)
        else
            mod:spritePlay(sprite, "IdleLevel" .. saveData.QualityLevel)
            if sprite:GetFrame() == 0 then
                sfx:Play(SoundEffect.SOUND_BEEP,0.1,0,false,0.2 * (saveData.QualityLevel/5))
            end
        end
        updateDialVal(slot,d,saveData)
    end


    local dial = sprite:GetLayer(2)
    dial:SetCropOffset(Vector(16 * d.currentDialVal, 0))

    local jamOffset = 0
    if saveData.Jammed then
        jamOffset = 160
    end
    local baseMachine = sprite:GetLayer(0)
    baseMachine:SetCropOffset(Vector(0,jamOffset))

    FiendFolio.OverrideExplosionHack(slot, true)
end, mod.FF.MilkQualityModulator.Var)

FiendFolio.onMachineTouch(mod.FF.MilkQualityModulator.Var, function(player, slot)
    local sprite, d = slot:GetSprite(), mod:GetEntityData(slot)
	local saveData = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'SlotData', tostring(slot.InitSeed), {})

    if (not d.state)
    and (not slotIsDead(slot))
    and (saveData.QualityLevel and saveData.QualityLevel < 5)
    and (slot.Parent) and (not mod:GetEntityData(slot.Parent).state)
    and (not slotIsDead(slot.Parent))
    and (not saveData.Jammed) then
        if player:GetNumCoins() >= 1 then
            player:AddCoins(-1)
            d.state = "insertCoin"
            local rng = slot:GetDropRNG()
            if rng:RandomInt(mod.MILK.NUMBERFIDDLING.QualityRoll) < saveData.QualityLevel then
                local rand = rng:RandomInt(5)
                if rand == 1 then
                    saveData.storedQualityLevel = 1
                elseif rand == 2 then
                    saveData.storedQualityLevel = math.max(1, saveData.QualityLevel - 2)
                else
                    saveData.storedQualityLevel = math.max(1, saveData.QualityLevel - 1)
                end
            else
                local rollVal = 100
                if saveData.QualityLevel < 3 then
                    rollVal = 20
                end
                local rand = rng:RandomInt(rollVal)
                if rand == 1 then
                    saveData.storedQualityLevel = math.min(5, saveData.QualityLevel + 2)
                else
                    saveData.storedQualityLevel = math.min(5, saveData.QualityLevel + 1)
                end
            end
            d.storedPlayer = player
            HandleJam(slot, saveData, player)
        end
    end
end)

-----------------------------------------------------------------------

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, typ, rng, player)
    if player:IsExtraAnimationFinished()
    and (player:GetNumCoins() >= 5)
    then
        mod:playerDrinkRandomMilk(player, rng, "flip up/down")
        player:AddCoins(-5)
        return {
            Discharge = true,
            Remove = false,
            ShowAnim = false,
        }
    end
    return {
        Discharge = false,
        ShowAnim = false,
        Remove = false,
    }
end, mod.ITEM.COLLECTIBLE.BAPHOMETS_EXCHANGE)