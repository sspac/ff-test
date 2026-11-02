local mod = FiendFolio

local embryo = {
	Variant = mod.FF.Blastulation.Sketch,
}
mod:AddEmbryo(embryo)



-- Splat color
function embryo:Init(entity)
	entity.SplatColor = Color(0,0,0, 1, 0.48,0.4,0.36)
end