local mod = FiendFolio

local girls = {
    [PlayerType.PLAYER_MAGDALENE] = true,
    [PlayerType.PLAYER_EVE] = true,
    [PlayerType.PLAYER_LILITH] = true,
    [PlayerType.PLAYER_BETHANY] = true,
    [PlayerType.PLAYER_MAGDALENE_B] = true,
    [PlayerType.PLAYER_EVE_B] = true,
    [PlayerType.PLAYER_LILITH_B] = true,
    [PlayerType.PLAYER_BETHANY_B] = true,
    [mod.PLAYER.SLIPPY] = true,
    [mod.PLAYER.CHINA] = true,
    [mod.PLAYER.FRIEND] = true,
    [mod.PLAYER.BRIEND] = true,
    [mod.PLAYER.INABA] = true,
    [mod.PLAYER.BINABA] = true,
    [mod.PLAYER.FREEZERJR] = true,
}
--Apollyon is Non-Binary, not a girl

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, coll, bool)
    if coll and coll:ToPlayer() and pickup.SubType == mod.ITEM.COLLECTIBLE.GIRL_DINNER then
        local player = coll:ToPlayer()
        local d = mod:GetEntityData(player)
        if d.randomGirlDecided == nil and (player:GetPlayerType() == PlayerType.PLAYER_EDEN or player:GetPlayerType() == PlayerType.PLAYER_EDEN_B) then
            if player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.GIRL_DINNER):RandomInt(4) == 0 then
                d.randomGirlDecided = true
            else
                d.randomGirlDecided = false
            end
        end
        if girls[player:GetPlayerType()] or d.randomGirlDecided then
        else
            Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_PICKUP_COLLISION, pickup.Variant, pickup, coll, bool)
            return false
        end
    end
end, 100)