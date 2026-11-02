local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local statusflag = mod:RegisterEnemyStatusEffect("MULTIEUCLIDEAN", 0, "multiEuclideanOnUpdate", {Vasculitis = "multiEuclideanOnVasculitis"})
local tearflag = TearFlagsLib.RegisterTearFlag("MULTIEUCLIDEAN")
local statusColorPriority = 2

function mod:handleMultiEuclidean(npc, data, sprite)
	data.FFMultiEuclideanDuration = data.FFMultiEuclideanDuration - 1
	if data.FFMultiEuclideanDuration >= 0 then
		local ptrhash = GetPtrHash(npc)
		mod.MultieuclideanEnemiesToColor[ptrhash] = {NPC = npc}

		local lasers = Isaac.FindByType(7, -1, -1, false, false)
		for _, laser in pairs(lasers) do
			laser = laser:ToLaser()
			if laser.Child and laser.Parent and laser.Parent.Type == EntityType.ENTITY_PLAYER then
				if (not mod:GetEntityData(laser).FFMultiEuclideanTearSpawner) and (not laser.OneHit or not mod:GetEntityData(laser).AlreadyDuplicatedByMultiEuclidean) then
					local endpoint = laser.Child.Position
					local laservec = (endpoint - laser.Position)
					if mod:GetEntityData(laser).AlreadyDuplicatedByMultiEuclidean then
						laservec = (laser:GetEndPoint() - laser.Position)
					end
					local npcvec = (npc.Position - laser.Position)
					if laservec:Length() > npcvec:Length() - npc.Size then
						local entryVec = laservec:Resized(npcvec:Length())
						local laserCheckPoint = laser.Position + entryVec
						if npc.Position:Distance(laserCheckPoint) <= npc.Size + laser.Size then
							--laser.Color = Color(0,1,1,1)
							if laser.OneHit then
								for i = -90, 90, 180 do
									local offsetVec = laservec:Resized(laser.Size):Rotated(i)
									local newlaser = EntityLaser.ShootAngle(laser.Variant, entryVec + offsetVec, laservec:GetAngleDegrees(), math.max(laser.Timeout, 1), laser.PositionOffset, laser.SpawnerEntity)
									newlaser.TearFlags = laser.TearFlags | TearFlags.TEAR_HOMING
									newlaser.CollisionDamage = laser.CollisionDamage
									newlaser.Color = laser.Color
									if laser.MaxDistance > 0 then
										newlaser:SetMaxDistance(math.max(1, (laser.MaxDistance + npc.Size + 10) - entryVec:Length()))
									end
									mod:GetEntityData(newlaser).AlreadyDuplicatedByMultiEuclidean = true
									mod:GetEntityData(newlaser).FFMultiEuclideanTearSpawner = npc
									newlaser.DisableFollowParent = true
									newlaser.Position = laserCheckPoint + offsetVec
									newlaser.OneHit = true
									TearFlagsLib.CopyTearFlags(newlaser, laser, TearFlagsLib.WeaponFlag.LASER, {wipe = true})
									newlaser:Update()
								end
								mod:GetEntityData(laser).AlreadyDuplicatedByMultiEuclidean = true
								laser:Remove()
							else
								local ldata = mod:GetEntityData(laser)
								if ldata.AlreadyDuplicatedByMultiEuclidean then
									if ldata.MultiEuclideanStoredLength > 0 and laser.MaxDistance > ldata.MultiEuclideanStoredLength + npc.Size + 10 then
										ldata.AlreadyDuplicatedByMultiEuclidean = 0
										laser:SetMaxDistance(ldata.MultiEuclideanStoredLength)
									else
										ldata.MultiEuclideanEntryPoint = laserCheckPoint
										--ldata.MultiEuclideanStoredLength = laser.MaxDistance
										laser:SetMaxDistance(entryVec:Length())
										ldata.AlreadyDuplicatedByMultiEuclidean = 2
									end
								else
									for i = -90, 90, 180 do
										local offsetVec = laservec:Resized(laser.Size):Rotated(i)
										local newlaser = EntityLaser.ShootAngle(laser.Variant, entryVec + offsetVec, laservec:GetAngleDegrees(), 0, laser.PositionOffset, laser.SpawnerEntity)
										newlaser.TearFlags = laser.TearFlags | TearFlags.TEAR_HOMING
										newlaser.CollisionDamage = laser.CollisionDamage
										newlaser.Color = laser.Color
										if laser.MaxDistance > 0 then
											newlaser:SetMaxDistance(math.max(1, (laser.MaxDistance + npc.Size + 10) - entryVec:Length()))
										end
										mod:GetEntityData(newlaser).AlreadyDuplicatedByMultiEuclidean = true
										mod:GetEntityData(newlaser).MultiEuclideanFatherLaser = laser
										mod:GetEntityData(newlaser).MultiEuclideanLaserOffset = i
										mod:GetEntityData(newlaser).FFMultiEuclideanTearSpawner = npc
										newlaser.DisableFollowParent = true
										newlaser.Position = laserCheckPoint + offsetVec
										TearFlagsLib.CopyTearFlags(newlaser, laser, TearFlagsLib.WeaponFlag.LASER, {wipe = true})
										newlaser:Update()
									end
									ldata.MultiEuclideanStoredLength = laser.MaxDistance
									laser:SetMaxDistance(entryVec:Length())
									ldata.MultiEuclideanEntryPoint = laserCheckPoint
									ldata.AlreadyDuplicatedByMultiEuclidean = 2
								end
							end
						end
					end
				end
			end
		end
    end
end

mod:AddPriorityCallback(ModCallbacks.MC_PRE_LASER_UPDATE, CallbackPriority.LATE, function(_, laser)
	local data = mod:GetEntityData(laser)
	if data.MultiEuclideanFatherLaser and data.MultiEuclideanFatherLaser:Exists() then
		laser.TearFlags = data.MultiEuclideanFatherLaser.TearFlags
		TearFlagsLib.CopyTearFlags(laser, data.MultiEuclideanFatherLaser, TearFlagsLib.WeaponFlag.LASER, {wipe = true})
	end
end)

local LUM_R, LUM_G, LUM_B = 0.212671, 0.715160, 0.072169 -- luminance factors used for colorize operation
function mod:colorMultieuclideanEnemies()
	for k, npcInfo in pairs(mod.MultieuclideanEnemiesToColor) do
		local currcolor = npcInfo.NPC:GetSprite().Color
		local currcolorize = currcolor:GetColorize()
		local currRT, currGT, currBT = currcolor.R, currcolor.G, currcolor.B
		local currRO, currGO, currBO = currcolor.RO, currcolor.GO, currcolor.BO
		local currRC, currGC, currBC, currAC = currcolorize.R, currcolorize.G, currcolorize.B, currcolorize.A

        local s = math.sin(game:GetFrameCount()/20*math.pi)
		-- colour setup so multieuclidean color is applied to the sprite first, then the sprite color to that result
		-- note these factors are specific to base colour with colorize alpha 1
        local multiEuclidColor =
			Color(-s*2, -s*2, -s*2, currcolor.A,
			      ((s+1) / 2) * (currRT * (1 - currAC + LUM_R * currRC * currAC) + currGT * LUM_G * currRC * currAC                + currBT * LUM_B * currRC * currAC)                + currRO,
			      ((s+1) / 2) * (currRT * LUM_R * currGC * currAC                + currGT * (1 - currAC + LUM_G * currGC * currAC) + currBT * LUM_B * currGC * currAC)                + currGO,
			      ((s+1) / 2) * (currRT * LUM_R * currBC * currAC                + currGT * LUM_G * currBC * currAC                + currBT * (1 - currAC + LUM_B * currBC * currAC)) + currBO,
			      currRT * (1 - currAC + LUM_R * currRC * currAC) + currGT * LUM_G * currRC * currAC                + currBT * LUM_B * currRC * currAC,
			      currRT * LUM_R * currGC * currAC                + currGT * (1 - currAC + LUM_G * currGC * currAC) + currBT * LUM_B * currGC * currAC,
			      currRT * LUM_R * currBC * currAC                + currGT * LUM_G * currBC * currAC                + currBT * (1 - currAC + LUM_B * currBC * currAC),
			      1)
        npcInfo.NPC:SetColor(multiEuclidColor, 1, statusColorPriority, false, false)

		mod.MultieuclideanEnemiesToColor[k] = nil
	end
end

mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, function(_, tear, entity, mysteryBoolean)
	local tdata = mod:GetEntityData(tear)
    local spawnerEntity = tdata.FFMultiEuclideanTearSpawner

    if spawnerEntity and spawnerEntity:Exists() then
		if spawnerEntity.Index == entity.Index and spawnerEntity.InitSeed == entity.InitSeed then
			return true
		elseif mod:isSegmented(spawnerEntity) and mod:isInSegmentsOf(entity, spawnerEntity) then
			return true
		elseif mod:isBasegameSegmented(spawnerEntity) and mod:isInBasegameSegmentsOf(entity, spawnerEntity) then
			return true
        end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_TEAR_COLLISION, function(_, tear, entity, mysteryBoolean)
	local tdata = mod:GetEntityData(tear)
    local spawnerEntity = tdata.FFMultiEuclideanTearSpawner
	local data = mod:GetEntityData(entity)

    if spawnerEntity and spawnerEntity:Exists() then
		if spawnerEntity.Index == entity.Index and spawnerEntity.InitSeed == entity.InitSeed then
			return
		elseif mod:isSegmented(spawnerEntity) and mod:isInSegmentsOf(entity, spawnerEntity) then
			return
		elseif mod:isBasegameSegmented(spawnerEntity) and mod:isInBasegameSegmentsOf(entity, spawnerEntity) then
			return
        end

    elseif tear.FrameCount >= 2
	and not tear:IsMultidimensionalTouched()
	and data.FFMultiEuclideanDuration and data.FFMultiEuclideanDuration >= 0 then
		local player
		if tear.SpawnerEntity and tear.SpawnerEntity.Type == 1 then
			player = tear.SpawnerEntity:ToPlayer()
		else
			player = Isaac.GetPlayer()
		end
		local pdata = mod:GetEntityData(player)

		pdata.cannotFireMoreSlippyTears = true
		for i = -90, 90, 180 do
			local offsetVec = tear.Velocity:Resized(tear.Size):Rotated(i)
			local newtear = tear:MakeMultidimensionalCopy()
			newtear.Position = tear.Position + offsetVec
			newtear.Velocity = tear.Velocity

			newtear.SpawnerEntity = tear.SpawnerEntity
			newtear.SpawnerType = tear.SpawnerType
			newtear.SpawnerVariant = tear.SpawnerVariant

			TearFlagsLib.AddTearFlags(newtear, TearFlagsLib.Flag.YIN_YANG)
			if newtear.Variant ~= tear.Variant then
				newtear:ChangeVariant(tear.Variant)
			end
			mod:GetEntityData(newtear).FFMultiEuclideanTearSpawner = entity
			mod:GetEntityData(newtear).FFMultiEuclideanIgnoreEnemy = entity.InitSeed
		end
		pdata.cannotFireMoreSlippyTears = false

		tdata.FFMultiEuclideanTearSetColor = true
		tear:SetMultidimensionalTouched(true)
		tear:Remove()
	end
end)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_BOMB_COLLISION, CallbackPriority.EARLY, function(_, bomb, entity, mysteryBoolean)
	local tdata = mod:GetEntityData(bomb)
    local spawnerEntity = tdata.FFMultiEuclideanTearSpawner
	local data = mod:GetEntityData(entity)

    if tdata.FFMultiEuclideanTearSpawner and spawnerEntity and spawnerEntity:Exists() then
		if spawnerEntity.Index == entity.Index and spawnerEntity.InitSeed == entity.InitSeed then
			return true
		elseif mod:isSegmented(spawnerEntity) and mod:isInSegmentsOf(entity, spawnerEntity) then
			return true
		elseif mod:isBasegameSegmented(spawnerEntity) and mod:isInBasegameSegmentsOf(entity, spawnerEntity) then
			return true
        end
    else
        if not tdata.AlreadyDuplicatedByMultiEuclidean then
            if data.FFMultiEuclideanDuration and data.FFMultiEuclideanDuration >= 0 then
                local player
                if bomb.SpawnerEntity and bomb.SpawnerEntity.Type == 1 then
                    player = bomb.SpawnerEntity:ToPlayer()
                else
                    player = Isaac.GetPlayer()
                end
                for i = -90, 90, 180 do
                    local offsetVec = bomb.Velocity:Resized(bomb.Size):Rotated(i)
                    local newbomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, bomb.Variant, bomb.SubType, bomb.Position + offsetVec, bomb.Velocity, TearFlagsLib.GetTearPlayer(bomb) or entity):ToBomb()
					newbomb.Flags = bomb.Flags
					newbomb.CollisionDamage = bomb.CollisionDamage
					newbomb.ExplosionDamage = bomb.ExplosionDamage
					newbomb.RadiusMultiplier = bomb.RadiusMultiplier
					newbomb.IsFetus = bomb.IsFetus
					newbomb:SetFallAcceleration(bomb:GetFallAcceleration())
					newbomb:SetFallSpeed(bomb:GetFallSpeed())
					newbomb:SetPrismTouched(bomb:IsPrismTouched())
					newbomb:SetRocketAngle(bomb:GetRocketAngle())
					newbomb:SetRocketSpeed(bomb:GetRocketSpeed())
					newbomb:SetScale(bomb:GetScale())
					newbomb:SetExplosionCountdown(bomb:GetExplosionCountdown())
                    mod:GetEntityData(newbomb).FFMultiEuclideanTearSpawner = entity
                    mod:GetEntityData(newbomb).AlreadyDuplicatedByMultiEuclidean = true
					TearFlagsLib.CopyTearFlags(newbomb, bomb, TearFlagsLib.WeaponFlag.DR_FETUS, {wipe = true})
					TearFlagsLib.AddTearFlags(newbomb, TearFlagsLib.Flag.YIN_YANG)
					mod:GetEntityData(newbomb).FFMultiEuclideanIgnoreEnemy = entity.InitSeed
                end
                tdata.AlreadyDuplicatedByMultiEuclidean = true
                if not TearFlagsLib.HasTearFlags(bomb, mod.FriendBulletFlags.GRENADE) then
					bomb:Remove()
				end
            end
        end
	end
end)

--[[mod:AddCallback(ModCallbacks.MC_PRE_KNIFE_COLLISION, function(_, knife, entity, mysteryBoolean)
	local tdata = mod:GetEntityData(knife)
    local spawnerEntity = tdata.FFMultiEuclideanTearSpawner
	local data = mod:GetEntityData(entity)

    if tdata.FFMultiEuclideanTearSpawner and spawnerEntity and spawnerEntity:Exists() then
		if spawnerEntity.Index == entity.Index and spawnerEntity.InitSeed == entity.InitSeed then
			return true
		elseif mod:isSegmented(spawnerEntity) and mod:isInSegmentsOf(entity, spawnerEntity) then
			return true
		elseif mod:isBasegameSegmented(spawnerEntity) and mod:isInBasegameSegmentsOf(entity, spawnerEntity) then
			return true
        end
    else
        if not tdata.AlreadyDuplicatedByMultiEuclidean then
            if data.FFMultiEuclideanDuration and data.FFMultiEuclideanDuration >= 0 then
                local player
                if knife.SpawnerEntity and knife.SpawnerEntity.Type == 1 then
                    player = knife.SpawnerEntity:ToPlayer()
                else
                    player = Isaac.GetPlayer()
                end
                for i = -5, 5, 10 do
                    local newKnife = player:FireKnife(player, i, false, 2, 0)
                    mod:GetEntityData(newKnife).FFMultiEuclideanTearSpawner = entity
                    newknife.Velocity = Vector(10 * player.ShotSpeed,0):Rotated(knife.Rotation)
                end
                tdata.AlreadyDuplicatedByMultiEuclidean = true
            end
        end
	end
end)]]

function mod:euclideanTearUpdate(tear, tdata)
    if tdata.FFMultiEuclideanTearSpawner or mod:GetEntityData(tear).FFMultiEuclideanTearSetColor then
        local s = math.sin(game:GetFrameCount()/20*math.pi)
        local multiEuclidColor = Color(-s*2, -s*2, -s*2, 1, (s+1)/2, (s+1)/2, (s+1)/2)
        multiEuclidColor:SetColorize(1, 1, 1, 1)
        tear.Color = multiEuclidColor
    end
end

function mod:multiEuclideanPostBombUpdate(bomb, data)
    if data.FFMultiEuclideanTearSpawner then
        local s = math.sin(game:GetFrameCount()/20*math.pi)
        local multiEuclidColor = Color(-s*2, -s*2, -s*2, 1, (s+1)/2, (s+1)/2, (s+1)/2)
        multiEuclidColor:SetColorize(1, 1, 1, 1)
        bomb.Color = multiEuclidColor
    end
end

function mod:multiEuclideanLaserUpdate(player, laser, data, rng)
    if data.FFMultiEuclideanTearSpawner then
        local s = math.sin(game:GetFrameCount()/20*math.pi)
        local multiEuclidColor = Color(-s*2, -s*2, -s*2, 1, (s+1)/2, (s+1)/2, (s+1)/2)
        multiEuclidColor:SetColorize(1, 1, 1, 1)
        laser.Color = multiEuclidColor
    end
	if data.MultiEuclideanFatherLaser then
		if data.MultiEuclideanFatherLaser:Exists() and data.MultiEuclideanFatherLaser.Child then
			if mod:GetEntityData(data.MultiEuclideanFatherLaser).AlreadyDuplicatedByMultiEuclidean then
				local fathervec = data.MultiEuclideanFatherLaser.Child.Position - data.MultiEuclideanFatherLaser.Position
				local offsetPos = fathervec:Rotated(data.MultiEuclideanLaserOffset):Resized(data.MultiEuclideanFatherLaser.Size)
				--[[if mod:GetEntityData(data.MultiEuclideanFatherLaser).MultiEuclideanEntryPoint then
					laser.Position = mod:GetEntityData(data.MultiEuclideanFatherLaser).MultiEuclideanEntryPoint + offsetPos
				else]]
					laser.Position = data.MultiEuclideanFatherLaser.Child.Position + offsetPos
				--end
				local maxlength = mod:GetEntityData(data.MultiEuclideanFatherLaser).MultiEuclideanStoredLength
				local curlength = data.MultiEuclideanFatherLaser.LaserLength
				if maxlength then
					if maxlength <= 0 then
						laser:SetMaxDistance(0)
					else
						laser:SetMaxDistance(math.max(1,maxlength + 25 - curlength))
					end
				end
				laser.AngleDegrees = data.MultiEuclideanFatherLaser.AngleDegrees
				laser.LastAngleDegrees = data.MultiEuclideanFatherLaser.LastAngleDegrees
			else
				laser:Remove()
			end
		else
			laser:Remove()
		end
	elseif (not laser.OneHit) and data.AlreadyDuplicatedByMultiEuclidean then
		if tonumber(data.AlreadyDuplicatedByMultiEuclidean) then
			data.AlreadyDuplicatedByMultiEuclidean = data.AlreadyDuplicatedByMultiEuclidean - 1
			if data.AlreadyDuplicatedByMultiEuclidean <= 0 then
				if data.MultiEuclideanStoredLength then
					laser:SetMaxDistance(data.MultiEuclideanStoredLength)
					laser.LaserLength = laser.MaxDistance
				end
				data.AlreadyDuplicatedByMultiEuclidean = nil
			end
		end
	end
end



function FiendFolio.AddMultiEuclidean(entity, source, duration, isCloned)
	if not (entity and entity:ToNPC()) then
		return
	end

	if (entity.Type == EntityType.ENTITY_MASK or (entity.Type == EntityType.ENTITY_MASK_OF_INFAMY and entity.Parent)) and not isCloned then
		return
	end
	
	if Isaac.RunCallbackWithParam(ModCallbacks.MC_PRE_STATUS_EFFECT_APPLY, "FFMultiEuclidean", "FFMultiEuclidean", entity, EntityRef(source), duration) == false then
		return
	end

	if mod:isSegmented(entity) and not isCloned then
		local segments = mod:getSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.AddMultiEuclidean(segment, source, duration, true)
			end
		end
	elseif mod:isBasegameSegmented(entity) and not isCloned then
		local segments = mod:getBasegameSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.AddMultiEuclidean(segment, source, duration, true)
			end
		end
	end

	local data = mod:GetEntityData(entity)
	local isBoss = entity:IsBoss()
	if isBoss and entity:GetBossStatusEffectCooldown() > 0 then
		--do nothing
	elseif not (entity:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) or mod:isStatusBlacklisted(entity)) or
	       ((entity.Type == EntityType.ENTITY_MASK or entity.Type == EntityType.ENTITY_MASK_OF_INFAMY) and isCloned)
	then
		data.FFMultiEuclideanDuration = math.max(data.FFMultiEuclideanDuration or 0, duration)
		data.FFMultiEuclideanSource = EntityRef(source)

		if isBoss then
			entity:SetBossStatusEffectCooldown(FiendFolio.StatusEffectVariables.BossStatusResistanceFrameCount)
		end

		mod:TrackEnemyStatus(entity, statusflag)

		local ptrhash = GetPtrHash(entity)
		mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
		mod.VasculitisInfo[ptrhash][statusflag] = {Source = data.FFMultiEuclideanSource}
		
		Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_STATUS_EFFECT_APPLY, "FFMultiEuclidean", "FFMultiEuclidean", entity, EntityRef(source), duration)
	end
end

function FiendFolio.RemoveMultiEuclidean(entity, isCloned)
	if mod:isSegmented(entity) and not isCloned then
		local segments = mod:getSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.RemoveMultiEuclidean(segment, true)
			end
		end
	elseif mod:isBasegameSegmented(entity) and not isCloned then
		local segments = mod:getBasegameSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.RemoveMultiEuclidean(segment, true)
			end
		end
	end

	local data = mod:GetEntityData(entity)
	data.FFMultiEuclideanDuration = nil
	mod:UntrackEnemyStatus(entity, statusflag)

	if not (entity:IsDead() or entity:HasMortalDamage()) then
		local ptrhash = GetPtrHash(entity)
		mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
		mod.VasculitisInfo[ptrhash][statusflag] = nil
	end
end

function FiendFolio.FlagMultiEuclidean(entity, duration)
	TearFlagsLib.AddTearFlags(entity, tearflag)

	local params = TearFlagsLib.GetTearFlagParams(entity, tearflag)
	TearFlagsLib.SetTearFlagParams(entity, tearflag, {Duration = math.max(params.Duration or 0, duration)})
end

function mod:applyMultiEuclideanFlag(entity, player, source)
	-- need to get these values out first before scheduling cause otherwise they might get eaten by garbage collection
	-- happens with stuff like can of beans
	-- sucks but w/e
	local params = TearFlagsLib.GetTearFlagParams(source, tearflag)
	local duration = params.Duration

	local ptrhash = GetPtrHash(entity)
	mod.QueuedStatusApply[ptrhash] = mod.QueuedStatusApply[ptrhash] or {}
	table.insert(mod.QueuedStatusApply[ptrhash], function()
		FiendFolio.AddMultiEuclidean(entity, player, duration)
	end)
end
mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, mod.applyMultiEuclideanFlag, tearflag)

function mod.handleMultiEuclideanD3(entity)
	local params = TearFlagsLib.GetTearFlagParams(entity, tearflag)
	TearFlagsLib.SetTearFlagParams(entity, tearflag, {Duration = math.max(params.Duration or 0, 180)})
end

function mod:multiEuclideanOnVasculitis(tear, npc)
	local ptrhash = GetPtrHash(npc)
	mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}

	local vasculitisInfo = mod.VasculitisInfo[ptrhash][statusflag]
	if vasculitisInfo then
		local source = vasculitisInfo.Source
		local player = source and source.Entity and source.Entity:ToPlayer()
		local secondHandMultiplier = (player and (player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1)) or 1
		FiendFolio.FlagMultiEuclidean(tear, 180 * secondHandMultiplier)
	end
end

function mod:multiEuclideanOnUpdate(npc, data, sprite, clearingStatus)
	if data.FFMultiEuclideanDuration ~= nil and data.FFMultiEuclideanDuration > 0 and not clearingStatus then
		mod:handleMultiEuclidean(npc, data, sprite)
		--data.hasFFStatusIcon = true
	else
		data.FFMultiEuclideanDuration = nil
		mod:UntrackEnemyStatus(npc, statusflag)

		if not (npc:IsDead() or npc:HasMortalDamage()) then
			local ptrhash = GetPtrHash(npc)
			mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
			mod.VasculitisInfo[ptrhash][statusflag] = nil
		end
	end
end

function mod:copyMultiEuclidean(copy, copyData, source, sourceData)
	copyData.FFMultiEuclideanDuration = sourceData.FFMultiEuclideanDuration
	copyData.FFMultiEuclideanSource = sourceData.FFMultiEuclideanSource

	mod:TrackEnemyStatus(copy, statusflag)

	local copyPtrhash = GetPtrHash(copy)
	local sourcePtrhash = GetPtrHash(source)
	mod.VasculitisInfo[copyPtrhash] = mod.VasculitisInfo[copyPtrhash] or {}
	mod.VasculitisInfo[sourcePtrhash] = mod.VasculitisInfo[sourcePtrhash] or {}
	if mod.VasculitisInfo[sourcePtrhash][statusflag] then
		mod.VasculitisInfo[copyPtrhash][statusflag] = {Source = mod.VasculitisInfo[sourcePtrhash][statusflag].Source or copyData.FFMultiEuclideanSource}
	end
end