local mod = FiendFolio

local embryo = {
	Variant = mod.FF.Blastulation.Chubber,

	LaunchSpeed = 14,
}
mod:AddEmbryo(embryo)



-- Go Chubber mode
function embryo:Death(entity)
	local target = entity:GetPlayerTarget()
	local vector = mod:ClampVector(target.Position - entity.Position, 90)

	local func = function()
		local chubber = Isaac.Spawn(EntityType.ENTITY_VIS, 22, 1, entity.Position, vector, entity):ToNPC()
		chubber.State = NpcState.STATE_MOVE
		chubber.V1 = vector:Resized(embryo.LaunchSpeed)
		chubber.MaxHitPoints = 0
		chubber.Mass = 1
		chubber:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
		chubber:Update()
	end
	Isaac.CreateTimer(func, 1, 1, false)
end