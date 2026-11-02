local mod = FiendFolio

function mod:EraserTwoOnFireTear(player, tear)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.ERASER_TWO) then
        local d = mod:GetEntityData(player)
        tear:ChangeVariant(TearVariant.ERASER)
    end
end