if ANDROMEDA then
    --if FiendFolio.ItemsEnabled then
        if not FiendFolioAddedAndromedaItems then
            ANDROMEDA:AddToSpode(FiendFolio.ITEM.COLLECTIBLE.OPHIUCHUS, true)
            ANDROMEDA:AddToSpode(FiendFolio.ITEM.COLLECTIBLE.CETUS, true)
            ANDROMEDA:AddToSpode(FiendFolio.ITEM.COLLECTIBLE.MUSCA, true)

            ANDROMEDA:AddToSpode(FiendFolio.ITEM.COLLECTIBLE.DEIMOS, true)
            ANDROMEDA:AddToSpode(FiendFolio.ITEM.COLLECTIBLE.NYX, true)
            ANDROMEDA:AddToSpode(FiendFolio.ITEM.COLLECTIBLE.GKUNHOMDIMA, true)
            ANDROMEDA:AddToSpode(FiendFolio.ITEM.COLLECTIBLE.PLANET_X, true)
            ANDROMEDA:AddToSpode(FiendFolio.ITEM.COLLECTIBLE.GANYMEDE, true)

            ANDROMEDA:AddToAbandonedPlanetarium(FiendFolio.ITEM.COLLECTIBLE.OPHIUCHUS)
            ANDROMEDA:AddToAbandonedPlanetarium(FiendFolio.ITEM.COLLECTIBLE.CETUS)
            ANDROMEDA:AddToAbandonedPlanetarium(FiendFolio.ITEM.COLLECTIBLE.MUSCA)
        end
    --end
end