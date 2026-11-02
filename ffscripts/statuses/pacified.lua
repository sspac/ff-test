local mod = FiendFolio

--Mostly copied over from Mugged!

local statusflag = mod:RegisterEnemyStatusEffect("PACIFIED", 30, "pacifiedOnUpdate", {HasIcon = true, Vasculitis = "pacifiedOnVasculitis"})
local tearflag = TearFlagsLib.RegisterTearFlag("PACIFIED")
local statusColorPriority = 125

function mod:handlePacified(entity, data, sprite)
	data.FFPacifiedDuration = data.FFPacifiedDuration - 1
	if data.FFPacifiedDuration >= 0 then
		entity:SetColor(FiendFolio.StatusEffectColors.Pacified, 1, statusColorPriority, false, false)
	end
end


function mod.AddPacified(entity, source, duration, isCloned, sourceRef)
	if not (entity and entity:ToNPC()) then
		return
	end
	
	if (entity.Type == EntityType.ENTITY_MASK or (entity.Type == EntityType.ENTITY_MASK_OF_INFAMY and entity.Parent)) and not isCloned then
		return
	end
	
	if Isaac.RunCallbackWithParam(ModCallbacks.MC_PRE_STATUS_EFFECT_APPLY, "FFPacified", "FFPacified", entity, EntityRef(source), duration) == false then
		return
	end
	
	if mod:isSegmented(entity) and not isCloned then
		local segments = mod:getSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				mod.AddPacified(segment, source, duration, true, sourceRef)
			end
		end
	elseif mod:isBasegameSegmented(entity) and not isCloned then
		local segments = mod:getBasegameSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				mod.AddPacified(segment, source, duration, true, sourceRef)
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
		data.FFPacifiedDuration = math.max(data.FFPacifiedDuration or 0, duration)
		data.FFPacifiedSource = sourceRef or EntityRef(source)
		
		if isBoss then
			entity:SetBossStatusEffectCooldown(FiendFolio.StatusEffectVariables.BossStatusResistanceFrameCount)
		end
		
		mod:TrackEnemyStatus(entity, statusflag)
		
		local ptrhash = GetPtrHash(entity)
		mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
		mod.VasculitisInfo[ptrhash][statusflag] = {Source = data.FFPacifiedSource}
		
		Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_STATUS_EFFECT_APPLY, "FFPacified", "FFPacified", entity, EntityRef(source), duration)
	end
end

function mod.RemovePacified(entity, isCloned)
	if mod:isSegmented(entity) and not isCloned then
		local segments = mod:getSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				mod.RemovePacified(segment, true)
			end
		end
	elseif mod:isBasegameSegmented(entity) and not isCloned then
		local segments = mod:getBasegameSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				mod.RemovePacified(segment, true)
			end
		end
	end

	local data = mod:GetEntityData(entity)
	data.FFPacifiedDuration = nil
	mod:UntrackEnemyStatus(entity, statusflag)
	
	if not (entity:IsDead() or entity:HasMortalDamage()) then
		local ptrhash = GetPtrHash(entity)
		mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
		mod.VasculitisInfo[ptrhash][statusflag] = nil
	end
end

function FiendFolio.FlagPacified(entity, duration)
	TearFlagsLib.AddTearFlags(entity, tearflag)
	
	local params = TearFlagsLib.GetTearFlagParams(entity, tearflag)
	TearFlagsLib.SetTearFlagParams(entity, tearflag, {Duration = math.max(params.Duration or 0, duration)})
end

function mod:applyPacifiedFlag(entity, player, source)
	local params = TearFlagsLib.GetTearFlagParams(source, tearflag)
	FiendFolio.AddPacified(entity, player, params.Duration)
end
mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, mod.applyPacifiedFlag, tearflag)

function mod.handlePacifiedD3(entity)
	local params = TearFlagsLib.GetTearFlagParams(entity, tearflag)
	TearFlagsLib.SetTearFlagParams(entity, tearflag, {Duration = math.max(params.Duration or 0, 150)})
end

function mod:pacifiedOnVasculitis(tear, npc)
	local ptrhash = GetPtrHash(npc)
	mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
	
	local vasculitisInfo = mod.VasculitisInfo[ptrhash][statusflag]
	if vasculitisInfo then
		local source = vasculitisInfo.Source
		local player = source and source.Entity and source.Entity:ToPlayer()
		local secondHandMultiplier = (player and (player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1)) or 1
		FiendFolio.FlagPacified(tear, 120 * secondHandMultiplier)
	end
end

--Color(1.0, 0.8, 0.8, 1.0, 70/255, 25/255, 25/255)
function mod:pacifiedOnUpdate(npc, data, sprite, clearingStatus)
	if data.FFPacifiedDuration ~= nil and data.FFPacifiedDuration > 0 and not clearingStatus then
		mod:handlePacified(npc, data, sprite)
		data.FFWasPacified = true
		--data.hasFFStatusIcon = true

		if data.FFPacifiedDuration < 61 then
			if data.FFPacifiedDuration % 15 == 0 and data.FFPacifiedDuration > 0 then
				data.FFPacifiedFlash = FiendFolio.StatusEffectColors.PacifiedFlash
				npc:SetColor(data.FFPacifiedFlash, 2, 1, false, true)
			elseif data.FFPacifiedFlash then
				data.FFPacifiedFlash = Color.Lerp(data.FFPacifiedFlash, FiendFolio.StatusEffectColors.Pacified, 0.1)
				npc:SetColor(data.FFPacifiedFlash, 2, 1, false, true)
			end
		else
			data.FFPacifiedFlash = nil
		end
	else
		data.FFPacifiedDuration = nil
		data.FFPacifiedFlash = nil
		mod:UntrackEnemyStatus(npc, statusflag)
		
		if not (npc:IsDead() or npc:HasMortalDamage()) then
			local ptrhash = GetPtrHash(npc)
			mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
			mod.VasculitisInfo[ptrhash][statusflag] = nil
			data.FFWasPacified = nil
		end
	end
end

function mod:copyPacified(copy, copyData, source, sourceData)
	copyData.FFPacifiedDuration = sourceData.FFPacifiedDuration
	copyData.FFPacifiedSource = sourceData.FFPacifiedSource
	
	mod:TrackEnemyStatus(copy, statusflag)
	
	local copyPtrhash = GetPtrHash(copy)
	local sourcePtrhash = GetPtrHash(source)
	mod.VasculitisInfo[copyPtrhash] = mod.VasculitisInfo[copyPtrhash] or {}
	mod.VasculitisInfo[sourcePtrhash] = mod.VasculitisInfo[sourcePtrhash] or {}
	if mod.VasculitisInfo[sourcePtrhash][statusflag] then
		mod.VasculitisInfo[copyPtrhash][statusflag] = {Source = mod.VasculitisInfo[sourcePtrhash][statusflag].Source or copyData.FFPacifiedSource}
	end
end

function mod:pacifiedOnDamage(ent, source)
    if source and source.Entity then
        local src = source.Entity
        if src:ToNPC() then
            if mod:GetEntityData(src).FFWasPacified ~= nil then
                return false
            end
        else
			local keepGoing = true
			local foundIt
			local limit = 0
			while keepGoing do
				if mod:GetEntityData(src).FFWasPacified ~= nil then
					foundIt = src
					keepGoing = nil
				elseif limit >= 20 then
					keepGoing = nil
				elseif src.SpawnerEntity then
					limit = limit+1
					src = src.SpawnerEntity
				else
					keepGoing = nil
				end
			end
            if foundIt then
                return false
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_INIT, function(_, proj)
    if proj.SpawnerEntity and (mod:GetEntityData(proj.SpawnerEntity).FFPacifiedDuration ~= nil or mod:GetEntityData(proj.SpawnerEntity).FFWasPacified) then
        proj:AddProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER)
		mod:GetEntityData(proj).FFWasPacified = true
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, npc)
    if npc.SpawnerEntity and mod:GetEntityData(npc.SpawnerEntity).FFPacifiedDuration ~= nil then
        mod.AddPacified(npc, npc.SpawnerEntity, mod:GetEntityData(npc.SpawnerEntity).FFPacifiedDuration, nil, mod:GetEntityData(npc.SpawnerEntity).FFPacifiedSource)
		mod:GetEntityData(npc).FFWasPacified = true
    end
end)