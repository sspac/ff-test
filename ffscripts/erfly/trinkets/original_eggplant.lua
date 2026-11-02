local mod = FiendFolio
local game = Game()

mod.OriginalEggplantReplaced = nil

local function tryAddItemToEggplantTable(item,pickupType,position)
    mod.OriginalEggplantReplaced = mod.OriginalEggplantReplaced or {}
    local dontAdd
    for i = 1, #mod.OriginalEggplantReplaced do
        if mod.OriginalEggplantReplaced[i] then
            if mod.OriginalEggplantReplaced[i].Pos:Distance(position) < 2 then
                print("didn't add")
                dontAdd = true
                break
            end
        end
    end
    if not dontAdd then
        local config = Isaac.GetItemConfig()
        local itemsprite
        if pickupType == "Collectible" then
            itemsprite = config:GetCollectible(item).GfxFileName
        elseif pickupType == "Trinket" then
            itemsprite = config:GetTrinket(item).GfxFileName
        end
        table.insert(mod.OriginalEggplantReplaced, {
            Pos = position,
            Sprite = itemsprite,
        })
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, p)
    if mod.anyPlayerHas(mod.ITEM.TRINKET.ORIGINAL_EGGPLANT, true) then
        local shouldRoll
        for i = 1, #mod.ReferenceItems.Actives do
            if mod.ReferenceItems.Actives[i].ID == p.SubType then
                shouldRoll = true
                break
            end   
        end
        if not shouldRoll then
            for i = 1, #mod.ReferenceItems.Passives do
                if mod.ReferenceItems.Passives[i].ID == p.SubType then
                    shouldRoll = true
                    break
                end   
            end
        end
        if shouldRoll then
            tryAddItemToEggplantTable(p.SubType,"Collectible",p.Position)
            p:Morph(5,100, 0, true, false, false)
        end
    end
end, 100)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, p)
    if mod.anyPlayerHas(mod.ITEM.TRINKET.ORIGINAL_EGGPLANT, true) then
        local shouldRoll
        for i = 1, #mod.ReferenceItems.Trinkets do
            if mod.ReferenceItems.Trinkets[i].ID == p.SubType then
                tryAddItemToEggplantTable(p.SubType,"Trinket",p.Position)
                p:Morph(5,350, 0, true, false, false)
            end   
        end
        for i = 1, #mod.ReferenceItems.Rocks do
            if mod.ReferenceItems.Rocks[i].ID == p.SubType then
                tryAddItemToEggplantTable(p.SubType,"Trinket",p.Position)
                p:Morph(5,350,FiendFolio.GetGolemTrinket(), true, false, false)
            end   
        end
    end
end, 350)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    if mod.OriginalEggplantReplaced then
        SFXManager():Play(mod.Sounds.AmethystBreak, 0.5, 0, false, 0.75)
        for k = 1, #mod.OriginalEggplantReplaced do
            local sprite = Sprite()
            sprite:Load("gfx/005.100_collectible.anm2", true)
            sprite:ReplaceSpritesheet(1, mod.OriginalEggplantReplaced[k].Sprite)
            print(mod.OriginalEggplantReplaced[k].Sprite)
            sprite:SetFrame("Idle", 0)
            sprite:LoadGraphics()
            local usedPosition = mod.OriginalEggplantReplaced[k].Pos
            for i = 1, 120 do
                mod.scheduleForUpdate(function()
                    --wingedFont:GetStringWidth(str) * -3
                    local pos = game:GetRoom():WorldToScreenPosition(usedPosition) + Vector(0, -i/3)
                    local opacity
                    if i >= 30 then
                        opacity = 1 - ((i-30)/90)
                    else
                        opacity = i/30
                    end
                    opacity = opacity * 0.5
                    sprite.Color = Color(1,1,1,opacity)
                    sprite:Render(pos,Vector.Zero,Vector.Zero)
                end, i, ModCallbacks.MC_POST_RENDER)
            end
        end
        mod.OriginalEggplantReplaced = nil
    end
end)