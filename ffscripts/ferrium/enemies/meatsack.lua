local mod = FiendFolio
local game = Game()

local bal = {
    IdleChance = 2,
    Idle = {20,55},
    FearDist = 70,
    FearTimer = 20,

    Speed = 3,

    LineCount = 5,
    LineSpeed = 17,
    LineSegments = {4,6},
    LineLifespan = {15, 40},
    LineVariance = 5,
    LineVel = -1.1,
    LineAccel = 0.05,
}

function mod:meatsackAI(npc)
    local sprite = npc:GetSprite()
    local target = npc:GetPlayerTarget()
    local d = mod:GetEntityData(npc)
    local rng = npc:GetDropRNG()
    
    if not d.init then
        npc:AddEntityFlags(EntityFlag.FLAG_EXTRA_GORE)
        d.State = "Idle"
        d.FearTimer = 0
        d.init = true
    else
        npc.StateFrame = npc.StateFrame+1
    end

    if d.State == "Idle" then

        if not d.TargetPos or npc.Position:Distance(d.TargetPos) < 5 or npc.StateFrame > 60 or  npc:CollidesWithGrid() then
            if d.TargetPos and rng:RandomInt(bal.IdleChance) == 0 and npc.Position:Distance(d.TargetPos) < 5 then
                d.IdlePos = mod:RandomInt(bal.Idle[1], bal.Idle[2], rng)
            end
            d.TargetPos = mod:FindRandomValidPathPosition(npc, 3, nil, 90)+mod:shuntedPosition(10, rng)
            npc.StateFrame = 0
        end

        if npc.Position:Distance(target.Position) < bal.FearDist then
            d.FearTimer = bal.FearTimer
        end

        if mod:isScare(npc) or d.FearTimer > 0 then
            if d.FearTimer > 0 then
                d.FearTimer = d.FearTimer-1
            end
            local targetvel = (target.Position - npc.Position):Resized(-bal.Speed*1.1)
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
                local targetvel = (d.TargetPos - npc.Position):Resized(bal.Speed)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvel, 0.3)
            else
                npc.Pathfinder:FindGridPath(d.TargetPos, bal.Speed/6.5, 900, true)
            end
        else
            npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.2)
        end
        
        if npc.Velocity:Length() > 1 then
            if math.abs(npc.Velocity.X) > math.abs(npc.Velocity.Y) then
                mod:spritePlay(sprite, "WalkHori")
            else
                mod:spritePlay(sprite, "WalkVert")
            end
        else
            mod:spritePlay(sprite, "Idle")
        end
        npc.FlipX = npc.Velocity.X < 0
    elseif d.State == "Burst" then
        if sprite:IsFinished("Burst") then
            local ang = (target.Position-npc.Position):GetAngleDegrees()
            local lineFunc = function(v, tab)
                tab.frames = tab.frames+1
                local offset = math.sin(tab.frames/4)*tab.offset
                local targetpos = v.Position+tab.original:Resized(30)+tab.original:Rotated(90):Resized(offset)
                if tab.offset > 0 then
                    tab.offset = tab.offset-0.5
                end
                v.Velocity = (targetpos-v.Position):Resized(tab.speed)
                if tab.speed > 0 then
                    tab.speed = math.max(0.05, tab.speed+tab.vel)
                    if tab.vel < -0.03 then
                        tab.vel = math.min(-0.03, tab.vel+tab.accel)
                    end
                end
            end

            local params = ProjectileParams()
            params.HeightModifier = -20
            params.FallingAccelModifier = 0.5
            for i=1,bal.LineCount do
                local myAng
                if i > 1 then
                    myAng = ang+mod:RandomInt(-45, 45, rng)+360/bal.LineCount*i
                else
                    myAng = ang+mod:RandomInt(-5, 5, rng)
                end

                local count = (i == 1 and bal.LineSegments[2]) or mod:RandomInt(bal.LineSegments[1], bal.LineSegments[2], rng)
                params.FallingSpeedModifier = mod:RandomInt(-3,0,rng)
                local dir = -2*rng:RandomInt(2)+1
                local offset = mod:RandomInt(20, 45, rng)*dir
                for j=1,count do
                    local speed = bal.LineSpeed
                    local vel = bal.LineVel
                    local accel = bal.LineAccel-0.005
                    for k=1,j*2 do
                        speed = speed+vel
                        vel = math.min(-0.03, vel+accel)
                    end
                    mod.scheduleForUpdate(function()
                        params.Scale = 1.5-0.2*j
                        params.TargetPosition = Vector(vel, speed)
                        local proj = npc:FireProjectilesEx(npc.Position, Vector(speed, 0):Rotated(myAng), 0, params)[1]
                        local d1 = mod:GetEntityData(proj)
                        d1.projType = "customProjectileBehavior"
                        d1.customProjectileBehavior = {update = lineFunc, frames = 2*math.pi, accel = bal.LineAccel, vel = proj.TargetPosition.X,
                            angle = 9, speed = proj.TargetPosition.Y, offset = offset, original = proj.Velocity}
                    end, j*2)
                end
            end

            local spawn = Isaac.Spawn(d.MeatsackTarget[1], d.MeatsackTarget[2], d.MeatsackTarget[3], npc.Position, Vector.Zero, npc):ToNPC()

            local poof = Isaac.Spawn(1000, EffectVariant.POOF02, 3, npc.Position, Vector.Zero, npc):ToEffect()
            local poof2 = Isaac.Spawn(1000, EffectVariant.POOF02, 4, npc.Position, Vector.Zero, npc):ToEffect()
            for i=1,4 do
                local randVel = RandomVector()*mod:getRoll(10,30,rng)/20
                local cloud = Isaac.Spawn(1000, 59, 0, npc.Position, Vector.Zero, nil):ToEffect()
                cloud:SetTimeout(mod:getRoll(100,150,rng))
                local color = Color(0.45,0,0,0,0,0,0)
                cloud.Color = color
                local randScale = mod:getRoll(80,150,rng)/100
                cloud.SpriteScale = Vector(0.5, 0.5)
                mod:GetEntityData(cloud).cosmeticDust = {scale = randScale, vel = randVel, alpha = 0.5}
            end

            d.State = "Idle"
            npc:Kill()
        else
            mod:spritePlay(sprite, "Burst")
        end

        npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.2)
    end
end

function mod:meatsackOnEnemyDeath(entity)
    if not mod:isEmpathBlacklisted(entity) and not (entity.Type == mod.FF.Meatsack.ID and entity.Variant == mod.FF.Meatsack.Var) and not (entity.Type == EntityType.ENTITY_GEMINI and entity.Variant == 12) and not mod:GetEntityData(entity).FFIsDeathAnimation
    and entity.Type ~= mod.FFID.Tech and not mod:isSegmented(entity) then
        local sacks = {}
        for _,sack in ipairs(Isaac.FindByType(mod.FF.Meatsack.ID, mod.FF.Meatsack.Var, -1, false, false)) do
            if not (sack:IsDead() or sack:HasMortalDamage()) then
                table.insert(sacks, sack)
            end
        end
        if #sacks > 0 then
            local rng = entity:GetDropRNG()
            local npc = sacks[rng:RandomInt(#sacks)+1]
            mod:GetEntityData(npc).State = "Burst"
            mod:GetEntityData(npc).MeatsackTarget = {entity.Type, entity.Variant, entity.SubType}
        end
    end
end