local mod = FiendFolio
local game = Game()

function mod:FossilizedEyePickupRender(pickup, offset)
    local itemConfig = Isaac.GetItemConfig():GetCard(pickup.SubType)
    if itemConfig and itemConfig:IsCard() then
        local curses = game:GetLevel():GetCurses()

        if not (curses == curses | mod.curses.veilCurse) and pickup.EntityCollisionClass > 0 then
            local icon = Sprite()
            icon.Color = Color(icon.Color.R, icon.Color.G, icon.Color.B, 0.7, icon.Color.RO, icon.Color.GO, icon.Color.BO)

            if itemConfig.HudAnim == "" then
                icon:Load("gfx/ui/ui_cardspills.anm2", true)
                icon:SetFrame("CardFronts", pickup.SubType)
            else
                icon:Load(itemConfig.ModdedCardFront:GetFilename(), true)
                icon:SetFrame(itemConfig.HudAnim, 0)
            end

            local renderPos = pickup.Position+Vector(0,-10)
            renderPos = Isaac.WorldToRenderPosition(renderPos) + offset
            icon:Render(renderPos, Vector.Zero, Vector.Zero)
        end
        
    end
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_PICKUP_RENDER, mod.ITEM.TRINKET.FOSSILIZED_EYE, mod.FossilizedEyePickupRender, PickupVariant.PICKUP_TAROTCARD)