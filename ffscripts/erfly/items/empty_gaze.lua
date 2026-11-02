local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

function mod.emptyGazeChecker()
	if mod.anyPlayerHas(mod.ITEM.COLLECTIBLE.EMPTY_GAZE) then
		mod.EmptyGazeActive = true
	else
		mod.EmptyGazeActive = false
	end
end

function mod:emptyGazeHandler(npc)
	if mod.EmptyGazeActive then
		npc:AddEntityFlags(EntityFlag.FLAG_EXTRA_GORE)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.emptyGazeHandler)

local spawnedTears = {1,1,1,1,1,2,2,2,3}
local spawnedTearVars = {
	1,1,1,1,1,1,1,1,1,1,
	2,2,2,
	29,29,29,
	33,34,
	35,
}

function mod:emptyGazeDeath(npc)
	if mod.EmptyGazeActive then
		local rng = Isaac.GetPlayer():GetCollectibleRNG(mod.ITEM.COLLECTIBLE.EMPTY_GAZE)
		local spawnCount = spawnedTears[rng:RandomInt(#spawnedTears) + 1]
		local vec = Vector(1,0):Rotated(rng:RandomInt(360))
		local rot = 360 / spawnCount
		local randomVar = spawnedTearVars[rng:RandomInt(#spawnedTearVars) + 1]
		for i = 1, spawnCount do
			local uniqueVec = vec:Resized(mod:RandomInt(30,100)/10)
			local usedVec = uniqueVec:Rotated((rot * i) + mod:RandomInt(-45,45,rng))
			local tear = Isaac.Spawn(2,randomVar,0,npc.Position + usedVec,usedVec,nil):ToTear()
			tear.FallingAcceleration = 1
			tear.FallingSpeed = mod:RandomInt(-5,-10,rng)
			if randomVar == 2 then --Teeth
				tear.CollisionDamage = tear.CollisionDamage * 2
			elseif randomVar == 29 then --Bones
				tear:AddTearFlags(TearFlags.TEAR_QUADSPLIT)
			elseif randomVar == 33 or randomVar == 34 then --Eyeballs
				tear:AddTearFlags(TearFlags.TEAR_POP)
				if randomVar == 34 then --Bloody
					tear.CollisionDamage = tear.CollisionDamage * 1.1
				end
			elseif randomVar == 35 then --Bloody tears
				tear.CollisionDamage = tear.CollisionDamage * 1.5
				tear.Scale = 1.5
				tear:AddTearFlags(TearFlags.TEAR_BURSTSPLIT)
			end
		end
		local npcs = Isaac.FindInRadius(npc.Position, 100, EntityPartition.ENEMY)
		for _,other in ipairs(npcs) do
			local vec = (other.Position - npc.Position)
			local dist = vec:Length()
			vec = vec:Resized((100 - dist) * 0.33)
			other.Velocity = other.Velocity + vec
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.emptyGazeDeath)