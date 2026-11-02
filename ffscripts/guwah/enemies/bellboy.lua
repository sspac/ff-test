local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local bal = {
    moveSpeed = 2,
    moveLerp = 0.1,
    slowFactor = 0.7,
    waitTime = {120,180},
    ringRadius = 120,
    projSpeed = 8,
}

local function GetBellDir(npc, pos, goTowards)
    if npc.Position.X < pos.X then
        if goTowards then
            return "Left"
        else
            return "Right"
        end
    else
        if goTowards then
            return "Right"
        else
            return "Left"
        end
    end
end

function mod:MakeLarynxWave(position, size, duration, spawner, color)
    size = size or 20
    duration = duration or 30
    local ring = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BIG_ATTRACT, 10, position, Vector.Zero, spawner):ToEffect()
    ring.MaxRadius = size
    ring.MinRadius = 0
    ring.LifeSpan = duration
    if color then
        ring.Color = color
    end
    ring:Update()
    return ring
end

function mod:MakeLarynxLine(position, size, duration, spawner, color)
    size = size or 15
    duration = duration or 9
    local line = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BIG_ATTRACT, 11, position, Vector.Zero, spawner):ToEffect()
    line.MaxRadius = size
    line.MinRadius = 10
    line.LifeSpan = duration
    if color then
        line.Color = color
    end
    line:Update()
    return line
end

function mod:BellBoyAI(npc, sprite, data)
    local targetpos = mod:confusePos(npc, npc:GetPlayerTarget().Position)
    local rng = npc:GetDropRNG()

    if not data.Init then
        npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_HIDE_HP_BAR)
        npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        data.State = "Appear"
        data.Init = true
    end

    if data.State == "Idle" then
        if game:GetRoom():IsClear() then
            data.State = "Leave"
        else
            mod:spritePlay(sprite, "Idle")
            npc.Velocity = mod:Lerp(npc.Velocity, mod:reverseIfFear(npc, targetpos - npc.Position):Resized(bal.moveSpeed), bal.moveLerp)

            npc.StateFrame = npc.StateFrame - 1
            if npc.StateFrame <= 0 then
                data.BellDir = GetBellDir(npc, targetpos, true)
                data.RingAnim = "Hit"..data.BellDir.."Manual"
                sprite:Play(data.RingAnim, true)
                data.State = "Ring"
            end
        end

    else
        npc.Velocity = npc.Velocity * bal.slowFactor

        if data.State == "Appear" then
            if sprite:IsFinished("Appear") then
                data.State = "Idle"
                npc.StateFrame = mod:RandomInt(bal.waitTime, rng)
            elseif sprite:IsEventTriggered("Coll") then
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            else
                mod:spritePlay(sprite, "Appear")
            end

        elseif data.State == "Leave" then
            if sprite:IsFinished("Leave") then
                npc:Remove()
            elseif sprite:IsEventTriggered("Coll") then
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            else
                mod:spritePlay(sprite, "Leave")
            end

        elseif data.State == "Ring" then
            if sprite:IsFinished(data.RingAnim) then
                data.State = "Idle"
                npc.StateFrame = mod:RandomInt(bal.waitTime, rng)
            elseif sprite:IsEventTriggered("Shoot") then
                local isGolden = (mod:CheckStage("Cathedral", {15}) or mod:CheckStage("Chest", {17}))

                mod:PlaySound(mod.Sounds.BellBoy, npc, 1, 3)
                local ringpos = npc.Position + ((data.BellDir == "Right") and Vector(-30,0) or Vector(30,0))
                npc.Velocity = npc.Velocity + (ringpos - npc.Position):Resized(10)
                game:MakeShockwave(ringpos, 0.035, 0.025, 10)

                local color = Color(1,0.3,0.3,0.7)
                if isGolden then
                    color = Color(1,0.8,0.3,0.7)
                end
                for i = 0, 2 do
                    mod:MakeLarynxWave(npc.Position, 40, 30 + (i * 10), npc, color)
                end
                for i = 1, 5 do
                    mod:MakeLarynxLine(npc.Position, mod:RandomInt(15,20,rng), 9, npc, color)
                end
                

                local filter = function(_, enemy)
                    return (enemy.Position:Distance(npc.Position) < bal.ringRadius + enemy.Size
                    and enemy:IsActiveEnemy() and enemy.InitSeed ~= npc.InitSeed
                    and (npc.CanShutDoors or enemy.EntityCollisionClass > EntityCollisionClass.ENTCOLL_NONE))
                end
                for _, enemy in pairs(mod:GetAllEnemies(filter)) do
                    local effect = Isaac.Spawn(mod.FF.ReverseBloodPoof.ID,mod.FF.ReverseBloodPoof.Var,mod.FF.ReverseBloodPoof.Sub,enemy.Position,Vector.Zero,npc):ToEffect()
                    effect:FollowParent(enemy)
                    effect.DepthOffset = enemy.Position.Y * 1.25
                    effect.ParentOffset = Vector(0,-10)
                    mod:GetEntityData(effect).BellBoy = true
                    if isGolden then
                        effect.Color = mod.ColorGolden
                    --[[else
                        effect.Color = mod.ColorSortaRed]]
                    end
                    effect:Update()
                end
            else
                mod:spritePlay(sprite, data.RingAnim)
            end
        end
    end

    if npc:IsDead() and npc.EntityCollisionClass >= EntityCollisionClass.ENTCOLL_ALL then
        npc:PlaySound(SoundEffect.SOUND_POT_BREAK, 1, 0, false, 1)
        mod:PlaySound(mod.Sounds.BellBoy, npc, 0.9, 3)
        for i = 1, 5 do
            local particle = Isaac.Spawn(1000, 4, 0, npc.Position, RandomVector()*mod:RandomInt(3,8), npc)
            particle:Update()
            particle:GetSprite():SetFrame("rubble_alt", mod:RandomInt(0,3))
        end
    end
end

function mod:BellBoyHurt(npc, amount, damageFlags, source)
    local data = mod:GetEntityData(npc)
    if data.State ~= "Ring" then
        local sourcepos = Isaac.GetRandomPosition()
        if source and source.Position then
            sourcepos = source.Position
        end
        data.BellDir = GetBellDir(npc, sourcepos)
        data.RingAnim = "Hit"..data.BellDir
        npc:GetSprite():Play(data.RingAnim, true)
        data.State = "Ring"
    end
    return false
end