local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local bal = {
    speedMult = 0.6,
    shootCooldown = {30,60},
    wiggleProjRate = 6,
    wiggleSpeed = 9,
    wiggleWaveLength = 0.25,
    wiggleAmplitude = 45,
    spreadAngles = {40,70},
    spreadSpeed = 12,
}

local wiggleParams = ProjectileParams()
wiggleParams.Color = mod.ColorWigglyMaggot
wiggleParams.FallingAccelModifier = -0.15
wiggleParams.BulletFlags = ProjectileFlags.NO_WALL_COLLIDE
wiggleParams.Scale = 0.8

local spreadParams = ProjectileParams()
spreadParams.Scale = 1.5

function mod:CarveCreepAI(npc, sprite, data)
    local rng = npc:GetDropRNG()

    if not data.Init then
        npc.SplatColor = mod.ColorTwitchyGibs
        data.Init = true
    end

    npc.Velocity = npc.Velocity * bal.speedMult

    if npc.State == 4 then
        if not data.SetCooldown then
            npc.StateFrame = math.floor(mod:RandomInt(bal.shootCooldown[1], bal.shootCooldown[2], rng)/2)
            data.SetCooldown = true
        end
    elseif npc.State == 8 then
        if sprite:IsEventTriggered("StartShoot") then
            mod:PlaySound(SoundEffect.SOUND_BOSS_LITE_HISS, npc)
        elseif sprite:IsEventTriggered("StopShoot") then
            for _, angle in pairs(bal.spreadAngles) do
                npc:FireProjectiles(npc.Position, Vector(0,bal.spreadSpeed):Rotated(npc.SpriteRotation + angle), 0, spreadParams)
                npc:FireProjectiles(npc.Position, Vector(0,bal.spreadSpeed):Rotated(npc.SpriteRotation - angle), 0, spreadParams)
            end
            mod:PlaySound(SoundEffect.SOUND_HEARTOUT, npc)
            mod:PlaySound(SoundEffect.SOUND_SMB_LARGE_CHEWS_4, npc, 0.75, 0.75)
            data.SetCooldown = false
        end

        if npc.FrameCount % bal.wiggleProjRate == 0 and (sprite:WasEventTriggered("StartShoot") and not sprite:WasEventTriggered("StopShoot")) then
            local vel = Vector(0,bal.wiggleSpeed):Rotated(npc.SpriteRotation)
            for i, proj in pairs(mod:FireProjectiles(npc, npc.Position, vel, 1, wiggleParams)) do
                local d = mod:GetEntityData(proj)
				d.projType = "CarveCreep"
                d.CarveCreepYAxis = (npc.SpriteRotation % 180 == 0)
                d.CarveCreepVel = vel
                d.CarveCreepInitAxis = (d.CarveCreepYAxis and npc.Position.X or npc.Position.Y)
                d.CarveCreepReverseSine = (i == 2)
            end
            mod:PlaySound(SoundEffect.SOUND_BLOODSHOOT, npc, 0.8, 0.75)
            for i = 0, bal.wiggleProjRate/2, bal.wiggleProjRate/2 do
                mod.scheduleForUpdate(function()
                    local eff = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 1, npc.Position - Vector(0,10):Rotated(npc.SpriteRotation), vel:Rotated(mod:RandomInt(-45,45)):Resized(mod:RandomInt(3,10)), npc)
                    eff.Color = Color(0.5,0.75,0.5,0.85)
                    local scale = mod:RandomInt(50,100) * 0.01
                    eff.SpriteScale = Vector(scale,scale)
                    eff.DepthOffset = 80
                    eff:Update()
                end, i)
            end
        end
    end
end

function mod:CarveCreepProjectile(proj, data)
    local frame = proj.FrameCount
    local val = math.sin(frame * bal.wiggleWaveLength) * bal.wiggleAmplitude
    if data.CarveCreepReverseSine then
        val = -val
    end
    local targetpos 
    if data.CarveCreepYAxis then
        targetpos = Vector(data.CarveCreepInitAxis + val, proj.Position.Y) + data.CarveCreepVel
    else
        targetpos = Vector(proj.Position.X, data.CarveCreepInitAxis + val) + data.CarveCreepVel
    end
    proj.Velocity = targetpos - proj.Position
end