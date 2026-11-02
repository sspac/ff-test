local mod = FiendFolio

local embryo = {
	Variant = mod.FF.Blastulation.Drowned,

	ShotSpeed = 8,
}
mod:AddEmbryo(embryo)



-- Shoot in an X pattern on death
function embryo:Death(entity)
	local params = ProjectileParams()
	params.Variant = ReworkedFoes and ProjectileVariant.PROJECTILE_TEAR or ProjectileVariant.PROJECTILE_NORMAL
	entity:FireProjectilesEx(entity.Position, Vector(embryo.ShotSpeed, 4), ProjectileMode.CROSS, params)
end