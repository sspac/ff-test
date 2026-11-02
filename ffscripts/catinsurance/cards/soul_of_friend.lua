local mod = FiendFolio

local Constants = {
	CLIP_SIZE = 6
}

local function filter(gunInfo)
	return not gunInfo.NoFriendSoul
end



-- Give a Soul of Friend gun to the given player
function mod:AddFriendSoulGun(player, gunType, ammoTable, ammoCount)
	gunType = _G.NextSoulFriendSub or gunType

	-- Give it to the Briend twin with the least amount of guns
	local playerData = mod:GetEntityData(player)

	if player:GetPlayerType() == mod.PLAYER.BRIEND then
		local twin = mod:GetBriendTwin(player)
		local twinData = mod:GetEntityData(twin)

		local myGuns = playerData.FriendSoulGuns
		local twinGuns = twinData.FriendSoulGuns

		if myGuns and (not twinGuns or #twinGuns < #myGuns) then
			player = twin
			playerData = twinData
		end
	end

	-- Create the gun
	local newGun = mod:SpawnFriendGun(player, gunType, nil, ammoTable)
	mod:FriendPlaySound(gunType, "Equip", 1)

	local gunData = mod:GetEntityData(newGun)
	gunData.IsFriendSoulGun = true
	gunData.GunLimitedAmmo = ammoCount
	newGun:Update()

	-- Add it to the tracker
	playerData.FriendSoulGuns = playerData.FriendSoulGuns or {}
	table.insert(playerData.FriendSoulGuns, EntityPtr(newGun))
	mod:EvaluateExtraChargeBar(player)
end



---@param player EntityPlayer
function mod:UseSoulOfFriend(_, player, flags)
	local randomGun = mod:GetRandomFriendGunSubtype(filter, player:GetCardRNG(mod.ITEM.CARD.SOUL_OF_FRIEND))
	local ammoCount = mod.FriendGunInfo[randomGun] and mod.FriendGunInfo[randomGun].MaxLimitedAmmo or mod.DefaultMaxLimitedAmmo

	-- Create the ammo table with only red hearts
	local ammoTable = {}

	for i = 1, Constants.CLIP_SIZE do
		table.insert(ammoTable, {HeartKey = "RED_HEART"})
	end

	mod:AddFriendSoulGun(player, randomGun, ammoTable, ammoCount)
	mod:trySayAnnouncerLine(mod.Sounds.VARuneSoulFriend, flags, 40)
end
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.UseSoulOfFriend, mod.ITEM.CARD.SOUL_OF_FRIEND)