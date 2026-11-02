-- Sewing Manual --

-- todo: beah stuff, friends fireball formula luck, stuff migrated tearflagslib

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local spoonBenderColor = Color(0.4, 0.15, 0.38, 1.0, 0.278431, 0.0, 0.454902, 0.0, 0.0, 0.0, 0.0)
local numberOneColor = Color(1.0, 1.0, 0.0, 1.0, 0.176471, 0.0588235, 0.0, 0.0, 0.0, 0.0, 0.0)
local spiderBiteColor = Color(2.0, 2.0, 2.0, 1.0, 0.196078, 0.196078, 0.196078, 0.0, 0.0, 0.0, 0.0)
local commonColdColor = Color(0.4, 0.97, 0.5, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
local parasiteColor = Color(0.9, 0.3, 0.08, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
local momsContactColor = Color(1.25, 0.05, 0.15, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
local spectralColor = Color(1.5, 2.0, 2.0, 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) -- Ouija Board, Spirit of the Night, Dead Dove
local lumpOfCoalColor = Color(0.2, 0.09, 0.065, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
local ipecacColor = Color(0.5, 0.9, 0.4, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
local sacredHeartColor = Color(1.5, 2.0, 2.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
local momsEyeshadowColor = Color(1.0, 0.0, 1.0, 1.0, 0.196078, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
local ironBarColor = Color(0.5, 0.5, 0.5, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
local rubberCementColor = Color(1.0, 1.0, 0.8, 1.0, 0.1, 0.1, 0.1, 0.0, 0.0, 0.0, 0.0)
local momsPerfumeColor = Color(1.0, 1.0, 0.454902, 1.0, 0.168627, 0.145098, 0.0, 0.0, 0.0, 0.0, 0.0)
local abaddonColor = Color(0.392157, 0.392157, 0.392157, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
local ballOfTarColor = Color(0.15, 0.15, 0.15, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
local fireMindColor = Color(1.0, 1.0, 1.0, 1.0, 0.3, 0.0, 0.0, 1.8, 0.9, 0.3, 1.0)
local darkMatterColor = Color(1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 1.0)
local scorpioColor = Color(0.196078, 1.0, 0.196078, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
local evesMascaraColor = Color(0.2, 0.2, 0.2, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
local mysteriousLiquidColor = Color(1.0, 1.0, 1.0, 1.0, 0.0, 0.2, 0.0, 0.2, 1.0, 0.2, 1.0)
local soyMilkColor = Color(1.5, 2.0, 2.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
local deadOnionColor = Color(0.5, 0.25, 0.1, 0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
local serpentsKissColor = Color(0.5, 0.97, 0.5, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
local sulfuricAcidColor = Color(1.0, 1.0, 0.1, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
local transparentColor = Color(0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) -- Little Horn, Ocular Rift
local almondMilkColor = Color(1.8, 1.7, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
local eyeOfTheOccultColor = Color(1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.3, 0.0, 0.25, 1.0)
local lodestoneColor = Color(1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 1.0)
local rottenTomatoColor = Color(0.7, 0.14, 0.1, 1.0, 0.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)

local playdoughBrownColor = Color(1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.7, 0.6, 0.4, 1.5)
local playdoughRedColor = Color(1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.9, 0.2, 0.2, 1.5)
local playdoughPinkColor = Color(1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 1.0, 0.4, 0.7, 1.5)
local playdoughPurpleColor = Color(1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 1.0, 0.4, 1.2, 1.5)
local playdoughBlueColor = Color(1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.3, 0.4, 1.0, 1.5)
local playdoughCyanColor = Color(1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.4, 0.7, 1.0, 1.5)
local playdoughGreenColor = Color(1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.4, 0.8, 0.5, 1.5)
local playdoughYellowColor = Color(1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.8, 0.9, 0.1, 1.5)
local playdoughOrangeColor = Color(1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 1.0, 0.4, 0.2, 1.5)

local continuumColors = {
	Color(1, 1, 1, 1, 0, 0, 0, 1, 0.33, 1, 1),
	Color(1, 1, 1, 1, 0, 0, 0, 1, 0.66, 1, 1),
	Color(1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1),
	Color(1, 1, 1, 1, 0, 0, 0, 0.66, 0.66, 0.66, 1),
	Color(1, 1, 1, 1, 0, 0, 0, 0.33, 0.33, 0.33, 1),
	Color(0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0),
	Color(1, 1, 1, 1, 0, 0, 0, 0.33, 0, 0.33, 1),
	Color(1, 1, 1, 1, 0, 0, 0, 0.66, 0, 0.66, 1),
	Color(1, 1, 1, 1, 0, 0, 0, 1, 0, 1, 1),
}

local playdoughRainbowColors = {
	Color(1, 1, 1, 1, 0, 0, 0, 4, 0.4, 0.4, 1),
	Color(1, 1, 1, 1, 0, 0, 0, 4, 1.12, 0.4, 1),
	Color(1, 1, 1, 1, 0, 0, 0, 4, 1.84, 0.4, 1),
	Color(1, 1, 1, 1, 0, 0, 0, 4, 2.56, 0.4, 1),
	Color(1, 1, 1, 1, 0, 0, 0, 4, 3.28, 0.4, 1),
	Color(1, 1, 1, 1, 0, 0, 0, 4, 4, 0.4, 1),
	Color(1, 1, 1, 1, 0, 0, 0, 3.28, 4, 0.4, 1),
	Color(1, 1, 1, 1, 0, 0, 0, 2.56, 4, 0.4, 1),
	Color(1, 1, 1, 1, 0, 0, 0, 1.84, 4, 0.4, 1),
	Color(1, 1, 1, 1, 0, 0, 0, 1.12, 4, 0.4, 1),
	Color(1, 1, 1, 1, 0, 0, 0, 0.4, 4, 0.4, 1),
	Color(1, 1, 1, 1, 0, 0, 0, 0.4, 4, 1.12, 1),
	Color(1, 1, 1, 1, 0, 0, 0, 0.4, 4, 1.84, 1),
	Color(1, 1, 1, 1, 0, 0, 0, 0.4, 4, 2.56, 1),
	Color(1, 1, 1, 1, 0, 0, 0, 0.4, 4, 3.28, 1),
	Color(1, 1, 1, 1, 0, 0, 0, 0.4, 4, 4, 1),
	Color(1, 1, 1, 1, 0, 0, 0, 0.4, 3.28, 4, 1),
	Color(1, 1, 1, 1, 0, 0, 0, 0.4, 2.56, 4, 1),
	Color(1, 1, 1, 1, 0, 0, 0, 0.4, 1.84, 4, 1),
	Color(1, 1, 1, 1, 0, 0, 0, 0.4, 1.12, 4, 1),
	Color(1, 1, 1, 1, 0, 0, 0, 0.4, 0.4, 4, 1),
	Color(1, 1, 1, 1, 0, 0, 0, 1.12, 0.4, 4, 1),
	Color(1, 1, 1, 1, 0, 0, 0, 1.84, 0.4, 4, 1),
	Color(1, 1, 1, 1, 0, 0, 0, 2.56, 0.4, 4, 1),
	Color(1, 1, 1, 1, 0, 0, 0, 3.28, 0.4, 4, 1),
	Color(1, 1, 1, 1, 0, 0, 0, 4, 0.4, 4, 1),
	Color(1, 1, 1, 1, 0, 0, 0, 4, 0.4, 3.28, 1),
	Color(1, 1, 1, 1, 0, 0, 0, 4, 0.4, 2.56, 1),
	Color(1, 1, 1, 1, 0, 0, 0, 4, 0.4, 1.84, 1),
	Color(1, 1, 1, 1, 0, 0, 0, 4, 0.4, 1.12, 1),
}

--Original
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_INNER_EYE] = {
	FireCooldown = 45,
	BodyColor = Color(1,1,1,1,132.221/255,10.699/255,7.442/255,0.372,0.735,0.743,1),
	EyeAColor = Color(1,1,1,1,65.549/255,122.681/255,223.920/255,0.602,0.425,0.106,1),
	EyeBColor = Color(1,1,1,1,65.549/255,122.681/255,223.920/255,0.602,0.425,0.106,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_SPOON_BENDER] = {
	TearColor = spoonBenderColor, 
	TearFlags = TearFlags.TEAR_HOMING,
	BodyColor = Color(1,1,1,1,13.549/255,13.549/255,13.549/255,0.602,0.602,0.602,1),
	EyeAColor = Color(1,1,1,1,-66.973/255,18.920/255,-36.124/255,0.965,0.106,0.832,1),
	EyeBColor = Color(1,1,1,1,-66.973/255,18.920/255,-36.124/255,0.965,0.106,0.832,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_MY_REFLECTION] = {
	TearDamage = 5.86,
	TearFallingSpeed = -0.885,
	TearFallingAccel = -0.06,
	TearVelocity = 16.0,
	BodyColor = Color(1,1,1,1,20.310/255,20.310/255,20.310/255,0.920,0.920,0.920,1),
	EyeAColor = Color(1,1,1,1,13.832/255,89.425/255,127.274/255,0.558,0.434,0.301,1),
	EyeBColor = Color(1,1,1,1,13.832/255,89.425/255,127.274/255,0.558,0.434,0.301,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_NUMBER_ONE] = {
	FireCooldown = 12,
	TearHeight = -5.75, 
	TearFallingSpeed = -0.972, 
	TearColor = numberOneColor,
	BodyColor = Color(1,1,1,1,132.221/255,10.699/255,7.442/255,0.372,0.735,0.743,1),
	EyeAColor = Color(1,1,1,1,131.484/255,99.609/255,-310.859/255,0.484,0.609,2.141,1),
	EyeBColor = Color(1,1,1,1,131.484/255,99.609/255,-310.859/255,0.484,0.609,2.141,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_CUPIDS_ARROW] = {
	TearVariant = TearVariant.CUPID_BLUE, 
	TearFlags = TearFlags.TEAR_PIERCING,
	BodyColor = Color(1,1,1,1,-2.451/255,-2.451/255,-2.451/255,0.602,0.602,0.602,1),
	EyeAColor = Color(1,1,1,1,-12.25/255,0,0,0.75,0,0,1),
	EyeBColor = Color(1,1,1,1,-12.25/255,0,0,0.75,0,0,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_MOMS_EYE] = {
	BodyColor = Color(1,1,1,1,132.221/255,10.699/255,7.442/255,0.372,0.735,0.743,1),
	EyeAColor = Color(1,1,1,1,65.549/255,122.681/255,223.920/255,0.602,0.425,0.106,1),
	EyeBColor = Color(1,1,1,1,-13.637/255,0,0,0.850,0/255,0/255,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_LOKIS_HORNS] = {
	BodyColor = Color(1,1,1,1,-13.637/255,0,0,0.850,0/255,0/255,1),
	EyeAColor = Color(1,1,1,1,10.788/255,10.788/255,10.788/255,0.283,0.283,0.283,1),
	EyeBColor = Color(1,1,1,1,10.788/255,10.788/255,10.788/255,0.283,0.283,0.283,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_SPIDER_BITE] = {
	ProcChance = 0.25,
	ProcTearColor = spiderBiteColor,
	ProcTearFlags = TearFlags.TEAR_SLOW,
	BodyColor = Color(1,1,1,1,-24.438/255,-24.438/255,-24.438/255,0.563,0.563,0.563,1),
	EyeAColor = Color(1,1,1,1,-77.766/255,-39.734/255,-47.672/255,1.234,0.266,0.328,1),
	EyeBColor = Color(1,1,1,1,-77.766/255,-39.734/255,-47.672/255,1.234,0.266,0.328,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_COMMON_COLD] = {
	ProcChance = 0.25,
	ProcTearColor = commonColdColor,
	ProcTearFlags = TearFlags.TEAR_POISON,
	BodyColor = Color(1,1,1,1,22.469/255,69.752/255,-7.584/255,0.708,0.664,0.779,1),
	EyeAColor = Color(1,1,1,1,-18.248/255,13.726/255,-36.991/255,0.664,0.699,0.655,1),
	EyeBColor = Color(1,1,1,1,-18.248/255,13.726/255,-36.991/255,0.664,0.699,0.655,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_PARASITE] = {
	TearColor = parasiteColor, 
	TearFlags = TearFlags.TEAR_SPLIT,
	BodyColor = Color(1,1,1,1,99.5/255,-56.219/255,-56.219/255,0.5,0.781,0.781,1),
	EyeAColor = Color(1,1,1,1,-24.841/255,-30.575/255,-30.575/255,0.788,0.434,0.434,1),
	EyeBColor = Color(1,1,1,1,-24.841/255,-30.575/255,-30.575/255,0.788,0.434,0.434,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_MOMS_CONTACTS] = {
	ProcChance = 0.2,
	ProcTearColor = momsContactColor,
	ProcTearFlags = TearFlags.TEAR_FREEZE,
	TearFallingSpeed = -0.444,
	BodyColor = Color(1,1,1,1,132.221/255,10.699/255,7.442/255,0.372,0.735,0.743,1),
	EyeAColor = Color(1,1,1,1,-13.637/255,0,0,0.850,0/255,0/255,1),
	EyeBColor = Color(1,1,1,1,65.549/255,122.681/255,223.920/255,0.602,0.425,0.106,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_OUIJA_BOARD] = {
	FireCooldown = 18,
	TearColor = spectralColor, 
	TearFlags = TearFlags.TEAR_SPECTRAL,
	BodyColor = Color(1,1,1,166/255,-67.699/255,-67.699/255,-67.699/255,1.265,1.265,1.265,1),
	EyeAColor = Color(1,1,1,166/255,-67.699/255,-67.699/255,-67.699/255,1.265,1.265,1.265,1),
	EyeBColor = Color(1,1,1,166/255,-67.699/255,-67.699/255,-67.699/255,1.265,1.265,1.265,1),
	EarsColor = Color(1,1,1,166/255,0,0,0),
	OutlineColor = Color(1,1,1,166/255,0,0,0)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_LUMP_OF_COAL] = {
	TearColor = lumpOfCoalColor, 
	TearFlags = TearFlags.TEAR_GROW,
	BodyColor = Color(1,1,1,1,-45.920/255,-45.920/255,-45.920/255,0.894,0.894,0.894,1),
	EyeAColor = Color(1,1,1,1,-9.319/255,-9.319/255,-9.319/255,0.425,0.425,0.425,1),
	EyeBColor = Color(1,1,1,1,-9.319/255,-9.319/255,-9.319/255,0.425,0.425,0.425,1)}
	
--Wrath of the Lamb
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_IPECAC] = {
	FireCooldown = 70,
	TearFallingSpeed = -9.691,
	TearFallingAccel = 0.512,
	TearVelocity = 8.0,
	TearColor = ipecacColor,
	TearFlags = TearFlags.TEAR_EXPLOSIVE | TearFlags.TEAR_POISON,
	BodyColor = Color(1,1,1,1,22.469/255,69.752/255,-7.584/255,0.708,0.664,0.779,1),
	EyeAColor = Color(1,1,1,1,22.422/255,21.641/255,20.234/255,0.422,0.641,0.234,1),
	EyeBColor = Color(1,1,1,1,22.422/255,21.641/255,20.234/255,0.422,0.641,0.234,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_TOUGH_LOVE] = {
	ProcChance = 0.1,
	ProcTearVariant = TearVariant.TOOTH,
	ProcTearDamage = 11.2,
	BodyColor = Color(1,1,1,1,132.221/255,10.699/255,7.442/255,0.372,0.735,0.743,1),
	EyeAColor = Color(1,1,1,1,65.549/255,122.681/255,223.920/255,0.602,0.425,0.106,1),
	EyeBColor = Color(1,1,1,1,57.438/255,-54.375/255,117.328/255,0.438,0.625,0.328,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_MULLIGAN] = {
	ProcChance = 1/6,
	ProcTearFlags = TearFlags.TEAR_MULLIGAN,
	BodyColor = Color(1,1,1,1,20.911/255,8.602/255,17.779/255,0.345,0.531,0.628,1),
	EyeAColor = Color(1,1,1,1,-21.212/255,-22.345/255,-55.690/255,0.283,0.460,0.920,1),
	EyeBColor = Color(1,1,1,1,-21.212/255,-22.345/255,-55.690/255,0.283,0.460,0.920,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_MUTANT_SPIDER] = {
	FireCooldown = 55,
	BodyColor = Color(1,1,1,1,-14.359/255,21.625/255,-47.344/255,0.641,0.625,0.656,1),
	EyeAColor = Color(1,1,1,1,65.549/255,122.681/255,223.920/255,0.602,0.425,0.106,1),
	EyeBColor = Color(1,1,1,1,65.549/255,122.681/255,223.920/255,0.602,0.425,0.106,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_SPIRIT_OF_THE_NIGHT] = {
	TearColor = spectralColor, 
	TearFlags = TearFlags.TEAR_SPECTRAL,
	BodyColor = Color(1,1,1,1,-3.646/255,-3.646/255,-3.646/255,0.195,0.195,0.195,1),
	EyeAColor = Color(1,1,1,1,36.106/255,36.106/255,36.106/255,0.858,0.858,0.858,1),
	EyeBColor = Color(1,1,1,1,36.106/255,36.106/255,36.106/255,0.858,0.858,0.858,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_POLYPHEMUS] = {
	TearDamage = 15.0, 
	FireCooldown = 55, 
	TearFlags = TearFlags.TEAR_PERSISTENT,
	BodyColor = Color(1,1,1,1,132.221/255,10.699/255,7.442/255,0.372,0.735,0.743,1),
	EyeAColor = Color(1,1,1,1,-12.422/255,-14.297/255,-22.125/255,0.578,0.703,0.875,1),
	EyeBColor = Color(1,1,1,1,-12.422/255,-14.297/255,-22.125/255,0.578,0.703,0.875,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_SACRED_HEART] = {
	FireCooldown = 31,
	TearColor = sacredHeartColor, 
	TearDamage = 9.05,
	TearFallingSpeed = -0.717,
	TearVelocity = 7.5,
	TearFlags = TearFlags.TEAR_HOMING,
	BodyColor = Color(1,1,1,1,-26.027/255,-58.478/255,-58.478/255,1.035,0.637,0.637,1),
	EyeAColor = Color(1,1,1,1,28.744/255,255/255,255/255,0.887,0,0,1),
	EyeBColor = Color(1,1,1,1,28.744/255,255/255,255/255,0.887,0,0,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_DEAD_DOVE] = {
	TearColor = spectralColor, 
	TearFlags = TearFlags.TEAR_SPECTRAL,
	BodyColor = Color(1,1,1,1,15.796/255,15.796/255,15.796/255,0.938,0.938,0.938,1),
	EyeAColor = Color(1,1,1,1,27.766/255,18.547/255,6.281/255,0.766,0.547,0.281,1),
	EyeBColor = Color(1,1,1,1,27.766/255,18.547/255,6.281/255,0.766,0.547,0.281,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_3_DOLLAR_BILL] = {
	BodyColor = Color(1,1,1,1,63.496/255,25.522/255,98.319/255,0.673,0.637,0.575,1),
	EyeAColor = Color(1,1,1,1,103.805/255,13.345/255,49.451/255,0.593,0.540,0.398,1),
	EyeBColor = Color(1,1,1,1,103.805/255,13.345/255,49.451/255,0.593,0.540,0.398,1)}
	
--Rebirth
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_MOMS_EYESHADOW] = {
	ProcChance = 0.1,
	ProcTearColor = momsEyeshadowColor,
	ProcTearFlags = TearFlags.TEAR_CHARM,
	BodyColor = Color(1,1,1,1,132.221/255,10.699/255,7.442/255,0.372,0.735,0.743,1),
	EyeAColor = Color(1,1,1,1,-52.375/255,23.5/255,219.063/255,0.625,0.5,0.063,1),
	EyeBColor = Color(1,1,1,1,-52.375/255,23.5/255,219.063/255,0.625,0.5,0.063,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_IRON_BAR] = {
	TearDamage = 4.08,
	ProcChance = 0.1,
	ProcTearColor = ironBarColor,
	ProcTearFlags = TearFlags.TEAR_CONFUSION,
	BodyColor = Color(1,1,1,1,-18.451/255,-18.451/255,-18.451/255,0.602,0.602,0.602,1),
	EyeAColor = Color(1,1,1,1,49.549/255,49.549/255,49.549/255,0.602,0.602,0.602,1),
	EyeBColor = Color(1,1,1,1,49.549/255,49.549/255,49.549/255,0.602,0.602,0.602,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_LOST_CONTACT] = {
	TearVariant = TearVariant.LOST_CONTACT, 
	TearFallingSpeed = -0.3,
	TearVelocity = 8.5,
	TearFlags = TearFlags.TEAR_SHIELDED,
	BodyColor = Color(1,1,1,1,132.221/255,10.699/255,7.442/255,0.372,0.735,0.743,1),
	EyeAColor = Color(1,1,1,1,65.549/255,122.681/255,223.920/255,0.602,0.425,0.106,1),
	EyeBColor = Color(1,1,1,1,-33.850/255,-15.796/255,51.903/255,1.133,1.062,0.796,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_RUBBER_CEMENT] = {
	TearColor = rubberCementColor, 
	TearFlags = TearFlags.TEAR_BOUNCE,
	BodyColor = Color(1,1,1,1,132.221/255,10.699/255,7.442/255,0.372,0.735,0.743,1),
	EyeAColor = Color(1,1,1,1,141.422/255,12.891/255,12.891/255,0.422,0.891,0.891,1),
	EyeBColor = Color(1,1,1,1,141.422/255,12.891/255,12.891/255,0.422,0.891,0.891,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_ANTI_GRAVITY] = {
	FireCooldown = 15,
	TearFlags = TearFlags.TEAR_WAIT,
	BodyColor = Color(1,1,1,1,-10.885/255,-23.204/255,-22.796/255,0.513,0.938,1.062,1),
	EyeAColor = Color(1,1,1,1,-62.558/255,-22.558/255,40.416/255,0.743,0.743,0.779,1),
	EyeBColor = Color(1,1,1,1,-62.558/255,-22.558/255,40.416/255,0.743,0.743,0.779,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_CRICKETS_BODY] = {
	FireCooldown = 18,
	TearFallingSpeed = 0.757,
	BodyColor = Color(1,1,1,1,5.548/255,-1.602/255,-2.062/255,0.602,0.469,0.416,1),
	EyeAColor = Color(1,1,1,1,27.438/255,-16.688/255,-4.813/255,0.438,0.313,0.188,1),
	EyeBColor = Color(1,1,1,1,27.438/255,-16.688/255,-4.813/255,0.438,0.313,0.188,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_MOMS_PERFUME] = {
	FireCooldown = 18,
	ProcChance = 0.15,
	ProcTearColor = momsPerfumeColor,
	ProcTearFlags = TearFlags.TEAR_FEAR,
	BodyColor = Color(1,1,1,1,132.221/255,10.699/255,7.442/255,0.372,0.735,0.743,1),
	EyeAColor = Color(1,1,1,1,65.549/255,122.681/255,223.920/255,0.602,0.425,0.106,1),
	EyeBColor = Color(1,1,1,1,102.531/255,102.547/255,98.141/255,0.531,0.547,0.141,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_ABADDON] = {
	TearDamage = 5.86,
	TearVariant = TearVariant.BLOOD,
	ProcChance = 0.15,
	ProcTearColor = abaddonColor,
	ProcTearFlags = TearFlags.TEAR_FEAR,
	BodyColor = Color(1,1,1,1,-3.646/255,-3.646/255,-3.646/255,0.195,0.195,0.195,1),
	EyeAColor = Color(1,1,1,1,-36.25/255,0/255,0/255,0.75,0,0,1),
	EyeBColor = Color(1,1,1,1,-36.25/255,0/255,0/255,0.75,0,0,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_BALL_OF_TAR] = {
	ProcChance = 0.1,
	ProcTearColor = ballOfTarColor,
	ProcTearFlags = TearFlags.TEAR_SLOW | TearFlags.TEAR_GISH,
	BodyColor = Color(1,1,1,1,3.25/255,3.25/255,3.25/255,0.25,0.25,0.25,1),
	EyeAColor = Color(1,1,1,1,30.797/255,39.813/255,-260.438/255,0.797,0.813,1.563,1),
	EyeBColor = Color(1,1,1,1,30.797/255,39.813/255,-260.438/255,0.797,0.813,1.563,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_TINY_PLANET] = {
	TearFallingSpeed = -2.518,
	TearFlags = TearFlags.TEAR_ORBIT | TearFlags.TEAR_SPECTRAL,
	BodyColor = Color(1,1,1,1,-32.195/255,-32.195/255,-32.195/255,0.593,0.593,0.593,1),
	EyeAColor = Color(1,1,1,1,65.549/255,122.681/255,223.920/255,0.602,0.425,0.106,1),
	EyeBColor = Color(1,1,1,1,65.549/255,122.681/255,223.920/255,0.602,0.425,0.106,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_DEATHS_TOUCH] = {
	FireCooldown = 28,
	TearDamage = 5.86,
	TearVariant = TearVariant.SCHYTHE, 
	TearFlags = TearFlags.TEAR_PIERCING,
	BodyColor = Color(1,1,1,1,-46.124/255,-46.124/255,-46.124/255,0.832,0.832,0.832,1),
	EyeAColor = Color(1,1,1,1,3.25/255,3.25/255,3.25/255,0.25,0.25,0.25,1),
	EyeBColor = Color(1,1,1,1,3.25/255,3.25/255,3.25/255,0.25,0.25,0.25,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_20_20] = {
	TearDamage = 2.8,
	BodyColor = Color(1,1,1,1,132.221/255,10.699/255,7.442/255,0.372,0.735,0.743,1),
	EyeAColor = Color(1,1,1,1,65.549/255,122.681/255,223.920/255,0.602,0.425,0.106,1),
	EyeBColor = Color(1,1,1,1,65.549/255,122.681/255,223.920/255,0.602,0.425,0.106,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_FIRE_MIND] = {
	TearColor = fireMindColor, 
	TearFlags = TearFlags.TEAR_BURN,
	BodyColor = Color(1,1,1,1,75.752/255,40.575/255,11.841/255,0.664,0.566,0.212,1),
	EyeAColor = Color(1,1,1,1,80.779/255,25.248/255,-7.053/255,0.628,0.336,0.071,1),
	EyeBColor = Color(1,1,1,1,80.779/255,25.248/255,-7.053/255,0.628,0.336,0.071,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_DARK_MATTER] = {
	TearDamage = 5.19,
	TearColor = darkMatterColor,
	TearFlags = TearFlags.TEAR_DARK_MATTER,
	ProcChance = 1/3,
	ProcTearFlags = TearFlags.TEAR_FEAR,
	BodyColor = Color(1,1,1,1,10.788/255,10.788/255,10.788/255,0.283,0.283,0.283,1),
	EyeAColor = Color(1,1,1,1,1.655/255,1.655/255,1.655/255,0.460,0.460,0.460,1),
	EyeBColor = Color(1,1,1,1,1.655/255,1.655/255,1.655/255,0.460,0.460,0.460,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_PROPTOSIS] = {
	TearDamage = 4.43,
	TearFlags = TearFlags.TEAR_SHRINK,
	BodyColor = Color(1,1,1,1,132.221/255,10.699/255,7.442/255,0.372,0.735,0.743,1),
	EyeAColor = Color(1,1,1,1,139.708/255,-11.177/255,-11.177/255,0.389,0.903,0.903,1),
	EyeBColor = Color(1,1,1,1,139.708/255,-11.177/255,-11.177/255,0.389,0.903,0.903,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_SCORPIO] = {
	TearColor = scorpioColor, 
	TearFlags = TearFlags.TEAR_POISON,
	BodyColor = Color(1,1,1,1,-20.301/255,-20.301/255,-20.301/255,0.735,0.735,0.735,1),
	EyeAColor = Color(1,1,1,1,-81.531/255,-22.938/255,35.655/255,0.708,0.584,0.460,1),
	EyeBColor = Color(1,1,1,1,-81.531/255,-22.938/255,35.655/255,0.708,0.584,0.460,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_SAGITTARIUS] = {
	TearVariant = TearVariant.CUPID_BLUE, 
	TearFlags = TearFlags.TEAR_PIERCING,
	BodyColor = Color(1,1,1,1,-20.301/255,-20.301/255,-20.301/255,0.735,0.735,0.735,1),
	EyeAColor = Color(1,1,1,1,-81.531/255,-61.248/255,35.655/255,0.708,0.664,0.460,1),
	EyeBColor = Color(1,1,1,1,-81.531/255,-61.248/255,35.655/255,0.708,0.664,0.460,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_PISCES] = {
	FireCooldown = 18,
	TearFlags = TearFlags.TEAR_KNOCKBACK,
	Mass = 24.0,
	BodyColor = Color(1,1,1,1,-20.301/255,-20.301/255,-20.301/255,0.735,0.735,0.735,1),
	EyeAColor = Color(1,1,1,1,35.655/255,-81.531/255,-22.938/255,0.460,0.708,0.584,1),
	EyeBColor = Color(1,1,1,1,35.655/255,-81.531/255,-22.938/255,0.460,0.708,0.584,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_EVES_MASCARA] = {
	TearDamage = 7.0, 
	FireCooldown = 34, 
	TearVelocity = 6.0, 
	TearFallingSpeed = -1.617,
	TearColor = evesMascaraColor,
	BodyColor = Color(1,1,1,1,132.221/255,10.699/255,7.442/255,0.372,0.735,0.743,1),
	EyeAColor = Color(1,1,1,1,-3.646/255,-3.646/255,-3.646/255,0.195,0.195,0.195,1),
	EyeBColor = Color(1,1,1,1,-3.646/255,-3.646/255,-3.646/255,0.195,0.195,0.195,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_STRANGE_ATTRACTOR] = {
	TearVariant = TearVariant.METALLIC, 
	TearFlags = TearFlags.TEAR_ATTRACTOR,
	BodyColor = Color(1,1,1,1,3.25/255,3.25/255,3.25/255,0.25,0.25,0.25,1),
	EyeAColor = Color(1,1,1,1,39.5/255,39.5/255,39.5/255,0.5,0.5,0.5,1),
	EyeBColor = Color(1,1,1,1,39.5/255,39.5/255,39.5/255,0.5,0.5,0.5,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_MYSTERIOUS_LIQUID] = {
	TearColor = mysteriousLiquidColor, 
	TearFlags = TearFlags.TEAR_MYSTERIOUS_LIQUID_CREEP,
	BodyColor = Color(1,1,1,1,-2.451/255,-2.451/255,-2.451/255,0.602,0.602,0.602,1),
	EyeAColor = Color(1,1,1,1,23.047/255,79.531/255,15.063/255,0.047,0.531,0.063,1),
	EyeBColor = Color(1,1,1,1,23.047/255,79.531/255,15.063/255,0.047,0.531,0.063,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_SOY_MILK] = {
	TearDamage = 0.7, 
	FireCooldown = 2,
	TearColor = soyMilkColor,
	Mass = 1.6,
	BodyColor = Color(1,1,1,1,132.221/255,10.699/255,7.442/255,0.372,0.735,0.743,1),
	EyeAColor = Color(1,1,1,1,255/255,183.188/255,95.375/255,0,0.188,0.375,1),
	EyeBColor = Color(1,1,1,1,255/255,183.188/255,95.375/255,0,0.188,0.375,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_GODHEAD] = {
	FireCooldown = 28,
	TearDamage = 4.43,
	TearFallingSpeed = -0.977,
	TearVelocity = 7.0,
	TearFlags = TearFlags.TEAR_GLOW | TearFlags.TEAR_HOMING,
	BodyColor = Color(1,1,1,1,-15.938/255,-15.938/255,-15.938/255,1.063,1.063,1.063,1),
	EyeAColor = Color(1,1,1,1,255/255,207.188/255,-402.891,0,0.188,2.109,1),
	EyeBColor = Color(1,1,1,1,-24.398/255,-3.584/255,13.336/255,0.531,0.779,0.885,1),
	EarsColor = Color(1,1,1,1,-195.358/255,-262.769/255,-262.769/255,2.700,2.025,2.025,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_DEAD_ONION] = {
	TearColor = deadOnionColor,
	TearFallingSpeed = -0.584,
	TearVelocity = 6.0,
	TearFlags = TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_PIERCING,
	BodyColor = Color(1,1,1,1,28.469/255,16.344/255,17.313/255,0.469,0.344,0.313,1),
	EyeAColor = Color(1,1,1,1,5.655/255,25.637/255,28/255,0.460,0.150,0,1),
	EyeBColor = Color(1,1,1,1,5.655/255,25.637/255,28/255,0.460,0.150,0,1)}
	
--Afterbirth
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_THE_WIZ] = {
	TearFlags = TearFlags.TEAR_SPECTRAL,
	BodyColor = Color(1,1,1,1,20.310/255,20.310/255,20.310/255,0.920,0.920,0.920,1),
	EyeAColor = Color(1,1,1,1,65.549/255,122.681/255,223.920/255,0.602,0.425,0.106,1),
	EyeBColor = Color(1,1,1,1,65.549/255,122.681/255,223.920/255,0.602,0.425,0.106,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_8_INCH_NAILS] = {
	TearVariant = TearVariant.NAIL, 
	TearDamage = 5.86,
	TearFlags = TearFlags.TEAR_KNOCKBACK,
	KnockbackMultiplier = 2.0,
	Mass = 24.0,
	BodyColor = Color(1,1,1,1,132.221/255,10.699/255,7.442/255,0.372,0.735,0.743,1),
	EyeAColor = Color(1,1,1,1,-38.558/255,-38.558/255,-38.558/255,0.743,0.743,0.743,1),
	EyeBColor = Color(1,1,1,1,-38.558/255,-38.558/255,-38.558/255,0.743,0.743,0.743,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_CONTINUUM] = {
	TearFallingSpeed = -1.066,
	TearFlags = TearFlags.TEAR_CONTINUUM | TearFlags.TEAR_SPECTRAL,
	BodyColor = Color(1,1,1,1,36.832/255,3.708/255,67.912/255,0.558,0.389,0.451,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_HOLY_LIGHT] = {
	ProcChance = 0.1,
	ProcTearFlags = TearFlags.TEAR_LIGHT_FROM_HEAVEN,
	BodyColor = Color(1,1,1,1,0,0,0,255/255,255/255,255/255,1),
	EyeAColor = Color(1,1,1,1,0,0,0,0/255,255/255,255/255,1),
	EyeBColor = Color(1,1,1,1,0,0,0,0/255,255/255,255/255,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_PUPULA_DUPLEX] = {
	TearVariant = TearVariant.PUPULA, 
	TearFlags = TearFlags.TEAR_SPECTRAL,
	BodyColor = Color(1,1,1,1,132.221/255,10.699/255,7.442/255,0.372,0.735,0.743,1),
	EyeAColor = Color(1,1,1,1,65.549/255,122.681/255,223.920/255,0.602,0.425,0.106,1),
	EyeBColor = Color(1,1,1,1,65.549/255,122.681/255,223.920/255,0.602,0.425,0.106,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_SERPENTS_KISS] = {
	ProcChance = 0.15,
	ProcTearColor = serpentsKissColor,
	ProcTearFlags = TearFlags.TEAR_POISON,
	BodyColor = Color(1,1,1,1,6.717/255,-10.602/255,-9.265/255,0.044,0.469,0.354,1),
	EyeAColor = Color(1,1,1,1,-139.566/255,64.858/255,-146.080/255,1.088,0.522,1.106,1),
	EyeBColor = Color(1,1,1,1,-139.566/255,64.858/255,-146.080/255,1.088,0.522,1.106,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_GODS_FLESH] = {
	ProcChance = 0.1,
	ProcTearVariant = TearVariant.GODS_FLESH,
	ProcTearFlags = TearFlags.TEAR_GODS_FLESH,
	BodyColor = Color(1,1,1,1,139.912/255,35.956/255,35.956/255,0.451,0.726,0.726,1),
	EyeAColor = Color(1,1,1,1,-27.805/255,-27.805/255,139.912,0.407,0.407,0.451,1),
	EyeBColor = Color(1,1,1,1,-27.805/255,-27.805/255,139.912,0.407,0.407,0.451,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_EXPLOSIVO] = {
	ProcChance = 0.25,
	ProcTearVariant = TearVariant.EXPLOSIVO,
	ProcTearFlags = TearFlags.TEAR_STICKY,
	BodyColor = Color(1,1,1,1,3.25/255,3.25/255,3.25/255,0.25,0.25,0.25,1),
	EyeAColor = Color(1,1,1,1,80.779/255,25.248/255,-7.053/255,0.628,0.336,0.071,1),
	EyeBColor = Color(1,1,1,1,80.779/255,25.248/255,-7.053/255,0.628,0.336,0.071,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_CROWN_OF_LIGHT] = {
	BodyColor = Color(1,1,1,1,-25.221/255,109.398/255,214.381/255,0.628,0.469,0.159,1),
	EyeAColor = Color(1,1,1,1,0,0,0,0/255,255/255,255/255,1),
	EyeBColor = Color(1,1,1,1,0,0,0,0/255,255/255,255/255,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_FRUIT_CAKE] = {
	BodyColor = Color(1,1,1,1,-25.425/255,-28.292/255,0.230/255,0.566,0.389,0.027,1),
	EyeAColor = Color(1,1,1,1,-36.25/255,0/255,0/255,0.75,0,0,1),
	EyeBColor = Color(1,1,1,1,0/255,-64.375/255,0/255,0,0.625,0,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_HEAD_OF_THE_KEEPER] = {
	TearVariant = TearVariant.COIN,
	TearFlags = TearFlags.TEAR_GREED_COIN,
	BodyColor = Color(1,1,1,1,-22.558/255,-22.558/255,-22.558/255,0.743,0.743,0.743,1),
	EyeAColor = Color(1,1,1,1,8.416/255,-64.717/255,7/255,0.779,0.956,0,1),
	EyeBColor = Color(1,1,1,1,8.416/255,-64.717/255,7/255,0.779,0.956,0,1)}
	
--Afterbirth+
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_APPLE] = {
	FireCooldown = 19,
	ProcChance = 1/15,
	ProcTearVariant = TearVariant.RAZOR,
	ProcTearDamage = 14.0,
	BodyColor = Color(1,1,1,1,-37.637/255,0/255,0/255,0.850,0,0,1),
	EyeAColor = Color(1,1,1,1,0/255,-0.5/255,0/255,0,0.5,0,1),
	EyeBColor = Color(1,1,1,1,0/255,-0.5/255,0/255,0,0.5,0,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_LEAD_PENCIL] = {
	BodyColor = Color(1,1,1,1,58.673/255,37.602/255,7.381/255,0.770,0.531,0.159,1),
	EyeAColor = Color(1,1,1,1,151.195/255,-61.743/255,-61.743/255,0.407,0.991,0.991,1),
	EyeBColor = Color(1,1,1,1,151.195/255,-61.743/255,-61.743/255,0.407,0.991,0.991,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_COMPOUND_FRACTURE] = {
	TearFallingSpeed = -0.446,
	TearVariant = TearVariant.BONE,
	TearFlags = TearFlags.TEAR_BONE,
	BodyColor = Color(1,1,1,1,-51.903/255,-51.903/255,-51.903/255,1.204,1.204,1.204,1),
	EyeAColor = Color(1,1,1,1,-37.637/255,0/255,0/255,0.850,0,0,1),
	EyeBColor = Color(1,1,1,1,-37.637/255,0/255,0/255,0.850,0,0,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_SINUS_INFECTION] = {
	ProcChance = 0.2,
	ProcTearVariant = TearVariant.BOOGER,
	ProcTearFlags = TearFlags.TEAR_BOOGER,
	BodyColor = Color(1,1,1,1,132.221/255,10.699/255,7.442/255,0.372,0.735,0.743,1),
	EyeAColor = Color(1,1,1,1,-13.319/255,32.779/255,-13.319/255,0.425,0.628,0.425,1),
	EyeBColor = Color(1,1,1,1,-13.319/255,32.779/255,-13.319/255,0.425,0.628,0.425,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_GLAUCOMA] = {
	ProcChance = 0.05,
	ProcTearVariant = TearVariant.GLAUCOMA,
	ProcTearFlags = TearFlags.TEAR_PERMANENT_CONFUSION,
	BodyColor = Color(1,1,1,1,132.221/255,10.699/255,7.442/255,0.372,0.735,0.743,1),
	EyeAColor = Color(1,1,1,1,9.336/255,9.336/255,9.336/255,0.885,0.885,0.885,1),
	EyeBColor = Color(1,1,1,1,9.336/255,9.336/255,9.336/255,0.885,0.885,0.885,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_PARASITOID] = {
	ProcChance = 1/7,
	ProcTearVariant = TearVariant.EGG,
	ProcTearFlags = TearFlags.TEAR_EGG,
	BodyColor = Color(1,1,1,1,15.796/255,15.796/255,15.796/255,0.938,0.938,0.938,1),
	EyeAColor = Color(1,1,1,1,20.911/255,8.602/255,17.779/255,0.345,0.531,0.628,1),
	EyeBColor = Color(1,1,1,1,20.911/255,8.602/255,17.779/255,0.345,0.531,0.628,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_EYE_OF_BELIAL] = {
	TearFallingSpeed = -0.446,
	TearVariant = TearVariant.BLOOD,
	TearFlags = TearFlags.TEAR_BELIAL | TearFlags.TEAR_PIERCING,
	BodyColor = Color(1,1,1,1,-61.637/255,0/255,0/255,0.850,0,0,1),
	EyeAColor = Color(1,1,1,1,-91.469/255,-21.646/255,-27.186/255,1.292,0.195,0.248,1),
	EyeBColor = Color(1,1,1,1,-91.469/255,-21.646/255,-27.186/255,1.292,0.195,0.248,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_SULFURIC_ACID] = {
	TearDamage = 4.08,
	ProcChance = 0.25,
	ProcTearColor = sulfuricAcidColor,
	ProcTearFlags = TearFlags.TEAR_ACID,
	BodyColor = Color(1,1,1,1,148.938/255,126.372/255,-169.646/255,0.416,0.504,1.195,1),
	EyeAColor = Color(1,1,1,1,-25.188/255,64.547/255,25/255,0.813,0.547,0,1),
	EyeBColor = Color(1,1,1,1,-25.188/255,64.547/255,25/255,0.813,0.547,0,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_JACOBS_LADDER] = {
	TearFlags = TearFlags.TEAR_JACOBS,
	BodyColor = Color(1,1,1,1,-38.558/255,-38.558/255,-38.558/255,0.743,0.743,0.743,1),
	EyeAColor = Color(1,1,1,1,-133.142/255,74.469/255,191.814/255,1.522,0.708,0.248,1),
	EyeBColor = Color(1,1,1,1,-133.142/255,74.469/255,191.814/255,1.522,0.708,0.248,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_EUTHANASIA] = {
	ProcChance = 1/30,
	ProcTearVariant = TearVariant.NEEDLE,
	ProcTearFlags = TearFlags.TEAR_NEEDLE,
	BodyColor = Color(1,1,1,1,-71.027/255,-71.027/255,-71.027/255,1.035,1.035,1.035,1),
	EyeAColor = Color(1,1,1,1,-3.646/255,-3.646/255,-3.646/255,0.195,0.195,0.195,1),
	EyeBColor = Color(1,1,1,1,-3.646/255,-3.646/255,-3.646/255,0.195,0.195,0.195,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_LITTLE_HORN] = {
	ProcChance = 0.05,
	ProcTearColor = transparentColor,
	ProcTearFlags = TearFlags.TEAR_HORN,
	BodyColor = Color(1,1,1,1,-3.646/255,-3.646/255,-3.646/255,0.195,0.195,0.195,1),
	EyeAColor = Color(1,1,1,1,-77.766/255,-39.734/255,-47.672/255,1.234,0.266,0.328,1),
	EyeBColor = Color(1,1,1,1,-77.766/255,-39.734/255,-47.672/255,1.234,0.266,0.328,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_BACKSTABBER] = {
	TearFlags = TearFlags.TEAR_BACKSTAB,
	BodyColor = Color(1,1,1,1,-8.522/255,-34.239/255,-22.726/255,0.363,0.319,0.301,1),
	EyeAColor = Color(1,1,1,1,45.735/255,7.991/255,12.584/255,0.354,0.345,0.327,1),
	EyeBColor = Color(1,1,1,1,45.735/255,7.991/255,12.584/255,0.354,0.345,0.327,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_TECHNOLOGY_ZERO] = {
	TearFlags = TearFlags.TEAR_LASER,
	BodyColor = Color(1,1,1,1,-18.451/255,-18.451/255,-18.451/255,0.602,0.602,0.602,1),
	EyeAColor = Color(1,1,1,1,65.549/255,122.681/255,223.920/255,0.602,0.425,0.106,1),
	EyeBColor = Color(1,1,1,1,65.549/255,122.681/255,223.920/255,0.602,0.425,0.106,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_POP] = {
	TearVariant = TearVariant.EYE,
	TearFlags = TearFlags.TEAR_POP,
	BodyColor = Color(1,1,1,1,-13.637/255,0,0,0.850,0/255,0/255,1),
	EyeAColor = Color(1,1,1,1,255/255,30.619/255,20.593/255,0,0.841,0.876,1),
	EyeBColor = Color(1,1,1,1,255/255,30.619/255,20.593/255,0,0.841,0.876,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_HAEMOLACRIA] = {
	FireCooldown = 68,
	TearDamage = 7.79,
	TearFallingSpeed = -10.981,
	TearFallingAccel = 0.8,
	TearVariant = TearVariant.BALLOON,
	TearFlags = TearFlags.TEAR_BURSTSPLIT,
	BodyColor = Color(1,1,1,1,132.221/255,10.699/255,7.442/255,0.372,0.735,0.743,1),
	EyeAColor = Color(1,1,1,1,58.496/255,0/255,0/255,0.673,0,0,1),
	EyeBColor = Color(1,1,1,1,58.496/255,0/255,0/255,0.673,0,0,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_LACHRYPHAGY] = {
	TearVariant = TearVariant.HUNGRY,
	TearFlags = TearFlags.TEAR_ABSORB,
	BodyColor = Color(1,1,1,1,-26.172/255,63.563/255,240.047/255,0.828,0.563,0.047,1),
	EyeAColor = Color(1,1,1,1,65.549/255,122.681/255,223.920/255,0.602,0.425,0.106,1),
	EyeBColor = Color(1,1,1,1,65.549/255,122.681/255,223.920/255,0.602,0.425,0.106,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_TRISAGION] = {
	TearFlags = TearFlags.TEAR_LASERSHOT,
	BodyColor = Color(1,1,1,1,11.283/255,85.752/255,214.381/255,0.956,0.664,0.159,1),
	EyeAColor = Color(1,1,1,1,11.283/255,85.752/255,214.381/255,0.956,0.664,0.159,1),
	EyeBColor = Color(1,1,1,1,11.283/255,85.752/255,214.381/255,0.956,0.664,0.159,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_FLAT_STONE] = {
	TearFallingSpeed = -14.816,
	TearFallingAccel = 3.0,
	TearFlags = TearFlags.TEAR_HYDROBOUNCE,
	BodyColor = Color(1,1,1,1,-1.858/255,-2.142/255,-1.912/255,0.478,0.522,0.548,1),
	EyeAColor = Color(1,1,1,1,5.832/255,50.212/255,81.239/255,0.558,0.717,0.681,1),
	EyeBColor = Color(1,1,1,1,5.832/255,50.212/255,81.239/255,0.558,0.717,0.681,1)}
	
--Repentance
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_MUCORMYCOSIS] = {
	ProcChance = 0.25,
	ProcTearVariant = TearVariant.SPORE,
	ProcTearFlags = TearFlags.TEAR_SPORE,
	BodyColor = Color(1,1,1,1,-2.292/255,-1.062/255,-2.708/255,0.389,0.416,0.611,1),
	EyeAColor = Color(1,1,1,1,6.912/255,3.504/255,8.575/255,0.451,0.327,0.566,1),
	EyeBColor = Color(1,1,1,1,58.354/255,47.354/255,71.761/255,0.195,0.195,0.319,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_ALMOND_MILK] = {
	TearDamage = 1.05,
	FireCooldown = 3,
	Mass = 2.4,
	TearColor = almondMilkColor,
	BodyColor = Color(1,1,1,1,-21.018/255,30.442/255,51.903/255,0.690,0.743,0.796,1),
	EyeAColor = Color(1,1,1,1,5.442/255,-47.478/255,-24.292/255,0.743,0.637,0.389,1),
	EyeBColor = Color(1,1,1,1,5.442/255,-47.478/255,-24.292/255,0.743,0.637,0.389,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_EYE_SORE] = {
	BodyColor = Color(1,1,1,1,132.221/255,10.699/255,7.442/255,0.372,0.735,0.743,1),
	EyeAColor = Color(1,1,1,1,255/255,-151.195/255,-151.195/255,0,1.593,1.593,1),
	EyeBColor = Color(1,1,1,1,255/255,-151.195/255,-151.195/255,0,1.593,1.593,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE] = {
	BodyColor = Color(1,1,1,1,-11.814/255,-18.814/255,-33.301/255,0.752,0.752,0.735,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_EYE_OF_THE_OCCULT] = {
	TearDamage = 5.19, 
	TearHeight = -31.75, 
	TearFallingSpeed = -0.467, 
	TearVelocity = 8.4, 
	TearColor = eyeOfTheOccultColor,
	TearFlags = TearFlags.TEAR_OCCULT,
	BodyColor = Color(1,1,1,1,-11.547/255,-31.547/255,-6.578/255,0.453,0.453,0.422,1),
	EyeAColor = Color(1,1,1,1,182.788/255,37.442/255,-19.584/255,0.283,0.743,0.779,1),
	EyeBColor = Color(1,1,1,1,182.788/255,37.442/255,-19.584/255,0.283,0.743,0.779,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_TERRA] = {
	TearDamage = 5.19, 
	Mass = 24.0, 
	TearVariant = TearVariant.ROCK, 
	TearFlags = TearFlags.TEAR_KNOCKBACK | TearFlags.TEAR_ROCK,
	BodyColor = Color(1,1,1,1,4.009/255,-9.248/255,-9.248/255,0.655,0.664,0.664,1),
	EyeAColor = Color(1,1,1,1,-36.142/255,-32.345/255,-32.345/255,0.522,0.460,0.460,1),
	EyeBColor = Color(1,1,1,1,-36.142/255,-32.345/255,-32.345/255,0.522,0.460,0.460,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_URANUS] = {
	TearVariant = TearVariant.ICE,
	TearFlags = TearFlags.TEAR_ICE,
	BodyColor = Color(1,1,1,1,-78.982/255,-27.080/255,63.186/255,1.310,1.106,0.752,1),
	EyeAColor = Color(1,1,1,1,-78.982/255,-27.080/255,63.186/255,1.310,1.106,0.752,1),
	EyeBColor = Color(1,1,1,1,-78.982/255,-27.080/255,63.186/255,1.310,1.106,0.752,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_OCULAR_RIFT] = {
	ProcChance = 0.05,
	ProcTearColor = transparentColor,
	ProcTearFlags = TearFlags.TEAR_RIFT,
	BodyColor = Color(1,1,1,1,132.221/255,10.699/255,7.442/255,0.372,0.735,0.743,1),
	EyeAColor = Color(1,1,1,1,65.549/255,122.681/255,223.920/255,0.602,0.425,0.106,1),
	EyeBColor = Color(1,1,1,1,80.779/255,25.248/255,-7.053/255,0.628,0.336,0.071,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_LODESTONE] = {
	ProcChance = 1/6,
	ProcTearColor = lodestoneColor,
	ProcTearFlags = TearFlags.TEAR_MAGNETIZE,
	BodyColor = Color(1,1,1,1,-29.496/255,-29.496/255,-29.496/255,0.327,0.327,0.327,1),
	EyeAColor = Color(1,1,1,1,-33.850/255,-33.850/255,-33.850/255,1.133,1.133,1.133,1),
	EyeBColor = Color(1,1,1,1,-33.850/255,-33.850/255,-33.850/255,1.133,1.133,1.133,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_ROTTEN_TOMATO] = {
	ProcChance = 1/6,
	ProcTearColor = rottenTomatoColor,
	ProcTearFlags = TearFlags.TEAR_BAIT,
	BodyColor = Color(1,1,1,1,28.726/255,-10.442/255,-10.442/255,0.699,0.257,0.257,1),
	EyeAColor = Color(1,1,1,1,-36.5/255,-48.359/255,-32.578/255,0.5,0.641,0.422,1),
	EyeBColor = Color(1,1,1,1,-36.5/255,-48.359/255,-32.578/255,0.5,0.641,0.422,1)}
mod.SewingManualWhitelist[CollectibleType.COLLECTIBLE_KNOCKOUT_DROPS] = {
	ProcChance = 0.1,
	ProcTearVariant = TearVariant.FIST,
	ProcTearFlags = TearFlags.TEAR_PUNCH,
	BodyColor = Color(1,1,1,1,-48.274/255,-48.274/255,-48.274/255,0.699,0.699,0.699,1),
	EyeAColor = Color(1,1,1,1,4.779/255,-1.133/255,-1.442/255,0.628,0.177,0.257,1),
	EyeBColor = Color(1,1,1,1,4.779/255,-1.133/255,-1.442/255,0.628,0.177,0.257,1)}

local function playerHasSewingManual(player)
	return player:HasTrinket(mod.ITEM.TRINKET.SEWING_MANUAL_3_USE) or 
	       player:HasTrinket(mod.ITEM.TRINKET.SEWING_MANUAL_2_USE) or
	       player:HasTrinket(mod.ITEM.TRINKET.SEWING_MANUAL_1_USE)
end

local function getSewingManualMultiplier(player)
	return player:GetTrinketMultiplier(mod.ITEM.TRINKET.SEWING_MANUAL_3_USE) + 
	       player:GetTrinketMultiplier(mod.ITEM.TRINKET.SEWING_MANUAL_2_USE) +
	       player:GetTrinketMultiplier(mod.ITEM.TRINKET.SEWING_MANUAL_1_USE)
end

local function isSewingManualTrinket(id)
	local id = id & 0x7fff
	return id == mod.ITEM.TRINKET.SEWING_MANUAL_3_USE or 
	       id == mod.ITEM.TRINKET.SEWING_MANUAL_2_USE or
	       id == mod.ITEM.TRINKET.SEWING_MANUAL_1_USE
end

local function downgradeSewingManualTrinkets(player)
	local t0 = player:GetTrinket(0)
	local t1 = player:GetTrinket(1)
	
	local t0IsSewingManual = isSewingManualTrinket(t0)
	local t1IsSewingManual = isSewingManualTrinket(t1)
	
	local removedT0 = false
	local removedT1 = false
	
	if t0IsSewingManual then
		removedT0 = player:TryRemoveTrinket(t0)
	end
	if t1IsSewingManual then
		removedT1 = player:TryRemoveTrinket(t1)
	end
	
	if removedT0 then
		if t0 == mod.ITEM.TRINKET.SEWING_MANUAL_3_USE then
			player:AddTrinket(mod.ITEM.TRINKET.SEWING_MANUAL_2_USE, false)
		elseif t0 == mod.ITEM.TRINKET.SEWING_MANUAL_2_USE then
			player:AddTrinket(mod.ITEM.TRINKET.SEWING_MANUAL_1_USE, false)
		elseif t0 == mod.ITEM.TRINKET.SEWING_MANUAL_3_USE | 0x8000 then
			player:AddTrinket(mod.ITEM.TRINKET.SEWING_MANUAL_2_USE | 0x8000, false)
		elseif t0 == mod.ITEM.TRINKET.SEWING_MANUAL_2_USE | 0x8000 then
			player:AddTrinket(mod.ITEM.TRINKET.SEWING_MANUAL_1_USE | 0x8000, false)
		end
	end
	if removedT1 then
		if t1 == mod.ITEM.TRINKET.SEWING_MANUAL_3_USE then
			player:AddTrinket(mod.ITEM.TRINKET.SEWING_MANUAL_2_USE, false)
		elseif t1 == mod.ITEM.TRINKET.SEWING_MANUAL_2_USE then
			player:AddTrinket(mod.ITEM.TRINKET.SEWING_MANUAL_1_USE, false)
		elseif t1 == mod.ITEM.TRINKET.SEWING_MANUAL_3_USE | 0x8000 then
			player:AddTrinket(mod.ITEM.TRINKET.SEWING_MANUAL_2_USE | 0x8000, false)
		elseif t1 == mod.ITEM.TRINKET.SEWING_MANUAL_2_USE | 0x8000 then
			player:AddTrinket(mod.ITEM.TRINKET.SEWING_MANUAL_1_USE | 0x8000, false)
		end
	end
	
	if t0IsSewingManual and t0 & 0x7fff ~= mod.ITEM.TRINKET.SEWING_MANUAL_1_USE and not t1IsSewingManual and t1 > 0 then
		if player:TryRemoveTrinket(t1) then
			player:AddTrinket(t1, false)
		end
	end
	
	while player:GetSmeltedTrinkets()[mod.ITEM.TRINKET.SEWING_MANUAL_1_USE].trinketAmount > 0 do
		player:TryRemoveSmeltedTrinket(mod.ITEM.TRINKET.SEWING_MANUAL_1_USE)
	end
	while player:GetSmeltedTrinkets()[mod.ITEM.TRINKET.SEWING_MANUAL_1_USE].goldenTrinketAmount > 0 do
		player:TryRemoveSmeltedTrinket(mod.ITEM.TRINKET.SEWING_MANUAL_1_USE | 0x8000)
	end
	while player:GetSmeltedTrinkets()[mod.ITEM.TRINKET.SEWING_MANUAL_2_USE].trinketAmount > 0 do
		player:TryRemoveSmeltedTrinket(mod.ITEM.TRINKET.SEWING_MANUAL_2_USE)
		player:AddSmeltedTrinket(mod.ITEM.TRINKET.SEWING_MANUAL_1_USE, false)
	end
	while player:GetSmeltedTrinkets()[mod.ITEM.TRINKET.SEWING_MANUAL_2_USE].goldenTrinketAmount > 0 do
		player:TryRemoveSmeltedTrinket(mod.ITEM.TRINKET.SEWING_MANUAL_2_USE | 0x8000)
		player:AddSmeltedTrinket(mod.ITEM.TRINKET.SEWING_MANUAL_1_USE | 0x8000, false)
	end
	while player:GetSmeltedTrinkets()[mod.ITEM.TRINKET.SEWING_MANUAL_3_USE].trinketAmount > 0 do
		player:TryRemoveSmeltedTrinket(mod.ITEM.TRINKET.SEWING_MANUAL_3_USE)
		player:AddSmeltedTrinket(mod.ITEM.TRINKET.SEWING_MANUAL_2_USE, false)
	end
	while player:GetSmeltedTrinkets()[mod.ITEM.TRINKET.SEWING_MANUAL_3_USE].goldenTrinketAmount > 0 do
		player:TryRemoveSmeltedTrinket(mod.ITEM.TRINKET.SEWING_MANUAL_3_USE | 0x8000)
		player:AddSmeltedTrinket(mod.ITEM.TRINKET.SEWING_MANUAL_2_USE | 0x8000, false)
	end
end

mod:AddPriorityCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, CallbackPriority.LATE, function(_, collectible, charge, firstTime, slot, varData, player)
	if playerHasSewingManual(player) and mod.SewingManualWhitelist[collectible] then
		local data = mod:GetEntityData(player).ffsavedata
		if data then
			player:RemoveCollectible(collectible)
			
			data.FFSewingManualFamiliars = data.FFSewingManualFamiliars or {}
			data.FFSewingManualFamiliars[tostring(collectible)] = (data.FFSewingManualFamiliars[tostring(collectible)] or 0) + getSewingManualMultiplier(player)
			
			downgradeSewingManualTrinkets(player)
			
			player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS)
			player:EvaluateItems()
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, collectible, rng, player, useflags, slot, vardata)
	local basedata = mod:GetEntityData(player)
	local data = basedata.ffsavedata
	
	data.FFSewingManualFamiliars = data.FFSewingManualFamiliars or {}
	basedata.FFBoxOfFriendsSewingManualFamiliars = basedata.FFBoxOfFriendsSewingManualFamiliars or {}
	
	local callCache = false
	for collectible,_ in pairs(mod.SewingManualWhitelist) do
		if (data.FFSewingManualFamiliars[tostring(collectible)] or 0) > 0 then
			basedata.FFBoxOfFriendsSewingManualFamiliars[collectible] = (basedata.FFBoxOfFriendsSewingManualFamiliars[collectible] or 0) + 
			                                                            (data.FFSewingManualFamiliars[tostring(collectible)] or 0)
			player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS)
			callCache = true
		end
	end
	if callCache then
		player:EvaluateItems()
	end
end, CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	for i = 0, game:GetNumPlayers() - 1 do
		local player = game:GetPlayer(i)
		local basedata = mod:GetEntityData(player)
		basedata.FFBoxOfFriendsSewingManualFamiliars = basedata.FFBoxOfFriendsSewingManualFamiliars or {}
		basedata.FFSewingManualDisableCrown = nil
		
		local callCache = false
		if #(basedata.FFBoxOfFriendsSewingManualFamiliars) > 0 then
			player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS)
			callCache = true
		end
		
		basedata.FFBoxOfFriendsSewingManualFamiliars = {}
		if callCache then
			player:EvaluateItems()
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
	local itempool = game:GetItemPool()
	itempool:RemoveTrinket(mod.ITEM.TRINKET.SEWING_MANUAL_2_USE)
	itempool:RemoveTrinket(mod.ITEM.TRINKET.SEWING_MANUAL_1_USE)
end)

function mod:sewingManualFamiliarCache(player)
	local level = game:GetLevel()
	local inMinesEscape = level:HasAbandonedMineshaft() and level:GetDimension() == Dimension.MINESHAFT
	
	local basedata = mod:GetEntityData(player)
	local data = basedata.ffsavedata
	
	data.FFSewingManualFamiliars = data.FFSewingManualFamiliars or {}
	basedata.FFBoxOfFriendsSewingManualFamiliars = basedata.FFBoxOfFriendsSewingManualFamiliars or {}
	
	for collectible,_ in pairs(mod.SewingManualWhitelist) do
		local dollNum = (data.FFSewingManualFamiliars[tostring(collectible)] or 0) + (basedata.FFBoxOfFriendsSewingManualFamiliars[collectible] or 0)
		if inMinesEscape then
			dollNum = 0
		end
		player:CheckFamiliar(FiendFolio.ITEM.FAMILIAR.SEWING_MANUAL_DOLL,
		                     dollNum,
		                     player:GetTrinketRNG(mod.ITEM.TRINKET.SEWING_MANUAL_3_USE),
		                     nil,
		                     collectible)
	end
end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, familiar)
	local sprite = familiar:GetSprite()
	local familiarConfig = mod.SewingManualWhitelist[familiar.SubType] or {}
	
	local bodyLayer = sprite:GetLayer("body")
	if bodyLayer then
		bodyLayer:SetColor(familiarConfig.BodyColor or Color())
	end
	
	local eyeALayer = sprite:GetLayer("eyeA")
	if eyeALayer then
		eyeALayer:SetColor(familiarConfig.EyeAColor or Color())
	end
	
	local eyeBLayer = sprite:GetLayer("eyeB")
	if eyeBLayer then
		eyeBLayer:SetColor(familiarConfig.EyeBColor or Color())
	end
	
	local earsLayer = sprite:GetLayer("ears")
	if earsLayer then
		earsLayer:SetColor(familiarConfig.EarsColor or Color())
	end
	
	local outlineLayer = sprite:GetLayer("outline")
	if outlineLayer then
		outlineLayer:SetColor(familiarConfig.OutlineColor or Color())
	end
end, FiendFolio.ITEM.FAMILIAR.SEWING_MANUAL_DOLL)

local ThreeDollarBillEffects = {
	CollectibleType.COLLECTIBLE_8_INCH_NAILS,
	CollectibleType.COLLECTIBLE_20_20,
	CollectibleType.COLLECTIBLE_APPLE,
	CollectibleType.COLLECTIBLE_BALL_OF_TAR,
	CollectibleType.COLLECTIBLE_CONTINUUM,
	CollectibleType.COLLECTIBLE_CRICKETS_BODY,
	CollectibleType.COLLECTIBLE_DARK_MATTER,
	--CollectibleType.COLLECTIBLE_DEAD_EYE,
	CollectibleType.COLLECTIBLE_DEATHS_TOUCH,
	CollectibleType.COLLECTIBLE_EUTHANASIA,
	CollectibleType.COLLECTIBLE_EXPLOSIVO,
	CollectibleType.COLLECTIBLE_EYE_OF_BELIAL,
	CollectibleType.COLLECTIBLE_FIRE_MIND,
	CollectibleType.COLLECTIBLE_HOLY_LIGHT,
	CollectibleType.COLLECTIBLE_IRON_BAR,
	CollectibleType.COLLECTIBLE_LITTLE_HORN,
	CollectibleType.COLLECTIBLE_LOST_CONTACT,
	CollectibleType.COLLECTIBLE_MOMS_CONTACTS,
	CollectibleType.COLLECTIBLE_MOMS_EYESHADOW,
	CollectibleType.COLLECTIBLE_MOMS_PERFUME,
	CollectibleType.COLLECTIBLE_MUTANT_SPIDER,
	CollectibleType.COLLECTIBLE_MY_REFLECTION,
	CollectibleType.COLLECTIBLE_MYSTERIOUS_LIQUID,
	CollectibleType.COLLECTIBLE_NUMBER_ONE,
	CollectibleType.COLLECTIBLE_OUIJA_BOARD,
	CollectibleType.COLLECTIBLE_PARASITOID,
	CollectibleType.COLLECTIBLE_PROPTOSIS,
	CollectibleType.COLLECTIBLE_PUPULA_DUPLEX,
	CollectibleType.COLLECTIBLE_RUBBER_CEMENT,
	CollectibleType.COLLECTIBLE_SAGITTARIUS,
	CollectibleType.COLLECTIBLE_SCORPIO,
	CollectibleType.COLLECTIBLE_SINUS_INFECTION,
	--CollectibleType.COLLECTIBLE_SPEED_BALL,
	CollectibleType.COLLECTIBLE_SPOON_BENDER,
	CollectibleType.COLLECTIBLE_INNER_EYE,
	CollectibleType.COLLECTIBLE_PARASITE,
	--CollectibleType.COLLECTIBLE_SAD_ONION,
	CollectibleType.COLLECTIBLE_THE_WIZ,
	CollectibleType.COLLECTIBLE_TOUGH_LOVE,
}

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, familiar)
	local player = familiar.Player
	local data = mod:GetEntityData(familiar)
	local sprite = familiar:GetSprite()
	local isSuperpositioned = mod:isSuperpositionedPlayer(familiar.Player)
	local isSirenCharmed = mod:isSirenCharmed(familiar)
	local isKingBabyTarget = mod:isKingBabyAParent(familiar, true)
	local isPlayerMarked = familiar.Player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED)

	if not data.state then
		familiar:AddToFollowers()
		familiar.FireCooldown = 0
		
		data.state = "Float"
		data.stateframe = 0
		
		data.configframe = 0
		data.currentdollarconfig = ThreeDollarBillEffects[math.random(#ThreeDollarBillEffects)]
	else
		familiar.FireCooldown = familiar.FireCooldown - ((player and player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) and 2) or 1)
		familiar.FireCooldown = math.max(0, familiar.FireCooldown)
		
		data.stateframe = data.stateframe + 1
		data.configframe = data.configframe + 1
	end
	
	local familiarConfig = mod.SewingManualWhitelist[familiar.SubType] or {}
	if familiar.SubType == CollectibleType.COLLECTIBLE_3_DOLLAR_BILL then
		if data.configframe >= 150 then  --normally 3 dollar bill would be two effects with one changing every 2-3 seconds but im not setting this up to support two effects
			data.currentdollarconfig = ThreeDollarBillEffects[math.random(#ThreeDollarBillEffects)]
			data.configframe = 0
		end
		familiarConfig = mod.SewingManualWhitelist[data.currentdollarconfig] or {}
	end
	
	local direction = player:GetFireDirection()
	data.lastdirection = (data.lastdirection ~= nil and data.lastdirection) or direction
	data.lastdirection = (direction ~= Direction.NO_DIRECTION and direction) or data.lastdirection
	if familiar.FireCooldown <= 0 and mod.IsPlayerTryingToShoot(player) then
		data.stateframe = 0
		data.state = "Shoot"
		familiar.FireCooldown = familiarConfig.FireCooldown or 22
		if Sewn_API then
			if Sewn_API:IsUltra(data) then
				familiar.FireCooldown = familiar.FireCooldown - 8
			elseif Sewn_API:IsSuper(data) then
				familiar.FireCooldown = familiar.FireCooldown - 4
			end
		end
		
		local cancelTearFiring = Isaac.RunCallbackWithParam(mod.CALLBACK.PRE_DOLL_FIRE_TEAR, familiar.SubType, familiar)
		if cancelTearFiring == false then
			goto continueSewingManualDollAIAfterFiring
		end
		
		if isSirenCharmed then
			local velocity = mod.GetFamiliarShootingDirection(familiar):Resized(10)
			velocity = velocity + player:GetTearMovementInheritance(velocity)
			
			local proj = Isaac.Spawn(9, 0, 0, familiar.Position, velocity, familiar):ToProjectile()
			if familiarConfig.TearColor then
				proj.Color = familiarConfig.TearColor
			end
		else
			local isProc = math.random() <= (familiarConfig.ProcChance or -1)
		
			local velocity = mod.GetFamiliarShootingDirection(familiar):Resized(familiarConfig.TearVelocity or 10)
			velocity = velocity + player:GetTearMovementInheritance(velocity)
			local variant = familiarConfig.TearVariant or 0
			if isProc and familiarConfig.ProcTearVariant then
				variant = familiarConfig.ProcTearVariant
			end
			local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, variant, 0, familiar.Position, velocity, familiar):ToTear()
			
			tear.Height = familiarConfig.TearHeight or -23.75
			tear.FallingSpeed = (familiarConfig.TearFallingSpeed or 0.1) + math.random() * 0.2
			tear.FallingAcceleration = familiarConfig.TearFallingAccel or 0.0
			if familiarConfig.KnockbackMultiplier then
				tear.KnockbackMultiplier = familiarConfig.KnockbackMultiplier
			end
			if familiarConfig.Mass then
				tear.Mass = familiarConfig.Mass
			end
			
			tear.CollisionDamage = familiarConfig.TearDamage or 3.5
			if isProc and familiarConfig.ProcTearDamage then
				tear.CollisionDamage = familiarConfig.ProcTearDamage
			end
			tear.Scale = 0.8
			if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
				tear.CollisionDamage = tear.CollisionDamage * 2
				tear.Scale = 1.0
			end
			if Sewn_API then
				if Sewn_API:IsUltra(data) then
					tear.CollisionDamage = tear.CollisionDamage * 1.5
					tear.Scale = tear.Scale * 1.1
				elseif Sewn_API:IsSuper(data) then
					tear.CollisionDamage = tear.CollisionDamage * 1.25
					tear.Scale = tear.Scale * 1.05
				end
			end
			tear:ResetSpriteScale()
			
			if isProc and familiarConfig.ProcTearColor then
				tear.Color = familiarConfig.ProcTearColor
			elseif familiarConfig.TearColor then
				tear.Color = familiarConfig.TearColor
			end
			if player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
				tear:AddTearFlags(TearFlags.TEAR_HOMING)
				local tearcolor = Color(0.4, 0.15, 0.38, 1, 55/255, 5/255, 95/255)
				tear.Color = tearcolor
			end
			
			if isSuperpositioned then
				local tearcolor = Color.Lerp(tear.Color, Color(1,1,1,1,0,0,0), 0)
				tearcolor.A = tearcolor.A / 4
				tear.Color = tearcolor
				tear.CollisionDamage = tear.CollisionDamage/4
			end
			
			if isProc and familiarConfig.ProcTearFlags then
				tear:AddTearFlags(familiarConfig.ProcTearFlags)
			end
			if familiarConfig.TearFlags then
				tear:AddTearFlags(familiarConfig.TearFlags)
			end
			
			Isaac.RunCallbackWithParam(mod.CALLBACK.POST_DOLL_FIRE_TEAR, familiar.SubType, familiar, tear)
			tear:Update()
		end
	end
	
	::continueSewingManualDollAIAfterFiring::
	
	if data.state == "Float" then
		if direction == Direction.LEFT and not (sprite:IsPlaying("FloatLeft") and sprite.FlipX == true) then
			local frame = sprite:GetFrame()
			sprite:Play("FloatLeft", true)
			sprite:SetFrame(frame)
			sprite.FlipX = false
		elseif direction == Direction.RIGHT and not (sprite:IsPlaying("FloatRight") and sprite.FlipX == false) then
			local frame = sprite:GetFrame()
			sprite:Play("FloatRight", true)
			sprite:SetFrame(frame)
			sprite.FlipX = false
		elseif direction == Direction.UP and not sprite:IsPlaying("FloatUp") then
			local frame = sprite:GetFrame()
			sprite:Play("FloatUp", true)
			sprite:SetFrame(frame)
			sprite.FlipX = false
		elseif (direction == Direction.DOWN or direction == Direction.NO_DIRECTION) and not sprite:IsPlaying("FloatDown") then
			local frame = sprite:GetFrame()
			sprite:Play("FloatDown", true)
			sprite:SetFrame(frame)
			sprite.FlipX = false
		end
	elseif data.state == "Shoot" then
		if data.lastdirection == Direction.LEFT and not (sprite:IsPlaying("FloatShootLeft") and sprite.FlipX == true) then
			local frame = sprite:GetFrame()
			sprite:Play("FloatShootLeft", true)
			sprite:SetFrame(frame)
			sprite.FlipX = false
		elseif data.lastdirection == Direction.RIGHT and not (sprite:IsPlaying("FloatShootRight") and sprite.FlipX == false) then
			local frame = sprite:GetFrame()
			sprite:Play("FloatShootRight", true)
			sprite:SetFrame(frame)
			sprite.FlipX = false
		elseif data.lastdirection == Direction.UP and not sprite:IsPlaying("FloatShootUp") then
			local frame = sprite:GetFrame()
			sprite:Play("FloatShootUp", true)
			sprite:SetFrame(frame)
			sprite.FlipX = false
		elseif (data.lastdirection == Direction.DOWN or data.lastdirection == Direction.NO_DIRECTION) and not sprite:IsPlaying("FloatShootDown") then
			local frame = sprite:GetFrame()
			sprite:Play("FloatShootDown", true)
			sprite:SetFrame(frame)
			sprite.FlipX = false
		end
		
		if (direction ~= Direction.NO_DIRECTION and data.stateframe >= 9) or data.stateframe >= 17 then
			data.state = "Float"
			data.stateframe = 0
		end
	end
	
	familiar:FollowParent()
end, FiendFolio.ITEM.FAMILIAR.SEWING_MANUAL_DOLL)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_FAMILIAR_RENDER, CallbackPriority.LATE, function(_, familiar, offset)
	if familiar.Visible and familiar.SubType == mod.ITEM.COLLECTIBLE.INFESTATION_0 then
		local sprite = familiar:GetSprite()
		local familiarConfig = mod.SewingManualWhitelist[familiar.SubType] or {}
		
		local outlineLayer = sprite:GetLayer("outline")
		if outlineLayer then
			outlineLayer:SetColor(Color(0,0,0,96/255,1,0,0))
			sprite:Render(Isaac.WorldToRenderPosition(familiar.Position + familiar.PositionOffset) + offset + Vector(-1,0))
			outlineLayer:SetColor(Color(0,0,0,96/255,0,1,1))
			sprite:Render(Isaac.WorldToRenderPosition(familiar.Position + familiar.PositionOffset) + offset + Vector(1,0))
			outlineLayer:SetColor(familiarConfig.OutlineColor or Color())
		end
	end
end, FiendFolio.ITEM.FAMILIAR.SEWING_MANUAL_DOLL)

---------------------------
-- Basegame Item Effects --
---------------------------

-- My Reflection
mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	tear.FallingSpeed = tear.FallingSpeed / 2
	tear.Parent = familiar
	mod:GetEntityData(tear).FFSewingManualBoomerang = true
end, CollectibleType.COLLECTIBLE_MY_REFLECTION)

mod:AddPriorityCallback(ModCallbacks.MC_POST_TEAR_UPDATE, CallbackPriority.IMPORTANT, function(_, tear)
	local data = mod:GetEntityData(tear)
	if data.FFSewingManualBoomerang and tear.Parent then
		tear.Velocity = tear.Velocity + (tear.Parent.Position - tear.Position):Resized(0.5)
	end
end)

-- Ipecac
mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	tear.CollisionDamage = tear.CollisionDamage + 40
	tear.Scale = tear.Scale * 1.25
end, CollectibleType.COLLECTIBLE_IPECAC)

-- Polyphemus
mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	tear.Scale = tear.Scale * 1.6
end, CollectibleType.COLLECTIBLE_POLYPHEMUS)

-- Anti-Gravity
mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	tear.Parent = familiar
end, CollectibleType.COLLECTIBLE_ANTI_GRAVITY)

-- Tiny Planet
mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	tear.FallingSpeed = tear.FallingSpeed * 3
	tear.Parent = familiar
end, CollectibleType.COLLECTIBLE_TINY_PLANET)

-- Cricket's Body
mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	mod:GetEntityData(tear).FFSewingManualQuadsplit = true
end, CollectibleType.COLLECTIBLE_CRICKETS_BODY)

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, tear)
	local tear = tear:ToTear()
	if tear then
		local data = mod:GetEntityData(tear)
		if data.FFSewingManualQuadsplit and tear:IsDead() then
			local velocity = Vector.FromAngle(math.random() * 360):Resized(10)
			for i = 1, 4 do
				local qtear = Isaac.Spawn(EntityType.ENTITY_TEAR, tear.Variant, tear.SubType, tear.Position, velocity:Rotated(i * 90), tear.SpawnerEntity):ToTear()
				
				qtear.Height = -11.875
				qtear.FallingSpeed = 0.757 + math.random() * 0.2
				qtear.FallingAcceleration = 0.0
				
				qtear.CollisionDamage = tear.CollisionDamage / 2
				qtear.Scale = tear.Scale * 0.6
				tear:ResetSpriteScale()
				
				qtear.Color = tear.Color
				qtear.TearFlags = tear.TearFlags
				
				qtear:Update()
			end
		end
	end
end)

-- Proptosis
mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	tear.Scale = tear.Scale * 1.56
	tear:ResetSpriteScale()
end, CollectibleType.COLLECTIBLE_PROPTOSIS)

-- Soy Milk
mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	tear.Scale = tear.Scale - 0.3
	tear:ResetSpriteScale()
end, CollectibleType.COLLECTIBLE_SOY_MILK)

-- Dead Onion
mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	tear.Scale = tear.Scale * 1.22
	tear:ResetSpriteScale()
end, CollectibleType.COLLECTIBLE_DEAD_ONION)

-- Pupula Duplex
mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	tear.Scale = tear.Scale * 1.6
	tear:ResetSpriteScale()
end, CollectibleType.COLLECTIBLE_PUPULA_DUPLEX)

-- Crown of Light
mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	local player = familiar.Player
	if player and not (mod:GetEntityData(player).FFSewingManualDisableCrown or not player:HasFullHearts()) then
		tear.Velocity = mod.GetFamiliarShootingDirection(familiar):Resized(7)
		tear.Velocity = tear.Velocity + player:GetTearMovementInheritance(tear.Velocity)
		
		tear.CollisionDamage = tear.CollisionDamage * 2
		tear.FallingSpeed = -0.977 + math.random() * 0.2
		tear:ChangeVariant(TearVariant.DIAMOND)
	end
end, CollectibleType.COLLECTIBLE_CROWN_OF_LIGHT)

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, function(_, player)
	mod:GetEntityData(player).FFSewingManualDisableCrown = true
end, EntityType.ENTITY_PLAYER)

-- Fruit Cake
local FruitCakeEffects = {
	TearFlags.TEAR_SPECTRAL,
	TearFlags.TEAR_PIERCING,
	TearFlags.TEAR_HOMING,
	TearFlags.TEAR_SLOW,
	TearFlags.TEAR_POISON,
	TearFlags.TEAR_FREEZE,
	TearFlags.TEAR_SPLIT,
	TearFlags.TEAR_GROW,
	TearFlags.TEAR_BOOMERANG,
	TearFlags.TEAR_PERSISTENT,
	TearFlags.TEAR_WIGGLE,
	TearFlags.TEAR_MULLIGAN,
	TearFlags.TEAR_EXPLOSIVE,
	TearFlags.TEAR_CHARM,
	TearFlags.TEAR_CONFUSION,
	TearFlags.TEAR_HP_DROP,
	TearFlags.TEAR_ORBIT,
	TearFlags.TEAR_WAIT,
	TearFlags.TEAR_QUADSPLIT,
	TearFlags.TEAR_BOUNCE,
	TearFlags.TEAR_FEAR,
	TearFlags.TEAR_SHRINK,
	TearFlags.TEAR_BURN,
	TearFlags.TEAR_ATTRACTOR,
	TearFlags.TEAR_KNOCKBACK,
	TearFlags.TEAR_PULSE,
	TearFlags.TEAR_SPIRAL,
	TearFlags.TEAR_FLAT,
	TearFlags.TEAR_SQUARE,
	TearFlags.TEAR_GLOW,
	TearFlags.TEAR_GISH | TearFlags.TEAR_SLOW,
	TearFlags.TEAR_MYSTERIOUS_LIQUID_CREEP,
	TearFlags.TEAR_SHIELDED,
	TearFlags.TEAR_STICKY,
	TearFlags.TEAR_CONTINUUM,
	TearFlags.TEAR_LIGHT_FROM_HEAVEN,
	TearFlags.TEAR_GODS_FLESH,
	TearFlags.TEAR_GREED_COIN,
	TearFlags.TEAR_BIG_SPIRAL,
	TearFlags.TEAR_PERMANENT_CONFUSION,
	TearFlags.TEAR_BOOGER,
	TearFlags.TEAR_EGG,
	TearFlags.TEAR_ACID,
	TearFlags.TEAR_BONE,
	TearFlags.TEAR_BELIAL,
	TearFlags.TEAR_MIDAS,
	TearFlags.TEAR_NEEDLE,
	TearFlags.TEAR_JACOBS,
	TearFlags.TEAR_HORN,
	TearFlags.TEAR_LASER,
	TearFlags.TEAR_POP,
	TearFlags.TEAR_ABSORB,
	TearFlags.TEAR_LASERSHOT,
	TearFlags.TEAR_HYDROBOUNCE,
	TearFlags.TEAR_BURSTSPLIT,
	TearFlags.TEAR_PUNCH,
	TearFlags.TEAR_ICE,
	TearFlags.TEAR_MAGNETIZE,
	TearFlags.TEAR_BAIT,
	TearFlags.TEAR_OCCULT,
	TearFlags.TEAR_ORBIT_ADVANCED,
	TearFlags.TEAR_ROCK,
	TearFlags.TEAR_TURN_HORIZONTAL,
	TearFlags.TEAR_ECOLI,
	TearFlags.TEAR_COIN_DROP_DEATH,
	TearFlags.TEAR_RIFT,
	TearFlags.TEAR_SPORE,
	TearFlags.TEAR_CARD_DROP_DEATH,
	TearFlags.TEAR_RUNE_DROP_DEATH,
	TearFlags.TEAR_TELEPORT,
	TearFlags.TEAR_ENEMY_TO_WISP,
}

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	tear.TearFlags = tear.TearFlags | FruitCakeEffects[math.random(#FruitCakeEffects)]
	tear.Parent = familiar
end, CollectibleType.COLLECTIBLE_FRUIT_CAKE)

-- Lead Pencil
local function getSign(rng)
    local r = rng:RandomInt(2)
    if r == 0 then 
        return -1
    else
        return 1
    end
end

mod:AddCallback(FiendFolio.CALLBACK.PRE_DOLL_FIRE_TEAR, function(_, familiar)
	local data = mod:GetEntityData(familiar)

	data.FFSewingManualLeadPencilShots = data.FFSewingManualLeadPencilShots or 0
	data.FFSewingManualLeadPencilShots = (data.FFSewingManualLeadPencilShots + 1) % 15
	data.FFSewingManualLeadPencilShots = data.FFSewingManualLeadPencilShots 
	
	if data.FFSewingManualLeadPencilShots == 0 then
		local player = familiar.Player
		local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_LEAD_PENCIL)
		
		local burstVel = mod.GetFamiliarShootingDirection(familiar):Resized(13)
		burstVel = burstVel + player:GetTearMovementInheritance(burstVel)
		
		for i = 1, 12 do
			local a = getSign(rng) * rng:RandomFloat()
			local b = (getSign(rng) * rng:RandomFloat() * math.pi) * 2
			
			local tearVelX = math.cos(b) * a * 3.5 + burstVel.X
			local tearVelY = math.sin(b) * a * 3.5 + burstVel.Y
			
			local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLOOD, 0, familiar.Position, Vector(tearVelX, tearVelY), familiar):ToTear()
			
			tear.Height = -23.75
			tear.FallingSpeed = ((0.1 + math.random() * 0.2) - rng:RandomFloat() * 15.0) + 5.0
			tear.FallingAcceleration = 0.5
			
			tear.CollisionDamage = 3.5
			tear.Scale = 0.8
			if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
				tear.CollisionDamage = tear.CollisionDamage * 2
				tear.Scale = 1.0
			end
			if Sewn_API then
				if Sewn_API:IsUltra(data) then
					tear.CollisionDamage = tear.CollisionDamage * 1.5
					tear.Scale = tear.Scale * 1.1
				elseif Sewn_API:IsSuper(data) then
					tear.CollisionDamage = tear.CollisionDamage * 1.25
					tear.Scale = tear.Scale * 1.05
				end
			end
			
			local scale = (rng:RandomInt(2) * 0.4 + 0.9 + getSign(rng) * rng:RandomFloat() * 0.05) * tear.Scale
			if scale <= 0.01 then
				scale = 0.01
			end
			tear.Scale = scale
			tear:ResetSpriteScale()
			
			if player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
				tear:AddTearFlags(TearFlags.TEAR_HOMING)
				local tearcolor = Color(0.4, 0.15, 0.38, 1, 55/255, 5/255, 95/255)
				tear.Color = tearcolor
			end
			
			if mod:isSuperpositionedPlayer(familiar.Player) then
				local tearcolor = Color.Lerp(tear.Color, Color(1,1,1,1,0,0,0), 0)
				tearcolor.A = tearcolor.A / 4
				tear.Color = tearcolor
				tear.CollisionDamage = tear.CollisionDamage/4
			end
		end
			
		return false
    end
end, CollectibleType.COLLECTIBLE_LEAD_PENCIL)

-- Haemolacria
mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	tear.Scale = tear.Scale * 1.56
end, CollectibleType.COLLECTIBLE_HAEMOLACRIA)

-- Playdough Cookie
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, familiar)
	if familiar.SubType == CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE then
		local sprite = familiar:GetSprite()
		
		local eyeALayer = sprite:GetLayer("eyeA")
		if eyeALayer then
			eyeALayer:SetColor(playdoughRainbowColors[game:GetFrameCount() % #playdoughRainbowColors + 1])
		end
		
		local eyeBLayer = sprite:GetLayer("eyeB")
		if eyeBLayer then
			eyeBLayer:SetColor(playdoughRainbowColors[game:GetFrameCount() % #playdoughRainbowColors + 1])
		end
	end
end, FiendFolio.ITEM.FAMILIAR.SEWING_MANUAL_DOLL)

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	local color = math.random(11)
	local proc = math.random()
	
	if color == 1 then
		tear.Color = playdoughRedColor
		if proc <= 1/2 then
			tear.CollisionDamage = tear.CollisionDamage * 2
		elseif proc <= 1/2 + 1/6 then
			tear:AddTearFlags(TearFlags.TEAR_FREEZE)
		end
	elseif color == 2 then
		tear.Color = playdoughPinkColor
		if proc <= 1/2 then
			tear:AddTearFlags(TearFlags.TEAR_CHARM)
		end
	elseif color == 3 then
		tear.Color = playdoughPurpleColor
		if proc <= 1/2 then
			tear:AddTearFlags(TearFlags.TEAR_HOMING)
		else
			tear:AddTearFlags(TearFlags.TEAR_TURN_HORIZONTAL)
		end
	elseif color == 4 then
		tear.Color = playdoughBlueColor
		if proc <= 1/3 then
			tear:AddTearFlags(TearFlags.TEAR_SHRINK)
		end
	elseif color == 5 then
		tear.Color = playdoughCyanColor
		if proc <= 1/4 then
			tear:AddTearFlags(TearFlags.TEAR_SLOW | TearFlags.TEAR_ICE)
		end
	elseif color == 6 then
		tear.Color = playdoughGreenColor
		tear:AddTearFlags(TearFlags.TEAR_POISON)
	elseif color == 7 then
		tear.Color = playdoughYellowColor
		if proc <= 1/2 then
			tear:AddTearFlags(TearFlags.TEAR_FEAR)
		end
	elseif color == 8 then
		tear.Color = playdoughOrangeColor
		if proc <= 5/12 then
			tear:AddTearFlags(TearFlags.TEAR_BURN)
		elseif proc <= 5/12 + 1/4 then
			tear:AddTearFlags(TearFlags.TEAR_BAIT)
		end
	else
		tear.Color = playdoughBrownColor
	end
	
	if familiar.Player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
		local tearcolor = Color(0.4, 0.15, 0.38, 1, 55/255, 5/255, 95/255)
		tear.Color = tearcolor
	end
	if mod:isSuperpositionedPlayer(familiar.Player) then
		local tearcolor = Color.Lerp(tear.Color, Color(1,1,1,1,0,0,0), 0)
		tearcolor.A = tearcolor.A / 4
		tear.Color = tearcolor
	end
end, CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE)

-- Almond Milk
local AlmondMilkEffects = {
	FLAT_WORM = 1,
	PULSE_WORM = 2,
	WIGGLE_WORM = 3,
	HOOK_WORM = 4,
	RING_WORM = 5,
	WHIP_WORM = 6,
	LAZY_WORM = 7,
	TAPE_WORM = 8,
	OUROBOROS_WORM = 9,
	BRAIN_WORM = 10,
	RUBBER_CEMENT = 11,
	MY_REFLECTION = 12,
	TINY_PLANET = 13
}

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	local effect = math.random(13)
	
	if effect == AlmondMilkEffects.FLAT_WORM then
		tear:AddTearFlags(TearFlags.TEAR_FLAT)
	elseif effect == AlmondMilkEffects.PULSE_WORM then
		tear:AddTearFlags(TearFlags.TEAR_PULSE)
	elseif effect == AlmondMilkEffects.WIGGLE_WORM then
		tear:AddTearFlags(TearFlags.TEAR_WIGGLE | TearFlags.TEAR_SPECTRAL)
	elseif effect == AlmondMilkEffects.HOOK_WORM then
		tear:AddTearFlags(TearFlags.TEAR_SQUARE | TearFlags.TEAR_SPECTRAL)
		tear.FallingSpeed = tear.FallingSpeed - 0.5
	elseif effect == AlmondMilkEffects.RING_WORM then
		tear:AddTearFlags(TearFlags.TEAR_SPIRAL | TearFlags.TEAR_SPECTRAL)
	elseif effect == AlmondMilkEffects.WHIP_WORM then
		tear.Velocity = tear.Velocity:Resized(tear.Velocity:Length() * 1.5)
		tear.FallingSpeed = tear.FallingSpeed + 1.2
	elseif effect == AlmondMilkEffects.LAZY_WORM then
		tear.Velocity = tear.Velocity:Resized(tear.Velocity:Length() * 0.6)
		tear.FallingSpeed = tear.FallingSpeed - 1.6
	elseif effect == AlmondMilkEffects.TAPE_WORM then
		tear.FallingSpeed = tear.FallingSpeed - 1.0
	elseif effect == AlmondMilkEffects.OUROBOROS_WORM then
		tear:AddTearFlags(TearFlags.TEAR_BIG_SPIRAL | TearFlags.TEAR_SPECTRAL)
		tear.FallingSpeed = tear.FallingSpeed - 0.5
	elseif effect == AlmondMilkEffects.BRAIN_WORM then
		tear:AddTearFlags(TearFlags.TEAR_TURN_HORIZONTAL)
	elseif effect == AlmondMilkEffects.RUBBER_CEMENT then
		tear:AddTearFlags(TearFlags.TEAR_BOUNCE)
	elseif effect == AlmondMilkEffects.MY_REFLECTION then
		local player = familiar.Player
		
		tear.Velocity = mod.GetFamiliarShootingDirection(familiar):Resized(16)
		tear.Velocity = tear.Velocity + player:GetTearMovementInheritance(tear.Velocity)
		
		tear.FallingSpeed = (-0.885 + math.random() * 0.2) / 2
		tear.FallingAcceleration = -0.06
		mod:GetEntityData(tear).FFSewingManualBoomerang = true
	elseif effect == AlmondMilkEffects.TINY_PLANET then
		tear.FallingSpeed = -2.518 + math.random() * 0.2
		tear:AddTearFlags(TearFlags.TEAR_ORBIT | TearFlags.TEAR_SPECTRAL)
	end
	
	tear.Parent = familiar
	tear.Scale = tear.Scale - 0.35
	tear:ResetSpriteScale()
end, CollectibleType.COLLECTIBLE_ALMOND_MILK)

-- Eye of the Occult
mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	tear.Parent = familiar
end, CollectibleType.COLLECTIBLE_EYE_OF_THE_OCCULT)

-- Terra
mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	tear.CollisionDamage = tear.CollisionDamage * (math.random() * 1.5 + 0.5)
end, CollectibleType.COLLECTIBLE_TERRA)

-- Mom's Eye
mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	if math.random() <= 0.5 then
		local player = familiar.Player
		
		local velocity = mod.GetFamiliarShootingDirection(familiar):Resized(10)
		velocity = velocity + player:GetTearMovementInheritance(velocity)
		velocity = velocity:Rotated(180)
		
		local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLUE, 0, familiar.Position, velocity, familiar):ToTear()
		
		tear.Height = -23.75
		tear.FallingSpeed = 0.1 + math.random() * 0.2
		tear.FallingAcceleration = 0.0
		
		tear.CollisionDamage = 3.5
		tear.Scale = 0.8
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
			tear.CollisionDamage = tear.CollisionDamage * 2
			tear.Scale = 1.0
		end
		if Sewn_API then
			if Sewn_API:IsUltra(data) then
				tear.CollisionDamage = tear.CollisionDamage * 1.5
				tear.Scale = tear.Scale * 1.1
			elseif Sewn_API:IsSuper(data) then
				tear.CollisionDamage = tear.CollisionDamage * 1.25
				tear.Scale = tear.Scale * 1.05
			end
		end
		tear:ResetSpriteScale()
		
		if player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
			tear:AddTearFlags(TearFlags.TEAR_HOMING)
			local tearcolor = Color(0.4, 0.15, 0.38, 1, 55/255, 5/255, 95/255)
			tear.Color = tearcolor
		end
		
		if mod:isSuperpositionedPlayer(familiar.Player) then
			local tearcolor = Color.Lerp(tear.Color, Color(1,1,1,1,0,0,0), 0)
			tearcolor.A = tearcolor.A / 4
			tear.Color = tearcolor
			tear.CollisionDamage = tear.CollisionDamage/4
		end
		
		tear:Update()
	end
end, CollectibleType.COLLECTIBLE_MOMS_EYE)

-- Loki's Horns
mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	if math.random() <= 0.25 then
		local player = familiar.Player
		
		for i = 90, 270, 90 do
			local velocity = mod.GetFamiliarShootingDirection(familiar):Resized(10)
			velocity = velocity + player:GetTearMovementInheritance(velocity)
			velocity = velocity:Rotated(i)
			
			local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLUE, 0, familiar.Position, velocity, familiar):ToTear()
			
			tear.Height = -23.75
			tear.FallingSpeed = 0.1 + math.random() * 0.2
			tear.FallingAcceleration = 0.0
			
			tear.CollisionDamage = 3.5
			tear.Scale = 0.8
			if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
				tear.CollisionDamage = tear.CollisionDamage * 2
				tear.Scale = 1.0
			end
			if Sewn_API then
				if Sewn_API:IsUltra(data) then
					tear.CollisionDamage = tear.CollisionDamage * 1.5
					tear.Scale = tear.Scale * 1.1
				elseif Sewn_API:IsSuper(data) then
					tear.CollisionDamage = tear.CollisionDamage * 1.25
					tear.Scale = tear.Scale * 1.05
				end
			end
			tear:ResetSpriteScale()
			
			if player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
				tear:AddTearFlags(TearFlags.TEAR_HOMING)
				local tearcolor = Color(0.4, 0.15, 0.38, 1, 55/255, 5/255, 95/255)
				tear.Color = tearcolor
			end
			
			if mod:isSuperpositionedPlayer(familiar.Player) then
				local tearcolor = Color.Lerp(tear.Color, Color(1,1,1,1,0,0,0), 0)
				tearcolor.A = tearcolor.A / 4
				tear.Color = tearcolor
				tear.CollisionDamage = tear.CollisionDamage/4
			end
			
			tear:Update()
		end
	end
end, CollectibleType.COLLECTIBLE_LOKIS_HORNS)

-- The Wiz
mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	local player = familiar.Player
	tear.Velocity = tear.Velocity:Rotated(-45)
	
	local velocity = mod.GetFamiliarShootingDirection(familiar):Resized(10)
	velocity = velocity + player:GetTearMovementInheritance(velocity)
	velocity = velocity:Rotated(45)
	
	local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLUE, 0, familiar.Position, velocity, familiar):ToTear()
	
	tear.Height = -23.75
	tear.FallingSpeed = 0.1 + math.random() * 0.2
	tear.FallingAcceleration = 0.0
	
	tear.CollisionDamage = 3.5
	tear.Scale = 0.8
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
		tear.CollisionDamage = tear.CollisionDamage * 2
		tear.Scale = 1.0
	end
	if Sewn_API then
		if Sewn_API:IsUltra(data) then
			tear.CollisionDamage = tear.CollisionDamage * 1.5
			tear.Scale = tear.Scale * 1.1
		elseif Sewn_API:IsSuper(data) then
			tear.CollisionDamage = tear.CollisionDamage * 1.25
			tear.Scale = tear.Scale * 1.05
		end
	end
	tear:ResetSpriteScale()
	
	if player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
		tear:AddTearFlags(TearFlags.TEAR_HOMING)
		local tearcolor = Color(0.4, 0.15, 0.38, 1, 55/255, 5/255, 95/255)
		tear.Color = tearcolor
	end
	
	if mod:isSuperpositionedPlayer(familiar.Player) then
		local tearcolor = Color.Lerp(tear.Color, Color(1,1,1,1,0,0,0), 0)
		tearcolor.A = tearcolor.A / 4
		tear.Color = tearcolor
		tear.CollisionDamage = tear.CollisionDamage/4
	end
	
	tear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
	
	tear:Update()
end, CollectibleType.COLLECTIBLE_THE_WIZ)

-- Eye Sore
mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	local rand = math.random()
	local numTears = 0
	if rand <= 3/16 then
		numTears = 1
	elseif rand <= 5/16 then
		numTears = 2
	elseif rand <= 6/16 then
		numTears = 3
	else
		return
	end
	
	local player = familiar.Player
	
	for i = 1, numTears do
		local velocity = mod.GetFamiliarShootingDirection(familiar):Resized(10)
		velocity = velocity + player:GetTearMovementInheritance(velocity)
		velocity = velocity:Rotated(math.random() * 360)
		
		local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLUE, 0, familiar.Position, velocity, familiar):ToTear()
		
		tear.Height = -23.75
		tear.FallingSpeed = 0.1 + math.random() * 0.2
		tear.FallingAcceleration = 0.0
		
		tear.CollisionDamage = 3.5
		tear.Scale = 0.8
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
			tear.CollisionDamage = tear.CollisionDamage * 2
			tear.Scale = 1.0
		end
		if Sewn_API then
			if Sewn_API:IsUltra(data) then
				tear.CollisionDamage = tear.CollisionDamage * 1.5
				tear.Scale = tear.Scale * 1.1
			elseif Sewn_API:IsSuper(data) then
				tear.CollisionDamage = tear.CollisionDamage * 1.25
				tear.Scale = tear.Scale * 1.05
			end
		end
		tear:ResetSpriteScale()
		
		if player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
			tear:AddTearFlags(TearFlags.TEAR_HOMING)
			local tearcolor = Color(0.4, 0.15, 0.38, 1, 55/255, 5/255, 95/255)
			tear.Color = tearcolor
		end
		
		if mod:isSuperpositionedPlayer(familiar.Player) then
			local tearcolor = Color.Lerp(tear.Color, Color(1,1,1,1,0,0,0), 0)
			tearcolor.A = tearcolor.A / 4
			tear.Color = tearcolor
			tear.CollisionDamage = tear.CollisionDamage/4
		end
		
		tear:Update()
	end
end, CollectibleType.COLLECTIBLE_EYE_SORE)

-- 20/20
mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	local player = familiar.Player
	tear.Position = tear.Position + Vector.FromAngle(tear.Velocity:GetAngleDegrees() + 90):Resized(8)
	
	local velocity = mod.GetFamiliarShootingDirection(familiar):Resized(10)
	velocity = velocity + player:GetTearMovementInheritance(velocity)
	
	local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLUE, 0, familiar.Position + Vector.FromAngle(velocity:GetAngleDegrees() - 90):Resized(8), velocity, familiar):ToTear()
	
	tear.Height = -23.75
	tear.FallingSpeed = 0.1 + math.random() * 0.2
	tear.FallingAcceleration = 0.0
	
	tear.CollisionDamage = 3.5
	tear.Scale = 0.8
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
		tear.CollisionDamage = tear.CollisionDamage * 2
		tear.Scale = 1.0
	end
	if Sewn_API then
		if Sewn_API:IsUltra(data) then
			tear.CollisionDamage = tear.CollisionDamage * 1.5
			tear.Scale = tear.Scale * 1.1
		elseif Sewn_API:IsSuper(data) then
			tear.CollisionDamage = tear.CollisionDamage * 1.25
			tear.Scale = tear.Scale * 1.05
		end
	end
	tear:ResetSpriteScale()
	
	if player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
		tear:AddTearFlags(TearFlags.TEAR_HOMING)
		local tearcolor = Color(0.4, 0.15, 0.38, 1, 55/255, 5/255, 95/255)
		tear.Color = tearcolor
	end
	
	if mod:isSuperpositionedPlayer(familiar.Player) then
		local tearcolor = Color.Lerp(tear.Color, Color(1,1,1,1,0,0,0), 0)
		tearcolor.A = tearcolor.A / 4
		tear.Color = tearcolor
		tear.CollisionDamage = tear.CollisionDamage/4
	end
	
	tear:Update()
end, CollectibleType.COLLECTIBLE_20_20)

-- Inner Eye
mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	local player = familiar.Player
	tear.Position = tear.Position + Vector.FromAngle(tear.Velocity:GetAngleDegrees()):Resized(11.5)
	
	for i = -1, 1, 2 do
		local velocity = mod.GetFamiliarShootingDirection(familiar):Resized(10)
		velocity = velocity + player:GetTearMovementInheritance(velocity)
		
		local position = familiar.Position + Vector.FromAngle(velocity:GetAngleDegrees() + 180):Resized(0.028) + Vector.FromAngle(velocity:GetAngleDegrees() + 90 * i):Resized(8.757)
		local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLUE, 0, position, velocity:Rotated(4.34 * i), familiar):ToTear()
		
		tear.Height = -23.75
		tear.FallingSpeed = 0.1 + math.random() * 0.2
		tear.FallingAcceleration = 0.0
		
		tear.CollisionDamage = 3.5
		tear.Scale = 0.8
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
			tear.CollisionDamage = tear.CollisionDamage * 2
			tear.Scale = 1.0
		end
		if Sewn_API then
			if Sewn_API:IsUltra(data) then
				tear.CollisionDamage = tear.CollisionDamage * 1.5
				tear.Scale = tear.Scale * 1.1
			elseif Sewn_API:IsSuper(data) then
				tear.CollisionDamage = tear.CollisionDamage * 1.25
				tear.Scale = tear.Scale * 1.05
			end
		end
		tear:ResetSpriteScale()
		
		if player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
			tear:AddTearFlags(TearFlags.TEAR_HOMING)
			local tearcolor = Color(0.4, 0.15, 0.38, 1, 55/255, 5/255, 95/255)
			tear.Color = tearcolor
		end
		
		if mod:isSuperpositionedPlayer(familiar.Player) then
			local tearcolor = Color.Lerp(tear.Color, Color(1,1,1,1,0,0,0), 0)
			tearcolor.A = tearcolor.A / 4
			tear.Color = tearcolor
			tear.CollisionDamage = tear.CollisionDamage/4
		end
		
		tear:Update()
	end
end, CollectibleType.COLLECTIBLE_INNER_EYE)

-- Mutant Spider
mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	local player = familiar.Player
	tear.Position = tear.Position + Vector.FromAngle(tear.Velocity:GetAngleDegrees() + 180):Resized(0.064) + Vector.FromAngle(tear.Velocity:GetAngleDegrees() - 90):Resized(9.134)
	tear.Velocity = tear.Velocity:Rotated(-6.51)
	
	for i = -1, 1, 2 do
		local velocity = mod.GetFamiliarShootingDirection(familiar):Resized(10)
		velocity = velocity + player:GetTearMovementInheritance(velocity)
		
		local position = familiar.Position + Vector.FromAngle(velocity:GetAngleDegrees()):Resized(9.952) + Vector.FromAngle(velocity:GetAngleDegrees() + 90 * i):Resized(4.379)
		local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLUE, 0, position, velocity:Rotated(2.17 * i), familiar):ToTear()
		
		tear.Height = -23.75
		tear.FallingSpeed = 0.1 + math.random() * 0.2
		tear.FallingAcceleration = 0.0
		
		tear.CollisionDamage = 3.5
		tear.Scale = 0.8
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
			tear.CollisionDamage = tear.CollisionDamage * 2
			tear.Scale = 1.0
		end
		if Sewn_API then
			if Sewn_API:IsUltra(data) then
				tear.CollisionDamage = tear.CollisionDamage * 1.5
				tear.Scale = tear.Scale * 1.1
			elseif Sewn_API:IsSuper(data) then
				tear.CollisionDamage = tear.CollisionDamage * 1.25
				tear.Scale = tear.Scale * 1.05
			end
		end
		tear:ResetSpriteScale()
		
		if player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
			tear:AddTearFlags(TearFlags.TEAR_HOMING)
			local tearcolor = Color(0.4, 0.15, 0.38, 1, 55/255, 5/255, 95/255)
			tear.Color = tearcolor
		end
		
		if mod:isSuperpositionedPlayer(familiar.Player) then
			local tearcolor = Color.Lerp(tear.Color, Color(1,1,1,1,0,0,0), 0)
			tearcolor.A = tearcolor.A / 4
			tear.Color = tearcolor
			tear.CollisionDamage = tear.CollisionDamage/4
		end
		
		tear:Update()
	end
	
	local velocity = mod.GetFamiliarShootingDirection(familiar):Resized(10)
	velocity = velocity + player:GetTearMovementInheritance(velocity)
	
	local position = familiar.Position + Vector.FromAngle(velocity:GetAngleDegrees() + 180):Resized(0.064) + Vector.FromAngle(velocity:GetAngleDegrees() + 90):Resized(9.134)
	local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLUE, 0, position, velocity:Rotated(6.51), familiar):ToTear()
	
	tear.Height = -23.75
	tear.FallingSpeed = 0.1 + math.random() * 0.2
	tear.FallingAcceleration = 0.0
	
	tear.CollisionDamage = 3.5
	tear.Scale = 0.8
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
		tear.CollisionDamage = tear.CollisionDamage * 2
		tear.Scale = 1.0
	end
	if Sewn_API then
		if Sewn_API:IsUltra(data) then
			tear.CollisionDamage = tear.CollisionDamage * 1.5
			tear.Scale = tear.Scale * 1.1
		elseif Sewn_API:IsSuper(data) then
			tear.CollisionDamage = tear.CollisionDamage * 1.25
			tear.Scale = tear.Scale * 1.05
		end
	end
	tear:ResetSpriteScale()
	
	if player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
		tear:AddTearFlags(TearFlags.TEAR_HOMING)
		local tearcolor = Color(0.4, 0.15, 0.38, 1, 55/255, 5/255, 95/255)
		tear.Color = tearcolor
	end
	
	if mod:isSuperpositionedPlayer(familiar.Player) then
		local tearcolor = Color.Lerp(tear.Color, Color(1,1,1,1,0,0,0), 0)
		tearcolor.A = tearcolor.A / 4
		tear.Color = tearcolor
		tear.CollisionDamage = tear.CollisionDamage/4
	end
	
	tear:Update()
end, CollectibleType.COLLECTIBLE_MUTANT_SPIDER)

-- Continuum
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, familiar)
	if familiar.SubType == CollectibleType.COLLECTIBLE_CONTINUUM then
		local sprite = familiar:GetSprite()
		
		local eyeALayer = sprite:GetLayer("eyeA")
		if eyeALayer then
			eyeALayer:SetColor(continuumColors[math.floor(game:GetFrameCount() / 2) % #continuumColors + 1])
		end
		
		local eyeBLayer = sprite:GetLayer("eyeB")
		if eyeBLayer then
			eyeBLayer:SetColor(continuumColors[math.floor(game:GetFrameCount() / 2) % #continuumColors + 1])
		end
	end
end, FiendFolio.ITEM.FAMILIAR.SEWING_MANUAL_DOLL)
