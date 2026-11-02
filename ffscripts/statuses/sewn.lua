-- Sewn --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local statusflag = mod:RegisterEnemyStatusEffect("SEWN", 1000, "sewnOnUpdate", {PostUpdate = "sewnPostUpdate", HasIcon = true, Vasculitis = "sewnOnVasculitis"})
local tearflag = TearFlagsLib.RegisterTearFlag("SEW")
local statusColorPriority = 127

function mod:doNotShareHP(entity)
	return FiendFolio.HPSharingBlacklist[entity.Type] or
	       FiendFolio.HPSharingBlacklist[entity.Type .. " " .. entity.Variant] or
	       FiendFolio.HPSharingBlacklist[entity.Type .. " " .. entity.Variant .. " " .. entity.SubType]
end

function mod:SewnNpcTakeDmg(entity, data)
	data.FFSewnTookDamageThisFrame = game:GetFrameCount()
end

function mod:sewnPostUpdate(npcs)
	mod:handleSewnCurrentHealth(npcs)
	mod:spawnSewnRopes(npcs)
end

function mod:handleSewnCurrentHealth(npcs)
	local totalDamageToSpread = 0.0

	local someoneTookDamage = false
	local lastDamageWasFly = false
	for _, npc in pairs(npcs) do
		local data = mod:GetEntityData(npc)
		data.FFSewnLastDamageDealt = nil

		if data.FFSewnDuration ~= nil and mod:checkIfStatusLogicIsApplied(npc) and (not data.IsCuffed or data.CuffsDesignatedMainSegment) then
			totalDamageToSpread = totalDamageToSpread + math.max(0, (data.FFSewnLastHP or npc.HitPoints) - npc.HitPoints) * data.FFSewnDamagePercentage
			someoneTookDamage = someoneTookDamage or (data.FFSewnTookDamageThisFrame and game:GetFrameCount() - data.FFSewnTookDamageThisFrame <= 1)
			lastDamageWasFly = lastDamageWasFly or data.LastDamageWasFly
		end
	end

	if totalDamageToSpread > 0.0 then
		for _, npc in pairs(npcs) do
			local data = mod:GetEntityData(npc)

			if data.FFSewnDuration ~= nil then
				if someoneTookDamage then
					mod:applyFakeDamageFlash(npc)
				end
				
				if (not mod:isBasegameSegmented(npc) or mod:isBasegameMainSegment(npc) or mod:isBasegameReducedSyncSegment(npc)) then
					local sewnDamage = totalDamageToSpread - (math.max(0, (data.FFSewnLastHP or npc.HitPoints) - npc.HitPoints)) * data.FFSewnDamagePercentage
					if sewnDamage > 0.0 and 
					   ((npc.Type == mod.FF.Fishaac.ID and npc.Variant == mod.FF.Fishaac.Var) or
					    (npc.Type == mod.FF.TDweller.ID and npc.Variant == mod.FF.TDweller.Var))
					then
						npc:TakeDamage(1, 0, EntityRef(source), 0)
					else
						npc.HitPoints = npc.HitPoints - sewnDamage
					end
					
					data.FFSewnLastDamageDealt = sewnDamage
					
					if sewnDamage > 0.0 then 
						mod:doomOnDamage(npc, data, nil) 
						data.LastDamageWasFly = lastDamageWasFly
					end
					
					if npc.HitPoints <= 0.0 and npc.MaxHitPoints ~= 0.0 and (not mod:isStatusCorpse(npc)) and (not mod:isLeavingStatusCorpse(npc)) and not (npc.Type == EntityType.ENTITY_VISAGE and npc.Variant == 1) and not (data.FFBerserkDuration ~= nil and data.FFBerserkDuration >= 0) then
						if npc:IsBoss() then
							local ptrhash = GetPtrHash(npc)
							if not mod.StatusSentKillingBlow[ptrhash] then
								if not data.FFSewnSource then
									data.FFSewnSource = EntityRef(Isaac.GetPlayer(0))
								end
								npc:TakeDamage(0.0001, 0, data.FFSewnSource, 0)
							end
							mod.StatusSentKillingBlow[ptrhash] = EntityPtr(npc)
						else
							npc:Kill()
						end
						data.FFSewnDuration = nil
						data.FFSewnIgnoreRope = nil
						data.FFSewnDamagePercentage = nil
						data.FFSewnLastHP = nil
						mod:UntrackEnemyStatus(npc, statusflag)
						
						if not (npc:IsDead() or npc:HasMortalDamage()) then
							local ptrhash = GetPtrHash(npc)
							mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
							mod.VasculitisInfo[ptrhash][statusflag] = nil
						end
					end
				end
			end
		end
	end

	for _, npc in pairs(npcs) do
		local data = mod:GetEntityData(npc)
		if data.FFSewnDuration ~= nil then
			data.FFSewnLastHP = npc.HitPoints
		end
	end
end

mod.SewnRopes = {}
function mod:handleSewnRopes()
	local ropes = Isaac.FindByType(EntityType.ENTITY_EVIS, 10, 22, false, false)
	for k,rope in pairs(mod.SewnRopes) do
		local ropeData = mod:GetEntityData(rope)
		local removing = false

		if (not rope.Parent) or rope.Parent:IsDead() or mod:isStatusCorpse(rope.Parent) or mod:GetEntityData(rope.Parent).FFSewnDuration == nil then
			removing = true
		end

		if (not rope.Child) or rope.Child:IsDead() or mod:isStatusCorpse(rope.Child) or mod:GetEntityData(rope.Child).FFSewnDuration == nil then
			removing = true
		end

		if removing then
			if rope.Parent then
				mod:GetEntityData(rope.Parent).FFSewnRopeParent = nil
			end

			if rope.Child then
				mod:GetEntityData(rope.Child).FFSewnRopeChild = nil
			end

			if rope.Target then
				rope.Target:Remove()
			end

			mod.SewnRopes[k] = nil
			rope:Remove()
		end
	end
end

function mod:spawnSewnRopes(npcs)
	for k1, npc in pairs(npcs) do
		local npcData = mod:GetEntityData(npc)

		if npcData.FFSewnDuration ~= nil and 
		   not npcData.FFSewnIgnoreRope and
		   not npcData.FFSewnRopeParent and 
		   not (npc:IsDead() or mod:isStatusCorpse(npc)) and 
		   mod:checkIfStatusLogicIsApplied(npc)
		then
			for k2, otherNpc in pairs(npcs) do
				if k1 ~= k2 then
					local otherNpcData = mod:GetEntityData(otherNpc)

					if otherNpcData.FFSewnDuration ~= nil and 
					   not otherNpcData.FFSewnRopeChild and 
					   not (otherNpc:IsDead() or mod:isStatusCorpse(otherNpc)) and 
					   mod:checkIfStatusLogicIsApplied(otherNpc)
					then
						local npcChildRope = npcData.FFSewnRopeChild
						local otherNpcParentRope = otherNpcData.FFSewnRopeParent

						local alreadyConnected = false

						local nextChildData = npcData
						local nextChildRope = npcChildRope
						while nextChildRope ~= nil do
							if nextChildRope.Parent == nil or nextChildRope.Child == nil then
								nextChildRope:Remove()
								nextChildRope = nil
								nextChildData.FFSewnRopeChild = nil
								break
							end
							if otherNpcParentRope and nextChildRope.Index == otherNpcParentRope.Index then
								alreadyConnected = true
								break
							end
							nextChildData = mod:GetEntityData(nextChildRope.Parent)
							nextChildRope = nextChildData.FFSewnRopeChild
						end

						local nextParentData = otherNpcData
						local nextParentRope = otherNpcParentRope
						while nextParentRope ~= nil do
							if nextParentRope.Parent == nil or nextParentRope.Child == nil then
								nextParentRope:Remove()
								nextParentRope = nil
								nextParentData.FFSewnRopeParent = nil
								break
							end
							if alreadyConnected then
								break
							end
							if npcChildRope and nextParentRope.Index == npcChildRope.Index then
								alreadyConnected = true
								break
							end
							nextParentData = mod:GetEntityData(nextParentRope.Child)
							nextParentRope = nextParentData.FFSewnRopeParent
						end

						if not alreadyConnected then
							local rope = Isaac.Spawn(EntityType.ENTITY_EVIS, 10, 22, otherNpc.Position, nilvector, nil)
							local ropeData = mod:GetEntityData(rope)
							rope:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)

							local ropehash = GetPtrHash(rope)
							mod.SewnRopes[ropehash] = rope
							
							rope.Parent = npc
							npcData.FFSewnRopeParent = rope

							local handler = Isaac.Spawn(1000, 1749, 0, npc.Position + (otherNpc.Position - npc.Position):Normalized(), nilvector, nil)
							handler:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
							handler:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
							handler.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
							handler.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
							handler.CollisionDamage = 0
							handler.Visible = false
							mod:GetEntityData(handler).Rope = rope

							rope.Target = handler
							rope.Position = handler.Position

							rope.Child = otherNpc
							otherNpcData.FFSewnRopeChild = rope

							ropeData.FadeInDuration = 10
							ropeData.FadeInDurationMax = 10

							rope:GetSprite():SetFrame(100)
							rope:Update()

							break
						end
					end
				end
			end
		end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
	if effect.SubType == 0 and (mod:GetEntityData(effect).Rope == nil or not mod:GetEntityData(effect).Rope:Exists()) then
		effect:Remove()
	end
end, 1749)

function mod:sewingRopeRender(npc)
	if npc.Variant == 10 and npc.SubType == 22 then
		local data = mod:GetEntityData(npc)
		if not npc.Parent or not npc.Child or not npc.Target then
			-- do nothing
		elseif npc:Exists() then
			if data.FrameCount or npc.FrameCount ~= data.FrameCount then
				data.FrameCount = npc.FrameCount
				data.FadeInDuration = math.max(0, data.FadeInDuration - 1)
			end

			--npc:GetSprite():Play("FadeIn" .. data.FadeInDuration, true)
			npc:GetSprite():Play("FadeIn0", true)
			local location = npc.Child.Position - (npc.Child.Position - npc.Parent.Position) * ((data.FadeInDuration * 2) / (data.FadeInDurationMax * 2))
			npc.Target.Velocity = location - npc.Target.Position
			npc.Target.Visible = false
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.sewingRopeRender, EntityType.ENTITY_EVIS)

function mod:sewingRopeUpdate(npc)
	if npc.Variant == 10 and npc.SubType == 22 then
		return false
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.sewingRopeUpdate, EntityType.ENTITY_EVIS)

function mod:handleSewn(entity, data, sprite)
	data.FFSewnDuration = data.FFSewnDuration - 1

	if data.FFSewnDuration >= 0 then
		entity:SetColor(FiendFolio.StatusEffectColors.Sewn, 1, statusColorPriority, false, false)
	end
end

function FiendFolio.AddSewn(entity, source, duration, isCloned, ignoreRope, damagePercentage)
	if not (entity and entity:ToNPC()) then
		return
	end
	
	if (entity.Type == EntityType.ENTITY_MASK or (entity.Type == EntityType.ENTITY_MASK_OF_INFAMY and entity.Parent)) and not isCloned then
		return
	end
	
	if Isaac.RunCallbackWithParam(ModCallbacks.MC_PRE_STATUS_EFFECT_APPLY, "FFSewn", "FFSewn", entity, EntityRef(source), duration) == false then
		return
	end
	
	if mod:isSegmented(entity) and not isCloned then
		local segments = mod:getSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.AddSewn(segment, source, duration, true, ignoreRope, damagePercentage)
			end
		end
	elseif mod:isBasegameSegmented(entity) and not isCloned then
		local segments = mod:getBasegameSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.AddSewn(segment, source, duration, true, ignoreRope, damagePercentage)
			end
		end
	end

	local data = mod:GetEntityData(entity)
	local isBoss = entity:IsBoss()
	if isBoss and entity:GetBossStatusEffectCooldown() > 0 then
		--do nothing
	elseif not (entity:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) or mod:isStatusBlacklisted(entity) or data.FFIsDeathAnimation or mod:doNotShareHP(entity) or data.eternalFlickerspirited) or 
	       ((entity.Type == EntityType.ENTITY_MASK or entity.Type == EntityType.ENTITY_MASK_OF_INFAMY) and isCloned) 
	then
		data.FFSewnDuration = math.max(data.FFSewnDuration or 0, duration)
		data.FFSewnSource = EntityRef(source)
		data.FFSewnLastHP = entity.HitPoints
		if data.FFSewnIgnoreRope == nil or data.FFSewnIgnoreRope == true then
			data.FFSewnIgnoreRope = (ignoreRope or false)
		end
		data.FFSewnDamagePercentage = math.max(data.FFSewnDamagePercentage or 0, damagePercentage)
		
		if isBoss then
			entity:SetBossStatusEffectCooldown(FiendFolio.StatusEffectVariables.BossStatusResistanceFrameCount)
		end
		
		mod:TrackEnemyStatus(entity, statusflag)
		
		local ptrhash = GetPtrHash(entity)
		mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
		mod.VasculitisInfo[ptrhash][statusflag] = {Source = data.FFSewnSource}
		
		Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_STATUS_EFFECT_APPLY, "FFSewn", "FFSewn", entity, EntityRef(source), duration)
	end
end

function FiendFolio.RemoveSewn(entity, isCloned)
	if mod:isSegmented(entity) and not isCloned then
		local segments = mod:getSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.RemoveSewn(segment, true)
			end
		end
	elseif mod:isBasegameSegmented(entity) and not isCloned then
		local segments = mod:getBasegameSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.RemoveSewn(segment, true)
			end
		end
	end

	local data = mod:GetEntityData(entity)
	data.FFSewnDuration = nil
	data.FFSewnIgnoreRope = nil
	data.FFSewnDamagePercentage = nil
	data.FFSewnLastHP = nil
	mod:UntrackEnemyStatus(entity, statusflag)
	
	if not (entity:IsDead() or entity:HasMortalDamage()) then
		local ptrhash = GetPtrHash(entity)
		mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
		mod.VasculitisInfo[ptrhash][statusflag] = nil
	end
end

function FiendFolio.FlagSew(entity, duration, damagePercentage)
	TearFlagsLib.AddTearFlags(entity, tearflag)
	
	local params = TearFlagsLib.GetTearFlagParams(entity, tearflag)
	TearFlagsLib.SetTearFlagParams(entity, tearflag, {Duration = math.max(params.Duration or 0, duration),
	                                                  DamagePercentage = math.max(params.DamagePercentage or 0, damagePercentage)})
end

function mod:applySewFlag(entity, player, source)
	local params = TearFlagsLib.GetTearFlagParams(source, tearflag)
	FiendFolio.AddSewn(entity, player, params.Duration, nil, nil, params.DamagePercentage)
end
mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, mod.applySewFlag, tearflag)

function mod.handleSewD3(entity)
	local params = TearFlagsLib.GetTearFlagParams(entity, tearflag)
	TearFlagsLib.SetTearFlagParams(entity, tearflag, {Duration = 120,
	                                                  DamagePercentage = 0.5})
end

function mod:sewnOnVasculitis(tear, npc)
	local ptrhash = GetPtrHash(npc)
	mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
	
	local vasculitisInfo = mod.VasculitisInfo[ptrhash][statusflag]
	if vasculitisInfo then
		local source = vasculitisInfo.Source
		local player = source and source.Entity and source.Entity:ToPlayer()
		local secondHandMultiplier = (player and (player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1)) or 1
		FiendFolio.FlagSew(tear, 180 * secondHandMultiplier, 0.5)
	end
end

function mod:sewnOnUpdate(npc, data, sprite, clearingStatus)
	if data.FFSewnDuration ~= nil and data.FFSewnDuration > 0 and not clearingStatus then
		mod:handleSewn(npc, data, sprite)
		data.hasFFStatusIcon = true
	else
		data.FFSewnDuration = nil
		data.FFSewnIgnoreRope = nil
		data.FFSewnDamagePercentage = nil
		data.FFSewnLastHP = nil
		mod:UntrackEnemyStatus(npc, statusflag)
		
		if not (npc:IsDead() or npc:HasMortalDamage()) then
			local ptrhash = GetPtrHash(npc)
			mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
			mod.VasculitisInfo[ptrhash][statusflag] = nil
		end
	end
end

function mod:copySewn(copy, copyData, source, sourceData)
	if not (copyData.FFIsDeathAnimation or mod:doNotShareHP(copy) or copyData.eternalFlickerspirited) then
		copyData.FFSewnDuration = sourceData.FFSewnDuration
		copyData.FFSewnSource = sourceData.FFSewnSource
		copyData.FFSewnLastHP = copy.HitPoints
		copyData.FFSewnIgnoreRope = sourceData.FFSewnIgnoreRope
		copyData.FFSewnDamagePercentage = sourceData.FFSewnDamagePercentage
		
		mod:TrackEnemyStatus(copy, statusflag)
		
		local copyPtrhash = GetPtrHash(copy)
		local sourcePtrhash = GetPtrHash(source)
		mod.VasculitisInfo[copyPtrhash] = mod.VasculitisInfo[copyPtrhash] or {}
		mod.VasculitisInfo[sourcePtrhash] = mod.VasculitisInfo[sourcePtrhash] or {}
		if mod.VasculitisInfo[sourcePtrhash][statusflag] then
			mod.VasculitisInfo[copyPtrhash][statusflag] = {Source = mod.VasculitisInfo[sourcePtrhash][statusflag].Source or copyData.FFSewnSource}
		end
	end
end
