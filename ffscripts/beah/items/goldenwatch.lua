local mod = FiendFolio
local sfx = SFXManager()

-- hi beah thank you for selling me the watch
--                          - hippocrunchy
-- no problem
--                          - beah et al.

--[[
local firerate = 2
local function goldenWatchTick(_, player)
    if not player:HasCollectible(mod.ITEM.COLLECTIBLE.GOLDEN_WATCH) then
        return
    end
    local p_data = mod:GetEntityData(player)
    local coins = math.min(50, player:GetNumCoins())
    if coins ~= p_data.ff_goldenWatchCoins then
        p_data.ff_goldenWatchCoins = coins
        p_data.ff_goldenWatchBuff = firerate - (coins*0.04)
        
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.COLLECTIBLE.GOLDEN_WATCH, goldenWatchTick)

local function buyItem(_, pickup, player, coins)
    local price = pickup.Price
    if price>0 or price == PickupPrice.PRICE_FREE or coins > 0 then    
        if player:HasCollectible(mod.ITEM.COLLECTIBLE.GOLDEN_WATCH) then
            player:RemoveCollectible(mod.ITEM.COLLECTIBLE.GOLDEN_WATCH)
            mod:SpawnItemPopup(mod.ITEM.COLLECTIBLE.GOLDEN_WATCH, 1, player.Position, player)

            sfx:Play(SoundEffect.SOUND_THUMBS_DOWN)
        end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PICKUP_SHOP_PURCHASE, mod.ITEM.COLLECTIBLE.GOLDEN_WATCH, buyItem)
]]

mod.ff_goldenWatchMult = 0.01

mod.ff_goldenWatchWhitelist = {
    [SlotVariant.BEGGAR] = ItemPoolType.POOL_BEGGAR,
    [SlotVariant.DEVIL_BEGGAR] = ItemPoolType.POOL_DEMON_BEGGAR,
    [SlotVariant.KEY_MASTER] = ItemPoolType.POOL_KEY_MASTER,
    [SlotVariant.BOMB_BUM] = ItemPoolType.POOL_BOMB_BUM,
    [SlotVariant.BATTERY_BUM] = ItemPoolType.POOL_BATTERY_BUM,
    [SlotVariant.ROTTEN_BEGGAR] = ItemPoolType.POOL_ROTTEN_BEGGAR,
    [mod.FF.ZodiacBeggar.Var] = mod.CustomPool.ZODIAC_BEGGAR,
    [mod.FF.Dealer.Var] = mod.CustomPool.CONTRABAND,
    [mod.FF.EvilBeggar.Var] = -1,
    [mod.FF.PokerTable.Var] = -1
}

local tempGoldenWatchState = 0
-- 0 = watch is in the inventory
-- 1 = same as 2 but the replace chance is decreased (it already respawned and wasn't taken)
-- 2 = watch sold, will now replace items with a money cost
-- 3 = watch sold, will now replace items with a health cost (devil beggar & evil beggar)

local holdUpWatchRange = 80
local devilValueIncrease = 50

local function giveWatch(_, slot, collider)
    if collider:ToPlayer() then
        local player = collider:ToPlayer()
        if not player:HasCollectible(mod.ITEM.COLLECTIBLE.GOLDEN_WATCH) then
            return
        end
        if mod.ff_goldenWatchWhitelist[slot.Variant] and not mod:GetEntityData(slot).givenGoldenWatch then
            if not mod:GetEntityData(slot).ff_goldenWatched then
                sfx:Play(SoundEffect.SOUND_FETUS_LAND)
                slot:SetState(6)
                local s = slot:GetSprite()
                s:ReplaceSpritesheet(2, "gfx/nothing.png")
                s:LoadGraphics()
                s:Play("PayPrize", true)
                mod:GetEntityData(slot).ff_goldenWatched = true

                local sd = mod:GetEntityData(player).ffsavedata.RunEffects
                sd.goldenWatchState = 2
                tempGoldenWatchState = 2

                -- Devil Beggar: special 25% chance to activate the evil beggar effect, telegraphed by black smoke
                if slot.Variant == SlotVariant.DEVIL_BEGGAR then
                    if mod:RandomInt(1,4,slot:GetDropRNG()) == 2 then
                        sd.goldenWatchState = 3
                        tempGoldenWatchState = 3
                        local poof = Isaac.Spawn(1000, EffectVariant.POOF01, 0, slot.Position, Vector.Zero, slot):ToEffect()
		                poof.Color = Color(0.2, 0.2, 0.2, 0.8, 0, 0, 0)
		                sfx:Play(SoundEffect.SOUND_DEVILROOM_DEAL, 0.8, 0, false, 1.5)
                    end
                end

                local custom = slot.Variant > 99
                if custom then
                    slot.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                    if slot.Variant == mod.FF.ZodiacBeggar.Var then
                        s:RemoveOverlay()
                    elseif slot.Variant == mod.FF.EvilBeggar.Var then
                        s:Play("PayNothing", true)
                        sd.goldenWatchState = 3
                        tempGoldenWatchState = 3
                        local poof = Isaac.Spawn(1000, EffectVariant.POOF01, 0, slot.Position, Vector.Zero, slot):ToEffect()
		                poof.Color = Color(0.2, 0.2, 0.2, 0.8, 0, 0, 0)
		                sfx:Play(SoundEffect.SOUND_DEVILROOM_DEAL, 0.8, 0, false, 1.5)
                    elseif slot.Variant == mod.FF.PokerTable.Var then
                        sd.goldenWatchState = 2
                    end
                end

                player:RemoveCollectible(mod.ITEM.COLLECTIBLE.GOLDEN_WATCH)
                mod:SpawnItemPopup(mod.ITEM.COLLECTIBLE.GOLDEN_WATCH, mod.ItemPopupSubtypes.BEGGAR_GIVE, slot.Position, player)
            end
            return false
        end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_PRE_SLOT_COLLISION, mod.ITEM.COLLECTIBLE.GOLDEN_WATCH, giveWatch)

local function liftWatch(player, slot)
    player:AnimateCollectible(mod.ITEM.COLLECTIBLE.GOLDEN_WATCH, "LiftItem", "PlayerPickup")
    mod:GetEntityData(player).ff_holdingWatchSlot = slot
end

local function lowerWatch(player)
    if player:IsHoldingItem() or string.find(player:GetSprite():GetAnimation(), "PickupWalk") then
        player:AnimateCollectible(mod.ITEM.COLLECTIBLE.GOLDEN_WATCH, "HideItem", "PlayerPickup")
    end
    mod:GetEntityData(player).ff_holdingWatchSlot = nil
end

local function slotWatchHold(_, slot)
    if not Game():GetRoom():IsClear() then return end
    for i=0, Game():GetNumPlayers()-1 do
		local player = Game():GetPlayer(i)
		local data = mod:GetEntityData(player)
        if player and player:Exists() and player:HasCollectible(mod.ITEM.COLLECTIBLE.GOLDEN_WATCH) then
            if mod.ff_goldenWatchWhitelist[slot.Variant] and not mod:GetEntityData(slot).ff_goldenWatched and slot:GetState() < 2 then
                local d = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'SlotData', tostring(slot.InitSeed), {})
                if data.ff_holdingWatchSlot and data.ff_holdingWatchSlot:ToSlot() and player.Position:Distance(data.ff_holdingWatchSlot.Position) > holdUpWatchRange then
                    lowerWatch(player)
                elseif not data.ff_holdingWatchSlot and player.Position:Distance(slot.Position) < holdUpWatchRange and not player:IsHoldingItem() 
                and not d.givenGoldenWatch then
                    liftWatch(player, slot)
                end
            end
        end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_SLOT_UPDATE, mod.ITEM.COLLECTIBLE.GOLDEN_WATCH, slotWatchHold)

mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, function (_, player, collectible)
    if mod:GetEntityData(player).ff_holdingWatchSlot then
        lowerWatch(player)
    end
end, mod.ITEM.COLLECTIBLE.GOLDEN_WATCH)

function mod:goldenWatchSlotUpdate(slot, data)
    if not data.ff_goldenWatched then return end
    local s = slot:GetSprite()
    local r = slot:GetDropRNG()

    -- Dealer: the watch will be resold near 99 cents, contraband reward is also buffed if you remembered to bring it
    if slot.Variant == mod.FF.Dealer.Var then
        local d = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'SlotData', tostring(slot.InitSeed), {})
        d.givenGoldenWatch = true
        if s:GetFrame() > 20 then
            slot.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        end
        if s:IsFinished("PayPrize") then
            s:Play("IdleLook", true)
            for i = 1, Game():GetNumPlayers() do
                local player = Game():GetPlayer(i-1)
                local sd = mod:GetEntityData(player).ffsavedata.RunEffects
                if sd then
                    sd.goldenWatchValue = sd.goldenWatchValue or 15
                    sd.goldenWatchValue = mod:RandomInt(7,math.max(7,sd.goldenWatchValue),r)
                    sd.goldenWatchValue = sd.goldenWatchValue*3
                    if not player:HasCollectible(CollectibleType.COLLECTIBLE_DEEP_POCKETS) then
                        sd.goldenWatchValue = math.min(sd.goldenWatchValue, 99-mod:RandomInt(0,14,r))
                    end
                    break
                end
            end
            data.ff_goldenWatched = false
        end
        return
        
    -- Evil Beggar: the watch will reappear in devil rooms/black markets instead of shops (buffing its value), no additional reward
    elseif slot.Variant == mod.FF.EvilBeggar.Var then
        local d = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'SlotData', tostring(slot.InitSeed), {})
        d.givenGoldenWatch = true
        if s:IsFinished("PayNothing") then
            slot.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            data.ff_goldenWatched = false
            s:Play("Prize")
        end

    -- Poker Table: bet the watch, if you win, poker table leaves instantly and you get the watch back with its value buffed
    elseif slot.Variant == mod.FF.PokerTable.Var then
        local d = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'SlotData', tostring(slot.InitSeed), {})
        d.givenGoldenWatch = true
        mod.scheduleForUpdate(function()
            slot.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        end, 30)
        data.ff_goldenWatched = false
    end

    if s:IsFinished("PayPrize") then
        s:Play("Prize", true)
    elseif s:IsFinished("Prize") then
        slot:SetState(4)
        s:Play("Teleport", true)
    elseif s:IsFinished("Teleport") then
        slot:Remove()
    end

    if s:IsEventTriggered("Prize") then
        sfx:Play(SoundEffect.SOUND_CASH_REGISTER)
        sfx:Play(SoundEffect.SOUND_SLOTSPAWN)
        local pool = ItemPoolType.POOL_BEGGAR
        if mod.ff_goldenWatchWhitelist[slot.Variant] then pool = mod.ff_goldenWatchWhitelist[slot.Variant] end
        local item
        if type(pool) == "table" then
            item = mod.GetItemFromCustomItemPool(pool, r)
        elseif pool > -1 then
            item = Game():GetItemPool():GetCollectible(pool, true, slot.DropSeed)
        end
        local freePos = Game():GetRoom():FindFreePickupSpawnPosition(slot.Position+Vector(0,40))
        if item then
            Isaac.Spawn(5, 100, item, freePos, Vector.Zero, slot):ToPickup()
        end

        -- STANDARD BEGGARS
        if slot.Variant == 4 then -- DEFAULT
            local nickels = 2
            for i = 1, Game():GetNumPlayers() do
                local player = Game():GetPlayer(i-1)
                local sd = mod:GetEntityData(player).ffsavedata.RunEffects

                -- regular beggars give more money as the watch value increases (strategically making it easier for you to repurchase the watch)
                if sd and sd.goldenWatchValue then
                    nickels = nickels + math.floor(sd.goldenWatchValue / 15)
                    break
                end
            end
            for i=1,nickels do
                Isaac.Spawn(5,20,2,freePos,RandomVector():Resized(2),slot)
            end
            for i=1,5 do
                Isaac.Spawn(5,20,1,freePos,RandomVector():Resized(2.5+(i*0.2)),slot)
            end
        elseif slot.Variant == 5 then -- DEVIL
            for i=1,4 do
                Isaac.Spawn(5,10,0,freePos,RandomVector():Resized(3),slot)
            end
            Isaac.Spawn(5,10,6,freePos,RandomVector():Resized(2),slot)
        elseif slot.Variant == 7 then -- KEY
            for i=1,4 do
                Isaac.Spawn(5,30,0,freePos,RandomVector():Resized(3),slot)
            end
            Isaac.Spawn(5,30,2,freePos,RandomVector():Resized(2),slot)
        elseif slot.Variant == 9 then -- BOMB
            for i=1,4 do
                Isaac.Spawn(5,40,0,freePos,RandomVector():Resized(3),slot)
            end
            if Isaac.GetPersistentGameData():Unlocked(Achievement.GOLDEN_BOMBS) then
                Isaac.Spawn(5,40,4,freePos,RandomVector():Resized(2),slot)
            end
        elseif slot.Variant == 13 then -- BATTERY
            for i=1,3 do
                Isaac.Spawn(5,90,0,freePos,RandomVector():Resized(3),slot)
            end
            if Isaac.GetPersistentGameData():Unlocked(Achievement.GOLDEN_BATTERY) then
                Isaac.Spawn(5,90,4,freePos,RandomVector():Resized(2),slot)
            end
        elseif slot.Variant == 18 then -- ROTTEN
            local bone = 0
            if Isaac.GetPersistentGameData():Unlocked(Achievement.BONE_HEARTS) then
                bone = 11
            end
            for i=1,2 do
                Isaac.Spawn(5,10,bone,freePos,RandomVector():Resized(3),slot)
            end
            for i=1,2 do
                Isaac.Spawn(5,10,12,freePos,RandomVector():Resized(3),slot)
            end
            Game():GetPlayer(0):AddBlueFlies(12, freePos, Game():GetPlayer(0))

        elseif slot.Variant == mod.FF.ZodiacBeggar.Var then -- ZODIAC
            for i=1,3 do
                Isaac.Spawn(5,301,0,freePos+Vector(40,0):Resized(40):Rotated(i*120),Vector.Zero,slot)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_SHOP_PURCHASE, function (_, pickup, player, spent)
    if player.QueuedItem.Item and player.QueuedItem.Item.ID == mod.ITEM.COLLECTIBLE.GOLDEN_WATCH then 
        local sd = mod:GetEntityData(player).ffsavedata.RunEffects
        local value = 0
        if spent >= 0 then
            value = spent
            sd.goldenWatchValue = value
        else
            sd.goldenWatchValue = sd.goldenWatchValue or 0
            sd.goldenWatchValue = sd.goldenWatchValue + devilValueIncrease
        end
        sd.goldenWatchState = 0
        tempGoldenWatchState = 0
    end
end, 100)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pedestal)
    if tempGoldenWatchState > 0 and pedestal:IsShopItem() then
        if tempGoldenWatchState == 3 and (pedestal.Price >= 0 or pedestal.Price < -20) then return
        elseif tempGoldenWatchState <= 2 and pedestal.Price < 0 then return end
        local chance = 3
        local r = pedestal:GetDropRNG()
        if tempGoldenWatchState == 1 then chance = 1 end
        if mod:RandomInt(1,4,r) <= chance then
            pedestal:Morph(5, 100, mod.ITEM.COLLECTIBLE.GOLDEN_WATCH, true, true, true)
            
            --pedestal.ShopItemId = -1
            pedestal.AutoUpdatePrice = false
            local sparkle = Isaac.Spawn(1000, 7003, 0, pedestal.Position, Vector.Zero, pedestal):ToEffect()
            sparkle.RenderZOffset = -5
            sparkle.SpriteOffset = Vector(-10, -10)

            if pedestal.Price > 0 and pedestal.Price <= 15 then
                pedestal.Price = pedestal.Price+mod:RandomInt(2,3,r)

                for i = 1, Game():GetNumPlayers() do
                    local player = Game():GetPlayer(i-1)
                    local sd = mod:GetEntityData(player).ffsavedata.RunEffects
                    sd.goldenWatchState = 1
                    if sd.goldenWatchValue and sd.goldenWatchValue >= 15 then
                        if tempGoldenWatchState == 1 then sd.goldenWatchValue = math.max(15,sd.goldenWatchValue-mod:RandomInt(7,15,r)) end
                        pedestal.Price = sd.goldenWatchValue+mod:RandomInt(7,math.max(7,sd.goldenWatchValue),r)
                        if not player:HasCollectible(CollectibleType.COLLECTIBLE_DEEP_POCKETS) then
                            pedestal.Price = math.min(pedestal.Price, 99-mod:RandomInt(0,14,r))
                        end
                        break
                    end
                end
            end
            tempGoldenWatchState = 0
        end
    end
end, PickupVariant.PICKUP_COLLECTIBLE)

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
	for i = 1, Game():GetNumPlayers() do
        local player = Game():GetPlayer(i-1)
        local sd = mod:GetEntityData(player).ffsavedata.RunEffects
        if sd and sd.goldenWatchState then
            if (sd.goldenWatchState >= 2) and tempGoldenWatchState == 0 then
                sd.goldenWatchState = 1
            end
            tempGoldenWatchState = sd.goldenWatchState
        end
    end
end)

if EID then
    EID:addDescriptionModifier("EID FF Golden Watch", function (descObj)
        if descObj.Entity and descObj.Entity.Type == 5 and descObj.Entity.Variant == 100 and descObj.Entity.SubType == mod.ITEM.COLLECTIBLE.GOLDEN_WATCH then
            local dmg = 0.0
            if descObj.Entity:ToPickup():IsShopItem() and descObj.Entity:ToPickup().Price >= 0 then 
                local price = descObj.Entity:ToPickup().Price
                dmg = 1.0+(price*mod.ff_goldenWatchMult)
                descObj.Description = "↑ "..price.."¢ -> x"..dmg.." Damage multiplier#" .. descObj.Description
            else
                for i = 1, Game():GetNumPlayers() do
                    local player = Game():GetPlayer(i-1)
                    local sd = mod:GetEntityData(player).ffsavedata.RunEffects
                    if sd and descObj.Entity:ToPickup():IsShopItem() and descObj.Entity:ToPickup().Price < 0 then
                        local value = sd.goldenWatchValue or 0
                        dmg = 1.0+((value+devilValueIncrease)*mod.ff_goldenWatchMult)
                        descObj.Description = "↑ x"..dmg.." Damage multiplier#" .. descObj.Description
                    elseif sd and sd.goldenWatchValue and sd.goldenWatchValue > 0 then
                        dmg = 1.0+(sd.goldenWatchValue*mod.ff_goldenWatchMult)
                        descObj.Description = "↑ x"..dmg.." Damage multiplier#" .. descObj.Description
                    end
                end
            end
        end

		return descObj
    end)
end

--item popup bs

function mod:SpawnItemPopup(item, type, pos, player)
    local itemConfig = Isaac.GetItemConfig():GetCollectible(item)
    local gfx = itemConfig.GfxFileName

    local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.FF.ItemPopup.Var, type, pos, Vector.Zero, player)
    local sprite = effect:GetSprite()
    sprite:ReplaceSpritesheet(0, gfx)
    sprite.LoadGraphics(sprite)
    effect.DepthOffset = 20
    --effect:Update()
    return effect
end

local startOffset,endOffest = Vector(0, -40), Vector(0, -65)
local moveSpeed, timeToRampUp, turnSpeed, minRadius, maxRadius = 24, 16, 32, 16, 160
local disHopDuration, heightOffGround = 20, -40

local color = Color(1, 1, 1, 0.835) local whitenedColour = Color(1, 1, 1, 0.835, 1, 1, 1)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function (_, effect)
    local e_data = mod:GetEntityData(effect)
    if effect.SubType == mod.ItemPopupSubtypes.STANDARD or effect.SubType == mod.ItemPopupSubtypes.STANDALONE_WITH_VEL then
        local mult = mod:ClampNumber((20/effect.FrameCount)/20, 0, 1)^0.4
        local velLerp = mod:Lerp(endOffest, startOffset, mult)
        if effect.SubType == mod.ItemPopupSubtypes.STANDALONE_WITH_VEL then
            velLerp = velLerp:Rotated(45*effect.Velocity.X*100)
        end
        effect.SpriteOffset = velLerp

        if effect.FrameCount > 20 then
            local flashMaster = (effect.FrameCount % 4)
            local shouldVis = flashMaster > 1
            
            effect.Visible = shouldVis
        end
        if effect.FrameCount > 35 then
            effect:Remove()
        end
        return
    end

    
    local p = effect.SpawnerEntity
    if not p then
        effect:Remove()
        return
    end
    if effect.SubType == mod.ItemPopupSubtypes.MOVE_TO_PLAYER then
        local moveSpeedMult = (effect.FrameCount / timeToRampUp)
        local angleMult = moveSpeedMult * 2/3

        moveSpeedMult =0.5 + (math.min(1,moveSpeedMult^2)/2)
        --[[angleMult = math.max(0.3, angleMult)*3
        mod:AngularMovementFunction(effect, p, moveSpeedMult*moveSpeed, angleMult*turnSpeed, 0.7)]]

        local d = effect.Position:Distance(p.Position)
        if d < maxRadius then
            if d < minRadius then
                effect:Remove()
                local trail = e_data.sw_itemNotifTrail
                mod.scheduleForUpdate(function ()
                    if trail then
                        trail:Remove()
                    end
                end, 10, ModCallbacks.MC_POST_UPDATE)
            else
                effect.Color = Color.Lerp(whitenedColour, color, (d-minRadius)/maxRadius)
            end
        end
        
        
        local v = (p.Position - effect.Position):Normalized():Resized(math.min(d, moveSpeed*moveSpeedMult))
        effect.Velocity = mod:Lerp(v, effect.Velocity, 0.9)
        return
    end
    if effect.SubType == mod.ItemPopupSubtypes.DIS_FUNNY_MOMENTS then
        local lerp = effect.FrameCount / disHopDuration
        if lerp > 1 then
            effect:Remove()
        else
            local pos = mod:Lerp(p.Position, e_data.sw_disTargetPos, lerp)
            effect.Velocity = pos - effect.Position
            
            e_data.sw_lastOffGroundThing = e_data.sw_lastOffGroundThing or Vector(0, 0)
            local hop = math.sin(lerp/(1/math.pi))
            local v = Vector(0, heightOffGround*hop)
            effect.SpriteOffset = effect.SpriteOffset + (v-e_data.sw_lastOffGroundThing)
            e_data.sw_lastOffGroundThing = v
            if lerp > 0.33 then
                local col = Color(1, 1, 1, 1, 1, 1, 1)
                effect.Color = Color.Lerp(effect.Color, col, 0.33)
                effect.SpriteScale = mod:Lerp(Vector(1, 1), Vector(0.66, 0.66), (lerp-0.33)/0.66)
            end
            local trail = e_data.sw_itemNotifTrail
            trail.ParentOffset = effect.SpriteOffset + Vector(0, -16)
        end
        return
    end
    if effect.SubType == mod.ItemPopupSubtypes.BEGGAR_GIVE then
        local vel = (effect.FrameCount/20)*2
        if effect.FrameCount < 5 then
            effect.SpriteOffset = Vector(0,-32)
            effect.SpriteScale = Vector(0.4,1.6)
        elseif effect.FrameCount < 11 then
            effect.SpriteOffset = Vector(0,-48)
            effect.SpriteScale = Vector(1,1)
        elseif effect.FrameCount < 20 then
            effect.SpriteOffset = Vector(0,-12+vel)
        else
            effect:Remove()
        end
    end
end, mod.FF.ItemPopup.Var)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function (_, effect)
    --if effect.SubType == mod.ItemPopupSubtypes.STANDARD then
        effect.Color = color
    --end
    if effect.SubType == mod.ItemPopupSubtypes.MOVE_TO_PLAYER or effect.SubType == mod.ItemPopupSubtypes.DIS_FUNNY_MOMENTS then
        effect.Velocity = RandomVector()*10
        
        local e_data = mod:GetEntityData(effect)
        e_data.sw_itemNotifTrail = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPRITE_TRAIL, 0, effect.Position, Vector.Zero, effect):ToEffect()
        e_data.sw_itemNotifTrail:FollowParent(effect)
    end
end, mod.FF.ItemPopup.Var)
