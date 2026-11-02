local mod = FiendFolio

local bal = {
    spread = 7,
    speed = 7.7,
    speed2 = 0.6,

    cooldown = 45,
}

local boneColor = Color(90/255,25/255,110/255)

--some code used from red bony
function mod:hazyAI(npc)
    local d = mod:GetEntityData(npc)
    local sprite = npc:GetSprite()
    local target = npc:GetPlayerTarget()

    if not d.init then
        npc.SplatColor = boneColor
        d.hazyCooldown = 0
        d.init = true
    elseif d.hazyCooldown > 0 then
        d.hazyCooldown = d.hazyCooldown-1
    end


    if npc.State == NpcState.STATE_ATTACK and d.hazyCooldown > 0 then
        local entry = d.prevHazeInfo or {anim = sprite:GetAnimation(), frame = sprite:GetFrame(), vel = npc.Velocity}
        local dir, flip = mod:GetMoveString(entry.vel, true)
        sprite.FlipX = flip
        npc.State = NpcState.STATE_MOVE
        sprite:Play("Walk" .. dir, true)
        sprite:SetFrame(entry.frame)
        npc.Velocity = entry.vel
    else
        d.prevHazeInfo = {frame = sprite:GetFrame(), vel = npc.Velocity}
    end

    if sprite:IsEventTriggered("Shoot") then
        d.hazyCooldown = bal.cooldown
        for _, bone in pairs(Isaac.FindByType(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_BONE)) do
            if bone.FrameCount <= 0 and bone.SpawnerEntity and bone.SpawnerEntity.InitSeed == npc.InitSeed then
                local br = npc:GetDropRNG()
                bone = bone:ToProjectile()
                bone.Color = boneColor

                local params = ProjectileParams()
                --params.Variant = 1
                params.Color = boneColor
                local sFlip = (br:RandomInt(2) == 0 and 1) or -1
                bone.Velocity = bone.Velocity:Resized(bal.speed)
                for i=-1,1 do
                    local speed = bal.speed+bal.speed2*sFlip - (bal.speed2*(i+1)*sFlip)
                    local real = bone
                    if i ~= 0 then
                        real = mod:LazySpawnProjectile(1, 0, npc.Position, bone.Velocity:Resized(speed):Rotated(i*bal.spread), npc):ToProjectile()
                        real.Height = bone.Height
                        real.ProjectileFlags = bone.ProjectileFlags
                        real.Color = boneColor
                        real.FallingSpeed = bone.FallingSpeed
                        real.FallingAccel = bone.FallingAccel
                        real.CollisionDamage = bone.CollisionDamage
                    end
                    local bd = mod:GetEntityData(real)
                    real.FallingSpeed = -1.5
                    real.FallingAccel = -0.03

                    bd.projType = "customProjectileBehavior"
                    bd.customProjectileBehavior = {update = function(v, tab)
                        --[[if i ~= 0 then
                            local targetpos = tab.originalPos+tab.originalVel+tab.originalVel:Rotated(90):Resized(math.sin(i*v.FrameCount/2)*2.5)
                            tab.originalPos = tab.originalPos+tab.originalVel
                            v.Velocity = mod:Lerp(v.Velocity, (targetpos-v.Position):Resized(bal.speed2), 0.3)
                        end]]
                        local rng = v:GetDropRNG()
                        tab.offset = tab.offset or rng:RandomInt(10)
                        tab.offset = tab.offset+1

                        if tab.offset % 3 == 0 then
                            local randVel = RandomVector()*mod:RandomInt(5,15,rng)/20
                            local cloud = Isaac.Spawn(1000, 59, 0, v.Position, Vector.Zero, v):ToEffect()
                            cloud:SetTimeout(mod:RandomInt(10,30,rng))
                            local color = Color(0.2,0,0.3,0.3,0,0,0)
                            cloud.Color = color
                            local randScale = mod:RandomInt(50,60,rng)/100
                            cloud.SpriteScale = Vector(randScale, randScale)
                            mod:GetEntityData(cloud).cosmeticDust = {scale = randScale, vel = randVel, lifespan = mod:RandomInt(10,30,rng), alpha = 0.5}
                            cloud.SpriteOffset = Vector(0, v.Height*0.6)
                        end

                        if v:CollidesWithGrid() then
                            local proj = mod:LazySpawnProjectile(1, 0, v.Position, (target.Position-v.Position):Resized(bal.speed), npc):ToProjectile()
                            proj.Height = v.Height
                            proj.ProjectileFlags = v.ProjectileFlags
                            proj.Color = v.Color
                            proj.FallingSpeed = -2
                            proj.FallingAccel = 0
                            proj:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
                            mod.scheduleForUpdate(function()
                                proj:ClearProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
                            end, 3)
                            v:Remove()
                        end
                    end,}
                end
                break
            end
        end
    end
end