local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

function mod:corrodeStorageBattery(p)
	for i = 1, 2 do
		local isBattery = p:GetCard(i-1)

		if isBattery == mod.ITEM.CARD.STORAGE_BATTERY_0 then
		p:SetCard(i-1,mod.ITEM.CARD.CORRODED_BATTERY_0)
		sfx:Play(SoundEffect.SOUND_REDLIGHTNING_ZAP_BURST, 1, 0, false, 1)
		elseif isBattery == mod.ITEM.CARD.STORAGE_BATTERY_1 then
		p:SetCard(i-1,mod.ITEM.CARD.CORRODED_BATTERY_1)
		sfx:Play(SoundEffect.SOUND_REDLIGHTNING_ZAP_BURST, 1, 0, false, 1)
		elseif isBattery == mod.ITEM.CARD.STORAGE_BATTERY_2 then
		p:SetCard(i-1,mod.ITEM.CARD.CORRODED_BATTERY_2)
		sfx:Play(SoundEffect.SOUND_REDLIGHTNING_ZAP_BURST, 1, 0, false, 1)
		elseif isBattery == mod.ITEM.CARD.STORAGE_BATTERY_3 then
		p:SetCard(i-1,mod.ITEM.CARD.CORRODED_BATTERY_3)
		sfx:Play(SoundEffect.SOUND_REDLIGHTNING_ZAP_BURST, 1, 0, false, 1)
		end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
	local data = mod:GetEntityData(pickup)
	if not data.CheckedStorageBatterySheet then
		data.CheckedStorageBatterySheet = true

		local sprite = pickup:GetSprite()

		--Change Spritesheet
		if pickup.SubType == mod.ITEM.CARD.STORAGE_BATTERY_1 then
			sprite:ReplaceSpritesheet(0, "gfx/items/pick ups/storage_battery_02.png")
		elseif pickup.SubType == mod.ITEM.CARD.STORAGE_BATTERY_2 then
			sprite:ReplaceSpritesheet(0, "gfx/items/pick ups/storage_battery_03.png")
		elseif pickup.SubType == mod.ITEM.CARD.STORAGE_BATTERY_3 then
			sprite:ReplaceSpritesheet(0, "gfx/items/pick ups/storage_battery_04.png")
		elseif pickup.SubType == mod.ITEM.CARD.CORRODED_BATTERY_1 then
			sprite:ReplaceSpritesheet(0, "gfx/items/pick ups/corroded_battery_02.png")
		elseif pickup.SubType == mod.ITEM.CARD.CORRODED_BATTERY_2 then
			sprite:ReplaceSpritesheet(0, "gfx/items/pick ups/corroded_battery_03.png")
		elseif pickup.SubType == mod.ITEM.CARD.CORRODED_BATTERY_3 then
			sprite:ReplaceSpritesheet(0, "gfx/items/pick ups/corroded_battery_04.png")
		end
		sprite:LoadGraphics()
	end
end, PickupVariant.PICKUP_TAROTCARD)

mod.isStorageBattery = {
	[mod.ITEM.CARD.STORAGE_BATTERY_0] = true,
	[mod.ITEM.CARD.STORAGE_BATTERY_1] = true,
	[mod.ITEM.CARD.STORAGE_BATTERY_2] = true,
	[mod.ITEM.CARD.STORAGE_BATTERY_3] = true,
	[mod.ITEM.CARD.CORRODED_BATTERY_0] = true,
	[mod.ITEM.CARD.CORRODED_BATTERY_1] = true,
	[mod.ITEM.CARD.CORRODED_BATTERY_2] = true,
	[mod.ITEM.CARD.CORRODED_BATTERY_3] = true,
}

function mod:useStorageBattery(card, player, useFlags)
	if (useFlags & UseFlag.USE_OWNED == 0) then return end

	local playersItem = player:GetActiveItem()
	local playersPocketItem = player:GetActiveItem(2)
	local toset = ActiveSlot.SLOT_PRIMARY

	if playersItem == 0 and playersPocketItem ~= 0 then --If player has no active but has pocket active
	 toset = 2
	 playersItem = playersPocketItem
	elseif playersItem ~= 0 and playersPocketItem ~= 0 and player:GetActiveCharge(toset) == 0 then --Has Active and Pocket, but Active is not charged.
	 toset = 2
	 playersItem = playersPocketItem
	end

	local baseCharge = player:GetActiveCharge(toset)
	local overcharge = player:GetBatteryCharge(toset)
	local itemCharge = baseCharge+overcharge
	if card == mod.ITEM.CARD.STORAGE_BATTERY_0 then
		if playersItem == 0 and toset == 0 then
		player:AddCard(mod.ITEM.CARD.STORAGE_BATTERY_0)
		elseif Isaac.GetItemConfig():GetCollectible(playersItem).ChargeType ~= 0 then
		player:AddCard(mod.ITEM.CARD.STORAGE_BATTERY_0)
		elseif itemCharge == 0 then
		player:AddCard(mod.ITEM.CARD.STORAGE_BATTERY_0)
		elseif itemCharge == 1 then
		 player:AddCard(mod.ITEM.CARD.STORAGE_BATTERY_1)
		 mod:addActiveCharge(player, -1, true)
		elseif itemCharge == 2 then
		 player:AddCard(mod.ITEM.CARD.STORAGE_BATTERY_2)
		 mod:addActiveCharge(player, -2, true)
		elseif itemCharge >= 3 then
		 player:AddCard(mod.ITEM.CARD.STORAGE_BATTERY_3)
		 mod:addActiveCharge(player, -3, true)
		end
		SFXManager():Play(SoundEffect.SOUND_BEEP,1,1,false,2)
	elseif card == mod.ITEM.CARD.STORAGE_BATTERY_1 then
		--Checks Avaliable Slot
		 if playersItem == 0 and playersPocketItem ~= 0 then --If player has no active but has pocket active
			toset = 2
		elseif playersItem ~= 0 and playersPocketItem ~= 0 and player:GetActiveCharge(0) == 0 then --Has Active and Pocket, but Active is not charged.
			toset = 0
		end
		baseCharge = player:GetActiveCharge(toset)
		overcharge = player:GetBatteryCharge(toset)
		itemCharge = baseCharge+overcharge

		 player:AddCard(mod.ITEM.CARD.STORAGE_BATTERY_0)
		 mod:addActiveCharge(player, 1, true)
		 SFXManager():Play(SoundEffect.SOUND_BATTERYCHARGE,1,1,false,1.5)

		 --Timed Item
         if playersItem > 0 and Isaac.GetItemConfig():GetCollectible(playersItem).ChargeType == 1 then
          if player:GetActiveCharge(toset) ~= Isaac.GetItemConfig():GetCollectible(playersItem).MaxCharges then
		   player:SetActiveCharge(Isaac.GetItemConfig():GetCollectible(playersItem).MaxCharges,toset)
		  else
		   player:SetActiveCharge(Isaac.GetItemConfig():GetCollectible(playersItem).MaxCharges+Isaac.GetItemConfig():GetCollectible(playersItem).MaxCharges,toset)
		  end
         end

		 local e = Isaac.Spawn(1000, 48, 0, player.Position+Vector(0,-50), nilvector, nil)
	elseif card == mod.ITEM.CARD.STORAGE_BATTERY_2 then
		--Checks Avaliable Slot
		 if playersItem == 0 and playersPocketItem ~= 0 then --If player has no active but has pocket active
			toset = 2
		elseif playersItem ~= 0 and playersPocketItem ~= 0 and player:GetActiveCharge(0) == 0 then --Has Active and Pocket, but Active is not charged.
			toset = 0
		end
		baseCharge = player:GetActiveCharge(toset)
		overcharge = player:GetBatteryCharge(toset)
		itemCharge = baseCharge+overcharge

		 player:AddCard(mod.ITEM.CARD.STORAGE_BATTERY_0)
		 mod:addActiveCharge(player, 2, true)
		 SFXManager():Play(SoundEffect.SOUND_BATTERYCHARGE,1,1,false,1.5)

		 --Timed Item
         if playersItem > 0 and Isaac.GetItemConfig():GetCollectible(playersItem).ChargeType == 1 then
          if player:GetActiveCharge(toset) ~= Isaac.GetItemConfig():GetCollectible(playersItem).MaxCharges then
		   player:SetActiveCharge(Isaac.GetItemConfig():GetCollectible(playersItem).MaxCharges,toset)
		  else
		   player:SetActiveCharge(Isaac.GetItemConfig():GetCollectible(playersItem).MaxCharges+Isaac.GetItemConfig():GetCollectible(playersItem).MaxCharges,toset)
		  end
         end

		 local e = Isaac.Spawn(1000, 48, 0, player.Position+Vector(0,-50), nilvector, nil)
	elseif card == mod.ITEM.CARD.STORAGE_BATTERY_3 then
		--Checks Avaliable Slot
		 if playersItem == 0 and playersPocketItem ~= 0 then --If player has no active but has pocket active
			toset = 2
		elseif playersItem ~= 0 and playersPocketItem ~= 0 and player:GetActiveCharge(0) == 0 then --Has Active and Pocket, but Active is not charged.
			toset = 0
		end
		baseCharge = player:GetActiveCharge(toset)
		overcharge = player:GetBatteryCharge(toset)
		itemCharge = baseCharge+overcharge

		 player:AddCard(mod.ITEM.CARD.STORAGE_BATTERY_0)
		 mod:addActiveCharge(player, 3, true)
		 SFXManager():Play(SoundEffect.SOUND_BATTERYCHARGE,1,1,false,1.5)

		 --Timed Item
         if playersItem > 0 and Isaac.GetItemConfig():GetCollectible(playersItem).ChargeType == 1 then
          if player:GetActiveCharge(toset) ~= Isaac.GetItemConfig():GetCollectible(playersItem).MaxCharges then
		   player:SetActiveCharge(Isaac.GetItemConfig():GetCollectible(playersItem).MaxCharges,toset)
		  else
		   player:SetActiveCharge(Isaac.GetItemConfig():GetCollectible(playersItem).MaxCharges+Isaac.GetItemConfig():GetCollectible(playersItem).MaxCharges,toset)
		  end
         end

		 local e = Isaac.Spawn(1000, 48, 0, player.Position+Vector(0,-50), nilvector, nil)
	elseif card == mod.ITEM.CARD.CORRODED_BATTERY_0 then
		if playersItem == 0 then
		player:AddCard(mod.ITEM.CARD.CORRODED_BATTERY_0)
		elseif Isaac.GetItemConfig():GetCollectible(playersItem).ChargeType ~= 0 then
		player:AddCard(mod.ITEM.CARD.CORRODED_BATTERY_0)
		elseif itemCharge == 0 then
		player:AddCard(mod.ITEM.CARD.CORRODED_BATTERY_0)
		elseif itemCharge == 1 then
		 player:AddCard(mod.ITEM.CARD.CORRODED_BATTERY_1)
		 mod:addActiveCharge(player, -1, true)
		elseif itemCharge == 2 then
		 player:AddCard(mod.ITEM.CARD.CORRODED_BATTERY_2)
		 mod:addActiveCharge(player, -2, true)
		elseif itemCharge >= 3 then
		 player:AddCard(mod.ITEM.CARD.CORRODED_BATTERY_3)
		 mod:addActiveCharge(player, -3, true)
		end
		SFXManager():Play(SoundEffect.SOUND_EDEN_GLITCH, 1, 0, false, 1)
	elseif card == mod.ITEM.CARD.CORRODED_BATTERY_1 then
		--Checks Avaliable Slot
		 if playersItem == 0 and playersPocketItem ~= 0 then --If player has no active but has pocket active
			toset = 2
		elseif playersItem ~= 0 and playersPocketItem ~= 0 and player:GetActiveCharge(0) == 0 then --Has Active and Pocket, but Active is not charged.
			toset = 0
		end
		baseCharge = player:GetActiveCharge(toset)
		overcharge = player:GetBatteryCharge(toset)
		itemCharge = baseCharge+overcharge

		mod:addActiveCharge(player, 1, true)
		 SFXManager():Play(SoundEffect.SOUND_REDLIGHTNING_ZAP, 1, 0, false, 1)
		 SFXManager():Play(SoundEffect.SOUND_BATTERYCHARGE,1,1,false,1.5)
		 local e = Isaac.Spawn(6, 666, 0, player.Position+Vector(0,15), nilvector, nil)
		 local e = Isaac.Spawn(1000, 48, 0, player.Position+Vector(0,-50), nilvector, nil)

		--Timed Item
         if playersItem > 0 and Isaac.GetItemConfig():GetCollectible(playersItem).ChargeType == 1 then
          if player:GetActiveCharge(toset) ~= Isaac.GetItemConfig():GetCollectible(playersItem).MaxCharges then
		   player:SetActiveCharge(Isaac.GetItemConfig():GetCollectible(playersItem).MaxCharges,toset)
		  else
		   player:SetActiveCharge(Isaac.GetItemConfig():GetCollectible(playersItem).MaxCharges+Isaac.GetItemConfig():GetCollectible(playersItem).MaxCharges,toset)
		  end
         end

	elseif card == mod.ITEM.CARD.CORRODED_BATTERY_2 then
		--Checks Avaliable Slot
		 if playersItem == 0 and playersPocketItem ~= 0 then --If player has no active but has pocket active
			toset = 2
		elseif playersItem ~= 0 and playersPocketItem ~= 0 and player:GetActiveCharge(0) == 0 then --Has Active and Pocket, but Active is not charged.
			toset = 0
		end
		baseCharge = player:GetActiveCharge(toset)
		overcharge = player:GetBatteryCharge(toset)
		itemCharge = baseCharge+overcharge

		mod:addActiveCharge(player, 2, true)
		 SFXManager():Play(SoundEffect.SOUND_REDLIGHTNING_ZAP, 1, 0, false, 1)
		 SFXManager():Play(SoundEffect.SOUND_BATTERYCHARGE,1,1,false,1.5)
		 local e = Isaac.Spawn(6, 666, 0, player.Position+Vector(0,15), nilvector, nil)
		 local e = Isaac.Spawn(1000, 48, 0, player.Position+Vector(0,-50), nilvector, nil)

		 --Timed Item
         if playersItem > 0 and Isaac.GetItemConfig():GetCollectible(playersItem).ChargeType == 1 then
          if player:GetActiveCharge(toset) ~= Isaac.GetItemConfig():GetCollectible(playersItem).MaxCharges then
		   player:SetActiveCharge(Isaac.GetItemConfig():GetCollectible(playersItem).MaxCharges,toset)
		  else
		   player:SetActiveCharge(Isaac.GetItemConfig():GetCollectible(playersItem).MaxCharges+Isaac.GetItemConfig():GetCollectible(playersItem).MaxCharges,toset)
		  end
         end

	elseif card == mod.ITEM.CARD.CORRODED_BATTERY_3 then
		--Checks Avaliable Slot
		 if playersItem == 0 and playersPocketItem ~= 0 then --If player has no active but has pocket active
			toset = 2
		elseif playersItem ~= 0 and playersPocketItem ~= 0 and player:GetActiveCharge(0) == 0 then --Has Active and Pocket, but Active is not charged.
			toset = 0
		end
		baseCharge = player:GetActiveCharge(toset)
		overcharge = player:GetBatteryCharge(toset)
		itemCharge = baseCharge+overcharge

		mod:addActiveCharge(player, 3, true)
		 SFXManager():Play(SoundEffect.SOUND_REDLIGHTNING_ZAP, 1, 0, false, 1)
		 SFXManager():Play(SoundEffect.SOUND_BATTERYCHARGE,1,1,false,1.5)
		 local e = Isaac.Spawn(6, 666, 0, player.Position+Vector(0,15), nilvector, nil)
		 local e = Isaac.Spawn(1000, 48, 0, player.Position+Vector(0,-50), nilvector, nil)

		 --Timed Item
         if playersItem > 0 and Isaac.GetItemConfig():GetCollectible(playersItem).ChargeType == 1 then
          if player:GetActiveCharge(toset) ~= Isaac.GetItemConfig():GetCollectible(playersItem).MaxCharges then
		   player:SetActiveCharge(Isaac.GetItemConfig():GetCollectible(playersItem).MaxCharges,toset)
		  else
		   player:SetActiveCharge(Isaac.GetItemConfig():GetCollectible(playersItem).MaxCharges+Isaac.GetItemConfig():GetCollectible(playersItem).MaxCharges,toset)
		  end
         end

	end

	--[[for i = 0, 1 do
		local trinketHeld = player:GetTrinket(i)
		if trinketHeld == 79 then
			player:DropTrinket(player.Position,false)
			SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN,0.6,1,false,1.5)
		end
	end]]

	--[[for i = 0, 1 do
		local trinketHeld = player:GetTrinket(i)
		if trinketHeld == 79 then
			local batterytodelete = Isaac.FindByType(5,300,mod.ITEM.CARD.STORAGE_BATTERY_0)
			for  _, v in pairs(batterytodelete) do
				batterytodelete[_]:Remove()
			end
		end
	end]]--
	mod.usedStorageBattery = true
	mod.scheduleForUpdate(function()
		--[[for _, card in pairs(Isaac.FindByType(5, 300, -1, false, false)) do
			if mod.isStorageBattery[card.SubType] then
				if card.FrameCount <= 1 then
					print("procced")
					card:Remove()
				end
			end
		end]]
		mod.usedStorageBattery = nil
	end, 0, nil, true)

end
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.useStorageBattery, mod.ITEM.CARD.STORAGE_BATTERY_0);
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.useStorageBattery, mod.ITEM.CARD.STORAGE_BATTERY_1);
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.useStorageBattery, mod.ITEM.CARD.STORAGE_BATTERY_2);
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.useStorageBattery, mod.ITEM.CARD.STORAGE_BATTERY_3);
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.useStorageBattery, mod.ITEM.CARD.CORRODED_BATTERY_0);
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.useStorageBattery, mod.ITEM.CARD.CORRODED_BATTERY_1);
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.useStorageBattery, mod.ITEM.CARD.CORRODED_BATTERY_2);
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.useStorageBattery, mod.ITEM.CARD.CORRODED_BATTERY_3);