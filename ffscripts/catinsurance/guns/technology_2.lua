local mod = FiendFolio

local directionToVector = {
	[Direction.UP] = Vector(0, -1),
	[Direction.DOWN] = Vector(0, 1),
	[Direction.LEFT] = Vector(-1, 0),
	[Direction.RIGHT] = Vector(1, 0),
}

---@param player EntityPlayer
function mod:FriendHandleTech(player)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY_2) and mod:IsAnyFriend(player) then
		local pData = mod:GetEntityData(player)
		local headDirection = player:GetHeadDirection()
		local laser = pData.FriendTech2
        local attackDirection = mod:SnapVector(player:GetAimDirection(), 90)
        local isShooting = player:CanTurnHead() and player:GetFireDirection() ~= Direction.NO_DIRECTION

		if not laser and isShooting then
			pData.FriendTech2 = player:FireTechLaser(player.Position, LaserOffset.LASER_TECH1_OFFSET, directionToVector[headDirection], false, true, player, 0.13):ToLaser()
			pData.FriendTech2:SetOneHit(false)
			pData.FriendTech2:SetTimeout(10)
		end

		if laser then
			if laser:Exists() and isShooting then

				if headDirection == Direction.UP or headDirection == Direction.LEFT then
					laser.DepthOffset = player.DepthOffset - 5
				else
					laser.DepthOffset = player.DepthOffset + 5
				end

				if headDirection == Direction.UP then
					laser.Position = player.Position - Vector(-10, 0) - Vector(0, player.SpriteScale.Y)
				elseif headDirection == Direction.DOWN then
					laser.Position = player.Position - Vector(10, 0) + Vector(0, player.SpriteScale.Y)
				elseif headDirection == Direction.LEFT then
					laser.Position = player.Position - Vector(10, 0) - Vector(player.SpriteScale.X, 0)
				elseif headDirection == Direction.RIGHT then
					laser.Position = player.Position - Vector(-10, 0) + Vector(player.SpriteScale.X, 0)
				end

				laser:SetTimeout(10)
				laser.Angle = attackDirection:GetAngleDegrees()
			else
				laser:SetTimeout(2)
				pData.FriendTech2 = nil
			end
		end
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, CollectibleType.COLLECTIBLE_TECHNOLOGY_2, mod.FriendHandleTech)