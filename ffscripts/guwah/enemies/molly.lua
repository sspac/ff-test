local mod = FiendFolio
local game = Game()
local rng = RNG()
local sfx = SFXManager()

function mod:MollyInit(npc)
    mod:GetEntityData(npc).IsMolly = true
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    local data = mod:GetEntityData(npc)
    if data.IsMolly then
        local championcolor = -1
        if npc:IsChampion() then
            championcolor = npc:GetChampionColorIdx()
        end
        npc:Morph(280,0,0,championcolor)
        npc:ReplaceSpritesheet(0, "gfx/monsters/afterbirth/280.000_blackglobinbody_corpse.png", true)
        data.IsMolly = false
    end
end, EntityType.ENTITY_GUSHER)