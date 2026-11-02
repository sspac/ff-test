local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

----------------------------------------------------------------------------------------------------
-- Common Battery Logic

-- Mostly the same functionality as player:NeedsCharge, but allowing for manual overcharge.
local function CanBeCharged(player, slot, allowOvercharge)
	local activeInfo = mod:GetActiveItemInfo(player, slot)
	
	if not activeInfo or activeInfo.ChargeType == ItemConfig.CHARGE_SPECIAL then return false end
	
	local maxCharge = activeInfo.MaxCharges
	if allowOvercharge or player:HasCollectible(CollectibleType.COLLECTIBLE_BATTERY) then
		maxCharge = maxCharge * 2
	end
	local currentCharge = player:GetActiveCharge(slot) + player:GetBatteryCharge(slot)
	
	return currentCharge < maxCharge
end

local function CanPickupBatteryInternal(player, allowOvercharge)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.SALT_LAMP) then
		local data = mod:GetEntityData(player).ffsavedata
		if data.saltLampDuration < data.saltLampMax or (allowOvercharge and data.saltLampDuration < data.saltLampMax*2) then
			return true
		end
	end
	if player:HasTrinket(FiendFolio.ITEM.TRINKET.POWER_INVERTER) then
		return true
	end
	for slot=0, 2 do
		if CanBeCharged(player, slot, allowOvercharge) then
			return true
		end
	end
	return false
end

function mod.canPickupBattery(player)
	return CanPickupBatteryInternal(player, false)
end
function mod.canPickupBatteryAllowOvercharge(player)
	return CanPickupBatteryInternal(player, true)
end

local function TryAddActiveCharge(player, data, slot, amount, allowOvercharge, allowUndercharge, chargeType)
	local activeInfo = mod:GetActiveItemInfo(player, slot)
	
	if not activeInfo or activeInfo.ChargeType ~= chargeType then return end
	
	local hasTheBattery = player:HasCollectible(CollectibleType.COLLECTIBLE_BATTERY)
	local hasDadsBattery = player:HasCollectible(mod.ITEM.COLLECTIBLE.DADS_BATTERY)
	local maxCharge = activeInfo.MaxCharges
	local trueMaxCharge = maxCharge
	if allowOvercharge or hasTheBattery then
		trueMaxCharge = trueMaxCharge * 2
	end
	local currentDebt = mod:getChargeDebt(player, data, slot)
	local currentCharge = player:GetActiveCharge(slot) + player:GetBatteryCharge(slot) - currentDebt
	local minCharge = allowUndercharge and -math.max(currentDebt, hasDadsBattery and mod:getDadsBatteryMaxDebt(chargeType) or maxCharge) or math.min(currentCharge, 0)
	
	if not ((amount < 0 and currentCharge > minCharge) or (amount > 0 and currentCharge < trueMaxCharge)) then return end
	
	if activeInfo.ChargeType == ItemConfig.CHARGE_TIMED then
		amount = (amount > 0) and maxCharge or -maxCharge
	end
	
	local newCharge = math.max(minCharge, math.min(currentCharge + amount, trueMaxCharge))
	
	if currentCharge == newCharge then return end
	
	player:SetActiveCharge(math.max(newCharge, 0), slot)
	game:GetHUD():FlashChargeBar(player, slot)
	
	if amount < 0 then
		sfx:Play(SoundEffect.SOUND_BATTERYDISCHARGE)
	elseif (currentCharge < maxCharge and newCharge >= maxCharge) or (currentCharge < trueMaxCharge and newCharge >= trueMaxCharge) then
		sfx:Play(SoundEffect.SOUND_BATTERYCHARGE)
	elseif newCharge < maxCharge  or (currentCharge >= maxCharge and newCharge < trueMaxCharge) then
		sfx:Play(SoundEffect.SOUND_BEEP)
	end
	
	if newCharge < 0 then
		mod:setChargeDebt(player, data, slot, math.abs(newCharge))
	elseif currentDebt > 0 then
		mod:setChargeDebt(player, data, slot, 0)
	end
	
	return slot
end

local function AddActiveChargeInternal(player, data, amount, allowOvercharge, allowUndercharge)
	for _, chargeType in ipairs({ItemConfig.CHARGE_NORMAL, ItemConfig.CHARGE_TIMED}) do
		for slot=0, 2 do
			local result = TryAddActiveCharge(player, data, slot, amount, allowOvercharge, allowUndercharge, chargeType)
			if result then
				return result
			end
		end
	end
	
	for slot=0, 2 do
		local activeInfo = mod:GetActiveItemInfo(player, slot)
		if amount > 0 and (not activeInfo or activeInfo.ChargeType ~= ItemConfig.CHARGE_NORMAL or activeInfo.MaxCharges == 0) and mod:getChargeDebt(player, data, slot, ItemConfig.CHARGE_NORMAL) > 0 then
			local debt = mod:getChargeDebt(player, data, slot, ItemConfig.CHARGE_NORMAL)
			local newDebt = math.max(debt - amount, 0)
			mod:setChargeDebt(player, data, slot, newDebt, ItemConfig.CHARGE_NORMAL)
			sfx:Play(SoundEffect.SOUND_BEEP)
			return
		end
		for _, chargeType in ipairs({ItemConfig.CHARGE_NORMAL, ItemConfig.CHARGE_TIMED}) do
			local result = TryAddActiveCharge(player, data, slot, amount, allowOvercharge, allowUndercharge, chargeType)
			if result then
				return result
			end
		end
	end
end

-- Adds the given amount of active charge to the first slot that needs charge.
function mod:addActiveCharge(player, amount, allowOvercharge, allowUndercharge)
	if not amount or amount == 0 then return end
	
	local data = mod:GetEntityData(player)
	
	local successfullyChargedActiveSlot = AddActiveChargeInternal(player, data, amount, allowOvercharge, allowUndercharge)
	
	-- Allow "charging" the Salt Lamp trinket as well.
	if player:HasTrinket(FiendFolio.ITEM.ROCK.SALT_LAMP) then
		local sdata = data.ffsavedata
		if (sdata.saltLampDuration < sdata.saltLampMax or (allowOvercharge and sdata.saltLampDuration < sdata.saltLampMax*2)) then
			local currentCharge = sdata.saltLampDuration
			
			local maxCharge = allowOvercharge and (sdata.saltLampMax*2) or sdata.saltLampMax
			maxCharge = math.max(maxCharge, currentCharge)
			
			local newCharge = sdata.saltLampDuration + math.ceil(amount * (sdata.saltLampMax / 6))
			newCharge = math.min(math.max(0, newCharge), maxCharge)
			
			if not successfullyChargedActiveSlot then
				if amount < 0 then
					sfx:Play(SoundEffect.SOUND_BATTERYDISCHARGE)
				elseif newCharge >= sdata.saltLampMax then
					sfx:Play(SoundEffect.SOUND_BATTERYCHARGE)
				else
					sfx:Play(SoundEffect.SOUND_BEEP)
				end
			end
			
			sdata.saltLampDuration = newCharge
		end
	end
	
	return successfullyChargedActiveSlot
end

----------------------------------------------------------------------------------------------------
-- Firework Battery

CustomHealthAPI.Library.RegisterPickupEntity(mod.PICKUP.VARIANT.FIREWORK_BATTERY, 0, {
	IsBattery = true,
	CanCollect = mod.canPickupBattery,
	OnCollect = function(player, battery)
		mod:addActiveCharge(player, 6)
		mod:GetEntityData(player).ffsavedata.excelsiorBonus = (mod:GetEntityData(player).ffsavedata.excelsiorBonus or 0) + 1
	end,
})

----------------------------------------------------------------------------------------------------
-- Virtuous Battery

local NUM_VIRTUOUS_BATTERY_WISPS = 2

CustomHealthAPI.Library.RegisterPickupEntity(mod.PICKUP.VARIANT.VIRTUOUS_BATTERY, 0, {
	IsBattery = true,
	CanCollect = mod.canPickupBattery,
	OnCollect = function(player, battery)
		mod:addActiveCharge(player, 6)
		mod:GetEntityData(player).ffsavedata.virtuousCharge = (mod:GetEntityData(player).ffsavedata.virtuousCharge or 0) + 1
	end,
})

local function AllowVirtuousBatteryProc(item)
	local itemInfo = Isaac.GetItemConfig():GetCollectible(item)
	return item and item > 0 and itemInfo and itemInfo.MaxCharges > 0 and itemInfo.ChargeType == 0
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, item, rng, player, useFlags, slot)
	local data = mod:GetEntityData(player).ffsavedata
	if (data.virtuousCharge or 0) > 0 and AllowVirtuousBatteryProc(item) and useFlags & UseFlag.USE_OWNED ~= 0 and slot > -1 then
		for i=1, NUM_VIRTUOUS_BATTERY_WISPS * data.virtuousCharge do
			player:AddWisp(item, player.Position, true)
		end
		sfx:Play(SoundEffect.SOUND_FLAMETHROWER_END)
		data.virtuousCharge = 0
	end
end)

local bookSprite = Sprite()
bookSprite:Load("gfx/005.100_collectible.anm2", false)
bookSprite:ReplaceSpritesheet(1, "gfx/ui/hud_bookofvirtues.png")
bookSprite:LoadGraphics()
bookSprite:Play("ShopIdle", true)

local bookOffset = Vector(16, 32)

local function BookSpriteAlreadyPresent(player, slot)
	if slot ~= ActiveSlot.SLOT_PRIMARY then
		return false
	end

	local judasBirthrightActive = (playerType == PlayerType.PLAYER_JUDAS or playerType == PlayerType.PLAYER_BLACKJUDAS)
			and player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
			and player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) ~= CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE

	local bookOfVirtuesActive = player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES)
			and player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) ~= CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES

	return judasBirthrightActive or bookOfVirtuesActive
end

mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_ACTIVE_ITEM, function(_, player, slot, pos, alpha, scale, chargeBarPos)
	local data = mod:GetEntityData(player).ffsavedata
	local item = player:GetActiveItem(slot)

	local shouldRender = (slot == ActiveSlot.SLOT_PRIMARY or slot == ActiveSlot.SLOT_POCKET)
			and AllowVirtuousBatteryProc(item)
			and data and data.virtuousCharge and data.virtuousCharge > 0
			and not BookSpriteAlreadyPresent(player, slot)

	if shouldRender then
		bookSprite:Render(pos + bookOffset * scale)
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
	local n = 0.5 + 0.5 * math.sin(math.pi * Isaac.GetFrameCount() / 100)
	local a = 0.2 + 0.3 * n
	bookSprite.Color = Color(1,1,1,a)
end)

----------------------------------------------------------------------------------------------------
-- Potato Battery

CustomHealthAPI.Library.RegisterPickupEntity(mod.PICKUP.VARIANT.POTATO_BATTERY, 0, {
	IsBattery = true,
	CanCollect = mod.canPickupBattery,
	OnCollect = function(player, battery)
		mod:addActiveCharge(player, 1)
	end,
})

----------------------------------------------------------------------------------------------------
-- Cursed Battery

local MIN_CURSED_BATTERY_CHARGE = -3
local MAX_CURSED_BATTERY_CHARGE = 6

CustomHealthAPI.Library.RegisterPickupEntity(mod.PICKUP.VARIANT.CURSED_BATTERY, 0, {
	IsBattery = true,
	CanCollect = mod.canPickupBatteryAllowOvercharge,
	OnCollect = function(player, battery)
		local data = mod:GetEntityData(player)
		
		local rng = RNG()
		rng:SetSeed(battery.InitSeed, 35)
		
		local hasMaximumDebt = true
		for slot=0,2 do
			local activeInfo = mod:GetActiveItemInfo(player, slot)
			if activeInfo and mod:getChargeDebt(player, data, slot) < activeInfo.MaxCharges then
				hasMaximumDebt = false
				break
			end
		end
		
		local minCharge = hasMaximumDebt and 1 or MIN_CURSED_BATTERY_CHARGE
		local maxCharge = MAX_CURSED_BATTERY_CHARGE
		
		local possibleCharges = {}
		for i=minCharge, maxCharge do
			-- Exclude 0 from the possibilities.
			if i~= 0 then
				table.insert(possibleCharges, i)
			end
		end
		local charge = possibleCharges[rng:RandomInt(#possibleCharges)+1]
		
		if charge < 0 then
			-- Effect for charge being lost
			local eff = Isaac.Spawn(EntityType.ENTITY_EFFECT, 49, 3, battery.Position, Vector.Zero, nil):ToEffect()
			eff.PositionOffset = Vector(0, -40)
			mod:AddSamaelAngerBonus(0.1)
		end
		mod:addActiveCharge(player, charge, true, true)
	end,
})
