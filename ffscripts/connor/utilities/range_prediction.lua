local mod = FiendFolio

-- Some code for predicting the range of tears and projectiles.
-- The bulk of the prediction is based on how the game actually updates the FallingSpeed/Height every frame.
-- Unfortunately I have not figured out how to perform the necessary calculation without a loop
-- (if it is even possible to do so given the nature of the math involved).
--
-- FallingSpeed(t) = (FallingAccel + 0.1) + 0.9 * FallingSpeed(t-1)
-- Height(t) = StartingHeight + FallingSpeed(0) + FallingSpeed(1) + FallingSpeed(2) + ... + FallingSpeed(t)

-- Don't predict over a minute into the future, because come on...
local MAX_PREDICTION_FRAMES = 30 * 60

-- Tears and Projectiles are affected by a random deviation to their initial FallingSpeed, from 0.0 to 0.2
-- Note that this only applies to tears and projectiles fired "naturally" or via FireTear/FireProjectile(s), not manually-spawned ones.
-- For predictive purposes I use 0.1, the average.
local AVG_INITIAL_FALLINGSPEED_DEVIATION = 0.1

local function PredictFallFramesInternal(height, heightToHitGround, fallingSpeed, fallingAccel)
	if fallingAccel <= -0.1 then
		-- It's not ever going to fall.
		return -1
	end
	
	local t = 0
	while height < heightToHitGround do
		fallingSpeed = (fallingAccel + 0.1) + 0.9 * fallingSpeed
		height = height + fallingSpeed
		if t >= MAX_PREDICTION_FRAMES then
			return t
		end
		t = t + 1
	end
	return t
end

-- Predicts how many more frames will pass before the tear hits the ground.
function mod:PredictFramesUntilTearHitsGround(height, fallingSpeed, fallingAccel)
	return PredictFallFramesInternal(height, -5, fallingSpeed, fallingAccel)
end

-- Predicts how many more frames will pass before the projectile hits the ground.
function mod:PredictFramesUntilProjectileHitsGround(height, fallingSpeed, fallingAccel)
	return PredictFallFramesInternal(height, 0, fallingSpeed, fallingAccel)
end

-- Predicts how much further the tear will travel before hitting the ground.
function mod:PredictTearRange(height, fallingSpeed, fallingAccel, speed)
	return mod:PredictFramesUntilTearHitsGround(height, fallingSpeed, fallingAccel) * speed
end

-- Predicts how much further the projectile will travel before hitting the ground.
function mod:PredictProjectileRange(height, fallingSpeed, fallingAccel, speed)
	return mod:PredictFramesUntilProjectileHitsGround(height, fallingSpeed, fallingAccel) * speed
end

-- Predicts how far a tear will go based on player stats.
-- For the player's CURRENT stats you can just check `player.TearRange`.
function mod:PredictTearRangeFromPlayerStats(tearHeightStat, tearFallingSpeedStat, tearFallingAccelStat, shotSpeedStat)
	-- For some reason the player's TearFallingSpeed stat is the inverse of the actual value used for the initial FallingSpeed of the tear.
	local initialFallingSpeed = AVG_INITIAL_FALLINGSPEED_DEVIATION - tearFallingSpeedStat
	return mod:PredictTearRange(tearHeightStat, initialFallingSpeed, tearFallingAccelStat, shotSpeedStat * 10)
end

-- Predicts how far a projectile will go based on ProjectileParams.
function mod:PredictProjectileRangeFromParams(projParams, projSpeed)
	local initialFallingSpeed = projParams.FallingSpeedModifier + 0.1 - AVG_INITIAL_FALLINGSPEED_DEVIATION
	return mod:PredictProjectileRange(projParams.HeightModifier - 23, initialFallingSpeed, projParams.FallingAccelModifier, projSpeed)
end
