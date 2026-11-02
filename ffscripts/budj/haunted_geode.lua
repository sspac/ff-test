local mod = FiendFolio

function mod:hauntedGeodeTearHitParams(player, tearparams, weapontype, damagescale, teardisplacement, source)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.HAUNTED_GEODE) then
		local trinketPower, geodeBonus = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.HAUNTED_GEODE)
        local chance = (20 + 2 * player.Luck) * trinketPower
        if geodeBonus then
            chance = chance * 1.5
        end
        if math.random(100) < chance then
			tearparams.TearFlags = tearparams.TearFlags | TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_PIERCING
			mod:changeTearParamsVariant(tearparams, TearVariant.CUPID_BLUE, TearVariant.CUPID_BLOOD)
			local color = Color.Lerp(tearparams.TearColor, tearparams.TearColor, 1)
            color.R = color.R * 1.3
            color.G = color.G * 1.3
            color.B = color.B * 1.3
            color.A = color.A * 0.8
            color.RO = color.RO + 0.2
            color.GO = color.GO + 0.2
            color.BO = color.BO + 0.2
			tearparams.TearColor = color
		end
	end
end
mod:AddTrinketCallback(ModCallbacks.MC_EVALUATE_TEAR_HIT_PARAMS, FiendFolio.ITEM.ROCK.HAUNTED_GEODE, mod.hauntedGeodeTearHitParams)