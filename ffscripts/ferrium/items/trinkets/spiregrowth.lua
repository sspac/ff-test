local mod = FiendFolio

mod.spireGrowthSpecials = { --Face cards might not be used, remember that fool starts at 1.
	[Card.CARD_CLUBS_2] = 2,
	[Card.CARD_DIAMONDS_2] = 2,
	[Card.CARD_SPADES_2] = 2,
	[Card.CARD_HEARTS_2] = 2,
	[Card.CARD_ACE_OF_CLUBS] = 1,
	[Card.CARD_ACE_OF_DIAMONDS] = 1,
	[Card.CARD_ACE_OF_SPADES] = 1,
	[Card.CARD_ACE_OF_HEARTS] = 1,
	[Card.CARD_SUICIDE_KING] = 13,
	[Card.CARD_QUEEN_OF_HEARTS] = 12,

	[mod.ITEM.CARD.MISPRINTED_TWO_OF_CLUBS] = 2,
	[mod.ITEM.CARD.THREE_OF_CLUBS] = 3,
	[mod.ITEM.CARD.JACK_OF_CLUBS] = 11,
	[mod.ITEM.CARD.MISPRINTED_JACK_OF_CLUBS] = 11,
	[mod.ITEM.CARD.QUEEN_OF_CLUBS] = 12,
	[mod.ITEM.CARD.KING_OF_CLUBS] = 13,
	[mod.ITEM.CARD.REVERSE_KING_OF_CLUBS] = 13,
	[mod.ITEM.CARD.THREE_OF_DIAMONDS] = 3,
	[mod.ITEM.CARD.MISPRINTED_THREE_OF_DIAMONDS] = 3,
	[mod.ITEM.CARD.JACK_OF_DIAMONDS] = 11,
	[mod.ITEM.CARD.QUEEN_OF_DIAMONDS] = 12,
	[mod.ITEM.CARD.KING_OF_DIAMONDS] = 13,
	[mod.ITEM.CARD.THREE_OF_SPADES] = 3,
	[mod.ITEM.CARD.JACK_OF_SPADES] = 11,
	[mod.ITEM.CARD.QUEEN_OF_SPADES] = 12,
	[mod.ITEM.CARD.KING_OF_SPADES] = 13,
	[mod.ITEM.CARD.THREE_OF_HEARTS] = 3,
	[mod.ITEM.CARD.JACK_OF_HEARTS] = 11,

	[mod.ITEM.CARD.MISPRINTED_JUSTICEJACK] = 11,
	[mod.ITEM.CARD.THIRTEEN_OF_STARS] = 13,

	[mod.ITEM.CARD.ACE_OF_WANDS] = 1,
	[mod.ITEM.CARD.ACE_OF_PENTACLES] = 1,
	[mod.ITEM.CARD.ACE_OF_SWORDS] = 1,
	[mod.ITEM.CARD.ACE_OF_CUPS] = 1,
	[mod.ITEM.CARD.TWO_OF_WANDS] = 2,
	[mod.ITEM.CARD.TWO_OF_PENTACLES] = 2,
	[mod.ITEM.CARD.TWO_OF_SWORDS] = 2,
	[mod.ITEM.CARD.TWO_OF_CUPS] = 2,
	[mod.ITEM.CARD.THREE_OF_WANDS] = 3,
	[mod.ITEM.CARD.THREE_OF_PENTACLES] = 3,
	[mod.ITEM.CARD.THREE_OF_SWORDS] = 3,
	[mod.ITEM.CARD.THREE_OF_CUPS] = 3,
	[mod.ITEM.CARD.KING_OF_WANDS] = 13,
	[mod.ITEM.CARD.KING_OF_PENTACLES] = 13,
	[mod.ITEM.CARD.REVERSE_KING_OF_PENTACLES] = 13,
	[mod.ITEM.CARD.MISPRINTED_KING_OF_PENTACLES] = 13,
	[mod.ITEM.CARD.KING_OF_SWORDS] = 13,
	[mod.ITEM.CARD.KING_OF_CUPS] = 13,

	[mod.ITEM.CARD.HAPPY_SQUIRREL] = 23,
	[mod.ITEM.CARD.THE_INVISIBLE_MOON] = 28,
	[mod.ITEM.CARD.ABERRANT_LOVERS] = 6,
	[mod.ITEM.CARD.ABERRANT_DEATH] = 12,
	[mod.ITEM.CARD.ABERRANT_TOWER] = 16,
	[mod.ITEM.CARD.ABERRANT_STARS] = 17,
	[mod.ITEM.CARD.ABERRANT_MOON] = 18,
	[mod.ITEM.CARD.ABERRANT_SUN] = 19,

	[mod.ITEM.CARD.PLUS_3_FIREBALLS] = 3,
	[mod.ITEM.CARD.REVERSE_3_FIREBALLS] = 3,
	--[mod.ITEM.CARD.CARDJITSU_AC_3000] = 3000,
}

function mod:spireGrowthUpdate(player)
	local data = mod:GetEntityData(player)
	
	if player:HasTrinket(FiendFolio.ITEM.TRINKET.SPIRE_GROWTH) then
		--local mult = player:GetTrinketMultiplier(FiendFolio.ITEM.TRINKET.SPIRE_GROWTH)-1
		if data.spireGrowth then
			if data.spireGrowth > 0 then
				if player.FrameCount % 40 == 0 then
					
					data.spireGrowth = math.max(0,data.spireGrowth-0.1)
				end
			else
				data.spireGrowth = nil
			end
		end
		if player.FrameCount % 40 == 0 then
			player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
			player:EvaluateItems()
		end
	end
	
	if data.spireGrowth and not player:HasTrinket(FiendFolio.ITEM.TRINKET.SPIRE_GROWTH) then
		data.spireGrowth = nil
		player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
		player:EvaluateItems()
	end
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, FiendFolio.ITEM.TRINKET.SPIRE_GROWTH, mod.spireGrowthUpdate)
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, mod.spireGrowthUpdate, FiendFolio.ITEM.TRINKET.SPIRE_GROWTH)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, card, player, flag) --what the fuck is this code I'm returning here it's like gibberish
	local data = mod:GetEntityData(player)
	if player:HasTrinket(FiendFolio.ITEM.TRINKET.SPIRE_GROWTH) then
		local mult = player:GetTrinketMultiplier(FiendFolio.ITEM.TRINKET.SPIRE_GROWTH)-1
		data.spireGrowth = data.spireGrowth or 0
		local bonus = 0
		local vanillaYay
		--print("1: " .. player:GetCard(0) .. ", 2: " .. player:GetCard(1) .. ", 3: " .. player:GetCard(2))
		if card >= Card.CARD_REVERSE_FOOL and card <= Card.CARD_REVERSE_WORLD then --Turn tainted tarots into basegame
			card = card-Card.CARD_REVERSE_FOOL+1
		end
		if card >= Card.CARD_FOOL and card <= Card.CARD_WORLD then --Base game is 1 higher than actual tarots, but keep fool as 1
			card = math.max(1, card-1)
			vanillaYay = true
		end
		if mod.spireGrowthSpecials[card] ~= nil then
			card = mod.spireGrowthSpecials[card]
			vanillaYay = true
		end
		if vanillaYay then
			card = math.min(card, 24)
			local val = 0.5+0.2*card ^ (5*0.1752)*(1+mult)
			if data.spireGrowth < val then
				data.spireGrowth = val
			end
		end

		player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
		player:EvaluateItems()
	end
end)