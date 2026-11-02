local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local bal = {
    speed = 8,
    radSpeed = 5,
    chaseSpeed = 13.5,
    chaseShotInterval = 10,
    rotateAmt = 3,
    dmgReduction = 0.25,

    radRadius = 60,
    radDuration = 220,
}

local function IsFlashMaiden(npc)
	return npc and npc.Type == mod.FF.FlashMaiden.ID and npc.SubType == mod.FF.FlashMaiden.Sub
end

local function radialJets(pos, num, dist)
    for i=1,num do
        local vec = pos + Vector(0, 1*dist):Rotated((360/num)*i)
        local firejet = Isaac.Spawn(mod.FF.RadioactiveFireJet.ID, mod.FF.RadioactiveFireJet.Var, mod.FF.RadioactiveFireJet.Sub, vec, Vector.Zero, nil):ToEffect()
        firejet:Update()
    end
end

function mod:flashMaidenAI(npc, sprite, d)
    local rng = npc:GetDropRNG()
	local target = npc:GetPlayerTarget()
    local room = game:GetRoom()

    local confused = npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION)
    local feared = npc:HasEntityFlags(EntityFlag.FLAG_FEAR | EntityFlag.FLAG_SHRINK)

    if not d.init then
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
        npc.SplatColor = mod.ColorBobsGreen
        d.ffRadioactiveEnemy = true
        d.ffAbsorbRadiation = true

        d.randomNum = mod:RandomInt(1,20)
        
        d.targetVec = (target.Position-npc.Position)
        d.moveDir = 1
        d.swingAnim = "SwingRight_ref"
        d.state = -1
		d.init = true
	end

    if d.state == -1 then
        mod:SpritePlay(sprite,"Open")
        if sprite:IsPlaying("Open") then
            if sprite:IsEventTriggered("Shoot") then
                npc:PlaySound(SoundEffect.SOUND_ROCK_CRUMBLE)
                for i = 1, 5 do
                    local particle = Isaac.Spawn(1000, 4, 0, npc.Position, RandomVector()*mod:RandomInt(1,4), npc)
                    particle:Update()
                end
                local smoke = Isaac.Spawn(1000, EffectVariant.DUST_CLOUD, 0, npc.Position, Vector.Zero, npc):ToEffect()
                smoke:SetTimeout(15)
                smoke.SpriteOffset = Vector(0,-30)
                smoke.DepthOffset = 1
                smoke:Update()

                d.biggestRad = mod:RandomInt(5,15)
            end
        end
        if npc.FrameCount > 10 and sprite:IsFinished("Open") then
            d.state = 0
        end
        npc.Velocity = Vector.Zero
    elseif d.state == 0 then
        mod:SpritePlay(sprite,"Idle")
        d.targetVec = (target.Position-npc.Position)
        if  d.targetVec  then
            if confused then
                d.targetVec = d.targetVec:Rotated(mod:RandomInt(1,360))
            end
            if feared then
                d.targetVec = -d.targetVec
            end

            d.moveVec = d.targetVec:Resized(bal.speed)

            d.moveDir = 1
            if rng:RandomFloat() < 0.5 then
                d.moveDir = -1
            end

            d.swingAnim = "SwingRight_ref"
            if d.targetVec.X < 0 then
                d.swingAnim = "SwingLeft_ref"
            end
            d.state = 1
        end
        npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.2)
    elseif d.state == 1 then
        mod:SpritePlay(sprite,d.swingAnim)
        if sprite:WasEventTriggered("Shoot") and d.moveVec 
        and not sprite:WasEventTriggered("Stop") then
            local moveVec = d.moveVec
            if mod:IsEnemyExposedToRadiation(npc, false, d) then
                moveVec = moveVec:Resized(bal.radSpeed)
            end
            npc.Velocity = mod:Lerp(npc.Velocity, moveVec, 0.5)
            d.moveVec = d.moveVec:Rotated(bal.rotateAmt*d.moveDir)
        else
            npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.2)
        end

        if room:GetGridCollisionAtPos(npc.Position+(d.moveVec:Resized(50))) >= 4 then
            d.state = 0
        end

        if sprite:IsFinished(d.swingAnim) then
            d.state = 0
        end
    elseif d.state == 2 then
        mod:SpritePlay(sprite,"Transform")
        npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.2)

        if sprite:IsEventTriggered("Shoot") then
            npc:BloodExplode()

            npc:PlaySound(SoundEffect.SOUND_ROCK_CRUMBLE)
            npc:PlaySound(mod.Sounds.PollutionCharge, 1, 0, false, 1.5)
            for i = 1, 5 do
                local particle = Isaac.Spawn(1000, 4, 0, npc.Position, RandomVector()*mod:RandomInt(1,4), npc)
                particle:Update()
            end
            local smoke = Isaac.Spawn(1000, EffectVariant.DUST_CLOUD, 0, npc.Position, Vector.Zero, npc):ToEffect()
            smoke:SetTimeout(15)
            smoke.SpriteOffset = Vector(0,-30)
            smoke.DepthOffset = 1
            smoke:Update()

            if target.Position.X < npc.Position.X then sprite.FlipX = true else sprite.FlipX = false end
        end

        if sprite:IsFinished("Transform") then
            d.Transformed = true
            d.state = 3
        end
    elseif d.state == 3 then
        mod:SpritePlay(sprite,"Chase")

        if npc.Velocity:Length() > 1 then
            if npc.Velocity.X < 0 then sprite.FlipX = true else sprite.FlipX = false end
        end

        local maidens = Isaac.FindByType(mod.FF.FlashMaiden.ID, mod.FF.FlashMaiden.Var, -1, false, false)
        local maidCount = 0
        for _, ent in ipairs(maidens) do
            if ent.Index ~= npc.Index
            and mod:GetEntityData(ent).state == 3 then
                maidCount = maidCount + 1
            end
        end

        if not feared and not confused then
            if (d.randomNum+npc.FrameCount) % (bal.chaseShotInterval+(maidCount*3)) == 0 then
                d.shotRotate = d.shotRotate or 1

                local params = ProjectileParams()
                params.Scale = 1
                params.FallingSpeedModifier = 0
                params.FallingAccelModifier = -0.1
                local shootvec = -npc.Velocity:Rotated(d.shotRotate*45) * 0.25
                local proj = mod:FireProjectiles(npc, npc.Position, shootvec, 0, params)
                proj:GetSprite():Load("gfx/projectiles/radioactive_glowing.anm2", true)
                mod:GetEntityData(proj).customProjSplat = "gfx/projectiles/radioactiveSplat.png"
                proj:AddProjectileFlags(ProjectileFlags.DECELERATE)

                d.shotRotate = -d.shotRotate
            end
        end

        d.target = d.target or target.Position
        d.targetTimer = d.targetTimer or 100
        if npc.Position:Distance(d.target) < 60 then
            d.target = target.Position
        elseif d.targetTimer > 0 then
            d.targetTimer = d.targetTimer - 1
        elseif d.targetTimer <= 0 then
            d.target = target.Position
            if confused then
                d.target = room:GetRandomPosition(30)
            end
            d.targetTimer = 100
        end

        local spd = bal.chaseSpeed

        if Isaac.GetPlayer() and Isaac.GetPlayer().MoveSpeed <= 0.6 then
            spd = spd - (1-Isaac.GetPlayer().MoveSpeed)*3
        end

        if feared then
            spd = bal.chaseSpeed*0.75
        end
    
        npc.Velocity = mod:Lerp(npc.Velocity,(d.target-npc.Position):Resized(spd),0.05)
    end

    d.biggestRad = d.biggestRad or mod:GetRadiationBuildup(npc)
    d.biggestRad = math.max(mod:GetRadiationBuildup(npc), d.biggestRad)

    d.biggestRad = math.min(d.biggestRad+0.05,100)
    mod:SetRadiationBuildup(npc, math.max(d.biggestRad, mod:GetRadiationBuildup(npc)))

    if d.ffIrradiatedIcon then
        d.ffIrradiatedIcon.SpriteOffset = Vector(0, -40 + npc.Size * -1.0)
    end

    if d.state == 1 and mod:GetRadiationPercent(npc) > 0.9 then
        d.ffAbsorbRadiation = false
        npc.HitPoints = math.floor(math.max(npc.HitPoints, (npc.MaxHitPoints/6)*5))
        npc:PlaySound(mod.Sounds.RiseUp, 1, 0, false, 0.7)
        npc:SetColor(Color(0,1,0,1,0,0.5,0),20, 1, true, false)

        sprite.PlaybackSpeed = 1.2
        d.state = 2
    end

    if npc:IsDead() then
        npc:BloodExplode()

        local params = ProjectileParams()
        local vec = (target.Position-npc.Position):Resized(6)
        local proj = mod:FireProjectiles(npc, npc.Position, vec, 0, params)
        proj.Scale = 2.5
        proj.FallingAccel = 1.2
        proj.FallingSpeed = -30
        mod:GetEntityData(proj).projType = "FlashMaiden"
        proj:GetSprite():Load("gfx/projectiles/radioactive_glowing.anm2", true)
        mod:GetEntityData(proj).customProjSplat = "gfx/projectiles/radioactiveSplat.png"
        proj:AddProjectileFlags(ProjectileFlags.EXPLODE)
    end

    if d.stateTimer and d.stateTimer > 0 then
        d.stateTimer = d.stateTimer - 1
    end
end

function mod:flashMaidenProjDeath(proj, d)
    local radZone = mod:SpawnRadioactiveAura(proj, proj.Position, bal.radRadius, bal.radDuration)
	radZone.Size = 40
    
    local position = proj.Position

    mod.scheduleForUpdate(function()
        sfx:Play(SoundEffect.SOUND_FLAMETHROWER_END, 1, 0, false, 1)
        radialJets(position, 6, 35)
    end, 4)

    mod.scheduleForUpdate(function()
        radialJets(position, 8, 70)
    end, 8)

    mod.scheduleForUpdate(function()
        radialJets(position, 10, 105)
    end, 12)
end

function mod:flashMaidenHurt(npc, sprite, d, amount, flags, source, cooldown)
    if not (d.Transformed
    or mod:HasDamageFlag(DamageFlag.DAMAGE_CLONES, flags) 
    or mod:HasDamageFlag(DamageFlag.DAMAGE_EXPLOSION, flags) 
    or mod:HasDamageFlag(DamageFlag.DAMAGE_CRUSH, flags)) then

        npc:TakeDamage(amount * bal.dmgReduction, flags | DamageFlag.DAMAGE_CLONES, source, 0)
        return false 
    end
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, eff)
	if IsFlashMaiden(eff.SpawnerEntity) then
		mod:GetEntityData(eff).isRadioactiveExplosion = true
	end
end, EffectVariant.BOMB_EXPLOSION)