local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

-- concept by Ferrium

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, familiar)
    familiar.FireCooldown = 40
	--familiar.IsFollower = true
end, mod.ITEM.FAMILIAR.LIL_GOLEM)

-- stolen function ty eid
local function GoldenTrinketDescription(description, trinketID, mult)
    local data = EID:getDescriptionEntry("goldenTrinketData", trinketID) or EID.GoldenTrinketData[trinketID]
    local multiplier = mult
    local textChoice = 1
    local count = 0
    local lilGolemIcon = "{{Collectible" .. mod.ITEM.COLLECTIBLE.LIL_GOLEM .. "}}"

    if data then
        if type(data) == "number" then data = {t={data}} end

        --custom multipliers (either manually defined, or just changing the max multiplier
        if data.mults then
            multiplier = data.mults[2]
        elseif data.mult and data.mult < 2 then multiplier = data.mult end

        --custom additions table (manually defined)
        -- index 1 is 2x, index 2 is 3x, index 3 is 4x
        local addition = 0
        if data.additions then
            addition = data.additions[textChoice]
        end

        --replacing numeric text based on our multiplier
        if (data.t) then
            local numReplacements = 0
            --"%d*%.?%d+" will grab every number group (1, 10, 0.5), this will allow us to not replace the "1" in "10" erroneously
            description = string.gsub(description, "%d*%.?%d+", function(s)
                count = 0
                for _, v in ipairs(data.t) do
                    if (s == tostring(v) and count == 0) then
                        count = count + 1
                        numReplacements = numReplacements + 1
                        if v == 17 then
                            if multiplier == 2 then v = 16.5
                            elseif multiplier == 3 then v = (1/6)*100 end -- convert 17% to 33% or 50%
                        elseif v == 33 and (multiplier == 1.5 or multiplier == 3) then v = (1/3)*100 end -- convert 33% to 50% or 100%
                        return "{{ColorOverclock}}" .. string.format("%.4g",v * multiplier + addition) .. "{{CR}}"
                    end
                end
            end)
            count = count + numReplacements
        end
        --replacing a phrase, such as "half a heart", with a double or tripled version
        --the table should be 3 entries long (can also be 6, 9, etc. for multiple find+replaces)
        --it can be 2 entries long if there's no triple effect
        --If you need to differentiate between Golden and Mom's, use fullReplace
        if data.findReplace then
            local textTable = EID:getDescriptionEntry("goldenTrinketEffects", trinketID)
            if textTable then
                for i=1,#textTable,3 do
                    local newText = textTable[math.min(i+multiplier-1, #textTable)]
                    description, count = string.gsub(description, textTable[i], "{{ColorOverclock}}" .. newText .. "{{ColorText}}", 1)
                end
            end
        end
        --append some new text to the description
        --the append table can be 1, 2, or 3 entries long (2 entries = double and triple, 3 entries = Golden, Mom's, Both)
        if data.append then
            local textTable = EID:getDescriptionEntry("goldenTrinketEffects", trinketID)
            if textTable then
                if #textTable == 2 and textChoice == 2 then textChoice = 1 -- some items have only 2 descriptions (double and triple), so Golden and Mom's should both choose text #1
                else textChoice = math.min(textChoice, #textTable) end -- some items have only 1 description
                
                if textTable[textChoice] ~= "" then
                    description = description .. "#{{ColorOverclock}}" .. textTable[textChoice]
                    count = 1
                end
            end
        end
        --the nuclear option: replacing the entire description; 1 = Golden, 2 = Mom's Box, 3 = Both
        --only replace if the chosen language has defined it
        if data.fullReplace then
            local textTable = EID:getDescriptionEntry("goldenTrinketEffects", trinketID, true)
            if (textTable) then
                if #textTable == 2 and textChoice == 2 then textChoice = 1 -- some items have only 2 descriptions (double and triple), so Golden and Mom's should both choose text #1
                else textChoice = math.min(textChoice, #textTable) end -- some items have only 1 description
                
                description = textTable[textChoice]
                count = 1
            end
        end
        -- we didn't replace everything; maybe the language didn't have the number? append a simple "effect is doubled/tripled"
        if count == 0 and multiplier > 1 then
            local goldenDesc = EID:getDescriptionEntry("goldenTrinket") or ""
            if multiplier == 3 then goldenDesc = EID:getDescriptionEntry("tripledTrinket") or ""
            elseif multiplier == 4 then goldenDesc = EID:getDescriptionEntry("quadrupledTrinket") end
            description = description .. "#" .. "{{ColorOverclock}}"..goldenDesc
        end
    end
    return lilGolemIcon .. " {{ColorOverclock}}Lil Golem" .. "#" .. description
end

local function getEidTrinketDesc(trinketType, multiplier)
    trinketType = trinketType % TrinketType.TRINKET_GOLDEN_FLAG
    local arrayData = EID:getDescriptionData(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, trinketType)
    local description = arrayData[3]
    description = GoldenTrinketDescription(arrayData[3], trinketType, multiplier)
    return {
        Name = arrayData[2],
        Description = description,
        -- Transformation = arrayData[4],
    }
end

local function findLastBum(player, familiar)
    local lastBum
    for i,entity in ipairs(Isaac.GetRoomEntities()) do
        if entity.Type == 3 and mod.bumVariants[entity.Variant] then
            local fam = entity:ToFamiliar()
            --Means it won't follow anything after itself
            if GetPtrHash(fam) == GetPtrHash(familiar) then
                break
            end
            if GetPtrHash(fam.Player) == GetPtrHash(player) then
                lastBum = entity
            end
        end
    end
    return lastBum or player
end

local function giveInnateTrinket(player, trinketID, power)
    if trinketID > 0 then
        player:AddInnateTrinket(trinketID, 1, "FF_LILGOLEM", -1, true)
        if power > 2 then
            player:AddInnateTrinket(trinketID-TrinketType.TRINKET_GOLDEN_FLAG, power-2, "FF_LILGOLEM", -1, true)
        end
    end
end

local function removeInnateTrinket(player, trinketID, power)
    if trinketID > 0 then
        player:RemoveInnateTrinket(trinketID, 1, "FF_LILGOLEM")
        if power > 2 then
            player:RemoveInnateTrinket(trinketID-TrinketType.TRINKET_GOLDEN_FLAG, power-2, "FF_LILGOLEM")
        end
    end
end

local bumVals = {
    ["fam"] = {
        Min = 40,
        Max = 40,
        LerpFol = 0.1,
        LerpStop = 0.5,
    },
    ["player"] = {
        Min = 100,
        Max = 100,
        LerpFol = 0.5,
        LerpStop = 0.2,
    }
}

FiendFolio.AddItemPickupCallback(function(player, added)
    local room = game:GetRoom()
    local pos = room:FindFreePickupSpawnPosition(player.Position, 40, true)
    Isaac.Spawn(5, 350, FiendFolio.GetNextMiningMachineTrinket(0, player), pos, Vector.Zero, player)

end, nil, mod.ITEM.COLLECTIBLE.LIL_GOLEM)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, familiar)
	local data = mod:GetEntityData(familiar)
	local sprite = familiar:GetSprite()
    local player = familiar.Player
    local isSirenCharmed = mod:isSirenCharmed(familiar)
    local rng = familiar:GetDropRNG()

    data.trinketPower = 2
    if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then data.trinketPower = 3 end
    data.ignoreTrinket = data.ignoreTrinket or -1

    if game:GetRoom():GetFrameCount() == 0 then
        familiar.Target = nil
    end

    if not data.Chasing or familiar.Coins > 0 then
        if not familiar.Target or (familiar.Target and not familiar.Target:Exists()) then
            familiar.Target = findLastBum(player, familiar)
        end
        local targ = familiar.Target
        --Bum movement
        local targType = "fam"
        if targ.Type == 1 then
            targType = "player"
        end

        data.golemState = data.golemState or "Idle"
        if data.golemState == "Idle" then
            mod:spritePlay(sprite, "Idle")
            if familiar.Coins > 0 then
                local id = familiar.Coins - TrinketType.TRINKET_GOLDEN_FLAG
                Isaac.Spawn(5,350,id,familiar.Position,Vector.Zero,familiar)
                removeInnateTrinket(player, familiar.Coins, data.trinketPower)
                familiar.Coins = 0
            end
            data.EID_Description = nil
        elseif data.golemState == "Pickup" then
            mod:spritePlay(sprite, "Pickup")
            if sprite:IsFinished("Pickup") then
                data.golemState = "Holding"
            end
        elseif data.golemState == "Holding" then
            mod:spritePlay(sprite, "IdleHolding")
            local booms = Isaac.FindByType(1000,1)
            for _, boom in pairs(booms) do
                if boom.Position:Distance(familiar.Position) < 90 then
                    data.golemState = "Bombed"
                    if #Isaac.FindByType(5, 350) > 0 then
                        data.ignoreTrinket = familiar.Coins - TrinketType.TRINKET_GOLDEN_FLAG
                        data.ignoreTrinketTimer = nil
                    end
                    if data.ignoreTrinket == -1 and (boom:ToEffect().SpawnerType == 4 or boom:ToEffect().SpawnerType == 1) then
                        familiar.FireCooldown = 100
                    else
                        familiar.FireCooldown = 40
                    end
                    break
                end
            end

            if EID and familiar.Coins > 0 then
                if game:GetRoom():IsClear() and familiar.Position:Distance(player.Position) < 80 then
                    if data.savedDesc then
                        data.EID_Description = data.savedDesc
                        if not data.EID_Description.Name then
                            data.EID_Description.Name = Isaac.GetItemConfig():GetTrinket(familiar.Coins).Name
                        end 
                    else
                        local desc = getEidTrinketDesc(familiar.Coins, data.trinketPower)
                        if desc then
                            data.EID_Description = getEidTrinketDesc(familiar.Coins, data.trinketPower)
                            if not data.EID_Description.Name then
                                data.EID_Description.Name = Isaac.GetItemConfig():GetTrinket(familiar.Coins).Name
                            end 
                            data.savedDesc = data.EID_Description
                        else
                            data.EID_Description = nil
                        end
                    end
                else
                    data.EID_Description = nil
                end
            end
        elseif data.golemState == "Bombed" then
            mod:spritePlay(sprite, "Bombed")
            if sprite:IsFinished("Bombed") then
                data.golemState = "Idle"
            end
            if sprite:IsEventTriggered("Drop") then
                local id = familiar:ToFamiliar().Coins - TrinketType.TRINKET_GOLDEN_FLAG
                local trinket = Isaac.Spawn(5,350,id,familiar.Position,Vector.Zero,familiar):ToPickup()
                if id == TrinketType.TRINKET_PERFECTION then
                    trinket.Timeout = 30
                    trinket.Wait = 30
                end
                removeInnateTrinket(player, familiar.Coins, data.trinketPower)
                familiar.Coins = 0
            end
        end

        local playerDistance = targ.Position:Distance(familiar.Position)
        if data.FollowingParent then
            local targVel = (targ.Position - familiar.Position):Resized(3)
            familiar.Velocity = mod:Lerp(familiar.Velocity, targVel, bumVals[targType].LerpFol)
            if playerDistance < bumVals[targType].Min then
                data.FollowingParent = false
            end
        else
            familiar.Velocity = mod:Lerp(familiar.Velocity, Vector.Zero, bumVals[targType].LerpStop)
            if playerDistance > bumVals[targType].Max then
                data.FollowingParent = true
            end
        end

        familiar.FireCooldown = math.max(0, familiar.FireCooldown - 1)
        if data.ignoreTrinket then
            data.ignoreTrinketTimer = data.ignoreTrinketTimer or 200
            if data.ignoreTrinketTimer <= 0 then
                data.ignoreTrinketTimer = nil
                data.ignoreTrinket = nil
            else
                data.ignoreTrinketTimer = data.ignoreTrinketTimer - 1
            end
        end
        if data.golemState == "Idle" and familiar.FireCooldown == 0 and familiar.FrameCount % 30 == 0 then
            local trinket
            local closest = 99999
            for _, ent in pairs(Isaac.FindByType(5, 350)) do
                local dist = familiar.Position:Distance(ent.Position)
                if dist < closest then
                    if ent.SubType ~= data.ignoreTrinket then
                        -- currently ignores golden and blasphemous trinkets until i put in the effort to make them look right
                        if ent.SubType < TrinketType.TRINKET_GOLDEN_FLAG and not mod:IsPickupTrinketBlasphemous(ent) then
                            closest = dist
                            trinket = ent
                        end
                    end
                end
            end
            if trinket then
                data.Chasing = trinket
            end
       end
    elseif data.Chasing then
        if (data.Chasing and data.Chasing:Exists() and data.Chasing.SubType > 0) then
            local targPos = data.Chasing.Position + Vector(-10,-10)
            local targVel = (targPos - familiar.Position):Resized(4)
            familiar.Velocity = mod:Lerp(familiar.Velocity, targVel, 0.2)
            if targPos:Distance(familiar.Position) < 10 then
                familiar.Coins = data.Chasing.SubType + TrinketType.TRINKET_GOLDEN_FLAG

                --sprite:GetLayer(1):SetRenderFlags(AnimRenderFlags.GOLDEN)
                local spr = Isaac.GetItemConfig():GetTrinket(data.Chasing.SubType).GfxFileName
                sprite:ReplaceSpritesheet(1, spr)
                sprite:LoadGraphics()

                data.ignoreTrinket = -1
                data.savedDesc = nil
                data.golemState = "Pickup"

                sfx:Play(SoundEffect.SOUND_SHELLGAME, 1, 0, false, 1)
                sfx:Play(mod.Sounds.OverclockOn, 0.5, 0, false, 2)

                local effect = Isaac.Spawn(1000, EffectVariant.SIREN_RING, 0, familiar.Position, Vector.Zero, familiar):ToEffect()
                effect:FollowParent(familiar)
                effect.Color = Color(0,0,0,0.5,0.8,0.8,1)
                effect.SpriteScale = (effect.SpriteScale*0.3)
                effect.DepthOffset = -1000
                effect.Timeout = 40
                familiar:SetColor(Color(0,0.3,0.3,1,0.8,0.8,1), 20, 1, true, true)

                data.Chasing:Remove()
                
                giveInnateTrinket(player, familiar.Coins, data.trinketPower)
            end
        else
            data.Chasing = nil
        end
    end

    if game:GetLevel():HasAbandonedMineshaft() then
        local roomDesc = game:GetLevel():GetCurrentRoomDesc()
        if roomDesc.Data.Type == RoomType.ROOM_DEFAULT and roomDesc.Data.Subtype == 10 then
            if not data.chaseSave then
                local func = function()
                    for _, p in ipairs(PlayerManager.GetPlayers()) do
                        if p.Position.Y < game:GetRoom():GetCenterPos().Y then
                            mod:postLilGolemRemoved(p)
                        end
                    end
                end
                mod:AddOneTimeCallback(ModCallbacks.MC_PRE_ROOM_EXIT, func)
                data.chaseSave = true
            end
        else
            data.chaseSave = false
        end
    end
end, mod.ITEM.FAMILIAR.LIL_GOLEM)

function mod:postLilGolemRemoved(player)
    for _, familiar in ipairs(Isaac.FindByType(3, mod.ITEM.FAMILIAR.LIL_GOLEM)) do
        local data = mod:GetEntityData(familiar)
        if familiar:ToFamiliar().Coins > 0 then
            local id = familiar:ToFamiliar().Coins - TrinketType.TRINKET_GOLDEN_FLAG
            Isaac.Spawn(5,350,id,familiar.Position,Vector.Zero,familiar)
            familiar:ToFamiliar().Coins = 0
        end
        data.ignoreTrinket = -1
        data.savedDesc = nil
        data.chaseSave = false
        data.golemState = "Idle"
    end
    player:ClearInnateItemGroup("FF_LILGOLEM")
end
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, mod.postLilGolemRemoved, mod.ITEM.COLLECTIBLE.LIL_GOLEM)