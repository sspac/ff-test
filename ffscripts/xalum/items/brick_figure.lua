local mod = FiendFolio
local brickFigure = mod.ITEM.COLLECTIBLE.BRICK_FIGURE
local MORPH_CHANCE = 0.2

mod.AddItemPickupCallback(function(player, added)
	local room = Game():GetRoom()
	local position = room:FindFreePickupSpawnPosition(player.Position, 40, true)

	if mod.ACHIEVEMENT.BRICK_SEPARATOR:IsUnlocked() then
		Isaac.Spawn(5, 300, mod.ITEM.CARD.BRICK_SEPERATOR, position, Vector.Zero, player)
	else
		Isaac.Spawn(5, 300, mod.ITEM.CARD.STUD, position, Vector.Zero, player)
	end

	for i = 1, 4 do
		local position = room:FindFreePickupSpawnPosition(player.Position, 40, true)
		Isaac.Spawn(5, 300, mod.ITEM.CARD.STUD, position, Vector.Zero, player)
	end
end, nil, brickFigure)

mod:AddCollectibleCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, brickFigure, function(_, pickup)
	if pickup.SubType == CoinSubType.COIN_PENNY then
		local data = mod:GetEntityData(pickup)
		data.wasAlreadyInRoom = data.wasAlreadyInRoom ~= nil and data.wasAlreadyInRoom or pickup.FrameCount == 0

		if pickup.FrameCount == 1 and not data.wasAlreadyInRoom then
			local rng = PlayerManager.FirstCollectibleOwner(brickFigure):GetCollectibleRNG(brickFigure)
			if rng:RandomFloat() < MORPH_CHANCE then
				pickup:Morph(5, 300, mod.ITEM.CARD.STUD, true, true, true)
			end
		end
	end
end, PickupVariant.PICKUP_COIN)