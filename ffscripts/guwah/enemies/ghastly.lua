local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local bal = {
    chaseSpeed = 7,
    chaseLerp = 0.075,
    leaveTime = 10,
    shootIdle = 30,
    idleSpeed = 3.5,
    idleLerp = 0.15,
    shootCooldown = {120, 180},
    projSpeed = 10,
    slowFactor = 0.7,
    fadeDistance = 400,
    cloneAlpha = 0.3,
    maxCornerOffset = 40,
}

local params = ProjectileParams()
params.FallingAccelModifier = -0.1
params.BulletFlags = ProjectileFlags.GHOST
params.Variant = ProjectileVariant.PROJECTILE_TEAR

local function RandomizeHead(npc)
    local rng = npc:GetDropRNG()
    local sprite = npc:GetSprite()
    local sheet = "gfx/enemies/ghastly/monster_ghastly.png"
    if rng:RandomFloat() <= 0.5 then
        sheet = "gfx/enemies/ghastly/monster_ghastly_alt.png"
    end
    sprite.FlipX = (rng:RandomFloat() <= 0.5)
    sprite:ReplaceSpritesheet(0, sheet)
    sprite:LoadGraphics()
end

function mod:GetRoomCorners(avoidPlayer)
    local room = game:GetRoom()
    local corners = {room:GetTopLeftPos(), room:GetBottomRightPos(), Vector(room:GetBottomRightPos().X, room:GetTopLeftPos().Y), Vector(room:GetTopLeftPos().X, room:GetBottomRightPos().Y)}
    if avoidPlayer then
        for i, corner in pairs(corners) do
            if game:GetNearestPlayer(corner).Position:Distance(corner) < avoidPlayer then
                table.remove(corners, i)
            end
        end
    end
    return corners
end

local function GetTeleportPos(npc, targetpos)
    local room = game:GetRoom()
    local rng = npc:GetDropRNG()
    local cornerpos = mod:GetRandomElem(mod:GetRoomCorners(80), rng)
    if not cornerpos then
        cornerpos = mod:GetRandomElem(mod:GetRoomCorners(), rng)
    end
    return cornerpos + (RandomVector() * mod:RandomInt(0, bal.maxCornerOffset, rng))
end

local function GetMirrorPos(pos, mode)
    local center = game:GetRoom():GetCenterPos()
    local targetVec = pos - center
    if mode == 1 then
        targetVec = Vector(-targetVec.X, -targetVec.Y)
    elseif mode == 2 then
        targetVec = Vector(targetVec.X, -targetVec.Y)
    elseif mode == 3 then
        targetVec = Vector(-targetVec.X, targetVec.Y)
    end
    return center + targetVec
end

function mod:SetAlpha(sprite, alpha)
    local oldcolor = sprite.Color
    local color = Color.Lerp(oldcolor, Color.Default, 0) 
    color:SetTint(1,1,1,alpha)
    sprite.Color = color
end

function mod:GhastlyAI(npc, sprite, data)
    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position)
    local rng = npc:GetDropRNG()

    if not data.Init then
        if npc.SubType == 1 then
            mod:makeWaitFerr(npc, npc.Type, npc.Variant, 0, 40, false)
        else
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
            npc.StateFrame = math.floor(mod:RandomInt(bal.shootCooldown,rng)*0.66)
            npc.SplatColor = mod.ColorGhostly
            npc.SpriteOffset = Vector(0,-5)
            RandomizeHead(npc)
        
            local pickIdle
            local pickChase
            for _, ghastly in pairs(Isaac.FindByType(mod.FF.Ghastly.ID, mod.FF.Ghastly.Var)) do
                local gdata = mod:GetEntityData(ghastly)
                if gdata.State == "Chase" or gdata.NextState == "Chase" then
                    pickIdle = true
                elseif gdata.State == "Idle" or gdata.NextState == "Idle" then
                    pickChase = true
                end
            end
            if pickIdle and not pickChase then
                data.NextState = "Idle"
            elseif pickChase and not pickIdle then
                data.NextState = "Chase"
            else
                data.NextState = mod:GetRandomElem({"Chase", "Idle"}, rng)
            end

            if data.waited then
                npc.Visible = true
                data.State = "Appear"
                data.AppearThenLeave = true
            else
                data.State = "Leave"
            end
            data.Init = true
        end
    end

    if data.State == "Chase" then
        mod:spritePlay(sprite, "Move")
        mod:UnscareWhenOutOfRoom(npc)
        npc.Velocity = mod:Lerp(npc.Velocity, mod:reverseIfFear(npc, (targetpos - npc.Position):Resized(bal.chaseSpeed)), bal.chaseLerp)

        npc.StateFrame = npc.StateFrame - 1
        if npc.StateFrame <= 0 then
            data.State = "Leave"
            data.NextState = "Idle"
        end

    elseif data.State == "Leave" then
        npc.Velocity = npc.Velocity * bal.slowFactor
        if sprite:IsFinished("Leave") then
            npc.StateFrame = npc.StateFrame - 1
            if npc.StateFrame <= 0 then
                npc.Position = GetTeleportPos(npc, target.Position)
                RandomizeHead(npc)
                npc.Visible = true   
                data.State = "Appear"
                for i = 1, 3 do
                    local pos = GetMirrorPos(npc.Position, i)
                    local clone = Isaac.Spawn(mod.FF.GhastlyClone.ID,mod.FF.GhastlyClone.Var,mod.FF.GhastlyClone.Sub,pos,Vector.Zero,npc)
                    clone.Parent = npc
                    mod:GetEntityData(clone).MirrorMode = i
                    clone:Update()
                end
            else
                npc.Velocity = Vector.Zero   
                npc.Visible = false
            end
        elseif sprite:IsEventTriggered("Coll") then
            npc.StateFrame = bal.leaveTime
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
        else
            mod:spritePlay(sprite, "Leave")
        end

    elseif data.State == "Appear" then
        npc.Velocity = npc.Velocity * bal.slowFactor
        if sprite:IsFinished("Appear") then 
            if data.AppearThenLeave then
                data.State = "Leave"
                data.AppearThenLeave = false
            else
                if data.NextState == "Idle" then
                    npc.StateFrame = bal.shootIdle
                elseif data.NextState == "Chase" then
                    npc.StateFrame = mod:RandomInt(bal.shootCooldown,rng)
                end  
                data.State = data.NextState
            end
        elseif sprite:IsEventTriggered("Coll") then
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
            npc:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET)
        else
            mod:spritePlay(sprite, "Appear")
        end
    
    elseif data.State == "Idle" then
        mod:spritePlay(sprite, "Idle")
        mod:UnscareWhenOutOfRoom(npc)
        npc.Velocity = mod:Lerp(npc.Velocity, mod:reverseIfFear(npc, (targetpos - npc.Position):Resized(bal.idleSpeed)), bal.idleLerp)

        npc.StateFrame = npc.StateFrame - 1
        if npc.StateFrame <= 0 then
            data.State = "Shoot"
        end

    elseif data.State == "Shoot" then
        npc.Velocity = npc.Velocity * bal.slowFactor
        if sprite:IsFinished("Shoot") then 
            data.State = "Leave"
            data.NextState = "Chase"
        elseif sprite:IsEventTriggered("Shoot") then
            npc:FireProjectiles(npc.Position, (targetpos - npc.Position):Resized(bal.projSpeed), 0, params)
            mod:PlaySound(SoundEffect.SOUND_SHAKEY_KID_ROAR, npc)
            local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 5, npc.Position, Vector.Zero, npc)
            effect.SpriteOffset = Vector(0,-15)
            effect.DepthOffset = npc.Position.Y * 1.25
            effect.Color = mod.ColorGhostly
            effect:Update()
        else
            mod:spritePlay(sprite, "Shoot")
        end
    end
end

function mod:GhastlyRender(npc, sprite)
    local alpha = bal.cloneAlpha + ((1 - bal.cloneAlpha) * math.max(0, (bal.fadeDistance - npc:GetPlayerTarget().Position:Distance(npc.Position))/bal.fadeDistance))
    mod:SetAlpha(sprite, alpha)
end

function mod:GhastlyClone(effect, sprite, data)
    local rng = effect:GetDropRNG()

    if not data.Init then
        effect.SpriteOffset = Vector(0,-5)
        mod:SetAlpha(sprite, bal.cloneAlpha)
        RandomizeHead(effect)
        data.Init = true
    end

    if effect.Parent and not mod:IsReallyDead(effect.Parent) then
        local parent = effect.Parent:ToNPC()
        local psprite = parent:GetSprite()
        local pdata = mod:GetEntityData(parent)
        local targetpos = mod:confusePos(parent, parent:GetPlayerTarget().Position)
        sprite:SetFrame(psprite:GetAnimation(), psprite:GetFrame())
       
        if pdata.State == "Leave" then
            effect.Parent = nil
        else
            effect.TargetPosition = GetMirrorPos(parent.Position, data.MirrorMode)
            effect.Velocity = effect.TargetPosition - effect.Position
        end
    else
        effect.Velocity = effect.Velocity * bal.slowFactor
        if sprite:IsFinished("Leave") then
            effect:Remove()
        else
            mod:spritePlay(sprite, "Leave")
        end
    end
end