local mod = FiendFolio
local sfx = SFXManager()

--[[FiendFolio.AddItemPickupCallback(function(player)
    mod:CheckAgainstCurrentGun(player, CollectibleType.COLLECTIBLE_9_VOLT)
end, nil, CollectibleType.COLLECTIBLE_9_VOLT)]]

mod:AddCallback("POST_GUN_FIRE_TEAR", function(_, gun, player, tear)
    if player:HasCollectible(CollectibleType.COLLECTIBLE_9_VOLT) then
        local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_9_VOLT)
        if rng:RandomInt(100) < 20 then
            local td = mod:GetEntityData(tear)
            td.nineVoltBullet = player
        end
    end
end)

function mod:NineVoltBulletDeath(ent, sourceEntity, sourceData, spawner, spawnerData)
    if sourceData.nineVoltBullet or (spawner and spawnerData.nineVoltBullet) then
        local player
        if sourceData.nineVoltBullet then
            player = sourceData.nineVoltBullet
        elseif spawner and spawnerData.nineVoltBullet then
            player = spawnerData.nineVoltBullet
        end
        if player:Exists() then
            mod.scheduleForUpdate(function()
                if ent and ent:Exists() and ent:IsEnemy() and ent:IsDead() then
                    local done
                    for i=0,2 do
                        local active = player:GetActiveItem(i)
                        if active == mod.ITEM.COLLECTIBLE.HOT_SHOT then
                            local charge = player:GetActiveCharge(i)+player:GetBatteryCharge(i)
                            local max = mod.FriendBalancing.ActiveCharge*2
                            done = true
                            player:SetActiveCharge(math.min(max, math.ceil(charge+15)), i)
                        end
                    end
                    if done then
                        sfx:Play(SoundEffect.SOUND_BEEP, 0.6, 0, false, 1)
                    end
                end
            end, 2)
        end
    end
end