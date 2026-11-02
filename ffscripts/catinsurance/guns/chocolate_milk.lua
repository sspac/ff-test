local mod = FiendFolio
local sfx = SFXManager()
local synergy = {}

local SHAKE_PER_BULLET = 0.65
local DAMAGE_PER_BULLET = 0.7
local BULLET_INCREASE_PER_TICK = 0.02

mod.FriendChocolateMilkDamagePerBullet = DAMAGE_PER_BULLET

local overrides = {
	CollectibleType.COLLECTIBLE_C_SECTION,
	CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE,
}

local function getBulletIncreasePerTick(player)
    local currentTears = 30 / (player.MaxFireDelay + 1)
    return currentTears * BULLET_INCREASE_PER_TICK
end

function mod:FriendGetChocolateMilkShots(player, gun, min)
    min = min or 1
    local data = mod:GetEntityData(player)
    local charge = data.FriendChocolateMilkCharge or 0
    local currentTears = 30 / (player.MaxFireDelay + 1)
    if currentTears >= 30 then
        return 2 * (currentTears // 30)
    end

    local ammo = data.FriendChocolateMilkMaxAmmo or (gun.Ammo and #gun.Ammo or 0)

    return math.max(math.min(math.floor(charge), ammo), min)
end

---@param gun EntityEffect
---@param player EntityPlayer
---@param aim Vector
function synergy:PreGunFire(gun, player, aim, held)
	if not mod:ShouldRunSynergy(player, gun, CollectibleType.COLLECTIBLE_CHOCOLATE_MILK) then return end
	local hasOverride = false
	for _, c in ipairs(overrides) do
		if player:HasCollectible(c) then
			hasOverride = true
			break
		end
	end
	
	if hasOverride and not mod:IsFriendSoulGun(gun) then
		return
	end

	local d = mod:GetEntityData(gun)
	local pd = mod:GetEntityData(player)
	local charge = pd.FriendChocolateMilkCharge and math.min(math.ceil(pd.FriendChocolateMilkCharge / pd.FriendChocolateMilkMaxAmmo * 100), 100) or 0

	local currentTears = 30 / (player.MaxFireDelay + 1)
	if currentTears >= 30 or ((charge >= 100 or d.FriendMarkedSoyLetGo) and (mod.IsPlayerMarkedFiring(player) or mod.HasSoyOrAlmondMilk(player))) then
		synergy:ReleaseGun(gun, player, aim, held)
	end

	return true
end

mod:AddCallback("PRE_GUN_FIRE", synergy.PreGunFire)

---@param gun EntityEffect
---@param player EntityPlayer
---@param aim Vector
function synergy:ReleaseGun(gun, player, aim, held)
	if not mod:ShouldRunSynergy(player, gun, CollectibleType.COLLECTIBLE_CHOCOLATE_MILK) then return end
	local hasOverride = false
	for _, c in ipairs(overrides) do
		if player:HasCollectible(c) then
			hasOverride = true
			break
		end
	end
	
	if hasOverride and not mod:IsFriendSoulGun(gun) then
		return
	end
    
    local gd = mod:GetEntityData(gun)
    local pData = mod:GetEntityData(player)
	local shots = mod:FriendGetChocolateMilkShots(player, gun)
    local damageMult = shots * DAMAGE_PER_BULLET

    if shots > 0 and not mod:ShouldRunSynergy(player, gun, CollectibleType.COLLECTIBLE_CURSED_EYE) then
        local shotThings = mod:FireGunFriend(gun, aim, held)
        if shotThings and #shotThings > 0 then
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

                if pData.FriendChocolateMilkAmmoEaten then
                    mod:GetEntityData(singleShot).FriendChocolateMilkStopHeartEffects = true
                    if #pData.FriendChocolateMilkAmmoEaten > 0 then
                        for _, shot in ipairs(pData.FriendChocolateMilkAmmoEaten) do
                            if singleShot.Type == EntityType.ENTITY_TEAR then
                                mod:ApplyFriendTearShotEffects(singleShot, player, shot, false)
								mod:ApplyFriendTearColor(singleShot)
                            elseif singleShot.Type == EntityType.ENTITY_LASER then
                                mod:ApplyFriendLaserShotEffects(singleShot, player, shot, false)
                            elseif singleShot.Type == EntityType.ENTITY_BOMB then
                                mod:ApplyFriendBombShotEffects(singleShot, player, shot, false)
								mod:ApplyFriendTearColor(singleShot)
                            end
                        end
                    else
                        local shot = TearFlagsLib.GetTearFlagParams(singleShot, mod.FriendBulletFlags.FRIEND).Shot
                        if singleShot.Type == EntityType.ENTITY_TEAR then
                            mod:ApplyFriendTearShotEffects(singleShot, player, shot, false)
							mod:ApplyFriendTearColor(singleShot)
                        elseif singleShot.Type == EntityType.ENTITY_LASER then
                            mod:ApplyFriendLaserShotEffects(singleShot, player, shot, false)
                        elseif singleShot.Type == EntityType.ENTITY_BOMB then
                            mod:ApplyFriendBombShotEffects(singleShot, player, shot, false)
							mod:ApplyFriendTearColor(singleShot)
                        end
                    end
                end

                pData.FriendChocolateMilkAmmoEaten = {}
            end
        end

        mod:SubtractLimitedAmmo(gd, shots-1)
    end
    
    gd.DontReloadNewRoom = false
	Isaac.CreateTimer(function ()
        pData.FriendChocolateMilkCharge = 0
        pData.FriendChocolateMilkTracker = 0
    end, 1, 1, true)
end

mod:AddCallback("GUN_HOLD_RELEASE", synergy.ReleaseGun)

function mod.FriendChocolateMilkBarAnimFunc(player, pd, sprite, entry)
    if entry then
		if not entry.timer then
			entry.timer = 0
			entry.initialDelay = 0
			entry.chargeLayer = 1
		end

		local shooting = mod.IsPlayerShootingOrMarked(player)

		if entry.timer < 0 and shooting then
			entry.timer = 0
		end

        local guns = mod:GetGunsWithSynergy(player, CollectibleType.COLLECTIBLE_CHOCOLATE_MILK)
		local highestAmmo = 0
		for _, gun in ipairs(guns) do
			local ammo = #gun.Ammo

			if highestAmmo < ammo then
				highestAmmo = ammo
			end
		end

		if shooting and highestAmmo > 0 then
            pd.FriendChocolateMilkCharge = pd.FriendChocolateMilkCharge or 0
            pd.FriendChocolateMilkTracker = pd.FriendChocolateMilkTracker or 0

            if pd.FriendChocolateMilkCharge == 0 then
                pd.FriendChocolateMilkMaxAmmo = highestAmmo
            end

            pd.FriendChocolateMilkCharge = pd.FriendChocolateMilkCharge + getBulletIncreasePerTick(player)
            pd.FriendChocolateMilkTracker = pd.FriendChocolateMilkTracker + getBulletIncreasePerTick(player)

            for _, gun in ipairs(guns) do
                local d = mod:GetEntityData(gun.Gun)
                d.DontReloadNewRoom = true
                if d.state == "Reload" then
                    d.state = "Idle"
                end
            end

            local floored = math.floor(pd.FriendChocolateMilkTracker)
            if floored >= 1 and highestAmmo > 1 then
                for i = 1, floored do
                    local lastAmmoEaten
                    for _, v in pairs(pd.FriendHeldGuns) do
                        lastAmmoEaten = mod:GetFriendGunNextShot(v.Gun)  -- Consumes ammo
                    end

                    if lastAmmoEaten then
                        pd.FriendChocolateMilkAmmoEaten = pd.FriendChocolateMilkAmmoEaten or {}
                        table.insert(pd.FriendChocolateMilkAmmoEaten, lastAmmoEaten)
                    end
                end

                pd.FriendChocolateMilkTracker = 0
                sfx:Play(SoundEffect.SOUND_SCAMPER)
            end

            entry.spriteFrame = math.min(math.ceil(pd.FriendChocolateMilkCharge / pd.FriendChocolateMilkMaxAmmo * 100), 100)
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

function mod.FriendChocolateMilkBarConditionFunc(player, d)
	local hasOverride = false
	for _, c in ipairs(overrides) do
		if player:HasCollectible(c) then
			hasOverride = true
			break
		end
	end

    local pd = mod:GetEntityData(player)
    local guns = mod:GetGunsWithSynergy(player, CollectibleType.COLLECTIBLE_CHOCOLATE_MILK)
    for _, gun in ipairs(guns) do
        local ammo = gun.Ammo and #gun.Ammo or 0

        if (
            (not hasOverride or mod:IsFriendSoulGun(gun.Gun))
            and mod.IsPlayerShootingOrMarked(player)
            and ammo > 0
            and not (pd.FriendMarkedSoyReloading and mod:GetEntityData(gun.Gun).state == "Reload")
        ) then
            return true
        end
    end
end

function synergy:ShakeGun(e, player)
    if not mod:ShouldRunSynergy(player, e, CollectibleType.COLLECTIBLE_CHOCOLATE_MILK) then return end
	local hasOverride = false
	for _, c in ipairs(overrides) do
		if player:HasCollectible(c) then
			hasOverride = true
			break
		end
	end
	
	if hasOverride and mod:IsFriendSoulGun(e) then
		return
	end
    
	local shots = mod:FriendGetChocolateMilkShots(player, e)
    mod:GetEntityData(e).ExtraOffset = RandomVector() * ((shots - 1) * SHAKE_PER_BULLET)
end

mod:AddCallback("POST_GUN_UPDATE", synergy.ShakeGun)

function synergy:CancelReload(e, player)
    local currentTears = 30 / (player.MaxFireDelay + 1)
    local d = mod:GetEntityData(player).FriendHeldGuns[e.InitSeed]
    local ammo = d.Ammo and #d.Ammo or 0
    if mod:ShouldRunSynergy(player, e, CollectibleType.COLLECTIBLE_CHOCOLATE_MILK)
    and mod:GetEntityData(player).FriendChocolateMilkCharge
    and mod:GetEntityData(player).FriendChocolateMilkCharge > 0
    and ammo > 0
    and currentTears < 30 then
        return true
    end
end

mod:AddCallback("GUN_PRE_RELOAD_SHOT", synergy.CancelReload)

function synergy:CancelNormalHeartEffect(thing, player)
    if mod:GetEntityData(thing).FriendChocolateMilkStopHeartEffects then
        return true
    end
end

mod:AddCallback("PRE_GUN_APPLY_SHOT_EFFECT", synergy.CancelNormalHeartEffect)