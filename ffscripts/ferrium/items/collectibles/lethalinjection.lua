local mod = FiendFolio

local bal = {
    baseChance = 15,
    maxExtra = 15,

    ExecuteTimer = 400,
    ExecuteFlat = 20,
    ExecuteMult = 5,
}

local tearcolor = Color(0.74, 0.4, 0.4, 1, 0.15, 0.04, 0.04)

local function checkLethalInjectionProc(player)
    local mult = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.LETHAL_INJECTION)
	local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.LETHAL_INJECTION)
    local chance = bal.baseChance*mult+mod.XalumLuckBonus(player.Luck, 25, bal.maxExtra/100)*100
    if rng:RandomInt(100) < chance then
        return true
    end
end

function mod:lethalInjectionFlagGeneric(entity, player, weaponFlag)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.LETHAL_INJECTION) then
		if checkLethalInjectionProc(player) then
			FiendFolio.FlagSentenced(entity, bal.ExecuteTimer, player.Damage*bal.ExecuteMult+bal.ExecuteFlat)
			
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
mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, FiendFolio.ITEM.COLLECTIBLE.LETHAL_INJECTION, mod.lethalInjectionFlagGeneric)