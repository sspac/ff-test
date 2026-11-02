local mod = FiendFolio
local game = Game()

FiendFolio.AddItemPickupCallback(function(player, added)
    --player:SetColor(mod.ColorRedNo3, -1, 9, false, false)
    mod:AddMorbidHearts(player, 3)
end, nil, mod.ITEM.COLLECTIBLE.RED_NO_3)

--[[function mod:playerEnsureRedNo3Color(player, d)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.RED_NO_3) then
        d.tryUpdateColor = mod.ColorRedNo3
    end
end

function mod:playerEnsureRedNo3ColorDelayed(player, d)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.RED_NO_3) then
        local d = mod:GetEntityData(player)
        d.tryUpdateColorTimer = {mod.ColorRedNo3, 10}
    end
end]]