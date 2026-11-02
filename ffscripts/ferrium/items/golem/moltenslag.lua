local mod = FiendFolio
local sfx = SFXManager()

function mod:moltenSlagUpdate(player)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.MOLTEN_SLAG) then
		local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.MOLTEN_SLAG)
		local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.MOLTEN_SLAG)
		for _,entity in ipairs(Isaac.FindInRadius(player.Position, 40+math.min(60, 20*mult), EntityPartition.ENEMY)) do
			if entity:IsActiveEnemy() and (not mod:isFriend(entity)) and (not entity:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)) then
				if rng:RandomInt(60-math.floor(math.min(50, 10*mult))) == 0 then
					entity:AddBurn(EntityRef(player), math.ceil(60*mult), player.Damage*mult)
				end
			end
		end
	end
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.ROCK.MOLTEN_SLAG, mod.moltenSlagUpdate)

function mod:moltenSlagOnGrind(player, slot, data)
    if mod:GetRealTrinketId(data.GrindingTrinket) == FiendFolio.ITEM.ROCK.MOLTEN_SLAG then
		player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, false, false, true, false)
		local rng = player:GetTrinketRNG(mod.ITEM.ROCK.MOLTEN_SLAG)
		sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS, 1, 0, false, 1.5)
		for i=1,10 do
			local ember = Isaac.Spawn(1000, 66, 0, player.Position+Vector(mod:getRoll(-5,5,rng), mod:getRoll(-5,5,rng)), Vector(0,-mod:getRoll(1,5,rng)):Rotated(mod:getRoll(-40,40,rng)), player)
			ember.DepthOffset = 20
			ember.SpriteOffset = Vector(0,-10)
			ember.SpriteScale = Vector(mod:getRoll(10,20,rng)/10, mod:getRoll(10,20,rng)/10)
			ember:Update()
		end
	end
end