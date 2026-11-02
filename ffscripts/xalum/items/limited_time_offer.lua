local mod = FiendFolio
local game = Game()
local limitedOffer = mod.ITEM.TRINKET.LIMITED_TIME_OFFER
local renderFlags = AnimRenderFlags.IGNORE_GAME_TIME | AnimRenderFlags.GOLDEN
local twoMinutes = 30 * 60 * 2


local function getOfferDuration()
	return twoMinutes * (PlayerManager.GetTotalTrinketMultiplier(limitedOffer) * (1 + PlayerManager.GetTotalTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND)))
end

local function shouldReducePrice(currentPrice, shopIndex)
	return (
		mod.savedata and mod.savedata.run and mod.savedata.run.LevelEntryTime and -- A plague be upon you
		game:GetRoom():GetType() == RoomType.ROOM_SHOP and
		currentPrice > 0 and
		math.max(shopIndex, 0) % 2 == 1 and -- no one will ever know
		PlayerManager.AnyoneHasTrinket(limitedOffer) and
		game:GetFrameCount() < mod.savedata.run.LevelEntryTime + getOfferDuration()
	)
end

local function shouldFlicker()
	local timeDelta = (mod.savedata.run.LevelEntryTime + twoMinutes * (PlayerManager.GetTotalTrinketMultiplier(limitedOffer) * (1 + PlayerManager.GetTotalTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND)))) - game:GetFrameCount()
	return timeDelta < 30 and timeDelta % 4 < 2
end

local function changePriceGfx(sprite, anm2, animation, price)
	sprite:Load(anm2, true)
	sprite:SetAnimation(animation)

	if price >= 10 then
		sprite:SetLayerFrame(0, price // 10)
	else
		sprite:GetLayer(0):SetVisible(false)
	end

	sprite:SetLayerFrame(1, price % 10)
	sprite:SetLayerFrame(2, 10)
end

mod:AddTrinketCallback(ModCallbacks.MC_GET_SHOP_ITEM_PRICE, limitedOffer, function(_, variant, subtype, shopIndex, price)
	if shouldReducePrice(price, shopIndex) then
		return math.max(1, math.floor(price / 2))
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
	if mod.savedata and mod.savedata.run then
		mod.savedata.run.LevelEntryTime = game:GetFrameCount()
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	if mod.savedata and mod.savedata.run and not mod.savedata.run.LevelEntryTime then -- Shit don't work on floor 1 idk
		mod.savedata.run.LevelEntryTime = game:GetFrameCount()
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup) -- :(
	if shouldReducePrice(pickup.Price, pickup.ShopItemId) and not shouldFlicker() then
		local sprite = pickup:GetPriceSprite()
		changePriceGfx(sprite, "gfx/golden_prices.anm2", "NumbersGold", pickup.Price)
		sprite:SetRenderFlags(renderFlags)
		mod:GetEntityData(pickup).didHaveLimitedTimeOfferTint = true
	elseif mod:GetEntityData(pickup).didHaveLimitedTimeOfferTint then
		mod:GetEntityData(pickup).didHaveLimitedTimeOfferTint = nil

		local sprite = pickup:GetPriceSprite()
		sprite:SetRenderFlags(sprite:GetRenderFlags() & ~ renderFlags)

		if pickup.ShopItemId > 0 and game:GetRoom():GetShopItemPrice(pickup.Variant, pickup.SubType, pickup.ShopItemId) == pickup.Price then
			changePriceGfx(sprite, "gfx/005.150_shop item.anm2", "NumbersWhite", pickup.Price)
		end
	end
end)

mod:AddTrinketCallback(ModCallbacks.MC_PRE_PLAYERHUD_TRINKET_RENDER, limitedOffer, function(_, slot, position, scale, player, origin)
	if player:GetTrinket(slot) & TrinketType.TRINKET_ID_MASK == limitedOffer then
		local duration = getOfferDuration()
		local timeSinceLevelEntry = game:GetFrameCount() - mod.savedata.run.LevelEntryTime
		local expired = timeSinceLevelEntry >= duration
		local progress = timeSinceLevelEntry % duration
		local threshold = duration / 8

		local offset = Vector(32 + 32 * math.floor(progress / threshold), 0)
		if expired then offset.Y = 64 end
		return {CropOffset = offset}
	end
end)