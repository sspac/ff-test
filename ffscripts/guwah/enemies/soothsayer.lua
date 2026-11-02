local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

--For testing
local attackRollOverride = nil
local forceRareAttacks = false

local bal = {
    moveSpeed = 5,
    runSpeed = 7,
    spinStartSpeedMult = 0.5,
    spinCooldown = {20,30},
    spinTime = {40,60},
    spinSpeedMult = 1.25,
    numAttacks = 11,
    numRareAttacks = 3,
    rareAttackChance = 0.05,
    rareAttackCooldown = 2,
    attackingSpeedMult = 0.25,
    selfDmgResist = 0.5,

    pinkProjSpeed = 10,

    redFlies = {2,3},
    redNonFlies = 2,
    redNonFlySpawnDist = 120,

    orangeProjSpeed = 6,

    yellowLasers = 6,
    yellowLaserDelay = 25,

    greenProjSpeed = 6,

    cyanBubbleAmount = {6,8},
    cyanBubbleSubs = {mod.FF.BubbleSmall.Sub, mod.FF.BubbleMed.Sub, mod.FF.BubbleLarge.Sub},
    cyanBubbleSpeed = {2,4},

    blueProjCount = 8,
    blueProjSpeed = 10,

    purpleProjSpeed = 6,

    whiteBeamDuration = 30,

    grayBoneSpeed = 8,

    brownFartRadius = 80,
}

mod.SoothsayerRerollList = { --This list is based on natural observed D10 rerolls + some manual ommisions/additions
    {mod.FF.Skulltist.ID, mod.FF.Skulltist.Var},
    {mod.FF.NewYear.ID, mod.FF.NewYear.Var},
    {mod.FF.Madhat.ID, mod.FF.Madhat.Var},
    {mod.FF.Grimoire.ID, mod.FF.Grimoire.Var},
    {mod.FF.Soothsayer.ID, mod.FF.Soothsayer.Var}, --lol
    {EntityType.ENTITY_CULTIST, 0},
    {EntityType.ENTITY_CULTIST, 1}, --Blood Cultist
    {mod.FF.Clergy.ID, mod.FF.Clergy.Var},
    {mod.FF.Shi.ID, mod.FF.Shi.Var},
    {mod.FF.ScytheRider.ID, mod.FF.ScytheRider.Var},
    {mod.FF.PitchforkHitcher.ID, mod.FF.PitchforkHitcher.Var},
    {mod.FF.Myiasis.ID, mod.FF.Myiasis.Var},
    {mod.FF.Crosseyes.ID, mod.FF.Crosseyes.Var},
    {mod.FF.Marzy.ID, mod.FF.Marzy.Var, nil, true},
    {mod.FF.Foe.ID, mod.FF.Foe.Var},
    {mod.FF.Dangler.ID, mod.FF.Dangler.Var},
    {mod.FF.Tango.ID, mod.FF.Tango.Var},
    {mod.FF.Pyroclasm.ID, mod.FF.Pyroclasm.Var},
    {mod.FF.Ghostse.ID, mod.FF.Ghostse.Var},
    {mod.FF.Mistmonger.ID, mod.FF.Mistmonger.Var},
    {mod.FF.Rosie.ID, mod.FF.Rosie.Var, nil, true},
    {mod.FF.SplitEar.ID, mod.FF.SplitEar.Var},
    {mod.FF.HolyWobbles.ID, mod.FF.HolyWobbles.Var},
    {mod.FF.Cherub.ID, mod.FF.Cherub.Var},
    {mod.FF.UmbraBlistered.ID, mod.FF.UmbraBlistered.Var, {1,2}},
    {mod.FF.Hyperbole.ID, mod.FF.Hyperbole.Var},
    {mod.FF.Premonition.ID, mod.FF.Premonition.Var},
    {mod.FF.Limbone.ID, mod.FF.Limbone.Var, mod.FF.Limbone.Sub, true},
    {mod.FF.Shitling.ID, mod.FF.Shitling.Var, nil, true},
    {mod.FF.Trihorf.ID, mod.FF.Trihorf.Var, nil, true},
    {EntityType.ENTITY_POLTY, 1}, --Kineti
    {EntityType.ENTITY_TUMOR, 1}, --Planetoid
    {EntityType.ENTITY_RING_OF_FLIES, 0}, --Ring Fly
    {mod.FF.RingOfRingFlies.ID, mod.FF.RingOfRingFlies.Var},
    {EntityType.ENTITY_VIS_FATTY, 1}, --Fetal Demon
    {EntityType.ENTITY_SUCKER, 2}, --Soul Sucker
    {EntityType.ENTITY_MOCKULUS, 0},
    {EntityType.ENTITY_FLOATING_HOST, 0},
    {EntityType.ENTITY_SHOPKEEPER, 0, nil, true},
    {EntityType.ENTITY_SHOPKEEPER, 3}, --Hanging Shopkeeper
}

function mod:RerollIntoEnemyFromList(npc, list, fallbackEntry)
    local rerollEntry = fallbackEntry or {EntityType.ENTITY_ATTACKFLY, 0, 0}
    local rng = npc:GetDropRNG()
    local canRerollIntoGrounded = (game:GetRoom():GetGridCollisionAtPos(npc.Position) <= GridCollisionClass.COLLISION_NONE and not mod:AmISoftlocked(npc, false))
    for i = 1, 10 do
        local entry = mod:GetRandomElem(list, rng)
        if canRerollIntoGrounded or not entry[4] then
            rerollEntry = entry
            break
        end
    end
    --npc:Morph(rerollEntry[1], rerollEntry[2] or 0, rerollEntry[3] or 0, npc:GetChampionColorIdx()) --Better to just respawn the enemy
    if type(rerollEntry[3]) == "table" then
        rerollEntry[3] = mod:GetRandomElem(rerollEntry[3], rng)
    end
    local newEnemy = Isaac.Spawn(rerollEntry[1], rerollEntry[2] or 0, rerollEntry[3] or 0, npc.Position, Vector.Zero, npc.SpawnerEntity):ToNPC()
    if npc:IsChampion() and newEnemy:GetEntityConfigEntity():CanBeChampion() then
        newEnemy:MakeChampion(69, npc:GetChampionColorIdx(), true)
        newEnemy.HitPoints = newEnemy.MaxHitPoints
    end
    npc:Remove()
    return newEnemy
end

local function DoMoving(npc, speedMult, attacking)
    speedMult = speedMult or 1
    local rng = npc:GetDropRNG()
    local targetpos = mod:confusePos(npc, npc:GetPlayerTarget().Position)

    if npc.I2 <= 0 then
        npc.I2 = mod:RandomInt(10,15,rng)
        if attacking and not game:GetRoom():CheckLine(npc.Position,targetpos,3,0,false,false) then
            npc.V1 = (npc.Position - targetpos):Resized(bal.runSpeed * speedMult * 2):Rotated(mod:RandomInt(-15,15,rng))
        elseif targetpos:Distance(npc.Position) < (attacking and 60 or 100) or mod:isScare(npc) then
            npc.V1 = (targetpos - npc.Position):Resized(bal.runSpeed * speedMult):Rotated(mod:RandomInt(-15,15,rng))
        else
            npc.V1 = (npc.Position - targetpos):Resized(bal.moveSpeed * speedMult):Rotated(mod:RandomInt(-120,120,rng))
        end
    else
        npc.I2 = npc.I2 - 1
    end
    npc.Velocity = mod:Lerp(npc.Velocity, npc.Position - (npc.Position + npc.V1), 0.1)
end

local pinkParams = ProjectileParams()
pinkParams.Color = mod.ColorHotPink
pinkParams.Scale = 1.5
pinkParams.Damage = 1
pinkParams.BulletFlags = ProjectileFlags.NO_WALL_COLLIDE
pinkParams.Spread = 2

local orangeParams = ProjectileParams()
orangeParams.Color = mod.ColorCrackleOrange
orangeParams.Scale = 2
orangeParams.FallingSpeedModifier = -25
orangeParams.FallingAccelModifier = 1.5
orangeParams.BulletFlags = ProjectileFlags.FIRE_WAVE | ProjectileFlags.NO_WALL_COLLIDE

local greenParams = ProjectileParams()
greenParams.Color = mod.ColorIpecacProper
greenParams.Scale = 2
greenParams.FallingSpeedModifier = -25
greenParams.FallingAccelModifier = 1.5
greenParams.BulletFlags = ProjectileFlags.EXPLODE | ProjectileFlags.ACID_GREEN | ProjectileFlags.NO_WALL_COLLIDE

local blueParams = ProjectileParams()
blueParams.Color = mod.ColorRainbowBlue
blueParams.Scale = 1.5
blueParams.Damage = 1
blueParams.FallingAccelModifier = -0.1

local purpleParams = ProjectileParams()
purpleParams.Variant = ProjectileVariant.PROJECTILE_TEAR
purpleParams.Color = mod.ColorPsyGrape2
purpleParams.Scale = 3
purpleParams.FallingSpeedModifier = -15
purpleParams.BulletFlags = ProjectileFlags.NO_WALL_COLLIDE

local function DoShootPoof(npc, variant, sub, color, renderBelow, alpha, vel)
    local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, variant or EffectVariant.BLOOD_EXPLOSION, sub or 5, npc.Position, vel or Vector.Zero, npc)
    poof.PositionOffset = npc:GetNullOffset("EffectPos")
    poof.Color = mod:CloneColor(color or Color.Default, alpha or 0.75)
    poof.DepthOffset = renderBelow and -80 or 40
    if variant == mod.FF.FFWhiteSmoke.Var and sub == mod.FF.FFWhiteSmoke.Sub then
        mod:GetEntityData(poof).longonly = true
    end
    return poof
end

local function BigGore(npc)
    npc:AddEntityFlags(EntityFlag.FLAG_EXTRA_GORE)
    npc:BloodExplode()
    npc:ClearEntityFlags(EntityFlag.FLAG_EXTRA_GORE)
end

local function DoSoothsayerAttack(npc, rare)
    local rng = npc:GetDropRNG()
    local targetpos = mod:confusePos(npc, npc:GetPlayerTarget().Position)

    if rare then
        if npc.I1 == 1 then --Elipsis (split into two)
            BigGore(npc)
            mod:PlaySound(SoundEffect.SOUND_KNIFE_PULL, npc)
            npc:TrySplit(0, EntityRef(npc), true)
    
        elseif npc.I1 == 2 then --Question Mark (reroll)
            BigGore(npc)
            mod:PlaySound(910, npc, 0.8, 2)
            mod:PlaySound(SoundEffect.SOUND_EDEN_GLITCH, npc)
            mod:RerollIntoEnemyFromList(npc, mod.SoothsayerRerollList)

        elseif npc.I1 == 3 then --Exclamation Mark (giga explosion)
            npc:AddEntityFlags(EntityFlag.FLAG_EXTRA_GORE)
            game:BombExplosionEffects(npc.Position, 300, TearFlags.TEAR_GIGA_BOMB, Color.Default, npc, 1)
            npc:Kill()
        end

    else
        if npc.I1 == 1 then --Pink Fan
            npc:FireProjectiles(npc.Position, (targetpos - npc.Position):Resized(bal.pinkProjSpeed), ProjectileMode.SPREAD_THREE, pinkParams)
            DoShootPoof(npc, nil, nil, mod.ColorHotPink)
            mod:PlaySound(SoundEffect.SOUND_BLOODSHOOT, npc, 0.8, 1.2)
            mod:PlaySound(SoundEffect.SOUND_BOSS_LITE_HISS, npc)

        elseif npc.I1 == 2 then --Red Swirl
            local areBishops = (mod.GetEntityCount(EntityType.ENTITY_BISHOP) > 0)
            for i = 1, (areBishops and 1 or mod:RandomInt(bal.redFlies, rng)) do
                local vec = (targetpos - npc.Position):Resized(mod:RandomInt(2,5,rng)):Rotated(mod:RandomInt(-45,45,rng))
                local fly = Isaac.Spawn(EntityType.ENTITY_ATTACKFLY, 0, 0, npc.Position + vec:Resized(10), vec, npc)
                fly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                fly:SetColor(mod.ColorDecentlyRed,30,1,true,false)
            end
            local lastSpawnPos
            for i = 1, (areBishops and 1 or bal.redNonFlies) do
                local targetspan = targetpos - npc.Position
                if targetspan:Length() > bal.redNonFlySpawnDist then
                    targetspan = targetspan:Resized(bal.redNonFlySpawnDist)
                end
                spawnpos = mod:FindSafeSpawnSpot(npc.Position + targetspan, (bal.redNonFlySpawnDist / 2) - 10, nil, false)
                if spawnpos == nil or (spawnpos and lastSpawnPos and spawnpos:Distance(lastSpawnPos) < 30) then
                    spawnpos = mod:FindSafeSpawnSpot(npc.Position, bal.redNonFlySpawnDist, bal.redNonFlySpawnDist + 40, true)
                end
                spawnPos = spawnpos + RandomVector():Resized(mod:RandomInt(0,15,rng))
                lastSpawnPos = spawnPos
                if rng:RandomFloat() <= 0.5 then
                    local skuzz = Isaac.Spawn(mod.FF.Skuzz.ID, mod.FF.Skuzz.Var, 0, npc.Position, ((spawnpos - npc.Position) / 15) * 0.9, npc)
                    mod:GetEntityData(skuzz).jumpytimer = 0
                    mod:GetEntityData(skuzz).state = "hop"
                    skuzz.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                    skuzz.GridCollisionClass = GridCollisionClass.COLLISION_NONE
                    skuzz:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                    skuzz:Update()
                    skuzz:SetColor(mod.ColorDecentlyRed,30,1,true,false)
                else    
                    local spider = EntityNPC.ThrowSpider(npc.Position, npc, spawnpos, false, mod:RandomInt(-45,-30,rng))
                    spider.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
                    mod:GetEntityData(spider).RestoreGroundCollision = true
                    spider:SetColor(mod.ColorDecentlyRed,30,1,true,false)
                end
            end
            DoShootPoof(npc, nil, nil, mod.ColorModeratelyRed)
            mod:PlaySound(SoundEffect.SOUND_SUMMONSOUND, npc)
            mod:PlaySound(SoundEffect.SOUND_PORTAL_SPAWN, npc, 1, 1.5)

        elseif npc.I1 == 3 then --Orange Flame
            npc:FireProjectiles(npc.Position, (targetpos - npc.Position):Resized(bal.orangeProjSpeed), ProjectileMode.SINGLE, orangeParams)
            DoShootPoof(npc, nil, 2, mod.ColorCrackleOrange)
            mod:PlaySound(SoundEffect.SOUND_BLOODSHOOT, npc, 0.8, 1.2)
            mod:PlaySound(SoundEffect.SOUND_WAR_FLAME, npc, 1.2, 0.8)

        elseif npc.I1 == 4 then --Yellow Bolt
            local offset = mod:RandomAngle(rng)
            for i = 360/bal.yellowLasers, 360, 360/bal.yellowLasers do
                local laser = Isaac.Spawn(1000, 1737, 0, npc.Position, Vector.FromAngle(i + offset):Resized(6), npc):ToEffect()
                mod:GetEntityData(laser).delay = bal.yellowLaserDelay
                mod:GetEntityData(laser).timeout = 8
                mod:GetEntityData(laser).DoesntPush = true
                laser:Update()
                mod:GetEntityData(laser).offsetSpawn = Vector(0,-20)
                laser.Parent = npc
                laser:Update()
                laser.Color = mod.ColorElectricYellow
            end
            DoShootPoof(npc, nil, 3, mod.ColorElectricYellow, true, 1.0)
            mod:PlaySound(SoundEffect.SOUND_LASERRING_WEAK, npc, 0.8)

        elseif npc.I1 == 5 then --Green Droplet
            npc:FireProjectiles(npc.Position, (targetpos - npc.Position):Resized(bal.greenProjSpeed), ProjectileMode.SINGLE, greenParams)
            DoShootPoof(npc, nil, 2, mod.ColorBobsGreen)
            mod:PlaySound(SoundEffect.SOUND_HEARTOUT, npc)

        elseif npc.I1 == 6 then --Cyan Bubble
            for i = 1, mod:RandomInt(bal.cyanBubbleAmount, rng) do
                local vec = RandomVector():Resized(mod:RandomInt(bal.cyanBubbleSpeed, rng))
				mod.ShootBubble(npc, mod:GetRandomElem(bal.cyanBubbleSubs, rng), npc.Position + vec:Resized(5), vec)
            end
            DoShootPoof(npc, nil, 3, mod.ColorWaterPeople, true, 0.5)
            mod:PlaySound(mod.Sounds.BathtubFart, npc, 1.5)
            mod:PlaySound(SoundEffect.SOUND_BOSS2_BUBBLES, npc, 0.8, 1.2)

        elseif npc.I1 == 7 then --Blue Ring
            blueParams.BulletFlags =  ProjectileFlags.NO_WALL_COLLIDE + (rng:RandomFloat() <= 0.5 and ProjectileFlags.CURVE_LEFT or ProjectileFlags.CURVE_RIGHT)
            local offset = mod:RandomAngle(rng)
            for i = 360/bal.blueProjCount, 360, 360/bal.blueProjCount do
                npc:FireProjectiles(npc.Position, Vector.FromAngle(i + offset):Resized(bal.blueProjSpeed), ProjectileMode.SINGLE, blueParams)
            end
            DoShootPoof(npc, nil, 2, mod.ColorBlueBlue)
            mod:PlaySound(SoundEffect.SOUND_BLOODSHOOT, npc, 0.8, 1.2)
            mod:PlaySound(SoundEffect.SOUND_MEATHEADSHOOT, npc)

        elseif npc.I1 == 8 then --Purple Eye
            local proj = npc:FireProjectilesEx(npc.Position, (targetpos - npc.Position):Resized(bal.purpleProjSpeed), ProjectileMode.SINGLE, purpleParams)[1]
            mod:GetEntityData(proj).projType = "Sixth"
            DoShootPoof(npc, nil, 2, mod.ColorMausPurple)
            DoShootPoof(npc, nil, 2, mod.ColorPsyGrape2)
            mod:PlaySound(SoundEffect.SOUND_BLOODSHOOT, npc, 0.8, 1.2)
            mod:PlaySound(SoundEffect.SOUND_WEIRD_WORM_SPIT, npc)
    
        elseif npc.I1 == 9 then --White Cross
            table.insert(mod.SkyCrackins, {Count = bal.whiteBeamDuration, Spawner = npc})
            DoShootPoof(npc, mod.FF.FFWhiteSmoke.Var, mod.FF.FFWhiteSmoke.Sub, Color.Default)
            mod:PlaySound(SoundEffect.SOUND_LIGHTBOLT_CHARGE, npc)
            mod:PlaySound(SoundEffect.SOUND_BOSS_LITE_ROAR, npc, 1.1, 0.25)

        elseif npc.I1 == 10 then --Gray Bone
            local targetspan = targetpos - npc.Position
            local bone = Isaac.Spawn(EntityType.ENTITY_BIG_BONY, 10, 0, npc.Position + targetspan:Resized(10), targetspan:Resized(bal.grayBoneSpeed), npc)
            bone.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS
            mod:FadeIn(bone, 3)
            DoShootPoof(npc, mod.FF.FFWhiteSmoke.Var, mod.FF.FFWhiteSmoke.Sub, Color(0.75,0.75,0.75))
            mod:PlaySound(SoundEffect.SOUND_SCAMPER, npc)
            mod:PlaySound(SoundEffect.SOUND_WORM_SPIT, npc)

        elseif npc.I1 == 11 then --Brown Poop
            Isaac.GridSpawn(GridEntityType.GRID_POOP, 0, npc.Position, true)
            game:ButterBeanFart(npc.Position, bal.brownFartRadius, npc, true, false)
            DoShootPoof(npc, nil, 0, mod.ColorPoop, true, 1.0)
        end
    end
end

local altShootNumbers = {4,6,11}
function mod:SoothsayerAI(npc, sprite, data)
    local rng = npc:GetDropRNG()
    local targetpos = mod:confusePos(npc, npc:GetPlayerTarget().Position)

    if not data.Init then
        npc.StateFrame = mod:RandomInt(bal.spinCooldown, rng) - 15
        data.State = "Idle"
        data.RareAttacksCooldown = (npc.Scale < 0.9 or mod:IsCloset(true)) and 1 or 0 --Prevent Meat-Cleaved Soothsayers from doing a rare attack immeadiately
        data.Init = true
    end

    if data.State == "Idle" then
        mod:SpritePlay(sprite, "Idle")
        DoMoving(npc)

        npc.StateFrame = npc.StateFrame - 1
        if npc.StateFrame <= 0 then
            data.State = "SpinStart"
        end

    elseif data.State == "SpinStart" then
        DoMoving(npc, bal.spinStartSpeedMult)

        if sprite:IsFinished("SpinStart") then
            npc.StateFrame = mod:RandomInt(bal.spinTime, rng)
            data.State = "Spinning"
            sprite:Play("SpinLoop")
        elseif sprite:IsEventTriggered("Sound") then
            mod:PlaySound(SoundEffect.SOUND_DEATH_REVERSE, npc, 1.25, 0.25)
        elseif sprite:IsEventTriggered("Blink") then
            mod:PlaySound(SoundEffect.SOUND_ULTRA_GREED_PULL_SLOT, npc)
        else
            mod:SpritePlay(sprite, "SpinStart")
        end

    elseif data.State == "Spinning" then
        mod:SpritePlay(sprite, "SpinLoop", true)
        DoMoving(npc, bal.spinSpeedMult)
        mod:AddLoopingSoundEntry(SoundEffect.SOUND_ULTRA_GREED_SLOT_SPIN_LOOP, 0.33)

        npc.StateFrame = npc.StateFrame - 1
        local room = game:GetRoom()
        if npc.StateFrame <= 0 and npc.Position:Distance(targetpos) <= 300
        and (room:CheckLine(npc.Position,targetpos,3,0,false,false) or npc.StateFrame <= -90)
        and room:GetGridCollisionAtPos(npc.Position) <= GridCollisionClass.COLLISION_PIT 
         then
            data.DoingRareAttack = forceRareAttacks or (rng:RandomFloat() <= bal.rareAttackChance and data.RareAttacksCooldown <= 0)
            if data.DoingRareAttack then
                if mod:IsCloset(true) then --Only do splitting rare attack in closets
                    npc.I1 = 1
                elseif mod:DoesRoomHaveAnyRequiredGridsToClear() and not attackRollOverride then
                    npc.I1 = mod:RandomInt(1,bal.numRareAttacks-1,rng)
                else
                    npc.I1 = attackRollOverride and math.min(attackRollOverride, bal.numRareAttacks) or mod:RandomInt(1,bal.numRareAttacks,rng)
                end
                data.AnimSuffix = "Rare"
                for _, soothsayer in pairs(Isaac.FindByType(mod.FF.Soothsayer.ID, mod.FF.Soothsayer.Var)) do
                    mod:GetEntityData(soothsayer).RareAttacksCooldown = bal.rareAttackCooldown
                end
            else
                npc.I1 = attackRollOverride and math.min(attackRollOverride, bal.numAttacks) or mod:RandomInt(1,bal.numAttacks,rng)
                data.AnimSuffix = ""
                data.RareAttacksCooldown = data.RareAttacksCooldown - 1
            end
            if not (data.DoingRareAttack and npc.I1 == 3) then
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS
            end
            sprite:GetLayer(6):SetCropOffset(Vector((npc.I1 - 1) * 32, 0))
            sprite:GetLayer(8):SetCropOffset(Vector((npc.I1 - 1) * 32, 0))
            mod:PlaySound(SoundEffect.SOUND_ULTRA_GREED_SLOT_STOP, npc)
            data.State = "SpinStop"
        end

    elseif data.State == "SpinStop" then
        DoMoving(npc, bal.attackingSpeedMult, true)

        if sprite:IsFinished("SpinStop"..data.AnimSuffix) then
            if data.DoingRareAttack and npc.I1 == 3 then
                mod:PlaySound(SoundEffect.SOUND_WAR_BOMB_TICK, npc, 1.5, 3)
                data.State = "Explode"
                sprite:Play("Explode")
            else
                data.State = "Shoot"
                data.AnimSuffix = (mod:Contains(altShootNumbers, npc.I1) or data.DoingRareAttack) and "02" or "01"
                sprite:Play("Shoot"..data.AnimSuffix)
            end
        elseif sprite:IsEventTriggered("Blink") then
            if data.DoingRareAttack then
                mod:PlaySound(SoundEffect.SOUND_THUMBSDOWN_AMPLIFIED, npc)
            else
                mod:PlaySound(SoundEffect.SOUND_THUMBSUP, npc, 1.25, 0.5)
            end
        elseif sprite:IsEventTriggered("Sound") then
            mod:PlaySound(891, npc)
        else
            mod:SpritePlay(sprite, "SpinStop"..data.AnimSuffix)
        end

    elseif data.State == "Shoot" then
        npc.Velocity = npc.Velocity * 0.7

        if sprite:IsFinished("Shoot"..data.AnimSuffix) then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
            npc.StateFrame = mod:RandomInt(bal.spinCooldown, rng)
            data.State = "Idle"
        elseif sprite:IsEventTriggered("Shoot") then
            DoSoothsayerAttack(npc, data.DoingRareAttack)
        else
            mod:SpritePlay(sprite, "Shoot"..data.AnimSuffix)
        end

    elseif data.State == "Explode" then
        npc.Velocity = npc.Velocity * 0.7

        if sprite:IsFinished("Explode") then
            DoSoothsayerAttack(npc, true)
        elseif sprite:IsEventTriggered("Sound") then
            mod:PlaySound(SoundEffect.SOUND_MONSTER_YELL_A, npc)
        else
            mod:SpritePlay(sprite, "Explode")
        end

        if sprite:GetFrame() % 2 == 0 then
            DoShootPoof(npc, mod.FF.FFWhiteSmoke.Var, mod.FF.FFWhiteSmoke.Sub, Color(0.5,0.5,0.5), true, 0.75, Vector(0,-5 - (sprite:GetFrame()/5)):Rotated(mod:RandomInt(-15,15,rng)))
        end
    end
end

function mod:SoothsayerHurt(npc, amount, damageFlags, source)
    if (mod:HasDamageFlag(DamageFlag.DAMAGE_FIRE, damageFlags) or mod:HasDamageFlag(DamageFlag.DAMAGE_EXPLOSION, damageFlags)) and not mod:IsPlayerDamage(source) then
        return {Damage = amount * bal.selfDmgResist}
    end
end

function mod:SoothsayerRegen(npc, sprite, data)
    if data.State == "Explode" then
        data.State = "Idle"
    else
        sprite:GetLayer(6):SetCropOffset(Vector((npc.I1 - 1) * 32, 0))
        sprite:GetLayer(8):SetCropOffset(Vector((npc.I1 - 1) * 32, 0))
    end
end

--Giga bombs are stupid and don't account for teleporters/buttons when calculating what things the player should always have a path to, so disable the giga explosion if those exist
function mod:DoesRoomHaveAnyRequiredGridsToClear() 
    local room = game:GetRoom()
    for i = 0, room:GetGridSize() do
        local grid = room:GetGridEntity(i)
        if grid then
            if grid:GetType() == GridEntityType.GRID_TELEPORTER
            or (grid:GetType() == GridEntityType.GRID_PRESSURE_PLATE and grid:GetVariant() == 0)
            or StageAPI.GetCustomGrid("FFTotemSwitch", i)
            or StageAPI.GetCustomGrid("FFTotemTimedButton", i) then
                return true
            end
        end
    end
    return false
end