--[[
Whatever man.
	
local mod = FiendFolio
mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, card, player, flags)
	if mod.DoVanillaItemTweaks then
		for i = 1, 3 do
			mod.ThrowFriendlySkuzz(player, RandomVector() * 2)
			mod:ThrowBlueBeetle(player)
			Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_SPIDER, mod.ITEM.FAMILIAR.BLUE_BABY_SPIDER_SUBTYPE, player.Position, Vector.Zero, player)
		end
	end
end, Card.RUNE_BERKANO)

]]