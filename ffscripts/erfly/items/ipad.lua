local mod = FiendFolio
local game = Game()

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function()
	local room = game:GetRoom()
	for _, npc in pairs(Isaac.GetRoomEntities()) do
		if npc:IsEnemy() then
			npc.Position = Vector(npc.Position.X, room:GetGridHeight() * 50)
		end
	end
	--print("before")
	--return true
end, mod.ITEM.COLLECTIBLE.MARIAS_IPAD)

local ipadWispTearsToBePostFired = {}
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, familiar)
	if familiar.SubType == mod.ITEM.COLLECTIBLE.MARIAS_IPAD then
		for _, t in pairs(ipadWispTearsToBePostFired) do
			t.Velocity = Vector(0,1):Resized(t.Velocity:Length()) + familiar.Player:GetTearMovementInheritance(familiar.Player:GetAimDirection())
			--local tdata = mod:GetEntityData(t)
			--tdata.ipadTear = true
		end

		ipadWispTearsToBePostFired = {}
	end
end, FamiliarVariant.WISP)

mod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, function(_, tear)
	if tear.SpawnerEntity and
	   tear.SpawnerEntity.Type == EntityType.ENTITY_FAMILIAR and
	   tear.SpawnerEntity.Variant == FamiliarVariant.WISP and
	   tear.SpawnerEntity.SubType == mod.ITEM.COLLECTIBLE.MARIAS_IPAD
	then
		ipadWispTearsToBePostFired[tear.Index .. " " .. tear.InitSeed] = tear
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, tear)
	if ipadWispTearsToBePostFired[tear.Index .. " " .. tear.InitSeed] then
		ipadWispTearsToBePostFired[tear.Index .. " " .. tear.InitSeed] = nil
	end
end, EntityType.ENTITY_TEAR)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	ipadWispTearsToBePostFired = {}
end)

function mod:ipadOnTearDamage(sourcedata, ent)
	if sourcedata.ipadTear then
		ent.Position = Vector(ent.Position.X, room:GetGridHeight() * 50)
	end
end