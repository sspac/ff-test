local mod = FiendFolio

function mod:HellviteDeathCheck(npc, player)
    if player:HasTrinket(mod.ITEM.ROCK.HELLVITE) then
        local hasHellvite = 0
        for i=0,1 do
            if mod:GetRealTrinketId(player:GetTrinket(i)) == mod.ITEM.ROCK.HELLVITE then
                if mod:IsGoldTrinket(player:GetTrinket(i)) then
                    hasHellvite = hasHellvite+1
                end
                hasHellvite = hasHellvite+1
            end
        end

        if hasHellvite > 0 then
            hasHellvite = hasHellvite+mod.GetGolemBonusTrinketPower(player, mod.ITEM.ROCK.HELLVITE)
            mod:GetEntityData(player).ffsavedata.RunEffects.HellviteKills = (mod:GetEntityData(player).ffsavedata.RunEffects.HellviteKills or 0) + hasHellvite
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            player:EvaluateItems()
        end
    end
end

function mod:HellviteHurt(player, damage, flag, source)
    if not mod:isDamageSelfInflicted(flag, source) then
        local activate
        for i=0,1 do
            if mod:GetRealTrinketId(player:GetTrinket(i)) == mod.ITEM.ROCK.HELLVITE then
                player:TryRemoveTrinket(mod.ITEM.ROCK.HELLVITE)
                activate = true
            end
        end
        if activate then
            local poof = Isaac.Spawn(1000, EffectVariant.POOF01, 0, player.Position, Vector.Zero, player):ToEffect()
            poof.Color = Color(0.2, 0.2, 0.2, 1, 0, 0, 0)
            SFXManager():Play(SoundEffect.SOUND_DEATH_CARD, 1, 0, false, 0.8)
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            player:EvaluateItems()
        end
    end
end