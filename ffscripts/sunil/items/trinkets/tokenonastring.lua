local mod = FiendFolio
local game = Game()


--thanks catinsurance for the effect to make trinkets drop something on new floor hehe
--thanks amy for the idea to make it disappear after one use so it's actually interesting and can be a real thing probably
function mod:TokenOnAStringSpawn()
    for i = 0,game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasTrinket(mod.ITEM.TRINKET.TOKEN_ON_A_STRING) then
            local spawnPos = game:GetRoom():FindFreePickupSpawnPosition(player.Position, 40)
            Isaac.Spawn(5, 961, 0, spawnPos, Vector.Zero, player)
            player:TryRemoveTrinket(mod.ITEM.TRINKET.TOKEN_ON_A_STRING)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.TokenOnAStringSpawn)
