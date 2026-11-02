local mod = FiendFolio
local rockWorm = FiendFolio.ITEM.ROCK.ROCK_WORM
local rockWormCacheFlags = CacheFlag.CACHE_TEARFLAG | CacheFlag.CACHE_SHOTSPEED | CacheFlag.CACHE_RANGE | CacheFlag.CACHE_FIREDELAY

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
	mod.AnyPlayerDo(function(player)
		local data = mod.GetPersistentPlayerData(player)
		data.doneRockWorm = false
	end)
end)

mod:AddTrinketCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, rockWorm, function(_, player)
	local data = mod.GetPersistentPlayerData(player)
	if player:HasTrinket(rockWorm) and not data.doneRockWorm then
		data.doneRockWorm = true

		for i = 1, player:GetTrinketMultiplier(rockWorm) do
			mod.XalumSchedule(i * 15, function()
				local rng = player:GetTrinketRNG(rockWorm)
				local worm = mod.KingWormTrinkets[rng:RandomInt(#mod.KingWormTrinkets) + 1]
				mod:AddInnateTrinketForFloor(player, worm)
				player:AnimateTrinket(worm, "UseItem")
				player:AddCacheFlags(rockWormCacheFlags, true)
			end)
		end
	end
end)