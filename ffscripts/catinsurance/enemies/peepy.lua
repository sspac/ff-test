local mod = FiendFolio
local game = Game()

local Constants = {
    FRICTION = 0.6,
    ACCEL = 0.08,
    SPEED = 7,
    MAX_PLAYBACK_SPEED = 4,
    PUDDLE_FREQUENCY = 10,
    PUDDLE_TIMEOUT = 60,
    PUDDLE_SCALE = 1,
}

---@param npc EntityNPC
function mod:PeepyUpdate(npc)
    local target = npc:GetPlayerTarget()
    local sprite = npc:GetSprite()
    local pathfinder = npc:GetPathfinder()
    local data = mod:GetEntityData(npc)

    if npc.State == NpcState.STATE_INIT then
        npc.State = NpcState.STATE_MOVE
        npc.SplatColor = mod.ColorLemonYellow
        npc:AddEntityFlags(EntityFlag.FLAG_SLIPPERY_PHYSICS)
    end

    if npc.State == NpcState.STATE_MOVE then
        mod:spritePlay(sprite, "Walk")

        if mod:isConfuse(npc) then
            pathfinder:MoveRandomly(false)
        else
            local targetPos = mod:randomConfuse(npc, target.Position)
            if pathfinder:HasPathToPos(targetPos, false) then
                mod:CatheryPathFinding(npc, targetPos, {
                    Speed = Constants.SPEED,
                    Accel = Constants.ACCEL,
                    GiveUp = true,
                })
            end
        end

        -- anim speed
        local length = npc.Velocity:Length()
        if length > 0.25 then
            local playbackSpeed = (length / Constants.MAX_PLAYBACK_SPEED)
            playbackSpeed = mod:ClampNumber(playbackSpeed, 0.05, 3)
            sprite.PlaybackSpeed = playbackSpeed
        end

        -- spawn piss puddles
        if npc.FrameCount % Constants.PUDDLE_FREQUENCY == 0 then
            local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_YELLOW, 0, npc.Position, Vector.Zero, npc):ToEffect()
            creep.SpriteScale = Vector(Constants.PUDDLE_SCALE, Constants.PUDDLE_SCALE)
            creep.Timeout = Constants.PUDDLE_TIMEOUT
            creep:Update()
        end

        -- make sounds if hitting grid
        if npc:CollidesWithGrid() and not data.PeepyMadeSound then
            data.PeepyMadeSound = true
            npc:PlaySound(SoundEffect.SOUND_BABY_HURT)
        elseif not npc:CollidesWithGrid() then
            data.PeepyMadeSound = nil
        end
    end
   -- npc.Velocity = npc.Velocity * Constants.FRICTION
end