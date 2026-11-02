local mod = FiendFolio

local bal = {
    duration = 115,
    tears = 0.55,
    speed = 2,
}

local function triggerQuicksilver(player,d)
    local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.QUICKSILVER)
    d.QuicksilverRockBonus = {Timer = bal.duration*mult, Tears = bal.tears, Speed = bal.speed}
    player:AddCacheFlags(CacheFlag.CACHE_SPEED | CacheFlag.CACHE_FIREDELAY, true)
end

function mod:QuicksilverNewRoom(player, d, room)
    if player:HasTrinket(mod.ITEM.ROCK.QUICKSILVER) then
        if room:IsFirstVisit() or mod.IsActiveRoom() then
            triggerQuicksilver(player,d)
        end
    end
end
mod:AddTrinketCallback("FF_NEW_ROOM_PLAYER_FERRIUM", mod.ITEM.ROCK.QUICKSILVER, mod.QuicksilverNewRoom)

mod:AddTrinketCallback(mod.CALLBACK.FF_PLAYER_POST_START_GREED_WAVE, mod.ITEM.ROCK.QUICKSILVER, function(_, player, d, waveNumber, isBossWave)
	if player:HasTrinket(mod.ITEM.ROCK.QUICKSILVER) then
        triggerQuicksilver(player,d)
    end
end)

function mod:QuicksilverUpdate(player)
    local d = mod:GetEntityData(player)
    if d.QuicksilverRockBonus then
        if d.QuicksilverRockBonus.Timer > 0 then
            d.QuicksilverRockBonus.Timer = d.QuicksilverRockBonus.Timer-1
        else
            d.QuicksilverRockBonus = nil
            player:AddCacheFlags(CacheFlag.CACHE_SPEED | CacheFlag.CACHE_FIREDELAY, true)
        end
    end
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.ROCK.QUICKSILVER, mod.QuicksilverUpdate)