local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

mod:AddEntityCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, 1, 0, mod.PLAYER.FREEZERJR, function(_, player)
    if player:GetPlayerType() ~= mod.PLAYER.FREEZERJR then return end
    local data = mod:GetEntityData(player)
    local aim = mod.GetCorrectedFiringInput(player)

    local room = game:GetRoom()
    if room:GetFrameCount() < 1 then
        data.FreezerJrFullyCharged = nil
        data.FreezerJrCharge = 0
        data.FreezerJrCharging = false
        data.FreezerJrChargeEnd = 20
    end

    if aim:Length() > 0.5 then
        data.FreezerJrCharging = true
        data.FreezerJrCharge = data.FreezerJrCharge or 0
        local chargeRate = 125
        local hasBirthcake, numBirthcake = mod:playerHasBirthcake(player)
        if hasBirthcake then
            chargeRate = chargeRate / (numBirthcake + 1)
        end
        data.FreezerJrCharge = data.FreezerJrCharge + 1/chargeRate
        data.FreezerJrChargeEnd = 0
        if data.FreezerJrCharge >= 1 and not data.FreezerJrFullyCharged then
            player:SetColor(Color(1,1,1,1,0,0.15,0.75), 10, 15, true, false)
            sfx:Play(SoundEffect.SOUND_DOGMA_JACOBS_DOT, 0.5, 0, false, 0.5)
            data.FreezerJrFullyCharged = true
        end
    else
        data.FreezerJrCharging = false
        data.FreezerJrCharge = 0
        data.FreezerJrChargeEnd = data.FreezerJrChargeEnd or 20
        data.FreezerJrChargeEnd = data.FreezerJrChargeEnd + 2
        if data.FreezerJrFullyCharged then
            data.FreezerJrFullyCharged = nil

            --Remove entities
            for _,entity in ipairs(Isaac.GetRoomEntities()) do
                if entity.Type >= 4 then
                    entity:Remove()
                end
            end

            --Curse of the Gate check
            if mod:isCurseOfTheGateRoom() then
                mod:trySpawnGateKeyIfNeeded()
            end

            --Remove grids
            local newGrids = {}
            for i=0, room:GetGridSize() do
                local gridEntity = room:GetGridEntity(i)
                if gridEntity then
                    local gridpos = room:GetGridPosition(i)
                    local desc = gridEntity.Desc.Type
                    if not mod.skipGridBlaclist[desc]
                    and (not (desc == GridEntityType.GRID_PRESSURE_PLATE and gridEntity.Desc.Variant == 2))
                    then
                        if desc == GridEntityType.GRID_ROCK_ALT2 then
                            --spawn fool
                        end
                        room:RemoveGridEntity(i, 0, false)
                        table.insert(newGrids, i)
                    end
                end
            end
            for i = 1, #newGrids do
                for k = 1, 3 do
                    mod.scheduleForUpdate(function()
                        local room = game:GetRoom()
                        room:SpawnGridEntity(newGrids[i], GridEntityType.GRID_DECORATION, 0, 0, 0)
                    end, k)
                end
            end
            if StageAPI then
                for _, customGrid in ipairs(StageAPI.GetCustomGrids()) do
                    customGrid:Remove(false)
                end
            end

            --Game crash with Birthright
            local freeze = Isaac.Spawn(mod.FF.Freezer.ID, mod.FF.Freezer.Var, 0, player.Position, Vector.Zero, player)
            freeze:Update()
            local fz = freeze:GetSprite()
            fz:Play("bigfreeze")
            fz:SetFrame("bigfreeze", 127)
            mod:GetEntityData(freeze).RemoveOnFrame = 10
            if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
                sfx:Play(mod.Sounds.EpicTwinkleV,2,0,false,0.5)
                mod.scheduleForUpdate(function()
                    Isaac.ExecuteCommand("")
                end, 5, nil, true)
            else
                sfx:Play(mod.Sounds.EpicTwinkleV,0.1,0,false,mod:RandomInt(150,250)/100)
                sfx:Play(SoundEffect.SOUND_DOGMA_GODHEAD,1,0,false,mod:RandomInt(150,250)/100)
                sfx:Play(SoundEffect.SOUND_DOGMA_TV_BREAK,1,0,false,mod:RandomInt(150,250)/100)
            end
        end
    end
end)

local chargeBarSprite = Sprite()
chargeBarSprite:Load("gfx/ui/chargebars/chargebar_freezerjr.anm2", true)
chargeBarSprite.PlaybackSpeed = 0.5

mod:AddEntityCallback(ModCallbacks.MC_PRE_PLAYER_RENDER, 1, 0, mod.PLAYER.FREEZERJR, function(_, player)
    if game:GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT then return end
    if player:GetPlayerType() ~= mod.PLAYER.FREEZERJR then return end
    player:ClearCostumes()
    local data = mod:GetEntityData(player)
    local charge = (data.FreezerJrCharge or 0) * 100
    local chargeEnd = (data.FreezerJrChargeEnd or 20)
    if data.FreezerJrCharging then
        if charge < 100 then
            chargeBarSprite:SetFrame("Charging", math.floor(charge))
        else
            chargeBarSprite:Play("Charged", false)
            if not game:IsPaused() then
                chargeBarSprite:Update()
            end
        end
    else
        if chargeEnd and chargeEnd < 20 then
            chargeBarSprite:SetFrame("Disappear", math.floor(data.FreezerJrChargeEnd / 2))
        end
    end
    if charge > 0 or chargeEnd < 20 then
        chargeBarSprite:Render(Isaac.WorldToScreen(player.Position + Vector(0, -6 * player.Size)))
    end
end, 0)

mod:AddCallback("FF_PLAYER_HURT_SOUND", function()
    sfx:Play(mod.Sounds.DogmaScreamNoBaby, 0.5, 0, false, mod:RandomInt(70,100)/100)
    return true
end, mod.PLAYER.FREEZERJR)

mod:AddCallback("FF_PLAYER_DEATH_SOUND", function()
    sfx:Play(SoundEffect.SOUND_DOGMA_FEATHER_SPRAY, 0.5, 0, false, 0.5)
    return true
end, mod.PLAYER.FREEZERJR)