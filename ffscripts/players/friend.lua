local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local itemConfig = Isaac.GetItemConfig()

mod.FriendBulletFlags = mod.FriendBulletFlags or {}
mod.FriendBulletFlags.FRIEND = TearFlagsLib.RegisterTearFlag("BULLET_FRIEND")

-- hearts after here
mod.FriendBulletFlags.GOLD = TearFlagsLib.RegisterTearFlag("BULLET_GOLD")
mod.FriendBulletFlags.ETERNAL = TearFlagsLib.RegisterTearFlag("BULLET_ETERNAL")
mod.FriendBulletFlags.BONE = TearFlagsLib.RegisterTearFlag("BULLET_BONE")
mod.FriendBulletFlags.MORBID = TearFlagsLib.RegisterTearFlag("BULLET_MORBID")
mod.FriendBulletFlags.ROTTEN = TearFlagsLib.RegisterTearFlag("BULLET_ROTTEN")
mod.FriendBulletFlags.BLACK = TearFlagsLib.RegisterTearFlag("BULLET_BLACK")
mod.FriendBulletFlags.SOUL = TearFlagsLib.RegisterTearFlag("BULLET_SOUL")
mod.FriendBulletFlags.IMMORAL = TearFlagsLib.RegisterTearFlag("BULLET_IMMORAL")
mod.FriendBulletFlags.LEAKY = TearFlagsLib.RegisterTearFlag("BULLET_LEAKY")
mod.FriendBulletFlags.STEVEN = TearFlagsLib.RegisterTearFlag("BULLET_STEVEN")

-- technical effects after here
mod.FriendBulletFlags.NO_FALL_TEAR = TearFlagsLib.RegisterTearFlag("BULLET_NO_FALL_TEAR")
mod.FriendBulletFlags.FORCE_DIE_ON_WALLS = TearFlagsLib.RegisterTearFlag("BULLET_FORCE_DIE_ON_WALLS")
mod.FriendBulletFlags.GRENADE = TearFlagsLib.RegisterTearFlag("BULLET_GRENADE")

mod.PocketRockitDisallowedCustomFlags = (mod.PocketRockitDisallowedCustomFlags or TearFlagsLib.BitSetInfinity.Zero) | mod.FriendBulletFlags.BONE
mod.FriendBoneBulletSplitDisallowedFlags = {Vanilla = TearFlags.TEAR_SPLIT, Custom = TearFlagsLib.RegisterTearFlag("ZERO_POINT") | mod.FriendBulletFlags.BONE}

--[[
--TO DO:
--IMPLEMENT PEAS' BULLET SPRITES
--MAKE HEART DROPS MORE RELIABLE ON LOW HEALTH?
--Make the reload bonus mechanic more clear?
--AAAAAAAAAAAA
--Proper eternal heart effect for non-techx lasers?
--Update morbid heart synergies?
--If free aiming is enabled, maybe add an extra effect/buff for having analogue stick?
--Would be neat if Ludo+Spirit Sword could knock the ludo tear back when hitting enemies
]]

--[[BUG FIXES
--Tech X + Brimstone + Dr Fetus has weird looking laser rings, but this is a vanilla thing unrelated to friend
--Ipecac
--With ludo, should charge bars (like monstro's lung) be rendered by IT or stay by the player?
]]

mod.FriendBalancing = {
    Damage = 1.4,
    Tears = 1.2,
    Speed = 0,
    Shotspeed = 1,
    Luck = -2,
    FriendsLuckyPenny = 1,
    TapFireCooldown = 1, --Frame cooldown when tap firing
    HoldFireCooldown = 6, --Frame cooldown when holding down fire, chooses lower between this and tear rate
    MinMeleeCooldown = 3,
    ReloadMultiplier = 0.7, --Multiplies MaxFireDelay for each bullet's reload
    AutoReloadTimer = 10,
    HoldFireSlowdown = 0.35, --When tear rate is slower than the one you start with, make friend shoot slower when you hold down fire. 0 = no influence on firerate, higher value = more infulence
    ActiveCharge = 100, --Needed charge for her pocket active
    ReloadBonusFlat = 2.5,
    ReloadBonusMult = 0.5,
    DrFetusBombDamageMult = 2,
    EpicFetusRocketDamageMult = 3,
    HighFireRateExtraAmmoInterval = 3, -- every HighFireRateExtraAmmoInterval fire rate starting from HighFireRateExtraAmmoMinimum gives an extra ammo per shot
    HighFireRateExtraAmmoMinimum = 6,
    MrMegaBombFlatBonus = 10,
    HeartTimeout = 75,

    EternalHeartDamage = 1, --same as Sacred Heart
    EternalHeartMult = 1.3,
    BlackHeartMult = 0.5,
    ImmoralHeartChance = {15, 0.45, 15}, --Chance for crit. Base chance, potential increase, needed luck for max
    MorbidHeartChance = 50, --Chance to spawn a morbid chunk on kill
    GoldHeartChance = 0.5, --% Chance to not consume ammo
    FoolsGoldChance = 0.5, --% Chance to not consume ammo OR to double ammo + immoral heart effect

    --Aimed Shot
    ASFlatDamage = 6, --Multiplies by each level
    ASChargeRatio = 40, --Multiplies by chapter
    ASHeartChance = 100,

    --Slow Fireball
    SFInitialSpeed = 9,
    SFInitialSpeedCarBattery = 14,
    SFSlowSpeed = 1.7,
    SFRadius = 1,
    SFDamageMult = 1,
    SFDamageFlat = 5,
    SFHeartChance = 30,
    SFHitRadius = 105,
    SFHitRadiusCarBattery = 55,
    SFPlayerRadius = 75,
    SFRockRadius = 85,
    SFHitDamageMult = 1.8,
    SFHitDamageFlat = 7,
    SFHitDamageSuperFlat = 10,
    SFHitHeartChance = 55,
    SFLifespanMin = 20,
    SFLifespanRangeMult = 13.85, -- 1 range = x extra ticks of lifespan
    SFLifespanBirthrightMult = 1.45, -- lifespan is multiplied by x
    SFChargeRatio = 75,
    SFFireballCharge = 0.66,
    SFFireballBirthrightPower = 15,
    SFFireballBirthrightHits = 3,

    FireballSOffset = Vector(0,-10),

    --Gun graphical stuff default
    DefaultHeldOffset = 24,
    DefaultVerticalOffset = 0,
    DefaultTearHeight = -10,
    DefaultMuzzleOffset = Vector(44, -20),
    DefaultMuzzleScale = 1,
    DefaultCasingScale = 1,
    SearingShotCosmetics = true,
    SearingShotName = "Searing Shot",
    SearingShotDescription = "Perfected bullseye detonation",
    OriginalName = "Hot Shot",
    OriginalDescription = "Bullseye detonation",

}

-- If the player has a collectible in this list, their gun will be INVISIBLE.
-- Make it a function to be conditional
local RemoveGunIfFriendHas = {
    function (player)
        if player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION) then
            return true
        end

        return false
    end,
    function (player)
        local d = mod:GetEntityData(player)
        if d.GatlingGunPreventShoot or d.ReallyCantShoot then
            return true
        end

        return false
    end,
}

function mod:friendPostAddHealth(player)
    local d = mod:GetEntityData(player)
    if d.FriendsRevolver then
        local gun = d.FriendHeldGuns[d.FriendsRevolver.InitSeed]
        gun.Ammo = mod:GetFriendAmmo(gun.Gun or player, true)
    end
end
mod:AddCallback(CustomHealthAPI.Enums.Callbacks.POST_ADD_HEALTH, mod.friendPostAddHealth, FiendFolio.PLAYER.FRIEND)
mod:AddCallback(CustomHealthAPI.Enums.Callbacks.POST_ADD_HEALTH, mod.friendPostAddHealth, FiendFolio.PLAYER.BRIEND)

function mod:friendPostPlayerDamage(player)
    local d = mod:GetEntityData(player)
    if d.FriendsRevolver then
        local gun = d.FriendHeldGuns[d.FriendsRevolver.InitSeed]
        gun.Ammo = mod:GetFriendAmmo(gun.Gun or player, true)
    end
end
mod:AddCallback(CustomHealthAPI.Enums.Callbacks.POST_PLAYER_DAMAGE, mod.friendPostPlayerDamage, FiendFolio.PLAYER.FRIEND)
mod:AddCallback(CustomHealthAPI.Enums.Callbacks.POST_PLAYER_DAMAGE, mod.friendPostPlayerDamage, FiendFolio.PLAYER.BRIEND)

function mod:friendPostLoadHealthFromBackup(player)
    local d = mod:GetEntityData(player)
    if d.FriendsRevolver then
        local gun = d.FriendHeldGuns[d.FriendsRevolver.InitSeed]
        gun.Ammo = mod:GetFriendAmmo(gun.Gun or player, true)
    end
end
mod:AddCallback(CustomHealthAPI.Enums.Callbacks.POST_LOAD_HEALTH_FROM_BACKUP, mod.friendPostLoadHealthFromBackup, FiendFolio.PLAYER.FRIEND)
mod:AddCallback(CustomHealthAPI.Enums.Callbacks.POST_LOAD_HEALTH_FROM_BACKUP, mod.friendPostLoadHealthFromBackup, FiendFolio.PLAYER.BRIEND)

mod.FriendGunSupportedHearts = {
    ["RED_HEART"] = true,
    ["SOUL_HEART"] = true,
    ["BLACK_HEART"] = true,
    ["BONE_HEART"] = true,
    ["MORBID_HEART"] = true,
    ["ROTTEN_HEART"] = true,
    ["IMMORAL_HEART"] = true,
    ["GOLDEN_HEART"] = true,
    ["FOOLS_GOLD_HEART"] = true,
    ["ETERNAL_HEART"] = true,
    ["EMPTY_HEART"] = true,
    ["LEAKY_HEART"] = true,
}

mod.FriendGunIgnoredHearts = {
	["ETERNAL_SHIELD"] = true
}

function mod:friendPreHealthRender(player, playerSlot, healthIndex, info)
    return mod:PreRenderFriendHeart(player, false, nil, playerSlot, healthIndex, info)
end
mod:AddCallback(CustomHealthAPI.Enums.Callbacks.PRE_HEALTH_RENDER, mod.friendPreHealthRender, FiendFolio.PLAYER.FRIEND)

function mod:PreRenderFriendHeart(player, isBriendDeselected, baseOffset, playerSlot, healthIndex, info)
	local health = info.OtherHealth
	local redHealth = info.RedHealth
	local healthOverlayed = info.OtherHealthOverlayed
	local redHealthOverlayed = info.RedHealthOverlayed
	local filename = info.Filename
	local animname = info.Animation
	local color = Color.Lerp(info.Color, info.Color, 1)
	local extracolor = Color.Lerp(color, color, 1)

    local realAnim = animname
    local overlay
    local offset = Vector.Zero
    local eternalHeart
    local incompat

    if redHealth then
        if not mod.FriendGunSupportedHearts[redHealth.Key] then
            incompat = true
        end
    end
	if health then
        if not mod.FriendGunSupportedHearts[health.Key] then
            incompat = true
        end
    end
	if redHealthOverlayed then
        if not mod.FriendGunSupportedHearts[redHealthOverlayed.Key] then
            incompat = true
        end
	end
	if healthOverlayed then
        if not mod.FriendGunSupportedHearts[healthOverlayed.Key] then
            incompat = true
        end
	end

    if animname == "FoolsGoldOverlay" then
        local order = CustomHealthAPI.Library.GetHealthInOrder(player, false)
        local heartTab = order[healthIndex+1]
        local red = heartTab.Red
        local other = heartTab.Other
        overlay = true
        if red and red.HP > 0 then
            if red.HP > 1 or red.Key == "ROTTEN_HEART" then
                realAnim = "FoolsGoldHeartOverlayFull"
            else
                realAnim = "FoolsGoldHeartOverlayHalf"
            end
        elseif other and other.HP > 0 then
            if other.HP > 1 or other.Key == "ROTTEN_HEART" then
                realAnim = "FoolsGoldHeartOverlayFull"
            else
                realAnim = "FoolsGoldHeartOverlayHalf"
            end
        end
    elseif animname == "GoldHeartOverlay" then
        local order = CustomHealthAPI.Library.GetHealthInOrder(player, false)
        local heartTab = order[healthIndex+1]
        local red = heartTab.Red
        local other = heartTab.Other
        overlay = true
        if red and red.HP > 0 then
            if red.HP > 1 or red.Key == "ROTTEN_HEART" then
                realAnim = "GoldHeartOverlayFull"
            else
                realAnim = "GoldHeartOverlayHalf"
            end
        elseif other and other.HP > 0 then
            if other.HP > 1 or other.Key == "ROTTEN_HEART" then
                realAnim = "GoldHeartOverlayFull"
            else
                realAnim = "GoldHeartOverlayHalf"
            end
        end
    elseif animname == "WhiteHeartOverlay" then
        local order = CustomHealthAPI.Library.GetHealthInOrder(player, false)
        local heartTab
        local redHeart
        local num = 0
        for key, entry in pairs(order) do
            if entry.Red then
                heartTab = entry
                redHeart = true
                num = key-1
            elseif not redHeart and entry.Other and entry.Other.Key == "EMPTY_HEART" then
                heartTab = entry
                num = key-1
            end
        end
        if not heartTab then
            heartTab = order[1]
        end
        local red = heartTab.Red
        local other = heartTab.Other
        overlay = true
        eternalHeart = true
        if red and red.HP > 0 then
            if red.HP > 1 or red.Key == "ROTTEN_HEART" then
                realAnim = "WhiteHeartOverlayFull"
            else
                realAnim = "WhiteHeartOverlayHalf"
            end
        elseif other and other.HP > 0 then
            if other.HP > 1 then
                realAnim = "WhiteHeartOverlayFull"
            else
                realAnim = "WhiteHeartOverlayHalf"
            end
        else
            realAnim = "WhiteHeartOverlayFull"
        end
        --Not bothering with height atm cause of the 6 limit
        if num > healthIndex then
            offset = Vector((healthIndex-num)*CustomHealthAPI.Constants.HEART_PIXEL_WIDTH_DEFAULT, 0)
        elseif num < healthIndex then
            offset = Vector(-(healthIndex-num)*CustomHealthAPI.Constants.HEART_PIXEL_WIDTH_DEFAULT, 0)
        end
        healthIndex = num
    end
    local d = mod:GetEntityData(player)
    local continue = true
    if health.Key == "BONE_HEART" or health.Key == "BROKEN_HEART" or animname == "EmptyHeart" then
        if health.Key == "BONE_HEART" then
            local order = CustomHealthAPI.Library.GetHealthInOrder(player, false)
            local heartTab = order[healthIndex+1]
            if not heartTab.Red or heartTab.Red.HP <= 0 then
                continue = false
            end
        else
            continue = false
        end
    end

	if isBriendDeselected then
		color.A = 0.3
		extracolor.A = 0.3
	end
    if continue then
        local ammo
        if mod:IsAnyFriend(player) then
            if d.FriendsRevolver then
                ammo = d.FriendHeldGuns[d.FriendsRevolver.InitSeed].Ammo
            end
        elseif player:HasCollectible(mod.ITEM.COLLECTIBLE.FETAL_FRIEND) then
            ammo = d.fetalGunMimic
        end

        if ammo then
            local lastShot = ammo[#ammo]
            if not lastShot or lastShot.Index < healthIndex+1 then
                color.A = (player:GetEffects():HasNullEffect(NullItemID.ID_LOST_CURSE) or isBriendDeselected) and 0.1 or 0.35
            elseif lastShot.Index == healthIndex+1 then
                local tab = lastShot.HealthPosition
                if tab[1] < tab[2] then
                    if overlay then
                        color.A = (player:GetEffects():HasNullEffect(NullItemID.ID_LOST_CURSE) or isBriendDeselected) and 0.1 or 0.35
                    else
                        if tab[2] == 2 then
                            realAnim = realAnim .. "HL"
                        elseif tab[2] == 3 then
                            if tab[1] == 1 then
                                realAnim = realAnim .. "OTL"
                            else
                                realAnim = realAnim .. "TTL"
                            end
                        end
                    end
                end
            end
        end
    end

    if d.FriendHeartsJustReloaded then
        for key,entry in pairs(d.FriendHeartsJustReloaded) do
            if entry.Index == healthIndex+1 or (entry.Index < 0 and healthIndex == 0) then
                if entry.ReloadTimer > 0 then
                    color = Color(color.R, color.G, color.B, color.A, 0.2, 0.2, 0.2)
					extracolor = Color(extracolor.R, extracolor.G, extracolor.B, extracolor.A, 0.2, 0.2, 0.2)
                    if not overlay then
                        entry.ReloadTimer = entry.ReloadTimer-1
                    end
                end
                local pos
                if eternalHeart then
                    pos = entry.EternalPositionOffset or offset
                else
                    pos = entry.PositionOffset or offset
                end
                if entry.ShakeTimer[1] > 0 then
                    if not overlay then
                        pos = mod:Lerp(pos, Vector(-0.5, 1.5), 0.2)
                        entry.ShakeTimer[1] = entry.ShakeTimer[1]-1
                    end
                    if entry.ShakeTimer[1] <= 0 then
                        pos = offset+Vector(-0.5, 1.5)
                    end
                    offset = pos
                elseif entry.ShakeTimer[2] > 0 then
                    if not overlay then
                        pos = mod:Lerp(pos, offset, 0.2)
                        entry.ShakeTimer[2] = entry.ShakeTimer[2]-1
                    end
                    offset = pos
                else
                    d.FriendHeartsJustReloaded[key] = nil
                end
            end
        end
    end
    if d.FriendHeartsJustFired then
        for key,entry in pairs(d.FriendHeartsJustFired) do
            if entry.Index == healthIndex+1 or (entry.Index < 0 and healthIndex == 0) then
                local pos
                if eternalHeart then
                    pos = entry.EternalPositionOffset or offset
                else
                    pos = entry.PositionOffset or offset
                end
                if entry.ShakeTimer[1] > 0 then
                    if not overlay then
                        pos = mod:Lerp(pos, offset+Vector(0.5, -1.5), 0.2)
                        entry.ShakeTimer[1] = entry.ShakeTimer[1]-1
                    end
                    if entry.ShakeTimer[1] <= 0 then
                        pos = offset+Vector(0.5, -1.5)
                    end
                    offset = pos
                elseif entry.ShakeTimer[2] > 0 then
                    if not overlay then
                        pos = mod:Lerp(pos, offset, 0.2)
                        entry.ShakeTimer[2] = entry.ShakeTimer[2]-1
                    end
                    offset = pos
                else
                    d.FriendHeartsJustFired[key] = nil
                end
            end
        end
    end
    if baseOffset then
        offset = offset + baseOffset
    end
    if not incompat then
		if healthIndex == 0 and player:GetPlayerType() == FiendFolio.PLAYER.FRIEND then
			local ammo
			if d.FriendsRevolver then
				ammo = d.FriendHeldGuns[d.FriendsRevolver.InitSeed].Ammo
			end
			if ammo and ammo[1] and ammo[1].Index < 0 and ammo[#ammo].Index >= 0 then
				local healthSprite = CustomHealthAPI.Helper.GetHealthSprite("gfx/ui/ui_hearts_friend.anm2")
				healthSprite:Play("ExtraBullet", true)
				healthSprite:SetFrame(0)
				healthSprite.Color = extracolor
				CustomHealthAPI.Helper.RenderHealth(healthSprite, player, playerSlot, healthIndex, info.RenderOffset, info.TotalHealthRendered, offset + Vector(-2,2))
			end
		end

		info.Other = info.Other or {}
		info.Other.WasFriendCompat = true
		info.Other.ExtraFriendBulletColor = extracolor
        return {AnimationFilename = "gfx/ui/ui_hearts_friend.anm2", AnimationName = realAnim, Color = color, Offset = offset}
	else
		if isBriendDeselected then
			local color = Color.Lerp(info.Color, info.Color, 1)
			color.A = 0.3
			return {Color = color}
		end
    end
end

function mod:friendPostHealthRender(player, playerSlot, healthIndex, info)
    return mod:TryRenderBirthcakeBullet(player, false, nil, playerSlot, healthIndex, info)
end
mod:AddCallback(CustomHealthAPI.Enums.Callbacks.POST_HEALTH_RENDER, mod.friendPostHealthRender, FiendFolio.PLAYER.FRIEND)

function mod:TryRenderBirthcakeBullet(player, isBriendDeselected, baseOffset, playerSlot, healthIndex, info)
	if healthIndex == 0 and info.Other.WasFriendCompat and player:GetPlayerType() == FiendFolio.PLAYER.FRIEND then
		local d = mod:GetEntityData(player)
		local ammo
		if d.FriendsRevolver then
			ammo = d.FriendHeldGuns[d.FriendsRevolver.InitSeed].Ammo
		end
		if ammo and ammo[1] and ammo[1].Index < 0 and ammo[#ammo].Index < 0 then
			local healthSprite = CustomHealthAPI.Helper.GetHealthSprite("gfx/ui/ui_hearts_friend.anm2")
			healthSprite:Play("ExtraBullet", true)
			healthSprite:SetFrame(0)
			healthSprite.Color = info.Other.ExtraFriendBulletColor
			CustomHealthAPI.Helper.RenderHealth(healthSprite, player, playerSlot, healthIndex, info.RenderOffset, info.TotalHealthRendered, info.ExtraOffset + Vector(-2,2))
		end
	end
end

function mod:FriendPlaySound(sub, id, volume)
    local gun = mod.FriendGunInfo[sub]
    local gunSounds = gun and gun.Sounds
    if not gunSounds then
        gunSounds = mod.FriendGunInfo[mod.FF.FriendsRevolver.Sub].Sounds
    end

    if gunSounds[id] ~= false then
        local soundList
        local halfPitch = false
        if gunSounds[id] ~= nil then
            soundList = gunSounds[id]
        else
            if id ~= "BulletMega" then
                soundList = mod.FriendGunInfo[mod.FF.FriendsRevolver.Sub].Sounds[id]
            else
                soundList = gunSounds["Bullet"]
                if not soundList then
                    soundList = mod.FriendGunInfo[mod.FF.FriendsRevolver.Sub].Sounds["Bullet"]
                else
                    halfPitch = true
                end
            end
        end

        if soundList then
            local choice = soundList[mod:RandomInt(1, #soundList)]
            local divider = halfPitch and 200 or 100
            --sfx:Play(choice.Id, choice.Vol, 0, false, mod:RandomInt(math.floor(choice.PitchMin*100), math.floor(choice.PitchMax*100))/divider)
            sfx:Play(choice.Id, mod:RandomInt(math.floor(choice.VolMin*100*volume), math.floor(choice.VolMax*100*volume))/divider, 0, false, mod:RandomInt(math.floor(choice.PitchMin*100), math.floor(choice.PitchMax*100))/divider)
        end
    end
end

function mod:FriendBlockWeaponTypes(player)
	if player:GetPlayerType() == FiendFolio.PLAYER.FRIEND then
		local data = mod:GetEntityData(player)
		if not data.FriendBlockedWeaponTypes then
			data.FriendBlockedWeaponTypes = {}
		end

		local blockedWeapon = false

		for _, weaponType in pairs(mod.FriendWeaponTypeBlacklist) do
			local hadWeapon = player:HasWeaponType(weaponType)
			data.FriendBlockedWeaponTypes[weaponType] = hadWeapon
			if hadWeapon then
				player:EnableWeaponType(weaponType, false)
				blockedWeapon = true
			end
		end

		if player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION) then
			player:EnableWeaponType(WeaponType.WEAPON_FETUS, true)
			player:EnableWeaponType(WeaponType.WEAPON_LUDOVICO_TECHNIQUE, false)
		elseif player:HasCollectible(CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE) then
			player:EnableWeaponType(WeaponType.WEAPON_LUDOVICO_TECHNIQUE, true)
			player:EnableWeaponType(WeaponType.WEAPON_TEARS, false)
		elseif blockedWeapon then
			player:EnableWeaponType(WeaponType.WEAPON_TEARS, true)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.FriendBlockWeaponTypes, CacheFlag.CACHE_WEAPON)

-- Returns the WeaponType that accurately corresponds to Friend's current attack control scheme.
-- Since not all WeaponTypes are supported by Friend or may interact with each other differently than usual.
-- Optionally, supply a gun entity to get the weapon type that it should use for Soul of Friend, if any.
function mod:GetFriendWeaponType(player, gun)
    if gun and mod:IsFriendSoulGun(gun) then
        local gunInfo = mod.FriendGunInfo[gun.SubType]
        if gunInfo and gunInfo.WeaponType then
            return gunInfo.WeaponType
        end
    end

	if player:HasCollectible(CollectibleType.COLLECTIBLE_SPIRIT_SWORD) or player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_BERSERK) then
		return WeaponType.WEAPON_SPIRIT_SWORD
	end

	local brimstone = player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) or player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_BRIMSTONE)  -- Sulfur
	local lungs = player:HasCollectible(CollectibleType.COLLECTIBLE_MONSTROS_LUNG)
	local techx = player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_X)
	local bombs = player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS)
	local rockets = player:HasCollectible(CollectibleType.COLLECTIBLE_EPIC_FETUS)

	-- Dr Fetus / Epic Fetus override Tech X and Brimstone, but they are compatible with Friend's Monstro's Lung control scheme.
	if techx and not bombs and not rockets then
		return WeaponType.WEAPON_TECH_X
	elseif brimstone and not bombs and not rockets then
		return WeaponType.WEAPON_BRIMSTONE
	elseif lungs then
		return WeaponType.WEAPON_MONSTROS_LUNGS
	end

	return WeaponType.WEAPON_TEARS  -- Regular gun
end

-- Convenience to check if a gun is a soul gun.
function mod:IsFriendSoulGun(gun, gunData)
    gunData = gunData or mod:GetEntityData(gun)
    return gunData.IsFriendSoulGun == true
end

-- Convenience to check if the player run the synergy code for the gun.
-- Determined by if they have the collectible or if the gun is a soul gun for that collectible.
function mod:ShouldRunSynergy(player, gun, collectible)
    if player:HasCollectible(collectible) then
        return true
    elseif mod:IsFriendSoulGun(gun) and gun.SubType == collectible then
        return true
    end

    return false
end

function mod:FriendFullyReloadGuns(playerData)
    if not playerData.FriendHeldGuns then
        return
    end

    for _, gunTable in pairs(playerData.FriendHeldGuns) do
        if not gunTable.Ammo then
            goto continue
        end

        local friendAmmo = mod:GetFriendAmmo(gunTable.Gun)
        local ammoCount = #gunTable.Ammo
        for _ = ammoCount, #friendAmmo do
            local original = friendAmmo[#gunTable.Ammo + 1]
            table.insert(gunTable.Ammo, original)
        end

        ::continue::
    end
end

--- Returns the player then the gun's parent/owner (Evil Eye for example)
function mod:GetFriendGunPlayer(gun)
	local spawner = gun.SpawnerEntity
	local player
	while spawner ~= nil and spawner.Type ~= EntityType.ENTITY_PLAYER do
		if spawner.Type == EntityType.ENTITY_FAMILIAR then
			spawner = spawner:ToFamiliar().Player
		else
			spawner = spawner.SpawnerEntity
		end
	end
	if spawner then player = spawner:ToPlayer() end

	local gd = mod:GetEntityData(gun)

	if player and (gd.isFriendsPrimaryGun or gd.isFriendMultishotGun) and not gd.OwnedByIncubus then
		local pd = mod:GetEntityData(player)
		local ludo = mod:GetPointee(pd.FriendLudoDrone)
		if ludo and (not gun.Parent or not gun.Parent:Exists() or gun.Parent.Type == EntityType.ENTITY_PLAYER) then
			gun.Parent = ludo
		elseif not gun.Parent or not gun.Parent:Exists() then
			gun.Parent = player
		end
	end

	local parent = gun.Parent

	return player, parent, (gd.OwnedByIncubus and parent) or player
end

function mod:GetHoriGunOffset(gun, parent, d)
    local baseOffset = 0

    if d.ForceHeldOffset then
        return baseOffset +  d.ForceHeldOffset
    elseif mod.FriendGunInfo[gun.SubType].HeldOffset then
        return baseOffset +  mod.FriendGunInfo[gun.SubType].HeldOffset
    else
        return baseOffset +  mod.FriendBalancing.DefaultHeldOffset
    end
end

function mod:GetVertGunOffset(gun, parent, d)
    local baseOffset = 0

    if d.ForceVerticalOffset then
        return baseOffset + d.ForceVerticalOffset
    elseif mod.FriendGunInfo[gun.SubType].VerticalOffset then
        return baseOffset + mod.FriendGunInfo[gun.SubType].VerticalOffset
    else
        return baseOffset + mod.FriendBalancing.DefaultVerticalOffset
    end
end

function mod:GunShouldUseBriendHandOffset(gun, d, player, parent)
	return player:GetPlayerType() == mod.PLAYER.BRIEND and not mod:IsFriendSoulGun(gun, d)
		and not (parent and mod:GetEntityData(parent).FriendLudoPlayer)
        and not (parent and parent.Type ~= EntityType.ENTITY_PLAYER)
end

function mod:GunMovement(e, forceNoLerp)
    local player, parent = mod:GetFriendGunPlayer(e)

    local d = mod:GetEntityData(e)
    local pd = mod:GetEntityData(player)
    local parentData = mod:GetEntityData(parent)
    local sprite = e:GetSprite()
    local room = game:GetRoom()
    local mouseAimingEnabled = mod.MouseGunAiming == 1
    local fireInput = mod.GetCorrectedFiringInput(player, mouseAimingEnabled)
    local fireDir = fireInput
    local targetPos = d.GunMovementParent and d.GunMovementParent.Position or parent.Position

    local isBriend = player:GetPlayerType() == mod.PLAYER.BRIEND

    local isBriendGunInRightHand = true
    if isBriend then
        isBriendGunInRightHand = mod:IsBriendGunInRightHand(player, d)
    end

    pd.BriendFinalHandOffset = mod.BriendBalancing.HandOffset * player.SpriteScale
    local useBriendHandOffset = isBriend and mod:GunShouldUseBriendHandOffset(e, d, player, parent)

    local overrideDir

    local markedTarget = player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED) and mod.GetPlayerMarkedTarget(player)
    if parentData.LockGunAim then
        overrideDir = parentData.LockGunAim:Resized(math.max(fireDir:Length(), 0.1))
    elseif markedTarget then
        overrideDir = (markedTarget.Position - targetPos):Normalized()
    end

    if overrideDir then
        fireDir = overrideDir
        d.PreviousGunDir = overrideDir
    end

    d.CurrentAngle = d.CurrentAngle or 90

    if fireDir:Length() > 0.5 then
        d.PreviousGunDir = Vector(fireDir.X, fireDir.Y)

		local isMegaBlasting = false
		if parent.Type == EntityType.ENTITY_PLAYER then
			isMegaBlasting = player:GetMegaBlastDuration() > 0
			if isBriend then
				local othertwin = player:GetOtherTwin()
				if othertwin then
					isMegaBlasting = isMegaBlasting or othertwin:GetMegaBlastDuration() > 0
				end
			end
		end
        if not isMegaBlasting then
			d.PreviousFireFrame = e.FrameCount
		end
    else
        fireDir = d.PreviousGunDir
    end

    local continueReloadCheck = false
    if e.Variant == mod.FF.FriendsRevolver.Var then
        local gunTable = pd.FriendHeldGuns[e.InitSeed]
        local ammo = gunTable.Ammo
        local order = gunTable.FixedAmmo or CustomHealthAPI.Library.GetHealthInOrder(player, false) or {}

        -- trim empty containers and ignored hearts off of the list so that we can easily check if we need to reload
		local containers = {}
		for i, container in ipairs(order) do
			table.insert(containers, container)
		end
        for i = #containers, 1, -1 do
            local entry = containers[i]
            local filled = (entry.Red and entry.Red.HP > 0 and not mod.FriendGunIgnoredHearts[entry.Red.Key]) or
			               (entry.Other and entry.Other.HP > 0 and CustomHealthAPI.Library.GetInfoOfKey(entry.Other.Key, "Type") ~= CustomHealthAPI.Enums.HealthTypes.CONTAINER and not mod.FriendGunIgnoredHearts[entry.Other.Key])
            if not filled then
                containers[i] = nil
            end
        end

        local lastHeartContainer = (ammo[#ammo] and ammo[#ammo].Index) or 0
        continueReloadCheck = lastHeartContainer < #containers

        if lastHeartContainer == #containers and #containers > 0 then
            if ammo[#ammo].HeartType == "Red" then
                if not containers[#containers].Red or ammo[#ammo].HealthPosition[1] < containers[#containers].Red.HP then
                    continueReloadCheck = true
                end
            elseif ammo[#ammo].HeartType == "Other" then
                if not containers[#containers].Other or ammo[#ammo].HealthPosition[1] < containers[#containers].Other.HP then
                    continueReloadCheck = true
                end
            end
        end

        local timeToReload = (
            (
                d.PreviousFireFrame
                and e.FrameCount-d.PreviousFireFrame > mod.FriendBalancing.AutoReloadTimer
            )
            or not d.PreviousFireFrame
        )

        if continueReloadCheck and player:IsExtraAnimationFinished() and timeToReload and d.state ~= "Reload" and room:GetFrameCount() > 1 and not d.NoReload then
            d.reloadOverride = true
            d.state = "Reload"
            d.substate = "Begin"
        end
    end

    -- Override everything and hold above head for Briend
    local holdAboveHead = false
    if isBriend then
        d.HeldAboveHeadTarget = d.HeldAboveHeadTarget or Vector(0, 0)

		local mainTwin = player:GetMainTwin()
		mod:TrySwapBriendDataOnEsauJr(mainTwin)
        local mainTwinData = mod:GetEntityData(mainTwin)
        if mainTwinData.Briend and mainTwinData.Briend.TryHoldGunAboveHead then
            local isHoldingBoth, holdBothOffset = false, mod.BriendBalancing.HoldGunAboveHeadBirthcakeOffset
			-- If we're the revolver and that should be held above the head
			if not mainTwinData.Briend.PrimaryBriendGetsItem and d.isFriendsPrimaryGun and not d.isBriendsPrimaryGun then
                holdAboveHead = true
            -- If we're the deagle and the revolver should be held above the head
            elseif mainTwinData.Briend.PrimaryBriendGetsItem and d.isFriendsPrimaryGun and d.isBriendsPrimaryGun then
                holdAboveHead = true
            end

			-- If we have Birthcake, hold both above head
            if mod:playerHasBirthcake(mainTwin) then
				holdAboveHead = true
				isHoldingBoth = true
				if mod:IsSelectedBriend(player) then
					holdBothOffset = -1 * mod.BriendBalancing.HoldGunAboveHeadBirthcakeOffset
				end
            end

            if fireInput:Length() > 0.5 then
                holdAboveHead = false
            end

            if d.state ~= "Idle" and not (d.state == "Reload" and d.substate == "End") then
                holdAboveHead = false
            end

            if continueReloadCheck then
                holdAboveHead = false
            end

            local anim = sprite:GetAnimation()
            if anim ~= "Idle" and anim ~= "Appear" and anim ~= "ReloadFinish" then
                holdAboveHead = false
            end

            if holdAboveHead then
                d.LockAngle = 180
                d.LastHeldAboveHeadFrame = e.FrameCount
                targetPos = parent.Position
                d.HeldAboveHeadTarget = mod:Lerp(d.HeldAboveHeadTarget, mod.BriendBalancing.HoldGunAboveHeadOffset * mainTwin.SpriteScale.Y + ((isHoldingBoth and holdBothOffset) or Vector.Zero), mod.BriendBalancing.HoldGunAboveHeadLerp)
            end
        end

        if not holdAboveHead then
            d.HeldAboveHeadTarget = mod:Lerp(d.HeldAboveHeadTarget, Vector(0, 0), mod.BriendBalancing.HoldGunAboveHeadLerp)

            if d.LockAngle and d.LastHeldAboveHeadFrame and e.FrameCount - d.LastHeldAboveHeadFrame < 5 then
                d.LockAngle = nil
            end
        end

        if pd.Briend then pd.Briend.HoldingGunAboveHead = holdAboveHead end
    end

    if d.PreviousFireFrame and e.FrameCount-d.PreviousFireFrame > 60 then
        d.PreviousFireFrame = nil
        d.PreviousGunDir = nil
    end

    local dir
    if fireDir then
        local targetDir = fireDir
        local targetAng = d.AngleOffset + mod:GetAngleDegreesButGood(targetDir)
        if math.abs(d.CurrentAngle-(targetAng+360)) < math.abs(d.CurrentAngle-targetAng) then
            d.CurrentAngle = mod:Lerp(d.CurrentAngle, 360+targetAng, 0.75)
        elseif math.abs(d.CurrentAngle-(targetAng-360)) < math.abs(d.CurrentAngle-targetAng) then
            d.CurrentAngle = mod:Lerp(d.CurrentAngle, targetAng-360, 0.75)
        else
            d.CurrentAngle = mod:Lerp(d.CurrentAngle, targetAng, 0.75)
        end
    else
        local targetDir = (parent.Velocity:Length() > 0.3 and parent.Velocity) or (player:GetMovementVector():Length() > 0.3 and player:GetMovementVector()) or parent.Velocity
        local targetAng = d.AngleOffset + mod:GetAngleDegreesButGood(targetDir)
        if math.abs(d.CurrentAngle-(targetAng+360)) < math.abs(d.CurrentAngle-targetAng) then
            d.CurrentAngle = mod:Lerp(d.CurrentAngle, 360+targetAng, 0.2)
        elseif math.abs(d.CurrentAngle-(targetAng-360)) < math.abs(d.CurrentAngle-targetAng) then
            d.CurrentAngle = mod:Lerp(d.CurrentAngle, targetAng-360, 0.6)
        else
            d.CurrentAngle = mod:Lerp(d.CurrentAngle, targetAng, 0.2)
        end
    end

    if Options.MouseControl and not overrideDir and pd.LastFiredMouse and (mouseAimingEnabled or player:HasCollectible(CollectibleType.COLLECTIBLE_ANALOG_STICK) or player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE)) then
        local pos = mod:GetMousePosition(true)
        local aimFromPos = targetPos
        if d.OwnedByIncubus then
            aimFromPos = player.Position
        end
        local tearHeight = d.ForceTearHeight or mod.FriendGunInfo[e.SubType].TearHeight or mod.FriendBalancing.DefaultTearHeight
        local aimDir = pos-aimFromPos-Vector(0, tearHeight)
        d.CurrentAngle = d.AngleOffset + mod:GetAngleDegreesButGood(aimDir)
    end

    if d.MeleeSwingAngle then
        d.CurrentAngle = d.MeleeSwingAngle
    elseif d.LockAngle then
        d.CurrentAngle = d.LockAngle
    end

    d.CurrentAngle = d.CurrentAngle % 360

    -- if briend and aiming up or down, change angle slightly so that the guns are flipped
    if (
        useBriendHandOffset
        and (
            (d.CurrentAngle > 75 and d.CurrentAngle < 105)
            or (d.CurrentAngle > 255 and d.CurrentAngle < 285)
        )
     ) then
        local angle = mod.BriendBalancing.AngleInwards * (isBriendGunInRightHand and -1 or 1)
        angle = angle * mod.sign(d.CurrentAngle)

        d.BriendInwardAngle = angle
    end

    if holdAboveHead then
        d.BriendInwardAngle = 0
    end

    local positionAngle = d.CurrentAngle
    if useBriendHandOffset then
        if not isBriendGunInRightHand then
            positionAngle = positionAngle + 90
        else
            positionAngle = positionAngle + 90
        end
    end
    positionAngle = d.CurrentAngle

    local offset = mod:GetHoriGunOffset(e, parent, d)
    local verticalOffset = mod:GetVertGunOffset(e, parent, d)

    if mod.FriendGunInfo[e.SubType].SpriteOffset then
        offset = offset + mod.FriendGunInfo[e.SubType].SpriteOffset.X
        verticalOffset = verticalOffset + mod.FriendGunInfo[e.SubType].SpriteOffset.Y
    end

    local currentAngle = d.CurrentAngle + (d.BriendInwardAngle or 0)
    if currentAngle > 0 and currentAngle < 180 then
        local real = (90-math.abs(90-currentAngle))/90
        offset = offset-offset*0.25*real
    end
    if e.Variant == mod.FF.FriendsRevolver.Var and d.state == "Reload" then
        d.reloadOffset = d.reloadOffset or 1
        if d.substate == "End" then
            d.startReloadOffset = nil
            offset = offset*d.reloadOffset
            d.reloadOffset = math.min(1, d.reloadOffset+0.1)
        elseif d.startReloadOffset then
            offset = offset*d.reloadOffset
            d.reloadOffset = math.max(0.5, d.reloadOffset-0.1)
        end
        d.PreviousFireFrame = e.FrameCount-20
    end

    if parent.Type == 1 and useBriendHandOffset then
        local add, product
        if not isBriendGunInRightHand then
            add = (player:GetCostumeNullPos("RightEye", true, Vector(0, -1)) * mod.BriendBalancing.HandHoriOffsetMult)
            product = Vector.FromAngle(currentAngle):Dot(Vector(-1, 0))
        else
            add = (player:GetCostumeNullPos("LeftEye", true, Vector(0, -1)) * mod.BriendBalancing.HandHoriOffsetMult)
            product = Vector.FromAngle(currentAngle):Dot(Vector(1, 0))
        end

        pd.BriendFinalHandOffset = pd.BriendFinalHandOffset + add + Vector(add.X * product, 0)

        -- Makes the gun layering actually look good when aiming at 45 degree angles downwards left or right
        local dotRight = Vector.FromAngle(currentAngle):Dot(Vector(1, 0))
        if dotRight > 0 then
            if not isBriendGunInRightHand then
                e.DepthOffset = -5
            else
                e.DepthOffset = 5
            end
        else
            if not isBriendGunInRightHand then
                e.DepthOffset = 5
            else
                e.DepthOffset = -5
            end
        end
    else
        e.DepthOffset = 5
    end

    dir = Vector(offset, 0):Rotated(positionAngle)

    if useBriendHandOffset then
        pd.BriendCurrentHandOffset = pd.BriendCurrentHandOffset and mod:Lerp(pd.BriendCurrentHandOffset, pd.BriendFinalHandOffset, mod.BriendBalancing.GunSwitchSpeed) or pd.BriendFinalHandOffset
        dir = dir + pd.BriendCurrentHandOffset
    end

    dir = dir + Vector(0, verticalOffset)

    if d.MultishotOffset then
        dir = dir + d.MultishotOffset:Rotated(currentAngle)
    end

    e.SpriteRotation = currentAngle

    local sword = (e.SubType == CollectibleType.COLLECTIBLE_SPIRIT_SWORD or e.SubType == CollectibleType.COLLECTIBLE_BERSERK) and not (d.state == "Reload" and (d.substate == "Loading" or d.substate == "End"))
    if currentAngle > 90 and currentAngle <= 270 and not sword then
        sprite.FlipX = true
        e.SpriteRotation = 180-e.SpriteRotation
    else
        sprite.FlipX = false
    end

    if sprite.FlipY and not sword then
        sprite.FlipY = false
    end

    if sprite.FlipY then
        e.SpriteRotation = -e.SpriteRotation
    end

    if holdAboveHead then
        dir = Vector(0, 0)
    end

    if e.FrameCount < 2 or forceNoLerp then
        e.Position = targetPos + dir
        e.Velocity = Vector.Zero
    else
        local velocityCompensation = d.OwnedByIncubus and 1 or 2.5
        e.Velocity = (targetPos + parent.Velocity*velocityCompensation + dir) - e.Position - (d.HeldAboveHeadTarget or mod.nilvector)
    end
end

--This is for guns that are used outside of Friend
function mod:StandardGunMovement(e, player, forceNoLerp, target)
    target = target or player
    local d = mod:GetEntityData(e)
    local pd = mod:GetEntityData(player)
    local sprite = e:GetSprite()
    local fireDir = player:GetAimDirection()
    local room = game:GetRoom()
    if not pd.LastFiredMouse or mod.MouseGunAiming == 0 then
        fireDir = FiendFolio.GetCorrectedFiringInput(player)
    end
    d.CurrentAngle = d.CurrentAngle or 90
    if fireDir:Length() > 0.5 then
        d.PreviousGunDir = Vector(fireDir.X, fireDir.Y)

		local isMegaBlasting = player:GetMegaBlastDuration() > 0
		if player:GetPlayerType() == mod.PLAYER.BRIEND then
			local othertwin = player:GetOtherTwin()
			if othertwin then
				isMegaBlasting = isMegaBlasting or othertwin:GetMegaBlastDuration() > 0
			end
		end
		if not isMegaBlasting then
			d.PreviousFireFrame = e.FrameCount
		end
    else
        fireDir = d.PreviousGunDir
    end
    local targetPos = target.Position

    if d.PreviousFireFrame and e.FrameCount-d.PreviousFireFrame > 60 then
        d.PreviousFireFrame = nil
        d.PreviousGunDir = nil
    end

    local dir
    if fireDir then
        local targetDir = fireDir
        local targetAng = d.AngleOffset + mod:GetAngleDegreesButGood(targetDir)
        if math.abs(d.CurrentAngle-(targetAng+360)) < math.abs(d.CurrentAngle-targetAng) then
            d.CurrentAngle = mod:Lerp(d.CurrentAngle, 360+targetAng, 0.75)
        elseif math.abs(d.CurrentAngle-(targetAng-360)) < math.abs(d.CurrentAngle-targetAng) then
            d.CurrentAngle = mod:Lerp(d.CurrentAngle, targetAng-360, 0.75)
        else
            d.CurrentAngle = mod:Lerp(d.CurrentAngle, targetAng, 0.75)
        end
    else
        local targetDir = (target.Velocity:Length() > 0.3 and target.Velocity) or (player:GetMovementVector():Length() > 0.3 and player:GetMovementVector()) or target.Velocity
        local targetAng = d.AngleOffset + mod:GetAngleDegreesButGood(targetDir)
        if math.abs(d.CurrentAngle-(targetAng+360)) < math.abs(d.CurrentAngle-targetAng) then
            d.CurrentAngle = mod:Lerp(d.CurrentAngle, 360+targetAng, 0.2)
        elseif math.abs(d.CurrentAngle-(targetAng-360)) < math.abs(d.CurrentAngle-targetAng) then
            d.CurrentAngle = mod:Lerp(d.CurrentAngle, targetAng-360, 0.6)
        else
            d.CurrentAngle = mod:Lerp(d.CurrentAngle, targetAng, 0.2)
        end
    end

    if pd.LastFiredMouse and mod.MouseGunAiming == 1 and Options.MouseControl then
        local pos = mod:GetMousePosition(true)
        local height = d.ForceTearHeight or (mod.FriendGunInfo[e.SubType] and mod.FriendGunInfo[e.SubType].TearHeight) or mod.FriendBalancing.DefaultTearHeight
        d.CurrentAngle = d.AngleOffset + mod:GetAngleDegreesButGood(pos-targetPos-Vector(0, height))
    end

    if d.LockAngle then
        d.CurrentAngle = d.LockAngle
    end

    d.CurrentAngle = d.CurrentAngle % 360

    local offset = d.ForceHeldOffset or (mod.FriendGunInfo[e.SubType] and mod.FriendGunInfo[e.SubType].HeldOffset) or mod.FriendBalancing.DefaultHeldOffset
    local verticalOffset = d.ForceVerticalOffset or (mod.FriendGunInfo[e.SubType] and mod.FriendGunInfo[e.SubType].VerticalOffset) or mod.FriendBalancing.DefaultVerticalOffset

    if mod.FriendGunInfo[e.SubType] and mod.FriendGunInfo[e.SubType].SpriteOffset then
        offset = offset + mod.FriendGunInfo[e.SubType].SpriteOffset.X
        verticalOffset = verticalOffset + mod.FriendGunInfo[e.SubType].SpriteOffset.Y
    end

    if d.CurrentAngle > 0 and d.CurrentAngle < 180 then
        local real = (90-math.abs(90-d.CurrentAngle))/90
        offset = offset-offset*0.25*real
    end
    if e.Variant == mod.FF.FriendsRevolver.Var and d.state == "Reload" then
        d.reloadOffset = d.reloadOffset or 1
        if d.substate == "End" then
            d.startReloadOffset = nil
            offset = offset*d.reloadOffset
            d.reloadOffset = math.min(1, d.reloadOffset+0.1)
        elseif d.startReloadOffset then
            offset = offset*d.reloadOffset
            d.reloadOffset = math.max(0.5, d.reloadOffset-0.1)
        end
        d.PreviousFireFrame = e.FrameCount-20
    end
    dir = Vector(offset, verticalOffset):Rotated(d.CurrentAngle)

    if d.MultishotOffset then
        dir = dir + d.MultishotOffset:Rotated(d.CurrentAngle)
    end

    e.SpriteRotation = d.CurrentAngle

    if d.CurrentAngle > 90 and d.CurrentAngle <= 270 then
        sprite.FlipX = true
        e.SpriteRotation = 180-e.SpriteRotation
    else
        sprite.FlipX = false
    end

    if sprite.FlipY then
        sprite.FlipY = false
    end

    if sprite.FlipY then
        e.SpriteRotation = -e.SpriteRotation
    end

    if e.FrameCount < 2 or forceNoLerp then
        e.Position = targetPos + dir
        e.Velocity = Vector.Zero
    else
        e.Velocity = (targetPos+target.Velocity*2.5+dir) - e.Position
    end
end

function mod:GunDataInit(player, gun, d)
    d.FriendHeldGuns = d.FriendHeldGuns or {}
    d.FFHeldGuns = d.FFHeldGuns or {}
    if gun.Variant == mod.FF.FriendsRevolver.Var then
        d.FriendHeldGuns[gun.InitSeed] = {Gun = gun, LastFrameFired = 0}
    else
        d.FFHeldGuns[gun.SubType] = d.FriendHeldGuns[gun.SubType] or {}
        d.FFHeldGuns[gun.SubType][gun.InitSeed] = {Gun = gun, LastFrameFired = 0}
    end
end

function mod:GunNewRoom(player, d)
    if mod:IsAnyFriend(player) then
        mod:SpawnFriendGunIfDoesntExist(player, d)
    end
    if d.FFHeldGuns then
        for subtype,tab in pairs(d.FFHeldGuns) do --So entering new rooms doesn't have the gun fly across the screen
            for _,gTab in pairs(tab) do
                --Isaac.RunCallbackWithParam("POST_GUN_NEW_ROOM", gTab.Gun.SubType, gTab.Gun, player)
                local gd = mod:GetEntityData(gTab.Gun)
                gTab.Gun.Position = player.Position
                gTab.LastFrameFired = gTab.Gun.FrameCount
                gd.PreviousFireFrame = nil
                gd.PreviousGunDir = nil
                gTab.Gun:Update()
            end
        end
    end
    if d.FriendHeldGuns then
        for initseed,gTab in pairs(d.FriendHeldGuns) do
            if gTab.Gun and gTab.Gun:Exists() then
                Isaac.RunCallbackWithParam("POST_GUN_NEW_ROOM", gTab.Gun.SubType, gTab.Gun, player)
                local gd = mod:GetEntityData(gTab.Gun)
                gTab.Gun.Position = player.Position
                gd.reloadBonusActivated = 1
                if not mod:GetEntityData(gTab.Gun).DontReloadNewRoom then
                    gTab.Ammo = mod:GetFriendAmmo(gTab.Gun)
                end
                if gd.state == "Reload" then
                    gTab.Gun:GetSprite():Play("ReloadFinish", true)
                    gd.substate = "End"
                else
                    gd.state = "Idle"
                end
                gTab.LastFrameFired = gTab.Gun.FrameCount
                gd.PreviousFireFrame = nil
                gd.PreviousGunDir = nil
				gd.MegaBlastDesync = nil
                gTab.Gun:Update()
            end
        end
        mod:UpdateMultishotGuns(player)
    end
end

---@param ent Entity Either a Friend EntityPlayer or a Friend gun EntityEffect
---@param loadedAmmo boolean|table? Limit to only ammo currently loaded by the gun, or pass a table to take the place of the gun's current loaded ammo
function mod:GetFriendAmmo(ent, loadedAmmo)
    local player, gun
    if ent.Type == EntityType.ENTITY_PLAYER then
        player = ent:ToPlayer()
        gun = mod:GetEntityData(player).FriendsRevolver
    else
        gun = ent:ToEffect()
        player = mod:GetFriendGunPlayer(gun)
    end

    if not player then return end
    --local rng = gun:GetDropRNG()

    local gunTable = gun and mod:GetEntityData(player).FriendHeldGuns[gun.InitSeed] or {}

    local shots = {}

    local fixedAmmo = gunTable.FixedAmmo

    if fixedAmmo then
        if type(fixedAmmo) == "string" then
            local playerhp = CustomHealthAPI.Helper.GetTotalRedHP(player) + CustomHealthAPI.Helper.GetTotalSoulHP(player)
            for i=1, playerhp do
                table.insert(shots, {HeartKey = fixedAmmo})
            end
        elseif type(fixedAmmo) == "table" then
            for i, shot in ipairs(fixedAmmo) do
                table.insert(shots, mod:makeCopiedTable(shot))
            end
        end
        for i, shot in ipairs(shots) do
            shot.HeartKey = shot.HeartKey or "RED_HEART"
            shot.Index = i
            shot.LastInHeart = i % 2 == 0
            shot.HealthPosition = {(i % 2)+1, 2}
            shot.HeartType = CustomHealthAPI.Library.GetInfoOfKey(shot.HeartKey, "Type") == CustomHealthAPI.Enums.HealthTypes.RED and "Red" or "Other"
        end
    elseif player:IsCoopGhost() then
        local numShots = mod:IsBriendTwin(player) and 2 or 3
        for i=1,numShots do
            table.insert(shots, {Index = 1, HeartKey = "RED_HEART", LastInHeart = (i == numShots), HealthPosition = {i, numShots}, HeartType = "Red"})
        end
    else
        local order = CustomHealthAPI.Library.GetHealthInOrder(player, false)
		local lastRed
		local firstSoul
        for k,entry in ipairs(order) do
            local red = entry.Red
            local other = entry.Other
			local overlays = entry.Overlays

			local heartKey, containerKey, hp, heartType
			if red and red.HP > 0 then
				heartKey = red.Key
				containerKey = other and other.Key and CustomHealthAPI.Library.GetInfoOfKey(other.Key, "Type") == CustomHealthAPI.Enums.HealthTypes.CONTAINER and other.Key
				hp = red.HP
				heartType = "Red"
			elseif other and other.HP > 0 and other.Key and CustomHealthAPI.Library.GetInfoOfKey(other.Key, "Type") == CustomHealthAPI.Enums.HealthTypes.SOUL then
				heartKey = other.Key
				hp = other.HP
				heartType = "Other"
			end

			if hp then
				for i=1,hp do
					local shot = {Index = k, HeartKey = heartKey, ContainerKey = containerKey, OverlayKeys = {}, LastInHeart = (i == hp), HealthPosition = {i, hp}, HeartType = heartType}
					for _,overlayEntry in ipairs(overlays) do
						if overlayEntry.Key ~= "ETERNAL_HEART" then
							shot.OverlayKeys[overlayEntry.Key] = true
						end
					end
					if not mod.FriendGunIgnoredHearts[heartKey] then
						table.insert(shots, shot)
					end
					if heartType == "Red" then
						lastRed = shot
					elseif heartType == "Other" and firstSoul == nil then
						firstSoul = shot
					end
				end
			end
        end

        if #shots == 0 then
            if order[1] and order[1].Other and order[1].Other.HP > 0 and CustomHealthAPI.Library.GetInfoOfKey(order[1].Other.Key, "Type") == CustomHealthAPI.Enums.HealthTypes.CONTAINER then
				local key = order[1].Other.Key
				local overlays = order[1].Other.Overlays or {}
                local shot = {Index = 1, HeartKey = key, OverlayKeys = {}, LastInHeart = true, HealthPosition = {1, 1}, HeartType = "Other"}
				for _,overlayEntry in ipairs(overlays) do
					if overlayEntry.Key ~= "ETERNAL_HEART" then
						shot.OverlayKeys[overlayEntry.Key] = true
					end
				end
				if not mod.FriendGunIgnoredHearts[key] then
					table.insert(shots, shot)
				end
				firstSoul = shot
            else
                local shot = {Index = 1, HeartKey = "RED_HEART", LastInHeart = true, HealthPosition = {1, 1}, HeartType = "Red"}
				table.insert(shots, shot)
				lastRed = shot
            end
        end

		-- so eternal hearts are always actually attached to a bullet since they act weird as far as overlays go
		local eternal = CustomHealthAPI.Library.GetHPOfKey(player, "ETERNAL_HEART", true)
        if eternal > 0 then
            if lastRed then
                lastRed.OverlayKeys = lastRed.OverlayKeys or {}
				lastRed.OverlayKeys["ETERNAL_HEART"] = true
            elseif firstSoul then
                firstSoul.OverlayKeys = firstSoul.OverlayKeys or {}
				firstSoul.OverlayKeys["ETERNAL_HEART"] = true
            end
        end
    end

	if #shots > 0 and player:GetPlayerType() == FiendFolio.PLAYER.FRIEND then
		local _, birthcakeMult = mod:playerHasBirthcake(player)
		for i = 1, birthcakeMult do
			table.insert(shots, 1, {Index = -1 * i, HeartKey = "RED_HEART", LastInHeart = true, HealthPosition = {1, 1}, HeartType = "Red"})
		end
	end

    if type(loadedAmmo) == "boolean" then
        loadedAmmo = loadedAmmo and gunTable.Ammo or nil
    end

    if loadedAmmo then
        local lastChecked = 0
        local newTable = {}
        for i=1, #loadedAmmo do
            local entry = shots[i]
            if entry then
                lastChecked = i
                table.insert(newTable, entry)
            else
                lastChecked = -1
                break
            end
        end
        if lastChecked > 0 and lastChecked < #shots then
            --actually, do nothing unless you want to add unloaded shots to the ammo for some reason
        end

        return newTable
    else
        return shots
    end
end

--BulletVariant
local goldBulletCache = {}

function mod:TurnTearToFriendBullet(tear, gunType, player, gunInfo)
    if not Isaac.RunCallbackWithParam(mod.CALLBACK.FF_PRE_TURN_TEAR_TO_FRIEND_BULLET, gunType, tear, player, gunInfo) then
        gunInfo = gunInfo or mod.FriendGunInfo[gunType]

        if not gunInfo or not gunInfo.UseDefaultTears then
            local sprite = tear:GetSprite()
            local bulletVariant = mod.TEAR.FRIEND_BULLET
            local bulletSubType = 0
            local bulletAnm2, bulletSheet, bulletSheetGold

            -- Get the replacements
            if gunInfo then
                bulletVariant   = gunInfo.BulletVariant or bulletVariant
                bulletSubType   = gunInfo.BulletSubType or bulletSubType
                bulletAnm2      = gunInfo.BulletAnim
                bulletSheet     = gunInfo.BulletSprite
                bulletSheetGold = gunInfo.BulletSpriteGold
            end

            mod:changeTearVariant(tear, bulletVariant)
            tear.SubType = bulletSubType

            if tear.Variant == bulletVariant then
                -- Change the anm2
                if bulletAnm2 then
                    sprite:Load(bulletAnm2, true)
                end

                -- Change the spritesheet
                if bulletSheet then
                    sprite:ReplaceSpritesheet(0, bulletSheet, true)
                end
            end

            -- Golden bullets for Briend's Deagle
            if mod:IsBriendTwin(player) and not gunInfo.NoGoldenBullet then
                local baseSheet = sprite:GetLayer(0):GetSpritesheetPath()
                local cachedGoldSheet = goldBulletCache[baseSheet]

                -- Check if there is a gold version of the current sprite
                if cachedGoldSheet == nil then
                    local goldSheet = bulletSheetGold

                    if bulletSheetGold == nil then
                        goldSheet = string.gsub(baseSheet, ".png", "_gold.png")
                    end

                    -- Cache the filepath if there is
                    if pcall(function() Renderer.LoadImage(goldSheet) end) then
                        cachedGoldSheet = goldSheet
                    else
                        cachedGoldSheet = false
                    end

                    goldBulletCache[baseSheet] = cachedGoldSheet
                end

                -- Use the gold vesrion of the sprite if it exists
                if cachedGoldSheet then
                    sprite:ReplaceSpritesheet(0, cachedGoldSheet, true)
                end
            end
        end

        mod:GetEntityData(tear).FriendBulletInfo = gunInfo
    end
end

function mod:TurnSplitTearToFriendBullet(tear, source, splitTearType)
    local gunInfo = mod:GetEntityData(source).FriendBulletInfo

    if source:ToTear() and tear.Variant == source.Variant and gunInfo then
        local player = source.SpawnerEntity and source.SpawnerEntity:ToPlayer()
        local subType = 0

        -- Pass the gun subtype just in case
        if player then
            local gun = mod:GetEntityData(player).FriendsRevolver

            if gun then
                subType = gun.SubType
            end
        end

        mod:TurnTearToFriendBullet(tear, subType, player, gunInfo)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_FIRE_SPLIT_TEAR, mod.TurnSplitTearToFriendBullet)

mod:AddPriorityCallback(ModCallbacks.MC_PLAYER_GET_HEART_LIMIT, CallbackPriority.IMPORTANT, function (_, player, limit, ignoreModifiers)
	if ignoreModifiers then
		return 12
	else
		local brokenHearts = player:GetBrokenHearts()
		return (6 - brokenHearts) * 2
	end
end, FiendFolio.PLAYER.FRIEND)

---@param entity Entity
---@param subType integer? Gun type
---@param passedplayer EntityPlayer? If the entity belongs to a player and is not a player, set this.
---@param fixedAmmo string?|table? Pass a chapi heart key string or a table of friend Ammo to force the gun to use specific ammo.
function mod:SpawnFriendGun(entity, subType, passedplayer, fixedAmmo)
    local player = passedplayer or entity:ToPlayer()
    local d = player and mod:GetEntityData(player) or mod:GetEntityData(entity)
    local gun = Isaac.Spawn(mod.FF.FriendsRevolver.ID, mod.FF.FriendsRevolver.Var, mod.FF.FriendsRevolver.Sub, entity.Position, Vector.Zero, player):ToEffect()
    local gd = mod:GetEntityData(gun)
    gun.Parent = entity
    gun.SpawnerEntity = player
    gun.SpriteOffset = Vector(0,-9)
   -- gun.SpriteOffset = subType and mod.FriendGunInfo[subType].SpriteOffset or mod.FriendBalancing.DefaultSpriteOffset
    gun.DepthOffset = 5
    gd.state = "Init"
    gd.StateFrame = 0
    gd.AngleOffset = 0
    gun:AddEntityFlags(EntityFlag.FLAG_PERSISTENT | EntityFlag.FLAG_DONT_OVERWRITE)
    mod:GunDataInit(player, gun, d)
    local gunTable = d.FriendHeldGuns[gun.InitSeed]
    gunTable.FixedAmmo = fixedAmmo
    gunTable.Ammo = mod:GetFriendAmmo(gun)
    if subType then
        mod:ReplaceFriendGun(gun, player, subType)
    end
    Isaac.RunCallbackWithParam("POST_GUN_INIT", gun.SubType, gun, player)
    return gun
end

-- Handles spawning, removing, or replacing any additional guns for Multishot effects (mutant spider, inner eye, etc).
function mod:UpdateMultishotGuns(parent, forceUpdatePositions)
	local player = parent:ToPlayer()
	local isFamiliar = player == nil

	if isFamiliar then
		parent = parent:ToFamiliar()
		if not parent then
			return
		end
		player = parent.Player
	end

	local parentData = mod:GetEntityData(parent)
    if isFamiliar and parentData.BriendOriginalPlayer then
        player = parentData.BriendOriginalPlayer
    end

	if isFamiliar and not parentData.FamiliarCopyingFriendsGuns then
		return
	end

    local shouldDoEverything = true
	if not player or player:GetPlayerType() ~= mod.PLAYER.FRIEND then
        if not (isFamiliar and player:GetPlayerType() == mod.PLAYER.BRIEND) then
            shouldDoEverything = false
        end
    end

	if shouldDoEverything then
        local playerData = mod:GetEntityData(player)
        playerData.FriendLastMultishotUpdate = player.FrameCount

        local allGuns = playerData.FriendHeldGuns

        if not parentData.FriendsMultishotGuns then
            parentData.FriendsMultishotGuns = {}
        end
        local multiShotGuns = parentData.FriendsMultishotGuns

        local mainGun = playerData.FriendsRevolver
        if not mainGun or not mainGun:Exists() then
            playerData.FriendsRevolver = nil
            return
        end

        local mainGunData = mod:GetEntityData(mainGun)

        local multiShotInfo
        if mainGunData.RevolverInvisible then
            multiShotInfo = mod:GetMultiShotInfo(player, 1, 1)
        else
            multiShotInfo = mod:GetRealMultiShotInfo(player)
        end

        -- Conjoined transformation is dum
        if player:HasPlayerForm(PlayerForm.PLAYERFORM_BABY) then
            if multiShotInfo.NumEyes == 1 then
                multiShotInfo.NumTears = math.max(multiShotInfo.NumTears - 2, 1)
                multiShotInfo.NumTearsPerEye = math.max(multiShotInfo.NumTearsPerEye - 2, 1)
            end

            -- Don't apply the effect under certain conditions
            local canApply = true

            for _, check in ipairs(RemoveGunIfFriendHas) do
                local isFunc = type(check) == "function"

                if (isFunc and check(player)) or (not isFunc and player:HasCollectible(check)) then
                    canApply = false
                    break
                end
            end

            multiShotInfo.ApplyConjoined = canApply
        end

        local redLyreActive = player:HasCollectible(mod.ITEM.COLLECTIBLE.ANGELIC_LYRE_R) or (player:HasCollectible(CollectibleType.COLLECTIBLE_VOID) and playerData.ffsavedata.VoidedLyre == 2)
        if redLyreActive then
            multiShotInfo.NumTearsPerEye = multiShotInfo.NumTearsPerEye * 4
        end

        local numWeezerGuns = 0

        -- If the primary gun is the Weezer gun, "merge" as many batches of 4 tears as possible into more weezer guns.
        -- IE, if you would normally shoot 9 tears, you'll end up with 2 weezer guns and 1 other gun.
        if mainGun.SubType == CollectibleType.COLLECTIBLE_MUTANT_SPIDER and player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) then
            local eligibleTearsToMerge = multiShotInfo.NumTears
            numWeezerGuns = math.max(1, math.floor(eligibleTearsToMerge / 4))
            multiShotInfo.NumTears = math.max(multiShotInfo.NumTears - numWeezerGuns * 3, multiShotInfo.NumEyes)
            multiShotInfo.NumTearsPerEye = math.ceil(multiShotInfo.NumTears / multiShotInfo.NumEyes)
            if multiShotInfo.NumTears == 2 then
                multiShotInfo.SpreadAngle = 0
            end
        end

        local gunOffsets = mod:CalcMultiShotOffsets(multiShotInfo)
        local numGuns = #gunOffsets

        -- Try to put the primary gun near the middle.
        local mainGunIdx = math.ceil(mod:Lerp(1, numGuns, 0.5))

        local firstWeezerGun = 0
        local lastWeezerGun = 0

        if numWeezerGuns == 1 then
            firstWeezerGun = mainGunIdx
            lastWeezerGun = mainGunIdx
        elseif numWeezerGuns > 1 then
            firstWeezerGun = math.max(1, mainGunIdx - math.floor(numWeezerGuns/2))
            lastWeezerGun = firstWeezerGun + numWeezerGuns - 1
        end

        -- Pick another gun to turn any non-weezer guns into.
        local weezerFallback = mod.FF.FriendsRevolver.Sub
        if numWeezerGuns > 0 then
            for id, tab in pairs(mod.FriendGunInfo) do
                if id ~= CollectibleType.COLLECTIBLE_MUTANT_SPIDER and tab.Priority > mod.FriendGunInfo[weezerFallback].Priority and mod:HasGunCollectible(player, id, tab) then
                    weezerFallback = id
                end
            end
        end

        local exGunId = 1

        for i, posVel in ipairs(gunOffsets) do
            local gun
            if not isFamiliar and i == mainGunIdx then
                -- The "primary" gun goes in this spot.
                gun = mainGun
            else
                -- One of the extra multishot guns goes here.
                gun = mod:GetPointee(multiShotGuns[exGunId])
                if not gun then
                    gun = mod:SpawnFriendGun(parent, nil, player)
                    local gd = mod:GetEntityData(gun)
                    gd.isFriendMultishotGun = true
                    gd.OwnedByIncubus = isFamiliar
                    gd.FriendConserveAmmo = mainGunData.FriendConserveAmmo
                    multiShotGuns[exGunId] = EntityPtr(gun)

                    local mainGunTab = allGuns[mainGun.InitSeed]
                    local newGunTab = allGuns[gun.InitSeed]
                    newGunTab.Ammo = mod:makeCopiedTable(mainGunTab.Ammo)
                    newGunTab.HeldDown = mainGunTab.HeldDown
                end
                exGunId = exGunId + 1

                local isWeezerGunSlot = (i >= firstWeezerGun and i<= lastWeezerGun)
                if isWeezerGunSlot then
                    mod:ReplaceFriendGun(gun, player, CollectibleType.COLLECTIBLE_MUTANT_SPIDER)
                elseif mainGun.SubType == CollectibleType.COLLECTIBLE_MUTANT_SPIDER then
                    mod:ReplaceFriendGun(gun, player, weezerFallback)
                else
                    mod:ReplaceFriendGun(gun, player, mainGun.SubType)
                end
            end

            local gd = mod:GetEntityData(gun)
            gd.MultishotOffset = posVel.Position * 10
            gd.AngleOffset = posVel.Velocity:GetAngleDegrees()

            -- R U A WIZARD o( _ )o
            if playerData.WizardTracker then
                gd.AngleOffset = gd.AngleOffset + playerData.WizardTracker
            end

            if forceUpdatePositions then
                mod:GunMovement(gun, true)
            end
        end

        -- Remove any excess multishot guns that were previously spawned but no longer needed.
        local currentGunCount = #multiShotGuns
        for i=exGunId, currentGunCount do
            local gun = mod:GetPointee(multiShotGuns[i])
            if gun then
                --allGuns[gun.InitSeed] = nil
                --gun:Remove()
                mod:GetEntityData(gun).expiringGun = true
            end
            multiShotGuns[i] = nil
        end
	end

	if not isFamiliar then
		for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR)) do
            local fam = ent:ToFamiliar()
            local p = mod:GetEntityData(fam).BriendOriginalPlayer or fam.Player
			if p and GetPtrHash(p) == GetPtrHash(player) then
				mod:UpdateMultishotGuns(fam, forceUpdatePositions)
			end
		end
	end
end

-- Handles positioning Soul of Friend guns so theyre not all stacked on top of eachother
function mod:PositionSoulGuns(player)
	local playerData = mod:GetEntityData(player)

    if not playerData.FriendHeldGuns or mod:IsBriendTwin(player) then
        return
    end

    -- Position both Briend's guns together
    local allGuns = playerData.FriendSoulGuns

    if player:GetPlayerType() == mod.PLAYER.BRIEND then
        local twin = mod:GetBriendTwin(player)
        local twinData = mod:GetEntityData(twin)
        local twinGuns = twinData.FriendSoulGuns

        if twinGuns then
            allGuns = mod:MergeArrays(allGuns, twinGuns)
        end
    end

    local multiShotInfo = mod:GetMultiShotInfo(player, #allGuns, 1)
    local gunOffsets = mod:CalcMultiShotOffsets(multiShotInfo)
    local exGunId = 1

    for i, posVel in ipairs(gunOffsets) do
        local gun = mod:GetPointee( allGuns[exGunId] )
        if gun then
            local gunData = mod:GetEntityData(gun)
            gunData.MultishotOffset = posVel.Position * 10
            gunData.AngleOffset = posVel.Velocity:GetAngleDegrees()
            exGunId = exGunId + 1
        end
    end
end

-- Removes the `not :Exists()` guns that occasionally build up in the guns table
-- IDK how but sometimes volatile guns spawned by Evil Eye seem to get re-registered to Friend after the Evil Eye disappears, even though the gun doesn't :Exist()
-- That causes problems, this seems to fix them
function mod:CleanFriendHeldGuns(data)
    if not data.FriendHeldGuns then
        return
    end

    for key, gunTable in pairs(data.FriendHeldGuns) do
        if gunTable.Gun and not gunTable.Gun:Exists() then
            data.FriendHeldGuns[key] = nil
        end
    end
end

function mod:SpawnFriendGunIfDoesntExist(player, d)
    if (not d.FriendsRevolver or not d.FriendsRevolver:Exists()) then
        local isBriend = player:GetPlayerType() == mod.PLAYER.BRIEND
        d.FriendsRevolver = mod:SpawnFriendGun(player, isBriend and mod.SpecialFriendGunSubtypes.BRIEND_DEAGLE or nil)
        local revolverData = mod:GetEntityData(d.FriendsRevolver)
        revolverData.isFriendsPrimaryGun = true
        mod:CheckCurrentGunReplacement(player)

        if isBriend and not mod:IsBriendTwin(player) then
            revolverData.isBriendsPrimaryGun = true
        end
    end
end

function mod:GetRandomFriendGunSubtype(filter, rng)
    local validSubtypes = {}
    local invalidSubtypes = {}

    for _, sub in pairs(mod.SpecialFriendGunSubtypes) do
        invalidSubtypes[sub] = true
    end

    for sub, info in pairs(mod.FriendGunInfo) do
        if not invalidSubtypes[sub] and (not filter or filter(info)) then
            table.insert(validSubtypes, sub)
        end
    end

    return mod:RandomIndex(validSubtypes, rng)
end

-- Subtracts limited ammo from a gun, used for Soul of Friend guns
function mod:SubtractLimitedAmmo(gunData, amount)
    amount = amount or 1
    if gunData.GunLimitedAmmo then
        gunData.GunLimitedAmmo = gunData.GunLimitedAmmo - amount
    end
end

-- Gets all guns (held or soul) of a specific subtype.
function mod:GetGunsOfSubtype(player, sub)
    local pd = mod:GetEntityData(player)
    local guns = {}

    if pd.FriendHeldGuns then
        for _, gun in pairs(pd.FriendHeldGuns) do
            if gun.Gun.SubType == sub then
                table.insert(guns, gun)
            end
        end
    end

    return guns
end

function mod:GetGunsWithSynergy(player, collectible)
    local pd = mod:GetEntityData(player)
    local guns = {}

    if pd.FriendHeldGuns then
        for _, gun in pairs(pd.FriendHeldGuns) do
            if mod:ShouldRunSynergy(player, gun.Gun, collectible) then
                table.insert(guns, gun)
            end
        end
    end

    return guns
end

function mod:FriendPeffectUpdate(player, d)
    mod:CleanFriendHeldGuns(d)

    if mod:IsAnyFriend(player) then
        if player:IsCoopGhost() then
            -- This is not ideal, but co-op ghosts ignore canshoot. Probably fine, since friend themselves does not rely on .FireDelay
            player.FireDelay = 1
        end

        d.WasFriendFromFiendFolio = true

        mod:SpawnFriendGunIfDoesntExist(player, d)

        if d.FriendsRevolver and d.FriendsRevolver:Exists()
        and d.FriendsRevolver.SubType ~= mod.FF.FriendsRevolver.Sub
        and d.FriendsRevolver.SubType > 0 then
            local gunInfo = mod.FriendGunInfo[d.FriendsRevolver.SubType]
            if not gunInfo or (gunInfo.IsCollectible and not mod:HasGunCollectible(player, d.FriendsRevolver.SubType, gunInfo)) then
                mod:CheckCurrentGunReplacement(player, nil, game:GetRoom():HasCurseMist())
            end
        end

        local invisible = mod:GetEntityData(d.FriendsRevolver).RevolverInvisible
        local turnedInvisible = false
        for _, collectible in ipairs(RemoveGunIfFriendHas) do
            if type(collectible) == "function" then
                if collectible(player) then
                    mod:GetEntityData(d.FriendsRevolver).RevolverInvisible = true
                    turnedInvisible = true
                    break
                end
            elseif player:HasCollectible(collectible) then
                mod:GetEntityData(d.FriendsRevolver).RevolverInvisible = true
                turnedInvisible = true
                break
            end
        end

        if not turnedInvisible and invisible then
            mod:GetEntityData(d.FriendsRevolver).RevolverInvisible = false
            invisible = false
        else
            invisible = turnedInvisible
        end

        if mod:ShouldPlayerGetInitialised(player) and player:GetPlayerType() == mod.PLAYER.FRIEND then
            --player:SetPocketActiveItem(mod.ITEM.COLLECTIBLE.HOT_SHOT)
        end

		d.friendFireballs = d.friendFireballs or {}
		for i, entity in pairs(d.friendFireballs) do
			if not entity or not entity:Exists() then
				table.remove(d.friendFireballs, i)
			end
		end

        if player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION) then
            player:SetCanShoot(true)
        elseif player:HasCollectible(CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE) then
            player:SetCanShoot(true)
            local ludo = mod:GetPointee(d.FriendLudoDrone)
            if not ludo then
                for _,tear in ipairs(Isaac.FindByType(2, -1, -1, false, false)) do
                    tear = tear:ToTear()
                    if tear.SpawnerEntity and GetPtrHash(tear.SpawnerEntity) == GetPtrHash(player) and tear:HasTearFlags(TearFlags.TEAR_LUDOVICO) then
                        d.FriendLudoDrone = EntityPtr(tear)
                        mod:GetEntityData(tear).FriendLudoPlayer = player
                        ludo = tear
                        break
                    end
                end
            end
            if ludo then
                --ludo.Scale = 1
                --ludo.CollisionDamage = 1  -- This didn't seem to be working, also unsure if necessary?
                ludo.Height = -10
            end
        elseif player:CanShoot() then
            player:SetCanShoot(false)
        end

        if not d.FriendBlockedCollectibles then
            d.FriendBlockedCollectibles = {}
        end
        for _, id in ipairs(mod.FriendBlockedCollectibles) do
            if not player:IsCollectibleBlocked(id) then
                player:BlockCollectible(id)
                d.FriendBlockedCollectibles[id] = true
            end
        end

        -- R U A Wizard
        if player:GetRUAWizardTimer() > 0 then
            d.WizardTracker = d.WizardTracker or 45
            mod:QueueFriendMultishotRefresh(player)

        elseif d.WizardTracker then
            d.WizardTracker = nil
            mod:QueueFriendMultishotRefresh(player)
        end

		if player:GetPlayerType() == FiendFolio.PLAYER.FRIEND then
			local _, birthcakeMult = mod:playerHasBirthcake(player)
			if birthcakeMult ~= d.LastFriendBirthcakeMult then
				if d.FriendsRevolver then
					local gun = d.FriendHeldGuns[d.FriendsRevolver.InitSeed]
					gun.Ammo = mod:GetFriendAmmo(gun.Gun or player, true)
				end
			end
			d.LastFriendBirthcakeMult = birthcakeMult
		end

    elseif d.WasFriendFromFiendFolio then
        -- Clicker...
        if d.FriendsRevolver then
            if d.FriendsRevolver:Exists() then
                d.FriendsRevolver:Remove()
            end
            d.FriendsRevolver = nil
        end

        if d.FriendsMultishotGuns then
            for _, gun in pairs(d.FriendsMultishotGuns) do
                if gun.Ref and gun.Ref:Exists() then
                    gun.Ref:Remove()
                end
            end
            d.FriendsMultishotGuns = nil
        end

        if d.FriendBlockedCollectibles then
            for _, id in ipairs(mod.FriendBlockedCollectibles) do
                if d.FriendBlockedCollectibles[id] then
                    player:UnblockCollectible(id)
                end
            end
            d.FriendBlockedCollectibles = nil
        end

		d.LastFriendBirthcakeMult = nil
        d.WasFriendFromFiendFolio = nil
    end

    if d.FriendSoulGuns and #d.FriendSoulGuns > 0 then
        for i = #d.FriendSoulGuns, 1, -1 do
            local ptr = d.FriendSoulGuns[i]
            if not (ptr and ptr.Ref and ptr.Ref:Exists()) then
                d.FriendSoulGuns[i] = nil
            end
        end

        mod:PositionSoulGuns(player)
    end

    if d.FFHeldGuns or d.FriendHeldGuns then
        if player:GetSprite():IsPlaying("TeleportUp") then
            if d.FFHeldGuns then
                for subtype,tab in pairs(d.FFHeldGuns) do
                    for _,gTab in pairs(tab) do
                        gTab.Gun.Visible = false
                        mod:GetEntityData(gTab.Gun).TempHidden = true
                        mod:GetEntityData(gTab.Gun).SetVisiblePlease = true
                    end
                end
            end
            if d.FriendHeldGuns then
                for initseed,gTab in pairs(d.FriendHeldGuns) do
                    gTab.Gun.Visible = false
                    mod:GetEntityData(gTab.Gun).TempHidden = true
                    mod:GetEntityData(gTab.Gun).SetVisiblePlease = true
                end
            end
        end
    end
end

function mod:GetFriendGunAim(gun)
	local player, parent = mod:GetFriendGunPlayer(gun)
	local parentData = mod:GetEntityData(parent)
	local gd = mod:GetEntityData(gun)

	local aim
	local isMouseAim = false

	local pd = mod:GetEntityData(player)

	aim = player:GetAimDirection()
	local mouseAimingEnabled = mod.MouseGunAiming == 1

	if not pd.LastFiredMouse or not mouseAimingEnabled then
		if not mouseAimingEnabled then
			aim = FiendFolio.GetCorrectedFiringInput(player)
		end
	end

	if mouseAimingEnabled and Options.MouseControl and pd.LastFiredMouse and Input.IsMouseBtnPressed(Mouse.MOUSE_BUTTON_1) and not player:HasEntityFlags(EntityFlag.FLAG_FEAR) and player.ControlsCooldown == 0 then
		local pos = mod:GetMousePosition(true)
		local aimFromPos = gd.OwnedByIncubus and player.Position or parent.Position
        local height = gd.ForceTearHeight or mod.FriendGunInfo[gun.SubType].TearHeight or mod.FriendBalancing.DefaultTearHeight
		local mouseAim = (pos-aimFromPos-Vector(0, height)):Normalized()
		if mouseAim:Length() == 0 then
			mouseAim = gd.LastMouseAim or Vector(1,0)
		end
		gd.LastMouseAim = mouseAim
		aim = mouseAim
		isMouseAim = true
	end

	local markedTarget = mod.GetPlayerMarkedTarget(player)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED) and markedTarget then
		aim = (markedTarget.Position - parent.Position):Normalized()
	end

	if parentData.LockGunAim then
		aim = parentData.LockGunAim:Resized(aim:Length())
	end

	if gd.AngleOffset then
		aim = aim:Rotated(gd.AngleOffset)
	end

    local deg = math.abs(aim:GetAngleDegrees())
    if player:GetPlayerType() == mod.PLAYER.BRIEND and deg % 180 > 35 and deg % 180 < 145 then
        local angle = mod.BriendBalancing.AngleInwards * (mod:IsBriendGunInRightHand(player, gd) and -1 or 1)
        if aim:GetAngleDegrees() < 0 and aim:GetAngleDegrees() > -180 then
            angle = -angle
        end
        aim = aim:Rotated(angle)
    end

	return aim, isMouseAim
end

function mod:CanFriendFire(e, player, pd)
    local heldDown = pd.FriendHeldGuns[e.InitSeed].HeldDown
    local framesSinceLastFire = e.FrameCount-pd.FriendHeldGuns[e.InitSeed].LastFrameFired

    local tapCooldown = mod.FriendBalancing.TapFireCooldown
    local holdCooldown = math.min(player.MaxFireDelay, mod.FriendBalancing.HoldFireCooldown)

    if e.SubType == CollectibleType.COLLECTIBLE_SPIRIT_SWORD or e.SubType == CollectibleType.COLLECTIBLE_BERSERK then
        tapCooldown = mod.FriendBalancing.MinMeleeCooldown
        holdCooldown = math.max(holdCooldown, mod.FriendBalancing.MinMeleeCooldown)
    end

    local canFireTap = not heldDown and framesSinceLastFire > tapCooldown
    local canFireHeld = heldDown and framesSinceLastFire > holdCooldown

    return canFireTap or canFireHeld, tapCooldown, holdCooldown
end

mod:AddCallback(ModCallbacks.MC_PRE_EFFECT_UPDATE, function(_, e)
    e:SetPauseTime(0)
end, mod.FF.FriendsRevolver.Var)

local function ShouldDisableGunsForBackupWeapon(player)
	if player:GetPlayerType() == mod.PLAYER.BRIEND and mod:IsBriendTwin(player) then
		player = player:GetOtherTwin()
	end
	local backupWeapon = player and player:GetWeapon(0)
	if backupWeapon then
		local backupWeaponType = backupWeapon:GetWeaponType()
		return backupWeaponType == WeaponType.WEAPON_NOTCHED_AXE or backupWeaponType == WeaponType.WEAPON_URN_OF_SOULS
	end

    local callbackRet = Isaac.RunCallback(mod.CALLBACK.GUN_DISABLE_FOR_BACKUP_WEAPON, player)
    if callbackRet == true then
        return true
    end

	return false
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, e)
    local sprite = e:GetSprite()
    local d = mod:GetEntityData(e)
    local rng = e:GetDropRNG()
    local room = game:GetRoom()
    local gunInfo = mod.FriendGunInfo[e.SubType]

    if not e.SpawnerEntity then
        e:Remove()
        return
    end

    if not d.init then
        d.state = "Appear"
        d.init = true
    end

    d.FriendGunLastUpdate = game:GetFrameCount()

    local player, parent = mod:GetFriendGunPlayer(e)

    if player and player:Exists() and not player:IsDead() and parent and parent:Exists() then
        local pd = mod:GetEntityData(player)

        local gunTable = pd.FriendHeldGuns[e.InitSeed]

        if not gunTable then
            e:Remove()
            return
        end

        Isaac.RunCallbackWithParam("PRE_GUN_UPDATE", e.SubType, e, player, d)
        mod:GunMovement(e, false)

        if d.expiringGun then return end

        local tryingToShoot = mod.GetGoodShootingJoystick(player):Length() > 0 or player:AreOpposingShootDirectionsPressed()
        d.FriendMarkedSoyShoot = tryingToShoot and not d.FriendTryingToShoot
        if d.FriendMarkedSoyShoot then
            pd.FriendMarkedSoyReloading = nil
        end
        d.FriendMarkedSoyLetGo = not tryingToShoot and d.FriendTryingToShoot
        d.FriendTryingToShoot = tryingToShoot

        if not gunTable.Ammo then
            gunTable.Ammo = mod:GetFriendAmmo(e)
        end

        local aim = mod:GetFriendGunAim(e)

        if aim.Y == 1 or (d.PreviousGunDir and d.PreviousGunDir.Y == 1) then
            if sprite.FlipX then
                d.SpecialOffset = Vector(5, 0)
                e.PositionOffset = Vector(5, 0)
            else
                d.SpecialOffset = Vector(-5, 0)
                e.PositionOffset = Vector(-5, 0)
            end
        elseif aim.Y == -1 or (d.PreviousGunDir and d.PreviousGunDir.Y == -1) then
            if sprite.FlipX then
                d.SpecialOffset = Vector(-5, 0)
                e.PositionOffset = Vector(-5, 0)
            else
                d.SpecialOffset = Vector(5, 0)
                e.PositionOffset = Vector(5, 0)
            end
        else
            d.SpecialOffset = Vector.Zero
            e.PositionOffset = Vector.Zero
        end

        e.PositionOffset = e.PositionOffset + (d.ExtraOffset or Vector.Zero)

        local disableGunsForBackupWeapon = ShouldDisableGunsForBackupWeapon(player)
		local isMegaBlasting = player:GetMegaBlastDuration() > 0
		if player:GetPlayerType() == mod.PLAYER.BRIEND then
			local othertwin = player:GetOtherTwin()
			if othertwin then
				isMegaBlasting = isMegaBlasting or othertwin:GetMegaBlastDuration() > 0
			end
		end
        if not disableGunsForBackupWeapon and (parent.Type == EntityType.ENTITY_PLAYER or mod:GetEntityData(parent).FriendLudoPlayer or d.OwnedByIncubus) and player:IsExtraAnimationFinished() then
			if aim:Length() > 0.5 and not (parent.Type == EntityType.ENTITY_PLAYER and isMegaBlasting) then
                mod:UpdatePlayerHeadDirection(player:GetMainTwin(), math.floor(player.MaxFireDelay), false)
                local heldDown = pd.FriendHeldGuns[e.InitSeed].HeldDown
                local framesSinceLastFire = e.FrameCount-pd.FriendHeldGuns[e.InitSeed].LastFrameFired

                local theformula = math.max(player.MaxFireDelay, 1) / mod.FriendBalancing.Tears * 0.1
                theformula = math.max(theformula, 1.0)
                theformula = theformula ^ mod.FriendBalancing.HoldFireSlowdown

                local baseHoldCooldown = gunInfo.HoldCooldown or mod.FriendBalancing.HoldFireCooldown
                local holdCooldown = math.min(player.MaxFireDelay, baseHoldCooldown * theformula)
                local tapCooldown = gunInfo.TapCooldown or mod.FriendBalancing.TapFireCooldown

                if e.SubType == CollectibleType.COLLECTIBLE_SPIRIT_SWORD or e.SubType == CollectibleType.COLLECTIBLE_BERSERK then
                    tapCooldown = mod.FriendBalancing.MinMeleeCooldown
                    holdCooldown = math.max(holdCooldown, mod.FriendBalancing.MinMeleeCooldown)
                end

                local canFireTap = not heldDown and framesSinceLastFire > tapCooldown
                local canFireHeld = heldDown and framesSinceLastFire > holdCooldown

                if canFireTap or canFireHeld then
                    if not Isaac.RunCallbackWithParam("PRE_GUN_FIRE", e.SubType, e, player, aim, heldDown) then
                        mod:FireGunFriend(e, aim, false, player)
                    end
                    pd.FriendHeldGuns[e.InitSeed].HeldDown = true
                end
                d.PreviousFriendAimDir = Vector(aim.X, aim.Y)
				d.MegaBlastDesync = d.MegaBlastDesync or isMegaBlasting

            elseif room:GetFrameCount() > 1 then
                if pd.FriendHeldGuns[e.InitSeed].HeldDown then
                    Isaac.RunCallbackWithParam("GUN_HOLD_RELEASE", e.SubType, e, player, d.PreviousFriendAimDir or aim)
                end
                pd.FriendHeldGuns[e.InitSeed].HeldDown = nil
            end
        end

		local playerToCheckForVisibility = player
		if player:GetPlayerType() == mod.PLAYER.BRIEND and mod:IsBriendTwin(player) then
			playerToCheckForVisibility = player:GetOtherTwin()
		end

        if disableGunsForBackupWeapon or not (playerToCheckForVisibility:IsExtraAnimationFinished() or d.OwnedByIncubus)
        or playerToCheckForVisibility:GetSprite():IsPlaying("TeleportUp")
		or (playerToCheckForVisibility.Visible == false and room:GetFrameCount() > 0) then
            --mod:spritePlay(sprite, "Disappear")
            e.Visible = false
            d.TempHidden = true
            d.SetVisiblePlease = true
        elseif d.SetVisiblePlease then
            d.SetVisiblePlease = nil
            e.Visible = true
        end
        if not gunInfo.CustomAnim then
            if d.state == "Idle" then
                if d.TempHidden and e.Visible then
                    if sprite:IsFinished("Appear") then
                        d.TempHidden = nil
                    elseif room:GetFrameCount() > 0 then
                        mod:spritePlay(sprite, "Appear")
                    else
                        e.Visible = false
                        d.SetVisiblePlease = true
                    end
                else
                    mod:spritePlay(sprite, "Idle")
                end
            elseif d.state == "Shoot" then
                if sprite:IsFinished("Shoot") then
                    d.state = "Idle"
                else
                    mod:spritePlay(sprite, "Shoot")
                end
            elseif d.state == "Appear" then
                if sprite:IsFinished("Appear") then
                    d.state = "Idle"
                elseif room:GetFrameCount() > 0 then
                    mod:spritePlay(sprite, "Appear")
                end
            elseif d.state == "Reload" then
                local hasFearOrParalysis = player:HasEntityFlags(EntityFlag.FLAG_FEAR) or player.ControlsCooldown > 0
                if d.substate == "Begin" then
                    if sprite:IsFinished("BeginReload") then
                        d.substate = "Loading"
                        d.reloadFrame = 0
                        d.reloadedShots = 0
                        --gunTable.Ammo = {}
                        d.reloadOverride = nil
                    else
                        local canStartReload = not hasFearOrParalysis and (not sprite:IsPlaying("Shoot") or d.reloadOverride)

                        local mainGun = pd.FriendsRevolver
                        if mainGun and GetPtrHash(e) ~= GetPtrHash(mainGun) and not d.MegaBlastDesync then
                            -- Try to keep reload animations synced.
                            local mainGunData = mod:GetEntityData(mainGun)
                            if mainGunData.state == "Reload" and not mainGunData.reloadOverride and mainGun:GetSprite():IsPlaying("Shoot") then
                                canStartReload = false
                            end
                        end

                        if canStartReload then
                            if not sprite:IsPlaying("BeginReload") then
                                Isaac.RunCallbackWithParam("PRE_GUN_START_RELOAD", e.SubType, e, player)
                                mod:FriendPlaySound(e.SubType, "ReloadStart", 1)
                                sprite:Play("BeginReload", true)
                            end
                            if not d.startReloadOffset then
                                d.reloadOffset = 1
                                d.startReloadOffset = true
                            end
                        end
                    end
                elseif d.substate == "Loading" then
                    local targetTable = mod:GetFriendAmmo(e)

                    if #targetTable > #gunTable.Ammo then
                        if not hasFearOrParalysis and not Isaac.RunCallbackWithParam("GUN_PRE_RELOAD_SHOT", e.SubType, e, player) then
                            local fireDelay = player.MaxFireDelay
                            local mult = mod.FriendBalancing.ReloadMultiplier

                            if d.OwnedByIncubus and player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) then
                                mult = mult * 0.5
                            end

                            local mainGun = pd.FriendsRevolver
                            if mainGun and GetPtrHash(e) ~= GetPtrHash(mainGun) and not d.MegaBlastDesync then
                                -- Try to keep reload animations synced.
                                local mainGunData = mod:GetEntityData(mainGun)
                                if mainGunData.state == "Reload" and mainGunData.substate == "Begin" then
                                    d.reloadFrame = -1
                                else
                                    d.reloadFrame = mainGunData.reloadFrame
                                    if mainGunData.FriendGunLastUpdate == d.FriendGunLastUpdate then
                                        d.reloadFrame =  d.reloadFrame - 1
                                    end
                                end
                            end

                            local reloadRate = math.max(1, math.floor(fireDelay * mult))
                            d.reloadFrame = d.reloadFrame + 1

                            if d.reloadFrame > 0 and d.reloadFrame % reloadRate == 0 then
                                local dontReload = Isaac.RunCallbackWithParam("GUN_RELOAD_SHOT", e.SubType, e, player)

                                if not dontReload then
                                    local add = 1
                                    if gunInfo.ReloadAllAmmo then
                                        add = #targetTable - #gunTable.Ammo
                                    end

                                    d.reloadedShots = d.reloadedShots + add
                                    for i = 1, add do
                                        mod:ReloadFriendBullet(e, player)
                                    end

                                    sprite:Play("ReloadBullet", true)
                                    mod:FriendPlaySound(e.SubType, "ReloadClick", 1)
                                end
                            end
                        end

                    else
                        d.substate = "End"
                        mod:FriendPlaySound(e.SubType, "ReloadFinish", 1)

                        for i = 60, 360, 60 do
                            local vec = Vector(0,3):Rotated(i)
                            local position = d.RevolverInvisible and player.Position + Vector(0, -15 * player.SpriteScale.Y) + vec:Resized(20) or e.Position + vec:Resized(20)
                            local sparkle = Isaac.Spawn(1000, 1727, 0, position, vec, nil):ToEffect()
                            sparkle.SpriteOffset = Vector(0,-5)
                            sparkle:SetColor(Color(0.6, 0.6, 0.6, 1, 1, 0.4, 0.2), 100, 1, false, false)
                            sparkle:Update()
                        end

                        d.reloadBonusActivated = 1
                        d.reloadedShots = 0
                        Isaac.RunCallbackWithParam("POST_GUN_RELOAD", e.SubType, e, player, true)
                    end

                elseif d.substate == "End" then
                    if sprite:IsFinished("ReloadFinish") then
                        d.state = "Idle"
                        Isaac.RunCallbackWithParam("POST_GUN_FINISHED_RELOAD", e.SubType, e, player, false)
                    else
                        mod:spritePlay(sprite, "ReloadFinish")
                    end
                end
            end
        end

        if d.state ~= "Idle" and d.TempHidden then
            d.TempHidden = nil
        end

        Isaac.RunCallbackWithParam("POST_GUN_UPDATE", e.SubType, e, player)
    else
        d.state = "Disappearing"
    end

    if d.GunLimitedAmmo and d.GunLimitedAmmo <= 0 then
        if d.state ~= "Shoot" then
            d.state = "Disappearing"
        end
    end

    if d.state == "Disappearing" then
        if not d.disappearingStarted then
            d.disappearingStarted = true
            Isaac.RunCallbackWithParam("GUN_START_DISAPPEARING", e.SubType, e, player)
        end

        d.expiringGun = true
        e.Velocity = Vector.Zero
        if sprite:IsFinished("Disappear") then
            if player then
                local pd = mod:GetEntityData(player)
                if pd.FriendsRevolver and pd.FriendsRevolver.InitSeed == e.InitSeed then
                    pd.FriendsRevolver = nil
                end
            end
            e:Remove()
        else
            mod:spritePlay(sprite, "Disappear")
        end
    else
        d.disappearingStarted = nil
    end
end, mod.FF.FriendsRevolver.Var)

local decapAttackScissorsVariants = {
    [FamiliarVariant.SCISSORS] = true,
    [FamiliarVariant.DECAP_ATTACK] = true,
}

function mod:GetActiveScissorDecapHead(player)
    --Goes in reverse to get the topmost head
    local heads = Isaac.FindByType(3, -1, -1, false, false)
    for i = #heads, 1, -1 do
        if decapAttackScissorsVariants[heads[i].Variant] then
            if GetPtrHash(heads[i].SpawnerEntity) == GetPtrHash(player) then
                return heads[i]
            end
        end
    end
end
function mod:GetShootPosThatRespectsDecapAttackAndScissors(player, pos, useThisHead, returnOffset)
    local foundHead = useThisHead or mod:GetActiveScissorDecapHead(player)

    --This is ridiculous right?
    if foundHead then
        if returnOffset then
            return (foundHead.Position - player.Position)
        else
            return pos - (foundHead.Position - player.Position)
        end
    end
    if returnOffset then
        return Vector.Zero
    else
        return pos
    end
end

function mod:GetFriendGunMuzzleOffset(e)
    local guninfo = mod.FriendGunInfo[e.SubType] or {}
    return mod:GetEntityData(e).ForceMuzzleOffset or guninfo.MuzzleOffset or mod.FriendBalancing.DefaultMuzzleOffset
end

-- ignoreHeadAdjustment = ignore the offset added by decap attack and other things like it
function mod:GetFriendGunShootPos(e, aim, offset, forcePos, ignoreHeadAdjustment)
	local player, parent = mod:GetFriendGunPlayer(e)
	local d = mod:GetEntityData(e)
	local pd = mod:GetEntityData(player)
	local parentPos = forcePos or (parent and parent.Position or e.Position)
    local pos = parentPos

    local muzzleOffset = mod:GetFriendGunMuzzleOffset(e)
    offset = (offset or 0) + muzzleOffset.X

    if d.ForceHeldOffset then
        pos = pos + aim:Resized(d.ForceHeldOffset - 20 + offset)
    elseif mod.FriendGunInfo[e.SubType] then
        pos = pos + aim:Resized((mod.FriendGunInfo[e.SubType].HeldOffset or mod.FriendBalancing.DefaultHeldOffset) - 20 + offset)
    else
        pos = pos + aim:Resized(mod.FriendBalancing.DefaultHeldOffset - 20 + offset)
    end

	if d.MultishotOffset then
		pos = pos + d.MultishotOffset:Rotated(aim:GetAngleDegrees())
	end

    if not ignoreHeadAdjustment then
        pos = mod:GetShootPosThatRespectsDecapAttackAndScissors(player, pos)
    end

    local gunInfo = mod.FriendGunInfo[e.SubType] or {}
    if mod:GunShouldUseBriendHandOffset(e, d, player, parent) and not gunInfo.NoBriendHandOffset then
        -- This seems to work better, left the old code below tho
        pos = pos + (pd.BriendFinalHandOffset or Vector.Zero)
        --[[if not mod:IsBriendGunInRightHand(player, d) then
            pos = pos + Vector(mod.BriendBalancing.SecondaryHeldOffset, 0)
        else
            pos = pos + Vector(mod.BriendBalancing.PrimaryHeldOffset, 0)
        end]]
    end

	return pos
end

function mod:GetFriendCritChance(player)
	return mod.FriendBalancing.ImmoralHeartChance[1]+mod.XalumLuckBonus(player.Luck, mod.FriendBalancing.ImmoralHeartChance[3], mod.FriendBalancing.ImmoralHeartChance[2])*100
end

function mod:GetFriendShotDamageBonus(gun, player, shot)
    local d = gun and mod:GetEntityData(gun) or {}

    local flat = 0
    local mult = 1.0

    if d.reloadBonusActivated then
        local level = game:GetLevel():GetAbsoluteStage()
        flat = flat+d.reloadBonusActivated*mod.FriendBalancing.ReloadBonusFlat*level
        mult = mult+d.reloadBonusActivated*mod.FriendBalancing.ReloadBonusMult
    end
    d.reloadBonusActivated = nil

    if shot.OverlayKeys and shot.OverlayKeys["ETERNAL_HEART"] and shot.LastInHeart then
        mult = mult+mod.FriendBalancing.EternalHeartMult
        flat = flat+mod.FriendBalancing.EternalHeartDamage
    end

    if shot.HeartKey == "BLACK_HEART" then
        mult = mult+mod.FriendBalancing.BlackHeartMult
    end

    return flat, mult, shot.Crit
end

function mod:UpdateFriendLaserOffsets(laser, gun, aim)
	local d = mod:GetEntityData(laser)

	laser.AngleDegrees = aim:GetAngleDegrees() + (d.friendLaserAngleOffset or 0)

	--local muzzleOffset = d.isFriendBrimstone and (-laser.Size * 0.25) or -4
	local muzzleOffset = d.isFriendBrimstone and 0 or -20
	local muzzlePos = mod:GetFriendGunShootPos(gun, aim, muzzleOffset, nil, true) + (d.friendLaserPosOffset or mod.nilvector)
	local yOffset = mod:GetFriendGunMuzzleOffset(gun).Y

	local player, parent = mod:GetFriendGunPlayer(gun)

	if laser.DisableFollowParent then
		laser.Position = muzzlePos
		laser.PositionOffset = Vector(0, yOffset)
	else
		laser.PositionOffset = muzzlePos - parent.Position + Vector(0, yOffset)
	end
end

local function isRingLaser(laser)
	return laser.SubType == LaserSubType.LASER_SUBTYPE_RING_LUDOVICO or laser.SubType == LaserSubType.LASER_SUBTYPE_RING_PROJECTILE
end

mod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, function(_, laser)
	local d = mod:GetEntityData(laser)

	if TearFlagsLib.HasTearFlags(laser, mod.FriendBulletFlags.FRIEND) then
		local gun = TearFlagsLib.GetTearFlagParams(laser, mod.FriendBulletFlags.FRIEND).Gun
		if d.isFriendBrimstone then
			if not gun or not gun.Parent then
				laser:Remove()
				return
			end
		end

		local player = mod:GetFriendGunPlayer(gun)

		if d.friendLaserUpdateOffsets and gun and player then
			local gd = mod:GetEntityData(gun)
			local pd = mod:GetEntityData(player)

			local aiming = pd.FriendHeldGuns[gun.InitSeed] and pd.FriendHeldGuns[gun.InitSeed].HeldDown and player:GetAimDirection():Length() > 0 and gd.state ~= "Reload"

			if laser.Parent and laser.Parent.Type == EntityType.ENTITY_EFFECT and laser.Parent.Variant == EffectVariant.BRIMSTONE_SWIRL then
				if aiming then
					local aim, isMouseAim = mod:GetFriendGunAim(gun)
					if isMouseAim then
						laser.AngleDegrees = (mod:GetMousePosition(true) - laser.Position):GetAngleDegrees()
					else
						laser.AngleDegrees = aim:GetAngleDegrees()
					end
				end
			else
				local aim = aiming and mod:GetFriendGunAim(gun) or Vector.FromAngle(gd.CurrentAngle or 0)
				mod:UpdateFriendLaserOffsets(laser, gun, aim)
			end
		end
	end

	if player and TearFlagsLib.HasTearFlags(laser, mod.FriendBulletFlags.BONE) and game:GetFrameCount() > (d.FriendLaserLastUpdatedShotEffects or game:GetFrameCount()) and not isRingLaser(laser) then
		local endPoint = laser:GetEndPoint()
		local dir = laser.Position - endPoint
		mod:FireFriendBoneHeartBones(laser, player, endPoint, dir) -- TODO: REMOVE GLOBAL PLAYER
		TearFlagsLib.SetTearFlagParams(laser, mod.FriendBulletFlags.BONE, {NoRemove = false})
		TearFlagsLib.ClearTearFlags(laser, mod.FriendBulletFlags.BONE)
	end

	mod:UpdateFriendEternalHeartHalo(laser)

    if TearFlagsLib.HasTearFlags(laser, mod.FriendBulletFlags.BLACK) then
        laser.Velocity = mod:Lerp(laser.Velocity, mod.nilvector, 0.075)
    end
end)


-- This block detects damage from lasers, since the laser is not normally accessible within MC_ENTITY_TAKE_DMG.
-- Makes the CRIT! effect pop up for lasers + immoral hearts, and helps apply some status effects.
-- Not ideal, could maybe be replaced later with some new REPENTOGON thing.
local TRY_DETECT_FRIEND_LASER_HIT = false
local DETECTED_FRIEND_LASER_HIT = nil

mod:AddCallback(ModCallbacks.MC_PRE_LASER_COLLISION, function(_, laser, collider)
	TRY_DETECT_FRIEND_LASER_HIT = TearFlagsLib.HasTearFlags(laser, mod.FriendBulletFlags.BONE)
end)

mod:AddPostNpcTakeDmgFromSourceCallback(function(_, npc, data, damage, flags, sourceEntity, sourceData)
	if TRY_DETECT_FRIEND_LASER_HIT and not DETECTED_FRIEND_LASER_HIT and flags & DamageFlag.DAMAGE_LASER ~= 0 then
		DETECTED_FRIEND_LASER_HIT = sourceEntity
	end
end, EntityType.ENTITY_PLAYER)

mod:AddCallback(ModCallbacks.MC_POST_LASER_COLLISION, function(_, laser, collider)
	local d = mod:GetEntityData(laser)
	local cd = mod:GetEntityData(collider)

	if DETECTED_FRIEND_LASER_HIT then
		if TearFlagsLib.HasTearFlags(laser, mod.FriendBulletFlags.BONE) then
			TearFlagsLib.SetTearFlagParams(laser, mod.FriendBulletFlags.BONE, {NoRemove = false})
			TearFlagsLib.ClearTearFlags(laser, mod.FriendBulletFlags.BONE)
		end
	end
	TRY_DETECT_FRIEND_LASER_HIT = false
	DETECTED_FRIEND_LASER_HIT = nil
end)

function mod:GetTechXRadius(laser)
	-- you'd think this would be as simple as just checking laser.Radius
	-- nope

	local radius = laser.Radius
	if laser.Parent and laser.Parent.Type == EntityType.ENTITY_FAMILIAR then
		radius = radius * 0.75
	end

	if laser:HasTearFlags(TearFlags.TEAR_PULSE) then
		radius = math.sin(laser.FrameCount * 0.1) * 20 + radius
	end

	local player = laser.SpawnerEntity
	if player and player.Type == EntityType.ENTITY_PLAYER then
		local dist = math.min(laser.Position:Distance(player.Position), 500)
		if laser:HasTearFlags(TearFlags.TEAR_GROW) then
			radius = dist * 0.1 + radius
		end

		if laser:HasTearFlags(TearFlags.TEAR_SHRINK) then
			radius = radius + (1 - dist / 500) * 50
		end
	end

	return radius
end

function mod:ResetFriendShotEffects(ent, ignoreCrit)
	TearFlagsLib.SetTearFlagParams(ent, mod.FriendBulletFlags.GOLD, {NoRemove = false})
	TearFlagsLib.ClearTearFlags(ent, mod.FriendBulletFlags.GOLD)
	TearFlagsLib.SetTearFlagParams(ent, mod.FriendBulletFlags.ETERNAL, {NoRemove = false})
	TearFlagsLib.ClearTearFlags(ent, mod.FriendBulletFlags.ETERNAL)
	TearFlagsLib.SetTearFlagParams(ent, mod.FriendBulletFlags.IMMORAL, {NoRemove = false})
	TearFlagsLib.ClearTearFlags(ent, mod.FriendBulletFlags.IMMORAL)
	TearFlagsLib.SetTearFlagParams(ent, mod.FriendBulletFlags.BLACK, {NoRemove = false})
	TearFlagsLib.ClearTearFlags(ent, mod.FriendBulletFlags.BLACK)
	TearFlagsLib.SetTearFlagParams(ent, mod.FriendBulletFlags.SOUL, {NoRemove = false})
	TearFlagsLib.ClearTearFlags(ent, mod.FriendBulletFlags.SOUL)
	TearFlagsLib.SetTearFlagParams(ent, mod.FriendBulletFlags.ROTTEN, {NoRemove = false})
	TearFlagsLib.ClearTearFlags(ent, mod.FriendBulletFlags.ROTTEN)
	TearFlagsLib.SetTearFlagParams(ent, mod.FriendBulletFlags.BONE, {NoRemove = false})
	TearFlagsLib.ClearTearFlags(ent, mod.FriendBulletFlags.BONE)
	TearFlagsLib.SetTearFlagParams(ent, mod.FriendBulletFlags.MORBID, {NoRemove = false})
	TearFlagsLib.ClearTearFlags(ent, mod.FriendBulletFlags.MORBID)
	TearFlagsLib.SetTearFlagParams(ent, mod.FriendBulletFlags.LEAKY, {NoRemove = false})
	TearFlagsLib.ClearTearFlags(ent, mod.FriendBulletFlags.LEAKY)
	TearFlagsLib.SetTearFlagParams(ent, mod.FriendBulletFlags.STEVEN, {NoRemove = false})
	TearFlagsLib.ClearTearFlags(ent, mod.FriendBulletFlags.STEVEN)
	if not ignoreCrit then
		TearFlagsLib.SetTearFlagParams(ent, mod.CritFlag, {NoRemove = false})
		TearFlagsLib.ClearTearFlags(ent, mod.CritFlag)
	end
end

function mod:GetFriendShotLaserColor(ent, player)
	local baseRC, baseGC, baseBC = 0, 0, 0
	local baseDivisor = 0

	if TearFlagsLib.HasTearFlags(ent, mod.FriendBulletFlags.ETERNAL) then
		baseRC = baseRC + 4.72
		baseGC = baseGC + 4.6
		baseBC = baseBC + 4.52
		baseDivisor = baseDivisor + 1
	end
    if TearFlagsLib.HasTearFlags(ent, mod.FriendBulletFlags.BONE) then
		baseRC = baseRC + 4.76
		baseGC = baseGC + 4.72
		baseBC = baseBC + 4.19
		baseDivisor = baseDivisor + 1
    end
	if TearFlagsLib.HasTearFlags(ent, mod.FriendBulletFlags.LEAKY) then
		baseRC = baseRC + 5.19
		baseGC = baseGC + 0.88
		baseBC = baseBC + 1.30
		baseDivisor = baseDivisor + 1
    end
    if TearFlagsLib.HasTearFlags(ent, mod.FriendBulletFlags.MORBID) then
        baseRC = baseRC + 1.47
		baseGC = baseGC + 1.49
		baseBC = baseBC + 1.34
		baseDivisor = baseDivisor + 1
    end
    if TearFlagsLib.HasTearFlags(ent, mod.FriendBulletFlags.ROTTEN) then
		baseRC = baseRC + 3.93
		baseGC = baseGC + 3.66
		baseBC = baseBC + 1.91
		baseDivisor = baseDivisor + 1
    end
	if TearFlagsLib.HasTearFlags(ent, mod.FriendBulletFlags.BLACK) then
		baseRC = baseRC + 2.12
		baseGC = baseGC + 1.77
		baseBC = baseBC + 1.73
		baseDivisor = baseDivisor + 1
	end
	if TearFlagsLib.HasTearFlags(ent, mod.FriendBulletFlags.SOUL) then
		baseRC = baseRC + 2.81
		baseGC = baseGC + 3.03
		baseBC = baseBC + 3.52
		baseDivisor = baseDivisor + 1
	end
	if TearFlagsLib.HasTearFlags(ent, mod.FriendBulletFlags.IMMORAL) then
		baseRC = baseRC + 4.15
		baseGC = baseGC + 2.44
		baseBC = baseBC + 3.91
		baseDivisor = baseDivisor + 1
	end

	local sprite = ent:GetSprite()
	if TearFlagsLib.HasTearFlags(ent, mod.FriendBulletFlags.STEVEN) then
		baseRC = baseRC + 1
		baseGC = baseGC + 1
		baseBC = baseBC + 1
		baseDivisor = baseDivisor + 1
	end

    if TearFlagsLib.HasTearFlags(ent, mod.CritFlag) then
		local isTrickyCherry = TearFlagsLib.GetTearFlagParams(ent, mod.CritFlag).IsTrickyCherry
		return (isTrickyCherry and Color(1,1,1,1,0,0,0,6,0.9,0.9,1)) or Color(1,1,1,1,0,0,0,5.7,0.9,3.4,1), true
    end

	if baseDivisor > 0 then
		return Color(1, 1, 1, 1, 0, 0, 0, baseRC / baseDivisor, baseGC / baseDivisor, baseBC / baseDivisor, 1), true
	else
		return player.LaserColor, false
	end
end

function mod:ApplyFriendLaserShotEffects(laser, player, shot, crit, reset, isTemporary)
    local d = mod:GetEntityData(laser)
    d.FriendLaserLastUpdatedShotEffects = game:GetFrameCount()

    if reset then
		if TearFlagsLib.HasTearFlags(laser, mod.FriendBulletFlags.BONE) then
			mod:FireFriendBoneHeartBones(laser, player, laser.Position, -laser.Velocity)
		end

        laser.Color = player.LaserColor
		mod:ResetFriendShotEffects(laser)
        laser:SetMaxDistance(0)
    end

    if Isaac.RunCallback("PRE_GUN_APPLY_SHOT_EFFECT", laser, player, shot, crit) then
        return
    end

    if shot.HeartKey == "IMMORAL_HEART" or shot.ForceImmoral then
        TearFlagsLib.AddTearFlags(laser, mod.FriendBulletFlags.IMMORAL)
		TearFlagsLib.SetTearFlagParams(laser, mod.FriendBulletFlags.IMMORAL, {Player = player, NoRemove = not isTemporary})
		mod:GetEntityData(laser).FriendImmoralHitlist = nil
    end

    if shot.HeartKey == "BLACK_HEART" then
        TearFlagsLib.AddTearFlags(laser, mod.FriendBulletFlags.BLACK)
		TearFlagsLib.SetTearFlagParams(laser, mod.FriendBulletFlags.BLACK, {NoRemove = not isTemporary})
        laser:SetMaxDistance(200)

        if laser.SubType == LaserSubType.LASER_SUBTYPE_RING_PROJECTILE and not isTemporary then
            laser.Timeout = 60
        end
    end

    if shot.HeartKey == "SOUL_HEART" then
        TearFlagsLib.AddTearFlags(laser, mod.FriendBulletFlags.SOUL)
		TearFlagsLib.SetTearFlagParams(laser, mod.FriendBulletFlags.SOUL, {Player = player, NoRemove = not isTemporary})
    end

    if shot.HeartKey == "ROTTEN_HEART" then
		TearFlagsLib.AddTearFlags(laser, mod.FriendBulletFlags.ROTTEN)
		TearFlagsLib.SetTearFlagParams(laser, mod.FriendBulletFlags.ROTTEN, {Player = player, NoRemove = not isTemporary})
    end

    if shot.HeartKey == "BONE_HEART" or shot.ContainerKey == "BONE_HEART" then
		TearFlagsLib.AddTearFlags(laser, mod.FriendBulletFlags.BONE)
		TearFlagsLib.SetTearFlagParams(laser, mod.FriendBulletFlags.BONE, {Player = player, NoRemove = not isTemporary})
    elseif shot.HeartKey == "LEAKY_HEART" or shot.ContainerKey == "LEAKY_HEART" then
        TearFlagsLib.AddTearFlags(laser, mod.FriendBulletFlags.LEAKY)
		TearFlagsLib.SetTearFlagParams(laser, mod.FriendBulletFlags.LEAKY, {Player = player, NoRemove = not isTemporary})
    end

    if (shot.OverlayKeys and shot.OverlayKeys["GOLDEN_HEART"] and shot.LastInHeart) or shot.ForceGold then
		TearFlagsLib.AddTearFlags(laser, mod.FriendBulletFlags.GOLD)
		TearFlagsLib.SetTearFlagParams(laser, mod.FriendBulletFlags.GOLD, {NoRemove = not isTemporary})
    end

	if shot.OverlayKeys and shot.OverlayKeys["ETERNAL_HEART"] and shot.LastInHeart then
        if not isRingLaser(laser) then
            laser:AddTearFlags(TearFlags.TEAR_HOMING)
            laser:SetHomingType(1125515264) -- ?????????
            laser:RecalculateSamplesNextUpdate()
		elseif not TearFlagsLib.HasTearFlags(laser, mod.FriendBulletFlags.ETERNAL) then
            if not isLudo then
				laser.Velocity = laser.Velocity * 0.25
			end

			if not d.EternalHalo then
				local halo = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HALLOWED_GROUND, 0, laser.Position, Vector.Zero, laser):ToEffect()
				halo:FollowParent(laser)
				halo.DepthOffset = -100
				halo.SpriteScale = Vector.One * mod:GetTechXRadius(laser) / 80
				d.EternalHalo = halo
			end
        end

		TearFlagsLib.AddTearFlags(laser, mod.FriendBulletFlags.ETERNAL)
		TearFlagsLib.SetTearFlagParams(laser, mod.FriendBulletFlags.ETERNAL, {NoRemove = not isTemporary})
	end

	if shot.OverlayKeys and shot.OverlayKeys["STEVEN_HEART"] then
		laser:AddTearFlags(TearFlags.TEAR_HOMING)
		if not isRingLaser(laser) then
            laser:SetHomingType(1125515264) -- ?????????
            laser:RecalculateSamplesNextUpdate()
		end

		TearFlagsLib.AddTearFlags(laser, mod.FriendBulletFlags.STEVEN)
		TearFlagsLib.SetTearFlagParams(laser, mod.FriendBulletFlags.STEVEN, {NoRemove = not isTemporary})
	end

    if crit then
		TearFlagsLib.AddTearFlags(laser, mod.CritFlag)
		TearFlagsLib.SetTearFlagParams(laser, mod.CritFlag, {NoRemove = not isTemporary})
		mod:GetEntityData(laser).FFCritHitlist = nil
    end

    if shot.HeartKey == "MORBID_HEART" then
		TearFlagsLib.AddTearFlags(laser, mod.FriendBulletFlags.MORBID)
		TearFlagsLib.SetTearFlagParams(laser, mod.FriendBulletFlags.MORBID, {Player = player, NoRemove = not isTemporary})
    end

	laser.Color = mod:GetFriendShotLaserColor(laser, player)
end

function mod:FireFriendTechX(e, player, aim, posOffset, vel, shot, held, charge)
	if mod:IsFriendSoulGun(e, mod:GetEntityData(e)) then
		local ptype = player:GetPlayerType()
		if ptype ~= mod.PLAYER.FRIEND and ptype ~= mod.PLAYER.BRIEND then
			vel = vel * (1 + mod.FriendBalancing.Shotspeed)
		end
	end

    local flat, mult, crit = mod:GetFriendShotDamageBonus(e, player, shot)
    local newDamage = (player.Damage + flat)*mult
    local damMult = newDamage/player.Damage
    local pos = mod:GetFriendGunShootPos(e, aim) + posOffset
    charge = charge or 50
    local radius = math.floor(10+charge*0.5)
    local laser = player:FireTechXLaser(pos, vel, radius, player, math.sqrt(damMult))
    laser:SetScale(laser:GetScale() * 0.75)
    laser:SetDamageMultiplier(damMult)

    laser.Parent = e
	TearFlagsLib.AddTearFlags(laser, mod.FriendBulletFlags.FRIEND)
	TearFlagsLib.SetTearFlagParams(laser, mod.FriendBulletFlags.FRIEND, {NoRemove = true, Shot = shot, Gun = e, IsTechX = true})

    mod:ApplyFriendLaserShotEffects(laser, player, shot, crit)

    Isaac.RunCallbackWithParam("POST_GUN_FIRE_LASER", e.SubType, e, player, laser, held)

    return laser
end

function mod:HandleFriendLasers(player, e, laser, shot, aim, held)
    local isSoulGun = mod:IsFriendSoulGun(e, mod:GetEntityData(e))
    local isBrimstone = false
    if isSoulGun and mod.FriendGunInfo[e.SubType] and mod.FriendGunInfo[e.SubType].WeaponType == WeaponType.WEAPON_BRIMSTONE then
        isBrimstone = true
    elseif player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) or player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_BRIMSTONE) then
        isBrimstone = true
    end

    local flat, mult, crit = mod:GetFriendShotDamageBonus(e, player, shot)
    local newDamage = (player.Damage + flat)*mult
    local damMult = newDamage/player.Damage

	local ld = mod:GetEntityData(laser)
	ld.OrigDamageMult = ld.OrigDamageMult or laser:GetDamageMultiplier()
    laser:SetDamageMultiplier(damMult * ld.OrigDamageMult)

	TearFlagsLib.AddTearFlags(laser, mod.FriendBulletFlags.FRIEND)
	TearFlagsLib.SetTearFlagParams(laser, mod.FriendBulletFlags.FRIEND, {NoRemove = true, Shot = shot, Gun = e})

    mod:ApplyFriendLaserShotEffects(laser, player, shot, crit)
end

function mod:FireFriendLaser(e, player, aim, posOffset, vel, shot, held)
    local isSoulGun = mod:IsFriendSoulGun(e, mod:GetEntityData(e))
    local isBrimstone = false
    if isSoulGun and mod.FriendGunInfo[e.SubType] and mod.FriendGunInfo[e.SubType].WeaponType == WeaponType.WEAPON_BRIMSTONE then
        isBrimstone = true
    elseif player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) or player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_BRIMSTONE) then
        isBrimstone = true
    end

    local laser
    if isBrimstone then
        laser = player:FireBrimstone(vel, player, 1.0)
    else
        laser = player:FireTechLaser(e.Position, LaserOffset.LASER_BRIMSTONE_OFFSET, vel, false, true, player, 1)
    end

    local d = mod:GetEntityData(laser)
    d.isFriendBrimstone = isBrimstone
    d.friendLaserPosOffset = posOffset
    d.friendLaserAngleOffset = vel:GetAngleDegrees() - aim:GetAngleDegrees()
    d.friendLaserUpdateOffsets = isBrimstone
    laser.DisableFollowParent = isBrimstone
    laser.Parent = e.Parent

	mod:HandleFriendLasers(player, e, laser, shot, aim, held)
    mod:UpdateFriendLaserOffsets(laser, e, aim)

    Isaac.RunCallbackWithParam("POST_GUN_FIRE_LASER", e.SubType, e, player, laser, held)

    return laser
end

function mod:PreventRemovingFriendBulletFlags(entity, player, flag)
	if TearFlagsLib.GetTearFlagParams(entity, flag).NoRemove then
		return true
	end
end
mod:AddCallback(TearFlagsLib.Callback.PRE_REMOVE_TEARFLAG, mod.PreventRemovingFriendBulletFlags, mod.FriendBulletFlags.FRIEND)
mod:AddCallback(TearFlagsLib.Callback.PRE_REMOVE_TEARFLAG, mod.PreventRemovingFriendBulletFlags, mod.FriendBulletFlags.GOLD)
mod:AddCallback(TearFlagsLib.Callback.PRE_REMOVE_TEARFLAG, mod.PreventRemovingFriendBulletFlags, mod.FriendBulletFlags.ETERNAL)
mod:AddCallback(TearFlagsLib.Callback.PRE_REMOVE_TEARFLAG, mod.PreventRemovingFriendBulletFlags, mod.FriendBulletFlags.BONE)
mod:AddCallback(TearFlagsLib.Callback.PRE_REMOVE_TEARFLAG, mod.PreventRemovingFriendBulletFlags, mod.FriendBulletFlags.MORBID)
mod:AddCallback(TearFlagsLib.Callback.PRE_REMOVE_TEARFLAG, mod.PreventRemovingFriendBulletFlags, mod.FriendBulletFlags.ROTTEN)
mod:AddCallback(TearFlagsLib.Callback.PRE_REMOVE_TEARFLAG, mod.PreventRemovingFriendBulletFlags, mod.FriendBulletFlags.BLACK)
mod:AddCallback(TearFlagsLib.Callback.PRE_REMOVE_TEARFLAG, mod.PreventRemovingFriendBulletFlags, mod.FriendBulletFlags.SOUL)
mod:AddCallback(TearFlagsLib.Callback.PRE_REMOVE_TEARFLAG, mod.PreventRemovingFriendBulletFlags, mod.FriendBulletFlags.IMMORAL)
mod:AddCallback(TearFlagsLib.Callback.PRE_REMOVE_TEARFLAG, mod.PreventRemovingFriendBulletFlags, mod.FriendBulletFlags.LEAKY)
mod:AddCallback(TearFlagsLib.Callback.PRE_REMOVE_TEARFLAG, mod.PreventRemovingFriendBulletFlags, mod.FriendBulletFlags.STEVEN)

local LUM_R, LUM_G, LUM_B = 0.212671, 0.715160, 0.072169 -- luminance factors used for colorize operation
function mod:GetFriendShotTearColor(ent, color)
    local baseRO, baseGO, baseBO = 0, 0, 0
	local baseRC, baseGC, baseBC = 0, 0, 0
	local baseDivisor = 0
	local tearcolor = color

	if TearFlagsLib.HasTearFlags(ent, mod.FriendBulletFlags.ETERNAL) then
		baseRO, baseGO, baseBO = baseRO + 0.1708, baseGO + 0.0756, baseBO + 0.0843
		baseRC, baseGC, baseBC = baseRC + 0.8256, baseGC + 0.9127, baseBC + 0.8768
		baseDivisor = baseDivisor + 1
	end
    if TearFlagsLib.HasTearFlags(ent, mod.FriendBulletFlags.BONE) then
		baseRO, baseGO, baseBO = baseRO + 0.1233, baseGO + 0.1154, baseBO + 0.1090
		baseRC, baseGC, baseBC = baseRC + 0.8464, baseGC + 0.8464, baseBC + 0.7443
		baseDivisor = baseDivisor + 1
    end
	if TearFlagsLib.HasTearFlags(ent, mod.FriendBulletFlags.LEAKY) then
		baseRO, baseGO, baseBO = baseRO + 0.1958, baseGO - 0.1449, baseBO - 0.0391
		baseRC, baseGC, baseBC = baseRC + 0.8827, baseGC + 0.5847, baseBC + 0.4926
		baseDivisor = baseDivisor + 1
    end
    if TearFlagsLib.HasTearFlags(ent, mod.FriendBulletFlags.MORBID) then
        baseRO, baseGO, baseBO = baseRO + 0.0326, baseGO + 0.0253, baseBO + 0.0046
		baseRC, baseGC, baseBC = baseRC + 0.2486, baseGC + 0.2775, baseBC + 0.2758
		baseDivisor = baseDivisor + 1
    end
    if TearFlagsLib.HasTearFlags(ent, mod.FriendBulletFlags.ROTTEN) then
		baseRO, baseGO, baseBO = baseRO + 0.0520, baseGO - 0.0329, baseBO - 0.0178
		baseRC, baseGC, baseBC = baseRC + 0.6520, baseGC + 0.6947, baseBC + 0.3309
		baseDivisor = baseDivisor + 1
    end
	if TearFlagsLib.HasTearFlags(ent, mod.FriendBulletFlags.BLACK) then
		baseRO, baseGO, baseBO = baseRO + 0.0201, baseGO - 0.0535, baseBO - 0.0119
		baseRC, baseGC, baseBC = baseRC + 0.3794, baseGC + 0.4556, baseBC + 0.3752
		baseDivisor = baseDivisor + 1
	end
	if TearFlagsLib.HasTearFlags(ent, mod.FriendBulletFlags.SOUL) then
		baseRO, baseGO, baseBO = baseRO + 0.1287, baseGO + 0.1048, baseBO + 0.1912
		baseRC, baseGC, baseBC = baseRC + 0.5175, baseGC + 0.5944, baseBC + 0.5308
		baseDivisor = baseDivisor + 1
	end
	if TearFlagsLib.HasTearFlags(ent, mod.FriendBulletFlags.IMMORAL) then
		baseRO, baseGO, baseBO = baseRO + 0.0166, baseGO - 0.0542, baseBO + 0.0136
		baseRC, baseGC, baseBC = baseRC + 0.7826, baseGC + 0.6000, baseBC + 0.7756
		baseDivisor = baseDivisor + 1
	end

	local sprite = ent:GetSprite()
	if TearFlagsLib.HasTearFlags(ent, mod.FriendBulletFlags.STEVEN) then
		baseRO, baseGO, baseBO = baseRO + 0, baseGO - 0, baseBO + 0
		baseRC, baseGC, baseBC = baseRC + 1, baseGC + 1, baseBC + 1
		baseDivisor = baseDivisor + 1
		sprite:SetCustomShader("shaders/fiendfolio/coloroffset_parallel")
	elseif sprite:HasCustomShader("shaders/fiendfolio/coloroffset_parallel") then
		sprite:ClearCustomShader()
	end

    if TearFlagsLib.HasTearFlags(ent, mod.CritFlag) then
		baseDivisor = 0
		local isTrickyCherry = TearFlagsLib.GetTearFlagParams(ent, mod.CritFlag).IsTrickyCherry
		tearcolor = (isTrickyCherry and Color(1.3,1.3,1.3,1,150/255,-150/255,-150/255)) or Color(1.3,1.3,1.3,1,100/255,-150/255,100/255)
    end

	if baseDivisor > 0 then
		baseRO, baseGO, baseBO = baseRO / baseDivisor, baseGO / baseDivisor, baseBO / baseDivisor
		baseRC, baseGC, baseBC = baseRC / baseDivisor, baseGC / baseDivisor, baseBC / baseDivisor

		tearcolor = tearcolor or Color()
		local tearcolorize = tearcolor:GetColorize()
		local tearRT, tearGT, tearBT  = tearcolor.R, tearcolor.G, tearcolor.B
		local tearRO, tearGO, tearBO = tearcolor.RO, tearcolor.GO, tearcolor.BO
		local tearRC, tearGC, tearBC, tearAC = tearcolorize.R, tearcolorize.G, tearcolorize.B, tearcolorize.A

		-- colour setup so basecolor is applied to the sprite first, then the tearcolor to that result
		-- note these factors are specific to base colour with tints 1,1,1, and colorize alpha 1
		return Color(1, 1, 1, tearcolor.A,
		             baseRO * tearRT * (1 - tearAC) + baseRO * tearRT * LUM_R * tearRC * tearAC + baseGO * tearGT * LUM_G * tearRC * tearAC + baseBO * tearBT * LUM_B * tearRC * tearAC + tearRO,
		             baseGO * tearGT * (1 - tearAC) + baseRO * tearRT * LUM_R * tearGC * tearAC + baseGO * tearGT * LUM_G * tearGC * tearAC + baseBO * tearBT * LUM_B * tearGC * tearAC + tearGO,
		             baseBO * tearBT * (1 - tearAC) + baseRO * tearRT * LUM_R * tearGC * tearAC + baseGO * tearGT * LUM_G * tearBC * tearAC + baseBO * tearBT * LUM_B * tearBC * tearAC + tearBO,
		             baseRC * tearRT * (1 - tearAC) + (baseRC * tearRT * LUM_R + baseGC * tearGT * LUM_G + baseBC * tearBT * LUM_B) * tearRC * tearAC,
		             baseGC * tearGT * (1 - tearAC) + (baseRC * tearRT * LUM_R + baseGC * tearGT * LUM_G + baseBC * tearBT * LUM_B) * tearGC * tearAC,
		             baseBC * tearBT * (1 - tearAC) + (baseRC * tearRT * LUM_R + baseGC * tearGT * LUM_G + baseBC * tearBT * LUM_B) * tearBC * tearAC,
		             1)
	else
		return tearcolor
	end
end

function mod:ApplyFriendBombShotEffects(bomb, player, shot, crit)
	local rng = bomb:GetDropRNG()
	local bd = mod:GetEntityData(bomb)

    if Isaac.RunCallback("PRE_GUN_APPLY_SHOT_EFFECT", bomb, player, shot, crit) then
        return
    end

    if shot.HeartKey == "SOUL_HEART" then
		TearFlagsLib.AddTearFlags(bomb, mod.FriendBulletFlags.SOUL)
		TearFlagsLib.SetTearFlagParams(bomb, mod.FriendBulletFlags.SOUL, {Player = player})
	elseif shot.HeartKey == "ROTTEN_HEART" then
		TearFlagsLib.AddTearFlags(bomb, mod.FriendBulletFlags.ROTTEN)
		TearFlagsLib.SetTearFlagParams(bomb, mod.FriendBulletFlags.ROTTEN, {Player = player})
	elseif shot.HeartKey == "MORBID_HEART" then
		TearFlagsLib.AddTearFlags(bomb, mod.FriendBulletFlags.MORBID)
		TearFlagsLib.SetTearFlagParams(bomb, mod.FriendBulletFlags.MORBID, {Player = player})
	elseif shot.HeartKey == "BLACK_HEART" then
		TearFlagsLib.AddTearFlags(bomb, mod.FriendBulletFlags.BLACK)
		bomb.Velocity = bomb.Velocity:Resized(12):Rotated(mod:RandomFloat(-6, 6))
		if TearFlagsLib.HasTearFlags(bomb, mod.FriendBulletFlags.GRENADE) then
			TearFlagsLib.SetTearFlagParams(bomb, mod.FriendBulletFlags.GRENADE, {
				FlatStone = false,
				FallingSpeed = -5.6,
				FallingAcceleration = 0.33,
			})
		end
	elseif shot.HeartKey == "IMMORAL_HEART" or shot.ForceImmoral then
		TearFlagsLib.AddTearFlags(bomb, mod.FriendBulletFlags.IMMORAL)
		TearFlagsLib.SetTearFlagParams(bomb, mod.FriendBulletFlags.IMMORAL, {Player = player})
		mod:GetEntityData(bomb).FriendImmoralHitlist = nil
	end

	if shot.HeartKey == "BONE_HEART" or shot.ContainerKey == "BONE_HEART" then
		TearFlagsLib.AddTearFlags(bomb, mod.FriendBulletFlags.BONE)
		TearFlagsLib.SetTearFlagParams(bomb, mod.FriendBulletFlags.BONE, {Player = player})
    elseif shot.HeartKey == "LEAKY_HEART" or shot.ContainerKey == "LEAKY_HEART" then
        TearFlagsLib.AddTearFlags(bomb, mod.FriendBulletFlags.LEAKY)
		TearFlagsLib.SetTearFlagParams(bomb, mod.FriendBulletFlags.LEAKY, {Player = player})
    end

	if (shot.OverlayKeys and shot.OverlayKeys["GOLDEN_HEART"] and shot.LastInHeart) or shot.ForceGold then
		TearFlagsLib.AddTearFlags(bomb, mod.FriendBulletFlags.GOLD)
		bomb:AddTearFlags(TearFlags.TEAR_GOLDEN_BOMB)
	end
	if shot.OverlayKeys and shot.OverlayKeys["ETERNAL_HEART"] and shot.LastInHeart then
        TearFlagsLib.AddTearFlags(bomb, mod.FriendBulletFlags.ETERNAL)
		bomb.Velocity = bomb.Velocity * 0.5
		bomb:SetExplosionCountdown(bomb:GetExplosionCountdown() * 5)

		if not bd.EternalHalo then
			local halo = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HALLOWED_GROUND, 0, bomb.Position, Vector.Zero, bomb):ToEffect()
			halo:FollowParent(bomb)
			halo.DepthOffset = -100
			halo.SpriteScale = halo.SpriteScale * bomb:GetScale()
			bd.EternalHalo = halo
		end
	end
	if shot.OverlayKeys and shot.OverlayKeys["STEVEN_HEART"] then
        TearFlagsLib.AddTearFlags(bomb, mod.FriendBulletFlags.STEVEN)
		bomb:AddTearFlags(TearFlags.TEAR_HOMING)
	end

	if crit then
		TearFlagsLib.AddTearFlags(bomb, mod.CritFlag)
		mod:GetEntityData(bomb).FFCritHitlist = nil
		if not bd.critLightning or not bd.critLightning:Exists() then
			sfx:Play(mod.Sounds.CritShoot, 0.3, 0, false, math.random(80,120)/100)
			local critLightning = Isaac.Spawn(1000, 1737, 1, bomb.Position, Vector.Zero, bomb):ToEffect()
			critLightning.Parent = bomb
			critLightning.Color = Color(1,1,1,0,0,0,1)
			critLightning:Update()
			bd.critLightning = critLightning
		end
	end
end

function mod:HandleFriendBombs(player, e, bomb, shot, aim, held)
    local isSoulGun = mod:IsFriendSoulGun(e, mod:GetEntityData(e))
    local hasEpicFetus = false
    if isSoulGun and mod.FriendGunInfo[e.SubType] and mod.FriendGunInfo[e.SubType].WeaponType == WeaponType.WEAPON_ROCKETS then
        hasEpicFetus = true
    elseif player:HasCollectible(CollectibleType.COLLECTIBLE_EPIC_FETUS) then
        hasEpicFetus = true
    end

	local isRocket = hasEpicFetus or player:HasCollectible(CollectibleType.COLLECTIBLE_ROCKET_IN_A_JAR)

	local bd = mod:GetEntityData(bomb)

	TearFlagsLib.AddTearFlags(bomb, mod.FriendBulletFlags.FRIEND)
	TearFlagsLib.SetTearFlagParams(bomb, mod.FriendBulletFlags.FRIEND, {Shot = shot, Gun = e})

	if isRocket then
		bomb.ExplosionDamage = player.Damage * mod.FriendBalancing.EpicFetusRocketDamageMult
		bomb.Variant = BombVariant.BOMB_ROCKET
		local f = mod:RandomFloat(0.2,0.3)
		bomb.Velocity = bomb.Velocity * f
		bomb:SetRocketAngle(bomb.Velocity:GetAngleDegrees())
		bomb:SetRocketSpeed(bomb.Velocity:Length() * f)
		bomb.PositionOffset = Vector(0, -15)
        bomb:Update()
	else
		bomb:SetExplosionCountdown(bomb:GetExplosionCountdown() + mod:RandomInt(-5,5))
		bomb.ExplosionDamage = player.Damage * mod.FriendBalancing.DrFetusBombDamageMult
		bomb.SpriteOffset = Vector(0, -10)
		local flatStone = bomb:HasTearFlags(TearFlags.TEAR_HYDROBOUNCE)
		if flatStone then
			bomb:ClearTearFlags(TearFlags.TEAR_HYDROBOUNCE)
			bomb:SetExplosionCountdown(bomb:GetExplosionCountdown() * 2)
		end
		TearFlagsLib.AddTearFlags(bomb, mod.FriendBulletFlags.GRENADE)
		TearFlagsLib.SetTearFlagParams(bomb, mod.FriendBulletFlags.GRENADE, {
			FlatStone = flatStone,
			Height = -10,
			FallingSpeed = flatStone and -6 or mod:RandomFloat(-4, -2),
			FallingAcceleration = flatStone and 0.75 or 0.2,
			InitialSpeed = bomb.Velocity:Length(),
		})
	end

	if player:HasCollectible(CollectibleType.COLLECTIBLE_MR_MEGA) then
		bomb.ExplosionDamage = bomb.ExplosionDamage + mod.FriendBalancing.MrMegaBombFlatBonus
	end

	bd.preReloadBonusDamage = bomb.ExplosionDamage

	local flat, mult, crit = mod:GetFriendShotDamageBonus(e, player, shot)
	bomb.ExplosionDamage = (bomb.ExplosionDamage + flat) * mult

	mod:ApplyFriendBombShotEffects(bomb, player, shot, crit)
	mod:ApplyFriendTearColor(bomb)
end

function mod:FireFriendBomb(e, player, aim, posOffset, vel, shot, held)
    local pos = mod:GetFriendGunShootPos(e, aim) + posOffset
	vel = vel:Rotated(mod:RandomFloat(-4, 4))

	if mod:IsFriendSoulGun(e, mod:GetEntityData(e)) then
		local ptype = player:GetPlayerType()
		if ptype ~= mod.PLAYER.FRIEND and ptype ~= mod.PLAYER.BRIEND then
			vel = vel * (1 + mod.FriendBalancing.Shotspeed)
		end
	end

	mod.PreventBulletMuzzleAndSpeedUpFromRandom = true
	local bomb = player:FireBomb(pos, vel, player)
	mod.PreventBulletMuzzleAndSpeedUpFromRandom = nil
	mod:HandleFriendBombs(player, e, bomb, shot, aim, held)

    local gunInfo = mod.FriendGunInfo[e.SubType]
    local isSoulGun = mod:IsFriendSoulGun(e, mod:GetEntityData(e))
    local hasEpicFetus = false

    if isSoulGun and gunInfo and gunInfo.WeaponType == WeaponType.WEAPON_ROCKETS then
        hasEpicFetus = true
    elseif player:HasCollectible(CollectibleType.COLLECTIBLE_EPIC_FETUS) then
        hasEpicFetus = true
    end
	local isRocket = hasEpicFetus or player:HasCollectible(CollectibleType.COLLECTIBLE_ROCKET_IN_A_JAR)

	local flat, mult, crit = mod:GetFriendShotDamageBonus(e, player, shot)
	if not hasEpicFetus and not crit and (not gunInfo or not gunInfo.NoBombShrink) then
		mod:ShrinkBomb(bomb)
	end

	if not Isaac.RunCallbackWithParam("PRE_GUN_FIRE_SOUND", e.SubType, e, player, held) then
		if isRocket then
			mod:FriendPlaySound(e.SubType, "Rocket", 1)
		else
			local isCrit = TearFlagsLib.HasTearFlags(bomb, mod.CritFlag)
            if isCrit then
                mod:FriendPlaySound(e.SubType, "BombCrit", 1)
            else
                mod:FriendPlaySound(e.SubType, "Bomb", 1)
            end
		end
	end

	Isaac.RunCallbackWithParam("POST_GUN_FIRE_BOMB", e.SubType, e, player, bomb, held)

	return bomb
end

function mod.handleGrenadeD3(entity)
	if entity.Type == EntityType.ENTITY_BOMB then
		local bomb = entity:ToBomb()
		local flatStone = bomb:HasTearFlags(TearFlags.TEAR_HYDROBOUNCE)
		if flatStone then
			bomb:ClearTearFlags(TearFlags.TEAR_HYDROBOUNCE)
			bomb:SetExplosionCountdown(bomb:GetExplosionCountdown() * 2)
		end
		TearFlagsLib.SetTearFlagParams(bomb, mod.FriendBulletFlags.GRENADE, {
			FlatStone = flatStone,
			Height = -10,
			FallingSpeed = flatStone and -6 or mod:RandomFloat(-4, -2),
			FallingAcceleration = flatStone and 0.75 or 0.2,
			InitialSpeed = bomb.Velocity:Length(),
		})
	end
end

local doCrawlspaceBugfix = false
function mod:FireFriendTear(e, player, aim, posOffset, vel, shot, held, canFireEvilEye)
    if canFireEvilEye == nil then
        canFireEvilEye = true
    end

    local sinkIn = -5
    local friendGunShootPos = mod:GetFriendGunShootPos(e, aim, sinkIn)
	if mod:IsFriendSoulGun(e, mod:GetEntityData(e)) then
		local ptype = player:GetPlayerType()
		if ptype ~= mod.PLAYER.FRIEND and ptype ~= mod.PLAYER.BRIEND then
			vel = vel * (1 + mod.FriendBalancing.Shotspeed)
		end
	end
	mod.PreventBulletMuzzleAndSpeedUpFromRandom = true
	-- Seems like setting this after FireTear is too late
	mod:AddOneTimeCallback(ModCallbacks.MC_POST_TEAR_INIT, function(_, tear)
		tear:SetInitSound(SoundEffect.SOUND_NULL)
	end)
	doCrawlspaceBugfix = true
    local tear = player:FireTear(friendGunShootPos + posOffset, vel, canFireEvilEye, false, true, player)
	doCrawlspaceBugfix = false
	if not TearFlagsLib.HasTearFlags(tear, TearFlagsLib.Flag.MODEL_ROCKET) then tear.Position = tear.Position - tear.Velocity end
	mod.PreventBulletMuzzleAndSpeedUpFromRandom = nil
    local params = player:GetTearHitParams(WeaponType.WEAPON_TEARS)
    mod:HandleFriendTears(player, e, tear, shot, aim, held, params)

    if not mod.FriendGunInfo[e.SubType].NoMuzzle then
        local muzzlePos = mod:GetFriendGunShootPos(e, aim, sinkIn, nil, true)
        mod:MakeMuzzleFlashFriend(e, player, muzzlePos + posOffset, vel:Normalized())
    end

    return tear
end

mod:AddCallback(ModCallbacks.MC_PRE_TEAR_UPDATE, function(_, tear)
	-- idk im tired
	if doCrawlspaceBugfix and tear.FrameCount == 0 then
		if game:GetRoom():GetType() == RoomType.ROOM_DUNGEON then
			if not (tear:HasTearFlags(TearFlags.TEAR_HYDROBOUNCE) or tear:HasTearFlags(TearFlags.TEAR_LUDOVICO)) then
				tear.FallingSpeed = -0.1
				tear.FallingAcceleration = -0.05
			end
		end
	end
end)

function mod:FireSingleFriendShot(e, aim, posOffset, vel, shot, held, canFireEvilEye, forceWeaponType)
    local player = mod:GetFriendGunPlayer(e)

	if forceWeaponType == WeaponType.WEAPON_BOMBS or forceWeaponType == WeaponType.WEAPON_ROCKETS then
        return mod:FireFriendBomb(e, player, aim, posOffset, vel, shot, held)
	elseif forceWeaponType == WeaponType.WEAPON_TECH_X then
        return mod:FireFriendTechX(e, player, aim, posOffset, vel * 0.5, shot, held)
	elseif forceWeaponType == WeaponType.WEAPON_BRIMSTONE or forceWeaponType == WeaponType.WEAPON_LASER then
        return mod:FireFriendLaser(e, player, aim, posOffset, vel, shot, held)
	elseif forceWeaponType ~= nil then
        return mod:FireFriendTear(e, player, aim, posOffset, vel, shot, held, canFireEvilEye)
    elseif player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS) or player:HasCollectible(CollectibleType.COLLECTIBLE_EPIC_FETUS) then
        return mod:FireFriendBomb(e, player, aim, posOffset, vel, shot, held)
    elseif player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_X) then
        return mod:FireFriendTechX(e, player, aim, posOffset, vel * 0.5, shot, held)
    elseif player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY) or player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) or player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_BRIMSTONE) then
        return mod:FireFriendLaser(e, player, aim, posOffset, vel, shot, held)
    else
        return mod:FireFriendTear(e, player, aim, posOffset, vel, shot, held, canFireEvilEye)
    end
end

-- Returns how much extra ammo the player should have per bullet.
-- So a value of 2 will allow the player to shoot 2 bullets before the 3rd one, which will consume an ammo.
function mod:GetFriendExtraAmmo(player)
    local maxFireDelay = player.MaxFireDelay
    local currentTears = 30 / (maxFireDelay + 1)
    local baseExtra = (currentTears - mod.FriendBalancing.HighFireRateExtraAmmoMinimum) // mod.FriendBalancing.HighFireRateExtraAmmoInterval

    -- In vanilla, soy + brimstone lets you shoot forever
    -- This behavior wouldn't work well for Friend, so just let you shoot for a lot longer per bullet
    -- Quite strong actually!
    if mod:GetFriendWeaponType(player) == WeaponType.WEAPON_BRIMSTONE then
        baseExtra = baseExtra * 8
    end

    return baseExtra
end

function mod:GetFriendGunNextShot(gun, bypassAmmo)
	local player = mod:GetFriendGunPlayer(gun)
	local pd = mod:GetEntityData(player)
	local gunTable = pd.FriendHeldGuns[gun.InitSeed]

	if #gunTable.Ammo > 0 then
		local gd = mod:GetEntityData(gun)
		local shot = mod:makeCopiedTable(gunTable.Ammo[#gunTable.Ammo])

        if shot.OverlayKeys and shot.OverlayKeys["FOOLS_GOLD_HEART"] and shot.LastInHeart then
            local rng = gun:GetDropRNG()
            if rng:RandomFloat() <= mod.FriendBalancing.FoolsGoldChance then
                shot.ForceImmoral = false
                shot.ForceGold = true
            else
                shot.ForceGold = false
                shot.ForceImmoral = true
            end
        end

		if not bypassAmmo and not Isaac.RunCallbackWithParam("PRE_GUN_FIRE_CONSUME_AMMO", gun.SubType, gun, player, shot, gd) then
			local usedExtraAmmo = false

			local extraAmmo = mod:GetFriendExtraAmmo(player)
			gd.FriendConserveAmmo = gd.FriendConserveAmmo or 0
            if gd.FriendConserveAmmo > 0 or extraAmmo > 0 then
				if not gd.FriendConserveAmmo then
					gd.FriendConserveAmmo = extraAmmo
				end

				if gd.FriendConserveAmmo >= 0 then
					usedExtraAmmo = true
                elseif extraAmmo > 0 then
					gd.FriendConserveAmmo = extraAmmo
				end

                gd.FriendConserveAmmo = math.max(gd.FriendConserveAmmo - 1, 0)
			end

			-- Only shake the hearts in the HUD when friend's main gun shoots.
			if pd.FriendsRevolver and gun.InitSeed == pd.FriendsRevolver.InitSeed then
				local targetEntry = mod:makeCopiedTable(shot)
				targetEntry.ShakeTimer = {2, 2}
				pd.FriendHeartsJustFired = pd.FriendHeartsJustFired or {}
				pd.FriendHeartsJustFired[targetEntry.Index] = targetEntry
			end

			if not shot.ForceGold and not usedExtraAmmo and (not (shot.OverlayKeys and shot.OverlayKeys["GOLDEN_HEART"] and shot.LastInHeart) or mod:RandomFloat() > mod.FriendBalancing.GoldHeartChance) then
				gunTable.Ammo[#gunTable.Ammo] = nil
				if shot.OverlayKeys then
					shot.OverlayKeys["GOLDEN_HEART"] = nil
				end

                -- Use the full heart
                if shot.ForceImmoral then
                    gunTable.Ammo[#gunTable.Ammo] = nil
                end
			end
		end

		shot.Crit = (shot.HeartKey == "IMMORAL_HEART" or shot.ForceImmoral) and mod:RandomInt(100) < mod:GetFriendCritChance(player)

		return shot
	elseif bypassAmmo then
		return {Index = 1, HeartKey = "RED_HEART", LastInHeart = true, HealthPosition = {1, 1}, HeartType = "Red"}
	end
end

function mod:FriendSecondaryFire(player, aim, amount, owner, e, shots, p, forceWeaponType)
	if not (mod:GetEntityData(e).isTemporaryGun or player:HasCollectible(CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE) or player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION) or mod:IsFriendSoulGun(e, mod:GetEntityData(e))) then
		local params = p or {}
		params.DoBasegameEffects = true
		params.FriendGun = e
		params.FriendAmmoUsed = shots

		if forceWeaponType == WeaponType.WEAPON_SPIRIT_SWORD or forceWeaponType == WeaponType.WEAPON_BONE then
			params.WeaponType = WeaponType.WEAPON_SPIRIT_SWORD
		elseif forceWeaponType == WeaponType.WEAPON_BOMBS or forceWeaponType == WeaponType.WEAPON_ROCKETS then
			params.WeaponType = WeaponType.WEAPON_BOMBS
		elseif forceWeaponType == WeaponType.WEAPON_TECH_X then
			params.WeaponType = WeaponType.WEAPON_TECH_X
		elseif forceWeaponType == WeaponType.WEAPON_BRIMSTONE then
			params.WeaponType = WeaponType.WEAPON_BRIMSTONE
		elseif forceWeaponType == WeaponType.WEAPON_LASER then
			params.WeaponType = WeaponType.WEAPON_LASER
		elseif forceWeaponType ~= nil then
			params.WeaponType = WeaponType.WEAPON_TEARS
		elseif player:HasCollectible(CollectibleType.COLLECTIBLE_SPIRIT_SWORD) or player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_BERSERK) then
			params.WeaponType = WeaponType.WEAPON_SPIRIT_SWORD
		elseif player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS) or player:HasCollectible(CollectibleType.COLLECTIBLE_EPIC_FETUS) then
			params.WeaponType = WeaponType.WEAPON_BOMBS
		elseif player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_X) then
			params.WeaponType = WeaponType.WEAPON_TECH_X
		elseif player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) or player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_BRIMSTONE) then
			params.WeaponType = WeaponType.WEAPON_BRIMSTONE
		elseif player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY) then
			params.WeaponType = WeaponType.WEAPON_LASER
		else
			params.WeaponType = WeaponType.WEAPON_TEARS
		end

		if player:HasCollectible(CollectibleType.COLLECTIBLE_MONSTROS_LUNG) then
			if params.WeaponType == WeaponType.WEAPON_BOMBS or params.WeaponType == WeaponType.WEAPON_TEARS then
				params.WeaponType = WeaponType.WEAPON_MONSTROS_LUNGS
			else
				params.WeaponModifiers = (params.WeaponModifiers or 0) | WeaponModifier.MONSTROS_LUNG
			end
		end

		mod.SecondaryFireTearEffectFriendGun = params.FriendGun
		mod.SecondaryFireTearEffectFriendAmmoUsed = params.FriendAmmoUsed
		mod:SecondaryFire(player, aim:Normalized(), amount, owner, params)
		mod.SecondaryFireTearEffectFriendGun = nil
		mod.SecondaryFireTearEffectFriendAmmoUsed = nil
	end
end

mod.SecondaryFireTearEffectFriendGun = nil
mod.SecondaryFireTearEffectFriendAmmoUsed = nil
function mod:handleFriendSecondaryFireTearEffects(tear, player)
	if mod.SecondaryFireTearEffectFriendGun then
		local ammo = mod.SecondaryFireTearEffectFriendAmmoUsed[mod:RandomInt(1, #mod.SecondaryFireTearEffectFriendAmmoUsed )]
		if ammo.HeartKey == "IMMORAL_HEART" or ammo.ForceImmoral then
			local newammo = mod:makeCopiedTable(ammo)
			newammo.Crit = mod:RandomInt(100) < mod:GetFriendCritChance(player)
			ammo = newammo
		end
		mod:HandleFriendTears(player, mod.SecondaryFireTearEffectFriendGun, tear, ammo)
		local isFetusGun = mod.SecondaryFireTearEffectFriendGun.Parent and mod.SecondaryFireTearEffectFriendGun.Parent.Type == EntityType.ENTITY_TEAR and mod.SecondaryFireTearEffectFriendGun.Parent.Variant == TearVariant.FETUS
		if isFetusGun then
			local beeSkinMult = (TearFlagsLib.HasTearFlags(mod.SecondaryFireTearEffectFriendGun.Parent, TearFlagsLib.Flag.BEE_SKIN) and 0.3) or 1
			tear.CollisionDamage = tear.CollisionDamage * mod.FRIEND_C_SECTION.DAMAGE_MULT * beeSkinMult
		end
	end
end
mod:AddCallback(FiendFolio.CALLBACK.FF_POST_FIRE_SECONDARY_TEAR, mod.handleFriendSecondaryFireTearEffects)

--- Set bypassAmmo to true to make the shot not cost any ammo.
function mod:FireGunFriend(e, aim, held, canFireEvilEye, bypassAmmo, forceShotType, bypassMovementInheritance, forceWeaponType)
    local d = mod:GetEntityData(e)
    local sprite = e:GetSprite()
    local rng = e:GetDropRNG()
    local player, parent, owner = mod:GetFriendGunPlayer(e)
    local pd = mod:GetEntityData(player)
    local gunTable = pd.FriendHeldGuns[e.InitSeed]

    local shot = forceShotType or mod:GetFriendGunNextShot(e, bypassAmmo)

    local isSoulGun = mod:IsFriendSoulGun(e, d)
    if isSoulGun and forceWeaponType == nil then
        local gunInfo = mod.FriendGunInfo[e.SubType]
        if gunInfo and gunInfo.WeaponType then
            forceWeaponType = gunInfo.WeaponType
        end
    end

    if shot then
        aim = Isaac.RunCallbackWithParam("PRE_GUN_FIRE_LATE", e.SubType, e, player, aim) or aim
        local gunInfo = mod.FriendGunInfo[e.SubType]

        if not gunInfo.CustomAnim then
            sprite:Play("Shoot", true)
        end

        d.state = "Shoot"

        local shotSpeed = player.ShotSpeed
        if player:HasCollectible(CollectibleType.COLLECTIBLE_STYE)
        and pd.FriendIsRightEye then
            shotSpeed = shotSpeed - 0.3
        end

        local vel = aim:Resized(10 * shotSpeed)
        if not (pd.LastFiredMouse and mod.MouseGunAiming == 1)
        and not bypassMovementInheritance then
            vel = vel + player:GetTearMovementInheritance(aim)
        end

        local shotPosVels = {}
		local amount
        if player:GetPlayerType() == FiendFolio.PLAYER.BRIEND and pd.FriendsRevolver and GetPtrHash(e) == GetPtrHash(pd.FriendsRevolver) then
            local weaponType = mod:GetFriendWeaponType(player)
            local multiShotParams = player:GetMultiShotParams(weaponType)
			amount = multiShotParams:GetNumTears()
            for i=0, amount-1 do
                table.insert(shotPosVels, player:GetMultiShotPositionVelocity(i, weaponType, vel:Normalized(), vel:Length(), multiShotParams))
            end
        else
			amount = gunInfo.MultiShot or 1

            shotPosVels = mod:CalcMultiShotOffsets({
                NumTears = amount,
                Direction = vel,
                SpreadAngle = gunInfo.MultiShotSpread,
                NoArc = gunInfo.NoMultiShotArc,
            })
        end

        local shotThings = {}
        for _, posVel in ipairs(shotPosVels) do
			mod.SecondaryFireTearEffectFriendGun = e
			mod.SecondaryFireTearEffectFriendAmmoUsed = {shot}
            table.insert(shotThings, mod:FireSingleFriendShot(e, aim, posVel.Position * 10, posVel.Velocity, shot, held, canFireEvilEye, forceWeaponType))
			mod.SecondaryFireTearEffectFriendGun = nil
			mod.SecondaryFireTearEffectFriendAmmoUsed = nil
        end

        if #gunTable.Ammo == 0 and not d.NoReload then
            d.state = "Reload"
            d.substate = "Begin"

            if player:HasCollectible(mod.ITEM.COLLECTIBLE.FETAL_FRIEND) and pd.FriendsRevolver and e.InitSeed == pd.FriendsRevolver.InitSeed then
                player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_SHOTSPEED | CacheFlag.CACHE_DAMAGE, true)
            end
        end

        if d.GunLimitedAmmo then
            d.GunLimitedAmmo = d.GunLimitedAmmo - 1
        end

		mod:FriendSecondaryFire(player, aim, amount, owner, e, {shot}, nil, forceWeaponType)

        pd.FriendHeldGuns[e.InitSeed].LastFrameFired = e.FrameCount
        Isaac.RunCallbackWithParam("POST_GUN_FIRE", e.SubType, e, player, aim, {shot}, held, shotThings)

        if mod.FriendGunInfo[e.SubType].Ejection then
            mod:SpawnCasing(e, player)
        end

        return shotThings
    else
        --sfx:Play(clicking)
        if d.state ~= "Reload" and not d.NoReload then
            d.state = "Reload"
            d.substate = "Begin"
            d.reloadOverride = true
            pd.FriendHeldGuns[e.InitSeed].LastFrameFired = e.FrameCount
        end
    end
end

function mod:ReloadFriendBullet(e, player)
	local pd = mod:GetEntityData(player)
	local gunTable = pd.FriendHeldGuns[e.InitSeed]
	local targetTable = mod:GetFriendAmmo(e)
	local original = targetTable[#gunTable.Ammo+1]
	local rng = e:GetDropRNG()

	-- Only shake the hud when friend's main gun reloads.
	if pd.FriendsRevolver and e.InitSeed == pd.FriendsRevolver.InitSeed then
		local targetEntry = mod:makeCopiedTable(original)
		targetEntry.ReloadTimer = 3
		targetEntry.ShakeTimer = {2, 2}
		pd.FriendHeartsJustReloaded = pd.FriendHeartsJustReloaded or {}
		pd.FriendHeartsJustReloaded[targetEntry.Index] = targetEntry
	end

	table.insert(gunTable.Ammo, original)

    if #gunTable.Ammo == 1 then
        if player:HasCollectible(mod.ITEM.COLLECTIBLE.FETAL_FRIEND) and pd.FriendsRevolver and e.InitSeed == pd.FriendsRevolver.InitSeed then
            player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_SHOTSPEED | CacheFlag.CACHE_DAMAGE, true)
        end
    end

    if not mod.FriendGunInfo[e.SubType].Ejection then
        mod:SpawnCasing(e, player)
    end
end

function mod:SpawnCasing(e, player)
    local rng = e:GetDropRNG()
   	local vel = (player.Velocity * 1.2):Rotated(mod:RandomInt(-50,50,rng))
    local guninfo = mod.FriendGunInfo[e.SubType] or {}
	if vel:Length() < 1 then
		vel = Vector(1, 0):Rotated(rng:RandomInt(360))
	elseif vel:Length() > 6 then
		vel = vel:Resized(6)
	end

    if not mod:GetEntityData(e).RevolverInvisible then
        local case = Isaac.Spawn(1000, mod.FF.FriendCasing.Var, mod.FF.FriendCasing.Sub, e.Position, vel, player):ToEffect()
        local scale = mod:GetEntityData(e).ForceCasingScale or guninfo.CasingScale or mod.FriendBalancing.DefaultCasingScale
        case.SpriteScale = Vector(0.7, 0.5) * scale
        case.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
        local cd = mod:GetEntityData(case)
        if game:GetRoom():GetType() ~= RoomType.ROOM_DUNGEON then
            cd.launchedEnemyInfo = {zVel = -5, height = -2, landFunc = function()
                local vol = 0.5
                sfx:Play(mod.Sounds.D2Toss,0.06*vol,0,false, mod:RandomInt(95,115,rng)/100)
                case.SpriteOffset = Vector(0, -2)
                cd.launchedEnemyInfo = {zVel = -2.5, height = -2, landFunc = function()
                    sfx:Play(mod.Sounds.D2Toss,0.04*vol,0,false, mod:RandomInt(130,145,rng)/100)
                    case.SpriteOffset = Vector(0, -2)
                    cd.launchedEnemyInfo = {zVel = -1, height = -2, landFunc = function()
                        sfx:Play(mod.Sounds.D2Toss,0.01*vol,0,false, mod:RandomInt(160,170,rng)/100)
                        cd.FinishedBouncing = true
                    end}
                end}
            end}
        end
        if mod.FriendGunInfo[e.SubType].Casing then
            case:GetSprite():Play(guninfo.Casing, true)
        end
    end
end

function mod:MakeMuzzleFlashFriend(e, player, pos, aim)
    local continue = Isaac.RunCallbackWithParam("MUZZLE_FLASH", e.SubType, e, player)
    if not continue then
        local guninfo = mod.FriendGunInfo[e.SubType] or {}
        local muzzleOffset = mod:GetFriendGunMuzzleOffset(e)
        local scale = mod:GetEntityData(e).ForceMuzzleScale or guninfo.MuzzleScale or mod.FriendBalancing.DefaultMuzzleScale
        --local mult = (e.FlipX and -1) or g
        local flash = Isaac.Spawn(mod.FF.MuzzleFlash.ID, mod.FF.MuzzleFlash.Var, mod.FF.MuzzleFlash.Sub, pos, Vector.Zero, e):ToEffect()
        local flashSprite = flash:GetSprite()
        flash.PositionOffset = Vector(0, muzzleOffset.Y)
        flashSprite.PlaybackSpeed = math.random(50, 150)/100

        if guninfo.MuzzleColor then
            flashSprite.Color = guninfo.MuzzleColor
        else
            flashSprite.Color = mod:ColorHSV(0.0, 0.0, 1.0, 1, 0.1, 1.0, 0.9)
        end

        flash.SpriteScale = Vector(1, 1) * scale
        flash.DepthOffset = 75

        local angle = aim:GetAngleDegrees()
        if angle > 90 or angle < -90 then
            angle = (-angle) % 360
            flashSprite.FlipY = true
        end
        flash.SpriteRotation = angle
        flash.Parent = e
    end
end

function mod:tearHasCustomNoFallEffects(tear)
	return not (FiendFolio.HasCetusFlag(tear) or TearFlagsLib.HasTearFlags(tear, TearFlagsLib.Flag.SPLATTERSHOT)) and (TearFlagsLib.HasTearFlags(tear, mod.FriendBulletFlags.FRIEND) or TearFlagsLib.HasTearFlags(tear, mod.FriendBulletFlags.AMMO_CLIP) or TearFlagsLib.HasTearFlags(tear, mod.FriendBulletFlags.NO_FALL_TEAR))
end

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tear)
	local hasNoFallEffects = mod:tearHasCustomNoFallEffects(tear)
    local lifespan = (TearFlagsLib.HasTearFlags(tear, mod.FriendBulletFlags.BLACK) and TearFlagsLib.GetTearFlagParams(tear, mod.FriendBulletFlags.BLACK).LifeSpan) or
	                 (hasNoFallEffects and 125) or
	                 nil
    if lifespan and tear.FrameCount < lifespan then
       if not (tear:HasTearFlags(TearFlags.TEAR_HYDROBOUNCE) or tear:HasTearFlags(TearFlags.TEAR_LUDOVICO) or TearFlagsLib.HasTearFlags(tear, TearFlagsLib.Flag.STARDUST)) then
            tear.FallingSpeed = -0.1
            tear.FallingAcceleration = -0.05
        end
    end

    if TearFlagsLib.HasTearFlags(tear, mod.FriendBulletFlags.GOLD) then
        if tear.FrameCount % 6 == 0 then
			local rng = tear:GetDropRNG()
            local sparkle = Isaac.Spawn(1000, 1727, 0, tear.Position+mod:shuntedPosition(10, rng), Vector.Zero, tear):ToEffect()
            sparkle.SpriteOffset = Vector(0, tear.Height)
            sparkle.SpriteScale = Vector(0.8, 0.8)
            sparkle:SetColor(Color(1,1,1,1,1,1,0), 100, 1, false, false)
            sparkle:Update()
        end
    end

    if TearFlagsLib.HasTearFlags(tear, mod.FriendBulletFlags.FORCE_DIE_ON_WALLS) and not tear:IsDead() then
        local params = TearFlagsLib.GetTearFlagParams(tear, mod.FriendBulletFlags.FORCE_DIE_ON_WALLS)
        if params.NoCollideTime and params.NoCollideTime <= tear.FrameCount then
            local room = game:GetRoom()
            local grid = room:GetGridEntityFromPos(tear.Position)
            if grid and grid.CollisionClass == GridCollisionClass.COLLISION_WALL and grid:GetType() ~= GridEntityType.GRID_PILLAR then
                tear:Die()
            elseif not room:IsPositionInRoom(tear.Position, -20) then
                tear:Die()
            end
        end
    end

    if hasNoFallEffects and tear.Position:Distance(game:GetRoom():GetClampedPosition(tear.Position, 0)) > 1000 then
		local d = mod:GetEntityData(tear)
        d.ffNoSplat = true
        tear:Remove()
    end
end)

mod:AddCallback(ModCallbacks.MC_PRE_EFFECT_RENDER, function(_, e)
	local d = mod:GetEntityData(e)
	if d.RevolverInvisible or not e:Exists() then
		return false
	end

	local sprite = e:GetSprite()
	local subt = e.SubType

    local shouldHaveDeagleShader = d.IsBriendDeagle

    if not shouldHaveDeagleShader and e.Parent then
        local ownerData = mod:GetEntityData(e.Parent)
        local player = e.Parent:ToPlayer()
        local familiar = e.Parent:ToFamiliar()

        shouldHaveDeagleShader = (
            d.IsFriendSoulGun
            and player
            and mod:IsBriendTwin(player)
        ) or (
            ownerData.FamiliarCopyingFriendsGuns
            and mod:IsBriendTwin(familiar.Player)
        )
    end

	if shouldHaveDeagleShader and not (mod.FriendGunInfo[subt].NoGolden or mod.FriendGunInfo[subt].GoldenSprite) then
        -- Tint the gun gold for visibility
        sprite:SetCustomShader("shaders/fiendfolio/coloroffset_deagle")
		local color = Color()
		color:SetColorize(mod.FriendGunInfo[subt].GoldenValueThreshold or 0.0,
		                  mod.FriendGunInfo[subt].GoldenBrightnessTint or 0.0,
		                  mod.FriendGunInfo[subt].GoldenBrightnessOffset or 0.0,
		                  mod.FriendGunInfo[subt].GoldenSaturationMult or 0.0)
		sprite.Color = color
	else
		sprite:ClearCustomShader()
		sprite.Color = Color()
	end

	local renderMode = game:GetRoom():GetRenderMode()

	if renderMode == RenderMode.RENDER_WATER_REFRACT or renderMode == RenderMode.RENDER_WATER_REFLECT then
		sprite.Color.A = 0
	elseif d.expiringGun then
		if not d.expiringGunTimer then
			d.expiringGunTimer = 16
		elseif not game:IsPaused() then
			d.expiringGunTimer = d.expiringGunTimer - 1
		end
		if d.expiringGunTimer < 1 then
			e:Remove()
			return false
		end
		sprite.Color.A = math.min(1, d.expiringGunTimer / 8)
	else
		sprite.Color.A = 1
	end

	if sprite.FlipX or sprite.FlipY then
		return mod:GetSpriteFlippedAxisCorrectionOffset(sprite, true)
	end
end, mod.FF.FriendsRevolver.Var)

--FRIEND'S POCKET ACTIVES
--Some code adapted from Connor's Gaper in a Jar and the held active code from erfly!!

local fireballSprite = Sprite()
fireballSprite:Load("gfx/projectiles/projectile_friend_fireball.anm2", true)
fireballSprite:Play("MoveHori")
fireballSprite.Rotation = 90

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, item, rng, player, useflags, activeslot)
	if useflags & UseFlag.USE_CARBATTERY ~= 0 then
		return {Discharge = false, Remove = false, ShowAnim = false}
	end
	local d = mod:GetEntityData(player)
	if d.holdingFFItem then
		d.holdingFFItem = nil
		d.holdingFFItemSlot = nil
        d.HoldingFFItemBlankVisual = true
        d.putFireballAway = true
		player:AnimatePickup(Sprite(), false, "HideItem")
        d.FriendFireballFrames = 1
	else
		d.holdingFFItem = mod.ITEM.COLLECTIBLE.HOT_SHOT
		d.holdingFFItemSlot = activeslot
		d.HoldingFFItemBlankVisual = true
        d.putFireballAway = nil
		player:AnimatePickup(Sprite(), false, "LiftItem")
        d.FriendFireballFrames = 1
        if mod.FriendBalancing.SearingShotCosmetics then
            if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
                fireballSprite:ReplaceSpritesheet(0, "gfx/projectiles/projectile_friend_fireball_birthright2.png")
            else
                fireballSprite:ReplaceSpritesheet(0, "gfx/projectiles/projectile_friend_fireball.png")
            end
            fireballSprite:LoadGraphics()
        end
	end

	return {Discharge = false}
end, mod.ITEM.COLLECTIBLE.HOT_SHOT)

mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_ACTIVE_ITEM, function(_, player, slot, offset, alpha, scale)
    if mod.FriendBalancing.SearingShotCosmetics then
        local cropOffsetX = 0
        local itemConfig = itemConfig:GetCollectible(FiendFolio.ITEM.COLLECTIBLE.HOT_SHOT)
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
            cropOffsetX = 32
            itemConfig.Name = mod.FriendBalancing.SearingShotName
            itemConfig.Description = mod.FriendBalancing.SearingShotDescription
        else
            itemConfig.Name = mod.FriendBalancing.OriginalName
            itemConfig.Description = mod.FriendBalancing.OriginalDescription
        end
        local cropOffset = Vector(cropOffsetX, 0)

        return {CropOffset = cropOffset}
    end
end, mod.ITEM.COLLECTIBLE.HOT_SHOT)

function mod:friendFireballRender(player, d)
    if not (game:GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT) then
        if d.holdingFFItem and d.holdingFFItem == mod.ITEM.COLLECTIBLE.HOT_SHOT then
            local framePosition = {1, 1, -26, -20, -14, -21, -28, -26, -25}
            if d.FriendFireballFrames < #framePosition and game:GetFrameCount() % 2 == 0 then
                d.FriendFireballFrames = d.FriendFireballFrames+1
            end
            if framePosition[d.FriendFireballFrames] and framePosition[d.FriendFireballFrames] < 0 then
                fireballSprite:Render(Isaac.WorldToScreen(player.Position + Vector(0, -1+framePosition[d.FriendFireballFrames])*player.SpriteScale.Y*2))
                --[[local moveVec = (player.Velocity:Length() > 0.3 and player.Velocity) or (player:GetMovementVector():Length() > 0.3 and player:GetMovementVector()) or player.Velocity
                fireballSprite.Rotation = moveVec:GetAngleDegrees()]]

                if game:GetFrameCount() % 2 == 0 then
                    fireballSprite:Update()
                end
            end
        elseif d.putFireballAway then
            local framePosition = {-25, -23, -16, 1}
            if d.FriendFireballFrames < #framePosition and game:GetFrameCount() % 2 == 0 then
                d.FriendFireballFrames = d.FriendFireballFrames+1
            end
            if framePosition[d.FriendFireballFrames] and framePosition[d.FriendFireballFrames] < 0 then
                fireballSprite:Render(Isaac.WorldToScreen(player.Position + Vector(0, -1+framePosition[d.FriendFireballFrames])*player.SpriteScale.Y*2))
                --[[local moveVec = (player.Velocity:Length() > 0.3 and player.Velocity) or (player:GetMovementVector():Length() > 0.3 and player:GetMovementVector()) or player.Velocity
                fireballSprite.Rotation = moveVec:GetAngleDegrees()]]
                if game:GetFrameCount() % 2 == 0 then
                    fireballSprite:Update()
                end
            else
                d.putFireballAway = nil
            end
        end
    end
end

function mod:useFireballActive(player, aim, slot)
    local count = player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) and 2 or 1
    for ballNum = 1, count do
        local isCarBattery = ballNum == 2
        local fireballSpeed = isCarBattery and mod.FriendBalancing.SFInitialSpeedCarBattery or mod.FriendBalancing.SFInitialSpeed
        local vel = aim:Resized(fireballSpeed)
        if not (mod:GetEntityData(player).LastFiredMouse and mod.MouseGunAiming == 1) then
            vel = vel + player:GetTearMovementInheritance(aim)
        end

        local fireball = Isaac.Spawn(mod.FF.FriendFireball.ID, mod.FF.FriendFireball.Var, mod.FF.FriendFireball.Sub, player.Position, vel, player)
        local fd = mod:GetEntityData(fireball)
        fd.fireballDirection = vel
        fireball.Parent = player
        if mod.FriendBalancing.SearingShotCosmetics then
            if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
                local fsprite = fireball:GetSprite()
                fsprite:ReplaceSpritesheet(0, "gfx/projectiles/projectile_friend_fireball_birthright2.png")
                fsprite:LoadGraphics()
            end
        end
        sfx:Play(mod.Sounds.FireLight, 1.6, 0, false, mod:RandomInt(110,130,fireball:GetDropRNG())/100)
        if slot >= 0 then
            player:DischargeActiveItem(slot)
        end
        mod:GetEntityData(player).friendFireballs = mod:GetEntityData(player).friendFireballs or {}
        table.insert(mod:GetEntityData(player).friendFireballs, fireball)

        if player:HasTrinket(mod.ITEM.ROCK.ELECTRUM) then
            fd.electrumFireball = true
        end

        local range = player.TearRange / 40
        local lifespan = range * mod.FriendBalancing.SFLifespanRangeMult
        lifespan = math.max(math.ceil(lifespan), mod.FriendBalancing.SFLifespanMin)

        if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
            fd.IsBirthrightFireball = true
            fd.Hits = mod.FriendBalancing.SFFireballBirthrightHits
            lifespan = math.ceil(lifespan * mod.FriendBalancing.SFLifespanBirthrightMult)
        else
            fd.IsBirthrightFireball = false
            fd.Hits = 1
        end

        fd.FireballLifespan = lifespan

        -- Make the size smaller
        if isCarBattery then
            fireball:GetSprite().Scale = Vector(0.5, 0.5)
            fireball.SizeMulti = Vector(0.7, 0.7)
            fd.IsCarBatteryFireball = true
        end

        fireball:Update()
    end
end

-- Gives something the ability to spawn a friend heart when it kills something else
function mod:LetSpawnFriendHearts(data, forceChance)
    data.FriendHealthBullet = true
    data.FriendHealthChance = forceChance or mod.FriendBalancing.SFHeartChance
end

function mod:friendFireballUpdate(npc)
    local sprite = npc:GetSprite()
    local d = mod:GetEntityData(npc)
    local level = game:GetLevel():GetAbsoluteStage()
    local rng = npc:GetDropRNG()

    if not d.init then
        npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        npc:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_DEATH_TRIGGER | EntityFlag.FLAG_NO_FLASH_ON_DAMAGE | EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_HIDE_HP_BAR | EntityFlag.FLAG_NO_REWARD | EntityFlag.FLAG_NO_QUERY | EntityFlag.FLAG_NO_BLOOD_SPLASH)
        mod:LetSpawnFriendHearts(d)

        d.currentSpeed = mod.FriendBalancing.SFInitialSpeed
        if d.IsCarBatteryFireball then
            d.currentSpeed = mod.FriendBalancing.SFInitialSpeedCarBattery
        end
        d.init = true
    else
        npc.StateFrame = npc.StateFrame+1
    end

    npc.SpriteOffset = mod.FriendBalancing.FireballSOffset+npc.Velocity:Resized(-2)

    d.fireballDirection = d.fireballDirection or npc.Velocity
    npc.Velocity = mod:Lerp(npc.Velocity, d.fireballDirection:Resized(d.currentSpeed), 0.4)
    if d.currentSpeed > mod.FriendBalancing.SFSlowSpeed then
        d.currentSpeed = math.max(mod.FriendBalancing.SFSlowSpeed, d.currentSpeed*0.973)
    end

    if d.IsCarBatteryFireball then
        npc.Scale = 0.75
    end

    --[[if math.abs(npc.Velocity.X) > math.abs(npc.Velocity.Y) then
        sprite.FlipX = npc.Velocity.X < 0
        mod:spritePlay(sprite, "MoveHori")
    else
        sprite.FlipY = npc.Velocity.Y < 0
        mod:spritePlay(sprite, "MoveVert")
    end]]

    mod:spritePlay(sprite, "MoveHori")
    npc.SpriteRotation = npc.Velocity:GetAngleDegrees()

    if d.SuperExplode then
        if not d.warning then
            d.timer = 2
            npc.Color = Color(1, 1, 1, 1, 1, 1, 1)
            d.warning = true
            --sfx:Play(mod.Sounds.CameraPrime, 0.2, 0, false, 2)
            sfx:Play(mod.Sounds.PitchforkHit, 2, 0, false, 2)

            local plurple = Color(0.5, 0.7, 1, 1, 0, 0, 0)
            plurple:SetColorize(0.5, 0.2, 0.8, 1)
            if mod.FriendBalancing.SearingShotCosmetics then
                if d.IsBirthrightFireball then
                    plurple = Color(35/255,175/255,1,1)
                end
            end
            --[[for i=1,8 do
                local vec = Vector(0, mod:RandomInt(4,9,rng)/10):Rotated(rng:RandomInt(360))
                local ember = Isaac.Spawn(1000, EffectVariant.EMBER_PARTICLE, 0, npc.Position, vec, npc):ToEffect()
                ember.Color = plurple
            end]]
            for i=0,2 do
                mod.scheduleForUpdate(function()
                    local burst = Isaac.Spawn(1000, EffectVariant.BIG_ATTRACT, 10, npc.Position, Vector.Zero, npc):ToEffect()
                    burst:SetTimeout(10)
                    burst.Color = plurple
                    mod:GetEntityData(burst).cochleaEffect = {scale = 0.01, frames = 0, maxScale = 0.2, speed = 0.045, slowdown = 0.7}
                    burst.SpriteScale = Vector.Zero
                    burst:GetSprite().Rotation = burst:GetDropRNG():RandomInt(360)
                    burst.SpriteOffset = mod.FriendBalancing.FireballSOffset
                    burst:FollowParent(npc)
                    burst:Update()
                end, i)
            end
        elseif d.timer > 0 then
            d.timer = d.timer-1
            d.currentSpeed = d.currentSpeed*0.9
        else
            d.FriendHealthChance = mod.FriendBalancing.SFHitHeartChance
            local player = npc.Parent:ToPlayer()
            if player then
                --Little bit cheaty, some naughty players might find a way to abuse this, but just makes it so birthright ones don't hurt players
                for _, p in ipairs(Isaac.FindInRadius((npc.Position), mod.FriendBalancing.SFHitRadius + 1, EntityPartition.PLAYER)) do
                    if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
                    or p.Position:Distance(npc.Position) > mod.FriendBalancing.SFPlayerRadius
                    then
                        local realP = p:ToPlayer()
                        realP:SetMinDamageCooldown(1)
                    end
                end

                local explosionRadius = mod.FriendBalancing.SFHitRadius
                local explosionDamage = player.Damage*mod.FriendBalancing.SFHitDamageMult+mod.FriendBalancing.SFHitDamageFlat*level
                if d.IsCarBatteryFireball then
                    explosionDamage = explosionDamage / 2
                    explosionRadius = mod.FriendBalancing.SFHitRadiusCarBattery
                end
                game:BombDamage(
                    npc.Position,
                    explosionDamage,
                    explosionRadius,
                    false, npc, 0,
                    DamageFlag.DAMAGE_EXPLOSION | DamageFlag.DAMAGE_IGNORE_ARMOR,
                    true
                )

                local scale = Vector(explosionRadius/75, explosionRadius/60)
                local expSub = mod.FF.FriendExplosion.Sub
                if mod.FriendBalancing.SearingShotCosmetics then
                    if d.IsBirthrightFireball then
                        expSub = mod.FF.FriendExplosionB.Sub
                    end
                end

                local explosion = Isaac.Spawn(1000, mod.FF.FriendExplosion.Var, expSub, npc.Position, Vector.Zero, player):ToEffect()
                explosion.SpriteScale = scale
                local crater = Isaac.Spawn(1000, 18, 0, npc.Position, Vector.Zero, player):ToEffect()
                crater.SpriteScale = scale

                --For purpose of letting mod stuff be aware something happened
                local splosion = Isaac.Spawn(1000,EffectVariant.BOMB_EXPLOSION,0,npc.Position,Vector.Zero,nil)
                splosion.Color = mod.ColorInvisible
                splosion:Update()

                mod:GetEntityData(player).friendFireballs = mod:GetEntityData(player).friendFireballs or {}
                for _,fire in pairs(mod:GetEntityData(player).friendFireballs) do
                    if fire and fire:Exists() and fire.Position:Distance(npc.Position) < explosionRadius then
                        --mod:GetEntityData(fire).timer = 0
                        --mod:GetEntityData(fire).warning = true
                        mod:GetEntityData(fire).SuperExplode = true
                    end
                end

                game:ShakeScreen(14)
                --sfx:Play(SoundEffect.SOUND_BOSS1_EXPLOSIONS, 1, 0, false, 1)

                if d.electrumFireball then
                    local rng2 = player:GetTrinketRNG(mod.ITEM.ROCK.ELECTRUM)
                    local mult = mod.GetGolemTrinketPower(player, mod.ITEM.ROCK.ELECTRUM)
                    mod:alternateElectrumShock(player, rng2, player.Damage*mult+mod.FriendBalancing.SFHitDamageSuperFlat*2, npc.Position, 3)
                end

                d.Hits = d.Hits or 1
                d.Hits = d.Hits - 1
                if d.Hits <= 0 then
                    npc:Remove()
                else
                    -- Make it smaller (birthright)
                    npc.Color = Color.Default
                    if d.HitDirection then
                        npc.Velocity = d.HitDirection:Resized(mod.FriendBalancing.SFFireballBirthrightPower)
                        d.fireballDirection = npc.Velocity
                    else
                        npc.Velocity = npc.Velocity:Resized(mod.FriendBalancing.SFFireballBirthrightPower)
                        d.fireballDirection = npc.Velocity
                    end
                    d.currentSpeed = mod.FriendBalancing.SFFireballBirthrightPower
                    d.timer = 2
                    d.warning = nil
                    d.SuperExplode = nil
                    d.HitDirection = nil
                    npc.StateFrame = npc.StateFrame // 2
                end
            end
        end
    elseif npc.StateFrame > (d.FireballLifespan) or npc:CollidesWithGrid() then
        local player = npc.Parent:ToPlayer()
        --[[
        local plurple = Color(0.5, 0.7, 1, 1, 0, 0, 0)
        plurple:SetColorize(0.85, 0.2, 0.75, 1)
        game:BombExplosionEffects(npc.Position, player.Damage*mod.FriendBalancing.SFDamageMult+player.Damage*mod.FriendBalancing.SFDamageFlat*level, 0, plurple, npc, mod.FriendBalancing.SFRadius, false, true, DamageFlag.DAMAGE_EXPLOSION | DamageFlag.DAMAGE_IGNORE_ARMOR)
        game:ShakeScreen(4)]]

        if d.IsBirthrightFireball and npc:CollidesWithGrid() then
            local projected = npc.Position + npc.Velocity:Resized(3)
            local grid = game:GetRoom():GetGridEntityFromPos(projected)
            if grid then
                local normal = (game:GetRoom():GetClampedPosition(projected, 1) - projected):Normalized()
                local closestSide = Vector.FromAngle(((normal:GetAngleDegrees() + 45) // 90) * 90):Rotated(180)
                d.fireballDirection = (d.fireballDirection - 2 * (d.fireballDirection:Dot(closestSide)) * closestSide):Resized(d.currentSpeed)
                npc.Velocity = d.fireballDirection
                npc.SpriteRotation = npc.Velocity:GetAngleDegrees()
            end
        else
            sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS, 0.6, 0, false, mod:RandomInt(110, 120, rng)/100)

            local fireplume = Isaac.Spawn(1000, EffectVariant.FIRE_JET, 1, npc.Position, Vector.Zero, player):ToEffect()
            local plumeDamage = player.Damage*mod.FriendBalancing.SFDamageMult+mod.FriendBalancing.SFDamageFlat*level
            if d.IsCarBatteryFireball then
                plumeDamage = plumeDamage / 2
            end
            fireplume.CollisionDamage = plumeDamage
            mod:LetSpawnFriendHearts(mod:GetEntityData(fireplume), d.FriendHealthChance)
            if mod.FriendBalancing.SearingShotCosmetics then
                if d.IsBirthrightFireball then
                    local plumeSprite = fireplume:GetSprite()
                    plumeSprite:ReplaceSpritesheet(0, "gfx/effects/fire_jet_friend_blue.png")
                    plumeSprite:LoadGraphics()
                end
            end
            npc:Remove()
        end
    end
end

function mod:FriendFireballCollide(npc, coll, first)
    local colliderIsOtherFireball = coll.Type == mod.FF.FriendFireball.ID and coll.Variant == mod.FF.FriendFireball.Var
    if coll.Type == EntityType.ENTITY_PLAYER or (coll:ToNPC() and coll:ToNPC():HasEntityFlags(EntityFlag.FLAG_FRIENDLY) or (coll:ToProjectile() and coll:ToProjectile():HasProjectileFlags(ProjectileFlags.HIT_ENEMIES))) then
        return true
    elseif colliderIsOtherFireball then
        return true
    elseif coll:ToNPC() then
        npc.StateFrame = mod:GetEntityData(npc).FireballLifespan
    end
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, function(_, e)
    if e.SubType == mod.FF.FriendFireball.Sub then
        local renderMode = game:GetRoom():GetRenderMode()
        if renderMode == RenderMode.RENDER_WATER_ABOVE then
            e.Color = Color(e.Color.R, e.Color.G, e.Color.B, 0, e.Color.RO, e.Color.GO, e.Color.BO)
        elseif e.Color.A == 0 then
            e.Color = Color(e.Color.R, e.Color.G, e.Color.B, 1, e.Color.RO, e.Color.GO, e.Color.BO)
        end
    end
end, mod.FF.FriendFireball.Var)

function mod:MakeFriendImmoralHeartExplosion(pos, player, crit, noDamageSource)
	local radius = crit and 1.0 or 0.69
	local damage = player.Damage
	if crit then
		damage = damage * mod.CritDamageMult
	end
	game:BombExplosionEffects(pos, damage, TearFlags.TEAR_NORMAL, FiendFolio.ColorDarkPurple, player, radius, true, not noDamageSource)
end

local swordsThatWereSwinging = {}
local swordsThatHaveProccedBone = {}
function mod:FriendApplyBoneEffect(entity, player, source, weaponFlag)
	if source.Type == EntityType.ENTITY_EFFECT then
		if source.Variant == EffectVariant.TECH_DOT then
			local child = source.Child
			if child then
				TearFlagsLib.SetTearFlagParams(child, mod.FriendBulletFlags.BONE, {NoRemove = false})
				TearFlagsLib.ClearTearFlags(child, mod.FriendBulletFlags.BONE)
			end
		elseif source.Variant == EffectVariant.BRIMSTONE_SWIRL then
			local child = source.Child or mod:GetEntityData(source).FriendSwirlLaser
			if child then
				TearFlagsLib.SetTearFlagParams(child, mod.FriendBulletFlags.BONE, {NoRemove = false})
				TearFlagsLib.ClearTearFlags(child, mod.FriendBulletFlags.BONE)
			end
		end
	elseif TearFlagsLib.IsEntitySpiritSword(source) then
		local sword = source:ToKnife()
		local ptrhash = GetPtrHash(sword)
		if sword:GetIsSwinging() then swordsThatWereSwinging[ptrhash] = true end
		swordsThatHaveProccedBone[ptrhash] = true
		return
	end

	TearFlagsLib.SetTearFlagParams(source, mod.FriendBulletFlags.BONE, {NoRemove = false})
	TearFlagsLib.ClearTearFlags(source, mod.FriendBulletFlags.BONE)
end
mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, mod.FriendApplyBoneEffect, mod.FriendBulletFlags.BONE)

local hasSpawnedMorbidChunk = {}
function mod:FriendApplyMorbidEffect(entity, player, source, weaponFlag)
	mod.scheduleForUpdate(function()
        if entity and entity:IsEnemy() and (entity:IsDead() or entity:HasMortalDamage()) and not (hasSpawnedMorbidChunk[GetPtrHash(entity)] or (entity.Type == mod.FFID.Tech and entity.Variant > 999)) then
            hasSpawnedMorbidChunk[GetPtrHash(entity)] = true
            mod:GetEntityData(player).ffsavedata.MorbidChunks = math.min(3, (mod:GetEntityData(player).ffsavedata.MorbidChunks or 0) + 1)
            player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS)
            player:EvaluateItems()
        end
    end, 2)
end
mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, mod.FriendApplyMorbidEffect, mod.FriendBulletFlags.MORBID)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	hasSpawnedMorbidChunk = {}
end)

function mod:FriendApplyRottenEffect(entity, player, source, weaponFlag)
	local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
    FiendFolio.AddFestering(entity, player, 90 * secondHandMultiplier + 1)
end
mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, mod.FriendApplyRottenEffect, mod.FriendBulletFlags.ROTTEN)

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, function(_, entity, amount, flags, source, cooldown, extraSource)
	if not entity:ToNPC() then return end

	local source = extraSource or source
	if source.Entity and TearFlagsLib.IsEntitySpiritSword(source.Entity) then
		source = EntityRef(source.Entity:ToKnife():GetHitboxParentKnife() or source.Entity)
	end

	local hitter = nil
	if source.Type == 0 and flags & DamageFlag.DAMAGE_LASER > 0 then
		local potential = mod.CheckingForDmg[#mod.CheckingForDmg]
		if potential and TearFlagsLib.IsEntityOcularRift(potential) then
			hitter = potential
		end
	elseif source.Type == 1 and source.Entity and mod:GetEntityData(source.Entity).MaliceDashing then
		hitter = mod:GetEntityData(source.Entity).MaliceProjectile
	elseif source.Type == 1000 and (source.Variant == EffectVariant.ROCKET or source.Variant == EffectVariant.SMALL_ROCKET) then
		if flags & DamageFlag.DAMAGE_EXPLOSION == 0 then return end
		hitter = source.Entity
	elseif source.Type == EntityType.ENTITY_BOMB then
		if flags & DamageFlag.DAMAGE_EXPLOSION == 0 then return end
		hitter = source.Entity
	elseif source.Type == 1 and TearFlagsLib.hemoptysisDummy then
		hitter = TearFlagsLib.hemoptysisDummy
	else
		hitter = source.Entity
	end

	if not hitter or not TearFlagsLib.HasTearFlags(hitter, mod.FriendBulletFlags.SOUL) then return end

	FiendFolio.AddSoulful(entity, TearFlagsLib.GetTearPlayer(hitter), 300, amount)
end)

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

function mod:getCapsuleCollisionPoint(sourceCapsule, colliderCapsule)
	local sourceStart, sourceEnd = sourceCapsule:GetVec2(), sourceCapsule:GetVec3()
	local colliderStart, colliderEnd = colliderCapsule:GetVec2(), colliderCapsule:GetVec3()
	local sourceRadius, sourcePointDist = sourceCapsule:GetF1(), sourceCapsule:GetF2()
	local colliderPointDist = colliderCapsule:GetF2()

	local sourceClosest, colliderClosest
	if sourcePointDist <= 0 and colliderPointDist <= 0 then
		sourceClosest = sourceStart
		colliderClosest = colliderStart
	elseif sourcePointDist == 0 then
		sourceClosest = sourceStart
		colliderClosest = getClosestPointOnLine(sourceStart, colliderStart, colliderEnd)
	elseif colliderPointDist == 0 then
		sourceClosest = getClosestPointOnLine(colliderStart, sourceStart, sourceEnd)
		colliderClosest = colliderStart
	else
		local sourceAngle, colliderAngle = (sourceEnd - sourceStart):GetAngleDegrees() % 180, (colliderEnd - colliderStart):GetAngleDegrees() % 180
		if sourceAngle ~= colliderAngle then
			-- https://www.pdas.com/lineint.html
			local x1, y1 = sourceStart.X, sourceStart.Y
			local x2, y2 = sourceEnd.X, sourceEnd.Y
			local x3, y3 = colliderStart.X, colliderStart.Y
			local x4, y4 = colliderEnd.X, colliderEnd.Y

			local a1 = y2 - y1
			local b1 = x1 - x2
			local c1 = x2 * y1 - x1 * y2

			local a2 = y4 - y3
			local b2 = x3 - x4
			local c2 = x4 * y3 - x3 * y4

			local denom = a1 * b2 - a2 * b1
			if denom ~= 0 then
				local intersectingPoint = Vector((b1 * c2 - b2 * c1) / denom, (a2 * c1 - a1 * c2) / denom)
				sourceClosest = getClosestPointOnLine(intersectingPoint, sourceStart, sourceEnd)
				colliderClosest = getClosestPointOnLine(intersectingPoint, colliderStart, colliderEnd)
				goto foundClosestPoints
			end
		end

		local middlePoint = (colliderCapsule:GetPosition() - sourceCapsule:GetPosition()) / 2 + sourceCapsule:GetPosition()
		sourceClosest = getClosestPointOnLine(middlePoint, sourceStart, sourceEnd)
		colliderClosest = getClosestPointOnLine(middlePoint, colliderStart, colliderEnd)
	end

	::foundClosestPoints::
	local dir = colliderClosest - sourceClosest
	return dir:Resized(math.min(sourceRadius, dir:Length())) + sourceClosest
end

function mod:getSwordCapsules(sword)
	local origHitboxCapsuleA, origHitboxCapsuleB = sword:GetNullCapsule("Hit"), sword:GetNullCapsule("Hit2")

	local hitboxCapsuleScale = 0.8
	local doScaling = true
    if sword:GetIsSwinging() then
		if not sword:GetIsSpinAttack() then
			doScaling = false
		end
		hitboxCapsuleScale = 1.8
    end

	local hitboxCapsuleA, hitboxCapsuleB = origHitboxCapsuleA, origHitboxCapsuleB
	if doScaling then
		local distA = (origHitboxCapsuleA:GetF1() + origHitboxCapsuleA:GetF2()) * hitboxCapsuleScale - origHitboxCapsuleA:GetF1()
		local distB = (origHitboxCapsuleB:GetF1() + origHitboxCapsuleB:GetF2()) * hitboxCapsuleScale - origHitboxCapsuleB:GetF1()
		local startPointA = origHitboxCapsuleA:GetPosition() - origHitboxCapsuleA:GetDirection() * distA
		local endPointA = origHitboxCapsuleA:GetPosition() + origHitboxCapsuleA:GetDirection() * distA
		local startPointB = origHitboxCapsuleB:GetPosition() - origHitboxCapsuleB:GetDirection() * distB
		local endPointB = origHitboxCapsuleB:GetPosition() + origHitboxCapsuleB:GetDirection() * distB

		hitboxCapsuleA = Capsule(startPointA, endPointA, origHitboxCapsuleA:GetF1())
		hitboxCapsuleB = Capsule(startPointB, endPointB, origHitboxCapsuleB:GetF1())
	end

	return hitboxCapsuleA, hitboxCapsuleB
end

function mod:getSwordCollidePos(sword, entity)
	local hitboxCapsuleA, hitboxCapsuleB = mod:getSwordCapsules(sword)
	local entityCapsule = entity:GetCollisionCapsule()

	local pos = Vector(0,0)
	if not (hitboxCapsuleA:GetF1() > 0 and hitboxCapsuleA:Collide(entityCapsule, pos)) then
		if not (hitboxCapsuleB:GetF1() > 0 and hitboxCapsuleB:Collide(entityCapsule, pos)) then
			if hitboxCapsuleA:GetF1() > 0 and hitboxCapsuleB:GetF1() > 0 then
				return
			else
				-- turns out there's a thing in the basegame where if one of the two null hitboxes has a radius of 0 then
				-- the damage check craps out on the hitbox check and instead it depends purely on the queried radius
				-- not sure if it's a bug or intended honestly but doesn't really matter either way

				local queryPos, queryRadius
				if hitboxCapsuleB:GetF1() <= 0 then
					queryPos = hitboxCapsuleA:GetPosition()
					queryRadius = hitboxCapsuleA:GetF1() + hitboxCapsuleA:GetF2()
				else
					local hitboxCapsuleDist = hitboxCapsuleA:GetPosition():Distance(hitboxCapsuleB:GetPosition())
					queryPos = hitboxCapsuleA:GetPosition()
					queryRadius = (hitboxCapsuleDist + hitboxCapsuleA:GetF1() + hitboxCapsuleA:GetF2() + hitboxCapsuleB:GetF1() + hitboxCapsuleB:GetF2()) * 0.5
					if 0.0 < hitboxCapsuleDist then
						local posOffsetFactor = queryRadius - (hitboxCapsuleA:GetF1() + hitboxCapsuleA:GetF2())
						queryPos = hitboxCapsuleA:GetPosition() + (posOffsetFactor * (hitboxCapsuleB:GetPosition() - hitboxCapsuleA:GetPosition())) / hitboxCapsuleDist
					end
				end
				local queryCapsule = Capsule(queryPos, queryPos, queryRadius)

				if not queryCapsule:Collide(entityCapsule, pos) then
					return
				else
					pos = mod:getCapsuleCollisionPoint(queryCapsule, entityCapsule)
				end
			end
		else
			pos = mod:getCapsuleCollisionPoint(hitboxCapsuleB, entityCapsule)
		end
	else
		pos = mod:getCapsuleCollisionPoint(hitboxCapsuleA, entityCapsule)
	end
	return pos
end

function mod:FriendApplyImmoralEffect(entity, player, source, weaponFlag, params, hitbox)
	if source.Type == EntityType.ENTITY_BOMB or
	   (source.Type == EntityType.ENTITY_EFFECT and source.Variant == EffectVariant.ROCKET) or
	   (source.Type == EntityType.ENTITY_EFFECT and source.Variant == EffectVariant.SMALL_ROCKET) or
	   (source.Type == EntityType.ENTITY_TEAR and source:ToTear():HasTearFlags(TearFlags.TEAR_EXPLOSIVE)) or
	   (source.Type == EntityType.ENTITY_LASER and source:ToLaser():HasTearFlags(TearFlags.TEAR_EXPLOSIVE)) or
	   (source.Type == EntityType.ENTITY_KNIFE and source:ToKnife():HasTearFlags(TearFlags.TEAR_EXPLOSIVE)) or
	   TearFlagsLib.HasCustomVanillaTearFlags(source, TearFlags.TEAR_EXPLOSIVE)
	then
		return
	end
	if weaponFlag == TearFlagsLib.WeaponFlag.FF_PLANET_X then
		local fdata = mod:GetEntityData(source)
		if fdata.HasHitThisRoll then
			return
		end
	end
	local shouldHitlist = source.Type == EntityType.ENTITY_LASER or
	                      (source.Type == EntityType.ENTITY_TEAR and source:ToTear():HasTearFlags(TearFlags.TEAR_LUDOVICO)) or
	                      (source.Type == EntityType.ENTITY_KNIFE and not TearFlagsLib.IsEntitySpiritSword(source)) or
	                      (source.Type == EntityType.ENTITY_EFFECT and (source.Variant == EffectVariant.BRIMSTONE_BALL or source.Variant == EffectVariant.TECH_DOT or source.Variant == EffectVariant.BRIMSTONE_SWIRL))
	if shouldHitlist then
		local data = mod:GetEntityData(source)
		data.FriendImmoralHitlist = data.FriendImmoralHitlist or {}
		if data.FriendImmoralHitlist[GetPtrHash(entity)] then
			return
		end
	end

	local pos = source.Position
	local nodamagesource = false
	if source.Type == EntityType.ENTITY_LASER then
		pos = movePosToClosestLaserSegment(entity.Position, source:ToLaser())
	end
	if weaponFlag == TearFlagsLib.WeaponFlag.CLUB and source.SubType == 4 then
		local capsulePosition, capsuleRadius = TearFlagsLib.GetSwingingKnifeCapsulePositionRadius(source)
		pos = (capsulePosition - entity.Position):Resized(entity.Size * math.max(entity.SizeMulti.X, entity.SizeMulti.Y)) + entity.Position
	end
	if weaponFlag == TearFlagsLib.WeaponFlag.SWORD then
		-- oh god here we go
		nodamagesource = true
		pos = mod:getSwordCollidePos((hitbox or source):ToKnife(), entity)
		if pos == nil then
			return
		end
	end
	if weaponFlag == TearFlagsLib.WeaponFlag.FF_PROVIDENCE_LASER then
		pos = entity.Position
	end
	mod:MakeFriendImmoralHeartExplosion(pos, player, TearFlagsLib.HasTearFlags(source, mod.CritFlag), nodamagesource)

	if shouldHitlist then
		local data = mod:GetEntityData(source)
		data.FriendImmoralHitlist = data.FriendImmoralHitlist or {}
		local segments = (mod:isSegmented(entity) and not mod:isReducedSyncSegment(entity) and mod:getSegments(entity)) or
		                 (mod:isBasegameSegmented(entity) and not mod:isBasegameReducedSyncSegment(entity) and mod:getBasegameSegments(entity)) or
		                 {entity}
		for _, segment in ipairs(segments) do
			data.FriendImmoralHitlist[GetPtrHash(segment)] = true
		end
	end
end
mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, mod.FriendApplyImmoralEffect, mod.FriendBulletFlags.IMMORAL)

if REPENTOGON.MeetsVersion("1.1.2") then
function mod:ImmoralBoostBombDamage(pos, damage, radius, linecheck, source, tearflags, damageflags, damagesource)
	if source and TearFlagsLib.HasTearFlags(source, mod.FriendBulletFlags.IMMORAL) then
		local player = TearFlagsLib.GetTearFlagParams(source, mod.FriendBulletFlags.IMMORAL).Player
		if player then
			return {Damage = damage + player.Damage}
		end
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_BOMB_DAMAGE, CallbackPriority.LATE, mod.ImmoralBoostBombDamage)
end

function mod:FriendEntityTakeDmg(ent, d, damage, flag, source, sourceData, spawner, spawnerData)
    if sourceData.FriendHealthBullet or (spawner and spawnerData.FriendHealthBullet) then
        local chance
        if sourceData.FriendHealthBullet then
            chance = sourceData.FriendHealthChance or 50
        elseif spawner and spawnerData.FriendHealthBullet then
            chance = spawnerData.FriendHealthChance or 50
        end
        local anyBriend = PlayerManager.AnyoneIsPlayerType(mod.PLAYER.BRIEND)
        local dropRng = ent:GetDropRNG()
        if dropRng:RandomInt(100) < chance then
            mod.scheduleForUpdate(function()
                if ent and ent:Exists() and ent:IsEnemy() and ent:IsDead() and not (d.FriendBulletHealth or (ent.Type == mod.FFID.Tech and ent.Variant > 999)) then
                    d.FriendBulletHealth = true
                    local subt = HeartSubType.HEART_HALF
                    if anyBriend and dropRng:RandomFloat() < mod.BriendBalancing.SoulHeartChance then
                        subt = HeartSubType.HEART_HALF_SOUL
                        if not Isaac.GetPersistentGameData():Unlocked(Achievement.EVERYTHING_IS_TERRIBLE) then
                            subt = HeartSubType.HEART_SOUL
                        end
                    end
                    local heart = Isaac.Spawn(5, PickupVariant.PICKUP_HEART, subt, ent.Position, Vector.Zero, ent):ToPickup()
                    heart.Timeout = mod.FriendBalancing.HeartTimeout
                end
            end, 2)
        end
    end
    mod:NineVoltBulletDeath(ent, source, sourceData, spawner, spawnerData)

    local player = source:ToPlayer() or (spawner and spawner:ToPlayer())
    if player and ent:IsVulnerableEnemy() then
        player = player:GetMainTwin()
        local level = game:GetLevel():GetAbsoluteStage()

        for i=0,2 do
            local active = player:GetActiveItem(i)

            if active == mod.ITEM.COLLECTIBLE.HOT_SHOT then
                local max = mod.FriendBalancing.ActiveCharge*2
                local newCharge = 100*damage
                local fireballMult = 1
                if source.Type == mod.FF.FriendFireball.ID and source.Variant == mod.FF.FriendFireball.Var then
                    fireballMult = mod.FriendBalancing.SFFireballCharge
                end
                newCharge = fireballMult*newCharge/(mod.FriendBalancing.SFChargeRatio*math.ceil(level/2))
                local completedGain = math.min(ent.HitPoints, newCharge)
                player:AddActiveCharge(math.ceil(completedGain), i, false, true, true)

            elseif active == mod.ITEM.COLLECTIBLE.GUNSLINGERS_GRIT then
                local pData = mod:GetEntityData(player)
                if pData.BriendGritBoost then
                    return
                end

                local max = mod.BriendBalancing.ActiveCharge*2
                local newCharge = 100*damage
                newCharge = newCharge/(mod.BriendBalancing.ChargeRatio*math.ceil(level/2))
                local completedGain = math.min(ent.HitPoints, newCharge)

                local shouldOvercharge = player:GetPlayerType() == mod.PLAYER.BRIEND
                player:AddActiveCharge(math.ceil(completedGain), i, false, shouldOvercharge, true)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, item, rng, player, useflags, activeslot)
    if mod:IsAnyFriend(player) then
        local playersToCheck = {player}
        if player:GetPlayerType() == mod.PLAYER.BRIEND then
            table.insert(playersToCheck, player:GetOtherTwin())
        end

        for _, player in ipairs(playersToCheck) do
            local pData = mod:GetEntityData(player)
            if pData.FriendHeldGuns then
                for _, gunInfo in pairs(pData.FriendHeldGuns) do
                    local gun = gunInfo.Gun
                    if gun and gun:Exists() then
                        gun:Remove()
                    end
                end
            end
        end
    end
end, CollectibleType.COLLECTIBLE_ESAU_JR)

function mod:ReplaceFriendGun(gun, player, id, force)
    if gun.SubType == id and not force then return end

    local newGunInfo = mod.FriendGunInfo[id]

    if not newGunInfo then return end

    local sprite = gun:GetSprite()

    if newGunInfo.ReplaceAnim then
        sprite:Load(newGunInfo.ReplaceAnim, true)
    elseif newGunInfo.ReplaceSprite then
        if newGunInfo.SpriteType == "Shoot" then
            if sprite:GetAnimation() ~= "gfx/effects/guns/guntype_shoot.anm2" then
                sprite:Load("gfx/effects/guns/guntype_shoot.anm2", true)
            end
        elseif newGunInfo.SpriteType == "Nothing" then
            if sprite:GetAnimation() ~= "gfx/effects/guns/guntype_nothing.anm2" then
                sprite:Load("gfx/effects/guns/guntype_nothing.anm2", true)
            end
        elseif newGunInfo.SpriteType == "Bolt" then
            if sprite:GetAnimation() ~= "gfx/effects/guns/guntype_bolt.anm2" then
                sprite:Load("gfx/effects/guns/guntype_bolt.anm2", true)
            end
        else
            if sprite:GetAnimation() ~= "gfx/effects/guns/guntype_default.anm2" then
                sprite:Load("gfx/effects/guns/guntype_default.anm2", true)
            end
        end
        sprite:ReplaceSpritesheet(0, newGunInfo.ReplaceSprite)
        sprite:LoadGraphics()
    elseif id == mod.FF.FriendsRevolver.Sub then
        if sprite:GetAnimation() ~= "gfx/effects/guns/guntype_default.anm2" then
            sprite:Load("gfx/effects/guns/guntype_default.anm2", true)
        else
            sprite:Reload()
        end
    end

	if newGunInfo.GoldenSprite and mod:GetEntityData(gun).IsBriendDeagle then
        sprite:ReplaceSpritesheet(0, newGunInfo.GoldenSprite)
		if id == CollectibleType.COLLECTIBLE_TOUGH_LOVE then
			sprite:ReplaceSpritesheet(1, newGunInfo.GoldenSprite)
			sprite:ReplaceSpritesheet(2, newGunInfo.GoldenSprite)
			sprite:ReplaceSpritesheet(3, newGunInfo.GoldenSprite)
			sprite:ReplaceSpritesheet(4, newGunInfo.GoldenSprite)
		end
        sprite:LoadGraphics()
	end

    gun.SubType = id
end

-- Returns true if the player has the collectible for the gun info,
-- OR if they have the collectible effect if ActiveEffect is set for the gun info.
function mod:HasGunCollectible(player, id, currentGunInfo)
    -- Check if they have the collectible required for the gun
    -- If ActiveEffect, check only if they have the effect and not the collectible
    local hasCollectible
    if currentGunInfo.ActiveEffect then
        local effect = player:GetEffects()
        hasCollectible = effect:HasCollectibleEffect(id)
    else
        hasCollectible = player:HasCollectible(id)
    end

    return hasCollectible
end

-- Goes over the guns table and checks if the current gun should be replaced, either by a higher priority gun,
-- or because the player no longer has the corresponding item for the current gun.
function mod:CheckCurrentGunReplacement(player, gun, skipSound)
    local gun = gun or mod:GetEntityData(player).FriendsRevolver

    if not gun or not gun:Exists() then return end

	local data = mod:GetEntityData(gun)
    local isBriendTwin = mod:IsBriendTwin(player)
    local isFetusGun = data.OwnedByFetus
    local currentGun = gun.SubType

    local replaceCandidates = {}

    if isBriendTwin then
        table.insert(replaceCandidates, {
            ID = mod.SpecialFriendGunSubtypes.BRIEND_DEAGLE,
            Priority = mod.FriendGunInfo[mod.SpecialFriendGunSubtypes.BRIEND_DEAGLE].Priority,
            Order = 0,
        })
        data.IsBriendDeagle = true
    end

    if currentGun ~= mod.FF.FriendsRevolver.Sub and currentGun > 0 and (not mod.FriendGunInfo[currentGun] or not mod:HasGunCollectible(player, currentGun, mod.FriendGunInfo[currentGun])) then
        currentGun = mod.FF.FriendsRevolver.Sub

        if not isBriendTwin then
            table.insert(replaceCandidates, {
                ID = mod.FF.FriendsRevolver.Sub,
                Priority = mod.FriendGunInfo[mod.FF.FriendsRevolver.Sub].Priority,
                Order = 0,
            })
        end
    end

    local currentGunInfo = mod.FriendGunInfo[currentGun] or mod.FriendGunInfo[mod.FF.FriendsRevolver.Sub]

    for id, gunInfo in pairs(mod.FriendGunInfo) do
        local skip = isFetusGun and id == CollectibleType.COLLECTIBLE_MUTANT_SPIDER

        if not skip and gunInfo.Priority > currentGunInfo.Priority and mod:HasGunCollectible(player, id, currentGunInfo) then
            table.insert(replaceCandidates, {
                ID = id,
                Priority = gunInfo.Priority,
                Order = #replaceCandidates,
            })
        end
    end

    table.sort(replaceCandidates, function(a, b)
        if a.Priority == b.Priority then
            return a.Order < b.Order
        end
        return a.Priority > b.Priority
    end)

    for _, tab in ipairs(replaceCandidates) do
        if mod:CheckAgainstCurrentGun(player, tab.ID, true, gun, skipSound) then
            return
        end
    end
end

function mod:CheckAgainstCurrentGun(player, id, ignoreCurrent, gun, skipSound)
    local new = mod.FriendGunInfo[id]
    if (mod:IsAnyFriend(player)) and new ~= nil then
        local d = mod:GetEntityData(player)
        local gunToCheck = gun or d.FriendsRevolver
        if gunToCheck and gunToCheck:Exists() and gunToCheck.SubType ~= id then
            local current = mod.FriendGunInfo[gunToCheck.SubType]
            if (ignoreCurrent or new.Priority >= current.Priority) and not Isaac.RunCallbackWithParam("PRE_GUN_REPLACE", id, gunToCheck, player) then
                mod:ReplaceFriendGun(gunToCheck, player, id)
                mod:QueueFriendMultishotRefresh(player, d)
                if not skipSound then
                    mod:FriendPlaySound(id, "Equip", 1)
                end
                Isaac.RunCallbackWithParam("POST_GUN_REPLACE", id, gunToCheck, player)
                return true
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_ADDED, function(_, player, id, first, wispOrInnate)
    if mod.FriendGunInfo[id] and not mod.FriendGunInfo[id].ActiveEffect then
        mod:CheckAgainstCurrentGun(player, id)
    end
	mod:QueueFriendMultishotRefresh(player)
end)
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, function(_, player, id, removeFromForm, wispOrInnate)
	mod:QueueFriendMultishotRefresh(player)
end)

mod:AddCallback(ModCallbacks.MC_PRE_ROOM_EXIT, function()
	if game:GetRoom():HasCurseMist() and (PlayerManager.AnyoneIsPlayerType(mod.PLAYER.FRIEND) or PlayerManager.AnyoneIsPlayerType(mod.PLAYER.BRIEND)) then
		mod:AddOneTimeCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
			if not game:GetRoom():HasCurseMist() then
				for _, player in ipairs(PlayerManager.GetPlayers()) do
					if mod:IsAnyFriend(player) then
						mod:CheckCurrentGunReplacement(player, nil, true)
					end
				end
			end
		end)
	end
end)

-- Sulfur
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_ADD_EFFECT, function(_, player)
	mod:CheckAgainstCurrentGun(player, CollectibleType.COLLECTIBLE_BRIMSTONE)
end, itemConfig:GetCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE))

-- Berserk
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_ADD_EFFECT, function(_, player)
	mod:CheckAgainstCurrentGun(player, CollectibleType.COLLECTIBLE_BERSERK)
end, itemConfig:GetCollectible(CollectibleType.COLLECTIBLE_BERSERK))

local shootInputs = {
    ButtonAction.ACTION_SHOOTRIGHT, ButtonAction.ACTION_SHOOTUP, ButtonAction.ACTION_SHOOTLEFT, ButtonAction.ACTION_SHOOTDOWN
}

function mod:CheckForMouseGun(player, ci)
    local d = mod:GetEntityData(player)

    local isKeyboardPlayer = player.ControllerIndex == 0

    if isKeyboardPlayer and Input.IsMouseBtnPressed(Mouse.MOUSE_BUTTON_1) then
        d.LastFiredMouse = true
    end

    if isKeyboardPlayer
    and Options.MouseControl
    and Input.IsMouseBtnPressed(Mouse.MOUSE_BUTTON_2)
    and (not player:HasCurseMistEffect())
    then
        if player:GetPlayerType() == mod.PLAYER.FRIEND then

            -- allow mouse controls for daydream without activating friend fireball
            if d.DaydreamActivationTimer then
                d.DaydreamActivationTimer = 0
                d.UsedMouse2Fireball = true
            end

            if (not d.LastUsedFireball or player.FrameCount-d.LastUsedFireball > 5) and not d.UsedMouse2Fireball then
                d.LastUsedFireball = player.FrameCount
                d.UsedMouse2Fireball = true
                for i=0,2 do
                    local active = player:GetActiveItem(i)
                    local charge = player:GetActiveCharge(i)+player:GetBatteryCharge(i)
                    if active == mod.ITEM.COLLECTIBLE.HOT_SHOT and charge >= mod.FriendBalancing.ActiveCharge and d.FriendsRevolver then
                        local pos = mod:GetMousePosition(true)
                        local dir = pos - player.Position
                        if mod.MouseGunAiming == 0 and not player:HasCollectible(CollectibleType.COLLECTIBLE_ANALOG_STICK) and not player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then
                            dir = mod:SnapVector(dir, 90)
                        end
                        local gd = d.FriendsRevolver
                        local aim = (dir-Vector(0, (gd.ForceTearHeight or mod.FriendGunInfo[d.FriendsRevolver.SubType].TearHeight or mod.FriendBalancing.DefaultTearHeight))):Normalized()
                        mod:useFireballActive(player, aim, i)
                        break
                    end
                end
                if d.holdingFFItem and d.holdingFFItem == mod.ITEM.COLLECTIBLE.HOT_SHOT then
                    d.holdingFFItem = nil
                    d.holdingFFItemSlot = nil
                    d.HoldingFFItemBlankVisual = true
                    d.putFireballAway = true
                    player:AnimatePickup(Sprite(), false, "HideItem")
                    d.FriendFireballFrames = 1
                end
            end
        elseif (not d.LastUsedGunslingersGrit or player.FrameCount-d.LastUsedGunslingersGrit > 5) and not d.UsedMouse2GunslingersGrit and player:GetPlayerType() == mod.PLAYER.BRIEND and not mod:IsBriendTwin(player) then
            local activeCharge = player:GetActiveCharge(ActiveSlot.SLOT_POCKET) + player:GetBatteryCharge(ActiveSlot.SLOT_POCKET)
            if activeCharge >= mod.BriendBalancing.ActiveCharge then
                player:UseActiveItem(mod.ITEM.COLLECTIBLE.GUNSLINGERS_GRIT, nil, ActiveSlot.SLOT_POCKET)
                player:AddActiveCharge(-mod.BriendBalancing.ActiveCharge, ActiveSlot.SLOT_POCKET)
                d.UsedMouse2GunslingersGrit = true
                d.LastUsedGunslingersGrit = player.FrameCount
            end
        end
    elseif d.UsedMouse2Fireball then
        d.UsedMouse2Fireball = nil
    elseif d.UsedMouse2GunslingersGrit then
        d.UsedMouse2GunslingersGrit = nil
    end
    for _,inputs in ipairs(shootInputs) do
        if Input.IsActionPressed(inputs, ci) then
            d.LastFiredMouse = false
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, e)
    local sprite = e:GetSprite()
    if e.SubType == mod.FF.MuzzleFlash.Sub then
        sprite:Update()
        if sprite:IsFinished("Fire") then
            e:Remove()
        end
    elseif e.SubType == mod.FF.FriendCasing.Sub then --Some code taken from Erfly's bullet casing stuff
        local d = mod:GetEntityData(e)
        local rng = e:GetDropRNG()
        local s = e:GetSprite()

        if s:GetAnimation() == "None" then
            e:Remove()
            return
        end
        local room = game:GetRoom()
        local inDungeon = (room:GetType() == RoomType.ROOM_DUNGEON)
        if not d.init then
            if inDungeon then
                e.Velocity = Vector(e.Velocity.X, -15)
            else
                if not d.launchedEnemyInfo then
                    d.launchedEnemyInfo = {zVel = -4, landFunc = function()
                        sfx:Play(mod.Sounds.D2Toss,0.2,0,false, mod:RandomInt(95,115,rng))
                        d.launchedEnemyInfo = {zVel = -2, landFunc = function()
                            sfx:Play(mod.Sounds.D2Toss,0.12,0,false, mod:RandomInt(130,145,rng))
                            d.launchedEnemyInfo = {zVel = -0.5, landFunc = function()
                                sfx:Play(mod.Sounds.D2Toss,0.07,0,false, mod:RandomInt(160,170,rng))
                                d.FinishedBouncing = true
                            end}
                        end}
                    end}
                end
            end
            d.init = true
        end

        if inDungeon then
            e.Velocity = e.Velocity + Vector(0, 1.5)
            if not d.FinishedBouncing then
                local colliding = room:GetGridCollisionAtPos(e.Position) > 0
                if colliding and not d.stillColliding then
                    d.stillColliding = true
                    d.timesCollided = d.timesCollided or 0
                    d.timesCollided = d.timesCollided + 1
                    if d.timesCollided == 1 then
                        e.Velocity = Vector(e.Velocity.X, e.Velocity.Y * -0.75)
                        sfx:Play(mod.Sounds.D2Toss,0.2,0,false, mod:RandomInt(95,115,rng)/100)
                    elseif d.timesCollided == 2 then
                        e.Velocity = Vector(e.Velocity.X, e.Velocity.Y * -0.5)
                        sfx:Play(mod.Sounds.D2Toss,0.12,0,false, mod:RandomInt(130,145,rng)/100)
                    else
                        sfx:Play(mod.Sounds.D2Toss,0.07,0,false, mod:RandomInt(160,170,rng)/100)
                        d.FinishedBouncing = true
                        e.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
                    end
                else
                    --So it doesn't hit the same floor twice, but also doesn't get stuck in walls
                    if (not colliding) or (e.Velocity:Length() > 12) then
                        d.stillColliding = false
                    end
                end
                --Code to make sure it doesn't get caught on nothing (beast, error room holes)
                local RoomMax = math.min((room:GetGridHeight() * 50) - 25, 700)
                if e.Position.Y > RoomMax then
                    d.FinishedBouncing = true
                    e.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
                end
            end
        end

        if sprite.FlipX then
            e.SpriteRotation = e.SpriteRotation - e.Velocity.X * 5
        else
            e.SpriteRotation = e.SpriteRotation + e.Velocity.X * 5
        end
        e.Velocity = e.Velocity * 0.9

        if d.FinishedBouncing then
            e.Color = Color(e.Color.R, e.Color.G, e.Color.B, e.Color.A - 0.05, e.Color.RO, e.Color.GO, e.Color.BO)
            if e.Color.A <= 0 then
                e:Remove()
            end
        end
    end
end, mod.FF.MuzzleFlash.Var)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, function(_, e)
    local renderMode = game:GetRoom():GetRenderMode()
    if renderMode == RenderMode.RENDER_WATER_ABOVE then
        e.Color = Color(e.Color.R, e.Color.G, e.Color.B, 0, e.Color.RO, e.Color.GO, e.Color.BO)
    elseif e.Color.A == 0 then
        e.Color = Color(e.Color.R, e.Color.G, e.Color.B, 1, e.Color.RO, e.Color.GO, e.Color.BO)
    end
end, mod.FF.MuzzleFlash.Var)

mod:AddCallback("FF_PLAYER_HURT_SOUND", function()
    sfx:Play(mod.Sounds.FriendHurt, 0.8, 0, false, 1.0)
    return true
end, mod.PLAYER.FRIEND)

mod:AddCallback("FF_PLAYER_DEATH_SOUND", function()
    sfx:Play(mod.Sounds.FriendDies, 0.8, 0, false, 1.0)
    return true
end, mod.PLAYER.FRIEND)

local function reverseFallingSpeed(speed, accel)
    return (speed - 0.1 - accel) / 0.9
end

function mod:ApplyFriendTearShotEffects(tear, player, shot, crit, noRemove, reset)
    if Isaac.RunCallback("PRE_GUN_APPLY_SHOT_EFFECT", tear, player, shot, crit) then
        return
    end

    if reset then
		mod:ResetFriendShotEffects(tear)
    end

    local rng = tear:GetDropRNG()
    local td = mod:GetEntityData(tear)
	local isLudo = tear:HasTearFlags(TearFlags.TEAR_LUDOVICO)
    if (shot.OverlayKeys and shot.OverlayKeys["GOLDEN_HEART"] and shot.LastInHeart) or shot.ForceGold then
		TearFlagsLib.AddTearFlags(tear, mod.FriendBulletFlags.GOLD)
		TearFlagsLib.SetTearFlagParams(tear, mod.FriendBulletFlags.GOLD, {NoRemove = noRemove})
	end
    if shot.OverlayKeys and shot.OverlayKeys["ETERNAL_HEART"] and shot.LastInHeart and not TearFlagsLib.HasTearFlags(tear, mod.FriendBulletFlags.ETERNAL) then
		TearFlagsLib.AddTearFlags(tear, mod.FriendBulletFlags.ETERNAL)
		TearFlagsLib.SetTearFlagParams(tear, mod.FriendBulletFlags.ETERNAL, {NoRemove = noRemove})
		if not isLudo then
			if tear.WaitFrames > 0 then
				local mult = math.max(1.5, tear.ContinueVelocity:Length()-16) / tear.ContinueVelocity:Length()
				TearFlagsLib.SetTearFlagParams(tear, mod.FriendBulletFlags.ETERNAL, {FallSpeedMult = mult})
				tear.ContinueVelocity = tear.ContinueVelocity * mult
			else
				local mult = math.max(1.5, tear.Velocity:Length()-16) / tear.Velocity:Length()
				TearFlagsLib.SetTearFlagParams(tear, mod.FriendBulletFlags.ETERNAL, {FallSpeedMult = mult})
				tear.Velocity = tear.Velocity * mult
			end
		end
		if not td.EternalHalo then
			local halo = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HALLOWED_GROUND, 0, tear.Position, Vector.Zero, tear):ToEffect()
			halo:FollowParent(tear)
			halo.DepthOffset = -100
			halo.SpriteScale = halo.SpriteScale * tear.Scale / 1.1081267595291 * 0.5
			td.EternalHalo = halo
		end
    end
    if shot.OverlayKeys and shot.OverlayKeys["STEVEN_HEART"] then
		TearFlagsLib.AddTearFlags(tear, mod.FriendBulletFlags.STEVEN)
		TearFlagsLib.SetTearFlagParams(tear, mod.FriendBulletFlags.STEVEN, {NoRemove = noRemove})
		if tear.Variant == TearVariant.BOBS_HEAD or tear.Variant == TearVariant.KEY or tear.Variant == TearVariant.KEY_BLOOD then
			mod.scheduleForUpdate(function()
				tear:AddTearFlags(TearFlags.TEAR_HOMING)
			end, 1)
		else
			tear:AddTearFlags(TearFlags.TEAR_HOMING)
		end
    end
    if shot.HeartKey == "BONE_HEART" or shot.ContainerKey == "BONE_HEART" then
        TearFlagsLib.AddTearFlags(tear, mod.FriendBulletFlags.BONE)
		TearFlagsLib.SetTearFlagParams(tear, mod.FriendBulletFlags.BONE, {Player = player, NoRemove = noRemove})
    end
	if shot.HeartKey == "LEAKY_HEART" or shot.ContainerKey == "LEAKY_HEART" then
        TearFlagsLib.AddTearFlags(tear, mod.FriendBulletFlags.LEAKY)
		TearFlagsLib.SetTearFlagParams(tear, mod.FriendBulletFlags.LEAKY, {Player = player, NoRemove = noRemove})
    end

    if shot.HeartKey == "MORBID_HEART" then
        TearFlagsLib.AddTearFlags(tear, mod.FriendBulletFlags.MORBID)
		TearFlagsLib.SetTearFlagParams(tear, mod.FriendBulletFlags.MORBID, {Player = player, NoRemove = noRemove})
    end
    if shot.HeartKey == "ROTTEN_HEART" then
        TearFlagsLib.AddTearFlags(tear, mod.FriendBulletFlags.ROTTEN)
		TearFlagsLib.SetTearFlagParams(tear, mod.FriendBulletFlags.ROTTEN, {Player = player, NoRemove = noRemove})
    end
	if shot.HeartKey == "BLACK_HEART" and not TearFlagsLib.HasTearFlags(tear, mod.FriendBulletFlags.BLACK) then
        TearFlagsLib.AddTearFlags(tear, mod.FriendBulletFlags.BLACK)
		TearFlagsLib.SetTearFlagParams(tear, mod.FriendBulletFlags.BLACK, {NoRemove = noRemove})
		if not isLudo then
			if tear.Variant == TearVariant.BOBS_HEAD or tear.Variant == TearVariant.KEY or tear.Variant == TearVariant.KEY_BLOOD then
				mod.scheduleForUpdate(function()
					tear:AddTearFlags(TearFlags.TEAR_DECELERATE | TearFlags.TEAR_PIERCING)
                    tear.Velocity = tear.Velocity * 1.5
				end, 1)
			else
				tear:AddTearFlags(TearFlags.TEAR_DECELERATE | TearFlags.TEAR_PIERCING)
                tear.Velocity = tear.Velocity * 1.5
			end
			TearFlagsLib.SetTearFlagParams(tear, mod.FriendBulletFlags.BLACK, {LifeSpan = 10})
			tear.Scale = tear.Scale*1.5
			td.NoFallRotation = true
		end
	end
	if shot.HeartKey == "SOUL_HEART" then
		TearFlagsLib.AddTearFlags(tear, mod.FriendBulletFlags.SOUL)
		TearFlagsLib.SetTearFlagParams(tear, mod.FriendBulletFlags.SOUL, {Player = player, NoRemove = noRemove})
	end
	if shot.HeartKey == "IMMORAL_HEART" or shot.ForceImmoral then
		TearFlagsLib.AddTearFlags(tear, mod.FriendBulletFlags.IMMORAL)
		TearFlagsLib.SetTearFlagParams(tear, mod.FriendBulletFlags.IMMORAL, {Player = player, NoRemove = noRemove})
		mod:GetEntityData(tear).FriendImmoralHitlist = nil
	end
    if crit then
        TearFlagsLib.AddTearFlags(tear, mod.CritFlag)
		TearFlagsLib.SetTearFlagParams(tear, mod.CritFlag, {NoRemove = noRemove})
		mod:GetEntityData(tear).FFCritHitlist = nil
		if not td.critLightning or not td.critLightning:Exists() then
			sfx:Play(mod.Sounds.CritShoot, 0.3, 0, false, math.random(80,120)/100)
			local critLightning = Isaac.Spawn(1000, 1737, 1, tear.Position, Vector.Zero, tear):ToEffect()
			critLightning.Parent = tear
			critLightning.Color = Color(1,1,1,0,0,0,1)
			critLightning:Update()
			td.critLightning = critLightning
		end
    end
end

function mod:ApplyFriendTearColor(tear, tearcolor)
	local td = mod:GetEntityData(tear)
	local tearcolor = td.FriendOrigColor or tearcolor or tear.Color
	td.FriendOrigColor = tearcolor
	tear.Color = mod:GetFriendShotTearColor(tear, tearcolor)
end

function mod:ApplyFriendGenericShotEffects(ent, player, shot, crit, noRemove, reset)
    if Isaac.RunCallback("PRE_GUN_APPLY_SHOT_EFFECT", ent, player, shot, crit) then
        return
    end

    if reset then
		mod:ResetFriendShotEffects(ent)
    end

    local rng = ent:GetDropRNG()
    if (shot.OverlayKeys and shot.OverlayKeys["GOLDEN_HEART"] and shot.LastInHeart) or shot.ForceGold then
		TearFlagsLib.AddTearFlags(ent, mod.FriendBulletFlags.GOLD)
		TearFlagsLib.SetTearFlagParams(ent, mod.FriendBulletFlags.GOLD, {NoRemove = noRemove})
	end
    if shot.OverlayKeys and shot.OverlayKeys["ETERNAL_HEART"] and shot.LastInHeart then
		TearFlagsLib.AddTearFlags(ent, mod.FriendBulletFlags.ETERNAL)
		TearFlagsLib.SetTearFlagParams(ent, mod.FriendBulletFlags.ETERNAL, {NoRemove = noRemove})
    end
    if shot.OverlayKeys and shot.OverlayKeys["STEVEN_HEART"] then
		TearFlagsLib.AddTearFlags(ent, mod.FriendBulletFlags.STEVEN)
		TearFlagsLib.SetTearFlagParams(ent, mod.FriendBulletFlags.STEVEN, {NoRemove = noRemove})

		if ent.Type == EntityType.ENTITY_TEAR then
			ent:ToTear():AddTearFlags(TearFlags.TEAR_HOMING)
		elseif ent.Type == EntityType.ENTITY_BOMB then
			ent:ToBomb():AddTearFlags(TearFlags.TEAR_HOMING)
		elseif ent.Type == EntityType.ENTITY_LASER then
			local laser = ent:ToLaser()
			laser:AddTearFlags(TearFlags.TEAR_HOMING)
			if not isRingLaser(laser) then
				laser:SetHomingType(1125515264) -- ?????????
				laser:RecalculateSamplesNextUpdate()
			end
		elseif ent.Type == EntityType.ENTITY_KNIFE then
			ent:ToKnife():AddTearFlags(TearFlags.TEAR_HOMING)
		elseif ent.Type == EntityType.ENTITY_EFFECT and
		       (ent.Variant == EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL or ent.Variant == EffectVariant.CHAIN_LIGHTNING or ent.Variant == EffectVariant.BRIMSTONE_BALL or
		       ent.Variant == EffectVariant.BRIMSTONE_SWIRL or ent.Variant == EffectVariant.TECH_DOT)
		then
			ent:ToEffect():AddTearFlags(TearFlags.TEAR_HOMING)
		else
			TearFlagsLib.AddCustomVanillaTearFlags(ent, TearFlags.TEAR_HOMING)
		end
    end
    if shot.HeartKey == "BONE_HEART" or shot.ContainerKey == "BONE_HEART" then
        TearFlagsLib.AddTearFlags(ent, mod.FriendBulletFlags.BONE)
		TearFlagsLib.SetTearFlagParams(ent, mod.FriendBulletFlags.BONE, {NoRemove = noRemove, Player = player})
    end
	if shot.HeartKey == "LEAKY_HEART" or shot.ContainerKey == "LEAKY_HEART" then
        TearFlagsLib.AddTearFlags(ent, mod.FriendBulletFlags.LEAKY)
		TearFlagsLib.SetTearFlagParams(ent, mod.FriendBulletFlags.LEAKY, {NoRemove = noRemove, Player = player})
    end

    if shot.HeartKey == "MORBID_HEART" then
        TearFlagsLib.AddTearFlags(ent, mod.FriendBulletFlags.MORBID)
		TearFlagsLib.SetTearFlagParams(ent, mod.FriendBulletFlags.MORBID, {NoRemove = noRemove, Player = player})
    end
    if shot.HeartKey == "ROTTEN_HEART" then
        TearFlagsLib.AddTearFlags(ent, mod.FriendBulletFlags.ROTTEN)
		TearFlagsLib.SetTearFlagParams(ent, mod.FriendBulletFlags.ROTTEN, {NoRemove = noRemove, Player = player})
    end
	if shot.HeartKey == "BLACK_HEART" then
        TearFlagsLib.AddTearFlags(ent, mod.FriendBulletFlags.BLACK)
        TearFlagsLib.SetTearFlagParams(ent, mod.FriendBulletFlags.BLACK, {NoRemove = noRemove})
	end
	if shot.HeartKey == "SOUL_HEART" then
		TearFlagsLib.AddTearFlags(ent, mod.FriendBulletFlags.SOUL)
		TearFlagsLib.SetTearFlagParams(ent, mod.FriendBulletFlags.SOUL, {NoRemove = noRemove, Player = player})
	end
	if shot.HeartKey == "IMMORAL_HEART" or shot.ForceImmoral then
		TearFlagsLib.AddTearFlags(ent, mod.FriendBulletFlags.IMMORAL)
		TearFlagsLib.SetTearFlagParams(ent, mod.FriendBulletFlags.IMMORAL, {NoRemove = noRemove, Player = player})
		mod:GetEntityData(ent).FriendImmoralHitlist = nil
	end
    if crit then
        TearFlagsLib.AddTearFlags(ent, mod.CritFlag)
        TearFlagsLib.SetTearFlagParams(ent, mod.CritFlag, {NoRemove = noRemove})
		mod:GetEntityData(ent).FFCritHitlist = nil
    end
end

function mod.handleEternalBulletD3(entity)
	if entity.Type == EntityType.ENTITY_TEAR then
		local tear = entity:ToTear()
		if tear.WaitFrames > 0 then
			local mult = math.max(1.5, tear.ContinueVelocity:Length()-16) / tear.ContinueVelocity:Length()
			TearFlagsLib.SetTearFlagParams(tear, mod.FriendBulletFlags.ETERNAL, {FallSpeedMult = mult})
			tear.ContinueVelocity = tear.ContinueVelocity * mult
		else
			local mult = math.max(1.5, tear.Velocity:Length()-16) / tear.Velocity:Length()
			TearFlagsLib.SetTearFlagParams(tear, mod.FriendBulletFlags.ETERNAL, {FallSpeedMult = mult})
			tear.Velocity = tear.Velocity * mult
		end
	elseif entity.Type == EntityType.ENTITY_BOMB then
		local bomb = entity:ToBomb()
		bomb.Velocity = bomb.Velocity * 0.5
		bomb:SetExplosionCountdown(bomb:GetExplosionCountdown() * 5)
	end
end

function mod.handleBoneBulletD3(entity)
	TearFlagsLib.SetTearFlagParams(entity, TearFlagsLib.Flag.BULLET_BONE, {Player = TearFlagsLib.GetTearPlayer(entity)})
end

function mod.handleMorbidBulletD3(entity)
	TearFlagsLib.SetTearFlagParams(entity, TearFlagsLib.Flag.BULLET_MORBID, {Player = TearFlagsLib.GetTearPlayer(entity)})
end

function mod.handleBlackBulletD3(entity)
	if entity.Type == EntityType.ENTITY_TEAR then
		local tear = entity:ToTear()
		tear:AddTearFlags(TearFlags.TEAR_DECELERATE | TearFlags.TEAR_PIERCING)
        tear.Velocity = tear.Velocity * 1.5
		TearFlagsLib.SetTearFlagParams(tear, mod.FriendBulletFlags.BLACK, {LifeSpan = 10})
		mod:GetEntityData(tear).NoFallRotation = true
	elseif entity.Type == EntityType.ENTITY_BOMB then
		entity.Velocity = entity.Velocity:Resized(12):Rotated(mod:RandomFloat(-6, 6))
		if TearFlagsLib.HasTearFlags(entity, mod.FriendBulletFlags.GRENADE) then
			TearFlagsLib.SetTearFlagParams(entity, mod.FriendBulletFlags.GRENADE, {
				FlatStone = false,
				FallingSpeed = -5.6,
				FallingAcceleration = 0.33,
			})
		end
	end
end

function mod.handleLeakyBulletD3(entity)
	TearFlagsLib.SetTearFlagParams(entity, TearFlagsLib.Flag.BULLET_LEAKY, {Player = TearFlagsLib.GetTearPlayer(entity)})
end

function mod:HandleFriendTears(player, e, tear, shot, aim, held, params)
    local rng = e:GetDropRNG()
    local td = mod:GetEntityData(tear)
    local stopSound
    mod:TurnTearToFriendBullet(tear, e.SubType, player)
	TearFlagsLib.AddTearFlags(tear, mod.FriendBulletFlags.FRIEND)
	TearFlagsLib.SetTearFlagParams(tear, mod.FriendBulletFlags.FRIEND, {Shot = shot, Gun = e})
    if player:HasCollectible(CollectibleType.COLLECTIBLE_GUILLOTINE) and not mod:GetActiveScissorDecapHead(player) then
        tear.Position = mod:GetFriendGunShootPos(e, aim)
    end
    if not (tear:HasTearFlags(TearFlags.TEAR_HYDROBOUNCE) or tear:HasTearFlags(TearFlags.TEAR_LUDOVICO) or TearFlagsLib.HasTearFlags(tear, TearFlagsLib.Flag.STARDUST)) then
        tear.FallingSpeed = -0.1
        tear.FallingAcceleration = -0.05
	elseif tear:HasTearFlags(TearFlags.TEAR_HYDROBOUNCE) then
		tear.FallingSpeed = -22 -- This number I put in out of frustration actually works really well!
    end
	if not mod:ShouldRunSynergy(player, e, CollectibleType.COLLECTIBLE_MYSTERIOUS_LIQUID) then
		tear.Height = mod:GetEntityData(e).ForceTearHeight or (mod.FriendGunInfo[e.SubType].TearHeight or mod.FriendBalancing.DefaultTearHeight)
	end
    tear:SetInitSound(SoundEffect.SOUND_NULL)
    if not Isaac.RunCallbackWithParam("PRE_GUN_FIRE_SOUND", e.SubType, e, player, false) or stopSound then
        if player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_MEGA_MUSH) then
            mod:FriendPlaySound(e.SubType, "BulletMega", 1)
        else
            if mod:GetFriendWeaponType(player, e) == WeaponType.WEAPON_MONSTROS_LUNGS then
                mod:FriendPlaySound(e.SubType, "Bullet", 1)
            else
                local ammo = mod:GetFriendAmmo(e, true)
                local ammoLeft = #ammo
                local volshoot = math.min((ammoLeft * 0.5 + 0.1) ^ 0.1, 1)
                local volclick = (math.max(3 - ammoLeft, 0) * 0.20) ^ 0.4
                volclick = math.min(volclick , 1)

                mod:FriendPlaySound(e.SubType, "Bullet", volshoot)
                --sfx:Play(mod.Sounds.AmmoWarning, volclick, 0, false, mod:RandomFloat(0.85, 0.95))
                sfx:Play(mod.Sounds.AmmoWarning, volclick, 0, false, 1)
            end
        end
    end

    -- Set tear color assuming it has one
    local gunInfo = mod.FriendGunInfo[e.SubType]
    if gunInfo and gunInfo.DefaultBulletColor then
        tear.Color = gunInfo.DefaultBulletColor
    end

    -- Revert Tough Love teeth damage, since we do a custom effect.
    if params and params.TearVariant == TearVariant.TOOTH then
        tear.CollisionDamage = params.TearDamage / 3.2
    end

    td.preReloadBonusDamage = tear.CollisionDamage

    local flat, mult, crit = mod:GetFriendShotDamageBonus(e, player, shot)
    tear.CollisionDamage = (tear.CollisionDamage+ flat)*mult

	mod:ApplyFriendTearShotEffects(tear, player, shot, crit)
	mod:ApplyFriendTearColor(tear)

    td.BulletOriginalAim = aim
    Isaac.RunCallbackWithParam("POST_GUN_FIRE_TEAR", e.SubType, e, player, tear, held)
end

mod:AddPriorityCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, math.huge, function(_, entity, player, weaponFlag)
	if weaponFlag == TearFlagsLib.WeaponFlag.LASER or weaponFlag == TearFlagsLib.WeaponFlag.KNIFE or
	   weaponFlag == TearFlagsLib.WeaponFlag.DARK_ARTS or weaponFlag == TearFlagsLib.WeaponFlag.EPIC_FETUS or
	   weaponFlag == TearFlagsLib.WeaponFlag.LOCUST or weaponFlag == TearFlagsLib.WeaponFlag.UMBILICAL_WHIP or
	   weaponFlag == TearFlagsLib.WeaponFlag.BRIMSTONE_BALL or weaponFlag == TearFlagsLib.WeaponFlag.ANTI_GRAV_LASER or
	   weaponFlag == TearFlagsLib.WeaponFlag.OCULAR_RIFT or weaponFlag == TearFlagsLib.WeaponFlag.CLUB_EPIC_FETUS or
	   weaponFlag == TearFlagsLib.WeaponFlag.BOBS_ROTTEN_HEAD or weaponFlag == TearFlagsLib.WeaponFlag.SHARP_KEY or
	   weaponFlag == TearFlagsLib.WeaponFlag.HEMOPTYSIS
	then
		return
	end
	if TearFlagsLib.HasTearFlags(entity, mod.FriendBulletFlags.FETAL_FRIEND) or TearFlagsLib.HasTearFlags(entity, mod.FriendBulletFlags.AMMO_CLIP) then
		if weaponFlag == TearFlagsLib.WeaponFlag.AQUARIUS then
			local d = mod:GetEntityData(entity)
			local color = d.FriendOrigColor or d.FFAquariusTearColor or entity.Color
			d.FriendOrigColor = color
			d.FFAquariusTearColor = mod:GetFriendShotTearColor(entity, color)
		else
			mod:ApplyFriendTearColor(entity)
		end
	end
end)

mod:AddCallback(TearFlagsLib.Callback.POST_CLEAR_LUDOVICO_FLAGS, function(_, entity)
	mod:GetEntityData(entity).FriendOrigColor = nil
end)

mod:AddCallback(ModCallbacks.MC_PRE_EFFECT_UPDATE, function(_, e)
    e:SetPauseTime(0)
end, mod.FF.RocketteDragoonGun.Var)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, e)
    if e.SubType == mod.FF.RocketteDragoonGun.Sub then
        mod:RocketteDragoonGunUpdate(e)
    elseif e.SubType == mod.FF.RaildriverGun.Sub then
        mod:RaildriverGunUpdate(e)
    elseif e.SubType == mod.FF.GrandpasGatlingGun.Sub then
        mod:GatlingGunUpdate(e)
    elseif e.SubType == mod.FF.FriendUnlockGun.Sub then
        mod:FriendUnlockGunUpdate(e)
    end
end, mod.FF.RocketteDragoonGun.Var)

local updateFriendMultishot = false

function mod:QueueFriendMultishotRefresh(player, d)
	updateFriendMultishot = true
	(d or mod:GetEntityData(player)).FriendUpdateMultishotParams = true
end

function mod:FriendStartReloadMarkedSoy(gun, player)
	if mod.IsPlayerMarkedFiring(player) or mod.HasSoyOrAlmondMilk(player) then
		local pd = mod:GetEntityData(player)
		local gunInfo = pd.FriendHeldGuns[gun.InitSeed]
		if gunInfo and gunInfo.Ammo and #gunInfo.Ammo == 0 then
			pd.FriendMarkedSoyReloading = true
		end
	end
end
mod:AddCollectibleCallback(mod.CALLBACK.PRE_GUN_START_RELOAD, CollectibleType.COLLECTIBLE_MARKED, mod.FriendStartReloadMarkedSoy)
mod:AddCollectibleCallback(mod.CALLBACK.PRE_GUN_START_RELOAD, CollectibleType.COLLECTIBLE_SOY_MILK, mod.FriendStartReloadMarkedSoy)
mod:AddCollectibleCallback(mod.CALLBACK.PRE_GUN_START_RELOAD, CollectibleType.COLLECTIBLE_ALMOND_MILK, mod.FriendStartReloadMarkedSoy)

mod:AddCallback(mod.CALLBACK.PRE_GUN_FIRE, function (_, e, player, aim, shots, held)
    local pd = mod:GetEntityData(player)
    local gd = mod:GetEntityData(e)
    if gd.GunLimitedAmmo and gd.GunLimitedAmmo <= 0 then
        return true
    end
    if pd.FriendMarkedSoyReloading then
        return true
    end
end)

function mod:FriendMarkedSoyFinishReload(gun, player)
	mod:GetEntityData(player).FriendMarkedSoyReloading = nil
end
mod:AddCallback(mod.CALLBACK.POST_GUN_RELOAD, mod.FriendMarkedSoyFinishReload)
mod:AddCallback(mod.CALLBACK.GUN_HOLD_RELEASE, mod.FriendMarkedSoyFinishReload)

mod:AddCallback(mod.CALLBACK.POST_GUN_FIRE, function(_, e, player, aim, shots, held)
    local data = mod:GetEntityData(e)
    if data.isFriendsPrimaryGun then
        mod:QueueFriendMultishotRefresh(player, data)
        Isaac.RunCallbackWithParam("POST_PRIMARY_GUN_FIRE", e.SubType, e, player, aim, shots, held)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	if updateFriendMultishot then
		updateFriendMultishot = false
		for _, player in ipairs(PlayerManager.GetPlayers()) do
			if mod:IsAnyFriend(player) then
				local d = mod:GetEntityData(player)
				if d.FriendUpdateMultishotParams then
					d.FriendUpdateMultishotParams = nil
					mod:UpdateMultishotGuns(player, false)
				end
			end
		end
	end
end)

--friend stageapi portrait (hi ferrium!)
if StageAPI and StageAPI.Loaded then
    StageAPI.AddPlayerGraphicsInfo(FiendFolio.PLAYER.FRIEND, {
        Name = "gfx/ui/boss/playername_friend.png",
        Portrait = "gfx/ui/stage/playerportrait_friend.png",
        NoShake = true
    })
end

mod:AddCallback("POST_PRIMARY_GUN_FIRE", function(_, e, player, aim, shots, held)
    local data = mod:GetEntityData(player)
    if data.WizardTracker then
        data.WizardTracker = -data.WizardTracker
    end
end)

-- left and right eye stuff
mod:AddCallback("PRE_GUN_FIRE_LATE", function (_, e, player, aim, shots, held)
    local d = mod:GetEntityData(player)
    if d.FriendIsRightEye then
        d.FriendIsRightEye = false
    else
        d.FriendIsRightEye = true
    end
end)

mod:AddCallback("PRE_GUN_FIRE", function(_, e, player, aim, shots, held)
    local d = mod:GetEntityData(player)
    for _, collectible in ipairs(RemoveGunIfFriendHas) do
        if type(collectible) == "function" and collectible(player) then
            if d.FriendsRevolver and GetPtrHash(e) == GetPtrHash(d.FriendsRevolver) then
                return true
            end
        elseif type(collectible) == "number" and player:HasCollectible(collectible) then
            if d.FriendsRevolver and GetPtrHash(e) == GetPtrHash(d.FriendsRevolver) then
                return true
            end
        end
    end
end)

mod:AddCallback("POST_GUN_INIT", function(_, g, player)
    local p = player
    local d = mod:GetEntityData(p)
    for _, collectible in ipairs(RemoveGunIfFriendHas) do
        if type(collectible) == "function" and collectible(p) then
            if d.FriendsRevolver and GetPtrHash(g) == GetPtrHash(d.FriendsRevolver) then
                mod:GetEntityData(g).RevolverInvisible = true
                break
            end
        elseif type(collectible) == "number" and p:ToPlayer():HasCollectible(collectible) then
            if d.FriendsRevolver and GetPtrHash(g) == GetPtrHash(d.FriendsRevolver) then
                mod:GetEntityData(g).RevolverInvisible = true
                break
            end
        end
    end
end)

function mod:FireFriendBoneHeartBones(source, player, pos, dir, tearFallingSpeed, forceNum, velMult)
	sfx:Play(SoundEffect.SOUND_BONE_SNAP)
	local radial = not dir or dir:Length() == 0
	local numBones = forceNum or (radial and 8) or 4
    local minVelocity = 10
    local maxVelocity = 20
    local angleSpread = 25
	for i = 1, numBones do
		local vel = radial and RandomVector() or dir:Rotated(mod:RandomInt(-angleSpread, angleSpread))
		vel = vel:Resized(mod:RandomInt(minVelocity, maxVelocity)) * (velMult or 1)
		local newtear = TearFlagsLib.FireSplitTear(source, vel, player, {
			RemoveFlags = mod.FriendBoneBulletSplitDisallowedFlags.Vanilla,
			RemoveCustomFlags = mod.FriendBoneBulletSplitDisallowedFlags.Custom,

			PositionOverride = pos,
			DamageOverride = player.Damage, -- TODO: Decide how we want to handle the first bullet of a filled health bar dealing increased damage.
			ScaleMult = 0.75,
			TearVariant = TearVariant.BONE,
			SplitTearType = "FF_BULLET_BONE",
		})

        -- Set some properties for the split bone tear
		newtear.CanTriggerStreakEnd = false
		newtear.Mass = newtear.Mass * 0.5
		newtear.FallingSpeed = (tearFallingSpeed or 1) * 0.1

		if TearFlagsLib.HasTearFlags(newtear, mod.FriendBulletFlags.BONE) then
            TearFlagsLib.SetTearFlagParams(newtear, mod.FriendBulletFlags.BONE, {NoRemove = false})
			TearFlagsLib.ClearTearFlags(newtear, mod.FriendBulletFlags.BONE)
		end

		if source.Type == EntityType.ENTITY_FAMILIAR and source.Variant == mod.ITEM.FAMILIAR.PLANET_X then
			TearFlagsLib.GetCustomVanillaTearFlagParams(newtear).ScaleOverride = nil
			newtear.Scale = TearFlagsLib.GetCustomVanillaTearFlagParams(source).ScaleOverride * 0.75
		end

        -- Add the tear flags
        newtear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
        TearFlagsLib.AddTearFlags(newtear, mod.FriendBulletFlags.NO_FALL_TEAR | mod.FriendBulletFlags.FORCE_DIE_ON_WALLS)
        TearFlagsLib.SetTearFlagParams(newtear, mod.FriendBulletFlags.FORCE_DIE_ON_WALLS, {
            NoCollideTime = vel:Length() // 2 -- Cooldown before it starts dying on walls
        })
		newtear:ResetSpriteScale()
	end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, entity)
	local data = mod:GetEntityData(entity)
	if TearFlagsLib.HasTearFlags(entity, mod.FriendBulletFlags.BONE) then
		local player = TearFlagsLib.GetTearFlagParams(entity, mod.FriendBulletFlags.BONE).Player
		if player then
			local dir = -entity.Velocity
			if dir:Length() == 0 then
				dir = RandomVector()
			end
			local pos = entity.Position + dir:Resized(30)
			mod:FireFriendBoneHeartBones(entity:ToTear(), player, pos, dir, entity:ToTear().FallingSpeed)
		end
	end
end, EntityType.ENTITY_TEAR)

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, entity)
	if TearFlagsLib.HasTearFlags(entity, mod.FriendBulletFlags.BONE) then
		local player = TearFlagsLib.GetTearFlagParams(entity, mod.FriendBulletFlags.BONE).Player
		if player then
			mod:FireFriendBoneHeartBones(entity:ToLaser(), player, entity.Position, -entity.Velocity)
		end
	end
end, EntityType.ENTITY_LASER)

local antiRecursion = false
mod:AddCallback(ModCallbacks.MC_POST_BOMB_TEARFLAG_EFFECTS, function(_, pos, radius, tearflags, source, radiusMult)
	if antiRecursion then return end

	if source then
		if TearFlagsLib.HasTearFlags(source, mod.FriendBulletFlags.BONE) then
			local data = mod:GetEntityData(source)
			if not data.FriendBoneBombed then
				local player = TearFlagsLib.GetTearFlagParams(source, mod.FriendBulletFlags.BONE).Player
				if player then
					local pos = source.Position
					local dir = nil
					if source.Variant == BombVariant.BOMB_ROCKET or source.Variant == BombVariant.BOMB_ROCKET_GIGA then
						dir = source.Velocity
						pos = pos + dir:Resized(30)
					end
					mod:FireFriendBoneHeartBones(source, player, pos, dir)
					data.FriendBoneBombed = true
				end
			end
		end
	end
end, EntityType.ENTITY_BOMB)

mod:AddCallback(ModCallbacks.MC_POST_BOMB_TEARFLAG_EFFECTS, function(_, pos, radius, tearflags, source, radiusMult)
	if antiRecursion then return end

	if source and (source.Variant == EffectVariant.ROCKET or source.Variant == EffectVariant.SMALL_ROCKET) then
		if TearFlagsLib.HasTearFlags(source, mod.FriendBulletFlags.BONE) then
			local data = mod:GetEntityData(source)
			if not data.FriendBoneBombed then
				local player = TearFlagsLib.GetTearFlagParams(source, mod.FriendBulletFlags.BONE).Player
				if player then
					mod:FireFriendBoneHeartBones(source, player, source.Position, nil)
					data.FriendBoneBombed = true
				end
			end
		end
	end
end, EntityType.ENTITY_EFFECT)

mod:AddCallback(ModCallbacks.MC_POST_FIRE_SPLIT_TEAR, function(_, tear, source, splitType)
    TearFlagsLib.ClearTearFlags(tear, mod.FriendBulletFlags.BONE)
end)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	-- failsafe
	antiRecursion = false
end)

local function reverseFallingSpeed(speed, accel)
  -- Reverses the falling speed based upon a given falling acceleration

  return (speed - 0.1 - accel) / 0.9
end

function mod:UpdateFriendEternalHeartHalo(ent)
	local d = mod:GetEntityData(ent)
	if TearFlagsLib.HasTearFlags(ent, mod.FriendBulletFlags.ETERNAL) then
		local typ = ent.Type
		if not (d.EternalHalo and d.EternalHalo:Exists()) and
		   (typ == EntityType.ENTITY_TEAR or
		   typ == EntityType.ENTITY_BOMB or
		   (typ == EntityType.ENTITY_LASER and isRingLaser(ent)) or
		   (typ == EntityType.ENTITY_KNIFE and not (TearFlagsLib.IsKnifeSwingable(ent) or TearFlagsLib.IsEntitySpiritSword(ent)) and ent:ToKnife():HasTearFlags(TearFlags.TEAR_LUDOVICO)))
		then
			local halo = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HALLOWED_GROUND, 0, ent.Position, Vector.Zero, ent):ToEffect()
            halo:FollowParent(ent)
            halo.DepthOffset = -100
			d.EternalHalo = halo
		end
		if d.EternalHalo then
			local scale
			if typ == EntityType.ENTITY_TEAR then
				scale = ent:ToTear().Scale / 1.1081267595291 * 0.5
			elseif typ == EntityType.ENTITY_BOMB then
				scale = ent:ToBomb():GetScale()
			elseif typ == EntityType.ENTITY_LASER then
				scale = mod:GetTechXRadius(ent:ToLaser()) / 80
			elseif typ == EntityType.ENTITY_KNIFE then
				scale = 1
			else
				return
			end
			d.EternalHalo.SpriteScale = Vector.One * scale
			local range = 80 * scale
			for i=0, game:GetNumPlayers()-1 do
				local player = game:GetPlayer(i)
				if player and player:Exists() and player.Position:Distance(ent.Position) <= range then
					player = player:ToPlayer()
					player:SetHallowedGroundCountdown(2)
					player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_TEARFLAG | CacheFlag.CACHE_TEARCOLOR)
					player:EvaluateItems()
				end
			end
		end
		if typ == EntityType.ENTITY_TEAR and not ent:IsDead() and not (TearFlagsLib.HasTearFlags(ent, mod.FriendBulletFlags.FRIEND) or TearFlagsLib.HasTearFlags(ent, mod.FriendBulletFlags.AMMO_CLIP)) then
			local mult = TearFlagsLib.GetTearFlagParams(ent, mod.FriendBulletFlags.ETERNAL).FallSpeedMult
			if mult then
				local tear = ent:ToTear()
				local flags = tear.TearFlags
				if flags & (TearFlags.TEAR_POP | TearFlags.TEAR_ABSORB | TearFlags.TEAR_LUDOVICO) == TearFlags.TEAR_NORMAL and tear.WaitFrames <= 0 then
					tear.Height = tear.Height - tear.FallingSpeed
					local currFallSpeed = tear.FallingSpeed
					local prevFallSpeed = reverseFallingSpeed(tear.FallingSpeed, tear.FallingAcceleration)
					tear.FallingSpeed = (currFallSpeed - prevFallSpeed) * mult + prevFallSpeed
					tear.Height = tear.Height + tear.FallingSpeed * mult
					d.FriendEternalIntendedFallingSpeed = tear.FallingSpeed
					tear.FallingSpeed = tear.FallingSpeed * mult
				end
			end
		end
	elseif d.EternalHalo then
		if d.EternalHalo:Exists() then
			d.EternalHalo:Remove()
		end
		d.EternalHalo = nil
	end
end
mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, mod.UpdateFriendEternalHeartHalo)
mod:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, mod.UpdateFriendEternalHeartHalo)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_TEAR_UPDATE, -1 * math.huge, function(_, tear)
	local data = mod:GetEntityData(tear)
	if data.FriendEternalIntendedFallingSpeed then
		tear.FallingSpeed = data.FriendEternalIntendedFallingSpeed
		data.FriendEternalIntendedFallingSpeed = nil
	end
end)

function mod:UpdateLeakyEffect(ent)
	if TearFlagsLib.HasTearFlags(ent, mod.FriendBulletFlags.LEAKY) then
		local typ = ent.Type
		if ent.Type == EntityType.ENTITY_KNIFE then
			local knife = ent:ToKnife()
			if knife:IsFlying() and Isaac.GetFrameCount() % 2 == 0 then
				local player = TearFlagsLib.GetTearFlagParams(ent, mod.FriendBulletFlags.LEAKY).Player
				if player and math.random() <= 0.5 * (1 - math.min(0.33, (math.abs(knife:GetKnifeVelocity()) / 12) ^ 4)) then
					local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, ent.Position, Vector.Zero, player):ToEffect()
					local creepScale = math.random() * 0.5 + 0.2
					creep.SpriteScale = Vector(creepScale, creepScale)
					creep:Update()
				end
			end
		else
			local player = TearFlagsLib.GetTearFlagParams(ent, mod.FriendBulletFlags.LEAKY).Player
			if player and math.random() <= 0.33 then
				local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, ent.Position + ((ent.Type == EntityType.ENTITY_EFFECT and ent.Variant == EffectVariant.BRIMSTONE_SWIRL and Vector(ent.PositionOffset.X, 0)) or Vector.Zero), Vector.Zero, player):ToEffect()
				local creepScale = math.random() * 0.5 + 0.2
				creep.SpriteScale = Vector(creepScale, creepScale)
				creep:Update()
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, mod.UpdateLeakyEffect)
mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, mod.UpdateLeakyEffect)
mod:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, mod.UpdateLeakyEffect)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.UpdateLeakyEffect, EffectVariant.SMALL_ROCKET)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.UpdateLeakyEffect, EffectVariant.TECH_DOT)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.UpdateLeakyEffect, EffectVariant.BRIMSTONE_SWIRL)

function mod:UpdateFriendLaserSampleEffects(laser)
	local hasLeaky = TearFlagsLib.HasTearFlags(laser, mod.FriendBulletFlags.LEAKY)
	local hasGold = TearFlagsLib.HasTearFlags(laser, mod.FriendBulletFlags.GOLD)

	local data = mod:GetEntityData(laser)
	if (hasLeaky and not data.DidLeakyOneShot) or hasGold then
		local leakyPlayer = TearFlagsLib.GetTearFlagParams(laser, mod.FriendBulletFlags.LEAKY).Player

		local samples = TearFlagsLib.GetLaserSampleCapsules(laser)
		local distToUse = 0
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
					if hasLeaky and leakyPlayer and not data.DidLeakyOneShot and math.random() <= ((laser.OneHit and 0.33) or (isRingLaser(laser) and 0.05) or 0.1) then
						local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, locus1 + (locus2 - locus1):Resized(usedDist), Vector.Zero, leakyPlayer):ToEffect()
						local creepScale = math.random() * 0.5 + 0.2
						creep.SpriteScale = Vector(creepScale, creepScale)
						creep:Update()
					end
					if hasGold and (laser.FrameCount == 2 or laser.FrameCount % 6 == 1) and math.random() < 1/3 then
						local rng = laser:GetDropRNG()
						local sparkle = Isaac.Spawn(1000, 1727, 0, locus1 + (locus2 - locus1):Resized(usedDist) + mod:shuntedPosition(10, rng), Vector.Zero, laser):ToEffect()
						sparkle.SpriteOffset = Isaac.WorldToScreenDistance(Vector(0, laser.PositionOffset.Y))
						sparkle.SpriteScale = Vector(0.8, 0.8)
						sparkle:SetColor(Color(1,1,1,1,1,1,0), 100, 1, false, false)
						sparkle:Update()
					end
					distToUse = distToUse + 20
				end
			end
			data.DidLeakyOneShot = hasLeaky and laser.OneHit
		end
	end

	if not hasLeaky then
		data.DidLeakyOneShot = nil
	end
end
mod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, mod.UpdateFriendLaserSampleEffects)

function mod:tryLeakySplat(ent, shouldReturn, forcePos)
	if TearFlagsLib.HasTearFlags(ent, mod.FriendBulletFlags.LEAKY) then
		local player = TearFlagsLib.GetTearFlagParams(ent, mod.FriendBulletFlags.LEAKY).Player
		if player then
			local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, forcePos or ent.Position, Vector.Zero, player):ToEffect()
			local creepScale = math.random() * 0.5 + 0.2
			creep.SpriteScale = Vector(creepScale, creepScale)
			creep:Update()
			return shouldReturn
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_TEAR_DEATH, mod.tryLeakySplat)

function mod:ThrowFriendKnife(knife)
	-- i need this to be done in pre update the exact frame it is thrown
	if TearFlagsLib.WasEntityFiredByPlayerMimic(knife) then
		local data = mod:GetEntityData(knife)
		local isFlying = knife:IsFlying()

		if isFlying then
			local isReturning = data.fetalFriendLastFrameDistance and data.fetalFriendLastFrameDistance > knife.Position:Distance(knife.SpawnerEntity.Position)

			if not data.fetalFriendLastFrameWasFlying then
				if not (TearFlagsLib.IsKnifeSwingable(knife) or TearFlagsLib.IsEntitySpiritSword(knife)) then
					mod:dichromaticFlagKnife(knife, TearFlagsLib.GetTearPlayer(knife))
					mod:galliumFlagKnife(knife, TearFlagsLib.GetTearPlayer(knife))
					mod:spinachFlagKnife(knife, TearFlagsLib.GetTearPlayer(knife))

					mod:ResetFriendShotEffects(knife)
					mod:ApplyFetalFriendToKnife(knife)
				end
				if REPENTOGON.MeetsVersion("1.1.2") and knife.SubType == KnifeSubType.DEFAULT and
				   not TearFlagsLib.IsEntitySpiritSword(knife) and TearFlagsLib.HasTearFlags(knife, mod.FriendBulletFlags.BLACK)
				then
					knife.MaxDistance = knife.MaxDistance * 0.5
					local distFactor = (knife:HasTearFlags(TearFlags.TEAR_ORBIT) and 1) or 2
					local var = knife.Variant
					if var == 1 or var == 2 or var == 3 or var == 4 or var == 8 or var == 9 then
						distFactor = distFactor * 0.75
					end
					if knife:HasTearFlags(TearFlags.TEAR_HYDROBOUNCE) then
						distFactor = distFactor * 0.75
					end
					local newVel = math.sqrt(knife.MaxDistance / (distFactor * 0.5)) * distFactor
					knife:SetKnifeVelocity(newVel)
				end
			end

			if isReturning and not data.fetalFriendLastFrameWasReturning then
				data.fetalFriendLastFrameWasReturning = true
			end

			data.fetalFriendLastFrameWasReturning = isReturning
		elseif data.fetalFriendLastFrameWasFlying then
			data.fetalFriendLastFrameWasReturning = false
		end

		data.fetalFriendLastFrameWasFlying = isFlying
		data.fetalFriendLastFrameDistance = knife.Position:Distance(knife.SpawnerEntity.Position)
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_KNIFE_UPDATE, -1 * math.huge, mod.ThrowFriendKnife)

function mod:CatchFriendKnife(knife, player)
	if TearFlagsLib.HasTearFlags(knife, mod.FriendBulletFlags.BONE) then
		local player = TearFlagsLib.GetTearFlagParams(knife, mod.FriendBulletFlags.BONE).Player
		if player then
			mod:FireFriendBoneHeartBones(knife, player, knife.Position, Vector.FromAngle(knife.Rotation))
		end
	end

	mod:ResetFriendShotEffects(knife)
	TearFlagsLib.SetTearFlagParams(knife, mod.FriendBulletFlags.FRIEND, {NoRemove = false})
	TearFlagsLib.ClearTearFlags(knife, mod.FriendBulletFlags.FRIEND)
	TearFlagsLib.SetTearFlagParams(knife, mod.FriendBulletFlags.FETAL_FRIEND, {NoRemove = false})
	TearFlagsLib.ClearTearFlags(knife, mod.FriendBulletFlags.FETAL_FRIEND)
	TearFlagsLib.SetTearFlagParams(knife, mod.FriendBulletFlags.AMMO_CLIP, {NoRemove = false})
	TearFlagsLib.ClearTearFlags(knife, mod.FriendBulletFlags.AMMO_CLIP)

	-- also putting this here
	TearFlagsLib.SetTearFlagParams(knife, TearFlagsLib.Flag.YIN_YANG, {NoRemove = false})
	TearFlagsLib.ClearTearFlags(knife, TearFlagsLib.Flag.YIN_YANG)
	TearFlagsLib.SetTearFlagParams(knife, TearFlagsLib.Flag.PRANK_COOKIE, {NoRemove = false})
	TearFlagsLib.ClearTearFlags(knife, TearFlagsLib.Flag.PRANK_COOKIE)
	TearFlagsLib.SetTearFlagParams(knife, TearFlagsLib.Flag.GALLIUM, {NoRemove = false})
	TearFlagsLib.ClearTearFlags(knife, TearFlagsLib.Flag.GALLIUM)
	TearFlagsLib.SetTearFlagParams(knife, TearFlagsLib.Flag.SPINACH, {NoRemove = false})
	TearFlagsLib.ClearTearFlags(knife, TearFlagsLib.Flag.SPINACH)
end
mod:AddCallback(TearFlagsLib.Callback.POST_CATCH_KNIFE, mod.CatchFriendKnife)
mod:AddCallback(TearFlagsLib.Callback.POST_CATCH_CLUB, mod.CatchFriendKnife)

function mod:ApplyFriendHomingToKnife(knife)
	if TearFlagsLib.IsEntitySpiritSword(knife) then return end
	if (TearFlagsLib.HasTearFlags(knife, mod.FriendBulletFlags.ETERNAL) and not knife:HasTearFlags(TearFlags.TEAR_LUDOVICO)) or
	   TearFlagsLib.HasTearFlags(knife, mod.FriendBulletFlags.STEVEN) or
	   TearFlagsLib.HasTearFlags(knife, TearFlagsLib.Flag.YIN_YANG)
	then
		knife:AddTearFlags(TearFlags.TEAR_HOMING)
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_KNIFE_UPDATE, mod.ApplyFriendHomingToKnife)

function mod:ApplyFriendHomingToBrimball(brimball)
	if TearFlagsLib.HasTearFlags(brimball, mod.FriendBulletFlags.ETERNAL) or
	   TearFlagsLib.HasTearFlags(brimball, mod.FriendBulletFlags.STEVEN) or
	   TearFlagsLib.HasTearFlags(brimball, TearFlagsLib.Flag.YIN_YANG)
	then
		brimball:AddTearFlags(TearFlags.TEAR_HOMING)
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_EFFECT_UPDATE, mod.ApplyFriendHomingToBrimball, EffectVariant.BRIMSTONE_BALL)

local updatingLaser = {}
mod:AddPriorityCallback(ModCallbacks.MC_PRE_LASER_UPDATE, math.huge, function(_, laser)
	table.insert(updatingLaser, laser)
end)

mod:AddPriorityCallback(ModCallbacks.MC_POST_LASER_UPDATE, -1 * math.huge, function(_, laser)
	for i = #updatingLaser, 1, -1 do
		local updater = updatingLaser[i]
		table.remove(updatingLaser, i)
		if GetPtrHash(updater) == GetPtrHash(laser) then
			return
		end
	end
end)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_EFFECT_UPDATE, math.huge, function(_, brimball)
	table.insert(updatingLaser, brimball)
end, EffectVariant.BRIMSTONE_BALL)

mod:AddPriorityCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, -1 * math.huge, function(_, brimball)
	for i = #updatingLaser, 1, -1 do
		local updater = updatingLaser[i]
		table.remove(updatingLaser, i)
		if GetPtrHash(updater) == GetPtrHash(brimball) then
			return
		end
	end
end, EffectVariant.BRIMSTONE_BALL)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	updatingLaser = {}
end)

mod:AddCallback(ModCallbacks.MC_EVALUATE_TEAR_HIT_PARAMS, function(_, player, tearparams, weapon, damagescale, displacement, source)
	if weapon == WeaponType.WEAPON_LASER and #updatingLaser > 0 then
		local laser = updatingLaser[#updatingLaser]
		if laser:Exists() and
		   ((laser.Type == EntityType.ENTITY_LASER and laser.SubType ~= LaserSubType.LASER_SUBTYPE_RING_PROJECTILE and TearFlagsLib.HasTearFlags(laser, mod.FriendBulletFlags.ETERNAL)) or
		    TearFlagsLib.HasTearFlags(laser, mod.FriendBulletFlags.STEVEN) or
		    TearFlagsLib.HasTearFlags(laser, TearFlagsLib.Flag.YIN_YANG))
		then
			tearparams.TearFlags = tearparams.TearFlags | TearFlags.TEAR_HOMING
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, function(_, knife)
    if not TearFlagsLib.IsEntitySpiritSword(knife) and TearFlagsLib.HasTearFlags(knife, mod.FriendBulletFlags.GOLD) then
        if knife.FrameCount % 6 == 0 and Isaac.GetFrameCount() % 2 == 0 then
			if TearFlagsLib.IsKnifeSwingableAndThrowable(knife) and knife.SubType ~= KnifeSubType.CLUB_HITBOX and not knife:IsFlying() then return end

			local rng = knife:GetDropRNG()
            local sparkle = Isaac.Spawn(1000, 1727, 0, knife.Position+mod:shuntedPosition(10, rng), Vector.Zero, knife):ToEffect()
            sparkle.SpriteOffset = Vector(0, -8)
            sparkle.SpriteScale = Vector(0.8, 0.8)
            sparkle:SetColor(Color(1,1,1,1,1,1,0), 100, 1, false, false)
            sparkle:Update()
        end
    end
end)

function mod:FriendClubHitboxInit(hitbox)
	if hitbox.FrameCount > 0 or not TearFlagsLib.CanClubVariantHaveTearEffects(hitbox.Variant) then return end

	mod:ApplyFetalFriendToClub(hitbox)

	if TearFlagsLib.HasTearFlags(hitbox, mod.FriendBulletFlags.BLACK) then
		hitbox.TargetPosition = hitbox.TargetPosition / 2
	end

	local parent = hitbox:GetHitboxParentKnife()
	if parent then
		if TearFlagsLib.HasTearFlags(hitbox, mod.FriendBulletFlags.BONE) then
			mod.scheduleForUpdate(function()
				mod:FireFriendBoneHeartBones(hitbox, TearFlagsLib.GetTearPlayer(parent), hitbox.Position, Vector.FromAngle(hitbox.Rotation), nil, 3)
			end, 1)
		end
		local player = TearFlagsLib.GetTearPlayer(parent)
		if player and TearFlagsLib.HasTearFlags(hitbox, mod.FriendBulletFlags.LEAKY) then
			mod.scheduleForUpdate(function()
				local capsulePosition, capsuleRadius = TearFlagsLib.GetSwingingKnifeCapsulePositionRadius(hitbox)
				local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, capsulePosition, Vector.Zero, player):ToEffect()
				local creepScale = (math.random() * 1/6 + 4/3) * capsuleRadius / 32
				creep.SpriteScale = Vector(creepScale, creepScale)
				creep:Update()
				return shouldReturn
			end, 3)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_KNIFE_UPDATE, mod.FriendClubHitboxInit, KnifeSubType.CLUB_HITBOX)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, rocket)
    if TearFlagsLib.HasTearFlags(rocket, mod.FriendBulletFlags.GOLD) then
        if rocket.FrameCount % 6 == 0 then
			local rng = rocket:GetDropRNG()
            local sparkle = Isaac.Spawn(1000, 1727, 0, rocket.Position+mod:shuntedPosition(10, rng), Vector.Zero, rocket):ToEffect()
            sparkle.SpriteOffset = Isaac.WorldToScreenDistance(rocket.PositionOffset)
            sparkle.SpriteScale = Vector(0.8, 0.8)
            sparkle:SetColor(Color(1,1,1,1,1,1,0), 100, 1, false, false)
            sparkle:Update()
        end
    end
end, EffectVariant.SMALL_ROCKET)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, techdot)
    if TearFlagsLib.HasTearFlags(techdot, mod.FriendBulletFlags.GOLD) then
        if techdot.FrameCount % 6 == 0 then
			local rng = techdot:GetDropRNG()
            local sparkle = Isaac.Spawn(1000, 1727, 0, techdot.Position+mod:shuntedPosition(10, rng), Vector.Zero, techdot):ToEffect()
            sparkle.SpriteOffset = Isaac.WorldToScreenDistance(techdot.PositionOffset)
            sparkle.SpriteScale = Vector(0.8, 0.8)
            sparkle:SetColor(Color(1,1,1,1,1,1,0), 100, 1, false, false)
            sparkle:Update()
        end
    end
end, EffectVariant.TECH_DOT)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, ripple)
	local tears = Isaac.FindByType(EntityType.ENTITY_TEAR)
	for _, tear in ipairs(tears) do
		if tear.Position:Distance(ripple.Position) < 0.0001 then
			local tear = tear:ToTear()
			if tear and tear:HasTearFlags(TearFlags.TEAR_HYDROBOUNCE) then
				if mod:tryLeakySplat(tear, true) then
					return
				end
			end
		end
	end
	local bombs = Isaac.FindByType(EntityType.ENTITY_BOMB)
	for _, bomb in ipairs(bombs) do
		if bomb.Position:Distance(ripple.Position) < 0.0001 then
			local bomb = bomb:ToBomb()
			if bomb and bomb:HasTearFlags(TearFlags.TEAR_HYDROBOUNCE) then
				if mod:tryLeakySplat(bomb, true) then
					return
				end
			end
		end
	end
	local knives = Isaac.FindByType(EntityType.ENTITY_KNIFE)
	for _, knife in ipairs(knives) do
		if knife.Position:Distance(ripple.Position) < 0.0001 then
			local knife = knife:ToKnife()
			if knife and knife:HasTearFlags(TearFlags.TEAR_HYDROBOUNCE) then
				if mod:tryLeakySplat(knife, true) then
					return
				end
			end
		end
	end
end, EffectVariant.RIPPLE_POOF)

if REPENTOGON.MeetsVersion("1.1.2") then
mod:AddCallback(ModCallbacks.MC_PRE_BOMB_TEARFLAG_EFFECTS, function(_, pos, radius, tearflags, source, radiusMult)
	if source and TearFlagsLib.HasTearFlags(source, mod.FriendBulletFlags.LEAKY) then
		return {TearFlags = tearflags | TearFlags.TEAR_BLOOD_BOMB}
	end
end)
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local spawner = eff.SpawnerEntity
	if spawner and spawner.Type == EntityType.ENTITY_BOMB and TearFlagsLib.HasTearFlags(spawner, mod.FriendBulletFlags.ETERNAL) then
		local countdown = spawner:ToBomb():GetExplosionCountdown()
		if countdown <= 30 and eff.FrameCount % 6 == 0 then
			eff:SetColor(Color(1,1,1,1,0.75), 4, 999, true, false)
		end
	end
end, EffectVariant.HALLOWED_GROUND)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, brimball)
    if TearFlagsLib.HasTearFlags(brimball, mod.FriendBulletFlags.GOLD) then
        if brimball.FrameCount % 6 == 0 then
			local rng = brimball:GetDropRNG()
            local sparkle = Isaac.Spawn(1000, 1727, 0, brimball.Position+mod:shuntedPosition(brimball.Size * math.max(brimball.SizeMulti.X, brimball.SizeMulti.Y) - 4, rng), Vector.Zero, brimball):ToEffect()
            sparkle.SpriteOffset = Vector(0, -8)
            sparkle.SpriteScale = Vector(0.8, 0.8)
            sparkle:SetColor(Color(1,1,1,1,1,1,0), 100, 1, false, false)
            sparkle:Update()
        end
    end
	if brimball:GetSprite():IsPlaying("Disappear") then
		local data = mod:GetEntityData(brimball)
		if not data.FFDidLeakyBrimball and TearFlagsLib.HasTearFlags(brimball, mod.FriendBulletFlags.LEAKY) then
			local player = TearFlagsLib.GetTearFlagParams(brimball, mod.FriendBulletFlags.LEAKY).Player
			if player then
				local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, brimball.Position, Vector.Zero, player):ToEffect()
				local creepScale = 2 * brimball.Size * math.max(brimball.SizeMulti.X, brimball.SizeMulti.Y) / 46
				creep.SpriteScale = Vector(creepScale, creepScale)
				creep:Update()
				data.FFDidLeakyBrimball = true
			end
		end
		if TearFlagsLib.HasTearFlags(brimball, mod.FriendBulletFlags.BONE) then
			local player = TearFlagsLib.GetTearFlagParams(brimball, mod.FriendBulletFlags.BONE).Player
			if player then
				mod:FireFriendBoneHeartBones(brimball, player, brimball.Position)
				TearFlagsLib.SetTearFlagParams(brimball, mod.FriendBulletFlags.BONE, {NoRemove = false})
				TearFlagsLib.ClearTearFlags(brimball, mod.FriendBulletFlags.BONE)
			end
		end
	end
end, EffectVariant.BRIMSTONE_BALL)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, swirl)
    if TearFlagsLib.HasTearFlags(swirl, mod.FriendBulletFlags.GOLD) then
        if swirl.FrameCount % 6 == 0 then
			local rng = swirl:GetDropRNG()
			local sprite = swirl:GetSprite()
			local statesize = sprite:GetLayer(0):GetSize()
			local framescale = sprite:GetCurrentAnimationData():GetLayer(0):GetFrame(sprite:GetFrame()):GetScale()
			local dist = math.floor(math.max(statesize.X, statesize.Y) * math.max(sprite.Scale.X, sprite.Scale.Y) * math.max(framescale.X, framescale.Y) * 18) - 4
            local sparkle = Isaac.Spawn(1000, 1727, 0, swirl.Position+Isaac.ScreenToWorldDistance(mod:shuntedPosition(dist, rng)), Vector.Zero, swirl):ToEffect()
            sparkle.PositionOffset = swirl.PositionOffset
            sparkle.SpriteScale = Vector(0.8, 0.8)
            sparkle:SetColor(Color(1,1,1,1,1,1,0), 100, 1, false, false)
            sparkle:Update()
        end
    end
end, EffectVariant.BRIMSTONE_SWIRL)

mod:AddCallback(ModCallbacks.MC_PRE_EFFECT_UPDATE, function(_, swirl)
	local data = mod:GetEntityData(swirl)
	data.FriendSwirlLaser = swirl.Child or data.FriendSwirlLaser

	local child = data.FriendSwirlLaser
	if child and child:Exists() then
		local cdata = mod:GetEntityData(child)
		cdata.FriendLaserSwirl = swirl
	end

	if swirl.FrameCount == 0 and child then
		local player = TearFlagsLib.GetTearPlayer(child)
		local shot = TearFlagsLib.GetTearFlagParams(child, mod.FriendBulletFlags.FRIEND).Shot or TearFlagsLib.GetTearFlagParams(child, mod.FriendBulletFlags.AMMO_CLIP).Shot
		if player and shot then
			mod:ApplyFriendGenericShotEffects(swirl, player, shot, shot.Crit, true, true)
			swirl.Color = mod:GetFriendShotLaserColor(swirl, player)
		end

		mod:UpdateFetalFriendSwirl(swirl)
	end
end, EffectVariant.BRIMSTONE_SWIRL)

mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, -300, function(_, entity, amount, flags, source, cooldown, extraSource)
	if flags & DamageFlag.DAMAGE_CLONES ~= 0 or not entity:ToNPC() then return end

	if source.Type ~= 1000 or (source.Variant ~= EffectVariant.TECH_DOT and source.Variant ~= EffectVariant.BRIMSTONE_SWIRL) or not source.Entity or
	   not (TearFlagsLib.HasTearFlags(source.Entity, mod.FriendBulletFlags.FRIEND) or
	        TearFlagsLib.HasTearFlags(source.Entity, mod.FriendBulletFlags.FETAL_FRIEND) or
	        TearFlagsLib.HasTearFlags(source.Entity, mod.FriendBulletFlags.AMMO_CLIP))
	then
		return
	end

	local shot = TearFlagsLib.GetTearFlagParams(source.Entity, mod.FriendBulletFlags.FRIEND).Shot or
	             TearFlagsLib.GetTearFlagParams(source.Entity, mod.FriendBulletFlags.FETAL_FRIEND).Shot or
	             TearFlagsLib.GetTearFlagParams(source.Entity, mod.FriendBulletFlags.AMMO_CLIP).Shot
	local player = TearFlagsLib.GetTearPlayer(source.Entity)
	if shot and player then
		local flat, mult, crit = mod:GetFriendShotDamageBonus(nil, player, shot)
		local ammoMult = (TearFlagsLib.HasTearFlags(source.Entity, mod.FriendBulletFlags.AMMO_CLIP) and mod.FriendBalancing.Damage) or 1
		return {Damage = (amount * ammoMult + flat) * mult}
	end
end)

mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, -300, function(_, entity, amount, flags, source, cooldown)
	if flags & DamageFlag.DAMAGE_CLONES ~= 0 or not entity:ToNPC() then return end

	if source.Type ~= 1000 or (source.Variant ~= EffectVariant.ROCKET and source.Variant ~= EffectVariant.SMALL_ROCKET) or not source.Entity or
	   not (TearFlagsLib.HasTearFlags(source.Entity, mod.FriendBulletFlags.FRIEND) or
	        TearFlagsLib.HasTearFlags(source.Entity, mod.FriendBulletFlags.FETAL_FRIEND) or
	        TearFlagsLib.HasTearFlags(source.Entity, mod.FriendBulletFlags.AMMO_CLIP))
	then
		return
	end

	if flags & DamageFlag.DAMAGE_EXPLOSION > 0 then
		local shot = TearFlagsLib.GetTearFlagParams(source.Entity, mod.FriendBulletFlags.FRIEND).Shot or
		             TearFlagsLib.GetTearFlagParams(source.Entity, mod.FriendBulletFlags.FETAL_FRIEND).Shot or
		             TearFlagsLib.GetTearFlagParams(source.Entity, mod.FriendBulletFlags.AMMO_CLIP).Shot
		local player = TearFlagsLib.GetTearPlayer(source.Entity)
		if shot and player then
			local flat, mult, crit = mod:GetFriendShotDamageBonus(nil, player, shot)
			local ammoMult = (TearFlagsLib.HasTearFlags(source.Entity, mod.FriendBulletFlags.AMMO_CLIP) and mod.FriendBalancing.Damage) or 1
			local rocketMult = (source.Variant == EffectVariant.ROCKET and 20) or 10
			return {Damage = (amount * ammoMult + flat * rocketMult) * mult}
		end
	end
end)

mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, -300, function(_, entity, amount, flags, source, cooldown, extraSource)
	if flags & DamageFlag.DAMAGE_CLONES ~= 0 or not entity:ToNPC() then return end

	if extraSource == nil or extraSource.Type ~= 3 or extraSource.Variant ~= FamiliarVariant.UMBILICAL_BABY or not extraSource.Entity or
	   not (TearFlagsLib.HasTearFlags(extraSource.Entity, mod.FriendBulletFlags.FRIEND) or
	        TearFlagsLib.HasTearFlags(extraSource.Entity, mod.FriendBulletFlags.FETAL_FRIEND) or
	        TearFlagsLib.HasTearFlags(extraSource.Entity, mod.FriendBulletFlags.AMMO_CLIP))
	then
		return
	end

	local shot = TearFlagsLib.GetTearFlagParams(extraSource.Entity, mod.FriendBulletFlags.FRIEND).Shot or
	             TearFlagsLib.GetTearFlagParams(extraSource.Entity, mod.FriendBulletFlags.FETAL_FRIEND).Shot or
	             TearFlagsLib.GetTearFlagParams(extraSource.Entity, mod.FriendBulletFlags.AMMO_CLIP).Shot
	local player = TearFlagsLib.GetTearPlayer(extraSource.Entity)
	if shot and player then
		local flat, mult, crit = mod:GetFriendShotDamageBonus(nil, player, shot)
		local ammoMult = (TearFlagsLib.HasTearFlags(extraSource.Entity, mod.FriendBulletFlags.AMMO_CLIP) and mod.FriendBalancing.Damage) or 1
		return {Damage = (amount * ammoMult + flat) * mult}
	end
end)

mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, -300, function(_, entity, amount, flags, source, cooldown, extraSource)
	if flags & DamageFlag.DAMAGE_CLONES ~= 0 or not entity:ToNPC() then return end

	local source = extraSource or source
	if source.Entity and TearFlagsLib.IsEntitySpiritSword(source.Entity) then
		return
	end
	if source.Type ~= 8 or not source.Entity or
	   not (TearFlagsLib.HasTearFlags(source.Entity, mod.FriendBulletFlags.FRIEND) or
	        TearFlagsLib.HasTearFlags(source.Entity, mod.FriendBulletFlags.FETAL_FRIEND) or
	        TearFlagsLib.HasTearFlags(source.Entity, mod.FriendBulletFlags.AMMO_CLIP))
	then
		return
	end

	local shot = TearFlagsLib.GetTearFlagParams(source.Entity, mod.FriendBulletFlags.FRIEND).Shot or
	             TearFlagsLib.GetTearFlagParams(source.Entity, mod.FriendBulletFlags.FETAL_FRIEND).Shot or
	             TearFlagsLib.GetTearFlagParams(source.Entity, mod.FriendBulletFlags.AMMO_CLIP).Shot
	local player = TearFlagsLib.GetTearPlayer(source.Entity)
	if shot and player then
		local flat, mult, crit = mod:GetFriendShotDamageBonus(nil, player, shot)
		local ammoMult = (TearFlagsLib.HasTearFlags(source.Entity, mod.FriendBulletFlags.AMMO_CLIP) and mod.FriendBalancing.Damage) or 1
		return {Damage = ((source.Entity.CollisionDamage * ammoMult + flat) * mult) * (amount / source.Entity.CollisionDamage)}
	end
end)

mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, -300, function(_, entity, amount, flags, source, cooldown, extraSource)
	if flags & DamageFlag.DAMAGE_CLONES ~= 0 or not entity:ToNPC() then return end

	local source = extraSource or source
	if (source.Type ~= EntityType.ENTITY_LASER and not (source.Type == EntityType.ENTITY_EFFECT and source.Variant == EffectVariant.BRIMSTONE_BALL)) or not source.Entity or
	   not (TearFlagsLib.HasTearFlags(source.Entity, mod.FriendBulletFlags.FRIEND) or
	        TearFlagsLib.HasTearFlags(source.Entity, mod.FriendBulletFlags.FETAL_FRIEND) or
	        TearFlagsLib.HasTearFlags(source.Entity, mod.FriendBulletFlags.AMMO_CLIP))
	then
		return
	end

	local shot = TearFlagsLib.GetTearFlagParams(source.Entity, mod.FriendBulletFlags.FRIEND).Shot or
	             TearFlagsLib.GetTearFlagParams(source.Entity, mod.FriendBulletFlags.FETAL_FRIEND).Shot or
	             TearFlagsLib.GetTearFlagParams(source.Entity, mod.FriendBulletFlags.AMMO_CLIP).Shot
	local player = TearFlagsLib.GetTearPlayer(source.Entity)
	if shot and player then
		local flat, mult, crit = mod:GetFriendShotDamageBonus(nil, player, shot)
		local ammoMult = (TearFlagsLib.HasTearFlags(source.Entity, mod.FriendBulletFlags.AMMO_CLIP) and mod.FriendBalancing.Damage) or 1
		return {Damage = ((source.Entity.CollisionDamage * ammoMult + flat) * mult) * (amount / source.Entity.CollisionDamage)}
	end
end)

mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, -300, function(_, entity, amount, flags, source, cooldown, extraSource)
	if flags & DamageFlag.DAMAGE_CLONES ~= 0 or not entity:ToNPC() then return end

	local source = extraSource or source
	if not (source.Type == 1 and TearFlagsLib.hemoptysisDummy and
	        (TearFlagsLib.HasTearFlags(TearFlagsLib.hemoptysisDummy, mod.FriendBulletFlags.FRIEND) or
	         TearFlagsLib.HasTearFlags(TearFlagsLib.hemoptysisDummy, mod.FriendBulletFlags.FETAL_FRIEND) or
	         TearFlagsLib.HasTearFlags(TearFlagsLib.hemoptysisDummy, mod.FriendBulletFlags.AMMO_CLIP)))
	then
		return
	end

	local shot = TearFlagsLib.GetTearFlagParams(TearFlagsLib.hemoptysisDummy, mod.FriendBulletFlags.FRIEND).Shot or
	             TearFlagsLib.GetTearFlagParams(TearFlagsLib.hemoptysisDummy, mod.FriendBulletFlags.FETAL_FRIEND).Shot or
	             TearFlagsLib.GetTearFlagParams(TearFlagsLib.hemoptysisDummy, mod.FriendBulletFlags.AMMO_CLIP).Shot
	local player = TearFlagsLib.GetTearPlayer(source.Entity)
	if shot and player then
		local flat, mult, crit = mod:GetFriendShotDamageBonus(nil, player, shot)
		local ammoMult = (TearFlagsLib.HasTearFlags(TearFlagsLib.hemoptysisDummy, mod.FriendBulletFlags.AMMO_CLIP) and mod.FriendBalancing.Damage) or 1
		return {Damage = (amount * ammoMult + flat) * mult}
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_FIRE_SPLIT_TEAR, function(_, tear, source)
	if TearFlagsLib.HasTearFlags(source, mod.FriendBulletFlags.ETERNAL) then
		TearFlagsLib.AddTearFlags(tear, mod.FriendBulletFlags.ETERNAL)
		if tear.WaitFrames > 0 then
			local mult = math.max(1.5, tear.ContinueVelocity:Length()-16) / tear.ContinueVelocity:Length()
			TearFlagsLib.SetTearFlagParams(tear, mod.FriendBulletFlags.ETERNAL, {FallSpeedMult = mult})
			tear.ContinueVelocity = tear.ContinueVelocity * mult
		else
			local mult = math.max(1.5, tear.Velocity:Length()-16) / tear.Velocity:Length()
			TearFlagsLib.SetTearFlagParams(tear, mod.FriendBulletFlags.ETERNAL, {FallSpeedMult = mult})
			tear.Velocity = tear.Velocity * mult
		end
		local halo = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HALLOWED_GROUND, 0, tear.Position, Vector.Zero, tear):ToEffect()
		halo:FollowParent(tear)
		halo.DepthOffset = -100
		halo.SpriteScale = halo.SpriteScale * tear.Scale / 1.1081267595291 * 0.5
		mod:GetEntityData(tear).EternalHalo = halo
	end
	if TearFlagsLib.HasTearFlags(source, mod.FriendBulletFlags.BLACK) then
        TearFlagsLib.AddTearFlags(tear, mod.FriendBulletFlags.BLACK)
		tear:AddTearFlags(TearFlags.TEAR_DECELERATE | TearFlags.TEAR_PIERCING)
        tear.Velocity = tear.Velocity * 1.5
		tear.Scale = tear.Scale*1.5
		TearFlagsLib.SetTearFlagParams(tear, mod.FriendBulletFlags.BLACK, {LifeSpan = 10})
		mod:GetEntityData(tear).NoFallRotation = true
	end
	if TearFlagsLib.HasTearFlags(source, mod.FriendBulletFlags.STEVEN) then
		tear:GetSprite():SetCustomShader("shaders/fiendfolio/coloroffset_parallel")
	end
	TearFlagsLib.ClearTearFlags(tear, mod.FriendBulletFlags.BONE)
end, SplitTearType.SWORD_BEAM or 11)

mod:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, function(_, sword)
	if sword.SubType == 4 or not TearFlagsLib.IsEntitySpiritSword(sword) then return end

	local isSwinging = sword:GetIsSwinging()
	local capsule = mod:getSwordCapsules(sword)
	if sword.FrameCount % ((isSwinging and 1) or 6) == 0 and Isaac.GetFrameCount() % 2 == 0 and TearFlagsLib.HasTearFlags(sword, mod.FriendBulletFlags.GOLD) then
		local capsuleStart, capsuleEnd = capsule:GetVec2(), capsule:GetVec3()
		local dir = capsuleEnd - capsuleStart
		local pos = capsuleStart + dir:Resized(dir:Length() * math.random())

		local rng = sword:GetDropRNG()
        local sparkle = Isaac.Spawn(1000, 1727, 0, pos+mod:shuntedPosition(math.floor(capsule:GetF1()), rng), Vector.Zero, sword):ToEffect()
        sparkle.PositionOffset = sword.PositionOffset
        sparkle.SpriteScale = Vector(0.8, 0.8)
        sparkle:SetColor(Color(1,1,1,1,1,1,0), 100, 1, false, false)
        sparkle:Update()
	end

	local ptrhash = GetPtrHash(sword)
	if isSwinging then
		if not swordsThatWereSwinging[ptrhash] then swordsThatHaveProccedBone[ptrhash] = nil end
		swordsThatWereSwinging[ptrhash] = true

		if Isaac.GetFrameCount() % 2 == 0 and TearFlagsLib.HasTearFlags(sword, mod.FriendBulletFlags.LEAKY) then
			local player = TearFlagsLib.GetTearFlagParams(sword, mod.FriendBulletFlags.LEAKY).Player
			if player then
				local capsuleStart, capsuleEnd = capsule:GetVec2(), capsule:GetVec3()
				local dir = capsuleStart - capsuleEnd
				local dist = dir:Length()
				if dist > 0 then
					local distRemaining = dist + capsule:GetF1() * 2
					while distRemaining > 0 do
						if math.random() <= ((distRemaining == dist and 0.66) or 0.33) then
							local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, capsuleEnd + dir:Resized(dist - distRemaining + capsule:GetF1()), Vector.Zero, player):ToEffect()
							local creepScale = math.random() * 0.5 + 0.2
							creep.SpriteScale = Vector(creepScale, creepScale)
							creep:Update()
						end
						distRemaining = distRemaining - 20
					end
				end
			end
		end
	elseif swordsThatWereSwinging[ptrhash] then
		if not swordsThatHaveProccedBone[ptrhash] and TearFlagsLib.HasTearFlags(sword, mod.FriendBulletFlags.BONE) then
			local player = TearFlagsLib.GetTearFlagParams(sword, mod.FriendBulletFlags.BONE).Player
			if player then
				mod:FireFriendBoneHeartBones(sword, player, sword.Position, Vector.FromAngle(sword.Rotation))
			end
		end
		swordsThatWereSwinging[ptrhash] = nil
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, sword)
	if sword.SubType == 4 or not TearFlagsLib.IsEntitySpiritSword(sword) then return end

	local ptrhash = GetPtrHash(sword)
	if swordsThatWereSwinging[ptrhash] then
		if not swordsThatHaveProccedBone[ptrhash] and TearFlagsLib.HasTearFlags(sword, mod.FriendBulletFlags.BONE) then
			local player = TearFlagsLib.GetTearFlagParams(sword, mod.FriendBulletFlags.BONE).Player
			if player then
				mod:FireFriendBoneHeartBones(sword:ToKnife(), player, sword.Position, Vector.FromAngle(sword:ToKnife().Rotation))
			end
		end
		swordsThatWereSwinging[ptrhash] = nil
	end
	swordsThatHaveProccedBone[ptrhash] = nil
	swordsThatWereSwinging[ptrhash] = nil
end, EntityType.ENTITY_KNIFE)

--[[
function mod:checkDidPlayerDieFriend(player, data)
    if player:IsDead() and mod:IsAnyFriend(player) then
        if not data.checkedMusicForFriend then
            mod.scheduleForUpdate(function()
                local ms = MusicManager()
                if ms:GetCurrentMusicID() == Music.MUSIC_JINGLE_GAME_OVER then
                    local outcome = math.random(4)
                    if outcome == 1 then
                        ms:Play(mod.Music.FriendGameOver01, 0)
                    elseif outcome == 2 then
                        ms:Play(mod.Music.FriendGameOver02, 0)
                    elseif outcome == 3 then
                        ms:Play(mod.Music.FriendGameOver03, 0)
                    elseif outcome == 4 then
                        ms:Play(mod.Music.FriendGameOver04, 0)
                    end
                    ms:UpdateVolume()
                end
            end, 120, ModCallbacks.MC_POST_RENDER)
            data.checkedMusicForFriend = true
        end
    elseif data.checkedMusicForFriend then
        data.checkedMusicForFriend = false
    end
end
]]

-- Death jingles
function mod:ShouldPlayFriendDeathJingle()
    local anyFriend = false
    local players = PlayerManager.GetPlayers()
    local deadPlayers = 0
    for _, player in ipairs(players) do
        if player:IsDead() or player:IsCoopGhost() then
            deadPlayers = deadPlayers + 1
        end

        if mod:IsAnyFriend(player) then
            anyFriend = true
        end
    end

    if anyFriend and deadPlayers == #players then
        return true
    end

    return false
end

mod:AddCallback(ModCallbacks.MC_PRE_MUSIC_PLAY, function(_, music, volume)
    if mod:ShouldPlayFriendDeathJingle() then
        local outcome = math.random(4)
        if outcome == 1 then
            return mod.Music.FriendGameOver01
        elseif outcome == 2 then
            return mod.Music.FriendGameOver02
        elseif outcome == 3 then
            return mod.Music.FriendGameOver03
        elseif outcome == 4 then
            return mod.Music.FriendGameOver04
        end
    end
end, Music.MUSIC_JINGLE_GAME_OVER)

mod:AddCallback(ModCallbacks.MC_PRE_MUSIC_PLAY, function(_, music, volume)
    if mod:ShouldPlayFriendDeathJingle() then
        return false
    end
end, Music.MUSIC_GAME_OVER)

-- Extra starting room controls
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    -- Only appear in the starting room
    -- Don't appear if the player was detected with mouse controls
    -- Disappears forever after the player was seen at least trying them out
    local room = game:GetRoom()
    local level = game:GetLevel()
    if (
        level:GetStage() == LevelStage.STAGE1_1
        and level:GetStageType() < StageType.STAGETYPE_REPENTANCE
        and level:GetDimension() == Dimension.NORMAL
        and level:GetStartingRoomIndex() == level:GetCurrentRoomIndex()
        and not FiendFolio.savedata.DetectedThatYouHadMouseControlsEnabled
    ) then
        if not Options.MouseControl then
            local player = Isaac.GetPlayer(0)
            if mod:IsAnyFriend(player) then
                local spawnPos = Vector(65,350) -- The bottom left
                local eff = Isaac.Spawn(mod.FF.MouseControlsIndicator.ID, mod.FF.MouseControlsIndicator.Var, mod.FF.MouseControlsIndicator.Sub, spawnPos, Vector.Zero, nil)

                -- Gets the color of the floor controls sprite
                -- This will account for things such as Burning Basement's slightly different color palette
                local playerConfig = EntityConfig.GetPlayer(player:GetPlayerType())
                local controlsSprite = playerConfig:GetModdedControlsSprite()
                local floorColor = Color.Lerp(controlsSprite.Color, Color(), 0) -- Duplicate the color
                floorColor:SetColorize(0.3, 0.3, 0.3, 0.4)
                eff:GetSprite().Color = floorColor

                -- Will become a part of the floor, rendering below shadows and removing the effect entity
                eff:AddEntityFlags(EntityFlag.FLAG_RENDER_FLOOR)
            end
        else
            FiendFolio.savedata.DetectedThatYouHadMouseControlsEnabled = true
        end
    end
end)

-- Custom familiar sprites

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, familiar)
    if familiar.Player:GetPlayerType() == FiendFolio.PLAYER.FRIEND or familiar.Player:GetPlayerType() == FiendFolio.PLAYER.BRIEND then
        familiar:GetSprite():ReplaceSpritesheet(0, "gfx/familiar/friend/friend_leprocy.png", true)
    end
end, FamiliarVariant.LEPROCY)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, familiar)
    if familiar.Player:GetPlayerType() == FiendFolio.PLAYER.FRIEND or familiar.Player:GetPlayerType() == FiendFolio.PLAYER.BRIEND then
        familiar:GetSprite():ReplaceSpritesheet(0, "gfx/familiar/friend/friend_finger.png", true)
    end
end, FamiliarVariant.FINGER)

--[[
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function()
    --Don't appear if the player was detected with mouse controls
    --Disappears forever after the player was seen at least trying them out
    if not FiendFolio.savedata.DetectedThatYouHadMouseControlsEnabled then
        if not isContinued then
            if Game():GetFrameCount() == 0 then
                if not Options.MouseControl then
                    mod.scheduleForUpdate(function()
                        local playerType = Isaac.GetPlayer():GetPlayerType()
                        if playerType == mod.PLAYER.FRIEND
                        or playerType == mod.PLAYER.BRIEND
                        then
                            --To stop Briend from spawning two
                            if mod.GetEntityCount(mod.FF.MouseControlsIndicator.ID, mod.FF.MouseControlsIndicator.Var, mod.FF.MouseControlsIndicator.Sub) < 1 then
                                local eff = Isaac.Spawn(mod.FF.MouseControlsIndicator.ID, mod.FF.MouseControlsIndicator.Var, mod.FF.MouseControlsIndicator.Sub, Vector(70,350), Vector.Zero, nil)
                                eff.Color = Color(0,0,0,0)
                                eff:Update()
                            end
                        end
                    end, 1, nil, true)
                else
                    FiendFolio.savedata.DetectedThatYouHadMouseControlsEnabled = true
                end
            end
        end
    end
end)

function mod:MouseControlsIndicatorAI(e)
    local stagetype = game:GetLevel():GetStageType()
    local alpha = math.min(0.9,e.FrameCount / 120)
    if Options.MouseControl then
        mod:GetEntityData(e).Timeout = mod:GetEntityData(e).Timeout or alpha
        mod:GetEntityData(e).Timeout = mod:GetEntityData(e).Timeout - 0.05
        if mod:GetEntityData(e).Timeout <= 0 then
            FiendFolio.savedata.DetectedThatYouHadMouseControlsEnabled = true
            e:Remove()
        else
            alpha = mod:GetEntityData(e).Timeout
        end
    end
    --[[if stagetype == StageType.STAGETYPE_AFTERBIRTH then
        e.Color = Color(0.3,0.3,0.3,alpha)
    elseif stagetype == StageType.STAGETYPE_WOTL then
        e.Color = Color(0.6,0.6,0.6,alpha)
    else
        e.Color = Color(0.6,0.6,0.6,alpha)
    end]-]
    e.Color = Color(1,1,1,alpha)
    e.DepthOffset = -2000
end
]]