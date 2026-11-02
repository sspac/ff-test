-- Bedtime Story --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, id, rng, player, useflags, activeslot, customvardata)
	local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1

	local duration = 180 * secondHandMultiplier
	if useflags == useflags | UseFlag.USE_CARBATTERY then
		duration = 360 * secondHandMultiplier
	end

	game:Darken(1, duration + 40)

	local entities = Isaac.GetRoomEntities()
	for _,entity in ipairs(entities) do
		if entity:ToNPC() and mod:checkIfStatusLogicIsApplied(entity, false) and not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
			FiendFolio.AddDrowsy(entity, player, 40, duration)
		end
	end

	return useflags ~= useflags | UseFlag.USE_NOANIM
end, FiendFolio.ITEM.COLLECTIBLE.BEDTIME_STORY)

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, function(_, e)
	if e.Variant == FamiliarVariant.WISP and e.SubType == FiendFolio.ITEM.COLLECTIBLE.BEDTIME_STORY then
		local player = e:ToFamiliar().Player
		local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1

		local duration = 90 * secondHandMultiplier
		game:Darken(1, duration + 40)

		local entities = Isaac.GetRoomEntities()
		for _,entity in ipairs(entities) do
			if entity:ToNPC() and mod:checkIfStatusLogicIsApplied(entity, false) and not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
				FiendFolio.AddDrowsy(entity, player, 40, duration, 2)
			end
		end
	end
end, EntityType.ENTITY_FAMILIAR)
