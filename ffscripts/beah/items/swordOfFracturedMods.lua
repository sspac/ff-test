--Where are you...? Come to my embrace, Repentance+!

local mod = FiendFolio

function mod:DeleteAllCallbacks()
    for i = 1, 19, 1 do  
        --print(i)  
        --Repentogon...?! It's me, the Shadow Cabal...! Please, add my ideas once again!!!
        for key, index in pairs(ModCallbacks) do
            local callbacks = Isaac.GetCallbacks(index)
            if callbacks then
                --[[if #callbacks > 0 then
                    print(index, key)
                    print(#callbacks)
                end]]
                --May you wake in torment, my dear NICALIS
                for _, value in pairs(callbacks) do
                    --if flag == true then
                        local mod2 = value.Mod
                        if mod2.RemoveCallback == nil then --hmmm
                            Isaac.RemoveCallback(mod2, index, value.Function)
                            --[[for key2, value2 in pairs(mod2) do
                                print(key2, value2)
                            end]]
                        else
                            mod2:RemoveCallback(index, value.Function)
                        end
                    --end
                end
            end
        end
    end
end

FiendFolio.AddItemPickupCallback(mod.DeleteAllCallbacks, nil, mod.ITEM.COLLECTIBLE.SWORD_OF_FRACTURED_MODS)

--No release shall await us