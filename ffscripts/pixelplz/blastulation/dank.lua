local mod = FiendFolio

local embryo = {
	Variant = mod.FF.Blastulation.Dank,

	LandCreepScale = 0.9,
	DeathCreepScale = 1.5,
}
mod:AddEmbryo(embryo)



-- Splat color
function embryo:Init(entity)
	entity.SplatColor = Color.ProjectileTar
end

-- Create creep when landing
function embryo:Update(entity)
	if entity:GetSprite():IsEventTriggered("Landed") then
		mod:QuickCreep(EffectVariant.CREEP_BLACK, entity, entity.Position, embryo.LandCreepScale)

		-- Effect
		local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 2, entity.Position, Vector.Zero, entity):ToEffect()
		effect.DepthOffset = entity.DepthOffset - 10
		effect.SpriteScale = Vector.One * 0.75
		effect:GetSprite().Color = Color.ProjectileTar
	end
end

-- Create creep on death
function embryo:Death(entity)
	mod:QuickCreep(EffectVariant.CREEP_BLACK, entity, entity.Position, embryo.DeathCreepScale)
end