local mod = FiendFolio
local game = Game()

function mod:FleaCircusTakeDmg(ent, tab, data)
	local sourceEnt = tab.source
	data.LastDamageWasFlea = sourceEnt and sourceEnt.Type == EntityType.ENTITY_FAMILIAR and sourceEnt.Variant == mod.ITEM.FAMILIAR.ATTACK_SKUZZ and sourceEnt.SubType > 0
end
mod:AddTrinketCallback("FF_GENERIC_NPC_TAKE_DMG_FERRIUM", mod.ITEM.TRINKET.FLEA_CIRCUS, mod.FleaCircusTakeDmg)

function mod:FleaCircusDeath(npc, data)
	if mod.anyPlayerHas(FiendFolio.ITEM.TRINKET.FLEA_CIRCUS, true) then
		local mult = mod.getTrinketMultiplierAcrossAllPlayers(FiendFolio.ITEM.TRINKET.FLEA_CIRCUS)
		if not data.LastDamageWasFlea and not (npc.Type == mod.FFID.Tech and npc.Variant > 999) then
			local room = game:GetRoom()
			local chance = mult*20
			if npc:GetDropRNG():RandomInt(100) < chance and room:GetGridCollisionAtPos(npc.Position) == GridCollisionClass.COLLISION_NONE then
				local subt = npc:GetDropRNG():RandomInt(4) + 1
				local flea = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.ATTACK_SKUZZ, subt, npc.Position, Vector.Zero, nil):ToFamiliar()
				flea:Update()
			end
		end
	end
end
mod:AddTrinketCallback("FF_POST_NPC_DEATH_FERRIUM", mod.ITEM.TRINKET.FLEA_CIRCUS, mod.FleaCircusDeath)

function mod:ClumpOfLadybugsDeath(npc)
	if mod.anyPlayerHas(FiendFolio.ITEM.TRINKET.CLUMP_OF_LADYBUGS, true) then
		local mult = mod.getTrinketMultiplierAcrossAllPlayers(FiendFolio.ITEM.TRINKET.CLUMP_OF_LADYBUGS)
		if not (npc.Type == mod.FFID.Tech and npc.Variant > 999) then
			local room = game:GetRoom()
			local chance = mult*20
			if npc:GetDropRNG():RandomInt(100) < chance and room:GetGridCollisionAtPos(npc.Position) == GridCollisionClass.COLLISION_NONE then
				local subt = npc:GetDropRNG():RandomInt(4) + 1
				local lady = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.BLUE_BEETLE, subt, npc.Position, Vector.Zero, nil):ToFamiliar()
				lady:Update()
			end
		end
	end
end
mod:AddTrinketCallback("FF_POST_NPC_DEATH_FERRIUM", mod.ITEM.TRINKET.CLUMP_OF_LADYBUGS, mod.ClumpOfLadybugsDeath)