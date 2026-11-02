-- Festering --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local statusflag = mod:RegisterEnemyStatusEffect("FESTERING", 40, "festeringOnUpdate", {Vasculitis = "festeringOnVasculitis"})
local tearflag = TearFlagsLib.RegisterTearFlag("FESTERING")
local statusColorPriority = 998

function mod:handleFestering(entity, data, sprite)
	data.FFFesteringDuration = data.FFFesteringDuration - 1
	local source = data.FFFesteringSource and data.FFFesteringSource.Entity
	if not (source and source:Exists()) then
		source = Isaac.GetPlayer(0)
	end
	local player = source:ToPlayer()
	if not player then
		player = Isaac.GetPlayer(0)
	end
	if data.FFFesteringDuration % 30 == 0 then
		local rng = entity:GetDropRNG()
		local fly = Isaac.Spawn(3, FamiliarVariant.BLUE_FLY, 0, entity.Position, (source.Position-entity.Position):Resized(5):Rotated(mod:RandomInt(-20,20,rng)), source):ToFamiliar()
		fly.Player = player
		fly.TargetPosition = source.Position
		fly.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		mod:GetEntityData(fly).IgnoreForAMoment = 30
		fly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	end
	if data.FFFesteringDuration >= 0 then
		entity:SetColor(FiendFolio.StatusEffectColors.Festering, 1, statusColorPriority, false, false)
	end
end

function FiendFolio.AddFestering(entity, source, duration, isCloned)
	if not (entity and entity:ToNPC()) then
		return
	end

	if (entity.Type == EntityType.ENTITY_MASK or (entity.Type == EntityType.ENTITY_MASK_OF_INFAMY and entity.Parent)) and not isCloned then
		return
	end
	
	if Isaac.RunCallbackWithParam(ModCallbacks.MC_PRE_STATUS_EFFECT_APPLY, "FFFestering", "FFFestering", entity, EntityRef(source), duration) == false then
		return
	end

	if mod:isSegmented(entity) and not isCloned then
		local segments = mod:getSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.AddFestering(segment, source, duration, true)
			end
		end
	elseif mod:isBasegameSegmented(entity) and not isCloned then
		local segments = mod:getBasegameSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.AddFestering(segment, source, duration, true)
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
		data.FFFesteringDuration = math.max(data.FFFesteringDuration or 0, duration)
		data.FFFesteringSource = EntityRef(source)
		
		if isBoss then
			entity:SetBossStatusEffectCooldown(FiendFolio.StatusEffectVariables.BossStatusResistanceFrameCount)
		end
		
		mod:TrackEnemyStatus(entity, statusflag)
		
		local ptrhash = GetPtrHash(entity)
		mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
		mod.VasculitisInfo[ptrhash][statusflag] = {Source = data.FFFesteringSource}
		
		Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_STATUS_EFFECT_APPLY, "FFFestering", "FFFestering", entity, EntityRef(source), duration)
	end
end

function FiendFolio.RemoveFestering(entity, isCloned)
	if mod:isSegmented(entity) and not isCloned then
		local segments = mod:getSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.RemoveFestering(segment, true)
			end
		end
	elseif mod:isBasegameSegmented(entity) and not isCloned then
		local segments = mod:getBasegameSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.RemoveFestering(segment, true)
			end
		end
	end

	local data = mod:GetEntityData(entity)
	data.FFFesteringDuration = nil
	mod:UntrackEnemyStatus(entity, statusflag)
	
	if not (entity:IsDead() or entity:HasMortalDamage()) then
		local ptrhash = GetPtrHash(entity)
		mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
		mod.VasculitisInfo[ptrhash][statusflag] = nil
	end
end

function FiendFolio.FlagFestering(entity, duration)
	TearFlagsLib.AddTearFlags(entity, tearflag)
	
	local params = TearFlagsLib.GetTearFlagParams(entity, tearflag)
	TearFlagsLib.SetTearFlagParams(entity, tearflag, {Duration = math.max(params.Duration or 0, duration)})
end

function mod:applyFesteringFlag(entity, player, source)
	local data = mod:GetEntityData(source)
	local params = TearFlagsLib.GetTearFlagParams(source, tearflag)
	FiendFolio.AddFestering(entity, player, params.Duration)
end
mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, mod.applyFesteringFlag, tearflag)

function mod.handleFesteringD3(entity)
	local params = TearFlagsLib.GetTearFlagParams(entity, tearflag)
	TearFlagsLib.SetTearFlagParams(entity, tearflag, {Duration = math.max(params.Duration or 0, 91)})
end

function mod:festeringOnVasculitis(tear, npc)
	local ptrhash = GetPtrHash(npc)
	mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
	
	local vasculitisInfo = mod.VasculitisInfo[ptrhash][statusflag]
	if vasculitisInfo then
		local source = vasculitisInfo.Source
		--local player = source and source.Entity and source.Entity:ToPlayer()
		--local secondHandMultiplier = (player and (player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1)) or 1
		FiendFolio.FlagFestering(tear, 91)
	end
end

function mod:festeringOnUpdate(npc, data, sprite, clearingStatus)
	if data.FFFesteringDuration ~= nil and data.FFFesteringDuration > 0 and not clearingStatus then
		mod:handleFestering(npc, data, sprite)
		--data.hasFFStatusIcon = true
	else
		data.FFFesteringDuration = nil
		mod:UntrackEnemyStatus(npc, statusflag)
		
		if not (npc:IsDead() or npc:HasMortalDamage()) then
			local ptrhash = GetPtrHash(npc)
			mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
			mod.VasculitisInfo[ptrhash][statusflag] = nil
		end
	end
end

function mod:copyFestering(copy, copyData, source, sourceData)
	copyData.FFFesteringDuration = sourceData.FFFesteringDuration
	copyData.FFFesteringSource = sourceData.FFFesteringSource
	
	mod:TrackEnemyStatus(copy, statusflag)
	
	local copyPtrhash = GetPtrHash(copy)
	local sourcePtrhash = GetPtrHash(source)
	mod.VasculitisInfo[copyPtrhash] = mod.VasculitisInfo[copyPtrhash] or {}
	mod.VasculitisInfo[sourcePtrhash] = mod.VasculitisInfo[sourcePtrhash] or {}
	if mod.VasculitisInfo[sourcePtrhash][statusflag] then
		mod.VasculitisInfo[copyPtrhash][statusflag] = {Source = mod.VasculitisInfo[sourcePtrhash][statusflag].Source or copyData.FFFesteringSource}
	end
end

-- Rendering a swarm of flies above affected targets
local FLY_SPRITE = Sprite()
FLY_SPRITE:Load("gfx/1000.033_tiny fly.anm2", true)
FLY_SPRITE:Play("Idle", true)
if FLY_SPRITE:GetLayer(1) then
	FLY_SPRITE:GetLayer(1):SetVisible(false)
end
FLY_SPRITE.Offset = Vector(0, 10)

function FiendFolio:RenderFesteringFlies(entity, renderOffset, d)
	if not entity or not d.FFFesteringDuration or d.FFFesteringDuration <= 0
			or not entity:GetSprite():GetNullFrame("OverlayEffect") or not entity:GetSprite():GetNullFrame("OverlayEffect"):IsVisible() then
		return
	end

	if not d.ffFesteringFlies then
		d.ffFesteringFlies = {}
	end
	local flies = d.ffFesteringFlies

	for i=1,20 do
		if not flies[i] then
			flies[i] = {
				Pos = Vector.Zero,
				Vel = RandomVector(),
			}
		end
		
		local turnStrength = 0.075
		local pullStrength = 0.075
		
		if not game:IsPaused() then
			flies[i].Vel = flies[i].Vel:Rotated(mod.RotateTowardsTarget(flies[i].Vel:GetAngleDegrees(), (-flies[i].Pos):GetAngleDegrees(), turnStrength)) + RandomVector()
			flies[i].Vel = mod:Lerp(flies[i].Vel, -flies[i].Pos:Normalized(), pullStrength)
			flies[i].Pos = flies[i].Pos + flies[i].Vel
		end
		local targetPos = entity.Position + entity:GetNullOffset("OverlayEffect") + flies[i].Pos
		FLY_SPRITE:SetFrame((game:GetFrameCount() + i) % 2)
		FLY_SPRITE.FlipX = flies[i].Vel.X < 0
		FLY_SPRITE:Render(Isaac.WorldToScreen(targetPos) + renderOffset - game:GetRoom():GetRenderScrollOffset())
	end
end
