-- Holy Bean --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local baseDuration = 90
local excomRadius = 120
local knockbackRadius = 120

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, id, rng, player, useflags, activeslot, customvardata)
	local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
	local duration = baseDuration * secondHandMultiplier
	if useflags == useflags | UseFlag.USE_CARBATTERY then
		duration = duration * 2
	end
	local damage = player.Damage
	local hasGiganteBean = player:HasTrinket(TrinketType.TRINKET_GIGANTE_BEAN)
	
	local entities = Isaac.FindInRadius(player.Position, 9999, EntityPartition.ENEMY)
	for _,entity in ipairs(entities) do
		if entity:ToNPC() and mod:checkIfStatusLogicIsApplied(entity, false) and not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
			if entity.Position:Distance(player.Position) < entity.Size * math.max(entity.SizeMulti.X, entity.SizeMulti.Y) + excomRadius * ((hasGiganteBean and 2) or 1) then
				FiendFolio.AddExcommunicated(entity, player, duration, damage, nil, true)
			end
		end
	end
	game:ButterBeanFart(player.Position, knockbackRadius, player, false, false)
	
	local fartCloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FART, 0, player.Position, nilvector, player)
	local fartSprite = fartCloud:GetSprite()
	fartSprite.Color = Color(1.3, 1.3, 1.3, 1.0, 0/255, 30/255, 45/255, 1.0, 1.0, 1.0, 1)
	fartSprite.Scale = (hasGiganteBean and Vector(2,2)) or Vector(1,1)

	return false
end, FiendFolio.ITEM.COLLECTIBLE.HOLY_BEAN)