local mod = FiendFolio

local embryos = {
	mod.FF.Blastulation.Walking,
	mod.FF.Blastulation.Blue,
}

for i, variant in pairs(embryos) do
	local embryo = {
		Variant = variant,
	}
	mod:AddEmbryo(embryo)
end