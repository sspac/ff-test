local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

function mod:CorruptedLarvaNewRoom()
    local room = game:GetRoom()

    if room:IsFirstVisit() and not room:IsClear() then
        for i = 0, game:GetNumPlayers() - 1 do
            local player = Isaac.GetPlayer(i)
            local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.CORRUPTED_LARVA)
            if mult > 0 then
                for _ = 1, mult do
                    Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, mod.ITEM.FAMILIAR.MINI_LEVEL_0_FLY, player.Position, Vector.Zero, player)
                end
            end
        end
    end
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.ITEM.TRINKET.CORRUPTED_LARVA, mod.CorruptedLarvaNewRoom)

function mod:CorruptedLarvaNoTarget(familiar)
    if familiar.SubType == mod.ITEM.FAMILIAR.MINI_LEVEL_0_FLY then
        local target = familiar.Target and familiar.Target:ToNPC()
        if target and not target:CanDevolve() then
            familiar.Target = nil
        end
    end
end
mod:AddEntityCallback(
    ModCallbacks.MC_FAMILIAR_UPDATE,
    EntityType.ENTITY_FAMILIAR,
    FamiliarVariant.BLUE_FLY,
    mod.ITEM.FAMILIAR.MINI_LEVEL_0_FLY,
    mod.CorruptedLarvaNoTarget,
    FamiliarVariant.BLUE_FLY
)

function mod:CorruptedLarvaCollision(familiar, entity)
    if familiar.SubType == mod.ITEM.FAMILIAR.MINI_LEVEL_0_FLY then
        local npc = entity:ToNPC()
        if npc and npc:IsActiveEnemy() and npc:IsVulnerableEnemy() and npc:CanDevolve() then
            game:DevolveEnemy(npc)
            familiar:Remove()
            sfx:Play(SoundEffect.SOUND_EDEN_GLITCH)
        end
        return true
    end
end
mod:AddEntityCallback(
    ModCallbacks.MC_PRE_FAMILIAR_COLLISION,
    EntityType.ENTITY_FAMILIAR,
    FamiliarVariant.BLUE_FLY,
    mod.ITEM.FAMILIAR.MINI_LEVEL_0_FLY,
    mod.CorruptedLarvaCollision,
    FamiliarVariant.BLUE_FLY
)