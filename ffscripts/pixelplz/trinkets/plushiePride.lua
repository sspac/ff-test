local mod = FiendFolio



function mod:PlushiePrideDischargeItem(id, removed, player, slot)
	local multi = player:GetTrinketMultiplier(mod.ITEM.TRINKET.PLUSHIE_PRIDE)

	-- Get the duration based on the max charges
	local config = Isaac.GetItemConfig():GetCollectible(id)
	local chargeBonus = 1

	if  config.ChargeType == ItemConfig.CHARGE_NORMAL
	or (config.ChargeType == ItemConfig.CHARGE_SPECIAL and config.MaxCharges <= 12) then
		chargeBonus = config.MaxCharges

		-- Spawn one for one-time use actives, just for fun
		if removed then
			chargeBonus = math.max(chargeBonus, 1)
		end
	end

	-- Add the collectible effects
	local cooldown = (multi * chargeBonus + 1) * 5
	player:AddCollectibleEffect(CollectibleType.COLLECTIBLE_ANARCHIST_COOKBOOK, false, cooldown, true)
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_DISCHARGE_ACTIVE_ITEM, mod.ITEM.TRINKET.PLUSHIE_PRIDE, mod.PlushiePrideDischargeItem)