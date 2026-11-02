local mod = FiendFolio
local game = Game()
local pakChoi = mod.ITEM.COLLECTIBLE.PAK_CHOI
local nullReviver = mod.ITEM.NULL.PAK_CHOI_REVIVE
local dataKey = {}

mod.PAK_CHOI_BOOST = 1.09 -- If the price of Pak Choi ever changes we could consider changing this to match

-- Done:
--[[
	Tears
	Damage
	Speed
	Shotspeed
	Luck
	Range
	Tear Height
	Size
	Mass
	Friction
	Deal Chance
	Planetarium Chance
	Coins
	Coin Cap
	Bombs
	Bomb Cap
	Keys
	Key Cap
	Health Cap
	Tear Size
	Extra Lives
	Invulnerability frames
	Shield Duration (book of shadows, algiz, sigil of baphomet) -- I think enough different things use Shields to list it in the EID
	Creep Lifespan (aquarius, anemia, the thousand other creep items) -- See above
	Time Charge Item Recharge Rate
	Bomb Placement rate
	Bomb damage
]]

-- Done (DON'T DOCUMENT IN EID) These are too hard to explain without going into too much detail so just don't fucking bother, leave it to the wiki editors
--[[
	-- Too complicated to explain in 1 line of EID
	Heart Containers (Heart Containers + Bone Hearts mixed handling)
	Red Health (Red + Rotten + Morbid mixed handling)
	Soul Health (Soul + Black + Immoral mixed handling)
	Golden Hearts (Just way too niche honsetly)
	Copper Bombs (Ditto)
	Giga Bombs (Ditto)
	Broken Hearts (lmao)
	Creep Damage (Aquarius exception because fuck my life in particular)
	Creep Size (Unnoticable lmao)

	Fireball Cap (Fiend, Pyromancy, Imp Finger)
	Fireball Recharge Rate (Fiend, Pyromancy, Imp Finger)

	-- Character specific effects
	Blood Gauge Charge
	Soul Gauge Charge
	Golem Rock Power
	Fractional Poop Mana

	-- Item specific effects
	Guillotine Orbit Speed + Orbit Distance
	Cambion/Immaculate Conception gestation rate
	IBS Poop-Spell charge-rate
	Mega Blast/Soul of Azazel duration
	Red Stew damage up duration
	Urn of Souls current Souls (limits at base cap)
	Jar of Flies current Flies
	Gamekid duration
	Necronomicon/Blood Rights/Black Heart damage
	Magic Fingers damage
	Sharp Straw damage
	Best Friend damage
	Mr Boom damage
	My Little Unicorn duration
	Unicorn Stump duration
	Spirit Shackles slow-mo duration
	Camo Undies stat boost duration -- When the fuck did this item start doing this
	Mega Mush duration
	Dark Arts duration
	Reverse Magician duration
	Reverse Priestess duration
	Reverse Empress duration
	Reverse Chariot duration
	Reverse Hanged Man duration
	Reverse Devil duration
	Astral Projection slowdown duration
	Collision damage (Virus, Aries, Gamekid, My Little Unicorn, Tooth and Nail)

	-- etc
	Poker Table odds
]]

-- To-do:
--[[
	Temporary familiars? (Bone Orbitals/Wisps)
	4.5 Volt charge rate?
	Pause Duration
	Spin To Win Recharge Cooldown reduction (idk how to word this in a way that makes it sound like I'm multiplying something like 1.09x like I'm supposed to so lets just pretend)
	Notched Axe durability/Dark Arts duration (might involve increasing the charge time for the item instead of reducing, idk, look into it)
	The Boomerang speed???????
	Anima Sola chain duration
	Reverse Chariot duration
	Black Powder Pentagram damage
	Circle of Protection damage
	Jumper Cables charge rate
	Lead Pencil charge rate
	Mars/Divine Intervention recharge rate
	Reverse Strength duration (see camo undies, it's a roomEffect)
	Hemoptysis cooldown (null effect? maybe? it adds 2 temp effects, presumably one is null and one is collectible) -- Or maybe 1 is NullItemID.ID_HEMOPTYSIS and the other is NullItemID.ID_HEMOPTYSIS_BOOST -- Needs testing
	Bob's Rotten Head explosion damage

	Player-status-effect-duration reduction

	Happy's wishlist:
	https://discord.com/channels/401124229090639884/487689556783661056/1257468315341688843

	T. Samson berserk charge rate
	T. lost quality replacement rate??
	Friend reload speed (maybe maybe not)

	-- Not currently possible (or feasible)

	Holy Mantle charges (why don't you get more than 1 shield if you have more than 1 of the item??????)
	Urn of Souls/Jar of Flies/Hearts capacity -- This is so niche I don't even know how to explain to Repentogon Inc. that I would want it
]]

function mod.GetPakChoiMultiplier(player)
	return mod.PAK_CHOI_BOOST ^ player:GetCollectibleNum(pakChoi)
end

local function truncate(value, numDecimals)
	local whole = math.floor(value)
	local totalDigits = string.len(tostring(whole)) + numDecimals + 1
	local truncatedString = string.sub(tostring(value), 1,  totalDigits)
	return tonumber(truncatedString)
end

local function getExclusiveSoulHearts(player)
	local armour = player:GetSoulHearts()
	local soul = armour 
	soul = soul + soul % 2 -- trust the process
	soul = soul - 2 * mod.CountBits(player:GetBlackHearts())

	local testBit = armour
	testBit = testBit + testBit % 2
	testBit = testBit / 2
	testBit = 1 << (testBit - 1)

	if player:GetBlackHearts() & testBit == 0 and armour % 2 == 1 then
		soul = soul - 1
	end

	return soul - mod.GetImmoralHeartsNum(player)
end

local function getExclusiveRedHearts(player)
	local blood = player:GetHearts()
	blood = blood - player:GetRottenHearts() * 2

	local morbid = mod.GetMorbidHeartsNum(player)
	blood = blood - math.floor(2 * morbid / 3 + 0.5) -- Send it

	return blood
end

local function fullHeal(player)
	local bloodCharges = player:GetBloodCharge()
	player:AddHearts(100)

	if player:GetBloodCharge() ~= 0 then
		player:AddBloodCharge(bloodCharges + 12 - player:GetBloodCharge())
	end
end

local function getSafeData(entity, persistent)
	if persistent then
		local data = mod.GetPersistentPlayerData(entity)
		data.pakChoiData = data.pakChoiData or {
			immaculateBoost = 0,
			cambionBoost = 0,
		}
		return data.pakChoiData
	else
		local data = mod:GetEntityData(entity)
		data[dataKey] = data[dataKey] or {}
		return data[dataKey]
	end
end

local function shouldGrantCambionBaby(player)
	local state = player:GetCambionConceptionState()
	return state == 15 or state == 30 or state == 60 or state == 90 -- This item is fucked up man
end

local function shouldGrantImmaculateBaby(player)
	local state = player:GetImmaculateConceptionState()
	return state == 0 -- This item blows chunks
end

local function getValidCambionFlags(player)
	local options = {}
	local gameData = Isaac.GetPersistentGameData()
	local ownedFlags = player:GetConceptionFamiliarFlags()

	for i = 0, 5 do if ownedFlags & (1 << i) == 0 then table.insert(options, 1 << i) end end
	if gameData:Unlocked(Achievement.LIL_ABADDON) and ownedFlags & ConceptionFamiliarFlag.LIL_ABADDON == 0 then table.insert(options, ConceptionFamiliarFlag.LIL_ABADDON) end
	if gameData:Unlocked(Achievement.TWISTED_PAIR) and ownedFlags & ConceptionFamiliarFlag.TWISTED_PAIR == 0 then table.insert(options, ConceptionFamiliarFlag.TWISTED_PAIR) end

	return options
end

local function getValidImmaculateFlags(player)
	local options = {}
	local ownedFlags = player:GetConceptionFamiliarFlags()

	for i = 6, 10 do if ownedFlags & (1 << i) == 0 then table.insert(options, 1 << i) end end
	return options
end

mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE, CallbackPriority.LATE, function(_, player)
	if player:HasCollectible(pakChoi) then
		player.MaxFireDelay = mod:tearsMult(player.MaxFireDelay, mod.GetPakChoiMultiplier(player))
	end
end, CacheFlag.CACHE_FIREDELAY)

mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE, CallbackPriority.LATE, function(_, player)
	if player:HasCollectible(pakChoi) then
		player.Damage = player.Damage * mod.GetPakChoiMultiplier(player)
	end
end, CacheFlag.CACHE_DAMAGE)

mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE, CallbackPriority.LATE, function(_, player)
	if player:HasCollectible(pakChoi) then
		player.MoveSpeed = player.MoveSpeed * mod.GetPakChoiMultiplier(player)
	end
end, CacheFlag.CACHE_SPEED)

mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE, CallbackPriority.LATE, function(_, player)
	if player:HasCollectible(pakChoi) then
		player.ShotSpeed = player.ShotSpeed * mod.GetPakChoiMultiplier(player)
	end
end, CacheFlag.CACHE_SHOTSPEED)

mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE, CallbackPriority.LATE, function(_, player)
	if player:HasCollectible(pakChoi) then
		player.TearRange = player.TearRange * mod.GetPakChoiMultiplier(player)
		player.TearHeight = player.TearHeight * mod.GetPakChoiMultiplier(player)
	end
end, CacheFlag.CACHE_RANGE)

mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE, CallbackPriority.LATE, function(_, player)
	if player:HasCollectible(pakChoi) then
		player.Luck = player.Luck * mod.GetPakChoiMultiplier(player)
	end
end, CacheFlag.CACHE_LUCK)

mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE, CallbackPriority.IMPORTANT, function(_, player)
	if player:HasCollectible(pakChoi) or player:GetPlayerType() == mod.PLAYER.CHINA then
		player.SizeMulti = Vector.One -- :,)
	end
end, CacheFlag.CACHE_SIZE)

mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE, CallbackPriority.LATE, function(_, player)
	if player:HasCollectible(pakChoi) and not player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_MEGA_MUSH) then -- You couldn't fit through doors with Mega Mush active lmao
		player.SizeMulti = player.SizeMulti * (mod.GetPakChoiMultiplier(player))
	end
end, CacheFlag.CACHE_SIZE)

mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CUSTOM_CACHE, CallbackPriority.LATE, function(_, player, cache, value)
	return math.floor(value * mod.PAK_CHOI_BOOST ^ PlayerManager.GetNumCollectibles(pakChoi))
end, "maxcoins")

mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CUSTOM_CACHE, CallbackPriority.LATE, function(_, player, cache, value)
	return math.floor(value * mod.PAK_CHOI_BOOST ^ PlayerManager.GetNumCollectibles(pakChoi))
end, "maxbombs")

mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CUSTOM_CACHE, CallbackPriority.LATE, function(_, player, cache, value)
	return math.floor(value * mod.PAK_CHOI_BOOST ^ PlayerManager.GetNumCollectibles(pakChoi))
end, "maxkeys")

mod:AddPriorityCollectibleCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, CallbackPriority.LATE, pakChoi, function(_, player)
	local pakChoiPower = mod.GetPakChoiMultiplier(player)
	if pakChoiPower == 1 then return end

	local rng = player:GetCollectibleRNG(pakChoi)
	local effects = player:GetEffects()
	local roomEffects = game:GetRoom():GetEffects()
	local data = getSafeData(player, false)
	local persistentData = getSafeData(player, true)
	local immaculateState = player:GetImmaculateConceptionState()
	local cambionState = player:GetCambionConceptionState()

	player.Mass = math.min(1000, player.Mass * pakChoiPower) -- Why did they make Gnawed Leaf the way they did. What were they thinking

	if player:GetMovementJoystick():Length() == 0 then -- Prioritise ***gamefeel***, Friction actively lowers movement speed which just kinda feels wrong
		if not mod:GetEntityData(player).MaliceMinion then
			player.Friction = player.Friction / pakChoiPower -- Friction works backwards how you'd expect it to, trust this is technically x1.09
		end
	end

	for method, set in pairs({
		GetCollectibleEffect = {
			{Key = "lastShadows", ID = CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS},
			{Key = "lastGamekid", ID = CollectibleType.COLLECTIBLE_GAMEKID},
			{Key = "lastUnicorn", ID = CollectibleType.COLLECTIBLE_MY_LITTLE_UNICORN},
			{Key = "lastUnicornStump", ID = CollectibleType.COLLECTIBLE_UNICORN_STUMP},
			{Key = "lastMegaMush", ID = CollectibleType.COLLECTIBLE_MEGA_MUSH},
			{Key = "lastDarkArts", ID = CollectibleType.COLLECTIBLE_DARK_ARTS},
		},

		GetNullEffect = {
			{Key = "lastSpiritShackles", ID = NullItemID.ID_SPIRIT_SHACKLES_SOUL},
			{Key = "lastReverseMagician", ID = NullItemID.ID_REVERSE_MAGICIAN},
			{Key = "lastReversePriestess", ID = NullItemID.ID_REVERSE_HIGH_PRIESTESS},
			{Key = "lastReverseEmpress", ID = NullItemID.ID_REVERSE_EMPRESS},
			{Key = "lastReverseChariot", ID = NullItemID.ID_REVERSE_CHARIOT},
			{Key = "lastReverseHangedMan", ID = NullItemID.ID_REVERSE_HANGED_MAN},
			{Key = "lastReverseDevil", ID = NullItemID.ID_REVERSE_DEVIL},
		}
	}) do
		for _, info in pairs(set) do
			local effect = effects[method](effects, info.ID)

			if data[info.Key] and effect and effect.Cooldown > data[info.Key] then
				local diff = effect.Cooldown - data[info.Key]
				-- print("pre:", effect.Cooldown, diff)
				effect.Cooldown = effect.Cooldown + math.floor(diff * (pakChoiPower - 1))
				-- print("post:", effect.Cooldown)
			end

			data[info.Key] = effect and effect.Cooldown or 0
		end
	end

	if not data.lastHadAstralProjection and roomEffects:GetCollectibleEffect(CollectibleType.COLLECTIBLE_ASTRAL_PROJECTION) then
		local effect = roomEffects:GetCollectibleEffect(CollectibleType.COLLECTIBLE_ASTRAL_PROJECTION)
		effect.Cooldown = math.floor(effect.Cooldown * pakChoiPower)
	end

	if data.lastCamoUndiesBoost and effects:GetNullEffectNum(NullItemID.ID_CAMO_BOOST) > data.lastCamoUndiesBoost then
		local diff = effects:GetNullEffectNum(NullItemID.ID_CAMO_BOOST) - data.lastCamoUndiesBoost
		effects:AddNullEffect(NullItemID.ID_CAMO_BOOST, true, math.floor(diff * (pakChoiPower - 1)))
	end

	if not data.lastHadInvulnerability and player:GetDamageCooldown() > 0 then
		player:SetMinDamageCooldown(math.floor(player:GetDamageCooldown() * pakChoiPower))
	end

	if data.lastIBSCharge and data.lastIBSCharge < player.IBSCharge then
		local diff = player.IBSCharge - data.lastIBSCharge
		player.IBSCharge = player.IBSCharge + diff * (pakChoiPower - 1)
	end

	if data.lastMegaBlastDuration and data.lastMegaBlastDuration < player:GetMegaBlastDuration() then
		player:SetMegaBlastDuration(math.floor(player:GetMegaBlastDuration() * pakChoiPower))

		for _, laser in pairs(Isaac.FindByType(7, 6, 0)) do
			if laser.FrameCount == 0 and laser.SpawnerEntity.InitSeed == player.InitSeed then
				laser:ToLaser().Timeout = player:GetMegaBlastDuration()
			end
		end
	end

	if data.lastRedStewDuration and data.lastRedStewDuration < player:GetRedStewBonusDuration() then
		player:SetRedStewBonusDuration(math.floor(player:GetRedStewBonusDuration() * pakChoiPower))
	end

	if data.lastBombPlaceDelay and data.lastBombPlaceDelay < player:GetBombPlaceDelay() then
		player:SetBombPlaceDelay(math.ceil(player:GetBombPlaceDelay() / pakChoiPower))
	end

	if player:HasCollectible(CollectibleType.COLLECTIBLE_IMMACULATE_CONCEPTION) and (data.lastImmaculateState or 9e9) < immaculateState then -- Immaculate Pregnancy
		persistentData.immaculateBoost = persistentData.immaculateBoost + (immaculateState - data.lastImmaculateState) * (pakChoiPower - 1)

		if persistentData.immaculateBoost >= 1 then
			player:SetImmaculateConceptionState((immaculateState + 1) % 15)
			persistentData.immaculateBoost = persistentData.immaculateBoost - 1

			if shouldGrantImmaculateBaby(player) then -- Since Immaculate Conception triggers EVERY 15 hearts, this will eventually trigger
				local options = getValidImmaculateFlags(player)

				-- See Cambion Conception for explanation
				local choice = #options > 0 and options[rng:RandomInt(#options) + 1] or 0
				local pass = Isaac.RunCallback(ModCallbacks.MC_PRE_PLAYER_GIVE_BIRTH_IMMACULATE, player, choice)

				if (pass == nil or pass) and #options > 0 then
					player:SetConceptionFamiliarFlags(player:GetConceptionFamiliarFlags() | choice)
					player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS, true)
				end

				Isaac.Spawn(5, 10, 3, game:GetRoom():FindFreePickupSpawnPosition(player.Position), Vector.Zero, player)
			end

			player:UpdateIsaacPregnancy()
		end
	end

	if player:HasCollectible(CollectibleType.COLLECTIBLE_CAMBION_CONCEPTION) and (data.lastCambionState or 9e9) < cambionState then -- Cambrion Pregnancy
		persistentData.cambionBoost = persistentData.cambionBoost + (cambionState - data.lastCambionState) * (pakChoiPower - 1)

		if persistentData.cambionBoost >= 1 then
			player:SetCambionConceptionState(cambionState + 1)
			persistentData.cambionBoost = persistentData.cambionBoost - 1

			if shouldGrantCambionBaby(player) then -- This doesn't proc if you picked up Pak Choi first, but might if you picked Cambion first
				local options = getValidCambionFlags(player)

				-- If there are no valid vanilla options the callback still needs to proc for modded familiar support
				-- Pass a familiarFlag that isn't used so that mods which want to do 1:1 replacements don't accidentally proc, but the callback is still called for weight-based extention
				local choice = #options > 0 and options[rng:RandomInt(#options) + 1] or 0
				local pass = Isaac.RunCallback(ModCallbacks.MC_PRE_PLAYER_GIVE_BIRTH_CAMBION, player, choice)

				if (pass == nil or pass) and #options > 0 then -- I hate you return false callbacks
					player:SetConceptionFamiliarFlags(player:GetConceptionFamiliarFlags() | choice)
					player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS, true)
				end
			end

			player:UpdateIsaacPregnancy(true)
		end
	end

	--[[for i = ActiveSlot.SLOT_PRIMARY, ActiveSlot.SLOT_POCKET do -- 4.5 Volt, not really sure how to track properly atm
		local activeItemDesc = player:GetActiveItemDesc(i)
	end]]

	data.lastImmaculateState = player:GetImmaculateConceptionState()
	data.lastCambionState = player:GetCambionConceptionState()
	data.lastHadInvulnerability = player:GetDamageCooldown() > 0
	data.lastIBSCharge = player.IBSCharge
	data.lastMegaBlastDuration = player:GetMegaBlastDuration()
	data.lastRedStewDuration = player:GetRedStewBonusDuration()
	data.lastBombPlaceDelay = player:GetBombPlaceDelay()
	data.lastHadAstralProjection = roomEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_ASTRAL_PROJECTION)
	data.lastCamoUndiesBoost = effects:GetNullEffectNum(NullItemID.ID_CAMO_BOOST)
end)

mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, function(_, _, _, _, _, _, player)
	getSafeData(player, false).lastCambionState = 0
end, CollectibleType.COLLECTIBLE_CAMBION_CONCEPTION)

mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, function(_, _, _, _, _, _, player)
	getSafeData(player, false).lastImmaculateState = 0
end, CollectibleType.COLLECTIBLE_IMMACULATE_CONCEPTION)

mod:AddPriorityCallback(ModCallbacks.MC_POST_DEVIL_CALCULATE, CallbackPriority.LATE, function(_, chance)
	return chance * mod.PAK_CHOI_BOOST ^ PlayerManager.GetNumCollectibles(pakChoi)
end)

mod:AddPriorityCallback(ModCallbacks.MC_POST_PLANETARIUM_CALCULATE, CallbackPriority.LATE, function(_, chance)
	return chance * mod.PAK_CHOI_BOOST ^ PlayerManager.GetNumCollectibles(pakChoi)
end)

mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, function(_, item, charge, firstPick, slot, varData, player)
	local persistentData = mod.GetPersistentPlayerData(player)

	-- We fucking love floating point numbers we fucking love floating point numbers we fucking love floating point numbers we fucking love foating point numbers
	-- All i want is a 1 decimal point truncation but floating point numbers want me to commit crimes against humanity instead
	local coinsToAdd = (player:GetNumCoins() + mod:GetFractionalCoins()) * 0.09
	mod:AddFractionalCoins(truncate(coinsToAdd, 1))

	local bombsToAdd = (player:GetNumBombs() + mod.GetFractionalBombs()) * 0.09
	mod.AddFractionalBombs(truncate(bombsToAdd, 1))

	local keysToAdd = (player:GetNumKeys() + mod.GetFractionalKeys()) * 0.09
	mod.AddFractionalKeys(truncate(keysToAdd, 1))

	local manaToAdd = (player:GetPoopMana() + mod.GetFractionalMana()) * 0.09
	mod.AddFractionalMana(truncate(manaToAdd, 1))

	local containersToAdd = math.floor(player:GetEffectiveMaxHearts() / 2 * 0.09)
	if player:GetMaxHearts() > 0 then
		player:AddMaxHearts(containersToAdd * 2)
	elseif player:GetBoneHearts() > 0 then
		player:AddBoneHearts(containersToAdd)
	else
		player:AddMaxHearts(containersToAdd * 2)
	end

	-- Rotten Hearts count for 2, Morbid Hearts count for 3. I'm sorry
	local hearts = player:GetHearts()
	local morbids = mod.GetMorbidHeartsNum(player)
	local morbidBoost = math.ceil((morbids - 1) / 3)
	hearts = hearts + morbidBoost
	hearts = math.floor(hearts * 0.09)

	if getExclusiveRedHearts(player) > 0 then
		player:AddHearts(hearts)
	elseif player:GetRottenHearts() > 0 then
		player:AddRottenHearts(hearts)
	elseif mod.GetMorbidHeartsNum(player) > 0 then
		mod:AddMorbidHearts(player, hearts)
	end

	local armour = math.floor(player:GetSoulHearts() * 0.09)
	if getExclusiveSoulHearts(player) > 0 then
		player:AddSoulHearts(armour)
	elseif mod.GetImmoralHeartsNum(player) > 0 then
		mod:AddImmoralHearts(player, armour)
	elseif player:GetBlackHearts() > 0 then
		player:AddBlackHearts(armour)
	else -- Failsafe, this shouldn't ever happen
		player:AddSoulHearts(armour)
	end

	player:AddGoldenHearts(math.floor(player:GetGoldenHearts() * 0.09))
	player:AddBrokenHearts(math.floor(player:GetBrokenHearts() * 0.09)) -- I mean why not really, technically it's possible to pull this off and survive if you're Maggie with Birthright
	player:AddBloodCharge(math.floor(player:GetBloodCharge() * 0.09))
	player:AddSoulCharge(math.floor(player:GetSoulCharge() * 0.09))

	local lives = math.floor(player:GetExtraLives() * 0.09)
	for i = 1, lives do player:AddNullItemEffect(nullReviver, false) end

	player:AddUrnSouls(math.floor(player:GetUrnSouls() * 0.09))
	player:AddJarFlies(math.floor(player:GetJarFlies() * 0.09))

	player:AddGigaBombs(math.floor(player:GetNumGigaBombs() * 0.09))
	persistentData.FFCopperBombsStored = math.floor((persistentData.FFCopperBombsStored or 0) * mod.PAK_CHOI_BOOST)
end, pakChoi)

mod:AddPriorityCallback(ModCallbacks.MC_PLAYER_GET_HEART_LIMIT, CallbackPriority.LATE, function(_, player, limit, ignoreModifiers)
	if player:HasCollectible(pakChoi) then
		if ignoreModifiers then
			return math.floor(limit / 2 * mod.GetPakChoiMultiplier(player)) * 2
		else
			-- i need whatever the limit is before broken hearts cause basegame forces it above zero before this callback
			-- basegame has a way of getting this (it's literally just a parameter to getheartlimit) but it's not exposed in the api
			-- so
			local ptype = player:GetPlayerType()
			local realLimit = 24
			if player.Variant == 0 then
				local effects = player:GetEffects()
				if ptype == PlayerType.PLAYER_THEFORGOTTEN and effects:HasNullEffect(NullItemID.ID_SOUL_FORGOTTEN) then
					realLimit = 6
				elseif ptype == PlayerType.PLAYER_ESAU and effects:HasNullEffect(NullItemID.ID_SOUL_JACOB) then
					realLimit = 4
				elseif ptype == PlayerType.PLAYER_THEFORGOTTEN or ptype == PlayerType.PLAYER_THESOUL then
					realLimit = 12
				end
			elseif player.Variant ~= 1 then
				local ptype = player:GetPlayerType()
				if ptype == PlayerType.PLAYER_THEFORGOTTEN or ptype == PlayerType.PLAYER_THESOUL then
					realLimit = 12
				end
			else
				realLimit = 12
			end
			if ptype == PlayerType.PLAYER_MAGDALENE and player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
				realLimit = realLimit + 12
			end
			realLimit = Isaac.RunCallbackWithParam(ModCallbacks.MC_PLAYER_GET_HEART_LIMIT, ptype, player, realLimit, true) or realLimit
			-- why is keeper hp limit stuff considered a modifier?
			if ptype == PlayerType.PLAYER_KEEPER or ptype == PlayerType.PLAYER_KEEPER_B then
				if ptype == PlayerType.PLAYER_KEEPER then
					realLimit = 3 + ((player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and 1) or 0)
				elseif ptype == PlayerType.PLAYER_KEEPER_B then
					realLimit = 2
				end
				realLimit = realLimit + player:GetGreedsGulletHearts() * 2
				if player:HasCollectible(CollectibleType.COLLECTIBLE_GREEDS_GULLET) then
					local coins = player:GetNumCoins()
					local addedHearts = math.floor(coins / 25)
					if coins == 99 then
						addedHearts = addedHearts + 1
					end
					realLimit = realLimit + addedHearts * 2
				end
				realLimit = math.floor(realLimit * mod.GetPakChoiMultiplier(player)) * 2
			end
			
			local brokenHearts = player:GetBrokenHearts()
			return realLimit - brokenHearts * 2
		end
	end
end)

function mod:pakChoiTearHitParams(player, tearparams, weapontype, damagescale, teardisplacement, source)
	tearparams.TearScale = tearparams.TearScale * mod.GetPakChoiMultiplier(player)
end
mod:AddPriorityCollectibleCallback(ModCallbacks.MC_EVALUATE_TEAR_HIT_PARAMS, CallbackPriority.LATE, pakChoi, mod.pakChoiTearHitParams)

mod:AddPriorityCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, CallbackPriority.LATE, function(_, knife)
	local player = knife.Parent and knife.Parent:ToPlayer()

	if player then
		local power = mod.GetPakChoiMultiplier(player)
		local data = mod:GetEntityData(knife)
		data.lastFramePakChoiPower = data.lastFramePakChoiPower or 1

		knife.SpriteScale = knife.SpriteScale / data.lastFramePakChoiPower
		knife.SpriteScale = knife.SpriteScale * power
		data.lastFramePakChoiPower = power

		if not mod.IsKnifeSwingable(knife) then
			knife.SizeMulti = knife.SpriteScale
		end
	end
end)

-- Called from `ffscripts/revives.lua`
function mod.TryPakChoiRevive(player, data, effects)
	if effects:HasNullEffect(nullReviver) then
		effects:RemoveNullEffect(nullReviver)

		-- This revive should be pretty damn good given how hard it is to get
		Isaac.CreateTimer(function()
			local containers = player:GetMaxHearts()
			if containers < 12 then
				player:AddMaxHearts(12 - containers)
			end

			fullHeal(player)
			player:AnimateCollectible(pakChoi, "UseItem")
		end, 1, 1, true)

		player:SetMinDamageCooldown(120)
		player:Revive()
	end
end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, familiar)
	local data = getSafeData(familiar)
	local power = mod.GetPakChoiMultiplier(familiar.Player)
	data.lastPower = data.lastPower or 1

	if power ~= data.lastPower then
		familiar.OrbitDistance = familiar.OrbitDistance / data.lastPower
		familiar.OrbitDistance = familiar.OrbitDistance * power

		familiar.OrbitSpeed = familiar.OrbitSpeed / data.lastPower
		familiar.OrbitSpeed = familiar.OrbitSpeed * power
	end

	data.lastPower = power
end, FamiliarVariant.GUILLOTINE)

mod:AddCollectibleCallback(ModCallbacks.MC_POST_EFFECT_INIT, pakChoi, function(_, effect)
	if EntityEffect.IsPlayerCreep(effect.Variant) and effect.SpawnerEntity and effect.SpawnerEntity.Type == 1 then
		local power = mod.GetPakChoiMultiplier(effect.SpawnerEntity:ToPlayer())
		if power == 1 then return end

		effect.Timeout = math.floor(effect.Timeout * power)
		effect.CollisionDamage = effect.CollisionDamage * power -- For some reason this doesn't work specifically for Aquarius Creep whatever man

		Isaac.CreateTimer(function()
			effect.SpriteScale = effect.SpriteScale * power -- For some reason actually doing this on init does bad things with big mults idk man ask the fish
		end, 1, 1, false)
	end
end)

mod:AddPriorityCallback(ModCallbacks.MC_PLAYER_GET_ACTIVE_MAX_CHARGE, CallbackPriority.LATE, function(_, item, player, vardata, charge)
	if player:HasCollectible(pakChoi) and Isaac.GetItemConfig():GetCollectible(item).ChargeType == ItemConfig.CHARGE_TIMED then
		return math.ceil(charge / mod.GetPakChoiMultiplier(player))
	end
end)

mod:AddPriorityCallback(ModCallbacks.MC_POST_PLAYER_USE_BOMB, CallbackPriority.LATE, function(_, player, bomb)
	-- Notably Dr. Fetus bombs are excluded on purpose, since they already scale with Isaac's increased Damage stat
	
	if player:HasCollectible(pakChoi) then
		bomb.ExplosionDamage = bomb.ExplosionDamage * mod.GetPakChoiMultiplier(player)
	end
end)

mod:AddPriorityCallback(ModCallbacks.MC_POST_BOMB_INIT, CallbackPriority.LATE, function(_, bomb) -- Best Friend
	if bomb.SpawnerEntity and bomb.SpawnerEntity.Type == 1 then
		local player = bomb.SpawnerEntity:ToPlayer()
		bomb.ExplosionDamage = bomb.ExplosionDamage * mod.GetPakChoiMultiplier(player)
	end
end, BombVariant.BOMB_DECOY)

mod:AddPriorityCallback(ModCallbacks.MC_POST_BOMB_INIT, CallbackPriority.LATE, function(_, bomb) -- Mr. Boom
	if bomb.SpawnerEntity and bomb.SpawnerEntity.Type == 1 then
		local player = bomb.SpawnerEntity:ToPlayer()
		bomb.ExplosionDamage = bomb.ExplosionDamage * mod.GetPakChoiMultiplier(player)
	end
end, BombVariant.BOMB_BIG)

--[[mod:AddPriorityCallback(ModCallbacks.MC_POST_TEAR_INIT, CallbackPriority.LATE, function(_, tear) -- Mr. Boom
	if tear.SpawnerEntity and tear.SpawnerEntity.Type == 1 then
		local player = tear.SpawnerEntity:ToPlayer()
		print("how's it going", tear.CollisionDamage)
		-- bomb.ExplosionDamage = bomb.ExplosionDamage * 1.09 ^ player:GetCollectibleNum(pakChoi)
	end
end, TearVariant.BOBS_HEAD)]]

-- Tracks: Necronomicon, Black Hearts, Magic Fingers, Blood Rights, Sharp Straw
-- Tracks: Virus, Aries, Gamekid, My Little Unicorn, Tooth and Nail
local trackPakChoiIncreaseDamage 

-- Theoretically these should account for literally any item which damages enemies on-use. If it causes problems just let me know ig
mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, function(_, _, _, player)
	if player:HasCollectible(pakChoi) then
		trackPakChoiIncreaseDamage = player
	end
end)

mod:AddPriorityCallback(ModCallbacks.MC_USE_ITEM, CallbackPriority.LATE, function()
	trackPakChoiIncreaseDamage = nil
end)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, CallbackPriority.LATE, function(_, player)
	if player:HasCollectible(pakChoi) then
		trackPakChoiIncreaseDamage = player
	end
end)

mod:AddPriorityCallback(ModCallbacks.MC_POST_PLAYER_COLLISION, CallbackPriority.LATE, function()
	trackPakChoiIncreaseDamage = nil
end)

mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CallbackPriority.LATE, function(_, entity, damage, flags, source, cooldown)
	if trackPakChoiIncreaseDamage and entity.Type ~= 1 then
		return {Damage = damage * mod.PAK_CHOI_BOOST ^ trackPakChoiIncreaseDamage:GetCollectibleNum(pakChoi)}
	end
end)

local noLoop = true
mod:AddPriorityCollectibleCallback(TearFlagsLib.Callback.POST_POLL_TEARFLAGS, CallbackPriority.EARLY, pakChoi, function(_, entity, player, weaponFlag)
	if noLoop and player:HasCollectible(pakChoi) then
		local chance = mod.GetPakChoiMultiplier(player) - 1
		local rng = player:GetCollectibleRNG(pakChoi)

		if rng:RandomFloat() < chance then
			noLoop = false
			Isaac.RunCallbackWithParam(TearFlagsLib.Callback.POLL_TEARFLAGS, weaponFlag, entity, player, weaponFlag)
			noLoop = true
		end
	end
end)

mod:AddPriorityCollectibleCallback(ModCallbacks.MC_EVALUATE_TEAR_HIT_PARAMS, CallbackPriority.EARLY, pakChoi, function(_, player, params, weaponType, damageScale, tearDisplacement, source)
	if noLoop and player:HasCollectible(pakChoi) then
		local chance = mod.GetPakChoiMultiplier(player) - 1
		local rng = player:GetCollectibleRNG(pakChoi)

		if rng:RandomFloat() < chance or true then
			noLoop = false
			local params2 = player:GetTearHitParams(weaponType, damageScale, tearDisplacement, source)
			noLoop = true

			params.TearFlags = params.TearFlags | params2.TearFlags

			if params.TearVariant == TearVariant.BLUE then
				params.TearVariant = params2.TearVariant
			end

			params.TearDamage = math.max(params.TearDamage, params2.TearDamage) -- Lowkey i cba to figure out a proper way to tell if your damage should go up/down and by how much, so just take the bigger one
			params.TearColor = params.TearColor * params2.TearColor -- This is also not correct
		end
	end
end)

local centOffset = Vector(20, 0)
local decimalOffsets = {Vector(15, 5), Vector(14.5, 6), Vector(13.5, 5), Vector(13, 5)}
local fractionalOffset = Vector(30, 0)

mod:AddPriorityCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, CallbackPriority.EARLY, function(_, pickup)
	if pickup.SubType == pakChoi and pickup.Price > 0 then
		local sprite = pickup:GetPriceSprite()
		local cent = sprite:GetLayer(2)
		cent:SetPos(centOffset)
	end
end, 100)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_RENDER, function(_, pickup)
	if pickup.SubType == pakChoi and pickup.Price > 0 then
		local renderMode = game:GetRoom():GetRenderMode()
		if renderMode == RenderMode.RENDER_NORMAL or renderMode == RenderMode.RENDER_WATER_ABOVE then
			
			local realPrice = pickup.Price * mod.PAK_CHOI_BOOST
			local partialPrice = realPrice * 10 // 1 % 10
			local intPrice = math.floor(realPrice)

			if partialPrice then
				local sprite = pickup:GetPriceSprite()
				local layer = sprite:GetLayer(1)

				-- Do not talk to me
				-- This is stupid and looks bad and mixely, but this is literally a joke that no other thing will ever use
				-- I doubt anyone will ever even see this naturally
				-- So I don't care anymore, my efforts to make it look better without modifying the spritesheet were a roaring failure

				-- Let the sharks eat me

				-- Captain's Log 27/11/2024

				sprite:SetLayerFrame(1, 0)

				layer:SetSize(Vector.One * 0.3)
				for i = 1, 4 do
					sprite:RenderLayer(1, Isaac.WorldToScreen(pickup.Position + decimalOffsets[i]))
				end
				layer:SetSize(Vector.One)

				sprite:SetLayerFrame(1, partialPrice)
				sprite:RenderLayer(1, Isaac.WorldToScreen(pickup.Position + fractionalOffset))
				
				sprite:SetLayerFrame(1, realPrice % 10 // 1)
				sprite:SetLayerFrame(0, realPrice / 10 // 1)
			end
		end
	end
end, 100)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, CallbackPriority.EARLY, function(_, pickup, collider)
	if pickup.SubType == pakChoi and pickup.Price > 0 and collider.Type == 1 and collider.Variant == PlayerVariant.PLAYER then
		local player = Isaac.GetPlayer()
		if not player:IsExtraAnimationFinished() or not player:CanPickupItem() then return true end

		local coins = player:GetNumCoins() + mod.GetFractionalCoins()
		local realPrice = truncate(pickup.Price * mod.PAK_CHOI_BOOST, 1)

		if coins < realPrice then return true end

		mod:AddFractionalCoins(pickup.Price - realPrice)
	end
end, 100)