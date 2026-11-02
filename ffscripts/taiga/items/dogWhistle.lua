-- Dog Whistle --

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

	local entities = Isaac.GetRoomEntities()
	for _,entity in ipairs(entities) do
		if entity:ToNPC() and mod:checkIfStatusLogicIsApplied(entity, false) and not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
			FiendFolio.AddBerserk(entity, player, duration)
		end
	end

	return useflags ~= useflags | UseFlag.USE_NOANIM
end, FiendFolio.ITEM.COLLECTIBLE.DOG_WHISTLE)
