local Mod = FiendFolio
local sfx = SFXManager()

local EVENT_NAME = "Mega Bomb"
local SPRITESHEET = "megabomb.png"
local YES_DESCRIPTION = "Cool!"
local NO_DESCRIPTION = "Too big!"
local EVENT_WEIGHT = 10

local sound = Isaac.GetSoundIdByName("DaydreamDingDing")

Mod:AddCallback("DAYDREAM_POST_CONFIRM_EVENT", function ()
    sfx:Play(sound)

    local room = Game():GetRoom()
    Isaac.Spawn(
        EntityType.ENTITY_BOMB,
        BombVariant.BOMB_GIGA,
        0,
        room:FindFreeTilePosition(room:GetCenterPos(), 30),
        Vector.Zero,
        nil
    )
end, EVENT_NAME)

---@param player EntityPlayer
Mod:AddCallback("DAYDREAM_POST_DENY_EVENT", function (_, player)
    sfx:Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ)

    player:UseCard(Card.CARD_TOWER, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
end, EVENT_NAME)

Mod:RegisterDaydreamEvent(EVENT_NAME, EVENT_WEIGHT, YES_DESCRIPTION, NO_DESCRIPTION, SPRITESHEET, true)