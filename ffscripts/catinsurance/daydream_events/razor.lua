local Mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local EVENT_NAME = "Razor"
local SPRITESHEET = "razor.png"
local YES_DESCRIPTION = "Pain!"
local NO_DESCRIPTION = "Power!"
local EVENT_WEIGHT = 100

Mod:AddCallback("DAYDREAM_PRE_EVENT_DISPLAY", function (_, _, player)
    local data = Mod:GetEntityData(player).ffsavedata
    if data.DaydreamAnemic then
        return false
    end
end, EVENT_NAME)

---@param player EntityPlayer
Mod:AddCallback("DAYDREAM_POST_CONFIRM_EVENT", function (_, player)
    sfx:Play(SoundEffect.SOUND_BLOODBANK_SPAWN)
    local effects = player:GetEffects()
    effects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_ANEMIC)
    Mod:GetEntityData(player).ffsavedata.DaydreamAnemic = true
end, EVENT_NAME)

---@param player EntityPlayer
Mod:AddCallback("DAYDREAM_POST_DENY_EVENT", function (_, player)
    sfx:Play(SoundEffect.SOUND_BLOODBANK_SPAWN)
    for _, entity in ipairs(Isaac.GetRoomEntities()) do
        if entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then
            entity:AddBleeding(EntityRef(player), 90)
        end
    end
end, EVENT_NAME)

Mod:RegisterDaydreamEvent(EVENT_NAME, EVENT_WEIGHT, YES_DESCRIPTION, NO_DESCRIPTION, SPRITESHEET)

function Mod:ResetDaydreamRazor()
    for _, player in ipairs(PlayerManager.GetPlayers()) do
        local data = Mod:GetEntityData(player).ffsavedata
        if data.DaydreamAnemic then
            player:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_ANEMIC)
        end

        data.DaydreamAnemic = nil
    end
end