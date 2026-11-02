local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local bal = {
    MaskDist = 40,
    MaskDistFar = 75,
    MaskCheck = 5,
    MaskMaxCheck = 300,
    MaskRotate = 2,
    MaskRotateFast = 5,

    Idle = {10,55},
    IdleChance = 2,
    NormalSpeed = 3,
    ChargeSpeed = 5,
    ChargeMin = 60,
    ChargeTime = 100,
}

function mod:freeThinkerAI(npc)
    local sprite = npc:GetSprite()
    local d = mod:GetEntityData(npc)
    local target = npc:GetPlayerTarget()
    local rng = npc:GetDropRNG()

    if not d.init then
        d.MyThinkMasks = {}
        if npc.SubType > 2 then
            local rangle = 90
            for i=1,npc.SubType-2 do
                local pos = npc.Position+Vector(bal.MaskDist, 0):Rotated(rangle+i*360/(npc.SubType-2))
                local mask = Isaac.Spawn(mod.FF.FreeThinkerMask.ID, mod.FF.FreeThinkerMask.Var, mod.FF.FreeThinkerMask.Sub, pos, Vector.Zero, npc):ToNPC()
                mod:GetEntityData(mask).FreeThinkerAng = rangle+i*360/(npc.SubType-2)
                mask.Parent = npc
                mask:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                table.insert(d.MyThinkMasks, mask)
            end
        end
        d.MoveState = "Idle"
        d.State = "Idle"
        if npc.SubType == 1 then
            npc.SplatColor = Color(1, 1, 1, 0)
            d.FreeThinkerAng = d.FreeThinkerAng or rng:RandomInt(360)
            npc:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
            sprite:Stop()
            npc.SpriteOffset = Vector(0, -20)
            d.MaskDist = bal.MaskDist
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
        end
        d.ChargeFrames = 0
        d.init = true
    else
        d.ChargeFrames = d.ChargeFrames+1
        npc.StateFrame = npc.StateFrame+1
    end
    
    if npc.SubType == 1 then
        if not npc.Parent or not mod:superExists(npc.Parent) then
            npc:PlaySound(SoundEffect.SOUND_ROCK_CRUMBLE, 0.3, 0, false, mod:RandomInt(110,120,rng)/100)
            local cloud = Isaac.Spawn(1000, 59, 0, npc.Position, Vector.Zero, npc):ToEffect()
            cloud:SetTimeout(20)
            cloud.SpriteOffset = npc.SpriteOffset
            npc:Die()
        else
            local par = npc.Parent

            local targetPos = par.Position+Vector(d.MaskDist, 0):Rotated(d.FreeThinkerAng)
            npc.Velocity = mod:Lerp(npc.Velocity, (targetPos-npc.Position), 0.8)

            local spriteAngle = (360-d.FreeThinkerAng)+22.5+90
            spriteAngle = math.floor((spriteAngle % 360)/45)
            sprite:SetFrame("Mask", spriteAngle)

            if mod:GetEntityData(par).State == "Charge" then
                d.MaskDist = mod:Lerp(d.MaskDist, bal.MaskDistFar, 0.1)
                d.FreeThinkerAng = d.FreeThinkerAng+bal.MaskRotateFast
            else
                d.MaskDist = mod:Lerp(d.MaskDist, bal.MaskDist, 0.1)
                d.FreeThinkerAng = d.FreeThinkerAng+bal.MaskRotate
            end
        end
    else
        if d.State == "Idle" then
            if not mod:isScareOrConfuse(npc) and d.ChargeFrames > bal.ChargeMin then
                for key,mask in pairs(d.MyThinkMasks) do
                    if mod:superExists(mask) then
                        if mod:IsPosInBetweenBad(npc.Position, target.Position, mask.Position, bal.MaskCheck, 0) then
                            d.ChargeVec = (target.Position-npc.Position):Resized(bal.ChargeSpeed)
                            d.State = "Charge"
                            npc.StateFrame = 0
                        end
                    else
                        d.MyThinkMasks[key] = nil
                    end
                end
            end

            if not d.TargetPos or npc.Position:Distance(d.TargetPos) < 5 or npc.StateFrame > 60 or  npc:CollidesWithGrid() then
                if d.TargetPos and rng:RandomInt(bal.IdleChance) == 0 and npc.Position:Distance(d.TargetPos) < 5 then
                    d.IdlePos = mod:RandomInt(bal.Idle[1], bal.Idle[2], rng)
                end
                d.TargetPos = mod:FindRandomValidPathPosition(npc, 3, nil, 90)+mod:shuntedPosition(10, rng)
                npc.StateFrame = 0
            end

            if mod:isScare(npc) then
                local targetvel = (target.Position - npc.Position):Resized(-bal.ChargeSpeed)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvel, 0.2)
            elseif d.IdlePos then
                if d.IdlePos > 0 then
                    d.IdlePos = d.IdlePos-1
                    npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.1)
                else
                    d.IdlePos = nil
                    d.TargetPos = mod:FindRandomValidPathPosition(npc, 3, nil, 90)+mod:shuntedPosition(10, rng)
                    npc.StateFrame = 0
                end
            elseif d.TargetPos then
                local room = game:GetRoom()
                if room:CheckLine(npc.Position, d.TargetPos, 0, 1, false, false) then
                    local targetvel = (d.TargetPos - npc.Position):Resized(bal.NormalSpeed)
                    npc.Velocity = mod:Lerp(npc.Velocity, targetvel, 0.3)
                else
                    npc.Pathfinder:FindGridPath(d.TargetPos, bal.NormalSpeed/6.5, 900, true)
                end
            else
                npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.2)
            end
        elseif d.State == "Charge" then
            if npc:CollidesWithGrid() or npc.StateFrame > bal.ChargeTime then
                d.State = "Idle"
                d.ChargeFrames = 0
                d.TargetPos = mod:FindRandomValidPathPosition(npc, 3, nil, 90)+mod:shuntedPosition(10, rng)
                npc.StateFrame = 0
            end
            npc.Velocity = mod:Lerp(npc.Velocity, d.ChargeVec, 0.2)
        end

        if npc.Velocity:Length() < 1 then
            mod:spritePlay(sprite, "Idle")
        else
            npc.FlipX = npc.Velocity.X < 0
            if math.abs(npc.Velocity.X) > math.abs(npc.Velocity.Y) then
                mod:spritePlay(sprite, "WalkHori")
            else
                mod:spritePlay(sprite, "WalkVert")
            end
        end
        mod:spriteOverlayPlay(sprite, "HeadIdle")
    end
end

function mod:freeThinkerMaskHurt(npc, damage, flag, source)
    if npc.SubType == 1 then
        return false
    end
end