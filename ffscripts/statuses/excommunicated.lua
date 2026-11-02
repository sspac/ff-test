-- Excommunicated --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local statusflag = mod:RegisterEnemyStatusEffect("EXCOMMUNICATE", 10000, "excommunicatedOnUpdate", {Vasculitis = "excommunicatedOnVasculitis"})
local tearflag = TearFlagsLib.RegisterTearFlag("EXCOMMUNICATE")
local statusColorPriority = 1

local TeleportUpFrames = {
	[0] = {OffsetX = 0, OffsetY = 8,
	       ScaleX = 0.90, ScaleY = 1.10,
	       Color = Color(0.0, 0.0, 0.0, 1.0, 0/255, 0/255, 0/255)},
	[1] = {OffsetX = 0, OffsetY = 8,
	       ScaleX = 0.90, ScaleY = 1.10,
	       Color = Color(1.0, 1.0, 1.0, 1.0, 255/255, 255/255, 255/255)},
	[2] = {OffsetX = 0, OffsetY = -24,
	       ScaleX = 1.40, ScaleY = 0.60,
	       Color = Color(0.0, 0.0, 0.0, 1.0, 0/255, 0/255, 0/255)},
	[3] = {OffsetX = 0, OffsetY = -24,
	       ScaleX = 1.40, ScaleY = 0.60,
	       Color = Color(1.0, 1.0, 1.0, 1.0, 255/255, 255/255, 255/255)},
	[4] = {OffsetX = 0, OffsetY = -24,
	       ScaleX = 1.80, ScaleY = 0.50,
	       Color = Color(0.0, 0.0, 0.0, 1.0, 0/255, 0/255, 0/255)},
	[5] = {OffsetX = 0, OffsetY = 26,
	       ScaleX = 0.50, ScaleY = 2.20,
	       Color = Color(1.0, 1.0, 1.0, 1.0, 255/255, 255/255, 255/255)},
	[6] = {OffsetX = 0, OffsetY = 26,
	       ScaleX = 0.30, ScaleY = 3.00,
	       Color = Color(0.0, 0.0, 0.0, 1.0, 0/255, 0/255, 0/255)},
	[7] = {OffsetX = 0, OffsetY = 30,
	       ScaleX = 0.10, ScaleY = 8.00,
	       Color = Color(1.0, 1.0, 1.0, 1.0, 255/255, 255/255, 255/255)},
}

local TeleportDownFrames = {
	[0] = {OffsetX = 0, OffsetY = 30,
	       ScaleX = 0.10, ScaleY = 8.00,
	       Color = Color(1.0, 1.0, 1.0, 1.0, 255/255, 255/255, 255/255)},
	[1] = {OffsetX = 0, OffsetY = 26,
	       ScaleX = 0.30, ScaleY = 3.00,
	       Color = Color(0.0, 0.0, 0.0, 1.0, 0/255, 0/255, 0/255)},
	[2] = {OffsetX = 0, OffsetY = 26,
	       ScaleX = 0.50, ScaleY = 2.20,
	       Color = Color(1.0, 1.0, 1.0, 1.0, 255/255, 255/255, 255/255)},
	[3] = {OffsetX = 0, OffsetY = -24,
	       ScaleX = 1.80, ScaleY = 0.50,
	       Color = Color(0.0, 0.0, 0.0, 1.0, 0/255, 0/255, 0/255)},
	[4] = {OffsetX = 0, OffsetY = -24,
	       ScaleX = 1.40, ScaleY = 0.60,
	       Color = Color(1.0, 1.0, 1.0, 1.0, 255/255, 255/255, 255/255)},
	[5] = {OffsetX = 0, OffsetY = -24,
	       ScaleX = 1.40, ScaleY = 0.60,
	       Color = Color(0.0, 0.0, 0.0, 1.0, 0/255, 0/255, 0/255)},
	[6] = {OffsetX = 0, OffsetY = 8,
	       ScaleX = 0.90, ScaleY = 1.10,
	       Color = Color(1.0, 1.0, 1.0, 1.0, 255/255, 255/255, 255/255)},
	[7] = {OffsetX = 0, OffsetY = 8,
	       ScaleX = 0.90, ScaleY = 1.10,
	       Color = Color(0.0, 0.0, 0.0, 1.0, 0/255, 0/255, 0/255)},
}

function mod:doExcommunicatedDamage(entity, damage, source, isPartial, overrideDamage)
	local level = game:GetLevel()
	local dmg = (overrideDamage and damage) or 
	            (FiendFolio.StatusEffectVariables.ExcommunicatedBaseDamage + FiendFolio.StatusEffectVariables.ExcommunicatedFloorAdditiveDamage * level:GetAbsoluteStage())
	local telefragDmg = dmg * FiendFolio.StatusEffectVariables.ExcommunicatedTelefragDamageMultiplier
	
	if not isPartial and 
	   (not (mod:isSegmented(entity) or mod:isBasegameSegmented(entity)) or 
	    mod:isMainSegment(entity) or mod:isBasegameMainSegment(entity))
	then
		local enemiesToDamage = Isaac.FindInRadius(entity.Position, 
		                                           math.max(entity.Size + FiendFolio.StatusEffectVariables.ExcommunicatedDamageExtraRadius, 
		                                                    FiendFolio.StatusEffectVariables.ExcommunicatedDamageMinRadius), 
		                                           EntityPartition.ENEMY)
		for _, enemy in ipairs(enemiesToDamage) do
			if enemy:ToNPC() and (enemy.Index ~= entity.Index or enemy.InitSeed ~= entity.InitSeed) then
				if mod:checkIfStatusLogicIsApplied(enemy, true) then
					enemy:TakeDamage(telefragDmg, 0, source, 0)
				end
			end
		end
	end
	
	if mod:checkIfStatusLogicIsApplied(entity, true) then
		entity:TakeDamage((isPartial and damage * 0.5) or dmg, 0, source, 0)
		sfx:Play(SoundEffect.SOUND_BLACK_POOF, 0.9, 0, false, ((isPartial and 4) or 2) + math.random() * 0.1)
	end
	
	local poof = Isaac.Spawn(1000, 16, 1, entity.Position, nilvector, nil):ToEffect()
	poof:GetSprite().Color = Color(1.0, 1.0, 1.0, 0.5, 0/255, 0/255, 0/255)
	poof.SpriteScale = Vector(entity.Size / 40 + 0.2, entity.Size / 40 + 0.2) * ((isPartial and 0.7) or 1)
end

function mod:handleExcommunicated(entity, data, sprite)
	data.FFExcommunicatedDuration = data.FFExcommunicatedDuration - 1
	if data.FFExcommunicatedDuration >= 0 and (data.FFExcommunicatedStarted or not entity:HasMortalDamage()) then
		data.FFExcommunicatedStarted = true
		
		data.FFExcommunicatedOriginalSpriteOffset = data.FFExcommunicatedOriginalSpriteOffset or Vector(sprite.Offset.X, sprite.Offset.Y)
		data.FFExcommunicatedOriginalSpriteScale = data.FFExcommunicatedOriginalSpriteScale or Vector(sprite.Scale.X, sprite.Scale.Y)
		data.FFExcommunicatedOriginalCollisionClass = data.FFExcommunicatedOriginalCollisionClass or entity.EntityCollisionClass
		
		if data.FFExcommunicatedInitialPosition == nil then
			data.FFExcommunicatedInitialPosition = entity.Position
		end
		entity.Position = data.FFExcommunicatedInitialPosition
		
		if data.FFExcommunicatedTarget == nil or not data.FFExcommunicatedTarget:Exists() then
			local target = Isaac.Spawn(1000, 1756, 0, entity.Position, nilvector, entity):ToEffect()
			target.Parent = entity
			target.DepthOffset = -9999
			target:GetSprite().Color = Color(1.0, 1.0, 1.0, 0.75, 0, 0, 0)
			data.FFExcommunicatedTarget = target
		end
		
		if data.FFExcommunicatedDuration > FiendFolio.StatusEffectVariables.ExcommunicatedShortDuration and
		   not FiendFolio.CheckIfShouldExcommunicate(false)
		then
			data.FFExcommunicatedDuration = FiendFolio.StatusEffectVariables.ExcommunicatedShortDuration
			data.FFExcommunicatedIsShorted = true
		end
		
		if data.FFExcommunicatedTeleportUp == 0 then
			sfx:Play(SoundEffect.SOUND_HELL_PORTAL1, 1, 0, false, 1)
		elseif data.FFExcommunicatedDuration <= 8 and data.FFExcommunicatedTeleportDown == 0 then
			sfx:Play(SoundEffect.SOUND_HELL_PORTAL2, 1, 0, false, 1)
		end
		
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		
		if data.FFExcommunicatedDuration == 0 or data.FFExcommunicatedTeleportDown >= 8 then
			sprite.Offset = data.FFExcommunicatedOriginalSpriteOffset
			sprite.Scale = data.FFExcommunicatedOriginalSpriteScale
			entity.EntityCollisionClass = data.FFExcommunicatedOriginalCollisionClass
			entity.Visible = true
			
			data.FFExcommunicatedDuration = nil
			data.FFExcommunicatedMaxDuration = nil
			data.FFExcommunicatedTeleportUp = nil
			data.FFExcommunicatedTeleportDown = nil
			data.FFExcommunicatedOriginalSpriteOffset = nil
			data.FFExcommunicatedOriginalSpriteScale = nil
			data.FFExcommunicatedOriginalCollisionClass = nil
			data.FFExcommunicatedSource = nil
			data.FFExcommunicatedDamage = nil
			data.FFExcommunicatedOverrideDamage = nil
			data.FFExcommunicatedInitialPosition = nil
			data.FFExcommunicatedIsShorted = nil
			data.FFExcommunicatedStarted = nil
			mod:UntrackEnemyStatus(entity, statusflag)
			
			if not (entity:IsDead() or entity:HasMortalDamage()) then
				local ptrhash = GetPtrHash(entity)
				mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
				mod.VasculitisInfo[ptrhash][statusflag] = nil
			end
			
			if data.FFExcommunicatedTarget and data.FFExcommunicatedTarget:Exists() then
				data.FFExcommunicatedTarget:Remove()
			end
			data.FFExcommunicatedTarget = nil
		elseif data.FFExcommunicatedDuration <= 8 and data.FFExcommunicatedTeleportDown < 8 then
			local frame = TeleportDownFrames[data.FFExcommunicatedTeleportDown]
			local originalOffset = data.FFExcommunicatedOriginalSpriteOffset
			local originalScale = data.FFExcommunicatedOriginalSpriteScale
			
			sprite.Offset = Vector(originalOffset.X + frame.OffsetX, originalOffset.Y + frame.OffsetY)
			sprite.Scale = Vector(originalScale.X * frame.ScaleX, originalScale.Y * frame.ScaleY)
			
			entity:SetColor(frame.Color, 1, statusColorPriority, false, false)
			entity.Visible = true
		
			if (data.FFExcommunicatedTeleportDown or 0) == 2 then
				mod:doExcommunicatedDamage(entity, data.FFExcommunicatedDamage, data.FFExcommunicatedSource, nil, data.FFExcommunicatedOverrideDamage)
			end
			
			data.FFExcommunicatedTeleportDown = data.FFExcommunicatedTeleportDown + 1
		elseif data.FFExcommunicatedTeleportUp < 8 then
			local frame = TeleportUpFrames[data.FFExcommunicatedTeleportUp]
			local originalOffset = data.FFExcommunicatedOriginalSpriteOffset
			local originalScale = data.FFExcommunicatedOriginalSpriteScale
			
			sprite.Offset = Vector(originalOffset.X + frame.OffsetX, originalOffset.Y + frame.OffsetY)
			sprite.Scale = Vector(originalScale.X * frame.ScaleX, originalScale.Y * frame.ScaleY)
			
			entity:SetColor(frame.Color, 1, statusColorPriority, false, false)
			entity.Visible = true
			
			data.FFExcommunicatedTeleportUp = data.FFExcommunicatedTeleportUp + 1
		else
			entity.Visible = false
		end
		
		if data.FFExcommunicatedDuration == 10 then
			local beam = Isaac.Spawn(1000, 1757, 0, entity.Position, nilvector, nil):ToEffect()
			beam:GetSprite():Play("Spotlight", true)
		end
		
		if not entity:HasEntityFlags(EntityFlag.FLAG_FREEZE) then
			entity:AddEntityFlags(EntityFlag.FLAG_FREEZE)
			local ptrhash = GetPtrHash(entity)
			mod.HasTempStatusFlag[ptrhash] = {NPC = entity, 
			                                  FlagsToRemove = ((mod.HasTempStatusFlag[ptrhash] and mod.HasTempStatusFlag[ptrhash].FlagsToRemove) or 0) | EntityFlag.FLAG_FREEZE}
		end
		
		if not entity:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) then
			entity:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
			local ptrhash = GetPtrHash(entity)
			mod.HasTempStatusFlag[ptrhash] = {NPC = entity, 
			                                  FlagsToRemove = ((mod.HasTempStatusFlag[ptrhash] and mod.HasTempStatusFlag[ptrhash].FlagsToRemove) or 0) | EntityFlag.FLAG_NO_TARGET}
		end
		
		if data.FFExcommunicatedTarget and data.FFExcommunicatedTarget:Exists() then
			local targetSprite = data.FFExcommunicatedTarget:GetSprite()
			if data.FFExcommunicatedIsShorted then
				if not targetSprite:IsPlaying("Warning Blink") then
					targetSprite:Play("Warning Blink", true)
				end
				
				if (data.FFExcommunicatedTeleportDown or 0) >= 3 then
					data.FFExcommunicatedTarget.Visible = false
				end
			else
				local percentageFinished = 1 - ((data.FFExcommunicatedDuration - FiendFolio.StatusEffectVariables.ExcommunicatedWarningDuration) / 
				                                (data.FFExcommunicatedMaxDuration - FiendFolio.StatusEffectVariables.ExcommunicatedWarningDuration))
				
				local anim = "78 Blink"
				if percentageFinished < 0.125 then
					anim = "08 Blink"
				elseif percentageFinished < 0.25 then
					anim = "18 Blink"
				elseif percentageFinished < 0.375 then
					anim = "28 Blink"
				elseif percentageFinished < 0.5 then
					anim = "38 Blink"
				elseif percentageFinished < 0.625 then
					anim = "48 Blink"
				elseif percentageFinished < 0.75 then
					anim = "58 Blink"
				elseif percentageFinished < 0.875 then
					anim = "68 Blink"
				end
				
				if data.FFExcommunicatedDuration <= FiendFolio.StatusEffectVariables.ExcommunicatedWarningDuration then
					anim = "Warning Blink"
				end
				
				if not targetSprite:IsPlaying(anim) then
					local frame = targetSprite:GetFrame()
					targetSprite:Play(anim, true)
					targetSprite:SetFrame(frame)
				end
				
				if (data.FFExcommunicatedTeleportDown or 0) >= 3 then
					data.FFExcommunicatedTarget.Visible = false
				end
			end
		end
	end
end

local function isPartialExcommunicationOnAdd(entity, isCloned)
	local isBossWithResistance = entity:ToNPC():IsBoss() and (mod:hasCustomStatus(entity) or mod:GetEntityData(entity).FFBossStatusResistance)
	if isBossWithResistance then
		return true
	end
	
	return not FiendFolio.CheckIfShouldExcommunicate(true)
end

function FiendFolio.AddExcommunicated(entity, source, duration, damage, isCloned, ignorePartial, overrideDamage)
	if not (entity and entity:ToNPC()) then
		return
	end
	
	if (entity.Type == EntityType.ENTITY_MASK or (entity.Type == EntityType.ENTITY_MASK_OF_INFAMY and entity.Parent)) and not isCloned then
		return
	end
	
	if Isaac.RunCallbackWithParam(ModCallbacks.MC_PRE_STATUS_EFFECT_APPLY, "FFExcommunicated", "FFExcommunicated", entity, EntityRef(source), duration) == false then
		return
	end
	
	if mod:isSegmented(entity) and not isCloned then
		local segments = mod:getSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.AddExcommunicated(segment, source, duration, damage, true, ignorePartial, overrideDamage)
			end
		end
	elseif mod:isBasegameSegmented(entity) and not isCloned then
		local segments = mod:getBasegameSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.AddExcommunicated(segment, source, duration, damage, true, ignorePartial, overrideDamage)
			end
		end
	end
	
	if (entity:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) or mod:isStatusBlacklisted(entity)) and 
	   not ((entity.Type == EntityType.ENTITY_MASK or entity.Type == EntityType.ENTITY_MASK_OF_INFAMY) and isCloned)
	then
		return
	end
	
	if entity:ToNPC():GetChampionColorIdx() == 6 then
		return
	end
	
	if mod:GetEntityData(entity).eternalFlickerspirited then
		return
	end
	
	if entity.Type == mod.FF.Centipede.ID and entity.Variant == mod.FF.Centipede.Var then
		if entity.SubType > 0 and entity.SubType < 100 then
			return
		end
	end
	
	if isPartialExcommunicationOnAdd(entity, isCloned) then
		if not ignorePartial then mod:doExcommunicatedDamage(entity, damage, EntityRef(source), true, overrideDamage) end
		return
	end

	local data = mod:GetEntityData(entity)
	local isBoss = entity:IsBoss()
	if isBoss and entity:GetBossStatusEffectCooldown() > 0 then
		--do nothing
	elseif not (entity:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) or mod:isStatusBlacklisted(entity)) or 
	       ((entity.Type == EntityType.ENTITY_MASK or entity.Type == EntityType.ENTITY_MASK_OF_INFAMY) and isCloned) 
	then
		if data.FFExcommunicatedDuration == nil or data.FFExcommunicatedDuration > 8 then
			data.FFExcommunicatedDuration = math.max(data.FFExcommunicatedDuration or 0, duration)
			data.FFExcommunicatedMaxDuration = math.max(data.FFExcommunicatedMaxDuration or 0, duration)
			data.FFExcommunicatedSource = EntityRef(source)
			data.FFExcommunicatedTeleportUp = data.FFExcommunicatedTeleportUp or 0
			data.FFExcommunicatedTeleportDown = data.FFExcommunicatedTeleportDown or 0
			data.FFExcommunicatedDamage = math.max(data.FFExcommunicatedDamage or 0, damage)
			data.FFExcommunicatedOverrideDamage = data.FFExcommunicatedOverrideDamage or overrideDamage
			
			local sprite = entity:GetSprite()
			data.FFExcommunicatedOriginalSpriteOffset = data.FFExcommunicatedOriginalSpriteOffset or Vector(sprite.Offset.X, sprite.Offset.Y)
			data.FFExcommunicatedOriginalSpriteScale = data.FFExcommunicatedOriginalSpriteScale or Vector(sprite.Scale.X, sprite.Scale.Y)
			data.FFExcommunicatedOriginalCollisionClass = data.FFExcommunicatedOriginalCollisionClass or entity.EntityCollisionClass
			
			if isBoss then
				entity:SetBossStatusEffectCooldown(FiendFolio.StatusEffectVariables.BossStatusResistanceFrameCount + duration)
			end
			
			mod:TrackEnemyStatus(entity, statusflag)
			
			local ptrhash = GetPtrHash(entity)
			mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
			mod.VasculitisInfo[ptrhash][statusflag] = {Source = data.FFExcommunicatedSource}
		
			Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_STATUS_EFFECT_APPLY, "FFExcommunicated", "FFExcommunicated", entity, EntityRef(source), duration)
		end
	end
end

function FiendFolio.RemoveExcommunicated(entity, isCloned)
	if mod:isSegmented(entity) and not isCloned then
		local segments = mod:getSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.RemoveExcommunicated(segment, true)
			end
		end
	elseif mod:isBasegameSegmented(entity) and not isCloned then
		local segments = mod:getBasegameSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.RemoveExcommunicated(segment, true)
			end
		end
	end

	local data = mod:GetEntityData(entity)
	local sprite = entity:GetSprite()
	
	--[[if data.FFExcommunicatedDuration ~= nil and (data.FFExcommunicatedTeleportDown or 0) < 2 then
		if not (mod:isSegmented(entity) or mod:isBasegameSegmented(entity)) or
		   mod:isMainSegment(entity) or mod:isBasegameMainSegment(entity)
		then
			local enemiesToDamage = Isaac.FindInRadius(entity.Position, 
			                                           math.max(entity.Size + FiendFolio.StatusEffectVariables.ExcommunicatedDamageExtraRadius, 
			                                                    FiendFolio.StatusEffectVariables.ExcommunicatedDamageMinRadius), 
			                                           EntityPartition.ENEMY)
			for _, enemy in ipairs(enemiesToDamage) do
				if enemy:ToNPC() and (enemy.Index ~= entity.Index or enemy.InitSeed ~= entity.InitSeed) then
					if mod:checkIfStatusLogicIsApplied(enemy, true) then
						enemy:TakeDamage(data.FFExcommunicatedDamage * FiendFolio.StatusEffectVariables.ExcommunicatedTelefragDamageMultiplier, 
						                 0, data.FFExcommunicatedSource, 0)
					end
				end
			end
		end
		
		if mod:checkIfStatusLogicIsApplied(entity, true) then
			entity:TakeDamage(data.FFExcommunicatedDamage, 0, data.FFExcommunicatedSource, 0)
			sfx:Play(SoundEffect.SOUND_BLACK_POOF, 0.9, 0, false, 2.0 + math.random() * 0.1)
		end
		
		local poof = Isaac.Spawn(1000, 16, 1, entity.Position, nilvector, nil):ToEffect()
		poof:GetSprite().Color = Color(1.0, 1.0, 1.0, 0.5, 0/255, 0/255, 0/255)
		poof.SpriteScale = Vector(entity.Size / 40 + 0.2, entity.Size / 40 + 0.2)
	end]]--
	
	if data.FFExcommunicatedDuration ~= nil then
		if data.FFExcommunicatedOriginalSpriteOffset ~= nil then
			sprite.Offset = data.FFExcommunicatedOriginalSpriteOffset
		end
		if data.FFExcommunicatedOriginalSpriteScale ~= nil then
			sprite.Scale = data.FFExcommunicatedOriginalSpriteScale
		end
		if data.FFExcommunicatedOriginalCollisionClass ~= nil then
			entity.EntityCollisionClass = data.FFExcommunicatedOriginalCollisionClass
		end
		entity.Visible = true
	end
	
	data.FFExcommunicatedDuration = nil
	data.FFExcommunicatedMaxDuration = nil
	data.FFExcommunicatedTeleportUp = nil
	data.FFExcommunicatedTeleportDown = nil
	data.FFExcommunicatedOriginalSpriteOffset = nil
	data.FFExcommunicatedOriginalSpriteScale = nil
	data.FFExcommunicatedOriginalCollisionClass = nil
	data.FFExcommunicatedSource = nil
	data.FFExcommunicatedDamage = nil
	data.FFExcommunicatedOverrideDamage = nil
	data.FFExcommunicatedInitialPosition = nil
	data.FFExcommunicatedIsShorted = nil
	data.FFExcommunicatedStarted = nil
	mod:UntrackEnemyStatus(entity, statusflag)
	
	if not (entity:IsDead() or entity:HasMortalDamage()) then
		local ptrhash = GetPtrHash(entity)
		mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
		mod.VasculitisInfo[ptrhash][statusflag] = nil
	end
	
	if data.FFExcommunicatedTarget and data.FFExcommunicatedTarget:Exists() then
		data.FFExcommunicatedTarget:Remove()
	end
	data.FFExcommunicatedTarget = nil
end

function mod:isExcommunicated(entity)
	local data = mod:GetEntityData(entity)
	return data.FFExcommunicatedDuration ~= nil and data.FFExcommunicatedDuration >= 0
end

local cachedShouldExcommunicate = nil
local cachedShouldExcommunicateAtStart = nil
local lastFrameOfCachedShouldExcommunicate = -1
function FiendFolio.CheckIfShouldExcommunicate(startOfStatus)
	local frame = game:GetFrameCount()
	if frame == lastFrameOfCachedShouldExcommunicate then
		if startOfStatus then
			return cachedShouldExcommunicateAtStart
		else
			return cachedShouldExcommunicate
		end
	end
	
	local room = game:GetRoom()

	--Cancel out if buttons aren't pressed
	if room:HasTriggerPressurePlates() then
		local size = room:GetGridSize()
		for i=0, size do
			local gridEntity = room:GetGridEntity(i)
			if gridEntity then
				local desc = gridEntity.Desc.Type
				if gridEntity.Desc.Type == GridEntityType.GRID_PRESSURE_PLATE then
					if gridEntity:GetVariant() == 0 then
						if gridEntity.State ~= 3 then
							cachedShouldExcommunicate = true
							lastFrameOfCachedShouldExcommunicate = frame
							return true
						end
					end
				end
			end
		end
	end

	--real check real
	local remainingEntities = 0
	local excommunicatedEntities = 0
	for index,entity in ipairs(Isaac.GetRoomEntities()) do
		if entity.Type == mod.FF.CurseOfTheGateKeySpawner.ID and entity.Variant == mod.FF.CurseOfTheGateKeySpawner.Var and entity:CanShutDoors() then
			goto excommunicatedContinue
		elseif entity:IsActiveEnemy() and entity:CanShutDoors() then
			if not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
				if not mod.waitingEnemiesTriggered then
					for k = 1, #mod.ComeOutTables do
						for i = 1, #mod.ComeOutTables[k] do
							if mod.ComeOutTables[k][i][3] then
								if entity.Type == mod.ComeOutTables[k][i][1] and entity.Variant == mod.ComeOutTables[k][i][2] and entity.SubType == mod.ComeOutTables[k][i][3] then
									goto excommunicatedContinue
								end
							elseif mod.ComeOutTables[k][i][2] then
								if entity.Type == mod.ComeOutTables[k][i][1] and entity.Variant == mod.ComeOutTables[k][i][2] then
									goto excommunicatedContinue
								end
							else
								if entity.Type == mod.ComeOutTables[k][i][1] then
									goto excommunicatedContinue
								end
							end
						end
					end
				end

				if entity:ToNPC():GetChampionColorIdx() == 6 then
					goto excommunicatedContinue
				end
				if mod:GetEntityData(entity).eternalFlickerspirited then
					goto excommunicatedContinue
				end
				if entity.Type == mod.FF.Centipede.ID and entity.Variant == mod.FF.Centipede.Var then
					if entity.SubType > 0 and entity.SubType < 100 then
						goto excommunicatedContinue
					end
				end
				--[[if REVEL.ENT.PENANCE_ORB then
					if entity.Type == REVEL.ENT.PENANCE_ORB.Type and entity.Variant == REVEL.ENT.PENANCE_ORB.Variant then
						badent = true
					end
				end
				if REVEL.ENT.PENANCE_SIN then
					if entity.Type == REVEL.ENT.PENANCE_SIN.Type and entity.Variant == REVEL.ENT.PENANCE_SIN.Variant then
						badent = true
					end
				end]]
				if entity.Type == EntityType.ENTITY_DOGMA then
					if entity.Variant == 0 then
						goto excommunicatedContinue
					elseif entity.Variant == 1 and entity.HitPoints <= 0 then
						goto excommunicatedContinue
					end
				end
				if mod:isBerserk(entity) and entity.HitPoints <= 0 and entity.MaxHitPoints ~= 0 then
					goto excommunicatedContinue
				end
				if (mod:isSegmented(entity) and not mod:isMainSegment(entity)) or 
				   (mod:isBasegameSegmented(entity) and not mod:isBasegameMainSegment(entity))
				then
					goto excommunicatedContinue
				end
				if mod:isExcommunicated(entity) then
					excommunicatedEntities = excommunicatedEntities + 1
					goto excommunicatedContinue
				end

				remainingEntities = remainingEntities + 1
			end
		end

		::excommunicatedContinue::
	end

	cachedShouldExcommunicate = remainingEntities > 0
	cachedShouldExcommunicateAtStart = remainingEntities > 1 or excommunicatedEntities > 0
	lastFrameOfCachedShouldExcommunicate = frame
	
	if startOfStatus then
		return cachedShouldExcommunicateAtStart
	else
		return cachedShouldExcommunicate
	end
end

function FiendFolio.FlagExcommunicate(entity, duration, damage)
	TearFlagsLib.AddTearFlags(entity, tearflag)
	
	local params = TearFlagsLib.GetTearFlagParams(entity, tearflag)
	TearFlagsLib.SetTearFlagParams(entity, tearflag, {Duration = math.max(params.Duration or 0, duration),
	                                                  Damage = math.max(params.Damage or 0, damage)})
end

function mod:applyExcommunicatedFlag(entity, player, source)
	local data = mod:GetEntityData(source)
	local params = TearFlagsLib.GetTearFlagParams(source, tearflag)
	FiendFolio.AddExcommunicated(entity, player, params.Duration, params.Damage)
end
mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, mod.applyExcommunicatedFlag, tearflag)

function FiendFolio.HasExcommunicatedFlag(entity)
	return TearFlagsLib.HasTearFlags(entity, tearflag)
end

function mod.handleExcommunicateD3(entity)
	local player = TearFlagsLib.GetTearPlayer(entity)
	local params = TearFlagsLib.GetTearFlagParams(entity, tearflag)
	TearFlagsLib.SetTearFlagParams(entity, tearflag, {Duration = math.max(params.Duration or 0, 120),
	                                                  Damage = math.max(params.Damage or 0, (player and player.Damage) or 3.5)})
end

function mod:excommunicatedOnVasculitis(tear, npc)
	local ptrhash = GetPtrHash(npc)
	mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
	
	local vasculitisInfo = mod.VasculitisInfo[ptrhash][statusflag]
	if vasculitisInfo then
		local source = vasculitisInfo.Source
		local player = source and source.Entity and source.Entity:ToPlayer()
		local secondHandMultiplier = (player and (player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1)) or 1
		FiendFolio.FlagExcommunicate(tear, 120 * secondHandMultiplier, player.Damage)
	end
end

function mod:excommunicatedOnUpdate(npc, data, sprite, clearingStatus)
	if data.FFMartyrOnDeathDuration == nil or data.FFExcommunicatedStarted then
		if data.FFExcommunicatedDuration ~= nil and data.FFExcommunicatedDuration > 0 and not clearingStatus then
			mod:handleExcommunicated(npc, data, sprite)
		else
			data.FFExcommunicatedDuration = nil
			data.FFExcommunicatedMaxDuration = nil
			data.FFExcommunicatedTeleportUp = nil
			data.FFExcommunicatedTeleportDown = nil
			data.FFExcommunicatedOriginalSpriteOffset = nil
			data.FFExcommunicatedOriginalSpriteScale = nil
			data.FFExcommunicatedOriginalCollisionClass = nil
			data.FFExcommunicatedSource = nil
			data.FFExcommunicatedDamage = nil
			data.FFExcommunicatedOverrideDamage = nil
			data.FFExcommunicatedInitialPosition = nil
			data.FFExcommunicatedIsShorted = nil
			data.FFExcommunicatedStarted = nil
			mod:UntrackEnemyStatus(npc, statusflag)
			
			if not (npc:IsDead() or npc:HasMortalDamage()) then
				local ptrhash = GetPtrHash(npc)
				mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
				mod.VasculitisInfo[ptrhash][statusflag] = nil
			end
			
			if data.FFExcommunicatedTarget and data.FFExcommunicatedTarget:Exists() then
				data.FFExcommunicatedTarget:Remove()
			end
			data.FFExcommunicatedTarget = nil
		end
	end
end

function mod:copyExcommunicated(copy, copyData, source, sourceData)
	copyData.FFExcommunicatedDuration = sourceData.FFExcommunicatedDuration
	copyData.FFExcommunicatedMaxDuration = sourceData.FFExcommunicatedMaxDuration
	copyData.FFExcommunicatedSource = sourceData.FFExcommunicatedSource
	copyData.FFExcommunicatedTeleportUp = sourceData.FFExcommunicatedTeleportUp
	copyData.FFExcommunicatedTeleportDown = sourceData.FFExcommunicatedTeleportDown
	copyData.FFExcommunicatedDamage = sourceData.FFExcommunicatedDamage
	copyData.FFExcommunicatedOverrideDamage = sourceData.FFExcommunicatedOverrideDamage
	copyData.FFExcommunicatedStarted = sourceData.FFExcommunicatedStarted
	
	mod:TrackEnemyStatus(copy, statusflag)
	
	local copyPtrhash = GetPtrHash(copy)
	local sourcePtrhash = GetPtrHash(source)
	mod.VasculitisInfo[copyPtrhash] = mod.VasculitisInfo[copyPtrhash] or {}
	mod.VasculitisInfo[sourcePtrhash] = mod.VasculitisInfo[sourcePtrhash] or {}
	if mod.VasculitisInfo[sourcePtrhash][statusflag] then
		mod.VasculitisInfo[copyPtrhash][statusflag] = {Source = mod.VasculitisInfo[sourcePtrhash][statusflag].Source or copyData.FFExcommunicatedSource}
	end
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, target)
	target.Velocity = nilvector
	
	if not target.Parent then
		target:Remove()
	elseif not mod:isExcommunicated(target.Parent) then
		target:Remove()
	end
end, 1756)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, beam)
	beam.Velocity = nilvector
	
	local sprite = beam:GetSprite()
	
	if sprite:IsEventTriggered("Hit") then
		local crater = Isaac.Spawn(1000, 18, 1, beam.Position, nilvector, nil):ToEffect()
		local craterSprite = crater:GetSprite()
		crater:Update()
		
		local frame = math.random(0, 7)
		craterSprite:SetFrame("IdleSmall", frame)
		craterSprite:Stop()
		
		crater.Timeout = 150
		
		sfx:Play(SoundEffect.SOUND_LIGHTBOLT, 1.0, 0, false, 1.0)
	end
	
	if sprite:IsFinished("Spotlight") then
		beam:Remove()
	end
end, 1757)
