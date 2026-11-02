local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

-- To-do:
--[[
	Fiend Minions need special handling
	Dynamic callbacks
]]

local warHorn = mod.ITEM.COLLECTIBLE.THE_WAR_HORN
local warHorn2 = mod.ITEM.COLLECTIBLE.THE_WAR_HORN_CHARGING
local glueBaby = mod.ITEM.FAMILIAR.GLUE_BABY

local FIRE_COOLDOWN = 16
local FIRE_ANIM_DURATION = 8
local FLOAT_ANIM_DURATION = 16
local CACHE_FLAGS = CacheFlag.CACHE_FAMILIARS | CacheFlag.CACHE_SPEED
local DAMAGE_MULT = 3
local JUDAS_DAMAGE_MULT = 3.33

mod.WarHornDamageMult = DAMAGE_MULT

local familiarBerserkBase = Color(
	FiendFolio.StatusEffectColors.Berserk.R / 3,
	FiendFolio.StatusEffectColors.Berserk.G / 3,
	FiendFolio.StatusEffectColors.Berserk.B / 3
)

local function enableWarHornGhostCallbacks()

end

local function disableWarHornGhostCallbacks()

end

local function replaceWarHorn(player, slot)
	slot = slot or mod.QueryItemSlot(player, warHorn)

	if slot then
		player:RemoveCollectible(warHorn, false, slot)
		player:AddCollectible(warHorn2, 0, false, slot)
	end

	local data = mod.GetPersistentPlayerData(player)
	data.warHornActive = false
	data.warHornNaturalDecay = nil

	player:AddCacheFlags(CACHE_FLAGS, true)
end

local function queryFamiliarFromSpawnerStack(damageSource)
	if not damageSource.Entity then return false end
	if damageSource.Type == 3 then return damageSource.Entity:ToFamiliar() end

	damageSource = damageSource.Entity
	while damageSource.SpawnerEntity do
		if damageSource.SpawnerEntity.Type == 3 then return damageSource.SpawnerEntity:ToFamiliar() end
		damageSource = damageSource.SpawnerEntity
	end

	return false
end

local function familiarBloodExplode(familiar)
	for i = 1, 11 - math.random(5) do
		local smoke = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, 0, familiar.Position, Vector.FromAngle(math.random() * 360) * math.random() * 10, nil):ToEffect()
		smoke.Color = Color(158/255, 11/255, 15/255, 67/255, 0, 0, 0)
		smoke:SetTimeout(10 + math.random(15))
		smoke:Update()
	end

	for i = 1, 8 do
		Isaac.Spawn(1000, 5, 0, familiar.Position, RandomVector() * math.random() * 10, familiar)
	end

	local poof = Isaac.Spawn(1000, 16, 4, familiar.Position, Vector.Zero, familiar):ToEffect()
	poof.SpriteScale = Vector(0.5, 0.5)

	sfx:Play(SoundEffect.SOUND_SIREN_MINION_SMOKE)
	game:ShakeScreen(5)
end

local function getDeadFamiliarList(player)
	local data = mod.GetPersistentPlayerData(player)
	data.warHornDeadFamiliarVariants = data.warHornDeadFamiliarVariants or {}
	return data.warHornDeadFamiliarVariants
end

mod.WarHorn = {
	BerserkFamiliar = function(familiar)
		local data = mod:GetEntityData(familiar)
		data.FFBerserkDuration = 9e9
		data.FFBerserkSource = player
		data.FFBerserkWarHorned = true
	end,

	UnberserkFamiliar = function(familiar)
		local data = mod:GetEntityData(familiar)
		data.FFBerserkDuration = nil
		data.FFBerserkSource = nil
		data.FFBerserkWarHorned = nil

		familiar:GetSprite().PlaybackSpeed = 1.0
		sfx:Play(SoundEffect.SOUND_BERSERK_END, 0.5, 0, false, 1.0)

		for i = 1, 11 - math.random(5) do
			local smoke = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, 0, familiar.Position, Vector.FromAngle(math.random() * 360) * math.random() * 10, nil):ToEffect()
			smoke.Color = Color(158/255, 11/255, 15/255, 67/255, 0, 0, 0)
			smoke:SetTimeout(10 + math.random(15))
			smoke:Update()
		end
	end,

	KillFamiliar = function(familiar, fromValidator)
		if not fromValidator then
			mod.WarHorn.UnberserkFamiliar(familiar)
			familiarBloodExplode(familiar)
		end

		if not Isaac.RunCallbackWithParam(mod.CALLBACK.WAR_HORN_KILL_FAMILIAR, familiar.Variant, familiar) then
			local data = getDeadFamiliarList(familiar.Player)
			data = mod:GetEntityData(familiar.Player)
			data.warHornDeadFamiliars = data.warHornDeadFamiliars or {}
			table.insert(data.warHornDeadFamiliars, familiar)

			data = mod:GetEntityData(familiar)
			data.warHornParams = {
				Color = familiar.Color,
				Follower = familiar.IsFollower,
				CollisionClass = familiar.EntityCollisionClass,
			}

			familiar.EntityCollisionClass = 0
			familiar:RemoveFromFollowers()

			if not fromValidator then
				local savedata = mod.GetPersistentPlayerData(familiar.Player)
				mod.InitTableFields(savedata, "warHornValidator", tostring(familiar.Variant), 0)
				savedata.warHornValidator[tostring(familiar.Variant)] = savedata.warHornValidator[tostring(familiar.Variant)] + 1
			end
		end
	end,

	ReviveFamiliar = function(familiar, noCallback)
		local data = mod:GetEntityData(familiar)
		familiar = familiar:ToFamiliar()
		data.isWarHornSoulTarget = false

		if data.warHornParams then
			familiar.Color = data.warHornParams.Color
			familiar.EntityCollisionClass = data.warHornParams.CollisionClass

			if data.warHornParams.Follower then
				familiar:AddToFollowers()
			end
		end

		data.warHornParams = nil

		local savedata = mod.GetPersistentPlayerData(familiar.Player)
		mod.InitTableFields(savedata, "warHornValidator", tostring(familiar.Variant), 0)
		savedata.warHornValidator[tostring(familiar.Variant)] = math.max(0, savedata.warHornValidator[tostring(familiar.Variant)] - 1)

		data = mod:GetEntityData(familiar.Player)
		for i = 1, #data.warHornDeadFamiliars do
			if mod.AreEntitiesSame(data.warHornDeadFamiliars[i], familiar) then
				table.remove(data.warHornDeadFamiliars, i)
				break
			end
		end

		if not noCallback then
			Isaac.RunCallbackWithParam(mod.CALLBACK.WAR_HORN_REVIVE_FAMILIAR, familiar.Variant, familiar)
		end
	end,
}

function mod.IsBlueFamiliar(familiar)
	return (
		familiar.Variant == FamiliarVariant.BLUE_FLY 					-- Blue Fly, Locusts of the Apocalypse
		or familiar.Variant == FamiliarVariant.BLUE_SPIDER 				-- Blue Spider, Baby Blue Spider
		or familiar.Variant == FiendFolio.ITEM.FAMILIAR.ATTACK_SKUZZ 	-- Blue Skuzz, Fleas of the Modern Apocalypse
		or familiar.Variant == FiendFolio.ITEM.FAMILIAR.BLUE_BEETLE		-- Blue Beetles, Ladybirds
		or familiar.Variant == FiendFolio.ITEM.FAMILIAR.FAIRY_FLY_1		-- Fairy Flies
		or familiar.Variant == FiendFolio.ITEM.FAMILIAR.FAIRY_FLY_2
		or familiar.Variant == FiendFolio.ITEM.FAMILIAR.FAIRY_FLY_3
	)
end

function mod.IsNonCombatFamiliar(familiar)
	if familiar.Player:GetTrinketMultiplier(FiendFolio.ITEM.TRINKET.GOOGLY_EYES) > 0 then
		return mod.NonCombatFamiliars[familiar.Variant] and not mod.GooglyEyesWhitelist[familiar.Variant]
	else
		return mod.NonCombatFamiliars[familiar.Variant]
	end
end

function mod.IsWarHornIgnored(familiar)
	return (
		familiar.Variant == FiendFolio.ITEM.FAMILIAR.FIEND_ORBITING_FIREBALL
	)
end

function mod.DoesFamiliarGetWarHornBoost(familiar)
	return (
		not mod.IsBlueFamiliar(familiar)
		and not mod.IsNonCombatFamiliar(familiar)
		and not mod.IsWarHornIgnored(familiar)
	)
end

function mod.IsTemporaryFamiliar(familiar)
	return (
		mod.IsBlueFamiliar(familiar)
		or familiar.Variant == glueBaby
		or familiar.Variant == FiendFolio.ITEM.FAMILIAR.FRAGILE_BOBBY	-- Fragile Bobby + Egg Penny Baby
		or familiar.Variant == FiendFolio.ITEM.FAMILIAR.MORBID_CHUNK
		or familiar.Variant == FamiliarVariant.MINISAAC
		or familiar.Variant == FamiliarVariant.BONE_SPUR
		or familiar.Variant == FamiliarVariant.BONE_ORBITAL
		or familiar.Variant == FamiliarVariant.WISP
	)
end

function mod.DoesFamiliarBlockGlueBaby(familiar, player)
	return (
		mod.AreEntitiesSame(familiar.Player, player)
		and not mod:GetEntityData(familiar).warHornParams
		and not mod.IsTemporaryFamiliar(familiar)
		and not mod.IsNonCombatFamiliar(familiar)
		and not mod.IsWarHornIgnored(familiar)
	)
end

local function shouldAddGlueBaby(player)
	for _, familiar in pairs(Isaac.FindByType(3)) do
		if mod.DoesFamiliarBlockGlueBaby(familiar:ToFamiliar(), player) then
			return false
		end
	end

	return true
end

function mod.ValidateWarHornFamiliars(player) -- Call on POST_GAME_STARTED
	local savedata = mod.GetPersistentPlayerData(player)
	if not savedata.warHornValidator then return end

	for idString, num in pairs(savedata.warHornValidator) do
		local found = 0
		for _, familiar in pairs(Isaac.FindByType(3, tonumber(idString))) do
			if num <= found then break end

			familiar = familiar:ToFamiliar()
			if mod.AreEntitiesSame(familiar.Player, player) and not mod:GetEntityData(familiar).warHornParams then
				familiar.Visible = true
				mod.WarHorn.KillFamiliar(familiar, true)
				found = found + 1
			end
		end

		savedata.warHornValidator[idString] = found
	end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, item, rng, player, flags, slot)
	if flags & UseFlag.USE_CARBATTERY > 0 then return end
	local data = mod.GetPersistentPlayerData(player)
	mod:GetEntityData(player).warHornPenalty = nil

	if data.warHornActive then
		replaceWarHorn(player, slot)
		sfx:Play(mod.Sounds.WarHornOff)
	else
		if flags & UseFlag.USE_OWNED == 0 then
			data.warHornNaturalDecay = player.FrameCount + 900
		end

		data.warHornActive = true
		player:AddCacheFlags(CACHE_FLAGS, true)
		sfx:Play(mod.Sounds.WarHornOn)
		sfx:Play(SoundEffect.SOUND_BERSERK_START, 0.5, 0, false, 1.0)
	end

	return true
end, warHorn)

function mod.WarHornPeffectUpdate(player, data)
	if player:HasCollectible(warHorn2) then
		for i = 0, 3 do
			if player:GetActiveItem(i) == warHorn2 and player:GetActiveCharge(i) == 450 then
				player:RemoveCollectible(warHorn2, false, i)
				player:AddCollectible(warHorn, 0, false, i)
			end
		end
	end

	if data.warHornNaturalDecay then
		if data.warHornNaturalDecay <= player.FrameCount then
			data.warHornActive = false
			data.warHornNaturalDecay = nil
		end
	elseif data.warHornActive and not player:HasCollectible(warHorn) then
		data.warHornNaturalDecay = player.FrameCount + 900
	end
end

mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CallbackPriority.LATE, function(_, player, amount, flags, source, cooldown)
	if mod.GetPersistentPlayerData(player).warHornActive and not Isaac.RunCallback(mod.CALLBACK.PRE_AWARD_WAR_HORN_PENALTY, player, source, flags) then
		sfx:Play(mod.Sounds.FiendHurt, 0.8, 0, false, 1.5)
		replaceWarHorn(player:ToPlayer())
		mod:GetEntityData(player).warHornPenalty = true

		return {Damage = amount * 2}
	end
end, 1)

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, amount, flags, source, cooldown)
	if entity:ToNPC() then
		local familiar = queryFamiliarFromSpawnerStack(source)
		if familiar and mod.GetPersistentPlayerData(familiar.Player).warHornActive then
			local mult = familiar.Player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE) and JUDAS_DAMAGE_MULT or DAMAGE_MULT

			return {
				Damage = amount * mult,
			}
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player)
	if mod.GetPersistentPlayerData(player).warHornActive then
		player.MoveSpeed = player.MoveSpeed + 0.25
	end
end, CacheFlag.CACHE_SPEED)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player)
	local expected = shouldAddGlueBaby(player) and mod.GetPersistentPlayerData(player).warHornActive and 1 or 0
	player:CheckFamiliar(glueBaby, expected, player:GetCollectibleRNG(warHorn), Isaac.GetItemConfig():GetCollectible(warHorn))
end, CacheFlag.CACHE_FAMILIARS)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, familiar)
	local data = mod:GetEntityData(familiar)
	data.animDirection = "Down"
	data.animPrefix = "Float"
	familiar:AddToFollowers()
end, glueBaby)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, familiar)
	local data = mod:GetEntityData(familiar)
	local sprite = familiar:GetSprite()

	familiar.FireCooldown = familiar.FireCooldown - 1

	if mod.IsPlayerTryingToShoot(familiar.Player) then
		local firingVector, negateTearInheritance = mod.GetFamiliarShootingDirection(familiar)
		sprite.FlipX = firingVector.X < 0

		data.animDirection = mod.GetNearestDirectionStringFromAngle(firingVector:GetAngleDegrees(), "Side")

		if familiar.FireCooldown <= 0 then
			data.animPrefix = "FloatShoot"

			local tear = familiar:FireProjectile(firingVector)
			if negateTearInheritance then
				tear.Velocity = firingVector:Resized(tear.Velocity:Length())
			end

			mod.SetFamiliarFireCooldown(familiar, FIRE_COOLDOWN)
		end
	elseif familiar.FireCooldown < 0 then
		data.animDirection = "Down"
	end

	sprite:SetFrame(data.animPrefix .. data.animDirection, familiar.FrameCount % FLOAT_ANIM_DURATION)

	if data.animPrefix == "FloatShoot" and familiar.FireCooldown < FIRE_COOLDOWN - FIRE_ANIM_DURATION then
		data.animPrefix = "Float"
	end

	familiar:FollowParent()
end, glueBaby)

mod:AddCallback(ModCallbacks.MC_GET_FOLLOWER_PRIORITY, function()
	return FollowerPriority.SHOOTER
end, glueBaby)

mod:AddPriorityCallback(ModCallbacks.MC_FAMILIAR_UPDATE, CallbackPriority.LATE, function(_, familiar)
	if not mod.DoesFamiliarGetWarHornBoost(familiar) then return end
	local data = mod:GetEntityData(familiar)
	local playerData = mod.GetPersistentPlayerData(familiar.Player)

	if playerData.warHornActive and not data.FFBerserkWarHorned then
		mod.WarHorn.BerserkFamiliar(familiar)
	elseif data.FFBerserkWarHorned and not playerData.warHornActive then
		if mod:GetEntityData(familiar.Player).warHornPenalty then
			mod.WarHorn.KillFamiliar(familiar)
		else
			mod.WarHorn.UnberserkFamiliar(familiar)
		end
	end

	if data.FFBerserkWarHorned then
		mod:berserkOnUpdate(familiar, mod:GetEntityData(familiar), familiar:GetSprite())

		if data.FFBerserkDuration >= 0 then
			local colour = Color.Lerp(familiarBerserkBase, FiendFolio.StatusEffectColors.BerserkFlash, math.abs(math.sin(math.pi / 8 * game:GetFrameCount())))
			local realColour = Color(1, 1, 1, 1, colour.R / 2.5, colour.G / 2.5, colour.B / 2.5)
			familiar:SetColor(realColour, 2, 126, false, false)
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_FAMILIAR_RENDER, function(_, familiar)
	if mod:GetEntityData(familiar).FFBerserkWarHorned and mod.IsStandardRenderMode() then
		mod.statusIconsPlayer(_, familiar, Vector(0, 14) + game:GetRoom():GetRenderScrollOffset(), true) -- idfk man (cat: *I* know, man.)
	end
end)

mod:AddCallback(mod.CALLBACK.PRE_AWARD_WAR_HORN_PENALTY, function(_, player, source, flags) -- Holy shit this callback is maybe the worst thing I've ever written why did I do it like that
	if not (not source or ( -- Stolen from Retribution's Wax Wing penalty detection
		source.Type ~= 1 and
		source.Type ~= 6 and
		flags & (DamageFlag.DAMAGE_CURSED_DOOR | DamageFlag.DAMAGE_CHEST | DamageFlag.DAMAGE_IV_BAG | DamageFlag.DAMAGE_NO_PENALTIES) == 0 and
		not ( -- Sacrifice Room Spikes
			game:GetRoom():GetType() == RoomType.ROOM_SACRIFICE and
			source.Type == 0 and
			flags & DamageFlag.DAMAGE_SPIKES > 0
		) and
		not ( -- Blood Oath
			source.Type == 3 and
			source.Variant == FamiliarVariant.BLOOD_OATH
		)
	)) then
		return true
	end
end)

mod:AddCollectibleCallback(ModCallbacks.MC_POST_FAMILIAR_FIRE_PROJECTILE, CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE, function(_, tear)
	if not tear.SpawnerEntity or tear.SpawnerEntity.Type ~= 3 then return end
	local familiar = tear.SpawnerEntity:ToFamiliar()
	if mod:GetEntityData(familiar).FFBerserkWarHorned and not mod:GetEntityData(tear).checkedWarHornBurn and familiar.Player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE) then
		local rng = familiar.Player:GetCollectibleRNG(warHorn2)
		if rng:RandomFloat() < 0.2666 then -- Gotta force it in somewhere
			tear.TearFlags = tear.TearFlags | TearFlags.TEAR_BURN
			TearFlagsLib.TryChangeTearVariant(tear, TearVariant.FIRE_MIND)
		end

		mod:GetEntityData(tear).checkedWarHornBurn = true
	end
end)

mod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_UPDATE, function(_, familiar) -- Make dynamic callback
	if mod:GetEntityData(familiar).warHornParams then
		local data = mod:GetEntityData(familiar)
		familiar.Color = Color(1, 1, 1, 0.35)

		data.warHornTarget = data.warHornTarget or Isaac.GetRandomPosition()
		if data.warHornTarget:Distance(familiar.Position) < 10 or familiar.FrameCount % 90 == 0 then
			data.warHornTarget = Isaac.GetRandomPosition()
		end

		local heading = (data.warHornTarget - familiar.Position):Resized(2)
		familiar.Velocity = mod.XalumLerp(familiar.Velocity, heading, 0.1)
		return true
	end
end)

--[[mod:AddPriorityCallback(ModCallbacks.MC_GET_FOLLOWER_PRIORITY, CallbackPriority.IMPORTANT, function(_, familiar)
	if mod:GetEntityData(familiar).warHornGhost then
		return -9999
	end
end)]]

function mod.SpawnWarHornSoul(familiar)
	-- Shout out Mammonite Codex
	-- I was NOT looking forward to figuring these fuckers out on my own
	local vel = (familiar.Position - familiar.Player.Position):Rotated(math.random() < 0.5 and 90 or -90):Resized(20)
	local soul = Isaac.Spawn(1000, 179, 0, familiar.Player.Position, vel, nil):ToEffect()
	soul.Target = familiar
	mod:GetEntityData(soul).warHornTarget = familiar
	mod:GetEntityData(familiar).isWarHornSoulTarget = true
end

mod:AddCallback(ModCallbacks.MC_POST_ROOM_TRIGGER_CLEAR, function()
	mod.AnyPlayerDo(function(player)
		local data = mod:GetEntityData(player).warHornDeadFamiliars
		if data and #data > 0 then
			local rng = player:GetCollectibleRNG(warHorn)
			local familiar = data[rng:RandomInt(#data) + 1]:ToFamiliar()
			mod.SpawnWarHornSoul(familiar)
		end
	end)
end)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, soul)
	if mod:GetEntityData(soul).warHornTarget then
		soul.Velocity = soul.Velocity / 1.3
		
		if soul:GetSprite():IsPlaying("Collect") then
			mod.WarHorn.ReviveFamiliar(mod:GetEntityData(soul).warHornTarget)
			mod:GetEntityData(soul).warHornTarget = nil
			sfx:Play(SoundEffect.SOUND_SOUL_PICKUP)
		end
	end
end, EffectVariant.ENEMY_SOUL)

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, soul)
	if soul.Variant == EffectVariant.ENEMY_SOUL and mod:GetEntityData(soul).warHornTarget then
		mod.WarHorn.ReviveFamiliar(mod:GetEntityData(soul).warHornTarget)
		sfx:Play(SoundEffect.SOUND_SOUL_PICKUP)
	end
end, 1000)

mod:AddPriorityCallback(ModCallbacks.MC_POST_GAME_STARTED, CallbackPriority.LATE, function()
	mod.AnyPlayerDo(function(player)
		mod.ValidateWarHornFamiliars(player)
	end)
end)


local function tryAddFamiliarLaserBurn(_, laser)
	if not laser.SpawnerEntity or laser.SpawnerEntity.Type ~= 3 or TearFlagsLib.IsFamiliarPlayerMimic(laser.SpawnerEntity) then return end
	local familiar = laser.SpawnerEntity:ToFamiliar()

	if mod:GetEntityData(familiar).FFBerserkWarHorned and not mod:GetEntityData(laser).checkedWarHornBurn and familiar.Player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE) then
		local rng = familiar.Player:GetCollectibleRNG(warHorn2)
		if rng:RandomFloat() < 0.2666 then -- Gotta force it in somewhere
			laser.TearFlags = laser.TearFlags | TearFlags.TEAR_BURN
			laser.Color = Color.LaserFireMind
		end

		mod:GetEntityData(laser).checkedWarHornBurn = true
	end
end

mod:AddCollectibleCallback(ModCallbacks.MC_POST_FAMILIAR_FIRE_TECH_LASER, CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE, tryAddFamiliarLaserBurn)
mod:AddCollectibleCallback(ModCallbacks.MC_POST_FAMILIAR_FIRE_BRIMSTONE, CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE, tryAddFamiliarLaserBurn)
mod:AddCollectibleCallback(ModCallbacks.MC_PRE_LASER_COLLISION, CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE, tryAddFamiliarLaserBurn)

mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE, function(_, entity, player, weaponFlag)
	if entity.SpawnerType == 3 and entity.SpawnerEntity then
		local familiar = entity.SpawnerEntity:ToFamiliar()
		if mod:GetEntityData(familiar).FFBerserkWarHorned and not mod:GetEntityData(entity).checkedWarHornBurn and familiar.Player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE) then
			local rng = familiar.Player:GetCollectibleRNG(warHorn2)
			if rng:RandomFloat() < 0.2666 then -- Gotta force it in somewhere
				if entity.TearFlags and entity.Type ~= EntityType.ENTITY_LASER then
					entity.TearFlags = entity.TearFlags | TearFlags.TEAR_BURN
				else
					TearFlagsLib.AddCustomVanillaTearFlags(entity, TearFlags.TEAR_BURN)
				end

				if TearFlagsLib.IsWeaponTearVariant(weaponFlag) then
					TearFlagsLib.TryChangeTearVariant(entity, TearVariant.FIRE_MIND)
				else
					entity.Color = Color.LaserFireMind
				end	
			end

			mod:GetEntityData(entity).checkedWarHornBurn = true
		end
	end
end)

local function shouldFullKniveForceRevive(familiar)
	local data = mod:GetEntityData(familiar)
	local room = game:GetRoom()
	local level = game:GetLevel()

	return (
		level:GetStage() == LevelStage.STAGE3_2
		and level:GetStageType() >= StageType.STAGETYPE_REPENTANCE
		and room:GetType() == RoomType.ROOM_BOSS
		and room:IsClear()
		and not data.isWarHornSoulTarget
	)
end

mod:AddPriorityCallback(ModCallbacks.MC_PRE_FAMILIAR_UPDATE, CallbackPriority.IMPORTANT, function(_, familiar)
	if mod:GetEntityData(familiar).warHornParams and shouldFullKniveForceRevive(familiar) then
		mod.SpawnWarHornSoul(familiar)
	end
end, FamiliarVariant.KNIFE_FULL)

for _, i in pairs({warHorn, warHorn2}) do
	mod:AddEntityCallback(ModCallbacks.MC_POST_NEW_ROOM, EntityType.ENTITY_FAMILIAR, FamiliarVariant.WISP, i, function()
		for _, entity in pairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.WISP, i)) do
			entity:Remove()
		end
	end)
end