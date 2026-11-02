local mod = FiendFolio
local music = MusicManager()

-- Skinless
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function (_, npc)
    music:Crossfade(mod.Music.Skinless)
end, EntityType.ENTITY_HUSH_SKINLESS)