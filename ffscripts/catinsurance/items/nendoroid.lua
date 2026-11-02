local mod = FiendFolio

local extraItem = Sprite("gfx/effects/nendoroid.anm2", true)

---@param collider Entity
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function (_, pickup, collider)
    if pickup.SubType == mod.ITEM.COLLECTIBLE.NENDOROID and not pickup.Touched and pickup.Wait == 0 then
        local player = collider:ToPlayer()
        if player and player:IsExtraAnimationFinished() then
            Isaac.CreateTimer(function ()
                player:FlushQueueItem()
            end, 1, 1, true)
        end
    end
end, PickupVariant.PICKUP_COLLECTIBLE)

---@param player EntityPlayer
function mod:NendoroidUpdate()
    for _, player in ipairs(PlayerManager.GetPlayers()) do
        if player:HasCollectible(mod.ITEM.COLLECTIBLE.NENDOROID) then
            player.Visible = false

            local renderPos = Isaac.WorldToScreen(player.Position) - Vector(0, 20)
            local data = mod:GetEntityData(player)
            local nendoroid = data.Nendoroid
            if not nendoroid then
                data.Nendoroid = Sprite("gfx/effects/nendoroid.anm2", true)
                data.Nendoroid:Play("Init")
                data.NendoroidNoPickup = true
                nendoroid = data.Nendoroid
            end

            nendoroid:Render(renderPos)
            if player.FrameCount % 2 == 0 then
                nendoroid:Update()
            end
            
            local sprite = player:GetSprite()
            local held = player.QueuedItem.Item and player.QueuedItem.Item.ID
            if sprite:GetAnimation():match("Pickup") and not data.NendoroidNoPickup and held then
                if sprite:GetFrame() == 0 then
                    nendoroid:Play("Pickup")
                end

                if held and held == CollectibleType.COLLECTIBLE_MOMS_KNIFE then
                    local hold = nendoroid:GetNullFrame("hold"):GetPos()
                    extraItem:SetFrame("Knife", 0)
                    data.NendoroidKnife = true
                    extraItem:Render(renderPos + hold)
                elseif held and held == CollectibleType.COLLECTIBLE_GUPPYS_HEAD then
                    local hold = nendoroid:GetNullFrame("hold"):GetPos()
                    extraItem:SetFrame("Cat", 0)
                    extraItem:Render(renderPos + hold)
                    
                    if not data.NendoroidFly then
                        data.NendoroidFly = true
                        player:AddBlueFlies(3, player.Position, player)
                    end
                end
            elseif sprite:GetAnimation() == "Trapdoor" then
                if sprite:GetFrame() == 0 then
                    nendoroid:Play("Trapdoor")
                end
            elseif sprite:GetAnimation() == "Appear" then
                nendoroid:Play("Cry") 
            elseif not nendoroid:IsPlaying("Init") then
                if data.NendoroidKnife then
                    nendoroid:Play("HoldKnife")
                else
                    nendoroid:Play("Idle", true)
                end

                if not sprite:GetAnimation():match("Pickup") then
                    data.NendoroidNoPickup = nil
                end

                if data.NendoroidFly then
                    data.NendoroidFly = nil
                end
            else
                local hold = nendoroid:GetNullFrame("hold"):GetPos()
                extraItem:SetFrame("Smile", 0)
                extraItem:Render(renderPos + hold)
            end
        end

    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_RENDER, mod.ITEM.COLLECTIBLE.NENDOROID, mod.NendoroidUpdate, PlayerVariant.PLAYER)

function mod:NendoroidNewFloor()
    for _, player in ipairs(PlayerManager.GetPlayers()) do
        local data = mod:GetEntityData(player)
        data.NendoroidKnife = nil
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.ITEM.COLLECTIBLE.NENDOROID, mod.NendoroidNewFloor)

function mod:NendoroidFly(fam)
    if fam.FrameCount == 0 then
        fam.Color = Color(fam.Color.R, fam.Color.G, fam.Color.B, 0)
    end
    fam:GetSprite():SetFrame(0)
    fam.Color = Color.Lerp(fam.Color, Color(fam.Color.R, fam.Color.G, fam.Color.B, 1), 0.1)
end
mod:AddCollectibleCallback(ModCallbacks.MC_PRE_FAMILIAR_RENDER, mod.ITEM.COLLECTIBLE.NENDOROID, mod.NendoroidFly, FamiliarVariant.BLUE_FLY)

function mod:NendoroidTrapdoor()
    for _, trapdoor in ipairs(Isaac.FindByType(1000, StageAPI.E.Trapdoor.V)) do
        local sprite = trapdoor:GetSprite()
        if sprite:GetLayer(0):GetSpritesheetPath() ~= "gfx/grid/door_20_secrettrapdoor.png" then
            sprite:ReplaceSpritesheet(0, "gfx/grid/door_20_secrettrapdoor.png", true)
        end
    end

    local room = Game():GetRoom()
    for i = 0, room:GetGridSize() do
        local grid = room:GetGridEntity(i)
        if grid and grid:GetType() == GridEntityType.GRID_TRAPDOOR then
            if grid:GetVariant() == 0 then
                grid:GetSprite():ReplaceSpritesheet(0, "gfx/grid/door_20_secrettrapdoor.png", true)
            end
        end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_UPDATE, mod.ITEM.COLLECTIBLE.NENDOROID, mod.NendoroidTrapdoor)