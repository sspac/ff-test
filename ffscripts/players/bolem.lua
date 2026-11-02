local mod = FiendFolio

local game = Game()
local sfx = SFXManager()
local itemconfig = Isaac.GetItemConfig()
local itempool = game:GetItemPool()
local rng = RNG()

mod.BolemsPebbles = {
	FiendFolio.ITEM.ROCK.KNIFE_PEBBLE,
	FiendFolio.ITEM.ROCK.TEARDROP_PEBBLE,
	FiendFolio.ITEM.ROCK.ARROW_PEBBLE,
	FiendFolio.ITEM.ROCK.CLOVER_PEBBLE,
	FiendFolio.ITEM.ROCK.SHOE_PEBBLE,
	FiendFolio.ITEM.ROCK.FRUITY_PEBBLE,
}

mod.BolemsMixedPebbles = {
	FiendFolio.ITEM.ROCK.MIXED_PEBBLE_1, --Speed + DMG
	FiendFolio.ITEM.ROCK.MIXED_PEBBLE_2, --Speed + luck
	FiendFolio.ITEM.ROCK.MIXED_PEBBLE_3, --Tears + Luck
	FiendFolio.ITEM.ROCK.MIXED_PEBBLE_4, --Range + DMG
	FiendFolio.ITEM.ROCK.MIXED_PEBBLE_5, --Range + Luck
	FiendFolio.ITEM.ROCK.MIXED_PEBBLE_6, --Speed + Range
}

mod.BolemRockBlacklist = {
	FiendFolio.ITEM.ROCK.REBAR_ROCK,
	FiendFolio.ITEM.ROCK.ROCK_CAKE,
	FiendFolio.ITEM.ROCK.HEALTH_GEODE,
}

mod.BolemItemDropBlacklist = {
	mod.ITEM.COLLECTIBLE.OVERCLOCK,
	CollectibleType.COLLECTIBLE_BIRTHRIGHT,
}


local function AnyBolemDo(foo)
    mod.AnyPlayerDo(function(player)
        if player:GetPlayerType() == FiendFolio.PLAYER.BOLEM then
            foo(player)
        end
    end)
end

local bolemHead = Isaac.GetCostumeIdByPath("gfx/characters/player_bolem_hole.anm2")
local overclockHead = Isaac.GetCostumeIdByPath("gfx/characters/player_bolem_overclock.anm2")

local function InMirrorWorld()
	return game:GetLevel():GetDimension() == Dimension.MIRROR
end

local function InFFG()
	if not FFGRACE then
		return false
	end
	return (FFGRACE.STAGE.Boiler and FFGRACE.STAGE.Boiler:IsStage()) or (FFGRACE.STAGE.Grotto and FFGRACE.STAGE.Grotto:IsStage())
end

function mod:BolemInit(player)
	mod:TryInitGolemSubway()
	mod:TrySpawnGolemSubwayTrapdoor(true)
	
    local sprite = player:GetSprite()
    sprite:Load("gfx/characters/player_bolem.anm2", true)
    sprite:Play(sprite:GetDefaultAnimationName(), true)
	
    player:AddTrinket(FiendFolio.ITEM.ROCK.POCKET_SAND)
    player:AddTrinket(FiendFolio.ITEM.ROCK.DIRT_CLUMP)

    itempool:RemoveTrinket(FiendFolio.ITEM.ROCK.DIRT_CLUMP)

	for i, rock in pairs(FiendFolio.savedata.GolemPoolData.Trinkets) do
		if mod:Contains(mod.BolemRockBlacklist, rock[1]) or mod:Contains(mod.BolemsPebbles, rock[1]) then
			table.remove(FiendFolio.savedata.GolemPoolData.Trinkets, i)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PLAYER_INIT_POST_LEVEL_INIT_STATS, mod.BolemInit, mod.PLAYER.BOLEM)

CustomHealthAPI.PersistentData.CharactersThatCantHaveRedHealth[FiendFolio.PLAYER.BOLEM] = true
CustomHealthAPI.PersistentData.CharactersThatConvertMaxHealth[FiendFolio.PLAYER.BOLEM] = "SOUL_HEART"

function FiendFolio.BolemExists()
	local numPlayers = game:GetNumPlayers()

    local numBolems = 0
    local hasNonBolem = false
    for i = 0, numPlayers - 1 do
        local player = Isaac.GetPlayer(i)
        if player:GetPlayerType() == FiendFolio.PLAYER.BOLEM then
            numBolems = numBolems + 1
        elseif player.Variant == 0 then
            hasNonBolem = true
        end
    end

    local isAnyBolem = numBolems > 0
    local isMixedBolem = isAnyBolem and hasNonBolem


    return isAnyBolem, isMixedBolem
end

local function hidedescEIDCallback(descObj)
	descObj.Name = ""
	descObj.Description = ""
	descObj.Icon = nil -- also tested {"Blank", 0, 0, 0}
	return descObj
end
local function hidedescEIDCondition(descObj)
	-- Loosely working around descObj.Entity possibly being a GridEntity (due to Sanguine Bond)
	if descObj.Entity and descObj.Entity.ToPickup and descObj.Entity:ToPickup() and mod:GetEntityData(descObj.Entity).FFHideEIDDesc then
		return true
	end
end
if EID then
	EID:addDescriptionModifier("FF Hide Desc Modifier", hidedescEIDCondition, hidedescEIDCallback)
end
mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CallbackPriority.LATE, function(_, ent, amt, flags, source)
	local player = ent:ToPlayer()
	local data = mod:GetEntityData(player)
	local sd = data.ffsavedata

	if player and player:GetPlayerType() == FiendFolio.PLAYER.BOLEM and not mod:isDamageSelfInflicted(flags, source) then
		if rng:RandomFloat() <= sd.RockDropChance and not sd.RockRoomCap then
			local willbreak = false
			if mod:RandomInt(1, 3) == 1 then
				willbreak = true
			end
			player:FlushQueueItem()

			if BirthcakeRebaked and mod:playerHasBirthcake(player) then
				local t1, t0 = player:GetTrinket(1), player:GetTrinket(0)
				local smeltedTrinkets = player:GetSmeltedTrinkets()
				local wasGolden = false
				if t1 == BirthcakeRebaked.Birthcake.ID + TrinketType.TRINKET_GOLDEN_FLAG or t0 == BirthcakeRebaked.Birthcake.ID + TrinketType.TRINKET_GOLDEN_FLAG then
					player:TryRemoveTrinket(BirthcakeRebaked.Birthcake.ID)
					wasGolden = true
				elseif t1 == BirthcakeRebaked.Birthcake.ID or t0 == BirthcakeRebaked.Birthcake.ID then
					player:TryRemoveTrinket(BirthcakeRebaked.Birthcake.ID)
				elseif smeltedTrinkets[BirthcakeRebaked.Birthcake.ID].goldenTrinketAmount > 0 then
					player:TryRemoveSmeltedTrinket(BirthcakeRebaked.Birthcake.ID + TrinketType.TRINKET_GOLDEN_FLAG)
					wasGolden = true
				else
					player:TryRemoveSmeltedTrinket(BirthcakeRebaked.Birthcake.ID)
				end

				local id
				if not willbreak and wasGolden then
					id = BirthcakeRebaked.Birthcake.ID + TrinketType.TRINKET_GOLDEN_FLAG
				elseif wasGolden then
					id = BirthcakeRebaked.Birthcake.ID
					willbreak = false
				else
					id = BirthcakeRebaked.Birthcake.ID
				end

				local trinket = Isaac.Spawn(5, 350, id, player.Position, mod:TrueRandomVector():Resized(mod:RandomInt(10, 20)), player):ToPickup()
				if willbreak then
					trinket.Timeout = 60
					trinket.Wait = 100
				end
				sd.RockDropChance = sd.RockDropChance*0.6
				sd.RockRoomCap = true

				return
			end

			local playerdrops = {}
			for i, rock in pairs(FiendFolio.ITEM.ROCK) do
				if player:HasTrinket(rock) then
					table.insert(playerdrops, {rock, "rock"})
				end
			end
			--if willbreak then
				for id=1, itemconfig:GetCollectibles().Size-1 do
					if player:HasCollectible(id, true) and not mod:Contains(mod.BolemItemDropBlacklist, id) and not itemconfig:GetCollectible(id):HasTags(ItemConfig.TAG_QUEST) then
						table.insert(playerdrops, {id, "item"})
					end
				end
			--end

			if #playerdrops > 0 then
				local ran = mod:GetRandomElem(playerdrops)
				todrop, typ = ran[1], ran[2]

				if typ == "rock" then
					player:TryRemoveTrinket(todrop)
					local trinket = Isaac.Spawn(5, 350, todrop, player.Position, mod:TrueRandomVector():Resized(mod:RandomInt(10, 20)), player):ToPickup()
					if willbreak then
						trinket.Timeout = 60
						trinket.Wait = 100
					end
				else
					player:RemoveCollectible(todrop)
					local trinket = Isaac.Spawn(5, 350, FiendFolio.ITEM.ROCK.FOOLS_UNOBTAINIUM, player.Position, mod:TrueRandomVector():Resized(mod:RandomInt(10, 20)), player):ToPickup()
					trinket.Timeout = 60
					trinket.Wait = 100
					trinket:GetSprite():ReplaceSpritesheet(0, itemconfig:GetCollectible(todrop).GfxFileName)
					trinket:GetSprite():LoadGraphics()
					mod:GetEntityData(trinket).FFHideEIDDesc = true
				end

				sd.RockDropChance = sd.RockDropChance*0.6
				sd.RockRoomCap = true
			end
		end
	end
end,EntityType.ENTITY_PLAYER)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
	local room = game:GetRoom()
	local level = game:GetLevel()
	--local optionsindex = pickup.OptionsPickupIndex

	if mod.BolemExists() and not itemconfig:GetCollectible(pickup.SubType):HasTags(ItemConfig.TAG_QUEST) then
		if room:GetType() == RoomType.ROOM_TREASURE and room:IsFirstVisit() and room:GetFrameCount() < 2 then
			if game:IsGreedMode() and level:GetCurrentRoomIndex() == 98 then -- Silver treasure room
				pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, mod:GetRandomElem(mod.BolemsPebbles), true)
				pickup.Velocity = mod:TrueRandomVector():Resized(3)
				Isaac.RunCallback("POST_BOLEM_MORPH_PICKUP", pickup)

				local newrock = Isaac.Spawn(5, 350, mod:GetRandomElem(mod.BolemsMixedPebbles), pickup.Position, mod:TrueRandomVector():Resized(3), pickup):ToPickup()
			else
				pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, mod.GetGolemTrinket(), true)
				if InFFG() and room:IsFirstVisit() and room:GetFrameCount() <= 1 then
					pickup.OptionsPickupIndex = 1
				end
				Isaac.RunCallback("POST_BOLEM_MORPH_PICKUP", pickup)
			end
			--pickup.OptionsPickupIndex = optionsindex
		elseif room:GetType() == RoomType.ROOM_BOSS then
			pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, mod:GetRandomElem(mod.BolemsPebbles), true)
			pickup.Velocity = mod:TrueRandomVector():Resized(3)
			Isaac.RunCallback("POST_BOLEM_MORPH_PICKUP", pickup)

			local newrock = Isaac.Spawn(5, 350, mod:GetRandomElem(mod.BolemsMixedPebbles), pickup.Position, mod:TrueRandomVector():Resized(3), pickup):ToPickup()
			if mod:IsPlayerWithCollectible(CollectibleType.COLLECTIBLE_DAMOCLES_PASSIVE) then
				local newrock2 = Isaac.Spawn(5, 350, mod:GetRandomElem(mod.BolemsMixedPebbles), pickup.Position, mod:TrueRandomVector():Resized(3), pickup):ToPickup()
				local newrock3 = Isaac.Spawn(5, 350, mod:GetRandomElem(mod.BolemsPebbles), pickup.Position, mod:TrueRandomVector():Resized(3), pickup):ToPickup()
			end
		elseif room:GetType() == RoomType.ROOM_CHALLENGE and room:GetFrameCount() < 2 then
			pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, mod:GetRandomElem(mod:GetRandomElem({mod.BolemsPebbles, mod.BolemsMixedPebbles})), true)
			--pickup.Velocity = mod:TrueRandomVector():Resized(3)
			Isaac.RunCallback("POST_BOLEM_MORPH_PICKUP", pickup)
			local persistData = EntitySaveStateManager.GetEntityData(mod, pickup)
			persistData.BolemChallengeRoomRock = true
		end
	end
end, PickupVariant.PICKUP_COLLECTIBLE)

function mod:bolemChallengeTrinketCheck(pickup, collider)
	if Game():GetRoom():GetType() == RoomType.ROOM_CHALLENGE then
		local persistData = EntitySaveStateManager.GetEntityData(mod, pickup)
		if persistData.BolemChallengeRoomRock then
			Ambush.StartChallenge()
		end
	end
end

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.bolemChallengeTrinketCheck, PickupVariant.PICKUP_TRINKET)


mod:AddCallback("POST_BOLEM_MORPH_PICKUP", function(_, pickup)
	local room = game:GetRoom()
	if mod:IsPlayerWithCollectible(CollectibleType.COLLECTIBLE_DAMOCLES_PASSIVE) then
		local newrock = Isaac.Spawn(5, 350, mod.GetGolemTrinket(), pickup.Position+Vector(15, 0), Vector.Zero, pickup):ToPickup()
		pickup.Position = pickup.Position+Vector(-15, 0)
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
	local room = game:GetRoom()

	if mod.GolemExists() and InMirrorWorld() and pickup.Timeout <= 0 and pickup.Variant ~= FiendFolio.ITEM.ROCK.FOOLS_UNOBTAINIUM then
		local sprite = pickup:GetSprite()
		local sdata = FiendFolio.savedata.run
		sdata.RocksToSpawn = sdata.RocksToSpawn or {}
		if sprite:IsEventTriggered("DropSound") then
			Isaac.Spawn(1000, EffectVariant.BIG_SPLASH, 0, pickup.Position, Vector.Zero, pickup)
			sfx:Play(mod.Sounds.SplashLarge)
			table.insert(sdata.RocksToSpawn, pickup.SubType)
			pickup:Remove()
		end
	end
end, PickupVariant.PICKUP_TRINKET)

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function(_)
	local level = game:GetLevel()
	AnyBolemDo(function(player)
		local data = mod:GetEntityData(player)
		local sd = data.ffsavedata

		if (not level:IsAscent()) or (level:GetStage() == LevelStage.STAGE3_2 and level:GetStageType() == StageType.STAGETYPE_REPENTANCE) then
			sd.RockDropChance = 0.5
		end
		data.OverclockTime = data.OverclockTime or 0
	end)
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function(_)
	local sdata = FiendFolio.savedata.run
	local room = game:GetRoom()
	local level = game:GetLevel()
	if sdata.RocksToSpawn and not InMirrorWorld() and room:GetType() == RoomType.ROOM_BOSS and room:IsClear() then
		for i, rock in pairs(sdata.RocksToSpawn) do
			local position = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 60)
			local pickup = Isaac.Spawn(5, 350, rock, position, Vector.Zero, nil):ToPickup()
			Isaac.Spawn(1000, EffectVariant.BIG_SPLASH, 0, position, Vector.Zero, nil)
			pickup:GetSprite():Play("Appear")
			pickup:GetSprite():SetFrame(7)
		end

		sdata.RocksToSpawn = nil
		sfx:Play(mod.Sounds.SplashLarge)
	end

	AnyBolemDo(function(player)
		local data = mod:GetEntityData(player)
		local sd = data.ffsavedata

		sd.RockRoomCap = false

		if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and mod:GetEntityData(player).OverclockTime > 0 then
			local effect = Isaac.Spawn(1000, mod.FF.BolemsClub.Var, mod.FF.BolemsClub.Sub, player.Position, Vector.Zero, player):ToEffect()
			mod:GetEntityData(effect).ClubPlayer = player
			effect.DepthOffset = -40
		end
    end)
end)

mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, function(_)
	local sdata = FiendFolio.savedata.run
	local room = game:GetRoom()
	local level = game:GetLevel()
	if sdata.RocksToSpawn and not InMirrorWorld() and room:GetType() == RoomType.ROOM_BOSS then
		for i, rock in pairs(sdata.RocksToSpawn) do
			local position = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 60)
			local pickup = Isaac.Spawn(5, 350, rock, position, Vector.Zero, nil):ToPickup()
			Isaac.Spawn(1000, EffectVariant.BIG_SPLASH, 0, position, Vector.Zero, nil)
			pickup:GetSprite():Play("Appear")
			pickup:GetSprite():SetFrame(7)
		end

		sdata.RocksToSpawn = nil
		sfx:Play(mod.Sounds.SplashLarge)
	end
end)

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, collectible, rng, player)
	local data = mod:GetEntityData(player)
	if not data.GulpingTrinket then
		data.OverclockTime = 600
		sfx:Play(mod.Sounds.OverclockOn, 0.7)
		player:AddCacheFlags(CacheFlag.CACHE_ALL)
		player:EvaluateItems()

		mod.scheduleForUpdate(function()
			player:AddNullCostume(overclockHead)
		end, 10)

		if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and Isaac.CountEntities(player, 1000, mod.FF.BolemsClub.Var, mod.FF.BolemsClub.Sub) == 0 then
			local effect = Isaac.Spawn(1000, mod.FF.BolemsClub.Var, mod.FF.BolemsClub.Sub, player.Position+RandomVector():Resized(1000), Vector.Zero, player):ToEffect()
			mod:GetEntityData(effect).ClubPlayer = player
			mod:GetEntityData(effect).ThrownVec = Vector.Zero
			mod:GetEntityData(effect).SuperAppear = true
			effect:GetSprite():Play("Spin")
			effect.DepthOffset = -40
		end

		if player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
			data.OverclockTime = 1200
		end
		return true
	end
end, mod.ITEM.COLLECTIBLE.OVERCLOCK)

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
	local data = mod:GetEntityData(player)
	data.OverclockTime = data.OverclockTime or 0
	if data.BolemEvalCache then
		player:AddCacheFlags(CacheFlag.CACHE_ALL)
		player:EvaluateItems()
		data.BolemEvalCache = false
	end
    if data.OverclockTime and data.OverclockTime > 0 then
		data.OverclockTime = data.OverclockTime - 1
		if data.OverclockTime == 0 then
			sfx:Play(mod.Sounds.OverclockOff, 0.7)
			data.BolemEvalCache = true
			player:TryRemoveNullCostume(overclockHead)
		end
		if data.OverclockTime > 30 and player.FrameCount % 20 == 0 then
			local effect = Isaac.Spawn(1000, EffectVariant.SIREN_RING, 0, player.Position, Vector.Zero, player):ToEffect()
			effect:FollowParent(player)
			effect.Color = Color(0,0,0,0.5,0.8,0.8,1)
			effect.SpriteScale = (effect.SpriteScale*0.4)*((data.OverclockTime+200)/800)
			effect.DepthOffset = -1000
		end
	end
end, FiendFolio.PLAYER.BOLEM)

mod:AddCallback(mod.CALLBACK.FF_POST_PLAYER_UPDATE, function(_, player) -- Called twice as often as PEFEECT, so should be avoided when possible
	local d = mod:GetEntityData(player)
	if d.golemHurtByExplosionRecently then
		if player.FrameCount > d.golemHurtByExplosionRecently + 10 then
			d.golemHurtByExplosionRecently = nil
		end
		if player:GetSprite():IsPlaying("Death") and not d.tintedRocked then
			d.tintedRocked = true
			sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE,1,2,false,1.2)
			for i = 30, 360, 30 do
				local smoke = Isaac.Spawn(1000, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, player.Position + Vector(0, 10), Vector(0,-10):Rotated(i), player)
				smoke.SpriteOffset = Vector(0, -20)
				smoke.Color = Color(1,1,1,1,100 / 255,100 / 255,100 / 255)
				smoke:Update()
			end
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL, player.Position, Vector(0, 3), player)
		end
	end
end, FiendFolio.PLAYER.BOLEM)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, flag)
	if player:GetPlayerType() == FiendFolio.PLAYER.BOLEM then
        if flag == CacheFlag.CACHE_DAMAGE then
            player.Damage = player.Damage + 0.7 -- base damage 4.20
        elseif flag == CacheFlag.CACHE_RANGE then
			local basemulti = player:GetD8RangeModifier()
			if player:HasCollectible(CollectibleType.COLLECTIBLE_NUMBER_ONE) then
				basemulti = basemulti * 0.8
			end
			if player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) or
			   player:HasCollectible(CollectibleType.COLLECTIBLE_HAEMOLACRIA) or
			   player:HasCollectible(CollectibleType.COLLECTIBLE_CRICKETS_BODY)
			then
				basemulti = basemulti * 0.8
			end

            --player.TearHeight = player.TearHeight + 1.25 -- base range 22.5
			player.TearRange = player.TearRange - 20 * basemulti
        elseif flag == CacheFlag.CACHE_LUCK then
            player.Luck = player.Luck - 1 -- base luck -1
        end
    end
end)

FiendFolio.AddItemPickupCallback(function(player, added)
	local position = room:FindFreePickupSpawnPosition(player.Position, 10)
	local pickup = Isaac.Spawn(5, 350, mod:GetRandomElem(mod:GetRandomElem({mod.BolemsPebbles, mod.BolemsMixedPebbles})), position, Vector.Zero, nil):ToPickup() --Intelligent
end, nil, mod.ITEM.COLLECTIBLE.GOLEMS_SUB)

mod:AddCallback(ModCallbacks.MC_PRE_GET_COLLECTIBLE, function(_, pooltype)
	local room = game:GetRoom()
	if mod.BolemExists() and room:GetType() == RoomType.ROOM_CHALLENGE and pooltype == ItemPoolType.POOL_BOSS then
		return mod.ITEM.COLLECTIBLE.GOLEMS_SUB
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
	local data = mod:GetEntityData(effect)
	if effect.SubType == mod.FF.BolemsClub.Sub then
		local player = data.ClubPlayer
		local sprite = effect:GetSprite()

		if not data.ThrownVec then
			local rot = player.Velocity
			if rot.X < 0 then
				sprite.FlipX = true
				effect.RenderZOffset = 5100
			else
				sprite.FlipX = false
				effect.RenderZOffset = -5100
			end
			rot = math.floor(rot:GetAngleDegrees())
			if sprite.FlipX then
				rot = (rot * -1) + 180
			end
			effect.SpriteRotation = rot

			local vec = (player.Position + Vector(0, -10) - effect.Position)
			effect.Velocity = mod:Lerp(effect.Velocity, vec, 0.6)

			if mod:GetEntityData(player).OverclockTime == 0 then
				data.ThrownVec = Vector.Zero
				sprite:Play("Spin")
				sfx:Play(SoundEffect.SOUND_SHELLGAME)
				data.ClubLeaving = true
			end

			local aim = player:GetAimDirection()
			if aim:Length() > 0.5 then
				data.ThrownVec = aim:Resized(60)
				sprite:Play("Spin")
				sfx:Play(SoundEffect.SOUND_SHELLGAME)
			end
		else
			data.DamageCooldown = data.DamageCooldown or 0

			if mod:GetEntityData(player).OverclockTime == 0 and not data.ClubLeaving then
				data.ClubLeaving = true
			end

			effect.Velocity = data.ThrownVec
			if not data.ClubLeaving then
				effect.Velocity = effect.Velocity + (player.Position - effect.Position):Resized(20)
			else
				effect.Velocity = effect.Velocity + (player.Position + effect.Position):Resized(20)
			end
			data.ThrownVec = mod:Lerp(data.ThrownVec, Vector.Zero, 0.05)

			for i, grident in pairs(FiendFolio.GetGridEntities()) do
				if grident.Position:Distance(effect.Position) <= 30 then
					if grident:ToRock() and grident.State ~= 2 and grident:IsBreakableRock() and mod:RandomInt(1, 200) == 1 then
						local pickup = Isaac.Spawn(5, 350, mod:GetGolemTrinket(), grident.Position, Vector.Zero, nil):ToPickup()
					end
					grident:Destroy()
				end
			end

			for i, entity in pairs(Isaac.FindInRadius(effect.Position, 30, EntityPartition.ENEMY)) do
				if entity:IsEnemy() and not entity:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) and not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and data.DamageCooldown == 0 then
					entity:TakeDamage(math.max(3.5, player.Damage*2), 0, EntityRef(player), 60)
					if not entity:HasEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK) then
						entity.Velocity = entity.Velocity + RandomVector():Resized(5)
					end
					sfx:Play(SoundEffect.SOUND_MEATY_DEATHS, 1, 2, false, 1.5)
					data.DamageCooldown = 10
				end
			end

			if (effect.Position + effect.Velocity):Distance(player.Position) < 20 and not data.ClubLeaving then
				data.ThrownVec = nil
				sprite:Play("Idle")
				if data.SuperAppear then
					sfx:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS)
					game:MakeShockwave(player.Position, 0.05, 0.025, 20)
					game:ShakeScreen(10)
					data.SuperAppear = false
				else
					sfx:Play(SoundEffect.SOUND_SCAMPER)
				end
			end

			if data.ClubLeaving and not game:GetRoom():IsPositionInRoom(effect.Position, -200) then
				effect:Remove()
			end

			data.DamageCooldown = math.max(0, data.DamageCooldown - 1)
		end
	end
end, mod.FF.BolemsClub.Var)