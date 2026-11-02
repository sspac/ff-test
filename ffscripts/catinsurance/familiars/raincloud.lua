-- This is a part of the Daydream item.

local mod = FiendFolio
local Raincloud = {}
local sfx = SFXManager()

local CLOUD_SUBTYPE = 0
local STORM_SUBTYPE = 1

local CREEP_INTERVAL = 5
local STRIKE_INTERVAL = 60
local STRIKE_DAMAGE = 4.5
local DAMAGE_RADIUS = 30
local CLOUD_SPEED = 4.5
local STORM_SPEED = 0.5
local MOVE_TOWARDS_RADIUS = 40 * 4

local variant = mod.ITEM.FAMILIAR.RAINCLOUD

function mod:RemoveRainclouds()
    for _, raincloud in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, variant)) do
        raincloud:Remove()
    end
end

---@param familiar EntityFamiliar
function Raincloud:InitCloud(familiar)
    local sprite = familiar:GetSprite()
    if familiar.SubType == CLOUD_SUBTYPE then 
        sprite:Play("Idle", true)
        familiar.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
        familiar.Velocity = Vector.FromAngle(-135):Resized(CLOUD_SPEED)
    else
        sprite:Play("IdleStorm", true)
        familiar.FireCooldown = STRIKE_INTERVAL
    end

    familiar.SpriteOffset = Vector(0, -25)
end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, Raincloud.InitCloud, variant)

---@param familiar EntityFamiliar
function Raincloud:UpdateCloud(familiar)
    if familiar.FireCooldown == 0 then
        local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL, 0, familiar.Position, Vector.Zero, familiar):ToEffect()
        creep.Scale = 0.85
        creep:Update()

        familiar.FireCooldown = CREEP_INTERVAL
    end

    familiar.Velocity = mod:Lerp(familiar.Velocity, mod:diagonalMoveFam(familiar, CLOUD_SPEED, true), 0.1)
    familiar.FireCooldown = math.max(familiar.FireCooldown - 1, 0)

    local enemy = mod.FindClosestEnemy(familiar.Position, MOVE_TOWARDS_RADIUS, true, nil, nil, nil, nil, true, nil, nil, nil)
    if enemy then
        local targetAngle = (enemy.Position - familiar.Position)
        local newAngle = mod:LerpAngleDegrees(familiar.Velocity, targetAngle, 0.5)
        familiar.Velocity = mod:Lerp(familiar.Velocity, Vector.FromAngle(newAngle):Resized(CLOUD_SPEED), 0.2)
    end
end

---@param familiar EntityFamiliar
function Raincloud:UpdateStorm(familiar)
    local sprite = familiar:GetSprite()
    if familiar.FireCooldown == 0 then
        sprite:Play("Strike", true)

        familiar.FireCooldown = STRIKE_INTERVAL
    end

    if sprite:IsFinished("Strike") then
        sprite:Play("IdleStorm", true)
    end

    -- Make a fake explosion so we don't blow up rocks or anything.
    if sprite:IsEventTriggered("Boom") then
        local explosion = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0, familiar.Position, Vector.Zero, familiar)
        explosion.SpriteScale = Vector(0.5, 0.5)

        local scorchMark = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_CRATER, 0, familiar.Position, Vector.Zero, familiar)
        scorchMark.SpriteScale = explosion.SpriteScale

        sfx:Play(SoundEffect.SOUND_EXPLOSION_WEAK)

        for _, ent in ipairs(Isaac.FindInRadius(familiar.Position, DAMAGE_RADIUS, EntityPartition.ENEMY)) do
            local enemy = ent:ToNPC()
            if enemy and ent:IsActiveEnemy() and ent:IsVulnerableEnemy() then
                enemy:TakeDamage(STRIKE_DAMAGE, DamageFlag.DAMAGE_EXPLOSION, EntityRef(familiar.Player), 5)
            end
        end
    end

    local enemy = mod.FindClosestEnemy(familiar.Position, nil, true, nil, nil, nil, nil, true, nil, nil, nil)
    enemy = enemy or familiar.Player

    local vec = (enemy.Position - familiar.Position)
    if vec:Length() > 15 then
        familiar:AddVelocity(vec:Normalized():Resized(STORM_SPEED))
    end

    familiar.Velocity = familiar.Velocity * 0.95
    familiar.FireCooldown = math.max(familiar.FireCooldown - 1, 0)
end

function Raincloud:UpdateClouds(familiar)
    if familiar.SubType == STORM_SUBTYPE then
        Raincloud:UpdateStorm(familiar)
    else
        Raincloud:UpdateCloud(familiar)
    end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, Raincloud.UpdateClouds, variant)