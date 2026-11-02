local mod = FiendFolio

function mod:aaaGeodeUpdate(player)
    if player:HasTrinket(FiendFolio.ITEM.ROCK.AAA_GEODE) then
        local data = mod:GetEntityData(player)
        data.aaaGeodeCharge = data.aaaGeodeCharge or {}
        for i=0,2 do
            data.aaaGeodeCharge[i] = player:GetActiveCharge(i)
        end
    end
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.ROCK.AAA_GEODE, mod.aaaGeodeUpdate)

function mod:aaaGeodeRoomClear(player, data, waves)
    if player:HasTrinket(FiendFolio.ITEM.ROCK.AAA_GEODE) and not player:HasCollectible(CollectibleType.COLLECTIBLE_4_5_VOLT) then
        local mult = player:GetTrinketMultiplier(FiendFolio.ITEM.ROCK.AAA_GEODE)
        if mod.HasTwoGeodes(player) then
            mult = mult+1
        end
        --ehh, I was thinking of making it a chance based thing when below 1 mult, but I feel like that would be really frustrating and not in a good way
        for i=0,2 do
            local item = player:GetActiveItem(i)
            if item > 0 then
                local charges = player:GetActiveMaxCharge(i)
                if (player:GetActiveCharge(i) > data.aaaGeodeCharge[i] or waves) and player:GetActiveCharge(i) < charges and player:GetActiveCharge(i)+math.max(1, mult) >= charges then
                    player:FullCharge(i)
                end
            end
        end
    end
end