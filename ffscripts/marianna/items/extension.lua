local mod = FiendFolio
local game = Game()
local hud = game:GetHUD()

--=========--
--Extension--
--=========--

--function for extension use
function mod:extensionUsed(item, rng, player, flags, slot, varData)
    --list of valid cards (change to OJ cards only when ferrium implements them)
    --[[local cardList = {
        mod.ITEM.CARD.OJ_PRESENT,
        mod.ITEM.CARD.OJ_BUSINESS,
        mod.ITEM.CARD.OJ_STRONGER,
    }]]
    --roll a random number for the card to be used
    local id = mod:weightedRNG(mod.OrangeJuiceCards, rng)
    --use card
    player:UseCard(id, UseFlag.USE_NOHUD)
    --print("extension used successfully")
end

--item activation
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.extensionUsed, mod.ITEM.COLLECTIBLE.EXTENSION)
