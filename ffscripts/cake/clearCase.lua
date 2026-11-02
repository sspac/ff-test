local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

mod:AddCollectibleCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.ITEM.COLLECTIBLE.CLEAR_CASE, function(_, player)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.CLEAR_CASE, true) and player:GetActiveItem(ActiveSlot.SLOT_POCKET) ~= mod.ITEM.COLLECTIBLE.CLEAR_CASE then
		player:RemoveCollectible(mod.ITEM.COLLECTIBLE.CLEAR_CASE)
		if player:GetPlayerType() ~= PlayerType.PLAYER_CAIN_B then
			player:SetPocketActiveItem(mod.ITEM.COLLECTIBLE.CLEAR_CASE)
		else
			player:AddCollectible(mod.ITEM.COLLECTIBLE.CLEAR_CASE_PASSIVE, 0, false)
		end
	end
end)
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.ITEM.COLLECTIBLE.CLEAR_CASE_PASSIVE, function(_, player)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.CLEAR_CASE_PASSIVE, true) and player:GetPlayerType() ~= PlayerType.PLAYER_CAIN_B then
		player:RemoveCollectible(mod.ITEM.COLLECTIBLE.CLEAR_CASE_PASSIVE)
		player:SetPocketActiveItem(mod.ITEM.COLLECTIBLE.CLEAR_CASE)
	end
end)

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, collectible, collider, low)
	local player = collider:ToPlayer()
	if not player or collectible.SubType == 0 or not player:CanPickupItem() then return end
	if mod:GetDimension() == 2 then return end
	local isCainB = player:GetPlayerType() == PlayerType.PLAYER_CAIN_B
	local customPickedUp
	local morphed
	if collectible.SubType == mod.ITEM.COLLECTIBLE.CLEAR_CASE and not isCainB then
		customPickedUp = true
		collectible.Touched = true
		mod:playCollectiblePickupSound()
		local collectibleConfig = Isaac.GetItemConfig():GetCollectible(mod.ITEM.COLLECTIBLE.CLEAR_CASE_PASSIVE)
		player:AnimateCollectible(mod.ITEM.COLLECTIBLE.CLEAR_CASE_PASSIVE)
		player:QueueItem(collectibleConfig, 0, true)
		game:GetHUD():ShowItemText(player, collectibleConfig)
		local pocketActive = player:GetActiveItem(ActiveSlot.SLOT_POCKET)
		if pocketActive > 0 then
			player:RemoveCollectible(pocketActive, false, ActiveSlot.SLOT_POCKET)
			collectible:Morph(collectible.Type, collectible.Variant, pocketActive, false, true, true)
			morphed = true
		end
	elseif player:HasCollectible(mod.ITEM.COLLECTIBLE.CLEAR_CASE_PASSIVE) and isCainB then
		customPickedUp = true
		player:RemoveCollectible(mod.ITEM.COLLECTIBLE.CLEAR_CASE_PASSIVE)
		local collectibleConfig = Isaac.GetItemConfig():GetCollectible(collectible.SubType)
		player:QueueItem(collectibleConfig, 0, true)
		player:AnimateCollectible(collectible.SubType)
		game:GetHUD():ShowItemText(player, collectibleConfig)
		sfx:Play(SoundEffect.SOUND_CHEST_OPEN, 1, 0, false, 1)
	elseif player:HasCollectible(mod.ITEM.COLLECTIBLE.CLEAR_CASE) and collectible.SubType > 0 and not isCainB then
		local collectibleConfig = Isaac.GetItemConfig():GetCollectible(collectible.SubType)
		if collectibleConfig.Type == ItemType.ITEM_ACTIVE and not FiendFolio.ClearCaseBlacklist[collectible.SubType] then
			collectible.Touched = true
			customPickedUp = true
			player:RemoveCollectible(mod.ITEM.COLLECTIBLE.CLEAR_CASE)
			player:SetPocketActiveItem(collectible.SubType)
			player:AnimateCollectible(collectible.SubType)
			game:GetHUD():ShowItemText(player, collectibleConfig)
			sfx:Play(SoundEffect.SOUND_CHEST_OPEN, 1, 0, false, 1)
		end
	end

	if customPickedUp then
		if not morphed then
			collectible.SubType = 0
			collectible:GetSprite():Play("Empty", true)

			-- hacky fix for collectible shadow
			collectible:GetSprite():ReplaceSpritesheet(4, "stageapi/none.png")
			collectible:GetSprite():LoadGraphics()
		end

		local pickupGroupNumber
		if collectible.OptionsPickupIndex ~= 0 then
			pickupGroupNumber = collectible.OptionsPickupIndex
		end

		for _, pickup in ipairs(Isaac.FindByType(5, 100, -1, false, false)) do
			if pickup:ToPickup().OptionsPickupIndex == pickupGroupNumber and pickupGroupNumber ~= 0 then
				local e = Isaac.Spawn(1000, 15, 2, pickup.Position, nilvector, nil)
				pickup:Remove()
			end
		end
	end
end, PickupVariant.PICKUP_COLLECTIBLE)

-- stop clear case from appearing as a shop item since that breaks it
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
	if (pickup.SubType == FiendFolio.ITEM.COLLECTIBLE.CLEAR_CASE or pickup.SubType == FiendFolio.ITEM.COLLECTIBLE.CLEAR_CASE_PASSIVE) and pickup:IsShopItem() then
		pickup:Morph(pickup.Type, pickup.Variant, 0, true, true, false)
	end
end, PickupVariant.PICKUP_COLLECTIBLE)