local mod = FiendFolio
local game = Game()

mod.AddItemPickupCallback(function(player, added)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.THE_DELUXE) then
		player:AddHearts(99)
	else
		player:AddHearts(-2)
		if player:GetHearts() == 0 then
			player:AddHearts(1)
			if player:GetPlayerType() == PlayerType.PLAYER_MAGDALENE_B and player:GetHearts() > 1 then
				player:AddHearts(1 - player:GetHearts())
			end
		end
	end
    if REPENTANCE_PLUS and Isaac.GetPersistentGameData():Unlocked(Achievement.BUTTER) then
        local spawnpos = game:GetRoom():FindFreePickupSpawnPosition(player.Position, 1, true)
        local butter = Isaac.Spawn(5, 350, TrinketType.TRINKET_BUTTER, spawnpos, Vector.Zero, player)
    end
end, nil, mod.ITEM.COLLECTIBLE.BACON_GREASE)