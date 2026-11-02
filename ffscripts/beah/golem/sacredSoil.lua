local mod = FiendFolio

local function pickupUpdate(_, pickup)
    if mod:GetRealTrinketId(pickup.SubType) == mod.ITEM.ROCK.SACRED_SOIL then
        local p_data = mod:GetEntityData(pickup)
        if not p_data.sw_hallowedGroundCircle then
            local circle = Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.FF.BeahInvisible.Var, 1, pickup.Position, Vector.Zero, pickup)
            circle.Parent = pickup
            p_data.sw_hallowedGroundCircle = circle

            local c_sprite = circle:GetSprite()
            c_sprite:Play("Appear")
        end
    end
end
mod:AddEntityCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, -1, pickupUpdate, PickupVariant.PICKUP_TRINKET)