local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

mod:AddPriorityCallback(ModCallbacks.MC_PRE_PLAYER_TAKE_DMG, -1 * math.huge, function(_, player, amount, flags, source, cooldown)
	-- I just really needed this to happen first and there are like 40 MC_ENTITY_TAKE_DAMAGE callbacks in this damn mod

	if source.Type == mod.FF.CaveSpider.ID and source.Variant == mod.FF.CaveSpider.Var then
		if mod.WillDamageBeFatal(player, amount, flags, true, true) then
			return false
		end
	end

end)