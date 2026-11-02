local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

--Mostly copied over from Pacified!

local statusflag = mod:RegisterEnemyStatusEffect("NURSING", 31, "nursingOnUpdate", {HasIcon = true, Vasculitis = "nursingOnVasculitis"})
local tearflag = TearFlagsLib.RegisterTearFlag("NURSING")
local statusColorPriority = 4
local healColorPriority = 0

function mod:handleNursing(entity, data, sprite)
	data.FFNursingDuration = data.FFNursingDuration - 1
	if data.FFNursingDuration >= 0 then
		local color = FiendFolio.StatusEffectColors.Nursing
		local spawncolor = FiendFolio.StatusEffectColors.NursingSpawn
		if data.FFNursingDuration < 61 then
			if data.FFNursingDuration % 15 == 0 and data.FFNursingDuration > 0 then
				data.FFNursingFlash = FiendFolio.StatusEffectColors.NursingFlash
				data.FFNursingSpawnFlash = FiendFolio.StatusEffectColors.NursingSpawnFlash
			elseif data.FFNursingFlash then
				data.FFNursingFlash = Color.Lerp(data.FFNursingFlash or FiendFolio.StatusEffectColors.Nursing, FiendFolio.StatusEffectColors.Nursing, 0.1)
				data.FFNursingSpawnFlash = Color.Lerp(data.FFNursingSpawnFlash or FiendFolio.StatusEffectColors.NursingSpawn, FiendFolio.StatusEffectColors.NursingSpawn, 0.1)
			end
			color = data.FFNursingFlash or color
			spawncolor = data.FFNursingSpawnFlash or spawncolor
		else
			data.FFNursingFlash = nil
			data.FFNursingSpawnFlash = nil
		end
		
		entity:SetColor(color, 1, statusColorPriority, false, false)
		
		for i = #data.FFNursingSpawns, 1, -1 do
			local spawn = data.FFNursingSpawns[i]
			if not spawn:Exists() then
				table.remove(data.FFNursingSpawns, i)
			elseif mod:GetEntityData(spawn).FFPacifiedDuration == nil then
				local typ, var = spawn.Type, spawn.Variant
				local basecolor = color
				if typ <= 9 or typ >= 1000 then
					basecolor = spawncolor
				end
				
				local currentColor = spawn:GetSprite().Color
				local newColor = Color.Lerp(basecolor, currentColor, 0)
				newColor.A = currentColor.A
				spawn:SetColor(newColor, statusColorPriority, statusColorPriority, false, false)
			end
		end
	end
end

function mod:nursingSpawnBlacklisted(entity)
	local typ, var, subt = entity.Type, entity.Variant, entity.SubType
	return FiendFolio.NursingSpawnBlacklist[typ] or
	       FiendFolio.NursingSpawnBlacklist[typ .. " " .. var] or
	       FiendFolio.NursingSpawnBlacklist[typ .. " " .. var .. " " .. subt]
end

function mod:initNursingSpawns(entity, data)
	if data.FFNursingSpawns == nil then
		data.FFNursingSpawns = {}
		
		-- forgive me father for i must sin
		local index, initSeed = entity.Index, entity.InitSeed
		for _, e2 in ipairs(mod.GetRoomEntitiesCache()) do
			if not mod:nursingSpawnBlacklisted(e2) then
				local spawnerEnt = e2.SpawnerEntity
				local i = 0
				while (spawnerEnt ~= nil and i < 100) do
					local spawnerEnt = e2.SpawnerEntity
					if spawnerEnt.Index == index and spawnerEnt.InitSeed == initSeed then
						table.insert(data.FFNursingSpawns, e2)
						mod:GetEntityData(e2).FFSpawnedByNursing = entity
						break
					end
					spawnerEnt = spawnerEnt.SpawnerEntity
					i = i + 1
				end
			end
		end
	end
end

function mod.AddNursing(entity, source, duration, isCloned)
	if not (entity and entity:ToNPC()) then
		return
	end
	
	if (entity.Type == EntityType.ENTITY_MASK or (entity.Type == EntityType.ENTITY_MASK_OF_INFAMY and entity.Parent)) and not isCloned then
		return
	end
	
	if Isaac.RunCallbackWithParam(ModCallbacks.MC_PRE_STATUS_EFFECT_APPLY, "FFNursing", "FFNursing", entity, EntityRef(source), duration) == false then
		return
	end
	
	if mod:isSegmented(entity) and not isCloned then
		local segments = mod:getSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				mod.AddNursing(segment, source, duration, true)
			end
		end
	elseif mod:isBasegameSegmented(entity) and not isCloned then
		local segments = mod:getBasegameSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				mod.AddNursing(segment, source, duration, true)
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
		data.FFNursingDuration = math.max(data.FFNursingDuration or 0, duration)
		data.FFNursingSource = EntityRef(source)
		mod:initNursingSpawns(entity, data)
		entity:SetColor(FiendFolio.StatusEffectColors.Nursing, 1, statusColorPriority, false, false)
		
		if isBoss then
			entity:SetBossStatusEffectCooldown(FiendFolio.StatusEffectVariables.BossStatusResistanceFrameCount)
		end
		
		mod:TrackEnemyStatus(entity, statusflag)
		
		local ptrhash = GetPtrHash(entity)
		mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
		mod.VasculitisInfo[ptrhash][statusflag] = {Source = data.FFNursingSource}
		
		Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_STATUS_EFFECT_APPLY, "FFNursing", "FFNursing", entity, EntityRef(source), duration)
	end
end

function mod.RemoveNursing(entity, isCloned)
	if mod:isSegmented(entity) and not isCloned then
		local segments = mod:getSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				mod.RemoveNursing(segment, true)
			end
		end
	elseif mod:isBasegameSegmented(entity) and not isCloned then
		local segments = mod:getBasegameSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				mod.RemoveNursing(segment, true)
			end
		end
	end

	local data = mod:GetEntityData(entity)
	data.FFNursingDuration = nil
	data.FFNursingSpawns = nil
	data.FFNursingFlash = nil
	data.FFNursingSpawnFlash = nil
	mod:UntrackEnemyStatus(entity, statusflag)
	
	if not (entity:IsDead() or entity:HasMortalDamage()) then
		local ptrhash = GetPtrHash(entity)
		mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
		mod.VasculitisInfo[ptrhash][statusflag] = nil
	end
end

function FiendFolio.FlagNursing(entity, duration)
	TearFlagsLib.AddTearFlags(entity, tearflag)
	
	local params = TearFlagsLib.GetTearFlagParams(entity, tearflag)
	TearFlagsLib.SetTearFlagParams(entity, tearflag, {Duration = math.max(params.Duration or 0, duration)})
end

function mod:applyNursingFlag(entity, player, source)
	-- need to get these values out first before scheduling cause otherwise they might get eaten by garbage collection
	-- happens with stuff like can of beans
	-- sucks but w/e
	local params = TearFlagsLib.GetTearFlagParams(source, tearflag)
	local duration = params.Duration
	
	local ptrhash = GetPtrHash(entity)
	mod.QueuedStatusApply[ptrhash] = mod.QueuedStatusApply[ptrhash] or {}
	table.insert(mod.QueuedStatusApply[ptrhash], function()
		FiendFolio.AddNursing(entity, player, duration)
	end)
end
mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, mod.applyNursingFlag, tearflag)

function mod.handleNursingD3(entity)
	local params = TearFlagsLib.GetTearFlagParams(entity, tearflag)
	TearFlagsLib.SetTearFlagParams(entity, tearflag, {Duration = math.max(params.Duration or 0, 120)})
end

function mod:nursingOnVasculitis(tear, npc)
	local ptrhash = GetPtrHash(npc)
	mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
	
	local vasculitisInfo = mod.VasculitisInfo[ptrhash][statusflag]
	if vasculitisInfo then
		local source = vasculitisInfo.Source
		local player = source and source.Entity and source.Entity:ToPlayer()
		local secondHandMultiplier = (player and (player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1)) or 1
		FiendFolio.FlagNursing(tear, 120 * secondHandMultiplier)
	end
end

function mod:nursingOnUpdate(npc, data, sprite, clearingStatus)
	if data.FFNursingDuration ~= nil and data.FFNursingDuration > 0 and not clearingStatus then
		mod:handleNursing(npc, data, sprite)
		--data.hasFFStatusIcon = true
	else
		data.FFNursingDuration = nil
		data.FFNursingSpawns = nil
		data.FFNursingFlash = nil
		data.FFNursingSpawnFlash = nil
		mod:UntrackEnemyStatus(npc, statusflag)
		
		if not (npc:IsDead() or npc:HasMortalDamage()) then
			local ptrhash = GetPtrHash(npc)
			mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
			mod.VasculitisInfo[ptrhash][statusflag] = nil
		end
	end
end

function mod:copyNursing(copy, copyData, source, sourceData)
	copyData.FFNursingDuration = sourceData.FFNursingDuration
	copyData.FFNursingSource = sourceData.FFNursingSource
	copyData.FFNursingFlash = Color.Lerp(sourceData.FFNursingFlash, sourceData.FFNursingFlash, 1)
	copyData.FFNursingSpawnFlash = Color.Lerp(sourceData.FFNursingSpawnFlash, sourceData.FFNursingSpawnFlash, 1)
	mod:initNursingSpawns(copy, copyData)
	
	mod:TrackEnemyStatus(copy, statusflag)
	
	local copyPtrhash = GetPtrHash(copy)
	local sourcePtrhash = GetPtrHash(source)
	mod.VasculitisInfo[copyPtrhash] = mod.VasculitisInfo[copyPtrhash] or {}
	mod.VasculitisInfo[sourcePtrhash] = mod.VasculitisInfo[sourcePtrhash] or {}
	if mod.VasculitisInfo[sourcePtrhash][statusflag] then
		mod.VasculitisInfo[copyPtrhash][statusflag] = {Source = mod.VasculitisInfo[sourcePtrhash][statusflag].Source or copyData.FFNursingSource}
	end
end

function mod:nursingHeal(player, src)
	player:AddHearts(1)
	player:SetMinDamageCooldown(60 * (player:GetTrinketMultiplier(TrinketType.TRINKET_BLIND_RAGE) + 1))
	player:SetColor(FiendFolio.StatusEffectColors.NursingHealFade, 16, 0, true, false)
	player:SetColor(FiendFolio.StatusEffectColors.NursingHealFlash, 2, 0, false, false)

	mod.NursingEnemiesToColor[GetPtrHash(src)] = {NPC = src, Frame = 0}
	for _, spawn in ipairs(mod:GetEntityData(src).FFNursingSpawns) do
		local typ = spawn.Type
		if not (typ <= 9 or typ >= 1000 or typ == FiendFolio.FFID.Tech) then
			mod.NursingEnemiesToColor[GetPtrHash(spawn)] = {NPC = spawn, Frame = 0}
		end
	end
	mod.RemoveNursing(src)

	sfx:Play(mod.Sounds.DrShambleHeal,2,0,false,1)
	sfx:Play(SoundEffect.SOUND_BAND_AID_PICK_UP,0.5,0,false,1)
	
	local notif = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, player.Position, nilvector, nil)
	notif.SpriteOffset = Vector(0, -24)
end

function mod:nursingTestForHeal(player, src)
	local srcdata = mod:GetEntityData(src)
	if srcdata.FFNursingDuration ~= nil then
		mod:nursingHeal(player, src)
		return false
	elseif srcdata.FFSpawnedByNursing and srcdata.FFSpawnedByNursing:Exists() and mod:GetEntityData(srcdata.FFSpawnedByNursing).FFNursingDuration ~= nil then
		mod:nursingHeal(player, srcdata.FFSpawnedByNursing)
		return false
    end
end

function mod:nursingOnDamage(player, source)
	if source and source.Entity then
		return mod:nursingTestForHeal(player, source.Entity)
	end
end

function mod:colorNursingEnemies()
	for k, npcInfo in pairs(mod.NursingEnemiesToColor) do
		local newColor
		if npcInfo.Frame < 2 then
			newColor = FiendFolio.StatusEffectColors.NursingHealFlash
		else
			local fade = math.max(0, math.min(1 - npcInfo.Frame / 16, 1))
			local currentColor = npcInfo.NPC:GetSprite().Color
			newColor = Color.Lerp(currentColor, Color(1,1,1,1,0,0,0), 0)
			newColor.A = currentColor.A
			newColor:SetOffset(currentColor.RO + 64/255 * fade, currentColor.GO + 128/255 * fade, currentColor.BO + 64/255 * fade)
		end
		npcInfo.NPC:SetColor(newColor, 1, healColorPriority, false, false)
		
		npcInfo.Frame = npcInfo.Frame + 1
		if npcInfo.Frame >= 16 then
			mod.NursingEnemiesToColor[k] = nil
		end
	end
end

function mod:nursingPostInit(entity)
	if not mod:nursingSpawnBlacklisted(entity) then
		local spawnerEnt = entity.SpawnerEntity
		while (spawnerEnt ~= nil) do
			local ptrhash = GetPtrHash(spawnerEnt)
			if mod.StatusesOnEnemy[ptrhash] and mod.StatusesOnEnemy[ptrhash][statusflag] then
				local data = mod:GetEntityData(spawnerEnt)
				mod:initNursingSpawns(spawnerEnt, data)
				table.insert(data.FFNursingSpawns, entity)
				mod:GetEntityData(entity).FFSpawnedByNursing = spawnerEnt
				break
			end
			spawnerEnt = spawnerEnt.SpawnerEntity
		end
	end
end
mod:AddManualCallback(ModCallbacks.MC_POST_BOMB_INIT, mod.nursingPostInit)
mod:AddManualCallback(ModCallbacks.MC_POST_KNIFE_INIT, mod.nursingPostInit)
mod:AddManualCallback(ModCallbacks.MC_POST_LASER_INIT, mod.nursingPostInit)
mod:AddManualCallback(ModCallbacks.MC_POST_PROJECTILE_INIT, mod.nursingPostInit)
mod:AddManualCallback(ModCallbacks.MC_POST_EFFECT_INIT, mod.nursingPostInit)
mod:AddManualCallback(ModCallbacks.MC_POST_NPC_INIT, mod.nursingPostInit)

local nursingInitCallbacksLoaded = false
function mod:nursingPostTrack(flag)
	if not nursingInitCallbacksLoaded and flag == statusflag then
		for _,_ in pairs(mod.EnemiesWithStatus[statusflag]) do
			mod:EnableManualCallback(ModCallbacks.MC_POST_BOMB_INIT, mod.nursingPostInit)
			mod:EnableManualCallback(ModCallbacks.MC_POST_KNIFE_INIT, mod.nursingPostInit)
			mod:EnableManualCallback(ModCallbacks.MC_POST_LASER_INIT, mod.nursingPostInit)
			mod:EnableManualCallback(ModCallbacks.MC_POST_PROJECTILE_INIT, mod.nursingPostInit)
			mod:EnableManualCallback(ModCallbacks.MC_POST_EFFECT_INIT, mod.nursingPostInit)
			mod:EnableManualCallback(ModCallbacks.MC_POST_NPC_INIT, mod.nursingPostInit)
			nursingInitCallbacksLoaded = true
			return
		end
	end
end

function mod:nursingPostUntrack(flag)
	if nursingInitCallbacksLoaded and flag == statusflag then
		for _,_ in pairs(mod.EnemiesWithStatus[statusflag]) do
			return
		end
		
		mod:DisableManualCallback(ModCallbacks.MC_POST_BOMB_INIT, mod.nursingPostInit)
		mod:DisableManualCallback(ModCallbacks.MC_POST_KNIFE_INIT, mod.nursingPostInit)
		mod:DisableManualCallback(ModCallbacks.MC_POST_LASER_INIT, mod.nursingPostInit)
		mod:DisableManualCallback(ModCallbacks.MC_POST_PROJECTILE_INIT, mod.nursingPostInit)
		mod:DisableManualCallback(ModCallbacks.MC_POST_EFFECT_INIT, mod.nursingPostInit)
		mod:DisableManualCallback(ModCallbacks.MC_POST_NPC_INIT, mod.nursingPostInit)
		nursingInitCallbacksLoaded = false
	end
end

mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, function(_, player, collider)
	mod:nursingTestForHeal(player, collider)
end)