local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

function mod:SpritePlay(sprite, anim) --muscle memory is fucked
    mod:spritePlay(sprite, anim)
end

function mod:GetNearestDoor(pos, radius)
    local room = game:GetRoom()
    local dist = radius or 9999
    local door
    for slot = 0, DoorSlot.NUM_DOOR_SLOTS - 1 do
        local newdoor = room:GetDoor(slot)
        if newdoor and newdoor.Position:Distance(pos) < dist then
            door = newdoor
            dist = newdoor.Position:Distance(pos)
        end
    end
    return door
end

local bal = {
    moveSpeed = 2,
    initCooldown = {30,45},
    attackCooldown = {60,120},
    redAttackCooldown = {120,180},
    spawnCap = 3,
    redSpawnCap = 2,
    spawnVel = 5,
    redSpawnVel = 2,
    redSpawnRollTime = 60,
}

local function ShouldTargetPlayer(npc, targetpos, isCheekadee)
    return isCheekadee
    or (targetpos:Distance(npc.Position) <= 200 and game:GetRoom():CheckLine(npc.Position, targetpos, 0, 1, false, false))
end

function mod:CheekyAI(npc, sprite, data)
    local rng = npc:GetDropRNG()
    local targetpos = mod:confusePos(npc, npc:GetPlayerTarget().Position)

    local isRashy = npc.Type == mod.FF.Rashy.ID and npc.Variant == mod.FF.Rashy.Var
    local isCheekadee = npc.Type == mod.FF.Cheekadee.ID and npc.Variant == mod.FF.Cheekadee.Var

    if not data.Init then
        data.State = "Idle"
        data.Moving = true
        npc.StateFrame = mod:RandomInt(bal.initCooldown, rng)
        data.Init = true
    end

    local spawnType = EntityType.ENTITY_DIP
    local spawnVar = 0
    local spawnCap = bal.spawnCap

    if isRashy then
        spawnType = mod.FF.SpicyDip.ID
        spawnVar = mod.FF.SpicyDip.Var
        spawnCap = bal.redSpawnCap
    elseif isCheekadee then
        spawnType = mod.FF.Murder.ID
        spawnVar = mod.FF.Murder.Var
    end

    if data.State == "Idle" then
        if mod:WanderAbout(npc, data, bal.moveSpeed, 0.02, nil, 0.3) then
            mod:SpritePlay(sprite, "Walk")
            if data.Moving then
                mod:FlipSprite(sprite, npc.Position + npc.Velocity, npc.Position)
            else
                npc.Velocity = npc.Velocity * 0.2
            end
            if sprite:IsEventTriggered("Start") then
                data.Moving = true
            elseif sprite:IsEventTriggered("Stop") then
                data.Moving = false
                mod:PlaySound(SoundEffect.SOUND_SCAMPER, npc, 0.4, 0.2)
            end
        else
            data.Moving = true
            npc.Velocity = npc.Velocity * 0.5
            mod:SpritePlay(sprite, "Idle")
        end

        npc.StateFrame = npc.StateFrame - 1
        if npc.StateFrame <= 0 then
            if (not mod:isFriend(npc) and mod.GetEntityCount(spawnType, spawnVar) < mod.GetEntityCount(npc.Type, npc.Variant) * spawnCap)
            or (mod:isFriend(npc) and mod.GetFriendlyEntityCount(spawnType, spawnVar) < mod.GetFriendlyEntityCount(npc.Type, npc.Variant) * spawnCap)
            then
                data.State = "Shoot"
            else
                npc.StateFrame = mod:RandomInt(bal.initCooldown, rng)
            end
        end

    elseif data.State == "Shoot" then
        npc.Velocity = npc.Velocity * 0.5
        if sprite:IsFinished("Shoot") then
            data.State = "Idle"
            data.Moving = true
            if isRashy then
                npc.StateFrame = mod:RandomInt(bal.redAttackCooldown, rng)
            else
                npc.StateFrame = mod:RandomInt(bal.attackCooldown, rng)
            end
        elseif sprite:IsEventTriggered("Sound") then
            mod:PlaySound(SoundEffect.SOUND_MEAT_JUMPS, npc)
            if ShouldTargetPlayer(npc, targetpos, isCheekadee) then
                mod:FlipSprite(npc, targetpos, npc.Position)
            end
        elseif sprite:IsEventTriggered("Shoot") then
            local particleVar = EffectVariant.POOP_PARTICLE
            local spawnVec = RandomVector() * bal.spawnVel
            if ShouldTargetPlayer(npc, targetpos, isCheekadee) then
                spawnVec = (targetpos - npc.Position):Resized(isRashy and bal.redSpawnVel or bal.spawnVel)
            end

            local spawn = Isaac.Spawn(spawnType, spawnVar, 0, npc.Position + spawnVec:Resized(20), spawnVec, npc):ToNPC()
            spawn:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            if isRashy then
                local d = mod:GetEntityData(spawn)
                d.state = 'roll'
                d.rolling = true
                spawn.StateFrame = 120 - bal.redSpawnRollTime
                d.confused = -bal.redSpawnRollTime
                particleVar = EffectVariant.BLOOD_PARTICLE
            elseif not isCheekadee then
                spawn.SplatColor = mod.ColorPoop
                spawn.State = NpcState.STATE_MOVE
            end
            spawn:Update()
            mod:FlipSprite(npc, npc.Position + spawnVec, npc.Position)

            for i = 1, 3 do
                local speed = mod:RandomInt(3,6,rng)
                local offset = mod:RandomInt(-20,20,rng)

                if isCheekadee then
                    local velocity = Vector(mod:GetSign(sprite.FlipX) * speed, 0):Rotated(offset)
                    local duration = mod:RandomInt(25,35,rng)
                    local smoke = mod:SpawnDust(npc.Position, velocity, 0.4, Color(0.2,0.2,0.2, 0.8), duration)
                    smoke:GetSprite().Offset = Vector(0, -15)
                else
                    local velocity = spawnVec:Resized(speed):Rotated(offset)
                    Isaac.Spawn(EntityType.ENTITY_EFFECT, particleVar, 0, npc.Position, velocity, npc)
                end
            end
            mod:PlaySound(SoundEffect.SOUND_PLOP, npc)
            mod:PlaySound(SoundEffect.SOUND_FART, npc)
        else
            mod:SpritePlay(sprite, "Shoot")
        end
    end

    if npc:IsDead() then
        if isCheekadee then
            local room = game:GetRoom()
            local grid = room:GetGridEntityFromPos(npc.Position)

            if not grid or grid:GetType() == GridEntityType.GRID_DECORATION or grid:GetType() == GridEntityType.GRID_SPIDERWEB then
                local grindex = room:GetGridIndex(npc.Position)
                mod.EvilPoopGrid:Spawn(grindex, true, false)
            end

        else
            local poopVar = 0
            if isRashy and not mod:GetNearestDoor(npc.Position, 80) then
                poopVar = 1
            end
            Isaac.GridSpawn(GridEntityType.GRID_POOP, poopVar, npc.Position, false)
        end

        mod:PlaySound(SoundEffect.SOUND_PLOP, npc)
    end
end

function mod:IgnoreRedPoopDamage(npc, amount, damageFlags, source)
	if mod:HasDamageFlag(DamageFlag.DAMAGE_POOP, damageFlags) then
        return false
    end
end