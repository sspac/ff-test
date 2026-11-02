local mod = FiendFolio

--[[States:
    4 - Idle/Moving
    6 - Jumping

    new ones
    8 - NpcState.STATE_ATTACK
]]

local soulfull = {
    specialDist = 80,
    maxDist = 200,
    attackCooldown = {75,140,30},
    attackDur = {60,100},
    maxRad = 75,
    ringAccel = 10,
    ringAccelMin = 2,
}

function mod:soulSpooterAI(npc)
    local sprite = npc:GetSprite()
    local d = mod:GetEntityData(npc)
    local target = npc:GetPlayerTarget()
    local rng = npc:GetDropRNG()
    
    if not d.init then
        d.stateFrame = 0
        d.init = true
    else
        d.stateFrame = d.stateFrame+1
    end

    if npc.State == NpcState.STATE_MOVE then
        if npc.Position:Distance(target.Position) < soulfull.maxDist and not mod:isScareOrConfuse(npc) then
            local GO
            if npc.Position:Distance(target.Position) < soulfull.specialDist then
                GO = true
            elseif d.stateFrame > soulfull.attackCooldown[1] and rng:RandomInt(soulfull.attackCooldown[3]) then
                GO = true
            elseif d.stateFrame > soulfull.attackCooldown[3] then
                GO = true
            end

            if GO then
                npc.State = NpcState.STATE_ATTACK
                d.attackDur = mod:RandomInt(soulfull.attackDur[1], soulfull.attackDur[2], rng)
                d.state = "Start"
                npc:PlaySound(SoundEffect.SOUND_MONSTER_GRUNT_4, 0.7, 0, false, mod:RandomInt(160,170,rng)/100)
            end
        end
    elseif npc.State == NpcState.STATE_JUMP then
        npc.FlipX = npc.Velocity.X < 0
    elseif npc.State == NpcState.STATE_ATTACK then --laser
        if d.state == "Start" then
            if sprite:IsFinished("AttackStart") then
                d.state = "Loop"
            elseif sprite:IsEventTriggered("Shoot") then
                local ring = Isaac.Spawn(7, 1, 3, npc.Position, Vector.Zero, npc):ToLaser()
                ring.Parent = npc
                if mod:isCharm(npc) then
                    ring.CollisionDamage = 16
                else
                    ring.CollisionDamage = 0.5
                end
                ring.Radius = 1
                ring.Timeout = 5
                d.laserRing = ring
                d.growing = true
                d.timeoutGrow = true
                d.ringGrowthAccel = soulfull.ringAccel
                npc:PlaySound(SoundEffect.SOUND_MAW_OF_VOID, 1, 0, false, mod:RandomInt(110,120,rng)/100)
            else
                mod:spritePlay(sprite, "AttackStart")
            end
        elseif d.state == "Loop" then
            if d.laserRing and d.laserRing:Exists() and d.laserRing.Timeout > 10 then
            else
                d.state = "End"
            end
            mod:spritePlay(sprite, "AttackLoop")
        elseif d.state == "End" then
            if sprite:IsFinished("AttackEnd") then
                d.state = nil
                npc.State = 4
                d.stateFrame = 0
            elseif sprite:IsEventTriggered("Stop") then
                if d.laserRing then
                    if d.laserRing:Exists() then
                        d.laserRing:Remove()
                    end
                    d.laserRing = nil
                end
                d.soulPulse = nil
                d.soulFrames = nil
                npc:PlaySound(SoundEffect.SOUND_SCYTHE_BREAK, 0.4, 0, false, 1.4)
            else
                mod:spritePlay(sprite, "AttackEnd")
            end
        end
        npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.3)
    end

    if npc:IsDead() then
        if d.laserRing and d.laserRing:Exists() then
            d.laserRing.Timeout = math.min(d.laserRing.Timeout, 10)
        end
    elseif d.laserRing and d.laserRing:Exists() then
        if d.growing then
            if d.laserRing.Radius < soulfull.maxRad then
                d.laserRing.Radius = math.min(d.laserRing.Radius+d.ringGrowthAccel, soulfull.maxRad)
                d.ringGrowthAccel = math.max(soulfull.ringAccelMin, d.ringGrowthAccel-1)
            else
                d.growing = nil
                d.soulPulse = true
                d.soulFrames = 0
            end
        elseif d.soulPulse then
            d.soulFrames = d.soulFrames+1
            local adjust = math.floor(math.sin(d.soulFrames/4)*3)
            d.laserRing.Radius = soulfull.maxRad+adjust
        end
        if d.timeoutGrow then
            if d.laserRing.Timeout < d.attackDur-3 then
                d.laserRing.Timeout = math.min(d.attackDur, d.laserRing.Timeout+9)
            else
                d.timeoutGrow = nil
            end
        end
    end
end