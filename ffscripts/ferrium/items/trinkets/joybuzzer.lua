local mod = FiendFolio
local grng = RNG()

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
    if mod.anyPlayerHas(mod.ITEM.TRINKET.JOY_BUZZER, true) then
        if pickup.Price > 0 or pickup.Price == PickupPrice.PRICE_FREE or pickup.Price == PickupPrice.PRICE_SPIKES then
            grng:SetSeed(pickup.InitSeed, 0)
            local mult = mod.getTrinketMultiplierAcrossAllPlayers(mod.ITEM.TRINKET.JOY_BUZZER)
            local chance = 25+25*mult
            local roll = grng:RandomInt(100)
            if roll < chance then
                --idk why this isn't working
                --[[local roll2 = grng:RandomInt(100)
                if roll2 < 33 then
                    pickup:Morph(5, mod.PICKUP.VARIANT.FIREWORK_BATTERY, 0, true)
                elseif roll2 < 66 then
                    pickup:Morph(5, mod.PICKUP.VARIANT.VIRTUOUS_BATTERY, 0, true)
                else
                    pickup:Morph(5, mod.PICKUP.VARIANT.CURSED_BATTERY, 0, true)
                end]]
                pickup:Morph(5, PickupVariant.PICKUP_LIL_BATTERY, BatterySubType.BATTERY_NORMAL, true)
            end
        end
    end
end, PickupVariant.PICKUP_TAROTCARD)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
    if mod.anyPlayerHas(mod.ITEM.TRINKET.JOY_BUZZER, true) then
        if pickup.SubType == BatterySubType.BATTERY_NORMAL and mod.anyPlayerHas(mod.ITEM.TRINKET.JOY_BUZZER, true) then
            grng:SetSeed(pickup.InitSeed, 0)
            local roll = grng:RandomInt(100)
            if roll < 33 then
                pickup:Morph(5, mod.PICKUP.VARIANT.FIREWORK_BATTERY, 0, true)
            elseif roll < 66 then
                pickup:Morph(5, mod.PICKUP.VARIANT.VIRTUOUS_BATTERY, 0, true)
            else
                pickup:Morph(5, mod.PICKUP.VARIANT.CURSED_BATTERY, 0, true)
            end
        end
    end
end, PickupVariant.PICKUP_LIL_BATTERY)