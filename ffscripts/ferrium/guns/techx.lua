local mod = FiendFolio
local sfx = SFXManager()

mod:AddCallback("PRE_GUN_FIRE", function(_, e, player, aim, held)
    if mod:GetFriendWeaponType(player, e) == WeaponType.WEAPON_TECH_X then
        local pd = mod:GetEntityData(player)
        local d = mod:GetEntityData(e)

        local gunTable = pd.FriendHeldGuns[e.InitSeed]

        local rng = e:GetDropRNG()
        d.DontReloadNewRoom = true

        if #gunTable.Ammo > 0 and not d.FriendTechXShotCharge then
            pd.FriendHeldGuns[e.InitSeed].LastFrameFired = e.FrameCount

            if d.state == "Reload" then
                d.state = "Idle"
            end
            sfx:Play(SoundEffect.SOUND_SCAMPER, 0.5, 0, false, mod:RandomInt(120,130,rng)/100)

            d.FriendTechXShotCharge = 0

            if pd.customChargeBarSprites and pd.customChargeBarSprites[CollectibleType.COLLECTIBLE_TECH_X] and pd.customChargeBarTable then
                for key,entry in pairs(pd.customChargeBarTable) do
                    if entry.id == CollectibleType.COLLECTIBLE_TECH_X then
                        entry.spriteFrame = 0
                    end
                end
            end
        elseif #gunTable.Ammo > 0 and held and d.FriendTechXShotCharge then
            local mincharged = d.FriendTechXShotCharge > 25
            local fullycharged = d.FriendTechXShotCharge >= 100
            local marked = mod.IsPlayerMarkedFiring(player)
            if (fullycharged or (mincharged and marked and d.FriendMarkedSoyLetGo)) and (marked or mod.HasSoyOrAlmondMilk(player)) then
                mod:TryFireFriendTechXGun(e, player, aim)
            end
            --[[d.FriendTechXShotCharge = d.FriendTechXShotCharge+50/player.MaxFireDelay
            if pd.customChargeBarSprites and pd.customChargeBarSprites[CollectibleType.COLLECTIBLE_TECH_X] and pd.customChargeBarTable then
                for key,entry in pairs(pd.customChargeBarTable) do
                    if entry.id == CollectibleType.COLLECTIBLE_TECH_X then
                        entry.spriteFrame = math.min(100, math.ceil(d.FriendTechXShotCharge))
                    end
                end
            end]]
        else
            if d.state ~= "Reload" then
                d.state = "Reload"
                d.substate = "Begin"
                d.reloadOverride = true
                d.FriendTechXShotCharge = nil
                if pd.customChargeBarSprites and pd.customChargeBarSprites[CollectibleType.COLLECTIBLE_TECH_X] and pd.customChargeBarTable then
                    for key,entry in pairs(pd.customChargeBarTable) do
                        if entry.id == CollectibleType.COLLECTIBLE_TECH_X then
                            entry.spriteFrame = 0
                        end
                    end
                end
            end
        end

        return true
    end
end)

function mod:TryFireFriendTechXGun(e, player, aim)
    if mod:GetFriendWeaponType(player, e) == WeaponType.WEAPON_TECH_X then
        local pd = mod:GetEntityData(player)
        local sprite = e:GetSprite()
        local d = mod:GetEntityData(e)
        local rng = e:GetDropRNG()

        if d.FriendTechXShotCharge and d.FriendTechXShotCharge > 25 then
            pd.FriendHeldGuns[e.InitSeed].LastFrameFired = e.FrameCount
            if not mod.FriendGunInfo[e.SubType].CustomAnim then
                sprite:Play("Shoot", true)
            end
            d.state = "Shoot"
            local vel = aim:Resized(5*player.ShotSpeed)
            if not (pd.LastFiredMouse and mod.MouseGunAiming == 1) then
                vel = vel + player:GetTearMovementInheritance(aim)
            end

            local shot = mod:GetFriendGunNextShot(e)

            local laser
			local numFired = 0

            -- Blue Lyre Tweak
            if (player:HasCollectible(mod.ITEM.COLLECTIBLE.ANGELIC_LYRE_B) or (player:HasCollectible(CollectibleType.COLLECTIBLE_VOID) and pd.ffsavedata.VoidedLyre == 1)) and math.floor(pd.BlueLyreShot or 0) == 0 then
                local cloud = Isaac.Spawn(1000, mod.FF.FFWhiteSmoke.Var, mod.FF.FFWhiteSmoke.Sub, player.Position + aim:Resized(20), aim:Resized(10), player)
                mod:GetEntityData(cloud).longonly = true
                cloud.SpriteOffset = Vector(0, -8)
                cloud:Update()
            else
                laser = mod:FireFriendTechX(e, player, aim, Vector.Zero, vel, shot, false, d.FriendTechXShotCharge)
                TearFlagsLib.SetTearFlagParams(laser, mod.FriendBulletFlags.FRIEND, {Charge = d.FriendTechXShotCharge})
				numFired = numFired + 1
            end

            if player:HasCollectible(CollectibleType.COLLECTIBLE_MONSTROS_LUNG) then
                local minimum = 2 + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MONSTROS_LUNG)
                local maximum = 3 + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MONSTROS_LUNG) * 2
                local extraShots = mod:RandomInt(minimum, maximum)
                for i=1, extraShots do
                    local newVel = vel:Rotated(mod:RandomInt(-30,30)) * mod:RandomFloat(0.6, 0.95)
                    mod:FireFriendTechX(e, player, aim, Vector.Zero, newVel, shot, false, math.ceil(d.FriendTechXShotCharge * 0.5))
                end
				numFired = numFired + extraShots
            end

            if pd.customChargeBarSprites and pd.customChargeBarSprites[CollectibleType.COLLECTIBLE_TECH_X] and pd.customChargeBarTable then
                for key,entry in pairs(pd.customChargeBarTable) do
                    if entry.id == CollectibleType.COLLECTIBLE_TECH_X then
                        entry.spriteFrame = 0
                    end
                end
            end
			
			if numFired > 0 then
				local _, _, owner = mod:GetFriendGunPlayer(e)
				mod:FriendSecondaryFire(player, aim, 1, owner, e, {shot}, {NumTears = numFired, WeaponCharge = math.ceil((d.FriendTechXShotCharge * 67/7500 + 8/75) * player.MaxFireDelay * 3)})
			end

            if laser then
                Isaac.RunCallbackWithParam("POST_GUN_FIRE", e.SubType, e, player, aim, {shot}, false, {laser})
                mod:SubtractLimitedAmmo(d)
            end
        end

        d.DontReloadNewRoom = false
        d.FriendTechXShotCharge = nil

        if not d.NoReload and #pd.FriendHeldGuns[e.InitSeed].Ammo == 0 then
            d.state = "Reload"
            d.substate = "Begin"
        end
    end
end
mod:AddCallback("GUN_HOLD_RELEASE", mod.TryFireFriendTechXGun)

mod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, function(_, laser)
    if (TearFlagsLib.HasTearFlags(laser, mod.FriendBulletFlags.FRIEND) or TearFlagsLib.HasTearFlags(laser, mod.FriendBulletFlags.AMMO_CLIP))
    and TearFlagsLib.GetTearFlagParams(laser, mod.FriendBulletFlags.FRIEND).IsTechX then
        local player = TearFlagsLib.GetTearPlayer(laser)
        local num = math.min(100, TearFlagsLib.GetTearFlagParams(laser, mod.FriendBulletFlags.FRIEND).Charge or TearFlagsLib.GetTearFlagParams(laser, mod.FriendBulletFlags.AMMO_CLIP).Charge or 50)
        local freq = math.floor(6+(100-num)/6)

        if player and player.Type == EntityType.ENTITY_PLAYER and not TearFlagsLib.HasTearFlags(laser, mod.FriendBulletFlags.ETERNAL) and 
		   laser.FrameCount % freq == 0 and not TearFlagsLib.GetTearFlagParams(laser, mod.FriendBulletFlags.FRIEND).NoLasers 
		then
            local dist = 80+num
            local firstDist = 80+num
            local chosen
            for _, enemy in ipairs(Isaac.FindInRadius(laser.Position, firstDist, EntityPartition.ENEMY)) do
                if enemy:IsActiveEnemy() and (not mod:isFriend(enemy)) and enemy:IsVulnerableEnemy() and not enemy:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) then
                    if enemy.Position:Distance(laser.Position) < dist then
                        dist = enemy.Position:Distance(laser.Position)
                        chosen = enemy
                    end
                end
            end

            if chosen then
				local flag = (TearFlagsLib.HasTearFlags(laser, mod.FriendBulletFlags.FRIEND) and mod.FriendBulletFlags.FRIEND) or 
				             (TearFlagsLib.HasTearFlags(laser, mod.FriendBulletFlags.AMMO_CLIP) and mod.FriendBulletFlags.AMMO_CLIP) or
				             nil
				if flag then
					local angle = (chosen.Position-laser.Position):GetAngleDegrees()
					local laser2 = EntityLaser.ShootAngle(2, laser.Position, angle, 1, Vector.Zero, player)
					laser2.CollisionDamage = laser.CollisionDamage
					laser2.DisableFollowParent = true
					local params = TearFlagsLib.GetTearFlagParams(laser, flag)
					TearFlagsLib.AddTearFlags(laser2, flag)
					TearFlagsLib.SetTearFlagParams(laser2, flag, {NoRemove = true, Shot = params.Shot, Gun = params.Gun})
					if params.Shot then
						mod:ApplyFriendLaserShotEffects(laser2, player, params.Shot)
					end
					laser2.MaxDistance = chosen.Position:Distance(laser.Position)
					laser2.Color = laser.Color
				end
            end
        end
    end
end)

function mod.FriendTechXBarAnimFunc(player, d, sprite, entry)
    if entry then
        local pd = mod:GetEntityData(player)

        if not entry.timer then
            entry.timer = 0
            entry.initialDelay = 0
            entry.chargeLayer = 1
        end

        if entry.timer < 0 and mod.IsPlayerShootingOrMarked(player) then
            entry.timer = 0
        end

        --local guns = mod:GetGunsOfSubtype(player, CollectibleType.COLLECTIBLE_TECH_X)
        local guns = mod:GetGunsWithSynergy(player, CollectibleType.COLLECTIBLE_TECH_X)
        if mod.IsPlayerShootingOrMarked(player) and guns[1] then
            local gun = guns[1]
            local gd = mod:GetEntityData(gun.Gun)
            if gd.FriendTechXShotCharge then
                gd.FriendTechXShotCharge = math.min(100, gd.FriendTechXShotCharge+10/player.MaxFireDelay)
                entry.spriteFrame = math.min(100, math.ceil(gd.FriendTechXShotCharge))
                -- Sync other guns
                for initseed, gTab in pairs(pd.FriendHeldGuns) do
                    if gTab.Gun and gTab.Gun:Exists() and mod:GetEntityData(gTab.Gun).FriendTechXShotCharge then
                        mod:GetEntityData(gTab.Gun).FriendTechXShotCharge = gd.FriendTechXShotCharge
                    end
                end
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

function mod.FriendTechXBarRenderConditionFunc(player, d, entry)
	--local guns = mod:GetGunsOfSubtype(player, CollectibleType.COLLECTIBLE_TECH_X)
	local guns = mod:GetGunsWithSynergy(player, CollectibleType.COLLECTIBLE_TECH_X)
	local anyNotReloading = false
	for _, gun in ipairs(guns) do
		anyNotReloading = anyNotReloading or mod:GetEntityData(gun.Gun).state ~= "Reload"
	end
	return mod.IsPlayerShootingOrMarked(player) and #guns > 0
		and not (mod:GetEntityData(player).FriendMarkedSoyReloading and not anyNotReloading)
end
