local mod = FiendFolio

local Settings = {
	PickupDelay = 40,
	TrinketReplaceChance = 25,
	VirtuesBaseChance = 10,
	VirtuesExtraChance = 5, -- Based on coin value
}



-- Check if the given trinket ID belongs to a penny trinket
local function isPennyTrinket(id)
	local config = Isaac.GetItemConfig():GetTrinket(id)

	if config then
		local name = string.lower(config.Name)
		return string.find(name, "penny")
	end
	return false
end

-- Add a trinket to Penny Album's tracker
local function addPennyTrinket(player, id, isBlasphemous)
	local tracker = isBlasphemous and "PENNY_ALBUM_BLASPHEMOUS" or "PENNY_ALBUM"
	player:AddInnateTrinket(id, 1, tracker)
	mod:TriggerBlasphemousDamageCache(player)

	-- Add extra copies with Car Battery
	if player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
		player:AddInnateTrinket(id, 1, "PENNY_ALBUM_CAR_BATTERY")
	end
end



-- Handle picking up penny trinkets
function mod:PennyAlbumTrinketCollision(pickup, collider, bool)
	local player = collider:ToPlayer()

	if player and player:HasCollectible(mod.ITEM.COLLECTIBLE.PENNY_ALBUM) and isPennyTrinket(pickup.SubType) then
		mod:GetEntityData(pickup).IsPennyAlbumTrinketBlashpemeous = mod:IsPickupTrinketBlasphemous(pickup)
		pickup.Variant = mod.PICKUP.VARIANT.PENNY_ALBUM_TRINKET
		pickup:ForceCollide(player, bool)
		return true
	end
end
mod:AddPriorityCollectibleCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, math.huge, mod.ITEM.COLLECTIBLE.PENNY_ALBUM, mod.PennyAlbumTrinketCollision, PickupVariant.PICKUP_TRINKET)

-- Let CHAPI do the heavy lifting for pickup handling
CustomHealthAPI.Library.RegisterPickupEntity(mod.PICKUP.VARIANT.PENNY_ALBUM_TRINKET, -1, {
	DropSound = SoundEffect.SOUND_SCAMPER,
	CollectSound = SoundEffect.SOUND_SHELLGAME,

	OnCollect = function(player, pickup)
		local isBlasphemous = mod:GetEntityData(pickup).IsPennyAlbumTrinketBlashpemeous
		addPennyTrinket(player, pickup.SubType, isBlasphemous)
	end,
})

-- Make the pickup not exist outside of collision callbacks
function mod:PennyAlbumTrinketUpdate(pickup)
	pickup.Variant = PickupVariant.PICKUP_TRINKET

	-- Make the trinket Blasphemous again
	local data = mod:GetEntityData(pickup)

	if data.IsPennyAlbumTrinketBlashpemeous then
		mod:MakePickupTrinketBlasphemous(pickup)
		data.IsPennyAlbumTrinketBlashpemeous = nil
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_UPDATE, mod.PennyAlbumTrinketUpdate, mod.PICKUP.VARIANT.PENNY_ALBUM_TRINKET)



-- Automatically store held penny trinkets when picking up the item
function mod:PennyAlbumAddItem(itemID, charge, firstTime, itemSlot, varData, player)
	for trinketSlot = 0, 1 do
		local trinketID = player:GetTrinket(trinketSlot)

		if isPennyTrinket(trinketID) then
			local isBlasphemous = mod:IsPlayerTrinketBlasphemous(player, trinketSlot)
			addPennyTrinket(player, trinketID, isBlasphemous)
			player:TryRemoveTrinket(trinketID)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.PennyAlbumAddItem, mod.ITEM.COLLECTIBLE.PENNY_ALBUM)

-- Store penny trinkets that aren't picked up normally
function mod:PennyAlbumAddTrinket(player, id, firstTime)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.PENNY_ALBUM) and isPennyTrinket(id) then
		local isBlasphemous = mod:PlayerHasBlasphemousTrinket(player, true, id) ~= nil
		addPennyTrinket(player, id, isBlasphemous)
		return false
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_PRE_ADD_TRINKET, mod.ITEM.COLLECTIBLE.PENNY_ALBUM, mod.PennyAlbumAddTrinket)



-- Blasphemous damage ups
-- Would be better if the trinket tracer was updated to account for innate trinkets but ehhh
function mod:PennyAlbumDamageCache(player, cacheFlag)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.PENNY_ALBUM) then
		local pennies = player:GetInnateTrinketGroup("PENNY_ALBUM_BLASPHEMOUS")
		local storedPennies = 0

		for pennyID, amount in pairs(pennies) do
			storedPennies = storedPennies + amount
		end
		player.Damage = player.Damage + storedPennies
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ITEM.COLLECTIBLE.PENNY_ALBUM, mod.PennyAlbumDamageCache, CacheFlag.CACHE_DAMAGE)



-- Drop every stored penny on the ground
local function dropPennies(player)
	local trackers = { "PENNY_ALBUM", "PENNY_ALBUM_BLASPHEMOUS", }
	local room = Game():GetRoom()
	local spawnedPennies = 0

	for i, tracker in pairs(trackers) do
		local pennies = player:GetInnateTrinketGroup(tracker)

		for pennyID, amount in pairs(pennies) do
			-- Spawn the trinkets one by one
			for j = 1, amount do
				local pos = room:FindFreePickupSpawnPosition(player.Position, 0, true)
				local penny = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, pennyID, pos, Vector.Zero, player):ToPickup()
				penny:SetDropDelay(spawnedPennies)
				penny.Wait = Settings.PickupDelay

				-- Make the trinket Blasphemous again
				if tracker == "PENNY_ALBUM_BLASPHEMOUS" then
					mod:MakePickupTrinketBlasphemous(penny)
				end

				spawnedPennies = spawnedPennies + 1
			end

			-- Remove it from the tracker
			player:RemoveInnateTrinket(pennyID, amount, tracker)
		end
	end

	player:SetInnateTrinketGroup("PENNY_ALBUM_CAR_BATTERY", {})
	mod:TriggerBlasphemousDamageCache(player)
	return spawnedPennies
end

-- Drop stored pennies when using the item
function mod:PennyAlbumUseItem(id, rng, player, flags, slot, varData)
	local spawnedPennies = dropPennies(player)

	return {
		Discharge = spawnedPennies > 0,
		Remove = false,
		ShowAnim = spawnedPennies > 0,
	}
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.PennyAlbumUseItem, mod.ITEM.COLLECTIBLE.PENNY_ALBUM)

-- Drop stored pennies when the item is removed
function mod:PennyAlbumRemoveItem(player, id, removeFromForm, innate)
	dropPennies(player)
end
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, mod.PennyAlbumRemoveItem, mod.ITEM.COLLECTIBLE.PENNY_ALBUM)



-- Make penny trinkets more likely to appear
function mod:PennyAlbumReplaceTrinket(selected, rng)
	if not isPennyTrinket(selected) and mod:Random(nil, nil, rng) <= Settings.TrinketReplaceChance / 100 then
		return mod:GetPennyTrinketIncludingFunnies(rng)
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_GET_TRINKET, mod.ITEM.COLLECTIBLE.PENNY_ALBUM, mod.PennyAlbumReplaceTrinket)



-- Spawn a Penny Press every floor
function mod:PennyAlbumNewFloor()
	local pennyPresses = 0

	-- Spawn one for every player that has the item
	for i, player in pairs( PlayerManager.GetPlayers() ) do
		if player:HasCollectible(mod.ITEM.COLLECTIBLE.PENNY_ALBUM) then
			pennyPresses = pennyPresses + 1
		end
	end

	-- Spawn them in a neat grid
	local room = Game():GetRoom()
	local startPos = Game():IsGreedMode() and room:GetGridPosition(67) or room:GetCenterPos()
	local positions = mod:GetGridPositions(pennyPresses, 60, 4)

	for i, offset in pairs(positions) do
		local spawnPos = startPos + Vector(0, -60) + offset
		Isaac.Spawn(EntityType.ENTITY_SLOT, mod.FF.PennyPress.Var, 0, spawnPos, Vector.Zero, nil)
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.ITEM.COLLECTIBLE.PENNY_ALBUM, mod.PennyAlbumNewFloor)



-- Add extra copies of the stored trinkets when picking up Car Battery
function mod:PennyAlbumAddCarBattery(id, charge, firstTime, slot, varData, player)
	if player:GetCollectibleNum(CollectibleType.COLLECTIBLE_CAR_BATTERY) <= 1 then
		local trackers = { "PENNY_ALBUM", "PENNY_ALBUM_BLASPHEMOUS", }

		for i, tracker in pairs(trackers) do
			local pennies = player:GetInnateTrinketGroup(tracker)

			for pennyID, amount in pairs(pennies) do
				player:AddInnateTrinket(pennyID, amount, "PENNY_ALBUM_CAR_BATTERY")
			end
		end
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.ITEM.COLLECTIBLE.PENNY_ALBUM, mod.PennyAlbumAddCarBattery, CollectibleType.COLLECTIBLE_CAR_BATTERY)

-- Remove the extra copies when Car Battery is removed
function mod:PennyAlbumRemoveCarBattery(player, id, removeFromForm, innate)
	if not player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
		player:SetInnateTrinketGroup("PENNY_ALBUM_CAR_BATTERY", {})
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, mod.ITEM.COLLECTIBLE.PENNY_ALBUM, mod.PennyAlbumRemoveCarBattery, CollectibleType.COLLECTIBLE_CAR_BATTERY)



-- Active item synergies when picking up coins
function mod:PennyAlbumSynergies(pickup, player, value)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.PENNY_ALBUM) then
		local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.PENNY_ALBUM)

		-- Book of Virtues Wisps
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
			local chance = Settings.VirtuesBaseChance + (Settings.VirtuesExtraChance * value)

			if mod:Random(nil, nil, rng) <= chance / 100 then
				player:AddWisp(mod.ITEM.COLLECTIBLE.PENNY_ALBUM, pickup.Position, true)
			end
		end

		-- Judas' Birthright temporary damage (just uses Wrathful Penny)
		if mod:playerIsBelialMode(player) then
			local effects = player:GetEffects()
			local valueMulti = math.max(1, value / 2.7)
			local duration = math.floor(30 * valueMulti)
			effects:AddTrinketEffect(mod.ITEM.TRINKET.DAMAGE_PENNY, true, duration)
		end

		-- Electrum zaps
		if player:HasTrinket(mod.ITEM.ROCK.ELECTRUM) then
			local electrumMulti = player:GetTrinketMultiplier(mod.ITEM.ROCK.ELECTRUM)
			local damage = (player.Damage * electrumMulti) + value
			mod:alternateElectrumShock(player, rng, damage, pickup.Position, 1, nil, nil, electrumMulti)
		end
	end
end