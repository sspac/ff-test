local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local wardensCrown = mod.ITEM.COLLECTIBLE.WARDENS_CROWN
local wardColour = KColor(0, 1, 1, 0.1)
local sizeScaleRatio = 0.75/7.1

local TWELVE_SECONDS = 12 * 30
local wards = {}

TearFlagsLib.RegisterTearFlag("WARDING")

mod.WARDENS_CROWN_DELAYED_SOUNDERS = (
	TearFlagsLib.WeaponFlag.KNIFE
	| TearFlagsLib.WeaponFlag.AQUARIUS
	| TearFlagsLib.WeaponFlag.LASER
	| TearFlagsLib.WeaponFlag.BRIMSTONE_BALL
	| TearFlagsLib.WeaponFlag.ANTI_GRAV_LASER
	| TearFlagsLib.WeaponFlag.OCULAR_RIFT
	| TearFlagsLib.WeaponFlag.LUDOVICO_TEAR
)

mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, function()
	mod.WARDENS_CROWN_DELAYED_SOUNDERS = mod.WARDENS_CROWN_DELAYED_SOUNDERS | (
		TearFlagsLib.WeaponFlag.FF_MALICE
		| TearFlagsLib.WeaponFlag.FF_HATRED
		| TearFlagsLib.WeaponFlag.FF_PLANET_X
	)
end)

local function shouldDelaySound(weaponFlag)
	return mod.WARDENS_CROWN_DELAYED_SOUNDERS:HasAnyFlag(weaponFlag)
end

local function shouldDoWardensCrown(player, entity, noScaling)
	local luck = TearFlagsLib.GetRealLuck(player, entity)
	local chance = TearFlagsLib.GetChance(luck, 0.05, 0.20, 7, not noScaling and player:GetCollectibleNum(wardensCrown))
	local rng = player:GetCollectibleRNG(wardensCrown)
	return rng:RandomFloat() < chance
end

local function canEnemyBeWarded(entity)
	return (
		entity.EntityCollisionClass ~= 0
		and not entity:HasEntityFlags(EntityFlag.FLAG_NO_TARGET)
		and not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)
	)
end

local function enableWardensCrownCallbacks()
	mod:EnableManualCallback(ModCallbacks.MC_POST_RENDER, mod.RenderWards)
	mod:EnableManualCallback(ModCallbacks.MC_NPC_UPDATE, mod.WardensCrownCatchSwarmFlies)
end

local function disableWardensCrownCallbacks()
	mod:DisableManualCallback(ModCallbacks.MC_POST_RENDER, mod.RenderWards)
	mod:DisableManualCallback(ModCallbacks.MC_NPC_UPDATE, mod.WardensCrownCatchSwarmFlies)
end

mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, wardensCrown, function(_, entity, player, weaponFlag)
	if player:HasCollectible(wardensCrown) and shouldDoWardensCrown(player, entity) then
		TearFlagsLib.AddTearFlags(entity, TearFlagsLib.Flag.WARDING)

		if not FiendFolio.HasCetusFlag(entity) then
			if weaponFlag == TearFlagsLib.WeaponFlag.TEAR then
				mod:changeTearVariant(entity:ToTear(), mod.TEAR.WARDING)
				sfx:Play(mod.Sounds.DevilDaggerGemCollect, 0.3, 0, false, math.random(110,125)/100)
			elseif shouldDelaySound(weaponFlag) then
				TearFlagsLib.SetTearFlagParams(entity, TearFlagsLib.Flag.WARDING, {DelayedSound = true})
			else
				sfx:Play(mod.Sounds.DevilDaggerGemCollect, 0.6, 0, false, math.random(110,125)/100)
			end
		end
	end
end)

mod:AddEntityCallback(TearFlagsLib.Callback.POLL_LOCUST_TEARFLAGS, EntityType.ENTITY_FAMILIAR, FamiliarVariant.ABYSS_LOCUST, wardensCrown, function(_, entity, player)
	if player:GetCollectibleRNG(wardensCrown):RandomFloat() < 0.2 then
		TearFlagsLib.AddTearFlags(entity, TearFlagsLib.Flag.WARDING)
		sfx:Play(mod.Sounds.DevilDaggerGemCollect, 0.6, 0, false, math.random(110,125)/100)
	end
end, wardensCrown)

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.WARDENS_CROWN] = {
	BodyColor = Color(1,1,1,1,-17.920/255,-48.735/255,-32.319/255,0.894,0.646,0.425,1),
	EyeAColor = Color(1,1,1,1,-75.460/255,-52.566/255,10.982/255,0.947,1.088,0.690,1),
	EyeBColor = Color(1,1,1,1,-75.460/255,-52.566/255,10.982/255,0.947,1.088,0.690,1)
}

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	local player = familiar.Player
	
	local chance = TearFlagsLib.GetChance(0, 0.05, 0.20, 7, 1)
	local rng = player:GetCollectibleRNG(FiendFolio.ITEM.COLLECTIBLE.WARDENS_CROWN)

	if rng:RandomFloat() < chance then
		TearFlagsLib.AddTearFlags(tear, TearFlagsLib.Flag.WARDING)
		mod:changeTearVariant(tear, mod.TEAR.WARDING)
		--tear:AddTearFlags(TearFlags.TEAR_HOMING)
		sfx:Play(mod.Sounds.DevilDaggerGemCollect, 0.3, 0, false, math.random(110,125)/100)
	end
end, FiendFolio.ITEM.COLLECTIBLE.WARDENS_CROWN)

mod:AddCallback(TearFlagsLib.Callback.POST_COPY_TEARFLAGS, function(_, recipient, donor, weaponFlag)
	if weaponFlag == TearFlagsLib.WeaponFlag.TEAR then
		mod:changeTearVariant(recipient:ToTear(), mod.TEAR.WARDING)
		sfx:Play(mod.Sounds.DevilDaggerGemCollect, 0.3, 0, false, math.random(110,125)/100)
	elseif shouldDelaySound(weaponFlag) then
		TearFlagsLib.SetTearFlagParams(recipient, TearFlagsLib.Flag.WARDING, {DelayedSound = true})
	else
		sfx:Play(mod.Sounds.DevilDaggerGemCollect, 0.6, 0, false, math.random(110,125)/100)
	end
end, TearFlagsLib.Flag.WARDING)

mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, function(_, entity, player, source, weaponFlag, params)
	TearFlagsLib.TemporarilyBlacklistEntity(entity, source, TearFlagsLib.Flag.WARDING, 300)

	table.insert(wards, {
		Position = entity.Position,
		Lifespan = 300,
		Radius = 60,
		Hostages = {entity},
		SeedCache = {[entity.InitSeed] = true}
	})
	enableWardensCrownCallbacks()

	if params.DelayedSound or FiendFolio.HasCetusFlag(entity) then
		sfx:Play(mod.Sounds.DevilDaggerGemCollect, 0.6, 0, false, math.random(110,125)/100)
	end
end, TearFlagsLib.Flag.WARDING)

function mod.handleWardingD3(entity)
	TearFlagsLib.SetTearFlagParams(entity, TearFlagsLib.Flag.WARDING, {DelayedSound = true})
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	for i = #wards, 1, -1 do
		local ward = wards[i]

		for _, entity in pairs(Isaac.FindInRadius(ward.Position, ward.Radius, EntityPartition.ENEMY)) do
			if not ward.SeedCache[entity.InitSeed] and entity.Position:Distance(ward.Position) < ward.Radius then -- FindInRadius uses edge-edge distance, not position-position, which is what I want
				local data = mod:GetEntityData(entity)
				if canEnemyBeWarded(entity) and (not data.ffLastWardensCrown or entity.FrameCount - data.ffLastWardensCrown >= TWELVE_SECONDS) then
					table.insert(ward.Hostages, entity)
					if entity:IsBoss() then
						data.ffLastWardensCrown = entity.FrameCount
					end

					ward.SeedCache[entity.InitSeed] = true
				end
			end
		end

		for j = #ward.Hostages, 1, -1 do
			local entity = ward.Hostages[j]
			local distance = entity.Position:Distance(ward.Position)

			if not canEnemyBeWarded(entity) then
				table.remove(ward.Hostages, j)
			elseif distance > ward.Radius then
				local shiftDirection = (ward.Position - entity.Position):Normalized()
				local shiftMagnitude = distance - ward.Radius

				entity.Position = entity.Position + shiftDirection * shiftMagnitude
			end

			if entity:IsBoss() then
				local data = mod:GetEntityData(entity)
				data.ffLastWardensCrown = data.ffLastWardensCrown or entity.FrameCount

				if entity.FrameCount >= data.ffLastWardensCrown + 90 then
					table.remove(ward.Hostages, j)
				end
			end
		end

		ward.Lifespan = ward.Lifespan - 1
		if ward.Lifespan % 2 == 0 then
			local sparkle = Isaac.Spawn(1000, 1727, 0, ward.Position + RandomVector() * ward.Radius, Vector.Zero, nil):ToEffect()
			sparkle.RenderZOffset = -5
			sparkle.SpriteScale = Vector.One * 0.5
		end

		if ward.Lifespan <= 0 then
			table.remove(wards, i)
			if #wards <= 0 then
				disableWardensCrownCallbacks()
			end
		end
	end
end)

local function dirtyDrawCircle(position, radius, segments, colour) -- I thought repentogon had a draw circle function, apparently only lines and quads
	local rotaterVector = Vector(0, radius)
	segments = segments or 24
	local step = 360 / segments
	local colour = colour or wardColour

	for i = 1, segments do
		local startPos = Isaac.WorldToScreen(position + rotaterVector:Rotated(step * i))
		local endPos = Isaac.WorldToScreen(position + rotaterVector:Rotated(step * (i + 1)))

		Isaac.DrawLine(startPos, endPos, colour, colour, 1)
	end
end
mod.RenderCircle = dirtyDrawCircle -- Shhh, don't tell me I stole this from myself, he'll flip

function mod.RenderWards()
	for _, ward in pairs(wards) do
		if ward.Lifespan > 15 or ward.Lifespan % 6 < 3 then
			dirtyDrawCircle(ward.Position, ward.Radius)
		end
	end
end
mod:AddManualCallback(ModCallbacks.MC_POST_RENDER, mod.RenderWards)

-- A Guwahavel special:
-- When blocked, Swarm Flies continue to update their TargetPosition and can "slingshot" towards it if far enough when let go
-- This is a stopgap measure for that
function mod.WardensCrownCatchSwarmFlies(_, npc)
	if npc.TargetPosition:Distance(npc.Position) > 90 then
        npc.TargetPosition = npc.Position + (npc.TargetPosition - npc.Position):Resized(90)
    end
end
mod:AddManualCallback(ModCallbacks.MC_NPC_UPDATE, mod.WardensCrownCatchSwarmFlies, EntityType.ENTITY_SWARM)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	wards = {}
	disableWardensCrownCallbacks()
end)

local function spawnSplash(tear, anim)
	local splash = Isaac.Spawn(1000, 12, 0, tear.Position, Vector.Zero, tear):ToEffect()
	splash.SpriteScale = Vector.One * tear.Scale * tear.SpriteScale.X

	sfx:Play(mod.Sounds.DevilDaggerGemCollect, 0.6, 0, false, math.random(75,90)/100)

	splash:GetSprite():Load("gfx/enemies/warden/cross.anm2", true)
	splash:GetSprite():Play(anim or "Impact")
	splash:Die()
end

local function spawnSparkle(tear, positionOverride, velocityOverride)
	local sparkle = Isaac.Spawn(1000, 1727, 0, positionOverride or tear.Position, velocityOverride or Vector.Zero, tear):ToEffect()
	local sdata = mod:GetEntityData(sparkle)
	sdata.RenderZOffset = -5
	sparkle.SpriteOffset = Vector(-10 + math.random(20), (tear.Height or 0) - 10 + math.random(20))
	return sparkle
end

mod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, function(_, tear)
	tear:GetSprite():Play("wee")
end, mod.TEAR.WARDING)

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tear)
	tear.SpriteScale = Vector.One * 0.75

	if tear.FrameCount % 2 == 0 then
		spawnSparkle(tear)
	end

	if tear:IsDead() then
		spawnSplash(tear)
	elseif tear:GetSprite():GetAnimation() ~= "wee" then
		tear:GetSprite():Play("wee")
	end
end, mod.TEAR.WARDING)

mod:AddCallback(ModCallbacks.MC_POST_TEAR_COLLISION, function(_, tear, collider)
	if tear:IsDead() then -- Just in case
		spawnSplash(tear, "ImpactWithPlayer")
	end
end, mod.TEAR.WARDING)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
	if TearFlagsLib.HasTearFlags(effect, TearFlagsLib.Flag.WARDING) and effect.FrameCount % 2 == 0 and effect.Timeout > 0 then
		local sparkle = spawnSparkle(effect, effect.Position + RandomVector() * 7.5, RandomVector() * math.random() * 3)
		sparkle.SpriteOffset = Vector.Zero
	end
end, EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL)