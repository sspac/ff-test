local mod = FiendFolio
local game = Game()

function mod:trippyFossilOnFireTear(player, tear, secondHandMultiplier)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.TRIPPY_FOSSIL) then
		local mult = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.TRIPPY_FOSSIL)
		local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.TRIPPY_FOSSIL)
		local chance = 7+5*mult+(2*player.Luck)

		if rng:RandomInt(100) < chance then
			tear.TearFlags = tear.TearFlags | TearFlags.TEAR_GODS_FLESH
			
			tear.Color = Color(rng:RandomInt(255)/255,rng:RandomInt(255)/255,rng:RandomInt(255)/255,1,0,0,0)
		end
	end
end

function mod:trippyFossilOnKnifeDamage(player, entity, secondHandMultiplier)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.TRIPPY_FOSSIL) then
		local mult = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.TRIPPY_FOSSIL)
		local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.TRIPPY_FOSSIL)
		local chance = 7+5*mult+(2*player.Luck)
		
		if rng:RandomInt(100) < chance then
			entity:AddShrink(EntityRef(player), 200 * secondHandMultiplier, false)
		end
	end
end

function mod:trippyFossilOnFireBomb(player, bomb, secondHandMultiplier)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.TRIPPY_FOSSIL) then
		local mult = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.TRIPPY_FOSSIL)
		local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.TRIPPY_FOSSIL)
		local chance = 7+5*mult+(2*player.Luck)
		
		if rng:RandomInt(100) < chance then
			bomb.Flags = bomb.Flags | TearFlags.TEAR_GODS_FLESH
		end
	end
end

function mod:trippyFossilOnLaserDamage(player, entity, secondHandMultiplier)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.TRIPPY_FOSSIL) then
		local mult = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.TRIPPY_FOSSIL)
		local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.TRIPPY_FOSSIL)
		local chance = 7+5*mult+(2*player.Luck)
		
		if rng:RandomInt(100) < chance then
			entity:AddShrink(EntityRef(player), 200 * secondHandMultiplier, false)
		end
	end
end

function mod:trippyFossilOnFireAquarius(player, creep, secondHandMultiplier)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.TRIPPY_FOSSIL) then
		local mult = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.TRIPPY_FOSSIL)
		local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.TRIPPY_FOSSIL)
		local chance = 7+5*mult+(2*player.Luck)
		
		if rng:RandomInt(100) < chance then
			local data = mod:GetEntityData(creep)
			data.AddShrink = true
			data.ApplyShrinkDuration = 200 * secondHandMultiplier
		end
	end
end

function mod:trippyFossilOnFireRocket(player, target, secondHandMultiplier)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.TRIPPY_FOSSIL) then
		local mult = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.TRIPPY_FOSSIL)
		local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.TRIPPY_FOSSIL)
		local chance = 7+5*mult+(2*player.Luck)
		
		if rng:RandomInt(100) < chance then
			local data = mod:GetEntityData(target)
			data.AddShrink = true
			data.ApplyShrinkDuration = 200 * secondHandMultiplier
		end
	end
end

function mod:trippyFossilOnDarkArtsDamage(player, entity, secondHandMultiplier)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.TRIPPY_FOSSIL) then
		local mult = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.TRIPPY_FOSSIL)
		local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.TRIPPY_FOSSIL)
		local chance = 7+5*mult+(2*player.Luck)
		
		if rng:RandomInt(100) < chance then
			entity:AddShrink(EntityRef(player), 200 * secondHandMultiplier, false)
		end
	end
end

function mod:shrinkOnApply(entity, source, data)
	if data.ApplyShrink then
		entity:AddShrink(EntityRef(source.Entity.SpawnerEntity), data.ApplyShrinkDuration)
	end
end

TearFlagsLib.RegisterTearFlag("FF_SHRINK")
mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, function(_, entity, player, source)
    local npc = entity:ToNPC()
    if npc and not npc:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) then
		local dur = mod:GetEntityData(source).ApplyShrinkDuration or 1
        entity:AddShrink(EntityRef(player), dur, false)
    end
end, TearFlagsLib.Flag.FF_SHRINK)

mod:AddCallback(TearFlagsLib.Callback.PRE_SWING_CLUB, function(_, entity, player)
	if player:HasTrinket(mod.ITEM.ROCK.TRIPPY_FOSSIL) then
		local rng = player:GetTrinketRNG(mod.ITEM.ROCK.TRIPPY_FOSSIL)
		local mult = mod.GetGolemTrinketPower(player, mod.ITEM.ROCK.TRIPPY_FOSSIL)
		local chance = 7+5*mult+(2*player.Luck)

		if rng:RandomInt(100) < chance then
			TearFlagsLib.AddTearFlags(entity, TearFlagsLib.Flag.FF_SHRINK)
			mod:GetEntityData(entity).ApplyShrinkDuration = 200*(player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND)+1)

			entity.Color = Color(rng:RandomInt(255)/255,rng:RandomInt(255)/255,rng:RandomInt(255)/255,1,0,0,0)
		end
	end
end)