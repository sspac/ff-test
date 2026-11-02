local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local bal = {
    speedMult = 0.9,
    explosionResistance = 0.33,
    laserResistance = 0.25,
}

local params1 = ProjectileParams()

local params2 = ProjectileParams()
params2.Color = mod.ColorIpecacProper
params2.Scale = 1.5
params2.FallingSpeedModifier = -20
params2.FallingAccelModifier = 0.8
params2.BulletFlags = ProjectileFlags.EXPLODE

local params3 = ProjectileParams()
params3.Color = mod.ColorDankBlackReal

local params4 = ProjectileParams()
params4.Variant = ProjectileVariant.PROJECTILE_TEAR
params4.Spread = 1.5

function mod:PartyballPreUpdate(npc, sprite, data)
    if npc.State == 8 then
        npc.Velocity = Vector.Zero
        if sprite:IsFinished("Death") then
            if npc.CanShutDoors then
                mod:KeepDoorsClosed(100)
            end
            mod.PartyballDeathEffect(npc)
            npc:Kill()
        else
            mod:spritePlay(sprite, "Death")
        end
        return true
    end
end

function mod:PartyballAI(npc, sprite, data)
    local rng = npc:GetDropRNG()

    if npc.State ~= 8 then
        npc.Velocity = npc.Velocity * bal.speedMult
        if rng:RandomFloat() <= 0.1 then
            local sparkle = Isaac.Spawn(EntityType.ENTITY_EFFECT, 7003, 0, npc.Position, -npc.Velocity:Rotated(mod:RandomInt(-20,20,rng)), npc)
            sparkle.Color = mod:RandomColor(0, 0.5, 0.15, rng)
            sparkle.RenderZOffset = -5
            sparkle.SpriteOffset = Vector(0,-10)
            sparkle:Update()
        end
    end
end

function mod:PartyballHurt(npc, amount, damageFlags, source)
    if (
        not (mod:HasDamageFlag(damageFlags, DamageFlag.DAMAGE_CLONES) or mod:IsPlayerDamage(source))
        and not (mod:isFriend(npc) or mod:isCharm(npc)) -- dont let it have infinite health as a friendly enemy
    ) then
        if mod:HasDamageFlag(damageFlags, DamageFlag.DAMAGE_EXPLOSION) then
            npc:TakeDamage(amount * bal.explosionResistance, damageFlags | DamageFlag.DAMAGE_CLONES, source, 0)
        elseif mod:HasDamageFlag(damageFlags, DamageFlag.DAMAGE_LASER) then
            npc:TakeDamage(amount * bal.laserResistance, damageFlags | DamageFlag.DAMAGE_CLONES, source, 0)
        end

        return false
    end
end

function mod.PartyballDeathEffect(npc)
    local rng = npc:GetDropRNG()
    local targetpos = mod:confusePos(npc, npc:GetPlayerTarget().Position)

    mod:PlaySound(SoundEffect.SOUND_PLOP, npc, 0.8)
    mod:PlaySound(SoundEffect.SOUND_DEATH_BURST_LARGE, npc, 2)
    mod:PlaySound(mod.Sounds.MurasaSparkle, npc, 0.8, 0.5)

    for i = 1, 5 do
        local splat = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_SPLAT, 0, (npc.Position + RandomVector() * mod:RandomInt(0,20,rng)), Vector.Zero, npc)
        splat.Color = mod:RandomColor(0.1, 0.5, 0.8, rng)
        splat:Update()
    end
    for i = 1, 8 do
        local gib = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_PARTICLE, 0, npc.Position, RandomVector() * mod:RandomInt(2,6,rng), npc)
        gib.Color = mod:RandomColor(0.1, 0.5, 1, rng)
        gib:Update()
    end
    for i = 1, 10 do
        local sparkle = Isaac.Spawn(EntityType.ENTITY_EFFECT, 7003, 0, npc.Position, RandomVector() * mod:RandomInt(10,20,rng), npc)
        sparkle.Color = mod:RandomColor(0, 0.5, 1, rng)
        sparkle.SpriteOffset = Vector(0,-10)
        sparkle:Update()
    end

    --Sucker
    npc:FireProjectiles(npc.Position, Vector(10,0), 6, params1) 

    --Ink
    npc:FireProjectiles(npc.Position, Vector(10,0), 7, params3) 
    local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_BLACK, 0, npc.Position, Vector.Zero, npc):ToEffect()
    creep:SetTimeout(450)
    creep.SpriteScale = Vector(3,3)

    --Mayfly
    npc:FireProjectiles(npc.Position, (targetpos - npc.Position):Resized(10), 1, params4)

    --Spitroast
    mod:PlaySound(mod.Sounds.FireFizzle, npc, 1.3)
    for i = 36, 360, 36 do
        local fire = Isaac.Spawn(EntityType.ENTITY_EFFECT, 7005, 1, npc.Position, Vector(8,0):Rotated(i), npc)
        fire:Update()
    end

    local orb = Isaac.Spawn(mod.FF.PartyOrb.ID, mod.FF.PartyOrb.Var, mod.FF.PartyOrb.Sub, npc.Position, Vector.Zero, npc)
    mod:GetEntityData(orb).Partyball = npc
end

function mod.PartyballDeathAnim(npc)
    local onCustomDeath = function(npc, deathAnim)
        deathAnim.State = 8
    end
    FiendFolio.genericCustomDeathAnim(npc, "Death", true, onCustomDeath)
end

function mod:PartyOrb(effect, sprite, data)
    effect.SpriteOffset = Vector(0,-5)

    if sprite:IsFinished("Shoot") then
        effect:Remove()

    --Spit
    elseif sprite:IsEventTriggered("Spit") then
        if data.Partyball then
            data.Partyball:FireProjectiles(effect.Position, (data.Partyball:GetPlayerTarget().Position - effect.Position):Resized(5), 0, params2) 
        end
        mod:PlaySound(SoundEffect.SOUND_HEARTOUT)

    --Volt
    elseif sprite:IsEventTriggered("Volt") then
		for i = mod:RandomInt(0,72), 360, 72 do
			local laser = Isaac.Spawn(EntityType.ENTITY_EFFECT, 1737, 0, effect.Position, Vector.FromAngle(i):Resized(7), data.Partyball):ToEffect()
			mod:GetEntityData(laser).delay = 20
			mod:GetEntityData(laser).timeout = 8
			mod:GetEntityData(laser).DoesntPush = true
			laser.Parent = data.Partyball
			laser.Color = Color(0,0,0,1,0.7,0.8,1)
            laser:Update()
		end
        mod:PlaySound(SoundEffect.SOUND_LASERRING_WEAK)

    --Soul Sucker
    elseif sprite:IsEventTriggered("SoulSucker") then
        local swirl = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ENEMY_BRIMSTONE_SWIRL, 0, effect.Position, Vector.Zero, data.Partyball)
        swirl.Parent = data.Partyball
        mod:PlaySound(SoundEffect.SOUND_FAMINE_BURST)
    end
end

function mod:KeepDoorsClosed(time)
    if not game:GetRoom():IsClear() then
        local doorCloser = Isaac.Spawn(mod.FF.DoorCloser.ID, mod.FF.DoorCloser.Var, 0, Vector(1000,1000), Vector.Zero, nil):ToNPC()
        doorCloser.I1 = time
    end
end

function mod:DoorCloserInit(npc)
    npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
    npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_HIDE_HP_BAR | EntityFlag.FLAG_NO_REWARD | EntityFlag.FLAG_NO_DEATH_TRIGGER)
    npc.Visible = false
    npc.SplatColor = mod.ColorInvisible
    npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
end

function mod:DoorCloserUpdate(npc, sprite, data)
    npc.Velocity = Vector.Zero
    if npc.FrameCount > npc.I1 then
        npc:Remove()
    end
end