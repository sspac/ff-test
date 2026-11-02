local mod = FiendFolio

local devBal = {
    maxDist = 90,
    playerHop = 65,
    playerShoot = 165,
    moveCooldown = {10, 35, 12},
    shootCooldown = 0,
    jumpCooldown = -5,

    shootNum = 4,
    shootMax = 12,
    leapRadius = {150,60},
    landSpeed = 11.5,
}

function mod:devourerAI(npc)
    local target = npc:GetPlayerTarget()
    local d = mod:GetEntityData(npc)
    local sprite = npc:GetSprite()
    local rng = npc:GetDropRNG()

    if not d.init then
        d.myMoveTable = {
            {"JumpSmall", 1.5},
            {"Shoot", 1},
            {"JumpPrep", 1},
        }
        d.refreshLoop = 0
        d.state = "Idle"
        d.init = true
    else
        npc.StateFrame = npc.StateFrame+1
    end

    if d.state == "Idle" then
        local GO
        if npc.StateFrame > devBal.moveCooldown[1] and rng:RandomInt(devBal.moveCooldown[3]) == 0 then
            GO = true
        elseif npc.StateFrame > devBal.moveCooldown[2] then
            GO = true
        end
        if mod:isConfuse(npc) then
            if npc.StateFrame > devBal.moveCooldown[1] then
                d.state = "JumpSmall"
                d.targetPosition = mod:FindRandomFreePos(npc, devBal.maxDist, true)
            end
        elseif mod:isScare(npc) then
            d.state = "JumpSmall"
            d.targetPosition = npc.Position+(npc.Position-target.Position):Resized(70)
        elseif GO then
            local tab = mod:makeCopiedTable(d.myMoveTable)
            local special = -1
            if target.Position:Distance(npc.Position) < devBal.playerHop then
                special = 1
                tab = {{"JumpSmall", 3}, {"Shoot", 1}}
            elseif target.Position:Distance(npc.Position) < devBal.playerShoot then
                tab[1][2] = tab[1][2]*0.6
            else
                table.remove(tab, 2)
            end
            local result = mod:weightedRNG(tab, rng)
            d.state = result
            if result == "JumpSmall" then
                if special == 1 then
                    d.targetPosition = target.Position
                else
                    d.targetPosition = mod:FindRandomFreePos(npc, devBal.maxDist, true)
                end
                d.myMoveTable[1][2] = d.myMoveTable[1][2]*0.75
            elseif result == "Shoot" then
                d.myMoveTable[2][2] = d.myMoveTable[2][2]*0.75
            else
                npc:PlaySound(SoundEffect.SOUND_ANGRY_GURGLE, 1, 0, false, 1)
                d.myMoveTable[3][2] = d.myMoveTable[3][2]*0.75
            end
            d.refreshLoop = d.refreshLoop+1
            if d.refreshLoop > 5 then
                d.myMoveTable = {
                    {"JumpSmall", 1.5},
                    {"Shoot", 1},
                    {"JumpPrep", 1},
                }
                d.refreshLoop = 0
            end
        end
        mod:spritePlay(sprite, "Idle")
        npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.3)
        npc.FlipX = npc.Velocity.X < 0
    elseif d.state == "Shoot" then
        if not d.stared then
            npc.FlipX = (target.Position-npc.Position).X < 0
        else
            npc.FlipX = d.stared
        end

        if sprite:IsFinished("ShootDown") then
            d.state = "Idle"
            npc.StateFrame = devBal.shootCooldown
            d.stared = nil
        elseif sprite:IsEventTriggered("Shoot") then
            npc:PlaySound(SoundEffect.SOUND_HEARTOUT, 0.7, 0, false, mod:RandomInt(110,120,rng)/100)
            npc:PlaySound(SoundEffect.SOUND_MEATHEADSHOOT, 1, 0, false, 1)
            local params = ProjectileParams()
            params.FallingAccelModifier = 1
            for i=1,devBal.shootNum do
                params.FallingSpeedModifier = mod:RandomInt(-120,-70,rng)/10
                local vel = (target.Position-npc.Position)*mod:RandomInt(35,75,rng)/1000
                if vel:Length() > devBal.shootMax then
                    vel = vel:Resized(devBal.shootMax+mod:RandomInt(-12,12,rng)/10)
                end
                vel = vel:Rotated(mod:RandomInt(-10,10,rng))
                npc:FireProjectiles(npc.Position, vel, 0, params)
            end
            local poof = Isaac.Spawn(1000, EffectVariant.POOF02, 0, npc.Position, Vector.Zero, npc):ToEffect()
            poof.SpriteOffset = Vector(0,-3)*npc.SpriteScale.Y
            poof.DepthOffset = 20
            poof.SpriteScale = Vector(0.5, 0.5)
            poof.Color = Color(1, 1, 1, 0.4, 0.2, 0.2, 0.2)
            local splat = Isaac.Spawn(1000, EffectVariant.BLOOD_EXPLOSION, 100, npc.Position, Vector.Zero, npc):ToEffect()
            splat.SpriteOffset = Vector(0,-3)*npc.SpriteScale.Y
            splat.DepthOffset = 20
            splat.Color = Color(1, 1, 1, 0.4, 0.2, 0.2, 0.2)
        else
            mod:spritePlay(sprite, "ShootDown")
        end

        npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.3)
    elseif d.state == "JumpSmall" then
        if sprite:IsFinished("JumpDown") then
            d.state = "Idle"
            npc.StateFrame = 0
            d.targetPosition = nil
        elseif sprite:IsEventTriggered("Jump") then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
            d.jumping = true
        elseif sprite:IsEventTriggered("Land") then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
            d.jumping = nil
            npc:PlaySound(SoundEffect.SOUND_MEAT_IMPACTS, 1, 0, false, mod:RandomInt(85,95,rng)/100)
        else
            mod:spritePlay(sprite, "JumpDown")
        end
        if d.jumping then
            if d.targetPosition then
                local vel = (d.targetPosition-npc.Position)*0.2
                npc.Velocity = mod:Lerp(npc.Velocity, vel, 0.3)
            end
        else
            npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.3)
        end

        npc.FlipX = npc.Velocity.X < 0
    elseif d.state == "JumpPrep" then
        if sprite:IsFinished("JumpPrep") then
            d.state = "Jumping"
        elseif sprite:IsEventTriggered("Jump") then
            d.targetPosition = mod:FindRandomFreePos(npc, devBal.leapRadius[1], true, nil, nil, devBal.leapRadius[2])
            d.superJumping = true
            d.launchedEnemyInfo = {zVel = -12, accel = 0.5, landFunc = function()
                if not mod:IsGlobinSpritesheet(npc) then
                    local params = ProjectileParams()
                    for i=1,4 do
                        npc:FireProjectiles(npc.Position, Vector(0, devBal.landSpeed):Rotated(i*90), 0, params)
                    end
                end
                local poof = Isaac.Spawn(1000, EffectVariant.POOF02, 4, npc.Position, Vector.Zero, npc):ToEffect()
                poof.DepthOffset = 10
                npc:PlaySound(SoundEffect.SOUND_MEAT_IMPACTS, 1, 0, false, mod:RandomInt(85,95,rng)/100)
                d.state = "Land"
                d.superJumping = nil
            end, collision = -20, pos = true}
        else
            mod:spritePlay(sprite, "JumpPrep")
        end

        if not d.superJumping then
            npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.3)
        end
    elseif d.state == "Jumping" then
        mod:spritePlay(sprite, "Midair")
    elseif d.state == "Land" then
        if sprite:IsFinished("Land") then
            d.state = "Idle"
            npc.StateFrame = devBal.jumpCooldown
        else
            mod:spritePlay(sprite, "Land")
        end

        npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.3)
    end

    if d.superJumping then
        local vel = (d.targetPosition-npc.Position)*0.12
        npc.Velocity = mod:Lerp(npc.Velocity, vel, 0.3)
    end
end