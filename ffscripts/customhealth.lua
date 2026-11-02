local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

mod.ExtraHealthIconSprite = Sprite()
mod.ExtraHealthIconSprite:Load("gfx/ui/ui_ffextrahealthicons.anm2", true)

----------------------------
-- Registration
----------------------------

local immoralSplatColor = Color(1.00, 1.00, 1.00, 1.00, 0.00, 0.00, 0.00)
immoralSplatColor:SetColorize(1.75, 1.25, 2.0, 1.0)
local immoralTrailColor = Color(0.80, 0.30, 1.00, 0.40, 0.00, 0.00, 0.00)

local morbidSplatColor = Color(1.00, 1.00, 1.00, 1.00, 0.00, 0.00, 0.00)
morbidSplatColor:SetColorize(0.75, 0.75, 0.5, 1.0)
local morbidTrailColor = Color(0.50, 0.55, 0.20, 0.40, 0.00, 0.00, 0.00)

local foolsGoldSplatColor = Color(1.00, 0.50, 0.90, 1.00, 0.20, 0.10, 0.40)
foolsGoldSplatColor:SetColorize(1.2, 0.6, 0.9, 1.0)
local foolsGoldTrailColor = Color(1.00, 0.50, 1.00, 0.40, 0.20, 0.00, 0.50)

local stevenSplatColor = Color(0, 0, 0, 1.00, 0, 0, 0)
local stevenTrailColor = Color(0, 0, 0, 1.00, 0, 0, 0)

CustomHealthAPI.Library.RegisterSoulHealth("IMMORAL_HEART", {
	AnimationFilename = "gfx/ui/immoral_hearts.anm2",
	AnimationName = {"ImmoralHeartHalf", "ImmoralHeartFull"},
	SortOrder = 100,
	AddPriority = 125,
	HealFlashRO = 80/255,
	HealFlashGO = 30/255,
	HealFlashBO = 50/255,
	MaxHP = 2,
	PrioritizeHealing = false,
	PickupEntities = {
		{ID = EntityType.ENTITY_PICKUP, Var = FiendFolio.PICKUP.VARIANT.HALF_IMMORAL_HEART, Sub = 0},
		{ID = EntityType.ENTITY_PICKUP, Var = FiendFolio.PICKUP.VARIANT.IMMORAL_HEART, Sub = 0},
	},
	SumptoriumSubType = 920,
	SumptoriumSplatColor = immoralSplatColor,
	SumptoriumTrailColor = immoralTrailColor,
	CollectSound = { ID = FiendFolio.Sounds.FiendHeartPickup, Volume = 1.0, Pitch = 1.0 },
})

CustomHealthAPI.Library.RegisterRedHealth("MORBID_HEART", {
	MaxHP = 3,
	AnimationFilenames = {
		EMPTY_HEART = "gfx/ui/morbid_hearts.anm2",
		BONE_HEART = "gfx/ui/morbid_hearts.anm2",
		LEAKY_HEART = "gfx/ui/morbid_hearts.anm2",
	},
	AnimationNames = {
		EMPTY_HEART = {"MorbidHeartThird", "MorbidHeartHalf", "MorbidHeartFull"},
		BONE_HEART = {"MorbidBoneHeartThird", "MorbidBoneHeartHalf", "MorbidBoneHeartFull"},
		LEAKY_HEART = {"MorbidLeakyHeartThird", "MorbidLeakyHeartHalf", "MorbidLeakyHeartFull"},
	},
	SortOrder = 200,
	AddPriority = 200,
	HealFlashRO = 26/255,
	HealFlashGO = 80/255,
	HealFlashBO = 26/255,
	ProtectsDealChance = false,
	PrioritizeHealing = false,
	PickupEntities = {
		{ID = EntityType.ENTITY_PICKUP, Var = FiendFolio.PICKUP.VARIANT.THIRD_MORBID_HEART, Sub = 0},
		{ID = EntityType.ENTITY_PICKUP, Var = FiendFolio.PICKUP.VARIANT.TWOTHIRDS_MORBID_HEART, Sub = 0},
		{ID = EntityType.ENTITY_PICKUP, Var = FiendFolio.PICKUP.VARIANT.MORBID_HEART, Sub = 0},
	},
	SumptoriumSubType = 921,
	SumptoriumSplatColor = morbidSplatColor,
	SumptoriumTrailColor = morbidTrailColor,
	CollectSound = { ID = SoundEffect.SOUND_ROTTEN_HEART, Volume = 1.0, Pitch = 1.0 },
})

CustomHealthAPI.Library.RegisterRedHealth("BOMB_HEART", {
	MaxHP = 2,
	AnimationFilenames = {
		EMPTY_HEART = "gfx/ui/bomb_hearts.anm2",
	},
	AnimationNames = {
		EMPTY_HEART = {"BombHeartHalf", "BombHeartFull"},
	},
	SortOrder = 100,
	AddPriority = 125,
	HealFlashRO = 30/255,
	HealFlashGO = 30/255,
	HealFlashBO = 30/255,
	ProtectsDealChance = false,
	PrioritizeHealing = false,
	PickupEntities = {
		{ID = EntityType.ENTITY_PICKUP, Var = FiendFolio.PICKUP.VARIANT.HALF_BOMB_HEART, Sub = 0},
		{ID = EntityType.ENTITY_PICKUP, Var = FiendFolio.PICKUP.VARIANT.BOMB_HEART, Sub = 0},
	},
	SumptoriumSubType = 922,
	SumptoriumSplatColor = morbidSplatColor,
	SumptoriumTrailColor = morbidTrailColor,
	CollectSound = {ID = SoundEffect.SOUND_FETUS_FEET, Volume = 1.0, Pitch = 1.0 },
})

CustomHealthAPI.Library.RegisterHealthOverlay("FOOLS_GOLD_HEART", {
	MaxHP = 0,
	AnimationFilename = "gfx/ui/ui_foolsgoldheart.anm2",
	AnimationName = "FoolsGoldOverlay",
	AllowSharedOverlayLayer = true,
	OverlayLayerOrder = 0,
	OverlayFlags = CustomHealthAPI.Enums.OverlayFlagSets.GOLDEN,
	SortOrder = 0,
	AddPriority = 0,
	HealFlashRO = 90/255,
	HealFlashGO = 30/255,
	HealFlashBO = 80/255,
	IgnoreBleeding = true,
	PickupEntities = {{ID = EntityType.ENTITY_PICKUP, Var = FiendFolio.PICKUP.VARIANT.FOOLS_GOLD_HEART, Sub = 0}},
	SumptoriumSubType = 923,
	SumptoriumSplatColor = foolsGoldSplatColor,
	SumptoriumTrailColor = foolsGoldTrailColor,
	CollectSound = {ID = SoundEffect.SOUND_GOLD_HEART, Volume = 1.0, Pitch = 0.75 },
})

CustomHealthAPI.Library.RegisterSoulHealth("ETERNAL_SHIELD", {
	AnimationFilename = "gfx/ui/ui_eternal_shield.anm2",
	AnimationName = {"EternalShield1Hit", "EternalShield2Hits", "EternalShield3Hits"},
	SortOrder = 9999,
	AddPriority = 9999,
	HealFlashRO = 100/255,
	HealFlashGO = 100/255,
	HealFlashBO = 100/255,
	MaxHP = 3,
	PrioritizeHealing = false,
})

CustomHealthAPI.Library.RegisterHealthContainer("LEAKY_HEART", {
	MaxHP = 0,
	AnimationFilename = "gfx/ui/leaky_hearts.anm2",
	AnimationName = "LeakyHeartEmpty",
	SortOrder = 1000,
	AddPriority = 1000,
	RemovePriority = 1000,
	ProtectsDealChance = true,
	CanHaveHalfCapacity = false,
	ForceBleedingIfFilled = true,
})

CustomHealthAPI.Library.DefineContainerForRedHealth("RED_HEART",
	"LEAKY_HEART",
	"gfx/ui/leaky_hearts.anm2",
	{"LeakyHeartHalf", "LeakyHeartFull"})

CustomHealthAPI.Library.DefineContainerForRedHealth("ROTTEN_HEART",
	"LEAKY_HEART",
	"gfx/ui/leaky_hearts.anm2",
	{"RottenLeakyHeartFull"})

CustomHealthAPI.Library.RegisterHealthOverlay("STEVEN_HEART", {
	MaxHP = 0,
	AnimationFilename = "gfx/ui/ui_steven_heart.anm2",
	AnimationName = "StevenOverlay",
	AllowSharedOverlayLayer = true,
	OverlayLayerOrder = 0,
	OverlayFlags = CustomHealthAPI.Enums.OverlayFlagSets.GOLDEN,
	SortOrder = 0,
	AddPriority = 0,
	HealFlashRO = 100/255,
	HealFlashGO = 100/255,
	HealFlashBO = 100/255,
	IgnoreBleeding = true,
	PickupEntities = {{ID = EntityType.ENTITY_PICKUP, Var = FiendFolio.PICKUP.VARIANT.STEVEN_HEART, Sub = 0}},
	SumptoriumSubType = 924,
	SumptoriumSplatColor = stevenSplatColor,
	SumptoriumTrailColor = stevenTrailColor,
	CollectSound = function() mod:stevenHeartCollectSound() end,
})

--[[CustomHealthAPI.Library.RegisterRedHealth("TEST_HEART_1", CustomHealthAPI.Enums.HealthKinds.HEART,
	{EMPTY_HEART = "gfx/ui/test_heart_1.anm2",
	 BONE_HEART = "gfx/ui/test_heart_1.anm2"},
	{EMPTY_HEART = {"Full"},
	 BONE_HEART = {"Full"}},
	3, 3,
	128/255, 0/255, 0/255,
	1,
	false,
	false)]]--

--[[CustomHealthAPI.Library.RegisterRedHealth("TEST_HEART_2", CustomHealthAPI.Enums.HealthKinds.HEART,
	{EMPTY_HEART = "gfx/ui/test_heart_2.anm2",
	 BONE_HEART = "gfx/ui/test_heart_2.anm2"},
	{EMPTY_HEART = {"Half", "Full"},
	 BONE_HEART = {"Half", "Full"}},
	3, 4,
	128/255, 0/255, 0/255,
	2,
	false,
	false)]]--

--[[CustomHealthAPI.Library.RegisterRedHealth("TEST_HEART_3", CustomHealthAPI.Enums.HealthKinds.HEART,
	{EMPTY_HEART = "gfx/ui/test_heart_3.anm2",
	 BONE_HEART = "gfx/ui/test_heart_3.anm2"},
	{EMPTY_HEART = {"Third", "Half", "Full"},
	 BONE_HEART = {"Third", "Half", "Full"}},
	3, 5,
	128/255, 0/255, 0/255,
	3,
	false,
	false)]]--

--[[CustomHealthAPI.Library.RegisterRedHealth("TEST_HEART_4",
	{MaxHP = 4,
	 AnimationFilenames = {EMPTY_HEART = "gfx/ui/test_heart_4.anm2",
	                       BONE_HEART = "gfx/ui/test_heart_4.anm2",
	                       LEAKY_HEART = "gfx/ui/test_heart_4.anm2"},
	 AnimationNames = {EMPTY_HEART = {"Fourth", "Third", "Half", "Full"},
	                   BONE_HEART = {"Fourth", "Third", "Half", "Full"},
	                   LEAKY_HEART = {"Fourth", "Third", "Half", "Full"}},
	 SortOrder = 201,
	 AddPriority = 201,
	 HealFlashRO = 128/255,
	 HealFlashGO = 0/255,
	 HealFlashBO = 0/255,
	 ProtectsDealChance = false,
	 PrioritizeHealing = false,
	 PickupEntities = {{ID = EntityType.ENTITY_PICKUP, Var = 10, Sub = 1},
	                   {ID = EntityType.ENTITY_PICKUP, Var = 10, Sub = 1},
	                   {ID = EntityType.ENTITY_PICKUP, Var = 10, Sub = 1},
	                   {ID = EntityType.ENTITY_PICKUP, Var = 10, Sub = 1}},
	 SumptoriumSubType = 666,
	 SumptoriumSplatColor = morbidSplatColor,
	 SumptoriumTrailColor = morbidTrailColor,
	 SumptoriumCollectSoundSettings = {ID = SoundEffect.SOUND_ROTTEN_HEART,
	                                   Volume = 1.0,
	                                   FrameDelay = 0,
	                                   Loop = false,
	                                   Pitch = 1.0,
	                                   Pan = 0}})]]--

--[[CustomHealthAPI.Library.RegisterSoulHealth("TEST_HEART_4_2",
	{MaxHP = 4,
	 AnimationFilename = "gfx/ui/test_heart_4.anm2",
	 AnimationName = {"Fourth", "Third", "Half", "Full"},
	 SortOrder = 101,
	 AddPriority = 151,
	 HealFlashRO = 128/255,
	 HealFlashGO = 0/255,
	 HealFlashBO = 0/255,
	 PrioritizeHealing = false,
	 PickupEntities = {{ID = EntityType.ENTITY_PICKUP, Var = 10, Sub = 1},
	                   {ID = EntityType.ENTITY_PICKUP, Var = 10, Sub = 1},
	                   {ID = EntityType.ENTITY_PICKUP, Var = 10, Sub = 1},
	                   {ID = EntityType.ENTITY_PICKUP, Var = 10, Sub = 1}},
	 SumptoriumSubType = 666,
	 SumptoriumSplatColor = morbidSplatColor,
	 SumptoriumTrailColor = morbidTrailColor,
	 SumptoriumCollectSoundSettings = {ID = SoundEffect.SOUND_ROTTEN_HEART,
	                                   Volume = 1.0,
	                                   FrameDelay = 0,
	                                   Loop = false,
	                                   Pitch = 1.0,
	                                   Pan = 0}})]]--

----------------------------
-- Pickups
----------------------------

mod.HeartPickups = {
	[PickupVariant.PICKUP_HEART] = true,
	[FiendFolio.PICKUP.VARIANT.HALF_BLACK_HEART] = true,
	[FiendFolio.PICKUP.VARIANT.BLENDED_BLACK_HEART] = true,
	[FiendFolio.PICKUP.VARIANT.HALF_IMMORAL_HEART] = true,
	[FiendFolio.PICKUP.VARIANT.IMMORAL_HEART] = true,
	[FiendFolio.PICKUP.VARIANT.BLENDED_IMMORAL_HEART] = true,
	[FiendFolio.PICKUP.VARIANT.THIRD_MORBID_HEART] = true,
	[FiendFolio.PICKUP.VARIANT.TWOTHIRDS_MORBID_HEART] = true,
	[FiendFolio.PICKUP.VARIANT.MORBID_HEART] = true,
	[FiendFolio.PICKUP.VARIANT.HALF_BOMB_HEART] = true,
	[FiendFolio.PICKUP.VARIANT.BOMB_HEART] = true,
	[FiendFolio.PICKUP.VARIANT.FOOLS_GOLD_HEART] = true,
	[FiendFolio.PICKUP.VARIANT.STEVEN_HEART] = true,
}
function mod:IsHeartPickup(pickup)
	local variant = pickup.Variant
	local d = mod:GetEntityData(pickup)
	if d.isPickupAToken then
		local savedata = FiendFolio.savedata.run
		if savedata.CurrentTokenValue and savedata.CurrentTokenValue[1] then
			variant = savedata.CurrentTokenValue[1]
		else
			return false
		end
	end
	if mod.HeartPickups[variant] then
		return true
	end
	local chapiDef = CustomHealthAPI.Library.GetPickupDefinition(variant, pickup.SubType)
	if chapiDef and chapiDef.IsHeart then
		return true
	end
	return false
end

CustomHealthAPI.Library.RegisterHeartPickup(FiendFolio.PICKUP.VARIANT.HALF_BLACK_HEART, -1, {
	HealthKeys = {"BLACK_HEART"},
	HealthAmount = 1,
	DropSound = SoundEffect.SOUND_MEAT_FEET_SLOW0,
	AllowCandyHeartSoulLocketBonus = true,
	AllowImmaculateConception = false,
})

CustomHealthAPI.Library.RegisterHeartPickup(FiendFolio.PICKUP.VARIANT.BLENDED_BLACK_HEART, -1, {
	HealthKeys = {"RED_HEART", "BLACK_HEART"},
	HealthAmount = 2,
	DropSound = SoundEffect.SOUND_MEAT_FEET_SLOW0,
	AllowCandyHeartSoulLocketBonus = true,
	AllowImmaculateConception = false,
})

for hp, variant in ipairs({FiendFolio.PICKUP.VARIANT.HALF_IMMORAL_HEART, FiendFolio.PICKUP.VARIANT.IMMORAL_HEART}) do
	CustomHealthAPI.Library.RegisterHeartPickup(variant, -1, {
		HealthKeys = {"IMMORAL_HEART"},
		HealthAmount = hp,
		DropSound = { ID = mod.Sounds.FiendHeartDrop, Volume = 0.8, Pitch = 1.0 },
		CollectSound = function()
			if math.random(1000) == 1 then
				sfx:Play(mod.Sounds.FiendHeartPickupRare, 1, 0, false, 1.0)
			else
				sfx:Play(mod.Sounds.FiendHeartPickup, 1, 0, false, 1)
			end
		end,
		AllowCandyHeartSoulLocketBonus = function(pickup, player) return pickup.SubType ~= 1 end,
		AllowImmaculateConception = function(pickup, player) return pickup.SubType ~= 1 end,
	})
end

CustomHealthAPI.Library.RegisterHeartPickup(FiendFolio.PICKUP.VARIANT.BLENDED_IMMORAL_HEART, -1, {
	HealthKeys = {"RED_HEART", "IMMORAL_HEART"},
	HealthAmount = 2,
	DropSound = { ID = mod.Sounds.FiendHeartDrop, Volume = 0.8, Pitch = 1.0 },
	AllowCandyHeartSoulLocketBonus = true,
	AllowImmaculateConception = false,
})

for hp, variant in ipairs({FiendFolio.PICKUP.VARIANT.THIRD_MORBID_HEART, FiendFolio.PICKUP.VARIANT.TWOTHIRDS_MORBID_HEART, FiendFolio.PICKUP.VARIANT.MORBID_HEART}) do
	CustomHealthAPI.Library.RegisterHeartPickup(variant, -1, {
		HealthKeys = {"MORBID_HEART"},
		HealthAmount = hp,
		DropSound = SoundEffect.SOUND_MEAT_FEET_SLOW0,
		AllowCandyHeartSoulLocketBonus = function(pickup, player) return pickup.SubType ~= 1 end,
		AllowImmaculateConception = function(pickup, player) return pickup.SubType ~= 1 end,
	})
end

for hp, variant in ipairs({FiendFolio.PICKUP.VARIANT.HALF_BOMB_HEART, FiendFolio.PICKUP.VARIANT.BOMB_HEART}) do
	CustomHealthAPI.Library.RegisterHeartPickup(variant, -1, {
		HealthKeys = {"BOMB_HEART"},
		HealthAmount = hp,
		DropSound = SoundEffect.SOUND_FETUS_LAND,
		AllowCandyHeartSoulLocketBonus = true,
		AllowImmaculateConception = true,
	})
end

CustomHealthAPI.Library.RegisterHeartPickup(FiendFolio.PICKUP.VARIANT.FOOLS_GOLD_HEART, -1, {
	HealthKeys = {"FOOLS_GOLD_HEART"},
	HealthAmount = 1,
	DropSound = { ID = SoundEffect.SOUND_GOLD_HEART_DROP, Volume = 1.0, Pitch = 0.75 },
	AllowCandyHeartSoulLocketBonus = false,
	AllowImmaculateConception = false,
})

CustomHealthAPI.Library.RegisterHeartPickup(FiendFolio.PICKUP.VARIANT.STEVEN_HEART, -1, {
	HealthKeys = {"STEVEN_HEART"},
	HealthAmount = 1,
	DropSound = function() mod:stevenHeartDropSound() end,
	AllowCandyHeartSoulLocketBonus = false,
	AllowImmaculateConception = false,
})

----------------------------
-- Sumptorium
----------------------------

function mod:immoralClotOnFireTear(tear)
	if mod.FireTearSource and mod.FireTearSource.Type == EntityType.ENTITY_FAMILIAR and mod.FireTearSource.Variant == FamiliarVariant.BLOOD_BABY and mod.FireTearSource.SubType == 920 and
	   not TearFlagsLib.HasTearFlags(tear, mod.CritFlag)
	then
		tear.Color = Color(1.1,1.1,1.1,1,50/255,-75/255,50/255)
	end
end

function mod:immoralClotOnFireLaser(laser)
	if laser.SpawnerEntity and laser.SpawnerEntity.Type == EntityType.ENTITY_FAMILIAR and
	   laser.SpawnerEntity.Variant == FamiliarVariant.BLOOD_BABY
	then
		if laser.SpawnerEntity.SubType == 920 then
			mod:GetEntityData(laser).ImpSodaLaserForceColor = true
			mod.scheduleForUpdate(function()
				laser.Color = Color(1.0, 1.0, 1.0, 1.0, 0/255, 0/255, 0/255, 5.7, 0.9, 3.4, 1)
			end, 1, ModCallbacks.MC_PRE_RENDER)
		end
	end
end

mod.ImmoralClotTracker = TearFlagsLib.RegisterTearFlag("IMMORAL_CLOT_TRACKER")
local foolsGoldClotTracker = TearFlagsLib.RegisterTearFlag("FOOLS_GOLD_CLOT_TRACKER")
mod:AddCallback(TearFlagsLib.Callback.PRE_REMOVE_TEARFLAG, function()
	return true
end, mod.ImmoralClotTracker)
mod:AddCallback(TearFlagsLib.Callback.PRE_REMOVE_TEARFLAG, function()
	return true
end, foolsGoldClotTracker)

function mod:clotOnFireBrimball(brimball)
	if brimball.SpawnerEntity and brimball.SpawnerEntity.Type == EntityType.ENTITY_PLAYER then
		local knives = Isaac.FindByType(EntityType.ENTITY_KNIFE)
		for _,knife in ipairs(knives) do
			if knife.SpawnerEntity and knife.SpawnerEntity.Type == EntityType.ENTITY_FAMILIAR and
			   knife.SpawnerEntity.Variant == FamiliarVariant.BLOOD_BABY
			then
				local potentialSpawnerPosition = brimball.Position - brimball.Velocity:Resized(30)
				local spawnerPosition = knife.SpawnerEntity.Position

				if math.abs(spawnerPosition.X - potentialSpawnerPosition.X) <= 0.0001 and
				   math.abs(spawnerPosition.Y - potentialSpawnerPosition.Y) <= 0.0001
				then
					if knife.SpawnerEntity.SubType == 920 then
						TearFlagsLib.AddTearFlags(brimball, mod.ImmoralClotTracker)
						mod:GetEntityData(brimball).ImpSodaLaserForceColor = true
						mod.scheduleForUpdate(function()
							brimball.Color = Color(1.0, 1.0, 1.0, 1.0, 0/255, 0/255, 0/255, 5.7, 0.9, 3.4, 1)
						end, 1, ModCallbacks.MC_PRE_RENDER)
					elseif knife.SpawnerEntity.SubType == 923 then
						TearFlagsLib.AddTearFlags(brimball, foolsGoldClotTracker)
					end
				end
			end
		end
	end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_TEAR_HIT_PARAMS, function(_, player, tearparams, weapon, damagescale, displacement, source)
	local source = source or mod.FireTearSource
	if source and source.Type == EntityType.ENTITY_FAMILIAR and source.Variant == FamiliarVariant.BLOOD_BABY and source.SubType == 921 then
		tearparams.TearVariant = mod.RegularToBlood[tearparams.TearVariant] or tearparams.TearVariant
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_TOUGH_LOVE) and math.random(10) == 1 then
			tearparams.TearDamage = tearparams.TearDamage * 3.2
			tearparams.TearVariant = TearVariant.TOOTH
		end
	end
end)

mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CallbackPriority.LATE, function(_, clot, damage, flags, source, damageCooldown)
	if clot.Variant == FamiliarVariant.BLOOD_BABY then
		local d = mod:GetEntityData(clot)
		if clot.SubType == 922 and damage >= clot.HitPoints and not d.BombHeartExploded then
			d.BombHeartExploded = true
			Isaac.Explode(clot.Position, clot, 100)
		end
	end
end, EntityType.ENTITY_FAMILIAR)

-- idk why i did all this for a clot
local foolsGoldTearFlag = TearFlagsLib.RegisterTearFlag("FOOLS_GOLD_CLOT")
local foolsGoldFreezeColor = Color(0.4, 0.1, 0.4, 1, 0.16, 0.16, 0.16)
local foolsGoldTearColor = Color(0.9, 0.4, 0.8, 1)

function mod:foolsGoldFreezeFlagGeneric(entity, player, weaponFlag)
	if (mod.FireTearSource and mod.FireTearSource.Type == EntityType.ENTITY_FAMILIAR and mod.FireTearSource.Variant == FamiliarVariant.BLOOD_BABY and mod.FireTearSource.SubType == 923) or
	   (entity and entity.Parent and entity.Parent.Type == EntityType.ENTITY_FAMILIAR and entity.Parent.Variant == FamiliarVariant.BLOOD_BABY and entity.Parent.SubType == 923) or
	   (entity and entity.SpawnerEntity and entity.SpawnerEntity.Type == EntityType.ENTITY_FAMILIAR and entity.SpawnerEntity.Variant == FamiliarVariant.BLOOD_BABY and entity.SpawnerEntity.SubType == 923) or
	   (entity and TearFlagsLib.HasTearFlags(entity, foolsGoldClotTracker))
	then
		TearFlagsLib.AddTearFlags(entity, foolsGoldTearFlag)

		if weaponFlag == TearFlagsLib.WeaponFlag.AQUARIUS then
			mod:GetEntityData(entity).FFAquariusTearColor = foolsGoldTearColor
		elseif weaponFlag == TearFlagsLib.WeaponFlag.EPIC_FETUS or weaponFlag == TearFlagsLib.WeaponFlag.CLUB_EPIC_FETUS then
			mod:GetEntityData(entity).FFExplosionColor = foolsGoldTearColor
		elseif weaponFlag == TearFlagsLib.WeaponFlag.LASER or
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
			entity.Color = foolsGoldTearColor
		end
	end
end
mod:AddCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, mod.foolsGoldFreezeFlagGeneric)

function mod:ApplyFoolsGoldFreeze(entity, player, source)
	if source and Random() % math.max(3, 9 - player.Luck * 0.25) == 0 then
		entity:AddFreeze(EntityRef(player), 90)
		mod:GetEntityData(entity).FoolsGoldFreeze = true
		entity:SetColor(foolsGoldFreezeColor, entity:GetFreezeCountdown(), 254, false, true)
	end
end
mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, mod.ApplyFoolsGoldFreeze, foolsGoldTearFlag)

function mod:UpdateFoolsGoldFreeze(entity, data)
	if data.FoolsGoldFreeze and entity:GetFreezeCountdown() < 1 then
		data.FoolsGoldFreeze = nil
	end
end

function mod:FoolsGoldFreezeKill(entity)
	if mod:GetEntityData(entity).FoolsGoldFreeze and entity:GetFreezeCountdown() > 0 then
		for j = 1, mod:RandomInt(1,4) do
			local randvec = Vector.FromAngle(mod:RandomFloat(360)) * mod:RandomFloat(1.5, 5)
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, mod.PICKUP.COIN.CURSED, entity.Position + randvec, randvec, entity)
		end
	end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_TEAR_HIT_PARAMS, function(_, player, tearparams, weapon, damagescale, displacement, source)
	local source = source or mod.FireTearSource
	if source and source.Type == EntityType.ENTITY_FAMILIAR and source.Variant == FamiliarVariant.BLOOD_BABY and source.SubType == 924 then
		tearparams.TearFlags = tearparams.TearFlags | TearFlags.TEAR_HOMING
		tearparams.TearVariant = FiendFolio.TEAR.MULTI_EUCLIDEAN
	end
end)

function mod:stevenClotOnFireBomb(bomb)
	if mod.FireTearSource and mod.FireTearSource.Type == EntityType.ENTITY_FAMILIAR and mod.FireTearSource.Variant == FamiliarVariant.BLOOD_BABY and mod.FireTearSource.SubType == 924 then
		bomb.Variant = mod.BOMB.PARALLEL
		bomb:SetLoadCostumes(true)
	end
end

function mod:stevenClotOnFireLaser(laser)
	if laser.SpawnerEntity and laser.SpawnerEntity.Type == EntityType.ENTITY_FAMILIAR and
	   laser.SpawnerEntity.Variant == FamiliarVariant.BLOOD_BABY
	then
		if laser.SpawnerEntity.SubType == 924 then
			mod:GetEntityData(laser).StevenLaserForceColor = true
			mod.scheduleForUpdate(function()
				laser.Color = Color(-2,-2,-2,1,1,1,1,1,1,1,1)
			end, 1, ModCallbacks.MC_PRE_RENDER)
		end
	end
end

function mod:stevenClotOnFireBrimball(brimball)
	if brimball.SpawnerEntity and brimball.SpawnerEntity.Type == EntityType.ENTITY_PLAYER then
		local knives = Isaac.FindByType(EntityType.ENTITY_KNIFE)
		for _,knife in ipairs(knives) do
			if knife.SpawnerEntity and knife.SpawnerEntity.Type == EntityType.ENTITY_FAMILIAR and
			   knife.SpawnerEntity.Variant == FamiliarVariant.BLOOD_BABY
			then
				local potentialSpawnerPosition = brimball.Position - brimball.Velocity:Resized(30)
				local spawnerPosition = knife.SpawnerEntity.Position

				if math.abs(spawnerPosition.X - potentialSpawnerPosition.X) <= 0.0001 and
				   math.abs(spawnerPosition.Y - potentialSpawnerPosition.Y) <= 0.0001
				then
					if knife.SpawnerEntity.SubType == 924 then
						mod:GetEntityData(brimball).StevenLaserForceColor = true
						mod.scheduleForUpdate(function()
							brimball.Color = Color(-2,-2,-2,1,1,1,1,1,1,1,1)
						end, 1, ModCallbacks.MC_PRE_RENDER)
					end
				end
			end
		end
	end
end

mod:AddCallback(ModCallbacks.MC_PRE_LASER_UPDATE, function(_, laser)
	local parent = laser.Parent
	if parent and parent.Type == EntityType.ENTITY_FAMILIAR and parent.Variant == FamiliarVariant.BLOOD_BABY and parent.SubType == 924 then
		laser.TearFlags = laser.TearFlags | TearFlags.TEAR_HOMING
	end
end)

mod:AddCallback(ModCallbacks.MC_PRE_KNIFE_UPDATE, function(_, knife)
	local parent = knife.Parent
	if parent and parent.Type == EntityType.ENTITY_FAMILIAR and parent.Variant == FamiliarVariant.BLOOD_BABY and parent.SubType == 924 then
		knife.TearFlags = knife.TearFlags | TearFlags.TEAR_HOMING
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, target)
	local parent = target.SpawnerEntity
	if parent and parent.Type == EntityType.ENTITY_FAMILIAR and parent.Variant == FamiliarVariant.BLOOD_BABY and parent.SubType == 924 then
		local familiar = parent:ToFamiliar()
		if familiar.Player and familiar.Player.TearFlags & TearFlags.TEAR_HOMING ~= TearFlags.TEAR_HOMING then
			local targetPos = target.Position
			local enemies = Isaac.FindInRadius(target.Position, 200, EntityPartition.ENEMY)
			local closestPos, closestDist = nil, math.huge
			for _, enemy in ipairs(enemies) do
				if enemy:ToNPC() and enemy.HitPoints > 0 and not enemy:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) then
					local enemyPos = enemy.Position
					local dist = enemyPos:Distance(targetPos)
					if dist < closestDist then
						closestPos = enemyPos
						closestDist = dist
					end
				end
			end
			if closestPos then
				target.Velocity = target.Velocity + (closestPos - targetPos):Normalized()
			end
		end
	end
end, EffectVariant.TARGET)


----------------------------
-- Immoral Hearts
----------------------------

function mod.GetImmoralHeartsNum(player)
	return CustomHealthAPI.Library.GetHPOfKey(player, "IMMORAL_HEART")
end

function mod:AddImmoralHearts(player, hp)
	CustomHealthAPI.Library.AddHealth(player, "IMMORAL_HEART", hp)
end

function mod:CanPickImmoralHearts(player)
	return CustomHealthAPI.Library.CanPickKey(player, "IMMORAL_HEART")
end

function mod:somePlayerHasImmoral(useFannyPackSafeguard)
	for i = 0, Game():GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(0)
		if CustomHealthAPI.Library.GetHPOfKey(player, "IMMORAL_HEART", nil, nil, useFannyPackSafeguard) > 0 then
			return true
		end
	end

	return false
end

mod:AddCallback(CustomHealthAPI.Enums.Callbacks.POST_HEALTH_DAMAGED, function(_, player, flags, key, hpDamaged, wasDepleted, wasLastDamaged)
	if mod.IsActiveRoom() and flags & DamageFlag.DAMAGE_FAKE == 0 and flags & DamageFlag.DAMAGE_DEVIL == 0 then
		local ptype = player:GetPlayerType()
		if key == "IMMORAL_HEART" and wasLastDamaged then
			local hearts = CustomHealthAPI.Library.GetHealthInOrder(player, true, true)
			local maskIndexOfImmoral = CustomHealthAPI.Library.GetInfoOfKey("IMMORAL_HEART", "MaskIndex")

			local numMinions = 0
			local numGold = 0
			for i = #hearts, 1, -1 do
				local health = hearts[i]
				local key = health.Other.Key
				local hp = health.Other.HP
				local maskIndexOfHealth = CustomHealthAPI.Library.GetInfoOfKey(key, "MaskIndex")

				if maskIndexOfHealth == maskIndexOfImmoral then
					if key == "IMMORAL_HEART" then
						if CustomHealthAPI.Helper.GetTotalHP(player) <= hp then
							numMinions = numMinions + (hp - 1)
							health.Other.HP = 1
							CustomHealthAPI.Helper.UpdateBasegameHealthState(player)
							break
						end
						if health.IsGold then
							CustomHealthAPI.Helper.UpdateHealthMasks(player, "GOLDEN_HEART", -1)
							numGold = numGold + 1
						end
						numMinions = numMinions + hp
						CustomHealthAPI.Library.RemoveOtherKey(player, i, true)
					else
						break
					end
				end
			end

			if numGold > 0 then
				CustomHealthAPI.Helper.TriggerGoldHearts(player, numGold)
			end

			while numMinions > 0 do
				local egg

				if numMinions >= 2 then
					egg = Isaac.Spawn(5, FiendFolio.PICKUP.VARIANT.FIEND_MINION, 2, player.Position, Vector(math.random(-5, 5), math.random(-5, 5)), player):ToPickup()
				else
					egg = Isaac.Spawn(5, FiendFolio.PICKUP.VARIANT.FIEND_MINION, 3, player.Position, Vector(math.random(-5, 5), math.random(-5, 5)), player):ToPickup()
					mod:GetEntityData(egg).hollowimmoral = true
				end

				egg:GetSprite():Play("Drop", true)
				if math.random(2) == 1 then
					egg:GetSprite().FlipX = true
				end

				egg.Parent = player
				egg:Update()

				numMinions = numMinions - 2
			end

			local hasBirthcake, numBirthcake = mod:playerHasBirthcake(player)
			if ptype == FiendFolio.PLAYER.FIEND and hasBirthcake then
				for i = 1, numBirthcake do
					local egg = Isaac.Spawn(1000, FiendFolio.PICKUP.VARIANT.FIEND_MINION_EFFECT, 1, player.Position, Vector(math.random(-5, 5), math.random(-5, 5)), player):ToEffect()
					mod:GetEntityData(egg).hollow = true
					mod:GetEntityData(egg).canreroll = false

					mod:GetEntityData(egg).fiendBonus = true

					egg:GetSprite():Play("Drop", true)
					if math.random(2) == 1 then
						egg:GetSprite().FlipX = true
					end

					local rand = math.random() * 360
					if rand < 60.0 then
						egg.Color = Color(1,1,1,1,0,0,0,3.0, (1.0 - math.abs((rand / 60.0) % 2.0 - 1.0)) * 2.0 + 1.0, 1.0,1)
					elseif rand < 120.0 then
						egg.Color = Color(1,1,1,1,0,0,0,(1.0 - math.abs((rand / 60.0) % 2.0 - 1.0)) * 2.0 + 1.0, 3.0, 1.0,1)
					elseif rand < 180.0 then
						egg.Color = Color(1,1,1,1,0,0,0,1.0, 3.0, (1.0 - math.abs((rand / 60.0) % 2.0 - 1.0)) * 2.0 + 1.0,1)
					elseif rand < 240.0 then
						egg.Color = Color(1,1,1,1,0,0,0,1.0, (1.0 - math.abs((rand / 60.0) % 2.0 - 1.0)) * 2.0 + 1.0, 3.0,1)
					elseif rand < 300.0 then
						egg.Color = Color(1,1,1,1,0,0,0,(1.0 - math.abs((rand / 60.0) % 2.0 - 1.0)) * 2.0 + 1.0, 1.0, 3.0,1)
					else
						egg.Color = Color(1,1,1,1,0,0,0,3.0, 1.0, (1.0 - math.abs((rand / 60.0) % 2.0 - 1.0)) * 2.0 + 1.0,1)
					end
					egg.Parent = player
					egg:Update()
				end
			end
		elseif (ptype == FiendFolio.PLAYER.FIEND or ptype == FiendFolio.PLAYER.CLASSIC_FIEND) and key == "BLACK_HEART" and wasLastDamaged then
			local hearts = CustomHealthAPI.Library.GetHealthInOrder(player, true, true)
			local maskIndexOfBlack = CustomHealthAPI.Library.GetInfoOfKey("BLACK_HEART", "MaskIndex")

			local numMinions = 0
			for i = #hearts, 1, -1 do
				local health = hearts[i]
				local key = health.Other.Key
				local maskIndexOfHealth = CustomHealthAPI.Library.GetInfoOfKey(key, "MaskIndex")

				if maskIndexOfHealth == maskIndexOfBlack then
					if key == "BLACK_HEART" then
						numMinions = numMinions + health.Other.HP
						CustomHealthAPI.Library.RemoveOtherKey(player, i, true)
					else
						break
					end
				end
			end

			local healthNum = CustomHealthAPI.Helper.GetTotalHP(player)
			if healthNum <= 0 and numMinions > 0 then
				local base = 1
				if ptype == FiendFolio.PLAYER.CLASSIC_FIEND then
					base = ((numMinions + 1) % 2) + 1
				end
				CustomHealthAPI.Helper.UpdateHealthMasks(player, "BLACK_HEART", base, true, false, true)
				numMinions = numMinions - 1
			end

			--I believe this is accurate to his birthpact effect
			--He gets more health after being hit, but also he still dies in 2 hits anyway
			if ptype == FiendFolio.PLAYER.CLASSIC_FIEND
			and player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
			then
				numMinions = numMinions + (2 * player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BIRTHRIGHT))
			end

			while numMinions > 0 do
				if ptype == FiendFolio.PLAYER.FIEND then
					local egg

					if numMinions >= 2 then
						egg = Isaac.Spawn(5, FiendFolio.PICKUP.VARIANT.FIEND_MINION, 1, player.Position, Vector(math.random(-5, 5), math.random(-5, 5)), player):ToPickup()
					else
						egg = Isaac.Spawn(1000, FiendFolio.PICKUP.VARIANT.FIEND_MINION_EFFECT, 1, player.Position, Vector(math.random(-5, 5), math.random(-5, 5)), player):ToEffect()
						mod:GetEntityData(egg).hollow = true
						mod:GetEntityData(egg).canreroll = false
					end

					--Unnecessary check anyway?
					--if ptype == FiendFolio.PLAYER.FIEND then
						mod:GetEntityData(egg).fiendBonus = true
					--end

					egg:GetSprite():Play("Drop", true)
					if math.random(2) == 1 then
						egg:GetSprite().FlipX = true
					end

					egg.Parent = player
					egg:Update()
				elseif ptype == FiendFolio.PLAYER.CLASSIC_FIEND and numMinions > 1 then
					local minion = Isaac.Spawn(EntityType.ENTITY_PICKUP,mod.PICKUP.VARIANT.FIEND_MINION_CLASSIC,0,Isaac.GetFreeNearPosition(player.Position,40),Vector.Zero,player)
					mod:GetEntityData(minion).canreroll = false --we don't want it to turn into anything else
					minion.EntityCollisionClass = 4
					minion.Parent = player
				end
				numMinions = numMinions - 2
			end

			local hasBirthcake, numBirthcake = mod:playerHasBirthcake(player)
			if ptype == FiendFolio.PLAYER.FIEND and hasBirthcake then
				for i = 1, numBirthcake do
					local egg = Isaac.Spawn(1000, FiendFolio.PICKUP.VARIANT.FIEND_MINION_EFFECT, 1, player.Position, Vector(math.random(-5, 5), math.random(-5, 5)), player):ToEffect()
					mod:GetEntityData(egg).hollow = true
					mod:GetEntityData(egg).canreroll = false

					mod:GetEntityData(egg).fiendBonus = true

					egg:GetSprite():Play("Drop", true)
					if math.random(2) == 1 then
						egg:GetSprite().FlipX = true
					end

					local rand = math.random() * 360
					if rand < 60.0 then
						egg.Color = Color(1,1,1,1,0,0,0,3.0, (1.0 - math.abs((rand / 60.0) % 2.0 - 1.0)) * 2.0 + 1.0, 1.0,1)
					elseif rand < 120.0 then
						egg.Color = Color(1,1,1,1,0,0,0,(1.0 - math.abs((rand / 60.0) % 2.0 - 1.0)) * 2.0 + 1.0, 3.0, 1.0,1)
					elseif rand < 180.0 then
						egg.Color = Color(1,1,1,1,0,0,0,1.0, 3.0, (1.0 - math.abs((rand / 60.0) % 2.0 - 1.0)) * 2.0 + 1.0,1)
					elseif rand < 240.0 then
						egg.Color = Color(1,1,1,1,0,0,0,1.0, (1.0 - math.abs((rand / 60.0) % 2.0 - 1.0)) * 2.0 + 1.0, 3.0,1)
					elseif rand < 300.0 then
						egg.Color = Color(1,1,1,1,0,0,0,(1.0 - math.abs((rand / 60.0) % 2.0 - 1.0)) * 2.0 + 1.0, 1.0, 3.0,1)
					else
						egg.Color = Color(1,1,1,1,0,0,0,3.0, 1.0, (1.0 - math.abs((rand / 60.0) % 2.0 - 1.0)) * 2.0 + 1.0,1)
					end
					egg.Parent = player
					egg:Update()
				end
			end
		end
	end
end, {"IMMORAL_HEART", FiendFolio.PLAYER.FIEND, FiendFolio.PLAYER.CLASSIC_FIEND})

----------------------------
-- Morbid Hearts
----------------------------

function mod.GetMorbidHeartsNum(player)
	return CustomHealthAPI.Library.GetHPOfKey(player, "MORBID_HEART")
end

function mod:AddMorbidHearts(player, hp)
	CustomHealthAPI.Library.AddHealth(player, "MORBID_HEART", hp)
end

function mod:CanPickMorbidHearts(player)
	return CustomHealthAPI.Library.CanPickKey(player, "MORBID_HEART")
end

function mod:somePlayerHasPostiche()
	for i = 0, Game():GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(0)
		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.DADS_POSTICHE) then
			return true
		end
	end

	return false
end

mod:AddCallback(CustomHealthAPI.Enums.Callbacks.POST_HEALTH_DAMAGED, function(_, player, flags, key, hpDamaged, wasDepleted, wasLastDamaged)
	mod:GetEntityData(player).TookMorbidHeartDamage = true

	if wasDepleted then
		sfx:Play(SoundEffect.SOUND_BOIL_HATCH, 1, 0, false, 1)
		player:BloodExplode()
		Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 1, player.Position, nilvector, player)

		local basedata = mod:GetEntityData(player)
		local data = basedata.ffsavedata

		if data then
			data.MorbidChunks = math.min(3, (data.MorbidChunks or 0) + 1)
			player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS)
			player:EvaluateItems()
		end
	end
end, "MORBID_HEART")

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, familiar)
	local sprite = familiar:GetSprite()
	local data = mod:GetEntityData(familiar)

	if not data.init then
		local rng = RNG()
		rng:SetSeed(familiar.InitSeed, 0)

		data.anim = "Float" .. (rng:RandomInt(4) + 1)
		data.init = true

		familiar:AddToOrbit(5)
		familiar.Position = familiar:GetOrbitPosition(familiar.Player.Position - familiar.Player.Velocity)
	end

	if not sprite:IsPlaying(data.anim) then
		sprite:Play(data.anim, true)
	end

	familiar.Velocity = familiar:GetOrbitPosition(familiar.Player.Position - familiar.Player.Velocity) - familiar.Position
end, FiendFolio.ITEM.FAMILIAR.MORBID_CHUNK)

mod:AddPostNpcTakeDmgFromSourceCallback(function(_, npc, npcData, amount, flags, familiar, familiarData)
	if flags & DamageFlag.DAMAGE_CLONES == 0 then
		familiar.SubType = familiar.SubType + 1
		if familiar.SubType >= 30 then
			familiar:BloodExplode()
			Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 1, familiar.Position, nilvector, familiar)

			local player = familiar.Player

			if player then
				local basedata = mod:GetEntityData(player)
				local data = basedata.ffsavedata

				if player:HasCollectible(mod.ITEM.COLLECTIBLE.GUPPYS_HEART) then
					local num = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.GUPPYS_HEART)
					local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.GUPPYS_HEART)
					local flies = 2*(num-1)+1+rng:RandomInt(3)
					for i=1,flies do
						local vec = Vector(0, mod:RandomInt(30,60,rng)/10):Rotated(rng:RandomInt(360))
						local fly = Isaac.Spawn(3, FamiliarVariant.BLUE_FLY, 0, familiar.Position, vec, familiar):ToFamiliar()
						fly.Player = player
						fly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
					end
					Isaac.Spawn(1000, EffectVariant.POOF01, 0, familiar.Position, Vector.Zero, familiar)
					sfx:Play(SoundEffect.SOUND_BOIL_HATCH, 0.6, 0, false, 1.1)
				end

				if data then
					data.MorbidChunks = math.max(0, (data.MorbidChunks or 0) - 1)
				end
			end

			familiar:Remove()
		end
	end
end, EntityType.ENTITY_FAMILIAR, FiendFolio.ITEM.FAMILIAR.MORBID_CHUNK)

mod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, function(_, familiar, collider)
    if collider.Type == EntityType.ENTITY_PROJECTILE and not collider:ToProjectile():HasProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER) then
        collider:Die()

		familiar.SubType = familiar.SubType + 10
		if familiar.SubType >= 30 then
			familiar:BloodExplode()
			Isaac.Spawn(1000, 2, 1, familiar.Position, nilvector, familiar)

			if familiar.Player then
				local basedata = mod:GetEntityData(familiar.Player)
				local data = basedata.ffsavedata

				if familiar.Player:HasCollectible(mod.ITEM.COLLECTIBLE.GUPPYS_HEART) then
					local player = familiar.Player
					local num = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.GUPPYS_HEART)
					local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.GUPPYS_HEART)
					local flies = 2*(num-1)+1+rng:RandomInt(3)
					for i=1,flies do
						local vec = Vector(0, mod:RandomInt(30,60,rng)/10):Rotated(rng:RandomInt(360))
						local fly = Isaac.Spawn(3, FamiliarVariant.BLUE_FLY, 0, familiar.Position, vec, familiar):ToFamiliar()
						fly.Player = player
						fly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
					end
					Isaac.Spawn(1000, EffectVariant.POOF01, 0, familiar.Position, Vector.Zero, familiar)
					sfx:Play(SoundEffect.SOUND_BOIL_HATCH, 0.6, 0, false, 1.1)
				end

				if data then
					data.MorbidChunks = math.max(0, (data.MorbidChunks or 0) - 1)
				end
			end

			familiar:Remove()
		end
    end
end, FiendFolio.ITEM.FAMILIAR.MORBID_CHUNK)

----------------------------
-- Bomb Hearts
----------------------------

function mod.GetBombHeartsNum(player)
	return CustomHealthAPI.Library.GetHPOfKey(player, "BOMB_HEART")
end

function mod:AddBombHearts(player, hp)
	CustomHealthAPI.Library.AddHealth(player, "BOMB_HEART", hp)
end

function mod:CanPickBombHearts(player)
	return CustomHealthAPI.Library.CanPickKey(player, "BOMB_HEART")
end

mod:AddCallback(CustomHealthAPI.Enums.Callbacks.POST_HEALTH_DAMAGED, function(_, player, flags, key, hpDamaged, wasDepleted, wasLastDamaged)
	if wasDepleted then
		Isaac.Explode(player.Position, player, 100)
	end
end, "BOMB_HEART")

----------------------------
-- Fool's Gold Hearts
----------------------------

function mod.GetFoolsGoldHeartsNum(player)
	return CustomHealthAPI.Library.GetHPOfKey(player, "FOOLS_GOLD_HEART")
end

function mod:AddFoolsGoldHearts(player, hp)
	CustomHealthAPI.Library.AddHealth(player, "FOOLS_GOLD_HEART", hp)
end

function mod:CanPickFoolsGoldHearts(player)
	return CustomHealthAPI.Library.CanPickKey(player, "FOOLS_GOLD_HEART")
end

function mod:TriggerFoolsGoldHearts(player, numTriggered)
	local burst = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, player.Position, Vector(0, 0), player):ToEffect()
	local burstSprite = burst:GetSprite()
	burstSprite:Load("gfx/293.000_ultragreedcoins.anm2", true)
	burstSprite:Play("CrumbleNoDebris", true)
	burstSprite.Color = foolsGoldSplatColor
	burst:Update()

	local crater = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_CRATER, 0, player.Position, Vector(0, 0), player):ToEffect()
	crater:SetColor(foolsGoldTrailColor, 99999999, 1, false, false)
	crater:Update()

	local rng = player:GetDropRNG()
	for i = 1, numTriggered do
		game:SpawnParticles(player.Position, EffectVariant.GOLD_PARTICLE, 10, mod:RandomFloat(8, 20), foolsGoldSplatColor, 0)

		for j = 1, mod:RandomInt(3,8) do
			local randvec = Vector.FromAngle(mod:RandomFloat(360)) * mod:RandomFloat(1.5, 5)
			local subt = mod:RandomInt(99) == 0 and mod.PICKUP.COIN.GOLDENCURSED or mod.PICKUP.COIN.CURSED
			local coin = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, subt, player.Position + randvec, randvec, player):ToPickup()
		end
	end

	local fearDuration = 300 * (player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1)
	for _, ent in ipairs(Isaac.FindInRadius(player.Position, 160.0, EntityPartition.ENEMY)) do
		if ent:ToNPC() and
		   not (ent:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) or
		        ent:HasEntityFlags(EntityFlag.FLAG_NO_TARGET))
		then
			ent:AddFear(EntityRef(player), fearDuration)
			ent:SetColor(foolsGoldSplatColor, 15, 255, true, true)
		end
	end

	sfx:Play(SoundEffect.SOUND_ULTRA_GREED_COIN_DESTROY, 1.0, 0, false, 0.7)
	sfx:Play(mod.Sounds.DirePayout, 0.4, 0, false, 1.1)
end

mod:AddCallback(CustomHealthAPI.Enums.Callbacks.POST_OVERLAY_BROKEN, function(_, player, key, amount, wasDamage)
	mod:TriggerFoolsGoldHearts(player, amount)
end, "FOOLS_GOLD_HEART")

----------------------------
-- Eternal Shield (Only given from Eternal Pendant)
----------------------------

function mod.GetEternalShieldNum(player)
	return CustomHealthAPI.Library.GetHPOfKey(player, "ETERNAL_SHIELD")
end

function mod:AddEternalShield(player)
	local mult = math.max(1, player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.ETERNAL_PENDANT))
	local num = mod.GetEternalShieldNum(player)
	local max = mult*3
	if num < max then
		local add = math.min(max-num, 3)
		CustomHealthAPI.Library.AddHealth(player, "ETERNAL_SHIELD", add)
	end
end

mod:AddCallback(CustomHealthAPI.Enums.Callbacks.PRE_HEALTH_DAMAGED, function(_, player, flags, redKey, redHP, otherKey, otherHP, amount)
	if amount > 0 then
		if otherHP > 1 then
			sfx:Play(SoundEffect.SOUND_SCYTHE_BREAK, 1, 0, false, 1)
		else
			sfx:Play(SoundEffect.SOUND_HOLY_MANTLE, 1, 0, false, 1)
		end
		mod.scheduleForUpdate(function()
        	mod:StopFFPlayerSoundsIGuess(player)
            sfx:Stop(SoundEffect.SOUND_ISAAC_HURT_GRUNT)
        end, 0)
		return 1
	end
end, "ETERNAL_SHIELD")

----------------------------
-- Leaky Hearts
----------------------------

local LEAKY_COUNTDOWN = 450 -- how many update frames until the leaky heart loses a 1/2 red heart (30/sec)
local LEAKY_COUNTDOWN_MAGGY = 300 -- how many update frames until the leaky heart loses a 1/2 red heart as tainted maggie (30/sec)

function mod.GetLeakyHeartsNum(player)
	return CustomHealthAPI.Library.GetHPOfKey(player, "LEAKY_HEART")
end

function mod:AddLeakyHearts(player, hp)
	CustomHealthAPI.Library.AddHealth(player, "LEAKY_HEART", hp)
end

function mod:CanPickLeakyHearts(player)
	return CustomHealthAPI.Library.CanPickKey(player, "LEAKY_HEART")
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
	local bleedKey = CustomHealthAPI.Helper.GetLowestPriorityRedKeyInContainer(player, "LEAKY_HEART")
	local data = mod:GetEntityData(player)
	if bleedKey then
		local isTaintedMaggie = player:GetPlayerType() == PlayerType.PLAYER_MAGDALENE_B
		local healthDrainCooldown = player:GetMaggyHealthDrainCooldown()
		if isTaintedMaggie and healthDrainCooldown < 300 then
			data.LeakyHeartCountdown = math.min(data.LeakyHeartCountdown or 300, healthDrainCooldown + 1)
			player:SetMaggyHealthDrainCooldown(300)
		end
		if data.LeakyHeartCountdown == nil then
			data.LeakyHeartCountdown = (isTaintedMaggie and LEAKY_COUNTDOWN_MAGGY) or LEAKY_COUNTDOWN
		end
		data.LeakyHeartCountdown = data.LeakyHeartCountdown - 1
		if data.LeakyHeartCountdown == 0 then
			CustomHealthAPI.Library.AddHealth(player, bleedKey, (CustomHealthAPI.Library.GetInfoOfKey(bleedKey, "MaxHP") == 1 and -2) or -1)
			data.LeakyHeartCountdown = (isTaintedMaggie and LEAKY_COUNTDOWN_MAGGY) or LEAKY_COUNTDOWN
		end

		local sdata = CustomHealthAPI.Helper.GetSavedata(player)
		if math.random() <= 0.20 and
		   not (player:HasEntityFlags(EntityFlag.FLAG_BLEED_OUT) or
		        player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_ANEMIC) or
		        (sdata and sdata.ShardBleedTimer) or
		        healthDrainCooldown > 0)
		then
			local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, player.Position, Vector.Zero, player):ToEffect()
			local creepScale = math.random() * 0.5 + 0.2
			creep.SpriteScale = Vector(creepScale, creepScale)
			creep:Update()
		end
	else
		data.LeakyHeartCountdown = nil
	end
end)

----------------------------
-- Steven Hearts
----------------------------

local STEVEN_SHOOT_LEN = 48 -- how many frames the steven heart shoot anim lasts for
local STEVEN_SHOOT_FRAME = 6 -- what frame the steven heart shoots on
local STEVEN_HEALTH_INDEX_DELAY = 8 -- how many frames of delay per health index for shooting

function mod.GetStevenHeartsNum(player)
	return CustomHealthAPI.Library.GetHPOfKey(player, "STEVEN_HEART")
end

function mod:AddStevenHearts(player, hp)
	CustomHealthAPI.Library.AddHealth(player, "STEVEN_HEART", hp)
end

function mod:CanPickStevenHearts(player)
	return CustomHealthAPI.Library.CanPickKey(player, "STEVEN_HEART")
end

function mod:stevenHeartDropSound()
	sfx:Play(FiendFolio.Sounds.TimeFcukPlayerLand, 1.5, 0, false, 0.8)
	sfx:Play(SoundEffect.SOUND_MEAT_FEET_SLOW0, 1.0, 0, false, 0.8)
end

function mod:stevenHeartCollectSound()
	sfx:Play(FiendFolio.Sounds.TimeFcukTalkie, 1.5, 0, false, 1)
	sfx:Play(SoundEffect.SOUND_BOSS2_BUBBLES, 0.7, 0, false, 0.6)
	sfx:Play(FiendFolio.Sounds.GravediggerDig, 0.5, 0, false, 1)
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
	local data = mod:GetEntityData(player)
	local playerToCheck = player
	if player:GetPlayerType() == FiendFolio.PLAYER.BRIEND and not mod:IsSelectedBriend(player) then
		playerToCheck = player:GetOtherTwin()
	end
	if mod.GetStevenHeartsNum(playerToCheck) > 0 and not player:GetEffects():HasNullEffect(NullItemID.ID_LOST_CURSE) then
		local gameframe = game:GetFrameCount()
		local enemies = Isaac.FindInRadius(player.Position, 9999, EntityPartition.ENEMY)
		for _, enemy in ipairs(enemies) do
			if enemy:ToNPC() and enemy.HitPoints > 0 and not enemy:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) and enemy:IsVulnerableEnemy() and not mod:isFriend(enemy) then
				if data.StevenHeartStoppedShootingAtFrame ~= nil or data.StevenHeartStartedShootingAtFrame == nil then
					data.StevenHeartStartedShootingAtFrame = gameframe
				end
				data.StevenHeartStoppedShootingAtFrame = nil
				data.CanDoStevenHeartShot = true
				return
			end
		end
		if data.StevenHeartStoppedShootingAtFrame == nil then
			data.StevenHeartStoppedShootingAtFrame = gameframe
		end
	else
		data.StevenHeartStartedShootingAtFrame = nil
		data.StevenHeartStoppedShootingAtFrame = nil
		data.CanDoStevenHeartShot = nil
	end
end)

mod:AddCallback(CustomHealthAPI.Enums.Callbacks.PRE_HEALTH_RENDER, function(_, player, playerSlot, healthIndex, info)
    if player:GetPlayerType() ~= FiendFolio.PLAYER.BRIEND or mod:IsSelectedBriend(player) then
		local data = mod:GetEntityData(player)
		local startedframe = data.StevenHeartStartedShootingAtFrame
		local endedframe = data.StevenHeartStoppedShootingAtFrame
		local gameframe = game:GetFrameCount() - healthIndex * STEVEN_HEALTH_INDEX_DELAY
		if startedframe and gameframe >= startedframe then
			local animframe = (gameframe - startedframe) % STEVEN_SHOOT_LEN
			if not endedframe or gameframe < endedframe or math.floor((endedframe - startedframe) / STEVEN_SHOOT_LEN) >= math.floor((gameframe - startedframe) / STEVEN_SHOOT_LEN) then
				return {AnimationName = "StevenOverlayShoot", AnimationFrame = animframe}
			end
		end
    end
end, "STEVEN_HEART")

local stevenTears = {}
mod:AddCallback(CustomHealthAPI.Enums.Callbacks.POST_HEALTH_RENDER, function(_, player, playerSlot, healthIndex, info)
    local data = mod:GetEntityData(player)
	if info.Frame == STEVEN_SHOOT_FRAME and data.CanDoStevenHeartShot then
		local order = CustomHealthAPI.Library.GetHealthInOrder(player)
		local entry = order[info.OrderIndex]
		if entry then
			local firePos = CustomHealthAPI.Helper.GetHealthRenderPos(player, playerSlot, healthIndex, info.RenderOffset, info.TotalHealthRendered, info.ExtraOffset) + Isaac.WorldToScreenDistance(Vector(0,23))
			local keys = {}
			if entry.Red and entry.Red.Key then table.insert(keys, entry.Red.Key) end
			if entry.Other and entry.Other.Key then table.insert(keys, entry.Other.Key) end
			for _, overlay in pairs(entry.Overlays) do
				if overlay.Key ~= "STEVEN_HEART" then
					table.insert(keys, overlay.Key)
				end
			end
			local pos = Isaac.ScreenToWorld(Vector.Zero) + Isaac.ScreenToWorldDistance(firePos)
			if StageAPI.IsMirrorDimension() then
				local topLeft = Isaac.RenderToWorld(Vector(0,0))
				local bottomRight = Isaac.RenderToWorld(game:GetRoom():GetRenderSurfaceTopLeft() * 2 + Vector(442,286))
				local center = (topLeft + bottomRight) / 2
				pos = (pos - center) * Vector(-1,1) + center
			end
			table.insert(stevenTears, {Position = pos, Keys = keys, Player = player})
		end
	end
end, "STEVEN_HEART")

mod:AddCallback(CustomHealthAPI.Enums.Callbacks.POST_RENDER_HP_BAR, function(_, player)
	mod:GetEntityData(player).CanDoStevenHeartShot = nil
end)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
	-- doing game logic in a render callback? dear god
	if #stevenTears > 0 then
		local enemies = Isaac.FindInRadius(game:GetRoom():GetCenterPos(), 9999, EntityPartition.ENEMY)
		local targets = {}
		for _, enemy in ipairs(enemies) do
			if enemy:ToNPC() and enemy.HitPoints > 0 and not enemy:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) and enemy:IsVulnerableEnemy() and not mod:isFriend(enemy) then
				table.insert(targets, {Position = enemy.Position, Target = enemy})
			end
		end
		for _, tearInfo in ipairs(stevenTears) do
			if tearInfo.Player:Exists() then
				local closest, closestDist = nil, math.huge
				for _, target in ipairs(targets) do
					local dist = target.Position:Distance(tearInfo.Position)
					if dist < closestDist then
						closest = target
						closestDist = dist
					end
				end
				if closest then
					local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, FiendFolio.TEAR.MULTI_EUCLIDEAN, 0, tearInfo.Position, (closest.Position - tearInfo.Position):Resized(10), tearInfo.Player):ToTear()
					mod:GetEntityData(tear).stevenHeartTear = true
					tear.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
					tear.CollisionDamage = 3.5
					tear.FallingSpeed = -0.1
					tear.FallingAcceleration = -0.05
					tear.Scale = 0.8
					tear:ResetSpriteScale()

					TearFlagsLib.AddTearFlags(tear, mod.FriendBulletFlags.NO_FALL_TEAR)
					tear:AddTearFlags(TearFlags.TEAR_HOMING)
					tear.Target = closest.Target

					if tearInfo.Player:HasTrinket(mod.ITEM.TRINKET.STEVENS_BOX) then
						local boxMult = tearInfo.Player:GetTrinketMultiplier(mod.ITEM.TRINKET.STEVENS_BOX)
						tear.CollisionDamage = tear.CollisionDamage * (1 + boxMult)
					end

					local hasSetColor = false
					for _, key in ipairs(tearInfo.Keys) do
						if key == "BLACK_HEART" then
							tear.CollisionDamage = tear.CollisionDamage * 1.25
							if math.random() < 1 / (5 - math.floor(tearInfo.Player.Luck * 0.1)) then
								tear.TearFlags = tear.TearFlags | TearFlags.TEAR_FEAR
							end
							tear.TearFlags = tear.TearFlags | TearFlags.TEAR_DARK_MATTER
							tear.Color = Color(1,1,1,1,0,0,0,0.3,0.3,0.3,1)
							tear.Scale = tear.Scale * 1.1
							tear:ResetSpriteScale()
							hasSetColor = true
						elseif key == "ETERNAL_HEART" then
							tear.CollisionDamage = tear.CollisionDamage * 1.5
							tear.Scale = tear.Scale * 1.3
							tear:ResetSpriteScale()
							tear.TearFlags = tear.TearFlags | TearFlags.TEAR_HOMING
						elseif key == "BONE_HEART" then
							tear:ChangeVariant(TearVariant.BONE)
							if not hasSetColor then tear.Color = Color(-2,-2,-2,1,1,1,1,1,1,1,1) end
							tear.TearFlags = tear.TearFlags | TearFlags.TEAR_BONE
						elseif key == "ROTTEN_HEART" then
							if math.random() < 1 / 6 then
								mod:GetEntityData(tear).nuggetMulligan = tearInfo.Player
							end
						elseif key == "IMMORAL_HEART" then
							tear.Color = Color(1.1,1.1,1.1,1,50/255,-75/255,50/255)
							if math.random(25) == 1 then
								TearFlagsLib.AddTearFlags(tear, mod.CritFlag)
								local data = mod:GetEntityData(tear)
								if not data.critLightning or not data.critLightning:Exists() then
									sfx:Play(mod.Sounds.CritShoot, 0.3, 0, false, math.random(80,120)/100)
									local critLightning = Isaac.Spawn(1000, 1737, 1, tear.Position, nilvector, tear):ToEffect()
									critLightning.Parent = tear
									critLightning.Color = Color(1,1,1,0,0,0,1)
									critLightning:Update()
									data.critLightning = critLightning
								end
								tear.Color = Color(1.3,1.3,1.3,1,100/255,-150/255,100/255)
							end
							hasSetColor = true
						elseif key == "MORBID_HEART" then
							if math.random(10) == 1 then
								mod:changeTearVariant(tear, TearVariant.TOOTH)
								if not hasSetColor then tear.Color = Color(-2,-2,-2,1,1,1,1,1,1,1,1) end
								tear.CollisionDamage = tear.CollisionDamage * 3.2
							end
						elseif key == "LEAKY_HEART" then
							TearFlagsLib.AddTearFlags(tear, mod.FriendBulletFlags.LEAKY)
							TearFlagsLib.SetTearFlagParams(tear, mod.FriendBulletFlags.LEAKY, {Player = tearInfo.Player})
							tear.Color = Color(1, 1, 1, 1, 0.1958, -0.1449, -0.0391, 0.8827, 0.5847, 0.4926, 1)
							hasSetColor = true
						end
						Isaac.RunCallbackWithParam(FiendFolio.CALLBACK.FF_APPLY_STEVEN_HEART_TEAR_EFFECT, key, tear, tearInfo.Player, key)
					end
				end
			end
		end
		stevenTears = {}
	end
end)
