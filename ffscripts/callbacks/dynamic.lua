-- Dynamic Callbacks --

--local mod = FiendFolio
local game = Game()

-- Callback that can be manually enabled/disabled
-------------------------------------------------------------------
-- FiendFolio:AddManualCallback(callbackId, func, optional)
-- FiendFolio:AddPriorityManualCallback(callbackId, priority, func, optional)
-- FiendFolio:EnableManualCallback(callbackId, func)
-- FiendFolio:DisableManualCallback(callbackId, func)

-- Callback that is ran only if a specific entity is in the room
---------------------------------------------------------------------------------
-- FiendFolio:AddEntityCallback(callbackId, typ, var, sub, func, optional)
-- FiendFolio:AddPriorityEntityCallback(callbackId, priority, typ, var, sub, func, optional)

-- Callback that is ran only if players have a specific collectible
-------------------------------------------------------------------------------------
-- FiendFolio:AddCollectibleCallback(callbackId, collectibleId, func, optional)
-- FiendFolio:AddPriorityCollectibleCallback(callbackId, priority, collectibleId, func, optional)

-- Callback that is ran only if players have a specific trinket
-----------------------------------------------------------------------------
-- FiendFolio:AddTrinketCallback(callbackId, trinketId, func, optional)
-- FiendFolio:AddPriorityTrinketCallback(callbackId, priority, trinketId, func, optional)

-- Callback that is ran only if players have a specific temporary effect
-----------------------------------------------------------------------------
-- FiendFolio:AddPlayerTempEffectCallback(callbackId, itemConfigItem, func, optional)
-- FiendFolio:AddPriorityPlayerTempEffectCallback(callbackId, priority, itemConfigItem, func, optional)

-- Callback that is ran only within a specific challenge
-----------------------------------------------------------------------------
-- FiendFolio:AddChallengeCallback(callbackId, challenge, func, optional)
-- FiendFolio:AddPriorityChallengeCallback(callbackId, priority, challenge, func, optional)

-- (Bonus Helper) Callback that only runs one time and removes itself, with an optional frame delay
-----------------------------------------------------------------------------
-- FiendFolio:AddOneTimeCallback(callbackId, func, optional, frameDelay)
-- FiendFolio:AddOneTimePriorityCallback(callbackId, priority, func, optional, frameDelay)

-- (Bonus Helper) Adds a callback twice: Once for the base trinket ID and once for the golden ID
-----------------------------------------------------------------------------
-- FiendFolio:AddCallbackWithTrinketParam(callbackId, func, trinketId)
-- FiendFolio:AddPriorityCallbackWithTrinketParam(callbackId, priority, func, trinketId)

FiendFolio.DebugDynamicCallbacks = FiendFolio.DebugDynamicCallbacks or false

FiendFolio:AddCallback(ModCallbacks.MC_EXECUTE_CMD, function(_, cmd, params)
	if cmd == "debugffdynamic" then
		FiendFolio.DebugDynamicCallbacks = not FiendFolio.DebugDynamicCallbacks
		print("[FF] Dynamic callback debug printing is now " .. (FiendFolio.DebugDynamicCallbacks and "ENABLED" or "DISABLED"))
	end
end)

---------------------
-- Callback basics --
---------------------
local baseCreated = {}
local loadedCallbacks = {}

-- Isaac.RunCallbackOverIterator expects an iterator that only returns the callback, no keys.
-- Otherwise, this iterator is equivalent to `pairs`.
local function GetCallbackIterator(callbackId, priority, optional)
	local t = loadedCallbacks[callbackId][priority][optional or "nil"]
	local k = nil
	return function()
		local v
		k, v = next(t, k)
		return v
	end
end

-- Runs the callback with the default logic, automatically including any custom logic implemented by REPENTOGON.
function FiendFolio.CreateDefaultBaseCallback(callbackId, priority, optional)
	FiendFolio:AddPriorityCallback(callbackId, priority, function(_, ...)
		local callbackIterator = GetCallbackIterator(callbackId, priority, optional)
		return Isaac.RunCallbackOverIterator(callbackId, callbackIterator, ...)
	end, optional)
end

-- REPENTOGON's pre-entity-render callbacks are odd in that the returned value adds to the current offset rather than replacing it.
-- So we need to handle that a little differently here and only return the total offset.
function FiendFolio.CreatePreRenderBaseCallback(callbackId, priority, optional)
	FiendFolio:AddPriorityCallback(callbackId, priority, function(mod, entity, value, ...)
		local addedValue = Vector(0,0)
		for callback in GetCallbackIterator(callbackId, priority, optional) do
			local ret = callback.Function(mod, entity, value + addedValue, ...)
			if ret ~= nil then
				if type(ret) == "boolean" and ret == false then
					return false
				elseif ret.X and ret.Y then
					addedValue = addedValue + ret
				end
			end
		end
		return addedValue
	end, optional)
end

function FiendFolio.CreateAdditiveFifthArgBaseCallback(callbackId, priority, optional)
	FiendFolio:AddPriorityCallback(callbackId, priority, function(mod, arg1, arg2, arg3, arg4, value, ...)
		for callback in GetCallbackIterator(callbackId, priority, optional) do
			local ret = callback.Function(mod, arg1, arg2, arg3, arg4, value, ...)
			if ret ~= nil then
				value = ret
			end
		end
		return value
	end, optional)
end

function FiendFolio.CreateCHAPIBaseCallback(callbackId, priority, optional)
	if not CustomHealthAPI.Enums.RunCallbackFuncs[callbackId] then return end
	FiendFolio:AddPriorityCallback(callbackId, priority, function(_, ...)
		local callbackIterator = GetCallbackIterator(callbackId, priority, optional)
		return CustomHealthAPI.Enums.RunCallbackFuncs[callbackId](callbackIterator, ...)
	end, optional)
end

-- Allows defining custom run logic for particular callbacks, such as for modded callbacks.
-- If not specified here, the default RunCallback logic will be used (including custom logic implemented by REPENTOGON).
local BaseCallbackLogic = {
	-- Basegame and RGON
	[ModCallbacks.MC_PRE_FAMILIAR_RENDER or {}] = FiendFolio.CreatePreRenderBaseCallback,
	[ModCallbacks.MC_PRE_NPC_RENDER or {}] = FiendFolio.CreatePreRenderBaseCallback,
	[ModCallbacks.MC_PRE_PLAYER_RENDER or {}] = FiendFolio.CreatePreRenderBaseCallback,
	[ModCallbacks.MC_PRE_PICKUP_RENDER or {}] = FiendFolio.CreatePreRenderBaseCallback,
	[ModCallbacks.MC_PRE_TEAR_RENDER or {}] = FiendFolio.CreatePreRenderBaseCallback,
	[ModCallbacks.MC_PRE_PROJECTILE_RENDER or {}] = FiendFolio.CreatePreRenderBaseCallback,
	[ModCallbacks.MC_PRE_KNIFE_RENDER or {}] = FiendFolio.CreatePreRenderBaseCallback,
	[ModCallbacks.MC_PRE_EFFECT_RENDER or {}] = FiendFolio.CreatePreRenderBaseCallback,
	[ModCallbacks.MC_PRE_BOMB_RENDER or {}] = FiendFolio.CreatePreRenderBaseCallback,
	[ModCallbacks.MC_PRE_SLOT_RENDER or {}] = FiendFolio.CreatePreRenderBaseCallback,
	
	-- FF
	[FiendFolio.CALLBACK.FF_SECONDARY_FIRE_TEAR_EFFECTS or {}] = FiendFolio.CreateAdditiveFifthArgBaseCallback,
	
	-- CHAPI
	[CustomHealthAPI.Enums.Callbacks.PRE_RENDER_HOLY_MANTLE or {}] = FiendFolio.CreateCHAPIBaseCallback,
	[CustomHealthAPI.Enums.Callbacks.PRE_ADD_HEALTH or {}] = FiendFolio.CreateCHAPIBaseCallback,
	[CustomHealthAPI.Enums.Callbacks.GET_ALABASTER_BOX_OWNER or {}] = FiendFolio.CreateCHAPIBaseCallback,
	[CustomHealthAPI.Enums.Callbacks.PRE_YUM_HEART_HEAL or {}] = FiendFolio.CreateCHAPIBaseCallback,
	[CustomHealthAPI.Enums.Callbacks.PRE_PLAYER_DAMAGE or {}] = FiendFolio.CreateCHAPIBaseCallback,
	[CustomHealthAPI.Enums.Callbacks.PRE_NOKILL_HEAL or {}] = FiendFolio.CreateCHAPIBaseCallback,
	[CustomHealthAPI.Enums.Callbacks.PRE_HEARTBREAK_HEAL or {}] = FiendFolio.CreateCHAPIBaseCallback,
	[CustomHealthAPI.Enums.Callbacks.PRE_SPIRIT_SHACKLES_HEAL or {}] = FiendFolio.CreateCHAPIBaseCallback,
	[CustomHealthAPI.Enums.Callbacks.PRE_GLASS_CANNON_HEAL or {}] = FiendFolio.CreateCHAPIBaseCallback,
	[CustomHealthAPI.Enums.Callbacks.PRE_ETERNAL_HEAL or {}] = FiendFolio.CreateCHAPIBaseCallback,
	[CustomHealthAPI.Enums.Callbacks.PRE_HEALTH_DAMAGED or {}] = FiendFolio.CreateCHAPIBaseCallback,
	[CustomHealthAPI.Enums.Callbacks.PRE_HEALTH_RENDER or {}] = FiendFolio.CreateCHAPIBaseCallback,
	[CustomHealthAPI.Enums.Callbacks.PRE_RENDER_HEARTS or {}] = FiendFolio.CreateCHAPIBaseCallback,
	[CustomHealthAPI.Enums.Callbacks.PRE_RENDER_UNKNOWN_CURSE or {}] = FiendFolio.CreateCHAPIBaseCallback,
	[CustomHealthAPI.Enums.Callbacks.PRE_AFTER_HEALTH_ICON_RENDER or {}] = FiendFolio.CreateCHAPIBaseCallback,
	[CustomHealthAPI.Enums.Callbacks.PRE_RENDER_LIVES or {}] = FiendFolio.CreateCHAPIBaseCallback,
	[CustomHealthAPI.Enums.Callbacks.PRE_BELOW_HEALTH_ICON_RENDER or {}] = FiendFolio.CreateCHAPIBaseCallback,
	[CustomHealthAPI.Enums.Callbacks.PRE_RENDER_HP_BAR or {}] = FiendFolio.CreateCHAPIBaseCallback,
	[CustomHealthAPI.Enums.Callbacks.PRE_SUMPTORIUM_CLOT_INIT or {}] = FiendFolio.CreateCHAPIBaseCallback,
}

function FiendFolio:TryCreateBaseCallback(callbackId, priority, optional)
	if not (baseCreated[callbackId] and baseCreated[callbackId][priority] and baseCreated[callbackId][priority][optional or "nil"]) then
		loadedCallbacks[callbackId] = loadedCallbacks[callbackId] or {}
		loadedCallbacks[callbackId][priority] = loadedCallbacks[callbackId][priority] or {}
		loadedCallbacks[callbackId][priority][optional or "nil"] = loadedCallbacks[callbackId][priority][optional or "nil"] or {}

		local baseCallbackLogic = BaseCallbackLogic[callbackId] or FiendFolio.CreateDefaultBaseCallback
		baseCallbackLogic(callbackId, priority, optional)

		baseCreated[callbackId] = baseCreated[callbackId] or {}
		baseCreated[callbackId][priority] = baseCreated[callbackId][priority] or {}
		baseCreated[callbackId][priority][optional or "nil"] = true
	end
end

-- For debug logging
local callbackIDToName = nil

local dynamicCallbacks = {}

local function RegisterDynamicCallback(callbackId, priority, optional, func)
	if not dynamicCallbacks[callbackId] then
		dynamicCallbacks[callbackId] = {}
	end
	if not dynamicCallbacks[callbackId][priority] then
		dynamicCallbacks[callbackId][priority] = {}
	end
	if not dynamicCallbacks[callbackId][priority][optional or "nil"] then
		dynamicCallbacks[callbackId][priority][optional or "nil"] = {}
	end
	local callback = dynamicCallbacks[callbackId][priority][optional or "nil"][func]
	if not callback then
		callback = {
			Mod = FiendFolio,
			Function = func,
			ID = callbackId,
			Priority = priority,
			Optional = optional,
			Collectibles = {},
			Trinkets = {},
			Effects = {},
			Entities = {},
			Challenges = {},
			ShouldBeLoaded = function(self)
				for _, collectibleId in ipairs(self.Collectibles) do
					if PlayerManager.AnyoneHasCollectible(collectibleId) then
						return true
					end
				end
				for _, trinketId in ipairs(self.Trinkets) do
					if PlayerManager.AnyoneHasTrinket(trinketId) then
						return true
					end
				end
				for _, item in ipairs(self.Effects) do
					if FiendFolio:AnyoneHasTempEffect(item) then
						return true
					end
				end
				for _, entity in ipairs(self.Entities) do
					if Isaac.CountEntities(nil, entity.Type, entity.Variant, entity.SubType) > 0 then
						return true
					end
				end
				if #self.Challenges > 0 then
					local currentChallenge = game.Challenge
					for _, challenge in ipairs(self.Challenges) do
						if challenge == currentChallenge then
							return true
						end
					end
				end
				return false
			end,
			DebugString = function(self)
				if not callbackIDToName then
					callbackIDToName = {}
					for k, v in pairs(ModCallbacks) do
						callbackIDToName[v] = k
					end
				end
				local strs = {}
				for _, collectibleId in ipairs(self.Collectibles) do
					table.insert(strs, "(Collectible#"..collectibleId..") " .. Isaac.GetItemConfig():GetCollectible(collectibleId).Name)
				end
				for _, trinketId in ipairs(self.Trinkets) do
					table.insert(strs, "(Trinket#"..trinketId..") " .. Isaac.GetItemConfig():GetTrinket(trinketId).Name)
				end
				for _, item in ipairs(self.Effects) do
					if item:IsNull() then
						table.insert(strs, "(NullItem#" .. item.ID .. ") " .. item.Name)
					elseif item:IsTrinket() then
						table.insert(strs, "(TrinketEffect#" .. item.ID .. ") " .. item.Name)
					elseif item:IsCollectible() then
						table.insert(strs, "(CollectibleEffect#" .. item.ID .. ") " .. item.Name)
					end
				end
				for _, entity in ipairs(self.Entities) do
					table.insert(strs, "(Entity#" .. entity.Type .. "." .. (entity.Variant or "X") .. "." .. (entity.SubType or "X") .. ") " .. EntityConfig.GetEntity(entity.Type, entity.Variant, entity.SubType):GetName())
				end
				for _, challenge in ipairs(self.Challenges) do
					local xml = XMLData.GetEntryById(XMLNode.CHALLENGE, challenge)
					table.insert(strs, "(Challenge#" .. challenge .. ") " .. (xml and xml.name or "???"))
				end
				return (callbackIDToName[callbackId] or callbackId) .. " for " .. table.concat(strs, ", ")
			end,
		}
		dynamicCallbacks[callbackId][priority][optional or "nil"][func] = callback
	end
	return callback
end

function FiendFolio:LoadDynamicCallback(callback)
	local callbackId = callback.ID
	local priority = callback.Priority
	local optional = callback.Optional or "nil"
	for _, loaded in pairs(loadedCallbacks[callbackId][priority][optional]) do
		if loaded.Function == callback.Function then
			return
		end
	end
	table.insert(loadedCallbacks[callbackId][priority][optional], callback)
	if FiendFolio.DebugDynamicCallbacks and callback.DebugString then
		print("[FF_DYNAMIC] Loaded: " .. callback:DebugString())
	end
end

function FiendFolio:UnloadDynamicCallback(callback)
	local callbackId = callback.ID
	local priority = callback.Priority
	local optional = callback.Optional or "nil"
	for i, loaded in pairs(loadedCallbacks[callbackId][priority][optional]) do
		if loaded.Function == callback.Function then
			table.remove(loadedCallbacks[callbackId][priority][optional], i)
			if FiendFolio.DebugDynamicCallbacks and callback.DebugString then
				print("[FF_DYNAMIC] Unloaded: " .. callback:DebugString())
			end
			return
		end
	end
end

function FiendFolio:TryUnloadDynamicCallback(callback)
	if not callback.ShouldBeLoaded or not callback:ShouldBeLoaded() then
		FiendFolio:UnloadDynamicCallback(callback)
	end
end

function FiendFolio:UnloadAllDynamicCallbacks()
	for _, byCallbackId in pairs(dynamicCallbacks) do
		for _, byPriority in pairs(byCallbackId) do
			for _, byOptional in pairs(byPriority) do
				for _, callback in pairs(byOptional) do
					FiendFolio:UnloadDynamicCallback(callback)
				end
			end
		end
	end
	FiendFolio:ClearDynamicModelingClayEffects()
	FiendFolio:SetDynamicErrorTrinketEffect(nil)
end

function FiendFolio:ReloadAllDynamicCallbacks()
	for _, byCallbackId in pairs(dynamicCallbacks) do
		for _, byPriority in pairs(byCallbackId) do
			for _, byOptional in pairs(byPriority) do
				for _, callback in pairs(byOptional) do
					if callback:ShouldBeLoaded() then
						FiendFolio:LoadDynamicCallback(callback)
					else
						FiendFolio:UnloadDynamicCallback(callback)
					end
				end
			end
		end
	end
	FiendFolio:RefreshDynamicModelingClayEffects(true)
	FiendFolio:SetDynamicErrorTrinketEffect(FiendFolio:GetErrorTrinketEffect())
end

local hadCurseMist = false

FiendFolio:AddPriorityCallback(ModCallbacks.MC_PRE_GAME_EXIT, math.huge, function()
	FiendFolio:UnloadAllDynamicCallbacks()
	hadCurseMist = false
end)

FiendFolio:AddPriorityCallback(ModCallbacks.MC_PRE_ROOM_EXIT, -1 * math.huge, function()
	hadCurseMist = game:GetRoom():HasCurseMist()
end)

FiendFolio:AddPriorityCallback(ModCallbacks.MC_PRE_NEW_ROOM, -1 * math.huge, function()
	FiendFolio:ReloadAllDynamicCallbacks()
end)

FiendFolio:AddPriorityCallback(ModCallbacks.MC_POST_NEW_ROOM, -1 * math.huge, function()
	local hasCurseMist = game:GetRoom():HasCurseMist()
	if hadCurseMist ~= hasCurseMist then
		if not hasCurseMist then
			-- removing curse mist earlier than usual to allow collectible/trinket callbacks to reload properly
			for _, player in ipairs(PlayerManager.GetPlayers()) do
				player:RemoveCurseMistEffect()
			end
		end

		FiendFolio:ReloadAllDynamicCallbacks()
	end
end)

FiendFolio:AddPriorityCallback(ModCallbacks.MC_USE_ITEM, -math.huge, function()
	FiendFolio:ReloadAllDynamicCallbacks()
end, CollectibleType.COLLECTIBLE_FLIP)

FiendFolio:AddPriorityCallback(ModCallbacks.MC_POST_DISCHARGE_ACTIVE_ITEM, -math.huge, function()
	FiendFolio:ReloadAllDynamicCallbacks()
end, CollectibleType.COLLECTIBLE_ESAU_JR)

-------------
-- Helpers --
-------------

local function TriggerItemCache(player, item)
	if item then
		player:AddCustomCacheTag(item:GetCustomCacheTags())
		player:AddCacheFlags(item.CacheFlags, true)
	end
end

-- Adds a callback twice, once with the clean trinket ID and again with the golden trinket ID.
-- For convenience when using callbacks that take a TrinketType as their optional param.
function FiendFolio:AddPriorityCallbackWithTrinketParam(callbackid, priority, func, trinketId)
	local cleanId = trinketId & TrinketType.TRINKET_ID_MASK
	local goldId = cleanId | TrinketType.TRINKET_GOLDEN_FLAG
	FiendFolio:AddPriorityCallback(callbackid, priority, func, cleanId)
	FiendFolio:AddPriorityCallback(callbackid, priority, func, goldId)
end

function FiendFolio:AddCallbackWithTrinketParam(callbackid, func, trinketId)
	FiendFolio:AddPriorityCallbackWithTrinketParam(callbackid, CallbackPriority.DEFAULT, func, trinketId)
end

function FiendFolio:AddOneTimePriorityCallback(callbackid, priority, func, optional, frameDelay)
	local wrapper
	if frameDelay then
		local targetFrame = game:GetFrameCount() + frameDelay
		wrapper = function(...)
			if game:GetFrameCount() >= targetFrame then
				FiendFolio:RemoveCallback(callbackid, wrapper)
				return func(...)
			end
		end
	else
		wrapper = function(...)
			FiendFolio:RemoveCallback(callbackid, wrapper)
			return func(...)
		end
	end
	FiendFolio:AddPriorityCallback(callbackid, priority, wrapper)
end

function FiendFolio:AddOneTimeCallback(callbackid, func, optional, frameDelay)
	FiendFolio:AddOneTimePriorityCallback(callbackid, CallbackPriority.DEFAULT, func, optional, frameDelay)
end

--------------------------------
-- Manually enabled callbacks --
--------------------------------
local manualCallbacks = {}

function FiendFolio:AddManualCallback(callbackId, func, optional)
	FiendFolio:AddPriorityManualCallback(callbackId, CallbackPriority.DEFAULT, func, optional)
end

function FiendFolio:AddPriorityManualCallback(callbackId, priority, func, optional)
	FiendFolio:TryCreateBaseCallback(callbackId, priority, optional)
	
	local callback = {Mod = FiendFolio, Function = func, ID = callbackId, Priority = priority, Optional = optional}
	manualCallbacks[callbackId] = manualCallbacks[callbackId] or {}
	table.insert(manualCallbacks[callbackId], callback)
end

function FiendFolio:EnableManualCallback(callbackId, func)
	for _, callback in pairs(manualCallbacks[callbackId] or {}) do
		if callback.Function == func then
			FiendFolio:LoadDynamicCallback(callback)
		end
	end
end

function FiendFolio:DisableManualCallback(callbackId, func)
	for _, callback in pairs(manualCallbacks[callbackId] or {}) do
		if callback.Function == func then
			FiendFolio:UnloadDynamicCallback(callback)
		end
	end
end

----------------------
-- Entity callbacks --
----------------------
local initFromType = {
	[EntityType.ENTITY_FAMILIAR] = ModCallbacks.MC_FAMILIAR_INIT,
	[EntityType.ENTITY_PLAYER] = ModCallbacks.MC_POST_PLAYER_INIT,
	[EntityType.ENTITY_PICKUP] = ModCallbacks.MC_POST_PICKUP_INIT,
	[EntityType.ENTITY_TEAR] = ModCallbacks.MC_POST_TEAR_INIT,
	[EntityType.ENTITY_PROJECTILE] = ModCallbacks.MC_POST_PROJECTILE_INIT,
	[EntityType.ENTITY_LASER] = ModCallbacks.MC_POST_LASER_INIT,
	[EntityType.ENTITY_KNIFE] = ModCallbacks.MC_POST_KNIFE_INIT,
	[EntityType.ENTITY_EFFECT] = ModCallbacks.MC_POST_EFFECT_INIT,
	[EntityType.ENTITY_BOMB] = ModCallbacks.MC_POST_BOMB_INIT,
	[EntityType.ENTITY_SLOT] = ModCallbacks.MC_POST_SLOT_INIT,
}

function FiendFolio:AddEntityCallback(callbackId, typ, var, subt, func, optional)
	FiendFolio:AddPriorityEntityCallback(callbackId, CallbackPriority.DEFAULT, typ, var, subt, func, optional)
end

function FiendFolio:AddPriorityEntityCallback(callbackId, priority, typ, var, subt, func, optional)
	local typ = (typ ~= nil and typ >= 0 and typ) or nil
	local var = (var ~= nil and var >= 0 and var) or nil
	local subt = (subt ~= nil and subt >= 0 and subt) or nil

	FiendFolio:TryCreateBaseCallback(callbackId, priority, optional)

	local callback = RegisterDynamicCallback(callbackId, priority, optional, func)
	table.insert(callback.Entities, {Type = typ, Variant = var, SubType = subt})

	FiendFolio:CreateEntityCallbackLoader(callback, typ, var, subt)
	FiendFolio:CreateEntityCallbackUnloader(callback, typ, var, subt)
end

function FiendFolio:CreateEntityCallbackLoader(callback, typ, var, subt)
	local callbackId = initFromType[typ] or ModCallbacks.MC_POST_NPC_INIT
	if callbackId == ModCallbacks.MC_FAMILIAR_INIT or
	   callbackId == ModCallbacks.MC_POST_PLAYER_INIT or
	   callbackId == ModCallbacks.MC_POST_PICKUP_INIT or
	   callbackId == ModCallbacks.MC_POST_TEAR_INIT or
	   callbackId == ModCallbacks.MC_POST_PROJECTILE_INIT or
	   callbackId == ModCallbacks.MC_POST_LASER_INIT or
	   callbackId == ModCallbacks.MC_POST_EFFECT_INIT or
	   callbackId == ModCallbacks.MC_POST_BOMB_INIT or
	   callbackId == ModCallbacks.MC_POST_SLOT_INIT
	then
		FiendFolio:AddCallback(callbackId, function(_, entity)
			if subt == nil or subt == entity.SubType then
				FiendFolio:LoadDynamicCallback(callback)
			end
		end, var)

		if typ == EntityType.ENTITY_PICKUP then
			FiendFolio:AddCallback(ModCallbacks.MC_POST_PICKUP_MORPH, function(_, entity)
				if typ == entity.Type and
				   (var == nil or var == entity.Variant) and
				   (subt == nil or subt == entity.SubType)
				then
					FiendFolio:LoadDynamicCallback(callback)
				end
			end)
		end
	elseif callbackId == ModCallbacks.MC_POST_NPC_INIT then
		FiendFolio:AddCallback(callbackId, function(_, entity)
			if (var == nil or var == entity.Variant) and
			   (subt == nil or subt == entity.SubType)
			then
				FiendFolio:LoadDynamicCallback(callback)
			end
		end, typ)

		FiendFolio:AddCallback(ModCallbacks.MC_POST_NPC_MORPH, function(_, entity)
			if typ == entity.Type and
			   (var == nil or var == entity.Variant) and
			   (subt == nil or subt == entity.SubType)
			then
				FiendFolio:LoadDynamicCallback(callback)
			end
		end)
	elseif callbackId == ModCallbacks.MC_POST_KNIFE_INIT then
		FiendFolio:AddCallback(callbackId, function(_, entity)
			if var == nil or var == entity.Variant then
				FiendFolio:LoadDynamicCallback(callback)
			end
		end, subt)
	end
end

function FiendFolio:CreateEntityCallbackUnloader(callback, typ, var, subt)
	FiendFolio:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, entity)
		if (var == nil or var == entity.Variant) and
		   (subt == nil or subt == entity.SubType)
		then
			-- Need to delay since Isaac.CountEntities still counts removed entities.
			FiendFolio:AddOneTimeCallback(ModCallbacks.MC_POST_UPDATE, function()
				FiendFolio:TryUnloadDynamicCallback(callback)
			end, nil, 1)
		end
	end, typ)

	if typ == EntityType.ENTITY_PICKUP then
		FiendFolio:AddCallback(ModCallbacks.MC_POST_PICKUP_MORPH, function(_, pickup, prevType, prevVar, prevSub)
			if typ == prevType and
			   (var == nil or var == prevVar) and
			   (subt == nil or subt == prevSub)
			then
				FiendFolio:TryUnloadDynamicCallback(callback)
			end
		end)
	elseif typ >= EntityType.ENTITY_GAPER and typ < EntityType.ENTITY_EFFECT then
		FiendFolio:AddCallback(ModCallbacks.MC_POST_NPC_MORPH, function(_, npc, prevType, prevVar, prevSub)
			if typ == prevType and
			   (var == nil or var == prevVar) and
			   (subt == nil or subt == prevSub)
			then
				FiendFolio:TryUnloadDynamicCallback(callback)
			end
		end)
	end
end

---------------------------
-- Collectible callbacks --
---------------------------

-- Map of CollectibleType->ItemConfigItem for collectibles with dynamic callbacks added for MC_EVALUATE_CACHE/STAT/CUSTOM_CACHE.
-- In certain cases (such as innates) we will miss the usual cache eval before we can enable the dynamic callbacks, and need to trigger another.
local evaluateCacheCollectibles = {}

local function MaybeTriggerCollectibleCache(player, collectibleId)
	if evaluateCacheCollectibles[collectibleId] then
		TriggerItemCache(player, evaluateCacheCollectibles[collectibleId])
	end
end

function FiendFolio:AddCollectibleCallback(callbackId, collectibleId, func, optional)
	FiendFolio:AddPriorityCollectibleCallback(callbackId, CallbackPriority.DEFAULT, collectibleId, func, optional)
end

function FiendFolio:AddPriorityCollectibleCallback(callbackId, priority, collectibleId, func, optional)
	FiendFolio:TryCreateBaseCallback(callbackId, priority, optional)

	local callback = RegisterDynamicCallback(callbackId, priority, optional, func)
	table.insert(callback.Collectibles, collectibleId)

	FiendFolio:CreateCollectibleCallbackLoader(callback, collectibleId)
	FiendFolio:CreateCollectibleCallbackInnateLoader(callback, collectibleId)
	FiendFolio:CreateCollectibleCallbackWispLoader(callback, collectibleId)
	FiendFolio:CreateCollectibleCallbackMetronomeLoader(callback, collectibleId)
	FiendFolio:CreateCollectibleCallbackGlitchedLoader(callback, collectibleId)
	FiendFolio:CreateCollectibleCallbackModelingClayLoader(callback, collectibleId)

	FiendFolio:CreateCollectibleCallbackUnloader(callback, collectibleId)
	FiendFolio:CreateCollectibleCallbackMetronomeUnloader(callback, collectibleId)
	FiendFolio:CreateCollectibleCallbackGlitchedUnloader(callback, collectibleId)
	FiendFolio:CreateCollectibleCallbackModelingClayUnloader(callback, collectibleId)

	if callbackId == ModCallbacks.MC_EVALUATE_CACHE or callbackId == ModCallbacks.MC_EVALUATE_STAT or callbackId == ModCallbacks.MC_EVALUATE_CUSTOM_CACHE then
		evaluateCacheCollectibles[collectibleId] = Isaac.GetItemConfig():GetCollectible(collectibleId)
	end
end

function FiendFolio:CreateCollectibleCallbackLoader(callback, collectibleId)
	FiendFolio:AddPriorityCallback(ModCallbacks.MC_PRE_ADD_COLLECTIBLE, math.huge, function()
		FiendFolio:LoadDynamicCallback(callback)
	end, collectibleId)
end

function FiendFolio:CreateCollectibleCallbackInnateLoader(callback, collectibleId)
	FiendFolio:AddCallback(ModCallbacks.MC_POST_ADD_INNATE_COLLECTIBLE, function(_, player)
		FiendFolio:LoadDynamicCallback(callback)

		-- May need to trigger another cache eval since we missed it.
		MaybeTriggerCollectibleCache(player, collectibleId)
	end, collectibleId)
end

function FiendFolio:CreateCollectibleCallbackWispLoader(callback, collectibleId)
	FiendFolio:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, familiar)
		if familiar.SubType == collectibleId then
			FiendFolio:LoadDynamicCallback(callback)
		end
	end, FamiliarVariant.ITEM_WISP)
end

function FiendFolio:CreateCollectibleCallbackMetronomeLoader(callback, collectibleId)
	FiendFolio:AddCallback("DYNAMIC_POST_ADD_METRONOME", function(_, player)
		FiendFolio:LoadDynamicCallback(callback)

		-- May need to trigger another cache eval since we missed it.
		MaybeTriggerCollectibleCache(player, collectibleId)
	end, collectibleId)
end

function FiendFolio:CreateCollectibleCallbackGlitchedLoader(callback, collectibleId)
	FiendFolio:AddCallback("DYNAMIC_PRE_ADD_GLITCHED_COLLECTIBLE", function()
		FiendFolio:LoadDynamicCallback(callback)
	end, collectibleId)
end

function FiendFolio:CreateCollectibleCallbackModelingClayLoader(callback, collectibleId)
	FiendFolio:AddCallback("DYNAMIC_LOAD_MODELING_CLAY_EFFECT", function(_, player)
		FiendFolio:LoadDynamicCallback(callback)

		-- May need to trigger another cache eval since we missed it.
		--MaybeTriggerCollectibleCache(player, collectibleId)
	end, collectibleId)
end

function FiendFolio:CreateCollectibleCallbackUnloader(callback, collectibleId)
	FiendFolio:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, function()
		FiendFolio:TryUnloadDynamicCallback(callback)
	end, collectibleId)
end

function FiendFolio:CreateCollectibleCallbackMetronomeUnloader(callback, collectibleId)
	FiendFolio:AddCallback("DYNAMIC_POST_REMOVE_METRONOME", function()
		FiendFolio:TryUnloadDynamicCallback(callback)
	end, collectibleId)
end

function FiendFolio:CreateCollectibleCallbackGlitchedUnloader(callback, collectibleId)
	FiendFolio:AddCallback("DYNAMIC_POST_REMOVE_GLITCHED_COLLECTIBLE", function()
		FiendFolio:TryUnloadDynamicCallback(callback)
	end, collectibleId)
end

function FiendFolio:CreateCollectibleCallbackModelingClayUnloader(callback, collectibleId)
	FiendFolio:AddCallback("DYNAMIC_UNLOAD_MODELING_CLAY_EFFECT", function()
		FiendFolio:TryUnloadDynamicCallback(callback)
	end, collectibleId)
end

------------------------
-- Metronome handling --
------------------------

local metronomeUsingPlayer = nil
local previousMetronomeID = 0

FiendFolio:AddPriorityCallback(ModCallbacks.MC_PRE_USE_ITEM, math.huge, function(_,_,_,player) 
	metronomeUsingPlayer = player
	previousMetronomeID = metronomeUsingPlayer:GetMetronomeCollectibleID()
end, CollectibleType.COLLECTIBLE_METRONOME)

FiendFolio:AddPriorityCallback(ModCallbacks.MC_USE_ITEM, -math.huge, function() 
	if previousMetronomeID ~= 0 then
		Isaac.RunCallbackWithParam("DYNAMIC_POST_REMOVE_METRONOME", previousMetronomeID, metronomeUsingPlayer)
	end
	if metronomeUsingPlayer then
		Isaac.RunCallbackWithParam("DYNAMIC_POST_ADD_METRONOME", metronomeUsingPlayer:GetMetronomeCollectibleID(), metronomeUsingPlayer)
	end
	metronomeUsingPlayer = nil
	previousMetronomeID = 0
end, CollectibleType.COLLECTIBLE_METRONOME)

-----------------------
-- Trinket callbacks --
-----------------------

-- Map of TrinketType->ItemConfigItem for trinkets with dynamic callbacks added for MC_EVALUATE_CACHE/STAT/CUSTOM_CACHE.
-- In certain cases (such as innates) we will miss the usual cache eval before we can enable the dynamic callbacks, and need to trigger another.
local evaluateCacheTrinkets = {}

function FiendFolio:AddTrinketCallback(callbackId, trinketId, func, optional)
	FiendFolio:AddPriorityTrinketCallback(callbackId, CallbackPriority.DEFAULT, trinketId, func, optional)
end

function FiendFolio:AddPriorityTrinketCallback(callbackId, priority, trinketId, func, optional)
	local trinketId = trinketId & TrinketType.TRINKET_ID_MASK

	FiendFolio:TryCreateBaseCallback(callbackId, priority, optional)

	local callback = RegisterDynamicCallback(callbackId, priority, optional, func)
	table.insert(callback.Trinkets, trinketId)

	FiendFolio:CreateTrinketCallbackLoader(callback, trinketId)
	FiendFolio:CreateTrinketCallbackInnateLoader(callback, trinketId)
	FiendFolio:CreateTrinketCallbackGlitchedLoader(callback, trinketId)
	FiendFolio:CreateTrinketCallbackErrorLoader(callback, trinketId)

	FiendFolio:CreateTrinketCallbackUnloader(callback, trinketId)
	FiendFolio:CreateTrinketCallbackGlitchedUnloader(callback, trinketId)
	FiendFolio:CreateTrinketCallbackErrorUnloader(callback, trinketId)

	if callbackId == ModCallbacks.MC_EVALUATE_CACHE or callbackId == ModCallbacks.MC_EVALUATE_STAT or callbackId == ModCallbacks.MC_EVALUATE_CUSTOM_CACHE then
		evaluateCacheTrinkets[trinketId] = Isaac.GetItemConfig():GetTrinket(trinketId)
	end
end

function FiendFolio:CreateTrinketCallbackLoader(callback, trinketId)
	FiendFolio:AddPriorityCallbackWithTrinketParam(ModCallbacks.MC_PRE_ADD_TRINKET, math.huge, function()
		FiendFolio:LoadDynamicCallback(callback)
	end, trinketId)
end

function FiendFolio:CreateTrinketCallbackInnateLoader(callback, trinketId)
	FiendFolio:AddPriorityCallbackWithTrinketParam(ModCallbacks.MC_POST_ADD_INNATE_TRINKET, -math.huge, function(_, player)
		FiendFolio:LoadDynamicCallback(callback)

		-- May need to trigger another cache eval since we missed it.
		if evaluateCacheTrinkets[trinketId] then
			TriggerItemCache(player, evaluateCacheTrinkets[trinketId])
		end
	end, trinketId)
end

function FiendFolio:CreateTrinketCallbackGlitchedLoader(callback, trinketId)
	FiendFolio:AddCallback("DYNAMIC_PRE_ADD_GLITCHED_TRINKET", function()
		FiendFolio:LoadDynamicCallback(callback)
	end, trinketId)
end

function FiendFolio:CreateTrinketCallbackErrorLoader(callback, trinketId)
	FiendFolio:AddCallback("DYNAMIC_LOAD_ERROR_TRINKET_EFFECT", function(_, triggerCache)
		FiendFolio:LoadDynamicCallback(callback)

		-- May need to trigger another cache eval since we missed it.
		if triggerCache and evaluateCacheTrinkets[trinketId] then
			for _, player in ipairs(PlayerManager.GetPlayers()) do
				TriggerItemCache(player, evaluateCacheTrinkets[trinketId])
			end
		end
	end, trinketId)
end

function FiendFolio:CreateTrinketCallbackUnloader(callback, trinketId)
	FiendFolio:AddPriorityCallbackWithTrinketParam(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, -math.huge, function()
		FiendFolio:TryUnloadDynamicCallback(callback)
	end, trinketId)
end

function FiendFolio:CreateTrinketCallbackGlitchedUnloader(callback, trinketId)
	FiendFolio:AddCallback("DYNAMIC_POST_REMOVE_GLITCHED_TRINKET", function()
		FiendFolio:TryUnloadDynamicCallback(callback)
	end, trinketId)
end

function FiendFolio:CreateTrinketCallbackErrorUnloader(callback, trinketId)
	FiendFolio:AddCallback("DYNAMIC_UNLOAD_ERROR_TRINKET_EFFECT", function()
		FiendFolio:TryUnloadDynamicCallback(callback)
	end, trinketId)
end

------------------------------
-- "Modeling Clay" handling --
------------------------------

local cachedModelingClayEffects = {}

function FiendFolio:ClearDynamicModelingClayEffects()
	cachedModelingClayEffects = {}
end

function FiendFolio:GetActiveModelingClayEffects()
	local activeEffects = {}

	if PlayerManager.AnyoneHasTrinket(TrinketType.TRINKET_MODELING_CLAY) then
		for _, player in ipairs(PlayerManager.GetPlayers()) do
			if player:HasTrinket(TrinketType.TRINKET_MODELING_CLAY) then
				local effect = player:GetModelingClayEffect()
				if effect > 0 then
					activeEffects[effect] = true
				end
			end
		end
	end

	return activeEffects
end

function FiendFolio:TryLoadModelingClayEffectForPlayer(player)
	if player:HasTrinket(TrinketType.TRINKET_MODELING_CLAY) then
		local effect = player:GetModelingClayEffect()
		if effect > 0 then
			if not cachedModelingClayEffects[effect] then
				cachedModelingClayEffects[effect] = true
				Isaac.RunCallbackWithParam("DYNAMIC_LOAD_MODELING_CLAY_EFFECT", effect, player)
			end
			return effect
		end
	end
end

function FiendFolio:TryUnloadModelingClayEffects()
	local activeEffects = FiendFolio:GetActiveModelingClayEffects()

	for effect, _ in pairs(cachedModelingClayEffects) do
		if not activeEffects[effect] then
			cachedModelingClayEffects[effect] = nil
			Isaac.RunCallbackWithParam("DYNAMIC_UNLOAD_MODELING_CLAY_EFFECT", effect)
		end
	end
end

function FiendFolio:RefreshDynamicModelingClayEffects(skipLoadUnload)
	if skipLoadUnload then
		cachedModelingClayEffects = FiendFolio:GetActiveModelingClayEffects()
		return
	end

	if PlayerManager.AnyoneHasTrinket(TrinketType.TRINKET_MODELING_CLAY) then
		for _, player in ipairs(PlayerManager.GetPlayers()) do
			FiendFolio:TryLoadModelingClayEffectForPlayer(player)
		end
	end

	FiendFolio:TryUnloadModelingClayEffects()
end

FiendFolio:AddPriorityCallbackWithTrinketParam(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, -math.huge, FiendFolio.TryLoadModelingClayEffectForPlayer, TrinketType.TRINKET_MODELING_CLAY)
FiendFolio:AddPriorityCallbackWithTrinketParam(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, -math.huge, FiendFolio.TryUnloadModelingClayEffects, TrinketType.TRINKET_MODELING_CLAY)
FiendFolio:AddPriorityTrinketCallback(ModCallbacks.MC_POST_PLAYER_NEW_ROOM_TEMP_EFFECTS, -math.huge, TrinketType.TRINKET_MODELING_CLAY, FiendFolio.TryLoadModelingClayEffectForPlayer)
FiendFolio:AddPriorityTrinketCallback(ModCallbacks.MC_POST_NEW_ROOM, -math.huge, TrinketType.TRINKET_MODELING_CLAY, function()
	FiendFolio:AddOneTimeCallback(ModCallbacks.MC_POST_UPDATE, FiendFolio.TryUnloadModelingClayEffects)
end)

------------------------------
-- "Error" Trinket handling --
------------------------------

local cachedErrorEffect = nil

function FiendFolio:SetDynamicErrorTrinketEffect(effect)
	cachedErrorEffect = effect
end

function FiendFolio:GetErrorTrinketEffect(ignoreAnyoneHasTrinket)
	if Isaac.IsInGame() and (ignoreAnyoneHasTrinket or PlayerManager.AnyoneHasTrinket(TrinketType.TRINKET_ERROR)) then
		return game:GetLevel():GetCurrentRoomDesc():GetErrorTrinketEffect()
	end
end

function FiendFolio:UpdateDynamicErrorTrinketEffect(isPreAdd)
	local currentErrorEffect = FiendFolio:GetErrorTrinketEffect(isPreAdd)
	local previousErrorEffect = cachedErrorEffect
	cachedErrorEffect = currentErrorEffect

	if currentErrorEffect ~= previousErrorEffect then
		if previousErrorEffect then
			Isaac.RunCallbackWithParam("DYNAMIC_UNLOAD_ERROR_TRINKET_EFFECT", previousErrorEffect)
		end
		if currentErrorEffect then
			local triggerCache = not isPreAdd
			Isaac.RunCallbackWithParam("DYNAMIC_LOAD_ERROR_TRINKET_EFFECT", currentErrorEffect, triggerCache)
		end

		if previousErrorEffect == TrinketType.TRINKET_MODELING_CLAY or currentErrorEffect == TrinketType.TRINKET_MODELING_CLAY then
			FiendFolio:RefreshDynamicModelingClayEffects()
		end
	end
end

FiendFolio:AddPriorityCallbackWithTrinketParam(ModCallbacks.MC_PRE_ADD_TRINKET, math.huge, function()
	FiendFolio:UpdateDynamicErrorTrinketEffect(true)
end, TrinketType.TRINKET_ERROR)

FiendFolio:AddPriorityCallbackWithTrinketParam(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, -math.huge, function()
	FiendFolio:UpdateDynamicErrorTrinketEffect(false)
end, TrinketType.TRINKET_ERROR)

FiendFolio:AddPriorityCallbackWithTrinketParam(ModCallbacks.MC_POST_ADD_INNATE_TRINKET, -math.huge, function()
	FiendFolio:UpdateDynamicErrorTrinketEffect(false)
end, TrinketType.TRINKET_ERROR)

---------------------------
-- Glitched Collectibles --
---------------------------

FiendFolio:AddPriorityCallback(ModCallbacks.MC_PRE_ADD_COLLECTIBLE, math.huge, function(_, collectible)
	if collectible < 0 then
		local glitchId = math.abs(collectible) - 1
		local targetItemConfig = ProceduralItemManager.GetProceduralItem(glitchId):GetTargetItem()
		if targetItemConfig:IsCollectible() then
			Isaac.RunCallbackWithParam("DYNAMIC_PRE_ADD_GLITCHED_COLLECTIBLE", targetItemConfig.ID)
		elseif targetItemConfig:IsTrinket() then
			Isaac.RunCallbackWithParam("DYNAMIC_PRE_ADD_GLITCHED_TRINKET", targetItemConfig.ID)
		end
	end
end)

FiendFolio:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, function(_, player, collectible)
	if collectible < 0 then
		local glitchId = math.abs(collectible) - 1
		local targetItemConfig = ProceduralItemManager.GetProceduralItem(glitchId):GetTargetItem()
		if targetItemConfig:IsCollectible() then
			Isaac.RunCallbackWithParam("DYNAMIC_POST_REMOVE_GLITCHED_COLLECTIBLE", targetItemConfig.ID)
		elseif targetItemConfig:IsTrinket() then
			Isaac.RunCallbackWithParam("DYNAMIC_POST_REMOVE_GLITCHED_TRINKET", targetItemConfig.ID)
		end
	end
end)

--------------------------------
-- Temporary effects (player) --
--------------------------------

function FiendFolio:AddPlayerTempEffectCallback(callbackId, itemConfigItem, func, optional)
	FiendFolio:AddPriorityPlayerTempEffectCallback(callbackId, CallbackPriority.DEFAULT, itemConfigItem, func, optional)
end

function FiendFolio:AddPriorityPlayerTempEffectCallback(callbackId, priority, itemConfigItem, func, optional)
	FiendFolio:TryCreateBaseCallback(callbackId, priority, optional)

	local callback = RegisterDynamicCallback(callbackId, priority, optional, func)
	table.insert(callback.Effects, itemConfigItem)

	FiendFolio:CreatePlayerTempEffectCallbackLoader(callback, itemConfigItem)
	FiendFolio:CreatePlayerTempEffectCallbackUnloader(callback, itemConfigItem)
end

function FiendFolio:AnyoneHasTempEffect(itemConfigItem)
	if itemConfigItem:IsCollectible() then
		for _, player in ipairs(PlayerManager.GetPlayers()) do
			if player:GetEffects():HasCollectibleEffect(itemConfigItem.ID) then
				return true
			end
		end
	elseif itemConfigItem:IsTrinket() then
		for _, player in ipairs(PlayerManager.GetPlayers()) do
			if player:GetEffects():HasTrinketEffect(itemConfigItem.ID) then
				return true
			end
		end
	elseif itemConfigItem:IsNull() then
		for _, player in ipairs(PlayerManager.GetPlayers()) do
			if player:GetEffects():HasNullEffect(itemConfigItem.ID) then
				return true
			end
		end
	end
	return false
end

function FiendFolio:CreatePlayerTempEffectCallbackLoader(callback, itemConfigItem)
	FiendFolio:AddPriorityCallback(ModCallbacks.MC_POST_PLAYER_ADD_EFFECT, -math.huge, function()
		FiendFolio:LoadDynamicCallback(callback)
	end, itemConfigItem)
end

function FiendFolio:CreatePlayerTempEffectCallbackUnloader(callback, itemConfigItem)
	FiendFolio:AddPriorityCallback(ModCallbacks.MC_POST_PLAYER_TRIGGER_EFFECT_REMOVED, -math.huge, function()
		FiendFolio:TryUnloadDynamicCallback(callback)
	end, itemConfigItem)
end

----------------
-- Challenges --
----------------

function FiendFolio:AddChallengeCallback(callbackId, challenge, func, optional)
	FiendFolio:AddPriorityChallengeCallback(callbackId, CallbackPriority.DEFAULT, challenge, func, optional)
end

function FiendFolio:AddPriorityChallengeCallback(callbackId, priority, challenge, func, optional)
	FiendFolio:TryCreateBaseCallback(callbackId, priority, optional)

	local callback = RegisterDynamicCallback(callbackId, priority, optional, func)
	table.insert(callback.Challenges, challenge)

	FiendFolio:CreateChallengeCallbackLoaderAndUnloader(callback, challenge)
end

local lastKnownChallenge = game.Challenge
function FiendFolio:CreateChallengeCallbackLoaderAndUnloader(callback, challenge)
	FiendFolio:AddCallback("DYNAMIC_LOAD_CHALLENGE", function(_, currentChallenge)
		if currentChallenge == challenge then
			FiendFolio:LoadDynamicCallback(callback)
		elseif lastKnownChallenge == challenge then
			FiendFolio:TryUnloadDynamicCallback(callback)
		end
		lastKnownChallenge = currentChallenge
	end)
end

FiendFolio:AddPriorityCallback(ModCallbacks.MC_PLAYER_INIT_PRE_LEVEL_INIT_STATS, -math.huge, function()
	Isaac.RunCallback("DYNAMIC_LOAD_CHALLENGE", game.Challenge)
end)

if not FiendFolio.OverriddenFunctions.Game.propset_Challenge then
	local META = getmetatable(Game())
	FiendFolio.OverriddenFunctions.Game.propset_Challenge = META.__propset.Challenge
	META.__propset.Challenge = function(game, challenge)
		FiendFolio.OverriddenFunctions.Game.propset_Challenge(game, challenge)
		Isaac.RunCallback("DYNAMIC_LOAD_CHALLENGE", challenge)
	end
end