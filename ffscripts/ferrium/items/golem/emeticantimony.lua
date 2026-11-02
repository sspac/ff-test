local mod = FiendFolio
local sfx = SFXManager()

local function SetInnateIpecac(player, count)
	player:SetInnateCollectibleCount(CollectibleType.COLLECTIBLE_IPECAC, count, "FF_EMETIC_ANTIMONY")
end

function mod:emeticAntimonyUpdate(player)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.EMETIC_ANTIMONY) then
		local data = mod:GetEntityData(player)
		
		local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.EMETIC_ANTIMONY)
		if not data.emeticAntimonyTimer then
			data.emeticAntimonyTimer = 41
		end
		
		if data.emeticAntimonyTimer > 0 then
			data.emeticAntimonyTimer = data.emeticAntimonyTimer-1
			if data.emeticAntimonyTimer < 60 and not data.emeticAntimonyWarning then
				data.emeticAntimonyWarning = true
				sfx:Play(SoundEffect.SOUND_VAMP_GULP, 1, 0, false, 0.85)
			end
		else
			if data.emeticAntimonyWarning == true then
				sfx:Play(SoundEffect.SOUND_BEEP, 1, 0, false, 0.85)
				data.emeticAntimonyWarning = false
				data.emeticFlash = 5
				data.emeticAntimonyReady = true
				if not player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) then
					SetInnateIpecac(player, 1)
				end
			end
			
			if data.emeticAntimonyReady == false then
				SetInnateIpecac(player, 0)
				data.emeticAntimonyWarning = false
				data.emeticAntimonyTimer = 500-math.min(400, 50*mult)
			end
		end
		
		if data.emeticFlash then
			if data.emeticFlash > 0 then
				data.emeticFlash = data.emeticFlash-1
				player.Color = Color.Lerp(player.Color, Color(1,1,1,1,0.2,1,0.2), 0.2)
			else
				player.Color = Color(1,1,1,1,0,0,0)
				data.emeticFlash = nil
			end
		end
	end
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, FiendFolio.ITEM.ROCK.EMETIC_ANTIMONY, mod.emeticAntimonyUpdate)

mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, function(_, player)
	if not player:HasTrinket(FiendFolio.ITEM.ROCK.EMETIC_ANTIMONY) then
		SetInnateIpecac(player, 0)
	end
end, FiendFolio.ITEM.ROCK.EMETIC_ANTIMONY)

mod:AddCallback(FiendFolio.CALLBACK.FF_SECONDARY_FIRE_INCLUDE_LUDO_IN_CLEARED_ROOM, function(_, player, dir, amount, owner, params)
	mod.scheduleForUpdate(function()
		local weaponType = params.WeaponType
		if weaponType == WeaponType.WEAPON_KNIFE or weaponType == WeaponType.WEAPON_ROCKETS or weaponType == WeaponType.WEAPON_URN_OF_SOULS then
			return
		end
		if weaponType == WeaponType.WEAPON_BONE then
			for _, knife in ipairs(Isaac.FindByType(EntityType.ENTITY_KNIFE)) do
				local var = knife.Variant
				if (var == KnifeVariant.BONE_CLUB or var == KnifeVariant.BONE_SCYTHE or var == KnifeVariant.DONKEY_JAWBONE) and 
				   knife.Parent and GetPtrHash(knife.Parent) == GetPtrHash(owner) and knife:ToKnife():IsFlying()
				then
					return
				end
			end
		end
		if params.IsSpinAttack then
			return
		end
		
		local data = mod:GetEntityData(player)
		if data.emeticAntimonyReady then
			data.emeticAntimonyReady = false
		end
	end, 1)
end)

function mod:emeticAntimonyOnFireLaser(player, laser)
	if mod:GetEntityData(player).emeticAntimonyReady then
		mod:GetEntityData(laser).forceEmetic = true
	end
end

-- need this so tech x and brimstone dont lose the ipecac effect after the first frame
local forceEmetic = false
mod:AddPriorityCallback(ModCallbacks.MC_PRE_LASER_UPDATE, math.huge, function(_, laser)
	if mod:GetEntityData(laser).forceEmetic then
		forceEmetic = true
	end
end)

mod:AddCallback(ModCallbacks.MC_EVALUATE_TEAR_HIT_PARAMS, function(_, player, tearparams, weapon, damagescale, displacement, source)
	if forceEmetic then
		tearparams.TearFlags = tearparams.TearFlags | TearFlags.TEAR_POISON | TearFlags.TEAR_EXPLOSIVE
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, function(_, laser)
	forceEmetic = false
end)
