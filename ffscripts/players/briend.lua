local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local config = Isaac.GetItemConfig()

-- set to true to transfer all items to deagle
local briendDebugMode = false

CustomHealthAPI.PersistentData.RenderTwinBelowMain[mod.PLAYER.BRIEND] = true
CustomHealthAPI.PersistentData.RenderTwinBelowMainThroughUnknown[mod.PLAYER.BRIEND] = true
CustomHealthAPI.PersistentData.TwinRenderOffset[mod.PLAYER.BRIEND] = Vector(CustomHealthAPI.Constants.HEART_PIXEL_WIDTH_DEFAULT / 2, 0)
CustomHealthAPI.PersistentData.CombineLivesOfTwins[mod.PLAYER.BRIEND] = true

-- CustomTag that identifies than an item/effect should be shared between both Briends
mod.BriendSharedTag = "briendshared"

-- Innate item group for sharing effects between briends. Used for both sharing actual items and sharing innates from groups. Persists on save & continue.
mod.BriendSharedInnateGroup = "FF_BRIEND_SHARED"
-- Innate item group used to sync innate items that are not in a "group" (and therefore do not persist on save+continue normally).
mod.BriendSharedLooseInnateGroup = "FF_BRIEND_SHARED_GROUPLESS"
-- Innate item group used for sharing wisp effects. Kept separate to easily refresh the entire group.
mod.BriendSharedWispInnateGroup = "FF_BRIEND_SHARED_WISPS"

mod.BriendBalancing = {
	-- Stats
	RevolverTearsAdd = 1,
	RevolverDamageMult = 0.8,
	RevolverDamageFlat = -0.25,
	RevolverLuckFlat = 2,

	DeagleTearsMult = 0.7,
	DeagleDamageMult = 1.5,
	DeagleDamageFlat = -0.2,
	DeagleHealthAdd = -2,

    -- Pocket active
	ActiveCharge = 100, -- Needed charge for her pocket active
	ChargeRatio = 65,
	BoostDuration = math.floor(30 * 3.5), -- Game ticks
	TearsBoost = 7,
	SoulHeartChance = 1/6,

	GritHurtRadius = 20,
	FireJetDamageMult = 2.5,
	FireJetDamageFlat = 5,
	BurnTime = 60,

	BlockTearsTime = 20,
	GritBlockRadius = 40,
	GritRadiusPerOneRange = 0.2,
	GritRangeFlat = 20,
	MinGritRange = 30,
	MaxGritRange = 20 * 6,
	GritRangeCarBatteryBonus = 15,

	-- Gun graphics
	AngleInwards = 3, -- How far inward do the guns aim when aiming up or down?
	HandHoriOffsetMult = 2,
	HandOffset = Vector(0, 40),
	PrimaryHeldOffset = -16,
	SecondaryHeldOffset = 16,
	GunSwitchSpeed = 0.5, -- lerp speed

	-- Misc graphics
	HoldGunAboveHeadRadius = 40 * 3,
	HoldGunAboveHeadOffset = Vector(0, 43),
	HoldGunAboveHeadBirthcakeOffset = Vector(-12, 0),
	HoldGunAboveHeadLerp = 0.5,
	HoldGunAboveHeadDelay = 5,
}

-- Mod devs: You don't need to find a way to add to this!
-- Use a CustomTag called "briendshared" to have both Briends have the item
-- Example in your items.xml:
-- <passive id="1" name="Cool item!!" customtags="briendshared" />
local BriendVanillaSharedItems = {
	CollectibleType.COLLECTIBLE_BATTERY,
	CollectibleType.COLLECTIBLE_SPELUNKER_HAT,
	CollectibleType.COLLECTIBLE_9_VOLT,
	CollectibleType.COLLECTIBLE_BOBBY_BOMB,
	CollectibleType.COLLECTIBLE_MOMS_PURSE,
	CollectibleType.COLLECTIBLE_BOBS_CURSE,
	CollectibleType.COLLECTIBLE_HABIT,
	CollectibleType.COLLECTIBLE_BUTT_BOMBS,
	CollectibleType.COLLECTIBLE_SAD_BOMBS,
	CollectibleType.COLLECTIBLE_PYROMANIAC,
	CollectibleType.COLLECTIBLE_INFAMY,
	CollectibleType.COLLECTIBLE_BFFS,
	CollectibleType.COLLECTIBLE_HIVE_MIND,
	CollectibleType.COLLECTIBLE_STARTER_DECK,
	CollectibleType.COLLECTIBLE_LITTLE_BAGGY,
	CollectibleType.COLLECTIBLE_HOT_BOMBS,
	CollectibleType.COLLECTIBLE_MISSING_PAGE_2,
	CollectibleType.COLLECTIBLE_ARIES,
	CollectibleType.COLLECTIBLE_CANCER,
	CollectibleType.COLLECTIBLE_BOMBER_BOY,
	CollectibleType.COLLECTIBLE_CAR_BATTERY,
	CollectibleType.COLLECTIBLE_SCATTER_BOMBS,
	CollectibleType.COLLECTIBLE_STICKY_BOMBS,
	CollectibleType.COLLECTIBLE_HOST_HAT,
	CollectibleType.COLLECTIBLE_GLITTER_BOMBS,
	CollectibleType.COLLECTIBLE_METAL_PLATE,
	CollectibleType.COLLECTIBLE_POLYDACTYLY,
	CollectibleType.COLLECTIBLE_CONE_HEAD,
	CollectibleType.COLLECTIBLE_CAMO_UNDIES,
	CollectibleType.COLLECTIBLE_FAST_BOMBS,
	CollectibleType.COLLECTIBLE_SCHOOLBAG,
	CollectibleType.COLLECTIBLE_NANCY_BOMBS,
	CollectibleType.COLLECTIBLE_ROCKET_IN_A_JAR,
	CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES,
	CollectibleType.COLLECTIBLE_MARS,
	CollectibleType.COLLECTIBLE_BLOOD_BOMBS,
	CollectibleType.COLLECTIBLE_BRIMSTONE_BOMBS,
	CollectibleType.COLLECTIBLE_4_5_VOLT,
	CollectibleType.COLLECTIBLE_FALSE_PHD,
	CollectibleType.COLLECTIBLE_SPIRIT_SHACKLES,
	CollectibleType.COLLECTIBLE_JELLY_BELLY,
	CollectibleType.COLLECTIBLE_GHOST_BOMBS,
	CollectibleType.COLLECTIBLE_EVIL_CHARM,
}

local BriendVanillaBlacklistedItems = {
	CollectibleType.COLLECTIBLE_SHARP_PLUG,
	CollectibleType.COLLECTIBLE_GUILLOTINE,
	CollectibleType.COLLECTIBLE_SCISSORS,
	CollectibleType.COLLECTIBLE_BREATH_OF_LIFE,
	CollectibleType.COLLECTIBLE_DECAP_ATTACK,
}

-- Same as above smile
local BriendVanillaSharedTrinkets = {
	TrinketType.TRINKET_PULSE_WORM,
	TrinketType.TRINKET_WIGGLE_WORM,
	TrinketType.TRINKET_RING_WORM,
	TrinketType.TRINKET_FLAT_WORM,
	TrinketType.TRINKET_MONKEY_PAW,
	TrinketType.TRINKET_HOOK_WORM,
	TrinketType.TRINKET_WHIP_WORM,
	TrinketType.TRINKET_PINKY_EYE,
	TrinketType.TRINKET_PUSH_PIN,
	TrinketType.TRINKET_CURVED_HORN,
	--TrinketType.TRINKET_GOAT_HOOF, -- Speed is already synced
	TrinketType.TRINKET_CANCER,
	TrinketType.TRINKET_RED_PATCH,
	TrinketType.TRINKET_LUCKY_TOE,
	TrinketType.TRINKET_MAGGYS_FAITH,
	TrinketType.TRINKET_SAMSONS_LOCK,
	TrinketType.TRINKET_RAINBOW_WORM,
	TrinketType.TRINKET_TAPE_WORM,
	TrinketType.TRINKET_LAZY_WORM,
	TrinketType.TRINKET_BLISTER,
	TrinketType.TRINKET_BLACK_FEATHER,
	TrinketType.TRINKET_CRACKED_CROWN,
	TrinketType.TRINKET_FISH_TAIL,
	TrinketType.TRINKET_BLACK_TOOTH,
	TrinketType.TRINKET_OUROBOROS_WORM,
	TrinketType.TRINKET_NOSE_GOBLIN,
	TrinketType.TRINKET_SUPER_BALL,
	TrinketType.TRINKET_LOST_CORK,
	TrinketType.TRINKET_CROW_HEART,
	TrinketType.TRINKET_DUCT_TAPE,
	TrinketType.TRINKET_STEM_CELL,
	TrinketType.TRINKET_WOODEN_CROSS,
	TrinketType.TRINKET_JAW_BREAKER,
	TrinketType.TRINKET_CHEWED_PEN,
	TrinketType.TRINKET_TEARDROP_CHARM,
	TrinketType.TRINKET_APPLE_OF_SODOM,
	TrinketType.TRINKET_BRAIN_WORM,
	TrinketType.TRINKET_PERFECTION,
	TrinketType.TRINKET_MOTHERS_KISS,
	TrinketType.TRINKET_TORN_CARD,
	TrinketType.TRINKET_MODELING_CLAY,
	TrinketType.TRINKET_HOLLOW_HEART,
	TrinketType.TRINKET_KIDS_DRAWING,
	TrinketType.TRINKET_THE_TWINS,
}

local BriendVanillaBlacklistedTrinkets = {
	TrinketType.TRINKET_LIBERTY_CAP,
	TrinketType.TRINKET_UMBILICAL_CORD,
	TrinketType.TRINKET_VIBRANT_BULB,
	TrinketType.TRINKET_DIM_BULB,
	TrinketType.TRINKET_BROKEN_SYRINGE,
	TrinketType.TRINKET_MOMS_LOCK,
}

-- The effects of these items are completely blocked on the twin.
-- If the item is also shared, the main twin will still get the effect.
local BriendTwinBlockedCollectibles = {
	CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES,  -- Prevents the twin from obtaining the fake active item
}

-- Generally, null effects that are part of passive items or pocket items should sync
-- Costumes will automatically sync regardless of null effect, so don't include those
mod.BriendNullSyncWhitelist = {
	-- Vanilla
	--[NullItemID.ID_STATUE] = true, -- Not gnawed leaf? unknown so leaving this out for now
	[NullItemID.ID_WIZARD] = true, -- Wizard pill
	[NullItemID.ID_BLINDFOLD] = true, -- Blindfolded
	[NullItemID.ID_EMPTY_VESSEL] = true, -- Empty Vessel item
	--[NullItemID.ID_MEGABLAST] = true, -- Idk what this does, probably just the costume?
	[NullItemID.ID_BOOKWORM] = true, -- Bookworm transformation (active item only transformation, and active items affect both twins)
	[NullItemID.ID_HUGE_GROWTH] = true, -- Huge Growth card
	[NullItemID.ID_ERA_WALK] = true, -- Era Walk card
	--[NullItemID.ID_SPIN_TO_WIN] = true, -- Sync not needed
	[NullItemID.ID_TOOTH_AND_NAIL] = true, -- Tooth and nail invincibility
	[NullItemID.ID_REVERSE_EMPRESS] = true, -- Reverse Empress card
	[NullItemID.ID_REVERSE_CHARIOT] = true, -- Reverse Chariot card
	[NullItemID.ID_REVERSE_HANGED_MAN] = true, -- Reverse Hanged Man card
	[NullItemID.ID_REVERSE_SUN] = true, -- Reverse Sun card
	--[NullItemID.ID_REVERSE_DEVIL] = true, -- Reverse Devil card
	--[NullItemID.ID_REVERSE_CHARIOT_ALT] = true, -- Secret Edith easter egg costume?
	--[NullItemID.ID_WAVY_CAP_1] = true, -- Wavy cap costume?
	--[NullItemID.ID_WAVY_CAP_2] = true, -- Wavy cap costume?
	--[NullItemID.ID_WAVY_CAP_3] = true, -- Wavy cap costume?
	--[NullItemID.ID_LUNA] = true, -- Luna costume?
	--[NullItemID.ID_JUPITER_BODY] = true, -- Jupiter costume
	--[NullItemID.ID_JUPITER_BODY_ANGEL] = true, -- Special jupiter costume for angel wing
	--[NullItemID.ID_JUPITER_BODY_PONY] = true, -- Special jupiter costume for Pony item
	--[NullItemID.ID_JUPITER_BODY_WHITEPONY] = true, -- Special juptier costume for White Pony item
	[NullItemID.ID_ESAU_JR] = true, -- girl help
	[NullItemID.ID_SPIRIT_SHACKLES_SOUL] = true, -- Spirit Shackles something?
	[NullItemID.ID_SPIRIT_SHACKLES_DISABLED] = true, -- Spirit shackles something?
	--[NullItemID.ID_LOST_CURSE] = true, -- White fire (resets next room if given to both??)
	--[NullItemID.ID_LAZARUS_SOUL_REVIVE] = true, -- Soul of Lazarus revive
	[NullItemID.ID_SOUL_MAGDALENE] = true, -- Maggy soul heart drops
	--[NullItemID.ID_HEMOPTYSIS] = true, -- Sneeze costume probably idk
	--[NullItemID.ID_HEMOPTYSIS_BOOST] = true -- Unsure so disabling for now

	-- FF
	[mod.ITEM.NULL.CURSED_PENNY_ALL_STATS] = true, -- Cursed Penny rare all stats up (lucky penny applies to both so this should too)

	-- Milk Machine
	[mod.ITEM.NULL.MILK_TEARS_UP] = true,
	[mod.ITEM.NULL.MILK_TEARS_DOWN] = true,
	[mod.ITEM.NULL.MILK_TEARS_UP_MULT] = true,
	[mod.ITEM.NULL.MILK_TEARS_DOWN_MULT] = true,
	[mod.ITEM.NULL.MILK_DAMAGE_UP] = true,
	[mod.ITEM.NULL.MILK_DAMAGE_DOWN] = true,
	[mod.ITEM.NULL.MILK_DAMAGE_UP_MULT] = true,
	[mod.ITEM.NULL.MILK_DAMAGE_DOWN_MULT] = true,
	[mod.ITEM.NULL.MILK_SPEED_UP] = false,  -- MoveSpeed is synced separately
	[mod.ITEM.NULL.MILK_SPEED_DOWN] = false,
	[mod.ITEM.NULL.MILK_SPEED_UP_MULT] = false,
	[mod.ITEM.NULL.MILK_SPEED_DOWN_MULT] = false,
	[mod.ITEM.NULL.MILK_RANGE_UP] = true,
	[mod.ITEM.NULL.MILK_RANGE_DOWN] = true,
	[mod.ITEM.NULL.MILK_RANGE_UP_MULT] = true,
	[mod.ITEM.NULL.MILK_RANGE_DOWN_MULT] = true,
	[mod.ITEM.NULL.MILK_SHOTSPEED_UP] = true,
	[mod.ITEM.NULL.MILK_SHOTSPEED_DOWN] = true,
	[mod.ITEM.NULL.MILK_SHOTSPEED_UP_MULT] = true,
	[mod.ITEM.NULL.MILK_SHOTSPEED_DOWN_MULT] = true,
	[mod.ITEM.NULL.MILK_LUCK_UP] = true,
	[mod.ITEM.NULL.MILK_LUCK_DOWN] = true,
	[mod.ITEM.NULL.MILK_LUCK_UP_MULT] = true,
	[mod.ITEM.NULL.MILK_LUCK_DOWN_MULT] = true,
}


-- Prevents these collectible effects from being synced between Briends
-- Shouldn't need to be used often but I didn't want to hardcode it
mod.BriendActiveSyncBlacklist = {
	[CollectibleType.COLLECTIBLE_NOTCHED_AXE] = true,
	[CollectibleType.COLLECTIBLE_SCISSORS] = true, -- Buggy and weird
	[CollectibleType.COLLECTIBLE_BROWN_NUGGET] = true, -- Spawns 2 because the collectible effect is used to spawn the familiar
	[CollectibleType.COLLECTIBLE_SCOOPER] = true,
	[CollectibleType.COLLECTIBLE_URN_OF_SOULS] = true,
	[CollectibleType.COLLECTIBLE_ANARCHIST_COOKBOOK] = true,
	[mod.ITEM.COLLECTIBLE.TOYBOX] = true, -- Trinket smelting is already synced and this uses the collectible effect for tracking if it should do that
}


-- Some actives want to be used as the active gun instead of defaulting to the main Briend player
-- Typically only used for health-affecting stuff
mod.BriendActiveOnSelectedGunWhitelist = {
	[CollectibleType.COLLECTIBLE_KAMIKAZE] = true,
	[CollectibleType.COLLECTIBLE_YUM_HEART] = true,
	[CollectibleType.COLLECTIBLE_BOOK_OF_REVELATIONS] = true,
	[CollectibleType.COLLECTIBLE_THE_NAIL] = true,
	[CollectibleType.COLLECTIBLE_RAZOR_BLADE] = true,
	[CollectibleType.COLLECTIBLE_GUPPYS_PAW] = true,
	[CollectibleType.COLLECTIBLE_IV_BAG] = true,
	[CollectibleType.COLLECTIBLE_PRAYER_CARD] = true,
	[CollectibleType.COLLECTIBLE_BLOOD_RIGHTS] = true,
	[CollectibleType.COLLECTIBLE_SATANIC_BIBLE] = true,
	[CollectibleType.COLLECTIBLE_CONVERTER] = true,
	[CollectibleType.COLLECTIBLE_D8] = true,
	[CollectibleType.COLLECTIBLE_POTATO_PEELER] = true,
	[CollectibleType.COLLECTIBLE_YUCK_HEART] = true,
	[CollectibleType.COLLECTIBLE_MAGIC_SKIN] = true,
	[CollectibleType.COLLECTIBLE_SUMPTORIUM] = true,
	[mod.ITEM.COLLECTIBLE.PURPLE_PUTTY] = true,
	[mod.ITEM.COLLECTIBLE.FIEND_MIX] = true,
	[mod.ITEM.COLLECTIBLE.YICK_HEART] = true,
	[mod.ITEM.COLLECTIBLE.TORTURE_COOKIE] = true,
	[mod.ITEM.COLLECTIBLE.BOOK_OF_LEVIATHAN] = true,
	[mod.ITEM.COLLECTIBLE.YCUK_HEART] = true,
}


mod.BriendActiveOnBothGunsWhitelist = {
	[ CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS ] = true,
	[ CollectibleType.COLLECTIBLE_SACRIFICIAL_ALTAR ] = true,
	[ CollectibleType.COLLECTIBLE_SULFUR ] = true,
	[ mod.ITEM.COLLECTIBLE.ACTIVATED_CHARCOAL ] = true,
}


-- When syncing MoveSpeed with Briend's twin, this helps to avoid doubling the speed gained by shared effects.
-- Only VANILLA stuff needs to be included manually in this table, rgon xml stats are found automatically.
local BriendSharedSpeedUps = {
	[ItemType.ITEM_NULL] = {
		[true] = {  -- Can stack
			[NullItemID.ID_WAVY_CAP_1] = -0.06,
		},
		[false] = {
			[NullItemID.ID_ERA_WALK] = 0.5,
			[NullItemID.ID_SPIN_TO_WIN] = 0.5,
			[NullItemID.ID_REVERSE_EMPRESS] = -0.1,
			[NullItemID.ID_REVERSE_HANGED_MAN] = -0.1,
		},
	},
	[ItemType.ITEM_ACTIVE] = {
		[true] = {  -- Can stack
			[CollectibleType.COLLECTIBLE_BERSERK] = 0.4,
			[CollectibleType.COLLECTIBLE_WAVY_CAP] = -0.03,
		},
		[false] = {
			[CollectibleType.COLLECTIBLE_MY_LITTLE_UNICORN] = 0.28,
			[CollectibleType.COLLECTIBLE_UNICORN_STUMP] = 0.28,
			[CollectibleType.COLLECTIBLE_THE_NAIL] = -0.18,
			[CollectibleType.COLLECTIBLE_DARK_ARTS] = 1.0,
		},
	},
	[ItemType.ITEM_PASSIVE] = {
		[true] = {  -- Can stack
		},
		[false] = {
			[CollectibleType.COLLECTIBLE_WHORE_OF_BABYLON] = 0.3,
			[CollectibleType.COLLECTIBLE_CAMO_UNDIES] = 0.5,
		},
	},
}

-- Uses these pills on the other Briend when used on one
mod.BriendPillSyncWhitelist = {
	[PillEffect.PILLEFFECT_TEARS_UP] = true,
	[PillEffect.PILLEFFECT_TEARS_DOWN] = true,

	[PillEffect.PILLEFFECT_LUCK_UP] = true,
	[PillEffect.PILLEFFECT_LUCK_DOWN] = true,

	[PillEffect.PILLEFFECT_RANGE_UP] = true,
	[PillEffect.PILLEFFECT_RANGE_DOWN] = true,

	--[PillEffect.PILLEFFECT_SPEED_UP] = true,
	--[PillEffect.PILLEFFECT_SPEED_DOWN] = true,

	[PillEffect.PILLEFFECT_SHOT_SPEED_UP] = true,
	[PillEffect.PILLEFFECT_SHOT_SPEED_DOWN] = true,

	[PillEffect.PILLEFFECT_EXPERIMENTAL] = true,

	[mod.ITEM.PILL.CYANIDE] = true,
}

-- Uses these cards on the other Briend when used on one
mod.BriendCardSyncWhitelist = {
	[Card.CARD_EMPRESS] = true,
	[Card.CARD_SOUL_LOST] = true,
}

-- Passes these card effects to the selected Briend when used
mod.BriendCardPassWhitelist = {
	[Card.CARD_STRENGTH] = true,
	[Card.CARD_HEARTS_2] = true,
	[Card.CARD_HOLY] = true,
	[Card.CARD_REVERSE_FOOL] = true,
	[Card.CARD_REVERSE_EMPRESS] = true,
	[Card.CARD_REVERSE_SUN] = true,
	[Card.CARD_REVERSE_LOVERS] = true,
	[Card.RUNE_BLACK] = true,
}

local function UpdateSharedSpeedTable()
	for id=1, config:GetNullItems().Size-1 do
		local item = config:GetNullItem(id)
		if item and mod.BriendNullSyncWhitelist[id] then
			local xmlData = XMLData.GetEntryById(XMLNode.NULLITEM, id)
			local speed = xmlData and (tonumber(xmlData.effectspeed) or tonumber(xmlData.speed))
			if speed then
				BriendSharedSpeedUps[ItemType.ITEM_NULL][true][id] = speed
			end
		end
	end
	for id=1, config:GetCollectibles().Size-1 do
		local item = config:GetCollectible(id)
		if item and item.Type == ItemType.ITEM_ACTIVE and not mod.BriendActiveSyncBlacklist[id] then
			local xmlData = XMLData.GetEntryById(XMLNode.ITEM, id)
			local speed = xmlData and tonumber(xmlData.effectspeed)
			if speed then
				BriendSharedSpeedUps[ItemType.ITEM_ACTIVE][true][id] = speed
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, function() UpdateSharedSpeedTable() end)
if Isaac.IsInGame() then UpdateSharedSpeedTable() end  -- luamod

-- Returns the speed that could be doubled due to Briend's shared null/active effects. Used to correct that.
local function GetBriendSharedSpeed(player)
	local totalSpeed = 0

	local effects = player:GetEffects()
	for itemType, tab in pairs(BriendSharedSpeedUps) do
		for canStack, items in pairs(tab) do
			for id, speed in pairs(items) do
				if itemType == ItemType.ITEM_NULL then
					if not mod.BriendNullSyncWhitelist[id] then
						items[id] = nil
					elseif canStack then
						totalSpeed = totalSpeed + speed * effects:GetNullEffectNum(id)
					elseif effects:HasNullEffect(id) then
						totalSpeed = totalSpeed + speed
					end
				elseif mod.BriendActiveSyncBlacklist[id] then
					items[id] = nil
				elseif canStack then
					totalSpeed = totalSpeed + speed * effects:GetCollectibleEffectNum(id)
				elseif effects:HasCollectibleEffect(id) then
					totalSpeed = totalSpeed + speed
				end
			end
		end
	end

	return totalSpeed
end

-- it's real.

function mod:IsAnyFriend(player)
	return player:GetPlayerType() == mod.PLAYER.FRIEND or player:GetPlayerType() == mod.PLAYER.BRIEND
end

for _, id in ipairs(BriendVanillaSharedItems) do
	local collectible = config:GetCollectible(id)
	collectible:AddCustomTag(mod.BriendSharedTag)
end
for _, id in ipairs(BriendVanillaSharedTrinkets) do
	local collectible = config:GetTrinket(id)
	collectible:AddCustomTag(mod.BriendSharedTag)
end


mod:AddCallback(CustomHealthAPI.Enums.Callbacks.PRE_CHECK_SWAP_TWIN_RENDERING, function(_, player)
    mod:TrySwapBriendDataOnEsauJr(player)
end, FiendFolio.PLAYER.BRIEND)

mod:AddCallback(CustomHealthAPI.Enums.Callbacks.PRE_HEALTH_RENDER, function(_, player, playerSlot, healthIndex, info)
    local isBriendDeselected = not mod:IsSelectedBriend(player)
	return mod:PreRenderFriendHeart(player, isBriendDeselected, baseOffset, playerSlot, healthIndex, info)
end, FiendFolio.PLAYER.BRIEND)

mod:AddCallback(CustomHealthAPI.Enums.Callbacks.PRE_RENDER_HP_BAR, function(_, player, slot, offset)
    if mod:IsSelectedBriend(player) then
        return {
            Offset = offset + Vector(CustomHealthAPI.Constants.HEART_PIXEL_WIDTH_DEFAULT + 3, 0)
        }
    end
end, FiendFolio.PLAYER.BRIEND)

mod:AddCallback(CustomHealthAPI.Enums.Callbacks.PRE_RENDER_UNKNOWN_CURSE, function(_, player, slot, renderInfo)
    local isBriendDeselected = not mod:IsSelectedBriend(player)
	local color = renderInfo.Color
	if isBriendDeselected then
		color = Color.Lerp(renderInfo.Color, renderInfo.Color, 0)
		color.A = 0.3
	end
    return {
        Offset = renderInfo.RenderOffset + Vector(CustomHealthAPI.Constants.HEART_PIXEL_WIDTH_DEFAULT + 4, 0),
		Color = color
    }
end, FiendFolio.PLAYER.BRIEND)

function mod:RenderBriendGunIcons(player, slot, offset, totalHealthRendered, isUnknownCurse)
    local anim = (mod:IsBriendTwin(player) and "Deagle") or "Revolver"
	local primaryBriend = mod:IsPrimaryGunRevolver(player)
	local color = Color()

	if not primaryBriend and mod:IsBriendTwin(player) then
		anim = anim .. "Selected"
	elseif primaryBriend and not mod:IsBriendTwin(player) then
		anim = anim .. "Selected"
	else
		color = Color(1,1,1,0.5)
	end
	mod.ExtraHealthIconSprite:Play(anim, true)
	mod.ExtraHealthIconSprite.Color = color
    CustomHealthAPI.Helper.RenderHealth(mod.ExtraHealthIconSprite,
	                                    player, slot, 0,
	                                    offset - Vector(CustomHealthAPI.Constants.HEART_PIXEL_WIDTH_DEFAULT + ((isUnknownCurse and 3) or 2), 0),
	                                    totalHealthRendered)
end
mod:AddCallback(CustomHealthAPI.Enums.Callbacks.POST_RENDER_HP_BAR, mod.RenderBriendGunIcons, FiendFolio.PLAYER.BRIEND)
mod:AddCallback(CustomHealthAPI.Enums.Callbacks.POST_RENDER_UNKNOWN_CURSE, function(_, player, slot, renderInfo)
	mod:RenderBriendGunIcons(player, slot, renderInfo.RenderOffset, 1, true)
end, FiendFolio.PLAYER.BRIEND)

mod:AddPriorityCallback(CustomHealthAPI.Enums.Callbacks.SHOULD_DANGER_FLASH, CallbackPriority.EARLY, function(_, healthDefinition, hasRedHealth, redKey, player)
	if not mod:IsSelectedBriend(player) then
		return false
	end
end, FiendFolio.PLAYER.BRIEND)

mod:AddCallback("FF_PLAYER_HURT_SOUND", function()
    sfx:Play(mod.Sounds.FriendHurt, 0.8, 0, false, 0.9)
    return true
end, mod.PLAYER.BRIEND)

mod:AddCallback("FF_PLAYER_DEATH_SOUND", function(_, player)
	if mod:IsBriendTwin(player) then
		return true
	end

    sfx:Play(mod.Sounds.FriendDies, 0.8, 0, false, 0.9)
    return true
end, mod.PLAYER.BRIEND)

mod:AddPriorityCallback(ModCallbacks.MC_PLAYER_GET_HEART_LIMIT, CallbackPriority.IMPORTANT, function (_, player, limit, ignoreModifiers)
	if ignoreModifiers then
		return 12
	else
		local brokenHearts = player:GetBrokenHearts()
		return (6 - brokenHearts) * 2
	end
end, FiendFolio.PLAYER.BRIEND)


--------------------------------------------------------------------------------------------------------------------

-- Is this the Briend which is visible, or the invisible one that has the Deagle?
function mod:IsBriendTwin(player)
	local mainTwin = player:GetMainTwin()
	if mainTwin and mainTwin:GetPlayerIndex() ~= player:GetPlayerIndex() then
		if player:GetPlayerType() == FiendFolio.PLAYER.BRIEND then
			return true
		end
	end

	return false
end

function mod:IsBriendMain(player)
	return player:GetPlayerType() == mod.PLAYER.BRIEND and not mod:IsBriendTwin(player)
end

-- Copy all Briend info between the main briend and esau jr upon swapping
-- Use this whenever you want to reference Briend's data table
function mod:TrySwapBriendDataOnEsauJr(player)
	if player and player:GetPlayerType() == FiendFolio.PLAYER.BRIEND then
		local data = mod:GetEntityData(player)
		if not data.Briend then
			local esaudPlayer
			local playerIndex = player:GetPlayerIndex()
			if playerIndex == -1 then
				-- nightmare nightmare nightmare
				local numPlayers = game:GetNumPlayers()
				local i = 0
				repeat
					esaudPlayer = PlayerManager.GetEsauJrState(i)
					if esaudPlayer and esaudPlayer.Index == player.Index then goto afterGettingEsauJrForBriend end
					i = i + 1
				until (i >= numPlayers)
				return
			else
				esaudPlayer = PlayerManager.GetEsauJrState(player:GetPlayerIndex())
			end
			::afterGettingEsauJrForBriend::
			if esaudPlayer then
				local esaudData = mod:GetEntityData(esaudPlayer)
				if esaudData.Briend then
					data.Briend = esaudData.Briend
					esaudData.Briend = nil

					data.BriendGritBoost = esaudData.BriendGritBoost
					esaudData.BriendGritBoost = nil

					local odata = CustomHealthAPI.Helper.GetOtherData(player)
					odata.SwapTwinBelowMainRendering = not mod:IsPrimaryGunRevolver(player)
				end
			end
		end
	end
end

-- Transfer player bleed to selected briend
function mod:HandleBriendPlayerBleed(player)
	if not mod:IsSelectedBriend(player) then
		local twin = player:GetOtherTwin()
		if twin then
			if player:HasEntityFlags(EntityFlag.FLAG_BLEED_OUT) then
				local bleedCountdown = player:GetBleedingCountdown()
				player:SetBleedingCountdown(0)
				player:ClearEntityFlags(EntityFlag.FLAG_BLEED_OUT)
				twin:AddEntityFlags(EntityFlag.FLAG_BLEED_OUT)
				twin:SetBleedingCountdown(bleedCountdown)
			end

			local data = CustomHealthAPI.Helper.GetSavedata(player)
			if data.ShardBleedTimer ~= nil then
				local twindata = CustomHealthAPI.Helper.GetSavedata(twin)
				twindata.ShardBleedTimer = data.ShardBleedTimer
				data.ShardBleedTimer = nil
			end
		end
	end
end

-- Is Briend holding a gun above their head to signify which gun is getting the item?
function mod:IsBriendHoldingGunAboveHead(player)
	local twin = player:GetOtherTwin()
	mod:TrySwapBriendDataOnEsauJr(player)
	mod:TrySwapBriendDataOnEsauJr(twin)
	local data = mod:GetEntityData(player)
	local twinData = mod:GetEntityData(twin)
	return (data.Briend and data.Briend.HoldingGunAboveHead) or (twinData.Briend and twinData.Briend.HoldingGunAboveHead)
end

-- Checks which gun should be primary
-- true = primary gun is revolver
-- false = primary gun is deagle
function mod:IsPrimaryGunRevolver(player)
	local primaryBriend = player:GetMainTwin()
	mod:TrySwapBriendDataOnEsauJr(primaryBriend)
	local data = mod:GetEntityData(primaryBriend)

	return data.Briend and data.Briend.IsPrimaryGunRevolver
end

-- return true if this is the briend with the active health bar
function mod:IsSelectedBriend(player)
	local isTwin = mod:IsBriendTwin(player)
	local isPrimary = mod:IsPrimaryGunRevolver(player)
	return isTwin == nil or isPrimary == nil or isTwin ~= isPrimary
end

-- Grabs the primary Briend from the player object, then swaps them
function mod:SwapPrimaryBriend(player)
	local primaryBriend = player:GetMainTwin()
	local twinBriend = primaryBriend:GetOtherTwin()
	mod:TrySwapBriendDataOnEsauJr(primaryBriend)
	mod:TrySwapBriendDataOnEsauJr(twinBriend)
	local data = mod:GetEntityData(primaryBriend)
	local tdata = mod:GetEntityData(twinBriend)

	data.Briend.IsPrimaryGunRevolver = not data.Briend.IsPrimaryGunRevolver

	local odata = CustomHealthAPI.Helper.GetOtherData(player)
	odata.SwapTwinBelowMainRendering = not odata.SwapTwinBelowMainRendering

	data.StevenHeartStartedShootingAtFrame = nil
	data.StevenHeartStoppedShootingAtFrame = nil
	data.CanDoStevenHeartShot = nil

	tdata.StevenHeartStartedShootingAtFrame = nil
	tdata.StevenHeartStoppedShootingAtFrame = nil
	tdata.CanDoStevenHeartShot = nil

	mod:HandleBriendPlayerBleed(primaryBriend)
	mod:HandleBriendPlayerBleed(twinBriend)
end

-- Gets the Briend twin from the player object is Briend, otherwise returns nil
---@return EntityPlayer
function mod:GetBriendTwin(player)
	if mod:IsBriendTwin(player) then
		return player
	elseif player:GetPlayerType() == mod.PLAYER.BRIEND then
		return player:GetOtherTwin()
	end
end

-- Adds the item to the passed twin's innate collectibles
function mod:AddSharedBriendPassive(player, id, amount)
	player:AddInnateCollectible(id, amount or 1, mod.BriendSharedInnateGroup)
end

-- Remove the item from the passed twin's innate collectibles
function mod:RemoveSharedBriendPassive(player, id, amount)
	player:RemoveInnateCollectible(id, amount or 1, mod.BriendSharedInnateGroup)
end

---@param parent EntityPlayer
function mod:SpawnHiddenFriend(parent)
	local player = parent:InitTwin(mod.PLAYER.BRIEND)

	player.Visible = false
	player.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
	player.Position = parent.Position

	player:InitPostLevelInitStats()

	return player
end

function mod:GetMaxGritDistance(player)
	local rangeAverage = player.TearRange

	if player:GetPlayerType() == mod.PLAYER.BRIEND then
		local otherTwin = player:GetOtherTwin()
		if otherTwin then
			rangeAverage = (player.TearRange + otherTwin.TearRange) / 2
		end
	end

	local maxDistance = (mod.BriendBalancing.GritRadiusPerOneRange * (rangeAverage/40) * 40) + mod.BriendBalancing.GritRangeFlat

	if player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
		maxDistance = maxDistance + mod.BriendBalancing.GritRangeCarBatteryBonus
	end

	return mod:ClampNumber(maxDistance, mod.BriendBalancing.MinGritRange, mod.BriendBalancing.MaxGritRange)
end

function mod:AddGritPoint(player, data, position)
	local maxDistance = mod:GetMaxGritDistance(player)
	data.GritBlockPoints = data.GritBlockPoints or {}
	table.insert(data.GritBlockPoints, {position, mod.BriendBalancing.BlockTearsTime})

	-- Do damage and burn in radius of point
	local damage = player.Damage * mod.BriendBalancing.FireJetDamageMult + mod.BriendBalancing.FireJetDamageFlat
	for _, ent in ipairs(Isaac.FindInRadius(position, maxDistance, EntityPartition.ENEMY)) do
		local npc = ent:ToNPC()
		if npc and npc:IsVulnerableEnemy() and npc:IsActiveEnemy() then
			npc:TakeDamage(damage, DamageFlag.DAMAGE_FIRE, EntityRef(player), 2)
			npc:AddBurn(EntityRef(player), mod.BriendBalancing.BurnTime, player.Damage)
		end
	end

	-- Also damage shopkeepers (they dont get picked up in the EntityPartition for some reason)
	-- Also +20 because
	for _, shopkeeper in ipairs(Isaac.FindByType(EntityType.ENTITY_SHOPKEEPER)) do
		if shopkeeper.Position:Distance(position) < maxDistance+30 then
			shopkeeper:Kill()
		end
	end

	-- Now do an immediate projectile check
	local hit = mod:DoGritBulletCheck(position, maxDistance)
	if hit then
		sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS, 0.5)
	end
end

function mod:DoGritBulletCheck(point, maxDistance)
	local hit = false
	for _, ent in ipairs(Isaac.FindInRadius(point, maxDistance, EntityPartition.BULLET)) do
		local proj = ent:ToProjectile()
		if proj and not proj:HasProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER) and not proj:IsDead() then
			proj:Die()

			-- Spawn fire jet to indicate we killed one
			local fireJet = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FIRE_JET, 1, proj.Position, Vector.Zero, player):ToEffect()
			fireJet.SpriteScale = Vector(0.8, 0.8)
			fireJet.CollisionDamage = 0
			fireJet.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

			hit = true
		end
	end

	return hit
end

function mod:doGunslingersGritFX(player)
	-- Spawn the grit wave effect
	local gritWave = Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.FF.GritWave.Var, mod.FF.GritWave.Sub, player.Position, Vector.Zero, player):ToEffect()

	-- Update spritesheet
	--local sprite = gritWave:GetSprite()
	--local blendMode = sprite:GetLayer(0):GetBlendMode()
	--blendMode:SetMode(BlendType.ADDITIVE)

	-- Set spritescale
	-- (resolution of image)/2 = 48
	local gritDistance = mod:GetMaxGritDistance(player)
	gritWave.SpriteScale = Vector.One * ((gritDistance / 48))

	-- Add embers particles
	for _ = 1, math.random(5, 10) do
		local vel = RandomVector():Resized(5)
		local ember = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.EMBER_PARTICLE, 0, player.Position, vel, player):ToEffect()
		ember.Color = Color(0.5,0.5,0.5,1.5, 0.2,0,0.4, 1,1,1,1)
		ember:SetTimeout(10)
		ember.SpriteScale = Vector.One * 1.0
	end

	--[[ Smoke
	for i = 1, math.random(3, 5) do
		local pos = RandomVector():Resized(math.random(10, gritDistance))
		local vel = pos:Resized(4)
		local dust = mod:SpawnDust(player.Position + pos, vel, 0.3, mod.ColorGritWavePurple, 30)
		dust.DepthOffset = -20
	end
	--]]

	gritWave:Update()
	sfx:Play(SoundEffect.SOUND_WAR_FLAME)
end

function mod:doGunslingersGritBoost(player)
	local data = mod:GetEntityData(player)
	data.BriendGritBoost = mod.BriendBalancing.BoostDuration
	player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_TEARCOLOR, true)
end

function mod:GritWaveUpdate(entity)
	local sprite = entity:GetSprite()
	if sprite:IsFinished() then
		entity:Remove()
	end
end

function mod:UseGunslingersGrit(item, rng, player, useflags, activeslot)
	if (useflags & UseFlag.USE_CARBATTERY) ~= 0 or mod:IsBriendTwin(player) then
		return {Discharge = false, Remove = false, ShowAnim = false}
	end

	-- Electrum...
	if player:HasTrinket(FiendFolio.ITEM.ROCK.ELECTRUM) then
		local trinketMulti = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.ELECTRUM)
		local laserDamage = trinketMulti * player.Damage
		FiendFolio:alternateElectrumShock(player, rng, laserDamage, player.Position, 1, nil, nil, trinketMulti)
	end

	if player:GetPlayerType() ~= mod.PLAYER.BRIEND then
		mod:doGunslingersGritBoost(player)

		-- Do AOE
		mod:AddGritPoint(player, mod:GetEntityData(player), player.Position)

		-- VFX and SFX
		mod:doGunslingersGritFX(player)

		return {Discharge = true, Remove = false, ShowAnim = false}
	end

	local otherTwin = player:GetOtherTwin()
	mod:TrySwapBriendDataOnEsauJr(player)
	mod:TrySwapBriendDataOnEsauJr(otherTwin)
	local twinData = mod:GetEntityData(otherTwin)
	local playerData = mod:GetEntityData(player)

	mod:FriendFullyReloadGuns(playerData)
	mod:FriendFullyReloadGuns(twinData)

	mod:doGunslingersGritBoost(player)
	mod:doGunslingersGritBoost(otherTwin)

	-- Do AOE
	mod:AddGritPoint(player, playerData, player.Position)

	-- Change primary gun
	mod:SwapPrimaryBriend(player)

	-- VFX and SFX
	mod:doGunslingersGritFX(player)

	return {Discharge = true, Remove = false, ShowAnim = false}
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.UseGunslingersGrit, mod.ITEM.COLLECTIBLE.GUNSLINGERS_GRIT)

function mod:BriendNewRoom(player, d)
	if player:GetPlayerType() ~= mod.PLAYER.BRIEND then
		return
	end
	if d.Briend then
		d.Briend.LostAllAmmo = nil
	end
end

-- Check if this gun should be in briend's right hand or not
function mod:IsBriendGunInRightHand(player, gunData)
	-- If we are the revolver and revolver is the primary gun
	if gunData.isBriendsPrimaryGun and mod:IsPrimaryGunRevolver(player) then
		return true
	-- If we are not the revolver and primary gun is not the revolver
	elseif not gunData.isBriendsPrimaryGun and not mod:IsPrimaryGunRevolver(player) then
		return true
	end
	return false
end

---@param player EntityPlayer
function mod:BriendPlayerUpdate(player)
	if mod:IsBriendTwin(player) then
		local parentPlayer = player:GetOtherTwin()
		player.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
		player.Velocity = parentPlayer.Velocity
		player.Position = parentPlayer.Position
	else
		local otherTwin = player:GetOtherTwin()
		if otherTwin and otherTwin:IsDead() and not player:IsDead() then
			player:Kill()
		end
	end

	mod:TrySwapBriendDataOnEsauJr(player)
	mod:HandleHealthCheckingActivesOnBriend(player)
	mod:HandleBriendPlayerBleed(player)
end
mod:AddCallback(mod.CALLBACK.FF_POST_PLAYER_UPDATE, mod.BriendPlayerUpdate, FiendFolio.PLAYER.BRIEND)

function mod:CheckBriendDataInit(player)
	local d = mod:GetEntityData(player)

	if not d.Briend or not d.Briend.Initialized then
		d.Briend = d.Briend or {} -- store shit here to have it copy between esau jr and the regular player

		if mod:IsBriendTwin(player) then
			d.Briend.IsBriendTwin = true
			local save = d.ffsavedata
			save.BriendTwinSyncStats = {
				MaxFireDelay = 0,
				Damage = 0,
				TearRange = 0,
				ShotSpeed = 0,
				Luck = 0
			}
		else
			d.Briend.IsPrimaryGunRevolver = true
			d.Briend.PrimaryBriendGetsItem = true
			d.Briend.AlternatingGunIsRevolver = true

			d.Briend.StatCache = {
				MaxFireDelay = {CacheFlag.CACHE_FIREDELAY, player.MaxFireDelay},
				Damage = {CacheFlag.CACHE_DAMAGE, player.Damage},
				TearRange = {CacheFlag.CACHE_RANGE, player.TearRange},
				ShotSpeed = {CacheFlag.CACHE_SHOTSPEED, player.ShotSpeed},
				Luck = {CacheFlag.CACHE_LUCK, player.Luck},
			}
		end

		d.Briend.LastChangedColor = player.FrameCount
		d.Briend.Initialized = true
	end
end

-- Tracks smelted trinket status
function mod:BriendTrackTrinkets(player, d)
	local history = player:GetHistory()
	local trinkets = {}

	-- Gather trinkets
	for _, historyItem in ipairs(history:GetCollectiblesHistory()) do
		if historyItem:IsTrinket() then
			local historyItemId = historyItem:GetItemID()
			trinkets[historyItemId] = trinkets[historyItemId] or 0
			trinkets[historyItemId] = trinkets[historyItemId] + 1
		end
	end

	-- Init values
	d.LastBriendSmeltedUpdate = d.LastBriendSmeltedUpdate or Isaac.GetFrameCount()
	d.LastBriendSmeltedTrinkets = d.LastBriendSmeltedTrinkets or trinkets

	-- Check old table for if we removed something that was there previously
	local updated = false
	for trinket, count in pairs(d.LastBriendSmeltedTrinkets) do
		if trinkets[trinket] ~= count then
			updated = true
			break
		end
	end

	-- Also check the new table in case we added something that wasnt there previously
	if not updated then
		for trinket, count in pairs(trinkets) do
			if d.LastBriendSmeltedTrinkets[trinket] ~= count then
				updated = true
				break
			end
		end
	end

	if updated then
		d.LastBriendSmeltedUpdate = Isaac.GetFrameCount()
	end

	d.LastBriendSmeltedTrinkets = trinkets
end

function mod:BriendSyncSmeltedTrinkets(sourceData, target, targetData)
	-- Check if target has a trinket that it shouldnt
	for trinket, sourceCount in pairs(sourceData.LastBriendSmeltedTrinkets) do
		local targetCount = targetData.LastBriendSmeltedTrinkets[trinket] or 0
		if targetCount < sourceCount then
			for _ = targetCount, sourceCount-1 do
				mod.IgnoreBriendTrinketResyncing = true
				target:TryRemoveTrinket(trinket)
				target:AddSmeltedTrinket(trinket)
				mod.IgnoreBriendTrinketResyncing = false
			end
		end
	end

	-- Check if target doesnt have a trinket that it should
	for trinket, targetCount in pairs(targetData.LastBriendSmeltedTrinkets) do
		local sourceCount = sourceData.LastBriendSmeltedTrinkets[trinket] or 0
		if targetCount > sourceCount then
			for _ = targetCount, sourceCount+1 do
				mod.IgnoreBriendTrinketResyncing = true
				target:TryRemoveTrinket(trinket)
				target:TryRemoveSmeltedTrinket(trinket)
				mod.IgnoreBriendTrinketResyncing = false
			end
		end
	end

	targetData.LastBriendSmeltedTrinkets = sourceData.LastBriendSmeltedTrinkets
end

-- FYI: This typically runs only once when the player is first spawned, and does not run on continues.
mod.BriendIgnorePassing = false
function mod:BriendPlayerInitStats(player)
	local itemPool = game:GetItemPool()
	itemPool:RemoveCollectible(mod.ITEM.COLLECTIBLE.GUNSLINGERS_GRIT)

	-- Hidden twin init
	if mod:IsBriendTwin(player) then
		local mainTwin = player:GetOtherTwin()
		player:SetControllerIndex(mainTwin.ControllerIndex)
		player:AddMaxHearts(mod.BriendBalancing.DeagleHealthAdd)
		player:RemoveCollectible(mod.ITEM.COLLECTIBLE.GUNSLINGERS_GRIT)

	-- Main twin init
	elseif not player:GetOtherTwin() then
		mod.BriendIgnorePassing = true
		mod:SpawnHiddenFriend(player)
		mod.BriendIgnorePassing = false
	end

	mod:CheckBriendDataInit(player)

	-- Remove blacklisted items and trinkets
	for _, item in ipairs(BriendVanillaBlacklistedItems) do
		itemPool:RemoveCollectible(item)
	end
	for _, trinket in ipairs(BriendVanillaBlacklistedTrinkets) do
		itemPool:RemoveTrinket(trinket)
	end
end
mod:AddCallback(ModCallbacks.MC_PLAYER_INIT_POST_LEVEL_INIT_STATS, mod.BriendPlayerInitStats, mod.PLAYER.BRIEND)

-- Update the description for Gunslinger's Grit
function mod:SetGunslingersGritDescription(player)
	local description = PlayerManager.AnyoneIsPlayerType(mod.PLAYER.BRIEND) and "Swap and strike" or "Scorch and strike"
	config:GetCollectible(mod.ITEM.COLLECTIBLE.GUNSLINGERS_GRIT).Description = description
end
mod:AddCallback(ModCallbacks.MC_PLAYER_INIT_PRE_LEVEL_INIT_STATS, mod.SetGunslingersGritDescription)

local noLoop = false
function mod:BriendActuallyBlacklistItem(col, itemPool, decrease, seed)
	if not noLoop and PlayerManager.AnyoneIsPlayerType(mod.PLAYER.BRIEND) then
		if BriendVanillaBlacklistedItems[col] then
			noLoop = true
			local new = game:GetItemPool():GetCollectible(itemPool, decrease, seed, CollectibleType.COLLECTIBLE_BREAKFAST)
			noLoop = false
			return new
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GET_COLLECTIBLE, mod.BriendActuallyBlacklistItem)

local noPoop = false
function mod:BriendActuallyBlacklistTrinket(trinket)
	if not noPoop and PlayerManager.AnyoneIsPlayerType(mod.PLAYER.BRIEND) then
		if BriendVanillaBlacklistedItems[trinket] then
			noPoop = true
			local new = game:GetItemPool():GetTrinket(false)
			noPoop = false
			return new
		end
	end
end
mod:AddCallback(ModCallbacks.MC_GET_TRINKET, mod.BriendActuallyBlacklistTrinket)

-- Since MC_PLAYER_INIT_POST_LEVEL_INIT_STATS does not run on continues, make sure some things are initialized here.
function mod:BriendPostGameContinue(isContinued)
	if isContinued then
		for _, player in ipairs(PlayerManager.GetPlayers()) do
			if player:GetPlayerType() == mod.PLAYER.BRIEND then
				mod:CheckBriendDataInit(player)
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.BriendPostGameContinue)

local HoldingUpAnims = {
	[Direction.NO_DIRECTION] = { Walk = "PickupWalkDown", Head = "HeadDown" },
	[Direction.UP] = { Walk = "PickupWalkUp", Head = "HeadUp" },
	[Direction.DOWN] = { Walk = "PickupWalkDown", Head = "HeadDown" },
	[Direction.LEFT] = { Walk = "PickupWalkLeft", Head = "HeadLeft" },
	[Direction.RIGHT] = { Walk = "PickupWalkRight", Head = "HeadRight" },
}

-- Have the Briend twin remove itself if the main twin is no longer Briend.
-- If repentogon adds a callback on ChangePlayerType this could probably be checked there instead.
mod:AddCallback(mod.CALLBACK.FF_PRE_PLAYER_UPDATE, function(_, player)
	local otherTwin = player:GetOtherTwin()
	if otherTwin and mod:IsBriendTwin(player) and otherTwin:GetPlayerType() ~= FiendFolio.PLAYER.BRIEND then
		-- Shove all the twin's items over to the main player.
		for id, count in pairs(player:GetCollectiblesList()) do
			local item = config:GetCollectible(id)
			if item and item.Type ~= ItemType.ITEM_ACTIVE then
				for i=1, count do
					otherTwin:AddCollectible(id, 0, false)
				end
			end
		end
		PlayerManager.RemoveCoPlayer(player)
		return true
	end
end, FiendFolio.PLAYER.BRIEND)

local function AllowWispSharing(collectible)
	local item = config:GetCollectible(collectible)
	if not item or item.Type ~= ItemType.ITEM_PASSIVE or item.CacheFlags & CacheFlag.CACHE_FAMILIARS > 0 then
		return false
	end
	return true
end

-- Copy the current effects of wisps owned by the twin. Familiar-granting ones are skipped.
local function SyncWisps(player, twin)
	mod:GetEntityData(player).BriendWispsSynced = true

	local wisps = twin:GetWispCollectiblesList()

	for id, amount in pairs(wisps) do
		if not AllowWispSharing(id) then
			wisps[id] = 0
		end
	end

	player:SetInnateCollectibleGroup(mod.BriendSharedWispInnateGroup, wisps)
end

-- Copy the current groupless innate items owned by the twin, if they are items that should be shared.
local function SyncGrouplessInnates(player, twin)
	mod:GetEntityData(player).BriendGrouplessInnatesSynced = true

	local innates = twin:GetInnateCollectibleGroup("")

	for id, amount in pairs(innates) do
		if not config:GetCollectible(id):HasCustomTag(mod.BriendSharedTag) then
			innates[id] = 0
		end
	end

	player:SetInnateCollectibleGroup(mod.BriendSharedLooseInnateGroup, innates)
end

---@param player EntityPlayer
mod.IgnoreBriendTrinketResyncing = false
function mod:BriendPeffectUpdate(player, d)-- Handle Grit boost application
	if d.BriendGritBoost then
		d.BriendGritBoost = d.BriendGritBoost - 1
		if d.BriendGritBoost <= 0 then
			d.BriendGritBoost = nil
		end

		if d.BriendGritBoost == nil or d.BriendGritBoost % 7 == 0 then
			player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_TEARCOLOR, true)
		end
	end

	-- Do bullet blocking
	if d.GritBlockPoints then
		local doSound = false
		local maxDistance = mod:GetMaxGritDistance(player)

		for i = #d.GritBlockPoints, 1, -1 do
			local pointInfo = d.GritBlockPoints[i]
			local point, timer = table.unpack(pointInfo)

			local hitSomething = mod:DoGritBulletCheck(point, maxDistance)
			if hitSomething then
				doSound = true
			end

			d.GritBlockPoints[i][2] = timer - 1
			if d.GritBlockPoints[i][2] <= 0 then
				table.remove(d.GritBlockPoints, i)
			end
		end

		if doSound then
			sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS, 0.5)
		end
	end

	if player:GetPlayerType() ~= mod.PLAYER.BRIEND then
		if d.Briend and d.Briend.IsBriendTwin and (not player:GetOtherTwin() or player:GetOtherTwin():GetPlayerType() ~= mod.PLAYER.BRIEND) then
			mod:AddOneTimeCallback(ModCallbacks.MC_POST_UPDATE, function()
				PlayerManager.RemoveCoPlayer(player)
			end)
		end
		return
	end

	mod:TrySwapBriendDataOnEsauJr(player)
	--if d.Briend then d.Briend.SyncStats = false end

	local otherTwin = player:GetOtherTwin()

	if otherTwin:GetPlayerType() ~= mod.PLAYER.BRIEND then
		otherTwin:ChangePlayerType(mod.PLAYER.BRIEND)  -- bleas
		mod:CheckBriendDataInit(player)
	end

	if not d.BriendWispsSynced then
		SyncWisps(player, otherTwin)
		SyncWisps(otherTwin, player)
	end

	if not d.BriendGrouplessInnatesSynced then
		SyncGrouplessInnates(player, otherTwin)
		SyncGrouplessInnates(otherTwin, player)
	end

	if d.BriendFixBookOfVirtuesCharge then
		d.BriendFixBookOfVirtuesCharge = nil
		if player:GetActiveItem() == CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES then
			player:SetActiveCharge(player:GetActiveMaxCharge())
		end
	end

	if d.BriendSkipItemTransfer then
		d.BriendSkipItemTransfer = nil
		-- Force chapi to resync before re-enabling health passing or else Briend could freaking Die
		-- (D4 can remove hearts when HP ups are rerolled, so we really don't want that to get passed to the main twin)
		CustomHealthAPI.Helper.ResyncHealthOfPlayer(player)
		CustomHealthAPI.Helper.ResyncHealthOfPlayer(otherTwin)
		mod.BriendIgnorePassing = false
	end

	if d.BriendDelayedEvaluateItems then
		player:AddCacheFlags(d.BriendDelayedEvaluateItems, true)
		d.BriendDelayedEvaluateItems = nil
	end

	if d.BriendMegaMushFinished and not game:IsPaused() then
		-- we don't know why they stay invisible but just setting them to visible afterwards fixes it yay
		if not mod:IsBriendTwin(player) then
			player.Visible = true
		end
		d.BriendMegaMushFinished = nil
	end

	if d.BriendDelayedSyncedItems then
		local delayedSyncItems = d.BriendDelayedSyncedItems
		d.BriendDelayedSyncedItems = nil
		for collectible, count in pairs(delayedSyncItems) do
			mod:AddSharedBriendPassive(otherTwin, collectible, count)
		end
	end

	mod:TrySwapBriendDataOnEsauJr(otherTwin)
	local od = mod:GetEntityData(otherTwin)

	-- Sync extra animations from twin to main
	if not mod:IsBriendTwin(player) and not otherTwin:IsExtraAnimationFinished() then
		-- GetBodySprite is bugged in REPENTOGON 1.1.2e (and prior!) and doesn't freaking return anything
		local sprite = player:GetBodySprite()
		if not sprite or not sprite:IsPlaying() then
			sprite = player:GetSprite()
		end
		local anim = sprite:GetAnimation()

		local otherSprite = otherTwin:GetBodySprite()
		if not otherSprite or not otherSprite:IsPlaying() then
			otherSprite = otherTwin:GetSprite()
		end
		local otherAnim = otherSprite:GetAnimation()

		if otherAnim:find("Walk") then
			otherAnim = "UseItem"
		end

		if otherAnim ~= anim and otherSprite:GetFrame() == 0 then
			if otherTwin:IsHoldingItem() and not player:IsHoldingItem() then
				local heldSprite = otherTwin:GetHeldSprite()
				player:AnimatePickup(heldSprite, false, otherAnim)
			elseif not player:IsHoldingItem() then
				player:PlayExtraAnimation(otherAnim)
			end
		end
	end

	local canDoHoldUpGunAnim = (
		not player:IsCoopGhost()
		and not d.holdingFFItem
		and player:CanPickupItem()
		and not player:IsHoldingItem()
		and not otherTwin:IsHoldingItem()
		and player:GetItemState() == CollectibleType.COLLECTIBLE_NULL
		and otherTwin:GetItemState() == CollectibleType.COLLECTIBLE_NULL
		and player:IsExtraAnimationFinished()
		and otherTwin:IsExtraAnimationFinished()
		and not player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_MEGA_MUSH)
	)

	-- Hold gun above head when near pedestal
	if d.Briend then
		if canDoHoldUpGunAnim and not mod.IsActiveRoom() then
			local pedestalFound = false
			for _, v in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
				if v.SubType > 0 and v.Position:Distance(player.Position) <= mod.BriendBalancing.HoldGunAboveHeadRadius then
					local item = config:GetCollectible(v.SubType)
					if item and item.Type ~= ItemType.ITEM_ACTIVE then
						pedestalFound = true
						break
					end
				end
			end

			if pedestalFound then
				d.Briend.TryHoldGunAboveHead = true
			else
				d.Briend.TryHoldGunAboveHead = nil
			end
		else
			d.Briend.TryHoldGunAboveHead = nil
		end
	end

	if mod:IsBriendTwin(player) then
		if not d.BriendTwinBlockedItems then
			d.BriendTwinBlockedItems = true
			for _, collectible in pairs(BriendTwinBlockedCollectibles) do
				player:BlockCollectible(collectible)
			end
		end
	else
		mod:BriendTrackTrinkets(player, d)
		mod:BriendTrackTrinkets(otherTwin, od)

		-- Sync our trinkets
		if d.LastBriendSmeltedUpdate and od.LastBriendSmeltedUpdate then
			local change = false
			if d.LastBriendSmeltedUpdate < od.LastBriendSmeltedUpdate then
				mod:BriendSyncSmeltedTrinkets(od, player, d)
				change = true
			elseif d.LastBriendSmeltedUpdate > od.LastBriendSmeltedUpdate then
				mod:BriendSyncSmeltedTrinkets(d, otherTwin, od)
				change = true
			end

			if change then
				-- This'll re-init next frame
				-- This lets us sync them together, making it so the very next update doesn't trigger another sync
				d.LastBriendSmeltedUpdate = nil
				od.LastBriendSmeltedUpdate = nil
			end
		end

		if player:GetEffects():HasNullEffect(NullItemID.ID_SPIN_TO_WIN) then
			d.BriendSpinToWinOffset = (d.BriendSpinToWinOffset or 0) + 1
		end
	end

	-- Handle DonateLuck syncing (donation machine, cursed pennies, lucky pennies, etc)
	if player.GetDonateLuck then
		local mainTwin = player:GetMainTwin()
		local hiddenTwin = mod:GetBriendTwin(player)
		local mainTwinData = mod:GetEntityData(mainTwin)
		local otherTwinData = mod:GetEntityData(hiddenTwin)

		mainTwinData.OldDonateLuck = mainTwinData.OldDonateLuck or mainTwin:GetDonateLuck()
		otherTwinData.OldDonateLuck = otherTwinData.OldDonateLuck or hiddenTwin:GetDonateLuck()

		-- If luck change, sync
		local mainDonateLuck = mainTwin:GetDonateLuck()
		local otherDonateLuck = hiddenTwin:GetDonateLuck()
		if mainDonateLuck ~= otherDonateLuck then
			-- Main twin had a luck change, so update other twin
			if mainTwinData.OldDonateLuck ~= mainDonateLuck then
				hiddenTwin:DonateLuck(mainDonateLuck - mainTwinData.OldDonateLuck)
			-- and vice versa
			elseif otherTwinData.OldDonateLuck ~= otherDonateLuck then
				hiddenTwin:DonateLuck(otherDonateLuck - otherTwinData.OldDonateLuck)
			end
		end

		-- Update old values
		mainTwinData.OldDonateLuck = mainTwin:GetDonateLuck()
		otherTwinData.OldDonateLuck = hiddenTwin:GetDonateLuck()
	end

	-- Do player bleed colors regardless of which twin has the effect
	if mod:IsBriendMain(player) then
		local data = CustomHealthAPI.Helper.GetSavedata(player)
		local twindata = CustomHealthAPI.Helper.GetSavedata(otherTwin)
		local timer = math.max((data and data.ShardBleedTimer) or -1 * math.huge, (twindata and twindata.ShardBleedTimer) or -1 * math.huge)
		if timer > -1 * math.huge then
			local tint = 1.0
			local offset = 0
			if timer < 58 then
				if (timer % 8) == 1 or (timer % 8) == 0 then
					tint = 0.0
					offset = 1
				elseif (timer % 8) == 7 or (timer % 8) == 6 then
					tint = 0.25
					offset = 0.75
				elseif (timer % 8) == 5 or (timer % 8) == 4 then
					tint = 0.5
					offset = 0.5
				elseif (timer % 8) == 3 or (timer % 8) == 2 then
					tint = 0.75
					offset = 0.25
				end
			end

			local color = Color(1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0)
			color = Color.Lerp(color, player:GetSprite().Color, math.min(1.0, timer / 300))
			color.G = color.G * tint
			color.B = color.B * tint
			color.RO = color.RO + offset

			player:SetColor(color, 1, 1, false, false)
		end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_TRIGGER_EFFECT_REMOVED, function(_, player)
	if player:GetPlayerType() == mod.PLAYER.BRIEND and not mod:IsBriendTwin(player) then
		-- we don't know why they stay invisible but just setting them to visible afterwards fixes it yay
		mod:GetEntityData(player).BriendMegaMushFinished = true
	end
end, Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_MEGA_MUSH))

local function StoreAnimation(spr)
	return {
		Anim = spr:GetAnimation(),
		Frame = spr:GetFrame(),
		IsPlaying = spr:IsPlaying(),
		OverlayAnim = spr:GetOverlayAnimation(),
		OverlayFrame = spr:GetOverlayFrame(),
		OverlayIsPlaying = spr:IsOverlayPlaying(),
		Scale = Vector(spr.Scale.X, spr.Scale.Y),
	}
end

local function RestoreAnimation(spr, state)
	spr:SetFrame(state.Anim, state.Frame)
	if state.IsPlaying then
		spr:Continue()
	else
		spr:Stop()
	end
	if state.OverlayAnim == "" then
		spr:RemoveOverlay()
	else
		spr:SetOverlayFrame(state.OverlayAnim, state.OverlayFrame)
		if state.OverlayIsPlaying then
			spr:ContinueOverlay()
		else
			spr:StopOverlay()
		end
	end
	spr.Scale = state.Scale
end

--[[
local function HideGlowLayer(player, d, hide)
	if d.BriendGlowLayerHidden ~= hide then
		d.BriendGlowLayerHidden = hide
		local glowLayerIdx = player:GetCostumeLayerMap()[1].costumeIndex
		if glowLayerIdx > -1 then
			local costumeDesc = player:GetCostumeSpriteDescs()[glowLayerIdx+1]
			if costumeDesc then
				local layer = costumeDesc:GetSprite():GetLayer(0)
				if layer then
					layer:SetColor(Color(1,1,1, hide and 0 or 1))
				end
			end
		end
	end
end
]]

mod:AddPriorityCallback(ModCallbacks.MC_PRE_PLAYER_RENDER, CallbackPriority.LATE, function(_, player, renderOffset)
	local d = mod:GetEntityData(player)
	if not d.Briend or player:GetPlayerType() ~= mod.PLAYER.BRIEND then return end

	if mod:IsBriendTwin(player) then
		player.Visible = false
		return
	end

	if not player.Visible or player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_MEGA_MUSH) or player:IsDead() then
		d.HoldingGunAboveHead = nil
		return
	end

	mod:TrySwapBriendDataOnEsauJr(player)


	-- Controls the animation for holding a gun over Briend's head
	local playerFrame = player.FrameCount

	if mod:IsBriendHoldingGunAboveHead(player) then
		d.Briend.HoldGunAnimEndFrame = nil
		if not d.Briend.HoldGunAnimStartFrame then
			d.Briend.HoldGunAnimStartFrame = playerFrame
		end
	elseif d.Briend.HoldGunAnimStartFrame then
		d.Briend.HoldGunAnimEndFrame = playerFrame
		d.Briend.HoldGunAnimStartFrame = nil
	end

	local extraAnim
	local extraAnimFrame
	local doCustomRender = false

	if d.Briend.HoldGunAnimStartFrame then
		extraAnim = "LiftItem"
		extraAnimFrame = playerFrame - d.Briend.HoldGunAnimStartFrame
		doCustomRender = extraAnimFrame > 1
	elseif d.Briend.HoldGunAnimEndFrame then
		local f = playerFrame - d.Briend.HoldGunAnimEndFrame
		if f >= 8 then
			d.Briend.HoldGunAnimEndFrame = nil
		else
			extraAnim = "HideItem"
			extraAnimFrame = playerFrame - d.Briend.HoldGunAnimEndFrame
			doCustomRender = extraAnimFrame < 3
		end
	end

	if extraAnim then
		local sprite = player:GetSprite()

		local scaleModifier

		local animData = sprite:GetAnimationData(extraAnim)
		if animData then
			local layerData = animData:GetLayer(12)
			if layerData then
				local frame = math.min(extraAnimFrame, animData:GetLength())
				scaleModifier = layerData:GetFrame(frame):GetScale()
			end
		end

		d.Briend.HoldGunRenderFrame = Isaac.GetFrameCount()

		if doCustomRender then
			local state = StoreAnimation(sprite)

			local anim = extraAnim
			local frame = extraAnimFrame

			if state.Anim == "WalkDown" or state.Anim == "WalkLeft" or state.Anim == "WalkUp" or state.Anim == "WalkRight" then
				anim = "Pickup" .. state.Anim
				frame = state.Frame
			end
			sprite:RemoveOverlay()
			sprite:SetFrame(anim, frame)

			if scaleModifier then
				sprite.Scale = state.Scale * scaleModifier
			end

			local renderPos = Isaac.WorldToScreen(player.Position) + renderOffset + player:GetFlyingOffset() - Game():GetRoom():GetRenderScrollOffset()
			sprite:Render(renderPos)

			RestoreAnimation(sprite, state)

			--d.Briend.HoldGunCustomRenderFrame = d.Briend.HoldGunRenderFrame
			if d.Briend.HoldGunAboveHeadSpriteScale then
				d.Briend.HoldGunAboveHeadSpriteScale = nil
				player:AddCacheFlags(CacheFlag.CACHE_SIZE, true)
			end

			--HideGlowLayer(player, d, true)
			Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_PLAYER_RENDER, player.Variant, player, renderOffset)
			return false
		else
			d.Briend.HoldGunAboveHeadSpriteScale = scaleModifier
			player:AddCacheFlags(CacheFlag.CACHE_SIZE, true)
		end

	elseif d.Briend.HoldGunAboveHeadSpriteScale then
		d.Briend.HoldGunAboveHeadSpriteScale = nil
		player:AddCacheFlags(CacheFlag.CACHE_SIZE, true)
	end
end, PlayerVariant.PLAYER)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player)
	local d = mod:GetEntityData(player)
	if d.Briend and d.Briend.HoldGunRenderFrame == Isaac.GetFrameCount() and d.Briend.HoldGunAboveHeadSpriteScale then
		player.SpriteScale = player.SpriteScale * d.Briend.HoldGunAboveHeadSpriteScale
	end
end, CacheFlag.CACHE_SIZE)

--[[
function mod:HideBriend(player)
	local d = mod:GetEntityData(player)
	if d.Briend then
		HideGlowLayer(player, d, false)
		if d.Briend.HoldGunCustomRenderFrame == Isaac.GetFrameCount() then
			return false
		end
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_RENDER_PLAYER_BODY, CallbackPriority.EARLY, mod.HideBriend, FiendFolio.PLAYER.BRIEND)
mod:AddPriorityCallback(ModCallbacks.MC_PRE_RENDER_PLAYER_HEAD, CallbackPriority.EARLY, mod.HideBriend, FiendFolio.PLAYER.BRIEND)
]]

local ORBIT_SPEEDS = {
	[0] = { 0.045, 2 },
	[1] = { 0.045, 1.5 },
	[2] = { -0.03, 1.5 },
	[3] = { 0.02, 1.5 },
	[4] = { 0.02, 1.5 },
	[5] = { 0.045, 1.5 },
	[6] = { 0.03, 1.5 },
	[7] = { 0.04, 1.5 },
}

-- Makes all familiars follow main Briend instead of the twin as long as they dont have special behavior
-- This could create some inconsistencies depending on what the familiar is doing, but it should be mostly fine smile
---@param familiar EntityFamiliar
local lastFrameCorrectedFamiliars = nil
local familiarsToCorrect = {}
function mod:BriendCorrectFamiliars(familiarUpdating)
	local correctedOrbitLayers = {}

	if not familiarUpdating:HasEntityFlags(EntityFlag.FLAG_APPEAR) or familiarUpdating.FrameCount >= 5 then
		local frame = game:GetFrameCount()
		if lastFrameCorrectedFamiliars ~= frame then
			familiarsToCorrect = {}
			for _, familiar in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR)) do
				local familiar = familiar:ToFamiliar()
				local player = familiar.Player
				if mod:IsBriendTwin(player) then
					if familiar.IsFollower or familiar.IsDelayed or familiar.OrbitLayer ~= -1 then
						table.insert(familiarsToCorrect, familiar)
					end
				end
			end
			lastFrameCorrectedFamiliars = frame
		end
		for _, familiar in ipairs(familiarsToCorrect) do
			local player = familiar.Player
			familiar.Player = player:GetMainTwin()
			correctedOrbitLayers[familiar.OrbitLayer] = true
			mod:GetEntityData(familiar).BriendOriginalPlayer = player
			mod:GetEntityData(familiar).BriendCorrected = (mod:GetEntityData(familiar).BriendCorrected or 0) + 1
		end
	end

	-- Handles Spin to Win, Big Fan, and Guardian Angel
	local player = familiarUpdating.Player
	if player and player:GetPlayerType() == FiendFolio.PLAYER.BRIEND then
		player = player:GetMainTwin()
		local twin = player:GetOtherTwin()

		local hasSpin = player:GetEffects():HasNullEffect(NullItemID.ID_SPIN_TO_WIN)
		local hasFlag = familiarUpdating:HasEntityFlags(EntityFlag.FLAG_SPIN)
		if hasSpin and not hasFlag then
			familiarUpdating:AddEntityFlags(EntityFlag.FLAG_SPIN)
		elseif hasFlag and not hasSpin then
			familiarUpdating:ClearEntityFlags(EntityFlag.FLAG_SPIN)
		end

		local orbitLayer = familiarUpdating.OrbitLayer

		if ORBIT_SPEEDS[orbitLayer] and correctedOrbitLayers[orbitLayer] then
			local orbitSpeed = ORBIT_SPEEDS[orbitLayer][1]
			if twin:HasCollectible(CollectibleType.COLLECTIBLE_GUARDIAN_ANGEL) or player:HasCollectible(CollectibleType.COLLECTIBLE_GUARDIAN_ANGEL) then
				orbitSpeed = orbitSpeed * ORBIT_SPEEDS[orbitLayer][2]
			end
			if twin:HasCollectible(CollectibleType.COLLECTIBLE_BIG_FAN) or player:HasCollectible(CollectibleType.COLLECTIBLE_BIG_FAN) then
				orbitSpeed = orbitSpeed * 1/3
			end
			familiarUpdating.OrbitSpeed = orbitSpeed
			familiarUpdating.OrbitAngleOffset = (familiarUpdating.OrbitAngleOffset + (mod:GetEntityData(player).BriendSpinToWinOffset or 0) * -10 * familiarUpdating.OrbitSpeed) % 360 - 180
		end
	end
end
mod:AddPriorityManualCallback(ModCallbacks.MC_PRE_FAMILIAR_UPDATE, math.huge, mod.BriendCorrectFamiliars)

function mod:BriendUncorrectFamiliars(familiarUpdating)
	for _, familiar in ipairs(familiarsToCorrect) do
		local data = mod:GetEntityData(familiar)
		data.BriendCorrected = math.max(0, (mod:GetEntityData(familiar).BriendCorrected or 0) - 1)
		if data.BriendCorrected <= 0 and data.BriendOriginalPlayer then
			familiar.Player = data.BriendOriginalPlayer
			data.BriendOriginalPlayer = nil
		end
	end
end
mod:AddPriorityManualCallback(ModCallbacks.MC_FAMILIAR_UPDATE, math.huge, mod.BriendUncorrectFamiliars)

-- Fixes a visual quirk on room transitions
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	if PlayerManager.AnyoneIsPlayerType(FiendFolio.PLAYER.BRIEND) then
		mod:AddOneTimeCallback(ModCallbacks.MC_PRE_FAMILIAR_RENDER, function()
			for _, familiar in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR)) do
				local player = familiar.Player
				if player and player:GetPlayerType() == FiendFolio.PLAYER.BRIEND then
					familiar:Update()
				end
			end
		end)
	end
end)

mod:AddCallback(mod.CALLBACK.PRE_GUN_UPDATE, function(_, gun, player)
	if player:GetPlayerType() ~= FiendFolio.PLAYER.BRIEND then return end

	mod:TrySwapBriendDataOnEsauJr(player)
	local pdata = mod:GetEntityData(player)
	local twin = player:GetOtherTwin()
	mod:TrySwapBriendDataOnEsauJr(twin)
	local twindata = twin and mod:GetEntityData(twin) or {}
	local gundata = mod:GetEntityData(gun)

	if pdata.FriendsRevolver and GetPtrHash(gun) == GetPtrHash(pdata.FriendsRevolver) then
		if (pdata.WizardTracker or twindata.WizardTracker) then
			if mod:IsSelectedBriend(player) then
				gundata.AngleOffset = 45
			else
				gundata.AngleOffset = -45
			end
		else
			gundata.AngleOffset = 0
		end
	end
end)

-- Return true if Briend should do that thing where they alternate firing
-- each of their guns, instead of firing both at the same time.
-- Generally disabled for guns/items/weapons that introduce charge bars.
function mod:AllowBriendAlternatingFire(player)
	local mainTwin = player:GetMainTwin()
	local otherTwin = player:GetOtherTwin()

	if not mainTwin or not otherTwin then
		return false
	end

	for _, twin in ipairs({mainTwin, otherTwin}) do
		mod:TrySwapBriendDataOnEsauJr(twin)
		local data = mod:GetEntityData(twin)

		local gun = data.FriendsRevolver
		if gun then
			local gunInfo = mod.FriendGunInfo[gun.SubType]
			if gunInfo and gunInfo.DoesntPreventAlternateFiring then
				return false
			end
		end

		if twin:HasCollectible(CollectibleType.COLLECTIBLE_CHOCOLATE_MILK) or twin:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION)
		or twin:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) or twin:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK)
		or twin:HasCollectible(CollectibleType.COLLECTIBLE_MARKED) then
			return false
		end

		local weaponType = mod:GetFriendWeaponType(twin)
		if weaponType == WeaponType.WEAPON_MONSTROS_LUNGS or weaponType == WeaponType.WEAPON_TECH_X or weaponType == WeaponType.WEAPON_BRIMSTONE then
			return false
		end
	end

	return true
end

function mod:AlternateGunFiring(gun, player, aim)
	if player:GetPlayerType() ~= mod.PLAYER.BRIEND or mod:GetEntityData(gun).IsFriendSoulGun then
		return
	end

	local mainTwin = player:GetMainTwin()
	local otherTwin = player:GetOtherTwin()
	mod:TrySwapBriendDataOnEsauJr(player)
	mod:TrySwapBriendDataOnEsauJr(mainTwin)
	mod:TrySwapBriendDataOnEsauJr(otherTwin)
	local thisPlayerData = mod:GetEntityData(player)
	local mainTwinData = mod:GetEntityData(mainTwin)
	local otherTwinData = mod:GetEntityData(otherTwin)

	if thisPlayerData.Briend.LostAllAmmo and not mod:GetEntityData(gun).FriendBrimstoneActive then
		return true
	end

	if not otherTwinData.FriendsRevolver or not otherTwinData.FriendsRevolver:Exists() then
		return
	end

	if not thisPlayerData.FriendsRevolver or not thisPlayerData.FriendsRevolver:Exists() then
		return
	end

	if not mod:AllowBriendAlternatingFire(player) then
		return
	end

	local gunData = otherTwinData.FriendHeldGuns[otherTwinData.FriendsRevolver.InitSeed]
	if otherTwinData.Briend.LostAllAmmo or (gunData and gunData.Ammo and #gunData.Ammo == 0) then
		if mod:IsBriendTwin(player) then
			mainTwinData.Briend.AlternatingGunIsRevolver = false
		else
			mainTwinData.Briend.AlternatingGunIsRevolver = true
		end
	end

	-- If revolver and is twin gun, dont fire
	if mainTwinData.Briend.AlternatingGunIsRevolver  then
		if mod:IsBriendTwin(player) then
			return true
		end
	-- If not revolver and main gun, don't fire
	else
		if not mod:IsBriendTwin(player) then
			return true
		end
	end
end
mod:AddPriorityCallback(mod.CALLBACK.PRE_GUN_FIRE, CallbackPriority.EARLY, mod.AlternateGunFiring)

function mod:SwapGunFiring(gun, player, shots, held, wasReloadBonus)
	if player:GetPlayerType() ~= mod.PLAYER.BRIEND then
		return
	end

	local mainTwin = player:GetMainTwin()
	local otherTwin = player:GetOtherTwin()
	mod:TrySwapBriendDataOnEsauJr(mainTwin)
	mod:TrySwapBriendDataOnEsauJr(otherTwin)
	local pd = mod:GetEntityData(mainTwin)
	local twinData = mod:GetEntityData(otherTwin)

	if not twinData.FriendsRevolver or not twinData.FriendsRevolver:Exists() then
		return
	end

	local twinGun = twinData.FriendHeldGuns[twinData.FriendsRevolver.InitSeed]

	if mod:AllowBriendAlternatingFire(player) then
		-- Dont swap if the other gun has no ammo or is reloading from 0
		-- Also don't swap if high fire rate and has reserve bullets
		local gunData = mod:GetEntityData(gun)
		if #twinGun.Ammo > 0 and (not gunData.FriendConserveAmmo or gunData.FriendConserveAmmo <= 0) then
			pd.Briend.AlternatingGunIsRevolver = not pd.Briend.AlternatingGunIsRevolver
		end

		-- match the data to the other gun
		twinGun.LastFrameFired = gun.FrameCount
	end

	-- if out of ammo, mark that
	mod:TrySwapBriendDataOnEsauJr(player)
	local currentPlayerData = mod:GetEntityData(player)
	local gunInfo = currentPlayerData.FriendHeldGuns[gun.InitSeed]
	if gunInfo and gunInfo.Ammo and #gunInfo.Ammo == 0 then
		currentPlayerData.Briend.LostAllAmmo = true
	end
end
mod:AddCallback(mod.CALLBACK.POST_PRIMARY_GUN_FIRE, mod.SwapGunFiring)

function mod:BriendFinishReload(gun, player)
	if player:GetPlayerType() == mod.PLAYER.BRIEND then
		mod:TrySwapBriendDataOnEsauJr(player)
		mod:GetEntityData(player).Briend.LostAllAmmo = nil
	end
end
mod:AddCallback(mod.CALLBACK.POST_GUN_RELOAD, mod.BriendFinishReload)
mod:AddCallback(mod.CALLBACK.GUN_HOLD_RELEASE, mod.BriendFinishReload)

-- Makes bullets shot while under the Grit boost have the health spawning effect
function mod:BriendGritBulletHearts(gun, player, aim, bulletInfo, held, shotThings)
	mod:TrySwapBriendDataOnEsauJr(player)
	local pd = mod:GetEntityData(player)
	if not pd.BriendGritBoost then
		return
	end

	for _, singleShot in ipairs(shotThings) do
		local shotData = mod:GetEntityData(singleShot)
		mod:LetSpawnFriendHearts(shotData)
	end
end
mod:AddCallback(mod.CALLBACK.POST_GUN_FIRE, mod.BriendGritBulletHearts)

local triggeringOnDamageEffects = false

function mod:damageIsMausDoor(flags, source)
	if source.Type == 0 and flags == DamageFlag.DAMAGE_SPIKES + DamageFlag.DAMAGE_INVINCIBLE + DamageFlag.DAMAGE_NO_MODIFIERS + DamageFlag.DAMAGE_NO_PENALTIES then
		local room = game:GetRoom()
		if room:GetType() == RoomType.ROOM_BOSS and room:IsClear() then
			return true
		end
	end
end

function mod:BriendTransferDamage(player, damage, flags, source, countdown)
	local otherTwin = player:GetOtherTwin()
	if otherTwin:IsInvincible() or otherTwin:HasInvincibility() then
		return false
	end

	-- Copy the other twin's i-frames
	local otherCooldown = otherTwin:GetDamageCooldown()
	if otherCooldown > 0 then
		if not ((source.Type == EntityType.ENTITY_FAMILIAR and source.Variant == FamiliarVariant.BLOOD_OATH) or
		            (source.Type == EntityType.ENTITY_SLOT and (source.Variant == SlotVariant.BLOOD_DONATION_MACHINE or
		                                                        source.Variant == SlotVariant.DEVIL_BEGGAR or
					                                            source.Variant == SlotVariant.HELL_GAME or
					                                            source.Variant == SlotVariant.CONFESSIONAL))) and
		       flags & DamageFlag.DAMAGE_FAKE ~= DamageFlag.DAMAGE_FAKE
		then
			player:SetMinDamageCooldown(otherCooldown)
			return false
		end
	end

	if (player:HasCollectible(CollectibleType.COLLECTIBLE_ISAACS_HEART) or otherTwin:HasCollectible(CollectibleType.COLLECTIBLE_ISAACS_HEART)) and
	   flags & (DamageFlag.DAMAGE_RED_HEARTS | DamageFlag.DAMAGE_ISSAC_HEART | DamageFlag.DAMAGE_INVINCIBLE) == 0
	then
		return false
	elseif (player:HasCollectible(CollectibleType.COLLECTIBLE_PYROMANIAC) or otherTwin:HasCollectible(CollectibleType.COLLECTIBLE_PYROMANIAC)) and
	   flags & DamageFlag.DAMAGE_EXPLOSION ~= 0 and not mod:IsSelectedBriend(player)
	then
		return false
	elseif not mod:IsSelectedBriend(player) then
		-- Checking for maus door damage, should just be cancelled
		if mod:damageIsMausDoor(flags, source) then
			return false
		end

		-- Transfer damage to the selected twin if not trying to trigger on-damage effects
		if not (triggeringOnDamageEffects or mod.PreventBriendDamagePassing) then
			if source.Type == EntityType.ENTITY_SLOT and (source.Variant == SlotVariant.BLOOD_DONATION_MACHINE or
			                                              source.Variant == SlotVariant.DEVIL_BEGGAR or
			                                              source.Variant == SlotVariant.HELL_GAME or
			                                              source.Variant == SlotVariant.CONFESSIONAL)
			then
				otherTwin:ResetDamageCooldown()
			end
			mod.PreventBriendDamagePassing = true
			otherTwin:TakeDamage(damage, flags, source, countdown)
			mod.PreventBriendDamagePassing = false
			return false
		end
	end
end
mod:AddPriorityCallback(mod.CALLBACK.FF_PRE_PLAYER_TAKE_DMG, -1 * math.huge, mod.BriendTransferDamage, mod.PLAYER.BRIEND)

function mod:BriendTrackLastHurt(ent, damage, flags, source, countdown)
	local player = ent:ToPlayer()

	if player:GetPlayerType() == mod.PLAYER.BRIEND then
		mod:GetEntityData(player).BriendLastHurtFrame = player.FrameCount -- For simulating grid damage knockback

		-- Try to trigger on-damage effects for the other twin
		if not triggeringOnDamageEffects then
			triggeringOnDamageEffects = true
			mod.PreventBriendDamagePassing = true
			player:GetOtherTwin():TakeDamage(damage, flags | DamageFlag.DAMAGE_FAKE | DamageFlag.DAMAGE_RED_HEARTS, source, countdown)
			mod.PreventBriendDamagePassing = false
			triggeringOnDamageEffects = false
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, mod.BriendTrackLastHurt, EntityType.ENTITY_PLAYER)

-- Simulate grid damage knockback
function mod:BriendSimulateKnockback(grid, ent, playerDamage, flags, amount, ignoreGridCollisionClass)
	local player = ent:ToPlayer()
	if player and mod:IsBriendTwin(player) and mod:IsSelectedBriend(player) then
		local data = mod:GetEntityData(player)
		if data.BriendLastHurtFrame == player.FrameCount then
			local main = player:GetMainTwin()
			main:AddVelocity((player.Position - grid.Position):Resized(4))
		end
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_GRID_HURT_DAMAGE, -1 * math.huge, mod.BriendSimulateKnockback)

-- Handles registering specifically sacrifice room damage
function mod:BriendTransferSacSpikeDamage(grid, ent, playerDamage, flags, amount, ignoreGridCollisionClass)
	local player = ent:ToPlayer()
	if player and not mod:IsSelectedBriend(player) then
		local room = game:GetRoom()
		if room:GetType() == RoomType.ROOM_SACRIFICE and grid:ToSpikes() then
			local otherTwin = player:GetOtherTwin()
			grid:HurtDamage(otherTwin, playerDamage, flags, amount, ignoreGridCollisionClass)
			return false
		end
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_GRID_HURT_DAMAGE, -1 * math.huge, mod.BriendTransferSacSpikeDamage)

-- Make stompy work regardless of which twin has it
function mod:BriendGridCollision(player, grindex, grid)
	if player:GetPlayerType() == mod.PLAYER.BRIEND
	and not player:CanCrushRocks() and player:GetOtherTwin():CanCrushRocks()
	and grid and (grid:IsBreakableRock() or grid:ToPoop() or grid:ToTNT()) then
		grid:DestroyWithSource(false, EntityRef(player))
		return true
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_PLAYER_GRID_COLLISION, -1 * math.huge, mod.BriendGridCollision, PlayerVariant.PLAYER)

function mod:ClearBriendBloodOath()
	-- whichever twin doesn't actually have the blood oath item isnt always having them cleared properly
	for _, player in ipairs(PlayerManager.GetPlayers()) do
		if player:GetPlayerType() == mod.PLAYER.BRIEND then
			player:GetEffects():RemoveNullEffect(NullItemID.ID_BLOOD_OATH, -1)
			local data = mod:GetEntityData(player)
			if data.Briend then
				data.Briend.WasStabbedByBloodOath = nil
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.ClearBriendBloodOath)

function mod:TriggerBriendBloodOath()
	for _, oath in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_OATH)) do
		local oath = oath:ToFamiliar()
		local player = oath.Player
		if player and player:GetPlayerType() == mod.PLAYER.BRIEND and not mod:IsSelectedBriend(player) then
			local otherTwin = player:GetOtherTwin()
			if oath.State ~= 4 then
				if CustomHealthAPI.Helper.BloodOathCanExtractHP(otherTwin) then
					oath.State = 4
					oath.Position = player.Position
					oath:GetSprite():Play("Stab", true)
				end
			else
				if not CustomHealthAPI.Helper.BloodOathCanExtractHP(otherTwin) then
					oath.State = 3
					oath:GetSprite():Play("Idle", true)
				end
			end
		end
	end
end
mod:AddPriorityEntityCallback(ModCallbacks.MC_POST_NEW_LEVEL, CallbackPriority.LATE, EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_OATH, -1, mod.TriggerBriendBloodOath)

function mod:TransferBriendBloodOath()
	-- blood oath effect gets cleared and transferred to whichever briend actually has the item on new room
	-- we dont want that, we want it to stay on whichever briend got stabbed
	for _, oath in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_OATH)) do
		local oath = oath:ToFamiliar()
		local player = oath.Player
		if player and player:GetPlayerType() == mod.PLAYER.BRIEND then
			local otherTwin = player:GetOtherTwin()

			local effects, twinEffects = player:GetEffects(), otherTwin:GetEffects()
			effects:RemoveNullEffect(NullItemID.ID_BLOOD_OATH, -1)
			twinEffects:RemoveNullEffect(NullItemID.ID_BLOOD_OATH, -1)
			if mod:GetEntityData(player).Briend.WasStabbedByBloodOath then
				effects:AddNullEffect(NullItemID.ID_BLOOD_OATH, true, oath.Hearts)
			else
				twinEffects:AddNullEffect(NullItemID.ID_BLOOD_OATH, true, oath.Hearts)
			end

			player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
			player:AddCacheFlags(CacheFlag.CACHE_SPEED)
			player:EvaluateItems()

			otherTwin:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
			otherTwin:AddCacheFlags(CacheFlag.CACHE_SPEED)
			otherTwin:EvaluateItems()
		end
	end
end
mod:AddEntityCallback(ModCallbacks.MC_POST_ROOM_TRANSITION_UPDATE, EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_OATH, -1, mod.TransferBriendBloodOath)

function mod:HandleBriendBloodOathStab(oath)
	if oath.State == 4 and oath:GetSprite():IsEventTriggered("Hit") then
		local player = oath.Player
		if player and player:GetPlayerType() == mod.PLAYER.BRIEND then
			local isSelectedBriend = mod:IsSelectedBriend(player)
			local otherTwin = player:GetOtherTwin()
			local overrideHearts = false
			if not isSelectedBriend and CustomHealthAPI.Helper.GetTotalRedHP(player, true) <= 1 then
				CustomHealthAPI.Mod:HandleBloodOathCallback(otherTwin, 1,
				                                            DamageFlag.DAMAGE_NOKILL | DamageFlag.DAMAGE_RED_HEARTS | DamageFlag.DAMAGE_ISSAC_HEART |
				                                            DamageFlag.DAMAGE_INVINCIBLE | DamageFlag.DAMAGE_IV_BAG | DamageFlag.DAMAGE_NO_MODIFIERS,
				                                            EntityRef(oath), 30)

				if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
					oath.Hearts = oath.Hearts + 4
				end
				overrideHearts = true
			end

			local hearts = oath.Hearts
			mod.scheduleForUpdate(function()
				if overrideHearts then
					oath.Hearts = hearts
				end

				local effects, twinEffects = player:GetEffects(), otherTwin:GetEffects()
				effects:RemoveNullEffect(NullItemID.ID_BLOOD_OATH, -1)
				twinEffects:RemoveNullEffect(NullItemID.ID_BLOOD_OATH, -1)
				if isSelectedBriend then
					effects:AddNullEffect(NullItemID.ID_BLOOD_OATH, true, oath.Hearts)
					mod:GetEntityData(player).Briend.WasStabbedByBloodOath = true
				else
					twinEffects:AddNullEffect(NullItemID.ID_BLOOD_OATH, true, oath.Hearts)
					mod:GetEntityData(otherTwin).Briend.WasStabbedByBloodOath = true
				end
			end, 1)
		end
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_FAMILIAR_UPDATE, math.huge, mod.HandleBriendBloodOathStab, FamiliarVariant.BLOOD_OATH)

local dontStackOverflow = false
local avoidRecursion = false
---@param player EntityPlayer
function mod:BriendTransferItems(collectible, charge, firstTime, slot, varData, player)
	if avoidRecursion then return end

	if player:GetPlayerType() ~= mod.PLAYER.BRIEND then
		return
	end

	if collectible == mod.ITEM.COLLECTIBLE.GUNSLINGERS_GRIT then
		return
	end

	local item = config:GetCollectible(collectible)
	local isActive = item and item.Type == ItemType.ITEM_ACTIVE

	local mainTwin = player:GetMainTwin()
	mod:TrySwapBriendDataOnEsauJr(mainTwin)
	local pd = mod:GetEntityData(mainTwin)
	if not pd.Briend or pd.BriendSkipItemTransfer then
		return
	end

	if dontStackOverflow then
		dontStackOverflow = false

		if not isActive then
			pd.Briend.PrimaryBriendGetsItem = not pd.Briend.PrimaryBriendGetsItem
		end
		return
	end

	local mainTwin = player:GetMainTwin()
	if not isActive and mod:playerHasBirthcake(mainTwin) then
		local otherTwin = mainTwin:GetOtherTwin()
		local t0, t1 = mainTwin:GetTrinket(0), mainTwin:GetTrinket(1)
		local smelted = mainTwin:GetSmeltedTrinkets()
		if smelted[BirthcakeRebaked.Birthcake.ID].goldenTrinketAmount > 0 then
			mod.IgnoreBriendTrinketResyncing = true
			mainTwin:TryRemoveSmeltedTrinket(BirthcakeRebaked.Birthcake.ID + TrinketType.TRINKET_GOLDEN_FLAG)
			mainTwin:AddSmeltedTrinket(BirthcakeRebaked.Birthcake.ID)
			otherTwin:TryRemoveSmeltedTrinket(BirthcakeRebaked.Birthcake.ID + TrinketType.TRINKET_GOLDEN_FLAG)
			otherTwin:AddSmeltedTrinket(BirthcakeRebaked.Birthcake.ID)
			mod.IgnoreBriendTrinketResyncing = false
		elseif smelted[BirthcakeRebaked.Birthcake.ID].trinketAmount > 0 then
			mod.IgnoreBriendTrinketResyncing = true
			mainTwin:TryRemoveSmeltedTrinket(BirthcakeRebaked.Birthcake.ID)
			otherTwin:TryRemoveSmeltedTrinket(BirthcakeRebaked.Birthcake.ID)
			mod.IgnoreBriendTrinketResyncing = false
		elseif t0 == BirthcakeRebaked.Birthcake.ID + TrinketType.TRINKET_GOLDEN_FLAG or t1 == BirthcakeRebaked.Birthcake.ID + TrinketType.TRINKET_GOLDEN_FLAG then
			mod.IgnoreBriendTrinketResyncing = true
			mainTwin:TryRemoveTrinket(BirthcakeRebaked.Birthcake.ID + TrinketType.TRINKET_GOLDEN_FLAG)
			mainTwin:AddTrinket(BirthcakeRebaked.Birthcake.ID)
			otherTwin:TryRemoveTrinket(BirthcakeRebaked.Birthcake.ID + TrinketType.TRINKET_GOLDEN_FLAG)
			otherTwin:AddTrinket(BirthcakeRebaked.Birthcake.ID)
			mod.IgnoreBriendTrinketResyncing = false
		else
			mod.IgnoreBriendTrinketResyncing = true
			mainTwin:TryRemoveTrinket(BirthcakeRebaked.Birthcake.ID)
			otherTwin:TryRemoveTrinket(BirthcakeRebaked.Birthcake.ID)
			mod.IgnoreBriendTrinketResyncing = false
		end

		local otherTwin = player:GetOtherTwin()

		mod.BriendIgnorePassing = true
		dontStackOverflow = true
		otherTwin:AddCollectible(collectible, charge, firstTime, slot, varData)
		mod.BriendIgnorePassing = false
		pd.Briend.PrimaryBriendGetsItem = not pd.Briend.PrimaryBriendGetsItem
		return
	end

	local transferItem = false
	-- Actives always go to the main Briend
	if item and item.Type == ItemType.ITEM_ACTIVE and mod:IsBriendTwin(player) then
		transferItem = true
		dontStackOverflow = true
	-- If the twin but the item should be going to the main
	elseif not briendDebugMode and mod:IsBriendTwin(player) and pd.Briend.PrimaryBriendGetsItem then
		transferItem = true
	-- If the main but the item should be going to the twin
	elseif not mod:IsBriendTwin(player) and (not pd.Briend.PrimaryBriendGetsItem or briendDebugMode) then
		transferItem = true
	end

	if transferItem then
		local otherTwin = player:GetOtherTwin()

		-- If a health up, make sure the health goes to the right character
		mod.BriendIgnorePassing = true
		otherTwin:AddCollectible(collectible, charge, firstTime, slot, varData)
		mod.BriendIgnorePassing = false

		return false
	elseif not isActive then
		pd.Briend.PrimaryBriendGetsItem = not pd.Briend.PrimaryBriendGetsItem
	end

	-- If a health up, make sure the health goes to the right character
	mod.BriendIgnorePassing = true
	avoidRecursion = true
	player:AddCollectible(collectible, charge, firstTime, slot, varData)
	mod.BriendIgnorePassing = false
	avoidRecursion = false
	return false
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_ADD_COLLECTIBLE, -1 * math.huge, mod.BriendTransferItems)

function mod:BriendShareItems(collectible, charge, firstTime, slot, varData, player)
	if player:GetPlayerType() ~= mod.PLAYER.BRIEND then
		return
	end

	-- Give to both
	if config:GetCollectible(collectible):HasCustomTag(mod.BriendSharedTag) then
		local otherTwin = player:GetOtherTwin()
		if not otherTwin then
			-- Probably eden's blessing
			local data = mod:GetEntityData(player)
			data.BriendDelayedSyncedItems = data.BriendDelayedSyncedItems or {}
			data.BriendDelayedSyncedItems[collectible] = (data.BriendDelayedSyncedItems[collectible] or 0) + 1
		else
			mod:AddSharedBriendPassive(otherTwin, collectible)
		end
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, -1 * math.huge, mod.BriendShareItems)

-- Re-implement Battery Pack's full charge for the deagle
function mod:BriendAddBatteryPack(collectible, charge, firstTime, slot, varData, player)
	if player:GetPlayerType() == mod.PLAYER.BRIEND and mod:IsBriendTwin(player) then
		local otherTwin = player:GetOtherTwin()

		for activeSlot = ActiveSlot.SLOT_PRIMARY, ActiveSlot.SLOT_POCKET do
			if otherTwin:AddActiveCharge(100, activeSlot, true, false, false) > 0 then
				break
			end
		end
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, -1 * math.huge, mod.BriendAddBatteryPack, CollectibleType.COLLECTIBLE_BATTERY_PACK)

-- Disable the item transfer stuff before D4 is triggered to avoid weird results.
-- This also runs for D100 and Dice Rooms, because this game is just chill like that.
mod:AddPriorityCallback(ModCallbacks.MC_PRE_USE_ITEM, CallbackPriority.LATE, function(_, _, _, player)
	if player:GetPlayerType() == mod.PLAYER.BRIEND then
		mod:GetEntityData(player:GetMainTwin()).BriendSkipItemTransfer = true
		mod.BriendIgnorePassing = true
	end
end, CollectibleType.COLLECTIBLE_D4)

-- D4 both Briends if used by the player themselves.
function mod:BriendD4Yourself(collectible, rng, player, useFlags, slot)
	if slot > -1 and useFlags & UseFlag.USE_OWNED ~= 0 and player:GetPlayerType() == mod.PLAYER.BRIEND and not mod:IsBriendTwin(player) then
		player:GetOtherTwin():UseActiveItem(CollectibleType.COLLECTIBLE_D4, (useFlags & ~UseFlag.USE_OWNED) | UseFlag.USE_NOANIM, -1)
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_USE_ITEM, CallbackPriority.EARLY, mod.BriendD4Yourself, CollectibleType.COLLECTIBLE_D4)
mod:AddPriorityCallback(ModCallbacks.MC_USE_ITEM, CallbackPriority.EARLY, mod.BriendD4Yourself, CollectibleType.COLLECTIBLE_D100)

function mod:BriendTriggerCollectibleRemoved(player, collectible, removeFromPlayerForm, wispOrInnate)
	if player:GetPlayerType() ~= mod.PLAYER.BRIEND then
		return
	end

	if not wispOrInnate and config:GetCollectible(collectible):HasCustomTag(mod.BriendSharedTag) then
		local data = mod:GetEntityData(player)
		if data.BriendDelayedSyncedItems and data.BriendDelayedSyncedItems[collectible] then
			data.BriendDelayedSyncedItems[collectible] = data.BriendDelayedSyncedItems[collectible] - 1
			if data.BriendDelayedSyncedItems[collectible] <= 0 then
				data.BriendDelayedSyncedItems[collectible] = nil
			end
		elseif player:GetOtherTwin() then
			mod:RemoveSharedBriendPassive(player:GetOtherTwin(), collectible)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, mod.BriendTriggerCollectibleRemoved)

-- Fix a quirk with book of virtues synced from the twin
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_ADDED, function(_, player, _, _, wispOrInnate)
	if wispOrInnate and player:GetPlayerType() == mod.PLAYER.BRIEND and not mod:IsBriendTwin(player) then
		mod:GetEntityData(player).BriendFixBookOfVirtuesCharge = true
	end
end, CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES)

local function AllowInnateSync(collectible, groupKey)
	if groupKey == mod.DiscInnateGroup then
		-- Apply disc effects to both Briends. Use the same logic as for wisps.
		return AllowWispSharing(collectible)
	end
	return groupKey ~= mod.BriendSharedLooseInnateGroup and groupKey ~= mod.BriendSharedInnateGroup and groupKey ~= mod.BriendSharedWispInnateGroup
		and config:GetCollectible(collectible):HasCustomTag(mod.BriendSharedTag)
end

---@param player EntityPlayer
function mod:BriendSyncInnateCollectibleAdd(player, collectible, groupKey, amount, duration)
	if player:GetPlayerType() == mod.PLAYER.BRIEND and AllowInnateSync(collectible, groupKey) then
		if groupKey == "" then
			mod:GetEntityData(player).BriendGrouplessInnatesSynced = false
		else
			mod:AddSharedBriendPassive(player:GetOtherTwin(), collectible, amount)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_ADD_INNATE_COLLECTIBLE, mod.BriendSyncInnateCollectibleAdd)

---@param player EntityPlayer
function mod:BriendSyncInnateCollectibleRemove(player, collectible, groupKey, amount, duration)
	if player:GetPlayerType() == mod.PLAYER.BRIEND and AllowInnateSync(collectible, groupKey) then
		if groupKey == "" then
			mod:GetEntityData(player).BriendGrouplessInnatesSynced = false
		else
			mod:RemoveSharedBriendPassive(player:GetOtherTwin(), collectible, amount)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_REMOVE_INNATE_COLLECTIBLE, mod.BriendSyncInnateCollectibleRemove)

function mod:BriendSyncItemWispAdd(familiar)
	local player = familiar.Player
	if player and player:GetPlayerType() == mod.PLAYER.BRIEND then
		mod:GetEntityData(player).BriendWispsSynced = false
	end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, mod.BriendSyncItemWispAdd, FamiliarVariant.ITEM_WISP)

function mod:BriendSyncItemWispRemove(entity)
	if entity.Variant == FamiliarVariant.ITEM_WISP then
		local familiar = entity:ToFamiliar()
		local player = familiar.Player
		if player and player:GetPlayerType() == mod.PLAYER.BRIEND then
			mod:GetEntityData(player).BriendWispsSynced = false
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, mod.BriendSyncItemWispRemove, EntityType.ENTITY_FAMILIAR)

local changingTrinkets = false
-- Both players should be effected by trinkets
---@param player EntityPlayer
function mod:BriendSyncTrinketsAdd(player, trinketType, firstTime)
	if player:GetPlayerType() ~= mod.PLAYER.BRIEND then
		return
	end

	if not config:GetTrinket(trinketType):HasCustomTag(mod.BriendSharedTag) then
		return
	end

	if changingTrinkets or mod.IgnoreBriendTrinketResyncing then
		changingTrinkets = false
		return
	end

	changingTrinkets = true

	local otherTwin = player:GetOtherTwin()
	otherTwin:AddTrinket(trinketType, firstTime)

	local slot = FiendFolio.GetTrinketSlot(otherTwin, trinketType)

	if mod:IsPlayerTrinketBlasphemous(player, slot) then
		mod:MakePlayerTrinketBlasphemous(otherTwin, slot)
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, -1 * math.huge, mod.BriendSyncTrinketsAdd)

---@param player EntityPlayer
function mod:BriendSyncTrinketsRemove(player, trinketType)
	if player:GetPlayerType() ~= mod.PLAYER.BRIEND then
		return
	end

	if not config:GetTrinket(trinketType):HasCustomTag(mod.BriendSharedTag) then
		return
	end

	if changingTrinkets or mod.IgnoreBriendTrinketResyncing then
		changingTrinkets = false
		return
	end

	changingTrinkets = true

	local otherTwin = player:GetOtherTwin()
	otherTwin:TryRemoveTrinket(trinketType)
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, -1 * math.huge, mod.BriendSyncTrinketsRemove)

local changingTempEffect = false
-- Likewise, both players should be effected by null effects
---@param player EntityPlayer
---@param configItem ItemConfigItem
function mod:BriendSyncTempEffectAdd(player, configItem, addCostume, count)
	if player:GetPlayerType() ~= mod.PLAYER.BRIEND then
		return
	end

	if changingTempEffect then
		changingTempEffect = false
		return
	end

	local otherTwin = player:GetOtherTwin()
	if not otherTwin then
		-- Eden's Blessing or some shit
		return
	end

	local effects = otherTwin:GetEffects()

	-- If they both get the lost curse, you lose it next room?????
	if configItem:IsNull() and mod.BriendNullSyncWhitelist[configItem.ID] then
		changingTempEffect = true
		effects:AddNullEffect(configItem.ID, addCostume, count)
	elseif configItem.Type == ItemType.ITEM_ACTIVE and not mod.BriendActiveSyncBlacklist[configItem.ID] then
		changingTempEffect = true
		effects:AddCollectibleEffect(configItem.ID, addCostume, count)
	elseif configItem:IsCollectible() and configItem.ID == CollectibleType.COLLECTIBLE_TAURUS then
		local eff = player:GetEffects():GetCollectibleEffect(CollectibleType.COLLECTIBLE_TAURUS)
		if eff and eff.Cooldown > 0 then
			changingTempEffect = true
			otherTwin:AddCollectibleEffect(CollectibleType.COLLECTIBLE_TAURUS, true, eff.Cooldown, false)
		end
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_PLAYER_ADD_EFFECT, -1 * math.huge, mod.BriendSyncTempEffectAdd)

---@param player EntityPlayer
---@param configItem ItemConfigItem
function mod:BriendSyncTempEffectRemove(player, configItem, count)
	if player:GetPlayerType() ~= mod.PLAYER.BRIEND then
		return
	end

	if changingTempEffect then
		changingTempEffect = false
		return
	end

	local otherTwin = player:GetOtherTwin()
	if not otherTwin then
		return
	end

	local effects = otherTwin:GetEffects()
	if configItem:IsNull() and mod.BriendNullSyncWhitelist[configItem.ID] then
		changingTempEffect = true
		effects:RemoveNullEffect(configItem.ID, count)
	elseif configItem.Type == ItemType.ITEM_ACTIVE then
		changingTempEffect = true
		effects:RemoveCollectibleEffect(configItem.ID, count)
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_PLAYER_TRIGGER_EFFECT_REMOVED, -1 * math.huge, mod.BriendSyncTempEffectRemove)

local gettingBasePillEffect = false

-- Fix the behaviour of Bad Trip and Health Down for Briend.
-- Whether or not the pill transforms into their good counterpart must depend solely on the selected twin.
function mod:BriendGetPillEffect(pillEffect, pillColor, player)
	if not gettingBasePillEffect and player and player:GetPlayerType() == mod.PLAYER.BRIEND then
		if not mod:IsSelectedBriend(player) then
			player = player:GetOtherTwin() or player
		end

		-- Call GetPillEffect with no player to get the baseline effect.
		gettingBasePillEffect = true
		local basePillEffect = game:GetItemPool():GetPillEffect(pillColor)
		gettingBasePillEffect = false

		if basePillEffect == PillEffect.PILLEFFECT_BAD_TRIP then
			local hp = CustomHealthAPI.Helper.GetTotalHP(player)
			if pillEffect == PillEffect.PILLEFFECT_BAD_TRIP and hp <= 2 then
				return PillEffect.PILLEFFECT_FULL_HEALTH
			elseif pillEffect == PillEffect.PILLEFFECT_FULL_HEALTH and hp > 2 then
				return PillEffect.PILLEFFECT_BAD_TRIP
			end
		elseif basePillEffect == PillEffect.PILLEFFECT_HEALTH_DOWN then
			local maxHearts = CustomHealthAPI.Helper.GetTotalMaxHP(player)
			if pillEffect == PillEffect.PILLEFFECT_HEALTH_DOWN and maxHearts <= 2 then
				return PillEffect.PILLEFFECT_HEALTH_UP
			elseif pillEffect == PillEffect.PILLEFFECT_HEALTH_UP and maxHearts > 2 then
				return PillEffect.PILLEFFECT_HEALTH_DOWN
			end
		end
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_GET_PILL_EFFECT, CallbackPriority.EARLY, mod.BriendGetPillEffect, PillEffect.PILLEFFECT_BAD_TRIP)
mod:AddPriorityCallback(ModCallbacks.MC_GET_PILL_EFFECT, CallbackPriority.EARLY, mod.BriendGetPillEffect, PillEffect.PILLEFFECT_FULL_HEALTH)
mod:AddPriorityCallback(ModCallbacks.MC_GET_PILL_EFFECT, CallbackPriority.EARLY, mod.BriendGetPillEffect, PillEffect.PILLEFFECT_HEALTH_DOWN)
mod:AddPriorityCallback(ModCallbacks.MC_GET_PILL_EFFECT, CallbackPriority.EARLY, mod.BriendGetPillEffect, PillEffect.PILLEFFECT_HEALTH_UP)

local oldPillRNG
local dontLoopPills = false
---@param player EntityPlayer
function mod:BriendSyncPillStats(effect, player, flags, color)
	if player:GetPlayerType() ~= mod.PLAYER.BRIEND or dontLoopPills then
		return
	end

	if mod.BriendPillSyncWhitelist[effect] then
		local otherTwin = player:GetOtherTwin()
		dontLoopPills = true
		if oldPillRNG then
			otherTwin:GetPillRNG(effect):SetSeed(oldPillRNG[1], oldPillRNG[2])
			oldPillRNG = nil
		end
		mod.BriendIgnorePassing = true
		otherTwin:UsePill(effect, color, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOHUD)
		dontLoopPills = false
		if effect == PillEffect.PILLEFFECT_EXPERIMENTAL then
			CustomHealthAPI.Helper.ResyncHealthOfPlayer(player)
			CustomHealthAPI.Helper.ResyncHealthOfPlayer(otherTwin)
		end
		mod.BriendIgnorePassing = false
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_USE_PILL, CallbackPriority.LATE, mod.BriendSyncPillStats)

function mod:BriendPreUsePill(effect, color, player, flags)
	if player:GetPlayerType() ~= mod.PLAYER.BRIEND or dontLoopPills then
		return
	end

	if mod.BriendPillSyncWhitelist[effect] then
		local rng = player:GetPillRNG(effect)
		oldPillRNG = {rng:GetSeed(), rng:GetShiftIdx()}
	end

	if effect == PillEffect.PILLEFFECT_EXPERIMENTAL then
		local otherTwin = player:GetOtherTwin()
		CustomHealthAPI.Helper.ResyncHealthOfPlayer(player)
		CustomHealthAPI.Helper.ResyncHealthOfPlayer(otherTwin)
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_USE_PILL, CallbackPriority.LATE + 1, mod.BriendPreUsePill)

local dontLoopCards = false
---@param player EntityPlayer
function mod:BriendPreUseCard(effect, player, flags)
	if player:GetPlayerType() ~= mod.PLAYER.BRIEND or dontLoopCards then
		return
	end

	if mod.BriendCardPassWhitelist[effect] and not mod:IsSelectedBriend(player) then
		local otherTwin = player:GetOtherTwin()
		dontLoopCards = true
		otherTwin:UseCard(effect, flags)
		dontLoopCards = false
		if flags & UseFlag.USE_NOANIM == 0 and mod:IsBriendTwin(otherTwin) and otherTwin:IsHoldingItem() then
			player:AnimateCard(effect, "UseItem")
		end
		return true
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_USE_CARD, CallbackPriority.LATE, mod.BriendPreUseCard)

function mod:BriendUseCard(effect, player, flags)
	if player:GetPlayerType() ~= mod.PLAYER.BRIEND or dontLoopCards then
		return
	end

	if mod.BriendCardSyncWhitelist[effect] then
		local otherTwin = player:GetOtherTwin()
		dontLoopCards = true
		otherTwin:UseCard(effect, flags | UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOHUD)
		dontLoopCards = false
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_USE_CARD, CallbackPriority.LATE, mod.BriendUseCard)

-- Track pill stat changes manually (necessary because of experimental pill and phd stuff)
local propertyToCache = {
	MaxFireDelay = CacheFlag.CACHE_FIREDELAY,
	Damage = CacheFlag.CACHE_DAMAGE,
	TearRange = CacheFlag.CACHE_RANGE,
	ShotSpeed = CacheFlag.CACHE_SHOTSPEED,
	Luck = CacheFlag.CACHE_LUCK,
}

local avoidLoop = false
---@param player EntityPlayer
function mod:BriendSyncStats(player, flag)
	if player:GetPlayerType() ~= mod.PLAYER.BRIEND then
		return
	end

	local twin = player:GetOtherTwin()
	mod:TrySwapBriendDataOnEsauJr(player)
	mod:TrySwapBriendDataOnEsauJr(twin)
	local pd = mod:GetEntityData(player)

	local cacheFlagsForTwin = 0

	-- If one has flying, both should
	if (
		twin
		and flag == CacheFlag.CACHE_FLYING
		and player.CanFly ~= twin.CanFly
		and not pd.SyncingFlight
		and not player:HasCurseMistEffect() -- Flight is weird in cursed mist even in vanilla, just dont sync during it
 	) then
		local twinData = mod:GetEntityData(twin)
		-- Add flight to twin
		twinData.SyncingFlight = player.CanFly
		cacheFlagsForTwin = cacheFlagsForTwin | CacheFlag.CACHE_FLYING
	end

	if flag == CacheFlag.CACHE_FLYING and pd.SyncingFlight then
		pd.SyncingFlight = nil
		player.CanFly = true
	end

	if flag == CacheFlag.CACHE_COLOR and twin and pd.Briend then
		local twinData = mod:GetEntityData(twin)
		if twinData.Briend then
			pd.Briend.LastChangedColor = player.FrameCount

			if not twinData.Briend.LastChangedColor or pd.Briend.LastChangedColor > twinData.Briend.LastChangedColor then
				twin:AddCacheFlags(CacheFlag.CACHE_COLOR, true)
			else
				player.Color = twin.Color
				player:GetSprite().Color = twin:GetSprite().Color
			end
		end
	end

	if flag == CacheFlag.CACHE_LUCK and player:HasCollectible(CollectibleType.COLLECTIBLE_EVIL_CHARM) then
		local numSharedEvilCharms = player:GetInnateCollectibleCount(CollectibleType.COLLECTIBLE_EVIL_CHARM, mod.BriendSharedInnateGroup)
			+ player:GetInnateCollectibleCount(CollectibleType.COLLECTIBLE_EVIL_CHARM, mod.BriendSharedLooseInnateGroup)
			+ player:GetInnateCollectibleCount(CollectibleType.COLLECTIBLE_EVIL_CHARM, mod.BriendSharedWispInnateGroup)
		player.Luck = player.Luck - 2 * numSharedEvilCharms
	end

	if twin and flag == CacheFlag.CACHE_SIZE then
		if mod:IsBriendTwin(player) then
			mod:GetEntityData(player).BriendTwinScale = player.SpriteScale
			player.SpriteScale = twin.SpriteScale
			cacheFlagsForTwin = cacheFlagsForTwin | CacheFlag.CACHE_SIZE
		elseif mod:GetEntityData(twin).BriendTwinScale then
			player.SpriteScale = player.SpriteScale * mod:GetEntityData(twin).BriendTwinScale
			twin.SpriteScale = player.SpriteScale
		end
	end

	if mod:IsBriendTwin(player) then
		if flag == CacheFlag.CACHE_SPEED then
			-- The twin's speed is calculated normally (so it is available in this callback),
			-- but the game will overwrite it with the main twin's speed afterwards.
			-- Store the twin's offset from their base MoveSpeed (1.0) so we can apply it to the main twin.
			-- Subtract speed gained from collectible/null effects that are shared with both twins.
			local previousSpeedOffset = pd.BriendTwinMoveSpeedOffset or 0
			pd.BriendTwinMoveSpeedOffset = (player.MoveSpeed - 1) - GetBriendSharedSpeed(player)
			if pd.BriendTwinMoveSpeedOffset ~= previousSpeedOffset then
				cacheFlagsForTwin = cacheFlagsForTwin | CacheFlag.CACHE_SPEED
			end
		end

		if flag == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage + mod:GetNumBlasphemousTrinkets(twin)
		end

		-- If the twin, add the stat changes from pills and other things
		local save = pd.ffsavedata
		if save.BriendTwinSyncStats then
			for var, change in pairs(save.BriendTwinSyncStats) do
				if propertyToCache[var] == flag then
					player[var] = player[var] + change
				end
			end
		end
	elseif player:GetPlayerType() == mod.PLAYER.BRIEND then

		if twin then
			if flag == CacheFlag.CACHE_SPEED then
				local twinData = mod:GetEntityData(twin)
				player.MoveSpeed = player.MoveSpeed + (twinData.BriendTwinMoveSpeedOffset or 0)
			end
			-- Fix familiars
			-- Twin can be nil on player first init
			if flag == CacheFlag.CACHE_FAMILIARS then
				cacheFlagsForTwin = cacheFlagsForTwin | CacheFlag.CACHE_FAMILIARS
			end
		end
	end

	if twin and cacheFlagsForTwin > 0 then
		if avoidLoop then
			mod:GetEntityData(twin).BriendDelayedEvaluateItems = cacheFlagsForTwin
		else
			avoidLoop = true
			twin:AddCacheFlags(cacheFlagsForTwin, true)
			avoidLoop = false
		end
	end
end
mod:AddPriorityManualCallback(ModCallbacks.MC_EVALUATE_CACHE, math.huge, mod.BriendSyncStats)

function mod:BriendEnableManualCallbacks()
	if PlayerManager.AnyoneIsPlayerType(mod.PLAYER.BRIEND) then
		mod:EnableManualCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.BriendSyncStats)
		mod:EnableManualCallback(ModCallbacks.MC_PRE_FAMILIAR_UPDATE, mod.BriendCorrectFamiliars)
		mod:EnableManualCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.BriendUncorrectFamiliars)
		mod:EnableManualCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.GunAboveHeadFailsafe)
	else
		mod:DisableManualCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.BriendSyncStats)
		mod:DisableManualCallback(ModCallbacks.MC_PRE_FAMILIAR_UPDATE, mod.BriendCorrectFamiliars)
		mod:DisableManualCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.BriendUncorrectFamiliars)
		mod:DisableManualCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.GunAboveHeadFailsafe)
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_ROOM_EXIT, mod.BriendEnableManualCallbacks)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.BriendEnableManualCallbacks)
if Isaac.IsInGame() then mod:BriendEnableManualCallbacks() end  -- luamod

---@param config ItemConfigItem
---@param player EntityPlayer
function mod:BriendSyncCostumeAdd(config, player, itemStateOnly)
	if mod:IsBriendTwin(player) then
		local main = player:GetMainTwin()
		main:AddCostume(config, itemStateOnly)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_ADD_COSTUME, mod.BriendSyncCostumeAdd)

---@param player EntityPlayer
function mod:BriendSyncCostumeRemove(config, player)
	if mod:IsBriendTwin(player) then
		local main = player:GetMainTwin()
		main:RemoveCostume(config)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_REMOVE_COSTUME, mod.BriendSyncCostumeRemove)

function mod:CancelBriendBomb(player)
	if mod:IsBriendTwin(player) then
		return false
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_USE_BOMB, mod.CancelBriendBomb)

function mod:CancelBriendRenderTrinket(_, _, _, player)
	if mod:IsBriendTwin(player) then
		return true
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_TRINKET_RENDER, mod.CancelBriendRenderTrinket)

function mod:CancelBriendRenderActive(player)
	if mod:IsBriendTwin(player) then
		return true
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_ACTIVE_ITEM, mod.CancelBriendRenderActive)

local noinfiniteloopskthankyou = false

function mod:PassBriendActive(id, rng, player, flags, slot, vardata)
	if player:GetPlayerType() == mod.PLAYER.BRIEND then
		if mod.BriendActiveOnSelectedGunWhitelist[id] and not mod:IsSelectedBriend(player) then
			local otherTwin = player:GetOtherTwin()
			otherTwin:UseActiveItem(id, flags, slot, vardata)
			if flags & UseFlag.USE_NOANIM == 0 and mod:IsBriendTwin(otherTwin) and otherTwin:IsHoldingItem() then
				player:AnimateCollectible(id, "UseItem")
			end
			return true

		elseif mod.BriendActiveOnBothGunsWhitelist[id] and not noinfiniteloopskthankyou then
			local otherTwin = player:GetOtherTwin()
			if mod:IsBriendTwin(otherTwin) then
				flags = flags | UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOHUD
			end
			noinfiniteloopskthankyou = true
			otherTwin:UseActiveItem(id, flags, slot, vardata)
			noinfiniteloopskthankyou = false
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, mod.PassBriendActive)

mod:AddCallback(CustomHealthAPI.Enums.Callbacks.PRE_YUM_HEART_HEAL, function(_, player)
    if not mod:IsSelectedBriend(player) then
		return true
    end
end, FiendFolio.PLAYER.BRIEND)

function mod:ResetBriendDamageCooldownOnActiveUse(id, rng, player)
	-- these items already do this but also need to do it for the othertwin to bypass the iframe failsafe
	-- otherwise you can use these items for free during iframes
	if player:GetPlayerType() == FiendFolio.PLAYER.BRIEND then
		player:ResetDamageCooldown()
		player:GetOtherTwin():ResetDamageCooldown()
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_USE_ITEM, math.huge, mod.ResetBriendDamageCooldownOnActiveUse, CollectibleType.COLLECTIBLE_RAZOR_BLADE)
mod:AddPriorityCallback(ModCallbacks.MC_PRE_USE_ITEM, math.huge, mod.ResetBriendDamageCooldownOnActiveUse, CollectibleType.COLLECTIBLE_IV_BAG)
mod:AddPriorityCallback(ModCallbacks.MC_PRE_USE_ITEM, math.huge, mod.ResetBriendDamageCooldownOnActiveUse, CollectibleType.COLLECTIBLE_BLOOD_RIGHTS)

function mod:HandleHealthCheckingActivesOnBriend(player)
	if Input.IsActionTriggered(ButtonAction.ACTION_ITEM, player.ControllerIndex) and not mod:IsBriendTwin(player) and not mod:IsSelectedBriend(player) then
		local active = player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)
		local otherTwin = player:GetOtherTwin()
		if (active == CollectibleType.COLLECTIBLE_GUPPYS_PAW or active == CollectibleType.COLLECTIBLE_POTATO_PEELER) and CustomHealthAPI.Helper.GetTotalMaxHP(player) <= 0 then
			otherTwin:UseActiveItem(active, UseFlag.USE_OWNED, ActiveSlot.SLOT_PRIMARY)
		end
	end
end


-- Special handling for Void: Only run as main twin, but pass stats to selected twin.
-- Always running as the main twin is so so that voided actives are tracked properly.
-- (Thats why Void isn't just on the BriendActiveOnSelectedGunWhitelist.)
local StatModifiers = {
	"Speed",
	"FireDelay",
	"Damage",
	"TearRange",
	"ShotSpeed",
	"Luck",
}

local function GetStatModifier(name, player)
	return player["Get"..name.."Modifier"](player)
end

local function SetStatModifier(name, player, modifier)
	return player["Set"..name.."Modifier"](player, modifier)
end

local function GetStatModifiers(player)
	local tab = {}
	for _, name in ipairs(StatModifiers) do
		tab[name] = GetStatModifier(name, player)
	end
	return tab
end

local function PassStatModifiers(player, twin, oldModifiers)
	local newModifiers = GetStatModifiers(player)
	local twinModifiers = GetStatModifiers(twin)
	for _, name in ipairs(StatModifiers) do
		local oldMod = oldModifiers[name]
		local newMod = newModifiers[name]
		local twinMod = twinModifiers[name]
		local diff = newMod - oldMod
		if diff ~= 0 then
			SetStatModifier(name, player, oldMod)
			SetStatModifier(name, twin, twinMod + diff)
		end
	end
	player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
	twin:AddCacheFlags(CacheFlag.CACHE_ALL, true)
end

mod:AddPriorityCallback(ModCallbacks.MC_PRE_USE_ITEM, math.huge, function(_, id, rng, player, flags, slot, vardata)
	if player:GetPlayerType() ~= FiendFolio.PLAYER.BRIEND then return end

	local twin = player:GetOtherTwin()

	if mod:IsBriendTwin(player) then
		twin:UseActiveItem(id, flags, slot, vardata)
		return true
	end

	if not mod:IsSelectedBriend(player) then
		local preStatModifiers = GetStatModifiers(player)
		preStatModifiers.Frame = game:GetFrameCount()
		mod:GetEntityData(player).BriendPreVoidStatModifiers = preStatModifiers
	end
end, CollectibleType.COLLECTIBLE_VOID)

mod:AddPriorityCallback(ModCallbacks.MC_USE_ITEM, CallbackPriority.EARLY, function(_, id, rng, player, flags, slot, vardata)
	if player:GetPlayerType() ~= FiendFolio.PLAYER.BRIEND then return end

	if not mod:IsBriendTwin(player) and not mod:IsSelectedBriend(player) then
		local data = mod:GetEntityData(player)
		if data.BriendPreVoidStatModifiers then
			if data.BriendPreVoidStatModifiers.Frame == game:GetFrameCount() then
				PassStatModifiers(player, player:GetOtherTwin(), data.BriendPreVoidStatModifiers)
			end
			data.BriendPreVoidStatModifiers = nil
		end
	end
end, CollectibleType.COLLECTIBLE_VOID)

-- Briend is slightly offset on floor transition due to how the game positions players with twins
-- Just manually set the position for player one only (co-op Briends are fine and not worth fixing)
function mod:BriendFixFloorTransitionOffset(isContinue)
	local playerOne = Isaac.GetPlayer(0)

	if playerOne:GetPlayerType() == mod.PLAYER.BRIEND and not isContinue then
		local room = game:GetRoom()

		if game:IsGreedMode() then
			playerOne.Position = room:GetGridPosition(67)
		else
			local level = game:GetLevel()
			if level:GetStage() == LevelStage.STAGE1_1 and level:GetStageType() <= StageType.STAGETYPE_REPENTANCE then
				playerOne.Position = room:GetGridPosition(97) + Vector(0, 20)
			else
				playerOne.Position = room:GetCenterPos()
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.BriendFixFloorTransitionOffset)
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.BriendFixFloorTransitionOffset)

-- It shows "Friend + Friend" against minibosses, fix this
local preventInfinite = false
---@param title string
function mod:FixItemTextDisplay(title, subtitle, isSticky, isCurseDisplay)
	if not PlayerManager.AnyoneIsPlayerType(mod.PLAYER.BRIEND) then
		return
	end

	if preventInfinite then
		preventInfinite = false
	else
		local fixedText = title
		fixedText = fixedText:gsub("%+Friend", "")
		if fixedText ~= title then
			preventInfinite = true
			game:GetHUD():ShowItemText(fixedText, subtitle, isCurseDisplay, true)
			return false
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_ITEM_TEXT_DISPLAY, mod.FixItemTextDisplay)

-- Temporary measure because we can't set EntityCollisionClass to none on the twin player.
-- If we do, they no longer detect shooting input.....????????
function mod:BriendCancelCollision(_, collider)
	if collider.Type == 1 then
		if mod:IsBriendTwin(collider:ToPlayer()) then
			return true
		end
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, -1 * math.huge, mod.BriendCancelCollision)
mod:AddPriorityCallback(ModCallbacks.MC_PRE_NPC_COLLISION, -1 * math.huge, mod.BriendCancelCollision)
mod:AddPriorityCallback(ModCallbacks.MC_PRE_BOMB_COLLISION, -1 * math.huge, mod.BriendCancelCollision)
mod:AddPriorityCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, -1 * math.huge, mod.BriendCancelCollision)
mod:AddPriorityCallback(ModCallbacks.MC_PRE_KNIFE_COLLISION, -1 * math.huge, mod.BriendCancelCollision)
mod:AddPriorityCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, -1 * math.huge, mod.BriendCancelCollision)
mod:AddPriorityCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, -1 * math.huge, mod.BriendCancelCollision)
mod:AddPriorityCallback(ModCallbacks.MC_PRE_LASER_COLLISION, -1 * math.huge, mod.BriendCancelCollision)

function mod:CanBriendPickupWhileNearbyItem(pickup, player)
	local vanillaChestsToOpen = {
		[PickupVariant.PICKUP_CHEST] = true,
		[PickupVariant.PICKUP_SPIKEDCHEST] = true,
		[PickupVariant.PICKUP_ETERNALCHEST] = true,
		[PickupVariant.PICKUP_MIMICCHEST] = true,
		[PickupVariant.PICKUP_OLDCHEST] = true,
		[PickupVariant.PICKUP_WOODENCHEST] = true,
		[PickupVariant.PICKUP_MEGACHEST] = true,
		[PickupVariant.PICKUP_LOCKEDCHEST] = true,
		[PickupVariant.PICKUP_BIGCHEST] = true,
		[PickupVariant.PICKUP_REDCHEST] = true,
		[PickupVariant.PICKUP_MOMSCHEST] = true,
	}

	return (
		(
			not pickup:IsShopItem()
			or mod.WillPlayerBuyPickup(player, pickup)
		)
		and (
			pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE
			or vanillaChestsToOpen[pickup.Variant]
			or pickup.Variant == PickupVariant.PICKUP_TRINKET
			or pickup.Variant == PickupVariant.PICKUP_TAROTCARD
			or pickup.Variant == PickupVariant.PICKUP_PILL
			or pickup:IsShopItem()
		)
		and pickup.SubType > 0
		and player:GetPlayerType() == mod.PLAYER.BRIEND
		and pickup.Wait == 0
	)
end

function mod:BriendControlPickupCollision(pickup, collider, low)
	if collider.Type == 1 then
		local player = collider:ToPlayer()

		if player:GetPlayerType() ~= FiendFolio.PLAYER.BRIEND then return end

		mod:TrySwapBriendDataOnEsauJr(player)

		if player:GetOtherTwin():IsHoldingItem() then
			return pickup:IsShopItem()
		end

		if pickup.Variant == PickupVariant.PICKUP_TAROTCARD or pickup.Variant == PickupVariant.PICKUP_PILL or pickup.Variant == PickupVariant.PICKUP_LIL_BATTERY or pickup.Variant == PickupVariant.PICKUP_TRINKET then
			if mod:IsBriendTwin(player) then
				return true
			end
		elseif mod:IsHeartPickup(pickup) or pickup.Price == -5 then
			if not mod:IsSelectedBriend(player) then
				return true
			end

			return
		end

		if mod:IsBriendTwin(player) then
			-- if the revolver cant buy a deal then it wont be purchased, even if the deagle can afford it
			-- allow the deagle to collide and subsequently purchase a deal if can afford
			if (
				mod:IsSelectedBriend(player)
				and (
					pickup:IsShopItem()
					and mod.IsDevilDeal(pickup.Price)
					and mod.CanAffordPrice(player, pickup.Price)
				)
			) then
				return
			end

			if pickup.Position:Distance(player.Position) > player.Size + pickup.Size then
				-- Probably forced collision. Pass it to the main player.
				local mainTwin = player:GetMainTwin()
				mainTwin:ForceCollide(pickup)
			end
			return true

		elseif mod:CanBriendPickupWhileNearbyItem(pickup, player) then
			if (
				not mod:IsSelectedBriend(player)
				and pickup:IsShopItem()
				and mod.IsDevilDeal(pickup.Price)
			) then
				return true
			end
		end
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, -1 * math.huge, mod.BriendControlPickupCollision)

function mod:BriendControlPickupCollision2(pickup, collider, low)
	if collider.Type == 1 then
		local player = collider:ToPlayer()

		mod:TrySwapBriendDataOnEsauJr(player)
		local data = mod:GetEntityData(player)

		if pickup.Variant == PickupVariant.PICKUP_TAROTCARD or pickup.Variant == PickupVariant.PICKUP_PILL or pickup.Variant == PickupVariant.PICKUP_LIL_BATTERY or pickup.Variant == PickupVariant.PICKUP_TRINKET then
			if pickup.Price == -5 and not mod:IsSelectedBriend(player) then
				local data = CustomHealthAPI.Helper.GetEntityData(pickup)
				local shouldCancelFromAnim = not player:IsExtraAnimationFinished()
				if not data.CHAPIHeartPickupSpentSpikesCostAlready
				and not CustomHealthAPI.Helper.PlayerIsHealthless(player)
				and not player:GetEffects():HasNullEffect(NullItemID.ID_LOST_CURSE)
				and not player:TakeDamage(2, DamageFlag.DAMAGE_SPIKES | DamageFlag.DAMAGE_NO_PENALTIES, EntityRef(nil), 30) then
					return true
				elseif shouldCancelFromAnim then
					return true
				end
				data.CHAPIHeartPickupSpentSpikesCostAlready = true
				pickup.AutoUpdatePrice = false
				pickup.Price = 0
				Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SHOP_SPIKES, 0, pickup.Position, Vector.Zero, nil)
				Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_PICKUP_SHOP_PURCHASE, pickup.Variant, pickup, player, -5)
			end
		end
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, math.huge, mod.BriendControlPickupCollision2)

-- Make devil deals on the deagle not delete your active item
function mod:BriendBuyDevilDeal(pickup, player, price)
	if mod.IsDevilDeal(price) and mod:IsBriendTwin(player) then
		local twin = player:GetMainTwin()
		local itemConfig = player.QueuedItem.Item

		if itemConfig and itemConfig.Type == ItemType.ITEM_ACTIVE -- The bought item is an active item
		and not twin:CanOverrideActiveItem(ActiveSlot.SLOT_PRIMARY) -- Primary slot isn't free
		and not (twin:HasCollectible(CollectibleType.COLLECTIBLE_SCHOOLBAG) and twin:CanOverrideActiveItem(ActiveSlot.SLOT_SECONDARY)) then -- Doesn't have a secondary slot
			local collectible = twin:GetActiveItem(ActiveSlot.SLOT_PRIMARY)
			twin:DropCollectible(collectible, pickup, true)
		end
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_PICKUP_SHOP_PURCHASE, -1 * math.huge, mod.BriendBuyDevilDeal, PickupVariant.PICKUP_COLLECTIBLE)

-- passing literally any and all health changes from the secondary gun to the primary
mod:AddCallback(CustomHealthAPI.Enums.Callbacks.PRE_ADD_HEALTH, function(_, player, key, hp)
	if not (mod.BriendIgnorePassing or CustomHealthAPI.PersistentData.IsTechnicalAddHealth > 0 or mod:IsSelectedBriend(player)) then
		local otherTwin = player:GetOtherTwin()
		if otherTwin then
			CustomHealthAPI.Library.AddHealth(otherTwin, key, hp)

			return true
		end
	end
end, FiendFolio.PLAYER.BRIEND)

-- passing any checks for alabaster box to the main briend
mod:AddCallback(CustomHealthAPI.Enums.Callbacks.GET_ALABASTER_BOX_OWNER, function(_, player)
	return player:GetMainTwin()
end, FiendFolio.PLAYER.BRIEND)

-- trying to fix hungry stevens without having to update the future
-- ts gonna get weird
local playersToFix = {}
local function loadStevenBeggarFix()
mod:AddPriorityCallback(ModCallbacks.MC_PRE_NPC_UPDATE, math.huge, function(_, npc)
    if npc.Variant == TheFuture.Monsters.HungrySteven.Var then
		local d = mod:GetEntityData(npc)
        for _, player in ipairs(PlayerManager.GetPlayers()) do
			if player:GetPlayerType() == mod.PLAYER.BRIEND then
				local othertwin = player:GetOtherTwin()
				if d.HungryItem and (not player:HasCollectible(d.HungryItem, true) or (othertwin and othertwin:HasCollectible(d.HungryItem, true) and not mod:IsSelectedBriend(player))) then
					table.insert(playersToFix, {Player = player, Position = player.Position})
					player.Position = player.Position + (player.Position - npc.Position):Resized(0.001)
				end
			end
		end
	end
end, TheFuture.Monsters.HungrySteven.ID)

mod:AddPriorityCallback(ModCallbacks.MC_NPC_UPDATE, CallbackPriority.LATE, function(_, npc)
    if npc.Variant == TheFuture.Monsters.HungrySteven.Var then
        for _, playerInfo in ipairs(playersToFix) do
			playerInfo.Player.Position = playerInfo.Position
		end
		playersToFix = {}
	end
end, TheFuture.Monsters.HungrySteven.ID)
end

mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, function()
	if TheFuture then
		loadStevenBeggarFix()
	end
end)
if ModReloadDetector.ModsLoaded then
	if TheFuture then
		loadStevenBeggarFix()
	end
end

-- Ignore passing health changes on new level
-- Fixes edge cases like Reverse Sun health going to the wrong player,
-- as well as things like Dream Catcher going to the active healthbar.
mod:AddPriorityCallback(ModCallbacks.MC_PRE_LEVEL_INIT, -math.huge, function ()
	mod.BriendIgnorePassing = true
end)
mod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_LEVEL, math.huge, function ()
	mod.BriendIgnorePassing = false
end)

mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_ADD_HEARTS, function(_, player, amount, healthtype, optional)
	if not (mod.BriendIgnorePassing or CustomHealthAPI.PersistentData.IsTechnicalAddHealth > 0 or mod:IsSelectedBriend(player)) then
		local otherTwin = player:GetOtherTwin()
		if otherTwin then
			if healthtype == AddHealthType.RED then
				otherTwin:AddHearts(amount)
			elseif healthtype == AddHealthType.MAX then
				otherTwin:AddMaxHearts(amount)
			elseif healthtype == AddHealthType.SOUL then
				otherTwin:AddSoulHearts(amount)
			elseif healthtype == AddHealthType.BLACK then
				otherTwin:AddBlackHearts(amount)
			elseif healthtype == AddHealthType.ETERNAL then
				otherTwin:AddEternalHearts(amount)
			elseif healthtype == AddHealthType.GOLDEN then
				otherTwin:AddGoldenHearts(amount)
			elseif healthtype == AddHealthType.BONE then
				otherTwin:AddBoneHearts(amount)
			elseif healthtype == AddHealthType.ROTTEN then
				otherTwin:AddRottenHearts(amount)
			elseif healthtype == AddHealthType.BROKEN then
				otherTwin:AddBrokenHearts(amount)
			end

			return 0
		end
	end
end)

-- Since Briend's twin is invisible, but Briend themself is technically not, manually run the pre/post player render callbacks for the twin,
-- for the sake of modded code that needs to do things on render, such as custom charge bars.
local BRIEND_PLAYER_RENDER_CALLBACKS = {
	[ModCallbacks.MC_PRE_PLAYER_RENDER] = { ParamIsVariant = true, AddsOffset = true },
	[ModCallbacks.MC_POST_PLAYER_RENDER] = { ParamIsVariant = true },
	[ModCallbacks.MC_PRE_RENDER_PLAYER_BODY] = { ParamIsVariant = false },
	[ModCallbacks.MC_PRE_RENDER_PLAYER_HEAD] = { ParamIsVariant = false },
	[ModCallbacks.MC_POST_RENDER_PLAYER_BODY] = { ParamIsVariant = false },
	[ModCallbacks.MC_POST_RENDER_PLAYER_HEAD] = { ParamIsVariant = false },
}
for callbackid, info in pairs(BRIEND_PLAYER_RENDER_CALLBACKS) do
	mod:AddPriorityCallback(callbackid, CallbackPriority.LATE+1, function(_, player, offset)
		if player:GetPlayerType() == FiendFolio.PLAYER.BRIEND and not mod:IsBriendTwin(player) then
			local twin = player:GetOtherTwin()
			if twin and not twin.Visible then
				local result = Isaac.RunCallbackWithParam(callbackid, info.ParamIsVariant and twin.Variant or twin:GetPlayerType(), twin, offset)
				if info.AddsOffset and type(result) == "userdata" and result.X and result.Y then
					return result - offset
				end
				return result
			end
		end
	end)
end

-- Stats+ handling. i guess.
-- Just disables the tear cap thing they have for Briend
-- https://github.com/aleksander-ciesielski/isaac-stats-plus/issues/31
mod:AddCallback("STATS_PLUS_REGISTER", function (_, api)
	api:register({
		id = "fiend-folio-reloaded",
		name = "Fiend Folio: RELOADED",
		middleware = {
			api:middleware({
				id = "set-tainted-friend-tear-cap-test-collectible-to-nil",
				name = "Set Tainted Friend tear cap test collectible to nil",
				description = "Sets Tainted Friend tear cap test collectible to nil",
				target = {
					provider = {
						addon = "stats-plus-essentials",
						id = "tear-cap-provider",
					},
					computable = "getTearCapTestCollectible",
				},
				priority = 0,
				intercept = function (ctx)
					local player = ctx.args[1]
					return player:GetPlayerType() == mod.PLAYER.BRIEND and ctx.finishWith() or ctx.ignore()
				end
			})
		}
	})
end)