local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local rabbitMoveTypes = {
    [0] = "Random",
    [1] = "Chase",
    [2] = "Wander",
    [3] = "Flank",
    [4] = "Herd",
    [5] = "Lazy",
}

local bal = {
    ChaseSpeed = 5,
    ChaseRunout = {10, 35, 20},
    ChaseLazy = {90, 150, 30},
    MinChase = 1,
    ChaseAng = 20,
    ChaseFlank = 60,

    WanderDist = {60, 150}, --Avoid player, min dist
    WanderAttempts = 2,
    WanderRad = 90,
    WanderLazy = {135, 200, 35},
    WanderHerd = 80,

    FlankAng = 20,
    FlankDist = {65, 160},
    FlankAttempts = 2,
    FlankTolerance = 10,
    FlankWander = {135, 200, 35},

    HerdLazy = {135, 200, 35},
    HerdLazy2 = {10, 35, 20},
    HerdRad = 150,
    HerdNum = 2,
    HerdDist = 55,

    LazyChance = 2,
    LazyTime = {35,65},
    LazyDist = 80,
    LazyFlank = {90, 150, 30},
    LazyChase = 80,
    LazyRad = 100,

    SurveyCooldown = 120,
    ShieldDecay = 15, --Lowers one shield strength every amount of frames
    
    DPlayerRad = 95,
    DPWander = 10,
    DPChase = 40,
    DRLazy = 20,
    DRWander = 50,

    RabbitDelay = 10, --Time it takes for a rabbit to reenter
    DoorIdle = {15,25},
}

local function RabbitDetermine(npc, target, rng)
    local d = mod:GetEntityData(npc)

    local playerRad = 9999
    for i = 1, game:GetNumPlayers() do
        local player = Isaac.GetPlayer(i - 1):ToPlayer()
        if player.Position:Distance(npc.Position) < playerRad and npc.Pathfinder:HasPathToPos(player.Position) then
            playerRad = player.Position:Distance(npc.Position)
            if playerRad <= bal.DPlayerRad then
                return "Chase"
            end
        end
    end
    local rabbitRad = 9999
    local chosen
    for _,rabbit in ipairs(Isaac.FindByType(mod.FF.Rabbit.ID, mod.FF.Rabbit.Var, -1, false, false)) do
        if mod:superExists(rabbit) and GetPtrHash(rabbit) ~= GetPtrHash(npc) and rabbit.Position:Distance(npc.Position) < rabbitRad
        and npc.Pathfinder:HasPathToPos(rabbit.Position) then
            chosen = rabbit
            rabbitRad = rabbit.Position:Distance(npc.Position)
        end
    end
    
    local rand = rng:RandomInt(100)
    if playerRad < rabbitRad then
        if rand < bal.DPWander then
            return "Wander"
        elseif rand < bal.DPChase then
            return "Chase"
        else
            return "Flank"
        end
    else
        if rand < bal.DRLazy then
            return "Lazy"
        elseif rand < bal.DRWander then
            return "Wander"
        else
            d.RabbitHerd = chosen
            return "Herd"
        end
    end
end

local function SurveyRabbits()
    local pool = {Random = {}, Chase = {}, Wander = {}, Flank = {}, Herd = {}, Lazy = {}, ToDetermine = {}}
    local room = game:GetRoom()
    local frames = room:GetFrameCount()
    for _,npc in ipairs(Isaac.FindByType(mod.FF.Rabbit.ID, mod.FF.Rabbit.Var, -1, false, false)) do
        if mod:superExists(npc) then
            local d = mod:GetEntityData(npc)
            local str = d.RabbitMove or "ToDetermine"
            table.insert(pool[str], npc:ToNPC())
            d.CurrentRabbitStr = str
            d.RabbitPool = pool
            d.RabbitsSurveyed = frames
        end
    end

    return pool
end

local function RabbitPoolUpdate(npc, d, move)
    if d.CurrentRabbitStr == "ToDetermine" and d.RabbitPool then
        for key, entry in pairs(d.RabbitPool[d.CurrentRabbitStr]) do
            if GetPtrHash(entry) == GetPtrHash(npc) then
                d.RabbitPool[d.CurrentRabbitStr][key] = nil
            end
        end
        table.insert(d.RabbitPool[d.RabbitMove], npc)
        d.CurrentRabbitStr = move
    elseif d.RabbitPool and d.CurrentRabbitStr and d.CurrentRabbitStr ~= move then
        for key, entry in pairs(d.RabbitPool[d.CurrentRabbitStr]) do
            if GetPtrHash(entry) == GetPtrHash(npc) then
                d.RabbitPool[d.CurrentRabbitStr][key] = nil
            end
        end
        table.insert(d.RabbitPool[move], npc)
        d.CurrentRabbitStr = move
    end
end

local function FindFlankPos(npc, target, d, rng)
    local result = npc.Position
    local angryRabbits = {}
    if not d.RabbitPool then return npc.Position end
    for _,rabbit in pairs(d.RabbitPool["Chase"]) do
        if mod:superExists(rabbit) then
            table.insert(angryRabbits, rabbit)
        end
    end
    for _,rabbit in pairs(d.RabbitPool["Flank"]) do
        if mod:superExists(rabbit) and mod:GetEntityData(rabbit).FlankState == "Chase" and GetPtrHash(npc) ~= GetPtrHash(npc) then
            table.insert(angryRabbits, rabbit)
        end
    end

    local angles = {}
    for key,entry in ipairs(angryRabbits) do
        table.insert(angles, mod:GetAngleDegreesButGood(entry.Position-target.Position))
    end

    local room = game:GetRoom()
    local size = room:GetGridSize()
    local potentials = {}
    local backups = {}
    for i=0, size do
        local gridpos = room:GetGridPosition(i)
        local gridEntity = room:GetGridEntity(i)

        if (not gridEntity or gridEntity.CollisionClass == GridCollisionClass.COLLISION_NONE) and npc.Pathfinder:HasPathToPos(gridpos, false)
        and gridpos:Distance(target.Position) < bal.FlankDist[2] and gridpos:Distance(target.Position) > bal.FlankDist[1] then
            for _,ang in ipairs(angles) do
                if mod:GetAngleDifferenceDead(mod:GetAngleDegreesButGood(gridpos-target.Position), ang) < bal.FlankAng then
                    table.insert(potentials, gridpos)
                end
                table.insert(backups, gridpos)
            end
        end
    end

    if #potentials > 0 then
        result = potentials[rng:RandomInt(#potentials)+1]
    elseif #backups > 0 then
        result = backups[rng:RandomInt(#backups)+1]
    else
        result = mod:FindRandomValidPathPosition(npc, 2, bal.WanderDist[1], nil, bal.WanderDist[2])
    end

    return result
end

local function RabbitInit(npc, d, move, force)
    if not force and d.RabbitPermanence == 1 then return end
    local blacklist
    if move == "Chase" then
        npc.StateFrame = 0
        d.RabbitChangeFrames = 0
        d.RabbitLazyFrames = 0
    elseif move == "Wander" then
        npc.StateFrame = 0
        d.RabbitChangeFrames = 0
        d.TargetPos = mod:FindRandomValidPathPosition(npc, 2, bal.WanderDist[1], nil, bal.WanderDist[2])
        d.RabbitWanders = 0
    elseif move == "Flank" then
        npc.StateFrame = 0
        d.RabbitChangeFrames = 0
        d.RabbitFlanks = 0
        d.FlankState = "Flank"
        d.TargetPos = FindFlankPos(npc, npc:GetPlayerTarget(), d, npc:GetDropRNG())
        d.RabbitFlankTol = 0
        d.RabbitLazyFrames = 0
    elseif move == "Herd" then
        if not d.RabbitHerd then
            local dist = 9999
            local chosen
            for _,rabbit in ipairs(Isaac.FindByType(mod.FF.Rabbit.ID, mod.FF.Rabbit.Var, -1, false, false)) do
                if mod:superExists(rabbit) and GetPtrHash(rabbit) ~= GetPtrHash(npc) and rabbit.Position:Distance(npc.Position) < dist
                and npc.Pathfinder:HasPathToPos(rabbit.Position) and (not mod:superExists(d.PrevRabbitHerd) or GetPtrHash(rabbit) == GetPtrHash(d.PrevRabbitHerd)) then
                    chosen = rabbit
                    dist = rabbit.Position:Distance(npc.Position)
                end
            end
            if chosen then
                d.RabbitHerd = chosen
            else
                blacklist = true
                RabbitInit(npc, d, "Lazy")
            end
        end
        if not blacklist then
            d.RabbitChangeFrames = 0
            d.RabbitLazyFrames = 0
            d.RabbitHerdFrames = 0
            npc.StateFrame = 0
            d.PrevRabbitHerd = d.RabbitHerd
        end
    elseif move == "Lazy" then
        d.TargetPos = nil
        d.RabbitChangeFrames = 0
        d.RabbitLazyFrames = 0
        npc.StateFrame = 0
    end

    if not blacklist then
        RabbitPoolUpdate(npc, d, move)
        d.RabbitMove = move
    end
end

function mod:RabbitAI(npc)
    local d = mod:GetEntityData(npc)
    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position)
    local sprite = npc:GetSprite()
    local room = game:GetRoom()
    local rng = npc:GetDropRNG()
    
    if not d.init then
        if npc.SubType & 1 == 1 then
            d.State = "AppearDoor"
            npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            npc:AddEntityFlags(EntityFlag.FLAG_NO_REWARD)
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
            npc.Color = Color(0, 0, 0, 0.5)
            d.FadedOut = 15
            d.DoorTargetPos = room:FindFreeTilePosition(npc.Position, 0)
        else
            d.State = "Idle"
        end

        d.RabbitPermanence = (npc.SubType >> 1 & 1 == 1)
        d.RabbitMove = rabbitMoveTypes[npc.SubType >> 2 & 7] or "Random"
        if d.RabbitMove == "Random" then
            d.RabbitMove = RabbitDetermine(npc, target, rng)
        end

        RabbitInit(npc, d, d.RabbitMove, true)

        d.init = true
    else
        npc.StateFrame = npc.StateFrame+1
    end

    if not d.RabbitsSurveyed or room:GetFrameCount()-d.RabbitsSurveyed > bal.SurveyCooldown then
        SurveyRabbits()
    end

    if d.RabbitMove and d.CurrentRabbitStr ~= d.RabbitMove then
        RabbitPoolUpdate(npc, d, d.RabbitMove)
    end

    if d.State == "Idle" then
        if npc:GetShieldStrength() > 0 and npc.FrameCount % bal.ShieldDecay == 0 then
            npc:SetShieldStrength(math.max(0, npc:GetShieldStrength()-1))
        end

        if not mod.IsActiveRoom() and not d.WhatTheFuckAmIDoing then
            d.State = "Skedaddle"
        end

        if d.RabbitMove == "Chase" then
            if mod:isScare(npc) then
                local targetvel = (targetpos - npc.Position):Resized(-bal.ChaseSpeed*1.2)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvel, 0.2)
                d.RabbitChangeFrames = 0
            elseif room:CheckLine(npc.Position, targetpos, 0, 1, false, false) then
                local targetvel = (targetpos - npc.Position):Resized(bal.ChaseSpeed)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvel, 0.2)
                d.RabbitChangeFrames = 0

                d.RabbitLazyFrames = d.RabbitLazyFrames+1
                if #d.RabbitPool["Chase"] > bal.MinChase then
                    if d.RabbitLazyFrames > bal.ChaseLazy[1] and rng:RandomInt(bal.ChaseLazy[3]) == 0 then
                        RabbitInit(npc, d, "Lazy")
                    elseif d.RabbitLazyFrames > bal.ChaseLazy[2] then
                        RabbitInit(npc, d, "Lazy")
                    end

                    for _,check in pairs(d.RabbitPool["Chase"]) do
                        if mod:superExists(check) then
                            local angDiff = mod:GetAngleDifferenceDead((npc.Position-target.Position), (check.Position-target.Position))
                            if (angDiff > bal.ChaseAng and angDiff < 360-bal.ChaseAng) and npc.StateFrame > bal.ChaseFlank then
                                RabbitInit(npc, d, "Flank")
                            end
                        end
                    end
                end
            else
                if npc.Pathfinder:HasPathToPos(target.Position, false) then
                    d.RabbitChangeFrames = 0
                    npc.Pathfinder:FindGridPath(targetpos, bal.ChaseSpeed/6.5, 900, true)
                else
                    d.RabbitChangeFrames = d.RabbitChangeFrames+1
                    if d.RabbitChangeFrames > bal.ChaseRunout[1] and rng:RandomInt(bal.ChaseRunout[3]) == 0 then
                        RabbitInit(npc, d, "Wander")
                    elseif d.RabbitChangeFrames > bal.ChaseRunout[2] then
                        RabbitInit(npc, d, "Wander")
                    end
                    npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.3)
                end
            end
        elseif d.RabbitMove == "Wander" then
            if not d.TargetPos or not npc.Pathfinder:HasPathToPos(d.TargetPos) then
                d.TargetPos = mod:FindRandomValidPathPosition(npc, 2, bal.WanderDist[1], nil, bal.WanderDist[2])
            end

            if npc.Position:Distance(d.TargetPos) < 20 then
                d.RabbitWanders = d.RabbitWanders+1
                if d.RabbitWanders >= bal.WanderAttempts then
                    d.TargetPos = mod:FindRandomValidPathPosition(npc, 2, bal.WanderDist[1], nil, bal.WanderDist[2])
                else
                    RabbitInit(npc, d, "Lazy")
                end
            end

            if mod:isScare(npc) then
                local targetvel = (targetpos - npc.Position):Resized(-bal.ChaseSpeed*1.2)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvel, 0.2)
            elseif d.TargetPos and room:CheckLine(npc.Position, d.TargetPos, 0, 1, false, false) then
                local targetvel = (d.TargetPos - npc.Position):Resized(bal.ChaseSpeed)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvel, 0.2)
            else
                if d.TargetPos and npc.Pathfinder:HasPathToPos(d.TargetPos, false) then
                    npc.Pathfinder:FindGridPath(d.TargetPos, bal.ChaseSpeed/6.5, 900, true)
                else
                    npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.3)
                end
            end

            local check
            for i = 1, game:GetNumPlayers() do
				local player = Isaac.GetPlayer(i - 1):ToPlayer()
				if player.Position:Distance(npc.Position) < bal.WanderRad and npc.Pathfinder:HasPathToPos(player.Position) then
                    check = true
                    RabbitInit(npc, d, "Chase")
                    break
                end
			end

            if not check and npc.StateFrame > bal.WanderHerd  then
                for _,rabbit in ipairs(Isaac.FindByType(mod.FF.Rabbit.ID, mod.FF.Rabbit.Var, -1, false, false)) do
                    if mod:superExists(rabbit) and GetPtrHash(rabbit) ~= GetPtrHash(npc) and rabbit.Position:Distance(npc.Position) < bal.WanderRad
                    and npc.Pathfinder:HasPathToPos(rabbit.Position) and (not mod:superExists(d.PrevRabbitHerd) or GetPtrHash(rabbit) == GetPtrHash(d.PrevRabbitHerd)) then
                        check = true
                        d.RabbitHerd = rabbit
                        RabbitInit(npc, d, "Herd")
                        break
                    end
                end
            end

            if not check then
                d.RabbitChangeFrames = d.RabbitChangeFrames+1
                if d.RabbitChangeFrames > bal.WanderLazy[1] and rng:RandomInt(bal.WanderLazy[3]) == 0 then
                    RabbitInit(npc, d, "Lazy")
                elseif d.RabbitChangeFrames > bal.WanderLazy[2] then
                    RabbitInit(npc, d, "Lazy")
                end
            end
        elseif d.RabbitMove == "Flank" then
            if not d.TargetPos or not npc.Pathfinder:HasPathToPos(d.TargetPos) then
                d.TargetPos = FindFlankPos(npc, target, d, rng)
                d.FlankState = "Flank"
            end

            if d.FlankState ~= "Chase" and npc.Position:Distance(d.TargetPos) < 20 then
                d.RabbitFlanks = d.RabbitFlanks+1
                if d.RabbitFlanks >= bal.FlankAttempts then
                    d.TargetPos = FindFlankPos(npc, target, d, rng)
                else
                    d.RabbitHerd = nil
                    RabbitInit(npc, d, "Herd")
                end
            end

            if room:CheckLine(npc.Position, target.Position, 0, 1, false, false) then
                if d.RabbitFlankTol > 0 then
                    d.RabbitFlankTol = d.RabbitFlankTol-1
                end
                if d.FlankState ~= "Chase" then
                    d.TargetPos = target.Position
                    d.FlankState = "Chase"
                end
            elseif d.FlankState == "Chase" then
                d.RabbitFlankTol = d.RabbitFlankTol+1
                if d.RabbitFlankTol > bal.FlankTolerance then
                    d.TargetPos = FindFlankPos(npc, target, d, rng)
                    d.FlankState = "Flank"
                end
            end

            if mod:isScare(npc) then
                local targetvel = (targetpos - npc.Position):Resized(-bal.ChaseSpeed*1.2)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvel, 0.2)
                d.RabbitChangeFrames = 0
            elseif d.TargetPos and room:CheckLine(npc.Position, d.TargetPos, 0, 1, false, false) then
                local pos = (d.FlankState == "Chase" and targetpos) or d.TargetPos
                local targetvel = (pos - npc.Position):Resized(bal.ChaseSpeed)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvel, 0.2)
                d.RabbitChangeFrames = 0
            else
                local pos = (d.FlankState == "Chase" and targetpos) or d.TargetPos or npc.Position
                if npc.Pathfinder:HasPathToPos(pos, false) then
                    d.RabbitChangeFrames = 0
                    npc.Pathfinder:FindGridPath(pos, bal.ChaseSpeed/6.5, 900, true)
                else
                    d.RabbitChangeFrames = d.RabbitChangeFrames+1
                    if d.RabbitChangeFrames > bal.ChaseRunout[1] and rng:RandomInt(bal.ChaseRunout[3]) == 0 then
                        RabbitInit(npc, d, "Wander")
                    elseif d.RabbitChangeFrames > bal.ChaseRunout[2] then
                        RabbitInit(npc, d, "Wander")
                    end
                    npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.3)
                end
            end

            d.RabbitLazyFrames = d.RabbitLazyFrames+1
            if d.RabbitLazyFrames > bal.FlankWander[1] and rng:RandomInt(bal.FlankWander[3]) == 0 then
                RabbitInit(npc, d, "Wander")
            elseif d.RabbitLazyFrames > bal.FlankWander[2] then
                RabbitInit(npc, d, "Wander")
            end
        elseif d.RabbitMove == "Herd" then
            if mod:superExists(d.RabbitHerd) then
                local pos = d.RabbitHerd.Position
                if mod:isScare(npc) then
                    local targetvel = (targetpos - npc.Position):Resized(-bal.ChaseSpeed*1.2)
                    npc.Velocity = mod:Lerp(npc.Velocity, targetvel, 0.2)
                    d.RabbitChangeFrames = 0
                elseif pos:Distance(npc.Position) < bal.HerdDist then
                    local vec = Vector(0, 2):Rotated(rng:RandomInt(360))
                    npc.Velocity = mod:Lerp(npc.Velocity, vec, 0.1)
                elseif room:CheckLine(npc.Position, pos, 0, 1, false, false) then
                    local targetvel = (pos - npc.Position):Resized(bal.ChaseSpeed)
                    npc.Velocity = mod:Lerp(npc.Velocity, targetvel, 0.2)
                    d.RabbitChangeFrames = 0
                else
                    if npc.Pathfinder:HasPathToPos(pos, false) then
                        d.RabbitChangeFrames = 0
                        npc.Pathfinder:FindGridPath(pos, bal.ChaseSpeed/6.5, 900, true)
                    else
                        d.RabbitChangeFrames = d.RabbitChangeFrames+1
                        if d.RabbitChangeFrames > bal.ChaseRunout[1] and rng:RandomInt(bal.ChaseRunout[3]) == 0 then
                            RabbitInit(npc, d, "Lazy")
                        elseif d.RabbitChangeFrames > bal.ChaseRunout[2] then
                            RabbitInit(npc, d, "Lazy")
                        end
                        npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.3)
                    end
                end

                d.RabbitLazyFrames = d.RabbitLazyFrames+1
                if d.RabbitLazyFrames > bal.HerdLazy[1] and rng:RandomInt(bal.HerdLazy[3]) == 0 then
                    RabbitInit(npc, d, "Lazy")
                elseif d.RabbitLazyFrames > bal.HerdLazy[2] then
                    RabbitInit(npc, d, "Lazy")
                end

                local herdCount = 0
                for _,rabbit in ipairs(Isaac.FindByType(mod.FF.Rabbit.ID, mod.FF.Rabbit.Var, -1, false, false)) do
                    if mod:superExists(rabbit) and GetPtrHash(rabbit) ~= GetPtrHash(npc) and rabbit.Position:Distance(npc.Position) < bal.HerdRad then
                        herdCount = herdCount+1
                        if herdCount > bal.HerdNum then
                            break
                        end
                    end
                end
                if herdCount > bal.HerdNum then
                    d.RabbitHerdFrames = d.RabbitHerdFrames+1
                    if d.RabbitHerdFrames > bal.HerdLazy2[1] and rng:RandomInt(bal.HerdLazy2[3]) == 0 then
                        RabbitInit(npc, d, "Wander")
                    elseif d.RabbitHerdFrames > bal.HerdLazy2[2] then
                        RabbitInit(npc, d, "Wander")
                    end
                else
                    d.RabbitHerdFrames = 0
                end
            else
                RabbitInit(npc, d, "Chase")
                npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.3)
            end
        elseif d.RabbitMove == "Lazy" then
            if not d.TargetPos or npc.Position:Distance(d.TargetPos) < 5 or npc.StateFrame > 60 or npc:CollidesWithGrid() or not npc.Pathfinder:HasPathToPos(d.TargetPos) then
                if d.TargetPos and rng:RandomInt(bal.LazyChance) == 0 and npc.Position:Distance(d.TargetPos) < 5 then
                    d.IdlePos = mod:RandomInt(bal.LazyTime[1], bal.LazyTime[2], rng)
                end
                d.TargetPos = mod:FindRandomValidPathPosition(npc, 3, nil, bal.LazyDist)+mod:shuntedPosition(10, rng)
                npc.StateFrame = 0
            end
    
            if mod:isScare(npc) then
                local targetvel = (target.Position - npc.Position):Resized(-bal.ChaseSpeed*1.2)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvel, 0.2)
            elseif d.IdlePos then
                if d.IdlePos > 0 then
                    d.IdlePos = d.IdlePos-1
                else
                    d.IdlePos = nil
                    d.TargetPos = mod:FindRandomValidPathPosition(npc, 3, nil, bal.LazyDist)+mod:shuntedPosition(10, rng)
                    npc.StateFrame = 0
                end
                npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.2)
            elseif d.TargetPos then
                if room:CheckLine(npc.Position, d.TargetPos, 0, 1, false, false) then
                    local targetvel = (d.TargetPos - npc.Position):Resized(bal.ChaseSpeed)
                    npc.Velocity = mod:Lerp(npc.Velocity, targetvel, 0.2)
                else
                    npc.Pathfinder:FindGridPath(d.TargetPos, bal.ChaseSpeed/6.5, 900, true)
                end
            else
                npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.2)
            end

            d.RabbitLazyFrames = d.RabbitLazyFrames+1
            if d.RabbitLazyFrames > bal.LazyFlank[1] and rng:RandomInt(bal.LazyFlank[3]) == 0 then
                RabbitInit(npc, d, "Flank")
            elseif d.RabbitLazyFrames > bal.LazyFlank[2] then
                RabbitInit(npc, d, "Flank")
            end

            d.RabbitChangeFrames = d.RabbitChangeFrames+1
            if d.RabbitChangeFrames > bal.LazyChase then
                for _,rabbit in ipairs(Isaac.FindByType(mod.FF.Rabbit.ID, mod.FF.Rabbit.Var, -1, false, false)) do
                    if mod:superExists(rabbit) and GetPtrHash(rabbit) ~= GetPtrHash(npc) and rabbit.Position:Distance(npc.Position) < bal.LazyRad then
                        --d.RabbitHerd = rabbit
                        RabbitInit(npc, d, "Chase")
                        break
                    end
                end
            end
        end

    elseif d.State == "AppearDoor" then
        if not d.DoorAppeared then
            local targetvel = (d.DoorTargetPos - npc.Position):Resized(bal.ChaseSpeed)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvel, 0.2)

            if npc.Position:Distance(d.DoorTargetPos) < 10 then
                d.DoorAppeared = mod:RandomInt(bal.DoorIdle[1], bal.DoorIdle[2], rng)
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
            end
        else
            npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.3)

            if d.DoorAppeared > 0 then
                d.DoorAppeared = d.DoorAppeared-1
            else
                d.State = "Idle"
                RabbitInit(npc, d, d.RabbitMove)
            end
        end

        if d.FadedOut then
            if d.FadedOut > 0 then
                d.FadedOut = d.FadedOut-1
                npc.Color = Color.Lerp(npc.Color, Color(1, 1, 1, 1, 0, 0, 0), 0.1)
            else
                npc.Color = Color(1, 1, 1, 1, 0, 0, 0)
                d.FadedOut = nil
            end
        end
    elseif d.State == "Skedaddle" then
        if not d.Leaving and (not d.TargetDoor or not npc.Pathfinder:HasPathToPos(d.TargetDoor[2])) then
            if not mod.RabbitsToEnter.Doors then
                mod:RabbitNewRoom(room)
            end
            local dist = 9999
            local chosen
            for key,tab in pairs(mod.RabbitsToEnter.Doors) do
                local door = room:GetDoor(key)
                if not door:IsLocked() and door:GetSprite():GetAnimation() ~= "Hidden" then
                    if npc.Position:Distance(door.Position) < dist then
                        dist = npc.Position:Distance(door.Position)
                        chosen = door
                    end
                end
            end
            if chosen then
                d.TargetDoor = {chosen, chosen.Position+Vector(40,0):Rotated(90*chosen.Direction)}
            else
                d.State = "Idle"
                d.WhatTheFuckAmIDoing = true
            end
        end
        
        if d.Leaving then
            local targetvel = (d.TargetDoor[1].Position - npc.Position):Resized(bal.ChaseSpeed)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvel, 0.2)

            if d.FadedOut then
                if d.FadedOut > 0 then
                    d.FadedOut = d.FadedOut-1
                    npc.Color = Color.Lerp(npc.Color, Color(0, 0, 0, 0, 0, 0, 0), 0.2)
                else
                    npc.Color = Color(1, 1, 1, 0, 0, 0, 0)
                    d.FadedOut = nil
                    npc:Remove()
                end
            end
        elseif d.TargetDoor and npc.Position:Distance(d.TargetDoor[2]) < 10 then
            d.Leaving = true
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            --d.Vec = Vector(-40,0):Rotated(-90*d.TargetDoor[1].Direction)
            npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.3)
            d.FadedOut = 12
        elseif d.TargetDoor then
            if room:CheckLine(npc.Position, d.TargetDoor[2], 0, 1, false, false) then
                local targetvel = (d.TargetDoor[2] - npc.Position):Resized(bal.ChaseSpeed)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvel, 0.2)
            else
                npc.Pathfinder:FindGridPath(d.TargetDoor[2], bal.ChaseSpeed/6.5, 900, true)
            end
        end
    end

    if npc.Velocity:Length() > 0.5 then
        if math.abs(npc.Velocity.X) > math.abs(npc.Velocity.Y) then
            mod:spritePlay(sprite, "WalkHori")
        else
            mod:spritePlay(sprite, "WalkVert")
        end
        npc.FlipX = npc.Velocity.X < 0
        mod:spriteOverlayPlay(sprite, "HeadMove")
    else
        mod:spriteOverlayPlay(sprite, "HeadIdle")
        mod:spritePlay(sprite, "Idle")
    end

    if npc:IsDead() and not d.RabbitDeath and not mod:isFriend(npc) then
        d.RabbitDeath = true
        if mod.RabbitsToEnter then
            mod.RabbitsToEnter.Queue = mod.RabbitsToEnter.Queue or {}
            table.insert(mod.RabbitsToEnter.Queue, {Type = "Rabbit", Priority = 0, InClearRooms = false})
        end
        --SurveyRabbits()
    end
end

function mod:RabbitUpdate(room)
    if mod.RabbitsToEnter then
        if not mod.RabbitsToEnter.Doors then
            mod:RabbitNewRoom(room)
        end
        if #mod.RabbitsToEnter.Queue > 0 then
            if mod.RabbitsToEnter.Delay > 0 then
                mod.RabbitsToEnter.Delay = mod.RabbitsToEnter.Delay-1
            else
                local q = mod.RabbitsToEnter.Queue
                local found = {}
                local isActive = mod.IsActiveRoom()
                for key,entry in ipairs(q) do
                    if entry.InClearRooms or isActive then
                        if #found == 0 then
                            found = {{entry, key}}
                        elseif entry.Priority > found[1][1].Priority then
                            found = {{entry, key}}
                        elseif entry.Priority == found[1][1].Priority then
                            table.insert(found, {entry, key})
                        end
                    end
                end

                if #found > 0 then
                    local rng = mod.RabbitsToEnter.RNG
                    local chosen = found[rng:RandomInt(#found)+1]

                    local goodDoors = {}
                    for key,tab in pairs(mod.RabbitsToEnter.Doors) do
                        local door = room:GetDoor(key)
                        if tab.Available == true and door:GetSprite():GetAnimation() ~= "Hidden" then
                            table.insert(goodDoors, key)
                        end
                    end
                    if #goodDoors > 0 then
                        local id = goodDoors[rng:RandomInt(#goodDoors)+1]
                        mod.RabbitsToEnter.Doors[id].Available = false
                        mod.RabbitsToEnter.Doors[id].State = "Init"
                        mod.RabbitsToEnter.Doors[id].WhosThere = mod:makeCopiedTable(chosen[1])
                        mod.RabbitsToEnter.Delay = bal.RabbitDelay
                        table.remove(mod.RabbitsToEnter.Queue, chosen[2])
                    else
                        if chosen[1].BackupSpawn then
                            chosen[1].BackupSpawn(chosen[1], room)
                        end

                        table.remove(mod.RabbitsToEnter.Queue, chosen[2])
                    end
                else
                    mod.RabbitsToEnter.Queue = {}
                end
            end
        end

        for key,entry in pairs(mod.RabbitsToEnter.Doors) do
            if entry.Available == false then
                local door = room:GetDoor(key)
                local sprite = door:GetSprite()
                local tab = entry.WhosThere
                if entry.State == "Init" then
                    local opening
                    if door:IsOpen() then
                        entry.DontClose = true
                    else
                        opening = true
                        sprite:Play(door.OpenAnimation, true)
                    end
                    entry.State = "Opened"
                    entry.Wait = bal.RabbitDelay
                    if opening and tab.Type == "Rabbit" then
                        local rng = mod.RabbitsToEnter.RNG
                        sfx:Play(mod.Sounds.RabbitDoor, 6, 0, false, mod:RandomInt(95,105,rng)/100)
                        if rng:RandomInt(30) == 0 then
                            sfx:Play(mod.Sounds.RabbitHorn, 6, 0, false, 1)
                        end
                    end
                elseif entry.State == "Opened" then
                    if entry.Wait > 0 then
                        entry.Wait = entry.Wait-1
                    elseif tab.Type == "Shadow Rabbits Large" then
                        for key2,entry2 in ipairs(tab.Squadron) do
                            local player = entry2.Player
                            local pd = mod:GetEntityData(player)
                            if player:Exists() and pd.ffsavedata.ShadowRabbiting and not pd.ffsavedata.ShadowRabbiting.ExitPoint then
                                mod.scheduleForUpdate(function()
                                    if player:Exists() and pd.ffsavedata.ShadowRabbiting and not pd.ffsavedata.ShadowRabbiting.ExitPoint then
                                        local rabbit = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.SHADOW_RABBIT_LARGE,
                                        0, door.Position, Vector.Zero, player):ToFamiliar()
                                        rabbit.Player = player
                                        mod:GetEntityData(rabbit).DoorAppearing = true
                                        mod:GetEntityData(rabbit).RabbitSpecial = entry2.Special
                                        rabbit:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                                        rabbit:Update()
                                    end
                                end, key2*20)
                            end
                            entry.Wait = 9999
                        end
                        mod.scheduleForUpdate(function()
                            entry.State = "Finish"
                            entry.Wait = bal.RabbitDelay
                            entry.WhosThere = nil
                        end, #tab.Squadron*20)
                    elseif tab.Type == "Shadow Rabbits Small" then
                        for key2,player in ipairs(tab.Smalls) do
                            local pd = mod:GetEntityData(player)
                            if player:Exists() and pd.ffsavedata.ShadowRabbiting and not pd.ffsavedata.ShadowRabbiting.ExitPoint then
                                mod.scheduleForUpdate(function()
                                    if player:Exists() and pd.ffsavedata.ShadowRabbiting and not pd.ffsavedata.ShadowRabbiting.ExitPoint then
                                        local rabbit = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.SHADOW_RABBIT_SMALL,
                                        0, door.Position, Vector.Zero, player):ToFamiliar()
                                        rabbit.Player = player
                                        mod:GetEntityData(rabbit).DoorAppearing = true
                                        rabbit:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                                        rabbit:Update()
                                    end
                                end, key2*20)
                            end
                            entry.Wait = 9999
                        end
                        mod.scheduleForUpdate(function()
                            entry.State = "Finish"
                            entry.Wait = bal.RabbitDelay
                        end, #tab.Smalls*20)
                    elseif tab.Type == "Rabbit" then
                        local rabbit = Isaac.Spawn(mod.FF.Rabbit.ID, mod.FF.Rabbit.Var, 1, door.Position, Vector.Zero, nil):ToNPC()
                        rabbit:Update()
                        entry.State = "Finish"
                        entry.Wait = bal.RabbitDelay
                    end
                elseif entry.State == "Finish" then
                    if entry.Wait > 0 then
                        entry.Wait = entry.Wait-1
                    else
                        local continue
                        if entry.DontClose or door:IsOpen() then
                            entry.DontClose = nil
                            continue = true
                        else
                            if door:IsLocked() then
                                if sprite:IsFinished(door.CloseAnimation) then
                                    sprite:Play(door.LockedAnimation, true)
                                    continue = true
                                else
                                    mod:spritePlay(sprite, door.CloseAnimation)
                                end
                            else
                                sprite:Play(door.CloseAnimation, true)
                                continue = true
                            end
                        end
                        if continue then
                            entry.Available = true
                        end
                    end
                end
            end
        end
    end
end

function mod:RabbitNewRoom(room)
    local doors = mod.availableDoors[room:GetRoomShape()]
    local realDoors = {}
    local rng = RNG()
    rng:SetSeed(room:GetDecorationSeed())
    for _,checkDoor in ipairs(doors) do
        local checkedDoor = room:GetDoor(checkDoor)
        if checkedDoor ~= nil then
            realDoors[checkDoor] = {Available = true}
        end
    end
    mod.RabbitsToEnter = {Queue = {}, Delay = bal.RabbitDelay, Doors = realDoors, RNG = rng}
end

function mod:RabbitColl(npc, coll, low)
    if mod:GetEntityData(npc).State == "Skedaddle" and coll.Type == npc.Type and coll.Variant == npc.Variant then
        return true
    end
end