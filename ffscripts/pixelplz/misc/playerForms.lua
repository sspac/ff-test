local mod = FiendFolio



-- Get the next free Esau Jr. save slot to use, if possible
---@return integer?
function FiendFolio:GetFreeEsauJrSaveSlot()
	for index = 0, 3 do
		if not PlayerManager.GetEsauJrState(index) then
			return index
		end
	end
end

-- Get the Esau Jr. save slot of the given player
---@param player EntityPlayer
---@return integer?
function FiendFolio:GetEsauJrSaveSlot(player)
	return EntitySaveStateManager.GetEntityData(mod, player).EsauJrSaveSlot
end

-- Set the Esau Jr. save slot of the given player
---@param player EntityPlayer
---@param slot integer
function FiendFolio:SetEsauJrSaveSlot(player, slot)
	EntitySaveStateManager.GetEntityData(mod, player).EsauJrSaveSlot = slot
end



-- Check if the given player is in their Esau Jr. form
---@param player EntityPlayer
---@return boolean
function FiendFolio:IsEsauJr(player)
	return player:GetEffects():HasNullEffect(NullItemID.ID_ESAU_JR)
end

-- Get the stored Esau Jr. form of the given player
---@param player EntityPlayer
---@return EntityPlayer?
function FiendFolio:GetStoredEsauJrForm(player)
	local saveSlot = mod:GetEsauJrSaveSlot(player)

	if saveSlot then
		return PlayerManager.GetEsauJrState(saveSlot)
	end
end

-- Get the original, non-Esau Jr. form of a player
---@param player EntityPlayer
---@return EntityPlayer
function FiendFolio:GetMainPlayerForm(player)
	local otherForm = mod:GetStoredEsauJrForm(player)

	if otherForm and mod:IsEsauJr(player) then
		return otherForm
	else
		return player
	end
end



-- Handle setting up save slots and running callbacks for Esau Jr.
local nextEsauJrOwner

function mod:EsauJrUse(id, rng, player, useFlags, slot, varData)
	local newForm = mod:GetStoredEsauJrForm(player)
	local validSaveSlot = mod:GetFreeEsauJrSaveSlot()

	-- Already has a stored form, run the callback
	if newForm then
		Isaac.RunCallback(mod.CALLBACK.ESAU_JR_SWITCH_FORM, player, newForm)

	-- No stored form, but we can create one
	elseif validSaveSlot then
		mod:SetEsauJrSaveSlot(player, validSaveSlot)
		nextEsauJrOwner	= player -- The next created Esau Jr. will belong to this player
	else
		--print("girl help")
	end
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.EsauJrUse, CollectibleType.COLLECTIBLE_ESAU_JR)

-- Newly created Esau Jr. form
function mod:EsauJrInit(player)
	if mod:IsEsauJr(player) and nextEsauJrOwner then
		-- Set up its save slot
		local saveSlot = mod:GetEsauJrSaveSlot(nextEsauJrOwner)
		mod:SetEsauJrSaveSlot(player, saveSlot)

		-- Run the callback on it
		Isaac.RunCallback(mod.CALLBACK.ESAU_JR_SWITCH_FORM, nextEsauJrOwner, player)
		nextEsauJrOwner = nil
	end
end
mod:AddCallback(ModCallbacks.MC_PLAYER_INIT_POST_LEVEL_INIT_STATS, mod.EsauJrInit)



-- Handle running callbacks for Tainted Lazarus
function mod:FlipUse(id, rng, player, useFlags, slot, varData)
	local flippedForm = player:GetFlippedForm()

	if flippedForm then
		Isaac.RunCallback(mod.CALLBACK.TLAZARUS_SWITCH_FORM, player, flippedForm)
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_USE_ITEM, math.huge, mod.FlipUse, CollectibleType.COLLECTIBLE_FLIP)