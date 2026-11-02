local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

function mod:fuzzyPicklePlayerUpdate(player)
    if player:HasTrinket(mod.ITEM.TRINKET.FUZZY_PICKLE) then
        local data = mod:GetEntityData(player)
        local heldItem = player.QueuedItem.Item
        if heldItem and (heldItem:IsCollectible() or heldItem:IsTrinket()) then
            data.lastHeldItemFuzzPickID = {heldItem.ID, heldItem:IsCollectible()}
        else
            if data.lastHeldItemFuzzPickID then
                local itemIsReference
                local itemIsNOTReference
                local partialRef
                if data.lastHeldItemFuzzPickID[2] then
                    --print("checking items")
                    for i = 1, #mod.ReferenceItems.Actives do
                        if mod.ReferenceItems.Actives[i].ID == data.lastHeldItemFuzzPickID[1] then
                            itemIsReference = mod.ReferenceItems.Actives[i].Reference
                            partialRef = mod.ReferenceItems.Actives[i].Partial
                            itemIsNOTReference = mod.ReferenceItems.Actives[i].NotReference
                            break
                        end
                    end
                    if not itemIsReference then
                        for i = 1, #mod.ReferenceItems.Passives do
                            if mod.ReferenceItems.Passives[i].ID == data.lastHeldItemFuzzPickID[1] then
                                itemIsReference = mod.ReferenceItems.Passives[i].Reference
                                partialRef = mod.ReferenceItems.Passives[i].Partial
                                itemIsNOTReference = mod.ReferenceItems.Passives[i].NotReference
                                break
                            end
                        end
                    end
                else
                    --print("checking trinkets")
                    for i = 1, #mod.ReferenceItems.Trinkets do
                        if mod.ReferenceItems.Trinkets[i].ID == data.lastHeldItemFuzzPickID[1] then
                            itemIsReference = mod.ReferenceItems.Trinkets[i].Reference
                            partialRef = mod.ReferenceItems.Trinkets[i].Partial
                            itemIsNOTReference = mod.ReferenceItems.Trinkets[i].NotReference
                            break
                        end
                    end
                    if not itemIsReference then
                        for i = 1, #mod.ReferenceItems.Rocks do
                            if mod.ReferenceItems.Rocks[i].ID == data.lastHeldItemFuzzPickID[1] then
                                itemIsReference = mod.ReferenceItems.Rocks[i].Reference
                                partialRef = mod.ReferenceItems.Rocks[i].Partial
                                itemIsNOTReference = mod.ReferenceItems.Rocks[i].NotReference
                                break
                            end
                        end
                    end
                end
                if itemIsReference then
                    local str = {partialRef and "This item references" or "This item is a reference to", itemIsReference}
                    if itemIsNOTReference then
                        str = {partialRef and "This item DOESN'T reference" or "This item is NOT a reference to", itemIsReference}
                        sfx:Play(mod.Sounds.NitroExpired, 1, 0, false, math.random(65,75)/100)
                    else
                        sfx:Play(mod.Sounds.NitroActive, 1, 0, false, math.random(65,75)/100)
                    end
                    for i = 1, 120 do
                        mod.scheduleForUpdate(function()
                            for k = 1, 2 do
                                local pos = game:GetRoom():WorldToScreenPosition(player.Position) + Vector(mod.TempestFont:GetStringWidth(str[k]) * -0.5, -(player.SpriteScale.Y * 35) - i/3 - 15)
                                local opacity
                                local cap = 90
                                if i >= cap then
                                    opacity = 1 - ((i-cap)/30)
                                else
                                    opacity = i/cap
                                end
                                --Isaac.RenderText(str, pos.X, pos.Y, 1, 1, 1, opacity)
                                mod.TempestFont:DrawString(str[k], pos.X, pos.Y + (12 * k), KColor(1,1,1,opacity), 0, false)
                            end
                        end, i, ModCallbacks.MC_POST_RENDER)
                    end
                end
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
                player:EvaluateItems()
                data.lastHeldItemFuzzPickID = nil
            end
        end
    end
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.ITEM.TRINKET.FUZZY_PICKLE, mod.fuzzyPicklePlayerUpdate)

mod:AddCallback(ModCallbacks.MC_EVALUATE_STAT, function(_, player, stage, dmg)
	if player:HasTrinket(mod.ITEM.TRINKET.FUZZY_PICKLE) then
        local referenceCount = 0
        for i = 1, #mod.ReferenceItems.Actives do
            if not mod.ReferenceItems.Actives[i].NotReference then
                referenceCount = referenceCount + (player:GetCollectibleNum(mod.ReferenceItems.Actives[i].ID) * (mod.ReferenceItems.Actives[i].Partial and 0.5 or 1) * 5)
            end
        end
        for i = 1, #mod.ReferenceItems.Passives do
            if not mod.ReferenceItems.Passives[i].NotReference then
                referenceCount = referenceCount + (player:GetCollectibleNum(mod.ReferenceItems.Passives[i].ID) * (mod.ReferenceItems.Passives[i].Partial and 0.5 or 1) * 1)
            end
        end
        for i = 1, #mod.ReferenceItems.Trinkets do
            if not mod.ReferenceItems.Trinkets[i].NotReference then
                referenceCount = referenceCount + (player:GetTrinketMultiplier(mod.ReferenceItems.Trinkets[i].ID) * (mod.ReferenceItems.Trinkets[i].Partial and 0.5 or 1) * 2.5)
            end
        end
        for i = 1, #mod.ReferenceItems.Rocks do
            if not mod.ReferenceItems.Rocks[i].NotReference then
                referenceCount = referenceCount + (mod.GetGolemTrinketPower(player, mod.ReferenceItems.Rocks[i].ID) * (mod.ReferenceItems.Rocks[i].Partial and 0.5 or 1) * 2.5)
            end
        end
        --print(referenceCount)
        dmg = dmg + (referenceCount * 0.1)
        return dmg
    end
end, EvaluateStatStage.FLAT_DAMAGE)