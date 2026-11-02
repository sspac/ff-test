local Mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local EVENT_NAME = "Angel"
local SPRITESHEET = "angel.png"
local YES_DESCRIPTION = "Good!"
local NO_DESCRIPTION = "Evil!"
local EVENT_WEIGHT = 100

local config = Isaac.GetItemConfig()

local FAMILIARS_ANGEL = {
    CollectibleType.COLLECTIBLE_GUARDIAN_ANGEL,
    CollectibleType.COLLECTIBLE_SERAPHIM,
    CollectibleType.COLLECTIBLE_ANGELIC_PRISM,
}

local FAMILIARS_DEVIL = {
    CollectibleType.COLLECTIBLE_LIL_BRIMSTONE,
    CollectibleType.COLLECTIBLE_LIL_ABADDON,
    CollectibleType.COLLECTIBLE_DEMON_BABY
}

Mod:AddCallback("DAYDREAM_PRE_EVENT_DISPLAY", function (_, _, player)
    local data = Mod:GetEntityData(player).ffsavedata
    if data.DaydreamFamiliar then
        return false
    end
end, EVENT_NAME)

---@param player EntityPlayer
Mod:AddCallback("DAYDREAM_POST_CONFIRM_EVENT", function (_, player)
    sfx:Play(SoundEffect.SOUND_POWERUP1)

    local data = Mod:GetEntityData(player).ffsavedata
    local rng = player:GetCollectibleRNG(Mod.ITEM.COLLECTIBLE.DAYDREAM)
    local choice = FAMILIARS_ANGEL[rng:RandomInt(1, #FAMILIARS_ANGEL)]

    player:AddInnateCollectible(choice)
    data.DaydreamFamiliar = choice
end, EVENT_NAME)

---@param player EntityPlayer
Mod:AddCallback("DAYDREAM_POST_DENY_EVENT", function (_, player)
    sfx:Play(SoundEffect.SOUND_POWERUP1)

    local data = Mod:GetEntityData(player).ffsavedata
    local rng = player:GetCollectibleRNG(Mod.ITEM.COLLECTIBLE.DAYDREAM)
    local choice = FAMILIARS_DEVIL[rng:RandomInt(1, #FAMILIARS_DEVIL)]

    player:AddInnateCollectible(choice)
    data.DaydreamFamiliar = choice
end, EVENT_NAME)

Mod:RegisterDaydreamEvent(EVENT_NAME, EVENT_WEIGHT, YES_DESCRIPTION, NO_DESCRIPTION, SPRITESHEET)

function Mod:DaydreamAngelPostNewRoom()
    for _, player in ipairs(PlayerManager.GetPlayers()) do
        local data = Mod:GetEntityData(player).ffsavedata
        if data.DaydreamFamiliar then
            player:RemoveInnateCollectible(data.DaydreamFamiliar)
        end

        data.DaydreamFamiliar = nil
    end
end