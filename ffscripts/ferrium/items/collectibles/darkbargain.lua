local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local bal = {
    Offset = Vector(0, -60),
    SpawnSpacing = 350,
    SpawnDist = 30,

    TargetVel = 13,
    Lerp = 0.35,
}

mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, function(_, id, _, _, _, _, player)
    local room = game:GetRoom()
    for i=1,4 do
        mod.scheduleForUpdate(function()
            local pos = room:FindFreePickupSpawnPosition(player.Position, 40, true, false)
            local penny = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 1, pos, Vector.Zero, player)
        end, i*2)
    end
end, mod.ITEM.COLLECTIBLE.DARK_BARGAIN)

function mod:DarkBargainNewLevel(room, level)
    local newItems = {}
    for i = 1, game:GetNumPlayers() do
		local player = Isaac.GetPlayer(i - 1)
        if player:HasCollectible(mod.ITEM.COLLECTIBLE.DARK_BARGAIN) then
            table.insert(newItems, player)
        end
    end

    local newPos = room:GetCenterPos()+bal.Offset
    for _,player in ipairs(newItems) do
        newPos = room:FindFreePickupSpawnPosition(newPos, 0, true, false)
        local ind = level:GetCurrentRoomDesc().SafeGridIndex

        local evilItem = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, mod.ITEM.COLLECTIBLE.DARK_BARGAIN, newPos, Vector.Zero, player):ToPickup()
        mod:GetEntityData(evilItem).DarkBargainTargetPlayer = player
        mod:GetEntityData(evilItem).DarkBargained = true
        mod:GetEntityData(player).ffsavedata.RunEffects.DarkBargainInfo = {Index = ind, id = mod.ITEM.COLLECTIBLE.DARK_BARGAIN}
        evilItem:RemoveCollectibleCycle()
        evilItem.ShopItemId = -2
        evilItem.Price = PickupPrice.PRICE_ONE_HEART
        evilItem.AutoUpdatePrice = false
    end
end

function mod:DarkBargainPreRoomExit()
    local laugh = true
    for _,item in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, mod.ITEM.COLLECTIBLE.DARK_BARGAIN, false, false)) do
        local d = mod:GetEntityData(item)
        if d.DarkBargained then
            if d.DarkBargainTargetPlayer and d.DarkBargainTargetPlayer:Exists() then
                local tab = mod:GetEntityData(d.DarkBargainTargetPlayer).ffsavedata.RunEffects.DarkBargainInfo
                if tab then
                    if laugh then
                        sfx:Play(SoundEffect.SOUND_SATAN_GROW, 0.4, 0, false, 1)
                        laugh = false
                    end
                    tab.KeepTheContract = true
                end
            end
            item:Remove()
        elseif d.DarkBargainedMovement then
            item:Remove()
        end
    end
end

function mod:DarkBargainNewRoom(player, data, room, level)
    local d = data.ffsavedata.RunEffects
    mod.scheduleForUpdate(function()
        if d.DarkBargainInfo and d.DarkBargainInfo.Index and d.DarkBargainInfo.Index == level:GetCurrentRoomIndex() then
            for _,item in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, mod.ITEM.COLLECTIBLE.DARK_BARGAIN, false, false)) do
                local id = mod:GetEntityData(item)
                if not id.DarkBargained then
                    id.DarkBargainTargetPlayer = player
                    id.DarkBargained = true
                end
            end
        end

        if d.DarkBargainInfo and d.DarkBargainInfo.KeepTheContract then
            local new = level:GetCurrentRoomDesc().SafeGridIndex
            local old = d.DarkBargainInfo.Index
            local xCheck = (old % 13) - (new % 13)
            local vec = Vector.Zero
            if xCheck < 0 then
                vec.X = -bal.SpawnSpacing
            elseif xCheck > 0 then
                vec.X = bal.SpawnSpacing
            end
            local yCheck = math.floor(old/13) - math.floor(new/13)
            if yCheck < 0 then
                vec.Y = -bal.SpawnSpacing
            elseif yCheck > 0 then
                vec.Y = bal.SpawnSpacing
            end
            local pos = player.Position+vec
            d.DarkBargainInfo.Index = new
            --[[local evilItem = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, d.DarkBargainInfo.id, pos, Vector.Zero, player):ToPickup()
            evilItem.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
            evilItem.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            mod:GetEntityData(evilItem).DarkBargainedMovement = true
            mod:GetEntityData(evilItem).DarkBargainTargetPlayer = player
            mod:GetEntityData(evilItem).DarkBargainVel = 0
            mod:GetEntityData(evilItem).DarkBargainPos = pos
            evilItem.Position = pos
            evilItem.PositionOffset = Vector(0,-15)
            evilItem.Price = PickupPrice.PRICE_ONE_HEART
            evilItem.AutoUpdatePrice = false
            evilItem.ShopItemId = -1]]

            local e = Isaac.Spawn(mod.FF.DarkBargainFakeItem.ID, mod.FF.DarkBargainFakeItem.Var, mod.FF.DarkBargainFakeItem.Sub, pos, Vector.Zero, player):ToEffect()
            mod:GetEntityData(e).DarkBargainTargetPlayer = player
            e.SpriteOffset = Vector(0, -15)
        end
    end, 1)
end
mod:AddCollectibleCallback("FF_NEW_ROOM_PLAYER_FERRIUM", mod.ITEM.COLLECTIBLE.DARK_BARGAIN, mod.DarkBargainNewRoom)

local priceToFrame = {
    [PickupPrice.PRICE_ONE_HEART] = 0,
    [PickupPrice.PRICE_TWO_HEARTS] = 1,
    [PickupPrice.PRICE_THREE_SOULHEARTS] = 2,
    [PickupPrice.PRICE_ONE_HEART_AND_TWO_SOULHEARTS] = 3,
    [PickupPrice.PRICE_SOUL] = 4,
    [PickupPrice.PRICE_ONE_SOUL_HEART] = 5,
    [PickupPrice.PRICE_TWO_SOUL_HEARTS] = 6,
    [PickupPrice.PRICE_ONE_HEART_AND_ONE_SOUL_HEART] = 7,
    [PickupPrice.PRICE_FREE] = 8,
    [0] = 8,
}

function mod:DarkBargainFakeItem(e)
    local sprite = e:GetSprite()
    local d = mod:GetEntityData(e)

    if not d.init then
        sprite:PlayOverlay("PriceOverlay", true)
        sprite:StopOverlay()
        d.Price = PickupPrice.PRICE_ONE_HEART
        d.init = true
    end

    if d.DarkBargainTargetPlayer and d.DarkBargainTargetPlayer:Exists() then
        local player = d.DarkBargainTargetPlayer
        local skeleton = player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN
        if player:HasTrinket(TrinketType.TRINKET_YOUR_SOUL) then
            d.Price = PickupPrice.PRICE_SOUL
        elseif player:GetMaxHearts() > 0 or skeleton then
            if player:GetMaxHearts() > 2 then
                d.Price = PickupPrice.PRICE_ONE_HEART
            else
                if player:GetEffectiveMaxHearts() > 2 or player:GetSoulHearts() > 0 then
                    d.Price = PickupPrice.PRICE_ONE_HEART
                else
                    d.Price = 0
                end
            end
        else
            local bone = player:GetPlayerType() == PlayerType.PLAYER_BLUEBABY
            local blue = player:GetEffectiveMaxHearts() > 0
            if player:GetSoulHearts() > 4 then
                if blue then
                    d.Price = PickupPrice.PRICE_ONE_SOUL_HEART
                else
                    d.Price = PickupPrice.PRICE_TWO_SOUL_HEARTS
                end
            elseif player:GetSoulHearts() > 2 then
                d.Price = PickupPrice.PRICE_ONE_SOUL_HEART
            else
                if bone then
                    d.Price = PickupPrice.PRICE_ONE_SOUL_HEART
                else
                    d.Price = 0
                end
            end
        end

        e.Velocity = mod:Lerp(e.Velocity, (player.Position-e.Position):Resized(bal.TargetVel), bal.Lerp)

        if e.Position:Distance(player.Position) < bal.SpawnDist and player:IsExtraAnimationFinished() then
            local evilItem = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, mod.ITEM.COLLECTIBLE.DARK_BARGAIN, player.Position, Vector.Zero, e):ToPickup()
            evilItem.TargetPosition = player.Position
            evilItem.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
            evilItem.Price = d.Price
            evilItem.AutoUpdatePrice = false
            evilItem.ShopItemId = -1
            evilItem.Visible = false
            evilItem:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            evilItem:RemoveCollectibleCycle()
            mod:GetEntityData(evilItem).RemoveIfEmpty = true
            mod:GetEntityData(player).ffsavedata.RunEffects.DarkBargainInfo = nil
            for i=1,100 do
                evilItem:Update()
                evilItem.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
                evilItem.TargetPosition = player.Position
                evilItem.Position = player.Position
            end
            e:Remove()
        end
    else
        e:Remove()
    end

    sprite:SetOverlayFrame("PriceOverlay", priceToFrame[d.Price])

    if e.Visible and e.FrameCount % 2 == 0 then
        local rng = e:GetDropRNG()
        local vel = Vector(0, mod:RandomInt(10, 13, rng)/5):Rotated(rng:RandomInt(360))
        local poof = Isaac.Spawn(1000, mod.FF.WhiteTrailEffect.Var, mod.FF.WhiteTrailEffect.Sub, e.Position, vel, e):ToEffect()
        poof.Color = Color(0, 0, 0, 1)
        poof.Parent = e
        poof:SetTimeout(14+rng:RandomInt(8))
        local size = 0.3+mod:RandomInt(5,9,rng)/10
        poof.SpriteScale = Vector(size, size)
        mod:GetEntityData(poof).Deccel = 0.92
        mod:GetEntityData(poof).ShrinkDelay = 4
        poof.SpriteOffset = Vector(0, -15)
        poof.DepthOffset = -100
        poof:Update()
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
    local data = mod:GetEntityData(pickup)

    if data.RemoveIfEmpty then
        if pickup.SubType == 0 then
            pickup:Remove()
        end
    end

    --[[if data.DarkBargainedMovement then
        local sprite = pickup:GetSprite()
        if data.DarkBargainTargetPlayer and data.DarkBargainTargetPlayer:Exists() and pickup.SubType > 0 then
            local player = data.DarkBargainTargetPlayer
            if pickup.Price ~= 0 then
                local skeleton = player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN
                if player:HasTrinket(TrinketType.TRINKET_YOUR_SOUL) then
                    pickup.Price = PickupPrice.PRICE_SOUL
                elseif player:GetMaxHearts() > 0 or skeleton then
                    if player:GetMaxHearts() > 2 then
                        pickup.Price = PickupPrice.PRICE_ONE_HEART
                    else
                        if player:GetEffectiveMaxHearts() > 2 or player:GetSoulHearts() > 0 then
                            pickup.Price = PickupPrice.PRICE_ONE_HEART
                        else
                            pickup.Price = 0
                        end
                    end
                else
                    local bone = player:GetPlayerType() == PlayerType.PLAYER_BLUEBABY
                    local blue = player:GetEffectiveMaxHearts() > 0
                    if player:GetSoulHearts() > 4 then
                        if blue then
                            pickup.Price = PickupPrice.PRICE_ONE_SOUL_HEART
                        else
                            pickup.Price = PickupPrice.PRICE_TWO_SOUL_HEARTS
                        end
                    elseif player:GetSoulHearts() > 2 then
                        pickup.Price = PickupPrice.PRICE_ONE_SOUL_HEART
                    else
                        if bone then
                            pickup.Price = PickupPrice.PRICE_ONE_SOUL_HEART
                        else
                            pickup.Price = 0
                        end
                    end
                end
            else
                sprite:Play("ShopIdle", true)
                sprite:RemoveOverlay()
            end

            local room = game:GetRoom()
            if pickup.Visible and room:GetFrameCount() > 12 and pickup.FrameCount % 2 == 0 then
                local rng = pickup:GetDropRNG()
                local vel = Vector(0, mod:RandomInt(10, 13, rng)/5):Rotated(rng:RandomInt(360))
                local poof = Isaac.Spawn(1000, mod.FF.WhiteTrailEffect.Var, mod.FF.WhiteTrailEffect.Sub, pickup.Position, vel, pickup):ToEffect()
                poof.Color = Color(0, 0, 0, 1)
                poof.Parent = pickup
                poof:SetTimeout(14+rng:RandomInt(8))
                local size = 0.3+mod:RandomInt(5,9,rng)/10
                poof.SpriteScale = Vector(size, size)
                mod:GetEntityData(poof).Deccel = 0.92
                mod:GetEntityData(poof).ShrinkDelay = 4
                poof.SpriteOffset = Vector(0, -15)
                poof.DepthOffset = -100
                poof:Update()
            end
        else
            pickup:Remove()
        end
    else]]
    if pickup.SubType == mod.ITEM.COLLECTIBLE.DARK_BARGAIN then
        local sprite = pickup:GetSprite()
        if data.DarkBargained and data.DarkBargainTargetPlayer then
            if data.DarkBargainTargetPlayer:Exists() then
                local offset = Vector(0, -10)
                if sprite:GetAnimation() ~= "ShopIdle" then
                    offset = Vector(0, -25)
                end
                if pickup.FrameCount % 3 == 0 then
                    local baseVel = data.DarkBargainTargetPlayer.Position-pickup.Position
                    local rng = pickup:GetDropRNG()
                    local vel = baseVel:Rotated(mod:RandomInt(-14,14,rng)):Resized(mod:RandomInt(17, 22, rng)/5)
                    local poof = Isaac.Spawn(1000, mod.FF.WhiteTrailEffect.Var, mod.FF.WhiteTrailEffect.Sub, pickup.Position, vel, pickup):ToEffect()
                    poof.Color = Color(0, 0, 0, 1)
                    poof.Parent = pickup
                    poof:SetTimeout(14+rng:RandomInt(8))
                    local size = 0.3+mod:RandomInt(5,9,rng)/10
                    poof.SpriteScale = Vector(size, size)
                    mod:GetEntityData(poof).Deccel = 0.99
                    mod:GetEntityData(poof).ShrinkDelay = 3
                    poof.SpriteOffset = offset
                    poof.DepthOffset = -100
                    poof:Update()
                end

                if pickup.FrameCount % 5 == 0 then
                    local rng = pickup:GetDropRNG()
                    local vel = Vector(0, mod:RandomInt(10, 13, rng)/5):Rotated(rng:RandomInt(360))
                    local poof = Isaac.Spawn(1000, mod.FF.WhiteTrailEffect.Var, mod.FF.WhiteTrailEffect.Sub, pickup.Position, vel, pickup):ToEffect()
                    poof.Color = Color(0, 0, 0, 1)
                    poof.Parent = pickup
                    poof:SetTimeout(14+rng:RandomInt(8))
                    local size = 0.3+mod:RandomInt(5,9,rng)/10
                    poof.SpriteScale = Vector(size, size)
                    mod:GetEntityData(poof).Deccel = 0.92
                    mod:GetEntityData(poof).ShrinkDelay = 4
                    poof.SpriteOffset = offset
                    poof.DepthOffset = -100
                    poof:Update()
                end

                if pickup.Price ~= 0 then
                    local player = data.DarkBargainTargetPlayer
                    local skeleton = player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN
                    if player:HasTrinket(TrinketType.TRINKET_YOUR_SOUL) then
                        pickup.Price = PickupPrice.PRICE_SOUL
                    elseif player:GetMaxHearts() > 0 or skeleton then
                        if player:GetMaxHearts() > 2 then
                            pickup.Price = PickupPrice.PRICE_ONE_HEART
                        else
                            if player:GetEffectiveMaxHearts() > 2 or player:GetSoulHearts() > 0 then
                                pickup.Price = PickupPrice.PRICE_ONE_HEART
                            else
                                pickup.Price = 0
                            end
                        end
                    else
                        local bone = player:GetPlayerType() == PlayerType.PLAYER_BLUEBABY
                        local blue = player:GetEffectiveMaxHearts() > 0
                        if player:GetSoulHearts() > 4 then
                            if blue then
                                pickup.Price = PickupPrice.PRICE_ONE_SOUL_HEART
                            else
                                pickup.Price = PickupPrice.PRICE_TWO_SOUL_HEARTS
                            end
                        elseif player:GetSoulHearts() > 2 then
                            pickup.Price = PickupPrice.PRICE_ONE_SOUL_HEART
                        else
                            if bone then
                                pickup.Price = PickupPrice.PRICE_ONE_SOUL_HEART
                            else
                                pickup.Price = 0
                            end
                        end
                    end
                end
            else
                pickup:Remove()
            end
        end
    end
end, PickupVariant.PICKUP_COLLECTIBLE)