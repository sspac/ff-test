local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local Constants = {
    PUDDLE_SCALE = 3,
    PUDDLE_TIMEOUT = 30 * 5,
    CONSTANT_PUDDLE_INTERVAL = 8,
    CONSTANT_PUDDLE_SCALE = 2,
    CONSTANT_PUDDLE_OFFSET = 10,
    CONSTANT_PUDDLE_TIMEOUT = 25,
}

-- Used in dung.lua!
mod.DANG_BASE_PROJECTILES = 15
mod.DANG_VARYING_PROJECTILES = 10

function mod:SpawnDangPuddle(position, scale, timeout)
    local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_SLIPPERY_BROWN, 0, position, Vector.Zero, nil):ToEffect()
    creep.SpriteScale = Vector.One * scale
    creep:SetTimeout(timeout + 1)
    creep:Update()
end

function mod:DangCornHazardDeath(npc)
    if mod.IsActiveRoom() then
        mod:SpawnDangPuddle(npc.Position, Constants.PUDDLE_SCALE, Constants.PUDDLE_TIMEOUT)
    end
end

function mod:DangCornHazardUpdate(npc)
    local sprite = npc:GetSprite()
    if sprite:IsFinished() then
        sprite:Play("Landed")
    end

    local room = game:GetRoom()
    local gridIndex = room:GetGridIndex(npc.Position)
    room:SetGridPath(gridIndex, 900)

    npc.Velocity = Vector.Zero

    if mod.IsActiveRoom() and npc.FrameCount % Constants.CONSTANT_PUDDLE_INTERVAL == 0 then
        local offset = RandomVector() * Constants.CONSTANT_PUDDLE_OFFSET
        mod:SpawnDangPuddle(npc.Position + offset, Constants.CONSTANT_PUDDLE_SCALE, Constants.CONSTANT_PUDDLE_TIMEOUT)
    end
end

function mod:DangCornHazardInit(npc)
    npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
    npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_STATUS_EFFECTS)    
    
    npc.SplatColor = mod.ColorBrowniePoop
    
    local sprite = npc:GetSprite()
    
    sprite:Play("Land", true)
    sfx:Play(SoundEffect.SOUND_FETUS_JUMP, 0.5)
end

function mod:DangCornProjectileDeath(proj, data)
    if data.projType == "dangCorn" then
        local room = game:GetRoom()
        local spawnPos = room:FindFreeTilePosition(proj.Position, 12)
        local corn = Isaac.Spawn(mod.FF.DangCornHazard.ID, mod.FF.DangCornHazard.Var, 0, spawnPos, Vector.Zero, proj.SpawnerEntity)
        mod:SpawnDangPuddle(spawnPos, Constants.CONSTANT_PUDDLE_SCALE, Constants.CONSTANT_PUDDLE_TIMEOUT)
    end
end

function mod:DangInit(npc)
    npc.SplatColor = mod.ColorBrowniePoop
end

-- Mostly copied from Dung's shooting code
---@param npc EntityNPC
function mod:DangShootCorn(npc, target, d)
    npc:PlaySound(SoundEffect.SOUND_PLOP,0.5,2,false,math.random(8,10)/10)

    local params = ProjectileParams()
    params.Scale = math.random(2, 10) / 10
    params.FallingSpeedModifier = -50 + math.random(10)
    params.FallingAccelModifier = 1.4 + math.random(2)/10
    params.Variant = mod.FF.DangCornProjectile.Var
    params.HeightModifier = 20

    local targetpos = mod:randomConfuse(npc, target.Position)
    local shotspeed = ((targetpos - npc.Position)*0.03):Rotated(-10+math.random(20))

    local cornProjectile = npc:FireProjectilesEx(npc.Position, shotspeed, ProjectileMode.SINGLE, params)[1]
    local data = mod:GetEntityData(cornProjectile)
    data.projType = "dangCorn"

    -- FX
    local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 1, npc.Position - Vector(0, 10), Vector.Zero, npc)
    poof.Color = mod.ColorPoop
    poof.DepthOffset = 20
end