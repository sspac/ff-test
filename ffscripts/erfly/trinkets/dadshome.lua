local mod = FiendFolio
local game = Game()

mod:AddTrinketCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.ITEM.TRINKET.DADS_HOME, function ()
    mod.scheduleForUpdate(function()
        local dadsHomeMult = mod.getTrinketMultiplierAcrossAllPlayers(mod.ITEM.TRINKET.DADS_HOME)
        if dadsHomeMult > 0 then
            if game:GetRoom():IsFirstVisit() then
                local safePlayer = Isaac.GetPlayer()
                local rng = safePlayer:GetTrinketRNG(mod.ITEM.TRINKET.DADS_HOME)
                local chance = math.max(6 - dadsHomeMult, 2)
                if rng:RandomInt(chance) == 1 then
                    local playerList = {}
                    mod.AnyPlayerDo(function(anyPlayer)
                        if anyPlayer:HasTrinket(mod.ITEM.TRINKET.DADS_HOME) then
                            table.insert(playerList, anyPlayer)
                        end
                    end)

                    local selectedPlayer
                    if #playerList > 0 then
                        selectedPlayer = playerList[rng:RandomInt(#playerList) + 1]
                    end
                    if not selectedPlayer then
                        selectedPlayer = safePlayer
                    end
                    selectedPlayer:UseCard(mod.ITEM.CARD.GREEN_HOUSE, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOHUD)
                    selectedPlayer:AnimateTrinket(mod.ITEM.TRINKET.DADS_HOME, "UseItem")
                end
            end
        end
    end, 2, ModCallbacks.MC_POST_UPDATE, true)
end)