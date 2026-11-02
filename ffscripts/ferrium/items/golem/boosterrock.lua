local mod = FiendFolio
local game = Game()

local caches = {[0] = "Damage", [1] = "Tears", [2] = "Range", [3] = "Speed"}

function mod:BoosterRockNewRoom(player, data)
    local room = game:GetRoom()
    local seed = room:GetDecorationSeed()
    local rng = RNG()
    rng:SetSeed(seed)
    player:AddCacheFlags(CacheFlag.CACHE_ALL)
    local rand = caches[rng:RandomInt(4)]
    if rand == "Damage" then
        data.BoosterRockStats = {rand, 0.7}
    elseif rand == "Tears" then
        data.BoosterRockStats = {rand, 0.5}
    elseif rand == "Range" then
        data.BoosterRockStats = {rand, 80}
    elseif rand == "Speed" then
        data.BoosterRockStats = {rand, 0.22}
    end
end
mod:AddTrinketCallback("FF_NEW_ROOM_PLAYER_FERRIUM", mod.ITEM.ROCK.BOOSTER_ROCK, mod.BoosterRockNewRoom)