local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, ID, rng, player, useflags, activeslot)
    if useflags == useflags | UseFlag.USE_CARBATTERY then
        return {Discharge = false, Remove = false, ShowAnim = false}
    else
        local d = mod:GetEntityData(player)
        if d.holdingFFItem then
            d.holdingFFItem = nil
            d.holdingFFItemSlot = nil
            player:AnimateCollectible(ID, "HideItem", "PlayerPickup")
        else
            d.holdingFFItem = ID
            d.holdingFFItemSlot = activeslot
            player:AnimateCollectible(ID, "LiftItem", "PlayerPickup")
        end
        return {Discharge = false, Remove = false, ShowAnim = false}
    end
end, FiendFolio.ITEM.COLLECTIBLE.GREEN_CANDLE)

function mod:useHeldGreenCandle(player, d, aim)
    if aim:Length() > 0.5 then
        local greenFire = Isaac.Spawn(1000, 52, 0, player.Position, aim:Resized(10), player):ToEffect()
        greenFire.Color = Color(1,1,1,1,-0.5,0.3,-0.4)
        greenFire:Update()
        greenFire.CollisionDamage = 5
        greenFire.Timeout = 50
        mod:GetEntityData(greenFire).stinkyGreenCandle = true
        greenFire:Update()
        sfx:Play(SoundEffect.SOUND_CANDLE_LIGHT, 1, 0, false, 1)
        sfx:Play(mod.Sounds.SizzleExtinguish, 0.5, 0, false, 0.8 + math.random(20)/10)
        if d.holdingFFItemSlot and d.holdingFFItemSlot >= 0 then
            player:DischargeActiveItem(d.holdingFFItemSlot)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, fire)
	local data = mod:GetEntityData(fire)
    if fire:GetSprite():IsPlaying("Idle") then
        if data.stinkyGreenCandle then
            if fire.Scale <= 0.75 then
                local cloud = Isaac.Spawn(1000, 141, 0, fire.Position, Vector.Zero, player):ToEffect()
                cloud.Timeout = 80
                cloud:Update()
                fire:Kill()
            end
            local player = fire.SpawnerEntity
            if player then
                if fire.FrameCount % 10 == 1 then
                    local cloud = Isaac.Spawn(1000, 141, 0, fire.Position, Vector.Zero, player):ToEffect()
                    cloud.Timeout = 80
                    cloud:Update()
                end
            else
                fire:Kill()
            end
        end
    end
end, EffectVariant.RED_CANDLE_FLAME)