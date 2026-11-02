local mod = FiendFolio
local game = Game()
local hud = game:GetHUD()

--=========--
--Lucky Cat--
--=========--

--i copied this chunk of code from erfly ^^;
FiendFolio.AddItemPickupCallback(function(player, added)
    --a for loop because i want it to spawn 5 pennies!!
    for penniesyay = 0, 4 do
		mod.scheduleForUpdate(function()
            --this gets the room or something... i don't know >_<... i copied it
			local room = Game():GetRoom()
            --???????
			local spawnpos = room:FindFreePickupSpawnPosition(room:GetGridPosition(room:GetGridIndex(player.Position)), 20)
            --spawn the pennies!! :D
			Isaac.Spawn(5, 20, 0, spawnpos + RandomVector()*math.random(20), Vector.Zero, nil)
		end, penniesyay, nil, true)
	end
    --lucky cat will display a fortune, here is the code to do this >w<
    mod.scheduleForUpdate(function()
        --this part shows the fortune
        mod:ShowFortune()
    end, 30, ModCallbacks.MC_POST_UPDATE, true)
end, nil, mod.ITEM.COLLECTIBLE.LE_CAT)
