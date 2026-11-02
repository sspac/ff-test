-- Lunatic Eye --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local tearcolor = Color(-1, -1, -1, 1, 0.67, 0.41, 0.89)
local lasercolor = Color(1.0, 1.0, 1.0, 1.0, 0/255, 0/255, 0/255, 3.24, 1.86, 4.39, 1)

local function isLunaticEyeUseSuccessful(player)
	local chance = (1/15) + (player:GetTrinketMultiplier(mod.ITEM.TRINKET.LUNATIC_EYE) - 1) * (1/30) + player.Luck / 16 * (2/15)
	chance = math.min(0.2, chance)
	if math.random() <= chance then
		return true
	end
end

local function getStackedLunaticEyeDuration(player, secondHandMultiplier)
	local base = 180 
	local result = math.ceil(base * (math.log(math.max(1, player:GetTrinketMultiplier(mod.ITEM.TRINKET.LUNATIC_EYE)), 5) + 1))
	return result * secondHandMultiplier
end

function mod:lunaticEyeLaserColor(player, flag)
	if player:HasTrinket(FiendFolio.ITEM.TRINKET.LUNATIC_EYE) then
		player.LaserColor = player.LaserColor * lasercolor
	end
end
mod:AddTrinketCallback(ModCallbacks.MC_EVALUATE_CACHE, FiendFolio.ITEM.TRINKET.LUNATIC_EYE, mod.lunaticEyeLaserColor, CacheFlag.CACHE_TEARCOLOR)

function mod:lunaticEyeFlagGeneric(entity, player, weaponFlag)
	if weaponFlag == TearFlagsLib.WeaponFlag.DARK_ARTS or weaponFlag == TearFlagsLib.WeaponFlag.OCULAR_RIFT then return end
	
	if player:HasTrinket(FiendFolio.ITEM.TRINKET.LUNATIC_EYE) then
		if isLunaticEyeUseSuccessful(player) then
			local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
			FiendFolio.FlagBerserk(entity, getStackedLunaticEyeDuration(player, secondHandMultiplier))
			
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
mod:AddTrinketCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, FiendFolio.ITEM.TRINKET.LUNATIC_EYE, mod.lunaticEyeFlagGeneric)

function mod:lunaticEyeFlagOnDamage(entity)
	local data = mod:GetEntityData(entity)
	local frame = game:GetFrameCount()
	if data.RolledForLunaticEye ~= frame then
		data.RolledForLunaticEye = frame
		
		local player = TearFlagsLib.GetTearPlayer(entity)
		if player and player:HasTrinket(FiendFolio.ITEM.TRINKET.LUNATIC_EYE) then
			if isLunaticEyeUseSuccessful(player) then
				local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
				FiendFolio.FlagBerserk(entity, getStackedLunaticEyeDuration(player, secondHandMultiplier))
			end
		end
	end
end

function mod:lunaticEyeFlagDarkArts(snare)

end