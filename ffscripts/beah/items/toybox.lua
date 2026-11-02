local mod = FiendFolio
local sfx = SFXManager()
local game = Game()

local function UseItem(_, _, _, player, flags)
    if flags & UseFlag.USE_CARBATTERY ~= 0 then
        return
    end

    sfx:Play(SoundEffect.SOUND_CHOIR_UNLOCK, 1, 0)
    local tempEffects = player:GetEffects()
    tempEffects:AddCollectibleEffect(mod.ITEM.COLLECTIBLE.TOYBOX, true, 3)
    return { Remove = true}
end

local function toyboxTick(_, player)
    if not player:IsExtraAnimationFinished() then
        return
    end
    local tempEffects = player:GetEffects()
    local p_data = mod:GetEntityData(player).ffsavedata.RunEffects
    local stacks = tempEffects:GetCollectibleEffect(mod.ITEM.COLLECTIBLE.TOYBOX) 

    if stacks ~= nil and stacks.Count > 0
    and (p_data.toyboxTrinket == nil) then
        local ptype = player:GetPlayerType()
        local isGolem = ptype == FiendFolio.PLAYER.GOLEM or ptype == FiendFolio.PLAYER.BOLEM
        local trinket
        if isGolem then
            trinket = mod.GetGolemTrinket()
        else
            trinket = game:GetItemPool():GetTrinket()
        end
        p_data.toyboxTrinket = trinket
        player:AnimateTrinket(trinket, "UseItem")
        tempEffects:RemoveCollectibleEffect(mod.ITEM.COLLECTIBLE.TOYBOX)
        
        sfx:Play(SoundEffect.SOUND_SHELLGAME, 1, 0)
        game:GetHUD():ShowItemText(player, Isaac.GetItemConfig():GetTrinket(trinket))

        if player:HasTrinket(mod.ITEM.ROCK.ELECTRUM) then
            local hf = function(enemy, p, m, r)
				mod:GetEntityData(enemy).electrumDeath = function()
                    if r:RandomInt(3) == 0 then
                        local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, trinket, enemy.Position, Vector.Zero, player)
                    end
				end
			end
            local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.ELECTRUM)
			mod:alternateElectrumShock(player, player:GetTrinketRNG(mod.ITEM.ROCK.ELECTRUM), player.Damage*mult+10, player.Position, 1, nil, hf)
        end
    end
    if p_data.toyboxTrinket ~= nil then
        player:AddSmeltedTrinket(p_data.toyboxTrinket)
        p_data.toyboxTrinket = nil
    end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, UseItem, mod.ITEM.COLLECTIBLE.TOYBOX)
mod:AddPlayerTempEffectCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, Isaac.GetItemConfig():GetCollectible(mod.ITEM.COLLECTIBLE.TOYBOX), toyboxTick)
