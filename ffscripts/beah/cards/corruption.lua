local mod = FiendFolio
local sfx = SFXManager()
local game = Game()
local hud = game:GetHUD()

--[[local evilChargebar = Sprite()
evilChargebar:Load("gfx/effect_leviathanitemoverlay.anm2", true)
evilChargebar:Play("Idle")]]

local function useCard(_, _, player, flags)
    player:AddNullItemEffect(mod.ITEM.NULL.CORRUPTION_CARD_EFFECT)

    sfx:Play(SoundEffect.SOUND_THUMBSDOWN_AMPLIFIED) --likely placeholder
    hud:FlashChargeBar(player, 0)
    hud:FlashChargeBar(player, 1)
    sfx:Play(SoundEffect.SOUND_BEEP)
    mod:trySayAnnouncerLine(mod.Sounds.VACardSlayTheSpireCorruption, flags, 35)
end

mod:AddCallback(ModCallbacks.MC_USE_CARD, useCard, mod.ITEM.CARD.CORRUPTION)

mod.CorruptionBlacklist = {
    mod.ITEM.COLLECTIBLE.HOT_POTATO_BOOK
} --wow
local function getMaximumCharge(_, item, player, _, maxCharge)
    local effects = player:GetEffects()
    if effects:HasNullEffect(mod.ITEM.NULL.CORRUPTION_CARD_EFFECT) then
        if mod:Contains(mod.CorruptionBlacklist, item)  then --check for creative ai probably ):
            return
        end
        local iconfig = Isaac.GetItemConfig()
        local cc = iconfig:GetCollectible(item)

        local _, slot = mod:BeahCheckPlayerForActiveData(player, item)
        if cc.ChargeType == ItemConfig.CHARGE_NORMAL and maxCharge > 1 and slot <= 1 then
            return 1
        end
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_PLAYER_GET_ACTIVE_MAX_CHARGE, CallbackPriority.LATE, getMaximumCharge)

function mod:corruptionNewFloor(player)
    local effects = player:GetEffects()
    if effects:HasNullEffect(mod.ITEM.NULL.CORRUPTION_CARD_EFFECT) then
        local iconfig = Isaac.GetItemConfig()
        for i = 0, 1, 1 do
            local item = player:GetActiveItem(i)
            local cc = iconfig:GetCollectible(item)
            if cc and cc.ChargeType == ItemConfig.CHARGE_NORMAL then
                player:RemoveCollectible(item)
            end
        end

        effects:RemoveNullEffect(mod.ITEM.NULL.CORRUPTION_CARD_EFFECT)
    end
end

--render crazy chargebar
mod:AddCallback(ModCallbacks.MC_POST_PLAYERHUD_RENDER_ACTIVE_ITEM, function (_,player, slot, offset, alpha, scale, chargeOffset)
    if player:GetEffects():HasNullEffect(mod.ITEM.NULL.CORRUPTION_CARD_EFFECT) then
        local s = player:GetActiveMaxCharge(slot)
        if s == 1 and slot < 2 then
            local cbarSprite = hud:GetChargeBarSprite()
            local rPos = chargeOffset
            cbarSprite.Color = Color(1,1,1,1,0.8,0,0)
            cbarSprite:Play("BarOverlay1")
            cbarSprite:Render(rPos)
            cbarSprite.Color = Color(1,1,1)
        end
    end
end)