local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local bal = {
    projSpeed = 10,
    trailBones = false,
    bounceBones = true,
    bounceVelMult = 0.8,
    numBounces = 3,
    maxRotate = 25,
}

local boneColor = Color(173/255,24/255,24/255)

local params = ProjectileParams()

function mod:RedBonyAI(npc, sprite, data)
    mod:lastJudgementAutoResprite(npc, data, sprite)
    if sprite:IsEventTriggered("Shoot") then
        for _, bone in pairs(Isaac.FindByType(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_BONE)) do
            if bone.FrameCount <= 0 and bone.SpawnerEntity and bone.SpawnerEntity.InitSeed == npc.InitSeed then
                bone = bone:ToProjectile()
                bone.Color = boneColor
                mod:GetEntityData(bone).projType = "RedBony"
                if bal.bounceBones then
                    mod:GetEntityData(bone).NumBounces = bal.numBounces
                    bone.Velocity = bone.Velocity * bal.bounceVelMult
                    bone.FallingSpeed = -10
                    bone.FallingAccel = 1.5
                end
                data.LastThrowVec = bone.Velocity
                break
            end
        end
    end

    if npc:IsDead() and mod:shouldDoDeathEffect(npc) then
        local angle = data.LastThrowVec and data.LastThrowVec:GetAngleDegrees() or mod:RandomAngle(npc:GetDropRNG())
        for i = 60, 360, 60 do
            npc:FireProjectiles(npc.Position, Vector(bal.projSpeed,0):Rotated(i + angle + 30), 0, params)
        end
    end
end

function mod:RedBonyProjectile(proj, data)
    if bal.trailBones then
        if proj.FrameCount % 4 == 0 then
            local trail = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HAEMO_TRAIL, 0, proj.Position, proj.Velocity:Rotated(mod:RandomInt(-45, 45)) * mod:RandomInt(-10, 20)/100, proj)
            trail.PositionOffset = proj.PositionOffset
            trail.SpriteScale = trail.SpriteScale * 0.75
            trail.DepthOffset = -40
            trail:Update()
        end

        if proj.FrameCount % 8 == 0 then
            local p = mod:LazySpawnProjectile(0, 0, proj.Position, proj.Velocity * mod:RandomInt(5,15) * 0.01, proj):ToProjectile()
            p.Scale = mod:RandomInt(5, 10) / 10
            p.FallingAccel = -0.08
            p.ProjectileFlags = proj.ProjectileFlags
            p:Update()
        end
    end

    if bal.bounceBones then
        if data.NumBounces > 0 and proj.Height >= -10 then
            local target = game:GetNearestPlayer(proj.Position)
            if proj:HasProjectileFlags(ProjectileFlags.HIT_ENEMIES) then
                local enemy = mod:GetNearestEnemy(proj.Position)
                if enemy then
                    target = enemy
                end
            end

            local angleDifference = mod:GetAngleDifferenceDead(target.Position - proj.Position, proj.Velocity)
            local rotation = angleDifference
            if rotation > bal.maxRotate then
                rotation = bal.maxRotate
            elseif rotation < -bal.maxRotate then
                rotation = -bal.maxRotate
            end

            local sprite = proj:GetSprite()
            local p = Isaac.Spawn(proj.Type, proj.Variant, 0, proj.Position, proj.Velocity:Rotated(rotation), proj.SpawnerEntity):ToProjectile()
            p.Color = proj.Color
            p.Scale = proj.Scale
            p.FallingSpeed = -15
            p.FallingAccel = 1.5
            p.Height = proj.Height
            p.ProjectileFlags = proj.ProjectileFlags
            p:GetSprite():SetFrame(sprite:GetFrame())
            p:GetSprite():Play(sprite:GetAnimation())
            mod:GetEntityData(p).projType = data.projType
            mod:GetEntityData(p).NumBounces = data.NumBounces - 1


            local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 2, proj.Position, Vector.Zero, proj)
            effect.SpriteScale = Vector(0.8,0.5)
            effect.Color = Color(1,1,1,0.5)
            effect.DepthOffset = -80
            effect:Update()
            mod:PlaySound(SoundEffect.SOUND_SCAMPER, nil, 1 + (0.5 * (bal.numBounces - data.NumBounces)), 0.5)

            proj:Remove()
        end
    end
end