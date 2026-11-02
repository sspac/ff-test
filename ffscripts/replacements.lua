local mod = FiendFolio

local game = Game()
local grng = RNG()
local sfx = SFXManager()

local preFamiliarSpawnFuncs = {
	[FamiliarVariant.DIP] = function(et, ev, es, pos, vel, sp, seed)
		return CustomPoopAPI:ffDipsPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
}

local preBombSpawnFuncs = {
	[BombVariant.BOMB_TROLL] = function(et, ev, es, pos, vel, sp, seed)
		return mod:dudsFlowerPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
}

local preCollectibleSpawnFuncs = {
	[mod.ITEM.COLLECTIBLE.GAPER_IN_A_JAR] = function(et, ev, es, pos, vel, sp, seed)
		mod:GaperJarPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[CollectibleType.COLLECTIBLE_CUBE_OF_MEAT] = function(et, ev, es, pos, vel, sp, seed)
		return mod:cornKernelPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[CollectibleType.COLLECTIBLE_BALL_OF_BANDAGES] = function(et, ev, es, pos, vel, sp, seed)
		return mod:cornKernelPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[FiendFolio.ITEM.COLLECTIBLE.CORN_KERNEL] = function(et, ev, es, pos, vel, sp, seed)
		return mod:cornKernelPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[CollectibleType.COLLECTIBLE_SMALL_ROCK] = function(et, ev, es, pos, vel, sp, seed)
		return mod:smallRockPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
}

local preTrinketSpawnFuncs = {
	[0] = function(et, ev, es, pos, vel, sp, seed)
		mod:detectTrinketSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[FiendFolio.ITEM.ROCK.UNOBTAINIUM] = function(et, ev, es, pos, vel, sp, seed)
		return mod:unobtainiumPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[FiendFolio.ITEM.ROCK.DADS_LEGENDARY_GOLDEN_ROCK] = function(et, ev, es, pos, vel, sp, seed)
		return mod:dadsLegendaryGoldenRockPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
}

local prePickupSpawnFuncs = {
	[0] = function(et, ev, es, pos, vel, sp, seed)
		return mod:sackFossilPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[PickupVariant.PICKUP_COIN] = function(et, ev, es, pos, vel, sp, seed)
		return mod:coinPreSpawn(et, ev, es, pos, vel, sp, seed) or
		       mod:sackFossilPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[PickupVariant.PICKUP_HEART] = function(et, ev, es, pos, vel, sp, seed)
		return mod:imageHeartPreSpawn(et, ev, es, pos, vel, sp, seed) or
		       mod:heartPreSpawn(et, ev, es, pos, vel, sp, seed) or
		       mod:sackFossilPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[PickupVariant.PICKUP_KEY] = function(et, ev, es, pos, vel, sp, seed)
		return mod:wackeyPreSpawn(et, ev, es, pos, vel, sp, seed) or
		       mod:sackFossilPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[PickupVariant.PICKUP_BOMB] = function(et, ev, es, pos, vel, sp, seed)
		return mod:copperBombPreSpawn(et, ev, es, pos, vel, sp, seed) or
		       mod:sackFossilPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[PickupVariant.PICKUP_CHEST] = function(et, ev, es, pos, vel, sp, seed)
		return mod:chestPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[PickupVariant.PICKUP_LOCKEDCHEST] = function(et, ev, es, pos, vel, sp, seed)
		return mod:chestPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[PickupVariant.PICKUP_GRAB_BAG] = function(et, ev, es, pos, vel, sp, seed)
		return mod:grabBagPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[PickupVariant.PICKUP_LIL_BATTERY] = function(et, ev, es, pos, vel, sp, seed)
		return mod:batteryPreSpawn(et, ev, es, pos, vel, sp, seed) or
		       mod:sackFossilPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[PickupVariant.PICKUP_TAROTCARD] = function(et, ev, es, pos, vel, sp, seed)
		return mod:CheckBoosterPackSpawn(et, ev, es, pos, vel, sp, seed) or
		       mod:storageBatteryPreSpawn(et, ev, es, pos, vel, sp, seed) or
		       mod:sackFossilPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[PickupVariant.PICKUP_PILL] = function(et, ev, es, pos, vel, sp, seed)
		return mod:handleLockedPills(et, ev, es, pos, vel, sp, seed) or
		       mod:sackFossilPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[PickupVariant.PICKUP_SHOPITEM] = function(et, ev, es, pos, vel, sp, seed)
		mod:brokenRecordPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[PickupVariant.PICKUP_COLLECTIBLE] = function(et, ev, es, pos, vel, sp, seed)
		mod:brokenRecordPreSpawn(et, ev, es, pos, vel, sp, seed)

		local func = preCollectibleSpawnFuncs[es]
		if func then return func(et, ev, es, pos, vel, sp, seed) end
	end,
	[PickupVariant.PICKUP_TRINKET] = function(et, ev, es, pos, vel, sp, seed)
		local func = preTrinketSpawnFuncs[mod:GetRealTrinketId(es)]
		if func then return func(et, ev, es, pos, vel, sp, seed) end
	end,
	[PickupVariant.PICKUP_TROPHY] = function(et, ev, es, pos, vel, sp, seed)
		return mod:craigsPhonePreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[mod.PICKUP.VARIANT.RANDOM_OBJECT] = function(et, ev, es, pos, vel, sp, seed)
		return mod:randomObjectPreSpawn(et, ev, es, pos, vel, sp, seed) or
		       mod:handleObjectSpawner(et, ev, es, pos, vel, sp, seed)
	end,
	[FiendFolio.PICKUP.VARIANT.HALF_BLACK_HEART] = function(et, ev, es, pos, vel, sp, seed)
		return mod:ultraHardPreSpawn(et, ev, es, pos, vel, sp, seed) or
		       mod:ffHeartPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[FiendFolio.PICKUP.VARIANT.BLENDED_BLACK_HEART] = function(et, ev, es, pos, vel, sp, seed)
		return mod:ultraHardPreSpawn(et, ev, es, pos, vel, sp, seed) or
		       mod:ffHeartPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[FiendFolio.PICKUP.VARIANT.IMMORAL_HEART] = function(et, ev, es, pos, vel, sp, seed)
		return mod:ultraHardPreSpawn(et, ev, es, pos, vel, sp, seed) or
		       mod:ffHeartPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[FiendFolio.PICKUP.VARIANT.HALF_IMMORAL_HEART] = function(et, ev, es, pos, vel, sp, seed)
		return mod:ultraHardPreSpawn(et, ev, es, pos, vel, sp, seed) or
		       mod:ffHeartPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[FiendFolio.PICKUP.VARIANT.BLENDED_IMMORAL_HEART] =	function(et, ev, es, pos, vel, sp, seed)
		return mod:ultraHardPreSpawn(et, ev, es, pos, vel, sp, seed) or
		       mod:ffHeartPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[FiendFolio.PICKUP.VARIANT.MORBID_HEART] = function(et, ev, es, pos, vel, sp, seed)
		return mod:ultraHardPreSpawn(et, ev, es, pos, vel, sp, seed) or
		       mod:ffHeartPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[FiendFolio.PICKUP.VARIANT.TWOTHIRDS_MORBID_HEART] = function(et, ev, es, pos, vel, sp, seed)
		return mod:ultraHardPreSpawn(et, ev, es, pos, vel, sp, seed) or
		       mod:ffHeartPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[FiendFolio.PICKUP.VARIANT.THIRD_MORBID_HEART] = function(et, ev, es, pos, vel, sp, seed)
		return mod:ultraHardPreSpawn(et, ev, es, pos, vel, sp, seed) or
		       mod:ffHeartPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[FiendFolio.PICKUP.VARIANT.SHOP_CHEST] = function(et, ev, es, pos, vel, sp, seed)
		return mod:gildedKeyPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[FiendFolio.PICKUP.VARIANT.DIRE_CHEST] = function(et, ev, es, pos, vel, sp, seed)
		return mod:gildedKeyPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[FiendFolio.PICKUP.VARIANT.GLASS_CHEST] = function(et, ev, es, pos, vel, sp, seed)
		return mod:gildedKeyPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[FiendFolio.PICKUP.VARIANT.ENGINE_CHEST] = function(et, ev, es, pos, vel, sp, seed)
		return mod:gildedKeyPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[FiendFolio.PICKUP.VARIANT.STEVEN_HEART] = function(et, ev, es, pos, vel, sp, seed)
		return mod:stevenHeartPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[303] = function(et, ev, es, pos, vel, sp, seed)
		return mod:horsePillPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[304] = function(et, ev, es, pos, vel, sp, seed)
		return mod:playingCardPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[305] = function(et, ev, es, pos, vel, sp, seed)
		return mod:pillPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[306] = function(et, ev, es, pos, vel, sp, seed)
		return mod:aberrantCardPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[307] = function(et, ev, es, pos, vel, sp, seed)
		return mod:minorArcanaPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[308] = function(et, ev, es, pos, vel, sp, seed)
		return mod:tarotPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[309] = function(et, ev, es, pos, vel, sp, seed)
		return mod:reverseTarotPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[310] = function(et, ev, es, pos, vel, sp, seed)
		return mod:soulstonePreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
}

local preSlotSpawnFuncs = {
	[SlotVariant.SLOT_MACHINE] = function(et, ev, es, pos, vel, sp, seed)
		return mod:goldenSlotSpawning(et, ev, es, pos, vel, sp, seed)
	end,
	[SlotVariant.BEGGAR] = function(et, ev, es, pos, vel, sp, seed)
		return mod:replaceBeggars(et, ev, es, pos, vel, sp, seed)
	end,
	[SlotVariant.DEVIL_BEGGAR] = function(et, ev, es, pos, vel, sp, seed)
		return mod:replaceBeggars(et, ev, es, pos, vel, sp, seed)
	end,
	[SlotVariant.KEY_MASTER] = function(et, ev, es, pos, vel, sp, seed)
		return mod:replaceBeggars(et, ev, es, pos, vel, sp, seed)
	end,
	[SlotVariant.BOMB_BUM] = function(et, ev, es, pos, vel, sp, seed)
		return mod:replaceBeggars(et, ev, es, pos, vel, sp, seed)
	end,
	[SlotVariant.BATTERY_BUM] = function(et, ev, es, pos, vel, sp, seed)
		return mod:replaceBeggars(et, ev, es, pos, vel, sp, seed)
	end,
	[SlotVariant.ROTTEN_BEGGAR] = function(et, ev, es, pos, vel, sp, seed)
		return mod:replaceBeggars(et, ev, es, pos, vel, sp, seed)
	end,
	[mod.FF.ZodiacBeggar.Var] = function(et, ev, es, pos, vel, sp, seed)
		return mod:checkLockedZodiacBeggar(et, ev, es, pos, vel, sp, seed)
	end,
	[mod.FF.EvilBeggar.Var] = function(et, ev, es, pos, vel, sp, seed)
		return mod:checkLockedEvilBeggar(et, ev, es, pos, vel, sp, seed)
	end,
	[mod.FF.GeodeGolem.Var] = function(et, ev, es, pos, vel, sp, seed)
		return mod:geodeGolemPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[mod.FF.Babi.Var] = function(et, ev, es, pos, vel, sp, seed)
		return mod:babiPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[mod.FF.Sweetpuss.Var] = function(et, ev, es, pos, vel, sp, seed)
		return mod:sweetpussPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[mod.FF.VendingMachine.Var] = function(et, ev, es, pos, vel, sp, seed)
		return mod:vendingMachinePreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[mod.FF.VendingMachineFF.Var] = function(et, ev, es, pos, vel, sp, seed)
		return mod:vendingMachinePreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[mod.FF.MilkMachine.Var] = function(et, ev, es, pos, vel, sp, seed)
		return mod:milkMachinePreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[160] = function(et, ev, es, pos, vel, sp, seed)
		return mod:pokerTablePreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[1022] = function(et, ev, es, pos, vel, sp, seed)
		return mod:sourpussPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[1040] = function(et, ev, es, pos, vel, sp, seed)
		return mod:checkLockedGoldenSlot(et, ev, es, pos, vel, sp, seed)
	end,
}

local preEffectSpawnFuncs = {
	[EffectVariant.BLOOD_SPLAT] = function(et, ev, es, pos, vel, sp, seed)
		return mod:HolyDrumstickBloodSplat(et, ev, es, pos, vel, sp, seed)
	end,
	[EffectVariant.POOF01] = function(et, ev, es, pos, vel, sp, seed)
		return mod:handleDeadMinionPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[EffectVariant.CREEP_RED] = function(et, ev, es, pos, vel, sp, seed)
		return mod:goldenPlumCreepPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[EffectVariant.PLAYER_CREEP_RED] = function(et, ev, es, pos, vel, sp, seed)
		return mod:goldenPlumFluteCreepPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[EffectVariant.DICE_FLOOR] = function(et, ev, es, pos, vel, sp, seed)
		return mod:diceFloorPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
}

local boomFlySpawnFuncs = {
	[0] = function(et, ev, es, pos, vel, sp, seed)
		return mod:alienLokiPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[1] = function(et, ev, es, pos, vel, sp, seed)
		return mod:alienLokiiPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
}

local preEntSpawnFuncs = {
	[EntityType.ENTITY_FAMILIAR] = function(et, ev, es, pos, vel, sp, seed)
		local func = preFamiliarSpawnFuncs[ev]
		if func then return func(et, ev, es, pos, vel, sp, seed) end
	end,
	[EntityType.ENTITY_BOMB] = function(et, ev, es, pos, vel, sp, seed)
		local func = preBombSpawnFuncs[ev]
		if func then return func(et, ev, es, pos, vel, sp, seed) end
	end,
	[EntityType.ENTITY_PICKUP] = function(et, ev, es, pos, vel, sp, seed)
		local func = prePickupSpawnFuncs[ev]
		if func then
			return func(et, ev, es, pos, vel, sp, seed) or
			       mod:pickupsFromD12machine(et, ev, es, pos, vel, sp, seed)
		end

		return mod:pickupsFromD12machine(et, ev, es, pos, vel, sp, seed)
	end,
	[EntityType.ENTITY_EFFECT] = function(et, ev, es, pos, vel, sp, seed)
		local func = preEffectSpawnFuncs[ev]
		if func then return func(et, ev, es, pos, vel, sp, seed) end
	end,
	[EntityType.ENTITY_SLOT] = function(et, ev, es, pos, vel, sp, seed)
		local func = preSlotSpawnFuncs[ev]
		if func then return func(et, ev, es, pos, vel, sp, seed) end
	end,
	[EntityType.ENTITY_PROJECTILE] = function(et, ev, es, pos, vel, sp, seed)
		return mod:goldenPlumProjPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[EntityType.ENTITY_GAPER] = function(et, ev, es, pos, vel, sp, seed)
		return mod:fiendMomGaperPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[EntityType.ENTITY_GUSHER] = function(et, ev, es, pos, vel, sp, seed)
		return mod:fiendMomPacerPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[EntityType.ENTITY_HORF] = function(et, ev, es, pos, vel, sp, seed)
		return mod:fiendMomHorfPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[EntityType.ENTITY_POOTER] = function(et, ev, es, pos, vel, sp, seed)
		return mod:fiendMomPooterPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[EntityType.ENTITY_CLOTTY] = function(et, ev, es, pos, vel, sp, seed)
		return mod:fiendMomClottyPreSpawn(et, ev, es, pos, vel, sp, seed) or
		       mod:guwahGreaturesDrumstickPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[EntityType.ENTITY_MULLIGAN] = function(et, ev, es, pos, vel, sp, seed)
		return mod:fiendMomMulliganPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[EntityType.ENTITY_ATTACKFLY] = function(et, ev, es, pos, vel, sp, seed)
		return mod:fiendMomAttackFlyPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[EntityType.ENTITY_MAGGOT] = function(et, ev, es, pos, vel, sp, seed)
		return mod:fiendMomMaggotPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[EntityType.ENTITY_CHARGER] = function(et, ev, es, pos, vel, sp, seed)
		return 	mod:drownedSpittyReplacementCheck(et, ev, es, pos, vel, sp, seed) or
				mod:fiendMomChargerPreSpawn(et, ev, es, pos, vel, sp, seed) or
		       	mod:beehiveFistulaPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[EntityType.ENTITY_GLOBIN] = function(et, ev, es, pos, vel, sp, seed)
		return mod:fiendMomGlobinPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[EntityType.ENTITY_BOOMFLY] = function(et, ev, es, pos, vel, sp, seed)
		local func = boomFlySpawnFuncs[ev]
		if func then return func(et, ev, es, pos, vel, sp, seed) end
	end,
	[EntityType.ENTITY_MAW] = function(et, ev, es, pos, vel, sp, seed)
		return mod:fiendMomMawPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[EntityType.ENTITY_BOIL] = function(et, ev, es, pos, vel, sp, seed)
		return mod:babyWidowPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[EntityType.ENTITY_GEMINI] = function(et, ev, es, pos, vel, sp, seed)
		return mod:geminiPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[EntityType.ENTITY_SPIDER] = function(et, ev, es, pos, vel, sp, seed)
		return mod:spiderPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[EntityType.ENTITY_BONY] = function(et, ev, es, pos, vel, sp, seed)
		return mod:redForsakenPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[EntityType.ENTITY_WALL_CREEP] = function(et, ev, es, pos, vel, sp, seed)
		return mod:guwahGreaturesArcaneCreepPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[EntityType.ENTITY_LEPER] = function(et, ev, es, pos, vel, sp, seed)
		return mod:LeperFleshPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[EntityType.ENTITY_SMALL_LEECH] = function(et, ev, es, pos, vel, sp, seed)
		return mod:cushionPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[mod.FFID.Connor] = function(et, ev, es, pos, vel, sp, seed)
		return mod:handleHoneyFoxCleaver(et, ev, es, pos, vel, sp, seed)
	end,
	[551] = function(et, ev, es, pos, vel, sp, seed)
		return mod:guwahGreaturesPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[1500] = function(et, ev, es, pos, vel, sp, seed)
		return mod:ghostLarryJrPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[mod.FFID.Boss] = function(et, ev, es, pos, vel, sp, seed)
		return mod:foozBossRushPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[EntityType.ENTITY_EMBRYO] = function(et, ev, es, pos, vel, sp, seed)
		return mod:holyMulliganEmbryoPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[EntityType.ENTITY_PIN] = function(et, ev, es, pos, vel, sp, seed)
		return mod:PinSegmentPreSpawn(et, ev, es, pos, vel, sp, seed)
	end,
	[mod.FFID.Tech] = function(et, ev, es, pos, vel, sp, seed)
		return mod:FFChampionVanillaBossSpawner(et, ev, es, pos, vel, sp, seed)
	end,
}

mod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, function(_, et, ev, es, pos, vel, sp, seed)
	local func = preEntSpawnFuncs[et]
	if func then
		return func(et, ev, es, pos, vel, sp, seed) or
		       mod:portalPreSpawn(et, ev, es, pos, vel, sp, seed)
	end

	return mod:portalPreSpawn(et, ev, es, pos, vel, sp, seed)
end)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_SELECTION, function(_, pickup, var, sub, reqVar, reqSub, rng)
	local result
	result = mod:heartPostSelection(pickup, var, sub, reqVar, reqSub, rng)
	result = result or mod:keyPostSelection(pickup, var, sub, reqVar, reqSub, rng)
	result = result or mod:coinPostSelection(pickup, var, sub, reqVar, reqSub, rng)
	result = result or mod:trinketPostSelection(pickup, var, sub, reqVar, reqSub, rng)
	if result then
		return result
	end
end)

local FFHearts = {
	[FiendFolio.PICKUP.VARIANT.HALF_BLACK_HEART] = true,
	[FiendFolio.PICKUP.VARIANT.BLENDED_BLACK_HEART] = true,
	[FiendFolio.PICKUP.VARIANT.IMMORAL_HEART] = true,
	[FiendFolio.PICKUP.VARIANT.HALF_IMMORAL_HEART] = true,
	[FiendFolio.PICKUP.VARIANT.BLENDED_IMMORAL_HEART] = true,
	[FiendFolio.PICKUP.VARIANT.MORBID_HEART] = true,
	[FiendFolio.PICKUP.VARIANT.TWOTHIRDS_MORBID_HEART] = true,
	[FiendFolio.PICKUP.VARIANT.THIRD_MORBID_HEART] = true,
	[FiendFolio.PICKUP.VARIANT.FOOLS_GOLD_HEART] = true,
	[FiendFolio.PICKUP.VARIANT.STEVEN_HEART] = true,
}

local SoulHeartOnly = {
	[PlayerType.PLAYER_BLUEBABY] = true,
	[PlayerType.PLAYER_THESOUL] = true,
	[PlayerType.PLAYER_JUDAS_B] = true,
	[PlayerType.PLAYER_BLUEBABY_B] = true,
	[PlayerType.PLAYER_THEFORGOTTEN_B] = true,
	[PlayerType.PLAYER_BETHANY_B] = true,
	[PlayerType.PLAYER_THESOUL_B] = true,
	[FiendFolio.PLAYER.FIEND] = true,
	[FiendFolio.PLAYER.BIEND] = true,
}

local SoulHeartOnlyStrict = {
	[PlayerType.PLAYER_BLUEBABY] = true,
	[PlayerType.PLAYER_JUDAS_B] = true,
	[PlayerType.PLAYER_BLUEBABY_B] = true,
	[PlayerType.PLAYER_THEFORGOTTEN_B] = true,
	[PlayerType.PLAYER_THESOUL_B] = true,
	[FiendFolio.PLAYER.FIEND] = true,
	[FiendFolio.PLAYER.BIEND] = true,
	[FiendFolio.PLAYER.BOLEM] = true,
}

-- Pickup replacements, penny replacements, sack replacements, battery replacements, etc
function mod:ultraHardPreSpawn(id, var, subtype, pos, vel, spawner, seed)
	if game.Challenge == Challenge.CHALLENGE_ULTRA_HARD then
		return {1000,0,999,seed}
	end
end

function mod:randomObjectPreSpawn(id, var, subtype, pos, vel, spawner, seed)
	grng:SetSeed(math.max(1, seed), 0)
	if subtype == 1 then
		local disc = mod.GetRandomDisc(grng) or mod.ITEM.CARD.TREASURE_DISC
		return {5, 300, disc, seed}
	elseif subtype == 2 then
		local cardid = FiendFolio.EnergyCards[grng:RandomInt(#FiendFolio.EnergyCards) + 1]
		return {5, 300, cardid, seed}
	else
		return {5, 300, FiendFolio.GetRandomObject(grng), seed}
	end
end

function mod:sackFossilPreSpawn(id, var, subtype, pos, vel, spawner, seed)
	if subtype == 0 then
		local hasSackFossil = false
		local totalSackFossilChance = 0
		mod.AnyPlayerDo(function(player)
			if player:HasTrinket(FiendFolio.ITEM.ROCK.SACK_FOSSIL) then
				hasSackFossil = true

				local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.SACK_FOSSIL)
				totalSackFossilChance = totalSackFossilChance + 10 * trinketPower
			end
		end)
		totalSackFossilChance = math.ceil(totalSackFossilChance)

		if hasSackFossil then
			grng:SetSeed(math.max(1, seed), 0)
			if grng:RandomInt(100) < totalSackFossilChance then
				return {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_GRAB_BAG, 0, seed}
				--pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_GRAB_BAG, 0)
			end
		end
	end
end

function mod:coinPreSpawn(id, var, subtype, pos, vel, spawner, seed)
    if subtype == 0 then
        local hauntedPennyChance = 200
        local cursedPennyChance = 150
        for i = 1, game:GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)
            if player:GetPlayerType() == FiendFolio.PLAYER.FIEND or player:GetPlayerType() == FiendFolio.PLAYER.BIEND then
                cursedPennyChance = math.min(20, cursedPennyChance)
            elseif player:GetPlayerType() == PlayerType.PLAYER_THELOST or player:GetPlayerType() == PlayerType.PLAYER_THELOST_B then
                hauntedPennyChance = 100
            end
        end
        local evilSticker = mod.anyPlayerHas(mod.ITEM.COLLECTIBLE.EVIL_STICKER, false)
        local foolsGold = mod.anyPlayerHas(mod.ITEM.TRINKET.FOOLS_GOLD, true)
		--local planchette = mod.anyPlayerHas(mod.ITEM.COLLECTIBLE.PLANCHETTE, false)
        if foolsGold then cursedPennyChance = math.min(5, cursedPennyChance) end
        if evilSticker then cursedPennyChance = math.min(3, cursedPennyChance) end
		--if planchette then hauntedPennyChance = math.min(5, hauntedPennyChance)	end
        if mod.getTrinketMultiplierAcrossAllPlayers(mod.ITEM.TRINKET.FOOLS_GOLD) > 1 or (foolsGold and evilSticker) then cursedPennyChance = math.min(2, cursedPennyChance) end

		grng:SetSeed(math.max(1, seed), 0)

        if grng:RandomInt(cursedPennyChance) == 0 then
            if grng:RandomInt(100) == 0 then
                return {id, var, mod.PICKUP.COIN.GOLDENCURSED, seed}
            else
                return {id, var, mod.PICKUP.COIN.CURSED, seed}
            end
        end

        if grng:RandomInt(hauntedPennyChance) == 0 then
            return {5, 20, mod.PICKUP.COIN.HAUNTED, seed}
        end

		if mod.anyPlayerHas(mod.ITEM.ROCK.FOSSILIZED_COIN, true) then
			local mult = mod.GetGolemTrinketPowerAcrossAllPlayers(mod.ITEM.ROCK.FOSSILIZED_COIN)
			local chance = 10+5*mult
			local chance2 = 4+3*mult
			local roll = grng:RandomInt(100)
			if roll < chance2 then
				return {id, var, CoinSubType.COIN_DIME, seed}
			elseif roll < chance then
				return {id, var, CoinSubType.COIN_NICKEL, seed}
			end
		end

		if grng:RandomInt(1000) == 0 then
			return {id, var, mod.PICKUP.COIN.PENNY_THAT_DOUBLES_IN_SIZE_EVERY_DAY, seed}
		elseif grng:RandomInt(1000) == 0 then
			return {id, var, mod.PICKUP.COIN.MOBILE_PENNY, seed}
		end
    end
end

function mod:chestPreSpawn(id, var, subtype, pos, vel, spawner, seed)
	local room = game:GetRoom()
	local chestseed = tostring(seed)

	local d = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'ChestData', chestseed, {})
	if not d.chestRerollCheck then
		local grng = RNG()
		grng:SetSeed(seed, 0)
		--Eternal Chest
		if mod.anyPlayerHas(mod.ITEM.TRINKET.RIGHT_HAND, true) then
			local rhchance = 3
			if mod.getTrinketMultiplierAcrossAllPlayers(mod.ITEM.TRINKET.RIGHT_HAND) > 1 then
				rhchance = 2
			end
			if grng:RandomInt(rhchance) == 0 then
				return {id, PickupVariant.PICKUP_ETERNALCHEST, 0, seed}
			end
		end
		--Dire Chest
		if mod.anyPlayerHas(mod.ITEM.TRINKET.MIDDLE_HAND, true) then
			local rhchance = 2
			if mod.getTrinketMultiplierAcrossAllPlayers(mod.ITEM.TRINKET.MIDDLE_HAND) > 1 then
				rhchance = 1
			end
			if grng:RandomInt(rhchance) < 1 then
				return {id, mod.PICKUP.VARIANT.DIRE_CHEST, 0, seed}
			end
		end
		--Shop Chest
		local roomType = room:GetType()
		if not d.chestReplaced and (roomType ~= RoomType.ROOM_CHALLENGE and roomType ~= RoomType.ROOM_BOSSRUSH) and var == 50 then
			local maxMoolah = 0
			for i = 1, game:GetNumPlayers() do
				local player = Isaac.GetPlayer(i - 1):ToPlayer()
				if player:GetNumCoins() > maxMoolah then
					maxMoolah = player:GetNumCoins()
				end
			end
			--this is apparently support for another mod
			if PickupCapCoinNum and PickupCapCoinNum > maxMoolah then
				maxMoolah = PickupCapCoinNum
			end
			local rollChance = 100
			if maxMoolah > 98 then
				rollChance = 10
			elseif maxMoolah > 50 then
				rollChance = 20
			elseif maxMoolah > 25 then
				rollChance = 40
			elseif maxMoolah > 15 then
				rollChance = 70
			elseif maxMoolah == 0 then
				rollChance = 2000
			end
			if var == 60 then	--Used to work, disabled for now
				rollChance = math.floor(rollChance * 0.75)
			end

			if grng:RandomInt(rollChance) == 0 then
				d.chestReplaced = true
				return {id, mod.PICKUP.VARIANT.SHOP_CHEST, 0, seed}
			end
		--Dire Chest
			if not d.chestReplaced then
				rollChance = 108
				local rand = grng:RandomInt(rollChance)
				if rand == 1 then
					d.chestReplaced = true
					return {id, mod.PICKUP.VARIANT.DIRE_CHEST, 0, seed}
				end
			end
		--Glass Chest
			if not d.chestReplaced then
				rollChance = 36
				local rand = grng:RandomInt(rollChance)
				if rand == 1 then
					d.chestReplaced = true
					return {id, mod.PICKUP.VARIANT.GLASS_CHEST, 0, seed}
				end
			end
			if not d.chestReplaced then
				rollChance = 0
				for i = 1, game:GetNumPlayers() do
					local player = Isaac.GetPlayer(i-1)
					if mod:CanPlayerUseEngineChest(player) then
						rollChance = 45
						break
					end
				end
				if rollChance > 0 and grng:RandomInt(rollChance) == 0 then
					d.chestReplaced = true
					return {id, mod.PICKUP.VARIANT.ENGINE_CHEST, 0, seed}
				end
			end
		end
		d.chestRerollCheck = true
		d.chestReplaced = true
	end
end

function mod:grabBagPreSpawn(id, var, subtype, pos, vel, spawner, seed)
	if subtype == 0 then
		grng:SetSeed(math.max(1, seed), 0)
		if mod.anyPlayerHas(mod.ITEM.COLLECTIBLE.HOT_POTATO_BOOK) and grng:RandomInt(3) == 0 then
			return {id, 666, 12, seed} -- Potato Sack
		end

        if grng:RandomInt(4) == 0 then
            if grng:RandomInt(2) == 0 then
                return {id, 666, 0, seed} -- Trash Bag
            else
                return {id, 666, 10, seed} -- Blood Bag
            end
        end

		if grng:RandomInt(10) == 0 then
			return {id, 666, 12, seed} -- Potato Sack
		end

        if grng:RandomInt(20) == 0 then
            return {id, 666, 11, seed} -- 52 Deck
        end
    end
end

function mod:batteryPreSpawn(id, var, subtype, pos, vel, spawner, seed)
	if subtype == 0 then
		grng:SetSeed(math.max(1, seed), 0)
		if mod.anyPlayerHas(mod.ITEM.COLLECTIBLE.EVIL_STICKER, false) and grng:RandomInt(2) == 0 then
			return {id, mod.PICKUP.VARIANT.CURSED_BATTERY, 0, seed}
		end
        if grng:RandomInt(10) == 0 then
            local kind = grng:RandomInt(4)
            if kind <= 1 then
                return {id, PickupVariant.PICKUP_TAROTCARD, mod.ITEM.CARD.STORAGE_BATTERY_2, seed}
            elseif kind == 2 then
                return {id, PickupVariant.PICKUP_TAROTCARD, mod.ITEM.CARD.STORAGE_BATTERY_1, seed}
            else
                return {id, PickupVariant.PICKUP_TAROTCARD, mod.ITEM.CARD.STORAGE_BATTERY_3, seed}
            end
        elseif grng:RandomInt(30) == 0 then
			local customBatteries = {
				{mod.PICKUP.VARIANT.FIREWORK_BATTERY, 1},
				{mod.PICKUP.VARIANT.VIRTUOUS_BATTERY, 1},
				{mod.PICKUP.VARIANT.CURSED_BATTERY, 2},
			}
			if game.Difficulty % 2 == 1 then
				table.insert(customBatteries, {mod.PICKUP.VARIANT.POTATO_BATTERY, 2})
			end
			local var = StageAPI.WeightedRNG(customBatteries, grng)
			return {id, var, 0, seed}
		end
	end
end

function mod:storageBatteryPreSpawn(id, var, subtype, pos, vel, spawner, seed)
	if mod.usedStorageBattery and mod.isStorageBattery[subtype] then
		return {1000, 0, 0, seed}
	end
	local storageBatts = {
		[mod.ITEM.CARD.STORAGE_BATTERY_1] = true,
		[mod.ITEM.CARD.STORAGE_BATTERY_2] = true,
		[mod.ITEM.CARD.STORAGE_BATTERY_3] = true,
	}
	local corrodedBatts = {
		[mod.ITEM.CARD.CORRODED_BATTERY_1] = true,
		[mod.ITEM.CARD.CORRODED_BATTERY_2] = true,
		[mod.ITEM.CARD.CORRODED_BATTERY_3] = true,
	}
	if storageBatts[subtype] then
		if mod.PlayerJustUsedD1 then
			--Random Battery (since batteries can roll into them)
			return {5,90,0,seed}
		end
	elseif corrodedBatts[subtype] then
		if mod.PlayerJustUsedD1 then
			--Empty corroded battery
			return {5,300,mod.ITEM.CARD.CORRODED_BATTERY_0,seed}
		end
	end
end

function mod:heartPreSpawn(id, var, subtype, pos, vel, spawner, seed)
	if game:GetRoom():GetType() == RoomType.ROOM_SUPERSECRET and mod.roomBackdrop == 10 and mod.ACHIEVEMENT.MORBID_HEART:IsUnlocked() then	-- Morbus super secret room
		if subtype == HeartSubType.HEART_HALF or subtype == HeartSubType.HEART_HALF_SOUL then
			return {5, FiendFolio.PICKUP.VARIANT.THIRD_MORBID_HEART, 0, seed}
		elseif subtype == HeartSubType.HEART_DOUBLEPACK then
			return {5, FiendFolio.PICKUP.VARIANT.MORBID_HEART, 0, seed}
		else
			return {5, FiendFolio.PICKUP.VARIANT.TWOTHIRDS_MORBID_HEART, 0, seed}
		end
	end
	grng:SetSeed(math.max(1, seed), 0)
	if mod.anyPlayerHas(mod.ITEM.COLLECTIBLE.ORGAN_DONOR) then
		if subtype ~= HeartSubType.HEART_FULL and subtype ~= HeartSubType.HEART_HALF then
			if grng:RandomFloat() < 0.02 then
				return {5, 10, HeartSubType.HEART_DOUBLEPACK, seed}
			elseif grng:RandomFloat() < 0.50 then
				return {5, 10, HeartSubType.HEART_HALF, seed}
			elseif grng:RandomFloat() < 0.025 then
				return {5, 10, HeartSubType.HEART_SCARED, seed}
			else
				return {5, 10, HeartSubType.HEART_FULL, seed}
			end
		end
	end
	if mod.anyPlayerHas(mod.ITEM.COLLECTIBLE.KALUS_HEART) then
		if subtype == HeartSubType.HEART_FULL or subtype == HeartSubType.HEART_HALF
		or subtype == HeartSubType.HEART_SCARED or subtype == HeartSubType.HEART_DOUBLEPACK then
			if grng:RandomFloat() < 0.12 then
				return {5, 10, HeartSubType.HEART_ROTTEN, seed}
			end
		end
	end
	if mod.anyPlayerHas(mod.ITEM.ROCK.ONYX, true) then
		local newSub
		local mult = mod.GetGolemTrinketPowerAcrossAllPlayers(mod.ITEM.ROCK.ONYX)
		local chance = 40+20*mult
		local chance2 = 10+10*mult
		local roll = grng:RandomInt(100)
		local roll2 = grng:RandomInt(100)
		local redReplaces = {[HeartSubType.HEART_FULL] = HeartSubType.HEART_SOUL, [HeartSubType.HEART_HALF] = HeartSubType.HEART_HALF_SOUL, [HeartSubType.HEART_SCARED] = HeartSubType.HEART_SOUL}
		if redReplaces[subtype] then
			if roll < chance2 then
				newSub = redReplaces[subtype]
			else
				return {5, 10, 114, seed} --Erasing done in main.lua, fiend heart replacement
			end
		end
		if roll2 < chance then
			if subtype == HeartSubType.HEART_SOUL or newSub == HeartSubType.HEART_SOUL then
				return {5, 10, HeartSubType.HEART_BLACK, seed}
			elseif subtype == HeartSubType.HEART_HALF_SOUL or newSub == HeartSubType.HEART_HALF_SOUL then
				return {5, mod.PICKUP.VARIANT.HALF_BLACK_HEART, 0, seed}
			elseif subtype == HeartSubType.HEART_BLENDED then
				return {5, mod.PICKUP.VARIANT.BLENDED_BLACK_HEART, 0, seed}
			end
		elseif newSub then
			return {5, 10, newSub, seed}
		end
	end
	for i = 1, game:GetNumPlayers() do
		local p = Isaac.GetPlayer(i - 1)
		if p:HasCollectible(mod.ITEM.COLLECTIBLE.GUPPYS_HEART) then
			local rng = p:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.GUPPYS_HEART)
			local heartVal = mod:IsSoulHeartPickup(var, subtype)
			if SoulHeartOnlyStrict[p:GetPlayerType()] and heartVal then
				--ehhhh, decided not to make it give orbitals and remove the soul heart
			elseif heartVal then
				local roll = rng:RandomInt(100)
				if heartVal > 1 then
					if roll < 40 then
						return {5, FiendFolio.PICKUP.VARIANT.MORBID_HEART, 0, seed}
					elseif roll < 90 then
						return {5, FiendFolio.PICKUP.VARIANT.TWOTHIRDS_MORBID_HEART, 0, seed}
					else
						return {5, FiendFolio.PICKUP.VARIANT.THIRD_MORBID_HEART, 0, seed}
					end
				else
					if roll < 40 then
						return {5, FiendFolio.PICKUP.VARIANT.TWOTHIRDS_MORBID_HEART, 0, seed}
					else
						return {5, FiendFolio.PICKUP.VARIANT.THIRD_MORBID_HEART, 0, seed}
					end
				end
			end
		end
	end
	if subtype == 0 then
		if mod:anyPlayerIsSkeletalFiend() then
			if grng:RandomFloat() < 0.33 then
				return {5, 10, 11, seed}
			end
		end

		local immoralchance = 0.005 -- About equivalent to black heart chance
		if mod:somePlayerHasImmoral(true) then
			immoralchance = 0.02
		end

		local morbidchance = 0.008 -- Little less than half of rotten heart chance
		if mod:somePlayerHasPostiche() then
			morbidchance = 0.03
		end

		if grng:RandomFloat() < immoralchance and mod.ACHIEVEMENT.IMMORAL_HEART:IsUnlocked() then
			return {EntityType.ENTITY_PICKUP, mod.PICKUP.VARIANT.IMMORAL_HEART, 0, seed}
		elseif grng:RandomFloat() < morbidchance and mod.ACHIEVEMENT.MORBID_HEART:IsUnlocked() then
			return {EntityType.ENTITY_PICKUP, FiendFolio.PICKUP.VARIANT.MORBID_HEART, 0, seed}
		end

		if mod.anyPlayerHas(mod.ITEM.COLLECTIBLE.EVIL_STICKER) and mod.ACHIEVEMENT.IMMORAL_HEART:IsUnlocked() then
			local rand = grng:RandomInt(20)
			if rand == 0 then
				return {EntityType.ENTITY_PICKUP, mod.PICKUP.VARIANT.IMMORAL_HEART, 0, seed}
			end
		end
	elseif subtype == HeartSubType.HEART_BLACK then
		if mod.anyPlayerHas(mod.ITEM.COLLECTIBLE.THE_LAST_BLACK_HEART) then
			if mod:RoomForcesBlackHeart() then
				return {13,0,0,seed}
			else
				local pickupChoice
				local dynamicPool = {}
				for _, data in pairs(mod.UnbiasedPickups["HeartsNoBlack"]) do
					if data.Unlocked() then
						table.insert(dynamicPool, data.ID)
					end
				end
				pickupChoice = dynamicPool[grng:RandomInt(#dynamicPool) + 1]

				if tonumber(pickupChoice) then
					return {5, 10, pickupChoice, seed}
				else
					return {5, pickupChoice.Var, pickupChoice.Sub, seed}
				end
			end
		end
	end
end

function mod:ffHeartPreSpawn(id, var, subtype, pos, vel, spawner, seed)
	if game:GetRoom():GetType() == RoomType.ROOM_SUPERSECRET and mod.roomBackdrop == 10 and mod.ACHIEVEMENT.MORBID_HEART:IsUnlocked()			-- Morbus super secret room
		and not (var == FiendFolio.PICKUP.VARIANT.THIRD_MORBID_HEART or var == FiendFolio.PICKUP.VARIANT.TWOTHIRDS_MORBID_HEART or var == FiendFolio.PICKUP.VARIANT.MORBID_HEART)
	then
		if var == FiendFolio.PICKUP.VARIANT.HALF_BLACK_HEART or var == FiendFolio.PICKUP.VARIANT.HALF_IMMORAL_HEART or var == FiendFolio.PICKUP.VARIANT.HALF_BOMB_HEART then
			return {5, FiendFolio.PICKUP.VARIANT.THIRD_MORBID_HEART, 0, seed}
		else
			return {5, FiendFolio.PICKUP.VARIANT.TWOTHIRDS_MORBID_HEART, 0, seed}
		end
	end
	grng:SetSeed(math.max(1, seed), 0)
	if mod.anyPlayerHas(mod.ITEM.COLLECTIBLE.ORGAN_DONOR) then
		if grng:RandomFloat() < 0.02 then
			return {5, 10, HeartSubType.HEART_DOUBLEPACK, seed}
		elseif grng:RandomFloat() < 0.50 then
			return {5, 10, HeartSubType.HEART_HALF, seed}
		elseif grng:RandomFloat() < 0.025 then
			return {5, 10, HeartSubType.HEART_SCARED, seed}
		else
			return {5, 10, HeartSubType.HEART_FULL, seed}
		end
	end
	if mod.anyPlayerHas(mod.ITEM.COLLECTIBLE.THE_LAST_BLACK_HEART) then
		if var == FiendFolio.PICKUP.VARIANT.HALF_BLACK_HEART
		or var == FiendFolio.PICKUP.VARIANT.BLENDED_BLACK_HEART then
			if mod:RoomForcesBlackHeart() then
				return {13,0,0,seed}
			else
				local pickupChoice
				local dynamicPool = {}
				for _, data in pairs(mod.UnbiasedPickups["HeartsNoBlack"]) do
					if data.Unlocked() then
						table.insert(dynamicPool, data.ID)
					end
				end
				pickupChoice = dynamicPool[grng:RandomInt(#dynamicPool) + 1]

				if tonumber(pickupChoice) then
					return {5, 10, pickupChoice, seed}
				else
					return {5, pickupChoice.Var, pickupChoice.Sub, seed}
				end
			end
		end
	end
end

function mod:heartPostSelection(pickup, var, subt, reqVar, reqSubt, rng)
	local isRandomHeart = (reqVar == PickupVariant.PICKUP_HEART and reqSubt == 0)
	local isRandomPickupThatChoseHeart = (reqVar == 0 and var == PickupVariant.PICKUP_HEART)
	if not isRandomHeart and not isRandomPickupThatChoseHeart then
		-- This is either not a randomized pickup, or not a heart. Don't replace it.
		return
	end

	if Isaac.GetPersistentGameData():Unlocked(Achievement.GOLD_HEART) then
		if (subt == HeartSubType.HEART_GOLDEN and (PlayerManager.AnyoneHasTrinket(mod.ITEM.TRINKET.FOOLS_GOLD) or PlayerManager.AnyoneHasCollectible(mod.ITEM.COLLECTIBLE.EVIL_STICKER)))
		or (subt ~= HeartSubType.HEART_GOLDEN and rng:RandomInt(160) == 0) then  -- Same chance as Gold Hearts
			return {FiendFolio.PICKUP.VARIANT.FOOLS_GOLD_HEART, 0, true}
		end
	end

	for i = 1, game:GetNumPlayers() do
		local p = Isaac.GetPlayer(i - 1)
		if p:HasCollectible(mod.ITEM.COLLECTIBLE.GUPPYS_HEART) then
			local heartVal = mod:IsSoulHeartPickup(var, subt)
			if SoulHeartOnlyStrict[p:GetPlayerType()] and heartVal then
				--ehhhh, decided not to make it give orbitals and remove the soul heart
			elseif heartVal then
				local roll = rng:RandomInt(100)
				if heartVal > 1 then
					if roll < 40 then
						return {FiendFolio.PICKUP.VARIANT.MORBID_HEART, 0, true}
					elseif roll < 90 then
						return {FiendFolio.PICKUP.VARIANT.TWOTHIRDS_MORBID_HEART, 0, true}
					else
						return {FiendFolio.PICKUP.VARIANT.THIRD_MORBID_HEART, 0, true}
					end
				else
					if roll < 40 then
						return {FiendFolio.PICKUP.VARIANT.TWOTHIRDS_MORBID_HEART, 0, true}
					else
						return {FiendFolio.PICKUP.VARIANT.THIRD_MORBID_HEART, 0, true}
					end
				end
			end
		end
	end

	if Isaac.GetPersistentGameData():Unlocked(Achievement.SOMETHING_FROM_THE_FUTURE) then
		local stevenChance = 500
		local boxMult = mod.getTrinketMultiplierAcrossAllPlayers(mod.ITEM.TRINKET.STEVENS_BOX)
		if boxMult >= 1 then
			stevenChance = math.max(5,math.ceil(35 / boxMult))
		end
		if rng:RandomInt(stevenChance) == 1 then
			return {FiendFolio.PICKUP.VARIANT.STEVEN_HEART, 0, true}
		end
	end
end
function mod:keyPostSelection(pickup, var, subt, reqVar, reqSubt, rng)
	local isRandomKey = (reqVar == PickupVariant.PICKUP_KEY and reqSubt == 0)
	local isRandomPickupThatChoseKey = (reqVar == 0 and var == PickupVariant.PICKUP_KEY)
	if not isRandomKey and not isRandomPickupThatChoseKey then
		-- This is either not a randomized pickup, or not a key. Don't replace it.
		return
	end
	if subt == KeySubType.KEY_NORMAL and mod.DoVanillaItemTweaks then
		local difficulty = (game.Difficulty % 2)
		local doubleChance = 75
		if difficulty == Difficulty.DIFFICULTY_HARD then
			doubleChance = 133 --Sisi liked the number
		end
		if rng:RandomInt(doubleChance) == 1 then
			return {PickupVariant.PICKUP_KEY, KeySubType.KEY_DOUBLEPACK, true}
		end
	end
end
function mod:coinPostSelection(pickup, var, subt, reqVar, reqSubt, rng)
	local isRandomCoin = (reqVar == PickupVariant.PICKUP_COIN and reqSubt == 0)
	local isRandomPickupThatChoseCoin = (reqVar == 0 and var == PickupVariant.PICKUP_COIN)
	if not isRandomCoin and not isRandomPickupThatChoseCoin then
		-- This is either not a randomized pickup, or not a coin. Don't replace it.
		return
	end
	if subt == CoinSubType.COIN_PENNY and mod.DoVanillaItemTweaks then
		local difficulty = (game.Difficulty % 2)
		local doubleChance = 128
		if difficulty == Difficulty.DIFFICULTY_HARD then
			doubleChance = 256
		end
		if rng:RandomInt(doubleChance) == 1 then
			return {PickupVariant.PICKUP_COIN, CoinSubType.COIN_DOUBLEPACK, true}
		end
	end
end
function mod:trinketPostSelection(pickup, var, subt, reqVar, reqSubt, rng)
	local isRandomTrinky = (reqVar == PickupVariant.PICKUP_TRINKET and reqSubt == 0)
	local isRandomPickupThatChoseTrinky = (reqVar == 0 and var == PickupVariant.PICKUP_TRINKET)
	if not isRandomTrinky and not isRandomPickupThatChoseTrinky then
		-- This is either not a randomized pickup, or not a coin. Don't replace it.
		return
	end
	--If the player has missing poster unlocked, but has NOT unlocked the lost
	--This makes it a little easier to get, as we add a lot of trinkets
	if not FiendFolio.RockTrinkets[subt] then
		--Yeah though don't replace rocks, that's not the plan
		local persistData = Isaac.GetPersistentGameData()
		if (not persistData:Unlocked(Achievement.THE_LOST))
		and persistData:Unlocked(Achievement.MISSING_POSTER)
		then
			if rng:RandomInt(90) == 23 then --Based on the number of trinkets in Afterbirth, when the unlock was added
				return {PickupVariant.PICKUP_TRINKET, TrinketType.TRINKET_MISSING_POSTER, true}
			end
		end
	end
end

function mod:wackeyPreSpawn(id, var, subtype, pos, vel, spawner, seed)
	if subtype == 0 then
		grng:SetSeed(math.max(1, seed), 0)
        local wackeyness = mod.getTrinketMultiplierAcrossAllPlayers(FiendFolio.ITEM.TRINKET.WACKEY)
		local pickupChoice
		if wackeyness >= 3 then
			pickupChoice = "SpadesBest"
		elseif wackeyness >= 2 then
			pickupChoice = "SpadesBetter"
		elseif wackeyness > 0 then
			pickupChoice = "Spades"
		end
		if pickupChoice then
			local dynamicPool = {}
            for _, data in pairs(mod.UnbiasedPickups[pickupChoice]) do
                if data.Unlocked() then
                    table.insert(dynamicPool, data.ID)
                end
            end

            newSub = dynamicPool[grng:RandomInt(#dynamicPool) + 1]
			return {id, var, newSub}
		end
	end
end

function mod:unobtainiumPreSpawn(id, var, subtype, pos, vel, spawner, seed)
	return {id, var, FiendFolio.GetGolemTrinket()}
end

function mod:dadsLegendaryGoldenRockPreSpawn(id, var, subtype, pos, vel, spawner, seed)
	if subtype < TrinketType.TRINKET_GOLDEN_FLAG then
		return {id, var, subtype + TrinketType.TRINKET_GOLDEN_FLAG}
	end
end

function mod:copperBombPreSpawn(id, var, subtype, pos, vel, spawner, seed)
	grng:SetSeed(math.max(1, seed), 0)
	if subtype == 0 then
		local chance = 0.01 -- About 1/10 the chance of a troll bomb
		local trinkyPower = mod.getTrinketMultiplierAcrossAllPlayers(FiendFolio.ITEM.TRINKET.FAULTY_FUSE)
		chance = chance + (0.4 * trinkyPower)
		local doubleupChance = 0.15
		if mod.anyPlayerHas(CollectibleType.COLLECTIBLE_BOGO_BOMBS) then
			doubleupChance = 1
		elseif mod.anyPlayerHas(CollectibleType.COLLECTIBLE_HUMBLEING_BUNDLE) then
			doubleupChance = 0.5
		end
		if grng:RandomFloat() < chance then
			local trollChance = 0.01
			if grng:RandomFloat() < trollChance then
				return {EntityType.ENTITY_BOMB, BombVariant.BOMB_TROLL, 160, seed}
			else
				if grng:RandomFloat() < doubleupChance then
					if grng:RandomFloat() < 0.75 then
						return {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, FiendFolio.PICKUP.BOMB.MIXED_DOUBLE, seed}
					else
						return {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, FiendFolio.PICKUP.BOMB.DOUBLE_COPPER, seed}
					end
				else
					return {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, FiendFolio.PICKUP.BOMB.COPPER, seed}
				end
			end
		end

		local addedChance = 0
		if mod.anyPlayerHas(mod.ITEM.COLLECTIBLE.EVIL_STICKER) then addedChance = addedChance + 0.1 end
		if mod.anyPlayerHas(mod.ITEM.COLLECTIBLE.COPPER_WRENCH) then addedChance = addedChance + 0.2 end
		if mod.anyPlayerHas(mod.ITEM.COLLECTIBLE.COPPER_CHUNK) then 
			local times = mod.getCollectibleMultiplierAcrossAllPlayers(mod.ITEM.COLLECTIBLE.COPPER_CHUNK)
			addedChance = addedChance + 0.1 + (0.1*times)
		end

		if addedChance > 0 then
			if grng:RandomFloat() <= addedChance then
				if grng:RandomFloat() < doubleupChance then
					return {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, FiendFolio.PICKUP.BOMB.DOUBLE_COPPER, seed}
				else
					return {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, FiendFolio.PICKUP.BOMB.COPPER, seed}
				end
			end
		end
	elseif subtype == FiendFolio.PICKUP.BOMB.COPPER then
		local trinkyPower = mod.getTrinketMultiplierAcrossAllPlayers(FiendFolio.ITEM.TRINKET.FAULTY_FUSE)
		local forcedDoubleUpChance = 0 + (trinkyPower * 0.25)
		if mod.anyPlayerHas(CollectibleType.COLLECTIBLE_BOGO_BOMBS) then
			forcedDoubleUpChance = 1
		elseif mod.anyPlayerHas(CollectibleType.COLLECTIBLE_HUMBLEING_BUNDLE) then
			forcedDoubleUpChance = forcedDoubleUpChance + 0.5
		end
		if grng:RandomFloat() < forcedDoubleUpChance then
			return {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, FiendFolio.PICKUP.BOMB.DOUBLE_COPPER, seed}
		end
	elseif subtype == FiendFolio.PICKUP.BOMB.COPPER_TROLL then
		return {4, 3, 160, seed}
	end
end

function mod:handleLockedPills(id, var, subtype, pos, vel, spawner, seed)
	local modified
	if subtype % 2048 == 14 and not Isaac.GetPersistentGameData():Unlocked(Achievement.GOLDEN_PILLS) then
		subtype = subtype - 14
		modified = true
	end
	if subtype >= 2048 and not Isaac.GetPersistentGameData():Unlocked(Achievement.HORSE_PILLS) then
		subtype = subtype - 2048
		modified = true
	end
	--Ensures gold / horse pills don't spawn if not unlocked
	--Nicalis doesn't account for this for some reason
	if modified then
		return {5, 70, subtype, seed}
	end
	--Random horse pill spawn
	--return above this means it should only run after checks
	if subtype == 2048 then
		grng:SetSeed(math.max(1, seed), 0)
		return {5, 70, 2048 + grng:RandomInt(12) + 1, seed}
	end
end

function mod:cornKernelPreSpawn(id, var, subtype, pos, vel, spawner, seed)
	--Not a rigorous check I know
	if Game():GetRoom():GetType() == RoomType.ROOM_BOSS then
		local savedata = FiendFolio.savedata.run
		--Code ensures corn kernel works like cube of meat / ball of bandages
		if savedata.CubeReplacement then
			if subtype ~= savedata.CubeReplacement then
				return {5, 100, savedata.CubeReplacement, seed}
			end
		else
			local currentRoom = StageAPI.GetCurrentRoom()
			if currentRoom and currentRoom.PersistentData.BossID then
				bossData = StageAPI.GetBossData(currentRoom.PersistentData.BossID)
				if bossData and bossData.IsFFBoss and bossData.Horseman then
					savedata.CubeReplacement = mod.ITEM.COLLECTIBLE.CORN_KERNEL
				end
			else
				savedata.CubeReplacement = subtype
			end
		end
	end
end

function mod:gildedKeyPreSpawn(id, var, subtype, pos, vel, spawner, seed)
	if mod.anyPlayerHas(TrinketType.TRINKET_GILDED_KEY, true) then
		return {5, PickupVariant.PICKUP_LOCKEDCHEST, 0, seed}
	end
end

function mod:stevenHeartPreSpawn(id, var, subtype, pos, vel, spawner, seed)
	if not Isaac.GetPersistentGameData():Unlocked(Achievement.SOMETHING_FROM_THE_FUTURE) then
		return {5, PickupVariant.PICKUP_HEART, 0, seed}
	end
end

--A couple autodelete slots
function mod:babiPreSpawn(id, var, subtype, pos, vel, spawner, seed)
	if subtype > 1048576 then
		return {1000,0,999,seed}
	end
end

function mod:sweetpussPreSpawn(id, var, subtype, pos, vel, spawner, seed)
	if subtype == 10 then
		return {1000,0,999,seed}
	end
end

function mod:pokerTablePreSpawn(id, var, subtype, pos, vel, spawner, seed)
	if subtype == mod.pokerTableStates.DoneLeaving then
		return {1000,0,999,seed}
	end
end

function mod:vendingMachinePreSpawn(id, var, subtype, pos, vel, spawner, seed)
	if mod:VendingMachineReplacementCheck(var, subtype) then
		return {1000,0,999,seed}
	end
end
function mod:milkMachinePreSpawn(id, var, subtype, pos, vel, spawner, seed)
	if not mod.ACHIEVEMENT.SALOON:IsUnlocked() then
		return {EntityType.ENTITY_SLOT,SlotVariant.SLOT_MACHINE,0,seed}
	end
end

function mod:dudsFlowerPreSpawn(id, var, subtype, pos, vel, spawner, seed)
	if subtype == 0 then --Troll bomb
		if spawner and spawner.Type == 1 then
			if spawner:ToPlayer():HasTrinket(mod.ITEM.TRINKET.DUDS_FLOWER) then
				return{4,3,160}
			end
			if spawner:ToPlayer():HasCollectible(mod.ITEM.COLLECTIBLE.COPPER_CHUNK) then
				local times = mod.getCollectibleMultiplierAcrossAllPlayers(mod.ITEM.COLLECTIBLE.COPPER_CHUNK)
				grng:SetSeed(math.max(1, seed), 0)
				if grng:RandomFloat() < 0.15+(0.1*times) then
					return{4,3,160}
				end
			end
		end
	end
end

FiendFolio.HorsemanCubes = {
	[CollectibleType.COLLECTIBLE_CUBE_OF_MEAT] = true,
	[CollectibleType.COLLECTIBLE_BALL_OF_BANDAGES] = true,
	[FiendFolio.ITEM.COLLECTIBLE.CORN_KERNEL] = true,
}

local tokenCheckedChestTypes = {
	[PickupVariant.PICKUP_CHEST] = true,
	[PickupVariant.PICKUP_SPIKEDCHEST] = true,
	[PickupVariant.PICKUP_ETERNALCHEST] = true,
	[PickupVariant.PICKUP_MIMICCHEST] = true,
	[PickupVariant.PICKUP_MEGACHEST] = true,
	[PickupVariant.PICKUP_HAUNTEDCHEST] = true,
	[PickupVariant.PICKUP_LOCKEDCHEST] = true,
	[PickupVariant.PICKUP_GRAB_BAG] = true,
}

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
	local twinTuffsPower = 0
	local luck = 0
	local rng = grng
	mod.AnyPlayerDo(function(player)
		if player:HasTrinket(FiendFolio.ITEM.ROCK.TWIN_TUFFS) then
			twinTuffsPower = twinTuffsPower + FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.TWIN_TUFFS)
			luck = math.max(player.Luck, luck)
			rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.TWIN_TUFFS)
			rng:SetSeed(pickup.InitSeed, 1)
		end
	end)

	if twinTuffsPower > 0 then
		local seedIndex = tostring(pickup.InitSeed)
		local TuffData = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'TwinTuffs', seedIndex, {})
		if not TuffData.TriedToRoll then
			--print(pickup.InitSeed)
			TuffData.TriedToRoll = true
			local baseChance = 0.25 * twinTuffsPower
			local luckChance = 0.025 * twinTuffsPower
			if rng:RandomFloat() < baseChance + luckChance * luck then
				local nvar, nsub = FiendFolio.GetTwinTuffsReplacement(pickup)
				if nvar then
					pickup:Morph(5, nvar, nsub, true, true)
				end
			end
		end
	end

	if pickup.Variant == 70 then
		local seedIndex = tostring(pickup.InitSeed)
		local CyanideData = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'CyanidePills', seedIndex, {})
		if mod.anyPlayerHas(FiendFolio.ITEM.COLLECTIBLE.CYANIDE_DEADLY_DOSE) and not pickup.SpawnerEntity then
			if not CyanideData.TriedToReplace then
				CyanideData.TriedToReplace = true
				if not mod.savedata.run.TryingToSpawnCyanide then
					if pickup.SubType == 14 or pickup.SubType == 961 then
						pickup:Morph(5, 70, 961, true, true)
					elseif pickup.SubType == 2062 or pickup.SubType == 3009 then
						pickup:Morph(5, 70, 3009, true, true)
					elseif pickup.SubType > 2048 then
						pickup:Morph(5, 70, 3008, true, true)
					else
						pickup:Morph(5, 70, 960, true, true)
					end
				end
			end
		else
			CyanideData.TriedToReplace = true
		end
	end

	if pickup.Variant == 300 then
		local seedIndex = tostring(pickup.InitSeed)
		local CyanideData = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'CyanidePills', seedIndex, {})
		if mod.anyPlayerHas(FiendFolio.ITEM.COLLECTIBLE.CYANIDE_DEADLY_DOSE) and mod.anyPlayerHas(CollectibleType.COLLECTIBLE_STARTER_DECK) and not pickup.SpawnerEntity then
			if not CyanideData.TriedToReplace then
				CyanideData.TriedToReplace = true
				if not mod.savedata.run.TryingToSpawnCyanide then
					pickup:Morph(5, 300, FiendFolio.ITEM.CARD.DESTINY_BOARD, true, true)
				end
			end
		else
			CyanideData.TriedToReplace = true
		end
	end

	if pickup.Variant == 20 and pickup.FrameCount <= 0 then
		for _, chest in pairs(Isaac.FindInRadius(pickup.Position, 0.00001, EntityPartition.PICKUP)) do
			if pickup.InitSeed ~= chest.InitSeed then
				if tokenCheckedChestTypes[chest.Variant] then
					local rollChance = 100
					local roll = pickup:GetDropRNG():RandomInt(rollChance)
					--print(roll)
					if roll == 0 then
						pickup:Morph(5, FiendFolio.PICKUP.VARIANT.TOKEN, 0, true, true)
					end
				end
			end
		end
	end
end)



--newage stop replacement
-- this function will be called anytime a room entity spawns
-- generally only do replacements here
-- because the ff persistence system depends on the callback being weird,
-- do persistence here too
local function PickupSpawnHelper(id, grindex, seed, randomIds, registry, variant)
    if id == 0 and randomIds then
        grng:SetSeed(seed + grindex, 0)
        id = randomIds[grng:RandomInt(#randomIds) + 1].softId
    end

    local item = registry[id]
    if item then
		local pickupSubtype = item.id
		if variant == PickupVariant.PICKUP_TAROTCARD then
			local config = Isaac.GetItemConfig()
			local card = config:GetCard(item.id)
			if card and not card:IsAvailable() then
				pickupSubtype = 0
			end
		end
        return { EntityType.ENTITY_PICKUP, variant, pickupSubtype}
    end

    return {
        999,
        StageAPI.E.DeleteMeEffect.V,
        0
    }
end

mod.LastRoomIndexForReplacementLogic = -999
mod.DrownedSpittyReplacements = 0
function mod:roomInit(id, variant, subtype, gridindex, seed, stageAPIFirstLoad)
	local room = game:GetRoom()
	local currentRoomIndex = game:GetLevel():GetCurrentRoomIndex()

	if mod.SetCurrentBackdrop and mod.SetCurrentBackdrop ~= currentRoomIndex then
		mod.roomBackdrop = nil
		mod.roomBackdropFrom = nil
		mod.roomBackdropFromStageAPI = nil
		mod.roomBackdropFromLevel = nil
		mod.SetCurrentBackdrop = nil
	end
	if mod.LastRoomIndexForReplacementLogic ~= currentRoomIndex then
		mod.DrownedSpittyReplacements = 0
		mod.LastRoomIndexForReplacementLogic = currentRoomIndex
	end

	if mod.ModeEnabled == 1 then
		--God help us all
		if id > 9 and id < 1000 then
			return {mod.FF.Mern.ID, mod.FF.Mern.Var, 0}
		end
	elseif mod.ModeEnabled == 2 then
		--Easy mode
		if id > 9 and id < 1000 then
			if game:GetRoom():GetType() ~= RoomType.ROOM_BOSS then
				return {mod.FF.WoodburnerEasy.ID, mod.FF.WoodburnerEasy.Var, 0}
			end
		--[[elseif id == 1930 then
			return {1500, 0 ,0}]]
		elseif id == 9000 then
			return {5, 370, 0}
		elseif id > 999 then
			return {1494, 0, 0}
		end
	end

	if id == EntityType.ENTITY_GAPER then
		if variant == 1 and subtype == 0 then
			grng:SetSeed(seed, 0)
			if grng:RandomInt(777) == 7 and not mod.SpookingOfIsaacActivated then
				return mod.ENT("PennyGaper")
			end
		end
		if (variant == 0 or variant == 2 or variant == mod.FF.PennyGaper.Var) and subtype == 0 then
			if mod.SpookingOfIsaacActivated then
				return {10,1,0}
			end
		end
	elseif id == 15 and variant == mod.FF.Drumstick.Var then
		return mod.ENT("Drumstick")
	elseif id == 15 and variant == mod.FF.HolyDrumstick.Var then
		return mod.ENT("HolyDrumstick")
	elseif id == 16 and (variant == 0 or variant == 1) and subtype == 900 then
		-- i hate the mulligan/mulligoon -> mulliboom replacement with a burning passion and don't want it in my rooms k thx bye - taiga
		return {16, variant, 0}
	elseif id == 16 and variant == mod.FF.Facade.Var then
		return mod.ENT("Facade")
	elseif id == 21 then
		if variant == mod.FF.Nimbus.Var and subtype == 0 then
			return mod.ENT("Nimbus")
		elseif variant == mod.FF.RolyPoly.Var then
			return {mod.FF.RolyPoly.ID, mod.FF.RolyPoly.Var, subtype}
		end
		elseif id == mod.FF.Cistern.ID and variant == mod.FF.Cistern.Var and subtype == 0 then
		return mod.ENT("Cistern")

	elseif id == 25 then
        grng:SetSeed(seed, 0)
		local funvar = grng:RandomInt(5000)
        local odds = 1
        if mod.getField(FiendFolio.savedata, 'run', 'dadsdebt') == 99 then odds = odds * 2 end
        if mod.anyPlayerHas(TrinketType.TRINKET_SHINY_ROCK, true) then odds = odds * 2 end
        if mod.anyPlayerHas(FiendFolio.ITEM.ROCK.NITRO_CRYSTAL, true) then odds = odds * 2 end
		if funvar < odds then
			if variant == mod.FF.Mightfly.Var then
				return {mod.FF.GoldenMightfly.ID, mod.FF.GoldenMightfly.Var, 0}
			else
				return {mod.FF.GBF.ID, mod.FF.GBF.Var, 0}
			end
		elseif variant == 1 and grng:RandomInt(25) == 0 and mod.replacementsEnabled then
			return {mod.FF.Warhead.ID, mod.FF.Warhead.Var, 0}
		end

	elseif id == 27 then
		if variant < 2 and subtype == 0 then
			local level = game:GetLevel()
			local stage = level:GetAbsoluteStage()
			local stageType = level:GetStageType()
			grng:SetSeed(seed, 0)
			if grng:RandomInt(6) == 0 and mod.replacementsEnabled and (stage == 5 or stage == 6) and stageType == 2 then
				return mod.ENT("SludgeHost")
			end
			if variant == 1 or grng:RandomInt(10) == 0 then
				return {27, 1, 0}
			else
				return {27, 0, 0}
			end
		--Hostlet
		elseif variant == 0 and subtype == 250 then
			grng:SetSeed(seed, 0)
			if grng:RandomInt(10) == 0 and mod.legacyReplacementsEnabled then
				return {27, 1, 251}
			else
				return {27, 0, 250}
			end
		end

	elseif id == 29 and variant == 0 and not mod.legacyReplacementsEnabled then
		return {29, 0, subtype}
	elseif id == 29 and variant == 1 and not mod.legacyReplacementsEnabled then
		return {29, 1, subtype}
	elseif id == 29 and variant > 959 and variant < 970 then
		return {29, variant, subtype}

	--Boils
	elseif id == 30 and variant == 0 and not mod.legacyReplacementsEnabled then
		return {30, 0, 0}
	elseif id == 30 and variant == 1 and not mod.legacyReplacementsEnabled then
		return {30, 1, 0}
	elseif id == 30 and variant == 2 and not mod.legacyReplacementsEnabled then
		return {30, 2, 0}
	elseif id == 30 and variant == mod.FF.StickySack.Var then
		return mod.ENT("StickySack")

	--Spitties
	elseif id == 31 and variant == 0 then
		local level = game:GetLevel()
		if mod.replacementsEnabled and (level:GetAbsoluteStage() == LevelStage.STAGE2_1 or level:GetAbsoluteStage() == LevelStage.STAGE2_2) and level:GetStageType() == StageType.STAGETYPE_AFTERBIRTH then
			local chance = 0.5
			if mod.DrownedSpittyReplacements > 2 then
				chance = chance / (mod.DrownedSpittyReplacements - 1)
			end
			grng:SetSeed(seed, 0)
			if grng:RandomFloat() <= chance then
				mod.DrownedSpittyReplacements = mod.DrownedSpittyReplacements + 1
				return {mod.FF.DrownedSpitty.ID, mod.FF.DrownedSpitty.Var, 0}
			end
		end

		if not mod.legacyReplacementsEnabled then
			return {31, 0, 0}
		end

	--Vis
	elseif id == 39 and variant == 0 and not mod.legacyReplacementsEnabled then
		return {39, 0, subtype}
	elseif id == 39 and variant == 1 and not mod.legacyReplacementsEnabled then
		return {39, 1, subtype}
	elseif id == 39 and variant == 2 and not mod.legacyReplacementsEnabled then
		return {39, 2, subtype}
	elseif id == 39 and variant == 3 and not mod.legacyReplacementsEnabled then
		return {39, 3, subtype}

	--The heck is this for?
	elseif id == 41 and variant == 0 and subtype == 7000 then
		return {41, 0, 7000}

	--Stone grimaces stay as stone grimaces
	elseif id == 42 and variant == 0 and subtype == 0 and not mod.legacyReplacementsEnabled then
		return {42, 0, 0}

	--Pokies don't become slides
	elseif id == 44 and variant == 0 and subtype == 0 and not mod.legacyReplacementsEnabled then
		return {44, 0, 0}

	--Dople
	elseif id == 53 and variant == 0 and subtype == 0 and not mod.legacyReplacementsEnabled then
		return {53, 0, 0}

	--Shine Spit replacement
	elseif id == EntityType.ENTITY_SUCKER and variant == 1 and subtype == 0 then
		grng:SetSeed(seed, 0)
		local funvar = grng:RandomInt(5000)
        local odds = 1
        if mod.getField(FiendFolio.savedata, 'run', 'dadsdebt') == 99 then odds = odds * 2 end
        if mod.anyPlayerHas(TrinketType.TRINKET_SHINY_ROCK, true) then odds = odds * 2 end
        if mod.anyPlayerHas(FiendFolio.ITEM.ROCK.NITRO_CRYSTAL, true) then odds = odds * 2 end
		if funvar < odds then
			return {mod.FF.ShineSpit.ID, mod.FF.ShineSpit.Var, 1}
		end

	--Prevent spider entity FF variants from being replaced by striders
	elseif id == 85 and variant >= 960 and variant <= 965 then
		return {85, variant, subtype}

	--No keeper blisters
	elseif id == 86 and variant == 0 and subtype == 0 and not mod.legacyReplacementsEnabled then
		return {86, 0, 0}

	--Walking Sticky
	elseif id == mod.FF.WalkingStickySack.ID and (variant == mod.FF.WalkingStickySack.Var or variant == mod.FF.StumblingStickySack.Var) and subtype == 0 and not mod.legacyReplacementsEnabled then
		return {mod.FF.WalkingStickySack.ID, variant, 0}

    elseif id == 90 and variant == 0 and subtype == 0 and mod.replacementsEnabled then
        grng:SetSeed(seed, 0)
        if grng:RandomInt(6) == 0 then
            return {610, 0, 0}
        end

	elseif id == 208 and variant == 0 and subtype == 0 and not mod.legacyReplacementsEnabled then
		return {208, 0, 0}
	elseif id == 208 and variant == 1 and subtype == 0 and not mod.legacyReplacementsEnabled then
		return {208, 1, 0}
	elseif id == 208 and variant == 2 and subtype == 0 and not mod.legacyReplacementsEnabled then
		return {208, 2, 0}

	elseif id == 208 and variant == 960 then
		return {208, 960, subtype}
	elseif id == 208 and variant == 961 then
		return {208, 961, subtype}
	elseif id == 208 and variant == 962 then
		return {208, 962, subtype}
	elseif id == 208 and variant == 963 then
		return {208, 963, subtype}
	--mr bones replacement test run
	elseif id == 227 and variant == 0 and stageType ~= 0 and grng:RandomInt(35) == 0 and mod.replacementsEnabled then
		return {227, 667, subtype}
	elseif id == 225 then
		grng:SetSeed(seed, 0)
		if grng:RandomInt(10) == 0 then
			return {225, 66, 0}
		end

	--Fuck the thing, fuck him bad, I hate him, if you like him, fuck you
	elseif id == 240 and not mod.legacyReplacementsEnabled then
		return {240, variant, subtype}
	elseif id == 241 and not mod.legacyReplacementsEnabled then
		return {241, variant, subtype}
	elseif id == 242 and not mod.legacyReplacementsEnabled then
		return {242, variant, subtype}

	--Conjoined Spitty
	elseif id == 243 and variant == 0 then
		local level = game:GetLevel()
		if mod.replacementsEnabled and (level:GetAbsoluteStage() == LevelStage.STAGE2_1 or level:GetAbsoluteStage() == LevelStage.STAGE2_2) and level:GetStageType() == StageType.STAGETYPE_AFTERBIRTH then
			local chance = 0.5
			if mod.DrownedSpittyReplacements > 2 then
				chance = chance / (mod.DrownedSpittyReplacements - 1)
			end
			grng:SetSeed(seed, 0)
			if grng:RandomFloat() <= chance then
				mod.DrownedSpittyReplacements = mod.DrownedSpittyReplacements + 1
				return {mod.FF.DrownedConjoinedSpitty.ID, mod.FF.DrownedConjoinedSpitty.Var, 0}
			end
		end

	--Ticking spiders no longer become blisters
	elseif id == 250 and not mod.legacyReplacementsEnabled then
        return {250, variant, subtype}

	elseif id == EntityType.ENTITY_STONEY and not mod.legacyReplacementsEnabled then
        if not Isaac.GetPersistentGameData():Unlocked(Achievement.THE_GATE_IS_OPEN) then
			return {EntityType.ENTITY_FLY, 0, 0}
		end
	elseif id == mod.FFID.Guwah then
		if variant == mod.FF.Dogrock.Var and grng:RandomInt(1000) == 0 then
			return {id, variant, 8521}
		end

	elseif id == 3001 and variant == 150 then
		mod.fuegoSpawners = mod.fuegoSpawners or {}
		table.insert(mod.fuegoSpawners, gridindex)
	elseif id == 825 and variant == 1000 then
		return {999, StageAPI.E.DeleteMeEffect.V, 0}

    --Warble from morbus, commenting out since it might be borked
	--[[
    elseif id == 839 and variant == 22 then
        grng:SetSeed(seed, 0)
		local funvar = grng:RandomInt(5000)
		if funvar == 0 or (mod.anyPlayerHas(TrinketType.TRINKET_SHINY_ROCK, true) and funvar < 2) then
			return {mod.FF.GBF.ID, mod.FF.GBF.Var, 0}
        end
	]]

	elseif id == mod.FF.ToxicKnight.ID and variant == mod.FF.ToxicKnight.Var and mod.replacementsEnabled then
		grng:SetSeed(seed, 0)
		if grng:RandomInt(9) == 0 then
			return mod.ENT("FloatingToxicKnight")
		end

	elseif id == mod.FF.Fishface.ID and variant == mod.FF.Fishface.Var then
		grng:SetSeed(seed, 0)
		local funvar = grng:RandomInt(5000)
		if funvar == 0 or (mod.anyPlayerHas(TrinketType.TRINKET_SHINY_ROCK, true) and funvar < 2) then
			return mod.ENT("FishfaceShiny")
        end

    elseif id == mod.FF.CustomCards.ID and variant == mod.FF.CustomCards.Var then
        return PickupSpawnHelper(subtype, gridindex, seed,
                                 FiendFolio.Cards, FiendFolio.CardsBySoftID,
                                 PickupVariant.PICKUP_TAROTCARD)

    elseif id == mod.FF.GlassDice.ID and variant == mod.FF.GlassDice.Var then
		local choice = subtype
		if choice == 0 or (not mod:IsGlassDiceUnlocked(choice, true)) then
			choice = mod:GetRandomGlassDice(grng, true)
			grng:Next()
		end

        return { EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, FiendFolio.GlassDiceBySoftID[choice].id }
	elseif id == mod.FF.BackdropReplacer.ID and variant == mod.FF.BackdropReplacer.Var and not StageAPI.InNewStage() then
			mod.roomBackdrop = subtype
			mod.roomBackdropFrom = game:GetLevel():GetCurrentRoomDesc().ListIndex
			mod.roomBackdropFromStageAPI = StageAPI.GetCurrentRoom()
			mod.roomBackdropFromLevel = game:GetSeeds():GetStageSeed(game:GetLevel():GetStage())
			mod.SetCurrentBackdrop = game:GetLevel():GetCurrentRoomIndex()

    -- PERSISTENT ENTITIES START HERE
	elseif (not StageAPI.GetCurrentRoom()) and game:GetRoom():GetFrameCount() == -1 then
		if id == mod.FF.Immural.ID and variant == mod.FF.Immural.Var then
			table.insert(mod.persistentTable, {Type = mod.FF.Immural.ID, Variant = mod.FF.Immural.Var, SubType = mod.FF.ImmuralDead.Sub, Position =  room:GetGridPosition(gridindex)})
		elseif id == mod.FF.RamblepointRed.ID and variant == mod.FF.RamblepointRed.Var then
			mod.ramblinPoints = mod.ramblinPoints or {}
			table.insert(mod.ramblinPoints, {point = subtype, colour = "red", pos = room:GetGridPosition(gridindex)})
		elseif id == mod.FF.RamblepointBlue.ID and variant == mod.FF.RamblepointBlue.Var then
			mod.ramblinPoints = mod.ramblinPoints or {}
			table.insert(mod.ramblinPoints, {point = subtype, colour = "blue", pos = room:GetGridPosition(gridindex)})
		elseif id == mod.FF.Grater.ID and variant == mod.FF.Grater.Var then	--Graters spawn grates when they're gone
			table.insert(mod.persistentTable, {Type = mod.FF.Graterhole.ID, Variant = mod.FF.Graterhole.Var, SubType = 0, Position = room:GetGridPosition(gridindex)})
		elseif id == 1002 and variant == 0 then --Flipped Bucket replacement
			local grid = room:GetGridEntity(gridindex)
			if room:IsFirstVisit() then
				local backdrop = room:GetBackdropType()
				if backdrop == 31 or backdrop == 36 or backdrop == 45 then --Only replace on backdrops with Buckets
					grng:SetSeed(seed, 0)
					if grng:RandomFloat() <= 0.2 then
						FiendFolio.FlippedBucketGrid:Spawn(gridindex, true, false, nil) --"Replacement" is just spawning it directly
						return {1002,0,0}
					end
				end
			end
		end

		if mod:CheckIDInTableFromValues(mod.PersistentList, id, variant, subtype) then
			table.insert(mod.persistentTable, {Type = id, Variant = variant, SubType = subtype, Position = room:GetGridPosition(gridindex)})
		end
	end

	if (id == 1000 and subtype ~= 1) or (id == 1500 and subtype ~= 1) then
		local roomDesc = game:GetLevel():GetCurrentRoomDesc()
		local gridPos = room:GetGridPosition(gridindex)
		for slot = 0, 7 do
			if roomDesc.Data.Doors & StageAPI.DoorsBitwise[slot] ~= 0 then
				local doorPos = room:GetDoorSlotPosition(slot)
				local clampedPos = room:GetClampedPosition(doorPos, 20)
				local shouldBeNonReplaceable
				if clampedPos.X == doorPos.X then -- door is on bottom / top wall
					shouldBeNonReplaceable = math.abs(doorPos.X - gridPos.X) <= 40 and math.abs(doorPos.Y - gridPos.Y) <= 80
				else -- door is on left / right wall
					shouldBeNonReplaceable = math.abs(doorPos.Y - gridPos.Y) <= 40 and math.abs(doorPos.X - gridPos.X) <= 80
				end

				if shouldBeNonReplaceable then
					return {id, 0, 1}
				end
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_ROOM_ENTITY_SPAWN, mod.roomInit)
if StageAPI then
    -- stageapi only calls pre spawn entity the first time a room is populated,
    -- vs pre_room_entity_spawn that may happen many times
    StageAPI.AddCallback("FiendFolio", "PRE_SPAWN_ENTITY", 100, function(entityInfo, list, gridIndex)
        local curRoom = StageAPI.GetCurrentRoom()
        return mod:roomInit(entityInfo.Data.Type, entityInfo.Data.Variant, entityInfo.Data.SubType, gridIndex, game:GetRoom():GetSpawnSeed() + gridIndex, curRoom and curRoom.FirstLoad)
    end)

	for i, entry in pairs(mod.PersistentList) do
		StageAPI.AddEntityPersistenceData({
			Type = entry[1],
			Variant = entry[2],
			SubType = entry[3],
			RemoveOnRemove = true,
			RemoveOnDeath = false,
			UpdateSubType = true,
		})
	end
end

function mod:holyMulliganEmbryoPreSpawn(etype, evar, esub, pos, vel, spawner, seed)
	if FiendFolio.ChangeAi then
		if evar == 0 then
			if mod:entIs(spawner, EntityType.ENTITY_HIVE, 2) then --Spawned by holy mulligan
				return {etype, mod.FF.Blastulation.Angelic, 0, seed}
			end
		end
	end
end

function mod:PinSegmentPreSpawn(etype, evar, esub, pos, vel, spawner, seed)
	if mod:entIs(spawner, mod.FF.DreadPin.ID, mod.FF.DreadPin.Var, mod.FF.DreadPin.Sub) then
		return {mod.FF.DreadPin.ID, mod.FF.DreadPin.Var, mod.FF.DreadPin.Sub-1, seed} -- Setting Subtype to 114 doesn't fix the issue caused by a room having champion bosses. It has to be above or below it.
	elseif mod:entIs(spawner, mod.FF.TechnoPin.ID, mod.FF.TechnoPin.Var, mod.FF.TechnoPin.IDx+1) and spawner:ToDelirium() then -- I'm doing this to make preventing projectiles shot by Delirium from getting replaced by laser shooter projectiles while in Technopin form more reliable.
		return {EntityType.ENTITY_PIN, 0, 1, seed}
	end
end

function mod:fiendMomGaperPreSpawn(etype, evar, esub, pos, vel, spawner, seed)
	if mod:entIs(spawner, mod.FF.FiendMom.ID, mod.FF.FiendMom.Var, mod.FF.FiendMom.Sub) then
		--Fiend mom gaper replacements
		grng:SetSeed(math.max(1, seed), 0)
		local rand = grng:RandomInt(4)
		if rand == 0 then
			return mod.ENT("Woodburner", seed)	--Woodburner
		elseif rand == 1 then
			return mod.ENT("Haunted", seed)	--Haunted
		else
			return mod.ENT("Slammer", seed)	--Slammer
		end
	end
end

function mod:fiendMomPacerPreSpawn(etype, evar, esub, pos, vel, spawner, seed)
	if mod:entIs(spawner, mod.FF.FiendMom.ID, mod.FF.FiendMom.Var, mod.FF.FiendMom.Sub) then
		--Fiend mom pacer replacements
		grng:SetSeed(math.max(1, seed), 0)
		if grng:RandomInt(2) == 0 then
			return {mod.FF.Spoop.ID, mod.FF.Spoop.Var, 3, seed}
		else
			return mod.ENT("Smidgen", seed)
		end
	end
end

function mod:fiendMomHorfPreSpawn(etype, evar, esub, pos, vel, spawner, seed)
	if mod:entIs(spawner, mod.FF.FiendMom.ID, mod.FF.FiendMom.Var, mod.FF.FiendMom.Sub) then
		--Fiend mom horf replacements
		grng:SetSeed(math.max(1, seed), 0)
		if grng:RandomInt(2) == 0 then
			return mod.ENT("Spitum", seed)	--Spitum
		else
			return mod.ENT("Flare", seed)	--Mr. Flare
		end
	end
end

function mod:fiendMomPooterPreSpawn(etype, evar, esub, pos, vel, spawner, seed)
	if mod:entIs(spawner, mod.FF.FiendMom.ID, mod.FF.FiendMom.Var, mod.FF.FiendMom.Sub) then
		--Fiend mom pooter replacements
		grng:SetSeed(math.max(1, seed), 0)
		local rand = grng:RandomInt(3)
		if rand == 0 then
			return mod.ENT("SuperSpooter", seed)	--Super Spooter
		else
			return mod.ENT("Spooter", seed)	--Spooter
		end
	end
end

function mod:fiendMomClottyPreSpawn(etype, evar, esub, pos, vel, spawner, seed)
	if mod:entIs(spawner, mod.FF.FiendMom.ID, mod.FF.FiendMom.Var, mod.FF.FiendMom.Sub) then
		--Fiend mom clot replacements
		grng:SetSeed(math.max(1, seed), 0)
		local rand = grng:RandomInt(2)
		if rand == 0 then
			return mod.ENT("Dung", seed)
		else
			return mod.ENT("Benign", seed)
		end
	end
end

function mod:fiendMomMulliganPreSpawn(etype, evar, esub, pos, vel, spawner, seed)
	if mod:entIs(spawner, mod.FF.FiendMom.ID, mod.FF.FiendMom.Var, mod.FF.FiendMom.Sub) then
		--Fiend mom mulligan replacements
		grng:SetSeed(math.max(1, seed), 0)
		local rand = grng:RandomInt(2)
		if rand == 0 then
			return mod.ENT("Sackboy", seed)	--Sackboy
		else
			return mod.ENT("Pitcher", seed)	--Pitcher
		end
	end
end

function mod:fiendMomAttackFlyPreSpawn(etype, evar, esub, pos, vel, spawner, seed)
	if mod:entIs(spawner, mod.FF.FiendMom.ID, mod.FF.FiendMom.Var, mod.FF.FiendMom.Sub) then
		--Fiend mom fly replacements
		grng:SetSeed(math.max(1, seed), 0)
		local rand = grng:RandomInt(4)
		if rand == 0 then
			return mod.ENT("Beeter", seed)	--Beeter
		elseif rand == 1 then
			return mod.ENT("MilkTooth", seed)	--Milk Tooth
		else
			return mod.ENT("ShotFly", seed)	--Wimpy
		end
	end
end

function mod:fiendMomMaggotPreSpawn(etype, evar, esub, pos, vel, spawner, seed)
	if mod:entIs(spawner, mod.FF.FiendMom.ID, mod.FF.FiendMom.Var, mod.FF.FiendMom.Sub) then
		--Fiend mom maggot replacements
		grng:SetSeed(math.max(1, seed), 0)
		local rand = grng:RandomInt(3)
		if rand == 0 then
			return mod.ENT("Morsel3", seed)	--3 Morsels
		else
			return mod.ENT("Morsel2", seed)	--2 Morsels
		end
	end
end

function mod:fiendMomChargerPreSpawn(etype, evar, esub, pos, vel, spawner, seed)
	if mod:entIs(spawner, mod.FF.FiendMom.ID, mod.FF.FiendMom.Var, mod.FF.FiendMom.Sub) then
		--Fiend mom charger replacements
		return mod.ENT("RolyPoly", seed)
	end
end

function mod:fiendMomGlobinPreSpawn(etype, evar, esub, pos, vel, spawner, seed)
	if mod:entIs(spawner, mod.FF.FiendMom.ID, mod.FF.FiendMom.Var, mod.FF.FiendMom.Sub) then
		--Fiend mom globin replacements
		grng:SetSeed(math.max(1, seed), 0)
		local rand = grng:RandomInt(4)
		if rand == 0 then
			return mod.ENT("Mothman", seed) --Mothman
		elseif rand == 1 then
			return mod.ENT("Dweller", seed)	--Dweller
		else
			return mod.ENT("Nimbus", seed)	--Nimbus
		end
	end
end

function mod:fiendMomMawPreSpawn(etype, evar, esub, pos, vel, spawner, seed)
	if mod:entIs(spawner, mod.FF.FiendMom.ID, mod.FF.FiendMom.Var, mod.FF.FiendMom.Sub) then
		--Fiend mom maw replacements
		grng:SetSeed(math.max(1, seed), 0)
		local rand = grng:RandomInt(2)
		if rand == 0 then
			return mod.ENT("Gunk", seed)
		else
			return mod.ENT("Scoop", seed)
		end
	end
end

--other replacements
function mod:beehiveFistulaPreSpawn(etype, evar, esub, pos, vel, spawner, seed)
	if evar == 0 then
		if mod:entChampIs(spawner, EntityType.ENTITY_FISTULA_SMALL, 0, mod.FF.BeehiveFistulaSmall.IDx) then  -- Beehive Fistula
			return {mod.FF.Stingler.ID, mod.FF.Stingler.Var, mod.FF.Stingler.Sub, seed}
		end
	end
end

function mod:babyWidowPreSpawn(etype, evar, esub, pos, vel, spawner, seed)
	if evar == 2 then
		if mod:entChampIs(spawner, mod.FF.BabyWidowChampion.ID, mod.FF.BabyWidowChampion.Var, mod.FF.BabyWidowChampion.IDx) then
			return {mod.FF.StickySack.ID, mod.FF.StickySack.Var, 0, seed}
		end
	end
end

function mod:drownedSpittyReplacementCheck(etype, evar, esub, pos, vel, spawner, seed)
	if FiendFolio.ChangeAi and spawner then 
		if spawner:IsDead() and (spawner.Type == EntityType.ENTITY_HIVE and spawner.Variant == 1) or (spawner.Type == EntityType.ENTITY_BOOMFLY and spawner.Variant == 2) then 
			grng:SetSeed(seed, 0)
			if grng:RandomFloat() <= 0.5 then --50% chance to replace Drowned Hive/Drowned Boom Fly death spawns
				return {mod.FF.DrownedSpitty.ID, mod.FF.DrownedSpitty.Var, 0, seed}
			end
		end
	end
end

function mod:geminiPreSpawn(etype, evar, esub, pos, vel, spawner, seed)
	--This code is there for testing purposes.
	if evar == 12 then
		if mod:entChampIs(spawner, EntityType.ENTITY_GEMINI, 2, mod.FF.RedBlightedOvum.IDx) then
			return {79, 12, mod.FF.RedBlightedOvumBaby.IDx+1, seed}
		elseif mod:entChampIs(spawner, EntityType.ENTITY_GEMINI, 2, mod.FF.BlueBlightedOvum.IDx) then
			return {79, 12, mod.FF.BlueBlightedOvumBaby.IDx+1, seed}
		end
	end
end

function mod:spiderPreSpawn(etype, evar, esub, pos, vel, spawner, seed)
	if evar == 0 then
		if mod:entChampIs(spawner, EntityType.ENTITY_FISTULA_SMALL, 1, mod.FF.FuzzyTeratomaSmall.IDx) then
			return {85, 140, 0, seed}
		elseif mod:entChampIs(spawner, EntityType.ENTITY_FISTULA_SMALL, 1, mod.FF.CornyTeratomaSmall.IDx) then
			return {85, 140, 0, seed}
		elseif mod:entChampIs(spawner, mod.FF.BabyWidowChampion.ID, mod.FF.BabyWidowChampion.Var, mod.FF.BabyWidowChampion.IDx) then
			return mod.ENT("Spooter", seed)
		elseif mod:entIs(spawner, mod.FF.Sackboy.ID, mod.FF.Sackboy.Var) then
			local s = spawner
			for _, e in pairs(Isaac.FindByType(spawner.Type, spawner.Variant, spawner.SubType, false, false)) do
				if e.Index == spawner.Index then s = e end
			end
			if mod:GetEntityData(s).babyreplace then
				return mod.ENT("BabySpider", seed)
			end
		end
	end
end

function mod:LeperFleshPreSpawn(etype, evar, esub, pos, vel, spawner, seed)
	if evar == 1 and esub == 0 then
		if mod:entIs(spawner, mod.FF.Molly.ID, mod.FF.Molly.Var) and mod:GetEntityData(spawner).IsMolly then
			return {mod.FF.TomaChunk.ID, mod.FF.TomaChunk.Var, mod.FF.TomaChunk.Sub, seed}
		end
	end
end

function mod:redForsakenPreSpawn(etype, evar, esub, pos, vel, spawner, seed)
	if evar == 0 then
		if mod:entChampIs(spawner, mod.FF.RedForsaken.ID, mod.FF.RedForsaken.Var, mod.FF.RedForsaken.IDx) then
			return {mod.FF.RedBony.ID, mod.FF.RedBony.Var, 0, seed}
		end
	end
end

function mod:ghostLarryJrPreSpawn(etype, evar, esub, pos, vel, spawner, seed)
	if mod:entChampIs(spawner, EntityType.ENTITY_LARRYJR, 0, mod.FF.LarryGhost.IDx) then
		return {9, 0, 0, seed}
	end
end

-- as far as i can tell this is from back when ossularry was a grub variant and is unused now
-- scream at me if i'm incorrect
--[[function mod:ossularryOldPreSpawn(etype, evar, esub, pos, vel, spawner, seed)
	if spawner and spawner.Type == 239 and spawner.Variant == 750 then
			return {1000, 88, 0, seed}
		end
	end
end]]

function mod:FFChampionVanillaBossSpawner(etype, evar, esub, pos, vel, spawner, seed)
	if evar == mod.FF.FFChampionVanillaBossSpawner.Var then
		if esub == mod.FF.GhostLarrySpawner.Sub then
				-- Ghost Larry
				return {mod.FF.LarryGhost.ID, mod.FF.LarryGhost.Var, mod.FF.LarryGhost.IDx+1, seed}
		elseif esub == mod.FF.FuckedUpandEvilHollowSpawner.Sub then
				-- Fucked Up and Evil Hollow
				return {mod.FF.HollowFuckedUpAndEvil.ID, mod.FF.HollowFuckedUpAndEvil.Var, mod.FF.HollowFuckedUpAndEvil.IDx+1, seed}
		elseif esub == mod.FF.MucusMonstroSpawner.Sub then
				-- Mucus Monstro
				return {mod.FF.MucusMonstro.ID, mod.FF.MucusMonstro.Var, mod.FF.MucusMonstro.IDx+1, seed}
		elseif esub == mod.FF.WineHuskSpawner.Sub then
				-- Wine Husk
				return {mod.FF.WineHusk.ID, mod.FF.WineHusk.Var, mod.FF.WineHusk.IDx+1, seed}
		elseif esub == mod.FF.AlienLokiSpawner.Sub then
				-- Alien Loki
				return {mod.FF.AlienLokiChampion.ID, mod.FF.AlienLokiChampion.Var, mod.FF.AlienLokiChampion.IDx+1, seed}
		elseif esub == mod.FF.AlienLokiiSpawner.Sub then
				-- Alien Lokii
				return {mod.FF.AlienLokiiChampion.ID, mod.FF.AlienLokiiChampion.Var, mod.FF.AlienLokiiChampion.IDx+1, seed}
		elseif esub == mod.FF.BeehiveFistulaBigSpawner.Sub then
				-- Beehive Fistula (Big)
				return {mod.FF.BeehiveFistulaBig.ID, mod.FF.BeehiveFistulaBig.Var, mod.FF.BeehiveFistulaBig.IDx+1, seed}
		elseif esub == mod.FF.BeehiveFistulaMediumSpawner.Sub then
				-- Beehive Fistula (Medium)
				return {mod.FF.BeehiveFistulaMedium.ID, mod.FF.BeehiveFistulaMedium.Var, mod.FF.BeehiveFistulaMedium.IDx+1, seed}
		elseif esub == mod.FF.BeehiveFistulaSmallSpawner.Sub then
				-- Beehive Fistula (Small)
				return {mod.FF.BeehiveFistulaSmall.ID, mod.FF.BeehiveFistulaSmall.Var, mod.FF.BeehiveFistulaSmall.IDx+1, seed}
		elseif esub == mod.FF.FuzzyTeratomaBigSpawner.Sub then
				-- Fuzzy Teratoma (Big)
				return {mod.FF.FuzzyTeratomaBig.ID, mod.FF.FuzzyTeratomaBig.Var, mod.FF.FuzzyTeratomaBig.IDx+1, seed}
		elseif esub == mod.FF.FuzzyTeratomaMediumSpawner.Sub then
				-- Fuzzy Teratoma (Medium)
				return {mod.FF.FuzzyTeratomaMedium.ID, mod.FF.FuzzyTeratomaMedium.Var, mod.FF.FuzzyTeratomaMedium.IDx+1, seed}
		elseif esub == mod.FF.FuzzyTeratomaSmallSpawner.Sub then
				-- Fuzzy Teratoma (Small)
				return {mod.FF.FuzzyTeratomaSmall.ID, mod.FF.FuzzyTeratomaSmall.Var, mod.FF.FuzzyTeratomaSmall.IDx+1, seed}
		elseif esub == mod.FF.GrinchKrampusSpawner.Sub then
				-- Grinch Krampus
				return {mod.FF.GrinchKrampus.ID, mod.FF.GrinchKrampus.Var, mod.FF.GrinchKrampus.IDx+1, seed}
		elseif esub == mod.FF.KidneyOfInfamyMaskSpawner.Sub then
				-- Kidney of Infamy Mask
				return {mod.FF.YellowMaskOfInfamy.ID, mod.FF.YellowMaskOfInfamy.Var, mod.FF.YellowMaskOfInfamy.IDx+1, seed}
		elseif esub == mod.FF.KidneyOfInfamyHeartSpawner.Sub then
				-- Kidney of Infamy Heart
				return {mod.FF.KidneyOfInfamy.ID, mod.FF.KidneyOfInfamy.Var, mod.FF.KidneyOfInfamy.IDx+1, seed}
		elseif esub == mod.FF.AlbinoWidowSpawner.Sub then
				-- Albino Widow
				return {mod.FF.BabyWidowChampion.ID, mod.FF.BabyWidowChampion.Var, mod.FF.BabyWidowChampion.IDx+1, seed}
		elseif esub == mod.FF.RedForsakenSpawner.Sub then
				-- Red Forsaken
				return {mod.FF.RedForsaken.ID, mod.FF.RedForsaken.Var, mod.FF.RedForsaken.IDx+1, seed}
		elseif esub == mod.FF.RedLittleHornSpawner.Sub then
				-- Red Little Horn
				return {mod.FF.RedLittleHorn.ID, mod.FF.RedLittleHorn.Var, mod.FF.RedLittleHorn.IDx+1, seed}
		elseif esub == mod.FF.GoldenBabyPlumSpawner.Sub then
				-- Golden Baby Plum
				return {mod.FF.GoldenPlum.ID, mod.FF.GoldenPlum.Var, mod.FF.GoldenPlum.IDx+1, seed}
		elseif esub == mod.FF.RainbowRagManSpawner.Sub then
				-- Rainbow Rag Man
				return {mod.FF.RainbowRagMan.ID, mod.FF.RainbowRagMan.Var, mod.FF.RainbowRagMan.IDx+1, seed}
		elseif esub == mod.FF.RedBigHornSpawner.Sub then
				-- Red Big Horn
				return {mod.FF.RedBigHorn.ID, mod.FF.RedBigHorn.Var, mod.FF.RedBigHorn.IDx+1, seed}
		elseif esub == mod.FF.PinkRagMegaSpawner.Sub then
				--Pink Rag Mega
				return {mod.FF.PinkRagMega.ID, mod.FF.PinkRagMega.Var, mod.FF.PinkRagMega.IDx+1, seed}
		elseif esub == mod.FF.BlackSisterVisSpawner.Sub then
				-- Black Sister Vis
				return {mod.FF.BlackSisterVis.ID, mod.FF.BlackSisterVis.Var, mod.FF.BlackSisterVis.IDx+1, seed}
		elseif esub == mod.FF.RivalWidowSpawner.Sub then
				-- Rival Widows
				return {mod.FF.RivalWidowChampion.ID, mod.FF.RivalWidowChampion.Var, mod.FF.RivalWidowChampion.IDx+1, seed}
		elseif esub == mod.FF.CornyTeratomaBigSpawner.Sub then
				-- Corny Teratoma (Big)
				return {mod.FF.CornyTeratomaBig.ID, mod.FF.CornyTeratomaBig.Var, mod.FF.CornyTeratomaBig.IDx+1, seed}
		elseif esub == mod.FF.CornyTeratomaMediumSpawner.Sub then
				-- Corny Teratoma (Medium)
				return {mod.FF.CornyTeratomaMedium.ID, mod.FF.CornyTeratomaMedium.Var, mod.FF.CornyTeratomaMedium.IDx+1, seed}
		elseif esub == mod.FF.CornyTeratomaSmallSpawner.Sub then
				-- Corny Teratoma (Small)
				return {mod.FF.CornyTeratomaSmall.ID, mod.FF.CornyTeratomaSmall.Var, mod.FF.CornyTeratomaSmall.IDx+1, seed}
		elseif esub == mod.FF.MushroomGurglingSpawner.Sub then
				-- Mushroom Gurgling
				return {mod.FF.MushroomGurgling.ID, mod.FF.MushroomGurgling.Var, mod.FF.MushroomGurgling.IDx+1, seed}
		end
	end
end

function mod:portalPreSpawn(etype, evar, esub, pos, vel, spawner, seed)
    -- Oh woah dude portal spawn replacements, doing it after everything else because it's probably best this way
    if (etype > 9 and etype < 1000) then
		if spawner and spawner.Type == 306 and spawner.Variant == 0 then
			local backdrop = game:GetRoom():GetBackdropType()
			if (mod.portalreplacement[backdrop] or backdrop == 16 or backdrop == 17) and not (StageAPI and StageAPI.InNewStage()) then
				local floor = mod.portalreplacement[backdrop]
				if type(floor) == "number" then
					floor = mod.portalreplacement[floor]
				end
				grng:SetSeed(math.max(1, seed), 0)
				if backdrop == 16 or backdrop == 17 then --Random enemies in Chest and Dark Room
					floor = mod.portalreplacement[mod:GetRandomElem(mod.portalreplacementrandompool, grng)]
				end
				local ent = floor[math.random(#floor)]
				if grng:RandomInt(750) == 1 and not MOISSHITTING then --Chance for FishFromNuclearThrone
					ent = FiendFolio.ENT("FishNuclearThrone")
				end
				if ent then
					return {ent[1] or 0, ent[2] or 0, ent[3] or 0, seed}
				end
			end
		elseif spawner and spawner.Type == 306 and spawner.Variant == 1 then
			grng:SetSeed(math.max(1, seed), 0)
			if grng:RandomInt(4) == 1 then
				local spawnType = mod.lilportalreplacement[1]
				if spawner.SubType == 1 then
					spawnType = mod.lilportalreplacement[2]
				end
				if grng:RandomInt(100) == 1 and spawner.SubType == 0 then -- Full Spider
					spawnType = mod.lilportalreplacement[3]
				end
				local ent = spawnType[grng:RandomInt(#spawnType)+1]
				return {ent[1] or 0, ent[2] or 0, ent[3] or 0, seed}
			end
		end
    end
end

function mod:smallRockPreSpawn(etype, evar, esub, pos, vel, spawner, seed)
	local room = game:GetRoom()

	local isRock
	local bigRock
	local grident = room:GetGridEntityFromPos(pos)
	--Spawn check
	if grident then
		if grident.Desc.Type == GridEntityType.GRID_ROCKT then
			isRock = true
		elseif grident.Desc.Type == GridEntityType.GRID_ROCK_SS then
			bigRock = true
		end
	end
	if not isRock then
		for _, tear in pairs(Isaac.FindInRadius(pos, 100, EntityPartition.TEAR)) do
			if tear.Variant == 40 then
				if tear:IsDead() then
					local sprite = tear:GetSprite()
					local anim = sprite:GetAnimation()
					if anim == "tinted" then
						isRock = true
					elseif anim == "superspecial" or anim == "ss_broken" then
						bigRock = true
					end
				end
			end
		end
	end
	if not isRock then
		for _, proj in pairs(Isaac.FindInRadius(pos, 100, EntityPartition.BULLET)) do
			if proj.Variant == 8 then
				if proj:IsDead() then
					local sprite = proj:GetSprite()
					local anim = sprite:GetAnimation()
					if anim == "tinted" then
						isRock = true
					elseif anim == "superspecial" or anim == "ss_broken" then
						bigRock = true
					end
				end
			end
		end
	end

	--If real
	if isRock then
		local backdropType = room:GetBackdropType()
		if mod.WoodenBackdrops[backdropType] then
			return {5, 100, mod.ITEM.COLLECTIBLE.SMALL_WOOD, seed}
		elseif mod.PipeBackdrops[backdropType] or (mod.roomBackdrop and mod.roomBackdrop == 3) then
			return {5, 100, mod.ITEM.COLLECTIBLE.SMALL_PIPE, seed}
		end
	elseif bigRock then --Hehe
		local backdropType = room:GetBackdropType()
		if mod.WoodenBackdrops[backdropType] then
			return {5, 100, mod.ITEM.COLLECTIBLE.BIG_WOOD, seed}
		elseif mod.PipeBackdrops[backdropType] or (mod.roomBackdrop and mod.roomBackdrop == 3) then
			return {5, 100, mod.ITEM.COLLECTIBLE.BIG_PIPE, seed}
		else
			return {5, 100, mod.ITEM.COLLECTIBLE.BIG_ROCK, seed}
		end
	end
end

function mod:guwahGreaturesDrumstickPreSpawn(etype, evar, esub, pos, vel, spawner, seed)
	if evar == 51 then
		if GuwahGreatures then --Turn GG enemies into their FF versions
			return {mod.FF.Drumstick.ID, mod.FF.Drumstick.Var, esub, seed}
		end
	end
end

function mod:guwahGreaturesArcaneCreepPreSpawn(etype, evar, esub, pos, vel, spawner, seed)
	if evar == 51 then
		if GuwahGreatures then --Turn GG enemies into their FF versions
			return {mod.FF.ArcaneCreep.ID, mod.FF.ArcaneCreep.Var, esub, seed}
		end
	end
end

function mod:guwahGreaturesPreSpawn(etype, evar, esub, pos, vel, spawner, seed)
	if GuwahGreatures then --Turn GG enemies into their FF versions
		if evar == 1 and esub <= 1 then
			return {mod.FF.Chunky.ID, mod.FF.Chunky.Var, esub, seed}
		elseif evar == 5 then
			return {mod.FF.Potluck.ID, mod.FF.Potluck.Var, esub, seed}
		end
	end
end

-- Grid Random Replacements
local gridReplacementRNG = RNG()
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    local room = game:GetRoom()
    local currentRoom = StageAPI.GetCurrentRoom()
    if room:IsFirstVisit() and (not currentRoom or currentRoom.VisitCount == 1) then
		local EggWebs = true
		gridReplacementRNG:SetSeed(room:GetSpawnSeed(), 0) -- grid rng is broken for reward plates, so lets just do this
        for i = 0, room:GetGridSize() do
            local grid = room:GetGridEntity(i)
			if grid and not StageAPI.IsCustomGrid(i) then
				if grid.Desc.Type == GridEntityType.GRID_POOP and grid.Desc.Variant == StageAPI.PoopVariant.Golden then
					if gridReplacementRNG:RandomFloat() <= 0.02 then
						if mod:ShouldThisCustomPoopSpawn() then
							FiendFolio.PlatinumPoopGrid:Spawn(i, false, true)
						end
					end
				elseif grid.Desc.Type == GridEntityType.GRID_PRESSURE_PLATE and grid.Desc.Variant == 1 and FiendFolio.ACHIEVEMENT.GOLDEN_REWARD_PLATE:IsUnlocked() then -- reward plate
					if gridReplacementRNG:RandomFloat() <= 0.01 then
						FiendFolio.GoldenRewardPlateGrid:Spawn(i, false, true)
					end
				elseif grid.Desc.Type == GridEntityType.GRID_SPIDERWEB and EggWebs then
					EggWebs = false
					if gridReplacementRNG:RandomFloat() <= 0.025 then
						FiendFolio.EggWebGrid:Spawn(i, false, true)
					end
				elseif grid.Desc.Type == GridEntityType.GRID_POOP
				and grid.Desc.Variant == StageAPI.PoopVariant.Normal
				and not mod:IsMinesEscape()
				and mod:ShouldThisCustomPoopSpawn()
				then
					-- Make sure we don't replace non-replaceable poops!
					local currentRoomDesc = game:GetLevel():GetCurrentRoomDesc()
					local data = currentRoomDesc.Data
					local x, y = StageAPI.GridToVector(i)
					for spawnIdx = 0, data.Spawns.Size - 1 do
						local spawn = data.Spawns:Get(spawnIdx)
						if x == spawn.X and y == spawn.Y then
							local canSpawnPoopHere = true
							for entryIdx = 0, #spawn.Entries - 1 do
								local entry = spawn.Entries:Get(entryIdx)
								if entry.Type == StbGridType.POOP and entry.Variant == GridPoopVariant.NORMAL then
									if entry.Subtype == StbPoopSubType.NON_REPLACEABLE then
										canSpawnPoopHere = false
									else
										canSpawnPoopHere = true
									end
								end
							end

							if canSpawnPoopHere then
								local harmingPoopWeight = 1/200
								if game.Difficulty % 2 == 1 then
									harmingPoopWeight = 1/100
								end
								if gridReplacementRNG:RandomFloat() <= harmingPoopWeight and Isaac.GetPersistentGameData():Unlocked(Achievement.CHARMING_POOP) then
									FiendFolio.HarmingPoopGrid:Spawn(i, false, true)
								end
							end

							break
						end
					end
				end
			end
        end
    end
end)

-- CARDS!!!

-- Ported to "weight" xml attribute
--[[
mod.StupidRareCards = {
	[mod.ITEM.CARD.DOWNLOAD_FAILURE] = true,
	[mod.ITEM.CARD.BROKEN_DISC] = true,
	[mod.ITEM.CARD.BLASPHEMY] = true,
}
]]

-- Ported to "hidden" xml attribute
--[[
mod.NoNaturalSpawnCards = {
	[mod.ITEM.CARD.REVERSE_KING_OF_CLUBS] = true,
	[mod.ITEM.CARD.SMALL_CONTRABAND] = true,
	[mod.ITEM.CARD.COOL_PHOTO] = true,
    [mod.ITEM.CARD.STORAGE_BATTERY_3] = true,
    [mod.ITEM.CARD.CORRODED_BATTERY_0] = true,
    [mod.ITEM.CARD.CORRODED_BATTERY_1] = true,
    [mod.ITEM.CARD.CORRODED_BATTERY_2] = true,
    [mod.ITEM.CARD.CORRODED_BATTERY_3] = true,
	[mod.ITEM.CARD.HORSE_PUSHPOP] = true,
	[mod.ITEM.CARD.STUD_2] = true,
	[mod.ITEM.CARD.STUD_3] = true,
	[mod.ITEM.CARD.STUD_4] = true,
	[mod.ITEM.CARD.STUD_5] = true,
	[mod.ITEM.CARD.STUD_6] = true,
	[mod.ITEM.CARD.DESTINY_BOARD] = true,

	--OJ Cards
	[mod.ITEM.CARD.OJ_BUSINESS] = true,
	[mod.ITEM.CARD.OJ_STRONGER] = true,
	[mod.ITEM.CARD.OJ_PRESENT] = true,

	-- disabled due to unfinishedness
    [mod.ITEM.CARD.TRAINER_CARD] = true,
    [mod.ITEM.CARD.RESCUE_CAT] = true,
}
]]

-- xml weight can't make "special" cards spawn more often (since it only affects the weight within that individual "pool") so we keep this
mod.BumpedOddsCards = {
    [mod.ITEM.CARD.PLUS_3_FIREBALLS] 	= 20,		-- n = how many rolls are allowed to get this card
    [mod.ITEM.CARD.IMPLOSION] 			= 20,		-- The function will roll as many times as the greatest n
    [mod.ITEM.CARD.CALLING_CARD] 		= 20,
    [mod.ITEM.CARD.GROTTO_BEAST] 		= 20,		-- Take 20 to be an average boost
    [mod.ITEM.CARD.PLAGUE_OF_DECAY] 	= 20,		-- Greater than 20 is a large boost
    [mod.ITEM.CARD.DEFUSE] 				= 20,		-- Less than 20 is a small boost
    [mod.ITEM.CARD.POT_OF_GREED] 		= 20,
    [mod.ITEM.CARD.SKIP_CARD] 			= 20,
    [mod.ITEM.CARD.CARDJITSU_SOCCER] 	= 20,
    [mod.ITEM.CARD.CARDJITSU_FLOORING_UPGRADE] = 20,
    [mod.ITEM.CARD.CARDJITSU_AC_3000] 	= 20,
    [mod.ITEM.CARD.GIFT_CARD] 			= 20,

    -- Reloaded
    [mod.ITEM.CARD.SORRY] 				= 7,
    [mod.ITEM.CARD.DARK_HOLE] 			= 15,
    [mod.ITEM.CARD.SEAL_OF_ORICHALCOS] 	= 15,
  	[mod.ITEM.CARD.MISPRINTED_GISH]		= 7,
    [mod.ITEM.CARD.NEKO_NYAN_QUIZ_CARD]	= 15,
    -- [mod.ITEM.CARD.RESCUE_CAT]			= 15,
    [mod.ITEM.CARD.EYE_OF_TRUTH]		= 15,
    [mod.ITEM.CARD.HAPPY_SQUIRREL]		= 15,
    [mod.ITEM.CARD.FRIENDLY_FIRE]		= 20,
    [mod.ITEM.CARD.REDACTED_TRIANGLE]	= 20,
    [mod.ITEM.CARD.THE_INVISIBLE_MOON]	= 10,
	[mod.ITEM.CARD.NEIGHBOURS_FROM_HELL]= 15,
	[mod.ITEM.CARD.CREATIVE_AI]			= 20,
	[mod.ITEM.CARD.CORRUPTION]			= 7,

    -- Card Sets, these should be boosted less than normal, relative to how many cards are in the set
    -- Aim for a total of ~50 (2.5 base cards worth of rolls collectively)

    -- Energy Cards
    [FiendFolio.ITEM.CARD.ENERGY_GRASS] 	= 5,
    [FiendFolio.ITEM.CARD.ENERGY_FIRE] 		= 5,
    [FiendFolio.ITEM.CARD.ENERGY_WATER] 	= 5,
    [FiendFolio.ITEM.CARD.ENERGY_LIGHTNING] = 5,
    [FiendFolio.ITEM.CARD.ENERGY_FIGHTING] 	= 5,
    [FiendFolio.ITEM.CARD.ENERGY_PSYCHIC] 	= 5,
    [FiendFolio.ITEM.CARD.ENERGY_COLORLESS] = 5,
    [FiendFolio.ITEM.CARD.ENERGY_DARKNESS] 	= 5,
    [FiendFolio.ITEM.CARD.ENERGY_METAL] 	= 5,
    [FiendFolio.ITEM.CARD.ENERGY_DRAGON] 	= 5,
    [FiendFolio.ITEM.CARD.ENERGY_FAIRY] 	= 5,

    -- Aberrant Cards
    [FiendFolio.ITEM.CARD.ABERRANT_LOVERS]	= 8,
    [FiendFolio.ITEM.CARD.ABERRANT_DEATH]	= 8,
    [FiendFolio.ITEM.CARD.ABERRANT_TOWER]	= 8,
    [FiendFolio.ITEM.CARD.ABERRANT_STARS]	= 8,
    [FiendFolio.ITEM.CARD.ABERRANT_MOON]	= 8,
    [FiendFolio.ITEM.CARD.ABERRANT_SUN]		= 8,

    -- Minor Arcana
	[FiendFolio.ITEM.CARD.ACE_OF_WANDS]			= 2,
	[FiendFolio.ITEM.CARD.ACE_OF_PENTACLES]		= 2,
	[FiendFolio.ITEM.CARD.ACE_OF_SWORDS]		= 2,
	[FiendFolio.ITEM.CARD.ACE_OF_CUPS]			= 2,
	[FiendFolio.ITEM.CARD.TWO_OF_PENTACLES] 	= 4,
	[FiendFolio.ITEM.CARD.TWO_OF_SWORDS] 		= 4,
	[FiendFolio.ITEM.CARD.TWO_OF_WANDS] 		= 4,
	[FiendFolio.ITEM.CARD.TWO_OF_CUPS] 			= 4,
	[FiendFolio.ITEM.CARD.THREE_OF_CUPS]		= 5,
	[FiendFolio.ITEM.CARD.THREE_OF_PENTACLES]	= 5,
	[FiendFolio.ITEM.CARD.THREE_OF_SWORDS]		= 5,
	[FiendFolio.ITEM.CARD.THREE_OF_WANDS]		= 5,
	[FiendFolio.ITEM.CARD.KING_OF_CUPS]			= 3,
	[FiendFolio.ITEM.CARD.KING_OF_PENTACLES]	= 3,
	[FiendFolio.ITEM.CARD.KING_OF_WANDS]		= 3,
	[FiendFolio.ITEM.CARD.KING_OF_SWORDS]		= 3,
	-- FiendFolio.ITEM.CARD.REVERSE_KING_OF_PENTACLES does not need bumped odds - it is sufficiently rare by default.
	[FiendFolio.ITEM.CARD.MISPRINTED_KING_OF_PENTACLES] = 3,  -- Doesn't need to be any rarer than King of Pentacles
}

local maxBumpAttempts = 0
for _, value in pairs(mod.BumpedOddsCards) do if value > maxBumpAttempts then maxBumpAttempts = value end end

mod.MinorArcanaKingCards = {
	[FiendFolio.ITEM.CARD.KING_OF_CUPS] = true,
	[FiendFolio.ITEM.CARD.KING_OF_PENTACLES] = true,
	[FiendFolio.ITEM.CARD.REVERSE_KING_OF_PENTACLES] = true,
	[FiendFolio.ITEM.CARD.MISPRINTED_KING_OF_PENTACLES] = true,
	[FiendFolio.ITEM.CARD.KING_OF_WANDS] = true,
	[FiendFolio.ITEM.CARD.KING_OF_SWORDS] = true,
}

mod.PlayingKingCards = {
	[FiendFolio.ITEM.CARD.KING_OF_DIAMONDS] = true,
	[FiendFolio.ITEM.CARD.KING_OF_SPADES] = true,
	[FiendFolio.ITEM.CARD.KING_OF_CLUBS] = true,
	[FiendFolio.ITEM.CARD.REVERSE_KING_OF_CLUBS] = true,
}

mod.MinorArcanaQueenCards = {}

mod.PlayingQueenCards = {
	[FiendFolio.ITEM.CARD.QUEEN_OF_CLUBS] = true,
	[FiendFolio.ITEM.CARD.QUEEN_OF_DIAMONDS] = true,
	[FiendFolio.ITEM.CARD.QUEEN_OF_SPADES] = true,
}

--These don't exist
mod.MinorArcanaJackCards = {}

mod.PlayingJackCards = {
	[FiendFolio.ITEM.CARD.JACK_OF_CLUBS] = true,
	[FiendFolio.ITEM.CARD.MISPRINTED_JACK_OF_CLUBS] = true,
	[FiendFolio.ITEM.CARD.JACK_OF_DIAMONDS] = true,
	[FiendFolio.ITEM.CARD.JACK_OF_SPADES] = true,
	[FiendFolio.ITEM.CARD.JACK_OF_HEARTS] = true,
}

mod.MinorArcanaTwoCards = {
	[FiendFolio.ITEM.CARD.TWO_OF_PENTACLES] = true,
	[FiendFolio.ITEM.CARD.TWO_OF_SWORDS] = true,
	[FiendFolio.ITEM.CARD.TWO_OF_WANDS] = true,
	[FiendFolio.ITEM.CARD.TWO_OF_CUPS] = true,
}

mod.MinorArcanaThreeCards = {
	[FiendFolio.ITEM.CARD.THREE_OF_CUPS] = true,
	[FiendFolio.ITEM.CARD.THREE_OF_PENTACLES] = true,
	[FiendFolio.ITEM.CARD.THREE_OF_SWORDS] = true,
	[FiendFolio.ITEM.CARD.THREE_OF_WANDS] = true,
}
mod.PlayingThreeCards = {
	[FiendFolio.ITEM.CARD.THREE_OF_CLUBS] = true,
	[FiendFolio.ITEM.CARD.THREE_OF_SPADES] = true,
	[FiendFolio.ITEM.CARD.THREE_OF_DIAMONDS] = true,
	[FiendFolio.ITEM.CARD.MISPRINTED_THREE_OF_DIAMONDS] = true,
	[FiendFolio.ITEM.CARD.THREE_OF_HEARTS] = true,
}

function FiendFolio.NoCardNaturalSpawn(card)
	--[[if not FiendFolio.CardsEnabled and mod.CardsByID[card] then
		return true
	end]]

	if FiendFolio.CardConfig.ArcanaKingCardsDisabled and mod.MinorArcanaKingCards[card] then
		return true
	end

	if FiendFolio.CardConfig.PlayingKingCardsDisabled and mod.PlayingKingCards[card] then
		return true
	end

	if FiendFolio.CardConfig.ArcanaQueenCardsDisabled and mod.MinorArcanaQueenCards[card] then
		return true
	end

	if FiendFolio.CardConfig.PlayingQueenCardsDisabled and mod.PlayingQueenCards[card] then
		return true
	end

	if FiendFolio.CardConfig.ArcanaJackCardsDisabled and mod.MinorArcanaJackCards[card] then
		return true
	end

	if FiendFolio.CardConfig.PlayingJackCardsDisabled and mod.PlayingJackCards[card] then
		return true
	end

	if FiendFolio.CardConfig.ArcanaTwoCardsDisabled and mod.MinorArcanaTwoCards[card] then
		return true
	end

	if FiendFolio.CardConfig.ArcanaThreeCardsDisabled and mod.MinorArcanaThreeCards[card] then
		return true
	end

	if FiendFolio.CardConfig.PlayingThreeCardsDisabled and mod.PlayingThreeCards[card] then
		return true
	end

	if card == mod.ITEM.CARD.SKIP_CARD and game.Challenge > 0 then
		return true
	end

	if card == mod.ITEM.CARD.TAINTED_TREASURE_DISC and not TaintedCollectibles then
		return true
	end

	return false
end

-- Make cards automatically respect the above settings
for _, card in pairs(FiendFolio.ITEM.CARD) do
	local conf = Isaac.GetItemConfig():GetCard(card)
	if conf then
		conf:SetAvailabilityCondition(function()
			return not FiendFolio.NoCardNaturalSpawn(card)
		end)
	end
end

local skipGetCard
local getCardRNG
function mod:CardReplacement(_, card, canSuit, canRune, onlyRune)
	if not getCardRNG then
		mod.savedata.cardRngSeed = mod.savedata.cardRngSeed or game:GetSeeds():GetStartSeed()
		getCardRNG = RNG()
		getCardRNG:SetSeed(mod.savedata.cardRngSeed, 35)
	end

	if not skipGetCard then
		local returnValue = card
		local itempool = game:GetItemPool()
		local itemConfig = Isaac.GetItemConfig()
		skipGetCard = true

		local forceReturn = false

		if canRune then
			local ANSUS_CHANCE = 250000
			if getCardRNG:RandomInt(ANSUS_CHANCE) == 1 then
				if Isaac.GetPersistentGameData():Unlocked(Achievement.RUNE_OF_ANSUZ) then
					returnValue = mod.ITEM.CARD.RUNE_ANSUS
					goto getCardEnd
				end
			end
		end
		if canRune and not onlyRune then -- Objects allowed to spawn
			local persistentData = mod.GetPersistentPlayerData(Isaac.GetPlayer())
			if persistentData.puzzleFortunes then -- Increase puzzle piece odds if one has already been used
				local pieceSpawn
				local spawnChance = 0
				local jigsawBoxMultiplier = mod.GetGlobalTrinketMultiplier(mod.ITEM.TRINKET.JIGSAW_PUZZLE_BOX)
				persistentData.puzzleSpawns = persistentData.puzzleSpawns or {}

				if persistentData.puzzleFortunes[2] and not persistentData.puzzleSpawns[2] then
					pieceSpawn = 2
					spawnChance = 0.85 + 0.05 * jigsawBoxMultiplier
				elseif persistentData.puzzleFortunes[1] and not persistentData.puzzleSpawns[1] then
					pieceSpawn = 1
					spawnChance = 0.40 + 0.20 * jigsawBoxMultiplier
				end

				if getCardRNG:RandomFloat() < spawnChance then
					persistentData.puzzleSpawns[pieceSpawn] = true
					returnValue = mod.ITEM.CARD.PUZZLE_PIECE
					goto getCardEnd
				end
			end

			if itemConfig:GetCard(card).CardType ~= ItemConfig.CARDTYPE_SPECIAL_OBJECT then -- Increase drop rates of Object type cards
				for i = 1, 10 do
					local new = itempool:GetCard(getCardRNG:Next(), canSuit, canRune, onlyRune)
					if itemConfig:GetCard(new).CardType == ItemConfig.CARDTYPE_SPECIAL_OBJECT then
						returnValue = new
						goto getCardEnd
					end
				end
			end
		elseif itemConfig:GetCard(card).CardType == ItemConfig.CARDTYPE_SPECIAL_OBJECT then -- Failsafe, this should NOT be an object
			-- This is a potential infinite loop, don't do this shit
			-- However

			repeat -- just in case, realistically this will rarely ever run more than once
				card = itempool:GetCard(getCardRNG:Next(), canSuit, canRune, onlyRune)
			until itemConfig:GetCard(card).CardType ~= ItemConfig.CARDTYPE_SPECIAL_OBJECT

			returnValue = card
			forceReturn = true
		end

		if not mod.BumpedOddsCards[card] and not onlyRune then
			local bumpModifier = 1
			local baseType = itemConfig:GetCard(card).CardType

			if baseType == ItemConfig.CARDTYPE_SUIT or baseType == ItemConfig.CARDTYPE_TAROT_REVERSE then
				bumpModifier = bumpModifier / 2 -- These are already rarer than average, leave them mostly alone
			elseif baseType == ItemConfig.CARDTYPE_SPECIAL then
				bumpModifier = 0 -- Leave them alone they have it hard enough
			elseif baseType == ItemConfig.CARDTYPE_RUNE then
				bumpModifier = bumpModifier / 1.5 -- Runes can have a little leeway, as a treat
			end

			for i = 1, maxBumpAttempts * bumpModifier do
				local new = itempool:GetCard(getCardRNG:Next(), canSuit, canRune, onlyRune)
				if mod.BumpedOddsCards[new] and i <= mod.BumpedOddsCards[new] * bumpModifier then
					returnValue = new
					goto getCardEnd
				end
			end
		end

		if mod:GetCardSuitNumber(card, true, true) then -- Balatro Joker logic
			local _, num = mod:GetCardSuitNumber(card, true, true)
			local results = mod:SurveyJokerStatus()
			if results then
				local roll = mod:weightedRNG(results, getCardRNG)
				if mod.CARDSUITS[roll] and mod.CARDSUITS[roll][num] then
					returnValue = mod.CARDSUITS[roll][num]
					if mod.CARDSUITS[roll][num .. "M"] then
						if getCardRNG:RandomInt(4) == 0 then
							returnValue = mod.CARDSUITS[roll][num .. "M"]
						end
					end
					goto getCardEnd
				end
			end
		end

		::getCardEnd::
		skipGetCard = false
		mod.savedata.cardRngSeed = getCardRNG:GetSeed()
		if returnValue == card and not forceReturn then
			-- We didn't change the spawned card. Return nil to avoid stepping the toes of other mods trying to do card replacements.
			return nil
		end

		return returnValue
	end
end
mod:AddCallback(ModCallbacks.MC_GET_CARD, mod.CardReplacement)

-- Booster Pack doesn't trigger MC_GET_CARD, so we have to handle that seperately (primarily for boosted-rate special cards)

-- The last frame we detected a player obtaining a new copy of Booster Pack.
local boosterPackDetectedAt = nil

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
	boosterPackDetectedAt = nil
end)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_ADD_COLLECTIBLE, math.huge, function(_, _, _, firstTime)
	if firstTime then
		boosterPackDetectedAt = game:GetFrameCount()
	end
end, CollectibleType.COLLECTIBLE_BOOSTER_PACK)

mod:AddPriorityCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, -math.huge, function(_, _, _, firstTime)
	if firstTime then
		boosterPackDetectedAt = nil
	end
end, CollectibleType.COLLECTIBLE_BOOSTER_PACK)

function mod:CheckBoosterPackSpawn(id, var, subt, pos, vel, spawner, seed)
	if boosterPackDetectedAt and boosterPackDetectedAt == game:GetFrameCount() then
		local replacement = mod:CardReplacement(nil, subt, true, false, false)
		if replacement then
			return {id, var, replacement, seed}
		end
	end
end

--D1 Detection (For things like storage batteries)
mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, function(_, itemID, rng, player, useflags, activeslot)
	mod.PlayerJustUsedD1 = true
end, CollectibleType.COLLECTIBLE_D1)
mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, itemID, rng, player, useflags, activeslot)
	mod.PlayerJustUsedD1 = false
end, CollectibleType.COLLECTIBLE_D1)
--Effect that instantly removes itself
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, e)
	if e.SubType == 999 then
		e:Remove()
	end
end, 0)
