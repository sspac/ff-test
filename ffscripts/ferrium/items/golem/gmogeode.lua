local mod = FiendFolio

mod.positivePills = {0, 2, 5, 7, 10, 12, 14, 16, 18, 20, 23, 24, 26, 28, 33, 34, 35, 36, 38, 41, 48}
--Not including Gulp or Vurp for obvious reasons.

mod:AddCallback(ModCallbacks.MC_USE_PILL, function(_, pill, player, flag)
    if player:HasTrinket(FiendFolio.ITEM.ROCK.GMO_GEODE) then
        if (not mod:GetEntityData(player).ffsavedata.pillstotake or mod:GetEntityData(player).ffsavedata.pillstotake == 0) and not mod:GetEntityData(player).GMOGeode then
            local mult = math.ceil(mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.GMO_GEODE))
            FiendFolio.QueuePills(player, mult)
            
            if mod.HasTwoGeodes(player) then
                local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.GMO_GEODE)
                local num = mod.positivePills[rng:RandomInt(#mod.positivePills)+1]
                mod:GetEntityData(player).queuedSpecificPills = mod:GetEntityData(player).queuedSpecificPills or {}
                table.insert(mod:GetEntityData(player).queuedSpecificPills, num)
            end
        end
    end
end)