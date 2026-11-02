local mod = FiendFolio
local game = Game()
local nilvector = Vector.Zero

mod.BombFlagSource = {
	BOMB = 0,
	ROCKET = 1,
	DR_FETUS = 2,
	EPIC_FETUS = 3,
	BOBS_ROTTEN_HEAD = 4,
	KAMIKAZE = 5,
	BBF = 6,
	BOBS_BRAIN = 7,
	LOCUST_OF_WAR = 8,
	ANARCHISTS_EASY_BAKE = 9,
	CLUB_EPIC_FETUS = 10,
	MINESWEEPER = 11,
	WRATHFUL_PLUSHIE = 12,
	BOMB_HEART = 13,
	BOMB_HEART_CLOT = 14,
}

function mod:PollBombFlags(entity, player, bombflagSource)
	Isaac.RunCallbackWithParam(FiendFolio.CALLBACK.FF_POLL_BOMBFLAGS, bombflagSource, entity, player, bombflagSource)
end

local sourceOverride, playerOverride, bombflagSourceOverride
function mod:ExplodeAsBombflagSource(entity, player, bombflagSource, misc)
	local misc = misc or {}
	sourceOverride, playerOverride, bombflagSourceOverride = entity, player, bombflagSource
	game:BombExplosionEffects(
		misc.Position or entity.Position,
		misc.Damage or 100,
		misc.TearFlags or player:GetBombFlags(),
		misc.Color,
		misc.Source or entity,
		misc.RadiusMult,
		misc.LineCheck,
		misc.DamageSource,
		misc.DamageFlags
	)
	sourceOverride, playerOverride, bombflagSourceOverride = nil, nil, nil
end

function mod:WipeBombFlags(entity)
	TearFlagsLib.WipeTearFlags(entity)
end

function mod:FFExplode(entity, player, bombflagSource, misc)
	mod:PollBombFlags(entity, player, bombflagSource)
	mod:ExplodeAsBombflagSource(entity, player, bombflagSource, misc)
	mod:WipeBombFlags(entity)
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_USE_BOMB, function (_, player, bomb)
	local data = mod:GetEntityData(bomb)
	if not data.HasPolledBombFlags then
		Isaac.RunCallbackWithParam(FiendFolio.CALLBACK.FF_POLL_BOMBFLAGS, mod.BombFlagSource.BOMB, bomb, player, mod.BombFlagSource.BOMB)
		data.HasPolledBombFlags = true
	end
	Isaac.RunCallback(FiendFolio.CALLBACK.FF_SET_BOMB_VARIANT, bomb, player, mod.BombFlagSource.BOMB)
end)

mod:AddCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, function(_, entity, player)
	local data = mod:GetEntityData(entity)
	if not data.HasPolledBombFlags then
		Isaac.RunCallbackWithParam(FiendFolio.CALLBACK.FF_POLL_BOMBFLAGS, mod.BombFlagSource.DR_FETUS, entity, player, mod.BombFlagSource.DR_FETUS)
		data.HasPolledBombFlags = true
	end
	Isaac.RunCallback(FiendFolio.CALLBACK.FF_SET_BOMB_VARIANT, entity:ToBomb(), player, mod.BombFlagSource.DR_FETUS)
end, TearFlagsLib.WeaponFlag.DR_FETUS)

mod:AddCallback(ModCallbacks.MC_POST_BOMB_INIT, function(_, bomb)
	if bomb.Variant ~= BombVariant.BOMB_THROWABLE and bomb.SpawnerEntity and bomb.SpawnerEntity.Type == EntityType.ENTITY_PLAYER then
		-- imma just assume this is anarchist cookbook and mr boom and number two and the like
		-- they don't update on frame 0 so you get this instead
		mod.scheduleForUpdate(function()
			-- failsafe because this has been an issue before
			if not (bomb:Exists() and bomb.SpawnerEntity and bomb.SpawnerEntity.Type == EntityType.ENTITY_PLAYER) then
				return
			end

			local data = mod:GetEntityData(bomb)
			if not data.HasPolledBombFlags then
				local sourceFlag = (bomb.IsFetus and mod.BombFlagSource.DR_FETUS) or mod.BombFlagSource.BOMB
				Isaac.RunCallbackWithParam(FiendFolio.CALLBACK.FF_POLL_BOMBFLAGS, sourceFlag, bomb, bomb.SpawnerEntity:ToPlayer(), sourceFlag)
				data.HasPolledBombFlags = true
			end
		end, 1)
	end
end)

local isDoctorsRemote = nil
mod:AddCallback(ModCallbacks.MC_PRE_EFFECT_UPDATE, function(_, target)
	isDoctorsRemote = mod:GetEntityData(target).FFIsDoctorsRemote
end, EffectVariant.TARGET)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function()
	isDoctorsRemote = nil
end, EffectVariant.TARGET)

mod:AddCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, function(_, entity, player)
	local data = mod:GetEntityData(entity)
	if not data.HasPolledBombFlags then
		local sourceFlag = (isDoctorsRemote and mod.BombFlagSource.ROCKET) or mod.BombFlagSource.EPIC_FETUS
		data.FFBombSourceFlag = sourceFlag
		Isaac.RunCallbackWithParam(FiendFolio.CALLBACK.FF_POLL_BOMBFLAGS, sourceFlag, entity, player, sourceFlag)
		data.HasPolledBombFlags = true
	end
end, TearFlagsLib.WeaponFlag.EPIC_FETUS)

mod:AddCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, function(_, entity, player)
	local data = mod:GetEntityData(entity)
	if not data.HasPolledBombFlags then
		Isaac.RunCallbackWithParam(FiendFolio.CALLBACK.FF_POLL_BOMBFLAGS, mod.BombFlagSource.CLUB_EPIC_FETUS, entity, player, mod.BombFlagSource.CLUB_EPIC_FETUS)
		data.HasPolledBombFlags = true
	end
end, TearFlagsLib.WeaponFlag.CLUB_EPIC_FETUS)

mod:AddCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, function(_, entity, player)
	local data = mod:GetEntityData(entity)
	if not data.HasPolledBombFlags then
		Isaac.RunCallbackWithParam(FiendFolio.CALLBACK.FF_POLL_BOMBFLAGS, mod.BombFlagSource.BOBS_ROTTEN_HEAD, entity, player, mod.BombFlagSource.BOBS_ROTTEN_HEAD)
		data.HasPolledBombFlags = true
	end
end, TearFlagsLib.WeaponFlag.BOBS_ROTTEN_HEAD)

local testingForKamikaze = nil
mod:AddPriorityCallback(ModCallbacks.MC_PRE_USE_ITEM, math.huge, function(_,_,_, player)
	testingForKamikaze = true
end, CollectibleType.COLLECTIBLE_KAMIKAZE)

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function()
	testingForKamikaze = nil
end, CollectibleType.COLLECTIBLE_KAMIKAZE)

local delayedBombFlagDamageFuncs = {}
local delayedBombFlagEffectFuncs = {}
local delayedBombFlagHasCross = {}
local delayedRollBombFlags = {}
mod:AddCallback(ModCallbacks.MC_POST_BOMB_DAMAGE, function (_, pos, dmg, radius, lineCheck, src, tearflags, dmgflags, dmgSrc)
	local src = sourceOverride or src
	if src == nil then return end
	
	local player, sourceFlag
	local ptrhash = GetPtrHash(src)
	if sourceOverride then
		player = playerOverride
		sourceFlag = bombflagSourceOverride
	elseif src.Type == EntityType.ENTITY_BOMB then
		player = src.SpawnerEntity and src.SpawnerEntity:ToPlayer()
		sourceFlag = (src:ToBomb().IsFetus and mod.BombFlagSource.DR_FETUS) or mod.BombFlagSource.BOMB
	elseif src.Type == EntityType.ENTITY_EFFECT and src.Variant == EffectVariant.ROCKET then
		player = src.SpawnerEntity and src.SpawnerEntity:ToPlayer()
		sourceFlag = mod:GetEntityData(src).FFBombSourceFlag
	elseif src.Type == EntityType.ENTITY_EFFECT and src.Variant == EffectVariant.SMALL_ROCKET then
		player = src.SpawnerEntity and src.SpawnerEntity:ToPlayer()
		sourceFlag = mod.BombFlagSource.CLUB_EPIC_FETUS
	elseif src.Type == EntityType.ENTITY_TEAR and src.Variant == TearVariant.BOBS_HEAD then
		player = src.SpawnerEntity and src.SpawnerEntity:ToPlayer()
		sourceFlag = mod.BombFlagSource.BOBS_ROTTEN_HEAD
	elseif testingForKamikaze and src.Type == EntityType.ENTITY_PLAYER then
		player = src:ToPlayer()
		sourceFlag = mod.BombFlagSource.KAMIKAZE
		delayedRollBombFlags[ptrhash] = {Source = src, Flag = sourceFlag, Player = src:ToPlayer()}
	elseif src.Type == EntityType.ENTITY_FAMILIAR and src.Variant == FamiliarVariant.BBF then
		local familiar = src:ToFamiliar()
		player = familiar and familiar.Player
		sourceFlag = mod.BombFlagSource.BBF
		delayedRollBombFlags[ptrhash] = {Source = src, Flag = sourceFlag, Player = src:ToPlayer()}
	elseif src.Type == EntityType.ENTITY_FAMILIAR and src.Variant == FamiliarVariant.BOBS_BRAIN then
		local familiar = src:ToFamiliar()
		player = familiar and familiar.Player
		sourceFlag = mod.BombFlagSource.BOBS_BRAIN
		delayedRollBombFlags[ptrhash] = {Source = src, Flag = sourceFlag, Player = src:ToPlayer()}
	elseif src.Type == EntityType.ENTITY_FAMILIAR and src.Variant == FamiliarVariant.BLUE_FLY and src.SubType == 1 then
		local familiar = src:ToFamiliar()
		player = familiar and familiar.Player
		sourceFlag = mod.BombFlagSource.LOCUST_OF_WAR
		delayedRollBombFlags[ptrhash] = {Source = src, Flag = sourceFlag, Player = src:ToPlayer()}
	end
	sourceFlag = mod:GetEntityData(src).ffOverrideBombFlagSource or sourceFlag
	delayedBombFlagHasCross[ptrhash] = delayedBombFlagHasCross[ptrhash] or tearflags & TearFlags.TEAR_CROSS_BOMB == TearFlags.TEAR_CROSS_BOMB
	
	if sourceFlag then
		local posCopy = Vector(pos.X, pos.Y) -- becomes junk data otherwise
		local tearflagsCopy = tearflags | TearFlags.TEAR_NORMAL -- becomes junk data otherwise
		for _, callbackData in pairs(Isaac.GetCallbacks(FiendFolio.CALLBACK.FF_POST_BOMBFLAG_DAMAGE)) do
			if not callbackData.Param or TearFlagsLib.HasTearFlags(src, callbackData.Param) then
				local params = TearFlagsLib.GetTearFlagParams(src, callbackData.Param)
				table.insert(delayedBombFlagDamageFuncs, function()
					callbackData.Function(callbackData.Mod, posCopy, dmg, radius, lineCheck, src, tearflagsCopy | ((delayedBombFlagHasCross[ptrhash] and TearFlags.TEAR_CROSS_BOMB) or TearFlags.TEAR_NORMAL), dmgflags, dmgSrc, player, sourceFlag, params)
				end)
			end
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_BOMB_TEARFLAG_EFFECTS, function (_, pos, radius, tearflags, src, radiusMult)
	local src = sourceOverride or src
	if src == nil then return end
	
	local player, sourceFlag, isDelayed
	local ptrhash = GetPtrHash(src)
	if sourceOverride then
		player = playerOverride
		sourceFlag = bombflagSourceOverride
	elseif src.Type == EntityType.ENTITY_BOMB then
		player = src.SpawnerEntity and src.SpawnerEntity:ToPlayer()
		sourceFlag = (src:ToBomb().IsFetus and mod.BombFlagSource.DR_FETUS) or mod.BombFlagSource.BOMB
	elseif src.Type == EntityType.ENTITY_EFFECT and src.Variant == EffectVariant.ROCKET then
		player = src.SpawnerEntity and src.SpawnerEntity:ToPlayer()
		sourceFlag = mod:GetEntityData(src).FFBombSourceFlag
	elseif src.Type == EntityType.ENTITY_EFFECT and src.Variant == EffectVariant.SMALL_ROCKET then
		player = src.SpawnerEntity and src.SpawnerEntity:ToPlayer()
		sourceFlag = mod.BombFlagSource.CLUB_EPIC_FETUS
	elseif src.Type == EntityType.ENTITY_TEAR and src.Variant == TearVariant.BOBS_HEAD then
		player = src.SpawnerEntity and src.SpawnerEntity:ToPlayer()
		sourceFlag = mod.BombFlagSource.BOBS_ROTTEN_HEAD
	elseif testingForKamikaze and src.Type == EntityType.ENTITY_PLAYER then
		player = src:ToPlayer()
		sourceFlag = mod.BombFlagSource.KAMIKAZE
		delayedRollBombFlags[ptrhash] = {Source = src, Flag = sourceFlag, Player = src:ToPlayer()}
		isDelayed = true
	elseif src.Type == EntityType.ENTITY_FAMILIAR and src.Variant == FamiliarVariant.BBF then
		local familiar = src:ToFamiliar()
		player = familiar and familiar.Player
		sourceFlag = mod.BombFlagSource.BBF
		delayedRollBombFlags[ptrhash] = {Source = src, Flag = sourceFlag, Player = src:ToFamiliar().Player}
		isDelayed = true
	elseif src.Type == EntityType.ENTITY_FAMILIAR and src.Variant == FamiliarVariant.BOBS_BRAIN then
		local familiar = src:ToFamiliar()
		player = familiar and familiar.Player
		sourceFlag = mod.BombFlagSource.BOBS_BRAIN
		delayedRollBombFlags[ptrhash] = {Source = src, Flag = sourceFlag, Player = src:ToFamiliar().Player}
		isDelayed = true
	elseif src.Type == EntityType.ENTITY_FAMILIAR and src.Variant == FamiliarVariant.BLUE_FLY and src.SubType == 1 then
		local familiar = src:ToFamiliar()
		player = familiar and familiar.Player
		sourceFlag = mod.BombFlagSource.LOCUST_OF_WAR
		delayedRollBombFlags[ptrhash] = {Source = src, Flag = sourceFlag, Player = src:ToFamiliar().Player}
		isDelayed = true
	end
	sourceFlag = mod:GetEntityData(src).ffOverrideBombFlagSource or sourceFlag
	delayedBombFlagHasCross[ptrhash] = delayedBombFlagHasCross[ptrhash] or tearflags & TearFlags.TEAR_CROSS_BOMB == TearFlags.TEAR_CROSS_BOMB
	
	if sourceFlag then
		local posCopy = Vector(pos.X, pos.Y) -- becomes junk data otherwise
		local tearflagsCopy = tearflags | TearFlags.TEAR_NORMAL -- becomes junk data otherwise
		for _, callbackData in pairs(Isaac.GetCallbacks(FiendFolio.CALLBACK.FF_POST_BOMBFLAG_EFFECTS)) do
			if isDelayed then
				table.insert(delayedBombFlagEffectFuncs, function()
					if not callbackData.Param or TearFlagsLib.HasTearFlags(src, callbackData.Param) then
						callbackData.Function(callbackData.Mod, posCopy, radius, tearflagsCopy | ((delayedBombFlagHasCross[ptrhash] and TearFlags.TEAR_CROSS_BOMB) or TearFlags.TEAR_NORMAL), src, radiusMult, player, sourceFlag, TearFlagsLib.GetTearFlagParams(src, callbackData.Param))
					end
				end)
			else
				if not callbackData.Param or TearFlagsLib.HasTearFlags(src, callbackData.Param) then
					local params = TearFlagsLib.GetTearFlagParams(src, callbackData.Param)
					table.insert(delayedBombFlagEffectFuncs, function()
						callbackData.Function(callbackData.Mod, posCopy, radius, tearflagsCopy | ((delayedBombFlagHasCross[ptrhash] and TearFlags.TEAR_CROSS_BOMB) or TearFlags.TEAR_NORMAL), src, radiusMult, player, sourceFlag, params)
					end)
				end
			end
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	for _, tab in pairs(delayedRollBombFlags) do
		local data = mod:GetEntityData(tab.Source)
		if not data.HasPolledBombFlags then
			Isaac.RunCallbackWithParam(FiendFolio.CALLBACK.FF_POLL_BOMBFLAGS, tab.Flag, tab.Source, tab.Player, tab.Flag)
			data.HasPolledBombFlags = true
		end
	end
	
	for _, func in ipairs(delayedBombFlagDamageFuncs) do
		func()
	end
	
	for _, func in ipairs(delayedBombFlagEffectFuncs) do
		func()
	end
	
	for _, tab in pairs(delayedRollBombFlags) do
		local data = mod:GetEntityData(tab.Source)
		TearFlagsLib.WipeTearFlags(tab.Source)
		data.HasPolledBombFlags = nil
	end
	
	delayedBombFlagDamageFuncs = {}
	delayedBombFlagEffectFuncs = {}
	delayedBombFlagHasCross = {}
	delayedRollBombFlags = {}
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	delayedBombFlagDamageFuncs = {}
	delayedBombFlagEffectFuncs = {}
	delayedRollBombFlags = {}
end)

-- doctor's remote is so weird man
-- the player uses the item, then on their next peffect update it spawns the target
-- it doesn't spawn the target during the actual use of the item like you'd expect
-- literally why

local playersCheckingForDoctorsRemote = {}
mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, collectible, rng, player)
	table.insert(playersCheckingForDoctorsRemote, player)
end, CollectibleType.COLLECTIBLE_DOCTORS_REMOTE)

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
	if #playersCheckingForDoctorsRemote > 0 then
		for i = #playersCheckingForDoctorsRemote, 1, -1 do
			local player2 = playersCheckingForDoctorsRemote[i]
			if not player2:Exists() then
				table.remove(playersCheckingForDoctorsRemote, i)
			elseif player.Index == player2.Index and player.InitSeed == player2.InitSeed then
				local targets = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.TARGET)
				for _, target in ipairs(targets) do
					if target.FrameCount == 0 and target.SpawnerEntity and
					   target.SpawnerEntity.Index == player.Index and target.SpawnerEntity.InitSeed == player.InitSeed
					then
						mod:GetEntityData(target).FFIsDoctorsRemote = true
					end
				end
				table.remove(playersCheckingForDoctorsRemote, i)
			end
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function(_, player)
	playersCheckingForDoctorsRemote = {}
end)

function mod:isReplaceableBombVariant(var)
	return not (var == BombVariant.BOMB_BIG or
		var == BombVariant.BOMB_DECOY or
		var == BombVariant.BOMB_TROLL or
		var == BombVariant.BOMB_SUPERTROLL or
		var == BombVariant.BOMB_THROWABLE or
		var == BombVariant.BOMB_GIGA or
		var == BombVariant.BOMB_GOLDENTROLL or
		var == BombVariant.BOMB_ROCKET or
		var == BombVariant.BOMB_ROCKET_GIGA or
		var == FiendFolio.FF.CherryBomb.Var or
		var == mod.BOMB.TROLL_COPPER)
end