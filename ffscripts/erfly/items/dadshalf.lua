local mod = FiendFolio

mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, mod.ITEM.COLLECTIBLE.DADS_HALF,
function(_, entity, player, weaponFlag)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.DADS_HALF) then
		if entity.Type == EntityType.ENTITY_TEAR then
			mod:makeTearBloody(entity)
		elseif weaponFlag == TearFlagsLib.WeaponFlag.FF_PLANET_X then
			mod:makePlanetXBloody(entity)
		end
	end
end)