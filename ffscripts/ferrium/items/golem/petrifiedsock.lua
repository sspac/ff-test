local mod = FiendFolio
local game = Game()

function mod:petrifiedSockTearHitParams(player, tearparams, weapontype, damagescale, teardisplacement, source)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.PETRIFIED_SOCK) then
		local mult = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.PETRIFIED_SOCK)
		local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.PETRIFIED_SOCK)
		local chance = 5+5*mult+(2*player.Luck)
		
		if rng:RandomInt(100) < chance then
			tearparams.TearFlags = tearparams.TearFlags | TearFlags.TEAR_FREEZE
			tearparams.TearColor = Color(0.6, 0.6, 0.6, 1, 0.35, 0.35, 0.35, 0.7, 0.7, 0.7, 0.5)
		end
	end
end
mod:AddTrinketCallback(ModCallbacks.MC_EVALUATE_TEAR_HIT_PARAMS, FiendFolio.ITEM.ROCK.PETRIFIED_SOCK, mod.petrifiedSockTearHitParams)