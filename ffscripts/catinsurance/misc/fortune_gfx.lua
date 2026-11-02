FiendFolio.NextFortuneGFX = nil

local game = Game()

function FiendFolio:GetFortuneOpacity()
    if FiendFolio.FortunePaperOpacity then
        return FiendFolio.FortunePaperOpacity / 10
    else
        return 1
    end
end

FiendFolio:AddCallback(ModCallbacks.MC_PRE_FORTUNE_DISPLAY, function ()
    local hud = game:GetHUD()
    local fortunePaper = hud:GetFortuneSprite()
    if FiendFolio.NextFortuneGFX then
        fortunePaper:ReplaceSpritesheet(0, FiendFolio.NextFortuneGFX, true)
        FiendFolio.NextFortuneGFX = nil
    else
        fortunePaper:ReplaceSpritesheet(0, "gfx/ui/effect_024.2_fortunepaper.png", true)
    end

    local opacity = FiendFolio:GetFortuneOpacity()
    fortunePaper.Color = Color(fortunePaper.Color.R, fortunePaper.Color.G, fortunePaper.Color.B, opacity)
end)