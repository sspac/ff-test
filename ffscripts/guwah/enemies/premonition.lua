local mod = FiendFolio
local game = Game()
local rng = RNG()
local sfx = SFXManager()

--Premonition
local bal = {
    moveSpeed = 2,
    moveLerp = 0.1,
    initWait = {20,40},
    waitTime = {45,70},
    projSpeed = 2.5,
    projSpeedLimit = 10,
    projAccelRate = 1.03,
    orbitAmount = 6,
    orbitDistance = 40,
}

--Apocalypse
local bal2 = {
    initWait = 60,
    waitTime = 150,
    orbitAmount = 2,
    orbitExpand = 2,
    spawnHPMult = 0.8,
}

local params = ProjectileParams()
params.Scale = 1.5
params.BulletFlags = ProjectileFlags.NO_WALL_COLLIDE

function mod:PremonitionAI(npc, sprite, data)
    local targetpos = mod:confusePos(npc, npc:GetPlayerTarget().Position)
    local rng = npc:GetDropRNG()

    if not data.Init then
        npc.SplatColor = Color(0.5,0.5,0.5)
        if npc.SpawnerEntity then
            npc.StateFrame = mod:RandomInt(bal.waitTime, rng)
        else
            npc.StateFrame = mod:RandomInt(bal.initWait, rng)
        end
        data.State = "Idle"
        data.Init = true
    end

    if data.State == "Idle" then
        mod:spritePlay(sprite, "Idle")
        npc.Velocity = mod:Lerp(npc.Velocity, mod:reverseIfFear(npc, (targetpos - npc.Position):Resized(bal.moveSpeed)), bal.moveLerp)

        npc.StateFrame = npc.StateFrame - 1
        if npc.StateFrame <= 0 --[[and game:GetRoom():CheckLine(npc.Position, targetpos, 3, 0, false, false)]] then
            data.State = "Shoot"
        end

    elseif data.State == "Shoot" then
        npc.Velocity = npc.Velocity * 0.7
        if sprite:IsFinished("Shoot") then
            data.State = "Idle"
            npc.StateFrame = mod:RandomInt(bal.waitTime, rng)
        elseif sprite:IsEventTriggered("Shoot") then
            local vec = (targetpos - npc.Position):Resized(bal.projSpeed)
            local dummyEffect = Isaac.Spawn(mod.FF.DummyEffect.ID, mod.FF.DummyEffect.Var, mod.FF.DummyEffect.Sub, npc.Position, vec, npc)
            local orbitCC = (rng:RandomFloat() <= 0.5)
            mod:GetEntityData(dummyEffect).PremonitionProjs = {}
            for i = 30, 270, 120 do
                local proj = mod:FireProjectiles(npc, npc.Position, vec, 0, params)
                proj.FallingAccel = -0.1
                mod:GetEntityData(proj).projType = "Premonition"
                mod:GetEntityData(proj).PremonitionAngle = i
                mod:GetEntityData(proj).OrbitCC = orbitCC
                proj.Parent = dummyEffect
                table.insert(mod:GetEntityData(dummyEffect).PremonitionProjs, proj)

                local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 5, npc.Position, Vector.Zero, npc):ToEffect()
                effect.SpriteScale = Vector(0.8,0.8)
                effect.SpriteOffset = Vector(0,-30) + Vector(-20,0):Rotated(i)
                effect.Color = Color(1,1,1,0.6)
                effect.DepthOffset = npc.Position.Y + 40
                effect:FollowParent(npc)
                effect:Update()
            end

            mod:PlaySound(SoundEffect.SOUND_GHOST_SHOOT, npc, 0.8, 0.8)
            mod:PlaySound(SoundEffect.SOUND_SHAKEY_KID_ROAR, npc, 0.65)
            mod:PlaySound(mod.Sounds.FlashShakeyKidRoar, npc, 0.4)
        else
            mod:spritePlay(sprite, "Shoot")
        end
    end

    if npc:IsDead() and mod:shouldDoDeathEffect(npc) then
        local head = Isaac.Spawn(mod.FF.ShrunkenHead.ID, mod.FF.ShrunkenHead.Var, 3, npc.Position, Vector.Zero, npc)
        mod:GetEntityData(head).SkinPreset = "1_sheol"
        --[[local head = Isaac.Spawn(mod.FF.ShrunkenHead.ID, mod.FF.ShrunkenHead.Var, 3, npc.Position, Vector.Zero, npc):ToNPC()
        mod:GetEntityData(head).AllChamps = true
        if npc:IsChampion() then
            head:MakeChampion(69, npc:GetChampionColorIdx(), true)
			head.HitPoints = head.MaxHitPoints
        end]]
    end
end

local function TrySpawnPremonitions(npc, data)
    if not data.SpawnedPremonitions then
        for i = 30, 270, 120 do
            local bigHead = Isaac.Spawn(mod.FF.Premonition.ID, mod.FF.Premonition.Var, 0, npc.Position + Vector(-70,0):Rotated(i), Vector.Zero, npc)
            bigHead:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            bigHead.MaxHitPoints = bigHead.MaxHitPoints * bal2.spawnHPMult
            bigHead.HitPoints = bigHead.MaxHitPoints
        end
        data.SpawnedPremonitions = true
    end
end

function mod:ApocalypseAI(npc, sprite, data)
    local room = game:GetRoom()
    local targetpos = mod:confusePos(npc, npc:GetPlayerTarget().Position)
    local rng = npc:GetDropRNG()

    if not data.Init then
        npc.SplatColor = Color(0.5,0.5,0.5)
        npc.StateFrame = bal2.initWait
        npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
        npc.SpriteOffset = Vector(0,50)
        data.OrbitCC = (rng:RandomFloat() <= 0.5)
        data.State = "Idle"

        local shiftRight = npc.SubType & 1 > 0
		local shiftDown = npc.SubType & 2 > 0
		if shiftRight then
			npc.Position = npc.Position + Vector(20, 0)
		end
		if shiftDown then
			npc.Position = npc.Position + Vector(0, 20)
		end

        data.Init = true
    end

    npc.Velocity = Vector.Zero
    mod.NegateKnockoutDrops(npc)
    mod.QuickSetEntityGridPath(npc)
    if npc.FrameCount % 10 == 0 then
        for i = 45, 360, 45 do
            mod.QuickSetEntityGridPath(npc, 900, false, room:GetGridIndex(npc.Position+Vector(40,0):Rotated(i)))
        end
        for i = 30, 360, 30 do
            mod.QuickSetEntityGridPath(npc, 900, false, room:GetGridIndex(npc.Position+Vector(70,0):Rotated(i)))
        end
    end

    if data.State == "Idle" then
        mod:spritePlay(sprite, "Idle")

        npc.StateFrame = npc.StateFrame - 1
        if npc.StateFrame <= 0 then
            data.State = "Shoot"
        end

    elseif data.State == "Shoot" then
        if sprite:IsFinished("Shoot") then
            data.State = "Idle"
            npc.StateFrame = bal2.waitTime
        elseif sprite:IsEventTriggered("Shoot") then
            for i = 30, 270, 120 do
                local sourcepos = npc.Position + Vector(-60,0):Rotated(i)
                local dummyEffect = Isaac.Spawn(mod.FF.DummyEffect.ID, mod.FF.DummyEffect.Var, mod.FF.DummyEffect.Sub, sourcepos, Vector(-bal2.orbitExpand,0):Rotated(i), npc)
                mod:GetEntityData(dummyEffect).OrbitAngle = i
                mod:GetEntityData(dummyEffect).OrbitCC = data.OrbitCC
                mod:GetEntityData(dummyEffect).OrbitPos = npc.Position
                mod:GetEntityData(dummyEffect).PremonitionProjs = {}

                for j = 30, 270, 120 do
                    local proj = mod:FireProjectiles(npc, sourcepos, Vector(-bal2.orbitExpand,0):Rotated(j), 0, params)
                    proj.FallingAccel = -0.1
                    mod:GetEntityData(proj).projType = "Apocalypse"
                    mod:GetEntityData(proj).PremonitionAngle = j
                    mod:GetEntityData(proj).OrbitCC = not data.OrbitCC
                    proj.Parent = dummyEffect
                    table.insert(mod:GetEntityData(dummyEffect).PremonitionProjs, proj)

                    local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 5, sourcepos, Vector.Zero, npc):ToEffect()
                    effect.SpriteScale = Vector(0.8,0.8)
                    effect.SpriteOffset = Vector(-20,0):Rotated(j)
                    effect.Color = Color(1,1,1,0.6)
                    effect.DepthOffset = npc.Position.Y + 40
                    effect:FollowParent(npc)
                    effect:Update()
                end
            end

            data.OrbitCC = not data.OrbitCC
            mod:PlaySound(SoundEffect.SOUND_GHOST_SHOOT, npc, 0.6, 0.8)
            mod:PlaySound(SoundEffect.SOUND_SHAKEY_KID_ROAR, npc, 0.4)
            mod:PlaySound(mod.Sounds.FlashShakeyKidRoar, npc, 0.2)
            mod:PlaySound(SoundEffect.SOUND_WORM_SPIT, npc, 0.2, 3)
            mod:PlaySound(SoundEffect.SOUND_FAMINE_SHOOT, npc, 1.2)
            mod:PlaySound(SoundEffect.SOUND_SATAN_SPIT, npc, 0.6, 0.8)
        else
            mod:spritePlay(sprite, "Shoot")
        end
    end

    if npc:IsDead() and mod:shouldDoDeathEffect(npc) then
        TrySpawnPremonitions(npc, data)
    end
end

function mod:ApocalypseRender(npc, sprite, data)
    if mod:IsNormalRender() and data.State == "Death" then
        if sprite:IsFinished("Death") then
            npc:Remove()
        elseif sprite:IsEventTriggered("Spawn") then
            TrySpawnPremonitions(npc, data)
        else
            mod:spritePlay(sprite, "Death")
        end
    end
end

function mod.ApocalypseDeathAnim(npc)
	local onCustomDeath = function(npc, deathAnim)
        mod:GetEntityData(deathAnim).State = "Death"
        deathAnim.State = NpcState.STATE_DEATH
        mod:PlaySound(SoundEffect.SOUND_DEVILROOM_DEAL, npc, 0.5, 2.5)
        mod:PlaySound(SoundEffect.SOUND_SATAN_RISE_UP, npc, 0.6)
    end
    FiendFolio.genericCustomDeathAnim(npc, "Death", true, onCustomDeath, false, false, true, false)
end

function mod:PremonitionProjectile(proj, data)
    if data.OrbitCC then
        data.PremonitionAngle = data.PremonitionAngle - bal.orbitAmount
    else
        data.PremonitionAngle = data.PremonitionAngle + bal.orbitAmount
    end

    if data.projType == "Premonition" and proj.FrameCount > 30 and game:GetRoom():GetGridCollisionAtPos(proj.Position) >= GridCollisionClass.COLLISION_WALL then
        proj:Die()
    end
end

function mod:PremonitionCore(effect, data)
    if data.OrbitPos then
        if data.OrbitCC then
            data.OrbitAngle = data.OrbitAngle - bal2.orbitAmount
        else
            data.OrbitAngle = data.OrbitAngle + bal2.orbitAmount
        end
        local dist = effect.Position:Distance(data.OrbitPos) + bal2.orbitExpand
        targetpos = data.OrbitPos + Vector(-dist, 0):Rotated(data.OrbitAngle)
        effect.Velocity = targetpos - effect.Position
    elseif effect.Velocity:Length() < bal.projSpeedLimit then
        effect.Velocity = effect.Velocity * bal.projAccelRate
    end

    local willDie = true
    for _, proj in pairs(data.PremonitionProjs) do
        if data.OrbitPos and effect.Position:Distance(data.OrbitPos) > 600 and not game:GetRoom():IsPositionInRoom(effect.Position, 0) then
            proj:Die()
        elseif proj:Exists() then
            local targetpos = effect.Position + Vector(bal.orbitDistance, 0):Rotated(mod:GetEntityData(proj).PremonitionAngle)
            local vec = targetpos - proj.Position
            vec = vec:Resized(math.min(vec:Length(), math.max(8, effect.Velocity:Length() * 2)))
            proj.Velocity = vec
            willDie = false
        end
    end

    if willDie then
        effect:Remove()
    end
end