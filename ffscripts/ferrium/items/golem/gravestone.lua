local mod = FiendFolio
local sfx = SFXManager()

function mod:gravestoneHurt(player)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.GRAVESTONE) then
		local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.GRAVESTONE)
		local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.GRAVESTONE)
		
		if rng:RandomInt(2) == 0 then
			sfx:Play(SoundEffect.SOUND_FLOATY_BABY_ROAR, 0.6, 0, false, 2)
			local ghost = Isaac.Spawn(1000, EffectVariant.HUNGRY_SOUL, 1, player.Position, Vector.Zero, player):ToEffect()
			ghost.Parent = player
			ghost:SetTimeout(math.floor(100*mult))
		else
			for i=1,math.ceil(mult) do
				local soul = Isaac.Spawn(1000, EffectVariant.PURGATORY, 1, player.Position, Vector.Zero, player):ToEffect()
				soul.Parent = player
				for i=1,39 do
					soul:Update()
				end
			end
		end
	end
end

function mod:gravestoneUpdate(player)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.GRAVESTONE) then
		local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.GRAVESTONE)
		local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.GRAVESTONE)
		local chance = math.min(50, 10+5*mult+player.Luck)
		
		for _,grid in ipairs(mod.GetGridEntities()) do
			if mod.gravestoneRocks[grid:GetGridIndex()] ~= nil then
				if grid.CollisionClass == GridCollisionClass.COLLISION_NONE then
					mod.gravestoneRocks[grid:GetGridIndex()] = nil
					if rng:RandomInt(100) < chance then
						if rng:RandomInt(2) == 0 then
							sfx:Play(SoundEffect.SOUND_FLOATY_BABY_ROAR, 0.6, 0, false, 2)
							local ghost = Isaac.Spawn(1000, EffectVariant.HUNGRY_SOUL, 1, grid.Position, Vector.Zero, player):ToEffect()
							ghost.Parent = player
							ghost:SetTimeout(math.floor(100*mult))
						else
							for i=1,math.ceil(mult) do
								local soul = Isaac.Spawn(1000, EffectVariant.PURGATORY, 1, grid.Position, Vector.Zero, player):ToEffect()
								soul.Parent = player
								for i=1,39 do
									soul:Update()
								end
							end
						end
					end
				end
			end
		end
	end
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.ROCK.GRAVESTONE, mod.gravestoneUpdate)