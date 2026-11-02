local mod = FiendFolio
local sfx = SFXManager()
local game = Game()
local fabergeBombs = FiendFolio.ITEM.COLLECTIBLE.FABERGE_BOMBS
local flag = TearFlagsLib.RegisterTearFlag("FABERGE_BOMB")
mod.CanFaberge = {
	[mod.BombFlagSource.BOMB] = true,
	[mod.BombFlagSource.ROCKET] = true,
	[mod.BombFlagSource.BOBS_ROTTEN_HEAD] = true,
	[mod.BombFlagSource.KAMIKAZE] = true,
}
mod.FabergeVariantBlacklist = {
	[BombVariant.BOMB_TROLL] = true,
	[BombVariant.BOMB_SUPERTROLL] = true,
	[BombVariant.BOMB_GOLDENTROLL] = true,
	[BombVariant.BOMB_THROWABLE] = true,
	[FiendFolio.BOMB.TROLL_COPPER] = true,
}

local goldenDecrementation = 1
local forcePlaceBombPlayer = nil

local function getDefaultBombPlaceDelay(player)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_FAST_BOMBS) then
		return 1
	else
		return 30
	end
end

local function spawnFabergeBomb(player)
	player:AddCoins(-3)
	sfx:Play(SoundEffect.SOUND_CASH_REGISTER)

	forcePlaceBombPlayer = player
end

function mod.CanPlayerPlaceFabergeBomb(player)
	return (
		player:HasCollectible(fabergeBombs)
		and player:GetNumBombs() == 0
		and player:GetPoopMana() == 0
		and player:GetNumCoins() >= 3
		and player:GetBombPlaceDelay() <= 0
		and not player:HasGoldenBomb()
		and not player:HasEntityFlags(EntityFlag.FLAG_FEAR)
		and mod:GetEntityData(player).CustomPoopAPI_LastUsedPoopSpell ~= player.FrameCount
	)
end

-- Late priority so that other mods which want to cancel all bomb placements will cancel this too
mod:AddPriorityCollectibleCallback(ModCallbacks.MC_PRE_PLAYER_USE_BOMB, CallbackPriority.LATE, fabergeBombs, function(_, player)
	if mod.CanPlayerPlaceFabergeBomb(player) then
		spawnFabergeBomb(player)

		if player:HasCollectible(CollectibleType.COLLECTIBLE_BLOOD_BOMBS) then
			return false
		end
	end 
end)

mod:AddPriorityCollectibleCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CallbackPriority.EARLY, fabergeBombs, function(_, entity, amount, flags, source, cooldown)
	if mod:GetEntityData(entity).catchFabergeBloodBombDamage and source.Type == 0 and not source.Entity then
		mod:GetEntityData(entity).catchFabergeBloodBombDamage = false
		return false
	end
end, 1)

mod:AddCollectibleCallback(ModCallbacks.MC_PRE_PLAYER_UPDATE, fabergeBombs, function(_, player)
	if Input.IsActionTriggered(ButtonAction.ACTION_BOMB, Isaac.GetPlayer().ControllerIndex) and mod.CanPlayerPlaceFabergeBomb(player) and player:HasCollectible(CollectibleType.COLLECTIBLE_BLOOD_BOMBS) then
		mod:GetEntityData(player).catchFabergeBloodBombDamage = true
	end
end)

function mod:fabergeBombsFlag(entity, player, sourceFlag)
	if mod.CanFaberge[sourceFlag] and player:HasCollectible(fabergeBombs) then
		if entity.Type == EntityType.ENTITY_BOMB and mod.FabergeVariantBlacklist[entity.Variant] then 
			return
		end
		TearFlagsLib.AddTearFlags(entity, flag)
    end
end
mod:AddCollectibleCallback(FiendFolio.CALLBACK.FF_POLL_BOMBFLAGS, fabergeBombs, mod.fabergeBombsFlag)

function mod:fabergeBombsVariant(bomb, player, sourceFlag)
	if mod.CanFaberge[sourceFlag] and player:HasCollectible(fabergeBombs) then
		local var = bomb.Variant
		if mod:isReplaceableBombVariant(var) then
			if mod:isCopperVariant(var) then
				bomb.Variant = mod.BOMB.FABERGE_COPPER
				bomb.Flags = bomb.Flags
			else
				bomb.Variant = mod.BOMB.FABERGE
				bomb.Flags = bomb.Flags
			end
		end
	end
end
mod:AddCollectibleCallback(FiendFolio.CALLBACK.FF_SET_BOMB_VARIANT, fabergeBombs, mod.fabergeBombsVariant)

local function shouldPlaceFabergeBomb(player)
	return (
		mod.CanPlayerPlaceFabergeBomb(player) and
		Input.IsActionTriggered(ButtonAction.ACTION_BOMB, player.ControllerIndex)
	)
end

local function getFractionalCoinSpawnMultiplier(player) -- Maybe other things can increase this, I love shitty little random synergies that don't matter, I'm open to ideas
	return math.min(10,
		(1 + 0.3 * math.max(0, player:GetCollectibleNum(fabergeBombs) - 1)) *
		(1.09 ^ player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.PAK_CHOI)) -- :)
	)
end

mod:AddCollectibleCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, fabergeBombs, function(_, player)
	if shouldPlaceFabergeBomb(player) then
		Isaac.RunCallbackWithParam(ModCallbacks.MC_PRE_PLAYER_USE_BOMB, player.Variant, player)
	end

	mod:GetEntityData(player).catchFabergeBloodBombDamage = false
end)

mod:AddCallback(FiendFolio.CALLBACK.FF_POST_BOMBFLAG_EFFECTS, function(_, pos, radius, tearflags, src, radiusMult, player, sourceFlag, tearFlagParams)
	local bombData = mod:GetEntityData(src)
	local frame = game:GetFrameCount()
	if bombData.lastFrameFaberged == frame then
		return
	end

	local rng = player:GetCollectibleRNG(fabergeBombs)
	local minSpawns = bombData.FFIsScatter and 1 or 10
	local realDecrementation = player:HasGoldenBomb() and goldenDecrementation or 1 -- Just in case you somehow lose Golden Bombs during the floor

	minSpawns = math.max(1, math.ceil(minSpawns * realDecrementation))

	for i = 1, rng:RandomInt(minSpawns, minSpawns * 2) * getFractionalCoinSpawnMultiplier(player) do
		local penny = Isaac.Spawn(5, PickupVariant.PICKUP_COIN, mod.PICKUP.COIN.LIL_PENNY, src.Position, rng:RandomVector() * (13 + rng:RandomFloat() * 5), player)
		penny:GetSprite():Play("AppearFast")
		mod:GetEntityData(penny).dangerousMode = player
	end

	if player:HasGoldenBomb() and not bombData.FFIsScatter then
		goldenDecrementation = goldenDecrementation * 0.7
	end

	bombData.lastFrameFaberged = frame
end, flag)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
	if pickup.SubType == mod.PICKUP.COIN.LIL_PENNY then
		local data = mod:GetEntityData(pickup)

		if data.dangerousMode then
			for _, enemy in pairs(Isaac.FindInRadius(pickup.Position, pickup.Size, EntityPartition.ENEMY)) do
				if enemy:ToNPC() and enemy.EntityCollisionClass >= EntityCollisionClass.ENTCOLL_PLAYEROBJECTS then
					if not data.dangerousButDontSpawnExtra then
						mod:GetEntityData(enemy).dropFractionalsIfMortal = true
					end
					enemy:TakeDamage(data.dangerousModeDamage or data.dangerousMode.Damage, 0, EntityRef(data.dangerousMode), 0)
					local rng = pickup:GetDropRNG()
					sfx:Play(mod.Sounds.D2Land, 0.5, 0, false, rng:RandomInt(90, 120)/100)
					data.dangerousMode = nil
					pickup.Velocity = -pickup.Velocity
					break
				end
			end
		end

		if pickup:GetSprite():IsEventTriggered("DropSound") and data.dangerousMode then
			data.dangerousMode = nil
		end
	end
end, PickupVariant.PICKUP_COIN)

function mod:dropFractionalsIfMortal(npc, data)
	if data.dropFractionalsIfMortal then
		data.dropFractionalsIfMortal = false

		if npc:HasMortalDamage() then
			local rng = npc:GetDropRNG()
			for i = 1, rng:RandomInt(2, 3) do
				Isaac.Spawn(5, PickupVariant.PICKUP_COIN, mod.PICKUP.COIN.LIL_PENNY, npc.Position, rng:RandomVector() * rng:RandomFloat() * 5, npc)
			end
		end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
	goldenDecrementation = 1
end)

mod:AddCollectibleCallback("FF_PLAYER_INPUT_ACTION", fabergeBombs, function(_, player, data, hook, button)
	if forcePlaceBombPlayer and button == ButtonAction.ACTION_BOMB and GetPtrHash(player) == GetPtrHash(forcePlaceBombPlayer) then
		forcePlaceBombPlayer = nil

		if player:GetPlayerType() ~= PlayerType.PLAYER_BLUEBABY_B then
			player:AddBombs(1)
			return true
		else
			local poopData = CustomPoopAPI.GetPersistentPlayerData(player)
			if poopData and poopData.Poops then
				mod:GetEntityData(player).CustomPoopAPI_LastUsedPoopSpell = player.FrameCount
				CustomPoopAPI:RunPoopSpellCallback(poopData.Poops[1], {poopData.Poops[1], player})
				table.remove(poopData.Poops, 1)
			end

			return false
		end
	end
end, InputHook.IS_ACTION_TRIGGERED)