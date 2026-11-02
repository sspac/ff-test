local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector(0, 0)

--soft serve ai - an ice cream cone of poo that runs towards the player, breaking apart as it goes on
function mod:softServeAI(npc,sprite,npcdata, var)

    --Initialisation
    if not npcdata.initcomplete then
        if not npcdata.scoopnumber then
            npcdata.scoopnumber = 3
        end
        npcdata.running = false
        npc.SplatColor = mod.ColorBrowniePoop
        npcdata.initcomplete = true
        npcdata.confuseangle = math.random(360)
        sprite:Play("appear" .. npcdata.scoopnumber, true);
    end

    npcdata.confuseangle = npcdata.confuseangle + math.random(-30, 30)

    --Constants
    if npcdata.initcomplete then
        mod:rancid(npc, 90, 240, 8, mod.rancidtable)
        if npc.FrameCount % (#mod.creepSpawnerCount * 4 - 1) == 0 then
            local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_SLIPPERY_BROWN, 0, npc.Position, Vector(0,0), npc):ToEffect();
            creep:Update();
        end
    end

    --Splattering / weight
    if npc:IsDead() and mod:shouldDoDeathEffect(npc) then
        if npcdata.scoopnumber ~= 0 then
            mod:softservesplatter(npc)
        end
        npcdata.running = false
        npc.Variant = mod.FF.Scoop.Var
        if npcdata.scoopnumber == 3 then
            npc.MaxHitPoints = npc.MaxHitPoints / 3
        elseif npcdata.scoopnumber == 2 then
            npc.MaxHitPoints = npc.MaxHitPoints / 2
        end
        npcdata.appeareded = true
        npcdata.scoopnumber = 1
        npc.Mass = 14
        npcdata.velocitymax = 9
    elseif ((var == 0 or var > 2) and npc.HitPoints <= (npc.MaxHitPoints/3)) or (var == 1 and npc.HitPoints <= (npc.MaxHitPoints/2)) then					-- If below 1/3 health
        if npcdata.scoopnumber == 3 or npcdata.scoopnumber == 2 then
            mod:softservesplatter(npc);
            npcdata.playpop = 2
            npcdata.running = false
            npc.Variant = mod.FF.Scoop.Var
            if npcdata.scoopnumber == 3 then
                npc.MaxHitPoints = npc.MaxHitPoints / 3
            elseif npcdata.scoopnumber == 2 then
                npc.MaxHitPoints = npc.MaxHitPoints / 2
            end
            npcdata.appeareded = true
        end
        npcdata.scoopnumber = 1
        npc.Mass = 14
        npcdata.velocitymax = 9
    elseif (var == 0 or var > 2) and npc.HitPoints <= (npc.MaxHitPoints*(2/3)) then				-- If below 2/3 health
        if npcdata.scoopnumber == 3 then
            mod:softservesplatter(npc);
            npcdata.playpop = 3
            npcdata.running = false
            npc.Variant = mod.FF.Sundae.Var
            npc.MaxHitPoints = npc.MaxHitPoints / 1.5
            npcdata.appeareded = true
        end
        npcdata.scoopnumber = 2
        npc.Mass = 17
        npcdata.velocitymax = 7
    else	-- If full health
        if var == 2 then
            npcdata.scoopnumber = 1
            npcdata.velocitymax = 9
        elseif var == 1 then
            npcdata.scoopnumber = 2
            npcdata.velocitymax = 7
        else
            npcdata.scoopnumber = 3
            npcdata.velocitymax = 5
        end
    end

    --Movement

    --Target Selection
    local target = npc:GetPlayerTarget()
    local targetpos
    if target and not npcdata.playpop and npcdata.appeareded then
        targetpos = target.Position
        npcdata.running = true
    else
        targetpos = npc.Position
        npcdata.running = false
    end

    if npcdata.running then

        targetpos = mod:randomConfuse(npc, targetpos)

        --Chase target
        if npc:HasEntityFlags(EntityFlag.FLAG_FEAR) or npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION) then
            local targetvelocity = (targetpos - npc.Position):Normalized() * npcdata.velocitymax
            if npc:HasEntityFlags(EntityFlag.FLAG_FEAR) then
                targetvelocity = targetvelocity * -1
            end
            local lerpy = 0.05
            if npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION) then
                targetvelocity = Vector(npcdata.velocitymax, 0):Rotated(npcdata.confuseangle)
                --lerpy = 0.3
            end
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, lerpy)
        else
            mod:CatheryPathFinding(npc, targetpos, {
            Speed = npcdata.velocitymax,
            Accel = 0.05,
            GiveUp = true
            })
        end

    end
    --Animate

    if npcdata.appeareded then
        if npcdata.playpop then

            if sprite:IsFinished("pop2") or sprite:IsFinished("pop3") then
                npcdata.playpop = false
                npcdata.running = true
            elseif npcdata.playpop == 2 then
                mod:spritePlay(sprite, "pop2")
            elseif npcdata.playpop == 3 then
                mod:spritePlay(sprite, "pop3")
            end

        elseif npcdata.running then
            if npc.Velocity:Length() > 0.1 then
            mod:spritePlay(sprite, "move" .. npcdata.scoopnumber)
            else
                mod:spritePlay(sprite, "idle" .. npcdata.scoopnumber)
            end
        else
            if not sprite:IsPlaying("idle" .. npcdata.scoopnumber) then
                sprite:Play("idle" .. npcdata.scoopnumber, true);
            end
        end
    else
        if sprite:IsFinished("appear" .. npcdata.scoopnumber) then
            npcdata.appeareded = true
        else
            if not sprite:IsPlaying("appear" .. npcdata.scoopnumber) then
                sprite:Play("appear" .. npcdata.scoopnumber, true);
            end
        end
    end
end