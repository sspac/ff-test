-- Doomsday Clock --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local doomDuration = 300
local doomCountdown = 3

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, id, rng, player, useflags, activeslot, customvardata)
	local batteryMult = 1
	if useflags == useflags | UseFlag.USE_CARBATTERY then
		batteryMult = 2
	end

	local entities = Isaac.GetRoomEntities()
	for _,entity in ipairs(entities) do
		local npc = entity:ToNPC()
		local ptrhash = GetPtrHash(entity)
		mod.QueuedStatusApply[ptrhash] = mod.QueuedStatusApply[ptrhash] or {}
		table.insert(mod.QueuedStatusApply[ptrhash], function()
			if npc and mod:checkIfStatusLogicIsApplied(npc, false) and not npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
				if mod:CanApplyDoom(npc, player) then
					local isBoss = npc:IsBoss()
					FiendFolio.AddDoom(npc, player, doomDuration * batteryMult, doomCountdown, (isBoss and 40 * batteryMult) or 999, nil, nil, nil, nil, nil, not isBoss)
				end
			end
		end)
	end

	return useflags ~= useflags | UseFlag.USE_NOANIM
end, FiendFolio.ITEM.COLLECTIBLE.DOOMSDAY_CLOCK)
