local mod = FiendFolio
local game = Game()

function mod:jugularAI(npc)
    local sprite = npc:GetSprite()
    local d = mod:GetEntityData(npc)
    local target = npc:GetPlayerTarget()
    local targetpos = mod:randomConfuse(npc, target.Position)
    local player = target:ToPlayer()
    local rng = npc:GetDropRNG()
    mod:beelzebubCheck(npc)


    if not d.init then
        if d.dead then
            d.state = "Dead"
        else
            d.state = "Idle"
            mod:AddSoundmakerFly(npc)
        end
        local targDir = (targetpos-npc.Position)
        if targDir.X > 0 then
            d.moveDir = "Right"
        else
            d.moveDir = "Left"
        end
        d.wahooDir = Vector.Zero
        d.turnTimer = 0
        d.init = true
    else
        npc.StateFrame = npc.StateFrame+1
    end

    if d.state == "Idle" then
        if player and not mod:isScareOrConfuse(npc) then
            local aim = mod.GetCorrectedFiringInput(player)
            if aim:Length() > 0 then
            else
                aim = nil
            end

			if aim then
                local dist = npc.Position:Distance(targetpos)
                targetpos = targetpos+aim:Resized(math.max(0, dist-8))
                d.wahooDir = mod:Lerp(d.wahooDir, aim:Resized(1), 0.1)
            else
                d.wahooDir = mod:Lerp(d.wahooDir, Vector.Zero, 0.12)
            end
        end

        if mod:isScare(npc) then
            local vel = (npc.Position-targetpos):Resized(4)+d.wahooDir
            if vel:Length() > 8 then
                vel = vel:Resized(8)
            end
            npc.Velocity = mod:Lerp(npc.Velocity, vel, 0.3)
        else
            local vel = (targetpos-npc.Position):Resized(3)+d.wahooDir
            if vel:Length() > 8 then
                vel = vel:Resized(8)
            end
            npc.Velocity = mod:Lerp(npc.Velocity, vel, 0.3)
        end

        local targVel = (target.Position-npc.Position)
        if d.moveDir == "Right" then
            if d.turnTransition then
                if sprite:IsFinished("FlyTurnLR") then
                    d.turnTransition = nil
                    npc.StateFrame = 0
                else
                    mod:spritePlay(sprite, "FlyTurnLR")
                end
            else
                if targVel.X < 0 then
                    if d.turnTimer > 0 then
                        d.turnTimer = d.turnTimer-1
                    else
                        d.moveDir = "Left"
                        d.turnTransition = true
                    end
                else
                    d.turnTimer = 2
                end
                mod:spritePlay(sprite, "FlyRight")
            end
        else
            if d.turnTransition then
                if sprite:IsFinished("FlyTurnRL") then
                    d.turnTransition = nil
                    npc.StateFrame = 0
                else
                    mod:spritePlay(sprite, "FlyTurnRL")
                end
            else
                if targVel.X > 0 then
                    if d.turnTimer > 0 then
                        d.turnTimer = d.turnTimer-1
                    else
                        d.moveDir = "Right"
                        d.turnTransition = true
                    end
                else
                    d.turnTimer = 4
                end
                mod:spritePlay(sprite, "FlyLeft")
            end
        end
    elseif d.state == "Dead" then
        if sprite:IsFinished("Death") then
            npc:PlaySound(SoundEffect.SOUND_DEATH_BURST_LARGE, 1, 0, false, 1)
            npc:Kill()
        elseif sprite:IsEventTriggered("Land") then
            npc:PlaySound(SoundEffect.SOUND_BONE_BREAK, 1, 0, false, mod:getRoll(95,105,rng)/100)
        elseif sprite:IsEventTriggered("Sploosh") then
            npc:PlaySound(SoundEffect.SOUND_SINK_DRAIN_GURGLE, 1, 0, false, 1)
            npc:PlaySound(SoundEffect.SOUND_HEARTIN, 1, 0, false, 1)
            d.splatFrames = 0
            d.splooshing = true
        elseif sprite:IsEventTriggered("End") then
            d.splooshing = nil
        elseif sprite:IsEventTriggered("Sound") then
            npc:PlaySound(SoundEffect.SOUND_SCAMPER, 1, 0, false, mod:getRoll(90,110,rng)/100)
            table.insert(mod.jugularRain, {target = target, friend = mod:isFriend(npc), rng = rng, source = npc})
        else
            mod:spritePlay(sprite, "Death")
        end

        if d.splooshing then
            d.splatFrames = d.splatFrames+1
            local params = ProjectileParams()
            params.FallingAccelModifier = -2
            params.BulletFlags = ProjectileFlags.NO_WALL_COLLIDE | ProjectileFlags.CANT_HIT_PLAYER
            params.HeightModifier = -140
            mod:SetGatheredProjectiles()
            for i=1,2 do
                params.FallingSpeedModifier = -mod:getRoll(60,100,rng)
                params.Scale = mod:getRoll(50,110,rng)/100
                npc:FireProjectiles(npc.Position, (target.Position-npc.Position):Resized(3.4)+RandomVector(), 0, params)
            end
            for _, proj in pairs(mod:GetGatheredProjectiles()) do
                local pd = mod:GetEntityData(proj)
                pd.customProjectileBehavior = {update = function()
                    if proj.FrameCount > 5 then
                        proj.Color = Color(1, 1, 1, math.max((30-proj.FrameCount)/25, 0), 0, 0, 0)

                        if proj.FrameCount > 30 then
                            proj:Remove()
                        elseif proj.FrameCount > 22 then
                            if proj.Scale > 0.2 then
                                proj.Scale = proj.Scale-0.05
                            end
                        else
                            if proj.Scale > 0.6 then
                                proj.Scale = proj.Scale-0.02
                            end
                        end

                        --[[if target and target:Exists() then
                            proj.Velocity = mod:Lerp(proj.Velocity, (target.Position-proj.Position):Resized(3.4), 0.08)
                        end]]
                    end
                end}
                pd.projType = "customProjectileBehavior"
                proj.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
                proj.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            end

            if npc.FrameCount % 3 == 0 then
                npc:PlaySound(SoundEffect.SOUND_BOSS2_BUBBLES, 0.4, 0, false, mod:getRoll(90,110,rng)/100)
                local splatter = Isaac.Spawn(1000, EffectVariant.BLOOD_SPLAT, 0, npc.Position+mod:shuntedPosition(47, rng), Vector.Zero, npc):ToEffect()
                splatter.Scale = 0.5
                splatter:Update()
                local splat = Isaac.Spawn(1000, EffectVariant.BLOOD_DROP, 0, npc.Position, (target.Position-npc.Position):Resized(d.splatFrames*0.2+mod:getRoll(30,55,rng)/10):Rotated(mod:getRoll(-30,30,rng)), npc):ToEffect()
                splat.FallingSpeed = -mod:getRoll(6,10,rng)
                splat.PositionOffset = Vector(0, -47-npc.StateFrame)
                splat:Update()
                d.splatPosition = splat.Position

                local poof = Isaac.Spawn(1000, EffectVariant.POOF04, 160, npc.Position, Vector.Zero, npc):ToEffect()
                poof.SpriteOffset = Vector(0, -47-npc.StateFrame)
                poof.DepthOffset = 500
            end
        end

        npc.Velocity = Vector.Zero
    end
end

function mod.jugularDeathAnim(npc)
	local onCustomDeath = function(npc, deathAnim)
		mod:GetEntityData(deathAnim).dead = true
	end
	mod.genericCustomDeathAnim(npc, "Death", false, onCustomDeath, false, false)
end

function mod:jugularRainEffect(entry, key)
    if not entry.init then
        entry.init = true
        entry.frames = 0
        entry.firstFallVal = 1
        if Isaac.GetChallenge() == mod.challenges.dirtyBubble then
            mod.jugularRain[key] = nil
            return
        end
    end
    if entry.target and mod:superExists(entry.target) then
        entry.frames = entry.frames+1
        local target = entry.target
        local rng = entry.rng
        if entry.frames % entry.firstFallVal == 0 then
            local proj = Isaac.Spawn(mod.FF.SilentBloodProj.ID, mod.FF.SilentBloodProj.Var, mod.FF.SilentBloodProj.Sub, target.Position, Vector(0,mod:getRoll(2,12,rng)/15):Rotated(rng:RandomInt(360))+target.Velocity*0.4, entry.source):ToProjectile()
            if entry.friend then
                proj:AddProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER | ProjectileFlags.HIT_ENEMIES)
            end
            proj.Height = -600
            proj.FallingSpeed = 20
            proj.FallingAccel = 2
            local num = mod:getRoll(50,120,rng)/100
            proj.Scale = 0.15
            mod:GetEntityData(proj).customProjectileBehavior = {update = function()
                if proj.Scale < num then
                    proj.Scale = proj.Scale+0.03
                else
                    mod:GetEntityData(proj).customProjectileBehavior = nil
                end
            end}
            mod:GetEntityData(proj).projType = "customProjectileBehavior"
            mod:GetEntityData(proj).customProjSound = {SoundEffect.SOUND_SPLATTER, 0.25, mod:getRoll(90,110,rng)/100}
        end

        if entry.frames < 90 and entry.frames % 15 == 0 then
            entry.firstFallVal = entry.firstFallVal+1
        elseif (game:GetRoom():IsClear() or not mod.IsActiveRoom()) and entry.frames > 50 then
            mod.jugularRain[key] = nil
        end
    else
        mod.jugularRain[key] = nil
    end
end