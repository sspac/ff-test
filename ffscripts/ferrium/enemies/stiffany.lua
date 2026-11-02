local mod = FiendFolio
local game = Game()

local stiffBal = {
    shotFreq = 20,
    chargeStart = 25,
    chargeSpeed = 4.5,
    shootSpeed = 5.5,
}

local vecToDir = {
    [0] = "Right",
    [90] = "Down",
    [180] = "Left",
    [270] = "Up",
}

function mod:stiffanyAI(npc, sprite, d)
    local target = npc:GetPlayerTarget()
    local rng = npc:GetDropRNG()
    local room = game:GetRoom()
    if not d.init then
        npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
        if npc.SubType > 0 then
            d.stiffanyAngle = (npc.SubType-1)*90
        else
            d.stiffanyAngle = rng:RandomInt(4)*90
        end
        d.myDir = vecToDir[d.stiffanyAngle]
        sprite:Play("Appear" .. d.myDir, true)
        d.stiffStateFrame = 0
        d.semiState = "Idle"
        d.init = true
    else
        d.stiffStateFrame = d.stiffStateFrame+1
    end

    if d.semiState == "Idle" then
        if d.stiffStateFrame > stiffBal.shotFreq then
            d.semiState = "Shoot"
            d.stiffanyShot = nil
        end
        mod:spriteOverlayPlay(sprite, "Head" .. d.myDir)
    elseif d.semiState == "Shoot" then
        if sprite:IsOverlayFinished("Shoot" .. d.myDir) then
            d.semiState = "Idle"
            d.stiffStateFrame = 0
        elseif sprite:GetOverlayFrame() == 5 and not d.stiffanyShot then
            npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT, 1, 0, false, mod:RandomInt(90,110,rng)/100)
            d.stiffanyShot = true
            local params = ProjectileParams()
			params.FallingSpeedModifier = 0
			params.FallingAccelModifier = -0.16
			--params.HeightModifier = 20
			params.Scale = mod:RandomInt(95,150,rng)/100
            local color = Color(1, 0.8, 0.7, 1)
            color:SetColorize(4.2, 1.3, 1.2, 1)
            params.Color = color
            local bonusVel = npc.Velocity*0.2
            if math.abs(npc.Velocity.X) > math.abs(npc.Velocity.Y) then
                if npc.Velocity.X > 0 then
                    if d.myDir == "Left" then
                        bonusVel = bonusVel+Vector(npc.Velocity.X/2, 0)
                    end
                else
                    if d.myDir == "Right" then
                        bonusVel = bonusVel+Vector(npc.Velocity.X/2, 0)
                    end
                end
            else
                if npc.Velocity.Y > 0 then
                    if d.myDir == "Up" then
                        bonusVel = bonusVel+Vector(0, npc.Velocity.Y/2)
                    end
                else
                    if d.myDir == "Down" then
                        bonusVel = bonusVel+Vector(0, npc.Velocity.Y/2)
                    end
                end
            end
            npc:FireProjectiles(npc.Position+Vector(14,0):Rotated(d.stiffanyAngle+180), Vector(5.5, 0):Rotated(d.stiffanyAngle+180)+bonusVel, 0, params)

            local splat = Isaac.Spawn(1000, EffectVariant.BLOOD_EXPLOSION, 100, npc.Position+Vector(19,0):Rotated(d.stiffanyAngle+180), Vector.Zero, npc):ToEffect()
            splat.SpriteOffset = Vector(0,-16)*npc.SpriteScale.Y
            splat.DepthOffset = 30
            splat.Color = Color(1, 1, 1, 0.55, 0.1, 0.1, 0.1)
            splat:FollowParent(npc)
        else
            mod:spriteOverlayPlay(sprite, "Shoot" .. d.myDir)
        end
    end

    if npc.State == 4 then
        if npc.StateFrame > stiffBal.chargeStart and target.Position:Distance(npc.Position) < 250 and not mod:isScareOrConfuse(npc) and room:CheckLine(npc.Position, target.Position, 1) then
            local xAxis = math.abs(npc.Position.X - target.Position.X) < 30
            local yAxis = math.abs(npc.Position.Y - target.Position.Y) < 30
            local lookAngle = Vector(stiffBal.chargeSpeed,0):Rotated(d.stiffanyAngle)
            local difference = mod:GetAngleDifference((target.Position-npc.Position), lookAngle)

            if difference < 45 and (xAxis or yAxis) then
                npc.State = 10
				d.charge = lookAngle
                npc.Mass = 60
			elseif difference > 315 and (xAxis or yAxis) then
				npc.State = 10
				d.charge = lookAngle
                npc.Mass = 60
			end
        end
    elseif npc.State == 10 then
        npc.Velocity = mod:Lerp(npc.Velocity, d.charge or Vector.Zero, 0.3)
        if npc:CollidesWithGrid() then
            npc.State = 4
            npc.StateFrame = 0
            npc.Mass = 15
        end
    end

    npc.FlipX = false
    if npc.Velocity:Length() > 0.1 then
        if math.abs(npc.Velocity.X) > math.abs(npc.Velocity.Y) then
            if npc.Velocity.X > 0 then
                mod:spritePlay(sprite, "WalkRight")
            else
                mod:spritePlay(sprite, "WalkLeft")
            end
        else
            mod:spritePlay(sprite, "WalkVert")
        end
    else
        mod:spritePlay(sprite, "Idle")
    end
end

function mod:stiffanyHurt(npc, damage, flag, source)
    local data = mod:GetEntityData(npc)
    if data.stiffanyAngle and mod:KnightDamageBlocking(npc, source, -Vector.FromAngle(data.stiffanyAngle)) then
        return false
    end
    --[[if source and source.Entity and source.Entity.Type == 2 then
        local tear = source.Entity:ToTear()
        if tear and not tear:HasTearFlags(TearFlags.TEAR_PIERCING) then
            local d = mod:GetEntityData(npc)
            if not d.stiffanyAngle then
                if npc.SubType > 0 then
                    d.stiffanyAngle = (npc.SubType-1)*90
                else
                    d.stiffanyAngle = npc:GetDropRNG():RandomInt(4)*90
                end
            end
            local lookAngle = Vector(1,0):Rotated(d.stiffanyAngle)
            local difference = mod:GetAngleDifference((tear.Position-npc.Position), lookAngle)
            if difference < 90 then
                return false
			elseif difference > 270 then
                return false
			end
        end
    end]]
end