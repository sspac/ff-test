local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local bal = {
    minWait = 15,
    maxWait = 60,
    projInterval = 4,
}

local params = ProjectileParams()

function mod:ImperialistAI(npc, sprite, data)
    local rng = npc:GetDropRNG()

    if not data.Init then
        data.WaitTime = 0
        data.MakesWobblinProj = true
        data.Poofs = {}
        data.Init = true
    end

    if npc.State == 4 then
        if data.WaitTime > 0 then
            npc.State = 3
            sprite:Play("Idle", true)
        elseif not data.ClearedProjectiles then
            mod:PoxProjectileClearing(npc)
            data.ClearedProjectiles = true
            data.Poofs = {}
        end
    else
        data.WaitTime = data.WaitTime - 1
        data.ClearedProjectiles = false
    end

    if sprite:WasEventTriggered("Jump") and not sprite:WasEventTriggered("Land") then
        if npc.Velocity:Length() > 1 and sprite:GetFrame() % bal.projInterval == 0 then
            local projectile = mod:FireProjectiles(npc, npc.Position, Vector.Zero, 0, params)
            mod:GetEntityData(projectile).Wobblin = true
            projectile.FallingAccel = -0.05
            projectile.Scale = 1.3
            projectile.Height = -30
            projectile.Parent = npc
            projectile:AddProjectileFlags(ProjectileFlags.ANY_HEIGHT_ENTITY_HIT | ProjectileFlags.NO_WALL_COLLIDE)

            local effect = Isaac.Spawn(1000,2,1,npc.Position,Vector.Zero,npc):ToEffect()
            effect.SpriteOffset = Vector(0,-60)
            effect.DepthOffset = npc.Position.Y - 400
            effect:FollowParent(npc)
            table.insert(data.Poofs, effect)

            npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT, 0.8, 0, false, 1.2)
        end
    end

    if sprite:IsEventTriggered("Jump") then
        data.StartPos = npc.Position
    elseif sprite:IsEventTriggered("Fall") then
        for _, effect in pairs(data.Poofs) do
            if effect:Exists() then
                mod:GetEntityData(effect).ParentOffsetAdjust = Vector(0,11)
                mod:GetEntityData(effect).ParentOffsetTarget = Vector(0,35)
            end
        end
    elseif sprite:IsEventTriggered("Land") then
        local dist = data.StartPos:Distance(npc.Position)
        data.WaitTime = mod:BoundValue(dist/3, bal.minWait, bal.maxWait)
    end

    if npc:IsDead() then
        npc:PlaySound(SoundEffect.SOUND_POT_BREAK, 1, 0, false, 1)
        for i = 1, 3 do
            local particle = Isaac.Spawn(1000, 4, 0, npc.Position, RandomVector()*mod:RandomInt(2,6), npc)
            particle:Update()
            particle:GetSprite():SetFrame("rubble_alt", mod:RandomInt(0,3))
        end
    end
end