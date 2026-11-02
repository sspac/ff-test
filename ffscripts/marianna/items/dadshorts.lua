local mod = FiendFolio
local game = Game()
local hud = game:GetHUD()

--==========--
--Dad Shorts--
--==========--

FiendFolio.AddItemPickupCallback(function(player, added)
    mod.scheduleForUpdate(function()
        local room = Game():GetRoom()
        local spawnpos = room:FindFreePickupSpawnPosition(room:GetGridPosition(room:GetGridIndex(player.Position)), 20)
        Isaac.Spawn(5, 30, 1, spawnpos + RandomVector()*math.random(20), Vector.Zero, nil)
    end, 3, nil, true)
end, nil, mod.ITEM.COLLECTIBLE.DADS_SHORTS)
