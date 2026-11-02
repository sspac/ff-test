local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

function mod:horsePillPreSpawn(type, var, sub, pos, vel, spawner, seed)
    local rng = RNG()
    rng:SetSeed(math.max(1, seed), 1)
	local HORSE = FiendFolio.GetRandomPill(rng) 
    if Isaac.GetPersistentGameData():Unlocked(Achievement.HORSE_PILLS) then
        HORSE = HORSE + PillColor.PILL_GIANT_FLAG
    end
    return{EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, HORSE}
end

function mod:playingCardPreSpawn(type, var, sub, pos, vel, spawner, seed)
    local rng = RNG()
    rng:SetSeed(math.max(1, seed), 1)
    return{EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, FiendFolio.GetRandomPlayingCard(rng)}
end

function mod:pillPreSpawn(type, var, sub, pos, vel, spawner, seed)
    local rng = RNG()
    rng:SetSeed(math.max(1, seed), 1)
    return{EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, FiendFolio.GetRandomPill(rng)}
end

function mod:aberrantCardPreSpawn(type, var, sub, pos, vel, spawner, seed)
    local rng = RNG()
    rng:SetSeed(math.max(1, seed), 1)
    return{EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, FiendFolio.GetRandomAberrantCard(rng)}
end

function mod:soulstonePreSpawn(type, var, sub, pos, vel, spawner, seed)
    local rng = RNG()
    rng:SetSeed(math.max(1, seed), 1)
    return{EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, FiendFolio.GetRandomSoulstone(rng)}
end

function mod:minorArcanaPreSpawn(type, var, sub, pos, vel, spawner, seed)
    local rng = RNG()
    rng:SetSeed(math.max(1, seed), 1)
    local spawnedCard = FiendFolio.GetRandomMinorCard(rng)
    --Unnecessary atm?
    --[[local itemConfig = Isaac.GetItemConfig()
    while not itemConfig:GetCard(spawnedCard):IsAvailable() do
        spawnedCard = FiendFolio.GetRandomMinorCard(rng)
    end]]
    return{EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, spawnedCard}
end

function mod:tarotPreSpawn(type, var, sub, pos, vel, spawner, seed)
    local rng = RNG()
    rng:SetSeed(math.max(1, seed), 1)
    return{EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, FiendFolio.GetRandomRegTarotCard(rng)}
end

function mod:reverseTarotPreSpawn(type, var, sub, pos, vel, spawner, seed)
    local rng = RNG()
    rng:SetSeed(math.max(1, seed), 1)
    local attemptSpawnedCard = FiendFolio.GetRandomReverseTarotCard(rng)
    local spawnedCard = FiendFolio.GetRandomRegTarotCard(rng)
    local itemConfig = Isaac.GetItemConfig()
    for i = 1, 100 do
        if itemConfig:GetCard(attemptSpawnedCard):IsAvailable() then
            spawnedCard = attemptSpawnedCard
            break
        else
            attemptSpawnedCard = FiendFolio.GetRandomReverseTarotCard(rng)
        end
    end
    return{EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, spawnedCard}
end