local mod = FiendFolio

local embryo = {
	Variant = mod.FF.Blastulation.Burning,

	FireHealth = 3.5,
}
mod:AddEmbryo(embryo)



-- Chance to spawn a fire on death
function embryo:Death(entity)
	if mod:Random(1, 2) <= 1 then
		local fire = Isaac.Spawn(EntityType.ENTITY_FIREPLACE, 10, 0, entity.Position, Vector.Zero, entity)
		fire.HitPoints = embryo.FireHealth
		fire:Update()
	end
end