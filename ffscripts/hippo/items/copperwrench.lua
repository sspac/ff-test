local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local explosionDmg = 50
local chanceToBreak = 300 --every second
local timeUntilPrime = 30*60 --60 seconds until prime
local breakGraceTime = 30*10 -- 10 seconds until allowed to break

local preppedForPrimeTime = false

local copperColor = Color(1, 0.8, 0.4, 1, 0, 0, 0)
copperColor:SetColorize(1, 0.5, 0.1, 1)

--secret functions
-- copper dud chance is increased to 80% until you get one dud

function mod:SpawnCopperBotFly(bomb)
    if mod.anyPlayerHas(mod.ITEM.COLLECTIBLE.COPPER_WRENCH) then
        local copperFly = Isaac.Spawn(3, mod.ITEM.FAMILIAR.COPPER_BOT_FLY, 1800, bomb.Position, Vector.Zero, bomb):ToFamiliar()
        local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 1, bomb.Position, Vector.Zero, bomb):ToEffect()
        poof.SpriteScale = Vector.One * 0.5
        copperFly:SetColor(Color(2,2,2,1,2,1.2,0),20,99,true,false)
        mod:GetEntityData(copperFly).postDud = true
        sfx:Play(mod.Sounds.CopperWrench, 2)
        bomb:Remove()
        return true
    end
    return false
end

local function copperDebris(fam, particleNum, doSmoke)
    for _= 1,particleNum do
        local particle = Isaac.Spawn(1000, 4, 7, fam.Position, RandomVector()*mod:RandomInt(1,4), fam)
        particle.SpriteScale = Vector(0.5,0.5)
        particle.Color = copperColor
        particle:Update()
    end
    if doSmoke then
        local smoke = Isaac.Spawn(1000, EffectVariant.DUST_CLOUD, 0, fam.Position, Vector.Zero, fam):ToEffect()
        smoke:SetTimeout(15)
        smoke.SpriteOffset = Vector(0,-30)
        smoke.DepthOffset = 1
        smoke:Update()
    end
end

FiendFolio.AddItemPickupCallback(function(player, added)
    local room = game:GetRoom()
    for i=1,3 do
        local pos = room:FindFreePickupSpawnPosition(player.Position, 40, true)
        Isaac.Spawn(5, 40, mod.PICKUP.BOMB.COPPER, pos, Vector.Zero, nil)
    end
    
    player:GetEffects():AddCollectibleEffect(mod.ITEM.COLLECTIBLE.COPPER_WRENCH)
end, nil, mod.ITEM.COLLECTIBLE.COPPER_WRENCH)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, fam)
    fam.OrbitDistance = Vector(60,55)
    fam.OrbitSpeed = 0.015
    fam.SpriteOffset = Vector(0,-2)
    mod:lastJudgementAutoResprite(fam)
end, mod.ITEM.FAMILIAR.COPPER_BOT_FLY)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, fam)
    local sprite = fam:GetSprite()
    local d = mod:GetEntityData(fam)
    local player = fam.Player

    local rng = fam:GetDropRNG()
    preppedForPrimeTime = true

    if d.postDud then
        d.state = "Spawn"
        d.primeTimer = timeUntilPrime
        d.spawnTimer = 40
        fam.State = d.primeTimer

        copperDebris(fam, 8, true)

        local pulse = Isaac.Spawn(1000, 1960, 20, fam.Position, Vector.Zero, fam)
        pulse.SpriteScale = Vector(0.15,0.15)
        pulse.Color = Color(0.6,0.6,0.6,0.15,0,0,0)
        pulse:GetSprite().PlaybackSpeed = 1.5
        pulse:Update()

        for _ = 1, 4 do
            local laser = mod:ShootPlasmaBallLaser(fam, mod:RandomInt(0, 360))
            laser.Color = mod.ColorElectricYellowA
        end

        for _,bullet in ipairs(Isaac.FindInRadius(fam.Position, 100, EntityPartition.BULLET)) do
            bullet:Kill()
        end
        for _,ent in ipairs(Isaac.FindInRadius(fam.Position, 100, EntityPartition.ENEMY)) do
            if ent and
            ent:IsVulnerableEnemy() and
            not ent:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and
            not ent:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) and
            not ent:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) then
                ent:AddFreeze(EntityRef(fam), 50)
            end
        end
        d.postDud = false
    end
    
    d.state = d.state or "Spawn"
    if d.state ~= "Explode" and d.state ~= "Spawn" then
        fam.OrbitDistance = Vector(60,55)
        local targetPosition = fam:GetOrbitPosition(player.Position + player.Velocity)
        if fam.Position:Distance(targetPosition) > 30 then
            fam.Position = targetPosition
        else
            fam.Velocity = targetPosition - fam.Position
        end

        d.primeTimer = d.primeTimer or timeUntilPrime
        if d.primeTimer > 0 then
            fam.State = d.primeTimer
            d.primeTimer = d.primeTimer - 1
        end
        --local isSuperpositioned = mod:isSuperpositionedPlayer(player)
    end

    if fam.Visible then
        local bullets = Isaac.FindInRadius(player.Position, 180, EntityPartition.BULLET)
        if #bullets > 0 then
            local closest = 999999
            for _,bullet in ipairs(bullets) do
                if (bullet.Position+bullet.Velocity*4):Distance(player.Position) < closest then
                    closest = (bullet.Position+bullet.Velocity*4):Distance(player.Position)
                    d.closestBullet = bullet
                end
            end
        end

        if d.state == "Spawn" then
            mod:spritePlay(sprite, "Fly") 
            d.spawnTimer = d.spawnTimer or 0
            if d.spawnTimer > 0 then
                d.spawnTimer = d.spawnTimer - 1
            else
                d.state = "Idle"
                fam.OrbitLayer = 2
                fam:RecalculateOrbitOffset(fam.OrbitLayer, true)
                fam.Position = fam:GetOrbitPosition(player.Position + player.Velocity)
                Isaac.Spawn(1000,15,0,fam.Position,Vector.Zero,fam)
                sfx:Play(SoundEffect.SOUND_SUMMON_POOF, 0.6, 2, false, 1.2)
                d.spawnTimer = nil

                if fam.State > 0 then d.primeTimer = fam.State end
                if fam.State < 0 then 
                    d.primeTimer = 0
                    d.state = "Primed" 
                end
            end

            fam.Velocity = Vector.Zero
        elseif d.state == "Idle" then
            mod:spritePlay(sprite, "Fly") 
            sprite.PlaybackSpeed = 1

            if d.primeTimer <= 0 then
                sfx:Play(SoundEffect.SOUND_BEEP, 0.7, 2, false, 0.7)
                sfx:Play(SoundEffect.SOUND_LIGHTBOLT_CHARGE, 1, 2, false, 1)
                fam:SetColor(Color(2,2,2,1,2,2,2),10,99,true,false)

                fam.State = -1
                d.state = "Primed"
            elseif d.closestBullet and d.closestBullet:Exists() then
                d.state = "Attack"
            end
        elseif d.state == "Attack" then
            mod:spritePlay(sprite, "Attack")
            if sprite:IsFinished("Attack") then
                d.state = "Idle"
            end

            sprite.PlaybackSpeed = 1.5

            if d.closestBullet and d.closestBullet:Exists() then
                if d.closestBullet.Position.X < fam.Position.X then
                    sprite.FlipX = true
                else
                    sprite.FlipX = false
                end
                if sprite:IsEventTriggered("Shoot") then
                    local vel = ((d.closestBullet.Position+d.closestBullet.Velocity*5.5) - fam.Position):Resized(14)
                    local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 10, 0, fam.Position, vel, fam):ToTear()
                    tear:AddTearFlags(TearFlags.TEAR_SHIELDED | TearFlags.TEAR_SPECTRAL)
                    tear.Height = -23
                    tear.CollisionDamage = 0
                    tear.Scale = 0.75
                    tear.Size = 1.5
                    tear.FallingSpeed = 1.5
                    d.tear = tear
                end
            end
        
        elseif d.state == "Primed" then
            if d.readyToBreak then
                mod:spritePlay(sprite, "Break")
                if sprite:IsFinished("Break") then
                    copperDebris(fam, 6, true)
                    sfx:Play(SoundEffect.SOUND_POT_BREAK, 0.8, 2, false, 1.2)
                    sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 0.5, 2, false, 1)
                    fam:Die()
                end
            else
                mod:spritePlay(sprite, "Primed")

                d.breakGrace = d.breakGrace or breakGraceTime
                if d.breakGrace > 0 then
                    d.breakGrace = d.breakGrace - 1
                else
                    if fam.FrameCount % 30 == 0 and mod:RandomInt(1,chanceToBreak,rng) == 4 then
                        copperDebris(fam, 2, false)
                        sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 0.5, 2, false, 1.2)

                        fam:SetColor(Color(2,2,2,1,2,2,2),6,99,true,false)
                        d.readyToBreak = true
                    end
                end
            end

        elseif d.state == "Explode" then
            if not d.explodeTimer then
                local shield = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BISHOP_SHIELD, 0, player.Position, Vector.Zero, player):ToEffect()
                shield.Target = player
                shield.SpriteOffset = Vector(0,-15)
                shield.DepthOffset = 100
                shield.Parent = fam
                shield.Timeout = 60
                shield:Update()

                player:SetMinDamageCooldown(60)
                sfx:Play(SoundEffect.SOUND_HOLY_MANTLE, 0.6, 2, false, 1.2)
                sfx:Play(SoundEffect.SOUND_BISHOP_HIT)
                fam:SetColor(Color(2,2,2,1,2,2,2),10,99,true,false)

                mod:spritePlay(sprite, "Idle")
                fam.Velocity = (fam.Position-player.Position):Resized(13)
            end

            d.explodeTimer = d.explodeTimer or 15
            if d.explodeTimer > 0 then
                d.explodeTimer = d.explodeTimer - 1
            else
                mod:spritePlay(sprite, "Explode")
                if sprite:IsFinished("Explode") then
                    local dmg = explosionDmg
                    if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then dmg = dmg+50 end
                    if player:HasCollectible(CollectibleType.COLLECTIBLE_MR_MEGA) then dmg = dmg+50 end
                    local bomb = player:FireBomb(fam.Position, Vector.Zero, player)
                    bomb.ExplosionDamage = dmg
                    bomb.Flags = player:GetBombFlags()
                    bomb:SetExplosionCountdown(0)
		            fam:Die()
                end
            end
            fam.Velocity = fam.Velocity * 0.85
        end

        if d.closestBullet then
            if not d.closestBullet:Exists() or d.closestBullet.Position:Distance(player.Position) > 200 then
                d.closestBullet = nil
            end

            if d.tear and d.tear:Exists() and d.closestBullet and d.closestBullet:Exists() then
                d.tear.Velocity = mod:Lerp(d.tear.Velocity,((d.closestBullet.Position+d.closestBullet.Velocity*4)-d.tear.Position):Resized(15),0.25)
                if d.tear.Position:Distance(d.closestBullet.Position) < 30 then
                    d.closestBullet:Die()
                    d.tear:Die()
                end
            end
        end
    end

    if fam:IsDead() then
        local cbotfly = Isaac.FindByType(3, mod.ITEM.FAMILIAR.COPPER_BOT_FLY, -1)
        if #cbotfly <= 1 and not player:GetEffects():HasCollectibleEffect(mod.ITEM.COLLECTIBLE.COPPER_WRENCH) then
            player:GetEffects():AddCollectibleEffect(mod.ITEM.COLLECTIBLE.COPPER_WRENCH)
        end
    end
end, mod.ITEM.FAMILIAR.COPPER_BOT_FLY)

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, damage, flag, source)
	if preppedForPrimeTime then
        if (flag & DamageFlag.DAMAGE_CLONES) == 0 and (flag & DamageFlag.DAMAGE_IV_BAG) == 0 then
            local p = npc:ToPlayer()
            local preventDamage = false
            if not p:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE) then
                local cbotfly = Isaac.FindByType(3, mod.ITEM.FAMILIAR.COPPER_BOT_FLY, -1)
                if cbotfly and #cbotfly>0 then
                    for i,fly in ipairs(cbotfly) do
                        local d = mod:GetEntityData(fly)
                        if tostring(p:GetCollectibleRNG(1):GetSeed()) == tostring(fly:ToFamiliar().Player:GetCollectibleRNG(1):GetSeed()) 
                        and d.state == "Primed" then
                            preventDamage = true
                            d.state = "Explode"
                            if not (#cbotfly > 4 and mod:RandomInt(1,#cbotfly-2,rng) == 1) then
                                break
                            end
                        end
                    end
                end
            end
            if preventDamage then
                return false
            end
        end
    end
end, EntityType.ENTITY_PLAYER)