local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

function mod:handleObjectSpawner(type, var, sub, pos, vel, spawner, seed)
    local rng = RNG()
    rng:SetSeed(math.max(1, seed), 1)
    return{EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, FiendFolio.GetRandomObject(rng)}
end