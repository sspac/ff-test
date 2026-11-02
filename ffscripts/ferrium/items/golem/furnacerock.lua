local mod = FiendFolio

local function CheckFurnaceProc(player)
	local rng = player:GetTrinketRNG(mod.ITEM.ROCK.FURNACE_ROCK)
    local chance = math.min(50, 100*1/(math.max(1, 16-player.Luck)))
    if rng:RandomInt(100) < chance then
        return true
    end
end

local function FireFurnaceRock(player, dir)
    local mult = mod.GetGolemTrinketPower(player, mod.ITEM.ROCK.FURNACE_ROCK)
	local rng = player:GetTrinketRNG(mod.ITEM.ROCK.FURNACE_ROCK)
    local fire = Isaac.Spawn(1000, EffectVariant.RED_CANDLE_FLAME, 0, player.Position, (dir:Resized(10) + player:GetTearMovementInheritance(dir)) * 1.4, player):ToEffect()
    fire.CollisionDamage = player.Damage*mult
	SFXManager():Play(SoundEffect.SOUND_FLAME_BURST, 0.4, 0, false, mod:RandomInt(150,160,rng)/100)
end

mod:AddTrinketCallback(FiendFolio.CALLBACK.FF_SECONDARY_FIRE, FiendFolio.ITEM.ROCK.FURNACE_ROCK, function(_, player, dir, amount, owner, params)
	if player:HasTrinket(mod.ITEM.ROCK.FURNACE_ROCK) then
		for i = 1, amount do
			if CheckFurnaceProc(player) then
				FireFurnaceRock(player, dir)
			end
		end
	end
end)