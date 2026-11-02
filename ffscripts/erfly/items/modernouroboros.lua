local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local flag = TearFlagsLib.RegisterTearFlag("MODERN_OUROBOROS")
mod.MODERN_OUROBOROS = {}
mod.MODERN_OUROBOROS.PREVENT_APPLY_CREEP = TearFlagsLib.WeaponFlag.DR_FETUS |
                                           TearFlagsLib.WeaponFlag.EPIC_FETUS |
                                           TearFlagsLib.WeaponFlag.CLUB_EPIC_FETUS |
                                           TearFlagsLib.WeaponFlag.AQUARIUS

function mod:updateModernOuroborosTearLaserColor(player)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.MODERN_OUROBOROS) then
		player.TearColor = player.TearColor * FiendFolio.ColorModernOuroboros
		player.LaserColor = player.LaserColor * Color(1,1,1,1,0,0,0,1.62,1.53,1.26, 1)
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_EVALUATE_CACHE, FiendFolio.ITEM.COLLECTIBLE.MODERN_OUROBOROS, mod.updateModernOuroborosTearLaserColor, CacheFlag.CACHE_TEARCOLOR)

function mod:modernOuroborosFlagGeneric(entity, player, weaponFlag)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.MODERN_OUROBOROS) then
		TearFlagsLib.AddTearFlags(entity, flag)
		
		if weaponFlag == TearFlagsLib.WeaponFlag.TEAR and not FiendFolio.HasCetusFlag(entity) then
			for i = -30, 30, 30 do
				local smoke = Isaac.Spawn(1000, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, entity.Position, entity.Velocity:Resized(10):Rotated(i), nil)
				--smoke.SpriteScale = Vector(1,1)
				smoke.SpriteOffset = Vector(0, -10)
				smoke:Update()
			end
		end
	end
end
mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, FiendFolio.ITEM.COLLECTIBLE.MODERN_OUROBOROS, mod.modernOuroborosFlagGeneric)
mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_CHANCELESS_TEARFLAGS, FiendFolio.ITEM.COLLECTIBLE.MODERN_OUROBOROS, mod.modernOuroborosFlagGeneric)

function mod:modernOuroborosFlagLocust(entity, player, weaponFlag)
	TearFlagsLib.AddTearFlags(entity, flag)
end
mod:AddEntityCallback(TearFlagsLib.Callback.POLL_LOCUST_TEARFLAGS, EntityType.ENTITY_FAMILIAR, FamiliarVariant.ABYSS_LOCUST, 
                      FiendFolio.ITEM.COLLECTIBLE.MODERN_OUROBOROS, mod.modernOuroborosFlagLocust, FiendFolio.ITEM.COLLECTIBLE.MODERN_OUROBOROS)

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

function mod:applyModernOuroborosFlag(entity, player, source, weaponFlag)
	if weaponFlag == TearFlagsLib.WeaponFlag.FF_PLANET_X then
		local fdata = mod:GetEntityData(source)
		if fdata.LastFrameHit == game:GetFrameCount() then
			return
		end
	end
	if not (mod.MODERN_OUROBOROS.PREVENT_APPLY_CREEP:HasAnyFlag(weaponFlag) or FiendFolio.HasCetusFlag(source)) then
		local edata = mod:GetEntityData(entity)
		if not edata.spawnedModernOuroCreepLately then
			local pos = source.Position
			if source.Type == EntityType.ENTITY_LASER then
				pos = movePosToClosestLaserSegment(entity.Position, source:ToLaser())
			elseif weaponFlag == TearFlagsLib.WeaponFlag.CLUB and source.SubType == 4 then
				local capsulePosition, capsuleRadius = TearFlagsLib.GetSwingingKnifeCapsulePositionRadius(source)
				pos = (capsulePosition - entity.Position):Resized(entity.Size * math.max(entity.SizeMulti.X, entity.SizeMulti.Y)) + entity.Position
			elseif weaponFlag == TearFlagsLib.WeaponFlag.SWORD then
				pos = mod:getSwordCollidePos((hitbox or source):ToKnife(), entity)
				if pos == nil then
					return
				end
			elseif weaponFlag == TearFlagsLib.WeaponFlag.FF_PROVIDENCE_LASER then
				pos = entity.Position
			end
			
			mod.SpawnGunpowder(Isaac.GetPlayer(0),Game():GetRoom():GetClampedPosition(pos, 0), 120, 120, nil, nil, true, FiendFolio.ColorModernOuroborosShitty, nil, nil, TearFlagsLib.GetTearFlagParams(source, flag).AutoBurn)
			edata.spawnedModernOuroCreepLately = 30
			
			if weaponFlag == TearFlagsLib.WeaponFlag.TEAR then
				mod:GetEntityData(source).LastFrameSpawnedPowderCreep = game:GetFrameCount()
			end
		end
	end
end
mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, mod.applyModernOuroborosFlag, flag)

function mod:modernOuroborosPostTearRemove(tear)
    if TearFlagsLib.HasTearFlags(tear, flag) and not FiendFolio.HasCetusFlag(tear) then
		local data = mod:GetEntityData(tear)
		if data.LastFrameSpawnedPowderCreep == nil or math.abs(data.LastFrameSpawnedPowderCreep - game:GetFrameCount()) > 1 then
			mod.SpawnGunpowder(Isaac.GetPlayer(0),Game():GetRoom():GetClampedPosition(tear.Position, 0), 120, 120, nil, nil, true, FiendFolio.ColorModernOuroborosShitty, nil, nil, TearFlagsLib.GetTearFlagParams(tear, flag).AutoBurn)
		end
	end
end

function mod:modernOuroborosPostExplosion(explosion, player, source, weaponFlag)
	mod.SpawnGunpowder(Isaac.GetPlayer(0),Game():GetRoom():GetClampedPosition(explosion.Position, 0), 120, 120, nil, nil, true, FiendFolio.ColorModernOuroborosShitty, nil, nil, TearFlagsLib.GetTearFlagParams(source, flag).AutoBurn)
end
mod:AddCallback(TearFlagsLib.Callback.APPLY_EXPLOSION_TEARFLAG_EFFECT, mod.modernOuroborosPostExplosion, flag)

function mod:modernOuroborosAquariusUpdate(e)
	if TearFlagsLib.HasTearFlags(e, flag) then
		local d = mod:GetEntityData(e)
		d.ModernOuroborosInfo = d.ModernOuroborosInfo or {}
		local moi = d.ModernOuroborosInfo
		
		local burntime = 60
		local spreaddist = 50
		if TearFlagsLib.GetTearFlagParams(e, flag).AutoBurn then
			moi.Flaming = true
		end
		if moi.Flaming and not moi.SpawnedFire then
			local fires = Isaac.FindByType(1000,51,960)
			local tooCloseToFire = false
			for _, fire in ipairs(fires) do
				if math.abs((fire.Position - e.Position):Length()) < 20 and fire.FrameCount < 30 then
					tooCloseToFire = true
				end
			end
			if not tooCloseToFire then
				local fire = Isaac.Spawn(1000,51,960, e.Position, nilvector, e.SpawnerEntity):ToEffect()
				fire.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
				mod:GetEntityData(fire).timer = burntime
				fire:FollowParent(e)
				fire:Update()
			end
			moi.SpawnedFire = true
			moi.StateFrame = 0
		elseif not moi.Flaming then
			local fire = mod.FindClosestFire(e.Position, 99999, true)
			if fire then
				if e.Position:Distance(fire.Position) < spreaddist then
					moi.Flaming = true
				end
			end
		end
		if moi.SpawnedFire then
			moi.StateFrame = moi.StateFrame + 1
			if moi.StateFrame > burntime + 10 then
				e:Remove()
			elseif moi.StateFrame > burntime then
				e.SpriteScale = Vector(1,1) * (1 - ((moi.StateFrame - burntime)/10))
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.modernOuroborosAquariusUpdate, EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL)

function mod:modernOuroborosAquariusDamage(source, entity, data)
	if source.Type == EntityType.ENTITY_EFFECT and source.Variant == EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL and source.Entity and TearFlagsLib.HasTearFlags(source.Entity, flag) then
		entity:AddSlowing(source, 3, 0.5, Color(1,1,1,1,0,0,0))
	end
end

function mod:modernOuroEntityUpdate(npc, data)
	if data.spawnedModernOuroCreepLately then
		data.spawnedModernOuroCreepLately = data.spawnedModernOuroCreepLately - 1
		if data.spawnedModernOuroCreepLately <= 0 then
			data.spawnedModernOuroCreepLately = nil
		end
	end
end

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.MODERN_OUROBOROS] = {
	TearColor = FiendFolio.ColorModernOuroboros,
	BodyColor = Color(1,1,1,1,-0.752/255,-61.381/255,-14.009/255,0.336,0.841,0.345,1),
	EyeAColor = Color(1,1,1,1,-77.766/255,-39.734/255,-47.672/255,1.234,0.266,0.328,1),
	EyeBColor = Color(1,1,1,1,-77.766/255,-39.734/255,-47.672/255,1.234,0.266,0.328,1)}

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	TearFlagsLib.AddTearFlags(tear, TearFlagsLib.Flag.MODERN_OUROBOROS)
	
	for i = -30, 30, 30 do
		local smoke = Isaac.Spawn(1000, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, tear.Position, tear.Velocity:Resized(10):Rotated(i), nil)
		--smoke.SpriteScale = Vector(1,1)
		smoke.SpriteOffset = Vector(0, -10)
		smoke:Update()
	end
end, FiendFolio.ITEM.COLLECTIBLE.MODERN_OUROBOROS)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, familiar)
	if familiar.SubType == FiendFolio.ITEM.COLLECTIBLE.MODERN_OUROBOROS and familiar.Player then
		if mod.fireEntitiesFriend then
			table.insert(mod.fireEntitiesFriend, familiar.Player)
		end
	end
end, FiendFolio.ITEM.FAMILIAR.SEWING_MANUAL_DOLL)

mod:AddCollectibleCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.ITEM.COLLECTIBLE.MODERN_OUROBOROS, function(_, player)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.MODERN_OUROBOROS) then
		if mod.fireEntitiesFriend then
			table.insert(mod.fireEntitiesFriend, player)
		end
	end
end)

function mod.handleModernOuroborosD3(entity)
	TearFlagsLib.SetTearFlagParams(entity, flag, {AutoBurn = true})
end