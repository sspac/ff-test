local mod = FiendFolio
local sfx = SFXManager()

--[[FiendFolio.AddItemPickupCallback(function(player)
    mod:CheckAgainstCurrentGun(player, FiendFolio.ITEM.COLLECTIBLE.STRANGE_RED_OBJECT)
end, nil, FiendFolio.ITEM.COLLECTIBLE.STRANGE_RED_OBJECT)

FiendFolio.AddItemPickupCallback(function(player)
    mod:CheckAgainstCurrentGun(player, FiendFolio.ITEM.COLLECTIBLE.HOW_TO_ROLL)
end, nil, FiendFolio.ITEM.COLLECTIBLE.HOW_TO_ROLL)]]

--[[mod:AddCallback("PRE_GUN_FIRE_SOUND", function(_, gun, player)
    sfx:Play(mod.Sounds.ShotgunBlast, 0.4, 0, false, mod:RandomInt(120,140,gun:GetDropRNG())/100)
    return true
end, FiendFolio.ITEM.COLLECTIBLE.HOW_TO_ROLL)]]

mod:AddCallback("PRE_GUN_FIRE_SOUND", function(_, gun, player)
    sfx:Play(mod.Sounds.ShotgunBlast, 0.4, 0, false, mod:RandomInt(120,140,gun:GetDropRNG())/100)
    return true
end, FiendFolio.ITEM.COLLECTIBLE.HOW_TO_ROLL)

mod:AddCallback("POST_GUN_UPDATE", function(_, gun, player)
    local sprite = gun:GetSprite()
    if sprite:IsPlaying("Shoot") then
        sprite.PlaybackSpeed = 1.75
    else
        sprite.PlaybackSpeed = 1
    end
end, FiendFolio.ITEM.COLLECTIBLE.COLLECTIBLE_TOUGH_LOVE)