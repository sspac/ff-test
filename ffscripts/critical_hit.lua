local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero
local flagsManager = TearFlagsLib
mod.CritFlag = flagsManager.RegisterTearFlag("CRIT")

mod.CritDamageMult = 5

local blacklistedCharacters = {
    [PlayerType.PLAYER_CAIN] = true,
    [PlayerType.PLAYER_CAIN_B] = true,
	[FiendFolio.PLAYER.FRIEND] = true,
}
local function canStrangeEyeCrit(player)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.STRANGE_EYE) then
		mod.savedata.StrangeEyeStatus = mod.savedata.StrangeEyeStatus or 1
        if (player:GetTearDisplacement() == -1 or blacklistedCharacters[player:GetPlayerType()] or not player:HasWeaponType(WeaponType.WEAPON_TEARS))
		and mod.savedata.StrangeEyeStatus > 5 then
            return true
        end
    end
end

function mod:canCritialHit(player, isChanceless)
	return player:HasCollectible(mod.ITEM.COLLECTIBLE.IMP_SODA) or player:HasTrinket(FiendFolio.ITEM.ROCK.SODALITE_GEODE) or mod:IsNearPepperStatue(player.Position, 2)
		or canStrangeEyeCrit(player)
end

function mod:shouldCriticalHit(player, entity, isChanceless)
	local d = mod:GetEntityData(player)
	if d.TempCritTime then
		return true
	elseif d.ffsavedata and d.ffsavedata.RunEffects.GuaranteedCrits and d.ffsavedata.RunEffects.GuaranteedCrits > 0 then
		d.ffsavedata.RunEffects.GuaranteedCrits = d.ffsavedata.RunEffects.GuaranteedCrits-1
		return true
	end

	if (mod.FireTearSource and mod.FireTearSource.Type == EntityType.ENTITY_FAMILIAR and mod.FireTearSource.Variant == FamiliarVariant.BLOOD_BABY and mod.FireTearSource.SubType == 920) or
	   (entity and entity.Parent and entity.Parent.Type == EntityType.ENTITY_FAMILIAR and entity.Parent.Variant == FamiliarVariant.BLOOD_BABY and entity.Parent.SubType == 920) or
	   (entity and entity.SpawnerEntity and entity.SpawnerEntity.Type == EntityType.ENTITY_FAMILIAR and entity.SpawnerEntity.Variant == FamiliarVariant.BLOOD_BABY and entity.SpawnerEntity.SubType == 920) or
	   (entity and TearFlagsLib.HasTearFlags(entity, mod.ImmoralClotTracker))
	then	
		if not isChanceless and math.random(25) == 1 then
			return true
		end
	end

	if not isChanceless and mod:canCritialHit(player) then
		local extraOdds = 0
		if player:HasCollectible(mod.ITEM.COLLECTIBLE.IMP_SODA) then
			extraOdds = extraOdds + (5 * player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.IMP_SODA))
			if player:HasTrinket(FiendFolio.ITEM.ROCK.SODALITE_GEODE) then
				extraOdds = extraOdds + 5
			end
		end
		
		local trinketPower, geodeBonus = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.SODALITE_GEODE)
		if geodeBonus then
			trinketPower = trinketPower * 1.5
		end
		if trinketPower > 0 then
			extraOdds = extraOdds + 5 * (trinketPower - 1)
		end

		if mod:IsNearPepperStatue(player.Position, 2) then --Sculpted Pepper, Fiend Statue
			extraOdds = extraOdds + 18
			extraOdds = extraOdds * 1.5
		end

		if canStrangeEyeCrit(player) then
			local boost = true
			if blacklistedCharacters[player:GetPlayerType()] or not player:HasWeaponType(WeaponType.WEAPON_TEARS) then
				local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.STRANGE_EYE)
				if rng:RandomInt(2) == 0 then
					boost = false
				end
			end
			if boost then
				mod.savedata.StrangeEyeStatus = mod.savedata.StrangeEyeStatus or 1
				if mod.savedata.StrangeEyeStatus > 20 then
					extraOdds = extraOdds + 7
				elseif mod.savedata.StrangeEyeStatus > 10 then
					extraOdds = extraOdds + 3
				elseif mod.savedata.StrangeEyeStatus > 5 then
					extraOdds = extraOdds + 1
				end
			end
		end
		
		local ImpSodaOdds = (30 - math.floor(player.Luck * 2) - math.ceil(extraOdds))
		return math.random(math.max(3, ImpSodaOdds)) == 1
	end
	return false
end

function mod:genericHandleCrit(entity, player, weaponFlag, isChanceless)
	if weaponFlag == TearFlagsLib.WeaponFlag.DARK_ARTS or weaponFlag == TearFlagsLib.WeaponFlag.OCULAR_RIFT then return end
	
	if mod:shouldCriticalHit(player, entity, isChanceless) then
		local isTrickyCherry = mod:GetEntityData(player).TrickyCherryCrit
	
		flagsManager.AddTearFlags(entity, mod.CritFlag)
		flagsManager.SetTearFlagParams(entity, mod.CritFlag, {IsTrickyCherry = isTrickyCherry})
		mod:GetEntityData(entity).FFCritHitlist = nil
		
		if weaponFlag == TearFlagsLib.WeaponFlag.TEAR or weaponFlag == TearFlagsLib.WeaponFlag.LUDOVICO_TEAR or
		   weaponFlag == TearFlagsLib.WeaponFlag.BOBS_ROTTEN_HEAD or weaponFlag == TearFlagsLib.WeaponFlag.SHARP_KEY or
		   weaponFlag == TearFlagsLib.WeaponFlag.DR_FETUS or weaponFlag == TearFlagsLib.WeaponFlag.FF_PLANET_X
		then
			-- if this isn't scheduled then sometimes the index of the crit lightning is before the parent and it follows a frame behind as a result
			mod.scheduleForUpdate(function()
				local data = mod:GetEntityData(entity)
				if not data.critLightning or not data.critLightning:Exists() then
					sfx:Play(mod.Sounds.CritShoot, 0.3, 0, false, math.random(80,120)/100)
					local critLightning = Isaac.Spawn(1000, 1737, 1, entity.Position, nilvector, entity):ToEffect()
					critLightning.Parent = entity
					critLightning.Color = Color(1,1,1,0,0,0,1)
					critLightning:Update()
					mod:GetEntityData(critLightning).TrickyCherryCrit = isTrickyCherry
					data.critLightning = critLightning
				end
			end, 1)
		end
		
		local color = (isTrickyCherry and Color(1.3,1.3,1.3,1,150/255,-150/255,-150/255)) or Color(1.3,1.3,1.3,1,100/255,-150/255,100/255)
		if weaponFlag == TearFlagsLib.WeaponFlag.AQUARIUS then
			mod:GetEntityData(entity).FFAquariusTearColor = color
		elseif weaponFlag == TearFlagsLib.WeaponFlag.EPIC_FETUS or weaponFlag == TearFlagsLib.WeaponFlag.CLUB_EPIC_FETUS then
			mod:GetEntityData(entity).FFExplosionColor = color
		elseif weaponFlag == TearFlagsLib.WeaponFlag.BOBS_ROTTEN_HEAD or weaponFlag == TearFlagsLib.WeaponFlag.SHARP_KEY then
			-- these don't usually get tear colours but this feels like a special exception
			-- giving them a reduced colour cause why not
			entity.Color = (isTrickyCherry and Color(1.1,1.1,1.1,1,50/255,-50/255,-50/255)) or Color(1.1,1.1,1.1,1,33/255,-50/255,33/255)
		elseif weaponFlag == TearFlagsLib.WeaponFlag.LASER or 
		       weaponFlag == TearFlagsLib.WeaponFlag.ANTI_GRAV_LASER or 
		       weaponFlag == TearFlagsLib.WeaponFlag.KNIFE or
		       weaponFlag == TearFlagsLib.WeaponFlag.DARK_ARTS or
		       weaponFlag == TearFlagsLib.WeaponFlag.LOCUST or
		       weaponFlag == TearFlagsLib.WeaponFlag.UMBILICAL_WHIP or
		       weaponFlag == TearFlagsLib.WeaponFlag.BRIMSTONE_BALL or
		       weaponFlag == TearFlagsLib.WeaponFlag.OCULAR_RIFT or
		       weaponFlag == TearFlagsLib.WeaponFlag.HEMOPTYSIS
		then
			return
		else
			entity.Color = color
		end
	end
end
mod:AddCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, function(_, entity, player, weaponFlag)
	mod:genericHandleCrit(entity, player, weaponFlag, false)
end)
mod:AddCallback(TearFlagsLib.Callback.POLL_CHANCELESS_TEARFLAGS, function(_, entity, player, weaponFlag)
	mod:genericHandleCrit(entity, player, weaponFlag, true)
end)

function mod.handleCritD3(entity)
	if entity.Type == EntityType.ENTITY_TEAR or entity.Type == EntityType.ENTITY_BOMB then
		-- if this isn't scheduled then sometimes the index of the crit lightning is before the parent and it follows a frame behind as a result
		mod.scheduleForUpdate(function()
			local data = mod:GetEntityData(entity)
			if not data.critLightning or not data.critLightning:Exists() then
				sfx:Play(mod.Sounds.CritShoot, 0.3, 0, false, math.random(80,120)/100)
				local critLightning = Isaac.Spawn(1000, 1737, 1, entity.Position, nilvector, entity):ToEffect()
				critLightning.Parent = entity
				critLightning.Color = Color(1,1,1,0,0,0,1)
				critLightning:Update()
				mod:GetEntityData(critLightning).TrickyCherryCrit = isTrickyCherry
				data.critLightning = critLightning
			end
		end, 1)
	end
end

function mod:PreventRemovingCritFlag(entity, player, flag)
	if TearFlagsLib.GetTearFlagParams(entity, flag).NoRemove then
		return true
	end
end
mod:AddCallback(TearFlagsLib.Callback.PRE_REMOVE_TEARFLAG, mod.PreventRemovingCritFlag, mod.CritFlag)

local function getClosestPointOnLine(testPosition, lineOrigin, lineEnd)
	local heading = lineEnd - lineOrigin
	local magnitude = heading:Length()
	heading:Normalize()

	local lhs = testPosition - lineOrigin
	local dot = lhs:Dot(heading)
	dot = math.min(math.max(0, dot), magnitude)
	return lineOrigin + heading * dot
end

local function movePosToClosestLaserSegment(pos, laser)
	local closestPoint = pos
	local closestDist = math.huge
	local capsules
	if laser:IsSampleLaser() then
		capsules = TearFlagsLib.GetLaserSampleCapsules(laser)
	else
		capsules = {TearFlagsLib.GetCapsule(laser.Position, laser.Position + Vector.FromAngle(laser.AngleDegrees) * 9999, laser.Radius)}
	end
	for _, laserCapsule in pairs(capsules) do
		local pointOnLine = getClosestPointOnLine(pos, laserCapsule.Locus1, laserCapsule.Locus2)
		local dist = pointOnLine:Distance(pos)
		if dist < closestDist then
			closestPoint = pointOnLine
			closestDist = dist
		end
	end
	return closestPoint
end

mod.CheckingForDmg = {}
mod:AddPriorityCallback(ModCallbacks.MC_PRE_EFFECT_UPDATE, math.huge, function(_, rift)
	table.insert(mod.CheckingForDmg, rift)
end, EffectVariant.RIFT)

mod:AddPriorityCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, -1 * math.huge, function(_, rift)
	for i = #mod.CheckingForDmg, 1, -1 do
		local entity = mod.CheckingForDmg[i]
		table.remove(mod.CheckingForDmg, i)
		if GetPtrHash(rift) == GetPtrHash(entity) then
			break
		end
	end
end, EffectVariant.RIFT)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	mod.CheckingForDmg = {}
end)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	mod.CheckingForDmg = {}
end)

mod.CurrentlyCritting = {}
mod.OverrideCritBoostCheck = nil -- set to boolean value to force crit to be enabled/disabled
mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, -200, function(_, entity, amount, flags, source, cooldown, extraSource)
	if flags & DamageFlag.DAMAGE_CLONES ~= 0 or not entity:ToNPC() then return end
	
	if mod.OverrideCritBoostCheck ~= nil then
		return (mod.OverrideCritBoostCheck and {Damage = amount * mod.CritDamageMult}) or nil
	end
	
	local origSource = source
	local source = extraSource or source
	if source.Type == EntityType.ENTITY_KNIFE then
		source = EntityRef(source.Entity:ToKnife():GetHitboxParentKnife() or source.Entity)
	end
	local shouldDoFX = flags & DamageFlag.DAMAGE_EXPLOSION == 0 and
	                   not (source.Entity and FiendFolio.HasBeansFlag(source.Entity)) and
	                   (not (source.Entity and TearFlagsLib.HasTearFlags(source.Entity, TearFlagsLib.Flag.EYE_OF_PROVIDENCE)) or mod.EyeOfProvLaser) and
	                   not (source.Type == EntityType.ENTITY_LASER and source.Entity and source.Entity:ToLaser():HasTearFlags(TearFlags.TEAR_EXPLOSIVE))

	if source.Type == 0 and flags & DamageFlag.DAMAGE_LASER > 0 then
		-- this is technically not accurate for ocular rift since it rolls every hit instead of every frame but idc
		-- this functions nicer for can of beans purposes
		-- i'll leave tearflagslib generally as it is but for weird stuff like this imma do this instead
		local critter = mod.CheckingForDmg[#mod.CheckingForDmg]
		if critter and TearFlagsLib.IsEntityOcularRift(critter) then
			local player = TearFlagsLib.GetTearPlayer(critter)
			local data = mod:GetEntityData(critter)
			local frame = game:GetFrameCount()
			if data.AppliedCrit ~= frame then
				TearFlagsLib.SetTearFlagParams(critter, mod.CritFlag, {NoRemove = false})
				TearFlagsLib.ClearTearFlags(critter, mod.CritFlag)
			end
			if data.RolledForImpSoda ~= frame then
				if mod:shouldCriticalHit(player) then
					local isTrickyCherry = mod:GetEntityData(player).TrickyCherryCrit
					flagsManager.AddTearFlags(critter, mod.CritFlag)
					flagsManager.SetTearFlagParams(critter, mod.CritFlag, {IsTrickyCherry = isTrickyCherry, NoRemove = true})
					data.AppliedCrit = frame
				end
				data.RolledForImpSoda = frame
			end
			if player and TearFlagsLib.HasTearFlags(critter, mod.CritFlag) and not Isaac.RunCallbackWithParam(FiendFolio.CALLBACK.PRE_CRIT_BOOST_DMG, EntityType.ENTITY_EFFECT, entity, amount, flags, source, cooldown) then
				if shouldDoFX then
					local isTrickyCherry = data.IsTrickyCherryCrit
					mod.scheduleForUpdate(function()
						if data.lastFrameImpSodaProcced == frame then return end
						mod:doCriticalHitFx(critter.Position, entity, critter, isTrickyCherry)
						data.lastFrameImpSodaProcced = frame
					end, 1)
				end
				mod.CurrentlyCritting[GetPtrHash(entity)] = true
				return {Damage = amount * mod.CritDamageMult}
			end
		end
	elseif source.Entity and TearFlagsLib.IsEntityOcularRift(source.Entity) then
		-- same as above, just more stuff to make can of beans play nicer with this
		local critter = source.Entity
		local player = TearFlagsLib.GetTearPlayer(critter)
		local data = mod:GetEntityData(critter)
		local frame = game:GetFrameCount()
		if data.AppliedCrit ~= frame then
			TearFlagsLib.SetTearFlagParams(critter, mod.CritFlag, {NoRemove = false})
			TearFlagsLib.ClearTearFlags(critter, mod.CritFlag)
		end
		if data.RolledForImpSoda ~= frame then
			if mod:shouldCriticalHit(player) then
				local isTrickyCherry = mod:GetEntityData(player).TrickyCherryCrit
				flagsManager.AddTearFlags(critter, mod.CritFlag)
				flagsManager.SetTearFlagParams(critter, mod.CritFlag, {IsTrickyCherry = isTrickyCherry, NoRemove = true})
				data.AppliedCrit = frame
			end
			data.RolledForImpSoda = frame
		end
		if player and TearFlagsLib.HasTearFlags(critter, mod.CritFlag) and not Isaac.RunCallbackWithParam(FiendFolio.CALLBACK.PRE_CRIT_BOOST_DMG, EntityType.ENTITY_EFFECT, entity, amount, flags, source, cooldown) then
			if shouldDoFX then
				local isTrickyCherry = data.IsTrickyCherryCrit
				mod.scheduleForUpdate(function()
					if data.lastFrameImpSodaProcced == frame then return end
					mod:doCriticalHitFx(critter.Position, entity, critter, isTrickyCherry)
					data.lastFrameImpSodaProcced = frame
				end, 1)
			end
			mod.CurrentlyCritting[GetPtrHash(entity)] = true
			return {Damage = amount * mod.CritDamageMult}
		end
	elseif source.Type == EntityType.ENTITY_EFFECT and source.Variant == EffectVariant.DARK_SNARE and source.Entity and source.Entity.SpawnerEntity then
		local snare = source.Entity
		local player = TearFlagsLib.GetTearPlayer(snare)
		local data = mod:GetEntityData(snare)
		local frame = game:GetFrameCount()
		if data.AppliedCrit ~= frame then
			TearFlagsLib.SetTearFlagParams(snare, mod.CritFlag, {NoRemove = false})
			TearFlagsLib.ClearTearFlags(snare, mod.CritFlag)
		end
		if data.RolledForImpSoda ~= frame and data.AppliedCrit ~= frame then
			if mod:shouldCriticalHit(player) then
				local isTrickyCherry = mod:GetEntityData(player).TrickyCherryCrit
				flagsManager.AddTearFlags(snare, mod.CritFlag)
				flagsManager.SetTearFlagParams(snare, mod.CritFlag, {IsTrickyCherry = isTrickyCherry, NoRemove = true})
				data.AppliedCrit = frame
			end
			data.RolledForImpSoda = frame
		end
		if player and TearFlagsLib.HasTearFlags(snare, mod.CritFlag) and not Isaac.RunCallbackWithParam(FiendFolio.CALLBACK.PRE_CRIT_BOOST_DMG, source.Type, entity, amount, flags, source, cooldown) then
			if shouldDoFX then
				local isTrickyCherry = TearFlagsLib.GetTearFlagParams(snare, mod.CritFlag).IsTrickyCherry
				mod.scheduleForUpdate(function()
					local frame = game:GetFrameCount()
					if data.lastFrameImpSodaProcced == frame then return end
					mod:doCriticalHitFx(snare.Position, entity, snare, isTrickyCherry)
					data.lastFrameImpSodaProcced = frame
				end, 1)
			end
			mod.CurrentlyCritting[GetPtrHash(entity)] = true
			return {Damage = amount * mod.CritDamageMult}
		end
	elseif source.Type == 1 and source.Entity and mod:GetEntityData(source.Entity).MaliceDashing then
		local pdata = mod:GetEntityData(source.Entity)
		if pdata.MaliceProjectile and pdata.MaliceProjectile:Exists() and TearFlagsLib.HasTearFlags(pdata.MaliceProjectile, mod.CritFlag) and
		   not Isaac.RunCallbackWithParam(FiendFolio.CALLBACK.PRE_CRIT_BOOST_DMG, pdata.MaliceProjectile.Type, entity, amount, flags, EntityRef(pdata.MaliceProjectile), cooldown) 
		then
			if shouldDoFX then
				local sourceEnt = pdata.MaliceProjectile
				local data = mod:GetEntityData(sourceEnt)
				local isTrickyCherry = TearFlagsLib.GetTearFlagParams(sourceEnt, mod.CritFlag).IsTrickyCherry
				mod.scheduleForUpdate(function()
					local frame = game:GetFrameCount()
					if data.lastFrameImpSodaProcced == frame then return end
					mod:doCriticalHitFx(sourceEnt.Position, entity, sourceEnt, isTrickyCherry)
					data.lastFrameImpSodaProcced = frame
				end, 1)
			end
			mod.CurrentlyCritting[GetPtrHash(entity)] = true
			return {Damage = amount * mod.CritDamageMult}
		end
	elseif source.Type == 1 and TearFlagsLib.hemoptysisDummy and TearFlagsLib.HasTearFlags(TearFlagsLib.hemoptysisDummy, mod.CritFlag) then
		local dummy = TearFlagsLib.hemoptysisDummy
		if not Isaac.RunCallbackWithParam(FiendFolio.CALLBACK.PRE_CRIT_BOOST_DMG, source.Type, entity, amount, flags, EntityRef(dummy), cooldown) then
			if shouldDoFX then
				local sourceEnt = dummy
				local data = mod:GetEntityData(sourceEnt)
				local isTrickyCherry = TearFlagsLib.GetTearFlagParams(sourceEnt, mod.CritFlag).IsTrickyCherry
				local pos = (source.Entity and source.Entity.Position) or sourceEnt.Position
				mod.scheduleForUpdate(function()
					local frame = game:GetFrameCount()
					if data.lastFrameImpSodaProcced == frame then return end
					mod:doCriticalHitFx(pos, entity, sourceEnt, isTrickyCherry)
					data.lastFrameImpSodaProcced = frame
				end, 1)
			end
			mod.CurrentlyCritting[GetPtrHash(entity)] = true
			return {Damage = amount * mod.CritDamageMult}
		end
	elseif source.Entity and TearFlagsLib.HasTearFlags(source.Entity, mod.CritFlag) then
		local shouldHitlist = flags & DamageFlag.DAMAGE_EXPLOSION == 0 and
		                      not mod.EyeOfProvLaser and
		                      (source.Type == EntityType.ENTITY_LASER or 
							  (source.Type == EntityType.ENTITY_TEAR and source.Entity:ToTear():HasTearFlags(TearFlags.TEAR_LUDOVICO)) or
		                      (source.Type == EntityType.ENTITY_KNIFE and origSource.Entity.SubType ~= 4 and not TearFlagsLib.IsEntitySpiritSword(source.Entity)) or 
		                      (source.Type == EntityType.ENTITY_EFFECT and (source.Variant == EffectVariant.BRIMSTONE_BALL or source.Variant == EffectVariant.TECH_DOT or source.Variant == EffectVariant.BRIMSTONE_SWIRL)))
		if shouldHitlist then
			local data = mod:GetEntityData(source.Entity)
			data.FFCritHitlist = data.FFCritHitlist or {}
			if data.FFCritHitlist[GetPtrHash(entity)] then
				return
			end
		end
		if not Isaac.RunCallbackWithParam(FiendFolio.CALLBACK.PRE_CRIT_BOOST_DMG, source.Type, entity, amount, flags, source, cooldown) then
			local sourceEnt = mod.EyeOfProvLaser or source.Entity
			local data = mod:GetEntityData(sourceEnt)
			if shouldDoFX then
				local isTrickyCherry = TearFlagsLib.GetTearFlagParams(sourceEnt, mod.CritFlag).IsTrickyCherry
				local pos = (mod.EyeOfProvLaser and entity.Position) or 
				            (source.Type == EntityType.ENTITY_LASER and movePosToClosestLaserSegment(entity.Position, sourceEnt:ToLaser())) or 
							sourceEnt.Position
				local shouldDoFrameCheck = source.Type ~= EntityType.ENTITY_LASER and not mod.EyeOfProvLaser
				mod.scheduleForUpdate(function()
					local frame = game:GetFrameCount()
					if shouldDoFrameCheck and data.lastFrameImpSodaProcced == frame then return end
					mod:doCriticalHitFx(pos, entity, sourceEnt, isTrickyCherry)
					data.lastFrameImpSodaProcced = frame
				end, 1)
			end
			if shouldHitlist then
				data.FFCritHitlist = data.FFCritHitlist or {}
				local frame = game:GetFrameCount()
				local segments = (mod:isSegmented(entity) and not mod:isReducedSyncSegment(entity) and mod:getSegments(entity)) or
				                 (mod:isBasegameSegmented(entity) and not mod:isBasegameReducedSyncSegment(entity) and mod:getBasegameSegments(entity)) or
				                 {entity}
				for _, segment in ipairs(segments) do
					data.FFCritHitlist[GetPtrHash(segment)] = frame
				end
			end
			mod.CurrentlyCritting[GetPtrHash(entity)] = true
			return {Damage = amount * mod.CritDamageMult}
		end
	end
end)

mod:AddPriorityCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, math.huge, function(_, entity)
	mod.CurrentlyCritting[GetPtrHash(entity)] = nil
	mod.ForceCrit = false
end)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	mod.CurrentlyCritting = {}
	mod.OverrideCritBoostCheck = nil
end)

mod:AddCallback(FiendFolio.CALLBACK.PRE_CRIT_BOOST_DMG, function(_, entity, _, _, source)
	if source.Variant == EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL then
		if not source.Entity then return end
		local data = mod:GetEntityData(source.Entity)
		data.impSodaHitList = data.impSodaHitList or {}
		if data.impSodaHitList[GetPtrHash(entity)] then
			return true
		end
		data.impSodaHitList[GetPtrHash(entity)] = true
	end
end, EntityType.ENTITY_EFFECT)

mod:AddCallback(ModCallbacks.MC_POST_BOMB_TEARFLAG_EFFECTS, function(_, pos, radius, tearflags, src, radiusMult)
	if src and TearFlagsLib.HasTearFlags(src, mod.CritFlag) then
		local frame = game:GetFrameCount()
		if mod:GetEntityData(src).lastFrameImpSodaProcced ~= frame or src.Type == EntityType.ENTITY_LASER then
			mod:doCriticalHitFx(pos, nil, src)
			mod:GetEntityData(src).lastFrameImpSodaProcced = frame
		end
	end
end)

function mod:doCriticalHitFx(pos, target, source, doTrickyCherry)
	sfx:Play(mod.Sounds.ImpSodaCrit,0.8,0,false,math.random(80,120)/100)
	local crit = Isaac.Spawn(1000, 1734, 0, pos + Vector(0,1), nilvector, source):ToEffect()

	if doTrickyCherry or TearFlagsLib.GetTearFlagParams(source, mod.CritFlag).IsTrickyCherry then
		crit:GetSprite():ReplaceSpritesheet(0, "gfx/familiar/fiend/effect_crit_cherry.png", true)
	end

	crit.DepthOffset = ((source and source.DepthOffset) or 0) + 1
	crit.SpriteOffset = Vector(0, -15)
	crit:Update()
	if target and not (target.Type == EntityType.ENTITY_BEAST and (target.Variant == 10 or target.Variant == 20 or target.Variant == 30 or target.Variant == 40)) then
		mod:makeEnemyGib(target)
	end
	game:ShakeScreen(6)
end

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.IMP_SODA] = {
	BodyColor = Color(1,1,1,1,-35.305/255,-37.606/255,-22.973/255,0.907,0.642,0.965,1),
	EyeAColor = Color(1,1,1,1,45.656/255,-158/255,-55.203/255,0.656,1,0.797,1),
	EyeBColor = Color(1,1,1,1,45.656/255,-158/255,-55.203/255,0.656,1,0.797,1)}

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	if math.random(25) == 1 then
		flagsManager.AddTearFlags(tear, mod.CritFlag)
		local data = mod:GetEntityData(tear)
		if not data.critLightning or not data.critLightning:Exists() then
			sfx:Play(mod.Sounds.CritShoot, 0.3, 0, false, math.random(80,120)/100)
			local critLightning = Isaac.Spawn(1000, 1737, 1, tear.Position, nilvector, tear):ToEffect()
			critLightning.Parent = tear
			critLightning.Color = Color(1,1,1,0,0,0,1)
			critLightning:Update()
			data.critLightning = critLightning
		end
		tear.Color = Color(1.3,1.3,1.3,1,100/255,-150/255,100/255)
		
		if familiar.Player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
			local tearcolor = Color(0.4, 0.15, 0.38, 1, 55/255, 5/255, 95/255)
			tear.Color = tearcolor
		end
		if mod:isSuperpositionedPlayer(familiar.Player) then
			local tearcolor = Color.Lerp(tear.Color, Color(1,1,1,1,0,0,0), 0)
			tearcolor.A = tearcolor.A / 4
			tear.Color = tearcolor
		end
		--tear.SplatColor = Color(1.3,1.3,1.3,1,100 / 255,-150 / 255,100 / 255)
	end
end, FiendFolio.ITEM.COLLECTIBLE.IMP_SODA)

function mod:impSodaCritZap(e)
	if e.SubType == 1 then
		if not e.Parent or (e.Parent and not (e.Parent:Exists() and flagsManager.HasTearFlags(e.Parent, mod.CritFlag))) then
			e:Remove()
		end
		if e.Parent and e.Parent:Exists() then
			local alpha = 1
			if e.FrameCount < 10 then
				alpha = e.FrameCount / 10
			end
			if mod:GetEntityData(e).TrickyCherryCrit then
				e.Color = Color(1,0.5,0.5,alpha,0.25,0,0)
			else
				e.Color = Color(0.5,1,1,alpha,0,0,1)
			end
			if not e.IsFollowing then
				e:FollowParent(e.Parent)
				e.Position = e.Parent.Position
				e.Velocity = e.Parent.Velocity
				e.ParentOffset = Vector(0, -1)
			end
			if e.Parent:ToTear() or e.Parent:ToProjectile() then
				local p = e.Parent:ToTear() or e.Parent:ToProjectile()
				e.SpriteScale = Vector(1,1) * p.Scale
				e.SpriteOffset = Vector(0, 16 * p.Scale)
			elseif e.Parent:ToBomb() then
				local p = e.Parent:ToBomb()
				local scale = p:GetScale() * 1.35
				if p.Variant == BombVariant.BOMB_ROCKET then
					e.SpriteOffset = p.SpriteOffset + Vector(0, 16) * scale
				else
					e.SpriteOffset = p.SpriteOffset + Vector(1, 11) * scale
				end
				e.SpriteScale = Vector(1,1) * scale
			elseif e.Parent.Type == EntityType.ENTITY_FAMILIAR and e.Parent.Variant == mod.ITEM.FAMILIAR.PLANET_X then
				local scale = e.Parent.Size / 7
				e.SpriteScale = Vector(1,1) * scale
				e.SpriteOffset = Vector(0, 16 * scale)
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_EFFECT_RENDER, mod.impSodaCritZap, 1737)
