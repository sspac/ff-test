local mod = FiendFolio

local moduleToColor = {
	[ mod.ITEM.COLLECTIBLE.PRODUCTIVITY_MODULE ] = "red",
	[ mod.ITEM.COLLECTIBLE.EFFICIENCY_MODULE ] 	 = "green",
	[ mod.ITEM.COLLECTIBLE.SPEED_MODULE ] 		 = "blue",
}



-- Get the usable path to a layer's spritesheet
local function getProperSheetPath(path)
	local start = string.find(path, "gfx/")
	return string.sub(path, start)
end

-- Update the lights on the costume sprites
function mod:UpdateModuleCostume(player)
	for costumeID, _ in pairs(moduleToColor) do
		for i, desc in pairs( player:GetCostumeSpriteDescs() ) do
			local config = desc:GetItemConfig()

			if config.Type == ItemType.ITEM_PASSIVE and config.ID == costumeID then
				local costumeSprite = desc:GetSprite()
				local headLayer = costumeSprite:GetLayer(0)

				-- Get the base image
				local sheet = getProperSheetPath(headLayer:GetSpritesheetPath())
				local baseImage = Renderer.LoadImage(sheet)
				local imageScale = Vector(baseImage:GetWidth(), baseImage:GetHeight())

				-- Get the source and destination quads
				local src = 	 SourceQuad(Vector(0, 0), Vector(imageScale.X, 0), Vector(0, imageScale.Y), Vector(imageScale.X, imageScale.Y))
				local dst = DestinationQuad(Vector(0, 0), Vector(imageScale.X, 0), Vector(0, imageScale.Y), Vector(imageScale.X, imageScale.Y))

				-- Create the final image
				local finalImage = Renderer.CreateImage(imageScale.X, imageScale.Y, "FF_MODULES")

				Renderer.RenderToImage(finalImage, function(surfaceRenderController)
					baseImage:Render(src, dst, KColor.White)

					-- Add the lights that should be active
					for itemID, color in pairs(moduleToColor) do
						if player:HasCollectible(itemID) then
							local colorLayer = costumeSprite:GetLayer(color)
							local colorSheet = getProperSheetPath(colorLayer:GetSpritesheetPath())
							local colorImage = Renderer.LoadImage(colorSheet)
							colorImage:Render(src, dst, KColor.White)
						end
					end
				end)

				headLayer:SetSpritesheet(finalImage)
				break
			end
		end
	end
end



local itemConfig = Isaac.GetItemConfig()

for moduleID, color in pairs(moduleToColor) do
	-- Update the costume when getting one of the modules
	local function addItem(_, id, charge, firstTime, slot, varData, player)
		mod:UpdateModuleCostume(player)
	end
	mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, addItem, moduleID)


	-- Update the costume when losing one of the modules
	local function removeItem(_, player, id, removeFromForm, wispOrInnate)
		mod:UpdateModuleCostume(player)
	end
	mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, removeItem, moduleID)


	-- Update the costume when it gets applied or removed
	local moduleConfig = itemConfig:GetCollectible(moduleID)

	local function addRemoveCostume(_, config, player, itemStateOnly)
		mod:UpdateModuleCostume(player)
	end
	mod:AddCallback(ModCallbacks.MC_POST_PLAYER_ADD_COSTUME,    addRemoveCostume, moduleConfig)
	mod:AddCallback(ModCallbacks.MC_POST_PLAYER_REMOVE_COSTUME, addRemoveCostume, moduleConfig)


	-- Also update when updating the color cache
	local function updateSkinColor(_, player, cacheFlag)
		mod:UpdateModuleCostume(player)
	end
	mod:AddCollectibleCallback(ModCallbacks.MC_EVALUATE_CACHE, moduleID, updateSkinColor, CacheFlag.CACHE_COLOR)
end