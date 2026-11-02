local mod = FiendFolio
local game = Game()
local EternalCrystalDamage = 1
local EternalCrystalTears = 0.5

--eternal crystal damage cache
function mod:EternalCrystalCache(player, flag, og)
    if not player:HasTrinket(mod.ITEM.ROCK.ETERNAL_CRYSTAL) then
        return
    end

    if player:GetEternalHearts() == 0 then
        return
    end

    if flag == EvaluateStatStage.DAMAGE_UP then
        return og + mod.GetGolemTrinketPower(player,mod.ITEM.ROCK.ETERNAL_CRYSTAL) * EternalCrystalDamage
    end

-- eternal crystal fire rate cache
    if flag == EvaluateStatStage.TEARS_UP then
        return og + (mod.GetGolemTrinketPower(player,mod.ITEM.ROCK.ETERNAL_CRYSTAL) * EternalCrystalTears)
    end
end

-- hooks the function to the MC_EVALUATE_STAT thingy
mod:AddCallback(ModCallbacks.MC_EVALUATE_STAT, mod.EternalCrystalCache)

function mod:EternalCrystalUpdate(player)
    local data = mod:GetEntityData(player)
    local updated = false

    if player:GetEternalHearts() == 1 and not data.EternalCrystal then
        data.EternalCrystal = true
        updated = true
    elseif  player:GetEternalHearts() == 0 and data.EternalCrystal then
        data.EternalCrystal = nil
        updated = true
    end

    if updated then
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_DAMAGE, true)
    end
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.ROCK.ETERNAL_CRYSTAL, mod.EternalCrystalUpdate)

-- every two stages you get the eternal heart code
function mod:EternalCrystalSpawn()
    if game:GetLevel():GetAbsoluteStage() % 2 ~= 0 then
        return
    end
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasTrinket(mod.ITEM.ROCK.ETERNAL_CRYSTAL) then
            local spawnPos = game:GetRoom():FindFreePickupSpawnPosition(player.Position, 40)
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_ETERNAL, spawnPos, Vector.Zero, player)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.EternalCrystalSpawn)