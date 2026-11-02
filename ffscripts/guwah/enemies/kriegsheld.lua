local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local bal = {
    shortWait = {20,35},
    waitTime = {50,80},
    projSpeed = 8.5,
    burstProjSpeed = 18,
    burstAngleVar = 8,
    burstTime = 30,
}

local params = ProjectileParams()
params.Scale = 2
params.BulletFlags = ProjectileFlags.NO_WALL_COLLIDE

function mod:KriegsheldAI(npc, sprite, data)
    local rng = npc:GetDropRNG()
    local room = game:GetRoom()
    local targetpos = mod:confusePos(npc, npc:GetPlayerTarget().Position)

    if not data.Init then
        if npc.SubType == 0 then
            sprite.FlipX = (rng:RandomFloat() <= 0.5)
        elseif npc.SubType == 1 then
            sprite.FlipX = true
        end

        npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
        npc.StateFrame = mod:RandomInt(bal.shortWait, rng)
        data.State = "Idle"
        data.Init = true
    end

    npc.Velocity = Vector.Zero
    mod.QuickSetEntityGridPath(npc)
    mod.NegateKnockoutDrops(npc)

    if data.State == "Idle" then
        mod:SpritePlay(sprite, "Idle")

        npc.StateFrame = npc.StateFrame - 1
        if npc.StateFrame <= 0 then
            data.State = "Shoot"
            npc.StateFrame = mod:RandomInt(bal.waitTime, rng)
        end

    elseif data.State == "Shoot" then
        if sprite:IsFinished("Shoot") then
            data.State = "Idle"
        elseif sprite:IsEventTriggered("Shoot") then
            local kriegVec
            local validPoses = {}
            for i = 90, 360, 90 do
                local endPos = room:GetLaserTarget(targetpos, Vector.FromAngle(i))
                local checkLinePos = endPos - Vector.FromAngle(i):Resized(20)
                if room:CheckLine(targetpos, checkLinePos, 3, 0, false, false) and room:CheckLine(npc.Position, checkLinePos, 3, 0, false, false) and targetpos:Distance(endPos) > 30 then
                    --Isaac.Spawn(1000,2,5,endPos,Vector.Zero,npc)
                    table.insert(validPoses, endPos)
                end
            end
            local shootPos = mod:GetRandomElem(validPoses, rng)

            if shootPos then
                kriegVec = mod:SnapVector(targetpos - shootPos, 90):Resized(bal.burstProjSpeed)
            else
                shootPos = targetpos
            end

            local proj = mod:FireProjectiles(npc, npc.Position, (shootPos - npc.Position):Resized(bal.projSpeed), 0, params)
            mod:GetEntityData(proj).projType = "Kriegsheld"
            mod:GetEntityData(proj).KriegVec = kriegVec

            local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 2, npc.Position, Vector.Zero, npc)
            effect.Color = Color(1,1,1,0.7)
            effect.DepthOffset = 40
            effect.SpriteOffset = sprite.FlipX and Vector(-15,-32) or Vector(15,-32)
       
            mod:PlaySound(SoundEffect.SOUND_MONSTER_GRUNT_4, npc, 0.8)
        else 
            mod:SpritePlay(sprite, "Shoot")
        end
    end
end

function mod:KriegsheldProjectile(proj, data)
    proj.FallingSpeed = 0
    proj.FallingAccel = -0.1

    if data.KriegStuck then
        data.KriegCounter = data.KriegCounter + 1
        proj.Color = Color(1,1,1,1,data.KriegCounter/45)
        proj.Velocity = Vector.Zero

        if data.KriegCounter >= bal.burstTime then
            for i = 1, 30 do
                mod.scheduleForUpdate(function()
                    if i % 3 <= 1 then
                        local p = mod:LazySpawnProjectile(proj.Variant, 0, proj.Position, data.KriegVec:Rotated(mod:RandomInt(-bal.burstAngleVar, bal.burstAngleVar)), proj):ToProjectile()
                        p:AddProjectileFlags(proj.ProjectileFlags)
                        p.Scale = mod:RandomInt(5,10) * 0.1
                        local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 1, proj.Position + (RandomVector() * mod:RandomInt(0,15)), Vector.Zero, proj)
                        effect.PositionOffset = proj.PositionOffset
                        effect:Update()
                    end
                end, i)
            end
            local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 3, proj.Position, Vector.Zero, proj)
            effect.PositionOffset = proj.PositionOffset
            effect:Update()
            mod:PlaySound(SoundEffect.SOUND_DEATH_BURST_LARGE, nil, 1.5)
            proj:Die()
        elseif data.KriegCounter == bal.burstTime - 20 then
            local tracer = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.GENERIC_TRACER, 0, proj.Position, Vector(0.001,0), npc):ToEffect()
            tracer.Timeout = 20
            tracer.TargetPosition = data.KriegVec:Normalized()
            tracer.PositionOffset = proj.PositionOffset
            tracer.LifeSpan = 15
            tracer.Color = Color(1,0,0)
            tracer:Update()
        end
    else
        local room = game:GetRoom()
        local samplePos = proj.Position + proj.Velocity
        if room:GetGridCollisionAtPos(samplePos) >= GridCollisionClass.COLLISION_SOLID then
            local stickPos = mod:GetNearestPosOfCollisionClassOrGreater(proj.Position, GridCollisionClass.COLLISION_SOLID)
            data.KriegStuck = true
            data.KriegVec = data.KriegVec or mod:SnapVector(proj.Position - stickPos, 90):Resized(bal.burstProjSpeed)
            data.KriegCounter = 0
            mod:PlaySound(SoundEffect.SOUND_MEAT_IMPACTS, nil, 1, 0.7)
            local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 2, proj.Position + proj.Velocity, Vector.Zero, proj)
            effect.PositionOffset = proj.PositionOffset
            effect:Update()
        end
    end
end