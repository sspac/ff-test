-- Allow Enemy Replacements --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

-- enemies that can be replaced
mod.AllowEnemyReplaceableWhitelist = {
	[EntityType.ENTITY_SHOPKEEPER] = true,
	[EntityType.ENTITY_DEATHS_HEAD .. " " .. 1] = true,
}

-- enemies that cannot be replaced
mod.AllowEnemyReplaceableBlacklist = {
	[EntityType.ENTITY_MOM] = true, -- i have other plans
	[EntityType.ENTITY_MOMS_HEART] = true,
	[EntityType.ENTITY_SATAN] = true,
	[EntityType.ENTITY_ISAAC] = true,
	[EntityType.ENTITY_THE_LAMB] = true,
	[EntityType.ENTITY_MEGA_SATAN] = true,
	[EntityType.ENTITY_MEGA_SATAN_2] = true,
	[EntityType.ENTITY_ULTRA_GREED] = true,
	[EntityType.ENTITY_HUSH] = true,
	[EntityType.ENTITY_DELIRIUM] = true,
	[EntityType.ENTITY_MOTHER] = true,
	[EntityType.ENTITY_DOGMA] = true,
	[EntityType.ENTITY_BEAST] = true,
}

-- enemies that can be replaced into
mod.AllowEnemyReplacementWhitelist = {}

-- enemies that cannot be replaced into
mod.AllowEnemyReplacementBlacklist = {
	[EntityType.ENTITY_MOM] = true, -- story bosses (most of these are just too big or too silly so nah i have other plans)
	[EntityType.ENTITY_MOMS_HEART] = true,
	[EntityType.ENTITY_SATAN] = true,
	[EntityType.ENTITY_ISAAC] = true,
	[EntityType.ENTITY_THE_LAMB] = true,
	[EntityType.ENTITY_MEGA_SATAN] = true,
	[EntityType.ENTITY_MEGA_SATAN_2] = true,
	[EntityType.ENTITY_ULTRA_GREED] = true,
	[EntityType.ENTITY_HUSH] = true,
	[EntityType.ENTITY_DELIRIUM] = true,
	[EntityType.ENTITY_MOTHER] = true,
	[EntityType.ENTITY_DOGMA] = true,
	[EntityType.ENTITY_BEAST] = true,
	[EntityType.ENTITY_BLOOD_PUPPY] = true, -- do you really want to start dealing with these three?
	[EntityType.ENTITY_DARK_ESAU] = true,
	[EntityType.ENTITY_MOTHERS_SHADOW] = true,
	[EntityType.ENTITY_GIDEON] = true, -- i don't think these spawn but doesn't hurt to double check
	[EntityType.ENTITY_DUMMY] = true,
	[mod.FF.FakeHorse.ID .. " " .. mod.FF.FakeHorse.Var] = true, -- projectiles
	[mod.FF.WormBall.ID .. " " .. mod.FF.WormBall.Var] = true,
	[EntityType.ENTITY_VIS .. " " .. 22] = true,
	[mod.FF.Propaganda.ID .. " " .. mod.FF.Propaganda.Var .. " " .. 1] = true,
	[mod.FF.IDPDGrenade.ID .. " " .. mod.FF.IDPDGrenade.Var] = true,
	[mod.FF.Lurker.ID .. " " .. mod.FF.Lurker.Var] = true, -- lurker parts
	[mod.FF.LurkerCore.ID .. " " .. mod.FF.LurkerCore.Var] = true,
	[mod.FF.LurkerTooth.ID .. " " .. mod.FF.LurkerTooth.Var] = true,
	[mod.FF.LurkerStoma.ID .. " " .. mod.FF.LurkerStoma.Var] = true,
	[mod.FF.LurkerStretch.ID .. " " .. mod.FF.LurkerStretch.Var] = true,
	[mod.FF.LurkerBrain.ID .. " " .. mod.FF.LurkerBrain.Var] = true,
	[mod.FF.LurkerCollider.ID .. " " .. mod.FF.LurkerCollider.Var] = true,
	[mod.FF.LurkerStretchCollider.ID .. " " .. mod.FF.LurkerStretchCollider.Var] = true,
	[mod.FF.LurkerPsuedoDefault.ID .. " " .. mod.FF.LurkerPsuedoDefault.Var] = true,
	[mod.FF.LurkerBridgeProj.ID .. " " .. mod.FF.LurkerBridgeProj.Var] = true,
	[mod.FF.LurkerCord.ID .. " " .. mod.FF.LurkerCord.Var] = true,
	[mod.FF.Tsar.ID .. " " .. mod.FF.Tsar.Var] = true, -- breaks as soon as they start looking for the grate
	[mod.FF.Tsarball.ID .. " " .. mod.FF.Tsarball.Var] = true,
	[mod.FF.OrgBashful.ID .. " " .. mod.FF.OrgBashful.Var] = true, -- dies immediately
	[mod.FF.OrgBashfulCorpse.ID .. " " .. mod.FF.OrgBashfulCorpse.Var] = true,
	[mod.FF.OrgSpeedy.ID .. " " .. mod.FF.OrgSpeedy.Var] = true,
	[mod.FF.OrgPokey.ID .. " " .. mod.FF.OrgPokey.Var] = true,
	[mod.FF.OrgPokeyCorpse.ID .. " " .. mod.FF.OrgPokeyCorpse.Var] = true,
	[mod.FF.Ossularry.ID .. " " .. mod.FF.Ossularry.Var] = true,
	[mod.FF.Cortex.ID .. " " .. mod.FF.Cortex.Var] = true,
	[mod.FF.DuskHand.ID .. " " .. mod.FF.DuskHand.Var] = true,
	[EntityType.ENTITY_LARRYJR] = true,
	[mod.FF.FlagpoleHead.ID .. " " .. mod.FF.FlagpoleHead.Var] = true,
	[mod.FF.FlagpoleBody.ID .. " " .. mod.FF.FlagpoleBody.Var] = true,
	[mod.FF.Freezer.ID .. " " .. mod.FF.Freezer.Var] = true, -- yeah no
	[mod.FF.CacophobiaVenus.ID .. " " .. mod.FF.CacophobiaVenus.Var] = true,
	[mod.FF.Fount.ID .. " " .. mod.FF.Fount.Var] = true, -- why are my enemies sliding around
	[mod.FF.Rook.ID .. " " .. mod.FF.Rook.Var] = true,
	[mod.FF.Chorus.ID .. " " .. mod.FF.Chorus.Var] = true,
	[EntityType.ENTITY_FROZEN_ENEMY] = true,
	[mod.FF.LonelyKnightBrain.ID .. " " .. mod.FF.LonelyKnightBrain.Var] = true,
	[mod.FF.LonelyKnightShell.ID .. " " .. mod.FF.LonelyKnightShell.Var] = true,
	[mod.FF.Propaganda.ID .. " " .. mod.FF.Propaganda.Var .. " " .. 2] = true,
	[EntityType.ENTITY_HORNFEL .. " " .. 1] = true,
	[mod.FF.DimGhost.ID .. " " .. mod.FF.DimGhost.Var] = true, -- death effects
	[EntityType.ENTITY_MAMA_GURDY] = true, -- despawns immediately
	[mod.FF.Murmur.ID .. " " .. mod.FF.Murmur.Var] = true, -- spits out some sort of error
	[mod.FF.WhispersController.ID .. " " .. mod.FF.WhispersController.Var] = true,
	[mod.FF.Whispers.ID .. " " .. mod.FF.Whispers.Var] = true,
	[mod.FF.WhispersMarker.ID .. " " .. mod.FF.WhispersMarker.Var] = true,
	[mod.FF.BloastEye.ID .. " " .. mod.FF.BloastEye.Var] = true, -- never dies
	[666 .. " " .. 191] = true,
	[mod.FF.SentryShell.ID .. " " .. mod.FF.SentryShell.Var .. " " .. mod.FF.SentryShell.Sub] = true,
	[mod.FF.RotspinCore.ID .. " " .. mod.FF.RotspinCore.Var] = true, -- no grid collision
	[mod.FF.RotspinMoon.ID .. " " .. mod.FF.RotspinMoon.Var] = true,
	[mod.FF.Amon.ID .. " " .. mod.FF.Amon.Var] = true, -- Amon parts
	[mod.FF.AmonCorpse.ID .. " " .. mod.FF.AmonCorpse.Var] = true,
	[mod.FF.AmonArm.ID .. " " .. mod.FF.AmonArm.Var] = true,
	[mod.FF.BreathsHead.ID .. " " .. mod.FF.BreathsHead.Var] = true,
	[EntityType.ENTITY_ROTGUT] = true, -- softlocks
	[EntityType.ENTITY_ROCK_SPIDER .. " " .. 1] = true, -- infinite health with doorstop
	[EntityType.ENTITY_GURDY] = true, -- teleports the player on room start
}

local function isReplaceable(typ, var, subt)
	if mod.AllowEnemyReplaceableWhitelist[typ] or mod.AllowEnemyReplaceableWhitelist[typ .. " " .. var] or mod.AllowEnemyReplaceableWhitelist[typ .. " " .. var .. " " .. subt] then return true end
	if mod.AllowEnemyReplaceableBlacklist[typ] or mod.AllowEnemyReplaceableBlacklist[typ .. " " .. var] or mod.AllowEnemyReplaceableBlacklist[typ .. " " .. var .. " " .. subt] then return false end	
	if typ <= 9 or typ >= 1000 then return false end
	
	local entconf = EntityConfig.GetEntity(typ, var)
	if not entconf then return false end
	
	local canShutDoors = entconf:CanShutDoors()
	local hasHP = entconf:GetBaseHP() > 0
	return canShutDoors and hasHP
end

local function isReplacement(xmlEntry)
	local typ = tonumber(xmlEntry.id)
	local var = (xmlEntry.variant ~= nil and tonumber(xmlEntry.variant)) or 0
	local subt = (xmlEntry.subtype ~= nil and tonumber(xmlEntry.subtype)) or 0
	if mod.AllowEnemyReplacementWhitelist[typ] or mod.AllowEnemyReplacementWhitelist[typ .. " " .. var] or mod.AllowEnemyReplacementWhitelist[typ .. " " .. var .. " " .. subt] then return true end	
	if mod.AllowEnemyReplacementBlacklist[typ] or mod.AllowEnemyReplacementBlacklist[typ .. " " .. var] or mod.AllowEnemyReplacementBlacklist[typ .. " " .. var .. " " .. subt] then return false end	
	if typ <= 9 or typ >= 1000 then return false end
	
	local canShutDoors = xmlEntry.shutdoors ~= "false"
	local hasHP = ((xmlEntry.basehp ~= nil and tonumber(xmlEntry.basehp)) or 0) > 0
	return canShutDoors and hasHP
end

local function getReplacement(typ, var, subt, seed)
	if Isaac.GetChallenge() == mod.challenges.allowEnemyReplacements then
		if isReplaceable(typ, var, subt) then
			local rng = RNG()
			rng:SetSeed(seed, 39)
			
			local numEntries = XMLData.GetNumEntries(XMLNode.ENTITY)
			local replacement
			repeat
				replacement = XMLData.GetEntryByOrder(XMLNode.ENTITY, rng:RandomInt(numEntries) + 1)
			until (isReplacement(replacement))
			
			return {tonumber(replacement.id), 
			        (replacement.variant ~= nil and tonumber(replacement.variant)) or 0, 
			        (replacement.subtype ~= nil and tonumber(replacement.subtype)) or 0}
		end
	end
end

mod:AddPriorityChallengeCallback(ModCallbacks.MC_PRE_ROOM_ENTITY_SPAWN, CallbackPriority.IMPORTANT, mod.challenges.allowEnemyReplacements, function(_, typ, var, subt, grid, seed)
	return getReplacement(typ, var, subt, seed)
end)

StageAPI.AddCallback("FiendFolio", "PRE_SPAWN_ENTITY", 1, function(entityInfo, entityList, index)
	return getReplacement(entityInfo.Data.Type, entityInfo.Data.Variant, entityInfo.Data.SubType, StageAPI.RoomLoadRNG:GetSeed()+index)
end)

mod:AddChallengeCallback(ModCallbacks.MC_PLAYER_INIT_POST_LEVEL_INIT_STATS, mod.challenges.allowEnemyReplacements, function(_, player)
	player:AddSmeltedTrinket(TrinketType.TRINKET_DOOR_STOP)
	mod.SetChallengeDestinationIcon(mod.DestinationIcon.RANDOM)
end)

--[[mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, collectible, rng, player, useflags, slot, vardata)
	if Isaac.GetChallenge() == mod.challenges.allowEnemyReplacements then
		if slot >= 0 and player:GetCard(0) == FiendFolio.ITEM.CARD.SKIP_CARD then
			local desc = player:GetActiveItemDesc(slot)
			if desc then desc.VarData = 4 end
		end
	end
end, CollectibleType.COLLECTIBLE_BLANK_CARD)]]--

local function getRoomDifficulties(gamemode)
	if gamemode == Difficulty.DIFFICULTY_NORMAL then
		return 5, 10
	else
		return 10, 15
	end
end

local function getBossRoomInfo()
	local level = game:GetLevel()
	for y = 0, 12 do
		for x = 0, 12 do
			local index = y * 13 + x
			local roomDesc = level:GetRoomByIdx(index)
			local roomData = roomDesc.Data
			if roomData and index == roomDesc.SafeGridIndex then
				local roomType = roomData.Type
				if roomType == RoomType.ROOM_BOSS then
					return roomData, index
				end
			end
		end
	end
end

local storyBossRoomSubtypes = {8, 25, 39, 39, 40, 40, 24, 24, 54, 54}
local function getBossRoomSubType(seed)
	local rng = RNG()
	rng:SetSeed(seed, 64)
	
	return storyBossRoomSubtypes[rng:RandomInt(#storyBossRoomSubtypes) + 1]
end

mod:AddChallengeCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.challenges.allowEnemyReplacements, function()
	local level = game:GetLevel()
	local levelstage = level:GetStage()
	if levelstage == LevelStage.STAGE3_2 then
		local bossRoomData, bossIndex = getBossRoomInfo()
		if bossRoomData == nil then return end
		
		local minDifficulty, maxDifficulty = getRoomDifficulties(game.Difficulty)
		local seed = math.max(1, game:GetLevel():GetDungeonPlacementSeed())
		local subtype = getBossRoomSubType(seed)
		local room = RoomConfigHolder.GetRandomRoom(seed, false, 
		                                            StbType.SPECIAL_ROOMS, RoomType.ROOM_BOSS, RoomShape.ROOMSHAPE_1x1,
		                                            nil, nil, nil, nil, nil, subtype)
		if room then
			local bossroom = level:GetRoomByIdx(bossIndex)
			bossroom.Data = room
		end
	end
end)