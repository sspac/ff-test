local mod = FiendFolio

local function FlyInit(_, familiar)
    local player = PlayerManager.FirstTrinketOwner(mod.ITEM.TRINKET.OWL_FEATHER)
    if player then
        local t_rng = player:GetTrinketRNG(mod.ITEM.TRINKET.OWL_FEATHER)
        if t_rng:RandomFloat() < 0.2 * player:GetTrinketMultiplier(mod.ITEM.TRINKET.OWL_FEATHER) then
            familiar.SubType = LocustSubtypes.LOCUST_OF_WRATH
            familiar:GetSprite():Play("LocustWrath", true)
            return
        end
    end
end
mod:AddTrinketCallback(ModCallbacks.MC_FAMILIAR_INIT, mod.ITEM.TRINKET.OWL_FEATHER, FlyInit, FamiliarVariant.BLUE_FLY)