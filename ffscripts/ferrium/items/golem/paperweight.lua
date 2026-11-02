local mod = FiendFolio
local sfx = SFXManager()

local validChests = {
    [PickupVariant.PICKUP_BOMBCHEST] = true,
    [PickupVariant.PICKUP_SPIKEDCHEST] = true,
    [PickupVariant.PICKUP_ETERNALCHEST] = true,
    [PickupVariant.PICKUP_MIMICCHEST] = true,
    [PickupVariant.PICKUP_MEGACHEST] = true,
    [PickupVariant.PICKUP_LOCKEDCHEST] = true,
}

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, collider, low)
    local player
    if collider and collider:ToPlayer() then
        player = collider:ToPlayer()
    end
    if player and validChests[pickup.Variant] == true and player:HasTrinket(mod.ITEM.ROCK.PAPERWEIGHT) then
        local sprite = pickup:GetSprite()
        local mult = mod.GetGolemTrinketPower(player, mod.ITEM.ROCK.PAPERWEIGHT)
        local rng = player:GetTrinketRNG(mod.ITEM.ROCK.PAPERWEIGHT)
        if pickup.Variant == PickupVariant.PICKUP_MEGACHEST then
            local crack
            local open
            local d2 = mod:GetEntityData(pickup)
            if not d2.paperweightTimer or d2.paperweightTimer < 1 then
                if (sprite:GetAnimation() == "Idle" or sprite:IsFinished("UseKey") or sprite:IsFinished("UseGoldenKey") or sprite:IsFinished("UseCoin")) then
                    if pickup.SubType > 0 then
                        crack = true
                        d2.paperweightTimer = 7
                        if not d2.originalSubType then
                            d2.originalSubType = pickup.SubType
                        end
                        pickup.SubType = pickup.SubType-1
                        player.Velocity = (player.Position-pickup.Position):Resized(3)
                    else
                        pickup.SubType = d2.originalSubType or 3
                        crack = true
                        pickup:TryOpenChest(player)
                    end
                end
            else
                d2.paperweightTimer = d2.paperweightTimer-1
            end
            if crack then
                sfx:Play(SoundEffect.SOUND_POT_BREAK, 1, 0, false, 1)

                for i=1,3 do
                    local spd = mod:getRoll(5,12,rng)/6
                    local vel = Vector(0,spd):Rotated(rng:RandomInt(360))
                    local dust = Isaac.Spawn(1000, EffectVariant.DUST_CLOUD, 0, pickup.Position, vel, player):ToEffect()
                    local de_dust = mod:GetEntityData(dust)
                    dust.Color = Color(1, 1, 1, 0.3, 0, 0, 0)
                    dust.SpriteScale = Vector(0.2, 0.2)
                    dust:SetTimeout(mod:getRoll(30,60,rng))
                    de_dust.cosmeticDust = {vel = vel, scale = mod:getRoll(20,80,rng)/100, slowdown = 0.98}
                    dust:Update()
                end

                local d = mod:GetEntityData(player).ffsavedata.RunEffects
                if not d.paperweightCount then
                    d.paperweightCount = 0
                end
                d.paperweightCount = d.paperweightCount+1
                local chance = rng:RandomInt(100)
                if mult < 2 and d.paperweightCount > 5*mult and chance < 10*(2-mult) then
                    local trueMult = player:GetTrinketMultiplier(mod.ITEM.ROCK.PAPERWEIGHT)
                    for i=1,trueMult do
                        player:TryRemoveTrinket(mod.ITEM.ROCK.PAPERWEIGHT)
                    end

                    sfx:Play(SoundEffect.SOUND_MIRROR_BREAK, 0.55, 0, false, 2.6)
                    player:AnimateSad()
                    d.paperweightCount = 0
                    local trinket = Isaac.Spawn(5, 350, mod.ITEM.ROCK.POCKET_SAND, player.Position, Vector(0,3):Rotated(rng:RandomInt(360)), player)
                end
            end
            Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_PICKUP_COLLISION, pickup.Variant, pickup, collider, low)
            return false
        elseif (sprite:GetAnimation() == "Idle" or sprite:IsFinished("Close")) then
            pickup:TryOpenChest(player)

            sfx:Play(SoundEffect.SOUND_POT_BREAK, 1, 0, false, 1)
            pickup.Velocity = (pickup.Position-player.Position):Resized(6)

            for i=1,3 do
                local spd = mod:getRoll(5,12,rng)/6
                local vel = Vector(0,spd):Rotated(rng:RandomInt(360))
                local dust = Isaac.Spawn(1000, EffectVariant.DUST_CLOUD, 0, pickup.Position, vel, player):ToEffect()
                local de_dust = mod:GetEntityData(dust)
                dust.Color = Color(1, 1, 1, 0.3, 0, 0, 0)
                dust.SpriteScale = Vector(0.2, 0.2)
                dust:SetTimeout(mod:getRoll(30,60,rng))
                de_dust.cosmeticDust = {vel = vel, scale = mod:getRoll(20,80,rng)/100, slowdown = 0.98}
                dust:Update()
            end

            local d = mod:GetEntityData(player).ffsavedata.RunEffects
            if not d.paperweightCount then
                d.paperweightCount = 0
            end
            d.paperweightCount = d.paperweightCount+1
            local chance = rng:RandomInt(100)
            if mult < 2 and d.paperweightCount > 5*mult and chance < 10*(2-mult) then
                local trueMult = player:GetTrinketMultiplier(mod.ITEM.ROCK.PAPERWEIGHT)
                for i=1,trueMult do
                    player:TryRemoveTrinket(mod.ITEM.ROCK.PAPERWEIGHT)
                end

                sfx:Play(SoundEffect.SOUND_MIRROR_BREAK, 0.55, 0, false, 2.6)
                player:AnimateSad()
                d.paperweightCount = 0
                local trinket = Isaac.Spawn(5, 350, mod.ITEM.ROCK.POCKET_SAND, player.Position, Vector(0,3):Rotated(rng:RandomInt(360)), player)
            end
        end
    end
end)