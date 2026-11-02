local mod = FiendFolio

-- Temporary familiars should be removed entirely when they die. Return true to tell War Horn not to store ghost-data about this familiar
mod:AddCallback(mod.CALLBACK.WAR_HORN_KILL_FAMILIAR, function(_, familiar)
	familiar:Remove()
	return true
end, mod.ITEM.FAMILIAR.FRAGILE_BOBBY)

mod:AddCallback(mod.CALLBACK.WAR_HORN_KILL_FAMILIAR, function(_, familiar)
	mod:GetEntityData(familiar.Player).ffsavedata.MorbidChunks = 0
	familiar:Remove()
	return true
end, mod.ITEM.FAMILIAR.MORBID_CHUNK)

mod:AddCallback(mod.CALLBACK.WAR_HORN_KILL_FAMILIAR, function(_, familiar)
	familiar:Remove()
	return true
end, FamiliarVariant.MINISAAC)

mod:AddCallback(mod.CALLBACK.WAR_HORN_KILL_FAMILIAR, function(_, familiar)
	familiar:Remove()
	return true
end, FamiliarVariant.BONE_SPUR)

mod:AddCallback(mod.CALLBACK.WAR_HORN_KILL_FAMILIAR, function(_, familiar)
	familiar:Remove()
	return true
end, FamiliarVariant.BONE_ORBITAL)

mod:AddCallback(mod.CALLBACK.WAR_HORN_KILL_FAMILIAR, function(_, familiar)
	familiar:Remove()
	return true
end, FamiliarVariant.WISP)

mod:AddCallback(mod.CALLBACK.WAR_HORN_KILL_FAMILIAR, function(_, familiar)
	familiar:Remove()
	return true
end, FamiliarVariant.SWARM_FLY_ORBITAL)

mod:AddCallback(mod.CALLBACK.WAR_HORN_KILL_FAMILIAR, function(_, familiar)
	if familiar.SubType ~= 0 then
		familiar:Remove()
		return true
	end
end, mod.ITEM.FAMILIAR.PLANET_X)

-- Multi-entity familiars need to revive the entire familiar when any part is revived.
mod:AddCallback(mod.CALLBACK.WAR_HORN_REVIVE_FAMILIAR, function(_, familiar)
	local brain = familiar
	if familiar.SubType ~= 0 then
		brain = familiar.Parent
		mod.WarHorn.ReviveFamiliar(brain, true)
	end

	for _, part in pairs(mod:GetEntityData(brain).Segments) do
		if not TearFlagsLib.AreEntitiesSame(part, familiar) then
			mod.mod.WarHorn.ReviveFamiliar(part, true)
		end
	end
end, mod.ITEM.FAMILIAR.OPHIUCHUS)

mod:AddCallback(mod.CALLBACK.WAR_HORN_REVIVE_FAMILIAR, function(_, familiar)
	local brain = familiar
	if familiar.SubType ~= 0 then
		brain = familiar.Parent
		mod.mod.WarHorn.ReviveFamiliar(brain, true)
	end

	for _, part in pairs(mod:GetEntityData(brain).Hands) do
		if not TearFlagsLib.AreEntitiesSame(part, familiar) then
			mod.mod.WarHorn.ReviveFamiliar(part, true)
		end
	end
end, mod.ITEM.FAMILIAR.GRABBER)

mod:AddCallback(mod.CALLBACK.WAR_HORN_REVIVE_FAMILIAR, function(_, familiar)
	for _, part in pairs(mod:GetEntityData(familiar).whisperFam) do
		mod.mod.WarHorn.ReviveFamiliar(part, true)
	end
end, mod.ITEM.FAMILIAR.CARELESS_WHISPERS)

mod:AddCallback(mod.CALLBACK.WAR_HORN_REVIVE_FAMILIAR, function(_, familiar)
	local brain = familiar.Parent
	mod.mod.WarHorn.ReviveFamiliar(brain, true)

	for _, part in pairs(mod:GetEntityData(brain).whisperFam) do
		if not TearFlagsLib.AreEntitiesSame(part, familiar) then
			mod.mod.WarHorn.ReviveFamiliar(part, true)
		end
	end
end, mod.ITEM.FAMILIAR.CARELESS_WHISPER_INDIVIDUAL)