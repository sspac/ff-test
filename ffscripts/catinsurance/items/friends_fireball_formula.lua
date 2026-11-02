local mod = FiendFolio
local FriendsFireballFormula = {}
local manager = TearFlagsLib
manager.RegisterTearFlag("FRIEND_FIRE")
local fireballFormulaStatusflag = mod:RegisterEnemyStatusEffect("SEWING_FRIEND_FIRE_TRACKER", 0, "sewingFriendFireOnUpdate", {Vasculitis = "sewingFriendFireOnVasculitis"})

local BURN_TIME = 60
local FIRE_JET_DISTANCE = 30

local purple = mod.ColorFireballFormulaPurple

local MIN_LUCK = 0
local MAX_LUCK = 20
local MIN_CHANCE = 0.1
local MAX_CHANCE = 1

local SKIPPED_WEAPONS = {}

local SKIPPED_COLOURERS = {
    [TearFlagsLib.WeaponFlag.KNIFE] = true, -- Flickers
    [TearFlagsLib.WeaponFlag.LASER] = true, -- Sets Player.LaserColor
    [TearFlagsLib.WeaponFlag.BRIMSTONE_BALL] = true, -- Sets Player.LaserColor
    [TearFlagsLib.WeaponFlag.ANTI_GRAV_LASER] = true, -- Sets Player.LaserColor
    [TearFlagsLib.WeaponFlag.UMBILICAL_WHIP] = true, -- Permanently tints Gello purple
    [TearFlagsLib.WeaponFlag.DARK_ARTS] = true,
    [TearFlagsLib.WeaponFlag.BOBS_ROTTEN_HEAD] = true,
    [TearFlagsLib.WeaponFlag.SHARP_KEY] = true,
    [TearFlagsLib.WeaponFlag.OCULAR_RIFT] = true,
    [TearFlagsLib.WeaponFlag.HEMOPTYSIS] = true,
}

-- previously pepper flakes then fiend's fire flakes and now friend's fire formula

local function shouldAddFlag(player, source)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.FRIENDS_FIREBALL_FORMULA) then
        local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.FRIENDS_FIREBALL_FORMULA)
        if rng:RandomFloat() < TearFlagsLib.GetChance(TearFlagsLib.GetRealLuck(player, source), MIN_CHANCE, MAX_CHANCE, MAX_LUCK) then
            return true
        end
    end

    return false
end

function FriendsFireballFormula:PollTearFlag(entity, player, weaponFlag)
    if SKIPPED_WEAPONS[weaponFlag] then return end

    if shouldAddFlag(player, entity) then
        TearFlagsLib.AddTearFlags(entity, TearFlagsLib.Flag.FRIEND_FIRE)

        if SKIPPED_COLOURERS[weaponFlag] then return end
		if weaponFlag == TearFlagsLib.WeaponFlag.AQUARIUS then
			mod:GetEntityData(entity).FFAquariusColor = purple
		elseif weaponFlag == TearFlagsLib.WeaponFlag.EPIC_FETUS or weaponFlag == TearFlagsLib.WeaponFlag.CLUB_EPIC_FETUS then
			mod:GetEntityData(entity).FFExplosionColor = purple
		else
			entity.Color = purple
		end
    end
end

mod:AddCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, FriendsFireballFormula.PollTearFlag)

function FriendsFireballFormula:ApplyTearflagEffect(entity, player, source)
    entity:AddBurn(EntityRef(player), BURN_TIME * (1 + player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND)), player.Damage)
	
	if TearFlagsLib.GetTearFlagParams(source, TearFlagsLib.Flag.FRIEND_FIRE).ForceJets then
		mod:TrackEnemyStatus(entity, fireballFormulaStatusflag)
		local ptrhash = GetPtrHash(entity)
		mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
		mod.VasculitisInfo[ptrhash][fireballFormulaStatusflag] = {}
	end
end

mod:AddCallback(manager.Callback.APPLY_TEARFLAG_EFFECT, FriendsFireballFormula.ApplyTearflagEffect, manager.Flag.FRIEND_FIRE)

---@param npc EntityNPC
function mod:SpawnFireballFormulaJet(npc)
    if npc:HasEntityFlags(EntityFlag.FLAG_BURN) then
		local ptrhash = GetPtrHash(npc)
		local player = PlayerManager.FirstCollectibleOwner(mod.ITEM.COLLECTIBLE.FRIENDS_FIREBALL_FORMULA)
		if player then
			local spawnDistance = FIRE_JET_DISTANCE
			local fireJet = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FIRE_JET, 1, npc.Position, Vector.Zero, player):ToEffect()
			fireJet:SetDamageSource(EntityType.ENTITY_PLAYER)
			fireJet.CollisionDamage = player.Damage

			local data = mod:GetEntityData(fireJet)
			data.FireFormula = true
			for i = 0, 360, 90 do
				local position = npc.Position + Vector.FromAngle(i) * spawnDistance
				fireJet = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FIRE_WAVE, 1, position, Vector.Zero, player):ToEffect()
				fireJet.Rotation = i
				fireJet:SetDamageSource(EntityType.ENTITY_PLAYER)
				fireJet.CollisionDamage = player.Damage

				local jdata = mod:GetEntityData(fireJet)
				jdata.FireFormula  = true
			end
		elseif mod.EnemiesWithStatus[fireballFormulaStatusflag][ptrhash] then
			player = mod:GetEntityData(npc).FFFriendFireSource or Isaac.GetPlayer()
			
			local spawnDistance = 30
			local fireJet = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FIRE_JET, 1, npc.Position, Vector.Zero, player):ToEffect()
			fireJet:SetDamageSource(EntityType.ENTITY_PLAYER)
			fireJet.CollisionDamage = player.Damage

			local data = mod:GetEntityData(fireJet)
			data.FireFormula = true
			data.SewingFireFormula = true
			for i = 0, 360, 90 do
				local position = npc.Position + Vector.FromAngle(i) * spawnDistance
				fireJet = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FIRE_WAVE, 1, position, Vector.Zero, player):ToEffect()
				fireJet.Rotation = i
				fireJet:SetDamageSource(EntityType.ENTITY_PLAYER)
				fireJet.CollisionDamage = player.Damage

				local jdata = mod:GetEntityData(fireJet)
				jdata.FireFormula  = true
				jdata.SewingFireFormula  = true
			end
		end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.SpawnFireballFormulaJet)

---@param ent Entity
---@param source EntityRef
function FriendsFireballFormula:InflictBurnFireJet(ent, _, _, source)
    local npc = ent:ToNPC()
    if source.Entity
    and mod:GetEntityData(source.Entity).FireFormula
    and npc then
        local player = source.Entity.SpawnerEntity and source.Entity.SpawnerEntity:ToPlayer()
        if player then
            npc:AddBurn(
                source,
                BURN_TIME * (1 + player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND)),
                player.Damage
            )
        end
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, FriendsFireballFormula.InflictBurnFireJet)

-- Make the fire jets spawn by the fire wave marked with our data
local checkingForJets = {}
function FriendsFireballFormula:MarkFireJets(jet)
    if #checkingForJets > 0 then
		local wave = checkingForJets[#checkingForJets]
		if mod:GetEntityData(wave).FireFormula then
			local player = wave.SpawnerEntity and wave.SpawnerEntity:ToPlayer()
			if player then
				mod:GetEntityData(jet).FireFormula = true
				jet.CollisionDamage = player.Damage
				return
			end
		end
	end
	
	local player = jet.SpawnerEntity and jet.SpawnerEntity:ToPlayer()
    if player then
		if player:HasCollectible(mod.ITEM.COLLECTIBLE.FRIENDS_FIREBALL_FORMULA) then
			mod:GetEntityData(jet).FireFormula = true
			jet.CollisionDamage = player.Damage
		else
			for k,v in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FiendFolio.ITEM.FAMILIAR.SEWING_MANUAL_DOLL, mod.ITEM.COLLECTIBLE.FRIENDS_FIREBALL_FORMULA)) do
				local fam = v:ToFamiliar()
				if fam and fam.Player and fam.Player.Index == player.Index and fam.Player.InitSeed == player.InitSeed then
					mod:GetEntityData(jet).FireFormula = true
					mod:GetEntityData(jet).SewingFireFormula = true
					jet.CollisionDamage = player.Damage
					break
				end
			end
		end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, FriendsFireballFormula.MarkFireJets, EffectVariant.FIRE_JET)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_EFFECT_UPDATE, math.huge, function(_, wave)
	if mod:GetEntityData(wave).FireFormula then
		table.insert(checkingForJets, wave)
	end
end, EffectVariant.FIRE_WAVE)

mod:AddPriorityCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, -1 * math.huge, function(_, wave)
	for i = #checkingForJets, 1, -1 do
		local entity = checkingForJets[i]
		table.remove(checkingForJets, i)
		if GetPtrHash(wave) == GetPtrHash(entity) then
			break
		end
	end
end, EffectVariant.FIRE_WAVE)


---@param source EntityRef
function FriendsFireballFormula:CancelFireJetDamage(_, _, _, source)
    if not source or not source.Entity then return end
    local data = mod:GetEntityData(source.Entity)
    if source.Entity
    and source.Entity.Type == EntityType.ENTITY_EFFECT
    and (source.Entity.Variant == EffectVariant.FIRE_JET or source.Entity.Variant == EffectVariant.FIRE_WAVE)
    and data.FireFormula then
        return false
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_TAKE_DMG, FriendsFireballFormula.CancelFireJetDamage)

function FriendsFireballFormula:SetLaserColor(player)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.FRIENDS_FIREBALL_FORMULA) then
        player.LaserColor = purple
    end
end

mod:AddCollectibleCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ITEM.COLLECTIBLE.FRIENDS_FIREBALL_FORMULA, FriendsFireballFormula.SetLaserColor, CacheFlag.CACHE_TEARCOLOR)

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.FRIENDS_FIREBALL_FORMULA] = {
	BodyColor = Color(1,1,1,1,10.328/255,12.234/255,7.25/255,0.328,0.234,0.25,1),
	EyeAColor = Color(1,1,1,1,73.593/255,-423.781/255,255/255,0.594,2.219,0,1),
	EyeBColor = Color(1,1,1,1,73.593/255,-423.781/255,255/255,0.594,2.219,0,1)}

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	local rng = familiar.Player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.FRIENDS_FIREBALL_FORMULA)
    if rng:RandomFloat() < TearFlagsLib.GetChance(0, 0.1, 1, 20) then
		local player = familiar.Player
		local secondHandMultiplier = ((player and player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND)) or 0) + 1
        TearFlagsLib.AddTearFlags(tear, TearFlagsLib.Flag.FRIEND_FIRE)
		TearFlagsLib.SetTearFlagParams(tear, TearFlagsLib.Flag.FRIEND_FIRE, {ForceJets = true})
		tear.Color = purple
    end
end, FiendFolio.ITEM.COLLECTIBLE.FRIENDS_FIREBALL_FORMULA)

function mod.handleFriendFireD3(entity)
	TearFlagsLib.SetTearFlagParams(entity, TearFlagsLib.Flag.FRIEND_FIRE, {ForceJets = true})
end

function mod:sewingFriendFireOnUpdate(npc)
	if not npc:HasEntityFlags(EntityFlag.FLAG_BURN) then
		mod:UntrackEnemyStatus(npc, fireballFormulaStatusflag)
	
		if not (npc:IsDead() or npc:HasMortalDamage()) then
			local ptrhash = GetPtrHash(npc)
			mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
			mod.VasculitisInfo[ptrhash][fireballFormulaStatusflag] = nil
		end
	end
end

function mod:sewingFriendFireOnVasculitis(tear, npc)
	local ptrhash = GetPtrHash(npc)
	mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
	
	local vasculitisInfo = mod.VasculitisInfo[ptrhash][fireballFormulaStatusflag]
	if vasculitisInfo then
		TearFlagsLib.AddTearFlags(tear, TearFlagsLib.Flag.FRIEND_FIRE)
		TearFlagsLib.SetTearFlagParams(tear, TearFlagsLib.Flag.FRIEND_FIRE, {ForceJets = true})
	end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, ent, _, _, source)
    local npc = ent:ToNPC()
    if source.Entity
    and mod:GetEntityData(source.Entity).SewingFireFormula
    and npc then
		mod:TrackEnemyStatus(npc, fireballFormulaStatusflag)
		local ptrhash = GetPtrHash(npc)
		mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
		mod.VasculitisInfo[ptrhash][fireballFormulaStatusflag] = {}
    end
end)