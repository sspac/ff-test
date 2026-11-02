local mod = FiendFolio
local game = Game()

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player, flags)
    local sd = mod:GetEntityData(player).ffsavedata.RunEffects
    sd.PinkCowNum = (sd.PinkCowNum or 0)+4
    mod:trySayAnnouncerLine(mod.Sounds.VAObjectPinkCow, flags, 30)
end, mod.ITEM.CARD.PINK_COW)

function mod:PinkCowNewRoom(player, d)
    local room = game:GetRoom()
    if not room:IsClear() then
        local sd = d.ffsavedata
        if sd and sd.RunEffects and sd.RunEffects.PinkCowNum then
            local rng = player:GetCardRNG(mod.ITEM.CARD.PINK_COW)
            mod.scheduleForUpdate(function()
                local enemies = {}
                for _,entity in ipairs(Isaac.FindInRadius(player.Position, 1050, EntityPartition.ENEMY)) do
                    if entity:ToNPC() and (not mod:isFriend(entity)) and entity:IsActiveEnemy() and entity:IsVulnerableEnemy()
                    and not (entity:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) or entity:HasEntityFlags(EntityFlag.FLAG_NO_TARGET))
                    and not mod:GetEntityData(entity).FFPacifiedDuration then
                        table.insert(enemies, entity)
                    end
                end
                if #enemies > 0 then
                    local chosen = enemies[rng:RandomInt(#enemies)+1]
                    local mult = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND)+1
                    mod.AddPacified(chosen, player, 300*mult)
                    --This would lead to infinite breaking with stuff like midas touch and a spawner
                    --[[if chosen:IsBoss() then
                        local mult = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND)+1
                        mod.AddPacified(chosen, player, 300*mult)
                    else
                        mod.AddPacified(chosen, player, 9999)
                    end]]

                    sd.RunEffects.PinkCowNum = sd.RunEffects.PinkCowNum-1
                end

                if sd.RunEffects.PinkCowNum <= 0 then
                    sd.RunEffects.PinkCowNum = nil
                end
            end, 1)
        end
    end
end