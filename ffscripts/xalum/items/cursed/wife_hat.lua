local mod = FiendFolio
local game = Game()
local veilCurse = 1 << (mod.curses.veilCurse - 1)

mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, function()
	if Retribution then
		Retribution.AddCursedTrinket(mod.ITEM.TRINKET.WIFE_HAT, 7, true)

		mod:AddCallback(Retribution.Callback.GET_CURSED_TRINKET, function()
			if not PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_BLACK_CANDLE) then
				local level = game:GetLevel()
				level:AddCurse(veilCurse)
			end
		end, mod.ITEM.TRINKET.WIFE_HAT)

		mod:AddPriorityCallback(ModCallbacks.MC_POST_CURSE_EVAL, CallbackPriority.LATE, function(_, curseMask)
			if PlayerManager.AnyoneHasTrinket(mod.ITEM.TRINKET.WIFE_HAT) then
				return curseMask | (veilCurse)
			end
		end)

		mod:AddCallback(Retribution.Callback.SELL_CURSED_TRINKET, function(_, player)
			local level = game:GetLevel()
			level:RemoveCurses(veilCurse)
		end, mod.ITEM.TRINKET.WIFE_HAT)
	end
end)