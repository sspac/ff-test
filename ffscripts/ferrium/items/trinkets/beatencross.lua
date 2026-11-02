local mod = FiendFolio

local bal = {
    HeartCap = 3,
}

function mod:BeatenCrossHealthDamaged(player, flags, redKey, redHP, otherKey, otherHP, amount)
	if amount > 0 and player:HasTrinket(mod.ITEM.TRINKET.BEATEN_CROSS) and not player:HasCollectible(CollectibleType.COLLECTIBLE_WAFER) then
		local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.BEATEN_CROSS)
        local order = CustomHealthAPI.Library.GetHealthInOrder(player, false)
        local goodIndexes = 0
        local checked = -1
        for position,heartEntry in ipairs(order) do
            for heartType,typeEntry in pairs(heartEntry) do
                if type(typeEntry) == "table" and typeEntry.HP and typeEntry.HP > 0 and checked ~= position then
                    checked = position
                    goodIndexes = goodIndexes+1
                end
            end
        end
        if goodIndexes <= bal.HeartCap*mult then
    		return 1
        end
	end
end
mod:AddTrinketCallback(CustomHealthAPI.Enums.Callbacks.PRE_HEALTH_DAMAGED, mod.ITEM.TRINKET.BEATEN_CROSS, mod.BeatenCrossHealthDamaged)