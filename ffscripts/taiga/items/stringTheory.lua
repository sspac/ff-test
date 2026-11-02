-- String Theory --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

function mod:stringTheoryUpdate(player)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.STRING_THEORY) then
		local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
		
		local enemies = Isaac.FindInRadius(player.Position, 120, EntityPartition.ENEMY)
		for _, enemy in ipairs(enemies) do
			if enemy:ToNPC() and not mod:isFriend(enemy) then
				if enemy:ToNPC():IsBoss() then
					FiendFolio.AddSewn(enemy, player, 90 * secondHandMultiplier, nil, true, 0.5)
				else
					FiendFolio.AddSewn(enemy, player, 15 * secondHandMultiplier, nil, true, 0.5)
				end
			end
		end
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, FiendFolio.ITEM.COLLECTIBLE.STRING_THEORY, mod.stringTheoryUpdate)