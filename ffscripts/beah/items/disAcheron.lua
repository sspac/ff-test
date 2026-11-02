local mod = FiendFolio
local sfx = SFXManager()
local game = Game()

local time = 90
time=time*30
local function AddDisItem(player, isActuallyDis, pool, pos)
    if isActuallyDis == nil then
        isActuallyDis = true
    end
    local p_data = mod:GetEntityData(player)
    local collectible = mod:GetCollectibleWithArgs(function (conf, id)
        return conf.Type ~= ItemType.ITEM_ACTIVE and conf:HasTags(ItemConfig.TAG_SUMMONABLE) and (isActuallyDis or id ~= mod.ITEM.COLLECTIBLE.ACHERON)
    end, pool)
    p_data.ffsavedata.RunEffects.disItems = p_data.ffsavedata.RunEffects.disItems or {}
    table.insert(p_data.ffsavedata.RunEffects.disItems, {
        id = collectible,
        time = 0,
        dis = isActuallyDis,
        position = pos,
        readyToProcess = false,
    })
end

local function PickupItem(_, type, _, firstTime, _, _, player)
    if not player:HasCollectible(mod.ITEM.COLLECTIBLE.DIS) or not firstTime then
        return
    end

    local iconf = Isaac.GetItemConfig()
    local item = iconf:GetCollectible(type)

    --[[if item:HasTags(ItemConfig.TAG_QUEST) then
        return
    end]]
    AddDisItem(player)
end

local maxDisOrbitals, disOrbitSpeed, orbitDistance, groundOffset = 10, 2, 80, Vector(0, -16)
local disYellow = Color(1, 1, 0) local disRed = Color(1, 0, 0)
local disOffsetYellow = Color(1, 1, 1, 0.635, 0.5, 0.5) local disOffsetRed = Color(1, 1, 1, 0.635, 0.5)
local function acheronDisTick(_, player)
    local p_data = mod:GetEntityData(player)
    local reset = p_data.sw_resetDis --set on floor entry i believe
    if p_data.ffsavedata.RunEffects.disItems then
        p_data.ffsavedata.RunEffects.disRenderData = p_data.ffsavedata.RunEffects.disRenderData or {}
        local madeFunnySoundThisFrame = false
        local iConfig = Isaac.GetItemConfig()
        local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.DIS)

        for i = 1, #p_data.ffsavedata.RunEffects.disItems, 1 do
            local tab = p_data.ffsavedata.RunEffects.disItems[i]
            if tab ~= nil then
                if tab.readyToProcess then
                    tab.time = tab.time + 1
                else
                    local effect = tab.gainEffect
                    if tab.dis then
                        if not effect then
                            for j = 1, maxDisOrbitals, 1 do
                                if p_data.ffsavedata.RunEffects.disRenderData[j] == nil then
                                    tab.renderIdx = j

                                    effect = mod:SpawnItemPopup(tab.id, mod.ItemPopupSubtypes.DIS_FUNNY_MOMENTS, player.Position, player)
                                    --effect.SpriteScale = Vector(0.66, 0.66)
                                    effect.SpriteOffset = groundOffset
                                    local colorLerp = rng:RandomFloat()
                                    effect.Color = Color.Lerp(disOffsetYellow, disOffsetRed, colorLerp)

                                    local sigmaColor = Color.Lerp(disYellow, disRed, colorLerp)
                                    local renderTab = {
                                        gainEffect = effect,
                                        color = {
                                            R = sigmaColor.RO,
                                            G = sigmaColor.GO,
                                            B = sigmaColor.BO,
                                        },
                                        orbitOffset = 36 * (j-1),
                                        mainIdx = i
                                    }
                                    p_data.ffsavedata.RunEffects.disRenderData[j] = renderTab
                                    mod:GetEntityData(effect).sw_disTargetPos = (Vector.FromAngle(renderTab.orbitOffset + (p_data.sw_disRenderOrbit or 0)):Resized(orbitDistance) + player.Position)

                                    tab.gainEffect = effect
                                    sfx:Play(SoundEffect.SOUND_SOUL_PICKUP)
                                    goto finishedUnProcess
                                end

                            end
                            tab.readyToProcess = true
                            mod:beahAddInnate(player, tab.id, 1)
                        end
                    else
                        if (not effect and tab.position) then
                            effect = mod:SpawnItemPopup(tab.id, mod.ItemPopupSubtypes.MOVE_TO_PLAYER, tab.position, player)
                            sfx:Play(SoundEffect.SOUND_MEATY_DEATHS, 0.8, 0)
                            effect:MakeBloodPoof()
                            tab.gainEffect = effect
                            tab.position = nil
                        end
                    end
                    if tab.position == nil and (effect == nil or not effect:Exists()) then
                        tab.readyToProcess = true
                        if tab.onion and mod.OnionDiscHandlingSubtypes[tab.id] then
                            --onion disc initialization
                            --print("success on add")
                            p_data.ffsavedata.RunEffects.OnionDiscOnions = p_data.ffsavedata.RunEffects.OnionDiscOnions or {}
                            p_data.ffsavedata.RunEffects.OnionDiscOnions[tab.id] = (p_data.ffsavedata.RunEffects.OnionDiscOnions[tab.id] or 0) + 1
                            if mod.OnionDiscHandlingSubtypes[tab.id] == 1 then -- modded
                                mod:beahAddInnate(player, tab.id, 1)
                            else --vanilla
                                player:AddCostume(Isaac.GetItemConfig():GetCollectible(tab.id))
                                player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
                            end
                        else
                            --print("failure on add")
                            mod:beahAddInnate(player, tab.id, 1)
                        end
                        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, player.Position, Vector.Zero, nil)
                        game:GetHUD():ShowItemText(player, iConfig:GetCollectible(tab.id))
                        if tab.dis then
                            if tab.renderIdx then
                                sfx:Play(SoundEffect.SOUND_DEATH_CARD)
                            end
                        else
                            sfx:Play(SoundEffect.SOUND_DEATH_CARD)
                        end
                        --do on gain item vfx stuff here ig
                    end
                end
                ::finishedUnProcess::

                if (not tab.dis and tab.time > time) or (tab.dis and reset) then
                    table.remove(p_data.ffsavedata.RunEffects.disItems, i)
                    if tab.onion and mod.OnionDiscHandlingSubtypes[tab.id] then
                        --onion disc cleanup 
                        p_data.ffsavedata.RunEffects.OnionDiscOnions = p_data.ffsavedata.RunEffects.OnionDiscOnions or {}
                        p_data.ffsavedata.RunEffects.OnionDiscOnions[tab.id] = (p_data.ffsavedata.RunEffects.OnionDiscOnions[tab.id] or 0) - 1
                        if mod.OnionDiscHandlingSubtypes[tab.id] == 1 then -- modded
                            mod:beahAddInnate(player, tab.id, -1)
                        else --vanilla
                            if p_data.ffsavedata.RunEffects.OnionDiscOnions[tab.id] == 0 and not player:HasCollectible(tab.id) then
                                player:RemoveCostume(Isaac.GetItemConfig():GetCollectible(tab.id))
                            end
                            player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
                        end
                    else
                        mod:beahAddInnate(player, tab.id, -1)
                    end
                    i = i - 1

                    if tab.dis then
                        if tab.renderIdx then
                            local effect = p_data.ffsavedata.RunEffects.disRenderData[tab.renderIdx].effect
                            local explode = Isaac.Spawn(mod.FF.GanymedePoof.ID, mod.FF.GanymedePoof.Var, mod.FF.GanymedePoof.Sub, effect.Position + effect.PositionOffset, Vector.Zero, effect)
                            explode.DepthOffset = 20
                            sfx:Play(SoundEffect.SOUND_DEMON_HIT, 0.8, 0)
                            local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, effect.Position+effect.PositionOffset, Vector.Zero, effect)
                            local color = p_data.ffsavedata.RunEffects.disRenderData[tab.renderIdx].color
                            poof.Color = Color(1,1,1,1,color.R, color.G, color.B)
                            poof.SpriteScale = Vector(0.5, 0.5)
                            effect:Remove()
                            p_data.ffsavedata.RunEffects.disRenderData[tab.renderIdx] = nil
                        end
                    else
                        mod:SpawnItemPopup(tab.id, 1, player.Position, player)
                    end
                    if not madeFunnySoundThisFrame then
                        madeFunnySoundThisFrame = true
                        sfx:Play(SoundEffect.SOUND_THUMBS_DOWN, 1, 0)
                    end
                    reset = false
                else
                    p_data.ffsavedata.RunEffects.disItems[i] = tab
                end
            end
        end

        p_data.sw_disRenderOrbit = (p_data.sw_disRenderOrbit or 0) + disOrbitSpeed
        for key, renderTab in pairs(p_data.ffsavedata.RunEffects.disRenderData) do
            if not renderTab.orbitVector then
                renderTab.orbitVector = Vector.FromAngle(renderTab.orbitOffset + p_data.sw_disRenderOrbit):Resized(orbitDistance + (rng:RandomFloat()*45))
            else
                renderTab.orbitVector = renderTab.orbitVector:Rotated(disOrbitSpeed)
            end
            renderTab.renderPos = player.Position + renderTab.orbitVector

            if renderTab.gainEffect and renderTab.gainEffect:Exists() then
                local e_data = mod:GetEntityData(renderTab.gainEffect)
                e_data.sw_disTargetPos = renderTab.renderPos - groundOffset
            elseif renderTab.effect == nil or not renderTab.effect:Exists() then
                
                    
                local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, 
                    mod.FF.DisWisp.Var, 0, renderTab.renderPos+groundOffset, Vector.Zero, nil)
                effect.Color = Color(1,1,1,1,renderTab.color.R, renderTab.color.G, renderTab.color.B)
                effect:GetSprite():Play("Idle")
                effect.SpriteOffset = groundOffset
                renderTab.effect = effect

                if renderTab.gainEffect then
                    renderTab.gainEffect = nil
                    local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, effect.Position, Vector.Zero, effect)
                    poof.Color = Color(1,1,1,1,renderTab.color.R, renderTab.color.G, renderTab.color.B)
                    poof.SpriteScale = Vector(0.75, 0.75)
                end
            end

            if renderTab.effect then
                local effect = renderTab.effect
                effect.Position = renderTab.renderPos
            end
            p_data.ffsavedata.RunEffects.disRenderData[key] = renderTab
        end
    end
    p_data.sw_resetDis = nil
end

local function EnemyDies(_, enemy)
    local allP = mod:AllPlayersWithCollectible(mod.ITEM.COLLECTIBLE.ACHERON)
    for _, player in ipairs(allP) do
        local dmg = enemy.MaxHitPoints
        local p_data = mod:GetEntityData(player)

        p_data.ffsavedata.RunEffects.acheronCharge = (p_data.ffsavedata.RunEffects.acheronCharge or 0) + dmg
        local neededCharge = mod:Current45VoltCharge()*6
        local bool = false
        while p_data.ffsavedata.RunEffects.acheronCharge > neededCharge do
            p_data.ffsavedata.RunEffects.acheronCharge = p_data.ffsavedata.RunEffects.acheronCharge - neededCharge
            AddDisItem(player, false, ItemPoolType.POOL_DEVIL, enemy.Position)

            --do flashy visuals
            if not bool then
                bool = true
                local c = Color(0.5,1,1,1,0.5,0.5,0.5)
                local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 3, enemy.Position, Vector.Zero, enemy)
                poof.Color = c
                local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 4, enemy.Position, Vector.Zero, enemy)
                poof.Color = c
                --player:MakeBloodPoof(enemy.Position, )
            end
        end
    end
end

mod:AddCollectibleCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.ITEM.COLLECTIBLE.DIS, PickupItem) 
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, acheronDisTick)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, EnemyDies)

local function disDamage(_, ent, amt, flags)
    if flags & (DamageFlag.DAMAGE_FAKE | DamageFlag.DAMAGE_NO_PENALTIES) ~= 0 then
        return
    end
    mod:GetEntityData(ent).sw_resetDis = true
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, mod.ITEM.COLLECTIBLE.DIS, disDamage, EntityType.ENTITY_PLAYER)


----------------
-- ONION DISC --
----------------

mod.OnionDiscHandlingSubtypes = {
    --1 == modded item, change stat handling
    --2 == vanilla item, replicate to best ability, do not give innate copy
    -- i was not able to interfere with the tainted treasures onions, sorry. presumably it should not matter as i do not believe they use non-flat tears

    --mod.ITEM.COLLECTIBLE.ONION_DISC, ignore
    --CollectibleType.COLLECTIBLE_DEAD_ONION, ignore
    --mod.ITEM.COLLECTIBLE.THE_HAPPY_GO_LUCKY_ONION, ignore
    [mod.ITEM.COLLECTIBLE.SIDEWAYS_ONION] = 1,
    [CollectibleType.COLLECTIBLE_SAD_ONION] = 2,
}

--first return output is real number, second output is oniondisc flat tears number
function mod.GetOnionDiscNums(player, onion)
    --print(onion, "onion check")
    local p_data = mod:GetEntityData(player)
    local cnum = player:GetCollectibleNum(onion)
    if p_data.ffsavedata.RunEffects and p_data.ffsavedata.RunEffects and p_data.ffsavedata.RunEffects.OnionDiscOnions then
        local onionNum = p_data.ffsavedata.RunEffects.OnionDiscOnions[onion]
        if onionNum then
            return cnum-onionNum, onionNum
        end
    end
    return cnum, 0
end

--legacy code
--[[mod:AddCustomCBack(mod.CustomCallbacks.SWCB_EVALUATE_TEMP_WISPS, function (_, player, data)
    if data.ffsavedata.RunEffects.disItems then
        for _, value in ipairs(data.ffsavedata.RunEffects.disItems) do
            if value.readyToProcess then
                mod:AddItemWispForEval(player, value.id)
            end
        end
    end
end)]]