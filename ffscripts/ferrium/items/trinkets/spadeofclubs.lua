local mod = FiendFolio
local game = Game()

local keysToBomb = {
    [KeySubType.KEY_NORMAL] = BombSubType.BOMB_NORMAL,
    [KeySubType.KEY_CHARGED] = BombSubType.BOMB_NORMAL,
    [KeySubType.KEY_DOUBLEPACK] = BombSubType.BOMB_DOUBLEPACK,
    [KeySubType.KEY_GOLDEN] = BombSubType.BOMB_GOLDEN,
    [mod.PICKUP.KEY.SPICY] = mod.PICKUP.BOMB.COPPER,
    [mod.PICKUP.KEY.SPICY_PERM] = mod.PICKUP.BOMB.COPPER,
    [mod.PICKUP.KEY.CHARGEDSPICY] = mod.PICKUP.BOMB.COPPER,
    [mod.PICKUP.KEY.SPICY_BOX] = mod.PICKUP.BOMB.DOUBLE_COPPER,
    [mod.PICKUP.KEY.SUPERSPICY] = mod.PICKUP.BOMB.DOUBLE_COPPER,
    [mod.PICKUP.KEY.SUPERSPICY_PERM] = mod.PICKUP.BOMB.DOUBLE_COPPER,
    [mod.PICKUP.KEY.CHARGEDSPICY_BOX] = mod.PICKUP.BOMB.DOUBLE_COPPER,
    [mod.PICKUP.KEY.CHARGEDSPICY_PERM] = mod.PICKUP.BOMB.DOUBLE_COPPER,
}

local bombsToKey = {
    [BombSubType.BOMB_NORMAL] = KeySubType.KEY_NORMAL,
    [BombSubType.BOMB_DOUBLEPACK] = KeySubType.KEY_DOUBLEPACK,
    [BombSubType.BOMB_GOLDEN] = KeySubType.KEY_GOLDEN,
    [mod.PICKUP.BOMB.COPPER] = mod.PICKUP.KEY.SPICY_PERM,
    [mod.PICKUP.BOMB.DOUBLE_COPPER] = mod.PICKUP.KEY.SUPERSPICY_PERM,
}

function mod:SpadeOfClubsUpdate()
    if mod.anyPlayerHas(mod.ITEM.TRINKET.SPADE_OF_CLUBS, true) then
        if game:GetFrameCount() % 60 == 0 then
            local keys = {}
            local bombs = {}
            for _,key in ipairs(Isaac.FindByType(5, PickupVariant.PICKUP_KEY, -1, false, false)) do
                if keysToBomb[key.SubType] and key.EntityCollisionClass == EntityCollisionClass.ENTCOLL_ALL then
                    key = key:ToPickup()
                    table.insert(keys, key)
                end
            end
            for _,bomb in ipairs(Isaac.FindByType(5, PickupVariant.PICKUP_BOMB, -1, false, false)) do
                if bombsToKey[bomb.SubType] and bomb.EntityCollisionClass == EntityCollisionClass.ENTCOLL_ALL then
                    bomb = bomb:ToPickup()
                    table.insert(bombs, bomb)
                end
            end

            --This is so it doesn't immediately unconvert the keys
            for _,key in ipairs(keys) do
                local d = mod:GetEntityData(key)
                if d.SpadeofClubsOriginal and d.SpadeofClubsOriginal[1] == PickupVariant.PICKUP_BOMB then
                    local tab = d.SpadeofClubsOriginal
                    key:Morph(5, PickupVariant.PICKUP_BOMB, d.SpadeofClubsOriginal[2], true, true, true)
                    mod:GetEntityData(key).SpadeofClubsOriginal = tab
                    key:GetSprite():Play("Idle", true)
                    key.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                else
                    local tab = d.SpadeofClubsOriginal or {key.Variant, key.SubType}
                    key:Morph(5, PickupVariant.PICKUP_BOMB, keysToBomb[key.SubType], true, true, true)
                    mod:GetEntityData(key).SpadeofClubsOriginal = tab
                    key:GetSprite():Play("Idle", true)
                    key.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                end
            end
            for _,bomb in ipairs(bombs) do
                local d = mod:GetEntityData(bomb)
                if d.SpadeofClubsOriginal and d.SpadeofClubsOriginal[1] == PickupVariant.PICKUP_KEY then
                    local tab = d.SpadeofClubsOriginal
                    bomb:Morph(5, PickupVariant.PICKUP_KEY, d.SpadeofClubsOriginal[2], true, true, true)
                    mod:GetEntityData(bomb).SpadeofClubsOriginal = tab
                    bomb:GetSprite():Play("Idle", true)
                    bomb.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                else
                    local tab = d.SpadeofClubsOriginal or {bomb.Variant, bomb.SubType}
                    d.SpadeofClubsOriginal = {bomb.Variant, bomb.SubType}
                    bomb:Morph(5, PickupVariant.PICKUP_KEY, bombsToKey[bomb.SubType], true, true, true)
                    mod:GetEntityData(bomb).SpadeofClubsOriginal = tab
                    bomb:GetSprite():Play("Idle", true)
                    bomb.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                end
            end
        end
    end
end
mod:AddTrinketCallback("FF_POST_UPDATE_FERRIUM", mod.ITEM.TRINKET.SPADE_OF_CLUBS, mod.SpadeOfClubsUpdate)