local mod = FiendFolio
local sfx = SFXManager()

local function used(_, id, rng, player, flags)
    --[[local p_data = mod:GetEntityData(player)
    p_data.WickedPData.hotPotatoBuff = (p_data.WickedPData.hotPotatoBuff or 1) + 0.1]]
    sfx:Play(SoundEffect.SOUND_POWERUP1, 1, 0)
    return true
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, used, mod.ITEM.COLLECTIBLE.HOT_POTATO_BOOK)

local function updateItem()
    local players = mod:AllPlayersWithCollectible(mod.ITEM.COLLECTIBLE.HOT_POTATO_BOOK)

    for _, player in ipairs(players) do
        local charge, slot = mod:BeahCheckPlayerForActiveData(player, mod.ITEM.COLLECTIBLE.HOT_POTATO_BOOK)
        if slot ~= -1 then --tainted fiend proofing
            player:RemoveCollectible(mod.ITEM.COLLECTIBLE.HOT_POTATO_BOOK, false, slot, false)
            player:AddCollectible(mod.ITEM.COLLECTIBLE.HOT_POTATO_BOOK, charge, false, slot)
        end
    end
end

local function AfterChargeItem()
    local ic = Isaac.GetItemConfig()
    local i = ic:GetCollectible(mod.ITEM.COLLECTIBLE.HOT_POTATO_BOOK)
    i.ChargeType = ItemConfig.CHARGE_NORMAL
    updateItem()
    
    local players = mod:AllPlayersWithCollectible(mod.ITEM.COLLECTIBLE.HOT_POTATO_BOOK)

    for _, player in ipairs(players) do
        if player:HasTrinket(TrinketType.TRINKET_WATCH_BATTERY) then
            local t_rng = player:GetTrinketRNG(TrinketType.TRINKET_WATCH_BATTERY)
            if t_rng:RandomFloat() < 0.05 then
                mod:ChargeFirstActiveOfType(player, mod.ITEM.COLLECTIBLE.HOT_POTATO_BOOK)
            end
        end
    end
end

local function onRoomClear()
    local ic = Isaac.GetItemConfig()
    local i = ic:GetCollectible(mod.ITEM.COLLECTIBLE.HOT_POTATO_BOOK)
    i.ChargeType = ItemConfig.CHARGE_SPECIAL
    updateItem()

    mod.scheduleForUpdate(AfterChargeItem, 0, ModCallbacks.MC_POST_RENDER)
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_PLAYER_TRIGGER_ROOM_CLEAR, 200, onRoomClear)
--bov

local function cool(_, familiar)
    if familiar.SubType ~= mod.ITEM.COLLECTIBLE.HOT_POTATO_BOOK then
        return
    end

    local player = familiar.Player
    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
end
mod:AddEntityCallback(ModCallbacks.MC_FAMILIAR_INIT, EntityType.ENTITY_FAMILIAR, FamiliarVariant.WISP, mod.ITEM.COLLECTIBLE.HOT_POTATO_BOOK, cool, FamiliarVariant.WISP)

local function cooler(_, familiar)
    if familiar.Variant ~= EntityType.ENTITY_FAMILIAR and familiar.SubType ~= mod.ITEM.COLLECTIBLE.HOT_POTATO_BOOK then
        return
    end

    local familiar = familiar:ToFamiliar()
    if familiar and familiar.Player then
        familiar.Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
    end
end
mod:AddEntityCallback(ModCallbacks.MC_POST_ENTITY_KILL, EntityType.ENTITY_FAMILIAR, FamiliarVariant.WISP, mod.ITEM.COLLECTIBLE.HOT_POTATO_BOOK, cooler, EntityType.ENTITY_FAMILIAR)
--4.5 volt proofing

--[[local function FourFiveVoltOnDamage(_, player)
    if player:HasCollectible(647) then
        
    end
end i cant be effed to do this]]

--I HATE THAT THE INITCHARGE ISNT normal ): but the prices we have to do for balancing i guess ):