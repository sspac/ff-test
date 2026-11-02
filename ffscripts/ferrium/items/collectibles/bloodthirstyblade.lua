local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local bBal = {
    knifeCount = 3,
    --knifeTimer = {80, 200, 30},
    knifeTimer = 160,
    backupDamage = 10,
    knifeMult = 1.2,
    knifeScaling = 1.8,
    knifeHang = 6,
    knifeHang2 = 15,
    knifeInitial = -6.6,
    knifeAccel = 1.6,
    knifeAccel2 = 0.1,
    knifeMaxSpeed = 33,
    hangSpeed = {9,12},
    SearchRadius = 40,
    DamageRadius = 10,
    turnSpeedThresh = 6,

    HemDur = 66,
    HemMult = 0.5,

    bloodTimer = 35,
    bloodSpeed = 20,
    bloodSpeed2 = 2,
    bloodSpeedIncrease = 3,
    bloodMult = 1,
    bloodScaling = 1.2,
    bloodAngle = 8,
    bloodThreshHolds = {0.8,0.5,0.15},
    bloodAccelGain = 0.02,
    shotCount = 12,
}

function mod:BloodthirstyBladeUpdate(player)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.BLOODTHIRSTY_BLADE) then
        local d = mod:GetEntityData(player)
        local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.BLOODTHIRSTY_BLADE)
        if mod.IsActiveRoom() then
            d.BloodthirstyBladeCount = (d.BloodthirstyBladeCount or 0)+1

            local fire
            --idk why the fire timing was random but commenting it out in case it was important
            --[[if d.BloodthirstyBladeCount > bBal.knifeTimer[1] and rng:RandomInt(bBal.knifeTimer[3]) == 0 then
                fire = true
            elseif d.BloodthirstyBladeCount > bBal.knifeTimer[2] then
                fire = true
            end]]
            if d.BloodthirstyBladeCount > bBal.knifeTimer then
                fire = true
            end

            if fire then
                sfx:Play(SoundEffect.SOUND_KNIFE_PULL, 0.4, 0, false, mod:RandomInt(155,165,rng)/100)
                d.BloodthirstyBladeCount = -(bBal.knifeHang+bBal.knifeHang2)
                local mult = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.BLOODTHIRSTY_BLADE)

                for i=1,bBal.knifeCount do
                    local vel = Vector(mod:RandomInt(bBal.hangSpeed[1], bBal.hangSpeed[2], rng), 0):Rotated(rng:RandomInt(360))+player.Velocity
                    local knife = Isaac.Spawn(1000, mod.FF.BloodthirstyBlade.Var, mod.FF.BloodthirstyBlade.Sub, player.Position, vel, player):ToEffect()
                    knife.Parent = player
                    mod:GetEntityData(knife).BloodthirstyBladeMult = mult
                    knife:Update()
                end
            end
        end

        --[[if d.BloodthirstyBladePierce then
            local mult = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.BLOODTHIRSTY_BLADE)-1
            for key,entry in pairs(d.BloodthirstyBladePierce) do
                if entry.Timer > 8 then
                    local go
                    if entry.Timer > bBal.bloodTimer*bBal.bloodThreshHolds[1] then
                        if entry.Timer % 2 == 0 then
                            go = true
                        end
                    elseif entry.Timer > bBal.bloodTimer*bBal.bloodThreshHolds[2] then
                        if entry.Timer % 3 == 0 then
                            go = true
                        end
                    elseif entry.Timer > bBal.bloodTimer*bBal.bloodThreshHolds[3] then
                        if entry.Timer % 6 == 0 then
                            go = true
                        end
                    else
                        if entry.Timer % 8 == 0 then
                            go = true
                        end
                    end
                    if go then
                        for i=-1,1,2 do
                            local vel = entry.Dir:Resized(i*entry.Speed):Rotated(mod:RandomInt(-bBal.bloodAngle,bBal.bloodAngle,rng))+player.Velocity
                            local shot = Isaac.Spawn(2, 1, 0, player.Position, vel, player):ToTear()
                            --local shot = player:FireTear(player.Position, vel, false, true, false, player, bBal.bloodMult+mult)
                            shot.Scale = mod:RandomInt(50,100,rng)/100
                            shot.FallingAcceleration = shot.FallingAcceleration+entry.FallingAccel
                            shot.CollisionDamage = player.Damage*bBal.bloodMult*mult
                        end
                    end
                    entry.Speed = entry.Speed*0.9
                    entry.Timer = entry.Timer-1
                    entry.FallingAccel = entry.FallingAccel+bBal.bloodAccelGain
                else
                    d.BloodthirstyBladePierce[key] = nil
                end
            end
        end]]
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.COLLECTIBLE.BLOODTHIRSTY_BLADE, mod.BloodthirstyBladeUpdate)

function mod:BloodthirstyBladeNewRoom(player, data)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.BLOODTHIRSTY_BLADE) then
        data.BloodthirstyBladeCount = 70
        data.BloodthirstyBladePierce = {}
    end
end
mod:AddCollectibleCallback("FF_NEW_ROOM_PLAYER_FERRIUM", mod.ITEM.COLLECTIBLE.BLOODTHIRSTY_BLADE, mod.BloodthirstyBladeNewRoom)

function mod:BloodthirstyBladeEffect(e)
    local sprite = e:GetSprite()
    local d = mod:GetEntityData(e)
    local rng = e:GetDropRNG()

    if not d.init then
        d.StateFrame = 0
        d.initialDir = d.initialDir or e.Velocity
        d.state = "Spinning"
        d.target = (mod.FindRandomEnemy(e.Position, nil, true) or e.Parent)
        e.Color = Color(0, 0, 0, 1)
        d.init = true
    else
        d.StateFrame = d.StateFrame+1
    end
    if e.Parent and e.Parent:Exists() then
        if not d.target or not mod:superExists(d.target) then
            d.target = (mod.FindRandomEnemy(e.Position, nil, true) or e.Parent)
        end

        if d.state == "Spinning" then
            sprite.Rotation = (d.target.Position-e.Position):GetAngleDegrees()-90

            e.Velocity = e.Velocity*0.93

            if d.StateFrame > bBal.knifeHang then
                if sprite:GetFrame() >= 7 then
                    d.state = "EndSpin"
                end
            end

            mod:spritePlay(sprite, "spin")
        elseif d.state == "EndSpin" then
            sprite.Rotation = (d.target.Position-e.Position):GetAngleDegrees()-90

            if sprite:IsFinished("halt") then
                d.state = "Wait2"
                d.StateFrame = 0
            else
                mod:spritePlay(sprite, "halt")
            end

            e.Velocity = mod:Lerp(e.Velocity, Vector.Zero, 0.3)
        elseif d.state == "Fly" then
            d.flySpeed = math.min(bBal.knifeMaxSpeed, d.flySpeed+d.flyAccel)
            d.flyAccel = d.flyAccel+bBal.knifeAccel2
            if d.flySpeed < bBal.turnSpeedThresh then
                d.flyVec = (d.target.Position-e.Position)
                sprite.Rotation = (d.target.Position-e.Position):GetAngleDegrees()-90
            end
            local vel = d.flyVec:Resized(d.flySpeed)
            e.Velocity = mod:Lerp(e.Velocity, vel, 0.3)

            if d.BloodiedBlade then
                mod:spritePlay(sprite, "bloody")
            else
                mod:spritePlay(sprite, "idle")
            end
        elseif d.state == "Wait2" then
            e.Velocity = mod:Lerp(e.Velocity, Vector.Zero, 0.3)

            sprite.Rotation = (d.target.Position-e.Position):GetAngleDegrees()-90

            if d.StateFrame > bBal.knifeHang2 then
                d.state = "Fly"
                d.flySpeed = bBal.knifeInitial
                d.flyAccel = bBal.knifeAccel
                d.flyVec = (d.target.Position-e.Position)
                local vel = d.flyVec:Resized(d.flySpeed)
                e.Velocity = mod:Lerp(e.Velocity, vel, 0.3)
                d.CanDamage = true
                d.StartedBladeFly = d.StateFrame
                d.DamagedEntsCatalog = {}
            end

            mod:spritePlay(sprite, "idle")
        end

        if d.CanDamage then
            local level = game:GetLevel():GetAbsoluteStage()
            local room = game:GetRoom()
            if not d.CanCollideWithGrid and room:IsPositionInRoom(e.Position, 0) then
                d.CanCollideWithGrid = true
            end

            for _, enemy in ipairs(Isaac.FindInRadius(e.Position, bBal.SearchRadius, EntityPartition.ENEMY)) do
                if enemy:IsActiveEnemy() and (not mod:isFriend(enemy)) and enemy:IsVulnerableEnemy() and not d.DamagedEntsCatalog[enemy.InitSeed] and
                    enemy.Position:DistanceSquared(e.Position) <= (bBal.DamageRadius + enemy.Size) ^ 2 then
                    d.DamagedEntsCatalog[enemy.InitSeed] = true
                    local baseDamage = bBal.backupDamage
                    local timeMult = 1
                    if e.Parent and e.Parent:ToPlayer() and e.Parent:Exists() then
                        local player = e.Parent:ToPlayer()
                        timeMult = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
                        baseDamage = player.Damage
                    end
                    local damage = baseDamage*bBal.knifeMult*(d.BloodthirstyBladeMult or 1)+bBal.knifeScaling*level
                    enemy:TakeDamage(damage, 0, EntityRef(e), 0)

                    if not enemy:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) then
                        mod.AddBleed(enemy, e, bBal.HemDur*timeMult, baseDamage*bBal.HemMult)
                    end

                    if not d.BloodiedBlade then
                        d.BloodiedBlade = true
                    end
                end
            end

            if d.flySpeed > bBal.turnSpeedThresh then
                for _, player in ipairs(Isaac.FindInRadius(e.Position, bBal.SearchRadius, EntityPartition.PLAYER)) do
                    if player.Position:DistanceSquared(e.Position) <= (bBal.DamageRadius + player.Size) ^ 2 then
                        --local pd = mod:GetEntityData(player)
                        --pd.BloodthirstyBladePierce = pd.BloodthirstyBladePierce or {}

                        sfx:Play(SoundEffect.SOUND_KNIFE_PULL, 1, 0, false, mod:RandomInt(90,110,rng)/100)
                        sfx:Play(SoundEffect.SOUND_MEATY_DEATHS, 0.6, 0, false, mod:RandomInt(120,140,rng)/100)

                        --table.insert(pd.BloodthirstyBladePierce, {Timer = bBal.bloodTimer, Speed = bBal.bloodSpeed, Dir = e.Velocity, FallingAccel = 0})

                        for j=0,8,3 do
                            local vel = e.Velocity:Resized(j+mod:getRoll(-1,1,rng)):Rotated(mod:getRoll(-8,8,rng))
                            local gib = Isaac.Spawn(1000, 5, 0, player.Position, vel, player):ToEffect()
                        end

                        for i=1,bBal.shotCount do
                            local speed = bBal.bloodSpeedIncrease*(bBal.shotCount-i)+bBal.bloodSpeed2
                            local vel = e.Velocity:Resized(speed):Rotated(mod:RandomInt(-bBal.bloodAngle,bBal.bloodAngle,rng))+player.Velocity
                            local shot = Isaac.Spawn(2, 1, 0, player.Position, vel, player):ToTear()
                            shot.Scale = mod:RandomInt(50,100,rng)/100
                            shot.FallingAcceleration = shot.FallingAcceleration+bBal.bloodAccelGain*i
                            shot.CollisionDamage = player:ToPlayer().Damage*bBal.bloodMult*(d.BloodthirstyBladeMult or 1)+bBal.bloodScaling*level
                            shot.Mass = 1
                        end

                        for i=-1,1,2 do
                            local baseDir = e.Velocity:Resized(-1):Rotated(30*i)
                            for j=1,6,2 do
                                if j < 2 then
                                    local vel = baseDir:Rotated(mod:RandomInt(-14,14,rng)):Resized(mod:RandomInt(17+11*j, 25+11*j, rng)/5)+player.Velocity
                                    local poof = Isaac.Spawn(1000, mod.FF.WhiteTrailEffect.Var, mod.FF.WhiteTrailEffect.Sub, player.Position, vel, e):ToEffect()
                                    poof.Color = Color(0, 0, 0, 1, mod:RandomInt(45,55,rng)/100, mod:RandomInt(1,4,rng)/100, mod:RandomInt(1,4,rng)/100)
                                    poof.Parent = player
                                    poof:SetTimeout(25-j*5+rng:RandomInt(10))
                                    local size = 0.2+mod:RandomInt(4,9,rng)/10*(6-j)/7
                                    poof.SpriteScale = Vector(size, size)
                                    mod:GetEntityData(poof).Deccel = 0.77
                                    mod:GetEntityData(poof).ShrinkDelay = 10
                                    poof.SpriteOffset = Vector(0, -10)
                                    poof:Update()
                                else
                                    local vel = baseDir:Rotated(mod:RandomInt(-14,14,rng)):Resized(mod:RandomInt(45+15*j, 48+15*j, rng)/5)+player.Velocity
                                    local poof = Isaac.Spawn(1000, mod.FF.WhiteTrailEffect.Var, mod.FF.WhiteTrailEffect.Sub, player.Position, vel, e):ToEffect()
                                    poof.Color = Color(0, 0, 0, 1, mod:RandomInt(45,55,rng)/100, mod:RandomInt(1,4,rng)/100, mod:RandomInt(1,4,rng)/100)
                                    poof.Parent = player
                                    poof:SetTimeout(25-j*5+rng:RandomInt(10))
                                    local size = 0.2+mod:RandomInt(4,9,rng)/10*(6-j)/7
                                    poof.SpriteScale = Vector(size, size)
                                    mod:GetEntityData(poof).Deccel = 0.77
                                    mod:GetEntityData(poof).ShrinkDelay = 10
                                    poof.SpriteOffset = Vector(0, -10)
                                    poof:Update()
                                end
                            end
                        end
                        e:Remove()
                    end
                end
            end

            if (d.CanCollideWithGrid and room:GetGridCollisionAtPos(e.Position) >= GridCollisionClass.COLLISION_WALL and d.StateFrame-d.StartedBladeFly > 20) or d.StateFrame > 120 then
                local burst = Isaac.Spawn(1000, EffectVariant.IMPACT, 0, e.Position, Vector.Zero, e)
                sfx:Play(SoundEffect.SOUND_POT_BREAK, 0.65, 0, false, mod:RandomInt(25,35,rng)/10)
                for i=0,2 do
                    local particle = Isaac.Spawn(1000, 35, 1, e.Position, Vector(0,rng:RandomInt(5)/3.2):Rotated(rng:RandomInt(360)), e)
                    particle:SetColor(Color(0.15,0.15,0.15,1,0,0,0), 999, 1, false, false)
                end
                e:Remove()
            end
        end
        if not d.FadedIn and e.Color.R < 1 then
            local increase = 0.03
            e.Color = Color(e.Color.R+increase, e.Color.G+increase, e.Color.B+increase, 1)
        else
            d.FadedIn = true
        end
    else
        local burst = Isaac.Spawn(1000, EffectVariant.IMPACT, 0, e.Position, Vector.Zero, e)
        sfx:Play(SoundEffect.SOUND_POT_BREAK, 0.65, 0, false, mod:RandomInt(25,35,rng)/10)
        for i=0,2 do
            local particle = Isaac.Spawn(1000, 35, 1, e.Position, Vector(0,rng:RandomInt(5)/3.2):Rotated(rng:RandomInt(360)), e)
            particle:SetColor(Color(0.15,0.15,0.15,1,0,0,0), 999, 1, false, false)
        end
        e:Remove()
    end
end

function mod:WhiteTrailEffect(e)
    local d = mod:GetEntityData(e)

    if not d.init then
        d.StateFrame = 0
        d.MaxScale = Vector(e.SpriteScale.X, e.SpriteScale.Y)
        d.MaxTime = e.Timeout
        d.init = true
    else
        d.StateFrame = d.StateFrame+1
    end

    if e.Timeout > 0 then
        if d.ShrinkDelay then
            if d.ShrinkDelay > 0 then
                d.ShrinkDelay = d.ShrinkDelay-1
                e.Timeout = d.MaxTime
            else
                d.ShrinkDelay = nil
            end
        end
        if d.Deccel then
            e.Velocity = e.Velocity*d.Deccel
        end
        if not d.DontShrink then
            local timescale = e.Timeout/d.MaxTime
            e.SpriteScale = d.MaxScale*timescale
        end
    else
        e:Remove()
    end

    if d.ExtraFunc then
        d.ExtraFunc(e)
    end
end