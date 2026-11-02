local mod = FiendFolio
local sfx = SFXManager()
local oldShell = mod.ITEM.TRINKET.OLD_SHELL
local flagsManager = TearFlagsLib

local unspreadables = {
	[WeaponType.WEAPON_ROCKETS] = true,
	[WeaponType.WEAPON_MONSTROS_LUNGS] = true,
	[WeaponType.WEAPON_LUDOVICO_TECHNIQUE] = true,
	[WeaponType.WEAPON_URN_OF_SOULS] = true,
	[WeaponType.WEAPON_SPIRIT_SWORD] = true,
	[WeaponType.WEAPON_UMBILICAL_WHIP] = true,
}

local function shouldIncreaseShots(player)
	return (
		not player:HasWeaponType(WeaponType.WEAPON_LUDOVICO_TECHNIQUE) and
		not TearFlagsLib.PlayerHasLudoKnife(player) and
		player:GetTrinketRNG(oldShell):RandomFloat() < 0.1
	)
end

function mod:canWeaponTypeSpread(weaponType)
	return not unspreadables[weaponType]
end

function mod:getWeaponSpread(weaponType)
	if weaponType == WeaponType.WEAPON_BONE then
		return 15
	end

	return 2.15
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_MULTI_SHOT_PARAMS, function(_, player, params, weaponType)
	local resetParams = false

	if player:HasTrinket(oldShell) then
		local data = mod:GetEntityData(player)
		if data.lastCheckedOldShell == player.FrameCount then 
			return data.cacheOldShellParams
		end

		if shouldIncreaseShots(player) then
			local tears = params:GetNumTears() + 4 * player:GetTrinketMultiplier(oldShell) - 1
			params:SetNumTears(tears)
			params:SetNumLanesPerEye(tears // params:GetNumEyesActive()) -- God I hope all this works properly, MultiShotParams are intimidating

			if mod:canWeaponTypeSpread(weaponType) then
				params:SetSpreadAngle(weaponType, (tears - 1) * mod:getWeaponSpread(weaponType))
			end

			data.cacheOldShellParams = params
			data.catchOldShellTears = player.FrameCount
		else
			data.cacheOldShellParams = nil
		end

		data.lastCheckedOldShell = player.FrameCount
	end
end)

local function genericReduceCollisionDamage(_, entity)
	local player = entity.SpawnerEntity and (entity.SpawnerEntity:ToPlayer() or entity.SpawnerEntity:ToFamiliar() and entity.SpawnerEntity:ToFamiliar().Player)
	if player and mod:GetEntityData(player).catchOldShellTears == player.FrameCount then
		entity.CollisionDamage = entity.CollisionDamage * 0.7
	end
end

mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, genericReduceCollisionDamage)
mod:AddCallback(ModCallbacks.MC_POST_FIRE_BOMB, genericReduceCollisionDamage)
-- mod:AddCallback(ModCallbacks.MC_POST_FIRE_SWORD, genericReduceCollisionDamage) -- Yeah man this shit's cooked
mod:AddCallback(ModCallbacks.MC_POST_FIRE_BRIMSTONE_BALL, genericReduceCollisionDamage) -- I'm going to commit so many crimes

local function genericLaserFlagDamageReduction(_, entity)
	local player = entity.SpawnerEntity and (entity.SpawnerEntity:ToPlayer() or entity.SpawnerEntity:ToFamiliar() and entity.SpawnerEntity:ToFamiliar().Player)
	if player and mod:GetEntityData(player).catchOldShellTears == player.FrameCount then
		mod:GetEntityData(entity).oldShellDamageMult = 0.7
	end
end

mod:AddPriorityCallback(ModCallbacks.MC_PRE_LASER_COLLISION, 100000, function(_, laser, entity) -- Fuck you lasers, eat shit
	if entity:IsVulnerableEnemy() and mod:GetEntityData(laser).oldShellDamageMult then
		mod:GetEntityData(entity).oldShellDamageMult = mod:GetEntityData(laser).oldShellDamageMult
	end
end)

mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CallbackPriority.EARLY, function(_, entity, amount, flags, source, cooldown)
	local data = mod:GetEntityData(entity)

	if data.oldShellDamageMult then
		local mult = data.oldShellDamageMult
		data.oldShellDamageMult = nil

		return {
			Damage = amount * mult
		}
	end
end)

function mod:oldShellResetDamageMult(npc, data)
	if data.oldShellDamageMult then
		data.oldShellDamageMult = nil
	end
end

mod:AddCallback(ModCallbacks.MC_POST_FIRE_BRIMSTONE, genericLaserFlagDamageReduction)
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TECH_LASER, genericLaserFlagDamageReduction)
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TECH_X_LASER, genericLaserFlagDamageReduction)

-- I save the day
mod:AddCallback(flagsManager.Callback.PRE_SWING_CLUB, function(_, knife, player)
	if mod:GetEntityData(player).catchOldShellTears == player.FrameCount then
		knife.CollisionDamage = knife.CollisionDamage * 0.7
	end
end)

mod:AddCallback(flagsManager.Callback.POST_THROW_KNIFE, function(_, knife, player)
	if mod:GetEntityData(player).catchOldShellTears == player.FrameCount then
		mod:GetEntityData(knife).oldShellDamageMult = 0.7
	end
end)

mod:AddCallback(flagsManager.Callback.POST_CATCH_KNIFE, function(_, knife, player)
	mod:GetEntityData(knife).oldShellDamageMult = nil
end)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_KNIFE_COLLISION, 100000, function(_, knife, entity)
	if entity:IsVulnerableEnemy() and mod:GetEntityData(knife).oldShellDamageMult then
		mod:GetEntityData(entity).oldShellDamageMult = mod:GetEntityData(knife).oldShellDamageMult
	end
end)

mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_UPDATE, function(_, player)
	local data = mod:GetEntityData(player)

	if data.catchOldShellTears and data.catchOldShellTears ~= player.FrameCount then
		mod:GetEntityData(player).catchOldShellTears = nil
	end
end)


mod:AddPriorityCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, CallbackPriority.LATE, function(_, entity, player)
	if player:HasTrinket(oldShell) and player:GetTrinketRNG(oldShell):RandomFloat() < 0.1 then
		entity = TearFlagsLib.Cast(entity)
		if not entity.FireSplitTear then end

		local bonusTears = 4 * player:GetTrinketMultiplier(oldShell)
		local angleDif = 360 / bonusTears
		local angleOffset = player:GetTrinketRNG(oldShell):RandomFloat() * 360

		for i = 1, bonusTears do
			local tear = TearFlagsLib.FireSplitTear(entity, Vector.FromAngle(angleOffset + angleDif * i) * 10 * player.ShotSpeed, player, {
				RemoveFlags = TearFlags.TEAR_LUDOVICO,
				DamageOverride = player.Damage * 0.7,
				ScaleMult = 0.5,
				SplitTearType = "FF_OldShell",
			})
		end
	end
end, TearFlagsLib.WeaponFlag.LUDOVICO_TEAR)

mod:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, function(_, knife)
	local player = TearFlagsLib.GetTearPlayer(knife)
	if player and player:HasTrinket(oldShell) and knife.FrameCount // player.MaxFireDelay ~= (knife.FrameCount - 1) // player.MaxFireDelay then
		if player:GetTrinketRNG(oldShell):RandomFloat() < 0.1 then
			local bonusTears = 4 * player:GetTrinketMultiplier(oldShell)
			local angleDif = 360 / bonusTears
			local angleOffset = player:GetTrinketRNG(oldShell):RandomFloat() * 360

			-- In a just and beautiful world this would fire the projectile knives from the Brimstone/Mom's Knife synergy
			-- Unforauntely we live in Nicalis's world

			for i = 1, bonusTears do
				local tear = TearFlagsLib.FireSplitTear(knife, Vector.FromAngle(angleOffset + angleDif * i) * 10 * player.ShotSpeed, player, {
					RemoveFlags = TearFlags.TEAR_LUDOVICO,
					DamageOverride = player.Damage * 0.7,
					ScaleMult = 0.75,
					SplitTearType = "FF_OldShell",
				})
			end
		end
	end
end)