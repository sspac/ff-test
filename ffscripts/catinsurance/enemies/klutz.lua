local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local klutz = {}
local klutzIdVar = mod.FF.Klutz

local purple = Color(0,0,0,0.5,20/255, 0, 40/255)

local Settings = {
    DASH_SPEED = 10.4,
    IDLE_TIME = 50,
    DASH_TIME = 25,
    DASH_DELAY = 14,
    DASH_COUNT = 3,
    POSSESSION_TIME = 60,
    STUN_TIMER = 70,
    DASH_END_TIMER = 50,
    BEHIND_DISTANCE = 12,
    IDLE_SPEED = 2,
    TURN_AMOUNT = 3,
    TURN_HOMING_CURVE = 0.15,
    RESISTANCE_STRENGTH = 0.215,
    TRAIL_WAVY_MULT = 3,
    TRAIL_MAX_LENGTH = 30,
    WALK_SPEED = 5,
}

local HAZARDOUS_GRIDS = {
    [GridEntityType.GRID_FIREPLACE] = true,
    [GridEntityType.GRID_ROCK_SPIKED] = true,
    [GridEntityType.GRID_SPIKES] = true,
    [GridEntityType.GRID_SPIKES_ONOFF] = true,
}

-- Name of custom grid and the condition in which they'll be targeted
local HAZARDOUS_GRIDS_STAGEAPI = {
    ["FFTotemSpikesRed"] = function (customGrid)
        return customGrid.Data.Poking
    end,
    ["FFTotemSpikesBlue"] = function (customGrid)
        return customGrid.Data.Poking
    end
}

-- Prioritizes grids by distance, then enemies by distance
---@param position Vector
local function getClosestHazards(position)
    local validPositions = {}
    local room = game:GetRoom()
    for i = 0, room:GetGridSize() - 1 do
        local grid = room:GetGridEntity(i)
        local customGrid = StageAPI.GetCustomGrid(i)
        if grid or customGrid then
            local gridPosition = room:GetGridPosition(i)
            local pass = false
            if customGrid and HAZARDOUS_GRIDS_STAGEAPI[customGrid.GridConfig.Name] and HAZARDOUS_GRIDS_STAGEAPI[customGrid.GridConfig.Name](customGrid) then
                pass = true
            elseif HAZARDOUS_GRIDS[grid:GetType()] then
                pass = true
            end

            if pass then
                validPositions[#validPositions+1] = gridPosition
            end
        end
    end

    if #validPositions > 0 then
        table.sort(validPositions, function (a, b)
            return a:DistanceSquared(position) < b:DistanceSquared(position)
        end)
        return validPositions
    else
        -- Return enemy
        for _, entity in ipairs(Isaac.GetRoomEntities()) do
            if entity:IsActiveEnemy() and entity:IsVulnerableEnemy() then
                validPositions[#validPositions+1] = entity.Position
            end
        end

        if #validPositions > 0 then
            table.sort(validPositions, function (a, b)
                return a:DistanceSquared(position) < b:DistanceSquared(position)
            end)
            return validPositions
        else
            return {room:GetCenterPos()}
        end
    end
end

---@param npc EntityNPC
function mod:KlutzInit(npc)
    local data = mod:GetEntityData(npc)
    data.KlutzCountdown = Settings.IDLE_TIME
    data.KlutzDashCount = Settings.DASH_COUNT

    npc:AddEntityFlags(EntityFlag.FLAG_NO_SPIKE_DAMAGE)
    npc.SplatColor = purple
    npc:GetSprite():Play("Idle", true)
end

---@param npc EntityNPC
function mod:KlutzUpdate(npc)
    local sprite = npc:GetSprite()
    local target = npc:GetPlayerTarget()
    local data = mod:GetEntityData(npc)
    local hasFear = npc:HasEntityFlags(EntityFlag.FLAG_FEAR)
    local hasConfusion = npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION)

    if mod:isFriend(npc) then
        npc.CollisionDamage = 1
    end

    if npc.State == NpcState.STATE_INIT then
        npc.State = NpcState.STATE_IDLE
    end

    if npc.State == NpcState.STATE_IDLE then
        local direction = (target.Position - npc.Position):Resized(Settings.IDLE_SPEED)
        if hasFear then
            direction = (npc.Position - target.Position):Resized(Settings.IDLE_SPEED)
        end
        npc.Velocity = mod:Lerp(npc.Velocity, direction, 0.2)
        data.KlutzCountdown = math.max(data.KlutzCountdown - 1, 0)

        if data.KlutzCountdown == 0 and not hasConfusion and not hasFear then
            data.KlutzCountdown = Settings.DASH_TIME
            npc.State = NpcState.STATE_MOVE
            sprite:Play("MoveStartDown", true)
            data.KlutzDashCount = Settings.DASH_COUNT
            data.KlutzDashCooldown = Settings.DASH_DELAY
        end

    elseif npc.State == NpcState.STATE_MOVE then
        if sprite:IsFinished("MoveStartDown") and data.KlutzDashCooldown == 0 or sprite:IsPlaying("MoveLoopDown") then
            npc.StateFrame = 0
            sprite:Play("MoveLoopDown", true)
            data.KlutzCountdown = math.max(data.KlutzCountdown - 1, 0)
            local diff = target.Position - npc.Position
            npc.Velocity = mod:Lerp(npc.Velocity, diff:Resized(Settings.DASH_SPEED), Settings.TURN_HOMING_CURVE):Resized(Settings.DASH_SPEED)
            if data.KlutzCountdown == 0 then
                data.KlutzDashCount = data.KlutzDashCount - 1
                if data.KlutzDashCount > 0 then
                    data.KlutzCountdown = Settings.DASH_TIME
                    npc.State = NpcState.STATE_MOVE
                    data.KlutzDashCooldown = Settings.DASH_DELAY
                    sprite:Play("MoveStartDown", true)
                else
                    npc.State = NpcState.STATE_STOMP
                    data.KlutzCountdown = Settings.DASH_END_TIMER
                    sprite:Play("Idle", true)
                    data.KlutzDashCooldown = nil
                    data.KlutzDashCount = Settings.DASH_COUNT
                end
            end
        else
            npc.StateFrame = 1
            npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.25)
            if data.KlutzDashCooldown then
                data.KlutzDashCooldown = math.max(data.KlutzDashCooldown - 1, 0)
                if data.KlutzDashCooldown == 0 then
                    sfx:Play(SoundEffect.SOUND_CUTE_GRUNT)
                end
            end

        end

        if hasFear or hasConfusion then
            npc.State = NpcState.STATE_STOMP
            data.KlutzCountdown = Settings.DASH_END_TIMER
            sprite:Play("Idle", true)
            data.KlutzDashCooldown = nil
            data.KlutzDashCount = Settings.DASH_COUNT
        end
    elseif npc.State == NpcState.STATE_SPECIAL then
        data.KlutzCountdown = math.max(data.KlutzCountdown - 1, 0)
        data.KlutzDashCooldown = nil
        data.KlutzDashCount = Settings.DASH_COUNT
        npc.StateFrame = 0

        if data.KlutzPossessing then
            local player = Isaac.GetPlayer(data.KlutzPossessing)
            npc.Position = player.Position
            npc.Velocity = Vector.Zero

            -- Semi-hacky way of using the pathfinder for the player
            local playerData = mod:GetEntityData(player)
            local hazards = getClosestHazards(player.Position)

            local foundValidHazard = false
            local finalHazardPos
            for _, hazardPos in ipairs(hazards) do
                local result = mod:CatheryPathFinding(npc, hazardPos, {
                    Speed = Settings.WALK_SPEED,
                    Accel = 0.1,
                    UseDirectPath = true,
                    GiveUp = false,
                    Threshold = player:IsFlying() and 3000 or 999, -- 999 is just enough to walk on spikes and pressure plates
                    IgnorePits = player:IsFlying(),
                })

                -- Failsafe, just go straight towards enemy
                if result ~= false then
                    playerData.PossessedPathfindingVector = npc.Velocity
                    finalHazardPos = hazardPos
                    foundValidHazard = true
                    break
                end
            end

            -- No hazards can be pathed to
            -- Just go straight towards the nearest one
            if not foundValidHazard then
                finalHazardPos = hazards[1]
                playerData.PossessedPathfindingVector = (hazards[1] - player.Position):Normalized()
            end

            if player.Position:Distance(finalHazardPos) < 7 then
                playerData.PossessedPathfindingVector = nil
            end

            npc.Velocity = Vector.Zero

            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
        end

        if data.KlutzCountdown == 0 or not data.KlutzPossessing then
            npc.Visible = true

            if data.KlutzPossessing then
                local possessedPlayerData = mod:GetEntityData(Isaac.GetPlayer(data.KlutzPossessing))
                possessedPlayerData.KlutzPossessed = nil
                Isaac.GetPlayer(data.KlutzPossessing):AddCacheFlags(CacheFlag.CACHE_COLOR, true)
                sfx:Play(SoundEffect.SOUND_PORTAL_SPAWN)
            end

            data.KlutzPossessing = nil
            npc.State = NpcState.STATE_STOMP
            data.KlutzCountdown = Settings.STUN_TIMER
            npc.Visible = true
            npc.Velocity = RandomVector() * 10
            mod:ClearTrailPath(npc)

            sprite:Play("StunLoop", true)
        end

    -- Stun state (just dashed a bunch or just left the player's body)
    elseif npc.State == NpcState.STATE_STOMP then
        data.KlutzCountdown = math.max(data.KlutzCountdown - 1, 0)
        npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.1)
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL

        if data.KlutzCountdown == 0 then
            data.KlutzCountdown = Settings.IDLE_TIME
            npc.State = NpcState.STATE_IDLE
            sprite:Play("Idle", true)
        end
    end

    sprite.FlipX = npc.Velocity.X < 0
end

---@param npc EntityNPC
function mod:KlutzPreRender(npc)
    if npc.State == NpcState.STATE_SPECIAL then return end
	local charging = npc.State == NpcState.STATE_MOVE

    mod:RenderTrail(npc, {
        SkipFirstPos = false,
        Spacing = 8,
        SpacingMult = 0.6,
        VelocitySpacing = 0.6,
        VelocitySpacingLimit = 9,
        VelocitySpacingLerp = 0.08,
        TrailAnim = "Trail",
        TrailOutlineAnim = "TrailOutline",
        RenderEntity = false,
        Wiggle = {
            Speed = 2.0,
            Frequency = 1.0,
            Amount = charging and {2, 4} or {1.5, 2},
        },
        Pulse = {
            Speed = 1.0,
            Frequency = 1.0,
            Amount = {0.1, 0.2},
        },
    })
end

---@param npc EntityNPC
---@param collider Entity
function mod:KlutzPostCollision(npc, collider)
    local player = collider:ToPlayer()
    if not player then return end

    local playerData = mod:GetEntityData(player)
    local npcData = mod:GetEntityData(npc)

    if not playerData.KlutzPossessed
    and not npcData.KlutzPossessing
    and npc.State == NpcState.STATE_MOVE
    and npc:GetSprite():GetAnimation() ~= "MoveStartDown"
    and npc.StateFrame == 0 
    and not mod:isFriend(npc) then
        npcData.KlutzPossessing = player:GetPlayerIndex()
        npcData.KlutzCountdown = Settings.POSSESSION_TIME
        playerData.KlutzPossessed = EntityPtr(npc)
        player:AddCacheFlags(CacheFlag.CACHE_COLOR, true)

        npc.State = NpcState.STATE_SPECIAL
        npc.Visible = false
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

        --fx

        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 1, collider.Position, Vector.Zero, npc)
        sfx:Play(SoundEffect.SOUND_BLACK_POOF)
    end
end

---@param ent Entity
function mod:KlutzCancelControlPlayer(ent, data)
    if data.KlutzPossessed and data.KlutzPossessed.Ref then
        local ptr = data.KlutzPossessed.Ref
        mod:GetEntityData(ptr).KlutzPossessing = nil

        sfx:Play(SoundEffect.SOUND_PORTAL_SPAWN)
    end

    data.KlutzPossessed = nil
    ent:ToPlayer():AddCacheFlags(CacheFlag.CACHE_COLOR, true)
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, ent, amount, flags, src, frames)
    
    local data = mod:GetEntityData(ent)
    if data.KlutzPossessed and flags & DamageFlag.DAMAGE_CLONES == 0 then
        ent:TakeDamage(amount, flags | DamageFlag.DAMAGE_CLONES, EntityRef(data.KlutzPossessed.Ref), frames)
        mod:KlutzCancelControlPlayer(ent, data)
        return false
    end

    mod:KlutzCancelControlPlayer(ent, data)

end, EntityType.ENTITY_PLAYER)

function mod:KlutzCancelControlAllPlayer()
    for _, player in ipairs(PlayerManager.GetPlayers()) do
        mod:KlutzCancelControlPlayer(player, mod:GetEntityData(player))
    end
end

function mod:KlutzCancelHazardDamage(ent, _, flags, source)
    if flags & DamageFlag.DAMAGE_SPIKES == DamageFlag.DAMAGE_SPIKES then
        return false
    end

    if flags & DamageFlag.DAMAGE_POOP == DamageFlag.DAMAGE_POOP then
        return false
    end

    if flags & DamageFlag.DAMAGE_FIRE == DamageFlag.DAMAGE_FIRE then
        return false
    end

    if source.Type == 0 and source.Variant == GridEntityType.GRID_ROCK_SPIKED then
        return false
    end
end

---@param player EntityPlayer
function mod:KlutzResistMovement(player, data)
    if data.KlutzPossessed then
        -- Let the player resist
        local input = Vector(0, 0)
        if Input.IsActionPressed(ButtonAction.ACTION_LEFT, player.ControllerIndex) then
            input.X = -1
        elseif Input.IsActionPressed(ButtonAction.ACTION_RIGHT, player.ControllerIndex) then
            input.X = 1
        end

        if Input.IsActionPressed(ButtonAction.ACTION_UP, player.ControllerIndex) then
            input.Y = -1
        elseif Input.IsActionPressed(ButtonAction.ACTION_DOWN, player.ControllerIndex) then
            input.Y = 1
        end

        if input:Length() > 1e-3 then
            player:AddVelocity(Vector.FromAngle(input:GetAngleDegrees()):Resized(Settings.RESISTANCE_STRENGTH))
        end

        if player.FrameCount % 5 == 0 then
            -- FX (spawning this in the same callback causes flashing)
            Isaac.CreateTimer(function()
                local dust = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, 0, player.Position - Vector(0, 30), Vector(mod:RandomFloat(-3.75, 3.75), -5), nil):ToEffect()
                dust.Color = Color(0.8, 0.5, 0.8)
                dust.SpriteScale = Vector.One * 0.9
                dust.Timeout = 10
                dust.LifeSpan = 10
                dust.DepthOffset = -10000
                dust:Update()
            end, 1, 1, false)
        end

        if not data.KlutzPossessed.Ref then
            mod:KlutzCancelControlPlayer(player, data)
        end
    end
end

---@param player EntityPlayer
function mod:KlutzControlPlayer(player, data, hook, action)
    if not data.KlutzPossessed then
        return
    end

    -- Get the inputs required to move in the direction we need.
    local dirVec = data.PossessedPathfindingVector

    if not dirVec or dirVec:Length() < 1e-3 then
        return
    end

    local percentages = {
        [ButtonAction.ACTION_DOWN] = dirVec:Dot(Vector(0, 1)),
        [ButtonAction.ACTION_LEFT] = dirVec:Dot(Vector(-1, 0)),
        [ButtonAction.ACTION_RIGHT] = dirVec:Dot(Vector(1, 0)),
        [ButtonAction.ACTION_UP] = dirVec:Dot(Vector(0, -1))
    }

    local t = percentages[action]
    if t then
        if hook == InputHook.GET_ACTION_VALUE then
            if t < -1 then
                return -1
            elseif t > 1 then
                return 1
            else
                return t
            end
        else
            local highestNum, a
            for i, v in pairs(percentages) do
                if not a or v > a then
                    highestNum = i
                    a = v
                end
            end

            if highestNum and highestNum == action then
                return true
            end
        end
    end
end

mod:AddCallback("FF_PLAYER_INPUT_ACTION", mod.KlutzControlPlayer)

---@param player EntityPlayer
function klutz:TintPlayer(player)
    if mod:GetEntityData(player).KlutzPossessed then
        local cloneColor = Color()
        Color.Lerp(cloneColor, player.Color, 1)
        cloneColor:SetTint(0.8, 0.5, 0.8, 1)
        player.Color = cloneColor
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, klutz.TintPlayer, CacheFlag.CACHE_COLOR)