FiendFolio.CALLBACK = { -- Custom callbacks make mod compatability easier. Using empty tables as callback ids makes them safely 100% unique.
	MEDLEY_PENNY_PICKUP = {}, -- Passes: EntityPickup: penny, Entity: collider (player or familiar)
	PRE_REWARD_HEART_OF_CHINA = {}, -- Passes: EntityPlayer. Optional argument: PlayerType. Return True to cancel the base Health-Up reward
	EVALUATE_HEART_OF_CHINA_GAUGE_SIZE = {}, -- Passes: Int: currentHealthBarSize, EntityPlayer. Optional argument: PlayerType. Return Int to override the currentHealthBarSize
	PRE_EVAL_CURSE_GATE = {}, -- Passes: Level; Return false to disallow Curse of the Gate from appearing (such as on a custom floor), return true to allow Curse of the Gate to generate on a floor
	SELECT_CURSE_GATE_ROOMS = {}, -- Passes: Level; Return a table {StbType = ..., Variant = ...} to change which set of rooms are used for the Curse of the Gate rooms
	POST_SPAWN_NUGGET_BOMB_POOTER = "POST_SPAWN_NUGGET_BOMB_POOTER", --Passes: EntityFamiliar: spooter, TearFlags: flags, EntityPlayer: player, bool: isDecoy, int: bSeed
	POST_NUGGET_BOMB_POOTER_FIRE_WEAPON = "POST_NUGGET_BOMB_POOTER_FIRE_WEAPON", -- Passes entity: weaponEntity, WeaponType: weaponType, familiar: pooter, bool: isUltraPooter, bool: isMiniPooter. Optional arguemnt: weaponType
	FF_CUSTOM_TEAR_RENDER = "FF_CUSTOM_TEAR_RENDER", -- See ffscripts/customTearVariants.lua for details
	FF_CUSTOM_TEAR_SPLAT = "FF_CUSTOM_TEAR_SPLAT", -- See ffscripts/customTearVariants.lua for details
	PRE_TRIGGER_PLUSH_LAMB = {}, -- Passes EntityPlayer, CollectibleType: itemToReaward. Optional argument: CollectibleType. Return `true` to prevent plush lamb from triggering, return CollectibleType to change which item is re-awarded
	POST_ADD_PLUSH_LAMB_ITEM = {}, -- Passes EntityPlayer, CollectibleType: awardedItem. Optional argument: CollectibleType
	GET_POKER_TABLE_ODDS_PRE_MULTIPLIERS = {}, -- Passes: Int: PlayerOdds, Int: TableOdds. Return `Int, Int` to override odds (2nd Int optional)
	GET_POKER_TABLE_ODDS_POST_MULTIPLIERS = {}, -- Passes: Int: PlayerOdds, Int: TableOdds. Return `Int, Int` to override odds (2nd Int optional)
	PRE_AWARD_WAR_HORN_PENALTY = {}, -- Passes: EntityPlayer: player, EntityRef: damageSource, Int: damageFlags. Return `true` to cancel the penalty
	WAR_HORN_KILL_FAMILIAR = {},
	WAR_HORN_REVIVE_FAMILIAR = {},
	PRE_DECK_BOX_STORE_CARD = {}, -- Passes: EntityPlayer: player, Int: cardId. Optional argument cardID. Return `false` to prevent card being added to Deck Box
	PRE_STRANGE_MATTER_KILL = {}, -- Passes: Entity: targetEntity. Optional argument entityType. Return `true` to prevent entity from being killed
	FF_PLAYER_INPUT_ACTION = "FF_PLAYER_INPUT_ACTION", -- passes player, data, hook, action, optional argument hook
	FF_POST_LUDO_TEAR_RESET = "FF_POST_LUDO_TEAR_RESET",
	FF_PLAYER_HURT_SOUND = "FF_PLAYER_HURT_SOUND", --Passes: Int: PlayerType, EntityPlayer, return true to override default sound
	FF_PLAYER_DEATH_SOUND = "FF_PLAYER_DEATH_SOUND", --Passes: Int: PlayerType, EntityPlayer, return true to override default sound
	DAYDREAM_POST_CONFIRM_EVENT = "DAYDREAM_POST_CONFIRM_EVENT",
	DAYDREAM_POST_DENY_EVENT = "DAYDREAM_POST_DENY_EVENT",
	MC_WOULD_IT_HURT_TO_SLAP_THIS_PLAYER = "MC_WOULD_IT_HURT_TO_SLAP_THIS_PLAYER",
	FF_POST_START_GREED_WAVE = {}, --Passes: Int: waveNumber, Bool: isBossWave
	FF_PLAYER_POST_START_GREED_WAVE = {}, --Passes: EntityPlayer: player, Table: playerData Int: waveNumber, Bool: isBossWave
	FF_POST_PLAYER_POST_START_GREED_WAVE = {}, --Passes: Int: waveNumber, Bool: isBossWave
	FF_POST_END_GREED_WAVE = {}, --Passes: Int: waveNumber, Bool: isBossWave
	FF_PLAYER_POST_END_GREED_WAVE = {}, --Passes: EntityPlayer: player, Table: playerData Int: waveNumber, Bool: isBossWave
	POST_BOLEM_MORPH_PICKUP = "POST_BOLEM_MORPH_PICKUP",
	POST_FIRE_CHERRY_BOMB = "POST_FIRE_CHERRY_BOMB", --Passes: EntityBomb: bomb, EntityPlayer: player
	POST_CHERRY_BOMB_EXPLODE = "POST_CHERRY_BOMB_EXPLODE", --Passes: EntityBomb: bomb
	POST_GKUN_RAIN_TEAR = "POST_GKUN_RAIN_TEAR", --Passes: EntityTear: tear, EntityPlayer: player
	POST_GKUN_RAIN_BOMB = "POST_GKUN_RAIN_BOMB", --Passes: EntityBomb: bomb, EntityPlayer: player
	FF_POLL_BOMBFLAGS = "FF_POLL_BOMBFLAGS", --Passes: Entity: entity, EntityPlayer: player, FiendFolio.BombFlagSource: sourceFlag
	FF_SET_BOMB_VARIANT = "FF_SET_BOMB_VARIANT", --Passes: EntityBomb: bomb, EntityPlayer: player, FiendFolio.BombFlagSource: sourceFlag
	FF_POST_BOMBFLAG_DAMAGE = "FF_POST_BOMBFLAG_DAMAGE",
	FF_POST_BOMBFLAG_EFFECTS = "FF_POST_BOMBFLAG_EFFECTS",
	GET_CAN_OF_BEANS_FART_PARAMS = "GET_CAN_OF_BEANS_FART_PARAMS", -- Passes: Entity: source, EntityPlayer: player, TearFlagsLib.WeaponFlag: weaponFlag, Entity: target). Optional argument: TearFlagsLib.WeaponFlag.
	PRE_CAN_OF_BEANS_WEAPON_FART = "PRE_CAN_OF_BEANS_WEAPON_FART", --Passes: Entity: source, TearFlagsLib.WeaponFlag: weaponFlag, table: params. Optional argument: TearFlagsLib.WeaponFlag. Return false to cancel the fart effect.
	FF_SECONDARY_FIRE = "FF_SECONDARY_FIRE",
	FF_SECONDARY_FIRE_TEAR_EFFECTS = "FF_SECONDARY_FIRE_TEAR_EFFECTS",
	FF_POST_FIRE_SECONDARY_TEAR = "FF_POST_FIRE_SECONDARY_TEAR",
	FF_SECONDARY_FIRE_INCLUDE_LUDO_IN_CLEARED_ROOM = "FF_SECONDARY_FIRE_INCLUDE_LUDO_IN_CLEARED_ROOM",
	FF_POST_IMMACULATE_HEART = "FF_POST_IMMACULATE_HEART",
	FF_POST_TORN_CARD = "FF_POST_TORN_CARD",
	FF_POST_EYE_OF_GREED = "FF_POST_EYE_OF_GREED",
	FF_PRE_LEAD_PENCIL_FIRE_BURST = "FF_PRE_LEAD_PENCIL_FIRE_BURST",
	FF_POST_LEAD_PENCIL_FIRE_TEAR = "FF_POST_LEAD_PENCIL_FIRE_TEAR",
	FF_POST_LEAD_PENCIL_FIRE_BURST = "FF_POST_LEAD_PENCIL_FIRE_BURST",
	FF_SOAPSUDS_CHECK_CHAMPION = "FF_SOAPSUDS_CHECK_CHAMPION",
	PRE_DOLL_FIRE_TEAR = "FF_PRE_DOLL_FIRE_TEAR", -- Passes: EntityFamiliar; Optional argument: CollectibleType. Return false to prevent tear from firing.	--Sewing Manual
	POST_DOLL_FIRE_TEAR = "FF_POST_DOLL_FIRE_TEAR", -- Passes: EntityFamiliar, EntityTear; Optional argument: CollectibleType.								--Sewing Manual
	POST_CHARACTER_SELECT_REVIVE = "FF_POST_CHARACTER_SELECT_REVIVE", -- Passes: Player, PlayerType; Optional argument: PlayerType							--The trinket named Character Select
	POST_ACHIEVEMENT_UNLOCK = "FF_POST_ACHIEVEMENT_UNLOCK", -- Passes: FFAchievementID
	FF_PRE_ADD_MILK = "FF_PRE_ADD_MILK", -- Passes: player, PositiveMilk, NegativeMilk, MilkQuality, return true to cancel applying
	FF_POST_ADD_MILK_NULLITEM = "FF_POST_ADD_MILK_NULLITEM", -- Passes: player, nullItemID
	FF_POST_TOTEM_LAUNCH = "FF_POST_TOTEM_LAUNCH", -- Passes: player, playerData
	FF_PRE_PLAYER_TOUCH_TOTEM_LEVER = "FF_PRE_PLAYER_TOUCH_TOTEM_LEVER",
	FF_APPLY_STEVEN_HEART_TEAR_EFFECT = "FF_APPLY_STEVEN_HEART_TEAR_EFFECT", -- Passes: EntityTear: tear, EntityPlayer: player, CHAPIHealthKey: key; Option argument: CHAPIHealthKey
	PRE_CRIT_BOOST_DMG = "PRE_CRIT_BOOST_DMG",
	FF_GET_C_SECTION_TEAR_COSTUME = "FF_GET_C_SECTION_TEAR_COSTUME",
	FF_PRE_SALOON_GENERATE = "FF_PRE_SALOON_GENERATE", --Return false to block saloons, return true to try and force saloons (which might admittedly fail anyway)
	TLAZARUS_SWITCH_FORM = "FF_TLAZARUS_SWITCH_FORM", -- Passes: EntityPlayer: originalForm, EntityPlayer: newForm
	ESAU_JR_SWITCH_FORM = "FF_ESAU_JR_SWITCH_FORM", -- Passes: EntityPlayer: originalForm, EntityPlayer: newForm
	SWITCH_TOTEMS = "FF_SWITCH_TOTEMS", -- Passes: boolean: totemState; Optional argument: totemState

	-- Player callbacks that use PlayerType as their optional param instead of PlayerVariant
	-- FYI CallbackPriority is kinda useless on these atm
	FF_POST_PLAYER_INIT = "FF_POST_PLAYER_INIT",
	FF_PRE_PLAYER_UPDATE = "FF_PRE_PLAYER_UPDATE",
	FF_POST_PLAYER_UPDATE = "FF_POST_PLAYER_UPDATE",
	FF_PRE_PLAYER_RENDER = "FF_PRE_PLAYER_RENDER",
	FF_POST_PLAYER_RENDER = "FF_POST_PLAYER_RENDER",
	FF_PRE_PLAYER_COLLISION = "FF_PRE_PLAYER_COLLISION",
	FF_POST_PLAYER_COLLISION = "FF_POST_PLAYER_COLLISION",
	FF_PRE_PLAYER_TAKE_DMG = "FF_PRE_PLAYER_TAKE_DMG",
	FF_PRE_PLAYER_TRIGGER_ROOM_CLEAR = "FF_PRE_PLAYER_TRIGGER_ROOM_CLEAR",
	FF_POST_PLAYER_TRIGGER_ROOM_CLEAR = "FF_POST_PLAYER_TRIGGER_ROOM_CLEAR",
	FF_PRE_PLAYER_USE_BOMB = "FF_PRE_PLAYER_USE_BOMB",
	FF_POST_PLAYER_USE_BOMB = "FF_POST_PLAYER_USE_BOMB",
	FF_PRE_PLAYER_GRID_COLLISION = "FF_PRE_PLAYER_GRID_COLLISION",
	FF_PLAYER_GRID_COLLISION = "FF_PLAYER_GRID_COLLISION",

	--Friend
	POST_GUN_INIT = "POST_GUN_INIT",
	PRE_GUN_UPDATE = "PRE_GUN_UPDATE",
	POST_GUN_UPDATE = "POST_GUN_UPDATE",
	PRE_GUN_FIRE = "PRE_GUN_FIRE",
	POST_GUN_FIRE = "POST_GUN_FIRE",
	POST_GUN_NEW_ROOM = "POST_GUN_NEW_ROOM",
	GUN_HOLD_RELEASE = "GUN_HOLD_RELEASE",
	PRE_GUN_START_RELOAD = "PRE_GUN_START_RELOAD",
	GUN_PRE_RELOAD_SHOT = "GUN_PRE_RELOAD_SHOT",
	GUN_RELOAD_SHOT = "GUN_RELOAD_SHOT",
	POST_GUN_FINISHED_RELOAD = "POST_GUN_FINISHED_RELOAD",
	PRE_GUN_FIRE_SOUND = "PRE_GUN_FIRE_SOUND",
	POST_GUN_FIRE_TEAR = "POST_GUN_FIRE_TEAR",
	POST_GUN_FIRE_LASER = "POST_GUN_FIRE_LASER",
	PRE_GUN_APPLY_SHOT_EFFECT = "PRE_GUN_APPLY_SHOT_EFFECT",
	PRE_GUN_FIRE_CONSUME_AMMO = "PRE_GUN_FIRE_CONSUME_AMMO",
	PRE_FETAL_FRIEND_FIRE_CONSUME_AMMO = "PRE_FETAL_FRIEND_FIRE_CONSUME_AMMO",
	PRE_GUN_FIRE_LATE = "PRE_GUN_FIRE_LATE",
	MUZZLE_FLASH = "MUZZLE_FLASH",
	PRE_GUN_REPLACE = "PRE_GUN_REPLACE",
	POST_GUN_REPLACE = "POST_GUN_REPLACE",
	POST_PRIMARY_GUN_FIRE = "POST_PRIMARY_GUN_FIRE",
	FF_PRE_TURN_TEAR_TO_FRIEND_BULLET = "FF_PRE_TURN_TEAR_TO_FRIEND_BULLET",
	POST_GUN_RELOAD = "POST_GUN_RELOAD",
	GUN_START_DISAPPEARING = "GUN_START_DISAPPEARING",
	GUN_DISABLE_FOR_BACKUP_WEAPON = "GUN_DISABLE_FOR_BACKUP_WEAPON",

	-- Inaba (sshhhhhhh)
	SATELLITE_PRE_FIRE = "SATELLITE_PRE_FIRE",
	SATELLITE_EVALUATE_CAN_SHOOT = "SATELLITE_EVALUATE_CAN_SHOOT",
	SATELLITE_POST_FIRE_TEAR = "SATELLITE_POST_FIRE_TEAR",

	--Charge circles
	FF_CHARGE_CIRCLE_CHARGED = "FF_CHARGE_CIRCLE_CHARGED",
	FF_TRINKET_CIRCLE_CHARGED = "FF_TRINKET_CIRCLE_CHARGED",
	FF_EXTRA_CIRCLE_CHARGED = "FF_EXTRA_CIRCLE_CHARGED",
	FF_CHARGE_CIRCLE_RELEASED = "FF_CHARGE_CIRCLE_RELEASED",
	FF_TRINKET_CHARGE_CIRCLE_RELEASED = "FF_TRINKET_CHARGE_CIRCLE_RELEASED",
	FF_EXTRA_CHARGE_CIRCLE_RELEASED = "FF_EXTRA_CHARGE_CIRCLE_RELEASED",
	FF_CHARGE_CIRCLE_FIRED = "FF_CHARGE_CIRCLE_FIRED",
	FF_TRINKET_CHARGE_CIRCLE_FIRED = "FF_TRINKET_CHARGE_CIRCLE_FIRED",
	FF_EXTRA_CHARGE_CIRCLE_FIRED = "FF_EXTRA_CHARGE_CIRCLE_FIRED",

	--Erfly's, they're MINE
	--FF_ERFLY_POST_PLAYER_UPDATE = "FF_ERFLY_POST_PLAYER_UPDATE",
	FF_ERFLY_POST_PLAYER_RENDER = "FF_ERFLY_POST_PLAYER_RENDER",
	--FF_ERFLY_PEFFECT_UPDATE = "FF_ERFLY_PEFFECT_UPDATE",
	FF_ERFLY_PLAYER_ON_HIT_HURT = "FF_ERFLY_PLAYER_ON_HIT_HURT",
	FF_ERFLY_PLAYER_ON_HIT_HURT_LATE = "FF_ERFLY_PLAYER_ON_HIT_HURT_LATE",
	FF_ERFLY_PRE_PLAYER_COLL = "FF_ERFLY_PRE_PLAYER_COLL",
	FF_ERFLY_PLAYER_INIT = "FF_ERFLY_PLAYER_INIT",
	FF_ERFLY_ON_DOUBLE_TAP = "FF_ERFLY_ON_DOUBLE_TAP",

	FF_ERFLY_POST_FIRE_TEAR = "FF_ERFLY_POST_FIRE_TEAR",
	FF_ERFLY_POST_FIRE_BOMB = "FF_ERFLY_POST_FIRE_BOMB",
	FF_ERFLY_PRE_FIRE_LASER = "FF_ERFLY_PRE_FIRE_LASER",
	FF_ERFLY_POST_FIRE_LASER = "FF_ERFLY_POST_FIRE_LASER",
	FF_ERFLY_ON_FIRE_ROCKET = "FF_ERFLY_ON_FIRE_ROCKET",
	FF_ERFLY_ON_FIRE_AQUARIUS = "FF_ERFLY_ON_FIRE_AQUARIUS",
	FF_ERFLY_ON_DARK_ARTS_DAMAGE = "FF_ERFLY_ON_DARK_ARTS_DAMAGE",

	FF_ERFLY_PRE_PLAYER_NEW_ROOM = "FF_ERFLY_PRE_PLAYER_NEW_ROOM",
	FF_ERFLY_PLAYER_NEW_ROOM = "FF_ERFLY_PLAYER_NEW_ROOM",
	FF_ERFLY_POST_PLAYER_NEW_ROOM = "FF_ERFLY_POST_PLAYER_NEW_ROOM",
	FF_ERFLY_PRE_SPAWN_AWARD_FAMILIARS = "FF_ERFLY_PRE_SPAWN_AWARD_FAMILIARS",
	FF_ERFLY_PRE_SPAWN_AWARD_EXTRAS = "FF_ERFLY_PRE_SPAWN_AWARD_EXTRAS",
	FF_ERFLY_POST_START_GREED_WAVE = "FF_ERFLY_POST_START_GREED_WAVE",
}

function FiendFolio.RunAdditiveCallback(callbackID, optionalArgument, additiveValue, ...)
	local callbacks = Isaac.GetCallbacks(callbackID)
	local matchFunc = getmetatable(callbacks).__matchParams

	for _, callback in pairs(callbacks) do
		if matchFunc(optionalArgument, callback.Param) then
			additiveValue = callback.Function(callback.Mod, additiveValue, ...) or additiveValue
		end
	end

	return additiveValue
end