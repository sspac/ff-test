local mod = FiendFolio
local game = Game()

-- hi sunil i completely recoded this from scratch
-- there were lots of issues with XL floors, forget me now, crown trinkets, etc.
-- hope you dont mind! -cat

local DEFAULT_DATA_RUN = {
	UnenteredRooms = 0,
}

local DEFAULT_DATA_PLAYER = {
	DamageBonus = 0
}

function mod:GetShootingStarData(player)
	local save
	if player then
		local data = mod:GetEntityData(player)
		save = mod.getFieldInit(data.ffsavedata, "ShootingStar", DEFAULT_DATA_PLAYER)
	else
		save = mod.getFieldInit(mod.savedata, "run", "ShootingStar", DEFAULT_DATA_RUN)
	end
	return save
end

function mod:CountTreasureRooms()
	local level = game:GetLevel()
	local rooms = level:GetRooms()
	local count = 0
	for i = 0, rooms.Size-1 do
		local room = rooms:Get(i)
		if room.Data and room.Data.Type == RoomType.ROOM_TREASURE then
			count = count + 1
		end
	end

	return count
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	local save = mod:GetShootingStarData()
	local room = game:GetRoom()
	if room:GetType() == RoomType.ROOM_TREASURE and room:IsFirstVisit() then
		save.UnenteredRooms = math.max(save.UnenteredRooms - 1, 0)
	end
end)

function mod:ShootingStarBonus(player, fromPlayerUpdate, postLevelInitFinished)
	local runData = mod:GetShootingStarData()

	-- Only run on new level (not save and continue)
	if postLevelInitFinished then
		local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.SHOOTING_STAR)
		if mult > 0 and runData.UnenteredRooms > 0 then
			-- Calculate damage bonus
			local playerData = mod:GetShootingStarData(player)
			local damageBonus = runData.UnenteredRooms * mult
			playerData.DamageBonus = playerData.DamageBonus + damageBonus
			player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
		end
	end
end
-- This runs BEFORE MC_POST_NEW_LEVEL
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_NEW_LEVEL, mod.ShootingStarBonus)

function mod:ShootingStarReset()
	local runData = mod:GetShootingStarData()

	-- Reset the shooting star tracking for the new floor !!!
	local treasureCount = mod:CountTreasureRooms()
	runData.UnenteredRooms = treasureCount
end
-- Do this on late, just in case another mod uses this callback to do crazy shenanigans that add more treasure rooms
mod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_LEVEL, CallbackPriority.LATE+1, mod.ShootingStarReset)