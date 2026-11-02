local mod = FiendFolio

local embryo = {
	Variant = mod.FF.Blastulation.Mishap.Variant,

	LimeChance = 33,
	CreepSize = 2.5,
	CreepDuration = 240,
}
mod:AddEmbryo(embryo)



function embryo:Init(entity)
	-- Have a chance to turn into the lime variant if a player has Limestone
	local trinketMulti = PlayerManager.GetTotalTrinketMultiplier(FiendFolio.ITEM.ROCK.LIMESTONE)
	local chance = trinketMulti * embryo.LimeChance
	local rng = RNG(entity.InitSeed)

	if mod:Random(nil, nil, rng) <= chance / 100 then
		entity:Morph(entity.Type, entity.Variant, mod.FF.Blastulation.Mishap.SubTypes.Lime, -1)
	end

	-- Splat colors
	if entity.SubType == mod.FF.Blastulation.Mishap.SubTypes.Lime then
		entity.SplatColor = FiendFolio.ColorIpecacProper
	else
		entity.SplatColor = FiendFolio.ColorLemonYellow
	end
end

-- Create creep on death
function embryo:Death(entity)
	if entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
		local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_LEMON_MISHAP, 0, entity.Position, Vector.Zero, entity)
		creep:Update()

		-- Free item idea: Lime Mishap
		-- Same as Lemon Mishap but green :)
		if entity.SubType == mod.FF.Blastulation.Mishap.SubTypes.Lime then
			creep:GetSprite():ReplaceSpritesheet(0, "gfx/enemies/blastulation/lime_mishap.png", true)
		end

	else
		local variant = entity.SubType == mod.FF.Blastulation.Mishap.SubTypes.Lime and EffectVariant.CREEP_GREEN or EffectVariant.CREEP_YELLOW
		mod:QuickCreep(variant, entity, entity.Position, embryo.CreepSize, embryo.CreepDuration)
	end
end