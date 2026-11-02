local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local chargeTypes = {
    [BatterySubType.BATTERY_MICRO] = 2,
    [BatterySubType.BATTERY_MEGA] = 12,
}
local batteryVariants = {
    [90] = true,
    [mod.PICKUP.VARIANT.FIREWORK_BATTERY] = true,
    [mod.PICKUP.VARIANT.VIRTUOUS_BATTERY] = true,
    [mod.PICKUP.VARIANT.POTATO_BATTERY] = true,
    [mod.PICKUP.VARIANT.CURSED_BATTERY] = true,
}
local dmgPer6Charges = 0.9
mod:AddPriorityTrinketCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, -1, mod.ITEM.TRINKET.POWER_INVERTER, function (_, pickup, player)
    if batteryVariants[pickup.Variant] == nil then
        return
    end
    player = player:ToPlayer()
    if not player or not player:HasTrinket(mod.ITEM.TRINKET.POWER_INVERTER) then
        return
    end
    if not mod:CanPickupPickupGeneric(pickup, player) then
        return
    end

    local i_data = mod:GetEntityData(pickup)
    if not i_data.ff_invertPlayer then
        i_data.ff_invertPlayer = player

        local p_data = mod:GetEntityData(player)
        local tmult = math.max(player:GetTrinketMultiplier(mod.ITEM.TRINKET.POWER_INVERTER), 1)
        local charge = pickup.Variant == mod.PICKUP.VARIANT.POTATO_BATTERY and 1 or chargeTypes[pickup.SubType]
        local dmgToAdd = ((charge or 6) / 6) * dmgPer6Charges * tmult
    
        p_data.ffsavedata.RunEffects.inverterdmgToAdd = (p_data.ffsavedata.RunEffects.inverterdmgToAdd or 0) + (dmgToAdd)
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        player:EvaluateItems()
    end
    pickup.Friction = 0
    pickup.Mass = 0
end)

mod:AddTrinketCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, mod.ITEM.TRINKET.POWER_INVERTER, function (_, pickup)
    local i_data = mod:GetEntityData(pickup)
    if batteryVariants[pickup.Variant] == nil then
        return
    end
    if pickup:Exists() and i_data.ff_invertPlayer then
        local player = i_data.ff_invertPlayer
        i_data.ff_invertPlayer = nil

        local p_data = mod:GetEntityData(player)
        if pickup.SubType == BatterySubType.BATTERY_GOLDEN then
            p_data.ffsavedata.RunEffects.goldenBatteryRandomRoom = mod:DoGoldenBattery(player, pickup)
        end
        local sprite = pickup:GetSprite()
        sprite:Play("Collect")
        pickup:Die()
        sfx:Play(SoundEffect.SOUND_BATTERYCHARGE)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BATTERY, 0, player.Position - Vector(0, 60), Vector.Zero, player)

        --[[if pickup.Variant == mod.PICKUP.VARIANT.FIREWORK_BATTERY then
            mod:GetEntityData(player).ffsavedata.excelsiorBonus = (mod:GetEntityData(player).ffsavedata.excelsiorBonus or 0) + 1
        elseif pickup.Variant == mod.PICKUP.VARIANT.VIRTUOUS_BATTERY then
		    mod:GetEntityData(player).ffsavedata.virtuousCharge = (mod:GetEntityData(player).ffsavedata.virtuousCharge or 0) + 1
        end]]
    end
end)

function mod:DoGoldenBattery(player, battery)
    player:TakeDamage(2, DamageFlag.DAMAGE_NO_PENALTIES, EntityRef(battery), 1)

    local level = game:GetLevel()
    local currIdx = level:GetCurrentRoomIndex()
    
    local newIdx = currIdx
    local t_rng = player:GetTrinketRNG(mod.ITEM.TRINKET.POWER_INVERTER)
    while newIdx == currIdx do
        local seed = t_rng:Next() --I don't know where I got this from but it makes seeding things a little better
        newIdx = level:GetRandomRoomIndex(false, seed) 
    end
    return newIdx
end

mod:AddTrinketCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.ITEM.TRINKET.POWER_INVERTER, function ()
    local allPlayers = mod:GetAllPlayers()
    for index, player in ipairs(allPlayers) do
        local p_data = mod:GetEntityData(player)
        local level = game:GetLevel()
        local currRoom = level:GetCurrentRoomDesc ()
        local currIdx = level:GetCurrentRoomIndex()

        if level:GetStartingRoomIndex() == currIdx
        and currRoom.VisitedCount == 1 then
            p_data.ffsavedata.RunEffects.inverterdmgToAdd = nil
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            player:EvaluateItems()
            
            p_data.ffsavedata.RunEffects.goldenBatteryRandomRoom = nil
        else
            local gidx = p_data.ffsavedata.RunEffects.goldenBatteryRandomRoom
            if gidx and gidx == currIdx then
                p_data.ffsavedata.RunEffects.goldenBatteryRandomRoom = nil

                local room = game:GetRoom()
                local roomPos = room:FindFreePickupSpawnPosition(Isaac.GetRandomPosition())
                local battery = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, BatterySubType.BATTERY_GOLDEN, roomPos, Vector.Zero, nil)
                battery:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                battery:GetSprite():Play("Idle")
            end
        end
    end
end)