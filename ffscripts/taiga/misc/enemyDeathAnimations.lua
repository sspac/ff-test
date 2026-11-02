-- Enemy Death Animations --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local bkeeperKilledThisRoom = 0
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	bkeeperKilledThisRoom = 0
	mod.fiendImmoralSpawnOnSpawnedChance = 2
end)

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, function(_, entity)
	if entity:ToNPC() and not entity:HasEntityFlags(EntityFlag.FLAG_NO_REWARD) then
		bkeeperKilledThisRoom = bkeeperKilledThisRoom + 1
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, npc)
	mod:GetEntityData(npc).SpawnedAtRoomStart = game:GetRoom():GetFrameCount() == -1
end)

function mod:spawnBKeeperCoin(entity, increment)
	if increment then
		bkeeperKilledThisRoom = bkeeperKilledThisRoom + 1
	end

	if mod:anyPlayerIsBKeeper() and not entity:HasEntityFlags(EntityFlag.FLAG_NO_REWARD) then
		local rng = RNG()
		rng:SetSeed(entity.InitSeed, 0)

		if mod:GetEntityData(entity).SpawnedAtRoomStart or rng:RandomFloat() <= 1 / math.max(bkeeperKilledThisRoom, 1) then
			local coin = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, entity.Position, RandomVector() * (math.random() + 3), nil):ToPickup()
			coin.Timeout = 60
		end
	end
end

function mod:spawnVadeRetroGhost(entity)
	if PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_VADE_RETRO) and not entity:HasEntityFlags(EntityFlag.FLAG_NO_REWARD) then
		local ghost = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ENEMY_GHOST, 0, entity.Position, Vector(8,0):Rotated(math.random() * 360), player)
		ghost.CollisionDamage = 3 + 0.04 * entity.MaxHitPoints
		return
	end
end

function mod:HandleItemRecycle(collectible, rng, player, useflags)
	-- does nothing but kept for epiphany compat
end

local rainbowChampionDrops = {
	PickupVariant.PICKUP_COIN,
	PickupVariant.PICKUP_BOMB,
	PickupVariant.PICKUP_KEY,
	PickupVariant.PICKUP_HEART,
	PickupVariant.PICKUP_PILL,
	PickupVariant.PICKUP_TAROTCARD,
	PickupVariant.PICKUP_TRINKET
}

function mod:spawnChampionPickups(entity)
	-- note: this is just the pickups, all other effects are not handled by this function
	local npc = entity:ToNPC()
	if not npc then return end

	local champIdx = npc:GetChampionColorIdx()
	if champIdx == -1 or champIdx == 24 or champIdx > 25 then
		return
	end

	local rng = entity:GetDropRNG()
	if game.Difficulty == Difficulty.DIFFICULTY_GREED or game.Difficulty == Difficulty.DIFFICULTY_HARD and rng:RandomFloat() > 1/3 then
		return
	end

	if champIdx == 4 then
		local player = game:GetNearestPlayer(entity.Position)
		player:AddBlueFlies(3, entity.Position, player)
	elseif champIdx == 18 then
		if rng:RandomFloat() <= 0.2 then
			game:Spawn(EntityType.ENTITY_PICKUP,
			           PickupVariant.PICKUP_PILL,
			           game:GetRoom():FindFreePickupSpawnPosition(entity.Position, 0, false, false),
			           nilvector,
			           entity,
			           game:GetItemPool():ForceAddPillEffect(PillEffect.PILLEFFECT_SMALLER),
			           math.max(rng:Next(), 1))
		end
	elseif champIdx == 19 then
		if rng:RandomFloat() <= 0.2 then
			game:Spawn(EntityType.ENTITY_PICKUP,
			           PickupVariant.PICKUP_PILL,
			           game:GetRoom():FindFreePickupSpawnPosition(entity.Position, 0, false, false),
			           nilvector,
			           entity,
			           game:GetItemPool():ForceAddPillEffect(PillEffect.PILLEFFECT_LARGER),
			           math.max(rng:Next(), 1))
		end
	elseif champIdx == 21 then
		local player = game:GetNearestPlayer(entity.Position)
		player:AddBlueFlies(4 + rng:RandomInt(3), entity.Position, player)
	elseif champIdx == 22 then
		local room = game:GetRoom()
		for i = 1, rng:RandomInt(2) + 2 do
			game:Spawn(EntityType.ENTITY_PICKUP,
			           0,
			           room:FindFreePickupSpawnPosition(entity.Position, 0, false, false),
			           nilvector,
			           entity,
			           4,
			           math.max(rng:Next(), 1))
		end
	elseif champIdx == 23 then
		game:GetNearestPlayer(entity.Position):UseActiveItem(CollectibleType.COLLECTIBLE_NECRONOMICON, UseFlag.USE_NOANIM)
	elseif champIdx == 10 or champIdx == 24 then
		-- boy these dont even work with glyph, ain't that something
		return
	elseif champIdx == 25 then
		local room = game:GetRoom()
		for _, var in ipairs(rainbowChampionDrops) do
			game:Spawn(EntityType.ENTITY_PICKUP,
			           var,
			           room:FindFreePickupSpawnPosition(entity.Position, 0, false, false),
			           nilvector,
			           entity,
			           0,
			           math.max(rng:Next(), 1))
		end
	else
		local room = game:GetRoom()
		local num = (champIdx == 3 and (rng:RandomInt(3) + 1)) or 1
		local glyphOwner = (PlayerManager.GetRandomCollectibleOwner and
		                    PlayerManager.GetRandomCollectibleOwner(CollectibleType.COLLECTIBLE_GLYPH_OF_BALANCE, entity.InitSeed, rng)) or
		                   PlayerManager.FirstCollectibleOwner(CollectibleType.COLLECTIBLE_GLYPH_OF_BALANCE)

		for i = 1, num do
			local typ, var, subt

			if glyphOwner then
				local glyphTable = glyphOwner:GetGlyphOfBalanceDrop()
				typ, var, subt = EntityType.ENTITY_PICKUP, glyphTable[1], glyphTable[2]
			elseif champIdx == 0 then
				typ, var, subt = EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL
			elseif champIdx == 1 then
				typ, var, subt = EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, 0
			elseif champIdx == 2 then
				typ, var, subt = EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, 0
			elseif champIdx == 3 then
				typ, var, subt = EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0
			elseif champIdx == 5 then
				typ, var, subt = EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, 0
			elseif champIdx == 6 then
				typ, var, subt = EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_ETERNAL
			elseif champIdx == 7 then
				typ, var, subt = EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, 0
			elseif champIdx == 8 then
				typ, var, subt = EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LOCKEDCHEST, 0
			elseif champIdx == 9 then
				typ, var, subt = EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_REDCHEST, 0
			elseif champIdx == 11 then
				typ, var, subt = EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, 0
			elseif champIdx == 12 then
				typ, var, subt = EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_DOUBLEPACK
			elseif champIdx == 13 then
				typ, var, subt = EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF
			elseif champIdx == 14 then
				typ, var, subt = EntityType.ENTITY_PICKUP, 301, 0
			elseif champIdx == 20 then
				typ, var, subt = EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL
			else
				return
			end

			local pos = entity.Position
			if room:GetGridCollisionAtPos(pos) ~= GridCollisionClass.COLLISION_NONE then
				pos = room:FindFreePickupSpawnPosition(entity.Position, 0, false, false)
			end
			local vec = (num == 1 and nilvector) or Vector.FromAngle(math.random() * 360):Resized(0.65)
			game:Spawn(typ, var, pos, vec, entity, subt, math.max(rng:Next(), 1))
		end
	end
end

local function getVasculitisTearInfo(entityflags)
	local tearflags = TearFlags.TEAR_NORMAL
	local tearvariant = (REPENTANCE_PLUS and 26) or 1
	if entityflags & EntityFlag.FLAG_SLOW ~= 0 then
		tearflags = tearflags | TearFlags.TEAR_SLOW
	end
	if entityflags & EntityFlag.FLAG_POISON ~= 0 then
		tearflags = tearflags | TearFlags.TEAR_POISON
	end
	if entityflags & EntityFlag.FLAG_FREEZE ~= 0 then
		tearflags = tearflags | TearFlags.TEAR_FREEZE
	end
	if entityflags & EntityFlag.FLAG_CHARM ~= 0 then
		tearflags = tearflags | TearFlags.TEAR_CHARM
	end
	if entityflags & EntityFlag.FLAG_CONFUSION ~= 0 then
		tearflags = tearflags | TearFlags.TEAR_CONFUSION
	end
	if entityflags & EntityFlag.FLAG_FEAR ~= 0 then
		tearflags = tearflags | TearFlags.TEAR_FEAR
	end
	if entityflags & EntityFlag.FLAG_BURN ~= 0 then
		tearflags = tearflags | TearFlags.TEAR_BURN
		tearvariant = TearVariant.FIRE_MIND
	end
	if entityflags & EntityFlag.FLAG_MAGNETIZED ~= 0 then
		tearflags = tearflags | TearFlags.TEAR_MAGNETIZE
	end
	if entityflags & EntityFlag.FLAG_ICE ~= 0 then
		tearflags = tearflags | TearFlags.TEAR_ICE
		tearvariant = TearVariant.ICE
	end
	if entityflags & EntityFlag.FLAG_BAITED ~= 0 then
		tearflags = tearflags | TearFlags.TEAR_BAIT
	end
	return tearflags, tearvariant
end

function mod:spawnVasculitis(npc)
	local player = PlayerManager.FirstCollectibleOwner(CollectibleType.COLLECTIBLE_VASCULITIS)
	if player then
		local stagefactor = game:GetLevel():GetStage() * 0.3 + 3.2
		local numtears = math.min(16, math.ceil(npc.MaxHitPoints / stagefactor))
		local teardamage = math.max(stagefactor, npc.MaxHitPoints / numtears)

		if numtears > 0 then
			local tearflags, tearvariant = getVasculitisTearInfo(npc:GetEntityFlags())
			local tearcolor = Color(2,0,0,1,0.2,0,0)
			local pos = npc.Position

			local baseangle = math.random() * 360
			for i = 1, numtears do
				local angle = baseangle + 360 / numtears * (i + (math.random() - 0.5))
				local vec = Vector.FromAngle(angle):Resized(math.random() * 4 + 8)
				local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, tearvariant, 0, pos, vec, player):ToTear()
				tear.CollisionDamage = teardamage
				tear.TearFlags = tearflags
				tear:GetSprite().Color = tearcolor
				Isaac.RunCallback(TearFlagsLib.Callback.POST_FIRE_VASCULITIS_TEAR, tear, npc)
				tear:Update()
			end
		end
	end
end

function mod:grabbedByBigHorn(npc)
	if npc:IsBoss() then return false end
	local bigHornHands = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.BIG_HORN_HAND)
	for _, hand in ipairs(bigHornHands) do
		if hand.Target and hand.Target.InitSeed == npc.InitSeed and hand.Target.Index == npc.Index then
			return true
		end
	end
	return false
end

function mod:shouldDoDeathEffect(npc, ignoreShrink)
	-- for stuff with no animation
	local npc = npc:ToNPC()
	return not ((not ignoreShrink and npc:HasEntityFlags(EntityFlag.FLAG_SHRINK)) or
	            mod:isStatusCorpse(npc) or
	            mod:isLeavingStatusCorpse(npc))
end

function mod:shouldDoDeathAnimation(npc, ignoreShrink)
	local npc = npc:ToNPC()
	return not ((not ignoreShrink and npc:HasEntityFlags(EntityFlag.FLAG_SHRINK)) or
	            mod:isStatusCorpse(npc) or
	            mod:isLeavingStatusCorpse(npc) or
	            (not npc:IsBoss() and npc:GetChampionColorIdx() == 12) or
	            mod:grabbedByBigHorn(npc))
end

FiendFolio.EnemyOnDeath = {}
FiendFolio.EnemyOnDeath.DeathAnims = {} -- Defined at the bottom of main
FiendFolio.EnemyOnDeath.SkulltistEffects = {} -- Defined at the bottom of main

function mod:basicDeathAnimation(npc, deathAnimName, dropsBeforeAnim)
	--[[npc.State = 17
	npc:GetSprite():Play(deathAnimName, true)
	mod:GetEntityData(npc).FFIsDeathAnimation = true
	npc.Velocity = Vector.Zero]]--

	local onCustomDeath = function(npc, deathAnim)
		mod:GetEntityData(deathAnim).FFBasicDeath = true
		deathAnim.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
		deathAnim.SplatColor = Color.Lerp(npc.SplatColor, Color(1,1,1,1,0,0,0), 0)
	end

	mod.genericCustomDeathAnim(npc, deathAnimName, nil, onCustomDeath, nil, nil, nil, dropsBeforeAnim)
end

function mod:preUpdateBasicDeath(npc, npcdata)
	if npcdata.FFBasicDeath then
		npc.Velocity = nilvector
		local sprite = npc:GetSprite()
		if sprite:IsEventTriggered("Explosion") or sprite:IsEventTriggered("explode") then
			npc:BloodExplode()
		end
		if sprite:IsEventTriggered("BloodStart") or sprite:IsEventTriggered("bloodstart") then
			npcdata.bleeding = true
		end
		if sprite:IsEventTriggered("BloodEnd") or sprite:IsEventTriggered("bloodend") then
			npcdata.bleeding = false
		end
		if npcdata.bleeding then
			if npc.FrameCount % 4 == 0 then
				local blood = Isaac.Spawn(1000, 5, 0, npc.Position, RandomVector()*3, npc):ToEffect();
				blood.Color = npc.SplatColor
				blood.SplatColor = npc.SplatColor
				blood:Update()

				local bloo2 = Isaac.Spawn(1000, 2, 0, npc.Position, RandomVector()*3, npc):ToEffect();
				bloo2.Color = npc.SplatColor
				bloo2.SplatColor = npc.SplatColor
				bloo2.SpriteScale = Vector(1,1)
				bloo2.SpriteOffset = Vector(-3+math.random(14), -45+math.random(40))
				bloo2:Update()

				npc:PlaySound(SoundEffect.SOUND_MEAT_JUMPS,0.2,0,false,0.8)
			end
		end
		if sprite:IsFinished(sprite:GetAnimation()) then
			if npcdata.FFPreventDeathDrops then
				npc:Remove()
			else
				local splatoon = Color.Lerp(npc.SplatColor, Color(1,1,1,1,0,0,0), 0)
				npc.SplatColor = Color(1,1,1,0,0,0,0)
				npc:Die()
				npc.SplatColor = splatoon
			end
		end
		return true
	end
end

function mod.genericCustomDeathAnim(npc, animName, canShutDoors, miscFunc, canCollide, hasKnockback, isDeathAnim, dropsBeforeAnim)
	mod.AboutToSpawnGenericDeathAnim = true
	local deathAnim = Isaac.Spawn(npc.Type, npc.Variant, npc.SubType, npc.Position, nilvector, nil):ToNPC()
	mod.AboutToSpawnGenericDeathAnim = false

	if npc:GetChampionColorIdx() >= 0 then
		deathAnim:MakeChampion(0, npc:GetChampionColorIdx())
	end
	--deathAnim.HitPoints = 0
	--deathAnim.MaxHitPoints = 0
	deathAnim:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

	local deathAnimData = mod:GetEntityData(deathAnim)
	if isDeathAnim ~= nil then
		deathAnimData.FFIsDeathAnimation = isDeathAnim
	else
		deathAnimData.FFIsDeathAnimation = true
	end

	local deathAnimSprite = deathAnim:GetSprite()
	if animName ~= nil then deathAnimSprite:Play(animName, true) end
	deathAnimSprite.Offset = npc:GetSprite().Offset
	deathAnimSprite.FlipX = npc:GetSprite().FlipX
	deathAnim.SplatColor = npc.SplatColor

	if not canCollide then deathAnim.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE end
	if canShutDoors ~= nil then deathAnim.CanShutDoors = canShutDoors end
	if not hasKnockback then deathAnim:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK) end
	deathAnim:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_HIDE_HP_BAR | EntityFlag.FLAG_NO_TARGET)

	if (npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)) then
		deathAnim:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
	end

	if miscFunc then miscFunc(npc, deathAnim) end

	if dropsBeforeAnim then
		mod:GetEntityData(npc).FFPreventDeathDrops = false
		mod:GetEntityData(deathAnim).FFPreventDeathDrops = true
	else
		mod:GetEntityData(npc).FFPreventDeathDrops = true
		mod:GetEntityData(deathAnim).FFPreventDeathDrops = false
	end

	mod:GetEntityData(npc).FFMyDeathAnimation = deathAnim
	npc.Visible = false
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, function(_, entity)
	if not entity:ToNPC() then
		return
	end
	local npc = entity:ToNPC()

	mod:empathOnEnemyDeath(entity)
	mod:meatsackOnEnemyDeath(entity)
	mod:shampooBottleOnEnemyDeath(entity)
	mod:FoolsGoldFreezeKill(entity)

	if (entity.Type == mod.FF.PsychoFly.ID and entity.Variant == mod.FF.PsychoFly.Var) or
	   (entity.Type == mod.FF.ManicFly.ID and entity.Variant == mod.FF.ManicFly.Var)
	then
		mod.triggerPsychoManicFlies(npc)
	end

	if mod:GetEntityData(npc).SkulltistVictim then
		for _, effects in pairs(FiendFolio.EnemyOnDeath.SkulltistEffects) do
			if effects.ID == entity.Type and
			   (effects.Var == entity.Variant or effects.Var == -1 or effects.Var == nil) and
			   (effects.Sub == entity.SubType or effects.Sub == -1 or effects.Sub == nil)
			then
				if effects.EffectFunc then
					effects.EffectFunc(npc)
				end

				break
			end
		end
	end

	if mod:shouldDoDeathAnimation(npc) then
		if not (mod:GetEntityData(npc).FFIsDeathAnimation or
				mod:GetEntityData(npc).SkulltistVictim)
		then
			for _, anims in pairs(FiendFolio.EnemyOnDeath.DeathAnims) do
				if anims.ID == entity.Type and
				   (anims.Var == entity.Variant or anims.Var == -1 or anims.Var == nil) and
				   (anims.Sub == entity.SubType or anims.Sub == -1 or anims.Sub == nil)
				then
					if anims.BasicAnimName then
						mod:basicDeathAnimation(npc, anims.BasicAnimName, anims.DropsBeforeAnim)
					elseif anims.CustomAnimFunc then
						anims.CustomAnimFunc(npc)
					end

					break
				end
			end
		end

		if mod:GetEntityData(npc).FFIsDeathAnimation or mod:GetEntityData(npc).rocktime then
			if npc.Type == mod.FF.FossilBoomFly.ID and
			   npc.Variant == mod.FF.FossilBoomFly.Var
			then
				mod.fossilizedBoomFlyDeathEffect(npc)
			end
		end

		if mod:GetEntityData(npc).FFPreventDeathDrops then
			npc:Remove()
		end
	end
end)