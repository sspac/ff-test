local mod = FiendFolio
local game = Game()

local function ItemUse(_, _, _, player)
    local room = game:GetRoom()
    local rType = room:GetType()
    if room:GetType() == RoomType.ROOM_SHOP then
        room:ShopRestockFull()
    else
        local level = game:GetLevel()
        local roomDesc = level:GetRoomByIdx(level:GetCurrentRoomIndex())
        local roomData = roomDesc.Data

        local whatToDoToItem = nil
        if rType == RoomType.ROOM_DEVIL then
            whatToDoToItem = function (pickup)
                local c = room:GetSeededCollectible(Random())
                pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, c)
                
                pickup.Price = -1
                pickup.ShopItemId = -2
                pickup:Update()
            end
        elseif rType == RoomType.ROOM_ANGEL and roomData.Subtype == 1 then -- angel shop
            whatToDoToItem = function (pickup, idx)
                pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, mod.ITEM.COLLECTIBLE.NENDOROID)
                --[[pickup.Price = 1
                pickup.AutoUpdatePrice = true
                pickup.ShopItemId = idx]]
                pickup:MakeShopItem(idx)
                --pickup:Update()
                --pickup:Update()

                --player:UseActiveItem(CollectibleType.COLLECTIBLE_D6, false)
                pickup:Morph(pickup.Type, PickupVariant.PICKUP_SHOPITEM, 0, true)
                if pickup.Type ~= PickupVariant.PICKUP_COLLECTIBLE then
                    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, pickup.Position, Vector.Zero, nil)
                end
                --pickup:MakeShopItem(idx)
            end
        end

        if whatToDoToItem then
            room:ShopReshuffle(true, true)
            local spawns = roomData.Spawns
            local shopIDX = 0
            for i = 0, roomData.SpawnCount, 1 do
                local spawn = spawns:Get(i)
                if spawn then
                    local entry = spawn:PickEntry(0)
                    if entry and entry.Type == EntityType.ENTITY_PICKUP 
                    and entry.Variant == PickupVariant.PICKUP_SHOPITEM then
                        local spawnPos = Vector(80+spawn.X*40, 80+(spawn.Y+2)*40)
                        local shopPickups = Isaac.FindInRadius(spawnPos, 2, EntityPartition.ENTITY_PICKUP)
                        local shopitem = nil
                        for index, value in ipairs(shopPickups) do
                            value = value:ToPickup()
                            if value and value.Price ~= 0 then
                                shopitem = value
                            end
                        end
                        if shopitem == nil then
                            shopitem = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_SHOPITEM, 0, spawnPos, Vector.Zero, nil)
                        end

                        shopitem = shopitem:ToPickup()
                        whatToDoToItem(shopitem, shopIDX)
                        shopitem:AddEntityFlags(EntityFlag.FLAG_APPEAR)
                        shopIDX = shopIDX + 1
                    end
                end
            end
            if rType == RoomType.ROOM_ANGEL and roomData.Subtype == 1 then
                --room:ShopRestockFull()
                --player:UseActiveItem(CollectibleType.COLLECTIBLE_D6, false)
            end
        end
    end
    return true
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, ItemUse, mod.ITEM.COLLECTIBLE.DSTOCK)
