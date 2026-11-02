local mod = FiendFolio
local game = Game()

local ruinBal = {
    maxDist = 90,
    playerHop = 65,
    playerChase = 250,
    moveCooldown = {2, 17, 7},

    bombTimer = 75,
    chaseChance = 60,
    bombDamage = 15,
    bombDistance1 = 40,
    bombDistance2 = 100,
    bombDelay = 10,
    explodeResist = 0.66,
}

function mod:ruinerAI(npc)
    local target = npc:GetPlayerTarget()
    local d = mod:GetEntityData(npc)
    local sprite = npc:GetSprite()
    local rng = npc:GetDropRNG()

    if not d.init then
        d.myMoveTable = {
            {"Jump", 3},
            {"ExplodeStart", 1.1},
        }
        d.refreshLoop = 0
        d.state = "Idle"
        d.init = true
    else
        npc.StateFrame = npc.StateFrame+1
    end

    if d.state == "Idle" then
        local GO
        if npc.StateFrame > ruinBal.moveCooldown[1] and rng:RandomInt(ruinBal.moveCooldown[3]) == 0 then
            GO = true
        elseif npc.StateFrame > ruinBal.moveCooldown[2] then
            GO = true
        end
        if mod:isConfuse(npc) then
            if npc.StateFrame > ruinBal.moveCooldown[1] then
                d.state = "Jump"
                d.targetPosition = mod:FindRandomFreePos(npc, ruinBal.maxDist, true)
            end
        elseif mod:isScare(npc) then
            d.state = "Jump"
            d.targetPosition = npc.Position+(npc.Position-target.Position):Resized(70)
        elseif GO then
            local tab = mod:makeCopiedTable(d.myMoveTable)
            local special = -1
            if target.Position:Distance(npc.Position) < ruinBal.playerHop then
                special = 1
                tab = {{"Jump", 4}, {"ExplodeStart", 1}}
            elseif target.Position:Distance(npc.Position) < ruinBal.playerChase and rng:RandomInt(100) < ruinBal.chaseChance then
                special = 2
            end
            local result = mod:weightedRNG(tab, rng)
            if d.lastExplode then
                d.state = "Jump"
            else
                d.state = result
            end
            if result == "Jump" or d.lastExplode then
                d.lastExplode = nil
                if special == 1 then
                    d.targetPosition = target.Position
                elseif special == 2 then
                    d.targetPosition = mod:FindClosestValidPosition(npc, target, 40, ruinBal.maxDist, 0)
                else
                    d.targetPosition = mod:FindRandomFreePos(npc, ruinBal.maxDist, true)
                end
                d.myMoveTable[1][2] = d.myMoveTable[1][2]*0.8
            else
                npc:PlaySound(SoundEffect.SOUND_MONSTER_GRUNT_4, 1, 0, false, mod:RandomInt(90,110,rng)/100)
                d.bombTimer = ruinBal.bombTimer
                d.myMoveTable[2][2] = d.myMoveTable[2][2]*0.33
                d.lastExplode = true
            end
            d.refreshLoop = d.refreshLoop+1
            if d.refreshLoop > 5 then
                d.myMoveTable = {
                    {"Jump", 3},
                    {"ExplodeStart", 1.1},
                }
                d.refreshLoop = 0
            end
        end
        mod:spritePlay(sprite, "Down")
        npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.3)
        npc.FlipX = npc.Velocity.X < 0
    elseif d.state == "Explode" then
        if d.bombTimer <= 0 then
            npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
            d.state = "Exploded"
            npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.4)
            game:BombExplosionEffects(npc.Position, ruinBal.bombDamage, 0, nil, npc, 1, false, true, DamageFlag.DAMAGE_EXPLOSION)
            for i=1,4 do
                game:BombExplosionEffects(npc.Position+Vector(0,ruinBal.bombDistance1):Rotated(i*90), ruinBal.bombDamage, 0, nil, npc, 1, false, true, DamageFlag.DAMAGE_EXPLOSION)
            end
            mod.scheduleForUpdate(function()
                for i=1,4 do
                    game:BombExplosionEffects(npc.Position+Vector(0,ruinBal.bombDistance2):Rotated(i*90), ruinBal.bombDamage, 0, nil, npc, 1, false, true, DamageFlag.DAMAGE_EXPLOSION)
                end
                npc:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
            end, ruinBal.bombDelay)
        else
            if d.bombTimer > 60 then
                if sprite:GetFrame() > 14 then
                    sprite:SetFrame(0)
                end
            elseif d.bombTimer > 40 then
                if sprite:GetFrame() > 26 then
                    sprite:SetFrame(15)
                end
            elseif d.bombTimer > 20 then
                if sprite:GetFrame() > 46 then
                    sprite:SetFrame(29)
                end
            else
                if sprite:GetFrame() > 58 or sprite:IsFinished("Attack") then
                    sprite:SetFrame(51)
                end
            end
            mod:spritePlay(sprite, "Attack")
            d.bombTimer = d.bombTimer-1
        end

        npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.04)
    elseif d.state == "Exploded" then
        if sprite:IsFinished("Exploded") then
            d.state = "Idle"
            npc.StateFrame = 0
        else
            mod:spritePlay(sprite, "Exploded")
        end

        npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.3)
        npc.FlipX = npc.Velocity.X < 0
    elseif d.state == "ExplodeStart" then
        if sprite:IsFinished("AttackPrime") then
            d.state = "Explode"
            d.bombTimer = ruinBal.bombTimer
            sprite:Play("Attack")
        else
            mod:spritePlay(sprite, "AttackPrime")
        end

        npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.1)
        npc.FlipX = npc.Velocity.X < 0
    elseif d.state == "Jump" then
        if sprite:IsFinished("JumpDown") then
            d.state = "Idle"
            npc.StateFrame = 0
            d.targetPosition = nil
        elseif sprite:IsEventTriggered("Jump") then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
            d.jumping = true
        elseif sprite:IsEventTriggered("Land") then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
            d.jumping = nil
            npc:PlaySound(SoundEffect.SOUND_MEAT_IMPACTS, 1, 0, false, mod:RandomInt(95,115,rng)/100)
        else
            mod:spritePlay(sprite, "JumpDown")
        end
        if d.jumping then
            local vel = ((d.targetPosition or npc.Position)-npc.Position)*0.2
            npc.Velocity = mod:Lerp(npc.Velocity, vel, 0.3)
        else
            npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.3)
        end
        
        npc.FlipX = npc.Velocity.X < 0
    end
end

function mod:ruinerHurt(ent, damage, flag, source)
    if source and source.Entity and source.Entity.Type == mod.FF.Ruiner.ID and source.Entity.Variant == mod.FF.Ruiner.Var and flag == flag | DamageFlag.DAMAGE_EXPLOSION then
        return false
    elseif mod:GetEntityData(ent).state == "Explode" and flag ~= flag | DamageFlag.DAMAGE_CLONES then
        ent:TakeDamage(damage*ruinBal.explodeResist, flag | DamageFlag.DAMAGE_CLONES, source, 0)
        return false
    end
end