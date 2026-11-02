local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local plushLamb = mod.ITEM.TRINKET.PLUSH_LAMB

local LAMB_DELAY = 15

mod.PlushLambBlacklist = {
	[mod.ITEM.COLLECTIBLE.EMPTY_BOOK] = true,
}

local function getPlushLambData(player, data)
	data = data or mod:GetEntityData(player)
	data.ffPlushLamb = data.ffPlushLamb or {
		TrackActive = false,
		TrackingSlot = 0,
		Item = nil,
		TimeUntilShowLamb = -1,
		TimeUntilGiveItem = -1,
		SlotsTracker = {},
		ForceItem = false,
		ForceSkip = false,
	}

	return data.ffPlushLamb
end

function mod.HasQueuedLambItem(player, data)
	return getPlushLambData(player, data).Item 
end

function mod.ClearPlushLambData(player, data)
	local ref = getPlushLambData(player)
	ref = nil
end

mod:AddTrinketCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, plushLamb, function(_, player, item, removeTransformation, wasWispOrInnate)
	if wasWispOrInnate then return end

	local config = Isaac.GetItemConfig()
	local data = getPlushLambData(player)

	if data.ForceSkip or mod.PlushLambBlacklist[item] then return end

	if config:GetCollectible(item).Type == ItemType.ITEM_ACTIVE then
		if (not data.Item or config:GetCollectible(data.Item).Type ~= ItemType.ITEM_ACTIVE) and not data.ForceItem then
			local returnVal = Isaac.RunCallbackWithParam(mod.CALLBACK.PRE_TRIGGER_PLUSH_LAMB, item, player, item)
			if type(returnVal) == "number" then
				item = returnVal
				returnVal = nil
			end

			if not returnVal then
				data.Item = item
				data.TrackActive = true
				data.TrackingSlot = data.SlotsTracker[tostring(item)] or 0
				data.TimeUntilShowLamb = LAMB_DELAY
				data.TimeUntilGiveItem = LAMB_DELAY * 2
			end
		end
	elseif not data.Item then
		local returnVal = Isaac.RunCallbackWithParam(mod.CALLBACK.PRE_TRIGGER_PLUSH_LAMB, item, player, item)
		local realItem = item

		if type(returnVal) == "number" then
			item = returnVal
			returnVal = nil
		end

		if not returnVal then
			if player:GetPlayerType() == PlayerType.PLAYER_ISAAC_B then
				for _, pickup in pairs(Isaac.FindByType(5, 100, realItem)) do
					pickup = pickup:ToPickup()
					if pickup.Touched and pickup.FrameCount == 0 then
						data.ForceItem = true
						pickup.SubType = 0

						Isaac.CreateTimer(function()
							pickup:GetSprite():Play("Empty")
							pickup:GetSprite():ReplaceSpritesheet(4, "nothing.png", true)
						end, 0, 1, false)

						break
					end
				end
			end

			data.Item = item
			data.TimeUntilShowLamb = LAMB_DELAY
			data.TimeUntilGiveItem = LAMB_DELAY * 2
		end
	end
end)

function mod.PlushLambPeffectUpdate(player, playerData)
	if player:HasTrinket(plushLamb) or mod.HasQueuedLambItem(player, playerData) then
		local data = getPlushLambData(player, playerData)
		data.TimeUntilShowLamb = math.max(-1, data.TimeUntilShowLamb - 1)
		data.TimeUntilGiveItem = math.max(-1, data.TimeUntilGiveItem - 1)

		if data.TrackActive then
			if player:GetActiveItem(data.TrackingSlot) ~= 0 then
				data.Item = nil
			end

			data.TrackActive = false
		end

		if data.Item and data.TimeUntilShowLamb == 0 then
			player:AnimateTrinket(plushLamb, "UseItem")
			sfx:Play(mod.Sounds.PlushLamb, 3)
			mod.DowngradeTrinket(player, plushLamb)
			data.ForceItem = true
		end

		if data.Item and data.TimeUntilGiveItem <= 0 then
			local config = Isaac.GetItemConfig()
			local configItem = config:GetCollectible(data.Item)
			player:AddCollectible(data.Item, configItem.InitCharge, true, data.TrackingSlot or 0)
			player:AnimateCollectible(data.Item, "UseItem")

			Isaac.RunCallbackWithParam(mod.CALLBACK.POST_ADD_PLUSH_LAMB_ITEM, data.Item, player, data.Item)

			data.Item = nil
			data.ForceItem = false
		end

		data.SlotsTracker = {}
		for i = ActiveSlot.SLOT_PRIMARY, ActiveSlot.SLOT_POCKET do
			data.SlotsTracker[tostring(player:GetActiveItem(i))] = i
		end

		data.ForceSkip = false
	end
end

mod:AddCallback(mod.CALLBACK.POST_ADD_PLUSH_LAMB_ITEM, function(_, player, item)
	local room = game:GetRoom()
	local level = game:GetLevel()

	if level:GetStage() == LevelStage.STAGE3_2 and room:GetType() == RoomType.ROOM_BOSS then
		player:AddCollectible(CollectibleType.COLLECTIBLE_KNIFE_PIECE_2, 0, true, 0)
	end
end, CollectibleType.COLLECTIBLE_KNIFE_PIECE_1)


-- Some really unfortunate timings in the collectible pickup execution order means I have to do some absolutely horrific things here, I'm sorry
-- Most of this code is stolen near verbatim from Retribution's Shattered Dice collectible-collision pickup detection

local function canPlayerAffordPrice(player, price)
	if price > 0 then
		return price <= player:GetNumCoins()
	elseif price == PickupPrice.PRICE_SPIKES then
		return player:GetDamageCooldown() == 0
	elseif price == PickupPrice.PRICE_SOUL then
		return player:HasTrinket(TrinketType.TRINKET_YOUR_SOUL)
	elseif price == 0 or price == PickupPrice.PRICE_FREE then
		return true
	elseif price == PickupPrice.PRICE_ONE_HEART or price == PickupPrice.PRICE_TWO_HEARTS then
		return player:GetEffectiveMaxHearts() > 0
	elseif price == PickupPrice.PRICE_ONE_HEART_AND_TWO_SOULHEARTS or price == PickupPrice.PRICE_ONE_HEART_AND_ONE_SOUL_HEART then
		return player:GetSoulHearts() > 0 and player:GetEffectiveMaxHearts() > 0
	elseif price == PickupPrice.PRICE_THREE_SOULHEARTS or price == PickupPrice.PRICE_ONE_SOUL_HEART or price == PickupPrice.PRICE_TWO_SOUL_HEARTS then
		return player:GetSoulHearts() > 0
	end
end

-- Retribution's version of this function includes checks that I have removed, as they are redundant when called by Retirbution.WillPlayerPickItem
-- DO NOT copy this specific function from this instance of it, as it is not sufficient for testing whether a player will buy a collectible
local function canPlayerBuyCollectible(player, pickup)
	return (
		player.Variant == PlayerVariant.PLAYER and
		player.ItemHoldCooldown == 0 and
		(Retribution and Retribution.CanAffordPrice(player, pickup.Price) or canPlayerAffordPrice(player, pickup.Price)) -- Retribution's version includes code specific for a Retribution item
	)
end

local function willPlayerPickItem(pickup, player)
	return (
		player:CanPickupItem() and
		not player:IsHoldingItem() and
		pickup.Wait == 0 and
		pickup.SubType ~= 0 and
		(
			pickup.Price == 0 or
			canPlayerBuyCollectible(player, pickup)
		)
	)
end

mod:AddTrinketCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, plushLamb, function(_, pickup, collider)
	if pickup.SubType == 0 or Isaac.GetItemConfig():GetCollectible(pickup.SubType).Type ~= ItemType.ITEM_ACTIVE then
		return
	end

	local player = collider:ToPlayer()
	if player and player:HasTrinket(plushLamb) and willPlayerPickItem(pickup, player) then
		local data = getPlushLambData(player)
		data.ForceSkip = true
	end
end, PickupVariant.PICKUP_COLLECTIBLE)