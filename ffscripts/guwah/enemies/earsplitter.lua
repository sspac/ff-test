local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local bal = {
    hitboxWidth = 1.5,
    moveSpeed = 2,
    vertMoveSpeedMult = 1.3,
    chargeCooldown = {90,120},
    earlyChargeMaxTime = 60,
    chargeSpeed = 15,
    chargeGap = 13,
    totalCharges = 2,
    roomMargin = 120,
    knifeInitChargeSpeed = 20,
    earHPMult = 0.75,
}

local function HaemoTrail(npc)
    local rng = npc:GetDropRNG()
    if rng:RandomFloat() <= 0.75 then
        local chargingUp = mod:GetEntityData(npc).AnimSuffix == "Up"
        local trail = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HAEMO_TRAIL, 0, npc.Position + (RandomVector() * mod:RandomInt(0,5,rng)), -npc.V1:Resized(mod:RandomInt(5,10,rng)), npc):ToEffect()
        trail.SpriteScale = Vector(0.7,0.7)
        trail.SpriteOffset = Vector(0, chargingUp and -10 or -25)
        trail.DepthOffset = chargingUp and 0 or -20
        trail:Update()
    end
end

local function LarynxEffects(npc)
    local color = Color(1,0.3,0.3,0.7)
    for i = 1, 6 do
        local line = mod:MakeLarynxLine(npc.Position, mod:RandomInt(15,25,npc:GetDropRNG()), 10, npc, color)
        line:FollowParent(npc)
    end
    local wave = mod:MakeLarynxWave(npc.Position, 30, 30, npc, color)
    wave:FollowParent(npc)
end

local function FireBlade(npc)
	local chargeLeft = npc:GetSprite().FlipX
    local chargeVel = chargeLeft and Vector(-bal.knifeInitChargeSpeed, 0) or Vector(bal.knifeInitChargeSpeed, 0)
    local blade = Isaac.Spawn(mod.FF.EarSplitterBlade.ID, mod.FF.EarSplitterBlade.Var, 0, npc.Position + chargeVel:Resized(30), chargeVel, npc):ToNPC()
    blade.V1 = chargeVel
    blade.Scale = npc.Scale
    blade:GetSprite().FlipX = chargeLeft
    mod:GetEntityData(blade).ChargingLeft = chargeLeft
    LarynxEffects(npc)
    npc:PlaySound(SoundEffect.SOUND_LARYNX_SCREAM_HI, 1, 0, false, (1.5 + (mod:RandomInt(-2,2, npc:GetDropRNG())/10)))
	game:ShakeScreen(10)
end

function mod:EarSplitterAI(npc, sprite, data)
    local targetpos = mod:confusePos(npc, npc:GetPlayerTarget().Position)
    local room = game:GetRoom()
    local rng = npc:GetDropRNG()

    if not data.Init then
        npc.StateFrame = mod:RandomInt(bal.chargeCooldown, rng)
        npc.SizeMulti = Vector(bal.hitboxWidth, 1)
        data.State = "Idle"
        data.Init = true
    end

    if data.State == "Idle" then
        mod:SpritePlay(sprite, "Idle")
        mod:FlipSprite(sprite, npc.Position, targetpos)

        local moveVel = (targetpos - npc.Position):Resized(bal.moveSpeed)
        npc.Velocity = mod:Lerp(npc.Velocity, mod:reverseIfFear(npc, Vector(moveVel.X, moveVel.Y * bal.vertMoveSpeedMult)), 0.3)

        npc.StateFrame = npc.StateFrame - 1
        if npc.StateFrame <= 0 or (npc.StateFrame <= bal.earlyChargeMaxTime and math.abs(targetpos.Y - npc.Position.Y) <= 40 and rng:RandomFloat() <= 0.25) then
            data.ChargingLeft = npc.Position.X > targetpos.X
            sprite.FlipX = data.ChargingLeft
            npc.TargetPosition = npc.Position
            npc.V1 = data.ChargingLeft and Vector(-bal.chargeSpeed, 0) or Vector(bal.chargeSpeed, 0)
            data.State = "ChargeStart"
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
        end
    
    elseif data.State == "ChargeStart" then
        npc.Velocity = npc.Velocity * 0.8

        if sprite:IsFinished("ChargeStart") then
            data.AnimSuffix = "Hori"
            data.State = "Charging"
            data.HurtingEnemies = true
            data.HurtList = {}
            npc.I1 = bal.totalCharges
            npc.StateFrame = 15
            LarynxEffects(npc)
            npc:PlaySound(SoundEffect.SOUND_LARYNX_SCREAM_MED, 1, 0, false, (2 + (mod:RandomInt(-2,2, npc:GetDropRNG())/10)))
        else
            mod:SpritePlay(sprite, "ChargeStart")
        end

    elseif data.State == "Charging" then
        mod:SpritePlay(sprite, "Charge"..data.AnimSuffix)
        npc.Velocity = mod:Lerp(npc.Velocity, npc.V1, 0.3)
        HaemoTrail(npc)
       
        if npc.I1 <= 0 then
            if ((npc.Position.X < npc.TargetPosition.X and data.ChargingLeft) or (npc.Position.X > npc.TargetPosition.X and not data.ChargingLeft)) and room:IsPositionInRoom(npc.Position, 0) then
                data.State = "ChargeStop"
                data.HurtingEnemies = false
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
            end
        end
        npc.StateFrame = npc.StateFrame - 1
        if npc.StateFrame <= 0 and not room:IsPositionInRoom(npc.Position, -bal.roomMargin) then
            npc.I1 = npc.I1 - 1
            npc.StateFrame = 15
            if npc.I1 <= 0 then
                npc.V1 = data.ChargingLeft and Vector(-bal.chargeSpeed, 0) or Vector(bal.chargeSpeed, 0)
                npc.V2 = Vector(data.ChargingLeft and room:GetBottomRightPos().X + bal.roomMargin or room:GetTopLeftPos().X - bal.roomMargin, npc:GetPlayerTarget().Position.Y)
                data.AnimSuffix = "Hori"
                data.State = "ChargeWait"
                npc.StateFrame = bal.chargeGap
                npc.SizeMulti = Vector(bal.hitboxWidth, 1)
                mod:FadeOut(npc, 10)
            else
                local chargeUp = npc:GetPlayerTarget().Position.Y < room:GetCenterPos().Y
                npc.V1 = chargeUp and Vector(0, -bal.chargeSpeed) or Vector(0, bal.chargeSpeed)
                npc.V2 = Vector(npc:GetPlayerTarget().Position.X, chargeUp and room:GetBottomRightPos().Y + bal.roomMargin or room:GetTopLeftPos().Y - bal.roomMargin)
                data.AnimSuffix = chargeUp and "Up" or "Down"
                data.State = "ChargeWait"
                npc.StateFrame = bal.chargeGap
                npc.SizeMulti = Vector(1, bal.hitboxWidth)
                mod:FadeOut(npc, 10)
            end
        end

    elseif data.State == "ChargeWait" then
        --npc.Visible = false
        npc.StateFrame = npc.StateFrame - 1
        if npc.StateFrame <= 0 then 
            npc.Position = npc.V2
            npc.Velocity = Vector.Zero --npc.V1
            data.State = "Charging"
            data.HurtingEnemies = true
            data.HurtList = {}
            mod:SpritePlay(sprite, "Charge"..data.AnimSuffix)
            npc.Color = mod:CloneColor(npc.Color, 1)
            mod:FadeIn(npc, 5)
        end

    elseif data.State == "ChargeStop" then
        npc.Velocity = npc.Velocity * 0.8

        if sprite:IsFinished("ChargeStop") then
            npc.StateFrame = mod:RandomInt(bal.chargeCooldown, rng)
            data.State = "Idle"
        else
            mod:SpritePlay(sprite, "ChargeStop")
        end

    elseif data.State == "Shoot" then
        npc.Velocity = npc.Velocity * 0.8

        if sprite:IsFinished("Shoot") then
            npc.StateFrame = mod:RandomInt(bal.chargeCooldown, rng)
            data.State = "Idle"
        elseif sprite:IsEventTriggered("Shoot") then
            FireBlade(npc)
            npc:BloodExplode()
        else
            mod:SpritePlay(sprite, "Shoot")
        end

    elseif data.State == "Death" then
        if sprite:IsFinished("Death") then
            FiendFolio.EarSplitterDeathEffect(npc)
            npc:Kill()
        else
            mod:spritePlay(sprite, "Death")
        end

        if sprite:WasEventTriggered("BloodStart") and not sprite:WasEventTriggered("BloodStop") then
            if sprite:GetFrame() % 2 == 0 then
                sfx:Play(SoundEffect.SOUND_MEAT_JUMPS)
                local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 2, npc.Position, Vector.Zero, npc)
                poof.SpriteOffset = Vector(0,-25) + (RandomVector() * mod:RandomInt(5,40,rng))
                poof.DepthOffset = 20
            end
        end
    end
end

function mod:EarSplitterColl(npc, collider)
    if npc.FrameCount > 5 and collider:ToNPC() then
        local data = mod:GetEntityData(npc)
        if data.HurtingEnemies and not mod:Contains(data.HurtList, collider.InitSeed) then
            collider:TakeDamage(40, 0, EntityRef(npc), 0)
            table.insert(data.HurtList, collider.InitSeed)
        end
    end
end

function FiendFolio.EarSplitterDeathAnim(npc)
	local onCustomDeath = function(npc, deathAnim)
        mod:GetEntityData(npc).State = "Death"
        mod:GetEntityData(deathAnim).State = "Death"
        mod:GetEntityData(deathAnim).Init = true
        mod:FlipSprite(deathAnim:GetSprite(), npc.Position, npc:GetPlayerTarget().Position)
    end
    FiendFolio.genericCustomDeathAnim(npc, "Death", true, onCustomDeath, false, false, true, true)
end

function FiendFolio.EarSplitterDeathEffect(npc)
	FireBlade(npc)
    local spawnDist = 30
    local subOffset = chargeLeft and 1 or 0
    for i = 1, 3, 2 do
        local ear = Isaac.Spawn(mod.FF.SplitEar.ID, mod.FF.SplitEar.Var, subOffset + i, npc.Position + Vector(chargeLeft and spawnDist or -spawnDist, i == 3 and -spawnDist or spawnDist), Vector.Zero, npc):ToNPC()
        if npc:IsChampion() then
            ear:MakeChampion(69, npc:GetChampionColorIdx(), true)
        end
        ear:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        ear:ReplaceSpritesheet(0, "gfx/enemies/splitear/splitear_bloody.png", true)
        ear.HitPoints = ear.HitPoints * bal.earHPMult
    end
end

function mod:EarSplitterBladeAI(npc, sprite, data)
    local target = npc:GetPlayerTarget()
    local room = game:GetRoom()

    if not data.Init then
        npc.StateFrame = 15
        npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        npc:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS + EntityFlag.FLAG_NO_TARGET + EntityFlag.FLAG_HIDE_HP_BAR + EntityFlag.FLAG_NO_FLASH_ON_DAMAGE + EntityFlag.FLAG_NO_REWARD + EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
        npc.SizeMulti = Vector(bal.hitboxWidth, 1)
        data.HurtingEnemies = true
        data.HurtList = {}
        data.Init = true
    end

    mod:SpritePlay(sprite, "Projectile")
    if room:IsClear() then
        npc:Kill()
    else
        if data.Waiting then
            npc.StateFrame = npc.StateFrame - 1
            if npc.StateFrame <= 0 then 
                data.HurtList = {}
                npc.Position = npc.V2
                npc.Velocity = Vector.Zero --npc.V1
                data.Waiting = false
                npc.Color = mod:CloneColor(npc.Color, 1)
                mod:FadeIn(npc, 5)
            end
        else
            npc.Velocity = mod:Lerp(npc.Velocity, npc.V1, 0.3)
            HaemoTrail(npc)
            npc.StateFrame = npc.StateFrame - 1
            if npc.StateFrame <= 0 and not room:IsPositionInRoom(npc.Position, -bal.roomMargin) then
                npc.StateFrame = 15
                npc.V1 = data.ChargingLeft and Vector(-bal.chargeSpeed, 0) or Vector(bal.chargeSpeed, 0)
                npc.V2 = Vector(data.ChargingLeft and room:GetBottomRightPos().X + bal.roomMargin or room:GetTopLeftPos().X - bal.roomMargin, npc:GetPlayerTarget().Position.Y)
                data.Waiting = true
                npc.StateFrame = bal.chargeGap
                mod:FadeOut(npc, 10)
            end
        end
    end

    if npc:IsDead() then
        npc:PlaySound(SoundEffect.SOUND_POT_BREAK, 1, 0, false, 1)   
        npc:PlaySound(SoundEffect.SOUND_SCYTHE_BREAK, 1, 0, false, 0.8)
        for i = 1, 12 do
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.NAIL_PARTICLE, 0, npc.Position, RandomVector():Resized(mod:RandomInt(3,10,rng)), npc)
        end
        local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.IMPACT, 0, npc.Position, Vector.Zero, npc)
        poof.SpriteOffset = Vector(0,-20)
        --poof.SpriteScale = Vector(1.5,1.5)
    end
end