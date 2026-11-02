-- Green Apple --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local roomBaseChance = 7.5
local roomMaxChance = 15
local roomLuckScaling = 7.5/20
local roomHeartScaling = 7.5/12

local tearBaseChance = 1
local tearMaxChance = 5
local tearLuckScaling = 4/20
local tearHeartScaling = 4/24

local roomDuration = 300
local tearDuration = 120

local function getRedHpRoom(player)
	local healthtype = player:GetHealthType()
	if healthtype == HealthType.COIN then
		return player:GetMaxHearts() - player:GetHearts()
	elseif healthtype == HealthType.LOST or 
		   CustomHealthAPI.Helper.IsFoundSoul(player) or
		   player:IsCoopGhost()
	then
		return 0
	elseif player:GetPlayerType() == FiendFolio.PLAYER.CHINA then
		return 0
	else
		return CustomHealthAPI.Helper.GetAmountUnoccupiedContainers(player) * 2 + CustomHealthAPI.Helper.GetHealableRedHP(player)
	end
end

local function getRoomChance()
	local chance = roomBaseChance - roomLuckScaling
	for i=1, game:GetNumPlayers() do
		local player = Isaac.GetPlayer(i - 1)
		local collectibleNum = player:GetCollectibleNum(FiendFolio.ITEM.COLLECTIBLE.GREEN_APPLE)
		chance = chance + (collectibleNum * (1 + math.max(0, player.Luck))) * roomLuckScaling
		chance = chance + getRedHpRoom(player) * roomHeartScaling
	end
	return math.min(chance, roomMaxChance)
end

local function getTearChance(player)
	local chance = tearBaseChance - tearLuckScaling
	local collectibleNum = player:GetCollectibleNum(FiendFolio.ITEM.COLLECTIBLE.GREEN_APPLE)
	chance = chance + collectibleNum * (1 + math.max(0, player.Luck)) * tearLuckScaling
	chance = chance + getRedHpRoom(player) * tearHeartScaling
	return math.min(chance, tearMaxChance)
end

local function getLocustChance(player)
	local chance = tearBaseChance - tearLuckScaling
	local collectibleNum = player:GetCollectibleNum(FiendFolio.ITEM.COLLECTIBLE.GREEN_APPLE)
	chance = chance + (1 + math.max(0, player.Luck)) * tearLuckScaling
	chance = chance + getRedHpRoom(player) * tearHeartScaling
	return math.min(chance, tearMaxChance)
end

function mod:greenAppleNewRoom()
	local applePlayer = PlayerManager.FirstCollectibleOwner(FiendFolio.ITEM.COLLECTIBLE.GREEN_APPLE)
	if applePlayer and CustomHealthAPI.Helper.GetSavedata(applePlayer) then
		local chance = getRoomChance()
		local rng = RNG()
		local secondHandMultiplier = PlayerManager.GetTotalTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
		rng:SetSeed(game:GetRoom():GetDecorationSeed(), 66)
		for _, entity in ipairs(Isaac.GetRoomEntities()) do
			local typ = entity.Type
			if typ > 9 and typ < 1000 and not mod:isFriend(entity) then
				if rng:RandomFloat() * 100 <= chance then
					FiendFolio.AddNursing(entity, applePlayer, roomDuration * secondHandMultiplier)
				end
			end
		end
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_NEW_ROOM, FiendFolio.ITEM.COLLECTIBLE.GREEN_APPLE, mod.greenAppleNewRoom)

function mod:greenAppleLaserColor(player)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.GREEN_APPLE) then
		player.LaserColor = player.LaserColor * FiendFolio.StatusEffectColors.NursingSpawn
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_EVALUATE_CACHE, FiendFolio.ITEM.COLLECTIBLE.GREEN_APPLE, mod.greenAppleLaserColor, CacheFlag.CACHE_TEARCOLOR)

function mod:greenAppleFlagGeneric(entity, player, weaponFlag)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.GREEN_APPLE) then
		local chance = getTearChance(player)
		local rng = player:GetCollectibleRNG(FiendFolio.ITEM.COLLECTIBLE.GREEN_APPLE)
		if rng:RandomFloat() * 100 <= chance then
			local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
			FiendFolio.FlagNursing(entity, tearDuration * secondHandMultiplier)
			
			if weaponFlag == TearFlagsLib.WeaponFlag.AQUARIUS then
				mod:GetEntityData(entity).FFAquariusTearColor = FiendFolio.StatusEffectColors.NursingSpawn
			elseif weaponFlag == TearFlagsLib.WeaponFlag.EPIC_FETUS or weaponFlag == TearFlagsLib.WeaponFlag.CLUB_EPIC_FETUS then
				mod:GetEntityData(entity).FFExplosionColor = FiendFolio.StatusEffectColors.NursingSpawn
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
				entity.Color = FiendFolio.StatusEffectColors.NursingSpawn
			end
		end
	end
end
mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, FiendFolio.ITEM.COLLECTIBLE.GREEN_APPLE, mod.greenAppleFlagGeneric)

function mod:greenAppleFlagLocust(entity, player, weaponFlag)
	local chance = 0.1
	local rng = player:GetCollectibleRNG(FiendFolio.ITEM.COLLECTIBLE.GREEN_APPLE)
	if rng:RandomFloat() < chance then
		local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
		FiendFolio.FlagNursing(entity, tearDuration * secondHandMultiplier)
	end
end
mod:AddEntityCallback(TearFlagsLib.Callback.POLL_LOCUST_TEARFLAGS, EntityType.ENTITY_FAMILIAR, FamiliarVariant.ABYSS_LOCUST, 
                      FiendFolio.ITEM.COLLECTIBLE.GREEN_APPLE, mod.greenAppleFlagLocust, FiendFolio.ITEM.COLLECTIBLE.GREEN_APPLE)

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.GREEN_APPLE] = {
	BodyColor = Color(1,1,1,1,99.292/255,-69.956/255,-36.106/255,0.611,1.274,1.142,1),
	EyeAColor = Color(1,1,1,1,29.611/255,-3.611/255,33.681/255,0.186,0.814,0.425,1),
	EyeBColor = Color(1,1,1,1,29.611/255,-3.611/255,33.681/255,0.186,0.814,0.425,1)}

local function getTearChanceSewing(player)
	local chance = 1 + getRedHpRoom(player) * 4/24
	return math.min(chance, 5)
end

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	local chance = getTearChanceSewing(familiar.Player)
	local rng = familiar.Player:GetCollectibleRNG(FiendFolio.ITEM.COLLECTIBLE.GREEN_APPLE)
	if rng:RandomFloat() * 100 <= chance then
		local secondHandMultiplier = familiar.Player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
		FiendFolio.FlagNursing(tear, 120 * secondHandMultiplier)
		tear.Color = FiendFolio.StatusEffectColors.NursingSpawn
	end
end, FiendFolio.ITEM.COLLECTIBLE.GREEN_APPLE)