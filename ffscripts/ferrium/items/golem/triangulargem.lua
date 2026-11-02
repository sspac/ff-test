local mod = FiendFolio

local bal = {
    Dist = 75,
    Size = 20,
    RotSpeed = 3.5
}

function mod:TriangleGemDamage(npc, flags, source, d)
    if source and source.Entity and source.Entity:ToPlayer() or (source.Entity.SpawnerEntity and source.Entity.SpawnerEntity:ToPlayer()) then
        local player
        if source.Entity:ToPlayer() then
            player = source.Entity:ToPlayer()
        else
            if source.Entity:ToTear() and mod:GetEntityData(source.Entity).TriangleGemHost then
                return
            end
            player = source.Entity.SpawnerEntity:ToPlayer()
        end
        mod.scheduleForUpdate(function()
            if player and player:HasTrinket(mod.ITEM.ROCK.TRIANGULAR_GEM) and mod:superExists(npc) then
                local pd = mod:GetEntityData(player)
                pd.TriangularGemCount = (pd.TriangularGemCount or 0)+1
                if pd.TriangularGemCount >= 3 then
                    pd.TriangularGemCount = 0
                    local mult = mod.GetGolemTrinketPower(player, mod.ITEM.ROCK.TRIANGULAR_GEM)
                    local rng = player:GetTrinketRNG(mod.ITEM.ROCK.TRIANGULAR_GEM)
                    local chance = 33*mult
                    if rng:RandomInt(100) < chance then
                        if not d.TriangularGemOrbits then
                            d.TriangularGemOrbits = {}
                            local rangle = rng:RandomInt(360)
                            for i=1,3 do
								mod.IgnoreSecondaryFireEffects = true
                                local tear = player:FireTear(npc.Position+Vector(bal.Dist*(npc.Size/bal.Size), 0):Rotated(rangle+i*120), Vector.Zero, false, true, false, player, 1)
                                mod.IgnoreSecondaryFireEffects = false
								local poof = Isaac.Spawn(1000, EffectVariant.TEAR_POOF_A, 0, tear.Position, Vector.Zero, player):ToEffect()
                                poof.SpriteOffset = Vector(0, tear.Height)
                                poof.Color = Color(0.8, 0.5, 0.1, 1, 0, 0, 0, 2, 0.3, 0, 1)
                                poof.Scale = tear.Scale
                                poof:Update()
                                tear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
                                tear.CollisionDamage = tear.CollisionDamage*1.33
                                mod:GetEntityData(tear).TriangleGemHost = npc
                                local tab = {update = function(v, tab, vd, key)
                                    if mod:superExists(vd.TriangleGemHost) then
                                        v.FallingSpeed = 0
                                        v.FallingAcceleration = -0.05
                                        local hd = mod:GetEntityData(vd.TriangleGemHost)

                                        local targetpos = vd.TriangleGemHost.Position+Vector(bal.Dist*(vd.TriangleGemHost.Size/bal.Size), 0):Rotated(hd.TriangularGemOrbits[tab.Tear].Angle)
                                        v.Velocity = (targetpos-v.Position)
                                        hd.TriangularGemOrbits[tab.Tear].Angle = hd.TriangularGemOrbits[tab.Tear].Angle+bal.RotSpeed
                                    else
                                        v.FallingSpeed = -14
                                        v.FallingAcceleration = 2
                                        v.Velocity = v.Velocity*0.5
                                        if key then
                                            vd.customTearBehavior[key] = nil
                                        else
                                            vd.customTearBehavior = nil
                                        end
                                    end
                                end, Tear = i}
                                mod:TryToAddTearBehavior(tear, mod:GetEntityData(tear), tab)
                                d.TriangularGemOrbits[i] = {Angle = rangle+i*120, Tear = tear}
                            end
                        else
                            local backupAngle = rng:RandomInt(360)
                            local resolved
                            for i=1,3 do
                                local entry = d.TriangularGemOrbits[i]

                                if i == 1 then --Lazy solution go
                                    if entry.Tear and entry.Tear:Exists() then
                                        for j=2,3 do
                                            d.TriangularGemOrbits[j].Angle = entry.Angle+(j-1)*120
                                            resolved = 1
                                        end
                                    else
                                        for j=2,3 do
                                            local entry2 = d.TriangularGemOrbits[j]
                                            if entry2 and entry2.Tear and entry2.Tear:Exists() then
                                                resolved = j
                                                break
                                            end
                                        end
                                        if resolved then
                                            if resolved == 2 then
                                                entry.Angle = d.TriangularGemOrbits[2].Angle-120
                                                d.TriangularGemOrbits[3].Angle = d.TriangularGemOrbits[2].Angle+120
                                            else
                                                entry.Angle = d.TriangularGemOrbits[3].Angle-240
                                                d.TriangularGemOrbits[2].Angle = d.TriangularGemOrbits[3].Angle-120
                                            end
                                        end
                                    end
                                    if not resolved then
                                        for j=1,3 do
                                            d.TriangularGemOrbits[j].Angle = backupAngle+120*j
                                        end
                                    end
                                end

                                if entry and (not entry.Tear or not entry.Tear:Exists()) and entry.Angle then
                                    local tear = player:FireTear(npc.Position+Vector(bal.Dist*(npc.Size/bal.Size), 0):Rotated(entry.Angle), Vector.Zero, false, true, false, player, 1)
                                    local poof = Isaac.Spawn(1000, EffectVariant.TEAR_POOF_A, 0, tear.Position, Vector.Zero, player):ToEffect()
                                    poof.SpriteOffset = Vector(0, tear.Height)
                                    poof.Color = Color(0.8, 0.5, 0.1, 1, 0, 0, 0, 2, 0.3, 0, 1)
                                    poof.Scale = tear.Scale
                                    poof:Update()
                                    mod:GetEntityData(tear).TriangleGemHost = npc
                                    tear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
                                    tear.CollisionDamage = tear.CollisionDamage*1.33
                                    local tab = {update = function(v, tab, vd, key)
                                        if mod:superExists(vd.TriangleGemHost) then
                                            v.FallingSpeed = 0
                                            v.FallingAcceleration = -0.05
                                            local hd = mod:GetEntityData(vd.TriangleGemHost)
        
                                            local targetpos = vd.TriangleGemHost.Position+Vector(bal.Dist*(vd.TriangleGemHost.Size/bal.Size), 0):Rotated(hd.TriangularGemOrbits[tab.Tear].Angle)
                                            v.Velocity = (targetpos-v.Position)
                                            hd.TriangularGemOrbits[tab.Tear].Angle = hd.TriangularGemOrbits[tab.Tear].Angle+bal.RotSpeed
                                        else
                                            v.FallingSpeed = -14
                                            v.FallingAcceleration = 2
                                            v.Velocity = v.Velocity*0.5
                                            if key then
                                                vd.customTearBehavior[key] = nil
                                            else
                                                vd.customTearBehavior = nil
                                            end
                                        end
                                    end, Tear = i}
                                    mod:TryToAddTearBehavior(tear, mod:GetEntityData(tear), tab)
                                    d.TriangularGemOrbits[i].Tear = tear
                                end
                            end
                        end
                    end
                end
            end
        end, 1)
    end
end