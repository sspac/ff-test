local mod = FiendFolio

local bloomBal = {
    MaxDist = 90,
    BaseSpeed = 4,
    BaseSpeedWander = 2,
    BloomedSpeed = 4.5,
    MaxSpeed = 9,
    AimSpeed = 2,
    BloomerPlayerOffset = 60,
    ShootCooldown = {40, 90, 25},
    ShootSpeed = 12,

    BloomerMoveTime = 35,
    BloomerAngleChange = 30,
    AngleAdjust = 3,
    MaxAngle = 60,

    EyePos = Vector(0, -15),
    EyeMaxDist = 3,
    PositionStickiness = 20,
    BreakPositionStickiness = 6,

    bloomThresh = 0.55,
    BloomFleshCount = 3,
    FleshRotate = 4,
    InitialFleshDist = 5,
    MedFleshDist = 40,
    MaxFleshDist = 56,
}

local function BloomerWander(npc, par, d, rng)
    if not d.BloomerTargetPos or npc.Position:Distance(d.BloomerTargetPos+par.Position) < 15 or d.BloomerMovementFrames > bloomBal.BloomerMoveTime or mod:isConfuse(npc) then
        local newAng = mod:RandomInt(bloomBal.BloomerAngleChange, 360-bloomBal.BloomerAngleChange)
        d.BloomerTargetPos = (npc.Position-par.Position):Rotated(newAng):Resized(mod:RandomInt(math.floor(math.min(bloomBal.MaxDist/2, par.Size+3)), bloomBal.MaxDist, rng))
        d.BloomerMovementFrames = 0
        d.HoldBloomPosition = bloomBal.BreakPositionStickiness
    end
    local dir
    local speed = bloomBal.BaseSpeedWander
    if d.BloomerBloomed then
        speed = bloomBal.BloomedSpeed
    end
    if mod:isScare(npc) then
        dir = (npc.Position-(d.BloomerTargetPos+par.Position)):Rotated(d.BloomerCurveAngle):Resized(speed)
    else
        dir = ((d.BloomerTargetPos+par.Position)-npc.Position):Rotated(d.BloomerCurveAngle):Resized(speed)
    end
    d.BloomerCurveFrames = d.BloomerCurveFrames+1
    d.BloomerMovementFrames = d.BloomerMovementFrames+1
    d.BloomerCurveAngle = bloomBal.MaxAngle*d.BloomerCurve
    local val = math.sin(d.BloomerCurveFrames/35)
    d.BloomerCurve = (val > 0 and 1) or -1

    return dir
end

function mod:bloomerAI(npc)
    local sprite = npc:GetSprite()
    local d = mod:GetEntityData(npc)
    local target = npc:GetPlayerTarget()
    local targetpos = mod:randomConfuse(npc, target.Position)
    local rng = npc:GetDropRNG()

    if not d.init then
        local host = mod.FindClosestEnemyEffigy(npc.Position, true)
        if host then
            d.BloomerHost = host
            local dummyeffect = mod:AddDummyEffect(npc, Vector(0,18)*npc.SpriteScale.Y)
            dummyeffect:Update()
            local cord = Isaac.Spawn(mod.FF.BloomerCord.ID, mod.FF.BloomerCord.Var, mod.FF.BloomerCord.Sub, npc.Position, Vector.Zero, npc):ToNPC()
            cord:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            d.dummy = dummyeffect
            cord.Parent = dummyeffect
            cord.Target = host
            d.BloomerCord = cord
            cord:Update()

            d.WahooDir = Vector.Zero
            d.BloomerCurve = 1
            d.BloomerCurveAngle = 0
            d.BloomerCurveFrames = 0
            d.BloomerMovementFrames = 0

            if npc.SubType == 1 then
                d.State = "Idle"
                d.BloomerBloomed = true
            else
                d.State = "IdleWhole"
            end
        else
            npc:Kill()
        end
        d.init = true
    else
        npc.StateFrame = npc.StateFrame+1
    end

    local specialMove
    if d.State == "IdleWhole" then
        if target:ToPlayer() then
            local player = target:ToPlayer()
            local aim = mod.GetCorrectedFiringInput(player)
            if aim:Length() > 0 then
            else
                aim = nil
            end

            if aim then
                local offset = math.min(npc.Position:Distance(player.Position), bloomBal.BloomerPlayerOffset)
                targetpos = targetpos+aim:Resized(offset)
                d.WahooDir = mod:Lerp(d.WahooDir, aim:Resized(-bloomBal.AimSpeed), 0.2) --Why did I name it this in Jugular
                specialMove = true
                d.HoldBloomPosition = bloomBal.PositionStickiness
            end
        end
        mod:spritePlay(sprite, "TrueIdle")
    elseif d.State == "Idle" then
        local shoot
        if npc.StateFrame > bloomBal.ShootCooldown[1] and rng:RandomInt(bloomBal.ShootCooldown[3]) then
            shoot = true
        elseif npc.StateFrame > bloomBal.ShootCooldown[2] then
            shoot = true
        end
        if shoot then
            d.State = "Shoot"
        end

        mod:spritePlay(sprite, "IdleOpen")
    elseif d.State == "Shoot" then
        if sprite:IsFinished("Shoot") then
            d.State = "Idle"
            npc.StateFrame = 0
        elseif sprite:IsEventTriggered("Shoot") then
            local targPos = target.Position+target.Velocity*25
            local params = ProjectileParams()
            params.HeightModifier = 5
            params.Scale = 1.6
            npc:FireProjectiles(npc.Position, (targPos-npc.Position):Resized(bloomBal.ShootSpeed), 0, params)
            npc:PlaySound(SoundEffect.SOUND_MEATY_DEATHS, 0.6, 0, false, mod:RandomInt(160,200,rng)/100)
            params.Scale = 1.3
            npc:FireProjectiles(npc.Position, (target.Position-npc.Position):Resized(bloomBal.ShootSpeed*0.8), 0, params)

            local splat = Isaac.Spawn(1000, EffectVariant.BLOOD_EXPLOSION, 100, npc.Position, Vector.Zero, npc):ToEffect()
            splat.SpriteOffset = Vector(0,-16)*npc.SpriteScale.Y
            splat.DepthOffset = 30
            splat.Color = Color(1, 1, 1, 0.7, 0.1, 0.1, 0.1)
            splat:FollowParent(npc)
        else
            mod:spritePlay(sprite, "Shoot")
        end
    elseif d.State == "Break" then
        d.HoldBloomPosition = bloomBal.BreakPositionStickiness

        if sprite:IsFinished("Bloom") then
            d.State = "Idle"
            npc.StateFrame = 0
        elseif sprite:IsEventTriggered("Bloom") then
            npc:PlaySound(SoundEffect.SOUND_SKIN_PULL, 0.7, 0, false, mod:RandomInt(150,165,rng)/100)
            npc:PlaySound(SoundEffect.SOUND_POISON_HURT, 0.8, 0, false, mod:RandomInt(150,165,rng)/100)
            d.BloomerBloomed = true
            npc:BloodExplode()
            local poof = Isaac.Spawn(1000, EffectVariant.POOF02, 4, npc.Position, Vector.Zero, npc):ToEffect()
            poof:FollowParent(npc)
            poof.SpriteOffset = Vector(0, -15)
            poof.SpriteScale = Vector(0.6, 0.6)
            poof:Update()

            local rangle = rng:RandomInt(360)
            d.MyFlesh = {}
            for i=1,bloomBal.BloomFleshCount do
                local flesh = Isaac.Spawn(EntityType.ENTITY_LEPER, 1, 0, npc.Position+Vector(bloomBal.InitialFleshDist, 0):Rotated(rangle+i*(360/bloomBal.BloomFleshCount)), Vector.Zero, npc):ToNPC()
                flesh:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                flesh.Parent = npc
                mod:GetEntityData(flesh).BloomerFlesh = npc
                mod:GetEntityData(flesh).BloomerAngle = rangle+i*(360/bloomBal.BloomFleshCount)
                mod:GetEntityData(flesh).BloomerDist = bloomBal.InitialFleshDist
                flesh.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
                flesh.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
                table.insert(d.MyFlesh, flesh)
            end
        else
            mod:spritePlay(sprite, "Bloom")
        end
    end

    if d.BloomerHost and mod:superExists(d.BloomerHost) then
        local par = d.BloomerHost
        local dist = par.Position - npc.Position

        if specialMove then
            local vel
            if mod:isScare(npc) then
                vel = (npc.Position-targetpos):Resized(bloomBal.MaxSpeed)
            else
                vel = (targetpos-npc.Position):Resized(bloomBal.BaseSpeed)+d.WahooDir
                if vel:Length() > bloomBal.MaxSpeed then
                    vel = vel:Resized(bloomBal.MaxSpeed)
                end
            end
            d.BloomerTargetPos = (npc.Position-d.BloomerHost.Position)
            d.BloomerMovementFrames = 0
            
            npc.Velocity = mod:Lerp(npc.Velocity, vel, 0.3)
        else
            local frac = 0.3
            local vel
            if d.HoldBloomPosition then
                if d.HoldBloomPosition > 0 then
                    d.HoldBloomPosition = d.HoldBloomPosition-1
                else
                    d.HoldBloomPosition = nil
                end
                d.BloomerMovementFrames = 0
                vel = Vector(0, mod:RandomInt(120,300,rng)/100):Rotated(rng:RandomInt(360))
                frac = 0.08
            else
                vel = BloomerWander(npc, par, d, rng)
            end
            vel = vel+d.WahooDir
            if vel:Length() > bloomBal.MaxSpeed then
                vel = vel:Resized(bloomBal.MaxSpeed)
            end
            npc.Velocity = mod:Lerp(npc.Velocity, vel, frac)
            d.WahooDir = mod:Lerp(d.WahooDir, Vector.Zero, 0.12)
        end

        if dist:Length() > bloomBal.MaxDist then
            local distToClose = dist - dist:Resized(bloomBal.MaxDist)
            npc.Velocity = npc.Velocity + distToClose*0.5
        end
    else
        if d.BloomerCord and d.BloomerCord:Exists() then
            d.BloomerCord:Remove()
        end
        d.BloomerHost = nil
        npc:Kill()
    end

    if npc:IsDead() or not mod:superExists(npc) then
        if d.dummy then
            d.dummy:Remove()
        end
    end

    if not d.BloomerBloomed and npc.HitPoints < npc.MaxHitPoints*bloomBal.bloomThresh and d.State ~= "Break" then
        d.State = "Break"
    end
end

local eyeSprite = Sprite()
eyeSprite:Load("gfx/enemies/bloomer/bloomer.anm2", true)
eyeSprite:Play("Eye", true)
function mod:bloomerRender(npc)
    if mod:IsNormalRender(true) then
        local d = mod:GetEntityData(npc)
        if d.State == "Idle" then
            local target = npc:GetPlayerTarget()
            local targetpos = mod:randomConfuse(npc, target.Position)
            eyeSprite.Scale = npc.SpriteScale
            local scaleMult = Vector(npc.SpriteScale.X, npc.SpriteScale.Y)
            local offset = bloomBal.EyePos*scaleMult+(targetpos-npc.Position):Resized(bloomBal.EyeMaxDist)*scaleMult

            eyeSprite:Render(Isaac.WorldToScreen(npc.Position+offset), Vector.Zero, Vector.Zero)
        end
    end
end

function mod:bloomerColl(ent, coll, first)
    if coll:ToNPC() then
        if mod:GetEntityData(ent).BloomerHost and mod:GetEntityData(ent).BloomerHost.InitSeed == coll.InitSeed then
            return true
        elseif coll.Type == EntityType.ENTITY_LEPER and coll.Variant == 1 and coll.SubType == 0 then
            return true
        end
    end
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == 1 and npc.SubType == 0 then
        local d = mod:GetEntityData(npc)
        if d.BloomerFlesh and mod:superExists(d.BloomerFlesh) then
            npc.State = NpcState.STATE_ATTACK5
            local par = d.BloomerFlesh
            local pd = mod:GetEntityData(par)
            local dir = pd.BloomerCurve or 1
            d.BloomerRotate = d.BloomerRotate or bloomBal.FleshRotate*dir
            if dir == 1 then
                if d.BloomerRotate < bloomBal.FleshRotate and npc.FrameCount % 2 == 0 then
                    d.BloomerRotate = d.BloomerRotate+1
                end
            else
                if d.BloomerRotate > -bloomBal.FleshRotate and npc.FrameCount % 2 == 0 then
                    d.BloomerRotate = d.BloomerRotate-1
                end
            end
            d.BloomerAngle = d.BloomerAngle+d.BloomerRotate

            if pd.State ~= "Shoot" then
                if d.BloomerDist < bloomBal.MedFleshDist then
                    d.BloomerDist = math.min(d.BloomerDist+2, bloomBal.MedFleshDist)
                elseif d.BloomerDist > bloomBal.MedFleshDist then
                    d.BloomerDist = math.max(d.BloomerDist-1, bloomBal.MedFleshDist)
                end
                d.BloomerDist = mod:Lerp(d.BloomerDist, bloomBal.MedFleshDist, 0.05)
            elseif pd.State == "Shoot" then
                if d.BloomerDist < bloomBal.MaxFleshDist then
                    d.BloomerDist = math.min(d.BloomerDist+3, bloomBal.MaxFleshDist)
                elseif d.BloomerDist > bloomBal.MaxFleshDist then
                    d.BloomerDist = math.min(d.BloomerDist-5, bloomBal.MaxFleshDist)
                end
            end

            local targetpos = par.Position+Vector(d.BloomerDist, 0):Rotated(d.BloomerAngle)
            npc.Velocity = (targetpos-npc.Position)
        elseif d.BloomerFlesh then
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
            npc.State = NpcState.STATE_MOVE
            d.BloomerFlesh = nil
        end
    end
end, EntityType.ENTITY_LEPER)