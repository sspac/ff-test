local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player, flags)
    local d = mod:GetEntityData(player)
    d.holdingFFItem = cardID
    d.holdingFFItemSlot = "card"
    player:AnimateCard(cardID, "LiftItem")
end, FiendFolio.ITEM.CARD.DARK_HOLE)

function mod:useHeldDarkHole(player, data, aim)
    sfx:Play(mod.Sounds.YgoCard, 1, 0, false, 1)
    local blackHole = Isaac.Spawn(1000,107,0,player.Position, aim:Resized(25),player):ToEffect()
    local sprite = blackHole:GetSprite()
    sprite:ReplaceSpritesheet(0, "gfx/effects/effect_dark_hole.png")
    sprite:ReplaceSpritesheet(1, "gfx/effects/effect_dark_hole_item.png")
    sprite:LoadGraphics()
    data.HoldingFFItemBlankVisual = true
end