local mod = FiendFolio

local bal = {
    baseChance = 15,
    maxExtra = 15,

    drowsyTime = 25,
    sleepTime = 35,
	nightmareCountdown = 1,
	nightmareDamageMult = 2,
}

local tearcolor = Color(0.74, 0.5, 0.74, 1, 0.15, 0.07, 0.08)
local lasercolor = Color(1, 1, 1, 1, 0, 0, 0, 3.45, 2.4, 4.05, 1)

local function checkSleepyDustProc(player)
    local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.SLEEPY_DUST)
	local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.SLEEPY_DUST)
    local chance = bal.baseChance*mult+mod.XalumLuckBonus(player.Luck, 25, bal.maxExtra/100)*100
    if rng:RandomInt(100) < chance then
        return true
    end
end

function mod:sleepyDustFlagGeneric(entity, player, weaponFlag)
	if player:HasTrinket(FiendFolio.ITEM.TRINKET.SLEEPY_DUST) then
		if checkSleepyDustProc(player) then
			local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
			FiendFolio.FlagDrowsy(entity, bal.drowsyTime, bal.sleepTime*secondHandMultiplier, bal.nightmareCountdown, bal.nightmareDamageMult)
			
			if weaponFlag == TearFlagsLib.WeaponFlag.AQUARIUS then
				mod:GetEntityData(entity).FFAquariusTearColor = tearcolor
			elseif weaponFlag == TearFlagsLib.WeaponFlag.EPIC_FETUS or weaponFlag == TearFlagsLib.WeaponFlag.CLUB_EPIC_FETUS then
				mod:GetEntityData(entity).FFExplosionColor = tearcolor
			elseif weaponFlag == TearFlagsLib.WeaponFlag.LASER or 
			       weaponFlag == TearFlagsLib.WeaponFlag.ANTI_GRAV_LASER or 
			       weaponFlag == TearFlagsLib.WeaponFlag.KNIFE or
			       weaponFlag == TearFlagsLib.WeaponFlag.DARK_ARTS or
			       weaponFlag == TearFlagsLib.WeaponFlag.LOCUST or
			       weaponFlag == TearFlagsLib.WeaponFlag.UMBILICAL_WHIP or
			       weaponFlag == TearFlagsLib.WeaponFlag.BRIMSTONE_BALL or
			       weaponFlag == TearFlagsLib.WeaponFlag.BOBS_ROTTEN_HEAD or
			       weaponFlag == TearFlagsLib.WeaponFlag.SHARP_KEY or
			       weaponFlag == TearFlagsLib.WeaponFlag.OCULAR_RIFT or
			       weaponFlag == TearFlagsLib.WeaponFlag.HEMOPTYSIS
			then
				return
			else
				entity.Color = tearcolor
			end
		end
	end
end
mod:AddTrinketCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, FiendFolio.ITEM.TRINKET.SLEEPY_DUST, mod.sleepyDustFlagGeneric)