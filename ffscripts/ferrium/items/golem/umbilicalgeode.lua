local mod = FiendFolio

function mod:umbilicalGeodeNewRoom(player)
    if player:HasTrinket(mod.ITEM.ROCK.UMBILICAL_GEODE) then
        local mult, gB = mod.GetGolemTrinketPower(player, mod.ITEM.ROCK.UMBILICAL_GEODE)
        mult = math.ceil(mult)
        local heartCheck = 2
        if gB then
            heartCheck = 3
        end
        if player:GetHearts() < heartCheck then
            local tempEffs = player:GetEffects()
            tempEffs:AddCollectibleEffect(CollectibleType.COLLECTIBLE_LITTLE_STEVEN, false, mult)
        end
    end
end
mod:AddTrinketCallback("FF_NEW_ROOM_PLAYER_FERRIUM", mod.ITEM.ROCK.UMBILICAL_GEODE, mod.umbilicalGeodeNewRoom, mod.UMBILICAL_GEODE)

function mod:umbilicalGeodeHurt(player)
    if player:HasTrinket(mod.ITEM.ROCK.UMBILICAL_GEODE) then
        local rng = player:GetTrinketRNG(mod.ITEM.ROCK.UMBILICAL_GEODE)
        local mult, gB = mod.GetGolemTrinketPower(player, mod.ITEM.ROCK.UMBILICAL_GEODE)
        local chance = 0.30
        if gB then
            chance = 0.45
        end
        chance = (chance + mult * 0.15) + (player.Luck * 0.02)
        if rng:RandomFloat() < chance then
            local tempEffs = player:GetEffects()
            tempEffs:AddCollectibleEffect(CollectibleType.COLLECTIBLE_GEMINI, false, 1)
        end
    end
end