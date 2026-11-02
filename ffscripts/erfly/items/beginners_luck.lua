local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

function mod:beginnersLuckPostNewLevel(player)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.BEGINNERS_LUCK) then
		player:AddCacheFlags(CacheFlag.CACHE_LUCK, true)
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PLAYER_NEW_LEVEL, mod.ITEM.COLLECTIBLE.BEGINNERS_LUCK, mod.beginnersLuckPostNewLevel)