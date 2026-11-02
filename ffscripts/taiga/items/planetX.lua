-- Planet X --

-- Ball 20

-- TODO: remaining synergies, callbacks

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local quantumflag = TearFlagsLib.RegisterTearFlag("QUANTUM_PLANET_X")

TearFlagsLib.RegisterWeapon("FF_PLANET_X")
TearFlagsLib.RegisterWeaponIdentityFunction(TearFlagsLib.WeaponFlag.FF_PLANET_X, function(entity)
    return (
        entity.Type == EntityType.ENTITY_FAMILIAR and
        entity.Variant == mod.ITEM.FAMILIAR.PLANET_X
    )
end)

mod.PARANOIA.RATE_LIMITED = mod.PARANOIA.RATE_LIMITED | TearFlagsLib.WeaponFlag.FF_PLANET_X
mod.GAY_GARNET.DO_APPLY_EFFECTS = mod.GAY_GARNET.DO_APPLY_EFFECTS | TearFlagsLib.WeaponFlag.FF_PLANET_X
mod.CHEMICAL_COOKIE.PER_ENTITY_COOLDOWN = mod.CHEMICAL_COOKIE.PER_ENTITY_COOLDOWN | TearFlagsLib.WeaponFlag.FF_PLANET_X

local PlanetXSubtype = {
	BASE = 0,
	EXTRA = 1,
	MULTISHOT = 2,
}

-- damage: familiar collision damage
-- tears: familiar refresh rate, collision interval, and damage if collision interval drops below the minimum (todo)
-- range: familiar orbit radius
-- shot speed: familiar orbit velocity

local damageFactor = 1.5 -- how much player damage converts to collision damage
local refreshRateFactor = 2 -- how much player max fire delay converts to frames til familiar rerolls tear effects
local minRefreshRate = 4 -- minimum frames til familiar rerolls tear effects
local collisionIntervalFactor = 1 -- how much player max fire delay converts to collision interval
local minCollisionInterval = 2 -- minimum collision interval
local rangeScaler = 170 -- the higher this value, the more aggressively range converts to radius above default range (6.5)
local baseRadius = 25 -- how much radius planet x orbits at minimum range (1)
local extraRadius = 75 -- how much extra radius planet x orbits at default range (6.5)
local extraRadiusContinuum = 160 -- how much extra radius planet x orbits at default range (6.5) under the continuum effect
local rangeLerp = 0.05 -- how quickly range updates
local extraRadiusLerp = 0.05 -- how quickly extra radius updates
local fearRange = 40 -- range stat forced to when feared
local fearRangeLerp = 0.2 -- how quickly range updates when feared
local fearExtraRadiusLerp = 0.2 -- how quickly extra radius updates when feared
local baseShotSpeedFactor = 0.25 -- how much player shot speed converts to orbit velocity
local shotSpeedLerp = 0.05 -- how quickly shotspeed updates
local extraOrbitalsCap = 7 -- how many extra orbitals there can be (to avoid the familiar cap)
local multishotCap = 4 -- how many multishot orbitals there can be (to avoid the familiar cap)
local scaleFactor = 1.5 -- how much bigger is the familiar compared to player tear scale
local smoothingToOrbitVelMult = 1.33 -- how much orbit velocity is multiplied when moving back to orbit
local aimAngleDesyncThreshold = 10 -- how much the aiming angle has to change before orbit resyncing triggers
local trinitySnapSteps = 100 -- how many steps resyncing checks for the trinity angle
local tinyPlanetRadiusMult = 0.4 -- how much radius is multiplied at max for tiny planet
local tinyPlanetLerp = 0.1 -- how quickly radius changes for tiny planet
local soyMilkExtraTears = 7 -- how many extra tears soy milk adds to the orbit
local boomerangMinRadius = 0.4 -- how much of a radius multiplier is applied at the boomerang minimum
local boomerangTimes = 8 -- how many times should boomerang happen in a full rotation
local boomerangLerpIn = 0.05 -- how quickly boomerang effect toggles on
local boomerangLerpOut = 0.05 -- how quickly boomerang effect toggles off
local whiskeyAngleRateMultMin = -0.3 -- minimum angle rate multiplier for whiskey
local whiskeyAngleRateMultMax = 1.4 -- maximum angle rate multiplier for whiskey
local whiskeyAngleRateMultAccel = 0.02 -- how quickly the angle rate multiplier for whiskey can accelerate
local whiskeyAngleRateMultChangeLimit = 0.2 -- how quickly the angle rate muliplier can move in either direction
local whiskeyAngleRateDirectionFrames = 5 -- how many frames before the angle rate multiplier for whiskey can flip what direction it's accelerating in
local whiskeyRadiusMultMin = 0.85 -- minimum radius multiplier for whiskey
local whiskeyRadiusMultMax = 1.15 -- maximum radius multiplier for whiskey
local whiskeyRadiusMultAccel = 0.004 -- how quickly the radius multiplier for whiskey can accelerate
local whiskeyRadiusMultChangeLimit = 0.02 -- how quickly the radius muliplier can move in either direction
local whiskeyRadiusMultDirectionFrames = 8 -- how many frames before the radius multiplier for whiskey can flip what direction it's accelerating in
local whiskeyLerpIn = 0.05 -- how quickly whiskey effect toggles on
local whiskeyLerpOut = 0.05 -- how quickly whiskey effect toggles off
local wiggleFrameMult = 0.5 -- multiplier for the rate at which the wiggle effect occurs
local wiggleAmplitude = 12 -- distance of the wiggle sinwave
local wiggleMaxAtVel = 2.5 -- wiggle effect maxs out at this velocity
local wiggleLerpIn = 0.05 -- how quickly wiggle effect toggles on
local wiggleLerpOut = 0.05 -- how quickly wiggle effect toggles off
local maxWNICPrevious = 133 -- how many frames wnic tracks movement for
local wnicFrameSkip = 3 -- how many frames are between steps of movement for wnic tears spawned by the planet
local spiralAngleRate = 15 -- how quickly the spiral effect spins around
local spiralRadius = 28.5 -- radius of the spiral effect
local spiralLerpIn = 0.05 -- how quickly spiral effect toggles on
local spiralLerpOut = 0.05 -- how quickly spiral effect toggles off
local bigSpiralAngleRate = 10 -- how quickly the big spiral effect spins around
local bigSpiralRadius = 100 -- radius of the big spiral effect
local bigSpiralLerpIn = 0.05 -- how quickly big spiral effect toggles on
local bigSpiralLerpOut = 0.05 -- how quickly big spiral effect toggles off
local homingRadius = 80 -- radius enemies are checked for within for homing and how far before homing breaks off from enemies
local homingMaxDistance = 0.85 -- percentage between intended orbit position and homing orbit position
local homingMaxRate = 0.2 -- maximum value for lerp speed at which familiar homes onto enemy
local homingOrbitVelToRate = 0.02 -- multiplier for orbit velocity to homing lerp speed
local yinYangHomingMult = 2 -- multiplier to homing lerp speed when yin-yang effect
local multishotLerpIn = 0.2 -- how quickly multishot effect toggles on
local multishotLerpOut = 0.05 -- how quickly multishot effect toggles on
local multishotAngleMult = 1.05 -- multiplier to base angle rate used for multishot angle updating
local multishotAngleOffsetLerp = 0.05 -- how quickly multishot angle offset changes when multishot num updates
local multishotRadiusMult = 2.5 -- how much familiar size converts to multishot orbit radius
local maxStrangeAttractorForce = 8 -- maximum force of pull of strange attractor effect
local maxStrangeAttractorForceAt = 100 -- distance away from the player at which strange attractor effect reaches max force (40 units per grid)
local darknessSpeedMult = 0.1 -- multiplier to shot speed applied when darkness is active
local darknessSpeedLerp = 0.7333 -- how quickly darkness slowdown applies
local darknessColourLerp = 0.4 -- how quickly darkness colour applies
local godheadHaloDamage = 0.4 -- how much damage the godhead halo deals per rate
local godheadDamageRate = 2 -- applies godhead halo damage every x frames
local pulseLerpIn = 0.05 -- how quickly pulse effect toggles on
local pulseLerpOut = 0.05 -- how quickly pulse effect toggles off
local modelRocketLerpIn = 0.05 -- how quickly model rocket effect toggles on
local modelRocketLerpOut = 0.05 -- how quickly model rocket effect toggles off
local modelRocketLerp = 0.9 -- how much the orbit origin point is lerped by under the model rocket effect
local palinopsiaTimeout = 15 -- how long the palinopsia trail lasts for

local tanOffsets = {
	Vector(math.tan((math.pi/64)*1) * 25, 0),
	Vector(math.tan((math.pi/64)*2) * 25, 0),
	Vector(math.tan((math.pi/64)*3) * 25, 0),
	Vector(math.tan((math.pi/64)*4) * 25, 0),
	Vector(math.tan((math.pi/64)*5) * 25, 0),
	Vector(math.tan((math.pi/64)*6) * 25, 0),
	Vector(math.tan((math.pi/64)*7) * 25, 0),
	Vector(math.tan((math.pi/64)*8) * 25, 0),
	Vector(math.tan((math.pi/64)*9) * 25, 0),
	Vector(math.tan((math.pi/64)*10) * 25, 0),
	Vector(math.tan((math.pi/64)*11) * 25, 0),
	Vector(math.tan((math.pi/64)*12) * 25, 0),
	Vector(math.tan((math.pi/64)*13) * 25, 0),
	Vector(math.tan((math.pi/64)*14) * 25, 0),
	Vector(math.tan((math.pi/64)*15) * 25, 0),
	Vector(math.tan((math.pi/64)*16) * 25, 0),
	Vector(math.tan((math.pi/64)*17) * 25, 0),
	Vector(math.tan((math.pi/64)*18) * 25, 0),
	Vector(math.tan((math.pi/64)*19) * 25, 0),
	Vector(math.tan((math.pi/64)*20) * 25, 0),
	Vector(math.tan((math.pi/64)*21) * 25, 0),
	Vector(math.tan((math.pi/64)*22) * 25, 0),
	Vector(math.tan((math.pi/64)*23) * 25, 0),
	Vector(math.tan((math.pi/64)*24) * 25, 0),
	Vector(math.tan((math.pi/64)*25) * 25, 0),
	Vector(math.tan((math.pi/64)*26) * 25, 0),
	Vector(math.tan((math.pi/64)*27) * 25, 0),
	Vector(math.tan((math.pi/64)*28) * 25, 0),
	Vector(math.tan((math.pi/64)*29) * 25, 0),
	Vector(math.tan((math.pi/64)*30) * 25, 0),
	Vector(math.tan((math.pi/64)*31) * 25, 0),
	math.huge,
	-1 * math.huge,
	Vector(math.tan((math.pi/64)*33) * 25, 0),
	Vector(math.tan((math.pi/64)*34) * 25, 0),
	Vector(math.tan((math.pi/64)*35) * 25, 0),
	Vector(math.tan((math.pi/64)*36) * 25, 0),
	Vector(math.tan((math.pi/64)*37) * 25, 0),
	Vector(math.tan((math.pi/64)*38) * 25, 0),
	Vector(math.tan((math.pi/64)*39) * 25, 0),
	Vector(math.tan((math.pi/64)*40) * 25, 0),
	Vector(math.tan((math.pi/64)*41) * 25, 0),
	Vector(math.tan((math.pi/64)*42) * 25, 0),
	Vector(math.tan((math.pi/64)*43) * 25, 0),
	Vector(math.tan((math.pi/64)*44) * 25, 0),
	Vector(math.tan((math.pi/64)*45) * 25, 0),
	Vector(math.tan((math.pi/64)*46) * 25, 0),
	Vector(math.tan((math.pi/64)*47) * 25, 0),
	Vector(math.tan((math.pi/64)*48) * 25, 0),
	Vector(math.tan((math.pi/64)*49) * 25, 0),
	Vector(math.tan((math.pi/64)*50) * 25, 0),
	Vector(math.tan((math.pi/64)*51) * 25, 0),
	Vector(math.tan((math.pi/64)*52) * 25, 0),
	Vector(math.tan((math.pi/64)*53) * 25, 0),
	Vector(math.tan((math.pi/64)*54) * 25, 0),
	Vector(math.tan((math.pi/64)*55) * 25, 0),
	Vector(math.tan((math.pi/64)*56) * 25, 0),
	Vector(math.tan((math.pi/64)*57) * 25, 0),
	Vector(math.tan((math.pi/64)*58) * 25, 0),
	Vector(math.tan((math.pi/64)*59) * 25, 0),
	Vector(math.tan((math.pi/64)*60) * 25, 0),
	Vector(math.tan((math.pi/64)*61) * 25, 0),
	Vector(math.tan((math.pi/64)*62) * 25, 0),
	Vector(math.tan((math.pi/64)*63) * 25, 0),
	Vector(0, 0),
}

local hydrobounceHeights = {
	-23.75 * math.abs(math.cos(math.pi / 32 * 1)),
	-23.75 * math.abs(math.cos(math.pi / 32 * 2)),
	-23.75 * math.abs(math.cos(math.pi / 32 * 3)),
	-23.75 * math.abs(math.cos(math.pi / 32 * 4)),
	-23.75 * math.abs(math.cos(math.pi / 32 * 5)),
	-23.75 * math.abs(math.cos(math.pi / 32 * 6)),
	-23.75 * math.abs(math.cos(math.pi / 32 * 7)),
	-23.75 * math.abs(math.cos(math.pi / 32 * 8)),
	-23.75 * math.abs(math.cos(math.pi / 32 * 9)),
	-23.75 * math.abs(math.cos(math.pi / 32 * 10)),
	-23.75 * math.abs(math.cos(math.pi / 32 * 11)),
	-23.75 * math.abs(math.cos(math.pi / 32 * 12)),
	-23.75 * math.abs(math.cos(math.pi / 32 * 13)),
	-23.75 * math.abs(math.cos(math.pi / 32 * 14)),
	-23.75 * math.abs(math.cos(math.pi / 32 * 15)),
	0,
	-23.75 * math.abs(math.cos(math.pi / 32 * 17)),
	-23.75 * math.abs(math.cos(math.pi / 32 * 18)),
	-23.75 * math.abs(math.cos(math.pi / 32 * 19)),
	-23.75 * math.abs(math.cos(math.pi / 32 * 20)),
	-23.75 * math.abs(math.cos(math.pi / 32 * 21)),
	-23.75 * math.abs(math.cos(math.pi / 32 * 22)),
	-23.75 * math.abs(math.cos(math.pi / 32 * 23)),
	-23.75 * math.abs(math.cos(math.pi / 32 * 24)),
	-23.75 * math.abs(math.cos(math.pi / 32 * 25)),
	-23.75 * math.abs(math.cos(math.pi / 32 * 26)),
	-23.75 * math.abs(math.cos(math.pi / 32 * 27)),
	-23.75 * math.abs(math.cos(math.pi / 32 * 28)),
	-23.75 * math.abs(math.cos(math.pi / 32 * 29)),
	-23.75 * math.abs(math.cos(math.pi / 32 * 30)),
	-23.75 * math.abs(math.cos(math.pi / 32 * 31)),
	-23.75,
}

-- basegame tearflag effects that should only proc once per roll of planet x tearflag effects
local oncePerRollBasegameFlags = TearFlags.TEAR_MULLIGAN | TearFlags.TEAR_MYSTERIOUS_LIQUID_CREEP | TearFlags.TEAR_LIGHT_FROM_HEAVEN | 
                                 TearFlags.TEAR_EGG | TearFlags.TEAR_RIFT | TearFlags.TEAR_MOM_STOMP_WISP

-- basegame tearflag effects that should only proc once per roll for each enemy hit
local oncePerEnemyBasegameFlags = TearFlags.TEAR_NEEDLE | TearFlags.TEAR_HORN | TearFlags.TEAR_REROLL_ENEMY

-- basegame tearflag effects that go on fire-delay-based cooldown after proccing
local oncePerRefreshBasegameFlags = {TearFlags.TEAR_SPLIT, TearFlags.TEAR_QUADSPLIT, TearFlags.TEAR_BONE, TearFlags.TEAR_BURSTSPLIT}

-- basegame tearflag effects that should only proc once per frame
local oncePerFrameBasegameFlags = TearFlags.TEAR_EXPLOSIVE

-- todo (this is a mix of stuff that needs to be ported to tearflagslib still, and stuff that needs specific synergies):

--	needs to proc once per frame/enemy/roll:
-- 		mern lvl 2, devils umbrella, nugget bladder, nugget blood, moji sick, moji gift, mtn dew, cerberus

-- 	apply effects:
--		nugget faberge, ipad, pgo wisp, ambassador, webby geode

--	splitting effects:
--		absorb, cetus

-- 	movement effects:
--		bounce, tractor, pop, occult, orbit advanced, baby crater, moji sunglasses, moji bug, 
--		flip phone, hydrokinesis, black bullet, ganymede, air freshener, cacepi, shroomite, fractal

--	multishot effects:
--		angelic lyre

-- 	other:
-- 		flat, laser, antisaac, moji joy, moji gun, pupula, range multipliers, sewn api

local dirToAng = {
	[Direction.NO_DIRECTION] = 270,
	[Direction.LEFT] = 180,
	[Direction.UP] = 270,
	[Direction.RIGHT] = 0,
	[Direction.DOWN] = 90
}

local function lerp(i, j, percent)
    return i * (1 - percent) + j * percent
end

local function lerpColor(colorA, colorB, percent)
	local r = colorA.R * (1-percent) + colorB.R * percent
	local g = colorA.G * (1-percent) + colorB.G * percent
	local b = colorA.B * (1-percent) + colorB.B * percent
	local a = colorA.A * (1-percent) + colorB.A * percent
	local ro = colorA.RO * (1-percent) + colorB.RO * percent
	local go = colorA.GO * (1-percent) + colorB.GO * percent
	local bo = colorA.BO * (1-percent) + colorB.BO * percent

	local colorizeA = colorA:GetColorize()
	local colorizeB = colorB:GetColorize()
	local rc = colorizeA.R * (1-percent) + colorizeB.R * percent
	local gc = colorizeA.G * (1-percent) + colorizeB.G * percent
	local bc = colorizeA.B * (1-percent) + colorizeB.B * percent
	local ac = colorizeA.A * (1-percent) + colorizeB.A * percent

	return Color(r,g,b,a,ro,go,bo,rc,gc,bc,ac)
end

-- helper functions for trinity worm
local function trinityScale(v)
	if v > 0.5 then
		return (math.sqrt(v * 2 - 1) + 1) / 2
	else
		return 1 - (math.sqrt((1 - v) * 2 - 1) + 1) / 2
	end
end

local function trinityFactorLow(a, v)
	return trinityScale(math.max(0, 1 - math.abs((a - (((a > 540) and 1080) or 0) - v) / -180)))
end

local function trinityFactor(a, v)
	return trinityScale(math.max(0, 1 - math.abs((a - v) / -180)))
end

local function trinityFactorHigh(a, v)
	return trinityScale(math.max(0, 1 - math.abs((a + (((a < 540) and 1080) or 0) - v) / -180)))
end

local function updateAiming(fam, player, fdata, hasTinyPlanetFlag, hasTrinityWormFlag, fireDirection)
	if hasTinyPlanetFlag or hasTrinityWormFlag then
		-- get aim angle
		fdata.AimAngle = fdata.AimAngle or 270
		fdata.LastShootingAngle = fdata.LastShootingAngle or fdata.AimAngle
		if fireDirection ~= Direction.NO_DIRECTION then
			if hasTinyPlanetFlag or player:HasCollectible(CollectibleType.COLLECTIBLE_ANALOG_STICK) then
				fdata.AimAngle = player:GetShootingJoystick():GetAngleDegrees() % 360
			else
				fdata.AimAngle = dirToAng[fireDirection]
			end
		end

		-- check if change is large enough to justify a resync
		local shootDiffA = math.abs(fdata.LastShootingAngle - fdata.AimAngle)
		local shootDiffB = math.abs((fdata.LastShootingAngle + 360) - fdata.AimAngle)
		local shootDiffC = math.abs(fdata.LastShootingAngle - (fdata.AimAngle + 360))
		local shootDiff
		if shootDiffA < shootDiffB and shootDiffA < shootDiffC then
			shootDiff = shootDiffA
		elseif shootDiffB < shootDiffC then
			shootDiff = shootDiffB
		else
			shootDiff = shootDiffC
		end
		if math.abs(shootDiff) > aimAngleDesyncThreshold then
			fdata.ResyncToOrbit = fam.SubType == PlanetXSubtype.BASE
			fdata.SmoothingToOrbit = true
		end
	else
		-- set default aim angle
		fdata.AimAngle = fdata.AimAngle or 270
	end

	fdata.LastShootingAngle = fdata.AimAngle
end

local function updateWhiskey(fdata, hasWhiskeyFlag)
	fdata.WhiskeyMultLerp = fdata.WhiskeyMultLerp or ((not fdata.Initialized and hasWhiskeyFlag and 1) or 0)
	if hasWhiskeyFlag then
		fdata.WhiskeyMultLerp = lerp(fdata.WhiskeyMultLerp, 1, whiskeyLerpIn)
	else
		fdata.WhiskeyMultLerp = lerp(fdata.WhiskeyMultLerp, 0, whiskeyLerpOut)
	end

	fdata.WhiskeyRadiusMult = fdata.WhiskeyRadiusMult or 1
	fdata.whiskeyRadiusMultAccel = fdata.whiskeyRadiusMultAccel or 0
	fdata.WhiskeyRadiusMultChangeDirection = fdata.WhiskeyRadiusMultChangeDirection or 1
	fdata.WhiskeyRadiusMultCountdown = math.max(0, (fdata.WhiskeyRadiusMultCountdown or 0) - 1)
	if fdata.WhiskeyRadiusMult >= whiskeyRadiusMultMax then
		fdata.WhiskeyRadiusMultChangeDirection = -1
		fdata.WhiskeyRadiusMultCountdown = whiskeyRadiusMultDirectionFrames
	elseif fdata.WhiskeyRadiusMult <= whiskeyRadiusMultMin then
		fdata.WhiskeyRadiusMultChangeDirection = 1
		fdata.WhiskeyRadiusMultCountdown = whiskeyRadiusMultDirectionFrames
	elseif fdata.WhiskeyRadiusMultCountdown == 0 then
		fdata.WhiskeyRadiusMultChangeDirection = (math.random(2) == 1 and -1) or 1
		fdata.WhiskeyRadiusMultCountdown = whiskeyRadiusMultDirectionFrames
	end
	fdata.whiskeyRadiusMultAccel = fdata.whiskeyRadiusMultAccel + whiskeyRadiusMultAccel * fdata.WhiskeyRadiusMultChangeDirection
	fdata.whiskeyRadiusMultAccel = math.max(-1 * whiskeyRadiusMultChangeLimit, math.min(fdata.whiskeyRadiusMultAccel, whiskeyRadiusMultChangeLimit))
	fdata.WhiskeyRadiusMult = fdata.WhiskeyRadiusMult + fdata.whiskeyRadiusMultAccel
	fdata.Radius = fdata.Radius * lerp(1, fdata.WhiskeyRadiusMult, fdata.WhiskeyMultLerp)

	fdata.WhiskeyAngleRateMult = fdata.WhiskeyAngleRateMult or 1
	fdata.whiskeyAngleRateMultAccel = fdata.whiskeyAngleRateMultAccel or 0
	fdata.WhiskeyAngleRateChangeDirection = fdata.WhiskeyAngleRateChangeDirection or 1
	fdata.WhiskeyAngleRateCountdown = math.max(0, (fdata.WhiskeyAngleRateCountdown or 0) - 1)
	if fdata.WhiskeyAngleRateMult >= whiskeyAngleRateMultMax then
		fdata.WhiskeyAngleRateChangeDirection = -1
		fdata.WhiskeyAngleRateCountdown = whiskeyAngleRateDirectionFrames
	elseif fdata.WhiskeyAngleRateMult <= whiskeyAngleRateMultMin then
		fdata.WhiskeyAngleRateChangeDirection = 1
		fdata.WhiskeyAngleRateCountdown = whiskeyAngleRateDirectionFrames
	elseif fdata.WhiskeyAngleRateCountdown == 0 then
		fdata.WhiskeyAngleRateChangeDirection = (math.random(2) == 1 and -1) or 1
		fdata.WhiskeyAngleRateCountdown = whiskeyAngleRateDirectionFrames
	end
	fdata.whiskeyAngleRateMultAccel = fdata.whiskeyAngleRateMultAccel + whiskeyAngleRateMultAccel * fdata.WhiskeyAngleRateChangeDirection
	fdata.whiskeyAngleRateMultAccel = math.max(-1 * whiskeyAngleRateMultChangeLimit, math.min(fdata.whiskeyAngleRateMultAccel, whiskeyAngleRateMultChangeLimit))
	fdata.WhiskeyAngleRateMult = fdata.WhiskeyAngleRateMult + fdata.whiskeyAngleRateMultAccel
	fdata.AngleRate = fdata.AngleRate * lerp(1, fdata.WhiskeyAngleRateMult, fdata.WhiskeyMultLerp)
end

local function getSquareTrinityPos(trinityAngle, aimAngle, radius)
	local angle = trinityAngle % 180 - 90
	local pos
	if -90 <= angle and angle < -30 then
		pos = Vector(radius - (radius * (math.abs(angle) - 30) / 45) * 1.038675, radius * 30 / 45)
	elseif -30 <= angle and angle < 30 then
		pos = Vector(radius, -1 * radius * angle / 45)
	else
		pos = Vector(radius - (radius * (math.abs(angle) - 30) / 45) * 1.038675, -1 * radius * 30 / 45)
	end
	
	if math.ceil((trinityAngle % 540) / 180) == 2 then
		pos = pos:Rotated(120)
	elseif math.ceil((trinityAngle % 540) / 180) == 3 then
		pos = pos:Rotated(240)
	end
	
	return pos:Rotated(aimAngle)
end

local function getTrinityPos(trinityAngle, aimAngle, radius)
	-- if trinity, orbit shape is trinity pointed in last shooting direction
	local baseAngle = 360 - (trinityAngle % 360)

	local a = Vector.FromAngle((baseAngle + 330 % 360) + aimAngle) * radius + Vector.FromAngle(60 + aimAngle) * radius * 0.5
	local b = Vector.FromAngle((baseAngle + 270 % 360) + aimAngle) * radius + Vector.FromAngle(180 + aimAngle) * radius * 0.5
	local c = Vector.FromAngle((baseAngle + 210 % 360) + aimAngle) * radius + Vector.FromAngle(300 + aimAngle) * radius * 0.5
	local d = Vector.FromAngle((baseAngle + 150 % 360) + aimAngle) * radius + Vector.FromAngle(60 + aimAngle) * radius * 0.5
	local e = Vector.FromAngle((baseAngle + 90 % 360) + aimAngle) * radius + Vector.FromAngle(180 + aimAngle) * radius * 0.5
	local f = Vector.FromAngle((baseAngle + 30 % 360) + aimAngle) * radius + Vector.FromAngle(300 + aimAngle) * radius * 0.5

	a = a * trinityFactorLow(trinityAngle, 90)
	b = b * trinityFactor(trinityAngle, 270)
	c = c * trinityFactor(trinityAngle, 450)
	d = d * trinityFactor(trinityAngle, 630)
	e = e * trinityFactor(trinityAngle, 810)
	f = f * trinityFactorHigh(trinityAngle, 990)
	return a + b + c + d + e + f
end

local function getSquarePos(angle, radius)
	if 0 <= angle and angle < 45 then
		return Vector(radius, -1 * radius / 45 * angle)
	elseif 45 <= angle and angle < 135 then
		return Vector(radius - radius / 45 * (angle - 45), -1 * radius)
	elseif 135 <= angle and angle < 225 then
		return Vector(-1 * radius, -1 * radius + radius / 45 * (angle - 135))
	elseif 225 <= angle and angle < 315 then
		return Vector(-1 * radius + radius / 45 * (angle - 225), radius)
	else
		return Vector(radius, radius - radius / 45 * (angle - 315))
	end
end

local function getOrbitPos(fam, player, fdata, hasTinyPlanetFlag, fireDirection, hasTrinityWormFlag, hasSquareFlag)
	local orbitPos
	if hasSquareFlag and hasTrinityWormFlag then
		orbitPos = getSquareTrinityPos(fdata.TrinityAngle, fdata.AimAngle, fdata.Radius)
		if fam.SubType == PlanetXSubtype.BASE and fdata.ResyncToOrbit and (orbitPos - (fdata.LastOrbitPos or orbitPos)):Length() > fdata.OrbitVelocity * smoothingToOrbitVelMult then
			-- desynced, need to update trinity angle to closest angle
			local closestAngle
			local closestPos
			local closestDist = math.huge
			for i = 0, trinitySnapSteps-1 do
				local angle = 540 / trinitySnapSteps * i
				local pos = getSquareTrinityPos(angle, fdata.AimAngle, fdata.Radius)
				local dist = (pos - fdata.LastOrbitPos):Length()
				if dist < closestDist then
					closestAngle = angle
					closestPos = pos
					closestDist = dist
				end
			end
			fdata.TrinityAngle = closestAngle
			orbitPos = closestPos
			fdata.ResyncToOrbit = false
		end
	elseif hasTrinityWormFlag then
		orbitPos = getTrinityPos(fdata.TrinityAngle, fdata.AimAngle, fdata.Radius)
		if fam.SubType == PlanetXSubtype.BASE and fdata.ResyncToOrbit and (orbitPos - (fdata.LastOrbitPos or orbitPos)):Length() > fdata.OrbitVelocity * smoothingToOrbitVelMult then
			-- desynced, need to update trinity angle to closest angle
			local closestAngle
			local closestPos
			local closestDist = math.huge
			for i = 0, trinitySnapSteps-1 do
				local angle = 540 / trinitySnapSteps * i
				local pos = getTrinityPos(angle, fdata.AimAngle, fdata.Radius)
				local dist = (pos - fdata.LastOrbitPos):Length()
				if dist < closestDist then
					closestAngle = angle
					closestPos = pos
					closestDist = dist
				end
			end
			fdata.TrinityAngle = closestAngle
			orbitPos = closestPos
			fdata.ResyncToOrbit = false
		end
	elseif hasSquareFlag then
		orbitPos = getSquarePos(fdata.OrbitAngle, fdata.Radius)
		if fam.SubType == PlanetXSubtype.BASE and fdata.ResyncToOrbit and (orbitPos - (fdata.LastOrbitPos or orbitPos)):Length() > fdata.OrbitVelocity * smoothingToOrbitVelMult then
			-- desynced, need to update orbit angle to closest angle
			fdata.OrbitAngle = 360 - (fdata.LastOrbitPos:GetAngleDegrees() % 360)
			orbitPos = getSquarePos(fdata.OrbitAngle, fdata.Radius)
			fdata.ResyncToOrbit = false
		end
	else
		-- else, orbit shape is circle
		orbitPos = Vector.FromAngle(360 - fdata.OrbitAngle) * fdata.Radius
		if fam.SubType == PlanetXSubtype.BASE and fdata.ResyncToOrbit and (orbitPos - (fdata.LastOrbitPos or orbitPos)):Length() > fdata.OrbitVelocity * smoothingToOrbitVelMult then
			-- desynced, need to update orbit angle to closest angle
			fdata.OrbitAngle = 360 - (fdata.LastOrbitPos:GetAngleDegrees() % 360)
			orbitPos = Vector.FromAngle(360 - fdata.OrbitAngle) * fdata.Radius
			fdata.ResyncToOrbit = false
		end
	end

	-- if tiny planet, adjust shape to be shifted outwards in aim direction
	local shouldLerpOut = hasTinyPlanetFlag and (fireDirection ~= Direction.NO_DIRECTION or Isaac.GetChallenge() == mod.challenges.penIsland)
	local lerpTarget = Vector.FromAngle(fdata.AimAngle):Resized(tinyPlanetRadiusMult)
	fdata.TinyPlanetAdjustor = fdata.TinyPlanetAdjustor or ((shouldLerpOut and lerpTarget) or Vector(0,0))
	if shouldLerpOut then
		fdata.TinyPlanetAdjustor:Lerp(lerpTarget, tinyPlanetLerp)
	else
		fdata.TinyPlanetAdjustor:Lerp(Vector(0,0), tinyPlanetLerp)
	end

	local angleFromOrigin = orbitPos:GetAngleDegrees() - fdata.TinyPlanetAdjustor:GetAngleDegrees()
	local distanceFromOrigin = orbitPos:Length()
	local distMult = math.cos(math.rad(angleFromOrigin)) * fdata.TinyPlanetAdjustor:Length() + 1
	orbitPos = orbitPos:Resized(distanceFromOrigin * distMult)

	-- smooth target position if not synchronized to orbit
	if fdata.SmoothingToOrbit then
		local orbitDiff = orbitPos - (fdata.LastOrbitPos or orbitPos)

		local smoothVel = (fdata.OrbitVelocity + math.max(0, lerp(1, fdata.WhiskeyAngleRateMult, fdata.WhiskeyMultLerp) - 1)) * smoothingToOrbitVelMult
		if orbitDiff:Length() > smoothVel then
			orbitPos = fdata.LastOrbitPos + orbitDiff:Resized(smoothVel)
		else
			fdata.SmoothingToOrbit = false
			fdata.ResyncToOrbit = false
			fdata.WhiskeyNeedsToSober = false
		end
	end

	-- update persistent info and return
	fdata.LastOrbitPos = orbitPos
	return orbitPos
end

local function getBoomerangOffset(fam, fdata, hasBoomerangFlag, targetPosRelative, pdata)
	if fam.SubType == PlanetXSubtype.MULTISHOT then
		fdata.BoomerangOffsetMult = pdata.BoomerangOffsetMult
	else
		fdata.BoomerangOffsetMult = fdata.BoomerangOffsetMult or ((not fdata.Initialized and hasBoomerangFlag and 1) or 0)
		if hasBoomerangFlag then
			fdata.BoomerangOffsetMult = lerp(fdata.BoomerangOffsetMult, 1, boomerangLerpIn)
		else
			fdata.BoomerangOffsetMult = lerp(fdata.BoomerangOffsetMult, 0, boomerangLerpOut)
		end
	end

	local angleFromOrigin = targetPosRelative:GetAngleDegrees()
	local boomerangOffset = (math.cos(math.rad(angleFromOrigin) * boomerangTimes) - 1) * (1 - boomerangMinRadius) / 2 * Vector.FromAngle(angleFromOrigin) * targetPosRelative:Length()
	return boomerangOffset * fdata.BoomerangOffsetMult
end

local function isParentInitialized(subt, fdata, pdata)
	if subt == PlanetXSubtype.MULTISHOT and pdata then
		return pdata.Initialized
	else
		return fdata.Initialized
	end
end

local function getMultishotOffset(fam, fdata, targetPosRelative, pdata)
	fdata.MultishotOffsetMult = fdata.MultishotOffsetMult or ((not isParentInitialized(fam.SubType, fdata, pdata) and fdata.NumMultishot > 1 and 1) or 0)
	if fdata.NumMultishot > 1 then
		fdata.MultishotOffsetMult = lerp(fdata.MultishotOffsetMult, 1, multishotLerpIn)
	else
		fdata.MultishotOffsetMult = lerp(fdata.MultishotOffsetMult, 0, multishotLerpOut)
	end

	if fam.SubType == PlanetXSubtype.MULTISHOT then
		fdata.MultishotOffsetAngle = pdata.MultishotOffsetAngle
	else
		fdata.MultishotOffsetAngle = (fdata.MultishotOffsetAngle or 0) + fdata.AngleRate * multishotAngleMult
	end

	fdata.MultishotAnglePercent = lerp(fdata.MultishotAnglePercent or fdata.MultishotOrbitalMult or 0, fdata.MultishotOrbitalMult or 0, multishotAngleOffsetLerp)
	return Vector(fam.Size * multishotRadiusMult,0):Rotated(360 * fdata.MultishotAnglePercent + fdata.MultishotOffsetAngle) * fdata.MultishotOffsetMult
end

local function getContinuumPos(pos)
	local room = game:GetRoom()
	local topLeft = room:GetTopLeftPos()
	local bottomRight = room:GetBottomRightPos()

	local continuumPos = pos
	local parallelUniverse = Vector(0,0)
	while continuumPos.X < topLeft.X - 100 do
		continuumPos = continuumPos + Vector(bottomRight.X - topLeft.X + 200, 0)
		parallelUniverse = parallelUniverse + Vector(-1,0)
	end
	while continuumPos.X > bottomRight.X + 100 do
		continuumPos = continuumPos - Vector(bottomRight.X - topLeft.X + 200, 0)
		parallelUniverse = parallelUniverse + Vector(1,0)
	end

	while continuumPos.Y < topLeft.Y - 100 do
		continuumPos = continuumPos + Vector(0, bottomRight.Y - topLeft.Y + 200)
		parallelUniverse = parallelUniverse + Vector(0,-1)
	end
	while continuumPos.Y > bottomRight.Y + 100 do
		continuumPos = continuumPos - Vector(0, bottomRight.Y - topLeft.Y + 200)
		parallelUniverse = parallelUniverse + Vector(0,1)
	end

	return continuumPos, parallelUniverse
end

local function moveToPos(fam, fdata, targetPosRelative, origin, hasContinuum, tanOffset, isTanResetting, numUniverses)
	local origPos = fam.Position
	
	local quantumUniversePositions = {}
	local quantumUniverseVelocities = {}
	local parallelUniverses = {}
	for i = 0, numUniverses-1 do
		local vel = (fdata.QuantumUniverseVelocities and fdata.QuantumUniverseVelocities[i+1]) or nil
		local pos = (fdata.QuantumUniversePositions and fdata.QuantumUniversePositions[i+1]) or nil
		if pos and vel then
			pos = pos + vel
		end
		local targetPos = targetPosRelative:Rotated(360 / numUniverses * i) + origin

		lastParallelUniverse = (fdata.LastParallelUniverses and fdata.LastParallelUniverses[i+1]) or Vector(0,0)
		if hasContinuum then
			-- if continuum, screen wrap
			local continuumPos, parallelUniverse = getContinuumPos(targetPos)
			continuumPos = continuumPos + tanOffset:Rotated(360 / numUniverses * i)

			if fdata.Initialized and not (fdata.PostNewRoomReset or fdata.PostStickReset) and not isTanResetting and pos ~= nil then
				if parallelUniverse.X ~= lastParallelUniverse.X or parallelUniverse.Y ~= lastParallelUniverse.Y then
					fam.Position = ((fdata.LastTargetPosRelative or targetPosRelative) - targetPosRelative):Rotated(360 / numUniverses * i) + continuumPos
				end
				quantumUniverseVelocities[i+1] = continuumPos - pos
				quantumUniversePositions[i+1] = pos
			else
				quantumUniverseVelocities[i+1] = nilvector
				quantumUniversePositions[i+1] = continuumPos
			end
			parallelUniverses[i+1] = parallelUniverse
		else
			targetPos = targetPos + tanOffset:Rotated(360 / numUniverses * i)
			if fdata.Initialized and not (fdata.PostNewRoomReset or fdata.PostStickReset) and not isTanResetting and pos ~= nil then
				if 0 ~= lastParallelUniverse.X or 0 ~= lastParallelUniverse.Y then
					fam.Position = ((fdata.LastTargetPosRelative or targetPosRelative) - targetPosRelative):Rotated(360 / numUniverses * i) + targetPos
				end
				quantumUniverseVelocities[i+1] = targetPos - pos
				quantumUniversePositions[i+1] = pos
			else
				quantumUniverseVelocities[i+1] = nilvector
				quantumUniversePositions[i+1] = targetPos
			end
			parallelUniverses[i+1] = Vector(0,0)
		end
	end
	
	local frame = game:GetFrameCount()
	fdata.CurrentQuantumUniverse = fdata.ForcedQuantumUniverse or ((frame % numUniverses) + 1)
	fam.Position = quantumUniversePositions[fdata.CurrentQuantumUniverse]
	fam.Velocity = quantumUniverseVelocities[fdata.CurrentQuantumUniverse]

	fdata.WasContinuum = hasContinuum
	fdata.LastNumUniverses = numUniverses
	fdata.QuantumUniversePositions = quantumUniversePositions
	fdata.QuantumUniverseVelocities = quantumUniverseVelocities
	fdata.LastParallelUniverses = parallelUniverses
	fdata.PostNewRoomReset = nil
	fdata.PostStickReset = nil
	
	if fdata.StickTarget then
		local newPos
		if not fdata.StickTargetOffset then
			fdata.StickTargetOffset = origPos - fdata.StickTarget.Position
		end
		newPos = (fdata.StickTarget.Position + fdata.StickTarget.Velocity) + fdata.StickTargetOffset
		
		fam.Position = origPos
		fam.Velocity = newPos - origPos
	end
end

local function updateMovement(fam, player, fdata, pdata, vanillaFlags)
	-- this is so bloody complicated but i want the extra control
	-- i could probably jerryrig basegame's orbital system but eh
	-- so here we are, new system, let's go

	-- player position: base orbit origin
	local origin = player.Position

	-- initialize angle
	fdata.OrbitAngle = fdata.OrbitAngle or 0
	fdata.TrinityAngle = fdata.TrinityAngle or 0

	-- initialize hook worm tracker
	local hasSquareFlag = vanillaFlags & TearFlags.TEAR_SQUARE == TearFlags.TEAR_SQUARE
	if fdata.WasSquareFlag == nil then
		fdata.WasSquareFlag = hasSquareFlag
	end

	-- initialize trinity worm tracker
	local hasTrinityWormFlag = TearFlagsLib.HasTearFlags(fam, TearFlagsLib.Flag.TRINITY)
	if fdata.WasTrinityWormFlag == nil then
		fdata.WasTrinityWormFlag = hasTrinityWormFlag
	end

	-- update stick target
	if fdata.StickTarget and 
	   not (fdata.StickTimeout > 0 and fdata.StickTarget:Exists() and not (mod:isFriend(fdata.StickTarget) or fdata.StickTarget:HasEntityFlags(EntityFlag.FLAG_NO_TARGET)))
	then
		fdata.StickTarget = nil
		fdata.StickTargetOffset = nil
		fdata.StickTimeout = 0
		if not (fdata.Explosivo or fdata.Mucormycosis) then
			fdata.ResyncToOrbit = fam.SubType == PlanetXSubtype.BASE
			fdata.SmoothingToOrbit = true
			fdata.PostStickReset = true
			fdata.LastOrbitPos = fam.Position - origin
		end
	end

	-- update player aiming direction
	local hasTinyPlanetFlag = vanillaFlags & TearFlags.TEAR_ORBIT == TearFlags.TEAR_ORBIT
	fdata.LastFireDirection = fdata.LastFireDirection or Direction.NO_DIRECTION
	local fireDirection = player:GetFireDirection()
	updateAiming(fam, player, fdata, hasTinyPlanetFlag, hasTrinityWormFlag, fireDirection)

	local hasContinuum = vanillaFlags & TearFlags.TEAR_CONTINUUM == TearFlags.TEAR_CONTINUUM
	local numUniverses = (TearFlagsLib.HasTearFlags(fam, quantumflag) and TearFlagsLib.GetTearFlagParams(fam, quantumflag).num) or 1
	if fdata.Initialized then
		if player:HasTrinket(TrinketType.TRINKET_DUCT_TAPE) or
		   (vanillaFlags & TearFlags.TEAR_WAIT == TearFlags.TEAR_WAIT and
		    fireDirection ~= Direction.NO_DIRECTION and
		    fdata.LastTargetPosRelative ~= nil)
		then
			-- if wait or duct tape, pause all movement if firing
			fdata.TanFrame = fdata.TanFrame or 0
			tanOffset = tanOffsets[fdata.TanFrame + 1]
			
			-- update origin with last offset
			origin = origin + (fdata.LastOriginOffset or nilvector)
			fdata.LastOrigin = origin
			
			moveToPos(fam, fdata, fdata.LastTargetPosRelative, origin, hasContinuum, tanOffset, false, numUniverses)
			return
		end
	end
	
	-- if decel/accel/model rocket, origin is lerped
	local hasRocketFlag = vanillaFlags & TearFlags.TEAR_DECELERATE == TearFlags.TEAR_DECELERATE or
	                      vanillaFlags & TearFlags.TEAR_ACCELERATE == TearFlags.TEAR_ACCELERATE or
	                      TearFlagsLib.HasTearFlags(fam, TearFlagsLib.Flag.MODEL_ROCKET)
	fdata.RocketLerp = fdata.RocketLerp or ((not fdata.Initialized and hasRocketFlag and 1) or 0)
	if hasRocketFlag then
		fdata.RocketLerp = lerp(fdata.RocketLerp, 1, modelRocketLerpIn)
	else
		fdata.RocketLerp = lerp(fdata.RocketLerp, 0, modelRocketLerpOut)
	end
	local rocketOrigin = origin * (1 - modelRocketLerp * fdata.RocketLerp) + (fdata.LastOrigin or origin) * modelRocketLerp * fdata.RocketLerp
	fdata.LastOriginOffset = rocketOrigin - origin
	origin = rocketOrigin
	fdata.LastOrigin = rocketOrigin

	-- update item trackers
	if fdata.CachedTrinityWormItem == nil then
		fdata.CachedTrinityWormItem = mod.GetTrinityWormMultiplier(player)
	end
	if fdata.CachedTanWormItem == nil then
		fdata.CachedTanWormItem = mod.GetTanWormMultiplier(player)
	end
	if fdata.CachedMyReflectionItem == nil then
		fdata.CachedMyReflectionItem = player:HasCollectible(CollectibleType.COLLECTIBLE_MY_REFLECTION)
	end
	if fdata.CachedTinyPlanetItem == nil then
		fdata.CachedTinyPlanetItem = player:HasCollectible(CollectibleType.COLLECTIBLE_TINY_PLANET)
	end

	-- update tracker for being sychronized to orbit
	if fdata.ResyncToOrbit == nil then
		fdata.ResyncToOrbit = false
	end
	if (fdata.WasTrinityWormFlag ~= nil and fdata.WasTrinityWormFlag ~= hasTrinityWormFlag) or
	   (fdata.WasSquareFlag ~= nil and fdata.WasSquareFlag ~= hasSquareFlag)
	then
		fdata.ResyncToOrbit = fam.SubType == PlanetXSubtype.BASE
		fdata.SmoothingToOrbit = true
	end

	-- range: base orbit radius
	-- undo range bonuses from certain tear movement items
	-- if feared, should have little to no range
	local isFeared = player:HasEntityFlags(EntityFlag.FLAG_FEAR)
	if fdata.CachedRange == nil then
		local newRange = player.TearRange
		if fdata.CachedTrinityWormItem > 0 then
			newRange = newRange - 500 * fdata.CachedTrinityWormItem
		end
		if fdata.CachedTanWormItem > 0 then
			newRange = newRange - 720 * fdata.CachedTanWormItem
		end
		if fdata.CachedMyReflectionItem then
			newRange = (newRange - 60) / 2
		end
		if fdata.CachedTinyPlanetItem then
			newRange = newRange - 260
		end
		if hasContinuum then
			newRange = math.max(360, newRange)
		end
		if isFeared then
			newRange = fearRange
		end
		fdata.CachedRange = newRange
	end

	-- if continuum, alter how much range converts to radius
	fdata.CurrentRange = lerp(fdata.CurrentRange or fdata.CachedRange, fdata.CachedRange, (isFeared and fearRangeLerp) or rangeLerp)
	fdata.ExtraRadius = lerp(fdata.ExtraRadius or (hasContinuum and extraRadiusContinuum) or extraRadius, (isFeared and 0) or (hasContinuum and extraRadiusContinuum) or extraRadius, (isFeared and fearExtraRadiusLerp) or extraRadiusLerp)
	fdata.Radius = math.log(math.max(1, fdata.CurrentRange + rangeScaler) / (40 + rangeScaler), (260 + rangeScaler) / (40 + rangeScaler)) * fdata.ExtraRadius + baseRadius

	-- shotspeed: base orbit velocity
	-- undo shotspeed bonuses from certain tear movement item effects
	if fdata.CachedShotSpeed == nil then
		local newShotSpeed = player.ShotSpeed
		if fdata.CachedMyReflectionItem then
			newShotSpeed = newShotSpeed / 1.6
		end
		fdata.CachedShotSpeed = newShotSpeed * (fdata.ShotSpeedMult or 1)
	end
	fdata.CurrentShotSpeed = lerp(fdata.CurrentShotSpeed or (fdata.CachedShotSpeed * 10 * baseShotSpeedFactor), fdata.CachedShotSpeed * 10 * baseShotSpeedFactor, shotSpeedLerp)
	fdata.OrbitVelocity = fdata.CurrentShotSpeed

	-- if fractal, apply spiral shape to orbit radius

	-- if guardian angel/spin to win, increase orbit velocity
	-- if big fan, decrease orbit velocity
	local twin = player:GetPlayerType() == mod.PLAYER.BRIEND and player:GetOtherTwin()
	if player:GetEffects():HasNullEffect(NullItemID.ID_SPIN_TO_WIN) or (twin and twin:GetEffects():HasNullEffect(NullItemID.ID_SPIN_TO_WIN)) then
		fdata.OrbitVelocity = fdata.OrbitVelocity * 7.2
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_GUARDIAN_ANGEL) or (twin and twin:HasCollectible(CollectibleType.COLLECTIBLE_GUARDIAN_ANGEL)) then
		fdata.OrbitVelocity = fdata.OrbitVelocity * 2
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BIG_FAN) or (twin and twin:HasCollectible(CollectibleType.COLLECTIBLE_BIG_FAN)) then
		fdata.OrbitVelocity = fdata.OrbitVelocity * 1/3
	end
	
	-- if darkness, reduce orbit velocity when the player is firing
	fdata.DarknessPhase = not TearFlagsLib.HasTearFlags(fam, TearFlagsLib.Flag.DARKNESS) or mod:GetEntityData(player).ff_darknessActive or player:GetFireDirection() == Direction.NO_DIRECTION
	fdata.DarknessVelMult = mod:Lerp(fdata.DarknessVelMult or 1, fdata.DarknessPhase and 1 or darknessSpeedMult, darknessSpeedLerp)
	fdata.OrbitVelocity = fdata.OrbitVelocity * fdata.DarknessVelMult

	-- apply any effects to orbit velocity/radius from the base system
	fdata.OrbitVelocity = fdata.OrbitVelocity * fam.OrbitSpeed
	fdata.Radius = fdata.Radius * math.max(0.000001, fam.OrbitDistance.X)

	-- determine angle rate so that orbit vel is maintained
	-- i dunno why this works specifically but it does
	-- magic~
	fdata.AngleRate = 57.33 / fdata.Radius * fdata.OrbitVelocity

	-- if whiskey, multiply radius and angle rate by random amounts
	fdata.WasWhiskey = fdata.WasWhiskey or false
	local hasWhiskeyFlag = TearFlagsLib.HasTearFlags(fam, TearFlagsLib.Flag.WHISKEY)
	if fam.SubType == PlanetXSubtype.MULTISHOT then
		fdata.Radius = pdata.Radius
		fdata.AngleRate = pdata.AngleRate
		fdata.WhiskeyAngleRateMult = pdata.WhiskeyAngleRateMult
		fdata.WhiskeyMultLerp = pdata.WhiskeyMultLerp
	else
		updateWhiskey(fdata, hasWhiskeyFlag)
	end

	local orbitPos
	if fam.SubType == PlanetXSubtype.BASE or (fam.SubType == PlanetXSubtype.EXTRA and hasWhiskeyFlag and fdata.Initialized) then
		-- update angle
		if false then
			-- if tractor, snap angle immediately to aim angle
		elseif false then
			-- if occult, update angle towards aim angle
		elseif not fdata.IgnoreAngleRateThisFrame then
			-- else, update angle regularly
			fdata.OrbitAngle = fdata.OrbitAngle + fdata.AngleRate
			fdata.TrinityAngle = fdata.TrinityAngle + fdata.AngleRate
		end
		fdata.OrbitAngle = fdata.OrbitAngle % 360
		fdata.TrinityAngle = fdata.TrinityAngle % 1080

		-- get orbit position of familiar relative to the player's position
		fdata.WasSmoothingToOrbit = fdata.SmoothingToOrbit
		orbitPos = getOrbitPos(fam, player, fdata, hasTinyPlanetFlag, fireDirection, hasTrinityWormFlag, hasSquareFlag)

		-- other
		fdata.WhiskeyNeedsToSober = false
	elseif fam.SubType == PlanetXSubtype.EXTRA then
		-- angle is entirely dependent on the parent
		fdata.OrbitAngle = (pdata.OrbitAngle + 360 * fdata.ExtraOrbitalMult) % 360
		fdata.TrinityAngle = (pdata.TrinityAngle + 540 * fdata.ExtraOrbitalMult) % 1080

		-- and by extension so is the orbit position
		fdata.SmoothingToOrbit = fdata.SmoothingToOrbit or fdata.WhiskeyNeedsToSober or pdata.WasSmoothingToOrbit
		fdata.WasSmoothingToOrbit = fdata.SmoothingToOrbit
		orbitPos = getOrbitPos(fam, player, fdata, hasTinyPlanetFlag, fireDirection, hasTrinityWormFlag, hasSquareFlag)
	elseif fam.SubType == PlanetXSubtype.MULTISHOT then
		-- angle is entirely dependent on the parent
		fdata.OrbitAngle = pdata.OrbitAngle
		fdata.TrinityAngle = pdata.TrinityAngle

		-- and by extension so is the orbit position
		fdata.SmoothingToOrbit = fdata.SmoothingToOrbit or pdata.WasSmoothingToOrbit
		fdata.WasSmoothingToOrbit = fdata.SmoothingToOrbit
		orbitPos = getOrbitPos(fam, player, fdata, hasTinyPlanetFlag, fireDirection, hasTrinityWormFlag, hasSquareFlag)
	end

	-- update target position with additional movements
	local targetPosRelative = orbitPos

	-- if boomerang, add movement from intended position to sinwave towards player
	local hasBoomerangFlag = vanillaFlags & TearFlags.TEAR_BOOMERANG == TearFlags.TEAR_BOOMERANG
	targetPosRelative = targetPosRelative + getBoomerangOffset(fam, fdata, hasBoomerangFlag, targetPosRelative, pdata)

	-- if multishot, add offset from intended position to make x-body system
	if fam.SubType > PlanetXSubtype.MULTISHOT then
		fdata.MultishotSpawnPos = getContinuumPos(targetPosRelative + origin)
	end
	targetPosRelative = targetPosRelative + getMultishotOffset(fam, fdata, targetPosRelative, pdata)

	-- if homing/brainworm/yin-yang/baby-bender/eternal bullet, try to move towards a targeted enemy's position if it's within a certain radius from the intented orbit position
	local targetPosRelativeBeforeOffsets = targetPosRelative
	local targetPosBeforeOffsets = getContinuumPos(targetPosRelativeBeforeOffsets + origin)
	local hasYinYangFlag = TearFlagsLib.HasTearFlags(fam, TearFlagsLib.Flag.YIN_YANG)
	local hasHomingFlag = vanillaFlags & (TearFlags.TEAR_HOMING | TearFlags.TEAR_TURN_HORIZONTAL) ~= TearFlags.TEAR_NORMAL or
	                      TearFlagsLib.HasTearFlags(fam, TearFlagsLib.Flag.BULLET_ETERNAL) or
	                      hasYinYangFlag

	fdata.PreviousHomingToPositions = fdata.PreviousHomingToPositions or {}
	if not hasHomingFlag then
		fam.Target = nil
		table.insert(fdata.PreviousHomingToPositions, fdata.CurrentHomingToPosition)
		fdata.CurrentHomingToPosition = nil
	else
		if fam.Target then
			local homingTo = fam.Target
			if (fdata.ForcedQuantumUniverse ~= nil and fdata.CurrentHomingToPosition.Universe ~= fdata.ForcedQuantumUniverse) or 
			   homingTo:Exists() or 
			   mod:isFriend(homingTo) or 
			   homingTo:HasEntityFlags(EntityFlag.FLAG_NO_TARGET)
			then
				fam.Target = nil
				table.insert(fdata.PreviousHomingToPositions, fdata.CurrentHomingToPosition)
				fdata.CurrentHomingToPosition = nil
			else
				local homingToPos = (homingTo.Position - origin):Rotated(-360 / numUniverses * fdata.CurrentHomingToPosition.Universe) + origin
				local dist = (homingToPos - getContinuumPos(targetPosRelativeBeforeOffsets + origin)):Length()
				if dist > homingRadius then
					fam.Target = nil
					table.insert(fdata.PreviousHomingToPositions, fdata.CurrentHomingToPosition)
					fdata.CurrentHomingToPosition = nil
				else
					fdata.CurrentHomingToPosition.Pos = homingToPos
				end
			end
		else
			fam.Target = nil
			table.insert(fdata.PreviousHomingToPositions, fdata.CurrentHomingToPosition)
			fdata.CurrentHomingToPosition = nil
		end
		if not fam.Target then
			local closest, closestNPC, closestUniverse = math.huge, nil, nil
			for i = 0, numUniverses-1 do
				if fdata.ForcedQuantumUniverse == i+1 or fdata.ForcedQuantumUniverse == nil then
					local universePosBeforeOffsets = getContinuumPos(targetPosRelativeBeforeOffsets:Rotated(360 / numUniverses * i) + origin)
					local npcs = Isaac.FindInRadius(universePosBeforeOffsets, homingRadius, EntityPartition.ENEMY)
					for _, npc in ipairs(npcs) do
						if npc.Type > 9 and npc.Type < 1000 and not mod:isFriend(npc) and not npc:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) then
							local dist = (npc.Position - universePosBeforeOffsets):Length()
							if dist < closest then
								closest = dist
								closestNPC = npc
								closestUniverse = i
							end
						end
					end
				end
			end
			if closestNPC then
				fam.Target = closestNPC
				fdata.CurrentHomingToPosition = {
					Pos = (closestNPC.Position - origin):Rotated(-360 / numUniverses * closestUniverse) + origin,
					Lerp = 0,
					Universe = closestUniverse+1
				}
			end
		end
	end
	
	local lerpStrength = math.min(homingMaxRate, fdata.OrbitVelocity * homingOrbitVelToRate * ((hasYinYangFlag and yinYangHomingMult) or 1))
	local origLerp = 1
	local totalPos = nilvector
	if fdata.CurrentHomingToPosition then
		fdata.CurrentHomingToPosition.Lerp = 1 - (1 - fdata.CurrentHomingToPosition.Lerp) * (1 - lerpStrength)
		totalPos = totalPos + (fdata.CurrentHomingToPosition.Pos - origin) * fdata.CurrentHomingToPosition.Lerp * homingMaxDistance
		origLerp = origLerp - (fdata.CurrentHomingToPosition.Lerp * homingMaxDistance)
	end
	for i = #fdata.PreviousHomingToPositions, 1, -1 do
		fdata.PreviousHomingToPositions[i].Lerp = fdata.PreviousHomingToPositions[i].Lerp * (1 - lerpStrength)
		if fdata.PreviousHomingToPositions[i].Lerp <= 0.0001 then
			table.remove(fdata.PreviousHomingToPositions, i)
		else
			totalPos = totalPos + (fdata.PreviousHomingToPositions[i].Pos - origin) * fdata.PreviousHomingToPositions[i].Lerp * homingMaxDistance
			origLerp = origLerp - (fdata.PreviousHomingToPositions[i].Lerp * homingMaxDistance)
		end
	end
	targetPosRelative = totalPos + targetPosRelative * origLerp

	-- if bounce/pop, override movement to bounce away from enemy/tear if hit

	-- if wiggle, add offset from intended position of sin wave perpendicular to vel direction
	local targetPosRelativeDiff = targetPosRelative - (fdata.LastTargetPosRelativeBeforeOffsets or targetPosRelative)
	local targetPosRelativeDiffLength = targetPosRelativeDiff:Length()
	local movementAngle = (targetPosRelativeDiffLength > 0 and targetPosRelativeDiff:GetAngleDegrees() % 360) or fdata.LastMovementAngle
	local wiggleOffset = Vector(0,0)
	if movementAngle ~= nil then
		if fam.SubType == PlanetXSubtype.BASE then
			fdata.WiggleFrame = (fdata.WiggleFrame or 0) + 1
		else
			fdata.WiggleFrame = pdata.WiggleFrame or 0
		end
		wiggleOffset = Vector.FromAngle(movementAngle + 90) *
		               math.sin(fdata.WiggleFrame * wiggleFrameMult) *
		               wiggleAmplitude *
		               math.min(wiggleMaxAtVel, targetPosRelativeDiffLength) / wiggleMaxAtVel
	end

	local hasWiggleFlag = vanillaFlags & TearFlags.TEAR_WIGGLE == TearFlags.TEAR_WIGGLE
	fdata.WiggleOffsetMult = fdata.WiggleOffsetMult or ((not fdata.Initialized and hasWiggleFlag and 1) or 0)
	if hasWiggleFlag then
		fdata.WiggleOffsetMult = lerp(fdata.WiggleOffsetMult, 1, wiggleLerpIn)
	else
		fdata.WiggleOffsetMult = lerp(fdata.WiggleOffsetMult, 0, wiggleLerpOut)
	end
	targetPosRelative = targetPosRelative + wiggleOffset * fdata.WiggleOffsetMult

	-- if big spiral, add offset from intended position of large circle
	local hasBigSpiralFlag = vanillaFlags & TearFlags.TEAR_BIG_SPIRAL == TearFlags.TEAR_BIG_SPIRAL
	fdata.BigSpiralOffsetMult = fdata.BigSpiralOffsetMult or ((not fdata.Initialized and hasBigSpiralFlag and 1) or 0)
	if hasBigSpiralFlag then
		fdata.BigSpiralOffsetMult = lerp(fdata.BigSpiralOffsetMult, 1, bigSpiralLerpIn)
	else
		fdata.BigSpiralOffsetMult = lerp(fdata.BigSpiralOffsetMult, 0, bigSpiralLerpOut)
	end
	if fam.SubType == PlanetXSubtype.BASE then
		fdata.BigSpiralAngle = (fdata.BigSpiralAngle or 0) + bigSpiralAngleRate
	else
		fdata.BigSpiralAngle = pdata.BigSpiralAngle or 0
	end
	local bigSpiralOffset = Vector.FromAngle(fdata.BigSpiralAngle) * bigSpiralRadius
	targetPosRelative = targetPosRelative + bigSpiralOffset * fdata.BigSpiralOffsetMult

	-- if spiral, add offset from intended position of small circle
	local hasSpiralFlag = vanillaFlags & TearFlags.TEAR_SPIRAL == TearFlags.TEAR_SPIRAL
	fdata.SpiralOffsetMult = fdata.SpiralOffsetMult or ((not fdata.Initialized and hasSpiralFlag and 1) or 0)
	if hasSpiralFlag then
		fdata.SpiralOffsetMult = lerp(fdata.SpiralOffsetMult, 1, spiralLerpIn)
	else
		fdata.SpiralOffsetMult = lerp(fdata.SpiralOffsetMult, 0, spiralLerpOut)
	end
	if fam.SubType == PlanetXSubtype.BASE then
		fdata.SpiralAngle = (fdata.SpiralAngle or 0) + spiralAngleRate
	else
		fdata.SpiralAngle = pdata.SpiralAngle or 0
	end
	local spiralOffset = Vector.FromAngle(fdata.SpiralAngle) * spiralRadius
	targetPosRelative = targetPosRelative + spiralOffset * fdata.SpiralOffsetMult

	-- if moji bug, add offset from intended position of random jitter within a certain radius

	-- if booger/sticky/spore, ignore movement to stay attached to enemy

	-- if tan, apply movement from intended position to move in tanwave shape
	local hasTanFlag = TearFlagsLib.HasTearFlags(fam, TearFlagsLib.Flag.TAN) or (fdata.TanFrame or 0) > 0
	local tanOffset, isTanResetting = Vector(0,0), false
	if hasTanFlag then
		fdata.TanFrame = ((fdata.TanFrame or 0) + 1) % #tanOffsets
		tanOffset = tanOffsets[fdata.TanFrame + 1]
		if tanOffset == math.huge then
			tanOffset = Vector(9999, 0)
		elseif tanOffset == -1 * math.huge then
			tanOffset = Vector(-9999, 0)
			isTanResetting = true
		end
		tanOffset = tanOffset:Rotated(targetPosRelativeBeforeOffsets:GetAngleDegrees())
	end

	-- move to target position
	moveToPos(fam, fdata, targetPosRelative, origin, hasContinuum, tanOffset, isTanResetting, numUniverses)

	-- update persistent info
	fdata.WasTrinityWormFlag = hasTrinityWormFlag
	fdata.WasSquareFlag = hasSquareFlag
	fdata.WhiskeyNeedsToSober = fdata.WhiskeyNeedsToSober or hasWhiskeyFlag
	fdata.LastFireDirection = fireDirection
	fdata.LastTargetPosRelative = targetPosRelative
	fdata.LastTargetPosRelativeBeforeOffsets = targetPosRelativeBeforeOffsets
	fdata.LastMovementAngle = movementAngle
	fdata.WasContinuum = hasContinuum

	fdata.PreviousTargetPosRelativesForWNIC = fdata.PreviousTargetPosRelativesForWNIC or {}
	table.insert(fdata.PreviousTargetPosRelativesForWNIC, targetPosRelative)
	while #fdata.PreviousTargetPosRelativesForWNIC > maxWNICPrevious do
		table.remove(fdata.PreviousTargetPosRelativesForWNIC, 1)
	end
end

local function getSpriteScale(scale, sizeMulti, flags)
	if scale > 2.55 then
        return Vector((scale * sizeMulti.X) / 2.55, (scale * sizeMulti.Y) / 2.55)
	elseif flags & TearFlags.TEAR_GROW == TearFlags.TEAR_GROW then
		if scale <= 0.3 then
			return Vector((scale * sizeMulti.X) / 0.25, (scale * sizeMulti.Y) / 0.25)
		elseif scale <= 0.55 then
			local adjustedBase = math.ceil((scale - 0.175) / 0.25) * 0.25 + 0.175
			return Vector((scale * sizeMulti.X) / adjustedBase, (scale * sizeMulti.Y) / adjustedBase)
		elseif scale <= 1.175 then
			local adjustedBase = math.ceil((scale - 0.175) / 0.125) * 0.125 + 0.175
			return Vector((scale * sizeMulti.X) / adjustedBase, (scale * sizeMulti.Y) / adjustedBase)
		elseif scale <= 2.175 then
			local adjustedBase = math.ceil((scale - 0.175) / 0.25) * 0.25 + 0.175
			return Vector((scale * sizeMulti.X) / adjustedBase, (scale * sizeMulti.Y) / adjustedBase)
		else
			return Vector((scale * sizeMulti.X) / 2.55, (scale * sizeMulti.Y) / 2.55)
		end
    else
        return sizeMulti
	end
end

local continuumColors = {
	Color(1, 1, 1, 1, 0, 0, 0, 1, 0.33, 1, 1),
	Color(1, 1, 1, 1, 0, 0, 0, 1, 0.66, 1, 1),
	Color(1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1),
	Color(1, 1, 1, 1, 0, 0, 0, 0.66, 0.66, 0.66, 1),
	Color(1, 1, 1, 1, 0, 0, 0, 0.33, 0.33, 0.33, 1),
	Color(0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0),
	Color(1, 1, 1, 1, 0, 0, 0, 0.33, 0, 0.33, 1),
	Color(1, 1, 1, 1, 0, 0, 0, 0.66, 0, 0.66, 1),
	Color(1, 1, 1, 1, 0, 0, 0, 1, 0, 1, 1),
}

local function getContinuumColor()
	return continuumColors[math.floor(game:GetFrameCount() / 2) % #continuumColors + 1]
end

local function getGodsMarbleColor()
	local s = math.asin(math.cos(game:GetFrameCount()/10*math.pi)) / math.pi * 2
	return Color(-s*2, -s*2, -s*2, 1, ((s+1) / 2), ((s+1) / 2), ((s+1) / 2), 1.2, 1.2, 0.8, 1)
end

local flashDuration = 5
local function getYaaiColor()
	local fcount = game:GetFrameCount()
    local flash = Color(1,1,1,1,0.2,0.2,0.2,1,1,1,1)
    if fcount % (flashDuration * 2) < flashDuration then
        flash = Color(-2,-2,-2, 1, 2.2, 2.2, 2.2, 1, 1, 1, 1)
    end
	return flash
end

local function updatePlanetXWNICPosMap(fam, player, fdata)
	local posMap = {}

	local frameSkipOffset = game:GetFrameCount() % wnicFrameSkip
	local beamStepOffset = math.floor((game:GetFrameCount() % (mod.wnicBlinkDuration ^ 2 * wnicFrameSkip)) / wnicFrameSkip)
	local frameSkip = (0 - frameSkipOffset) % wnicFrameSkip
	table.insert(posMap, 1, {pos = fdata.PreviousTargetPosRelativesForWNIC[#fdata.PreviousTargetPosRelativesForWNIC],
	                         v = (0 - beamStepOffset) % mod.wnicBlinkDuration <= mod.wnicIsVis})
	local beamStep = 1
	for i = #fdata.PreviousTargetPosRelativesForWNIC - 1, 2, -1 do
		if frameSkip == 0 then
			table.insert(posMap, 1, {pos = fdata.PreviousTargetPosRelativesForWNIC[i],
			                         v = (beamStep - beamStepOffset) % mod.wnicBlinkDuration <= mod.wnicIsVis})
			beamStep = beamStep + 1
		end
		frameSkip = (frameSkip + 1) % wnicFrameSkip
	end
	table.insert(posMap, 1, {pos = fdata.PreviousTargetPosRelativesForWNIC[1], v = true})

	for i = 1, #posMap do
		local val = posMap[i]
		if i == 1 then
			val.heartscale = (Vector.One * fdata.WNICEndpointScale)
            _,_,val.heartanim = mod:GetTearAnimSuffix(fdata.WNICEndpointScale)
		end
		val.rPos = val.pos + Vector(0,-23.75)
		val.origin = player
	end

	fdata.WNICPosMap = posMap
end

function mod:addPlanetXToConnectors(entity, player, parentPosMap, startPos, rEndPos)
    if player == nil then
        return
    end
    mod.initLoopController(player)

    local edata = mod:GetEntityData(entity)
    local ldata = mod:GetEntityData(mod.loopController)

    if edata.sw_loopIdx ~= nil then
		local idx = GetPtrHash(entity)
        ldata.sw_AgainTears = ldata.sw_AgainTears or {}
        ldata.sw_AgainTears[idx] = {
            t = entity,
            posMap = parentPosMap,
			ludo = false,
			planetx = true,
			sfc = 2,
			rEndPos = rEndPos
        }
        entity.Position = startPos
    else
		local idx = edata.PlanetIndex + 920000

		ldata.sw_GoingPlanets = ldata.sw_GoingPlanets or {}
		local oldfcount = (ldata.sw_GoingPlanets[idx] or {}).fcount
		ldata.sw_GoingPlanets[idx] = {
			p = entity,
			fcount = oldfcount
		}
	end

	ldata.sw_GoingTears = ldata.sw_GoingTears or {}
	ldata.sw_GoingTears[GetPtrHash(entity)] = nil -- need to do this or the tears have their own trails
end

function mod:handlePlanetXWNIC(fam, player)
	local fdata = mod:GetEntityData(fam)
	if fdata.WNICCooldown ~= nil then
		return
	end
	
	local tear = TearFlagsLib.FireSplitTear(fam, fdata.WNICPosMap[2].pos - fdata.WNICPosMap[1].pos, player, {
        RemoveFlags = FiendFolio.wnicDisallowedTearFlags,
        RemoveCustomFlags = TearFlagsLib.Flag.WNIC,

        PositionOverride = fdata.WNICPosMap[1].pos + player.Position,
        ColorOverride = player.TearColor,
        ScaleOverride = TearFlagsLib.GetCustomVanillaTearFlagParams(fam).ScaleOverride * 0.75,
        DamageMult = fam:GetMultiplier(),
        SplitTearType = "FF_WNIC",
    })

	tear.Height = -23.75
	tear.FallingSpeed = 0
	tear.FallingAcceleration = -0.1
	tear.PositionOffset = Vector(0, -23.75)
	tear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
    tear:SetColor(fam.Color*Color(1,1,1,0.05,1,2,1), 15, 15, true, true)
    mod:GetEntityData(tear).sw_loopIdx = GetPtrHash(fam)
	
	TearFlagsLib.GetCustomVanillaTearFlagParams(tear).ScaleOverride = nil

    mod:addPlanetXToConnectors(tear, player, fdata.WNICPosMap, fdata.WNICPosMap[1].pos + player.Position, fdata.WNICPosMap[#fdata.WNICPosMap].pos + Vector(0,-23.75))
	fdata.WNICCooldown = player.MaxFireDelay
end

local function updateCreepEffects(fam, player, fdata)
	mod:updateGalliumEffect(fam)
	mod:updateSpinachEffect(fam)
	mod:UpdateLeakyEffect(fam)
	mod:fiendsThirdLegGenericUpdate(fam)
end

local function spawnSplat(fam)
	local fdata = mod:GetEntityData(fam)
	if fdata.Hidden and fdata.Hidden > 0 then return end
	
	local var
	if fdata.TearVariant == TearVariant.BALLOON or fdata.TearVariant == TearVariant.BALLOON_BRIMSTONE or fdata.TearVariant == TearVariant.BALLOON_BOMB then
		var = 11
	elseif fdata.TearVariant == TearVariant.METALLIC then
		var = (math.random(2) == 1 and 13) or 12
	elseif mod:isBloodyTearVariant(fdata.TearVariant) then
		var = 11
	else
		var = (math.random(2) == 1 and 13) or 12
	end
	
	local poof = Isaac.Spawn(1000, var, 0, fam.Position, nilvector, fam)
	poof.PositionOffset = fam.PositionOffset
	poof.Color = fam:GetSprite().Color
	poof.SpriteScale = Vector(fam.Size / 7 * 0.8, fam.Size / 7 * 0.8)
	
	sfx:Play(258)
end

local function updateMultishotPlanets(fam, player, fdata, pdata, willRollEffects)
	if fam.SubType < PlanetXSubtype.MULTISHOT then
		fdata.MultishotOrbitals = fdata.MultishotOrbitals or {}

		local numMultishotChanged = false
		for i = #fdata.MultishotOrbitals, 1, -1 do
			if not fdata.MultishotOrbitals[i]:Exists() then
				table.remove(fdata.MultishotOrbitals, i)
				numMultishotChanged = true
			end
		end
		
		while fdata.NumMultishot - 1 > #fdata.MultishotOrbitals do
			local multishotOrbital = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.PLANET_X, PlanetXSubtype.MULTISHOT, fdata.MultishotSpawnPos or fam.Position, nilvector, fam):ToFamiliar()
			multishotOrbital:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			multishotOrbital.Parent = fam
			multishotOrbital.Player = fam.Player
			mod:GetEntityData(multishotOrbital).Owner = mod:GetEntityData(fam).Owner
			table.insert(fdata.MultishotOrbitals, multishotOrbital)
			numMultishotChanged = true
		end
		while fdata.NumMultishot - 1 < #fdata.MultishotOrbitals do
			local multishotOrbital = fdata.MultishotOrbitals[#fdata.MultishotOrbitals]
			table.remove(fdata.MultishotOrbitals, #fdata.MultishotOrbitals)
			if multishotOrbital:Exists() then
				spawnSplat(multishotOrbital)
				multishotOrbital:Remove()
			end
			numMultishotChanged = true
		end

		if numMultishotChanged then
			for i = 1, #fdata.MultishotOrbitals do
				local multishotOrbital = fdata.MultishotOrbitals[i]
				local mdata = mod:GetEntityData(multishotOrbital)
				mdata.MultishotOrbitalMult = i / (#fdata.MultishotOrbitals + 1)
				mdata.SmoothingToOrbit = mdata.SmoothingToOrbit or multishotOrbital.FrameCount ~= 0
			end
		end

		for i = 1, #fdata.MultishotOrbitals do
			local multishotOrbital = fdata.MultishotOrbitals[i]
			local cdata = mod:GetEntityData(multishotOrbital)
			mod:updatePlanetX(multishotOrbital, player, cdata, fdata, pdata, willRollEffects)
			if multishotOrbital.FrameCount == 0 then
				multishotOrbital:Update()
			end
		end
	end
end

-- optimizations babyyyyyyyyy
local cachedBreakableGrids = {}
local cachedDamagableGrids = {}
function cacheGrid(grid, frame, forceTNT)
	local pos = grid.Position
	local indexX, indexY = math.floor(pos.X / 40), math.floor(pos.Y / 40)
	local info = {
		Grid = grid,
		Center = {pos.X, pos.Y},
		TopLeft = {pos.X - 20, pos.Y - 20},
		TopRight = {pos.X + 20, pos.Y - 20},
		BottomLeft = {pos.X - 20, pos.Y + 20},
		BottomRight = {pos.X + 20, pos.Y + 20},
		LastFrameCached = frame or game:GetFrameCount(),
	}

	local typ = grid:GetType()
	local col = grid.CollisionClass
	if (col ~= GridCollisionClass.COLLISION_NONE and col ~= GridCollisionClass.COLLISION_PIT) or (typ == GridEntityType.GRID_TNT and forceTNT) then
		if typ == GridEntityType.GRID_POOP then -- or typ == GridEntityType.GRID_TNT then
			cachedDamagableGrids[indexX] = cachedDamagableGrids[indexX] or {}
			cachedDamagableGrids[indexX][indexY] = info
			cachedBreakableGrids[indexX] = cachedBreakableGrids[indexX] or {}
			cachedBreakableGrids[indexX][indexY] = info
			return
		elseif grid:ToRock() then
			info.CanReroll = true
			cachedDamagableGrids[indexX] = cachedDamagableGrids[indexX] or {}
			cachedDamagableGrids[indexX][indexY] = nil
			cachedBreakableGrids[indexX] = cachedBreakableGrids[indexX] or {}
			cachedBreakableGrids[indexX][indexY] = info
			return
		elseif grid:ToDoor() then
			cachedDamagableGrids[indexX] = cachedDamagableGrids[indexX] or {}
			cachedDamagableGrids[indexX][indexY] = nil
			cachedBreakableGrids[indexX] = cachedBreakableGrids[indexX] or {}
			cachedBreakableGrids[indexX][indexY] = info
			return
		end
	end
	cachedDamagableGrids[indexX] = cachedDamagableGrids[indexX] or {}
	cachedDamagableGrids[indexX][indexY] = nil
	cachedBreakableGrids[indexX] = cachedBreakableGrids[indexX] or {}
	cachedBreakableGrids[indexX][indexY] = nil
	return
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	local room = game:GetRoom()
	for x = 0, 30 do
		for y = 0, 30 do
			local grid = room:GetGridEntityFromPos(Vector(x * 40, y * 40))
			if grid then
				cacheGrid(grid, nil, grid:GetType() == GridEntityType.GRID_TNT and grid.State ~= 4)
			end
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_GRID_ENTITY_SPAWN, function(_, grid)
	cacheGrid(grid, nil, true)
end)

mod:AddCallback(ModCallbacks.MC_PRE_GRID_ENTITY_DOOR_UPDATE, function(_, door)
	cacheGrid(door)
end)

mod:AddCallback(ModCallbacks.MC_PRE_ROOM_EXIT, function()
	cachedBreakableGrids = {}
	cachedDamagableGrids = {}
end)

-- doing all this vector math purely on the lua side for performance reasons
-- seems to help a ton for some extreme cases
-- is probably overkill given those cases are likely to never occur (need multiple planets the size of entire rooms filled with grids that can be broken)
-- but w/e
local function add(a, b)
	return {a[1] + b[1], a[2] + b[2]}
end

local function subtract(a, b)
	return {a[1] - b[1], a[2] - b[2]}
end

local function multiply(a, n)
	return {a[1] * n, a[2] * n}
end

local function length(a)
	return math.sqrt(a[1]^2 + a[2]^2)
end

local function distance(a, b)
	return math.sqrt((b[1] - a[1]) ^ 2 + (b[2] - a[2]) ^ 2)
end

local function normalized(a)
	return multiply(a, 1 / length(a))
end

local function resized(a, n)
	return multiply(normalized(a), n)
end

local function dot(a, b)
	return a[1] * b[1] + a[2] * b[2]
end

local function rotated(a, n)
	return {math.cos(a[1], math.rad(n)) - math.sin(a[2], math.rad(n)),
	        math.sin(a[1], math.rad(n)) + math.cos(a[2], math.rad(n))}
end

local function getClosestPointOnLine(testPosition, lineOrigin, lineEnd)
	local heading = subtract(lineEnd, lineOrigin)
	local magnitude = length(heading)
	heading = normalized(heading)

	local lhs = subtract(testPosition, lineOrigin)
	local d = dot(lhs, heading)
	d = math.min(math.max(0, d), magnitude)
	return add(lineOrigin, multiply(heading, d))
end

local function circleLineIntersect(circlePos, circleRadius, lineA, lineB)
	return distance(getClosestPointOnLine(circlePos, lineA, lineB), circlePos) < circleRadius
end

local function circleGridIntersect(circlePos, circleRadius, gridInfo)
	-- https://stackoverflow.com/questions/401847/circle-rectangle-collision-detection-intersection
	local gridPos = gridInfo.Center
	if gridPos[1] - 20 <= circlePos[1] and circlePos[1] <= gridPos[1] + 20 and
	   gridPos[2] - 20 <= circlePos[2] and circlePos[2] <= gridPos[2] + 20
	then
		return true
	end

	return circleLineIntersect(circlePos, circleRadius, gridInfo.TopLeft, gridInfo.BottomLeft) or
	       circleLineIntersect(circlePos, circleRadius, gridInfo.BottomLeft, gridInfo.BottomRight) or
	       circleLineIntersect(circlePos, circleRadius, gridInfo.BottomRight, gridInfo.TopRight) or
	       circleLineIntersect(circlePos, circleRadius, gridInfo.TopRight, gridInfo.TopLeft)
end

local function rectangleGridIntersect(rectA, rectB, rectC, rectD, gridInfo)
	--https://stackoverflow.com/questions/10962379/how-to-check-intersection-between-2-rotated-rectangles
	local rect = {rectA, rectB, rectC, rectD}
	local grid = {gridInfo.TopLeft, gridInfo.BottomLeft, gridInfo.BottomRight, gridInfo.TopRight}

	for i = 1, 4 do
		local rectA = rect[i]
		local rectB = rect[((i+1) > 4 and 1) or i+1]

		local normal = {rectB[2] - rectA[2], rectA[1] - rectB[1]}

		local minRect, maxRect
		for _, rectPoint in ipairs(rect) do
			local projected = normal[1] * rectPoint[1] + normal[2] * rectPoint[2]
			if minRect == nil or projected < minRect then
				minRect = projected
			end
			if maxRect == nil or projected > maxRect then
				maxRect = projected
			end
		end

		local minGrid, maxGrid
		for _, gridPoint in ipairs(grid) do
			local projected = normal[1] * gridPoint[1] + normal[2] * gridPoint[2]
			if minGrid == nil or projected < minGrid then
				minGrid = projected
			end
			if maxGrid == nil or projected > maxGrid then
				maxGrid = projected
			end
		end

		if maxRect < minGrid or maxGrid < minRect then
			return false
		end
	end

	return true
end

local function applyGridEffects(fam, player, fdata, gridInfo, canBreakRocks, canRerollGrids, frame, room, indexX, indexY)
	local grid = gridInfo.Grid
	if gridInfo.LastFrameCached ~= frame then
		grid = room:GetGridEntityFromPos(Vector(gridInfo.Center[1], gridInfo.Center[2]))
		if grid then
			cacheGrid(grid, frame)
			local checking = ((canBreakRocks or canRerollGrids) and cachedBreakableGrids) or cachedDamagableGrids
			if not (checking[indexX] and checking[indexX][indexY]) then
				return
			end
			gridInfo = checking[indexX][indexY]
		else
			cachedDamagableGrids[indexX] = {}
			cachedDamagableGrids[indexX][indexY] = nil
			cachedBreakableGrids[indexX] = {}
			cachedBreakableGrids[indexX][indexY] = nil
			return
		end
	end
	if grid then
		if canRerollGrids and gridInfo.CanReroll then
			local gridPos = Vector(gridInfo.Center[1], gridInfo.Center[2])
			local tear = Isaac.Spawn(2, 0, 0, gridPos, nilvector, nil):ToTear()
			tear:AddTearFlags(TearFlags.TEAR_REROLL_ROCK_WISP)
			tear.FallingAcceleration = -0.1
			tear.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			tear.CollisionDamage = 0
			tear:SetInitSound(SoundEffect.SOUND_NULL)
			tear:Update()
			tear:Remove()
		elseif canBreakRocks then
			grid:Destroy()
			cacheGrid(grid, frame)
		else
			grid:Hurt((fam.CollisionDamage >= 10 and 2) or 1)
			cacheGrid(grid, frame)
		end
	end
end

local function updateGridEffects(fam, player, fdata, vanillaFlags)
	if vanillaFlags & TearFlags.TEAR_NO_GRID_DAMAGE ~= TearFlags.TEAR_NORMAL then return end

	local room = game:GetRoom()
	local frame = game:GetFrameCount()
	local capsule = fam:GetCollisionCapsule()
	local radius = capsule:GetF1()

	local s, e = capsule:GetVec2(), capsule:GetVec3()
	local startPos = {s.X, s.Y}
	local endPos = {e.X, e.Y}
	local pointDist = distance(startPos, endPos)

	local minX = math.max(0, math.floor(math.min(startPos[1] - radius, endPos[1] - radius) / 40))
	local maxX = math.min(30, math.ceil(math.max(startPos[1] + radius, endPos[1] + radius) / 40))
	local minY = math.max(0, math.floor(math.min(startPos[2] - radius, endPos[2] - radius) / 40))
	local maxY = math.min(30, math.ceil(math.max(startPos[2] + radius, endPos[2] + radius) / 40))

	local perpendicular = resized(rotated(subtract(endPos, startPos), 90), radius)
	local rectA = add(startPos, perpendicular)
	local rectB = subtract(startPos, perpendicular)
	local rectC = subtract(endPos, perpendicular)
	local rectD = add(endPos, perpendicular)

	local canBreakRocks = vanillaFlags & (TearFlags.TEAR_ACID | TearFlags.TEAR_ROCK) ~= TearFlags.TEAR_NORMAL
	local canRerollGrids = vanillaFlags & TearFlags.TEAR_REROLL_ROCK_WISP ~= TearFlags.TEAR_NORMAL
	local checking = ((canBreakRocks or canRerollGrids) and cachedBreakableGrids) or cachedDamagableGrids
	for x = minX, maxX do
		for y = minY, maxY do
			if checking[x] and checking[x][y] and not (fdata.GridHitList[x] and fdata.GridHitList[x][y]) then
				local gridInfo = checking[x][y]
				if circleGridIntersect(startPos, radius, gridInfo) or
				   (pointDist > 0.0001 and (circleGridIntersect(endPos, radius, gridInfo) or rectangleGridIntersect(rectA, rectB, rectC, rectD, gridInfo)))
				then
					applyGridEffects(fam, player, fdata, gridInfo, canBreakRocks, canRerollGrids, frame, room, x, y)
					fdata.GridHitList[x] = fdata.GridHitList[x] or {}
					fdata.GridHitList[x][y] = true
				end
			end
		end
	end
end

local function updateStrangeAttractor(fam, player, vanillaFlags)
	if vanillaFlags & TearFlags.TEAR_ATTRACTOR == TearFlags.TEAR_ATTRACTOR then
		local pos = fam.Position
		local dist = (pos - player.Position):Length()
		local force = math.min(math.max(1, dist / maxStrangeAttractorForceAt * maxStrangeAttractorForce), maxStrangeAttractorForce)
		game:UpdateStrangeAttractor(pos, force)
	end
end

local function doBasegameSplittingEffects(fam, player, fdata, vanillaFlags, isHydrobounce, pos)
	local var = fdata.TearVariant
	if var == TearVariant.BALLOON or var == TearVariant.BALLOON_BRIMSTONE or var == TearVariant.BALLOON_BOMB then
		var = TearVariant.BLOOD
	elseif var ~= TearVariant.METALLIC then
		if mod:isBloodyTearVariant(var) then
			var = TearVariant.BLOOD
		else
			var = TearVariant.BLUE
		end
	end
	
	if vanillaFlags & TearFlags.TEAR_SPLIT == TearFlags.TEAR_SPLIT then
		for i = 0, 180, 180 do
			local newtear = TearFlagsLib.FireSplitTear(fam, (fam.Position - player.Position):Rotated(i):Resized(player.ShotSpeed * 10), player, {
				RemoveFlags = TearFlags.TEAR_SPLIT,
				TearVariant = TearVariant.BLUE,
				ScaleOverride = fam.Size / 7 * 0.5,
				SplitTearType = SplitTearType.PARASITE,
				PositionOverride = pos,
			})
			TearFlagsLib.GetCustomVanillaTearFlagParams(newtear).ScaleOverride = nil
		end
	end
	if vanillaFlags & TearFlags.TEAR_QUADSPLIT == TearFlags.TEAR_QUADSPLIT then
		local vel = Vector.FromAngle(math.random() * 360):Resized(player.ShotSpeed * 10)
		for i = 90, 360, 90 do
			local newtear = TearFlagsLib.FireSplitTear(fam, vel:Rotated(i), player, {
				RemoveFlags = TearFlags.TEAR_SPLIT | TearFlags.TEAR_QUADSPLIT | TearFlags.TEAR_BONE,
				TearVariant = var,
				ScaleOverride = fam.Size / 7 * 0.6,
				SplitTearType = SplitTearType.QUAD,
				PositionOverride = pos,
			})
			newtear.Height = -11.875
			newtear.FallingSpeed = 0.757 + math.random() * 0.2
			newtear.FallingAcceleration = 0.0
			TearFlagsLib.GetCustomVanillaTearFlagParams(newtear).ScaleOverride = nil
		end
	end
	if not isHydrobounce and vanillaFlags & TearFlags.TEAR_BONE == TearFlags.TEAR_BONE then
		for i = 1, 2 do
			local vel = Vector.FromAngle(math.random() * 360):Resized(player.ShotSpeed * 10)
			local newtear = TearFlagsLib.FireSplitTear(fam, vel, player, {
				RemoveFlags = TearFlags.TEAR_BONE,
				TearVariant = var,
				ScaleOverride = 1.0,
				SplitTearType = SplitTearType.BONE,
				PositionOverride = pos,
			})
			newtear.Height = -23.75
			newtear.FallingSpeed = 0.1 + math.random() * 0.2
			newtear.FallingAcceleration = 0.0
			TearFlagsLib.GetCustomVanillaTearFlagParams(newtear).ScaleOverride = nil
		end
	end
	if vanillaFlags & TearFlags.TEAR_BURSTSPLIT == TearFlags.TEAR_BURSTSPLIT then
		for i = 1, math.random(6) + 5 do
			local vel = Vector.FromAngle(math.random() * 360):Resized(player.ShotSpeed * 10)
			local newtear = TearFlagsLib.FireSplitTear(fam, vel, player, {
				RemoveFlags = TearFlags.TEAR_SPLIT | TearFlags.TEAR_QUADSPLIT | TearFlags.TEAR_BONE | TearFlags.TEAR_BURSTSPLIT,
				TearVariant = TearVariant.BLOOD,
				DamageOverride = fam.CollisionDamage * (0.5 + math.random() * 0.35),
				ScaleOverride = fam.Size / 7 * (0.4 + math.random() * 0.3),
				SplitTearType = SplitTearType.BURST,
				PositionOverride = pos,
			})
			newtear.Height = -23.75
			newtear.FallingSpeed = -4 + math.random() * -7
			newtear.FallingAcceleration = 1.3
			TearFlagsLib.GetCustomVanillaTearFlagParams(newtear).ScaleOverride = nil
			TearFlagsLib.GetCustomVanillaTearFlagParams(newtear).DamageOverride = nil
		end
	end
end

local trackingIpecacDmg = nil
local function updateHydrobounce(fam, player, fdata, vanillaFlags)
	local hasHydrobounceFlag = (vanillaFlags & TearFlags.TEAR_HYDROBOUNCE == TearFlags.TEAR_HYDROBOUNCE and mod.IsActiveRoom()) or (fdata.HydrobounceFrame or 0) > 0
	local height = -23.75
	if mod:isSirenCharmed(fam) then
		fdata.HydrobounceFrame = 0
	elseif hasHydrobounceFlag then
		fdata.HydrobounceFrame = ((fdata.HydrobounceFrame or 0) + 1) % #hydrobounceHeights
		height = hydrobounceHeights[fdata.HydrobounceFrame + 1]
		if height == 0.0 then
			local sprite = fam:GetSprite()
			local hasBeansFlag = FiendFolio.HasBeansFlag(fam)
			for i = 1, fdata.LastNumUniverses or 1 do
				if fdata.ForcedQuantumUniverse == nil or fdata.ForcedQuantumUniverse == i then
					local origPos = fam.Position
					local pos = (not fdata.StickTarget and fdata.QuantumUniversePositions[i]) or fam.Position
					fam.Position = pos
					
					local origVel = fam.Velocity
					fam.Velocity = fdata.QuantumUniverseVelocities[i] or fam.Velocity
					
					local origCurrUniverse = fdata.CurrentQuantumUniverse
					fdata.CurrentQuantumUniverse = i
					
					doBasegameSplittingEffects(fam, player, fdata, vanillaFlags, true, pos)
					if vanillaFlags & TearFlags.TEAR_JACOBS == TearFlags.TEAR_JACOBS then
						game:ChainLightning(pos, fam.CollisionDamage * 0.5, vanillaFlags, player)
					end
					
					local hasExplosive = vanillaFlags & TearFlags.TEAR_EXPLOSIVE == TearFlags.TEAR_EXPLOSIVE
					local hasMysterious = vanillaFlags & TearFlags.TEAR_MYSTERIOUS_LIQUID_CREEP == TearFlags.TEAR_MYSTERIOUS_LIQUID_CREEP
					if hasExplosive then
						trackingIpecacDmg = {}
					end
					
					local tearscale = fam.Size / 7
					if vanillaFlags & (TearFlags.TEAR_EXPLOSIVE | TearFlags.TEAR_MYSTERIOUS_LIQUID_CREEP) ~= TearFlags.TEAR_NORMAL then
						TearFlagsLib.CancelDamage = true
						local tear = Isaac.Spawn(2, 0, 0, pos, nilvector, player):ToTear()
						tear.CollisionDamage = fam.CollisionDamage
						tear.Scale = tearscale
						tear.Color = (hasExplosive and lerpColor(fam.Color, fam.Color, 0)) or Color(1,1,1,0,0,0,0)
						tear:AddTearFlags(vanillaFlags &~ (TearFlagsLib.STICKY_TEAR_FLAGS | TearFlagsLib.SPLITSHOT_TEAR_FLAGS | TearFlagsLib.PIERCING_TEARFLAGS))
						tear:AddEntityFlags(EntityFlag.FLAG_NO_QUERY)
						tear:Die()
						TearFlagsLib.CancelDamage = false
						tear:Update()
						tear:Remove()
					end
					
					if hasBeansFlag then
						local params = mod:getCanFartParams(fam, player, TearFlagsLib.WeaponFlag.FF_PLANET_X)
						params.PositionOverride = pos
						params.IgnoreCooldown = true
						local color = Color.Lerp(params.ColorOverride, params.ColorOverride, 1)
						color.A = color.A * 0.5
						params.ColorOverride = color
						mod:spawnCanFartFromWeapon(fam, TearFlagsLib.WeaponFlag.FF_PLANET_X, params)
					end

					local hit = trackingIpecacDmg or {}
					trackingIpecacDmg = nil
					if not (hasExplosive or hasBeansFlag) then
						local ripple = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.RIPPLE_POOF, 0, pos, nilvector, fam)
						local color = Color.Lerp(sprite.Color, sprite.Color, 1)
						if not fdata.ForcedQuantumUniverse then
							color.A = color.A * 0.5
						end
						ripple.Color = color
						ripple.SpriteScale = Vector(1,1) * (tearscale * 0.25 + 0.28571)
						sfx:Play(150)

						for _, ent in ipairs(Isaac.FindInRadius(pos, 9999, EntityPartition.ENEMY)) do
							if ent.Type > 9 and ent.Type < 1000 and not ent:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) and ent.Type ~= EntityType.ENTITY_FIREPLACE and not mod:isFriend(ent) and
							   pos:Distance(ent.Position) <= (fam.Size + ent.Size + 13)
							then
								local damageFlags = 0
								if vanillaFlags & TearFlags.TEAR_MULLIGAN == TearFlags.TEAR_MULLIGAN then
									damageFlags = damageFlags | DamageFlag.DAMAGE_SPAWN_FLY
								end
								if hasExplosive then
									damageFlags = damageFlags | DamageFlag.DAMAGE_EXPLOSION
								end
								if vanillaFlags & TearFlags.TEAR_HP_DROP == TearFlags.TEAR_HP_DROP then
									if player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_GIMPY):RandomFloat() < 1/3 then
										damageFlags = damageFlags | DamageFlag.DAMAGE_SPAWN_RED_HEART
									end
								end
								if vanillaFlags & TearFlags.TEAR_ROCK == TearFlags.TEAR_ROCK then
									damageFlags = damageFlags | DamageFlag.DAMAGE_CRUSH
								end
								if vanillaFlags & TearFlags.TEAR_COIN_DROP_DEATH == TearFlags.TEAR_COIN_DROP_DEATH then
									damageFlags = damageFlags | DamageFlag.DAMAGE_SPAWN_COIN
								end
								if vanillaFlags & TearFlags.TEAR_CARD_DROP_DEATH == TearFlags.TEAR_CARD_DROP_DEATH then
									damageFlags = damageFlags | DamageFlag.DAMAGE_SPAWN_CARD
								end
								if vanillaFlags & TearFlags.TEAR_RUNE_DROP_DEATH == TearFlags.TEAR_RUNE_DROP_DEATH then
									damageFlags = damageFlags | DamageFlag.DAMAGE_SPAWN_RUNE
								end
								TearFlagsLib.DamageEntity(ent, fam.CollisionDamage * 0.25, damageFlags, fam, {IgnoreVanillaDamageFlags = true})
								table.insert(hit, ent)
							end
						end
					end
					
					for _, ent in ipairs(hit) do
						TearFlagsLib.CallTearFlagCallback(ent, player, fam, TearFlagsLib.WeaponFlag.FF_PLANET_X)
						
						mod.scheduleForUpdate(function()
							if not fdata.ForcedQuantumUniverse then
								for j = 1, fdata.LastNumUniverses or 1 do
									if j ~= i then
										local pos = fdata.QuantumUniversePositions[j] or fam.Position
										for k=1,7 do
											local ember = Isaac.Spawn(1000,66,0, pos+fam.PositionOffset, RandomVector()*math.random(10,45)/10, nil):ToEffect()
											ember.Color = Color(math.random(255)/255,math.random(255)/255,math.random(255)/255,1,0,0,0)
											ember.Scale = math.random(50,100)/100
											ember:SetTimeout(5)
											ember:Update()
										end
									end
								end
								fdata.ForcedQuantumUniverse = i
							end
							fdata.ForcedQuantumUniverseFrames = fdata.CollisionInterval + 1
						end, 1)
					end
					
					fam.Position = origPos
					fam.Velocity = origVel
					fdata.CurrentQuantumUniverse = origCurrUniverse
				end
			end
		end
	end
	fam.PositionOffset = Vector(0, height)
end

local function updatePalinopsia(fam, player, fdata)
	if TearFlagsLib.HasTearFlags(fam, TearFlagsLib.Flag.PALINSOPIA) then
		local ghostBehind = fdata.PalinopsiaHandler
		if not (ghostBehind and ghostBehind:Exists()) then
			ghostBehind = Isaac.Spawn(mod.FF.BeahInvisible.ID, mod.FF.BeahInvisible.Var, 21, fam.Position, Vector.Zero, player)
			fdata.PalinopsiaHandler = ghostBehind
			local gd = mod:GetEntityData(ghostBehind)
			gd.p_damageZones = gd.p_damageZones or {}
			gd.p_killSwitch = fam.Index
		end
		local gd = mod:GetEntityData(ghostBehind)

		gd.P_Die = 0

		if (fdata.Hidden or 0) <= 0 then
			for i = 1, fdata.LastNumUniverses or 1 do
				if fdata.ForcedQuantumUniverse == nil or fdata.ForcedQuantumUniverse == i then
					local pos = (not fdata.StickTarget and fdata.QuantumUniversePositions[i]) or fam.Position
					
					if fam.FrameCount % math.floor(3 * refreshRateFactor) == 1 then
						local sprite = fam:GetSprite()
						mod:hiddenBroadcastEnemy(fam, sprite, true, pos, palinopsiaTimeout * 2)
					end

					if fam.FrameCount % 7 == 1 then
						table.insert(gd.p_damageZones, {pos = pos, rad = fam.Size*0.94, dmg = 0.2*player.Damage*damageFactor, timeout = palinopsiaTimeout})
					end
				end
			end
		end
	else
		fdata.PalinopsiaHandler = nil
	end
end

local function updateExtraTearSprites(fam, player, fdata, vanillaFlags)
	if not fdata.GodheadHaloSprite then
		fdata.GodheadHaloSprite = Sprite()
		fdata.GodheadHaloSprite:Load("gfx/tearhalo.anm2", true)
		fdata.GodheadHaloSprite:Play("Idle", true)
		fdata.GodheadHaloSprite.Color = Color(1,1,1,1/3)
	end
	fdata.GodheadHaloSprite:Update()
	if vanillaFlags & TearFlags.TEAR_GLOW == TearFlags.TEAR_GLOW then
		fdata.GodheadHaloSprite.Color = Color(1,1,1,math.min(1, fdata.GodheadHaloSprite.Color.A+1/3))
		
		if fam.FrameCount % godheadDamageRate == 0 then
			for _, ent in ipairs(Isaac.FindInRadius(fam.Position, 9999, EntityPartition.ENEMY)) do
				if ent.Type > 9 and ent.Type < 1000 and not ent:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) and ent.Type ~= EntityType.ENTITY_FIREPLACE and not mod:isFriend(ent) then
					for i = 1, fdata.LastNumUniverses or 1 do
						if fdata.ForcedQuantumUniverse == nil or fdata.ForcedQuantumUniverse == i then
							local pos = (not fdata.StickTarget and fdata.QuantumUniversePositions[i]) or fam.Position
							if ent.Position:Distance(pos) <= (fam.Size * 4 + ent.Size) then
								TearFlagsLib.DamageEntity(ent, godheadHaloDamage, 0, fam, {IgnoreVanillaDamageFlags = true})
								
								mod.scheduleForUpdate(function()
									if not fdata.ForcedQuantumUniverse then
										for j = 1, fdata.LastNumUniverses or 1 do
											if j ~= i then
												local pos = fdata.QuantumUniversePositions[j] or fam.Position
												for k=1,7 do
													local ember = Isaac.Spawn(1000,66,0, pos+fam.PositionOffset, RandomVector()*math.random(10,45)/10, nil):ToEffect()
													ember.Color = Color(math.random(255)/255,math.random(255)/255,math.random(255)/255,1,0,0,0)
													ember.Scale = math.random(50,100)/100
													ember:SetTimeout(5)
													ember:Update()
												end
											end
										end
										fdata.ForcedQuantumUniverse = i
									end
									fdata.ForcedQuantumUniverseFrames = fdata.CollisionInterval + 1
								end, 1)
							end
						end
					end
				end
			end
		end
	else
		fdata.GodheadHaloSprite.Color = Color(1,1,1,math.max(0, fdata.GodheadHaloSprite.Color.A-1/3))
	end
	
	if not fdata.DeadEyeSprite then
		fdata.DeadEyeSprite = Sprite()
		fdata.DeadEyeSprite:Load("gfx/deadeyeteareffect.anm2", true)
		fdata.DeadEyeSprite:Play("Idle", true)
		fdata.DeadEyeSprite:GetLayer(0):GetBlendMode():SetMode(BlendType.ADDITIVE)
		fdata.DeadEyeSprite.Color = Color(1,1,1,0)
	end
	fdata.DeadEyeSprite:Update()
	local currentCharge = fdata.DeadEyeCurrentCharge or 0
	local targetCharge = fdata.DeadEyeCharge
	if currentCharge > targetCharge then
		fdata.DeadEyeCurrentCharge = math.max(targetCharge, currentCharge - math.abs((targetCharge - fdata.LastDeadEyeCharge) / 3))
	elseif currentCharge < targetCharge then
		fdata.DeadEyeCurrentCharge = math.min(targetCharge, currentCharge + math.abs((targetCharge - fdata.LastDeadEyeCharge) / 3))
	end
	if fdata.BelialActive > 0 then
		fdata.BelialCharge = math.min((fdata.BelialCharge or 0) + 0.1, 0.3)
	else
		fdata.BelialCharge = math.max((fdata.BelialCharge or 0) - 0.1, 0)
	end
	fdata.DeadEyeSprite.Color = Color(1,1,1,currentCharge+fdata.BelialCharge)
	
	local hasHorn = vanillaFlags & (TearFlags.TEAR_HORN | TearFlags.TEAR_RIFT) ~= TearFlags.TEAR_NORMAL
	if not fdata.LittleHornSprite then
		fdata.LittleHornSprite = Sprite()
		fdata.LittleHornSprite:Load("gfx/littlehornteareffect.anm2", true)
		fdata.LittleHornSprite:Play("Idle", true)
		fdata.LittleHornSprite:GetLayer(0):GetBlendMode():SetMode(BlendType.ADDITIVE)
		fdata.LittleHornSprite.Color = Color(1,1,1,1/3)
	end
	fdata.LittleHornSprite:Update()
	if hasHorn then
		fdata.LittleHornSprite.Color = Color(1,1,1,math.min(1, fdata.LittleHornSprite.Color.A+1/3))
	else
		fdata.LittleHornSprite.Color = Color(1,1,1,math.max(0, fdata.LittleHornSprite.Color.A-1/3))
	end
	
	local hasLight = vanillaFlags & TearFlags.TEAR_LIGHT_FROM_HEAVEN ~= TearFlags.TEAR_NORMAL
	if not fdata.HolyLightSprite then
		fdata.HolyLightSprite = Sprite()
		fdata.HolyLightSprite:Load("gfx/holylightteareffect.anm2", true)
		fdata.HolyLightSprite:Play("Idle", true)
		fdata.HolyLightSprite:GetLayer(0):GetBlendMode():SetMode(BlendType.ADDITIVE)
		fdata.HolyLightSprite.Color = Color(1,1,1,1/3)
	end
	fdata.HolyLightSprite:Update()
	if hasLight and not hasHorn then
		fdata.HolyLightSprite.Color = Color(1,1,1,math.min(1, fdata.HolyLightSprite.Color.A+1/3))
	else
		fdata.HolyLightSprite.Color = Color(1,1,1,math.max(0, fdata.HolyLightSprite.Color.A-1/3))
	end
	
	local hasJacob = vanillaFlags & TearFlags.TEAR_JACOBS ~= TearFlags.TEAR_NORMAL
	if not fdata.JacobsLadderSprite then
		fdata.JacobsLadderSprite = Sprite()
		fdata.JacobsLadderSprite:Load("gfx/jacobsladderteareffect.anm2", true)
		fdata.JacobsLadderSprite:Play("Idle", true)
		fdata.JacobsLadderSprite.Color = Color(1,1,1,1/3)
	end
	fdata.JacobsLadderSprite:Update()
	if hasJacob and not (hasHorn or hasLight) then
		fdata.JacobsLadderSprite.Color = Color(1,1,1,math.min(1, fdata.JacobsLadderSprite.Color.A+1/3))
	else
		fdata.JacobsLadderSprite.Color = Color(1,1,1,math.max(0, fdata.JacobsLadderSprite.Color.A-1/3))
	end
	
	local hasMysterious = vanillaFlags & TearFlags.TEAR_MYSTERIOUS_LIQUID_CREEP ~= TearFlags.TEAR_NORMAL
	if not fdata.MysteriousLiquidSprite then
		fdata.MysteriousLiquidSprite = Sprite()
		fdata.MysteriousLiquidSprite:Load("gfx/mysteriousteareffect.anm2", true)
		fdata.MysteriousLiquidSprite:Play("Idle", true)
		fdata.MysteriousLiquidSprite.Color = Color(1,1,1,1/3)
	end
	fdata.MysteriousLiquidSprite:Update()
	if hasMysterious and not (hasHorn or hasLight or hasJacob) then
		fdata.MysteriousLiquidSprite.Color = Color(1,1,1,math.min(1, fdata.MysteriousLiquidSprite.Color.A+1/3))
	else
		fdata.MysteriousLiquidSprite.Color = Color(1,1,1,math.max(0, fdata.MysteriousLiquidSprite.Color.A-1/3))
	end
	
	local hasBurn = vanillaFlags & TearFlags.TEAR_BURN ~= TearFlags.TEAR_NORMAL
	if not fdata.FireMindSprite then
		fdata.FireMindSprite = Sprite()
		fdata.FireMindSprite:Load("gfx/firemindteareffect.anm2", true)
		fdata.FireMindSprite:Play("Idle", true)
		fdata.FireMindSprite.Color = Color(1,1,1,1/3)
	end
	fdata.FireMindSprite:Update()
	if hasBurn and not (hasHorn or hasLight or hasJacob or hasMysterious) then
		fdata.FireMindSprite.Color = Color(1,1,1,math.min(1, fdata.FireMindSprite.Color.A+1/3))
	else
		fdata.FireMindSprite.Color = Color(1,1,1,math.max(0, fdata.FireMindSprite.Color.A-1/3))
	end
	
	local hasDarkMatter = vanillaFlags & TearFlags.TEAR_DARK_MATTER ~= TearFlags.TEAR_NORMAL
	if not fdata.DarkMatterSprite then
		fdata.DarkMatterSprite = Sprite()
		fdata.DarkMatterSprite:Load("gfx/darkmatterteareffect.anm2", true)
		fdata.DarkMatterSprite:Play("Idle", true)
		fdata.DarkMatterSprite.Color = Color(1,1,1,1/3)
	end
	fdata.DarkMatterSprite:Update()
	if hasDarkMatter and not (hasHorn or hasLight or hasJacob or hasMysterious or hasBurn) then
		fdata.DarkMatterSprite.Color = Color(1,1,1,math.min(1, fdata.DarkMatterSprite.Color.A+1/3))
	else
		fdata.DarkMatterSprite.Color = Color(1,1,1,math.max(0, fdata.DarkMatterSprite.Color.A-1/3))
	end
end

function mod:makePlanetXBloody(fam)
	local fdata = mod:GetEntityData(fam)
	fdata.TearVariant = mod.RegularToBlood[fdata.TearVariant] or fdata.TearVariant
end

mod.PlanetsSpawned = mod.PlanetsSpawned or 0
local planetsToRescale = {}
function mod:updatePlanetX(fam, player, fdata, pdata, gpdata, willRollEffects)
	if not fdata.Initialized then
		-- okay so i really want to support any mods that modify orbitspeed/distance
		-- however, this updates orbitspeed of anything else in that layer
		-- which actually wouldn't be a problem if it didn't also update it on removal
		-- so each familiar gets it's own layer now fuck it nightmare nightmare nightmare
		fdata.PlanetIndex = mod.PlanetsSpawned
		fam:AddToOrbit(9200000 + fdata.PlanetIndex)
		mod.PlanetsSpawned = mod.PlanetsSpawned + 1

		fam.OrbitSpeed = 1
		fam.OrbitDistance = Vector(1,0)

		fam:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
		fam.Mass = 0.000001
		
		fdata.IgnoreAngleRateThisFrame = true
		fdata.LastNumUniverses = 1
		
		sfx:Play(153)
	else
		fdata.IgnoreAngleRateThisFrame = nil
	end
	
	local isCharmed = fam:IsCharmed()
	if fdata.WasCharmed ~= nil and isCharmed ~= fdata.WasCharmed then
		fam.OrbitSpeed = 1
		fam.OrbitDistance = Vector(1,0)
		fam.Color = Color()
		if fdata.LastTargetPosRelative then 
			fam.Position = player.Position + fdata.LastTargetPosRelative 
		end
	end

	local room = game:GetRoom()
	local roomframe = room:GetFrameCount()
	if roomframe == 0 then
		fdata.GridHitList = {}
	end

	fdata.PastCollisions = fdata.PastCollisions or {}
	fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE

	fdata.BasegameTearflagCooldowns = fdata.BasegameTearflagCooldowns or {}
	for flag, cooldown in pairs(fdata.BasegameTearflagCooldowns) do
		fdata.BasegameTearflagCooldowns[flag] = fdata.BasegameTearflagCooldowns[flag] - 1
		if fdata.BasegameTearflagCooldowns[flag] <= 0 then
			fdata.BasegameTearflagCooldowns[flag] = nil
		end
	end
	if fdata.WNICCooldown ~= nil then
		fdata.WNICCooldown = fdata.WNICCooldown - 1
		if fdata.WNICCooldown <= 0 then
			fdata.WNICCooldown = nil
		end
	end
	if fdata.ParanoiaCooldown ~= nil then
		fdata.ParanoiaCooldown = fdata.ParanoiaCooldown - 1
		if fdata.ParanoiaCooldown <= 0 then
			fdata.ParanoiaCooldown = nil
		end
	end
	if fdata.ZeroPointCooldown ~= nil then
		fdata.ZeroPointCooldown = fdata.ZeroPointCooldown - 1
		if fdata.ZeroPointCooldown <= 0 then
			fdata.ZeroPointCooldown = nil
		end
	end
	if fdata.YAAICooldown ~= nil then
		fdata.YAAICooldown = fdata.YAAICooldown - 1
		if fdata.YAAICooldown <= 0 then
			fdata.YAAICooldown = nil
		end
	end

	fdata.QueuedColors = fdata.QueuedColors or {}
	if not fdata.Initialized or willRollEffects then
		local oldColor = fam.Color
		fdata.HadContinuum = TearFlagsLib.GetCustomVanillaTearFlags(fam) & TearFlags.TEAR_CONTINUUM == TearFlags.TEAR_CONTINUUM
		fdata.HadGodsMarble = TearFlagsLib.HasTearFlags(fam, TearFlagsLib.Flag.GODS_MARBLE)
		fdata.HadYaai = TearFlagsLib.HasTearFlags(fam, TearFlagsLib.Flag.YAAI)
		if FiendFolio.HasBeansFlag(fam) then
			fdata.LastBeansInfo = FiendFolio.GetBeansTearFlagParams(fam)
		else
			fdata.LastBeansInfo = nil
		end
		fdata.CyclingLerp = nil
		
		if not isCharmed and TearFlagsLib.HasTearFlags(fam, mod.FriendBulletFlags.BONE) and mod.IsActiveRoom() then
			mod:FireFriendBoneHeartBones(fam, player, fam.Position, nil, nil, 4, 0.5)
		end

		TearFlagsLib.WipeTearFlags(fam)
		TearFlagsLib.WipeCustomVanillaTearFlags(fam)
		fdata.ShotSpeedMult = nil

		local hasBabyBender = player:HasTrinket(TrinketType.TRINKET_BABY_BENDER)
		local params = player:GetTearHitParams(WeaponType.WEAPON_TEARS, fam:GetMultiplier())
		fam.CollisionDamage = params.TearDamage * damageFactor
		fam.Size = 7 * params.TearScale * scaleFactor * ((player:HasCollectible(CollectibleType.COLLECTIBLE_DEATHS_TOUCH) and 2) or 1)
		fam.Color = params.TearColor * ((hasBabyBender and Color.TearHoming) or Color())
		fdata.TearVariant = params.TearVariant
		if fdata.TearVariant ~= TearVariant.BALLOON and fdata.TearVariant ~= TearVariant.BALLOON_BRIMSTONE and 
		   fdata.TearVariant ~= TearVariant.BALLOON_BOMB and fdata.TearVariant ~= TearVariant.METALLIC
		then
			if mod:isBloodyTearVariant(fdata.TearVariant) then
				fdata.TearVariant = TearVariant.BLOOD
			else
				fdata.TearVariant = TearVariant.BLUE
			end
		end
		TearFlagsLib.AddCustomVanillaTearFlags(fam, params.TearFlags | ((hasBabyBender and TearFlags.TEAR_HOMING) or TearFlags.TEAR_NORMAL))
		TearFlagsLib.CallPollTearFlagCallback(fam, player, TearFlagsLib.WeaponFlag.FF_PLANET_X)
		local hasHomingFlag = TearFlagsLib.GetCustomVanillaTearFlags(fam) & TearFlags.TEAR_HOMING == TearFlags.TEAR_HOMING or
		                      TearFlagsLib.HasTearFlags(fam, TearFlagsLib.Flag.BULLET_ETERNAL) or
		                      TearFlagsLib.HasTearFlags(fam, TearFlagsLib.Flag.YIN_YANG)
		if not isCharmed and not hasHomingFlag and (fdata.BelialActive or 0) > 0 then
			TearFlagsLib.AddCustomVanillaTearFlags(fam, TearFlags.TEAR_HOMING)
			fdata.BelialAddedHoming = true
		else
			fdata.BelialAddedHoming = false
		end
		fdata.IsSlippy = (pdata and pdata.IsSlippy) or player:GetPlayerType() == mod.PLAYER.SLIPPY
		fdata.IsAcupuncture = (pdata and pdata.IsAcupuncture) or  mod:shouldFireAcupuncture(player, fam:GetDropRNG(), mod:GetEntityData(player))
		fdata.Damage = fam.CollisionDamage * ((fdata.IsSlippy and 0.8) or (fdata.IsAcupuncture and 0.65) or 1)
		fdata.Scale = fam.Size / 7
		TearFlagsLib.SetCustomVanillaTearFlagParams(fam, {
			RemoveStickyTears = true,
			ScaleOverride = fdata.Scale,
			ColorOverride = lerpColor(fam.Color, fam.Color, 0),
		})
		if FiendFolio.HasBeansFlag(fam) then
			fam.Color = mod:getCanOfBeansColor(fam.Color, FiendFolio.GetBeansTearFlagParams(fam))
		end

		fdata.WNICEndpointScale = mod:getTearParamsScale(player, player.Damage, player.TearFlags) * 0.7

		fdata.QueuedColors = {}
		if fam.FrameCount > 0 then
			local newColorA = lerpColor(oldColor, fam.Color, 0.33)
			local newColorB = lerpColor(oldColor, fam.Color, 0.66)
			local newColorC = fam.Color
			
			table.insert(fdata.QueuedColors, newColorA)
			table.insert(fdata.QueuedColors, newColorB)
			table.insert(fdata.QueuedColors, newColorC)
		end

		local forgottenLullabyMult = (player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) and 0.5) or 1
		fdata.CollisionInterval = math.max(minCollisionInterval, math.floor(player.MaxFireDelay * collisionIntervalFactor * forgottenLullabyMult))
		if TearFlagsLib.GetCustomVanillaTearFlags(fam) & TearFlags.TEAR_LASERSHOT == TearFlags.TEAR_LASERSHOT then
			fdata.CollisionInterval = 2
		end
		fdata.PastCollisions = fdata.PastCollisions or {}
		for i = #fdata.PastCollisions, 1, -1 do
			local collision = fdata.PastCollisions[i]
			if collision.Interval > fdata.CollisionInterval then
				collision.Interval = fdata.CollisionInterval
			end
		end
		fdata.HasHitThisRoll = nil
		fdata.PastCollisionsThisRoll = {}

		fdata.CachedRange = nil
		fdata.CachedShotSpeed = nil
		
		fdata.DeadEyeCharge = math.min(player:GetDeadEyeCharge() / 8, 1)
		fdata.LastDeadEyeCharge = (fdata.DeadEyeSprite and fdata.DeadEyeSprite.Color.A) or 0
		
		local numUniverses = (TearFlagsLib.HasTearFlags(fam, quantumflag) and TearFlagsLib.GetTearFlagParams(fam, quantumflag).num) or 1
		if fdata.LastNumUniverses ~= numUniverses and fdata.LastNumUniverses ~= nil then
			for i = 2, fdata.LastNumUniverses or 1 do
				if i == fdata.ForcedQuantumUniverse or fdata.ForcedQuantumUniverse == nil then
					local pos = fdata.QuantumUniversePositions[i] or fam.Position
					for j=1,7 do
						local ember = Isaac.Spawn(1000,66,0, pos+fam.PositionOffset, RandomVector()*math.random(10,45)/10, nil):ToEffect()
						ember.Color = Color(math.random(255)/255,math.random(255)/255,math.random(255)/255,1,0,0,0)
						ember.Scale = math.random(50,100)/100
						ember:SetTimeout(5)
						ember:Update()
					end
				end
			end
		
			fdata.ForcedQuantumUniverse = nil
			fdata.ForcedQuantumUniverseFrames = 0
		end

		fdata.TrueNumMultishot = (fam.SubType == PlanetXSubtype.MULTISHOT and pdata and pdata.Multishot) or 
		                         math.min(player:GetMultiShotParams(WeaponType.WEAPON_TEARS):GetNumTears() * (((fdata.IsSlippy or fdata.IsAcupuncture) and 3) or 1), multishotCap)
		fdata.GridHitList = {}
	end
	fdata.NumMultishot = fdata.TrueNumMultishot + math.floor((gpdata and gpdata.CursedCharge) or (pdata and pdata.CursedCharge) or fdata.CursedCharge)

	local vanillaFlags = TearFlagsLib.GetCustomVanillaTearFlags(fam)
	local vanillaParams = TearFlagsLib.GetCustomVanillaTearFlagParams(fam)

	fdata.CurrentColor = fdata.CurrentColor or fam.Color
	if #fdata.QueuedColors >= 1 then
		fdata.CurrentColor = table.remove(fdata.QueuedColors, 1)
	end

	local hasContinuum = vanillaFlags & TearFlags.TEAR_CONTINUUM == TearFlags.TEAR_CONTINUUM
	local hasGodsMarble = TearFlagsLib.HasTearFlags(fam, TearFlagsLib.Flag.GODS_MARBLE)
	local hasYaai = TearFlagsLib.HasTearFlags(fam, TearFlagsLib.Flag.YAAI)
	local hasBeans = FiendFolio.HasBeansFlag(fam)
	local originalContinuumColor = getContinuumColor()
	local originalGodsMarbleColor = getGodsMarbleColor()
	local originalYaaiColor = getYaaiColor()
	local cyclingColor = fdata.CurrentColor
	if hasContinuum or hasGodsMarble or hasYaai or fdata.HadContinuum or fdata.HadGodsMarble or fdata.HadYaai then
		local oldCyclingColor
		local newCyclingColor

		if hasYaai then
			if hasBeans then
				newCyclingColor = mod:getCanOfBeansColor(originalYaaiColor, FiendFolio.GetBeansTearFlagParams(fam))
			else
				newCyclingColor = originalYaaiColor
			end
		elseif hasGodsMarble then
			if hasBeans then
				newCyclingColor = mod:getCanOfBeansColor(originalGodsMarbleColor, FiendFolio.GetBeansTearFlagParams(fam))
			else
				newCyclingColor = originalGodsMarbleColor
			end
		elseif hasContinuum then
			if hasBeans then
				newCyclingColor = mod:getCanOfBeansColor(originalContinuumColor, FiendFolio.GetBeansTearFlagParams(fam))
			else
				newCyclingColor = originalContinuumColor
			end
		end
		if fdata.HadYaai then
			if fdata.LastBeansInfo then
				oldCyclingColor = mod:getCanOfBeansColor(originalYaaiColor, fdata.LastBeansInfo)
			else
				oldCyclingColor = originalYaaiColor
			end
		elseif fdata.HadGodsMarble then
			if fdata.LastBeansInfo then
				oldCyclingColor = mod:getCanOfBeansColor(originalGodsMarbleColor, fdata.LastBeansInfo)
			else
				oldCyclingColor = originalGodsMarbleColor
			end
		elseif fdata.HadContinuum then
			if fdata.LastBeansInfo then
				oldCyclingColor = mod:getCanOfBeansColor(originalContinuumColor, fdata.LastBeansInfo)
			else
				oldCyclingColor = originalContinuumColor
			end
		end

		fdata.CyclingLerp = math.min(3, (fdata.CyclingLerp or 0) + 1)
		cyclingColor = lerpColor(oldCyclingColor or newCyclingColor, newCyclingColor or oldCyclingColor, fdata.CyclingLerp / 3)
	end
	if hasYaai then
		fdata.CyclingColorStrength = math.min(3, (fdata.CyclingColorStrength or 0) + 1)
		vanillaParams.ColorOverride = originalYaaiColor
	elseif hasGodsMarble then
		fdata.CyclingColorStrength = math.min(3, (fdata.CyclingColorStrength or 0) + 1)
		vanillaParams.ColorOverride = originalGodsMarbleColor
	elseif hasContinuum then
		fdata.CyclingColorStrength = math.min(3, (fdata.CyclingColorStrength or 0) + 1)
		vanillaParams.ColorOverride = originalContinuumColor
	else
		fdata.CyclingColorStrength = math.max(0, (fdata.CyclingColorStrength or 0) - 1)
	end

	if isCharmed then
		fdata.ForcedQuantumUniverseFrames = 0
		fdata.BelialActive = 0
		fdata.BrainFossilCooldown = 0
		fdata.BrainFossilWaitingToGoOnCooldown = nil
		fdata.PulseLerp = 0
		fdata.Hidden = 0
		fdata.WasHidden = nil
	end

	fdata.ForcedQuantumUniverseFrames = math.max(0, (fdata.ForcedQuantumUniverseFrames or 0) - 1)
	if fdata.ForcedQuantumUniverseFrames <= 0 then
		fdata.ForcedQuantumUniverse = nil
	end
	if fdata.BrainFossilWaitingToGoOnCooldown == nil then
		fdata.BelialActive = math.max(0, (fdata.BelialActive or 0) - 1)
		if fdata.BelialActive <= 0 and fdata.BelialAddedHoming then
			fdata.BelialAddedHoming = false
			TearFlagsLib.ClearCustomVanillaTearFlags(fam, TearFlags.TEAR_HOMING)
		end
	end
	fdata.BrainFossilCooldown = math.max(0, (fdata.BrainFossilCooldown or 0) - 1)
	if fdata.BrainFossilWaitingToGoOnCooldown ~= nil then
		fdata.BrainFossilWaitingToGoOnCooldown = math.max(0, fdata.BrainFossilWaitingToGoOnCooldown - 1)
		if fdata.BrainFossilWaitingToGoOnCooldown <= 0 then
			fdata.BrainFossilCooldown = fdata.BrainFossilCooldownToSet or 0
			if TearFlagsLib.HasTearFlags(fam, TearFlagsLib.Flag.BRAIN_FOSSIL) then
				local params = TearFlagsLib.GetTearFlagParams(fam, TearFlagsLib.Flag.BRAIN_FOSSIL)
				local newColorA = lerpColor(fam.Color, params.color or fam.Color, 0.33)
				local newColorB = lerpColor(fam.Color, params.color or fam.Color, 0.66)
				local newColorC = params.color or fam.Color
				fam.Color = params.color or fam.Color

				fdata.QueuedColors = {}
				table.insert(fdata.QueuedColors, newColorA)
				table.insert(fdata.QueuedColors, newColorB)
				table.insert(fdata.QueuedColors, newColorC)
				
				if fdata.BelialActive <= 0 then
					TearFlagsLib.ClearCustomVanillaTearFlags(fam, TearFlags.TEAR_HOMING)
				end
				TearFlagsLib.ClearTearFlags(fam, TearFlagsLib.Flag.BRAIN_FOSSIL)
			end
			fdata.BrainFossilCooldownToSet = nil
			fdata.BrainFossilWaitingToGoOnCooldown = nil
		end
	end

	local twin = player:GetPlayerType() == mod.PLAYER.BRIEND and player:GetOtherTwin()
	fam.CollisionDamage = fdata.Damage
	if player:GetEffects():HasNullEffect(NullItemID.ID_SPIN_TO_WIN) or (twin and twin:GetEffects():HasNullEffect(NullItemID.ID_SPIN_TO_WIN)) then
		fam.CollisionDamage = fam.CollisionDamage * 1.5 + 6
	end
	if vanillaFlags & TearFlags.TEAR_LASERSHOT == TearFlags.TEAR_LASERSHOT then
		fam.CollisionDamage = fam.CollisionDamage / 3
	end
	local chocolateCharge = (gpdata and gpdata.ChocolateCharge) or (pdata and pdata.ChocolateCharge) or fdata.ChocolateCharge
	local proptosisMult = (vanillaFlags & TearFlags.TEAR_SHRINK == TearFlags.TEAR_SHRINK and math.max(1, 3 - roomframe / 75) / 3) or 1
	local coalMult = (vanillaFlags & TearFlags.TEAR_GROW == TearFlags.TEAR_GROW and math.min(2, 1 + roomframe / 300)) or 1
	fam.CollisionDamage = fam.CollisionDamage * chocolateCharge * proptosisMult * coalMult
	if vanillaFlags & TearFlags.TEAR_PERSISTENT == TearFlags.TEAR_PERSISTENT then
		local targetDamage = fam.CollisionDamage - (fam.CollisionDamage / 2 - 6)
		fdata.PolyphemusPenalty = math.max(0, math.min(fdata.PolyphemusPenalty or 0, targetDamage) - targetDamage / (player.MaxFireDelay * 2))
	else
		fdata.PolyphemusPenalty = 0
	end
	fdata.DamageBeforePolyphemus = fam.CollisionDamage
	fam.CollisionDamage = fam.CollisionDamage - fdata.PolyphemusPenalty
	TearFlagsLib.SetCustomVanillaTearFlagParams(fam, {
		DamageOverride = fam.CollisionDamage,
	})
	
	local hasPulseFlag = vanillaFlags & TearFlags.TEAR_PULSE == TearFlags.TEAR_PULSE
	fdata.PulseLerp = fdata.PulseLerp or ((not fdata.Initialized and hasPulseFlag and 1) or 0)
	if hasPulseFlag then
		fdata.PulseLerp = lerp(fdata.PulseLerp, 1, pulseLerpIn)
	else
		fdata.PulseLerp = lerp(fdata.PulseLerp, 0, pulseLerpOut)
	end
	local pulseMult = lerp(1, 0.5 + math.abs((fam.FrameCount % 10) - 5) * 0.12, fdata.PulseLerp)
	local scale = fdata.Scale
	if fdata.Damage ~= fam.CollisionDamage then
		scale = scale / mod:getTearParamsScale(player, fdata.Damage, vanillaFlags, true) * mod:getTearParamsScale(player, fam.CollisionDamage, vanillaFlags, true)
	end
	
	local stickAboveZero = fdata.StickTimeout and fdata.StickTimeout > 0
	fdata.StickTimeout = math.max(0, (fdata.StickTimeout or 0) - 1)
	local explodePos = stickAboveZero and fdata.StickTimeout <= 0 and fam.Position
	local stuckTo = fdata.StickTarget
	local stickMult = 1 + (fdata.StickTimeout > 0 and (1 - fdata.StickTimeout / 150) or 0)
	
	fam.Size = 7 * scale * pulseMult * stickMult
	fam:SetShadowSize(0.08 * scale * (fam.SizeMulti.X + fam.SizeMulti.Y) / 2 * pulseMult * stickMult)
	vanillaParams.ScaleOverride = scale * pulseMult * stickMult
	TearFlagsLib.SetCustomVanillaTearFlagParams(fam, {
		ScaleOverride = scale * pulseMult * stickMult,
	})
	
	updateMovement(fam, player, fdata, pdata, vanillaFlags)
	
	local color = lerpColor(fdata.CurrentColor, cyclingColor, fdata.CyclingColorStrength / 3)
	local cmult = (fdata.DarknessVelMult - darknessSpeedMult) / (1 - darknessSpeedMult)
    cmult = mod:Lerp(fdata.DarknessColourMult or cmult, cmult, darknessColourLerp)
    fdata.DarknessColourMult = cmult
    color = color * Color(cmult,cmult,cmult,math.min(1, cmult+0.3))
	mod.scheduleForUpdate(function()
		fam:SetColor(color, 1, 260, false, false)
	end, 1)
	
	if explodePos then
		if fdata.Explosivo then
			trackingIpecacDmg = {}
			game:BombExplosionEffects(explodePos, fam.CollisionDamage + 60, vanillaFlags | TearFlags.TEAR_EXPLOSIVE, color, fam, math.max(30, math.min(48 * fdata.Scale, 60)) / 75)
			fdata.Hidden = 90
			fdata.WasHidden = true
			hit = trackingIpecacDmg
			trackingIpecacDmg = nil
			
			local origPos = fam.Position
			fam.Position = explodePos
			for _, ent in ipairs(hit) do
				TearFlagsLib.CallTearFlagCallback(ent, player, fam, TearFlagsLib.WeaponFlag.FF_PLANET_X)
			end
			fam.Position = origPos
		end
		if fdata.Mucormycosis then
			game:Fart(explodePos, nil, nil, nil, nil, Color(1,1,1,1,0,0,0,0.8,0.8,2,1))
			fdata.Hidden = 90
			fdata.WasHidden = true
			
			local var = fdata.TearVariant
			if var == TearVariant.BALLOON or var == TearVariant.BALLOON_BRIMSTONE or var == TearVariant.BALLOON_BOMB then
				var = TearVariant.BLOOD
			elseif var ~= TearVariant.METALLIC then
				if mod:isBloodyTearVariant(var) then
					var = TearVariant.BLOOD
				else
					var = TearVariant.BLUE
				end
			end
	
			for i = 1, 4 do
				local vel = Vector.FromAngle(math.random() * 360):Resized(player.ShotSpeed * 10)
				local newtear = TearFlagsLib.FireSplitTear(fam, vel, player, {
					TearVariant = var,
					ScaleOverride = 1.0,
					SplitTearType = SplitTearType.SPORE,
					PositionOverride = explodePos,
				})
				newtear.Height = -23.75
				newtear.FallingSpeed = 0.1 + math.random() * 0.2
				newtear.FallingAcceleration = 0.0
				TearFlagsLib.AddTearFlags(newtear, TearFlagsLib.Flag.YIN_YANG)
				TearFlagsLib.GetTearFlagParams(newtear, TearFlagsLib.Flag.YIN_YANG, {Strength = 0.05})
				mod:GetEntityData(newtear).FFMultiEuclideanIgnoreEnemy = stuckTo.InitSeed
				mod:GetEntityData(newtear).PlanetXMucormySpawner = stuckTo
				TearFlagsLib.GetCustomVanillaTearFlagParams(newtear).ScaleOverride = nil
			end
		end
	end
	if fdata.StickTimeout <= 0 then
		fdata.Explosivo = nil
		fdata.Mucormycosis = nil
	end
	
	updateMultishotPlanets(fam, player, fdata, pdata, willRollEffects)
	updatePlanetXWNICPosMap(fam, player, fdata)
	updateCreepEffects(fam, player, fdata)
	updateStrangeAttractor(fam, player, vanillaFlags)

	updateGridEffects(fam, player, fdata, vanillaFlags)
	updateHydrobounce(fam, player, fdata, vanillaFlags)
	updatePalinopsia(fam, player, fdata)
	updateExtraTearSprites(fam, player, fdata, vanillaFlags)

	fdata.Hidden = math.max(0, (fdata.Hidden or 0) - 1)
	if fdata.Hidden <= 0 then
		if fdata.WasHidden then
			fdata.WasHidden = false
			sfx:Play(153)
		end
		fam.Visible = true
		
		if fam.FrameCount % 6 == 0 then
			if TearFlagsLib.HasTearFlags(fam, mod.FriendBulletFlags.GOLD) then
				local rng = fam:GetDropRNG()
				local sparkle = Isaac.Spawn(1000, 1727, 0, fam.Position+mod:shuntedPosition(10, rng), Vector.Zero, fam):ToEffect()
				sparkle.PositionOffset = fam.PositionOffset
				sparkle.SpriteScale = Vector(0.8, 0.8)
				sparkle:SetColor(Color(1,1,1,1,1,1,0), 100, 1, false, false)
				sparkle:Update()
			end
		end
		if fam.FrameCount % 4 == 0 then
			if vanillaFlags & TearFlags.TEAR_BURSTSPLIT == TearFlags.TEAR_BURSTSPLIT then
				local trail = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HAEMO_TRAIL, 0, fam.Position, nilvector, fam)
				trail.SpriteScale = Vector.One * (fam.Size / 7 * (0.3 + math.random() * 0.2))
				trail.PositionOffset = fam.PositionOffset
			end
		end

		local fsprite = fam:GetSprite()
		
		local anim
		if vanillaParams.ScaleOverride <= 0.3 then
			anim = "Tear1"
		elseif vanillaParams.ScaleOverride <= 0.55 then
			anim = "Tear2"
		elseif vanillaParams.ScaleOverride <= 0.675 then
			anim = "Tear3"
		elseif vanillaParams.ScaleOverride <= 0.8 then
			anim = "Tear4"
		elseif vanillaParams.ScaleOverride <= 0.925 then
			anim = "Tear5"
		elseif vanillaParams.ScaleOverride <= 1.05 then
			anim = "Tear6"
		elseif vanillaParams.ScaleOverride <= 1.175 then
			anim = "Tear7"
		elseif vanillaParams.ScaleOverride <= 1.425 then
			anim = "Tear8"
		elseif vanillaParams.ScaleOverride <= 1.675 then
			anim = "Tear9"
		elseif vanillaParams.ScaleOverride <= 1.925 then
			anim = "Tear10"
		elseif vanillaParams.ScaleOverride <= 2.175 then
			anim = "Tear11"
		elseif vanillaParams.ScaleOverride <= 2.55 then
			anim = "Tear12"
		else
			anim = "Tear13"
		end
		if isCharmed then
			anim = "Charmed" .. anim
		elseif fdata.TearVariant == TearVariant.BALLOON or fdata.TearVariant == TearVariant.BALLOON_BRIMSTONE or fdata.TearVariant == TearVariant.BALLOON_BOMB then
			anim = "Balloon" .. anim
		elseif fdata.TearVariant == TearVariant.METALLIC then
			anim = "Metallic" .. anim
		elseif mod:isBloodyTearVariant(fdata.TearVariant) then
			anim = "Blood" .. anim
		else
			anim = "Regular" .. anim
		end

		if not fsprite:IsPlaying(anim) then
			local frame = fsprite:GetFrame()
			fsprite:Play(anim, true)
			fsprite:SetFrame(frame)
		end

		local spritescale = getSpriteScale(vanillaParams.ScaleOverride, fam.SizeMulti, vanillaFlags)
		local layer = fsprite:GetLayer(0)
		if layer then
			layer:SetSize(spritescale)
		end
		table.insert(planetsToRescale, fam)
		mod:EnableManualCallback(ModCallbacks.MC_POST_UPDATE, mod.RescalePlanetX)
		
		if TearFlagsLib.HasTearFlags(fam, TearFlagsLib.Flag.STRANGE_MATTER) then
			mod:spawnStrangeTrail(fam.Position, fam, vanillaParams.ScaleOverride)
		end
	else
		fam.Visible = false
	end

	for i = #fdata.PastCollisions, 1, -1 do
		local collision = fdata.PastCollisions[i]
		collision.Interval = collision.Interval - 1
		if collision.Interval <= 0 then
			table.remove(fdata.PastCollisions, i)
		end
	end

	fdata.Initialized = true
end

local function updateBasePlanet(fam, player, fdata)
	local frame = game:GetFrameCount()
	if fdata.LastFrameUpdated == frame or fdata.warHornParams then
		return
	end
	fdata.LastFrameUpdated = frame

	local player = (fdata.Owner and fdata.Owner:Exists() and fdata.Owner) or player
	local isCharmed = fam:IsCharmed()
	if isCharmed then 
		player = fam.Player
	end

	fdata.ExtraOrbitals = fdata.ExtraOrbitals or {}

	local numExtraOrbitals = math.max(0, player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.PLANET_X) +
	                                     player:GetEffects():GetCollectibleEffectNum(mod.ITEM.COLLECTIBLE.PLANET_X) - 1)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
		numExtraOrbitals = numExtraOrbitals + soyMilkExtraTears
	end
	numExtraOrbitals = math.min(numExtraOrbitals, extraOrbitalsCap)

	local numExtraChanged = false
	for i = #fdata.ExtraOrbitals, 1, -1 do
		if not fdata.ExtraOrbitals[i]:Exists() then
			table.remove(fdata.ExtraOrbitals, i)
			numExtraChanged = true
		end
	end
	while numExtraOrbitals > #fdata.ExtraOrbitals do
		local extraOrbital = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.PLANET_X, PlanetXSubtype.EXTRA, player.Position, nilvector, fam):ToFamiliar()
		extraOrbital:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		extraOrbital.Parent = fam
		extraOrbital.Player = fam.Player
		mod:GetEntityData(extraOrbital).Owner = mod:GetEntityData(fam).Owner
		table.insert(fdata.ExtraOrbitals, extraOrbital)
		numExtraChanged = true
	end
	while numExtraOrbitals < #fdata.ExtraOrbitals do
		local extraOrbital = fdata.ExtraOrbitals[#fdata.ExtraOrbitals]
		table.remove(fdata.ExtraOrbitals, #fdata.ExtraOrbitals)
		if extraOrbital:Exists() then
			spawnSplat(extraOrbital)
			extraOrbital:Remove()
		end
		numExtraChanged = true
	end

	if numExtraChanged then
		for i = 1, #fdata.ExtraOrbitals do
			local extraOrbital = fdata.ExtraOrbitals[i]
			local edata = mod:GetEntityData(extraOrbital)
			edata.ExtraOrbitalMult = i / (#fdata.ExtraOrbitals + 1)
			edata.SmoothingToOrbit = edata.SmoothingToOrbit or extraOrbital.FrameCount ~= 0
		end
	end

	local willRollEffects = false
	if fdata.FireDelay == nil then
		fdata.FireDelay = fdata.FireDelay or 0
	end
	if numExtraChanged or isCharmed ~= fdata.WasCharmed then
		fdata.FireDelay = player.MaxFireDelay * refreshRateFactor
		willRollEffects = true
	end
	if fdata.FireDelay <= 0 then
		local forgottenLullabyMult = (player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) and 0.5) or 1
		local refreshRate = math.max(minRefreshRate, player.MaxFireDelay * refreshRateFactor * forgottenLullabyMult)
		while fdata.FireDelay <= 0 do
			fdata.FireDelay = fdata.FireDelay + refreshRate
		end
		willRollEffects = true
	end
	fdata.FireDelay = fdata.FireDelay - 1
	
	local hasChocolateMilk = player:HasCollectible(CollectibleType.COLLECTIBLE_CHOCOLATE_MILK)
	local hasCursedEye = player:HasCollectible(CollectibleType.COLLECTIBLE_CURSED_EYE)
	local fireDelay = player.MaxFireDelay
	if hasChocolateMilk then
		fireDelay = fireDelay * 2.5 + 1.5
	end
	if hasCursedEye then
		fireDelay = fireDelay * 2 + 1
	end
	fireDelay = fireDelay * refreshRateFactor
	fdata.ChocolateCharge = fdata.ChocolateCharge or ((not fdata.Initialized and hasChocolateMilk and 0.1) or 1)
	fdata.CursedCharge = fdata.CursedCharge or 0
	local fireDirection = player:GetFireDirection()
	if hasChocolateMilk then
		if fireDirection == Direction.NO_DIRECTION then
			fdata.ChocolateCharge = math.max(0.1, fdata.ChocolateCharge - 1.3)
		else
			fdata.ChocolateCharge = math.min(4, fdata.ChocolateCharge + 3.9 / fireDelay)
		end
	else
		if fdata.ChocolateCharge > 1 then
			fdata.ChocolateCharge = math.max(1, fdata.ChocolateCharge - 1.3)
		elseif fdata.ChocolateCharge < 1 then
			fdata.ChocolateCharge = math.min(1, fdata.ChocolateCharge + 0.39)
		end
	end
	if hasCursedEye then
		if fireDirection == Direction.NO_DIRECTION then
			fdata.CursedCharge = 0
		else
			fdata.CursedCharge = math.min(4, fdata.CursedCharge + 4 / fireDelay)
		end
	else
		fdata.CursedCharge = 0
	end
	if isCharmed then
		fdata.ChocolateCharge = 1
		fdata.CursedCharge = 0
	end

	mod:updatePlanetX(fam, player, fdata, nil, nil, willRollEffects)
	for i = 1, #fdata.ExtraOrbitals do
		local extraOrbital = fdata.ExtraOrbitals[i]
		local cdata = mod:GetEntityData(extraOrbital)
		mod:updatePlanetX(extraOrbital, player, cdata, fdata, nil, willRollEffects)
		if extraOrbital.FrameCount == 0 then
			extraOrbital:Update()
		end
	end
	fdata.WasCharmed = isCharmed
end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, fam)
	local player = fam.Player
	local fdata = mod:GetEntityData(fam)

	if fam.SubType == PlanetXSubtype.BASE then
		updateBasePlanet(fam, player, fdata)
	elseif not (fam.Parent and fam.Parent:Exists()) then
		spawnSplat(fam)
		fam:Remove()
	end
end, mod.ITEM.FAMILIAR.PLANET_X)

function mod:markPlanetXToRevaluateCache(player, flag)
	if flag == CacheFlag.CACHE_RANGE then
		for _, fam in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.PLANET_X)) do
			local fam = fam:ToFamiliar()
			local fdata = mod:GetEntityData(fam)
			local owner = (fdata.Owner and fdata.Owner:Exists() and fdata.Owner) or player
			local isCharmed = fam:IsCharmed()
			if isCharmed then 
				owner = fam.Player
			end
			if owner and owner.Index == player.Index and owner.InitSeed == player.InitSeed then
				local fdata = mod:GetEntityData(fam)
				fdata.CachedTrinityWormItem = nil
				fdata.CachedTanWormItem = nil
				fdata.CachedTinyPlanetItem = nil
				fdata.CachedMyReflectionItem = nil
			end
		end
	elseif flag == CacheFlag.CACHE_SHOTSPEED then
		for _, fam in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.PLANET_X)) do
			local fam = fam:ToFamiliar()
			local fdata = mod:GetEntityData(fam)
			local owner = (fdata.Owner and fdata.Owner:Exists() and fdata.Owner) or player
			local isCharmed = fam:IsCharmed()
			if isCharmed then 
				owner = fam.Player
			end
			if owner and owner.Index == player.Index and owner.InitSeed == player.InitSeed then
				local fdata = mod:GetEntityData(fam)
				fdata.CachedMyReflectionItem = nil
			end
		end
	end
end
mod:AddEntityCallback(ModCallbacks.MC_EVALUATE_CACHE, EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.PLANET_X, 0, mod.markPlanetXToRevaluateCache)

function mod:planetXFamiliarCache(player, basedata)
	local count = 0
	local needToAssignTo = {}
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.PLANET_X) then
		count = count + 1
		needToAssignTo[GetPtrHash(player)] = player
	end
	if player:GetPlayerType() == mod.PLAYER.BRIEND then
		local twin = player:GetOtherTwin()
		if twin and twin:HasCollectible(mod.ITEM.COLLECTIBLE.PLANET_X) then
			count = count + 1
			needToAssignTo[GetPtrHash(twin)] = twin
		end
	end
	
	local origPlayer = player
	if mod:IsBriendTwin(player) then
		player = player:GetMainTwin()
	end

	local planetsToCheck = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.PLANET_X, PlanetXSubtype.BASE)
	for _, fam in ipairs(planetsToCheck) do
		local fam = fam:ToFamiliar()
		if fam.Player and GetPtrHash(fam.Player) then
			local fdata = mod:GetEntityData(fam)
			if fdata.Owner and not needToAssignTo[GetPtrHash(fdata.Owner)] then
				spawnSplat(fam)
				fam:Remove()
			end
		end
	end
	player:CheckFamiliar(mod.ITEM.FAMILIAR.PLANET_X,
	                     count,
	                     player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.PLANET_X),
	                     Isaac.GetItemConfig():GetCollectible(mod.ITEM.COLLECTIBLE.PLANET_X),
	                     PlanetXSubtype.BASE)

	if count > 0 then
		local planetsToAssign = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.PLANET_X, PlanetXSubtype.BASE)
		local firstAssignedPlanet = nil
		for _, fam in ipairs(planetsToAssign) do
			local fdata = mod:GetEntityData(fam)
			if fdata.Initialized and fdata.Owner and needToAssignTo[GetPtrHash(fdata.Owner)] then
				firstAssignedPlanet = fam
			end
		end
		for _, fam in ipairs(planetsToAssign) do
			local fdata = mod:GetEntityData(fam)
			if not fdata.Initialized then
				if not (fdata.Owner and needToAssignTo[GetPtrHash(fdata.Owner)]) then
					for _, player in pairs(needToAssignTo) do
						fdata.Owner = player
						break
					end
				end
				if fdata.Owner then needToAssignTo[GetPtrHash(fdata.Owner)] = nil end
				
				if not firstAssignedPlanet then
					firstAssignedPlanet = fam
				else
					local odata = mod:GetEntityData(firstAssignedPlanet)
					local frameOffset = math.min(3, firstAssignedPlanet.FrameCount)
					mod.scheduleForUpdate(function()
						fdata.OrbitAngle = ((odata.OrbitAngle or 0) + 180 + frameOffset * (odata.AngleRate or 0)) % 360
						fdata.TrinityAngle = ((odata.TrinityAngle or 0) + 540 + frameOffset * (odata.AngleRate or 0)) % 1080
					end, 1)
				end
				
				local fam = fam:ToFamiliar()
				mod.scheduleForUpdate(function()
					updateBasePlanet(fam, fam.Player, fdata)
				end, 1)
			end
		end
	end
end

mod:AddPriorityCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, math.huge, function(_, fam, col)
    local fdata = mod:GetEntityData(fam)
	if (fdata.Hidden or 0) > 0 then
		return true
	elseif not fdata.DarknessPhase then
		return true
	elseif col.Type == EntityType.ENTITY_PROJECTILE then
		local vanillaFlags = TearFlagsLib.GetCustomVanillaTearFlags(fam)
        if vanillaFlags & TearFlags.TEAR_SHIELDED ~= TearFlags.TEAR_SHIELDED or mod:isSirenCharmed(fam) then
			return
		end

        local proj = col:ToProjectile()
		if proj:HasProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER) then
			return true
		end
		proj:Die()
	elseif col.Type > 9 and col.Type < 1000 then
		if (col:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) and col.Type ~= EntityType.ENTITY_FIREPLACE) or mod:isSirenCharmed(fam) then
			return
		end

		fdata.PastCollisions = fdata.PastCollisions or {}
		for _, interval in ipairs(fdata.PastCollisions) do
			if interval.Index == col.Index and interval.InitSeed == col.InitSeed then
				return true
			end
		end
		
		local fam = fam:ToFamiliar()
		local player = (fdata.Owner and fdata.Owner:Exists() and fdata.Owner) or fam.Player
		local isCharmed = fam:IsCharmed()
		if isCharmed then 
			player = fam.Player
		end
		
		local vanillaFlags = TearFlagsLib.GetCustomVanillaTearFlags(fam)
		local origVanillaFlags = vanillaFlags
		if vanillaFlags & TearFlags.TEAR_BELIAL == TearFlags.TEAR_BELIAL then
			fdata.BelialActive = fdata.CollisionInterval + 1
			
			local hasHomingFlag = vanillaFlags & TearFlags.TEAR_HOMING == TearFlags.TEAR_HOMING or
			                      TearFlagsLib.HasTearFlags(fam, TearFlagsLib.Flag.BULLET_ETERNAL) or
			                      TearFlagsLib.HasTearFlags(fam, TearFlagsLib.Flag.YIN_YANG)
			if not hasHomingFlag then
				TearFlagsLib.AddCustomVanillaTearFlags(fam, TearFlags.TEAR_HOMING)
				fdata.BelialAddedHoming = true
			end
		end
		if TearFlagsLib.HasTearFlags(fam, TearFlagsLib.Flag.BRAIN_FOSSIL) then
			local params = TearFlagsLib.GetTearFlagParams(fam, TearFlagsLib.Flag.BRAIN_FOSSIL)
			fdata.BrainFossilWaitingToGoOnCooldown = fdata.CollisionInterval + 1
			fdata.BrainFossilCooldownToSet = params.cooldown
		end
		if TearFlagsLib.HasTearFlags(fam, quantumflag) then
			if not fdata.ForcedQuantumUniverse then
				for i = 1, fdata.LastNumUniverses or 1 do
					if i ~= fdata.CurrentQuantumUniverse then
						local pos = fdata.QuantumUniversePositions[i] or fam.Position
						for j=1,7 do
							local ember = Isaac.Spawn(1000,66,0, pos+fam.PositionOffset, RandomVector()*math.random(10,45)/10, nil):ToEffect()
							ember.Color = Color(math.random(255)/255,math.random(255)/255,math.random(255)/255,1,0,0,0)
							ember.Scale = math.random(50,100)/100
							ember:SetTimeout(5)
							ember:Update()
						end
					end
				end
				fdata.ForcedQuantumUniverse = fdata.CurrentQuantumUniverse
			end
			fdata.ForcedQuantumUniverseFrames = fdata.CollisionInterval + 1
		end
		
		if fdata.Explosivo or fdata.Mucormycosis then
			return false
		end
		
		if vanillaFlags & TearFlags.TEAR_PERSISTENT == TearFlags.TEAR_PERSISTENT then
			fdata.PolyphemusPenalty = fdata.PolyphemusPenalty + math.min(col.HitPoints, fdata.DamageBeforePolyphemus)
		end
		
		local frame = game:GetFrameCount()
		if fdata.HasHitThisRoll then
			vanillaFlags = vanillaFlags & ~oncePerRollBasegameFlags
		end
		if frame == fdata.LastFrameHit then
			vanillaFlags = vanillaFlags & ~oncePerFrameBasegameFlags
		end
		for _, pastCol in ipairs(fdata.PastCollisionsThisRoll) do
			if pastCol.Index == col.Index and pastCol.InitSeed == col.InitSeed then
				vanillaFlags = vanillaFlags & ~oncePerEnemyBasegameFlags
				break
			end
		end
		for flag, cooldown in pairs(fdata.BasegameTearflagCooldowns) do
			vanillaFlags = vanillaFlags & ~flag
		end
		if col.Type == EntityType.ENTITY_FIREPLACE then
			vanillaFlags = vanillaFlags & ~TearFlags.TEAR_EXPLOSIVE
		end
		local hasExplosive = vanillaFlags & TearFlags.TEAR_EXPLOSIVE == TearFlags.TEAR_EXPLOSIVE
		local vanillaParams = TearFlagsLib.GetCustomVanillaTearFlagParams(fam)
		local vel = fam.Position - player.Position
		if vanillaFlags & TearFlags.TEAR_PUNCH == TearFlags.TEAR_PUNCH then
			vel = vel:Resized(player.ShotSpeed * 10)
		else
			vel = vel:Resized(0.000001)
			if vanillaFlags & TearFlags.TEAR_KNOCKBACK == TearFlags.TEAR_KNOCKBACK then
				mod:applyFakeKnockbackFlag(col, player, fam, TearFlagsLib.WeaponFlag.FF_PLANET_X)
			end
		end
		vanillaParams.VelocityOverride = vel
		if hasExplosive then
			trackingIpecacDmg = {}
		end
		TearFlagsLib.ApplyVanillaTearFlagEffectsToEntity(col, vanillaFlags, player, fam, vanillaParams)
		vanillaParams.VelocityOverride = nil
		local hit = trackingIpecacDmg
		trackingIpecacDmg = nil
		if not hasExplosive then
			local damageFlags = 0
			if vanillaFlags & TearFlags.TEAR_MULLIGAN == TearFlags.TEAR_MULLIGAN then
				damageFlags = damageFlags | DamageFlag.DAMAGE_SPAWN_FLY
			end
			if vanillaFlags & TearFlags.TEAR_EXPLOSIVE == TearFlags.TEAR_EXPLOSIVE then
				damageFlags = damageFlags | DamageFlag.DAMAGE_EXPLOSION
			end
			if vanillaFlags & TearFlags.TEAR_HP_DROP == TearFlags.TEAR_HP_DROP then
				if player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_GIMPY):RandomFloat() < 1/3 then
					damageFlags = damageFlags | DamageFlag.DAMAGE_SPAWN_RED_HEART
				end
			end
			if vanillaFlags & TearFlags.TEAR_ROCK == TearFlags.TEAR_ROCK then
				damageFlags = damageFlags | DamageFlag.DAMAGE_CRUSH
			end
			if vanillaFlags & TearFlags.TEAR_COIN_DROP_DEATH == TearFlags.TEAR_COIN_DROP_DEATH then
				damageFlags = damageFlags | DamageFlag.DAMAGE_SPAWN_COIN
			end
			if vanillaFlags & TearFlags.TEAR_CARD_DROP_DEATH == TearFlags.TEAR_CARD_DROP_DEATH then
				damageFlags = damageFlags | DamageFlag.DAMAGE_SPAWN_CARD
			end
			if vanillaFlags & TearFlags.TEAR_RUNE_DROP_DEATH == TearFlags.TEAR_RUNE_DROP_DEATH then
				damageFlags = damageFlags | DamageFlag.DAMAGE_SPAWN_RUNE
			end
			TearFlagsLib.DamageEntity(col, fam.CollisionDamage, damageFlags, fam, {IgnoreVanillaDamageFlags = true})
			hit = {}
		end
		table.insert(hit, col)
		local interval = fdata.CollisionInterval
		for _, ent in ipairs(hit or {}) do
			TearFlagsLib.CallTearFlagCallback(ent, player, fam, TearFlagsLib.WeaponFlag.FF_PLANET_X)
			local segments = {ent}
			if mod:isSegmented(ent) and not mod:isReducedSyncSegment(ent) then
				segments = mod:getSegments(ent)
			elseif mod:isBasegameSegmented(ent) and not mod:isBasegameReducedSyncSegment(ent) then
				segments = mod:getBasegameSegments(ent)
			end
			
			for _, segment in ipairs(segments) do
				table.insert(fdata.PastCollisions, {Index = segment.Index,
				                                    InitSeed = segment.InitSeed,
				                                    Interval = interval})
				table.insert(fdata.PastCollisionsThisRoll, {Index = segment.Index,
				                                            InitSeed = segment.InitSeed})
			end
		end
		doBasegameSplittingEffects(fam, player, fdata, vanillaFlags)
		for _, flag in ipairs(oncePerRefreshBasegameFlags) do
			if fdata.BasegameTearflagCooldowns[flag] == nil then
				fdata.BasegameTearflagCooldowns[flag] = player.MaxFireDelay
			end
		end
		if not fdata.StickTarget and origVanillaFlags & (TearFlags.TEAR_BOOGER | TearFlags.TEAR_STICKY | TearFlags.TEAR_SPORE) ~= TearFlags.TEAR_NORMAL then
			fdata.StickTarget = col
			fdata.StickTargetOffset = fam.Position - col.Position
			fdata.StickTimeout = 150
			fam.Velocity = col.Velocity
			fdata.Explosivo = origVanillaFlags & TearFlags.TEAR_STICKY ~= TearFlags.TEAR_NORMAL
			fdata.Mucormycosis = origVanillaFlags & TearFlags.TEAR_SPORE ~= TearFlags.TEAR_NORMAL
		end
		fdata.HasHitThisRoll = true
		fdata.LastFrameHit = frame
		return false
    end
end, mod.ITEM.FAMILIAR.PLANET_X)

mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, function(_, entity, player, source, weaponFlag)
	if weaponFlag ~= TearFlagsLib.WeaponFlag.FF_PLANET_X then return end
	local fam = source
	local fdata = mod:GetEntityData(fam)
	local currentUniverse = fdata.CurrentQuantumUniverse
	mod.scheduleForUpdate(function()
		if fdata.LastNumUniverses and not fdata.ForcedQuantumUniverse then
			for i = 1, fdata.LastNumUniverses or 1 do
				if i ~= currentUniverse then
					local pos = fdata.QuantumUniversePositions[i] or fam.Position
					for j=1,7 do
						local ember = Isaac.Spawn(1000,66,0, pos+fam.PositionOffset, RandomVector()*math.random(10,45)/10, nil):ToEffect()
						ember.Color = Color(math.random(255)/255,math.random(255)/255,math.random(255)/255,1,0,0,0)
						ember.Scale = math.random(50,100)/100
						ember:SetTimeout(5)
						ember:Update()
					end
				end
			end
			fdata.ForcedQuantumUniverse = currentUniverse
		end
		fdata.ForcedQuantumUniverseFrames = fdata.CollisionInterval + 1
	end, 1)
end, quantumflag)

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, function(_, entity, amount, flags, source, countdown)
	if trackingIpecacDmg then
		table.insert(trackingIpecacDmg, entity)
	end
end)

mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, function(_, tear, entity)
    local tdata = mod:GetEntityData(tear)
    if tear.FrameCount <= 5 and tdata.PlanetXMucormySpawner then
		if tdata.PlanetXMucormySpawner.InitSeed == entity.InitSeed then
			return true
        end
    end
end)

mod:AddEntityCallback(ModCallbacks.MC_POST_NEW_ROOM, EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.PLANET_X, nil, function()
	local initWNIC = false
	for _, fam in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.PLANET_X)) do
		local fam = fam:ToFamiliar()
		local fdata = mod:GetEntityData(fam)
		fdata.PastCollisions = {}
		local player = (fdata.Owner and fdata.Owner:Exists() and fdata.Owner) or fam.Player
		local isCharmed = fam:IsCharmed()
		if isCharmed then 
			player = fam.Player
		end
		fdata.LastFrameUpdated = nil
		fdata.PostNewRoomReset = true
		fdata.LastOrigin = player.Position + (fdata.LastOriginOffset or nilvector)
		fdata.StickTarget = nil
		fdata.StickTargetOffset = nil

		if TearFlagsLib.HasTearFlags(fam, TearFlagsLib.Flag.WNIC) then
			mod:addPlanetXToConnectors(fam, player)
			initWNIC = true
		end
	end
	for _, fam in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.PLANET_X, PlanetXSubtype.BASE)) do
		local fam = fam:ToFamiliar()
		local fdata = mod:GetEntityData(fam)
		local player = fam.Player
		updateBasePlanet(fam, player, fdata)
	end
	mod:handleQuantumPlanetXRendering()

	if initWNIC then
		mod:updateEveryPingTear()
	end
end)

function mod:RescalePlanetX()
	for _, fam in ipairs(planetsToRescale) do
		fam.SpriteScale = Vector.One
	end
	planetsToRescale = {}
	mod:DisableManualCallback(ModCallbacks.MC_POST_UPDATE, mod.RescalePlanetX)
end
mod:AddManualCallback(ModCallbacks.MC_POST_UPDATE, mod.RescalePlanetX)

local planetXPositionsToRender = {}
local planetsToDequantify = {}
local forcingRender = false
mod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_RENDER, function(_, fam, offset)
	if planetsToDequantify[GetPtrHash(fam)] and not forcingRender then
		return false
	end

	local fdata = mod:GetEntityData(fam)
	
	local halosprite = fdata.GodheadHaloSprite
	if halosprite and halosprite.Color.A > 0 then
		local scale = fam.Size / 7 * 0.45
		if fdata.RenderingQuantum then
			halosprite:GetLayer(0):SetColor(Color(1,1,1,0.5))
		else
			halosprite:GetLayer(0):SetColor(Color())
		end
		halosprite.Scale = Vector(scale, scale)
		halosprite:Render(Isaac.WorldToRenderPosition(fam.Position + fam.PositionOffset) + offset)
	end
	
	local darkmattersprite = fdata.DarkMatterSprite
	if darkmattersprite and darkmattersprite.Color.A > 0 then
		local scale = fam.Size / 7 * 0.45
		darkmattersprite.Scale = Vector(scale, scale)
		if fdata.RenderingQuantum then
			darkmattersprite:GetLayer(0):SetColor(Color(1,1,1,0.5))
		else
			darkmattersprite:GetLayer(0):SetColor(Color())
		end
		darkmattersprite.Rotation = fam.Velocity:GetAngleDegrees()
		darkmattersprite:Render(Isaac.WorldToRenderPosition(fam.Position + fam.PositionOffset) + offset)
	end
	
	local firemindsprite = fdata.FireMindSprite
	if firemindsprite and firemindsprite.Color.A > 0 then
		local scale = fam.Size / 7 * 0.45
		firemindsprite.Scale = Vector(scale, scale)
		if fdata.RenderingQuantum then
			firemindsprite:GetLayer(0):SetColor(Color(1,1,1,0.5))
		else
			firemindsprite:GetLayer(0):SetColor(Color())
		end
		firemindsprite.Rotation = fam.Velocity:GetAngleDegrees()
		firemindsprite:Render(Isaac.WorldToRenderPosition(fam.Position + fam.PositionOffset) + offset)
	end
	
	local mysteriousliquidsprite = fdata.MysteriousLiquidSprite
	if mysteriousliquidsprite and mysteriousliquidsprite.Color.A > 0 then
		local scale = fam.Size / 7 * 0.45
		mysteriousliquidsprite.Scale = Vector(scale, scale)
		if fdata.RenderingQuantum then
			mysteriousliquidsprite:GetLayer(0):SetColor(Color(1,1,1,0.5))
		else
			mysteriousliquidsprite:GetLayer(0):SetColor(Color())
		end
		mysteriousliquidsprite.Rotation = fam.Velocity:GetAngleDegrees()
		mysteriousliquidsprite:Render(Isaac.WorldToRenderPosition(fam.Position + fam.PositionOffset) + offset)
	end
end, mod.ITEM.FAMILIAR.PLANET_X)

mod:AddCallback(ModCallbacks.MC_POST_FAMILIAR_RENDER, function(_, fam, offset)
	local fdata = mod:GetEntityData(fam)
	
	local jacobsladdersprite = fdata.JacobsLadderSprite
	if jacobsladdersprite and jacobsladdersprite.Color.A > 0 then
		local scale = fam.Size / 7 * 0.45
		jacobsladdersprite.Scale = Vector(scale, scale)
		if fdata.RenderingQuantum then
			jacobsladdersprite:GetLayer(0):SetColor(Color(1,1,1,0.5))
		else
			jacobsladdersprite:GetLayer(0):SetColor(Color())
		end
		jacobsladdersprite:Render(Isaac.WorldToRenderPosition(fam.Position + fam.PositionOffset) + offset)
	end
	
	local holylightsprite = fdata.HolyLightSprite
	if holylightsprite and holylightsprite.Color.A > 0 then
		local scale = fam.Size / 7 * 0.45
		holylightsprite.Scale = Vector(scale, scale)
		if fdata.RenderingQuantum then
			holylightsprite:GetLayer(0):SetColor(Color(1,1,1,0.5))
		else
			holylightsprite:GetLayer(0):SetColor(Color())
		end
		holylightsprite:Render(Isaac.WorldToRenderPosition(fam.Position + fam.PositionOffset) + offset)
	end
	
	local littlehornsprite = fdata.LittleHornSprite
	if littlehornsprite and littlehornsprite.Color.A > 0 then
		local scale = fam.Size / 7 * 0.45
		littlehornsprite.Scale = Vector(scale, scale)
		if fdata.RenderingQuantum then
			littlehornsprite:GetLayer(0):SetColor(Color(1,1,1,0.5))
		else
			littlehornsprite:GetLayer(0):SetColor(Color())
		end
		littlehornsprite:Render(Isaac.WorldToRenderPosition(fam.Position + fam.PositionOffset) + offset)
	end
	
	local deadeyesprite = fdata.DeadEyeSprite
	if deadeyesprite and deadeyesprite.Color.A > 0 then
		local scale = fam.Size / 7 * 0.45
		deadeyesprite.Scale = Vector(scale, scale)
		if fdata.RenderingQuantum then
			deadeyesprite:GetLayer(0):SetColor(Color(1,1,1,0.5))
		else
			deadeyesprite:GetLayer(0):SetColor(Color())
		end
		deadeyesprite:Render(Isaac.WorldToRenderPosition(fam.Position + fam.PositionOffset) + offset)
	end
end, mod.ITEM.FAMILIAR.PLANET_X)

function mod:handleQuantumPlanetXRendering()
	for _, famInfo in pairs(planetsToDequantify) do
		if famInfo.Fam and famInfo.Fam:Exists() then
			famInfo.Fam.Visible = true
			if famInfo.ShadowSize then
				famInfo.Fam:SetShadowSize(famInfo.ShadowSize)
			end
		end
	end
	planetsToDequantify = {}

	planetXPositionsToRender = {}
	for _, fam in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.PLANET_X)) do
		if TearFlagsLib.HasTearFlags(fam, quantumflag) and fam.Visible then
			local fdata = mod:GetEntityData(fam)
			if fdata.LastNumUniverses and fdata.ForcedQuantumUniverse == nil and fdata.StickTarget == nil then
				local shadowsize = fam:GetShadowSize()
				for i = 1, fdata.LastNumUniverses or 1 do
					local pos = fdata.QuantumUniversePositions[i] or fam.Position
					local vel = fdata.QuantumUniverseVelocities[i] or fam.Velocity
					local index = nil
					for j = 1, #planetXPositionsToRender do
						if pos.X < planetXPositionsToRender[j].Pos.X then
							index = j
							break
						end
					end
					table.insert(planetXPositionsToRender, index or i, {Fam = fam, Pos = pos, Vel = vel})
				end
				planetsToDequantify[GetPtrHash(fam)] = {Fam = fam, ShadowSize = shadowsize}
				fam:SetShadowSize(0)
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_RENDER, mod.handleQuantumPlanetXRendering)

mod:AddCallback(ModCallbacks.MC_POST_ROOM_RENDER_ENTITIES, function()
	local renderframe = Isaac.GetFrameCount()
	local frame = (game:GetFrameCount() * 2) + (game:IsPaused() and 1 or renderframe % 2)
	local offset = game:GetRoom():GetRenderScrollOffset()
	for i = 1, #planetXPositionsToRender do
		local famInfo = planetXPositionsToRender[i]
		local fam = famInfo.Fam
		local pos, vel = fam.Position, fam.Velocity
		local data = mod:GetEntityData(fam)
		local sprite = fam:GetSprite()
		local layer = sprite:GetLayer(0)

		fam.Position = famInfo.Pos + ((frame % 2 == 0 and (famInfo.Vel * 0.5)) or nilvector)
		fam.Velocity = famInfo.Vel
		data.RenderingQuantum = true
		layer:SetColor(Color(1,1,1,0.5))

		forcingRender = true
		fam:Render(offset)
		forcingRender = false

		fam.Position = pos
		fam.Velocity = vel
		data.RenderingQuantum = false
		layer:SetColor(Color())
	end
end)