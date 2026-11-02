local mod = FiendFolio
local Constants = {
    BASE_CHANCE = 0.1,
    FLAT = 0.15,
}

local function uraniumTrinketHurt(_, player, flags, key, hp)
    if flags & DamageFlag.DAMAGE_FAKE > 0 then
        return
    end

    if not player:HasTrinket(mod.ITEM.ROCK.URANIUM) then
        return
    end

    local rng = player:GetTrinketRNG(mod.ITEM.ROCK.URANIUM)
    local power = mod.GetGolemTrinketPower(player, mod.ITEM.ROCK.URANIUM)
    local chance = Constants.BASE_CHANCE + (Constants.FLAT * power)

    if rng:RandomFloat() <= chance then
        local id, var, subt = mod:GetHeartIdFromKey(key, hp)

        if id and var and subt then
            mod:SpawnHeartFromRadiation(player, id, var, subt)
        end
    end
end
mod:AddTrinketCallback(CustomHealthAPI.Enums.Callbacks.POST_HEALTH_DAMAGED, mod.ITEM.ROCK.URANIUM, uraniumTrinketHurt)