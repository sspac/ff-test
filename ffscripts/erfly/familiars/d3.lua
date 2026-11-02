local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local flag = TearFlagsLib.RegisterTearFlag("D3")

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, fam)
    fam.OrbitDistance = Vector(50,50)
    fam.OrbitSpeed = 1
    fam.OrbitLayer = 2
    fam:RecalculateOrbitOffset(fam.OrbitLayer, true)
end, mod.ITEM.FAMILIAR.D3)

local function TEARFLAG(x)
	return x >= 64 and BitSet128(0,1<<(x-64)) or BitSet128(1<<x,0)
end

mod:AddPriorityCallback(ModCallbacks.MC_POST_MODS_LOADED, -1 * math.huge, function()
	mod.D3Effects = {
		{TearFlagsLib = TearFlagsLib.Flag.DARKNESS, Misc = mod.handleDarknessD3},
		{TearFlagsLib = TearFlagsLib.Flag.EYE_OF_PROVIDENCE},
		{TearFlagsLib = TearFlagsLib.Flag.WNIC, Misc = mod.handleWNICD3},
		{TearFlagsLib = TearFlagsLib.Flag.YAAI, Misc = mod.handleYAAID3},
		{TearFlagsLib = TearFlagsLib.Flag.ZERO_POINT},
		{TearFlagsLib = TearFlagsLib.Flag.FORTUNE},
		{TearFlagsLib = TearFlagsLib.Flag.CHAOS_EGG_BOMB},
		{TearFlagsLib = TearFlagsLib.Flag.CHAOS_MAGNET_BOMB},
		{TearFlagsLib = TearFlagsLib.Flag.CHAOS_POOP_BOMB},
		{TearFlagsLib = TearFlagsLib.Flag.CHAOS_HOLY_BOMB},
		{TearFlagsLib = TearFlagsLib.Flag.CHAOS_BABY_BOMB},
		{TearFlagsLib = TearFlagsLib.Flag.CHAOS_ICE_BOMB},
		{TearFlagsLib = TearFlagsLib.Flag.CHAOS_FLYING_BOMB, Misc = mod.handleFlyingBombD3},
		{TearFlagsLib = TearFlagsLib.Flag.CHAOS_FORTUNE_BOMB},
		{TearFlagsLib = TearFlagsLib.Flag.CHAOS_MONEY_BOMB},
		{TearFlagsLib = TearFlagsLib.Flag.CHAOS_BUBBLE_BOMB},
		{TearFlagsLib = TearFlagsLib.Flag.FRIEND_FIRE, Misc = mod.handleFriendFireD3},
		{TearFlagsLib = TearFlagsLib.Flag.SOAPSUDS},
		{TearFlagsLib = TearFlagsLib.Flag.KALU},
		{TearFlagsLib = TearFlagsLib.Flag.CRIT, Misc = mod.handleCritD3},
		{TearFlagsLib = TearFlagsLib.Flag.FOOLS_GOLD_CLOT},
		{TearFlagsLib = TearFlagsLib.Flag.YIN_YANG, Basegame = TearFlags.TEAR_HOMING},
		{TearFlagsLib = TearFlagsLib.Flag.BLACK_MOON},
		{TearFlagsLib = TearFlagsLib.Flag.CETUS},
		{TearFlagsLib = TearFlagsLib.Flag.DRIED_PAINT},
		{TearFlagsLib = TearFlagsLib.Flag.SUNGLASSES, Misc = mod.handleSunglassesD3},
		{TearFlagsLib = TearFlagsLib.Flag.WHISKEY},
		{TearFlagsLib = TearFlagsLib.Flag.HORNCOB},
		{TearFlagsLib = TearFlagsLib.Flag.MODERN_OUROBOROS, Misc = mod.handleModernOuroborosD3},
		{TearFlagsLib = TearFlagsLib.Flag.PARANOIA, Misc = mod.handleParanoiaD3},
		{TearFlagsLib = TearFlagsLib.Flag.GUTS_BOMB},
		{TearFlagsLib = TearFlagsLib.Flag.REROLLIGAN},
		{TearFlagsLib = TearFlagsLib.Flag.TRINITY, Basegame = TearFlags.TEAR_SPECTRAL},
		{TearFlagsLib = TearFlagsLib.Flag.FOSSIL_BOMB},
		{TearFlagsLib = TearFlagsLib.Flag.FRACTAL, Basegame = TearFlags.TEAR_SPECTRAL},
		{TearFlagsLib = TearFlagsLib.Flag.AMBASSADOR, Misc = mod.handleAmbassadorD3},
		{TearFlagsLib = TearFlagsLib.Flag.BULLET_ETERNAL, Misc = mod.handleEternalBulletD3},
		{TearFlagsLib = TearFlagsLib.Flag.BULLET_BONE, Misc = mod.handleBoneBulletD3},
		{TearFlagsLib = TearFlagsLib.Flag.BULLET_MORBID, Misc = mod.handleMorbidBulletD3},
		{TearFlagsLib = TearFlagsLib.Flag.FESTERING, Misc = mod.handleFesteringD3},
		{TearFlagsLib = TearFlagsLib.Flag.BULLET_BLACK, Misc = mod.handleBlackBulletD3},
		{TearFlagsLib = TearFlagsLib.Flag.BULLET_SOUL},
		{TearFlagsLib = TearFlagsLib.Flag.BULLET_IMMORAL},
		{TearFlagsLib = TearFlagsLib.Flag.BULLET_LEAKY, Misc = mod.handleLeakyBulletD3},
		{TearFlagsLib = TearFlagsLib.Flag.BULLET_NO_FALL_TEAR},
		{TearFlagsLib = TearFlagsLib.Flag.BULLET_GRENADE, Misc = mod.handleGrenadeD3},
		{TearFlagsLib = TearFlagsLib.Flag.NUGGET_BOMB},
		{TearFlagsLib = TearFlagsLib.Flag.BERSERK, Misc = mod.handleBerserkD3},
		{TearFlagsLib = TearFlagsLib.Flag.BRUISE, Misc = mod.handleBruiseD3},
		{TearFlagsLib = TearFlagsLib.Flag.DOOM, Misc = mod.handleDoomD3},
		{TearFlagsLib = TearFlagsLib.Flag.DROWSY, Misc = mod.handleDrowsyD3},
		{TearFlagsLib = TearFlagsLib.Flag.DROWSY, Misc = mod.handleNightmareD3},
		{TearFlagsLib = TearFlagsLib.Flag.EXCOMMUNICATE, Misc = mod.handleExcommunicateD3},
		{TearFlagsLib = TearFlagsLib.Flag.GLEAMING, Misc = mod.handleGleamingD3},
		{TearFlagsLib = TearFlagsLib.Flag.HEMORRHAGE, Misc = mod.handleHemorrhageD3},
		{TearFlagsLib = TearFlagsLib.Flag.MARTYR, Misc = mod.handleMartyrD3},
		{TearFlagsLib = TearFlagsLib.Flag.MUG, Misc = mod.handleMugD3},
		{TearFlagsLib = TearFlagsLib.Flag.MULTIEUCLIDEAN, Misc = mod.handleMultiEuclideanD3},
		{TearFlagsLib = TearFlagsLib.Flag.NURSING, Misc = mod.handleNursingD3},
		{TearFlagsLib = TearFlagsLib.Flag.OVERLOAD, Misc = mod.handleOverloadD3},
		{TearFlagsLib = TearFlagsLib.Flag.PACIFIED, Misc = mod.handlePacifiedD3},
		{TearFlagsLib = TearFlagsLib.Flag.SEW, Basegame = TearFlags.TEAR_PIERCING, Misc = mod.handleSewD3},
		{TearFlagsLib = TearFlagsLib.Flag.BRIDGE_BOMB},
		{TearFlagsLib = TearFlagsLib.Flag.BEANS, Misc = mod.handleBeansD3},
		{TearFlagsLib = TearFlagsLib.Flag.GREEN_BOMB},
		{TearFlagsLib = TearFlagsLib.Flag.LOCUST_BOMB},
		{TearFlagsLib = TearFlagsLib.Flag.FF_ZIP_BOMB},
		{TearFlagsLib = TearFlagsLib.Flag.FABERGE_BOMB},
		{TearFlagsLib = TearFlagsLib.Flag.STRANGE_MATTER},
		{TearFlagsLib = TearFlagsLib.Flag.WARDING, Misc = mod.handleWardingD3},
		{TearFlagsLib = TearFlagsLib.Flag.MIND_RAZOR, Basegame = TearFlags.TEAR_PIERCING},
		{TearFlagsLib = TearFlagsLib.Flag.DEVILS_UMBRELLA, Misc = mod.handleDevilsUmbrellaD3},
		{TearFlagsLib = TearFlagsLib.Flag.GALLIUM},
		{TearFlagsLib = TearFlagsLib.Flag.FF_BLEED_OUT},
		{TearFlagsLib = TearFlagsLib.Flag.MI_BIRTHCAKE},
		{TearFlagsLib = TearFlagsLib.Flag.PEPPERMINT},
		{TearFlagsLib = TearFlagsLib.Flag.HONEY},
		{TearFlagsLib = TearFlagsLib.Flag.GODS_MARBLE},
		{TearFlagsLib = TearFlagsLib.Flag.POCKET_ROCKIT, Misc = mod.handlePocketRockitBlackD3},
		{TearFlagsLib = TearFlagsLib.Flag.POCKET_ROCKIT, Misc = mod.handlePocketRockitRedD3},
		{TearFlagsLib = TearFlagsLib.Flag.POCKET_ROCKIT, Misc = mod.handlePocketRockitYellowD3},
		{TearFlagsLib = TearFlagsLib.Flag.POCKET_ROCKIT, Misc = mod.handlePocketRockitGreenD3},
		{TearFlagsLib = TearFlagsLib.Flag.SENTENCED, Misc = mod.handleSentencedD3},
		{TearFlagsLib = TearFlagsLib.Flag.CERBERUS, Misc = mod.handleCerberusD3},
		{TearFlagsLib = TearFlagsLib.Flag.MODEL_ROCKET},
		{TearFlagsLib = TearFlagsLib.Flag.BRAIN_FOSSIL, Basegame = TearFlags.TEAR_HOMING, Misc = mod.handleBrainFossilD3},
		{TearFlagsLib = TearFlagsLib.Flag.CHEMICAL_COOKIE, Misc = mod.handleChemicalCookieD3},
        {TearFlagsLib = TearFlagsLib.Flag.MODULO, Misc = mod.handleModuloD3},
        {TearFlagsLib = TearFlagsLib.Flag.PALINSOPIA, Misc = mod.handlePalinsopiaD3},
        {TearFlagsLib = TearFlagsLib.Flag.FF_KALUS_EYE},
        {TearFlagsLib = TearFlagsLib.Flag.SPLATTERSHOT},
        {TearFlagsLib = TearFlagsLib.Flag.FF_INFESTATION_ZERO},
	}
	for i = 0, TearFlags.TEAR_EFFECT_COUNT - 1 do
		table.insert(mod.D3Effects, {Basegame = TEARFLAG(i)})
	end
end)

--Beautiful triangular tables (there has to be a better way to code something like this)
local d3tears = {
    10,
    9,9,
    8,8,8,
    7,7,7,7,
    6,6,6,6,6,
    5,5,5,5,5,5,
    4,4,4,4,4,4,4,
    3,3,3,3,3,3,3,3,
    2,2,2,2,2,2,2,2,2,
    1,1,1,1,1,1,1,1,1,1,
}

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, fam)
    local sprite = fam:GetSprite()
    local d = mod:GetEntityData(fam)
    local player = fam.Player
    local dist = 60 + (math.sin(fam.FrameCount / 5) * 15)
    fam.OrbitDistance = Vector(dist,dist)
    local targetPosition = fam:GetOrbitPosition(player.Position + player.Velocity)
    fam.Velocity = targetPosition - fam.Position
    fam.SpriteOffset = Vector(0,-2)
    fam.OrbitSpeed = -0.04

    --fam.Color = Color(1,1,1,0.3)

    for _, tear in ipairs(Isaac.FindInRadius(fam.Position, 15, EntityPartition.TEAR)) do
		tear = tear:ToTear()
        local td = mod:GetEntityData(tear)
        local denied
        if td.specialfiend or td.implosionCard then
            denied = true
        end
        if not (TearFlagsLib.HasTearFlags(tear, flag) or denied) then
            mod:changeToRandomTearVariant(tear, true)
            tear.Color = Color(math.random(200)/100, math.random(200)/100, math.random(200)/100, 1)
            local count = d3tears[math.random(#d3tears)]
            if tear.TearFlags == tear.TearFlags | mod:SetTearFlag(123) then
                count = 1
            end
            for i = 1, math.random(count) do
				local effect = mod.D3Effects[math.random(#mod.D3Effects)]
                if effect.Basegame then
                    tear:AddTearFlags(effect.Basegame)
                end
				if effect.TearFlagsLib then
					TearFlagsLib.AddTearFlags(tear, effect.TearFlagsLib)
				end
				if effect.Misc then
					effect.Misc(tear)
				end
            end
            local randExtraDamage = math.random(50,150) / 100
            tear.CollisionDamage = tear.CollisionDamage * randExtraDamage
            tear.Scale = tear.Scale * randExtraDamage
            tear.Velocity = tear.Velocity * (math.random(10,150) / 100)
            TearFlagsLib.AddTearFlags(tear, flag)
        end
    end

    local bombs = Isaac.FindByType(EntityType.ENTITY_BOMBDROP)
	for _, bomb in ipairs(bombs) do
        bomb = bomb:ToBomb()
        if bomb.IsFetus then
            if not TearFlagsLib.HasTearFlags(bomb, flag) then
                if bomb.Position:Distance(fam.Position) < 15 then
                    for i = 1, d3tears[math.random(#d3tears)] do
						local effect = mod.D3Effects[math.random(#mod.D3Effects)]
						if effect.Basegame then
							bomb:AddTearFlags(effect.Basegame)
						end
						if effect.TearFlagsLib then
							TearFlagsLib.AddTearFlags(bomb, effect.TearFlagsLib)
						end
						if effect.Misc then
							effect.Misc(bomb)
						end
                    end
                    bomb.Velocity = bomb.Velocity * (math.random(10,150) / 100)
                    bomb.Color = Color(math.random(200)/100, math.random(200)/100, math.random(200)/100, 1)
					TearFlagsLib.AddTearFlags(bomb, flag)
                end
            end
        end
    end

    --Laser Nonsense
    local lasers = Isaac.FindByType(EntityType.ENTITY_LASER)
	for _, laser in ipairs(lasers) do
        laser = laser:ToLaser()
        local ld = mod:GetEntityData(laser)
        if ld.rollColldown and ld.rollColldown > 0 then
            ld.rollColldown = ld.rollColldown - 1
            if ld.rollColldown <= 1 then
                ld.rollColldown = nil
            end
        elseif laser.SpawnerEntity and laser.SpawnerEntity.Type == 1 and (not (TearFlagsLib.HasTearFlags(laser, flag) or laser.Variant == 7)) then
            local laserStart = laser.Position
            local laserEnd = laser:GetEndPoint()
            local laserVec = laserEnd - laserStart
            local d3Vec = fam.Position - laserStart
            --print(laser.PositionOffset)
            local successful
            if d3Vec:Length() < laserVec:Length() then
                local dotProd = laserVec:Normalized():Dot(d3Vec:Normalized())
                if dotProd > 0.99 then
                    successful = true
                end
            end
            if successful then
                ld.rollColldown = ld.rollColldown or 10
                if not ld.shortenedByD3 then
                    ld.shortenedByD3 = laser.MaxDistance
                    local randomVar = math.random(14)
                    if randomVar >=7 then
                        randomVar = randomVar + 1
                    end
                    local wackyLaser = EntityLaser.ShootAngle(randomVar, fam.Position, laserVec:GetAngleDegrees(), laser.Timeout, nilvector, fam):ToLaser()
                    wackyLaser.Timeout = math.max(laser.Timeout, 10)
                    wackyLaser.CollisionDamage = laser.CollisionDamage
                    wackyLaser.MaxDistance = laserVec:Length() - d3Vec:Length()
                    wackyLaser.TearFlags = laser.TearFlags
                    for i = 1, d3tears[math.random(#d3tears)] do
						local effect = mod.D3Effects[math.random(#mod.D3Effects)]
						if effect.Basegame then
							wackyLaser:AddTearFlags(effect.Basegame)
						end
						if effect.TearFlagsLib then
							TearFlagsLib.AddTearFlags(wackyLaser, effect.TearFlagsLib)
						end
						if effect.Misc then
							effect.Misc(wackyLaser)
						end
                    end
                    local setColor
                    if math.random(3) == 1 then
                        if math.random(2) == 1 then
                            setColor = mod:tryMakeLaserSapphic(wackyLaser)
                        else
                            setColor = mod:tryMakeLaserTrans(wackyLaser)
                        end
                    end
                    local lascolor
                    if setColor then
                        if math.random(3) ~= 1 then
                            lascolor = Color(math.random(200)/100, math.random(200)/100, math.random(200)/100,1,0,0,0)
                        end
                    else
                        lascolor = Color(1,1,1,1,0,0,0)
                        lascolor:SetColorize(math.random(200)/100, math.random(200)/100, math.random(200)/100, 1)
                    end
                    if lascolor then
                        wackyLaser.Color = lascolor
                    end
					TearFlagsLib.AddTearFlags(wackyLaser, flag)
                    ld.trackedLaser = wackyLaser
                end
                if ld.trackedLaser then
                    local vec = (laserStart + laserVec:Resized(d3Vec:Length())) - fam.Position
                    ld.trackedLaser.PositionOffset = laser.PositionOffset + vec
                    ld.trackedLaser:Update()
                end
                laser.MaxDistance = d3Vec:Length()
                laser:Update()
            else
                if ld.shortenedByD3 then
                    laser.MaxDistance = ld.shortenedByD3
                    ld.shortenedByD3 = nil
                    laser:Update()
                    if ld.trackedLaser then
                        ld.trackedLaser.Timeout = math.min(ld.trackedLaser.Timeout, 10)
                        d.trackedLasers = d.trackedLasers or {}
                        table.insert(d.trackedLasers, ld.trackedLaser)
                        ld.trackedLaser = nil
                    end
                end
            end
        end
    end

    d.trackedLasers = d.trackedLasers or {}
    for _, laser in pairs(d.trackedLasers) do
        if laser:Exists() then
            laser.PositionOffset = mod:Lerp(laser.PositionOffset, Vector(0, -25), 0.15)
        end
    end

end, mod.ITEM.FAMILIAR.D3)