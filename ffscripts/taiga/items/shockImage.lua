-- Shock Image --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local baseShockTimes = 3
local shockDamageMult = 0.4
local shockRestPeriod = 45
local shockActivePeriod = 15

local chanceDivider = 30
local baseChanceVal = 5
local minChanceVal = 1
local maxChanceVal = 10
local maxChanceAtLuck = 12
local scaledChanceMult = (maxChanceVal - baseChanceVal) / maxChanceAtLuck

local tearcolor = Color(1.0, 1.0, 0.0, 1.0, 80/255, 20/255, 0/255, 1.0, 1.0, 0.0, 0.5)
local lasercolor = Color(1.0, 1.0, 1.0, 1.0, 0/255, 0/255, 0/255, 6.0, 4.2, 1.0, 1.0)

local function isShockImageUseSuccessful(player)
	local chance = baseChanceVal * player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.SHOCK_IMAGE) + player.Luck / scaledChanceMult
	chance = math.min(math.max(minChanceVal, chance), maxChanceVal)
	if math.random() * chanceDivider <= chance then
		return true
	end
end

local function getStackedShockImageTimes(player, secondHandMultiplier)
	local base = baseShockTimes
	local result = math.ceil(base * (math.log(math.max(1, player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.SHOCK_IMAGE)), 10) + 1))
	return result * secondHandMultiplier
end

function mod:shockImageLaserColor(player, flag)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.SHOCK_IMAGE) then
		player.LaserColor = player.LaserColor * lasercolor
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_EVALUATE_CACHE, FiendFolio.ITEM.COLLECTIBLE.SHOCK_IMAGE, mod.shockImageLaserColor, CacheFlag.CACHE_TEARCOLOR)

function mod:shockImageFlagGeneric(entity, player, weaponFlag)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.SHOCK_IMAGE) then
		if isShockImageUseSuccessful(player) then
			local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
			FiendFolio.FlagOverload(entity, getStackedShockImageTimes(player, secondHandMultiplier), player.Damage * shockDamageMult, shockRestPeriod, shockActivePeriod)
			
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
mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, FiendFolio.ITEM.COLLECTIBLE.SHOCK_IMAGE, mod.shockImageFlagGeneric)

function mod:shockImageFlagLocust(entity, player, weaponFlag)
	if player:GetCollectibleRNG(FiendFolio.ITEM.COLLECTIBLE.SHOCK_IMAGE):RandomFloat() < 0.2 then
		local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
		FiendFolio.FlagOverload(entity, baseShockTimes * secondHandMultiplier, player.Damage * shockDamageMult, shockRestPeriod, shockActivePeriod)
	end
end
mod:AddEntityCallback(TearFlagsLib.Callback.POLL_LOCUST_TEARFLAGS, EntityType.ENTITY_FAMILIAR, FamiliarVariant.ABYSS_LOCUST, 
                      FiendFolio.ITEM.COLLECTIBLE.SHOCK_IMAGE, mod.shockImageFlagLocust, FiendFolio.ITEM.COLLECTIBLE.SHOCK_IMAGE)

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.SHOCK_IMAGE] = {
	BodyColor = Color(1,1,1,1,-15.796/255,-15.796/255,-15.796/255,1.062,1.062,1.062,1),
	EyeAColor = Color(1,1,1,1,-31.641/255,-44.297/255,9.641/255,0.359,0.703,0.641,1),
	EyeBColor = Color(1,1,1,1,-31.641/255,-44.297/255,9.641/255,0.359,0.703,0.641,1)}

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	if math.random() * 30 <= 5 then
		local player = familiar.Player
		local secondHandMultiplier = ((player and player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND)) or 0) + 1
		FiendFolio.FlagOverload(tear, baseShockTimes * secondHandMultiplier, player.Damage * 0.4, shockRestPeriod, shockActivePeriod)
		tear.Color = Color(1.0, 1.0, 0.0, 1.0, 80/255, 20/255, 0/255, 1.0, 1.0, 0.0, 0.5)
		
		if familiar.Player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
			local tearcolor = Color(0.4, 0.15, 0.38, 1, 55/255, 5/255, 95/255)
			tear.Color = tearcolor
		end
		if mod:isSuperpositionedPlayer(familiar.Player) then
			local tearcolor = Color.Lerp(tear.Color, Color(1,1,1,1,0,0,0), 0)
			tearcolor.A = tearcolor.A / 4
			tear.Color = tearcolor
		end
	end
end, FiendFolio.ITEM.COLLECTIBLE.SHOCK_IMAGE)