local mod = FiendFolio
local sfx = SFXManager()
local game = Game()

local retryAttempts = 15
local function useCard(_, _, player, flags)
    sfx:Play(SoundEffect.SOUND_CHOIR_UNLOCK, 1, 0)
    mod:trySayAnnouncerLine(mod.Sounds.VACardSlayTheSpireNeighborsFromHell, flags, 70)
    local trinket = nil
    local attempts = 0
    local ptype = player:GetPlayerType()
    local isGolem = ptype == FiendFolio.PLAYER.GOLEM or ptype == FiendFolio.PLAYER.BOLEM
    while (trinket == nil or player:HasTrinket(trinket)) and attempts < retryAttempts do
        if isGolem then
            trinket = mod.GetGolemTrinket()
        else
            trinket = game:GetItemPool():GetTrinket()
        end
    end
    if flags & UseFlag.USE_MIMIC == 0 then
        player:AnimateTrinket(trinket)
    end
    player:AddSmeltedTrinket(trinket)
    game:GetHUD():ShowItemText(player, Isaac.GetItemConfig():GetTrinket(trinket))
end

mod:AddCallback(ModCallbacks.MC_USE_CARD, useCard, mod.ITEM.CARD.NEIGHBOURS_FROM_HELL)