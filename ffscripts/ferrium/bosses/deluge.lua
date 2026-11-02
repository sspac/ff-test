local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local bal = {
    Speed = 1.5,
    Speed2 = 1,
    Speed3 = 0.66,
    HorseOffset = Vector(50, 10),
    --[[FloodingRange = 120, --Range when flooded bubbles pop (NOT USED HERE, HAS TO BE APPLIED IN MAIN.LUA IN BUBBLE CODE) Also in statuses/flooded
    FloodingDur = 200,
    FloodingSlowMin = 0.05, --Subtracts 0.05 if below 1 speed
    FloodingSlowMax = 0.9, --Multiplier if above 1 speed
    FloodingSlippy = 0.6,]]

    MRange = 180, --Range for random movement
    MMax = 40, --Max time moving
    MRest = {30,60}, --Random wander period
    MRestChance = 2, --Chance to wander after moving
    MWChance = 5, --This and below are stuff that determines random wandering
    MWTime = 10,
    MFNum = 4, --Moves toward the player every X move triggers

    --Flak Cannon
    FlakTime = {30,60,20,0}, --Minimum time, max time, chance, then stateframe modifier
    FSpeed1 = 14.5, --Main shotspeed
    FSpeed2 = 9.5,
    FScale1 = 2.5,
    FScale2 = {65, 100},
    FLifetime = 25, --How long before the spread decels harsher
    FDecel = {0.95, 0.8},
    FDecel2 = 0.96,
    FLifeTime2 = 26,
    FNum = 8, --Number of split shots

    --Charge
    ChargeTime = {40, 80, 25, -20},
    CSlowMax = 3, --Initial charge speed, and how it accels from 0
    CSlowSpeed = 0.1,
    CSlowAccel = 0.05,
    CSpeed = 12, --Speed when it starts fully charging
    COutsideDist = 80, --How far outside the room Deluge starts charging back
    COutsideSpeed = 3,
    COutsideTime = 60,
    CYank = {10, 20, 25},
    CYankDist = {120, 80, 40},
    CGrav = -4, --Fallspeed for Deluge's body
    CGrav2 = -8,
    CSplatNum = 10, --Number of shots in the ring upon splash and trajectory
    CSplatGrav = {-15, 1.1},
    CSplatSpeed = 3,
    CBodySpeed = 4,
    CBubbles = 6, --Bubbles spawned on impact. Every other bubble is Flooded
    CBubbleSpeed = 8,
    CReleaseSpeed = 10, --Fires in an x upon dragging out
    CBBubbleStart = 20,
    CBBubbleFreq = 21,
    CBBubblePosOff = 30,

    --Twirl
    TwirlTime = {50, 70, 25, -20},
    TAmount = 2, --Amount of spins Deluge does (Animation works best when it stops after a loop), add one for the ending
    TSpeed = 7.5,
    TDecay = 0.35,
    TAngleInc = 60,
    TBubbleSpeed = 6,
    TFreq = 5, --Spawn rate
    TFlood = 3, --One per this many will be flooded
    TMinDist = 180,

    --Phase Change
    PThreshhold = {0.375, 0.3}, --Phase change on first, if health crosses second threshhold, becomes nearly invulnerable (1 damage)
    PReduction = 0.1, --Multiplies damage taken by this amount
    PGrav = -6, --For the horse
    PHorseRange = 160,
    --Repeats the same effects as the charge splash?

    --Greg stuff
    GShotSpeed = 11,
    GShotAngle = {10, 30}, --first for swim, second for laser
    GRecoil = 4,
    GSlippy = 0.05,
    GSpriteSpeed = 0.45, --How much speed is needed to update the body's direction.
    GMouthOffset = -8,
    GBubbleSpeed = 13,
    --Fires triple shot after each attack. Decides on a shot angle for each attack. Recoil after firing shot.

    --Laser
    LaserTime = {35, 75, 20},
    LCharge = 10,
    LRotate = 1.5,
    LScale = 0.4, --Laser Width, Bazazel is 0.35
    LMove = 6.5,
    LLerp = 0.1,
    LSplash = 4, --Frequency of splatter bullets
    LFall = {75,120},
    LAccel = 1.1,
    LSpeed = {75,160},
    LAngle = 40,
    LScale2 = {50, 80},
    LFollowPlayer = 60,
    LImpactBubbles = 3,
    LImpactSpeed = {60,95},
    LImpactAngle = 50,
    LShootDelay = 20, --Time before shooting after the attack ends

    --Swim
    SwimTime = {35, 75, 20},
    SSpeed = 7,
    SFreq = 7,
    SFlood = 4,
    SSlippy = 0.1,
    STime = 80,
    SHopRange = 95, --Mostly cosmetic, where it can jump out
    SGrav = -6,
    SDist = 30,
    SXYOffset = 0.8, --Balancing out rooms being longer than they are tall
    STooShort = 60,
    SAngle = 35,
    SShootDelay = 25,

    DontDeleteRipple = 114,
}

--sound effects, various small visual poofs

local floodedColor = Color(0.7, 0.7, 0.7, 1, 0, 0, 0.6)

local phase1Attacks = {"Flak", "Charge", "Twirl"}
local phase2Attacks = {"Laser", "Swim"} --actually, realizing this isn't needed cause it's only two
local extraOffset = {["L"] = Vector(-14, 0), ["DL"] = Vector(-9, 0), ["R"] = Vector(14, 0), ["DR"] = Vector(9, 0),}

local function GetDelugeAttack(d, rng, attacks)
    if d.LastDelugeAttack then
        local list = mod:RemoveEntryThroughResult(attacks, d.LastDelugeAttack)
        local first = list[rng:RandomInt(#list)+1]
        local attacks2 = mod:RemoveEntryThroughResult(attacks, first)
        local ret = mod:GetRandomOrderedTable(attacks2, rng, {first})
        d.LastDelugeAttack = ret[3]
        return ret
    else
        local ret = mod:GetRandomOrderedTable(attacks, rng)
        d.LastDelugeAttack = ret[3]
        return ret
    end
end

--0 is directional, 1 is anywhere.
local function FindDelugeBodySpot(npc, rng, mode, range)
    local d = mod:GetEntityData(npc)
    local room = game:GetRoom()
    if mode == 0 then
        local results = {}
        local dest = room:GetGridPosition(room:GetGridIndex(npc.Position))
        local originPoint = dest+Vector(-40*d.ChargeDir, -40)
        for j=0,2 do
            local newPoint = originPoint+Vector(0, 40*j)
            if room:GetGridCollisionAtPos(newPoint) < GridCollisionClass.COLLISION_OBJECT then
                table.insert(results, newPoint)
            end
        end
        if #results > 0 then
            dest = results[rng:RandomInt(#results)+1]
        end
        return dest+mod:shuntedPosition(20, rng)
    elseif mode == 1 then
        local results = {}
        local size = room:GetGridSize()
        for i=0, size do
            local gridPos = room:GetGridPosition(i)
            if room:GetGridCollision(i) < GridCollisionClass.COLLISION_OBJECT and gridPos:Distance(npc.Position) < range and room:CheckLine(npc.Position, gridPos, 3, 1, false, false) then
                table.insert(results, gridPos)
            end
        end

        if #results > 0 then
            return results[rng:RandomInt(#results)+1]
        else
            return npc.Position
        end
    end
end

local function SlopeFunc(m, x, y) --only input the one needed, return where x/y would be in the equation
    local cent = game:GetRoom():GetCenterPos()
    local b = cent.Y-m*cent.X
    if x then
        return m*x+b
    else
        return (y-b)/m
    end
end

local function GetTwirlPos(npc, rng)
    local room = game:GetRoom()
    --Geometry class pays off, chops the room in half perpindicularly from the center to the enemy. Then chooses a spot in the opposite sector.
    local cent = room:GetCenterPos()
    local vec = (cent-npc.Position):Rotated(90):Normalized()
    local failsafe
    local slope
    if vec.X ~= 0 then
        slope = vec.Y/vec.X
    else
        failsafe = true
    end
    local orient = 1
    if failsafe or math.abs(npc.Position.X-cent.X) >math.abs(npc.Position.Y-cent.Y) then
        orient = 0
    end
    local sector = 0 --Sector 0 is lower on the x/y axis
    if (orient == 0 and npc.Position.X > cent.X) or (orient == 1 and npc.Position.Y > cent.Y) then
        sector = 1
    end

    local results = {}
    local size = room:GetGridSize()
	for i=0, size do
		local gridPos = room:GetGridPosition(i)
        if room:GetGridCollision(i) < GridCollisionClass.COLLISION_OBJECT and gridPos:Distance(npc.Position) > bal.TMinDist and room:CheckLine(npc.Position, gridPos, 3, 1, false, false) then
            if orient == 0 then --X
                local x = (failsafe and cent.X) or SlopeFunc(slope, nil, gridPos.Y)
                if sector == 0 then
                    if gridPos.X > x then
                        table.insert(results, gridPos)
                    end
                else
                    if gridPos.X < x then
                        table.insert(results, gridPos)
                    end
                end
            else --Y
                local y = SlopeFunc(slope, gridPos.X)
                if sector == 0 then
                    if gridPos.Y > y then
                        table.insert(results, gridPos)
                    end
                else
                    if gridPos.Y < y then
                        table.insert(results, gridPos)
                    end
                end
            end
        end
    end

    if #results > 0 then
        return results[rng:RandomInt(#results)+1]
    else
        return npc.Position
    end
end

local function CheckLine(pos, dir, str)
    local room = game:GetRoom()
    local check = true
    local failsafe = 0
    local origin = pos
    while check or failsafe < 15 do
        failsafe = failsafe+1
        local checkPos = pos+dir*failsafe
        origin = pos-dir
        if room:GetGridCollisionAtPos(checkPos) >= GridCollisionClass.COLLISION_OBJECT then
            return {origin, 40*failsafe, dir, str}
        end
    end
    return {origin, failsafe*40, dir, str}
end

local function CheckSwimPos(npc, target, blacklist)
    if blacklist and target then
        local initial
        local compare

        if blacklist == "L" or blacklist == "R" then
            if target.Position.Y > npc.Position.Y then
                initial = CheckLine(npc.Position, Vector(0, 40), "D")
            else
                initial = CheckLine(npc.Position, Vector(0, -40), "U")
            end
            if target.Position.Y < npc.Position.Y then
                compare = CheckLine(npc.Position, Vector(0, 40), "D")
            else
                compare = CheckLine(npc.Position, Vector(0, -40), "U")
            end
            if compare[2] > initial[2]*bal.SXYOffset then
                initial = compare
            end
        else
            if target.Position.X > npc.Position.X then
                initial = CheckLine(npc.Position, Vector(40, 0), "R")
            else
                initial = CheckLine(npc.Position, Vector(-40, 0), "L")
            end
            if target.Position.X < npc.Position.X then
                compare = CheckLine(npc.Position, Vector(40, 0), "R")
            else
                compare = CheckLine(npc.Position, Vector(-40, 0), "L")
            end
            if compare[2] > initial[2]*bal.SXYOffset then
                initial = compare
            end
        end
        if initial[2] > bal.STooShort then
            return {initial[1], initial[3], initial[4]}
        end
    elseif target then
        local initial
        local compare

        if math.abs(target.Position.X-npc.Position.X) > math.abs(target.Position.Y-npc.Position.Y) then
            if target.Position.X > npc.Position.X then
                initial = CheckLine(npc.Position, Vector(40, 0), "R")
            else
                initial = CheckLine(npc.Position, Vector(-40, 0), "L")
            end

            if target.Position.Y > npc.Position.Y then
                compare = CheckLine(npc.Position, Vector(0, 40), "D")
            else
                compare = CheckLine(npc.Position, Vector(0, -40), "U")
            end

            if compare[2] > initial[2]*bal.SXYOffset then
                initial = compare
            end
        else
            if target.Position.Y > npc.Position.Y then
                initial = CheckLine(npc.Position, Vector(0, 40), "D")
            else
                initial = CheckLine(npc.Position, Vector(0, -40), "U")
            end

            if target.Position.X > npc.Position.X then
                compare = CheckLine(npc.Position, Vector(40, 0), "R")
            else
                compare = CheckLine(npc.Position, Vector(-40, 0), "L")
            end

            if compare[2]*bal.SXYOffset > initial[2] then
                initial = compare
            end
        end

        if initial[2] < bal.STooShort then
            local compare2
            if target.Position.X < npc.Position.X then
                compare = CheckLine(npc.Position, Vector(40, 0), "R")
            else
                compare = CheckLine(npc.Position, Vector(-40, 0), "L")
            end
            if target.Position.Y < npc.Position.Y then
                compare2 = CheckLine(npc.Position, Vector(0, 40), "D")
            else
                compare2 = CheckLine(npc.Position, Vector(0, -40), "U")
            end

            if compare[2]*bal.SXYOffset > compare2[2] then
                compare = compare2
            end

            if compare[2] > initial[2] then
                initial = compare
            end
        end

        return {initial[1], initial[3], initial[4]}
    end
end

local numToDir = {[1] = "R", [2] = "DR", [3] = "D", [4] = "DL", [5] = "L", [6] = "UL", [7] = "U", [8] = "UR"}

function mod:DelugeAI(npc, sprite, d)
    local target = npc:GetPlayerTarget()
    local room = game:GetRoom()
    local rng = npc:GetDropRNG()
    local targetPos = mod:confusePos(npc, target.Position)

    if not d.Init then
        npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS
        d.DelugeAttackQueue = GetDelugeAttack(d, rng, phase1Attacks)
        d.LastDelugeDir = "L"
        d.State = "Idle"
        d.ExtraFrames = 0

        d.DelugeGregSprite = Sprite()
        d.DelugeGregSprite:Load("gfx/bosses/deluge/boss_greg.anm2", true)
        d.DelugeOverlaySprite = Sprite()
        d.DelugeOverlaySprite:Load("gfx/bosses/deluge/boss_deluge.anm2", true)
        d.DelugeOverlaySprite:ReplaceSpritesheet(0, "gfx/bosses/deluge/boss_deluge_cut.png", true)

        d.Init = true
    else
        npc.StateFrame = npc.StateFrame+1
    end

    if d.State == "Idle" then
        if d.PreparedForPhaseChange then
            d.State = "ChangingPhases"
        else

            if mod:isScare(npc) then
                npc.Velocity = mod:Lerp(npc.Velocity, (targetPos-npc.Position):Resized(bal.Speed*1.5), 0.3)
            else
                if not d.MoveDest then
                    d.MoveFrames = 0
                    d.MoveDest = mod:FindRandomValidPathPosition(npc, 3, 60, bal.MRange)
                    d.MoveNums = 0
                    d.WanderVec = Vector(0, bal.Speed2):Rotated(rng:RandomInt(360))
                end

                d.MoveFrames = d.MoveFrames+1

                if d.MoveRest then
                    if d.MoveRest > 0 then
                        npc.Velocity = mod:Lerp(npc.Velocity, d.WanderVec:Resized(bal.Speed2), 0.15)
                        d.MoveRest = d.MoveRest-1
                        d.WanderTime = (d.WanderTime or 0)+1
                        if d.WanderTime > bal.MWTime and rng:RandomInt(bal.MWChance) == 0 then
                            d.WanderTime = 0
                            d.WanderVec = Vector(0, bal.Speed2):Rotated(rng:RandomInt(360))
                        end
                    else
                        d.MoveFrames = 0
                        d.MoveDest = mod:FindRandomValidPathPosition(npc, 3, 60, bal.MRange)
                        d.MoveRest = nil
                    end
                elseif npc.Position:Distance(d.MoveDest) < 20 or d.MoveFrames > bal.MMax then
                    d.MoveNums = (d.MoveNums or 0)+1
                    if rng:RandomInt(bal.MRestChance) == 0 then
                        d.MoveRest = mod:RandomInt(bal.MRest[1], bal.MRest[2], rng)
                    elseif d.MoveNums > bal.MFNum then
                        d.MoveNums = 0
                        d.MoveFrames = 0
                        d.MoveDest = mod:FindClosestValidPosition(npc, target, 60, bal.MRange, 0)
                    else
                        d.MoveFrames = 0
                        d.MoveDest = mod:FindRandomValidPathPosition(npc, 3, 60, bal.MRange)
                    end
                else
                    if room:CheckLine(npc.Position, d.MoveDest, 3, 1, false, false) then
                        local targetvel = (d.MoveDest - npc.Position):Resized(bal.Speed)
                        npc.Velocity = mod:Lerp(npc.Velocity, targetvel, 0.25)
                    elseif npc.Pathfinder:HasPathToPos(d.MoveDest) then
                        npc.Pathfinder:FindGridPath(d.MoveDest, bal.Speed/6.5, 900, true)
                    else
                        d.MoveRest = mod:RandomInt(bal.MRest[1], bal.MRest[2], rng)
                    end
                end
            end

            sprite.FlipX = npc.Velocity.X < 0

            mod:spritePlay(sprite, "Idle")

            if not mod:isScareOrConfuse(npc) then
                local nextAttack = d.DelugeAttackQueue[1]
                --Certain attacks happen quicker if criteria is met. Flak charges faster if in line of sight, Charge if the player is horizontal.
                d.ExtraFrames = d.ExtraFrames+1
                if nextAttack == "Flak" and d.ExtraFrames % 2 == 0 and room:CheckLine(npc.Position, target.Position, 0, 1, false, false) then
                    npc.StateFrame = npc.StateFrame+1
                elseif nextAttack == "Charge" and math.abs(target.Position.Y-npc.Position.Y) < 60 then
                    npc.StateFrame = npc.StateFrame+1
                elseif nextAttack == "Twirl" then
                end

                local tab = bal[nextAttack .. "Time"]
                local active
                if npc.StateFrame > tab[2] then
                    active = true
                elseif npc.StateFrame > tab[1] and rng:RandomInt(tab[3]) == 0 then
                    active = true
                end

                if active then
                    d.State = nextAttack
                    if nextAttack == "Charge" then
                        sprite.FlipX = target.Position.X < npc.Position.X
                        d.ChargeDir = (target.Position.X > npc.Position.X and 1) or -1
                    elseif nextAttack == "Twirl" then
                        --Determine twirl dest here
                        d.TwirlDest = GetTwirlPos(npc, rng)
                        d.SubState = "Begin"
                        d.TwirlMovement = nil
                    end
                end
            end
        end
    elseif d.State == "Flak" then
        sprite.FlipX = target.Position.X < npc.Position.X

        if sprite:IsFinished("BasicShot") then
            d.State = "Idle"
            d.MoveDest = nil
            table.remove(d.DelugeAttackQueue, 1)
            if #d.DelugeAttackQueue == 0 then
                d.DelugeAttackQueue = GetDelugeAttack(d, rng, phase1Attacks)
            end
            npc.StateFrame = bal.FlakTime[4]
            d.ExtraFrames = 0
        elseif sprite:IsEventTriggered("Sound") then
            npc:PlaySound(mod.Sounds.DelugeShot, 1.5, 0, false, mod:RandomInt(90,105,rng)/100)
        elseif sprite:IsEventTriggered("Shoot") then
            npc:PlaySound(mod.Sounds.PotatoCannon, 1.1, 0, false, mod:RandomInt(90,110,rng)/100)
            local xOff = (sprite.FlipX and -bal.HorseOffset.X) or bal.HorseOffset.X
            local poof = Isaac.Spawn(1000, EffectVariant.POOF02, 0, npc.Position, Vector.Zero, npc):ToEffect()
            poof:FollowParent(npc)
            poof.SpriteOffset = Vector(xOff+((sprite.FlipX and 5) or -5), -bal.HorseOffset.Y-12)
            poof.DepthOffset = 10
            poof.SpriteScale = Vector(0.6, 0.7)
            poof.Color = Color(0.2, 1, 1, 0.3, 0.6, 0.8, 1)
            mod:GetEntityData(poof).FollowFlipX = true
            poof:Update()

            local params = ProjectileParams()
            params.HeightModifier = -bal.HorseOffset.Y+4
            params.Scale = bal.FScale1
            params.Variant = ProjectileVariant.PROJECTILE_TEAR
            params.FallingAccelModifier = -0.05
            params.FallingSpeedModifier = 0
            local pos = npc.Position+Vector(xOff, 0)
            local proj = npc:FireProjectilesEx(pos, (target.Position-pos):Resized(bal.FSpeed1), 0, params)[1]

            local pelletFunc = function(v)
                if v.FrameCount > bal.FLifetime then
                    --v.FallingAccel = 1.1
                    v.Velocity = v.Velocity*bal.FDecel[2]
                else
                    v.FallingAccel = v.FallingAccel+0.05
                    v.FallingSpeed = 0
                    v.Velocity = v.Velocity*bal.FDecel[1]
                end
            end
            mod:GetEntityData(proj).projType = "customProjectileBehavior"
			mod:GetEntityData(proj).customProjectileBehavior = {death = function(v, tab)
                local rangle = rng:RandomInt(360)
                local posOff = v.Position
                local fails = 0
                while not tab.TimeoutDeath and (not room:IsPositionInRoom(posOff, 0) or room:GetGridCollisionAtPos(posOff)) and fails < 10 do
                    posOff = posOff-v.Velocity
                    fails = fails+1
                    if fails == 10 then
                        posOff = v.Position
                    end
                end
                posOff = posOff-v.Velocity
                for _,tPoof in ipairs(Isaac.FindByType(1000, EffectVariant.TEAR_POOF_A, -1, false, false)) do
                    if tPoof.FrameCount < 2 and poof.Position:Distance(v.Position) < 5 then
                        tPoof.Position = posOff+v.Velocity*2
                        v.Position = posOff
                        break
                    end
                end
                for i=1,bal.FNum do
                    local p = mod:LazySpawnProjectile(ProjectileVariant.PROJECTILE_TEAR, 0, posOff, Vector(bal.FSpeed2, 0):Rotated(rangle+i*(360/bal.FNum)), npc):ToProjectile()
                    p.Scale = mod:RandomInt(bal.FScale2[1], bal.FScale2[2], rng)/100
                    p.Height = v.Height
                    p.FallingAccel = -0.05
                    p.FallingSpeed = 0
                    p.ProjectileFlags = v.ProjectileFlags | ProjectileFlags.BOUNCE
                    mod:GetEntityData(p).projType = "customProjectileBehavior"
			        mod:GetEntityData(p).customProjectileBehavior = {update = pelletFunc}
                end
            end, update = function(v, tab)
                v.Velocity = v.Velocity*bal.FDecel2
                if v.FrameCount > bal.FLifeTime2 then
                    tab.TimeoutDeath = true
                    v:Die()
                else
                    v.FallingSpeed = 0
                    v.FallingAccel = -0.05
                end
            end}
        else
            mod:spritePlay(sprite, "BasicShot")
        end

        npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.2)
    elseif d.State == "Charge" then
        if sprite:IsFinished("ChargeBegin") then
            d.State = "ChargeHorse"
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
            d.SubState = "Begin"
            local neg = (sprite.FlipX and -1) or 1
            d.LineDummy = mod:AddDummyEffect(npc, Vector(-5*neg,5))

            local spot = FindDelugeBodySpot(npc, rng, 0)
            local vel = (spot-npc.Position)*0.025
            local body = Isaac.Spawn(mod.FF.DelugeHelper.ID, mod.FF.DelugeHelper.Var, 0, npc.Position, vel, npc):ToNPC()
            body.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            body.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
            body:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            body:GetSprite():Play("FallingBack", true)
            body:GetSprite().FlipX = vel.X > 0
            body:SetShadowSize(0.2)
            mod:GetEntityData(body).launchedEnemyInfo = {zVel = bal.CGrav, height = -20, pos = true,landFunc = function(n)
                if room:GetGridCollisionAtPos(n.Position) == GridCollisionClass.COLLISION_SOLID and room:GetGridEntityFromPos(n.Position) then
                    room:GetGridEntityFromPos(n.Position):Destroy()
                end
				n:PlaySound(SoundEffect.SOUND_BOSS2_DIVE, 1, 0, false, 1)
                local rangle = rng:RandomInt(360)
                local params = ProjectileParams()
                params.Variant = 4
                params.FallingSpeedModifier = bal.CSplatGrav[1]
                params.FallingAccelModifier = bal.CSplatGrav[2]
				for i=1,bal.CSplatNum do
                    npc:FireProjectilesEx(n.Position, Vector(bal.CSplatSpeed, 0):Rotated(rangle+i*360/bal.CSplatNum), 0, params)
				end
                rangle = rng:RandomInt(360)
                mod.scheduleForUpdate(function()
                    if not mod:isFriend(npc) then
                        for i=1,bal.CBubbles do
                            local dir = Vector(bal.CBubbleSpeed, 0):Rotated(rangle+i*360/bal.CBubbles)
                            local sub = 11
                            if i % 2 == 0 then
                                sub = 7
                            end
                            local bubble = Isaac.Spawn(mod.FF.Bubble.ID, mod.FF.Bubble.Var, sub, n.Position+dir:Resized(5), dir, npc)
                            bubble:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                            bubble.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
                            if i % 2 == 1 then
                                mod:GetEntityData(bubble).FloodedBubble = true
                                --bubble.Color = floodedColor
                            else
                                mod:GetEntityData(bubble).DelugeBuffed = true
                            end
                            mod.scheduleForUpdate(function()
                                bubble.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                            end, 3)
                        end
                    end
                end, 1)
                --body.Visible = false
                body.Color = Color(1, 1, 1, 0, 0, 0, 0)
                mod:GetEntityData(body).SubmergedBody = true
                body.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS
                local splash = Isaac.Spawn(1000, EffectVariant.BIG_SPLASH, 0, n.Position, Vector.Zero, n)
			end}
            body.Parent = npc
            body:Update()
            d.DelugeBody = body
            d.BodyDummy = mod:AddDummyEffect(body, Vector(0, 20))

            local line = Isaac.Spawn(mod.FF.FishingLine.ID, mod.FF.FishingLine.Var, mod.FF.FishingLine.Sub, npc.Position, Vector.Zero, npc):ToNPC()
			line:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			line:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_DEATH_TRIGGER | EntityFlag.FLAG_NO_REWARD)
			line.Parent = d.LineDummy
			line.Target = d.BodyDummy
            d.FishingLine = line
        elseif sprite:IsEventTriggered("Shoot") then
            d.DelugeCharge = 0
            d.DelugeChargeSpeed = bal.CSlowSpeed
        elseif sprite:IsEventTriggered("Sound") then
            npc:PlaySound(mod.Sounds.DelugeChargeWarn, 1.5, 0, false, mod:RandomInt(95,105,rng)/100)
        else
            mod:spritePlay(sprite, "ChargeBegin")
        end

        if not d.DelugeCharge then
            npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.3)
        else
            d.DelugeCharge = math.min(bal.CSpeed, d.DelugeCharge+d.DelugeChargeSpeed)
            d.DelugeChargeSpeed = d.DelugeChargeSpeed+bal.CSlowAccel
            npc.Velocity = mod:Lerp(npc.Velocity, Vector(d.DelugeCharge*d.ChargeDir, 0), 0.3)
        end
    elseif d.State == "ChargeHorse" then
        if d.SubState == "Begin" then
            if sprite:IsFinished("HorseChargeStart") then
                d.SubState = "Idle"
            elseif sprite:IsEventTriggered("Shoot") then
                d.DelugeCharge = nil
            else
                mod:spritePlay(sprite, "HorseChargeStart")
            end
            if d.DelugeCharge then
                d.DelugeCharge = math.min(bal.CSpeed, d.DelugeCharge+d.DelugeChargeSpeed)
                d.DelugeChargeSpeed = d.DelugeChargeSpeed+bal.CSlowAccel
                npc.Velocity = mod:Lerp(npc.Velocity, Vector(d.DelugeCharge*d.ChargeDir, 0), 0.3)
            else
                npc.Velocity = mod:Lerp(npc.Velocity, Vector(bal.CSpeed*d.ChargeDir, 0), 0.3)
            end
        elseif d.SubState == "Idle" then
            if not d.FullyFadedOut then
                if not d.DelugeFade and not room:IsPositionInRoom(npc.Position, 0) then
                    d.DelugeFade = 1
                elseif d.DelugeFade then
                    d.DelugeFade = math.max(0, d.DelugeFade-0.2)
                    npc.Color = Color(npc.Color.R, npc.Color.G, npc.Color.B, d.DelugeFade, npc.Color.RO, npc.Color.GO, npc.Color.BO)
                    if d.DelugeFade == 0 then
                        npc.StateFrame = 0
                        d.YankCounter = 1
                        d.CurrentYPos = npc.Position.Y
                        d.FullyFadedOut = true
                        npc.Visible = false
                    end
                end

                npc.Velocity = mod:Lerp(npc.Velocity, Vector(bal.CSpeed*d.ChargeDir, 0), 0.3)
            elseif not d.BeginReturn then
                if bal.COutsideTime-npc.StateFrame < 15 and mod:superExists(d.FishingLine) then
                    local frame = sprite:GetFrame()
                    if (bal.COutsideTime-npc.StateFrame) % 7 == 0 or (d.JustFlashed and npc.StateFrame-d.JustFlashed < 4) then
                        if not d.JustFlashed then
                            d.JustFlashed = npc.StateFrame
                        end
                        d.FishingLine:GetSprite():SetFrame("FlashRed", frame)
                    else
                        d.JustFlashed = nil
                        d.FishingLine:GetSprite():SetFrame("Idle", frame)
                    end
                end

                if npc.StateFrame > bal.COutsideTime then
                    d.BeginReturn = true
                    d.ChargeDir = d.ChargeDir*-1
                    --sprite.FlipX = d.ChargeDir < 0
                    npc.Visible = true
                    local frame = sprite:GetFrame()
                    d.FishingLine:GetSprite():SetFrame("Idle", frame)
                    d.JustFlashed = nil
                elseif bal.CYank[d.YankCounter] and npc.StateFrame > bal.CYank[d.YankCounter] then
                    local dist = mod:RandomInt(math.ceil(bal.CYankDist[d.YankCounter]/2), bal.CYankDist[d.YankCounter])
                    local dir = -1+rng:RandomInt(2)*2
                    local failed
                    if (dir == 1 and d.CurrentYPos+dist > room:GetBottomRightPos().Y) or (dir == -1 and d.CurrentYPos-dist < room:GetTopLeftPos().Y) then
                        dir = dir*-1
                        failed = true
                    end
                    if failed and ((dir == 1 and d.CurrentYPos+dist > room:GetBottomRightPos().Y) or (dir == -1 and d.CurrentYPos-dist < room:GetTopLeftPos().Y)) then
                        dir = 0
                    end
                    d.CurrentYPos = d.CurrentYPos+dist*dir
                    d.YankCounter = d.YankCounter+1
                end
                local xPos = (d.ChargeDir == -1 and room:GetTopLeftPos().X-bal.COutsideDist) or room:GetBottomRightPos().X+bal.COutsideDist
                local goPos = Vector(xPos, d.CurrentYPos)
                npc.Velocity = mod:Lerp(npc.Velocity, (goPos-npc.Position)*0.1, 0.3)
            else
                if d.DelugeFade then
                    d.DelugeFade = math.min(1, d.DelugeFade+0.25)
                    npc.Color = Color(npc.Color.R, npc.Color.G, npc.Color.B, d.DelugeFade, npc.Color.RO, npc.Color.GO, npc.Color.BO)
                    if d.DelugeFade == 1 then
                        d.DelugeFade = nil
                    end
                end

                local pos = room:FindFreeTilePosition(room:GetCenterPos(), 999)
                if mod:superExists(d.DelugeBody) then
                    pos = d.DelugeBody.Position
                end
                if (npc.Position+npc.Velocity:Resized(40)):Distance(pos) < 70 then
                    d.SubState = "End"
                    d.FullyFadedOut = nil
                    d.BeginReturn = nil
                    if d.DelugeFade then
                        npc.Color = Color(npc.Color.R, npc.Color.G, npc.Color.B, 1, npc.Color.RO, npc.Color.GO, npc.Color.BO)
                        d.DelugeFade = nil
                    end
                else
                    npc.Velocity = mod:Lerp(npc.Velocity, Vector(bal.CSpeed*d.ChargeDir, (pos.Y-npc.Position.Y)*0.1), 0.3)
                end
            end

            mod:spritePlay(sprite, "HorseChargeIdle")
        elseif d.SubState == "End" then
            if sprite:IsFinished("HorseChargeEnd") then
                d.SubState = "EndWaiting"
                d.Braking = nil
            elseif sprite:IsEventTriggered("Shoot") then
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS
                d.Braking = true
                npc:PlaySound(mod.Sounds.BusterGhostSkid2, 1, 0, false, 1)

                local follow = function(n, tab)
                    if mod:superExists(npc) then
                        local vel = (npc.Position-n.Position)
                        if npc.Position:Distance(n.Position) > 15 then
                            vel = vel:Resized(3)
                        end
                        n.Velocity = vel
                        if tab.height < -20 then
                            tab.Activated = true
                        end

                        if tab.height > -15 and tab.Activated then
                            npc:PlaySound(SoundEffect.SOUND_FORESTBOSS_STOMPS, 0.6, 0, false, 1.6)
                            npc:PlaySound(mod.Sounds.DelugeLand, 1.5, 0, false, mod:RandomInt(90,105,rng)/100)
                            mod:GetEntityData(npc).State = "HorseLanded"
                            n:Remove()
                        end
                    else
                        n:Remove()
                    end
                end

                local spawnPos
                if mod:superExists(d.DelugeBody) then
                    local vel = (npc.Position-d.DelugeBody.Position)*0.025
                    d.DelugeBody:GetSprite():Play("YankedUp", true)
                    d.DelugeBody:GetSprite().FlipX = vel.X < 0
                    --d.DelugeBody.Visible = true
                    d.DelugeBody.Color = Color(1, 1, 1, 1, 0, 0, 0)
                    mod:GetEntityData(d.DelugeBody).launchedEnemyInfo = {zVel = bal.CGrav2, height = -3, pos = true, extraFunc = follow}
                    mod:GetEntityData(d.DelugeBody).SubmergedBody = nil
                    spawnPos = d.DelugeBody.Position
                else
                    local pos = room:FindFreeTilePosition(room:GetCenterPos(), 999)
                    local vel = (npc.Position-pos)*0.025
                    local body = Isaac.Spawn(mod.FF.DelugeHelper.ID, mod.FF.DelugeHelper.Var, 0, pos, vel, npc):ToNPC()
                    body.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                    body.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
                    body.Parent = npc
                    mod:GetEntityData(body).PanicSpawned = true
                    body:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                    body:GetSprite():Play("YankedUp", true)
                    body:GetSprite().FlipX = vel.X < 0
                    mod:GetEntityData(body).launchedEnemyInfo = {zVel = bal.CGrav2, height = -3, pos = true, extraFunc = follow}
                    spawnPos = pos
                end

                npc:PlaySound(SoundEffect.SOUND_BOSS2_DIVE, 1, 0, false, 1)
                local splash = Isaac.Spawn(1000, EffectVariant.BIG_SPLASH, 0, spawnPos, Vector.Zero, npc):ToEffect()
                local params = ProjectileParams()
                params.Variant = 4
                for i=1,4 do
                    npc:FireProjectiles(npc.Position, Vector(bal.CReleaseSpeed,0):Rotated(i*90+45), 0, params)
                end

                if mod:superExists(d.BodyDummy) then
                    d.BodyDummy:Remove()
                end
                d.BodyDummy = nil
                if mod:superExists(d.FishingLine) then
                    d.FishingLine:Remove()
                end
                d.FishingLine = nil
                if mod:superExists(d.LineDummy) then
                    d.LineDummy:Remove()
                end
                d.LineDummy = nil
            else
                mod:spritePlay(sprite, "HorseChargeEnd")
            end

            if d.Braking then
                npc.Velocity = npc.Velocity*0.8
            else
                npc.Velocity = mod:Lerp(npc.Velocity, Vector(bal.CSpeed*d.ChargeDir*0.8, 0), 0.3)
            end
        elseif d.SubState == "EndWaiting" then
            mod:spritePlay(sprite, "HorseIdle")
            npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.3)
        end
    elseif d.State == "HorseLanded" then
        if sprite:IsFinished("LandOnHorse") then
            d.State = "Idle"
            d.MoveDest = nil
            table.remove(d.DelugeAttackQueue, 1)
            if #d.DelugeAttackQueue == 0 then
                d.DelugeAttackQueue = GetDelugeAttack(d, rng, phase1Attacks)
            end
            npc.StateFrame = bal.ChargeTime[4]
            d.ExtraFrames = 0
        else
            mod:spritePlay(sprite, "LandOnHorse")
        end

        npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.3)
    elseif d.State == "Twirl" then
        if d.SubState == "Begin" then
            if sprite:IsFinished("TwirlStart") then
                d.SubState = "Idle"
            elseif sprite:IsEventTriggered("Shoot") then
                d.TwirlMovement = true
                d.TwirlDirection = ((d.TwirlDest-npc.Position).X > 0 and 1) or -1
                d.TwirlVec = (d.TwirlDest-npc.Position):Resized(bal.TSpeed)
                npc.StateFrame = 0
                d.BubbleAngle = (d.TwirlDest-npc.Position):GetAngleDegrees()+90
                d.BubbleCount = 0

                npc:PlaySound(SoundEffect.SOUND_ULTRA_GREED_SPINNING, 0.6, 0, true, 0.9)
            elseif sprite:IsEventTriggered("Sound") then
                npc:PlaySound(mod.Sounds.DelugeSpinWarn, 1.5, 0, false, mod:RandomInt(95,105,rng)/100)
            else
                mod:spritePlay(sprite, "TwirlStart")
            end

            if d.TwirlMovement then
                npc.Velocity = mod:Lerp(npc.Velocity, (d.TwirlDest-npc.Position):Resized(bal.TSpeed), 0.3)
            else
                npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.3)
            end
        elseif d.SubState == "Idle" then
            if npc.Position:Distance(d.TwirlDest) < 50 then
                d.SubState = "End"
                d.CurrentTwirlSpeed = bal.TSpeed
            end
            mod:spritePlay(sprite, "TwirlIdle")

            npc.Velocity = mod:Lerp(npc.Velocity, (d.TwirlDest-npc.Position):Resized(bal.TSpeed), 0.3)
        elseif d.SubState == "End" then
            if sprite:IsFinished("TwirlEnd") then
                d.State = "Idle"
                d.MoveDest = nil
                table.remove(d.DelugeAttackQueue, 1)
                if #d.DelugeAttackQueue == 0 then
                    d.DelugeAttackQueue = GetDelugeAttack(d, rng, phase1Attacks)
                end
                npc.StateFrame = bal.TwirlTime[4]
                d.TwirlParticleAng = nil
                d.ExtraFrames = 0
            elseif sprite:IsEventTriggered("Sound") then
                d.TwirlMovement = nil
                npc:PlaySound(mod.Sounds.DelugeSpinEnd, 1.5, 0, false, mod:RandomInt(95,110,rng)/100)
                sfx:Stop(SoundEffect.SOUND_ULTRA_GREED_SPINNING)
            else
                mod:spritePlay(sprite, "TwirlEnd")
            end

            if d.TwirlMovement then
                npc.Velocity = mod:Lerp(npc.Velocity, d.TwirlVec:Resized(d.CurrentTwirlSpeed), 0.3)
                d.CurrentTwirlSpeed = math.max(0, d.CurrentTwirlSpeed-bal.TDecay)
            else
                npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.3)
            end
        end

        if d.TwirlMovement and npc.StateFrame % 5 == 0 then
            d.TwirlParticleAng = d.TwirlParticleAng or 0
            d.TwirlParticleAng = d.TwirlParticleAng + 20*d.TwirlDirection
            for i=1,2 do
                local vel = Vector(mod:RandomInt(30,65,rng)/10, 0):Rotated(d.TwirlParticleAng+mod:RandomInt(-20,20,rng))
                local drop = Isaac.Spawn(1000, EffectVariant.WATER_SPLASH, 1, npc.Position, vel, npc):ToEffect()
                drop.FallingSpeed = -mod:RandomInt(60,120,rng)/10
                drop.m_Height = -15
            end
        end

        if d.TwirlMovement and npc.StateFrame % bal.TFreq == 0 and not mod:isFriend(npc) then
            local dir = Vector(bal.TBubbleSpeed, 0):Rotated(d.BubbleAngle)
            local sub = 2
            if d.BubbleCount % bal.TFlood == 1 then
                sub = 7
            elseif d.BubbleCount % bal.TFlood == 0 then
                sub = 11
            end
            local bubble = Isaac.Spawn(mod.FF.Bubble.ID, mod.FF.Bubble.Var, sub, npc.Position+dir:Resized(5), dir, npc)
            bubble:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            bubble.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			local bd = mod:GetEntityData(bubble)
            bd.TwirlBubble = npc.InitSeed
            if d.BubbleCount % bal.TFlood == 0 then
                bd.FloodedBubble = true
                --bubble.Color = floodedColor
            elseif d.BubbleCount % bal.TFlood == 0 then
                bd.DelugeBuffed = true
            end
            mod.scheduleForUpdate(function()
                bubble.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            end, 3)
            mod.scheduleForUpdate(function()
                bd.TwirlBubble = nil
            end, 10)
            d.BubbleCount = d.BubbleCount+1
            d.BubbleAngle = d.BubbleAngle + d.TwirlDirection*bal.TAngleInc
        end
    elseif d.State == "ChangingPhases" then
        if sprite:IsFinished("FallOff") then
            local mVel = Vector(1, 0):Rotated(rng:RandomInt(360))
            d.State = "FallingOff"
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS
            sprite:Play("FallingBack", true)
            sprite.FlipX = mVel.X > 0
            d.launchedEnemyInfo = {zVel = bal.CGrav, height = -20, pos = true,landFunc = function(n)
                if room:GetGridCollisionAtPos(n.Position) == GridCollisionClass.COLLISION_SOLID and room:GetGridEntityFromPos(n.Position) then
                    room:GetGridEntityFromPos(n.Position):Destroy()
                end
				n:PlaySound(SoundEffect.SOUND_BOSS2_DIVE, 1, 0, false, 1)
                local rangle = rng:RandomInt(360)
                local params = ProjectileParams()
                params.Variant = 4
                params.FallingSpeedModifier = bal.CSplatGrav[1]
                params.FallingAccelModifier = bal.CSplatGrav[2]
				for i=1,bal.CSplatNum do
                    npc:FireProjectilesEx(n.Position, Vector(bal.CSplatSpeed, 0):Rotated(rangle+i*360/bal.CSplatNum), 0, params)
				end
                rangle = rng:RandomInt(360)
                mod.scheduleForUpdate(function()
                    if not mod:isFriend(npc) then
                        for i=1,bal.CBubbles do
                            local dir = Vector(bal.CBubbleSpeed, 0):Rotated(rangle+i*360/bal.CBubbles)
                            local sub = 11
                            if i % 2 == 0 then
                                sub = 7
                            end
                            local bubble = Isaac.Spawn(mod.FF.Bubble.ID, mod.FF.Bubble.Var, sub, n.Position+dir:Resized(5), dir, npc)
                            bubble:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                            bubble.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
                            if i % 2 == 1 then
                                mod:GetEntityData(bubble).FloodedBubble = true
                                --bubble.Color = floodedColor
                            else
                                mod:GetEntityData(bubble).DelugeBuffed = true
                            end
                            mod.scheduleForUpdate(function()
                                bubble.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                            end, 6)
                        end
                    end
                end, 1)
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                d.State = "BodyIdle"
                d.SquishAnim = 1
                d.OpenForGreg = 20
                sprite.FlipX = false
                d.DelugePhaseChange = true
                d.DelugeDamageNegation = nil
                d.DelugeDamageResist = nil
                d.NextGregAttack = rng:RandomInt(2)
                local splash = Isaac.Spawn(1000, EffectVariant.BIG_SPLASH, 0, n.Position, Vector.Zero, n)
                npc.Velocity = npc.Velocity*0.3
			end}

            local spot = FindDelugeBodySpot(npc, rng, 1, bal.PHorseRange)
            local vel = (spot-npc.Position)*0.025
            local horse = Isaac.Spawn(mod.FF.DelugeHelper.ID, mod.FF.DelugeHelper.Var, 1, npc.Position, vel, npc):ToNPC()
            horse.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            horse.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS
            horse:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            horse:GetSprite():Play("HorseDieStart", true)
            horse:GetSprite().FlipX = vel.X > 0
            mod:GetEntityData(horse).State = "Idle"
            horse:SetShadowSize(0.15)
            horse.Parent = npc
            mod:GetEntityData(horse).launchedEnemyInfo = {zVel = bal.PGrav, height = -4, pos = true,landFunc = function(n)
                mod:GetEntityData(n).State = "DeathAnim"
            end,}
            horse:Update()
        elseif sprite:IsEventTriggered("Sound") then
            npc:PlaySound(mod.Sounds.DelugeShot, 1.5, 0, false, mod:RandomInt(90,105,rng)/100)
        else
            mod:spritePlay(sprite, "FallOff")
        end

        npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.3)
    elseif d.State == "FallingOff" then
        mod:spritePlay(sprite, "FallingBack")
    elseif d.State == "BodyIdle" then
        if d.SquishAnim then
            if npc.Velocity:Length() > bal.GSpriteSpeed then
                local dir = numToDir[math.ceil(((mod:GetAngleDegreesButGood(npc.Velocity)+22.5)%360)/45)]
                d.DelugeOverlaySprite:SetFrame("BodyLand" .. dir, d.SquishAnim)
                sprite:SetFrame("BodyLand" .. dir, d.SquishAnim)
                d.LastDelugeDir = dir
            else
                d.DelugeOverlaySprite:SetFrame("BodyLand" .. d.LastDelugeDir, d.SquishAnim)
                sprite:SetFrame("BodyLand" .. d.LastDelugeDir, d.SquishAnim)
            end
            d.SquishAnim = d.SquishAnim+1
            if d.SquishAnim >= 6 then
                d.SquishAnim = nil
            end
        else
            if npc.Velocity:Length() > bal.GSpriteSpeed then
                local dir = numToDir[math.ceil(((mod:GetAngleDegreesButGood(npc.Velocity)+22.5)%360)/45)]
                mod:spritePlay(d.DelugeOverlaySprite, "BodyIdle" .. dir)
                mod:spritePlay(sprite, "BodyIdle" .. dir)
                d.LastDelugeDir = dir
            else
                mod:spritePlay(d.DelugeOverlaySprite, "BodyIdle" .. d.LastDelugeDir)
                mod:spritePlay(sprite, "BodyIdle" .. d.LastDelugeDir)
            end
        end

        if not d.GregOverride then
            if mod:isScare(npc) then
                npc.Velocity = mod:Lerp(npc.Velocity, (targetPos-npc.Position):Resized(bal.Speed2), 0.1)
            else
                if not d.MoveDest then
                    d.MoveFrames = 0
                    d.MoveDest = mod:FindRandomValidPathPosition(npc, 3, 60, bal.MRange)
                    d.MoveNums = 0
                end

                d.MoveFrames = d.MoveFrames+1

                if npc.Position:Distance(d.MoveDest) < 20 or d.MoveFrames > bal.MMax then
                    d.MoveNums = (d.MoveNums or 0)+1
                    if rng:RandomInt(bal.MRestChance) == 0 then
                        d.MoveRest = mod:RandomInt(bal.MRest[1], bal.MRest[2], rng)
                    elseif d.MoveNums > bal.MFNum then
                        d.MoveNums = 0
                        d.MoveFrames = 0
                        d.MoveDest = mod:FindClosestValidPosition(npc, target, 60, bal.MRange, 0)
                    else
                        d.MoveFrames = 0
                        d.MoveDest = mod:FindRandomValidPathPosition(npc, 3, 60, bal.MRange)
                    end
                else
                    if room:CheckLine(npc.Position, d.MoveDest, 3, 1, false, false) then
                        local targetvel = (d.MoveDest - npc.Position):Resized(bal.Speed3)
                        npc.Velocity = mod:Lerp(npc.Velocity, targetvel, bal.GSlippy)
                    elseif npc.Pathfinder:HasPathToPos(d.MoveDest) then
                        npc.Pathfinder:FindGridPath(d.MoveDest, (bal.Speed3*0.66)/6.5, 900, true)
                    else
                        npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, bal.GSlippy)
                    end
                end
            end
        end
        d.DelugeOverlaySprite:Update()

        if npc.Velocity:Length() > 4 and npc.StateFrame % 6 == 0 then
            local ripple = Isaac.Spawn(1000, EffectVariant.WATER_RIPPLE, bal.DontDeleteRipple, npc.Position, Vector.Zero, npc):ToEffect()
            ripple.SpriteScale = Vector(1.5, 1.5)
            ripple.DepthOffset = -30
        end

        if d.OpenForGreg then
            if d.OpenForGreg > 0 then
                d.OpenForGreg = d.OpenForGreg-1
            else
                d.OpenForGreg = nil
                d.DelugeGreg = true
            end
        end
    end

    if not d.DelugePhaseChange then
        if npc.HitPoints < bal.PThreshhold[2]*npc.MaxHitPoints then
            d.DelugeDamageNegation = true
            d.PreparedForPhaseChange = true
        elseif npc.HitPoints < bal.PThreshhold[1]*npc.MaxHitPoints then
            d.DelugeDamageResist = true
            d.PreparedForPhaseChange = true
        end
    end

    if mod:superExists(d.LineDummy) then
        local neg = (sprite.FlipX and -1) or 1
        local over = sprite:GetNullFrame("GregPos")
        if over and over:GetPos() then
            d.LineDummy.ParentOffset = Vector(over:GetPos().X*neg-20*neg, over:GetPos().Y+18)
        end
    end

    if d.DelugeGreg then
        if not d.GregState then
            d.GregState = "Appear"
            npc.StateFrame = 0
            d.Phase2BossBarIcon = true
        end

        local gs = d.DelugeGregSprite
        if d.GregState == "Idle" then
            local str = (d.NextGregAttack == 0 and "Laser") or "Swim"
            --str = "Swim"
            local tab = bal[str .. "Time"]
            local active
            if npc.StateFrame > tab[2] then
                active = true
            elseif npc.StateFrame > tab[1] and rng:RandomInt(tab[3]) == 0 then
                active = true
            end

            if active then
                if str == "Laser" then
                    d.SubState = "Begin"
                elseif str == "Swim" then
                    d.SubState = "HopOut"
                end
                d.GregOverride = true
                d.GregState = str
            end
            mod:spritePlay(gs, "Idle")
        elseif d.GregState == "Laser" then
            if d.SubState == "Begin" then
                if gs:IsFinished("BrimChargeStart") then
                    d.SubState = "ChargeIdle"
                    npc.StateFrame = 0
                elseif gs:IsEventTriggered("Sound") then
                    npc:PlaySound(SoundEffect.SOUND_VAMP_GULP, 1, 0, false, 1.5)
                else
                    mod:spritePlay(gs, "BrimChargeStart")
                end

                npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.25)
            elseif d.SubState == "ChargeIdle" then
                if npc.StateFrame > bal.LCharge then
                    d.SubState = "ChargeEnd"
                end

                mod:spritePlay(gs, "BrimChargeIdle")
                npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.25)
            elseif d.SubState == "ChargeEnd" then
                if gs:IsFinished("BrimChargeEnd") then
                    d.GregLaserTarget = mod:FindNearestCorner(npc)
                    d.SubState = "Start"
                    local dir = numToDir[math.ceil(((mod:GetAngleDegreesButGood(d.GregLaserTarget-npc.Position)+22.5)%360)/45)]
                    d.CurrentLaserDirection = dir
                    mod:spritePlay(gs, "BrimStart" .. dir)
                    local over = sprite:GetNullFrame("GregPos")
                    local pos = npc.Position+over:GetPos()

                    d.GregLaser = EntityLaser.ShootAngle(LaserVariant.THICK_RED, pos, (d.GregLaserTarget-pos):GetAngleDegrees(), 999, Vector(0, bal.GMouthOffset), npc)
                    d.GregLaser:SetScale(bal.LScale)
                    d.GregLaser.DepthOffset = 20
                    d.GregLaser.Color = Color(0, 1, 2, 1, 0.25, 0.35, 0.65)
                    d.GregLaser.IsActiveRotating = true
                    d.GregLaser.RotationSpd = 0
                else
                    mod:spritePlay(gs, "BrimChargeEnd")
                end

                npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.25)
            elseif d.SubState == "Start" then
                local tVel = (target.Position-npc.Position)
                local difference = mod:GetAngleDifferenceDead(d.GregLaser.AngleDegrees, tVel)
                local neg = 1
                if math.abs(difference) < bal.LFollowPlayer then
                    if difference > 0 then
                        neg = -1
                    end
                else
                    if difference <= 0 then
                        neg = -1
                    end
                end
                d.GregLaser:SetTimeout(4)
                local ang = mod:Lerp(d.GregLaser.RotationSpd, bal.LRotate*neg, 0.1)
                d.GregLaser.RotationDegrees = ang
                d.GregLaser.IsActiveRotating = true
                d.GregLaser.RotationSpd = ang

                local realAng = d.GregLaser.AngleDegrees
                if realAng < 0 then
                    realAng = realAng+360
                end
                local dir = numToDir[math.ceil(((realAng+22.5)%360)/45)]
                if dir ~= d.CurrentLaserDirection then
                    gs:SetAnimation("BrimStart" .. dir, false)
                else
                    mod:spritePlay(gs, "BrimStart" .. dir)
                end
                d.CurrentLaserDirection = dir

                if d.GregLaser.AngleDegrees % 360 <= 345 and d.GregLaser.AngleDegrees % 360 > 195 then
                    d.GregLaser.DepthOffset = -40
                else
                    d.GregLaser.DepthOffset = 40
                end

                local over = sprite:GetNullFrame("GregPos")
                d.GregLaser.ParentOffset = over:GetPos()*1.5+(extraOffset[dir] or Vector.Zero)

                if gs:IsFinished("BrimStart" .. dir) then
                    d.SubState = "Idle"
                    npc.StateFrame = 0
                    d.CurrentLaserDirection = nil
                end

                if npc.StateFrame % bal.LSplash == 0 then
                    local params = ProjectileParams()
                    params.Variant = 4
                    params.FallingAccelModifier = bal.LAccel
                    params.FallingSpeedModifier = -mod:RandomInt(bal.LFall[1], bal.LFall[2], rng)/10
                    params.Scale = mod:RandomInt(bal.LScale2[1], bal.LScale2[2], rng)/100
                    params.BulletFlags = params.BulletFlags | ProjectileFlags.NO_WALL_COLLIDE
                    local speed = mod:RandomInt(bal.LSpeed[1], bal.LSpeed[2], rng)/10
                    local vel = Vector(speed, 0):Rotated(realAng+180+mod:RandomInt(-bal.LAngle, bal.LAngle, rng))
                    local proj = npc:FireProjectilesEx(d.GregLaser:GetEndPoint(), vel, 0, params)[1]
                    mod.scheduleForUpdate(function()
                        if proj and proj:Exists() then
                            proj:ClearProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
                        end
                    end, 5)
                end

                local vel = Vector(bal.LMove*0.5, 0):Rotated(realAng+180)
                npc.Velocity = mod:Lerp(npc.Velocity, vel, bal.LLerp)
            elseif d.SubState == "Idle" then
                local tVel = (target.Position-npc.Position)
                local difference = mod:GetAngleDifferenceDead(d.GregLaser.AngleDegrees, tVel)
                local neg = 1
                if math.abs(difference) < bal.LFollowPlayer then
                    if difference > 0 then
                        neg = -1
                    end
                else
                    if difference <= 0 then
                        neg = -1
                    end
                end
                d.GregLaser:SetTimeout(4)
                local ang = mod:Lerp(d.GregLaser.RotationSpd, bal.LRotate*neg, 0.1)
                d.GregLaser.RotationDegrees = ang
                d.GregLaser.IsActiveRotating = true
                d.GregLaser.RotationSpd = ang

                local realAng = d.GregLaser.AngleDegrees
                if realAng < 0 then
                    realAng = realAng+360
                end

                if d.GregLaser.AngleDegrees % 360 <= 345 and d.GregLaser.AngleDegrees % 360 > 195 then
                    d.GregLaser.DepthOffset = -40
                else
                    d.GregLaser.DepthOffset = 40
                end


                local dir = numToDir[math.ceil(((realAng+22.5)%360)/45)]
                mod:spritePlay(gs, "Brim" .. dir)

                local over = sprite:GetNullFrame("GregPos")
                d.GregLaser.ParentOffset = over:GetPos()*1.5+(extraOffset[dir] or Vector.Zero)

                if npc.StateFrame % bal.LSplash == 0 then
                    local params = ProjectileParams()
                    params.Variant = 4
                    params.FallingAccelModifier = bal.LAccel
                    params.FallingSpeedModifier = -mod:RandomInt(bal.LFall[1], bal.LFall[2], rng)/10
                    params.Scale = mod:RandomInt(bal.LScale2[1], bal.LScale2[2], rng)/100
                    params.BulletFlags = params.BulletFlags | ProjectileFlags.NO_WALL_COLLIDE
                    local speed = mod:RandomInt(bal.LSpeed[1], bal.LSpeed[2], rng)/10
                    local vel = Vector(speed, 0):Rotated(realAng+180+mod:RandomInt(-bal.LAngle, bal.LAngle, rng))
                    local proj = npc:FireProjectilesEx(d.GregLaser:GetEndPoint(), vel, 0, params)[1]
                    mod.scheduleForUpdate(function()
                        if proj and proj:Exists() then
                            proj:ClearProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
                        end
                    end, 5)
                end

                local vel = Vector(bal.LMove, 0):Rotated(realAng+180)
                npc.Velocity = mod:Lerp(npc.Velocity, vel, bal.LLerp)

                if npc:CollidesWithGrid() and npc.StateFrame > 25 then
                    d.SquishAnim = 1
                    d.SubState = "End"
                    npc:PlaySound(SoundEffect.SOUND_MEAT_JUMPS, 1, 0, false, 1)
                    mod.scheduleForUpdate(function()
                        npc.Velocity = npc.Velocity*2
                    end, 1)

                    local poof = Isaac.Spawn(1000, EffectVariant.POOF02, 0, npc.Position, Vector.Zero, npc):ToEffect()
                    poof:FollowParent(npc)
                    poof.SpriteOffset = Vector(0,-7)
                    poof.DepthOffset = 10
                    poof.SpriteScale = Vector(0.8, 1)
                    poof.Color = Color(0.2, 1, 1, 0.3, 0.6, 0.8, 1)
                    poof:Update()
                    local vec = npc.Velocity:Rotated(180)
                    for i=1,bal.LImpactBubbles do
                        local realVec = vec:Rotated(mod:RandomInt(-bal.LImpactAngle, bal.LImpactAngle, rng)):Resized(mod:RandomInt(-bal.LImpactSpeed[1], bal.LImpactSpeed[2], rng)/10)
                        local bubble = Isaac.Spawn(mod.FF.Bubble.ID, mod.FF.Bubble.Var, 7, npc.Position+realVec:Resized(5), realVec, npc):ToNPC()
                        bubble:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                        bubble.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
                        local bd = mod:GetEntityData(bubble)
						bd.DelugeDontKillYet = true
                        bd.DelugeBuffed = true
                        mod.scheduleForUpdate(function()
                            bubble.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                        end, 3)
                    end
                end
            elseif d.SubState == "End" then
                if gs:IsFinished("BrimEnd") then
                    d.GregState = "Shoot"
                    d.SubState = "HoldIt"
                    d.GregShootDelay = bal.LShootDelay
                    d.GregTripleAngle = bal.GShotAngle[2]
                    d.GregShootMode = "Laser"
                    npc.StateFrame = 0
                else
                    mod:spritePlay(gs, "BrimEnd")
                end

                npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, bal.GSlippy)
            end
        elseif d.GregState == "Swim" then
            if d.SubState == "HopOut" then
                if gs:IsFinished("HopOut") then
                    d.TempGregSwimSpot = CheckSwimPos(npc, npc:GetPlayerTarget())
                    local pos = npc.Position-d.TempGregSwimSpot[2]:Resized(bal.SDist)
                    if room:GetGridCollisionAtPos(pos) >= GridCollisionClass.COLLISION_OBJECT then
                        local num = 1
                        pos = npc.Position-d.TempGregSwimSpot[2]:Resized(bal.SDist-num*5)
                        while room:GetGridCollisionAtPos(pos) >= GridCollisionClass.COLLISION_OBJECT and num < bal.SDist/5 do
                            num = num+1
                            pos = npc.Position-d.TempGregSwimSpot[2]:Resized(bal.SDist-math.min(bal.SDist, num*5))
                        end
                    end
                    local over = sprite:GetNullFrame("GregPos")
                    local myPos = npc.Position+over:GetPos()
                    d.GregLaunchedEnemyInfo = {zVel = bal.SGrav, height = -5, target = pos, myPos = myPos, vel = (pos-myPos)*0.025, landFunc = function(n, tab)
                        d.GregLanded = true
                        npc.StateFrame = 0
                        npc:PlaySound(SoundEffect.SOUND_BOSS2_DIVE, 0.4, 0, false, 2)
                        local splash = Isaac.Spawn(1000, EffectVariant.BIG_SPLASH, 0, tab.myPos, Vector.Zero, n):ToEffect()
                        splash.SpriteScale = Vector(0.3, 0.3)

                        for i=1,6 do
                            local vel = Vector(mod:RandomInt(10,40,rng)/10, 0):Rotated(rng:RandomInt(360))
                            local drop = Isaac.Spawn(1000, EffectVariant.WATER_SPLASH, 1, tab.myPos, vel, npc):ToEffect()
                            drop.FallingSpeed = -mod:RandomInt(60,120,rng)/10
                            drop.m_Height = -5
                        end
                    end, extraFunc = function(n, tab)
                        if not tab.divingDownAnim and tab.zVel > -1 then
                            if gs:IsFinished("AirChange") then
                                tab.divingDownAnim = true
                                gs:Play("DownAir", true)
                            else
                                mod:spritePlay(gs, "AirChange")
                            end
                        end
                    end,}
                    gs:Play("UpAir", true)
                    d.SubState = "Prepare"
                else
                    mod:spritePlay(gs, "HopOut")
                end
                npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.2)
            elseif d.SubState == "Prepare" then
                if d.GregLanded then
                    if npc.StateFrame > 20 then
                        --d.GregSwim = CheckSwimPos(npc, npc:GetPlayerTarget())
                        d.GregSwim = d.TempGregSwimSpot
                        d.TempGregSwimSpot = nil
                        d.GregLanded = nil
                        gs:Play("Surface" .. d.GregSwim[3], true)
                    end
                elseif d.GregSwim then
                    if gs:IsFinished("Surface" .. d.GregSwim[3]) then
                        d.SubState = "Swimming"
                        npc.StateFrame = 0
                    else
                        mod:spritePlay(gs, "Surface" .. d.GregSwim[3])
                    end
                end
                npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.2)
            elseif d.SubState == "Swimming" then
                if not d.SecondSwim and not (npc:CollidesWithGrid() and npc.StateFrame > 50) then
                    local passedBy
                    if npc.StateFrame > 10 then
                        if d.GregSwim[3] == "L" or d.GregSwim[3] == "R" then
                            if math.abs(target.Position.X-npc.Position.X) < 40 and math.abs(target.Position.Y-npc.Position.Y) > 40 then
                                passedBy = true
                            end
                        else
                            if math.abs(target.Position.Y-npc.Position.Y) < 40 and math.abs(target.Position.X-npc.Position.X) > 40 then
                                passedBy = true
                            end
                        end
                    end
                    local checkAhead = room:GetGridCollisionAtPos(npc.Position+d.GregSwim[2]:Resized(20)) >= GridCollisionClass.COLLISION_OBJECT
                    if checkAhead or passedBy then
                        local result = CheckSwimPos(npc, npc:GetPlayerTarget(), d.GregSwim[3])
                        if result then
                            d.SubState = "Relocate"
                            d.NewGregSwim = result
                        end
                    end
                else
                    if npc:CollidesWithGrid() or npc.StateFrame > 100 then
                        --d.GregSwim = nil
                        d.NewGregSwim = nil
                        d.GregLanded = nil
                        d.SecondSwim = nil
                        d.SubState = "Ending"
                    end
                end
                npc.Velocity = mod:Lerp(npc.Velocity, d.GregSwim[2]:Resized(bal.SSpeed), bal.SSlippy)

                local pos = npc.Position-d.GregSwim[2]:Resized(bal.SDist)
                if room:GetGridCollisionAtPos(pos) >= GridCollisionClass.COLLISION_OBJECT then
                    local num = 1
                    pos = npc.Position-d.GregSwim[2]:Resized(bal.SDist-num*5)
                    while room:GetGridCollisionAtPos(pos) >= GridCollisionClass.COLLISION_OBJECT and num < bal.SDist/5 do
                        num = num+1
                        pos = npc.Position-d.GregSwim[2]:Resized(bal.SDist-math.min(bal.SDist, num*5))
                    end
                end

                if npc.StateFrame % bal.SFreq == 0 then
                    d.FloodBubbleCount = d.FloodBubbleCount or 0

                    local sub = 2
                    if d.FloodBubbleCount % bal.SFlood == 2 then
                        sub = 7
                    elseif d.FloodBubbleCount % bal.SFlood == 0 then
                        sub = 11
                    end

                    local dir = npc.Velocity:Rotated(180+mod:RandomInt(-bal.SAngle, bal.SAngle, rng))
                    local bubble = Isaac.Spawn(mod.FF.Bubble.ID, mod.FF.Bubble.Var, sub, pos, dir, npc)
                    bubble:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                    if d.FloodBubbleCount % bal.SFlood == 0 then
                        mod:GetEntityData(bubble).FloodedBubble = true
                        --bubble.Color = floodedColor
                    elseif sub == 7 then
                        mod:GetEntityData(bubble).DelugeBuffed = true
                    end
                    bubble.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
                    mod.scheduleForUpdate(function()
                        bubble.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                    end, 3)
                    bubble.SpriteOffset = Vector(0, 10)

                    d.FloodBubbleCount = d.FloodBubbleCount+1
                end

                if npc.StateFrame % 3 == 0 then
                    Isaac.Spawn(1000, EffectVariant.TEAR_POOF_A, 10, pos, Vector.Zero, npc)
                end

                if npc.StateFrame % 7 == 0 then
                    npc:PlaySound(SoundEffect.SOUND_MEAT_IMPACTS, 0.4, 0, false, mod:RandomInt(160,190,rng)/100)
                    local ripple = Isaac.Spawn(1000, EffectVariant.WATER_RIPPLE, 0, pos, Vector.Zero, npc):ToEffect()
                    ripple.SpriteScale = Vector(0.5, 0.5)
                end

                mod:spritePlay(gs, "Swim" .. d.GregSwim[3])
            elseif d.SubState == "Relocate" then
                if d.NewGregSwim then
                    if gs:IsFinished("Sink" .. d.GregSwim[3]) then
                        d.GregSwim = d.NewGregSwim
                        gs:Play("Surface" .. d.GregSwim[3], true)
                        d.NewGregSwim = nil
                    else
                        mod:spritePlay(gs, "Sink" .. d.GregSwim[3])
                    end
                else
                    if gs:IsFinished("Surface" .. d.GregSwim[3]) then
                        d.SubState = "Swimming"
                        d.SecondSwim = true
                        npc.StateFrame = 0
                    else
                        mod:spritePlay(gs, "Surface" .. d.GregSwim[3])
                    end
                end

                npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, bal.GSlippy)
            elseif d.SubState == "Ending" then
                if gs:IsFinished("StopSwim") then
                    d.GregSwim = nil

                    npc.StateFrame = 0
                    d.StopGregRender = true
                    d.SubState = "Waiting"
                else
                    mod:spritePlay(gs, "StopSwim")
                end

                npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.2)
            elseif d.SubState == "Waiting" then
                if npc.StateFrame > 15 then
                    d.GregState = "AppearShoot"
                    d.StopGregRender = nil

                    mod.scheduleForUpdate(function()
                        local over = sprite:GetNullFrame("GregPos")
                        if over then
                            local pos = npc.Position+over:GetPos()*1.5
                            for i=1,6 do
                                local vel = Vector(mod:RandomInt(10,40,rng)/10, 0):Rotated(rng:RandomInt(360))
                                local drop = Isaac.Spawn(1000, EffectVariant.WATER_SPLASH, 1, pos, vel, npc):ToEffect()
                                drop.FallingSpeed = -mod:RandomInt(60,120,rng)/10
                                drop.m_Height = -20
                            end
                        end
                    end, 3)
                end
            end
        elseif d.GregState == "Shoot" then
            gs.FlipX = target.Position.X < npc.Position.X

            if d.SubState == "HoldIt" then
                mod:spritePlay(gs, "HoldShot")

                if npc.StateFrame > d.GregShootDelay then
                    d.SubState = "Shoot"
                end
            elseif d.SubState == "ChargeAnim" then
                if gs:IsFinished("BrimChargeStart") then
                    d.SubState = "HoldIt"
                else
                    mod:spritePlay(gs, "BrimChargeStart")
                end
            elseif d.SubState == "Shoot" then
                if gs:IsFinished("Shoot") then
                    d.GregState = "Idle"
                    npc.StateFrame = 0
                    d.GregOverride = nil
                    d.MoveFrames = 0
                    d.MoveDest = mod:FindRandomValidPathPosition(npc, 3, 60, bal.MRange)
                    d.MoveNums = 0
                    gs.FlipX = false
                    if d.NextGregAttack == 0 then
                        d.NextGregAttack = 1
                    else
                        d.NextGregAttack = 0
                    end
                elseif gs:IsEventTriggered("Shoot") then
                    local over = sprite:GetNullFrame("GregPos")
                    local pos = npc.Position+over:GetPos()*1.5
                    local params = ProjectileParams()
                    params.Variant = 4
                    params.HeightModifier = -10
                    local vel = (target.Position-pos)
                    for i=-1,1 do
                        if d.GregShootMode == "Laser" then
                            if i == 0 then
                                npc:FireProjectiles(pos, vel:Resized(bal.GShotSpeed), 0, params)
                            else
                                local bubble = Isaac.Spawn(mod.FF.Bubble.ID, mod.FF.Bubble.Var, 11, pos+vel:Resized(5), vel:Resized(bal.GBubbleSpeed):Rotated(d.GregTripleAngle*i), npc)
                                bubble:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                                bubble.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
                                mod:GetEntityData(bubble).FloodedBubble = true
                                --bubble.Color = floodedColor
                                mod.scheduleForUpdate(function()
                                    bubble.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                                end, 3)
                            end
                        else
                            if i == 0 then
                                local bubble = Isaac.Spawn(mod.FF.Bubble.ID, mod.FF.Bubble.Var, 11, pos+vel:Resized(5), vel:Resized(bal.GBubbleSpeed), npc)
                                bubble:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                                bubble.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
                                mod:GetEntityData(bubble).FloodedBubble = true
                                --bubble.Color = floodedColor
                                mod.scheduleForUpdate(function()
                                    bubble.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                                end, 3)
                            else
                                npc:FireProjectiles(pos, vel:Resized(bal.GShotSpeed):Rotated(d.GregTripleAngle*i), 0, params)
                            end
                        end
                    end
                    npc.Velocity = (pos-target.Position):Resized(bal.GRecoil)
                    npc:PlaySound(SoundEffect.SOUND_LITTLE_SPIT, 1, 0, false, 1)

                    local poof = Isaac.Spawn(1000, EffectVariant.POOF02, 0, pos, Vector.Zero, npc):ToEffect()
                    poof:FollowParent(npc)
                    poof.SpriteOffset = Vector(0,-7)
                    poof.DepthOffset = 20
                    poof.SpriteScale = Vector(0.5, 0.6)
                    poof.Color = Color(0.2, 1, 1, 0.3, 0.6, 0.8, 1)
                    poof:Update()
                else
                    mod:spritePlay(gs, "Shoot")
                end
            end

            npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, bal.GSlippy)
        elseif d.GregState == "Appear" then
            if gs:IsFinished("Appear") then
                d.GregState = "Idle"
                npc.StateFrame = 0
            elseif gs:IsEventTriggered("Sound") then
                npc:PlaySound(SoundEffect.SOUND_CHILD_ANGRY_ROAR, 1, 0, false, 1)
            else
                mod:spritePlay(gs, "Appear")
            end
        elseif d.GregState == "AppearShoot" then
            if gs:IsFinished("AppearShort") then
                d.GregState = "Shoot"
                d.SubState = "ChargeAnim"
                npc.StateFrame = 0
                d.GregShootDelay = bal.SShootDelay
                d.GregTripleAngle = bal.GShotAngle[1]
                d.GregShootMode = "Swim"
            else
                mod:spritePlay(gs, "AppearShort")
            end

            npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, bal.GSlippy)
        end
        gs:Update()
    end
end

function mod:DelugeRender(npc)
    if mod:IsNormalRender(true) then
        local d = mod:GetEntityData(npc)
        local dying = npc:GetSprite():IsPlaying("Death")
        if dying then
            sfx:Stop(SoundEffect.SOUND_ULTRA_GREED_SPINNING)
            if npc:GetShadowSize() > 0 then
                npc:SetShadowSize(0)
                if mod:superExists(d.BodyDummy) then
                    d.BodyDummy:Remove()
                end
                d.BodyDummy = nil
                if mod:superExists(d.FishingLine) then
                    d.FishingLine:Remove()
                end
                d.FishingLine = nil
                if mod:superExists(d.LineDummy) then
                    d.LineDummy:Remove()
                end
                d.LineDummy = nil
            end

            if d.DelugeGregSprite then
                d.DelugeGregSprite.Color = Color(1, 1, 1, 0)
            end
            if d.DelugeOverlaySprite then
                d.DelugeOverlaySprite.Color = Color(1, 1, 1, 0)
            end
        elseif d.DelugeGreg and not dying then
            local sprite = npc:GetSprite()
            local over = sprite:GetNullFrame("GregPos")

            if over and over:GetPos() then
                if d.StopGregRender then
                elseif d.GregLaunchedEnemyInfo then
                    local tab = d.GregLaunchedEnemyInfo
                    tab.accel = tab.accel or 0.3
					local offset = tab.height+tab.zVel+tab.accel/2
                    if not tab.stopFall then
    					tab.height = offset
					    tab.zVel = tab.zVel + tab.accel
                        tab.myPos = tab.myPos+tab.vel
                    end

                    if tab.extraFunc then
                        tab.extraFunc(npc, tab)
                    end

					if tab.height > 0 then
						d.GregLaunchedEnemyInfo = nil
                        if tab.landFunc then
                            tab.landFunc(npc, tab)
                        end
					end
                    local height = Vector(0, offset)

                    d.DelugeGregSprite:Render(Isaac.WorldToScreen(tab.myPos+height))
                elseif d.GregLanded then
                elseif d.GregSwim then
                    if d.GregSwim[3] ~= "D" then
                        local room = game:GetRoom()
                        local pos = npc.Position-d.GregSwim[2]:Resized(bal.SDist)
                        if room:GetGridCollisionAtPos(pos) >= GridCollisionClass.COLLISION_OBJECT then
                            local num = 1
                            pos = npc.Position-d.GregSwim[2]:Resized(bal.SDist-num*5)
                            while room:GetGridCollisionAtPos(pos) >= GridCollisionClass.COLLISION_OBJECT and num < bal.SDist/5 do
                                num = num+1
                                pos = npc.Position-d.GregSwim[2]:Resized(bal.SDist-math.min(bal.SDist, num*5))
                            end
                        end
                        d.DelugeGregSprite:Render(Isaac.WorldToScreen(pos))
                    end
                else
                    d.DelugeGregSprite:Render(Isaac.WorldToScreen(npc.Position)+over:GetPos())
                end

                if not (d.GregSwim or d.GregLaunchedEnemyInfo or d.GregLanded or d.StopGregRender) then
                    d.DelugeOverlaySprite.Color = npc:GetColor()
                    d.DelugeOverlaySprite:Render(Isaac.WorldToScreen(npc.Position))
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_NPC_RENDER, function(_, npc) --For when Greg is swimming behind Deluge, to stop rendering over
    if mod:IsNormalRender(true) then
        local d = mod:GetEntityData(npc)
        if d.DelugeGreg then
            if d.GregSwim and not (d.GregLaunchedEnemyInfo or d.GregLanded) then
                if d.GregSwim[3] == "D" then
                    local room = game:GetRoom()
                    local pos = npc.Position-d.GregSwim[2]:Resized(bal.SDist)
                    if room:GetGridCollisionAtPos(pos) >= GridCollisionClass.COLLISION_OBJECT then
                        local num = 1
                        pos = npc.Position-d.GregSwim[2]:Resized(bal.SDist-num*5)
                        while room:GetGridCollisionAtPos(pos) >= GridCollisionClass.COLLISION_OBJECT and num < bal.SDist/5 do
                            num = num+1
                            pos = npc.Position-d.GregSwim[2]:Resized(bal.SDist-math.min(bal.SDist, num*5))
                        end
                    end
                    d.DelugeGregSprite:Render(Isaac.WorldToScreen(pos))
                end
            end
        end
    end
end, mod.FF.Deluge.ID)

function mod:DelugeCollision(npc, coll)
    local d = mod:GetEntityData(npc)
    if coll and coll.Type == mod.FF.Bubble.ID and coll.Variant == mod.FF.Bubble.Var then
        if d.State == "ChargeHorse" then
			local bd = mod:GetEntityData(coll)
            if not bd.DelugePop then
                coll:TakeDamage(1, 0, EntityRef(npc), 0)
                bd.DelugePop = true
            end
            return true
        elseif d.State == "Twirl" then
            if d.TwirlMovement then
                if not mod:GetEntityData(coll).TwirlBubble then
                    coll.Velocity = (coll.Position-npc.Position):Resized(bal.TBubbleSpeed*2)
                end
                return true
            end
        elseif d.DelugePhaseChange then
            return true
        end
    end
end

function mod:DelugeHurt(npc, damage, flags, source, cooldown)
    local d = mod:GetEntityData(npc)
    if d.DelugeDamageNegation and flags ~= flags | DamageFlag.DAMAGE_CLONES then
        npc:TakeDamage(math.min(1, damage*bal.PReduction), flags | DamageFlag.DAMAGE_CLONES, source, 0)
        return false
    elseif d.DelugeDamageResist and flags ~= flags | DamageFlag.DAMAGE_CLONES then
        npc:TakeDamage(damage*bal.PReduction, flags | DamageFlag.DAMAGE_CLONES, source, 0)
        return false
    end
end

function mod:DelugeHelperAI(npc)
    if mod:superExists(npc.Parent) then
        local d = mod:GetEntityData(npc)
        if npc.SubType == 1 then --Horse
            local sprite = npc:GetSprite()
            if d.State == "Idle" then
                if sprite:IsFinished("HorseDieStart") then
                    sprite:Play("HorseDieIdle", true)
                end
            elseif d.State == "DeathAnim" then
                if sprite:IsFinished("HorseDie") then
                    npc:Remove()
                else
                    mod:spritePlay(sprite, "HorseDie")
                end
                npc.Velocity = Vector.Zero
            end
        elseif npc.SubType == 0 then --Body
            if d.SubmergedBody then
                npc.StateFrame = npc.StateFrame or 0
                npc.StateFrame = npc.StateFrame+1
                local pd = mod:GetEntityData(npc.Parent)
                if npc.StateFrame % 6 == 0 then
                    local ripple = Isaac.Spawn(1000, EffectVariant.WATER_RIPPLE, 0, npc.Position, Vector.Zero, npc)
                end
                if npc.StateFrame > bal.CBBubbleStart and npc.FrameCount % bal.CBBubbleFreq == 0 and not mod:isFriend(npc.Parent) then
                    local pos = npc.Position+mod:shuntedPosition(bal.CBBubblePosOff, npc:GetDropRNG())
                    local bubble = Isaac.Spawn(mod.FF.Bubble.ID, mod.FF.Bubble.Var, 2, pos, Vector.Zero, npc)
                    bubble:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
					local bd = mod:GetEntityData(bubble)
                    bd.spawning = true
                    bd.DelugeSpawning = true
                    bubble:Update()
                end
                if pd.State == "ChargeHorse" then
                    if npc.FrameCount % 9 == 0 or not d.DelugeXVel then
                        d.DelugeXVel = mod:RandomInt(-bal.CBodySpeed*10, bal.CBodySpeed*10, npc:GetDropRNG())/10
                    end
                    npc.Velocity = mod:Lerp(npc.Velocity, Vector(d.DelugeXVel, mod:ClampNumber((npc.Parent.Position.Y-npc.Position.Y), -bal.CBodySpeed, bal.CBodySpeed)), 0.09)
                end
            end
        end
    else
        npc:Remove()
    end
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, e) --Remove the ripples so that it doesn't look weird while floating or in corpse form
    if not e.SubType == bal.DontDeleteRipple then
        for _,del in ipairs(Isaac.FindByType(mod.FF.Deluge.ID, mod.FF.Deluge.Var, -1, false, false)) do
            if del.Position:Distance(e.Position) < 5 then
                e:Remove()
                break
            end
        end
    end
end, EffectVariant.WATER_RIPPLE)

mod:AddCallback(ModCallbacks.MC_PRE_EFFECT_RENDER, function(_, e) --Remove the ripples so that it doesn't look weird while floating or in corpse form
    if e.FrameCount < 1 then
        for _,del in ipairs(Isaac.FindByType(mod.FF.Deluge.ID, mod.FF.Deluge.Var, -1, false, false)) do
            if del.Position:Distance(e.Position) < 5 then
                e.Visible = false
                e:Remove()
                break
            end
        end
    end
end, EffectVariant.WATER_SPLASH)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, e)
    local d = mod:GetEntityData(e)
    if d.FollowFlipX and e.Parent then
        d.FollowFlipXCurrent = d.FollowFlipXCurrent or e.Parent:GetSprite().FlipX
        if d.FollowFlipXCurrent ~= e.Parent:GetSprite().FlipX then
            e.SpriteOffset = Vector(e.SpriteOffset.X*-1, e.SpriteOffset.Y)
            d.FollowFlipXCurrent = e.Parent:GetSprite().FlipX
        end
    end
end, EffectVariant.POOF02)

mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, npc)
	if npc.Variant == mod.FF.Monsoon.Var and game:GetRoom():GetType() == RoomType.ROOM_BOSSRUSH then
		mod:floodBossRush()
	end
end, mod.FF.Monsoon.ID)

mod:AddCallback(ModCallbacks.MC_POST_GAME_END, function(_, gameOver)
	if gameOver then
		if #Isaac.FindByType(mod.FF.Deluge.ID, mod.FF.Deluge.Var) > 0 then
			sfx:Play(mod.Sounds.DelugeLaugh, 1.3, 0, false, 1)
		end
	end
end)
