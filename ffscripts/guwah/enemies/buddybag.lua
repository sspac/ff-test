local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local bal = {
    moveSpeed = 3,
    slowSpeed = 0.5,
    initWait = {60,90},
    waitTime = {150,210},
    baseCap = 1,
    spawnCap = 2,
}

function mod:BuddybagAI(npc, sprite, data)
    local targetpos = mod:confusePos(npc, npc:GetPlayerTarget().Position)
    local rng = npc:GetDropRNG()
    local room = game:GetRoom()

    if not data.Init then
        data.State = "Idle"
        npc.StateFrame = mod:RandomInt(bal.initWait, rng)
        data.Init = true
    end

    if data.State == "Idle" then
        if npc.FrameCount > 0 then
            data.newhome = data.newhome or mod:GetNewPosAligned(npc.Position)
            if npc.Position:Distance(data.newhome) < 20 
            or npc.Velocity:Length() < 0.3 
            or (not room:CheckLine(data.newhome,npc.Position,0,900,false,false)) 
            or (mod:isConfuse(npc) and npc.StateFrame % 10 == 0) then
                data.newhome = mod:GetNewPosAligned(npc.Position)
            end

            if sprite:IsEventTriggered("StartStep") then
                data.Movin = true
            elseif sprite:IsEventTriggered("StopStep") then
                data.Movin = false
                mod:PlaySound(SoundEffect.SOUND_SCAMPER, npc, 0.4, 0.2)
            end
            local speed = bal.slowSpeed
            if data.Movin then
                speed = bal.moveSpeed
            end
            npc.Velocity = mod:Lerp(npc.Velocity, (data.newhome - npc.Position):Resized(speed), 0.3)
            mod:AnimWalkFrame(npc, sprite, "walkhori", {"walkdown", "walkup"}, true, "idle", 0.01)
            

            npc.StateFrame = npc.StateFrame - 1
            if npc.StateFrame <= 0 then
                local cap = bal.baseCap + (mod.GetEntityCountConsiderFriend(npc,mod.FF.Buddybag.ID, mod.FF.Buddybag.Var) * bal.spawnCap)
                if cap > mod.GetEntityCountConsiderFriend(npc,mod.FF.Wimpy.ID, mod.FF.Wimpy.Var) then
                    data.State = "Spawn"
                else
                    npc.StateFrame = mod:RandomInt(bal.waitTime, rng)
                end
            end
        end

    elseif data.State == "Spawn" then
        npc.Velocity = npc.Velocity * 0.7
        if sprite:IsFinished("firebuddy") then
            data.State = "Idle"
            data.newhome = nil
            data.Movin = false
            npc.StateFrame = mod:RandomInt(bal.waitTime, rng)
        elseif sprite:IsEventTriggered("rarr") then
            mod:PlaySound(SoundEffect.SOUND_LOW_INHALE, npc, 1.5, 0.8)
            mod:PlaySound(SoundEffect.SOUND_MONSTER_GRUNT_1, npc, 1.5, 0.8)
        elseif sprite:IsEventTriggered("Shoot") then
            local wimpy = Isaac.Spawn(mod.FF.Wimpy.ID, mod.FF.Wimpy.Var, 0, npc.Position, Vector.Zero, npc):ToNPC()
            wimpy.State = 8
            wimpy.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            wimpy:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            wimpy:GetSprite():Play("Jump", true)
            wimpy:GetSprite():SetFrame(9)
            mod:GetEntityData(wimpy).init = true
            mod:GetEntityData(wimpy).Wait = 0
            wimpy:Update()

            local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 2, npc.Position, Vector.Zero, npc)
            effect.SpriteOffset = Vector(0,-28)
            effect.DepthOffset = npc.Position.Y * 1.25
            effect.SpriteScale = Vector(1.25,0.75)
            effect.Color = Color(1,1,1,0.6,0.2)
            effect:Update()

            mod:PlaySound(SoundEffect.SOUND_MEAT_JUMPS, npc)
            mod:PlaySound(SoundEffect.SOUND_MEATY_DEATHS, npc, 1, 0.7)
            mod:PlaySound(mod.Sounds.PiperAttack, npc, 0.8, 0.7)
        else
            mod:spritePlay(sprite, "firebuddy")
        end
    end

    if npc:IsDead() and mod:shouldDoDeathEffect(npc) then
        --[[local num = mod:RandomInt(5,8,rng)
        local angle = mod:RandomAngle(rng)
        local params = ProjectileParams()
        params.FallingAccelModifier = 2
        for i = 360/num, 360, 360/num do
            params.FallingSpeedModifier = mod:RandomInt(-40,-15,rng)
            params.Scale = mod:RandomInt(8,14,rng) * 0.1
            npc:FireProjectiles(npc.Position, Vector(mod:RandomInt(1,3,rng),0):Rotated(angle + i + mod:RandomInt(-20,20,rng)), 0, params)			
        end]]
    
        local wimpy = Isaac.Spawn(mod.FF.Wimpy.ID, mod.FF.Wimpy.Var, 0, npc.Position, Vector.Zero, npc):ToNPC()
        wimpy.Scale = 1.3
        wimpy.MaxHitPoints = wimpy.MaxHitPoints * 1.5
        wimpy.HitPoints = wimpy.MaxHitPoints
    end
end