local mod = FiendFolio
local game = Game()
local itemConfig = Isaac.GetItemConfig()

-- TODO: Not yet fully portable
-- BUG: Data for a queued trinket will be lost if you exit the run while its queued
-- BUG: Blasphemous trinkets will flicker on the hud sometimes

local debugging = false

-- We need to check for trinkets moving pretty much constantly,
-- but this avoids recursive updates.
local needUpdateTrackedTrinkets = false
local updatingTrackedTrinkets = false

-- TrinketTracker data structure is designed to live inside a savedata table.
local function GetTrackedTrinkets()
	if needUpdateTrackedTrinkets and not updatingTrackedTrinkets then
		mod.TrinketTracker:UpdateTrackedTrinkets()
	end
	if not FiendFolio.savedata or not FiendFolio.savedata.run then
		return {}
	end
	local rundata = FiendFolio.savedata.run
	if not rundata.TRACKED_TRINKETS then
		rundata.TRACKED_TRINKETS = {}
	end
	return rundata.TRACKED_TRINKETS
end

local function MintPlayerKey()
	local savedata = FiendFolio.savedata.run
	savedata.NUM_TRINKET_TRACKER_PLAYERS = (savedata.NUM_TRINKET_TRACKER_PLAYERS or 0) + 1
	return savedata.NUM_TRINKET_TRACKER_PLAYERS
end

function mod:GetQueuedTrinket(player)
	if player.QueuedItem.Item and player.QueuedItem.Item:IsTrinket() then
		local id = player.QueuedItem.Item.ID
		if player:GetHeldSprite():GetRenderFlags() & AnimRenderFlags.GOLDEN ~= 0 then
			id = id | TrinketType.TRINKET_GOLDEN_FLAG
		end
		return id
	end
end

local function _GetSubTable(init, stringKeys, tab, key, ...)
	if stringKeys then
		key = ""..key  -- For the tracked trinkets table, all keys must be strings for json compatibility.
	end
	if not tab[key] then
		if init then
			tab[key] = {}
		else
			return
		end
	end
	if #{...} > 0 then
		return _GetSubTable(init, stringKeys, tab[key], ...)
	end
	return tab[key]
end

local function GetSavedSubTable(tab, key, ...)
	return _GetSubTable(true, true, tab, key, ...)
end

local function GetSavedSubTableOrNil(tab, key, ...)
	return _GetSubTable(false, true, tab, key, ...)
end

local function GetSubTable(tab, key, ...)
	return _GetSubTable(true, false, tab, key, ...)
end

local function GetSubTableOrNil(tab, key, ...)
	return _GetSubTable(false, false, tab, key, ...)
end

mod.TrinketTracker = {
	-- Add callbacks like this:
	-- mod:AddCallback(mod.TrinketTracker.Callbacks.PLAYER_EVALUATE_TRINKET, ...)
	-- Ignore how the callback IDs are initialized to empty strings - they are populated with unique keys below.
	Callbacks = {
		PLAYER_EVALUATE_TRINKET = "",  -- Called on MC_EVALUATE_CACHE for every tracked trinket the player holds.
			-- Args: (player, trackedTrinket, cacheFlag)
			-- Optional Param: CacheFlag
		PLAYER_TRINKET_ADDED = "",  -- Called when the player gains a tracked trinket.
			-- Args: (player, trackedTrinket, oldLocation)
			-- Optional Param: TrinketType
		PLAYER_TRINKET_REMOVED = "",  -- Called when the player loses the tracked trinket.
			-- Args: (player, trackedTrinket, oldLocation)
			-- Optional Param: TrinketType
		PRE_RENDER_TRINKET = "",  -- Called before the sprite of a tracked trinket is rendered regardless of current location. Return true to skip.
			-- Args: (sprite, trackedTrinket)
			-- Optional Param: TrinketType
	},
	Location = {
		GROUND = 1,
		QUEUE = 2,
		POCKET = 3,
		SMELTED = 4,
	},
}

local callbackKey = string.sub(tostring(mod.TrinketTracker), 10)
for callback, _ in pairs(mod.TrinketTracker.Callbacks) do
	mod.TrinketTracker.Callbacks[callback] = "[" .. mod.Name .. "] " .. "TrinketTracker." .. callback .. "<" .. callbackKey ..">"
end

local TrinketLocation = mod.TrinketTracker.Location

local function LogError(str)
	str = "["..mod.Name..".TricketTracker] " .. str
	Console.PrintError(str)
	Isaac.DebugString(str)
end

local function LogDebug(str)
	if debugging then
		str = "["..mod.Name..".TricketTracker] " .. str
		print(str)
	end
end

local function KeyIterator(tab, keys)
	local i = 0
	return function()
		local k

		repeat
			i = i + 1
			k = keys[i]
			if k then
				k = ""..k
			end
		until not k or tab[k]

		if k and tab[k] then
			return k, tab[k]
		end
	end
end

local function CleanTable(tab)
	local isEmpty = true
	local emptySubTableKeys = {}

	for k,v in pairs(tab) do
		if type(v) == "table" and k ~= "Data" then
			local emptySubTable = CleanTable(v)
			if emptySubTable then
				table.insert(emptySubTableKeys, k)
			else
				isEmpty = false
			end
		else
			isEmpty = false
		end
	end

	for _, k in ipairs(emptySubTableKeys) do
		tab[k] = nil
	end

	return isEmpty
end

local function QueryTrackedTrinketsInternal(queries, func, ignoreGoldenState)
	local trackedTrinkets = GetTrackedTrinkets()

	if not queries then
		queries = {TrinketLocation.GROUND, TrinketLocation.QUEUE, TrinketLocation.POCKET, TrinketLocation.SMELTED}
	end

	for k, v in pairs(queries) do
		local locType, q
		if type(v) == "number" then
			locType = v
			q = {}
		else
			locType = k
			q = v
		end

		local filter
		if q.TrinketTypes then
			filter = {}
			for _, t in ipairs(q.TrinketTypes) do
				if ignoreGoldenState then
					filter[t & TrinketType.TRINKET_ID_MASK] = true
					filter[t | TrinketType.TRINKET_GOLDEN_FLAG] = true
				else
					filter[t] = true
				end
			end
		end

		local typeTab = GetSavedSubTable(trackedTrinkets, locType)
		local variants = q.LocationVariants or {}
		local subTypes = q.LocationSubTypes or {}
		if #subTypes == 0 and locType == TrinketLocation.SMELTED and q.TrinketTypes then
			for t, _ in pairs(filter) do
				table.insert(subTypes, t)
			end
		end

		local variantIterator = (#variants == 0) and pairs or KeyIterator
		for locVariant, variantTab in variantIterator(typeTab, variants) do
			local subIterator = (#subTypes == 0) and pairs or KeyIterator
			for locSubType, subTab in subIterator(variantTab, subTypes) do
				for i=#subTab, 1, -1 do
					local trackedTrinket = subTab[i]
					local t = trackedTrinket.Type
					if not filter or filter[t] then
						if not func then
							return trackedTrinket
						end
						local result = func(trackedTrinket)
						if type(result) == "table" then
							if result.Remove then
								table.remove(subTab, i)
								if result.RunRemovedCallback and trackedTrinket.Location.Type == TrinketLocation.POCKET or trackedTrinket.Location.Type == TrinketLocation.SMELTED then
									local entity = trackedTrinket.Location.Entity and trackedTrinket.Location.Entity.Ref or nil
									local player = entity and entity:Exists() and entity:ToPlayer() or nil
									if player then
										Isaac.RunCallbackWithParam(mod.TrinketTracker.Callbacks.PLAYER_TRINKET_REMOVED, trackedTrinket.Type, player, trackedTrinket, trackedTrinket.Location)
									end
								end
							end
							if result.Return then
								return trackedTrinket
							end
						elseif result then
							return trackedTrinket
						end
					end
				end
			end
		end
	end
end

local function GetTransientEntityData(entity)
	local data = mod:GetEntityData(entity)
	if not data.ffTrinketTrackerData then
		data.ffTrinketTrackerData = {}
	end
	return data.ffTrinketTrackerData
end

local function GetCurrentRoomKey()
	return ""..game:GetLevel():GetCurrentRoomDesc().ListIndex
end

local function GetEntityKey(entity)
	if entity.Type == EntityType.ENTITY_PLAYER then
		-- Player InitSeeds are inconsistent with Tainted Lazarus & co-op.
		-- USed to use GetCollectibleRNG but it gets funny with Esau Jr and Tainted Lazarus
		local d = EntitySaveStateManager.GetEntityData(mod, entity)
		if not d.mykey then
			d.mykey = MintPlayerKey()
		end
		return ""..d.mykey
	end
	return ""..entity.InitSeed
end

local function UpdatePlayerState(player)
	GetTransientEntityData(player).LastState = {
		Trinkets = {
			[0] = player:GetTrinket(0),
			[1] = player:GetTrinket(1),
		},
		QueuedTrinket = mod:GetQueuedTrinket(player),
	}
end

local function InvalidatePlayerState(player)
	if player then
		GetTransientEntityData(player).LastState = {
			Trinkets = {
				[0] = 0,
				[1] = 0,
			},
			QueuedTrinket = nil,
		}
	end
end

local function GetLastPlayerState(player)
	local data = GetTransientEntityData(player)
	if not data.LastState then
		UpdatePlayerState(player)
	end
	return data.LastState
end

local function InsertTrackedTrinket(trackedTrinket)
	local loc = trackedTrinket.Location
	local tab = GetSavedSubTable(GetTrackedTrinkets(), loc.Type, loc.Variant, loc.SubType)
	table.insert(tab, trackedTrinket)
end

local function CheckLocationPtr(location, entity)
	if not location.Entity or not location.Entity.Ref or not location.Entity.Ref:Exists() then
		location.Entity = EntityPtr(entity)
	end
end

function mod.TrinketTracker:GetDataForPickup(pickup, init)
	if pickup.Type ~= EntityType.ENTITY_PICKUP or pickup.Variant ~= PickupVariant.PICKUP_TRINKET then
		return
	end

	local roomkey = GetCurrentRoomKey()
	local key = GetEntityKey(pickup)

	local trackedTrinket = QueryTrackedTrinketsInternal({
		[TrinketLocation.GROUND] = {
			LocationVariants={roomkey},
			LocationSubTypes={key},
			TrinketTypes={pickup.SubType},
		}})

	if trackedTrinket then
		CheckLocationPtr(trackedTrinket.Location, pickup)
		return trackedTrinket
	end

	if init then
		local new = {
			Type = pickup.SubType,
			Location = {
				Type = TrinketLocation.GROUND,
				Variant = roomkey,
				SubType = key,
				EntityKey = key,
				Entity = EntityPtr(pickup),
			},
			Data = {},
		}
		InsertTrackedTrinket(new)
		return new
	end
end

function mod.TrinketTracker:GetDataForPlayerSlot(player, slot, init)
	if player.Type ~= EntityType.ENTITY_PLAYER or slot < 0 or slot > 1 then
		return
	end
	player = player:ToPlayer()
	local key = GetEntityKey(player)
	local trinket = player:GetTrinket(slot)

	local trackedTrinket = QueryTrackedTrinketsInternal({
		[TrinketLocation.POCKET] = {
			LocationVariants={key},
			LocationSubTypes={slot},
			TrinketTypes={trinket},
		}})

	if trackedTrinket then
		CheckLocationPtr(trackedTrinket.Location, player)
		return trackedTrinket
	end

	if init then
		local new = {
			Type = trinket,
			Location = {
				Type = TrinketLocation.POCKET,
				Variant = key,
				SubType = slot,
				EntityKey = key,
				Entity = EntityPtr(player),
			},
			Data = {},
		}
		InsertTrackedTrinket(new)
		return new
	end
end

function mod.TrinketTracker:SwapPlayerSlotData(player)
	local slot0 = mod.TrinketTracker:GetDataForPlayerSlot(player, 0, true)
	local slot1 = mod.TrinketTracker:GetDataForPlayerSlot(player, 1, true)
	local slot0data = slot0.Data
	slot0.Data = slot1.Data
	slot1.Data = slot0data
	slot0.HudSprite = nil
	slot1.HudSprite = nil
end

function mod.TrinketTracker:GetDataForPlayerQueue(player, init)
	if player.Type ~= EntityType.ENTITY_PLAYER then
		return
	end
	player = player:ToPlayer()
	local key = GetEntityKey(player)

	local queuedTrinket = mod:GetQueuedTrinket(player)
	if not queuedTrinket then return end

	local trackedTrinket = QueryTrackedTrinketsInternal({
		[TrinketLocation.QUEUE] = {
			LocationVariants = {key},
			TrinketTypes = {queuedTrinket},
		}})

	if trackedTrinket then
		CheckLocationPtr(trackedTrinket.Location, player)
		return trackedTrinket
	end

	if init then
		local new = {
			Type = trinket,
			Location = {
				Type = TrinketLocation.QUEUE,
				Variant = key,
				SubType = 0,
				EntityKey = key,
				Entity = EntityPtr(player),
			},
			Data = {},
		}
		InsertTrackedTrinket(new)
		return new
	end
end

-- Scans the player's current smelted trinkets and initializes any untracked instances.
local function CheckSmeltedTrinketInit(player, trinketType, gulpTime)
	local totalNum = 0
	local numTracked = 0

	for _, existing in ipairs(mod.TrinketTracker:GetSmelted(player, trinketType)) do
		if not gulpTime or existing.Location.Time == gulpTime then
			numTracked = numTracked + 1
		end
	end

	local key = GetEntityKey(player)

	for _, historyItem in ipairs(player:GetHistory():SearchTrinkets(trinketType)) do
		-- SearchTrinkets is not golden-sensitive, so double check the ID.
		if historyItem:GetItemID() == trinketType and (not gulpTime or historyItem:GetTime() == gulpTime) then
			totalNum = totalNum + 1
			if numTracked < totalNum then
				InsertTrackedTrinket({
					Type = trinketType,
					Location = {
						Type = TrinketLocation.SMELTED,
						Variant = key,
						SubType = trinketType,
						EntityKey = key,
						Entity = EntityPtr(player),
						Time = historyItem:GetTime(),
					},
					Data = {},
				})
			end
		end
	end
end

-- Returns a potentially-empty list of tracked trinkets of the given type, and optionally matching a specific gulpTime.
-- If "init" is true, initializes empty tracking data for all smelted trinkets that match the query if they are not currently tracked.
function mod.TrinketTracker:GetDataForPlayerSmelted(player, trinketType, gulpTime, ignoreGoldenState, init)
	if init then
		if ignoreGoldenState then
			local cleanid = trinketType & TrinketType.TRINKET_ID_MASK
			local goldenid = cleanid | TrinketType.TRINKET_GOLDEN_FLAG
			CheckSmeltedTrinketInit(player, cleanid, gulpTime)
			CheckSmeltedTrinketInit(player, goldenid, gulpTime)
		else
			CheckSmeltedTrinketInit(player, trinketType, gulpTime)
		end
	end

	local out = {}

	local query = {
		[TrinketLocation.SMELTED] = {
			LocationVariants={GetEntityKey(player)},
			LocationSubTypes={trinketType},
		},
	}
	QueryTrackedTrinketsInternal(query, function(trackedTrinket)
		if not gulpTime or gulpTime == trackedTrinket.Location.Time then
			table.insert(out, trackedTrinket)
		end
	end, ignoreGoldenState)

	return out
end

-- Returns the current stored list of tracked smelted copies of this trinket. May not include untracked copies.
function mod.TrinketTracker:GetSmelted(player, trinketType)
	if player.Type ~= EntityType.ENTITY_PLAYER then
		return {}
	end
	return GetSavedSubTableOrNil(GetTrackedTrinkets(), TrinketLocation.SMELTED, GetEntityKey(player), trinketType) or {}
end

function mod.TrinketTracker:QueryPlayer(player, func, includeQueue, trinket)
	local filter = {LocationVariants={GetEntityKey(player)}}
	if trinket then
		if type(trinket) == "number" then
			filter.TrinketTypes = {trinket}
		elseif type(trinket) == "table" then
			filter.TrinketTypes = trinket
		end
	end
	local query = {
		[TrinketLocation.POCKET] = filter,
		[TrinketLocation.SMELTED] = filter,
	}
	if includeQueue then
		query[TrinketLocation.QUEUE] = filter
	end
	return QueryTrackedTrinketsInternal(query, func, true)
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	local byKey = {}

	QueryTrackedTrinketsInternal({[TrinketLocation.GROUND]={LocationVariants={GetCurrentRoomKey()}}}, function(trackedTrinket)
		byKey[trackedTrinket.Location.EntityKey] = trackedTrinket
	end)

	for _, pickup in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET)) do
		local trackedTrinket = byKey[GetEntityKey(pickup)]
		if trackedTrinket then
			trackedTrinket.Location.Entity = EntityPtr(pickup)
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
	GetTrackedTrinkets()[TrinketLocation.GROUND] = {}
end)

local function CheckPlayers(func)
	for _, player in ipairs(PlayerManager.GetPlayers()) do
		if player:Exists() then
			func(player)
		end
		local flipped = player:GetFlippedForm()
		if flipped then
			func(flipped)
		end
	end
	for i=0,3 do
		local esaujr = PlayerManager.GetEsauJrState(i)
		if esaujr then
			func(esaujr)
		end
	end
end

local function RegeneratePointers()
	local players = {}
	CheckPlayers(function(player)
		players[GetEntityKey(player)] = player
	end)

	local pickups = {}
	for _, pickup in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET)) do
		pickups[GetEntityKey(pickup)] = pickup
	end

	QueryTrackedTrinketsInternal(nil, function(trackedTrinket)
		local location = trackedTrinket.Location
		if not location.Entity or not location.Entity.Ref then
			local entity = (location.Type == TrinketLocation.GROUND) and pickups[location.EntityKey] or players[location.EntityKey]
			location.Entity = entity and EntityPtr(entity) or {}
		end
	end)
end

local arrivalsCache = {}

local function FindGroundArrivals()
	local arrivals = {}

	local roomkey = GetCurrentRoomKey()
	for _, pickup in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET)) do
		if pickup.FrameCount <= 1 then
			local key = GetEntityKey(pickup)
			table.insert(arrivals, {
				TrinketType = pickup.SubType,
				Location = {
					Type = TrinketLocation.GROUND,
					Variant = roomkey,
					SubType = key,
					EntityKey = key,
					Entity = EntityPtr(pickup),
					Time = game:GetFrameCount() - pickup.FrameCount,
				},
			})
		end
	end

	return arrivals
end

local function FindPocketArrivals()
	local arrivals = {}

	CheckPlayers(function(player)
		local key = GetEntityKey(player)
		local lastState = GetLastPlayerState(player)
		for i=0,1 do
			local trinket =  player:GetTrinket(i)
			if trinket > 0 and trinket ~= lastState.Trinkets[i] then
				table.insert(arrivals, {
					TrinketType = trinket,
					Location = {
						Type = TrinketLocation.POCKET,
						Variant = key,
						SubType = i,
						EntityKey = key,
						Entity = EntityPtr(player),
						Time = game:GetFrameCount(),
					},
				})
			end
		end
	end)

	return arrivals
end

local function FindQueueArrivals()
	local arrivals = {}

	CheckPlayers(function(player)
		local lastState = GetLastPlayerState(player)
		local queuedTrinket = mod:GetQueuedTrinket(player)
		if queuedTrinket and queuedTrinket ~= lastState.QueuedTrinket then
			local key = GetEntityKey(player)
			table.insert(arrivals, {
				TrinketType = queuedTrinket,
				Location = {
					Type = TrinketLocation.QUEUE,
					Variant = key,
					SubType = 0,
					EntityKey = key,
					Entity = EntityPtr(player),
					Time = game:GetFrameCount(),
				},
			})
		end
	end)

	return arrivals
end

local function FindSmeltedArrivals()
	local arrivals = {}

	local currentFrame = game:GetFrameCount()

	CheckPlayers(function(player)
		local key = GetEntityKey(player)
		local history = player:GetHistory():SearchTrinkets()
		local i = #history

		while history[i] and history[i]:GetTime() >= currentFrame-1 do
			local trinket = history[i]:GetItemID()
			table.insert(arrivals, {
				TrinketType = trinket,
				Location = {
					Type = TrinketLocation.SMELTED,
					Variant = key,
					SubType = trinket,
					EntityKey = key,
					Entity = EntityPtr(player),
					Time = history[i]:GetTime(),
				},
			})
			i = i-1
		end
	end)

	return arrivals
end

local function GetArrivals(locationType)
	if not arrivalsCache[locationType] then
		if locationType == TrinketLocation.GROUND then
			arrivalsCache[locationType] = FindGroundArrivals()
		elseif locationType == TrinketLocation.POCKET then
			arrivalsCache[locationType] = FindPocketArrivals()
		elseif locationType == TrinketLocation.QUEUE then
			arrivalsCache[locationType] = FindQueueArrivals()
		elseif locationType == TrinketLocation.SMELTED then
			arrivalsCache[locationType] = FindSmeltedArrivals()
		end
	end
	return arrivalsCache[locationType] or {}
end

local function ResetArrivalsCache()
	arrivalsCache = {}
end
ResetArrivalsCache()

local function GetLocationStr(location)
	if location.Type == TrinketLocation.GROUND then
		return " on ground in room " .. location.Variant .. " with InitSeed " .. location.SubType
	elseif location.Type == TrinketLocation.QUEUE then
		return " in queue"
	elseif location.Type == TrinketLocation.POCKET then
		return " in player slot " .. location.SubType
	elseif location.Type == TrinketLocation.SMELTED then
		return " smelted by player @ " .. location.Time
	end
end

local delayedCallbacks = {}

local function LocateTrinket(trackedTrinket)
	local oldLocation = trackedTrinket.Location

	local locationsToCheck = {}

	if oldLocation.Type == TrinketLocation.GROUND then
		locationsToCheck = {TrinketLocation.QUEUE, TrinketLocation.POCKET, TrinketLocation.SMELTED, TrinketLocation.GROUND}
	elseif oldLocation.Type == TrinketLocation.QUEUE then
		locationsToCheck = {TrinketLocation.POCKET, TrinketLocation.GROUND, TrinketLocation.SMELTED, TrinketLocation.QUEUE}
	elseif oldLocation.Type == TrinketLocation.POCKET then
		locationsToCheck = {TrinketLocation.GROUND, TrinketLocation.SMELTED, TrinketLocation.QUEUE, TrinketLocation.POCKET}
	elseif oldLocation.Type == TrinketLocation.SMELTED then
		locationsToCheck = {TrinketLocation.GROUND, TrinketLocation.POCKET, TrinketLocation.QUEUE, TrinketLocation.SMELTED}
	end

	for _, newLocationType in ipairs(locationsToCheck) do
		local arrivals = GetArrivals(newLocationType)
		for i=#arrivals, 1, -1 do
			local arrival = arrivals[i]
			if arrival.TrinketType == trackedTrinket.Type then
				trackedTrinket.Location = arrival.Location
				table.remove(arrivals, i)

				local oldEntity = oldLocation.Entity.Ref
				local newEntity = arrival.Location.Entity.Ref

				LogDebug("Moved " .. trackedTrinket.Type .. " from" .. GetLocationStr(oldLocation) .. " -> to" .. GetLocationStr(trackedTrinket.Location))
				InsertTrackedTrinket(trackedTrinket)

				local removedFromPlayer = (oldLocation.Type == TrinketLocation.POCKET or oldLocation.Type == TrinketLocation.SMELTED) and oldEntity and oldEntity:Exists() and oldEntity:ToPlayer() or nil
				local addedToPlayer = (newLocationType == TrinketLocation.POCKET or newLocationType == TrinketLocation.SMELTED) and newEntity and newEntity:Exists() and newEntity:ToPlayer() or nil
				local samePlayer = removedFromPlayer and addedToPlayer and GetPtrHash(removedFromPlayer) == GetPtrHash(addedToPlayer)

				if not samePlayer then
					if removedFromPlayer then
						table.insert(delayedCallbacks, function() Isaac.RunCallbackWithParam(mod.TrinketTracker.Callbacks.PLAYER_TRINKET_REMOVED, trackedTrinket.Type, removedFromPlayer, trackedTrinket, oldLocation) end)
					end
					if addedToPlayer then
						table.insert(delayedCallbacks, function() Isaac.RunCallbackWithParam(mod.TrinketTracker.Callbacks.PLAYER_TRINKET_ADDED, trackedTrinket.Type, addedToPlayer, trackedTrinket, oldLocation) end)
					end
				end

				return true
			end
		end
	end
	return false
end

mod:AddPriorityCallback(ModCallbacks.MC_POST_PICKUP_INIT, -math.huge, function()
	needUpdateTrackedTrinkets = true
end, PickupVariant.PICKUP_TRINKET)

mod:AddPriorityCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, -math.huge, function(_, pickup, collider)
	if pickup:IsDead() then
		needUpdateTrackedTrinkets = true
	end
end, PickupVariant.PICKUP_TRINKET)

mod:AddPriorityCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, -math.huge, function(_, entity)
	if entity.Variant == PickupVariant.PICKUP_TRINKET then
		needUpdateTrackedTrinkets = true
	end
end, EntityType.ENTITY_PICKUP)

mod:AddPriorityCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, -math.huge, function(_, player, trinket, firstTime, innate)
	if not innate then
		needUpdateTrackedTrinkets = true
	end
end)

-- Track removed trinkets each frame to try to minimize how often we have to parse the player's smelted trinkets.
local removedTrinkets = {}

mod:AddPriorityCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, -math.huge, function(_, player, trinket, innate)
	if not innate then
		needUpdateTrackedTrinkets = true

		local key = GetEntityKey(player)
		if not removedTrinkets[key] then
			removedTrinkets[key] = {}
		end
		removedTrinkets[key][trinket] = true
	end
end)

mod:AddPriorityCallback(ModCallbacks.MC_USE_ITEM, -math.huge, function()
	needUpdateTrackedTrinkets = true
end, CollectibleType.COLLECTIBLE_SMELTER)

local function IsTrinketMissing(trackedTrinket)
	local trinket = trackedTrinket.Type
	local location = trackedTrinket.Location
	local entityExists = location.Entity.Ref and location.Entity.Ref.Type == (location.Type == TrinketLocation.GROUND and 5 or 1)

	-- :Exists() check should be used for pickups but not players
	if entityExists and location.Type == TrinketLocation.GROUND and not location.Entity.Ref:Exists() then
		entityExists = false
	end

	if entityExists then
		local t = location.Entity.Ref.Type
		local var = location.Entity.Ref.Variant
		local subt = location.Entity.Ref.SubType
		local entityValid = (location.Type == TrinketLocation.GROUND) and (t == EntityType.ENTITY_PICKUP and var == PickupVariant.PICKUP_TRINKET and subt == trackedTrinket.Type) or (t == EntityType.ENTITY_PLAYER)
		if not entityValid then
			LogDebug("Invalid entity for " .. trinket .. GetLocationStr(location))
			return true
		end
	end

	if location.Type == TrinketLocation.GROUND then
		if not entityExists then
			-- Try to see if we can find the pickup entity again...
			for _, pickup in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET)) do
				if pickup:Exists() and not pickup:IsDead() and GetEntityKey(pickup) == location.EntityKey then
					location.Entity = EntityPtr(pickup)
					return false
				end
			end
			return true
		end
		return false
	end

	if not entityExists then
		return true
	end

	local player = location.Entity.Ref:ToPlayer()
	if player:IsCoopGhost() then
		-- Ignore until they come back
		return false
	elseif location.Type == TrinketLocation.QUEUE then
		local queuedTrinket = mod:GetQueuedTrinket(player)
		return not queuedTrinket or queuedTrinket ~= trinket
	elseif location.Type == TrinketLocation.POCKET then
		local slot = location.SubType
		return player:GetTrinket(slot) ~= trinket
	elseif location.Type == TrinketLocation.SMELTED and removedTrinkets[location.EntityKey] and removedTrinkets[location.EntityKey][trinket] then
		local obtainedFrame = location.Time
		local found = false

		local history = player:GetHistory():GetCollectiblesHistory()
		local j = #history
		while history[j] and history[j]:GetTime() >= obtainedFrame do
			local historyItem = history[j]
			if historyItem:GetTime() == obtainedFrame and historyItem:IsTrinket() and historyItem:GetItemID() == trinket then
				found = true
				break
			end
			j = j-1
		end

		return not found
	end
end

-- If any of the tracked trickets have moved, try to find them again.
-- Only give up and untrack them if they are still missing by the end of the update cycle.
function mod.TrinketTracker:UpdateTrackedTrinkets(isPostUpdate)
	updatingTrackedTrinkets = true
	ResetArrivalsCache()
	delayedCallbacks = {}

	local query = {
		[TrinketLocation.GROUND] = {LocationVariants={GetCurrentRoomKey()}},
		[TrinketLocation.QUEUE] = {},
		[TrinketLocation.POCKET] = {},
		[TrinketLocation.SMELTED] = {},
	}
	QueryTrackedTrinketsInternal(query, function(trackedTrinket)
		if isPostUpdate then
			-- Stop tracking trinkets that no longer have data.
			local hasData = false
			for k,v in pairs(trackedTrinket.Data) do
				if v then
					hasData = true
					break
				end
			end
			if not hasData then
				return {Remove=true}
			end
		end

		local trinket = trackedTrinket.Type
		local location = trackedTrinket.Location

		if not location.Entity or not location.Entity.Ref then
			RegeneratePointers()
		end

		if IsTrinketMissing(trackedTrinket) then
			if location.Type ~= TrinketLocation.GROUND then
				if (not location.Entity.Ref or not location.Entity.Ref:ToPlayer()) then
					LogDebug("Player disappeared with trinket " .. trinket .. GetLocationStr(location))
					return {Remove=isPostUpdate}
				elseif location.Entity.Ref:ToPlayer():HasCurseMistEffect() then
					return  -- Disregard missing trinkets with curse mist active
				end
			end
			local success = LocateTrinket(trackedTrinket)
			if not success then
				LogDebug("Lost track of trinket " .. trinket .. GetLocationStr(location))
			end
			return {
				Remove = success or isPostUpdate,
				RunRemovedCallback = isPostUpdate and not success,
			}
		end
	end)

	if isPostUpdate then
		CheckPlayers(function(player)
			UpdatePlayerState(player)
		end)
		removedTrinkets = {}
		CleanTable(GetTrackedTrinkets())
	end

	for _, func in pairs(delayedCallbacks) do
		func()
	end

	updatingTrackedTrinkets = false
	needUpdateTrackedTrinkets = false
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	mod.TrinketTracker:UpdateTrackedTrinkets(true)
end)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cacheFlag)
	local key = GetEntityKey(player)
	local query = {
		[TrinketLocation.POCKET] = {LocationVariants={key}},
		[TrinketLocation.SMELTED] = {LocationVariants={key}},
	}
	QueryTrackedTrinketsInternal(query, function(trackedTrinket)
		Isaac.RunCallbackWithParam(mod.TrinketTracker.Callbacks.PLAYER_EVALUATE_TRINKET, cacheFlag, player, trackedTrinket, cacheFlag)
	end)
end)

FiendFolio:AddPriorityCallback(ModCallbacks.MC_USE_ITEM, -math.huge, function(_, _, _, player)
	InvalidatePlayerState(player)
	InvalidatePlayerState(player:GetFlippedForm())
end, CollectibleType.COLLECTIBLE_FLIP)

FiendFolio:AddPriorityCallback(ModCallbacks.MC_POST_DISCHARGE_ACTIVE_ITEM, -math.huge, function(_, _, _, player)
	InvalidatePlayerState(player)
	for i=0,3 do
		InvalidatePlayerState(PlayerManager.GetEsauJrState(i))
	end
end, CollectibleType.COLLECTIBLE_ESAU_JR)

local function CreateTrinketSprite(id, player)
	local sprite = Sprite()
	sprite:Load("gfx/ui/ff_hud_item.anm2", true)
	sprite:Play("HUD", true)
	local gfx = itemConfig:GetTrinket(id).GfxFileName
	if player then
		if id == TrinketType.TRINKET_ERROR then
			local errorEffect = player:GetErrorTrinketEffect()
			if errorEffect > 0 then
				id = errorEffect
				gfx = itemConfig:GetTrinket(errorEffect).GfxFileName
				sprite.Color:SetTint(0.5176471, 0.10196079, 0.10196079, 1)
			end
		end
		if id == TrinketType.TRINKET_MODELING_CLAY then
			local modelingClayEffect = player:GetModelingClayEffect()
			if modelingClayEffect > 0 then
				gfx = itemConfig:GetCollectible(modelingClayEffect).GfxFileName
				sprite.Color:SetColorize(0.5976471, 0.33411765, 0.31058824, 1)
			end
		end
	end
	sprite:ReplaceSpritesheet(0, gfx, true)
	return sprite
end

local function RenderTrinketHudSprite(id, sprite, trackedTrinket, pos, scale, crop, smelted)
	sprite.Scale = Vector(scale, scale)
	sprite:GetLayer(0):SetCropOffset(crop)
	if id & TrinketType.TRINKET_GOLDEN_FLAG ~= 0 then
		sprite:SetRenderFlags(AnimRenderFlags.GOLDEN)
	else
		sprite:SetRenderFlags(0)
	end
	sprite.Color.A = smelted and 0.5 or 1
	local skip = false
	if trackedTrinket then
		skip = Isaac.RunCallbackWithParam(mod.TrinketTracker.Callbacks.PRE_RENDER_TRINKET, id, sprite, pos, trackedTrinket)
	end
	if not skip then
		sprite:Render(pos)
	end
end

local function RenderTrackedTrinketHudSprite(trackedTrinket, pos, scale, crop, smelted)
	local id = trackedTrinket.Type
	if not trackedTrinket.HudSprite then
		local entity = trackedTrinket.Location.Entity and trackedTrinket.Location.Entity.Ref or nil
		local player = entity and entity:Exists() and entity:ToPlayer() or nil
		trackedTrinket.HudSprite = CreateTrinketSprite(id, player)
	end
	local sprite = trackedTrinket.HudSprite
	RenderTrinketHudSprite(id, sprite, trackedTrinket, pos, scale, crop, smelted)
end

local runningPreTrinketRender = false

mod:AddPriorityCallback(ModCallbacks.MC_PRE_PLAYERHUD_TRINKET_RENDER, -math.huge, function(_, slot, pos, scale, player, crop)
	if runningPreTrinketRender or slot < 0 or slot > 1 then return end

	local currentFrame = game:GetFrameCount()

	-- There's a small quirk where the trinket renders on the HUD for a frame or two after the player no longer has it.
	-- So I do a little funny business here.
	local pdata = GetTransientEntityData(player)
	if not pdata.LastSeenInSlotOnRender then
		pdata.LastSeenInSlotOnRender = {
			[0] = { Frame = currentFrame },
			[1] = { Frame = currentFrame },
		}
	end

	local trackedTrinket = mod.TrinketTracker:GetDataForPlayerSlot(player, slot)
	local lastSeenInfo = pdata.LastSeenInSlotOnRender[slot]
	local prevTrackedTrinket = lastSeenInfo.TrackedTrinket
	local currentTrinket = player:GetTrinket(slot)

	if (not prevTrackedTrinket or currentTrinket ~= 0) and lastSeenInfo.Frame < currentFrame then
		lastSeenInfo.TrackedTrinket = trackedTrinket
		lastSeenInfo.Frame = game:GetFrameCount()
	end

	trackedTrinket = trackedTrinket or prevTrackedTrinket

	if trackedTrinket and (trackedTrinket.Type == currentTrinket or currentTrinket == 0) then
		runningPreTrinketRender = true
		local result = Isaac.RunCallbackWithParam(ModCallbacks.MC_PRE_PLAYERHUD_TRINKET_RENDER, slot, slot, pos, scale, player, crop)
		runningPreTrinketRender = false

		if result == true then
			return true
		elseif result ~= nil and type(result) == "table" then
			pos = result.Position or pos
			scale = result.Scale or scale
			crop = result.CropOffset or crop
		end
		RenderTrackedTrinketHudSprite(trackedTrinket, pos, scale, crop)
		return true
	end
end)

local function SetSpriteVisible(sprite, visible)
	for _, layer in ipairs(sprite:GetAllLayers()) do
		layer:SetVisible(visible)
	end
end

mod:AddPriorityCallback(ModCallbacks.MC_PRE_PICKUP_RENDER, math.huge, function(_, pickup, renderOffset)
	local trackedTrinket = mod.TrinketTracker:GetDataForPickup(pickup)
	if pickup.Visible and trackedTrinket and not mod:GetEntityData(pickup).ReplacedByVeil then
		local sprite = pickup:GetSprite()
		local renderPos = Isaac.WorldToScreen(pickup.Position) + renderOffset - game:GetRoom():GetRenderScrollOffset()
		if Isaac.RunCallbackWithParam(mod.TrinketTracker.Callbacks.PRE_RENDER_TRINKET, pickup.SubType, sprite, renderPos, trackedTrinket) then
			trackedTrinket.SetVisible = true
			SetSpriteVisible(sprite, false)
		end
	end
end, PickupVariant.PICKUP_TRINKET)

mod:AddPriorityCallback(ModCallbacks.MC_POST_PICKUP_RENDER, -math.huge, function(_, pickup, renderOffset)
	local trackedTrinket = mod.TrinketTracker:GetDataForPickup(pickup)
	if trackedTrinket and trackedTrinket.SetVisible then
		trackedTrinket.SetVisible = nil
		SetSpriteVisible(pickup:GetSprite(), true)
	end
end, PickupVariant.PICKUP_TRINKET)

local function GetQueuedTrackedTrinketSprite(player)
	local sprite = player:GetHeldSprite()
	if player:IsHeldItemVisible() and player.QueuedItem.Item and player.QueuedItem.Item:IsTrinket() and sprite:GetFilename() ~= "gfx/items/pick ups/mystery_pickup.anm2" then
		local trackedTrinket = mod.TrinketTracker:GetDataForPlayerQueue(player)
		if trackedTrinket then
			return sprite, trackedTrinket
		end
	end
end

mod:AddPriorityCallback(ModCallbacks.MC_PRE_PLAYER_RENDER, math.huge, function(_, player, renderOffset)
	local sprite, trackedTrinket = GetQueuedTrackedTrinketSprite(player)
	if sprite and trackedTrinket then
		SetSpriteVisible(sprite, false)
	end
end)
mod:AddPriorityCallback(ModCallbacks.MC_POST_PLAYER_RENDER, -math.huge, function(_, player, renderOffset)
	local sprite, trackedTrinket = GetQueuedTrackedTrinketSprite(player)
	if sprite and trackedTrinket then
		SetSpriteVisible(sprite, true)
		local renderPos = Isaac.WorldToScreen(player.Position) + renderOffset + player:GetFlyingOffset() - game:GetRoom():GetRenderScrollOffset()
		if not Isaac.RunCallbackWithParam(mod.TrinketTracker.Callbacks.PRE_RENDER_TRINKET, trackedTrinket.Type, sprite, renderPos, trackedTrinket) then
			sprite:Render(renderPos)
		end
	end
end)

local smeltedTrinketsToRender = { [0]={}, [1]={} }
local smeltedTrackedTrinketIDs = { [0]={}, [1]={} }
local smeltedTrinketRenderFilter = {}
local smeltedTrinketSprites = {}

function mod:PostHistoryHudRecompute(historyhud, playeridx)
	-- Strawman+EsauJR nonsense. Will no longer be needed in a future rgon update.
	if playeridx < 0 or playeridx > 1 then return end

	smeltedTrinketsToRender[playeridx] = {}
	smeltedTrackedTrinketIDs[playeridx] = {}

	local player = historyhud:GetPlayer(playeridx)

	if player then
		local trackedSmeltedTrinkets = {}

		-- Collect all the tracked smelted trinkets from this player.
		local query = {
			[TrinketLocation.SMELTED] = {LocationVariants={GetEntityKey(player)}},
		}
		QueryTrackedTrinketsInternal(query, function(trackedTrinket)
			local cleanid = trackedTrinket.Type & TrinketType.TRINKET_ID_MASK
			local t = trackedTrinket.Location.Time
			table.insert(GetSubTable(trackedSmeltedTrinkets, cleanid, t), trackedTrinket)
			table.insert(smeltedTrackedTrinketIDs[playeridx], trackedTrinket.Type)
		end, true)

		-- Cross-reference the tracked trinkets with the trinkets in the HistoryHUD to find the ones we want to render.
		-- TODO: Add a "true" parameter to the GetTrinkets call after the bug with it has been fixed in rgon 1.1.2a
		for _, historyHudTrinket in ipairs(historyhud:GetTrinkets(playeridx, smeltedTrackedTrinketIDs[playeridx])) do
			local id = historyHudTrinket:GetItemID()
			local golden = id & TrinketType.TRINKET_GOLDEN_FLAG ~= 0
			local cleanid = id & TrinketType.TRINKET_ID_MASK
			local t = historyHudTrinket:GetTime()

			local trinketList = GetSubTableOrNil(trackedSmeltedTrinkets, cleanid, t)
			local toRenderList = GetSubTable(smeltedTrinketsToRender, playeridx, cleanid)

			if trinketList and trinketList[1] then
				table.insert(toRenderList, trinketList[1])
				table.remove(trinketList, 1)
			else
				-- Insert entries for non-tracked trinkets too
				table.insert(toRenderList, {Skip=true, Golden=golden})
			end
		end
	end

	-- Regenerate the filter set of trinket IDs to take over rendering of, and init any additional sprites needed.
	smeltedTrinketRenderFilter = {}
	local oldsprites = smeltedTrinketSprites
	smeltedTrinketSprites = {}

	local mergedTrinketIDs = {}
	for i = 0,1 do
		for _, id in ipairs(smeltedTrackedTrinketIDs[i]) do
			mergedTrinketIDs[id] = true
		end
	end
	for id, _ in pairs(mergedTrinketIDs) do
		table.insert(smeltedTrinketRenderFilter, id)
		smeltedTrinketSprites[id] = oldsprites[id] or CreateTrinketSprite(id, player)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_HISTORYHUD_RECOMPUTE, mod.PostHistoryHudRecompute)

-- On new room, clear any cached sprites for Modeling Clay and Error so that we can reset them.
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	QueryTrackedTrinketsInternal(nil, function(trackedTrinket)
		if trackedTrinket.Type == TrinketType.TRINKET_ERROR or trackedTrinket.Type == TrinketType.TRINKET_MODELING_CLAY then
			trackedTrinket.HudSprite = nil
		end
	end)
	smeltedTrinketSprites[TrinketType.TRINKET_ERROR] = nil
	smeltedTrinketSprites[TrinketType.TRINKET_MODELING_CLAY] = nil
end)

-- Prevent rendering any trinkets that we are tracking so we can render them ourselves.
mod:AddCallback(ModCallbacks.MC_PRE_HISTORYHUD_RENDER, function()
	if #smeltedTrinketRenderFilter > 0 then
		return {
			HideTrinkets = smeltedTrinketRenderFilter,
		}
	end
end)

-- Render the smelted sprites for tracked trinkets.
mod:AddCallback(ModCallbacks.MC_POST_HISTORYHUD_RENDER, function(_, historyhud, historyhudpos)
	for playeridx = 0,1 do
		for id, trinkets in pairs(smeltedTrinketsToRender[playeridx]) do
			local scale = (Options.ExtraHUDStyle == 2) and 0.5 or 1
			for i, offset in ipairs(historyhud:GetTrinketOffsets(playeridx, id)) do
				local renderpos = historyhudpos + offset
				local trinket = trinkets[i]
				if trinket and not trinket.Skip then
					RenderTrackedTrinketHudSprite(trinket, renderpos, scale, Vector.Zero, true)
				elseif smeltedTrinketSprites[id] then
					local golden = trinket and trinket.Golden
					RenderTrinketHudSprite(golden and (id | TrinketType.TRINKET_GOLDEN_FLAG) or id, smeltedTrinketSprites[id], nil, renderpos, scale, Vector.Zero, true)
				end
			end
		end
	end
end)

function mod:RefreshHistoryHUD()
	local historyhud = game:GetHUD():GetHistoryHUD()
	for i=0,1 do
		mod:PostHistoryHudRecompute(historyhud, i)
	end
end

-- Refresh the HistoryHUD data on luamod
if Isaac.IsInGame() then
	mod:RefreshHistoryHUD()
end
