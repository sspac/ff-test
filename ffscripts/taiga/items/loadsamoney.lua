-- Loadsamoney --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local baseDuration = 90

local chanceDivider = 8
local baseChanceVal = 2
local minChanceVal = 0.5
local maxChanceVal = 8
local maxChanceAtLuck = 25
local scaledChanceMult = (maxChanceVal - baseChanceVal) / maxChanceAtLuck

local tearcolor = Color(1.1, 1.1, 1.1, 1.0, -5/255, -5/255, -5/255, 1.0, 0.75, 0.45, 1)
local lasercolor = Color(1.0, 1.0, 1.0, 1.0, 0/255, 0/255, 0/255, 3.5, 2.625, 1.575, 1)

local function isLoadsamoneyUseSuccessful(player)
	local chance = (baseChanceVal * player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.LOADSAMONEY)) + player.Luck * scaledChanceMult
	chance = math.min(math.max(minChanceVal, chance), maxChanceVal)
	if math.random() * maxChanceVal <= chance then
		return true
	end
end

local function getStackedLoadsamoneyDuration(player, secondHandMultiplier)
	local base = baseDuration
	local result = math.ceil(base * (math.log(math.max(1, player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.LOADSAMONEY)), 5) + 1))
	return result * secondHandMultiplier
end

function mod:loadsamoneyLaserColor(player, flag)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.LOADSAMONEY) then
		player.LaserColor = player.LaserColor * lasercolor
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_EVALUATE_CACHE, FiendFolio.ITEM.COLLECTIBLE.LOADSAMONEY, mod.loadsamoneyLaserColor, CacheFlag.CACHE_TEARCOLOR)

function mod:loadsamoneyFlagGeneric(entity, player, weaponFlag)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.LOADSAMONEY) then
		if isLoadsamoneyUseSuccessful(player) then
			local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
			FiendFolio.FlagMug(entity, getStackedLoadsamoneyDuration(player, secondHandMultiplier))

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
mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, FiendFolio.ITEM.COLLECTIBLE.LOADSAMONEY, mod.loadsamoneyFlagGeneric)

function mod:loadsamoneyFlagLocust(entity, player, weaponFlag)
	if player:GetCollectibleRNG(FiendFolio.ITEM.COLLECTIBLE.LOADSAMONEY):RandomFloat() < 0.2 then
		local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
		FiendFolio.FlagMug(entity, baseDuration * secondHandMultiplier)
	end
end
mod:AddEntityCallback(TearFlagsLib.Callback.POLL_LOCUST_TEARFLAGS, EntityType.ENTITY_FAMILIAR, FamiliarVariant.ABYSS_LOCUST,
                      FiendFolio.ITEM.COLLECTIBLE.LOADSAMONEY, mod.loadsamoneyFlagLocust, FiendFolio.ITEM.COLLECTIBLE.LOADSAMONEY)

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.LOADSAMONEY] = {
	BodyColor = Color(1,1,1,1,47.726/255,15.239/255,8.770/255,0.699,0.681,-0.027,1),
	EyeAColor = Color(1,1,1,1,-19.703/255,-29.469/255,-20.719/255,0.297,0.531,0.281,1),
	EyeBColor = Color(1,1,1,1,-19.703/255,-29.469/255,-20.719/255,0.297,0.531,0.281,1),}

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	if math.random() * 8 <= 2 then
		local player = familiar.Player
		local secondHandMultiplier = ((player and player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND)) or 0) + 1
		FiendFolio.FlagMug(tear, 90 * secondHandMultiplier)
		tear.Color = Color(1.1, 1.1, 1.1, 1.0, -5/255, -5/255, -5/255, 1.0, 0.75, 0.45, 1)

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
end, FiendFolio.ITEM.COLLECTIBLE.LOADSAMONEY)

local checkingForSpawnsFromShopkeeper = false
local shopkeeperSpawnedStuff = false

mod:AddPriorityCallback(ModCallbacks.MC_PRE_NPC_UPDATE, math.huge, function(_, shopkeeper)
	if shopkeeper:IsDead() then
		local variant = shopkeeper.Variant
		if variant == 0 or variant == 1 or variant == 2 then
			checkingForSpawnsFromShopkeeper = true
			shopkeeperSpawnedStuff = false
		end
	end
end, EntityType.ENTITY_SHOPKEEPER)

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, shopkeeper)
	local savedata = FiendFolio.savedata.run
	if shopkeeper:IsDead() and not savedata.LoadsamoneyHasSpawned
	and mod.ACHIEVEMENT.LOADSAMONEY:IsUnlocked()
	then
		local variant = shopkeeper.Variant
		if variant == 0 or variant == 1 or variant == 2 then
			checkingForSpawnsFromShopkeeper = false
			if not shopkeeperSpawnedStuff then
				local rng = RNG()
				rng:SetSeed(shopkeeper.DropSeed, 53)
				if rng:RandomFloat() <= 0.01 then
					Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, FiendFolio.ITEM.COLLECTIBLE.LOADSAMONEY, shopkeeper.Position, nilvector, nil)
					game:GetItemPool():RemoveCollectible(FiendFolio.ITEM.COLLECTIBLE.LOADSAMONEY)
					savedata.LoadsamoneyHasSpawned = true
				end
			end
			shopkeeperSpawnedStuff = false
		end
	end
end, EntityType.ENTITY_SHOPKEEPER)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, -1 * math.huge, function(_, typ, var, subt, pos, vel, spawner, seed)
	if checkingForSpawnsFromShopkeeper then
		if typ == EntityType.ENTITY_SPIDER or typ == EntityType.ENTITY_STRIDER then
			shopkeeperSpawnedStuff = true
		elseif typ == EntityType.ENTITY_PICKUP and var == PickupVariant.PICKUP_COIN then
			shopkeeperSpawnedStuff = true
		elseif typ == EntityType.ENTITY_PICKUP and var == PickupVariant.PICKUP_COLLECTIBLE and (subt == CollectibleType.COLLECTIBLE_STEAM_SALE or
		                                                                                        subt == CollectibleType.COLLECTIBLE_HEAD_OF_THE_KEEPER or
		                                                                                        subt == CollectibleType.COLLECTIBLE_COUPON)
		then
			shopkeeperSpawnedStuff = true
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, collectible)
	if collectible.SubType == FiendFolio.ITEM.COLLECTIBLE.LOADSAMONEY then
		local savedata = FiendFolio.savedata.run
		savedata.LoadsamoneyHasSpawned = true
	end
end, PickupVariant.PICKUP_COLLECTIBLE)