local mod = FiendFolio
local game = Game()

local Constants = {
    DROP_CHANCE = 0.15,
    ROOM_CLEAR_CHANCE = 0.1,
}

mod.SpareEraserWhitelistChests = {
    [PickupVariant.PICKUP_BOMBCHEST] = true,
    [PickupVariant.PICKUP_CHEST] = true,
    [PickupVariant.PICKUP_HAUNTEDCHEST] = true,
    [PickupVariant.PICKUP_MIMICCHEST] = true,
    [PickupVariant.PICKUP_SPIKEDCHEST] = true,
    [mod.PICKUP.VARIANT.GLASS_CHEST] = true,
}

mod.SpareEraserWhitelistSacks = {
    [PickupVariant.PICKUP_GRAB_BAG] = true,
}

---@param player EntityPlayer
function mod.SpareEraserPickup(player)
    local activeSlot = player:GetActiveItemSlot(CollectibleType.COLLECTIBLE_ERASER)
    if activeSlot >= 0 then
        player:FullCharge(activeSlot, true)
    end
end

function mod.SpareEraserCanPickup(player)
    local activeSlot = player:GetActiveItemSlot(CollectibleType.COLLECTIBLE_ERASER)
    return activeSlot >= 0 and player:GetActiveCharge(activeSlot) == 0
end

CustomHealthAPI.Library.RegisterPickupEntity(mod.PICKUP.VARIANT.SPARE_ERASER, 0, {
    CanCollect = mod.SpareEraserCanPickup,
    OnCollect = mod.SpareEraserPickup,
    DropSound = SoundEffect.SOUND_BOOMERANG_CATCH,
})

function mod:InsertEraserDropSack(pickup)
    if PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_ERASER) and mod.DoVanillaItemTweaks then
        local sprite = pickup:GetSprite()
        if mod.SpareEraserWhitelistSacks[pickup.Variant] and sprite:GetAnimation() == "Collect" and sprite:GetFrame() == 1 and pickup:GetDropRNG():RandomFloat() < Constants.DROP_CHANCE then
            local velocity = EntityPickup.GetRandomPickupVelocity(pickup.Position)
            Isaac.Spawn(EntityType.ENTITY_PICKUP, mod.PICKUP.VARIANT.SPARE_ERASER, 0, pickup.Position, velocity, nil)
        end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, CollectibleType.COLLECTIBLE_ERASER, mod.InsertEraserDropSack)

function mod:InsertEraserDropChest(pickup)
    if PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_ERASER) and mod.DoVanillaItemTweaks then
        local d = mod:GetEntityData(pickup)
        if d.FFAlreadyCheckedSpareEraser then
            return
        end

        d.FFAlreadyCheckedSpareEraser = true
        
        local lootList = pickup:GetLootList():GetEntries()
        for _, entry in ipairs(lootList) do
            if entry:GetVariant() == PickupVariant.PICKUP_COLLECTIBLE or entry:GetVariant() == PickupVariant.PICKUP_CHEST or entry:GetVariant() == PickupVariant.PICKUP_LOCKEDCHEST then
                return
            end
        end

        if mod.SpareEraserWhitelistChests[pickup.Variant] and pickup:GetDropRNG():RandomFloat() < Constants.DROP_CHANCE then
            local velocity = EntityPickup.GetRandomPickupVelocity(pickup.Position)
            Isaac.Spawn(EntityType.ENTITY_PICKUP, mod.PICKUP.VARIANT.SPARE_ERASER, 0, pickup.Position, velocity, nil)
        end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_OPEN_CHEST, CollectibleType.COLLECTIBLE_ERASER, mod.InsertEraserDropChest)

function mod:AddEraserToRoomDrops(rng, spawnPos)
    local room = game:GetRoom()
    if room:GetType() == RoomType.ROOM_BOSS or room:GetType() == RoomType.ROOM_BOSSRUSH then
        return
    end

    local player = PlayerManager.FirstCollectibleOwner(CollectibleType.COLLECTIBLE_ERASER)
    if player and mod.DoVanillaItemTweaks then
        if rng:RandomFloat() < Constants.ROOM_CLEAR_CHANCE then
            local pos = room:FindFreePickupSpawnPosition(spawnPos)
            Isaac.Spawn(EntityType.ENTITY_PICKUP, mod.PICKUP.VARIANT.SPARE_ERASER, 0, pos, Vector.Zero, nil)
        end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, CollectibleType.COLLECTIBLE_ERASER, mod.AddEraserToRoomDrops)