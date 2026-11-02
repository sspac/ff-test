local mod = FiendFolio
local game = Game()

mod:AddTrinketCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.ITEM.TRINKET.BLOODY_SANDPAPER, function(_, player)
	local data = mod:GetEntityData(player)
	if player:HasTrinket(mod.ITEM.TRINKET.BLOODY_SANDPAPER) then
		if (not data.TotalFrozen) then
			local grident = game:GetRoom():GetGridEntityFromPos(player.Position)
			if grident and grident.Desc.Type == GridEntityType.GRID_GRAVITY then
				player.Velocity = mod:Lerp(player.Velocity, player:GetMovementVector() * player.MoveSpeed * 4, 0.3)
			else
				player.Velocity = player:GetMovementVector() * player.MoveSpeed * 4
			end
		end
	end
end)