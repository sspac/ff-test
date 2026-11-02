local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

FiendFolio.AddItemPickupCallback(function(player, added)
    for i = 0, 70 do
		mod.scheduleForUpdate(function()
			local room = Game():GetRoom()
			local spawnpos = room:FindFreePickupSpawnPosition(room:GetGridPosition(room:GetGridIndex(player.Position)), 20)
			local vec = RandomVector()*mod:RandomInt(50,100)/10
            Isaac.Spawn(5, 20, FiendFolio.PICKUP.COIN.LIL_PENNY, player.Position, vec, nil)
		end, i, nil, true)
	end
end, nil, FiendFolio.ITEM.COLLECTIBLE.PAGEANT_BOY_2)