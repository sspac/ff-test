local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local storyOfUndertale

local undertaleCrew = {
    {Gender = "Male",    Type = {EntityType.ENTITY_GOAT, 0, 0}, Scale = Vector(1.5,1.5)},
    {Gender = "Female",  Type = {EntityType.ENTITY_GOAT, 0, 0}, Scale = Vector(0.75,2)},
    {Gender = "Male",    Type = {EntityType.ENTITY_BONY, 0, 0}, Scale = Vector(1.5, 0.75)},
    {Gender = "Male",    Type = {EntityType.ENTITY_BONY, 0, 0}, Scale = Vector(0.75, 2)},
    {Gender = "Female",  Type = {mod.FF.Fishface.ID, mod.FF.Fishface.Var, 0}, Scale = Vector(1,1.5)},
    {Gender = "Unknown", Type = {mod.FF.Bloomer.ID, mod.FF.Bloomer.Var, 0}, Scale = Vector(1,1)},
}

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, id, rng, player, useflags, activeslot)
    for i = 1, #undertaleCrew do
        local ent = undertaleCrew[i].Type
        local npc = Isaac.Spawn(ent[1], ent[2], ent[3], player.Position + RandomVector()*10, Vector.Zero, player):ToNPC()
        npc:AddCharmed(EntityRef(player), -1)
        npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        npc:Update()
        mod:GetEntityData(npc).StoryOfUndertale = undertaleCrew[i].Scale
        --Slop code
        mod.scheduleForUpdate(function()
            storyOfUndertale = false
            sfx:Stop(SoundEffect.SOUND_HAPPY_RAINBOW)
            if npc and npc:Exists() then
			    npc:Remove()
            end
		end, 0, ModCallbacks.MC_POST_NEW_ROOM, true)
    end
    storyOfUndertale = true
    sfx:Play(SoundEffect.SOUND_HAPPY_RAINBOW, 1, 0, false, 0.25)
    return true
end, mod.ITEM.COLLECTIBLE.STORY_OF_UNDERTALE)

--Actually pissed that I need to do this for a joke item
--NPCs just refuse to SpriteScale indefinitely otherwise
--I can't even purely do it in NPC_UPDATE???
function mod:storyOfUndertaleUpdate(npc)
    if storyOfUndertale then
        local data = mod:GetEntityData(npc)
        if data.StoryOfUndertale then
            mod.scheduleForUpdate(function()
                if npc and npc:Exists() then
                    npc.SpriteScale = data.StoryOfUndertale
                end
            end, 0)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.storyOfUndertaleUpdate, EntityType.ENTITY_GOAT)
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.storyOfUndertaleUpdate, EntityType.ENTITY_BONY)