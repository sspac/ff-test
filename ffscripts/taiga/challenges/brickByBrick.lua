-- Brick By Brick --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

mod:AddChallengeCallback(ModCallbacks.MC_PLAYER_INIT_POST_LEVEL_INIT_STATS, mod.challenges.brickByBrick, function(_, player)
	--The Golden Brick must WIN
	player:TryRemoveTrinket(FiendFolio.ITEM.ROCK.ROLLING_ROCK)
	player:AddTrinket(FiendFolio.ITEM.ROCK.BRICK_ROCK + TrinketType.TRINKET_GOLDEN_FLAG)
end)