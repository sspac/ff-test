local mod = FiendFolio
local game = Game()

-- this isnt even a gun
-- and it's the only one i've done
-- and the only one i'll ever do?
-- maybe?
-- wait cati already did this bit FUCK

function mod:HandleZitEffect(player)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_LARGE_ZIT) then
		local aim = mod.GetCorrectedFiringInput(player)
        if aim:Length() > 0.5 and game:GetFrameCount() % 30 == 0 then
			local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_LARGE_ZIT)
            if rng:RandomFloat() < 1/3 then
				--Second ever use of DoZitEffect
				player:DoZitEffect(aim:Normalized())
			end
		end
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, CollectibleType.COLLECTIBLE_LARGE_ZIT, mod.HandleZitEffect, FiendFolio.PLAYER.FRIEND)
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, CollectibleType.COLLECTIBLE_LARGE_ZIT, mod.HandleZitEffect, FiendFolio.PLAYER.BRIEND)
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, CollectibleType.COLLECTIBLE_LARGE_ZIT, mod.HandleZitEffect, FiendFolio.PLAYER.BINABA)