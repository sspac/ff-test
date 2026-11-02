-- Mugged --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local statusflag = mod:RegisterEnemyStatusEffect("MUG", 10, "muggedOnUpdate", {HasIcon = true, Vasculitis = "muggedOnVasculitis"})
local tearflag = TearFlagsLib.RegisterTearFlag("MUG")
local statusColorPriority = 127

function mod:handleMugged(entity, data, sprite)
	data.FFMuggedDuration = data.FFMuggedDuration - 1
	if data.FFMuggedDuration >= 0 then
		if data.FFMuggedCoinsToSpawn == 0 then
			FiendFolio.RemoveMugged(entity)
			return
		end
		entity:SetColor(FiendFolio.StatusEffectColors.Mugged, 1, statusColorPriority, false, false)
	end
end

function FiendFolio.AddMugged(entity, source, duration, spawnCoinImmediate, coinsPerHit, maxCoins, isCloned)
	if not (entity and entity:ToNPC()) then
		return
	end
	
	if (entity.Type == EntityType.ENTITY_MASK or (entity.Type == EntityType.ENTITY_MASK_OF_INFAMY and entity.Parent)) and not isCloned then
		return
	end
	
	if Isaac.RunCallbackWithParam(ModCallbacks.MC_PRE_STATUS_EFFECT_APPLY, "FFMugged", "FFMugged", entity, EntityRef(source), duration) == false then
		return
	end
	
	if mod:isSegmented(entity) and not isCloned then
		local segments = mod:getSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.AddMugged(segment, source, duration, spawnCoinImmediate, coinsPerHit, maxCoins, true)
			end
		end
	elseif mod:isBasegameSegmented(entity) and not isCloned then
		local segments = mod:getBasegameSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.AddMugged(segment, source, duration, spawnCoinImmediate, coinsPerHit, maxCoins, true)
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
		--if data.FFMuggedDuration == nil then
		--	sfx:Play(mod.Sounds.CursedPennyNegative, 0.7, 0, false, 1.5)
		--end
		
		data.FFMuggedSource = EntityRef(source)
		data.FFMuggedCoinsPerHit = coinsPerHit or 1
		data.FFMuggedCoinsToSpawn = math.max(data.FFMuggedCoinsToSpawn or 0, maxCoins or 10)
		
		if spawnCoinImmediate and (data.FFMuggedDuration or 0) <= 0 then
			FiendFolio.SpawnMuggedMicroPenny(entity, data, data.FFMuggedSource)
		end
		data.FFMuggedDuration = math.max(data.FFMuggedDuration or 0, duration)
		
		if isBoss then
			entity:SetBossStatusEffectCooldown(FiendFolio.StatusEffectVariables.BossStatusResistanceFrameCount)
		end
		
		mod:TrackEnemyStatus(entity, statusflag)
		
		local ptrhash = GetPtrHash(entity)
		mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
		mod.VasculitisInfo[ptrhash][statusflag] = {Source = data.FFMuggedSource}
		
		Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_STATUS_EFFECT_APPLY, "FFMugged", "FFMugged", entity, EntityRef(source), duration)
	end
end

function FiendFolio.RemoveMugged(entity, isCloned)
	if mod:isSegmented(entity) and not isCloned then
		local segments = mod:getSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.RemoveMugged(segment, true)
			end
		end
	elseif mod:isBasegameSegmented(entity) and not isCloned then
		local segments = mod:getBasegameSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.RemoveMugged(segment, true)
			end
		end
	end

	local data = mod:GetEntityData(entity)
	data.FFMuggedDuration = nil
	data.FFMuggedSource = nil
	data.FFMuggedCoinsPerHit = nil
	data.FFMuggedCoinsToSpawn = nil
	mod:UntrackEnemyStatus(entity, statusflag)
	
	if not (entity:IsDead() or entity:HasMortalDamage()) then
		local ptrhash = GetPtrHash(entity)
		mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
		mod.VasculitisInfo[ptrhash][statusflag] = nil
	end
end

function FiendFolio.SpawnMuggedMicroPenny(entity, data, source)
	local frame = game:GetFrameCount()
	if data.FFMuggedLastFrameSpawnedCoin ~= frame then
		for i = 1, data.FFMuggedCoinsPerHit or 1 do
			if data.FFMuggedCoinsToSpawn ~= 0 then
				local vec = RandomVector()*mod:RandomInt(40,80)/10
				local coin = Isaac.Spawn(5, 20, FiendFolio.PICKUP.COIN.LIL_PENNY, entity.Position, vec, source and source.Entity or Isaac.GetPlayer(0)):ToPickup()
				coin.Timeout = 450
				data.FFMuggedCoinsToSpawn = data.FFMuggedCoinsToSpawn - 1
			end
		end
		data.FFMuggedLastFrameSpawnedCoin = frame
	end
	--sfx:Play(mod.Sounds.CursedPennyNegative, 0.45, 0, false, 1.5 - (0.15 * math.random() - 0.1))
	--sfx:Play(mod.Sounds.CursedPennyNegative, 0.45, 0, false, 1.4 - 0.1 * math.random())
end

function mod:muggedOnDamage(ent, data, amount)
	if amount > 0 and data.FFMuggedDuration ~= nil and data.FFMuggedDuration > 0 and ent:IsVulnerableEnemy() then
		if not data.FFMuggedSource then
			data.FFMuggedSource = EntityRef(Isaac.GetPlayer(0))
		end
		FiendFolio.SpawnMuggedMicroPenny(ent, data, data.FFMuggedSource)
	end
end

function FiendFolio.FlagMug(entity, duration)
	TearFlagsLib.AddTearFlags(entity, tearflag)
	
	local params = TearFlagsLib.GetTearFlagParams(entity, tearflag)
	TearFlagsLib.SetTearFlagParams(entity, tearflag, {Duration = math.max(params.Duration or 0, duration)})
end

function mod:applyMugFlag(entity, player, source)
	-- need to get these values out first before scheduling cause otherwise they might get eaten by garbage collection
	-- happens with stuff like can of beans
	-- sucks but w/e
	local params = TearFlagsLib.GetTearFlagParams(source, tearflag)
	local duration = params.Duration
	
	local ptrhash = GetPtrHash(entity)
	mod.QueuedStatusApply[ptrhash] = mod.QueuedStatusApply[ptrhash] or {}
	table.insert(mod.QueuedStatusApply[ptrhash], function()
		FiendFolio.AddMugged(entity, player, duration, true)
	end)
end
mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, mod.applyMugFlag, tearflag)

function mod.handleMugD3(entity)
	local params = TearFlagsLib.GetTearFlagParams(entity, tearflag)
	TearFlagsLib.SetTearFlagParams(entity, tearflag, {Duration = math.max(params.Duration or 0, 90)})
end

function mod:muggedOnVasculitis(tear, npc)
	local ptrhash = GetPtrHash(npc)
	mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
	
	local vasculitisInfo = mod.VasculitisInfo[ptrhash][statusflag]
	if vasculitisInfo then
		local source = vasculitisInfo.Source
		local player = source and source.Entity and source.Entity:ToPlayer()
		local secondHandMultiplier = (player and (player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1)) or 1
		FiendFolio.FlagMug(tear, 90 * secondHandMultiplier)
	end
end

function mod:muggedOnUpdate(npc, data, sprite, clearingStatus)
	if data.FFMuggedDuration ~= nil and data.FFMuggedDuration > 0 and not clearingStatus then
		mod:handleMugged(npc, data, sprite)
		--data.hasFFStatusIcon = true
	else
		data.FFMuggedDuration = nil
		data.FFMuggedSource = nil
		data.FFMuggedCoinsPerHit = nil
		data.FFMuggedCoinsToSpawn = nil
		mod:UntrackEnemyStatus(npc, statusflag)
		
		if not (npc:IsDead() or npc:HasMortalDamage()) then
			local ptrhash = GetPtrHash(npc)
			mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
			mod.VasculitisInfo[ptrhash][statusflag] = nil
		end
	end
end

function mod:copyMugged(copy, copyData, source, sourceData)
	copyData.FFMuggedDuration = sourceData.FFMuggedDuration
	copyData.FFMuggedSource = sourceData.FFMuggedSource
	copyData.FFMuggedCoinsPerHit = sourceData.FFMuggedCoinsPerHit
	copyData.FFMuggedCoinsToSpawn = sourceData.FFMuggedCoinsToSpawn
	
	mod:TrackEnemyStatus(copy, statusflag)
	
	local copyPtrhash = GetPtrHash(copy)
	local sourcePtrhash = GetPtrHash(source)
	mod.VasculitisInfo[copyPtrhash] = mod.VasculitisInfo[copyPtrhash] or {}
	mod.VasculitisInfo[sourcePtrhash] = mod.VasculitisInfo[sourcePtrhash] or {}
	if mod.VasculitisInfo[sourcePtrhash][statusflag] then
		mod.VasculitisInfo[copyPtrhash][statusflag] = {Source = mod.VasculitisInfo[sourcePtrhash][statusflag].Source or copyData.FFMuggedSource}
	end
end
