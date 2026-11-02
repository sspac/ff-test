local mod = FiendFolio
local game = Game()
local synergy = {}

local MAX_BULLETS = 5
local SHOT_DELAY = 3

local overrides = {
	CollectibleType.COLLECTIBLE_TECH_X,
	CollectibleType.COLLECTIBLE_NEPTUNUS,
	CollectibleType.COLLECTIBLE_C_SECTION,
	CollectibleType.COLLECTIBLE_NEPTUNUS,
	CollectibleType.COLLECTIBLE_SPIRIT_SWORD,
	CollectibleType.COLLECTIBLE_BRIMSTONE,
	CollectibleType.COLLECTIBLE_DR_FETUS,
	CollectibleType.COLLECTIBLE_EPIC_FETUS,
	CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE,
	CollectibleType.COLLECTIBLE_MOMS_KNIFE,
	CollectibleType.COLLECTIBLE_MONSTROS_LUNG
}

-- this feels close enough
---@param player EntityPlayer
local function getMaxCharge(player)
    return math.floor(player.MaxFireDelay * MAX_BULLETS)
end

local function getNumShots(player, gun)
    local data = mod:GetEntityData(player)
    local charge = data.FriendCursedEyeCharge or 0
    local maxCharge = getMaxCharge(player)
    charge = math.min(charge, maxCharge)

    local targetShots = math.floor((charge / maxCharge) * MAX_BULLETS)
    local ammo = mod:GetFriendAmmo(gun or player)
	
	return mod:ClampNumber(targetShots, 1, #ammo)
end

-- hi connor
-- hi - connor
local function resetChargeBar(player)
	local pd = mod:GetEntityData(player)

	if pd.customChargeBarSprites then
		if not pd.customChargeBarSprites[CollectibleType.COLLECTIBLE_CURSED_EYE] then
			mod:EvaluateExtraChargeBar(player)
		end
		if pd.customChargeBarSprites[CollectibleType.COLLECTIBLE_CURSED_EYE] and pd.customChargeBarTable then
			for key,entry in pairs(pd.customChargeBarTable) do
				if entry.id == CollectibleType.COLLECTIBLE_CURSED_EYE then
					entry.spriteFrame = 0
				end
			end
		end
	end
end

local function resetCursedEye(gun, player)
    local pData = mod:GetEntityData(player)
    local gunData = mod:GetEntityData(gun)

    pData.FriendCursedEyeCharge = nil
	gunData.FriendCursedEyeActive = nil

	if #pData.FriendHeldGuns[gun.InitSeed].Ammo < #mod:GetFriendAmmo(gun) and gunData.state ~= "Reload" then
		gunData.state = "Reload"
		gunData.substate = "Begin"
		gunData.reloadOverride = true
	end

	resetChargeBar(player)
end

---@param gun EntityEffect
---@param player EntityPlayer
---@param aim Vector
function synergy:PreGunFire(gun, player, aim, held)
	local soulGun = mod:IsFriendSoulGun(gun) and gun.SubType == CollectibleType.COLLECTIBLE_CURSED_EYE
	if not player:HasCollectible(CollectibleType.COLLECTIBLE_CURSED_EYE) and not soulGun then return end
    -- everything overwrites this item :(
    if mod:GetFriendWeaponType(player) ~= WeaponType.WEAPON_TEARS and not soulGun then return end
	local hasOverride = false
	for _, c in ipairs(overrides) do
		if player:HasCollectible(c) then
			hasOverride = true
			break
		end
	end
	
	if hasOverride then
		return
	end

	if (mod.IsPlayerMarkedFiring(player) or mod.HasSoyOrAlmondMilk(player)) and math.min(math.ceil((mod:GetEntityData(player).FriendCursedEyeCharge or 0) / getMaxCharge(player) * 100), 100) >= 100 then
		synergy:ReleaseGun(gun, player, aim, held)
	end

	--[[if mod:GetEntityData(gun).OwnedByIncubus then
		return
	end]]

	return true
end

mod:AddCallback("PRE_GUN_FIRE", synergy.PreGunFire)

---@param gun EntityEffect
---@param player EntityPlayer
---@param aim Vector
function synergy:ReleaseGun(gun, player, aim, held)
	local soulGun = mod:IsFriendSoulGun(gun) and gun.SubType == CollectibleType.COLLECTIBLE_CURSED_EYE
	if not player:HasCollectible(CollectibleType.COLLECTIBLE_CURSED_EYE) and not soulGun then return end
    -- everything overwrites this item :(
    if mod:GetFriendWeaponType(player) ~= WeaponType.WEAPON_TEARS and not soulGun then return end
	local hasOverride = false
	for _, c in ipairs(overrides) do
		if player:HasCollectible(c) then
			hasOverride = true
			break
		end
	end

	if hasOverride then
		return
	end

    local pData = mod:GetEntityData(player)
	local shots = getNumShots(player, gun)

	Isaac.CreateTimer(function ()
		resetCursedEye(gun, player)
	end, 1, 1, true)
	
	if shots > 0 then
		local hadChoccyMilkCharge = pData.FriendChocolateMilkCharge and pData.FriendChocolateMilkCharge > 0
		local choccyMilkShots = mod:FriendGetChocolateMilkShots(player, gun, 0)
		local damageMult = choccyMilkShots * mod.FriendChocolateMilkDamagePerBullet

		local maxShots = #mod:GetFriendAmmo(gun, true)
		if hadChoccyMilkCharge and pData.FriendCursedEyeStartAmmo then
			maxShots = pData.FriendCursedEyeStartAmmo
		end
		local targetShots = math.min(maxShots, shots)

		if mod.IsPlayerMarkedFiring(player) then
			mod:GetEntityData(gun).FriendCursedEyeDelay = SHOT_DELAY * targetShots
		end

		for i = 0, targetShots - 1 do
			Isaac.CreateTimer(function ()
				-- Let the player cancel like normal cursed eye
				if pData.FriendCursedEyeCharge == 0 or pData.FriendCursedEyeCharge == nil then
					local shotThings = mod:FireGunFriend(gun, aim, held, nil, hadChoccyMilkCharge)
					if hadChoccyMilkCharge and shotThings and #shotThings > 0 then
						for _, singleShot in ipairs(shotThings) do
							if singleShot.Type == EntityType.ENTITY_TEAR then
								singleShot.CollisionDamage = singleShot.CollisionDamage * damageMult
								singleShot.Scale = singleShot.Scale * math.max(damageMult, 0.5)
							elseif singleShot.Type == EntityType.ENTITY_LASER then
								singleShot.CollisionDamage = singleShot.CollisionDamage * damageMult
							elseif singleShot.Type == EntityType.ENTITY_BOMB then
								singleShot.ExplosionDamage = singleShot.ExplosionDamage * damageMult
								singleShot:SetScale(damageMult)
								singleShot:SetLoadCostumes()
							end
						end
					end
				end
			end, i * SHOT_DELAY, 1, false)
		end
	end
end

mod:AddCallback("GUN_HOLD_RELEASE", synergy.ReleaseGun)

---@param player EntityPlayer
function mod:FriendTeleportOnDamage(player, data, _, flags)
	local player = player:ToPlayer()
	if not player:HasCollectible(CollectibleType.COLLECTIBLE_CURSED_EYE) then return end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BLACK_CANDLE) then return end
	if mod:GetFriendWeaponType(player) ~= WeaponType.WEAPON_TEARS then return end
	local hasOverride = false
	for _, c in ipairs(overrides) do
		if player:HasCollectible(c) then
			hasOverride = true
			break
		end
	end
	
	if hasOverride then
		return
	end

	if flags & DamageFlag.DAMAGE_CURSED_DOOR ~= 0
        or flags & DamageFlag.DAMAGE_FAKE ~= 0
        or flags & DamageFlag.DAMAGE_DEVIL ~= 0
        or flags & DamageFlag.DAMAGE_INVINCIBLE ~= 0
        or flags & DamageFlag.DAMAGE_IV_BAG ~= 0
        or flags & DamageFlag.DAMAGE_NO_PENALTIES ~= 0 then
        return
    end

	local charge = getNumShots(player)
	if data.FriendCursedEyeCharge and data.FriendCursedEyeCharge > 0 and charge < 5 then
		local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_CURSED_EYE)
		local seed = rng:Next()
		game:MoveToRandomRoom(false, seed, player)
	end
end

function mod.FriendCursedEyeBarAnimFunc(player, pd, sprite, entry)
    if entry then
		if not entry.timer then
			entry.timer = 0
			entry.initialDelay = 0
			entry.chargeLayer = 1
		end

		if entry.timer < 0 and mod.IsPlayerShootingOrMarked(player) then
			entry.timer = 0
		end

		local guns = mod:GetGunsWithSynergy(player, CollectibleType.COLLECTIBLE_CURSED_EYE)
		for _, gun in ipairs(guns) do
			local d = mod:GetEntityData(gun.Gun)
			local ammo = gun.Ammo and #gun.Ammo or 0
			if d.FriendCursedEyeDelay then
				d.FriendCursedEyeDelay = d.FriendCursedEyeDelay - 1
				if d.FriendCursedEyeDelay <= 1 then
					d.FriendCursedEyeDelay = nil
				end
			elseif mod.IsPlayerShootingOrMarked(player) and ammo > 0 then
				pd.FriendCursedEyeCharge = pd.FriendCursedEyeCharge or 0
				if pd.FriendCursedEyeCharge == 0 then
					pd.FriendCursedEyeStartAmmo = ammo
				end
				pd.FriendCursedEyeCharge = math.min(pd.FriendCursedEyeCharge + 1, getMaxCharge(player))
				entry.spriteFrame = math.min(math.ceil(pd.FriendCursedEyeCharge / getMaxCharge(player) * 100), 100)
			end
		end

		if entry.spriteFrame and entry.spriteFrame == 100 then
			if not entry.charged then
				sprite:Play("StartCharged", true)
				entry.charged = true
			elseif sprite:IsFinished("StartCharged") then
				mod:spritePlay(sprite, "Charged")
			end
		elseif entry.timer > 0 then
			sprite:Play("Charging")
			sprite:SetFrame(entry.spriteFrame or 0)
			entry.charged = nil
		end

		if entry.timer >=0 and entry.timer < 10 then
			entry.timer = 100
		end
	end
end

function mod.FriendCursedEyeBarConditionFunc(player, d)
	local hasOverride = false
	for _, c in ipairs(overrides) do
		if player:HasCollectible(c) then
			hasOverride = true
			break
		end
	end

	local guns = mod:GetGunsWithSynergy(player, CollectibleType.COLLECTIBLE_CURSED_EYE)
	for _, gun in ipairs(guns) do
		local ammo = gun.Ammo and #gun.Ammo or 0
		local soulGun = mod:IsFriendSoulGun(gun.Gun)
		if (
			(not hasOverride or soulGun)
			and mod.IsPlayerShootingOrMarked(player)
			and (player:HasCollectible(CollectibleType.COLLECTIBLE_CURSED_EYE) or soulGun)
			and mod:GetFriendWeaponType(player, gun.Gun) == WeaponType.WEAPON_TEARS
			and ammo > 0
		) then
			return true
		end
	end
end