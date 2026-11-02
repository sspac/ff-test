-- Implements FF-specific variants of player callbacks that use PlayerType as their optional param instead of PlayerVariant.
-- This is both for convenience and for optimization/efficiency.
local CALLBACKS_WITH_PLAYER_VARIANT_PARAM = {
	[ModCallbacks.MC_POST_PLAYER_INIT] = FiendFolio.CALLBACK.FF_POST_PLAYER_INIT,
	[ModCallbacks.MC_PRE_PLAYER_UPDATE] = FiendFolio.CALLBACK.FF_PRE_PLAYER_UPDATE,
	[ModCallbacks.MC_POST_PLAYER_UPDATE] = FiendFolio.CALLBACK.FF_POST_PLAYER_UPDATE,
	[ModCallbacks.MC_PRE_PLAYER_RENDER] = FiendFolio.CALLBACK.FF_PRE_PLAYER_RENDER,
	[ModCallbacks.MC_POST_PLAYER_RENDER] = FiendFolio.CALLBACK.FF_POST_PLAYER_RENDER,
	[ModCallbacks.MC_PRE_PLAYER_COLLISION] = FiendFolio.CALLBACK.FF_PRE_PLAYER_COLLISION,
	[ModCallbacks.MC_POST_PLAYER_COLLISION] = FiendFolio.CALLBACK.FF_POST_PLAYER_COLLISION,
	[ModCallbacks.MC_PRE_PLAYER_TAKE_DMG] = FiendFolio.CALLBACK.FF_PRE_PLAYER_TAKE_DMG,
	[ModCallbacks.MC_PRE_PLAYER_TRIGGER_ROOM_CLEAR] = FiendFolio.CALLBACK.FF_PRE_PLAYER_TRIGGER_ROOM_CLEAR,
	[ModCallbacks.MC_POST_PLAYER_TRIGGER_ROOM_CLEAR] = FiendFolio.CALLBACK.FF_POST_PLAYER_TRIGGER_ROOM_CLEAR,
	[ModCallbacks.MC_PRE_PLAYER_USE_BOMB] = FiendFolio.CALLBACK.FF_PRE_PLAYER_USE_BOMB,
	[ModCallbacks.MC_POST_PLAYER_USE_BOMB] = FiendFolio.CALLBACK.FF_POST_PLAYER_USE_BOMB,
	[ModCallbacks.MC_PRE_PLAYER_GRID_COLLISION] = FiendFolio.CALLBACK.FF_PRE_PLAYER_GRID_COLLISION,
	[ModCallbacks.MC_PLAYER_GRID_COLLISION] = FiendFolio.CALLBACK.FF_PLAYER_GRID_COLLISION,
}

for vanillaCallbackID, ffCallbackID in pairs(CALLBACKS_WITH_PLAYER_VARIANT_PARAM) do
	FiendFolio:AddCallback(vanillaCallbackID, function(_, player, arg1, ...)
		-- Get the functions for the FF callback but execute them using the vanilla callback's logic.
		local callbackIterator = Isaac.GetCallbackIterator(ffCallbackID, player:GetPlayerType())
		local ret =  Isaac.RunCallbackOverIterator(vanillaCallbackID, callbackIterator, player, arg1, ...)
		if vanillaCallbackID == ModCallbacks.MC_PRE_PLAYER_RENDER and type(ret) == "userdata" and ret.X and ret.Y then
			-- bluh
			return ret - arg1
		end
		return ret
	end, PlayerVariant.PLAYER)
end
