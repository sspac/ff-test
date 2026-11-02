local mod = FiendFolio



-- Get the main player from any given one
---@param player EntityPlayer
---@return EntityPlayer
function FiendFolio:GetMainPlayer(player, allowDeadLazarus)
	local checkPlayer = player
	local regularPlayer
	local tries = 0

	while not regularPlayer and tries < 100 do
		tries = tries + 1

		-- Extra player, such as Strawman
		if checkPlayer.Parent and checkPlayer.Parent:ToPlayer() then
			checkPlayer = checkPlayer.Parent:ToPlayer() ---@diagnostic disable-line: cast-local-type

		-- Main / twin player
		else
			regularPlayer = checkPlayer
		end
	end

	-- Fuck Tainted Lazarus >:(
	if regularPlayer:GetPlayerType() == PlayerType.PLAYER_LAZARUS2_B and not regularPlayer:IsHologram() and not allowDeadLazarus then
		return regularPlayer:GetFlippedForm() ---@diagnostic disable-line: return-type-mismatch
	else
		return regularPlayer:GetMainTwin()
	end
end

-- Check if the given player is the main one
---@param player EntityPlayer
---@return boolean
function FiendFolio:IsMainPlayer(player)
	return player:GetPlayerIndex() == mod:GetMainPlayer(player):GetPlayerIndex()
end



-- Get the source player from any given entity (if possible)
---@param entity Entity
---@return EntityPlayer?
function FiendFolio:GetPlayerFromEntity(entity)
	local checkEntity = entity
	local player
	local tries = 0

	while not player and tries < 100 do
		tries = tries + 1

		-- No entity found
		if not checkEntity then
			break

		-- Entity is already a player
		elseif checkEntity:ToPlayer() then
			player = checkEntity:ToPlayer()

		-- Entity is a familiar, easy to get its player
		elseif checkEntity:ToFamiliar() and not checkEntity:ToFamiliar():IsCharmed() then
			player = checkEntity:ToFamiliar().Player

		-- Continue with the parent or spawner entity
		else
			checkEntity = checkEntity.Parent or checkEntity.SpawnerEntity
		end
	end

	return player
end



-- Get the source familiar from any given entity (if possible)
---@param entity Entity
---@return EntityFamiliar?
function FiendFolio:GetFamiliarFromEntity(entity)
	local checkEntity = entity
	local familiar
	local tries = 0

	while not familiar and tries < 100 do
		tries = tries + 1

		-- No entity found
		if not checkEntity then
			break

		-- Entity is already a familiar
		elseif checkEntity:ToFamiliar() then
			familiar = checkEntity:ToFamiliar()

		-- Continue with the parent or spawner entity
		else
			checkEntity = checkEntity.Parent or checkEntity.SpawnerEntity
		end
	end

	return familiar
end