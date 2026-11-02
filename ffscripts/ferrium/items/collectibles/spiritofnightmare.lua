local mod = FiendFolio

local bal = {
    baseChance = 15,
    maxExtra = 35,

    drowsyTime = 40,
    sleepTime = 120,
}

local tearcolor = Color(0.35, 0.35, 0.35, 1, 0, 0, 0, 0.3, 0.3, 0.3, 1)
local lasercolor = Color(1, 1, 1, 1, 0, 0, 0, 0.525, 0.525, 0.525, 1)

local function CheckSpiritOfNightmareProc(player)
    local mult = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.SPIRIT_OF_NIGHTMARE)
	local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.SPIRIT_OF_NIGHTMARE)
    local chance = bal.baseChance*mult+mod.XalumLuckBonus(player.Luck, 25, bal.maxExtra/100)*100
    if rng:RandomInt(100) < chance then
        return true
    end
end

function mod:spiritOfNightmareFlagGeneric(entity, player, weaponFlag)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.SPIRIT_OF_NIGHTMARE) then
		if CheckSpiritOfNightmareProc(player) then
			local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
			FiendFolio.FlagDrowsy(entity, bal.drowsyTime, bal.sleepTime*secondHandMultiplier)
			
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
mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, FiendFolio.ITEM.COLLECTIBLE.SPIRIT_OF_NIGHTMARE, mod.spiritOfNightmareFlagGeneric)

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.SPIRIT_OF_NIGHTMARE] = {
	BodyColor = Color(1,1,1,1,-14.265/255,-14.265/255,-14.265/255,0.347,0.347,0.347,1),
	EyeAColor = Color(1,1,1,1,-77.766/255,-39.734/255,-47.672/255,1.234,0.266,0.328,1),
	EyeBColor = Color(1,1,1,1,-77.766/255,-39.734/255,-47.672/255,1.234,0.266,0.328,1)}

local function CheckSpiritOfNightmareProcSewing(player)
    local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.SPIRIT_OF_NIGHTMARE)
    if rng:RandomInt(100) < 15 then
        return true
    end
end

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
    if CheckSpiritOfNightmareProcSewing(familiar.Player) then
		local player = familiar.Player
		local secondHandMultiplier = ((player and player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND)) or 0) + 1
		FiendFolio.FlagDrowsy(tear, bal.drowsyTime, bal.sleepTime*secondHandMultiplier, nil, nil, 3.5)

		tear.Color = tearcolor
    end
end, FiendFolio.ITEM.COLLECTIBLE.SPIRIT_OF_NIGHTMARE)