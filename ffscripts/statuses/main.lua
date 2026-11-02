local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local statusColorPriority = 1

mod.EnemyStatusEffects = {}
mod.CurrentlyRunningStatuses = mod.CurrentlyRunningStatuses or {}
mod.StatusesOnEnemy = mod.StatusesOnEnemy or {}
mod.EnemiesWithStatus = mod.EnemiesWithStatus or {}
function mod:RegisterEnemyStatusEffect(flag, priority, updateFunc, extraInfo)
	mod.EnemyStatusEffects[flag] = {Flag = flag, 
	                                Priority = priority, 
	                                Update = updateFunc, 
	                                PostUpdate = extraInfo and extraInfo.PostUpdate, 
	                                Vasculitis = extraInfo and extraInfo.Vasculitis, 
	                                HasIcon = extraInfo and extraInfo.HasIcon}
	mod.EnemiesWithStatus[flag] = mod.EnemiesWithStatus[flag] or {}
	return flag
end

-- leaving this here as a point of reference for priority:

-- early priority (0-999) (statuses that deal damage or kill enemies as part of their 
--                         update cycle, or just don't super care when ran):
-- 		multieuclidean, mugged, hemorrhaging, pacified, nursing, festering, soulful, sentenced, gleaming, hidden
-- 		infected confuzzle, overloaded, drowsy, doom, bruise (should always end)

-- mid priority (1000-9999) (statuses that check amount of damage taken as part of their
--                           update cycle, or rely on enemies dying):
-- 		sewn (should always start), berserk, martyr, dried paint

-- late priority (10000+) (statuses that could mess up later called statuses or are 
--                        otherwise impacted by them):
--		excommunicated, enthralled (should always end)

mod.LoadScripts({
    --"ffscripts.statuses.atrophy",
    "ffscripts.statuses.berserk",
    --"ffscripts.statuses.blind",
    --"ffscripts.statuses.bloated",
    "ffscripts.statuses.bruise",
    "ffscripts.statuses.doom",
    "ffscripts.statuses.drowsyAndSleep",
    "ffscripts.statuses.excommunicated",
	"ffscripts.statuses.flooded",
    "ffscripts.statuses.hemorrhaging",
    "ffscripts.statuses.martyr",
    "ffscripts.statuses.multieuclidean",
    "ffscripts.statuses.mugged",
    "ffscripts.statuses.overloaded",
	"ffscripts.statuses.pacified",
    "ffscripts.statuses.sewn",
    --"ffscripts.statuses.sweaty",
	"ffscripts.statuses.festering",
	"ffscripts.statuses.soulful",
	"ffscripts.statuses.sentenced",
	"ffscripts.statuses.nursing",
	"ffscripts.statuses.gleaming",
	"ffscripts.statuses.hidden",
	"ffscripts.statuses.traced",
})

-----------------------------------------------------------
-- Status Effects
-----------------------------------------------------------

function mod:isIceBlacklisted(entity)
	return entity:IsBoss() or
	       FiendFolio.IceBlacklist[entity.Type] or
	       FiendFolio.IceBlacklist[entity.Type .. " " .. entity.Variant] or
	       FiendFolio.IceBlacklist[entity.Type .. " " .. entity.Variant .. " " .. entity.SubType]
end

function mod:isIceWhitelisted(entity)
	return FiendFolio.IceWhitelist[entity.Type] or
	       FiendFolio.IceWhitelist[entity.Type .. " " .. entity.Variant] or
	       FiendFolio.IceWhitelist[entity.Type .. " " .. entity.Variant .. " " .. entity.SubType]
end

function mod:isStatusBlacklisted(entity)
	return mod.FFStatusBlacklist[entity.Type] or
	       mod.FFStatusBlacklist[entity.Type .. " " .. entity.Variant] or
	       mod.FFStatusBlacklist[entity.Type .. " " .. entity.Variant .. " " .. entity.SubType]
end

function mod:isLeavingStatusCorpse(entity)
	return entity:HasMortalDamage() and (entity:HasEntityFlags(EntityFlag.FLAG_ICE) or mod:GetEntityData(entity).FFApplyMartyrOnDeath == true)
end

function mod:isStatusCorpse(entity)
	local ptrhash = GetPtrHash(entity)
	return entity:HasEntityFlags(EntityFlag.FLAG_ICE_FROZEN) or mod:GetEntityData(entity).FFMartyrDuration ~= nil or mod.EnemiesWithStatus["MARTYR"][ptrhash] or mod.WasMartyrGhost[ptrhash]
end

function mod:isDamagableByStatus(npc, target)
	return target:ToNPC() and (mod:isCharm(npc) or mod:isBerserk(npc) or mod:isBaited(target))
end

function mod:isCharmOrBerserk(npc)
	return mod:isCharm(npc) or mod:isBerserk(npc)
end

function mod:hasCustomStatus(npc, ignoreBruise)
	local data = mod:GetEntityData(npc)
	return (data.FFAtrophyDuration ~= nil and data.FFAtrophyDuration > 0) or 
	       (data.FFBerserkDuration ~= nil and data.FFBerserkDuration > 0) or
	       (data.FFBlindDuration ~= nil and data.FFBlindDuration > 0) or 
	       (data.FFBloatedDuration ~= nil and data.FFBloatedDuration > 0) or
	       (not ignoreBruise and data.FFBruiseInstances ~= nil and #data.FFBruiseInstances > 0) or 
	       (data.FFDoomDuration ~= nil and data.FFDoomDuration > 0) or 
	       (data.FFDrowsyDuration ~= nil and data.FFDrowsyDuration > 0) or 
	       (data.FFSleepDuration ~= nil and data.FFSleepDuration > 0) or 
	       (data.FFBleedDuration ~= nil and data.FFBleedDuration > 0) or 
	       (data.FFSewnDuration ~= nil and data.FFSewnDuration > 0) or 
	       (data.FFSweatyDuration ~= nil and data.FFSweatyDuration > 0) or
		   (data.FFMultiEuclideanDuration ~= nil and data.FFMultiEuclideanDuration > 0) or
		   (data.FFExcommunicatedDuration ~= nil and data.FFExcommunicatedDuration > 0) or
		   (data.FFMuggedDuration ~= nil and data.FFMuggedDuration > 0) or
		   (data.FFPacifiedDuration ~= nil and data.FFPacifiedDuration > 0) or
		   (data.FFFesteringDuration ~= nil and data.FFFesteringDuration > 0) or
		   (data.FFSoulfulDuration ~= nil and data.FFSoulfulDuration > 0)
end

function mod:removeStatusEffects(entity, ignoreFriendly, isCloned)
	if mod:isSegmented(entity) and not isCloned then
		local segments = mod:getSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				mod:removeStatusEffects(entity, ignoreFriendly, true)
			end
		end
	elseif mod:isBasegameSegmented(entity) and not isCloned then
		local segments = mod:getBasegameSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				mod:removeStatusEffects(entity, ignoreFriendly, true)
			end
		end
	end

	if ignoreFriendly then
		entity:ClearEntityFlags(EntityFlag.FLAG_FRIENDLY)
	end

	-- WHY DOES THE BASEGAME REMOVESTATUSEFFECTS RESET COLOR WHY WHY WHY
	entity:ClearEntityFlags(EntityFlag.FLAG_FREEZE | EntityFlag.FLAG_POISON | EntityFlag.FLAG_SLOW |
	                        EntityFlag.FLAG_CHARM | EntityFlag.FLAG_CONFUSION | EntityFlag.FLAG_MIDAS_FREEZE |
	                        EntityFlag.FLAG_FEAR | EntityFlag.FLAG_BURN | EntityFlag.FLAG_SHRINK |
	                        EntityFlag.FLAG_BLEED_OUT | EntityFlag.FLAG_MAGNETIZED | EntityFlag.FLAG_BAITED |
	                        EntityFlag.FLAG_WEAKNESS | EntityFlag.FLAG_BRIMSTONE_MARKED)

	--FiendFolio.RemoveAtrophy(entity)
	FiendFolio.RemoveBerserk(entity, isCloned)
	FiendFolio.RemoveBleed(entity)
	--FiendFolio.RemoveBlind(entity)
	--FiendFolio.RemoveBloated(entity)
	FiendFolio.RemoveBruise(entity)
	FiendFolio.RemoveDoom(entity)
	FiendFolio.RemoveDrowsy(entity)
	FiendFolio.RemoveExcommunicated(entity)
	FiendFolio.RemoveSewn(entity)
	FiendFolio.RemoveSleep(entity)
	--FiendFolio.RemoveSweaty(entity)
	FiendFolio.RemoveMultiEuclidean(entity)
	FiendFolio.RemoveOverloaded(entity)
	FiendFolio.RemoveMugged(entity)
	FiendFolio.RemovePacified(entity)
	FiendFolio.RemoveFestering(entity)
	FiendFolio.RemoveSoulful(entity)
	FiendFolio.RemoveSentenced(entity)
end

function mod:checkIfStatusLogicIsApplied(entity, flipKnights, allowLogicIfSomewhatSegmented)
	if not (mod:isSegmented(entity) or mod:isBasegameSegmented(entity)) then
		return true
	elseif flipKnights and entity.Type == mod.FF.ToxicKnight.ID and entity.Variant == mod.FF.ToxicKnight.Var then
		return entity.SubType == mod.FF.ToxicKnightBrain.Sub
	elseif flipKnights and entity.Type == mod.FF.PsiKnight.ID and entity.Variant == mod.FF.PsiKnight.Var then
		return entity.SubType == mod.FF.PsiKnightBrain.Sub
	elseif entity.Type == mod.FF.FoozTwinRed.ID and entity.Variant == mod.FF.FoozTwinRed.Var then
		return allowLogicIfSomewhatSegmented or not (entity.Parent and entity.Parent:Exists() and not entity.Parent:IsDead())
	elseif entity.Type == EntityType.ENTITY_HEART or entity.Type == EntityType.ENTITY_HEART_OF_INFAMY then
		return true
	elseif entity.Type == EntityType.ENTITY_MASK or (entity.Type == EntityType.ENTITY_MASK_OF_INFAMY and entity.Parent) then
		return allowLogicIfSomewhatSegmented
	elseif entity.Type == EntityType.ENTITY_MASK_OF_INFAMY and not entity.Parent then
		return true
	elseif mod:isMainSegment(entity) or mod:isBasegameMainSegment(entity) then
		return true
	elseif mod:isReducedSyncSegment(entity) or mod:isBasegameReducedSyncSegment(entity) then
		return true
	else
		return false
	end
end

function mod:getBasegameVelocityMultiplier(entity)
	local room = game:GetRoom()
	
	local isSlowed = entity:HasEntityFlags(EntityFlag.FLAG_SLOW)
	local isWeak = entity:HasEntityFlags(EntityFlag.FLAG_WEAKNESS)
	local brokenWatchState = room:GetBrokenWatchState()
	local hasStopWatch = PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_STOP_WATCH)
	local hourglassActive = room:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_HOURGLASS)

	local slowValue = 1.0
	if isSlowed then
		slowValue = slowValue * 0.5
	end
	if isWeak then
		slowValue = slowValue * 2/3
	end
	if brokenWatchState == 1 then
		slowValue = slowValue * 0.5
	elseif brokenWatchState == 2 then
		slowValue = slowValue * 1.43
	end
	if hasStopWatch then
		slowValue = slowValue * 0.8
	end
	if hourglassActive then
		slowValue = slowValue * 0.5
	end

	return slowValue
end

function mod:isInMinecart(entity)
	local minecarts = Isaac.FindByType(EntityType.ENTITY_MINECART, -1, -1, true)
	for _, minecart in ipairs(minecarts) do
		if minecart.Child ~= nil and minecart.Child.Index == entity.Index and minecart.Child.InitSeed == entity.InitSeed then
			return true
		end
	end
	
	return false
end

function mod:isInAnimaSola(entity)
	local chains = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.ANIMA_CHAIN, 0, true)
	for _, chain in ipairs(chains) do
		if chain.FrameCount > 5 and chain.Target ~= nil and chain.Target.Index == entity.Index and chain.Target.InitSeed == entity.InitSeed then
			return true
		end
	end
	
	return false
end

function mod:handleAnimAndMoveSpeedMultipliers(info)
	local entity = info.NPC
	local statusMultiplier = info.Mult
	if info.NoSpeed then
		statusMultiplier = 0
	end
	if statusMultiplier ~= 1 and not (mod:isInMinecart(entity) or mod:isInAnimaSola(entity)) then
		local basegameVelocityMultiplier = mod:getBasegameVelocityMultiplier(entity)

		entity.Position = entity.Position - entity.Velocity * basegameVelocityMultiplier * (1 - statusMultiplier)
		info.OriginalVelocity = entity.Velocity
		entity.Velocity = entity.Velocity * statusMultiplier
	end

	entity:GetSprite().PlaybackSpeed = statusMultiplier
	mod:riftWalkerSetAnimMulti(entity, statusMultiplier)
end

local statusVelCallbacksEnabled = false
function mod:resetStatusVelocityPreNPC(npc)
	local ptrhash = GetPtrHash(npc)
	local info = mod.HasAnimAndMoveMulti[ptrhash]
	if info then
		local npc = info.NPC
		npc.Velocity = info.OriginalVelocity or npc.Velocity
		mod.HasAnimAndMoveMulti[ptrhash] = nil
	end
end
mod:AddPriorityManualCallback(ModCallbacks.MC_PRE_NPC_UPDATE, math.huge, mod.resetStatusVelocityPreNPC)

function mod:resetStatusVelocity()
	if Isaac.GetFrameCount() % 2 == 0 then
		for k, info in pairs(mod.HasAnimAndMoveMulti) do
			local npc = info.NPC
			npc.Velocity = info.OriginalVelocity or npc.Velocity
		end
		mod.HasAnimAndMoveMulti = {}
	end
end
mod:AddManualCallback(ModCallbacks.MC_POST_RENDER, mod.resetStatusVelocity)

function mod:setTargetOfNPC(npc, data)
	local typ, var = npc.Type, npc.Variant
	if typ == EntityType.ENTITY_EVIS and var == 10 then -- Evis Guts / Sewing Rope
		return
	elseif typ == EntityType.ENTITY_SIREN_HELPER then
		return
	end
	
	local target
	if mod:isSegmented(npc) then
		if mod:isMainSegment(npc) then
			if npc.Target and npc.Target:HasEntityFlags(EntityFlag.FLAG_BAITED) and not mod:isInSegmentsOf(npc.Target, npc) then
				target = npc.Target
			elseif data.FFBerserkDuration ~= nil and data.FFBerserkDuration >= 0 then
				target = mod:getBerserkTarget(npc, data)
			else
				target = npc.Target
				if npc.Target == nil then
					target = npc:GetPlayerTarget()
				end
				
				if mod:isInSegmentsOf(target, npc) then
					local npcIsCharmed = npc:HasEntityFlags(EntityFlag.FLAG_CHARM)
					local npcIsFriendly = npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)

					local closestDist = 999999
					local closestEnt = nil
					local closestEntHasBait = false

					for _, entity in ipairs(Isaac.FindInRadius(game:GetRoom():GetCenterPos(), 1000, EntityPartition.ENEMY)) do
						local entityIsBaited = entity:HasEntityFlags(EntityFlag.FLAG_BAITED)
						local entityIsFriendly = entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)
						local entityIsSelf = entity.Index == npc.Index and entity.InitSeed == npc.InitSeed

						if entityIsSelf then
							-- do nothing
						elseif entity:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) then
							-- do nothing
						elseif mod:isSegmented(entity) and mod:isInSegmentsOf(entity, npc) then
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
							end
						elseif closestEntHasBait then
							-- do nothing
						elseif not (npcIsFriendly or npcIsCharmed) then
							-- do nothing
						else
							local dist = (entity.Position - npc.Position):Length()
							if dist < closestDist then
								closestEnt = entity
								closestDist = dist
								closestEntHasBait = entityHasBait
							end
						end
					end

					if closestEntHasBait then
						-- do nothing
					elseif (npcIsCharmed or npcIsFriendly) and closestEnt then
						-- do nothing
					else
						local player = game:GetNearestPlayer(npc.Position)
						local dist = (player.Position - npc.Position):Length()
						if dist < closestDist then
							closestEnt = player
							closestDist = dist
							closestEntHasBait = false
						end
					end

					target = closestEnt
				end
			end
		else
			for _, segment in ipairs(mod:getSegments(npc)) do
				if mod:isMainSegment(segment) then
					target = segment.Target
					break
				end
			end
		end
	elseif mod:isBasegameSegmented(npc) then
		if mod:isBasegameMainSegment(npc) then
			if npc.Target and npc.Target:HasEntityFlags(EntityFlag.FLAG_BAITED) then
				target = npc.Target
			elseif data.FFBerserkDuration ~= nil and data.FFBerserkDuration >= 0 then
				target = mod:getBerserkTarget(npc, data)
			end
		else
			for _, segment in ipairs(mod:getBasegameSegments(npc)) do
				if mod:isBasegameMainSegment(segment) then
					target = segment.Target
					break
				end
			end
		end
	else
		if npc.Target and npc.Target:HasEntityFlags(EntityFlag.FLAG_BAITED) then
			target = npc.Target
		elseif data.FFBerserkDuration ~= nil and data.FFBerserkDuration >= 0 then
			target = mod:getBerserkTarget(npc, data)
		end
	end

	if target ~= nil and target:ToNPC() then
		npc.Target = target
		data.FFForcedTarget = target
		return true
	elseif data.FFForcedTarget then
		if not npc.Target or (data.FFForcedTarget.Index == npc.Target.Index and data.FFForcedTarget.InitSeed == npc.Target.InitSeed) then
			npc.Target = nil
		end
		data.FFForcedTarget = nil
		return false
	end
end

mod.LoadedBerserkTargetCallback = false
function mod:handleBerserkTargeting(npc)
	local ptrhash = GetPtrHash(npc)
	if not mod.BerserkEnemiesToRetarget[ptrhash] then
		return
	end
	
	if not mod:setTargetOfNPC(npc, mod:GetEntityData(npc)) then
		mod.BerserkEnemiesToRetarget[ptrhash] = nil
		for _,_ in pairs(mod.BerserkEnemiesToRetarget) do
			return
		end
		mod.DisableManualCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.handleBerserkTargeting)
		mod.LoadedBerserkTargetCallback = false
	end
end
mod:AddManualCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.handleBerserkTargeting)

function mod:shouldClearStatus(entity)
	if entity.Type == EntityType.ENTITY_FROZEN_ENEMY then
		return true
	elseif entity.Type == EntityType.ENTITY_CLICKETY_CLACK and entity.State == 16 then
		return true
	elseif entity.Type == EntityType.ENTITY_VISAGE and entity.Variant == 1 and entity.State == 109 then
		return true
	else
		return false
	end
end

function mod:handleCordifyMarkersWithUranus()
-- Cordify Marker + Uranus compatibility because effects are weird
	local markers = Isaac.FindByType(EntityType.ENTITY_EFFECT, 1731)
	for _,marker in ipairs(markers) do
		if marker.Parent and (mod:isLeavingStatusCorpse(marker.Parent) or mod:isStatusCorpse(marker.Parent)) then
			marker:Remove()
		end
	end
end
mod:AddPriorityEntityCallback(ModCallbacks.MC_POST_UPDATE, CallbackPriority.LATE, 
                              EntityType.ENTITY_EFFECT, 1731, nil,
                              mod.handleCordifyMarkersWithUranus)

if ModCallbacks.MC_PRE_STATUS_EFFECT_APPLY and StatusEffect and StatusEffect.ICE then
function mod:preventIceStatus(status, entity, source, duration)
	local npc = entity:ToNPC()
	if npc then
		if mod:isIceBlacklisted(npc) and not mod:isIceWhitelisted(npc) then
			return false
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_STATUS_EFFECT_APPLY, mod.preventIceStatus, StatusEffect.ICE)
end

function mod:addCopyStatusHandler(typ, var, subt)
	if ModCallbacks.MC_POST_STATUS_EFFECT_APPLY then
	mod:AddEntityCallback(ModCallbacks.MC_POST_STATUS_EFFECT_APPLY, typ, var, subt, function(_, status, ent1)
		if ent1.Type == typ and
		   (var == nil or ent1.Variant == var) and
		   (subt == nil or ent1.SubType == subt)
		then
			for _, ent2 in ipairs(mod:getSegments(ent1)) do
				if ent1.Index ~= ent2.Index or ent1.InitSeed ~= ent2.InitSeed then
					mod:copyBasegameStatuses(ent1, ent2)
				end
			end
		end
	end)
	end
end

function mod:TrackEnemyStatus(entity, flag)
	local npc = entity:ToNPC()
	if npc == nil then return end

	local statusInfo = mod.EnemyStatusEffects[flag]
	if statusInfo == nil then return end

	local ptrhash = GetPtrHash(npc)
	mod.StatusesOnEnemy[ptrhash] = mod.StatusesOnEnemy[ptrhash] or {}
	mod.StatusesOnEnemy[ptrhash][flag] = true
	mod.EnemiesWithStatus[flag][ptrhash] = npc
	
	-- insert in reverse table order so that statuses disabling themselves dont cause issues
	for i = #mod.CurrentlyRunningStatuses, 1, -1 do
		local entry = mod.CurrentlyRunningStatuses[i]
		if entry.Flag == flag then
			goto postTrackStatus
		elseif entry.Priority > statusInfo.Priority then
			table.insert(mod.CurrentlyRunningStatuses, i+1, statusInfo)
			goto postTrackStatus
		end
	end
	table.insert(mod.CurrentlyRunningStatuses, 1, statusInfo)
	
	::postTrackStatus::
	mod:nursingPostTrack(flag)
end

function mod:UntrackEnemyStatus(entity, flag)
	local npc = entity:ToNPC()
	if npc == nil then return end
	
	local statusInfo = mod.EnemyStatusEffects[flag]
	if statusInfo == nil then return end
	
	local ptrhash = GetPtrHash(npc)
	if mod.StatusesOnEnemy[ptrhash] then
		mod.StatusesOnEnemy[ptrhash][flag] = nil
		for _,_ in pairs(mod.StatusesOnEnemy) do
			goto untrackStatusPostEnemy
		end
		mod.StatusesOnEnemy[ptrhash] = nil
	end
	
	::untrackStatusPostEnemy::
	mod.EnemiesWithStatus[flag][ptrhash] = nil
	for _,_ in pairs(mod.EnemiesWithStatus[flag]) do
		goto postUntrackStatus
	end
	for i, entry in ipairs(mod.CurrentlyRunningStatuses) do
		if entry.Flag == flag then
			table.remove(mod.CurrentlyRunningStatuses, i)
			goto postUntrackStatus
		end
	end
	
	::postUntrackStatus::
	mod:nursingPostUntrack(flag)
end

local entitiesToPostRemove = {}
mod.HasTempStatusFlag = {}
mod.StatusSentKillingBlow = {}
mod.BruiseBossStatusResistance = {}
mod.HasAnimAndMoveMulti = {}
mod.ResetPlaybackSpeed = {}
mod.DrowsyEnemiesToColor = {}
mod.EnthralledEnemiesToColor = {}
mod.OverloadedEnemiesToColor = {}
mod.MultieuclideanEnemiesToColor = {}
mod.NursingEnemiesToColor = {}
mod.BerserkEnemiesToRetarget = {}
mod.QueuedStatusApply = {}
mod.DoomHPEstimate = {}
mod.VasculitisInfo = {}
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, e)
	local etyp = e.Type
	if etyp <= 9 or etyp >= 1000 then return end
	
	table.insert(entitiesToPostRemove, e)
end)

function mod:statusPostRemove(e)
	local ptrhash = GetPtrHash(e)
	if mod.StatusesOnEnemy[ptrhash] ~= nil then
		for flag, _ in pairs(mod.StatusesOnEnemy[ptrhash]) do
			mod:UntrackEnemyStatus(e, flag)
		end
		mod.StatusesOnEnemy[ptrhash] = nil
	end
	mod.HasTempStatusFlag[ptrhash] = nil
	mod.StatusSentKillingBlow[ptrhash] = nil
	mod.BruiseBossStatusResistance[ptrhash] = nil
	mod.HasAnimAndMoveMulti[ptrhash] = nil
	mod.ResetPlaybackSpeed[ptrhash] = nil
	mod.SewnRopes[ptrhash] = nil
	mod.DrowsyEnemiesToColor[ptrhash] = nil
	mod.EnthralledEnemiesToColor[ptrhash] = nil
	mod.OverloadedEnemiesToColor[ptrhash] = nil
	mod.MultieuclideanEnemiesToColor[ptrhash] = nil
	mod.NursingEnemiesToColor[ptrhash] = nil
	mod.BerserkEnemiesToRetarget[ptrhash] = nil
	if mod.LoadedBerserkTargetCallback then
		for _,_ in pairs(mod.BerserkEnemiesToRetarget) do
			return
		end
		mod.DisableManualCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.handleBerserkTargeting)
		mod.LoadedBerserkTargetCallback = false
	end
	mod.QueuedStatusApply[ptrhash] = nil
	mod.DoomHPEstimate[ptrhash] = nil
	mod.VasculitisInfo[ptrhash] = nil
end

local loadedIconCallback = false
function mod:handleStatusEffects()
	mod:resetOnlyDeadBerserkRemaining()
	
	-- vasculitis is handled in MC_POST_NPC_DEATH
	-- MC_POST_NPC_DEATH is after MC_POST_ENTITY_REMOVE
	-- so i have to delay the post removal stuff or else i lose everything and vasculitis doesn't work
	-- bleh
	for _, e in ipairs(entitiesToPostRemove) do
		mod:statusPostRemove(e)
	end
	entitiesToPostRemove = {}

	for _, info in pairs(mod.HasTempStatusFlag) do
		info.NPC:ClearEntityFlags(info.FlagsToRemove)
	end
	mod.HasTempStatusFlag = {}
	
	for _, applyFuncs in pairs(mod.QueuedStatusApply) do
		for _, func in ipairs(applyFuncs) do
			func()
		end
	end
	mod.QueuedStatusApply = {}
	mod.DoomHPEstimate = {}
	
	-- move into temp table so that statuses disabling themselves dont cause issues
	local statusesToRun = {}
	local runStatusIcons = false
	for i = #mod.CurrentlyRunningStatuses, 1, -1 do
		local statusInfo = mod.CurrentlyRunningStatuses[i]
		table.insert(statusesToRun, statusInfo)
	end
	for _, statusInfo in ipairs(statusesToRun) do
		local flag = statusInfo.Flag
		local updateFunc = mod[statusInfo.Update]
		
		for _, npc in pairs(mod.EnemiesWithStatus[flag]) do
			local data = mod:GetEntityData(npc)
			local sprite = npc:GetSprite()
			local clearingStatus = mod:shouldClearStatus(npc)
			
			updateFunc(mod, npc, data, sprite, clearingStatus)
		end
		
		if statusInfo.PostUpdate ~= nil then
			mod[statusInfo.PostUpdate](mod, mod.EnemiesWithStatus[flag])
		end
		
		runStatusIcons = runStatusIcons or statusInfo.HasIcon
	end

	for k, npcPtr in pairs(mod.StatusSentKillingBlow) do
		if npcPtr.Ref and npcPtr.Ref.HitPoints > 0.0 then
			mod.StatusSentKillingBlow[k] = nil
		end
	end

	for k, info in pairs(mod.BruiseBossStatusResistance) do
		info.Cooldown = info.Cooldown - 1
		if info.Cooldown <= 0 or info.NPC:GetBossStatusEffectCooldown() <= 0 then
			mod.BruiseBossStatusResistance[k] = nil
		end
	end
	
	for k, npc in pairs(mod.ResetPlaybackSpeed) do
		if not npc:HasEntityFlags(EntityFlag.FLAG_FREEZE) then
			local sprite = npc:GetSprite()
			sprite.PlaybackSpeed = 1
			mod.ResetPlaybackSpeed[k] = nil
		end
	end
	
	local needToEnableStatusVelCallbacks = false
	for k, info in pairs(mod.HasAnimAndMoveMulti) do
		mod:handleAnimAndMoveSpeedMultipliers(info)
		mod.ResetPlaybackSpeed[k] = info.NPC
		needToEnableStatusVelCallbacks = true
	end
	
	if needToEnableStatusVelCallbacks then
		if not statusVelCallbacksEnabled then
			mod:EnableManualCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.resetStatusVelocityPreNPC)
			mod:EnableManualCallback(ModCallbacks.MC_POST_RENDER, mod.resetStatusVelocity)
			statusVelCallbacksEnabled = true
		end
	else
		if statusVelCallbacksEnabled then
			mod:DisableManualCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.resetStatusVelocityPreNPC)
			mod:DisableManualCallback(ModCallbacks.MC_POST_RENDER, mod.resetStatusVelocity)
			statusVelCallbacksEnabled = false
		end
	end
	
	if runStatusIcons then
		if not loadedIconCallback then
			mod:EnableManualCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.statusIconsNPC)
			loadedIconCallback = true
		end
	else
		if loadedIconCallback then
			mod:DisableManualCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.statusIconsNPC)
			loadedIconCallback = false
		end
	end
	
	mod:handleSewnRopes()
	mod:colorDrowsyEnemies()
	mod:colorMultieuclideanEnemies()
	mod:colorOverloadedEnemies()
	mod:colorNursingEnemies()
	mod:colorEnthralledEnemies()
	mod:jevilBruseEnemies()
end

local function entityflagsToTearflags(entityflags)
	local tearflags = TearFlags.TEAR_NORMAL
	if entityflags & EntityFlag.FLAG_FREEZE ~= 0 then
		tearflags = tearflags | TearFlags.TEAR_FREEZE
	end
	if entityflags & EntityFlag.FLAG_POISON ~= 0 then
		tearflags = tearflags | TearFlags.TEAR_POISON
	end
	if entityflags & EntityFlag.FLAG_SLOW ~= 0 then
		tearflags = tearflags | TearFlags.TEAR_SLOW
	end
	if entityflags & EntityFlag.FLAG_CHARM ~= 0 or entityflags & EntityFlag.FLAG_FRIENDLY ~= 0 then
		tearflags = tearflags | TearFlags.TEAR_CHARM
	end
	if entityflags & EntityFlag.FLAG_CONFUSION ~= 0 then
		tearflags = tearflags | TearFlags.TEAR_CONFUSION
	end
	if entityflags & EntityFlag.FLAG_MIDAS_FREEZE ~= 0 then
		tearflags = tearflags | TearFlags.TEAR_MIDAS
	end
	if entityflags & EntityFlag.FLAG_FEAR ~= 0 then
		tearflags = tearflags | TearFlags.TEAR_FEAR
	end
	if entityflags & EntityFlag.FLAG_BURN ~= 0 then
		tearflags = tearflags | TearFlags.TEAR_BURN
	end
	if entityflags & EntityFlag.FLAG_SHRINK ~= 0 then
		tearflags = tearflags | TearFlags.TEAR_GODS_FLESH
	end
	if entityflags & EntityFlag.FLAG_BLEED_OUT ~= 0 then
		tearflags = tearflags | TearFlags.TEAR_BACKSTAB
	end
	if entityflags & EntityFlag.FLAG_ICE ~= 0 or entityflags & EntityFlag.FLAG_ICE_FROZEN ~= 0 then
		tearflags = tearflags | TearFlags.TEAR_ICE
	end
	if entityflags & EntityFlag.FLAG_MAGNETIZED ~= 0 then
		tearflags = tearflags | TearFlags.TEAR_MAGNETIZE
	end
	if entityflags & EntityFlag.FLAG_BAITED ~= 0 then
		tearflags = tearflags | TearFlags.TEAR_BAIT
	end
	if entityflags & EntityFlag.FLAG_WEAKNESS ~= 0 then
		--tearflags = tearflags | TearFlags.TEAR_
	end
	if entityflags & EntityFlag.FLAG_BRIMSTONE_MARKED ~= 0 then
		--tearflags = tearflags | TearFlags.TEAR_
	end
	return tearflags
end

function mod:handleVasculitis(tear, npc)
	local ptrhash = GetPtrHash(npc)
	local tempInfo = mod.HasTempStatusFlag[ptrhash]
	if tempInfo then
		tear:ClearTearFlags(entityflagsToTearflags(tempInfo.FlagsToRemove))
	end

	for _, statusInfo in pairs(mod.EnemyStatusEffects) do
		local vasculitisFunc = mod[statusInfo.Vasculitis]
		if vasculitisFunc ~= nil then
			vasculitisFunc(mod, tear, npc)
		end
	end
end
mod:AddCallback(TearFlagsLib.Callback.POST_FIRE_VASCULITIS_TEAR, mod.handleVasculitis)

function mod:getStatusIconInfo(entity, data)
	if not entity then
		return
	else
		local anim = nil
		local offset = nil
		local noRender = false
		--local color = nil

		if data.FFNursingDuration ~= nil then
			anim = "Nursing"
			offset = Vector(0.5, -10)
		elseif data.FFDoomDuration ~= nil then
			offset = Vector(0, -10)
			
			local showNightmareIcon = data.FFNightmare and (data.FFDrowsyDuration == nil or data.FFDrowsyDuration <= 0)
			if showNightmareIcon then
				anim = "Nightmare" .. data.FFDoomCountdown
			else
				anim = "Doom" .. data.FFDoomCountdown
			end
			if data.FFDoomCountdown >= 10 then
				if showNightmareIcon then
					anim = "Nightmare10+"
				else
					anim = "Doom10+"
				end
			end
		elseif (data.FFDrowsyDuration == nil or data.FFDrowsyDuration <= 0) and data.FFSleepDuration ~= nil then
			anim = "Sleep"
			offset = Vector(0.5, 0)
		elseif data.FFPacifiedDuration ~= nil then
			anim = "Pacified"
			offset = Vector(0,0)
		elseif data.FFBerserkDuration ~= nil then
			anim = "Berserk"
			offset = Vector(0,0)
		elseif data.FFBruiseInstances ~= nil then
			offset = Vector(0.5, 0)

			local stacks = data.FFBruiseLastStacks or 0
			if stacks == 1 then
				anim = "BruiseLvl1"
			elseif stacks == 2 then
				anim = "BruiseLvl2"
			elseif stacks == 3 then
				anim = "BruiseLvl3"
			elseif stacks == 4 then
				anim = "BruiseLvl4"
			elseif stacks >= 5 then
				anim = "BruiseLvl5"
			end
		elseif data.FFSewnDuration ~= nil then
			anim = "Sewn"
			offset = Vector(0.5, 0)
		elseif data.FFOverloadedDuration ~= nil then
			anim = "Overloaded"
			offset = Vector(0,0)
		elseif data.FFBleedDuration ~= nil then
			anim = "Bleed"
			offset = Vector(0,0)
		elseif data.FFMuggedDuration ~= nil then
			anim = "Mugged"
			offset = Vector(0.5,-10)
		--[[elseif data.FFMultiEuclideanDuration ~= nil then
			anim = "Multieuclidean"
			offset = Vector(0,-10)
			
			local s = math.sin(game:GetFrameCount()/20*math.pi)
			color = Color(-s*2, -s*2, -s*2, 1, (s+1)/2, (s+1)/2, (s+1)/2)]]--
		elseif data.FFTracedStatus ~= nil then
			anim = "Traced"
			offset = Vector(0.5, -10)
		elseif entity:ToPlayer() and mod:getPlayerBruiseStrength(entity:ToPlayer()) > 0 then
			anim = "BruiseLvl1"
			offset = Vector(0.5, 0)
		elseif data.HoneyPennyTimer ~= nil then --Honey Powerup
			if data.HoneyPennyTimer <= 60 then
				anim = "HoneyRunOut"
			else
				anim = "Honey"
			end
			offset = Vector(0,0)
		elseif data.FFSentencedDuration ~= nil then
			offset = Vector(0, 0)
			anim = "SentencedPlaceholder"
			noRender = true
		end
		
		return anim, offset, noRender --, color
	end
end

function mod:statusIconsOld(effect)
	local parent = effect.Parent

	if not parent then
		effect:Remove()
	else
		local data = mod:GetEntityData(parent)
		local sprite = effect:GetSprite()

		local offset = 0

		-- these use the new system now
		--[[if data.FFDoomDuration ~= nil then
			local anim = "Doom" .. data.FFDoomCountdown
			if data.FFDoomCountdown >= 10 then
				anim = "Doom10+"
			end
			
			if not (sprite:IsPlaying(anim) or sprite:IsFinished(anim)) then
				sprite:Play(anim, true)
			end
		elseif data.FFBerserkDuration ~= nil then
			if not sprite:IsPlaying("Berserk") then
				sprite:Play("Berserk", true)
			end
		elseif data.FFOverloadedDuration ~= nil then
			if not sprite:IsPlaying("Overloaded") then
				sprite:Play("Overloaded", true)
			end
		elseif data.FFSewnDuration ~= nil then
			offset = 0.5

			if not sprite:IsPlaying("Sewn") then
				sprite:Play("Sewn", true)
			end
		elseif (data.FFDrowsyDuration == nil or data.FFDrowsyDuration <= 0) and data.FFSleepDuration ~= nil then
			offset = 0.5

			if not sprite:IsPlaying("Sleep") then
				sprite:Play("Sleep", true)
			end
		elseif data.FFBruiseInstances ~= nil then
			offset = 0.5

			local frame = 0
			if sprite:IsPlaying("BruiseLvl1") or sprite:IsPlaying("BruiseLvl2") or sprite:IsPlaying("BruiseLvl3") or sprite:IsPlaying("BruiseLvl4") or sprite:IsPlaying("BruiseLvl5") then
				frame = sprite:GetFrame()
			end

			local stacks = data.FFBruiseLastStacks or 0
			if stacks == 1 and not sprite:IsPlaying("BruiseLvl1") then
				sprite:Play("BruiseLvl1", true)
				sprite:SetFrame(frame)
			elseif stacks == 2 and not sprite:IsPlaying("BruiseLvl2") then
				sprite:Play("BruiseLvl2", true)
				sprite:SetFrame(frame)
			elseif stacks == 3 and not sprite:IsPlaying("BruiseLvl3") then
				sprite:Play("BruiseLvl3", true)
				sprite:SetFrame(frame)
			elseif stacks == 4 and not sprite:IsPlaying("BruiseLvl4") then
				sprite:Play("BruiseLvl4", true)
				sprite:SetFrame(frame)
			elseif stacks >= 5 and not sprite:IsPlaying("BruiseLvl5") then
				sprite:Play("BruiseLvl5", true)
				sprite:SetFrame(frame)
			end
		elseif data.FFBleedDuration ~= nil then
			if not sprite:IsPlaying("Bleed") then
				sprite:Play("Bleed", true)
			end
		elseif data.HoneyPennyTimer ~= nil and not sprite:IsPlaying("HoneyRunOut") then --Honey Powerup
			if data.HoneyPennyTimer <= 60 and not sprite:IsPlaying("HoneyRunOut") then--Honey Powerup
				sprite:Play("HoneyRunOut", true)
			elseif not sprite:IsPlaying("Honey") then
				sprite:Play("Honey", true)
			end
		end]]--

		if effect.FrameCount <= 1 then
			effect.SpriteOffset = Vector(offset, -30 + parent.Size * -1.0)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.statusIconsOld, 1748)

function mod:shouldMoveFromBasegameStatusIcon(entity)
	--if entity:HasEntityFlags(EntityFlag.FLAG_CHARM) or
	--   entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) or
	--   entity:HasEntityFlags(EntityFlag.FLAG_BURN) or
	--   entity:HasEntityFlags(EntityFlag.FLAG_POISON) or
	--   entity:HasEntityFlags(EntityFlag.FLAG_CONFUSION) or
	if entity:HasEntityFlags(EntityFlag.FLAG_FEAR) or
	   entity:HasEntityFlags(EntityFlag.FLAG_SLOW) or
	   entity:HasEntityFlags(EntityFlag.FLAG_BLEED_OUT) or
	   entity:HasEntityFlags(EntityFlag.FLAG_MAGNETIZED) or
	--   entity:HasEntityFlags(EntityFlag.FLAG_BAITED) or
	--   entity:HasEntityFlags(EntityFlag.FLAG_WEAKNESS) or
	   entity:HasEntityFlags(EntityFlag.FLAG_BRIMSTONE_MARKED)
	then
		return true
	end
	
	local npc = entity:ToNPC()
	if npc then
		local championIdx = npc:GetChampionColorIdx()
		if championIdx == ChampionColor.KING or championIdx == ChampionColor.DEATH then
			return true
		end
	end
	
	return game:GetRoom():GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_HOURGLASS)
end

local statusIconSprite = Sprite()
statusIconSprite:Load("gfx/ui/ff_statuseffects.anm2", true)
function mod:statusIconsNPC(entity, entityOffset)
	local ptrhash = GetPtrHash(entity)
	if not mod.StatusesOnEnemy[ptrhash] then
		return
	end
	
	local data = mod:GetEntityData(entity)
	if data.NoCustomStatusIndicators or not mod:checkIfStatusLogicIsApplied(entity, false, true) then
		return
	end
	
	local anim, animOffset, noRender = mod:getStatusIconInfo(entity, data)
	if anim == nil then
		data.FFLastStatusIconAnim = nil
		data.FFLastStatusIconFrame = nil
		data.FFLastTimeRenderedStatusIcon = nil
		return
	end
	
	local isaacFrameCount = Isaac.GetFrameCount()
	if data.FFLastFrameRanStatusIcons ~= isaacFrameCount and data.FFLastFrameRanStatusIcons ~= isaacFrameCount - 1 then
		data.FFLastStatusIconAnim = nil
		data.FFLastStatusIconFrame = nil
		data.FFLastTimeRenderedStatusIcon = nil
	end
	data.FFLastFrameRanStatusIcons = isaacFrameCount

	local iconOffset = Vector(0, -30 + entity.Size * -1.0)
	local iconColor = Color(1,1,1,1,0,0,0)
	local iconRotation = 0
	local iconScale = Vector(1,1)
	
	if REPENTOGON then
		local sprite = entity:GetSprite()
		--[[local iconNullFrame = sprite:GetNullFrame("OverlayEffect") -- crashes atm
		
		if iconNullFrame == nil or not iconNullFrame:IsVisible() then
			return
		end
		
		iconOffset = iconNullFrame:GetPos()
		iconColor = iconNullFrame:GetColor()
		iconRotation = iconNullFrame:GetRotation()
		iconScale = iconNullFrame:GetScale()]]--
		
		local iconOffsetTemp = Isaac.WorldToScreenDistance(entity:GetNullOffset("OverlayEffect"))
		if iconOffsetTemp:Length() <= 0 then
			return
		end
		iconOffset = iconOffsetTemp
	end
	
	if data.FFLastStatusIconAnim == "BruiseLvl1" or
	   data.FFLastStatusIconAnim == "BruiseLvl2" or
	   data.FFLastStatusIconAnim == "BruiseLvl3" or
	   data.FFLastStatusIconAnim == "BruiseLvl4" or
	   data.FFLastStatusIconAnim == "BruiseLvl5"
	then
		if anim ~= "BruiseLvl1" and
		   anim ~= "BruiseLvl2" and
		   anim ~= "BruiseLvl3" and
		   anim ~= "BruiseLvl4" and
		   anim ~= "BruiseLvl5"
		then
			data.FFLastStatusIconFrame = nil
			data.FFLastTimeRenderedStatusIcon = nil
		end
	elseif anim ~= data.FFLastStatusIconAnim then
		data.FFLastStatusIconFrame = nil
		data.FFLastTimeRenderedStatusIcon = nil
	end
	
	data.FFLastStatusIconAnim = anim
	data.FFLastStatusIconFrame = data.FFLastStatusIconFrame or 0
	
	local gameFrameCount = Game():GetFrameCount()
	if data.FFLastTimeRenderedStatusIcon ~= nil then
		data.FFLastStatusIconFrame = data.FFLastStatusIconFrame + (gameFrameCount - data.FFLastTimeRenderedStatusIcon)
	end
	data.FFLastTimeRenderedStatusIcon = gameFrameCount
	
	statusIconSprite:Play(anim, true)
	if REPENTOGON then
		local animData = statusIconSprite:GetCurrentAnimationData()
		if animData:IsLoopingAnimation() ~= 0 and animData:IsLoopingAnimation() ~= false then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % animData:GetLength()
		end
	else
		if anim == "BruiseLvl1" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 20
		elseif anim == "BruiseLvl2" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 30
		elseif anim == "BruiseLvl3" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 30
		elseif anim == "BruiseLvl4" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 30
		elseif anim == "BruiseLvl5" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 30
		elseif anim == "Bleed" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 7
		elseif anim == "Sewn" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 20
		elseif anim == "Sleep" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 60
		elseif anim == "Berserk" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 16
		elseif anim == "Doom1" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 4
		elseif anim == "Doom2" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 4
		elseif anim == "Doom3" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 4
		elseif anim == "Doom4" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 4
		elseif anim == "Doom5" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 4
		elseif anim == "Doom6" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 4
		elseif anim == "Doom7" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 4
		elseif anim == "Doom8" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 4
		elseif anim == "Doom9" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 4
		elseif anim == "Doom10+" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 4
		elseif anim == "Nightmare1" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 4
		elseif anim == "Nightmare2" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 4
		elseif anim == "Nightmare3" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 4
		elseif anim == "Nightmare4" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 4
		elseif anim == "Nightmare5" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 4
		elseif anim == "Nightmare6" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 4
		elseif anim == "Nightmare7" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 4
		elseif anim == "Nightmare8" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 4
		elseif anim == "Nightmare9" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 4
		elseif anim == "Nightmare10+" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 4
		elseif anim == "Overloaded" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 8
		elseif anim == "Pacified" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 8
		elseif anim == "Mugged" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 48
		elseif anim == "Multieuclidean" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 18
		elseif anim == "Traced" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 16
		end
	end
	
	statusIconSprite.Offset = iconOffset + animOffset
	statusIconSprite.Color = iconColor
	statusIconSprite.Rotation = iconRotation
	statusIconSprite.Scale = iconScale
	
	statusIconSprite:SetFrame(data.FFLastStatusIconFrame)
	statusIconSprite:Stop()
	
	local renderPosition = Isaac.WorldToScreen(entity.Position) - Game():GetRoom():GetRenderScrollOffset() + entityOffset
	local customIconOffset = Vector(0,0)
	if not noRender then
		customIconOffset = Vector(0,-16)
	end
	
	if data.FFStatusSpecialRender then
		if mod:shouldMoveFromBasegameStatusIcon(entity) then
			customIconOffset = Vector(0,-16)
		end
	
		data.FFStatusSpecialRender.Offset = iconOffset + customIconOffset
		data.FFStatusSpecialRender.Color = iconColor
		data.FFStatusSpecialRender.Rotation = iconRotation
		data.FFStatusSpecialRender.Scale = iconScale
		--[[if gameFrameCount % 2 == 0 then
			data.FFStatusSpecialRender:Update()
		end]]--
		data.FFStatusSpecialRender:Render(renderPosition, Vector.Zero, Vector.Zero)
	end
	
	if not noRender then
		statusIconSprite:Render(renderPosition, Vector.Zero, Vector.Zero)
	end
end
mod:AddPriorityManualCallback(ModCallbacks.MC_POST_NPC_RENDER, CallbackPriority.LATE, mod.statusIconsNPC)

for _, statusInfo in ipairs(mod.CurrentlyRunningStatuses) do
	if statusInfo.HasIcon then
		mod:EnableManualCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.statusIconsNPC)
		loadedIconCallback = true
		break
	end
end

function mod:statusIconsPlayer(entity, entityOffset, isFamiliar)
	if not entity:Exists() then return end

	if not isFamiliar then
		if mod:IsBriendTwin(entity) then
			return
		end
	end
	
	local data = mod:GetEntityData(entity)
	
	local anim, animOffset = mod:getStatusIconInfo(entity, data)
	if anim == nil then
		data.FFLastStatusIconAnim = nil
		data.FFLastStatusIconFrame = nil
		data.FFLastTimeRenderedStatusIcon = nil
		return
	end

	local iconOffset = Vector(0, -30 + entity.Size * -1.0)
	local iconColor = Color(1,1,1,1,0,0,0)
	local iconRotation = 0
	local iconScale = Vector(1,1)
	
	if data.FFLastStatusIconAnim == "BruiseLvl1" or
	   data.FFLastStatusIconAnim == "BruiseLvl2" or
	   data.FFLastStatusIconAnim == "BruiseLvl3" or
	   data.FFLastStatusIconAnim == "BruiseLvl4" or
	   data.FFLastStatusIconAnim == "BruiseLvl5"
	then
		if anim ~= "BruiseLvl1" and
		   anim ~= "BruiseLvl2" and
		   anim ~= "BruiseLvl3" and
		   anim ~= "BruiseLvl4" and
		   anim ~= "BruiseLvl5"
		then
			data.FFLastStatusIconFrame = nil
			data.FFLastTimeRenderedStatusIcon = nil
		end
	elseif anim ~= data.FFLastStatusIconAnim then
		data.FFLastStatusIconFrame = nil
		data.FFLastTimeRenderedStatusIcon = nil
	end
	
	data.FFLastStatusIconAnim = anim
	data.FFLastStatusIconFrame = data.FFLastStatusIconFrame or 0
	
	local frameCount = Game():GetFrameCount()
	if data.FFLastTimeRenderedStatusIcon ~= nil then
		data.FFLastStatusIconFrame = data.FFLastStatusIconFrame + (frameCount - data.FFLastTimeRenderedStatusIcon)
	end
	data.FFLastTimeRenderedStatusIcon = frameCount
	
	statusIconSprite:Play(anim, true)
	if REPENTOGON then
		local animData = statusIconSprite:GetCurrentAnimationData()
		if animData:IsLoopingAnimation() ~= 0 and animData:IsLoopingAnimation() ~= false then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % animData:GetLength()
		end
	else
		if anim == "BruiseLvl1" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 20
		elseif anim == "BruiseLvl2" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 30
		elseif anim == "BruiseLvl3" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 30
		elseif anim == "BruiseLvl4" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 30
		elseif anim == "BruiseLvl5" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 30
		elseif anim == "Bleed" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 7
		elseif anim == "Sewn" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 20
		elseif anim == "Sleep" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 60
		elseif anim == "Berserk" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 16
		elseif anim == "Doom1" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 4
		elseif anim == "Doom2" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 4
		elseif anim == "Doom3" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 4
		elseif anim == "Doom4" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 4
		elseif anim == "Doom5" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 4
		elseif anim == "Doom6" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 4
		elseif anim == "Doom7" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 4
		elseif anim == "Doom8" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 4
		elseif anim == "Doom9" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 4
		elseif anim == "Doom10+" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 4
		elseif anim == "Nightmare1" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 4
		elseif anim == "Nightmare2" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 4
		elseif anim == "Nightmare3" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 4
		elseif anim == "Nightmare4" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 4
		elseif anim == "Nightmare5" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 4
		elseif anim == "Nightmare6" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 4
		elseif anim == "Nightmare7" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 4
		elseif anim == "Nightmare8" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 4
		elseif anim == "Nightmare9" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 4
		elseif anim == "Nightmare10+" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 4
		elseif anim == "Overloaded" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 8
		elseif anim == "Pacified" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 8
		elseif anim == "Mugged" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 48
		elseif anim == "Multieuclidean" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 18
		elseif anim == "Traced" then
			data.FFLastStatusIconFrame = data.FFLastStatusIconFrame % 16
		end
	end
	
	statusIconSprite.Offset = iconOffset + animOffset
	statusIconSprite.Color = iconColor
	statusIconSprite.Rotation = iconRotation
	statusIconSprite.Scale = iconScale
	
	statusIconSprite:SetFrame(data.FFLastStatusIconFrame)
	statusIconSprite:Stop()
	
	local renderPosition = Isaac.WorldToScreen(entity.Position) - Game():GetRoom():GetRenderScrollOffset() + entityOffset
	statusIconSprite:Render(renderPosition, Vector.Zero, Vector.Zero)
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, mod.statusIconsPlayer)

function mod:copyBasegameStatuses(source, copy)
	local sourceHasHideHPBar = source:HasEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)
	local copyHasHideHPBar = copy:HasEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)
	source:ClearEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)
	copy:ClearEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)
	
	local sourceHasAppear = source:HasEntityFlags(EntityFlag.FLAG_APPEAR)
	local copyHasAppear = copy:HasEntityFlags(EntityFlag.FLAG_APPEAR)
	source:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	copy:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	
	source:CopyStatusEffects(copy)

	if sourceHasHideHPBar then
		source:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)
	else
		source:ClearEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)
	end
	if copyHasHideHPBar then
		copy:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)
	else
		copy:ClearEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)
	end

	if sourceHasAppear then
		source:AddEntityFlags(EntityFlag.FLAG_APPEAR)
	else
		source:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	end
	if copyHasAppear then
		copy:AddEntityFlags(EntityFlag.FLAG_APPEAR)
	else
		copy:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	end
	
	-- something is broken in rgon rn with copying status colors
	-- so here we go
	local copyColorParams = copy:GetColorParams() -- need to clear the copy's colorparams so we dont get exponential amounts of color params
	for i = #copyColorParams, 1, -1 do
		local params = copyColorParams[i]
		if params:GetPriority() == 255 then
			table.remove(copyColorParams, i)
		end
	end
	copy:SetColorParams(copyColorParams)
	
	local sourceColorParams = source:GetColorParams()
	for _, params in ipairs(sourceColorParams) do
		if params:GetPriority() == 255 then
			local color = params:GetColor()
			copy:SetColor(mod:copyColor(color), params:GetLifespan(), 255, false, true)
		end
	end
end

function mod:copyFFStatusEffects(source, copy)
	local sourceData = mod:GetEntityData(source)
	local copyData = mod:GetEntityData(copy)

	if not (copy:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) or mod:isStatusBlacklisted(copy)) then
		mod:copyHemorraging(copy, copyData, source, sourceData)
		mod:copyBruise(copy, copyData, source, sourceData)
		mod:copyDrowsyAndSleep(copy, copyData, source, sourceData)
		mod:copySewn(copy, copyData, source, sourceData)
		mod:copyBerserk(copy, copyData, source, sourceData)
		mod:copyDoom(copy, copyData, source, sourceData)
		mod:copyExcommunicated(copy, copyData, source, sourceData)
		mod:copyOverloaded(copy, copyData, source, sourceData)
		mod:copyMugged(copy, copyData, source, sourceData)
		mod:copyPacified(copy, copyData, source, sourceData)
		mod:copyFestering(copy, copyData, source, sourceData)
		mod:copySoulful(copy, copyData, source, sourceData)
		mod:copyMultiEuclidean(copy, copyData, source, sourceData)
		mod:copySentenced(copy, copyData, source, sourceData)
		mod:copyHidden(copy, copyData, source, sourceData)
	end

	mod:copyMartyr(copy, copyData, sourceData)
end

function mod:copyStatusEffects(source, copy)
	mod:copyBasegameStatuses(source, copy)
	mod:copyFFStatusEffects(source, copy)
end