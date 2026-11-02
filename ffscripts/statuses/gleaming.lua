local mod = FiendFolio

local statusflag = mod:RegisterEnemyStatusEffect("GLEAM", 70, "gleamingOnUpdate", {Vasculitis = "gleamingOnVasculitis"})
local tearflag = TearFlagsLib.RegisterTearFlag("GLEAMING")

local GLEAM_RADIUS = 80
local GLEAM_STATUS_TIME = 15

FiendFolio.GleamStatusEffects = {
    BURNING     = 0,
    FEAR        = 1,
    CHARM       = 2,
    SLOWNESS    = 3,
    BRUISED     = 4,
    MUGGED      = 5,
    POISON      = 6,
}

local GleamColor = {
    [mod.GleamStatusEffects.BURNING] 	= Color(1, 195/255, 155/255),
    [mod.GleamStatusEffects.FEAR] 		= Color(200/255, 155/255, 1),
    [mod.GleamStatusEffects.CHARM] 		= Color(1, 180/255, 1),
    [mod.GleamStatusEffects.POISON] 	= Color(85/255, 1, 85/255),
    [mod.GleamStatusEffects.SLOWNESS] 	= Color(0, 0, 0),
    [mod.GleamStatusEffects.BRUISED] 	= Color(100/255, 0, 100/255),
    [mod.GleamStatusEffects.MUGGED] 	= Color(1, 1, 75/255),
}

local GleamStatusToFlag = {
	[mod.GleamStatusEffects.BURNING] = EntityFlag.FLAG_BURN,
	[mod.GleamStatusEffects.FEAR] = EntityFlag.FLAG_FEAR,
	[mod.GleamStatusEffects.CHARM] = EntityFlag.FLAG_CHARM,
	[mod.GleamStatusEffects.POISON] = EntityFlag.FLAG_POISON,
	[mod.GleamStatusEffects.SLOWNESS] = EntityFlag.FLAG_SLOW,
	[mod.GleamStatusEffects.BRUISED] = function (data)
		return not data.FFBruiseInstances or #data.FFBruiseInstances == 0
	end,
	[mod.GleamStatusEffects.MUGGED] = function (data)
		return not data.FFMuggedDuration or data.FFMuggedDuration >= 0
	end
}

function mod:handleGleaming(entity, data, sprite)
    data.FFGleamDuration = data.FFGleamDuration - 1
    if data.FFGleamDuration >= 0 then
        local player = data.FFGleamSource and data.FFGleamSource.Entity and data.FFGleamSource.Entity:ToPlayer()
		if not player then
			player = Isaac.GetPlayer(0)
			data.FFGleamSource = EntityRef(player)
		end
        local sourceRef = data.FFGleamSource

        local statusEffectType = data.FFGleamType
		local hasStatusCheck = GleamStatusToFlag[statusEffectType]

		if hasStatusCheck == nil then
			return
		end
        local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
        local statusTime = GLEAM_STATUS_TIME * secondHandMultiplier

        local offset = Vector(0, -(entity.Size * entity.SizeMulti:Length())/2)
        local hash = GetPtrHash(entity)
		
        for _, nearbyEnt in ipairs(Isaac.FindInRadius(entity.Position + offset, GLEAM_RADIUS, EntityPartition.ENEMY)) do
            if nearbyEnt:IsEnemy()
            and nearbyEnt:IsActiveEnemy()
            and not nearbyEnt:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
            and hash ~= GetPtrHash(nearbyEnt) then
				local nearbyEntData
				-- Check if we can even apply a status
				if type(hasStatusCheck) == "function" then
					if not nearbyEntData then nearbyEntData = mod:GetEntityData(nearbyEnt) end

					if not hasStatusCheck(nearbyEntData) then
						goto continue
					end
				elseif nearbyEnt:HasEntityFlags(hasStatusCheck) then
					goto continue
				end
				
				-- Inflict status effecst depending on aura
                if statusEffectType == mod.GleamStatusEffects.BURNING then
                    nearbyEnt:AddBurn(sourceRef, statusTime, player.Damage * 2)
                elseif statusEffectType == mod.GleamStatusEffects.FEAR then
                    nearbyEnt:AddFear(sourceRef, statusTime)
                elseif statusEffectType == mod.GleamStatusEffects.CHARM then
                    nearbyEnt:AddCharmed(sourceRef, statusTime)
                elseif statusEffectType == mod.GleamStatusEffects.POISON then
                    nearbyEnt:AddPoison(sourceRef, statusTime, player.Damage * 2)
                elseif statusEffectType == mod.GleamStatusEffects.SLOWNESS then
                    nearbyEnt:AddSlowing(sourceRef, statusTime, 0.5, mod.ColorNormal)
                elseif statusEffectType == mod.GleamStatusEffects.MUGGED then
                    mod.AddMugged(nearbyEnt, player, statusTime)
                elseif statusEffectType == mod.GleamStatusEffects.BRUISED then
					-- Only use GetData if not done before
					if not nearbyEntData then nearbyEntData = mod:GetEntityData(nearbyEnt) end

                    -- Don't apply Bruised more than once
                    if not nearbyEntData.FFBruiseInstances or #nearbyEntData.FFBruiseInstances == 0 then
                        mod.AddBruise(nearbyEnt, player, statusTime, 1, 1)
                    end
                end

				::continue::
            end
        end
    end
end

function mod.AddGleaming(entity, source, duration, statusType, isCloned)
	if not (entity and entity:ToNPC()) then
		return
	end
	
	if (entity.Type == EntityType.ENTITY_MASK or (entity.Type == EntityType.ENTITY_MASK_OF_INFAMY and entity.Parent)) and not isCloned then
		return
	end
	
	if Isaac.RunCallbackWithParam(ModCallbacks.MC_PRE_STATUS_EFFECT_APPLY, "FFGleaming", "FFGleaming", entity, EntityRef(source), duration) == false then
		return
	end
	
	if mod:isSegmented(entity) and not isCloned then
		local segments = mod:getSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				mod.AddGleaming(segment, source, duration, statusType, true)
			end
		end
	elseif mod:isBasegameSegmented(entity) and not isCloned then
		local segments = mod:getBasegameSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				mod.AddGleaming(segment, source, duration, statusType, true)
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
		data.FFGleamDuration = math.max(data.FFGleamDuration or 0, duration)
		data.FFGleamSource = EntityRef(source)

        local forcedStatusType = statusType ~= nil and statusType or nil
        statusType = statusType or mod:RandomInt(0, 6)

        -- Set the status type the Gleaming aura uses
        data.FFGleamType = statusType

        -- If the aura's type is predetermined, also set it here.
        data.FFGleamTypeForced = forcedStatusType

        data.FFGleamAura = EntityPtr(mod:CreateGleamAura(statusType, entity))

		if isBoss then
			entity:SetBossStatusEffectCooldown(FiendFolio.StatusEffectVariables.BossStatusResistanceFrameCount)
		end

		mod:TrackEnemyStatus(entity, statusflag)

		local ptrhash = GetPtrHash(entity)
		mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
		mod.VasculitisInfo[ptrhash][statusflag] = {
            Source = data.FFGleamSource,
            ForceStatusType = data.FFGleamTypeForced
        }
		
		Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_STATUS_EFFECT_APPLY, "FFGleaming", "FFGleaming", entity, EntityRef(source), duration)
	end
end

function mod.RemoveGleaming(entity, isCloned)
	if mod:isSegmented(entity) and not isCloned then
		local segments = mod:getSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				mod.RemoveGleaming(segment, true)
			end
		end
	elseif mod:isBasegameSegmented(entity) and not isCloned then
		local segments = mod:getBasegameSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				mod.RemoveGleaming(segment, true)
			end
		end
	end

	local data = mod:GetEntityData(entity)
    data.FFGleamDuration = nil
	data.FFGleamType = nil
    data.FFGleamTypeForced = nil

    if data.FFGleamAura and data.FFGleamAura.Ref then
        data.FFGleamAura.Ref:GetSprite():Play("Disappear", true)
    end

    data.FFGleamAura = nil
    
	mod:UntrackEnemyStatus(entity, statusflag)
	
	if not (entity:IsDead() or entity:HasMortalDamage()) then
		local ptrhash = GetPtrHash(entity)
		mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
		mod.VasculitisInfo[ptrhash][statusflag] = nil
	end
end

function FiendFolio.FlagGleaming(entity, duration, forceStatusType)
	TearFlagsLib.AddTearFlags(entity, tearflag)
	
	local params = TearFlagsLib.GetTearFlagParams(entity, tearflag)
	TearFlagsLib.SetTearFlagParams(entity, tearflag, {Duration = math.max(params.Duration or 0, duration),
                                                      ForceStatusType = forceStatusType})
end

function mod:applyGleamingFlag(entity, player, source)
	local data = mod:GetEntityData(source)
    local entityData = mod:GetEntityData(entity)
	if not entityData.FFGleamDuration then	
		local params = TearFlagsLib.GetTearFlagParams(source, tearflag)
        mod.AddGleaming(entity, player, params.Duration, params.ForceStatusType)
    end
end
mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, mod.applyGleamingFlag, tearflag)

function mod.handleGleamingD3(entity)
	local params = TearFlagsLib.GetTearFlagParams(entity, tearflag)
	local chosenStatus = params.ForceStatusType or (math.random(7) - 1)
	TearFlagsLib.SetTearFlagParams(entity, tearflag, {Duration = math.max(params.Duration or 0, 150),
                                                      ForceStatusType = chosenStatus})
	if entity.Type == EntityType.ENTITY_TEAR then
		mod:CreateGleamAura(chosenStatus, entity)
	end
end

function mod:gleamingOnVasculitis(tear, npc)
	local ptrhash = GetPtrHash(npc)
	mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
	
	local vasculitisInfo = mod.VasculitisInfo[ptrhash][statusflag]
	if vasculitisInfo then
		local source = vasculitisInfo.Source
		local player = source and source.Entity and source.Entity:ToPlayer()
		local secondHandMultiplier = (player and (player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1)) or 1
		FiendFolio.FlagGleaming(tear, 150 * secondHandMultiplier)
	end
end

function mod:gleamingOnUpdate(npc, data, sprite, clearingStatus)
	if data.FFGleamDuration ~= nil and data.FFGleamDuration > 0 and not clearingStatus then
		mod:handleGleaming(npc, data, sprite)
		--data.hasFFStatusIcon = true
	else
        
        data.FFGleamDuration = nil
        data.FFGleamType = nil
        data.FFGleamTypeForced = nil
        
        if data.FFGleamAura and data.FFGleamAura.Ref then
            data.FFGleamAura.Ref:GetSprite():Play("Disappear")
        end
        
        data.FFGleamAura = nil
        mod:UntrackEnemyStatus(npc, statusflag)
		
		if not (npc:IsDead() or npc:HasMortalDamage()) then
			local ptrhash = GetPtrHash(npc)
			mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
			mod.VasculitisInfo[ptrhash][statusflag] = nil
		end
	end
end

function mod:copyGleaming(copy, copyData, source, sourceData)
	copyData.FFGleamDuration = sourceData.FFGleamDuration
	copyData.FFGleamSource = sourceData.FFGleamSource
    copyData.FFGleamType = sourceData.FFGleamType
    copyData.FFGleamTypeForced = sourceData.FFGleamTypeForced
	
	mod:TrackEnemyStatus(copy, statusflag)
	
	local copyPtrhash = GetPtrHash(copy)
	local sourcePtrhash = GetPtrHash(source)
	mod.VasculitisInfo[copyPtrhash] = mod.VasculitisInfo[copyPtrhash] or {}
	mod.VasculitisInfo[sourcePtrhash] = mod.VasculitisInfo[sourcePtrhash] or {}
	if mod.VasculitisInfo[sourcePtrhash][statusflag] then
		mod.VasculitisInfo[copyPtrhash][statusflag] = {
            Source = mod.VasculitisInfo[sourcePtrhash][statusflag].Source or copyData.FFGleamSource,
            ForceStatusType = mod.VasculitisInfo[sourcePtrhash][statusflag].ForceStatusType or copyData.FFGleamTypeForced,
        }
	end
end

function mod:CreateGleamAura(statusEffectType, entity)
	local aura = Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.FFID.Effect, mod.FF.GleamAura.Sub, entity.Position, Vector.Zero, entity)

    aura.Color = GleamColor[statusEffectType]
    aura:ToEffect():FollowParent(entity)

    aura.Size = entity.Type == EntityType.ENTITY_TEAR and 30 or GLEAM_RADIUS
    aura.DepthOffset = -100

	aura:GetSprite():Play("Appear")
    aura:Update()

    return aura
end
	
function mod:handleGleamAura(effect)
	if effect.SubType ~= FiendFolio.FF.GleamAura.Sub then return end

    local sprite = effect:GetSprite()
    local parent = effect.Parent

    if sprite:IsFinished("Disappear") then
        effect:Remove()
        return
    end

	if not parent then
		if not sprite:IsPlaying("Disappear") then
			sprite:Play("Disappear", true)
		end

		return
	end

	if sprite:IsFinished("Appear") then
		sprite:Play("Idle")
	end

	-- Size the aura
	local scale = effect.Size / 80
	effect.SpriteScale = Vector.One * scale

    -- Position the aura
    local offset = Vector.Zero
    if parent.Type ~= EntityType.ENTITY_TEAR then
        offset = Vector(0, -(parent.Size * parent.SizeMulti:Length())/2)
    end
    effect.SpriteOffset = offset
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.handleGleamAura, FiendFolio.FF.GleamAura.Var)