-- Hypno Ring --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local drowsyDuration = 40
local baseSleepDuration = 120

local chanceDivider = 25
local baseChanceVal = 5
local minChanceVal = 1
local maxChanceVal = 25/3
local maxChanceAtLuck = 10
local scaledChanceMult = (maxChanceVal - baseChanceVal) / maxChanceAtLuck

local tearcolor = Color(0.25, 0.2, 0.6, 1.0, 20/255, 20/255, 40/255)
local lasercolor = Color(1.4, 1.4, 1.4, 1.0, 0/255, 0/255, 0/255, 0.9, 0.8, 2.4, 1)

local function isHypnoRingUseSuccessful(player)
	local chance = (baseChanceVal * player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.HYPNO_RING)) + math.min(player.Luck, maxChanceAtLuck) * scaledChanceMult
	chance = math.min(math.max(minChanceVal, chance), maxChanceVal)
	if math.random() * chanceDivider <= chance then
		return true
	end
end

local function getStackedHypnoRingDuration(player, secondHandMultiplier)
	local base = baseSleepDuration
	local result = math.ceil(base * (math.log(math.max(1, player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.HYPNO_RING)), 10) + 1))
	return result * secondHandMultiplier
end

function mod:hypnoRingLaserColor(player)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.HYPNO_RING) then
		player.LaserColor = player.LaserColor * lasercolor
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_EVALUATE_CACHE, FiendFolio.ITEM.COLLECTIBLE.HYPNO_RING, mod.hypnoRingLaserColor, CacheFlag.CACHE_TEARCOLOR)

function mod:hypnoRingFlagGeneric(entity, player, weaponFlag)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.HYPNO_RING) then
		if isHypnoRingUseSuccessful(player) then
			local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
			FiendFolio.FlagDrowsy(entity, drowsyDuration, getStackedHypnoRingDuration(player, secondHandMultiplier))
			
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
mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, FiendFolio.ITEM.COLLECTIBLE.HYPNO_RING, mod.hypnoRingFlagGeneric)

function mod:hypnoRingFlagLocust(entity, player, weaponFlag)
	if player:GetCollectibleRNG(FiendFolio.ITEM.COLLECTIBLE.HYPNO_RING):RandomFloat() < 0.2 then
		local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
		FiendFolio.FlagDrowsy(entity, drowsyDuration, baseSleepDuration * secondHandMultiplier)
	end
end
mod:AddEntityCallback(TearFlagsLib.Callback.POLL_LOCUST_TEARFLAGS, EntityType.ENTITY_FAMILIAR, FamiliarVariant.ABYSS_LOCUST, 
                      FiendFolio.ITEM.COLLECTIBLE.HYPNO_RING, mod.hypnoRingFlagLocust, FiendFolio.ITEM.COLLECTIBLE.HYPNO_RING)

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.HYPNO_RING] = {
	BodyColor = Color(1,1,1,1,132.221/255,10.699/255,7.442/255,0.372,0.735,0.743,1),
	EyeAColor = Color(1,1,1,1,26.903/255,-51.832/255,-51.832/255,0.796,0.442,0.442,1),
	EyeBColor = Color(1,1,1,1,26.903/255,-51.832/255,-51.832/255,0.796,0.442,0.442,1)}
	
mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	if math.random() * 25 <= 5 then
		local player = familiar.Player
		local secondHandMultiplier = ((player and player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND)) or 0) + 1
		FiendFolio.FlagDrowsy(tear, drowsyDuration, baseSleepDuration * secondHandMultiplier)
		
		tear.Color = Color(0.25, 0.2, 0.6, 1.0, 20/255, 20/255, 40/255)
		
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
end, FiendFolio.ITEM.COLLECTIBLE.HYPNO_RING)