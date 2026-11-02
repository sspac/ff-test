local mod = FiendFolio
local game = Game()
local nilvector = mod.nilvector

function mod:CoolSunglassesNewRoom()
    local room = game:GetRoom()
    local humbled = PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_HUMBLEING_BUNDLE)
    local coinsToStrew = 0
	local globalCount = PlayerManager.GetNumCollectibles(mod.ITEM.COLLECTIBLE.COOL_SUNGLASSES)
    if globalCount > 0 and not room:IsClear() then
        coinsToStrew = coinsToStrew + 1 + (2 * globalCount)
    end
    
	--Cool Sunglasses :)
	if coinsToStrew > 0 then
		local p1 = Isaac.GetPlayer(0)
		local coins = PickupCapCoinNum or p1:GetNumCoins()
		local coinSpawns
		--adding some no pickup cap compat
		if humbled then
			coinSpawns = math.min(coins, coinsToStrew * 2)
		else
			coinSpawns = math.min(coins, coinsToStrew)
		end
		if PickupCapCoinNum then
			PickupCapCoinNum = PickupCapCoinNum - coinSpawns
		else
			p1:AddCoins(-coinSpawns)
		end
		--Cheeky little method to basically turn 5 coins into 6
		--This is probably exploitable somehow but           screw it
		if humbled then
			coinSpawns = math.ceil(coinSpawns / 2)
		end

		for i = 1, coinSpawns do
			local subSpawn = 1
			if humbled then subSpawn = 4 end
			Isaac.Spawn(5, 20, subSpawn, room:FindFreePickupSpawnPosition(Isaac.GetRandomPosition(), 40, true), nilvector, nil)
		end
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.ITEM.COLLECTIBLE.COOL_SUNGLASSES, mod.CoolSunglassesNewRoom)

function mod:CoolSunglassesUpdate(player)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.COOL_SUNGLASSES) and game:GetFrameCount() % 4 == 0 then
		local data = mod:GetEntityData(player)

		local maxDistance = 120
		local nearestCoinDist = maxDistance

		local playerPos = player.Position
		local playerSize = player.Size

		for _, pickup in pairs(Isaac.FindInRadius(playerPos, maxDistance + playerSize, EntityPartition.PICKUP)) do
			if mod.IsCoinVariant(pickup.Variant) then
				local spr = pickup:GetSprite()
				if not spr:IsPlaying("Expire") and not spr:IsPlaying("Collect") then
					local dist = playerPos:Distance(pickup.Position) - playerSize - pickup.Size
					nearestCoinDist = math.min(nearestCoinDist, dist)
				end
			end
		end

		local maxSpeedBonus = 0.5
		local newSpeed = maxSpeedBonus * (1 - nearestCoinDist/maxDistance)

		if newSpeed ~= data.ffCoolSunglassesSpeed then
			data.ffCoolSunglassesSpeed = newSpeed
			player:AddCacheFlags(CacheFlag.CACHE_SPEED, true)
		end
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.COLLECTIBLE.COOL_SUNGLASSES, mod.CoolSunglassesUpdate)

function mod:CoolSunglassesCache(player)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.COOL_SUNGLASSES) then
		local data = mod:GetEntityData(player)
		player.MoveSpeed = player.MoveSpeed + (data.ffCoolSunglassesSpeed or 0)
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ITEM.COLLECTIBLE.COOL_SUNGLASSES, mod.CoolSunglassesCache, CacheFlag.CACHE_SPEED)