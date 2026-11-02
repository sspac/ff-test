-- Drowsy and Sleep --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local statusflag = mod:RegisterEnemyStatusEffect("DROWSY", 90, "drowsySleepOnUpdate", {HasIcon = true, Vasculitis = "drowsyOnVasculitis"})
local tearflag = TearFlagsLib.RegisterTearFlag("DROWSY")
local statusColorPriority = 124

local function canCollideWithTears(entity)
	return entity.EntityCollisionClass == EntityCollisionClass.ENTCOLL_PLAYEROBJECTS or entity.EntityCollisionClass == EntityCollisionClass.ENTCOLL_ALL
end

function mod.hasCollidablePart(entity)
	if mod:isSegmented(entity) then
		local segments = mod:getSegments(entity)

		for _,segment in ipairs(segments) do
			if canCollideWithTears(segment) then
				return true
			end
		end
		return false
	elseif mod:isBasegameSegmented(entity) then
		local segments = mod:getBasegameSegments(entity)

		for _,segment in ipairs(segments) do
			if canCollideWithTears(segment) then
				return true
			end
		end
		return false
	else
		return canCollideWithTears(entity)
	end
end

function mod:handleDrowsy(entity, data, sprite)
	data.FFDrowsyDuration = data.FFDrowsyDuration - 1
	
	local hasCollidablePart = mod.hasCollidablePart(entity)
	if data.FFDrowsyDuration <= 0 and data.FFSleepDuration ~= nil and not hasCollidablePart and not data.FFNightmare then
		data.FFSleepDuration = data.FFSleepDuration - 1
		if data.FFSleepDuration > 0 then
			data.FFDrowsyDuration = 1
		end
	end
	
	if data.FFNightmare then
		if data.FFHasDoom then
			mod:handleDoom(entity, data, sprite)
			if data.FFDrowsyDuration == nil then
				return
			end
		end
	end
	
	local ptrhash = GetPtrHash(entity)
	if entity.HitPoints <= 0 and entity.MaxHitPoints ~= 0 then
		mod:clearDrowsySleep(entity, data)
		return
	elseif data.FFDrowsyDuration >= 0 then
		mod.DrowsyEnemiesToColor[ptrhash] = {NPC = entity,
											 LerpAmount = data.FFDrowsyDuration / data.FFDrowsyDurationMax}
	end
	
	if data.FFDrowsyDuration ~= nil and data.FFDrowsyDuration <= 0 and data.FFSleepDuration ~= nil and data.FFSleepDuration >= 0 then
		mod:handleSleep(entity, data, sprite, true)
		return
	end
	
	local animMoveMult = math.max(0, data.FFDrowsyDuration / data.FFDrowsyDurationMax)
	if not hasCollidablePart then
		animMoveMult = math.max(animMoveMult, 0.66)
	end
	mod.HasAnimAndMoveMulti[ptrhash] = mod.HasAnimAndMoveMulti[ptrhash] or {}
	mod.HasAnimAndMoveMulti[ptrhash].NPC = entity
	mod.HasAnimAndMoveMulti[ptrhash].Mult = (mod.HasAnimAndMoveMulti[ptrhash].Mult or 1) * animMoveMult
end

function FiendFolio.AddDrowsy(entity, source, duration, sleepDuration, nightmareCountdown, nightmareDamageMult, isCloned, forcedNightmareDamage)
	if not (entity and entity:ToNPC()) then
		return
	end
	
	if (entity.Type == EntityType.ENTITY_MASK or (entity.Type == EntityType.ENTITY_MASK_OF_INFAMY and entity.Parent)) and not isCloned then
		return
	end
	
	if Isaac.RunCallbackWithParam(ModCallbacks.MC_PRE_STATUS_EFFECT_APPLY, "FFDrowsy", "FFDrowsy", entity, EntityRef(source), duration) == false then
		return
	end
	if Isaac.RunCallbackWithParam(ModCallbacks.MC_PRE_STATUS_EFFECT_APPLY, "FFSleep", "FFSleep", entity, EntityRef(source), duration) == false then
		return
	end
	
	if mod:isSegmented(entity) and not isCloned then
		local segments = mod:getSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.AddDrowsy(segment, source, duration, sleepDuration, nightmareCountdown, nightmareDamageMult, true, forcedNightmareDamage)
			end
		end
	elseif mod:isBasegameSegmented(entity) and not isCloned then
		local segments = mod:getBasegameSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.AddDrowsy(segment, source, duration, sleepDuration, nightmareCountdown, nightmareDamageMult, true, forcedNightmareDamage)
			end
		end
	end

	local data = mod:GetEntityData(entity)
	local isBoss = entity:IsBoss()
	if data.FFNightmare and data.FFDoomCountdown ~= nil and data.FFDoomCountdown <= 0 then
		--do nothing
	elseif isBoss and entity:GetBossStatusEffectCooldown() > 0 then
		--do nothing
	elseif not (entity:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) or mod:isStatusBlacklisted(entity)) or 
	       ((entity.Type == EntityType.ENTITY_MASK or entity.Type == EntityType.ENTITY_MASK_OF_INFAMY) and isCloned) 
	then
		if not (data.FFIsAsleep or data.FFDrowsyDuration ~= nil) then
			data.FFDrowsyDuration = duration
			data.FFDrowsyDurationMax = duration
		end

		data.FFSleepDuration = math.max(data.FFSleepDuration or 0, sleepDuration)
		data.FFDrowsySource = EntityRef(source)
		data.FFSleepSource = EntityRef(source)
		data.FFSleepTriggered = false
		
		if forcedNightmareDamage or PlayerManager.AnyoneHasCollectible(mod.ITEM.COLLECTIBLE.SPIRIT_OF_NIGHTMARE) then
			data.FFNightmare = true
			data.FFNightmareCountdown = math.max(data.FFNightmareCountdown or 0, nightmareCountdown or 4)

			local nightmarePassiveCountdown = math.floor(sleepDuration / (nightmareCountdown or 4))
			data.FFNightmarePassiveCountdown = math.min(data.FFNightmarePassiveCountdown or math.huge, nightmarePassiveCountdown)
			
			local dam = 0
			for i=1,Game():GetNumPlayers() do
				local player = Isaac.GetPlayer(i-1)
				if player:HasCollectible(mod.ITEM.COLLECTIBLE.SPIRIT_OF_NIGHTMARE) then
					local mult = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.SPIRIT_OF_NIGHTMARE)
					dam = dam+player.Damage*mult
				end
			end
			dam = math.max(dam, forcedNightmareDamage or 0)
			data.FFNightmareDamage = math.max(data.FFNightmareDamage or 0, dam * (nightmareDamageMult or 4))
		end
		
		if isBoss then
			entity:SetBossStatusEffectCooldown(FiendFolio.StatusEffectVariables.BossStatusResistanceFrameCount)
		end
		
		mod:TrackEnemyStatus(entity, statusflag)
		
		local ptrhash = GetPtrHash(entity)
		mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
		mod.VasculitisInfo[ptrhash][statusflag] = {Source = data.FFDrowsySource}
		
		Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_STATUS_EFFECT_APPLY, "FFDrowsy", "FFDrowsy", entity, EntityRef(source), duration)
		Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_STATUS_EFFECT_APPLY, "FFSleep", "FFSleep", entity, EntityRef(source), duration)
	end
end

function FiendFolio.RemoveDrowsy(entity, isCloned)
	if mod:isSegmented(entity) and not isCloned then
		local segments = mod:getSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.RemoveDrowsy(segment, true)
			end
		end
	elseif mod:isBasegameSegmented(entity) and not isCloned then
		local segments = mod:getBasegameSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.RemoveDrowsy(segment, true)
			end
		end
	end

	local data = mod:GetEntityData(entity)
	data.FFDrowsyDuration = nil
	data.FFSleepDuration = nil
	data.FFNightmare = nil
	data.FFSleepTriggered = nil
	mod:UntrackEnemyStatus(entity, statusflag)
	
	if not (entity:IsDead() or entity:HasMortalDamage()) then
		local ptrhash = GetPtrHash(entity)
		mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
		mod.VasculitisInfo[ptrhash][statusflag] = nil
	end

	entity:GetSprite().PlaybackSpeed = 1.0
end

function mod:handleSleep(entity, data, sprite, passedFromDrowsy)
	if not (passedFromDrowsy or
	        data.FFNightmare and data.FFDoomCountdown ~= nil and data.FFDoomCountdown <= 0)
	then
		data.FFSleepDuration = data.FFSleepDuration - 1
	end

	if entity.HitPoints <= 0 and entity.MaxHitPoints ~= 0 then
		mod:clearDrowsySleep(entity, data)
	elseif data.FFSleepDuration >= 0 or (data.FFNightmare and data.FFDoomCountdown ~= nil and data.FFDoomCountdown <= 0) then
		local ptrhash = GetPtrHash(entity)
		mod.DrowsyEnemiesToColor[ptrhash] = {NPC = entity}

		if not data.FFSleepTriggered then
			if passedFromDrowsy then
				if not (mod:isInMinecart(entity) or mod:isInAnimaSola(entity)) then
					local basegameVelocityMultiplier = mod:getBasegameVelocityMultiplier(entity)
					entity.Position = entity.Position - entity.Velocity * basegameVelocityMultiplier
				end
			end
			entity.Velocity = nilvector
			mod.HasAnimAndMoveMulti[ptrhash] = mod.HasAnimAndMoveMulti[ptrhash] or {}
			mod.HasAnimAndMoveMulti[ptrhash].NPC = entity
			mod.HasAnimAndMoveMulti[ptrhash].NoSpeed = true
			
			if not entity:HasEntityFlags(EntityFlag.FLAG_FREEZE) then
				entity:AddEntityFlags(EntityFlag.FLAG_FREEZE)
				local ptrhash = GetPtrHash(entity)
				mod.HasTempStatusFlag[ptrhash] = {NPC = entity, 
												  FlagsToRemove = ((mod.HasTempStatusFlag[ptrhash] and mod.HasTempStatusFlag[ptrhash].FlagsToRemove) or 0) | EntityFlag.FLAG_FREEZE}
			end
		end
		
		if data.FFNightmare then
			if passedFromDrowsy then
				if data.FFNightmareDamage > 0 then
					mod.AddDoom(entity, nil, 0, data.FFNightmareCountdown, data.FFNightmareDamage, nil, true, data.FFNightmarePassiveCountdown, true, nil, nil, data.FFSleepSource)
				end
			end
			
			if data.FFHasDoom then
				mod:handleDoom(entity, data, sprite)
			end
		end
	end
end

function mod:colorDrowsyEnemies()
	for k, npcInfo in pairs(mod.DrowsyEnemiesToColor) do
		if npcInfo.LerpAmount ~= nil then
			npcInfo.NPC:SetColor(Color.Lerp(FiendFolio.StatusEffectColors.Sleep, npcInfo.NPC:GetSprite().Color, npcInfo.LerpAmount), 1, statusColorPriority, false, false)
		else
			npcInfo.NPC:SetColor(FiendFolio.StatusEffectColors.Sleep, 1, statusColorPriority, false, false)
		end
		mod.DrowsyEnemiesToColor[k] = nil
	end
end

function FiendFolio.AddSleep(entity, source, duration, nightmareCountdown, nightmareDamageMult, isCloned)
	if not (entity and entity:ToNPC()) then
		return
	end
	
	if (entity.Type == EntityType.ENTITY_MASK or (entity.Type == EntityType.ENTITY_MASK_OF_INFAMY and entity.Parent)) and not isCloned then
		return
	end
	
	if Isaac.RunCallbackWithParam(ModCallbacks.MC_PRE_STATUS_EFFECT_APPLY, "FFSleep", "FFSleep", entity, EntityRef(source), duration) == false then
		return
	end
	
	if mod:isSegmented(entity) and not isCloned then
		local segments = mod:getSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.AddSleep(segment, source, duration, nightmareCountdown, nightmareDamageMult, true)
			end
		end
	elseif mod:isBasegameSegmented(entity) and not isCloned then
		local segments = mod:getBasegameSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.AddSleep(segment, source, duration, nightmareCountdown, nightmareDamageMult, true)
			end
		end
	end

	local data = mod:GetEntityData(entity)
	local isBoss = entity:IsBoss()
	if data.FFNightmare and data.FFDoomCountdown ~= nil and data.FFDoomCountdown <= 0 then
		--do nothing
	elseif isBoss and entity:GetBossStatusEffectCooldown() > 0 then
		--do nothing
	elseif not (entity:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) or mod:isStatusBlacklisted(entity)) or 
	       ((entity.Type == EntityType.ENTITY_MASK or entity.Type == EntityType.ENTITY_MASK_OF_INFAMY) and isCloned) 
	then
		data.FFSleepDuration = math.max(data.FFSleepDuration or 0, duration)
		data.FFSleepSource = source
		data.FFSleepTriggered = false
		
		if PlayerManager.AnyoneHasCollectible(mod.ITEM.COLLECTIBLE.SPIRIT_OF_NIGHTMARE) then
			data.FFNightmare = true
			data.FFNightmareCountdown = nightmareCountdown or 4

			local nightmarePassiveCountdown = math.floor(sleepDuration / data.FFNightmareCountdown)
			data.FFNightmarePassiveCountdown = math.min(data.FFNightmarePassiveCountdown or math.huge, nightmarePassiveCountdown)
			
			local dam = 0
			for i=1,Game():GetNumPlayers() do
				local player = Isaac.GetPlayer(i-1)
				if player:HasCollectible(mod.ITEM.COLLECTIBLE.SPIRIT_OF_NIGHTMARE) then
					local mult = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.SPIRIT_OF_NIGHTMARE)
					dam = dam+player.Damage*mult
				end
			end
			data.FFNightmareDamage = math.max(data.FFNightmareDamage or 0, dam * (nightmareDamageMult or 4))
		end
		
		if isBoss then
			entity:SetBossStatusEffectCooldown(FiendFolio.StatusEffectVariables.BossStatusResistanceFrameCount)
		end
		
		mod:TrackEnemyStatus(entity, statusflag)
		
		local ptrhash = GetPtrHash(entity)
		mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
		mod.VasculitisInfo[ptrhash][statusflag] = {Source = data.FFSleepSource}
		
		Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_STATUS_EFFECT_APPLY, "FFSleep", "FFSleep", entity, EntityRef(source), duration)
	end
end

function FiendFolio.RemoveSleep(entity, isCloned)
	if mod:isSegmented(entity) and not isCloned then
		local segments = mod:getSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.RemoveSleep(segment, true)
			end
		end
	elseif mod:isBasegameSegmented(entity) and not isCloned then
		local segments = mod:getBasegameSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.RemoveSleep(segment, true)
			end
		end
	end

	local data = mod:GetEntityData(entity)
	data.FFDrowsyDuration = nil
	data.FFSleepDuration = nil
	data.FFNightmare = nil
	data.FFSleepTriggered = nil
	mod:UntrackEnemyStatus(entity, statusflag)
	
	if not (entity:IsDead() or entity:HasMortalDamage()) then
		local ptrhash = GetPtrHash(entity)
		mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
		mod.VasculitisInfo[ptrhash][statusflag] = nil
	end

	entity:GetSprite().PlaybackSpeed = 1.0
end

function mod:sleepOnDamage(entity, amount, flags, source, cooldown)
	if flags & DamageFlag.DAMAGE_CLONES ~= 0 or not entity:ToNPC() then return end
	
	local data = mod:GetEntityData(entity)
	if not (data.FFDrowsyDuration ~= nil and data.FFDrowsyDuration > 0) and data.FFSleepDuration ~= nil and data.FFSleepDuration > 0 and not data.FFSleepTriggered then
		local frame = game:GetFrameCount()
		if mod:isSegmented(entity) then
			local segments = mod:getSegments(entity)

			for _,segment in ipairs(segments) do
				local segmentData = mod:GetEntityData(segment)
				segmentData.FFDrowsyDuration = 0
				segmentData.FFSleepDuration = 0
				segmentData.FFDoomNightmareMaxPassiveCountdown = nil
				segmentData.FFSleepTriggered = true
				segmentData.FFLastFrameTriggeredSleep = frame
				segment:GetSprite().PlaybackSpeed = 1.0
			end
		elseif mod:isBasegameSegmented(entity) then
			local segments = mod:getBasegameSegments(entity)

			for _,segment in ipairs(segments) do
				local segmentData = mod:GetEntityData(segment)
				segmentData.FFDrowsyDuration = 0
				segmentData.FFSleepDuration = 0
				segmentData.FFDoomNightmareMaxPassiveCountdown = nil
				segmentData.FFSleepTriggered = true
				segmentData.FFLastFrameTriggeredSleep = frame
				segment:GetSprite().PlaybackSpeed = 1.0
			end
		else
			data.FFDrowsyDuration = 0
			data.FFSleepDuration = 0
			data.FFDoomNightmareMaxPassiveCountdown = nil
			data.FFSleepTriggered = true
			data.FFLastFrameTriggeredSleep = frame
			entity:GetSprite().PlaybackSpeed = 1.0
		end

		if not data.FFTakingDoomDamage then
			return {Damage = amount * FiendFolio.StatusEffectVariables.SleepAwakenDamageMultiplier}
		end
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, -100, mod.sleepOnDamage)

function FiendFolio.FlagDrowsy(entity, duration, sleepDuration, nightmareCountdown, nightmareDamageMult, forcedNightmareDamage)
	TearFlagsLib.AddTearFlags(entity, tearflag)
	
	local params = TearFlagsLib.GetTearFlagParams(entity, tearflag)
	TearFlagsLib.SetTearFlagParams(entity, tearflag, {Duration = math.max(params.Duration or 0, duration),
	                                                  SleepDuration = math.max(params.SleepDuration or 0, sleepDuration),
	                                                  NightmareCountdown = (nightmareCountdown ~= nil and math.max(params.NightmareCountdown or 0, nightmareCountdown)) or params.NightmareCountdown,
	                                                  NightmareDamageMult = (nightmareDamageMult ~= nil and math.max(params.NightmareDamageMult or 0, nightmareDamageMult)) or params.NightmareDamageMult,
	                                                  ForcedNightmareDamage = (forcedNightmareDamage ~= nil and math.max(params.ForcedNightmareDamage or 0, forcedNightmareDamage)) or params.ForcedNightmareDamage})
end

function mod:applyDrowsyFlag(entity, player, source)
	-- need to get these values out first before scheduling cause otherwise they might get eaten by garbage collection
	-- happens with stuff like can of beans
	-- sucks but w/e
	local params = TearFlagsLib.GetTearFlagParams(source, tearflag)
	local duration = params.Duration
	local sleepDuration = params.SleepDuration
	local nightmareCountdown = params.NightmareCountdown
	local nightmareDamageMult = params.NightmareDamageMult
	local forcedNightmareDamage = params.ForcedNightmareDamage
	
	local ptrhash = GetPtrHash(entity)
	mod.QueuedStatusApply[ptrhash] = mod.QueuedStatusApply[ptrhash] or {}
	table.insert(mod.QueuedStatusApply[ptrhash], function()
		if mod:GetEntityData(entity).FFLastFrameTriggeredSleep ~= game:GetFrameCount() then
			FiendFolio.AddDrowsy(entity, player, duration, sleepDuration, nightmareCountdown, nightmareDamageMult, nil, forcedNightmareDamage)
		end
	end)
end
mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, mod.applyDrowsyFlag, tearflag)

function mod.handleDrowsyD3(entity)
	local params = TearFlagsLib.GetTearFlagParams(entity, tearflag)
	TearFlagsLib.SetTearFlagParams(entity, tearflag, {Duration = math.max(params.Duration or 0, 60),
	                                                  SleepDuration = math.max(params.SleepDuration or 0, 180)})
end
function mod.handleNightmareD3(entity)
	local player = TearFlagsLib.GetTearPlayer(entity)
	local params = TearFlagsLib.GetTearFlagParams(entity, tearflag)
	TearFlagsLib.SetTearFlagParams(entity, tearflag, {Duration = math.max(params.Duration or 0, 60),
	                                                  SleepDuration = math.max(params.SleepDuration or 0, 180),
	                                                  ForcedNightmareDamage = math.max(params.ForcedNightmareDamage or 0, (player and player.Damage) or 3.5)})
end

function mod:drowsyOnVasculitis(tear, npc)
	local ptrhash = GetPtrHash(npc)
	mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
	
	local vasculitisInfo = mod.VasculitisInfo[ptrhash][statusflag]
	if vasculitisInfo then
		local source = vasculitisInfo.Source
		local player = source and source.Entity and source.Entity:ToPlayer()
		local secondHandMultiplier = (player and (player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1)) or 1
		FiendFolio.FlagDrowsy(tear, 60, 180 * secondHandMultiplier)
	end
end

function mod:drowsySleepOnUpdate(npc, data, sprite, clearingStatus)
	if data.FFDrowsyDuration ~= nil and data.FFDrowsyDuration > 0 and not clearingStatus then
		mod:handleDrowsy(npc, data, sprite)
	elseif data.FFSleepDuration ~= nil and 
	       (data.FFSleepDuration > 0 or (data.FFNightmare and data.FFDoomCountdown ~= nil and data.FFDoomCountdown <= 0)) and 
	       not clearingStatus 
	then
		if data.FFDrowsyDuration ~= nil then
			npc.Position = npc.Position - npc.Velocity
		end
		data.FFDrowsyDuration = nil
		data.FFIsAsleep = true
		mod:handleSleep(npc, data, sprite)
		data.hasFFStatusIcon = true
	else
		mod:clearDrowsySleep(npc, data)
	end
end

function mod:copyDrowsyAndSleep(copy, copyData, source, sourceData)
	copyData.FFDrowsyDuration = sourceData.FFDrowsyDuration
	copyData.FFDrowsyDurationMax = sourceData.FFDrowsyDurationMax
	copyData.FFDrowsySource = sourceData.FFDrowsySource

	copyData.FFSleepDuration = sourceData.FFSleepDuration
	copyData.FFSleepSource = sourceData.FFSleepSource
	
	copyData.FFNightmare = sourceData.FFNightmare
	copyData.FFNightmareCountdown = sourceData.FFNightmareCountdown
	copyData.FFNightmarePassiveCountdown = sourceData.FFNightmarePassiveCountdown
	copyData.FFNightmareDamage = sourceData.FFNightmareDamage
	copyData.FFSleepTriggered = sourceData.FFSleepTriggered
	
	mod:TrackEnemyStatus(copy, statusflag)
	
	local copyPtrhash = GetPtrHash(copy)
	local sourcePtrhash = GetPtrHash(source)
	mod.VasculitisInfo[copyPtrhash] = mod.VasculitisInfo[copyPtrhash] or {}
	mod.VasculitisInfo[sourcePtrhash] = mod.VasculitisInfo[sourcePtrhash] or {}
	if mod.VasculitisInfo[sourcePtrhash][statusflag] then
		mod.VasculitisInfo[copyPtrhash][statusflag] = {Source = mod.VasculitisInfo[sourcePtrhash][statusflag].Source or copyData.FFDrowsySource}
	end
end

function mod:clearDrowsySleep(npc, data, isCloned)
	if mod:isSegmented(npc) and not isCloned then
		local segments = mod:getSegments(npc)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= npc.InitSeed or segment.Index ~= npc.Index then
				mod:clearDrowsySleep(segment, mod:GetEntityData(segment), true)
			end
		end
	elseif mod:isBasegameSegmented(npc) and not isCloned then
		local segments = mod:getBasegameSegments(npc)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= npc.InitSeed or segment.Index ~= npc.Index then
				mod:clearDrowsySleep(segment, mod:GetEntityData(segment), true)
			end
		end
	end
	
	data.FFDrowsyDuration = nil
	data.FFSleepDuration = nil
	data.FFIsAsleep = nil
	data.FFNightmare = nil
	data.FFNightmareCountdown = nil
	data.FFNightmarePassiveCountdown = nil
	data.FFNightmareDamage = nil
	data.FFDoomNightmareMaxPassiveCountdown = nil
	data.FFSleepTriggered = nil
	mod:UntrackEnemyStatus(npc, statusflag)
	
	if not (npc:IsDead() or npc:HasMortalDamage()) then
		local ptrhash = GetPtrHash(npc)
		mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
		mod.VasculitisInfo[ptrhash][statusflag] = nil
	end
end
