local mod = FiendFolio

--Ultra secret rooms don't work here

mod:AddCallback(ModCallbacks.MC_PRE_LEVEL_PLACE_ROOM, function(_, slot, config, seed)
    if config.Type == RoomType.ROOM_SECRET then
        local mult = mod.getTrinketMultiplierAcrossAllPlayers(mod.ITEM.TRINKET.HOLLOW_CARD)
        --[[if mult > 2 then
            local room = RoomConfigHolder.GetRandomRoom(seed, true, StbType.SPECIAL_ROOMS, RoomType.ROOM_ULTRASECRET, RoomShape.ROOMSHAPE_1x1)
            if room then
                return room
            end
        elseif mult >= 1 then
            local room = RoomConfigHolder.GetRandomRoom(seed, true, StbType.SPECIAL_ROOMS, RoomType.ROOM_SUPERSECRET, RoomShape.ROOMSHAPE_1x1)
            if room then
                return room
            end
        end]]
        if mult > 0 then
            local room = RoomConfigHolder.GetRandomRoom(seed, true, StbType.SPECIAL_ROOMS, RoomType.ROOM_SUPERSECRET, RoomShape.ROOMSHAPE_1x1)
            if room then
                return room
            end
        end
    --[[elseif config.Type == RoomType.ROOM_SUPERSECRET then
        local mult = mod.getTrinketMultiplierAcrossAllPlayers(mod.ITEM.TRINKET.HOLLOW_CARD)
        if mult > 1 then
            local room = RoomConfigHolder.GetRandomRoom(seed, true, StbType.SPECIAL_ROOMS, RoomType.ROOM_ULTRASECRET, RoomShape.ROOMSHAPE_1x1)
            if room then
                return room
            end
        end]]
    end
end)