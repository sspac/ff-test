local mod = FiendFolio

local embryo = {
	Variant = mod.FF.Blastulation.Angelic,
}
mod:AddEmbryo(embryo)



function embryo:Update(entity)
	local sprite = entity:GetSprite()

	-- Start flying
	if sprite:IsEventTriggered("Jump") then
		entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS

	-- Stop flying
	elseif sprite:IsEventTriggered("Landed") then
		entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
	end
end