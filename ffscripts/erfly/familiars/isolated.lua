local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function (_, familiar)
    if familiar.OrbitDistance then
	    local isolationCount = familiar.Player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.ISOLATED)
        local data = mod:GetEntityData(familiar)
        if isolationCount > 0 then
            if not data.isolationOriginalOrbit then
                data.isolationOriginalOrbit = familiar.OrbitDistance
            end
            familiar.OrbitDistance = mod:Lerp(familiar.OrbitDistance, data.isolationOriginalOrbit * (isolationCount + 1), 0.2)
        else
            local data = mod:GetEntityData(familiar)
            if data.isolationOriginalOrbit then
                familiar.OrbitDistance = mod:Lerp(familiar.OrbitDistance, data.isolationOriginalOrbit, 0.2)
            end
        end
    end
end)

local function findShortestCircularDist(startAng, desiredAng)
    local val = 49
    local startVal = 250
    local smallestVal = 9999
    for i = -360, 360, 360 do
        local usedVal = desiredAng + i
        local resultVal = usedVal - startAng
        if math.abs(resultVal) < math.abs(smallestVal) then
            smallestVal = resultVal
        end
    end
    return smallestVal
end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, fam)
    fam.OrbitDistance = Vector(50,50)
    fam.OrbitSpeed = 1
    fam.OrbitLayer = mod.ITEM.FAMILIAR.ISOLATED
    fam:RecalculateOrbitOffset(fam.OrbitLayer, true)
end, mod.ITEM.FAMILIAR.ISOLATED)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, fam)
    local sprite = fam:GetSprite()
    local d = mod:GetEntityData(fam)
    local player = fam.Player

    d.StateFrame = d.StateFrame or 0
    d.StateFrame = d.StateFrame + 1
    d.ShotCount = d.ShotCount or 0

    if not d.coolTrail or d.coolTrail and not d.coolTrail:Exists() then
        local trail = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPRITE_TRAIL, 0, fam.Position, Vector.Zero, fam):ToEffect()
        trail.MinRadius = 0.12
        trail.SpriteScale = Vector(1.5,1)
        trail.Color = Color(53/255,38/255,79/255,1)
        trail:FollowParent(fam)
        trail.ParentOffset = Vector(0,-24)
        trail:Update()
        d.coolTrail = trail
    else
        d.coolTrail.ParentOffset = fam.SpriteOffset + Vector(0,-24)
    end

    if (not d.primeSubject) or (d.primeSubject and not d.primeSubject:Exists()) then
        local isolateds = Isaac.FindByType(3, mod.ITEM.FAMILIAR.ISOLATED)
        d.primeState = true
        d.primeSubject = fam
        local orbitIndex = 0
        local numIsolateds = 0
        for _, isolated in pairs(isolateds) do
            if GetPtrHash(isolated:ToFamiliar().Player) == GetPtrHash(player) then
                numIsolateds = numIsolateds + 1
                if GetPtrHash(isolated) > GetPtrHash(d.primeSubject) then
                    d.primeState = false
                    d.primeSubject = isolated
                end
                if GetPtrHash(isolated) > GetPtrHash(fam) then
                    orbitIndex = orbitIndex + 1
                end
            end
        end
        d.isolatedCount = numIsolateds
        d.OrbitIndex = orbitIndex
    end

    local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.ISOLATED)
    d.OrbitAng = d.OrbitAng or rng:RandomInt(360)
    if d.primeState then
        if not d.State then
            d.OrbitSpeed = d.OrbitSpeed or 1
            if d.StateFrame >= 5 then
                d.CanFire = true
            end
            if d.CanFire and player:GetAimDirection():Length() > 0.5 then
                d.State = "SpeedUp"
                d.StateFrame = 0
                local OrbitTarg
                if d.ShotCount == 0 or (not d.HeldAng) then
                    local angleChoice = rng:RandomInt(4)
                    if d.PrevAng then
                        while angleChoice == d.PrevAng do
                            angleChoice = rng:RandomInt(4)
                        end
                    end
                    OrbitTarg = (90 * angleChoice) - 25 --The -20 is because it looks odd otherwise, please bear it no mind
                    d.HeldAng = OrbitTarg
                    d.PrevAng = angleChoice
                else
                    OrbitTarg = d.HeldAng
                end
                local travel = findShortestCircularDist(d.OrbitAng, OrbitTarg)
                d.CanFire = false
                d.OrbitSpeed = travel / 5
            end
        elseif d.State == "SpeedUp" then
            if d.StateFrame >= 5 then
                d.State = nil
                d.StateFrame = 0
                if d.OrbitSpeed > 0 then
                    d.OrbitSpeed = 1
                else
                    d.OrbitSpeed = -1
                end
                --Shoot
                local isolateds = Isaac.FindByType(3, mod.ITEM.FAMILIAR.ISOLATED)
                for _, isolated in pairs(isolateds) do
                    if GetPtrHash(isolated:ToFamiliar().Player) == GetPtrHash(player) then
                        mod:GetEntityData(isolated).Shooting = true
                    end
                end
            end
        end
        d.OrbitAng = (d.OrbitAng + d.OrbitSpeed) % 360
    else
        if d.primeSubject then
            if mod:GetEntityData(d.primeSubject).OrbitAng then
                d.OrbitAng = mod:GetEntityData(d.primeSubject).OrbitAng + ((360/d.isolatedCount) * d.OrbitIndex)
            end
        end
    end
    if d.Shooting then
        local ang = -90 + (90 * rng:RandomInt(4))
        if ang >= 180 then
            ang = 90
        end
        local vec = (fam.Position - player.Position):Resized(10):Rotated(ang)
        local tear = Isaac.Spawn(2, 41, 0, fam.Position, vec, fam):ToTear()
        tear:AddTearFlags(TearFlags.TEAR_ICE)
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
            tear.CollisionDamage = tear.CollisionDamage * 2
            tear.Scale = 1.1
        else
            tear.Scale = 0.9
        end
        if player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
            tear.TearFlags = tear.TearFlags | TearFlags.TEAR_HOMING
            TearFlagsLib.AddTearFlags(tear, TearFlagsLib.Flag.YIN_YANG)
            TearFlagsLib.SetTearFlagParams(tear, TearFlagsLib.Flag.YIN_YANG, {Strength = 0.05})
            tear.Color = FiendFolio.ColorPsy
        end

        sfx:Play(SoundEffect.SOUND_FREEZE_SHATTER, 0.2, 0, false, 1.25)
        d.ShotCount = (d.ShotCount + 1) % 4
        d.Shooting = false
    end
    fam.OrbitDistance = mod:Lerp(fam.OrbitDistance, Vector(75,0), 0.2)
    local targetPosition = player.Position + fam.OrbitDistance:Rotated(d.OrbitAng)
    fam.Velocity = targetPosition - fam.Position

end, mod.ITEM.FAMILIAR.ISOLATED)

mod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, function(_, fam, coll)
    if coll.Type == 9 then
        coll:Die()
    end
end, mod.ITEM.FAMILIAR.ISOLATED)