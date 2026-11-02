local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local deckBox = mod.ITEM.COLLECTIBLE.DECK_BOX
local USEFLAGS = UseFlag.USE_NOANIM | UseFlag.USE_MIMIC | UseFlag.USE_NOHUD
local GET_STRING_ERROR_RETURN = "StringTable::InvalidKey"

local MIN_CHANCE = 0.15
local MAX_CHANCE = 0.30
local LUCK_THRESHOLD = 27

--Offensive cards moved to blacklists.lua

mod.DeckBoxSpecialExclusions = {
}

mod.DeckBoxObjectInclusions = {
	[Card.CARD_EMERGENCY_CONTACT] = true,
	[mod.ITEM.CARD.COOL_PHOTO] = true,
}

-- Reverse King of Clubs excluded for what I hope are obvious reasons
mod.reverseCardMap = {
	-- Normal -> Reverse
	[Card.CARD_FOOL] = 				Card.CARD_REVERSE_FOOL,
	[Card.CARD_MAGICIAN] = 			Card.CARD_REVERSE_MAGICIAN,
	[Card.CARD_HIGH_PRIESTESS] = 	Card.CARD_REVERSE_HIGH_PRIESTESS,
	[Card.CARD_EMPRESS] = 			Card.CARD_REVERSE_EMPRESS,
	[Card.CARD_EMPEROR] = 			Card.CARD_REVERSE_EMPEROR,
	[Card.CARD_HIEROPHANT] = 		Card.CARD_REVERSE_HIEROPHANT,
	[Card.CARD_LOVERS] = 			Card.CARD_REVERSE_LOVERS,
	[Card.CARD_CHARIOT] = 			Card.CARD_REVERSE_CHARIOT,
	[Card.CARD_JUSTICE] = 			Card.CARD_REVERSE_JUSTICE,
	[Card.CARD_HERMIT] = 			Card.CARD_REVERSE_HERMIT,
	[Card.CARD_WHEEL_OF_FORTUNE] = 	Card.CARD_REVERSE_WHEEL_OF_FORTUNE,
	[Card.CARD_STRENGTH] = 			Card.CARD_REVERSE_STRENGTH,
	[Card.CARD_HANGED_MAN] = 		Card.CARD_REVERSE_HANGED_MAN,
	[Card.CARD_DEATH] = 			Card.CARD_REVERSE_DEATH,
	[Card.CARD_TEMPERANCE] = 		Card.CARD_REVERSE_TEMPERANCE,
	[Card.CARD_DEVIL] = 			Card.CARD_REVERSE_DEVIL,
	[Card.CARD_TOWER] = 			Card.CARD_REVERSE_TOWER,
	[Card.CARD_STARS] = 			Card.CARD_REVERSE_STARS,
	[Card.CARD_MOON] = 				Card.CARD_REVERSE_MOON,
	[Card.CARD_SUN] = 				Card.CARD_REVERSE_SUN,
	[Card.CARD_JUDGEMENT] = 		Card.CARD_REVERSE_JUDGEMENT,
	[Card.CARD_WORLD] = 			Card.CARD_REVERSE_WORLD,

	[FiendFolio.ITEM.CARD.PLUS_3_FIREBALLS] = 	FiendFolio.ITEM.CARD.REVERSE_3_FIREBALLS,
	[FiendFolio.ITEM.CARD.KING_OF_PENTACLES] = 	FiendFolio.ITEM.CARD.REVERSE_KING_OF_PENTACLES,

	-- Reverse -> Normal
	[Card.CARD_REVERSE_FOOL] = 				Card.CARD_FOOL,
	[Card.CARD_REVERSE_MAGICIAN] = 			Card.CARD_MAGICIAN,
	[Card.CARD_REVERSE_HIGH_PRIESTESS] = 	Card.CARD_HIGH_PRIESTESS,
	[Card.CARD_REVERSE_EMPRESS] = 			Card.CARD_EMPRESS,
	[Card.CARD_REVERSE_EMPEROR] = 			Card.CARD_EMPEROR,
	[Card.CARD_REVERSE_HIEROPHANT] = 		Card.CARD_HIEROPHANT,
	[Card.CARD_REVERSE_LOVERS] = 			Card.CARD_LOVERS,
	[Card.CARD_REVERSE_CHARIOT] = 			Card.CARD_CHARIOT,
	[Card.CARD_REVERSE_JUSTICE] = 			Card.CARD_JUSTICE,
	[Card.CARD_REVERSE_HERMIT] = 			Card.CARD_HERMIT,
	[Card.CARD_REVERSE_WHEEL_OF_FORTUNE] = 	Card.CARD_WHEEL_OF_FORTUNE,
	[Card.CARD_REVERSE_STRENGTH] = 			Card.CARD_STRENGTH,
	[Card.CARD_REVERSE_HANGED_MAN] = 		Card.CARD_HANGED_MAN,
	[Card.CARD_REVERSE_DEATH] = 			Card.CARD_DEATH,
	[Card.CARD_REVERSE_TEMPERANCE] = 		Card.CARD_TEMPERANCE,
	[Card.CARD_REVERSE_DEVIL] = 			Card.CARD_DEVIL,
	[Card.CARD_REVERSE_TOWER] = 			Card.CARD_TOWER,
	[Card.CARD_REVERSE_STARS] = 			Card.CARD_STARS,
	[Card.CARD_REVERSE_MOON] = 				Card.CARD_MOON,
	[Card.CARD_REVERSE_SUN] = 				Card.CARD_SUN,
	[Card.CARD_REVERSE_JUDGEMENT] = 		Card.CARD_JUDGEMENT,
	[Card.CARD_REVERSE_WORLD] = 			Card.CARD_WORLD,

	[FiendFolio.ITEM.CARD.REVERSE_3_FIREBALLS] = 		FiendFolio.ITEM.CARD.PLUS_3_FIREBALLS,
	[FiendFolio.ITEM.CARD.REVERSE_KING_OF_PENTACLES] = 	FiendFolio.ITEM.CARD.KING_OF_PENTACLES,
}

function mod.TryReverseCard(card, skipUnlockCheck)
	local try = mod.reverseCardMap[card]
	if not try then return card end

	if skipUnlockCheck or mod.IsCardUnlocked(try) then
		return try
	else
		return card
	end
end

local function canStoreCard(card)
	if not card then return false end
	local cardType = Isaac.GetItemConfig():GetCard(card).CardType

	return (
		cardType == ItemConfig.CARDTYPE_TAROT or
		cardType == ItemConfig.CARDTYPE_SUIT or
		cardType == ItemConfig.CARDTYPE_TAROT_REVERSE or
		(cardType == ItemConfig.CARDTYPE_SPECIAL and not mod.DeckBoxSpecialExclusions[card]) or
		(cardType == ItemConfig.CARDTYPE_SPECIAL_OBJECT and mod.DeckBoxObjectInclusions[card])
	) and not Isaac.RunCallbackWithParam(mod.CALLBACK.PRE_DECK_BOX_STORE_CARD, card, player, card)
end

local function isPlayerHoldingACard(player) -- This is a little horrific sorry
	if not player:IsHoldingItem() then return false end
	local holdingSpriteFile = string.lower(player:GetHeldSprite():GetFilename())
	return (
		string.match(holdingSpriteFile, "ui_cardspills.anm2") or -- Vanilla Cardfronts
		string.match(holdingSpriteFile, "ui_cardfronts.anm2")	 -- Modded Cardfronts
	)
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, item, rng, player, flags, slot, varData)
	if isPlayerHoldingACard(player) then
		if flags & UseFlag.USE_CARBATTERY > 0 then return end

		-- If your currently selected Pocket Item is an Active Item, then pills/cards are added to the Secondary slot, otherwise the Primary slot
		local cardSlot = PillCardSlot.PRIMARY
		if player:GetPocketItem(PillCardSlot.PRIMARY):GetType() == PocketItemType.ACTIVE_ITEM then
			cardSlot = PillCardSlot.SECONDARY
		end

		local card = player:GetCard(cardSlot)
		local persistentData = mod.GetPersistentPlayerData(player)
		persistentData.deckBoxContents = persistentData.deckBoxContents or {}

		if #persistentData.deckBoxContents < player:GetActiveMaxCharge(slot) and canStoreCard(card) then
			table.insert(persistentData.deckBoxContents, card)
			player:RemovePocketItem(cardSlot)
			player:AddActiveCharge(1, slot, true, false, true)
		else
			sfx:Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ)
		end

		return {Discharge = false, ShowAnim = true}
	else
		local persistentData = mod.GetPersistentPlayerData(player)
		persistentData.deckBoxContents = persistentData.deckBoxContents or {}

		if flags & UseFlag.USE_CARBATTERY == 0 then persistentData.canUseDeckBoxContents = true end
		if not persistentData.canUseDeckBoxContents then return end

		for _, card in pairs(persistentData.deckBoxContents) do
			if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE) then
				player:UseCard(mod.TryReverseCard(card))
			else
				player:UseCard(card, USEFLAGS)
			end

			if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
				player:AddWisp(deckBox, player.Position)
				sfx:Play(SoundEffect.SOUND_CANDLE_LIGHT, 1, 0, false, 1)
			end
		end

		if flags & UseFlag.USE_CARBATTERY == 0 then
			Isaac.CreateTimer(function()
				persistentData.deckBoxContents = {}
				persistentData.canUseDeckBoxContents = false
			end, 1, 0, true)
		end

		return true
	end
end, deckBox)

mod:AddCallback(ModCallbacks.MC_PLAYER_GET_ACTIVE_MIN_USABLE_CHARGE, function(_, slot, player, currentMinCharge)
	if isPlayerHoldingACard(player) and canStoreCard(player:GetCard(0)) then
		return 0
	else
		return 1
	end
end, deckBox)

mod:AddCallback(ModCallbacks.MC_PLAYER_GET_ACTIVE_MAX_CHARGE, function(_, item, player, varData, currentCharge)
	local either = player:HasCollectible(CollectibleType.COLLECTIBLE_STARTER_DECK) or player:HasCollectible(CollectibleType.COLLECTIBLE_BOOSTER_PACK)
	local both = player:HasCollectible(CollectibleType.COLLECTIBLE_STARTER_DECK) and player:HasCollectible(CollectibleType.COLLECTIBLE_BOOSTER_PACK)

	if both then
		return currentCharge + 3
	elseif either then
		return currentCharge + 2
	end
end, deckBox)

function mod:getCombatCard(rng)
	local card = mod.OffensiveCards[1]
	--local gameData = Isaac.GetPersistentGameData()

	repeat
		card = mod.OffensiveCards[rng:RandomInt(#mod.OffensiveCards) + 1]
	until mod.IsCardUnlocked(card)
	return card
end

mod:AddCollectibleCallback(ModCallbacks.MC_POST_NPC_DEATH, deckBox, function(_, npc)
	if npc:HasEntityFlags(EntityFlag.FLAG_NO_REWARD) then return end

	local rng = npc:GetDropRNG()
	local chanceMod = npc.SpawnerType ~= 0 and 0.33 or 1 -- Enemies spawned by other enemies are less likely to drop cards
	local chance = TearFlagsLib.GetChance(PlayerManager.FirstCollectibleOwner(deckBox).Luck, MIN_CHANCE * chanceMod, MAX_CHANCE * chanceMod, LUCK_THRESHOLD, PlayerManager.GetNumCollectibles(deckBox)) -- Teehee
	if rng:RandomFloat() < chance then
		local card = Isaac.Spawn(5, PickupVariant.PICKUP_TAROTCARD, mod:getCombatCard(rng), npc.Position, rng:RandomVector() * 4, npc):ToPickup()
		card.Timeout = 60
		mod:GetEntityData(card).deckBoxInstantConsume = true
	end
end)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, 1, function(_, pickup, collider, first) -- Just slightly early, just a smidge
	local player = collider:ToPlayer()
	if not player then return end
	if not mod:GetEntityData(pickup).deckBoxInstantConsume then return end

	if not player:HasCollectible(deckBox) then
		if player:GetOtherTwin() and player:GetOtherTwin():HasCollectible(deckBox) then
			player = player:GetOtherTwin()
		else
			Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_PICKUP_COLLISION, pickup.Variant, pickup, collider, first)
			return false
		end
	end

	local slot = player:GetActiveItemSlot(deckBox)
	local data = mod.GetPersistentPlayerData(player)
	data.deckBoxContents = data.deckBoxContents or {}
	if #data.deckBoxContents >= player:GetActiveMaxCharge(slot) then return false end

	local hud = game:GetHUD()
	local config = Isaac.GetItemConfig():GetCard(pickup.SubType)

	table.insert(data.deckBoxContents, pickup.SubType)
	player:AddActiveCharge(1, slot, true, false, true)
	player:AnimateCollectible(deckBox, "UseItem")
	pickup:Remove()

	local name = Isaac.GetString("PocketItems", config.Name)
	local description = Isaac.GetString("PocketItems", config.Description)
	hud:ShowItemText(name ~= GET_STRING_ERROR_RETURN and name or config.Name, description ~= GET_STRING_ERROR_RETURN and description or config.Description) -- :(

	return true
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	local wormWisps = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.WISP, deckBox)
	for _, wisp in ipairs(wormWisps) do
		wisp:Remove()
	end
end)