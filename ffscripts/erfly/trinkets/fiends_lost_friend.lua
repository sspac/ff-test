local mod = FiendFolio
local game = Game()

function mod:fiendsLostFriendNewRoom(player)
    if player:HasTrinket(mod.ITEM.TRINKET.FIENDS_LOST_FRIEND) then
        local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.FIENDS_LOST_FRIEND)
        for i = 1, math.floor(mult) do
            local minion = Isaac.Spawn(1000, mod.PICKUP.VARIANT.FIEND_MINION_EFFECT, 1, player.Position, Vector.Zero, player)
            minion.EntityCollisionClass = 4
            minion.Parent = player

            local data = mod:GetEntityData(minion)
            data.hollow = true
            data.canreroll = false
            data.fiendsLostFriend = true
            minion:Update()
        end
    end
end