local mod = FiendFolio

local batteryChances = {{BatterySubType.BATTERY_NORMAL, 30}, {BatterySubType.BATTERY_MICRO, 50}, {-1, 30}}

function mod:NonagonGeodeUseActive(item, rng, player, slot)
    if player:HasTrinket(mod.ITEM.ROCK.NONAGON_GEODE) then
        local mult = mod.GetGolemTrinketPower(player, mod.ITEM.ROCK.NONAGON_GEODE)
		local itemConfig = Isaac:GetItemConfig():GetCollectible(item)
        local charge = player:GetActiveMaxCharge(slot)
        local ignore

        if itemConfig.ChargeType > 0 then
            ignore = true
        else
            if (charge == 1 and player:HasCollectible(CollectibleType.COLLECTIBLE_9_VOLT)) or charge == 0 then
                ignore = true
            end
        end

        if not ignore then
            local chance = 15+10*mult
            if mod.HasTwoGeodes(player) then
                chance = chance*2
            end

            if rng:RandomInt(100) < chance then
                local tempTab = mod:makeCopiedTable(batteryChances)
                if not Isaac.GetPersistentGameData():Unlocked(Achievement.GOLDEN_BATTERIES) then
                    tempTab = {{BatterySubType.BATTERY_NORMAL, 40}, {BatterySubType.BATTERY_MICRO, 40}, {BatterySubType.BATTERY_MEGA, 10}, {-1, 25}}
                end
                local sub = mod:weightedRNG(tempTab, rng)
                local card
                if sub == -1 then
                    sub = mod.ITEM.CARD.STORAGE_BATTERY_0+rng:RandomInt(3)+1
                    card = true
                end

                local pos = Game():GetRoom():FindFreePickupSpawnPosition(player.Position, 0, true, false)
                if card then
                    Isaac.Spawn(5, 300, sub, pos, Vector.Zero, player)
                else
                    Isaac.Spawn(5, 90, sub, pos, Vector.Zero, player)
                end
                SFXManager():Play(SoundEffect.SOUND_BATTERYCHARGE, 0.4, 0, false, mod:RandomInt(120,140,rng)/100)
            end
        end
    end
end