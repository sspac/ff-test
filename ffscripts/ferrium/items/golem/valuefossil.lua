local mod = FiendFolio
local game = Game()

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
    if mod.anyPlayerHas(FiendFolio.ITEM.ROCK.VALUE_FOSSIL, true) and pickup:IsShopItem() and pickup.Price > 0 then
		if not FiendFolio.savedata.run.level.valueFossilPickups then
			FiendFolio.savedata.run.level.valueFossilPickups = {}
		end
		local sales = FiendFolio.savedata.run.level.valueFossilPickups
		local mult = 0
		for i=0, game:GetNumPlayers()-1 do
			local player = game:GetPlayer(i)
			if player:HasTrinket(mod.ITEM.ROCK.VALUE_FOSSIL) then
				mult = mult+mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.VALUE_FOSSIL)
			end
		end
		pickup.AutoUpdatePrice = false
		if not sales["" .. pickup.InitSeed] or sales["" .. pickup.InitSeed] ~= math.ceil(mult) then
			if sales["" .. pickup.InitSeed] then
				local change = sales["" .. pickup.InitSeed]-math.ceil(mult)
				pickup.Price = pickup.Price+change
				sales["" .. pickup.InitSeed] = math.ceil(mult)
			else
				pickup.Price = pickup.Price-math.ceil(mult)
				sales["" .. pickup.InitSeed] = math.ceil(mult)
			end
		end
	end
end)