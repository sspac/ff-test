local mod = FiendFolio
local sfx = SFXManager()
local game = Game()

local aBal = {
    asteroidCap = {5, 10, 2},
    initialAsteroids = 4,
    asteroidHealth = 5,
    orbitDist = 45,
    orbitSpeed = 0.012,
    posOffset = -18,
    projCheck = 20,
    blockRadius = 8,
    projCheck2 = 20,
    blockRadius2 = 15,
    invulnPeriod = 16,

    flySpeed = 16,
    searchRadius = 15,
    damageRadius = 8,
    backupDamage = 10,
    damageMult = 1.5,
    damageScaling = 1.2,
    confuseDur = 150,
    damageGain = 77, --dealing this amount of damage grants an asteroid, increases each chapter
}

--blocks several hits, also blocks when shot out
--rock poof height

mod.ExpectedNewAsteroidBelts = 0

FiendFolio.AddItemPickupCallback(function(player, added)
    local d = mod:GetEntityData(player).ffsavedata.RunEffects
    local mult = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.ASTEROID_BELT)-1
    d.AsteroidBelt = d.AsteroidBelt or {}
    local cap = math.min(aBal.asteroidCap[2], aBal.asteroidCap[1]+aBal.asteroidCap[3]*mult)
    local num = 0
    for _,i in pairs(d.AsteroidBelt) do
        num = num+1
    end
    local addMax = (cap-num)
    local new = math.min(aBal.initialAsteroids, addMax)
    player:CheckFamiliar(mod.ITEM.FAMILIAR.ASTEROID, num+new, player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.ASTEROID_BELT), Isaac:GetItemConfig():GetCollectible(mod.ITEM.COLLECTIBLE.ASTEROID_BELT), 0)
end, nil, mod.ITEM.COLLECTIBLE.ASTEROID_BELT)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, fam)
    local pd = mod:GetEntityData(fam.Player).ffsavedata.RunEffects
    pd.AsteroidBelt = pd.AsteroidBelt or {}
    if not pd.AsteroidBelt["" .. fam.InitSeed] then
        pd.AsteroidBelt["" .. fam.InitSeed] = {fam = fam, health = aBal.asteroidHealth}
    end
    fam.Player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.ASTEROID_BELT):Next()
    local rng = fam:GetDropRNG()
    local d = mod:GetEntityData(fam)
    local sprite = fam:GetSprite()
    fam:AddToOrbit(12)
    d.spriteVar = rng:RandomInt(4)+1
    sprite:Play("Idle" .. d.spriteVar, true)
    fam.PositionOffset = Vector(0, aBal.posOffset)
    fam.OrbitDistance = Vector(aBal.orbitDist, aBal.orbitDist)
    fam.OrbitSpeed = aBal.orbitSpeed
    fam.Position = fam:GetOrbitPosition(fam.Player.Position + fam.Player.Velocity)
    mod:GetEntityData(fam).updatePosAst = true
    fam:Update()
end, mod.ITEM.FAMILIAR.ASTEROID)

function mod:AsteroidBeltNewRoom()
    for _,rock in ipairs(Isaac.FindByType(3, mod.ITEM.FAMILIAR.ASTEROID, -1, false, false)) do
        if mod:GetEntityData(rock).firedAsteroid then
            rock:Remove()
        end
    end
end

function mod:AsteroidBeltRoomClear(player, d1)
    local d = d1.ffsavedata.RunEffects
    d.AsteroidBelt = d.AsteroidBelt or {}
    local mult = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.ASTEROID_BELT)
    local cap = math.min(aBal.asteroidCap[2], aBal.asteroidCap[1]+aBal.asteroidCap[3]*mult)
    local num = 0
    for _,i in pairs(d.AsteroidBelt) do
        num = num+1
    end
    local addMax = (cap-num)
    local new = math.min(mult, addMax)
    player:CheckFamiliar(mod.ITEM.FAMILIAR.ASTEROID, num+new, player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.ASTEROID_BELT), Isaac:GetItemConfig():GetCollectible(mod.ITEM.COLLECTIBLE.ASTEROID_BELT), 0)
end

function mod:AsteroidBeltCache(player)
    local d = mod:GetEntityData(player).ffsavedata.RunEffects
    d.AsteroidBelt = d.AsteroidBelt or {}
    local mult = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.ASTEROID_BELT)
    local cap = math.min(aBal.asteroidCap[2], aBal.asteroidCap[1]+aBal.asteroidCap[3]*mult)
    local num = 0
    for id,i in pairs(d.AsteroidBelt) do
        if num <= cap and i.fam and i.fam:Exists() then
            num = math.min(num+1, cap)
        else
            --Little safety check to make sure the entity exists first
            if i.fam and i.fam:Exists() then
                i.fam:Remove()
            end
            d.AsteroidBelt[id] = nil
        end
    end
    player:CheckFamiliar(mod.ITEM.FAMILIAR.ASTEROID, num, player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.ASTEROID_BELT), Isaac:GetItemConfig():GetCollectible(mod.ITEM.COLLECTIBLE.ASTEROID_BELT), 0)
end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, fam)
    local d = mod:GetEntityData(fam)
    local sprite = fam:GetSprite()
    local rng = fam:GetDropRNG()

    if not d.init then
        if fam.Player then
            local pd = mod:GetEntityData(fam.Player).ffsavedata.RunEffects
            if pd.AsteroidBelt["" .. fam.InitSeed] then
                fam.Coins = pd.AsteroidBelt["" .. fam.InitSeed].health
                if fam.Coins < aBal.asteroidHealth/2 then
                    d.AsteroidCrack = true
                end
            else
                fam.Coins = aBal.asteroidHealth
                pd.AsteroidBelt["" .. fam.InitSeed] = {fam = fam, health = aBal.asteroidHealth}
            end
            local pos = fam:GetOrbitPosition(fam.Player.Position + fam.Player.Velocity)
            fam.Position = pos
        else
            fam:Remove()
        end
        d.init = true
    end

    if fam.Player and fam.Player:Exists() then
        local player = fam.Player:ToPlayer()
        if fam.Coins > aBal.asteroidHealth/2 then
            mod:spritePlay(sprite, "Idle" .. d.spriteVar)
        else
            mod:spritePlay(sprite, "Crack" .. d.spriteVar)
        end

        if d.firedAsteroid then
            if not d.init2 then
                fam.Position = fam.Player.Position
                d.init2 = true
            end
            fam.Velocity = d.firedAsteroidDir:Resized(aBal.flySpeed)

            for _,proj in ipairs(Isaac.FindInRadius(fam.Position, aBal.projCheck2, EntityPartition.BULLET)) do
                if proj.Position:DistanceSquared(fam.Position) <= (aBal.blockRadius2 + player.Size) ^ 2 then
                    proj:Die()
                end
            end

            for _, enemy in ipairs(Isaac.FindInRadius(fam.Position, aBal.searchRadius, EntityPartition.ENEMY)) do
                if enemy:IsActiveEnemy() and (not mod:isFriend(enemy)) and enemy:IsVulnerableEnemy() and
                    enemy.Position:DistanceSquared(fam.Position) <= (aBal.damageRadius + enemy.Size) ^ 2 then
                    local timeMult = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
                    local baseDamage = player.Damage
                    if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
                        baseDamage = baseDamage * 2
                    end
                    local level = game:GetLevel():GetAbsoluteStage()
                    local damage = baseDamage*aBal.damageMult+aBal.damageScaling*level
                    enemy:TakeDamage(damage, 0, EntityRef(fam), 0)

                    if not enemy:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) then
                        enemy:AddConfusion(EntityRef(fam), aBal.confuseDur*timeMult, false)
                    end

                    local burst = Isaac.Spawn(1000, EffectVariant.ROCK_POOF, 0, fam.Position, Vector.Zero, fam):ToEffect()
                    burst.SpriteOffset = Vector(0,-10)
                    sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 0.7, 0, false, mod:RandomInt(120,140,rng)/100)
                    for i=0,2 do
                        local particle = Isaac.Spawn(1000, 35, 1, fam.Position, Vector(0,rng:RandomInt(5)/3.2):Rotated(rng:RandomInt(360)), fam)
                        particle:SetColor(Color(0.25,0.25,0.35,1,0,0,0), 999, 1, false, false)
                    end
                    fam:Remove()
                end
            end

            local room = game:GetRoom()
            if room:GetGridCollisionAtPos(fam.Position) >= GridCollisionClass.COLLISION_OBJECT or not room:IsPositionInRoom(fam.Position, 0) then
                local burst = Isaac.Spawn(1000, EffectVariant.ROCK_POOF, 0, fam.Position, Vector.Zero, fam):ToEffect()
                burst.SpriteOffset = Vector(0,-10)
                sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 0.7, 0, false, mod:RandomInt(120,140,rng)/100)
                for i=0,2 do
                    local particle = Isaac.Spawn(1000, 35, 1, fam.Position, Vector(0,rng:RandomInt(5)/3.2):Rotated(rng:RandomInt(360)), fam)
                    particle:SetColor(Color(0.25,0.25,0.35,1,0,0,0), 999, 1, false, false)
                end
                fam:Remove()
            end
        elseif mod:isSirenCharmed(fam) then
            fam.OrbitDistance = Vector(aBal.orbitDist, aBal.orbitDist)
            fam.OrbitSpeed = aBal.orbitSpeed
            local pos = fam:GetOrbitPosition(player.Position + player.Velocity)
            if d.updatePosAst then
                d.updatePosAst = nil
                fam.Position = pos
            else
                fam.Velocity = (pos-fam.Position)
            end
        else
            local pd = mod:GetEntityData(player).ffsavedata.RunEffects
            pd.AsteroidBelt["" .. fam.InitSeed] = pd.AsteroidBelt["" .. fam.InitSeed] or {fam = fam, health = aBal.asteroidHealth}
            local entry = pd.AsteroidBelt["" .. fam.InitSeed]
            fam.OrbitDistance = Vector(aBal.orbitDist, aBal.orbitDist)
            fam.OrbitSpeed = aBal.orbitSpeed
            local pos = fam:GetOrbitPosition(player.Position + player.Velocity)
            if d.updatePosAst then
                d.updatePosAst = nil
                fam.Position = pos
            else
                fam.Velocity = (pos-fam.Position)
            end

            if d.invulnPeriod then
                if d.invulnPeriod > 0 then
                    d.invulnPeriod = d.invulnPeriod-1
                else
                    d.invulnPeriod = nil
                end
            end

            for _,proj in ipairs(Isaac.FindInRadius(fam.Position, aBal.projCheck, EntityPartition.BULLET)) do
                if proj.Position:DistanceSquared(fam.Position) <= (aBal.blockRadius + player.Size) ^ 2 then
                    proj:Die()

                    if not d.invulnPeriod then
                        d.invulnPeriod = aBal.invulnPeriod
                        fam.Coins = fam.Coins-1
                        entry.health = fam.Coins
                        mod:applyFakeDamageFlash(fam)

                        if not d.AsteroidCrack and fam.Coins <= aBal.asteroidHealth/2 then
                            d.AsteroidCrack = true
                            sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 0.7, 0, false, mod:RandomInt(120,140,rng)/100)
                        end

                        if fam.Coins <= 0 then
                            local burst = Isaac.Spawn(1000, EffectVariant.ROCK_POOF, 0, fam.Position, Vector.Zero, fam):ToEffect()
                            burst.SpriteOffset = Vector(0,-10)
                            sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 0.7, 0, false, mod:RandomInt(120,140,rng)/100)
                            for i=0,2 do
                                local particle = Isaac.Spawn(1000, 35, 1, fam.Position, Vector(0,rng:RandomInt(5)/3.2):Rotated(rng:RandomInt(360)), fam)
                                particle:SetColor(Color(0.25,0.25,0.35,1,0,0,0), 999, 1, false, false)
                            end
                            sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 0.7, 0, false, mod:RandomInt(120,140,rng)/100)
                            pd.AsteroidBelt["" .. fam.InitSeed] = nil
                            fam:Remove()
                        end
                    end
                end
            end
        end
    else
        local burst = Isaac.Spawn(1000, EffectVariant.ROCK_POOF, 0, fam.Position, Vector.Zero, fam):ToEffect()
        burst.SpriteOffset = Vector(0,-10)
        sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 0.7, 0, false, mod:RandomInt(120,140,rng)/100)
        for i=0,2 do
            local particle = Isaac.Spawn(1000, 35, 1, fam.Position, Vector(0,rng:RandomInt(5)/3.2):Rotated(rng:RandomInt(360)), fam)
            particle:SetColor(Color(0.25,0.25,0.35,1,0,0,0), 999, 1, false, false)
        end
        sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 0.7, 0, false, mod:RandomInt(120,140,rng)/100)
        fam:Remove()
    end

end, mod.ITEM.FAMILIAR.ASTEROID)

function mod:asteroidBeltDoubleTap(player, data)
    if 0 == 0 or player:HasCollectible(mod.ITEM.COLLECTIBLE.ASTEROID_BELT) then
        local aim = mod:GetSimpleAimDir(player)
        if aim:Length() > 0.5 then
            local d = data.RunEffects
            d.AsteroidBelt = d.AsteroidBelt or {}
            local chosen
            local lowest = 9999
            for key,entry in pairs(d.AsteroidBelt) do
                if entry.health < lowest then
                    chosen = key
                    lowest = entry.health
                end
            end
            if chosen then
                local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.ASTEROID_BELT)
                local fam = d.AsteroidBelt[chosen].fam
                if fam and not mod:isSirenCharmed(fam) then
                    sfx:Play(SoundEffect.SOUND_SHELLGAME, 0.5, 0, false, 1.3)
                    mod:GetEntityData(fam).firedAsteroid = true
                    fam:RemoveFromOrbit()
                    local dir = aim:Resized(aBal.flySpeed)+player:GetTearMovementInheritance(aim)
                    mod:GetEntityData(fam).firedAsteroidDir = dir
                    fam.Position = player.Position
                    d.AsteroidBelt["" .. fam.InitSeed] = nil

                    --[[for i=1,3 do
                        local randVel = Vector(0, mod:RandomInt(2,15,rng)/10):Rotated(rng:RandomInt(360))
                        local cloud = Isaac.Spawn(1000, 59, 0, player.Position, Vector.Zero, nil):ToEffect()
                        cloud:SetTimeout(mod:RandomInt(50,75,rng))
                        local color = Color(1,1,1,0,0,0,0)
                        cloud.Color = color
                        local randScale = mod:RandomInt(80,150,rng)/100
                        cloud.SpriteScale = Vector(0.5, 0.5)
                        mod:GetEntityData(cloud).cosmeticDust = {scale = randScale, vel = randVel, alpha = 0.5}
                    end]]

                    for _,a in ipairs(Isaac.FindByType(3, mod.ITEM.FAMILIAR.ASTEROID, -1, false, false)) do
                        local as = a:ToFamiliar()
                        if as.Player and as.Player:Exists() and not mod:GetEntityData(as).firedAsteroid then
                            mod:GetEntityData(as).updatePosAst = true
                        end
                    end
                elseif not mod:isSirenCharmed(fam) then
                    d.AsteroidBelt[chosen] = nil
                end
            end
        end
    end
end

function mod:asteroidBeltTakeDmg(ent, tab)
    local player = tab.source:ToPlayer() or (tab.spawner and tab.spawner:ToPlayer())
    if player and ent:IsVulnerableEnemy() then
        if player:HasCollectible(mod.ITEM.COLLECTIBLE.ASTEROID_BELT) then
            local level = math.max(game:GetLevel():GetAbsoluteStage(), 1)
            local needed = aBal.damageGain*math.ceil(level/2)
            local d = mod:GetEntityData(player).ffsavedata.RunEffects
            if ent.HitPoints > 0 then
                local increase = math.min(ent.HitPoints, tab.damage)
                d.AsteroidDamage = (d.AsteroidDamage or 0)+increase
                if d.AsteroidDamage > needed then
                    local mult = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.ASTEROID_BELT)
                    local gain = math.floor(d.AsteroidDamage/needed)
                    d.AsteroidDamage = d.AsteroidDamage % needed
                    if mod.IsNanOrInf(d.AsteroidDamage) then
                        d.AsteroidDamage = 0
                    end
                    d.AsteroidBelt = d.AsteroidBelt or {}
                    local cap = math.min(aBal.asteroidCap[2], aBal.asteroidCap[1]+aBal.asteroidCap[3]*mult)
                    local num = 0
                    for _,i in pairs(d.AsteroidBelt) do
                        num = num+1
                    end
                    local addMax = (cap-num)
                    local new = math.min(gain, addMax)
                    player:CheckFamiliar(mod.ITEM.FAMILIAR.ASTEROID, num+new, player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.ASTEROID_BELT), Isaac:GetItemConfig():GetCollectible(mod.ITEM.COLLECTIBLE.ASTEROID_BELT), 0)
                end
            end
        end
    end
end
mod:AddCollectibleCallback("FF_GENERIC_NPC_TAKE_DMG_FERRIUM", mod.ITEM.COLLECTIBLE.ASTEROID_BELT, mod.asteroidBeltTakeDmg)