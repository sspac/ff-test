local mod = FiendFolio

function mod:pennyPickupScarab(player, pickup, value)
	if player:HasTrinket(mod.ITEM.TRINKET.SCARAB_PENNY) then
		for i=1, player:GetTrinketMultiplier(mod.ITEM.TRINKET.SCARAB_PENNY) do
			mod:ThrowBlueBeetle(player)
		end
	end
end
