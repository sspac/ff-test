-- Berserk --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local statusflag = mod:RegisterEnemyStatusEffect("BERSERK", 1010, "berserkOnUpdate", {HasIcon = true, Vasculitis = "berserkOnVasculitis"})
local tearflag = TearFlagsLib.RegisterTearFlag("BERSERK")
local statusColorPriority = 126

mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, function(_, proj)
	if proj.FrameCount <= 1 and proj.SpawnerEntity ~= nil then
		local spawnerData = mod:GetEntityData(proj.SpawnerEntity)
		if spawnerData.FFBerserkDuration ~= nil and spawnerData.FFBerserkDuration >= 0 then
			proj.ProjectileFlags = proj.ProjectileFlags | ProjectileFlags.HIT_ENEMIES
			mod:GetEntityData(proj).FFBerserkProjectile = true
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, function(_, proj, entity, mysteryBoolean)
	local data = mod:GetEntityData(proj)
	local spawnerEntity = proj.SpawnerEntity

	if data.FFBerserkProjectile and spawnerEntity then
		if spawnerEntity.Index == entity.Index and spawnerEntity.InitSeed == entity.InitSeed then
			return true
		elseif mod:isSegmented(spawnerEntity) and mod:isInSegmentsOf(entity, spawnerEntity) then
			return true
		elseif mod:isBasegameSegmented(spawnerEntity) and mod:isInBasegameSegmentsOf(entity, spawnerEntity) then
			return true
		end
	end

end)

mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, function(_, npc, entity, mysteryBoolean)
	if mod:isBerserk(npc) and entity:ToNPC() then
		if mod:isSegmented(npc) and mod:isInSegmentsOf(entity, npc) then
			return true
		elseif mod:isBasegameSegmented(npc) and mod:isInBasegameSegmentsOf(entity, npc) then
			return true
		elseif mod:isCharm(npc) or mod:isCharm(entity) or mod:isBaited(entity) then
			-- do nothing
		elseif npc.Target and npc.Target.Index == entity.Index and npc.Target.InitSeed == entity.InitSeed then
			-- do nothing
		else
			entity:TakeDamage((math.log((npc.MaxHitPoints / 100) + 1.1) / math.log(10)) * 75.9853, 0, EntityRef(npc), 0) -- Matches npc.Target damage
		end
	end
end)

local onlyDeadBerserkRemaining = nil
function mod:checkIfOnlyDeadBerserkRemaining()
	if onlyDeadBerserkRemaining ~= nil then
		return onlyDeadBerserkRemaining
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
							onlyDeadBerserkRemaining = false
							return false
						end
					end
				end
			end
		end
	end

	--real check real
	for index,entity in ipairs(Isaac.GetRoomEntities()) do
		if entity.Type == mod.FF.CurseOfTheGateKeySpawner.ID and entity.Variant == mod.FF.CurseOfTheGateKeySpawner.Var and entity:CanShutDoors() then
			return false
		elseif entity:IsActiveEnemy() and entity:CanShutDoors() then
			if not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
				if not mod.waitingEnemiesTriggered then
					for k = 1, #mod.ComeOutTables do
						for i = 1, #mod.ComeOutTables[k] do
							if mod.ComeOutTables[k][i][3] then
								if entity.Type == mod.ComeOutTables[k][i][1] and entity.Variant == mod.ComeOutTables[k][i][2] and entity.SubType == mod.ComeOutTables[k][i][3] then
									goto berserkcontinue
								end
							elseif mod.ComeOutTables[k][i][2] then
								if entity.Type == mod.ComeOutTables[k][i][1] and entity.Variant == mod.ComeOutTables[k][i][2] then
									goto berserkcontinue
								end
							else
								if entity.Type == mod.ComeOutTables[k][i][1] then
									goto berserkcontinue
								end
							end
						end
					end
				end

				if entity:ToNPC():GetChampionColorIdx() == 6 then
					goto berserkcontinue
				end
				if mod:GetEntityData(entity).eternalFlickerspirited then
					goto berserkcontinue
				end
				if entity.Type == mod.FF.Centipede.ID and entity.Variant == mod.FF.Centipede.Var then
					if entity.SubType > 0 and entity.SubType < 100 then
						goto berserkcontinue
					end
				end
				if entity.Type == mod.FF.Alfil.ID and entity.Variant == mod.FF.Alfil.Var then
					goto berserkcontinue
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
						goto berserkcontinue
					elseif entity.Variant == 1 and entity.HitPoints <= 0 then
						goto berserkcontinue
					end
				end
				if mod:isBerserk(entity) and entity.HitPoints <= 0 and entity.MaxHitPoints ~= 0 then
					goto berserkcontinue
				end

				onlyDeadBerserkRemaining = false
				return false
			end
		end

		::berserkcontinue::
	end


	onlyDeadBerserkRemaining = true
	return true
end

function mod:resetOnlyDeadBerserkRemaining()
	onlyDeadBerserkRemaining = nil
end

function mod:handleBerserk(entity, data, sprite)
	data.FFBerserkDuration = data.FFBerserkDuration - 1

	if data.FFBerserkPlayedIntro == nil and data.FFBerserkGunslinger == nil then
		if not data.FFBerserkWarHorned then
			sfx:Play(SoundEffect.SOUND_BERSERK_START, 0.5, 0, false, 1.0)
		end
		data.FFBerserkPlayedIntro = true
	end

	if data.FFBerserkDuration >= 0 then
		local color = Color.Lerp(FiendFolio.StatusEffectColors.Berserk, FiendFolio.StatusEffectColors.BerserkFlash, math.abs(math.sin(math.pi / 4 * game:GetFrameCount())))
		entity:SetColor(color, 1, statusColorPriority, false, false)
	end

	if not data.FFBerserkGunslinger then
		if entity.Target or (data.FFBerserkPreviousTarget and data.FFBerserkPreviousTarget:Exists() and not data.FFBerserkPreviousTarget:ToNPC()) then
			local target = entity.Target or data.FFBerserkPreviousTarget
			data.FFBerserkTicksWithCurrentTarget = (data.FFBerserkTicksWithCurrentTarget or 0) + 1
			if data.FFBerserkTicksWithCurrentTarget > FiendFolio.StatusEffectVariables.BerserkTargetTime or mod:isStatusCorpse(target) or
			(mod:isBerserk(target) and target.HitPoints <= 0 and target.MaxHitPoints ~= 0) then
				data.FFBerserkIgnoredTarget = target
				data.FFBerserkPreviousTarget = nil
				entity.Target = nil
			end
		else
			data.FFBerserkTicksWithCurrentTarget = nil
		end
	end
	
	local ptrhash = GetPtrHash(entity)
	mod.BerserkEnemiesToRetarget[ptrhash] = true
	if not mod.LoadedBerserkTargetCallback then
		mod:EnableManualCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.handleBerserkTargeting)
		mod.LoadedBerserkTargetCallback = true
	end
	
	if entity:IsBoss() and (entity.HitPoints <= 0 and entity.MaxHitPoints ~= 0) then
		data.FFBerserkBossTimeout = (data.FFBerserkBossTimeout or 0) + 1
	end
	
	if not sfx:IsPlaying(mod.Sounds.CustomBerserkTick) and (data.FFBerserkBossTimeout == 1 or data.FFBerserkDuration == 60) then
		sfx:Play(mod.Sounds.CustomBerserkTick, 0.5, 0, false, 1.0)
	end

	if data.FFBerserkDuration == 0 or (entity.HitPoints <= 0 and entity.MaxHitPoints ~= 0 and (mod:checkIfOnlyDeadBerserkRemaining() or (data.FFBerserkBossTimeout or 0) >= FiendFolio.StatusEffectVariables.BerserkBossTimeout)) then
		entity.Target = nil
		data.FFBerserkDuration = nil
		data.FFBerserkPlayedIntro = nil
		data.FFBerserkPreviousTarget = nil
		data.FFBerserkIgnoredTarget = nil
		data.FFBerserkBossTimeout = nil
		mod:UntrackEnemyStatus(entity, statusflag)
		
		if not (entity:IsDead() or entity:HasMortalDamage()) then
			local ptrhash = GetPtrHash(entity)
			mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
			mod.VasculitisInfo[ptrhash][statusflag] = nil
		end

		if not data.FFBerserkGunslinger then
			sfx:Play(SoundEffect.SOUND_BERSERK_END, 0.5, 0, false, 1.0)
		end
		--[[if not sfx:IsPlaying(SoundEffect.SOUND_BERSERK_TICK) then
			sfx:Play(SoundEffect.SOUND_BERSERK_TICK, 0.7, 0, false, 1.0)
		end]]--

		if entity.HitPoints <= 0.0 and entity.MaxHitPoints ~= 0.0 and not mod:isStatusCorpse(entity) then
			local addedExtraGoreFlag = false
			if not entity:HasEntityFlags(EntityFlag.FLAG_EXTRA_GORE) then
				entity:AddEntityFlags(EntityFlag.FLAG_EXTRA_GORE)
				addedExtraGoreFlag = true
			end

			data.FFBerserkKilled = true
			if entity:IsBoss() then
				if not mod.StatusSentKillingBlow[ptrhash] then
					entity:TakeDamage(0.0001, 0, data.FFSewnSource, 0)
				end
				mod.StatusSentKillingBlow[ptrhash] = EntityPtr(entity)
				data.FFBerserkKickOutLilMinx = true
			else
				entity:Kill()
			end

			if addedExtraGoreFlag then
				entity:ClearEntityFlags(EntityFlag.FLAG_EXTRA_GORE)
			end

			for i = 1, 11 - math.random(5) do
				local smoke = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, 0, entity.Position, Vector.FromAngle(math.random() * 360) * math.random() * 10, nil):ToEffect()
				smoke.Color = Color(158/255, 11/255, 15/255, 67/255, 0, 0, 0)
				smoke:SetTimeout(10 + math.random(15))
				smoke:Update()
			end
		end
		
		return
	end
	
	mod.HasAnimAndMoveMulti[ptrhash] = mod.HasAnimAndMoveMulti[ptrhash] or {}
	mod.HasAnimAndMoveMulti[ptrhash].NPC = entity
	mod.HasAnimAndMoveMulti[ptrhash].Mult = (mod.HasAnimAndMoveMulti[ptrhash].Mult or 1) * FiendFolio.StatusEffectVariables.BerserkAnimAndMoveSpeedMultiplier
end

function mod:isBerserkBlacklisted(entity)
	return mod.BerserkBlacklist[entity.Type] or
	       mod.BerserkBlacklist[entity.Type .. " " .. entity.Variant] or
	       mod.BerserkBlacklist[entity.Type .. " " .. entity.Variant .. " " .. entity.SubType]
end

function mod:getBerserkTarget(npc, data, gunslingerRage)
	local target
	gunslingerRage = gunslingerRage or data.FFBerserkGunslinger

	if data.FFBerserkPreviousTarget and (not gunslingerRage or data.FFBerserkPreviousTarget:ToNPC()) then
		target = data.FFBerserkPreviousTarget
	end

	if target == nil or not target:Exists() or target:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) then
		local ignoredTarget = data.FFBerserkIgnoredTarget
		local npcIsCharmed = npc:HasEntityFlags(EntityFlag.FLAG_CHARM)
		local npcIsFriendly = npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)

		local closestDist = 999999
		local closestEnt = nil
		local closestEntHasBait = false
		local closestEntShouldBeIgnored = false

		for _, entity in ipairs(Isaac.FindInRadius(game:GetRoom():GetCenterPos(), 1000, EntityPartition.ENEMY)) do
			local entityIsBaited = entity:HasEntityFlags(EntityFlag.FLAG_BAITED)
			local entityIsFriendly = entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)
			local entityIsIgnored = ignoredTarget ~= nil and entity.Index == ignoredTarget.Index and entity.InitSeed == ignoredTarget.InitSeed
			local entityIsSelf = entity.Index == npc.Index and entity.InitSeed == npc.InitSeed

			if entityIsSelf then
				-- do nothing
			elseif entity:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) then
				-- do nothing
			elseif mod:isSegmented(entity) and mod:isInSegmentsOf(entity, npc) then
				-- do nothing
			elseif mod:isBasegameSegmented(entity) and mod:isInBasegameSegmentsOf(entity, npc) then
				-- do nothing
			elseif npcIsFriendly and entityIsFriendly then
				-- do nothing
			elseif mod:isStatusCorpse(entity) then
				-- do nothing
			elseif entityIsBaited then
				local dist = (entity.Position - npc.Position):Length()
				if dist < closestDist then
					closestEnt = entity
					closestDist = dist
					closestEntHasBait = entityHasBait
					closestEntShouldBeIgnored = false
				end
			elseif closestEntHasBait then
				-- do nothing
			elseif entityIsIgnored and not closestEntShouldBeIgnored then
				-- do nothing
			elseif mod:isBerserk(entity) and entity.HitPoints <= 0 and entity.MaxHitPoints ~= 0 then
				-- do nothing
			elseif gunslingerRage and (mod:GetEntityData(entity).GunslingerData or (entity.SpawnerEntity and mod:GetEntityData(entity.SpawnerEntity).GunslingerData)) then
				-- do nothing
			elseif entity:IsVulnerableEnemy() then
				local dist = (entity.Position - npc.Position):Length()
				if dist < closestDist then
					closestEnt = entity
					closestDist = dist
					closestEntHasBait = entityHasBait
					closestEntShouldBeIgnored = entityIsIgnored
				end
			end
		end

		if not gunslingerRage or not closestEnt then
			for i = 1, game:GetNumPlayers() do
				local player = Isaac.GetPlayer(i - 1)
				local playerIsIgnored = ignoredTarget ~= nil and ignoredTarget.Type == EntityType.ENTITY_PLAYER

				if closestEntHasBait then
					-- do nothing
				elseif playerIsIgnored and closestEnt then
					-- do nothing
				elseif (npcIsCharmed or npcIsFriendly) and closestEnt then
					-- do nothing
				else
					local dist = (player.Position - npc.Position):Length()
					if dist < closestDist then
						closestEnt = player
						closestDist = dist
						closestEntHasBait = false
						closestEntShouldBeIgnored = playerIsIgnored
					end
				end
			end
		end

		data.FFBerserkPreviousTarget = closestEnt
		target = closestEnt
		if ignoredTarget ~= nil and (ignoredTarget.Index ~= target.Index or ignoredTarget.InitSeed ~= target.InitSeed) then
			data.FFBerserkTicksWithCurrentTarget = nil
		end
	end
	
	return target
end

function FiendFolio.AddBerserk(entity, source, duration, isCloned, isMinx, gunslingerRage)
	if not (entity and entity:ToNPC()) then
		return
	end
	
	if (entity.Type == EntityType.ENTITY_MASK or (entity.Type == EntityType.ENTITY_MASK_OF_INFAMY and entity.Parent)) and not isCloned then
		return
	end
	
	if Isaac.RunCallbackWithParam(ModCallbacks.MC_PRE_STATUS_EFFECT_APPLY, "FFBerserk", "FFBerserk", entity, EntityRef(source), duration) == false then
		return
	end
	
	if mod:isSegmented(entity) and not isCloned then
		local segments = mod:getSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.AddBerserk(segment, source, duration, true, isMinx, gunslingerRage)
			end
		end
	elseif mod:isBasegameSegmented(entity) and not isCloned then
		local segments = mod:getBasegameSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.AddBerserk(segment, source, duration, true, isMinx, gunslingerRage)
			end
		end
	end

	local data = mod:GetEntityData(entity)
	local isBoss = entity:IsBoss()
	if not isMinx and not gunslingerRage and isBoss and entity:GetBossStatusEffectCooldown() > 0 then
		--do nothing
	elseif not (entity:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) or mod:isStatusBlacklisted(entity) or mod:isBerserkBlacklisted(entity)) or 
	       ((entity.Type == EntityType.ENTITY_MASK or entity.Type == EntityType.ENTITY_MASK_OF_INFAMY) and isCloned) 
	then
		if isMinx and entity:ToNPC():IsBoss() then
			local playedIntro = data.FFBerserkPlayedIntro
			mod:removeStatusEffects(entity, false, true)
			data.FFBerserkPlayedIntro = playedIntro
		end
		
		data.FFBerserkDuration = math.max(duration, data.FFBerserkDuration or 0)
		data.FFBerserkSource = EntityRef(source)
		data.FFBerserkGunslinger = gunslingerRage
		
		if not gunslingerRage and isBoss then
		
			entity:SetBossStatusEffectCooldown(FiendFolio.StatusEffectVariables.BossStatusResistanceFrameCount)
		end
		
		mod:TrackEnemyStatus(entity, statusflag)
		
		local ptrhash = GetPtrHash(entity)
		mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
		mod.VasculitisInfo[ptrhash][statusflag] = {Source = data.FFBerserkSource}
		
		Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_STATUS_EFFECT_APPLY, "FFBerserk", "FFBerserk", entity, EntityRef(source), duration)
	end
end

function FiendFolio.RemoveBerserk(entity, isCloned)
	if mod:isSegmented(entity) and not isCloned then
		local segments = mod:getSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.RemoveBerserk(segment, true)
			end
		end
	elseif mod:isBasegameSegmented(entity) and not isCloned then
		local segments = mod:getBasegameSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.RemoveBerserk(segment, true)
			end
		end
	end

	local data = mod:GetEntityData(entity)

	if data.FFBerserkDuration ~= nil then
		entity.Target = nil
		entity:GetSprite().PlaybackSpeed = 1.0

		if not data.FFBerserkGunslinger then
			sfx:Play(SoundEffect.SOUND_BERSERK_END, 0.5, 0, false, 1.0)
		end

		if entity.HitPoints <= 0.0 and entity.MaxHitPoints ~= 0.0 and not mod:isStatusCorpse(entity) then
			local addedExtraGoreFlag = false
			if not entity:HasEntityFlags(EntityFlag.FLAG_EXTRA_GORE) then
				entity:AddEntityFlags(EntityFlag.FLAG_EXTRA_GORE)
				addedExtraGoreFlag = true
			end

			entity:Kill()

			if addedExtraGoreFlag then
				entity:ClearEntityFlags(EntityFlag.FLAG_EXTRA_GORE)
			end

			for i = 1, 11 - math.random(5) do
				local smoke = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, 0, entity.Position, Vector.FromAngle(math.random() * 360) * math.random() * 10, nil):ToEffect()
				smoke.Color = Color(158/255, 11/255, 15/255, 67/255, 0, 0, 0)
				smoke:SetTimeout(10 + math.random(15))
				smoke:Update()
			end
		end
	end

	data.FFBerserkDuration = nil
	data.FFBerserkPlayedIntro = nil
	data.FFBerserkPreviousTarget = nil
	data.FFBerserkIgnoredTarget = nil
	data.FFBerserkBossTimeout = nil
	data.FFBerserkGunslinger = nil
	mod:UntrackEnemyStatus(entity, statusflag)
	
	if not (entity:IsDead() or entity:HasMortalDamage()) then
		local ptrhash = GetPtrHash(entity)
		mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
		mod.VasculitisInfo[ptrhash][statusflag] = nil
	end
end

function mod:isBerserk(entity)
	local data = mod:GetEntityData(entity)
	return data.FFBerserkDuration ~= nil and data.FFBerserkDuration >= 0
end

function mod:berserkOnDamage(entity, amount, flags, source, cooldown)
	if flags & DamageFlag.DAMAGE_CLONES ~= 0 or not entity:ToNPC() then return end
	
	local data = mod:GetEntityData(entity)
	if data.FFBerserkDuration ~= nil and data.FFBerserkDuration > 0 then
		local allowDamageEffects = not mod:isBasegameSegmented(entity) or mod:isBasegameMainSegment(entity) or mod:isBasegameReducedSyncSegment(entity)
		if allowDamageEffects then
			return {Damage = amount * FiendFolio.StatusEffectVariables.BerserkDamageReceivedMultiplier}
		end
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, -100, mod.berserkOnDamage)

function mod:damagedByBerserkOld(ent, damage, flags, source, countdown, data)
	if source ~= nil and source.Entity ~= nil and data.FFBerserkIgnoreDamageCallback ~= true and flags & DamageFlag.DAMAGE_CLONES == 0 then
		local sourceData = mod:GetEntityData(source.Entity)
		if (sourceData.FFBerserkDuration ~= nil and sourceData.FFBerserkDuration > 0) or sourceData.FFBerserkProjectile then
			data.FFBerserkIgnoreDamageCallback = true
			if ent.Type == EntityType.ENTITY_PLAYER then
				ent:TakeDamage(damage + FiendFolio.StatusEffectVariables.BerserkDamageAgainstPlayer, flags, source, countdown)
			else
				ent:TakeDamage(damage * FiendFolio.StatusEffectVariables.BerserkDamageGivenMultiplier + FiendFolio.StatusEffectVariables.BerserkDamageGivenFlat, flags, source, countdown)
			end
			data.FFBerserkIgnoreDamageCallback = false
			return false
		end
	end
end

function mod:damagedByBerserk(ent, damage, flags, source, countdown, data)
	local returndata = {}
	if source ~= nil and source.Entity ~= nil and flags & DamageFlag.DAMAGE_CLONES == 0 then
		local sourceData = mod:GetEntityData(source.Entity)
		if (sourceData.FFBerserkDuration ~= nil and sourceData.FFBerserkDuration > 0 and not sourceData.FFBerserkWarHorned) or sourceData.FFBerserkProjectile then
			if ent.Type == EntityType.ENTITY_PLAYER then
				returndata.newDamage = damage + FiendFolio.StatusEffectVariables.BerserkDamageAgainstPlayer
				returndata.sendNewDamage = true
			else
				if not mod:isBasegameSegmented(ent) or mod:isBasegameReducedSyncSegment(ent) or not mod:isInBasegameSegmentsOf(ent, source.Entity) then
					returndata.newDamage = damage * FiendFolio.StatusEffectVariables.BerserkDamageGivenMultiplier + FiendFolio.StatusEffectVariables.BerserkDamageGivenFlat
					returndata.sendNewDamage = true
				end
			end
		end
	end
	
	return returndata
end

function mod:PreventRemovingBerserkFlag(entity, player, flag)
	local params = TearFlagsLib.GetTearFlagParams(entity, flag)
	if params.NoRemove then
		return true
	end
end
mod:AddCallback(TearFlagsLib.Callback.PRE_REMOVE_TEARFLAG, mod.PreventRemovingBerserkFlag, tearflag)

function FiendFolio.FlagBerserk(entity, duration)
	TearFlagsLib.AddTearFlags(entity, tearflag)
	
	local params = TearFlagsLib.GetTearFlagParams(entity, tearflag)
	TearFlagsLib.SetTearFlagParams(entity, tearflag, {Duration = math.max(params.Duration or 0, duration)})
end

function mod:applyBerserkFlagAndOnCheckKill(entity, amount, flags, source, cooldown, extraSource)
	if flags & DamageFlag.DAMAGE_CLONES ~= 0 or not entity:ToNPC() then return end
	
	local origSource = source
	local source = extraSource or source
	if source.Type == EntityType.ENTITY_KNIFE then
		source = EntityRef(source.Entity:ToKnife():GetHitboxParentKnife() or source.Entity)
	end
	
	if source.Type == 0 and flags & DamageFlag.DAMAGE_LASER > 0 then
		-- this is technically not accurate for ocular rift since it rolls every hit instead of every frame but idc
		-- this functions nicer for can of beans purposes
		-- i'll leave tearflagslib generally as it is but for weird stuff like this imma do this instead
		local hitter = mod.CheckingForDmg[#mod.CheckingForDmg]
		if hitter and TearFlagsLib.IsEntityOcularRift(hitter) then
			local data = mod:GetEntityData(hitter)
			local frame = game:GetFrameCount()
			if data.ClearedBerserk ~= frame then
				TearFlagsLib.SetTearFlagParams(hitter, tearflag, {NoRemove = false})
				TearFlagsLib.ClearTearFlags(hitter, tearflag)
				data.ClearedBerserk = frame
			end
			
			mod:lunaticEyeFlagOnDamage(hitter)
			
			if TearFlagsLib.HasTearFlags(hitter, tearflag) then
				local params = TearFlagsLib.GetTearFlagParams(hitter, tearflag)
				FiendFolio.AddBerserk(entity, TearFlagsLib.GetTearPlayer(hitter), params.Duration)
				TearFlagsLib.SetTearFlagParams(hitter, tearflag, {NoRemove = true})
			end
		end
	elseif source.Entity and TearFlagsLib.IsEntityOcularRift(source.Entity) then
		-- same as above, just more stuff to make can of beans play nicer with this
		local hitter = source.Entity
		
		local data = mod:GetEntityData(hitter)
		local frame = game:GetFrameCount()
		if data.ClearedBerserk ~= frame then
			TearFlagsLib.SetTearFlagParams(hitter, tearflag, {NoRemove = false})
			TearFlagsLib.ClearTearFlags(hitter, tearflag)
			data.ClearedBerserk = frame
		end
		
		mod:lunaticEyeFlagOnDamage(hitter)
		
		if TearFlagsLib.HasTearFlags(hitter, tearflag) then
			local params = TearFlagsLib.GetTearFlagParams(hitter, tearflag)
			FiendFolio.AddBerserk(entity, TearFlagsLib.GetTearPlayer(hitter), params.Duration)
			TearFlagsLib.SetTearFlagParams(hitter, tearflag, {NoRemove = true})
		end
	elseif source.Type == EntityType.ENTITY_EFFECT and source.Variant == EffectVariant.DARK_SNARE and source.Entity and source.Entity.SpawnerEntity then
		local snare = source.Entity
		
		local data = mod:GetEntityData(snare)
		local frame = game:GetFrameCount()
		if data.ClearedBerserk ~= frame then
			TearFlagsLib.SetTearFlagParams(snare, tearflag, {NoRemove = false})
			TearFlagsLib.ClearTearFlags(snare, tearflag)
			data.ClearedBerserk = frame
		end
		
		mod:lunaticEyeFlagOnDamage(snare)
		
		if TearFlagsLib.HasTearFlags(snare, tearflag) then
			local params = TearFlagsLib.GetTearFlagParams(snare, tearflag)
			FiendFolio.AddBerserk(entity, TearFlagsLib.GetTearPlayer(snare), params.Duration)
			TearFlagsLib.SetTearFlagParams(snare, tearflag, {NoRemove = true})
		end
	elseif source.Type == 1 and source.Entity and mod:GetEntityData(source.Entity).MaliceDashing then
		local pdata = mod:GetEntityData(source.Entity)
		if pdata.MaliceProjectile and pdata.MaliceProjectile:Exists() and TearFlagsLib.HasTearFlags(pdata.MaliceProjectile, tearflag) then
			local params = TearFlagsLib.GetTearFlagParams(pdata.MaliceProjectile, tearflag)
			FiendFolio.AddBerserk(entity, source.Entity, params.Duration)
		end
	elseif source.Type == 1 and TearFlagsLib.hemoptysisDummy then
		if TearFlagsLib.HasTearFlags(TearFlagsLib.hemoptysisDummy, tearflag) then
			local params = TearFlagsLib.GetTearFlagParams(TearFlagsLib.hemoptysisDummy, tearflag)
			FiendFolio.AddBerserk(entity, source.Entity, params.Duration)
		end
	elseif source.Entity and TearFlagsLib.HasTearFlags(source.Entity, tearflag) then
		local params = TearFlagsLib.GetTearFlagParams(source.Entity, tearflag)
		FiendFolio.AddBerserk(entity, TearFlagsLib.GetTearPlayer(source.Entity), params.Duration)
	end
	
	local data = mod:GetEntityData(entity)
	if data.FFBerserkDuration ~= nil and data.FFBerserkDuration > 0 then
		return {DamageFlags = flags | DamageFlag.DAMAGE_NOKILL}
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, -50, mod.applyBerserkFlagAndOnCheckKill)

function mod.handleBerserkD3(entity)
	local params = TearFlagsLib.GetTearFlagParams(entity, tearflag)
	TearFlagsLib.SetTearFlagParams(entity, tearflag, {Duration = math.max(params.Duration or 0, 180)})
end

function mod:berserkOnVasculitis(tear, npc)
	local ptrhash = GetPtrHash(npc)
	mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
	
	local vasculitisInfo = mod.VasculitisInfo[ptrhash][statusflag]
	if vasculitisInfo then
		local source = vasculitisInfo.Source
		local player = source and source.Entity and source.Entity:ToPlayer()
		local secondHandMultiplier = (player and (player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1)) or 1
		FiendFolio.FlagBerserk(tear, 180 * secondHandMultiplier)
	end
end

function mod:berserkOnUpdate(npc, data, sprite, clearingStatus)
	data.FFBerserkKilled = nil
	if data.FFBerserkDuration ~= nil and data.FFBerserkDuration > 0 and not clearingStatus then
		mod:handleBerserk(npc, data, sprite)
		data.hasFFStatusIcon = data.FFBerserkDuration ~= nil
	else
		data.FFBerserkDuration = nil
		data.FFBerserkPlayedIntro = nil
		data.FFBerserkPreviousTarget = nil
		data.FFBerserkIgnoredTarget = nil
		data.FFBerserkKickOutLilMinx = nil
		data.FFBerserkBossTimeout = nil
		data.FFBerserkGunslinger = nil
		mod:UntrackEnemyStatus(npc, statusflag)
		
		if not (npc:IsDead() or npc:HasMortalDamage()) then
			local ptrhash = GetPtrHash(npc)
			mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
			mod.VasculitisInfo[ptrhash][statusflag] = nil
		end
	end
end

function mod:copyBerserk(copy, copyData, source, sourceData)
	copyData.FFBerserkDuration = sourceData.FFBerserkDuration
	copyData.FFBerserkSource = sourceData.FFBerserkSource
	copyData.FFBerserkPlayedIntro = sourceData.FFBerserkPlayedIntro
	copyData.FFBerserkPreviousTarget = sourceData.FFBerserkPreviousTarget
	copyData.FFBerserkIgnoredTarget = sourceData.FFBerserkIgnoredTarget
	copyData.FFBerserkBossTimeout = sourceData.FFBerserkBossTimeout
	copyData.FFBerserkGunslinger = sourceData.FFBerserkGunslinger
	
	mod:TrackEnemyStatus(copy, statusflag)
	
	local copyPtrhash = GetPtrHash(copy)
	local sourcePtrhash = GetPtrHash(source)
	mod.VasculitisInfo[copyPtrhash] = mod.VasculitisInfo[copyPtrhash] or {}
	mod.VasculitisInfo[sourcePtrhash] = mod.VasculitisInfo[sourcePtrhash] or {}
	if mod.VasculitisInfo[sourcePtrhash][statusflag] then
		mod.VasculitisInfo[copyPtrhash][statusflag] = {Source = mod.VasculitisInfo[sourcePtrhash][statusflag].Source or copyData.FFBerserkSource}
	end
end
