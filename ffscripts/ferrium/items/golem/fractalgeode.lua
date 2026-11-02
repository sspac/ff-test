local mod = FiendFolio
local tearflag = TearFlagsLib.RegisterTearFlag("FRACTAL")

function mod:fractalGeodeFlagGeneric(entity, player, weaponFlag)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.FRACTAL_GEODE) then
        local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.FRACTAL_GEODE)
		local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.FRACTAL_GEODE)
        local chance = 15*mult+mod.XalumLuckBonus(player.Luck, 20, 0.3)*100
        local drowsyDuration = 40
		local tearcolor = Color(0.3, 0.3, 0.5, 1, 0.2, 0.3, 0.6, 1, 1, 1, 1)
		local lasercolor = Color(1, 1, 1, 1, 0, 0, 0, 2.6, 3.1, 4.6, 1)

        if mod.HasTwoGeodes(player) then
            chance = chance+20
            if rng:RandomInt(2) == 0 then
                drowsyDuration = 5
				tearcolor = Color(0.5, 0.5, 0.7, 1, 0.35, 0.4, 0.75, 1, 1, 1, 1)
				lasercolor = Color(1, 1, 1, 1, 0, 0, 0, 4.2, 4.4, 6.2, 1)
            end
        end

        if rng:RandomInt(100) < chance then
			local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
			FiendFolio.FlagDrowsy(entity, drowsyDuration, 120 * secondHandMultiplier)
			TearFlagsLib.AddTearFlags(entity, tearflag)
		
			if weaponFlag == TearFlagsLib.WeaponFlag.TEAR then
				entity.Color = tearcolor
				entity.TearFlags = entity.TearFlags | TearFlags.TEAR_SPECTRAL
				
				local data = mod:GetEntityData(entity)
                data.fractalInitialVel = entity.Velocity
                data.fractalRotatingVel = entity.Velocity
                data.fractalDir = 1-rng:RandomInt(2)*2
			elseif weaponFlag == TearFlagsLib.WeaponFlag.BOBS_ROTTEN_HEAD then
				entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS -- spectral tearflag acts funny
				
				local data = mod:GetEntityData(entity)
                data.fractalInitialVel = entity.Velocity
                data.fractalRotatingVel = entity.Velocity
                data.fractalDir = 1-rng:RandomInt(2)*2
			elseif weaponFlag == TearFlagsLib.WeaponFlag.SHARP_KEY then
				mod.scheduleForUpdate(function()
					entity.TearFlags = entity.TearFlags | TearFlags.TEAR_SPECTRAL
				end, 0)
				
				local data = mod:GetEntityData(entity)
                data.fractalInitialVel = entity.Velocity
                data.fractalRotatingVel = entity.Velocity
                data.fractalDir = 1-rng:RandomInt(2)*2
			elseif weaponFlag == TearFlagsLib.WeaponFlag.AQUARIUS then
				mod:GetEntityData(entity).FFAquariusTearColor = tearcolor
			elseif weaponFlag == TearFlagsLib.WeaponFlag.EPIC_FETUS or weaponFlag == TearFlagsLib.WeaponFlag.CLUB_EPIC_FETUS then
				mod:GetEntityData(entity).FFExplosionColor = tearcolor
			elseif weaponFlag == TearFlagsLib.WeaponFlag.KNIFE or
				   weaponFlag == TearFlagsLib.WeaponFlag.LASER or
				   weaponFlag == TearFlagsLib.WeaponFlag.ANTI_GRAV_LASER or
				   weaponFlag == TearFlagsLib.WeaponFlag.DARK_ARTS or
				   weaponFlag == TearFlagsLib.WeaponFlag.LOCUST or
				   weaponFlag == TearFlagsLib.WeaponFlag.UMBILICAL_WHIP or
				   weaponFlag == TearFlagsLib.WeaponFlag.BRIMSTONE_BALL or
			       weaponFlag == TearFlagsLib.WeaponFlag.OCULAR_RIFT or
			       weaponFlag == TearFlagsLib.WeaponFlag.HEMOPTYSIS
			then
				return
			else
				entity.Color = tearcolor
			end
		end
	end
end
mod:AddTrinketCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, FiendFolio.ITEM.ROCK.FRACTAL_GEODE, mod.fractalGeodeFlagGeneric)

function mod.fractalTear(v, d)
    if TearFlagsLib.HasTearFlags(v, tearflag) then
        d.fractalInitialVel = d.fractalInitialVel or v.Velocity
        d.fractalRotatingVel = d.fractalRotatingVel or v.Velocity
        d.fractalDir = d.fractalDir or (1-math.random(0,1)*2)
		
        v.Velocity = d.fractalInitialVel*0.3+d.fractalRotatingVel:Rotated(-15)*0.8
        d.fractalRotatingVel = d.fractalRotatingVel:Rotated(15*d.fractalDir)
        v.FallingSpeed = 0
    end
end

function mod:fractalGeodeTrinketUpdate(trinket)
	if mod:GetRealTrinketId(trinket.SubType) == FiendFolio.ITEM.ROCK.FRACTAL_GEODE then
		local sprite = trinket:GetSprite()
		if sprite:GetFilename() == "gfx/005.350_Trinket.anm2" then
			local appear = false
			if sprite:IsPlaying("Appear") then
				appear = true
			end
			sprite:Load("gfx/items/trinkets/golem/fractal_geode.anm2", true)
			if appear == true then
				sprite:Play("Appear", true)
			else
				sprite:Play("Idle", true)
			end
			sprite:LoadGraphics()
			sprite:Update()
		end
	end
end