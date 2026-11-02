local mod = FiendFolio
local game = Game()

local flag = TearFlagsLib.RegisterTearFlag("TRINITY")

function mod:trinityFlagGeneric(entity, player, weaponFlag)
	if mod.HasTrinityWorm(player) then
		TearFlagsLib.AddTearFlags(entity, flag)
		
		if weaponFlag == TearFlagsLib.WeaponFlag.TEAR then
			local color = entity.Color
			entity:ToTear():AddTearFlags(TearFlags.TEAR_SPECTRAL)
			entity.Color = color
			entity.Velocity = entity.Velocity:Rotated(-25) * 1.5
		end
	end
end
mod:AddCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, mod.trinityFlagGeneric)
mod:AddCallback(TearFlagsLib.Callback.POLL_CHANCELESS_TEARFLAGS, mod.trinityFlagGeneric)

function mod:updateTrinityTear(tear, td)
	if not tear:HasTearFlags(TearFlags.TEAR_LUDOVICO) and TearFlagsLib.HasTearFlags(tear, flag) then
		td.HolyWormPos = td.HolyWormPos or 1
		td.HolyWormValue = td.HolyWormValue or 1

		local val = 1.5 * td.HolyWormPos
		if td.ModelRocketTear and (td.ModelRocketFrame or 0) < 13 then
			val = 0
		end
		td.HolyWormValue = td.HolyWormValue + val

		if td.HolyWormValue >= 19 then
			td.HolyWormPos = -1
		elseif td.HolyWormValue <= 1 then
			td.HolyWormPos = 1
		end

		tear.Velocity = tear.Velocity:Rotated(td.HolyWormValue)
	end
end