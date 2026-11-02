-- Hemorrhaging --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local statusflag = mod:RegisterEnemyStatusEffect("HEMORRHAGE", 20, "hemorragingOnUpdate", {HasIcon = true, Vasculitis = "hemorragingOnVasculitis"})
local tearflag = TearFlagsLib.RegisterTearFlag("HEMORRHAGE")
local statusColorPriority = 127

function mod:handleBleed(entity, data, sprite)
	data.FFBleedDuration = data.FFBleedDuration - 1
	if data.FFBleedDuration >= 0 then
		--entity:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
		entity:SetColor(FiendFolio.StatusEffectColors.Bleed, 1, statusColorPriority, false, false)

		if not data.FFBleedSource then
			data.FFBleedSource = EntityRef(Isaac.GetPlayer(0))
		end

		local frameCount = game:GetFrameCount()

		if mod:checkIfStatusLogicIsApplied(entity, true) then
			if frameCount % FiendFolio.StatusEffectVariables.BleedDamageTickRate == 0 then
				data.FFTakingBleedDamage = true
				entity:TakeDamage(data.FFBleedDamage * FiendFolio.StatusEffectVariables.BleedDamagePercentage, 0, data.FFBleedSource, 0)
				data.FFTakingBleedDamage = nil
			end
		end

		if frameCount % FiendFolio.StatusEffectVariables.BleedCreepTickRate == 0 then
			local size = entity.Size
			local hasCork = data.FFBleedHasCork

			local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, entity.Position, nilvector, data.FFBleedSource.Entity or Isaac.GetPlayer(0)):ToEffect()
			creep.Scale = size / 15 + 0.15
			if hasCork then creep.Scale = creep.Scale * 2 end

			creep.CollisionDamage = data.FFBleedDamage * FiendFolio.StatusEffectVariables.BleedCreepDamagePercentage
			creep:SetTimeout(FiendFolio.StatusEffectVariables.BleedCreepTimeout)
			creep:Update()

			if (hasCork and size >= 15) or size >= 30 then
				math.randomseed(creep.InitSeed)
				creep:GetSprite():SetFrame("BiggestBlood0"..math.random(6), 0)

				local creepScale = size / 48 + 0.15
				if hasCork then creepScale = creepScale * 2 end

				creep.Scale = creepScale
				creep.Size = creepScale
				creep.SpriteScale = Vector(creepScale, creepScale)
			elseif (hasCork and size >= 7.5) or size >= 15 then
				math.randomseed(creep.InitSeed)
				creep:GetSprite():SetFrame("BigBlood0"..math.random(6), 0)

				local creepScale = size / 25 + 0.15
				if hasCork then creepScale = creepScale * 2 end

				creep.Scale = creepScale
				creep.Size = creepScale
				creep.SpriteScale = Vector(creepScale, creepScale)
			end
		end
		
		if math.random() <= FiendFolio.StatusEffectVariables.BleedTearChance then
			if mod:checkIfStatusLogicIsApplied(entity, true, true) then
				local angle = math.random() * 360.0
				local vel = Vector.FromAngle(angle):Resized(math.random() * FiendFolio.StatusEffectVariables.BleedTearVelocityScale + FiendFolio.StatusEffectVariables.BleedTearVelocityBase)
				vel = vel + entity.Velocity * FiendFolio.StatusEffectVariables.BleedTearEntityVelocityInheritance
				
				local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLOOD, 0, entity.Position, vel, data.FFBleedSource.Entity or Isaac.GetPlayer(0)):ToTear()
				local rand = math.random()
				tear.CollisionDamage = data.FFBleedDamage * (rand * 0.3375 + 0.675) * FiendFolio.StatusEffectVariables.BleedTearDamagePercentage
				tear.Scale = (0.55 + math.sqrt(data.FFBleedDamage) * 0.23 + data.FFBleedDamage / 100) * (rand * 0.5 + 0.75)
				tear.Height = -11.01 + math.random() * 1.02
				tear.FallingSpeed = -14.1 + math.random() * 10.2
				tear.FallingAcceleration = 0.5
				
				mod:GetEntityData(tear).FFHemorrhagingTear = true
				mod:GetEntityData(tear).FFHemorrhagingTearSpawner = entity
				tear.SpawnerEntity = nil -- temp fix
				tear:Update()
			end
		end
	end
end

mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, function(_, tear, entity, mysteryBoolean)
	local data = mod:GetEntityData(tear)
	local spawnerEntity = data.FFHemorrhagingTearSpawner
	
	if data.FFHemorrhagingTear and spawnerEntity and spawnerEntity:Exists() then
		if spawnerEntity.Index == entity.Index and spawnerEntity.InitSeed == entity.InitSeed then
			return true
		elseif mod:isSegmented(spawnerEntity) and mod:isInSegmentsOf(entity, spawnerEntity) then
			return true
		elseif mod:isBasegameSegmented(spawnerEntity) and mod:isInBasegameSegmentsOf(entity, spawnerEntity) then
			return true
		end
	end
end)

function FiendFolio.AddHemorrhage(entity, source, duration, damage, isCloned, isSanguine)
	if not (entity and entity:ToNPC()) then
		return
	end
	
	if (entity.Type == EntityType.ENTITY_MASK or (entity.Type == EntityType.ENTITY_MASK_OF_INFAMY and entity.Parent)) and not isCloned then
		return
	end
	
	if Isaac.RunCallbackWithParam(ModCallbacks.MC_PRE_STATUS_EFFECT_APPLY, "FFHemorrhaging", "FFHemorrhaging", entity, EntityRef(source), duration) == false then
		return
	end
	
	if mod:isSegmented(entity) and not isCloned then
		local segments = mod:getSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.AddBleed(segment, source, duration, damage, true, isSanguine)
			end
		end
	elseif mod:isBasegameSegmented(entity) and not isCloned then
		local segments = mod:getBasegameSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.AddBleed(segment, source, duration, damage, true, isSanguine)
			end
		end
	end

	local data = mod:GetEntityData(entity)
	local isBoss = entity:IsBoss()
	local ptrhash = GetPtrHash(entity)
	if not (isSanguine and mod.BruiseBossStatusResistance[ptrhash]) and isBoss and entity:GetBossStatusEffectCooldown() > 0 then
		--do nothing
	elseif not (entity:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) or mod:isStatusBlacklisted(entity)) or 
	       ((entity.Type == EntityType.ENTITY_MASK or entity.Type == EntityType.ENTITY_MASK_OF_INFAMY) and isCloned) 
	then
		data.FFBleedDuration = math.max(data.FFBleedDuration or 0, duration)
		data.FFBleedDamage = math.max(data.FFBleedDamage or 0, damage)
		data.FFBleedSource = EntityRef(source)
		
		data.FFBleedHasCork = source and 
			                  source.Type == EntityType.ENTITY_PLAYER and 
			                  source:ToPlayer():HasTrinket(TrinketType.TRINKET_LOST_CORK)
		
		if isBoss and not isSanguine then
			entity:SetBossStatusEffectCooldown(FiendFolio.StatusEffectVariables.BossStatusResistanceFrameCount)
		end
		
		mod:TrackEnemyStatus(entity, statusflag)
		mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
		mod.VasculitisInfo[ptrhash][statusflag] = {Source = data.FFBleedSource}
		
		Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_STATUS_EFFECT_APPLY, "FFHemorrhaging", "FFHemorrhaging", entity, EntityRef(source), duration)
	end
end
FiendFolio.AddBleed = FiendFolio.AddHemorrhage -- old name

function FiendFolio.RemoveHemorrhage(entity, isCloned)
	if mod:isSegmented(entity) and not isCloned then
		local segments = mod:getSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.RemoveBleed(segment, true)
			end
		end
	elseif mod:isBasegameSegmented(entity) and not isCloned then
		local segments = mod:getBasegameSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.RemoveBleed(segment, true)
			end
		end
	end

	local data = mod:GetEntityData(entity)
	data.FFBleedDuration = nil
	mod:UntrackEnemyStatus(entity, statusflag)
	
	if not (entity:IsDead() or entity:HasMortalDamage()) then
		local ptrhash = GetPtrHash(entity)
		mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
		mod.VasculitisInfo[ptrhash][statusflag] = nil
	end
end
FiendFolio.RemoveBleed = FiendFolio.RemoveHemorrhage -- old name

function FiendFolio.FlagHemorrhage(entity, duration, damage)
	TearFlagsLib.AddTearFlags(entity, tearflag)
	
	local params = TearFlagsLib.GetTearFlagParams(entity, tearflag)
	TearFlagsLib.SetTearFlagParams(entity, tearflag, {Duration = math.max(params.Duration or 0, duration),
	                                                  Damage = math.max(params.Damage or 0, damage)})
end

function mod:applyHemorrhageFlag(entity, player, source)
	local data = mod:GetEntityData(source)
	local params = TearFlagsLib.GetTearFlagParams(source, tearflag)
	FiendFolio.AddBleed(entity, player, params.Duration, params.Damage)
end
mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, mod.applyHemorrhageFlag, tearflag)

function mod.handleHemorrhageD3(entity)
	local player = TearFlagsLib.GetTearPlayer(entity)
	local params = TearFlagsLib.GetTearFlagParams(entity, tearflag)
	TearFlagsLib.SetTearFlagParams(entity, tearflag, {Duration = math.max(params.Duration or 0, 180),
	                                                  Damage = math.max(params.Damage or 0, ((player and player.Damage) or 3.5) * 0.5)})
end

function mod:hemorragingOnVasculitis(tear, npc)
	local ptrhash = GetPtrHash(npc)
	mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
	
	local vasculitisInfo = mod.VasculitisInfo[ptrhash][statusflag]
	if vasculitisInfo then
		local source = vasculitisInfo.Source
		local player = source and source.Entity and source.Entity:ToPlayer()
		local secondHandMultiplier = (player and (player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1)) or 1
		FiendFolio.FlagHemorrhage(tear, 90 * secondHandMultiplier, player.Damage * 0.5)
	end
end

function mod:hemorragingOnUpdate(npc, data, sprite, clearingStatus)
	if data.FFBleedDuration ~= nil and data.FFBleedDuration > 0 and not clearingStatus then
		mod:handleBleed(npc, data, sprite)
		data.hasFFStatusIcon = true
	else
		data.FFBleedDuration = nil
		mod:UntrackEnemyStatus(npc, statusflag)
	
		if not (npc:IsDead() or npc:HasMortalDamage()) then
			local ptrhash = GetPtrHash(npc)
			mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
			mod.VasculitisInfo[ptrhash][statusflag] = nil
		end
	end
end

function mod:copyHemorraging(copy, copyData, source, sourceData)
	copyData.FFBleedDuration = sourceData.FFBleedDuration
	copyData.FFBleedDamage = sourceData.FFBleedDamage
	copyData.FFBleedSource = sourceData.FFBleedSource
	copyData.FFBleedHasCork = sourceData.FFBleedHasCork
	
	mod:TrackEnemyStatus(copy, statusflag)
	
	local copyPtrhash = GetPtrHash(copy)
	local sourcePtrhash = GetPtrHash(source)
	mod.VasculitisInfo[copyPtrhash] = mod.VasculitisInfo[copyPtrhash] or {}
	mod.VasculitisInfo[sourcePtrhash] = mod.VasculitisInfo[sourcePtrhash] or {}
	if mod.VasculitisInfo[sourcePtrhash][statusflag] then
		mod.VasculitisInfo[copyPtrhash][statusflag] = {Source = mod.VasculitisInfo[sourcePtrhash][statusflag].Source or copyData.FFBleedSource}
	end
end
