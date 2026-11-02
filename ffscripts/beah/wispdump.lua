local mod = FiendFolio
local game = Game()

local function getPos(w)
    local room = game:GetRoom()
    return room:FindFreePickupSpawnPosition(w.Position)
end

local wispContent = {
    [mod.ITEM.COLLECTIBLE.TOYBOX] = {
        OnDeath = function (entity, rng)
            if rng:RandomFloat() < 0.2 then
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, mod.ITEM.CARD.NEIGHBOURS_FROM_HELL, getPos(entity), Vector.Zero, entity)  
            end
        end
    },
    [mod.ITEM.COLLECTIBLE.BOTTLE_CAP] = {
        OnDeath = function (entity, rng)
            if rng:RandomFloat() < 0.8 then
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, mod.PICKUP.COIN.CURSED , getPos(entity), Vector.Zero, entity)  
            end
        end
    },
    [mod.ITEM.COLLECTIBLE.GREEN_CANDLE] = {
        OnUpdate = function (entity) 
            if entity.FrameCount % 40 == 0 then
                local player = entity.Player
                local cloud = Isaac.Spawn(1000, 141, 0, entity.Position, Vector.Zero, player):ToEffect()
                cloud.Timeout = 80
                cloud:Update()
                --entity:Die()
            end
        end,
        RemoveOnNextRoom = true
    },
    [mod.ITEM.COLLECTIBLE.BOOK_OF_LEVIATHAN] = {
        OnUpdate = function (entity)
            local player = entity.Player
            if entity.FrameCount % 40 == 0 and player then  
                local targets = Isaac.FindInRadius(entity.Position, 80000, EntityPartition.ENEMY) 
                mod:Shuffle(targets)
                for index, value in ipairs(targets) do
                    if value:IsVulnerableEnemy() and not value:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then        
                        --ripped from sanguine hook 
                        local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
		                FiendFolio.AddBruise(value, player, 40 * secondHandMultiplier, 1, 1)

                        return
                    end
                end
            end
        end
    },
    [mod.ITEM.COLLECTIBLE.HOLY_BEAN] = {
        OnDeath = function (entity) 
            local player = entity.Player
            local pos = player.Position
            player.Position = entity.Position
            player:UseActiveItem(mod.ITEM.COLLECTIBLE.HOLY_BEAN , false, false, true, false)
            player.Position = pos
        end,
        RemoveOnNextRoom = true
    },
    [mod.ITEM.COLLECTIBLE.BLACK_EYED_PEA] = {
        OnDeath = function (entity) 
            local player = entity.Player
            local pos = player.Position
            player.Position = entity.Position
            player:UseActiveItem(mod.ITEM.COLLECTIBLE.BLACK_EYED_PEA , false, false, true, false)
            player.Position = pos
        end,
        RemoveOnNextRoom = true
    },
    [mod.ITEM.COLLECTIBLE.NIL_PASTA] = {
        OnUpdate = function (entity)
            local a, b = 110, 44
            if entity.FrameCount % a < b then
                entity.Velocity = Vector.Zero
            elseif entity.FrameCount % a == b then
                entity.Position = entity.Player.Position
            end
        end
    }
}

for key, value in pairs(wispContent) do
    if value.OnDeath then
        mod:AddEntityCallback(ModCallbacks.MC_POST_ENTITY_KILL, EntityType.ENTITY_FAMILIAR, FamiliarVariant.WISP, key, function (_, entity)
            entity = entity:ToFamiliar()
            if entity and entity.Variant == FamiliarVariant.WISP and entity.SubType == key then
                local rng = entity:GetDropRNG()
                value.OnDeath(entity, rng)
            end
        end, EntityType.ENTITY_FAMILIAR)
    end

    if value.OnUpdate then
        mod:AddEntityCallback(ModCallbacks.MC_FAMILIAR_UPDATE, EntityType.ENTITY_FAMILIAR, FamiliarVariant.WISP, key, function (_,entity)
            if entity.SubType ~= key then
                return
            end
            value.OnUpdate(entity)
        end, FamiliarVariant.WISP)
    end

    if value.TearFired then
        mod:AddEntityCallback(ModCallbacks.MC_POST_TEAR_INIT, EntityType.ENTITY_FAMILIAR, FamiliarVariant.WISP, key, function (_,entity)
            if tear.SpawnerType ~= EntityType.ENTITY_FAMILIAR
            or tear.SpawnerVariant ~= FamiliarVariant.WISP
            or tear.SpawnerEntity.SubType ~= mod.ITEMS.VOID_EGG then
                return
            end

            local wisp = tear.SpawnerEntity:ToFamiliar()
            local rng = wisp:GetDropRNG()
            value.TearFired(tear, wisp, rng)
        end)
    end
end

mod:AddEntityCallback(ModCallbacks.MC_POST_NEW_ROOM, EntityType.ENTITY_FAMILIAR, FamiliarVariant.WISP, nil, function ()
    local i = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.WISP)
    for index, value in ipairs(i) do
        if wispContent[value.SubType] and wispContent[value.SubType].RemoveOnNextRoom then
            value:Remove()
        end
    end
end)