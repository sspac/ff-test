local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local bal = {
    spawnCap = 3,
    leechDist = {80,160},
    maxDiveDist = 240,
    projSpeed = {7,10},
    fountainDuration = 45,
}

function mod:BlubbieAI(npc, sprite, data)
    local rng = npc:GetDropRNG()

    if npc.State == 4 then --Idle
        if mod.GetEntityCount(EntityType.ENTITY_SMALL_LEECH) >= mod.GetEntityCount(mod.FF.Blubbie.ID, mod.FF.Blubbie.Var) * bal.spawnCap then
            npc.ProjectileCooldown = math.max(npc.ProjectileCooldown, 45)
        end

    elseif npc.State == 8 then --Spawning
        if sprite:IsEventTriggered("BlubbieShoot") then
            local spawnPos = mod:FindSafeSpawnSpot(npc.Position, bal.leechDist[1], bal.leechDist[2], true, false, true)
            local leech = EntityNPC.ThrowSpider(npc.Position, npc, spawnPos, false, mod:RandomInt(-90,-50,rng))
            leech:ToNPC():Morph(EntityType.ENTITY_SMALL_LEECH, 0, 0, -1)  
            mod:PlaySound(SoundEffect.SOUND_WORM_SPIT, npc)
            mod:PlaySound(SoundEffect.SOUND_MEAT_JUMPS, npc, 1.0, 0.75)
            local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 2, npc.Position, npc.Velocity * 0.75, npc)
            poof.PositionOffset = npc:GetNullOffset("EffectPos")
            poof.DepthOffset = 80
            if data.FFGRACESkin and FFGRACE then
                poof.Color = mod:CloneColor(FFGRACE.ColorBoilerBlood, 0.5)
            else
                local isPoop = mod:CheckStage("Dross", {"45"})
                poof.Color = mod:CloneColor(isPoop and mod.ColorPoop or mod.ColorSolidWater, isPoop and 0.75 or 0.5)
            end
            poof:Update()
        end

    elseif npc.State == 16 then --Divebomb
        if sprite:WasEventTriggered("BlubbieShoot") then
            npc.Velocity = mod:Lerp(npc.Velocity, npc.V1, 0.5)
        else
            npc.Velocity = npc.Velocity * 0.5
        end
    
        if sprite:IsFinished("Death") then
            FiendFolio.BlubbieDeathEffect(npc)
            mod:PlaySound(SoundEffect.SOUND_DEATH_BURST_LARGE, npc)
            npc:Kill()
        elseif sprite:IsEventTriggered("Sound") then
            mod:PlaySound(SoundEffect.SOUND_FAT_WIGGLE, npc)
        elseif sprite:IsEventTriggered("BlubbieShoot") then
            local attackVec = npc:GetPlayerTarget().Position - npc.Position
            if attackVec:Length() > bal.maxDiveDist then
                attackVec = attackVec:Resized(bal.maxDiveDist)
            end
            npc.V1 = attackVec / 20
            npc.Velocity = npc.V1
            Isaac.Spawn(mod.FF.LargeWaterRipple.ID, mod.FF.LargeWaterRipple.Var, mod.FF.LargeWaterRipple.Sub, npc.Position, Vector.Zero, npc)
            mod:PlaySound(SoundEffect.SOUND_BOSS2INTRO_WATER_EXPLOSION, npc, 1.3, 0.5)
            mod:PlaySound(SoundEffect.SOUND_FETUS_JUMP, npc)
        else
            mod:SpritePlay(sprite, "Death")
        end
    end
end

function FiendFolio.BlubbieDeathAnim(npc)
	local onCustomDeath = function(npc, deathAnim)
        deathAnim.State = 16
    end
    FiendFolio.genericCustomDeathAnim(npc, "Death", true, onCustomDeath, false, false, true, false)
end

function FiendFolio.BlubbieDeathEffect(npc)
	local params = ProjectileParams()
    params.Variant = mod:CheckStage("Dross", {"45"}) and ProjectileVariant.PROJECTILE_PUKE or ProjectileVariant.PROJECTILE_TEAR
    npc:FireProjectiles(npc.Position, Vector(bal.projSpeed[1],0), ProjectileMode.CROSS, params)
    npc:FireProjectiles(npc.Position, Vector(bal.projSpeed[2],0), ProjectileMode.PLUS, params)
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BIG_SPLASH, 0, npc.Position, Vector.Zero, npc)
    table.insert(mod.TearFountains, {["Duration"] = bal.fountainDuration, ["Spawner"] = npc, ["Params"] = params})
end