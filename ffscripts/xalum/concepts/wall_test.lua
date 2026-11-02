local mod = FiendFolio
local game = Game()

local FLAGS = EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK
local targetTile = 7
local targetTile2 = 52 --127

--[[mod:AddCallback(ModCallbacks.MC_USE_ITEM, function()
	if targetTile == 7 then
		targetTile = 82
		targetTile2 = 127
	else
		targetTile = 7
		targetTile2 = 52
	end
end)]]

mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, npc)
	if npc.Variant == 311 then
		local room = game:GetRoom()
		local topleft = room:GetTopLeftPos()
		local bottomright = room:GetBottomRightPos()
		local centrepos = room:GetCenterPos()

		npc.Position = Vector(centrepos.X, topleft.Y - 128)
		npc.SpriteOffset = Vector(0, 83)
		npc.SortingLayer = SortingLayer.SORTING_DOOR
		npc.DepthOffset = -10000
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
		npc:AddEntityFlags(FLAGS)

		if npc.SubType == 1 then
			npc.Position = Vector(centrepos.X, bottomright.Y + 128)
			print(npc.Position.Y)
			npc.SpriteRotation = 180
			npc.SpriteOffset = Vector(0, -83)
		end
	end
end, 180)

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc) -- I LOVE HARDCODING I LOVE HARDCODING
	if npc.Variant == 311 then
		local targetTile = npc.SubType == 0 and targetTile or targetTile2
		if npc.SubType == 0 then
			y = 12 + 40 * (targetTile // 15)
		elseif npc.SubType == 1 then
			y = 548 - 40 * ((134-targetTile) // 15)
		end

		local targetPosition = Vector(room:GetCenterPos().X, y)
		
		-- print(npc.SubType, y, targetTile)
		-- print(npc.Position)

		targetPosition = mod.XalumLerp(npc.Position, targetPosition, 0.2)
		npc.Velocity = targetPosition - npc.Position
	end
end, 180)