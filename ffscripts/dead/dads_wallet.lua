local mod = FiendFolio
local game = Game()

--[[
Dad's Wallet
"Damage Debt"

Buy shop items you can't afford, pay it later!

Note: Debt rendering is handled in `ffscripts/connor/pickups/coins_hud.lua`
]]

function mod:TriggerDadsDebtCacheEval()
	for _, player in ipairs(PlayerManager.GetPlayers()) do
		if player:Exists() and player:HasCollectible(mod.ITEM.COLLECTIBLE.DADS_WALLET) then
			player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
		end
	end
end

function mod:CanPayWithDadsWallet(player, price)
	local coins = player:GetNumCoins()
	if price > coins then
		local potentialDebt = price - coins
		return ((FiendFolio.savedata.run.dadsdebt or 0) + potentialDebt) <= 99
	end
	return false
end

function mod:PayWithDadsWallet(player, price)
	local coins = player:GetNumCoins()
	if coins > 0 then
		player:AddCoins(-math.min(coins, price))
	end

	local addedDebt = price - coins

	if addedDebt > 0 then
		local rundata = FiendFolio.savedata.run
		rundata.dadsdebt = math.min((rundata.dadsdebt or 0) + addedDebt, 99)
		mod:TriggerDadsDebtCacheEval()
	end
end

function mod:handleWalletDebt(pickup, collider)
	if not pickup:IsShopItem() or pickup:IsDead() then return end

	local player = collider:ToPlayer()
	if not player or not player:HasCollectible(mod.ITEM.COLLECTIBLE.DADS_WALLET) then return end

	local price = pickup.Price

	if player:IsExtraAnimationFinished() and FiendFolio.CanPurchasePickup(player, pickup) and mod:CanPayWithDadsWallet(player, price) then
		-- This final check shouldn't be necessary, but can't be too careful with recursion.
		local data = mod:GetEntityData(pickup)
		if not data.PayedWithDadsWallet then
			data.PayedWithDadsWallet = true
			pickup.Price = PickupPrice.PRICE_FREE
			pickup.AutoUpdatePrice = false
			mod:PayWithDadsWallet(player, price)
			player:ForceCollide(pickup)
		end
	end
end
mod:AddPriorityCollectibleCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, CallbackPriority.LATE, mod.ITEM.COLLECTIBLE.DADS_WALLET, mod.handleWalletDebt)

function mod:handleWalletDebtBagOfCrafting(pickup, collider, low)
	if not pickup:IsShopItem() or pickup:IsDead() or pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then return end

	local player = collider:ToPlayer()
	if not player or not player:HasCollectible(mod.ITEM.COLLECTIBLE.DADS_WALLET) or not player:HasCollectible(CollectibleType.COLLECTIBLE_BAG_OF_CRAFTING) then return end

	local price = pickup.Price
	if not mod:CanPayWithDadsWallet(player, price) then return end

	for _, knife in ipairs(Isaac.FindByType(EntityType.ENTITY_KNIFE, KnifeVariant.BAG_OF_CRAFTING, KnifeSubType.CLUB_HITBOX)) do
		knife = knife:ToKnife()
		local hitboxParent = knife:GetHitboxParentKnife()
		if hitboxParent then
			local knifeParent = hitboxParent.Parent
			if knifeParent and GetPtrHash(knifeParent) == GetPtrHash(player) then
				local pickupHitListIndex = pickup:GetHitListIndex()
				for _, hitListIndex in ipairs(knife:GetHitList()) do
					if hitListIndex == pickupHitListIndex then
						pickup.Price = 0
						if player:TryAddToBagOfCrafting(pickup) then
							mod:PayWithDadsWallet(player, price)
							Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_PICKUP_COLLISION, pickup.Variant, pickup, collider, low)
							return true
						end
						pickup.Price = price
						return
					end
				end
			end
		end
	end
end
mod:AddPriorityCollectibleCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, CallbackPriority.IMPORTANT, mod.ITEM.COLLECTIBLE.DADS_WALLET, mod.handleWalletDebtBagOfCrafting)

-- This should run before Platinum Credit's MC_POST_UPDATE.
mod:AddPriorityCallback(ModCallbacks.MC_POST_UPDATE, CallbackPriority.EARLY-1, function()
	local savedata = FiendFolio.savedata.run

	local debtChange = false

	if savedata.dadsdebt then
		local player = Isaac.GetPlayer()

		-- Try to slurp up Platinum Credit first, if available.
		local platinumCreditData = mod:GetPlatinumCreditData()
		if platinumCreditData.Credit > 0 and savedata.dadsdebt > 0 then
			local transfer = math.min(platinumCreditData.Credit, savedata.dadsdebt)
			platinumCreditData.Credit = platinumCreditData.Credit - transfer
			savedata.dadsdebt = savedata.dadsdebt - transfer
			debtChange = true
		end

		if player:GetNumCoins() > 0 and savedata.dadsdebt > 0 then
			local coins = player:GetNumCoins()
			player:AddCoins(-savedata.dadsdebt)
			savedata.dadsdebt = savedata.dadsdebt - coins
			debtChange = true
		end

		if savedata.dadsdebt <= 0 then
			savedata.dadsdebt = nil
		end
	end

	if debtChange then
		mod:TriggerDadsDebtCacheEval()
	end
end)

FiendFolio.AddItemPickupCallback(function(player, added)
	local pos = game:GetRoom():FindFreePickupSpawnPosition(player.Position, 40, true)
	local cconfig = Isaac.GetItemConfig():GetCard(Card.CARD_CREDIT)
	if cconfig:IsAvailable() then
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_CREDIT, pos, mod.nilvector, player)
	end
end, nil, mod.ITEM.COLLECTIBLE.DADS_WALLET)