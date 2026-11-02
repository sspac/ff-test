local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local bal = {
    moveSpeed = 3,
    backUpDistance = 40,
    shootDetectAngle = 20,
    wispCap = 3,
    wispSpawnRate = 120,
    projSpeed = 20,
    deathFalafels = 4,
    attackRange = 300,
}

local suffixes = {"Down", "Right", "Up", "Left"}

local function GetAntiFiendHead(npc, targetpos, checkFear)
    local span = targetpos - npc.Position
    if checkFear then
        span = mod:reverseIfFear(npc, span)
    end
    local targrel
    if math.abs(span.X) > math.abs(span.Y) then
        if span.X < 0 then
            targrel = 3
        else
            targrel = 1
        end
    else
        if span.Y < 0 then
            targrel = 2
        else
            targrel = 0
        end
    end
    return targrel
end

local function MakeFalafel(position, vec, spawner)
    local skin = Isaac.Spawn(mod.FF.Falafel.ID, mod.FF.Falafel.Var, 0, position, vec, spawner)
    skin.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    skin:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
    mod:GetEntityData(skin).fallspeed = mod:RandomInt(-12,-8)
    mod:GetEntityData(skin).fallaccel = 1
    mod:GetEntityData(skin).state = "thrown"
    skin:GetSprite():ReplaceSpritesheet(0, "gfx/enemies/antifiend/falafel_antifiend.png")
    skin:GetSprite():ReplaceSpritesheet(1, "gfx/enemies/antifiend/falafel_antifiend.png")
    skin:GetSprite():ReplaceSpritesheet(6, "gfx/enemies/antifiend/falafel_morph_antifiend.png")
    skin:GetSprite():LoadGraphics()
    skin.SplatColor = mod.ColorFiendGuts
    skin:Update()
end

local function GatherWisps(npc)
    local wisps = {}
    for _, wisp in pairs(Isaac.FindByType(mod.FF.AntiFiendWisp.ID, mod.FF.AntiFiendWisp.Var, mod.FF.AntiFiendWisp.Sub)) do
        if wisp.Parent and wisp.Parent.InitSeed == npc.InitSeed then
            table.insert(wisps, wisp)
        end
    end
    return wisps 
end

local function RecalculateWispOrbiting(npc)
    local sorttable = {}
    for _, wisp in pairs(GatherWisps(npc)) do
        if not mod:GetEntityData(wisp).AimOffset then
            local angle = mod:GetAngleDegreesButGood(wisp.Position - npc.Position)
            table.insert(sorttable, {wisp, angle})
        end
    end
    table.sort(sorttable, function(a, b) return a[2] < b[2] end )
    for i = 1, #sorttable do
        local data = mod:GetEntityData(sorttable[i][1])
        data.OrbitAngle = ((360 / #sorttable) * i)
    end
end

local function AddFireballWisp(npc, data)
    local wisp = Isaac.Spawn(mod.FF.AntiFiendWisp.ID, mod.FF.AntiFiendWisp.Var, mod.FF.AntiFiendWisp.Sub, npc.Position, Vector.Zero, npc)
    wisp.Parent = npc
    wisp.SpriteOffset = Vector(0,-14)
    wisp:Update()
    RecalculateWispOrbiting(npc)
    return wisp
end

local params = ProjectileParams()
params.Variant = mod.FF.AntiFiendProjectile.Var
params.HeightModifier = 5

function mod:AntiFiendAI(npc, sprite, data)
    local targetpos = mod:confusePos(npc, npc:GetPlayerTarget().Position)
    local rng = npc:GetDropRNG()
    local room = game:GetRoom()
    local wisps = GatherWisps(npc)

    if not data.Init then
        npc:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
        npc.StateFrame = math.floor(bal.wispSpawnRate/2.5)
        data.State = data.State or "Idle"
        data.Init = true
    end

    if data.State == "Idle" then
        --Status Effects
        if mod:isConfuse(npc) then
            if mod:RandomInt(1,2,rng) == 1 then
                bal.moveSpeed = bal.moveSpeed * -1
            end
            if mod:RandomInt(1,3,rng) == 1 then
                bal.moveSpeed = bal.moveSpeed * 2.5
            end
        end

        --Targeting
        local targdistance = mod:reverseIfFear(npc, targetpos - npc.Position)
        local targrel = GetAntiFiendHead(npc, targetpos)
        local distanceabs = npc.Position:Distance(targetpos)

        if distanceabs < bal.backUpDistance and room:CheckLine(npc.Position,targetpos,0,3,false,false) and not mod:isScare(npc)  then
            local extravec = 0
            if distanceabs < bal.backUpDistance * 0.66 then
                extravec = distanceabs / 3
            end

            local tpa = targetpos
            if targrel == 0 then
                tpa = targetpos + Vector((targetpos.X - npc.Position.X), -distanceabs - extravec)
            elseif targrel == 1 then
                tpa = targetpos + Vector(-distanceabs - extravec, (targetpos.Y - npc.Position.Y))
            elseif targrel == 2 then
                tpa = targetpos + Vector((targetpos.X - npc.Position.X), distanceabs + extravec)
            elseif targrel == 3 then
                tpa = targetpos + Vector(distanceabs + extravec, (targetpos.Y - npc.Position.Y))
            end

            if npc.Position:Distance(tpa) > 10 then
                local vel = (tpa - npc.Position):Resized(bal.moveSpeed)
                npc.Velocity = mod:Lerp(vel, npc.Velocity, 0.8)
            else
                npc.Velocity = npc.Velocity * 0.8
            end

        else
            if mod:isScare(npc) then
                local vel = (targetpos - npc.Position):Resized(bal.moveSpeed * -1.5)
                npc.Velocity = mod:Lerp(vel, npc.Velocity, 0.8)

            elseif room:CheckLine(npc.Position,targetpos,0,0,false,false) then
                local vel = (targetpos - npc.Position):Resized(bal.moveSpeed)
                npc.Velocity = mod:Lerp(vel, npc.Velocity, 0.8)

            elseif npc.Pathfinder:HasPathToPos(targetpos, false) then
                mod:CatheryPathFinding(npc, targetpos, {
                    Speed = bal.moveSpeed,
                    Accel = 0.2,
                    Interval = 1,
                    GiveUp = true
                 })
            else
                local targvec = Vector(npc.Position.X, targetpos.Y)
                if targrel == 2 or targrel == 0 then
                    targvec = Vector(targetpos.X, npc.Position.Y)
                end
                local vel = (targvec - npc.Position):Resized(bal.moveSpeed)
                npc.Velocity = mod:Lerp(vel, npc.Velocity, 0.8)
            end
        end

        mod:AnimWalkFrame(npc, sprite, {"WalkLeft", "WalkRight"}, {"WalkDown", "WalkUp"})
    
        data.HeadSuffix = suffixes[targrel+1]
        mod:spriteOverlayPlay(sprite, "Head"..data.HeadSuffix)
        if room:CheckLine(targetpos,npc.Position,3,900,false,false) then
            if (math.abs(targdistance.X) < bal.shootDetectAngle or math.abs(targdistance.Y) < bal.shootDetectAngle) and targdistance:Length() < bal.attackRange then
                if #wisps > 0 then
                    local shootwisp
                    local dist = 9999
                    for _, wisp in pairs(wisps) do
                        if wisp.Position:Distance(targetpos) < dist then
                            shootwisp = wisp
                            dist = wisp.Position:Distance(targetpos)
                        end
                    end
                    if shootwisp then
                        data.ShootVec = Vector(0,bal.projSpeed):Rotated(-targrel * 90)
                        mod:GetEntityData(shootwisp).AimOffset = data.ShootVec:Resized(20)
                        RecalculateWispOrbiting(npc)
                        data.ShootWisp = shootwisp
                        sprite:RemoveOverlay()
                        mod:spritePlay(sprite, "Shoot"..data.HeadSuffix)
                        data.State = "Shoot"
                    end
                end
            end
        end

    elseif data.State == "Shoot" then
        npc.Velocity = npc.Velocity * 0.7
        if sprite:IsFinished("Shoot"..data.HeadSuffix) then
            data.State = "Idle"
            mod:spriteOverlayPlay(sprite, "Head"..data.HeadSuffix)
        elseif sprite:IsEventTriggered("Shoot") then
            if data.ShootWisp and data.ShootWisp:Exists() then
                mod:PlaySound(mod.Sounds.FireballLaunch, npc, mod:RandomInt(90, 110, rng)/100, 0.4)
                mod:PlaySound(mod.Sounds.FiendHurt, npc, 0.6)
                mod:PlaySound(SoundEffect.SOUND_FLAMETHROWER_END, npc, mod:RandomInt(90, 110, rng)/100, 0.3)
                mod:PlaySound(SoundEffect.SOUND_FLAME_BURST, npc, mod:RandomInt(90, 110, rng)/100, 0.3)
				mod:SetGatheredProjectiles()
                npc:FireProjectiles(data.ShootWisp.Position, data.ShootVec, 0, params)
				for _, proj in pairs(mod:GetGatheredProjectiles()) do
					proj.ProjectileFlags = proj.ProjectileFlags & ~ProjectileFlags.GHOST
				end
                data.ShootWisp:Remove()
            end
        else
            mod:spritePlay(sprite, "Shoot"..data.HeadSuffix)
        end

    elseif data.State == "Death" then
        if sprite:IsFinished("Death") then
            mod.AntiFiendDeathEffect(npc)
            npc:Kill()
        else
            mod:spritePlay(sprite, "Death")
        end
    end

    npc.StateFrame = npc.StateFrame - 1
    if npc.StateFrame <= 0 then
        if #wisps < bal.wispCap then
            AddFireballWisp(npc, data)
            npc.StateFrame = bal.wispSpawnRate
        end
    end
end

function mod.AntiFiendDeathAnim(npc)
	local onCustomDeath = function(npc, deathAnim)
        mod:GetEntityData(deathAnim).State = "Death"
        mod:PlaySound(mod.Sounds.FiendDies, deathAnim, 0.6)
    end
    FiendFolio.genericCustomDeathAnim(npc, "Death", true, onCustomDeath, false, false, true, false)
end

function mod.AntiFiendDeathEffect(npc)
    local splat = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_SPLAT, 0, npc.Position, Vector.Zero, npc)
    splat.Color = mod.ColorFiendGuts
    splat:Update()
    local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0, npc.Position, Vector.Zero, npc)
    poof.Color = mod.ColorFiendGuts
    poof:Update()
    local poof2 = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 3, npc.Position, Vector.Zero, npc)
    poof2.Color = mod.ColorFiendGuts
    poof2.SpriteScale = Vector(0.8,0.8)
    poof2:Update()
    local poof3 = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 4, npc.Position, Vector.Zero, npc)
    poof3.Color = mod.ColorFiendGuts
    poof3.SpriteScale = Vector(0.8,0.8)
    poof3:Update()
    for i = 1, 6 do
        local gib = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_PARTICLE, 0, npc.Position, RandomVector()*mod:RandomInt(5,8), npc)
        gib.Color = mod.ColorFiendGuts
        gib:Update()
    end
    for i = 1, bal.deathFalafels do
        MakeFalafel(npc.Position, RandomVector()*mod:RandomInt(2,5,npc:GetDropRNG()), npc)
    end
    sfx:Play(SoundEffect.SOUND_DEATH_BURST_LARGE)
    sfx:Stop(SoundEffect.SOUND_DEATH_BURST_BONE)
end

function mod:AntiFiendWisp(effect, sprite, data)
    effect.SpriteOffset = Vector(0, -14)
    if effect.Parent and not mod:IsReallyDead(effect.Parent) then
        local vec
        if data.AimOffset then
            local targetpos = effect.Parent.Position + data.AimOffset
            vec = targetpos - effect.Position
        elseif data.OrbitAngle then
            local targetpos = effect.Parent.Position + Vector(30,0):Rotated(data.OrbitAngle)
            vec = targetpos - effect.Position
            data.OrbitAngle = data.OrbitAngle - 3
        end
        if vec then
            vec = vec:Resized(math.min(vec:Length(), 5))
            effect.Velocity = vec
        end
    else
        mod:AntiFiendFireballDeath(effect, sprite)
        effect:Remove()
    end
end

function mod:AntiFiendFireball(proj, sprite, data)
    mod:spritePlay(sprite, "MoveHori")
    sprite.Rotation = proj.Velocity:GetAngleDegrees()
    proj.FallingAccel = 0
    proj.FallingSpeed = 0

    if proj.FrameCount % 3 == 2 then
        local plume = Isaac.Spawn(1000, 147, 0, proj.Position, Vector.Zero, proj.SpawnerEntity)
        plume.SpriteScale = Vector(0.5,0.5)
        plume.Color = Color(1,1,1,1,-0.5,0.5,-0.5)
        plume:Update()
    end
end

function mod:AntiFiendFireballDeath(proj, sprite)
	local spreadMulti = 5
	local rotExtra = mod:RandomInt(60)

	for i = 1, 6 do
		for j = 0, 2 do
			local rotInd = 0.33 * j
			local vecMinus = 0
			if j > 0 then
				vecMinus = 10
			end
			local fire = Isaac.Spawn(1000, 7015, 0, proj.Position, Vector(0, 1):Resized((30 - vecMinus)/spreadMulti):Rotated((i - rotInd)*60 + rotExtra), proj.SpawnerEntity)
            fire:GetSprite():ReplaceSpritesheet(0, "gfx/effects/effect_005_fire_radioactive.png")
            fire:GetSprite():LoadGraphics()
            fire.Parent = proj.SpawnerEntity
            fire.Size = 16
            fire:Update()
		end
	end

    local explosion = Isaac.Spawn(1000, 7018, 0, proj.Position, Vector.Zero, proj.SpawnerEntity)
    explosion.SpriteScale = Vector(0.5,0.5)
    explosion.Color = Color(1,1,1,1,-0.5,0.5,-0.5)
    explosion:Update()
    mod:DestroyNearbyGrid(proj, 40)

    sfx:Play(mod.Sounds.FireballLand, 1.4, 0, false, mod:RandomInt(90, 110)/100)
    sfx:Play(SoundEffect.SOUND_EXPLOSION_WEAK)
    if not (proj.SpawnerEntity and mod:isFriend(proj.SpawnerEntity) and mod.GetFriendlyEntityCount(mod.FF.Falafel.ID, mod.FF.Falafel.Var) > 2) then
        MakeFalafel(proj.Position, proj.Velocity/20, proj.SpawnerEntity)
    end
end