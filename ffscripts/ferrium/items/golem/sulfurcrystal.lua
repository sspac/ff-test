local mod = FiendFolio

function mod:tryTriggerSulfurCrystal(player, data)
    local savedata = data.ffsavedata.RunEffects
    local mult = math.ceil(mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.SULFUR_CRYSTAL))

    savedata.sulfurCrystalCount = (savedata.sulfurCrystalCount or 0)+1
    --print(savedata.sulfurCrystalCount)
    if savedata.sulfurCrystalCount >= 5-mult then
        player:UseActiveItem(CollectibleType.COLLECTIBLE_SULFUR, UseFlag.USE_NOANIM, -1)
        savedata.sulfurCrystalCount = 0
    end
end
function mod:sulfurCrystalNewRoom(player, data)
    if player:HasTrinket(FiendFolio.ITEM.ROCK.SULFUR_CRYSTAL) then
        local room = Game():GetRoom()
        if not room:IsClear() then
            mod:tryTriggerSulfurCrystal(player, data)
        end
    end
end
mod:AddTrinketCallback("FF_NEW_ROOM_PLAYER_FERRIUM", mod.ITEM.ROCK.SULFUR_CRYSTAL, mod.sulfurCrystalNewRoom)

mod:AddTrinketCallback(mod.CALLBACK.FF_PLAYER_POST_START_GREED_WAVE, mod.ITEM.ROCK.SULFUR_CRYSTAL, function(_, player, data, waveNumber, isBossWave)
	if player:HasTrinket(mod.ITEM.ROCK.SULFUR_CRYSTAL) then
        mod:tryTriggerSulfurCrystal(player, data)
    end
end)