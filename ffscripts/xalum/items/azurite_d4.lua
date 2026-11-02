local mod = FiendFolio
local azuriteD4 = mod.ITEM.COLLECTIBLE.AZURITE_D4

local TIME_PER_ITEM = 5
local TRAVEL_DISTANCE = 40
local RENDER_OFFSET = Vector(0, -80)

local sprite = Sprite()
sprite:Load("gfx/005.100_collectible.anm2", false)
sprite:Play("ShopIdle")

local function gatherItemList(player)
	local config = Isaac.GetItemConfig()
	local max = config:GetCollectibles().Size

	local items = {}
	local n

	for i = 1, max do
		if config:GetCollectible(i) and config:GetCollectible(i).Type ~= ItemType.ITEM_ACTIVE then
			for j = 1, player:GetCollectibleNum(i, true) do
				table.insert(items, i)
			end
		end
	end

	local i = (1 << 32) - 1
	while config:GetCollectible(i) do
		for j = 1, player:GetCollectibleNum(i, true) do
			table.insert(items, i)
		end
		i = i - 1
	end

	return items
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, item, rng, player, flags, slot)
	if flags & UseFlag.USE_CARBATTERY == 0 then
		local data = mod:GetEntityData(player)

		if mod.HasItemState(player, azuriteD4) then
			local cycleTime = #data.azuriteD4Items * TIME_PER_ITEM
			local cycleFrame = (player.FrameCount - data.azuriteD4Frame) % cycleTime
			local centreIndex = cycleFrame // TIME_PER_ITEM + 1
			local tableIndex = centreIndex % #data.azuriteD4Items + 1
			local itemID = data.azuriteD4Items[tableIndex]
			player:RemoveCollectible(itemID)

			data.azuriteD4Items = nil
			data.azuriteD4Frame = nil

			mod.RemoveItemState(player, true)
			return {Discharge = true}
		else
			data.azuriteD4Frame = player.FrameCount
			data.azuriteD4Items = gatherItemList(player)

			if #data.azuriteD4Items > 0 then
				mod.SetItemState(player, azuriteD4, slot)
			else
				data.azuriteD4Items = nil
				data.azuriteD4Frame = nil
			end

			return {Discharge = false}
		end
	end
end, azuriteD4)

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, function(_, player)
	local data = mod:GetEntityData(player)
	if data.azuriteD4Items then
		local playerFrame = player.FrameCount

		data.azuriteD4LastRenderFrame = data.azuriteD4LastRenderFrame or 0
		if data.azuriteD4LastRenderFrame == player.FrameCount then
			playerFrame = playerFrame + 0.5
		end

		local itemConfig = Isaac.GetItemConfig()
		local cycleTime = #data.azuriteD4Items * TIME_PER_ITEM
		local cycleFrame = (playerFrame - data.azuriteD4Frame) % cycleTime
		local itemFrame = cycleFrame % TIME_PER_ITEM + 1
		local centreIndex = cycleFrame // TIME_PER_ITEM + 1

		local renderQueue = {
			{FadeOffset = TIME_PER_ITEM * -2,	XOffset = TRAVEL_DISTANCE * -2, 	Item = centreIndex - 2},
			{FadeOffset = TIME_PER_ITEM * 2,	XOffset = TRAVEL_DISTANCE * 2,		Item = centreIndex + 2},
			{FadeOffset = TIME_PER_ITEM * -1,	XOffset = TRAVEL_DISTANCE * -1, 	Item = centreIndex - 1},
			{FadeOffset = TIME_PER_ITEM * 1,	XOffset = TRAVEL_DISTANCE * 1,		Item = centreIndex + 1},
			{FadeOffset = 0,	XOffset = 0,	Item = centreIndex},
		}

		local fadeRange = TIME_PER_ITEM * 2 + (TIME_PER_ITEM - 0.5) / 2

		for i = 1, 5 do
			local renderData = renderQueue[i]
			local tableIndex = renderData.Item % #data.azuriteD4Items + 1
			local itemID = data.azuriteD4Items[tableIndex]

			sprite:ReplaceSpritesheet(1, itemConfig:GetCollectible(itemID).GfxFileName)
			sprite:LoadGraphics()

			local fadeFrame = renderData.FadeOffset - (itemFrame - 1) + (TIME_PER_ITEM - 0.5) / 2
			local fadeValue = fadeFrame / fadeRange
			local fade = math.min(1, 2 * math.cos(1.6 * fadeValue))
			sprite.Color = Color(1, 1, 1, fade, 0, 0, 0)

			local offset = -(itemFrame / TIME_PER_ITEM - 0.5) * TRAVEL_DISTANCE + renderData.XOffset
			local worldPosition = player.Position + RENDER_OFFSET + Vector(offset, 0)
			sprite:Render(Isaac.WorldToScreen(worldPosition))
		end

		data.azuriteD4LastRenderFrame = player.FrameCount
	end
end)