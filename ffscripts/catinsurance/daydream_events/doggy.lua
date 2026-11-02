local Mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local EVENT_NAME = "Doggy"
local SPRITESHEET = "doggy.png"
local YES_DESCRIPTION = "Boom!"
local NO_DESCRIPTION = "Treat!"
local EVENT_WEIGHT = 1

---@param player EntityPlayer
Mod:AddCallback("DAYDREAM_POST_CONFIRM_EVENT", function (_, player)
    sfx:Play(SoundEffect.SOUND_GFUEL_ROCKETLAUNCHER)
    player:UseActiveItem(CollectibleType.COLLECTIBLE_DOCTORS_REMOTE)
end, EVENT_NAME)

---@param player EntityPlayer
Mod:AddCallback("DAYDREAM_POST_DENY_EVENT", function (_, player)
    player:UseActiveItem(CollectibleType.COLLECTIBLE_FORTUNE_COOKIE)
end, EVENT_NAME)

Mod:RegisterDaydreamEvent(EVENT_NAME, EVENT_WEIGHT, YES_DESCRIPTION, NO_DESCRIPTION, SPRITESHEET)