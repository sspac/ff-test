local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
    local d = mod:GetEntityData(pickup)
    if pickup.SubType == mod.ITEM.COLLECTIBLE.FUN_PIZZA then
        d.isFunPizza = true
    else
        if pickup.SubType == 0 then
            if d.isFunPizza then
                d.isFunPizza = nil
                sfx:Play(mod.Sounds.Tada)
                local firework = Isaac.Spawn(1000,104,0,pickup.Position,Vector.Zero, nil)
            end
        else
            d.isFunPizza = nil
        end
    end
end, 100)