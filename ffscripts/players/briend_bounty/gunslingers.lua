local mod = FiendFolio
local game = Game()



-- Gunslinger Maker entity
local metaEntityData = {
	Name = "GunslingerMaker",
	BitValues = {
		Tier = { Length = 3, },
	},
}
if StageAPI then
	StageAPI.AddMetadataEntity(metaEntityData, StageAPI.E.MetaEntity.T, 1764)
end



-- Check if the given entity can be turned into a gunslinger
---@param entity Entity
---@param ignoreSpawner? boolean If true, enemies spawned by other enemies will be allowed.
---@param ignoreBlacklist? boolean If true, the blacklist and minimum health checks will be ignored.
---@param allowFriendly? boolean If true, friendly enemies will be allowed. 
---@return boolean
function mod:IsValidBountyEnemy(entity, ignoreSpawner, ignoreBlacklist, allowFriendly)
	if entity and entity:Exists() and entity:ToNPC()
	and (allowFriendly or not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)) then
		entity = entity:ToNPC()

		-- Stubborn cunts
		if mod:IsOnList(mod.GunslingerSelection.AlwaysAllow, entity) then
			return true
		end

		if entity:IsActiveEnemy(true) and (allowFriendly or entity.CanShutDoors)
		and (ignoreBlacklist or entity.MaxHitPoints >= mod.GunslingerSelection.MinimumHealth) then
			local data = mod:GetEntityData(entity)

			-- Janky death animation entity
			if data.FFIsDeathAnimation then
				return false
			end

			-- StageAPI champion preventer
			local room = game:GetRoom()
			local currentRoom = StageAPI and StageAPI.GetCurrentRoom()

			if room:GetFrameCount() <= 0 and currentRoom then
				local grindex = room:GetGridIndex(entity.Position)

				if currentRoom.Metadata:Has{ Index = grindex, Name = "ChampionPreventer" } then
					return false
				end
			end

			-- Blacklisted
			if not ignoreBlacklist then
				local blacklist = mod:IsOnList(mod.GunslingerSelection.Blacklist, entity)
				local isFunction = type(blacklist) == "function"

				if (isFunction and blacklist(entity)) or (not isFunction and blacklist) then
					return false
				end
			end

			-- Not a main segment
			if (mod:isSegmented(entity) or mod:isBasegameSegmented(entity)) and not mod:IsOnList(mod.GunslingerSelection.AllowSegments, entity) then
				local origin = mod:isBasegameSegmented(entity) and "Basegame" or "" -- Why are they separate?
				local functionToUse = "is" .. origin .. "MainSegment"

				if not mod[functionToUse](mod, entity) then
					return false
				end

			-- Non-boss enemy spawned by another enemy
			elseif not ignoreSpawner and not entity:IsBoss()
			and (entity.SpawnerEntity or entity.SpawnerType ~= 0)
			and entity.SpawnerType ~= EntityType.ENTITY_GIDEON then
				return false
			end

			return true
		end
	end

	return false
end



-- Get the amount of active, non-blacklisted bosses
---@return integer
function mod:CountValidBountyBosses()
	local amount = 0

	for i, entity in pairs( Isaac.GetRoomEntities() ) do
		if entity:IsBoss() and mod:IsValidBountyEnemy(entity) then
			amount = amount + 1
		end
	end
	return amount
end



-- Get the amount of gunslingers a room / wave should have
---@return integer
function mod:GetTargetGunslingerCount()
	local amount = game:GetVictoryLap()

	-- Rerun extra
	if game:IsRerun() then
		amount = amount + 1
	end

	-- Extra for each main twin
	for i, player in pairs( PlayerManager.GetPlayers() ) do
		if player:GetPlayerType() == mod.PLAYER.BRIEND and not mod:IsBriendTwin(player) then
			amount = amount + 1
		end
	end
	return amount
end



-- Turn the given entity into a gunslinger
---@param entity EntityNPC
---@param gunTier? integer Leave out to use normal gun tier selecting.
---@param dualWield? boolean Forces the entity to dual wield guns.
---@param gunType? BountyGunTypes Forces the entity to use the given gun type.
---@param secondaryGunType? BountyGunTypes Can be left out to use `gunType`.
---@param costume string? The name of an animation in the costume ANM2.
---@param dontIncreaseHealth? boolean Makes the entity not gain the gunslinger health multiplier.
function mod:MakeGunslinger(entity, gunTier, dualWield, gunType, secondaryGunType, costume, dontIncreaseHealth)
	local rng = RNG(entity.InitSeed)

	local data = mod:GetEntityData(entity)
	data.GunslingerData = { Guns = {}, }


	-- Increase health
	if not entity:IsBoss() and not dontIncreaseHealth then
		-- Special handling for Fishaac and Missing Link
		if (entity.Type == mod.FF.Fishaac.ID  and entity.Variant == mod.FF.Fishaac.Var)
		or (entity.Type == mod.FF.TDweller.ID and entity.Variant == mod.FF.TDweller.Var) then
			entity.MaxHitPoints = entity.MaxHitPoints + 1
			entity.HitPoints 	= entity.HitPoints 	  + 1

		else
			local hpMulti = entity:IsChampion() and "Champion" or "Regular"
			hpMulti = mod.GunslingerSelection.HealthMulti[hpMulti]

			entity.MaxHitPoints = entity.MaxHitPoints * hpMulti
			entity.HitPoints 	= entity.HitPoints 	  * hpMulti
		end
	end


	-- Get the tier to choose from
	if not gunTier then
		local currentHeat = mod:ClampNumber(mod.savedata.run.briendHeat or 3, 1, 5)
		local tierPicker = WeightedOutcomePicker()
		tierPicker:AddOutcomeWeight(currentHeat, 100)

		-- Get the possible neigbouring tiers
		for direction, amount in pairs( mod.GunslingerSelection.MaxTierDifference ) do
			local multi = mod:GetSign(direction == "Higher")

			for i = 1, amount do
				local newTier = currentHeat + (multi * i)

				-- Don't include tiers that don't exist (clamping the value would make certain tiers more common)
				if mod:ClampNumber(newTier, 1, 5) == newTier then
					local weightDecrease = i * mod.GunslingerSelection.TierWeightDecreases[direction]
					tierPicker:AddOutcomeWeight(newTier, 100 - weightDecrease)
				end
			end
		end

		gunTier = tierPicker:PickOutcome(rng)
	else
		gunTier = mod:ClampNumber(gunTier, 1, 5)
	end


	-- Choose the guns
	local gunPicker = mod.GunslingerSelection.Tiers[gunTier].Picker
	local gunCount = dualWield and 2 or 1
	local hasEternal = false

	for i = 1, gunCount do
		local chosenType = (i > 1 and secondaryGunType) or gunType or gunPicker:PickOutcome(rng)
		local gunTracker = mod:CreateBountyGunTracker(chosenType)
		table.insert(data.GunslingerData.Guns, gunTracker)

		-- Use the eternal hat if the Eternal Revolver was picked
		if chosenType == mod.BountyGunTypes.REVOLVER_ETERNAL then
			hasEternal = true
		end
	end
	mod:QueueGunslingerUpdate(entity)


	-- Create the costume
	if not costume then
		-- Eternal Revolver
		if hasEternal then
			costume = "Eternal"

		-- Great Gideon's goons
		elseif entity.SpawnerType == EntityType.ENTITY_GIDEON then
			costume = "Goon"
		end
	end

	data.GunslingerData.Costume = {
		Sprite = Sprite(mod.GunslingerCostumes.Filepath, true),
		Animation = costume or mod.GunslingerSelection.Tiers[gunTier].Costume,
		LastUpdateFrame = -1,
	}
end





-- Turn one enemy per room / wave into a gunslinger
local queuedWaveGuns = false

function mod:DistributeEnemyGuns()
	if PlayerManager.AnyoneIsPlayerType(mod.PLAYER.BRIEND) and not mod:IsRoomThin() and mod:CountValidBountyBosses() <= 0 then
		local validEnemies = {}

		-- Get all valid enemies
		for i, entity in pairs( Isaac.GetRoomEntities() ) do
			if entity.FrameCount <= 0 and not entity:IsBoss() and mod:IsValidBountyEnemy(entity) then
				table.insert(validEnemies, entity:ToNPC())
			end
		end


		if #validEnemies > 0 then
			local rng = RNG( game:GetRoom():GetSpawnSeed() )

			-- Get the wave offset
			local level = game:GetLevel()
			local waveOffset = Ambush.GetCurrentWave()

			if game:IsGreedMode() and level:GetCurrentRoomIndex() == level:GetStartingRoomIndex() then
				waveOffset = level.GreedModeWave
			end

			-- Offset the seed so different waves get different outcomes
			for i = 1, waveOffset do
				rng:Next()
			end


			-- Give random enemies guns
			local targetCount = mod:GetTargetGunslingerCount()

			while targetCount > 0 and #validEnemies > 0 do
				local chosenIndex = mod:Random(1, #validEnemies, rng)
				local chosen = validEnemies[chosenIndex]
				table.remove(validEnemies, chosenIndex)

				mod:MakeGunslinger(chosen)
				targetCount = targetCount - 1
			end


			-- Give a random enemy an Eternal Revolver
			if not game:IsGreedMode() and #validEnemies > 0 then
				local eternal = mod.GunslingerSelection.EternalRevolver

				if mod.savedata.run.briendHeat >= eternal.MinHeat then
					local heatMulti = mod.savedata.run.briendHeat - eternal.MinHeat
					local chance = eternal.BaseChance + (heatMulti * eternal.HeatBonus)

					if mod:Random(nil, nil, rng) <= chance / 100 then
						local chosen = mod:RandomIndex(validEnemies, rng)
						mod:MakeGunslinger(chosen, 5, false, mod.BountyGunTypes.REVOLVER_ETERNAL)
					end
				end
			end
		end

		queuedWaveGuns = false
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.DistributeEnemyGuns)

-- Wait for the spawn pentagrams before distributing enemy guns
function mod:DistributeNewWaveGuns(effect)
	if not queuedWaveGuns and effect.Variant == EffectVariant.SPAWN_PENTAGRAM then
		mod.scheduleForUpdate(mod.DistributeEnemyGuns, 0, ModCallbacks.MC_POST_UPDATE, true)
		queuedWaveGuns = true
	end
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, mod.DistributeNewWaveGuns, EntityType.ENTITY_EFFECT)



function mod:PotentialGunslingerInit(entity)
	-- Always turn bosses into gunslingers
	if entity:IsBoss() and PlayerManager.AnyoneIsPlayerType(mod.PLAYER.BRIEND) and not mod:IsRoomThin() then
		local func = function()
			-- Make sure they have their segments set up already
			if queuedWaveGuns and (mod:isSegmented(entity) or mod:isBasegameSegmented(entity)) then
				entity:Update()
			end

			if mod:IsValidBountyEnemy(entity) then
				-- Try dual wielding
				local shouldDualWield = false
				local roomType = game:GetRoom():GetType()

				if (roomType == RoomType.ROOM_BOSS or roomType == RoomType.ROOM_MINIBOSS -- Boss / miniboss rooms
				or game:GetLevel():GetStage() == LevelStage.STAGE8 -- Home
				or game:IsGreedBoss() or game:IsGreedFinalBoss()) -- Greed Mode
				and not mod:IsOnList(mod.GunslingerSelection.DontDualWield, entity) -- Not blacklisted
				and mod:CountValidBountyBosses() <= 1 then -- Only one boss is active
					local rng = RNG(entity.InitSeed)
					local heatBonus = mod.savedata.run.briendHeat * mod.GunslingerSelection.DualWieldChance.HeatBonus
					local dualWieldChance = mod.GunslingerSelection.DualWieldChance.Base + heatBonus
					shouldDualWield = mod:Random(nil, nil, rng) <= dualWieldChance / 100
				end

				mod:MakeGunslinger(entity, nil, shouldDualWield)
			end
		end
		mod.scheduleForUpdate(func, 0, ModCallbacks.MC_POST_UPDATE, true)
	end



	-- Gunslinger Maker entity
	local currentRoom = StageAPI and StageAPI.GetCurrentRoom()

	if game:GetRoom():GetFrameCount() <= 0 and currentRoom then
		local grindex = game:GetRoom():GetGridIndex(entity.Position)
		local result = currentRoom.Metadata:Search{ Index = grindex, Name = metaEntityData.Name }

		if result and #result > 0 then
			for i, entry in pairs(result) do
				local func = function()
					local subtype = entry.Entity.SubType

					-- Random tier
					if subtype == 0 then
						local rng = RNG(entity.InitSeed)
						local tier = mod:Random(1, 5, rng)
						mod:MakeGunslinger(entity, tier)

					-- Eternal Revolver
					elseif subtype == 6 then
						mod:MakeGunslinger(entity, 5, false, mod.BountyGunTypes.REVOLVER_ETERNAL)

					-- Specific tiers
					else
						mod:MakeGunslinger(entity, subtype)
					end
				end
				mod.scheduleForUpdate(func, 0, ModCallbacks.MC_POST_UPDATE, true)
				break
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.PotentialGunslingerInit)



-- Console command
local commandName = "makegunslingers"
local description = "Turn every valid enemy into a gunslinger."
local shortHelpText = "Run without any parameters to see the full help section."
local fullHelpText = {
	"Can have multiple parameters in any order, separated with spaces:",
	"",
	"Tier:[number] - Affects the costume and the gun types if not defined.",
	"Force - Makes the command ignore entity blacklists.",
	"Replace - If not included, the command will only apply to enemies that don't already have guns.",
	"NoHealth - Makes the affected enemies not gain the gunslinger health multiplier.",
	"DualWield - Forces the entities to dual wield guns.",
	"GunType:[ID/Name] - Accepts either the gun type's ID or a lowercase version of their enum name (eg. revolver_basic).",
	"Primary:[ID/Name] - Same as GunType but only affects the primary gun if dual wielding. Takes priority over GunType.",
	"Secondary:[ID/Name] - Same as GunType but only affects the secondary gun if dual wielding. Takes priority over GunType.",
	"Costume:[Name] - The name of an animation in the costume ANM2."
}

local function commandFunc(_, cmd, rawParams)
	if cmd == commandName then
		local splitParams = mod:SplitString(rawParams)

		-- Print the help text if no parameters are given
		if not splitParams or #splitParams <= 0 then
			for i, line in pairs(fullHelpText) do
				print(line)
			end

		else
			local params = {}

			-- Split the parameters into usable data
			for i, param in pairs(splitParams) do
				local split = mod:SplitString(param, ":")
				local variable = split[1]
				local value = split[2]

				if value then
					local number = tonumber(value)

					-- Number values
					if number then
						value = number

					-- Gun names
					elseif variable == "GunType" or variable == "Primary" or variable == "Secondary" then
						value = string.lower(value)

						for name, id in pairs(mod.BountyGunTypes) do
							if string.lower(name) == value then
								value = id
								break
							end
						end
					end

				-- Flags
				else
					value = true
				end

				params[variable] = value
			end

			-- Go through every valid entity
			for i, entity in pairs( Isaac.GetRoomEntities() ) do
				if mod:IsValidBountyEnemy(entity, true, params.Force) then
					local data = mod:GetEntityData(entity)
					local add = true

					if data.GunslingerData and data.GunslingerData.Guns then
						if params.Replace then
							-- Remove their existing guns first
							for j, gun in pairs(data.GunslingerData.Guns) do
								if gun.Entity and gun.Entity:Exists() then
									gun.Entity:Remove()
								end
							end
							data.GunslingerData = nil

						else
							add = false
						end
					end

					-- Turn into a gunslinger
					if add then
						local mainGunType = params.Primary or params.GunType

						mod:MakeGunslinger(
							entity:ToNPC(),
							params.Tier,
							params.DualWield,
							mainGunType,
							params.Secondary,
							params.Costume,
							params.NoHealth
						)
					end
				end
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, commandFunc)

Console.RegisterCommand(commandName,
	description,
	description .. " " .. shortHelpText,
	false,
	AutocompleteType.NONE
)