local mod = FiendFolio

local function CheckFulguriteProc(player)
    if player:HasCollectible(CollectibleType.COLLECTIBLE_JACOBS_LADDER) then
        return false
    end
    local mult = mod.GetGolemTrinketPower(player, mod.ITEM.ROCK.FULGURITE)
	local rng = player:GetTrinketRNG(mod.ITEM.ROCK.FULGURITE)
    local chance = 20*mult+mod.XalumLuckBonus(player.Luck, 25, 0.3)*100
    if rng:RandomInt(100) < chance then
        return true
    end
end

function mod:fulguriteTearHitParams(player, tearparams, weapontype, damagescale, teardisplacement, source)
	if player:HasTrinket(mod.ITEM.ROCK.FULGURITE) then
		if CheckFulguriteProc(player) then
			tearparams.TearFlags = tearparams.TearFlags | TearFlags.TEAR_JACOBS
			tearparams.TearColor = Color(0.74, 0.5, 0.3, 1, 0.2, 0.1, 0)
		end
	end
end
mod:AddTrinketCallback(ModCallbacks.MC_EVALUATE_TEAR_HIT_PARAMS, mod.ITEM.ROCK.FULGURITE, mod.fulguriteTearHitParams)

function mod:FulguriteOnGrind(player, trinket)
    if mod:GetRealTrinketId(trinket) == mod.ITEM.ROCK.FULGURITE then
        local sound
        for i=0,2 do
            local active = player:GetActiveItem()
            if active > 0 then
                local config = Isaac.GetItemConfig():GetCollectible(active)
                local charge = player:GetActiveMaxCharge(i)
                if config.ChargeType ~= 2 then
                    player:AddActiveCharge(charge*2, i, true, true, false)
                end
            end
        end
    end
end