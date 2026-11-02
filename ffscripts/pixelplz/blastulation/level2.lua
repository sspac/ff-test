local mod = FiendFolio

local embryo = {
	Variant = mod.FF.Blastulation.Level2,
	Special = true,

	SpawnDelay = 20,
	Radius = 60,
	SpawnCount = 3,
}
mod:AddEmbryo(embryo)



-- Splat color
function embryo:Init(entity)
	entity.SplatColor = Color(1,1,1, 1, 0,0,0, 1,1,1, 0.65)
end

-- Be super stinky and gross haha
function embryo:Update(entity)
	if not entity.Child or not entity.Child:Exists() then
		local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0, entity.Position, Vector.Zero, entity):ToEffect()
		entity.Child = effect

		-- Follow the entity and disappear along with it
		effect.Parent = entity
		effect:FollowParent(entity)
		effect.DepthOffset = entity.DepthOffset - 10

		-- Set the scale
		local scale = embryo.Radius / 40
		effect:GetSprite().Scale = Vector.One * scale
	end
end

function embryo:Death(entity)
	local offset = mod:Random(359)
	local baseAngle = 360 / embryo.SpawnCount

	for i = 1, embryo.SpawnCount do
		local angle = offset + baseAngle * i
		local speed = mod:Random(2, 4)
		local velocity = Vector.FromAngle(angle):Resized(speed)

		-- Phage time
		if LastJudgement and LastJudgement.STAGE.Mortis:IsStage() then
			local phage = Isaac.Spawn(LastJudgement.ENT.Phage.ID, LastJudgement.ENT.Phage.Var, 0, entity.Position, velocity, entity):ToNPC()
			phage:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			mod:GetEntityData(phage).State = "Idle"

		-- Maggot time
		else
			local maggot = Isaac.Spawn(EntityType.ENTITY_SMALL_MAGGOT, 0, 0, entity.Position, Vector.Zero, entity):ToNPC()
			maggot.State = NpcState.STATE_SPECIAL
			maggot.TargetPosition = velocity
			maggot.PositionOffset = Vector(0, -10)

			-- Set the Z speed
			local zSpeed = mod:Random(4, 10)
			maggot.V1 = Vector(-zSpeed, 0)
		end
	end
end