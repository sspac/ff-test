local mod = FiendFolio
local game = Game()

local flag = TearFlagsLib.RegisterTearFlag("GODS_MARBLE")

mod.GODS_MARBLE = {}
mod.GODS_MARBLE.IGNORE_APPLY = TearFlagsLib.WeaponFlag.EPIC_FETUS |
                               TearFlagsLib.WeaponFlag.CLUB_EPIC_FETUS

function mod:godsMarbleLaserColor(player, flag)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.GODS_MARBLE) then
		player.LaserColor = player.LaserColor * Color(1, 1, 1, 1, 0, 0, 0, 4.8, 4.8, 3.2, 1)
	end
end
mod:AddTrinketCallback(ModCallbacks.MC_EVALUATE_CACHE, FiendFolio.ITEM.ROCK.GODS_MARBLE, mod.godsMarbleLaserColor, CacheFlag.CACHE_TEARCOLOR)

-- God's Marble
function mod:godsMarbleFlagGeneric(entity, player, weaponFlag)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.GODS_MARBLE) then
        local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.GODS_MARBLE)
        local chance = math.min(3 + player.Luck, 40) * trinketPower

        if math.random(100) < chance then
            TearFlagsLib.AddTearFlags(entity, flag)
			
			local typ = entity.Type
			if typ == EntityType.ENTITY_TEAR then
				entity:ToTear():AddTearFlags(TearFlags.TEAR_SPECTRAL)
				if weaponFlag == TearFlagsLib.WeaponFlag.BOBS_ROTTEN_HEAD or weaponFlag == TearFlagsLib.WeaponFlag.SHARP_KEY then
					mod.scheduleForUpdate(function()
						entity:ToTear():AddTearFlags(TearFlags.TEAR_SPECTRAL)
					end, 0)
				end
			elseif typ == EntityType.ENTITY_BOMB then
				entity:ToBomb():AddTearFlags(TearFlags.TEAR_SPECTRAL)
			elseif typ == EntityType.ENTITY_LASER then
				entity:ToLaser():AddTearFlags(TearFlags.TEAR_SPECTRAL)
			elseif typ == EntityType.ENTITY_KNIFE then
				entity:ToKnife():AddTearFlags(TearFlags.TEAR_SPECTRAL)
			elseif typ == EntityType.ENTITY_EFFECT then
				entity:ToEffect():AddTearFlags(TearFlags.TEAR_SPECTRAL)
			else
				TearFlagsLib.AddCustomVanillaTearFlags(entity, TearFlags.TEAR_SPECTRAL)
			end
			
			if weaponFlag == TearFlagsLib.WeaponFlag.AQUARIUS then
				mod:GetEntityData(entity).FFAquariusTearColor = Color(1, 1, 1, 1, 0, 0, 0, 1.2, 1.2, 0.8, 1)
			elseif weaponFlag == TearFlagsLib.WeaponFlag.EPIC_FETUS or weaponFlag == TearFlagsLib.WeaponFlag.CLUB_EPIC_FETUS then
				mod:GetEntityData(entity).FFExplosionColor = Color(1, 1, 1, 1, 0, 0, 0, 1.2, 1.2, 0.8, 1)
			elseif weaponFlag == TearFlagsLib.WeaponFlag.LASER or 
			       weaponFlag == TearFlagsLib.WeaponFlag.ANTI_GRAV_LASER or 
			       weaponFlag == TearFlagsLib.WeaponFlag.KNIFE or
			       weaponFlag == TearFlagsLib.WeaponFlag.DARK_ARTS or
			       weaponFlag == TearFlagsLib.WeaponFlag.LOCUST or
			       weaponFlag == TearFlagsLib.WeaponFlag.UMBILICAL_WHIP or
			       weaponFlag == TearFlagsLib.WeaponFlag.BRIMSTONE_BALL or
			       weaponFlag == TearFlagsLib.WeaponFlag.BOBS_ROTTEN_HEAD or
			       weaponFlag == TearFlagsLib.WeaponFlag.SHARP_KEY or
			       weaponFlag == TearFlagsLib.WeaponFlag.OCULAR_RIFT or
			       weaponFlag == TearFlagsLib.WeaponFlag.HEMOPTYSIS
			then
				return
			else
				local s = math.asin(math.cos(game:GetFrameCount()/10*math.pi)) / math.pi * 2
				entity.Color = Color(-s*2, -s*2, -s*2, 1, ((s+1) / 2), ((s+1) / 2), ((s+1) / 2), 1.2, 1.2, 0.8, 1)
			end
		end
	end
end
mod:AddTrinketCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, FiendFolio.ITEM.ROCK.GODS_MARBLE, mod.godsMarbleFlagGeneric)

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tear)
	local var = tear.Variant
	if var ~= TearVariant.BOBS_HEAD and var ~= TearVariant.KEY and var ~= TearVariant.KEY_BLOOD and TearFlagsLib.HasTearFlags(tear, flag) then
		if var ~= TearVariant.MULTIDIMENSIONAL then
			local s = math.asin(math.cos(game:GetFrameCount()/10*math.pi)) / math.pi * 2
			tear.Color = Color(-s*2, -s*2, -s*2, 1, ((s+1) / 2), ((s+1) / 2), ((s+1) / 2), 1.2, 1.2, 0.8, 1)
		else
			tear.Color = Color(1, 1, 1, 1, 0, 0, 0, 1.2, 1.2, 0.8, 1)
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, function(_, bomb)
	if TearFlagsLib.HasTearFlags(bomb, flag) then
		local s = math.asin(math.cos(game:GetFrameCount()/10*math.pi)) / math.pi * 2
		bomb.Color = Color(-s*2, -s*2, -s*2, 1, ((s+1) / 2), ((s+1) / 2), ((s+1) / 2), 1.2, 1.2, 0.8, 1)
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, function(_, knife)
	if mod.IsKnifeSwingable(knife) and TearFlagsLib.HasTearFlags(knife, flag) then
		local s = math.asin(math.cos(game:GetFrameCount()/10*math.pi)) / math.pi * 2
		knife.Color = Color(-s*2, -s*2, -s*2, 1, ((s+1) / 2), ((s+1) / 2), ((s+1) / 2), 1.2, 1.2, 0.8, 1)
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_TEAR_DEATH, function(_, tear)
	if TearFlagsLib.HasTearFlags(tear, flag) and not FiendFolio.HasCetusFlag(tear) then
        local eff = Isaac.Spawn(1000, 1062, 0, tear.Position, Vector.Zero, tear.SpawnerEntity) -- gods marble effect
        eff.SpriteScale = Vector(2, 2)
        eff.Size = eff.Size * 2
		eff:Update()
    end
end)

mod:AddCallback(TearFlagsLib.Callback.APPLY_EXPLOSION_TEARFLAG_EFFECT, function(_, explosion, player, boomie, weaponFlag)
	local eff = Isaac.Spawn(1000, 1062, 0, boomie.Position, Vector.Zero, player) -- gods marble effect
	eff.SpriteScale = Vector(2, 2)
	eff.Size = eff.Size * 2
	eff:Update()
end, flag)

local function getClosestPointOnLine(testPosition, lineOrigin, lineEnd)
	local heading = lineEnd - lineOrigin
	local magnitude = heading:Length()
	heading:Normalize()

	local lhs = testPosition - lineOrigin
	local dot = lhs:Dot(heading)
	dot = math.min(math.max(0, dot), magnitude)
	return lineOrigin + heading * dot
end

local function movePosToClosestLaserSegment(pos, laser)
	local closestPoint = pos
	local closestDist = math.huge
	local capsules
	if laser:IsSampleLaser() then
		capsules = TearFlagsLib.GetLaserSampleCapsules(laser)
	else
		capsules = {TearFlagsLib.GetCapsule(laser.Position, laser.Position + Vector.FromAngle(laser.AngleDegrees) * 9999, laser.Radius)}
	end
	for _, laserCapsule in pairs(capsules) do
		local pointOnLine = getClosestPointOnLine(pos, laserCapsule.Locus1, laserCapsule.Locus2)
		local dist = pointOnLine:Distance(pos)
		if dist < closestDist then
			closestPoint = pointOnLine
			closestDist = dist
		end
	end
	return closestPoint
end

local function doGodsMarbleEffect(origin, radius, spawner)
	for _, pos in pairs({
		origin,
		origin + Vector(0, radius),
		origin + Vector(0, -radius),
		origin + Vector(radius, 0),
		origin + Vector(-radius, 0),
		origin + Vector(radius, radius) * 0.8,
		origin + Vector(radius, -radius) * 0.8,
		origin + Vector(-radius, radius) * 0.8,
		origin + Vector(-radius, -radius) * 0.8,
	}) do
		Isaac.Spawn(1000, EffectVariant.CRACK_THE_SKY, 1, pos, Vector.Zero, spawner)
	end
end

function mod:applyGodsMarbleFlag(entity, player, source, weaponFlag, params, hitbox)
	if entity.Type == EntityType.ENTITY_TEAR or entity.Type == EntityType.ENTITY_BOMB or mod.GODS_MARBLE.IGNORE_APPLY:HasAnyFlag(weaponFlag) then
		return
	end
	if weaponFlag == TearFlagsLib.WeaponFlag.FF_PLANET_X then
		local fdata = mod:GetEntityData(source)
		if fdata.HasHitThisRoll then
			return
		end
	end
	
	if weaponFlag == TearFlagsLib.WeaponFlag.AQUARIUS then
		if not mod:GetEntityData(source).FFGodsMarbleHasTriggered then
			doGodsMarbleEffect(source.Position, 24, player)
			mod:GetEntityData(source).FFGodsMarbleHasTriggered = true
		end
	elseif source.Type == EntityType.ENTITY_LASER then
		doGodsMarbleEffect(movePosToClosestLaserSegment(entity.Position, source:ToLaser()), 24, player)
	elseif weaponFlag == TearFlagsLib.WeaponFlag.CLUB and source.SubType == 4 then
		local capsulePosition, capsuleRadius = TearFlagsLib.GetSwingingKnifeCapsulePositionRadius(source)
		doGodsMarbleEffect((capsulePosition - entity.Position):Resized(entity.Size * math.max(entity.SizeMulti.X, entity.SizeMulti.Y)) + entity.Position, 24, player)
	elseif weaponFlag == TearFlagsLib.WeaponFlag.SWORD then
		local pos = mod:getSwordCollidePos((hitbox or source):ToKnife(), entity)
		if pos ~= nil then
			doGodsMarbleEffect(pos, 24, player)
		end
	elseif weaponFlag == TearFlagsLib.WeaponFlag.FF_PROVIDENCE_LASER then
		doGodsMarbleEffect(entity.Position, 24, player)
	else
		doGodsMarbleEffect(source.Position, 24, player)
	end
end
mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, mod.applyGodsMarbleFlag, flag)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
    if eff.FrameCount > 40 then
        local color = eff.Color
        color.A = color.A * 0.8
        eff.Color = color
    end
    if eff.FrameCount > 45 then
        eff:Remove()
        return
    end

	local canLaser = false
	local enemies = Isaac.FindInRadius(eff.Position, eff.Size, EntityPartition.ENEMY)
	for _, enemy in ipairs(enemies) do
		if enemy:ToNPC() and not (mod:isFriend(enemy) or enemy:HasEntityFlags(EntityFlag.FLAG_NO_TARGET)) then
			canLaser = true
			break
		end
	end
    if canLaser then
		doGodsMarbleEffect(eff.Position, eff.Size, eff.SpawnerEntity)
        eff:Remove()
    end
end, 1062)