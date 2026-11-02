local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local itemConfig = Isaac.GetItemConfig()

-- Take note of all items that add coins on pickup via XML
local ITEMS_THAT_ADD_COINS = {}
for i=1, itemConfig:GetCollectibles().Size-1 do
	local item = itemConfig:GetCollectible(i)
	if item and item.AddCoins > 0 then
		ITEMS_THAT_ADD_COINS[i] = item.AddCoins
	end
end

function mod:GetPlatinumCreditData()
	local savedata = mod.savedata and mod.savedata.run or {}
	if not savedata.PlatinumCreditData then
		savedata.PlatinumCreditData = {}
	end
	local data = savedata.PlatinumCreditData
	if not data.Credit then
		data.Credit = 0
	end
	if not data.PhantomCredit then
		data.PhantomCredit = 0
	end
	if not data.RealCoins then
		data.RealCoins = Isaac.GetPlayer():GetNumCoins()
	end
	return savedata.PlatinumCreditData
end

function mod:AddPlatinumCredit(amount)
	local data = mod:GetPlatinumCreditData()
	data.Credit = data.Credit + amount
	mod:UpdatePlatinumCredit()
end

-- Register actual pickup functionality
CustomHealthAPI.Library.RegisterPickupEntity(PickupVariant.PICKUP_COIN, mod.PICKUP.COIN.PLATINUM, {
	DropSound = { ID = SoundEffect.SOUND_DIMEDROP, Volume = 1, Pitch = 1.25 },
	CollectSound = { ID = SoundEffect.SOUND_DIMEPICKUP, Volume = 1, Pitch = 1.5 },
	OnCollect = function(player, pickup)
		mod:AddPlatinumCredit(30)
		mod:triggerPennyPickup(player, pickup, 10)
	end,
})

function mod:UpdatePlatinumCredit()
	if Isaac.GetPlayer():HasCurseMistEffect() then return end
	
	local data = mod:GetPlatinumCreditData()
	
	local coinsAddedByItems = 0
	for i=0, game:GetNumPlayers()-1 do
		local player = game:GetPlayer(i)
		if player and player:Exists() then
			local init = false
			local pData = mod:GetEntityData(player)
			if not pData.PlatinumCreditItemTracking then
				pData.PlatinumCreditItemTracking = {}
				init = true
			end
			for itemID, coins in pairs(ITEMS_THAT_ADD_COINS) do
				local prevCount = pData.PlatinumCreditItemTracking[itemID] or 0
				local currentCount = player:GetCollectibleNum(itemID, true)
				if not init and currentCount > prevCount then
					coinsAddedByItems = (currentCount - prevCount) * coins
				end
				pData.PlatinumCreditItemTracking[itemID] = currentCount
			end
		end
	end
	
	local player = Isaac.GetPlayer()
	local maxCoins = player:GetMaxCoins()
	
	-- Edge case where the player currently has more than their max coins due to losing Deep Pockets.
	-- If they had phantom credit when they lost Deep Pockets, forcibly "fix" their coins. I don't care.
	if player:GetNumCoins() > maxCoins and data.PhantomCredit > 0 then
		local excess = player:GetNumCoins() - maxCoins
		local excessCredit = math.min(excess, data.PhantomCredit)
		data.PhantomCredit = data.PhantomCredit - excessCredit
		data.Credit = data.Credit + excessCredit
		data.RealCoins = math.min(data.RealCoins, maxCoins)
		player:AddCoins(-excess)
		return
	end
	
	local expectedCoins = data.RealCoins + data.PhantomCredit + coinsAddedByItems
	
	if expectedCoins > maxCoins and data.PhantomCredit > 0 and coinsAddedByItems > 0 then
		-- The player probably overflowed after picking up an item that granted coins.
		-- Try to move overflowed Phantom Credit back into Platinum Credit so it doesn't get lost.
		local overflow = math.min(expectedCoins - maxCoins, data.PhantomCredit)
		data.PhantomCredit = data.PhantomCredit - overflow
		data.Credit = data.Credit + overflow
		expectedCoins = maxCoins
	end
	
	--local coinDiff = player:GetNumCoins() - expectedCoins
	local coinDiff = math.max(player:GetNumCoins() - expectedCoins, player:GetNumCoins() - maxCoins)
	
	if coinDiff < 0 then
		-- The player lost coins. Remove those coins from the Phantom Credit.
		local coinsLost = -coinDiff
		local phantomCreditLost = math.min(coinsLost, data.PhantomCredit)
		data.PhantomCredit = data.PhantomCredit - phantomCreditLost
		
		-- Player lost more than the available Phantom Credit. Replace the rest of the lost coins using Platinum Credit.
		local platinumCreditLost = math.min(coinsLost - phantomCreditLost, data.Credit, maxCoins - player:GetNumCoins())
		if platinumCreditLost > 0 then
			data.Credit = data.Credit - platinumCreditLost
			player:AddCoins(platinumCreditLost)
		end
	end
	
	local creditToTransfer = math.min(data.Credit, maxCoins - player:GetNumCoins())
	if creditToTransfer > 0 then
		-- If space is available, transfer Platinum Credit into Phantom Credit.
		local newExpectedCoins = player:GetNumCoins() + creditToTransfer
		player:AddCoins(creditToTransfer)
		data.Credit = data.Credit - creditToTransfer
		data.PhantomCredit = data.PhantomCredit + creditToTransfer
		
		if player:GetNumCoins() < newExpectedCoins then
			-- Some of the Platinum Credit disappeared immediately when transfered to Phantom Credit.
			-- They may have been eaten by Keeper, or something. Just assume them to be lost.
			local coinsLost = math.min(newExpectedCoins - player:GetNumCoins(), data.PhantomCredit)
			data.PhantomCredit = data.PhantomCredit - coinsLost
		end
	end
	
	local currentCoins = player:GetNumCoins()
	
	if data.PhantomCredit < 0 then
		local str = "[FF] Error: Negative Platinum Phantom Credit"
		print(str)
		Isaac.DebugString(str)
		
		data.PhantomCredit = 0
	end
	
	if data.PhantomCredit > currentCoins then
		local str = "[FF] Error: Excessive Platinum Phantom Credit"
		print(str)
		Isaac.DebugString(str)
		
		local excess = data.PhantomCredit - currentCoins
		data.PhantomCredit = currentCoins
		data.Credit = data.Credit + excess
	end
	
	data.RealCoins = currentCoins - data.PhantomCredit
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_UPDATE, CallbackPriority.EARLY, mod.UpdatePlatinumCredit)

-- Platinum Credit only lasts for the floor.
mod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_LEVEL, CallbackPriority.EARLY, function()
	local data = mod:GetPlatinumCreditData()
	local player = Isaac.GetPlayer()
	
	if data.PhantomCredit > 0 then
		player:AddCoins(-data.PhantomCredit)
	end
	data.PhantomCredit = 0
	data.Credit = 0
	data.RealCoins = player:GetNumCoins()
end)

-- If the player touches a penny while they have Phantom Credit, make sure there is room for the coin's value.
mod:AddPriorityCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, CallbackPriority.LATE, function(_, player, collider)
	local pickup = collider:ToPickup()
	if pickup and pickup.Variant == PickupVariant.PICKUP_COIN then
		local data = mod:GetPlatinumCreditData()
		local coinValue = mod.GetCoinValue(pickup)
		local maxCoins = player:GetMaxCoins()
		if player:GetNumCoins() + coinValue > maxCoins and data.PhantomCredit > 0 then
			-- Try to reduce Phantom Credit to allow the penny to fit.
			local excess = math.min(player:GetNumCoins() + coinValue - maxCoins, data.PhantomCredit)
			data.PhantomCredit = data.PhantomCredit - excess
			data.Credit = data.Credit + excess
			player:AddCoins(-excess)
		end
	end
end)

-- Used in a EntityPlayer:AddCoins() override so that overflow due to Phantom Credit doesn't get wasted.
function mod:PlatinumCreditPreAddCoins(player, amount)
	local data = mod:GetPlatinumCreditData()
	local maxCoins = player:GetMaxCoins()
	local currentCoins = player:GetNumCoins()
	if data.PhantomCredit > 0 and amount > 0 and currentCoins + amount > maxCoins then
		-- More coins are being added than can fit. Remove excess Phantom Credit.
		local excess = math.min(currentCoins + amount - maxCoins, data.PhantomCredit)
		data.PhantomCredit = data.PhantomCredit - excess
		data.Credit = data.Credit + excess
		amount = amount - excess
	end
	return amount
end

-- Handle 2 of Diamonds
mod:AddPriorityCallback(ModCallbacks.MC_USE_CARD, CallbackPriority.EARLY, function(_, _, player)
	local data = mod:GetPlatinumCreditData()
	
	data.Credit = data.Credit * 2
	
	if data.PhantomCredit <= 0 then
		-- Nothing to worry about.
		return
	end
	
	data.PhantomCredit = data.PhantomCredit * 2
	
	if data.RealCoins == 0 then
		originalAddCoins(player, 2)
	end
	
	data.RealCoins = math.max(data.RealCoins * 2, 2)
	
	local maxCoins = player:GetMaxCoins()
	
	if player:GetNumCoins() >= maxCoins then
		local expectedCoins = data.RealCoins + data.PhantomCredit
		if expectedCoins > maxCoins then
			-- Player's coins overflowed. Move any excess Phantom Credit back into Platinum Credit.
			local excess = math.min(expectedCoins - maxCoins, data.PhantomCredit)
			data.PhantomCredit = data.PhantomCredit - excess
			data.Credit = data.Credit + excess
		end
	end
end, Card.CARD_DIAMONDS_2)
