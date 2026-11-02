local mod = FiendFolio
local game = Game()

function mod:tefilinNewFloorPlayer(player)
    local p_data = mod:GetEntityData(player)
    if p_data.ffsavedata.RunEffects.tefilinUp == false then
        p_data.ffsavedata.RunEffects.tefilinUp = true
    end
    if FiendFolio.savedata.run.tef_removeNextFloor then
        p_data.ffsavedata.RunEffects.tefilinUp = nil
    elseif p_data.ffsavedata.RunEffects.tefilinUp then
        local level = game:GetLevel()
        level:AddAngelRoomChance(276)
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_DEVIL_APPLY_SPECIAL_ITEMS, function ()
    for index, value in ipairs(mod:GetAllPlayers()) do
        local p_data = mod:GetEntityData(value)
        if p_data.ffsavedata.RunEffects.tefilinUp then
            return 1
        end
    end
end)

FiendFolio.AddItemPickupCallback(function(player)
    local p_data = mod:GetEntityData(player)
    p_data.ffsavedata.RunEffects.tefilinUp = false
    local level = game:GetLevel()

    local bossCleared = true
    local rooms = level:GetRooms()
    for i = 0, rooms.Size, 1 do
        local room = rooms:Get(i)
        if room and room.Data and room.Data.Type == RoomType.ROOM_BOSS then
            bossCleared = bossCleared and room.Clear
        end
    end

    if not bossCleared then
        level:AddAngelRoomChance(276)
        p_data.ffsavedata.RunEffects.tefilinUp = true
    end
end, nil, mod.ITEM.COLLECTIBLE.TEFILLIN)

local function CheckForDealDoors()
    local room = game:GetRoom()

    for i = 0, DoorSlot.NUM_DOOR_SLOTS - 1, 1 do
        local door = room:GetDoor(i)
        if door and door:IsRoomType(RoomType.ROOM_ANGEL) then
            FiendFolio.savedata.run.tef_removeNextFloor = true
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, function ()
    mod.scheduleForUpdate(CheckForDealDoors, 0, ModCallbacks.MC_POST_UPDATE)
end)