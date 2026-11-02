local mod = FiendFolio

function mod:deathCapFossilReset(player)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.DEATH_CAP_FOSSIL) then
		local queuedItem = player.QueuedItem

		if queuedItem.Item ~= nil and queuedItem.Item:IsTrinket() and queuedItem.Item.ID == FiendFolio.ITEM.ROCK.DEATH_CAP_FOSSIL then
			mod:GetEntityData(player).ffsavedata.RunEffects.DeathCapFossilCount = 0
		end
	end
end
--mod:AddTrinketCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.ROCK.DEATH_CAP_FOSSIL, mod.deathCapFossilReset)