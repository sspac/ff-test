local mod = FiendFolio
local sfx = SFXManager()

--[[mod:AddPriorityCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, CallbackPriority.EARLY, function()
    if player:HasTrinket(mod.ITEM.TRINKET.INK_POT) then
        local d = mod:GetEntityData(player)
        d.InkPotHeartCount = CustomHealthAPI.Helper.GetBasegameBlackHeartsNum(player)
    end
end)]]

function mod:InkPotUpdate(player)
    if player:HasTrinket(mod.ITEM.TRINKET.INK_POT) then
        local d = mod:GetEntityData(player)
        d.InkPotHeartCount = CustomHealthAPI.Helper.GetBasegameBlackHeartsNum(player)
    end
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.TRINKET.INK_POT, mod.InkPotUpdate)

function mod:InkPotConvertSoul(player)
    if player:HasTrinket(mod.ITEM.TRINKET.INK_POT) then
        local d = mod:GetEntityData(player)
        if d.InkPotHeartCount and CustomHealthAPI.Helper.GetBasegameBlackHeartsNum(player) > d.InkPotHeartCount then
            local order = CustomHealthAPI.Library.GetHealthInOrder(player, false)
            local count = player:GetTrinketMultiplier(mod.ITEM.TRINKET.INK_POT)*2
            local convert = 0
            for i=1,#order do
                local heartEntry = order[i]
                for heartType,typeEntry in pairs(heartEntry) do
                    if convert < count and heartType == "Other" and typeEntry.Key == "SOUL_HEART" and typeEntry.HP > 0 then
                        convert = convert+1
                        typeEntry.Key = "BLACK_HEART"
                    end
                end
            end
            if convert > 0 then
                local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.INK_POT)
                sfx:Play(SoundEffect.SOUND_BLACK_POOF, 0.6, 0, false, 1.3)
                local poof = Isaac.Spawn(1000, EffectVariant.POOF02, 1, player.Position, Vector.Zero, player):ToEffect()
                poof.SpriteScale = Vector(0.6, 0.6)
                poof.Color = Color(0.2, 0.2, 0.2, 0.6, 0, 0, 0, 1, 1, 1, 1)
                poof:Update()
                local splat = Isaac.Spawn(1000, EffectVariant.BLOOD_SPLAT, 0, player.Position, Vector.Zero, player):ToEffect()
                splat.Color = mod.ColorDankBlackReal
                splat.SpriteScale = Vector(2, 2)

                for i=1,3 do
                    local vel = Vector(mod:RandomInt(10,40,rng)/10, 0):Rotated(rng:RandomInt(360))
                    local drop = Isaac.Spawn(1000, EffectVariant.WATER_SPLASH, 1, player.Position, vel, player):ToEffect()
                    drop.FallingSpeed = -mod:RandomInt(60,120,rng)/10
                    drop.m_Height = -5
                    drop.Color = Color(0.05, 0.05, 0.05, 1)
                    drop.SpriteScale = Vector(1.1, 1.1)
                end
            end
        end
        d.InkPotHeartCount = CustomHealthAPI.Helper.GetBasegameBlackHeartsNum(player)
    end
end
mod:AddTrinketCallback(CustomHealthAPI.Enums.Callbacks.POST_ADD_HEALTH, mod.ITEM.TRINKET.INK_POT, mod.InkPotConvertSoul)