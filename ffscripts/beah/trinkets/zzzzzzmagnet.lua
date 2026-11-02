local mod = FiendFolio
local game = Game()

local function CheckForDealDoors()
    if not PlayerManager.AnyoneHasTrinket(mod.ITEM.TRINKET.ZZZZZZ_MAGNET) then
        return
    end
    if mod:IsPlayerWithCollectible(mod.ITEM.COLLECTIBLE.TOO_MANY_OPTIONS) then
        return
    end
    local room = game:GetRoom()

    for i = 0, DoorSlot.NUM_DOOR_SLOTS - 1, 1 do
        local door = room:GetDoor(i)
        if door then
            mod:EggConvertDoor(door)
        end
    end
end
mod:AddTrinketCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.ITEM.TRINKET.ZZZZZZ_MAGNET, function ()
    mod.scheduleForUpdate(CheckForDealDoors, 0, ModCallbacks.MC_POST_UPDATE)
end)
mod:AddTrinketCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.ITEM.TRINKET.ZZZZZZ_MAGNET, CheckForDealDoors)

function mod:EggConvertDoor(door)
    if door.TargetRoomIndex ~= GridRooms.ROOM_DEVIL_IDX then
        return
    end
    door.TargetRoomIndex = GridRooms.ROOM_ERROR_IDX
    local sprite = door:GetSprite()
    --[[for ii = 1, 4 do
        sprite:ReplaceSpritesheet(ii, "gfx/grid/egg_iamerrorroomdoor.png")
    end
    sprite:LoadGraphics()]]
    local anim = sprite:GetAnimation()
    sprite:Load("gfx/grid/egg_iamerrorroomdoor.anm2", true)
    if door:IsOpen() then
        sprite:Play("Opened", true)
    else
        sprite:Play(anim, true)
    end
end