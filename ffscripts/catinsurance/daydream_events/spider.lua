local Mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local EVENT_NAME = "Spider"
local SPRITESHEET = "spider.png"
local YES_DESCRIPTION = "Cute!"
local NO_DESCRIPTION = "Scary!"
local EVENT_WEIGHT = 100

---@param player EntityPlayer
Mod:AddCallback("DAYDREAM_POST_CONFIRM_EVENT", function (_, player)
    sfx:Play(SoundEffect.SOUND_THUMBSUP)
    for _ = 1, 5 do
        local position = player.Position + RandomVector() * 50
        player:ThrowBlueSpider(player.Position, position)
    end
end, EVENT_NAME)

---@param player EntityPlayer
Mod:AddCallback("DAYDREAM_POST_DENY_EVENT", function (_, player)
    sfx:Play(SoundEffect.SOUND_THUMBSUP)
    for _ = 1, 4 do
        local position = player.Position + RandomVector() * 50
        Isaac.Spawn(EntityType.ENTITY_FAMILIAR, Mod.ITEM.FAMILIAR.BLUE_BEETLE, 0, position, Vector.Zero, player)
    end
end, EVENT_NAME)

Mod:RegisterDaydreamEvent(EVENT_NAME, EVENT_WEIGHT, YES_DESCRIPTION, NO_DESCRIPTION, SPRITESHEET)