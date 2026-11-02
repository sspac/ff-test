local mod = FiendFolio

-- Pre-damage checks that run for ALL ENTITIES, though primarily required for "all enemies". Use for negating or modifying damage.
-- If you want to run logic on specific SOURCES of damage, check out `npc_take_dmg_callback.lua`!
mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CallbackPriority.EARLY-1, function(_, entity, amount, flags, source, cooldown)
	local returnTable = false

	local data = mod:GetEntityData(entity)

	if mod:handleSummoningCircleDamage(entity, data) == false then
		return false
	end

	if data.FFIsDeathAnimation or data.SpewTime or (mod.eternalFlickerspiritInRoom and data.eternalFlickerspirited) then
		return false
	end

	if mod:HasBrownHornImmunity(entity, data) then
		return false
	end

	if mod:FlickerspiritTakeDmg(entity, data) == false then
		return false
	end

	if mod:MartyrTakeDmg(entity, data) == false then
		return false
	end

	local npc = entity:ToNPC()
	local sourceEnt = source.Entity

	if npc then
		-- If you wanted npc-only damage and don't care about the source... right here

		if sourceEnt then
			local sourceData = mod:GetEntityData(sourceEnt)

			if mod:pacifiedOnDamage(npc, sourceEnt, sourceData) == false then
				return false
			end

			local srcCallbackResult, srcCallbackReturnedTable = mod:RunPreNpcTakeDmgFromSourceCallback(npc, data, amount, flags, sourceEnt, sourceData, source, cooldown)

			if srcCallbackReturnedTable then
				returnTable = true
				amount = srcCallbackResult.Damage or amount
				flags = srcCallbackResult.DamageFlags or flags
				cooldown = srcCallbackResult.DamageCountdown or cooldown
			elseif srcCallbackResult == false then
				return false
			end

			local bigFuncResult = mod:TheBigTakeDmgFunction(npc, data, amount, flags, source, sourceEnt, sourceData, cooldown)

			if bigFuncResult then
				returnTable = true
				amount = bigFuncResult.Damage or amount
				flags = bigFuncResult.DamageFlags or flags
				cooldown = bigFuncResult.DamageCountdown or cooldown
			end
		end
	end

	local parallelBombResult = mod:ParallelBombDamage(sourceEnt, amount)
	if parallelBombResult then
		returnTable = true
		amount = parallelBombResult.Damage
	end

	if returnTable then
		return {
			Damage = amount,
			DamageFlags = flags,
			DamageCountdown = cooldown,
		}
	end
end)

-- Post-damage effects. Wow! MC_POST_ENTITY_TAKE_DMG real!
-- If you want to run logic on specific SOURCES of damage, check out `npc_take_dmg_callback.lua`!
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, function(_, entity, amount, flags, source, cooldown)
	local data = mod:GetEntityData(entity)

	local npc = entity:ToNPC()
	local sourceEnt = source.Entity

	if npc then
		mod:CuffedNpcTakeDmg(npc, data)
		mod:SewnNpcTakeDmg(npc, data)
		mod:muggedOnDamage(npc, data, amount)
		mod:soulfulOnDamage(npc, data)
		mod:MuscaTakeDmg(npc, data, sourceEnt)

		mod:CurseOfTheScytheTakeDmg(npc, amount, flags, source, cooldown)
		mod:CurseOfTheMasterTakeDmg(npc, amount, flags, source, cooldown)

		if sourceEnt then
			local sourceData = mod:GetEntityData(sourceEnt)
			local spawner = sourceEnt.SpawnerEntity
			local spawnerData = spawner and mod:GetEntityData(spawner)

			mod:peppermintTakeDmg(npc, data, sourceEnt, sourceData)

			mod:AtlasBurdenTakeDmg(npc, data, sourceEnt)
			mod:PostTakeDmgHandleFiendFireballs(npc, data, amount, flags, sourceEnt, sourceData, spawner, spawnerData)
			mod:FriendEntityTakeDmg(npc, data, amount, flags, sourceEnt, sourceData, spawner, spawnerData)

			local compress = {damage = amount, flags = flags, source = sourceEnt, spawner = spawner}
			Isaac.RunCallbackWithParam("FF_GENERIC_NPC_TAKE_DMG_FERRIUM", _, npc, compress, data, sourceData, spawnerData)

			mod:RunPostNpcTakeDmgFromSourceCallback(npc, data, amount, flags, sourceEnt, sourceData, source, cooldown)
		end
	end

	mod:JevilsTailTakeDmg(entity, amount, flags, source, cooldown)
end)
