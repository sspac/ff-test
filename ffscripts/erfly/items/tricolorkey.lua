local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local tricolorReplacedGrids = {}

local LOCKCHANCE = 5
local INITIALCHANCE = 2/3
local REDUCER = 2/3

local replaceableTricolorRocks = {
    [GridEntityType.GRID_ROCK] = true,
    [GridEntityType.GRID_ROCKB] = true,
    [GridEntityType.GRID_ROCK_ALT] = true,
}

local puzzleGrids = {
    1013,1014,1015
}

local gridToBlock = {
    [1013] = 1017,
    [1014] = 1018,
    [1015] = 1019,
}

local function stopRockSFX()
    sfx:Stop(SoundEffect.SOUND_ROCK_CRUMBLE)
    sfx:Stop(SoundEffect.SOUND_POT_BREAK)
end

function mod:tryPlaceChainBlocks(pos, color, room, rng, chance)
    for i = 90, 360, 90 do
        local gridpos = pos + Vector(50,0):Rotated(i)
        local gridEnt = room:GetGridEntityFromPos(gridpos)
        if gridEnt then
            local desc = gridEnt.Desc.Type
            if replaceableTricolorRocks[desc] and not StageAPI.IsCustomGrid(room:GetGridIndex(gridpos)) then
                gridpos = gridEnt.Position
                if rng:RandomFloat() < chance then
                    --room:RemoveGridEntity(room:GetGridIndex(gridpos), 0, false)
                    gridEnt:Destroy(true)
                    stopRockSFX()
                    local block = Isaac.Spawn(183, color, rng:RandomInt(5), gridpos, Vector.Zero, nil)
                    table.insert(tricolorReplacedGrids, room:GetGridIndex(gridpos))
                    mod:tryPlaceChainBlocks(gridpos, color, room, rng, chance*REDUCER)
                end
            end
        end
    end
end

local function checkPlayerPath(pos)
    local pather = Isaac.Spawn(10,1984,0,pos,Vector.Zero,nil):ToNPC()
    local path = pather.Pathfinder
    local foundPath = false
    if path:HasPathToPos(Isaac.GetPlayer().Position, true) then
        foundPath = true
    end
    pather:Remove()
    --print(foundPath)
    return foundPath
end

function mod:tricolorKeyNewRoom(player, d, savedata)
    tricolorReplacedGrids = {}
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.TRICOLOR_KEY) then
        local room = game:GetRoom()
        if room:IsFirstVisit() then
            local rng = RNG()
            rng:SetSeed(room:GetAwardSeed(), 1)
            local newGrids = {}
            for i=0, room:GetGridSize() do
                local gridEntity = room:GetGridEntity(i)
                if gridEntity and not StageAPI.IsCustomGrid(i) then
                    local gridpos = room:GetGridPosition(i)
                    local desc = gridEntity.Desc.Type
                    if replaceableTricolorRocks[desc] then
                        local randCheck = rng:RandomInt(LOCKCHANCE)
                        if randCheck == 0 then
                            local nearbyAir
                            for k = 90, 360, 90 do
                                local surroundingPos = gridpos + Vector(50,0):Rotated(k)
                                local surroundedGrid = room:GetGridEntityFromPos(surroundingPos)
                                if not surroundedGrid then
                                    if checkPlayerPath(surroundingPos) then
                                        nearbyAir = true
                                        break
                                    end
                                end
                            end
                            if nearbyAir then
                                --room:RemoveGridEntity(room:GetGridIndex(gridpos), 0, false)
                                gridEntity:Destroy(true)
                                stopRockSFX()
                                local blockCol = puzzleGrids[rng:RandomInt(#puzzleGrids)+1]
                                local block = Isaac.Spawn(183, blockCol, 0, gridpos, Vector.Zero, nil)
                                table.insert(tricolorReplacedGrids, room:GetGridIndex(gridpos))
                                mod:tryPlaceChainBlocks(gridpos, gridToBlock[blockCol], room, rng, INITIALCHANCE)
                            end
                        end
                    end
                end
            end
        end
    end
end