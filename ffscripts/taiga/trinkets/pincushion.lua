-- Pincushion --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local baseDuration = 180

local tearcolor = Color(0.5, 0.25, 0.10, 1.0, 30/255, 15/255, 0/255)
local lasercolor = Color(1.0, 1.0, 1.0, 1.0, 0/255, 0/255, 0/255, 3.1, 1.6, 0.7, 1)

local function isPincushionUseSuccessful(player)
	local chance = math.max(5, 5 + (player:GetTrinketMultiplier(mod.ITEM.TRINKET.PINCUSHION) * 5) + (player.Luck * 30/6))
	if math.random() * 40 <= chance then
		return true
	end
end

local function getStackedPincushionDuration(player, secondHandMultiplier)
	local base = baseDuration 
	local result = math.ceil(base * (math.log(math.max(1, player:GetTrinketMultiplier(FiendFolio.ITEM.TRINKET.PINCUSHION)), 5) + 1))
	return result * secondHandMultiplier
end

function mod:pincushionFlagGeneric(entity, player, weaponFlag)
	if player:HasTrinket(FiendFolio.ITEM.TRINKET.PINCUSHION) then
		if isPincushionUseSuccessful(player) then
			local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
			FiendFolio.FlagSew(entity, getStackedPincushionDuration(player, secondHandMultiplier), 0.5)
			
			if weaponFlag == TearFlagsLib.WeaponFlag.TEAR or weaponFlag == TearFlagsLib.WeaponFlag.LUDOVICO_TEAR then
				entity.TearFlags = entity.TearFlags | TearFlags.TEAR_PIERCING
				if FiendFolio.HasCetusFlag(entity) then
					entity.Color = tearcolor
				else
					mod:changeTearVariant(entity, mod.TEAR.PIN, mod.TEAR.PIN_BLOOD)
					if FiendFolio.HasBeansFlag(entity) then
						entity.Color = tearcolor
					end
				end
			elseif weaponFlag == TearFlagsLib.WeaponFlag.BOBS_ROTTEN_HEAD or weaponFlag == TearFlagsLib.WeaponFlag.SHARP_KEY then
				-- have to schedule this cause otherwise it gets overwritten
				mod.scheduleForUpdate(function()
					entity.TearFlags = entity.TearFlags | TearFlags.TEAR_PIERCING
				end, 0)
			elseif weaponFlag == TearFlagsLib.WeaponFlag.AQUARIUS then
				mod:GetEntityData(entity).FFAquariusTearColor = tearcolor
			elseif weaponFlag == TearFlagsLib.WeaponFlag.EPIC_FETUS or weaponFlag == TearFlagsLib.WeaponFlag.CLUB_EPIC_FETUS then
				mod:GetEntityData(entity).FFExplosionColor = tearcolor
			elseif weaponFlag == TearFlagsLib.WeaponFlag.DR_FETUS then
				entity.Flags = entity.Flags | TearFlags.TEAR_PIERCING
				entity.Color = tearcolor
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
mod:AddTrinketCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, FiendFolio.ITEM.TRINKET.PINCUSHION, mod.pincushionFlagGeneric)