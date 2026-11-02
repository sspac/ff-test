local mod = FiendFolio
local game = Game()

local Constants = {
    MIN_COINS = 1,
    MAX_COINS = 3,
    DISABLED_STATE = 4, -- Flat file
    GFX = "gfx/grid/goldenspikes/",
}

FiendFolio.GoldenSpikeRockGrid = StageAPI.CustomGrid("FFGoldenSpikeRock", {
    BaseType = GridEntityType.GRID_ROCK_SPIKED,
    Anm2 = "gfx/grid/goldenspikes/grid_golden_spikes.anm2",
    Animation = "spiked",
    VariantFrames = 2,
    RemoveOnAnm2Change = true,
    OverrideGridSpawns = true,
    SpawnerEntity = {Type = FiendFolio.FFID.Grid, Variant = 1400}
})

local function getFileName(str)
    local name = str:match("[^/]*.png$")
    return name:sub(0, #name - 4)
end

---@param grid GridEntity
local function updateRockSprite(grid, room, forceFileName)
    local sprite = grid:GetSprite()
    local backdropType = room:GetBackdropType()
    local rocks
    
    -- This can return a function in crawlspaces which returns the backdrop.
    -- Crawlspaces shouldn't even have golden rocks but whatever.
    local roomGfx = mod:getCurrentRoomGfx()
    if type(roomGfx) == "function" then
        roomGfx = roomGfx()
    end

    if forceFileName then
        rocks = getFileName(forceFileName)
    elseif roomGfx and roomGfx.Grids and roomGfx.Grids.Rocks then
        rocks = getFileName(roomGfx.Grids.Rocks)
    elseif mod.backdropRockSpritesheets[backdropType] then
        rocks = getFileName(mod.backdropRockSpritesheets[backdropType]) 
    else
        rocks = "rocks_basement"
    end
    
    grid:ToRock():UpdateNeighbors()

    Isaac.CreateTimer(function ()
        sprite:ReplaceSpritesheet(0, Constants.GFX .. rocks .. ".png", true)
    end, 1, 1, false)
end

function mod.GoldenSpikesSpawn(customGrid)
    local room = game:GetRoom()
    updateRockSprite(customGrid.GridEntity, room)

    -- Set coins
    local rng = customGrid.GridEntity:GetRNG()
    customGrid.Data.Coins = rng:RandomInt(Constants.MIN_COINS, Constants.MAX_COINS)
end
StageAPI.AddCallback("FiendFolio", "POST_SPAWN_CUSTOM_GRID", 0, mod.GoldenSpikesSpawn, "FFGoldenSpikeRock")

function mod.GoldenSpikesUpdate(customGrid)
    if customGrid.GridEntity.State == Constants.DISABLED_STATE then
        local sparkles = mod:GetPointee(customGrid.Data.Sparkles)
        if not sparkles then
            sparkles = Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.FFID.Effect, mod.FF.GoldenSpikesSparkles.Sub, customGrid.Position, Vector.Zero, nil)
            sparkles.State = customGrid.GridIndex
            customGrid.Data.Sparkles = EntityPtr(sparkles)
        end
    end
end
StageAPI.AddCallback("FiendFolio", "POST_CUSTOM_GRID_UPDATE", 0, mod.GoldenSpikesUpdate, "FFGoldenSpikeRock")

function mod.GoldenSpikesPreChangeGFX(grid, index, fileName)
    if StageAPI.IsCustomGrid(grid, "FFGoldenSpikeRock") then
        local rocks = getFileName(fileName)
        return Constants.GFX .. rocks .. ".png"
    end
end
StageAPI.AddCallback("FiendFolio", "PRE_CHANGE_ROCK_GFX", 1, mod.GoldenSpikesPreChangeGFX)

function mod.GoldenSpikesDestroy(customGrid)
    for _ = 1, customGrid.Data.Coins do
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, customGrid.Position, RandomVector() * 4, nil)
    end
end
StageAPI.AddCallback("FiendFolio", "POST_CUSTOM_GRID_DESTROY", 0, mod.GoldenSpikesDestroy, "FFGoldenSpikeRock")

function mod:GoldenSpikeSparkleUpdate(effect)
    local room = game:GetRoom()
    if room:GetGridCollision(effect.State) ~= GridCollisionClass.COLLISION_SOLID then
        effect:Remove()
    end
end