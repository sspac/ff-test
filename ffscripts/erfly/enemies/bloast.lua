local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

--Mostly made by Erf but Catinsurance helped finish and polish 'em up! Thank you!

function mod:bloastUpdate(npc)
    local sprite, d = npc:GetSprite(), mod:GetEntityData(npc)
    local target = npc:GetPlayerTarget()
    local rng = npc:GetDropRNG()

    if not d.init then
        d.init = true
        d.state = "idle"
        d.NumberOfEyes = 2
        d.Intellect = 76
        d.FavouriteMovie = "Air Bud"
        d.BloodType = "AB+"
    else
        npc.StateFrame = npc.StateFrame + 1
    end
    if d.state == "idle" then
        npc.Velocity = npc.Velocity * 0.7
        if not sprite:IsPlaying("Blink") then
            mod:spritePlay(sprite, "Idle")
            if rng:RandomInt(30) == 1 then
                mod:spritePlay(sprite, "Blink")
            end
        end
        if (npc.StateFrame > 30 and rng:RandomInt(5) == 1) or npc.StateFrame > 40 then
            d.state = "jump"
            d.sState = nil
        end
    elseif d.state == "jump" then
        if not d.sState then
            npc.Velocity = npc.Velocity * 0.7
            if sprite:IsEventTriggered("Jump") or sprite:IsFinished("Jump") then
                npc:PlaySound(SoundEffect.SOUND_SHELLGAME, 1, 0, false, 0.7)
                d.sState = "inAir"
                npc.StateFrame = 0
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

                local checkPos = (target.Position-npc.Position)
                if mod:isScare(npc) then
                    checkPos = (npc.Position-target.Position)
                elseif mod:isConfuse(npc) then
                    checkPos = (mod:FindRandomFreePos(npc, 200, nil, true)-npc.Position)
                end
                if checkPos:Length() > 300 then
                    checkPos = checkPos:Resized(300)
                end

                local room = game:GetRoom()
                d.targetPos = room:FindFreeTilePosition(npc.Position+checkPos, 40) + (RandomVector())
                d.targetPos = room:GetClampedPosition(d.targetPos, npc.Size)
            else
                mod:spritePlay(sprite, "Jump")
            end
        elseif d.sState == "inAir" then
            local vel = Vector.Zero
            local dist = (npc.Position - d.targetPos):Length()
            if dist < 40 or npc.StateFrame > 120 then
                vel = Vector.Zero
                d.state = "land"
            elseif dist < 80 then
                vel = (d.targetPos - npc.Position):Resized(2)
            else
                vel = vel + (d.targetPos-npc.Position):Resized(dist / 65)
                if vel:Length() > dist then
                    vel = vel:Resized(dist)
                end
            end
            npc.Velocity = mod:Lerp(npc.Velocity, npc.Velocity+vel, 0.3)
    end
    elseif d.state == "land" then
        npc.Velocity = npc.Velocity * 0.5
        if sprite:IsFinished("Land") then
            d.state = "idleVuln"
            npc.StateFrame = 0
        elseif sprite:IsEventTriggered("Jump") then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            game:MakeShockwave(npc.Position, 0.035, 0.025, 5)
            npc:PlaySound(SoundEffect.SOUND_FORESTBOSS_STOMPS,1,0,false,0.75)
            --Break grids
            mod:DestroyNearbyGrid(npc, 80)
            --Creep
            local scale = 3 - (math.abs(d.NumberOfEyes - 2) * 0.5) -- 0.8 less scale from 3 for each eye lost
            local creep = Isaac.Spawn(1000, 22, 0, npc.Position, Vector.Zero, npc)
            creep.SpriteScale = creep.SpriteScale * scale
            for i = 1, 3 do
                local creep = Isaac.Spawn(1000, 22, 0, npc.Position + RandomVector():Resized(50), Vector.Zero, npc)
                creep.SpriteScale = creep.SpriteScale * (scale - 1)
            end
            --Splatter
            local speed = 9 - (math.abs(d.NumberOfEyes - 2) * 1.5) -- 1.5 less scale from 9 for each eye lost
            local params = ProjectileParams()
            for i = 30, 360, 30 do
                local rand = rng:RandomFloat()
                params.FallingSpeedModifier = -1 * (math.random(5, 20) + math.random());
                params.FallingAccelModifier = 2
                params.VelocityMulti = 0.65 + mod:RandomInt(0,4) * 0.2
                params.Scale = 1 + (rng:RandomFloat() * 0.5)
                npc:FireProjectiles(npc.Position, Vector(0,speed):Rotated(i-40+rand*80) + Vector.Zero, 0, params)
            end
            -- blood poof
            local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 1, npc.Position, Vector.Zero, npc)
            poof.Color = Color(1, 1, 1, 1, 0, 0, 0, 1, 0.15, 0.15, 1)
            poof.DepthOffset = 5
            poof.SpriteScale = Vector.One * 1.5
        elseif sprite:IsEventTriggered("Expose") then
            d.isVulnerable = true
        elseif sprite:IsEventTriggered("Shoot") then
            local speed = 10 - (math.abs(d.NumberOfEyes - 2) * 1.5) -- 2.5 less scale from 12 for each eye lost
            d.shooting = true
            d.shootOff = (target.Position - npc.Position):Resized(speed)
            d.shotScale = 1.5
            npc.StateFrame = 0
            npc:PlaySound(SoundEffect.SOUND_BEAST_LAVA_BALL_SPLASH,1,0,false,1)
            npc:PlaySound(SoundEffect.SOUND_HEARTOUT,1,0,false,1)
        elseif sprite:IsEventTriggered("Sound") then
            npc:PlaySound(SoundEffect.SOUND_ANIMAL_SQUISH,1,0,false,0.75)
            d.shooting = nil
        else
            mod:spritePlay(sprite, "Land")
        end
        if d.shooting and npc.StateFrame % 3 == 0 then
            local params = ProjectileParams()
            params.BulletFlags = ProjectileFlags.MEGA_WIGGLE
            params.Scale = 0.5 + d.shotScale
            for i = 36, 360, 36 do
                local vec = d.shootOff:Rotated(i)
			    npc:FireProjectiles(npc.Position + vec:Resized(25), vec, 0, params)
                local smoke = Isaac.Spawn(1000, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, npc.Position + vec, vec:Resized(math.random(3,7)), npc)
                local alpha = math.max(0.3, d.shotScale/3)
                smoke.Color = Color(1,1,1,alpha,1,0,0)
                smoke.SpriteOffset = Vector(0, -15) + npc.SpriteOffset
                smoke.SpriteScale = smoke.SpriteScale * math.random(70,100)/100
                smoke:Update()
            end
            d.shotScale = d.shotScale * 0.75
        end
    elseif d.state == "idleVuln" then
        npc.Velocity = npc.Velocity * 0.5
        if not sprite:IsPlaying("Vulnerableblink") then
            mod:spritePlay(sprite, "Vulnerable")
            if rng:RandomInt(30) == 1 then
                mod:spritePlay(sprite, "Vulnerableblink")
            end
        end
        if npc.StateFrame > 20 then
            if d.NumberOfEyes == 2 and npc.HitPoints <= (npc.MaxHitPoints * 0.8)
            or d.NumberOfEyes == 1 and npc.HitPoints <= (npc.MaxHitPoints * 0.6) then
                d.state = "fireEye"
            elseif rng:RandomInt(5) == 1 or npc.StateFrame > 30 then
                d.state = "hide"
                --d.state = "fireEye"
            end
        end
    elseif d.state == "hide" then
        npc.Velocity = npc.Velocity * 0.5
        if sprite:IsFinished("Hide") then
            d.state = "idle"
            npc.StateFrame = rng:RandomInt(20)
        elseif sprite:IsEventTriggered("Sound") then
        elseif sprite:IsEventTriggered("Sound2") then
            npc:PlaySound(mod.Sounds.StretchEye,0.8,0,false,1.5)
        elseif sprite:IsEventTriggered("Hide") then
            d.isVulnerable = false
            sfx:Stop(mod.Sounds.StretchEye)
            npc:PlaySound(SoundEffect.SOUND_MEATHEADSHOOT,1,0,false,0.8)
        else
            mod:spritePlay(sprite, "Hide")
        end
    elseif d.state == "fireEye" then
        npc.Velocity = npc.Velocity * 0.5
        if sprite:IsFinished("LoseEye") then
            d.state = "hide"
        elseif sprite:IsEventTriggered("LoseEye") then
            local sheet
            if d.NumberOfEyes == 2 then
                sheet = "Bloastskulloneeye"
            else
                sheet = "Bloastskullnoeye"
            end
            sprite:ReplaceSpritesheet(1, "gfx/enemies/bloast/" .. sheet .. ".png")
			sprite:LoadGraphics()
            d.NumberOfEyes = d.NumberOfEyes - 1
            npc:PlaySound(SoundEffect.SOUND_GOOATTACH0, 1, 0, false, 0.8)
            npc:PlaySound(SoundEffect.SOUND_MEAT_JUMPS, 0.75, 0, false, 1)
            npc:PlaySound(SoundEffect.SOUND_FRAIL_CHARGE, 0.65, 0, false, 1.25)

            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0, npc.Position - Vector(0, 35), Vector.Zero, npc)
        elseif sprite:IsEventTriggered("Sound") then
            npc:PlaySound(SoundEffect.SOUND_GOOATTACH0, 1, 0, false, 0.6)
            npc:PlaySound(SoundEffect.SOUND_MEAT_JUMPS, 0.75, 0, false, 1)
        elseif sprite:IsEventTriggered("Shoot") then
            local playerRel = (target.Position - npc.Position)
            local xNess, yNess = math.max(math.min(1,playerRel.X), -1), math.max(math.min(1,playerRel.Y), -1)
            local ang
            if math.abs(playerRel.X) > math.abs(playerRel.Y) or playerRel.Y < 0 then
                if xNess > 0 then
                    ang = 0
                else
                    ang = 180
                end
            else
                ang = 90
            end
            local brimmy = EntityLaser.ShootAngle(1, npc.Position, ang, 10, Vector(0, -35), npc)
            brimmy.DepthOffset = 10
            brimmy:Update()

            local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0, npc.Position - Vector(0, 35), Vector.Zero, npc)
            poof.DepthOffset = 15
            poof.SpriteScale = Vector.One * 1.5

            local fireVec = Vector(15,0):Rotated(ang)
            local eye = Isaac.Spawn(mod.FF.BloastEye.ID, mod.FF.BloastEye.Var, 0, npc.Position, fireVec + Vector(xNess * 0.1,yNess * 0.1), npc)
            eye.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
            eye:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            eye.Parent = npc
            eye:Update()
        elseif sprite:IsEventTriggered("Sound2") then
        else
            mod:spritePlay(sprite, "LoseEye")
        end
    end

    if d.isVulnerable then
		if npc:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) then
			npc:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS)
		end
	else
        if not npc:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) then
			npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS)
		end
	end
end

function mod:bloastHurt(npc)
    local d = mod:GetEntityData(npc)
    if not d.isVulnerable then
        return false
    end
end

local bloastEyeAngs = {
    {-30, 30, 30},
    {-20, 20, 40},
}

function mod:bloastEyeUpdate(npc)
    local sprite, d = npc:GetSprite(), mod:GetEntityData(npc)
    local target = npc:GetPlayerTarget()
    local rng = npc:GetDropRNG()

    npc.StateFrame = npc.StateFrame + 1

    npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS)

    if npc.FrameCount == 10 then
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
    end

    local movespeed = 3.2

    if d.shooting then
        movespeed = 1.8
        if sprite:IsFinished("Shoot") then
            d.shooting = nil
            npc.StateFrame = 0
        elseif sprite:IsEventTriggered("Shoot") then
            npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT, 1, 0, false, 1)
            local shootChoice = bloastEyeAngs[rng:RandomInt(#bloastEyeAngs) + 1]
            local targVec = (target.Position - npc.Position):Resized(8)
            local params = ProjectileParams()
            params.FallingSpeedModifier = -0.1
            params.FallingAccelModifier = -0.1
            for i = shootChoice[1], shootChoice[2], shootChoice[3] do
                npc:FireProjectiles(npc.Position, targVec:Rotated(i), 0, params)
            end
            local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 2, npc.Position, Vector.Zero, npc)
            poof.SpriteOffset = Vector(0,-10)
            poof.DepthOffset = 40
        else
            mod:spritePlay(sprite, "Shoot")
        end
    else
        mod:spritePlay(sprite, "Idle")
        if npc.StateFrame > 30 and rng:RandomInt(5) == 1 then
            local room = game:GetRoom()
            if room:CheckLine(npc.Position,target.Position,0,1,false,false) then
                if target.Position:Distance(npc.Position) < 300 then
                    d.shooting = true
                end
            end
        end
    end

    local targVec = mod:diagonalMove(npc, movespeed, true)

    npc.Velocity = mod:Lerp(npc.Velocity, targVec, math.min(0.5, npc.FrameCount / 50))

    if not (npc.Parent and not mod:isStatusCorpse(npc.Parent)) then
        npc:Kill()
    end
end