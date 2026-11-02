-- Siren Blacklisting --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

function mod:isSirenCharmed(familiar)
	local helpers = Isaac.FindByType(EntityType.ENTITY_SIREN_HELPER, -1, -1, true)
	for _, helper in ipairs(helpers) do
		if helper.Target and helper.Target.Index == familiar.Index and helper.Target.InitSeed == familiar.InitSeed then
			return true, helper
		end
	end
	return false, nil
end

function mod:getSirenHelper(familiar)
	local helpers = Isaac.FindByType(EntityType.ENTITY_SIREN_HELPER, -1, -1, true)
	for _, helper in ipairs(helpers) do
		if helper.Target and helper.Target.Index == familiar.Index and helper.Target.InitSeed == familiar.InitSeed then
			return helper
		end
	end
end

local hiddenFromSiren = {}
mod:AddPriorityEntityCallback(ModCallbacks.MC_PRE_NPC_UPDATE, math.huge, EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.PETROCK, nil, function(_, siren)
	local petrocks = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.PETROCK)
	for _,petrock in ipairs(petrocks) do
		if not petrock.Visible then
			petrock:AddEntityFlags(EntityFlag.FLAG_NO_QUERY)
			table.insert(hiddenFromSiren, petrock)
		end
	end
end, EntityType.ENTITY_SIREN)

mod:AddPriorityEntityCallback(ModCallbacks.MC_PRE_NPC_UPDATE, math.huge, EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.OPHIUCHUS, nil, function(_, siren)
	local sneks = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.OPHIUCHUS)
	for _,snek in ipairs(sneks) do
		if snek.SubType ~= 0 then
			snek:AddEntityFlags(EntityFlag.FLAG_NO_QUERY)
			table.insert(hiddenFromSiren, snek)
		end
	end
end, EntityType.ENTITY_SIREN)

mod:AddPriorityEntityCallback(ModCallbacks.MC_PRE_NPC_UPDATE, math.huge, EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.GRABBER, nil, function(_, siren)
	local grabbers = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.GRABBER)
	for _,grabber in ipairs(grabbers) do
		if grabber.SubType == 1 or grabber.SubType == 2 then
			grabber:AddEntityFlags(EntityFlag.FLAG_NO_QUERY)
			table.insert(hiddenFromSiren, grabber)
		end
	end
end, EntityType.ENTITY_SIREN)

mod:AddPriorityEntityCallback(ModCallbacks.MC_PRE_NPC_UPDATE, math.huge, EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.PLANET_X, nil, function(_, siren)
	local planets = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.PLANET_X)
	for _,planet in ipairs(planets) do
		if planet.SubType ~= 0 then
			planet:AddEntityFlags(EntityFlag.FLAG_NO_QUERY)
			table.insert(hiddenFromSiren, planet)
		end
	end
end, EntityType.ENTITY_SIREN)

mod:AddPriorityEntityCallback(ModCallbacks.MC_PRE_NPC_UPDATE, math.huge, EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.CARELESS_WHISPER_INDIVIDUAL, nil, function(_, siren)
	local whispers = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.CARELESS_WHISPER_INDIVIDUAL)
	for _,whisper in ipairs(whispers) do
		whisper:AddEntityFlags(EntityFlag.FLAG_NO_QUERY)
		table.insert(hiddenFromSiren, whisper)
	end
end, EntityType.ENTITY_SIREN)

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, siren)
	for _,familiar in ipairs(hiddenFromSiren) do
		familiar:ClearEntityFlags(EntityFlag.FLAG_NO_QUERY)
	end
	hiddenFromSiren = {}
end, EntityType.ENTITY_SIREN)