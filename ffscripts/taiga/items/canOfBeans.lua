-- Can of Beans --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local flag = TearFlagsLib.RegisterTearFlag("BEANS")

local baseFartRadius = 80
local falloffFartRadius = 20
local falloffPow = 1.5
local impactDamageFrames = 6
local impactDamageCooldown = 6
local impactDamageBase = 2.5
local impactDamageStage = 0.5
local minFartCooldown = 4
local flagsExcludedFromFart = TearFlags.TEAR_SPLIT | TearFlags.TEAR_EXPLOSIVE |
                              TearFlags.TEAR_QUADSPLIT | TearFlags.TEAR_MYSTERIOUS_LIQUID_CREEP |
                              TearFlags.TEAR_EGG | TearFlags.TEAR_BONE |
                              TearFlags.TEAR_ABSORB | TearFlags.TEAR_LASERSHOT |
                              TearFlags.TEAR_HYDROBOUNCE | TearFlags.TEAR_BURSTSPLIT |
                              TearFlags.TEAR_RIFT

mod.CAN_OF_BEANS = {}

-- ignore triggering the fart when the weapon applies tearflag effects to an entity
mod.CAN_OF_BEANS.IGNORE_APPLY = TearFlagsLib.WeaponFlag.DR_FETUS |
                                TearFlagsLib.WeaponFlag.EPIC_FETUS |
                                TearFlagsLib.WeaponFlag.CLUB_EPIC_FETUS

-- ignore the rule where enemies already hit by the main attack can't be hit by the fart
mod.CAN_OF_BEANS.ALLOW_HITTING_APPLIED_ENEMIES = TearFlagsLib.WeaponFlag.SWORD

-- trigger the fart when the weapon explodes
mod.CAN_OF_BEANS.ON_EXPLODE = TearFlagsLib.WeaponFlag.DR_FETUS |
                              TearFlagsLib.WeaponFlag.EPIC_FETUS |
                              TearFlagsLib.WeaponFlag.CLUB_EPIC_FETUS

-- do not cache the fart trigger when the weapon applies tearflag effects, instead immediately perform the fart
-- (should only be used with weapons that hit once then remove themselves before cached farts would occur in POST_UPDATE, 
-- otherwise creates issues)
mod.CAN_OF_BEANS.FART_IMMEDIATELY = TearFlagsLib.WeaponFlag.DARK_ARTS

-- cache the fart trigger but apply it in MC_POST_BRIMSTONE_SNEEZE instead of MC_POST_UPDATE
-- should only be used for hemoptysis
mod.CAN_OF_BEANS.FART_ON_POST_SNEEZE = TearFlagsLib.WeaponFlag.HEMOPTYSIS

-- only allow the weapon to fart once during it's lifetime
mod.CAN_OF_BEANS.FART_ONCE = TearFlagsLib.WeaponFlag.CLUB |
                             TearFlagsLib.WeaponFlag.DARK_ARTS |
                             TearFlagsLib.WeaponFlag.BRIMSTONE_BALL

-- weapon farts for every enemy hit, instead of only once per frame
mod.CAN_OF_BEANS.FART_PER_ENEMY = TearFlagsLib.WeaponFlag.LASER

-- allow each enemy hit to have their own damage used for the fart calc instead of all using the same
-- only works with fart per enemy flag
mod.CAN_OF_BEANS.USE_ENEMY_SPECIFIC_DAMAGE = TearFlagsLib.BitSetInfinity.Zero

-- weapon fart cooldown is separate for each enemy, but weapon still only farts once per frame
mod.CAN_OF_BEANS.FART_COOLDOWN_PER_ENEMY = TearFlagsLib.WeaponFlag.KNIFE |
                                           TearFlagsLib.WeaponFlag.FF_MALICE

-- weapon farts from the enemy's position instead of the weapon's position
mod.CAN_OF_BEANS.FART_FROM_ENEMY_POS = TearFlagsLib.WeaponFlag.LASER

-- move fart position to the closest point along the laser
mod.CAN_OF_BEANS.MOVE_FART_TO_LASER = TearFlagsLib.WeaponFlag.LASER

-- move fart position to the closest point along the club
mod.CAN_OF_BEANS.MOVE_FART_TO_CLUB = TearFlagsLib.WeaponFlag.CLUB

-- use the player's maxfiredelay as the cooldown instead of the default 4 frames
mod.CAN_OF_BEANS.FART_ON_FIREDELAY = TearFlagsLib.WeaponFlag.KNIFE |
                                     TearFlagsLib.WeaponFlag.LASER |
                                     TearFlagsLib.WeaponFlag.AQUARIUS |
                                     TearFlagsLib.WeaponFlag.ANTI_GRAV_LASER

-- weapon uses player's colors (TearColor/LaserColor) and not it's own entity's colors
mod.CAN_OF_BEANS.USE_PLAYERCOLOR = TearFlagsLib.WeaponFlag.HEMOPTYSIS

-- weapon uses EntityPlayer.LaserColor and farts should treat the weapon's color as such
mod.CAN_OF_BEANS.USE_LASERCOLOR = TearFlagsLib.WeaponFlag.LASER |
                                  TearFlagsLib.WeaponFlag.BRIMSTONE_BALL |
                                  TearFlagsLib.WeaponFlag.ANTI_GRAV_LASER |
                                  TearFlagsLib.WeaponFlag.HEMOPTYSIS

-- farts should get their colors from explosion entities instead of the base weapon entity
mod.CAN_OF_BEANS.USE_EXPLOSION_COLOR = TearFlagsLib.WeaponFlag.DR_FETUS |
                                       TearFlagsLib.WeaponFlag.EPIC_FETUS

-- farts should get their colors from Entity.Color instead of Sprite.Color
-- on aquarius, specifically, spritecolor has some weird processing applied to it, while entity.color is just the tearcolor, way nicer
mod.CAN_OF_BEANS.USE_ENTITY_COLOR = TearFlagsLib.WeaponFlag.AQUARIUS

local LUM_R, LUM_G, LUM_B = 0.212671, 0.715160, 0.072169 -- luminance factors used for colorize operation

-- *********
-- * Stats *
-- *********

function mod:updateCanOfBeansRange(player)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.CAN_OF_BEANS) then
		if not (player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) or 
		        player:HasCollectible(CollectibleType.COLLECTIBLE_MONSTROS_LUNG) or
		        player:HasCollectible(CollectibleType.COLLECTIBLE_HAEMOLACRIA) or
		        player:HasCollectible(CollectibleType.COLLECTIBLE_CRICKETS_BODY))
		then
			player.TearRange = player.TearRange * 0.8
		end
	end
end
mod:AddPriorityCollectibleCallback(ModCallbacks.MC_EVALUATE_CACHE, CallbackPriority.LATE, FiendFolio.ITEM.COLLECTIBLE.CAN_OF_BEANS, mod.updateCanOfBeansRange, CacheFlag.CACHE_RANGE)

function mod:updateCanOfBeansFallAccel(player)
	-- trying to keep this item from sailing over rocks for as long as i can
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.CAN_OF_BEANS) then
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_MONSTROS_LUNG) then
			player.TearFallingAcceleration = math.max(player.TearFallingAcceleration, 0.8 / (2 ^ ((math.max(player.TearRange, 40.0) - 208.0) / 80.0)))
		end
	end
end
mod:AddPriorityCollectibleCallback(ModCallbacks.MC_EVALUATE_CACHE, math.huge, FiendFolio.ITEM.COLLECTIBLE.CAN_OF_BEANS, mod.updateCanOfBeansFallAccel, CacheFlag.CACHE_RANGE)

local function lerpColor(colorA, colorB, percent)
	local r = colorA.R * (1-percent) + colorB.R * percent
	local g = colorA.G * (1-percent) + colorB.G * percent
	local b = colorA.B * (1-percent) + colorB.B * percent
	local a = colorA.A * (1-percent) + colorB.A * percent
	local ro = colorA.RO * (1-percent) + colorB.RO * percent
	local go = colorA.GO * (1-percent) + colorB.GO * percent
	local bo = colorA.BO * (1-percent) + colorB.BO * percent
	
	local colorizeA = colorA:GetColorize()
	local colorizeB = colorB:GetColorize()
	local rc = colorizeA.R * (1-percent) + colorizeB.R * percent
	local gc = colorizeA.G * (1-percent) + colorizeB.G * percent
	local bc = colorizeA.B * (1-percent) + colorizeB.B * percent
	local ac = colorizeA.A * (1-percent) + colorizeB.A * percent
	
	return Color(r,g,b,a,ro,go,bo,rc,gc,bc,ac)
end

function mod:updateCanOfBeansTearLaserColor(player)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.CAN_OF_BEANS) then
		local lasercolor = player.LaserColor
		local lasercolorize = lasercolor:GetColorize()
		local beancolor = Color(1, 1, 1, lasercolor.A, lasercolor.RO, lasercolor.GO, lasercolor.BO,
		                        lasercolor.R * 3.81, lasercolor.G * 2.7, lasercolor.B * 2.28, 1)
		player.LaserColor = lerpColor(beancolor, lasercolor, lasercolorize.A)
	end
end
mod:AddPriorityCollectibleCallback(ModCallbacks.MC_EVALUATE_CACHE, math.huge, FiendFolio.ITEM.COLLECTIBLE.CAN_OF_BEANS, mod.updateCanOfBeansTearLaserColor, CacheFlag.CACHE_TEARCOLOR)

-- ***********
-- * Polling *
-- ***********

local function rollBeanSynergy(player, rng, entity)
	if rng:RandomFloat() <= 1 / math.max(1, 4 - math.floor(player.Luck / 4)) then
		local params = TearFlagsLib.GetTearFlagParams(entity, flag)
		TearFlagsLib.SetTearFlagParams(entity, flag, {IsBean = true, AdditionalFlags = (params.AdditionalFlags or TearFlags.TEAR_NORMAL) | TearFlags.TEAR_POISON})
	end
end

local function rollKidneyBeanSynergy(player, rng, entity)
	if rng:RandomFloat() <= 1 / math.max(1, 10 - math.floor(player.Luck / 3)) then
		local params = TearFlagsLib.GetTearFlagParams(entity, flag)
		TearFlagsLib.SetTearFlagParams(entity, flag, {IsKidneyBean = true, AdditionalFlags = (params.AdditionalFlags or TearFlags.TEAR_NORMAL) | TearFlags.TEAR_CHARM})
	end
end

local function rollHolyBeanSynergy(player, rng, entity)
	local chance = mod.AnathemaBal.BaseChanceVal + player.Luck / mod.AnathemaBal.ScaledChanceMult
	chance = math.min(math.max(mod.AnathemaBal.MinChanceVal, chance), mod.AnathemaBal.MaxChanceVal)
	if rng:RandomFloat() * mod.AnathemaBal.ChanceDivider <= chance then
		TearFlagsLib.SetTearFlagParams(entity, flag, {IsHolyBean = true})
		
		local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
		FiendFolio.FlagExcommunicate(entity, mod.AnathemaBal.BaseDuration * secondHandMultiplier, player.Damage)
	end
end

local function rollButterBeanSynergy(player, rng, entity)
	if rng:RandomFloat() <= 1 / math.max(1, 10 - math.ceil(player.Luck)) then
		TearFlagsLib.SetTearFlagParams(entity, flag, {IsButterBean = true})
	end
end

local function rollWaitWhatSynergy(player, rng, entity)
	if rng:RandomFloat() <= math.min(0.2, 1 / math.max(1, 25 - math.floor(player.Luck))) then
		TearFlagsLib.SetTearFlagParams(entity, flag, {IsWaitWhat = true})
	end
end

local function rollLingerBeanSynergy(player, rng, entity)
	if rng:RandomFloat() <= math.min(0.2, 1 / math.max(1, 30 - math.floor(player.Luck))) then
		TearFlagsLib.SetTearFlagParams(entity, flag, {IsLingerBean = true})
	end
end

local function rollMegaBeanSynergy(player, rng, entity, isClear)
	if rng:RandomFloat() <= math.min(0.1, 1 / math.max(1, 20 - player.Luck * 2/3)) then
		TearFlagsLib.SetTearFlagParams(entity, flag, {IsMegaBean = true})
	end
end

local function rollBlackEyedPeaSynergy(player, rng, entity)
	local chance = mod.RubberBulletsBal.BaseChanceVal + player.Luck / mod.RubberBulletsBal.ScaledChanceMult
	chance = math.min(math.max(mod.RubberBulletsBal.MinChanceVal, chance), mod.RubberBulletsBal.MaxChanceVal)
	if rng:RandomFloat() * mod.RubberBulletsBal.ChanceDivider <= chance then
		TearFlagsLib.SetTearFlagParams(entity, flag, {IsBlackEyedPea = true})
		
		local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
		FiendFolio.FlagBruise(entity, mod.RubberBulletsBal.BaseDuration * secondHandMultiplier, 1, 1)
	end
end

function mod:setupCanOfBeansInfo(entity, player, data, ignoreSynergies)
	local frame = game:GetFrameCount()
	local data = data or mod:GetEntityData(entity)
	data.FFBeansInfo = data.FFBeansInfo or {}
	if data.FFBeansInfo.LastPollFrame == frame then
		return data.FFBeansInfo
	end
	
	local enemyLastFartOnFrame = data.FFBeansInfo.EnemyLastFartOnFrame
	local didOneShot = data.FFBeansInfo.DidOneShot
	local lastFrameCanFarted = data.FFBeansInfo.LastFrameCanFarted
	local enemiesHitThisFrame = data.FFBeansInfo.EnemiesHitThisFrame
	
	data.FFBeansInfo = {}
	local beansInfo = data.FFBeansInfo
	
	beansInfo.EnemyLastFartOnFrame = enemyLastFartOnFrame
	beansInfo.DidOneShot = didOneShot
	beansInfo.LastFrameCanFarted = lastFrameCanFarted
	beansInfo.EnemiesHitThisFrame = enemiesHitThisFrame
	beansInfo.LastPollFrame = frame
	
	if player and not ignoreSynergies then
		local rng = player:GetCollectibleRNG(FiendFolio.ITEM.COLLECTIBLE.CAN_OF_BEANS)
		local isClear = game:GetRoom():IsClear()
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BEAN) then
			rollBeanSynergy(player, rng, entity)
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BLACK_BEAN) then
			rollBeanSynergy(player, rng, entity)
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_KIDNEY_BEAN) then
			rollKidneyBeanSynergy(player, rng, entity)
		end
		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.HOLY_BEAN) then
			rollHolyBeanSynergy(player, rng, entity)
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BUTTER_BEAN) then
			rollButterBeanSynergy(player, rng, entity)
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_WAIT_WHAT) then
			rollWaitWhatSynergy(player, rng, entity)
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_LINGER_BEAN) then
			rollLingerBeanSynergy(player, rng, entity)
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_MEGA_BEAN) then
			rollMegaBeanSynergy(player, rng, entity, isClear)
		end
		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.BLACK_EYED_PEA) then
			rollBlackEyedPeaSynergy(player, rng, entity)
		end
		if player:HasTrinket(FiendFolio.ITEM.TRINKET.RAINBOW_BEAN) then
			local rand = rng:RandomInt(8)
			if rand == 0 then
				rollBeanSynergy(player, rng, entity)
			elseif rand == 1 then
				rollKidneyBeanSynergy(player, rng, entity)
			elseif rand == 2 then
				rollHolyBeanSynergy(player, rng, entity)
			elseif rand == 3 then
				rollButterBeanSynergy(player, rng, entity)
			elseif rand == 4 then
				rollWaitWhatSynergy(player, rng, entity)
			elseif rand == 5 then
				rollLingerBeanSynergy(player, rng, entity)
			elseif rand == 6 then
				rollMegaBeanSynergy(player, rng, entity, isClear)
			elseif rand == 7 then
				rollBlackEyedPeaSynergy(player, rng, entity)
			end
		end
		if player:HasTrinket(FiendFolio.ITEM.ROCK.CANNED_FOSSIL) then
			local rand = rng:RandomInt(3)
			if rand == 0 then
				rollBeanSynergy(player, rng, entity)
			elseif rand == 1 then
				rollKidneyBeanSynergy(player, rng, entity)
			elseif rand == 2 then
				rollButterBeanSynergy(player, rng, entity)
			end
		end
	end
	
	return beansInfo
end

function mod:setupCanOfBeansFlagGeneric(entity, player, data)
	TearFlagsLib.AddTearFlags(entity, flag)
	TearFlagsLib.SetTearFlagParams(entity, flag, {Player = player, AdditionalFlags = TearFlags.TEAR_NORMAL})
	mod:setupCanOfBeansInfo(entity, player, data)
end

function mod:canOfBeansFlagGeneric(entity, player, weaponFlag)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.CAN_OF_BEANS) then
		local data = mod:GetEntityData(entity)
		mod:setupCanOfBeansFlagGeneric(entity, player, data)
		
		if weaponFlag == TearFlagsLib.WeaponFlag.TEAR or weaponFlag == TearFlagsLib.WeaponFlag.LUDOVICO_TEAR then
			mod:makeTearBloody(entity)
			data.FFBeansInfo = data.FFBeansInfo or {}
			data.FFBeansInfo.ColorTime = true
			mod:canOfBeansColorScheduled(entity)
		elseif weaponFlag == TearFlagsLib.WeaponFlag.BOBS_ROTTEN_HEAD then
			local params = TearFlagsLib.GetTearFlagParams(entity, flag)
			TearFlagsLib.SetTearFlagParams(entity, flag, {IsBean = true, AdditionalFlags = (params.AdditionalFlags or TearFlags.TEAR_NORMAL) | TearFlags.TEAR_POISON})
		elseif (weaponFlag == TearFlagsLib.WeaponFlag.DR_FETUS or weaponFlag == TearFlagsLib.WeaponFlag.EPIC_FETUS or weaponFlag == TearFlagsLib.WeaponFlag.CLUB_EPIC_FETUS) and
		       player:HasCollectible(CollectibleType.COLLECTIBLE_BOBS_CURSE)
		then
			TearFlagsLib.SetTearFlagParams(entity, flag, {IsBean = true})
		elseif weaponFlag == TearFlagsLib.WeaponFlag.FF_PLANET_X then
			mod:makePlanetXBloody(entity)
		end
	end
end
mod:AddPriorityCollectibleCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, -500, FiendFolio.ITEM.COLLECTIBLE.CAN_OF_BEANS, mod.canOfBeansFlagGeneric)
mod:AddPriorityCollectibleCallback(TearFlagsLib.Callback.POLL_CHANCELESS_TEARFLAGS, -500, FiendFolio.ITEM.COLLECTIBLE.CAN_OF_BEANS, mod.canOfBeansFlagGeneric)

function mod.handleBeansD3(entity)
	mod:setupCanOfBeansFlagGeneric(entity, TearFlagsLib.GetTearPlayer(entity))
	
	if entity.Type == EntityType.ENTITY_TEAR then
		local data = mod:GetEntityData(entity)
		data.FFBeansInfo = data.FFBeansInfo or {}
		data.FFBeansInfo.ColorTime = true
		mod:canOfBeansColorScheduled(entity)
	end
end

function mod:canOfBeansFlagLocust(entity, player)
	local data = mod:GetEntityData(entity)
	mod:setupCanOfBeansFlagGeneric(entity, player, data)
end
mod:AddEntityCallback(TearFlagsLib.Callback.POLL_LOCUST_TEARFLAGS, EntityType.ENTITY_FAMILIAR, FamiliarVariant.ABYSS_LOCUST, 
                      FiendFolio.ITEM.COLLECTIBLE.CAN_OF_BEANS, mod.canOfBeansFlagLocust, FiendFolio.ITEM.COLLECTIBLE.CAN_OF_BEANS)

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.CAN_OF_BEANS] = {
	FireCooldown = 46,
	TearDamage = 7.01,
	TearFallingSpeed = -10.981,
	TearFallingAccel = 0.8,
	BodyColor = Color(1,1,1,1,-27.991/255,-27.991/255,-30.531/255,0.655,0.655,0.788,1),
	EyeAColor = Color(1,1,1,1,-20.761/255,-59.018/255,-55.681/255,0.681,0.690,0.575,1),
	EyeBColor = Color(1,1,1,1,-20.761/255,-59.018/255,-55.681/255,0.681,0.690,0.575,1)}

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	TearFlagsLib.AddTearFlags(tear, TearFlagsLib.Flag.BEANS)
	TearFlagsLib.SetTearFlagParams(tear, flag, {Player = familiar.Player, AdditionalFlags = TearFlags.TEAR_NORMAL})
	
	local frame = game:GetFrameCount()
	local data = mod:GetEntityData(tear)
	data.FFBeansInfo = data.FFBeansInfo or {}
	if data.FFBeansInfo.LastPollFrame == frame then
		return
	end
	
	local enemyLastFartOnFrame = data.FFBeansInfo.EnemyLastFartOnFrame
	local didOneShot = data.FFBeansInfo.DidOneShot
	local lastFrameCanFarted = data.FFBeansInfo.LastFrameCanFarted
	local enemiesHitThisFrame = data.FFBeansInfo.EnemiesHitThisFrame
	
	data.FFBeansInfo = {}
	local beansInfo = data.FFBeansInfo
	
	beansInfo.EnemyLastFartOnFrame = enemyLastFartOnFrame
	beansInfo.DidOneShot = didOneShot
	beansInfo.LastFrameCanFarted = lastFrameCanFarted
	beansInfo.EnemiesHitThisFrame = enemiesHitThisFrame
	beansInfo.LastPollFrame = frame
	
	mod:makeTearBloody(tear)
	beansInfo.ColorTime = true
	mod:canOfBeansColorScheduled(tear)
	tear.Scale = tear.Scale * 1.21
end, FiendFolio.ITEM.COLLECTIBLE.CAN_OF_BEANS)

function mod:copyBeansFlag(copy, source, weaponFlag)
	local sdata = mod:GetEntityData(source)
	local cdata = mod:GetEntityData(copy)
	
	if sdata.FFBeansInfo then
		cdata.FFBeansInfo = cdata.FFBeansInfo or {}
		cdata.FFBeansInfo.LastPollFrame = sdata.FFBeansInfo.LastPollFrame
		cdata.FFBeansInfo.Color = (sdata.FFBeansInfo.Color and Color.Lerp(sdata.FFBeansInfo.Color, Color(), 0)) or nil
	end
	
	if weaponFlag == TearFlagsLib.WeaponFlag.TEAR or weaponFlag == TearFlagsLib.WeaponFlag.LUDOVICO_TEAR then
		mod:makeTearBloody(copy)
		cdata.FFBeansInfo.ColorTime = true
		mod:canOfBeansColorScheduled(copy)
	end
end
mod:AddCallback(TearFlagsLib.Callback.POST_COPY_TEARFLAGS, mod.copyBeansFlag, flag)

function FiendFolio.HasBeansFlag(entity)
	return TearFlagsLib.HasTearFlags(entity, flag)
end

function FiendFolio.GetBeansInfo(entity)
	local data = mod:GetEntityData(entity)
	data.FFBeansInfo = data.FFBeansInfo or {}
	return data.FFBeansInfo
end

function FiendFolio.GetBeansTearFlagParams(entity)
	return TearFlagsLib.GetTearFlagParams(entity, flag)
end

-- ***********
-- * Colours *
-- ***********

-- this is so unnecessary but i dont care
-- imma make a whole complex colour system for the fucking bean item
-- you cant stop me mwahahahbahhahahahhahahhahaahahhahhahhahhahahhaahhahaha
-- legumize the tear babyyyyyyyyyyyyy

function mod:getCanOfBeansColor(tearcolor, flagparams, isAquarius)
	local flagparams = flagparams or {}

	local tearRT, tearGT, tearBT  = tearcolor.R, tearcolor.G, tearcolor.B
	local tearRO, tearGO, tearBO = tearcolor.RO, tearcolor.GO, tearcolor.BO
	local tearcolorize = tearcolor:GetColorize()
	local tearRC, tearGC, tearBC, tearAC = tearcolorize.R, tearcolorize.G, tearcolorize.B, tearcolorize.A
	
	-- determine the basecolor of can of beans colour
	-- average out the colors of any bean item synergies, else just use the default butterfart color
	local baseRO = 0
	local baseGO = 0
	local baseBO = 0
	local baseDivisor = 0
	if flagparams.IsBean then
		baseRO = baseRO + 50/255
		baseGO = baseGO + 100/255
		baseBO = baseBO + 25/255
		baseDivisor = baseDivisor + 1
	end
	if flagparams.IsKidneyBean then
		baseRO = baseRO + 100/255
		baseGO = baseGO + 30/255
		baseBO = baseBO + 100/255
		baseDivisor = baseDivisor + 1
	end
	if flagparams.IsHolyBean then
		baseRO = baseRO + 70/255
		baseGO = baseGO + 110/255
		baseBO = baseBO + 130/255
		baseDivisor = baseDivisor + 1
	end
	if flagparams.IsBlackEyedPea then
		baseRO = baseRO + 60/255
		baseGO = baseGO + 20/255
		baseBO = baseBO + 60/255
		baseDivisor = baseDivisor + 1
	end
	if flagparams.IsButterBean or flagparams.IsWaitWhat or flagparams.IsLingerBean or flagparams.IsMegaBean then
		baseRO = baseRO + 70/255
		baseGO = baseGO + 25/255
		baseBO = baseBO + 20/255
		baseDivisor = baseDivisor + 1
	end
	if baseDivisor > 0 then
		baseRO = baseRO / baseDivisor
		baseGO = baseGO / baseDivisor
		baseBO = baseBO / baseDivisor
	else
		baseRO = 100/255
		baseGO = 50/255
		baseBO = 30/255
	end
	--local basecolor = Color(1, 1, 0, 1, baseRO, baseGO, baseBO, 1, 1, 1, 1)
	--local basecolorize = basecolor:GetColorize()
	
	-- colour setup so basecolor being is applied to the sprite first, then the tearcolor to that result
	-- note these factors are specific to colour with tints 1,1,0 and colorize 1,1,1,1
	-- factors are different for different basecolor values
	-- could've calculated for any tint/colorize on the basecolor but dropped that for performance
	return Color(1, 1, 0, tearcolor.A,
	             baseRO * tearRT * (1 - tearAC) + baseRO * tearRT * LUM_R * tearRC * tearAC + baseGO * tearGT * LUM_G * tearRC * tearAC + baseBO * tearBT * LUM_B * tearRC * tearAC + tearRO,
				 baseGO * tearGT * (1 - tearAC) + baseRO * tearRT * LUM_R * tearGC * tearAC + baseGO * tearGT * LUM_G * tearGC * tearAC + baseBO * tearBT * LUM_B * tearGC * tearAC + tearGO,
				 baseBO * tearGT * (1 - tearAC) + baseRO * tearRT * LUM_R * tearBC * tearAC + baseGO * tearGT * LUM_G * tearBC * tearAC + baseBO * tearBT * LUM_B * tearBC * tearAC + tearBO,
				 tearRT * (1 - tearAC) + (tearRT * LUM_R + tearGT * LUM_G + tearBT * LUM_B) * tearRC * tearAC,
				 tearGT * (1 - tearAC) + (tearRT * LUM_R + tearGT * LUM_G + tearBT * LUM_B) * tearGC * tearAC,
				 tearBT * (1 - tearAC) + (tearRT * LUM_R + tearGT * LUM_G + tearBT * LUM_B) * tearBC * tearAC,
				 1)
end

local scheduledCanOfBeansColours = {}
function mod:canOfBeansColorScheduled(entity)
	local data = mod:GetEntityData(entity)
	local func = function()
		if data.FFBeansInfo and data.FFBeansInfo.ColorTime ~= nil and FiendFolio.HasBeansFlag(entity) then
			local beansInfo = data.FFBeansInfo
			if beansInfo.ColorTime ~= entity.FrameCount then
				local color = entity:GetSprite().Color
				local beancolor = mod:getCanOfBeansColor(color, FiendFolio.GetBeansTearFlagParams(entity))
				beansInfo.ColorTime = entity.FrameCount
				beansInfo.Color = Color.Lerp(color, color, 0)
				entity:SetColor(beancolor, 1, 0, false, false)
			end
		end
	end
	table.insert(scheduledCanOfBeansColours, func)
end
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, mod.canOfBeansColorScheduled) 
mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, mod.canOfBeansColorScheduled)

local function shouldColorClub(knife)
	if FiendFolio.HasBeansFlag(knife) then
		return true
	end
	local player = TearFlagsLib.GetTearPlayer(knife)
	return player and player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.CAN_OF_BEANS)
end

mod:AddPriorityCallback(ModCallbacks.MC_POST_FIRE_SPLIT_TEAR, - 1 * math.huge, function(_, new, old, splitType)
	if splitType ~= SplitTearType.MULTIDIMENSIONAL and splitType ~= SplitTearType.ANGELIC_PRISM and splitType ~= "FF_ZERO_POINT" and splitType ~= "FF_PARANOIA" then
		local data = mod:GetEntityData(old)
		if data.FFBeansInfo and data.FFBeansInfo.Color then
			new.Color = Color.Lerp(data.FFBeansInfo.Color, Color(), 0)
		end
	end
	mod:canOfBeansColorScheduled(new)
	mod:canOfBeansColorScheduled(old)
end)

function mod:canOfBeansColorClub(knife)
	if shouldColorClub(knife) then
		local data = mod:GetEntityData(knife)
		data.FFBeansInfo = data.FFBeansInfo or {}
		local beansInfo = data.FFBeansInfo
		local sprite = knife:GetSprite()
		local color = sprite.Color
		local beancolor = mod:getCanOfBeansColor(color, FiendFolio.GetBeansTearFlagParams(knife))
		beansInfo.Color = Color.Lerp(color, color, 0)
		sprite.Color = beancolor
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_KNIFE_RENDER, math.huge, mod.canOfBeansColorClub)

function mod:canOfBeansResetClubColor(knife)
	local data = mod:GetEntityData(knife)
	data.FFBeansInfo = data.FFBeansInfo or {}
	local beansInfo = data.FFBeansInfo
	if beansInfo.Color then knife:GetSprite().Color = beansInfo.Color end 
	beansInfo.Color = nil
end
mod:AddCallback(ModCallbacks.MC_POST_KNIFE_RENDER, mod.canOfBeansResetClubColor)

local runScheduledInPostTearUpdateThisFrame = nil
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	for _, knife in ipairs(Isaac.FindByType(EntityType.ENTITY_KNIFE)) do
		mod:canOfBeansResetClubColor(knife)
	end
	for _, func in ipairs(scheduledCanOfBeansColours) do
		func()
	end
	scheduledCanOfBeansColours = {}
	runScheduledInPostTearUpdateThisFrame = Isaac.GetFrameCount()
end)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	for _, func in ipairs(scheduledCanOfBeansColours) do
		func()
	end
	scheduledCanOfBeansColours = {}
end)
mod:AddPriorityCallback(ModCallbacks.MC_POST_TEAR_UPDATE, math.huge, function()
	if runScheduledInPostTearUpdateThisFrame == Isaac.GetFrameCount() then
		for _, func in ipairs(scheduledCanOfBeansColours) do
			func()
		end
		scheduledCanOfBeansColours = {}
	end
end)

local aquaBaseOffset = 238/255 * LUM_R + 28/255 * LUM_G
function mod:getCanOfBeansAquariusColor(tearcolor, flagparams, isAquarius)
	-- determine the basecolor of can of beans colour
	-- average out the colors of any bean item synergies, else just use the default butterfart color
	local beanRO = 0
	local beanGO = 0
	local beanBO = 0
	local baseDivisor = 0
	if flagparams.IsBean then
		beanRO = beanRO + 50/255
		beanGO = beanGO + 100/255
		beanBO = beanBO + 25/255
		baseDivisor = baseDivisor + 1
	end
	if flagparams.IsKidneyBean then
		beanRO = beanRO + 100/255
		beanGO = beanGO + 30/255
		beanBO = beanBO + 100/255
		baseDivisor = baseDivisor + 1
	end
	if flagparams.IsHolyBean then
		beanRO = beanRO + 70/255
		beanGO = beanGO + 110/255
		beanBO = beanBO + 130/255
		baseDivisor = baseDivisor + 1
	end
	if flagparams.IsBlackEyedPea then
		beanRO = beanRO + 60/255
		beanGO = beanGO + 20/255
		beanBO = beanBO + 60/255
		baseDivisor = baseDivisor + 1
	end
	if flagparams.IsButterBean or flagparams.IsWaitWhat or flagparams.IsLingerBean or flagparams.IsMegaBean then
		beanRO = beanRO + 70/255
		beanGO = beanGO + 25/255
		beanBO = beanBO + 20/255
		baseDivisor = baseDivisor + 1
	end
	if baseDivisor > 0 then
		beanRO = beanRO / baseDivisor
		beanGO = beanGO / baseDivisor
		beanBO = beanBO / baseDivisor
	else
		beanRO = 100/255
		beanGO = 50/255
		beanBO = 30/255
	end
	beanRO = (aquaBaseOffset + beanRO) * tearcolor.R
	beanGO = (aquaBaseOffset + beanGO) * tearcolor.G
	beanBO = (aquaBaseOffset + beanBO) * tearcolor.B
	
	local tearcolorize = tearcolor:GetColorize()
	local baseLum = beanRO * LUM_R + beanGO * LUM_G + beanBO * LUM_B
	beanRO = beanRO * (1 - tearcolorize.A) + baseLum * tearcolorize.R * tearcolorize.A + tearcolor.RO
	beanGO = beanGO * (1 - tearcolorize.A) + baseLum * tearcolorize.G * tearcolorize.A + tearcolor.GO
	beanBO = beanBO * (1 - tearcolorize.A) + baseLum * tearcolorize.B * tearcolorize.A + tearcolor.BO
	
	return Color(0, 0, 0, tearcolor.A, beanRO, beanGO, beanBO, 0, 0, 0, 0)
end

function mod:canOfBeansAquariusColor(creep, data)
	if FiendFolio.HasBeansFlag(creep) then
		data.FFBeansInfo = data.FFBeansInfo or {}
		creep:GetSprite().Color = mod:getCanOfBeansAquariusColor(creep.Color, FiendFolio.GetBeansTearFlagParams(creep))
	end
end

-- *********
-- * Farts *
-- *********

local function getTearColorForFart(entity, player, weaponFlag, params, beansInfo)
	if params.ColorOverride then
		return params.ColorOverride
	elseif beansInfo.Color then
		return beansInfo.Color
	end
	
	local inheritor = params.InheritColorFrom or entity
	if mod.CAN_OF_BEANS.USE_ENTITY_COLOR:HasAnyFlag(weaponFlag) then
		return inheritor.Color
	elseif mod.CAN_OF_BEANS.USE_PLAYERCOLOR:HasAnyFlag(weaponFlag) then
		if mod.CAN_OF_BEANS.USE_LASERCOLOR:HasAnyFlag(weaponFlag) then
			return player.LaserColor
		else
			return player.TearColor
		end
	else
		return inheritor:GetSprite().Color
	end
end

local cachedEnemies = {}
local lastTimeCachedEnemies = nil
local cachedProjs = {}
local lastTimeCachedProjs = nil
local preventingFartSfx = false
local preventRecursive = false
local preventProvRecursive = false
local fartCloudsToColour = {}
function mod:spawnCanFart(entity, player, positions, params, beansInfo, weaponFlag)
	if not preventRecursive or (weaponFlag == TearFlagsLib.WeaponFlag.FF_PROVIDENCE_LASER and not preventProvRecursive) then
		preventingFartSfx = true
		if weaponFlag == TearFlagsLib.WeaponFlag.FF_PROVIDENCE_LASER then
			preventProvRecursive = true
		else
			preventRecursive = true
		end
		
		local flagparams = FiendFolio.GetBeansTearFlagParams(entity)
		local damage = params.Damage
		local scale = params.Scale
		
		local hasGiganteBean = player:HasTrinket(TrinketType.TRINKET_GIGANTE_BEAN)
		local giganteMult = ((hasGiganteBean and 2) or 1)
		local megaMult = ((flagparams.IsMegaBean and 2) or 1)
		local adjustedRadiusMult = scale / 1.2289669513702 * megaMult
		local fartRadius = baseFartRadius * giganteMult * adjustedRadiusMult
		local falloffRadius = falloffFartRadius * giganteMult * adjustedRadiusMult
		
		local flags = params.VanillaFlags | (flagparams.AdditionalFlags or TearFlags.TEAR_NORMAL)
		local hasExplosive = flags & TearFlags.TEAR_EXPLOSIVE == TearFlags.TEAR_EXPLOSIVE
		local hasShielded = flags & TearFlags.TEAR_SHIELDED == TearFlags.TEAR_SHIELDED
		local hasPunch = flags & TearFlags.TEAR_PUNCH == TearFlags.TEAR_PUNCH
		flags = flags & ~flagsExcludedFromFart
		
		local isBean = flagparams.IsBean
		local isKidneyBean = flagparams.IsKidneyBean
		local isHolyBean = flagparams.IsHolyBean
		local isButterBean = flagparams.IsButterBean or flagparams.IsWaitWhat or flagparams.IsLingerBean or flagparams.IsMegaBean
		local isBlackEyedPea = flagparams.IsBlackEyedPea
		
		local enemies = cachedEnemies
		if lastTimeCachedEnemies ~= game:GetFrameCount() then
			enemies = Isaac.FindInRadius(Vector(0,0), 9999, EntityPartition.ENEMY)
			cachedEnemies = enemies
			lastTimeCachedEnemies = game:GetFrameCount()
		end
		
		local projs = cachedProjs
		if lastTimeCachedProjs ~= game:GetFrameCount() then
			projs = Isaac.FindByType(EntityType.ENTITY_PROJECTILE)
			cachedProjs = projs
			lastTimeCachedProjs = game:GetFrameCount()
		end
		
		local sdata = TearFlagsLib.GetSafeData(entity)
		local enemiesToSkip = beansInfo.EnemiesHitThisFrame or {}
		local hitEnemies = {}
		for _,enemy in ipairs(enemies) do
			if enemy.Type > 9 and enemy.Type < 1000 and not hitEnemies[GetPtrHash(enemy)] then
				local target = enemy
				local segments = {enemy}
				if mod:isSegmented(enemy) and not mod:isReducedSyncSegment(enemy) then
					segments = mod:getSegments(enemy)
					for _, segment in ipairs(segments) do
						if segment.Type == mod.FF.ToxicKnight.ID and segment.Variant == mod.FF.ToxicKnight.Var then
							if segment.SubType == mod.FF.ToxicKnightBrain.Sub then
								target = segment
							end
						elseif segment.Type == mod.FF.PsiKnight.ID and segment.Variant == mod.FF.PsiKnight.Var then
							if segment.SubType == mod.FF.PsiKnightBrain.Sub then
								target = segment
							end
						elseif mod:isMainSegment(segment) then
							target = segment
						end
					end
				elseif mod:isBasegameSegmented(enemy) and not mod:isBasegameReducedSyncSegment(enemy) then
					segments = mod:getBasegameSegments(enemy)
					for _, segment in ipairs(segments) do
						if mod:isBasegameMainSegment(segment) then
							target = segment
						end
					end
				end
				
				local skip = false
				if not mod.CAN_OF_BEANS.ALLOW_HITTING_APPLIED_ENEMIES:HasAnyFlag(weaponFlag) then
					for _, segment in ipairs(segments) do
						if enemiesToSkip[GetPtrHash(segment)] then
							skip = true
							break
						end
					end
				end
				
				local fartDamage = 0
				local origDamage = 0
				local startPos = nil
				local inDist = false
				for _, segment in ipairs(segments) do
					for _, posInfo in ipairs(positions) do
						local pos = posInfo.Position
						local dist = segment.Position:Distance(pos) - segment.Size * math.max(segment.SizeMulti.X, segment.SizeMulti.Y)
						local falloffMult = (flagparams.IsMegaBean and 1) or 
						                    ((dist < fartRadius) and ((1 - math.min(math.max(0, (dist - falloffRadius) / (fartRadius - falloffRadius)), 1)) ^ falloffPow)) or
											0
						local newDamage = (posInfo.DamageOverride or damage) * falloffMult
						if newDamage > fartDamage then
							fartDamage = newDamage
							origDamage = posInfo.DamageOverride or damage
							startPos = pos
							inDist = true
						end
					end
				end
				
				if inDist then
					local vel = target.Position - startPos
					if flags & TearFlags.TEAR_PUNCH == TearFlags.TEAR_PUNCH then
						vel = vel:Resized(player.ShotSpeed * 10)
					else
						vel = vel:Resized(0.000001)
					end
					local vanillaparams = {PositionOverride = target.Position,
										   VelocityOverride = vel,
										   RemoveStickyTears = true,
										   DamageOverride = origDamage,
										   ScaleOverride = scale}
					
					if skip then
						TearFlagsLib.ApplyVanillaTearFlagEffectsToEntity(target, flagparams.AdditionalFlags, player, entity, vanillaparams)
					else
						TearFlagsLib.AntiRecursion = true
						local inTearflagBlacklist = sdata.entityBlacklist and sdata.entityBlacklist[target.InitSeed]
						
						TearFlagsLib.ApplyVanillaTearFlagEffectsToEntity(target, flags, player, entity, vanillaparams)
						-- need to do this in this order or either it doesnt apply or it applies twice
						mod.OverrideCritBoostCheck = params.ForceCrit
						target:TakeDamage(fartDamage, 0, EntityRef(entity), 0)
						mod.OverrideCritBoostCheck = nil
						TearFlagsLib.CallTearFlagCallback(target, player, entity, weaponFlag)
						
						if weaponFlag == TearFlagsLib.WeaponFlag.HEMOPTYSIS then
							target:AddBrimstoneMark(EntityRef(player), -150)
						end
						
						if sdata.entityBlacklist and not inTearflagBlacklist then
							sdata.entityBlacklist[target.InitSeed] = nil
						end
						TearFlagsLib.AntiRecursion = false
					end
				end
				
				for _, segment in ipairs(segments) do
					hitEnemies[GetPtrHash(segment)] = true
					if inDist and not (flagparams.IsButterBean or hasPunch) then
						local data = mod:GetEntityData(enemy)
						data.applyBeansImpactDamage = game:GetFrameCount()
						data.applyBeansImpactDamageHasHitWall = false
						data.applyBeansImpactDamageSource = player
					end
				end
			end
		end
		
		for _, pos in ipairs(positions) do
			local pos = pos.Position
			for _, proj in ipairs(projs) do
				if not proj:HasEntityFlags(EntityFlag.FLAG_NO_QUERY) then
					proj:AddEntityFlags(EntityFlag.FLAG_NO_QUERY)
					mod:GetEntityData(proj).beansAddedNoQuery = true
				end
				if hasShielded then
					local dist = proj.Position:Distance(pos) - proj.Size * math.max(proj.SizeMulti.X, proj.SizeMulti.Y)
					if dist < fartRadius then
						proj:Die()
					end
				end
			end
			local screenshakeBefore = game:GetScreenShakeCountdown()
			game:ButterBeanFart(pos, baseFartRadius * adjustedRadiusMult, player, false, flagparams.IsButterBean or false)
			game:ShakeScreen(screenshakeBefore)
			for _, proj in ipairs(projs) do
				local data = mod:GetEntityData(proj)
				if data.beansAddedNoQuery then
					proj:ClearEntityFlags(EntityFlag.FLAG_NO_QUERY)
					data.beansAddedNoQuery = nil
				end
			end
			
			if flagparams.IsWaitWhat then
				local shockwave = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SHOCKWAVE, 0, pos, nilvector, player):ToEffect()
				shockwave.Parent = player
				shockwave:SetRadii(10, 10 + fartRadius)
				shockwave.Timeout = math.max(1, math.ceil(fartRadius / 80 * 10))
			end
			if flagparams.IsLingerBean then
				local cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BROWN_CLOUD, 0, pos, nilvector, player):ToEffect()
				cloud.State = 188
				local cdata = mod:GetEntityData(cloud)
				cdata.stopLingerDamage = game:GetFrameCount()
				cdata.manualStartPoofAnim = true
				cloud:Update()
			end
			
			local fartCloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FART, 0, pos, nilvector, player)
			local fartSprite = fartCloud:GetSprite()
			if mod.CAN_OF_BEANS.USE_LASERCOLOR:HasAnyFlag(weaponFlag) then
				fartSprite:ReplaceSpritesheet(0, "gfx/effects/effect_fart_red.png")
			elseif beansInfo.UseMultieuclideanFart then
				fartSprite:ReplaceSpritesheet(0, "gfx/effects/effect_fart_multieuclidean.png")
			else
				fartSprite:ReplaceSpritesheet(0, "gfx/effects/effect_fart_greyscale.png")
			end
			fartSprite:LoadGraphics()
			fartSprite.Scale = Vector(1,1) * giganteMult * adjustedRadiusMult
			fartCloud.DepthOffset = - 6
			
			-- leaving this in case somebody wants to set up a synergy in another mod or w/e
			fartCloud.Parent = entity
			mod:GetEntityData(fartCloud).FFCanOfBeansFart = {}
			mod:GetEntityData(fartCloud).FFCanOfBeansFart.Radius = fartRadius
			mod:GetEntityData(fartCloud).FFCanOfBeansFart.FalloffRadius = falloffRadius
			
			local color
			if not params.InheritColorDelayed then
				color = getTearColorForFart(entity, player, weaponFlag, params, beansInfo)
			end
			local func = function()
				if params.InheritColorDelayed then
					color = getTearColorForFart(entity, player, weaponFlag, params, beansInfo)
				end
				local colorize = color:GetColorize()
				
				-- average out the colors of any bean item synergies, else just use the default butterfart color
				local baseRT = 1
				local baseGT = 1
				local baseBT = 1
				if not mod.CAN_OF_BEANS.USE_LASERCOLOR:HasAnyFlag(weaponFlag) then
					baseRT = 0
					baseGT = 0
					baseBT = 0
					local baseDivisor = 0
					if isBean then
						baseRT = baseRT + 0.677
						baseGT = baseGT + 1.144
						baseBT = baseBT + 0.522
						baseDivisor = baseDivisor + 1
					end
					if isKidneyBean then
						baseRT = baseRT + 1.0
						baseGT = baseGT + 0.0
						baseBT = baseBT + 1.0
						baseDivisor = baseDivisor + 1
					end
					if isHolyBean then
						baseRT = baseRT + 1.3
						baseGT = baseGT + 1.534
						baseBT = baseBT + 1.65
						baseDivisor = baseDivisor + 1
					end
					if isButterBean then
						baseRT = baseRT + 0.914
						baseGT = baseGT + 0.481
						baseBT = baseBT + 0.47
						baseDivisor = baseDivisor + 1
					end
					if isBlackEyedPea then
						baseRT = baseRT + 0.711
						baseGT = baseGT + 0.4
						baseBT = baseBT + 0.711
						baseDivisor = baseDivisor + 1
					end
					if baseDivisor > 0 then
						baseRT = baseRT / baseDivisor
						baseGT = baseGT / baseDivisor
						baseBT = baseBT / baseDivisor
					else
						baseRT = 1.219
						baseGT = 0.801
						baseBT = 0.783
					end
				end
				
				local fartcolor = Color(color.R * baseRT, color.G * baseGT, color.B * baseBT, color.A * 0.7, 
				                        color.RO, color.GO, color.BO, 
				                        colorize.R, colorize.G, colorize.B, colorize.A)
				fartSprite.Color = fartcolor
				
				if flagparams.IsMegaBean then
					local megacolor = mod:getCanOfBeansColor(color, flagparams)
					game:GetRoom():GetFXLayers():AddPoopFx(megacolor)
				end
			end
			table.insert(fartCloudsToColour, func)
		end
			
		if TearFlagsLib.HasTearFlags(entity, mod.CritFlag) then
			for _, pos in ipairs(positions) do
				mod:doCriticalHitFx(pos.Position, nil, entity)
			end
		end
		
		preventingFartSfx = false
		local screenshake = 0
		if scale * giganteMult * megaMult < 0.875 then
			sfx:Play(SoundEffect.SOUND_FART, 0.8, 4, false, 1.75)
		elseif scale * giganteMult * megaMult < 1.875 then
			sfx:Play(SoundEffect.SOUND_FART, 1, 10, false, 1)
		else
			sfx:Play(SoundEffect.SOUND_FART, 1, 0, false, 1)
			sfx:Play(SoundEffect.SOUND_FART, 1, 0, false, 1)
			sfx:Play(SoundEffect.SOUND_FART, 1.2, 10, false, 0.5)
		end
		if flagparams.IsMegaBean then
			screenshake = 3
			sfx:Play(SoundEffect.SOUND_MEGABEAN_BLAST, 1, 0, false, 1, 0)
		end
		if game:GetScreenShakeCountdown() < screenshake then
			game:ShakeScreen(screenshake)
		end
		
		if weaponFlag == TearFlagsLib.WeaponFlag.FF_PROVIDENCE_LASER then
			preventProvRecursive = false
		else
			preventRecursive = false
		end
		return true
	end
end

local doingBrimstoneSneeze = {}
local brimstoneSneezeParams = {}
mod:AddPriorityCallback(ModCallbacks.MC_PRE_BRIMSTONE_SNEEZE, math.huge, function(_, source, direction, damagescale)
	if source then
		doingBrimstoneSneeze[GetPtrHash(source)] = true
	end
end)

mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_TEAR_HIT_PARAMS, math.huge, function(_, player, tearparams, weapontype)
	if weapontype == WeaponType.WEAPON_BRIMSTONE and doingBrimstoneSneeze[GetPtrHash(player)] then
		brimstoneSneezeParams[GetPtrHash(player)] = tearparams
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_BRIMSTONE_SNEEZE, function(_, source, direction, damagescale)
	doingBrimstoneSneeze[GetPtrHash(source)] = nil
	brimstoneSneezeParams[GetPtrHash(source)] = nil
end)

-- good golly, quality based damage! just what will they think of next?
-- quality 5 is not real, quality 5 cannot hurt you
local canOfBeansQuality = Isaac.GetItemConfig():GetCollectible(FiendFolio.ITEM.COLLECTIBLE.CAN_OF_BEANS).Quality
local locustMult = 1
if canOfBeansQuality == 0 then
	locustMult = 0.5
elseif canOfBeansQuality == 1 then
	locustMult = 0.75
elseif canOfBeansQuality == 3 then
	locustMult = 1.5
elseif canOfBeansQuality == 4 then
	locustMult = 2
end
function mod:getCanFartParams(source, player, weaponFlag, entity)
	local flags = TearFlagsLib.GetCustomVanillaTearFlags(source)
	local damage = source.CollisionDamage
	local scale = 1.2289669513702
	local color = nil
	local position = nil
	local forceCrit = nil
	
	if mod.CAN_OF_BEANS.FART_FROM_ENEMY_POS:HasAnyFlag(weaponFlag) and not mod.CAN_OF_BEANS.FART_PER_ENEMY:HasAnyFlag(weaponFlag) then
		position = entity.Position
	end
	
	if weaponFlag == TearFlagsLib.WeaponFlag.HEMOPTYSIS then
		local params = brimstoneSneezeParams[GetPtrHash(player)]
		damage = (params and params.TearDamage) or (player.Damage * 1.5)
		flags = flags | ((params and params.TearFlags) or (TearFlags.TEAR_NORMAL))
	elseif source.Type == EntityType.ENTITY_TEAR then
		local tear = source:ToTear()
		flags = flags | tear.TearFlags
		
		scale = tear.Scale
		if tear:HasTearFlags(TearFlags.TEAR_LUDOVICO) then
			scale = scale * 0.5644
		end
		if tear:HasTearFlags(TearFlags.TEAR_FETUS) then
			scale = scale - 0.5
		end
		if tear.Variant == TearVariant.BOBS_HEAD then
			scale = scale * 1.478
		end
	elseif source.Type == EntityType.ENTITY_BOMB then
		local bomb = source:ToBomb()
		flags = flags | bomb.Flags
		scale = bomb:GetScale() * 1.4782814979553 * bomb.RadiusMultiplier
		
		damage = bomb.ExplosionDamage
		if damage > 60 then
			damage = (damage - 30) / 5
		else
			damage = damage / 10
		end
		damage = damage * 3
	elseif source.Type == EntityType.ENTITY_LASER then
		scale = mod:getTearParamsScale(player, damage, flags)
	elseif source.Type == EntityType.ENTITY_KNIFE then
		local knife = source:ToKnife()
		flags = flags | knife.TearFlags
		
		if knife.Variant == KnifeVariant.MOMS_KNIFE or knife.Variant == KnifeVariant.SUMPTORIUM then
			scale = mod:getTearParamsScale(player, damage, flags)
			damage = damage * 2
		elseif TearFlagsLib.IsEntitySpiritSword(knife) then
			scale = 1.2289669513702
			damage = player.Damage
		else
			scale = knife.SpriteScale.X * 1.2289669513702
		end
	elseif source.Type == EntityType.ENTITY_FAMILIAR and source.Variant == FamiliarVariant.ABYSS_LOCUST then
		local locust = source:ToFamiliar()
		local famMult = locust:GetMultiplier()
		damage = player.Damage * locustMult * famMult
		scale = mod:getTearParamsScale(player, damage / (3.5 * locustMult) * 7.0083074569702, flags)
		color = Color()
	elseif source.Type == EntityType.ENTITY_FAMILIAR and source.Variant == FamiliarVariant.UMBILICAL_BABY then
		local gello = source:ToFamiliar()
		local famMult = gello:GetMultiplier()
		scale = mod:getTearParamsScale(player, damage * famMult, flags)
		damage = damage * 3 * famMult
	elseif source.Type == EntityType.ENTITY_EFFECT and source.Variant == EffectVariant.ROCKET then
		damage = player.Damage * 8
		scale = 1.4782814979553
	elseif source.Type == EntityType.ENTITY_EFFECT and source.Variant == EffectVariant.DARK_SNARE then
		color = Color(0.05, 0.05, 0.05, 1, 0, 0, 0)
	elseif source.Type == EntityType.ENTITY_EFFECT and source.Variant == EffectVariant.BRIMSTONE_BALL then
		scale = 1.8434504270553
	end
	
	if source.Type == EntityType.ENTITY_LASER or 
	   (source.Type == EntityType.ENTITY_KNIFE and source.SubType ~= 4 and not TearFlagsLib.IsEntitySpiritSword(source)) or 
	   (source.Type == EntityType.ENTITY_EFFECT and (source.Variant == EffectVariant.BRIMSTONE_BALL or source.Variant == EffectVariant.TECH_DOT or source.Variant == EffectVariant.BRIMSTONE_SWIRL))
	then
		forceCrit = mod.CurrentlyCritting[GetPtrHash(entity)] == true
	end
	
	local tearparams = TearFlagsLib.GetCustomVanillaTearFlagParams(source)
	local fartparams =  {VanillaFlags = flags, 
	                     Damage = tearparams.DamageOverride or damage, 
	                     Scale = tearparams.ScaleOverride or scale,
	                     PositionOverride = tearparams.PositionOverride or position,
	                     ColorOverride = tearparams.ColorOverride or color,
	                     ForceCrit = forceCrit}
	if weaponFlag == TearFlagsLib.WeaponFlag.FF_SHADOW_CLUSTER then
		fartparams.Damage = fartparams.Damage * 2
	end
	Isaac.RunCallbackWithParam(FiendFolio.CALLBACK.GET_CAN_OF_BEANS_FART_PARAMS, weaponFlag, source, player, weaponFlag, entity)
	return fartparams
end

-- copied from tearflagslib
local function getClosestPointOnLine(testPosition, lineOrigin, lineEnd)
	local heading = lineEnd - lineOrigin
	local magnitude = heading:Length()
	heading:Normalize()

	local lhs = testPosition - lineOrigin
	local dot = lhs:Dot(heading)
	dot = math.min(math.max(0, dot), magnitude)
	return lineOrigin + heading * dot
end

-- copied from tearflagslib
local function getLaserSampleCapsules(laser)
	local samples = laser:GetSamples()
	local capsules = {}

	for i = 1, #samples do
		local position = samples:Get(i - 1)
		local radius = laser.Radius

		if i == #samples then
			capsules[i-1].Locus2 = position
		elseif i > 1 then
			capsules[i] = capsules[i] or {}
			capsules[i].Locus1 = position
			capsules[i].Radius = radius
			capsules[i-1].Locus2 = position
		else
			capsules[1] = capsules[1] or {}
			capsules[1].Locus1 = position
			capsules[1].Radius = radius
		end
	end

	return capsules
end

local function movePosToClosestLaserSegment(pos, laser)
	local closestPoint = pos
	local closestDist = math.huge
	for _, laserCapsule in pairs(getLaserSampleCapsules(laser)) do
		local pointOnLine = getClosestPointOnLine(pos, laserCapsule.Locus1, laserCapsule.Locus2)
		local dist = pointOnLine:Distance(pos)
		if dist < closestDist then
			closestPoint = pointOnLine
			closestDist = dist
		end
	end
	return closestPoint
end

local clearEnemiesHitThisFrame = {}
function mod:spawnCanFartFromWeapon(source, weaponFlag, params)
	local data = mod:GetEntityData(source)
	data.FFBeansInfo = data.FFBeansInfo or {}
	
	local beansInfo = data.FFBeansInfo or {}
	local player = FiendFolio.GetBeansTearFlagParams(source).Player
	local frame = game:GetFrameCount()
	
	local cooldown = math.max(minFartCooldown, (mod.CAN_OF_BEANS.FART_ON_FIREDELAY:HasAnyFlag(weaponFlag) and player.MaxFireDelay) or minFartCooldown)
	local positions = {}
	local enemiesToCheck = beansInfo.EnemiesHitThisFrame
	local hasAnEnemyToCheck = false
	if enemiesToCheck then
		for _,_ in pairs(enemiesToCheck) do
			hasAnEnemyToCheck = true
			break
		end
	end
	if not hasAnEnemyToCheck then
		enemiesToCheck = {-1}
	end
	for ptrhash, hitEnemy in pairs(enemiesToCheck) do
		local allow
		if mod.CAN_OF_BEANS.FART_ONCE:HasAnyFlag(weaponFlag) then
			allow = not beansInfo.DidOneShot
		elseif mod.CAN_OF_BEANS.FART_PER_ENEMY:HasAnyFlag(weaponFlag) then
			if hitEnemy ~= -1 then
				beansInfo.EnemyLastFartOnFrame = beansInfo.EnemyLastFartOnFrame or {}
				if beansInfo.EnemyLastFartOnFrame[ptrhash] == nil or frame - beansInfo.EnemyLastFartOnFrame[ptrhash] >= cooldown then
					allow = true
				end
			end
		elseif mod.CAN_OF_BEANS.FART_COOLDOWN_PER_ENEMY:HasAnyFlag(weaponFlag) then
			beansInfo.EnemyLastFartOnFrame = beansInfo.EnemyLastFartOnFrame or {}
			for ptrhash, _ in pairs(beansInfo.EnemiesHitThisFrame) do
				if beansInfo.EnemyLastFartOnFrame[ptrhash] == nil or frame - beansInfo.EnemyLastFartOnFrame[ptrhash] >= cooldown then
					allow = true
					break
				end
			end
		else
			allow = params.IgnoreCooldown or data.LastFrameCanFarted == nil or frame - data.LastFrameCanFarted >= cooldown
		end
		
		if allow then
			local pos = source.Position
			if mod.CAN_OF_BEANS.FART_FROM_ENEMY_POS:HasAnyFlag(weaponFlag) and mod.CAN_OF_BEANS.FART_PER_ENEMY:HasAnyFlag(weaponFlag) then
				pos = hitEnemy.Entity.Position
				if source.Type == EntityType.ENTITY_LASER and mod.CAN_OF_BEANS.MOVE_FART_TO_LASER:HasAnyFlag(weaponFlag) then
					pos = movePosToClosestLaserSegment(pos, source:ToLaser())
				end
			end
			if source.Type == EntityType.ENTITY_KNIFE and mod.CAN_OF_BEANS.MOVE_FART_TO_CLUB:HasAnyFlag(weaponFlag) then
				local capsulePosition, capsuleRadius = TearFlagsLib.GetSwingingKnifeCapsulePositionRadius(source)
				pos = (capsulePosition - hitEnemy.Entity.Position):Resized(hitEnemy.Entity.Size * math.max(hitEnemy.Entity.SizeMulti.X, hitEnemy.Entity.SizeMulti.Y)) + hitEnemy.Entity.Position
			end
			pos = params.PositionOverride or pos
			local posInfo = {
				Position = pos, 
				DamageOverride = mod.CAN_OF_BEANS.FART_PER_ENEMY:HasAnyFlag(weaponFlag) and mod.CAN_OF_BEANS.USE_ENEMY_SPECIFIC_DAMAGE:HasAnyFlag(weaponFlag) and hitEnemy and type(hitEnemy) == "table" and hitEnemy.Params and hitEnemy.Params.Damage,
			}
			table.insert(positions, posInfo)
			
			if not mod.CAN_OF_BEANS.FART_PER_ENEMY:HasAnyFlag(weaponFlag) then
				break
			end
		end
	end
	
	if #positions <= 0 then
		if mod.CAN_OF_BEANS.FART_IMMEDIATELY:HasAnyFlag(weaponFlag) then
			beansInfo.EnemiesHitThisFrame = {}
		else
			table.insert(clearEnemiesHitThisFrame, beansInfo)
		end
		
		return
	end
	
	local returnval = Isaac.RunCallbackWithParam(FiendFolio.CALLBACK.PRE_CAN_OF_BEANS_WEAPON_FART, weaponFlag, source, weaponFlag, params)
	if (returnval == nil or returnval) and mod:spawnCanFart(source, player, positions, params, beansInfo, weaponFlag) then
		local cooldownFrame = (params.IgnoreCooldown and frame - cooldown + 2) or frame
		data.LastFrameCanFarted = cooldownFrame
		
		if mod.CAN_OF_BEANS.FART_ONCE:HasAnyFlag(weaponFlag) then
			beansInfo.DidOneShot = true
		elseif mod.CAN_OF_BEANS.FART_COOLDOWN_PER_ENEMY:HasAnyFlag(weaponFlag) or mod.CAN_OF_BEANS.FART_PER_ENEMY:HasAnyFlag(weaponFlag) then
			beansInfo.EnemyLastFartOnFrame = beansInfo.EnemyLastFartOnFrame or {}
			for _, enemy in pairs(beansInfo.EnemiesHitThisFrame) do
				local segments = {enemy.Entity}
				if mod:isSegmented(enemy.Entity) then
					segments = mod:getSegments(enemy.Entity)
				elseif mod:isBasegameSegmented(enemy.Entity) then
					segments = mod:getBasegameSegments(enemy.Entity)
				end
				for _, segment in ipairs(segments) do
					beansInfo.EnemyLastFartOnFrame[GetPtrHash(segment)] = cooldownFrame
				end
			end
		end
		
		if mod.CAN_OF_BEANS.FART_IMMEDIATELY:HasAnyFlag(weaponFlag) then
			beansInfo.EnemiesHitThisFrame = {}
		else
			table.insert(clearEnemiesHitThisFrame, beansInfo)
		end
	end
end

mod:AddCallback(FiendFolio.CALLBACK.PRE_CAN_OF_BEANS_WEAPON_FART, function(_, source, weaponFlag, params)
	local knife = source:ToKnife()
	if not (knife and knife:IsFlying()) then
		return false
	end
end, TearFlagsLib.WeaponFlag.KNIFE)

local entitiesToFart = {}
local entitiesToFartSneeze = {}
function mod:applyBeansFlag(entity, player, source, weaponFlag)
	if mod.CAN_OF_BEANS.IGNORE_APPLY:HasAnyFlag(weaponFlag) then
		return
	end
	
	if (not preventRecursive or (weaponFlag == TearFlagsLib.WeaponFlag.FF_PROVIDENCE_LASER and not preventProvRecursive)) and TearFlagsLib.HasTearFlags(source, flag) then
		local data = mod:GetEntityData(source)
		local params = mod:getCanFartParams(source, player, weaponFlag, entity)
		
		data.FFBeansInfo = data.FFBeansInfo or {}
		local beansInfo = data.FFBeansInfo or {}
		beansInfo.EnemiesHitThisFrame = beansInfo.EnemiesHitThisFrame or {}
		beansInfo.EnemiesHitThisFrame[GetPtrHash(entity)] = {Entity = entity}
		
		if mod.CAN_OF_BEANS.USE_ENEMY_SPECIFIC_DAMAGE:HasAnyFlag(weaponFlag) then
			beansInfo.EnemiesHitThisFrame[GetPtrHash(entity)].Params = params
		end
		
		if mod.CAN_OF_BEANS.FART_IMMEDIATELY:HasAnyFlag(weaponFlag) then
			mod:spawnCanFartFromWeapon(source, weaponFlag, params)
		elseif mod.CAN_OF_BEANS.FART_ON_POST_SNEEZE:HasAnyFlag(weaponFlag) then
			local srchash = GetPtrHash(source)
			if not entitiesToFartSneeze[srchash] then
				entitiesToFartSneeze[srchash] = {Source = source, WeaponFlag = weaponFlag, Params = params}
			end
		else
			local srchash = GetPtrHash(source)
			if not entitiesToFart[srchash] then
				entitiesToFart[srchash] = {Source = source, WeaponFlag = weaponFlag, Params = params}
			end
		end
	end
end
mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, mod.applyBeansFlag, flag)

mod:AddCallback(ModCallbacks.MC_POST_TEAR_DEATH, function(_, tear)
	if TearFlagsLib.HasTearFlags(tear, flag) then
		local params = mod:getCanFartParams(tear, FiendFolio.GetBeansTearFlagParams(tear).Player, TearFlagsLib.WeaponFlag.TEAR)
		mod:spawnCanFartFromWeapon(tear, TearFlagsLib.WeaponFlag.TEAR, params)
	end
	entitiesToFart[GetPtrHash(tear)] = nil
end)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, ripple)
	local tears = Isaac.FindInRadius(ripple.Position, 1, EntityPartition.TEAR)
	for _, tear in ipairs(tears) do
		if tear.Position:Distance(ripple.Position) < 0.0001 then
			local tear = tear:ToTear()
			if tear and 
			   tear.TearFlags & TearFlags.TEAR_HYDROBOUNCE == TearFlags.TEAR_HYDROBOUNCE and
			   (tear.Height == - 5.0 or (tear.Height == - 40 and tear.TearFlags & TearFlags.TEAR_LUDOVICO == TearFlags.TEAR_LUDOVICO)) and 
			   not tear:IsDead() and
			   TearFlagsLib.HasTearFlags(tear, flag)
			then
				local ptrhash = GetPtrHash(tear)
				if not entitiesToFart[ptrhash] then
					entitiesToFart[ptrhash] = {Source = tear, 
					                           WeaponFlag = TearFlagsLib.WeaponFlag.TEAR, 
					                           Params = mod:getCanFartParams(tear, FiendFolio.GetBeansTearFlagParams(tear).Player, TearFlagsLib.WeaponFlag.TEAR)}
				end
				entitiesToFart[ptrhash].Params.IgnoreCooldown = true
				ripple:Remove()
				ripple.Visible = false
				break
			end
		end
	end
end, EffectVariant.RIPPLE_POOF)

function mod:markToBeansFart(entity, weaponFlag, ignoreCooldown)
	if TearFlagsLib.HasTearFlags(entity, flag) then
		local ptrhash = GetPtrHash(entity)
		if not entitiesToFart[ptrhash] then
			entitiesToFart[ptrhash] = {Source = entity, 
									   WeaponFlag = weaponFlag, 
									   Params = mod:getCanFartParams(entity, FiendFolio.GetBeansTearFlagParams(entity).Player, weaponFlag)}
		end
		entitiesToFart[ptrhash].Params.IgnoreCooldown = entitiesToFart[ptrhash].Params.IgnoreCooldown or ignoreCooldown
	end
end

mod:AddPriorityCallback(ModCallbacks.MC_PRE_TEAR_UPDATE, math.huge, function(_, tear)
	-- this is the only way i could find to kill the tear early into the hydrobouncing
	-- without creating a bunch of issues like it bouncing an extra time or ignoring the death or having no tear splat
	-- im so tired of this item you have no idea
	if tear.Height >= -5.0 and tear.FallingSpeed > -20 and
	   tear.TearFlags & TearFlags.TEAR_HYDROBOUNCE == TearFlags.TEAR_HYDROBOUNCE and 
	   tear.TearFlags & (TearFlags.TEAR_QUADSPLIT | TearFlags.TEAR_EXPLOSIVE | TearFlags.TEAR_BURSTSPLIT) == TearFlags.TEAR_NORMAL and
	   TearFlagsLib.HasTearFlags(tear, flag)
	then
		tear.FallingSpeed = -9.99999
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, sploder)
	local tears = Isaac.FindInRadius(sploder.Position, 1, EntityPartition.TEAR)
	for _, tear in ipairs(tears) do
		if tear.Position:Distance(sploder.Position) < 0.0001 then
			local tear = tear:ToTear()
			if tear and 
			   tear.TearFlags & TearFlags.TEAR_HYDROBOUNCE == TearFlags.TEAR_HYDROBOUNCE and
			   (tear.Height == - 5.0 or tear.TearFlags & TearFlags.TEAR_LUDOVICO == TearFlags.TEAR_LUDOVICO) and
			   not tear:IsDead() and
			   TearFlagsLib.HasTearFlags(tear, flag)
			then
				local ptrhash = GetPtrHash(tear)
				if not entitiesToFart[ptrhash] then
					entitiesToFart[ptrhash] = {Source = tear, 
					                           WeaponFlag = TearFlagsLib.WeaponFlag.TEAR, 
					                           Params = mod:getCanFartParams(tear, FiendFolio.GetBeansTearFlagParams(tear).Player, TearFlagsLib.WeaponFlag.TEAR)}
				end
				entitiesToFart[ptrhash].Params.IgnoreCooldown = true
				break
			end
		end
	end
end, EffectVariant.BOMB_EXPLOSION)

function mod:resetBeansOnKnifeThrow(knife, player)
	local data = mod:GetEntityData(knife)
	data.FFBeansInfo = data.FFBeansInfo or {}
	if data.FFBeansInfo then
		data.FFBeansInfo.EnemyLastFartOnFrame = nil
	end
end
mod:AddCallback(TearFlagsLib.Callback.POST_THROW_KNIFE, mod.resetBeansOnKnifeThrow)
mod:AddCallback(TearFlagsLib.Callback.POST_THROW_CLUB, mod.resetBeansOnKnifeThrow)

mod:AddCallback(TearFlagsLib.Callback.APPLY_EXPLOSION_TEARFLAG_EFFECT, function(_, explosion, player, boomie, weaponFlag)
	if (not preventRecursive or (weaponFlag == TearFlagsLib.WeaponFlag.FF_PROVIDENCE_LASER and not preventProvRecursive)) and TearFlagsLib.HasTearFlags(boomie, flag) then
		if mod.CAN_OF_BEANS.ON_EXPLODE:HasAnyFlag(weaponFlag) then
			local frame = game:GetFrameCount()
			if mod:GetEntityData(boomie).didCanOfBeans ~= frame then
				local params = mod:getCanFartParams(boomie, player, weaponFlag)
				if mod.CAN_OF_BEANS.USE_EXPLOSION_COLOR:HasAnyFlag(weaponFlag) then
					params.InheritColorFrom = explosion
					params.InheritColorDelayed = true
				end
				mod:spawnCanFartFromWeapon(boomie, weaponFlag, params)
				mod:GetEntityData(boomie).didCanOfBeans = frame
			end
		end
	end
end, flag)

mod:AddCallback(ModCallbacks.MC_POST_BRIMSTONE_SNEEZE, function()
	for _, fartInfo in pairs(entitiesToFartSneeze) do
		mod:spawnCanFartFromWeapon(fartInfo.Source, fartInfo.WeaponFlag, fartInfo.Params)
	end
	entitiesToFartSneeze = {}
end)

mod:AddPriorityCallback(ModCallbacks.MC_POST_UPDATE, CallbackPriority.EARLY, function()
	for _, fartInfo in pairs(entitiesToFart) do
		mod:spawnCanFartFromWeapon(fartInfo.Source, fartInfo.WeaponFlag, fartInfo.Params)
	end
	entitiesToFart = {}
end)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	for _, func in ipairs(fartCloudsToColour) do
		func()
	end
	fartCloudsToColour = {}
	
	for _, beansInfo in ipairs(clearEnemiesHitThisFrame) do
		beansInfo.EnemiesHitThisFrame = {}
	end
	clearEnemiesHitThisFrame = {}
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	entitiesToFart = {}
	fartCloudsToColour = {}
end)

-- *****************
-- * Impact Damage *
-- *****************

mod:AddCallback(ModCallbacks.MC_POST_NPC_COLLISION, function(_, npc, collider)
	local data = mod:GetEntityData(npc)
	local frame = game:GetFrameCount()
	if collider.Type > 9 and
	   collider.Type < 1000 and
	   data.applyBeansImpactDamage and 
	   frame - data.applyBeansImpactDamage < impactDamageFrames and 
	   not npc:HasEntityFlags(EntityFlag.FLAG_APPLY_IMPACT_DAMAGE) and 
	   not (mod:isInSegmentsOf(collider, npc) or mod:isInBasegameSegmentsOf(collider, npc))
	then
		local ptrhash = GetPtrHash(npc)
		local cdata = mod:GetEntityData(npc)
		cdata.beansImpactDamageCooldown = cdata.beansImpactDamageCooldown or {}
		if cdata.beansImpactDamageCooldown[ptrhash] == nil or frame - cdata.beansImpactDamageCooldown[ptrhash] >= impactDamageCooldown then
			collider:TakeDamage(impactDamageBase + (game:GetLevel():GetAbsoluteStage() - 1) * impactDamageStage, 0, EntityRef(data.applyBeansImpactDamageSource), 0)
			cdata.beansImpactDamageCooldown[ptrhash] = frame
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_NPC_GRID_COLLISION, function(_, npc)
	local data = mod:GetEntityData(npc)
	if data.applyBeansImpactDamage and not data.applyBeansImpactDamageHasHitWall and
	   game:GetFrameCount() - data.applyBeansImpactDamage < impactDamageFrames and 
	   not npc:HasEntityFlags(EntityFlag.FLAG_APPLY_IMPACT_DAMAGE) 
	then
		npc:TakeDamage(impactDamageBase + (game:GetLevel():GetAbsoluteStage() - 1) * impactDamageStage, 0, EntityRef(data.applyBeansImpactDamageSource), 0)
		data.applyBeansImpactDamageHasHitWall = true
		data.applyBeansImpactDamage = game:GetFrameCount() - impactDamageFrames + 1 
	end
end)

-- *********
-- * Other *
-- *********

mod:AddPriorityCallback(ModCallbacks.MC_POST_TEAR_COLLISION, math.huge, function(_, tear, collider)
	if TearFlagsLib.HasTearFlags(tear, flag) and not tear:HasTearFlags(TearFlags.TEAR_LUDOVICO) and 
		collider.Type > 9 and collider.Type < 1000 and not mod:isFriend(collider)
	then
		tear:Die()
	end
end)

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, amount, flags, source, countdown)
	-- overriding the first frame hit of linger bean clouds for the synergy
	if source and source.Type == EntityType.ENTITY_EFFECT and source.Variant == EffectVariant.BROWN_CLOUD and source.Entity then
		local data = mod:GetEntityData(source.Entity)
		if game:GetFrameCount() == data.stopLingerDamage then
			return false
		end
	end
	
	-- overriding the flatstone ripple damage for tears
	if source.Type == EntityType.ENTITY_TEAR and source.Entity then
		local tear = source.Entity
		if math.abs(amount - tear.CollisionDamage / 4) < 0.0001 and TearFlagsLib.HasTearFlags(tear, flag) then
			local tear = tear:ToTear()
			if tear.TearFlags & TearFlags.TEAR_HYDROBOUNCE == TearFlags.TEAR_HYDROBOUNCE and
			   (tear.Height == - 5.0 or (tear.Height == - 40 and tear.TearFlags & TearFlags.TEAR_LUDOVICO == TearFlags.TEAR_LUDOVICO))
			then
				return false
			end
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, cloud)
	local data = mod:GetEntityData(cloud)
	if data.manualStartPoofAnim then
		local sprite = cloud:GetSprite()
		if sprite:IsFinished("PoofStart") then
			sprite:Play("PoofLoop", true)
			data.manualStartPoofAnim = nil
		end
	end
end, EffectVariant.BROWN_CLOUD)

mod:AddCallback(ModCallbacks.MC_PRE_SFX_PLAY, function()
	if preventingFartSfx then
		return false
	end
end, SoundEffect.SOUND_FART)
