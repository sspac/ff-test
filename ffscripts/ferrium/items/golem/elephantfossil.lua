local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

function mod:elephantFossilHurt(player, damage, flag, source)
    if not mod:isDamageSelfInflicted(flag, source) and player:HasTrinket(mod.ITEM.ROCK.ELEPHANT_FOSSIL) then
        local mult = math.ceil(mod.GetGolemTrinketPower(player, mod.ITEM.ROCK.ELEPHANT_FOSSIL))
        local d = mod:GetEntityData(player)
        local order = CustomHealthAPI.Library.GetHealthInOrder(player, false)
        local lastHeart
        for position,heartEntry in ipairs(order) do
            for heartType,typeEntry in pairs(heartEntry) do
                if heartType == "Other" and typeEntry.Key == "BONE_HEART" and typeEntry.HP > 0 then
                    lastHeart = heartEntry
                end
            end
        end
        if lastHeart then
            if not (lastHeart.Red and lastHeart.Red.HP > 0) and (not lastHeart.Other.ElephantFossilHit or lastHeart.Other.ElephantFossilHit < mult) then
                lastHeart.Other.ElephantFossilHit = (lastHeart.Other.ElephantFossilHit or 0)+1

                sfx:Play(SoundEffect.SOUND_BONE_BOUNCE, 1, 0, false, 1)
                player:UseActiveItem(CollectibleType.COLLECTIBLE_DULL_RAZOR, UseFlag.USE_NOANIM, -1)
                mod:StopFFPlayerSoundsIGuess(player)
                mod.scheduleForUpdate(function()
                    sfx:Stop(SoundEffect.SOUND_ISAAC_HURT_GRUNT)
                end, 0)
                return false
            end
        end
    end
end

function mod:ElephantFossilOnHeal(player, key)
	if game:GetFrameCount() <= 10 then return end
    if key == "RED_HEART" and player:HasTrinket(mod.ITEM.ROCK.ELEPHANT_FOSSIL) then
        local order = CustomHealthAPI.Library.GetHealthInOrder(player, false)
        for position,heartEntry in ipairs(order) do
            for heartType,typeEntry in pairs(heartEntry) do
                if heartType == "Other" and typeEntry.Key == "BONE_HEART" and typeEntry.HP > 0 then
                    if heartEntry.Red and heartEntry.Red.HP > 0 and heartEntry.Other.ElephantFossilHit then
                        heartEntry.Other.ElephantFossilHit = 0
                    end
                end
            end
        end
    end
end
mod:AddTrinketCallback(CustomHealthAPI.Enums.Callbacks.POST_ADD_HEALTH, mod.ITEM.ROCK.ELEPHANT_FOSSIL, mod.ElephantFossilOnHeal)