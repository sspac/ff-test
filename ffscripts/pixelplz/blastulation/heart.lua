local mod = FiendFolio

local embryo = {
	Variant = mod.FF.Blastulation.Heart,
	Special = true,

	MoveSpeed = 3,
}
mod:AddEmbryo(embryo)



function embryo:Update(entity)
	local sprite = entity:GetSprite()

	-- Spawn with a Mask if friendly
	if entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and entity.FrameCount <= 1 and not entity.Child then
		local pos = Game():GetRoom():FindFreePickupSpawnPosition(entity.Position, 0, true)
		local mask = Isaac.Spawn(EntityType.ENTITY_MASK, 0, 0, pos, Vector.Zero, entity)
		mask.Parent = entity
		entity.Child = mask
	end

	-- Movement
	if sprite:WasEventTriggered("Landed") then
		entity.Velocity = mod:StopLerp(entity.Velocity)
	else
		mod:AvoidPlayerCool(entity, embryo.MoveSpeed, true)
		mod:FlipTowardsMovement(entity, sprite)
	end

	-- Landed
	if sprite:IsEventTriggered("Landed") then
		entity.Velocity = Vector.Zero
		mod:PlaySoundCool(nil, SoundEffect.SOUND_GOOATTACH0, 0.4, 1.05)
		entity:MakeSplat(0.75)
	end

	-- Disable default AI
	if entity.FrameCount > 1 then
		mod:LoopingAnim(sprite, "Walk Sad")
		return true
	end
end



-- Make Masks count them as a potential parent
function mod:MaskUpdate(entity)
	if entity.FrameCount <= 1 and not entity.Parent then
		for i, entry in pairs(Isaac.FindByType(EntityType.ENTITY_EMBRYO, embryo.Variant)) do
			if not entry.Child and not entry:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
				entity.Parent = entry
				entry.Child = entity
				break
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.MaskUpdate, EntityType.ENTITY_MASK)