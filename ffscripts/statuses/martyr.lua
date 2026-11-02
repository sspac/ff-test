-- Martyr --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero
local flagsManager = TearFlagsLib

local statusflag = mod:RegisterEnemyStatusEffect("MARTYR", 1020, "martyrOnUpdate", {Vasculitis = "martyrOnVasculitis"})
local tearflag = TearFlagsLib.RegisterTearFlag("MARTYR")

local preventingDeathEffects = false
mod:AddPriorityCallback(ModCallbacks.MC_PRE_NPC_UPDATE, -1 * math.huge, function(_, npc)
	if preventingDeathEffects then return true end
end)

mod.WasMartyrGhost = {}
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, entity)
	if entity.SubType == 920 then
		local data = mod:GetEntityData(entity)
		
		data.FFMartyrDuration = data.FFMartyrDuration - 1
		if data.FFMartyrDuration <= 0 then
			local ptrhash
			if data.FFMartyrOriginalType then
				-- morph the martyr back to the original enemy and make the game remove them so cultists actually work
				preventingDeathEffects = true
				entity:Morph(data.FFMartyrOriginalType, data.FFMartyrOriginalVariant, data.FFMartyrOriginalSubType, -1)
				ptrhash = GetPtrHash(entity)
				mod.WasMartyrGhost[ptrhash] = true
				entity.State = 17
				entity:Update()
				if entity:Exists() then
					entity:GetSprite():SetFrame(999)
					entity:Update()
				end
				preventingDeathEffects = false
			end
			entity:Remove()
			if ptrhash then
				mod.WasMartyrGhost[ptrhash] = false
			end
			return
		end

		mod:removeStatusEffects(entity, true)

		entity.Position = data.FFMartyrPosition
		entity.Velocity = nilvector

		entity:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_HIDE_HP_BAR |
							  EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_DEATH_TRIGGER |
							  EntityFlag.FLAG_NO_SPIKE_DAMAGE | EntityFlag.FLAG_NO_FLASH_ON_DAMAGE |
							  EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)

		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
		entity.CollisionDamage = 0
		entity:ToNPC().CanShutDoors = false

		local martyrColor = FiendFolio.StatusEffectColors.Martyr
		local color = Color(martyrColor.R, martyrColor.G, martyrColor.B, martyrColor.A, martyrColor.RO, martyrColor.GO, martyrColor.BO)
		if data.FFMartyrDuration > 0 then
			color.A = math.min(color.A, color.A * math.log(data.FFMartyrDuration) / math.log(120))
		else
			color.A = 0
		end

		data.FFMartyrFlashDuration = data.FFMartyrFlashDuration - 1
		if data.FFMartyrFlashDuration > 0 then
			color = Color.Lerp(color, FiendFolio.StatusEffectColors.MartyrFlash, math.log(data.FFMartyrFlashDuration) / math.log(data.FFMartyrFlashDurationMax))
		end

		data.FFMartyrColor = color
		data.FFMartyrScale = data.FFMartyrScale or entity.SpriteScale

		if data.FFOriginalSpriteOffset == nil then
			data.FFOriginalSpriteOffset = Vector(entity.SpriteOffset.X, entity.SpriteOffset.Y)
		end
		entity.SpriteOffset = data.FFOriginalSpriteOffset + Vector(0, 2 * math.cos(math.rad((data.FFMartyrDurationMax - data.FFMartyrDuration) * 2)) - 2)

		if data.MartyrAura == nil then
			data.MartyrAura = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HALLOWED_GROUND, 0, entity.Position, nilvector, data.FFMartyrSource and data.FFMartyrSource.Entity or Isaac.GetPlayer(0)):ToEffect()
			data.MartyrAura.Parent = entity
			data.MartyrAura.DepthOffset = 1000
			data.MartyrAura:GetSprite().Scale = Vector(entity.Size * FiendFolio.StatusEffectVariables.MartyrAuraScalePerSize, entity.Size * FiendFolio.StatusEffectVariables.MartyrAuraScalePerSize)
			data.MartyrAura:Update()
		end

		local players = Isaac.FindInRadius(entity.Position, 80.0 * entity.Size * FiendFolio.StatusEffectVariables.MartyrAuraScalePerSize, EntityPartition.PLAYER)
		for _, player in ipairs(players) do
			local player = player:ToPlayer()
			if player then
				local pdata = mod:GetEntityData(player)
				pdata.FFInMartyrAura = 4

				local hasBasegameAura = player:GetHallowedGroundCountdown() > 0
				local hasMartyrAura = true

				if pdata.FFIsInMartyrAura == nil or pdata.FFIsInHallowAura == nil or
				   pdata.FFIsInMartyrAura ~= hasMartyrAura or
				   (pdata.FFIsInMartyrAura and pdata.FFIsInHallowAura ~= hasBasegameAura) 
				then
					pdata.FFIsInHallowAura = hasBasegameAura
					pdata.FFIsInMartyrAura = hasMartyrAura
					player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_TEARFLAG | CacheFlag.CACHE_TEARCOLOR)
					player:EvaluateItems()
				else
					pdata.FFIsInHallowAura = hasBasegameAura
					pdata.FFIsInMartyrAura = hasMartyrAura
				end
			end
		end
	end
end, EntityType.ENTITY_FROZEN_ENEMY)

mod:AddCallback(ModCallbacks.MC_PRE_NPC_RENDER, function(_, entity)
	if entity.SubType == 920 then
		local data = mod:GetEntityData(entity)
		local sprite = entity:GetSprite()
		
		sprite.Color = data.FFMartyrColor or sprite.Color
		sprite.Scale = data.FFMartyrScale or sprite.Scale
	end
end, EntityType.ENTITY_FROZEN_ENEMY)

function mod:MartyrTakeDmg(entity, data)
	if data.FFMartyrDuration ~= nil then
		return false
	end
end

function mod:spawnSubstituteMartyr(entity, data, sprite, handleDeath)
	if mod:isMartyrWhitelisted(entity) or not (mod:isMartyrBlacklisted(entity) or mod:isStatusBlacklisted(entity)) then
		local substitute = Isaac.Spawn(EntityType.ENTITY_FROZEN_ENEMY, 0, 920, entity.Position, nilvector, nil):ToNPC()
		substitute:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		substitute:PlaySound(SoundEffect.SOUND_DIVINE_INTERVENTION, 1, 0, false, 1 + (0.05 * math.random() - 0.025))
		
		local subdata = mod:GetEntityData(substitute)

		subdata.FFMartyrDuration = data.FFMartyrDurationToSet
		subdata.FFMartyrDurationMax = data.FFMartyrDurationToSet

		subdata.FFMartyrFlashDuration = 15
		subdata.FFMartyrFlashDurationMax = 15

		subdata.FFMartyrPosition = entity.Position
		subdata.FFMartyrSource = data.FFMartyrOnDeathSource
		
		if handleDeath then
			local npc = entity:ToNPC()
			subdata.FFMartyrOriginalType = entity.Type
			subdata.FFMartyrOriginalVariant = entity.Variant
			subdata.FFMartyrOriginalSubType = entity.SubType
		end

		local filename = sprite:GetFilename()
		local animation = sprite:GetAnimation()
		local frame = sprite:GetFrame()

		local overlayAnimation = sprite:GetOverlayAnimation()
		local overlayFrame = sprite:GetOverlayFrame()

		local flipX = sprite.FlipX
		local flipY = sprite.FlipY
		local offset = sprite.Offset
		local rotation = sprite.Rotation
		local scale = Vector(sprite.Scale.X, sprite.Scale.Y)
		
		local subsprite = substitute:GetSprite()
		subsprite:Load(filename, true)
		subsprite:SetFrame(animation, frame)
		subsprite:SetOverlayFrame(overlayAnimation, overlayFrame)

		subsprite.FlipX = flipX
		subsprite.FlipY = flipY
		subsprite.Offset = offset
		subsprite.Rotation = rotation
		subsprite.Scale = scale

		subdata.FFMartyrScale = scale
		
		substitute.PositionOffset = entity.PositionOffset

		mod:MartyrCompatibilities(entity, substitute)
		substitute:Update()
	end
end

function mod:handleMartyrOnDeath(entity, data, sprite)
	if not data.FFForceMartyrOnDeath then
		data.FFMartyrOnDeathDuration = data.FFMartyrOnDeathDuration - 1
	end

	if (entity:IsDead() or entity:HasMortalDamage() or mod:basegameSegmentHasMortalDamage(entity)) and not (data.FFBerserkDuration ~= nil and data.FFBerserkDuration >= 0) then
		if mod:checkIfStatusLogicIsApplied(entity, false) then
			local hasUranus = entity:HasEntityFlags(EntityFlag.FLAG_ICE)
			mod:spawnSubstituteMartyr(entity, data, sprite, not hasUranus)
			
			if not data.FFMartyrOnDeathSource then
				data.FFMartyrOnDeathSource = EntityRef(Isaac.GetPlayer(0))
			end
			
			if hasUranus then
				data.FFMartyrUranusDamage = true
				entity:TakeDamage(0.0001, 0, data.FFMartyrOnDeathSource, 0)
				data.FFMartyrUranusDamage = nil
			else
				-- if i let the game remove the enemy then cultists become an issue but if i remove the enemy then it's fine
				-- this might introduce some incompatibilities compared to the old way of faking the death but overall this should actually be more compatible
				entity:Kill()
				
				mod:spawnBKeeperCoin(entity, true)
				mod:spawnVadeRetroGhost(entity)
				mod:spawnChampionPickups(entity)
				mod:SpawnFireballFormulaJet(entity)
				mod:spawnVasculitis(entity)
				if not entity:HasEntityFlags(EntityFlag.FLAG_NO_REWARD) then
					data.FFMartyrLastDamageFlag = data.FFMartyrLastDamageFlag or 0
					if data.FFMartyrLastDamageFlag & DamageFlag.DAMAGE_SPAWN_BLACK_HEART ~= 0 then
						Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_BLACK, entity.Position, nilvector, nil)
					end
					if data.FFMartyrLastDamageFlag & DamageFlag.DAMAGE_SPAWN_RED_HEART ~= 0 then
						Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL, entity.Position, nilvector, nil)
					end
					if data.FFMartyrLastDamageFlag & DamageFlag.DAMAGE_SPAWN_COIN ~= 0 then
						Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, entity.Position, nilvector, nil)
					end
					if data.FFMartyrLastDamageFlag & DamageFlag.DAMAGE_SPAWN_TEMP_HEART ~= 0 then
						local heart = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF, entity.Position, RandomVector() * (math.random() + 3), nil):ToPickup()
						heart.Timeout = 60
					end
					if data.FFMartyrLastDamageFlag & DamageFlag.DAMAGE_SPAWN_CARD ~= 0 then
						local card = Game():GetItemPool():GetCard(entity.InitSeed, true, false, false)
						Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, card, entity.Position, nilvector, nil)
					end
					if data.FFMartyrLastDamageFlag & DamageFlag.DAMAGE_SPAWN_RUNE ~= 0 then
						local rune = Game():GetItemPool():GetCard(entity.InitSeed, false, true, true)
						Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, rune, entity.Position, nilvector, nil)
					end
				end
				data.FFMartyrLastDamageFlag = 0
				
				entity:Remove()
			end
			
			data.FFApplyMartyrOnDeath = nil
			data.FFForceMartyrOnDeath = nil
			data.FFMartyrDurationToSet = nil
			data.FFMartyrOnDeathSource = nil
			data.FFMartyrOnDeathDuration = nil
			mod:UntrackEnemyStatus(entity, flag)
			
			if not (entity:IsDead() or entity:HasMortalDamage()) then
				local ptrhash = GetPtrHash(entity)
				mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
				mod.VasculitisInfo[ptrhash][statusflag] = nil
			end
		else
			entity:Kill()
		end
	end
end

function mod:checkMartyrAuras(player, data)
	data.FFInMartyrAura = math.max((data.FFInMartyrAura or 0) - 1, 0)
	
	local hasBasegameAura = player:GetHallowedGroundCountdown() > 0
	local hasMartyrAura = data.FFInMartyrAura > 0
	
	if data.FFIsInMartyrAura == nil or data.FFIsInHallowAura == nil or
	   data.FFIsInMartyrAura ~= hasMartyrAura or
	   (data.FFIsInMartyrAura and data.FFIsInHallowAura ~= hasBasegameAura) 
	then
		data.FFIsInHallowAura = hasBasegameAura
		data.FFIsInMartyrAura = hasMartyrAura
		player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_TEARFLAG | CacheFlag.CACHE_TEARCOLOR)
		player:EvaluateItems()
	else
		data.FFIsInHallowAura = hasBasegameAura
		data.FFIsInMartyrAura = hasMartyrAura
	end
end

function mod:MartyrCompatibilities(entity, substitute)
	local typ, var, subt = entity.Type, entity.Variant, entity.SubType

	if mod.MartyrCompatibilityFunctions[typ .. " " .. var .. " " .. subt] ~= nil then
		mod.MartyrCompatibilityFunctions[typ .. " " .. var .. " " .. subt](entity, substitute)
	elseif mod.MartyrCompatibilityFunctions[typ .. " " .. var] ~= nil then
		mod.MartyrCompatibilityFunctions[typ .. " " .. var](entity, substitute)
	elseif mod.MartyrCompatibilityFunctions[typ] ~= nil then
		mod.MartyrCompatibilityFunctions[typ](entity, substitute)
	end
end

function mod:isMartyrBlacklisted(entity)
	return entity:IsBoss() or
	       entity:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) or
	       FiendFolio.MartyrBlacklist[entity.Type] or
	       FiendFolio.MartyrBlacklist[entity.Type .. " " .. entity.Variant] or
	       FiendFolio.MartyrBlacklist[entity.Type .. " " .. entity.Variant .. " " .. entity.SubType]
end

function mod:isMartyrWhitelisted(entity)
	return FiendFolio.MartyrWhitelist[entity.Type] or
	       FiendFolio.MartyrWhitelist[entity.Type .. " " .. entity.Variant] or
	       FiendFolio.MartyrWhitelist[entity.Type .. " " .. entity.Variant .. " " .. entity.SubType]
end

function FiendFolio.MarkForMartyrDeath(entity, source, duration, force, isCloned)
	if not (entity and entity:ToNPC()) then
		return
	end
	
	if Isaac.RunCallbackWithParam(ModCallbacks.MC_PRE_STATUS_EFFECT_APPLY, "FFMartyr", "FFMartyr", entity, EntityRef(source), duration) == false then
		return
	end
	
	local data = mod:GetEntityData(entity)

	if mod:isSegmented(entity) and not isCloned then
		local segments = mod:getSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.MarkForMartyrDeath(segment, source, duration, force, true)
			end
		end
	elseif mod:isBasegameSegmented(entity) and not isCloned then
		local segments = mod:getBasegameSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.MarkForMartyrDeath(segment, source, duration, force, true)
			end
		end
	end
	
	if (entity.Type == EntityType.ENTITY_MASK or (entity.Type == EntityType.ENTITY_MASK_OF_INFAMY and entity.Parent)) then
		return
	end

	if mod:isMartyrWhitelisted(entity) or not (mod:isMartyrBlacklisted(entity) or mod:isStatusBlacklisted(entity)) then
		data.FFApplyMartyrOnDeath = true
		data.FFForceMartyrOnDeath = force
		data.FFMartyrDurationToSet = duration

		data.FFMartyrOnDeathSource = EntityRef(source)
		data.FFMartyrOnDeathDuration = 1
		
		mod:TrackEnemyStatus(entity, statusflag)
		
		local ptrhash = GetPtrHash(entity)
		mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
		mod.VasculitisInfo[ptrhash][statusflag] = {Source = data.FFMartyrOnDeathSource}
		
		Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_STATUS_EFFECT_APPLY, "FFMartyr", "FFMartyr", entity, EntityRef(source), duration)
	end
end

function mod:PreventRemovingMartyrFlag(entity, player, flag)
	local params = TearFlagsLib.GetTearFlagParams(entity, flag)
	if params.NoRemove then
		return true
	end
end
mod:AddCallback(TearFlagsLib.Callback.PRE_REMOVE_TEARFLAG, mod.PreventRemovingMartyrFlag, tearflag)

function FiendFolio.FlagMartyr(entity, duration)
	TearFlagsLib.AddTearFlags(entity, tearflag)
	
	local params = TearFlagsLib.GetTearFlagParams(entity, tearflag)
	TearFlagsLib.SetTearFlagParams(entity, tearflag, {Duration = math.max(params.Duration or 0, duration)})
end

function mod:applyMartyrFlagAndOnCheckKill(entity, amount, flags, source, cooldown, extraSource)
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
			if data.ClearedMartyr ~= frame then
				TearFlagsLib.SetTearFlagParams(hitter, tearflag, {NoRemove = false})
				TearFlagsLib.ClearTearFlags(hitter, tearflag)
				data.ClearedMartyr = frame
			end
			
			mod:crucifixFlagOnDamage(hitter)
			
			if TearFlagsLib.HasTearFlags(hitter, tearflag) then
				local params = TearFlagsLib.GetTearFlagParams(hitter, tearflag)
				FiendFolio.MarkForMartyrDeath(entity, TearFlagsLib.GetTearPlayer(hitter), params.Duration, false)
				TearFlagsLib.SetTearFlagParams(hitter, tearflag, {NoRemove = true})
			end
		end
	elseif source.Entity and TearFlagsLib.IsEntityOcularRift(source.Entity) then
		-- same as above, just more stuff to make can of beans play nicer with this
		local hitter = source.Entity
		
		local data = mod:GetEntityData(hitter)
		local frame = game:GetFrameCount()
		if data.ClearedMartyr ~= frame then
			TearFlagsLib.SetTearFlagParams(hitter, tearflag, {NoRemove = false})
			TearFlagsLib.ClearTearFlags(hitter, tearflag)
			data.ClearedMartyr = frame
		end
		
		mod:crucifixFlagOnDamage(hitter)
		
		if TearFlagsLib.HasTearFlags(hitter, tearflag) then
			local params = TearFlagsLib.GetTearFlagParams(hitter, tearflag)
			FiendFolio.MarkForMartyrDeath(entity, TearFlagsLib.GetTearPlayer(hitter), params.Duration, false)
			TearFlagsLib.SetTearFlagParams(hitter, tearflag, {NoRemove = true})
		end
	elseif source.Type == EntityType.ENTITY_EFFECT and source.Variant == EffectVariant.DARK_SNARE and source.Entity and source.Entity.SpawnerEntity then
		local snare = source.Entity
		
		local data = mod:GetEntityData(snare)
		local frame = game:GetFrameCount()
		if data.ClearedMartyr ~= frame then
			TearFlagsLib.SetTearFlagParams(snare, tearflag, {NoRemove = false})
			TearFlagsLib.ClearTearFlags(snare, tearflag)
			data.ClearedMartyr = frame
		end
		
		mod:crucifixFlagOnDamage(snare)
		
		if TearFlagsLib.HasTearFlags(snare, tearflag) then
			local params = TearFlagsLib.GetTearFlagParams(snare, tearflag)
			FiendFolio.MarkForMartyrDeath(entity, TearFlagsLib.GetTearPlayer(snare), params.Duration, false)
			TearFlagsLib.SetTearFlagParams(snare, tearflag, {NoRemove = true})
		end
	elseif source.Type == EntityType.ENTITY_FAMILIAR and source.Variant == FamiliarVariant.ABYSS_LOCUST and source.Entity and source.Entity.SubType == FiendFolio.ITEM.COLLECTIBLE.CRUCIFIX then
		local locust = source.Entity:ToFamiliar()
		local player = locust.Player
		
		local secondHandMultiplier = 1
		if player then
			local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
		end
		FiendFolio.MarkForMartyrDeath(entity, player, 150 * secondHandMultiplier, false)
	elseif source.Type == 1 and source.Entity and mod:GetEntityData(source.Entity).MaliceDashing then
		local pdata = mod:GetEntityData(source.Entity)
		if pdata.MaliceProjectile and pdata.MaliceProjectile:Exists() and TearFlagsLib.HasTearFlags(pdata.MaliceProjectile, tearflag) then
			local params = TearFlagsLib.GetTearFlagParams(pdata.MaliceProjectile, tearflag)
			FiendFolio.MarkForMartyrDeath(entity, source.Entity, params.Duration, false)
		end
	elseif source.Type == 1 and TearFlagsLib.hemoptysisDummy then
		if TearFlagsLib.HasTearFlags(TearFlagsLib.hemoptysisDummy, tearflag) then
			local params = TearFlagsLib.GetTearFlagParams(TearFlagsLib.hemoptysisDummy, tearflag)
			FiendFolio.MarkForMartyrDeath(entity, source.Entity, params.Duration, false)
		end
	elseif source.Entity and TearFlagsLib.HasTearFlags(source.Entity, tearflag) then
		local params = TearFlagsLib.GetTearFlagParams(source.Entity, tearflag)
		FiendFolio.MarkForMartyrDeath(entity, TearFlagsLib.GetTearPlayer(source.Entity), params.Duration, false)
	end
	
	mod:platinumDipOnDamage(entity, source)
	
	local data = mod:GetEntityData(entity)
	if data.FFMartyrDuration ~= nil or (data.FFMartyrOnDeathDuration ~= nil and data.FFMartyrOnDeathDuration > 0) then
		data.FFMartyrLastDamageFlag = (data.FFMartyrLastDamageFlag or 0) | flags | DamageFlag.DAMAGE_NOKILL
		return {DamageFlags = flags | DamageFlag.DAMAGE_NOKILL}
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, -50, mod.applyMartyrFlagAndOnCheckKill)

function mod.handleMartyrD3(entity)
	local params = TearFlagsLib.GetTearFlagParams(entity, tearflag)
	TearFlagsLib.SetTearFlagParams(entity, tearflag, {Duration = math.max(params.Duration or 0, 150)})
end

function mod:martyrOnVasculitis(tear, npc)
	local ptrhash = GetPtrHash(npc)
	mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
	
	local vasculitisInfo = mod.VasculitisInfo[ptrhash][statusflag]
	if vasculitisInfo then
		local source = vasculitisInfo.Source
		local player = source and source.Entity and source.Entity:ToPlayer()
		local secondHandMultiplier = (player and (player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1)) or 1
		FiendFolio.FlagMartyr(entity, 150 * secondHandMultiplier)
	end
end

function mod:martyrOnUpdate(npc, data, sprite)
	if data.FFMartyrOnDeathDuration ~= nil then
		mod:handleMartyrOnDeath(npc, data, sprite)
	end
	
	if data.FFMartyrOnDeathDuration ~= nil and data.FFMartyrOnDeathDuration <= 0 then
		data.FFApplyMartyrOnDeath = nil
		data.FFMartyrOnDeathDuration = nil
		data.FFApplyMartyrExcommunicated = nil
		data.FFApplyMartyrExcommunicatedDuration = nil
		data.FFApplyMartyrExcommunicatedDamage = nil
		mod:UntrackEnemyStatus(npc, flag)
		
		if not (npc:IsDead() or npc:HasMortalDamage()) then
			local ptrhash = GetPtrHash(npc)
			mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
			mod.VasculitisInfo[ptrhash][statusflag] = nil
		end
	end
	
	data.FFMartyrLastDamageFlag = 0
end

function mod:copyMartyr(copy, copyData, sourceData)
	if mod:isMartyrWhitelisted(copy) or not (mod:isMartyrBlacklisted(copy) or mod:isStatusBlacklisted(copy)) then
		copyData.FFApplyMartyrOnDeath = sourceData.FFApplyMartyrOnDeath
		copyData.FFForceMartyrOnDeath = sourceData.FFForceMartyrOnDeath
		copyData.FFMartyrDurationToSet = sourceData.FFMartyrDurationToSet

		copyData.FFMartyrOnDeathSource = sourceData.FFMartyrOnDeathSource
		copyData.FFMartyrOnDeathDuration = sourceData.FFMartyrOnDeathDuration
	end
end

function mod:updateMartyrDamage(player)
	local data = mod:GetEntityData(player)
	if data.FFIsInMartyrAura and player:GetHallowedGroundCountdown() <= 0 then
		player.Damage = player.Damage * 1.1
	end
end

function mod:updateMartyrFireDelay(player)
	local data = mod:GetEntityData(player)
	if data.FFIsInMartyrAura and player:GetHallowedGroundCountdown() <= 0 then
		--player.MaxFireDelay = math.max(1, math.floor(player.MaxFireDelay * 0.8)) -- direct maxfiredelay multipliers break at negative firedelay values
		player.MaxFireDelay = mod:tearsMult(player.MaxFireDelay, mod:convertTearMultABPToRep(0.8))
	end
end

function mod:updateMartyrTearFlags(player)
	local data = mod:GetEntityData(player)
	if data.FFIsInMartyrAura and player:GetHallowedGroundCountdown() <= 0 then
		player.TearFlags = player.TearFlags | TearFlags.TEAR_HOMING
	end
end

function mod:updateMartyrTearLaserColor(player)
	local data = mod:GetEntityData(player)
	if data.FFIsInMartyrAura and player:GetHallowedGroundCountdown() <= 0 then
		local tearcolor = Color(1.5, 2.0, 2.0, 1.0, 0/255, 0/255, 0/255)
		player.TearColor = tearcolor
		
		local lasercolor = Color(1.0, 1.0, 1.0, 1.0, 0/255, 0/255, 0/255)
		lasercolor:SetColorize(5.0, 6.0, 6.0, 1)
		player.LaserColor = lasercolor
	end
end

mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_TAKE_DMG, function(_, player, amount, flags, source, countdown)
	local data = mod:GetEntityData(player)
	if data.FFIsInMartyrAura and player:GetHallowedGroundCountdown() <= 0 then
		local rng = player:GetCollectibleRNG(FiendFolio.ITEM.COLLECTIBLE.CRUCIFIX)
		if rng:RandomFloat() <= 0.5 then
			player:SetColor(Color(1, 1, 1, 1, 64/255, 64/255, 128/255), 16, 0, true, false)
			return false
		end
	end
end)
