local mod = FiendFolio
local heartacheRecursion

mod:AddTrinketCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.ITEM.TRINKET.HEARTACHE, function(_, entity, amount, flags, source, cooldown)
	local player = entity:ToPlayer()
	if player:GetTrinketMultiplier(mod.ITEM.TRINKET.HEARTACHE) > 0 and not heartacheRecursion and flags & DamageFlag.DAMAGE_FAKE == 0 then
		heartacheRecursion = true

		local brokens = player:GetTrinketMultiplier(mod.ITEM.TRINKET.HEARTACHE)
		local playerType = player:GetPlayerType()

		if playerType == PlayerType.PLAYER_THELOST or playerType == PlayerType.PLAYER_THELOST_B then brokens = brokens * 3 end

		player:AddBrokenHearts(brokens)

		newFlags = DamageFlag.DAMAGE_FAKE
		if player:GetBrokenHearts() >= 12 then
			newFlags = 0
		end

		heartacheRecursion = false
		return {Damage = 1, DamageFlags = newFlags}
	end
end, 1)