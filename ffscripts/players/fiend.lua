-- Fiend --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero
local grng = RNG()

mod.fiendstats = {
	damage = 1.2,
	tears = 1.3,
	speed = 0.2,
	shotspeed = 0.25,
	luck = -1,
	flag = 4,
	colour = Color(1.0, 1.0, 0.5, 1.0, 200 / 255, 0, 0),
}

-- Ignore this, this is just for War Horn compatibility
local familiarBerserkBase = Color(
	FiendFolio.StatusEffectColors.Berserk.R / 3,
	FiendFolio.StatusEffectColors.Berserk.G / 3,
	FiendFolio.StatusEffectColors.Berserk.B / 3
)

-- Making sure fiend gets his completion note
--CompletionNoteAPIMod:addPlayerNameToAPI("Fiend")

if StageAPI and StageAPI.Loaded then
	StageAPI.AddPlayerGraphicsInfo(FiendFolio.PLAYER.FIEND, {
		Name = "gfx/ui/boss/playername_fiend.png",
		Portrait = "gfx/ui/stage/playerportrait_fiend_rep.png",
		NoShake = true,
		Controls = "gfx/backdrop/controls_fiend.png"
	})
end

--------------------------------------------------------------------------------
-- Initializing --

mod:AddCallback(ModCallbacks.MC_PLAYER_INIT_POST_LEVEL_INIT_STATS, function(_, player)
	if FiendFolio.FiendConfig.ImpBabyMode then
		player:AddCollectible(CollectibleType.COLLECTIBLE_SULFURIC_ACID, 0, true)
		Game():GetItemPool():RemoveCollectible(CollectibleType.COLLECTIBLE_SULFURIC_ACID)
		player:RemovePocketItem(0)
		player:AddMaxHearts(6)
		player:AddHearts(6)
		player:AddBlackHearts(-4)
	else
		mod:AddImmoralHearts(player, 2)
	end
end, FiendFolio.PLAYER.FIEND)

mod:AddCallback(mod.CALLBACK.FF_POST_PLAYER_INIT, function(_, player)
	player:GetSprite():Load("gfx/characters/player_fiend.anm2", true)
	player:GetSprite():Play(player:GetSprite():GetDefaultAnimationName(), true)
end, mod.PLAYER.FIEND)

--------------------------------------------------------------------------------
-- Fiend / Biend heart replacement --

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
	local room = game:GetRoom()
	local anyPlayerIsFiend = false
	local highestFiendLuck = -99
	local anyPlayerIsBiend = false
	local highestBiendLuck = -99
	for i = 1, game:GetNumPlayers() do
		local player = Isaac.GetPlayer(i - 1)
		local ptype = player:GetPlayerType()

		if ptype == FiendFolio.PLAYER.FIEND then
			anyPlayerIsFiend = true
			highestFiendLuck = math.max(highestFiendLuck, player.Luck)
		elseif ptype == FiendFolio.PLAYER.BIEND or ptype == FiendFolio.PLAYER.CLASSIC_FIEND then
			anyPlayerIsBiend = true
			highestBiendLuck = math.max(highestBiendLuck, player.Luck)
		end
	end

	if pickup.SubType == 114 then
		local poof = Isaac.Spawn(1000, EffectVariant.POOF01, 0, pickup.Position, Vector.Zero, pickup):ToEffect()
		poof.Color = Color(0.2, 0.2, 0.2, 1, 0, 0, 0)
		sfx:Play(SoundEffect.SOUND_BLACK_POOF, 0.4, 0, false, 1.5)
		pickup:Remove()
		return
	elseif pickup.SubType == 115 then
		local poof = Isaac.Spawn(1000, EffectVariant.POOF01, 0, pickup.Position, Vector.Zero, pickup):ToEffect()
		poof.Color = Color(0.2, 0.2, 0.2, 1, 0, 0, 0)
		sfx:Play(SoundEffect.SOUND_BLACK_POOF, 0.4, 0, false, 1.5)
		pickup:Remove()
		return
	end

	if mod.anyPlayerHas(mod.ITEM.COLLECTIBLE.ORGAN_DONOR) then
		return
	end

	if anyPlayerIsBiend then
		local heartluck = math.max(0, math.min(13, highestBiendLuck))
		if pickup.SubType == HeartSubType.HEART_BLACK then
			--pickup.Timeout = 60
		else
			if pickup.SubType == HeartSubType.HEART_SOUL then
				if mod:RoomForcesSoulHeart() then
                    Isaac.Spawn(13,0,0,pickup.Position,Vector.Zero,nil)
                    pickup:Remove()
				else
					pickup:Morph(5, 10, 6, true)
				end
			elseif pickup.SubType == HeartSubType.HEART_HALF_SOUL then
				if mod:RoomForcesSoulHeart() then
                    Isaac.Spawn(13,0,0,pickup.Position,Vector.Zero,nil)
                    pickup:Remove()
				else
					pickup:Morph(5, mod.PICKUP.VARIANT.HALF_BLACK_HEART, 0, true)
				end
			elseif pickup.SubType == HeartSubType.HEART_BLENDED then
				if mod:RoomForcesSoulHeart() then
                    Isaac.Spawn(13,0,0,pickup.Position,Vector.Zero,nil)
                    pickup:Remove()
				else
					pickup:Morph(5, mod.PICKUP.VARIANT.BLENDED_BLACK_HEART, 0, true)
				end
			elseif room:GetType() ~= RoomType.ROOM_SUPERSECRET then
				grng:SetSeed(pickup.InitSeed, 0)

				if pickup.SubType == HeartSubType.HEART_ETERNAL or pickup.SubType == HeartSubType.HEART_GOLDEN then
					pickup:Morph(5, 10, 6, true)
				elseif pickup.SubType == HeartSubType.HEART_BONE and grng:RandomInt(5) == 0 then
					pickup:Morph(5, 10, 6, true)
				elseif grng:RandomInt(99) + 1 <= 33 + (33 * heartluck/13) then
					if pickup.SubType == HeartSubType.HEART_HALF then
						pickup:Morph(5, mod.PICKUP.VARIANT.HALF_BLACK_HEART, 0, true)
					else
						pickup:Morph(5, 10, 6, true)
					end
				end
			end
		end
	elseif anyPlayerIsFiend then
		local heartluck = math.max(0, math.min(13, highestFiendLuck))
		if pickup.SubType == HeartSubType.HEART_BLACK then
			--pickup.Timeout = 60
		else
			grng:SetSeed(pickup.InitSeed, 0)

			if grng:RandomFloat() < 0.10 then
				if pickup.SubType == HeartSubType.HEART_SOUL then
					pickup:Morph(5, 10, 6, true)
				elseif pickup.SubType == HeartSubType.HEART_HALF_SOUL then
					pickup:Morph(5, mod.PICKUP.VARIANT.HALF_BLACK_HEART, 0, true)
				elseif pickup.SubType == HeartSubType.HEART_BLENDED then
					pickup:Morph(5, mod.PICKUP.VARIANT.BLENDED_BLACK_HEART, 0, true)
				elseif room:GetType() ~= RoomType.ROOM_SUPERSECRET then
					if pickup.SubType == HeartSubType.HEART_ETERNAL or pickup.SubType == HeartSubType.HEART_GOLDEN then
						pickup:Morph(5, 10, 6, true)
					elseif pickup.SubType == HeartSubType.HEART_BONE and grng:RandomInt(5) == 0 then
						pickup:Morph(5, 10, 6, true)
					elseif grng:RandomInt(99) + 1 <= 33 + (33 * heartluck/13) then
						if pickup.SubType == HeartSubType.HEART_HALF then
							pickup:Morph(5, mod.PICKUP.VARIANT.HALF_BLACK_HEART, 0, true)
						else
							pickup:Morph(5, 10, 6, true)
						end
					end
				end
			else
				if pickup.SubType == HeartSubType.HEART_SOUL then
					pickup:Morph(5, mod.PICKUP.VARIANT.IMMORAL_HEART, 0, true)
				elseif pickup.SubType == HeartSubType.HEART_HALF_SOUL then
					pickup:Morph(5, mod.PICKUP.VARIANT.HALF_IMMORAL_HEART, 0, true)
				elseif pickup.SubType == HeartSubType.HEART_BLENDED then
					pickup:Morph(5, mod.PICKUP.VARIANT.BLENDED_IMMORAL_HEART, 0, true)
				elseif room:GetType() ~= RoomType.ROOM_SUPERSECRET then
					if pickup.SubType == HeartSubType.HEART_ETERNAL or pickup.SubType == HeartSubType.HEART_GOLDEN then
						pickup:Morph(5, mod.PICKUP.VARIANT.IMMORAL_HEART, 0, true)
					elseif pickup.SubType == HeartSubType.HEART_BONE and grng:RandomInt(5) == 0 then
						pickup:Morph(5, mod.PICKUP.VARIANT.IMMORAL_HEART, 0, true)
					elseif grng:RandomInt(99) + 1 <= 33 + (33 * heartluck/13) then
						if pickup.SubType == HeartSubType.HEART_HALF then
							pickup:Morph(5, mod.PICKUP.VARIANT.HALF_IMMORAL_HEART, 0, true)
						else
							pickup:Morph(5, mod.PICKUP.VARIANT.IMMORAL_HEART, 0, true)
						end
					end
				end
			end
		end
	end
end, PickupVariant.PICKUP_HEART)

mod:AddCallback(CustomHealthAPI.Enums.Callbacks.PRE_ADD_HEALTH, function(_, player, key, hp)
	if (FiendFolio.FiendConfig and not FiendFolio.FiendConfig.ImpBabyMode) and hp > 0 then
		if key == "BONE_HEART" then
			if not mod:GetEntityData(player).revivingViaDevilsHarvest then
				for i = 1, hp * 8 do
					-- bone orbitals are unaffected by the familiar cache
					local fam = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BONE_ORBITAL, 0, player.Position + RandomVector() * 20, Vector(0,0), player):ToFamiliar()
					fam.Player = player
				end
			end
			return true
		elseif CustomHealthAPI.Library.GetInfoOfKey(key, "Type") == CustomHealthAPI.Enums.HealthTypes.CONTAINER and
		       CustomHealthAPI.Library.GetInfoOfKey(key, "KindContained") ~= CustomHealthAPI.Enums.HealthKinds.NONE
		then
			local maxHP = CustomHealthAPI.Library.GetInfoOfKey(key, "MaxHP")
			local canHaveHalfCapacity = CustomHealthAPI.Library.GetInfoOfKey(key, "CanHaveHalfCapacity")

			if maxHP < 1 then
				if canHaveHalfCapacity then
					return "BLACK_HEART", hp
				else
					return "BLACK_HEART", hp * 2
				end
			else
				local fullKeysToAdd = math.floor(hp / maxHP)
				local newHP = fullKeysToAdd * 2
				if hp % maxHP ~= 0 then
					newHP = newHP + 1
				end

				return "BLACK_HEART", newHP
			end
		elseif CustomHealthAPI.Library.GetInfoOfKey(key, "Type") == CustomHealthAPI.Enums.HealthTypes.RED then
			return true
		elseif CustomHealthAPI.Library.GetInfoOfKey(key, "Type") == CustomHealthAPI.Enums.HealthTypes.SOUL and
		       key ~= "IMMORAL_HEART" and
			   key ~= "BLACK_HEART"
		then
			local maxHP = CustomHealthAPI.Library.GetInfoOfKey(key, "MaxHP")

			local fullKeysToAdd = math.floor(hp / maxHP)
			local newHP = fullKeysToAdd * 2
			if hp % maxHP ~= 0 then
				newHP = newHP + 1
			end

			return "BLACK_HEART", newHP
		end
	end
end, FiendFolio.PLAYER.FIEND)

mod:AddCallback(CustomHealthAPI.Enums.Callbacks.POST_RESYNC_PLAYER, function(_, player)
	if not FiendFolio.FiendConfig.ImpBabyMode then
		local hearts = CustomHealthAPI.Library.GetHealthInOrder(player)

		local numImmoral = 0
		local numBlack = 0
		for i = #hearts, 1, -1 do
			local health = hearts[i]
			local key = health.Other.Key
			local typeOfKey = CustomHealthAPI.Library.GetInfoOfKey(key, "Type")

			if typeOfKey == CustomHealthAPI.Enums.HealthTypes.SOUL and key ~= "IMMORAL_HEART" and key ~= "BLACK_HEART" then
				numBlack = numBlack + health.Other.HP
				CustomHealthAPI.Library.RemoveOtherKey(player, i, true)
			elseif CustomHealthAPI.Library.GetInfoOfKey(key, "Type") == CustomHealthAPI.Enums.HealthTypes.CONTAINER and
			       CustomHealthAPI.Library.GetInfoOfKey(key, "KindContained") ~= CustomHealthAPI.Enums.HealthKinds.NONE
			then
				if CustomHealthAPI.Library.GetInfoOfKey(key, "MaxHP") <= 0 then
					numImmoral = numImmoral + 2
				else
					if not mod:GetEntityData(player).revivingViaDevilsHarvest then
						for i = 1, 8 do
							-- bone orbitals are unaffected by the familiar cache
							local fam = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BONE_ORBITAL, 0, player.Position + RandomVector() * 20, Vector(0,0), player):ToFamiliar()
							fam.Player = player
						end
					end
				end
				CustomHealthAPI.Library.RemoveOtherKey(player, i, true)
			end
		end

		if numImmoral ~= 0 then mod:AddImmoralHearts(player, numImmoral) end
		if numBlack ~= 0 then player:AddBlackHearts(numBlack) end
	end
end, FiendFolio.PLAYER.FIEND)

mod:AddCallback(CustomHealthAPI.Enums.Callbacks.PRE_ETERNAL_HEAL, function(_, player, key)
	return "IMMORAL_HEART", 1
end, FiendFolio.PLAYER.FIEND)

mod:AddCallback(CustomHealthAPI.Enums.Callbacks.PRE_SPIRIT_SHACKLES_HEAL, function(_, player)
	return "IMMORAL_HEART", 1
end, FiendFolio.PLAYER.FIEND)

mod:AddCallback(CustomHealthAPI.Enums.Callbacks.PRE_HEARTBREAK_HEAL, function(_, player)
	return "IMMORAL_HEART", 1
end, FiendFolio.PLAYER.FIEND)

mod:AddCallback(CustomHealthAPI.Enums.Callbacks.PRE_GLASS_CANNON_HEAL, function(_, player)
	return "IMMORAL_HEART", 1
end, FiendFolio.PLAYER.FIEND)

mod:AddCallback(CustomHealthAPI.Enums.Callbacks.GET_MAX_HP_CONVERSION, function(_, player)
	return "BLACK_HEART"
end, FiendFolio.PLAYER.FIEND)

mod:AddCallback(CustomHealthAPI.Enums.Callbacks.GET_GULLET_HEART_KEY, function(_, player)
	return "IMMORAL_HEART"
end, FiendFolio.PLAYER.FIEND)

mod:AddCallback(CustomHealthAPI.Enums.Callbacks.PRE_NOKILL_HEAL, function(_, player)
	return "IMMORAL_HEART", 1
end, FiendFolio.PLAYER.FIEND)

mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_ADD_HEARTS, function(_, player, amount)
	if player:GetPlayerType() == FiendFolio.PLAYER.FIEND and (FiendFolio.FiendConfig and not FiendFolio.FiendConfig.ImpBabyMode) and amount > 0 then
		if not mod:GetEntityData(player).revivingViaDevilsHarvest then
			for i = 1, amount * 8 do
				-- bone orbitals are unaffected by the familiar cache
				local fam = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BONE_ORBITAL, 0, player.Position + RandomVector() * 20, Vector(0,0), player):ToFamiliar()
				fam.Player = player
			end
		end
		return 0
	end
end, AddHealthType.BONE)

--------------------------------------------------------------------------------
-- Fireballs

local FiendFireballConstants = {
	TearMult = 3,
	AOEMult = 1,
	FireCooldown = 10,
}

function mod:GetFireballCap(player, ptype)
	local fireballCap = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.PYROMANCY) * 3
	fireballCap = fireballCap + player:GetTrinketMultiplier(mod.ITEM.TRINKET.IMP_FINGER)

	local ptype = ptype or player:GetPlayerType()
	if ptype == FiendFolio.PLAYER.FIEND or ptype == FiendFolio.PLAYER.SKELETAL_FIEND then
		fireballCap = fireballCap + 3
	end

	local mult = 1.09 ^ player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.PAK_CHOI)
	return math.floor(fireballCap * mult)
end

function mod:HandleFireballCharge(player)
	local data = mod:GetEntityData(player)
	local sdata = data.ffsavedata
	local ptype = player:GetPlayerType()

	local fireballCap = mod:GetFireballCap(player, ptype)
	if mod.IsActiveRoom() and sdata.orbitingfireballs < fireballCap then
		-- Charge move time
		if not data.firechargetimer then
			local additive = math.min(150, player.MaxFireDelay * 7)
			if not (player:HasCollectible(mod.ITEM.COLLECTIBLE.PYROMANCY) or ptype == FiendFolio.PLAYER.SKELETAL_FIEND) then
				additive = additive * 3
			end

			additive = additive / 1.09 ^ player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.PAK_CHOI) -- Divide by 1.09 to simulate an increased recharge *rate*
			data.firechargetimer = player.FrameCount + additive
		end

		--Safety check?
		if (data.firechargetimer - player.FrameCount) > 100000 then
			data.firechargetimer = nil
		end

		if player.FrameCount >= data.firechargetimer then
			data.firechargetimer = nil

			local fiendflasheffect = Isaac.Spawn(1000, 668, 0, player.Position, Vector(0,0), player):ToEffect()
			mod:GetEntityData(fiendflasheffect).parent = player
			if mod:isSuperpositionedPlayer(player) then
				local flashcolor = Color.Lerp(fiendflasheffect.Color, Color(1,1,1,1,0,0,0), 0)
				flashcolor.A = flashcolor.A / 4
				fiendflasheffect.Color = flashcolor
			end
			sfx:Play(SoundEffect.SOUND_FLAME_BURST, 0.3, 0, false, math.random(150,160)/100)

			sdata.orbitingfireballs = sdata.orbitingfireballs + 1
			player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS, true)
		end
	end
end
mod:AddCallback(FiendFolio.CALLBACK.FF_POST_PLAYER_UPDATE, mod.HandleFireballCharge, FiendFolio.PLAYER.SKELETAL_FIEND)

function mod:MaybeHandleFireballCharge(player)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.PYROMANCY) or player:HasTrinket(mod.ITEM.TRINKET.IMP_FINGER) then
		mod:HandleFireballCharge(player)
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.ITEM.COLLECTIBLE.PYROMANCY, mod.MaybeHandleFireballCharge)
mod:AddTrinketCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.ITEM.TRINKET.IMP_FINGER, mod.MaybeHandleFireballCharge)

function mod.fireballFamiliarCache(player, data, grng)
	if data and data.orbitingfireballs ~= nil then
		player:CheckFamiliar(mod.ITEM.FAMILIAR.FIEND_ORBITING_FIREBALL, data.orbitingfireballs, grng)
	end
end

function FiendFolio.LaunchFireball(player, dir, mode)
	local isSuperpositioned = mod:isSuperpositionedPlayer(player)

	local tear = Isaac.Spawn(2, TearVariant.FIRE_MIND, 0, player.Position, dir, player):ToTear()
	tear.CollisionDamage = math.max(3.5, player.Damage) * FiendFireballConstants.TearMult
	tear.FallingAcceleration = 0
	tear.FallingSpeed = 0
	sfx:Play(mod.Sounds.FireballLaunch, 0.4, 0, false, math.random(90, 110)/100)
	--[[if tear.Variant ~= TearVariant.FIRE_MIND then
		tear:ChangeVariant(TearVariant.FIRE_MIND)
	end

	tear.TearFlags = (tear.TearFlags)
									& ~(
										TearFlags.TEAR_PIERCING
									  | TearFlags.TEAR_ABSORB
									  | TearFlags.TEAR_BOOGER
									  | TearFlags.TEAR_STICKY
										)

	tear.Color = Color(1,1,1,1,0,0,0) -- reset the color]]
	tear.TearFlags = TearFlags.TEAR_NORMAL
	tear.Size = tear.Size * 2.5
	local sprite = tear:GetSprite()
	local suff
	if sprite:IsPlaying("MoveVert") then
		suff = "Vert"
	else
		suff = "Hori"
	end
	if mode == "implosion" then
		sprite:ReplaceSpritesheet(0, "gfx/projectiles/fireball_implosion.png")
	elseif mode == "fiendSpecial" then
		sprite:ReplaceSpritesheet(0, "gfx/projectiles/projectile_fiendishfireball.png")
	elseif mode == "fireBone" then
		sprite:ReplaceSpritesheet(0, "gfx/projectiles/projectile_firebone.png")
	else
		sprite:ReplaceSpritesheet(0, "gfx/projectiles/fireball.png")
	end
	sprite:LoadGraphics()
	sprite.Scale = sprite.Scale * 3

	local tdata = mod:GetEntityData(tear)
	TearFlagsLib.AddTearFlags(tear, TearFlagsLib.Flag.YIN_YANG)
	if mode == "fiendSpecial" then
		TearFlagsLib.SetTearFlagParams(tear, TearFlagsLib.Flag.YIN_YANG, {Strength = 0.08})
	else
		TearFlagsLib.SetTearFlagParams(tear, TearFlagsLib.Flag.YIN_YANG, {Strength = 0.02})
	end
	tdata.specialfiend = true
	if mode == "implosion" then
		tdata.implosionCard = true
	elseif player:GetPlayerType() == FiendFolio.PLAYER.FIEND then
		tdata.spawnTempBlackHeart = true
	end
	if mode == "fiendSpecial" then
		tdata.fiendishfire = true
	end
	if mode == "fireBone" then
		tdata.firebone = true
	end
	sfx:Play(SoundEffect.SOUND_FLAME_BURST, 0.3, 0, false, math.random(90,110)/100)
	sfx:Play(SoundEffect.SOUND_FLAMETHROWER_END, 0.3, 0, false, math.random(90,110)/100)

	if isSuperpositioned then
		local tearcolor = Color.Lerp(tear.Color, Color(1,1,1,1,0,0,0), 0)
		tearcolor.A = tearcolor.A / 4
		tear.Color = tearcolor
		tdata.IsSuperpositioned = true
	end
end

function mod.fireballOnDoubleTap(player, action, data, sdata)
	if sdata.orbitingfireballs <= 0
	or (data.fireballtimer and player.FrameCount - data.fireballtimer < FiendFireballConstants.FireCooldown) then
		return
	end

	if player:GetFireDirection() < 0 then return end

	local dir = FiendFolio.GetCorrectedFiringInput(player)
	local idealPos = player.Position + (dir * 10)

	local idealDist = 99999999
	local orbiter
	for _, fam in ipairs(Isaac.FindByType(3, mod.ITEM.FAMILIAR.FIEND_ORBITING_FIREBALL, -1, false, false)) do
		if fam:ToFamiliar().Player.Index == player.Index then
			local dist = fam.Position:DistanceSquared(idealPos)
			if dist < idealDist then
				idealDist = dist
				orbiter = fam
			end
		end
	end

	data.firechargetimer = nil

	local mode = nil
	if mod:GetEntityData(orbiter).IsFiendishFire then
		mode = "fiendSpecial"
	elseif mod:GetEntityData(orbiter).IsFirebone then
		mode = "fireBone"
	end
	FiendFolio.LaunchFireball(player, dir * 30, mode)

	data.fireballtimer = player.FrameCount
	sdata.orbitingfireballs = sdata.orbitingfireballs - 1
	orbiter:Remove()
	player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS)
	player:EvaluateItems()
end

local changingvar = {
	[TearVariant.BLUE] = TearVariant.BLOOD,
	[TearVariant.CUPID_BLUE] = TearVariant.CUPID_BLOOD,
	[TearVariant.PUPULA] = TearVariant.PUPULA_BLOOD,
	[TearVariant.GODS_FLESH] = TearVariant.GODS_FLESH_BLOOD,
	[TearVariant.NAIL] = TearVariant.NAIL_BLOOD,
	[TearVariant.GLAUCOMA] = TearVariant.GLAUCOMA_BLOOD,
	[TearVariant.EYE] = TearVariant.EYE_BLOOD,
}

function mod:fiendTears(entity, player, weaponFlag)
	if (player:GetPlayerType() == FiendFolio.PLAYER.FIEND and
	   --not FiendFolio.FiendConfig.ClassicTears and
	   not FiendFolio.FiendConfig.ImpBabyMode)
	   or player:GetPlayerType() == FiendFolio.PLAYER.BIEND
	   or mod:GetEntityData(player).MaliceMinion
	   or mod:GetEntityData(player).TheRealTaintedFiend
	then
		if entity.Type == EntityType.ENTITY_TEAR then
			mod:makeTearBloody(entity)
		elseif weaponFlag == TearFlagsLib.WeaponFlag.FF_PLANET_X then
			mod:makePlanetXBloody(entity)
		end
	end
end
mod:AddCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, mod.fiendTears)

function mod:explodeFiendProj(tear, fireDamage, spreadMulti)
	local tdata = mod:GetEntityData(tear)
	local isSuperpositioned = mod:GetEntityData(tear).IsSuperpositioned
	spreadMulti = spreadMulti or 5
	math.randomseed(tear.Index + tear.FrameCount)
	if sfx:IsPlaying(SoundEffect.SOUND_TEARIMPACTS) then sfx:Stop(SoundEffect.SOUND_TEARIMPACTS) end
	sfx:Play(mod.Sounds.FireballLand, 1.4, 0, false, math.random(90, 110)/100)
	local explosion
	if tdata.firebone then
		explosion = Isaac.Spawn(1000, 7012, 50, tear.Position, nilvector, nil)
	else
		explosion = Isaac.Spawn(1000, 7018, 0, tear.Position, nilvector, nil)
	end
	if isSuperpositioned then
		local explosioncolor = Color.Lerp(explosion.Color, Color(1,1,1,1,0,0,0), 0)
		explosioncolor.A = explosioncolor.A / 4
		explosion.Color = explosioncolor
	end
	local aoeMult = FiendFireballConstants.AOEMult / FiendFireballConstants.TearMult
	local rotExtra = math.random(60)
	colorSet = mod.ColorNormal
	if tdata.implosionCard then
		colorSet = Color(1,1,1,1,-0.5,0.5,-0.5)
	elseif tdata.fiendishfire then
		colorSet = Color(1,1,1,1,66 / 255,13 / 255,202 / 255)
	elseif tdata.firebone then
		colorSet = Color(1,1,1,1,-0.3,-0.3,0.3)
	end
	if tdata.implosionCard or (tdata.fiendishfire and math.random(1,3) == 1) then
		local spood = Isaac.Spawn(1000, mod.PICKUP.VARIANT.FIEND_MINION_EFFECT, 0, tear.Position, nilvector, tear.SpawnerEntity)
		--[[if tdata.fiendishfire then
			local sprit = spood:GetSprite()
			sprit:ReplaceSpritesheet(0, "gfx/familiar/fiend/minions/morsel_minion_fiendish_half.png")
			sprit:ReplaceSpritesheet(1, "gfx/familiar/fiend/minions/morsel_minion_fiendish_half.png")
			sprit:ReplaceSpritesheet(6, "gfx/familiar/fiend/minions/morsel_minion_fiendish_half.png")
			sprit:ReplaceSpritesheet(7, "gfx/familiar/fiend/minions/morsel_minion_fiendish_half.png")
			sprit:LoadGraphics()
		end]]
		mod:GetEntityData(spood).canreroll = false
		spood.EntityCollisionClass = 4
		spood.Parent = tear.SpawnerEntity
		mod:GetEntityData(spood).hollow = true
	elseif tdata.firebone then
		--[[local spood = Isaac.Spawn(3, 128, 0, tear.Position, nilvector, tear.SpawnerEntity)
		spood.Parent = tear.SpawnerEntity
		spood.Color = FiendFolio.ColorSkeletalFiend
		spood:Update()]]
	end
	for i = 1, 6 do
		for j = 0, 2 do
			local rotInd = 0.33 * j
			local vecMinus = 0
			if j > 0 then
				vecMinus = 10
			end
			local e = Isaac.Spawn(1000, 7015, 0, tear.Position, Vector(0, 1):Resized((30 - vecMinus)/spreadMulti):Rotated((i - rotInd)*60 + rotExtra), tear.Parent)
			mod:GetEntityData(e).damage = fireDamage
			mod:GetEntityData(e).implosionCard = mod:GetEntityData(tear).implosionCard
			mod:GetEntityData(e).spawnTempBlackHeart  = mod:GetEntityData(tear).spawnTempBlackHeart
			mod:GetEntityData(e).firebone  = mod:GetEntityData(tear).firebone
			e.Color = colorSet
			if isSuperpositioned then
				local ecolor = Color.Lerp(e.Color, Color(1,1,1,1,0,0,0), 0)
				ecolor.A = ecolor.A / 4
				e.Color = ecolor
				mod:GetEntityData(e).IsSuperpositioned = true
			end
			e.Size = 16
		end
	end
end

function mod.fireballTears(tear, d)
	if d.specialfiend then
		tear.FallingAcceleration = 0
		tear.FallingSpeed = 0

		if tear.FrameCount % 2 == 1 then
			local fire = Isaac.Spawn(1000, 7015, 0, tear.Position, nilvector, tear.Parent)
			fire.Size = 1
			mod:GetEntityData(fire).implosionCard = mod:GetEntityData(tear).implosionCard
			mod:GetEntityData(fire).firebone = mod:GetEntityData(tear).firebone
			if d.IsSuperpositioned then
				local firecolor = Color.Lerp(fire.Color, Color(1,1,1,1,0,0,0), 0)
				firecolor.A = firecolor.A / 4
				fire.Color = firecolor
				mod:GetEntityData(fire).IsSuperpositioned = true
			end
			fire:Update()

			local firesub = 0
			if d.fiendishfire then
				firesub = 1
			end
			local plume = Isaac.Spawn(1000, 147, firesub, tear.Position, nilvector, tear.Parent)
			plume.SpriteScale = plume.SpriteScale * 0.75
			plume.SpawnerEntity = tear.Parent
			plume.Parent = tear.Parent
			plume.CollisionDamage = 0
			if d.implosionCard then
				plume.Color = Color(1,1,1,1,-0.5,0.5,-0.5)
			elseif d.firebone then
				plume.Color = FiendFolio.ColorSkeletalFiend
			end
			if d.IsSuperpositioned then
				local plumecolor = Color.Lerp(plume.Color, Color(1,1,1,1,0,0,0), 0)
				plumecolor.A = plumecolor.A / 4
				plume.Color = plumecolor
			end
			plume:Update()
		end

		if tear.Velocity:Length() < 5 then
			tear:Die()
		end

		if tear:IsDead() then
			local npcs = Isaac.FindInRadius(tear.Position, 500, EntityPartition.ENEMY)
			for _,npc in ipairs(npcs) do
				if (tear.Position - npc.Position):Length() < 75 * 0.75 + npc.Size and
				   game:GetRoom():CheckLine(tear.Position, npc.Position, 2) and
				   not npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)
				then
					npc:TakeDamage(6, DamageFlag.DAMAGE_EXPLOSION, EntityRef(tear), 0)
					if not (npc:HasEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK) or npc:HasEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)) then
						npc.Velocity = npc.Velocity + (npc.Position - tear.Position):Resized(8)
					end
				end
			end
			local crater = Isaac.Spawn(1000, 18, 0, tear.Position, nilvector, nil)
			crater.SpriteScale = Vector(0.75, 0.75)
			sfx:Play(SoundEffect.SOUND_BOSS1_EXPLOSIONS, 1, 0, false, 1)
			--game:BombExplosionEffects(tear.Position, 6, 0, Color(0, 0, 0, 0, 0, 0, 0), npc, 0.75, false, true)
			mod:explodeFiendProj(tear, FiendFireballConstants.AOEMult / FiendFireballConstants.TearMult)
			mod:TakeDownFriendWantedPoster(tear.Position)
		end
	end
end

function mod:fiendTearCollision(tear, collider)
	if mod:GetEntityData(tear).specialfiend then
		mod:GetEntityData(tear).removaltime = true
		local npcs = Isaac.FindInRadius(tear.Position, 500, EntityPartition.ENEMY)
		for _,npc in ipairs(npcs) do
			if (tear.Position - npc.Position):Length() < 75 * 0.5 + npc.Size and
			   game:GetRoom():CheckLine(tear.Position, npc.Position, 2) and
			   not npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)
			then
				npc:TakeDamage(2, DamageFlag.DAMAGE_EXPLOSION, EntityRef(tear), 0)
				local crater = Isaac.Spawn(1000, 18, 0, tear.Position, nilvector, nil)
				crater.SpriteScale = Vector(0.5, 0.5)
				sfx:Play(SoundEffect.SOUND_BOSS1_EXPLOSIONS, 1, 0, false, 1)
				--game:BombExplosionEffects(tear.Position, 2, 0, Color(0, 0, 0, 0, 0, 0, 0), npc, 0.5, false, true)
				mod:explodeFiendProj(tear, tear.CollisionDamage * 1/12, 10)
				if not (npc:HasEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK) or npc:HasEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)) then
					npc.Velocity = npc.Velocity + (npc.Position - tear.Position):Resized(8)
				end
			end
		end
		mod:TakeDownFriendWantedPoster(tear.Position)
	end
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
	local sprite = effect:GetSprite()
	for _, npc in pairs(Isaac.GetRoomEntities()) do
		if npc:IsEnemy() and npc:IsVulnerableEnemy() and npc.Position:Distance(effect.Position) - effect.Size - npc.Size <= 0 then
			npc:TakeDamage(mod:GetEntityData(effect).damage or 1.4, DamageFlag.DAMAGE_FIRE, EntityRef(effect), 4)
		end
	end
	if effect.FrameCount % 1 == 0 then
		sprite.Scale = sprite.Scale:Resized(sprite.Scale:Length() - 0.1)--(effect.Size - 1) / effect.Size)
		effect.Size = effect.Size - 1
	end
	if effect.Size < 10 then
		local alpha = effect.Size / 10
		if mod:GetEntityData(effect).IsSuperpositioned then
			alpha = alpha / 4
		end
		effect.Color = Color(effect.Color.R, effect.Color.G, effect.Color.B, alpha, effect.Color.RO, effect.Color.GO, effect.Color.BO)
	end
	if effect.Size <= 0 then
		effect:Remove()
		effect.Visible = false
	end
end, 7015)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
	if effect.SubType == 24 then
		local sprite = effect:GetSprite()
		if sprite:IsPlaying("Flush") then
			if sprite:IsFinished("Flush") then
				effect:Remove()
			end
		else
			effect.SpriteRotation = effect.FrameCount * 20
			effect.SpriteScale = effect.SpriteScale * 0.95
			if effect.FrameCount > 60 then
				effect:Remove()
			end
		end
	else
		local sprite = effect:GetSprite()
		if sprite:IsFinished("Explosion") then
			effect:Remove()
		end
	end
end, 7018)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, familiar)
	familiar:AddToOrbit(7019)
	familiar.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
	familiar.Color = Color(familiar.Color.R, familiar.Color.G, familiar.Color.B, 0)
	familiar:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	if mod.SkeletalFiendRequestsNoCandleSounds then
		mod.SkeletalFiendRequestsNoCandleSounds = false
	else
		sfx:Play(SoundEffect.SOUND_CANDLE_LIGHT)
	end
end, mod.ITEM.FAMILIAR.FIEND_ORBITING_FIREBALL)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, familiar)
	local sprite = familiar:GetSprite()
	local data = mod:GetEntityData(familiar)
	local pdata = mod:GetEntityData(familiar.Player)
	data.specialfiend = true
	sprite:Play("MoveHori", false)

	familiar.OrbitDistance = Vector(30, 30)
	familiar.OrbitSpeed = -0.08
	familiar.Velocity = familiar:GetOrbitPosition(familiar.Player.Position + familiar.Player.Velocity) - familiar.Position

	--sprite.Rotation = (familiar.Position - familiar.Player.Position):GetAngleDegrees() + 90
	sprite.Offset = Vector(0, -14)

	local fcABH = 5
	if familiar.FrameCount <= fcABH then
		familiar.Color = Color(familiar.Color.R, familiar.Color.G, familiar.Color.B, familiar.FrameCount / fcABH, familiar.Color.RO, familiar.Color.GO, familiar.Color.BO)
	end
	if (familiar.Player:GetPlayerType() == FiendFolio.PLAYER.FIEND and familiar.Player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT))
	or pdata.nextFireballShouldBeFiendish then
		pdata.nextFireballShouldBeFiendish = nil
		sprite:ReplaceSpritesheet(0, "gfx/familiar/fiend/effect_fiendishfireballwisp.png")
		sprite:LoadGraphics()
		data.IsFiendishFire = true
	elseif familiar.Player:GetPlayerType() == FiendFolio.PLAYER.SKELETAL_FIEND then
		sprite:ReplaceSpritesheet(0, "gfx/familiar/fiend/effect_firebonewisp.png")
		sprite:LoadGraphics()
		data.IsFirebone = true
	end
end, mod.ITEM.FAMILIAR.FIEND_ORBITING_FIREBALL)

--[[mod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, function(_, familiar, collider) --Yeah nobody likes them blowing up on enemies lol
	local isFiendish = (mod:GetEntityData(familiar).IsFiendishFire)
	if collider:IsEnemy() and collider:IsVulnerableEnemy() and collider:IsActiveEnemy() then
		sfx:Play(mod.Sounds.FireballLand, 1.4, 0, false, 0.7)
		local explosion = Isaac.Spawn(1000, 7018, 0, familiar.Position, nilvector, nil)
		if mod:isSuperpositionedPlayer(familiar.Player) then
			local explosioncolor = Color.Lerp(explosion.Color, Color(1,1,1,1,0,0,0), 0)
			explosioncolor.A = explosioncolor.A / 4
			explosion.Color = explosioncolor
		end
		if isFiendish then
			local spood = Isaac.Spawn(1000, mod.PICKUP.VARIANT.FIEND_MINION_EFFECT, 0, familiar.Position, nilvector, familiar.Player)
			local sprit = spood:GetSprite()
			sprit:ReplaceSpritesheet(0, "gfx/familiar/fiend/minions/morsel_minion_fiendish_half.png")
			sprit:ReplaceSpritesheet(1, "gfx/familiar/fiend/minions/morsel_minion_fiendish_half.png")
			sprit:ReplaceSpritesheet(6, "gfx/familiar/fiend/minions/morsel_minion_fiendish_half.png")
			sprit:ReplaceSpritesheet(7, "gfx/familiar/fiend/minions/morsel_minion_fiendish_half.png")
			sprit:LoadGraphics()
			mod:GetEntityData(spood).canreroll = false
			spood.EntityCollisionClass = 4
			spood.Parent = familiar.Player
			mod:GetEntityData(spood).hollow = true
		end
		local sdata = mod:GetEntityData(familiar.Player).ffsavedata
		sdata. = sdata.orbitingfireballs - 1
		familiar:Remove()
		familiar.Player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS)
		familiar.Player:EvaluateItems()
		collider:TakeDamage(familiar.Player.Damage * 5, DamageFlag.DAMAGE_EXPLOSION, EntityRef(familiar.Player), 0)
	end
end, mod.ITEM.FAMILIAR.FIEND_ORBITING_FIREBALL)]]

function mod:PostTakeDmgHandleFiendFireballs(ent, entData, damage, flags, sourceEnt, sourceData, spawner, spawnerData)
	if flags & DamageFlag.DAMAGE_CLONES ~= 0 then return end

	if sourceData.spawnTempBlackHeart then
		entData.spawnFiendishBlackHeart = true
		mod.FiendDoingFireballs = true
	end
	if sourceData.firebone then
		entData.spawnSkeletalFiendFirebone = true
		mod.FiendDoingFireballs = true
	end

	local player = nil
	local playerIsFiend = false
	if sourceEnt.Type == EntityType.ENTITY_PLAYER and sourceEnt.Variant == 0 and
	   (sourceEnt.SubType == FiendFolio.PLAYER.FIEND or sourceEnt.SubType == FiendFolio.PLAYER.SKELETAL_FIEND)
	then
		player = sourceEnt:ToPlayer()
		playerIsFiend = true
	elseif not (sourceEnt:ToNPC() or sourceEnt:ToPickup() or sourceEnt:ToFamiliar()) and
		   spawner and
		   spawner.Type == EntityType.ENTITY_PLAYER and
		   spawner.Variant == 0 and
		   (spawner:ToPlayer():GetPlayerType() == FiendFolio.PLAYER.FIEND or
		   spawner:ToPlayer():GetPlayerType() == FiendFolio.PLAYER.SKELETAL_FIEND)
	then
		player = spawner:ToPlayer()
		playerIsFiend = true
	end

	local sourceIsFireball = false
	if sourceEnt.Type == EntityType.ENTITY_TEAR and sourceData.specialfiend then
		sourceIsFireball = true
	end

	if playerIsFiend and not sourceIsFireball then
		entData.spawnFiendFireball = player
		local playerData = mod:GetEntityData(player)
		playerData.ffsavedata.fiendDamageDealt = (playerData.ffsavedata.fiendDamageDealt or 0) + math.min(damage, ent.HitPoints)
		mod.FiendDoingFireballs = true
	end
end

--------------------------------------------------------------------------------
-- Minions

function mod:getClosestEnemyMinion(position, radius)
	radius = radius ^ 2
	local target
	for _, ent in ipairs(Isaac.GetRoomEntities()) do
		if ent:IsActiveEnemy() and ent:IsVulnerableEnemy() and not ent:IsDead()
		and not ent:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and ent.Type ~= mod.FFID.Tech
		and ent:ToNPC().Pathfinder:HasPathToPos(position, false) then
			local distance = position:DistanceSquared(ent.Position)
			if distance < radius then
				radius = distance
				target = ent
			end
		end
	end
	return target
end

function mod:getClosestEnemyFlyingMinion(position, radius)
	radius = radius ^ 2
	local target
	for _, ent in ipairs(Isaac.GetRoomEntities()) do
		if ent:IsActiveEnemy() and ent:IsVulnerableEnemy() and not ent:IsDead()
		and not ent:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and ent.Type ~= mod.FFID.Tech then
			local distance = position:DistanceSquared(ent.Position)
			if distance < radius then
				radius = distance
				target = ent
			end
		end
	end
	return target
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
	local data = mod:GetEntityData(pickup)
	local sprite = pickup:GetSprite()
	math.randomseed(pickup.Index)
	if not data.proof then
		pickup.Parent = Isaac.GetPlayer(0)
		pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		sprite:Play("Appear", false)
		data.proof = true
	end
	if sprite:IsEventTriggered("Bang") then
		if data.spawnhollow then
			local spood = Isaac.Spawn(1000, mod.PICKUP.VARIANT.FIEND_MINION_EFFECT, 0, pickup.Position, Vector(math.random(-5, 5), math.random(-5, 5)), pickup.Parent)
			mod:GetEntityData(spood).hollow = true
			mod:GetEntityData(spood).canreroll = false
			spood:Update()
		else
			local spood = Isaac.Spawn(5, mod.PICKUP.VARIANT.FIEND_MINION, pickup.SubType, pickup.Position, Vector(math.random(-5, 5), math.random(-5, 5)), pickup.Parent)
			spood.Parent = pickup.Parent
			spood:Update()
		end
	end
	if sprite:IsFinished("Appear") then
		pickup:Remove()
	end
end, mod.PICKUP.VARIANT.FIEND_EGG)

--Fiend Minions, fiendminions
function mod:FiendMinionAI(pickup)
	if not pickup.Parent then
		pickup.Parent = Isaac.GetPlayer(0)
	end
	local room = game:GetRoom()
	local roomtype = room:GetType()
	local player = pickup.Parent:ToPlayer()
	local sprite = pickup:GetSprite()
	local data = mod:GetEntityData(pickup)

	local isEffect
	if pickup.Type == 1000 then
		if pickup.SubType == 10 then
			data.amethyst = true
		else
			data.hollow = true
		end
		isEffect = true
	end

	if not data.triedToMinionfy then
		local rand = math.random(100000)
		if rand == 1 and not data.amethyst then
			for i = 0, 7 do
				sprite:ReplaceSpritesheet(i, "gfx/familiar/fiend/minions/morsel_minion_gru.png")
			end
			sprite:LoadGraphics()
			data.isMinion = true
		elseif data.fiendsLostFriend then
			for i = 0, 7 do
				sprite:ReplaceSpritesheet(i, "gfx/familiar/fiend/minions/morsel_minion_black.png")
			end
			sprite:LoadGraphics()
		end
		data.triedToMinionfy = true
	end

	if sprite:IsPlaying("Drop") then
		pickup.Velocity = pickup.Velocity * 0.8
	end

	if player.CanFly then
		data.flying = true
	else
		data.flying = false
	end

	local playerIsFiend = player:GetPlayerType() == mod.PLAYER.FIEND

	--[[if player:GetEffects() then
		if player:HasCollectible(CollectibleType.COLLECTIBLE_GNAWED_LEAF) and player:GetMovementVector():Length() < 0.01 then
			if not data.gnawedLeafFrozen then
				data.gnawedLeafFrozen = true
				pickup.Color = Color(1.5, 1.5, 1.5, 1, 0, 0 ,0)
				local poof = Isaac.Spawn(1000, 15, 0, pickup.Position, nilvector, nil)
				poof.SpriteScale = poof.SpriteScale * 0.5
			end
		else
			data.gnawedLeafFrozen = false
			pickup.Color = mod.ColorNormal
		end
	end]]

	--[[if player:HasCollectible(247) then
		if not data.setbig then
			pickup:SetSize(26, Vector(2,2), 12)
			pickup.SpriteScale = pickup.SpriteScale * 2
			data.setbig = true
		end
	end]]

	local headsprite = "Head"
	if data.amethyst then
		data.headframe = data.headframe or math.random(120) - 1
	elseif data.fiendsLostFriend then
		data.headframe = 1
	elseif data.hollow or data.hollowanim then
		data.headframe = data.headframe or math.random(10) - 1
	end
	data.headframe = data.headframe or math.random(206) - 1
	if not sprite:IsPlaying("Drop") then
		sprite:SetOverlayFrame(headsprite, data.headframe)
	end

	if data.fiendsLostFriend then
		pickup.SpriteScale = Vector(1.25,1.25)
	end

	if not data.dead then
		if data.flying then
			pickup.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
		else
			pickup.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
		end
		pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL

		if not data.transforming then
			if mod.GetPersistentPlayerData(player).warHornActive then
				if not data.FFBerserkWarHorned then
					mod.WarHorn.BerserkFamiliar(pickup)
				end
			else
				if data.FFBerserkWarHorned then
					if mod:GetEntityData(player).warHornPenalty then
						for i = 1, 11 - math.random(5) do
							local smoke = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, 0, pickup.Position, Vector.FromAngle(math.random() * 360) * math.random() * 10, nil):ToEffect()
							smoke.Color = Color(158/255, 11/255, 15/255, 67/255, 0, 0, 0)
							smoke:SetTimeout(10 + math.random(15))
							smoke:Update()
						end

						for i = 1, 8 do
							Isaac.Spawn(1000, 5, 0, pickup.Position, RandomVector() * math.random() * 10, pickup)
						end

						local poof = Isaac.Spawn(1000, 16, 4, pickup.Position, Vector.Zero, pickup):ToEffect()
						poof.SpriteScale = Vector(0.5, 0.5)

						sfx:Play(SoundEffect.SOUND_SIREN_MINION_SMOKE)
						game:ShakeScreen(5)

						data.transforming = true
					else
						mod.WarHorn.UnberserkFamiliar(pickup)
					end
				end
			end

			if data.FFBerserkWarHorned then
				mod:berserkOnUpdate(pickup, mod:GetEntityData(pickup), pickup:GetSprite())

				if data.FFBerserkDuration >= 0 then
					local colour = Color.Lerp(familiarBerserkBase, FiendFolio.StatusEffectColors.BerserkFlash, math.abs(math.sin(math.pi / 8 * game:GetFrameCount())))
					local realColour = Color(1, 1, 1, 1, colour.R / 2.5, colour.G / 2.5, colour.B / 2.5)
					pickup:SetColor(realColour, 2, 126, false, false)
				end
			end
		end

		if data.transforming or ((not mod.IsActiveRoom() and (not data.persistent or data.remainingRooms <= 0) and (not data.mixPersistent or data.mixRemainingRooms <= 0)) or (data.amethyst and pickup.FrameCount > 300)) and not data.fiendsLostFriend then
			if data.amethyst then
				local poof = Isaac.Spawn(1000, 15, 0, pickup.Position, nilvector, nil)
				poof.SpriteScale = poof.SpriteScale * 0.5
				poof.Color = Color(1,0.3,1,1,10 / 255,0,10 / 255)
				pickup:Remove()
			elseif data.hollow or isEffect then
				--data.dead = true
				local dedbaby = Isaac.Spawn(1000, 2, 1, pickup.Position, nilvector, nil)
				dedbaby.Color = Color(0,0,0,0.7,0,0,0)
				local poof = Isaac.Spawn(1000, 15, 0, pickup.Position, nilvector, nil)
				poof.SpriteScale = poof.SpriteScale * 0.5
				poof.Color = Color(0.3,0.3,0.3,1,10 / 255,0,10 / 255)
				pickup:Remove()
			else
				data.transforming = true
				sprite.FlipX = false
				mod:spritePlay(sprite, "Transform")
				sprite:RemoveOverlay()
				pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
				if sprite:IsPlaying("Transform") and sprite:GetFrame() > 20 then
					local anim = "gfx/familiar/fiend/minions/morsel_minion_black.anm2"
					local id, var, subt = 5, 10, 6
					for _, key in pairs(mod.FiendMixMinions) do
						for _, entry in pairs(key) do
							if pickup.Type == entry.ID and pickup.Variant == entry.Var and pickup.SubType == entry.Sub then
								id = entry.PickupID
								var = entry.PickupVar
								subt = entry.PickupSub
								anim = entry.PickupAnim
								break
							end
						end
					end
					if id and var and subt and anim then
						pickup:Morph(id, var, subt, true)
						sprite:Load(anim, true)
						sprite:Play("Appear",true)
						sprite:Update()
					end
				end
			end
		elseif pickup.FrameCount >= 15 then
			if data.target and (data.target:IsDead() or pickup.FrameCount % 60 == 0 or (data.target.Type == 1 and pickup.FrameCount % 15 == 0)) then
				data.target = nil
			end
			if not data.target then
				if data.flying then
					data.target = mod:getClosestEnemyFlyingMinion(pickup.Position, 900)
				else
					data.target = mod:getClosestEnemyMinion(pickup.Position, 900)
				end
				if not data.target then
					data.target = pickup.Parent
				end
			end

				local speed = math.max(3, player.MoveSpeed * 5)

			if data.gnawedLeafFrozen then
				pickup.Velocity = pickup.Velocity * 0.7
			elseif data.target and pickup.FrameCount % 2 == 0 then
				if data.flying or room:CheckLine(pickup.Position,data.target.Position,0,1,false,false) then
					pickup.Velocity = mod:Lerp(pickup.Velocity, (data.target.Position - pickup.Position):Resized(speed), 0.3)
				else
					local room = Game():GetRoom()
					if room:GetGridCollisionAtPos(pickup.Position) > 0 then
						local freepos = room:FindFreeTilePosition(pickup.Position, 999999)
						pickup.Velocity = mod:Lerp(pickup.Velocity, (freepos - pickup.Position):Resized(speed), 0.3)
					else
						mod:CatheryPathFinding(pickup, data.target.Position, {
							Speed = speed,
							Accel = 0.6
						})
					end
				end
			end
		end

		data.FrameOff = math.random(15) - 1

		if (pickup.FrameCount + data.FrameOff) % math.floor(math.max(3, player.MaxFireDelay)) == 0 and not data.gnawedLeafFrozen then
			for _,g in ipairs(Isaac.GetRoomEntities()) do
				if g:IsActiveEnemy() and g:IsVulnerableEnemy() and not g:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
					if g.Position:Distance(pickup.Position) - g.Size - pickup.Size <= 0 then
						mod:GetEntityData(g).fiendminiondamage = true -- mod compat fun so that i can tell when the minion deals the damage
						mod:GetEntityData(g).fiendminiondealingdamage = pickup -- so that i can tell what minion is dealing the damage

						local startpos = 250
						if pickup.Parent:ToPlayer():HasCollectible(mod.ITEM.COLLECTIBLE.IMP_SODA) then
							startpos = startpos - 100
						end
						if mod:GetEntityData(pickup).fiendBonus then
							startpos = startpos - 100
						end

						local targetData = mod:GetEntityData(g)
						local damageDealt
						local warHornMult = data.FFBerserkWarHorned and 3 or 1

						if math.random(math.max(10, startpos - math.floor(player.Luck * 20))) == 1 then
							damageDealt = player.Damage * 5 * warHornMult
							g:TakeDamage(player.Damage * 5 * warHornMult, 0, EntityRef(player), 0)
							if data.isMinion then
								sfx:Play(mod.Sounds.MinionSoundscape,0.6,0,false,math.random(80,120)/100)
							else
								sfx:Play(SoundEffect.SOUND_BONE_SNAP,1,0,false,math.random(80,120)/100)
							end
							local crit = Isaac.Spawn(1000, 1734, 0, pickup.Position, nilvector, pickup):ToEffect()
							crit.SpriteOffset = Vector(0, -15)
							--crit:FollowParent(pickup)
							crit:Update()
							mod:makeEnemyGib(g)
						else
							if mod:GetEntityData(pickup).persistent then --curse of the imp minions deal more damage
								damageDealt = player.Damage * 0.5 * warHornMult
								g:TakeDamage(player.Damage * 0.5 * warHornMult, 0, EntityRef(player), 0)
							elseif mod:GetEntityData(pickup).fiendsLostFriend then
								damageDealt = player.Damage * warHornMult
								g:TakeDamage(player.Damage * warHornMult, 0, EntityRef(player), 0)
							elseif mod:GetEntityData(pickup).fiendBonus then
								damageDealt = player.Damage * 0.4 * warHornMult
								g:TakeDamage(player.Damage * 0.4 * warHornMult, 0, EntityRef(player), 0)
							else
								damageDealt = player.Damage * 0.2 * warHornMult
								g:TakeDamage(player.Damage * 0.2 * warHornMult, 0, EntityRef(player), 0)
							end
							sfx:Play(SoundEffect.SOUND_MEATY_DEATHS,0.2,0,false,math.random(150,200)/100)
							local dedbaby = Isaac.Spawn(1000, 2, 1, g.Position + Vector(0, 1), nilvector, nil)
							dedbaby.Color = g.SplatColor
							dedbaby.SpriteOffset = g.SpriteOffset + Vector(0,-5) + RandomVector() * math.random(15)
							dedbaby:Update()
						end
						--Whatever
						if playerIsFiend then
							targetData.spawnFiendFireball = player
							mod:GetEntityData(player).ffsavedata.fiendDamageDealt = (mod:GetEntityData(player).ffsavedata.fiendDamageDealt or 0) + damageDealt
							mod.FiendDoingFireballs = true
						end



						if damageDealt >= g.HitPoints and not targetData.incrementedMinionKilled and mod.CanRunUnlockAchievements() then
							targetData.incrementedMinionKilled = true
							mod.savedata.immoralMinionKills = mod.savedata.immoralMinionKills + 1
							mod:CheckPurplePuttyUnlock()
						end

						mod:GetEntityData(g).fiendminiondamage = nil
						--g:BloodExplode()
					end
				elseif g.Type == 1000 and g.Variant == 1736 then
					if g.Position:Distance(pickup.Position) - g.Size - pickup.Size <= 0 then
						pickup.Velocity = pickup.Velocity + (pickup.Position - g.Position):Resized(1)
						g.Velocity = pickup.Velocity + (g.Position - pickup.Position):Resized(1)
					end
				end
			end
		end
		if (not data.transforming) and not (sprite:IsPlaying("Drop")) then
			local extraString = ""
			--if data.hollow or data.hollowimmoral or data.holloweternal or data.hollowred or data.hollowrotten or data.hollowsoul then extraString = "2" end
			if pickup.Velocity:Length() > 0.3 then
				if pickup.Velocity.X > 0 then
					sprite.FlipX = false
				else
					sprite.FlipX = true
				end
				if data.flying then
					if math.abs(pickup.Velocity.X) > math.abs(pickup.Velocity.Y) then
						mod:spritePlay(sprite, "FlyHori" .. extraString)
					else
						mod:spritePlay(sprite, "FlyVert" .. extraString)
					end
				else
					if math.abs(pickup.Velocity.X) > math.abs(pickup.Velocity.Y) then
						mod:spritePlay(sprite, "WalkHori" .. extraString)
					else
						mod:spritePlay(sprite, "WalkVert" .. extraString)
					end
				end
			else
				if data.flying then
					mod:spritePlay(sprite, "FlyVert")
				else
					sprite:SetFrame("WalkVert", 0)
				end
			end
		end
	else
		pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		sprite:Play("Death", false)
		if sprite:IsFinished("Death") then
			pickup:Remove()
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.FiendMinionAI, mod.PICKUP.VARIANT.FIEND_MINION)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.FiendMinionAI, 1736)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_RENDER, function(_, pickup)
	if mod:GetEntityData(pickup).FFBerserkWarHorned and mod.IsStandardRenderMode() then
		mod.statusIconsPlayer(_, pickup, Vector(0, 14) + game:GetRoom():GetRenderScrollOffset(), true) -- idfk man (cat: *I* know, man.)
	end
end, mod.PICKUP.VARIANT.FIEND_MINION)

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, collider, low)
	if collider.Type == 1 or (collider.Type == 5 and collider.Variant ~= mod.PICKUP.VARIANT.FIEND_MINION) then
		return true
	end
end, mod.PICKUP.VARIANT.FIEND_MINION)

function mod.minionMorphOnNewRoom()
	for _, h in pairs(Isaac.FindByType(5, mod.PICKUP.VARIANT.FIEND_MINION, -1, false, false)) do
		local hdata = mod:GetEntityData(h)
		if hdata.mixPersistent and hdata.mixRemainingRooms >= 0 then
			if h.Parent then
				h.Position = h.Parent.Position + Vector(1 * math.random() - 0.5, 1 * math.random() - 0.5)
			else
				h.Position = Isaac.GetPlayer(0).Position + Vector(1 * math.random() - 0.5, 1 * math.random() - 0.5)
			end
			h.Velocity = nilvector

			if mod.IsActiveRoom() then
				hdata.mixRemainingRooms = hdata.mixRemainingRooms - 1
				if hdata.mixRemainingRooms <= 0 then
					hdata.mixPersistent = nil
					hdata.mixRemainingRooms = nil
					h:ClearEntityFlags(EntityFlag.FLAG_PERSISTENT)
				end
			end
		else
			h:Remove()

			local id, var, subt = 5, 10, 6
			for _, key in pairs(mod.FiendMixMinions) do
				for _, entry in pairs(key) do
					if h.Type == entry.ID and h.Variant == entry.Var and h.SubType == entry.Sub then
						id = entry.PickupID
						var = entry.PickupVar
						subt = entry.PickupSub
						break
					end
				end
			end
			if id and var and subt then
				Isaac.Spawn(id, var, subt, h.Position, nilvector, nil)
			end
		end
	end
	for _, h in pairs(Isaac.FindByType(1000, 1736, -1, false, false)) do
		local hdata = mod:GetEntityData(h)
		if hdata.mixPersistent and hdata.mixRemainingRooms >= 0 then
			if h.Parent then
				h.Position = h.Parent.Position + Vector(1 * math.random() - 0.5, 1 * math.random() - 0.5)
			else
				h.Position = Isaac.GetPlayer(0).Position + Vector(1 * math.random() - 0.5, 1 * math.random() - 0.5)
			end
			h.Velocity = nilvector

			if mod.IsActiveRoom() then
				hdata.mixRemainingRooms = hdata.mixRemainingRooms - 1
				if hdata.mixRemainingRooms <= 0 then
					hdata.mixPersistent = nil
					hdata.mixRemainingRooms = nil
					h:ClearEntityFlags(EntityFlag.FLAG_PERSISTENT)
				end
			end
		end
	end
end

mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, function()
	for _, minion in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, mod.PICKUP.VARIANT.FIEND_MINION, -1)) do
		if mod:GetEntityData(minion).mixPersistent then
			minion:ClearEntityFlags(EntityFlag.FLAG_PERSISTENT)
		end
	end
end)

function mod:CritHit(e)
	if e:GetSprite():IsFinished("Crit") then
		e:Remove()
	end
	e.SpriteOffset = e.SpriteOffset + Vector(0, -1)
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.CritHit, 1734)

--------------------------------------------------------------------------------
-- Misc

function mod:fiendChillHeadCostume(player)
	if REVEL and REVEL.GetData then
		-- Fiend has a custom Revelations chill head costume
		local data = REVEL.GetData(player)
		if not data.FrozenSpriteSpritesheet then
			data.FrozenSpriteSpritesheet = {}
		end
		data.FrozenSpriteSpritesheet[FiendFolio.PLAYER.FIEND] = {[0] = "gfx/effects/freezehead_fiend.png", [1] = "gfx/effects/freezeheadmelt_fiend.png"}
	end
end
-- MC_POST_PLAYER_INIT is inconsistent for this rn, this is good enough
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_NEW_ROOM_TEMP_EFFECTS, mod.fiendChillHeadCostume, FiendFolio.PLAYER.FIEND)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, familiar)
	if familiar.Player:GetPlayerType() == FiendFolio.PLAYER.FIEND then
		familiar:GetSprite():ReplaceSpritesheet(0, "gfx/familiar/fiend/fiend_leprocy.png", true)
	end
end, FamiliarVariant.LEPROCY)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, familiar)
	if familiar.Player:GetPlayerType() == FiendFolio.PLAYER.FIEND or familiar.Player:GetPlayerType() == FiendFolio.PLAYER.BIEND then
		familiar:GetSprite():ReplaceSpritesheet(0, "gfx/familiar/fiend/fiend_isaacsheart.png", true)
	end
end, FamiliarVariant.ISAACS_HEART)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, familiar)
	if familiar.Player:GetPlayerType() == FiendFolio.PLAYER.FIEND then
		familiar:GetSprite():ReplaceSpritesheet(0, "gfx/familiar/fiend/fiend_finger.png", true)
	end
end, FamiliarVariant.FINGER)

mod:AddCallback("FF_PLAYER_HURT_SOUND", function()
    sfx:Play(mod.Sounds.FiendHurt, 0.8, 0, false, 1)
    return true
end, mod.PLAYER.FIEND)

mod:AddCallback("FF_PLAYER_DEATH_SOUND", function()
    sfx:Play(mod.Sounds.FiendDies, 0.8, 0, false, 1)
    return true
end, mod.PLAYER.FIEND)