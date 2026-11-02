local mod = FiendFolio

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, coll)
    if pickup.Price < 0 and pickup.Price > -10 and pickup.Price ~= PickupPrice.PRICE_SPIKES then
        if coll and coll:ToPlayer() then
            local player = coll:ToPlayer()
            if player:HasTrinket(mod.ITEM.ROCK.DEVOURING_GEODE) then
                local holdingDevouringGeode
                local geodeCount = 0
                local targetGeode
                for i=0,1 do
                    local trinket = player:GetTrinket(i)
                    if mod:GetRealTrinketId(trinket) == mod.ITEM.ROCK.DEVOURING_GEODE then
                        holdingDevouringGeode = i
                        geodeCount = geodeCount+1
                    elseif mod.IsGeode(trinket) then
                        targetGeode = i
                        geodeCount = geodeCount+1
                    end
                end
                local done
                if not holdingDevouringGeode then
                    if geodeCount == 2 then
                        player:TryRemoveTrinket(player:GetTrinket(0))
                        done = true
                    end
                else
                    if targetGeode then
                        player:TryRemoveTrinket(player:GetTrinket(targetGeode))
                        done = true
                    else
                        player:TryRemoveTrinket(mod.ITEM.ROCK.DEVOURING_GEODE)
                        done = true
                    end
                end

                if done then
                    local poof = Isaac.Spawn(1000, EffectVariant.POOF01, 0, pickup.Position, Vector.Zero, pickup):ToEffect()
                    poof.Color = Color(0.2, 0.2, 0.2, 1, 0, 0, 0)
                    SFXManager():Play(SoundEffect.SOUND_BLACK_POOF, 0.4, 0, false, 1.5)
                    pickup.Price = PickupPrice.PRICE_FREE
                end
            end
        end
    end
end, 100)