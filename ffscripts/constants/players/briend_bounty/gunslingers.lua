local mod = FiendFolio
local gunTypes = mod.BountyGunTypes



-- Convert an entity's Type, Variant and Subtype to a string key
---@param type integer
---@param variant? integer Can be left out to count all Variants.
---@param subtype? integer Can be left out to count all SubTypes.
---@return string
function FiendFolio:TypeKey(type, variant, subtype)
	local key = tostring(type)

	-- Variant
	if variant then
		key = key .. "." .. variant
	end
	-- SubType
	if subtype then
		key = key .. "." .. subtype
	end

	return key
end



mod.GunslingerSelection = {
	MinimumHealth = 8,
	BerserkDuration = 30, -- Birthright Berserk duration after killing everything else

	-- Health multipliers for gunslingers
	HealthMulti = {
		Regular  = 1.8,
		Champion = 1.4,
	},

	-- Boss dual wielding chance
	DualWieldChance = {
		Base 	  = 10,
		HeatBonus = 10, -- Added to the base chance for each heat level
	},

	-- Eternal Revolver chance
	EternalRevolver = {
		MinHeat    = 4,
		BaseChance = 11,
		HeatBonus  = 11, -- Added for each heat level above the minimum
	},



	-- The tiers and their included gun types and costume
	Tiers = {
		{ -- Tier 1 - Revolvers
			Costume = "Deputy",
			Guns = {
				{ Type = gunTypes.REVOLVER_BASIC, 	  Weight = 100, },
				{ Type = gunTypes.REVOLVER_SNUB_NOSE, Weight = 75, },
			},
		},
		{ -- Tier 2 - Shotguns
			Costume = "Mobster",
			Guns = {
				{ Type = gunTypes.SHOTGUN_PUMP_ACTION,   Weight = 100, },
				{ Type = gunTypes.SHOTGUN_DOUBLE_BARREL, Weight = 75, },
				{ Type = gunTypes.SHOTGUN_COMBAT, 		 Weight = 50, },
			},
		},
		{ -- Tier 3 - SMGs
			Costume = "Commando",
			Guns = {
				{ Type = gunTypes.SMG_MAC, Weight = 100, },
				{ Type = gunTypes.SMG_MP,  Weight = 100, },
				{ Type = gunTypes.SMG_UZI, Weight = 100, },
			},
		},
		{ -- Tier 4 - Rifles
			Costume = "Soldier",
			Guns = {
				{ Type = gunTypes.RIFLE_AK,  Weight = 100, },
				{ Type = gunTypes.RIFLE_M16, Weight = 100, },
			},
		},
		{ -- Tier 5 - Launchers
			Costume = "Badass",
			Guns = {
				{ Type = gunTypes.GRENADE_LAUNCHER, Weight = 100, },
				{ Type = gunTypes.ROCKET_LAUNCHER,  Weight = 100, },
			},
		},
	},

	-- The max amount the gun tier can deviate from the heat level
	MaxTierDifference = {
		Lower  = 2,
		Higher = 1
	},
	-- Subtracted from 100 for each tier lower / higher than the current heat level
	TierWeightDecreases = {
		Lower  = 25,
		Higher = 50,
	},



	-- Enemies that should ALWAYS be allowed to become gunslingers
	AlwaysAllow = {
		[ mod:TypeKey(EntityType.ENTITY_SATAN) ] = true,
		[ mod:TypeKey(mod.FF.TDweller.ID, mod.FF.TDweller.Var) ] = true,
		[ mod:TypeKey(mod.FF.Fishaac.ID, mod.FF.Fishaac.Var) ] = true,
		[ mod:TypeKey(mod.FF.Whispers.ID, mod.FF.Whispers.Var) ] = true,
	},



	-- Enemies that are blacklisted from becoming gunslingers (enemies that don't shut doors are automatically blacklisted)
	-- Also accepts a function that should return a non-nil, non-false value to blacklist the entity
	Blacklist = {
		-- Vanilla
		[ mod:TypeKey(EntityType.ENTITY_FLY) ] = true,
		[ mod:TypeKey(EntityType.ENTITY_ATTACKFLY) ] = true,
		[ mod:TypeKey(EntityType.ENTITY_MOM, 0) ] = true,
		[ mod:TypeKey(EntityType.ENTITY_ENVY) ] = function(entity) return entity.Variant > 11 end,
		[ mod:TypeKey(EntityType.ENTITY_SUCKER, 5) ] = true,
			[ mod:TypeKey(EntityType.ENTITY_SUCKER, 6) ] = true,
		[ mod:TypeKey(EntityType.ENTITY_WAR, 1) ] = function(entity) return entity.SpawnerEntity end,
		[ mod:TypeKey(EntityType.ENTITY_DEATH, 20) ] = true,
		[ mod:TypeKey(EntityType.ENTITY_PEEP, 10) ] = true,
			[ mod:TypeKey(EntityType.ENTITY_PEEP, 11) ] = true,
		[ mod:TypeKey(EntityType.ENTITY_FISTULA_SMALL) ] = true,
		[ mod:TypeKey(EntityType.ENTITY_FISTULA_MEDIUM) ] = function(entity) return entity.SpawnerType == EntityType.ENTITY_MATRIARCH end,
		[ mod:TypeKey(EntityType.ENTITY_BLASTOCYST_SMALL) ] = true,
		[ mod:TypeKey(EntityType.ENTITY_MOTER) ] = true,
		[ mod:TypeKey(EntityType.ENTITY_SPIDER) ] = true,
			[ mod:TypeKey(EntityType.ENTITY_BIGSPIDER) ] = true,
		[ mod:TypeKey(EntityType.ENTITY_DADDYLONGLEGS) ] = function(entity) return entity.SpawnerEntity end,
		[ mod:TypeKey(EntityType.ENTITY_DIP) ] = true,
		[ mod:TypeKey(EntityType.ENTITY_RING_OF_FLIES) ] = true,
		[ mod:TypeKey(EntityType.ENTITY_DART_FLY) ] = true,
		[ mod:TypeKey(EntityType.ENTITY_MEGA_SATAN, 1) ] = true,
			[ mod:TypeKey(EntityType.ENTITY_MEGA_SATAN, 2) ] = true,
		[ mod:TypeKey(EntityType.ENTITY_SWARM) ] = true,
		[ mod:TypeKey(EntityType.ENTITY_HUSH_FLY) ] = true,
		[ mod:TypeKey(EntityType.ENTITY_LEPER, 1) ] = true,
		[ mod:TypeKey(EntityType.ENTITY_LITTLE_HORN, 1) ] = true,
		[ mod:TypeKey(EntityType.ENTITY_BIG_HORN, 1) ] = true,
			[ mod:TypeKey(EntityType.ENTITY_BIG_HORN, 2) ] = true,
		[ mod:TypeKey(EntityType.ENTITY_BISHOP) ] = true,
		[ mod:TypeKey(EntityType.ENTITY_WILLO) ] = true,
		[ mod:TypeKey(EntityType.ENTITY_SMALL_LEECH) ] = true,
		[ mod:TypeKey(EntityType.ENTITY_STRIDER) ] = true,
		[ mod:TypeKey(EntityType.ENTITY_ROCK_SPIDER) ] = true,
		[ mod:TypeKey(EntityType.ENTITY_FLY_BOMB) ] = true,
		[ mod:TypeKey(EntityType.ENTITY_SMALL_MAGGOT) ] = true,
		[ mod:TypeKey(EntityType.ENTITY_PUSTULE) ] = true,
		[ mod:TypeKey(EntityType.ENTITY_MOTHERS_SHADOW) ] = true,
		[ mod:TypeKey(EntityType.ENTITY_ARMYFLY) ] = true,
		[ mod:TypeKey(EntityType.ENTITY_DRIP) ] = true,
		[ mod:TypeKey(EntityType.ENTITY_SWARM_SPIDER) ] = true,
		[ mod:TypeKey(EntityType.ENTITY_DOGMA, 1) ] = true,

		-- FF
		[ mod:TypeKey(mod.FF.Drumstick.ID, mod.FF.Drumstick.Var) ] = true,
			[ mod:TypeKey(mod.FF.HolyDrumstick.ID, mod.FF.HolyDrumstick.Var) ] = true,
		[ mod:TypeKey(mod.FF.LittleBoy.ID, mod.FF.LittleBoy.Var) ] = true,
		[ mod:TypeKey(mod.FF.AmonArm.ID, mod.FF.AmonArm.Var) ] = true, -- Why are these Whipper variants?
		[ mod:TypeKey(mod.FF.WatcherEye.ID, mod.FF.WatcherEye.Var) ] = true,
		[ mod:TypeKey(mod.FF.Zissuru.ID, mod.FF.Zissuru.Var) ] = true,
		[ mod:TypeKey(mod.FF.Laideronnette.ID, mod.FF.Laideronnette.Var) ] = true,
		[ mod:TypeKey(mod.FF.Pawn.ID, mod.FF.Pawn.Var) ] = true,
		[ mod:TypeKey(mod.FF.Oralid.ID, mod.FF.Oralid.Var) ] = true,
		[ mod:TypeKey(mod.FF.Wimpy.ID, mod.FF.Wimpy.Var) ] = true,
		[ mod:TypeKey(mod.FF.Morsel.ID, mod.FF.Morsel.Var) ] = true,
			[ mod:TypeKey(mod.FF.Falafel.ID, mod.FF.Falafel.Var) ] = true,
			[ mod:TypeKey(mod.FF.Slick.ID, mod.FF.Slick.Var) ] = true,
			[ mod:TypeKey(mod.FF.Stump.ID, mod.FF.Stump.Var) ] = true,
		[ mod:TypeKey(mod.FF.Drop.ID, mod.FF.Drop.Var) ] = true,
		[ mod:TypeKey(mod.FF.Spark.ID, mod.FF.Spark.Var) ] = true,
		[ mod:TypeKey(mod.FF.Glob.ID, mod.FF.Glob.Var) ] = true,
		[ mod:TypeKey(mod.FF.Fossil.ID, mod.FF.Fossil.Var) ] = true,
		[ mod:TypeKey(mod.FF.Sentry.ID, mod.FF.Sentry.Var) ] = true,
		[ mod:TypeKey(mod.FF.Zingling.ID, mod.FF.Zingling.Var) ] = true,
		[ mod:TypeKey(mod.FF.Smokin.ID, mod.FF.Smokin.Var) ] = true,
		[ mod:TypeKey(mod.FF.Flickerspirit.ID, mod.FF.Flickerspirit.Var) ] = true,
		[ mod:TypeKey(mod.FF.Wire.ID, mod.FF.Wire.Var) ] = true,
		[ mod:TypeKey(mod.FF.Grape.ID, mod.FF.Grape.Var, mod.FF.Grape.Sub) ] = true,
		[ mod:TypeKey(mod.FF.Buckshot.ID, mod.FF.Buckshot.Var) ] = function(entity) return mod:GetEntityData(entity).state == "charge" end,
		[ mod:TypeKey(mod.FF.ThousandEyesCharge.ID, mod.FF.ThousandEyesCharge.Var, mod.FF.ThousandEyesCharge.Sub) ] = true,
			[ mod:TypeKey(mod.FF.ThousandEyesLook.ID, mod.FF.ThousandEyesLook.Var, mod.FF.ThousandEyesLook.Sub) ] = true,
			[ mod:TypeKey(mod.FF.ThousandEyesWait.ID, mod.FF.ThousandEyesWait.Var, mod.FF.ThousandEyesWait.Sub) ] = true,
		[ mod:TypeKey(mod.FF.Shiitake.ID, mod.FF.Shiitake.Var) ] = true,
		[ mod:TypeKey(mod.FF.Limb.ID, mod.FF.Limb.Var, mod.FF.Limb.Sub) ] = true,
			[ mod:TypeKey(mod.FF.PaleLimb.ID, mod.FF.PaleLimb.Var, mod.FF.PaleLimb.Sub) ] = true,
		[ mod:TypeKey(mod.FF.Smidgen.ID, mod.FF.Smidgen.Var) ] = true,
			[ mod:TypeKey(mod.FF.RedSmidgen.ID, mod.FF.RedSmidgen.Var) ] = true,
			[ mod:TypeKey(mod.FF.ErodedSmidgen.ID, mod.FF.ErodedSmidgen.Var) ] = true,
			[ mod:TypeKey(mod.FF.Tittle.ID, mod.FF.Tittle.Var) ] = true,
		[ mod:TypeKey(mod.FF.Enlightened.ID, mod.FF.Enlightened.Var) ] = true,
			[ mod:TypeKey(mod.FF.InnerEye.ID, mod.FF.InnerEye.Var) ] = true,
		[ mod:TypeKey(mod.FF.Psiling.ID, mod.FF.Psiling.Var) ] = true,
		[ mod:TypeKey(mod.FF.Umbra.ID, mod.FF.Umbra.Var) ] = true,
		[ mod:TypeKey(mod.FF.Deathany.ID, mod.FF.Deathany.Var) ] = true,
		[ mod:TypeKey(mod.FF.Galgalim.ID, mod.FF.Galgalim.Var) ] = true,
		[ mod:TypeKey(mod.FF.SpicyDip.ID, mod.FF.SpicyDip.Var) ] = true,
		[ mod:TypeKey(mod.FF.LightningFly.ID, mod.FF.LightningFly.Var) ] = true,
		[ mod:TypeKey(mod.FF.Blot.ID, mod.FF.Blot.Var) ] = true,
		[ mod:TypeKey(mod.FF.Commission.ID, mod.FF.Commission.Var) ] = true,
		[ mod:TypeKey(mod.FF.SunBody.ID, mod.FF.SunBody.Var) ] = true, -- Only matters for Greed Mode?
		[ mod:TypeKey(mod.FF.WhispersController.ID, mod.FF.WhispersController.Var) ] = true,
		[ mod:TypeKey(mod.FF.CacophobiaVenus.ID, mod.FF.CacophobiaVenus.Var) ] = true,
		[ mod:TypeKey(mod.FF.ShotFly.ID, mod.FF.ShotFly.Var) ] = true,
			[ mod:TypeKey(mod.FF.Shoter.ID, mod.FF.Shoter.Var) ] = true,
		[ mod:TypeKey(mod.FF.Ztewie.ID, mod.FF.Ztewie.Var) ] = true,
		[ mod:TypeKey(mod.FF.Sponge.ID, mod.FF.Sponge.Var) ] = true,
		[ mod:TypeKey(mod.FF.Casualty.ID, mod.FF.Casualty.Var) ] = true,
		[ mod:TypeKey(mod.FF.ShrunkenHead.ID, mod.FF.ShrunkenHead.Var) ] = true,
		[ mod:TypeKey(mod.FF.GamperGuts.ID, mod.FF.GamperGuts.Var) ] = true,
		[ mod:TypeKey(mod.FF.Litling.ID, mod.FF.Litling.Var) ] = true,
		[ mod:TypeKey(mod.FF.Murder.ID, mod.FF.Murder.Var) ] = true,
		[ mod:TypeKey(mod.FF.Beacon.ID, mod.FF.Beacon.Var) ] = true,
		[ mod:TypeKey(mod.FF.Beetle.ID, mod.FF.Beetle.Var) ] = true,
		[ mod:TypeKey(mod.FF.Skuzz.ID, mod.FF.Skuzz.Var) ] = true,
			[ mod:TypeKey(mod.FF.CongaSkuzz.ID, mod.FF.CongaSkuzz.Var) ] = true,
			[ mod:TypeKey(mod.FF.RingSkuzz.ID, mod.FF.RingSkuzz.Var) ] = true,
		[ mod:TypeKey(mod.FF.Creepterum.ID, mod.FF.Creepterum.Var) ] = true,
		[ mod:TypeKey(mod.FF.BeadFly.ID, mod.FF.BeadFly.Var) ] = true,
		[ mod:TypeKey(mod.FF.Spoop.ID, mod.FF.Spoop.Var) ] = true,
		[ mod:TypeKey(mod.FF.LurkerCore.ID, mod.FF.LurkerCore.Var) ] = true,
	},



	-- Segmented enemies that can be gunslingers even if they're not the main segment
	AllowSegments = {
		[ mod:TypeKey(EntityType.ENTITY_GEMINI) ] = true,
		[ mod:TypeKey(EntityType.ENTITY_HEART_OF_INFAMY) ] = true,
	},



	-- Bosses that shouldn't be able to dual wield
	DontDualWield = {
		[ mod:TypeKey(EntityType.ENTITY_THE_LAMB) ] = true,
		[ mod:TypeKey(EntityType.ENTITY_CHIMERA) ] = true,
		[ mod:TypeKey(mod.FF.Idolator.ID, mod.FF.Idolator.Var) ] = true,
	},
}



-- Turn the tier data into outcome pickers
for tier, entry in pairs(mod.GunslingerSelection.Tiers) do
	local picker = WeightedOutcomePicker()

	for i, gun in pairs(entry.Guns) do
		picker:AddOutcomeWeight(gun.Type, gun.Weight)
	end
	mod.GunslingerSelection.Tiers[tier].Picker = picker
end



-- Check if the given entity is in the given list using its Type, Variant and Subtype as a string key
---@param list table
---@param entity Entity
---@return table | boolean
function FiendFolio:IsOnList(list, entity)
	return
	list[ entity.Type .. "." .. entity.Variant .. "." .. entity.SubType ]
	or list[ entity.Type .. "." .. entity.Variant ]
	or list[ tostring(entity.Type) ]
	or false
end