local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local flag = TearFlagsLib.RegisterTearFlag("THIRD_LEG")

local fiendsThirdLegColor = Color(0.3, 0.5, 1, 1, 0.2, 0, 0.2)
fiendsThirdLegColor:SetColorize(1, 1, 2, 1)
local fiendsThirdLegLaserColor = Color(1, 1, 1, 1, 0, 0, 0)
fiendsThirdLegLaserColor:SetColorize(2.2, 1.3, 2.2, 1)

function mod:fiendsThirdLegTearLaserColor(player, flag)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.FIENDS_THIRD_LEG) then
		player.TearColor = player.TearColor * fiendsThirdLegColor
		player.LaserColor = player.LaserColor * fiendsThirdLegLaserColor
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_EVALUATE_CACHE, FiendFolio.ITEM.COLLECTIBLE.FIENDS_THIRD_LEG, mod.fiendsThirdLegTearLaserColor, CacheFlag.CACHE_TEARCOLOR)

function mod:fiendsThirdLegHoming(player, flag)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.FIENDS_THIRD_LEG) then
		player.TearFlags = player.TearFlags | TearFlags.TEAR_HOMING
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_EVALUATE_CACHE, FiendFolio.ITEM.COLLECTIBLE.FIENDS_THIRD_LEG, mod.fiendsThirdLegHoming, CacheFlag.CACHE_TEARFLAG)

function mod:fiendsThirdLegFlagGeneric(entity, player, weaponFlag)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.FIENDS_THIRD_LEG) then
		TearFlagsLib.AddTearFlags(entity, flag)
	end
end
mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, FiendFolio.ITEM.COLLECTIBLE.FIENDS_THIRD_LEG, mod.fiendsThirdLegFlagGeneric)
mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_CHANCELESS_TEARFLAGS, FiendFolio.ITEM.COLLECTIBLE.FIENDS_THIRD_LEG, mod.fiendsThirdLegFlagGeneric)

local function spawnFiendsThirdLegCreep(v, pos)
	local creep = Isaac.Spawn(1000, 46, 0, pos, Vector.Zero, v):ToEffect()
    creep.Color = Color(0.2,0,1,1,0.15+math.random(25,30)/100,0.2,0.15+math.random(25,30)/100)
    local damage = 10
    if v.SpawnerEntity and v.SpawnerEntity:ToPlayer() then
        damage = v.SpawnerEntity:ToPlayer().Damage
    end
    creep.CollisionDamage = damage
    creep.SpriteScale = Vector(0.7,0.7)
    creep:SetTimeout(30)
end

function mod:fiendsThirdLegGenericUpdate(v)
    if TearFlagsLib.HasTearFlags(v, flag) then
        if v.FrameCount % 2 == 0 then
            spawnFiendsThirdLegCreep(v, v.Position)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.fiendsThirdLegGenericUpdate, EffectVariant.SMALL_ROCKET)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.fiendsThirdLegGenericUpdate, EffectVariant.TECH_DOT)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.fiendsThirdLegGenericUpdate, EffectVariant.BRIMSTONE_SWIRL)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.fiendsThirdLegGenericUpdate, EffectVariant.BRIMSTONE_BALL)

function mod:fiendThirdLegKnife(v)
    if TearFlagsLib.HasTearFlags(v, flag) then
		if v:IsFlying() and v.FrameCount % 2 == 0 then
            spawnFiendsThirdLegCreep(v, v.Position)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, mod.fiendThirdLegKnife)

function mod:fiendsThirdLegSword(sword)
	if sword.SubType == 4 or not TearFlagsLib.IsEntitySpiritSword(sword) then return end
	
	if sword:GetIsSwinging() then
		if TearFlagsLib.HasTearFlags(sword, flag) then
			local capsule = mod:getSwordCapsules(sword)
			local capsuleStart, capsuleEnd = capsule:GetVec2(), capsule:GetVec3()
			local dir = capsuleStart - capsuleEnd
			local dist = dir:Length()
			if dist > 0 then
				local distRemaining = dist + capsule:GetF1() * 2
				while distRemaining > 0 do
					spawnFiendsThirdLegCreep(sword, capsuleEnd + dir:Resized(dist - distRemaining + capsule:GetF1()))
					distRemaining = distRemaining - 20
				end
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, mod.fiendsThirdLegSword)

function mod:fiendsThirdLegLaser(laser)
	local hasThirdLeg = TearFlagsLib.HasTearFlags(laser, flag)
	local data = mod:GetEntityData(laser)
	if hasThirdLeg and (laser.FrameCount <= 1 or not laser.OneHit) and not data.DidFiendsThirdLegOneShot then
		if Isaac.CountEntities(nil, 1000, EffectVariant.PLAYER_CREEP_BLACK, -1) < 100 or laser.FrameCount % 3 == 0 then
			local samples = TearFlagsLib.GetLaserSampleCapsules(laser)
			local distToUse = 0
			for _, sample in ipairs(samples) do
				local locus1 = sample.Locus1
				local locus2 = sample.Locus2
				local distRemaining = locus1:Distance(locus2)
				local usedDist = 0
				while (distRemaining > 0) do
					local distUsing = math.min(distToUse, distRemaining)
					usedDist = usedDist + distUsing
					distRemaining = distRemaining - distUsing
					distToUse = distToUse - distUsing
					if distToUse <= 0 then
						spawnFiendsThirdLegCreep(laser, locus1 + (locus2 - locus1):Resized(usedDist))
						distToUse = distToUse + 20
					end
				end
				data.DidFiendsThirdLegOneShot = laser.OneHit
			end
		end
	end
	if not hasThirdLeg then
		data.DidFiendsThirdLegOneShot = nil
	end
end
mod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, mod.fiendsThirdLegLaser)

function mod:fiendsThirdLegEpicFetus(target)
	local player = TearFlagsLib.GetTearPlayer(target)
	if player and player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.FIENDS_THIRD_LEG) and target.FrameCount % 2 == 0 then
		spawnFiendsThirdLegCreep(target, target.Position)
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, FiendFolio.ITEM.COLLECTIBLE.FIENDS_THIRD_LEG, mod.fiendsThirdLegEpicFetus, EffectVariant.TARGET)

function mod:fiendsThirdLegTearSplat(tear1)
    if TearFlagsLib.HasTearFlags(tear1, flag) then
        local tear = tear1:ToTear()
        local pitch = ((60-tear.Scale*10)+100)/100
        sfx:Play(mod.Sounds.AceVenturaLaugh, 0.6, 0, false, pitch)
        local splat = Isaac.Spawn(1000, 16, 4, tear.Position, Vector.Zero, tear)
        local color = Color(0.3,0.5,1,1,0.35,0.15,0.35)
        color:SetColorize(1,1,2,1)
        splat.Color = color
        splat.SpriteScale = Vector(tear.Scale/2, tear.Scale/2)
		local spawner = tear.SpawnerEntity
		if not spawner then
			spawner = Isaac.GetPlayer(0)
		elseif spawner:ToFamiliar() then
			spawner = spawner:ToFamiliar().Player
			if not spawner then
				spawner = Isaac.GetPlayer(0)
			end
		end
        local spood = Isaac.Spawn(5, FiendFolio.PICKUP.VARIANT.FIEND_MINION, 2, tear.Position, Vector.Zero, spawner)
		spood.Parent = spawner
		--mod:GetEntityData(spood).hollow = true
        local isActiveRoom = mod.IsActiveRoom()
        if not isActiveRoom then
			mod:GetEntityData(spood).mixPersistent = true
			mod:GetEntityData(spood).mixRemainingRooms = 1
			spood:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
		end
		spood:Update()
    end
end
mod:AddCallback(ModCallbacks.MC_POST_TEAR_DEATH, mod.fiendsThirdLegTearSplat)

function mod:fiendsThirdLegBombExplode(pos, radius, flags, source, radiusMult)
	if source and (source.Type == EntityType.ENTITY_BOMB or (source.Type == EntityType.ENTITY_EFFECT and (source.Variant == EffectVariant.ROCKET or source.Variant == EffectVariant.SMALL_ROCKET))) and 
	   TearFlagsLib.HasTearFlags(source, flag)
	then
		local data = mod:GetEntityData(source)
		local frame = game:GetFrameCount()
		if data.LastFrameFiendsThirdLeg == frame then return end
		data.LastFrameFiendsThirdLeg = frame
		
		local scale = radius * radiusMult / 75
        sfx:Play(mod.Sounds.AceVenturaLaugh, 0.6, 0, false, math.max(0.5, math.min(1.6, 2 - scale)))
        local splat = Isaac.Spawn(1000, 16, 4, source.Position, Vector.Zero, source)
        local color = Color(0.3,0.5,1,1,0.35,0.15,0.35)
        color:SetColorize(1,1,2,1)
        splat.Color = color
        splat.SpriteScale = Vector(scale, scale)
        local spood = Isaac.Spawn(5, FiendFolio.PICKUP.VARIANT.FIEND_MINION, 2, source.Position, Vector.Zero, source.SpawnerEntity)
		spood.Parent = source.SpawnerEntity
		--mod:GetEntityData(spood).hollow = true
        local isActiveRoom = mod.IsActiveRoom()
        if not isActiveRoom then
			mod:GetEntityData(spood).mixPersistent = true
			mod:GetEntityData(spood).mixRemainingRooms = 1
			spood:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
		end
        spood.SpriteScale = Vector(2,2) * scale
        spood.Size = spood.Size*2 * scale
		spood:Update()
    end
end
mod:AddCallback(ModCallbacks.MC_POST_BOMB_TEARFLAG_EFFECTS, mod.fiendsThirdLegBombExplode)

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

function mod:applyFiendsThirdLegFlag(entity, player, source, weaponFlag, params, hitbox)
	if source.Type ~= EntityType.ENTITY_BOMB and 
	   (source.Type ~= EntityType.ENTITY_TEAR or source:ToTear():HasTearFlags(TearFlags.TEAR_LUDOVICO)) and 
	   not (source.Type == EntityType.ENTITY_EFFECT and (source.Variant == EffectVariant.ROCKET or source.Variant == EffectVariant.SMALL_ROCKET)) and 
	   TearFlagsLib.HasTearFlags(source, flag) 
	then
		-- if i didnt already have all this code from immoral friend bullets i would not be bothering with this
		local pos = source.Position
		if source.Type == EntityType.ENTITY_LASER then
			pos = movePosToClosestLaserSegment(entity.Position, source:ToLaser())
		end
		if weaponFlag == TearFlagsLib.WeaponFlag.CLUB and source.SubType == 4 then
			local capsulePosition, capsuleRadius = TearFlagsLib.GetSwingingKnifeCapsulePositionRadius(source)
			pos = (capsulePosition - entity.Position):Resized(entity.Size * math.max(entity.SizeMulti.X, entity.SizeMulti.Y)) + entity.Position
		end
		if weaponFlag == TearFlagsLib.WeaponFlag.FF_PROVIDENCE_LASER then
			pos = entity.Position
		end
		if weaponFlag == TearFlagsLib.WeaponFlag.SWORD then
			local hitboxCapsuleA, hitboxCapsuleB = mod:getSwordCapsules((hitbox or source):ToKnife())
			local entityCapsule = entity:GetCollisionCapsule()
			
			pos = Vector(0,0)
			if not (hitboxCapsuleA:GetF1() > 0 and hitboxCapsuleA:Collide(entityCapsule, pos)) then
				if not (hitboxCapsuleB:GetF1() > 0 and hitboxCapsuleB:Collide(entityCapsule, pos)) then
					if hitboxCapsuleA:GetF1() > 0 and hitboxCapsuleB:GetF1() > 0 then
						return
					else
						local queryPos, queryRadius
						if hitboxCapsuleB:GetF1() <= 0 then
							queryPos = hitboxCapsuleA:GetPosition()
							queryRadius = hitboxCapsuleA:GetF1() + hitboxCapsuleA:GetF2()
						else
							local hitboxCapsuleDist = hitboxCapsuleA:GetPosition():Distance(hitboxCapsuleB:GetPosition())
							queryPos = hitboxCapsuleA:GetPosition()
							queryRadius = (hitboxCapsuleDist + hitboxCapsuleA:GetF1() + hitboxCapsuleA:GetF2() + hitboxCapsuleB:GetF1() + hitboxCapsuleB:GetF2()) * 0.5
							if 0.0 < hitboxCapsuleDist then
								local posOffsetFactor = queryRadius - (hitboxCapsuleA:GetF1() + hitboxCapsuleA:GetF2())
								queryPos = hitboxCapsuleA:GetPosition() + (posOffsetFactor * (hitboxCapsuleB:GetPosition() - hitboxCapsuleA:GetPosition())) / hitboxCapsuleDist
							end
						end
						local queryCapsule = Capsule(queryPos, queryPos, queryRadius)
						
						if not queryCapsule:Collide(entityCapsule, pos) then
							return
						else
							pos = mod:getCapsuleCollisionPoint(queryCapsule, entityCapsule)
						end
					end
				else
					pos = mod:getCapsuleCollisionPoint(hitboxCapsuleB, entityCapsule)
				end
			else
				pos = mod:getCapsuleCollisionPoint(hitboxCapsuleA, entityCapsule)
			end
		end
		
		sfx:Play(mod.Sounds.AceVenturaLaugh, 0.6, 0, false, 1.5)
        local splat = Isaac.Spawn(1000, 16, 4, pos, Vector.Zero, player)
        local color = Color(0.3,0.5,1,1,0.35,0.15,0.35)
        color:SetColorize(1,1,2,1)
        splat.Color = color
        splat.SpriteScale = Vector(0.5, 0.5)
        local spood = Isaac.Spawn(5, FiendFolio.PICKUP.VARIANT.FIEND_MINION, 2, pos, Vector.Zero, player)
		spood.Parent = player
        local isActiveRoom = mod.IsActiveRoom()
        if not isActiveRoom then
			mod:GetEntityData(spood).mixPersistent = true
			mod:GetEntityData(spood).mixRemainingRooms = 1
			spood:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
		end
		spood:Update()
	end
end
mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, mod.applyFiendsThirdLegFlag, flag)

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.FIENDS_THIRD_LEG] = {
	FireCooldown = 11,
	TearDamage = 11.65,
	TearColor = fiendsThirdLegColor,
	BodyColor = Color(1,1,1,1,-25.097/255,-31.761/255,-18.434/255,0.796,0.681,0.912,1),
	EyeAColor = Color(1,1,1,1,-9.779/255,-6.186/255,-14.339/255,0.372,0.248,0.585,1),
	EyeBColor = Color(1,1,1,1,-9.779/255,-6.186/255,-14.339/255,0.372,0.248,0.585,1)}

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	tear.TearFlags = tear.TearFlags | TearFlags.TEAR_HOMING
    TearFlagsLib.AddTearFlags(tear, flag)
end, FiendFolio.ITEM.COLLECTIBLE.FIENDS_THIRD_LEG)