local mod = FiendFolio
local sfx = SFXManager()
local game = Game()

local colorRedColour = Color(3, 0.7, 0.95, 1, 0.33, 0, 0)
colorRedColour:SetColorize(3, 0.04, 0.1, 0.8)

function mod:theColorRedAI(npc)
    local d = mod:GetEntityData(npc)
    local rng = npc:GetDropRNG()
    local target = npc:GetPlayerTarget()
    local room = game:GetRoom()

    if not d.init then
        npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        npc:GetSprite():Play("the animation that plays when this is red", true)
        npc.Visible = false
        npc:AddEntityFlags(EntityFlag.FLAG_NO_REWARD | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

        if (npc.SubType >> 7 & 1) == 1 then
            d.stationary = true
            d.initPos = npc.Position
        else
            d.pos = npc.Position
            npc.StateFrame = mod:getRoll(60, 120, rng)
            d.leaveFrame = mod:getRoll(140,220,rng)
            d.coolDownPeriod = 0
        end
        d.colorRedSize = npc.SubType & 127
        npc.Size = (d.colorRedSize+40)/2
        d.chosenMainRedFrame = rng:RandomInt(4)
        d.init = true
    else
        npc.StateFrame = npc.StateFrame+1
    end

    if d.stationary then
        if not d.isSpecturned then
            if not d.initPos then
                d.initPos = npc.Position
            end
            npc.Velocity = d.initPos-npc.Position
        else
            d.initPos = nil
        end
    else
        if npc.StateFrame > d.leaveFrame then
            if rng:RandomInt(6) == 0 then
                d.pos = target.Position
            else
                d.pos = mod:FindRandomFreePos(npc, 160)
            end
            d.leaveFrame = mod:getRoll(140,220,rng)
            d.coolDownPeriod = mod:getRoll(100,270,rng)*npc.Size/40
        end

        if d.coolDownPeriod > 0 then
            d.coolDownPeriod = d.coolDownPeriod-1
            npc.StateFrame = 0
            npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.05)
        else
            npc.Velocity = mod:Lerp(npc.Velocity, (d.pos-npc.Position):Resized(40/npc.Size), 0.14)

            if npc.Position:Distance(d.pos) < 30 then
                npc.StateFrame = d.leaveFrame
            end
        end
    end

    if npc.FrameCount % 13 == 0 then
        local eff = Isaac.Spawn(mod.FF.TheColorRedSplash.ID, mod.FF.TheColorRedSplash.Var, mod.FF.TheColorRedSplash.Sub, npc.Position, Vector.Zero, npc):ToEffect()
        local ed = mod:GetEntityData(eff)
        eff.DepthOffset = 500
        eff.SpriteRotation = rng:RandomInt(360)
        eff.SpriteOffset = mod:shuntedPosition(22, rng)*npc.Size/40
        eff.Color = Color(1, 0.5, 0.2, mod:getRoll(140,200,rng)/255, rng:RandomInt(30)/255, 0, 0)
        local scale = mod:getRoll(55,90,rng)/100*npc.Size/40
        eff.SpriteScale = Vector(scale, scale)
        ed.mainBodySize = npc.Size
        eff.Parent = npc
        eff:Update()
    end
    if (npc.FrameCount+2) % 10 == 0 then
        local eff = Isaac.Spawn(mod.FF.TheColorRedSplash.ID, mod.FF.TheColorRedSplash.Var, mod.FF.TheColorRedSplash.Sub, npc.Position, npc.Velocity*0.5, npc):ToEffect()
        local ed = mod:GetEntityData(eff)
        local scale = 1.2*npc.Size/40
        eff.SpriteScale = Vector(scale, scale)
        eff.Color = Color(1, 0.5, 0.2, 0.7, 0.13, 0, 0)
        eff.SpriteRotation = rng:RandomInt(360)
        eff.DepthOffset = 800
        local num = rng:RandomInt(4)
        while d.chosenMainRedFrame == num do
            num = rng:RandomInt(4)
        end
        ed.splochFrame = num
        ed.chosenMainRedFrame = num
        ed.lowerDepthOffsetRed = true
        ed.colorRedMainBody = true
        ed.mainBodySize = npc.Size
        --ed.spriteRotation = rng:RandomInt(3)-1
        eff.Parent = npc
        eff:Update()

        local splat = Isaac.Spawn(1000, EffectVariant.BLOOD_SPLAT, 0, npc.Position, Vector.Zero, npc):ToEffect()
        splat.Scale = 0.6*npc.Size/40
        splat:Update()
    end

    if room:IsClear() then
        npc:Remove()
    end

    if mod:isFriend(npc) then

    else
        for _, enemy in ipairs(Isaac.FindInRadius(npc.Position, npc.Size+50, EntityPartition.ENEMY)) do
            if not mod:isCuffsBlacklisted(enemy) and not mod:isFriend(enemy) and not mod:GetEntityData(enemy).colorRedAffected and enemy.EntityCollisionClass > EntityCollisionClass.ENTCOLL_NONE and enemy:IsActiveEnemy() then
                if enemy.Position:DistanceSquared(npc.Position) <= (npc.Size + enemy.Size) ^ 2 then
                    mod:GetEntityData(enemy).colorRedAffected = npc
                    mod:GetEntityData(enemy).colorRedFlash = 5

                    --[[local eff = Isaac.Spawn(mod.FF.TheColorRedSplash.ID, mod.FF.TheColorRedSplash.Var, mod.FF.TheColorRedSplash.Sub, enemy.Position, Vector.Zero, npc):ToEffect()
                    local ed = mod:GetEntityData(eff)
                    local scale = 1.5*enemy.Size/20
                    eff.SpriteScale = Vector(scale, scale)
                    eff.Color = Color(1, 0.2, 0.2, 0.9, 0.7, 0, 0)
                    eff.SpriteRotation = rng:RandomInt(360)
                    eff.SpriteOffset = Vector(0, -enemy.Size*0.8)
                    eff.DepthOffset = 800
                    eff:FollowParent(enemy)
                    eff:Update()]]
                end
            end
        end
    end
end

function mod:theColorRedSplashes(e)
    local d = mod:GetEntityData(e)
    local sprite = e:GetSprite()
    local rng = e:GetDropRNG()

    if not d.init then
        if not d.splochFrame then
            d.splochFrame = rng:RandomInt(4)
        end
        d.init = true
    end

    if sprite:IsFinished("Sploch" .. d.splochFrame) then
        e:Remove()
    else
        mod:spritePlay(sprite, "Sploch" .. d.splochFrame)
    end

    if d.lowerDepthOffsetRed then
        if e.DepthOffset > 500 then
            e.DepthOffset = e.DepthOffset-2
        end
    end

    if d.colorRedMainBody then
        --e.SpriteRotation = e.SpriteRotation+(d.spriteRotation or 0)*rng:RandomInt(10)/20
        if e.Parent then
            local vel = mod:getRoll(10, 22, rng)/10*(83.5-(d.mainBodySize or 1))/83.5
            e.Velocity = mod:Lerp(e.Velocity, (e.Parent.Position-e.Position):Resized(vel), 0.15)
        end
    elseif d.enemySpawnRed then
        if e.Parent then
            local vel = e.Parent.Velocity*0.95
            e.Velocity = mod:Lerp(e.Velocity, (e.Parent.Position-e.Position):Resized(vel:Length()*0.9), 0.15)
        end
    elseif d.deathEffectRedEffect then
        e.Velocity = Vector.Zero
        sprite:Update()
    else
        if e.Parent then
            local vel = 0.7*(83.5-(d.mainBodySize or 1))/83.5
            e.Velocity = mod:Lerp(e.Velocity, (e.Parent.Position-e.Position):Resized(vel), 0.08)
        end
    end
end

function mod:theColorRedEffectedEnemies(npc, d)
    local d = mod:GetEntityData(npc)
    if d.colorRedAffected then
        local rng = npc:GetDropRNG()
        if npc.EntityCollisionClass > EntityCollisionClass.ENTCOLL_NONE then
            if mod:isFriend(npc) then
                if npc.FrameCout % 3 == 0 and Isaac.CountEntities(nil, 1000, EffectVariant.PLAYER_CREEP_RED, -1) < 100 then
                    local creep = Isaac.Spawn(1000, EffectVariant.PLAYER_CREEP_RED, 0, npc.Position, Vector.Zero, npc):ToEffect()
                    creep.Scale = math.min(5, math.max(0.2, npc.Size/15))
                    creep:SetTimeout(60)
                    creep:Update()
                elseif npc.FrameCount % 6 == 0 then
                    local creep = Isaac.Spawn(1000, EffectVariant.PLAYER_CREEP_RED, 0, npc.Position, Vector.Zero, npc):ToEffect()
                    creep.Scale = math.min(5, math.max(0.2, npc.Size/15))
                    creep:SetTimeout(40)
                    creep:Update()
                end
            else
                if npc.FrameCount % 3 == 0 and Isaac.CountEntities(nil, 1000, EffectVariant.CREEP_RED, -1) < 100 then
                    local creep = Isaac.Spawn(1000, EffectVariant.CREEP_RED, 0, npc.Position, Vector.Zero, npc):ToEffect()
                    creep.Scale = math.min(5, math.max(0.2, npc.Size/15))
                    creep:SetTimeout(60)
                    creep:Update()
                elseif npc.FrameCount % 6 == 0 then
                    local creep = Isaac.Spawn(1000, EffectVariant.CREEP_RED, 0, npc.Position, Vector.Zero, npc):ToEffect()
                    creep.Scale = math.min(5, math.max(0.2, npc.Size/15))
                    creep:SetTimeout(40)
                    creep:Update()
                end
            end

            if npc.FrameCount % 6 == 0 then
                local eff = Isaac.Spawn(mod.FF.TheColorRedSplash.ID, mod.FF.TheColorRedSplash.Var, mod.FF.TheColorRedSplash.Sub, npc.Position, npc.Velocity, npc):ToEffect()
                local ed = mod:GetEntityData(eff)
                eff.DepthOffset = 800
                eff.SpriteRotation = rng:RandomInt(360)
                --eff.SpriteOffset = mod:shuntedPosition(22, rng)*npc.Size/20
                --eff.SpriteOffset = eff.SpriteOffset + Vector(0, -npc.Size*0.8)
                eff.SpriteOffset = Vector(0.5, -npc.Size*2.2-5)
                eff.Color = Color(1, 0.5, 0.2, mod:getRoll(100,190,rng)/255, (40+rng:RandomInt(30))/255, 0, 0)
                local scale = npc.Size/40
                eff.SpriteScale = Vector(scale, scale)
                ed.mainBodySize = npc.Size
                ed.lowerDepthOffsetRed = true
                ed.deathEffectRedEffect = true
                eff.Parent = npc
                eff:FollowParent(npc)
                eff:Update()
                --nevermind the smoke looked bad
            --[[elseif npc.FrameCount % 17 == 0 then
                local spd = rng:RandomInt(5)/4
                local vel = npc.Velocity:Resized(spd)
                local dust = Isaac.Spawn(1000, EffectVariant.DUST_CLOUD, 0, npc.Position, vel, npc):ToEffect()
                local de_dust = mod:GetEntityData(dust)
                dust.Color = Color(1, 0.5, 0.5, 0.2, 0.6, 0.1, 0.1)
                local scale = npc.Size/60
                dust.SpriteScale = Vector(scale, scale)
                dust:SetTimeout(mod:getRoll(25,45,rng))
                de_dust.cosmeticDust = {vel = vel, scale = mod:getRoll(20,55,rng)/100, alpha = 0.6}
                dust:Update()]]
            end

            if d.colorRedFlash > 0 then
                d.colorRedFlash = d.colorRedFlash-1
                npc.Color = Color.Lerp(npc.Color, Color(3,0.5,0.5,1,1,0.2,0.2), 0.2)
            else
                npc.Color = Color.Lerp(npc.Color, colorRedColour, 0.2)
            end
        end

        if npc:IsDead() then
            local charm
            if mod:isFriend(npc) then
                charm = ProjectileFlags.CANT_HIT_PLAYER | ProjectileFlags.HIT_ENEMIES
            elseif mod:isCharm(npc) then
                charm = ProjectileFlags.HIT_ENEMIES
            end
            table.insert(mod.colorRedDeathBurst, {npc = npc, charmMode = charm, frame = 0, pos = npc.Position, rng = rng, vel = 0, trueFrame = 0})
        end
    end
end
mod:AddEntityCallback(ModCallbacks.MC_NPC_UPDATE, mod.FF.TheColorRed.ID, mod.FF.TheColorRed.Var, nil, mod.theColorRedEffectedEnemies)

function mod:colorRedDeathBurstEffect(entry, key)
    if entry.frame < 55 then
        entry.frame = entry.frame+entry.vel
        entry.vel = entry.vel+0.15
        entry.trueFrame = entry.trueFrame+1
        if entry.trueFrame % 2 == 0 then
            local eff = Isaac.Spawn(mod.FF.TheColorRedSplash.ID, mod.FF.TheColorRedSplash.Var, mod.FF.TheColorRedSplash.Sub, entry.pos, Vector.Zero, entry.npc):ToEffect()
            local ed = mod:GetEntityData(eff)
            eff.DepthOffset = 800
            eff.SpriteRotation = entry.rng:RandomInt(360)
            eff.SpriteOffset = mod:shuntedPosition(10, entry.rng)
            eff.Color = Color(1, math.max(0, math.max(0, (200-entry.frame*5)/255)), math.max(0, (150-entry.frame*5)/255), 0.9, (40+(entry.frame*5))/255, 0, 0)
            local scale = (55-entry.frame)/40
            eff.SpriteScale = Vector(scale, scale)
            ed.deathEffectRedEffect = true
            ed.lowerDepthOffsetRed = true
            eff:Update()
        end
        if entry.trueFrame % 3 == 0 then
            sfx:Play(SoundEffect.SOUND_MEAT_JUMPS, 0.5, 0, false, mod:getRoll(110,125,entry.rng)/100)
        end
    else
        for i=1,8 do
            local proj = mod:LazySpawnProjectile(0, 0, entry.pos, Vector(0,12):Rotated(i*45), entry.npc):ToProjectile()
            local color = Color(2, 0.7, 0.7, 1, 0.33, 0, 0)
            color:SetColorize(2, 0.15, 0.2, 0.4)
            --proj:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
            --mod:GetEntityData(proj).noWallCollidePillar = true
            if i % 2 == 0 then
                proj.Scale = 1.6
                proj:AddProjectileFlags(ProjectileFlags.ACCELERATE)
                proj.Acceleration = 1.1
                proj.Velocity = proj.Velocity:Resized(3)
            end
            if entry.charmMode then
                proj:AddProjectileFlags(entry.charmMode)
            end
            proj.Color = color
        end
        local eff = Isaac.Spawn(1000, 16, 0, entry.pos, Vector.Zero, entry.npc):ToEffect()
        eff.SpriteScale = Vector(0.8, 1)
        eff.Color = Color(0.7, 1, 1, 1, 0, 0, 0)
        mod.colorRedDeathBurst[key] = nil
    end
end