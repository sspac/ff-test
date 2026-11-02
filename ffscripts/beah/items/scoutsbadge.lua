local mod = FiendFolio
local game = Game()

local muteThePillSFX = true
FiendFolio.AddItemPickupCallback(function(player)
    local winning = 0
    
    local lvel = game:GetLevel()
    for i = 1, 169 do
        local r = lvel:GetRoomByIdx(i)
                
        if r.Data 
        and (r.Data.Type == RoomType.ROOM_SECRET 
        or r.Data.Type == RoomType.ROOM_SUPERSECRET 
        or r.Data.Type == RoomType.ROOM_ULTRASECRET )
        and r.DisplayFlags ~= 0 then
            if r.DisplayFlags ~= 0 then
                winning = winning + 1
            else
                --open?
            end
        end
    end
    lvel:ApplyBlueMapEffect()

    for i = 1, winning, 1 do
        player:AddCollectibleEffect(mod.ITEM.COLLECTIBLE.SCOUTS_BADGE, false)
    end

    mod:AddInnateCollectibleForFloor(player, CollectibleType.COLLECTIBLE_XRAY_VISION, 1, false)
end, nil, mod.ITEM.COLLECTIBLE.SCOUTS_BADGE)