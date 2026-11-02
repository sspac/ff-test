local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local sevenSeals2 = FiendFolio.ITEM.COLLECTIBLE.SEVEN_SEALS_2
local horsemini = FiendFolio.ITEM.FAMILIAR.MODERN_HORSEMINI

local STREAK_COLOUR = Color(0.2, 0.2, 0.2, 0.1, 0, 0, 0)
local HAEMO_COLOUR = Color(1,1,1,0.5,0.3,1,0)
HAEMO_COLOUR:SetColorize(1,1,1,1)

mod.ModernHorseminiSubType = {
	MELTDOWN 	= 0,
	DELUGE 		= 1,
	POLLUTION 	= 2,
	PROPAGANDA 	= 3,
}

local commonPath = "gfx/familiar/7seals2/familiar_horsemini_"
local horseminiFilepath = {
	[mod.ModernHorseminiSubType.MELTDOWN] 	= "meltdown.png",
	[mod.ModernHorseminiSubType.DELUGE] 	= "deluge.png",
	[mod.ModernHorseminiSubType.POLLUTION] 	= "pollution.png",
	[mod.ModernHorseminiSubType.PROPAGANDA] = "propaganda.png",
}

local previousNuclearTearPath = -1
local nuclearTearData = {}

local function setHorseminiSubType(familiar, subtype)
	familiar.SubType = subtype

	local sprite = familiar:GetSprite()
	for i = 0, 1 do
		sprite:ReplaceSpritesheet(i, commonPath .. horseminiFilepath[subtype])
	end

	sprite:LoadGraphics()
	sprite:Play("FloatDown")
end

local function randomiseHorsemini(familiar, allowCurrent)
	local choices = {}
	for i = 0, 3 do
		if i ~= familiar.SubType or allowCurrent then
			table.insert(choices, i)
		end
	end

	Isaac.Spawn(1000, 15, 0, familiar.Position, Vector.Zero, familiar)
	setHorseminiSubType(familiar, choices[familiar.Player:GetCollectibleRNG(sevenSeals2):RandomInt(#choices) + 1])
end

-- Code (mostly) borrowed from Wetstone Grimlin
local function spawnBubble(familiar)
	local rng = familiar.Player:GetCollectibleRNG(sevenSeals2)
	local velocity = Vector(0, math.max(0.2, (3 + rng:RandomInt(5)) / 3)):Rotated(rng:RandomInt(360))
	local bubble = Isaac.Spawn(150, 1, 0, familiar.Position, velocity, familiar)
	bubble:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
	bubble:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	bubble:Update()

	local sprite = bubble:GetSprite()
	sprite:Load("gfx/projectiles/bubble/bubble_tiny_friendly.anm2", true)
	sprite:Play("Idle", true)
end

local horseminiData = {
	[mod.ModernHorseminiSubType.MELTDOWN] = {
		BaseSpeed = 2,
		ChaseSpeed = 3,
		DoesChase = true,
		SpawnInterval = 3,
		SpawnSfx = mod.Sounds.MDP1_HitHorseScream,
		SfxVolume = 0.3,
		FleaSubType = 1,
		CollisionDamage = 1.5,

		PassiveEffect = function(familiar)
			if familiar.FrameCount % 30 == 0 and #nuclearTearData > 0 then
				local rng = familiar.Player:GetCollectibleRNG(sevenSeals2)
				local path = rng:RandomInt(4) + 1

				while path == previousNuclearTearPath do
					path = rng:RandomInt(4) + 1
				end
				previousNuclearTearPath = path

				--local tear = Isaac.Spawn(2, mod.TEAR.RADIOACTIVE, 0, nuclearTearData[path].Start, nuclearTearData[path].Shoot:Resized(7), familiar):ToTear()

				-- I hate you familiar:FireProjectile()
				local tear = familiar:FireProjectile(nuclearTearData[path].Shoot)
				tear:ChangeVariant(mod.TEAR.RADIOACTIVE)
				tear.Position = nuclearTearData[path].Start
				tear.Velocity = nuclearTearData[path].Shoot:Resized(7)

				local sprite = tear:GetSprite()
				sprite:Load("gfx/projectiles/radioactive_glowing.anm2", true)
				sprite:Play("RegularTear6")

				tear.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
				tear.FallingSpeed = -0.1
				tear.FallingAcceleration = -0.1
				tear:SetInitSound(SoundEffect.SOUND_NULL)
			end
		end,
	},

	[mod.ModernHorseminiSubType.DELUGE] = {
		BaseSpeed = 1,
		ChaseSpeed = 1,
		DoesChase = false,
		SpawnInterval = 2.5,
		SpawnSfx = mod.Sounds.DelugeShot,
		SfxVolume = 0.7,
		FleaSubType = 2,
		CollisionDamage = 1,

		ExtraSpawnAnimCondition = function(familiar) return not game:GetRoom():IsClear() end,
		ExtraSpawn = function(familiar)
			for i = 1, 2 + familiar.Player:GetCollectibleRNG(sevenSeals2):RandomInt(2) do
				spawnBubble(familiar)
			end
		end,
	},

	[mod.ModernHorseminiSubType.POLLUTION] = {
		BaseSpeed = 1.5,
		ChaseSpeed = 6.5,
		DoesChase = true,
		SpawnInterval = 3,
		SpawnSfx = mod.Sounds.PollutionVom,
		SfxVolume = 0.75,
		FleaSubType = 3,
		CollisionDamage = 0.75,

		PassiveEffect = function(familiar)
			if familiar.FrameCount % 7 == 0 and familiar.Target and familiar.Target:Exists() then
				local fire = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.RED_CANDLE_FLAME, 0, familiar.Position, Vector.Zero, familiar):ToEffect()
	            fire:SetTimeout(15)
	            fire.CollisionDamage = familiar.Player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) and 3.4 or 1.7
	            fire.SpriteScale = Vector(0.66, 0.66)
			end
		end
	},

	[mod.ModernHorseminiSubType.PROPAGANDA] = {
		BaseSpeed = 2,
		ChaseSpeed = 2,
		DoesChase = false,
		SpawnInterval = 3.5,
		SpawnSfx = mod.Sounds.PropagandaNarcMegaphone,
		SfxVolume = 0.5,
		FleaSubType = 4,
		CollisionDamage = 1,

		ExtraSpawnAnimCondition = function(familiar) return familiar.Target and familiar.Target:Exists() end,
		ExtraSpawn = function(familiar)
			local rng = familiar.Player:GetCollectibleRNG(sevenSeals2)
			local direction = (familiar.Target.Position - familiar.Position):Normalized()
			local position = familiar.Position + direction * 32

			for i = 1.5, 30, 2 do -- ??????
				local velocity = direction:Resized(i / 2):Rotated(rng:RandomFloat() * 50 - 25)
				-- local tear = Isaac.Spawn(2, 1, 0, position, velocity, familiar):ToTear()

				-- I hate you familiar:FireProjectile()
				local tear = familiar:FireProjectile(velocity)
				tear:ChangeVariant(1)
				tear.Position = position
				tear.Velocity = velocity
				tear.CollisionDamage = tear.CollisionDamage / 2

				tear.Scale = (6 + i) / 40
				tear:AddTearFlags(TearFlags.TEAR_SPECTRAL --[[| mod.GetFamiliarTearFlags(familiar)]])
				tear.FallingAcceleration = -0.052

				TearFlagsLib.AddEntityToUpdateList(tear, "FF_7SEALS2_PROPAGANDA")
			end
		end,
	},
}

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, familiar)
	familiar.TargetPosition = Isaac.GetRandomPosition()
	randomiseHorsemini(familiar, true)
end, horsemini)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, familiar)
	local sprite = familiar:GetSprite()
	local data = horseminiData[familiar.SubType]
	local target = familiar.Target and data.DoesChase and familiar.Target.Position or familiar.TargetPosition
	local direction = (target - familiar.Position):Normalized()
	local speed = familiar.Target and data.ChaseSpeed or data.BaseSpeed

	if sprite:IsFinished("PreSpawn") then sprite:Play("FloatDown") end

	familiar.Velocity = familiar.Velocity:Lerp(direction * speed, 0.1)
	familiar.CollisionDamage = data.CollisionDamage

	if familiar.Position:Distance(target) > 2.5 then
		familiar.FlipX = direction.X < 0
	end

	familiar:PickEnemyTarget(9e9, 13, 1)
	if familiar.Position:DistanceSquared(familiar.TargetPosition) < 100 or familiar.FrameCount % 90 == 0 then
		familiar.TargetPosition = Isaac.GetRandomPosition()
	end

	if familiar.FrameCount % (data.SpawnInterval * 30) == 0 then
		if not familiar.Child or not familiar.Child:Exists() or (data.ExtraSpawnAnimCondition and data.ExtraSpawnAnimCondition(familiar)) then
			sprite:Play("PreSpawn")
		end
	end

	if data.PassiveEffect then data.PassiveEffect(familiar) end

	if sprite:IsPlaying("PreSpawn") and familiar.SubType == mod.ModernHorseminiSubType.PROPAGANDA and familiar.Target and familiar.Target:Exists() then
		familiar.Velocity = familiar.Velocity:Lerp(Vector.Zero, 0.1)
		familiar.FlipX = (familiar.Target.Position - familiar.Position).X < 0
	end

	if sprite:IsEventTriggered("Spawn") then
		local pitchMod = math.random() * 0.15
		sfx:Play(data.SpawnSfx, data.SfxVolume, 0, false, 1.1 + pitchMod)

		if not familiar.Child or not familiar.Child:Exists() then
			familiar.Child = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.ATTACK_SKUZZ, data.FleaSubType, familiar.Position, Vector.Zero, familiar)
			familiar.Child:Update()
		end

		if data.ExtraSpawnAnimCondition and data.ExtraSpawnAnimCondition(familiar) then
			data.ExtraSpawn(familiar)
		end
	end

	if familiar.FrameCount % 300 == 0 then
		randomiseHorsemini(familiar)
	end
end, horsemini)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	local room = game:GetRoom()
	nuclearTearData = {
		{Start = Vector(room:GetCenterPos().X - 100, 50), Shoot = Vector(5, 10)},
		{Start = Vector(room:GetCenterPos().X + 100, 50), Shoot = Vector(-5, 10)},
		{Start = Vector(room:GetCenterPos().X - 100, 50), Shoot = Vector(-5, 10)},
		{Start = Vector(room:GetCenterPos().X + 100, 50), Shoot = Vector(5, 10)},
	}
end)

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tear)
	tear.Velocity = tear.Velocity * 1.01

	if tear.FrameCount % 5 == 0 then
		local trail = Isaac.Spawn(1000, 111, 0, tear.Position, Vector.Zero, tear):ToEffect()
		trail:GetSprite().Offset = Vector(0, tear.Height * 0.75)

		if tostring(tear.Color) ~= tostring(Color.Default) then -- I can't believe this works ngl
			trail.Color = tear.Color
		else
			trail.Color = HAEMO_COLOUR
		end

		trail.SpriteScale = Vector(0.5, 0.5)
		trail:Update()
	end

	local blood = Isaac.Spawn(1000, 7, 0, tear.Position, Vector.Zero, tear)
	blood.SpriteScale = Vector(0.4,0.4)
	blood.Color = STREAK_COLOUR
	blood:Update()

	if tear.FrameCount > 200 then
		tear:Remove()
	end
end, mod.TEAR.RADIOACTIVE)

mod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, function(_, tear)
	local sprite = tear:GetSprite()
	sprite:Load("gfx/projectiles/radioactive_glowing.anm2", true)
	sprite:Play("RegularTear6")
end, mod.TEAR.RADIOACTIVE)

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, entity)
	if entity.Variant == mod.TEAR.RADIOACTIVE and game:GetRoom():GetFrameCount() > 0 and entity.FrameCount < 70 then
		local poof = Isaac.Spawn(1000, mod:getNormalTearPoofVariant(entity:ToTear().Scale, entity:ToTear().Height), 0, entity.Position, Vector.Zero, entity)

		if tostring(entity.Color) ~= tostring(Color.Default) then -- I can't believe this works ngl
			poof.Color = entity.Color
		else
			poof.Color = HAEMO_COLOUR
		end

		poof:GetSprite().Offset = entity.PositionOffset / 1.5
		sfx:Play(SoundEffect.SOUND_TEARIMPACTS)
	end
end, 2)

mod:AddCallback(TearFlagsLib.Callback.UPDATE_ENTITY_LIST, function(_, entity)
	entity.Velocity = entity.Velocity * 0.95
end, "FF_7SEALS2_PROPAGANDA")