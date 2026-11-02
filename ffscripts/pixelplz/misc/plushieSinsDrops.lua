local mod = FiendFolio

local plushieDrops = {
	-- Sloth
	[ EntityType.ENTITY_SLOTH ] = {
		Variants = {
			[0] = { Super = false, },
			[1] = { Super = true, },
		},
		Replace = PickupVariant.PICKUP_TAROTCARD,
		TrinketID = mod.ITEM.TRINKET.PLUSHIE_SLOTH,
	},

	-- Lust
	[ EntityType.ENTITY_LUST ] = {
		Variants = {
			[0] = { Super = false, },
			[1] = { Super = true, },
		},
		Replace = PickupVariant.PICKUP_PILL,
		TrinketID = mod.ITEM.TRINKET.PLUSHIE_LUST,
	},

	-- Wrath
	[ EntityType.ENTITY_WRATH ] = {
		Variants = {
			[0] = { Super = false, },
			[1] = { Super = true, },
		},
		Replace = PickupVariant.PICKUP_BOMB,
		TrinketID = mod.ITEM.TRINKET.PLUSHIE_WRATH,
	},

	-- Gluttony
	[ EntityType.ENTITY_GLUTTONY ] = {
		Variants = {
			[0] = { Super = false, },
			[1] = { Super = true, },
		},
		Replace = PickupVariant.PICKUP_HEART,
		TrinketID = mod.ITEM.TRINKET.PLUSHIE_GLUTTONY,
	},

	-- Greed
	[ EntityType.ENTITY_GREED ] = {
		Variants = {
			[0] = { Super = false, },
			[1] = { Super = true, },
		},
		Replace = PickupVariant.PICKUP_COIN,
		TrinketID = mod.ITEM.TRINKET.PLUSHIE_GREED,
	},

	-- Envy
	[ EntityType.ENTITY_ENVY ] = {
		Variants = {
			[30] = { Super = false, },
			[31] = { Super = true, },
		},
		Replace = PickupVariant.PICKUP_BOMB,
		TrinketID = mod.ITEM.TRINKET.PLUSHIE_ENVY,
	},

	-- Pride
	[ EntityType.ENTITY_PRIDE ] = {
		Variants = {
			[0] = { Super = false, },
			[1] = { Super = true, },
		},
		Replace = PickupVariant.PICKUP_KEY,
		TrinketID = mod.ITEM.TRINKET.PLUSHIE_PRIDE,
	},
}



for sinType, entry in pairs(plushieDrops) do
	-- Try to queue the plushie drop
	local queueFunc = function(_, entity)
		local variantEntry = entry.Variants[entity.Variant]
		local isAnyGolem, isMixedGolem = FiendFolio.GolemExists()
		local rng = entity:GetDropRNG()

		if variantEntry -- Is a valid sin
		and (not isAnyGolem or isMixedGolem) -- Don't drop if there are only Golems
		and Isaac.GetItemConfig():GetTrinket(entry.TrinketID):IsAvailable() -- Is unlocked
		and Game():GetItemPool():HasTrinket(entry.TrinketID) -- Is in the trinket pool
		and mod:Random(1, 5, rng) <= 1 then -- Random chance
			local canBeGold = variantEntry.Super -- Is a super sin
			and Isaac.GetPersistentGameData():Unlocked(Achievement.GOLDEN_TRINKET) -- Golden trinkets are unlocked

			mod:GetEntityData(entity).DropPlushie = {
				Dropped  = false,
				IsGolden = canBeGold and mod:Random(1, 2, rng) == 1,
			}
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, queueFunc, sinType)



	-- Replace pickup drops with the plushie if queued
	local dropFunc = function(_, eType, eVariant, eSubType, position, velocity, spawner, seed)
		if spawner and spawner.Type == sinType and entry.Variants[spawner.Variant] -- Is a valid sin
		and spawner:HasEntityFlags(EntityFlag.FLAG_BOSSDEATH_TRIGGERED) -- Is supposed to drop pickups
		and eType == EntityType.ENTITY_PICKUP and eVariant == entry.Replace then -- Is a replacable pickup
			local data = mod:GetEntityData(spawner)
			local dropData = data.DropPlushie

			if dropData then
				-- Only spawn the plushie once...
				if not dropData.Dropped then
					local trinketID = entry.TrinketID

					-- Remove it from the trinket pool
					Game():GetItemPool():RemoveTrinket(trinketID)

					-- Make it golden
					if dropData.IsGolden then
						trinketID = trinketID | TrinketType.TRINKET_GOLDEN_FLAG
					end

					position = Game():GetRoom():FindFreePickupSpawnPosition(position)
					Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, trinketID, position, Vector.Zero, spawner)
					dropData.Dropped = true
				end

				-- ...but remove every pickup drop from this sin
				return { StageAPI.E.DeleteMePickup.T, StageAPI.E.DeleteMePickup.V, 0, seed }
			end
		end
	end
	mod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, dropFunc)
end