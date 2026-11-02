local mod = FiendFolio
local game = Game()

local flag = TearFlagsLib.RegisterTearFlag("CHEMICAL_COOKIE")

mod.CHEMICAL_COOKIE = {}
mod.CHEMICAL_COOKIE.ROLL_ON_HIT = TearFlagsLib.WeaponFlag.LASER |  TearFlagsLib.WeaponFlag.ANTI_GRAV_LASER | TearFlagsLib.WeaponFlag.KNIFE |
                                  TearFlagsLib.WeaponFlag.LOCUST | TearFlagsLib.WeaponFlag.BRIMSTONE_BALL | TearFlagsLib.WeaponFlag.OCULAR_RIFT |
                                  TearFlagsLib.WeaponFlag.FF_MALICE
mod.CHEMICAL_COOKIE.DO_CREEP_EFFECTS_ON_APPLY = TearFlagsLib.WeaponFlag.AQUARIUS
mod.CHEMICAL_COOKIE.PER_ENTITY_COOLDOWN = TearFlagsLib.BitSetInfinity.Zero
mod.CHEMICAL_COOKIE.PER_WEAPONFLAG_COOLDOWN = TearFlagsLib.WeaponFlag.AQUARIUS

local bal = {
    Frequency = {60, 10, 30},
    CreepDamage = 0.225,
    CreepScale = {1, 3},
    CreepRange = {100, 750},
    CreepNum = 7,

    MarkChance = 20,
    BaitDur = 80,

    OverloadedShocks = 1,
    OverloadedRest = 45,
    OverloadedDur = 15,

    SlowDur = 10,
    SlowMult = 0.6,

    BeamChance = 2,
    BeamDamage = 15,
    BeamMult = 1.5,

    HomeVel = {5, 0.1},
    HomeDist = 120,
    HomeDamage = 2.5,

    DoomChance = 15,
    DoomDur = 180,
    DoomNum = 5,
    DoomDamage = 4,

    ExcommunicateChance = 10,
    ExcommunicateDur = 45,
}

local redColor = Color(1, 0.6, 0.6, 1, 0.05, 0, 0)
redColor:SetColorize(1, 0.2, 0.2, 1)
local yellowColor = Color(1, 1, 0.5, 1, 0.05, 0.05, 0)
yellowColor:SetColorize(1.2, 1.2, 0.3, 1)
local greenColor = Color(0.2, 1, 0.2, 1, 0, 0.05, 0)
greenColor:SetColorize(0.3, 1.4, 0.3, 1)
local blueColor = Color(0.4, 0.4, 1, 1, 0, 0, 0.05)
blueColor:SetColorize(0.5, 0.5, 1.4, 1)
local purpleColor = Color(0.85, 0.2, 1, 1, 0.05, 0, 0.05)
purpleColor:SetColorize(1.2, 0.5, 1.5, 1)
local blackColor = Color(0.35, 0.35, 0.35, 1, 0, 0, 0)
blackColor:SetColorize(0.3, 0.3, 0.3, 1)
local whiteColor = Color(1, 1, 1, 1, 0, 0, 0)
whiteColor:SetColorize(1.1, 1.1, 1.1, 1)
local stringToColor = {Red = redColor, Yellow = yellowColor, Green = greenColor, Blue = blueColor, Purple = purpleColor, Black = blackColor, White = whiteColor}

local creepEffects = {
    [0] = {Name = "Red", Color = Color(1, 0, 0, 1, 1, 0, 0), OnDamage = function(npc, d, rng, c, secondHandMultiplier)
        if rng:RandomInt(100) < bal.MarkChance then
            local source = c
            if d.ChemicalCookieSpawner.Player and d.ChemicalCookieSpawner.Player:Exists() then
                source = d.ChemicalCookieSpawner.Player
            end
            npc:AddBaited(EntityRef(source), bal.BaitDur*secondHandMultiplier)
        end
    end,},
    [1] = {Name = "Yellow", Color = Color(1, 1, 0, 1, 1, 1, 0), OnDamage = function(npc, d, rng, c, secondHandMultiplier)
        local source = c
        if d.ChemicalCookieSpawner.Player and d.ChemicalCookieSpawner.Player:Exists() then
            source = d.ChemicalCookieSpawner.Player
        end
        mod.AddOverloaded(npc, source, 0, bal.OverloadedShocks * secondHandMultiplier, d.ChemicalCookieSpawner.DamageCalc, bal.OverloadedRest, bal.OverloadedDur, true)
    end,},
    [2] = {Name = "Green", Color = Color(0.3, 1, 0.2, 1, 0, 0.75, 0.2), OnDamage = function(npc, d, rng, c, secondHandMultiplier)
        local source = c
        if d.ChemicalCookieSpawner.Player and d.ChemicalCookieSpawner.Player:Exists() then
            source = d.ChemicalCookieSpawner.Player
        end
        npc:AddSlowing(EntityRef(source), bal.SlowDur * secondHandMultiplier, bal.SlowMult, Color(1.2,1.2,1.2,1,0,0,0.1))
    end,},
    [3] = {Name = "Blue", Color = Color(0.1, 0.1, 1, 1, 0.15, 0.15, 1), OnDamage = function(npc, d, rng, c, secondHandMultiplier)
        if rng:RandomInt(100) < bal.BeamChance then
            local source = c
            if d.ChemicalCookieSpawner.Player and d.ChemicalCookieSpawner.Player:Exists() then
                source = d.ChemicalCookieSpawner.Player
            end
            local beam = Isaac.Spawn(1000, EffectVariant.CRACK_THE_SKY, 0, npc.Position, Vector.Zero, source)
            beam.CollisionDamage = d.ChemicalCookieSpawner.Damage*bal.BeamMult + bal.BeamDamage
        end
    end, NotStatus = true},
    [4] = {Name = "Purple", Color = Color(0.2, 0, 1, 1, 0.3, 0, 0.6), OnDamage = function(npc, d, rng, c, secondHandMultiplier)
        return bal.HomeDamage
    end, NotStatus = true, OnUpdate = function(c, d, rng)
        local dist = bal.HomeDist
        local found
        for _,enemy in ipairs(Isaac.FindInRadius(c.Position, bal.HomeDist, EntityPartition.ENEMY)) do
            if not mod:isFriend(enemy) and enemy.GridCollisionClass > EntityGridCollisionClass.GRIDCOLL_BULLET and enemy:IsVulnerableEnemy()
            and not enemy:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) then
                if enemy.Position:Distance(c.Position) < dist then
                    found = enemy
                    dist = enemy.Position:Distance(c.Position)
                end
            end
        end
        if found then
            c.Velocity = mod:Lerp(c.Velocity, (found.Position-c.Position):Resized(bal.HomeVel[1]), bal.HomeVel[2])
        else
            c.Velocity = mod:Lerp(c.Velocity, Vector.Zero, bal.HomeVel[2])
        end
    end,},
    [5] = {Name = "Black", Color = Color(0, 0, 0, 1, 0, 0, 0), OnDamage = function(npc, d, rng, c, secondHandMultiplier)
        local source = c.Entity
        if d.ChemicalCookieSpawner.Player and d.ChemicalCookieSpawner.Player:Exists() then
        source = d.ChemicalCookieSpawner.Player
        end
		local ptrhash = GetPtrHash(npc)
		mod.QueuedStatusApply[ptrhash] = mod.QueuedStatusApply[ptrhash] or {}
		table.insert(mod.QueuedStatusApply[ptrhash], function()
			local ptrhash = GetPtrHash(npc)
			local remainingHP = mod.DoomHPEstimate[ptrhash] or npc.HitPoints
			local canApply = mod:CanApplyDoom(npc, source, c.Entity.CollisionDamage, 2)
			local playerDamage = mod:DoomGetEstimatedPlayerDamage(npc, source)
			local playerCountdown = math.floor(remainingHP / playerDamage)
			if playerCountdown * playerDamage == remainingHP then
				playerCountdown = playerCountdown - 1
			end
			if rng:RandomInt(100) < bal.DoomChance and canApply then
				mod.AddDoom(npc, source, bal.DoomDur * secondHandMultiplier, bal.DoomNum, d.ChemicalCookieSpawner.Damage*bal.DoomDamage, nil, nil, nil, nil, math.max(1, math.min(playerCountdown + 1, bal.DoomNum)))
			else
				local isBoss = npc:IsBoss()
				local ndata = mod:GetEntityData(npc)
				local hasDoom = ndata.FFDoomDuration ~= nil and ndata.FFDoomDuration > 0
				if remainingHP > playerDamage * 3 and not (isBoss or hasDoom) then
					local pdata = mod:GetEntityData(source)
					if math.random() <= ((bal.DoomChance/100 * 9) ^ ((pdata.DoomPseudoRandomCounter or 3) / 3)) / 9 then
						mod.AddDoom(npc, source, bal.DoomDur * secondHandMultiplier, bal.DoomNum, d.ChemicalCookieSpawner.Damage*bal.DoomDamage, nil, nil, nil, nil, math.max(1, math.min(playerCountdown + 1, bal.DoomNum)))
						pdata.DoomPseudoRandomCounter = math.min((pdata.DoomPseudoRandomCounter or 3) - 1, 3)
					else
						pdata.DoomPseudoRandomCounter = math.max((pdata.DoomPseudoRandomCounter or 3) + 1, 3)
					end
				end
			end
        end)
    end,},
    [6] = {Name = "White", Color = Color(0, 0, 0, 1, 1, 1, 1), OnDamage = function(npc, d, rng, c, secondHandMultiplier)
        if rng:RandomInt(100) < bal.ExcommunicateChance then
            local source = c
            if d.ChemicalCookieSpawner.Player and d.ChemicalCookieSpawner.Player:Exists() then
                source = d.ChemicalCookieSpawner.Player
            end
            mod.AddExcommunicated(npc, source, bal.ExcommunicateDur * secondHandMultiplier, d.ChemicalCookieSpawner.Damage, true)
        end
    end,},
}

local function SpawnChemicalCookieCreep(entity, pos)
    local entry = TearFlagsLib.GetTearFlagParams(entity, flag)
    local source = entity
    if entry.Player and entry.Player:Exists() then
        source = entry.Player
    end
    local creep = Isaac.Spawn(1000, EffectVariant.PLAYER_CREEP_RED, 0, pos or entity.Position, Vector.Zero, source):ToEffect()
    local cd = mod:GetEntityData(creep)
    cd.ChemicalCookieSpawner = entry
    creep.Color = creepEffects[entry.Num].Color
    local num = mod:ClampNumber(entry.Range, bal.CreepRange[1], bal.CreepRange[2])
	num = (num-bal.CreepRange[1])/(bal.CreepRange[2]-bal.CreepRange[1])
	local scale = ((bal.CreepScale[2]-bal.CreepScale[1])*num)+bal.CreepScale[1]
	creep.SpriteScale = Vector(scale, scale)
    creep.CollisionDamage = entry.DamageCalc
    return creep
end

function mod:ChemicalCookieEntDamage(npc, entry2, flags, source, d)
    if source.Type == 1000 and source.Variant == EffectVariant.PLAYER_CREEP_RED and d.ChemicalCookieSpawner then
        local entry = creepEffects[d.ChemicalCookieSpawner.Num]
        local check = entry.OnDamage(npc, d, source.Entity:GetDropRNG(), source, d.ChemicalCookieSpawner.SecondHand)
        if check then
            entry2.newDamage = entry2.newDamage*check
            entry2.sendNewDamage = true
        end
    end
end

function mod:chemicalCookieFlagGeneric(entity, player, weaponFlag)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.CHEMICAL_COOKIE) then
        local mult = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.CHEMICAL_COOKIE)
		local cooldown = math.max(bal.Frequency[2], bal.Frequency[1]-(mult-1)*bal.Frequency[3])

		local rollOnHit = mod.CHEMICAL_COOKIE.ROLL_ON_HIT:HasAnyFlag(weaponFlag)
		local perEntity = mod.CHEMICAL_COOKIE.PER_ENTITY_COOLDOWN:HasAnyFlag(weaponFlag)
		local frame = game:GetFrameCount()
		local playerCooldownIndex = (mod.CHEMICAL_COOKIE.PER_WEAPONFLAG_COOLDOWN:HasAnyFlag(weaponFlag) and weaponFlag) or -1
		local playerLastFrame = mod:GetEntityData(player).ChemicalCookieCountdowns and mod:GetEntityData(player).ChemicalCookieCountdowns[playerCooldownIndex]
        if rollOnHit or
		   (perEntity and (mod:GetEntityData(entity).ChemicalCookieLastFrame == nil or frame - mod:GetEntityData(entity).ChemicalCookieLastFrame >= cooldown)) or
		   (not perEntity and (playerLastFrame == nil or frame - playerLastFrame >= cooldown))
		then
            local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.CHEMICAL_COOKIE)
            local num = false
			if not rollOnHit then
				num = rng:RandomInt(bal.CreepNum)
				if perEntity then
					mod:GetEntityData(entity).ChemicalCookieLastFrame = frame
				else
					mod:GetEntityData(player).ChemicalCookieCountdowns = mod:GetEntityData(player).ChemicalCookieCountdowns or {}
					mod:GetEntityData(player).ChemicalCookieCountdowns[playerCooldownIndex] = frame
				end
			end

			TearFlagsLib.AddTearFlags(entity, flag)
			TearFlagsLib.SetTearFlagParams(entity, flag, {
				Num = num,
				Damage = player.Damage,
				DamageCalc = player.Damage*bal.CreepDamage*mult,
				Player = player,
				Range = player.TearRange,
				SecondHand = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND)+1
			})

			if num then
				local color = creepEffects[num].Name
				if weaponFlag == TearFlagsLib.WeaponFlag.AQUARIUS then
					mod:GetEntityData(entity).FFAquariusTearColor = stringToColor[color]
				elseif weaponFlag == TearFlagsLib.WeaponFlag.EPIC_FETUS or weaponFlag == TearFlagsLib.WeaponFlag.CLUB_EPIC_FETUS then
					mod:GetEntityData(entity).FFExplosionColor = stringToColor[color]
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
					entity.Color = stringToColor[color]
				end
			end
		end
	end
end
mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, FiendFolio.ITEM.COLLECTIBLE.CHEMICAL_COOKIE, mod.chemicalCookieFlagGeneric)

function mod:chemicalCookieFlagLocust(entity, player, weaponFlag)
	TearFlagsLib.AddTearFlags(entity, flag)
	TearFlagsLib.SetTearFlagParams(entity, flag, {
		Damage = player.Damage,
		DamageCalc = player.Damage*bal.CreepDamage*mult,
		Player = player,
		Range = player.TearRange,
		SecondHand = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND)+1
	})
end
mod:AddEntityCallback(TearFlagsLib.Callback.POLL_LOCUST_TEARFLAGS, EntityType.ENTITY_FAMILIAR, FamiliarVariant.ABYSS_LOCUST,
                      FiendFolio.ITEM.COLLECTIBLE.CHEMICAL_COOKIE, mod.chemicalCookieFlagLocust, FiendFolio.ITEM.COLLECTIBLE.CHEMICAL_COOKIE)

local function getClosestPointOnLine(testPosition, lineOrigin, lineEnd)
	local heading = lineEnd - lineOrigin
	local magnitude = heading:Length()
	heading:Normalize()

	local lhs = testPosition - lineOrigin
	local dot = lhs:Dot(heading)
	dot = math.min(math.max(0, dot), magnitude)
	return lineOrigin + heading * dot
end

local function movePosToClosestLaserSegment(pos, laser)
	local closestPoint = pos
	local closestDist = math.huge
	local capsules
	if laser:IsSampleLaser() then
		capsules = TearFlagsLib.GetLaserSampleCapsules(laser)
	else
		capsules = {TearFlagsLib.GetCapsule(laser.Position, laser.Position + Vector.FromAngle(laser.AngleDegrees) * 9999, laser.Radius)}
	end
	for _, laserCapsule in pairs(capsules) do
		local pointOnLine = getClosestPointOnLine(pos, laserCapsule.Locus1, laserCapsule.Locus2)
		local dist = pointOnLine:Distance(pos)
		if dist < closestDist then
			closestPoint = pointOnLine
			closestDist = dist
		end
	end
	return closestPoint
end

function mod:applyChemicalCookieFlag(entity, player, source, weaponFlag)
	if weaponFlag == TearFlagsLib.WeaponFlag.FF_PLANET_X then
		local fdata = mod:GetEntityData(source)
		if fdata.HasHitThisRoll then
			return
		end
	end

	local params = TearFlagsLib.GetTearFlagParams(source, flag)
    local mult = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.CHEMICAL_COOKIE)
	local cooldown = math.max(bal.Frequency[2], bal.Frequency[1]-(mult-1)*bal.Frequency[3])
	local perEntity = mod.CHEMICAL_COOKIE.PER_ENTITY_COOLDOWN:HasAnyFlag(weaponFlag)
	local frame = game:GetFrameCount()
	local playerCooldownIndex = (mod.CHEMICAL_COOKIE.PER_WEAPONFLAG_COOLDOWN:HasAnyFlag(weaponFlag) and weaponFlag) or -1
	local playerLastFrame = mod:GetEntityData(player).ChemicalCookieCountdowns and mod:GetEntityData(player).ChemicalCookieCountdowns[playerCooldownIndex]
	if not params.Num and
	   ((perEntity and (mod:GetEntityData(entity).ChemicalCookieLastFrame == nil or frame - mod:GetEntityData(entity).ChemicalCookieLastFrame >= cooldown)) or
	    (not perEntity and (playerLastFrame == nil or frame - playerLastFrame >= cooldown)))
	then
        local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.CHEMICAL_COOKIE)
		params.Num = rng:RandomInt(bal.CreepNum)
		if perEntity then
			mod:GetEntityData(entity).ChemicalCookieLastFrame = frame
		else
			mod:GetEntityData(player).ChemicalCookieCountdowns = mod:GetEntityData(player).ChemicalCookieCountdowns or {}
			mod:GetEntityData(player).ChemicalCookieCountdowns[playerCooldownIndex] = frame
		end
		TearFlagsLib.SetTearFlagParams(source, flag, params)
	end

	if mod.CHEMICAL_COOKIE.DO_CREEP_EFFECTS_ON_APPLY:HasAnyFlag(weaponFlag) then
		if params.Num then
			creepEffects[params.Num].OnDamage(entity, {ChemicalCookieSpawner = params}, source:GetDropRNG(), EntityRef(source), params.SecondHand)
		end
	elseif not FiendFolio.HasCetusFlag(source) then
		local pos = source.Position
		if source.Type == EntityType.ENTITY_LASER then
			pos = movePosToClosestLaserSegment(entity.Position, source:ToLaser())
		elseif weaponFlag == TearFlagsLib.WeaponFlag.CLUB and source.SubType == 4 then
			local capsulePosition, capsuleRadius = TearFlagsLib.GetSwingingKnifeCapsulePositionRadius(source)
			pos = (capsulePosition - entity.Position):Resized(entity.Size * math.max(entity.SizeMulti.X, entity.SizeMulti.Y)) + entity.Position
		elseif weaponFlag == TearFlagsLib.WeaponFlag.SWORD then
			pos = mod:getSwordCollidePos((hitbox or source):ToKnife(), entity)
			if pos == nil then
				return
			end
		elseif weaponFlag == TearFlagsLib.WeaponFlag.FF_PROVIDENCE_LASER then
			pos = entity.Position
		end

		if params.Num then
			SpawnChemicalCookieCreep(source, pos)
		end
	end
end
mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, mod.applyChemicalCookieFlag, flag)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, e)
    local d = mod:GetEntityData(e)
    if d.ChemicalCookieSpawner then
        local entry = creepEffects[d.ChemicalCookieSpawner.Num]
        if entry.OnUpdate then entry.OnUpdate(e, d, e:GetDropRNG()) end
    end
end, EffectVariant.PLAYER_CREEP_RED)

function mod:chemicalCookieAquariusUpdate(e)
    if TearFlagsLib.HasTearFlags(e, flag) then
		local params = TearFlagsLib.GetTearFlagParams(e, flag)
        local entry = creepEffects[params.Num]
        if entry.OnUpdate then entry.OnUpdate(e, mod:GetEntityData(e), e:GetDropRNG()) end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.chemicalCookieAquariusUpdate, EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL)

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.CHEMICAL_COOKIE] = {
	BodyColor = Color(1,1,1,1,81.531/255,-13.234/255,-45.219/255,0.531,0.766,0.781,1),
	EyeAColor = Color(1,1,1,1,221.109/255,-30.172/255,-11.094/255,0.109,0.828,0.906,1),
	EyeBColor = Color(1,1,1,1,221.109/255,-30.172/255,-11.094/255,0.109,0.828,0.906,1)}

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, familiar)
	if familiar.SubType == FiendFolio.ITEM.COLLECTIBLE.CHEMICAL_COOKIE then
		local d = mod:GetEntityData(familiar)
        d.ChemicalCookieCountdown = d.ChemicalCookieCountdown or math.max(bal.Frequency[2], bal.Frequency[1])

        if not d.ChemicalCookieReady then
            if d.ChemicalCookieCountdown > 0 then
                d.ChemicalCookieCountdown = d.ChemicalCookieCountdown-1
            else
                d.ChemicalCookieReady = true
                d.ChemicalCookieCountdown = math.max(bal.Frequency[2], bal.Frequency[1])
            end
        end
    end
end, FiendFolio.ITEM.FAMILIAR.SEWING_MANUAL_DOLL)

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	if mod:GetEntityData(familiar).ChemicalCookieReady then
        local rng = familiar.Player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.CHEMICAL_COOKIE)
        local num = rng:RandomInt(bal.CreepNum)
        mod:GetEntityData(familiar).ChemicalCookieReady = nil

		TearFlagsLib.AddTearFlags(tear, flag)
		TearFlagsLib.SetTearFlagParams(tear, flag, {
			Num = num,
			Damage = 3.5,
			DamageCalc = 3.5*bal.CreepDamage,
			Player = familiar.Player,
			Range = 260.0,
			SecondHand = familiar.Player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND)+1
		})

		local color = creepEffects[num].Name
		tear.Color = stringToColor[color]
    end
end, FiendFolio.ITEM.COLLECTIBLE.CHEMICAL_COOKIE)

function mod.handleChemicalCookieD3(entity)
	local player = TearFlagsLib.GetTearPlayer(entity) or Isaac.GetPlayer()
	local params = TearFlagsLib.GetTearFlagParams(entity, flag)
	TearFlagsLib.SetTearFlagParams(entity, flag, {
		Num = num,
		Damage = (player and player.Damage) or 3.5,
		DamageCalc = ((player and player.Damage) or 3.5)*bal.CreepDamage,
		Player = player,
		Range = player.TearRange or 260.0,
		SecondHand = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND)+1
	})
end