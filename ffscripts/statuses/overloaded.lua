-- Overloaded --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local statusflag = mod:RegisterEnemyStatusEffect("OVERLOAD", 80, "overloadedOnUpdate", {HasIcon = true, Vasculitis = "overloadedOnVasculitis"})
local tearflag = TearFlagsLib.RegisterTearFlag("OVERLOAD")
local statusColorPriority = 127
local flashColorPriority = 2

function mod:fireOverloadedLaser(entity, force, forceDamage)
	local data = mod:GetEntityData(entity)
	local helper = data.FFOverloadedLaserHelper
	if not data.FFOverloadedLaserHelper then
		helper = Isaac.Spawn(1000, 1758, 0, entity.Position, nilvector, nil):ToEffect()
		helper.Parent = entity
		helper:FollowParent(entity)
		
		data.FFOverloadedLaserHelper = helper
	end
	
	mod:GetEntityData(helper).TimesToShock = data.FFOverloadedTimesToShock
	mod:GetEntityData(helper).Source = data.FFOverloadedSource
	mod:GetEntityData(helper).Damage = data.FFOverloadedDamage
	mod:GetEntityData(helper).RestPeriod = data.FFOverloadedRestPeriod
	mod:GetEntityData(helper).ActivePeriod = data.FFOverloadedActivePeriod
	mod:GetEntityData(helper).TimesPassed = data.FFOverloadedTimesPassed
	
	if force or data.FFOverloadedFrame % FiendFolio.StatusEffectVariables.OverloadedLaserCooldown == 0 then
		local distance;
		local laserAngle;
		
		local inRadius = Isaac.FindInRadius(entity.Position,
		                                    FiendFolio.StatusEffectVariables.OverloadedLaserDistance,
		                                    EntityPartition.ENEMY)
		local targets = {}
		for _, e in ipairs(inRadius) do
			if e and e:ToNPC() and not e:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) and
			   (e.InitSeed ~= entity.InitSeed or e.Index ~= entity.Index)
			then
				table.insert(targets, e)
			end
		end
		
		if #targets > 0 then
			local target = targets[math.random(#targets)]
			laserAngle = (target.Position - entity.Position):GetAngleDegrees()
			distance = math.max((target.Position - entity.Position):Length(), FiendFolio.StatusEffectVariables.OverloadedLaserDistance / 2)
		else
			laserAngle = data.FFOverloadedLaserHelper:GetDropRNG():RandomFloat() * 360
			distance = FiendFolio.StatusEffectVariables.OverloadedLaserDistance / 2
		end
		
		local laser = EntityLaser.ShootAngle(LaserVariant.ELECTRIC,
		                                     entity.Position,
		                                     laserAngle,
		                                     1,
		                                     Vector(0,-10),
		                                     data.FFOverloadedLaserHelper)
		laser.MaxDistance = distance
		laser.Color = Color(0,0,0,1,200 / 255,200 / 255,50 / 255) -- hi zapbladder
		laser.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
		laser.CollisionDamage = data.FFOverloadedDamage or forceDamage
		laser.Mass = 0
		laser:Update()
	end
end

function mod:handleOverloaded(entity, data, sprite)
	data.FFOverloadedDuration = data.FFOverloadedDuration - 1
	if data.FFOverloadedDuration >= 0 then
		if data.FFOverloadedInActivePeriod and data.FFOverloadedFrame >= data.FFOverloadedActivePeriod then
			data.FFOverloadedFrame = 0
			data.FFOverloadedInActivePeriod = false
		elseif (not data.FFOverloadedInActivePeriod) and data.FFOverloadedFrame >= data.FFOverloadedRestPeriod then
			data.FFOverloadedFrame = 0
			data.FFOverloadedInActivePeriod = true
		end
	
		entity:SetColor(FiendFolio.StatusEffectColors.Overloaded, 1, statusColorPriority, false, false)
		
		if data.FFOverloadedInActivePeriod then
			local ptrhash = GetPtrHash(entity)
			mod.OverloadedEnemiesToColor[ptrhash] = {NPC = entity}
			
			if not entity:HasEntityFlags(EntityFlag.FLAG_FREEZE) then
				entity:AddEntityFlags(EntityFlag.FLAG_FREEZE)
				local ptrhash = GetPtrHash(entity)
				mod.HasTempStatusFlag[ptrhash] = {NPC = entity, 
				                                  FlagsToRemove = ((mod.HasTempStatusFlag[ptrhash] and mod.HasTempStatusFlag[ptrhash].FlagsToRemove) or 0) | EntityFlag.FLAG_FREEZE}
			end
			
			if not data.FFOverloadedInitialSpriteOffset then
				data.FFOverloadedInitialSpriteOffset = Vector(entity.SpriteOffset.X, entity.SpriteOffset.Y)
			end
			
			local offset = Vector(math.random() * FiendFolio.StatusEffectVariables.OverloadedMaxSpriteOffset,
			                      math.random() * FiendFolio.StatusEffectVariables.OverloadedMaxSpriteOffset)
			
			if offset:Length() > FiendFolio.StatusEffectVariables.OverloadedMaxSpriteOffset then
				offset = offset:Resized(FiendFolio.StatusEffectVariables.OverloadedMaxSpriteOffset)
			end
			
			entity.SpriteOffset = data.FFOverloadedInitialSpriteOffset + offset
			
			if data.FFOverloadedInitialPosition == nil then
				data.FFOverloadedInitialPosition = entity.Position
			end
			entity.Position = data.FFOverloadedInitialPosition
			
			if mod:checkIfStatusLogicIsApplied(entity, true, true) then
				mod:fireOverloadedLaser(entity)
			end
		else
			if data.FFOverloadedInitialSpriteOffset then
				entity.SpriteOffset = data.FFOverloadedInitialSpriteOffset
				data.FFOverloadedInitialSpriteOffset = nil
			end
			
			data.FFOverloadedInitialPosition = nil
		end
		
		data.FFOverloadedFrame = data.FFOverloadedFrame + 1
	end
end

function mod:colorOverloadedEnemies()
	for k, npcInfo in pairs(mod.OverloadedEnemiesToColor) do
		local currentColor = npcInfo.NPC:GetSprite().Color
		local newColor = Color.Lerp(currentColor, Color(1,1,1,1,0,0,0), 0)
		newColor:SetTint(currentColor.R + 0.2, currentColor.G + 0.2, currentColor.B + 0.2, currentColor.A)
		newColor:SetOffset(currentColor.RO + 40/255, currentColor.GO + 40/255, currentColor.BO + 40/255)
		npcInfo.NPC:SetColor(newColor, 1, flashColorPriority, false, false)
		mod.OverloadedEnemiesToColor[k] = nil
	end
end

function FiendFolio.AddOverloaded(entity, source, duration, timesToShock, damage, restPeriod, activePeriod, isStartingActive, ignoreBossResistance, isCloned, sourceRef)
	if not (entity and entity:ToNPC()) then
		return
	end
	
	if (entity.Type == EntityType.ENTITY_MASK or (entity.Type == EntityType.ENTITY_MASK_OF_INFAMY and entity.Parent)) and not isCloned then
		return
	end
	
	if Isaac.RunCallbackWithParam(ModCallbacks.MC_PRE_STATUS_EFFECT_APPLY, "FFOverloaded", "FFOverloaded", entity, EntityRef(source), duration) == false then
		return
	end
	
	if mod:isSegmented(entity) and not isCloned then
		local segments = mod:getSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.AddOverloaded(segment, source, duration, timesToShock, damage, restPeriod, activePeriod, isStartingActive, ignoreBossResistance, true, sourceRef)
			end
		end
	elseif mod:isBasegameSegmented(entity) and not isCloned then
		local segments = mod:getBasegameSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.AddOverloaded(segment, source, duration, timesToShock, damage, restPeriod, activePeriod, isStartingActive, ignoreBossResistance, true, sourceRef)
			end
		end
	end

	local data = mod:GetEntityData(entity)
	local isBoss = entity:IsBoss()
	if not ignoreBossResistance and isBoss and entity:GetBossStatusEffectCooldown() > 0 then
		--do nothing
	elseif not (entity:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) or mod:isStatusBlacklisted(entity)) or 
	       ((entity.Type == EntityType.ENTITY_MASK or entity.Type == EntityType.ENTITY_MASK_OF_INFAMY) and isCloned) 
	then
		data.FFOverloadedRestPeriod = math.min(data.FFOverloadedRestPeriod or math.huge, restPeriod)
		data.FFOverloadedActivePeriod = math.max(data.FFOverloadedActivePeriod or 0, activePeriod)
		
		local calculatedDuration = duration
		if (duration or 0) <= 0 then
			if data.FFOverloadedDuration ~= nil then
				if data.FFOverloadedInActivePeriod then
					calculatedDuration = ((data.FFOverloadedRestPeriod + data.FFOverloadedActivePeriod) * timesToShock) + (data.FFOverloadedActivePeriod - math.min(data.FFOverloadedFrame, data.FFOverloadedActivePeriod))
				else
					calculatedDuration = ((data.FFOverloadedRestPeriod + data.FFOverloadedActivePeriod) * timesToShock) - math.min(data.FFOverloadedFrame, data.FFOverloadedRestPeriod)
				end
			else
				if isStartingActive then
					calculatedDuration = data.FFOverloadedActivePeriod * timesToShock + data.FFOverloadedRestPeriod * (timesToShock - 1)
				else
					calculatedDuration = (data.FFOverloadedRestPeriod + data.FFOverloadedActivePeriod) * timesToShock
				end
			end
		end
		
		data.FFOverloadedDuration = math.max(data.FFOverloadedDuration or 0, calculatedDuration)
		data.FFOverloadedDamage = math.max(data.FFOverloadedDamage or 0, damage)
		data.FFOverloadedSource = sourceRef or EntityRef(source)
		
		if not data.FFOverloadedInitialized then
			data.FFOverloadedFrame = 0
			data.FFOverloadedInActivePeriod = isStartingActive or false
			data.FFOverloadedInitialized = true
		end
		
		data.FFOverloadedTimesPassed = math.max(data.FFOverloadedTimesPassed or 0, timesPassed or 0)
		data.FFOverloadedTimesToShock = math.max(data.FFOverloadedTimesToShock or 0, timesToShock)
		
		if not ignoreBossResistance and isBoss then
			entity:SetBossStatusEffectCooldown(FiendFolio.StatusEffectVariables.BossStatusResistanceFrameCount + calculatedDuration)
		end
		
		mod:TrackEnemyStatus(entity, statusflag)
		
		local ptrhash = GetPtrHash(entity)
		mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
		mod.VasculitisInfo[ptrhash][statusflag] = {Source = data.FFOverloadedSource, TimesPassed = data.FFOverloadedTimesPassed}
		
		Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_STATUS_EFFECT_APPLY, "FFOverloaded", "FFOverloaded", entity, EntityRef(source), duration)
	end
end

function FiendFolio.RemoveOverloaded(entity, isCloned)
	if mod:isSegmented(entity) and not isCloned then
		local segments = mod:getSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.RemoveOverloaded(segment, true)
			end
		end
	elseif mod:isBasegameSegmented(entity) and not isCloned then
		local segments = mod:getBasegameSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.RemoveOverloaded(segment, true)
			end
		end
	end

	local data = mod:GetEntityData(entity)
	data.FFOverloadedDuration = nil
	data.FFOverloadedDamage = nil
	data.FFOverloadedRestPeriod = nil
	data.FFOverloadedActivePeriod = nil
	data.FFOverloadedInitialized = nil
	data.FFOverloadedInitialPosition = nil
	if data.FFOverloadedInitialSpriteOffset then
		entity.SpriteOffset = data.FFOverloadedInitialSpriteOffset
		data.FFOverloadedInitialSpriteOffset = nil
	end
	if data.FFOverloadedLaserHelper and data.FFOverloadedLaserHelper:Exists() then
		data.FFOverloadedLaserHelper:Remove()
	end
	data.FFOverloadedLaserHelper = nil
	data.FFOverloadedTimesPassed = nil
	data.FFOverloadedTimesToShock = nil
	mod:UntrackEnemyStatus(entity, statusflag)
	
	if not (entity:IsDead() or entity:HasMortalDamage()) then
		local ptrhash = GetPtrHash(entity)
		mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
		mod.VasculitisInfo[ptrhash][statusflag] = nil
	end
end

function FiendFolio.FlagOverload(entity, timesToShock, damage, restPeriod, activePeriod, timesPassed)
	TearFlagsLib.AddTearFlags(entity, tearflag)
	
	local params = TearFlagsLib.GetTearFlagParams(entity, tearflag)
	TearFlagsLib.SetTearFlagParams(entity, tearflag, {TimesToShock = math.max(params.TimesToShock or 0, timesToShock),
	                                                  Damage = math.max(params.Damage or 0, damage),
	                                                  RestPeriod = math.min(params.RestPeriod or math.huge, restPeriod),
	                                                  ActivePeriod = math.max(params.ActivePeriod or 0, activePeriod),
	                                                  TimesPassed = math.min(params.TimesPassed or math.huge, timesPassed or 0)})
end

function mod:applyOverloadFlag(entity, player, source)
	local params = TearFlagsLib.GetTearFlagParams(source, tearflag)
	FiendFolio.AddOverloaded(entity, player, 0, params.TimesToShock, params.Damage, params.RestPeriod, params.ActivePeriod, true)
end
mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, mod.applyOverloadFlag, tearflag)

function mod.handleOverloadD3(entity)
	local player = TearFlagsLib.GetTearPlayer(entity)
	local params = TearFlagsLib.GetTearFlagParams(entity, tearflag)
	TearFlagsLib.SetTearFlagParams(entity, tearflag, {TimesToShock = math.max(params.TimesToShock or 0, 4),
	                                                  Damage = math.max(params.Damage or 0, ((player and player.Damage) or 3.5) * 0.4),
	                                                  RestPeriod = math.min(params.RestPeriod or math.huge, 45),
	                                                  ActivePeriod = math.max(params.ActivePeriod or 0, 15),
	                                                  TimesPassed = math.min(params.TimesPassed or math.huge, 0)})
end

function mod:overloadedOnVasculitis(tear, npc)
	local ptrhash = GetPtrHash(npc)
	mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
	
	local vasculitisInfo = mod.VasculitisInfo[ptrhash][statusflag]
	if vasculitisInfo then
		local source = vasculitisInfo.Source
		local player = source and source.Entity and source.Entity:ToPlayer()
		local secondHandMultiplier = (player and (player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1)) or 1
		FiendFolio.FlagOverload(tear, 3 * secondHandMultiplier, player.Damage * 0.4, 45, 15, vasculitisInfo.TimesPassed)
	end
end

function mod:overloadedOnUpdate(npc, data, sprite, clearingStatus)
	if data.FFOverloadedDuration ~= nil and data.FFOverloadedDuration > 0 and not clearingStatus then
		mod:handleOverloaded(npc, data, sprite)
		data.hasFFStatusIcon = true
	else
		data.FFOverloadedDuration = nil
		data.FFOverloadedDamage = nil
		data.FFOverloadedRestPeriod = nil
		data.FFOverloadedActivePeriod = nil
		data.FFOverloadedInitialized = nil
		data.FFOverloadedInitialPosition = nil
		if data.FFOverloadedInitialSpriteOffset then
			npc.SpriteOffset = data.FFOverloadedInitialSpriteOffset
			data.FFOverloadedInitialSpriteOffset = nil
		end
		if data.FFOverloadedLaserHelper and data.FFOverloadedLaserHelper:Exists() then
			data.FFOverloadedLaserHelper:Remove()
		end
		data.FFOverloadedLaserHelper = nil
		data.FFOverloadedTimesPassed = nil
		data.FFOverloadedTimesToShock = nil
		mod:UntrackEnemyStatus(npc, statusflag)
		
		if not (npc:IsDead() or npc:HasMortalDamage()) then
			local ptrhash = GetPtrHash(npc)
			mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
			mod.VasculitisInfo[ptrhash][statusflag] = nil
		end
	end
end

function mod:copyOverloaded(copy, copyData, source, sourceData)
	copyData.FFOverloadedDuration = sourceData.FFOverloadedDuration
	copyData.FFOverloadedDamage = sourceData.FFOverloadedDamage
	copyData.FFOverloadedSource = sourceData.FFOverloadedSource
	copyData.FFOverloadedRestPeriod = sourceData.FFOverloadedRestPeriod
	copyData.FFOverloadedActivePeriod = sourceData.FFOverloadedActivePeriod
	copyData.FFOverloadedFrame = sourceData.FFOverloadedFrame
	copyData.FFOverloadedInActivePeriod = sourceData.FFOverloadedInActivePeriod
	copyData.FFOverloadedInitialized = sourceData.FFOverloadedInitialized
	copyData.FFOverloadedTimesPassed = sourceData.FFOverloadedTimesPassed
	copyData.FFOverloadedTimesToShock = sourceData.FFOverloadedTimesToShock
	
	mod:TrackEnemyStatus(copy, statusflag)
	
	local copyPtrhash = GetPtrHash(copy)
	local sourcePtrhash = GetPtrHash(source)
	mod.VasculitisInfo[copyPtrhash] = mod.VasculitisInfo[copyPtrhash] or {}
	mod.VasculitisInfo[sourcePtrhash] = mod.VasculitisInfo[sourcePtrhash] or {}
	if mod.VasculitisInfo[sourcePtrhash][statusflag] then
		mod.VasculitisInfo[copyPtrhash][statusflag] = {Source = mod.VasculitisInfo[sourcePtrhash][statusflag].Source or copyData.FFOverloadedSource,
		                                               TimesPassed = mod.VasculitisInfo[sourcePtrhash][statusflag].TimesPassed or copyData.FFOverloadedTimesPassed}
	end
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, helper)
	if helper.Parent then
		local data = mod:GetEntityData(helper.Parent)
		if data.FFOverloadedDuration == nil then
			helper:Remove()
		end
	else
		helper:Remove()
	end
end, 1758)

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, player, damage, flags, source, countdown)
	if source.Type == 1000 and source.Variant == 1758 then
		return false
	end
end, EntityType.ENTITY_PLAYER)

mod:AddPreNpcTakeDmgFromSourceCallback(function(_, entity, entityData, damage, flags, sourceEnt, data, sourceRef)
	if flags & DamageFlag.DAMAGE_LASER == DamageFlag.DAMAGE_LASER then
		local parent = sourceEnt.Parent
		if parent and parent.Index == entity.Index and parent.InitSeed == entity.InitSeed then
			return false
		end
	end
end, 1000, 1758)

mod:AddPostNpcTakeDmgFromSourceCallback(function(_, entity, entityData, damage, flags, sourceEnt, data, sourceRef)
	if flags & DamageFlag.DAMAGE_LASER == DamageFlag.DAMAGE_LASER and
	   data.TimesPassed ~= nil and 
	   (data.TimesToShock / 2) >= 1
	then
		local rng = sourceEnt:GetDropRNG()
		
		if rng:RandomFloat() <= FiendFolio.StatusEffectVariables.OverloadedPassChance then
			FiendFolio.AddOverloaded(entity, nil, 0, math.floor(data.TimesToShock / 2), data.Damage, data.RestPeriod, data.ActivePeriod, false, nil, nil, data.Source)
		end
	end
end, 1000, 1758)
