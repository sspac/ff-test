local mod = FiendFolio
local sfx = SFXManager()

--[[local function getNumDadItems(player)
    local itemCount = 0
    for i = 1, #mod.DadItems do
        itemCount = itemCount + player:GetCollectibleNum(mod.DadItems[i])
    end
    return itemCount
end]]

function mod:handleDadTransformation(player, amount)
    local eff = player:GetEffects()
    if amount == 1 then
        player:AddNullItemEffect(mod.ITEM.NULL.NORAD_DAD_TRANSFORMATION_TRACKER, true)
    elseif amount == -1 then
        eff:RemoveNullEffect(mod.ITEM.NULL.NORAD_DAD_TRANSFORMATION_TRACKER, 1)
    end

    local isDad = eff:HasNullEffect(mod.ITEM.NULL.DAD_TRANSFORMATION)
    if eff:GetNullEffectNum(mod.ITEM.NULL.NORAD_DAD_TRANSFORMATION_TRACKER) >= 3 then
        if not isDad then
            player:AddNullItemEffect(mod.ITEM.NULL.DAD_TRANSFORMATION, true)
            Game():GetHUD():ShowItemText("Who's your daddy?")
            sfx:Play(SoundEffect.SOUND_POWERUP_SPEWER)
            mod.scheduleForUpdate(function()
                sfx:Play(mod.Sounds.DadsDipDeath, 0.2, 0, false, 1)
            end, 90, ModCallbacks.MC_POST_RENDER, true)
            Isaac.Spawn(1000,15,0,player.Position,Vector.Zero,player)

			if not FiendFolio.ACHIEVEMENT.IM_SORRY_ISAAC:IsUnlocked(true) then
				FiendFolio.ACHIEVEMENT.IM_SORRY_ISAAC:Unlock()
			end
        end
    else --Based on how mom transformation works
        if isDad then
            eff:RemoveNullEffect(mod.ITEM.NULL.DAD_TRANSFORMATION, eff:GetNullEffectNum(mod.ITEM.NULL.DAD_TRANSFORMATION))
        end
    end
end

function mod:dadTransformationCheckItemAdded(collectibleType, charge, firstTime, slot, varData, player)
    if firstTime then
        mod:handleDadTransformation(player, 1)
    end
end
function mod:dadTransformationCheckItemRemoved(player, collectibleType, removeForm)
    --Procs before POST_ADD_COLLECTIBLE, so scheduling or else you can pick up dad's key and get a double up
    mod.scheduleForUpdate(function()
        if removeForm then
            mod:handleDadTransformation(player, -1)
        end
    end, 0, ModCallbacks.MC_POST_RENDER, true)
end

mod:AddPriorityCallback(ModCallbacks.MC_POST_MODS_LOADED, math.huge, function()
	for i = 1, #FiendFolio.DadItems do
		mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.dadTransformationCheckItemAdded, FiendFolio.DadItems[i])
		mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, mod.dadTransformationCheckItemRemoved, FiendFolio.DadItems[i])
	end
end)
if ModReloadDetector.ModsLoaded then
	for i = 1, #FiendFolio.DadItems do
		mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.dadTransformationCheckItemAdded, FiendFolio.DadItems[i])
		mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, mod.dadTransformationCheckItemRemoved, FiendFolio.DadItems[i])
	end
end

local function SpawnTempDadGun(player)
	local pData = mod:GetEntityData(player)
	local gun = mod:SpawnFriendGun(player, 41400)
	gun:ClearEntityFlags(EntityFlag.FLAG_PERSISTENT)
	local gData = mod:GetEntityData(gun)
	gData.isTemporaryGun = true
	gun.Timeout = 10
	return gun
end

local DAD_TRACKING_VEL_MULT = 5 --Tracks enemies position + this many frames of its velocity

local function DaddyNeedsATarget(player)
    local health = 0
    local chosen = nil
    local room = Game():GetRoom()
    for _, enemy in ipairs(Isaac.FindInRadius(player.Position, 1000, EntityPartition.ENEMY)) do
        if enemy:IsActiveEnemy() and (not mod:isFriend(enemy)) and enemy:IsVulnerableEnemy() then
            if enemy.HitPoints > health then
                if room:CheckLine(player.Position,enemy.Position + (enemy.Velocity * DAD_TRACKING_VEL_MULT),3,0,false,false) then
                    chosen = enemy
                    health = enemy.HitPoints
                end
            end
        end
    end
    return chosen
end

local dadGottaShoot
function mod:fireDadTransformationGun(player)
	if not dadGottaShoot then
        local d = mod:GetEntityData(player)
        if mod:RandomInt(10) == 1 then
			local target = DaddyNeedsATarget(player)
			if target then
				dadGottaShoot = true
				local vec = ((target.Position + (target.Velocity * DAD_TRACKING_VEL_MULT)) - player.Position)
				local dadGun
				if d.DadTransformationGun and d.DadTransformationGun:Exists() then
					dadGun = d.DadTransformationGun
					dadGun.Timeout = 10
				else
					dadGun = SpawnTempDadGun(player)
					d.DadTransformationGun = dadGun
				end
				local gunData = mod:GetEntityData(dadGun)
				gunData.LockAngle = vec:GetAngleDegrees()
				dadGun:Update()
				local playerDamageCache = player.Damage
				local playerShotSpeedCache = player.ShotSpeed
				local playerTearFlagsCache = player.TearFlags
				player.Damage = math.max(10, player.Damage * 3)
				player.ShotSpeed = 3
				player.TearFlags = player.TearFlags | TearFlags.TEAR_PIERCING
				mod:FireGunFriend(dadGun, vec, isHeld, false, true, "RED_HEART", true, WeaponType.WEAPON_TEARS)
				player.Damage = playerDamageCache
				player.ShotSpeed = playerShotSpeedCache
				player.TearFlags = playerTearFlagsCache
				dadGottaShoot = false
			end
			return true
        end
    end
end

mod:AddPlayerTempEffectCallback(FiendFolio.CALLBACK.FF_SECONDARY_FIRE, Isaac.GetItemConfig():GetNullItem(mod.ITEM.NULL.DAD_TRANSFORMATION), function(_, player, dir, amount, owner, params)
	if player:GetEffects():HasNullEffect(mod.ITEM.NULL.DAD_TRANSFORMATION) then
		mod.IgnoreSecondaryFireEffects = true
		mod:fireDadTransformationGun(player)
		mod.IgnoreSecondaryFireEffects = false
	end
end)