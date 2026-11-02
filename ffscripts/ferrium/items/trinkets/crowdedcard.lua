local mod = FiendFolio
local game = Game()

local bal = {
    Chance = {5, 5, 33},
}

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_COLLISION, function(_, player, coll, low)
    if coll.Type == 5 and mod:IsPickupAHeart(coll.Variant) then
        if player:HasTrinket(mod.ITEM.TRINKET.CROWDED_CARD) then
            local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.CROWDED_CARD)
            local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.CROWDED_CARD)
            local pickup = coll:ToPickup()
            local chance = math.min(bal.Chance[3], bal.Chance[1]+bal.Chance[2]*mult)
            mod.scheduleForUpdate(function()
                if (pickup:GetSprite():GetAnimation() == "Collect" or pickup.EntityCollisionClass == EntityCollisionClass.ENTCOLL_NONE) and rng:RandomInt(100) < chance then
                    local room = game:GetRoom()
                    local dynamicPool = {}
                    for _, data in pairs(mod.UnbiasedPickups["Hearts"]) do
                        if data.Unlocked() then
                            if not data.Chance or rng:RandomFloat() < data.Chance then
                                table.insert(dynamicPool, data.ID)
                            end
                        end
                    end
                    local choice = dynamicPool[rng:RandomInt(#dynamicPool) + 1]
                    if tonumber(choice) then
                        pickup = Isaac.Spawn(5, mod.CardNamePickups["Hearts"], choice, room:FindFreePickupSpawnPosition(player.Position + RandomVector():Resized(40)), Vector.Zero, player)
                    else
                        pickup = Isaac.Spawn(5, choice.Var, choice.Sub, room:FindFreePickupSpawnPosition(player.Position + RandomVector():Resized(40)), Vector.Zero, player)
                    end
                end
            end, 0)
        end
    end
end)