local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local rocketflag = TearFlagsLib.RegisterTearFlag("POCKET_ROCKIT")
local greenflag = TearFlagsLib.RegisterTearFlag("POCKET_ROCKIT_GREEN")
local redflag = TearFlagsLib.RegisterTearFlag("POCKET_ROCKIT_RED")
local blackflag = TearFlagsLib.RegisterTearFlag("POCKET_ROCKIT_BLACK")

local disallowedFlags = TearFlags.TEAR_SPLIT | TearFlags.TEAR_QUADSPLIT | TearFlags.TEAR_BONE | TearFlags.TEAR_ABSORB | TearFlags.TEAR_BURSTSPLIT | TearFlags.TEAR_SPORE
mod.PocketRockitDisallowedCustomFlags = (mod.PocketRockitDisallowedCustomFlags or TearFlagsLib.BitSetInfinity.Zero) | rocketflag

mod.PocketRockitSplitWhitelist = {
	[SplitTearType.MULTIDIMENSIONAL] = true,
	[SplitTearType.ANGELIC_PRISM] = true,
	["FF_WNIC"] = true,
	["FF_WORMHOLE_ROCK"] = true,
}

--0 - black, 1 = red, 2 = yellow, 3 = green
local secondaryFlag = mod:AddSecondaryFireTearFlag("POCKET_ROCKIT")
mod:AddPriorityTrinketCallback(FiendFolio.CALLBACK.FF_SECONDARY_FIRE_TEAR_EFFECTS, CallbackPriority.LATE, FiendFolio.ITEM.ROCK.POCKET_ROCKIT, function(_, tear, player, dir, source, flags)
	if flags & secondaryFlag == 0 and player:HasTrinket(FiendFolio.ITEM.ROCK.POCKET_ROCKIT) then
		local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.POCKET_ROCKIT)
		local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.POCKET_ROCKIT)
        local chance = 10*mult+mod.XalumLuckBonus(player.Luck, 10, 0.15)*100

        if rng:RandomInt(100) < chance then
			mod:firePocketRocketTear(player, tear, dir, source, flags ~= 0, flags)
			return flags | secondaryFlag
		end
	end
end)

mod:AddTrinketCallback(FiendFolio.CALLBACK.FF_SECONDARY_FIRE, FiendFolio.ITEM.ROCK.POCKET_ROCKIT, function(_, player, dir, amount, owner, params)
	if player:HasTrinket(mod.ITEM.ROCK.POCKET_ROCKIT) then
		local weaponType = params.WeaponType
		local modifiers = params.WeaponModifiers
		local charge = params.WeaponCharge
		local maxFireDelay = params.WeaponMaxFireDelay
		local numTears = params.NumTears
		if not params.ForceTearEffects and
		   ((weaponType == WeaponType.WEAPON_TEARS and not (params.GatlingGun or params.SwallowedM90 or params.RapidFireOpal)) or 
		    (weaponType == WeaponType.WEAPON_MONSTROS_LUNGS and not player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS)) or
		    (weaponType == WeaponType.WEAPON_BONE and modifiers & WeaponModifier.MONSTROS_LUNG == WeaponModifier.MONSTROS_LUNG and charge >= maxFireDelay * 2) or
		    (weaponType == WeaponType.WEAPON_SPIRIT_SWORD and params.FriendGun and params.IsFriendChargedSlash))
		then 
			return 
		end
		local isMonstrosLung = (weaponType == WeaponType.WEAPON_MONSTROS_LUNGS or modifiers & WeaponModifier.MONSTROS_LUNG == WeaponModifier.MONSTROS_LUNG) and 
		                       weaponType ~= WeaponType.WEAPON_URN_OF_SOULS and weaponType ~= WeaponType.WEAPON_SPIRIT_SWORD and weaponType ~= WeaponType.WEAPON_FETUS
		
		local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.POCKET_ROCKIT)
		local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.POCKET_ROCKIT)
        local chance = 10*mult+mod.XalumLuckBonus(player.Luck, 10, 0.15)*100
		local numProcs = 0
		for i = 1, numTears do
			if rng:RandomInt(100) < chance then
				numProcs = numProcs + 1
			end
		end
		
		for i = 1, numProcs do
			local pos = Vector(0,0)
			local vel = nil
			if isMonstrosLung then
				local a = mod:getSign(rng) * rng:RandomFloat()
				local b = (mod:getSign(rng) * rng:RandomFloat() * math.pi) * 2
				
				local x = math.cos(b) * a * 3.5 + player.ShotSpeed * dir:Resized(player.TearRange / 20).X;
				local y = math.sin(b) * a * 3.5 + player.ShotSpeed * dir:Resized(player.TearRange / 20).Y;
				
				vel = Vector(x,y)
			else
				pos, vel = mod:GetMultiShotPositionVelocityBasic(dir * 10 + player:GetTearMovementInheritance(dir), player.ShotSpeed, numProcs, i - 1)
			end
			mod:firePocketRocketTear(player, nil, vel, owner, nil, nil, pos)
		end
	end
end)

function mod:firePocketRocketTear(player, tear, dir, source, spawnNew, flags, posOffset)
	local flags = flags or 0
	
	local isNewTear = tear == nil or spawnNew
	if isNewTear then
		if flags & mod.SecondaryFireTearFlags.RECURSIVE ~= 0 then return end
		tear = mod:SpawnPlayerTear(player, ((source and source.Position) or player.Position) + (posOffset or Vector(0,0)), dir:Resized(6.6*player.ShotSpeed))
	else
		tear.Velocity = tear.Velocity * 0.66
	end
	
    local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.POCKET_ROCKIT)
    sfx:Play(SoundEffect.SOUND_ROCKET_LAUNCH_SHORT, 0.7, 0, false, 1.6)
	tear:ChangeVariant(mod.FF.PocketRockitTear.Var)
	local sprite = tear:GetSprite()
    local rand = rng:RandomInt(4)
	TearFlagsLib.AddTearFlags(tear, rocketflag)
	TearFlagsLib.SetTearFlagParams(tear, rocketflag, {
		originalColor = tear.Color,
		pattern = rand,
	})
    tear.Color = Color(1,1,1,1,0,0,0)
    tear.Scale = 1
    sprite:ReplaceSpritesheet(0, "gfx/projectiles/projectile_rockit" .. rand .. ".png")
    sprite:LoadGraphics()
	
	if isNewTear then
		Isaac.RunCallback(FiendFolio.CALLBACK.FF_POST_FIRE_SECONDARY_TEAR, tear, player)
		tear:Update()
	end
end

function mod:pocketRocketUpdate(player)
    if player:HasTrinket(FiendFolio.ITEM.ROCK.POCKET_ROCKIT) then
        local data = mod:GetEntityData(player)
        data.thisIsDUMBPocketRocket = {}
        for _, enemy in ipairs(Isaac.FindInRadius(game:GetRoom():GetCenterPos(), 1000, EntityPartition.ENEMY)) do
            if enemy:ToNPC() and not (enemy:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) or enemy:HasEntityFlags(EntityFlag.FLAG_NO_TARGET)) then
                table.insert(data.thisIsDUMBPocketRocket, enemy)
            end
        end
    end
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.ROCK.POCKET_ROCKIT, mod.pocketRocketUpdate)

--Danial effectively asked for this
FiendFolio.AddItemPickupCallback(function(player, added)
    if player:HasTrinket(FiendFolio.ITEM.ROCK.POCKET_ROCKIT) then
        if Options.Filter then
            Options.Filter = false
        end
    end
end, nil, CollectibleType.COLLECTIBLE_20_20)

local preventWNIC = false
function mod.pocketRocketTear(v, d)
    --if v.Variant ~= mod.FF.PocketRockitTear.Var then return end

    if TearFlagsLib.HasTearFlags(v, rocketflag) then
        local room = game:GetRoom()
        local sprite = v:GetSprite()
        sprite.Rotation = v.Velocity:GetAngleDegrees()
        v.FallingAcceleration = 0
        v.FallingSpeed = 0

        if v.SpawnerEntity and v.SpawnerEntity:ToPlayer() then
            local d2 = mod:GetEntityData(v.SpawnerEntity)
            local enemyList = d2.thisIsDUMBPocketRocket or Isaac.FindInRadius(v.Position, 500, EntityPartition.ENEMY)
            local dist = 500
            local foundTarget = false
            local shoot = false

            for _,enemy in ipairs(enemyList) do
                if enemy.Position:Distance(v.Position) < dist and room:CheckLine(enemy.Position, v.Position, 3, 0, false, false) then
                    d.pocketRocketTarget = enemy
                    foundTarget = true
                    dist = enemy.Position:Distance(v.Position)
                    if dist < 200 then
                        shoot = true
                    end
                end
            end
            if foundTarget == false then
                d.pocketRocketTarget = nil
            end

            if d.pocketRocketTarget then
                local tVel = (d.pocketRocketTarget.Position-v.Position)
                local difference = mod:GetAngleDifference(v.Velocity, tVel)
                if difference < 120 then
                    v.Velocity = v.Velocity:Rotated(-4)
                elseif difference > 240 then
                    v.Velocity = v.Velocity:Rotated(4)
                end

                if shoot and v.FrameCount % 8 == 0 then
					preventWNIC = true
                    local newTear = TearFlagsLib.FireSplitTear(v, (d.pocketRocketTarget.Position-v.Position):Resized(10), TearFlagsLib.GetTearPlayer(v), {
						RemoveFlags = disallowedFlags,
						RemoveCustomFlags = mod.PocketRockitDisallowedCustomFlags,
						
						ColorOverride = TearFlagsLib.GetTearFlagParams(v, rocketflag).originalColor or Color(1,1,1,1,0,0,0),
						DamageMult = 0.35,
						ScaleOverride = 0.2,
						TearVariant = TearVariant.BLUE,
						SplitTearType = "FF_POCKET_ROCKIT_FIRE",
					})
					preventWNIC = false
                end
            end
        end

        if v.FrameCount % 6 == 0 then
            local smoke = Isaac.Spawn(1000, mod.FF.FFWhiteSmoke.Var, mod.FF.FFWhiteSmoke.Sub, v.Position, -v.Velocity:Resized(1)+RandomVector()*math.random(1,2)/2, v)
            mod:GetEntityData(smoke).longonly = true
            smoke.SpriteScale = Vector(0.3, 0.3)
            smoke.Color = Color(0.6, 0.6, 0.6, 0.6, 0, 0, 0)
            smoke.SpriteOffset = Vector(0, v.Height*0.8)
            smoke:Update()
        elseif v.FrameCount % 9 == 0 then
            local ember = Isaac.Spawn(1000, 66, 0, v.Position, -v.Velocity:Resized(1)+RandomVector()*math.random(1,2)/2, v)
            ember.SpriteOffset = Vector(0, v.Height*0.8)
            ember:Update()
        end
    elseif TearFlagsLib.HasTearFlags(v, blackflag) then
		local params = TearFlagsLib.GetTearFlagParams(v, blackflag)
        local targetpos = params.originalPos+params.originalDir:Rotated(v.FrameCount*6*((params and params.orient) or 1)):Resized(params.originalDir:Length()*(math.min(16, v.FrameCount)))
		v.Velocity = targetpos-v.Position

		if v.FrameCount < 100 then
			v.FallingAcceleration = 0
            v.FallingSpeed = 0
		end
    elseif TearFlagsLib.HasTearFlags(v, redflag) then
        v.Velocity = v.Velocity*0.75

        if v.FrameCount < 100 then
			v.FallingAcceleration = 0
            v.FallingSpeed = 0
		end
    elseif TearFlagsLib.HasTearFlags(v, greenflag) then
		local params = TearFlagsLib.GetTearFlagParams(v, greenflag)
        v.Velocity = v.Velocity:Rotated(11*((params and params.orient) or 1))

        if v.FrameCount < 70 then
			v.FallingAcceleration = 0
            v.FallingSpeed = 0
		end
    end
end

function mod:pocketRocketTearRemove(v)
    if v.Variant == mod.FF.PocketRockitTear.Var then
        sfx:Stop(SoundEffect.SOUND_TEARIMPACTS)
        sfx:Play(SoundEffect.SOUND_POT_BREAK, 0.5, 0, false, 3)
        local impact = Isaac.Spawn(1000, 97, 0, v.Position, Vector.Zero, v)
        impact.SpriteScale = Vector(0.7, 0.7)
        impact.SpriteOffset = Vector(0, v.Height or 0)

        for i=1,2 do
            local part = Isaac.Spawn(1000, 98, 0, v.Position, RandomVector()*math.random(3), v)
            local color = Color(0.6, 0.6, 1, 1, 0, 0, 0)
            color:SetColorize(1, 1, 1, 1)
            part.Color = color
        end
	end

    if TearFlagsLib.HasTearFlags(v, rocketflag) then
		local params = TearFlagsLib.GetTearFlagParams(v, rocketflag)
		if not params.pattern then return end
		
        local rng = v:GetDropRNG()
        local dam = v.CollisionDamage*0.35
		local player = TearFlagsLib.GetTearPlayer(v)
		local color = params.originalColor or Color(1,1,1,1,0,0,0)
        if params.pattern == 0 then
            local randOrient = rng:RandomInt(360)
            local orient = 1-rng:RandomInt(2)*2
            for i=1,6 do
				preventWNIC = true
                local newTear = TearFlagsLib.FireSplitTear(v, Vector(0,6):Rotated(i*60+randOrient), player, {
					RemoveFlags = disallowedFlags,
					RemoveCustomFlags = mod.PocketRockitDisallowedCustomFlags,
					
					ColorOverride = color,
					DamageOverride = dam,
					ScaleOverride = 0.65+0.35*(i%2),
					TearVariant = TearVariant.BLUE,
					SplitTearType = "FF_POCKET_ROCKIT_BLACK",
				})
				preventWNIC = false
                newTear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
				TearFlagsLib.AddTearFlags(newTear, blackflag)
				TearFlagsLib.SetTearFlagParams(newTear, blackflag, {
					originalPos = v.Position,
					originalDir = Vector(0,6):Rotated(i*60+randOrient),
					orient = orient,
				})
            end
        elseif params.pattern == 1 then
            local vel = 4
            for i=-30,30,30 do
                local ang = 30
                local newVel = vel
                if i ~= 0 then
                    newVel = vel/math.cos(math.rad(ang))
                end
				preventWNIC = true
                local newTear = TearFlagsLib.FireSplitTear(v, v.Velocity:Rotated(-180+i):Resized(newVel), player, {
					RemoveFlags = disallowedFlags,
					RemoveCustomFlags = mod.PocketRockitDisallowedCustomFlags,
					
					ColorOverride = color,
					DamageOverride = dam,
					ScaleOverride = 0.7,
					TearVariant = TearVariant.BLUE,
					SplitTearType = "FF_POCKET_ROCKIT_RED",
				})
				preventWNIC = false
                newTear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
				TearFlagsLib.AddTearFlags(newTear, redflag)
            end
            for i=-15,15,30 do
                local ang = 15
                local newVel = vel*0.75
                if i ~= 0 then
                    newVel = vel*0.75/math.cos(math.rad(ang))
                end
				preventWNIC = true
                local newTear = TearFlagsLib.FireSplitTear(v, v.Velocity:Rotated(i):Resized(newVel), player, {
					RemoveFlags = disallowedFlags,
					RemoveCustomFlags = mod.PocketRockitDisallowedCustomFlags,
					
					ColorOverride = color,
					DamageOverride = dam,
					ScaleOverride = 0.7,
					TearVariant = TearVariant.BLUE,
					SplitTearType = "FF_POCKET_ROCKIT_RED",
				})
				preventWNIC = false
                newTear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
				TearFlagsLib.AddTearFlags(newTear, redflag)
            end
            for i=-30,30,60 do
                local ang = 30
                local newVel = vel+2
                newVel = (vel+2)/math.cos(math.rad(ang))
				preventWNIC = true
                local newTear = TearFlagsLib.FireSplitTear(v, v.Velocity:Rotated(-180+i):Resized(newVel), player, {
					RemoveFlags = disallowedFlags,
					RemoveCustomFlags = mod.PocketRockitDisallowedCustomFlags,
					
					ColorOverride = color,
					DamageOverride = dam,
					ScaleOverride = 0.7,
					TearVariant = TearVariant.BLUE,
					SplitTearType = "FF_POCKET_ROCKIT_RED",
				})
				preventWNIC = false
                newTear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
				TearFlagsLib.AddTearFlags(newTear, redflag)
            end
            for i=0,1 do
				preventWNIC = true
                local newTear = TearFlagsLib.FireSplitTear(v, v.Velocity:Rotated(i):Resized(vel+3+5*i), player, {
					RemoveFlags = disallowedFlags,
					RemoveCustomFlags = mod.PocketRockitDisallowedCustomFlags,
					
					ColorOverride = color,
					DamageOverride = dam,
					ScaleOverride = 0.7,
					TearVariant = TearVariant.BLUE,
					SplitTearType = "FF_POCKET_ROCKIT_RED",
				})
				preventWNIC = false
                newTear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
				TearFlagsLib.AddTearFlags(newTear, redflag)
            end
        elseif params.pattern == 2 then
            for i=1,9 do
				preventWNIC = true
                local newTear = TearFlagsLib.FireSplitTear(v, Vector(0,1+rng:RandomInt(15)/3):Rotated(rng:RandomInt(360)), player, {
					RemoveFlags = disallowedFlags,
					RemoveCustomFlags = mod.PocketRockitDisallowedCustomFlags,
					
					ColorOverride = color,
					DamageOverride = dam,
					ScaleOverride = 0.3+rng:RandomInt(40)/100,
					TearVariant = TearVariant.BLUE,
					SplitTearType = "FF_POCKET_ROCKIT_YELLOW",
				})
				preventWNIC = false
                newTear.FallingSpeed = -8 - rng:RandomInt(20)
				newTear.FallingAcceleration = 1.1
				newTear.Height = -10
                newTear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
            end
        elseif params.pattern == 3 then
            local rand = 5+rng:RandomInt(4)
            local rangle = rng:RandomInt(360)
            local orient = 1-rng:RandomInt(2)*2
            for i=1,rand do
                local rangle2 = 360/rand
				preventWNIC = true
                local newTear = TearFlagsLib.FireSplitTear(v, Vector(0,7):Rotated(i*rangle2+rangle), player, {
					RemoveFlags = disallowedFlags,
					RemoveCustomFlags = mod.PocketRockitDisallowedCustomFlags,
					
					ColorOverride = color,
					DamageOverride = dam,
					ScaleOverride = 0.75,
					TearVariant = TearVariant.BLUE,
					SplitTearType = "FF_POCKET_ROCKIT_GREEN",
				})
				preventWNIC = false
                newTear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
				TearFlagsLib.AddTearFlags(newTear, greenflag)
				TearFlagsLib.SetTearFlagParams(newTear, greenflag, {
					orient = orient,
				})
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_TEAR_DEATH, mod.pocketRocketTearRemove)

mod:AddCallback(ModCallbacks.MC_POST_FIRE_SPLIT_TEAR, function(_, new, old, splitType)
	if not mod.PocketRockitSplitWhitelist[splitType] then
		if old.Variant == mod.FF.PocketRockitTear.Var then
			if new.Variant ~= TearVariant.BLUE then 
				new:ChangeVariant(TearVariant.BLUE)
			end
			local params = TearFlagsLib.GetTearFlagParams(old, rocketflag)
			if splitType ~= "FF_ZERO_POINT" then
				new.Color = (params and params.originalColor) or new.Color
			end
		end
		TearFlagsLib.ClearTearFlags(new, rocketflag, true)
	elseif new.Variant == mod.FF.PocketRockitTear.Var then
		local params = TearFlagsLib.GetTearFlagParams(old, rocketflag)
		if params and params.pattern ~= nil then
			local sprite = new:GetSprite()
			sprite:ReplaceSpritesheet(0, "gfx/projectiles/projectile_rockit" .. params.pattern .. ".png")
			sprite:LoadGraphics()
		end
	end
end)

mod:AddCallback(TearFlagsLib.Callback.PRE_ADD_TEARFLAG, function(_, entity)
	if preventWNIC then
		preventWNIC = false
		return true
	end
end, TearFlagsLib.Flag.WNIC)

function mod.handlePocketRockitBlackD3(entity)
	TearFlagsLib.SetTearFlagParams(entity, rocketflag, {pattern = 0})
end

function mod.handlePocketRockitRedD3(entity)
	TearFlagsLib.SetTearFlagParams(entity, rocketflag, {pattern = 1})
end

function mod.handlePocketRockitYellowD3(entity)
	TearFlagsLib.SetTearFlagParams(entity, rocketflag, {pattern = 2})
end

function mod.handlePocketRockitGreenD3(entity)
	TearFlagsLib.SetTearFlagParams(entity, rocketflag, {pattern = 3})
end