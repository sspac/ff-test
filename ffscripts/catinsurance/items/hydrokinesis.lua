
local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local Hydrokinesis = {}

local RANGE_MULT = 0.4
local MIN_RADIUS = 40 * 0.75
local MIN_FIREDELAY_MULT = 0.8
local MAX_FIREDELAY_MULT = 2.33
local HEIGHT = -20
local SHOTSPEED_DOWN = 0.2
local TEAR_MULT = 0.5
local ROCKET_DELAY = 90 -- or so says the wiki...

local TECH_DOT = mod.FF.HKTechDot
local BRIM_SWIRL = mod.FF.HKBrimstoneSwirl
local FLOATING_KNIFE = mod.FF.HKFloatingKnife
local FETUS_MARKER = mod.FF.HKEpicFetusTarget
local FLOATING_SWORD = mod.FF.HKFloatingSword
local FLOATING_REVOLVER = mod.FF.HKFloatingRevolver

local transparent = Color(1, 1, 1, 0)
local transparentAndRed = Color(1, 0, 0, 0)

local GRIDS_TO_TARGET = {
    [GridEntityType.GRID_POOP] = true,
    [GridEntityType.GRID_TNT] = true,
}

local function clamp(num, min, max)
    if num < min then
		return min
	elseif num > max then
		return max
	else
		return num
	end
end

-- im really bad at mathy stuff but basically...
-- if the player shoots slow enough, their multiplier will start decrease exponentially.
-- this only really happens when their fire delay is so high that the lower multiplier balances itself out
local function getRaiseTime(player)
    local threshold = 50
    local mult
    if player.MaxFireDelay < threshold then
        mult = MAX_FIREDELAY_MULT
    else
        local subtractor = threshold * 0.1 + math.exp((player.MaxFireDelay - threshold) * 0.1)
        mult = (player.MaxFireDelay - subtractor) / player.MaxFireDelay
    end
    return clamp(mult, MIN_FIREDELAY_MULT, MAX_FIREDELAY_MULT) * player.MaxFireDelay
end

---@param player EntityPlayer
local function getHydroDelay(player)
    local divider = 1.5
    if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE)
    or player:HasCollectible(CollectibleType.COLLECTIBLE_EPIC_FETUS)
    or player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION) then
        divider = 0.7
    end
    local delay = player.MaxFireDelay // divider

    -- Diminish delay so it's not too high or low
    local lowestDelay = 5
    local startDiminishingLow = 10

    local highestDelay = 40
    local startDiminishingHigh = 30

    -- TODO: Remove this once TearFlagsLib has Monstro's Lung support
    local weapon = player:GetWeapon(1)
    local weaponType = weapon and weapon:GetWeaponType() or WeaponType.WEAPON_TEARS
    if weaponType == WeaponType.WEAPON_MONSTROS_LUNGS then
        startDiminishingHigh = 10
        highestDelay = 20
    end

    if delay < startDiminishingLow then
        local diminished = mod:DiminishingValue(delay, 0, startDiminishingLow, lowestDelay, startDiminishingLow, 1)
        delay = diminished
    elseif delay > startDiminishingHigh then
        local diminished = mod:DiminishingValue(delay, 0, delay, startDiminishingHigh, highestDelay, 1)
        delay = diminished
    end
    
    return delay
end

---@param tear EntityTear
---@return EntityPlayer?
local function getPlayerFromTear(tear)
    -- PosDisplacement used to detect sprinkler
    if tear.SpawnerEntity then
        if tear.SpawnerType == EntityType.ENTITY_PLAYER then
            return tear.SpawnerEntity:ToPlayer()
        elseif tear.SpawnerType == EntityType.ENTITY_FAMILIAR then
            return tear.SpawnerEntity:ToFamiliar().Player
        end
    end
end

-- Gets the nearest target position, whether that be a grid entity or an enemy
local function getTargetPosition(position, radius)
    local candidate, closestDistance
    local fakeGrid, closestFakeGrid
    local grid, closestGrid

    -- I have to use GetRoomEntities because fires have NO_QUERY, which makes them not detectable by FindInRadius
    for _, enemy in ipairs(Isaac.GetRoomEntities()) do
        if enemy.Position:Distance(position) <= radius and not enemy:IsDead() then
            if enemy:IsVulnerableEnemy() and enemy:IsActiveEnemy() and not (enemy:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) or enemy:HasEntityFlags(EntityFlag.FLAG_FRIENDLY_BALL)) then
                local distance = enemy.Position:Distance(position)
                if not closestDistance or closestDistance > distance then
                    candidate = enemy.Position
                    closestDistance = distance
                end
            end

            if (enemy.Type == EntityType.ENTITY_FIREPLACE and enemy.HitPoints > 1) or (enemy.Type == EntityType.ENTITY_MOVABLE_TNT and enemy.HitPoints > 0.5) then
                local distance = enemy.Position:Distance(position)
                if not closestFakeGrid or closestFakeGrid > distance then
                    fakeGrid = enemy.Position
                    closestDistance = distance
                end
            end
        end
    end

    -- try aiming towards nearby grids
    if not candidate then
        local room = game:GetRoom()
        for i = 1, 8 do
            local angle = Vector.FromAngle(i * 45)
            for dist = 1, radius // 40 do
                local pos = position + angle:Resized(dist * 40)
                local gridEnt = room:GetGridEntityFromPos(pos)
                if gridEnt and GRIDS_TO_TARGET[gridEnt:GetType()] then
                    -- not popped poop and not exploded tnt
                    if gridEnt.State ~= 1000 and gridEnt.State ~= 4 then
                        local distance = gridEnt.Position:Distance(position)
                        if not closestGrid or closestGrid > distance then
                            grid = gridEnt.Position
                            closestGrid = distance
                        end
                    end
                end
            end
        end
    end

    return candidate or grid or fakeGrid
end

---------------------
-- HYDRO SPAWNING
---------------------

---@param player EntityPlayer
function mod:HandleHydroSpawning(player)
    if not player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.HYDROKINESIS) then return end

    local data = mod:GetEntityData(player)
    data.HydrokinesisCooldown = data.HydrokinesisCooldown or getHydroDelay(player)
    data.HydrokinesisCooldown = math.max(data.HydrokinesisCooldown - 1, 0)

    if player:GetAimDirection():Length() > 1e-3 and data.HydrokinesisCooldown == 0 then
        data.HydrokinesisCooldown = getHydroDelay(player)
        local weapon = player:GetWeapon(1)
        local weaponType = weapon and weapon:GetWeaponType() or WeaponType.WEAPON_TEARS

        local rng = player:GetCollectibleRNG(FiendFolio.ITEM.COLLECTIBLE.HYDROKINESIS)
        local raiseTime = getRaiseTime(player)

        local radius = player.TearRange * RANGE_MULT
        local direction = data.HydroLastAttackDirection or Vector.Zero
        local distance = rng:RandomVector() * rng:RandomInt(MIN_RADIUS, math.floor(math.max(MIN_RADIUS, radius)))

        local spawnPos = player.Position + (direction * 70) + distance

        -- Get color values for the spawned weapons
        local tearColor = Color.Lerp(player.TearColor, Color.Default, 0)
        tearColor.A = 0
        local laserColor = Color.Lerp(player.LaserColor, Color.Default, 0)
        laserColor.A = 0

		mod.IgnoreSecondaryFireEffects = true
        if weaponType == WeaponType.WEAPON_FETUS then
            local tear = player:FireTear(player.Position, Vector.Zero, false, true, false, player)
            tear:AddTearFlags(TearFlags.TEAR_FETUS)
            tear:ChangeVariant(TearVariant.FETUS)
            mod:HydrokinesisControlTear(tear)
        elseif (
            weaponType == WeaponType.WEAPON_LUDOVICO_TECHNIQUE
            or weaponType == WeaponType.WEAPON_TEARS
            or weaponType == WeaponType.WEAPON_BONE
            or weaponType == WeaponType.WEAPON_MONSTROS_LUNGS
        ) then
            local isLudo = weaponType == WeaponType.WEAPON_LUDOVICO_TECHNIQUE
            if isLudo then
                spawnPos = player:GetActiveWeaponEntity().Position + distance
            end

            if mod:IsAnyFriend(player) then
                local gun = Isaac.Spawn(EntityType.ENTITY_EFFECT, FLOATING_REVOLVER.Var, FLOATING_REVOLVER.Sub, spawnPos, Vector.Zero, player)
                local gunData = mod:GetEntityData(gun)

                gun:SetColor(transparent, math.max(math.floor(raiseTime / 3), 10), 100, true, true)

                gunData.Hydrokinesis = raiseTime
                gunData.CollisionDivider = isLudo and 3 or 1
            else
                local tear = player:FireTear(isLudo and spawnPos or player.Position, Vector.Zero, false, true, true, player)
                if isLudo then
                    tear.CollisionDamage = tear.CollisionDamage / 3
                end
                mod:HydrokinesisControlTear(tear, weaponType == WeaponType.WEAPON_MONSTROS_LUNGS)
            end
        elseif weaponType == WeaponType.WEAPON_KNIFE then
            local floatingKnife = Isaac.Spawn(EntityType.ENTITY_EFFECT, FLOATING_KNIFE.Var, FLOATING_KNIFE.Sub, spawnPos, Vector.Zero, player)
            local knifeData = mod:GetEntityData(floatingKnife)

            floatingKnife:SetColor(transparent, math.max(math.floor(raiseTime / 3), 10), 100, true, true)

            knifeData.Hydrokinesis = raiseTime
        elseif weaponType == WeaponType.WEAPON_LASER or weaponType == WeaponType.WEAPON_TECH_X then
            local dot = Isaac.Spawn(EntityType.ENTITY_EFFECT, TECH_DOT.Var, TECH_DOT.Sub, spawnPos, Vector.Zero, player)
            local dotData = mod:GetEntityData(dot)

            dot.Color = player.LaserColor
            dot:SetColor(laserColor, math.max(math.floor(raiseTime / 3), 10), 100, true, true)

            dotData.Hydrokinesis = raiseTime
            dotData.TechXRadius = 45 -- arbitrary number that isnt too crazy
            dotData.HydroTechXDot = weaponType == WeaponType.WEAPON_TECH_X

            dot.PositionOffset = Vector(0, 10)
        elseif weaponType == WeaponType.WEAPON_BOMBS then
            local bomb = player:FireBomb(player.Position, Vector.Zero, player)
            Hydrokinesis:ControlBomb(bomb)
        elseif weaponType == WeaponType.WEAPON_ROCKETS then
            local fetusMarker = Isaac.Spawn(EntityType.ENTITY_EFFECT, FETUS_MARKER.Var, FETUS_MARKER.Sub, spawnPos, Vector.Zero, player)
            local markerData = mod:GetEntityData(fetusMarker)

            fetusMarker.Color = Color(0.6, 0, 0)
            fetusMarker:SetColor(transparentAndRed, math.max(math.floor(raiseTime / 3), 10), 100, true, true)

            fetusMarker:GetSprite().PlaybackSpeed = 0.33

            markerData.Hydrokinesis = raiseTime
        elseif weaponType == WeaponType.WEAPON_BRIMSTONE then
            local swirl = Isaac.Spawn(EntityType.ENTITY_EFFECT, BRIM_SWIRL.Var, BRIM_SWIRL.Sub, spawnPos, Vector.Zero, player)
            local swirlData = mod:GetEntityData(swirl)

            swirlData.Hydrokinesis = raiseTime
            swirlData.OldScale = 1
            swirl.Color = player.LaserColor

            swirlData.PositionOffset = Vector(0, 10)
        elseif weaponType == WeaponType.WEAPON_SPIRIT_SWORD then
            local floatingSword = Isaac.Spawn(EntityType.ENTITY_EFFECT, FLOATING_SWORD.Var, FLOATING_SWORD.Sub, spawnPos, Vector.Zero, player)
            local swordData = mod:GetEntityData(floatingSword)

            floatingSword.Color = player.TearColor
            floatingSword:SetColor(tearColor, math.max(math.floor(raiseTime / 3), 10), 100, true, true)

            swordData.Hydrokinesis = raiseTime

            local sprite = floatingSword:GetSprite()
            sprite.Offset = Vector(0, -10)
            if player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY) then
                for i = 0, 2 do
                    sprite:ReplaceSpritesheet(i, "gfx/effects/hydrokinesis_techsword.png")
                end

                sprite:LoadGraphics()
                sprite.Scale = Vector.One * 0.7
            else
                sprite.Scale = Vector.One * 0.8
            end

        end
		mod.IgnoreSecondaryFireEffects = false
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.COLLECTIBLE.HYDROKINESIS, mod.HandleHydroSpawning)

---------------------
-- CONTROL NORMAL TEARS
---------------------

---@param tear EntityTear
function mod:HydrokinesisControlTear(tear, isMonstrosLung)
    local player = getPlayerFromTear(tear)
    if not player then return end

    local rng = player:GetCollectibleRNG(FiendFolio.ITEM.COLLECTIBLE.HYDROKINESIS)
    local raiseTime = getRaiseTime(player)
    local data = mod:GetEntityData(tear)

    if tear:HasTearFlags(TearFlags.TEAR_HOMING) then
        data.HydroWasHoming = true
    end

    if tear:HasTearFlags(TearFlags.TEAR_SHRINK) then
        data.HydroWasProptosis = true
    end

    if tear:HasTearFlags(TearFlags.TEAR_FETUS) then
        data.HydroFetusTear = true
    end

    tear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
    tear:ClearTearFlags(TearFlags.TEAR_HOMING | TearFlags.TEAR_FETUS | TearFlags.TEAR_TRACTOR_BEAM | TearFlags.TEAR_LUDOVICO | TearFlags.TEAR_SHRINK)
    local color = Color(tear.Color.R, tear.Color.G, tear.Color.B, 0, tear.Color.RO, tear.Color.GO, tear.Color.BO)

    if #tear.Color:GetColorize() > 0 then
        color:SetColorize(table.unpack(tear.Color:GetColorize()))
    end

    if #tear.Color:GetTint() > 0 then
        color:SetTint(table.unpack(tear.Color:GetTint()))
    end

    if #tear.Color:GetOffset() > 0 then
        color:SetOffset(table.unpack(tear.Color:GetOffset()))
    end

    data.OldFallingAcceleration = tear.FallingAcceleration
    data.OldFallingSpeed = tear.FallingSpeed

    tear.FallingAcceleration = -0.1
    tear.FallingSpeed = 0

    tear:SetColor(color, math.max(math.floor(raiseTime / 3), 10), 255, true, true)

    local direction = mod:GetEntityData(player).HydroLastAttackDirection or Vector.Zero
    local radius = math.floor(player.TearRange * RANGE_MULT)
    local distance = rng:RandomVector() * rng:RandomInt(MIN_RADIUS, math.max(MIN_RADIUS, radius))
    tear.Position = tear.Position + (direction * 70) + distance
    tear.Velocity = Vector.Zero

    data.HydroShotSpeed = player.ShotSpeed * 8
    data.HydroRange = player.TearRange
    data.Hydrokinesis = raiseTime
    data.HydroLung = isMonstrosLung

    data.OriginalHeight = tear.Height
    tear.Height = -5
end

---@param tear EntityTear
function mod:UpdateHydroTear(tear)
    local data = mod:GetEntityData(tear)
    if not data.Hydrokinesis then return end

    if tear.FrameCount > data.Hydrokinesis then
        local nearestPos = getTargetPosition(tear.Position, math.floor(data.HydroRange))
        if nearestPos then
            tear:AddVelocity((nearestPos - tear.Position):Normalized() * data.HydroShotSpeed)
            tear.Rotation = (nearestPos - tear.Position):Normalized():GetAngleDegrees()
            tear.SpriteRotation = tear.Rotation
        end

        tear.FallingAcceleration = data.OldFallingAcceleration
        tear.FallingSpeed = data.OldFallingSpeed

        if data.HydroWasHoming then
            tear:AddTearFlags(TearFlags.TEAR_HOMING)
        end

        if data.HydroFetusTear then
            tear:AddTearFlags(TearFlags.TEAR_FETUS)
        end

        if data.HydroWasProptosis then
            tear:AddTearFlags(TearFlags.TEAR_SHRINK)
        end

        data.Hydrokinesis = nil
    else
        tear.Height = mod:Lerp(tear.Height, data.OriginalHeight, math.min(1, tear.FrameCount / data.Hydrokinesis))
        tear.Velocity = Vector.Zero
    end
end

mod:AddCollectibleCallback(ModCallbacks.MC_POST_TEAR_UPDATE, mod.ITEM.COLLECTIBLE.HYDROKINESIS, mod.UpdateHydroTear)

---------------------
-- LASER SYNERGY
---------------------

---@param dot EntityEffect
function mod:UpdateHydroLaser(dot)
    local data = mod:GetEntityData(dot)

    if dot:GetSprite():IsFinished("Disappear") then
        dot:Remove()
    end

    if not data.Hydrokinesis then return end

    local player = getPlayerFromTear(dot)
    if dot.FrameCount > data.Hydrokinesis then
        local nearestPos = getTargetPosition(dot.Position, math.floor(player.TearRange))
        if nearestPos then
            -- Do tech laser
            local direction = (nearestPos - dot.Position):Normalized()
            if data.HydroTechXDot then
                local laser = player:FireTechLaser(dot.Position, LaserOffset.LASER_BRIMSTONE_OFFSET, direction, false, true, dot, 1)
                laser.Parent = player
                laser.SubType = LaserSubType.LASER_SUBTYPE_RING_PROJECTILE
                laser.Timeout = 30
                laser.Radius = data.TechXRadius
                laser.DisableFollowParent = true
                laser.Velocity = direction * player.ShotSpeed * 8
                laser:AddTearFlags(TearFlags.TEAR_SPECTRAL)

            else
                local laser = player:FireTechLaser(dot.Position, LaserOffset.LASER_BRIMSTONE_OFFSET, direction, false, true, dot, 1)
                laser:AddTearFlags(TearFlags.TEAR_SPECTRAL)
                laser.Parent = player
                laser.DisableFollowParent = true
                laser.OneHit = true
            end

        end

        dot:GetSprite():Play("Disappear", true)
        data.Hydrokinesis = nil
    else
        dot.PositionOffset = Vector(0, mod:Lerp(dot.PositionOffset.Y, HEIGHT, math.min(1, dot.FrameCount / data.Hydrokinesis)))
    end
end

---------------------
-- DR. FETUS SYNERGY
---------------------

---@param bomb EntityBomb
function Hydrokinesis:ControlBomb(bomb)
    local player = getPlayerFromTear(bomb)
    if not player then return end
    if not player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.HYDROKINESIS) then return end

    local rng = player:GetCollectibleRNG(FiendFolio.ITEM.COLLECTIBLE.HYDROKINESIS)
    local raiseTime = getRaiseTime(player)
    local data = mod:GetEntityData(bomb)

    if bomb:HasTearFlags(TearFlags.TEAR_HOMING) then
        data.HydroWasHoming = true
    end

    bomb:AddTearFlags(TearFlags.TEAR_SPECTRAL)
    bomb:ClearTearFlags(TearFlags.TEAR_HOMING | TearFlags.TEAR_FETUS | TearFlags.TEAR_TRACTOR_BEAM | TearFlags.TEAR_LUDOVICO)
    local color = Color(bomb.Color.R, bomb.Color.G, bomb.Color.B, 0, bomb.Color.RO, bomb.Color.GO, bomb.Color.BO)

    if #bomb.Color:GetColorize() > 0 then
        color:SetColorize(table.unpack(bomb.Color:GetColorize()))
    end

    if #bomb.Color:GetTint() > 0 then
        color:SetTint(table.unpack(bomb.Color:GetTint()))
    end

    if #bomb.Color:GetOffset() > 0 then
        color:SetOffset(table.unpack(bomb.Color:GetOffset()))
    end

    bomb:SetColor(color, math.max(math.floor(raiseTime / 3), 10), 255, true, true)

    local direction = mod:GetEntityData(player).HydroLastAttackDirection or Vector.Zero
    local radius = math.floor(player.TearRange * RANGE_MULT)
    local distance = rng:RandomVector() * rng:RandomInt(MIN_RADIUS, math.max(MIN_RADIUS, radius))
    bomb.Position = bomb.Position + (direction * 70) + distance
    bomb.Velocity = Vector.Zero

    data.HydroShotSpeed = player.ShotSpeed * 8
    data.HydroRange = player.TearRange
    data.Hydrokinesis = raiseTime

    bomb:SetExplosionCountdown(bomb:GetExplosionCountdown() + math.floor(raiseTime))
end

---@param bomb EntityBomb
function Hydrokinesis:UpdateHydroBomb(bomb)
    local data = mod:GetEntityData(bomb)
    if not data.Hydrokinesis then return end

    if bomb.FrameCount > data.Hydrokinesis then
        local nearestPos = getTargetPosition(bomb.Position, data.HydroRange)
        if nearestPos then
            bomb:AddVelocity((nearestPos - bomb.Position):Normalized() * data.HydroShotSpeed)
        end

        bomb:AddTearFlags(TearFlags.TEAR_HOMING)

        if data.HydroFetusTear then
            bomb:AddTearFlags(TearFlags.TEAR_FETUS)
        end

        data.Hydrokinesis = nil
    end
end

mod:AddCollectibleCallback(ModCallbacks.MC_POST_BOMB_UPDATE, mod.ITEM.COLLECTIBLE.HYDROKINESIS, Hydrokinesis.UpdateHydroBomb)

---------------------
-- BRIMSTONE SYNERGY
---------------------

---@param swirl EntityEffect
function mod:UpdateHydroBrim(swirl)
    local sprite = swirl:GetSprite()
    local data = mod:GetEntityData(swirl)
    local player = swirl.SpawnerEntity and swirl.SpawnerEntity:ToPlayer() or Isaac.GetPlayer() -- for testing purposes

    if sprite:IsFinished("Shoot") then
        swirl:Remove()
        return
    end

    if not data.Hydrokinesis then return end

    if sprite:IsEventTriggered("Shoot") then
        local nearestPos = getTargetPosition(swirl.Position, math.floor(player.TearRange))
        if nearestPos then
            local direction = (nearestPos - swirl.Position):Normalized()
            local laser = player:FireBrimstone(direction, swirl)
            laser:AddTearFlags(TearFlags.TEAR_SPECTRAL)
            laser.Parent = player
            laser.DisableFollowParent = true
            laser.Position = swirl.Position
            laser.PositionOffset = Vector(0, 0)
            laser:SetScale(data.OldScale)

            mod:GetEntityData(laser).HydrokinesisBrimstone = true
        end

        data.Hydrokinesis = nil
        return
    end

    if sprite:IsFinished("Idle") then
        sprite:Play("Loop", true)
    end

    if swirl.FrameCount > data.Hydrokinesis and sprite:IsPlaying("Loop") then
        sprite:Play("Shoot", true)
    end
end

---------------------
-- MOM'S KNIFE SYNERGY
---------------------

---@param floatingKnife EntityEffect
function mod:UpdateHydroKnife(floatingKnife)
    local data = mod:GetEntityData(floatingKnife)

    -- The animation isnt fuckign working for some reason so rotate manually
    floatingKnife.SpriteRotation = floatingKnife.SpriteRotation + 23

    -- fade out
    if not data.Hydrokinesis then

        -- clone color and fade out
        local clonedColor = Color.Lerp(floatingKnife.Color, Color.Default, 0)
        clonedColor.A = math.max(clonedColor.A - 0.04, 0)
        floatingKnife.Color = clonedColor

        -- only remove if knife isnt in air.
        if floatingKnife.Color.A == 0 and (not data.HydroKnifeChild or not data.HydroKnifeChild.Ref) then
            floatingKnife:Remove()
        end

        return
    end

    local player = getPlayerFromTear(floatingKnife)
    if floatingKnife.FrameCount > data.Hydrokinesis then
        local nearestPos = getTargetPosition(floatingKnife.Position, math.floor(player.TearRange))
        if nearestPos then
            -- Do tech laser
            local direction = (nearestPos - floatingKnife.Position)

            local knife = player:FireKnife(floatingKnife, 0, false, KnifeSubType.DEFAULT, KnifeVariant.MOMS_KNIFE)
            knife.Rotation = direction:GetAngleDegrees()
            knife:Shoot(1, direction:Length())
            mod:GetEntityData(knife).RemoveOnReturn = true
            data.HydroKnifeChild = EntityPtr(knife)

            floatingKnife.Color = Color(1, 1, 1, 0)
        end

        data.Hydrokinesis = nil
    end
end

---------------------
-- SPIRIT SWORD SYNERGY
---------------------

---@param sword EntityEffect
function mod:UpdateHydroSword(sword)
    local player = getPlayerFromTear(sword)
    local data = mod:GetEntityData(sword)
    local sprite = sword:GetSprite()

    if not sprite:IsPlaying("Attack") then
        sword.SpriteRotation = sword.SpriteRotation + 23
    end

    -- fade out
    if not data.Hydrokinesis then

        -- clone color and fade out
        local clonedColor = Color.Lerp(sword.Color, Color.Default, 0)
        clonedColor.A = math.max(clonedColor.A - 0.04, 0)
        sword.Color = clonedColor

        if sprite:IsFinished("Attack") or sword.Color.A == 0 then
            sword:Remove()
        end

        return
    end

    if not player then return end
    if sword.FrameCount > data.Hydrokinesis then
        local nearestPos = getTargetPosition(sword.Position, math.floor(player.TearRange))
        if nearestPos then
            local isLightsaber = player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY)
            local direction = (nearestPos - sword.Position)
            
            -- Do cool sword beam
            if player:HasFullHearts() then
                local tear = player:FireTear(sword.Position, direction:Normalized() * player.ShotSpeed * 16, false, true, false)
                tear:AddTearFlags(TearFlags.TEAR_SPECTRAL)

                if isLightsaber then
                    tear:ChangeVariant(TearVariant.TECH_SWORD_BEAM)
                else
                    tear:ChangeVariant(TearVariant.SWORD_BEAM)
                end
            end

            -- Do cool sword swing
            local knifeVar = isLightsaber and KnifeVariant.TECH_SWORD or KnifeVariant.SPIRIT_SWORD
            local knife = Isaac.Spawn(EntityType.ENTITY_KNIFE, knifeVar, KnifeSubType.CLUB_HITBOX, sword.Position, Vector.Zero, player):ToKnife()
            knife.Visible = false
            knife:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

            knife.Parent = player
            knife.SpawnerEntity = player
            knife:SetIsSwinging(true)

            -- Make sure tearflags and stuff work
            local params = player:GetTearHitParams(WeaponType.WEAPON_SPIRIT_SWORD)
            knife.CollisionDamage = params.TearDamage
            knife.TearFlags = params.TearFlags
            TearFlagsLib.CallPollTearFlagCallback(knife, player, TearFlagsLib.WeaponFlag.SWORD)

            -- FX
            sword.SpriteRotation = direction:GetAngleDegrees() - 90
            sprite:Play("Attack", true)
            sfx:Play(SoundEffect.SOUND_SHELLGAME)
        end

        data.Hydrokinesis = nil
    end
end

---------------------
-- EPIC FETUS SYNERGY
---------------------

---@param marker EntityEffect
function mod:UpdateHydroFetusMarker(marker)
    local sprite = marker:GetSprite()
    local player = getPlayerFromTear(marker)
    local data = mod:GetEntityData(marker)

    if marker.FrameCount > data.Hydrokinesis then
        sprite:Play("Blink")

        if marker.FrameCount == math.ceil(data.Hydrokinesis) + ROCKET_DELAY - 10 then
            sfx:Play(FiendFolio.TempSoundEnums.EpicFetus)
        end

        local nearestPos = getTargetPosition(marker.Position, math.floor(player.TearRange))
        if nearestPos then
            local direction = nearestPos - marker.Position
            if direction:Length() > 5 then
                marker.Position = marker.Position + direction:Normalized():Resized(7)
            end
        end

        if marker.FrameCount > data.Hydrokinesis + ROCKET_DELAY and not data.RocketPtr then
            local rocket = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ROCKET, 0, marker.Position - Vector(0, Isaac.GetScreenHeight()), Vector.Zero, player):ToEffect()
            rocket.Parent = marker
            rocket.Timeout = 11
            mod:GetEntityData(rocket).Hydrokinesis = true
            data.RocketPtr = EntityPtr(rocket)
        end
    end

    if data.RocketPtr and not data.RocketPtr.Ref then
        marker:Remove()
    end
end

---@param rocket EntityEffect
function Hydrokinesis:UpdateHydroRocket(rocket)
    local data = mod:GetEntityData(rocket)
    if data.Hydrokinesis then
        rocket.SpriteOffset = Vector(0, (math.min(rocket.FrameCount, 10) - 10) * 100)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, Hydrokinesis.UpdateHydroRocket, EffectVariant.ROCKET)

---------------------
-- FRIEND SYNERGY :)
---------------------

---@param gun EntityEffect
function mod:UpdateHydroGun(gun)
    local player = gun.SpawnerEntity:ToPlayer()
    local data = mod:GetEntityData(gun)
    local sprite = gun:GetSprite()

    if not sprite:IsPlaying("Shoot") then
        gun.SpriteRotation = gun.SpriteRotation + 23
    end

    -- fade out
    if not data.Hydrokinesis then

        -- clone color and fade out
        local clonedColor = Color.Lerp(gun.Color, Color.Default, 0)
        clonedColor.A = math.max(clonedColor.A - 0.04, 0)
        gun.Color = clonedColor

        if gun.Color.A == 0 or sprite:IsFinished("Shoot") then
            gun:Remove()
        end

        return
    end

    if not player then return end
    if gun.FrameCount > data.Hydrokinesis then
        local nearestPos = getTargetPosition(gun.Position, math.floor(player.TearRange))
        if nearestPos then
            -- Do tech laser
            local direction = (nearestPos - gun.Position):Normalized()

            local tear = player:FireTear(gun.Position + direction * 10, direction * player.ShotSpeed * 8, false, true, true, player)
            tear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
            mod:TurnTearToFriendBullet(tear, gun.SubType, player)
			TearFlagsLib.AddTearFlags(tear, mod.FriendBulletFlags.NO_FALL_TEAR)
            sfx:Stop(SoundEffect.SOUND_TEARS_FIRE)
            sfx:Play(SoundEffect.SOUND_GFUEL_GUNSHOT, 1, 0, false, mod:RandomInt(90,100,player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.HYDROKINESIS))/100)

            tear.CollisionDamage = tear.CollisionDamage / data.CollisionDivider

            local angle = direction:GetAngleDegrees()
            if angle > 90 and angle <= 270 then
                sprite.FlipX = true
                gun.SpriteRotation = 180 - angle
            else
                sprite.FlipX = false
                gun.SpriteRotation = angle
            end
            sprite:Play("Shoot", true)
        end

        data.Hydrokinesis = nil
    end
end
--#region Other

---@param tear EntityTear
function Hydrokinesis:FixMultidimensionalBaby(tear)
    local sharedTear
    for _, other in ipairs(Isaac.FindByType(EntityType.ENTITY_TEAR)) do
        if other.InitSeed == tear.InitSeed then
            sharedTear = other
            break
        end
    end

    if sharedTear then
        local data = mod:GetEntityData(tear)
        local otherData = mod:GetEntityData(sharedTear)

        data.Hydrokinesis = otherData.Hydrokinesis
        data.HydroWasHoming = otherData.HydroWasHoming
        data.HydroLung = otherData.HydroLung
        data.HydroWasProptosis = otherData.HydroWasProptosis
        data.HydroFetusTear = otherData.HydroFetusTear
        data.HydroRange = otherData.HydroRange
        data.HydroShotSpeed = otherData.HydroShotSpeed
        data.OriginalHeight = otherData.OriginalHeight
        data.OldFallingAcceleration = otherData.OldFallingAcceleration
        data.OldFallingSpeed = otherData.OldFallingSpeed
    end
end

mod:AddEntityCallback(ModCallbacks.MC_POST_TEAR_INIT, EntityType.ENTITY_FAMILIAR, FamiliarVariant.MULTIDIMENSIONAL_BABY, 0, Hydrokinesis.FixMultidimensionalBaby, TearVariant.MULTIDIMENSIONAL)

-- so that if you tap fire, it still gets your last attack direction
function mod:UpdateHydroLastAttackDirection(player, data)
    local dir = player:GetAimDirection()
    if dir:Length() > 1e-3 then
        data.HydroLastAttackDirection = dir
    end
end

--#endregion