local mod = FiendFolio

function mod:azeriteOnGrind(player)
    if player:HasTrinket(FiendFolio.ITEM.ROCK.AZERITE) then
		local playersavedata = mod:GetEntityData(player).ffsavedata.RunEffects
		local rng2 = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.AZERITE)
		local mult = mod.GetGolemTrinketPower(player, mod.ITEM.ROCK.AZERITE)
		if not playersavedata.azeriteStats then
			playersavedata.azeriteStats = {}
			playersavedata.azeriteLevel = 0
		end
		if playersavedata.azeriteLevel < 20*mult then --level cap
			local stat = rng2:RandomInt(5)
			if stat == 0 then
				playersavedata.azeriteStats.range = (playersavedata.azeriteStats.range or 0)+1
				player:AddCacheFlags(CacheFlag.CACHE_RANGE)
				player:EvaluateItems()
			elseif stat == 1 then
				playersavedata.azeriteStats.damage = (playersavedata.azeriteStats.damage or 0)+1
				player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
				player:EvaluateItems()
			elseif stat == 2 then
				playersavedata.azeriteStats.tears = (playersavedata.azeriteStats.tears or 0)+1
				player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
				player:EvaluateItems()
			elseif stat == 3 then
				playersavedata.azeriteStats.shotspeed = (playersavedata.azeriteStats.shotspeed or 0)+1
				player:AddCacheFlags(CacheFlag.CACHE_SHOTSPEED)
				player:EvaluateItems()
			elseif stat == 4 then
				playersavedata.azeriteStats.speed = (playersavedata.azeriteStats.speed or 0)+1
				player:AddCacheFlags(CacheFlag.CACHE_SPEED)
				player:EvaluateItems()
			end
			player:AnimateHappy()
		end
	end
end