local mod = FiendFolio
local game = Game()

mod:AddTrinketCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, mod.ITEM.TRINKET.BREAKPOINT, function(_, entity, damage, flags, source, cooldown)
	local player = entity:ToPlayer()
	if player:HasTrinket(mod.ITEM.TRINKET.BREAKPOINT) then
		player:UseActiveItem(CollectibleType.COLLECTIBLE_PAUSE, UseFlag.USE_NOANIM)

		local currentPauseTimer = player:GetPauseTime()
		game:GetRoom():SetPauseTimer(math.max(currentPauseTimer, 150 * player:GetTrinketMultiplier(mod.ITEM.TRINKET.BREAKPOINT)))
		player:AnimateTrinket(mod.ITEM.TRINKET.BREAKPOINT, "UseItem")
	end
end, EntityType.ENTITY_PLAYER)