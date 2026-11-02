local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

--------------------------------------------------
-- ----- NOTE: GetData() Tags -----
--
--  - mod:GetEntityData(npc).ffRadioactiveEnemy
-- Enemy is immune to radioactive explosions and fire from enemies.
-- Primarily to prevent radioactive enemies from hurting each other.
--
--  - mod:GetEntityData(npc).ffAbsorbRadiation
-- Enemy will accumulate radiation buildup even from allied radiation, but still won't
-- take damage from allied radiation buildup. For enemies that react to being irradiated.
--
--  - mod:GetEntityData(npc).ffNoRadiationColor
-- Skips applying the radiation color modification to this enemy (the Greening).
--
--  - mod:GetEntityData(npc).ffRadiationGainRate
-- Customize the rate that the enemy gains radiation when exposed. Default is 1 per frame.
--
--  - mod:GetEntityData(npc).ffRadiationLossRate
-- Customize the rate that the enemy loses radiation when not exposed. Default is -1 per frame.
--
--------------------------------------------------
-- RADIATION SETTINGS

-- The # of frames the player must stand in radiation to start losing health.
local MAX_RADIATION = 60

-- When a player reaches MAX_RADIATION, take a heart and decrease their radiation count by this amount.
-- If this is less than MAX_RADIATION, that makes that subsequent hearts lost will be faster than the initial radiation buildup.
local RADIATION_REDUCTION_ON_HEALTH_LOSS = 40

-- The speed at which that dropped hearts will be moving when spawned.
-- Higher value means faster hearts, which means potentially harder to recover.
local RADIATION_DROPPED_HEART_SPEED = 4

-- The # of frames that dropped hearts will persist before disappearing.
-- Shortening this duration makes hearts harder to recover in time.
local RADIATION_DROPPED_HEART_TIMEOUT = 60

-- Whether red hearts will be lost first due to radiation over soul hearts.
local RADIATION_PREFER_RED_HEALTH = true

-- Which players are entirely immune to radiation.
FiendFolio.RadiationImmunePlayers = {
	[PlayerType.PLAYER_THELOST] = true,
	[PlayerType.PLAYER_THELOST_B] = true,
	[PlayerType.PLAYER_THEFORGOTTEN_B] = true,
	[FiendFolio.PLAYER.CHINA] = true,
}

--------------------------------------------------
-- HELPERS

-- Returns MAX_RADIATION for non-players.
-- If player, checks if they have Uranium rock, which grants radiation resistance.
function mod:GetMaxRadiation(entity)
	if entity.Type ~= EntityType.ENTITY_PLAYER then
		return MAX_RADIATION
	end

	local maxRadiation = MAX_RADIATION

	local player = entity:ToPlayer()
	if player:HasTrinket(mod.ITEM.ROCK.URANIUM) then
		local power = mod.GetGolemTrinketPower(player, mod.ITEM.ROCK.URANIUM)
		if power > 0 then
			maxRadiation = math.max(maxRadiation * (power+1), maxRadiation)
		end
	end

	return maxRadiation
end

-- Spawns a standalone radioactive aura, that will persist for its defined duration.
function mod:SpawnRadioactiveAura(spawner, position, radius, timeout)
	if spawner then
		position = position or spawner.Position
	end
	local radAura = Isaac.Spawn(FiendFolio.FF.Radiation.ID, FiendFolio.FF.Radiation.Var, FiendFolio.FF.Radiation.Sub, position, mod.nilvector, spawner):ToEffect()
	if radius then
		mod:GetEntityData(radAura).radiationRadius = radius
	end
	if timeout then
		radAura.LifeSpan = timeout
		radAura.Timeout = timeout
	end
	if spawner and mod:isFriend(spawner) then
		mod:GetEntityData(radAura).fromFriendly = true
	end
	return radAura
end

-- Set the target size of the radioactive aura around this entity, creating it if it doesn't exist yet.
-- If you stop calling this function, or the parent entity disappears, the aura will shrink and disappear after the timeout.
function mod:SetRadioactiveAura(parent, radius, timeout)
	local data
	if type(parent) == "table" then
		data = parent
	else
		data = mod:GetEntityData(parent)
	end

	if not data.ffRadioactiveAura or not data.ffRadioactiveAura:Exists() then
		local spawner = (type(parent) ~= "table") and parent or nil
		data.ffRadioactiveAura = mod:SpawnRadioactiveAura(spawner, parent.Position)
		if spawner then
			data.ffRadioactiveAura:FollowParent(spawner)
		end
	end

	mod:GetEntityData(data.ffRadioactiveAura).radiationRadius = radius
	data.ffRadioactiveAura.Timeout = timeout or 2
end

function mod:GetRadiationBuildup(entity, data)
	return (data or mod:GetEntityData(entity)).ffRadiationBuildup or 0
end

function mod:SetRadiationBuildup(entity, amount, data)
	local maxRadiation = mod:GetMaxRadiation(entity)
	local data = data or mod:GetEntityData(entity)
	data.ffRadiationBuildup = math.min(math.max(0, amount or 0), maxRadiation)
end

function mod:SetRadiationPercent(entity, pct, data)
	local maxRadiation = mod:GetMaxRadiation(entity)
	mod:SetRadiationBuildup(entity, maxRadiation * pct, data)
end

function mod:AddRadiationBuildup(entity, amount, data)
	mod:SetRadiationBuildup(entity, mod:GetRadiationBuildup(entity, data) + (amount or 0), data)
end

function mod:GetRadiationPercent(entity, data)
	local maxRadiation = mod:GetMaxRadiation(entity)
	return math.min(math.max(0, mod:GetRadiationBuildup(entity, data) / maxRadiation), 1)
end

-- Returns true if the player should be immune to radiation buildup.
function mod:PlayerImmuneToRadiation(player)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_EVIL_CHARM) then
		return true
	end
	local pType = player:GetPlayerType()
	return mod.RadiationImmunePlayers[pType]
		or CustomHealthAPI.Helper.IsFoundSoul(player)
		or player:IsCoopGhost()
end

function mod:FindRadiationAuras(cached)
	return Isaac.FindByType(FiendFolio.FF.Radiation.ID, FiendFolio.FF.Radiation.Var, FiendFolio.FF.Radiation.Sub, cached)
end

function mod:AllowRadioactiveExplosionFireDamage(entity, data, source)
	if entity:ToNPC() and data.ffRadioactiveEnemy then
		if mod:isFriend(entity) then
			return false
		end
		return source.IsFriendly or source.IsCharmed
	end
	return true
end

function mod:IsFriendlyRadioactiveAura(radAura)
	if radAura.SpawnerEntity and (radAura.SpawnerEntity.Type == EntityType.ENTITY_PLAYER
			or radAura.SpawnerEntity.Type == EntityType.ENTITY_FAMILIAR
			or mod:isFriend(radAura.SpawnerEntity)) then
		return true
	end
	return mod:GetEntityData(radAura).fromFriendly or false
end

function mod:IsAlliedRadioactiveAura(entity, radAura)
	return mod:IsFriendlyRadioactiveAura(radAura) == (entity.Type == EntityType.ENTITY_PLAYER or entity.Type == EntityType.ENTITY_FAMILIAR or mod:isFriend(entity))
end

function mod:IsEnemyExposedToRadiation(npc, includeAllied, data)
	data = data or mod:GetEntityData(npc)

	local alliedRadiation
	local hostileRadiation

	for _, radAura in pairs(mod:FindRadiationAuras(true)) do
		if npc.Position:Distance(radAura.Position) < radAura.Size + npc.Size then
			if mod:IsAlliedRadioactiveAura(npc, radAura) then
				alliedRadiation = radAura
			else
				hostileRadiation = radAura
			end
		end
	end

	if hostileRadiation then
		return hostileRadiation, true
	end

	if includeAllied or data.ffAbsorbRadiation then
		return alliedRadiation, false
	end
end

-- Gets a heart's id/var/sub from a chapi heart object
function mod:GetHeartIdFromKey(key, hp)
	local id, var, subt

	if mod.VanillaHeartDrops[key] then
		id = EntityType.ENTITY_PICKUP
		var = mod.VanillaHeartDrops[key].Var or PickupVariant.PICKUP_HEART
		subt = mod.VanillaHeartDrops[key].Sub or 0
	elseif CustomHealthAPI.PersistentData.HealthDefinitions[key] then
		local pickups = CustomHealthAPI.PersistentData.HealthDefinitions[key].PickupEntities
		local pickup = pickups[hp] or pickups[1] or pickups[2]
		id = pickup.ID
		var = pickup.Var
		subt = pickup.Sub
	end

	return id, var, subt
end

--[[
--Stole this to test something with pipe backdrops, THANK YOU --Erf
function mod:TestRadBackdrop()
	mod.roomBackdrop = 3
	mod.roomBackdropFrom = game:GetLevel():GetCurrentRoomDesc().ListIndex
	mod.roomBackdropFromStageAPI = StageAPI.GetCurrentRoom()
	mod.roomBackdropFromLevel = game:GetSeeds():GetStageSeed(game:GetLevel():GetStage())
	mod.SetCurrentBackdrop = game:GetLevel():GetCurrentRoomIndex()
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_ROOM, -1, mod.TestRadBackdrop)
]]
--------------------------------------------------
-- STATIC SHADER RELATED

local elephantRads = 0
local cachedStaticIntensity = 0
local lastStaticCheck = 0

-- Provides the current desired intensity of the static effect to the sleeper shader.
function mod:GetRadiationStaticIntensity()
	local currentFrame = game:GetFrameCount()

	if game:IsPaused() then
		return 0
	end

	if currentFrame == lastStaticCheck then
		-- Don't recalculate this more than once per frame.
		return cachedStaticIntensity
	end

	local maxRadiation = MAX_RADIATION

	-- The effect intensity and the corresponding amount of radiation we consider to be "medium".
	-- Specifically atm this is the amount of radiation the player drops to after losing a heart.
	local midPoint = 0.85
	local midRads = maxRadiation - RADIATION_REDUCTION_ON_HEALTH_LOSS

	local foundElephant = false
	local rads = 0

	for i=0, game:GetNumPlayers()-1 do
		local player = game:GetPlayer(i)
		if player and player:Exists() then
			rads = math.max(rads, mod:GetEntityData(player).ffRadiationBuildup or 0)
			maxRadiation = math.max(mod:GetMaxRadiation(player), maxRadiation)
			midRads = maxRadiation - RADIATION_REDUCTION_ON_HEALTH_LOSS
		end
		if not foundElephant then
			-- Check if any Elephants are within line of sight to a player.
			-- If so, we add a little static even if the player is not actually exposed to radiation.
			for _, elephant in ipairs(Isaac.FindByType(mod.FF.Elephant.ID, mod.FF.Elephant.Var)) do
				if game:GetRoom():CheckLine(player.Position, elephant.Position, 1) then
					foundElephant = true
				end
			end
		end
	end

	if foundElephant and elephantRads < midRads then
		elephantRads = elephantRads + 1
	elseif elephantRads > 0 then
		elephantRads = elephantRads - 1
	end

	rads = math.max(rads, elephantRads)

	-- Calculate the actual % we want to use for the shader.
	-- This looks more smooth visually than just doing it linearly.
	local radPct
	if rads <= midRads then
		local x = rads / midRads
		radPct = (-(x-1)^2 + 1) * midPoint
	else
		radPct = midPoint + math.min((rads-midRads) / (maxRadiation-midRads), 0.95) * (1-midPoint)
	end

	lastStaticCheck = currentFrame
	cachedStaticIntensity = radPct
	return cachedStaticIntensity
end

--------------------------------------------------
-- RADIATION EFFECT ENTITY

function mod:RadiationInit(radAura)
	if radAura.SubType ~= FiendFolio.FF.Radiation.Sub then return end

	radAura.Size = 20

	-- Initially just render radiation on the floor.
	-- The glow is rendered again manually in POST_RENDER to add a glow layer on top of everything as well.
	radAura.SortingLayer = SortingLayer.SORTING_BACKGROUND

	mod:RadiationUpdate(radAura)

	local blendMode = radAura:GetSprite():GetLayer(0):GetBlendMode()
	blendMode.RGBSourceFactor = BlendFactor.SRC_ALPHA
	blendMode.AlphaSourceFactor = BlendFactor.SRC_COLOR
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, mod.RadiationInit, FiendFolio.FF.Radiation.Var)

function mod:RadiationUpdate(radAura)
	if radAura.SubType ~= FiendFolio.FF.Radiation.Sub then return end

	local data = mod:GetEntityData(radAura)

	local targetRadius = 20 + (data.radiationRadius or 80)

	if radAura.Timeout == 0 then
		targetRadius = 0
	end

	if radAura.Size ~= targetRadius then
		data.lerpStrength = mod:Lerp(data.lerpStrength or 0, 0.1, 0.03)
		radAura.Size = mod:Lerp(radAura.Size, targetRadius, data.lerpStrength)
		if math.abs(targetRadius - radAura.Size) < 1 then
			radAura.Size = targetRadius
		end
	else
		data.lerpStrength = 0
	end

	if radAura.Size <= 1 then
		radAura:Remove()
		return
	end

	local n = math.sin(radAura.FrameCount / 4)
	local g = 1
	local rb = 0
	local a = 1  -- Change the alpha in the ANM2 instead of this, since this also affects the light generated.

	local go = 5 + 0.5 * n
	local rbo = 0.5 * n
	radAura.Color = Color(rb, g, rb, a, rbo, go, rbo)

	local scale = 0.7 * radAura.Size / 100
	if not data.ignorePulsing then
		local pulseMult = 1 + 0.1 * math.sin(radAura.FrameCount / 20)
		scale = scale * pulseMult
	end
	radAura.SpriteScale = Vector(scale, scale)

	if radAura.FrameCount % 5 == 0 then
		local pos = radAura.Position + Vector(Random() % radAura.Size, 0):Rotated(Random() % 360)
		local vel = Vector(0, -4)
		local particle = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.EMBER_PARTICLE, 0, pos, vel, radAura)
		local col = Color(1,1,1,1)
		col:SetColorize(0,2,0,1)
		particle.Color = col
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.RadiationUpdate, FiendFolio.FF.Radiation.Var)

-- Render the radiation again at the end, to add an additional layer of glow on top of everything.
function mod:RadiationRoomRender()
	if ModCallbacks.MC_POST_ROOM_RENDER_ENTITIES or game:GetRoom():GetFrameCount() > 0 then
		for _, radAura in ipairs(mod:FindRadiationAuras()) do
			radAura:GetSprite():Render(Isaac.WorldToScreen(radAura.Position))
		end
	end
end
mod:AddPriorityEntityCallback(ModCallbacks.MC_POST_ROOM_RENDER_ENTITIES or ModCallbacks.MC_POST_RENDER, CallbackPriority.LATE, FiendFolio.FF.Radiation.ID, FiendFolio.FF.Radiation.Var, FiendFolio.FF.Radiation.Sub, mod.RadiationRoomRender)

--------------------------------------------------
-- GEIGER COUNTER SOUND

local framesSinceGeiger = 0

function mod:RadiationSound()
	local rads = 0
	local maxRadiation = MAX_RADIATION

	for i=0, game:GetNumPlayers()-1 do
		local player = game:GetPlayer(i)
		if player and player:Exists() then
			maxRadiation = math.max(mod:GetMaxRadiation(player), MAX_RADIATION)
			rads = math.max(rads, mod:GetEntityData(player).ffRadiationBuildup or 0)
		end
	end

	if rads == 0 and #mod:FindRadiationAuras() == 0 then return end

	framesSinceGeiger = framesSinceGeiger + 1

	local n = math.min(rads / maxRadiation, 1)

	local freq = math.floor(mod:Lerp(15, 1, n))
	if framesSinceGeiger >= freq then
		local vol = mod:Lerp(0.5, 1.5, n)
		local pitch = mod:Lerp(0.8, 1.3, n) * mod:Lerp(0.9, 1.1, (Random() % 100) / 99)
		sfx:Play(mod.Sounds.Geiger, vol, 0, false, pitch)
		framesSinceGeiger = 0 -(Random() % math.max(1, math.floor(freq*0.5)))
	end
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.RadiationSound)

--------------------------------------------------
-- PROTECT HEARTS SPAWNED BY RADIATION

-- Number of frames to protect hearts dropped via radiation from being morphed.
local RADIATION_HEART_PROTECTION_FRAMES = 3

local heartsSpawnedByRadiation = {}

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	heartsSpawnedByRadiation = {}
end)

function mod:RadiationTrackHearts()
	local toRemove = {}

	local currentFrame = game:GetFrameCount()

	for hash, data in pairs(heartsSpawnedByRadiation) do
		if not data.Ptr or not data.Ptr.Ref then
			-- Pointer got broken, which can sometimes happen on Morph.
			-- See if we can find the same pickup again.
			for _, pickup in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP)) do
				if GetPtrHash(pickup) == hash then
					data.Ptr = EntityPtr(pickup)
					break
				end
			end
		end

		if currentFrame - data.SpawnedFrame > RADIATION_HEART_PROTECTION_FRAMES
				or not (data.Ptr and data.Ptr.Ref and data.Ptr.Ref:Exists() and data.Ptr.Ref:ToPickup()) then
			-- Protection period over, or the pickup is gone.
			table.insert(toRemove, hash)
		else
			local pickup = data.Ptr.Ref:ToPickup()

			if pickup.Variant ~= data.Var or pickup.SubType ~= data.Sub then
				pickup:Morph(data.ID, data.Var, data.Sub, true, true, true)
				mod:GetEntityData(pickup).noTaintedMorph = true  -- Rep+
				if pickup.Timeout < 1 then
					pickup.Timeout = RADIATION_DROPPED_HEART_TIMEOUT
				end
			end
		end
	end

	for _, hash in pairs(toRemove) do
		heartsSpawnedByRadiation[hash] = nil
	end
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.RadiationTrackHearts)

local spawningRadiationHeart = false

local caughtPickups = {}

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
	if spawningRadiationHeart then
		table.insert(caughtPickups, pickup)
	end
end)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_PICKUP_MORPH, CallbackPriority.IMPORTANT, function(_, pickup, newType, newVar, newSub, keepPrice, keepSeed, ignoreModifiers)
	if spawningRadiationHeart then
		return false
	end
	local d = heartsSpawnedByRadiation[GetPtrHash(pickup)]
	if d then
		if pickup.Variant == d.Var and pickup.SubType == d.Sub then
			return false
		end
		return {d.ID, d.Var, d.Sub, keepPrice, keepSeed, true}
	end
end)

mod:AddPriorityCallback(ModCallbacks.MC_POST_PICKUP_SELECTION, CallbackPriority.IMPORTANT, function(_, pickup)
	local d = heartsSpawnedByRadiation[GetPtrHash(pickup)]
	if d and d.ID == pickup.Type then
		return {d.Var, d.Sub}
	end
end)

--------------------------------------------------
-- RADIATION HP LOSS

mod.VanillaHeartDrops = {
	RED_HEART = {Sub = HeartSubType.HEART_HALF},
	ETERNAL_HEART = {Sub = HeartSubType.HEART_ETERNAL},
	SOUL_HEART = {Sub = HeartSubType.HEART_HALF_SOUL},
	BLACK_HEART = {Var = FiendFolio.PICKUP.VARIANT.HALF_BLACK_HEART},
	GOLDEN_HEART = {Sub = HeartSubType.HEART_GOLDEN},
	BONE_HEART = {Sub = HeartSubType.HEART_BONE},
	ROTTEN_HEART = {Sub = HeartSubType.HEART_ROTTEN},
	COIN_HEART = {Var = PickupVariant.PICKUP_COIN, Sub = CoinSubType.COIN_PENNY},
}

function mod:SpawnHeartFromRadiation(effectPlayer, id, var, subt)
	-- Protect the heart from getting morphed, also catch any additional pickups that get spawned for whatever reason.
	spawningRadiationHeart = true
	local heart = Isaac.Spawn(id, var, subt, effectPlayer.Position, RandomVector()*RADIATION_DROPPED_HEART_SPEED, effectPlayer):ToPickup()
	spawningRadiationHeart = false

	local hash = GetPtrHash(heart)

	-- Catch the heart being removed and replaced on init.
	for _, pickup in pairs(caughtPickups) do
		if pickup:Exists() and GetPtrHash(pickup) ~= hash then
			if heart:Exists() then
				pickup:Remove()
			else
				heart = pickup
				hash = GetPtrHash(heart)
			end
		end
	end

	caughtPickups = {}

	-- Undo any morphs/replacements on init.
	if heart.Variant ~= var or heart.SubType ~= subt then
		heart:Morph(id, var, subt, true, true, true)
	end

	mod:GetEntityData(heart).noTaintedMorph = true  -- Repentance Plus (the MOD)
	heart.Timeout = RADIATION_DROPPED_HEART_TIMEOUT

	-- Log this heart to further protect against morphing for a couple frames.
	heartsSpawnedByRadiation[hash] = {
		Ptr = EntityPtr(heart),
		ID = id,
		Var = var,
		Sub = subt,
		SpawnedFrame = game:GetFrameCount(),
	}

	sfx:Play(SoundEffect.SOUND_POISON_HURT, 1, 0, false, 1.5)
	effectPlayer:BloodExplode()
	local eff = Isaac.Spawn(1000,2,1, effectPlayer.Position, mod.nilvector, effectPlayer):ToEffect()
	eff:FollowParent(effectPlayer)
	eff.ParentOffset = Vector(0, -effectPlayer.Size * 0.8)
end

function mod:TriggerRadiationDamage(player)
	local lostHealth = CustomHealthAPI.Library.RemoveHealthInDamageOrder(player, 1, RADIATION_PREFER_RED_HEALTH, true)

	for _, health in pairs(lostHealth) do
		local id, var, subt = mod:GetHeartIdFromKey(health.Key, health.HP)

		if id and var and subt then
			local effectPlayer = (player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN_B) and player:GetOtherTwin() or player

			mod:SpawnHeartFromRadiation(effectPlayer, id, var, subt)
		end
	end
end

--------------------------------------------------
-- PLAYER UPDATE

local function UpdatePlayerRadiation(player, rads, data)
	mod:SetRadiationBuildup(player, rads, data)

	-- Update the player's green tint.
	local frame = player.FrameCount
	if (data.ffLastRadiationColorUpdate or 0) < frame then
		data.ffLastRadiationColorUpdate = frame

		local radPct = mod:GetRadiationBuildup(player) / mod:GetMaxRadiation(player)

		local c = player:GetColor()
		c:SetOffset(c.RO * (1 - radPct), c.GO + 0.75 * radPct, c.BO * (1 - radPct))
		player:SetColor(c, 1, 0, false, false)
	end
end

function mod:HandlePlayerRadiationExposure(player)
	if mod:PlayerImmuneToRadiation(player) then
		return
	end

	for _, radAura in pairs(mod:FindRadiationAuras()) do
		if player.Position:Distance(radAura.Position) < radAura.Size then
			local data = mod:GetEntityData(player)
			local rads = mod:GetRadiationBuildup(player, data)
			rads = math.min(rads+1, mod:GetMaxRadiation(player))
			UpdatePlayerRadiation(player, rads, data)
			data.ffLastExposedToRadiation = game:GetFrameCount()
			break
		end
	end
end
mod:AddPriorityEntityCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, CallbackPriority.EARLY, mod.FF.Radiation.ID, mod.FF.Radiation.Var, mod.FF.Radiation.Sub, mod.HandlePlayerRadiationExposure)

function mod:RadiationPlayerUpdate(player, pData)
	local rads = mod:GetRadiationBuildup(player, pData)

	if rads <= 0 then
		return
	end

	if mod:PlayerImmuneToRadiation(player) then
		UpdatePlayerRadiation(player, 0, pData)
		return
	end

	-- Reduce radiation when not being exposed.
	if (pData.ffLastExposedToRadiation or 0) < game:GetFrameCount() then
		rads = math.min(math.max(rads - 1, 0), MAX_RADIATION)
	end

	if rads >= mod:GetMaxRadiation(player) then
		local pType = player:GetPlayerType()
		local isKeeper = (pType == PlayerType.PLAYER_KEEPER or pType == PlayerType.PLAYER_KEEPER_B)
		local currentHealth
		if isKeeper then
			currentHealth = player:GetHearts()
		elseif pType == PlayerType.PLAYER_THESOUL_B then
			currentHealth = CustomHealthAPI.Helper.GetTotalHP(player:GetOtherTwin())
		else
			currentHealth = CustomHealthAPI.Helper.GetTotalHP(player)
		end
		local minHealth = isKeeper and 2 or 1

		if currentHealth > minHealth then
			-- Make the player drop a half-heart.
			rads = rads - RADIATION_REDUCTION_ON_HEALTH_LOSS
			if pType == PlayerType.PLAYER_THESOUL_B then
				mod:TriggerRadiationDamage(player:GetOtherTwin())
			else
				mod:TriggerRadiationDamage(player)
			end
		end
	end

	-- Update the current radiation buildup if it changed.
	if mod:GetRadiationBuildup(player, pData) ~= rads then
		UpdatePlayerRadiation(player, rads, pData)
	end

	mod:HandleRadiationIcon(player, pData)
end

--------------------------------------------------
-- ENEMY UPDATE

function mod:HandleEnemyRadiationExposure(npc)
	local data = mod:GetEntityData(npc)

	local radAura, isHostileRadiation = mod:IsEnemyExposedToRadiation(npc, false, data)

	if isHostileRadiation and mod:isFriend(npc) then
		-- Friendly radioactive enemies won't get hurt by hostile radiation.
		if data.ffAbsorbRadiation then
			isHostileRadiation = false
		elseif data.ffRadioactiveEnemy then
			radAura = nil
			isHostileRadiation = false
		end
	end

	if radAura and (not mod.IsEnemyReallyInvulnerable(npc) or data.ffAbsorbRadiation) then
		data.ExposedToRadiation = true
		if isHostileRadiation then
			data.ExposedToHostileRadiation = true
		end
	end
end
mod:AddPriorityEntityCallback(ModCallbacks.MC_NPC_UPDATE, CallbackPriority.EARLY, mod.FF.Radiation.ID, mod.FF.Radiation.Var, mod.FF.Radiation.Sub, mod.HandleEnemyRadiationExposure)

function mod:RadiationEnemyUpdate(npc, data)
	local maxRadiation = mod:GetMaxRadiation(npc)
	local rads = mod:GetRadiationBuildup(npc, data)

	if rads > 0 or data.ExposedToRadiation then
		if data.ExposedToRadiation then
			local gainRate = math.abs(data.ffRadiationGainRate or 1)
			rads = math.min(rads + gainRate, maxRadiation)
		else
			local lossRate = math.abs(data.ffRadiationLossRate or 1)
			rads = math.max(rads - lossRate, 0)
		end

		if rads >= maxRadiation and not npc:IsDead(npc) and not mod.IsEnemyReallyInvulnerable(npc) and data.ExposedToHostileRadiation then
			rads = rads - RADIATION_REDUCTION_ON_HEALTH_LOSS
			local originalSplatColor = Color.Lerp(npc.SplatColor, Color.Default, 0)  -- Copy
			local c = npc.SplatColor
			npc.SplatColor = Color(c.R, c.G, c.B, c.A, c.RO, mod:Lerp(c.GO, 1.0, 0.5), c.BO)
			mod:makeEnemyGib(npc)
			npc.SplatColor = originalSplatColor
			sfx:Play(SoundEffect.SOUND_POISON_HURT, 0.75, 0, false, 1.5)

			local damage = 9.2
			local source = EntityRef(nil)

			local radAura = mod:IsEnemyExposedToRadiation(npc, false, data)
			if radAura then
				if radAura.SpawnerEntity and radAura.SpawnerEntity:ToPlayer() then
					damage = math.max(damage, radAura.SpawnerEntity:ToPlayer().Damage * 2)
				end
				source = EntityRef(radAura.SpawnerEntity or radAura)
			end

			npc:TakeDamage(damage, DamageFlag.DAMAGE_IGNORE_ARMOR, source, 0)
		end

		if rads > 0 and not data.ffNoRadiationColor then
			local c = Color.Lerp(npc.Color, Color.Default, 0)  -- Copy
			c:SetOffset(c.RO, c.GO + 0.5 * (rads / maxRadiation), c.BO)
			npc:SetColor(c, 2, 9999, false, false)
		end

		mod:SetRadiationBuildup(npc, rads, data)

		data.ExposedToRadiation = false
		data.ExposedToHostileRadiation = false
	end

	mod:HandleRadiationIcon(npc, data, rads)
end

--------------------------------------------------
-- RADIATION STATUS ICON

function mod:HandleRadiationIcon(entity, data, rads)
	data = data or mod:GetEntityData(entity)
	if (rads or mod:GetRadiationBuildup(entity, data)) > 0 then
		-- Spawn the irradiated status icon if missing.
		if not data.ffIrradiatedIcon or not data.ffIrradiatedIcon:Exists() then
			local icon = Isaac.Spawn(EntityType.ENTITY_EFFECT, 1748, 0, entity.Position, mod.nilvector, nil):ToEffect()
			icon:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
			icon:FollowParent(entity)
			icon.DepthOffset = 1
			icon:GetSprite():Play("Irradiated", true)
			icon:Update()
			data.ffIrradiatedIcon = icon
		end
	elseif data.ffIrradiatedIcon and data.ffIrradiatedIcon:Exists() then
		-- Remove the irradiated status icon.
		data.ffIrradiatedIcon:Remove()
		data.ffIrradiatedIcon = nil
	end
end

function mod:RadiationIconUpdate(icon)
	if icon:GetSprite():GetAnimation() ~= "Irradiated" then return end

	if not icon.Parent or not icon.Parent:Exists() then
		icon:Remove()
		return
	end

	local rads = mod:GetRadiationPercent(icon.Parent)

	if rads <= 0 then
		icon:Remove()
		return
	end

	local amp = 1.5
	local spd = 5
	local n = rads * amp * math.sin(game:GetFrameCount() * math.pi * spd / 10)
	icon.SpriteOffset = Vector(n, icon.SpriteOffset.Y)

	local m = rads * amp * math.sin(game:GetFrameCount() * math.pi * spd / 15)
	local a = math.min(1, rads * 2)
	local go = rads*m/3
	icon.Color = Color(1,1,1, a, 0, go, 0)
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.RadiationIconUpdate, 1748)
