local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local fetalFriend = mod.ITEM.COLLECTIBLE.FETAL_FRIEND
local fetalFlags = CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_SHOTSPEED | CacheFlag.CACHE_DAMAGE

mod.FriendBulletFlags = mod.FriendBulletFlags or {}
mod.FriendBulletFlags.FETAL_FRIEND = TearFlagsLib.RegisterTearFlag("FETAL_FRIEND")

function mod:PreventRemovingFetalFriendFlag(entity, player, flag)
	if TearFlagsLib.GetTearFlagParams(entity, flag).NoRemove then
		return true
	end
end
mod:AddCallback(TearFlagsLib.Callback.PRE_REMOVE_TEARFLAG, mod.PreventRemovingFetalFriendFlag, mod.FriendBulletFlags.FETAL_FRIEND)

local function getDefaultGunMetadata()
	return {
		timeUntilReload = -1,
		reloadCooldown = -1,
		isReloading = false,
	}
end

function mod:ShouldMimicFriendBehaviour(player)
	return (
		player:HasCollectible(fetalFriend) and
		player:GetPlayerType() ~= mod.PLAYER.FRIEND and
		player:GetPlayerType() ~= mod.PLAYER.BRIEND
	)
end

function mod.HasFetalFriendAmmo(player)
	local data = mod:GetEntityData(player)

	if player:GetPlayerType() == mod.PLAYER.FRIEND then
		if data.FriendsRevolver then
			return #data.FriendHeldGuns[data.FriendsRevolver.InitSeed].Ammo > 0
		end
	else
		data.fetalGunMimic = data.fetalGunMimic or mod:GetFriendAmmo(player)
		return #data.fetalGunMimic > 0
	end

	return false
end

function mod.FireFetalFriendGun(player, reloadDelay)
	local data = mod:GetEntityData(player)
	data.fetalGunMimic = data.fetalGunMimic or mod:GetFriendAmmo(player)
	data.fetalGunData = data.fetalGunData or getDefaultGunMetadata()
	data.fetalGunData.timeUntilReload = math.max(data.fetalGunData.timeUntilReload or 0, math.max(30, math.floor(player.MaxFireDelay * 1.5)) + (reloadDelay or 0)) -- This definitely isn't how Friend does it
	data.fetalGunData.isReloading = false

	if #data.fetalGunMimic > 0 then
		local targetAmmo = mod:makeCopiedTable(data.fetalGunMimic[#data.fetalGunMimic])

        if (targetAmmo.OverlayKeys and targetAmmo.OverlayKeys["FOOLS_GOLD_HEART"] and targetAmmo.LastInHeart) then
            if math.random() <= mod.FriendBalancing.FoolsGoldChance then
                targetAmmo.ForceImmoral = false
                targetAmmo.ForceGold = true
            else
                targetAmmo.ForceGold = false
                targetAmmo.ForceImmoral = true
            end
        end
		
		data.fetalGunData.LastUsedAmmo = targetAmmo
		
		if not Isaac.RunCallback("PRE_FETAL_FRIEND_FIRE_CONSUME_AMMO", data.fetalGunData, player, targetAmmo) then
			targetAmmo.ShakeTimer = {2, 2}
			data.FriendHeartsJustFired = data.FriendHeartsJustFired or {}
			data.FriendHeartsJustFired[targetAmmo.Index] = targetAmmo
			
			if not targetAmmo.ForceGold and (not (targetAmmo.OverlayKeys and targetAmmo.OverlayKeys["GOLDEN_HEART"] and targetAmmo.LastInHeart) or mod:RandomFloat() > mod.FriendBalancing.GoldHeartChance) then
				data.fetalGunMimic[#data.fetalGunMimic] = nil
				if targetAmmo.OverlayKeys then
					targetAmmo.OverlayKeys["GOLDEN_HEART"] = nil
				end
				
                -- Use the full heart
                if targetAmmo.ForceImmoral then
                    data.fetalGunMimic[#data.fetalGunMimic] = nil
                end
			end
		end
		
		targetAmmo.Crit = (targetAmmo.HeartKey == "IMMORAL_HEART" or targetAmmo.ForceImmoral) and mod:RandomInt(100) < mod:GetFriendCritChance(player)

		if #data.fetalGunMimic == 0 then
			player:AddCacheFlags(fetalFlags, true)
		end
		
		data.FetalGunLastFrameFired = game:GetFrameCount()
	else
		data.fetalGunData.LastUsedAmmo = {Index = 1, HeartKey = "RED_HEART", LastInHeart = true, HealthPosition = {1, 1}, HeartType = "Red"}
	end
end

local function getWeaponPlayer(entity)
	if entity:ToPlayer() then
		return entity:ToPlayer()
	elseif entity:ToFamiliar() and TearFlagsLib.IsFamiliarPlayerMimic(entity) then
		return entity:ToFamiliar().Player
	end
end

local function reload(player, target, data)
	local copyAmmo = mod:makeCopiedTable(target)
	copyAmmo.ReloadTimer = 3
	copyAmmo.ShakeTimer = {2, 2}
	data.FriendHeartsJustReloaded = data.FriendHeartsJustReloaded or {}
	data.FriendHeartsJustReloaded[copyAmmo.Index] = copyAmmo

	table.insert(data.fetalGunMimic, target)
	sfx:Play(SoundEffect.SOUND_SCAMPER, 0.5, 0, false, math.random(190, 210) / 100)

	if #data.fetalGunMimic == 1 then
		player:AddCacheFlags(fetalFlags, true)
	end
end

local function shouldGrantPlayerTemporaryHoming(player, data)
	if player:HasWeaponType(WeaponType.WEAPON_ROCKETS) then
		local data = data or mod:GetEntityData(player)
		return (
			#data.fetalGunMimic > 0 and
			data.fetalGunMimic[#data.fetalGunMimic].OverlayKeys and 
			((data.fetalGunMimic[#data.fetalGunMimic].OverlayKeys["ETERNAL_HEART"] and data.fetalGunMimic[#data.fetalGunMimic].LastInHeart) or data.fetalGunMimic[#data.fetalGunMimic].OverlayKeys["STEVEN_HEART"]) and
			player.TearFlags ~= player.TearFlags | TearFlags.TEAR_HOMING
		)
	end
end

mod.RerollFetalFriendAmmo = false
mod.OverrideFetalFriendAmmo = nil
function mod.GetLastFetalFriendAmmo(player)
	local data = mod:GetEntityData(player)
	if data.fetalGunData then
		local shot = mod.OverrideFetalFriendAmmo or data.fetalGunData.LastUsedAmmo
		if mod.RerollFetalFriendAmmo and (shot.HeartKey == "IMMORAL_HEART" or shot.ForceImmoral) then
			local newshot = mod:makeCopiedTable(shot)
			newshot.Crit = mod:RandomInt(100) < mod:GetFriendCritChance(player)
			shot = newshot
		end
		return shot or mod:makeCopiedTable(data.fetalGunMimic[#data.fetalGunMimic])
	end
end

local function shouldDoLudoEffect(player)
	return player:HasCollectible(CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE) and
	       not (player:HasWeaponType(WeaponType.WEAPON_BOMBS) or
		        player:HasWeaponType(WeaponType.WEAPON_ROCKETS) or
		        player:HasWeaponType(WeaponType.WEAPON_TECH_X) or
		        player:HasWeaponType(WeaponType.WEAPON_BONE) or
		        player:HasWeaponType(WeaponType.WEAPON_NOTCHED_AXE) or
		        player:HasWeaponType(WeaponType.WEAPON_SPIRIT_SWORD) or
		        player:HasWeaponType(WeaponType.WEAPON_FETUS))
end

function mod:TryFireFetalFriendGun(player, isFireDelayed, hasReloadDelay, isSwirl)
	if not mod.NoFireFetalFriend and player and mod:ShouldMimicFriendBehaviour(player) and not shouldDoLudoEffect(player) then
		local data = mod:GetEntityData(player)
		local lastFireFrame = data.lastFrameFiredFetalGun
		local frame = game:GetFrameCount()
		if not isFireDelayed or lastFireFrame == nil or frame - lastFireFrame > math.min(player.MaxFireDelay, mod.FriendBalancing.HoldFireCooldown) then
			if lastFireFrame == nil or frame ~= lastFireFrame then
				if not isSwirl then mod.FireFetalFriendGun(player, ((hasReloadDelay and 20) or 0)) end
				data.lastFrameFiredFetalGun = frame
				return true
			end
		end
	end
end

mod:AddPriorityCollectibleCallback(ModCallbacks.MC_POST_TRIGGER_WEAPON_FIRED, CallbackPriority.EARLY, fetalFriend, function(_, direction, amount, owner, weapon)
	local weaponType = weapon:GetWeaponType()
	if weaponType ~= WeaponType.WEAPON_BRIMSTONE and weaponType ~= WeaponType.WEAPON_ROCKETS and 
	   weaponType ~= WeaponType.WEAPON_URN_OF_SOULS and weaponType ~= WeaponType.WEAPON_UMBILICAL_WHIP and
	   weaponType ~= WeaponType.WEAPON_BONE and weaponType ~= WeaponType.WEAPON_NOTCHED_AXE and
	   weaponType ~= WeaponType.WEAPON_SPIRIT_SWORD
	then
		local player = getWeaponPlayer(owner)
		if player then
			mod:TryFireFetalFriendGun(player)
		end
	end
end)

mod:AddCollectibleCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, fetalFriend, function(_, player)
	if player:HasCollectible(fetalFriend) and shouldDoLudoEffect(player) then
		for i = ButtonAction.ACTION_SHOOTLEFT, ButtonAction.ACTION_SHOOTDOWN do
			if Input.IsActionTriggered(i, player.ControllerIndex) then
				mod.FireFetalFriendGun(player)
			end
		end
	end
end)

mod:AddCollectibleCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, fetalFriend, function(_, player)
	if not mod:ShouldMimicFriendBehaviour(player) then return end

	local data = mod:GetEntityData(player)
	data.fetalGunData = data.fetalGunData or getDefaultGunMetadata()
	
	local isFiring = false
	for i = ButtonAction.ACTION_SHOOTLEFT, ButtonAction.ACTION_SHOOTDOWN do
		if Input.IsActionPressed(i, player.ControllerIndex) then
			isFiring = not player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_URN_OF_SOULS)
			break
		end
	end
	if not isFiring and 
	   (not player:HasWeaponType(WeaponType.WEAPON_ROCKETS) or Isaac.CountEntities(player, EntityType.ENTITY_EFFECT, EffectVariant.TARGET) <= 0) and
	   Isaac.CountEntities(player, EntityType.ENTITY_EFFECT, EffectVariant.BRIMSTONE_SWIRL) <= 0 and
	   not data.binabaCuttingGazeHoldPoint
	then
		data.fetalGunData.timeUntilReload = math.max(-1, data.fetalGunData.timeUntilReload - 1)
		data.fetalGunData.reloadCooldown = math.max(-1, data.fetalGunData.reloadCooldown - 1)
	end

	if data.fetalGunData.timeUntilReload == 0 then
		data.fetalGunData.reloadCooldown = 0
		data.fetalGunData.isReloading = true
	end

	if data.fetalGunData.reloadCooldown <= 0 and data.fetalGunData.isReloading then
		local rawAmmo = mod:GetFriendAmmo(player)
		local targetAmmo = rawAmmo[#data.fetalGunMimic + 1]

		if targetAmmo then
			reload(player, targetAmmo, data)
		end

		if #data.fetalGunMimic >= #rawAmmo then
			data.fetalGunData.isReloading = false
		else
			data.fetalGunData.reloadCooldown = player.MaxFireDelay
		end
		data.timeUntilReload = -1 -- fixes frame perfect reload bug
	end

	if shouldGrantPlayerTemporaryHoming(player) then
		data.FriendEternalHoming = true
		data.FetalFriendTemporaryHoming = true
		player:AddCacheFlags(CacheFlag.CACHE_TEARFLAG, true)
	elseif data.FetalFriendTemporaryHoming then
		data.FriendEternalHoming = false
		data.FetalFriendTemporaryHoming = false
		player:AddCacheFlags(CacheFlag.CACHE_TEARFLAG, true)
	end
end)

mod:AddCollectibleCallback(ModCallbacks.MC_POST_NEW_ROOM, fetalFriend, function()
	mod.AnyPlayerDo(function(player)
		if mod:ShouldMimicFriendBehaviour(player) then
			local data = mod:GetEntityData(player)
			data.fetalGunMimic = data.fetalGunMimic or mod:GetFriendAmmo(player)
			
			local rawAmmo = mod:GetFriendAmmo(player)
			local targetAmmo = rawAmmo[#data.fetalGunMimic + 1]

			while targetAmmo do
				reload(player, targetAmmo, data)
				targetAmmo = rawAmmo[#data.fetalGunMimic + 1]
			end

			data.fetalGunData = data.fetalGunData or getDefaultGunMetadata()
			data.fetalGunData.isReloading = false
			data.fetalGunData.reloadCooldown = -1
			data.fetalGunData.timeUntilReload = -1
		end
	end)
end)

mod:AddCallback(ModCallbacks.MC_EVALUATE_STAT, function(_, player, _, og)
	if player:HasCollectible(fetalFriend) and not mod.HasFetalFriendAmmo(player) then
		local reduction = (1 - 1/(2 ^ player:GetCollectibleNum(fetalFriend))) * 0.6 -- Trust the process
		return og-reduction
	end
end, EvaluateStatStage.TEARS_UP)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, flag)
	if player:HasCollectible(fetalFriend) and mod.HasFetalFriendAmmo(player) then
		player.ShotSpeed = player.ShotSpeed + 0.3
	end
end, CacheFlag.CACHE_SHOTSPEED)

mod:AddCollectibleCallback(CustomHealthAPI.Enums.Callbacks.POST_ADD_HEALTH, fetalFriend, function(_, player)
    if mod:ShouldMimicFriendBehaviour(player) then
        local data = mod:GetEntityData(player)
        if data.fetalGunData then
            data.fetalGunMimic = mod:GetFriendAmmo(player, data.fetalGunMimic)
            data.fetalGunData.timeUntilReload = math.max(1, data.fetalGunData.timeUntilReload)
        end
    end
end)

mod:AddCollectibleCallback(CustomHealthAPI.Enums.Callbacks.POST_PLAYER_DAMAGE, fetalFriend, function(_, player)
    if mod:ShouldMimicFriendBehaviour(player) then
        local data = mod:GetEntityData(player)
        data.fetalGunMimic = mod:GetFriendAmmo(player, data.fetalGunMimic)
    end
end)

mod:AddCollectibleCallback(CustomHealthAPI.Enums.Callbacks.POST_LOAD_HEALTH_FROM_BACKUP, fetalFriend, function(_, player)
    if mod:ShouldMimicFriendBehaviour(player) then
        local data = mod:GetEntityData(player)
        data.fetalGunMimic = mod:GetFriendAmmo(player, data.fetalGunMimic)
    end
end)

mod:AddCollectibleCallback(CustomHealthAPI.Enums.Callbacks.PRE_HEALTH_RENDER, fetalFriend, function(_, player, playerSlot, healthIndex, info)
    if mod:ShouldMimicFriendBehaviour(player) then
        return mod:PreRenderFriendHeart(player, false, nil, playerSlot, healthIndex, info)
    end
end)

mod:AddPriorityCollectibleCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, -301, fetalFriend, function(_, entity, player, weaponFlag)
	if weaponFlag ~= TearFlagsLib.WeaponFlag.TEAR then return end
	if not mod:ShouldMimicFriendBehaviour(player) then return end
	local tear = entity:ToTear()
	local shot = mod.GetLastFetalFriendAmmo(player)
	local flat, mult, crit = mod:GetFriendShotDamageBonus(nil, player, shot)
	tear.CollisionDamage = (tear.CollisionDamage + flat) * mult
	TearFlagsLib.AddTearFlags(tear, mod.FriendBulletFlags.FETAL_FRIEND)
	TearFlagsLib.SetTearFlagParams(tear, mod.FriendBulletFlags.FETAL_FRIEND, {Shot = shot, NoRemove = true})
	mod:ApplyFriendTearShotEffects(tear, player, shot, crit)
end)

function mod:ApplyFetalFriendToBrimstone(laser)
	local player = TearFlagsLib.GetTearPlayer(laser)
	mod:TryFireFetalFriendGun(player, true)
	mod:ApplyFetalFriendToLaser(laser, true)
	TearFlagsLib.SetTearFlagParams(laser, mod.FriendBulletFlags.FETAL_FRIEND, {BrimShouldRefresh = true})
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_FIRE_BRIMSTONE, fetalFriend, mod.ApplyFetalFriendToBrimstone)

function mod:ApplyFetalFriendToLaser(laser, isBrim)
	local player = TearFlagsLib.GetTearPlayer(laser)
	if player and not mod:ShouldMimicFriendBehaviour(player) then return end
	local shot = mod.GetLastFetalFriendAmmo(player)
	local flat, mult, crit = mod:GetFriendShotDamageBonus(nil, player, shot)
	TearFlagsLib.AddTearFlags(laser, mod.FriendBulletFlags.FETAL_FRIEND)
	TearFlagsLib.SetTearFlagParams(laser, mod.FriendBulletFlags.FETAL_FRIEND, {Shot = shot, NoRemove = true})
	mod:ApplyFriendLaserShotEffects(laser, player, shot, crit)
	local color = laser.Color
	mod.scheduleForUpdate(function() -- fix frame 1 color flicker
		laser.Color = color
		if laser.Child then laser.Child.Color = laser.Color end
	end, 1, ModCallbacks.MC_PRE_RENDER)
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_FIRE_TECH_LASER, fetalFriend, mod.ApplyFetalFriendToLaser)

function mod:ApplyFetalFriendToTechX(laser)
	local player = TearFlagsLib.GetTearPlayer(laser)
	if player and not mod:ShouldMimicFriendBehaviour(player) then return end
	local shot = mod.GetLastFetalFriendAmmo(player)
	local flat, mult, crit = mod:GetFriendShotDamageBonus(nil, player, shot)
	TearFlagsLib.AddTearFlags(laser, mod.FriendBulletFlags.FETAL_FRIEND)
	TearFlagsLib.SetTearFlagParams(laser, mod.FriendBulletFlags.FETAL_FRIEND, {Shot = shot, NoRemove = true})
	mod:ApplyFriendLaserShotEffects(laser, player, shot, crit)
	local color = laser.Color
	mod.scheduleForUpdate(function() -- fix frame 1 color flicker
		laser.Color = color
		if laser.Child then laser.Child.Color = laser.Color end
	end, 1, ModCallbacks.MC_PRE_RENDER)
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_FIRE_TECH_X_LASER, fetalFriend, mod.ApplyFetalFriendToTechX)

mod:AddCallback(ModCallbacks.MC_PRE_EFFECT_UPDATE, function(_, techdot)
	local child = techdot.Child
	if child and TearFlagsLib.HasTearFlags(child, mod.FriendBulletFlags.FETAL_FRIEND) then
		local player = TearFlagsLib.GetTearPlayer(child)
		if player and not mod:ShouldMimicFriendBehaviour(player) then return end
		local shot = TearFlagsLib.GetTearFlagParams(child, mod.FriendBulletFlags.FETAL_FRIEND).Shot
		TearFlagsLib.AddTearFlags(techdot, mod.FriendBulletFlags.FETAL_FRIEND)
		TearFlagsLib.SetTearFlagParams(techdot, mod.FriendBulletFlags.FETAL_FRIEND, {Shot = shot, NoRemove = true})
		mod:ApplyFriendGenericShotEffects(techdot, player, shot, shot.Crit, true, true)
	end
end, EffectVariant.TECH_DOT)

function mod:UpdateFetalFriendSwirl(swirl)
	local child = mod:GetEntityData(swirl).FriendSwirlLaser
	if child and child:Exists() and TearFlagsLib.HasTearFlags(child, mod.FriendBulletFlags.FETAL_FRIEND) then
		local player = TearFlagsLib.GetTearPlayer(child)
		if player and not mod:ShouldMimicFriendBehaviour(player) then return end
		local shot = TearFlagsLib.GetTearFlagParams(child, mod.FriendBulletFlags.FETAL_FRIEND).Shot
		TearFlagsLib.AddTearFlags(swirl, mod.FriendBulletFlags.FETAL_FRIEND)
		TearFlagsLib.SetTearFlagParams(swirl, mod.FriendBulletFlags.FETAL_FRIEND, {Shot = shot, NoRemove = true})
		mod:ApplyFriendGenericShotEffects(swirl, player, shot, shot.Crit, true, true)
		swirl.Color = mod:GetFriendShotLaserColor(swirl, player)
	end
end

mod:AddPriorityCallback(ModCallbacks.MC_PRE_LASER_UPDATE, CallbackPriority.EARLY, function(_, laser)
	if TearFlagsLib.HasTearFlags(laser, mod.FriendBulletFlags.FETAL_FRIEND) and TearFlagsLib.GetTearFlagParams(laser, mod.FriendBulletFlags.FETAL_FRIEND).BrimShouldRefresh then
		local parent = laser.Parent
		if parent and parent.Type == EntityType.ENTITY_EFFECT and parent.Variant == EffectVariant.BRIMSTONE_SWIRL then
			if not parent:GetSprite():WasEventTriggered("Shoot") then
				mod:GetEntityData(laser).WasSwirlPreventingFetalFriendFiring = true
				return
			end
		end
		local player = TearFlagsLib.GetTearPlayer(laser)
		if player then
			local fired = mod:TryFireFetalFriendGun(player, true, nil, mod:GetEntityData(laser).WasSwirlPreventingFetalFriendFiring)
			local shot = mod.GetLastFetalFriendAmmo(player)
			TearFlagsLib.SetTearFlagParams(laser, mod.FriendBulletFlags.FETAL_FRIEND, {Shot = shot, NoRemove = true})
			local flat, mult, crit = mod:GetFriendShotDamageBonus(nil, player, shot)
			if fired then 
				mod:ApplyFriendLaserShotEffects(laser, player, shot, crit, true)
				
				local data = mod:GetEntityData(laser)
				if data.FriendLaserSwirl and data.FriendLaserSwirl:Exists() then
					mod:UpdateFetalFriendSwirl(data.FriendLaserSwirl)
				end
				data.WasSwirlPreventingFetalFriendFiring = nil
			end
			if laser.Child then laser.Child.Color = laser.Color end
		end
	end
end)

function mod:ApplyFetalFriendToDrFetus(entity, player, weaponFlag)
	if weaponFlag ~= TearFlagsLib.WeaponFlag.DR_FETUS then return end
	if not mod:ShouldMimicFriendBehaviour(player) then return end
	local bomb = entity:ToBomb()
	local shot = mod.GetLastFetalFriendAmmo(player)
	local flat, mult, crit = mod:GetFriendShotDamageBonus(nil, player, shot)
	bomb.ExplosionDamage = (bomb.ExplosionDamage + flat * 10) * mult
	TearFlagsLib.AddTearFlags(bomb, mod.FriendBulletFlags.FETAL_FRIEND)
	TearFlagsLib.SetTearFlagParams(bomb, mod.FriendBulletFlags.FETAL_FRIEND, {Shot = shot})
	mod:ApplyFriendBombShotEffects(bomb, player, shot, crit)
end
mod:AddPriorityCollectibleCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, -301, fetalFriend, mod.ApplyFetalFriendToDrFetus)

function mod:ApplyFetalFriendToEpicFetus(rocket)
	local player = TearFlagsLib.GetTearPlayer(rocket)
	if player and not mod:ShouldMimicFriendBehaviour(player) then return end
	mod:TryFireFetalFriendGun(player)
	local shot = mod.GetLastFetalFriendAmmo(player)
	TearFlagsLib.AddTearFlags(rocket, mod.FriendBulletFlags.FETAL_FRIEND)
	TearFlagsLib.SetTearFlagParams(rocket, mod.FriendBulletFlags.FETAL_FRIEND, {Shot = shot})
	mod:ApplyFriendGenericShotEffects(rocket, player, shot, shot.Crit)
    local d = mod:GetEntityData(rocket)
	d.FFExplosionColor = mod:GetFriendShotTearColor(rocket)
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_EFFECT_INIT, fetalFriend, mod.ApplyFetalFriendToEpicFetus, EffectVariant.ROCKET)

function mod:ApplyFetalFriendToGello(familiar)
	local player = TearFlagsLib.GetTearPlayer(familiar)
	if player and not mod:ShouldMimicFriendBehaviour(player) then return end
	mod:TryFireFetalFriendGun(player, nil, true)
	local shot = mod.GetLastFetalFriendAmmo(player)
	TearFlagsLib.AddTearFlags(familiar, mod.FriendBulletFlags.FETAL_FRIEND)
	TearFlagsLib.SetTearFlagParams(familiar, mod.FriendBulletFlags.FETAL_FRIEND, {Shot = shot})
	mod:ApplyFriendGenericShotEffects(familiar, player, shot, shot.Crit)
end
mod:AddCollectibleCallback(ModCallbacks.MC_FAMILIAR_INIT, fetalFriend, mod.ApplyFetalFriendToGello, FamiliarVariant.UMBILICAL_BABY)

function mod:ApplyFetalFriendToKnife(knife)
	local player = TearFlagsLib.GetTearPlayer(knife)
	if player and not mod:ShouldMimicFriendBehaviour(player) then return end
	local shot = mod.GetLastFetalFriendAmmo(player)
	TearFlagsLib.AddTearFlags(knife, mod.FriendBulletFlags.FETAL_FRIEND)
	TearFlagsLib.SetTearFlagParams(knife, mod.FriendBulletFlags.FETAL_FRIEND, {Shot = shot, NoRemove = true})
	mod:ApplyFriendGenericShotEffects(knife, player, shot, shot.Crit, true)
end

local nextClubLaserColor = nil
function mod:ApplyFetalFriendToClub(hitbox)
	local parent = hitbox:GetHitboxParentKnife()
	if not parent then return end
	local player = TearFlagsLib.GetTearPlayer(parent)
	if player and not mod:ShouldMimicFriendBehaviour(player) then return end
	mod:TryFireFetalFriendGun(player)
	local shot = mod.GetLastFetalFriendAmmo(player)
	TearFlagsLib.AddTearFlags(hitbox, mod.FriendBulletFlags.FETAL_FRIEND)
	TearFlagsLib.SetTearFlagParams(hitbox, mod.FriendBulletFlags.FETAL_FRIEND, {Shot = shot})
	mod:ApplyFriendGenericShotEffects(hitbox, player, shot, shot.Crit)
	if nextClubLaserColor then
		mod:GetEntityData(parent).FFBrimballLaserColor = nextClubLaserColor
		mod:GetEntityData(parent).FFSwungWithBrimballAt = parent.FrameCount
		nextClubLaserColor = nil
	end
end

-- clubs do a weird thing where they flash the laser color after firing a brimball 
-- and frankly without actually setting the player lasercolor to match the brimball color this looks bad
-- hence this nonsense
local doInterpNextRenderFrame = false
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	nextClubLaserColor = nil
	doInterpNextRenderFrame = true
end)

mod:AddCallback(ModCallbacks.MC_PRE_KNIFE_RENDER, function(_, knife)
	if doInterpNextRenderFrame and Isaac.GetFrameCount() % 2 == 1 and mod:GetEntityData(knife).FFBrimballLaserColor then
		local tearcolor = knife.Color
		local lasercolor = mod:GetEntityData(knife).FFBrimballLaserColor
		lasercolor.G = 0
		lasercolor.B = 0
		
		local frame = knife.FrameCount - mod:GetEntityData(knife).FFSwungWithBrimballAt + 1
		knife:GetSprite().Color = Color.Lerp(lasercolor, tearcolor, math.min(1, frame / 18))
		if frame >= 18 then
			mod:GetEntityData(knife).FFBrimballLaserColor = nil
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
	if Isaac.GetFrameCount() % 2 == 1 then
		doInterpNextRenderFrame = false
	end
end)

function mod:ApplyFetalFriendToClubEpicFetus(rocket)
	local player = TearFlagsLib.GetTearPlayer(rocket)
	if player and not mod:ShouldMimicFriendBehaviour(player) then return end
	local shot = mod.GetLastFetalFriendAmmo(player)
	TearFlagsLib.AddTearFlags(rocket, mod.FriendBulletFlags.FETAL_FRIEND)
	TearFlagsLib.SetTearFlagParams(rocket, mod.FriendBulletFlags.FETAL_FRIEND, {Shot = shot})
	mod:ApplyFriendGenericShotEffects(rocket, player, shot, shot.Crit)
    local d = mod:GetEntityData(rocket)
	d.FFExplosionColor = mod:GetFriendShotTearColor(rocket)
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_EFFECT_INIT, fetalFriend, mod.ApplyFetalFriendToClubEpicFetus, EffectVariant.SMALL_ROCKET)

function mod:ApplyFetalFriendToBrimstoneBall(brimball)
	local player = TearFlagsLib.GetTearPlayer(brimball)
	if player and not mod:ShouldMimicFriendBehaviour(player) then return end
	mod:TryFireFetalFriendGun(player)
	local shot = mod.GetLastFetalFriendAmmo(player)
	TearFlagsLib.AddTearFlags(brimball, mod.FriendBulletFlags.FETAL_FRIEND)
	TearFlagsLib.SetTearFlagParams(brimball, mod.FriendBulletFlags.FETAL_FRIEND, {Shot = shot, NoRemove = true})
	mod:ApplyFriendGenericShotEffects(brimball, player, shot, shot.Crit, true)
	if REPENTOGON.MeetsVersion("1.1.2") and (TearFlagsLib.HasTearFlags(brimball, mod.FriendBulletFlags.ETERNAL) or TearFlagsLib.HasTearFlags(brimball, mod.FriendBulletFlags.STEVEN)) then
		brimball:AddTearFlags(TearFlags.TEAR_HOMING)
	end
	local color, hadColor = mod:GetFriendShotLaserColor(brimball, player)
	if hadColor then
		brimball.Color = color
		nextClubLaserColor = color
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_FIRE_BRIMSTONE_BALL, fetalFriend, mod.ApplyFetalFriendToBrimstoneBall)

function mod:ApplyFetalFriendToSword(entity, player, weaponFlag)
	if weaponFlag ~= TearFlagsLib.WeaponFlag.SWORD then return end
	local player = player or TearFlagsLib.GetTearPlayer(entity)
	if player and not mod:ShouldMimicFriendBehaviour(player) then return end
	local knife = entity:ToKnife()
	mod:TryFireFetalFriendGun(player, nil, true)
	local shot = mod.GetLastFetalFriendAmmo(player)
	local flat, mult, crit = mod:GetFriendShotDamageBonus(nil, player, shot)
	entity.CollisionDamage = (entity.CollisionDamage + flat) * mult
	TearFlagsLib.AddTearFlags(knife, mod.FriendBulletFlags.FETAL_FRIEND)
	TearFlagsLib.SetTearFlagParams(knife, mod.FriendBulletFlags.FETAL_FRIEND, {Shot = shot})
	mod:ApplyFriendGenericShotEffects(knife, player, shot, shot.Crit)
end
mod:AddPriorityCollectibleCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, -301, fetalFriend, mod.ApplyFetalFriendToSword)

function mod:ApplyFetalFriendToLudo(entity, player, weaponFlag)
	local isLudo = false
	local tear, knife
	if weaponFlag == TearFlagsLib.WeaponFlag.LUDOVICO_TEAR then
		tear = entity:ToTear()
		isLudo = true
	elseif weaponFlag == TearFlagsLib.WeaponFlag.KNIFE then
		knife = entity:ToKnife()
		isLudo = knife:HasTearFlags(TearFlags.TEAR_LUDOVICO)
	end

	if isLudo then
		if not mod:ShouldMimicFriendBehaviour(player) then
			mod:ResetFriendShotEffects(entity)
			return
		end
		
		local shot = mod.GetLastFetalFriendAmmo(player)
		if not shot then return end
		local flat, mult, crit = mod:GetFriendShotDamageBonus(nil, player, shot)
		if tear then 
			tear.CollisionDamage = (tear.CollisionDamage + flat) * mult
		end
		TearFlagsLib.AddTearFlags(entity, mod.FriendBulletFlags.FETAL_FRIEND)
		TearFlagsLib.SetTearFlagParams(entity, mod.FriendBulletFlags.FETAL_FRIEND, {Shot = shot})
		
		local data = mod:GetEntityData(entity)
		local pdata = mod:GetEntityData(player)
		if data.FetalFriendLudoLastFrameRefreshed == pdata.FetalGunLastFrameFired then
			if tear then
				if TearFlagsLib.HasTearFlags(tear, mod.FriendBulletFlags.STEVEN) then
					tear:AddTearFlags(TearFlags.TEAR_HOMING)
				end
			elseif knife then
				if TearFlagsLib.HasTearFlags(knife, mod.FriendBulletFlags.STEVEN) then
					knife:AddTearFlags(TearFlags.TEAR_HOMING)
				end
			end
			return
		end
		data.FetalFriendLudoLastFrameRefreshed = pdata.FetalGunLastFrameFired
		
		if TearFlagsLib.HasTearFlags(entity, mod.FriendBulletFlags.BONE) then
			mod:FireFriendBoneHeartBones(entity, player, entity.Position, Vector.Zero)
		end
		if tear then
			mod:ApplyFriendTearShotEffects(tear, player, shot, crit, true, true)
		elseif knife then
			mod:ApplyFriendGenericShotEffects(knife, player, shot, crit, true, true)
		end
	end
end
mod:AddPriorityCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, -301, mod.ApplyFetalFriendToLudo)

function mod:ApplyFetalFriendToLudoLaser(laser)
	if laser.SubType == LaserSubType.LASER_SUBTYPE_RING_LUDOVICO then
		local player = TearFlagsLib.GetTearPlayer(laser)
		if not (player and mod:ShouldMimicFriendBehaviour(player)) then
			mod:ResetFriendShotEffects(laser)
			return
		end
		
		local shot = mod.GetLastFetalFriendAmmo(player)
		if not shot then return end
		local flat, mult, crit = mod:GetFriendShotDamageBonus(nil, player, shot)
		TearFlagsLib.AddTearFlags(laser, mod.FriendBulletFlags.FETAL_FRIEND)
		TearFlagsLib.SetTearFlagParams(laser, mod.FriendBulletFlags.FETAL_FRIEND, {Shot = shot})
		
		local data = mod:GetEntityData(laser)
		local pdata = mod:GetEntityData(player)
		if data.FetalFriendLudoLastFrameRefreshed == pdata.FetalGunLastFrameFired then
			if TearFlagsLib.HasTearFlags(laser, mod.FriendBulletFlags.STEVEN) then
				laser:AddTearFlags(TearFlags.TEAR_HOMING)
			end
			laser.Color = mod:GetFriendShotLaserColor(laser, player)
			return
		end
		data.FetalFriendLudoLastFrameRefreshed = pdata.FetalGunLastFrameFired
		
		if TearFlagsLib.HasTearFlags(laser, mod.FriendBulletFlags.BONE) then
			mod:FireFriendBoneHeartBones(laser, player, laser.Position, Vector.Zero)
		end
		mod:ApplyFriendLaserShotEffects(laser, player, shot, crit, true)
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_LASER_UPDATE, mod.ApplyFetalFriendToLudoLaser)

mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, function(_, player)
	local data = mod:GetEntityData(player)

	if data.FetalFriendTemporaryHoming then
		data.FetalFriendTemporaryHoming = false
		data.FriendEternalHoming = false
		player:AddCacheFlags(TearFlags.CACHE_TEARFLAG, true)
	end
end, fetalFriend)