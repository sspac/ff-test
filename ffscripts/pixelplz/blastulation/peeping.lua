local mod = FiendFolio

local embryo = {
	Variant = mod.FF.Blastulation.Peeping,
	Special = true,
}
mod:AddEmbryo(embryo)



-- Spawn the helper
function embryo:Update(entity)
	if not entity:IsDead()
	and (not entity.Child or not entity.Child:Exists()) then
		local helper = Isaac.Spawn(EntityType.ENTITY_PEEPER_FATTY, 0, mod.FF.Blastulation.PeepingCordHelper, entity.Position, Vector.Zero, entity)
		helper.Parent = entity
		entity.Child = helper
	end
end



-- Handle the cords
function mod:PeepingHelperInit(entity)
	if entity.Variant == 0 and entity.SubType == mod.FF.Blastulation.PeepingCordHelper then
		entity:AddEntityFlags(
			EntityFlag.FLAG_NO_TARGET |
			EntityFlag.FLAG_NO_STATUS_EFFECTS |
			EntityFlag.FLAG_HIDE_HP_BAR |
			EntityFlag.FLAG_NO_REWARD |
			EntityFlag.FLAG_NO_DEATH_TRIGGER |
			EntityFlag.FLAG_NO_QUERY
		)
		entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

		entity.Visible = false
		entity:GetSprite().PlaybackSpeed = 0
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.PeepingHelperInit, EntityType.ENTITY_PEEPER_FATTY)

function mod:PeepingHelperUpdate(entity)
	if entity.Variant == 0 and entity.SubType == mod.FF.Blastulation.PeepingCordHelper then
		-- Get removed if the parent is gone
		if not entity.Parent or not entity.Parent:Exists() or entity.Parent:IsDead() then
			entity:Remove()

		else
			-- Stay on top of the parent
			entity.Position = entity.Parent.Position
			entity.Velocity = Vector.Zero
			entity.DepthOffset = entity.Parent.DepthOffset + 10
			entity.State = embryo.Variant

			-- Copy the animation
			local helperSprite = entity:GetSprite()
			local parentSprite = entity.Parent:GetSprite()

			local anim = parentSprite.FlipX and "Walk Sad Mirrored" or "Walk Sad"
			helperSprite:SetAnimation(anim)
			helperSprite:SetFrame(parentSprite:GetFrame())
			helperSprite.FlipX = parentSprite.FlipX
		end
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.PeepingHelperUpdate, EntityType.ENTITY_PEEPER_FATTY)