local mod = FiendFolio

local embryo = {
	Variant = mod.FF.Blastulation.Guillotine.Variant,

	OrbitSpeed = 3,
	OrbitDistance = 35,
}
mod:AddEmbryo(embryo)



function embryo:Init(entity)
	if entity.SubType == mod.FF.Blastulation.Guillotine.SubTypes.Body then
		entity:GetSprite():PlayOverlay("Blood", true)

		-- Create the head
		local head = Isaac.Spawn(entity.Type, entity.Variant, mod.FF.Blastulation.Guillotine.SubTypes.Head, entity.Position, Vector.Zero, entity)
		head.Parent = entity
		entity.Child = head
		head:Update()

	elseif entity.SubType == mod.FF.Blastulation.Guillotine.SubTypes.Head then
		entity:AddEntityFlags(
			EntityFlag.FLAG_NO_TARGET |
			EntityFlag.FLAG_HIDE_HP_BAR |
			EntityFlag.FLAG_NO_REWARD |
			EntityFlag.FLAG_NO_KNOCKBACK |
			EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK
		)
	end
end

function embryo:Update(entity)
	local sprite = entity:GetSprite()


	--[[ Body ]]--
	if entity.SubType == mod.FF.Blastulation.Guillotine.SubTypes.Body then
		entity:CopyStatusEffects(entity.Child, true)

		-- Set the blood gush position
		local bloodPos = sprite:GetNullFrame("GushPos"):GetPos()
		sprite:GetLayer("blood"):SetPos(bloodPos)

		-- Epic blood trail
		if entity:IsFrame(10, 0) then
			entity:MakeSplat(0.75).Color = entity.SplatColor
		end



	--[[ Head ]]--
	elseif entity.SubType == mod.FF.Blastulation.Guillotine.SubTypes.Head then
		-- Die without the body
		if not entity.Parent or not entity.Parent:Exists() or entity.Parent:IsDead() then
			entity:Kill()

		else
			mod:LoopingAnim(sprite, "Head")
			sprite.FlipX = entity.Parent:GetSprite().FlipX

			-- Update the angle
			local add = Vector(embryo.OrbitSpeed, 0)
			entity.TargetPosition = entity.TargetPosition + add

			-- Set the position
			local targetOffset = Vector.FromAngle(entity.TargetPosition.X):Resized(embryo.OrbitDistance)
			local pos = entity.Parent.Position + targetOffset
			entity.Velocity = (pos - entity.Position) / 3 * 2
		end


		-- Disable default AI
		if entity.FrameCount > 1 then
			return true
		end
	end
end

function embryo:DMG(entity, damageAmount, damageFlags, damageSource, damageCountdownFrames)
	if entity.SubType == mod.FF.Blastulation.Guillotine.SubTypes.Head then
		return false
	end
end