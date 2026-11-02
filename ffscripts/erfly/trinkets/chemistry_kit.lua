local mod = FiendFolio
local game = Game()

local fireplaceBlacklist = {
    [ChampionColor.PULSE_RED] = true,
}

local function convertFireplace(npc)
    if game:GetRoom():HasWater() then return end
    if not npc:IsChampion() and npc.HitPoints > 0 then
        local chemistryData = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'chemistryKitFires', {})
        if not chemistryData[tostring(npc.InitSeed)] then
            npc:MakeChampion(npc.InitSeed, -1, true)
            --[[if fireplaceBlacklist[npc:GetChampionColorIdx()] then
                npc:GetSprite():Play("Dissapear", true)
            end]]
            mod:GetEntityData(npc).IsChemistryFire = true
            if npc.HitPoints == 5 then
                npc.HitPoints = npc.MaxHitPoints
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, npc)
    if npc.Variant ~= 4 then --White fire excluded
        if mod.anyPlayerHas(mod.ITEM.TRINKET.CHEMISTRY_KIT, true) then
            local room = game:GetRoom()
            if room:GetFrameCount() <= 0 then
                convertFireplace(npc)
            else
                mod.scheduleForUpdate(function()
                    convertFireplace(npc)
                end, 0, nil, true)
            end
        end
    end
end, 33)

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant ~= 4 and npc:IsChampion() then --White fire excluded
        if mod:GetEntityData(npc).IsChemistryFire or mod.anyPlayerHas(mod.ITEM.TRINKET.CHEMISTRY_KIT, true) then
            local s = npc:GetSprite()
            if (s:IsPlaying("Dissapear") or s:IsPlaying("Dissapear2") or s:IsPlaying("Dissapear3")) and s:GetFrame() == 1 then
                local anim, frame = s:GetAnimation(), s:GetFrame()
                npc:Kill()
                local empty = Isaac.Spawn(33, npc.Variant, npc.SubType, npc.Position, Vector.Zero, npc):ToNPC()
                empty.HitPoints = 0
                local es = empty:GetSprite()
                es:Update()
                es:PlayOverlay(anim, true)
                local chemistryData = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'chemistryKitFires', {})
                chemistryData[tostring(empty.InitSeed)] = true
            end

            if fireplaceBlacklist[npc:GetChampionColorIdx()] then
                if npc.FrameCount > 150 then
                    npc:TakeDamage(1, 0, EntityRef(nil), 0)
                    npc:GetSprite():Play("Dissapear", true)
                end
            end
        end
    end
end, 33)

function mod:chemistryKitNewRoom(player, d, savedata)
    if player:HasTrinket(mod.ITEM.TRINKET.CHEMISTRY_KIT) then
        local room = game:GetRoom()
        if room:IsFirstVisit() then
            local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.CHEMISTRY_KIT)
            local gridsToReplace = {}
            for i=0, room:GetGridSize() do
                local gridEntity = room:GetGridEntity(i)
                if gridEntity then
                    local gridpos = room:GetGridPosition(i)
                    local desc = gridEntity.Desc.Type
                    if desc == GridEntityType.GRID_ROCK then
                        if rng:RandomInt(15) < player:GetTrinketMultiplier(mod.ITEM.TRINKET.CHEMISTRY_KIT) then
                            table.insert(gridsToReplace, {gridpos, gridEntity})
                        end
                    end
                end
            end
            for i = 1, math.min(#gridsToReplace, 10) do
                local randIndex = rng:RandomInt(#gridsToReplace) + 1
                local chosenGrid = gridsToReplace[randIndex]
                chosenGrid[2]:Destroy(true)
                SFXManager():Stop(SoundEffect.SOUND_ROCK_CRUMBLE)
                local fire = Isaac.Spawn(33,0,0,chosenGrid[1],Vector.Zero,nil)
                table.remove(gridsToReplace, randIndex)
            end
        end
    end
end