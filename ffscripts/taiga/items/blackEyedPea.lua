-- Black-Eyed Pea --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local baseDuration = 120
local bruiseRadius = 120
local knockbackRadius = 120

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, id, rng, player, useflags, activeslot, customvardata)
	local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
	local duration = baseDuration * secondHandMultiplier
	if useflags == useflags | UseFlag.USE_CARBATTERY then
		duration = duration * 2
	end
	local hasGiganteBean = player:HasTrinket(TrinketType.TRINKET_GIGANTE_BEAN)
	
	local entities = Isaac.FindInRadius(player.Position, 9999, EntityPartition.ENEMY)
	for _,entity in ipairs(entities) do
		if entity:ToNPC() and mod:checkIfStatusLogicIsApplied(entity, false) and not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
			if entity.Position:Distance(player.Position) < entity.Size * math.max(entity.SizeMulti.X, entity.SizeMulti.Y) + bruiseRadius * ((hasGiganteBean and 2) or 1) then
				FiendFolio.AddBruise(entity, player, duration, 1, 1)
				FiendFolio.AddBruise(entity, player, duration - baseDuration * 1/3 * secondHandMultiplier, 1, 1)
				FiendFolio.AddBruise(entity, player, duration - baseDuration * 2/3 * secondHandMultiplier, 1, 1)
			end
		end
	end
	game:ButterBeanFart(player.Position, knockbackRadius, player, false, false)
	
	local fartCloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FART, 0, player.Position, nilvector, player)
	local fartSprite = fartCloud:GetSprite()
	fartSprite.Color = Color(0.4, 0.4, 0.4, 1.0, 40/255, 0/255, 40/255, 1.0, 1.0, 1.0, 1)
	fartSprite.Scale = (hasGiganteBean and Vector(2,2)) or Vector(1,1)

	return false
end, FiendFolio.ITEM.COLLECTIBLE.BLACK_EYED_PEA)