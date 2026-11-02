local mod = FiendFolio

function mod:doubleRubbleOnGrind(trinket, data, player)
    if mod:GetRealTrinketId(data.GrindingTrinket) == FiendFolio.ITEM.ROCK.DOUBLE_RUBBLE then
		data.DoubledTrinket = FiendFolio.GetNextMiningMachineTrinket(trinket, player)
	end
end