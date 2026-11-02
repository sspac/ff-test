local Mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local EVENT_NAME = "Door"
local SPRITESHEET = "door.png"
local YES_DESCRIPTION = "Door!"
local NO_DESCRIPTION = "Wall!"
local EVENT_WEIGHT = 100

---@param player EntityPlayer
Mod:AddCallback("DAYDREAM_POST_CONFIRM_EVENT", function (_, player)
    player:UseActiveItem(CollectibleType.COLLECTIBLE_DADS_KEY)
end, EVENT_NAME)

---@param player EntityPlayer
Mod:AddCallback("DAYDREAM_POST_DENY_EVENT", function (_, player)
    if game:IsGreedMode() then
        Isaac.CreateTimer(function ()
            player:UsePill(PillEffect.PILLEFFECT_SEE_FOREVER, PillColor.PILL_WHITE_WHITE, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
        end, 1, 1, true)
    else
        Isaac.CreateTimer(function ()
            local room = game:GetRoom()
            local level = game:GetLevel()
            local roomIndex = level:GetCurrentRoomIndex()

            for slot = DoorSlot.LEFT0, DoorSlot.DOWN1 do
                if room:IsDoorSlotAllowed(slot) then
                    local success = level:MakeRedRoomDoor(roomIndex, slot)
                    if success then
                        sfx:Play(SoundEffect.SOUND_GOLDENKEY, 1, 2, false, 0.5)
                        return
                    end
                end
            end

            sfx:Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ)
        end, 1, 1, false)
    end
end, EVENT_NAME)

Mod:RegisterDaydreamEvent(EVENT_NAME, EVENT_WEIGHT, YES_DESCRIPTION, NO_DESCRIPTION, SPRITESHEET)