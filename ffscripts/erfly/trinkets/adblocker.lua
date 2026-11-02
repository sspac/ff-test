local mod = FiendFolio
local game = Game()

mod.AdBlockerOverlayBlacklist = {
    [Giantbook.SLEEP] = true,
    [Giantbook.SLEEP_NIGHTMARE] = true,
}

function mod:adBlocked(returnedP)
    if (not returnedP)
    or (returnedP and returnedP:ToPlayer() and not returnedP:ToPlayer():HasTrinket(mod.ITEM.TRINKET.ADBLOCKER))
    then
        local anyPlayerWithAdblocker = mod.anyPlayerHas(mod.ITEM.TRINKET.ADBLOCKER, true, nil, nil, true)
        if anyPlayerWithAdblocker then
            returnedP = anyPlayerWithAdblocker
        else
            returnedP = Isaac.GetPlayer()
        end
    end
    local str = "Popup blocked!"
    local wingedFont = Font()
    wingedFont:Load("font/pftempestasevencondensed.fnt")
    SFXManager():Play(SoundEffect.SOUND_BEEP,1,0,false,math.random(5,20)/100)
    for i = 1, 60 do
        mod.scheduleForUpdate(function()
            --wingedFont:GetStringWidth(str) * -3
            local pos = game:GetRoom():WorldToScreenPosition(returnedP.Position) + Vector(wingedFont:GetStringWidth(str) * -0.5, -(returnedP.SpriteScale.Y * 35) - i/3)
            local opacity
            if i >= 30 then
                opacity = 1 - ((i-30)/30)
            else
                opacity = i/30
            end
            --Isaac.RenderText(str, pos.X, pos.Y, 1, 1, 1, opacity)
            wingedFont:DrawString(str, pos.X, pos.Y, KColor(1,1,1,opacity), 0, false)
        end, i, ModCallbacks.MC_POST_RENDER)
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_FORTUNE_DISPLAY, function()
    local anyPlayerWithAdblocker = mod.anyPlayerHas(mod.ITEM.TRINKET.ADBLOCKER, true, nil, nil, true)
    if anyPlayerWithAdblocker then
        mod:adBlocked(anyPlayerWithAdblocker)
        return false
    end
end)

mod:AddCallback(ModCallbacks.MC_PRE_ITEM_OVERLAY_SHOW, function(_, giantbook)
    local anyPlayerWithAdblocker = mod.anyPlayerHas(mod.ITEM.TRINKET.ADBLOCKER, true, nil, nil, true)
    if anyPlayerWithAdblocker and not mod.AdBlockerOverlayBlacklist[giantbook] then
        mod:adBlocked(anyPlayerWithAdblocker)
        return true
    end
end)