local mod = FiendFolio

local flag = TearFlagsLib.RegisterTearFlag("BRAIN_FOSSIL")

function mod:brainFossilFlagGeneric(entity, player, weaponFlag)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.BRAIN_FOSSIL) then
		local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.BRAIN_FOSSIL)
		if weaponFlag == TearFlagsLib.WeaponFlag.TEAR or weaponFlag == TearFlagsLib.WeaponFlag.DR_FETUS then
			if not entity:HasTearFlags(TearFlags.TEAR_HOMING) then
				TearFlagsLib.AddTearFlags(entity, flag)
				TearFlagsLib.SetTearFlagParams(entity, flag, {timeout = player.TearRange/20*mult + (weaponFlag == TearFlagsLib.WeaponFlag.DR_FETUS and 10 or 0), color = entity.Color})
				entity:AddTearFlags(TearFlags.TEAR_HOMING)
				entity.Color = entity.Color * Color.TearHoming
			end
		elseif weaponFlag == TearFlagsLib.WeaponFlag.BOBS_ROTTEN_HEAD or weaponFlag == TearFlagsLib.WeaponFlag.SHARP_KEY then
			mod.scheduleForUpdate(function()
				if not entity:HasTearFlags(TearFlags.TEAR_HOMING) then
					TearFlagsLib.AddTearFlags(entity, flag)
					TearFlagsLib.SetTearFlagParams(entity, flag, {timeout = player.TearRange/20*mult})
					entity:AddTearFlags(TearFlags.TEAR_HOMING)
				end
			end, 1)
		elseif weaponFlag == TearFlagsLib.WeaponFlag.FF_PLANET_X then
			if (mod:GetEntityData(entity).BrainFossilCooldown or 0) <= 0 and
			   TearFlagsLib.GetCustomVanillaTearFlags(entity) & (TearFlags.TEAR_HOMING | TearFlags.TEAR_TURN_HORIZONTAL) == TearFlags.TEAR_NORMAL and
			   not TearFlagsLib.HasTearFlags(entity, TearFlagsLib.Flag.YIN_YANG) and
			   not TearFlagsLib.HasTearFlags(entity, TearFlagsLib.Flag.BULLET_ETERNAL)
			then
				TearFlagsLib.AddTearFlags(entity, flag)
				TearFlagsLib.SetTearFlagParams(entity, flag, {timeout = player.TearRange/20*mult, cooldown = player.MaxFireDelay * 5, color = entity.Color})
				TearFlagsLib.AddCustomVanillaTearFlags(entity, TearFlags.TEAR_HOMING)
				entity.Color = entity.Color * Color.TearHoming
			end
		end
	end
end
mod:AddPriorityTrinketCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, 999999, FiendFolio.ITEM.ROCK.BRAIN_FOSSIL, mod.brainFossilFlagGeneric)

function mod.handleBrainFossilD3(entity)
	local player = TearFlagsLib.GetTearPlayer(entity)
	local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.BRAIN_FOSSIL)
	TearFlagsLib.SetTearFlagParams(entity, flag, {timeout = (player and player.TearRange or 260)/20*mult, color = entity.Color})
	entity.Color = Color(0.4, 0.15, 0.38, 1, 0.27843, 0, 0.4549)
end

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tear)
	if TearFlagsLib.HasTearFlags(tear, flag) then
		local params = TearFlagsLib.GetTearFlagParams(tear, flag)
		if params.timeout > 0 then
			params.timeout = params.timeout - 1
			TearFlagsLib.SetTearFlagParams(tear, flag, {timeout = params.timeout - 1})
		else
			tear:ClearTearFlags(TearFlags.TEAR_HOMING)
			local color = params.color
			if color then
				mod.scheduleForUpdate(function()
					tear.Color = Color.Lerp(tear.Color, color, 0.33)
				end, 1)
				mod.scheduleForUpdate(function()
					tear.Color = Color.Lerp(tear.Color, color, 0.66)
				end, 2)
				mod.scheduleForUpdate(function()
					tear.Color = color
				end, 3)
			end
			TearFlagsLib.ClearTearFlags(tear, flag)
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, function(_, bomb)
	if TearFlagsLib.HasTearFlags(bomb, flag) then
		local params = TearFlagsLib.GetTearFlagParams(bomb, flag)
		if params.timeout > 0 then
			params.timeout = params.timeout - 1
			TearFlagsLib.SetTearFlagParams(bomb, flag, {timeout = params.timeout - 1})
		else
			bomb:ClearTearFlags(TearFlags.TEAR_HOMING)
			local color = params.color
			if color then
				mod.scheduleForUpdate(function()
					bomb.Color = Color.Lerp(bomb.Color, color, 0.33)
				end, 1)
				mod.scheduleForUpdate(function()
					bomb.Color = Color.Lerp(bomb.Color, color, 0.66)
				end, 2)
				mod.scheduleForUpdate(function()
					bomb.Color = color
				end, 3)
			end
			TearFlagsLib.ClearTearFlags(bomb, flag)
		end
	end
end)