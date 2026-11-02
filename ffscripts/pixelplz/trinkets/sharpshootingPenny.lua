local mod = FiendFolio

local Settings = {
	ClipSize = 6,
	BaseChance = 10,
	ChanceBonus = 10, -- Based on coin value
}

local function filter(gunInfo)
    return not gunInfo.NoFriendSoul
end



function mod:PennyPickupSharpshooting(pickup, player, value)
	if player:HasTrinket(mod.ITEM.TRINKET.SHARPSHOOTING_PENNY) then
		local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.SHARPSHOOTING_PENNY)
		local chance = Settings.BaseChance + (Settings.ChanceBonus * value)

		if mod:Random(nil, nil, rng) <= chance / 100 then
			local randomGun = mod:GetRandomFriendGunSubtype(filter, rng)

			-- Get the ammo count
			local friendSoulAmmo = mod.FriendGunInfo[randomGun] and mod.FriendGunInfo[randomGun].MaxLimitedAmmo or mod.DefaultMaxLimitedAmmo
			local gunTypeMulti = (friendSoulAmmo / mod.DefaultMaxLimitedAmmo) * Settings.ClipSize
			local trinketMulti = player:GetTrinketMultiplier(mod.ITEM.TRINKET.SHARPSHOOTING_PENNY)
			local ammoCount = math.ceil(gunTypeMulti) * trinketMulti

			-- Create the ammo table with only red hearts
			local ammoTable = {}

			for i = 1, Settings.ClipSize do
				table.insert(ammoTable, { HeartKey = "RED_HEART" })
			end

			mod:AddFriendSoulGun(player, randomGun, ammoTable, ammoCount)
		end
	end
end