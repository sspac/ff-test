local mod = FiendFolio
local game = Game()

mod.GAY_GARNET = {}
mod.GAY_GARNET.DO_APPLY_EFFECTS = TearFlagsLib.WeaponFlag.AQUARIUS |
                                  TearFlagsLib.WeaponFlag.DARK_ARTS |
                                  TearFlagsLib.WeaponFlag.OCULAR_RIFT |
                                  TearFlagsLib.WeaponFlag.HEMOPTYSIS |
                                  TearFlagsLib.WeaponFlag.BOBS_ROTTEN_HEAD |
                                  TearFlagsLib.WeaponFlag.SHARP_KEY |
                                  TearFlagsLib.WeaponFlag.FF_MALICE

--THE COMBINATION time to copy and paste weeeeeeee

mod:AddTrinketCallback(FiendFolio.CALLBACK.FF_SECONDARY_FIRE, FiendFolio.ITEM.ROCK.GAY_GARNET, function(_, player, dir, amount, owner, params)
	if player:HasTrinket(mod.ITEM.ROCK.GAY_GARNET) then
		local mult = mod.GetGolemTrinketPower(player, mod.ITEM.ROCK.GAY_GARNET)
		local rng = player:GetTrinketRNG(mod.ITEM.ROCK.GAY_GARNET)
		local chance = math.min(15+player.Luck+5*mult, 50)
		for i = 1, amount do
			if rng:RandomInt(100) < chance then
				mod:firePeppermint(player, player.Position, dir, true)
			end
		end
	end
end)

function mod:gayGarnetFlagGeneric(entity, player, weaponFlag)
	if not mod.GAY_GARNET.DO_APPLY_EFFECTS:HasAnyFlag(weaponFlag) then return end
	if player:HasTrinket(mod.ITEM.ROCK.GAY_GARNET) then
		local mult = mod.GetGolemTrinketPower(player, mod.ITEM.ROCK.GAY_GARNET)
		local rng = player:GetTrinketRNG(mod.ITEM.ROCK.GAY_GARNET)
		local chance = math.min(15+player.Luck+5*mult, 50)
        if rng:RandomInt(100) < chance then
			local typ = entity.Type
			if typ == EntityType.ENTITY_TEAR then
				entity:ToTear():AddTearFlags(TearFlags.TEAR_BURN)
				if weaponFlag == TearFlagsLib.WeaponFlag.BOBS_ROTTEN_HEAD or weaponFlag == TearFlagsLib.WeaponFlag.SHARP_KEY then
					mod.scheduleForUpdate(function()
						entity:ToTear():AddTearFlags(TearFlags.TEAR_BURN)
					end, 0)
				end
			elseif typ == EntityType.ENTITY_BOMB then
				entity:ToBomb():AddTearFlags(TearFlags.TEAR_BURN)
			elseif typ == EntityType.ENTITY_LASER then
				entity:ToLaser():AddTearFlags(TearFlags.TEAR_BURN)
			elseif typ == EntityType.ENTITY_KNIFE then
				entity:ToKnife():AddTearFlags(TearFlags.TEAR_BURN)
			elseif typ == EntityType.ENTITY_EFFECT then
				entity:ToEffect():AddTearFlags(TearFlags.TEAR_BURN)
			else
				TearFlagsLib.AddCustomVanillaTearFlags(entity, TearFlags.TEAR_BURN)
			end
			
			if weaponFlag == TearFlagsLib.WeaponFlag.AQUARIUS then
				mod:GetEntityData(entity).FFAquariusTearColor = Color(1, 1, 1, 1, 0.25, 0, 0, 1, 0.3, 0.1, 1)
			elseif weaponFlag == TearFlagsLib.WeaponFlag.EPIC_FETUS or weaponFlag == TearFlagsLib.WeaponFlag.CLUB_EPIC_FETUS then
				mod:GetEntityData(entity).FFExplosionColor = Color(1, 1, 1, 1, 0.25, 0, 0, 1, 0.3, 0.1, 1)
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
				-- do nothing
			else
				entity.Color = Color(1, 1, 1, 1, 0.25, 0, 0, 1, 0.3, 0.1, 1)
			end
		end

        chance = math.min(12 + player.Luck * 2, 30) * mult
        if rng:RandomInt(60) < chance then
			FiendFolio.FlagPeppermint(entity)
			
			if weaponFlag == TearFlagsLib.WeaponFlag.AQUARIUS then
				mod:GetEntityData(entity).FFAquariusTearColor = Color(0.7, 0.7, 1, 1, -0.1, -0.1, 0.1)
			elseif weaponFlag == TearFlagsLib.WeaponFlag.EPIC_FETUS or weaponFlag == TearFlagsLib.WeaponFlag.CLUB_EPIC_FETUS then
				mod:GetEntityData(entity).FFExplosionColor = Color(0.7, 0.7, 1, 1, -0.1, -0.1, 0.1)
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
				-- do nothing
			else
				entity.Color = Color(0.7, 0.7, 1, 1, -0.1, -0.1, 0.1)
			end
		end
	end
end
mod:AddTrinketCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, mod.ITEM.ROCK.GAY_GARNET, mod.gayGarnetFlagGeneric)