local mod = FiendFolio
local DivineVengeance = {}
local item = Isaac.GetItemIdByName("Divine Vengeance")
local orb = Isaac.GetEntityVariantByName("Divine Vengeance Orb")

local DAMAGE_FLAG_BLACKLIST = DamageFlag.DAMAGE_RED_HEARTS | DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_FAKE
local LASER_TIMEOUT = 20
local DAMAGE_MULTIPLIER = 0.4

---@param entity Entity
---@param source EntityRef
function DivineVengeance:OnHit(entity, _, flags, source, countdown)
    local player = entity:ToPlayer()
    if not player or flags & DAMAGE_FLAG_BLACKLIST > 0 then
        return
    end

    if not source
    or not source.Entity then
        return
    end

    local attacker = source.Entity
    if not (source.Entity:IsVulnerableEnemy() and source.Entity:IsActiveEnemy()) then
        if not (source.Entity.SpawnerEntity and source.Entity.SpawnerEntity:IsVulnerableEnemy() and source.Entity.SpawnerEntity:IsActiveEnemy()) then
            return
        end

        attacker = source.Entity.SpawnerEntity
    end

    local data = mod:GetEntityData(attacker)
    if player:HasCollectible(item) and not data.DVLightOrb then
        local lightOrb = Isaac.Spawn(EntityType.ENTITY_EFFECT, orb, 0, attacker.Position, Vector.Zero, player):ToEffect()
        lightOrb.SpriteOffset = Vector(0, -math.sqrt(attacker.Size) - attacker.SpriteOffset.Y - 15)
        lightOrb.DepthOffset = 10
        lightOrb.PositionOffset = lightOrb.SpriteOffset
        lightOrb:FollowParent(attacker)

        data.DVLightOrb = true

        Isaac.CreateTimer(function ()
            player:SetMinDamageCooldown(countdown * 2 * (player:GetCollectibleNum(item) + player:GetEffects():GetCollectibleEffectNum(item)) - 2)
        end, 2, 1, true)
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_TAKE_DMG, DivineVengeance.OnHit, PlayerVariant.PLAYER)

---@param lightOrb EntityEffect
function DivineVengeance:OrbUpdate(lightOrb)
    local player = lightOrb.SpawnerEntity and lightOrb.SpawnerEntity:ToPlayer() or Isaac.GetPlayer()
    local sprite = lightOrb:GetSprite()

    if not lightOrb.Parent or not lightOrb.Parent:Exists() or lightOrb.Parent:IsDead() then
        sprite:Stop()
        sprite.Color = Color(1, 1, 1, sprite.Color.A - 0.1)

        if sprite.Color.A <= 0 then
            lightOrb:Remove()
        end

        return
    end

    if sprite:IsFinished() then
        if lightOrb.Parent then
            mod:GetEntityData(lightOrb.Parent).DVLightOrb = nil
        end

        lightOrb:Remove()
        return
    end

    if sprite:IsEventTriggered("Trigger") then
        for i = 0, 270, 90 do
            local beam = EntityLaser.ShootAngle(LaserVariant.LIGHT_BEAM, lightOrb.Parent.Position + lightOrb.SpriteOffset, i, LASER_TIMEOUT, Vector.Zero, player)
            beam.DisableFollowParent = true
            beam.Parent = player
            beam.CollisionDamage = beam.CollisionDamage * DAMAGE_MULTIPLIER
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, DivineVengeance.OrbUpdate, orb)