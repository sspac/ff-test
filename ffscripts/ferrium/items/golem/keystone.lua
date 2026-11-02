local mod = FiendFolio
local game = Game()

function mod:keystoneUpdate(player)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.KEYSTONE) then
		local room = game:GetRoom()
		local data = mod:GetEntityData(player).ffsavedata.RunEffects

		if not data.keystoneCount then
			data.keystoneCount = 0
			data.keystoneNumber = player:GetNumKeys()
		end
		if player:GetNumKeys() < data.keystoneNumber then
			data.keystoneCount = data.keystoneCount + (data.keystoneNumber-player:GetNumKeys())
			player:AddCacheFlags(CacheFlag.CACHE_ALL)
			player:EvaluateItems()
		end
		data.keystoneNumber = player:GetNumKeys()
	end
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.ROCK.KEYSTONE, mod.keystoneUpdate)

function mod:KeystoneOnAdd(player, first, id)
	if first then
		local num = (mod:IsGoldTrinket(id) and 3) or 1
		Isaac.Spawn(5, 30, num, game:GetRoom():FindFreePickupSpawnPosition(player.Position, 0, true, false), Vector.Zero, player)
	end
end

function mod:keystoneNewLevel(player, d)
	if d.ffsavedata.RunEffects.keystoneCount then
		d.ffsavedata.RunEffects.keystoneCount = 0
		player:AddCacheFlags(CacheFlag.CACHE_ALL)
		player:EvaluateItems()
	end
end
mod:AddTrinketCallback("FF_NEW_LEVEL_PLAYER_FERRIUM", mod.ITEM.ROCK.KEYSTONE, mod.keystoneNewLevel)