local mod = FiendFolio
local game = Game()

local defaultData = {
	Events = {},
	EnemyPools = {["0"] = {}, ["1"] = {}, ["2"] = {}, ["3"] = {}},
	AllEntitiesEvents = {["0"] = false, ["1"] = false, ["2"] = false, ["3"] = false},
	RoomInitEntities = {},
}

mod.EnemyEventRoomData = TearFlagsLib.CopyTable(defaultData)

function mod.TriggerEvent(id)
	local room = game:GetRoom()
	local pos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 0, false, false)
	local tile = room:GetGridIndex(pos)

	room:SpawnGridEntity(tile, 20, 10 + id, 0, 0)
	local button = room:GetGridEntity(tile)

	local sprite = button:GetSprite()
	sprite:ReplaceSpritesheet(0, "")
	sprite:LoadGraphics()

	button:ToPressurePlate():Reward()
	room:RemoveGridEntity(tile, 0, false)
end

mod.EnemyTriggerHostBlacklist = {}
function mod.BlacklistEntityFromEnemyTrigger(t, v, s)
	t, v, s = tostring(t), tostring(v or -1), tostring(s or -1)

	mod.EnemyTriggerHostBlacklist[t] = mod.EnemyTriggerHostBlacklist[t] or {}
	mod.EnemyTriggerHostBlacklist[t][v] = mod.EnemyTriggerHostBlacklist[t][v] or {}
	mod.EnemyTriggerHostBlacklist[t][v][s] = true
end

local function isEntityDead(entity)
	return (
		entity:IsDead() or
		mod:isStatusCorpse(entity) or
		game:IsErased(entity) or
		not entity:Exists()
	)
end

local function isEntityBlacklisted(entity)
	local t, v, s = tostring(entity.Type), tostring(entity.Variant), tostring(entity.SubType)

	return StageAPI.IsMetadataEntity(t, v) or (mod.EnemyTriggerHostBlacklist[t] and (
		(
			mod.EnemyTriggerHostBlacklist[t][v] and (
				mod.EnemyTriggerHostBlacklist[t][v][s] or
				mod.EnemyTriggerHostBlacklist[t][v]["-1"]
			)
		) or mod.EnemyTriggerHostBlacklist[t]["-1"]
	))
end

local function isEntityBlacklistedEx(t, v, s)
	return StageAPI.IsMetadataEntity(t, v) or (mod.EnemyTriggerHostBlacklist[t] and (
		(
			mod.EnemyTriggerHostBlacklist[t][v] and (
				mod.EnemyTriggerHostBlacklist[t][v][s] or
				mod.EnemyTriggerHostBlacklist[t][v]["-1"]
			)
		) or mod.EnemyTriggerHostBlacklist[t]["-1"]
	))
end

local function canEntityBeTargeted(entity, ignoreDeath)
	return (
		entity:IsEnemy() and
		(ignoreDeath or not isEntityDead(entity)) and
		not entity:HasEntityFlags(EntityFlag.FLAG_PERSISTENT) and
		not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and
		not isEntityBlacklisted(entity)
	)
end

mod:AddCallback(ModCallbacks.MC_PRE_NEW_ROOM, function(_, room, roomDesc)
	mod.EnemyEventRoomData = TearFlagsLib.CopyTable(defaultData)
	mod:DisableManualCallback(ModCallbacks.MC_POST_UPDATE, mod.WatchEnemyEvents)
	mod:DisableManualCallback(ModCallbacks.MC_POST_UPDATE, mod.WatchEnemyEventsAllEnemies)
end)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, effect)
	if effect.SubType >= 10 then
		mod.EnemyEventRoomData.AllEntitiesEvents[tostring(effect.SubType % 10)] = true
		mod:EnableManualCallback(ModCallbacks.MC_POST_UPDATE, mod.WatchEnemyEventsAllEnemies)
	else
		table.insert(mod.EnemyEventRoomData.Events, {
			Group = effect.SubType,
			Position = effect.Position,
		})

		mod:EnableManualCallback(ModCallbacks.MC_POST_UPDATE, mod.WatchEnemyEvents)
	end

	effect:Remove()
end, mod.FF.CustomEventTrigger.Var)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	if #mod.EnemyEventRoomData.Events == 0 then return end

	for _, event in pairs(mod.EnemyEventRoomData.Events) do
		local dist = 9e9
		local closest = nil

		-- for _, entity in pairs(targets) do
		for i = #mod.EnemyEventRoomData.RoomInitEntities, 1, -1 do
			local entity = mod.EnemyEventRoomData.RoomInitEntities[i]
			if entity.Position:DistanceSquared(event.Position) < dist then
				dist = entity.Position:DistanceSquared(event.Position)
				closest = entity
			end
		end

		if closest then
			table.insert(mod.EnemyEventRoomData.EnemyPools[tostring(event.Group)], closest)
			mod.EnemyEventRoomData.EnemyPools[tostring(event.Group)].Watch = true
		end
	end
end)

function mod.WatchEnemyEvents()
	local watchingAny = false

	for i = 0, 3 do
		local key = tostring(i)
		if mod.EnemyEventRoomData.EnemyPools[key].Watch then
			watchingAny = true

			for j = #mod.EnemyEventRoomData.EnemyPools[key], 1, -1 do
				local test = mod.EnemyEventRoomData.EnemyPools[key][j]
				if not canEntityBeTargeted(test) then
					table.remove(mod.EnemyEventRoomData.EnemyPools[key], j)
				end
			end			

			if #mod.EnemyEventRoomData.EnemyPools[key] == 0 then
				mod.TriggerEvent(i)
				mod.EnemyEventRoomData.EnemyPools[key].Watch = false
			end
		end
	end

	if not watchingAny then
		mod:DisableManualCallback(ModCallbacks.MC_POST_UPDATE, mod.WatchEnemyEvents)
	end
end

function mod.WatchEnemyEventsAllEnemies()
	local found = false
	TearFlagsLib.ForAllEntities(function(entity)
		if canEntityBeTargeted(entity) then
			found = true
		end
	end)

	if not found then
		for i = 0, 3 do
			if mod.EnemyEventRoomData.AllEntitiesEvents[tostring(i)] then
				mod.TriggerEvent(i)
			end
		end

		mod:DisableManualCallback(ModCallbacks.MC_POST_UPDATE, mod.WatchEnemyEventsAllEnemies)
	end
end

mod:AddManualCallback(ModCallbacks.MC_POST_UPDATE, mod.WatchEnemyEvents)
mod:AddManualCallback(ModCallbacks.MC_POST_UPDATE, mod.WatchEnemyEventsAllEnemies)

mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, npc)
	if canEntityBeTargeted(npc, true) then
		table.insert(mod.EnemyEventRoomData.RoomInitEntities, npc)
	end
end)