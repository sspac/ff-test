local mod = FiendFolio
local sfx = SFXManager()

--[[FiendFolio.AddItemPickupCallback(function(player)
    mod:CheckAgainstCurrentGun(player, CollectibleType.COLLECTIBLE_PARASITE)
end, nil, CollectibleType.COLLECTIBLE_PARASITE)]]

--[[mod:AddCallback("PRE_GUN_FIRE_SOUND", function(_, gun, player)
    sfx:Play(mod.Sounds.IrisSpit, 0.4, 0, false, mod:RandomInt(120,140,gun:GetDropRNG())/100)
    return true
end, CollectibleType.COLLECTIBLE_PARASITE)]]

--[[FiendFolio.AddItemPickupCallback(function(player)
    mod:CheckAgainstCurrentGun(player, FiendFolio.ITEM.COLLECTIBLE.IMP_SODA)
end, nil, FiendFolio.ITEM.COLLECTIBLE.IMP_SODA)]]

--[[FiendFolio.AddItemPickupCallback(function(player)
    mod:CheckAgainstCurrentGun(player, FiendFolio.ITEM.COLLECTIBLE.RUBBER_BULLETS)
end, nil, FiendFolio.ITEM.COLLECTIBLE.RUBBER_BULLETS)]]

--[[FiendFolio.AddItemPickupCallback(function(player)
    mod:CheckAgainstCurrentGun(player, FiendFolio.ITEM.COLLECTIBLE.BRICK_FIGURE)
end, nil, FiendFolio.ITEM.COLLECTIBLE.BRICK_FIGURE)]]