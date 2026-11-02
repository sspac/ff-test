local mod = FiendFolio
local game = Game()

local Constants = {
    REPLACE_CHANCE = 0.09,
}

function mod:IsRockGoldenSpiked(gridIndex)
    return StageAPI.IsCustomGrid(gridIndex, "FFGoldenSpikeRock")
end

function mod:IsGridIndexNonReplaceableRock(gridIndex)
    local currentRoomDesc = game:GetLevel():GetCurrentRoomDesc()
    local data = currentRoomDesc.Data
    local x, y = StageAPI.GridToVector(gridIndex)
    for spawnIdx = 0, data.Spawns.Size - 1 do
        local spawn = data.Spawns:Get(spawnIdx)
        if x == spawn.X and y == spawn.Y then
            for entryIdx = 0, #spawn.Entries - 1 do
                local entry = spawn.Entries:Get(entryIdx)
                if entry.Type == StbGridType.ROCK and entry.Subtype == StbRockSubType.NON_REPLACEABLE then
                    return true
                end
            end

            break
        end
    end

    return false
end

function mod:CanRockBeGoldenSpikes(grid)
    local index = grid:GetGridIndex()
    if not mod:IsRockGoldenSpiked(index) and grid:GetType() == GridEntityType.GRID_ROCK then
        return not mod:IsGridIndexNonReplaceableRock(index)
    end

    return false
end

function mod:TryTurnRockIntoGoldenSpikes(grid)
    local player = PlayerManager.FirstCollectibleOwner(mod.ITEM.COLLECTIBLE.GOLDEN_SPIKES) or Isaac.GetPlayer(0)
    local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.GOLDEN_SPIKES)
    
    if (
        mod:CanRockBeGoldenSpikes(grid) and
        rng:RandomFloat() < Constants.REPLACE_CHANCE
    ) then
        grid:SetType(GridEntityType.GRID_ROCK_SPIKED)
        grid:Init(rng:GetSeed())

        mod.GoldenSpikeRockGrid:Spawn(grid:GetGridIndex(), true, false)
    end
end

function mod:GoldenSpikeNewRoom()
    local room = game:GetRoom()

    if (
        PlayerManager.AnyoneHasCollectible(mod.ITEM.COLLECTIBLE.GOLDEN_SPIKES) 
        and room:IsFirstVisit()
        and room:GetType() ~= RoomType.ROOM_DUNGEON -- dont trigger in crawlspaces
    ) then
        for i = 0, room:GetGridSize() do
            local grid = room:GetGridEntity(i)
            if grid and grid:GetType() == GridEntityType.GRID_ROCK then
                mod:TryTurnRockIntoGoldenSpikes(grid)
            end
        end
    end
end