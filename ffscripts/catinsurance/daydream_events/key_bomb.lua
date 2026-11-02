local Mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local EVENT_NAME = "Key/Bomb"
local SPRITESHEET = "key_bomb.png"
local YES_DESCRIPTION = "Key!"
local NO_DESCRIPTION = "Bomb!"
local EVENT_WEIGHT = 50

---@param player EntityPlayer
Mod:AddCallback("DAYDREAM_POST_CONFIRM_EVENT", function (_, player)
    sfx:Play(SoundEffect.SOUND_THUMBSUP)
    local pos = game:GetRoom():FindFreePickupSpawnPosition(player.Position, 40)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, KeySubType.KEY_NORMAL, pos, Vector.Zero, player)
end, EVENT_NAME)

---@param player EntityPlayer
Mod:AddCallback("DAYDREAM_POST_DENY_EVENT", function (_, player)
    sfx:Play(SoundEffect.SOUND_THUMBSUP)
    local pos = game:GetRoom():FindFreePickupSpawnPosition(player.Position, 40)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, BombSubType.BOMB_NORMAL, pos, Vector.Zero, player)
end, EVENT_NAME)

Mod:RegisterDaydreamEvent(EVENT_NAME, EVENT_WEIGHT, YES_DESCRIPTION, NO_DESCRIPTION, SPRITESHEET)