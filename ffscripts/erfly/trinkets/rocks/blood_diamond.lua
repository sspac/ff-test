local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local tearcolor = Color(1.5, 0.6, 0.6, 1, 0.3, -0.1, -0.1)
local flag = TearFlagsLib.RegisterTearFlag("FF_BLEED_OUT")

function mod:bloodDiamondFlagGeneric(entity, player, weaponFlag)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.BLOOD_DIAMOND) then
        local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.BLOOD_DIAMOND)
        local chance = math.min(5 + player.Luck * 2, 20) * trinketPower
		local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.BLOOD_DIAMOND)
        if rng:RandomInt(50) < chance then
			TearFlagsLib.AddTearFlags(entity, flag)
			
			if weaponFlag == TearFlagsLib.WeaponFlag.AQUARIUS then
				mod:GetEntityData(entity).FFAquariusTearColor = tearcolor
			elseif weaponFlag == TearFlagsLib.WeaponFlag.EPIC_FETUS or weaponFlag == TearFlagsLib.WeaponFlag.CLUB_EPIC_FETUS then
				mod:GetEntityData(entity).FFExplosionColor = tearcolor
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
				entity.Color = tearcolor
			end
		end
	end
end
mod:AddTrinketCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, FiendFolio.ITEM.ROCK.BLOOD_DIAMOND, mod.bloodDiamondFlagGeneric)

function mod:applyFFBleedOut(entity, player, source)
	if entity:IsEnemy() and 
	   not (entity:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) or 
	        entity:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) or 
	        entity:GetBossStatusEffectCooldown() > 0) 
	then
		local duration = 150 * (player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1)
		entity:AddBleeding(EntityRef(player), duration)
		entity:SetBleedingCountdown(duration)
		entity:SetColor(Color(3,0.75,0.75,1,0,0,0),1,2,false,false)
		for i = 1, 7 do
			mod.scheduleForUpdate(function()
				if entity and entity:Exists() then
					entity:SetColor(Color(3 - ((i/8)^3) * 2, 0.75 + ((i/8)^3) * 0.25, 0.75 + ((i/8)^3) * 0.25, 1, 0, 0, 0), 1, 2, false, false)
				end
			end, i+1)
		end
		mod:makeEnemyGib(entity)
	end
end
mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, mod.applyFFBleedOut, flag)

function mod:bloodDiamondPlayerHurt(player)
    if player:HasTrinket(FiendFolio.ITEM.ROCK.BLOOD_DIAMOND) then
        local creep = Isaac.Spawn(1000, 46, 0, player.Position, nilvector, player):ToEffect()
        creep.SpriteScale = creep.SpriteScale * 2
        creep:SetTimeout(120)
        creep:Update()
    end
end