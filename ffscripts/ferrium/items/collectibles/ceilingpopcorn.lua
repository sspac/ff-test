local mod = FiendFolio
local game = Game()

mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, function(_, type, charge, first, slot, varData, player)
    if first then
        local room = game:GetRoom()
        local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.CEILING_POPCORN)
        local heart = Isaac.Spawn(EntityType.ENTITY_PICKUP, mod.PICKUP.VARIANT.MORBID_HEART, 0, room:FindFreePickupSpawnPosition(player.Position, 35), Vector.Zero, nil)
    end
end, mod.ITEM.COLLECTIBLE.CEILING_POPCORN)