local mod = FiendFolio

function mod:magneticSandTearHitParams(player, tearparams, weapontype, damagescale, teardisplacement, source)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.MAGNETIC_SAND) then
		local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.MAGNETIC_SAND)
		local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.MAGNETIC_SAND)
        local chance = 10*mult+mod.XalumLuckBonus(player.Luck, 20, 0.4)*100

        if rng:RandomInt(100) < chance then
			tearparams.TearFlags = tearparams.TearFlags | TearFlags.TEAR_MAGNETIZE
			tearparams.TearColor = Color(0.3, 0.3, 0.45, 1, 0, 0, 0, 1, 1, 1, 1)
		end
	end
end
mod:AddTrinketCallback(ModCallbacks.MC_EVALUATE_TEAR_HIT_PARAMS, FiendFolio.ITEM.ROCK.MAGNETIC_SAND, mod.magneticSandTearHitParams)