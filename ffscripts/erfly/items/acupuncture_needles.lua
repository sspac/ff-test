local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local DamageMulti = 0.65
local VelocityMulti = 1.35
local SecondaryVelocityMulti = 1.25

function mod:shouldFireAcupuncture(player, rng, pdata)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.ACUPUNCTURE_NEEDLES) then
        if not pdata.firingAcupuncture then
            if rng:RandomFloat() < 1 / (math.max(3 - player.Luck/5, 1)) then
                return true
            end
        end
    end
end

function mod:acupunctureCheckPlayer(player, pdata)
    if pdata.firingAcupuncture then
        if type(pdata.firingAcupuncture) == "number" then
            pdata.firingAcupuncture = pdata.firingAcupuncture - 1
            if pdata.firingAcupuncture <= 0 then
                pdata.firingAcupuncture = false
            end
        else
            pdata.firingAcupuncture = false
        end
    end
end

local function determineAcupunctures(player, ent, initialTearPosition, initialTearVelocity)
    local tearInfo = {}
    initialTearVelocity = initialTearVelocity or ent.Velocity
    local count = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.ACUPUNCTURE_NEEDLES)
    local middleVal = math.floor(count / 2)
    if middleVal == 0 then
        middleVal = 1
    end
    local hasMiddle = middleVal ~= count/2
    local incrementalNess = 180 / (count + 1)
    local expectedMiddleVal = -90 + (incrementalNess * middleVal)
    for i = 1, count + 2 do
        local rot = -90 + ((i - 1) * incrementalNess)
        local lerpVal = math.abs(rot)/90
        local velSpeed = mod:Lerp(VelocityMulti, SecondaryVelocityMulti, lerpVal)
        local vel, pos
        if ent:ToTear() then
            pos = initialTearPosition + initialTearVelocity:Resized(-ent.Size * lerpVal * count) + initialTearVelocity:Resized(-ent.Size * lerpVal * count):Rotated(rot)
            vel = (initialTearVelocity * velSpeed):Rotated((rot * -1) / 45)
        elseif ent:ToBomb() then
            pos = initialTearPosition + initialTearVelocity:Resized(-ent.Size * lerpVal * count) + initialTearVelocity:Resized(-ent.Size * 0.5 * lerpVal * count):Rotated(rot)
            vel = (initialTearVelocity * velSpeed):Rotated((rot * -1) / 20)
        elseif ent:ToLaser() then
            local laser = ent:ToLaser()
            if laser:IsCircleLaser() then
                pos = ent.Position + ent.Velocity:Resized(laser.Radius):Rotated(rot * -1)
                vel = (ent.Velocity * velSpeed):Rotated((rot * -1) / 20)
            end
        end

        table.insert(tearInfo, {Position = pos, Velocity = vel})
    end

    return tearInfo, hasMiddle, expectedMiddleVal, middleVal
end

function mod:acupuncturePostFire(player, tear, rng, pdata, tdata, secondHandMultiplier, ignorePlayerEffects, isLudo)
    if mod:shouldFireAcupuncture(player, rng, pdata) then
        if isLudo and tear.Velocity:Length() == 0 then return end
        pdata.firingAcupuncture = true
        local initialTearPosition = tear.Position
        local initialTearVelocity
        if isLudo then
            initialTearVelocity = tear.Velocity:Resized(player.ShotSpeed * 10)
        else
            tear.CollisionDamage = tear.CollisionDamage * DamageMulti
            mod:changeTearVariant(tear, FiendFolio.TEAR.ACUPUNCTURE_NEEDLE, FiendFolio.TEAR.ACUPUNCTURE_NEEDLE_BLOOD)
        end
        local tearInfo, hasMiddle, expectedMiddleVal, middleVal = determineAcupunctures(player, tear, initialTearPosition, initialTearVelocity)
        --print(hasMiddle, expectedMiddleVal, middleVal)
        for i = 1, #tearInfo do
            local tInfo = tearInfo[i]
            if (i == middleVal and not isLudo) then
                tear.Velocity = tInfo.Velocity
                tear.Position = tInfo.Position
            else
                local newtear = player:FireTear(tInfo.Position, tInfo.Velocity, true, false, true, player, 0.65)
                mod:changeTearVariant(newtear, FiendFolio.TEAR.ACUPUNCTURE_NEEDLE, FiendFolio.TEAR.ACUPUNCTURE_NEEDLE_BLOOD)
                if player:HasCollectible(CollectibleType.COLLECTIBLE_CHOCOLATE_MILK) then
                    newtear.Scale = tear.Scale
                    newtear.CollisionDamage = tear.CollisionDamage
                end
                if tdata.AlreadyDuplicatedByMultiEuclidean then
                    mod:GetEntityData(newtear).AlreadyDuplicatedByMultiEuclidean = tdata.AlreadyDuplicatedByMultiEuclidean
                end
                mod.scheduleForUpdate(function()
                    newtear.Position = tInfo.Position
                end, 0)
                mod:tryAppendCSection(player, newtear)
            end
        end
    end
end

function mod:acupuncturePostFireBomb(player, bomb, rng, pdata, bdata)
    if mod:shouldFireAcupuncture(player, rng, pdata) then
        pdata.firingAcupuncture = true
        bomb.ExplosionDamage = bomb.ExplosionDamage * DamageMulti
        bomb.RadiusMultiplier = DamageMulti
        local initialTearPosition = bomb.Position
        local tearInfo, hasMiddle, expectedMiddleVal, middleVal = determineAcupunctures(player, bomb, initialTearPosition)
        for i = 1, #tearInfo do
            local tInfo = tearInfo[i]
            if (i == middleVal) then
                bomb.Velocity = tInfo.Velocity
                bomb.Position = tInfo.Position
            else
                local newbomb = player:FireBomb(tInfo.Position, tInfo.Velocity, player)
                newbomb.ExplosionDamage = newbomb.ExplosionDamage * DamageMulti
                newbomb.RadiusMultiplier = DamageMulti
            end
        end
        --bomb.Velocity = bomb.Velocity * VelocityMulti
    end
end
function mod:acupuncturePostFireLaser(player, laser, rng)
    local pdata = mod:GetEntityData(player)
    if mod:shouldFireAcupuncture(player, rng, pdata) then
        if laser:IsCircleLaser() then
            pdata.firingAcupuncture = 5
            local initialTearPosition = laser.Position
            laser.CollisionDamage = laser.CollisionDamage * DamageMulti
            local tearInfo, hasMiddle, expectedMiddleVal, middleVal = determineAcupunctures(player, laser, initialTearPosition)
            for i = 1, #tearInfo do
                local tInfo = tearInfo[i]
                if (i == middleVal and not isLudo) then
                    laser.Velocity = tInfo.Velocity
                    laser.Position = tInfo.Position
                    mod.scheduleForUpdate(function()
                        laser.Position = tInfo.Position
                    end, 0)
                else
                    local newLaser = player:FireTechXLaser(tInfo.Position, tInfo.Velocity, laser.Radius, player, DamageMulti)
                    mod.scheduleForUpdate(function()
                        newLaser.Position = tInfo.Position
                    end, 0)
                end
            end
        else
            if laser.OneHit then
                pdata.firingAcupuncture = 5
                for i = -90, 90, 180 do
                    local newLaser = player:FireTechLaser(laser.Position, 0, Vector(1,0):Rotated(laser.AngleDegrees):Rotated(i/45))
                end
            end
        end
    end
end

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.ACUPUNCTURE_NEEDLES] = {
	BodyColor = Color(1,1,1,1,-4.513/255,-27.080/255,-33.850/255,1.018,1.106,1.133,1),
	EyeAColor = Color(1,1,1,1,12.442/255,-5.027/255,-5.027/255,0.743,0.035,0.035,1),
	EyeBColor = Color(1,1,1,1,12.442/255,-5.027/255,-5.027/255,202/255,4/255,4/255,1),}

local function shouldFireAcupunctureSewing(player)
	local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.ACUPUNCTURE_NEEDLES)
    if rng:RandomFloat() < 1/3 then
        return true
    end
end

local function determineAcupuncturesSewing(tear, initialTearPosition, initialTearVelocity)
    local tearInfo = {}
    local count = 1
    local middleVal = 2
    local hasMiddle = middleVal ~= count/2
    local incrementalNess = 180 / (count + 1)
    local expectedMiddleVal = -90 + (incrementalNess * middleVal)
    for i = 1, count + 2 do
        local rot = -90 + ((i - 1) * incrementalNess)
        local lerpVal = math.abs(rot)/90
        local velSpeed = mod:Lerp(1.35, 1.25, lerpVal)
        local vel, pos
        pos = initialTearPosition + initialTearVelocity:Resized(-tear.Size * lerpVal * count) + initialTearVelocity:Resized(-tear.Size * lerpVal * count):Rotated(rot)
        vel = (initialTearVelocity * velSpeed):Rotated((rot * -1) / 45)

        table.insert(tearInfo, {Position = pos, Velocity = vel})
    end

    return tearInfo, hasMiddle, expectedMiddleVal, middleVal
end

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
    if shouldFireAcupunctureSewing(familiar.Player) then
		local initialTearPosition = tear.Position
        local initialTearVelocity = tear.Velocity
        tear.CollisionDamage = tear.CollisionDamage * 0.65
        mod:changeTearVariant(tear, FiendFolio.TEAR.ACUPUNCTURE_NEEDLE, FiendFolio.TEAR.ACUPUNCTURE_NEEDLE_BLOOD)
        local tearInfo, hasMiddle, expectedMiddleVal, middleVal = determineAcupuncturesSewing(tear, initialTearPosition, initialTearVelocity)
        for i = 1, #tearInfo do
            local tInfo = tearInfo[i]
            if i == middleVal then
                tear.Velocity = tInfo.Velocity
                tear.Position = tInfo.Position
            else
				local isSuperpositioned = mod:isSuperpositionedPlayer(familiar.Player)
				local newTear = Isaac.Spawn(EntityType.ENTITY_TEAR, FiendFolio.TEAR.ACUPUNCTURE_NEEDLE, 0, tInfo.Position, tInfo.Velocity, familiar):ToTear()
				newTear.Height = -23.75
				newTear.FallingSpeed = 0.1 + math.random() * 0.2
				newTear.FallingAcceleration = 0.0
				newTear.CollisionDamage = 3.5 * 0.65
				newTear.Scale = 0.8
				if familiar.Player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
					newTear.CollisionDamage = newTear.CollisionDamage * 2
					newTear.Scale = 1.0
				end
				if Sewn_API then
					if Sewn_API:IsUltra(data) then
						newTear.CollisionDamage = newTear.CollisionDamage * 1.5
						newTear.Scale = newTear.Scale * 1.1
					elseif Sewn_API:IsSuper(data) then
						newTear.CollisionDamage = newTear.CollisionDamage * 1.25
						newTear.Scale = newTear.Scale * 1.05
					end
				end
				newTear:ResetSpriteScale()
				if familiar.Player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
					newTear:AddTearFlags(TearFlags.TEAR_HOMING)
					local tearcolor = Color(0.4, 0.15, 0.38, 1, 55/255, 5/255, 95/255)
					newTear.Color = tearcolor
				end
				if isSuperpositioned then
					local tearcolor = Color.Lerp(newTear.Color, Color(1,1,1,1,0,0,0), 0)
					tearcolor.A = tearcolor.A / 4
					newTear.Color = tearcolor
					newTear.CollisionDamage = newTear.CollisionDamage/4
				end
                if mod:GetEntityData(tear).AlreadyDuplicatedByMultiEuclidean then
                    mod:GetEntityData(newTear).AlreadyDuplicatedByMultiEuclidean = mod:GetEntityData(tear).AlreadyDuplicatedByMultiEuclidean
                end
				newTear:Update()
            end
        end
	end
end, FiendFolio.ITEM.COLLECTIBLE.ACUPUNCTURE_NEEDLES)

function mod:acupunctureNeedleTear(tear, tvar, data, offset)
    local sprite = tear:GetSprite()
	local scale = tear.Scale
	local flags = tear.TearFlags
	
	local anim
	if scale <= 0.3 then
		anim = "RegularTear1"
	elseif scale <= 0.55 then
		anim = "RegularTear2"
	elseif scale <= 0.675 then
		anim = "RegularTear3"
	elseif scale <= 0.8 then
		anim = "RegularTear4"
	elseif scale <= 0.925 then
		anim = "RegularTear5"
	elseif scale <= 1.05 then
		anim = "RegularTear6"
	elseif scale <= 1.175 then
		anim = "RegularTear7"
	elseif scale <= 1.425 then
		anim = "RegularTear8"
	elseif scale <= 1.675 then
		anim = "RegularTear9"
	elseif scale <= 1.925 then
		anim = "RegularTear10"
	elseif scale <= 2.175 then
		anim = "RegularTear11"
	elseif scale <= 2.55 then
		anim = "RegularTear12"
	else
		anim = "RegularTear13"
	end

	if not sprite:IsPlaying(anim) then
		local frame = sprite:GetFrame()
		sprite:Play(anim, true)
		sprite:SetFrame(frame)
	end

	local spritescale = mod:getTearScale13(tear)
	local layers = sprite:GetAllLayers()
	for _, layer in ipairs(layers) do
		layer:SetSize(spritescale)
	end
	
	local adjustedVelocity = tear.Velocity
	if tear.WaitFrames > 0 then
		adjustedVelocity = tear.ContinueVelocity
	elseif (tear.FallingSpeed < 0 or 0.2 < tear.FallingSpeed) and 
	       flags & TearFlags.TEAR_LUDOVICO ~= TearFlags.TEAR_LUDOVICO and
	       ((flags & TearFlags.TEAR_ABSORB ~= TearFlags.TEAR_ABSORB and flags & TearFlags.TEAR_POP ~= TearFlags.TEAR_POP) or tear.Velocity:Length() <= 0.1) 
	then
		adjustedVelocity = adjustedVelocity + Vector(0, tear.FallingSpeed)
	end
	
	sprite.Rotation = adjustedVelocity:GetAngleDegrees()
	sprite.FlipX = false
	sprite.FlipY = false
end
mod:AddCallback("FF_CUSTOM_TEAR_RENDER", mod.acupunctureNeedleTear, FiendFolio.TEAR.ACUPUNCTURE_NEEDLE)
mod:AddCallback("FF_CUSTOM_TEAR_RENDER", mod.acupunctureNeedleTear, FiendFolio.TEAR.ACUPUNCTURE_NEEDLE_BLOOD)

function mod:acupunctureNeedleTearSplat(tear, tvar, data)
    sfx:Play(SoundEffect.SOUND_POT_BREAK, 0.5, 0, false, 3.5)
	
	if tear.TearFlags & TearFlags.TEAR_EXPLOSIVE == TearFlags.TEAR_EXPLOSIVE then return end

	local scale = tear.Scale
	local color = tear:GetSprite().Color
	
	local poof = Isaac.Spawn(1000, EffectVariant.IMPACT, 0, tear.Position, Vector.Zero, tear)
	poof:GetSprite().Color = color
	poof.SpriteScale = Vector(scale * 0.8, scale * 0.8)
	poof.PositionOffset = tear.PositionOffset
	
	for i = 1, 5 do
		local gib = Isaac.Spawn(1000, EffectVariant.NAIL_PARTICLE, 0, tear.Position, RandomVector()*2, tear):ToEffect()
		gib.m_Height = math.min(-5, tear.Height)
		gib:GetSprite().Color = color
		gib.State = 2
	end
end
mod:AddCallback("FF_CUSTOM_TEAR_SPLAT", mod.acupunctureNeedleTearSplat, FiendFolio.TEAR.ACUPUNCTURE_NEEDLE)
mod:AddCallback("FF_CUSTOM_TEAR_SPLAT", mod.acupunctureNeedleTearSplat, FiendFolio.TEAR.ACUPUNCTURE_NEEDLE_BLOOD)