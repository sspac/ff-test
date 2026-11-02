local mod = FiendFolio
local game = Game()

local base = 6.5
local floorAdditive = 0.5
local function npcSpawned(_, npc)
    mod.scheduleForUpdate(function ()
        local level = game:GetLevel()
        local dmg = (base*PlayerManager.GetNumCollectibles(mod.ITEM.COLLECTIBLE.CROSS_NECKLACE)) + (floorAdditive*level:GetAbsoluteStage())

        if npc.Type ~= 33 and npc.MaxHitPoints <= dmg and not (npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) or npc:HasEntityFlags(EntityFlag.FLAG_CHARM)) then
            npc:TakeDamage(dmg*5, DamageFlag.DAMAGE_INVINCIBLE, EntityRef(Isaac.GetPlayer(1)), 0)

            --do fancy vfx wherever it happened
            local p = mod:beahPoof(npc.Position, mod.FF.CrossNecklace.Sub)
            p.DepthOffset = 9999
        end
    end, 0, ModCallbacks.MC_POST_UPDATE, true)
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_NPC_INIT, mod.ITEM.COLLECTIBLE.CROSS_NECKLACE, npcSpawned)