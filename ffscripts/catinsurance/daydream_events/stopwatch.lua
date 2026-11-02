local Mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local EVENT_NAME = "Stopwatch"
local SPRITESHEET = "stopwatch.png"
local YES_DESCRIPTION = "Slower!"
local NO_DESCRIPTION = "Faster!"
local EVENT_WEIGHT = 100
local OFFSET = Vector(-2, 0)

Mod:AddCallback("DAYDREAM_POST_CONFIRM_EVENT", function (_, player)
    sfx:Play(SoundEffect.SOUND_WAR_BOMB_TICK, 1.3)

    local room = game:GetRoom()
    if room:GetBrokenWatchState() ~= 1 then
        room:SetBrokenWatchState(1)

        Isaac.CreateTimer(function ()
            room:SetBrokenWatchState(0)
        end, 30 * 16, 1, false)
    end
end, EVENT_NAME)

---@param player EntityPlayer
Mod:AddCallback("DAYDREAM_POST_DENY_EVENT", function (_, player)
    sfx:Play(SoundEffect.SOUND_THUMBSUP)

    local saveData = Mod:GetEntityData(player).ffsavedata
    saveData.DaydreamSpeedUp = saveData.DaydreamSpeedUp or 0
    saveData.DaydreamSpeedUp = saveData.DaydreamSpeedUp + 0.03

    player:AddCacheFlags(CacheFlag.CACHE_SPEED, true)
end, EVENT_NAME)

Mod:RegisterDaydreamEvent(EVENT_NAME, EVENT_WEIGHT, YES_DESCRIPTION, NO_DESCRIPTION, SPRITESHEET, nil, OFFSET)