local mod = FiendFolio
local sfx = SFXManager()

mod:AddPriorityCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, CallbackPriority.LATE, function(_, pickup, collider, low)
    if pickup:IsShopItem() and collider:ToPlayer() and collider:ToPlayer():HasTrinket(mod.ITEM.ROCK.PIG_IRON) and collider:ToPlayer():GetNumCoins() >= pickup.Price then
        local player = collider:ToPlayer()
        local rng = player:GetTrinketRNG(mod.ITEM.ROCK.PIG_IRON)
        local mult = mod.GetGolemTrinketPower(player, mod.ITEM.ROCK.PIG_IRON)
        local earlyPrice = pickup.Price
        --lazy solution hope it works
        mod.scheduleForUpdate(function()
            if pickup:GetSprite():GetAnimation() == nil or not pickup:Exists() or pickup.Variant == 100 then
                sfx:Play(SoundEffect.SOUND_CASH_REGISTER, 1, 0, false, 1)
                local percent = math.min(75, 25*mult)/100
                local refund = math.ceil(percent*earlyPrice)
                player:AddCoins(refund)
                for i=1,4 do
                    Isaac.Spawn(1000, 98, 0, pickup.Position, RandomVector()*mod:getRoll(2, 6, rng), player)
                end
            end
        end, 1)
    end
end)