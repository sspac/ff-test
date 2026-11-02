local mod = FiendFolio
local game = Game()

local kalusEye = mod.ITEM.COLLECTIBLE.KALUS_EYE
local BASE_CHANCE = 0.15
local MAX_CHANCE = 0.50
local LUCK_THRESHOLD = 17

local TEAR_COLOUR = Color(0, 0.75, 1, 1, 0.5, 0.5, 0.5)
local LASER_COLOUR = Color(1, 1, 1, 1, 0, 0, 0, 2.3, 4.6, 4.65, 1)
local STATUS_DURATION = 150

TearFlagsLib.RegisterTearFlag("FF_KALUS_EYE")

local function shouldDoKalusEye(player, entity)
	local luck = TearFlagsLib.GetRealLuck(player, entity)
	local chance = TearFlagsLib.GetChance(luck, BASE_CHANCE, MAX_CHANCE, LUCK_THRESHOLD, player:GetCollectibleNum(kalusEye))
	local rng = player:GetCollectibleRNG(kalusEye)
	return rng:RandomFloat() < chance
end

local function addKalusEyeColor(entity, weaponFlag)
	if weaponFlag == TearFlagsLib.WeaponFlag.AQUARIUS then
		mod:GetEntityData(entity).FFAquariusTearColor = TEAR_COLOUR
	elseif TearFlagsLib.IsWeaponEpicFetusVariant(weaponFlag) then
		mod:GetEntityData(entity).FFExplosionColor = TEAR_COLOUR
	elseif TearFlagsLib.ShouldWeaponGainEntityColor(weaponFlag) then
		entity.Color = TEAR_COLOUR
	end
end

mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, kalusEye, function(_, entity, player, weaponFlag)
	if player:HasCollectible(kalusEye) and shouldDoKalusEye(player, entity) then
		TearFlagsLib.AddTearFlags(entity, TearFlagsLib.Flag.FF_KALUS_EYE)
		addKalusEyeColor(entity, weaponFlag)
	end
end)

mod:AddEntityCallback(TearFlagsLib.Callback.POLL_LOCUST_TEARFLAGS, EntityType.ENTITY_FAMILIAR, FamiliarVariant.ABYSS_LOCUST, kalusEye, function(_, entity, player)
	if player:GetCollectibleRNG(kalusEye):RandomFloat() < MAX_CHANCE then
		TearFlagsLib.AddTearFlags(entity, TearFlagsLib.Flag.FF_KALUS_EYE)
	end
end, kalusEye)

mod:AddCollectibleCallback(ModCallbacks.MC_EVALUATE_CACHE, kalusEye, function(_, player)
	if player:HasCollectible(kalusEye) then
		player.LaserColor = player.LaserColor * LASER_COLOUR
	end
end, CacheFlag.CACHE_TEARCOLOR)

mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, function(_, entity, player, source, weaponFlag)
	mod.AddTracedStatus(entity, STATUS_DURATION * (player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1))
end, TearFlagsLib.Flag.FF_KALUS_EYE)

mod.SewingManualWhitelist[kalusEye] = {
	BodyColor = Color(1,1,1,1,9.606/255,-9.066/255,-29.813/255,0.978,1.004,1.040,1),
	EyeAColor = Color(1,1,1,1,-84.020/255,-104.393/255,-133.720/255,1.145,1.152,1.169,1),
	EyeBColor = Color(1,1,1,1,-84.020/255,-104.393/255,-133.720/255,1.145,1.152,1.169,1)}
	
mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	if familiar.Player:GetCollectibleRNG(kalusEye):RandomFloat() < BASE_CHANCE then
		TearFlagsLib.AddTearFlags(tear, TearFlagsLib.Flag.FF_KALUS_EYE, true)
		
		tear.Color = TEAR_COLOUR
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
end, kalusEye)