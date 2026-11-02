local mod = FiendFolio
local game = Game()
local sfx = SFXManager()


-- Code Taken from dssmenucore.lua
-- Hue: Changes the hue (0.0 = red, 0.5 = is around blue, 1.0 = also red)
-- Saturation: How vivid the color is
-- Value: Color brightness
function mod:ColorHSV(h, s, v, a, hO, sO, vO)
    local r, g, b

    h = math.fmod(h,1)

    local i = math.floor(h * 6);
    local f = h * 6 - i;
    local p = v * (1 - s);
    local q = v * (1 - f * s);
    local t = v * (1 - (1 - f) * s);

    i = i % 6

    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q
    end

    local rO, gO, bO

    local iO = math.floor(hO * 6);
    local fO = hO * 6 - iO;
    local pO = vO * (1 - sO);
    local qO = vO * (1 - fO * sO);
    local tO = vO * (1 - (1 - fO) * sO);

    iO = iO % 6

    if iO == 0 then rO, gO, bO = vO, tO, pO
    elseif iO == 1 then rO, gO, bO = qO, vO, pO
    elseif iO == 2 then rO, gO, bO = pO, vO, tO
    elseif iO == 3 then rO, gO, bO = pO, qO, vO
    elseif iO == 4 then rO, gO, bO = tO, pO, vO
    elseif iO == 5 then rO, gO, bO = vO, pO, qO
    end

    return Color(r, g, b, a, rO, gO, bO)
end

-- Helper for getting the costume suffix for a skin color
function mod:GetSkinColorSuffix(skincolor)
	if skincolor == SkinColor.SKIN_PINK then
		return ""
	elseif skincolor == SkinColor.SKIN_BLACK then
		return "_black"
	elseif skincolor == SkinColor.SKIN_BLUE then
		return "_blue"
	elseif skincolor == SkinColor.SKIN_RED then
		return "_red"
	elseif skincolor == SkinColor.SKIN_GREEN then
		return "_green"
	elseif skincolor == SkinColor.SKIN_GREY then
		return "_grey"
	else
		return "_white"
	end
end

function FiendFolio:IsHeartUnlocked(heartVar, heartSub)
    -- Vanilla heart
    if heartVar == PickupVariant.PICKUP_HEART then
        local heartsVanilla = {
            [HeartSubType.HEART_GOLDEN]     = Achievement.GOLDEN_HEARTS,
            [HeartSubType.HEART_HALF_SOUL]  = Achievement.EVERYTHING_IS_TERRIBLE,
            [HeartSubType.HEART_SCARED]     = Achievement.SCARED_HEART,
            [HeartSubType.HEART_BONE]       = Achievement.FORGOTTEN,
            [HeartSubType.HEART_ROTTEN]     = Achievement.ROTTEN_HEARTS,
        }

        local gameData = Isaac.GetPersistentGameData()
        local achievement = heartsVanilla[heartSub]
        if achievement then
            return gameData:Unlocked(achievement)
        end

        return true
    end

    -- FF hearts
    local heartsFF = {
        [mod.PICKUP.VARIANT.IMMORAL_HEART]              = "IMMORAL_HEART",
        [mod.PICKUP.VARIANT.HALF_IMMORAL_HEART]         = "IMMORAL_HEART",

        [mod.PICKUP.VARIANT.MORBID_HEART]               = "MORBID_HEART",
        [mod.PICKUP.VARIANT.TWOTHIRDS_MORBID_HEART]     = "MORBID_HEART",
        [mod.PICKUP.VARIANT.THIRD_MORBID_HEART]         = "MORBID_HEART",

        [mod.PICKUP.VARIANT.FOOLS_GOLD_HEART]           = "FOOLS_GOLD_HEART",
    }

    local achievement = heartsFF[heartVar]
    if achievement then
        return mod.ACHIEVEMENT[achievement]:IsUnlocked()
    end

    -- A special exception for steven hearts
    if heartVar == mod.PICKUP.VARIANT.STEVEN_HEART then
        local gameData = Isaac.GetPersistentGameData()
        return gameData:Unlocked(Achievement.STEVEN)
    end

    return true
end

-- Helper for spawning a heart.
-- `heartList` is a table of {var, sub}, where it spawns the first unlocked heart in the list.
--
-- Ex: `{{PickupVariant.PICKUP_HEART, HeartSubType.HEART_BONE}, {mod.PICKUP.VARIANT.IMMORAL_HEART, 0}, {PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL}}`
--
-- The above example will spawn a bone heart if unlocked, otherwise an immoral heart, otherwise a normal full red heart.
function FiendFolio:TrySpawnHeart(heartList, position, velocity, spawner)
    for _, heartInfo in ipairs(heartList) do
        local variant, subType = table.unpack(heartInfo)
        if mod:IsHeartUnlocked(variant, subType) then
            Isaac.Spawn(EntityType.ENTITY_PICKUP, variant, subType, position, velocity, spawner)
            return heartInfo
        end
    end
end

-- Helpers for for firing Monstro's Lung tears/bombs/lasers, recreated from vanilla decomps by Taiga and Connor

function mod:GetMonstroBurstInfo(pos, baseVel, num, baseFallSpeed, baseFallAccel)
    local out = {}

    for i = 1, (num or 14) do
        local a = mod:RandomFloat(-1, 1)
        local b = mod:RandomFloat(-1, 1) * math.pi * 2

        local tearVelX = math.cos(b) * a * 3.5 + baseVel.X
        local tearVelY = math.sin(b) * a * 3.5 + baseVel.Y

        local fallingSpeed = mod:RandomFloat(0, 0.2) - (baseFallSpeed or -0.18337345)
        local fallingAccel = baseFallAccel or 0

        if fallingAccel > 0.0 then
            fallingSpeed = fallingSpeed - mod:RandomFloat() * 10.0
        else
            fallingSpeed = (fallingSpeed - mod:RandomFloat() * 15.0) + 5.0
            fallingAccel = fallingAccel + 0.5
        end

        table.insert(out, {
            Pos = pos,
            Vel = Vector(tearVelX, tearVelY),
            ScaleMult = mod:RandomInt(0, 1) * 0.4 + 0.9 + mod:RandomFloat(-1, 1) * 0.05,
            FallingSpeed = fallingSpeed,
            FallingAcceleration = fallingAccel,
        })
    end

    return out
end

function mod:GetPlayerMonstroBurstInfo(player, pos, vel, num, ignoreShotSpeed)
    if not ignoreShotSpeed then
        vel = vel * player.ShotSpeed
    end
    return mod:GetMonstroBurstInfo(pos, vel, num, player.TearFallingSpeed, player.TearFallingAcceleration)
end

-- "damage" is a multiplier for the player, used directly otherwise.
function mod:FireMonstroBurst(source, burstPos, burstVel, numTears, damage, variant, playBurstSound)
    local tears = {}

    local player = source and source:ToPlayer()
    local familiar = source and source:ToFamiliar()

    for _, tearInfo in ipairs(player and mod:GetPlayerMonstroBurstInfo(player, burstPos, burstVel, numTears) or mod:GetMonstroBurstInfo(burstPos, burstVel, numTears)) do
        local tear
        if player then
            tear = player:FireTear(tearInfo.Pos, tearInfo.Vel, true, false, true, player, damage)
        elseif familiar then
            tear = familiar:FireProjectile(tearInfo.Vel)
            tear.Position = tearInfo.Pos
            tear.Velocity = tearInfo.Vel
            tear.CollisionDamage = damage
            if variant and variant > 0 then
                tear:ChangeVariant(variant)
            end
        else
            tear = Isaac.Spawn(EntityType.ENTITY_TEAR, variant or 0, 0, tearInfo.Pos, tearInfo.Vel, source):ToTear()
            tear.CollisionDamage = damage
        end
        tear.FallingAcceleration = tearInfo.FallingAcceleration
        tear.FallingSpeed = tear.FallingSpeed + tearInfo.FallingSpeed
        tear.Scale = math.max(tear.Scale * tearInfo.ScaleMult, 0.01)
        tear:ResetSpriteScale()
        table.insert(tears, tear)
    end

    if playBurstSound ~= false then
        sfx:Play(891, 0.8, 0, false, mod:RandomFloat(1.3, 1.5))
    end

    return tears
end

function mod:GetMonstroBombBurstInfo(pos, baseVel, num)
    local out = {}

    for i = 1, (num or 5) do
        local a = mod:RandomFloat(-1, 1)
        local b = mod:RandomFloat(-1, 1) * math.pi * 2
        local velX = math.cos(b) * a * 3.5 + baseVel.X
        local velY = math.sin(b) * a * 3.5 + baseVel.Y
        local vel = Vector(velX, velY) * mod:RandomFloat(0.4, 1.0)

        table.insert(out, {
            Pos = pos,
            Vel = vel,
            ScaleMult = mod:RandomFloat(0.15) + mod:RandomInt(1) * 0.2 + 0.4,
            FallSpeed = -1 - mod:RandomFloat(8),
            FallAcceleration = 0.8,
            Height = mod:RandomInt(-4, -8),
            ExplosionCountdown = mod:RandomInt(15, 30)
        })
    end

    return out
end

function mod:FireMonstroBombBurst(source, burstPos, burstVel, numBombs)
    local bombs = {}

    local player = source and source:ToPlayer()

    for _, bombInfo in ipairs(mod:GetMonstroBombBurstInfo(burstPos, burstVel, numBombs)) do
        local bomb
        if player then
            bomb = player:FireBomb(bombInfo.Pos, bombInfo.Vel, player)
        else
            bomb = Isaac.Spawn(EntityType.ENTITY_BOMB, 0, 0, bombInfo.Pos, bombInfo.Vel, source):ToBomb()
            bomb.IsFetus = true
            bomb:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
            bomb.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
        end
        bomb.PositionOffset.Y = bombInfo.Height
        bomb:SetFallSpeed(bombInfo.FallSpeed)
        bomb:SetFallAcceleration(bombInfo.FallAcceleration)
        bomb:SetExplosionCountdown(bombInfo.ExplosionCountdown)
        bomb.RadiusMultiplier = bomb.RadiusMultiplier * bombInfo.ScaleMult
        bomb:SetScale(bomb:GetScale() * bombInfo.ScaleMult)
        bomb:SetLoadCostumes(true)
        table.insert(bombs, bomb)
    end

    return bombs
end

-- Temporary, some laser functions aren't in release rgon yet
local rgonUpdated = getmetatable(EntityLaser).__class.SetInitSound ~= nil

function mod:GetMonstroLaserBurstInfo(pos, baseDir, num)
    local out = {}
    baseDir = baseDir:Normalized()

    for i = 1, (num or 6) do
        local a = 50 * mod:RandomFloat()
        local b = 2 * mod:RandomFloat() * math.pi

        local x = math.cos(b) * a + baseDir.X * 70
        local y = math.sin(b) * a + baseDir.Y * 70

        local chainSegmentDistance = math.sqrt(x * x + y * y)

        if chainSegmentDistance > 0 then
            x = x * (1/chainSegmentDistance)
            y = y * (1/chainSegmentDistance)
        end

        local laserPos = pos + baseDir * 10
        local laserDir = Vector(x,y):Normalized()

        table.insert(out, {
            Pos = laserPos,
            Dir = laserDir,
            ScaleMult = mod:RandomInt(1) * 0.4 + 0.9 + mod:RandomFloat(0.05),
            ChainSegmentDistance = chainSegmentDistance,
            NumChainedLasers = mod:RandomInt(3, 4),
            RgonUpdated = rgonUpdated,
        })
    end

    return out
end

-- "damage" is a multiplier for the player, used directly otherwise.
function mod:FireMonstroLaserBurst(source, burstPos, burstDir, numLasers, damage, posOffset, playBurstSound)
    if playBurstSound == nil then
        playBurstSound = numLasers and (numLasers > 5) or true
    end
    posOffset = posOffset or Vector(0, -20)

    local lasers = {}

    local player = source and source:ToPlayer()
    local familiar = source and source:ToFamiliar()
    local canDoFancyStuff = rgonUpdated and ((player ~= nil) or (familiar ~= nil and familiar.Player ~= nil))

    for _, laserInfo in ipairs(mod:GetMonstroLaserBurstInfo(burstPos, burstDir, numLasers)) do
        local laser
        if player then
            laser = player:FireTechLaser(laserInfo.Pos, LaserOffset.LASER_TRACTOR_BEAM_OFFSET, laserInfo.Dir, false, true, player, damage or 1)
        else
            laser = EntityLaser.ShootAngle(LaserVariant.THIN_RED, laserInfo.Pos, laserInfo.Dir:GetAngleDegrees(), 1, posOffset, source)
            if damage then
                laser.CollisionDamage = damage
            end
            if familiar and canDoFancyStuff then
                laser.Parent = familiar.Player
            end
        end

        laser.DisableFollowParent = true
        laser.Position = laserInfo.Pos
        laser.ParentOffset = mod.nilvector
        laser.PositionOffset = posOffset

        laser:SetScale(laser:GetScale() * laserInfo.ScaleMult)
        laser:ResetSpriteScale()

        if canDoFancyStuff then
            laser.MaxDistance = laserInfo.ChainSegmentDistance
            laser:SetNumChainedLasers(laserInfo.NumChainedLasers)
            if playBurstSound then
                laser:SetInitSound(SoundEffect.SOUND_NULL)
            end
        end

        table.insert(lasers, laser)
    end

    if playBurstSound then
        sfx:Play(SoundEffect.SOUND_REDLIGHTNING_ZAP_BURST)
    end

    return lasers
end

-- Merge all given arrays into one
function mod:MergeArrays(...)
    local tabs = table.pack(...)
    local result = {}
    for _, tab in ipairs(tabs) do
        for i, v in ipairs(tab) do
            table.insert(result, v)
        end
    end

    return result
end

-- If any player has immunity from NORMAL (not Black Lantern) curses.
-- Black Candle, Black Candelabra, Black Lantern
function FiendFolio:HasCurseImmunity()
    local immunityItems = {
        CollectibleType.COLLECTIBLE_BLACK_CANDLE,
        mod.ITEM.COLLECTIBLE.BLACK_LANTERN,
        mod.ITEM.COLLECTIBLE.BLACK_CANDELABRA,
    }

    for _, item in ipairs(immunityItems) do
        if PlayerManager.AnyoneHasCollectible(item) then
            return true
        end
    end

    return false
end

function FiendFolio:IsBeastFight(level, room)
    level = level or game:GetLevel()
    room = room or game:GetRoom()
    local stageNum = level:GetStage()
	local rtype = room:GetType()
	return (stageNum == LevelStage.STAGE8 and rtype == RoomType.ROOM_DUNGEON)
end