local mod = FiendFolio
local game = Game()

local tearcolor = Color(0.7, 0.7, 0.7, 1, 0, 0, 0, 0.5, 0.5, 0.5, 1)
local lasercolor = Color(1, 1, 1, 1, 0, 0, 0, 3, 3, 3, 1)

local flag = TearFlagsLib.RegisterTearFlag("GALLIUM")

function mod:galliumLaserColor(player, flag)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.CHUNK_OF_GALLIUM) then
		player.LaserColor = player.LaserColor * lasercolor
	end
end
mod:AddTrinketCallback(ModCallbacks.MC_EVALUATE_CACHE, FiendFolio.ITEM.ROCK.CHUNK_OF_GALLIUM, mod.galliumLaserColor, CacheFlag.CACHE_TEARCOLOR)

function mod:preventRemovingGalliumFlag(entity, player, flag)
	local params = TearFlagsLib.GetTearFlagParams(entity, flag)
	if params.NoRemove then
		return true
	end
end
mod:AddCallback(TearFlagsLib.Callback.PRE_REMOVE_TEARFLAG, mod.preventRemovingGalliumFlag, flag)

local checkingForRockets = {}
function mod:galliumFlagGeneric(entity, player, weaponFlag)
	if weaponFlag == TearFlagsLib.WeaponFlag.KNIFE then return end
	
	if weaponFlag == TearFlagsLib.WeaponFlag.EPIC_FETUS then
		local target
		if mod.CurrentRocketTarget then
			target = mod.CurrentRocketTarget
		elseif #checkingForRockets > 0 then
			target = checkingForRockets[#checkingForRockets]
		end
		if target and TearFlagsLib.HasTearFlags(target, flag) then
			TearFlagsLib.AddTearFlags(entity, flag)
			mod:GetEntityData(entity).FFExplosionColor = tearcolor
		end
	elseif player:HasTrinket(FiendFolio.ITEM.ROCK.CHUNK_OF_GALLIUM) then
		local mult = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.CHUNK_OF_GALLIUM)
		local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.CHUNK_OF_GALLIUM)
		local chance = 15*mult+mod.XalumLuckBonus(player.Luck, 20, 0.3)*100

		if rng:RandomInt(100) < chance then
			TearFlagsLib.AddTearFlags(entity, flag)
			
			if weaponFlag == TearFlagsLib.WeaponFlag.CLUB then
				mod.scheduleForUpdate(function()
					local capsulePosition, capsuleRadius = TearFlagsLib.GetSwingingKnifeCapsulePositionRadius(entity)
					mod:spawnGalliumCreep(entity, capsulePosition, math.max(0.2, (math.random() * 1/6 + 4/3) * capsuleRadius / 32))
				end, 3)
				entity.Color = tearcolor
			elseif weaponFlag == TearFlagsLib.WeaponFlag.AQUARIUS then
				mod:GetEntityData(entity).FFAquariusTearColor = tearcolor
			elseif weaponFlag == TearFlagsLib.WeaponFlag.EPIC_FETUS or weaponFlag == TearFlagsLib.WeaponFlag.CLUB_EPIC_FETUS then
				mod:GetEntityData(entity).FFExplosionColor = tearcolor
			elseif weaponFlag == TearFlagsLib.WeaponFlag.LASER or 
			       weaponFlag == TearFlagsLib.WeaponFlag.ANTI_GRAV_LASER or 
			       weaponFlag == TearFlagsLib.WeaponFlag.DARK_ARTS or
			       weaponFlag == TearFlagsLib.WeaponFlag.LOCUST or
			       weaponFlag == TearFlagsLib.WeaponFlag.UMBILICAL_WHIP or
			       weaponFlag == TearFlagsLib.WeaponFlag.BRIMSTONE_BALL or
			       weaponFlag == TearFlagsLib.WeaponFlag.BOBS_ROTTEN_HEAD or
			       weaponFlag == TearFlagsLib.WeaponFlag.SHARP_KEY or
			       weaponFlag == TearFlagsLib.WeaponFlag.OCULAR_RIFT or
			       weaponFlag == TearFlagsLib.WeaponFlag.HEMOPTYSIS
			then
				return
			else
				entity.Color = tearcolor
			end
		end
	end
end
mod:AddTrinketCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, FiendFolio.ITEM.ROCK.CHUNK_OF_GALLIUM, mod.galliumFlagGeneric)

function mod:galliumFlagKnife(knife, player)
	-- this isn't how effects are usually polled for knives but i'll make an exception for this
	if player:HasTrinket(FiendFolio.ITEM.ROCK.CHUNK_OF_GALLIUM) then
		local mult = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.CHUNK_OF_GALLIUM)
		local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.CHUNK_OF_GALLIUM)
		local chance = 15*mult+mod.XalumLuckBonus(player.Luck, 20, 0.3)*100

		if rng:RandomInt(100) < chance then
			TearFlagsLib.AddTearFlags(knife, flag)
			TearFlagsLib.SetTearFlagParams(knife, flag, {NoRemove = true})
		end
	end
end

function mod:spawnGalliumCreep(ent, pos, scale)
	local creep = Isaac.Spawn(1000, EffectVariant.PLAYER_CREEP_BLACK, 0, pos, Vector.Zero, TearFlagsLib.GetTearPlayer(ent) or ent):ToEffect()
	creep.Color = Color(1, 1, 1, 1, 0.45, 0.45, 0.45)
	creep.Scale = scale or creep.Scale
	creep:Update()
	
	creep.Scale = creep.Size / 20
	creep.SpriteScale = Vector(1,1) * creep.Scale
	if 42 <= creep.Size then
		creep:GetSprite():SetFrame("BiggestBlood0"..math.random(6), 0)
		creep.Scale = creep.Scale * 28/88
		creep.SpriteScale = creep.SpriteScale * 28/88
	elseif 26 <= creep.Size then
		creep:GetSprite():SetFrame("BigBlood0"..math.random(6), 0)
		creep.Scale = creep.Scale * 28/44
		creep.SpriteScale = creep.SpriteScale * 28/44
	elseif 19.8 <= creep.Size then
		creep:GetSprite():SetFrame("Blood0"..math.random(6), 0)
	else
		creep:GetSprite():SetFrame("SmallBlood0"..math.random(6), 0)
		creep.Scale = creep.Scale * 28/22
		creep.SpriteScale = creep.SpriteScale * 28/22
	end
end

function mod:updateGalliumEffect(ent)
	if TearFlagsLib.HasTearFlags(ent, flag) then
		local typ = ent.Type
		if ent.Type == EntityType.ENTITY_KNIFE then
			if ent:IsFlying() and ent.FrameCount % 2 == 0 then
				local size = ent.Size / 20.0
				if not TearFlagsLib.IsKnifeSwingable(ent) then
					size = size * 2
				end
				mod:spawnGalliumCreep(ent, ent.Position, math.max(0.2, size))
			end
		elseif ent.Type == EntityType.ENTITY_EFFECT then
			if ent.Variant == EffectVariant.SMALL_ROCKET then
				if Isaac.CountEntities(nil, 1000, EffectVariant.PLAYER_CREEP_BLACK, -1) < 100 or ent.FrameCount % 3 == 0 then
					mod:spawnGalliumCreep(ent, ent.Position, 0.8)
				end
			elseif ent.Variant == EffectVariant.TECH_DOT then
				if Isaac.CountEntities(nil, 1000, EffectVariant.PLAYER_CREEP_BLACK, -1) < 100 or ent.FrameCount % 3 == 0 then
					mod:spawnGalliumCreep(ent, ent.Position, 0.33 * math.max(ent.SpriteScale.X, ent.SpriteScale.Y))
				end
			elseif ent.Variant == EffectVariant.BRIMSTONE_SWIRL then
				if Isaac.CountEntities(nil, 1000, EffectVariant.PLAYER_CREEP_BLACK, -1) < 100 or ent.FrameCount % 3 == 0 then
					mod:spawnGalliumCreep(ent, ent.Position, 30 * ent.SpriteScale.X * ent:GetSprite():GetLayerFrameData(0):GetScale().X / 20)
				end
			else
				if Isaac.CountEntities(nil, 1000, EffectVariant.PLAYER_CREEP_BLACK, -1) < 100 or ent.FrameCount % 3 == 0 then
					mod:spawnGalliumCreep(ent, ent.Position, math.max(0.2, ent.Size / 20.0))
				end
			end
		elseif ent.Type == EntityType.ENTITY_TEAR then
			if Isaac.CountEntities(nil, 1000, EffectVariant.PLAYER_CREEP_BLACK, -1) < 100 or ent.FrameCount % 3 == 0 then
				mod:spawnGalliumCreep(ent, ent.Position, math.max(0.2, ent.Scale - 0.5))
			end
		else
			if Isaac.CountEntities(nil, 1000, EffectVariant.PLAYER_CREEP_BLACK, -1) < 100 or ent.FrameCount % 3 == 0 then
				mod:spawnGalliumCreep(ent, ent.Position, math.max(0.2, ent.Size / 20.0))
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, mod.updateGalliumEffect)
mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, mod.updateGalliumEffect)
mod:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, mod.updateGalliumEffect)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.updateGalliumEffect, EffectVariant.SMALL_ROCKET)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.updateGalliumEffect, EffectVariant.TECH_DOT)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.updateGalliumEffect, EffectVariant.BRIMSTONE_SWIRL)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.updateGalliumEffect, EffectVariant.BRIMSTONE_BALL)

function mod:galliumExplode(pos, damage, radius, lineCheck, source, tearflags, damageflags, damageSource)
	-- id do this in tearflags but that seems to have a stupid radius for ipecac
	if source and TearFlagsLib.HasTearFlags(source, flag) then
		mod:spawnGalliumCreep(source, pos, math.max(0.2, radius / 20))
	end
end
mod:AddCallback(ModCallbacks.MC_POST_BOMB_DAMAGE, mod.galliumExplode)

function mod:galliumSword(sword)
	if sword.SubType == 4 or not TearFlagsLib.IsEntitySpiritSword(sword) then return end
	
	if sword:GetIsSwinging() then
		if TearFlagsLib.HasTearFlags(sword, flag) then
			local capsule = mod:getSwordCapsules(sword)
			local capsuleStart, capsuleEnd = capsule:GetVec2(), capsule:GetVec3()
			local dir = capsuleStart - capsuleEnd
			local dist = dir:Length()
			if dist > 0 then
				local distRemaining = dist + capsule:GetF1() * 2
				while distRemaining > 0 do
					mod:spawnGalliumCreep(sword, capsuleEnd + dir:Resized(dist - distRemaining + capsule:GetF1()), 0.75)
					distRemaining = distRemaining - 20
				end
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, mod.galliumSword)

function mod:galliumAquarius(creep)
	if TearFlagsLib.HasTearFlags(creep, flag) then
		creep:AddTearFlags(TearFlags.TEAR_SLOW)
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_EFFECT_UPDATE, mod.galliumAquarius, EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL)

function mod:galliumLaser(laser)
	local hasGallium = TearFlagsLib.HasTearFlags(laser, flag)
	local data = mod:GetEntityData(laser)
	if hasGallium and (laser.FrameCount <= 1 or not laser.OneHit) and not data.DidGalliumOneShot then
		if Isaac.CountEntities(nil, 1000, EffectVariant.PLAYER_CREEP_BLACK, -1) < 100 or laser.FrameCount % 3 == 0 then
			local samples = TearFlagsLib.GetLaserSampleCapsules(laser)
			local distToUse = 0
			local creepScale = math.max(0.2, laser.Size / 20)
			for _, sample in ipairs(samples) do
				local locus1 = sample.Locus1
				local locus2 = sample.Locus2
				local distRemaining = locus1:Distance(locus2)
				local usedDist = 0
				while (distRemaining > 0) do
					local distUsing = math.min(distToUse, distRemaining)
					usedDist = usedDist + distUsing
					distRemaining = distRemaining - distUsing
					distToUse = distToUse - distUsing
					if distToUse <= 0 then
						mod:spawnGalliumCreep(laser, locus1 + (locus2 - locus1):Resized(usedDist), creepScale)
						distToUse = distToUse + creepScale * 20
					end
				end
				data.DidGalliumOneShot = laser.OneHit
			end
		end
	end
	if not hasGallium then
		data.DidGalliumOneShot = nil
	end
end
mod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, mod.galliumLaser)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_EFFECT_UPDATE, math.huge, function(_, target)
	table.insert(checkingForRockets, target)
end, EffectVariant.TARGET)

mod:AddPriorityCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, -1 * math.huge, function(_, target)
	for i = #checkingForRockets, 1, -1 do
		local entity = checkingForRockets[i]
		table.remove(checkingForRockets, i)
		if GetPtrHash(target) == GetPtrHash(entity) then
			break
		end
	end
end, EffectVariant.TARGET)

function mod:galliumEpicFetus(target)
	if not target:Exists() then return end
	
	local data = mod:GetEntityData(target)
	if not data.RolledForGallium then
		local player = TearFlagsLib.GetTearPlayer(target)
		if player and player:HasTrinket(FiendFolio.ITEM.ROCK.CHUNK_OF_GALLIUM) then
			local mult = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.CHUNK_OF_GALLIUM)
			local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.CHUNK_OF_GALLIUM)
			local chance = 15*mult+mod.XalumLuckBonus(player.Luck, 20, 0.3)*100

			if rng:RandomInt(100) < chance then
				TearFlagsLib.AddTearFlags(target, flag)
			end
		end
		data.RolledForGallium = true
	end

	if TearFlagsLib.HasTearFlags(target, flag) and target.FrameCount % 2 == 0 then
		mod:spawnGalliumCreep(target, target.Position, target.SpriteScale.X)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.galliumEpicFetus, EffectVariant.TARGET)