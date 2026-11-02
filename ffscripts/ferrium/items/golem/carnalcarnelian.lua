local mod = FiendFolio

function mod:carnalCarnelianUpdate(player)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.CARNAL_CARNELIAN) then
		local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.CARNAL_CARNELIAN)
		local radius = math.floor(110+30*mult)
		local distance = radius
		for _, enemy in ipairs(Isaac.FindInRadius(player.Position, radius, EntityPartition.ENEMY)) do
			if enemy:IsActiveEnemy() and (not mod:isFriend(enemy)) then
				if enemy.Position:Distance(player.Position) < distance then
					distance = enemy.Position:Distance(player.Position)
				end
			end
		end
        if distance < radius then
			mod:GetEntityData(player).carnalCarnelianDist = (radius-distance)/radius
		else
			mod:GetEntityData(player).carnalCarnelianDist = 0
		end
		player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
		player:AddCacheFlags(CacheFlag.CACHE_SPEED)
		player:EvaluateItems()
	end
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.ROCK.CARNAL_CARNELIAN, mod.carnalCarnelianUpdate)