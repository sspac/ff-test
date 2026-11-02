local mod = FiendFolio
local game = Game()

-- Contains some re-impementations / potential customizations of MultiShot logic.
-- With REPENTOGON we have access to proper MultiShotParams, but I liked making this to avoid that
-- dependency for now, and potentially to allow for some more control over the specifics.
-- Note that I don't roll for or apply the Bookworm effect anywhere here.

local function GetCount(player, id, includeCollectibleEffect)
	local count = player:GetCollectibleNum(id)
	if includeCollectibleEffect and player:GetEffects():HasCollectibleEffect(id) then
		-- Inner Eye, 2020, and Wiz's CollectibleEffects grant one stack of their effects at most.
		count = count + 1
	end
	return count
end

local function GetMutantSpiderCount(player)
	-- Mutant Spider's CollectibleEffect does not grant the effect.
	local count = GetCount(player, CollectibleType.COLLECTIBLE_MUTANT_SPIDER, false)
	if player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B then
		count = count + 1
	end
	return count
end

local function GetInnerEyeCount(player)
	local count = GetCount(player, CollectibleType.COLLECTIBLE_INNER_EYE, true)
	if player:GetPlayerType() == PlayerType.PLAYER_KEEPER then
		count = count + 1
	end
	return count
end

local function Get2020Count(player)
	return GetCount(player, CollectibleType.COLLECTIBLE_20_20, true)
end

local function GetWizCount(player)
	return GetCount(player, CollectibleType.COLLECTIBLE_THE_WIZ, true)
end

-- Returns the # of tears that the player would fire, not counting for the "balancing" done for Wiz's multiple "eyes".
function mod:GetRawMultiShotTearCount(player)
	local numSpider = GetMutantSpiderCount(player)
	local numInnerEye = GetInnerEyeCount(player)
	local num2020 = Get2020Count(player)
	local numWiz = GetWizCount(player)

	local numTears = 1 + numWiz

	if numSpider > 0 or numInnerEye > 0 then
		numTears = numTears + 1 + numInnerEye + numSpider * 2
	end

	if num2020 > 0 and numTears < 2 then
		numTears = 2
	end

	if num2020 > 1 then
		numTears = numTears + (num2020-1)
	end

	return math.min(numTears, 16)
end

-- Returns the total # of tears, the # of tears per eye, and the # of eyes, after potentially being adjusted for Wiz.
function mod:GetMultiShotTearCount(player, rawNumTears, numEyes)
	local numTears = rawNumTears or mod:GetRawMultiShotTearCount(player)
	numEyes = numEyes or (1 + GetWizCount(player))

	local numTearsPerEye = numTears

	if numEyes > 1 then
		numTearsPerEye = math.min(math.ceil(numTears / numEyes), math.floor(16 / numEyes))
		numTears = numTearsPerEye * numEyes
	end

	return numTears, numTearsPerEye, numEyes
end

-- Returns the angle used for a fan of tears shot by the player.
-- This is actually half the full angle, with tears being rotated -spreadAngle to +spreadAngle.
function mod:GetMultiShotSpreadAngle(player, numTears)
	numTears = numTears or mod:GetMultiShotRawTearCount(player)

	if numTears <= 2 then
		return 0
	end

	local numSpider = GetMutantSpiderCount(player)
	local numInnerEye = GetInnerEyeCount(player)

	local spreadAngle = 0

	if numSpider > 0 or numInnerEye > 0 then
		spreadAngle = 2.17 * math.min(1 + numInnerEye + numSpider * 2, numTears-1)

		if Get2020Count(player) > 0 then
			spreadAngle = spreadAngle * 0.4
		end
	end

	return math.min(spreadAngle, 90)
end

-- Returns half of the angle between the furthest of Wiz's multiple "eyes".
function mod:GetWizMultiEyeAngle(player, numEyes)
	numEyes = numEyes or (1 + GetWizCount(player))

	if numEyes > 1 then
		return 55
	elseif numEyes == 1 then
		return 45
	end
	return 0
end

-- Returns a table with some pseudo-MultiShotParams-like info:
--[[
NumTears = Total # of tears fired
RawNumTears = The # of tears the player would fire before the number was adjusted for Wiz
SpreadAngle = The angle of the tears fired in a single fan vary from -this to +this
NumEyes = # of "eyes" to shoot from simultaniously (ie, # of Wiz + 1)
NumTearsPerEye = # of tears fired per "eye" (Wiz)
MultiEyeAngle = Half of the angle between the two furthest Wiz "eyes"
]]
function mod:GetMultiShotInfo(player, rawNumTears, numEyes)
	local rawNumTears = rawNumTears or mod:GetRawMultiShotTearCount(player)
	local numTears, numTearsPerEye, numEyes = mod:GetMultiShotTearCount(player, rawNumTears, numEyes)
	local spreadAngle = mod:GetMultiShotSpreadAngle(player, numTears)
	local multiEyeAngle = mod:GetWizMultiEyeAngle(player, numEyes)

	return {
		NumTears = numTears,
		RawNumTears = rawNumTears,
		SpreadAngle = spreadAngle,
		NumEyes = numEyes,
		NumTearsPerEye = numTearsPerEye,
		MultiEyeAngle = multiEyeAngle,
	}
end

-- Returns a table with some pseudo-pseudo-MultiShotParams-like info. See above.
function mod:GetRealMultiShotInfo(player, weaponType)
	local params = player:GetMultiShotParams(weaponType or WeaponType.WEAPON_TEARS)

	return {
		NumTears = params:GetNumTears(),
		RawNumTears = params:GetNumTears(),
		SpreadAngle = params:GetSpreadAngle(weaponType or WeaponType.WEAPON_TEARS),
		NumEyes = params:GetNumEyesActive(),
		NumTearsPerEye = params:GetNumLanesPerEye(),
		MultiEyeAngle = params:GetMultiEyeAngle(),
	}
end

-- Returns a table of Position/Velocity pairs representing the initial position OFFSET & velocity of multishot tears.
-- Parameter is a table with any of the following attributes, some of which you could can from GetMultiShotInfo() or other functions above.
-- If you don't need to customize anything, you could also just use GetMultiShotPosVel() below.
--[[
SpreadAngle = The angle of the tears fired in a single fan vary from -this to +this
NumEyes = # of "eyes" to shoot from simultaniously (ie, # of Wiz + 1)
NumTearsPerEye = # of tears fired per "eye" (Wiz)
NumTears = (If NumTearsPerEye was not specified) # of tears to fire before being split evenly across each "eye"
MultiEyeAngle = Half of the angle between the two furthest Wiz "eyes"
NoArc = If set to true, tear's starting position offsets will be a straight line instead of an arc
Direction = Vector direction in which tears are being fired, defaults to Vector(1,0)
ShotSpeed = Speed to set the initial tear velocities to, defaults to the length of Direction if unspecified, or 1 if neither were
ApplyConjoined = Apply the effect of the Conjoined transformation, more or less
]]
-- Use GetMultiShotPosVel below if you don't want to customize the values, or with REPENTOGON you could use GetMultiShotPositionVelocity.
-- You might wanna multiply the returned Position offsets by 10.
function mod:CalcMultiShotOffsets(multiShotInfo)
	local numEyes = multiShotInfo.NumEyes or 1
	local numTearsPerEye = multiShotInfo.NumTearsPerEye or math.ceil((multiShotInfo.NumTears or multiShotInfo.RawNumTears or 1) / numEyes)
	local multiEyeAngle = multiShotInfo.MultiEyeAngle or mod:GetWizMultiEyeAngle(nil, numEyes)
	local spreadAngle = multiShotInfo.SpreadAngle
	if not spreadAngle then
		if numTearsPerEye <= 2 then
			spreadAngle = 0
		else
			spreadAngle = (numTearsPerEye-1) * 2.17
		end
	end
	local direction = multiShotInfo.Direction or Vector(1,0)
	local shotAngle = direction:GetAngleDegrees()
	local shotSpeed = multiShotInfo.ShotSpeed or direction:Length()
	
	local addedEyesForConjoined = false
	
	if multiShotInfo.ApplyConjoined then
		if numEyes == 1 then
			numEyes = numEyes + 2
			addedEyesForConjoined = true
		end
		if multiEyeAngle < 45 then
			multiEyeAngle = 45
		end
	end
	
	local ret = {}
	
	for i=0, numEyes-1 do
		local eyeAngle = shotAngle
		if numEyes > 1 and multiEyeAngle > 0 then
			eyeAngle = eyeAngle + 2 * multiEyeAngle * i / (numEyes-1) - multiEyeAngle
		end
		
		local numTears = numTearsPerEye
		
		if multiShotInfo.ApplyConjoined and (i==0 or i==numEyes-1) then
			if addedEyesForConjoined then
				numTears = 1
			else
				numTears = numTears + 1
			end
		end
		
		for j=0, numTears-1 do
			local n = 0
			local tearAngle = eyeAngle
			if numTears > 1 then
				n = j / (numTears-1)
				tearAngle = tearAngle + 2 * spreadAngle * n - spreadAngle
			end
			local pos
			if numTears < 2 then
				pos = Vector.Zero
			elseif multiShotInfo.NoArc then
				pos = Vector(0, n * 1.6 - 0.8)
			else
				local sideOffset = -0.8 * math.cos(math.pi * n)
				local outOffset = 1.1 * math.cos(math.pi * (n - 0.5))
				pos = Vector(outOffset, sideOffset)
			end
			table.insert(ret, {
				Position = pos:Rotated(shotAngle),
				Velocity = Vector.FromAngle(tearAngle):Resized(shotSpeed),
			})
		end
	end
	
	return ret
end

-- Returns a table of Position/Velocity pairs representing the initial position OFFSET & velocity of multishot tears for the provided player.
-- If useRepentogonIfAvailable is true and REPENTOGON is available, this will just use MultiShotParams instead of the re-implementations.
-- Note that there would be some slight differences, such as GetMultiShotParams automatically having a random chance to apply Bookworm.
-- In either case, you might wanna multiply the returned Position offsets by 10.
function mod:GetMultiShotPosVel(player, direction, shotSpeed, useRepentogonIfAvailable)
	direction = direction or Vector(1,0)
	shotSpeed = shotSpeed or (10 * player.ShotSpeed)
	if useRepentogonIfAvailable and REPENTOGON then
		local multiShotParams = player:GetMultiShotParams(WeaponType.WEAPON_TEARS)
		local ret = {}
		for i=0, multiShotParams:GetNumTears()-1 do
			table.insert(ret, player:GetMultiShotPositionVelocity(i, WeaponType.WEAPON_TEARS, direction, shotSpeed, multiShotParams))
		end
		return ret
	end
	local info = mod:GetMultiShotInfo(player)
	info.Direction = direction
	info.ShotSpeed = shotSpeed
	return mod:CalcMultiShotOffsets(player, info)
end
