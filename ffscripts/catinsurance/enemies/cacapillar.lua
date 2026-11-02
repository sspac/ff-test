local mod = FiendFolio
local game = Game()

local Settings = {
    DashSpeed = 12,
    ShortMoveSpeed = 6.5,
    DashLength = 70,
    DashFriction = 0.975,
    ShortMoveFriction = 0.8,
    TearDelayMin = 10,
    TearDelayMax = 25,
    TearSpeedMin = 4,
    TearSpeedMax = 7,
    DashCooldown = 35,
    DeathPuddleScale = 4,
    DeathPuddleDelay = 120,
    CreepSpawnDelay = 4,
    CreepPuddleDelay = 80,
    DashBelowAngle = 25
}

local params = ProjectileParams()
params.Variant = ProjectileVariant.PROJECTILE_PUKE

---@param npc EntityNPC
function mod:CacapillarUpdate(npc)
    local sprite = npc:GetSprite()
    local room = game:GetRoom()
    local target = npc:GetPlayerTarget()
   
    npc.StateFrame = math.max(npc.StateFrame - 1, 0)
    if npc.State == NpcState.STATE_INIT then
        npc.State = NpcState.STATE_MOVE
        npc.StateFrame = Settings.DashCooldown
        npc.SplatColor = mod.ColorPoop
    end

    if npc.State == NpcState.STATE_MOVE then
        if not sprite:IsPlaying() then
            npc.Pathfinder:FindGridPath(target.Position, 1, 900, false)

            local canSee = room:CheckLine(npc.Position, target.Position, LineCheckMode.RAYCAST)
            local direction = FiendFolio.GetCardinal(npc.Velocity:Normalized())
            local angle = math.abs(direction:GetAngleDegrees() - (target.Position - npc.Position):GetAngleDegrees())

            npc:PlaySound(mod.Sounds.WormScoot, 0.2, 0, false, math.random(97,103)/100)

            if not mod:isScareOrConfuse(npc) and canSee and angle < Settings.DashBelowAngle and npc.StateFrame == 0 then
                if direction.X > 0 then
                    sprite:Play("MoveRightStart", true)
                elseif direction.X < 0 then
                    sprite:Play("MoveLeftStart", true)
                elseif direction.Y > 0 then
                    sprite:Play("MoveDownStart", true)
                else
                    sprite:Play("MoveUpStart", true)
                end

                npc.V1 = direction
                npc.State = NpcState.STATE_ATTACK
            else
                npc:AddVelocity(direction:Resized(Settings.ShortMoveSpeed))
                if direction.X > 0 then
                    sprite:Play("MoveRightShort", true)
                elseif direction.X < 0 then
                    sprite:Play("MoveLeftShort", true)
                elseif direction.Y > 0 then
                    sprite:Play("MoveDownShort", true)
                else
                    sprite:Play("MoveUpShort", true)
                end
            end
        end

        npc.Velocity = npc.Velocity * Settings.ShortMoveFriction
        
    elseif npc.State == NpcState.STATE_ATTACK then
        if sprite:IsFinished() and npc.I1 == 0 then
            npc.StateFrame = Settings.DashLength
            npc.I1 = 1
            npc.I2 = 0
            npc:AddVelocity(npc.V1:Resized(Settings.DashSpeed))
            npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)

            npc:PlaySound(SoundEffect.SOUND_MAGGOTCHARGE)
        elseif npc.I1 == 0 then
            npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.2)
        end

        local cardinal = mod.GetCardinal(npc.Velocity)
        if npc.I1 == 1 then
            if cardinal.X > 0 then
                mod:spritePlay(sprite, "MoveRightLoop")
            elseif cardinal.X < 0 then
                mod:spritePlay(sprite, "MoveLeftLoop")
            elseif cardinal.Y > 0 then
                mod:spritePlay(sprite, "MoveDownLoop")
            else
                mod:spritePlay(sprite, "MoveUpLoop")
            end
        end

        -- Shoot to sides
        npc.I2 = npc.I2 - 1
        if npc.I2 <= 0 and npc.I1 == 1 then
            local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 1, npc.Position, Vector.Zero, npc)
            poof.Color = mod.ColorPoop

            -- Get the progress to the end of the dash
            local progress = (npc.StateFrame / Settings.DashLength)

            -- Get tear speed
            local speedDiff = Settings.TearSpeedMax - Settings.TearSpeedMin
            local tearSpeed = Settings.TearSpeedMax - (1 - progress) * speedDiff
            for angle = -90, 90, 180 do
                npc:FireProjectiles(npc.Position, cardinal:Rotated(angle):Resized(tearSpeed), ProjectileMode.SINGLE, params)
            end


            -- Get the tear delay
            local tearDelayDiff = Settings.TearDelayMax - Settings.TearDelayMin
            local tearDelay = Settings.TearDelayMin + (1 - progress) * tearDelayDiff
            npc.I2 = math.floor(tearDelay)
        end

        npc.Velocity = npc.Velocity * Settings.DashFriction

        if npc.StateFrame == 0 and npc.I1 == 1 then
            npc.I1 = 0
            npc.State = NpcState.STATE_MOVE
            npc.StateFrame = Settings.DashCooldown
            sprite:Stop()
            npc:ClearEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
        end
    end

    if npc.FrameCount % Settings.CreepSpawnDelay == 0 then
        local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_SLIPPERY_BROWN, 0, npc.Position, Vector.Zero, nil):ToEffect()
        creep:SetTimeout(Settings.CreepPuddleDelay)
        creep:Update()
    end
end

function mod:CacapillarDeath(npc)
	if mod:shouldDoDeathEffect(npc) then
		local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_SLIPPERY_BROWN, 0, npc.Position, Vector.Zero, nil):ToEffect()
		creep.SpriteScale = Vector.One * Settings.DeathPuddleScale
		creep:SetTimeout(Settings.DeathPuddleDelay)
		creep:Update()
	end
end