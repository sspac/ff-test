local mod = FiendFolio
local game = Game()

FiendFolio.AddItemPickupCallback(function(player, added)
    mod:AddFractionalCoins(0.1)
end, nil, mod.ITEM.COLLECTIBLE.GLIZZY)