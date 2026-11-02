local mod = FiendFolio

mod:AddCallbacks(ModCallbacks.MC_)

function mod:FossilizedEyePickupRender(pickup, offset)
    
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_PICKUP_RENDER, mod.ITEM.ROCK.FOSSILIZED_EYE, mod.FossilizedEyePickupRender, PickupVariant.PICKUP_TAROTCARD)