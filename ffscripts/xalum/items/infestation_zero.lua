local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

-- Trying out a different way of laying stuff out, seeing how I feel about it
local InfestationZero = {
	ID = mod.ITEM.COLLECTIBLE.INFESTATION_0,
	TearFlag = TearFlagsLib.RegisterTearFlag("FF_INFESTATION_ZERO"),
	Chance = 0.1,
	LocustChance = 0.15,

	PreviousRoomIndex = -1,

	GlitchDuration = 3,
	GlitchColour = {Color(0, 0, 0, 0.75, 1, 0, 0, 1, 0, 0), Color(0, 0, 0, 0.75, 0, 1, 1, 0, 1, 1), Color(0, 0, 0, 1, 1, 1, 1, 1, 1, 1)},
	GlitchOffset = {Vector(-1.5, 0), Vector(1.5, 0), Vector.Zero},
	GlitchRenderers = {},
}

function InfestationZero.GetPersistentData()
	if mod.savedata and mod.savedata.level2 then
		mod.savedata.level2.infestationZero = mod.savedata.level2.infestationZero or {}
		return mod.savedata.level2.infestationZero
	else
		return {}
	end
end

function InfestationZero.GlitchEnemy(entity)
	Isaac.CreateTimer(function() -- This should be queued for the end of the frame so that any weapons that apply effects and then deal damage still have their damage counted
		if InfestationZero.IsEntityBlacklisted(entity) then return end 

		local data = InfestationZero.GetPersistentData()
		local key = tostring(InfestationZero.PreviousRoomIndex)

		if not data[key] then
			data.Indexes = (data.Indexes or 0) + 1
			data[key] = {}
		end

		table.insert(data[key], {
			T = entity.Type,
			V = entity.Variant,
			S = entity.SubType,

			MaxHp 		= entity.MaxHitPoints,
			Hp 			= entity.HitPoints,
			Champion 	= entity:GetChampionColorIdx(),
			Size 		= entity.Size,
			SpriteScale	= entity.SpriteScale,
			Scale 		= entity.Scale,
		})

		mod:EnableManualCallback(ModCallbacks.MC_POST_NEW_ROOM, InfestationZero.CheckRespawns)
		InfestationZero.AddGlitchEffect(entity:GetSprite():Copy(), entity.Position)
		entity:Remove()
	end, 0, 1)
end

function InfestationZero.ReplicateEnemy(data, position)
	Isaac.CreateTimer(function()
		local config = EntityConfig.GetEntity(data.T, data.V, data.S)
		local sprite = Sprite(config:GetAnm2Path(), true)
		local room = game:GetRoom()

		sprite:Play(sprite:GetDefaultAnimation())
		sprite:Stop()

		InfestationZero.AddGlitchEffect(sprite, position)

		Isaac.CreateTimer(function()
			local new = Isaac.Spawn(data.T, data.V, data.S, position, Vector.Zero, nil):ToNPC()
			if data.Champion ~= -1 then new:MakeChampion(new.InitSeed, data.Champion) end

			new.MaxHitPoints = data.MaxHp
			new.HitPoints = data.Hp
			new.Scale = data.Scale
			new.SpriteScale = data.SpriteScale
			new.Size = data.Size

			InfestationZero.ShutDoors()
		end, InfestationZero.GlitchDuration, 1)
	end, 0, 1)
end

function InfestationZero.AddGlitchEffect(sprite, position)
	mod:EnableManualCallback(ModCallbacks.MC_POST_ROOM_RENDER_ENTITIES, InfestationZero.RenderGlitches)
	sfx:Play(SoundEffect.SOUND_DOGMA_JACOBS)
	sprite:Stop()

	table.insert(InfestationZero.GlitchRenderers, {
		Sprite = sprite,
		Position = position,
		Frame = game:GetFrameCount(),
	})
end

function InfestationZero.RenderGlitches()
	for i = #InfestationZero.GlitchRenderers, 1, -1 do
		local data = InfestationZero.GlitchRenderers[i]
		local screenPosition = Isaac.WorldToScreen(data.Position)

		for j = 1, 3 do
			data.Sprite.Color = InfestationZero.GlitchColour[j]
			data.Sprite:Render(screenPosition + InfestationZero.GlitchOffset[j])
		end

		if game:GetFrameCount() - data.Frame >= InfestationZero.GlitchDuration then
			table.remove(InfestationZero.GlitchRenderers, i)
		end
	end

	if #InfestationZero.GlitchRenderers == 0 then
		mod:DisableManualCallback(ModCallbacks.MC_POST_ROOM_RENDER_ENTITIES, InfestationZero.RenderGlitches)
	end
end

function InfestationZero.IsPositionPathable(position)
	local room = game:GetRoom()
	return (
		room:IsPositionInRoom(position, 0)
		and room:GetGridCollisionAtPos(position) % 5 == 0
		and not StageAPI.IsCustomGrid(room:GetGridIndex(position))
	)
end

function InfestationZero.FilterPathableIndexes(testIndexes)
	local indexMap = {}
	for _, index in pairs(testIndexes) do
		indexMap[index] = true
	end

	local room = game:GetRoom()
	local loopingPositions = {Isaac.GetPlayer().Position}
	local testedIndexes = {}
	local returnIndexes = {}

	while #loopingPositions > 0 do
		local temporaryLoop = {}

		for _, position in pairs(loopingPositions) do
			if InfestationZero.IsPositionPathable(position) then
				local index = room:GetGridIndex(position)
				if not testedIndexes[index] then
					testedIndexes[index] = true
					if indexMap[index] then table.insert(returnIndexes, index) end

					for i = 1, 4 do
						local newPos = position + Vector(40, 0):Rotated(i * 90)
						if not testedIndexes[room:GetGridIndex(newPos)] then
							table.insert(temporaryLoop, newPos)
						end
					end
				end
			end
		end

		loopingPositions = temporaryLoop
	end

	return returnIndexes
end

function InfestationZero.GetRoomSpawnIndexes(data)
	local room = game:GetRoom()
	local indexes = {}

	for i = 0, #data.Spawns - 1 do
		local spawn = data.Spawns:Get(i)
		local entry = spawn:PickEntry(1)
		if entry.Type >= 10 and entry.Type < 999 and not mod.NonEnemyNpcTypes[entry.Type] then
			local index = room:GetGridIndexByTile(spawn.X + 1, spawn.Y + 1)
			if index then table.insert(indexes, index) end
		end
	end

	return indexes
end

function InfestationZero.ShutDoors()
	if not PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_MERCURIUS) then
		StageAPI.CloseDoors()

		if PlayerManager.AnyoneHasTrinket(TrinketType.TRINKET_DOOR_STOP) then
			local entryDoor = game:GetRoom():GetDoor(game:GetLevel().EnterDoor)
			if entryDoor then entryDoor:Open() end
		end
	end
end

function InfestationZero.CheckRespawns()
	local level = game:GetLevel()
	local desc 	= level:GetCurrentRoomDesc()
	local data 	= InfestationZero.GetPersistentData()
	if #(data[tostring(desc.ListIndex)] or {}) == 0 then return end

	local room = game:GetRoom()
	local indexes = InfestationZero.GetRoomSpawnIndexes(desc.Data)
	if #indexes ~= 0 then indexes = InfestationZero.FilterPathableIndexes(indexes) end

	for i, enemyData in pairs(data[tostring(desc.ListIndex)]) do
		local pos = #indexes > 0 and room:GetGridPosition(indexes[(i % #indexes) + 1]) or FiendFolio:FindNearestReachableTile(Isaac.GetPlayer(), room:GetCenterPos())
		InfestationZero.ReplicateEnemy(enemyData, pos)
	end

	data[tostring(desc.ListIndex)] = nil
	data.Indexes = (data.Indexes or 1) - 1

	if data.Indexes == 0 then
		mod:DisableManualCallback(ModCallbacks.MC_POST_NEW_ROOM, InfestationZero.CheckRespawns)
	end
end

function InfestationZero.IsEntityBlacklisted(entity)
	return (
		not entity
		or entity:IsBoss()
		or entity:HasMortalDamage()
		or entity:IsDead()
		or mod:isLeavingStatusCorpse(entity)
		or not entity:IsVulnerableEnemy()
		or not entity:IsActiveEnemy()
		or not entity:Exists()
	)
end

mod:AddManualCallback(ModCallbacks.MC_POST_ROOM_RENDER_ENTITIES, InfestationZero.RenderGlitches)
mod:AddManualCallback(ModCallbacks.MC_POST_NEW_ROOM, InfestationZero.CheckRespawns)

mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, InfestationZero.ID, function(_, entity, player, weaponFlag)
	if player:HasCollectible(InfestationZero.ID) and player:GetCollectibleRNG(InfestationZero.ID):RandomFloat() < InfestationZero.Chance then
		TearFlagsLib.AddTearFlags(entity, InfestationZero.TearFlag)

		if weaponFlag == TearFlagsLib.WeaponFlag.TEAR then
			TearFlagsLib.TryChangeTearVariant(entity:ToTear(), mod.TEAR.INFESTATION_0)
		end
	end
end)

mod:AddEntityCallback(TearFlagsLib.Callback.POLL_LOCUST_TEARFLAGS, EntityType.ENTITY_FAMILIAR, FamiliarVariant.ABYSS_LOCUST, InfestationZero.ID, function(_, entity, player)
	if player:GetCollectibleRNG(InfestationZero.ID):RandomFloat() < InfestationZero.LocustChance then
		TearFlagsLib.AddTearFlags(entity, InfestationZero.TearFlag)
	end
end, InfestationZero.ID)

mod.SewingManualWhitelist[InfestationZero.ID] = {
	BodyColor = Color(1,1,1,0),
	EyeAColor = Color(1,1,1,0),
	EyeBColor = Color(1,1,1,0),
	EarsColor = Color(1,1,1,0),
	OutlineColor = Color(0,0,0,1,1,1,1)}

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	if familiar.Player:GetCollectibleRNG(InfestationZero.ID):RandomFloat() < 0.1 then
		TearFlagsLib.AddTearFlags(tear, InfestationZero.TearFlag)
		TearFlagsLib.TryChangeTearVariant(tear, mod.TEAR.INFESTATION_0)
	end
end, InfestationZero.ID)

mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, function(_, entity, player, source, weaponFlag)
	entity = entity:ToNPC()

	if not InfestationZero.IsEntityBlacklisted(entity) then
		InfestationZero.GlitchEnemy(entity)

		Isaac.CreateTimer(function() -- If I do this on the same frame as calling the Glitch effect, some weapons will cause enemies to INSTANTLY devolve without even leaving the room
			Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, mod.ITEM.FAMILIAR.MINI_LEVEL_0_FLY, entity.Position, Vector.Zero, player)
		end, 2, 1)
	end
end, TearFlagsLib.Flag.FF_INFESTATION_ZERO)

mod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, function(_, tear)
	tear:GetSprite():Load("gfx/projectiles/tear_infestation0.anm2", true)
	mod:handleTearScale13Anims(tear)
end, mod.TEAR.INFESTATION_0)

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tear)
	mod:handleTearScale13Anims(tear)
end, mod.TEAR.INFESTATION_0)

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, entity)
	if entity.Variant == mod.TEAR.INFESTATION_0 and game:GetRoom():GetFrameCount() > 0 then
		local poof = Isaac.Spawn(1000, mod:getNormalTearPoofVariant(entity:ToTear().Scale, entity:ToTear().Height), 0, entity.Position, Vector.Zero, entity)
		poof.Color = InfestationZero.GlitchColour[3]
		poof:GetSprite().Offset = entity.PositionOffset / 1.5
		sfx:Play(SoundEffect.SOUND_TEARIMPACTS)
	end
end, 2)

mod:AddCollectibleCallback(ModCallbacks.MC_PRE_CHANGE_ROOM, InfestationZero.ID, function()
	InfestationZero.PreviousRoomIndex = game:GetLevel():GetCurrentRoomDesc().ListIndex
end)