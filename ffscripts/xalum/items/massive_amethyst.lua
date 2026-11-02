local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local massiveAmethyst = mod.ITEM.TRINKET.MASSIVE_AMETHYST

mod.MASSIVE_AMETHYST = {
	NORMAL = Isaac.GetEntityVariantByName("Massive Amethyst Cluster"),
	FLOATING = Isaac.GetEntityVariantByName("Floating Massive Amethyst Cluster"),
}

--mod.GolemTrinketWhitelist[mod.TRINKETS.MASSIVE_AMETHYST] = 1
--moved to golem.lua

function mod.TransformShopkeeperToAmethyst(npc, amethyst)
	npc:Remove()

	for _, entity in pairs(Isaac.FindByType(5)) do
		if entity.FrameCount == 0 and npc.Position:Distance(entity.Position) < 5 then
			entity:Remove()
		end
	end

	local new = Isaac.Spawn(6, amethyst, 0, npc.Position, Vector.Zero, nil)
	mod:GetEntityData(new).init = true

	new:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)

	local sprite = new:GetSprite()
	if new.Variant == mod.MASSIVE_AMETHYST.NORMAL then
		sprite:Play("Shopkeeper " .. math.random(9))
	else
		sprite:Play("Guy" .. math.random(9))
	end
end

mod:AddTrinketCallback(ModCallbacks.MC_POST_NPC_INIT, massiveAmethyst, function(_, npc)
	local room = game:GetRoom()

	local playersNearby = #Isaac.FindInRadius(npc.Position, 5, EntityPartition.PLAYER) > 0 -- EID???? :(
	if not playersNearby and room:GetType() == RoomType.ROOM_SECRET and npc:Exists() then
		if npc.Variant == 0 or npc.Variant == 3 then
			mod.TransformShopkeeperToAmethyst(npc, mod.MASSIVE_AMETHYST.NORMAL)
		elseif npc.Variant == 1 or npc.Variant == 4 then
			mod.TransformShopkeeperToAmethyst(npc, mod.MASSIVE_AMETHYST.FLOATING)
		end
	end
end, EntityType.ENTITY_SHOPKEEPER)

function mod:MassiveAmethystSlotUpdate(slot)
	local data = mod:GetEntityData(slot)
	if not data.init then
		data.init = true

		slot:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)

		local sprite = slot:GetSprite()
		if slot.Variant == mod.MASSIVE_AMETHYST.NORMAL then
			sprite:Play("Shopkeeper " .. math.random(9))
		else
			sprite:Play("Guy" .. math.random(9))
		end
	end

	if slot.GridCollisionClass == 5 then
		for _, pickup in pairs(Isaac.FindByType(5)) do
			if pickup.FrameCount <= 1 and pickup.Position:Distance(slot.Position) < 7 and not pickup.SpawnerEntity then
				pickup:Remove()
			end
		end

		for _, bomb in pairs(Isaac.FindByType(4)) do
			if bomb.FrameCount <= 1 and bomb.Position:Distance(slot.Position) < 7 and not bomb.SpawnerEntity then
				bomb:Remove()
			end
		end

		local mult = PlayerManager.GetTotalTrinketMultiplier(massiveAmethyst)
		local rng = (PlayerManager.FirstTrinketOwner(massiveAmethyst) or Isaac.GetPlayer()):GetTrinketRNG(massiveAmethyst)
		local itempool = game:GetItemPool()

		for i = 1, mult + rng:RandomInt(3) do
			Isaac.Spawn(5, 300, Card.RUNE_SHARD, slot.Position, RandomVector(), slot)
		end

		for i = 0, rng:RandomInt(2) do
			local rune = itempool:GetCard(rng:Next(), false, true, true)
			Isaac.Spawn(5, 300, rune, slot.Position, RandomVector(), slot)
		end

		sfx:Play(mod.Sounds.AmethystBreak)

		for i = 1, math.random(4, 9) do
			local gib = Isaac.Spawn(1000, 35, 0, slot.Position, RandomVector() * 3, slot)
			local gibSprite = gib:GetSprite()

			gibSprite:Load("gfx/effects/amethyst_gibs.anm2", true)
			gibSprite:Play("Gib0" .. math.random(4))
		end

		slot:Remove()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, mod.MassiveAmethystSlotUpdate, mod.MASSIVE_AMETHYST.NORMAL)
mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, mod.MassiveAmethystSlotUpdate, mod.MASSIVE_AMETHYST.FLOATING)
