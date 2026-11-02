local mod = FiendFolio

local PoopTypes = { --I'll just handwave it as the base is 220 weight
    {"hi", 300},
    {666, 20}, --Drop
    {667, 10}, --Cursed
    {668, 20}, --Bee
    {669, 5}, --Platinum
    {670, 20}, --Spider
    {671, 10}, --Cursed
    {673, 20}, --Fuzzy
    {674, 20}, --Trash
}

function mod:DingleBerryFFRoomClear(player, waves)
    if player:HasTrinket(TrinketType.TRINKET_DINGLE_BERRY) then
        local mult = player:GetTrinketMultiplier(TrinketType.TRINKET_DINGLE_BERRY)
        local count = 0
        mod.scheduleForUpdate(function()
            for _,dip in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.DIP, -1)) do
                --[[if waves == "Challenge" then --actually this would be very visible so i should not replace them at this point
                    if dip.FrameCount == 30 then
                        
                    end
                end]]
                if waves == "Challenge" then
                elseif count < mult then
                    if dip.FrameCount == 0 and dip.Position:Distance(player.Position) < 10 then
                        count = count+1
                        local rng = dip:GetDropRNG()
                        local subt = mod:weightedRNG(PoopTypes, rng)
                        if subt == "hi" then
                        else
                            local copied = mod:makeCopiedTable(dip:GetData())
                            local newDip = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.DIP, subt, dip.Position, dip.Velocity, player):ToFamiliar()
                            newDip:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                            for key,entry in pairs(copied) do
                                newDip:GetData()[key] = entry
                            end
                            dip:Remove()
                            --dip.SubType = subt
                        end
                    end
                end
            end
        end, 0)
    end
end