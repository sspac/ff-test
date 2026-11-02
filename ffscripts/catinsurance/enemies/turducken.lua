local mod = FiendFolio
local sfx = SFXManager()
local game = Game()

local Constants = {
    MoveSpeed = 3,
    AttackCooldown = 90,
    CircleSpeed = 10,
    SquareSpeed = 8,
    DiamondSpeed = 7.4,
    CircleCount = 10,
    MegaClottyCount = 7,
}

local patterns = {
    -- Circle (Dinga)
    [1] = function (npc, pos)
        local params = ProjectileParams()
        params.Variant = ProjectileVariant.PROJECTILE_PUKE
        npc:FireProjectiles(pos, Vector(Constants.CircleSpeed, Constants.CircleCount), ProjectileMode.CIRCLE_CUSTOM, params)

        local dip = Isaac.Spawn(EntityType.ENTITY_DIP, 0, 0, pos, RandomVector():Resized(15), npc)
        dip:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        dip:AddEntityFlags(EntityFlag.FLAG_AMBUSH)
    end,

    -- Mega Clotty (from the chunky code hi guwah)
    [2] = function (npc, pos)
        local params = ProjectileParams()

        local vel = Constants.DiamondSpeed
        for i = -vel/2, vel, vel/2 do
            npc:FireProjectiles(pos, Vector(i, vel), 0, params)
            npc:FireProjectiles(pos, Vector(i-(vel/2), -vel), 0, params)
            npc:FireProjectiles(pos, Vector(vel, i-(vel/2)), 0, params)
            npc:FireProjectiles(pos, Vector(-vel, i), 0, params) 
        end
    end,

    -- Diamond (MemBrain)
    [3] = function (npc, pos)
        local params = ProjectileParams()

        local vel = Constants.DiamondSpeed
        for i = -vel/2, vel, vel/2 do
            npc:FireProjectiles(pos, Vector(i, vel):Rotated(45), 0, params)
            npc:FireProjectiles(pos, Vector(i-(vel/2), -vel):Rotated(45), 0, params)
            npc:FireProjectiles(pos, Vector(vel, i-(vel/2)):Rotated(45), 0, params)
            npc:FireProjectiles(pos, Vector(-vel, i):Rotated(45), 0, params) 
        end

        local fixedPos = game:GetRoom():GetClampedPosition(pos, 20)
        local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, fixedPos, Vector.Zero, npc)
        creep.SpriteScale = Vector(3, 3)
        creep:ToEffect().Timeout = 120
        creep:Update()
    end
}

local function makeSplat(npc)
    local splat = npc:MakeSplat(math.random(40 * 1, 40 * 3))
    splat.Color = npc.SplatColor
end

---@param npc EntityNPC
function mod:TurduckenUpdate(npc)
    local sprite = npc:GetSprite()
    local rng = npc:GetDropRNG()
    local target = npc:GetPlayerTarget()
    local pathfinder = npc.Pathfinder

    npc.StateFrame = math.max(npc.StateFrame - 1, 0)
    if npc.State == NpcState.STATE_INIT then
        npc.State = NpcState.STATE_MOVE
        npc.StateFrame = Constants.AttackCooldown // 2
        npc.SplatColor = mod.ColorPoop
    end

    if npc.State == NpcState.STATE_MOVE then

        pathfinder:MoveRandomly(false)
        npc.Velocity = npc.Velocity * 0.85

        if npc.FrameCount % 75 == 0 then
            makeSplat(npc)
        end

        if npc.StateFrame == 0 and sprite:IsFinished("Wiggle") and not mod:isScareOrConfuse(npc) then
            sprite:Play("Attack", true)
            npc.State = NpcState.STATE_ATTACK
            npc.StateFrame = Constants.AttackCooldown
            return
        end

        if not sprite:IsPlaying("Wiggle") then
            sprite:Play("Wiggle", true)
        end
    
    elseif npc.State == NpcState.STATE_ATTACK then
        npc.Velocity = mod:Lerp(npc.Velocity, Vector(0, 0), 0.1)

        if sprite:IsFinished("Attack") then
            npc.State = NpcState.STATE_MOVE
            mod:spritePlay(sprite, "Wiggle")
        end

        if sprite:IsEventTriggered("Shoot") then

            -- Shoot big projectile that splits
            local pattern = rng:RandomInt(1, 3)
            local bigParams = ProjectileParams()
            bigParams.Scale = 2

            if pattern == 1 then
                bigParams.Variant = ProjectileVariant.PROJECTILE_PUKE
            end

            mod:SetGatheredProjectiles()
            patterns[pattern](npc, npc.Position)
            for _, gathered in ipairs(mod:GetGatheredProjectiles()) do
                gathered.FallingAccel = -0.05
            end

            local big = npc:FireProjectilesEx(npc.Position, (target.Position - npc.Position):Resized(Constants.CircleSpeed), ProjectileMode.SINGLE, bigParams)[1]
            local data = mod:GetEntityData(big)
            data.projType = "turducken"
            data.turduckenPattern = pattern
            big.FallingAccel = -0.05

            sfx:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS)
            makeSplat(npc)
        end
    end
end

function mod:TurduckenDeath(npc)
	if mod:shouldDoDeathEffect(npc) then
		Isaac.Spawn(EntityType.ENTITY_MEMBRAIN, 0, 0, npc.Position, RandomVector() * 10, npc)
		Isaac.Spawn(EntityType.ENTITY_MEGA_CLOTTY, 0, 0, npc.Position, RandomVector() * 10, npc)
		Isaac.Spawn(EntityType.ENTITY_DINGA, 0, 0, npc.Position, RandomVector() * 10, npc)
	end
end

function mod:TurduckenProjectileDeath(proj, data)
    if data.projType == "turducken" then
        local npc = proj.SpawnerEntity and proj.SpawnerEntity:ToNPC()
        if not npc then
            return
        end

        local pattern = data.turduckenPattern
        mod:SetGatheredProjectiles()
        patterns[pattern](npc, proj.Position)
        for _, gathered in ipairs(mod:GetGatheredProjectiles()) do
            gathered.FallingAccel = -0.05
        end
    end
end