local mod = FiendFolio
local sfx = SFXManager()
local game = Game()

mod:AddTrinketCallback(FiendFolio.CALLBACK.FF_SECONDARY_FIRE, FiendFolio.ITEM.ROCK.CORAL_FOSSIL, function(_, player, dir, amount, owner, params)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.CORAL_FOSSIL) then
		local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.CORAL_FOSSIL)
		local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.CORAL_FOSSIL)
		local chance = 15+10*mult+player.Luck
		if rng:RandomInt(100) < chance then
			mod:coralFossilFire(player, player.Position)
		end
	end
end)

function mod:coralFossilFire(player, position, variant, vel)
	local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.CORAL_FOSSIL)
	vel = (vel or player.Velocity)
	for i=45,315,90 do
		local tear = Isaac.Spawn(2, (variant or 0), 0, position, vel+Vector(0,8):Rotated(i), player):ToTear()
		tear.CollisionDamage = player.Damage*mult
	end
end

function mod:CoralFossilOnAdd(player, first, id)
	if first then
		local num = (mod:IsGoldTrinket(id) and 4) or 2
		player:AddHearts(num)
		sfx:Play(SoundEffect.SOUND_VAMP_GULP, 1, 0, false, 1)
		local poof = Isaac.Spawn(1000, 49, 0, player.Position, Vector.Zero, player):ToEffect()
		poof.SpriteOffset = Vector(0,-30*player.SpriteScale.Y)
		poof:FollowParent(player)
		poof.DepthOffset = 50
		poof:Update()
	end
end

function mod:coralFossilUpdate(player)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.CORAL_FOSSIL) then
		local data = mod:GetEntityData(player).ffsavedata.RunEffects
		
		if player:IsDead() and not data.coralFossilFired then
			data.coralFossilFired = true
			mod:coralFossilFire(player, player.Position, 1, Vector.Zero)
			local charger = Isaac.Spawn(23, 1, 0, player.Position, Vector.Zero, player)
			charger:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			charger:AddCharmed(EntityRef(player), -1)
		end
	end
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.ROCK.CORAL_FOSSIL, mod.coralFossilUpdate)