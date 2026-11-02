local mod = FiendFolio
local sfx = SFXManager()

local Constants = {
    -- 1 level = 1 satellite
    LevelThresholds = {
        0, -- level 1
        100, -- level 2
        200, -- level 3
        300, -- level 4
    },

    FireRate = 10,
    Damage = 1.25,

    SatelliteDistance = 20,

    AnimationEnum = {
        [Direction.NO_DIRECTION] = "Down",
        [Direction.DOWN] = "Down",
        [Direction.LEFT] = "Left",
        [Direction.RIGHT] = "Right",
        [Direction.UP] = "Up",
    },
}

local config = Isaac.GetItemConfig():GetCollectible(mod.ITEM.COLLECTIBLE.LIL_INABA)

---@param familiar EntityFamiliar
function mod:LilInabaUpdate(familiar)
    local player = familiar.Player
    local d = mod:GetEntityData(familiar)
    local sprite = familiar:GetSprite()
    local fireDirection = player:GetFireDirection()

    local mult = familiar:GetMultiplier()
    local kills = familiar.Coins
    local maxFireRate = Constants.FireRate
    if player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) then
        maxFireRate = maxFireRate // 2
    end

    
    -- Get the appropriate number of satellites
    local maxSatellites = 1
    for i = #Constants.LevelThresholds, 1, -1 do
        local threshold = Constants.LevelThresholds[i]
        if kills >= threshold then
            maxSatellites = i
            break
        end
    end
    
    -- Play effects if new level
    if familiar.Keys ~= maxSatellites then
        sfx:Play(mod.Sounds.InabaPowerLevelUp, 1, 0, false, 1)
    end
    
    familiar.Keys = maxSatellites
    
    -- Remove non-existant satellites
    d.LilInabaSatellites = d.LilInabaSatellites or {}

    for i = #d.LilInabaSatellites, 1, -1 do
        local ptr = d.LilInabaSatellites[i]
        if not ptr or not ptr.Ref then
            d.LilInabaSatellites[i] = nil
        end
    end

    -- Add missing satellites
    if #d.LilInabaSatellites < maxSatellites then
        for _ = #d.LilInabaSatellites, maxSatellites-1 do
            local satellite = Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.FF.LilInabaSatellite.Var, mod.FF.LilInabaSatellite.Sub, familiar.Position, Vector.Zero, familiar)
            satellite.Parent = familiar
            table.insert(d.LilInabaSatellites, EntityPtr(satellite))
        end
    end

    -- Handle fire detection
    local justFired = false
    familiar.FireCooldown = math.max(familiar.FireCooldown - 1, 0)
    d.LilInabaLastFireDirection = d.LilInabaLastFireDirection or Direction.NO_DIRECTION
    local shouldStopFiringAnim = familiar.FireCooldown < maxFireRate // 2
    if fireDirection ~= Direction.NO_DIRECTION and familiar.FireCooldown == 0 then
        justFired = true
        familiar.FireCooldown = maxFireRate
        d.LilInabaLastFireDirection = fireDirection
        d.LilInabaAnim = Constants.AnimationEnum[fireDirection]
    elseif shouldStopFiringAnim then
        d.LilInabaAnim = nil
    end

    local aimVec = mod.DirectionToVector[d.LilInabaLastFireDirection]
    if shouldStopFiringAnim then
        aimVec = mod.DirectionToVector[fireDirection == Direction.NO_DIRECTION and Direction.DOWN or fireDirection]
    end

    local positions = {}
    local offsets = {}
    for i = 1, maxSatellites do
        local offset = (360 / maxSatellites) * (i - 1) + (90 * (maxSatellites - 1))
        positions[i] = player.Position + aimVec:Rotated(offset)
        offsets[i] = offset
    end

    --- Setup angles
    local nonPtrSats = {}
    for _, sat in ipairs(d.LilInabaSatellites) do
        if sat.Ref then
            table.insert(nonPtrSats, sat.Ref)
        end
    end
    
    local pairs = mod:PairEntitiesToPositions(nonPtrSats, positions)
    for i, pair in ipairs(pairs) do
        local satData = mod:GetEntityData(pair.ent)
        satData.SatelliteOffset = offsets[pair.posind]
        satData.CurrentAngle = aimVec:GetAngleDegrees() + satData.SatelliteOffset
    end

    --- Handle making the satellites rotate around the familiar
    local targetSatelliteRotationSpeed = 0
    if targetSatelliteRotationSpeed > 0 then
        d.satelliteRotationSpeed = mod:Lerp(d.satelliteRotationSpeed or 0, targetSatelliteRotationSpeed, 0.2)
        d.satelliteRotation = ((d.satelliteRotation or 0) + d.satelliteRotationSpeed) % 360
    else
        d.satelliteRotationSpeed = 0
        if (d.satelliteRotation or 0) > 0.1 then
            d.satelliteRotation = mod:LerpAngleDegrees(d.satelliteRotation or 0, 0, mod.InabaBal.SatelliteRotationSpeed * 0.5)
        else
            d.satelliteRotation = 0
        end
    end

    --- Update positions and animations
    local anim = (d.LilInabaAnim or Constants.AnimationEnum[d.LilInabaLastFireDirection])
    if shouldStopFiringAnim then
        anim = Constants.AnimationEnum[fireDirection]
    end
	local hasBabyBender = player:HasTrinket(TrinketType.TRINKET_BABY_BENDER)
	local isSuperpositioned = mod:isSuperpositionedPlayer(player)
    for _, ptr in ipairs(d.LilInabaSatellites) do
        local sat = ptr.Ref and ptr.Ref:ToEffect()
        if sat then
            local satSprite = sat:GetSprite()
            local satData = mod:GetEntityData(sat)

            local targetAngle = aimVec:GetAngleDegrees() + (d.satelliteRotation or 0) + satData.SatelliteOffset
            local currentAngleVec = Vector.FromAngle(satData.CurrentAngle)
            satData.CurrentAngle = mod:LerpAngleDegrees(currentAngleVec, targetAngle, mod.InabaBal.SatelliteRotationSpeed) % 360

            local satVec = (currentAngleVec * Constants.SatelliteDistance)

            local targetPos = familiar.Position + satVec + familiar.Velocity
            local targetLerpStrength = 0.85

            if sat.FrameCount == 0 or not (sat.Position.X == sat.Position.X) then
                sat.Position = targetPos
                sat.Velocity = mod.nilvector
            end

            -- We are ALSO three lerps deep
            satData.LerpStrength = mod:Lerp(math.min(satData.LerpStrength or targetLerpStrength, targetLerpStrength), targetLerpStrength, 0.1)
            sat.Velocity = mod:Lerp(sat.Velocity, mod:Lerp(sat.Position, targetPos, mod.InabaBal.SatellitePositionSpeed) - sat.Position, satData.LerpStrength)

            -- Shoot tears
            if justFired then
                local spread = mod.InabaBal.SatelliteSpread
                local projDir = aimVec:Rotated(mod:RandomInt(-spread, spread))
                
                local proj = familiar:FireProjectile(projDir)
                proj.Position = targetPos
                proj.CollisionDamage = Constants.Damage * mult
                proj.Color = mod:GetInabaTearColor(false, nil, false, proj.Color)
            end

            -- Update anims
            if d.LilInabaAnim then
                if shouldStopFiringAnim then
                    mod:spritePlay(satSprite, "Idle" .. anim)
                else
                    mod:spritePlay(satSprite, "Shoot" .. anim)
                end
            else
                mod:spritePlay(satSprite, "Idle" .. anim)
            end
			
			local color = Color(1.0, 1.0, 1.0, 1, 0/255, 0/255, 0/255)
			if hasBabyBender then
				color = Color(0.4, 0.15, 0.38, 1, 55/255, 5/255, 95/255)
			end
			if isSuperpositioned then
				color.A = color.A / 4
			end
			sat.Color = mod:GetInabaTearColor(false, nil, false, color)
        end
    end

    -- Update familiar animations and position
    mod:spritePlay(sprite, "Float" .. anim)

    familiar:FollowParent()
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.LilInabaUpdate, mod.ITEM.FAMILIAR.LIL_INABA)

function mod:LilInabaSatelliteUpdate(effect)
    -- Poof and remove if no familiar
    if not effect.Parent then
        local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, effect.Position, Vector.Zero, nil)
        poof.SpriteScale = Vector(0.5, 0.5)
        poof.SpriteOffset = Vector(0, -12)
        poof.Color = mod:GetInabaTearColor(false, nil, false, effect.Color)
        effect:Remove()
    end
end

---@param familiar EntityFamiliar
function mod:LilInabaInit(familiar)
    familiar:AddToFollowers()
end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, mod.LilInabaInit, mod.ITEM.FAMILIAR.LIL_INABA)

function mod:LilInabaOnKill(npc)
    local nearestFam, maxDist
    for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.LIL_INABA)) do
        if not nearestFam or nearestFam.Position:Distance(npc.Position) < maxDist then
            nearestFam = ent:ToFamiliar()
            maxDist = nearestFam.Position:Distance(npc.Position)
        end
    end

    if nearestFam then
        mod.SpawnInabaPowerItem(2, npc.Position)
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.ITEM.COLLECTIBLE.LIL_INABA, mod.LilInabaOnKill)

---@param player EntityPlayer
function mod:LilInabaCacheEvaluate(player)
    local count = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.LIL_INABA) + player:GetEffects():GetCollectibleEffectNum(mod.ITEM.COLLECTIBLE.LIL_INABA)
    local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.LIL_INABA)
    player:CheckFamiliar(mod.ITEM.FAMILIAR.LIL_INABA, count, rng, config)
    for _ = 1, count do
        rng:Next()
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.LilInabaCacheEvaluate, CacheFlag.CACHE_FAMILIARS)