local Mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local EVENT_NAME = "Map"
local SPRITESHEET = "map.png"
local YES_DESCRIPTION = "Path!"
local NO_DESCRIPTION = "Goal!"
local EVENT_WEIGHT = 100

---@param player EntityPlayer
Mod:AddCallback("DAYDREAM_POST_CONFIRM_EVENT", function (_, player)
    sfx:Play(SoundEffect.SOUND_PAPER_IN)
    Isaac.CreateTimer(function ()
        game:GetLevel():ApplyMapEffect() -- doing this on render causes visual bugs
    end, 1, 1, true)
end, EVENT_NAME)

---@param player EntityPlayer
Mod:AddCallback("DAYDREAM_POST_DENY_EVENT", function (_, player)
    sfx:Play(SoundEffect.SOUND_PAPER_IN)
    Isaac.CreateTimer(function ()
        game:GetLevel():ApplyCompassEffect(true)
    end, 1, 1, true)
end, EVENT_NAME)

Mod:RegisterDaydreamEvent(EVENT_NAME, EVENT_WEIGHT, YES_DESCRIPTION, NO_DESCRIPTION, SPRITESHEET, true)