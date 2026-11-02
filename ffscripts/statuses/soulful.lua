-- Soulful --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local statusflag = mod:RegisterEnemyStatusEffect("SOULFUL", 50, "soulfulOnUpdate", {Vasculitis = "soulfulOnVasculitis"})
local tearflag = TearFlagsLib.RegisterTearFlag("SOULFUL")
local statusColorPriority = 122

function mod:handleSoulful(entity, data, sprite)
	data.FFSoulfulDuration = data.FFSoulfulDuration - 1
	if data.FFSoulfulDuration >= 0 then
		entity:SetColor(FiendFolio.StatusEffectColors.Soulful, 1, statusColorPriority, false, false)
	elseif data.FFSoulfulChain then
		data.FFSoulfulChain = nil
	end
end

function FiendFolio.AddSoulful(entity, source, duration, damage, isCloned, sourceRef)
	if not (entity and entity:ToNPC()) then
		return
	end
	
	if (entity.Type == EntityType.ENTITY_MASK or (entity.Type == EntityType.ENTITY_MASK_OF_INFAMY and entity.Parent)) and not isCloned then
		return
	end
	
	if Isaac.RunCallbackWithParam(ModCallbacks.MC_PRE_STATUS_EFFECT_APPLY, "FFSoulful", "FFSoulful", entity, EntityRef(source), duration) == false then
		return
	end
	
	if mod:isSegmented(entity) and not isCloned then
		local segments = mod:getSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.AddSoulful(segment, source, duration, damage, true)
			end
		end
	elseif mod:isBasegameSegmented(entity) and not isCloned then
		local segments = mod:getBasegameSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.AddSoulful(segment, source, duration, damage, true)
			end
		end
	end

	local data = mod:GetEntityData(entity)
	local isBoss = entity:IsBoss()
	if isBoss and entity:GetBossStatusEffectCooldown() > 0 and data.FFSoulfulDuration ~= nil then
		data.FFSoulfulMaxDuration = data.FFSoulfulDuration - 5
	elseif not (entity:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) or mod:isStatusBlacklisted(entity)) or 
	       ((entity.Type == EntityType.ENTITY_MASK or entity.Type == EntityType.ENTITY_MASK_OF_INFAMY) and isCloned) 
	then
		data.FFSoulfulDuration = math.max(data.FFSoulfulDuration or 0, duration)
		data.FFSoulfulMaxDuration = data.FFSoulfulDuration - 5
		data.FFSoulfulDamage = damage
		data.FFSoulfulSource = sourceRef or EntityRef(source)
		
		if isBoss then
			entity:SetBossStatusEffectCooldown(FiendFolio.StatusEffectVariables.BossStatusResistanceFrameCount)
		end
		
		mod:TrackEnemyStatus(entity, statusflag)
		
		local ptrhash = GetPtrHash(entity)
		mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
		mod.VasculitisInfo[ptrhash][statusflag] = {Source = data.FFSoulfulSource}
		
		Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_STATUS_EFFECT_APPLY, "FFSoulful", "FFSoulful", entity, EntityRef(source), duration)
	end
end

function FiendFolio.RemoveSoulful(entity, isCloned)
	if mod:isSegmented(entity) and not isCloned then
		local segments = mod:getSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.RemoveSoulful(segment, true)
			end
		end
	elseif mod:isBasegameSegmented(entity) and not isCloned then
		local segments = mod:getBasegameSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.RemoveSoulful(segment, true)
			end
		end
	end

	local data = mod:GetEntityData(entity)
	data.FFSoulfulDuration = nil
	mod:UntrackEnemyStatus(entity, statusflag)
	
	if not (entity:IsDead() or entity:HasMortalDamage()) then
		local ptrhash = GetPtrHash(entity)
		mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
		mod.VasculitisInfo[ptrhash][statusflag] = nil
	end
end

function mod:soulfulOnDamage(ent, data)
	if data.FFSoulfulDuration ~= nil and data.FFSoulfulDuration > 0 and ent:IsVulnerableEnemy() then
		mod.scheduleForUpdate(function()
			if not data.FFSoulfulSource then
				data.FFSoulfulSource = EntityRef(Isaac.GetPlayer(0))
			end
			--print(data.FFSoulfulDuration, data.FFSoulfulMaxDuration)
			if (
				data.FFSoulfulDuration ~= nil 
				and data.FFSoulfulDuration > 0 
				and ent:IsVulnerableEnemy() 
				and data.FFSoulfulMaxDuration
				and data.FFSoulfulDuration <= data.FFSoulfulMaxDuration
		 	) then
				data.FFSoulfulDuration = 0
				ent:TakeDamage(data.FFSoulfulDamage, 0, data.FFSoulfulSource, 0)
				sfx:Play(mod.Sounds.LookerShoot, 0.8, 0, false, mod:RandomFloat(0.8, 0.9))
				
				local offset = Vector(0, -ent.Size*0.5) + RandomVector() * ent.Size * 0.2
				
				local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, ent.Position, Vector.Zero, nil):ToEffect()
				local poofSprite = poof:GetSprite()
				poofSprite.Color = FiendFolio.StatusEffectColors.Soulful
				poofSprite.Color.A = 0.4
				poofSprite.Color:SetColorize(1, 1, 1, 1)
				poofSprite:Load("gfx/1000.144_enemy ghost.anm2", true)
				poofSprite:Play("Explosion", true)
				poofSprite.Scale = Vector(0.75, 0.75)
				poof:FollowParent(ent)
				poof.ParentOffset = offset
				
				local impact = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.IMPACT, 0, ent.Position, Vector.Zero, nil):ToEffect()
				impact.SpriteScale = Vector(1.4, 1.4)
				impact:FollowParent(ent)
				impact.ParentOffset = offset
				
				--mod:makeEnemyGib(ent)
				ent:SetColor(Color(1,1,1,1,1,1,1), 12, 999, true, true)
				
				if mod:isSegmented(ent) and not mod:isReducedSyncSegment(ent) then
					local segments = mod:getSegments(ent)
					for _,segment in ipairs(segments) do
						mod:GetEntityData(segment).FFSoulfulDuration = 0
					end
				elseif mod:isBasegameSegmented(ent) and not mod:isBasegameReducedSyncSegment(ent) then
					local segments = mod:getBasegameSegments(ent)
					for _,segment in ipairs(segments) do
						mod:GetEntityData(segment).FFSoulfulDuration = 0
					end
				end
				
				if (data.FFSoulfulChain or 0) > 0 then
					FiendFolio.AddSoulful(ent, nil, 5, data.FFSoulfulDamage, nil, data.FFSoulfulSource)
					data.FFSoulfulMaxDuration = 2
					data.FFSoulfulChain = data.FFSoulfulChain - 1
				end
			end
		end, 2)
	end
end

function FiendFolio.FlagSoulful(entity, duration, damage)
	TearFlagsLib.AddTearFlags(entity, tearflag)
	
	local params = TearFlagsLib.GetTearFlagParams(entity, tearflag)
	TearFlagsLib.SetTearFlagParams(entity, tearflag, {Duration = math.max(params.Duration or 0, duration),
	                                                  Damage = math.max(params.Damage or 0, damage)})
end

function mod:applySoulfulFlag(entity, player, source)
	-- need to get these values out first before scheduling cause otherwise they might get eaten by garbage collection
	-- happens with stuff like can of beans
	-- sucks but w/e
	local params = TearFlagsLib.GetTearFlagParams(source, tearflag)
	local duration = params.Duration
	local damage = params.Damage
	
	local ptrhash = GetPtrHash(entity)
	mod.QueuedStatusApply[ptrhash] = mod.QueuedStatusApply[ptrhash] or {}
	table.insert(mod.QueuedStatusApply[ptrhash], function()
		FiendFolio.AddSoulful(entity, player, duration, damage)
	end)
end
mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, mod.applySoulfulFlag, tearflag)

function mod:soulfulOnVasculitis(tear, npc)
	local ptrhash = GetPtrHash(npc)
	mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
	
	local vasculitisInfo = mod.VasculitisInfo[ptrhash][statusflag]
	if vasculitisInfo then
		local source = vasculitisInfo.Source
		--local player = source and source.Entity and source.Entity:ToPlayer()
		--local secondHandMultiplier = (player and (player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1)) or 1
		FiendFolio.FlagSoulful(tear, 300, tear.CollisionDamage)
	end
end

function mod:soulfulOnUpdate(npc, data, sprite, clearingStatus)
	if data.FFSoulfulDuration ~= nil and data.FFSoulfulDuration > 0 and not clearingStatus then
		mod:handleSoulful(npc, data, sprite)
		--data.hasFFStatusIcon = true
	else
		data.FFSoulfulDuration = nil
		mod:UntrackEnemyStatus(npc, statusflag)
	
		if not (npc:IsDead() or npc:HasMortalDamage()) then
			local ptrhash = GetPtrHash(npc)
			mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
			mod.VasculitisInfo[ptrhash][statusflag] = nil
		end
	end
end

function mod:copySoulful(copy, copyData, source, sourceData)
	copyData.FFSoulfulDuration = sourceData.FFSoulfulDuration
	copyData.FFSoulfulSource = sourceData.FFSoulfulSource
	
	mod:TrackEnemyStatus(copy, statusflag)
	
	local copyPtrhash = GetPtrHash(copy)
	local sourcePtrhash = GetPtrHash(source)
	mod.VasculitisInfo[copyPtrhash] = mod.VasculitisInfo[copyPtrhash] or {}
	mod.VasculitisInfo[sourcePtrhash] = mod.VasculitisInfo[sourcePtrhash] or {}
	if mod.VasculitisInfo[sourcePtrhash][statusflag] then
		mod.VasculitisInfo[copyPtrhash][statusflag] = {Source = mod.VasculitisInfo[sourcePtrhash][statusflag].Source or copyData.FFSoulfulSource}
	end
end
