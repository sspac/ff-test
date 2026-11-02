local mod = FiendFolio
local sfx = SFXManager()

function mod:sandstoneDamage(player, damage, flag, source)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.SANDSTONE) then
		local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.SANDSTONE)

		if flag & DamageFlag.DAMAGE_EXPLOSION ~= 0 then
			sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 1, 0, false, 1)
			local t0 = player:GetTrinket(0)
			local t1 = player:GetTrinket(1)

			if t1 > 0 then
				player:TryRemoveTrinket(t1)
			end
			if t0 > 0 then
				player:TryRemoveTrinket(t0)
			end
			local held = false
			if mod:GetRealTrinketId(t0) == FiendFolio.ITEM.ROCK.SANDSTONE or mod:GetRealTrinketId(t1) == FiendFolio.ITEM.ROCK.SANDSTONE then
				held = true
			end
			

			if player:HasTrinket(FiendFolio.ITEM.ROCK.SANDSTONE) and not held then --oh, so golden trinkets are just two normal trinkets hidden as one
				local mult = player:GetTrinketMultiplier(FiendFolio.ITEM.ROCK.SANDSTONE)
				player:TryRemoveTrinket(FiendFolio.ITEM.ROCK.SANDSTONE)
				local newMult = player:GetTrinketMultiplier(FiendFolio.ITEM.ROCK.SANDSTONE)
				if mult-newMult == 1 then
					player:AddTrinket(FiendFolio.ITEM.ROCK.POCKET_SAND)
				else
					player:AddTrinket(FiendFolio.ITEM.ROCK.POCKET_SAND + TrinketType.TRINKET_GOLDEN_FLAG)
				end
				player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, false, false, true, false)
			end
			
			local removed = false
			if t0 > 0 then
				if t0 == FiendFolio.ITEM.ROCK.SANDSTONE then
					player:AddTrinket(FiendFolio.ITEM.ROCK.POCKET_SAND)
					removed = true
				elseif t0 == FiendFolio.ITEM.ROCK.SANDSTONE + TrinketType.TRINKET_GOLDEN_FLAG then
					player:AddTrinket(FiendFolio.ITEM.ROCK.POCKET_SAND + TrinketType.TRINKET_GOLDEN_FLAG)
					removed = true
				else
					player:AddTrinket(t0)
				end
			end
			if t1 > 0 then
				if removed then player:AddTrinket(t1)
				elseif t1 == FiendFolio.ITEM.ROCK.SANDSTONE then
					player:AddTrinket(FiendFolio.ITEM.ROCK.POCKET_SAND)
				elseif t1 == FiendFolio.ITEM.ROCK.SANDSTONE + TrinketType.TRINKET_GOLDEN_FLAG then
					player:AddTrinket(FiendFolio.ITEM.ROCK.POCKET_SAND + TrinketType.TRINKET_GOLDEN_FLAG)
				else
					player:AddTrinket(t1)
				end
			end
		end
	end
end

function mod:sandstoneTearHitParams(player, tearparams, weapontype, damagescale, teardisplacement, source)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.SANDSTONE) then
		local mult = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.SANDSTONE)
		local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.SANDSTONE)
		local chance = 10+10*mult+3*player.Luck

		if rng:RandomInt(100) < chance then
			tearparams.TearDamage = tearparams.TearDamage * 4
			tearparams.TearVariant = TearVariant.ROCK
			--sprite:Load("gfx/002.042_rock tear.anm2")
			--sprite:ReplaceSpritesheet(0, "gfx/projectiles/sandstone_tear.png")
			--sprite:LoadGraphics()
			tearparams.TearFlags = tearparams.TearFlags | TearFlags.TEAR_SHRINK | TearFlags.TEAR_CONFUSION
			tearparams.TearScale = tearparams.TearScale * 1.5
			tearparams.TearColor = Color(1.0, 1.0, 1.0, 1.0, 37/255, -27/255, -11/255, 1.274, 1.320, 0.915, 1)
		end
	end
end
mod:AddTrinketCallback(ModCallbacks.MC_EVALUATE_TEAR_HIT_PARAMS, mod.ITEM.ROCK.SANDSTONE, mod.sandstoneTearHitParams)