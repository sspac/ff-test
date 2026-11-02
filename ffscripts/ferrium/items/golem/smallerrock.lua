local mod = FiendFolio

function mod:smallerRockUpdate(player)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.SMALLER_ROCK) then
		local data = mod:GetEntityData(player)
		local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.SMALLER_ROCK)
		
		for _,grid in ipairs(mod.GetGridEntities()) do
			if mod.smallerRockRocks[grid:GetGridIndex()] ~= nil then
				if grid.CollisionClass == GridCollisionClass.COLLISION_NONE then
					mod.smallerRockRocks[grid:GetGridIndex()] = nil
					data.ffsavedata.RunEffects.smallerRockCount = (data.ffsavedata.RunEffects.smallerRockCount or 0)+mult
                    player:AnimateHappy()
                    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_SPEED)
                    player:EvaluateItems()
				end
			end
		end
	end
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.ROCK.SMALLER_ROCK, mod.smallerRockUpdate)