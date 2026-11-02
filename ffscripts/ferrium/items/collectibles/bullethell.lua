local mod = FiendFolio
local game = Game()

local bal = {
    MaxTargets = 5,
    SpawnStagger = 65,
    StepRadius = 25,
    ShotTypes = 4,

    --fire a ring, then another ring in the gaps
    OneCount = 12,
    OneDamage = {0, 3, 1}, --flat, scaling, multiplier
    OneDelay = 12,
    OneSpeed = 16,

    --fire in a gradual circle, incrementing, does a full circle
    TwoAngle = 20,
    TwoDamage = {0, 2, 1.2},
    TwoFreq = 1,
    TwoSpeed = 12,

    --fire a big accelerating spiral, spectral
    ThreeCount = 19,
    ThreeDamage = {6, 2, 1},
    ThreeSpeed = {2, 18, 0.0005},
    ThreeAngle = 3.5,

    --tri shot that spins rapidly
    FourAngle = 88,
    FourDamage = {0, 1, 1},
    FourFreq = 3,
    FourSpeed = 14,
    FourCount = 12,
    
    FallSpeed = 0,
    FallAccel = -0.05,
}

local lastSpawned = 0
function mod:BulletHellNewRoom()
    lastSpawned = 0
end

function mod:BulletHellItemNewRoom(player, d)
    d.BulletHellItemShots = nil
end

function mod:BulletHellItemUpdate(player)
    local d = mod:GetEntityData(player)

    if player:HasCollectible(mod.ITEM.COLLECTIBLE.BULLET_HELL) then
        local num = math.min(player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.BULLET_HELL)*2, bal.MaxTargets)
        local room = game:GetRoom()
        local found = 0
        for _,targ in ipairs(Isaac.FindByType(1000, mod.FF.BulletHellTarget.Var, mod.FF.BulletHellTarget.Sub, false, false)) do
            if targ.SpawnerEntity and targ.SpawnerEntity.InitSeed == player.InitSeed then
                found = found+1
            end
        end

        if found < num and mod.IsActiveRoom() then
            if room:GetFrameCount()-lastSpawned > bal.SpawnStagger then
                lastSpawned = room:GetFrameCount()
                local spawnPos = mod:FindRandomPositionButAvoidEnt(player, 2, 80, nil, nil, {1000, mod.FF.BulletHellTarget.Var, mod.FF.BulletHellTarget.Sub}, 90)
                local target = Isaac.Spawn(1000, mod.FF.BulletHellTarget.Var, mod.FF.BulletHellTarget.Sub, spawnPos, Vector.Zero, player):ToEffect()
                target.Parent = player
            end
        else
            lastSpawned = room:GetFrameCount()
        end
    end

    if d.BulletHellItemShots then
        local level = game:GetLevel():GetAbsoluteStage()
        local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.BULLET_HELL)
        for key,entry in pairs(d.BulletHellItemShots) do
            if entry.Time == 0 then
                if entry.Type == 1 then
                    local damage = player.Damage*bal.OneDamage[3]+bal.OneDamage[2]*level+bal.OneDamage[1]
                    for i=1,bal.OneCount do
                        local vec = Vector(0, bal.OneSpeed):Rotated(360/bal.OneCount*i)
                        local tear = Isaac.Spawn(2, mod.TEAR.M90_BULLET, 0, player.Position, vec, player):ToTear()
                        tear.SpawnerEntity = player
                        tear.CollisionDamage = damage
                        tear.FallingAcceleration = bal.FallAccel
                        tear.FallingSpeed = bal.FallSpeed
                        mod:GetEntityData(tear).CustomBulletVolume = 0.25
                        tear:Update()
                    end
                    mod.scheduleForUpdate(function()
                        for i=1,bal.OneCount do
                            local ang = 360/bal.OneCount
                            local vec = Vector(0, bal.OneSpeed):Rotated(ang*i+ang/2)
                            local tear = Isaac.Spawn(2, mod.TEAR.M90_BULLET, 0, player.Position, vec, player):ToTear()
                            tear.SpawnerEntity = player
                            tear.CollisionDamage = damage
                            tear.FallingAcceleration = bal.FallAccel
                            tear.FallingSpeed = bal.FallSpeed
                            mod:GetEntityData(tear).CustomBulletVolume = 0.25
                            tear:Update()
                        end
                    end, bal.OneDelay)
                    d.BulletHellItemShots[key] = nil
                elseif entry.Type == 2 then
                    entry.Angle = rng:RandomInt(360)
                    entry.Addition = 0
                    entry.Direction = -1+2*rng:RandomInt(2)
                elseif entry.Type == 3 then
                    local damage = player.Damage*bal.ThreeDamage[3]+bal.ThreeDamage[2]*level+bal.ThreeDamage[1]
                    local dir = -1+2*rng:RandomInt(2)
                    local func = {update = function(v, tab)
                        tab.BHSpeed = math.min(bal.ThreeSpeed[2], tab.BHSpeed+tab.BHVel)
                        v.Velocity = v.Velocity:Resized(tab.BHSpeed):Rotated(bal.ThreeAngle*tab.BHDir)
                        tab.BHVel = tab.BHVel+bal.ThreeSpeed[3]
                    end, BHSpeed = bal.ThreeSpeed[1], BHVel = 0, BHDir = dir}
                    for i=1,bal.ThreeCount do
                        local vec = Vector(0, bal.ThreeSpeed[1]):Rotated(360/bal.ThreeCount*i)
                        local tear = Isaac.Spawn(2, mod.TEAR.M90_BULLET, 0, player.Position, vec, player):ToTear()
                        tear.SpawnerEntity = player
                        tear.CollisionDamage = damage
                        tear.FallingAcceleration = bal.FallAccel
                        tear.FallingSpeed = bal.FallSpeed
                        tear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
                        mod:GetEntityData(tear).CustomBulletVolume = 0.25
                        tear:Update()
                        mod:TryToAddTearBehavior(tear, mod:GetEntityData(tear), func)
                    end
                    d.BulletHellItemShots[key] = nil
                elseif entry.Type == 4 then
                    entry.Angle = rng:RandomInt(360)
                    entry.Count = 0
                    entry.Direction = -1+2*rng:RandomInt(2)
                end
            end

            if entry.Type == 2 then
                if entry.Time % bal.TwoFreq == 0 then
                    local damage = player.Damage*bal.TwoDamage[3]+bal.TwoDamage[2]*level+bal.TwoDamage[1]
                    local vec = Vector(0, bal.TwoSpeed):Rotated(entry.Angle+entry.Addition*bal.TwoAngle*entry.Direction)
                    local tear = Isaac.Spawn(2, mod.TEAR.M90_BULLET, 0, player.Position, vec, player):ToTear()
                    tear.SpawnerEntity = player
                    tear.CollisionDamage = damage
                    tear.FallingAcceleration = bal.FallAccel
                    tear.FallingSpeed = bal.FallSpeed
                    mod:GetEntityData(tear).CustomBulletVolume = 0.25
                    tear:Update()
                    entry.Addition = entry.Addition+1
                    if entry.Addition*bal.TwoAngle > 360 then
                        d.BulletHellItemShots[key] = nil
                    end
                end
            elseif entry.Type == 4 then
                if entry.Time % bal.FourFreq == 0 then
                    local damage = player.Damage*bal.FourDamage[3]+bal.FourDamage[2]*level+bal.FourDamage[1]
                    for i=1,3 do
                        local vec = Vector(0, bal.FourSpeed):Rotated(entry.Angle+entry.Count*bal.FourAngle*entry.Direction+120*i)
                        local tear = Isaac.Spawn(2, mod.TEAR.M90_BULLET, 0, player.Position, vec, player):ToTear()
                        tear.SpawnerEntity = player
                        tear.CollisionDamage = damage
                        tear.FallingAcceleration = bal.FallAccel
                        tear.FallingSpeed = bal.FallSpeed
                        mod:GetEntityData(tear).CustomBulletVolume = 0.25
                        tear:Update()
                    end
                    entry.Count = entry.Count+1
                    if entry.Count > bal.FourCount then
                        d.BulletHellItemShots[key] = nil
                    end
                end
            end

            entry.Time = entry.Time+1
        end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.COLLECTIBLE.BULLET_HELL, mod.BulletHellItemUpdate)

function mod:BulletHellEffect(e)
    local sprite = e:GetSprite()
    local d = mod:GetEntityData(e)

    if not d.init then
        d.StateFrame = 0
        d.State = "Appear"
        --mod:spritePlay(sprite, "Blink")
        e:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        --e.Color = Color(1, 0.4, 0.4, 0.6, 0, 0)
        d.init = true
    end

    if d.State == "Appear" then
        if sprite:IsFinished("Appear") then
            d.State = "Idle"
        else
            mod:spritePlay(sprite, "Appear")
        end
    elseif d.State == "Idle" then
        for i = 1, game:GetNumPlayers() do
            local p = Isaac.GetPlayer(i - 1)
            if p.Position:Distance(e.Position) < bal.StepRadius then
                mod:GetEntityData(p).BulletHellItemShots = mod:GetEntityData(p).BulletHellItemShots or {}
                local rng = p:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.BULLET_HELL)
                table.insert(mod:GetEntityData(p).BulletHellItemShots, {Time = 0, Type = rng:RandomInt(bal.ShotTypes)+1, Angle = rng:RandomInt(360)})
                d.State = "Disappear"
                break
            end
        end

        mod:spritePlay(sprite, "Blink")

        if not mod.IsActiveRoom() then
            d.State = "Disappear"
        end
    elseif d.State == "Disappear" then
        if sprite:IsFinished("Remove") then
            e:Remove()
        else
            mod:spritePlay(sprite, "Remove")
        end
    end
end