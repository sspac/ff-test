local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local bal = {
    scootChance = 0.05,
    scootSpeed = 7.5,
    spawnCooldown = {90,120},
    spawnPoisonTicks = {5,8},
    spawnSpeedMult = 1.25,
    spawnCap = 2,

    baseBoomFlySpeed = 6,
    nearEnemySlowRange = 80,
    nearEnemySlowMinRange = 20,
    nearEnemySlowAmount = 0.8,
    dmgRange = 60,
    sporeRange = 120,
    projSpeed = 5, --Unused
}

function mod:RosieAI(npc, sprite, data)
    local rng = npc:GetDropRNG()

    if not data.Init then
        npc.StateFrame = mod:RandomInt(bal.spawnCooldown, rng) - 75
        data.State = "Idle"
        data.Init = true
    end

    if data.State == "Idle" then
        mod:SpritePlay(sprite, "Idle")
        npc.Velocity = npc.Velocity * 0.8

        npc.StateFrame = npc.StateFrame - 1
        if npc.StateFrame <= 0 then
            local poisonPosies = 0
            for _, posie in pairs(Isaac.FindByType(mod.FF.Posie.ID, mod.FF.Posie.Var)) do
                if mod:GetEntityData(posie).RosiePoisonTicks then
                    poisonPosies = poisonPosies + 1
                end
            end
            if poisonPosies >= mod.GetEntityCount(mod.FF.Rosie.ID, mod.FF.Rosie.Var) * bal.spawnCap then
                npc.StateFrame = mod:RandomInt(bal.spawnCooldown, rng) - 60
            else
                data.State = "Shoot"
            end
        elseif rng:RandomFloat() <= bal.scootChance then
            local goodDirs = {}
            for i = 90, 360, 90 do
                local offset = Vector.FromAngle(i):Resized(40)
                if room:GetGridPath(room:GetGridIndex(npc.Position + offset)) <= 900 then
                    table.insert(goodDirs, offset)
                end
            end
            local moveDir = mod:GetRandomElem(goodDirs, rng)
            if moveDir then
                npc.V1 = moveDir
                if math.abs(npc.V1.X) < math.abs(npc.V1.Y) then
                    data.AnimSuffix = npc.V1.Y > 0 and "Down" or "Up"
                else
                    data.AnimSuffix = "Hori"
                    mod:FlipSprite(sprite, npc.Position, npc.Position + npc.V1)
                end
                data.State = "Walk"
            end
        end

    elseif data.State == "Walk" then
        npc.Velocity = npc.Velocity * 0.8
        npc.StateFrame = npc.StateFrame - 1

        if sprite:IsFinished("Walk"..data.AnimSuffix) then
            data.State = "Idle"
        elseif sprite:IsEventTriggered("Move") then
            npc.Velocity = npc.V1:Resized(bal.scootSpeed)
        else
            mod:SpritePlay(sprite, "Walk"..data.AnimSuffix)
        end

    elseif data.State == "Shoot" then
        npc.Velocity = npc.Velocity * 0.8

        if sprite:IsFinished("Shoot") then
            npc.StateFrame = mod:RandomInt(bal.spawnCooldown, rng)
            data.State = "Idle"
        elseif sprite:IsEventTriggered("Shoot") then
            local targetSpan = mod:confusePos(npc, npc:GetPlayerTarget().Position) - npc.Position
            local shootVec = Vector(FiendFolio.sign(targetSpan.X), FiendFolio.sign(targetSpan.Y))
            local posie = Isaac.Spawn(mod.FF.Posie.ID, mod.FF.Posie.Var, 0, npc.Position + shootVec:Resized(15), shootVec:Resized(bal.baseBoomFlySpeed), npc):ToNPC()
            posie:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            mod:GetEntityData(posie).RosiePoisonTicks = mod:RandomInt(bal.spawnPoisonTicks, rng)
            posie:Update()
            posie.Velocity = shootVec:Resized(bal.baseBoomFlySpeed * bal.spawnSpeedMult)
            mod:PlaySound(SoundEffect.SOUND_WHEEZY_COUGH, npc)
            mod:PlaySound(SoundEffect.SOUND_SUMMONSOUND, npc, 1.0, 0.85)
            local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 2, npc.Position, Vector.Zero, npc)
            poof.DepthOffset = 40
            poof.PositionOffset = npc:GetNullOffset("EffectPos")
            poof.Color = mod:CloneColor(mod.ColorToxicFart, 0.75)
            poof:Update()
        else
            mod:SpritePlay(sprite, "Shoot")
        end
    end
end

function mod:PosieAI(npc, sprite, data)
    if data.RosiePoisonTicks and not npc:HasEntityFlags(EntityFlag.FLAG_POISON) then
        npc:AddPoison(EntityRef(npc.SpawnerEntity), 999, (npc.MaxHitPoints / data.RosiePoisonTicks) + 0.1)
    end

    local nearDist = 9999
    for _, enemy in pairs(Isaac.FindInRadius(npc.Position, bal.nearEnemySlowRange, EntityPartition.ENEMY | EntityPartition.PLAYER)) do
        if enemy:ToPlayer() or 
        (enemy:IsActiveEnemy() and GetPtrHash(enemy) ~= GetPtrHash(npc) 
        and mod:CanBeInfectedByCordifySpores(enemy) 
        and enemy.Type ~= EntityType.ENTITY_ETERNALFLY) then
            local dist = enemy.Position:Distance(npc.Position)
            if dist < nearDist then
                nearDist = math.max(dist, bal.nearEnemySlowMinRange)
                if dist <= bal.nearEnemySlowMinRange then
                    break
                end
            end
        end
    end
    local speedMult = npc:HasEntityFlags(EntityFlag.FLAG_POISON) and bal.spawnSpeedMult or 1.0
    if nearDist <= bal.nearEnemySlowRange then
        local slowFactor = 1.0 - (nearDist / bal.nearEnemySlowRange)
        local slowAmount = 1.0 - (bal.nearEnemySlowAmount * slowFactor)
        speedMult = speedMult * slowAmount
    end
    npc.Velocity = mod:Lerp(npc.Velocity, npc.Velocity:Resized(bal.baseBoomFlySpeed) * speedMult, 0.5)

    if npc:IsDead() and mod:shouldDoDeathEffect(npc) then
        for _, proj in pairs(mod:GatherProjectiles(npc)) do
            if proj.Variant == 0 then
                proj:Remove()
            end
        end

        --npc:FireProjectiles(npc.Position, Vector(bal.projSpeed, 0), ProjectileMode.PLUS, ProjectileParams())
        mod:FakerFart(npc, npc.Position, bal.dmgRange)
        for _, enemy in pairs(Isaac.FindInRadius(npc.Position, bal.sporeRange, EntityPartition.ENEMY)) do
            if enemy:IsActiveEnemy() and GetPtrHash(enemy) ~= GetPtrHash(npc) then
                mod.scheduleForUpdate(function()
                    if enemy:Exists() then
                        mod:CordifySporeInfect(npc, enemy, 0.85, 1.15)
                    end
                end, 0)
            end
        end
    end
end

function mod:PosieColl(npc, collider)
    if collider:ToPlayer() and npc:HasEntityFlags(EntityFlag.FLAG_POISON) then
        npc:Kill()
    end
end