local mod = FiendFolio
local game = Game()

local function useItem(_,_,rng,player)
    local room = game:GetRoom()
    local stype = rng:RandomFloat() <= 0.01 and mod.PICKUP.COIN.GOLDENCURSED or mod.PICKUP.COIN.CURSED 
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, stype, room:FindFreePickupSpawnPosition(player.Position), Vector.Zero, player)
    return true
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, useItem, mod.ITEM.COLLECTIBLE.BOTTLE_CAP)