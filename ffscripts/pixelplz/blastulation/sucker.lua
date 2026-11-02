local mod = FiendFolio

local embryo = {
	Variant = mod.FF.Blastulation.Sucker,

	ShotSpeed = 10,
}
mod:AddEmbryo(embryo)



-- Shoot in a + pattern on death
function embryo:Death(entity)
	entity:FireProjectilesEx(entity.Position, Vector(embryo.ShotSpeed, 4), ProjectileMode.PLUS, ProjectileParams())
end