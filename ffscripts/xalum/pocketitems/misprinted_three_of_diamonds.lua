local mod = FiendFolio
local card = mod.ITEM.CARD.MISPRINTED_THREE_OF_DIAMONDS
local distance = Vector(0, 40)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, _, player, flags)
	local rng = player:GetCardRNG(card)
	local optionsIndex = rng:Next()

	for i = 1, 3 do
		local trinket = mod.GetItemFromCustomItemPool(mod.CustomPool.MISPRINTED_PENNY_TRINKETS, rng)
		local pickup = Isaac.Spawn(5, 350, trinket, player.Position + distance:Rotated(120 * i), Vector.Zero, player):ToPickup()
		pickup.OptionsPickupIndex = optionsIndex
	end
end, card)