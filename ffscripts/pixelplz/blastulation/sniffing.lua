local mod = FiendFolio

local embryo = {
	Variant = mod.FF.Blastulation.Sniffing,

	Cooldown = {30, 15 * 30},
}
mod:AddEmbryo(embryo)



function embryo:Init(entity)
	entity.ProjectileCooldown = math.random(embryo.Cooldown[1], embryo.Cooldown[2])
end

-- sniff
function embryo:Update(entity)
	if entity.ProjectileCooldown <= 0 then
		local volume = math.random(45, 55) / 100
		local pitch = math.random(90, 110) / 100
		mod:PlaySoundCool(entity, mod.Sounds.EmbryoSniff, volume, pitch)

		entity.ProjectileCooldown = math.random(embryo.Cooldown[1], embryo.Cooldown[2])
	else
		entity.ProjectileCooldown = entity.ProjectileCooldown - 1
	end
end