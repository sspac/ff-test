-- Bruise --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local statusflag = mod:RegisterEnemyStatusEffect("BRUISE", 999, "bruiseOnUpdate", {HasIcon = true, Vasculitis = "bruiseOnVasculitis"})
local tearflag = TearFlagsLib.RegisterTearFlag("BRUISE")
local statusColorPriority = 126

function mod:handleBruise(entity, data, sprite)
	local numStacks = #data.FFBruiseInstances
	data.FFBruiseLastStacks = numStacks

	if numStacks > 0 then
		local bruiseColor = FiendFolio.StatusEffectColors.BruiseLvl5
		if numStacks == 4 then
			bruiseColor = FiendFolio.StatusEffectColors.BruiseLvl4
		elseif numStacks == 3 then
			bruiseColor = FiendFolio.StatusEffectColors.BruiseLvl3
		elseif numStacks == 2 then
			bruiseColor = FiendFolio.StatusEffectColors.BruiseLvl2
		elseif numStacks == 1 then
			bruiseColor = FiendFolio.StatusEffectColors.BruiseLvl1
		end
		entity:SetColor(bruiseColor, 1, statusColorPriority, false, false)
	end

	for i = numStacks, 1, -1 do
		data.FFBruiseInstances[i].Duration = data.FFBruiseInstances[i].Duration - 1
		if data.FFBruiseInstances[i].Duration <= 0 then
			table.remove(data.FFBruiseInstances, i)
		end
	end
end

function FiendFolio.AddBruise(entity, source, duration, stacks, damagePerStack, isCloned, isSanguine)
	if not (entity and entity:ToNPC()) then
		return
	end
	
	if (entity.Type == EntityType.ENTITY_MASK or (entity.Type == EntityType.ENTITY_MASK_OF_INFAMY and entity.Parent)) and not isCloned then
		return
	end
	
	if Isaac.RunCallbackWithParam(ModCallbacks.MC_PRE_STATUS_EFFECT_APPLY, "FFBruise", "FFBruise", entity, EntityRef(source), duration) == false then
		return
	end
	
	if mod:isSegmented(entity) and not isCloned then
		local segments = mod:getSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.AddBruise(segment, source, duration, stacks, damagePerStack, true, isSanguine)
			end
		end
	elseif mod:isBasegameSegmented(entity) and not isCloned then
		local segments = mod:getBasegameSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.AddBruise(segment, source, duration, stacks, damagePerStack, true, isSanguine)
			end
		end
	end

	local data = mod:GetEntityData(entity)
	local isBoss = entity:IsBoss()
	local ptrhash = GetPtrHash(entity)
	if not (isSanguine or mod.BruiseBossStatusResistance[ptrhash]) and isBoss and entity:GetBossStatusEffectCooldown() > 0 then
		--do nothing
	elseif not (entity:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) or mod:isStatusBlacklisted(entity)) or 
	       ((entity.Type == EntityType.ENTITY_MASK or entity.Type == EntityType.ENTITY_MASK_OF_INFAMY) and isCloned) 
	then
		data.FFBruiseInstances = data.FFBruiseInstances or {}

		for i = 1, stacks do
			table.insert(data.FFBruiseInstances, {Duration = duration, Damage = damagePerStack, Source = EntityRef(source)})
		end
		
		if isBoss then
			entity:SetBossStatusEffectCooldown(FiendFolio.StatusEffectVariables.BossStatusResistanceFrameCount)
			mod.BruiseBossStatusResistance[ptrhash] = {NPC = entity, Cooldown = FiendFolio.StatusEffectVariables.BossStatusResistanceFrameCount}
		end
		
		mod:TrackEnemyStatus(entity, statusflag)
		
		mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
		mod.VasculitisInfo[ptrhash][statusflag] = {Source = data.FFBruiseInstances[1].Source}
		
		Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_STATUS_EFFECT_APPLY, "FFBruise", "FFBruise", entity, EntityRef(source), duration)
	end
end

function FiendFolio.RemoveBruise(entity, isCloned)
	if mod:isSegmented(entity) and not isCloned then
		local segments = mod:getSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.RemoveBruise(segment, true)
			end
		end
	elseif mod:isBasegameSegmented(entity) and not isCloned then
		local segments = mod:getBasegameSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.RemoveBruise(segment, true)
			end
		end
	end

	local data = mod:GetEntityData(entity)
	data.FFBruiseInstances = nil
	mod:UntrackEnemyStatus(entity, statusflag)
	
	if not (entity:IsDead() or entity:HasMortalDamage()) then
		local ptrhash = GetPtrHash(entity)
		mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
		mod.VasculitisInfo[ptrhash][statusflag] = nil
	end
end

function mod:getBruiseDamage(entity)
	local data = mod:GetEntityData(entity)
	if data.FFBruiseInstances ~= nil and #data.FFBruiseInstances > 0 then
		local highestDamages = {}
		for i = 1, #data.FFBruiseInstances do
			for j = 0, math.min(#highestDamages, 4) do
				if highestDamages[j+1] == nil or highestDamages[j+1] <= data.FFBruiseInstances[i].Damage then
					table.insert(highestDamages, j+1, data.FFBruiseInstances[i].Damage)
					break
				end
			end
		end

		local addedDamage = 0
		for i = 1, math.min(#highestDamages, 5) do
			addedDamage = addedDamage + highestDamages[i]
		end
		return addedDamage
	end
	return 0
end

function mod:bruiseOnDamage(entity, amount, flags, source, cooldown)
	if flags & DamageFlag.DAMAGE_CLONES ~= 0 or not entity:ToNPC() then return end
	
	local data = mod:GetEntityData(entity)
	if data.FFBruiseInstances ~= nil and #data.FFBruiseInstances > 0 then
		local allowDamageEffects = not mod:isBasegameSegmented(entity) or mod:isBasegameMainSegment(entity) or mod:isBasegameReducedSyncSegment(entity)
		if allowDamageEffects then
			local highestDamages = {}
			for i = 1, #data.FFBruiseInstances do
				for j = 0, math.min(#highestDamages, 4) do
					if highestDamages[j+1] == nil or highestDamages[j+1] <= data.FFBruiseInstances[i].Damage then
						table.insert(highestDamages, j+1, data.FFBruiseInstances[i].Damage)
						break
					end
				end
			end

			local addedDamage = 0
			for i = 1, math.min(#highestDamages, 5) do
				addedDamage = addedDamage + highestDamages[i]
			end

			return {Damage = amount + addedDamage}
		end
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, -150, mod.bruiseOnDamage)

function FiendFolio.FlagBruise(entity, duration, stacks, damagePerStack)
	TearFlagsLib.AddTearFlags(entity, tearflag)
	
	local params = TearFlagsLib.GetTearFlagParams(entity, tearflag)
	TearFlagsLib.SetTearFlagParams(entity, tearflag, {Duration = math.max(params.Duration or 0, duration),
	                                                  Stacks = math.max(params.Stacks or 0, stacks),
	                                                  DamagePerStack = math.max(params.DamagePerStack or 0, damagePerStack)})
end

function mod:applyBruiseFlag(entity, player, source)
	-- need to get these values out first before scheduling cause otherwise they might get eaten by garbage collection
	-- happens with stuff like can of beans
	-- sucks but w/e
	local params = TearFlagsLib.GetTearFlagParams(source, tearflag)
	local duration = params.Duration
	local stacks = params.Stacks
	local damagePerStack = params.DamagePerStack
	
	local ptrhash = GetPtrHash(entity)
	mod.QueuedStatusApply[ptrhash] = mod.QueuedStatusApply[ptrhash] or {}
	table.insert(mod.QueuedStatusApply[ptrhash], function()
		FiendFolio.AddBruise(entity, player, duration, stacks, damagePerStack)
	end)
end
mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, mod.applyBruiseFlag, tearflag)

function FiendFolio.HasBruiseFlag(entity)
	return TearFlagsLib.HasTearFlags(entity, tearflag)
end

function mod.handleBruiseD3(entity)
	local params = TearFlagsLib.GetTearFlagParams(entity, tearflag)
	TearFlagsLib.SetTearFlagParams(entity, tearflag, {Duration = math.max(params.Duration or 0, 120),
	                                                  Stacks = math.max(params.Stacks or 0, 1),
	                                                  DamagePerStack = math.max(params.DamagePerStack or 0, 1)})
end

function mod:bruiseOnVasculitis(tear, npc)
	local ptrhash = GetPtrHash(npc)
	mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
	
	local vasculitisInfo = mod.VasculitisInfo[ptrhash][statusflag]
	if vasculitisInfo then
		local source = vasculitisInfo.Source
		local player = source and source.Entity and source.Entity:ToPlayer()
		local secondHandMultiplier = (player and (player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1)) or 1
		FiendFolio.FlagBruise(tear, 90 * secondHandMultiplier, 1, 1)
	end
end

function mod:bruiseOnUpdate(npc, data, sprite, clearingStatus)
	if data.FFBruiseInstances ~= nil and #data.FFBruiseInstances > 0 and not clearingStatus then
		mod:handleBruise(npc, data, sprite)
		data.hasFFStatusIcon = true
	else
		data.FFBruiseInstances = nil
		data.FFBruiseLastStacks = 0
		mod:UntrackEnemyStatus(npc, statusflag)
		
		if not (npc:IsDead() or npc:HasMortalDamage()) then
			local ptrhash = GetPtrHash(npc)
			mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
			mod.VasculitisInfo[ptrhash][statusflag] = nil
		end
	end
end

function mod:copyBruise(copy, copyData, source, sourceData)
	if sourceData.FFBruiseInstances then
		copyData.FFBruiseInstances = {}
		for _, stack in ipairs(sourceData.FFBruiseInstances) do
			table.insert(copyData.FFBruiseInstances, {Duration = stack.Duration, Damage = stack.Damage, Source = stack.Source})
		end
	end
	copyData.FFBruiseLastStacks = sourceData.FFBruiseLastStacks
	
	mod:TrackEnemyStatus(copy, statusflag)
	
	local copyPtrhash = GetPtrHash(copy)
	local sourcePtrhash = GetPtrHash(source)
	mod.VasculitisInfo[copyPtrhash] = mod.VasculitisInfo[copyPtrhash] or {}
	mod.VasculitisInfo[sourcePtrhash] = mod.VasculitisInfo[sourcePtrhash] or {}
	if mod.VasculitisInfo[sourcePtrhash][statusflag] then
		mod.VasculitisInfo[copyPtrhash][statusflag] = {Source = mod.VasculitisInfo[sourcePtrhash][statusflag].Source or copyData.FFBruiseInstances[1].Source}
	end
end
