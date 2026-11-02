-- Snooze Button --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, id, rng, player, useflags, activeslot, customvardata)
	mod:skipCardRoom()
end, FiendFolio.ITEM.COLLECTIBLE.SNOOZE_BUTTON)