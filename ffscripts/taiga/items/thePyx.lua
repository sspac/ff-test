-- The Pyx --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local baseDuration = 180

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, id, rng, player, useflags, activeslot, customvardata)
	local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
	local duration = baseDuration * secondHandMultiplier
	if useflags == useflags | UseFlag.USE_CARBATTERY then
		duration = duration * 2
	end

	local entities = Isaac.GetRoomEntities()
	local highestHP = -1 * math.huge
	local highestHasBoss = false
	local enemies = {}
	for _, entity in ipairs(entities) do
		local npc = entity:ToNPC()
		if npc then
			local statusLogicIsApplied = mod:checkIfStatusLogicIsApplied(entity, false, nil, true)
			local isUnfriendly = not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)
			local canHaveStatuses = not (entity:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) or mod:isStatusBlacklisted(entity))
			local isNotMask = not (entity.Type == EntityType.ENTITY_MASK or entity.Type == EntityType.ENTITY_MASK_OF_INFAMY)
			
			if statusLogicIsApplied and isUnfriendly and canHaveStatuses and isNotMask then
				table.insert(enemies, npc)
				
				local hp = npc.HitPoints
				if hp > highestHP then
					highestHP = hp
					highestHasBoss = false
				end
				highestHasBoss = highestHasBoss or npc:IsBoss()
			end
		end
	end
	
	local hasFoundHighest = false
	local hasAppliedExcom = false
	local damage = player.Damage
	for _, npc in ipairs(enemies) do
		local hp = npc.HitPoints
		local isBoss = npc:IsBoss()
		if hasFoundHighest or hp < highestHP or (highestHasBoss and not isBoss) then
			FiendFolio.AddExcommunicated(npc, player, duration, damage, nil, true)
			hasAppliedExcom = true
		else
			hasFoundHighest = true
		end
	end
	
	if not hasAppliedExcom then
		FiendFolio.AddExcommunicated(enemies[1], player, duration, damage, nil, true)
	end

	return useflags ~= useflags | UseFlag.USE_NOANIM
end, FiendFolio.ITEM.COLLECTIBLE.THE_PYX)
