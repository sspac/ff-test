local mod = FiendFolio
local sfx = SFXManager()

local function onCacheEval(_, player)
    if player.MoveSpeed < 1.6 then
        return
    end
    for i = 0, 1, 1 do
        if mod:GetRealTrinketId(player:GetTrinket(i)) == mod.ITEM.ROCK.ANCIENT_EFFIGY then
            local s = nil
            if i == 1 then
                s = player:GetTrinket(0)
                player:TryRemoveTrinket(s)
            end

            player:AnimateTrinket(mod.ITEM.ROCK.ANCIENT_EFFIGY)
            player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, false, false, true, false)
            sfx:Play(SoundEffect.SOUND_1UP)

            if s then
                player:AddTrinket(s)
            end
        end
    end
end
mod:AddPriorityTrinketCallback(ModCallbacks.MC_EVALUATE_CACHE, 999999, mod.ITEM.ROCK.ANCIENT_EFFIGY, onCacheEval, CacheFlag.CACHE_SPEED)