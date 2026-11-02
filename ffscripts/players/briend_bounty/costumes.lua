local mod = FiendFolio



-- Helper sprite for texel checking
local headHelper = Sprite(mod.GunslingerCostumes.Filepath)
headHelper:Play("HeadHelper", true)



-- Cache for the valid layers and texel offsets of used anm2s and spritesheets
local layerCache = {}
local offsetCache = {}

function mod:ClearGunslingerCostumeCache()
	layerCache = {}
	offsetCache = {}
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.ClearGunslingerCostumeCache)





-- Check if a layer is valid
---@param sprite Sprite
---@param layerID integer
---@return boolean isValid
---@return boolean isOverlay
local function isLayerValid(sprite, layerID, ignoreLayerState, ignoreOverlay)
	local layerState = sprite:GetLayer(layerID)

	-- Make sure it's not disabled through LayerState
	if layerState and (ignoreLayerState or layerState:IsVisible()) then
		for i = 1, 2 do
			if i == 2 or (not ignoreOverlay and sprite:GetOverlayAnimation() ~= "") then
				local animData = i == 1 and sprite:GetOverlayAnimationData() or sprite:GetCurrentAnimationData()

				if animData then
					local layerData = animData:GetLayer(layerID)

					-- Make sure the layer isn't disabled in the anm2
					if layerData and layerData:IsVisible() then
						local frame = i == 1 and sprite:GetOverlayFrame() or sprite:GetFrame()
						local frameData = layerData:GetFrame(frame)

						-- Make sure the frame is visible
						if frameData and frameData:IsVisible() then
							return true, i == 1
						end
					end
				end
			end
		end
	end

	return false, false
end



-- Get the layer to use as the head
---@param sprite Sprite
---@return integer | boolean layerID
---@return boolean isOverlay
function mod:GetHeadLayer(sprite)
	-- Manually defined head layers
	local entry, ignoreOverlay = mod:IsOnSpriteList(mod.GunslingerCostumes.HeadLayerOverrides, sprite)

	if entry == "_None" then
		return false, false

	elseif entry then
		local layerID = sprite:GetLayer(entry):GetLayerID()
		local isValid, fromOverlay = isLayerValid(sprite, layerID, nil, ignoreOverlay)

		if isValid then
			return layerID, fromOverlay
		end
	end


	-- Look for possible head layers
	local key = sprite:GetFilename() .. "|" .. sprite:GetOverlayAnimation() .. "|" .. sprite:GetOverlayFrame() .. "|" .. sprite:GetAnimation() .. "|" .. sprite:GetFrame()

	if not layerCache[key] then
		local sortedLayers = {}

		for layerID = 0, sprite:GetLayerCount() - 1 do
			local isValid, fromOverlay = isLayerValid(sprite, layerID, true)

			if isValid then
				local layerName = sprite:GetLayer(layerID):GetName()
				layerName = string.lower(layerName)

				-- Check for banned layers
				for i, bannedString in pairs( mod.GunslingerCostumes.LayersToIgnore ) do
					if string.find(layerName, bannedString) then
						isValid = false
						break
					end
				end

				if isValid then
					local priorityOffset = layerID / 100
					local layerPriority = 9999 + priorityOffset

					-- Check the name for head related strings
					for priority, targetString in pairs( mod.GunslingerCostumes.HeadLayers ) do
						if string.find(layerName, targetString) then
							layerPriority = priority + priorityOffset
						end
					end

					-- Save the layer and its priority
					local cache = {
						ID 		 = layerID,
						Priority = layerPriority,
					}
					table.insert(sortedLayers, cache)
				end
			end
		end

		-- Sort the result based on layer priority
		local sortFunc = function(k1, k2)
			return k1.Priority < k2.Priority
		end
		table.sort(sortedLayers, sortFunc)

		layerCache[key] = sortedLayers
	end


	-- Use the highest priority layer
	for i, layer in ipairs( layerCache[key] ) do
		local isValid, fromOverlay = isLayerValid(sprite, layer.ID)

		if isValid then
			return layer.ID, fromOverlay
		end
	end

	return false, false
end





-- Render and update gunslinger costumes
function mod:RenderGunslingerCostume(entity, offset)
	local data = mod:GetEntityData(entity)

	if entity.Visible and data.GunslingerData and data.GunslingerData.Costume then
		local sprite = entity:GetSprite()
		local room = Game():GetRoom()
		local renderMode = room:GetRenderMode()

		-- Check for custom conditions and the head layer before trying to render
		local renderCondition = mod:IsOnList(mod.GunslingerCostumes.RenderConditions, entity)
		local headLayerID, isHeadOverlay = mod:GetHeadLayer(sprite)

		if (not renderCondition or renderCondition(entity, sprite, data, renderMode)) and headLayerID then
			local calculatedHeight
			local shouldRender = false
			local headFrameData = isHeadOverlay and sprite:GetOverlayLayerFrameData(headLayerID) or sprite:GetLayerFrameData(headLayerID)
			local headLayerState = sprite:GetLayer(headLayerID)


			-- Get the manually defined Y position if there is any
			local entry = mod:IsOnSpriteList(mod.GunslingerCostumes.HeightOverrides, sprite)

			if entry then
				calculatedHeight = entry
				shouldRender = true


			-- Get the Y position based on the OverlayEffect layer
			elseif mod:IsOnList(mod.GunslingerCostumes.DontUseTexelDetection, entity) then
				calculatedHeight = headFrameData:GetPos().Y - headFrameData:GetPivot().Y
				local overlay = sprite:GetNullFrame("OverlayEffect")

				if overlay and overlay:IsVisible() then
					calculatedHeight = (overlay:GetPos().Y * 0.9) - calculatedHeight
					shouldRender = true
				end


			-- Get the Y position based on the head layer
			else
				local sheet = headLayerState:GetSpritesheetPath()
				local crop = headFrameData:GetCrop() + headLayerState:GetCropOffset()
				local size = Vector(headFrameData:GetWidth(), headFrameData:GetHeight())
				local key = sheet .. " (" .. crop.X .. "|" .. crop.Y .. ") (" .. size.X .. "|" .. size.Y .. ")"

				-- Use the cached version
				if offsetCache[key] then
					calculatedHeight = offsetCache[key]
					shouldRender = true

				-- Find the highest opaque pixel of the head layer
				else
					local image = sprite:GetSpritesheet(headLayerID)

					-- Use a separate sprite object so we only have to care about crop positions
					headHelper:ReplaceSpritesheet(0, sheet, true)
					headHelper:GetLayer(0):SetCropOffset(crop)
					headHelper.FlipY = renderMode == RenderMode.RENDER_WATER_REFLECT

					-- Start with larger increments to reduce lag for tall frames
					local distances = { size.Y, 10, 5, 1, }
					local startX = size.X / 2
					local startY = 0

					for i, targetDistance in pairs(distances) do
						local increments = distances[i + 1]

						if increments then
							local shouldContinue = false

							for j = 0, targetDistance, increments do
								local testPos = Vector(startX, startY + j)
								local result = headHelper:GetTexel(testPos, Vector.Zero, 0.1)

								if result.Alpha > 0 then
									local spritesheetPos = Vector(crop.X + startX, crop.Y + startY + j)

									-- Don't use sample positions that aren't on the spritesheet
									if image
									and (spritesheetPos.X < 0 or spritesheetPos.X > image:GetWidth()
									  or spritesheetPos.Y < 0 or spritesheetPos.Y > image:GetHeight()) then
										--print("Sample position is outside the spritesheet!")

									-- Stop and use the found position
									elseif i == #distances - 1 then
										calculatedHeight = startY + j
										offsetCache[key] = calculatedHeight
										shouldRender = true

									-- Continue with smaller increments
									else
										startY = startY + j - increments
										shouldContinue = true
									end
									break
								end
							end

							if not shouldContinue then
								break
							end
						end
					end
				end
			end


			if shouldRender then
				local costume = data.GunslingerData.Costume.Sprite

				-- Copy basic sprite variables
				costume.Scale = sprite.Scale
				costume.Offset = sprite.Offset
				costume.FlipX = sprite.FlipX
				costume.FlipY = sprite.FlipY
				costume.Rotation = sprite.Rotation


				-- Get the final position
				local basePos = headFrameData:GetPos() + headLayerState:GetPos()
				local scaleMulti = headFrameData:GetScale() * headLayerState:GetSize()
				local rotation = headFrameData:GetRotation() + headLayerState:GetRotation()
				local pivotOffset = (headFrameData:GetPivot() * scaleMulti):Rotated(rotation)

				local xOffset = (headFrameData:GetWidth() * scaleMulti.X) / 2
				local yOffset = (calculatedHeight + mod.GunslingerCostumes.VerticalOffset) * scaleMulti.Y
				local scalpOffset = Vector(xOffset, yOffset):Rotated(rotation)

				-- Minecart offset
				local minecartOffset = Vector.Zero
				local minecart = entity:GetMinecart()

				if minecart then
					local minecartSprite = minecart:GetSprite()
					local nullFrame = minecartSprite:GetNullFrame("AttachPos")

					if nullFrame and nullFrame:IsVisible() then
						minecartOffset = nullFrame:GetPos()
					end
				end

				local pos = basePos - pivotOffset + scalpOffset + minecartOffset


				-- Get the size based on the NPC's size
				local size = entity.Size * mod:Lerp(entity.SizeMulti.X, entity.SizeMulti.Y, 0.5)
				local scale = math.min(1 + (size - 25) / 50, mod.GunslingerCostumes.MaxSize)
				scale = scale * headFrameData:GetScale()


				-- Set the color
				local alphaModifier = headFrameData:GetColor().A * headLayerState:GetColor().A

				-- Wraith BULLSHIT
				if entity.Type == EntityType.ENTITY_WRAITH and room:GetWaterAmount() > 0
				and room:IsMirrorWorld() == (renderMode == RenderMode.RENDER_WATER_REFLECT) then
					alphaModifier = alphaModifier * room:GetLightningIntensity()
				end

				local baseColor = data.ActualColor or sprite.Color
				costume.Color = mod:copyColor(baseColor) * Color(1,1,1, alphaModifier)


				-- Update the layers
				for i, layer in pairs( costume:GetAllLayers() ) do
					-- Set the face offset for Steven hats
					if layer:GetName() == "face" then
						local faceOffset = costume:GetNullFrame("FacePos")

						if faceOffset and faceOffset:IsVisible() then
							faceOffset = faceOffset:GetPos() * scaleMulti
							pos = pos + faceOffset:Rotated(rotation)
						end
					end

					layer:SetSize(scale)
					layer:SetPos(pos)
					layer:SetRotation(rotation)
				end


				-- Update the render flags
				local entityRenderFlags = sprite:GetRenderFlags()
				local costumeRenderFlags = costume:GetRenderFlags()

				for i, flag in pairs( mod.GunslingerCostumes.RenderFlagsToCopy ) do
					-- Should have the flag, add it
					if entityRenderFlags & flag > 0 then
						costumeRenderFlags = costumeRenderFlags | flag

					-- Shouldn't have the flag anymore, remove it
					elseif costumeRenderFlags & flag > 0 then
						costumeRenderFlags = costumeRenderFlags ~ flag
					end
				end

				costume:SetRenderFlags(costumeRenderFlags)


				-- Set the animation
				if not costume:IsPlaying("EternalAppear") then
					mod:LoopingAnim(costume, data.GunslingerData.Costume.Animation)
				end

				-- Update it
				if data.GunslingerData.Costume.LastUpdateFrame ~= entity.FrameCount then
					mod:StevenHatUpdate(entity, data.GunslingerData.Costume)
					costume:Update()
					data.GunslingerData.Costume.LastUpdateFrame = entity.FrameCount
				end


				-- Render it
				local renderPos = entity.Position + entity.PositionOffset
				renderPos = Isaac.WorldToRenderPosition(renderPos) + offset
				costume:RenderLayer(0, renderPos)

				-- Schedule the post render callback
				local func = function()
					costume:RenderLayer(1, renderPos)

					if costume:GetLayer(2) then
						costume:RenderLayer(2, renderPos)
					end
				end

				-- Get the post render callback to use
				local callbackToUse = (entity.Type == EntityType.ENTITY_PICKUP and ModCallbacks.MC_POST_PICKUP_RENDER)
								   or (entity.Type == EntityType.ENTITY_SLOT   and ModCallbacks.MC_POST_SLOT_RENDER)
								   or ModCallbacks.MC_POST_NPC_RENDER

				mod.scheduleForUpdate(func, 0, callbackToUse)
			end
		end
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_NPC_RENDER, CallbackPriority.EARLY * 1000, mod.RenderGunslingerCostume)