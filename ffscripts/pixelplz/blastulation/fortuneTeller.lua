local mod = FiendFolio

local embryo = {
	Variant = mod.FF.Blastulation.FortuneTeller,
}
mod:AddEmbryo(embryo)



-- Show a fortune on death
function embryo:Death(entity)
	mod:ShowFortune(false, true)
end