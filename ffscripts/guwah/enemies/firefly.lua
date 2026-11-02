local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local bal = {
    moveSpeed = 5,
    moveLerp = 0.1,
    fullSpeed = 3,
    fullLerp = 0.3,
    targetDistance = 160,
    projSpeed = 8,
    projAngleVar = 15,
}

function mod:FindFireFlyFlame(npc)
    local dist = 9999
    local flame 
    for _, fire in pairs(Isaac.FindByType(EntityType.ENTITY_FIREPLACE)) do
        if fire.Position:Distance(npc.Position) < dist and mod:IsFireValid(fire) then
            flame = fire
            dist = fire.Position:Distance(npc.Position)
        end
    end
    for _, fire in pairs(Isaac.FindByType(1000,7005)) do
        if fire.Position:Distance(npc.Position) < dist and fire.Velocity:Length() < 5 then
            flame = fire
            dist = fire.Position:Distance(npc.Position)
        end
    end
    return flame
end

function mod:WanderAboutAir(npc, data, speed, lerpVal, minRad, maxRad, avoidPlayer, avoidEnemies)
    lerpVal = lerpVal or 0.3

    local room = game:GetRoom()
    local rng = npc:GetDropRNG()
    local targetpos = mod:confusePos(npc, npc:GetPlayerTarget().Position)

    if data.WalkPos then
        local vel 
        if mod:isScare(npc) or (avoidPlayer and targetpos:Distance(npc.Position) <= avoidPlayer and room:CheckLine(npc.Position,targetpos,0,1,false,false)) then
            vel = (npc.Position - targetpos):Resized(speed)
            data.WalkPos = nil
        elseif data.WalkPos:Distance(npc.Position) <= 10 then
            data.WalkPos = nil
        else
            vel = (data.WalkPos - npc.Position):Resized(speed)
        end

        if vel then
            npc.Velocity = mod:Lerp(npc.Velocity, vel, lerpVal)
        end
    else
        data.WalkPos = mod:FindRandomFreePosAirNoGrids(targetpos, minRad, maxRad, avoidEnemies)
        return true
    end
end

function mod:IsFireValid(fire, allowFading)
    if fire and fire:Exists() then
        if fire.Type == EntityType.ENTITY_FIREPLACE then
            return ((fire:ToNPC().State ~= 3 or fire.Variant >= 10) and fire.Variant ~= 11)
        elseif fire.Type == 1000 and fire.Variant == 7005 then
            return (allowFading or not (mod:GetEntityData(fire).timer and fire.FrameCount > mod:GetEntityData(fire).timer))
        end
    end
end

function mod:ShootFlamethrowerFlame(npc, pos, vel, params, height, sheet)
    params = params or ProjectileParams()
    params.Variant = ProjectileVariant.PROJECTILE_FIRE
    params.Color = Color.Default
    local proj = mod:FireProjectiles(npc, pos, vel, 0, params)
    proj.FallingAccel = -0.1
    proj.Height = -3
    mod:GetEntityData(proj).FlamethrowerFire = true
    if sheet then
        proj:GetSprite():ReplaceSpritesheet(0, sheet)
        proj:GetSprite():LoadGraphics()
    end
    return proj
end

function mod:FireFlyAI(npc, sprite, data)
    local targetpos = mod:confusePos(npc, npc:GetPlayerTarget().Position)
    local room = game:GetRoom()
    local rng = npc:GetDropRNG()
    mod:beelzebubCheck(npc)

    if not data.Init then
        data.State = "Idle"
        data.Init = true
    end

    if data.State == "Idle" then
        mod:spritePlay(sprite, "Idle")
        if mod:IsFireValid(npc.Child) then
            npc.Velocity = mod:Lerp(npc.Velocity, (npc.Child.Position - npc.Position):Resized(bal.moveSpeed), bal.moveLerp)
            if npc.Position:Distance(npc.Child.Position) <= 20 then
                npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
                data.State = "Suck"
            end
        else
            npc.Child = mod:FindFireFlyFlame(npc)
            mod:WanderAboutAir(npc, data, bal.moveSpeed, bal.moveLerp, 60, 120)
        end

    elseif data.State == "Suck" then
        npc.Velocity = npc.Velocity * 0.5
        if sprite:IsFinished("FireSuck") then
            data.State = "Full"
        elseif sprite:IsEventTriggered("Shoot") then
            if not mod:IsFireValid(npc.Child, true) then
                npc:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
                sprite:SetAnimation("FireSuckWhiff", false)
                data.State = "Whiff"
            else
                local sheet
                data.FireData = {
                    Type = npc.Child.Type,
                    Variant = npc.Child.Variant,
                }
                data.FullOfFire = true
                npc.Child.Velocity = Vector.Zero
            end
            mod:PlaySound(mod.Sounds.BaloonShort, npc, 2)
        elseif sprite:IsEventTriggered("Stop") then
            npc:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
        else
            mod:spritePlay(sprite, "FireSuck")
        end

        if sprite:WasEventTriggered("Shoot") and not sprite:WasEventTriggered("Stop") and npc.FrameCount % 2 == 0 then
            if mod:IsFireValid(npc.Child) then
                if npc.Child.Type == EntityType.ENTITY_FIREPLACE and npc.FrameCount % 4 == 0 then
                    local flags = 0
                    if npc.Child.Variant == 2 or npc.Child.Variant == 3 or npc.Child.Variant == 12 or npc.Child.Variant == 13 then
                        flags = DamageFlag.DAMAGE_EXPLOSION
                    end
                    npc.Child:TakeDamage(1, flags, EntityRef(npc), 0)
                elseif npc.Child.Type == 1000 and npc.Child.Variant == 7005 then --Gunpowder creep fire
                    mod:GetEntityData(npc.Child).SpriteScale = Vector(npc.Child.SpriteScale.X - 0.1, npc.Child.SpriteScale.Y - 0.1)
                end
            end
        end

    elseif data.State == "Whiff" then
        npc.Velocity = npc.Velocity * 0.5
        if sprite:IsFinished("FireSuckWhiff") then
            data.State = "Idle"
        else
            mod:spritePlay(sprite, "FireSuckWhiff")
        end

    elseif data.State == "Full" then
        mod:spritePlay(sprite, "Idle2")
        if npc.Position:Distance(targetpos) <= bal.targetDistance and room:CheckLine(npc.Position,targetpos,3,0,false,false) then
            data.State = "Shoot"
        else
            npc.Velocity = mod:Lerp(npc.Velocity, (targetpos - npc.Position):Resized(bal.fullSpeed), bal.fullLerp)
        end

    elseif data.State == "Shoot" then
        npc.Velocity = npc.Velocity * 0.8
        if sprite:IsFinished("Shoot") then
            data.State = "Idle"
        elseif sprite:IsEventTriggered("Shoot") then
            mod:PlaySound(mod.Sounds.FriedStart,npc,0.8)
            mod:PlaySound(SoundEffect.SOUND_FLAME_BURST,npc,1,0.5)
            data.FullOfFire = false
        elseif sprite:IsEventTriggered("Stop") then
            mod:PlaySound(SoundEffect.SOUND_CANDLE_LIGHT,npc,1,1.5)
        else
            mod:spritePlay(sprite, "Shoot")
        end

        if sprite:WasEventTriggered("Shoot") and not sprite:WasEventTriggered("Stop") and npc.FrameCount % 2 == 0 then
            local sheet 
            local shootbullets
            local params = ProjectileParams()
            if data.FireData.Type == EntityType.ENTITY_FIREPLACE then
                if data.FireData.Variant == 1 then
                    sheet = "gfx/effects/effect_005_fire_red.png"
                    shootbullets = true
                elseif data.FireData.Variant == 2 or data.FireData.Variant == 12 then
                    sheet = "gfx/effects/effect_005_fire_blue.png"
                elseif data.FireData.Variant == 3 or data.FireData.Variant == 13 then
                    sheet = "gfx/effects/effect_005_fire_purple.png"
                    shootbullets = true
                    params.BulletFlags = ProjectileFlags.SMART
                end
            end
            mod:ShootFlamethrowerFlame(npc, npc.Position, (targetpos-npc.Position):Resized(bal.projSpeed):Rotated(mod:RandomInt(-bal.projAngleVar,bal.projAngleVar,rng)), params, -25, sheet)
            if shootbullets then
                local params = ProjectileParams()
                params.FallingAccelModifier = 0.6
                params.FallingSpeedModifier = mod:RandomInt(-8,-5,rng)
                params.Scale = mod:RandomInt(16,30,rng) * 0.05
                local proj = mod:FireProjectiles(npc, npc.Position, (targetpos-npc.Position):Resized(mod:RandomInt(5,12,rng)):Rotated(mod:RandomInt(-20,20,rng)), 0, params)
                if data.FireData.Variant == 1 then
                    mod:GetEntityData(proj).creeptype = "red"	
                elseif data.FireData.Variant == 3 or data.FireData.Variant == 13 then   
                    proj:AddProjectileFlags(ProjectileFlags.SMART)	
                end		
            end
        end
    end

    if npc:IsDead() and data.FullOfFire then
        local firevar = 10
        if data.FireData.Variant == 2 or data.FireData.Variant == 12 then
            firevar = 12
        end
        Isaac.Spawn(EntityType.ENTITY_FIREPLACE, firevar, 0, npc.Position, Vector.Zero, npc)
    end
end

function mod:FireFlyColl(npc, collider)
    if collider.Type == EntityType.ENTITY_FIREPLACE then
        return true
    end
end