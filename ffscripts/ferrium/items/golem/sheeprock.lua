local mod = FiendFolio

local tearcolor = Color(0.5, 0.5, 0.5, 1.0, 0, 0, 0, 2.5, 2.5, 2.5, 1)
local lasercolor = Color(1, 1, 1, 1.0, 0, 0, 0, 6.25, 6.25, 6.25, 1)

function mod:sheepRockFlagGeneric(entity, player, weaponFlag)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.SHEEP_ROCK) then
		local mult = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.SHEEP_ROCK)
		local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.SHEEP_ROCK)
		local chance = 7*mult+(2*player.Luck)

		if rng:RandomInt(100) < chance then
			local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
			FiendFolio.FlagDrowsy(entity, 40, 120 * secondHandMultiplier)
		
			if weaponFlag == TearFlagsLib.WeaponFlag.TEAR then
				entity.Color = tearcolor
				entity.TearFlags = entity.TearFlags | TearFlags.TEAR_POP
			elseif weaponFlag == TearFlagsLib.WeaponFlag.BOBS_ROTTEN_HEAD or weaponFlag == TearFlagsLib.WeaponFlag.SHARP_KEY then
				-- have to schedule this cause otherwise it gets overwritten
				mod.scheduleForUpdate(function()
					entity.TearFlags = entity.TearFlags | TearFlags.TEAR_POP
				end, 0)
			elseif weaponFlag == TearFlagsLib.WeaponFlag.AQUARIUS then
				mod:GetEntityData(entity).FFAquariusColor = lasercolor
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
mod:AddTrinketCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, FiendFolio.ITEM.ROCK.SHEEP_ROCK, mod.sheepRockFlagGeneric)