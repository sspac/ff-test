local mod = FiendFolio
local game = Game()

--Brought to you by Abortionbirth Pack 3!!

function mod:InfestedPipelineNewLevel(player, d)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.INFESTED_PIPELINE) then
        d.InfestedPipelineQueueFarts = 53 + (player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.INFESTED_PIPELINE)-1)
        local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.INFESTED_PIPELINE)
        for i=1,100 do
            Isaac.Spawn(1000, 63, 0, player.Position+Vector(20, 0):Rotated(rng:RandomInt(360)), Vector.Zero, player)
        end
    end
end
mod:AddCollectibleCallback("FF_NEW_LEVEL_PLAYER_FERRIUM", mod.ITEM.COLLECTIBLE.INFESTED_PIPELINE, mod.InfestedPipelineNewLevel)

function mod:InfestedPipelineUpdate(player)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.INFESTED_PIPELINE) then
        local d = mod:GetEntityData(player)
        local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.INFESTED_PIPELINE)
        if d.InfestedPipelineQueueFarts and d.InfestedPipelineQueueFarts > 0 and player.FrameCount % 8 == 0 then
            game:Fart(player.Position, 60, player, 1, 1)
            d.InfestedPipelineQueueFarts = d.InfestedPipelineQueueFarts-1
        end

        d.InfestedPipelineCooldown = d.InfestedPipelineCooldown or 0
        if d.InfestedPipelineCooldown > 0 then
            local mult = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.INFESTED_PIPELINE)
            d.InfestedPipelineCooldown = d.InfestedPipelineCooldown-mult
        else
            if rng:RandomInt(60) == 0 then
                game:CharmFart(player.Position, 40, player)
                for _,entity in ipairs(Isaac.FindInRadius(player.Position, 999, EntityPartition.ENEMY)) do
                    if entity:ToNPC() and not mod:isCharm(entity) and not entity:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) then
                        entity:AddCharmed(EntityRef(player), 80)
                    end
                end
                d.InfestedPipelineCooldown = 50
            end
        end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.COLLECTIBLE.INFESTED_PIPELINE, mod.InfestedPipelineUpdate)