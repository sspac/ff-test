local mod = FiendFolio
local game = Game()

mod.statItemWhitelist = {
	[PickupVariant.PICKUP_COLLECTIBLE] = {
		[CollectibleType.COLLECTIBLE_BLOOD_CLOT] = true,
		[CollectibleType.COLLECTIBLE_CONSOLATION_PRIZE] = true,
		[mod.ITEM.COLLECTIBLE.LEVEL_2_BREAKFAST] = true,
	},
	[PickupVariant.PICKUP_TRINKET] = {

	},
}

local rerollFlags = {
	CacheFlag.CACHE_DAMAGE,
	CacheFlag.CACHE_FIREDELAY,
	CacheFlag.CACHE_SHOTSPEED,
	CacheFlag.CACHE_RANGE,
	CacheFlag.CACHE_SPEED,
	CacheFlag.CACHE_LUCK,
}

function mod:rollOffensiveItems(p)
    local isNoOffense = Isaac.GetChallenge() == mod.challenges.noOffense
	if isNoOffense then
		local config
		local var = p.Variant
		if var == PickupVariant.PICKUP_COLLECTIBLE then
			config = Isaac.GetItemConfig():GetCollectible(p.SubType)
		elseif var == PickupVariant.PICKUP_TRINKET then
			config = Isaac.GetItemConfig():GetTrinket(p.SubType)
		end
		local flags = config.CacheFlags
		local shouldRoll
		--Stat item (quickest check)
		if mod.statItemWhitelist[var][p.SubType] then
			shouldRoll = true
		end
		--Offensive item
		if (not shouldRoll) and isNoOffense and config.Tags == config.Tags | 1 << 20 then
			shouldRoll = true
		end
		--Stat item (proper check)
		if (not shouldRoll) then
			for i = 1, #rerollFlags do
				if flags == flags | rerollFlags[i] then
					shouldRoll = true
					break
				end
			end
		end
		if shouldRoll then
			--print(config.Name)
			p:Morph(5,var,0, true, false, false)
		end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.rollOffensiveItems, PickupVariant.PICKUP_COLLECTIBLE)
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.rollOffensiveItems, PickupVariant.PICKUP_TRINKET)