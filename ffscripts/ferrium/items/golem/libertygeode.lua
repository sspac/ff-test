local mod = FiendFolio

local libertyGeodeEffects = {
    CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM,
    --CollectibleType.COLLECTIBLE_COMPASS, --Has no collectibleeffect and I don't want to fuck about with wisps..
    --i can just lie and say that it was only added back in as a flash quirk and wasn't needed idc
    CollectibleType.COLLECTIBLE_MINI_MUSH,
    CollectibleType.COLLECTIBLE_ODD_MUSHROOM_THIN,
    CollectibleType.COLLECTIBLE_ODD_MUSHROOM_LARGE,
    CollectibleType.COLLECTIBLE_BLUE_CAP,
    CollectibleType.COLLECTIBLE_GODS_FLESH,
}

function mod:libertyGeodeNewRoom(player, data)
    if player:HasTrinket(mod.ITEM.ROCK.LIBERTY_GEODE) then
        local mult = player:GetTrinketMultiplier(mod.ITEM.ROCK.LIBERTY_GEODE)
        local rng = player:GetTrinketRNG(mod.ITEM.ROCK.LIBERTY_GEODE)
        local chance = 25*mult
        local chance1 = chance
        if mod.HasTwoGeodes(player) then
            chance1 = 38*mult
        end
        --the chance isn't documented, but it seems to be around 25% when eyeballing it over 30 rooms

        if rng:RandomInt(100) < chance1 then
            if mod.HasTwoGeodes(player) then
                local effs = mod:getSeveralDifferentNumbers(2, #libertyGeodeEffects, rng)

                local tempEffs = player:GetEffects()
                tempEffs:AddCollectibleEffect(libertyGeodeEffects[effs[1]], true, math.floor(mult))

                if rng:RandomInt(100) < chance then
                    tempEffs:AddCollectibleEffect(libertyGeodeEffects[effs[2]], true, math.floor(mult))
                end
            else
                local tempEffs = player:GetEffects()
                tempEffs:AddCollectibleEffect(libertyGeodeEffects[rng:RandomInt(#libertyGeodeEffects)+1], true, math.floor(mult))
            end
        end
    end
end
mod:AddTrinketCallback("FF_NEW_ROOM_PLAYER_FERRIUM", mod.ITEM.ROCK.LIBERTY_GEODE, mod.libertyGeodeNewRoom)