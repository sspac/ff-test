local mod = FiendFolio
local game = Game()

mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, function(_, player, trinketType, firstTime)
    if player:HasTrinket(FiendFolio.ITEM.ROCK.THE_STRONGEST_GEODE) then
        local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.THE_STRONGEST_GEODE)

        for i = 1, 0, -1 do
            local trink = player:GetTrinket(i)
            if FiendFolio.IsRockTrinket(trink) and trink ~= FiendFolio.ITEM.ROCK.THE_STRONGEST_GEODE and FiendFolio.GetRockRarity(trink) > 0 then
                local heartSub = HeartSubType.HEART_HALF_SOUL
                if mod.HasTwoGeodes(player) then
                    heartSub = HeartSubType.HEART_SOUL
                end

                if not Isaac.GetPersistentGameData():Unlocked(Achievement.EVERYTHING_IS_TERRIBLE) then
                    heartSub = HeartSubType.HEART_SOUL
                end

                Isaac.Spawn(5, 10, heartSub, player.Position, RandomVector() * 3, nil)

                local newTrinket = mod.GetGolemTrinket({0}, nil, true)
                FiendFolio.BreakRockTrinket(player, trink)
                Isaac.Spawn(5, 350, newTrinket, player.Position, RandomVector() * 3, nil)
                FiendFolio.TryRemoveGolemTrinketFromPool(newTrinket)
            end
        end
    end
end)

