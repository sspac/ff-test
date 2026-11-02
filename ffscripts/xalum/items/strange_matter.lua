local mod = FiendFolio
local game = Game()
local strangeMatter = mod.ITEM.COLLECTIBLE.STRANGE_MATTER
local strangeColour = Color(0.5, 0.5, 0.5, 1, 0, 255/255, 33/255)

local BASE_CHANCE = 0.03
local MAX_CHANCE = 0.25
TearFlagsLib.RegisterTearFlag("STRANGE_MATTER")

local function shouldDoStrangeMatter(player, entity)
	local luck = TearFlagsLib.GetRealLuck(player, entity)
	local chance = TearFlagsLib.GetChance(luck, BASE_CHANCE, MAX_CHANCE, 13, player:GetCollectibleNum(strangeMatter))
	local rng = player:GetCollectibleRNG(strangeMatter)
	return rng:RandomFloat() < chance
end

function mod:spawnStrangeTrail(position, spawnerEntity, scale)
	local trail = Isaac.Spawn(1000, 111, 0, position, RandomVector(), spawnerEntity):ToEffect()
	trail:Update()
	trail.Color = strangeColour
	trail.PositionOffset = spawnerEntity.PositionOffset
	trail.DepthOffset = -20
	trail.SpriteScale = Vector.One * 0.65

	if scale ~= nil then
		trail.SpriteScale = trail.SpriteScale * scale
	end
end

mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, strangeMatter, function(_, entity, player, weaponFlag)
	if player:HasCollectible(strangeMatter) and shouldDoStrangeMatter(player, entity) then
		TearFlagsLib.AddTearFlags(entity, TearFlagsLib.Flag.STRANGE_MATTER)
	end
end)

mod:AddEntityCallback(TearFlagsLib.Callback.POLL_LOCUST_TEARFLAGS, EntityType.ENTITY_FAMILIAR, FamiliarVariant.ABYSS_LOCUST, strangeMatter, function(_, entity, player)
	if player:GetCollectibleRNG(strangeMatter):RandomFloat() < BASE_CHANCE then
		TearFlagsLib.AddTearFlags(entity, TearFlagsLib.Flag.STRANGE_MATTER)
	end
end, strangeMatter)

mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, function(_, entity, player, source, weaponFlag)
	if weaponFlag == TearFlagsLib.WeaponFlag.FF_PLANET_X then
		local fdata = mod:GetEntityData(source)
		for _, pastCol in ipairs(fdata.PastCollisionsThisRoll) do
			if pastCol.Index == entity.Index and pastCol.InitSeed == entity.InitSeed then
				return
			end
		end
	end
	
	if not entity:IsBoss() then
		if not Isaac.RunCallbackWithParam(mod.CALLBACK.PRE_STRANGE_MATTER_KILL, entity.Type, entity) then
			mod:makeEnemyGib(entity)
			entity:Die()
		end
	end

	local splash = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BIG_SPLASH, 0, entity.Position, Vector.Zero, nil)
	splash.Color = strangeColour

	local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_GREEN, 0, entity.Position, Vector.Zero, nil):ToEffect()
	creep.SpriteScale = creep.SpriteScale * 2
	creep:Update()
end, TearFlagsLib.Flag.STRANGE_MATTER)

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tear)
	if TearFlagsLib.HasTearFlags(tear, TearFlagsLib.Flag.STRANGE_MATTER) then
		mod:spawnStrangeTrail(tear.Position, tear, tear.Scale)
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, function(_, knife)
	if TearFlagsLib.HasTearFlags(knife, TearFlagsLib.Flag.STRANGE_MATTER) then
		if knife.SubType == 4 then
			if knife.FrameCount % 2 == 1 and knife.FrameCount < 7 then
				local player = TearFlagsLib.GetTearPlayer(knife)
				local position, radius = TearFlagsLib.GetSwingingKnifeCapsulePositionRadius(knife)
				local push = (position - player.Position):Normalized() * radius * 0.5

				for i = 1, 15 do
					local offset = RandomVector() * math.random() * radius
					mod:spawnStrangeTrail(position + push + offset, knife)
				end
			end
		elseif not TearFlagsLib.IsKnifeSwinging(knife) then
			mod:spawnStrangeTrail(knife.Position, knife)
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
	if TearFlagsLib.HasTearFlags(effect, TearFlagsLib.Flag.STRANGE_MATTER) and effect.Timeout > 0 then
		local radius = 15
		local offset = RandomVector() * math.random() * radius
		mod:spawnStrangeTrail(effect.Position + offset, effect)
	end
end, EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL)

mod:AddCallback(mod.CALLBACK.PRE_STRANGE_MATTER_KILL, function(_, entity)
	if entity.Variant == FiendFolio.FF.Hitbox.Var then
		return true
	end
end, FiendFolio.FFID.Tech)

mod:AddCollectibleCallback(ModCallbacks.MC_EVALUATE_CACHE, strangeMatter, function(_, player)
	if player:HasCollectible(strangeMatter) then
		player.LaserColor = strangeColour
	end
end, CacheFlag.CACHE_TEARCOLOR)

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.STRANGE_MATTER] = {
	BodyColor = Color(1,1,1,1,2.664/255,13.442/255,6.894/255,0.115,0.743,0.142,1),
	EyeAColor = Color(1,1,1,1,-128.781/255,147.422/255,91.641/255,1.219,0.422,-0.359,1),
	EyeBColor = Color(1,1,1,1,-128.781/255,147.422/255,91.641/255,1.219,0.422,-0.359,1)}

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	local player = familiar.Player
	local chance = TearFlagsLib.GetChance(0, 0.03, 0.25, 13, 1)
	local rng = player:GetCollectibleRNG(FiendFolio.ITEM.COLLECTIBLE.STRANGE_MATTER)

	if rng:RandomFloat() < chance then
		TearFlagsLib.AddTearFlags(tear, TearFlagsLib.Flag.STRANGE_MATTER)
	end
end, FiendFolio.ITEM.COLLECTIBLE.STRANGE_MATTER)