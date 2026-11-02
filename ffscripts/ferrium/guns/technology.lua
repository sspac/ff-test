local mod = FiendFolio

--[[FiendFolio.AddItemPickupCallback(function(player)
    mod:CheckAgainstCurrentGun(player, CollectibleType.COLLECTIBLE_TECHNOLOGY)
end, nil, CollectibleType.COLLECTIBLE_TECHNOLOGY)]]

mod:AddCallback("PRE_GUN_FIRE_SOUND", function(_, gun, player)
    if not player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS) and not player:HasCollectible(CollectibleType.COLLECTIBLE_EPIC_FETUS) then
        return true
    end
end, CollectibleType.COLLECTIBLE_TECHNOLOGY)