local mod = FiendFolio
local game = Game()

local specials = {
    [RoomType.ROOM_SHOP] = true,
    [RoomType.ROOM_TREASURE] = true,
    [RoomType.ROOM_SECRET] = true,
    [RoomType.ROOM_SUPERSECRET] = true,
    [RoomType.ROOM_ARCADE] = true,
    [RoomType.ROOM_CHALLENGE] = true,
    [RoomType.ROOM_LIBRARY] = true,
    [RoomType.ROOM_SACRIFICE] = true,
    [RoomType.ROOM_ISAACS] = true,
    [RoomType.ROOM_BARREN] = true,
    [RoomType.ROOM_CHEST] = true,
    [RoomType.ROOM_PLANETARIUM] = true,
}

local goodSpecials = {
    [RoomType.ROOM_SHOP] = true,
    [RoomType.ROOM_TREASURE] = true,
    [RoomType.ROOM_SECRET] = true,
    [RoomType.ROOM_SUPERSECRET] = true,
    [RoomType.ROOM_LIBRARY] = true,
    [RoomType.ROOM_ISAACS] = true,
    [RoomType.ROOM_BARREN] = true,
    [RoomType.ROOM_CHEST] = true,
    [RoomType.ROOM_PLANETARIUM] = true,
}

function mod:StitchedCardNewLevel(player)
    if player:HasTrinket(mod.ITEM.TRINKET.STITCHED_CARD) then
        local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.STITCHED_CARD)
        local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.STITCHED_CARD)
        local level = game:GetLevel()
        local potentials = {}
        local all = {}
        local secrets = {}
        local roomList = level:GetRooms()
        for i=1,roomList.Size do
            local room = roomList:Get(i-1)
            local dat = room.OverrideData or room.Data
            if (mult > 1 and goodSpecials[dat.Type]) or (mult == 1 and specials[dat.Type]) then
                table.insert(potentials, i-1)
            end
            if specials[dat.Type] then
                table.insert(all, room.GridIndex)
                if dat.Type == RoomType.ROOM_SECRET or dat.Type == RoomType.ROOM_SUPERSECRET then
                    table.insert(secrets, room.GridIndex)
                end
            end
        end
        if #potentials > 0 then
            local ind = level:GetCurrentRoomIndex()
            local pleaseCheck = {[ind] = true, [ind+1] = true, [ind-1] = true, [ind-13] = true, [ind+13] = true}
            for key,_ in pairs(pleaseCheck) do
                if level:GetRoomByIdx(key) and level:GetRoomByIdx(key).GridIndex ~= key then
                    pleaseCheck[level:GetRoomByIdx(key).GridIndex] = true
                    pleaseCheck[key] = nil
                end
            end

            local results = rng:RandomInt(#potentials)+1
            local room = roomList:Get(potentials[results]).GridIndex
            game:ChangeRoom(room, 0)

            if not mod.anyPlayerHas(CollectibleType.COLLECTIBLE_MIND) and not mod.anyPlayerHas(CollectibleType.COLLECTIBLE_TREASURE_MAP) then
                local visibility
                if mod.anyPlayerHas(CollectibleType.COLLECTIBLE_COMPASS) then
                    visibility = "all"
                elseif mod.anyPlayerHas(CollectibleType.COLLECTIBLE_BLUE_MAP) then
                    visibility = "secret"
                end
                for i=1,roomList.Size do
                    local room2 = roomList:Get(i-1)
                    if pleaseCheck[room2.GridIndex] then
                        if room2 then
                            if (visibility == "all" and all[room2.GridIndex]) or (visibility == "secret" and secrets[room2.GridIndex]) then
                            else
                                room2.DisplayFlags = 0
                            end
                        end
                    end
                end
                level:UpdateVisibility()
            end
        end
    end
end