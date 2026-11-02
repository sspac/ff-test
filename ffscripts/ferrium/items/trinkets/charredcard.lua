local mod = FiendFolio
local game = Game()

local bal = {
    keepAway = 100, --tries to be at least this far away from players
    enemyExtras = 2, --adds this many copies if nearby an enemy
    enemyDist = 60, --only if this close to an enemy
    bombStagger = 4,
}

function mod:findCharredBombSpot(p, rng, mult)
    local room = game:GetRoom()
    local size = room:GetGridSize()
    local backup = {}
    local goods = {}
    local players = {}
    for i = 1, game:GetNumPlayers() do
		table.insert(players, Isaac.GetPlayer(i-1))
    end
    for i=0, size do
        if room:GetGridCollision(i) == GridCollisionClass.COLLISION_NONE then
            local pos = room:GetGridPosition(i)
            table.insert(backup, pos)
            for _,player in ipairs(players) do
                if player.Position:Distance(pos) > bal.keepAway then
                    table.insert(goods, pos)
                    local check
                    for _,npc in ipairs(Isaac.FindInRadius(pos, bal.enemyDist, EntityPartition.ENEMY)) do
                        if not mod:isFriend(npc) and npc:IsVulnerableEnemy() and mod:superExists(npc) then
                            check = true
                            break
                        end
                    end
                    if check then
                        for k=1,bal.enemyExtras do
                            table.insert(goods, pos)
                        end
                    end
                end
            end
        end
    end

    local tab = {}
    if #goods > 0 then
        local results = mod:getSeveralDifferentNumbers(mult, #goods, rng)
        for i=1,mult do
            table.insert(tab, goods[results[i]])
        end
        return tab
    elseif #backup > 0 then
        local results = mod:getSeveralDifferentNumbers(mult, #backup, rng)
        for i=1,mult do
            table.insert(tab, backup[results[i]])
        end
        return tab
    else
        return {p.Position}
    end
end

function mod:charredCardBomb(player, bomb)
    if player:HasTrinket(mod.ITEM.TRINKET.CHARRED_CARD) then
        local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.CHARRED_CARD)
        local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.CHARRED_CARD)

        local results = mod:findCharredBombSpot(player, rng, mult)
        local spawn = 0
        for _,pos in ipairs(results) do
            spawn = spawn+1
            mod.scheduleForUpdate(function()
                local trol = Isaac.Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_TROLL, 0, pos, Vector.Zero, player):ToBomb()
                trol:AddTearFlags(player:GetBombFlags())
            end, bal.bombStagger*spawn)
        end
    end
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_PLAYER_USE_BOMB, mod.ITEM.TRINKET.CHARRED_CARD, mod.charredCardBomb)