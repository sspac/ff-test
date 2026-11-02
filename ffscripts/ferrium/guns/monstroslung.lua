local mod = FiendFolio
local sfx = SFXManager()

mod:AddCallback("PRE_GUN_FIRE", function(_, e, player, aim, held)
    if mod:GetFriendWeaponType(player, e) == WeaponType.WEAPON_MONSTROS_LUNGS then
        local pd = mod:GetEntityData(player)
        local d = mod:GetEntityData(e)

        local gunTable = pd.FriendHeldGuns[e.InitSeed]
        if not d.monstrosLungPlannedShots and #gunTable.Ammo > 0 then
            d.monstrosLungLoaded = {}
            d.monstrosLungPlannedShots = #mod:GetFriendAmmo(e, true)
            d.monstrosLungAmmoSpent = 0
        end

        local rng = e:GetDropRNG()
        pd.FriendHeldGuns[e.InitSeed].LastFrameFired = e.FrameCount
        d.DontReloadNewRoom = true

        local markedOrSoy = mod.IsPlayerMarkedFiring(player) or mod.HasSoyOrAlmondMilk(player)

        if markedOrSoy and (d.FriendMarkedSoyLetGo or #gunTable.Ammo == 0) and d.monstrosLungLoaded and #d.monstrosLungLoaded > 0 then
            mod:ReleaseMonstrosLungGun(e, player, aim)
        elseif #gunTable.Ammo > 0 then
            if d.state == "Reload" then
                d.state = "Idle"
            end
            sfx:Play(SoundEffect.SOUND_SCAMPER, 0.5, 0, false, 0.8 + (12 - #gunTable.Ammo) * 0.2)

            local shot = mod:GetFriendGunNextShot(e)
            table.insert(d.monstrosLungLoaded, shot)
            if #gunTable.Ammo == 1 then
                for i=1,math.ceil(d.monstrosLungPlannedShots/2) do
                    table.insert(d.monstrosLungLoaded, shot)
                end
            end

            if pd.customChargeBarSprites and pd.customChargeBarSprites[CollectibleType.COLLECTIBLE_MONSTROS_LUNG] and pd.customChargeBarTable and d.monstrosLungPlannedShots then
                for key,entry in pairs(pd.customChargeBarTable) do
                    if entry.id == CollectibleType.COLLECTIBLE_MONSTROS_LUNG then
                        entry.spriteFrame = math.floor((d.monstrosLungPlannedShots-#gunTable.Ammo)/d.monstrosLungPlannedShots*100)
                        d.monstrosLungAmmoSpent = (d.monstrosLungPlannedShots-#gunTable.Ammo)
                    end
                end
            end
        elseif not held or not d.monstrosLungLoaded or #d.monstrosLungLoaded == 0 then
            if d.state ~= "Reload" then
                d.state = "Reload"
                d.substate = "Begin"
                d.reloadOverride = true

                d.monstrosLungLoaded = nil
                d.monstrosLungPlannedShots = nil
            end
        end

        return true
    end
end)

function mod:ReleaseMonstrosLungGun(e, player, aim)
    if mod:GetFriendWeaponType(player, e) == WeaponType.WEAPON_MONSTROS_LUNGS then
        local pd = mod:GetEntityData(player)
        local sprite = e:GetSprite()
        local d = mod:GetEntityData(e)
        local rng = e:GetDropRNG()

        local vel = aim:Resized(10*player.ShotSpeed)
        if not (pd.LastFiredMouse and mod.MouseGunAiming == 1) then
            vel = vel + player:GetTearMovementInheritance(aim)
        end

        local count = (d.monstrosLungLoaded and #d.monstrosLungLoaded) or 0
        
        mod.FriendGunInfo[e.SubType].MuzzleScale = count * 0.1 + 0.75
        
        local tears = {}
        
        for i=1,count do
            local randVel
            local randVelPlus = mod:RandomInt(-25,25,rng)/10
            if i>1 then
                randVel = vel:Rotated(mod:RandomInt(-20,20,rng))
                randVel = randVel:Resized(randVel:Length()+randVelPlus)
            end

            local trueVel = randVel or vel:Resized(vel:Length()+randVelPlus)
            local shot = d.monstrosLungLoaded[i]
			mod.SecondaryFireTearEffectFriendGun = e
			mod.SecondaryFireTearEffectFriendAmmoUsed = d.monstrosLungLoaded
            local tear = mod:FireSingleFriendShot(e, aim, Vector.Zero, trueVel, shot, true)
			mod.SecondaryFireTearEffectFriendGun = nil
			mod.SecondaryFireTearEffectFriendAmmoUsed = nil
            
            if mod.FriendGunInfo[e.SubType].Ejection then
                mod:SpawnCasing(e, player)
            end
            
            if tear and tear:ToTear() then
                tear.Velocity = trueVel * 1.35
                local tab = {update = function(v, tab, data, key)
                    if v.Velocity:Length() > tab.minVel and v.FrameCount < 60 then
                        v.Velocity = v.Velocity*0.935
                    else
                        if key then
                            data.customTearBehavior[key] = nil
                        else
                            data.customTearBehavior = nil
                        end
                    end
                end, minVel = trueVel:Length()*0.6}
                mod:TryToAddTearBehavior(tear, mod:GetEntityData(tear), tab)
                table.insert(tears, tear)
            end
        end

        if count > 0 and d.monstrosLungLoaded then
			local _, _, owner = mod:GetFriendGunPlayer(e)
			mod:FriendSecondaryFire(player, aim, d.monstrosLungAmmoSpent, owner, e, d.monstrosLungLoaded, {NumTears = count})
			
            if not mod.FriendGunInfo[e.SubType].CustomAnim then
                sprite:Play("Shoot", true)
            end
            d.state = "Shoot"
            Isaac.RunCallbackWithParam("POST_GUN_FIRE", e.SubType, e, player, aim, d.monstrosLungLoaded, false, tears)

            mod:SubtractLimitedAmmo(d, d.monstrosLungAmmoSpent or 1)
        end

        if pd.customChargeBarSprites and pd.customChargeBarSprites[CollectibleType.COLLECTIBLE_MONSTROS_LUNG] and pd.customChargeBarTable and d.monstrosLungPlannedShots then
            for key,entry in pairs(pd.customChargeBarTable) do
                if entry.id == CollectibleType.COLLECTIBLE_MONSTROS_LUNG then
                    entry.spriteFrame = 0
                    d.monstrosLungAmmoSpent = 0
                end
            end
        end

        d.DontReloadNewRoom = false
        d.monstrosLungLoaded = nil
        d.monstrosLungPlannedShots = nil

        if not d.NoReload and #pd.FriendHeldGuns[e.InitSeed].Ammo == 0 then
            d.state = "Reload"
            d.substate = "Begin"
        end
    end
end
mod:AddCallback("GUN_HOLD_RELEASE", mod.ReleaseMonstrosLungGun)

function mod.FriendMonstrosLungBarAnimFunc(player, d, sprite, entry)
    if entry then
        if not entry.timer then
            entry.timer = 0
            entry.initialDelay = 0
            entry.chargeLayer = 1
        end

        if entry.timer < 0 and mod.IsPlayerShootingOrMarked(player) then
            entry.timer = 0
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

function mod.FriendMonstrosLungBarRenderConditionFunc(player, d, entry)
    local anySoul = false
	local anyNotReloading = false
	local guns = mod:GetGunsWithSynergy(player, CollectibleType.COLLECTIBLE_MONSTROS_LUNG)
	for _, gun in ipairs(guns) do
		if mod:IsFriendSoulGun(gun.Gun) then
			anySoul = true
			break
		end
		anyNotReloading = anyNotReloading or mod:GetEntityData(gun.Gun).state ~= "Reload"
	end
    return (
        mod.IsPlayerShootingOrMarked(player)
        and #guns > 0
        and (not player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION) or anySoul)
        and not (mod:GetEntityData(player).FriendMarkedSoyReloading and not anyNotReloading)
    )
end
