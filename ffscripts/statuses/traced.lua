local mod = FiendFolio
local statusFlag = mod:RegisterEnemyStatusEffect("TRACED", 0, "tracedOnUpdate", {HasIcon = true, Vasculitis = "tracedOnVasculitis"})
local afterimage = {mod.FF.HardlightAfterimage.ID, mod.FF.HardlightAfterimage.Var, 0}
local AFTERIMAGE_COLOUR = Color(0, 0.75, 1, 0.35, 0.5, 0.5, 0.5, 0.75, 0.75, 0.75)
local AFTERIMAGE_FADEOUT = Color(0, 0.75, 1, 0, 0.5, 0.5, 0.5, 0.75, 0.75, 0.75)

local function canEntityGetStatusesFromSegment(entity, fromClone)
	return fromClone and (entity.Type == EntityType.ENTITY_MASK or (entity.Type == EntityType.ENTITY_MASK_OF_INFAMY and entity.Parent))
end

local function shouldSkipAddStatusEffect(entity, fromClone)
	return (
		not entity
		or not entity:ToNPC()
		or (entity:IsBoss() and entity:GetBossStatusEffectCooldown() > 0)
		or (entity:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) and not canEntityGetStatusesFromSegment(entity, fromClone))
		or mod:isStatusBlacklisted(entity)
	)
end

local function checkSegmentedEntity(entity, toCall, ...)
	local segments = mod:agnosticGetSegments(entity)
	for _, segment in pairs(segments or {}) do
		if not TearFlagsLib.AreEntitiesSame(entity, segment) then
			toCall(segment, table.unpack({...}))
		end
	end
end

function mod.AddTracedStatus(entity, duration, fromClone)
	if Isaac.RunCallbackWithParam(ModCallbacks.MC_PRE_STATUS_EFFECT_APPLY, "FFTraced", "FFTraced", entity, EntityRef(source), duration) == false then
		return
	end
	
	if shouldSkipAddStatusEffect(entity, fromClone) then return end
	if not fromClone and mod:agnosticIsSegmented(entity) then checkSegmentedEntity(entity, mod.AddTracedStatus, duration, true) end

	if entity:IsBoss() then
		entity:SetBossStatusEffectCooldown(FiendFolio.StatusEffectVariables.BossStatusResistanceFrameCount)
	end

	local data = mod:GetEntityData(entity)
	data.FFTracedStatus = data.FFTracedStatus or {Start = entity.FrameCount}
	data.FFTracedStatus.Duration = duration


	mod:TrackEnemyStatus(entity, statusFlag)

	local key = GetPtrHash(entity)
	mod.VasculitisInfo[key] = mod.VasculitisInfo[key] or {}
	mod.VasculitisInfo[key][statusFlag] = duration
		
	Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_STATUS_EFFECT_APPLY, "FFTraced", "FFTraced", entity, EntityRef(source), duration)
end

function mod.RemovedTracedStatus(entity, fromClone)
	if not fromClone and mod:agnosticIsSegmented(entity) then checkSegmentedEntity(entity, mod.RemovedTracedStatus, true) end

	mod:UntrackEnemyStatus(entity, statusFlag)
	mod:GetEntityData(entity).FFTracedStatus = nil

	if not (entity:IsDead() or entity:HasMortalDamage()) then
		local key = GetPtrHash(entity)
		mod.VasculitisInfo[key] = mod.VasculitisInfo[key] or {}
		mod.VasculitisInfo[key][statusFlag] = nil
	end
end

function mod:tracedOnUpdate(npc, data, sprite, clearingStatus)
	if not data.FFTracedStatus or npc:IsDead() or npc:HasMortalDamage() then
		mod.RemovedTracedStatus(npc)
		return
	end

	if npc.Visible and (npc.FrameCount - data.FFTracedStatus.Start) % 12 == 6 then
		local ghost = Isaac.Spawn(afterimage[1], afterimage[2], afterimage[3], npc.Position, Vector.Zero, npc):ToNPC()
		ghost.Parent = npc
		ghost.MaxHitPoints = npc.MaxHitPoints
		ghost.Color = AFTERIMAGE_COLOUR
		ghost.FlipX = npc.FlipX
		ghost.Scale = npc.Scale
		ghost.SpriteScale = npc.SpriteScale
		ghost.SpriteRotation = npc.SpriteRotation
		ghost.Size = npc.Size

		ghost:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		ghost:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_SPRITE_UPDATE | EntityFlag.FLAG_NO_PLAYER_CONTROL | EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_REWARD)
		ghost.EntityCollisionClass = math.min(EntityCollisionClass.ENTCOLL_PLAYEROBJECTS, npc.EntityCollisionClass)
		ghost.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE

		local npcSprite = npc:GetSprite()
		local ghostSprite = ghost:GetSprite()
		ghostSprite:Load(npcSprite:GetFilename(), true)

		for _, layer in pairs(npcSprite:GetAllLayers()) do
			local gfxPath = layer:GetSpritesheet():GetName()
			ghostSprite:ReplaceSpritesheet(layer:GetLayerID(), string.sub(gfxPath, string.find(gfxPath, "gfx/"), #gfxPath))
		end

		ghostSprite:LoadGraphics()
		ghostSprite:SetFrame(npcSprite:GetAnimation(), npcSprite:GetFrame())
		ghostSprite:SetOverlayFrame(npcSprite:GetOverlayAnimation(), npcSprite:GetOverlayFrame())

		TearFlagsLib.AddEntityToUpdateList(ghost, "FF_KALUS_EYE_AFTERIMAGE")
	end

	data.FFTracedStatus.Duration = data.FFTracedStatus.Duration - 1
	if data.FFTracedStatus.Duration <= 0 or clearingStatus then
		mod.RemovedTracedStatus(npc)
		return
	end
end

function mod:tracedOnVasculitis(tear, npc)
	local key = GetPtrHash(npc)
	if mod.VasculitisInfo[key] and mod.VasculitisInfo[key][statusFlag] then
		TearFlagsLib.AddTearFlags(tear, TearFlagsLib.Flag.FF_KALUS_EYE)
		TearFlagsLib.SetTearFlagParams(tear, TearFlagsLib.Flag.FF_KALUS_EYE, {
			Duration = mod.VasculitisInfo[key][statusFlag]
		})
	end
end

--[[mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, npc)
	if npc.Variant ~= afterimage[2] then return end

	npc

end, afterimage[1])]]

local function shouldAfterImageDisappear(entity)
	return (
		not entity.Parent
		or entity.Parent:IsDead()
		or entity.Parent:HasMortalDamage()
		or mod:isStatusCorpse(entity.Parent)
	)
end

mod:AddCallback(TearFlagsLib.Callback.UPDATE_ENTITY_LIST, function(_, entity)
	entity.HitPoints = entity.MaxHitPoints

	if shouldAfterImageDisappear(entity) then return entity:Remove() end

	local parentData = mod:GetEntityData(entity.Parent)
	if not parentData.FFTracedStatus then return entity:Remove() end

	local lifespan = math.min(45 - entity.FrameCount, mod:GetEntityData(entity.Parent).FFTracedStatus.Duration)
	if lifespan <= 0 then return entity:Remove() end

	--[[if lifespan < 15 then
		entity.Visible = lifespan % 4 < 2
	end]]

	if lifespan < 15 then
		entity.Color = Color.Lerp(entity.Color, AFTERIMAGE_FADEOUT, 0.13)
	else
		entity.Color = AFTERIMAGE_COLOUR
	end
end, "FF_KALUS_EYE_AFTERIMAGE")

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, amount, flags, source, cooldown, extraSource)
	if entity.Variant ~= afterimage[2] or not entity.Parent then return end
	if entity:ToNPC().I1 == entity.FrameCount then return end

	local realSource = (extraSource and extraSource.Entity) or (source and source.Entity)
	local isTearFlagsLibWeapon = TearFlagsLib.EstimateWeaponFlagFromEntity(realSource) ~= nil
	entity:ToNPC().I1 = entity.FrameCount

	if isTearFlagsLibWeapon then
		TearFlagsLib.DamageEntity(entity.Parent, amount, flags, realSource, {
			DamageSource = source and source.Entity,
			DamageCooldown = cooldown,
		})

		local player = TearFlagsLib.GetTearPlayer(realSource)
		local vanillaFlags = TearFlagsLib.AgnosticGetVanillaTearFlags(realSource)
		local vanillaParams = TearFlagsLib.GetCustomVanillaTearFlagParams(realSource)

		TearFlagsLib.ApplyWeaponTearFlags(entity.Parent, player, realSource, TearFlagsLib.EstimateWeaponFlagFromEntity(realSource), true)
		TearFlagsLib.ApplyVanillaTearFlagEffectsToEntity(entity.Parent, vanillaFlags, player, realSource, TearFlagsLib.FuzzyReplaceTable({DamageOverride = source.CollisionDamage}, vanillaParams))
	else
		entity.Parent:TakeDamage(amount, flags, source, cooldown)
	end

	return false
end, afterimage[1])

mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, function(_, npc, collider, low)
	if npc.Variant == afterimage[2] and collider.Type == EntityType.ENTITY_PLAYER then
		return true
	end
end, afterimage[1])

mod:AddCallback(TearFlagsLib.Callback.PRE_APPLY_TEARFLAG_EFFECTS, function(_, entity)
	if entity.Variant == afterimage[2] then
		return true
	end
end, afterimage[1])