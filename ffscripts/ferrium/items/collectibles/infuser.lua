local mod = FiendFolio
local game = Game()

local bal = {
    LowestSpeed = 0.5,
    SpeedThresh = 0.33,
}

local function GridDist(start, fin)
    local xDist = math.abs(start.X-fin.X)
    local yDist = math.abs(start.Y-fin.Y)
    return xDist+yDist
end

--950 - fireplace & GridCollisionClass.COLLISION_NONE, 3999 - grimace & GridCollisionClass.COLLISION_PIT
--999 & GridCollisionClass.COLLISION_PIT - totem lever

local blacklistedGrid = {
    [GridEntityType.GRID_SPIKES] = true,
    [GridEntityType.GRID_SPIKES_ONOFF] = true,
    [GridEntityType.GRID_LOCK] = true,
    [GridEntityType.GRID_WALL] = true,
    [GridEntityType.GRID_TRAPDOOR] = true,
    [GridEntityType.GRID_TELEPORTER] = true,
    [GridEntityType.GRID_ROCK_SPIKED] = true,
}

local function SurveyNearbyGrids(start, room, tab, threshold)
    tab = tab or {}
    threshold = threshold or GridCollisionClass.COLLISION_NONE
    local borders = mod:GetBorderingIndexes(room, start)
    local results = {}
    for dir,index in pairs(borders) do
        if not tab[index] and index >= 0 then
            local coll = room:GetGridCollision(index)
            local gridPath = room:GetGridPath(index)

            if coll <= threshold then
                local blacklist
                local grid = room:GetGridEntity(index)
                if (gridPath == 950 and coll == GridCollisionClass.COLLISION_NONE) or (gridPath == 3999 and coll == GridCollisionClass.COLLISION_PIT)
                or (gridPath == 999 and coll == GridCollisionClass.COLLISION_PIT)
                or (grid and blacklistedGrid[grid:GetType()])then
                    blacklist = true
                end
                if not blacklist then
                    results[index] = true
                else
                    results[index] = false
                end
            else
                results[index] = false
            end
        end
    end
    return results
end

local function getGridFromSpeed(speed)
    if speed < bal.LowestSpeed then
        return 1
    else
        speed = math.max(1, speed)
        local num = math.floor(math.max(2,2+(speed-1)/bal.SpeedThresh))
        return math.min(num, 5)
    end
end

mod.InfuserBeingUsed = nil
local otherInfuserInfo
local currentGrids = {}
local selectorMode = {Dir = "Down"}
mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, item, rng, player, useflags, activeSlot)
    local wackyLimiter
	for i=0,3 do
		if player:GetActiveItem(i) == FiendFolio.ITEM.COLLECTIBLE.INFUSER then
			wackyLimiter = true
		end
	end

    local d = mod:GetEntityData(player)
    if not d.UsingInfuser and mod.InfuserBeingUsed or useflags == useflags | UseFlag.USE_CARBATTERY or not wackyLimiter then
        return {Discharge = false, Remove = false, ShowAnim = false}
    end

    if not d.UsingInfuser then
        mod.InfuserBeingUsed = "Movement"
        otherInfuserInfo = {Player = player}
        d.UsingInfuser = "Movement"

        local room = game:GetRoom()
        local start = room:GetGridIndex(player.Position)
        local threshold = (player.CanFly and GridCollisionClass.COLLISION_WALL) or GridCollisionClass.COLLISION_NONE
        currentGrids[start] = {Color = "Green", Unit = true, UnitInfo = true, UnitChecked = true, Start = true}
        local targetInd = mod:GetBorderingIndexes(room, start, {"Down"})
        selectorMode = {Dir = "Down", CursorIndex = targetInd["Down"], Index = start}
        local proceedFurther = {start}
        local tempProceed = {}
        local max = getGridFromSpeed(player.MoveSpeed)
        for i=0,max do
            for _,startInd in pairs(proceedFurther) do
                local results = SurveyNearbyGrids(startInd, room, currentGrids, threshold)
                if i < max then
                    for index,result in pairs(results) do
                        if not currentGrids[index] then
                            local color = (result and "Green") or "Red"
                            currentGrids[index] = {Color = color}
                            if color == "Green" then
                                table.insert(tempProceed, index)
                            end
                        end
                    end
                else
                    local borders = mod:GetBorderingIndexes(room, startInd)
                    for dir, index in pairs(borders) do
                        if not currentGrids[index] then
                            currentGrids[index] = {Color = "Red"}
                        end
                    end
                end
            end
            proceedFurther = mod:makeCopiedTable(tempProceed)
            tempProceed = {}
        end

        --PLAY SFX, STOP THE STUFF
        
        return {Discharge = false, Remove = false, ShowAnim = true}
    elseif d.UsingInfuser == "Movement" then
        mod.InfuserBeingUsed = "Attack"

        return {Discharge = false, Remove = false, ShowAnim = false}
    elseif d.UsingInfuser == "Attack" then
        mod.InfuserBeingUsed = "Attacking"

        return {Discharge = true, Remove = false, ShowAnim = false}
    end
end, mod.ITEM.COLLECTIBLE.INFUSER)

--{Color = "Green", State = "Move", Start = true, Cursor = true}
function mod:InfuserTileChecker()
    if mod.InfuserBeingUsed then
        if otherInfuserInfo and otherInfuserInfo.Player:Exists() then
            local player = otherInfuserInfo.Player
            local room = game:GetRoom()
            for index,tab in pairs(currentGrids) do
                local pos = room:GetGridPosition(index)
                if not tab.Entity or not tab.Entity:Exists() then
                    local tile = Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.FF.InfuserTiles.Var, mod.FF.InfuserTiles.Sub, pos, Vector.Zero, player):ToEffect()
                    tile:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                    mod:GetEntityData(tile).Index = index
                    tile.Parent = player
                    tile.DepthOffset = -999
                    tile:Update()
                    tab.Entity = tile
                end
            end
        else
            otherInfuserInfo = nil
            mod.InfuserBeingUsed = nil
        end
    end
end
mod:AddCollectibleCallback("FF_POST_UPDATE_FERRIUM", mod.ITEM.COLLECTIBLE.INFUSER, mod.InfuserTileChecker)

function mod:InfuserTileEffect(e)
    local sprite = e:GetSprite()
    local d = mod:GetEntityData(e)

    if mod.InfuserBeingUsed and e.Parent and e.Parent:Exists() then
        local ind = d.Index or game:GetRoom():GetIndex(e.Position)
        local tab = currentGrids[ind]

        if tab then
            --The animation string factory
            local string = tab.Color or "Red"
            if tab.Attack then
                string = string .. "Attack"
            end
            if tab.Unit then
                string = string .. "Unit"
            end
            if selectorMode.Index and selectorMode.Index == ind then
                string = string .. "Select"
            end
            mod:spritePlay(sprite, string)

            if selectorMode.CursorIndex and selectorMode.CursorIndex == ind then
                local anim = "Arrow" .. selectorMode.Dir
                mod:spriteOverlayPlay(sprite, anim)
            else
                sprite:RemoveOverlay()
            end
        else
            e:Remove()
        end
    else
        e:Remove()
    end
end

local buttonToDir = {
    [ButtonAction.ACTION_RIGHT] = "Right",
    [ButtonAction.ACTION_UP] = "Up",
	[ButtonAction.ACTION_LEFT] = "Left",
	[ButtonAction.ACTION_DOWN] = "Down",
}

local shootActions = {
    [ButtonAction.ACTION_SHOOTLEFT] = "Left",
    [ButtonAction.ACTION_SHOOTRIGHT] = "Right",
    [ButtonAction.ACTION_SHOOTUP] = "Up",
    [ButtonAction.ACTION_SHOOTDOWN] = "Down",
}

local function nullifyAction(hook)
    if hook == InputHook.GET_ACTION_VALUE then
        return 0
    else
        return false
    end
end

local lastInput = 0
mod:AddCollectibleCallback("FF_PLAYER_INPUT_ACTION", mod.ITEM.COLLECTIBLE.INFUSER, function(_, player, d, hook, action)
	if d.UsingInfuser then
        if not (action == ButtonAction.ACTION_ITEM or action == ButtonAction.ACTION_DROP) then
            local dont
            if action == ButtonAction.ACTION_PILLCARD then
                if player:GetActiveItem(ActiveSlot.SLOT_POCKET) == mod.ITEM.COLLECTIBLE.INFUSER then
                    dont = true
                end
            end
            if not dont then
                return nullifyAction(hook)
            end
        end
	end
end)

function mod:InfuserPlayerUpdate(player)
    local d = mod:GetEntityData(player)
    local frame = game:GetFrameCount()
    local room = game:GetRoom()
    if frame-lastInput > 5 and d.UsingInfuser then
        if d.UsingInfuser == "Movement" then
            local check
            local controller = player.ControllerIndex
            for action,_ in pairs(buttonToDir) do
                if Input.IsActionPressed(action, controller) then
                    check = action
                    break
                end
            end
            if check then
                local dir = buttonToDir[check]
                local start = selectorMode.Index
                if dir and start then
                    local checked = mod:GetBorderingIndexes(room, start, {dir})
                    local select = checked[dir]
                    local tab = currentGrids[select]
                    if select >= 0 and tab and tab.Color == "Green" then
                        local tabOrig = currentGrids[start]
                        tabOrig.Unit = nil

                        --[[if not tab.UnitChecked then
                            local pos = room:GetGridPosition(select)
                            local enemyFound
                            for _,entity in ipairs(Isaac.FindInRadius(pos, 20, EntityPartition.ENEMY)) do
                                if entity:IsActiveEnemy() and (not mod:isFriend(entity)) and (not entity:HasEntityFlags(EntityFlag.FLAG_NO_TARGET)) then
                                    enemyFound = true
                                    break
                                end
                            end
                            tab.UnitChecked = true
                            tab.UnitInfo = enemyFound
                        end]]
                        tab.Unit = true
                        selectorMode.Index = select

                        local dir2 = selectorMode.Dir or "Down"
                        local targetInd = mod:GetBorderingIndexes(room, select, {dir2})
                        selectorMode.CursorIndex = targetInd[dir2]
                    end
                    lastInput = game:GetFrameCount()
                end
            end
            check = nil
            for action,_ in pairs(shootActions) do
                if Input.IsActionPressed(action, controller) then
                    check = action
                    break
                end
            end
            if check then
                local dir = shootActions[check]
                local start = selectorMode.Index
                if dir and start then
                    local checked = mod:GetBorderingIndexes(room, start, {dir})
                    local select = checked[dir]
                    local tab = currentGrids[select]
                    print(select)
                    if select >= 0 then
                        if not tab then
                            local pos = room:GetGridPosition(select)
                            local enemyFound
                            for _,entity in ipairs(Isaac.FindInRadius(pos, 20, EntityPartition.ENEMY)) do
                                if entity:IsActiveEnemy() and (not mod:isFriend(entity)) and (not entity:HasEntityFlags(EntityFlag.FLAG_NO_TARGET)) then
                                    enemyFound = true
                                    break
                                end
                            end
                            currentGrids[select] = {Color = "Blank", Unit = enemyFound, UnitInfo = enemyFound, UnitChecked = true}
                            print("new")
                        end

                        print("wheee")
                        selectorMode.CursorIndex = select
                        selectorMode.Dir = dir
                    end
                    lastInput = game:GetFrameCount()
                end
            end
        else

        end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.ITEM.COLLECTIBLE.INFUSER, mod.InfuserPlayerUpdate)


function mod:InfuserNewRoom()
    mod.InfuserBeingUsed = nil
    otherInfuserInfo = nil
    currentGrids = {}
    selectorMode = {Dir = "Down"}
end