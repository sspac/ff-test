local mod = FiendFolio

local bal = {
    Chance = 25,
    CIncrement = 10,
    ShrinkChance = 35,
    ShrinkIncrement = 25,
    ShrinkMax = 90,

    HealthIncrease = 1.5,
    HealthDecrease = 0.5,
    SpriteChange = 0.15,
    ColorDur = 75,
}

local copperColor = Color(1, 0.8, 0.4, 1, 0, 0, 0)
copperColor:SetColorize(1, 0.5, 0.1, 1)

function mod:CopperChunkEnemyInit(npc)
    mod.scheduleForUpdate(function()
        local d = mod:GetEntityData(npc)
        if not d.CopperChunkInit and mod.anyPlayerHas(mod.ITEM.COLLECTIBLE.COPPER_CHUNK) then
            if not (npc:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) or npc:HasEntityFlags(EntityFlag.FLAG_NO_TARGET)) and not npc:IsBoss() and npc.Type ~= mod.FFID.Tech then
                local mult = mod.getCollectibleMultiplierAcrossAllPlayers(mod.ITEM.COLLECTIBLE.COPPER_CHUNK)
                local rng = npc:GetDropRNG()
                if rng:RandomInt(100) < bal.Chance+bal.CIncrement*mult then
                    if rng:RandomInt(100) < math.max(bal.ShrinkChance+bal.ShrinkIncrement*mult, bal.ShrinkMax) then
                        npc.HitPoints = npc.HitPoints*bal.HealthDecrease
                        --npc.SpriteScale = npc.SpriteScale * (1-bal.SpriteChange)
                        npc.Scale = npc.Scale * (1-bal.SpriteChange)
                        npc:SetColor(copperColor, bal.ColorDur, 1, true, false)
                        mod.scheduleForUpdate(function()
                            if npc and npc:Exists() then
                                npc:PlaySound(mod.Sounds.MetalStepHeavy, 0.4, 0, false, mod:RandomInt(90,110,rng)/100)
                                local rangle = rng:RandomInt(360)
                                for i = 60, 360, 60 do
                                    local vec = Vector(0,3):Rotated(i+rangle)
                                    local sparkle = Isaac.Spawn(1000, 1727, 0, npc.Position + vec:Resized(20), vec, nil):ToEffect()
                                    sparkle.SpriteOffset = Vector(0,-12)
                                    sparkle:SetColor(Color(0.35, 0.5, 0.1, 1, 0.3, 0.5, 0), 100, 1, false, false)
                                    sparkle:Update()
                                end
                            end
                        end, mod:RandomInt(3,6,rng), nil, true)
                    else
                        npc.HitPoints = npc.HitPoints*bal.HealthIncrease
                        --npc.SpriteScale = npc.SpriteScale * (1+bal.SpriteChange)
                        npc.Scale = npc.Scale * (1+bal.SpriteChange)
                        npc:SetColor(copperColor, bal.ColorDur, 1, true, false)
                        mod.scheduleForUpdate(function()
                            if npc and npc:Exists() then
                                npc:PlaySound(mod.Sounds.MetalStepHeavy, 0.4, 0, false, mod:RandomInt(90,110,rng)/100)
                                local rangle = rng:RandomInt(360)
                                for i = 60, 360, 60 do
                                    local vec = Vector(0,3):Rotated(i+rangle)
                                    local sparkle = Isaac.Spawn(1000, 1727, 0, npc.Position + vec:Resized(20), vec, nil):ToEffect()
                                    sparkle.SpriteOffset = Vector(0,-12)
                                    sparkle:SetColor(Color(1, 0.2, 0.3, 1, 0.95, 0.2, 0), 100, 1, false, false)
                                    sparkle:Update()
                                end
                            end
                        end, mod:RandomInt(3,6,rng), nil, true)
                    end
                end
                d.CopperChunkInit = true
            end
        end
    end, 2, nil, true)
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_NPC_INIT, mod.ITEM.COLLECTIBLE.COPPER_CHUNK, mod.CopperChunkEnemyInit)