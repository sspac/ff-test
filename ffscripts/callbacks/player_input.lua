local mod = FiendFolio

-- "FF_PLAYER_INPUT_ACTION"
-- Optimization callback for MC_INPUT_ACTION to minimize redundant player checks and GetData calls.
--[[
mod:AddCallback("FF_PLAYER_INPUT_ACTION", function(_, player, data, inputHook, action)
    -- ...
end)
]]

mod:AddPriorityCallback(ModCallbacks.MC_INPUT_ACTION, -1, function(_, entity, hook, action)
	local player = entity and entity:ToPlayer()
	if player then
		local data = mod:GetEntityData(player)
		return Isaac.RunCallbackWithParam("FF_PLAYER_INPUT_ACTION", hook, player, data, hook, action)
	end
end)
