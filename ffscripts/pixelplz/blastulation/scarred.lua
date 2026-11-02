local mod = FiendFolio

local embryo = {
	Variant = mod.FF.Blastulation.Scarred,

	ShotSpeed = 8,
}
mod:AddEmbryo(embryo)



-- Shoot in a + pattern when landing
function embryo:Update(entity)
	if entity:GetSprite():IsEventTriggered("Landed") then
		local params = ProjectileParams()
		params.HeightModifier = 10
		entity:FireProjectilesEx(entity.Position, Vector(embryo.ShotSpeed, 4), ProjectileMode.PLUS, params)

		-- Effects
		entity:MakeSplat(0.75)

		local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 2, entity.Position, Vector.Zero, entity):ToEffect()
		effect.DepthOffset = entity.DepthOffset - 10
		effect.SpriteScale = Vector.One * 0.75
	end
end