local mod = FiendFolio
local game = Game()

--Finding positions, moving around, finding spots in the room, etc

function mod:FindNearestCorner(npc)
    local dist = 9999
    local corner = npc.Position
	local room = game:GetRoom()
    local tl = room:GetTopLeftPos()
    local br = room:GetBottomRightPos()
    local corners = {tl, br, Vector(tl.X, br.Y), Vector(br.X, tl.Y)}
    if room:GetRoomShape() >= RoomShape.ROOMSHAPE_LTL then --L rooms :/
        if room:GetRoomShape() == RoomShape.ROOMSHAPE_LTL then
            table.remove(corners, 1)
            table.insert(corners, Vector(tl.X+(br.X-tl.X)/2, tl.Y))
            table.insert(corners, Vector(tl.X, tl.Y+(br.Y-tl.Y)/2))
        elseif room:GetRoomShape() == RoomShape.ROOMSHAPE_LTR then
            table.remove(corners, 4)
            table.insert(corners, Vector(tl.X+(br.X-tl.X)/2, tl.Y))
            table.insert(corners, Vector(br.X, tl.Y+(br.Y-tl.Y)/2))
        elseif room:GetRoomShape() == RoomShape.ROOMSHAPE_LBL then
            table.remove(corners, 3)
            table.insert(corners, Vector(tl.X+(br.X-tl.X)/2, br.Y))
            table.insert(corners, Vector(tl.X, tl.Y+(br.Y-tl.Y)/2))
        elseif room:GetRoomShape() == RoomShape.ROOMSHAPE_LBR then
            table.remove(corners, 2)
            table.insert(corners, Vector(tl.X+(br.X-tl.X)/2, br.Y))
            table.insert(corners, Vector(br.X, tl.Y+(br.Y-tl.Y)/2))
        end

        for _,corn in ipairs(corners) do
            if npc.Position:Distance(corn) < dist then
                dist = npc.Position:Distance(corn)
                corner = corn
            end
        end

        return corner
    else
        for _,corn in ipairs(corners) do
            if npc.Position:Distance(corn) < dist then
                dist = npc.Position:Distance(corn)
                corner = corn
            end
        end

        return corner
    end
end

function mod:updateToNPCPosition(npc, held, offset, noUpdate, flipX)
    if not offset then
        offset = Vector.Zero
    elseif flipX then
        offset.X = -offset.X
    end
	held.Position = npc.Position+offset
	if npc.Index > held.Index and not noUpdate then
		held:Update()
	end
	held.Velocity = npc.Velocity
end

function mod:shuntedPosition(int, rng)
	local result
	if rng then
		result = Vector(mod:getRoll(-int, int, rng), mod:getRoll(-int, int, rng))
	else
		result = Vector(math.random(-int,int), math.random(-int,int))
	end
	return result
end

--Modified random valid path function to get random enemies closer to Isaac, or further away. 0 is close, 1 is far. 
function mod:FindClosestValidPosition(npc, target, avoidplayer, range, mode, ignorepoops)
    local validPosition = nil
    local pathfinder = npc.Pathfinder
    local room = game:GetRoom()
    local size = room:GetGridSize()
    local radius = nil
    range = range or 120
    ignorepoops = ignorepoops or false
    mode = mode or 0
    if mode == 0 then
        radius = 9999
    else
        radius = 0
    end
    local playertable = {}
    if avoidplayer then
        for _, entity in ipairs(Isaac.GetRoomEntities()) do
            if entity.Type == 1 then
                table.insert(playertable, entity)
            end
        end
    end
    for i=0, size do
        local gridpos = room:GetGridPosition(i)
        local gridEntity = room:GetGridEntity(i)
        local farfromplayer = true
        if npc.Pathfinder:HasPathToPos(gridpos, ignorepoops) and (not gridEntity or gridEntity.CollisionClass == GridCollisionClass.COLLISION_NONE) then
            if avoidplayer then
                for k = 1, #playertable do
                    if gridpos:Distance(playertable[k].Position) < avoidplayer then
                        farfromplayer = false
                    end
                end
            end
            if farfromplayer then
                if npc.Position:Distance(gridpos) < range then
                    if mode == 0 then
                        if target.Position:Distance(gridpos) < radius then
                            validPosition = gridpos
                            radius = target.Position:Distance(gridpos)
                        end
                    else
                        if target.Position:Distance(gridpos) > radius then
                            validPosition = gridpos
                            radius = target.Position:Distance(gridpos)
                        end
                    end
                end
            end
        end
    end
    if validPosition ~= nil then
        return validPosition
    else
        return npc.Position
    end
end

function mod:FindClosestFreePosition(npc, target, avoidplayer, range, mode, ignorepoops)
    local validPosition = nil
    local pathfinder = npc.Pathfinder
    local room = game:GetRoom()
    local size = room:GetGridSize()
    local radius = nil
    range = range or 120
    ignorepoops = ignorepoops or false
    mode = mode or 0
    if mode == 0 then
        radius = 9999
    else
        radius = 0
    end
    local playertable = {}
    if avoidplayer then
        for _, entity in ipairs(Isaac.GetRoomEntities()) do
            if entity.Type == 1 then
                table.insert(playertable, entity)
            end
        end
    end
    for i=0, size do
        local gridpos = room:GetGridPosition(i)
        local gridEntity = room:GetGridEntity(i)
        local farfromplayer = true
        if not gridEntity or gridEntity.CollisionClass == GridCollisionClass.COLLISION_NONE then
            if avoidplayer then
                for k = 1, #playertable do
                    if gridpos:Distance(playertable[k].Position) < avoidplayer then
                        farfromplayer = false
                    end
                end
            end
            if farfromplayer then
                if npc.Position:Distance(gridpos) < range then
                    if mode == 0 then
                        if target.Position:Distance(gridpos) < radius then
                            validPosition = gridpos
                            radius = target.Position:Distance(gridpos)
                        end
                    else
                        if target.Position:Distance(gridpos) > radius then
                            validPosition = gridpos
                            radius = target.Position:Distance(gridpos)
                        end
                    end
                end
            end
        end
    end
    if validPosition ~= nil then
        return validPosition
    else
        return npc.Position
    end
end

local EntGridToGridGrid = {
    [EntityGridCollisionClass.GRIDCOLL_NONE] = 6,
    [EntityGridCollisionClass.GRIDCOLL_WALLS_X] = GridCollisionClass.COLLISION_WALL,
    [EntityGridCollisionClass.GRIDCOLL_WALLS_Y] = GridCollisionClass.COLLISION_WALL,
    [EntityGridCollisionClass.GRIDCOLL_WALLS] = GridCollisionClass.COLLISION_WALL,
    [EntityGridCollisionClass.GRIDCOLL_BULLET] = GridCollisionClass.COLLISION_OBJECT,
    [EntityGridCollisionClass.GRIDCOLL_GROUND] = GridCollisionClass.COLLISION_PIT,
    [EntityGridCollisionClass.GRIDCOLL_NOPITS] = GridCollisionClass.COLLISION_OBJECT,
}
function mod:WouldEntCollideWithClass(ent, opp)
    local coll = ent.GridCollisionClass
    if EntGridToGridGrid[coll] then
        return opp >= EntGridToGridGrid[coll]
    elseif coll == EntityGridCollisionClass.GRIDCOLL_PITSONLY then
        return not (opp == GridCollisionClass.COLLISION_NONE or opp >= GridCollisionClass.COLLISION_OBJECT)
    end
end

--[[Modes:
    0 - Random Free Position (Grounded)
    1 - Random Free Position (Anywhere)
    2 - Random Pathfindable Position
    3 - Random Visible Position
]]
function mod:FindRandomPositionButAvoidEnt(npc, mode, avoidplayer, maxrad, minrad, idTable, avoidRad)
    local result = npc.Position
    local potentials = {}
    local room = game:GetRoom()
    local size = room:GetGridSize()
    mode = mode or 0
    local playertable = {}
    if avoidplayer then
        for _, entity in ipairs(Isaac.FindByType(1, -1, -1, false, false)) do
            table.insert(playertable, entity)
        end
    end
    local entTable = {}
    for _,ent in ipairs(Isaac.FindByType(idTable[1] or -1, idTable[2] or -1, idTable[3] or -1, false, false)) do
        table.insert(entTable, ent)
    end
    avoidRad = avoidRad or 60

    local testPath
    if mode == 2 and not npc:ToNPC() then
        testPath = Isaac.Spawn(mod.FFID.Ferrium, mod.FF.ChummerPathfinder.Var, 0, npc.Position, Vector.Zero, nil):ToNPC()
        testPath.Visible = false
        testPath:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        testPath.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        testPath.GridCollisionClass = npc.GridCollisionClass
        testPath:AddEntityFlags(EntityFlag.FLAG_NO_REWARD)
    end
    for i=0, size do
        local gridpos = room:GetGridPosition(i)
        local gridEntity = room:GetGridEntity(i)
        if mode == 1 or (not gridEntity) then
            local farfromplayer = true
            if avoidplayer then
                for k = 1, #playertable do
                    if gridpos:Distance(playertable[k].Position) < avoidplayer then
                        farfromplayer = false
                    end
                end
            end
            if farfromplayer then
                for _,ent in ipairs(entTable) do
                    if gridpos:Distance(ent.Position) < avoidRad then
                        farfromplayer = false
                    end
                end
            end
            if farfromplayer then
                if (not maxrad or npc.Position:Distance(gridpos) < maxrad) or (not minrad or npc.Position:Distance(gridpos) > minrad) then
                    if mode == 2 then
                        if npc:ToPlayer() then
                            if testPath.Pathfinder:HasPathToPos(gridpos, false) then
                                table.insert(potentials, gridpos)
                            end
                        else
                            if npc.Pathfinder:HasPathToPos(gridpos) then
                                table.insert(potentials, gridpos)
                            end
                        end
                    elseif mode == 3 then
                        if npc.EntityCollisionClass == EntityGridCollisionClass.GRIDCOLL_GROUND then
                            if room:CheckLine(npc.Position, gridpos, 0, 0, false, false) then
                                table.insert(potentials, gridpos)
                            end
                        elseif npc.EntityCollisionClass == EntityGridCollisionClass.GRIDCOLL_BULLET then
                            if room:CheckLine(npc.Position, gridpos, 3, 0, false, false) then
                                table.insert(potentials, gridpos)
                            end
                        elseif npc.EntityCollisionClass < EntityGridCollisionClass.GRIDCOLL_BULLET and npc.EntityCollisionClass > EntityGridCollisionClass.GRIDCOLL_NONE then
                            if room:CheckLine(npc.Position, gridpos, 2, 0, false, false) then --Not perfect
                                table.insert(potentials, gridpos)
                            end
                        elseif npc.EntityCollisionClass == EntityGridCollisionClass.GRIDCOLL_NONE then
                            table.insert(potentials, gridpos)
                        end
                    else
                        table.insert(potentials, gridpos)
                    end
                end
            end
        end
    end
    if mode == 2 and not npc:ToNPC() then
        testPath:Remove()
    end

    if #potentials > 0 then
        result = potentials[npc:GetDropRNG():RandomInt(#potentials)+1]
    end
    return result
end

function mod:GetBorderingIndexes(room, index, direction)
    local checker = direction or {"Up", "Right", "Down", "Left"}
    if type(direction) == "string" then
        checker = {direction}
    end

    local results = {}
    local vert = room:GetGridWidth()
    local added = 0
    for _,dir in ipairs(checker) do
        if dir == "Up" then
            if index >= vert then
                results[dir] = index-vert
            else
                results[dir] = -1
            end
            added = added+1
        elseif dir == "Left" then
            if index % vert > 0 then
                results[dir] = index-1
            else
                results[dir] = -1
            end
            added = added+1
        elseif dir == "Right" then
            if index % vert < vert-1 then
                results[dir] = index+1
            else
                results[dir] = -1
            end
            added = added+1
        elseif dir == "Down" then
            local size = room:GetGridSize()-1
            if index < size then
                results[dir] = index+vert
            else
                results[dir] = -1
            end
            added = added+1
        end
    end
    if added > 0 then
        return results
    end
end