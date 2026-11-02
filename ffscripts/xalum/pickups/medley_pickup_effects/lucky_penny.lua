local mod = FiendFolio

mod:AddCallback(mod.CALLBACK.MEDLEY_PENNY_PICKUP, function(_, pickup, collider)
	if collider:ToPlayer() then
		collider:ToPlayer():DonateLuck(1)
	end
end)