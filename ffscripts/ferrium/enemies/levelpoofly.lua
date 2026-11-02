local mod = FiendFolio
local game = Game()

function mod:levelPooFlyAI(npc)
    local d = mod:GetEntityData(npc)
    local target = npc:GetPlayerTarget()
    local targetpos = mod:randomConfuse(npc, target.Position)
    local rng = npc:GetDropRNG()
    local sprite = npc:GetSprite()
    mod:beelzebubCheck(npc)

    if not d.init then
        npc.SplatColor = mod.ColorPoop
        d.closestPoop = mod:FindClosestPoop(npc.Position)
        mod:AddSoundmakerFly(npc)
        d.state = "idle"
        d.distToPoop = 9999
        d.init = true
    else
        npc.StateFrame = npc.StateFrame
    end

    local poop
    if mod:isScare(npc) then
        npc.Velocity = mod:Lerp(npc.Velocity, (npc.Position-targetpos):Resized(7.7), 0.1)
    elseif d.closestPoop then
        if d.closestPoop.Desc.Type == GridEntityType.GRID_POOP and d.closestPoop.State < 1000 then
            d.distToPoop = d.closestPoop.Position:Distance(npc.Position)
            targetpos = mod:randomConfuse(npc, d.closestPoop.Position)
            poop = true
        else
            if d.state == "idle" and d.distToPoop < 100 and not mod:isScareOrConfuse(npc) then
                d.state = "shoot"
            end
            if mod:FindClosestPoop(npc.Position) then
                d.closestPoop = mod:FindClosestPoop(npc.Position)
            else
                d.closestPoop = nil
            end
        end
    else
        if mod:FindClosestPoop(npc.Position) then
            d.closestPoop = mod:FindClosestPoop(npc.Position)
        end
    end

    local speedMult = 1.0
    if d.state == "idle" then
        mod:spritePlay(sprite, "Idle")
    else
        if sprite:IsFinished("Shoot") then
            d.state = "idle"
        elseif sprite:IsEventTriggered("Shoot") then
            local params = ProjectileParams()
            params.Variant = ProjectileVariant.PROJECTILE_PUKE
            params.BulletFlags = ProjectileFlags.NO_WALL_COLLIDE
            npc:FireProjectiles(npc.Position, (npc:GetPlayerTarget().Position - npc.Position):Resized(9), 0, params)
            local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 1, npc.Position, Vector.Zero, npc)
            poof.PositionOffset = Vector(0,-10)
            poof.DepthOffset = 40
            poof.Color = mod.ColorPoop
            poof:Update()
            mod:PlaySound(SoundEffect.SOUND_WORM_SPIT, npc, 1.1)
        else
            mod:spritePlay(sprite, "Shoot")
        end
        speedMult = 0.75
    end
    

    local dist
    local playerClose
    if poop then
        dist = 80
    else
        local checkDist = npc.Position:Distance(targetpos)
        dist = math.min(npc.Position:Distance(targetpos), 40)
        if checkDist < 40 then
            playerClose = true
        end
    end
    local ang = mod:GetAngleDegreesButGood(targetpos-npc.Position)+90
    local realTarget = targetpos+Vector(dist, 0):Rotated(ang)
    local fuzzVel = Vector(mod:RandomInt(40,80,rng)/100, 0):Rotated(rng:RandomInt(360))
    local extraPush = (playerClose and (targetpos-npc.Position):Resized(0.5)) or Vector.Zero

    npc.Velocity = mod:Lerp(npc.Velocity, (realTarget-npc.Position):Resized(7.7 * speedMult), 0.1)+fuzzVel+extraPush

    if npc:CollidesWithGrid() and not poop then
        local jolt = (mod:FlailerWall(npc.Position)-npc.Position):Resized(-8)
        npc.Velocity = mod:Lerp(npc.Velocity, jolt, 0.5)
    end
end