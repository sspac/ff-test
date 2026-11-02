-- Doom --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local statusflag = mod:RegisterEnemyStatusEffect("DOOM", 91, "doomOnUpdate", {HasIcon = true, Vasculitis = "doomOnVasculitis"})
local tearflag = TearFlagsLib.RegisterTearFlag("DOOM")
local statusColorPriority = 123
local nightmareColorPriority = 124

function mod:handleDoom(entity, data, sprite)
	data.FFDoomDuration = math.max(0, data.FFDoomDuration - 1)
	if data.FFHasDoom then
		local lerpAmount = (data.FFDoomMaxPassiveCountdown ~= nil and 1) or math.min(1.0, data.FFDoomDuration / 60)
		local color = Color.Lerp(sprite.Color, FiendFolio.StatusEffectColors.Doom, lerpAmount)
		entity:SetColor(color, 1, (data.FFNightmare and nightmareColorPriority) or statusColorPriority, false, false)

		if not data.FFDoomSource then
			data.FFDoomSource = EntityRef(Isaac.GetPlayer(0))
		end
		
		if data.FFDoomMaxPassiveCountdown ~= nil or data.FFDoomNightmareMaxPassiveCountdown ~= nil then
			data.FFDoomPassiveCountdown = data.FFDoomPassiveCountdown + 1
			if (data.FFDoomMaxPassiveCountdown ~= nil and data.FFDoomPassiveCountdown >= data.FFDoomMaxPassiveCountdown) or
			   (data.FFDoomNightmareMaxPassiveCountdown ~= nil and data.FFDoomPassiveCountdown >= data.FFDoomNightmareMaxPassiveCountdown)
			then
				if data.FFDoomCountdown == 4 and (lastFramePiano3Happened == nil or lastFramePiano3Happened ~= Isaac.GetFrameCount()) then
					sfx:Play(mod.Sounds.Piano3, 0.7, 0, false, data.FFDoomPitch)
					lastFramePiano3Happened = Isaac.GetFrameCount()
				elseif data.FFDoomCountdown == 3 and (lastFramePiano2Happened == nil or lastFramePiano2Happened ~= Isaac.GetFrameCount()) then
					sfx:Play(mod.Sounds.Piano2, 0.7, 0, false, data.FFDoomPitch)
					lastFramePiano2Happened = Isaac.GetFrameCount()
				elseif data.FFDoomCountdown == 2 and (lastFramePiano1Happened == nil or lastFramePiano1Happened ~= Isaac.GetFrameCount()) then
					sfx:Play(mod.Sounds.Piano1, 0.7, 0, false, data.FFDoomPitch)
					lastFramePiano1Happened = Isaac.GetFrameCount()
				end
					
				if mod:isSegmented(entity) and not mod:isReducedSyncSegment(entity) then
					local segments = mod:getSegments(entity)

					for _,segment in ipairs(segments) do
						mod:GetEntityData(segment).FFDoomForceIconReaction = mod:GetEntityData(segment).FFDoomCountdown > 0
						mod:GetEntityData(segment).FFDoomCountdown = math.max(mod:GetEntityData(segment).FFDoomCountdown - 1, 0)
						mod:GetEntityData(segment).FFDoomPassiveCountdown = 0
						mod:GetEntityData(segment).FFLastDoomCountdown = game:GetFrameCount()
					end
				elseif mod:isBasegameSegmented(entity) and not mod:isBasegameReducedSyncSegment(entity)	then
					local segments = mod:getBasegameSegments(entity)

					for _,segment in ipairs(segments) do
						mod:GetEntityData(segment).FFDoomForceIconReaction = mod:GetEntityData(segment).FFDoomCountdown > 0
						mod:GetEntityData(segment).FFDoomCountdown = math.max(mod:GetEntityData(segment).FFDoomCountdown - 1, 0)
						mod:GetEntityData(segment).FFDoomPassiveCountdown = 0
						mod:GetEntityData(segment).FFLastDoomCountdown = game:GetFrameCount()
					end
				else
					data.FFDoomForceIconReaction = data.FFDoomCountdown > 0
					data.FFDoomCountdown = math.max(data.FFDoomCountdown - 1, 0)
					data.FFDoomPassiveCountdown = 0
					data.FFLastDoomCountdown = game:GetFrameCount()
				end
			end
		end
		
		if data.FFDoomCountdown <= 0 then
			data.FFDoomTriggerCountdown = (data.FFDoomTriggerCountdown or 10) - 1
			
			if data.FFDoomTriggerCountdown <= 0 then
				if mod:checkIfStatusLogicIsApplied(entity, true) then
					local flags = 0
					if data.FFDoomIgnoreArmor then
						flags = DamageFlag.DAMAGE_IGNORE_ARMOR
					end
					data.FFTakingDoomDamage = true
					entity:TakeDamage(data.FFDoomDamage, flags, data.FFDoomSource, 0)
					data.FFTakingDoomDamage = nil
					
					sfx:Play(mod.Sounds.DoomProc, 0.6, 0, false, math.random(85,115)/100)
					sfx:Play(mod.Sounds.ChainSnap, 1.6, 0, false, 1.0)
					sfx:Play(SoundEffect.SOUND_BLACK_POOF, 0.9, 0, false, 1.0)
					
					local poofA = Isaac.Spawn(1000, 16, 1, entity.Position, nilvector, nil)
					poofA:GetSprite().Color = Color(0.2, 0.2, 0.2, 0.6, 0/255, 0/255, 0/255)
					
					local poofB = Isaac.Spawn(1000, 16, 2, entity.Position, nilvector, nil)
					poofB:GetSprite().Color = Color(0.2, 0.2, 0.2, 0.6, 0/255, 0/255, 0/255)
					
					local poofC = Isaac.Spawn(1000, 15, 0, entity.Position, nilvector, nil)
					poofC:GetSprite().Color = Color(0.2, 0.2, 0.2, 0.6, 0/255, 0/255, 0/255)
					
					game:ShakeScreen(8)
				end
				
				data.FFHasDoom = nil
				data.FFDoomDuration = nil
				data.FFDoomCountdown = nil
				data.FFDoomDamage = nil
				data.FFDoomSource = nil
				data.FFDoomTriggerCountdown = nil
				data.FFDoomForceIconReaction = nil
				data.FFDoomPassiveCountdown = nil
				data.FFDoomMaxPassiveCountdown = nil
				data.FFDoomIgnoreArmor = nil
				data.FFDoomNightmareMaxPassiveCountdown = nil
				mod:UntrackEnemyStatus(entity, statusflag)
				
				if not (entity:IsDead() or entity:HasMortalDamage()) then
					local ptrhash = GetPtrHash(entity)
					mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
					mod.VasculitisInfo[ptrhash][statusflag] = nil
				end
				
				if data.FFNightmare and (data.FFDrowsyDuration == nil or data.FFDrowsyDuration <= 0) then
					mod:clearDrowsySleep(entity, data)
				end
			end
		end
	end
end

local lastFramePiano3Happened = nil
local lastFramePiano2Happened = nil
local lastFramePiano1Happened = nil

function FiendFolio.AddDoom(entity, source, duration, maxCountdown, damage, isCloned, muteSounds, passiveCountdown, isNightmare, countdown, ignoreArmor, sourceRef)
	if not (entity and entity:ToNPC()) then
		return
	end
	
	if (entity.Type == EntityType.ENTITY_MASK or (entity.Type == EntityType.ENTITY_MASK_OF_INFAMY and entity.Parent)) and not isCloned then
		return
	end
	
	if Isaac.RunCallbackWithParam(ModCallbacks.MC_PRE_STATUS_EFFECT_APPLY, "FFDoom", "FFDoom", entity, EntityRef(source), duration) == false then
		return
	end
	
	if isNightmare then
		countdown = maxCountdown
	end
	
	local playerDamage = mod:DoomGetEstimatedPlayerDamage(entity, player)
	if mod:isSegmented(entity) and not isCloned then
		local segments = mod:getSegments(entity)

		for _,segment in ipairs(segments) do
			if mod:isMainSegment(segment) and not mod:isReducedSyncSegment(segment) then
				local ptrhash = GetPtrHash(segment)
				local remainingHP = mod.DoomHPEstimate[ptrhash] or segment.HitPoints
				countdown = math.min(maxCountdown, math.floor(remainingHP / playerDamage))
				if countdown * playerDamage == remainingHP then
					countdown = countdown - 1
				end
				countdown = math.max(1, countdown)
				break
			end
		end

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.AddDoom(segment, source, duration, maxCountdown, damage, true, muteSounds, passiveCountdown, isNightmare, countdown, ignoreArmor, sourceRef)
			end
		end
	elseif mod:isBasegameSegmented(entity) and not isCloned then
		local segments = mod:getBasegameSegments(entity)

		for _,segment in ipairs(segments) do
			if mod:isBasegameMainSegment(segment) and not mod:isBasegameReducedSyncSegment(segment) then
				local ptrhash = GetPtrHash(segment)
				local remainingHP = mod.DoomHPEstimate[ptrhash] or segment.HitPoints
				countdown = math.min(maxCountdown, math.floor(remainingHP / playerDamage))
				if countdown * playerDamage == remainingHP then
					countdown = countdown - 1
				end
				countdown = math.max(1, countdown)
				break
			end
		end

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.AddDoom(segment, source, duration, maxCountdown, damage, true, muteSounds, passiveCountdown, isNightmare, countdown, ignoreArmor, sourceRef)
			end
		end
	end
	if countdown == nil then
		local ptrhash = GetPtrHash(entity)
		local remainingHP = mod.DoomHPEstimate[ptrhash] or entity.HitPoints
		countdown = math.min(maxCountdown, math.floor(remainingHP / playerDamage))
		if countdown * playerDamage == remainingHP then
			countdown = countdown - 1
		end
		countdown = math.max(1, countdown)
	end

	local data = mod:GetEntityData(entity)
	local isBoss = entity:IsBoss()
	if isBoss and entity:GetBossStatusEffectCooldown() > 0 and not isNightmare then
		--do nothing
	elseif not (entity:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) or mod:isStatusBlacklisted(entity)) or 
	       ((entity.Type == EntityType.ENTITY_MASK or entity.Type == EntityType.ENTITY_MASK_OF_INFAMY) and isCloned) 
	then
		data.FFHasDoom = true
		data.FFDoomDuration = math.max(data.FFDoomDuration or 0, duration)
		data.FFDoomDamage = math.max(data.FFDoomDamage or 0, damage)
		data.FFDoomIgnoreArmor = data.FFDoomIgnoreArmor or ignoreArmor
		data.FFDoomSource = sourceRef or EntityRef(source)
		
		if data.FFDoomCountdown == nil then
			data.FFDoomCountdown = countdown
			data.FFDoomTriggerCountdown = nil
			data.FFDoomForceIconReaction = nil
			data.FFDoomPitch = math.random(75,125)/100
			
			if not muteSounds then
				if data.FFDoomCountdown == 3 and (lastFramePiano3Happened == nil or lastFramePiano3Happened ~= Isaac.GetFrameCount()) then
					sfx:Play(mod.Sounds.Piano3, 0.7, 0, false, data.FFDoomPitch)
					lastFramePiano3Happened = Isaac.GetFrameCount()
				elseif data.FFDoomCountdown == 2 and (lastFramePiano2Happened == nil or lastFramePiano2Happened ~= Isaac.GetFrameCount()) then
					sfx:Play(mod.Sounds.Piano2, 0.7, 0, false, data.FFDoomPitch)
					lastFramePiano2Happened = Isaac.GetFrameCount()
				elseif data.FFDoomCountdown == 1 and (lastFramePiano1Happened == nil or lastFramePiano1Happened ~= Isaac.GetFrameCount()) then
					sfx:Play(mod.Sounds.Piano1, 0.7, 0, false, data.FFDoomPitch)
					lastFramePiano1Happened = Isaac.GetFrameCount()
				end
			end
		end
		
		if passiveCountdown ~= nil then
			data.FFDoomPassiveCountdown = data.FFDoomPassiveCountdown or 0
			if isNightmare and data.FFDoomMaxPassiveCountdown == nil then
				data.FFDoomNightmareMaxPassiveCountdown = math.min(data.FFDoomNightmareMaxPassiveCountdown or math.huge,
				                                                   passiveCountdown)
			else
				data.FFDoomMaxPassiveCountdown = math.min(data.FFDoomMaxPassiveCountdown or math.huge, 
				                                          data.FFDoomNightmareMaxPassiveCountdown or math.huge,
				                                          passiveCountdown)
				data.FFDoomNightmareMaxPassiveCountdown = nil
			end
		end
		
		if isBoss and not isNightmare then
			entity:SetBossStatusEffectCooldown(FiendFolio.StatusEffectVariables.BossStatusResistanceFrameCount)
		end
		
		mod:TrackEnemyStatus(entity, statusflag)
		
		if not isNightmare then
			local ptrhash = GetPtrHash(entity)
			mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
			mod.VasculitisInfo[ptrhash][statusflag] = {Source = data.FFDoomSource}
		end
		
		Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_STATUS_EFFECT_APPLY, "FFDoom", "FFDoom", entity, EntityRef(source), duration)
	end
end

function FiendFolio.RemoveDoom(entity, isCloned)
	if mod:isSegmented(entity) and not isCloned then
		local segments = mod:getSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.RemoveDoom(segment, true)
			end
		end
	elseif mod:isBasegameSegmented(entity) and not isCloned then
		local segments = mod:getBasegameSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.RemoveDoom(segment, true)
			end
		end
	end

	local data = mod:GetEntityData(entity)
	data.FFHasDoom = nil
	data.FFDoomDuration = nil
	data.FFDoomCountdown = nil
	data.FFDoomDamage = nil
	data.FFDoomSource = nil
	data.FFDoomTriggerCountdown = nil
	data.FFDoomForceIconReaction = nil
	data.FFDoomPassiveCountdown = nil
	data.FFDoomMaxPassiveCountdown = nil
	data.FFDoomNightmareMaxPassiveCountdown = nil
	data.FFDoomIgnoreArmor = nil
	mod:UntrackEnemyStatus(entity, statusflag)
	
	if not (entity:IsDead() or entity:HasMortalDamage()) then
		local ptrhash = GetPtrHash(entity)
		mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
		mod.VasculitisInfo[ptrhash][statusflag] = nil
	end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, function(_, entity, damage)
	local typ = entity.Type
	if typ > 9 and typ < 1000 then
		local ptrhash = GetPtrHash(entity)
		mod.DoomHPEstimate[ptrhash] = (mod.DoomHPEstimate[ptrhash] or entity.HitPoints) - damage
	end
end)

function FiendFolio.FlagDoom(entity, duration, countdown, damage, rollChance)
	TearFlagsLib.AddTearFlags(entity, tearflag)
	
	local params = TearFlagsLib.GetTearFlagParams(entity, tearflag)
	local rolls = params.Rolls or {}
	table.insert(rolls, rollChance or -1)
	TearFlagsLib.SetTearFlagParams(entity, tearflag, {Duration = math.max(params.Duration or 0, duration),
	                                                  Countdown = math.max(params.Countdown or 0, countdown),
	                                                  Damage = math.max(params.Damage or 0, damage),
	                                                  Rolls = rolls})
end

function mod:applyDoomFlag(entity, player, source)
	-- need to get these values out first before scheduling cause otherwise they might get eaten by garbage collection
	-- happens with stuff like can of beans
	-- sucks but w/e
	local params = TearFlagsLib.GetTearFlagParams(source, tearflag)
	local rolls = params.Rolls
	local duration = params.Duration
	local countdown = params.Countdown
	local damage = params.Damage
	
	local ptrhash = GetPtrHash(entity)
	mod.QueuedStatusApply[ptrhash] = mod.QueuedStatusApply[ptrhash] or {}
	table.insert(mod.QueuedStatusApply[ptrhash], function()
		local ptrhash = GetPtrHash(entity)
		local remainingHP = mod.DoomHPEstimate[ptrhash] or entity.HitPoints
		local playerDamage = mod:DoomGetEstimatedPlayerDamage(entity, player)
		for _, chance in ipairs(rolls) do
			if chance == -1 then
				FiendFolio.AddDoom(entity, player, duration, countdown, damage)
			elseif math.random() <= chance and remainingHP > playerDamage then
				FiendFolio.AddDoom(entity, player, duration, countdown, damage)
			elseif player ~= nil then
				local npc = entity:ToNPC()
				local isBoss = npc and npc:IsBoss()
				
				local edata = mod:GetEntityData(entity)
				local hasDoom = edata.FFDoomDuration ~= nil and edata.FFDoomDuration > 0
				
				if remainingHP > playerDamage * countdown and not (isBoss or hasDoom) then
					local pdata = mod:GetEntityData(player)
					
					if math.random() <= ((chance * 9) ^ ((pdata.DoomPseudoRandomCounter or 3) / 3)) / 9 then
						FiendFolio.AddDoom(entity, player, duration, countdown, damage)
						pdata.DoomPseudoRandomCounter = math.min((pdata.DoomPseudoRandomCounter or 3) - 1, 3)
					else
						pdata.DoomPseudoRandomCounter = math.max((pdata.DoomPseudoRandomCounter or 3) + 1, 3)
					end
				end
			end
		end
	end)
end
mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, mod.applyDoomFlag, tearflag)

function mod:DoomGetEstimatedPlayerDamage(entity, player, damageOverride)
	return (damageOverride or ((player and player.Damage) or 3.5)) + mod:getBruiseDamage(entity)
end

function mod:CanApplyDoom(entity, player, damageOverride, numHitsPerProc)
	local ptrhash = GetPtrHash(entity)
	local remainingHP = mod.DoomHPEstimate[ptrhash] or entity.HitPoints
	local playerDamage = mod:DoomGetEstimatedPlayerDamage(entity, player, damageOverride) * (numHitsPerProc or 1)
	local countdown = math.floor(remainingHP / playerDamage)
	if countdown * playerDamage == remainingHP then
		countdown = countdown - 1
	end
	return remainingHP > playerDamage, countdown
end

function mod:TryApplyDoom(entity, player, duration, countdown, damage, chance)
	local ptrhash = GetPtrHash(entity)
	mod.QueuedStatusApply[ptrhash] = mod.QueuedStatusApply[ptrhash] or {}
	table.insert(mod.QueuedStatusApply[ptrhash], function()
		local ptrhash = GetPtrHash(entity)
		local remainingHP = mod.DoomHPEstimate[ptrhash] or entity.HitPoints
		local playerDamage = mod:DoomGetEstimatedPlayerDamage(entity, player)
		if chance == -1 or chance == nil then
			FiendFolio.AddDoom(entity, player, duration, countdown, damage)
		elseif math.random() <= chance and remainingHP > playerDamage then
			FiendFolio.AddDoom(entity, player, duration, countdown, damage)
		elseif player ~= nil then
			local npc = entity:ToNPC()
			local isBoss = npc and npc:IsBoss()

			local edata = mod:GetEntityData(entity)
			local hasDoom = edata.FFDoomDuration ~= nil and edata.FFDoomDuration > 0

			if remainingHP > playerDamage * countdown and not (isBoss or hasDoom) then
				local pdata = mod:GetEntityData(player)

				if math.random() <= ((chance * 9) ^ ((pdata.DoomPseudoRandomCounter or 3) / 3)) / 9 then
					FiendFolio.AddDoom(entity, player, duration, countdown, damage)
					pdata.DoomPseudoRandomCounter = math.min((pdata.DoomPseudoRandomCounter or 3) - 1, 3)
				else
					pdata.DoomPseudoRandomCounter = math.max((pdata.DoomPseudoRandomCounter or 3) + 1, 3)
				end
			end
		end
	end)
end

function mod.handleDoomD3(entity)
	local player = TearFlagsLib.GetTearPlayer(entity)
	local params = TearFlagsLib.GetTearFlagParams(entity, tearflag)
	local rolls = params.Rolls or {}
	table.insert(rolls, -1)
	TearFlagsLib.SetTearFlagParams(entity, tearflag, {Duration = math.max(params.Duration or 0, 180),
	                                                  Countdown = math.max(params.Countdown or 0, 3),
	                                                  Damage = math.max(params.Damage or 0, ((player and player.Damage) or 3.5) * 5),
	                                                  Rolls = rolls})
end

function mod:doomOnVasculitis(tear, npc)
	local ptrhash = GetPtrHash(npc)
	mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
	
	local vasculitisInfo = mod.VasculitisInfo[ptrhash][statusflag]
	if vasculitisInfo then
		local source = vasculitisInfo.Source
		local player = source and source.Entity and source.Entity:ToPlayer()
		local secondHandMultiplier = (player and (player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1)) or 1
		FiendFolio.FlagDoom(tear, 180 * secondHandMultiplier, 3, player.Damage * 5)
	end
end

function mod:doomOnDamage(entity, data, source)
	if data.FFHasDoom and (data.FFDoomDuration > 0 or data.FFDoomMaxPassiveCountdown ~= nil or (data.FFNightmare and data.FFDoomCountdown == 1)) and 
	   (data.FFLastDoomCountdown == nil or game:GetFrameCount() >= data.FFLastDoomCountdown + FiendFolio.StatusEffectVariables.DoomCountdownCooldown) 
	then
		if data.FFDoomCountdown == 4 and (lastFramePiano3Happened == nil or lastFramePiano3Happened ~= Isaac.GetFrameCount()) then
			sfx:Play(mod.Sounds.Piano3, 0.7, 0, false, data.FFDoomPitch)
			lastFramePiano3Happened = Isaac.GetFrameCount()
		elseif data.FFDoomCountdown == 3 and (lastFramePiano2Happened == nil or lastFramePiano2Happened ~= Isaac.GetFrameCount()) then
			sfx:Play(mod.Sounds.Piano2, 0.7, 0, false, data.FFDoomPitch)
			lastFramePiano2Happened = Isaac.GetFrameCount()
		elseif data.FFDoomCountdown == 2 and (lastFramePiano1Happened == nil or lastFramePiano1Happened ~= Isaac.GetFrameCount()) then
			sfx:Play(mod.Sounds.Piano1, 0.7, 0, false, data.FFDoomPitch)
			lastFramePiano1Happened = Isaac.GetFrameCount()
		end
			
		if mod:isSegmented(entity) and not mod:isReducedSyncSegment(entity) then
			local segments = mod:getSegments(entity)

			for _,segment in ipairs(segments) do
				local sdata = mod:GetEntityData(segment)
				if sdata.FFHasDoom then
					sdata.FFDoomForceIconReaction = sdata.FFDoomCountdown > 0
					sdata.FFDoomCountdown = math.max(sdata.FFDoomCountdown - 1, 0)
					sdata.FFDoomPassiveCountdown = 0
					sdata.FFLastDoomCountdown = game:GetFrameCount()
				end
			end
		elseif mod:isBasegameSegmented(entity) and not mod:isBasegameReducedSyncSegment(entity)	then
			if not (source == nil or source.Entity == nil or mod:isInBasegameSegmentsOf(source.Entity, entity)) then
				local segments = mod:getBasegameSegments(entity)

				for _,segment in ipairs(segments) do
					local sdata = mod:GetEntityData(segment)
					if sdata.FFHasDoom then
						sdata.FFDoomForceIconReaction = sdata.FFDoomCountdown > 0
						sdata.FFDoomCountdown = math.max(sdata.FFDoomCountdown - 1, 0)
						sdata.FFDoomPassiveCountdown = 0
						sdata.FFLastDoomCountdown = game:GetFrameCount()
					end
				end
			end
		else
			data.FFDoomForceIconReaction = data.FFDoomCountdown > 0
			data.FFDoomCountdown = math.max(data.FFDoomCountdown - 1, 0)
			data.FFDoomPassiveCountdown = 0
			data.FFLastDoomCountdown = game:GetFrameCount()
		end
	end
end

function mod:doomOnUpdate(npc, data, sprite, clearingStatus)
	if not data.FFNightmare then
		if data.FFHasDoom and (data.FFDoomDuration > 0 or data.FFDoomMaxPassiveCountdown ~= nil or data.FFDoomCountdown <= 0) and not clearingStatus then
			mod:handleDoom(npc, data, sprite)
			data.hasFFStatusIcon = true
		else
			data.FFHasDoom = nil
			data.FFDoomDuration = nil
			data.FFDoomCountdown = nil
			data.FFDoomDamage = nil
			data.FFDoomSource = nil
			data.FFDoomTriggerCountdown = nil
			data.FFDoomForceIconReaction = nil
			data.FFDoomPassiveCountdown = nil
			data.FFDoomMaxPassiveCountdown = nil
			data.FFDoomIgnoreArmor = nil
			data.FFDoomNightmareMaxPassiveCountdown = nil
			mod:UntrackEnemyStatus(npc, statusflag)
			
			if not (npc:IsDead() or npc:HasMortalDamage()) then
				local ptrhash = GetPtrHash(npc)
				mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
				mod.VasculitisInfo[ptrhash][statusflag] = nil
			end
		end
	end
end

function mod:copyDoom(copy, copyData, source, sourceData)
	copyData.FFHasDoom = sourceData.FFHasDoom
	copyData.FFDoomDuration = sourceData.FFDoomDuration
	copyData.FFDoomCountdown = sourceData.FFDoomCountdown
	copyData.FFDoomDamage = sourceData.FFDoomDamage
	copyData.FFDoomSource = sourceData.FFDoomSource
	copyData.FFDoomTriggerCountdown = sourceData.FFDoomTriggerCountdown
	copyData.FFDoomForceIconReaction = sourceData.FFDoomForceIconReaction
	copyData.FFDoomPassiveCountdown = sourceData.FFDoomPassiveCountdown
	copyData.FFDoomMaxPassiveCountdown = sourceData.FFDoomMaxPassiveCountdown
	copyData.FFDoomIgnoreArmor = sourceData.FFDoomIgnoreArmor
	copyData.FFDoomNightmareMaxPassiveCountdown = sourceData.FFDoomNightmareMaxPassiveCountdown
	
	mod:TrackEnemyStatus(copy, statusflag)
	
	local copyPtrhash = GetPtrHash(copy)
	local sourcePtrhash = GetPtrHash(source)
	mod.VasculitisInfo[copyPtrhash] = mod.VasculitisInfo[copyPtrhash] or {}
	mod.VasculitisInfo[sourcePtrhash] = mod.VasculitisInfo[sourcePtrhash] or {}
	if mod.VasculitisInfo[sourcePtrhash][statusflag] then
		mod.VasculitisInfo[copyPtrhash][statusflag] = {Source = mod.VasculitisInfo[sourcePtrhash][statusflag].Source or copyData.FFDoomSource}
	end
end
