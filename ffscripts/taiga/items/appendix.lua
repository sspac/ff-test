-- Appendix --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

mod.AppendixSpawnableHearts = {}
for i = 1, 40 do table.insert(mod.AppendixSpawnableHearts, {5, 10, 1}) end -- red heart
for i = 1, 40 do table.insert(mod.AppendixSpawnableHearts, {5, 10, 2}) end -- half red heart
--for i = 1, 2 do table.insert(mod.AppendixSpawnableHearts, {5, 10, 5}) end -- double red heart
for i = 1, 1 do table.insert(mod.AppendixSpawnableHearts, {5, 10, 9}) end -- scared red heart
for i = 1, 2 do table.insert(mod.AppendixSpawnableHearts, {5, 10, 12}) end -- rotten heart
for i = 1, 1 do table.insert(mod.AppendixSpawnableHearts, {5, FiendFolio.PICKUP.VARIANT.MORBID_HEART, 0}) end -- morbid heart

FiendFolio.AddItemPickupCallback(function(player, added)
	mod:AddLeakyHearts(player, 2)
	
	local rng = player:GetCollectibleRNG(FiendFolio.ITEM.COLLECTIBLE.APPENDIX)
	for i = 1, rng:RandomInt(2) + 2 do
		local pickup = mod.AppendixSpawnableHearts[rng:RandomInt(#mod.AppendixSpawnableHearts) + 1]
		Isaac.Spawn(pickup[1], pickup[2], pickup[3], game:GetRoom():FindFreePickupSpawnPosition(player.Position, 40, true), nilvector, nil)
	end
end, nil, FiendFolio.ITEM.COLLECTIBLE.APPENDIX)