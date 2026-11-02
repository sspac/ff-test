local mod = FiendFolio
local game = Game()

---@param entity Entity
local function getPlayerFromSource(entity)
    local player = entity:ToPlayer()
    if player then
        return player
    end

    if entity.SpawnerEntity and entity.SpawnerEntity:ToPlayer() then
        return entity.SpawnerEntity:ToPlayer()
    end
end

function mod:InfestationPointFiveDamage(npc, amount, _, source)
    local trinket = PlayerManager.GetTotalTrinketMultiplier(mod.ITEM.TRINKET.INFESTATION_ONE_POINT_FIVE)

    local entity = source.Entity
    local player = entity and getPlayerFromSource(entity)
    if npc.HitPoints - amount <= 0
    and player
    and npc:IsVulnerableEnemy()
    and npc:IsActiveEnemy()
    and not npc:HasEntityFlags(EntityFlag.FLAG_NO_REWARD) then
        -- Spawn in a frame so that it doesn't immediately die
        Isaac.CreateTimer(function ()
            for _ = 1, trinket do
                local spawnPos = game:GetRoom():FindFreeTilePosition(npc.Position, 7)
                local spider = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_SPIDER, mod.ITEM.FAMILIAR.BLUE_BABY_SPIDER_SUBTYPE, spawnPos, Vector.Zero, player)
                spider:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            end
        end, 1, 1, false)
    end
end

mod:AddTrinketCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.ITEM.TRINKET.INFESTATION_ONE_POINT_FIVE, mod.InfestationPointFiveDamage)