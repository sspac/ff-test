local Mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local EVENT_NAME = "Spoonbender"
local SPRITESHEET = "spoon_bender.png"
local YES_DESCRIPTION = "Magic!"
local NO_DESCRIPTION = "Science!"
local EVENT_WEIGHT = 100

Mod:AddCallback("DAYDREAM_PRE_EVENT_DISPLAY", function (_, _, player)
    local data = Mod:GetEntityData(player).ffsavedata
    if data.DaydreamLodestone or data.DaydreamSpoonbender then
        return false
    end
end, EVENT_NAME)

---@param player EntityPlayer
Mod:AddCallback("DAYDREAM_POST_CONFIRM_EVENT", function (_, player)
    sfx:Play(SoundEffect.SOUND_FIRE_RUSH)
    player:AddInnateCollectible(CollectibleType.COLLECTIBLE_SPOON_BENDER)
    Mod:GetEntityData(player).ffsavedata.DaydreamSpoonbender = true
end, EVENT_NAME)

---@param player EntityPlayer
Mod:AddCallback("DAYDREAM_POST_DENY_EVENT", function (_, player)
    sfx:Play(SoundEffect.SOUND_STONE_IMPACT)
    player:AddInnateCollectible(CollectibleType.COLLECTIBLE_LODESTONE)
    Mod:GetEntityData(player).ffsavedata.DaydreamLodestone = true
end, EVENT_NAME)

Mod:RegisterDaydreamEvent(EVENT_NAME, EVENT_WEIGHT, YES_DESCRIPTION, NO_DESCRIPTION, SPRITESHEET)

function Mod:ResetDaydreamSpoonbender()
    for _, player in ipairs(PlayerManager.GetPlayers()) do
        local data = Mod:GetEntityData(player).ffsavedata
        if data.DaydreamLodestone then
            player:RemoveInnateCollectible(CollectibleType.COLLECTIBLE_LODESTONE)
        elseif data.DaydreamSpoonbender then
            player:RemoveInnateCollectible(CollectibleType.COLLECTIBLE_SPOON_BENDER)
        end

        data.DaydreamLodestone = nil
        data.DaydreamSpoonbender = nil
    end
end