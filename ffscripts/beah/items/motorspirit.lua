local mod = FiendFolio

local maxFireRate = 40--movespeed determines rate of fire spawn, so this is probably a good way to do it
local function peffectUpdate(_, player)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.MOTOR_SPIRIT) then
        local fired = player.Velocity
        fired = fired:Length()
        fired = fired / 4
        fired = fired^2
        fired = fired / 5

        local p_data = mod:GetEntityData(player)
        p_data.ff_fireBetween = (p_data.ff_fireBetween or 0)+fired
        p_data.ff_fireBetween = math.min(p_data.ff_fireBetween)

        if p_data.ff_fireBetween > 2 then
            p_data.ff_fireBetween = p_data.ff_fireBetween - 2
            --spawn fire

            local fire = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.RED_CANDLE_FLAME, 27, player.Position, Vector.Zero, player):ToEffect()
            fire:SetTimeout(30)
            fire.CollisionDamage = player.Damage / 5 --i keep the damage amount low because its not important when fire does player damage scaling
            fire.SpriteScale = Vector(0.66, 0.66)
            fire.Color = Color(1, 1, 1, 1, 0.5, -0.3, -0.3)
        end

        if p_data.ff_motorSpiritCooldown then
            p_data.ff_motorSpiritCooldown = p_data.ff_motorSpiritCooldown - 1
            if p_data.ff_motorSpiritCooldown <= 0 then
                p_data.ff_motorSpiritCooldown = nil
            end
        end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.COLLECTIBLE.MOTOR_SPIRIT, peffectUpdate)

local function OnEnemyTakeDMG(_, ent, amount, flags, source, dmgCooldown)
    local fire = source.Entity
    if not fire
    or fire.Type ~= EntityType.ENTITY_EFFECT
    or (fire.Variant ~= EffectVariant.RED_CANDLE_FLAME and fire.Variant ~= EffectVariant.FIRE_JET)
    or fire.SubType ~= 27
    or fire.CollisionDamage <= 0 then
        return
    end

    if not ent:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) then
        local f_damage = fire.CollisionDamage*10
        ent:AddBurn(EntityRef(fire.SpawnerEntity), 40, f_damage)
    end
    fire.CollisionDamage = -0
    fire:Kill()
end
mod:AddEntityCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, EntityType.ENTITY_EFFECT, EffectVariant.RED_CANDLE_FLAME, 27, OnEnemyTakeDMG)

--on collision
local cooldown = 15
local oset = Vector(24, 24)
local function onNPCCollide(_, npc, collidor)
    if mod:isFriend(npc) then
        return
    end

    local shopkeeper = false
    if not npc:IsActiveEnemy() or not npc:IsVulnerableEnemy() then
        if npc.Type ~= EntityType.ENTITY_SHOPKEEPER then
            return
        else
            shopkeeper = true
        end
    end

    local p = collidor:ToPlayer()
    if p then
        local hasCollectible = p:HasCollectible(mod.ITEM.COLLECTIBLE.MOTOR_SPIRIT)
        if not hasCollectible and p:GetPlayerType() == mod.PLAYER.BRIEND then
            if p:GetOtherTwin():HasCollectible(mod.ITEM.COLLECTIBLE.MOTOR_SPIRIT) then
                hasCollectible = true
                p = p:GetOtherTwin()
            end
        end 
        if hasCollectible then
            local p_data = mod:GetEntityData(p)
            if p_data.ff_motorSpiritCooldown == nil then
                p_data.ff_motorSpiritCooldown = cooldown

                for i = 1, 4, 1 do
                    local a = (i/4)*360
                    a = Vector.FromAngle(a)
                    a = a*oset

                    local jet = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FIRE_JET, 27, p.Position+a, Vector.Zero, p)
                    jet.CollisionDamage = p.Damage/5
                    jet.Parent = p
                    jet.Color = Color(1, 1, 1, 1, 0.5, -0.3, -0.3)

                    if shopkeeper then
                        npc:Kill()
                    end
                end
            end
        end
    end
end
mod:AddPriorityCollectibleCallback(ModCallbacks.MC_PRE_NPC_COLLISION, CallbackPriority.LATE, mod.ITEM.COLLECTIBLE.MOTOR_SPIRIT, onNPCCollide)

mod:AddEntityCallback(ModCallbacks.MC_PRE_PLAYER_TAKE_DMG, EntityType.ENTITY_EFFECT, EffectVariant.FIRE_JET, 27, function(_, player, _, _, source)
    local fire = source.Entity
    if fire
    and fire.Type == EntityType.ENTITY_EFFECT
    and fire.Variant == EffectVariant.FIRE_JET
    and fire.SubType == 27 then
        return false
    end
end)