local co = coroutine

local FF = FiendFolio
local game = Game()
local sfx = SFXManager()

local FIRST_POSSESSION_TIMER = 30*1
local POSSESSION_TIMER = 30*14

local SPLIT_HP = 0.666  -- HP % to split into two Idolators
local TRANSFORMING_DAMAGE_RESISTANCE = 0.2

local CONFIG = {
    PRIDE = {
        -- Config for old rotating brimstone attack.
        --BrimRotationDelay = 30,
        --BrimRotationTime = 30 * 5,
        --BrimRotationDegrees = 90,
        --ProjFanWidth = 10,
        --ProjSpeed = 15,
        BombSpeed = 17,
        BombFuse = {15, 15, 15},  --Duration of bomb's Idle, Pulse01, and Pulse02 animations before exploding.
        NumClones = 2,
        NumLasers = 2,
        LaserDuration = 30,
    },
    SLOTH = {
        MoveCreepTimeout = 30,
        MoveCreepInterval = 5,
        TriCreepTimeout = 20,
        TriCreepInterval = 1,
        TriCreepSpacing = 15,
        TriCreepAmount = 18,
        ChargeMinDist = 0,
        ChargeMaxDist = 160,
        ChargeVerticalDetectScale = 1.0,
        ChargeSpeed = 18,
        ChargeCreepInterval = 2,
        ChargeIpecacInterval = 4,
    },
    LUST = {
        KissyProjectileSpeed = 10,
        KissySplitProjectileSpeed = 5,
        MaxBouncyProjectileBounces = 5,
    },
    GREED = {
        MinPlayerDistFromWall = 150,
        GreedGapersPerSummon = 4,
        MaxGreedGapers = 5,
        CoinInitialSpeed = 5,
        MaxCoins = 2,
        CoinHP = 30,
    },
    ENVY = {
        MaxHeads = 4,
        HeadSpeed = 6,
        ProjectileSpeed = 10,
    },
    WRATH = {
        CrossExplosionSpacing = 40,
        CrossExplosionRadiusMult = 0.8,
        CrossExplosionInitialDelay = 20,
        CrossExplosionIncrementalDelay = 4,
        MinBombs = 4,
        MaxBombs = 6,
    },
}

local APPEAR_SOUND = {
    [0] = {SoundEffect.SOUND_MEAT_JUMPS, SoundEffect.SOUND_DEATH_REVERSE},
    [FF.FF.IdolatorLust.Sub] = {SoundEffect.SOUND_KISS_LIPS1},
    [FF.FF.IdolatorSloth.Sub] = {SoundEffect.SOUND_MONSTER_GRUNT_2},
    [FF.FF.IdolatorWrath.Sub] = {SoundEffect.SOUND_MONSTER_YELL_A},
    [FF.FF.IdolatorGluttony.Sub] = {SoundEffect.SOUND_MOUTH_FULL, SoundEffect.SOUND_SKIN_PULL},
    [FF.FF.IdolatorPride.Sub] = {SoundEffect.SOUND_BOSS_BUG_HISS},
    [FF.FF.IdolatorGreed.Sub] = {SoundEffect.SOUND_ULTRA_GREED_PULL_SLOT},
    [FF.FF.IdolatorEnvy.Sub] = {SoundEffect.SOUND_INFLATE, SoundEffect.SOUND_SKIN_PULL},
}

local MOVE_SPEED = {
    DEFAULT = 6,
    [FF.FF.IdolatorLust.Sub] = 8,
    [FF.FF.IdolatorGreed.Sub] = 8,  -- (he is pretty fast)
}

function GetMoveSpeed(npc)
    return MOVE_SPEED[npc.SubType] or MOVE_SPEED.DEFAULT
end

local GREED_WALL_HOLES = {}

FF:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    GREED_WALL_HOLES = {}
end)

local function GetGreedHoleInfo(doorSlot)
    local room = game:GetRoom()
    local doorSlotPos = room:GetDoorSlotPosition(doorSlot)

    local direction = 0
    for i = 0, 3 do
        local nextgrid = doorSlotPos + Vector(0, -40):Rotated(i * 90)
        if room:GetGridCollisionAtPos(nextgrid) ~= GridCollisionClass.COLLISION_WALL then
            direction = (i + 2) % 4
            break
        end
    end

    local directionVector = Vector(0, 30):Rotated(direction * 90)

    return doorSlotPos, direction, directionVector
end

local function FindDoorSlotForGreedGapers()
    local room = game:GetRoom()
    local validSlots = {}

    for i = 0, DoorSlot.NUM_DOOR_SLOTS - 1 do
        if not room:GetDoor(i) and room:IsDoorSlotAllowed(i) then
			local doorSlotPos = room:GetDoorSlotPosition(i)

			local closestPlayerDist

			FF.AnyPlayerDo(function(player)
				local dist = player.Position:Distance(doorSlotPos) 
				if not closestPlayerDist or dist < closestPlayerDist then
					closestPlayerDist = dist
				end
			end)

			if closestPlayerDist and closestPlayerDist > CONFIG.GREED.MinPlayerDistFromWall then
				table.insert(validSlots, i)
			end
        end
    end

	if #validSlots > 0 then
		return validSlots[FF:RandomInt(1, #validSlots)]
	end
end

local function MakeDebris(pos, dir, amount)
    pos = pos-dir:Resized(20)
    for i = 1, amount do
        local rockVel = dir:Resized(FF:RandomInt(4,amount)):Rotated(FF:RandomInt(-75,75))
        local rock = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ROCK_PARTICLE, 0, pos, rockVel, nil)
        rock:Update()
        local dustVel = dir:Resized(FF:RandomInt(4,amount/2)):Rotated(FF:RandomInt(-75,75))
        local dust = Isaac.Spawn(EntityType.ENTITY_EFFECT, FF.FF.FFWhiteSmoke.Var, FF.FF.FFWhiteSmoke.Sub, pos, dustVel, nil)
        dust.Color = Color(0.4, 0.4, 0.4, 1)
        FiendFolio:GetEntityData(dust).longonly = true
    end
end

-- Verifies that Idolator and a Sin Ghost still mutally agree that the possession is going to happen.
local function ValidateIntentToPossess(idolator, ghost)
    if not idolator or not idolator:Exists() or idolator:IsDead() or not ghost or not ghost:Exists() or ghost:IsDead() then
        return false
    end
    local ptr = FiendFolio:GetEntityData(idolator).IdolatorPossession
    if not ptr or not ptr.Ref or ptr.Ref.InitSeed ~= ghost.InitSeed then
        return false
    end
    ptr = FiendFolio:GetEntityData(ghost).IdolatorPossession
    if not ptr or not ptr.Ref or ptr.Ref.InitSeed ~= idolator.InitSeed then
        return false
    end
    return true
end

local function GetRoomCenterTarget(npc)
    local room = game:GetRoom()
    local roomCenter = room:GetCenterPos()
    local gridIndex1 = room:GetGridIndex(roomCenter)
    local gridIndex2 = room:GetGridIndex(roomCenter + Vector(0, 40))
    if room:GetGridPath(gridIndex1) >= 950 or room:GetGridCollision(gridIndex1) ~= GridCollisionClass.COLLISION_NONE
            or room:GetGridPath(gridIndex2) >= 950 or room:GetGridCollision(gridIndex2) ~= GridCollisionClass.COLLISION_NONE then
        -- Room center is blocked.
        return nil
    end
    local targetPos = roomCenter + Vector(0, 20)
    if npc.Pathfinder:HasPathToPos(targetPos, false) then
        return targetPos
    end
end

--------------------------------------------------
-- WRATH'S TROLL BOMBS

local function ThrowTrollBomb(pos, vel, initialHeight, fallingSpeed, spawner)
    local bomb = Isaac.Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_TROLL, 0, pos, vel, spawner):ToBomb()
    bomb.SpriteOffset = Vector(0, initialHeight)
    bomb.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    bomb:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
    local sprite = bomb:GetSprite()
    sprite:Play("Appear", true)
    sprite:SetFrame(7)

    local data = FiendFolio:GetEntityData(bomb)
    data.IdolatorWrathBomb = true
    data.IdolatorWrathBombFallingSpeed = fallingSpeed

    return bomb
end

FF:AddCallback(ModCallbacks.MC_POST_BOMB_RENDER, function(_, bomb)
    local data = FiendFolio:GetEntityData(bomb)

    if not data.IdolatorWrathBomb then return end

    local currentFrame = Isaac.GetFrameCount()
    if game:IsPaused() or data.IdolatorWrathBombLastUpdate == currentFrame then return end
    data.IdolatorWrathBombLastUpdate = currentFrame
    
    local sprite = bomb:GetSprite()
    if sprite:IsPlaying("Appear") and sprite:GetFrame() == 24 then
        sprite:Play("Pulse", true)
    end

    local fallingSpeed = data.IdolatorWrathBombFallingSpeed or 0
    bomb.SpriteOffset = Vector(0, bomb.SpriteOffset.Y + fallingSpeed)

    if bomb.SpriteOffset.Y >= 0 and fallingSpeed > 0 then
        bomb.SpriteOffset = FF.nilvector
        bomb.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        if fallingSpeed < 1.1 then
            data.IdolatorWrathBomb = nil
            fallingSpeed = nil
        else
            fallingSpeed = -fallingSpeed * 0.5
        end
    else
        fallingSpeed = fallingSpeed + 0.5
    end
    data.IdolatorWrathBombFallingSpeed = fallingSpeed
end, BombVariant.BOMB_TROLL)

--------------------------------------------------
-- IDOLATOR

local function UpdateMoveTarget(npc, manualTarget)
    local data = FiendFolio:GetEntityData(npc)
    local room = game:GetRoom()

    local target
    if manualTarget and npc.Pathfinder:HasPathToPos(manualTarget, false) then
        target = manualTarget
    end
    if not target and not manualTarget then
        local attempts = 0
        while not target and attempts < 3 do
            target = room:FindFreeTilePosition(room:GetRandomPosition(npc.Size), 80)
            if not npc.Pathfinder:HasPathToPos(target, false) then
                target = nil
            end
            attempts = attempts + 1
        end
    end

    data.Target = target
    data.LastTargetUpdate = game:GetFrameCount()
    data.AutoUpdateTargetIfClose = (manualTarget == nil)
end

local function ShouldWalkAround(npc)
    local data = FiendFolio:GetEntityData(npc)
    return not data.Action or data.Action == "AwaitPossession"
            or (npc.SubType == FF.FF.IdolatorLust.Sub and data.Action == 'SineWave')
end

local IdolatorRoutines = {
    -- All Idolators:
    -- - Wander around the room
    --   - Gluttony and Lust more aggressive
    function(npc)
        local data = FiendFolio:GetEntityData(npc)

        if not data.init then
            npc.Mass = 1000
            data.init = true
        end

        FF.WaitUntil(function() return ShouldWalkAround(npc) end)

        local chasePlayer = (npc.SubType == FF.FF.IdolatorLust.Sub or npc.SubType == FF.FF.IdolatorGluttony.Sub)

        if chasePlayer then
            UpdateMoveTarget(npc, npc:GetPlayerTarget().Position)
        else
            UpdateMoveTarget(npc)
        end

        --print("Movepos update: " .. game:GetFrameCount())
        local nextUpdate = game:GetFrameCount() + (chasePlayer and 10 or 30*2)

        FF.WaitUntil(function()
            return not data.Target or game:GetFrameCount() >= nextUpdate or (data.AutoUpdateTargetIfClose and npc.Position:Distance(data.Target) <= 80)
        end)
    end,
    function(npc)
        local data = FiendFolio:GetEntityData(npc)
        local sprite = npc:GetSprite()

        if npc.SubType == FF.FF.IdolatorGluttony.Sub then
            if not data.Action then
                sprite:Play('Idle', false)
            end
            if data.Action ~= 'BrimstoneBacklash' and data.Action ~= 'ProjectileJump' then
                npc.Velocity = FF:Lerp(npc.Velocity, FF.nilvector, 0.3)
            end
            return
        end

        if data.Action == 'Split2' then
            npc.Velocity = FF:Lerp(npc.Velocity, FF.nilvector, 0.14)
            return
        --[[elseif data.Action == 'RotatingBrim' then
            npc.Position = npc.TargetPosition
            npc.Velocity = FF.nilvector
            return]]
        elseif not ShouldWalkAround(npc) --[[and not (npc.SubType == FF.FF.IdolatorPride.Sub and data.Action == 'RotatingBrimSeeking')]] then
            npc.Velocity = FF.nilvector
            return
        elseif data.Target and npc.Position:Distance(data.Target) > 10 then
            local dist = npc.Position:Distance(data.Target)
            local moveSpeed = GetMoveSpeed(npc)

            if dist <= 80 and game:GetRoom():CheckLine(data.Target, npc.Position, 1, 1, false, false) then
                local speed = FF:Lerp(moveSpeed * 0.25, moveSpeed, dist / 80)
                local targetVel = (data.Target - npc.Position):Resized(speed)
                npc.Velocity = FF:Lerp(npc.Velocity, targetVel, 0.2)
            else
                npc.Pathfinder:FindGridPath(data.Target, moveSpeed / 9.5, 900, true)
            end
        else
            npc.Velocity = FF:Lerp(npc.Velocity, FF.nilvector, 0.2)
        end

        if npc.SubType == FF.FF.IdolatorSloth.Sub then
            sprite:Play('Walk', false)
        elseif npc.SubType == FF.FF.IdolatorEnvy.Sub then
            local vel = npc.Velocity
            if math.abs(vel.Y) > math.abs(vel.X) then
                sprite:Play('WalkVert', false)
            else
                if vel.X < 0 then
                    sprite:Play('WalkLeft', false)
                else
                    sprite:Play('WalkRight', false)
                end
            end
            sprite.FlipX = false
        else
            local vertAnim = 'WalkVert'
            if npc.SubType == FF.FF.IdolatorLust.Sub then
                if data.Action == 'SineWave' then
                    vertAnim = 'WalkVert02'
                else
                    sprite:PlayOverlay('WalkHead', false)
                end
            end
            FF:AnimWalkFrame(npc, sprite, 'WalkHori', vertAnim)
            sprite.FlipX = (sprite:GetAnimation() == 'WalkHori' and npc.Velocity.X < 0)
                    or (sprite:GetAnimation() == vertAnim and npc.Velocity.Y < 0)
        end
    end,
    -- Deciding when to start attacks.
    function(npc)
        local data = FiendFolio:GetEntityData(npc)
        if data.Action then return end

        data.SinceLastAction = (data.SinceLastAction or -1) + 1
        local waitSeconds =  (npc.SubType == FF.FF.IdolatorGluttony.Sub) and 1 or 2
        if FiendFolio:GetEntityData(npc).IdolatorSplit then
            waitSeconds = waitSeconds + 1
        end
        if data.SinceLastAction <= 30 * waitSeconds then return end

        if FF:RandomFloat() > 0.2 then return end

        local actions = {}
        if npc.SubType == FF.FF.IdolatorSloth.Sub then
            actions = { 'ShootCreep' }
        elseif npc.SubType == FF.FF.IdolatorLust.Sub then
            actions = { 'SineWave', 'FlatStone' }
        elseif npc.SubType == FF.FF.IdolatorWrath.Sub then
            actions = { 'CrossExplode', 'RandomBombs' }
        elseif npc.SubType == FF.FF.IdolatorGluttony.Sub then
            actions = { 'ProjectileJump' }

            local canBrim = true
            local partitions = 4
            local room = game:GetRoom()
            for i = 0, partitions - 1 do
                local dir = Vector.FromAngle(360 / partitions * i)
                if not room:IsPositionInRoom(npc.Position + dir * 45, 0) then
                    canBrim = false
                    break
                end
            end

            if canBrim then
                if data.SkippedGluttonBrim or Random() % 2 == 0 then
                    actions = {'BrimstoneBacklash'}
                    data.SkippedGluttonBrim = nil
                else
                    data.SkippedGluttonBrim = true
                end
            end
        elseif npc.SubType == FF.FF.IdolatorGreed.Sub then
            local numCoins = #Isaac.FindByType(EntityType.ENTITY_ULTRA_COIN)
            if numCoins + 2 <= CONFIG.GREED.MaxCoins then
                table.insert(actions, 'ShootCoins')
            end
            local numGreedGapers = #Isaac.FindByType(EntityType.ENTITY_GREED_GAPER)
            if numGreedGapers + CONFIG.GREED.GreedGapersPerSummon <= CONFIG.GREED.MaxGreedGapers then
				data.IdolatorGreedSummonDoorSlot = FindDoorSlotForGreedGapers()
				if data.IdolatorGreedSummonDoorSlot then
					table.insert(actions, 'GreedGapers')
				end
            end
        elseif npc.SubType == FF.FF.IdolatorEnvy.Sub then
            local numHeads = #Isaac.FindByType(FF.FF.IdolatorEnvyHead.ID, FF.FF.IdolatorEnvyHead.Var)
            if numHeads < CONFIG.ENVY.MaxHeads then
                table.insert(actions, 'SpawnHeads')
            end
            if numHeads > 1 then
                table.insert(actions, 'ShootCardinal')
            end
        elseif npc.SubType == FF.FF.IdolatorPride.Sub then
            actions = { 'BouncyBombs', 'Lasers' }
            --[[if GetRoomCenterTarget(npc) then
                table.insert(actions, 'RotatingBrimSeeking')
            end]]
        end

        data.Action = actions[math.floor(FF:RandomFloat() * #actions) + 1]
        --print('Action:', data.Action)
        data.SinceLastAction = 0
    end,
    -- Trigger possession.
    function(npc)
        local data = FiendFolio:GetEntityData(npc)

        if npc.FrameCount <= 1 or npc:GetSprite():IsPlaying("Appear") then return end

        if not data.IdolatorLastPossessed then
            data.IdolatorLastPossessed = npc.FrameCount
        end
        local lastPossession = data.IdolatorLastPossessed
        local timer = (npc.SubType == 0) and FIRST_POSSESSION_TIMER or POSSESSION_TIMER
        if data.Action or npc.FrameCount < lastPossession + timer then
            return
        end

        -- Find the sin ghosts that are available for possession.
        local eligibleGhosts = {}
        for _, ghost in ipairs(Isaac.FindByType(FF.FF.IdolatorGhost.ID, FF.FF.IdolatorGhost.Var)) do
            if ghost.SubType == npc.SubType then
                -- Duplicate of the ghost currently possessing us, somehow.
                ghost:Remove()
            elseif not FiendFolio:GetEntityData(ghost).IdolatorPossession then
                table.insert(eligibleGhosts, ghost)
            end
        end
        if #eligibleGhosts == 0 then return end

        -- Randomly pick a ghost to get possessed by.
        if not data.IdolatorRng then
            data.IdolatorRng = RNG()
            data.IdolatorRng:SetSeed(npc.InitSeed, 7)
        end
        local chosenGhost = eligibleGhosts[FF:RandomInt(1, #eligibleGhosts, data.IdolatorRng)]
        data.IdolatorPossession = EntityPtr(chosenGhost)
        FiendFolio:GetEntityData(chosenGhost).IdolatorPossession = EntityPtr(npc)
        chosenGhost:GetSprite():Play("PossessionTell", true)
        data.Action = "AwaitPossession"
    end,
    -- Handle possession.
    function(npc)
        local data = FiendFolio:GetEntityData(npc)
        FF.WaitUntil(function()
            if data.Action == "GettingPossessed" then
                -- Failsafe.
                data.Action = nil
                data.IdolatorPossession = nil
            end
            return data.Action == 'AwaitPossession'
        end)

        -- Just walk around while the ghost is flying towards Idolator.
        FF.WaitUntil(function()
            local ghost = data.IdolatorPossession and data.IdolatorPossession.Ref
            if not ValidateIntentToPossess(npc, ghost) then
                return true
            end
            if npc.Position:Distance(ghost.Position) <= npc.Size * 0.75 then
                return true
            end
        end)
        
        local ghost = data.IdolatorPossession and data.IdolatorPossession.Ref
        if not ValidateIntentToPossess(npc, ghost) then
            -- Something went wrong, bail out.
            data.IdolatorPossession = nil
            data.Action = nil
            return
        end
        
        -- Begin possession.
        data.Action = "GettingPossessed"
        
        local oldSubType = npc.SubType
        local newSubType = ghost.SubType
        data.IdolatorQueuedGhost = newSubType
        ghost:Remove()
        
        local sprite = npc:GetSprite()
        sprite:RemoveOverlay()
        sprite:Play("Possess", true)
        sprite.FlipX = false
        npc:SetColor(FF.ColorPureWhite, 10, 1, true, true)
        FF:PlaySound(FF.Sounds.FireballLaunch, npc, FF:RandomFloat(0.9, 1.1), 0.6)
        
        FF.WaitUntil(function() return sprite:IsFinished("Possess") end)
        
        npc:Morph(FF.FF.Idolator.ID, FF.FF.Idolator.Var, newSubType, -1)
        data.IdolatorQueuedGhost = nil
        if oldSubType > 0 then
            -- Eject the previous ghost, if any.
            local newGhost = Isaac.Spawn(FF.FF.IdolatorGhost.ID, FF.FF.IdolatorGhost.Var, oldSubType, npc.Position, RandomVector()*10, npc)
            newGhost:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            FF:PlaySound(FF.Sounds.FireballLaunch, npc, FF:RandomFloat(0.9, 1.1), 0.6)
        end
        
        sprite:Play("Appear", true)
        if newSubType ~= FF.FF.IdolatorSloth.Sub then
            FF:PlaySound(SoundEffect.SOUND_DEATH_REVERSE, npc)
        end
        npc:SetColor(FF.ColorPureWhite, 10, 1, true, true)
        
        FF.WaitUntil(function()
            return sprite:IsFinished("Appear")
        end)
        
        data.IdolatorLastPossessed = npc.FrameCount
        data.IdolatorPossession = nil
        data.Action = nil
        data.SinceLastAction = 0
    end,
    -- Spawn a second idolator at 66% health.
    function(npc)
        local data = FiendFolio:GetEntityData(npc)

        FF.WaitUntil(function()
            return not FF:isFriend(npc) and not data.IdolatorSplit and not data.Action and npc.HitPoints <= npc.MaxHitPoints * SPLIT_HP
        end)

        data.Action = "Split"

        local sprite = npc:GetSprite()
        sprite:RemoveOverlay()
        sprite:Play("Possess", true)
        sprite.FlipX = false

        FF.WaitUntil(function() return sprite:IsFinished("Possess") end)

        if npc.SubType > 0 then
            -- Eject the current ghost, if any.
            local ghostSubType = npc.SubType
            npc:Morph(FF.FF.Idolator.ID, FF.FF.Idolator.Var, 0, -1)
            local newGhost = Isaac.Spawn(FF.FF.IdolatorGhost.ID, FF.FF.IdolatorGhost.Var, ghostSubType, npc.Position, RandomVector()*10, npc)
            newGhost:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            FF:PlaySound(FF.Sounds.FireballLaunch, npc, FF:RandomFloat(0.9, 1.1), 0.6)
        end

        FF:PlaySound(SoundEffect.SOUND_MEATY_DEATHS, npc)

        local newIdolator = Isaac.Spawn(FF.FF.Idolator.ID, FF.FF.Idolator.Var, 0, npc.Position, FF.nilvector, nil):ToNPC()
        newIdolator:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        newIdolator.HitPoints = math.ceil(newIdolator.MaxHitPoints * SPLIT_HP)

        local dir = RandomVector()
        for i, idolator in ipairs({npc, newIdolator}) do
            idolator:GetSprite():Play("Appear", true)
            idolator:GetSprite():SetFrame(7 + (i-1)*7)
            idolator:SetColor(FF.ColorPureWhite, 10, 1, true, true)

            local rotDir = dir:Rotated(i * 180)
            idolator.Velocity = rotDir * 7
            idolator.Position = idolator.Position + rotDir

            FiendFolio:GetEntityData(idolator).IdolatorSplit = true
            FiendFolio:GetEntityData(idolator).Action = "Split2"
        end
    end,
    function(npc)
        local data = FiendFolio:GetEntityData(npc)
        if data.Action == "Split2" and not npc:GetSprite():IsPlaying("Appear") then
            data.Action = nil
        end
    end,

    -- Wrath
    --   1. Can do the tainted boom fly death effect, either cardinally or diagonally.
    function(npc)
        if npc.SubType ~= FF.FF.IdolatorWrath.Sub then return end

        local data = FiendFolio:GetEntityData(npc)
        FF.WaitUntil(function() return data.Action == 'CrossExplode' end)

        local angleOffset = FF:RandomFloat() * 2 < 1 and 0 or 45
        local attack = angleOffset == 0 and 'Attack01' or 'Attack02'

        local sprite = npc:GetSprite()
        sprite:Play(attack, true)

        FF.WaitUntil(function() return sprite:IsEventTriggered('Shoot') end)

        FF:PlaySound(SoundEffect.SOUND_MONSTER_YELL_A, npc, 1.0)

        for i = 0, 3 do
            local angle = angleOffset + i * 90
            local dir = Vector(1,0):Rotated(angle)
            local tracer = Isaac.Spawn(1000, 198, 0, npc.Position + dir * 10, Vector(0.001,0), npc):ToEffect()
            tracer.Timeout = CONFIG.WRATH.CrossExplosionInitialDelay + 5
            tracer.TargetPosition = dir
            tracer.LifeSpan = CONFIG.WRATH.CrossExplosionInitialDelay
            tracer:FollowParent(npc)
            tracer.SpriteScale = Vector(3,0.0001)
            tracer.Color = Color(0.5,0.2,0,0.8,0,0,0)
            tracer:Update()

            local progress = 0
            local startPos = nil
            local function myexplode()
                startPos = startPos or npc.Position
                local pos = startPos + progress * dir * CONFIG.WRATH.CrossExplosionSpacing
                if game:GetRoom():IsPositionInRoom(pos, 0) then
					game:BombExplosionEffects(pos, 40, nil, nil, npc, CONFIG.WRATH.CrossExplosionRadiusMult)
                    progress = progress + 1
                    FF.scheduleForUpdate(myexplode, CONFIG.WRATH.CrossExplosionIncrementalDelay)
                end
            end
            FF.scheduleForUpdate(myexplode, CONFIG.WRATH.CrossExplosionInitialDelay)
        end

        FF.WaitUntil(function() return sprite:IsFinished(attack) end)

        data.Action = nil
    end,
    --   2. Throw bombs into the air at random points in the room, these bombs have random fuses.
    function(npc)
        if npc.SubType ~= FF.FF.IdolatorWrath.Sub then return end

        local data = FiendFolio:GetEntityData(npc)
        FF.WaitUntil(function() return data.Action == 'RandomBombs' end)

        local sprite = npc:GetSprite()
        sprite:Play('BombLaunch', true)
        FF:PlaySound(SoundEffect.SOUND_GOOATTACH0, npc, 0.75)
        FF:PlaySound(SoundEffect.SOUND_LIGHTBOLT_CHARGE, npc, 0.75)
        FF.WaitUntil(function() return sprite:IsEventTriggered('Shoot') end)
        sfx:Stop(SoundEffect.SOUND_LIGHTBOLT_CHARGE)

        FF:PlaySound(SoundEffect.SOUND_BULLET_SHOT, npc)

        local room = game:GetRoom()
        local numBombs = FF:RandomInt(CONFIG.WRATH.MinBombs, CONFIG.WRATH.MaxBombs)

        for i = 1, numBombs do
            local speed = FF:RandomInt(5, 15)
            local vel = (room:GetRandomPosition(0) - npc.Position):Resized(speed)
            local fallingSpeed = FF:RandomInt(-90, -50) / 10
            ThrowTrollBomb(npc.Position, vel, -50, fallingSpeed, npc)
        end

        FF.WaitUntil(function() return sprite:IsFinished('BombLaunch') end)

        data.Action = nil
    end,

    -- Pride (old)
    --   1. Goes to the center of the room, does a rotating brimstone, first diagonally
    --      Occasionally, pride will shoot triple shots at the player.
	-- (Disabled this move, it was cool but too tight with multiple idolators.)
    --[[function(npc)
        if npc.SubType ~= FF.FF.IdolatorPride.Sub then return end

        local data = FiendFolio:GetEntityData(npc)

        if data.Action == 'RotatingBrim' then
            data.Action = nil
            npc.TargetPosition = FF.nilvector
        end

        FF.WaitUntil(function() return data.Action == 'RotatingBrimSeeking' end)

        local lastCheckedPos

        FF.WaitUntil(function()
            if npc.FrameCount % 30 == 0 then
                if lastCheckedPos and lastCheckedPos:Distance(npc.Position) < 5 then
                    -- We aren't going anywhere. Give up.
                    data.Target = nil
                    return true
                end
                lastCheckedPos = Vector(npc.Position.X, npc.Position.Y)
            end
            UpdateMoveTarget(npc, GetRoomCenterTarget(npc))
            return not data.Target or npc.Position:DistanceSquared(data.Target) < 10
        end)
        -- don't use attack if center of room is filled
        if not data.Target then
            data.Action = nil
            return
        end

        data.Action = 'RotatingBrim'
        npc.TargetPosition = data.Target

        local sprite = npc:GetSprite()
        sprite:Play('Attack01', true)
        for i = 1, 4 do
            local angle = 45 + i * 90
            local dir = Vector.FromAngle(angle)
            local tracer = Isaac.Spawn(1000, 198, 0, npc.Position + dir * 10 + Vector(0, -20), Vector(0.001,0), npc):ToEffect()
            tracer.Timeout = 20
            tracer.TargetPosition = dir
            tracer.LifeSpan = 12
            tracer:FollowParent(npc)
            tracer.SpriteScale = Vector(3,0.0001)
            tracer.Color = Color(0.5,0.2,0,0.8,0,0,0)
            tracer:Update()
        end
        FF.WaitUntil(function() return sprite:IsEventTriggered('Shoot') end)

        FF:PlaySound(SoundEffect.SOUND_BOSS_BUG_HISS, npc, 1.0)

        local attackStart = npc.FrameCount
        local attackDuration = CONFIG.PRIDE.BrimRotationDelay + CONFIG.PRIDE.BrimRotationTime - 10

        for i = 1, 4 do
            local angle = 45 + i * 90
            local laser = EntityLaser.ShootAngle(1, npc.Position + Vector(0, -20), angle, attackDuration, FF.nilvector, npc)
            laser.IsActiveRotating = true
            laser.RotationDegrees = CONFIG.PRIDE.BrimRotationDegrees
            laser.RotationSpd = CONFIG.PRIDE.BrimRotationDegrees / CONFIG.PRIDE.BrimRotationTime
            laser.RotationDelay = CONFIG.PRIDE.BrimRotationDelay
            laser.DisableFollowParent = true
        end

        FF.WaitUntil(function() return sprite:IsFinished('Attack01') end)
        FF.WaitFor(5)

        while npc.FrameCount - attackStart < attackDuration do
            -- shoot a triple shot at the player
            sprite:Play('Attack01', true)
            FF.WaitUntil(function() return sprite:IsEventTriggered('Shoot') end)

            FF:PlaySound(SoundEffect.SOUND_BOSS_LITE_HISS, npc, 1.0)
            local bet = npc:GetPlayerTarget().Position - npc.Position
            for i = -1, 1 do
                FF:LazySpawnProjectile(0, 0, npc.Position, bet:Rotated(i * CONFIG.PRIDE.ProjFanWidth):Resized(CONFIG.PRIDE.ProjSpeed), npc)
            end
            FF.WaitUntil(function() return sprite:IsFinished('Attack01') end)
            FF.WaitFor(5)
        end

        FF.WaitUntil(function() return sprite:IsFinished('Attack01') end)

        data.Action = nil
        npc.TargetPosition = FF.nilvector
    end,]]

	-- Pride
    --   1. (New) Creates clones of Pride, then all of them do a Pride laser attack.
	--      Pride may randomly switch places with one of the clones at the end of the attack.
    function(npc)
        if npc.SubType ~= FF.FF.IdolatorPride.Sub then return end

		local data = FiendFolio:GetEntityData(npc)
		local room = game:GetRoom()

        FF.WaitUntil(function() return data.Action == 'Lasers' end)

		local sprite = npc:GetSprite()
        sprite:Play('Attack01', true)

		data.idolatorPrideClones = {}

		local cloneSpawnAttempts = CONFIG.PRIDE.NumClones * 3
		while #data.idolatorPrideClones < CONFIG.PRIDE.NumClones and cloneSpawnAttempts > 0 do
			cloneSpawnAttempts = cloneSpawnAttempts - 1
			local pos = room:FindFreeTilePosition(room:GetRandomPosition(npc.Size), 80)
            if npc.Pathfinder:HasPathToPos(pos, false) then
                table.insert(data.idolatorPrideClones, pos)
            end
		end

		local lasersOffset = Vector(0, -20)

		local angleOffsets = {}
		local tracers = {}

		-- Spawn tracers
		for i = 0, #data.idolatorPrideClones do
			local pos
			if i == 0 then
				pos = npc.Position
			else
				pos = data.idolatorPrideClones[i]
			end
			angleOffsets[i] = Random() % 360
			for j = 1, CONFIG.PRIDE.NumLasers do
				local angle = angleOffsets[i] + j * 360 / CONFIG.PRIDE.NumLasers
				local dir = Vector.FromAngle(angle)
				local tracer = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.GENERIC_TRACER, 0, pos + dir * 10 + lasersOffset, Vector(0.001,0), npc):ToEffect()
				tracer.LifeSpan = 16
				tracer.Timeout = tracer.LifeSpan
				tracer.TargetPosition = dir
				if i == 0 then
					tracer:FollowParent(npc)
					tracer.ParentOffset = lasersOffset
				else
					tracer.ParentOffset = FF.nilvector
				end
				tracer.PositionOffset = FF.nilvector
				tracer.SpriteScale = Vector(2,0.0001)
				tracer.Color = Color(1,1,1,0.2,0,0,0)
				tracer:Update()
				table.insert(tracers, EntityPtr(tracer))
			end
		end

		FF.WaitUntil(function() return sprite:IsEventTriggered('Shoot') end)
		FF:PlaySound(SoundEffect.SOUND_BOSS_LITE_HISS, npc, 1.0)

		-- Clear tracers
		for _, tracerPtr in ipairs(tracers) do
			if tracerPtr.Ref and tracerPtr.Ref:Exists() then
				tracerPtr.Ref:ToEffect().Timeout = 1
				tracerPtr.Ref.Parent = nil
				tracerPtr.Ref.Color = Color(1,1,1, tracerPtr.Ref.Color.A * 0.5, 0,0,0)
			end
		end

		local swap = Random() % (#data.idolatorPrideClones + 1)
		if swap > 0 then
			-- Swap positions & laser angles with one of the clones
			local origPos = Vector(npc.Position.X, npc.Position.Y)
			local clonePos = data.idolatorPrideClones[swap]
			npc.Position = clonePos
			data.idolatorPrideClones[swap] = origPos

			local origAngle = angleOffsets[0]
			local cloneAngle = angleOffsets[swap]
			angleOffsets[0] = cloneAngle
			angleOffsets[swap] = origAngle
		end

		-- Spawn lasers
		for i = 0, #data.idolatorPrideClones do
			local pos
			if i == 0 then
				pos = npc.Position
			else
				pos = data.idolatorPrideClones[i]
			end
			for j = 1, CONFIG.PRIDE.NumLasers do
				local angle = angleOffsets[i] + j * 360 / CONFIG.PRIDE.NumLasers
				local laser = EntityLaser.ShootAngle(LaserVariant.PRIDE, pos + lasersOffset, angle, CONFIG.PRIDE.LaserDuration, FF.nilvector, npc)
				laser.Color = Color(1,1,1,0,0,0,0)
				laser.Parent = npc
				laser.DisableFollowParent = (i > 0)
			end
		end

        FF.WaitUntil(function() return sprite:IsFinished('Attack01') end)

		data.idolatorPrideClones = nil
		data.Action = nil
	end,
    --   2. Kicks a bouncy bomb towards the player. This bomb bounces around the room and explodes after some bounces.
    function(npc)
        if npc.SubType ~= FF.FF.IdolatorPride.Sub then return end

        local data = FiendFolio:GetEntityData(npc)
        FF.WaitUntil(function() return data.Action == 'BouncyBombs' end)

        local sprite = npc:GetSprite()
        sprite:Play('Attack02', true)
        FF:PlaySound(SoundEffect.SOUND_GURG_BARF, npc, 1.0)
        FF.WaitUntil(function() return sprite:IsEventTriggered('Shoot') end)

        local bet = npc:GetPlayerTarget().Position - npc.Position
        sprite.FlipX = bet.X < 0

        FF.WaitUntil(function() return sprite:IsEventTriggered('Kick') end)
        
        local bombOffset = Vector(30, 0)
        if sprite.FlipX then
            bombOffset = bombOffset * -1
        end

        local bomb = Isaac.Spawn(
            FF.FF.IdolatorPrideBomb.ID, FF.FF.IdolatorPrideBomb.Var, 0,
            npc.Position + bombOffset, bet:Resized(CONFIG.PRIDE.BombSpeed), npc
        )
        bomb:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        bomb:Update()

        FF:PlaySound(SoundEffect.SOUND_CLAP, npc, 1.0)
        FF:PlaySound(SoundEffect.SOUND_BOSS_LITE_HISS, npc, 1.0)

        FF.WaitUntil(function() return sprite:IsFinished('Attack02') end)

        data.Action = nil
    end,

    -- Envy
    --   1. Shoots little heads that bounce about the room at the player and do contact damage
    function(npc)
        if npc.SubType ~= FF.FF.IdolatorEnvy.Sub then return end

        local data = FiendFolio:GetEntityData(npc)
        FF.WaitUntil(function() return data.Action == 'SpawnHeads' end)

        local sprite = npc:GetSprite()

        local throwOrder = (Random() % 2 == 0) and {1,2} or {2,1}

        for numThrow, i in ipairs(throwOrder) do
            local anim = 'Attack0' .. i
            sprite:Play(anim, true)
            FF:PlaySound(SoundEffect.SOUND_BLOBBY_WIGGLE, npc)
            FF.WaitUntil(function() return sprite:IsEventTriggered("Throw") end)

            FF:PlaySound(SoundEffect.SOUND_MONSTER_GRUNT_0, npc, 1.0)
            FF:PlaySound(SoundEffect.SOUND_BIRD_FLAP, npc, 1.0)
            local vel = (npc:GetPlayerTarget().Position - npc.Position):Resized(CONFIG.ENVY.HeadSpeed)
            local pos = npc.Position + vel
            local head = Isaac.Spawn(FF.FF.IdolatorEnvyHead.ID, FF.FF.IdolatorEnvyHead.Var, 0, pos, vel, npc)
            head:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

            FF.WaitUntil(function() return sprite:IsFinished(anim) end)

            if numThrow == 1 then
                local numHeads = #Isaac.FindByType(FF.FF.IdolatorEnvyHead.ID, FF.FF.IdolatorEnvyHead.Var)
                if numHeads > math.ceil(CONFIG.ENVY.MaxHeads * 0.5) then
                    -- Don't throw another one.
                    data.Action = nil
                    return
                end
            end
        end

        data.Action = nil
    end,
    --   2. Envy and his heads shoot cardinal projectiles at the same time
    function(npc)
        if npc.SubType ~= FF.FF.IdolatorEnvy.Sub then return end

        local data = FiendFolio:GetEntityData(npc)
        FF.WaitUntil(function() return data.Action == 'ShootCardinal' end)

        local sprite = npc:GetSprite()
        sprite:Play('Scream', true)
        FF:PlaySound(SoundEffect.SOUND_MONSTER_ROAR_1, npc)
        FF.WaitUntil(function() return sprite:IsEventTriggered('TriggerHeads') end)

        local heads = Isaac.FindByType(FF.FF.IdolatorEnvyHead.ID, FF.FF.IdolatorEnvyHead.Var)
        for _, head in pairs(heads) do
            head:GetSprite():Play('Shoot', true)
        end
        FF.WaitUntil(function() return sprite:IsEventTriggered('Yell') end)

        FF:PlaySound(SoundEffect.SOUND_MONSTER_GRUNT_5, npc, 1.0)
        for i = 0, 3 do
            FF:LazySpawnProjectile(0, 0, npc.Position, Vector(1, 0):Rotated(i * 90) * CONFIG.ENVY.ProjectileSpeed, npc)
        end

        FF.WaitUntil(function() return sprite:IsFinished('Scream') end)

        data.Action = nil
    end,

    -- Sloth
    --   0. Slugs around the room, leaving short lasting creep behind.
    function(npc)
        if npc.SubType ~= FF.FF.IdolatorSloth.Sub then return end

        local creepInterval = (FiendFolio:GetEntityData(npc).Action == 'Charge') and CONFIG.SLOTH.ChargeCreepInterval or CONFIG.SLOTH.MoveCreepInterval

        if npc.FrameCount % creepInterval == 0 then
            local creep = Isaac.Spawn(1000, 22, 0, npc.Position, FF.nilvector, npc):ToEffect()
            creep.Color = FiendFolio.ColorBobsGreen
            creep:SetTimeout(CONFIG.SLOTH.MoveCreepTimeout)
            creep:Update()
        end
    end,
    --   1. It will sometimes shoot out 3 lines of creep from it, and a maggot in the open region closest to the player.
    function(npc)
        if npc.SubType ~= FF.FF.IdolatorSloth.Sub then return end

        local data = FiendFolio:GetEntityData(npc)
        FF.WaitUntil(function() return data.Action == 'ShootCreep' end)

        local sprite = npc:GetSprite()
        sprite:Play('Attack01', true)
        FF:PlaySound(SoundEffect.SOUND_MONSTER_GRUNT_2, npc, 1.0)
        FF.WaitUntil(function() return sprite:IsEventTriggered('Shoot') end)

        local closestDot = -math.huge
        local closestDir = nil
        local bet = npc:GetPlayerTarget().Position - npc.Position
        for i = 0, 2 do
            local angle = 270 + i * 120
            local dir = Vector.FromAngle(angle)
            local dist = 1

            local maggotDir = dir:Rotated(60)
            local dot = maggotDir:Dot(bet)
            if dot > closestDot then
                closestDir = maggotDir
                closestDot = dot
            end

            local room = game:GetRoom()
            local function fireCreep()
                local pos = npc.Position + dir * dist * CONFIG.SLOTH.TriCreepSpacing + Vector(0, -15)
                local creep = Isaac.Spawn(1000, 22, 0, pos, FF.nilvector, npc):ToEffect()
                creep.Color = FiendFolio.ColorBobsGreen
                creep:SetTimeout(CONFIG.SLOTH.TriCreepTimeout)
                local n = dist / CONFIG.SLOTH.TriCreepAmount
                creep:GetSprite().Scale = Vector.One * FF:Lerp(1.25, 0.75, n)
                creep:Update()
                if room:IsPositionInRoom(pos, 10) then
                    local explosionEff = Isaac.Spawn(1000, EffectVariant.BLOOD_EXPLOSION, 2, pos, FF.nilvector, creep)
                    explosionEff.Color = creep.Color

                    dist = dist + 1
                    if dist < CONFIG.SLOTH.TriCreepAmount then
                        FF.scheduleForUpdate(fireCreep, CONFIG.SLOTH.TriCreepInterval)
                    end
                end
            end
            FF.scheduleForUpdate(fireCreep, 1)
        end
        FF:PlaySound(SoundEffect.SOUND_SINK_DRAIN_GURGLE, npc, 1.0)

        FF:shootMaggot(npc, npc.Position + closestDir * 20, 1, 1)
        FF:PlaySound(SoundEffect.SOUND_SUMMONSOUND, npc, 1.0)

        FF.WaitUntil(function() return sprite:IsFinished('Attack01') end)

        data.Action = nil
    end,
    --   2. If the player is near the right/left, dash towards the player, shooting ipecac rapidly as it dashes.
    function(npc)
        if npc.SubType ~= FF.FF.IdolatorSloth.Sub then return end

        local data = FiendFolio:GetEntityData(npc)
        if data.Action then return end

        local target = npc:GetPlayerTarget()
        local yDiff = math.abs(target.Position.Y - npc.Position.Y)
        local xDiff = math.abs(target.Position.X - npc.Position.X)
        local canCharge = yDiff < npc.Size * CONFIG.SLOTH.ChargeVerticalDetectScale
                and xDiff > CONFIG.SLOTH.ChargeMinDist and xDiff < CONFIG.SLOTH.ChargeMaxDist

        if not canCharge then return end

        data.Action = 'Charge'

        local sprite = npc:GetSprite()

        local goLeft = target.Position.X < npc.Position.X
        local dir = Vector(goLeft and -1 or 1, 0)
        sprite.FlipX = goLeft

        sprite:Play('ChargeStart', true)
        FF:PlaySound(SoundEffect.SOUND_MONSTER_ROAR_0, npc, 1.0)
        FF.WaitUntil(function() return sprite:IsEventTriggered('Charge') end)

        local chargeStartFrame = npc.FrameCount

        repeat
            if sprite:IsFinished('ChargeStart') then
                sprite:Play('ChargeLoop', false)
            end
            npc.Velocity = dir * CONFIG.SLOTH.ChargeSpeed

            local closeToWall = not game:GetRoom():IsPositionInRoom(npc.Position + npc.Velocity * 5, npc.Size)
            if not closeToWall and (npc.FrameCount - chargeStartFrame) % CONFIG.SLOTH.ChargeIpecacInterval == 0 then
                local shootPos = npc.Position + Vector(70 * (goLeft and -1 or 1), 1)
                local initialVel = npc.Velocity:Resized(math.min(npc.Velocity:Length(), 8))
                local proj = FF:LazySpawnProjectile(0, 0, shootPos, initialVel, npc):ToProjectile()
                proj.ProjectileFlags = ProjectileFlags.EXPLODE | ProjectileFlags.ACCELERATE
                proj.FallingSpeed = -16
                proj.FallingAccel = 0.5
                proj.Scale = 2
                proj.Acceleration = 0.8
                proj.Height = -34
                proj.Color = FiendFolio.ColorIpecacProper
                
                local effPos = shootPos + Vector(0, proj.Height)
                local explosionEff = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 2, shootPos, FF.nilvector, npc):ToEffect()
                explosionEff.Color = FiendFolio.ColorBobsGreen
                explosionEff.SpriteOffset = Vector(0, proj.Height)
                
                FF:PlaySound(SoundEffect.SOUND_HEARTOUT, npc, 1.0)
            end
            co.yield()
        until npc:CollidesWithGrid() or npc.FrameCount - chargeStartFrame > 30 * 3

        sprite:Play('ChargeEnd')
        FF.WaitUntil(function() return sprite:IsFinished('ChargeEnd') end)

        data.Action = nil
    end,

    -- Greed (he is pretty fast)
    --   1. Shoots 2 spinning greed coins.
    function(npc)
        if npc.SubType ~= FF.FF.IdolatorGreed.Sub then return end

        local data = FiendFolio:GetEntityData(npc)
        FF.WaitUntil(function() return data.Action == 'ShootCoins' end)

        local dir = npc:GetPlayerTarget().Position - npc.Position

        local sprite = npc:GetSprite()
        sprite:Play('YEAH', true)
        FF:PlaySound(SoundEffect.SOUND_ULTRA_GREED_ROAR_1, npc, 2.0)
        FF.WaitUntil(function() return sprite:IsEventTriggered('Shoot') end)
        FF:PlaySound(SoundEffect.SOUND_ULTRA_GREED_PULL_SLOT, npc, 1.0)

        local vel = dir:Resized(CONFIG.GREED.CoinInitialSpeed)
        local coin = Isaac.Spawn(EntityType.ENTITY_ULTRA_COIN, 0, 0, npc.Position, vel, npc)
        coin:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        coin.MaxHitPoints = CONFIG.GREED.CoinHP
        coin.HitPoints = coin.MaxHitPoints
        for i = 1, 20 do
            coin:Update()
        end
        coin.Velocity = vel
        coin.Position = npc.Position + vel

        FF.WaitUntil(function() return sprite:IsFinished('YEAH') end)

        data.Action = nil
    end,
    --   2. From a wall, it commands   greed gapers.
    function(npc)
        if npc.SubType ~= FF.FF.IdolatorGreed.Sub then return end

        local data = FiendFolio:GetEntityData(npc)
        FF.WaitUntil(function() return data.Action == 'GreedGapers' end)

		local doorSlot = data.IdolatorGreedSummonDoorSlot

		if not doorSlot then
			data.Action = nil
			return
		end

        local sprite = npc:GetSprite()
        sprite:Play('Call', true)
        FF:PlaySound(SoundEffect.SOUND_ULTRA_GREED_ROAR_2, npc, 2.0)
        FF.WaitUntil(function() return sprite:IsEventTriggered('Yell') end)
        FF:PlaySound(SoundEffect.SOUND_ULTRA_GREED_SLOT_WIN_LOOP, npc)

        local doorSlotPos, direction, directionVector = GetGreedHoleInfo(doorSlot)

        if not GREED_WALL_HOLES[doorSlot] then
            local holePos = doorSlotPos + directionVector
            FF.SpawnWallHole(holePos, direction)
            FF:PlaySound(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND)
            game:ShakeScreen(10)
            MakeDebris(holePos, directionVector, 8)
            GREED_WALL_HOLES[doorSlot] = true
        end

        for i = 1, CONFIG.GREED.GreedGapersPerSummon do
            local greedGaper = Isaac.Spawn(EntityType.ENTITY_GREED_GAPER, 0, 0, doorSlotPos, FF.nilvector, npc)
            greedGaper.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
            greedGaper:SetColor(Color(0,0,0,1), 30, 1, true, true)
            local entryVec = directionVector:Resized(3):Rotated(FF:RandomInt(-45, 45))
            FiendFolio:GetEntityData(greedGaper).idolatorGreedGaperEntryVector = entryVec
            FF.WaitFor(5)
        end

        FF.WaitUntil(function() return sprite:IsFinished('Call') end)

        sfx:Stop(SoundEffect.SOUND_ULTRA_GREED_SLOT_WIN_LOOP)
        FF:PlaySound(SoundEffect.SOUND_ULTRA_GREED_SLOT_WIN_LOOP_END, npc)

        data.Action = nil
    end,

    -- Gluttony (He moves via jumping)
    --   1. Jumps into the air, shoots a volley of projectiles midair, then lands, leaving a long lasting creep pool
    function(npc)
        if npc.SubType ~= FF.FF.IdolatorGluttony.Sub then return end

        local data = FiendFolio:GetEntityData(npc)
        FF.WaitUntil(function() return data.Action == 'ProjectileJump' end)

        local sprite = npc:GetSprite()
        sprite:Play('JumpStart', true)
        FF.WaitUntil(function() return sprite:IsFinished('JumpStart') end)

        FF:PlaySound(SoundEffect.SOUND_FAT_WIGGLE, npc)
        npc.Velocity = (npc:GetPlayerTarget().Position - npc.Position) * 0.03

        sprite:Play('JumpLoop', true)

        local maxheight = 100
        local height
        local frames = 0
        local function dojump(cond)
            repeat
                height = math.sin(frames / 8 * math.pi / 2) * maxheight

                if height > 20 then
                    npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                    npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
                else
                    npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                    npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
                end

                npc.PositionOffset = Vector(0, -height)
                frames = frames + 1
                co.yield()
            until cond()
        end

        dojump(function() return math.abs(height - maxheight) < 0.5 end)

        sprite:Play('Apex', true)

        FF.WaitUntil(function() return sprite:IsEventTriggered('Shoot') end)
        local params = ProjectileParams()
        params.HeightModifier = -maxheight + npc.Size / 2
        params.FallingAccelModifier = -1
        for i = 1, FF:RandomInt(10,20) do
            params.Scale = FF:RandomFloat() * 1.5 + 0.5
            params.Damage = 1
            npc:FireBossProjectiles(1, npc:GetPlayerTarget().Position, 40, params)
        end
        FF:PlaySound(SoundEffect.SOUND_BOSS_GURGLE_ROAR, npc)

        FF.WaitUntil(function() return sprite:IsFinished('Apex') end)
        sprite:Play('FallLoop', true)

        dojump(function() return math.abs(height) < 0.5 end)

        npc.PositionOffset = Vector(0, 0)
        npc.Velocity = FF.nilvector

        sprite:Play('Land', true)
        game:MakeShockwave(npc.Position, 0.03, 0.02, 10)
        FF:PlaySound(SoundEffect.SOUND_FORESTBOSS_STOMPS, npc)

        local creep = Isaac.Spawn(1000, 22, 0, npc.Position, FF.nilvector, npc):ToEffect()
        creep.SpriteScale = Vector(2.5, 2.5)
        creep:SetTimeout(200)
        creep:Update()

        FF.WaitUntil(function() return sprite:IsFinished('Land') end)

        data.Action = nil
    end,
    --   2. Like chimera, it will shoot a brimstone moving it backwards, shooting quad shots when it hits a wall
    function(npc)
        if npc.SubType ~= FF.FF.IdolatorGluttony.Sub then return end

        local data = FiendFolio:GetEntityData(npc)
        FF.WaitUntil(function() return data.Action == 'BrimstoneBacklash' end)

        local sprite = npc:GetSprite()
        sprite:Play('BrimstoneCharge', true)
        FF:PlaySound(SoundEffect.SOUND_MOUTH_FULL, npc)

        local dir = FF:SnapVector(npc:GetPlayerTarget().Position - npc.Position, 90):Normalized()
        local angle = dir:GetAngleDegrees()

        local tracer = Isaac.Spawn(1000, 198, 0, npc.Position + dir * 20 + Vector(0, -20), Vector(0.001,0), npc):ToEffect()
        tracer.LifeSpan = sprite:GetCurrentAnimationData():GetLength()
        tracer.Timeout = tracer.LifeSpan + 2
        tracer.TargetPosition = dir
        tracer:FollowParent(npc)
        tracer.SpriteScale = Vector(3, 0.0001)
        tracer.Color = Color(0.5, 0, 0, 0.85)
        tracer:Update()

        FF.WaitUntil(function() return sprite:IsFinished('BrimstoneCharge') end)

        local flipX = false
        local animSuffix
        if math.abs(dir.X) > 0.1 then
            animSuffix = 'Hori'
            if dir.X < 0 then
                flipX = true
            end
        elseif dir.Y > 0 then
            animSuffix = 'Down'
        else
            animSuffix = 'Up'
        end

        sprite:Play('Brimstone' .. animSuffix, true)
        sprite.FlipX = flipX

        local laser = EntityLaser.ShootAngle(
            1, npc.Position, angle,
            30 * 5, dir:Resized(10), npc
        )
        laser.Parent = npc
        laser.PositionOffset = Vector(0, -20)
        if animSuffix == 'Down' then
            laser.DepthOffset = npc.DepthOffset + 100
        elseif animSuffix == 'Up' then
            laser.DepthOffset = npc.DepthOffset - 100
        end

        local targetVel = dir * -20
        npc.Velocity = targetVel
        FF.WaitUntil(function()
            npc.Velocity = FF:Lerp(npc.Velocity, targetVel, 0.5)
            return npc:CollidesWithGrid()
        end)
        npc.Velocity = FF.nilvector

        local collisionAnim = 'Collision' .. animSuffix
        sprite:Play(collisionAnim, true)
        FF:PlaySound(SoundEffect.SOUND_FORESTBOSS_STOMPS, npc)
        game:ShakeScreen(10)
        laser:Die()

        local params = ProjectileParams()
        params.Spread = 1
        npc:FireProjectiles(npc.Position, dir:Resized(10), 4, params)

        FF.WaitUntil(function()
            npc.Velocity = FF:Lerp(npc.Velocity, FF.nilvector, 0.2)
            return sprite:IsFinished(collisionAnim)
        end)

        data.Action = nil
    end,

    -- Lust
    --   1. large slow sine wave proj that breaks on walls into smaller slower of the same w/out the breaking
    function(npc)
        if npc.SubType ~= FF.FF.IdolatorLust.Sub then return end

        local data = FiendFolio:GetEntityData(npc)
        FF.WaitUntil(function() return data.Action == 'SineWave' end)

        local sprite = npc:GetSprite()
        sprite:PlayOverlay('Attack01', true)
        FF:PlaySound(SoundEffect.SOUND_MOUTH_FULL, npc, 1.5)
        FF.WaitUntil(function()
            return sprite:GetOverlayFrame() == 18 -- anm2 shoot event
        end)

        local bet = npc:GetPlayerTarget().Position - npc.Position
        sprite.FlipX = bet.X < 0

        local proj = FF:LazySpawnProjectile(0, 0, npc.Position + bet:Resized(npc.Size), bet:Resized(CONFIG.LUST.KissyProjectileSpeed), npc):ToProjectile()
        proj:AddProjectileFlags(ProjectileFlags.WIGGLE)
        proj.Scale = 2
        proj.FallingAccel = -0.1
        FiendFolio:GetEntityData(proj).IdolatorLustProj = true

        FF:PlaySound(SoundEffect.SOUND_KISS_LIPS1, npc, 1.0)

        FF.WaitUntil(function() return sprite:IsOverlayFinished('Attack01') end)

        data.Action = nil
    end,
    --   2. 2 projectiles that bounce around the room, flat stone with creep on each bounce
    function(npc)
        if npc.SubType ~= FF.FF.IdolatorLust.Sub then return end

        local data = FiendFolio:GetEntityData(npc)
        FF.WaitUntil(function() return data.Action == 'FlatStone' end)

        local sprite = npc:GetSprite()
        sprite:RemoveOverlay()
        sprite:Play('Attack02', true)
        FF:PlaySound(SoundEffect.SOUND_INHALE, npc, 1.25)
        FF.WaitUntil(function() return sprite:IsEventTriggered('Shoot') end)
        sfx:Stop(SoundEffect.SOUND_INHALE)
        FF:PlaySound(SoundEffect.SOUND_WEIRD_WORM_SPIT, npc, 1.0)

        for i=1,2 do
            local bet = npc:GetPlayerTarget().Position - npc.Position
            sprite.FlipX = bet.X < 0
            local proj = FF:LazySpawnProjectile(0, 0, npc.Position, bet:Resized(10), npc):ToProjectile()
            proj.Scale = 2
            proj.FallingAccel = -0.1
            proj.FallingSpeed = 0
            FiendFolio:GetEntityData(proj).IdolatorLustFlatStone = true
            proj:AddProjectileFlags(ProjectileFlags.BOUNCE | ProjectileFlags.ANY_HEIGHT_ENTITY_HIT)
            FF.WaitFor(30 * 0.5)
        end

        FF.WaitUntil(function() return sprite:IsFinished('Attack02') end)

        data.Action = nil
    end,
}

FF:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == FF.FF.Idolator.Var then
        FF.DoRoutines(IdolatorRoutines, npc)
    end
end, FF.FF.Idolator.ID)

-- Prevent self-damage and friendly damage between Idolators.
FF:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, amount, flags, source, cooldown)
    if entity.Variant ~= FF.FF.Idolator.Var then return end

    if FF:isFriend(entity) or source.IsCharmed or source.IsFriendly then return end

    if (source.Type == FF.FF.Idolator.ID and source.Variant == FF.FF.Idolator.Var)
            or (source.SpawnerType == FF.FF.Idolator.ID and source.SpawnerVariant == FF.FF.Idolator.Var) then
        return false
    end

    local anim = entity:GetSprite():GetAnimation()
    if anim == "Possess" or anim == "Appear" then
        return { Damage = amount * TRANSFORMING_DAMAGE_RESISTANCE }
    end
end, FF.FF.Idolator.ID)

FF:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, function(_, npc, collider)
    if npc.Variant == FF.FF.Idolator.Var and npc.SubType == 0
            and collider.Type == npc.Type and collider.Variant == npc.Variant and collider.SubType == 0
            and npc:GetSprite():IsPlaying("Appear") and collider:GetSprite():IsPlaying("Appear") then
        return true
    end
end, FF.FF.Idolator.ID)

local prideAttack01LastFrame
local renderRecursionBit = false

FF:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function(_, npc)
    if npc.Variant ~= FF.FF.Idolator.Var then return end

	local data = FiendFolio:GetEntityData(npc)
	local sprite = npc:GetSprite()

	-- Render Pride's "Clones"
	if npc.SubType == FF.FF.IdolatorPride.Sub and not renderRecursionBit then
		if data.Action == 'Lasers' and sprite:IsPlaying("Attack01") and data.idolatorPrideClones then
			local f = sprite:GetFrame()
			if not prideAttack01LastFrame then
				sprite:SetLastFrame()
				prideAttack01LastFrame = sprite:GetFrame()
				sprite:SetFrame(f)
			end
			local lastFrame = prideAttack01LastFrame
			local fadeIn = 15
			local fadeOut = lastFrame - 10
			local n 
			if f < fadeIn then
				n = math.min(f / fadeIn, 1.0)
			elseif f >= fadeOut then
				n = 1 - math.max((f-fadeOut) / (lastFrame-fadeOut), 0)
			else
				n = 1.0
			end
			local originalColor = Color.Lerp(sprite.Color, Color.Default, 0)  -- Copy
			local cloneColor = Color.Lerp(sprite.Color, Color.Default, 0)
			cloneColor.A = cloneColor.A * n
			sprite.Color = cloneColor
			renderRecursionBit = true
			for _, pos in ipairs(data.idolatorPrideClones) do
				local renderOffset = Isaac.WorldToScreen(pos) - Isaac.WorldToScreen(npc.Position)
				npc:Render(renderOffset)
			end
			sprite.Color = originalColor
		elseif data.idolatorPrideClones then
			data.idolatorPrideClones = nil
		end
		renderRecursionBit = false
	end

	-- Check for some SFX triggers outside of the normal update callback since it doesn't fire while in the "appearing" state.
    local currentFrame = npc.FrameCount
    if game:IsPaused() or data.IdolatorLastAppearSfxCheck == currentFrame then return end
    data.IdolatorLastAppearSfxCheck = currentFrame

    local subt = npc.SubType

    if APPEAR_SOUND[subt] then
        if sprite:IsEventTriggered("AppearSound") and APPEAR_SOUND[subt][1] then
            FF:PlaySound(APPEAR_SOUND[subt][1], npc, 1.0)
        elseif sprite:IsEventTriggered("AppearSound2") and APPEAR_SOUND[subt][2] then
            FF:PlaySound(APPEAR_SOUND[subt][2], npc, 1.0)
        end
    end

    if sprite:IsEventTriggered("Melt") then
        if subt == FF.FF.IdolatorSloth.Sub then
            FF:PlaySound(SoundEffect.SOUND_MEAT_JUMPS, npc, 0.8)
        else
            FF:PlaySound(SoundEffect.SOUND_DEATH_REVERSE, npc, 0.8)
        end
    end
end, FF.FF.Idolator.ID)

--------------------------------------------------
-- GREED'S GAPERS

FF:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    local data = FiendFolio:GetEntityData(npc)
    if data.idolatorGreedGaperEntryVector then
        if game:GetRoom():IsPositionInRoom(npc.Position, npc.Size) then
            data.idolatorGreedGaperEntryVector = nil
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
        else
            npc.Velocity = data.idolatorGreedGaperEntryVector
        end
    end
end, EntityType.ENTITY_GREED_GAPER)

--------------------------------------------------
-- LUST'S PROJECTILES

function FF:IdolatorLustProjectileRender(proj, data)
    if not data.IdolatorLustFlatStone then return end

    local currentFrame = Isaac.GetFrameCount()
    if game:IsPaused() or data.IdolatorLustFlatStoneUpdate == currentFrame then return end
    data.IdolatorLustFlatStoneUpdate = currentFrame

    if not data.IdolatorLustFlatStoneSpawnFrame then
        data.IdolatorLustFlatStoneSpawnFrame = currentFrame
    end
    
    local t = currentFrame - data.IdolatorLustFlatStoneSpawnFrame
    local height = math.abs(math.sin(t / 60 * math.pi * 2))
    proj.Height = FF:Lerp(-6, -76, height)

    if data.CreepReady and height < 0.1 then
        data.SpawnCreep = true
        data.CreepReady = false
    elseif not data.CreepReady and height > 0.5 then
        data.CreepReady = true
    end
end

function FF:IdolatorLustProjectileUpdate(proj, data)
    if data.IdolatorLustFlatStone then
        if data.SpawnCreep then
            local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, proj.Position, FF.nilvector, proj):ToEffect()
            creep.SpriteScale = Vector(2,2)
            creep:SetTimeout(30)
            creep:Update()
            
            data.NumBounces = (data.NumBounces or 0) + 1
            if data.NumBounces >= CONFIG.LUST.MaxBouncyProjectileBounces then
                proj:Die()
            else
                local splash = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.RIPPLE_POOF, 0, proj.Position + Vector(0, -1), FF.nilvector, proj):ToEffect()
                splash.SortingLayer = SortingLayer.SORTING_NORMAL
                splash.SpriteScale = Vector(0.8, 0.8)
                splash.Color = Color(0.8, 0, 0, 1)
                FF:PlaySound(SoundEffect.SOUND_TEARIMPACTS, nil, 1.5)
            end

            data.SpawnCreep = false
        end

    elseif data.IdolatorLustProj then
        if not proj:Exists() or proj:IsDead() then
            local vel = -proj.Velocity:Resized(CONFIG.LUST.KissySplitProjectileSpeed)
            for i = 1, 4 do
                local proj2 = FF:LazySpawnProjectile(0, 0, proj.Position, vel:Rotated(i * 30 - 60), proj):ToProjectile()
                proj2.FallingAccel = -0.06
                proj2:AddProjectileFlags(ProjectileFlags.WIGGLE)
            end
        elseif proj.FrameCount % 4 == 0 then
            local effPos = proj.Position + Vector(0, proj.Height) + RandomVector() * 5
            local eff = Isaac.Spawn(EntityType.ENTITY_EFFECT, 111, 0, effPos, proj.Velocity:Rotated(180):Resized(1), proj):ToEffect()
            eff:GetSprite().PlaybackSpeed = 0.5
            eff:GetSprite().Scale = Vector(0.5, 0.5)
            eff.Color = Color(1,1,1, 0.75)
        end
    end
end

--------------------------------------------------
-- PRIDE'S BOUNCY BOMB

local PrideBomb = {
    function(npc)
        local data = FiendFolio:GetEntityData(npc)
        if not data.init then
            npc.CollisionDamage = 0
            data.Velocity = npc.Velocity
            data.init = true
        end

        if npc.Velocity - data.Velocity ~= FF.nilvector then
            npc.Velocity = npc.Velocity:Resized(CONFIG.PRIDE.BombSpeed)
        end
        data.Velocity = npc.Velocity
    end,
    function(npc)
        local sprite = npc:GetSprite()
        sprite:Play('Idle', true)
        FF.WaitFor(CONFIG.PRIDE.BombFuse[1])

        sprite:Play('Pulse01', true)
        FF.WaitFor(CONFIG.PRIDE.BombFuse[2])

        sprite:Play('Pulse02', true)
        FF.WaitFor(CONFIG.PRIDE.BombFuse[3])

        Isaac.Explode(npc.Position, npc, 40)
        npc:Remove()
    end
}

FF:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == FF.FF.IdolatorPrideBomb.Var then
        FF.DoRoutines(PrideBomb, npc)
    end
end, FF.FF.IdolatorPrideBomb.ID)

FF:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, npc)
    if npc.Variant == FF.FF.IdolatorPrideBomb.Var then
        npc.PositionOffset = Vector(0, -15)
    end
end, FF.FF.IdolatorPrideBomb.ID)

FF:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, function(_, npc, collider)
    if npc.Variant == FF.FF.IdolatorPrideBomb.Var and npc.FrameCount < 15 and npc.SpawnerEntity and collider.InitSeed == npc.SpawnerEntity.InitSeed then
        return true
    end
end, FF.FF.IdolatorPrideBomb.ID)

FF:AddCallback(ModCallbacks.MC_POST_NPC_COLLISION, function(_, npc, collider)
    if npc.Variant == FF.FF.IdolatorPrideBomb.Var and collider:ToPlayer() then
        Isaac.Explode(npc.Position, npc, 40)
        npc:Remove()
    end
end, FF.FF.IdolatorPrideBomb.ID)

--------------------------------------------------
-- PRIDE'S LASERS

-- Handle some minor visual additions to the pride lasers for Idolator.
FF:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, function(_, laser)
    if laser.SpawnerType == FF.FF.Idolator.ID and laser.SpawnerVariant == FF.FF.Idolator.Var then
		local f = laser.FrameCount
		-- After spawning, grow width from a to b until t1, and shrink back to c by t2.
		local a, b, c = 0.25, 1.5, 1.0
		local t1, t2 = 10, 15
		local n
		if laser.FrameCount < t1 then
			n = FF:Lerp(a, b, f / t1)
		elseif laser.FrameCount < t2 then
			n = FF:Lerp(b, c, (f - t1) / (t2 - t1))
		elseif laser.Timeout < 6 then
			-- Shrink and fade out during the last few frames.
			n = FF:Lerp(c, 0, 1 - laser.Timeout / 10)
            laser.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		else
			n = c
		end
        laser.SpriteScale = Vector(1, n)
		-- Add some slight flashing.
		local c = 0.1  * (0.5 + 0.5 * math.sin(math.pi * laser.FrameCount / 6))
		laser.Color = Color(1,1,1, math.min(n, 1.0), c,c,c)
    end
end, LaserVariant.PRIDE)

--------------------------------------------------
-- ENVY'S HEADS

local EnvyHead = {
    function(npc)
        local data = FiendFolio:GetEntityData(npc)
        if not data.init then
            data.Velocity = npc.Velocity
            data.init = true
        end

        if npc.Velocity:Length() == 0 then
            npc.Velocity = RandomVector():Resized(CONFIG.ENVY.HeadSpeed)
        elseif npc.Velocity:DistanceSquared(data.Velocity) > 0.05 then
            npc.Velocity = npc.Velocity:Resized(CONFIG.ENVY.HeadSpeed)
        end
        data.Velocity = npc.Velocity
    end,
    function(npc)
        local sprite = npc:GetSprite()
        FF.WaitUntil(function() return sprite:IsEventTriggered('Shoot') end)

        for i = 0, 3 do
            FF:LazySpawnProjectile(0, 0, npc.Position, Vector(1, 0):Rotated(i * 90) * CONFIG.ENVY.ProjectileSpeed, npc)
        end
    end,
    --[[function(npc)
        if npc.SpawnerType == FF.FF.Idolator.ID and npc.SpawnerVariant == FF.FF.Idolator.Var
                and (not npc.SpawnerEntity or not npc.SpawnerEntity:Exists() or npc.SpawnerEntity:IsDead() or npc.SpawnerEntity.SubType ~= FF.FF.IdolatorEnvy.Sub) then
            npc:Kill()
        end
    end,]]
}

FF:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == FF.FF.IdolatorEnvyHead.Var then
        FF.DoRoutines(EnvyHead, npc)
    end
end, FF.FF.IdolatorEnvyHead.ID)

FF:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, npc)
    if npc.Variant == FF.FF.IdolatorEnvyHead.Var then
        npc.PositionOffset = Vector(0, -25)
        if npc.InitSeed % 2 == 0 then
            npc:GetSprite():ReplaceSpritesheet(0, "gfx/bosses/idolator/boss_idolatorenvyhead02.png")
            npc:GetSprite():LoadGraphics()
        end
        npc:GetSprite().FlipX = (Random() % 2 == 0)
    end
end, FF.FF.IdolatorEnvyHead.ID)

--------------------------------------------------
-- SIN GHOSTS

-- Table for tracking the sin ghosts.
local IDOLATOR_GHOSTS = {
    [FF.FF.IdolatorSloth.Sub] = { Name = "sloth", Ptr = nil },
    [FF.FF.IdolatorLust.Sub] = { Name = "lust", Ptr = nil },
    [FF.FF.IdolatorWrath.Sub] = { Name = "wrath", Ptr = nil },
    [FF.FF.IdolatorGluttony.Sub] = { Name = "gluttony", Ptr = nil },
    [FF.FF.IdolatorGreed.Sub] = { Name = "greed", Ptr = nil },
    [FF.FF.IdolatorEnvy.Sub] = { Name = "envy", Ptr = nil },
    [FF.FF.IdolatorPride.Sub] = { Name = "pride", Ptr = nil },
}

local function GhostExists(tab)
    return tab.Ptr and tab.Ptr.Ref and tab.Ptr.Ref:Exists()
end

-- Try to spawn the ghosts whenever Idolator spawns.
FF:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, npc)
    if npc.Variant == FF.FF.Idolator.Var and npc.SubType == 0
            and #Isaac.FindByType(FF.FF.IdolatorGhost.ID, FF.FF.IdolatorGhost.Var) == 0 then
        for subType, tab in pairs(IDOLATOR_GHOSTS) do
            Isaac.Spawn(FF.FF.IdolatorGhost.ID, FF.FF.IdolatorGhost.Var, subType, FF.nilvector, FF.nilvector, nil)
        end
    end
end, FF.FF.Idolator.ID)

-- If Idolator dies, eject whichever ghost was currently possessing it.
FF:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, function(_, npc)
    if npc.Variant ~= FF.FF.Idolator.Var then return end

    local data = FiendFolio:GetEntityData(npc)

    if npc.SubType > 0 then
        local ghost = Isaac.Spawn(FF.FF.IdolatorGhost.ID, FF.FF.IdolatorGhost.Var, npc.SubType, npc.Position, RandomVector()*20, npc)
        ghost:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
    end

    if data.IdolatorQueuedGhost then
        local ghost = Isaac.Spawn(FF.FF.IdolatorGhost.ID, FF.FF.IdolatorGhost.Var, data.IdolatorQueuedGhost, npc.Position, RandomVector()*20, npc)
        ghost:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
    end

    local activeIdolator = false
    for _, idolator in pairs(Isaac.FindByType(FF.FF.Idolator.ID, FF.FF.Idolator.Var, -1, true)) do
        if not idolator:IsDead() then
            activeIdolator = true
            break
        end
    end

    if not activeIdolator then
        for doorSlot, _ in pairs(GREED_WALL_HOLES) do
            local doorSlotPos, direction, directionVector = GetGreedHoleInfo(doorSlot)
            local holePos = doorSlotPos + directionVector
            FF.SpawnWallHole(holePos, direction, true)
        end
        GREED_WALL_HOLES = {}
    end
end, FF.FF.Idolator.ID)

-- Calcs the target positions for the idolator ghosts floating around the edges of the room.
local function GetGhostOrbitPos(subType)
    local room = game:GetRoom()
    local topLeft = room:GetTopLeftPos()
    local bottomRight = room:GetBottomRightPos()
    local center = FF:Lerp(topLeft, bottomRight, 0.5)
    local radius = topLeft:Distance(bottomRight) * 0.5

    local rotateSpeed = 0.5
    local n = ((game:GetFrameCount() * rotateSpeed) % 360) + 360 * subType / 7
    local targetPos = center + Vector(radius, 0):Rotated(n)
    return room:GetClampedPosition(targetPos, -60) + RandomVector() * FF:RandomFloat(4)
end

-- When ghosts are spawned, assign them to any missing sins / make sure there are no duplicates.
FF:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, npc)
    if npc.Variant ~= FF.FF.IdolatorGhost.Var then return end

    local idolators = {}
    for _, idolator in ipairs(Isaac.FindByType(FF.FF.Idolator.ID, FF.FF.Idolator.Var, -1, true)) do
        if idolator.SubType > 0 and not idolator:IsDead() then
            idolators[idolator.SubType] = true
        end
    end

    local ghostData = IDOLATOR_GHOSTS[npc.SubType]

    if not ghostData then
        -- Find a ghost that has not been spawned yet.
        for subType, tab in pairs(IDOLATOR_GHOSTS) do
            if not GhostExists(tab) and not idolators[subType] then
                ghostData = tab
                npc.SubType = subType
                break
            end
        end
    end

    if not ghostData or GhostExists(ghostData) or idolators[npc.SubType] then
        -- Do not spawn invalid or duplicate ghosts.
        npc:Remove()
        return
    end

    local spr = npc:GetSprite()
    spr:ReplaceSpritesheet(0, "gfx/bosses/idolator/boss_" .. ghostData.Name .. "ghost.png")
    spr:ReplaceSpritesheet(1, "gfx/bosses/idolator/boss_" .. ghostData.Name .. "ghost_trail.png")
    spr:LoadGraphics()
    ghostData.Ptr = EntityPtr(npc)

    npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
    npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

    spr:Play("Idle", true)

    if not (npc.SpawnerType == FF.FF.Idolator.ID and npc.SpawnerVariant == FF.FF.Idolator.Var) then
        -- Spawn off-screen unless ejected by Idolator.
        local pos = GetGhostOrbitPos(npc.SubType)
        npc.Position = pos + (pos - game:GetRoom():GetCenterPos()):Resized(200)
    end
end, FF.FF.IdolatorGhost.ID)

FF:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant ~= FF.FF.IdolatorGhost.Var then return end

    local ghostData = IDOLATOR_GHOSTS[npc.SubType]

    if not GhostExists(ghostData) then
        ghostData.Ptr = EntityPtr(npc)
    elseif npc.InitSeed ~= ghostData.Ptr.Ref.InitSeed then
        npc:Remove()
        return
    end

    -- Leave the room if no Idolators are present.
    -- Keep an arbitrary Idolator in Parent just so we don't have to constantly check for them.
    if not npc.Parent or not npc.Parent:Exists() then
        local idolators = Isaac.FindByType(FF.FF.Idolator.ID, FF.FF.Idolator.Var, -1, true)
        if #idolators > 0 then
            npc.Parent = idolators[1]
        else
            local room = game:GetRoom()
            if npc.Position:Distance(room:GetClampedPosition(npc.Position, 0)) > 200 then
                -- Remove self when sufficiently out of the room.
                npc:Remove()
                return
            end
            -- Move away from the center of the room.
            local targetVel = (npc.Position - room:GetCenterPos()):Resized(8)
            npc.Velocity = FF:Lerp(npc.Velocity, targetVel, 0.1)
            return
        end
    end

    local data = FiendFolio:GetEntityData(npc)

    if data.IdolatorPossession then
        -- Handle possessing Idolator.
        if not ValidateIntentToPossess(data.IdolatorPossession.Ref, npc) then
            data.IdolatorPossession = nil
            return
        end
        local idolator = data.IdolatorPossession.Ref
        local sprite = npc:GetSprite()
        if sprite:IsPlaying("PossessionTell") then
            npc.Velocity = Vector(0, -1.5)
            return
        elseif sprite:IsFinished("PossessionTell") then
            FF:PlaySound(SoundEffect.SOUND_BEAST_GHOST_DASH, npc, 1.1, 0.8)
            sprite:Play("DashDown", true)
        end
        -- Fly towards Idolator
        local targetPos = idolator.Position + idolator.Velocity
        sprite.FlipX = targetPos.X > npc.Position.X
        local targetSpeed = 20
        local targetVel = (targetPos - npc.Position):Resized(targetSpeed)
        npc.Velocity = FF:Lerp(npc.Velocity, targetVel, 0.2)
    else
        -- Float around the edges of the room.
        local targetPos = GetGhostOrbitPos(npc.SubType)
        local targetSpeed = math.min(7, targetPos:Distance(npc.Position) * 0.33)
        local targetVel = (targetPos - npc.Position):Resized(targetSpeed)
        npc.Velocity = FF:Lerp(npc.Velocity, targetVel, 0.1)
    end
end, FF.FF.IdolatorGhost.ID)

-- Render the ghostly trail of the sin ghosts.
FF:AddCallback(ModCallbacks.MC_PRE_NPC_RENDER, function(_, npc)
    if npc.Variant ~= FF.FF.IdolatorGhost.Var then return end

    FF:RenderTrail(npc, {
        Spacing = 10,
        SpacingMult = 0.6,
        VelocitySpacing = 0.75,
        VelocitySpacingLimit = 6,
        VelocitySpacingLerp = 0.05,
        TrailAnim = "Trail",
        TrailOutlineAnim = "TrailOutline",
        Wiggle = {
            Speed = 1.0,
            Frequency = 1.0,
            Amount = {1.5, 2}
        },
        Pulse = {
            Speed = 1.0,
            Frequency = 1.0,
            Amount = {0.1, 0.2},
        },
    })
end, FF.FF.IdolatorGhost.ID)
