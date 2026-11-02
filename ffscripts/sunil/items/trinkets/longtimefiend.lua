local mod = FiendFolio
local game = Game()

function mod:LongTimeFiendCache(player, flag, og)
	if player:HasTrinket(mod.ITEM.TRINKET.LONGTIME_FIEND) then
		local sdata = mod:GetEntityData(player).ffsavedata
		sdata.LongtimeFiendFloorsPassed = sdata.LongtimeFiendFloorsPassed or 0.1
		return og + sdata.LongtimeFiendFloorsPassed
	-- print("yaya!!")
	end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_STAT, mod.LongTimeFiendCache, EvaluateStatStage.FLAT_DAMAGE)

function mod:LongTimeFiendStats()
    for i = 0,game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasTrinket(mod.ITEM.TRINKET.LONGTIME_FIEND) then
			local sdata = mod:GetEntityData(player).ffsavedata
			sdata.LongtimeFiendFloorsPassed = sdata.LongtimeFiendFloorsPassed or 0.1
			sdata.LongtimeFiendFloorsPassed = sdata.LongtimeFiendFloorsPassed + 0.33
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            player:EvaluateItems()
			mod:DisableManualCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.LongTimeFiendStats)
			--Doing something very cheeky here
			--Should mean if a mod changes stage a couple times, it won't stack?
			mod.scheduleForUpdate(function()
				mod:EnableManualCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.LongTimeFiendStats)
			end, 1, ModCallbacks.MC_INPUT_ACTION, true)
		-- print("yaya?")
		end
	end
end
mod:AddManualCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.LongTimeFiendStats)
mod:EnableManualCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.LongTimeFiendStats)




