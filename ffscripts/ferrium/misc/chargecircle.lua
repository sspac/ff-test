local mod = FiendFolio
local game = Game()

--Items that have a typical, green charge bar
FiendFolio.ChargeBarWeaponTypes = {
	WeaponType.WEAPON_BRIMSTONE,
	WeaponType.WEAPON_KNIFE,
	WeaponType.WEAPON_MONSTROS_LUNGS,
	WeaponType.WEAPON_TECH_X,
	WeaponType.WEAPON_BONE,
	WeaponType.WEAPON_SPIRIT_SWORD,
	WeaponType.WEAPON_FETUS,
}

--Items that give a green charge bar, but does not have a weapon type associated
FiendFolio.ChargeBarItems = {
	[CollectibleType.COLLECTIBLE_CHOCOLATE_MILK] = "charge",
	[CollectibleType.COLLECTIBLE_CURSED_EYE] = "charge",
	[CollectibleType.COLLECTIBLE_NEPTUNUS] = "always",
}

--Items that add a unique charge bar
--Vanilla have stats in case you're overflowing the visuals
--priority actually does nothing sorry I'm sick of this

--[[
    vanilla: For items included in the base game
    Priority: Does nothing? Is also capitalized??
    trinket: For trinkets.
    layeredCharges: If the item has multiple stages to its charge bar (Example: Chaotic Carving), include a number to determine how many layers there are
    maxTime: How long it takes to fully charge the bar. If this is a layered charge bar, instead include a table with charge time for each layer.
    ignoreMarked: If this is set, it will not automatically fire with Marked.
    condition: If this function returns false or nil, it will remove the charge bar from the queue entirely.
    renderCondition: If this function returns false or nil, it will not render.
    fireFunc: Runs this function when firing.
]]
FiendFolio.ExtraChargeBarItems = {
	{id = CollectibleType.COLLECTIBLE_MAW_OF_THE_VOID, vanilla = true, Priority = 998, anm2 = "gfx/chargebar_maw.anm2", maxTime = 75},
	{id = CollectibleType.COLLECTIBLE_REVELATION, vanilla = true, Priority = 997, anm2 = "gfx/chargebar_revelation.anm2", maxTime = 75},
	{id = CollectibleType.COLLECTIBLE_MONTEZUMAS_REVENGE, vanilla = true, Priority = 996, anm2 = "gfx/chargebar_poop.anm2", maxTime = 75},
	{id = FiendFolio.ITEM.COLLECTIBLE.MTN_DEW, Priority = 1, anm2 = "gfx/ui/chargebars/chargebar_mtn_dew.anm2", maxTime = 80},
    {id = FiendFolio.ITEM.COLLECTIBLE.CHAOTIC_CARVING, Priority = 1, anm2 = "gfx/ui/chargebars/chargebar_chaotic_carving.anm2", maxTime = {40, 60, 40},
        layeredCharges = 3, ignoreMarked = true,},
        --condition = function(p, d) return d.CanPlaceChaoticCarving or 1==1 end
    {id = FiendFolio.ITEM.COLLECTIBLE.EXECUTIONER, Priority = 1, anm2 = "gfx/ui/chargebars/chargebar_executioner.anm2", maxTime = 140, ignoreMarked = true,
        renderCondition = mod.ExecutionerBarRenderCondition, animFunc = mod.ExecutionerAnimFunc},
    {id = FiendFolio.ITEM.COLLECTIBLE.GKUNHOMDIMA, Priority = 1, anm2 = "gfx/ui/chargebars/chargebar_gkunhomdima.anm2", maxTime = 75},
    {id = FiendFolio.ITEM.COLLECTIBLE.ICE_IX, Priority = 1, anm2 = "gfx/ui/chargebars/chargebar_iceix.anm2", maxTime=105},
    --[[{id = FiendFolio.ITEM.COLLECTIBLE.BAD_IDEA, Priority = 1, anm2 = "gfx/ui/chargebars/chargebar_executioner.anm2", maxTime = 60*30, ignoreMarked = true,
        renderCondition = mod.BadIdeaRenderCondition, animFunc = mod.BadIdeaRenderFunc}]]
}

FiendFolio.ExtraChargeBarTrinkets = {
    {id = FiendFolio.ITEM.TRINKET.EARTH_IMPALE, Priority = 1, anm2 = "gfx/ui/chargebars/chargebar_earth_impale.anm2", maxTime = 55, trinket = true},
    {id = FiendFolio.ITEM.ROCK.ROCKETTE_DRAGOON, Priority = 1, anm2 = "gfx/ui/chargebars/chargebar_rockette_dragoon.anm2", maxTime = 65, trinket = true},
}

--[[Callbacks
FF_TRINKET_CIRCLE... --For trinkets
FF_EXTRA_CIRCLE... --For effects not explicitly tied to items/weird cases

FF_CHARGE_CIRCLE_CHARGED -- Called when the charge bar is fully charged
FF_CHARGE_CIRCLE_FIRED -- Called when the charge bar is used
FF_CHARGE_CIRCLE_RELEASED -- Called when the charge bar is released
]]

--Fakeid is just so that it can stick its information in an id slot. Make sure it doesn't already have a charge bar.
--Preferrably vanilla ids so it doesn't have an issue of modded stuff changing orders
FiendFolio.FriendChargeBarWeapons = {
    {
        id = CollectibleType.COLLECTIBLE_SPIRIT_SWORD, weapontype = WeaponType.WEAPON_SPIRIT_SWORD, fakeid = CollectibleType.COLLECTIBLE_MY_REFLECTION, Priority = 995, anm2 = "gfx/ui/chargebars/chargebar_friend_sword.anm2",
        animFunc = function (...) mod.FriendSwordBarAnimFunc(...) end, renderCondition = function(...) return mod.FriendSwordBarConditionFunc(...) end,
    },
    {
        id = CollectibleType.COLLECTIBLE_BERSERK, weapontype = WeaponType.WEAPON_BONE, fakeid = CollectibleType.COLLECTIBLE_BLOOD_OF_THE_MARTYR, Priority = 995, anm2 = "gfx/ui/chargebars/chargebar_friend_sword.anm2",
        animFunc = function (...) mod.FriendSwordBarAnimFunc(...) end, renderCondition = function(...) return mod.FriendSwordBarConditionFunc(...) end,
    },
    
    {
        id = CollectibleType.COLLECTIBLE_CHOCOLATE_MILK, weapontype = WeaponType.WEAPON_TEARS, fakeid = CollectibleType.COLLECTIBLE_1UP, Priority = 995, anm2 = "gfx/chargebar.anm2",
        animFunc = function (...) mod.FriendChocolateMilkBarAnimFunc(...) end, renderCondition = function(...) return mod.FriendChocolateMilkBarConditionFunc(...) end,
    },
    {
        id = CollectibleType.COLLECTIBLE_CURSED_EYE, weapontype = WeaponType.WEAPON_TEARS, fakeid = CollectibleType.COLLECTIBLE_CRICKETS_HEAD, Priority = 995, anm2 = "gfx/chargebar.anm2",
        animFunc = function (...) mod.FriendCursedEyeBarAnimFunc(...) end, renderCondition = function(...) return mod.FriendCursedEyeBarConditionFunc(...) end,
    },
    {
        id = CollectibleType.COLLECTIBLE_TECH_X, weapontype = WeaponType.WEAPON_TECH_X, fakeid = CollectibleType.COLLECTIBLE_INNER_EYE, Priority = 995, anm2 = "gfx/chargebar.anm2",
        animFunc = mod.FriendTechXBarAnimFunc, renderCondition = mod.FriendTechXBarRenderConditionFunc,
    },
    {
        id = CollectibleType.COLLECTIBLE_BRIMSTONE, weapontype = WeaponType.WEAPON_BRIMSTONE, fakeid = CollectibleType.COLLECTIBLE_SPOON_BENDER, Priority = 995, anm2 = "gfx/chargebar.anm2",
        animFunc = function(...) mod.FriendBrimstoneBarAnimFunc(...) end, renderCondition = function(...) return mod.FriendBrimstoneBarConditionFunc(...) end,
    },
    {
        id = CollectibleType.COLLECTIBLE_MONSTROS_LUNG, weapontype = WeaponType.WEAPON_MONSTROS_LUNGS, fakeid = CollectibleType.COLLECTIBLE_SAD_ONION, Priority = 995, anm2 = "gfx/chargebar.anm2",
        animFunc = mod.FriendMonstrosLungBarAnimFunc, renderCondition = mod.FriendMonstrosLungBarRenderConditionFunc,
    },
}

FiendFolio.sortedExtraChargeBarItems = false

--sumptorium/berserk 1st
--green charge bar next (Weapon types)
-- maw of the void > revelation > montezuma's revenge

function mod:extraChargeCircleRender(player, d)
    if mod:IsNormalRender(true) then
        d.customChargeBarData = d.customChargeBarData or {}
        d.customChargeBarSprites = d.customChargeBarSprites or {}
        d.customChargeBarTrinketSprites = d.customChargeBarTrinketSprites or {}
        d.customChargeBarExtraSprites = d.customChargeBarExtraSprites or {}

        if d.customChargeBarTable then
            for _, entry in ipairs(d.customChargeBarTable) do
                if (entry.renderCondition and entry.renderCondition(player, d, entry)) or (player:GetFireDirection() ~= -1 and not entry.renderCondition) then
                    local sprite
                    if entry.extraCharge then
                        if not d.customChargeBarExtraSprites[entry.id or -5] then
                            d.customChargeBarExtraSprites[entry.id or -5] = Sprite()
                            d.customChargeBarExtraSprites[entry.id or -5]:Load(entry.anm2, true)
                        end
                        sprite = d.customChargeBarExtraSprites[entry.id or -5]
                    elseif entry.trinket then
                        if not d.customChargeBarTrinketSprites[entry.id or -5] then
                            d.customChargeBarTrinketSprites[entry.id or -5] = Sprite()
                            d.customChargeBarTrinketSprites[entry.id or -5]:Load(entry.anm2, true)
                        end
                        sprite = d.customChargeBarTrinketSprites[entry.id or -5]
                    else
                        if not d.customChargeBarSprites[entry.id or -5] then
                            d.customChargeBarSprites[entry.id or -5] = Sprite()
                            d.customChargeBarSprites[entry.id or -5]:Load(entry.anm2, true)
                        end
                        sprite = d.customChargeBarSprites[entry.id or -5]
                    end
                    entry.deactivated = nil
                    if not entry.timer then
                        entry.timer = -5
                        entry.initialDelay = 0
                        entry.chargeLayer = 1
                    end

                    if not game:IsPaused() then
                        if entry.animFunc then
                            entry.animFunc(player, d, sprite, entry)
                        else
                            if entry.timer > 0 then
                                if entry.layeredCharges then
                                    sprite:Play("Charging" .. entry.chargeLayer)
                                    sprite:SetFrame(100-math.floor(entry.timer/entry.maxTime[entry.chargeLayer]*100))
                                    if entry.chargeLayer == 1 then
                                        entry.charged = nil
                                    end
                                    entry.dontPlayDisappear = nil
                                else
                                    sprite:Play("Charging")
                                    sprite:SetFrame(100-math.floor(entry.timer/entry.maxTime*100))
                                    entry.charged = nil
                                end
                            elseif entry.timer == 0 then
                                if entry.layeredCharges then
                                    if not entry.charged or entry.charged <= entry.chargeLayer then
                                        local typ = (entry.trinket and "Trinket") or (entry.extraCharge and "Extra") or "Default"
                                        if typ == "Trinket" then
                                            Isaac.RunCallbackWithParam("FF_TRINKET_CHARGE_CIRCLE_CHARGED", entry.id, player, entry, d, entry.charged)
                                        elseif typ == "Extra" then
                                            Isaac.RunCallbackWithParam("FF_TRINKET_CHARGE_CIRCLE_CHARGED", entry.id, player, entry, d, entry.charged)
                                        else
                                            Isaac.RunCallbackWithParam("FF_CHARGE_CIRCLE_CHARGED", entry.id, player, entry, d, entry.charged)
                                        end
                                        sprite:Play("StartCharged" .. entry.chargeLayer, true)
                                        entry.charged = (entry.charged or 1)+1
                                    elseif sprite:IsFinished("StartCharged" .. entry.chargeLayer) then
                                        entry.chargeLayer = math.min(entry.layeredCharges, entry.chargeLayer+1)
                                        if entry.chargeLayer == entry.layeredCharges and entry.charged > entry.layeredCharges then
                                            mod:spritePlay(sprite, "Charged" .. entry.chargeLayer)
                                        else
                                            entry.timer = entry.maxTime[entry.chargeLayer]
                                        end
                                    elseif sprite:IsPlaying("Charged" .. entry.chargeLayer) and entry.layeredCharges > entry.chargeLayer then
                                        entry.chargeLayer = math.min(entry.layeredCharges, entry.chargeLayer+1)
                                        entry.timer = entry.maxTime[entry.chargeLayer]
                                    end
                                else
                                    if not entry.charged then
                                        local typ = (entry.trinket and "Trinket") or (entry.extraCharge and "Extra") or "Default"
                                        if typ == "Trinket" then
                                            Isaac.RunCallbackWithParam("FF_TRINKET_CHARGE_CIRCLE_CHARGED", entry.id, player, entry, d, entry.charged)
                                        elseif typ == "Extra" then
                                            Isaac.RunCallbackWithParam("FF_TRINKET_CHARGE_CIRCLE_CHARGED", entry.id, player, entry, d, entry.charged)
                                        else
                                            Isaac.RunCallbackWithParam("FF_CHARGE_CIRCLE_CHARGED", entry.id, player, entry, d, entry.charged)
                                        end
                                        sprite:Play("StartCharged", true)
                                        entry.charged = true
                                    elseif sprite:IsFinished("StartCharged") then
                                        mod:spritePlay(sprite, "Charged")
                                    end
                                end
                            end
                        end
                    end
                elseif player:IsExtraAnimationFinished() and game:GetRoom():GetFrameCount() > 0 then
                    local sprite
                    if entry.extraCharge then
                        if not d.customChargeBarExtraSprites[entry.id or -5] then
                            d.customChargeBarExtraSprites[entry.id or -5] = Sprite()
                            d.customChargeBarExtraSprites[entry.id or -5]:Load(entry.anm2, true)
                        end
                        sprite = d.customChargeBarExtraSprites[entry.id or -5]
                    elseif entry.trinket then
                        if not d.customChargeBarTrinketSprites[entry.id or -5] then
                            d.customChargeBarTrinketSprites[entry.id or -5] = Sprite()
                            d.customChargeBarTrinketSprites[entry.id or -5]:Load(entry.anm2, true)
                        end
                        sprite = d.customChargeBarTrinketSprites[entry.id or -5]
                    else
                        if not d.customChargeBarSprites[entry.id or -5] then
                            d.customChargeBarSprites[entry.id or -5] = Sprite()
                            d.customChargeBarSprites[entry.id or -5]:Load(entry.anm2, true)
                        end
                        sprite = d.customChargeBarSprites[entry.id or -5]
                    end

                    if not game:IsPaused() then
                        if entry.layeredCharges then
                            entry.chargeLayer = entry.chargeLayer or 1
                            if sprite:IsFinished("Disappear" .. entry.chargeLayer) then
                                entry.deactivated = true
                                entry.initialDelay = 0
                                entry.chargeLayer = 1
                                entry.dontPlayDisappear = nil
                            else
                                if not entry.dontPlayDisappear then
                                    entry.dontPlayDisappear = true
                                    mod:spritePlay(sprite, "Disappear" .. entry.chargeLayer)
                                    local typ = (entry.trinket and "Trinket") or (entry.extraCharge and "Extra") or "Default"
                                    if typ == "Trinket" then
                                        Isaac.RunCallbackWithParam("FF_TRINKET_CHARGE_CIRCLE_RELEASED", entry.id, player, entry, d)
                                    elseif typ == "Extra" then
                                        Isaac.RunCallbackWithParam("FF_EXTRA_CHARGE_CIRCLE_RELEASED", entry.id, player, entry, d)
                                    else
                                        Isaac.RunCallbackWithParam("FF_CHARGE_CIRCLE_RELEASED", entry.id, player, entry, d)
                                    end
                                end
                                entry.chargeLayer = 1
                            end
                        else
                            if sprite:IsFinished("Disappear") then
                                entry.deactivated = true
                                entry.initialDelay = 0
                            else
                                if not sprite:IsPlaying("Disappear") then
                                    local typ = (entry.trinket and "Trinket") or (entry.extraCharge and "Extra") or "Default"
                                    if typ == "Trinket" then
                                        Isaac.RunCallbackWithParam("FF_TRINKET_CHARGE_CIRCLE_RELEASED", entry.id, player, entry, d)
                                    elseif typ == "Extra" then
                                        Isaac.RunCallbackWithParam("FF_EXTRA_CHARGE_CIRCLE_RELEASED", entry.id, player, entry, d)
                                    else
                                        Isaac.RunCallbackWithParam("FF_CHARGE_CIRCLE_RELEASED", entry.id, player, entry, d)
                                    end
                                end
                                mod:spritePlay(sprite, "Disappear")
                            end
                        end
                    end
                end
            end

            local offset = Vector(19 * player.SpriteScale.X, -54 * player.SpriteScale.Y) + player:GetFlyingOffset()*1.5
            local barCount = 0
            --local firstCharge

            for _, entry in ipairs(d.customChargeBarTable) do
                if not entry.initialDelay then
                    entry.initialDelay = 0
                end
                if not entry.deactivated and entry.initialDelay > 2 then
                    if (mod.ExtraChargeBar == 1 and barCount > 3 and entry.vanilla) or not entry.vanilla or mod:IsBriendTwin(player) then
                        local anim = "Charging"
                        if entry.layeredCharges then
                            anim = anim .. entry.chargeLayer
                        end
                        if entry.extraCharge then
                            if game:GetFrameCount() % 2 == 0 and d.customChargeBarExtraSprites[entry.id or -5]:GetAnimation() ~= anim then
                                d.customChargeBarExtraSprites[entry.id or -5]:Update()
                            end
                        elseif entry.trinket then
                            if game:GetFrameCount() % 2 == 0 and d.customChargeBarTrinketSprites[entry.id or -5]:GetAnimation() ~= anim then
                                d.customChargeBarTrinketSprites[entry.id or -5]:Update()
                            end
                        else
                            if game:GetFrameCount() % 2 == 0 and d.customChargeBarSprites[entry.id or -5]:GetAnimation() ~= anim then
                                d.customChargeBarSprites[entry.id or -5]:Update()
                            end
                        end
                    end
                    if barCount < 4 or mod.ExtraChargeBar == 1 or entry.isFriendChargeBar then
                        local pos = player.Position
                        if mod:IsBriendTwin(player) then
                            pos = pos + Vector(-offset.X, offset.Y)
                        else
                            pos = pos + offset
                        end
                        --[[local room = game:GetRoom()
                        if room:IsMirrorWorld() then
                            local xPos = 2*room:GetCenterPos().X-pos.X
                            pos = Vector(xPos, pos.Y)
                        end]]
                        if ((mod.ExtraChargeBar == 1 and barCount > 3 and entry.vanilla) or not entry.vanilla or mod:IsBriendTwin(player))
                        and Options.ChargeBars and not entry.REALLYSTOPRENDERING then
                            entry.RenderPosition = pos
                            if entry.extraCharge then
                                d.customChargeBarExtraSprites[entry.id or -5]:Render(Isaac.WorldToScreen(pos))
                            elseif entry.trinket then
                                d.customChargeBarTrinketSprites[entry.id or -5]:Render(Isaac.WorldToScreen(pos))
                            else
                                d.customChargeBarSprites[entry.id or -5]:Render(Isaac.WorldToScreen(pos))
                            end
                        end
                    else
                        entry.RenderPosition = nil
                    end

                    if barCount % 2 == 0 then
                        offset = offset + Vector(10.5, 16.5)
                    else
                        offset = offset + Vector(10.5, -16.5)
                    end

                    barCount = barCount+1
                elseif entry.vanilla and not (mod.ExtraChargeBar == 1 and barCount > 3) and not entry.deactivated then
                    if barCount % 2 == 0 then
                        offset = offset + Vector(10.5, 16.5)
                    else
                        offset = offset + Vector(10.5, -16.5)
                    end

                    barCount = barCount+1
                end
            end
        end
    end
end

function mod:extraChargeCircleUpdate(player, d)
    if d.MaliceMinion then
        local mainPlayer = player.Parent:ToPlayer()
        local md = mod:GetEntityData(mainPlayer)
        if mainPlayer and md.customChargeBarData and md.customchargeBarEvaluated then
            mod.scheduleForUpdate(function()
                md.customchargeBarEvaluated = nil
            end, 0)
            d.customChargeBarData = mod:makeCopiedTable(md.customChargeBarData)
            d.customChargeBarTable = mod:makeCopiedTable(md.customChargeBarTable)
        end
    end

    local playerType = player:GetPlayerType()
    local weaponBar
    local chargeBarTab = {}
    local redo
    local extraFirst
    if not d.customChargeBarFired then
        d.customChargeBarFired = {}
        d.customChargeBarTrinketFired = {}
        d.customChargeBarExtraFired = {}
    end
    d.customChargeBarData = d.customChargeBarData or {}
    d.customChargeBarSprites = d.customChargeBarSprites or {}
    d.customChargeBarTrinketSprites = d.customChargeBarTrinketSprites or {}
    d.customChargeBarExtraSprites = d.customChargeBarExtraSprites or {}
    d.customChargeBarTable = d.customChargeBarTable or {}

    if mod.sortedExtraChargeBarItems == false then
        table.sort(mod.ExtraChargeBarItems, function(e1, e2)
            return e1.id < e2.id
        end)
        table.sort(mod.ExtraChargeBarTrinkets, function(e1, e2)
            return e1.id < e2.id
        end)
        mod.sortedExtraChargeBarItems = true
    end

    if playerType == PlayerType.PLAYER_EVE_B and player:GetHearts()+player:GetSoulHearts()+player:GetBoneHearts() > 1 then
        table.insert(chargeBarTab, {priority = 1000, anm2 = "gfx/chargebar_sumptorium.anm2", vanilla = true, id = CollectibleType.COLLECTIBLE_SUMPTORIUM, alwaysFirst = true})
        extraFirst = true
        if not d.customChargeBarData[CollectibleType.COLLECTIBLE_SUMPTORIUM] then
            redo = true
            d.customChargeBarData[CollectibleType.COLLECTIBLE_SUMPTORIUM] = function(p) return p:GetPlayerType() == PlayerType.PLAYER_EVE_B and p:HasCollectible(CollectibleType.COLLECTIBLE_SUMPTORIUM) and player:GetHearts()+player:GetSoulHearts()+player:GetBoneHearts() > 1 end
        end
    elseif playerType == PlayerType.PLAYER_SAMSON_B then
        if player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_BERSERK) then
            if not d.customChargeBarData[CollectibleType.COLLECTIBLE_BERSERK] then
                redo = true
                d.customChargeBarData[CollectibleType.COLLECTIBLE_BERSERK] = function(p) return p:GetPlayerType() == PlayerType.PLAYER_SAMSON_B and p:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_BERSERK) end
            end
            table.insert(chargeBarTab, {priority = 1000, anm2 = "gfx/chargebar_berserk.anm2", vanilla = true, id = CollectibleType.COLLECTIBLE_BERSERK, alwaysFirst = true})
            extraFirst = true
        end
    end

    for _,wType in ipairs(mod.ChargeBarWeaponTypes) do
        if player:HasWeaponType(wType) then
            if wType == WeaponType.WEAPON_BONE then
                if mod:isForgottenBoneCharging(player) then
                    weaponBar = true
                    if not d.customChargeBarData[-6] then
                        redo = true
                        d.customChargeBarData[-6] = function(p) return mod:isForgottenBoneCharging(p) end
                    end
                end
            elseif player:HasCollectible(CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE) and
            (wType == WeaponType.WEAPON_KNIFE or wType == WeaponType.WEAPON_BRIMSTONE) then
                --These weapontypes have a special interaction with ludo that removes the chargebar, but it still registers as the weapon.
            elseif wType == WeaponType.WEAPON_KNIFE then
                if not d.HasFiredMomsKnife or (player.FrameCount-d.HasFiredMomsKnife[2]) < 8 then --Does not let you charge while it's flying, but has a slight delay to disappear
                    weaponBar = true
                    if not d.customChargeBarData[-6] then
                        redo = true
                        d.customChargeBarData[-6] = function(p) return mod:isForgottenBoneCharging(p) end
                    end
                end
            else
                d.customChargeBarData[-5] = function(p) return p:HasWeaponType(wType) end
                weaponBar = true
            end
        end
    end

    if player:GetPlayerType() == FiendFolio.PLAYER.FRIEND then
    else
        if not weaponBar then
            for id,cType in ipairs(mod.ChargeBarItems) do
                if player:HasCollectible(id) then
                    weaponBar = true
                    table.insert(chargeBarTab, {priority = 999, anm2="gfx/chargebar.anm2", vanilla = true, weaponBar = true,})
                    if not d.customChargeBarData[id] then
                        redo = true
                        d.customChargeBarData[id] = function(p) return p:HasCollectible(id) end
                    end
                end
            end
        else
            table.insert(chargeBarTab, {priority = 999, anm2="gfx/chargebar.anm2", vanilla = true, weaponBar = true,})
        end
    end

    if not redo then
        for id,entry in pairs(d.customChargeBarData) do
            if entry and not entry(player, d, entry) then
                d.customChargeBarData[id] = nil
            end
        end
    end

    local count = #d.customChargeBarTable

    if count == 0 and #chargeBarTab > 0 then
        d.customChargeBarTable = chargeBarTab
        mod:EvaluateExtraChargeBar(player)
    elseif count > 0 then
        local stuffChanged
        local checked = 1
        for _, entry in ipairs(d.customChargeBarTable) do
            if checked == 1 and extraFirst and not entry.alwaysFirst then
                stuffChanged = true
                break
            elseif entry.vanilla and entry.alwaysFirst and not extraFirst then
                stuffChanged = true
                break
            elseif checked == 1 and extraFirst and entry.alwaysFirst then
                break
            end
            checked = checked+1
        end
        checked = 1 --let it resettle
        local num = (extraFirst and 2) or 1
        for _, entry in ipairs(d.customChargeBarTable) do
            if extraFirst then
                checked = checked-1
            elseif weaponBar and checked == 1 and not entry.weaponBar then
                stuffChanged = true
                break
            elseif checked == 1 and entry.weaponBar and not weaponBar then
                stuffChanged = true
                break
            end
            checked = checked+1
        end
        if stuffChanged then
            mod:EvaluateExtraChargeBar(player)
        end
    end

    --base implementation for handling charge items
    if d.customChargeBarTable then
        for _, entry in ipairs(d.customChargeBarTable) do
            if (entry.renderCondition and entry.renderCondition(player, d, entry)) or (player:GetFireDirection() ~= -1 and not entry.renderCondition) then
                if not entry.timer or not entry.initialDelay then
                    entry.timer = -5
                    entry.initialDelay = 0
                    entry.chargeLayer = 1
                end
                local sprite
                if entry.extraCharge then
                    if not d.customChargeBarExtraSprites[entry.id or -5] then
                        d.customChargeBarExtraSprites[entry.id or -5] = Sprite()
                        d.customChargeBarExtraSprites[entry.id or -5]:Load(entry.anm2, true)
                    end
                    sprite = d.customChargeBarExtraSprites[entry.id or -5]
                elseif entry.trinket then
                    if not d.customChargeBarTrinketSprites[entry.id or -5] then
                        d.customChargeBarTrinketSprites[entry.id or -5] = Sprite()
                        d.customChargeBarTrinketSprites[entry.id or -5]:Load(entry.anm2, true)
                    end
                    sprite = d.customChargeBarTrinketSprites[entry.id or -5]
                else
                    if not d.customChargeBarSprites[entry.id or -5] then
                        d.customChargeBarSprites[entry.id or -5] = Sprite()
                        d.customChargeBarSprites[entry.id or -5]:Load(entry.anm2, true)
                    end
                    sprite = d.customChargeBarSprites[entry.id or -5]
                end

                if entry.timer > 0 then
                    entry.timer = entry.timer-1
                    entry.initialDelay = entry.initialDelay+1
                elseif entry.timer < 0 and entry.maxTime then
                    if entry.layeredCharges then
                        entry.timer = entry.maxTime[entry.chargeLayer]
                    else
                        entry.timer = entry.maxTime
                    end
                end

                local dir = mod.GetCorrectedFiringInput(player)
                entry.dir = Vector(dir.X, dir.Y)

                if entry.extraCharge then
                    d.customChargeBarExtraDirection = d.customChargeBarExtraDirection or {}
                    d.customChargeBarExtraDirection[entry.id or -5] = Vector(dir.X, dir.Y)
                elseif entry.trinket then
                    d.customChargeBarTrinketDirection = d.customChargeBarTrinketDirection or {}
                    d.customChargeBarTrinketDirection[entry.id or -5] = Vector(dir.X, dir.Y)
                else
                    d.customChargeBarDirection = d.customChargeBarDirection or {}
                    d.customChargeBarDirection[entry.id or -5] = Vector(dir.X, dir.Y)
                end
                if entry.timer == 0 and not (entry.layeredCharges or entry.ignoreMarked) and player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED) and player:IsExtraAnimationFinished() and game:GetRoom():GetFrameCount() > 0 then
                    local typ = (entry.trinket and "Trinket") or (entry.extraCharge and "Extra") or "Default"
                    if typ == "Trinket" then
                        Isaac.RunCallbackWithParam("FF_TRINKET_CHARGE_CIRCLE_FIRED", entry.id, player, entry, d)
                    elseif typ == "Extra" then
                        Isaac.RunCallbackWithParam("FF_EXTRA_CHARGE_CIRCLE_FIRED", entry.id, player, entry, d)
                    else
                        Isaac.RunCallbackWithParam("FF_CHARGE_CIRCLE_FIRED", entry.id, player, entry, d)
                    end
                    sprite:Play("Disappear", true)
                    entry.timer = -5
                end
            elseif player:IsExtraAnimationFinished() and game:GetRoom():GetFrameCount() > 0 then
                if entry.charged then
                    local typ = (entry.trinket and "Trinket") or (entry.extraCharge and "Extra") or "Default"
                    if typ == "Trinket" then
                        Isaac.RunCallbackWithParam("FF_TRINKET_CHARGE_CIRCLE_FIRED", entry.id, player, entry, d)
                    elseif typ == "Extra" then
                        Isaac.RunCallbackWithParam("FF_EXTRA_CHARGE_CIRCLE_FIRED", entry.id, player, entry, d)
                    else
                        Isaac.RunCallbackWithParam("FF_CHARGE_CIRCLE_FIRED", entry.id, player, entry, d)
                    end
                end
                entry.charged = nil
                entry.timer = -5
            end
        end
    end
end

function mod:isForgottenBoneCharging(player)
    local d = mod:GetEntityData(player)
    local ent = player:GetActiveWeaponEntity()
    if ent and ent:ToKnife() then
        local knife = player:GetActiveWeaponEntity():ToKnife()
        local sprite = knife:GetSprite()
        if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) or player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK) then
            --forces swinging and ignores charge bars, even with charging items
            return false
        elseif player:HasCollectible(CollectibleType.COLLECTIBLE_CHOCOLATE_MILK) or player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) or player:HasCollectible(CollectibleType.COLLECTIBLE_CURSED_EYE) then
            --forces charging from the start
            local show = false
            if player:GetFireDirection() ~= -1 then
                if d.customChargeBarForgottenChargeSwinging then
                    if sprite:GetFrame() >= 9 then
                        d.customChargeBarForgottenChargeSwinging = nil
                    end
                elseif not d.customChargeBarForgottenChargeSwingStart then
                    d.customChargeBarForgottenChargeSwingStart = true
                else
                    show = true
                end
            else
                if d.customChargeBarForgottenChargeSwinging then
                    if sprite:GetFrame() >= 9 then
                        d.customChargeBarForgottenChargeSwinging = nil
                    end
                elseif d.customChargeBarForgottenChargeSwingStart then
                    d.customChargeBarForgottenChargeSwinging = true
                    d.customChargeBarForgottenChargeSwingStart = nil
                end
            end

            return show
        else
            if player:GetFireDirection() ~= -1 then
                if d.customChargeBarForgottenThrowing and not knife:IsFlying() then
                    d.customChargeBarForgottenSwingStart = true
                    d.customChargeBarForgottenSwingAbandoned = nil
                    d.customChargeBarForgottenThrowing = nil
                    d.customChargeBarForgottenPreviousFireDelay = nil
                elseif d.customChargeBarForgottenSwingAbandoned then
                    if player.FireDelay <= 0 or player.FireDelay > (d.customChargeBarForgottenPreviousFireDelay or 9999) then
                        d.customChargeBarForgottenSwingStart = true
                        d.customChargeBarForgottenSwingAbandoned = nil
                        d.customChargeBarForgottenThrowing = nil
                        d.customChargeBarForgottenPreviousFireDelay = nil
                    end
                    d.customChargeBarForgottenPreviousFireDelay = player.FireDelay
                elseif not d.customChargeBarForgottenSwingStart then
                    d.customChargeBarForgottenSwingStart = true
                    d.customChargeBarForgottenSwingAbandoned = nil
                    d.customChargeBarForgottenPreviousFireDelay = nil
                elseif sprite:GetFrame() >= 9 then
                    d.customChargeBarForgottenCharge = true
                    return true
                end
            else
                if d.customChargeBarForgottenThrowing and not knife:IsFlying() then
                    d.customChargeBarForgottenSwingStart = nil
                    d.customChargeBarForgottenThrowing = nil
                    d.customChargeBarForgottenSwingAbandoned = nil
                elseif d.customChargeBarForgottenCharge then
                    d.customChargeBarForgottenThrowing = true
                    d.customChargeBarForgottenCharge = nil
                elseif d.customChargeBarForgottenSwingAbandoned then
                    if player.FireDelay <= 0 then
                        d.customChargeBarForgottenSwingStart = nil
                        d.customChargeBarForgottenThrowing = nil
                        d.customChargeBarForgottenSwingAbandoned = nil
                        d.customChargeBarForgottenPreviousFireDelay = nil
                    end
                elseif d.customChargeBarForgottenSwingStart then
                    d.customChargeBarForgottenSwingAbandoned = true
                    d.customChargeBarForgottenPreviousFireDelay = nil
                end
            end
        end
    end
end

function mod:EvaluateExtraChargeBar(player)
    local playerType = player:GetPlayerType()
    local effects = player:GetEffects()
    local weaponBar
    local chargeBarTab = {}
    local redo
    local d = mod:GetEntityData(player)
    d.customchargeBarEvaluated = true
    d.customChargeBarData = d.customChargeBarData or {}
    d.customChargeBarSprites = d.customChargeBarSprites or {}
    d.customChargeBarTrinketSprites = d.customChargeBarTrinketSprites or {}
    d.customChargeBarExtraSprites = d.customChargeBarExtraSprites or {}
    d.customChargeBarTable = d.customChargeBarTable or {}
    if playerType == PlayerType.PLAYER_EVE_B and player:GetHearts()+player:GetSoulHearts()+player:GetBoneHearts() > 1 then
        table.insert(chargeBarTab, {priority = 1000, anm2 = "gfx/chargebar_sumptorium.anm2", vanilla = true, id = CollectibleType.COLLECTIBLE_SUMPTORIUM, alwaysFirst = true})
        if not d.customChargeBarData[CollectibleType.COLLECTIBLE_SUMPTORIUM] then
            redo = true
            d.customChargeBarData[CollectibleType.COLLECTIBLE_SUMPTORIUM] = function(p) return p:GetPlayerType() == PlayerType.PLAYER_EVE_B and p:HasCollectible(CollectibleType.COLLECTIBLE_SUMPTORIUM) and player:GetHearts()+player:GetSoulHearts()+player:GetBoneHearts() > 1 end
        end
    elseif playerType == PlayerType.PLAYER_SAMSON_B then
        if player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_BERSERK) then
            if not d.customChargeBarData[CollectibleType.COLLECTIBLE_BERSERK] then
                redo = true
                d.customChargeBarData[CollectibleType.COLLECTIBLE_BERSERK] = function(p) return p:GetPlayerType() == PlayerType.PLAYER_SAMSON_B and p:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_BERSERK) end
            end
            table.insert(chargeBarTab, {priority = 1000, anm2 = "gfx/chargebar_berserk.anm2", vanilla = true, id = CollectibleType.COLLECTIBLE_BERSERK, alwaysFirst = true})
        end
    end

    for _,wType in ipairs(mod.ChargeBarWeaponTypes) do
        if player:HasWeaponType(wType) then
            if wType == WeaponType.WEAPON_BONE then
                if mod:isForgottenBoneCharging(player) then
                    weaponBar = true
                    if not d.customChargeBarData[-6] then
                        redo = true
                        d.customChargeBarData[-6] = function(p) return mod:isForgottenBoneCharging(p) end
                    end
                end
            elseif player:HasCollectible(CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE) and
            (wType == WeaponType.WEAPON_KNIFE or wType == WeaponType.WEAPON_BRIMSTONE) then
                --These weapontypes have a special interaction with ludo that removes the chargebar, but it still registers as the weapon.
            elseif wType == WeaponType.WEAPON_KNIFE then
                if not d.HasFiredMomsKnife or (player.FrameCount-d.HasFiredMomsKnife[2]) < 8 then --Does not let you charge while it's flying, but has a slight delay to disappear
                    weaponBar = true
                    if not d.customChargeBarData[-6] then
                        redo = true
                        d.customChargeBarData[-6] = function(p) return mod:isForgottenBoneCharging(p) end
                    end
                end
            else
                d.customChargeBarData[-5] = function(p) return p:HasWeaponType(wType) end
                weaponBar = true
            end
        end
    end

    if not mod:IsAnyFriend(player) then
        if not weaponBar then
            for id,cType in ipairs(mod.ChargeBarItems) do
                if player:HasCollectible(id) or effects:HasCollectibleEffect(id) then
                    weaponBar = true
                    table.insert(chargeBarTab, {priority = 999, anm2="gfx/chargebar.anm2", vanilla = true, weaponBar = true})
                    if not d.customChargeBarData[id] then
                        redo = true
                        d.customChargeBarData[id] = function(p) return p:HasCollectible(id) end
                    end
                end
            end
        else
            table.insert(chargeBarTab, {priority = 999, anm2="gfx/chargebar.anm2", vanilla = true, weaponBar = true})
        end
    end

    for id,entry in ipairs(mod.ExtraChargeBarItems) do
        if player:HasCollectible(entry.id) or effects:HasCollectibleEffect(entry.id) then
            local tempEntry = mod:makeCopiedTable(entry)
            table.insert(chargeBarTab, tempEntry)
            if not d.customChargeBarData[tempEntry.id] then
                redo = true
                local func = function(p, da) return p:HasCollectible(tempEntry.id) or p:GetEffects():HasCollectibleEffect(tempEntry.id) end
                if tempEntry.condition then
                    func = function(p, da) return (p:HasCollectible(tempEntry.id) or p:GetEffects():HasCollectibleEffect(tempEntry.id)) and tempEntry.condition(p, da) end
                end
                d.customChargeBarData[tempEntry.id] = func
            end
        end
    end
    for id,entry in ipairs(mod.ExtraChargeBarTrinkets) do
        if player:HasTrinket(entry.id) or effects:HasTrinketEffect(entry.id) then
            local tempEntry = mod:makeCopiedTable(entry)
            table.insert(chargeBarTab, tempEntry)
            if not d.customChargeBarData[tempEntry.id] then
                redo = true
                local func = function(p, da) return p:HasTrinket(tempEntry.id) or p:GetEffects():HasTrinketEffect(tempEntry.id) end
                if tempEntry.condition then
                    func = function(p, da) return (p:HasTrinket(tempEntry.id) or p:GetEffects():HasTrinketEffect(tempEntry.id)) and tempEntry.condition(p, da) end
                end
                d.customChargeBarData[tempEntry.id] = func
            end
        end
    end

    if d.FriendHeldGuns then
        for _, gun in pairs(d.FriendHeldGuns) do
            for id,entry in ipairs(mod.FriendChargeBarWeapons) do
                if mod:GetFriendWeaponType(player, gun.Gun) == entry.weapontype or not mod:IsAnyFriend(player) then
                    -- make sure we didn't already add this chargebar
                    for _, barEntry in ipairs(chargeBarTab) do
                        if entry.id == barEntry.id then
                            goto continue
                        end
                    end

                    local tempEntry = mod:makeCopiedTable(entry)
                    tempEntry.isFriendChargeBar = true
                    table.insert(chargeBarTab, tempEntry)
                    if not d.customChargeBarData[tempEntry.fakeid] then
                        redo = true
                        local func = function(p, da) return mod:GetFriendWeaponType(p, gun.Gun) == tempEntry.weapontype end
                        if tempEntry.condition then
                            func = function(p, da) return mod:GetFriendWeaponType(p, gun.Gun) == tempEntry.weapontype and tempEntry.condition(p, da) end
                        end
                        d.customChargeBarData[tempEntry.fakeid] = func
                    end

                    ::continue::
                end
            end
        end
    end

    d.CustomChargeBarExtra = d.CustomChargeBarExtra or {}
    for id,entry in pairs(d.CustomChargeBarExtra) do
        entry.extraCharge = true
        table.insert(chargeBarTab, entry)
    end

    if not redo then
        for id,entry in pairs(d.customChargeBarData) do
            if entry and not entry(player, d, entry) then
                d.customChargeBarData[id] = nil
            end
        end
    end

    local count = #d.customChargeBarTable

    --[[if #chargeBarTab > 0 and (count == 0 or redo) then
        for key,entry in pairs(chargeBarTab) do
            if not entry.vanilla then
                chargeBarTab[key] = nil
            end
        end
        friendCheck = false
        for id,entry in ipairs(mod.ExtraChargeBarItems) do
            if not entry.vanilla and not friendCheck and mod:IsAnyFriend(player) then
                for id2,entry2 in ipairs(mod.FriendChargeBarWeapons) do
                    if player:HasCollectible(entry2.id) and not friendCheck then
                        friendCheck = true
                        local tempEntry = mod:makeCopiedTable(entry2)
                        table.insert(chargeBarTab, tempEntry)
                        if not d.customChargeBarData[tempEntry.fakeid] then
                            redo = true
                            local func = function(p, da) return p:HasCollectible(tempEntry.id) end
                            if tempEntry.condition then
                                func = function(p, da) return p:HasCollectible(tempEntry.id) and tempEntry.condition(p, da) end
                            end
                            d.customChargeBarData[tempEntry.fakeid] = func
                        end
                    end
                end
            end
            if player:HasCollectible(entry.id) then
                local tempEntry = mod:makeCopiedTable(entry)
                table.insert(chargeBarTab, tempEntry)
                if not d.customChargeBarData[tempEntry.id] then
                    redo = true
                    local func = function(p, da) return p:HasCollectible(tempEntry.id) end
                    if tempEntry.condition then
                        func = function(p, da) return p:HasCollectible(tempEntry.id) and tempEntry.condition(p, da) end
                    end
                    d.customChargeBarData[tempEntry.id] = func
                end
            end
        end
        for id,entry in ipairs(mod.ExtraChargeBarTrinkets) do
            if player:HasTrinket(entry.id) then
                local tempEntry = mod:makeCopiedTable(entry)
                table.insert(chargeBarTab, tempEntry)
                if not d.customChargeBarData[tempEntry.id] then
                    redo = true
                    local func = function(p, da) return p:HasTrinket(tempEntry.id) end
                    if tempEntry.condition then
                        func = function(p, da) return p:HasTrinket(entry.id) and tempEntry.condition(p, da) end
                    end
                    d.customChargeBarData[tempEntry.id] = func
                end
            end
        end
        for id,entry in pairs(d.CustomChargeBarExtra) do
            entry.extraCharge = true
            table.insert(chargeBarTab, entry)
        end
        --have to redo this because right now it's in order of it being added...
    end]]

    if count == 0 then
        d.customChargeBarTable = chargeBarTab
    else
        local ids = {}
        for _, entry in ipairs(d.customChargeBarTable) do
            table.insert(ids, {id = entry.id, trinket = entry.trinket, entry = entry})
        end
        local correctedChargeTab = {}
        for _, entry in ipairs(chargeBarTab) do
            local correct
            for _,things in ipairs(ids) do
                if things.id == entry.id and things.trinket == entry.trinket then
                    things.exists = true
                    table.insert(correctedChargeTab, things.entry)
                    correct = true
                    break
                end
            end
            if not correct then
                table.insert(correctedChargeTab, entry)
            end
        end
        d.customChargeBarTable = correctedChargeTab
    end
end

mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, mod.EvaluateExtraChargeBar)
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, mod.EvaluateExtraChargeBar)
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_ADDED, mod.EvaluateExtraChargeBar)
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, mod.EvaluateExtraChargeBar)
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_ADD_EFFECT, mod.EvaluateExtraChargeBar)
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_TRIGGER_EFFECT_REMOVED, mod.EvaluateExtraChargeBar)

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
    for i=0, game:GetNumPlayers()-1 do
        local player = game:GetPlayer(i)
        if player and player:Exists() then
            mod:EvaluateExtraChargeBar(player)
        end
    end
end)

mod:AddCallback("FF_CURSE_MIST_ADDED", mod.EvaluateExtraChargeBar)
mod:AddCallback("FF_CURSE_MIST_CLEARED", mod.EvaluateExtraChargeBar)