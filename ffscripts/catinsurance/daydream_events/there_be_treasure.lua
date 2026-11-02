local Mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local EVENT_NAME = "There Be Treasure!"
local SPRITESHEET = "treasure.png"
local YES_DESCRIPTION = "Riches!"
local NO_DESCRIPTION = "Risks!"
local EVENT_WEIGHT = 25

---@param player EntityPlayer
Mod:AddCallback("DAYDREAM_POST_CONFIRM_EVENT", function (_, player)
    sfx:Play(SoundEffect.SOUND_THUMBSUP)
    local pos = game:GetRoom():FindFreePickupSpawnPosition(player.Position, 40)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LOCKEDCHEST, 0, pos, Vector.Zero, player)
end, EVENT_NAME)

---@param player EntityPlayer
Mod:AddCallback("DAYDREAM_POST_DENY_EVENT", function (_, player)
    sfx:Play(SoundEffect.SOUND_THUMBSUP)
    local pos = game:GetRoom():FindFreePickupSpawnPosition(player.Position, 40)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_REDCHEST, 0, pos, Vector.Zero, player)
end, EVENT_NAME)

Mod:RegisterDaydreamEvent(EVENT_NAME, EVENT_WEIGHT, YES_DESCRIPTION, NO_DESCRIPTION, SPRITESHEET)