local mod = FiendFolio

function mod:rustyGeodeUpdate(player)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.RUSTY_GEODE) then
		local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.RUSTY_GEODE)
		local data = mod:GetEntityData(player).ffsavedata

		local decay = 0.002/mult
		if mod.HasTwoGeodes(player) then
			decay = 0.0008/mult
		end

		if data.rustyGeodeBonus and data.rustyGeodeBonus > 0 then
			data.rustyGeodeBonus = data.rustyGeodeBonus-decay
			if data.rustyGeodeBonus < 0 then
				data.rustyGeodeBonus = 0
			end
		end
		player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
		player:EvaluateItems()
	end
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.ROCK.RUSTY_GEODE, mod.rustyGeodeUpdate)

function mod:RustyGeodeOnAdd(player, first, id)
	local data = mod:GetEntityData(player).ffsavedata
	if first then
		local bonus = (mod:IsGoldTrinket(id) and 16) or 8
		data.rustyGeodeBonus = (data.rustyGeodeBonus or 0) + bonus
	end
end