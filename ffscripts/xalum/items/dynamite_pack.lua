local mod = FiendFolio
local dynamitePack = mod.ITEM.COLLECTIBLE.DYNAMITE_PACK

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, item, rng, player, flags)
	local offset = flags & UseFlag.USE_CARBATTERY > 0 and 60 or 0

	for i = 1, 3 do
		Isaac.Spawn(5, 41, 0, player.Position, Vector(0, 3):Rotated(offset + 120 * i), player)
	end

	return true
end, dynamitePack)