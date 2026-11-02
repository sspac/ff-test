local Mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local EVENT_NAME = "Cloud"
local SPRITESHEET = "cloud.png"
local YES_DESCRIPTION = "Rainy!"
local NO_DESCRIPTION = "Stormy!"
local EVENT_WEIGHT = 100

---@param player EntityPlayer
Mod:AddCallback("DAYDREAM_POST_CONFIRM_EVENT", function (_, player)
    sfx:Play(SoundEffect.SOUND_CANDLE_LIGHT)
    Isaac.Spawn(EntityType.ENTITY_FAMILIAR, Mod.ITEM.FAMILIAR.RAINCLOUD, 0, player.Position, Vector.Zero, player)
end, EVENT_NAME)

---@param player EntityPlayer
Mod:AddCallback("DAYDREAM_POST_DENY_EVENT", function (_, player)
    sfx:Play(SoundEffect.SOUND_CANDLE_LIGHT)
    Isaac.Spawn(EntityType.ENTITY_FAMILIAR, Mod.ITEM.FAMILIAR.RAINCLOUD, 1, player.Position, Vector.Zero, player)
end, EVENT_NAME)

Mod:RegisterDaydreamEvent(EVENT_NAME, EVENT_WEIGHT, YES_DESCRIPTION, NO_DESCRIPTION, SPRITESHEET)