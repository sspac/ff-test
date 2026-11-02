local mod = FiendFolio
local game = Game()
local rng = RNG()
local sfx = SFXManager()

function mod:DrumstickAI(npc, sprite, data)
    if not data.Init then
        data.Params1 = ProjectileParams()
        data.Params1.Scale = 0.5
        data.Params1.HeightModifier = 10
        data.Params2 = ProjectileParams()
        data.Params2.Variant = 1
        data.Params2.FallingSpeedModifier = -20
        data.Params2.FallingAccelModifier = 1.5
        data.Cooldown = mod:RandomInt(15,45)

        if npc.Variant == mod.FF.HolyDrumstick.Var then
            npc.SplatColor = FiendFolio.ColorPureWhitePale
            data.Params1.Variant = 6
            data.Params2.BulletFlags = data.Params2.BulletFlags | ProjectileFlags.SMART
            data.Params2.CurvingStrength = 0.05
            data.Params2.FallingSpeedModifier = -10
            data.Params2.FallingAccelModifier = 0.5
        end
        data.Init = true
    end
    if npc.State == 8 and not (mod:isCharm(npc) or (npc.Target and mod:isBaited(npc.Target))) then
        if data.Cooldown > 0 then
            npc.State = 4
        end
    else
        data.Cooldown = data.Cooldown - 1
    end

    if npc.Variant == mod.FF.HolyDrumstick.Var and npc.FrameCount % 3 == 1 then
        local splat = Isaac.Spawn(1000, 7, 7, npc.Position, Vector.Zero, npc)
        splat.Color = FiendFolio.ColorPureWhitePale
        splat.SpriteScale = Vector(0.75,0.75)
        splat:Update()
    end

    if sprite:IsEventTriggered("TinyShoot") then
        if npc.Variant == mod.FF.HolyDrumstick.Var then
            local rand = npc:GetDropRNG():RandomInt(4) * 90
            for i = 90, 270, 90 do
                npc:FireProjectiles(npc.Position, Vector(6,0):Rotated(i + rand), 0, data.Params1)
            end
            npc:FireProjectiles(npc.Position, Vector(10,0):Rotated(rand), 0, data.Params1)
        else
            npc:FireProjectiles(npc.Position, Vector(6,0), 6, data.Params1)
        end
        local effect = Isaac.Spawn(1000, 2, 1, npc.Position - Vector(0,10), Vector.Zero, npc)
        effect.DepthOffset = npc.Position.Y * 1.25
        npc:PlaySound(SoundEffect.SOUND_ANIMAL_SQUISH, 1, 0, false, 1.5)
    elseif sprite:IsFinished("Attack") then
        data.Cooldown = mod:RandomInt(15,45)
    end
    if npc:IsDead() and mod:shouldDoDeathEffect(npc) then
        local targetpos = mod:confusePos(npc, npc:GetPlayerTarget().Position)
        mod:SetGatheredProjectiles()
        npc:FireProjectiles(npc.Position, (targetpos - npc.Position):Resized(5), 0, data.Params2)
        for _, bone in pairs(mod:GetGatheredProjectiles()) do
            local bs = bone:GetSprite()
            bs:Load("gfx/enemies/drumstick/projectile_tinybone.anm2", true)
            bs:Play("Move")
            if data.Burnt and npc.Variant ~= mod.FF.HolyDrumstick.Var then
                bs:ReplaceSpritesheet(0, "gfx/enemies/drumstick/projectile_tinybone_grilled.png")
                bs:LoadGraphics()
                mod:GetEntityData(bone).projType = "drumstickBone"
            elseif npc.Variant == mod.FF.HolyDrumstick.Var then
                bs:ReplaceSpritesheet(0, "gfx/enemies/drumstick/projectile_tinybone _holy.png")
                bs:LoadGraphics()
                mod:GetEntityData(bone).projType = "drumstickHomingBone"
            end
        end
        npc:PlaySound(SoundEffect.SOUND_PLOP, 0.7, 0, false, 1.5)
    end
end

function mod:DrumstickHurt(npc, amount, damageFlags, source)
    if mod:HasDamageFlag(DamageFlag.DAMAGE_FIRE, damageFlags) and not game:GetRoom():HasWater() then
        mod:GetEntityData(npc).Burnt = true
        npc:Kill()
    end
end

function mod:DrumstickBoneProjectile(projectile, data)
    if projectile.FrameCount % 3 == 0 then
        local trail = Isaac.Spawn(1000, 111, 0, projectile.Position, Vector.Zero, projectile):ToEffect()
        trail.Color = Color(0.95,1,0.2,1,0.3,0.5,0)
        trail.SpriteScale = Vector(0.3,0.3)
        trail.SpriteOffset = Vector(0, projectile.Height * 0.75)
        trail.DepthOffset = -80
        trail:Update()
    end
end
function mod:DrumstickHomingBoneProjectile(projectile, data)
    projectile.Color = mod.ColorNormal
    if projectile:IsDead() then
        projectile.Color = Color(0.87,0.61,0.3,1,0,0,0)
    end
end

function mod:DrumstickBoneDeath(projectile, data)
    local fire = Isaac.Spawn(33, 10, 0, projectile.Position, Vector.Zero, projectile)
    fire.HitPoints = fire.HitPoints / 2
    fire:Update()
end

function mod:HolyDrumstickBloodSplat(t, v, s, po, ve, sp, se)
    if s ~= 7 then
		if sp and sp.Type == mod.FF.HolyDrumstick.ID and sp.Variant == mod.FF.HolyDrumstick.Var then
            return {1000,0,999,se}
        end
    end
end