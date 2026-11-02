local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

FiendFolio.AddItemPickupCallback(function(player, added)
    sfx:Play(SoundEffect.SOUND_VAMP_DOUBLE, 1, 0, false, 1)
    --player:SetColor(Color(0.3,0.75,0.3,1,0,0.2,0), -1, 9, false, false)
end, nil, FiendFolio.ITEM.COLLECTIBLE.JUMBO_JOSH)

--The RedJumboJosh was a mistake but eh fuck it, it's funny

--[[function mod:playerEnsureRedJumboJoshColor(player, d)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.JUMBO_JOSH) then
        d.tryUpdateColor = Color(0.3,0.75,0.3,1,0,0.2,0)
    end
end

function mod:playerEnsureRedJumboJoshColorDelayed(player)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.JUMBO_JOSH) then
        local d = mod:GetEntityData(player)
        d.tryUpdateColorTimer = {Color(0.3,0.75,0.3,1,0,0.2,0), 10}
    end
end]]

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
    if pickup.SubType == FiendFolio.ITEM.COLLECTIBLE.JUMBO_JOSH then
        local sprite = pickup:GetSprite()
        local anim = sprite:GetAnimation()
        local anim2 = sprite:GetOverlayFrame()
        sprite:Load("gfx/items/item_pedestal_64x.anm2", true)
        sprite:ReplaceSpritesheet(1, "gfx/items/collectibles/hi_jumbo_jush_true.png")
        sprite:LoadGraphics()
        sprite:Play(anim,true)
        sprite:SetOverlayFrame("Alternates",anim2)
        sprite:Update()
    end
end, PickupVariant.PICKUP_COLLECTIBLE)