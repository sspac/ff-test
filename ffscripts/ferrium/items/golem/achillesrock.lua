local mod = FiendFolio

--The name Achilles' Steel was thought of after it was sprited.
function mod:achillesRockUpdate(player)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.ACHILLES_ROCK) then
		local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.ACHILLES_ROCK)
		local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.ACHILLES_ROCK)
		for _, enemy in ipairs(Isaac.FindInRadius(player.Position, 1000, EntityPartition.ENEMY)) do
			if enemy:IsActiveEnemy() and (not mod:isFriend(enemy)) and enemy:IsVulnerableEnemy() then
				local data = mod:GetEntityData(enemy)
				if not data.achillesRockDir then
					data.achillesRockDir = rng:RandomInt(360)
				end
				data.achillesRock = mult
			end
		end
	end
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.ROCK.ACHILLES_ROCK, mod.achillesRockUpdate)

function mod:AchillesRockOnRemove(player)
	for _, enemy in ipairs(Isaac.FindInRadius(player.Position, 1000, EntityPartition.ENEMY)) do
		if mod:GetEntityData(enemy) then
			mod:GetEntityData(enemy).achillesRock = nil
		end
	end
end

--[[mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, ent, damage, flag, source)
	if source and flag ~= flag | DamageFlag.DAMAGE_CLONES then
		local data = mod:GetEntityData(ent)
		if data.achillesRock then
			if ent.Position:Distance(source.Position) > 1 then
				local angle = (source.Position-ent.Position):GetAngleDegrees()
				if angle < 0 then
					angle = angle+360
				end
				local difference = math.abs(data.achillesRockDir - angle)
				if difference < 60 or difference > 300 then
					ent:TakeDamage(damage * (1+data.achillesRock/2), flag | DamageFlag.DAMAGE_CLONES, EntityRef(ent), 0)
					if ent.Type ~= 951 then
						mod:makeEnemyGib(ent)
					end
					return false
				end
			end
		end
	end	
end)]]

function mod:achillesRockEntDamage(ent, amount, flags, source, cooldown)
	if flags & DamageFlag.DAMAGE_CLONES ~= 0 or not ent:ToNPC() then return end
	
	local data = mod:GetEntityData(ent)
	if data.achillesRock and source then
		if ent.Position:Distance(source.Position) > 1 then
			local angle = (source.Position-ent.Position):GetAngleDegrees()
			if angle < 0 then
				angle = angle+360
			end
			local difference = math.abs(data.achillesRockDir - angle)
			if difference < 60 or difference > 300 then
				if ent.Type ~= 951 then
					mod:makeEnemyGib(ent)
				end
				return {Damage = amount * (1+data.achillesRock/2)}
			end
		end
	end
end
mod:AddPriorityTrinketCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, -100, mod.ITEM.ROCK.ACHILLES_ROCK, mod.achillesRockEntDamage)