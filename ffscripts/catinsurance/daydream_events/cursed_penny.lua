local Mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local EVENT_NAME = "Cursed Penny"
local SPRITESHEET = "cursed_penny.png"
local YES_DESCRIPTION = "Curse!"
local NO_DESCRIPTION = "Gift!"
local EVENT_WEIGHT = 100

---@param player EntityPlayer
Mod:AddCallback("DAYDREAM_POST_CONFIRM_EVENT", function (_, player)
    sfx:Play(SoundEffect.SOUND_CASH_REGISTER)
    local pos = game:GetRoom():FindFreePickupSpawnPosition(player.Position, 40)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Mod.PICKUP.COIN.CURSED, pos, Vector.Zero, player)
end, EVENT_NAME)

---@param player EntityPlayer
Mod:AddCallback("DAYDREAM_POST_DENY_EVENT", function (_, player)
    sfx:Play(SoundEffect.SOUND_CASH_REGISTER)
    local pos = game:GetRoom():FindFreePickupSpawnPosition(player.Position, 40)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, pos, Vector.Zero, player)
end, EVENT_NAME)

Mod:RegisterDaydreamEvent(EVENT_NAME, EVENT_WEIGHT, YES_DESCRIPTION, NO_DESCRIPTION, SPRITESHEET)