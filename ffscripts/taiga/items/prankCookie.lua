-- Prank Cookie --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local flag = TearFlagsLib.RegisterTearFlag("PRANK_COOKIE")

mod.PRANK_COOKIE = {}
mod.PRANK_COOKIE.EFFECTS = {
	{DataFlag = "Hemorrhaging", Weight = 1, Color = Color(1.0, 1.0, 1.0, 1.0, 80/255, 0/255, -25/255, 0.7, 0.4, 0.5, 1.0)},
	{DataFlag = "Berserk", Weight = 1, Color = Color(0.4, 0.25, 0.25, 1.0, 60/255, -40/255, -40/255)},
	{DataFlag = "Bruise", Weight = 1, Color = Color(0.5, 0.3, 0.5, 1.0, 40/255, 0/255, 40/255)},
	{DataFlag = "Drowsy", Weight = 1, Color = Color(0.25, 0.2, 0.6, 1.0, 20/255, 20/255, 40/255)},
	{DataFlag = "Martyr", Weight = 1, Color = Color(1.0, 1.0, 1.0, 1.0, 50/255, 120/255, 160/255, 0.75, 0.7, 1.0, 1.0)},
	{DataFlag = "Sewn", Weight = 1, Color = Color(0.5, 0.25, 0.10, 1.0, 30/255, 15/255, 0/255)},
	{DataFlag = "Doom", Weight = 1, Color = Color(0.30, 0.30, 0.30, 1.0, 10/255, -25/255, -25/255, 0.75, 0.5, 0.5, 1.0)},
	{DataFlag = "Crit", Weight = 1, Color = Color(1.0,1.0,1.0,1,100/255,-150/255,100/255)},
	{DataFlag = "YinYang", Weight = 1, Color = Color(3.65, 1.25, 1, 1.0, -90/255, 40/255, 40/255, 0.413, 0.422, 0.657, 1.0)},
	{DataFlag = "MultiEuclidean", Weight = 1, Color = Color(2.0, 2.0, 2.0, 1.0, 0/255, 0/255, 0/255, 1.0, 1.0, 1.0, 1.0)},
	{DataFlag = "Overloaded", Weight = 1, Color = Color(1.0, 1.0, 0.0, 1.0, 80/255, 20/255, 0/255, 1.0, 1.0, 0.0, 0.5)},
	{DataFlag = "Mugged", Weight = 1, Color = Color(1.0, 1.0, 1.0, 1.0, 20/255, 15/255, 10/255, 1.0, 0.75, 0.45, 1)},
	{DataFlag = "Pacified", Weight = 1, Color = Color(0.9, 0.7, 0.7, 1.0, 70/255, 25/255, 25/255)},
	{DataFlag = "Traced", Weight = 1, Color = Color(1, 1, 1, 1, 0.4, 0.4, 0.4, 0, 0.59, 0.6, 1)},
}
mod.PRANK_COOKIE.SKIP_CRIT_GENERIC = TearFlagsLib.WeaponFlag.DARK_ARTS |
                                     TearFlagsLib.WeaponFlag.OCULAR_RIFT |
                                     TearFlagsLib.WeaponFlag.LOCUST
mod.PRANK_COOKIE.SKIP_YIN_YANG_GENERIC = TearFlagsLib.WeaponFlag.EPIC_FETUS |
                                         TearFlagsLib.WeaponFlag.KNIFE |
                                         TearFlagsLib.WeaponFlag.DARK_ARTS |
                                         TearFlagsLib.WeaponFlag.OCULAR_RIFT |
                                         TearFlagsLib.WeaponFlag.LOCUST

local prankCookieLaserColors = {
	Color(1.4, 1.4, 1.4, 1.0, 0/255, 0/255, 0/255, 2.5, 2.2, 0.0, 1), -- Overloaded
	Color(1.4, 1.4, 1.4, 1.0, 0/255, 0/255, 0/255, 2.4, 1.77, 1.11, 1), -- Mugged
	Color(1.4, 1.4, 1.4, 1.0, 0/255, 0/255, 0/255, 2.0, 1.1, 0.7, 1), -- Sewn
	Color(1.4, 1.4, 1.4, 1.0, 0/255, 0/255, 0/255, 1.0, 0.1, 0.1, 1), -- Doom
	Color(1.4, 1.4, 1.4, 1.0, 0/255, 0/255, 0/255, 3.0, 0.0, 0.0, 1), -- Berserk/Hemorrhaging
	Color(1.4, 1.4, 1.4, 1.0, 0/255, 0/255, 0/255, 2.8, 1.19, 1.19, 1), -- Pacified
	Color(1.4, 1.4, 1.4, 1.0, 0/255, 0/255, 0/255, 2.85, 0.45, 1.7, 1), -- Crit
	Color(1.4, 1.4, 1.4, 1.0, 0/255, 0/255, 0/255, 1.8, 0.2, 2.9, 1), -- Bruise
	Color(1.4, 1.4, 1.4, 1.0, 0/255, 0/255, 0/255, 0.9, 0.8, 2.4, 1), -- Drowsy
	Color(1.4, 1.4, 1.4, 1.0, 0/255, 0/255, 0/255, 0.08, 1.8, 2.6, 1), -- YinYang
	Color(1.4, 1.4, 1.4, 1.0, 0/255, 0/255, 0/255, 1.64, 3.28, 3.32, 1), -- Traced
	Color(1.4, 1.4, 1.4, 1.0, 0/255, 0/255, 0/255, 1.8, 2.25, 2.6, 1), -- Martyr
}

local doomDuration = 180
local doomCountdown = 3
local doomDamageMulti = 4

function mod:PreventRemovingPrankCookieFlag(entity, player, flag)
	local params = TearFlagsLib.GetTearFlagParams(entity, flag)
	if params.NoRemove then
		return true
	end
end
mod:AddCallback(TearFlagsLib.Callback.PRE_REMOVE_TEARFLAG, mod.PreventRemovingPrankCookieFlag, flag)

local checkingForRockets = {}
function mod:applyPrankCookie(entity, player, weaponFlag)
	if weaponFlag == TearFlagsLib.WeaponFlag.EPIC_FETUS then
		local target
		if mod.CurrentRocketTarget then
			target = mod.CurrentRocketTarget
		elseif #checkingForRockets > 0 then
			target = checkingForRockets[#checkingForRockets]
		end
		if target and TearFlagsLib.HasTearFlags(target, flag) then
			local chosenEffect = TearFlagsLib.GetTearFlagParams(target, flag).Effect
			TearFlagsLib.AddTearFlags(entity, flag)
			TearFlagsLib.SetTearFlagParams(entity, flag, {Effect = chosenEffect})
			mod:GetEntityData(entity).FFExplosionColor = chosenEffect.Color
		end
	end
	if TearFlagsLib.HasTearFlags(entity, flag) then return end
	
	local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1

	local totalWeight = 0
	for i = 1, #mod.PRANK_COOKIE.EFFECTS do
		if not (mod.PRANK_COOKIE.EFFECTS[i].DataFlag == "Crit" and mod.PRANK_COOKIE.SKIP_CRIT_GENERIC:HasAnyFlag(weaponFlag)) and
		   not (mod.PRANK_COOKIE.EFFECTS[i].DataFlag == "YinYang" and mod.PRANK_COOKIE.SKIP_YIN_YANG_GENERIC:HasAnyFlag(weaponFlag))
		then
			totalWeight = totalWeight + mod.PRANK_COOKIE.EFFECTS[i].Weight
		end
	end

	local rand = math.random() * totalWeight
	local chosenEffect = nil
	for i = 1, #mod.PRANK_COOKIE.EFFECTS do
		if not (mod.PRANK_COOKIE.EFFECTS[i].DataFlag == "Crit" and mod.PRANK_COOKIE.SKIP_CRIT_GENERIC:HasAnyFlag(weaponFlag)) and
		   not (mod.PRANK_COOKIE.EFFECTS[i].DataFlag == "YinYang" and mod.PRANK_COOKIE.SKIP_YIN_YANG_GENERIC:HasAnyFlag(weaponFlag))
		then
			if rand <= mod.PRANK_COOKIE.EFFECTS[i].Weight then
				chosenEffect = mod.PRANK_COOKIE.EFFECTS[i]
				break
			end
			rand = rand - mod.PRANK_COOKIE.EFFECTS[i].Weight
		end
	end
	if chosenEffect == nil then
		chosenEffect = mod.PRANK_COOKIE.EFFECTS[#mod.PRANK_COOKIE.EFFECTS]
	end

	TearFlagsLib.AddTearFlags(entity, flag)
	TearFlagsLib.SetTearFlagParams(entity, flag, {Effect = chosenEffect})

	local tearcolor = chosenEffect.Color
	if chosenEffect.DataFlag == "Berserk" then
		if math.random(15) == 1 then
			FiendFolio.FlagBerserk(entity, 180 * secondHandMultiplier)
		end
	elseif chosenEffect.DataFlag == "Hemorrhaging" then
		if math.random() * 8 <= 2 then
			FiendFolio.FlagHemorrhage(entity, 90 * secondHandMultiplier, player.Damage * 0.5)
		end
	elseif chosenEffect.DataFlag == "Bruise" then
		if math.random() * 25 <= 5 then
			FiendFolio.FlagBruise(entity, 90 * secondHandMultiplier, 1, 1)
		end
	elseif chosenEffect.DataFlag == "Drowsy" then
		if math.random() * 25 <= 5 then
			FiendFolio.FlagDrowsy(entity, 40, 120 * secondHandMultiplier)
		end
	elseif chosenEffect.DataFlag == "Martyr" then
		if math.random() * 30 <= 5 then
			FiendFolio.FlagMartyr(entity, 150 * secondHandMultiplier)
			FiendFolio.FlagExcommunicate(entity, 90 * secondHandMultiplier, player.Damage)
		end
	elseif chosenEffect.DataFlag == "Sewn" then
		if math.random() * 40 <= 20 then
			FiendFolio.FlagSew(entity, 180 * secondHandMultiplier, 0.5)
			if entity.Type == EntityType.ENTITY_TEAR then
				entity.TearFlags = entity.TearFlags | TearFlags.TEAR_PIERCING
			elseif entity.Type == EntityType.ENTITY_BOMB then
				entity.Flags = entity.Flags | TearFlags.TEAR_PIERCING
			end
		end
	elseif chosenEffect.DataFlag == "Doom" then
		FiendFolio.FlagDoom(entity, doomDuration * secondHandMultiplier, doomCountdown, player.Damage * doomDamageMulti, 0.2)
	elseif chosenEffect.DataFlag == "Crit" then
		if mod.PRANK_COOKIE.SKIP_CRIT_GENERIC:HasAnyFlag(weaponFlag) then goto prankCookieFlagVisuals end
		
		if math.random(25) == 1 then
			local isTrickyCherry = mod:GetEntityData(player).TrickyCherryCrit

			TearFlagsLib.AddTearFlags(entity, mod.CritFlag)
			TearFlagsLib.SetTearFlagParams(entity, mod.CritFlag, {IsTrickyCherry = isTrickyCherry})
			mod:GetEntityData(entity).FFCritHitlist = nil

			if weaponFlag == TearFlagsLib.WeaponFlag.TEAR or weaponFlag == TearFlagsLib.WeaponFlag.LUDOVICO_TEAR or
			   weaponFlag == TearFlagsLib.WeaponFlag.BOBS_ROTTEN_HEAD or weaponFlag == TearFlagsLib.WeaponFlag.SHARP_KEY or
			   weaponFlag == TearFlagsLib.WeaponFlag.DR_FETUS or weaponFlag == TearFlagsLib.WeaponFlag.FF_PLANET_X
			then
				-- if this isn't scheduled then sometimes the index of the crit lightning is before the parent and it follows a frame behind as a result
				mod.scheduleForUpdate(function()
					local data = mod:GetEntityData(entity)
					if not data.critLightning or not data.critLightning:Exists() then
						sfx:Play(mod.Sounds.CritShoot, 0.3, 0, false, math.random(80,120)/100)
						local critLightning = Isaac.Spawn(1000, 1737, 1, entity.Position, nilvector, entity):ToEffect()
						critLightning.Parent = entity
						critLightning.Color = Color(1,1,1,0,0,0,1)
						critLightning:Update()
						mod:GetEntityData(critLightning).TrickyCherryCrit = isTrickyCherry
						data.critLightning = critLightning
					end
				end, 1)
			end

			tearcolor = (isTrickyCherry and Color(1.0,1.0,1.0,1,150/255,-150/255,-150/255)) or Color(1.0,1.0,1.0,1,100/255,-150/255,100/255)
		end
	elseif chosenEffect.DataFlag == "YinYang" then
		if mod:GetEntityData(entity).FrameAddedDichro and 
		   game:GetFrameCount() - mod:GetEntityData(entity).FrameAddedDichro < mod.DICHROMATIC_BUTTERFLY.LASER_HOMING_FRAMES 
		then 
			goto prankCookieFlagVisuals 
		end
		if mod.PRANK_COOKIE.SKIP_YIN_YANG_GENERIC:HasAnyFlag(weaponFlag) then goto prankCookieFlagVisuals end

		if math.random(20) < 5 then
			if weaponFlag == TearFlagsLib.WeaponFlag.TEAR then
			    local tear = entity:ToTear()
				tear.TearFlags = tear.TearFlags | TearFlags.TEAR_HOMING
	
				if not TearFlagsLib.HasTearFlags(entity, TearFlagsLib.Flag.YIN_YANG) then
					local origDamage, origScale = tear.CollisionDamage, tear.Scale
					tear.CollisionDamage = origDamage * (1.25 + 0.50 * math.max(player:GetTrinketMultiplier(mod.ITEM.TRINKET.YIN_YANG_ORB) - 1, 0))
					tear.Scale = origScale * (mod:getTearParamsScale(player, tear.CollisionDamage, tear.TearFlags) / mod:getTearParamsScale(player, origDamage, tear.TearFlags))
				end
			elseif weaponFlag == TearFlagsLib.WeaponFlag.LUDOVICO_TEAR then
				TearFlagsLib.SetTearFlagParams(entity, flag, {Strength = 0.4})

				local tear = entity:ToTear()
				tear.TearFlags = tear.TearFlags | TearFlags.TEAR_HOMING
				if not TearFlagsLib.HasTearFlags(entity, TearFlagsLib.Flag.YIN_YANG) then
					tear.CollisionDamage = tear.CollisionDamage * (1.25 + 0.50 * math.max(player:GetTrinketMultiplier(mod.ITEM.TRINKET.YIN_YANG_ORB) - 1, 0))
				end
			elseif weaponFlag == TearFlagsLib.WeaponFlag.BOBS_ROTTEN_HEAD then
				local tear = entity:ToTear()
				tear.TearFlags = tear.TearFlags | TearFlags.TEAR_HOMING
				if not TearFlagsLib.HasTearFlags(entity, TearFlagsLib.Flag.YIN_YANG) then
					mod.scheduleForUpdate(function()
						tear.CollisionDamage = (tear.CollisionDamage - 185) * (1.25 + 0.50 * math.max(player:GetTrinketMultiplier(mod.ITEM.TRINKET.YIN_YANG_ORB) - 1, 0)) + 185
					end, 1)
				end
			elseif weaponFlag == TearFlagsLib.WeaponFlag.SHARP_KEY then
				local tear = entity:ToTear()
				tear.TearFlags = tear.TearFlags | TearFlags.TEAR_HOMING
				if not TearFlagsLib.HasTearFlags(entity, TearFlagsLib.Flag.YIN_YANG) then
					mod.scheduleForUpdate(function()
						tear.CollisionDamage = (tear.CollisionDamage - 30) * (1.25 + 0.50 * math.max(player:GetTrinketMultiplier(mod.ITEM.TRINKET.YIN_YANG_ORB) - 1, 0)) + 30
					end, 1)
				end
			elseif weaponFlag == TearFlagsLib.WeaponFlag.DR_FETUS then
				local bomb = entity:ToBomb()
				if not TearFlagsLib.HasTearFlags(entity, TearFlagsLib.Flag.YIN_YANG) then
					bomb.ExplosionDamage = bomb.ExplosionDamage * (1.25 + 0.50 * math.max(player:GetTrinketMultiplier(mod.ITEM.TRINKET.YIN_YANG_ORB) - 1, 0))
				end
				bomb.Flags = bomb.Flags | TearFlags.TEAR_HOMING
			elseif weaponFlag == TearFlagsLib.WeaponFlag.AQUARIUS then
				if REPENTOGON.MeetsVersion("1.1.2") then
					entity:ToEffect():AddTearFlags(TearFlags.TEAR_HOMING)
				end
			elseif weaponFlag == TearFlagsLib.WeaponFlag.LASER then
				mod:GetEntityData(entity).FrameAddedDichro = game:GetFrameCount()

				local laser = entity:ToLaser()
				laser:AddTearFlags(TearFlags.TEAR_HOMING)
				laser:SetHomingType(1125515264) -- ?????????
				laser:RecalculateSamplesNextUpdate()
			elseif weaponFlag == TearFlagsLib.WeaponFlag.CLUB then
				entity:ToKnife():AddTearFlags(TearFlags.TEAR_HOMING)
			elseif weaponFlag == TearFlagsLib.WeaponFlag.SWORD then
				if not TearFlagsLib.HasTearFlags(entity, TearFlagsLib.Flag.YIN_YANG) then
					entity.CollisionDamage = entity.CollisionDamage * (1.25 + 0.50 * math.max(player:GetTrinketMultiplier(mod.ITEM.TRINKET.YIN_YANG_ORB) - 1, 0))
				end
				entity:ToKnife():AddTearFlags(TearFlags.TEAR_HOMING)
			elseif weaponFlag == TearFlagsLib.WeaponFlag.BRIMSTONE_BALL then
				if REPENTOGON.MeetsVersion("1.1.2") then
					entity:ToEffect():AddTearFlags(TearFlags.TEAR_HOMING)
				end
			elseif weaponFlag == TearFlagsLib.WeaponFlag.ANTI_GRAV_LASER or
				   weaponFlag == TearFlagsLib.WeaponFlag.UMBILICAL_WHIP or
				   weaponFlag == TearFlagsLib.WeaponFlag.CLUB_EPIC_FETUS
			then
				-- do nothing
			else
				TearFlagsLib.AddCustomVanillaTearFlags(entity, TearFlags.TEAR_HOMING)
				if not TearFlagsLib.HasTearFlags(entity, TearFlagsLib.Flag.YIN_YANG) then
					entity.CollisionDamage = entity.CollisionDamage * (1.25 + 0.50 * math.max(player:GetTrinketMultiplier(mod.ITEM.TRINKET.YIN_YANG_ORB) - 1, 0))
				end
			end

			TearFlagsLib.AddTearFlags(entity, TearFlagsLib.Flag.YIN_YANG)
		end
	elseif chosenEffect.DataFlag == "MultiEuclidean" then
		if math.random() * 8 <= 2 then
			FiendFolio.FlagMultiEuclidean(entity, 180 * secondHandMultiplier)
		end
	elseif chosenEffect.DataFlag == "Overloaded" then
		if math.random() * 30 <= 5 then
			FiendFolio.FlagOverload(entity, 3 * secondHandMultiplier, player.Damage * 0.4, 45, 15)
		end
	elseif chosenEffect.DataFlag == "Mugged" then
		if math.random() * 8 <= 2 then
			FiendFolio.FlagMug(entity, 90 * secondHandMultiplier)
		end
	elseif chosenEffect.DataFlag == "Pacified" then
		local rand = math.random()
		if rand * 100 <= 1 then
			FiendFolio.FlagNursing(entity, 120 * secondHandMultiplier)
		elseif rand * 100 <= 16 then
			FiendFolio.FlagPacified(entity, 120 * secondHandMultiplier)
		end
	elseif chosenEffect.DataFlag == "Traced" then
		if math.random() < 0.15 then
			TearFlagsLib.AddTearFlags(entity, TearFlagsLib.Flag.FF_KALUS_EYE)
		end
	end

	::prankCookieFlagVisuals::
	if weaponFlag == TearFlagsLib.WeaponFlag.TEAR then
		if not FiendFolio.HasCetusFlag(entity) then
			mod:changeTearVariant(entity, mod.TEAR.PRANK_COOKIE)
		end
		entity.Color = tearcolor
	elseif weaponFlag == TearFlagsLib.WeaponFlag.LUDOVICO_TEAR then
		mod:changeTearVariant(entity, mod.TEAR.PRANK_COOKIE)
		entity.Color = tearcolor
	elseif weaponFlag == TearFlagsLib.WeaponFlag.AQUARIUS then
		mod:GetEntityData(entity).FFAquariusTearColor = tearcolor
	elseif weaponFlag == TearFlagsLib.WeaponFlag.EPIC_FETUS or weaponFlag == TearFlagsLib.WeaponFlag.CLUB_EPIC_FETUS then
		mod:GetEntityData(entity).FFExplosionColor = tearcolor
	elseif weaponFlag == TearFlagsLib.WeaponFlag.LASER or 
	       weaponFlag == TearFlagsLib.WeaponFlag.ANTI_GRAV_LASER or 
	       weaponFlag == TearFlagsLib.WeaponFlag.KNIFE or
	       weaponFlag == TearFlagsLib.WeaponFlag.DARK_ARTS or
	       weaponFlag == TearFlagsLib.WeaponFlag.LOCUST or
	       weaponFlag == TearFlagsLib.WeaponFlag.UMBILICAL_WHIP or
	       weaponFlag == TearFlagsLib.WeaponFlag.BRIMSTONE_BALL or
	       weaponFlag == TearFlagsLib.WeaponFlag.BOBS_ROTTEN_HEAD or
	       weaponFlag == TearFlagsLib.WeaponFlag.SHARP_KEY or
	       weaponFlag == TearFlagsLib.WeaponFlag.OCULAR_RIFT or
	       weaponFlag == TearFlagsLib.WeaponFlag.HEMOPTYSIS
	then
		return
	else
		entity.Color = tearcolor
	end
end

function mod:prankCookieFlagGeneric(entity, player, weaponFlag)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.PRANK_COOKIE) then
		mod:applyPrankCookie(entity, player, weaponFlag)
	end
end
mod:AddPriorityCollectibleCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, -351, FiendFolio.ITEM.COLLECTIBLE.PRANK_COOKIE, mod.prankCookieFlagGeneric)
mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_CHANCELESS_TEARFLAGS, FiendFolio.ITEM.COLLECTIBLE.PRANK_COOKIE, function(_, entity, player, weaponFlag)
	--lol
	TearFlagsLib.AddTearFlags(entity, flag)
end)

function mod:prankCookieFlagLocust(entity, player, weaponFlag)
	mod:applyPrankCookie(entity, player, weaponFlag)
end
mod:AddEntityCallback(TearFlagsLib.Callback.POLL_LOCUST_TEARFLAGS, EntityType.ENTITY_FAMILIAR, FamiliarVariant.ABYSS_LOCUST, 
                      FiendFolio.ITEM.COLLECTIBLE.PRANK_COOKIE, mod.prankCookieFlagLocust, FiendFolio.ITEM.COLLECTIBLE.PRANK_COOKIE)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_EFFECT_UPDATE, math.huge, function(_, target)
	table.insert(checkingForRockets, target)
end, EffectVariant.TARGET)

mod:AddPriorityCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, -1 * math.huge, function(_, target)
	for i = #checkingForRockets, 1, -1 do
		local entity = checkingForRockets[i]
		table.remove(checkingForRockets, i)
		if GetPtrHash(target) == GetPtrHash(entity) then
			break
		end
	end
end, EffectVariant.TARGET)

mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, -351, function(_, entity, amount, flags, source, cooldown, extraSource)
	
	if flags & DamageFlag.DAMAGE_CLONES ~= 0 or not entity:ToNPC() then return end
	
	local source = extraSource or source
	local hitter = nil
	local ignoreYinYang = false
	local force = false
	if source.Type == 0 and flags & DamageFlag.DAMAGE_LASER > 0 then
		local potential = mod.CheckingForDmg[#mod.CheckingForDmg]
		if potential and TearFlagsLib.IsEntityOcularRift(potential) then
			hitter = potential
		end
	elseif source.Entity and TearFlagsLib.IsEntityOcularRift(source.Entity) then
		hitter = source.Entity
	elseif source.Type == EntityType.ENTITY_EFFECT and source.Variant == EffectVariant.DARK_SNARE and source.Entity and source.Entity.SpawnerEntity then
		hitter = source.Entity
	elseif source.Type == EntityType.ENTITY_FAMILIAR and source.Variant == FamiliarVariant.ABYSS_LOCUST and source.Entity and source.Entity.SubType == FiendFolio.ITEM.COLLECTIBLE.PRANK_COOKIE then
		hitter = source.Entity
		ignoreYinYang = true
		force = true
	end

	if not hitter then return end
	
	-- this is technically not accurate for ocular rift since it rolls every hit instead of every frame but idc
	-- this functions nicer for can of beans purposes
	-- i'll leave tearflagslib generally as it is but for weird stuff like this imma do this instead
	local player = TearFlagsLib.GetTearPlayer(hitter)
	if not player then return end
	
	local data = mod:GetEntityData(hitter)
	local frame = game:GetFrameCount()
	if not ignoreYinYang and data.AppliedDichro ~= frame then
		TearFlagsLib.SetTearFlagParams(hitter, TearFlagsLib.Flag.YIN_YANG, {NoRemove = false})
		TearFlagsLib.ClearTearFlags(hitter, TearFlagsLib.Flag.YIN_YANG)
	end
	if data.AppliedCrit ~= frame then
		TearFlagsLib.SetTearFlagParams(hitter, mod.CritFlag, {NoRemove = false})
		TearFlagsLib.ClearTearFlags(hitter, mod.CritFlag)
	end
	if data.RolledForPrankCookie ~= frame then
		TearFlagsLib.SetTearFlagParams(hitter, flag, {NoRemove = false})
		TearFlagsLib.ClearTearFlags(hitter,flag)
		
		local player = TearFlagsLib.GetTearPlayer(hitter)
		if force or player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.PRANK_COOKIE) then
			local totalWeight = 0
			for i = 1, #mod.PRANK_COOKIE.EFFECTS do
				if not (mod.PRANK_COOKIE.EFFECTS[i].DataFlag == "YinYang" and ignoreYinYang) then
					totalWeight = totalWeight + mod.PRANK_COOKIE.EFFECTS[i].Weight
				end
			end

			local rand = math.random() * totalWeight
			local chosenEffect = nil
			for i = 1, #mod.PRANK_COOKIE.EFFECTS do
				if not (mod.PRANK_COOKIE.EFFECTS[i].DataFlag == "YinYang" and ignoreYinYang) then
					if rand <= mod.PRANK_COOKIE.EFFECTS[i].Weight then
						chosenEffect = mod.PRANK_COOKIE.EFFECTS[i]
						break
					end
					rand = rand - mod.PRANK_COOKIE.EFFECTS[i].Weight
				end
			end
			if chosenEffect == nil then
				chosenEffect = mod.PRANK_COOKIE.EFFECTS[#mod.PRANK_COOKIE.EFFECTS]
			end

			if chosenEffect.DataFlag == "Crit" then
				TearFlagsLib.AddTearFlags(hitter, flag)
				TearFlagsLib.SetTearFlagParams(hitter, flag, {Effect = chosenEffect, NoRemove = true})
				
				if math.random(25) == 1 then
					local isTrickyCherry = mod:GetEntityData(player).TrickyCherryCrit
					TearFlagsLib.AddTearFlags(hitter, mod.CritFlag)
					TearFlagsLib.SetTearFlagParams(hitter, mod.CritFlag, {IsTrickyCherry = isTrickyCherry, NoRemove = true})
					data.FFCritHitlist = nil
					data.AppliedCrit = frame
				end
			elseif not ignoreYinYang and chosenEffect.DataFlag == "YinYang" then
				TearFlagsLib.AddTearFlags(hitter, flag)
				TearFlagsLib.SetTearFlagParams(hitter, flag, {Effect = chosenEffect})
				
				if math.random(20) < 5 then
					TearFlagsLib.AddTearFlags(hitter, TearFlagsLib.Flag.YIN_YANG)
					TearFlagsLib.SetTearFlagParams(hitter, TearFlagsLib.Flag.YIN_YANG, {NoRemove = true})
					data.AppliedDichro = frame
				end
			end
		end
		data.RolledForPrankCookie = frame
	end
end)

function mod:prankCookieOnLaserEndpointInit(endpointData, laser)
	endpointData.PrankCookieLaser = TearFlagsLib.HasTearFlags(laser, flag)
end

function mod:prankCookieUpdateLaserColors(laser, data)
	if data.PrankCookieLaser or TearFlagsLib.HasTearFlags(laser, flag) then
		local ticks = #prankCookieLaserColors * 7
		local currentTick = game:GetFrameCount() % ticks

		local colorA = prankCookieLaserColors[math.floor(currentTick / 7) + 1]
		local colorB = prankCookieLaserColors[math.ceil(currentTick / 7) % #prankCookieLaserColors + 1]
		laser.Color = Color.Lerp(colorA, colorB, (currentTick % 7) / 7)
	end
end

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.PRANK_COOKIE] = {
	BodyColor = Color(1,1,1,1,2.578/255,-19.469/255,-23.172/255,0.578,0.531,0.828,1),
	EyeAColor = Color(1,1,1,1,-31.875/255,-75.766/255,134.391/255,1.125,1.234,0.391,1),
	EyeBColor = Color(1,1,1,1,-31.875/255,-75.766/255,134.391/255,1.125,1.234,0.391,1)}

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	mod:applyPrankCookie(tear, familiar.Player, TearFlagsLib.WeaponFlag.TEAR)
end, FiendFolio.ITEM.COLLECTIBLE.PRANK_COOKIE)

function mod:prankCookieTearRender(tear, var, data, offset)
	local sprite = tear:GetSprite()
	local scale = tear.Scale
	local flags = tear.TearFlags
	
	local anim
	if scale <= 0.675 then
		anim = "Stone1Move"
	elseif scale <= 0.925 then
		anim = "Stone2Move"
	elseif scale <= 1.175 then
		anim = "Stone3Move"
	elseif scale <= 1.675 then
		anim = "Stone4Move"
	elseif scale <= 2.175 then
		anim = "Stone5Move"
	else
		anim = "Stone6Move"
	end
	
	if not sprite:IsPlaying(anim) then
		local frame = sprite:GetFrame()
		sprite:Play(anim, true)
		sprite:SetFrame(frame)
	end

	local spritescale = mod:getTearScale6(tear)
	local layers = sprite:GetAllLayers()
	for _, layer in ipairs(layers) do
		layer:SetSize(spritescale)
	end
	
	if flags & TearFlags.TEAR_FLAT == TearFlags.TEAR_FLAT then
		local adjustedVelocity = tear.Velocity
		if tear.WaitFrames > 0 then
			adjustedVelocity = tear.ContinueVelocity
		elseif (tear.FallingSpeed < 0 or 0.2 < tear.FallingSpeed) and 
		       flags & TearFlags.TEAR_LUDOVICO ~= TearFlags.TEAR_LUDOVICO and
		       ((flags & TearFlags.TEAR_ABSORB ~= TearFlags.TEAR_ABSORB and flags & TearFlags.TEAR_POP ~= TearFlags.TEAR_POP) or tear.Velocity:Length() <= 0.1) 
		then
			adjustedVelocity = adjustedVelocity + Vector(0, tear.FallingSpeed)
		end
		
		sprite.Rotation = adjustedVelocity:GetAngleDegrees()
		sprite.FlipX = false
		sprite.FlipY = false
	else
		sprite.Rotation = 0
		sprite.FlipX = false
		sprite.FlipY = false
	end
end
mod:AddCallback("FF_CUSTOM_TEAR_RENDER", mod.prankCookieTearRender, FiendFolio.TEAR.PRANK_COOKIE)

function mod:prankCookieTearSplat(tear, var, data)
	sfx:Play(SoundEffect.SOUND_BONE_SNAP, 0.5, 0, false, math.random() + 2.0)
	
	if tear.TearFlags & TearFlags.TEAR_EXPLOSIVE == TearFlags.TEAR_EXPLOSIVE then return end

	local scale = tear.Scale
	local color = tear:GetSprite().Color
	
	local poof = Isaac.Spawn(1000, EffectVariant.IMPACT, 0, tear.Position, nilvector, tear)
	poof:GetSprite().Color = color
	poof.SpriteScale = Vector(scale * 0.8, scale * 0.8)
	poof.PositionOffset = tear.PositionOffset
	
	for i = 1, 5 do
		local gib = Isaac.Spawn(1000, EffectVariant.TOOTH_PARTICLE, 920, tear.Position, RandomVector()*2, tear):ToEffect()
		gib.m_Height = math.min(-5, tear.Height)
		gib:GetSprite().Color = color
		gib.State = 2
	end
end
mod:AddCallback("FF_CUSTOM_TEAR_SPLAT", mod.prankCookieTearSplat, FiendFolio.TEAR.PRANK_COOKIE)