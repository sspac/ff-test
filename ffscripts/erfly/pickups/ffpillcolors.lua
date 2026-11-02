local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

--ONLY REGULAR COLOURS
--This is not for specil pills like cyanide
mod.FFPillColours = {
    mod.PICKUP.PILLCOLOR.BLACKPURPLE,   mod.PICKUP.PILLCOLOR.BLACKPURPLE    | PillColor.PILL_GIANT_FLAG,
    mod.PICKUP.PILLCOLOR.PURPLEORANGE,  mod.PICKUP.PILLCOLOR.PURPLEORANGE   | PillColor.PILL_GIANT_FLAG,
    mod.PICKUP.PILLCOLOR.BLUEYELLOW,    mod.PICKUP.PILLCOLOR.BLUEYELLOW     | PillColor.PILL_GIANT_FLAG,
    mod.PICKUP.PILLCOLOR.BLUESILVER,    mod.PICKUP.PILLCOLOR.BLUESILVER     | PillColor.PILL_GIANT_FLAG,
    mod.PICKUP.PILLCOLOR.DOTSVIOLET,    mod.PICKUP.PILLCOLOR.DOTSVIOLET     | PillColor.PILL_GIANT_FLAG,
    mod.PICKUP.PILLCOLOR.MAROONSHADOW,  mod.PICKUP.PILLCOLOR.MAROONSHADOW   | PillColor.PILL_GIANT_FLAG,
    mod.PICKUP.PILLCOLOR.DOTSLIME,      mod.PICKUP.PILLCOLOR.DOTSLIME       | PillColor.PILL_GIANT_FLAG,
    mod.PICKUP.PILLCOLOR.EMERALDBEIGE,  mod.PICKUP.PILLCOLOR.EMERALDBEIGE   | PillColor.PILL_GIANT_FLAG,
    mod.PICKUP.PILLCOLOR.BLACKBLACK,    mod.PICKUP.PILLCOLOR.BLACKBLACK     | PillColor.PILL_GIANT_FLAG,
    mod.PICKUP.PILLCOLOR.REDRED,        mod.PICKUP.PILLCOLOR.REDRED         | PillColor.PILL_GIANT_FLAG,
    mod.PICKUP.PILLCOLOR.DOTSBLUE,      mod.PICKUP.PILLCOLOR.DOTSBLUE       | PillColor.PILL_GIANT_FLAG,
    mod.PICKUP.PILLCOLOR.DOTSPINK,      mod.PICKUP.PILLCOLOR.DOTSPINK       | PillColor.PILL_GIANT_FLAG,
    mod.PICKUP.PILLCOLOR.IVORYBYZANTIUM,mod.PICKUP.PILLCOLOR.IVORYBYZANTIUM | PillColor.PILL_GIANT_FLAG,
    mod.PICKUP.PILLCOLOR.WHITEORANGE,   mod.PICKUP.PILLCOLOR.WHITEORANGE    | PillColor.PILL_GIANT_FLAG,
    mod.PICKUP.PILLCOLOR.DOTSBLACK,     mod.PICKUP.PILLCOLOR.DOTSBLACK      | PillColor.PILL_GIANT_FLAG,
    mod.PICKUP.PILLCOLOR.RAINBOWGREY,   mod.PICKUP.PILLCOLOR.RAINBOWGREY    | PillColor.PILL_GIANT_FLAG,
    mod.PICKUP.PILLCOLOR.GREYTEAL,      mod.PICKUP.PILLCOLOR.GREYTEAL       | PillColor.PILL_GIANT_FLAG,
    mod.PICKUP.PILLCOLOR.DOTSYELLOW,    mod.PICKUP.PILLCOLOR.DOTSYELLOW     | PillColor.PILL_GIANT_FLAG,
    mod.PICKUP.PILLCOLOR.YELLOWCOW,     mod.PICKUP.PILLCOLOR.YELLOWCOW      | PillColor.PILL_GIANT_FLAG,
    mod.PICKUP.PILLCOLOR.TAUPEOFFBLACK, mod.PICKUP.PILLCOLOR.TAUPEOFFBLACK  | PillColor.PILL_GIANT_FLAG,
    mod.PICKUP.PILLCOLOR.COWCOW,        mod.PICKUP.PILLCOLOR.COWCOW         | PillColor.PILL_GIANT_FLAG,
    mod.PICKUP.PILLCOLOR.STRAWBERRYCOW, mod.PICKUP.PILLCOLOR.STRAWBERRYCOW  | PillColor.PILL_GIANT_FLAG,
    mod.PICKUP.PILLCOLOR.CHOCOLATECOW,  mod.PICKUP.PILLCOLOR.CHOCOLATECOW   | PillColor.PILL_GIANT_FLAG,
    mod.PICKUP.PILLCOLOR.GREENBROWN,    mod.PICKUP.PILLCOLOR.GREENBROWN     | PillColor.PILL_GIANT_FLAG,
}
--Just lets you pass isFFPill[101] or somethin to test it
local isFFPill = {}
do
    for i = 1, #mod.FFPillColours do
        isFFPill[mod.FFPillColours[i]] = true
    end
end

mod:AddCallback(ModCallbacks.MC_GET_PILL_EFFECT, function(_, pillEffect, pillColor, player)
    if isFFPill[pillColor] then
        local pillRegulise = pillColor % 2048
        local pillreplaced = 1
        if FiendFolio.savedata.run.PillCopies and FiendFolio.savedata.run.PillCopies[tostring(pillRegulise)] then
            pillreplaced = FiendFolio.savedata.run.PillCopies[tostring(pillRegulise)]
            --print(pillreplaced)
        end
        --[[local string = ""
        for i = 1, #mod.FFPillColours do
            if FiendFolio.savedata.run.PillCopies[tostring(mod.FFPillColours[i])] then
                string = string .. "{" .. mod.FFPillColours[i] .. ":" .. FiendFolio.savedata.run.PillCopies[tostring(mod.FFPillColours[i])] .. "}, "
            end
        end
        print(string)]]

        FiendFolio.savedata.run.IdentifiedRunPills = FiendFolio.savedata.run.IdentifiedRunPills or {}
        local itempool = game:GetItemPool()

        if itempool:IsPillIdentified(pillreplaced) and not FiendFolio.savedata.run.IdentifiedRunPills[tostring(pillRegulise)] then
            FiendFolio.savedata.run.IdentifiedRunPills[tostring(pillRegulise)] = true
        end

        if FiendFolio.savedata.run.IdentifiedRunPills[tostring(pillRegulise)] then
            local effect = itempool:GetPillEffect(pillreplaced, player)
            if effect == mod.ITEM.PILL.FF_UNIDENTIFIED then
                effect = mod.ITEM.PILL.SPIDER_UNBOXING
            end
            return effect
        else
            return mod.ITEM.PILL.FF_UNIDENTIFIED
        end

        --[[
        local phdp = mod.phdPlayer()
        local fphdp = mod.falsephdPlayer()
        local gpp = mod.goodPillPlayer()
        if (phdp or (gpp and FiendFolio.savedata.run.IdentifiedRunPills[tostring(pillRegulise)])) and fphdp then
            FiendFolio.savedata.run.IdentifiedRunPills[tostring(pillRegulise)] = true
            if not itempool:IsPillIdentified(pillreplaced) then
                itempool:IdentifyPill(pillreplaced)
            end
            local effect = itempool:GetPillEffect(pillreplaced, Isaac.GetPlayer())
            if effect == mod.ITEM.PILL.FF_UNIDENTIFIED then
                effect = mod.ITEM.PILL.SPIDER_UNBOXING
            end
            return effect
        elseif phdp or fphdp or (gpp and FiendFolio.savedata.run.IdentifiedRunPills[tostring(pillRegulise)]) then
            FiendFolio.savedata.run.IdentifiedRunPills[tostring(pillRegulise)] = true
            if not itempool:IsPillIdentified(pillreplaced) then
                itempool:IdentifyPill(pillreplaced)
            end
            local effect = itempool:GetPillEffect(pillreplaced, phdp or gpp or fphdp)
            if effect == mod.ITEM.PILL.FF_UNIDENTIFIED then
                effect = mod.ITEM.PILL.SPIDER_UNBOXING
            end
            return effect
        else
            if FiendFolio.savedata.run.IdentifiedRunPills[tostring(pillRegulise)] then
                local effect = itempool:GetPillEffect(pillreplaced, Isaac.GetPlayer())
                if effect == mod.ITEM.PILL.FF_UNIDENTIFIED then
                    effect = mod.ITEM.PILL.SPIDER_UNBOXING
                end
                return effect
            else
                return mod.ITEM.PILL.FF_UNIDENTIFIED
            end
        end
        ]]
    end
end)

mod:AddCallback(ModCallbacks.MC_GET_PILL_EFFECT, function(_, pillEffect, pillColor)
    if pillColor % 2048 < 100 and pillEffect == mod.ITEM.PILL.FF_UNIDENTIFIED then
        return PillEffect.PILLEFFECT_I_FOUND_PILLS
    end
end)

mod:AddCallback(ModCallbacks.MC_PRE_USE_PILL, function(_, pillEffect, pillColor, player, flags)
    --Freaking safety checks man, still breaks with echo chamber ig BUT OH FREAKING WELL
    --Repentogon should let this be fixed with echo chamber at least!
    Isaac.DebugString("INITIAL PILL IDENTIFICATION FAILED, USING BACKUP")
    local pill = pillColor
    pill = pill % 2048
    FiendFolio.savedata.run.IdentifiedRunPills = FiendFolio.savedata.run.IdentifiedRunPills or {}
    if not FiendFolio.savedata.run.IdentifiedRunPills[tostring(pill)] then
        FiendFolio.savedata.run.IdentifiedRunPills[tostring(pill)] = true
    end

    local pillreplaced = 1
    if FiendFolio.savedata.run.PillCopies and FiendFolio.savedata.run.PillCopies[tostring(pill)] then
        pillreplaced = FiendFolio.savedata.run.PillCopies[tostring(pill)]
    end

    local itempool = Game():GetItemPool()
    local usedEffect = itempool:GetPillEffect(pillreplaced, player)
    player:UsePill(usedEffect, pill)
    return true
end, mod.ITEM.PILL.FF_UNIDENTIFIED)

--[[local pillEID = {
    {"en_us", "Unidentified Pill"},

    {"cs_cz", "Neznámá Pilulka"},
    {"de", "Unidentifizierte Pille"},
    {"en_us_detailed", "Unidentified Pill"},
    {"fr", "Pilule non identifiée"},
    {"it", "Pillola non identificata"},
    {"ja_jp", "未識別のピル"},
    {"ko_kr", "확인되지 않은 알약"},
    {"pl", "Nieznana Pigułka"},
    {"pt", "Comprimido não identificado"},
    {"pt_br", "Pílula não identificada"},
    {"ru", "Неизвестная пилюля"},
    {"spa", "Píldora sin identificar"},
    {"tr_tr", "Tanımlanmamış Hap"},
    {"zh_cn", "不明胶囊"},
}]]

--Sorry wofsauge
--if EID then
--    for k = 1, #pillEID do
--        for i = 1, #EID.descriptions[pillEID[k][1]].pills do
--            if EID.descriptions[pillEID[k][1]].pills[i][1] == "31" then
--                EID.descriptions[pillEID[k][1]].pills[i] = {"31", pillEID[k][2], ""}
--            end
--        end
--    end
--end

if EID then
    if tonumber(EID.ModVersion) then
        local ver = tonumber(EID.ModVersion)
        if ver >= 4.35 then
            EID:SetPillEffectUnidentifyable(mod.ITEM.PILL.FF_UNIDENTIFIED, true)
        end
    end
end

--Thanks Éole
local function allowPillReplacement(pillColor)
    FFDontAllowPillReplacement = FFDontAllowPillReplacement or {} --Global, make sure not to overwrite on defining it if anyone uses it. CBA to make functions.
    for _,fnc in pairs(FFDontAllowPillReplacement) do
        if fnc(pillColor) then
            return false
        end
    end
    return true
end

function mod:GetPillReplacement(pillColor)
    if FiendFolio.savedata and FiendFolio.savedata.run and FiendFolio.savedata.run.PillBeingReplaced then
        if allowPillReplacement(pillColor) then
            local undecoratedPillColor = pillColor & PillColor.PILL_COLOR_MASK
            local pillFlags = pillColor & (~PillColor.PILL_COLOR_MASK)
            if FiendFolio.savedata.run.PillBeingReplaced[tostring(undecoratedPillColor)] then
                return FiendFolio.savedata.run.PillBeingReplaced[tostring(undecoratedPillColor)] | pillFlags
            end
        end
    end
end

function mod:CheckPlayerPillReplacements(player)
    for i = 0, 3 do
        local pillColor = player:GetPill(i)
        local replacement = mod:GetPillReplacement(pillColor)
        if replacement then
            player:SetPill(i, replacement)
        end
    end
end

mod:AddPriorityCallback(ModCallbacks.MC_PRE_PLAYER_ADD_PILL, CallbackPriority.EARLY, function(_, player, pillColor, slot)
    return mod:GetPillReplacement(pillColor)
end)

function mod:pillShitPostAddPHD(_, _, firstTime, _, _, player)
    if firstTime then
        for i = 1, #mod.FFPillColours do
            FiendFolio.savedata.run.IdentifiedRunPills = FiendFolio.savedata.run.IdentifiedRunPills or {}
            FiendFolio.savedata.run.IdentifiedRunPills[tostring(mod.FFPillColours[i])] = true
            if EID and EID.UsedPillColors then  -- sorry eid, again
                EID.UsedPillColors[tostring(mod.FFPillColours[i])] = true
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.pillShitPostAddPHD, CollectibleType.COLLECTIBLE_PHD)
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.pillShitPostAddPHD, CollectibleType.COLLECTIBLE_FALSE_PHD)

mod:AddPriorityCallback(ModCallbacks.MC_INPUT_ACTION, CallbackPriority.LATE, function(_, ent, hook, action)
    if hook == InputHook.IS_ACTION_TRIGGERED and (action == ButtonAction.ACTION_ITEM or action == ButtonAction.ACTION_PILLCARD) then
        if ent and action then
            local player = ent:ToPlayer()
            if player and player:GetPill(0) > 0 then
                if player.ControlsEnabled and player.ControlsCooldown == 0 and (not player:IsHoldingItem()) and (not mod:isScare(player)) then
                    --print("yes")
                    local usingPill = false
                    if (Input.IsActionTriggered(ButtonAction.ACTION_ITEM, player.ControllerIndex) and player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) == CollectibleType.COLLECTIBLE_PLACEBO) then
                        usingPill = true
                    elseif player:GetPlayerType() == PlayerType.PLAYER_JACOB then
                        if Input.IsActionTriggered(ButtonAction.ACTION_ITEM, player.ControllerIndex) and Input.IsActionPressed(ButtonAction.ACTION_DROP, player.ControllerIndex) then
                            usingPill = true
                        end
                    elseif player:GetPlayerType() == PlayerType.PLAYER_ESAU then
                        if Input.IsActionTriggered(ButtonAction.ACTION_PILLCARD, player.ControllerIndex) and Input.IsActionPressed(ButtonAction.ACTION_DROP, player.ControllerIndex) then
                            usingPill = true
                        end
                    else
                        if Input.IsActionTriggered(ButtonAction.ACTION_PILLCARD, player.ControllerIndex) then
                            usingPill = true
                        end
                    end

                    if usingPill then
                        --print("identify")
                        local pill = player:GetPill(0)
                        pill = pill % 2048
                        FiendFolio.savedata.run.IdentifiedRunPills = FiendFolio.savedata.run.IdentifiedRunPills or {}
                        if not FiendFolio.savedata.run.IdentifiedRunPills[tostring(pill)] then
                            FiendFolio.savedata.run.IdentifiedRunPills[tostring(pill)] = true
                        end
                    end
                else
                    --print("no")
                end
            end
        end
    end
end)

local CowPills = {
    [mod.PICKUP.PILLCOLOR.COWCOW] = true,
    [mod.PICKUP.PILLCOLOR.STRAWBERRYCOW] = true,
    [mod.PICKUP.PILLCOLOR.CHOCOLATECOW] = true,
}

local PillWeights = {
    [mod.PICKUP.PILLCOLOR.COWCOW] = 1,
    [mod.PICKUP.PILLCOLOR.STRAWBERRYCOW] = 1,
    [mod.PICKUP.PILLCOLOR.CHOCOLATECOW] = 1,
    [mod.PICKUP.PILLCOLOR.GREENBROWN] = 1,
}

function mod:newGamePillShit(continuing)
    game = Game()
    if not continuing then
        --local itempool = game:GetItemPool()
        --for i = 1, #mod.FFPillColours do
            --Unidentify them
            --There is literally no function for this wtf
            --See FiendFolio.savedata.run.IdentifiedRunPills
        --end
        local doDebug = false

        --Choose pills for a run
        local PillChoices = {}
        local VanillaPillChoices = {
            --Vanilla pills
            1,2,3,4,5,6,7,8,9,10,11,12,13,
        }
        for i = 1, #VanillaPillChoices do
            table.insert(PillChoices, {ID = VanillaPillChoices[i], Weight = 5})
        end
        --Sub in the FF Pills using the table at the top of this file
        --Naturally ignores horse pills
        for i = 1, #mod.FFPillColours do
            local pillID = mod.FFPillColours[i]
            if pillID < 2048 then
                if Isaac.GetPersistentGameData():Unlocked(Achievement.EVERYTHING_IS_TERRIBLE) then
                    local weight = 5
                    if PillWeights[pillID] then
                        weight = PillWeights[pillID]
                    end

                    if CowPills[pillID] then --Cow pills
                        if mod.ACHIEVEMENT.SALOON:IsUnlocked() then
                            table.insert(PillChoices, {ID = pillID, Weight = weight})
                        end
                    else
                        table.insert(PillChoices, {ID = pillID, Weight = weight})
                    end
                end
            end
        end
        --This is for helping determining which pills the fake colours will replace
        local PillsAvailableToReplace = {
            1,2,3,4,5,6,7,8,9,10,11,12,13
        }
        FiendFolio.savedata.run.RunPills = {}
        FiendFolio.savedata.run.IdentifiedRunPills = {}
        local rng = RNG()
        rng:SetSeed(game:GetSeeds():GetStartSeed(),0)
        --print("seeds")
        for i = 1, 13 do
            local wop = WeightedOutcomePicker()
            for i = 1, #PillChoices do
                wop:AddOutcomeWeight(i, PillChoices[i].Weight)
            end
            local rand = wop:PickOutcome(rng)
            local choice = PillChoices[rand].ID
            table.remove(PillChoices, rand)
            for j = 1, #PillsAvailableToReplace do
                if PillsAvailableToReplace[j] == choice then
                    table.remove(PillsAvailableToReplace, j)
                    break
                end
            end
            if doDebug then
                print(choice)
            end
            table.insert(FiendFolio.savedata.run.RunPills, choice)
        end
        if doDebug then
            --Testing if this works alright
            local string = ""
            for i = 1, #PillsAvailableToReplace do
                string = string .. PillsAvailableToReplace[i] .. ", "
            end
            print(string)
        end
        FiendFolio.savedata.run.PillCopies = {}
        FiendFolio.savedata.run.PillBeingReplaced = {}
        for i = 1, #FiendFolio.savedata.run.RunPills do
            if isFFPill[FiendFolio.savedata.run.RunPills[i]] then
                local pillReplacement = rng:RandomInt(#PillsAvailableToReplace) + 1
                FiendFolio.savedata.run.PillCopies[tostring(FiendFolio.savedata.run.RunPills[i])] = PillsAvailableToReplace[pillReplacement]
                FiendFolio.savedata.run.PillBeingReplaced[tostring(PillsAvailableToReplace[pillReplacement])] = FiendFolio.savedata.run.RunPills[i]
                table.remove(PillsAvailableToReplace, pillReplacement)
            end
        end
        if doDebug then
            local string = ""
            for i = 1, #FiendFolio.savedata.run.RunPills do
                string = string .. FiendFolio.savedata.run.RunPills[i] .. ", "
            end
            print(string)
        end
        local itempool = game:GetItemPool()
        for i = 1, #mod.FFPillColours do
            if not itempool:IsPillIdentified(mod.FFPillColours[i]) then
                itempool:IdentifyPill(mod.FFPillColours[i])
            end
        end
        --Rep+ treats gold / ff pills the same woo.
        --itempool:UnidentifyPill(PillColor.PILL_GOLD)
        FiendFolio.SaveSaveData()
    end

    for _, player in ipairs(PlayerManager.GetPlayers()) do
        mod:CheckPlayerPillReplacements(player)
    end
end

--Slight hacky stuff but what the fuck ever man.
--It works for one player right now. But can be spotted
--[[mod:AddCallback(ModCallbacks.MC_PRE_RENDER, function()
    local itempool = game:GetItemPool()
    itempool:UnidentifyPill(PillColor.PILL_GOLD)
end)

mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_RENDER, function(_, player)
    local pill = player:GetPill(0)
    local itempool = game:GetItemPool()
    if isFFPill[pill] or pill == 960 then
        print("identify", pill)
        itempool:IdentifyPill(PillColor.PILL_GOLD)
    end
end)]]

--Alternate solution
--[[mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_ADD_PILL, function(_, player)
    return false
end, PillColor.PILL_GOLD)]]

--Rep+ treats gold / ff pills the same woo.
--[[mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function() -- eugh
    local itempool = game:GetItemPool()
    if itempool:IsPillIdentified(PillColor.PILL_GOLD) then
        itempool:UnidentifyPill(PillColor.PILL_GOLD)
    end
end)]]

--Reworked a little by Éole, thanks!
mod:AddPriorityCallback(ModCallbacks.MC_POST_PICKUP_INIT, CallbackPriority.EARLY, function(_, pickup)
    local pillColor = pickup.SubType
    if allowPillReplacement(pillColor) then
        local undecoratedPillColor = pillColor & PillColor.PILL_COLOR_MASK
        local pillFlags = pillColor & (~PillColor.PILL_COLOR_MASK)
        if FiendFolio.savedata.run and FiendFolio.savedata.run.PillBeingReplaced and FiendFolio.savedata.run.PillBeingReplaced[tostring(undecoratedPillColor)] then
            pickup:Morph(5,70,FiendFolio.savedata.run.PillBeingReplaced[tostring(undecoratedPillColor)] | pillFlags, true, true)
        end
    end

    --[[local found
    for i = 1, #FiendFolio.savedata.run.RunPills do
        if pickup.SubType == FiendFolio.savedata.run.RunPills[i] then
            found = true
            break
        end
    end
    if found then
        print("pill exists")
    else
        print("pill shouldn't appear")
    end]]
end, PickupVariant.PICKUP_PILL)

-- Fix the pill sprite used for the Mom's Bottle of Pills animation.
mod:AddPriorityCallback(ModCallbacks.MC_USE_ITEM, -math.huge, function(_, _, _, player)
	-- Overly cautious
	local ptr = EntityPtr(player)
	mod:AddOneTimeCallback(ModCallbacks.MC_POST_UPDATE, function()
		local player = mod:GetPointee(ptr)
		if player and player:IsHoldingItem() and player:GetHeldSprite():IsPlaying() then
			local pillColor = (player:GetPocketItem(0):GetType() == PocketItemType.ACTIVE_ITEM) and player:GetPill(1) or player:GetPill(0)
			if isFFPill[pillColor] then
				local conf = EntityConfig.GetEntity(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, pillColor)
				if conf then
					local sprite = player:GetHeldSprite()
					local anim = sprite:GetAnimation()
					local overlay = sprite:GetOverlayAnimation()
					sprite:Load(conf:GetAnm2Path(), true)
					sprite:Play(anim, true)
					sprite:PlayOverlay(overlay, true)
				end
			end
		end
	end)
end, CollectibleType.COLLECTIBLE_MOMS_BOTTLE_OF_PILLS)
