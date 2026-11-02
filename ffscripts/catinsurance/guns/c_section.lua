local mod = FiendFolio
local synergy = {}

mod.FRIEND_C_SECTION = {}
mod.FRIEND_C_SECTION.DAMAGE_MULT = 0.7
mod.FRIEND_C_SECTION.MAX_FETUS_SPEED = 15
mod.FRIEND_C_SECTION.SIGHT_RADIUS = 40 * 10
mod.FRIEND_C_SECTION.TARGET_RADIUS = 40 * 4
mod.FRIEND_C_SECTION.KEEP_DISTANCE = 40 * 2.66
mod.FRIEND_C_SECTION.KEEP_DISTANCE_SWORD = 40 * 1.88
mod.FRIEND_C_SECTION.MAX_BRIMSTONE_DISTANCE = 80

mod.FRIEND_C_SECTION.FETUS_SHOTGUN_BULLET_COUNT = 6

local function calculateFetusFireCooldown(player)
    if mod:GetFriendWeaponType(player) == WeaponType.WEAPON_BRIMSTONE
    or player:HasCollectible(CollectibleType.COLLECTIBLE_MONSTROS_LUNG)
    or player:HasCollectible(CollectibleType.COLLECTIBLE_CURSED_EYE) then
        return math.max(math.floor(player.MaxFireDelay * 3.66), 5) 
    else
        return math.max(math.floor(player.MaxFireDelay * 1.33), 5)
    end
end

-- Make fetus shoot gun and keep distance
---@param tear EntityTear
function synergy:ControlFetus(tear)
    local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
    if not player then
        player = tear.SpawnerEntity and tear.SpawnerEntity:ToFamiliar() and tear.SpawnerEntity:ToFamiliar().Player

        if not player then
            return
        end
    end

    if not mod:IsAnyFriend(player) then
        return
    end

    local data = mod:GetEntityData(tear)
    if not data.FetusFriendGun or not data.FetusFriendGun.Ref then
        local pd = mod:GetEntityData(player)
        local main = pd.FriendsRevolver
        local shot = pd.FriendCSectionLastShot or mod:GetFriendGunNextShot(main, true)

        data.FetusFriendGun = EntityPtr(mod:SpawnFriendGun(tear, nil, player, shot and {shot} or "RED_HEART"))
        local friendGunData = mod:GetEntityData(data.FetusFriendGun.Ref)

        -- Fetus guns don't need effect overload protection as much, espectially since C-Section could be contributing to it.
        data.FetusFriendGun.Ref:ClearEntityFlags(EntityFlag.FLAG_DONT_OVERWRITE)
        friendGunData.LockAngle = tear.Velocity:GetAngleDegrees()
        friendGunData.NoReload = true
        friendGunData.OwnedByFetus = true

        mod:CheckCurrentGunReplacement(player, data.FetusFriendGun.Ref, true)
        data.FriendFireCooldown = 10

        -- Remove vanilla synergies
        local customFetusFlags = {
            TearFlags.TEAR_FETUS_BOMBER,
            TearFlags.TEAR_FETUS_BONE,
            TearFlags.TEAR_FETUS_BRIMSTONE,
            TearFlags.TEAR_FETUS_KNIFE,
            TearFlags.TEAR_FETUS_TECH,
            TearFlags.TEAR_FETUS_TECHX,
            TearFlags.TEAR_FETUS_SWORD,
        }
        
        for _, flag in ipairs(customFetusFlags) do
            if tear.TearFlags & flag == flag then
                tear.TearFlags = tear.TearFlags ~ flag
            end
        end
    end

    data.FriendFireCooldown = data.FriendFireCooldown or 0
    data.FriendFireCooldown = math.max(data.FriendFireCooldown - 1, 0)

    -- Handle movement
    if tear.Velocity:Length() > mod.FRIEND_C_SECTION.MAX_FETUS_SPEED then
        tear.Velocity = tear.Velocity:Resized(mod.FRIEND_C_SECTION.MAX_FETUS_SPEED)
    end

    tear.CollisionDamage = 0
    -- Handle gun
    local friendGunData = mod:GetEntityData(data.FetusFriendGun.Ref)
    friendGunData.ExtraOffset = Vector(0, (tear.Height - player.TearHeight))

    local nearestEnemy, d
    for _, enemy in ipairs(Isaac.FindInRadius(tear.Position, mod.FRIEND_C_SECTION.SIGHT_RADIUS, EntityPartition.ENEMY)) do
        if enemy:IsVulnerableEnemy() and enemy:IsActiveEnemy() then
            local calc = enemy.Position:DistanceSquared(tear.Position)
            if not d or calc < d then
                nearestEnemy = enemy
                d = calc
            end
        end
    end

    if not nearestEnemy then
        return
    end

    local dist = (nearestEnemy.Position - tear.Position)
    local aim = dist:Normalized()

    local spiritSword = data.FetusFriendGun.Ref.SubType == CollectibleType.COLLECTIBLE_SPIRIT_SWORD

    local keepDistance = spiritSword and mod.FRIEND_C_SECTION.KEEP_DISTANCE_SWORD or mod.FRIEND_C_SECTION.KEEP_DISTANCE

    if player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS) or player:HasCollectible(CollectibleType.COLLECTIBLE_EPIC_FETUS) then
        keepDistance = mod.FRIEND_C_SECTION.TARGET_RADIUS
    end

    if dist:Length() < keepDistance then
        local power = math.max((1 - (dist:Length() / keepDistance)) * 5, 1)
        tear:AddVelocity(aim:Rotated(180):Resized(power))
    end

    if data.FriendFireCooldown == 0 and dist:Length() < mod.FRIEND_C_SECTION.TARGET_RADIUS then
        friendGunData.LockAngle = aim:GetAngleDegrees()
        data.FriendFireCooldown = calculateFetusFireCooldown(player)

		mod.IgnoreSecondaryFireEffects = true
		local beeSkinMult = (TearFlagsLib.HasTearFlags(tear, TearFlagsLib.Flag.BEE_SKIN) and 0.3) or 1
        if spiritSword then
            local firstShot = not friendGunData.FriendFetusDidChargeAttack
            friendGunData.FriendFetusDidChargeAttack = true
            if firstShot then
                mod:FriendSpiritSwordTriggerChargedAttack(data.FetusFriendGun.Ref, aim)
            else
                mod:FriendSpiritSwordTriggerSlash(data.FetusFriendGun.Ref, false)
            end
        else
            -- Monstro's Lung special functionality
            if player:HasCollectible(CollectibleType.COLLECTIBLE_MONSTROS_LUNG) then  
                local vel = aim:Resized(10*player.ShotSpeed)
                local rng = tear:GetDropRNG()
                for i=1, mod.FRIEND_C_SECTION.FETUS_SHOTGUN_BULLET_COUNT do
                    local randVel
                    local randVelPlus = mod:RandomInt(-25,25,rng)/10
                    if i>1 then
                        randVel = vel:Rotated(mod:RandomInt(-20,20,rng))
                        randVel = randVel:Resized(randVel:Length()+randVelPlus)
                    end

                    local trueVel = randVel or vel:Resized(vel:Length()+randVelPlus)
                    local shot = mod:GetFriendGunNextShot(data.FetusFriendGun.Ref, true)
                    local singleFriendShot = mod:FireSingleFriendShot(data.FetusFriendGun.Ref, aim, Vector.Zero, trueVel, shot, true)
                    if singleFriendShot then
						if singleFriendShot.Type == EntityType.ENTITY_TEAR then
							singleFriendShot.Velocity = trueVel * 1.35
							local tab = {update = function(v, tab, dataa, key)
								if v.Velocity:Length() > tab.minVel and v.FrameCount < 60 then
									v.Velocity = v.Velocity*0.935
								else
									if key then
										dataa.customTearBehavior[key] = nil
									else
										dataa.customTearBehavior = nil
									end
								end
							end, minVel = trueVel:Length()*0.6}
							mod:TryToAddTearBehavior(singleFriendShot, mod:GetEntityData(singleFriendShot), tab)
							singleFriendShot.CollisionDamage = singleFriendShot.CollisionDamage * mod.FRIEND_C_SECTION.DAMAGE_MULT * beeSkinMult
						elseif singleFriendShot.Type == EntityType.ENTITY_LASER then
							singleFriendShot:SetDamageMultiplier(singleFriendShot:GetDamageMultiplier() * mod.FRIEND_C_SECTION.DAMAGE_MULT * beeSkinMult)
							if singleFriendShot.Variant == LaserVariant.THICK_RED
							or singleFriendShot.Variant == LaserVariant.THICKER_RED
							or singleFriendShot.Variant == LaserVariant.BRIM_TECH
							or singleFriendShot.Variant == LaserVariant.THICKER_BRIM_TECH then
								singleFriendShot.MaxDistance = mod.FRIEND_C_SECTION.MAX_BRIMSTONE_DISTANCE
							end
						elseif singleFriendShot.Type == EntityType.ENTITY_BOMB then
							singleFriendShot.ExplosionDamage = singleFriendShot.ExplosionDamage * mod.FRIEND_C_SECTION.DAMAGE_MULT * beeSkinMult
						end
                    end
                end

				mod.IgnoreSecondaryFireEffects = false
                return
            end

            -- Do this in a timer and for loop for Cursed Eye
            local timesToShoot = player:HasCollectible(CollectibleType.COLLECTIBLE_CURSED_EYE) and 5 or 1
            for delay = 0, timesToShoot - 1 do
                Isaac.CreateTimer(function ()
					mod.IgnoreSecondaryFireEffects = true
                    local shotThings = mod:FireGunFriend(data.FetusFriendGun.Ref, aim, false, true, true)
                    if shotThings and #shotThings > 0 then
                        for _, singleShot in ipairs(shotThings) do
                            if singleShot.Type == EntityType.ENTITY_TEAR then
                                singleShot.CollisionDamage = singleShot.CollisionDamage * mod.FRIEND_C_SECTION.DAMAGE_MULT * beeSkinMult
                            elseif singleShot.Type == EntityType.ENTITY_LASER then
								singleShot:SetDamageMultiplier(singleShot:GetDamageMultiplier() * mod.FRIEND_C_SECTION.DAMAGE_MULT * beeSkinMult)
                                if singleShot.Variant == LaserVariant.THICK_RED
                                or singleShot.Variant == LaserVariant.THICKER_RED
                                or singleShot.Variant == LaserVariant.BRIM_TECH
                                or singleShot.Variant == LaserVariant.THICKER_BRIM_TECH then
                                    singleShot.MaxDistance = mod.FRIEND_C_SECTION.MAX_BRIMSTONE_DISTANCE
                                end
                            elseif singleShot.Type == EntityType.ENTITY_BOMB then
                                singleShot.ExplosionDamage = singleShot.ExplosionDamage * mod.FRIEND_C_SECTION.DAMAGE_MULT * beeSkinMult
                            end
                        end
                    end
					mod.IgnoreSecondaryFireEffects = false
                end, delay * 3, 1, false)
            end
        end
		mod.IgnoreSecondaryFireEffects = false
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_TEAR_UPDATE, synergy.ControlFetus, TearVariant.FETUS)

function synergy:MakeFetusCostAmmo(_, _, owner, _)
    local player = owner:ToPlayer()
    if not player then
        return
    end

    if mod:IsAnyFriend(player) then
        local pd = mod:GetEntityData(player)
        local main = pd.FriendsRevolver
        local gunData = mod:GetEntityData(main)
        local gunTable = pd.FriendHeldGuns[main.InitSeed]
        pd.FriendHeldGuns[main.InitSeed].LastFrameFired = main.FrameCount

        if #gunTable.Ammo > 0 then
            pd.FriendCSectionLastShot = mod:GetFriendGunNextShot(main)  -- Consumes ammo

            if #gunTable.Ammo == 0 then
                gunData.state = "Reload"
                gunData.substate = "Begin"
                gunData.reloadOverride = true
            end
        end
        
    end
end

mod:AddPriorityCallback(ModCallbacks.MC_POST_TRIGGER_WEAPON_FIRED, CallbackPriority.EARLY, synergy.MakeFetusCostAmmo, WeaponType.WEAPON_FETUS)

---@param weapon Weapon
function synergy:DontShootFetusAtNoAmmo(weapon, fireDirection, isShooting)
    local owner = weapon:GetOwner()
    local player = owner.Type == EntityType.ENTITY_FAMILIAR and owner:ToFamiliar().Player or owner:ToPlayer()
    if mod:IsAnyFriend(player) then
        local pd = mod:GetEntityData(player)
        local main = pd.FriendsRevolver
        local gunData = mod:GetEntityData(main)
        local gunTable = pd.FriendHeldGuns[main.InitSeed]
        if #gunTable.Ammo == 0 then
            weapon:SetCharge(0)
        elseif isShooting then
            gunData.state = "Idle"
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_WEAPON_FIRE, synergy.DontShootFetusAtNoAmmo, WeaponType.WEAPON_FETUS)

---@param player EntityPlayer
function synergy:ChangeStats(player, flag)
    if player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION)
    and mod:IsAnyFriend(player) then
        if flag == CacheFlag.CACHE_SHOTSPEED then
            player.ShotSpeed = player.ShotSpeed - 0.6
        end

        if flag == CacheFlag.CACHE_TEARFLAG then
            player.TearFlags = player.TearFlags | TearFlags.TEAR_SPECTRAL
        end
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, synergy.ChangeStats, CacheFlag.CACHE_TEARFLAG)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, synergy.ChangeStats, CacheFlag.CACHE_SHOTSPEED)

---@param player EntityPlayer
function synergy:UpdateFriendCache(player, collectible)
    if mod:IsAnyFriend(player) then
        player:AddCacheFlags(CacheFlag.CACHE_TEARFLAG | CacheFlag.CACHE_SHOTSPEED, true)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, function (_, _, _, _, _, _, player)
    synergy:UpdateFriendCache(player)
end, CollectibleType.COLLECTIBLE_C_SECTION)

mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, synergy.UpdateFriendCache, CollectibleType.COLLECTIBLE_C_SECTION)