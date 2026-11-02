local mod = FiendFolio

function mod:unobtainiumPlayerUpdate(player)
    if player:HasTrinket(FiendFolio.ITEM.ROCK.UNOBTAINIUM) then
        while player:HasTrinket(FiendFolio.ITEM.ROCK.UNOBTAINIUM) do
            player:TryRemoveTrinket(FiendFolio.ITEM.ROCK.UNOBTAINIUM)
        end
    end
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.ITEM.ROCK.UNOBTAINIUM, mod.unobtainiumPlayerUpdate)
