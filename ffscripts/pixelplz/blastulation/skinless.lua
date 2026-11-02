local mod = FiendFolio

local embryo = {
	Variant = mod.FF.Blastulation.Skinless,
	Special = true,
}
mod:AddEmbryo(embryo)



function embryo:Update(entity)
	return true
end