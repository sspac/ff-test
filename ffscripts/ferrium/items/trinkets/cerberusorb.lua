local mod = FiendFolio
local sfx = SFXManager()
local color = Color(1, 1, 1, 1, 0.18, 0.1, 0.05)
color:SetColorize(1, 0.9, 0.3, 1)

local tearflag = TearFlagsLib.RegisterTearFlag("CERBERUS")

function mod:cerberusOrbUpdate(player)
    if player:HasTrinket(mod.ITEM.TRINKET.CERBERUS_ORB) then
        local d = mod:GetEntityData(player)
        local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.CERBERUS_ORB)
        if not d.cerberusOrbCount then
            d.cerberusOrbCount = 0
        end

        if not d.cerberusOrbReady and not d.cerberusOrbFlash then
            d.cerberusOrbCount = d.cerberusOrbCount+1
            local count = math.max(0, (4-mult))
            if d.cerberusOrbCount > 25+15*count then
                d.cerberusOrbFlash = 5
                sfx:Play(SoundEffect.SOUND_BEEP, 0.4, 0, false, 2)
            end
        elseif d.cerberusOrbFlash then
            if d.cerberusOrbFlash > 0 then
                d.cerberusOrbFlash = d.cerberusOrbFlash-1
                player.Color = Color.Lerp(player.Color, Color(1,1,1,1,0.6,0.6,0.2), 0.2)
            else
                player.Color = Color(1,1,1,1,0,0,0)
                d.cerberusOrbFlash = nil
                d.cerberusOrbReady = true
            end
        end
    end
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.TRINKET.CERBERUS_ORB, mod.cerberusOrbUpdate)

local makeCerbExplode = function(pl, ent, pos, mult)
    local explosion = Isaac.Spawn(1000, mod.FF.CerberusOrbExplosion.Var, mod.FF.CerberusOrbExplosion.Sub, pos, Vector.Zero, ent):ToEffect()
    local damage = 5
    if pl and pl:Exists() and pl:ToPlayer() then
        explosion.Parent = pl
        damage = pl.Damage
    else
        explosion.Parent = ent
    end
    sfx:Play(SoundEffect.SOUND_EXPLOSION_WEAK, 0.5, 0, false, 1.3)
    mod.scheduleForUpdate(function()
        for _,enemy in ipairs(Isaac.FindInRadius(pos, 40, EntityPartition.ENEMY)) do
            if enemy:IsActiveEnemy() and (not mod:isFriend(enemy)) and (enemy:IsVulnerableEnemy() or mod:GetEntityData(enemy).FFCopperBombHitbox) then
                enemy:TakeDamage(damage*mult, DamageFlag.DAMAGE_EXPLOSION, EntityRef(explosion.Parent), 0)
            end
        end
    end, 4)
    return explosion
end

local secondaryFlag = mod:AddSecondaryFireTearFlag("CERBERUS")
mod:AddPriorityTrinketCallback(FiendFolio.CALLBACK.FF_SECONDARY_FIRE_TEAR_EFFECTS, CallbackPriority.EARLY, FiendFolio.ITEM.TRINKET.CERBERUS_ORB, function(_, tear, player, dir, source, flags)
	if flags & secondaryFlag == 0 and player:HasTrinket(FiendFolio.ITEM.TRINKET.CERBERUS_ORB) then
		local d = mod:GetEntityData(player)
		local returnVal = flags
        if d.cerberusOrbReady or d.justFiredCerberusOrb == player.FrameCount then
			mod:fireCerberusOrb(tear, player, d, dir, source, mod:HasUnstackableSecondaryFlag(flags), flags)
			returnVal = flags | secondaryFlag
        end
        d.cerberusOrbCount = 0
		return returnVal
	end
end)

mod:AddPriorityTrinketCallback(FiendFolio.CALLBACK.FF_SECONDARY_FIRE, CallbackPriority.EARLY, FiendFolio.ITEM.TRINKET.CERBERUS_ORB, function(_, player, dir, amount, owner, params)
	if player:HasTrinket(mod.ITEM.TRINKET.CERBERUS_ORB) then
		local weaponType = params.WeaponType
		local modifiers = params.WeaponModifiers
		local charge = params.WeaponCharge
		local maxFireDelay = params.WeaponMaxFireDelay
		local numTears = params.NumTears
		if not params.ForceTearEffects and
		   ((weaponType == WeaponType.WEAPON_TEARS and not (params.GatlingGun or params.SwallowedM90 or params.RapidFireOpal)) or 
		    weaponType == WeaponType.WEAPON_BOMBS or
		    weaponType == WeaponType.WEAPON_MONSTROS_LUNGS or
		    (weaponType == WeaponType.WEAPON_BONE and modifiers & WeaponModifier.MONSTROS_LUNG == WeaponModifier.MONSTROS_LUNG and charge >= maxFireDelay * 2) or
		    (weaponType == WeaponType.WEAPON_SPIRIT_SWORD and params.FriendGun and params.IsFriendChargedSlash) or
		    weaponType == WeaponType.WEAPON_LUDOVICO_TECHNIQUE)
		then 
			return 
		end
		
		local d = mod:GetEntityData(player)
        if d.cerberusOrbReady or d.justFiredCerberusOrb == player.FrameCount then
			local isMonstrosLung = (weaponType == WeaponType.WEAPON_MONSTROS_LUNGS or modifiers & WeaponModifier.MONSTROS_LUNG == WeaponModifier.MONSTROS_LUNG) and 
			                       weaponType ~= WeaponType.WEAPON_URN_OF_SOULS and weaponType ~= WeaponType.WEAPON_SPIRIT_SWORD and weaponType ~= WeaponType.WEAPON_FETUS
		
			for i = 1, numTears do
				local pos = Vector(0,0)
				local vel = nil
				if isMonstrosLung then
					local a = mod:getSign(rng) * rng:RandomFloat()
					local b = (mod:getSign(rng) * rng:RandomFloat() * math.pi) * 2
					
					local x = math.cos(b) * a * 3.5 + player.ShotSpeed * dir:Resized(player.TearRange / 20).X;
					local y = math.sin(b) * a * 3.5 + player.ShotSpeed * dir:Resized(player.TearRange / 20).Y;
					
					vel = Vector(x,y)
				else
					pos, vel = mod:GetMultiShotPositionVelocityBasic(dir * 10 + player:GetTearMovementInheritance(dir), player.ShotSpeed, numTears, i - 1)
				end
				mod:fireCerberusOrb(nil, player, d, vel, owner, nil, nil, pos)
			end
			d.preventFushigiFire = true
        end
        d.cerberusOrbCount = 0
	end
end)

function mod:fireCerberusOrb(tear, player, d, dir, source, spawnNew, flags, posOffset)
	local flags = flags or 0
	local isNewTear = tear == nil or spawnNew
	if isNewTear then
		if flags & mod.SecondaryFireTearFlags.RECURSIVE ~= 0 then return end
		tear = mod:SpawnPlayerTear(player, ((source and source.Position) or player.Position) + (posOffset or Vector(0,0)), dir:Resized(player.ShotSpeed * 10))
	end
	
    local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.CERBERUS_ORB)
    tear.Color = color
    tear.Velocity = tear.Velocity*2
    tear.CollisionDamage = tear.CollisionDamage*(1+mult)
    tear.Scale = tear.Scale*1.3
    d.cerberusOrbReady = nil
    d.justFiredCerberusOrb = player.FrameCount
	TearFlagsLib.AddTearFlags(tear, tearflag)
	TearFlagsLib.SetTearFlagParams(tear, tearflag, {
		mult = mult,
		player = player,
	})
	
	if isNewTear then
		mod:checkReplaceableSecondaryFiredTears(tear, player, source, mod.SecondaryFireTearFlags.RECURSIVE | secondaryFlag)
		Isaac.RunCallback(FiendFolio.CALLBACK.FF_POST_FIRE_SECONDARY_TEAR, tear, player)
		tear:Update()
	end
end

mod:AddCallback(ModCallbacks.MC_POST_TEAR_DEATH, function(_, tear)
	if TearFlagsLib.HasTearFlags(tear, tearflag) then
		local params = TearFlagsLib.GetTearFlagParams(tear, tearflag)
		local pl
		if params.player and params.player:Exists() then
			pl = params.player
		end
		local boom = makeCerbExplode(pl, tear, tear.Position, params.mult or 1)
		boom.SpriteOffset = Vector(0, tear.Height)
	end
end)

function mod.handleCerberusD3(entity)
	local player = TearFlagsLib.GetTearPlayer(entity)
	local params = TearFlagsLib.GetTearFlagParams(entity, tearflag)
	TearFlagsLib.SetTearFlagParams(entity, tearflag, {mult = 1,
	                                                  player = player})
end