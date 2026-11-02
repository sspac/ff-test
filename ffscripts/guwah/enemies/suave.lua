local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local bal = {
    moveSpeed = 3,
    moveLerp = 0.1,
    wanderRadius = {20, 90},
    projSpeed = 11,
}

local params = ProjectileParams()
params.Variant = ProjectileVariant.PROJECTILE_TEAR
params.BulletFlags = ProjectileFlags.GHOST
params.Scale = 0.5

local function MakeGlassGibs(npc, amount)
    for i = 1, amount do
        local particle = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TOOTH_PARTICLE, 0, npc.Position, RandomVector()*mod:RandomInt(2,6,npc:GetDropRNG()), npc)
        particle.Color = Color(0.7,0.7,1,0.4)
        particle:Update()
    end
end

local function GetUrbanePos(suave)
    local player = Isaac.GetPlayer()
    return (suave.Position - (player.Position - suave.Position)), player
end

function mod:SuaveAI(npc, sprite, data)
    local rng = npc:GetDropRNG()

    if not data.Init then
        local urbane = Isaac.Spawn(mod.FF.Urbane.ID, mod.FF.Urbane.Var, 0, GetUrbanePos(npc), Vector.Zero, npc)
        urbane.Parent = npc

        npc.SplatColor = mod.ColorGhostly
        npc.TargetPosition = npc.Position
        data.State = "Idle"
        data.Init = true
    end

    if data.State == "Idle" then
        mod:spritePlay(sprite, "Idle")

        if not data.MoveTarget then
            data.MoveTarget = npc.TargetPosition + (RandomVector() * mod:RandomInt(bal.wanderRadius, rng))
        end

        if npc.Position:Distance(data.MoveTarget) < 5 then
            data.MoveTarget = nil
            npc.Velocity = npc.Velocity * 0.8
        else
            npc.Velocity = mod:Lerp(npc.Velocity, (data.MoveTarget - npc.Position):Resized(bal.moveSpeed), bal.moveLerp)
        end

    elseif data.State == "Death" then
        if sprite:IsFinished("Death") then
            mod:PlaySound(SoundEffect.SOUND_MIRROR_BREAK, npc, 1.25, 0.8)
            MakeGlassGibs(npc, 6)
            npc:Kill()
        else
            mod:spritePlay(sprite, "Death")
        end
    end
end

function mod:UrbaneAI(npc, sprite, data)
    if not data.Init then
        npc.SplatColor = mod.ColorGhostly
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_HIDE_HP_BAR)
        data.State = "Appear"
        data.Init = true
    end

    if mod:IsReallyDead(npc.Parent) then
        npc.Velocity = Vector.Zero
        sprite:RemoveOverlay()

        if sprite:IsFinished("Leave") then
            npc:Remove()
        else
            mod:spritePlay(sprite, "Leave")
        end
    else
        local targetpos, player = GetUrbanePos(npc.Parent)
        npc.Velocity = targetpos - npc.Position

        if data.State == "Appear" then
            if sprite:IsFinished("Appear") then
                data.State = "Idle"
            else
                mod:spritePlay(sprite, "Appear")
            end

        elseif data.State == "Idle" then
            mod:spritePlay(sprite, "Body")
            local vec = -player:GetAimDirection()
            local frame = player:GetHeadDirection()

            npc.StateFrame = npc.StateFrame - 1
            if vec:Length() > 0.2 and (data.FireDelay and player.FireDelay > data.FireDelay) then
                if data.SkipShot then
                    data.SkipShot = false
                else
                    npc:FireProjectiles(npc.Position, vec:Resized(bal.projSpeed), 0, params)
                    npc.StateFrame = 3
                    sprite:SetOverlayFrame("HeadShoot", frame)
                    data.SkipShot = true
                end
            elseif npc.StateFrame < 0 then
                sprite:SetOverlayFrame("HeadIdle", frame)
            end
            data.FireDelay = player.FireDelay
        end
    end
end

function mod.SuaveDeathAnim(npc)
    local onCustomDeath = function(npc, deathAnim)
        mod:PlaySound(SoundEffect.SOUND_GLASS_BREAK, npc, 1, 1.2)
        mod:PlaySound(SoundEffect.SOUND_MIRROR_BREAK, npc, 2, 0.3)
        MakeGlassGibs(npc, 2)
        mod:GetEntityData(deathAnim).State = "Death"
        mod:GetEntityData(deathAnim).Init = true
    end
    FiendFolio.genericCustomDeathAnim(npc, "Death", true, onCustomDeath)
end