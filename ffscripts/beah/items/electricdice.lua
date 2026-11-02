local mod = FiendFolio

mod.ElectricDiceBlacklist = {
    CollectibleType.COLLECTIBLE_DAMOCLES,
    CollectibleType.COLLECTIBLE_ALABASTER_BOX,
    CollectibleType.COLLECTIBLE_GENESIS,
    CollectibleType.COLLECTIBLE_DEATH_CERTIFICATE,
    CollectibleType.COLLECTIBLE_FORGET_ME_NOW,
    CollectibleType.COLLECTIBLE_BLUE_BOX,
    CollectibleType.COLLECTIBLE_DIPLOPIA,
    CollectibleType.COLLECTIBLE_PLAN_C,
    CollectibleType.COLLECTIBLE_MAMA_MEGA,
    CollectibleType.COLLECTIBLE_EDENS_SOUL,
    CollectibleType.COLLECTIBLE_MYSTERY_GIFT
}

local function ItemUse(_, id, _, player, flags)
    if not player:HasCollectible(mod.ITEM.COLLECTIBLE.ELECTRIC_DICE) then
        return
    end
    if flags & UseFlag.USE_CARBATTERY ~= 0 or flags & UseFlag.USE_OWNED == 0 then
        return
    end
    local charge, slot = mod:BeahCheckPlayerForActiveData(player, id)
    if charge == 0 --or slot == -1
    or mod:Contains(mod.ElectricDiceBlacklist, id) then
        return
    end

    local timesToUseBonus = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.ELECTRIC_DICE):RandomInt(3)
    local offset = Vector(0,-30)
    for i = 1, timesToUseBonus, 1 do
        player:UseActiveItem(id, flags | UseFlag.USE_CARBATTERY)

        local effect =  Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BATTERY, 0, player.Position + offset + ((i + 0.5) * Vector(0, -20)), Vector.Zero, player)
        effect.DepthOffset = 500
    end
end

mod:AddCollectibleCallback(ModCallbacks.MC_USE_ITEM, mod.ITEM.COLLECTIBLE.ELECTRIC_DICE, ItemUse)