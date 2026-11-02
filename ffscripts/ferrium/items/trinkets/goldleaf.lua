local mod = FiendFolio
local sfx = SFXManager()

local coinGain = 9

local function CanBeBought(pickup, player)
    return pickup.Price == PickupPrice.PRICE_FREE or (pickup.Price >= 0 and player:GetNumCoins() >= pickup.Price)
end

local function DoTheFXStuff(pickup)
    local rng = pickup:GetDropRNG()
    sfx:Play(SoundEffect.SOUND_CASH_REGISTER, 1, 0, false, 1)
    sfx:Play(SoundEffect.SOUND_SCYTHE_BREAK, 1, 0, false, 1)
    for i=0,6 do
		Isaac.Spawn(1000, EffectVariant.COIN_PARTICLE, 0, pickup.Position, Vector(mod:RandomInt(1,10,rng)/3, 0):Rotated(rng:RandomInt(360)), pickup)
	end
end

mod:AddPriorityCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, CallbackPriority.EARLY, function(_, pick, coll, low)
    if pick.SubType == 4 and coll:ToPlayer() then
        local player = coll:ToPlayer()
        if player:HasTrinket(mod.ITEM.TRINKET.GOLD_LEAF) and CanBeBought(pick, player) then
            local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.GOLD_LEAF)
            pick.SubType = 1
            DoTheFXStuff(pick)
            player:AddCoins(coinGain*mult)
        end
    end
end, PickupVariant.PICKUP_BOMB)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, CallbackPriority.EARLY, function(_, pick, coll, low)
    if pick.SubType == 7 and coll:ToPlayer() then
        local player = coll:ToPlayer()
        if player:HasTrinket(mod.ITEM.TRINKET.GOLD_LEAF) and CanBeBought(pick, player) then
            local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.GOLD_LEAF)
            DoTheFXStuff(pick)
            pick:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 1, true, true, false)
            pick:GetSprite():Play("Idle", true)
            pick.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            player:AddCoins(coinGain*mult)
        end
    end
end, PickupVariant.PICKUP_HEART)

--[[mod:AddPriorityCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, CallbackPriority.EARLY, function(_, pick, coll, low)
    if pick.SubType == 7 and coll:ToPlayer() then
        local player = coll:ToPlayer()
        if player:HasTrinket(mod.ITEM.TRINKET.GOLD_LEAF) and CanBeBought(pick, player) then
            local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.GOLD_LEAF)
            DoTheFXStuff(pick)
            pick:Morph(EntityType.ENTITY_PICKUP, mod.PICKUP.VARIANT.IMMORAL_HEART, 0, true, true, false)
            pick:GetSprite():Play("Idle", true)
            pick.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            player:AddCoins(7*mult)
        end
    end
end, mod.PICKUP.VARIANT.FOOLS_GOLD_HEART)]]

mod:AddPriorityCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, CallbackPriority.EARLY, function(_, pick, coll, low)
    if pick.SubType == 2 and coll:ToPlayer() then
        local player = coll:ToPlayer()
        if player:HasTrinket(mod.ITEM.TRINKET.GOLD_LEAF) and CanBeBought(pick, player) then
            local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.GOLD_LEAF)
            DoTheFXStuff(pick)
            pick.SubType = 1
            player:AddCoins(coinGain*mult)
        end
    end
end, PickupVariant.PICKUP_KEY)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, CallbackPriority.EARLY, function(_, pick, coll, low)
    if pick.SubType == 4 and coll:ToPlayer() then
        local player = coll:ToPlayer()
        if player:HasTrinket(mod.ITEM.TRINKET.GOLD_LEAF) and CanBeBought(pick, player) then
            local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.GOLD_LEAF)
            DoTheFXStuff(pick)
            pick:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, 1, true, true, false)
            pick:GetSprite():Play("Idle", true)
            pick.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            player:AddCoins(coinGain*mult)
        end
    end
end, PickupVariant.PICKUP_LIL_BATTERY)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, CallbackPriority.EARLY, function(_, pick, coll, low)
    if (pick.SubType == 7 or pick.SubType == mod.PICKUP.COIN.GOLDENCURSED) and coll:ToPlayer() then
        local player = coll:ToPlayer()
        if player:HasTrinket(mod.ITEM.TRINKET.GOLD_LEAF) and CanBeBought(pick, player) then
            local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.GOLD_LEAF)
            DoTheFXStuff(pick)
            if pick.SubType == 7 then
                pick.SubType = 1
            elseif pick.SubType == mod.PICKUP.COIN.GOLDENCURSED then
                pick.SubType = mod.PICKUP.COIN.CURSED
            end
            player:AddCoins(coinGain*mult)
        end
    end
end, PickupVariant.PICKUP_COIN)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, CallbackPriority.EARLY, function(_, pick, coll, low)
    if mod:GetEntityData(pick).BlockPickup then
        Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_PICKUP_COLLISION, pick.Variant, pick, coll, low)
        return false
    elseif mod:IsGoldTrinket(pick.SubType) and coll:ToPlayer() then
        local player = coll:ToPlayer()
        if player:HasTrinket(mod.ITEM.TRINKET.GOLD_LEAF) and CanBeBought(pick, player) then
            local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.GOLD_LEAF)
            DoTheFXStuff(pick)
            pick:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, pick.SubType-TrinketType.TRINKET_GOLDEN_FLAG, true, true, false)
            pick:GetSprite():Play("Idle", true)
            pick.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            player:AddCoins(coinGain*mult)
            mod:GetEntityData(pick).BlockPickup = 17
            Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_PICKUP_COLLISION, pick.Variant, pick, coll, low)
            return false
        end
    end
end, PickupVariant.PICKUP_TRINKET)