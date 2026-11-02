local mod = FiendFolio



-- Looping animation
---@param sprite Sprite
---@param anim string
---@param dontReset boolean? Default is `false`.
function FiendFolio:LoopingAnim(sprite, anim, dontReset)
	if not sprite:IsPlaying(anim) then
		if dontReset then
			sprite:SetAnimation(anim, false)
		else
			sprite:Play(anim, true)
		end
	end
end

-- Looping overlay
---@param sprite Sprite
---@param anim string
---@param priority boolean? Default is `false`.
function FiendFolio:LoopingOverlay(sprite, anim, priority)
	if not sprite:IsOverlayPlaying(anim) then
		if priority then
			sprite:SetOverlayRenderPriority(priority)
		end
		sprite:PlayOverlay(anim, true)
	end
end



-- Flip towards the entity's movement
---@param entity Entity
---@param sprite Sprite
---@param otherWay boolean? Usually, if moving towards the left, the entity will get `FlipX` set to true. Set this to `true` for the opposite of that. Defaults to `false`.
function FiendFolio:FlipTowardsMovement(entity, sprite, otherWay)
	sprite.FlipX = (otherWay ~= true and entity.Velocity.X < 0)
				or (otherWay == true and entity.Velocity.X > 0)
end

-- Flip towards the entity's target
---@param entity Entity
---@param sprite Sprite
---@param otherWay boolean? Usually, if moving towards the left, the entity will get `FlipX` set to true. Set this to `true` for the opposite of that. Defaults to `false`.
function FiendFolio:FlipTowardsTarget(entity, sprite, otherWay)
	local target = entity:ToNPC() and entity:GetPlayerTarget() or entity.Target

	sprite.FlipX = (otherWay ~= true and target.Position.X < entity.Position.X)
				or (otherWay == true and target.Position.X > entity.Position.X)
end