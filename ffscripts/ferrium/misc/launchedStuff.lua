local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

function mod:LaunchedEnemyRender(npc)
	local data = mod:GetEntityData(npc)
	if data.launchedEnemyInfo and npc:GetPauseTime() <= 0 then
		local tab = data.launchedEnemyInfo
		if mod:IsNormalRender(false) then
			tab.zVel = tab.zVel or 0
			tab.frames = tab.frames or 0
			tab.accel = tab.accel or 0.3
			if tab.extraFunc then
				tab.extraFunc(npc, tab)
			end
			if tab.vel then
				npc.Velocity = tab.vel
			end

			if tab.pos then
				--Position Offset, not position.
				if tab.custom then
					tab.custom(npc, tab)
				else
					tab.height = tab.height or npc.PositionOffset.Y
					local offset = tab.height+tab.zVel+tab.accel/2
					npc.PositionOffset = Vector(0, offset)
					tab.height = offset
					tab.zVel = tab.zVel + tab.accel
					
					if npc.PositionOffset.Y > 0 then
						data.launchedEnemyInfo = nil
						data.launchedEnemyLanded = true
						if tab.landFunc then
							tab.landFunc(npc, tab)
						end
						npc.PositionOffset = Vector(npc.PositionOffset.X, 0)
					end
					if tab.collision then
						if npc.PositionOffset.Y < tab.collision then
							npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
							npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
						else
							npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
							if data.playerobjectscoll then
								npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
							else
								npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
							end
						end
					end
				end
			else
				if tab.custom then
					tab.custom(npc, tab)
				else
					tab.height = tab.height or npc.SpriteOffset.Y
					local offset = tab.height+tab.zVel+tab.accel/2
					npc.SpriteOffset = Vector(0, offset)
					tab.height = offset
					tab.zVel = tab.zVel + tab.accel
					
					if npc.SpriteOffset.Y > 0 then
						data.launchedEnemyInfo = nil
						data.launchedEnemyLanded = true
						if tab.landFunc then
							tab.landFunc(npc, tab)
						end
						npc.SpriteOffset = Vector(npc.SpriteOffset.X, 0)
					end
					if tab.collision then
						if npc.SpriteOffset.Y < tab.collision then
							npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
							npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
						else
							npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
							if data.playerobjectscoll then
								npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
							else
								npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
							end
						end
					end
				end
			end
		end
	end
	if data.followParentInfo then
		local tab = data.followParentInfo
		if mod:IsNormalRender(false) then
			if not tab.init then
				tab.init = true
				tab.recordParent = {}
			end
			tab.max = tab.max or 10
			tab.min = tab.min or 2
			tab.parent = tab.parent or npc.Parent
			
			if tab.specialFunc then
				tab.specialFunc(npc, tab)
			end
			
			if tab.parent and tab.parent:Exists() then
				table.insert(tab.recordParent, {position = tab.parent.Position, velocity = tab.parent.Velocity})
				if #tab.recordParent > tab.max then
					table.remove(tab.recordParent, 1)
				end

				if #tab.recordParent > tab.min then
					npc.Position = tab.recordParent[tab.min-1].position
					npc.Velocity = tab.recordParent[tab.min-1].velocity
				end
			else
				data.followParentInfo = nil
				data.followParentStopped = true
			end
		end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, function(_, npc)
	mod:LaunchedEffectRender(npc)
end, 16)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, function(_, npc)
	if npc.SubType == mod.FF.Dogboard.Sub then
		mod:LaunchedEffectRender(npc)
	end
end, mod.FF.Dogboard.Var)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, function(_, npc)
	if npc.SubType == mod.FF.LunksackNeedle.Sub then
		mod:LaunchedEffectRender(npc)
	end
end, mod.FF.LunksackNeedle.Var)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, function(_, npc)
	if npc.SubType == mod.FF.FriendCasing.Sub then
		mod:LaunchedEffectRender(npc)
	end
end, mod.FF.FriendCasing.Var)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_RENDER, function(_, npc)
	mod:LaunchedEffectRender(npc)
end, 10)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_RENDER, function(_, npc)
	mod:LaunchedEffectRender(npc)
end, 20)

function mod:LaunchedEffectRender(npc)
	local data = mod:GetEntityData(npc)
	if data.launchedEnemyInfo then
		local tab = data.launchedEnemyInfo
		if mod:IsNormalRender(false) then
			tab.zVel = tab.zVel or 0
			tab.frames = tab.frames or 0
			tab.accel = tab.accel or 0.3
			if tab.extraFunc then
				tab.extraFunc(npc, tab)
			end

			if tab.vel then
				npc.Velocity = tab.vel
			end
			
			if tab.pos then
				--Position Offset, not position.
				if tab.custom then
					tab.custom(npc, tab)
				else
					tab.height = tab.height or npc.PositionOffset.Y
					local offset = tab.height+tab.zVel+tab.accel/2
					npc.PositionOffset = Vector(0, offset)
					tab.height = offset
					tab.zVel = tab.zVel + tab.accel
					
					if npc.PositionOffset.Y > 0 then
						data.launchedEnemyInfo = nil
						data.launchedEnemyLanded = true
						if tab.landFunc then
							tab.landFunc(npc, tab)
						end
					end
					if tab.collision then
						if npc.PositionOffset.Y < tab.collision then
							npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
							npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
						else
							npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
							npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
						end
					end
				end
			else
				if tab.custom then
					tab.custom(npc, tab)
				else
					tab.height = tab.height or npc.SpriteOffset.Y
					local offset = tab.height+tab.zVel+tab.accel/2
					npc.SpriteOffset = Vector(0, offset)
					tab.height = offset
					tab.zVel = tab.zVel + tab.accel
					
					if npc.SpriteOffset.Y > 0 then
						data.launchedEnemyInfo = nil
						data.launchedEnemyLanded = true
						if tab.landFunc then
							tab.landFunc(npc, tab)
						end
					end
					if tab.collision then
						if npc.SpriteOffset.Y < tab.collision then
							npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
							npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
						else
							npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
							npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
						end
					end
				end
			end
		end
	end
end

function mod:marioMode(player)
	local data = mod:GetEntityData(player)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_HOW_TO_JUMP) then
		if not data.launchedEnemyInfo then
			local customFunc = function(npc, tab)
				tab.height = tab.height or npc.SpriteOffset.Y
				local offset = tab.height+tab.zVel+tab.accel/2
				npc.SpriteOffset = Vector(0, offset)
				tab.height = offset
				tab.zVel = tab.zVel + tab.accel
					
				if npc.SpriteOffset.Y > 0 then
					data.launchedEnemyInfo = nil
					data.launchedEnemyLanded = true
				end
				if tab.collision then
					if npc.SpriteOffset.Y > tab.collision-5 then
						local jumpman
						for _,enemy in ipairs(Isaac.FindInRadius(npc.Position, 40, EntityPartition.ENEMY)) do
							if enemy:IsActiveEnemy() and (not mod:isFriend(enemy)) then
								jumpman = true
								enemy:TakeDamage(player.Damage, 0, EntityRef(npc), 0)
							end
						end
						if jumpman == true then
							if not tab.oneup then
								tab.oneup = 0
							end
							tab.oneup = tab.oneup+1
							if tab.oneup == 11 then
								Isaac.Spawn(5, 100, 11, game:GetRoom():FindFreePickupSpawnPosition(npc.Position, 40, true, false), Vector.Zero, nil)
							end
							tab.zVel = -4
							sfx:Play(mod.Sounds.BingBingWahoo, 0.3, 0, false, 1)
						end
					end
				
					if npc.SpriteOffset.Y < tab.collision then
						npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
						npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
					else
						npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
						npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
						tab.oneup = 0
					end
				end
			end
		
			data.launchedEnemyInfo = {zVel = -6, collision = -10, custom = customFunc}
			sfx:Play(mod.Sounds.BingBingWahoo, 0.3, 0, false, 1)
		end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.LaunchedEnemyRender, EntityType.ENTITY_MAGGOT)
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.LaunchedEnemyRender, mod.FF.Gishle.ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.LaunchedEnemyRender, mod.FF.CorruptedContusion.ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.LaunchedEnemyRender, mod.FF.TomaChunk.ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.LaunchedEnemyRender, mod.FF.CongaSkuzz.ID)
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.LaunchedEnemyRender, EntityType.ENTITY_ROCK_SPIDER)
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.LaunchedEnemyRender, EntityType.ENTITY_FIREPLACE)
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.LaunchedEnemyRender, EntityType.ENTITY_DIP)
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.LaunchedEnemyRender, mod.FF.CoalscoopCoal.ID)