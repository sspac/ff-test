local mod = FiendFolio
local game = Game()

function mod:colossalFossilTearHitParams(player, tearparams, weapontype, damagescale, teardisplacement, source)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.COLOSSAL_FOSSIL) then
		tearparams.TearScale = tearparams.TearScale * 2
	end
end
mod:AddTrinketCallback(ModCallbacks.MC_EVALUATE_TEAR_HIT_PARAMS, mod.ITEM.ROCK.COLOSSAL_FOSSIL, mod.colossalFossilTearHitParams)