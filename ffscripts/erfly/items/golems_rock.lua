local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, function(_, id, charge, firstTime, slot, vardata, player)
	if firstTime then
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, FiendFolio.GetNextMiningMachineTrinket(trinket, player), player.Position, Vector.FromAngle(math.random(30, 150)):Resized(5), player)
		--local sdata = mod:GetEntityData(Isaac.GetPlayer()).ffsavedata
		--if not sdata.playerSpawnedGolemRock then
		--	local trink = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, FiendFolio.GetNextMiningMachineTrinket(trinket, player), player.Position, Vector.FromAngle(math.random(30, 150)):Resized(5), player)
		--	sdata.playerSpawnedGolemRock = true
		--end
	end
end, mod.ITEM.COLLECTIBLE.GOLEMS_ROCK)

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, item, rng, player)
	local trinket = FiendFolio.GetMostRecentTrinket(player)
	if trinket ~= -1 then
		if player:TryRemoveTrinket(trinket) then
			FiendFolio.CrushRockTrinket(player, trinket, player)
			local trink = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, FiendFolio.GetNextMiningMachineTrinket(trinket, player), player.Position, Vector.FromAngle(math.random(30, 150)):Resized(5), player)
		end
	end

	local hasVirtues = player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES)
	if hasVirtues then
		player:AddWisp(FiendFolio.ITEM.COLLECTIBLE.GOLEMS_ROCK, player.Position) -- because its not recognizing that the wisp exists yet otherwise
		sfx:Play(SoundEffect.SOUND_CANDLE_LIGHT, 1, 0, false, 1)
		player:AddCacheFlags(CacheFlag.CACHE_ALL)
		player:EvaluateItems()
	end

	return true
end, mod.ITEM.COLLECTIBLE.GOLEMS_ROCK)

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, function(_, e)
	if e.Variant == FamiliarVariant.WISP and e.SubType == FiendFolio.ITEM.COLLECTIBLE.GOLEMS_ROCK then
		local player = e:ToFamiliar().Player
		if player then
			player:AddCacheFlags(CacheFlag.CACHE_ALL)
			player:EvaluateItems()
		end
	end
end, EntityType.ENTITY_FAMILIAR)

local golemsRockWispTearsToBePostFired = {}
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, familiar)
	if familiar.SubType == FiendFolio.ITEM.COLLECTIBLE.GOLEMS_ROCK then
		for _, t in pairs(golemsRockWispTearsToBePostFired) do
			local tear = t:ToTear()
			local randMult = math.random()
			if math.random(2) == 1 then
				tear.CollisionDamage = tear.CollisionDamage * (randMult + 1)
				tear.Scale = (tear.Scale + 0.1) * (randMult / 5 + 1)
			else
				tear.CollisionDamage = tear.CollisionDamage / (randMult + 1)
				tear.Scale = (tear.Scale + 0.1) / (randMult / 6 + 1)
			end
			tear:ResetSpriteScale()
		end

		golemsRockWispTearsToBePostFired = {}
	end
end, FamiliarVariant.WISP)

mod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, function(_, tear)
	if tear.SpawnerEntity and
	   tear.SpawnerEntity.Type == EntityType.ENTITY_FAMILIAR and
	   tear.SpawnerEntity.Variant == FamiliarVariant.WISP and
	   tear.SpawnerEntity.SubType == FiendFolio.ITEM.COLLECTIBLE.GOLEMS_ROCK
	then
		golemsRockWispTearsToBePostFired[tear.Index .. " " .. tear.InitSeed] = tear
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, tear)
	if golemsRockWispTearsToBePostFired[tear.Index .. " " .. tear.InitSeed] then
		golemsRockWispTearsToBePostFired[tear.Index .. " " .. tear.InitSeed] = nil
	end
end, EntityType.ENTITY_TEAR)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	golemsRockWispTearsToBePostFired = {}
end)