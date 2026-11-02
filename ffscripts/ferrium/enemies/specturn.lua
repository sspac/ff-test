local mod = FiendFolio
local game = Game()

function mod:specturnAI(npc)
	local sprite = npc:GetSprite()
	local d = mod:GetEntityData(npc)
	local room = game:GetRoom()
	
	if not d.init then
		if (npc.SubType & 1) == 0 then
			d.invuln = true
		else
			d.invuln = false
		end
		if (npc.SubType >> 1 & 1) == 1 then
			d.deathSpawn = false
		else
			d.deathSpawn = true
		end
		local searchNum = (npc.SubType >> 8 & 7)
		if searchNum == 0 then
			d.searchPos = npc.Position
		else
			d.searchPos = npc.Position+Vector(40,0):Rotated(-90+90*searchNum)
		end
		d.rotDir = (npc.SubType >> 7 & 1)
		npc.SplatColor = mod.ColorGhostly
		sprite:Play("Appear")
		d.init = true
	end
	npc:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET)
	npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
	
	if not d.found then
        local newparent = mod:getNearestSpecturnTargets(d.searchPos, 1, 0)[1]
        if newparent then
			local distance = (npc.SubType >> 11 & 15)*20
            npc.Parent = newparent
			local pData = mod:GetEntityData(newparent)
			if pData.specturnChildren == nil then
				pData.specturnChildren = {}
			end
            d.vec = (npc.Position - npc.Parent.Position):Resized(35)
            d.found = true
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            --npc.PositionOffset = Vector(0, (-13 / 26) * 40)
            npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET)
			npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			mod:GetEntityData(newparent).isSpecturnCenter = true
			local num = #pData.specturnChildren+1
			
			
			local targets = mod:getNearestSpecturnTargets(newparent.Position, (npc.SubType >> 2 & 31), 1)
			if #targets > 0 then
				table.insert(pData.specturnChildren, num, {})
			end
			for i=1,#targets do
				local target = targets[i]
				local targetData = mod:GetEntityData(target)
				
				table.insert(pData.specturnChildren[num], i, target)
				targetData.specturnCount = #targets
				targetData.specturnPosition = i
				targetData.specturnRing = num
				
				--target:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				targetData.isSpecturned = true
				--[[local newTarget = Isaac.Spawn(target.Type, target.Variant, target.SubType, npc.Position, Vector.Zero, newparent):ToNPC()
				target:Remove()]]
				
				mod:makeEnemyEternal(target, newparent, (100/#targets)*i, distance, d.invuln, d.deathSpawn, 20, 1, d.rotDir)
				--mod:makeEnemyEternal(newTarget, newparent, 50, 50, true, true, 20, 1, 1)
			end
        else
            sprite:Play("Death")
        end
    end

	if sprite:IsFinished("Appear") then
		if d.rotDir == 1 then
			sprite:Play("IdleReverse")
		else
			sprite:Play("Idle")
		end
	elseif sprite:IsFinished("Death") then
		npc:Remove()
	end

    if npc.Parent then
		local targpos = npc.Parent.Position + d.vec
		local targvec = (targpos - npc.Position)
		local targvel = targvec:Resized(npc.Position:Distance(targpos))
		npc.Velocity = mod:Lerp(npc.Velocity, targvel, 1)
		--npc.Position = targpos

		d.vec = d.vec:Rotated(3-6*d.rotDir)
    else
		npc.Velocity = npc.Velocity * 0.6
        sprite:Play("Death")
    end
end

--[[function mod:eternalFuckery(npc)
	local data = mod:GetEntityData(npc)
	if npc.SubType == 114 then
		if not data.init then
			data.isSpecturned = true
			data.specturnChildren = {}
			table.insert(data.specturnChildren, 1, {})
			data.init = true
			for i=1,3 do
				local test
				if i == 1 then
					test = Isaac.Spawn(150, 0, 0, npc.Position, Vector.Zero, npc):ToNPC()
				elseif i == 2 then
					test = Isaac.Spawn(150, 0, 1, npc.Position, Vector.Zero, npc):ToNPC()
				elseif i == 3 then
					test = Isaac.Spawn(150, 1, 2, npc.Position, Vector.Zero, npc):ToNPC()
				end
				
				table.insert(data.specturnChildren[1], i, test)
				local targetData = mod:GetEntityData(test)
				targetData.specturnCount = 3
				targetData.specturnPosition = i
				targetData.specturnRing = 1
				targetData.isSpecturned = true
				
				mod:makeEnemyEternal(test, npc, (100/3)*i, 70, false, true, 20, 0.5, 1)
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.eternalFuckery, 212)]]

function mod:isSpecturnBlacklist(entity)
	return mod.specturnBlacklist[entity.Type] or
	       mod.specturnBlacklist[entity.Type .. " " .. entity.Variant] or
	       mod.specturnBlacklist[entity.Type .. " " .. entity.Variant .. " " .. entity.SubType]
end

function mod:getNearestSpecturnTargets(position, numTargets, mode)
	local targets = {}
	local targetDists = {}
	
	if mode == 0 then
		local radius = 99999
		local target = nil
		for _, entity in ipairs(Isaac.GetRoomEntities()) do
			if mod:isFriend(entity) or (not mod:isCurseOfTheGateKeySpawner(entity) and (mod:isSpecturnBlacklist2(entity) or entity.Type >= 999 or entity.Type < 10)) then
			else
				if mod:isCurseOfTheGateKeySpawner(entity) then
					if not entity.Child then
						local key = Isaac.Spawn(EntityType.ENTITY_PICKUP, FiendFolio.PICKUP.VARIANT.GATECURSE_KEY, 0, entity.Position, Vector(0,0), entity):ToPickup()
						key.Parent = entity
						entity.Child = key
					end
					entity = entity.Child
				end
				
				local distance = position:Distance(entity.Position)
				if distance < radius then
					radius = distance
					target = entity
				end
			end
		end
		table.insert(targets, target)
	elseif mode == 1 then
		for _, entity in ipairs(Isaac.GetRoomEntities()) do
			local dist = position:Distance(entity.Position)
			if (not mod:isCurseOfTheGateKeySpawner(entity) and (entity.Type < 10 or entity.Type >= 999 or mod:isSpecturnBlacklist(entity))) or (not entity:Exists()) or mod:isFriend(entity) or mod:GetEntityData(entity).isSpecturned or mod:GetEntityData(entity).isSpecturnCenter then
				--do nothing
			else
				if mod:isCurseOfTheGateKeySpawner(entity) then
					if not entity.Child then
						local key = Isaac.Spawn(EntityType.ENTITY_PICKUP, FiendFolio.PICKUP.VARIANT.GATECURSE_KEY, 0, entity.Position, Vector.Zero, entity):ToPickup()
						key.Parent = entity
						entity.Child = key
					end
					entity = entity.Child
				end
				
				for i = 1, numTargets do
					if not targets[i] or dist <= targetDists[i] then
						table.insert(targets, i, entity)
						table.insert(targetDists, i, dist)
						break
					end
				end
			end
		end
	end

	while #targets > numTargets do
		table.remove(targets)
	end

	return targets
end

function mod:isSpecturnBlacklist2(entity)
	return mod.specturnBlacklist2[entity.Type] or
	       mod.specturnBlacklist2[entity.Type .. " " .. entity.Variant] or
	       mod.specturnBlacklist2[entity.Type .. " " .. entity.Variant .. " " .. entity.SubType]
end

function mod:recalculateSpecturnOrbits(npcTable) --look, I'm just not even going to bother changing the names or anything
	local wires = {}

	local initialoffset
	for _, wire in pairs(npcTable) do
		if wire:Exists() and not (wire:IsDead() or mod:isStatusCorpse(wire) or mod:isLeavingStatusCorpse(wire)) then
			local wireD = mod:GetEntityData(wire)
			if wireD.Parent ~= nil then
				if #wires < 1 then
					table.insert(wires, wire)
				else
					for i = 1, #wires do
						if wireD.madeEternalOffset < mod:GetEntityData(wires[i]).madeEternalOffset then
							table.insert(wires, i, wire)
							break
						end
					end
					if wireD.madeEternalOffset > mod:GetEntityData(wires[#wires]).madeEternalOffset then
						table.insert(wires, wire)
					end
				end
			end
		end
	end

	if #wires > 0 then
		local initialoffset = mod:GetEntityData(wires[1]).madeEternalOffset
		local divnum = #wires

		for i = 1, divnum do
			mod:GetEntityData(wires[i]).madeEternalChangePlaces = initialoffset + (100/divnum) * (i - 1)
		end
	end
end

function mod:madeEternalEnemies(entry, key)
	local npc = entry.npc
	local d = mod:GetEntityData(npc)
	if d.madeEternalParent and mod:superExists(d.madeEternalParent) then
		local childReal = true
		local checkChildren
		if mod:GetEntityData(d.madeEternalParent).specturnChildren == nil then
			childReal = false
		else
			checkChildren = mod:GetEntityData(d.madeEternalParent).specturnChildren[d.specturnRing]
		end
		--[[local realLength = 0 --Okay, for some reason the length of the table is ignoring some when it's nil.
		for i = 1,#checkChildren do
			if checkChildren[i] ~= nil then
				realLength = realLength+1
			end
		end]]
		
		--[[if realLength ~= d.specturnCount then
			if realLength > 1 then
				for i=1,realLength do
					if i < d.specturnCount then
						if checkChildren[i] == nil then
							print(i .. " " .. d.specturnPosition)
							checkChildren[i] = npc
							checkChildren[d.specturnPosition] = nil
							d.specturnPosition = i
						end
					end
				end
				d.madeEternalChangePlaces = d.madeEternalOffset+(100/realLength)*d.specturnPosition
				--d.madeEternalOffset = (100/realLength)*d.specturnPosition
			end
			d.specturnCount = realLength
		end]]
		
		--npc:SetColor(Color(1-(1/d.specturnCount)*d.specturnPosition, 1-(1/d.specturnCount)*d.specturnPosition, 1-(1/d.specturnCount)*d.specturnPosition,1,50 / 255,50 / 255,50 / 255),15,1,true,false)
	
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
		
		if d.madeEternalInvuln == true then
			npc:SetColor(Color(1.5,1.5,1.5,1,50 / 255,50 / 255,50 / 255),5,1,false,false)
			if mod.CanIComeOutYet() then
				d.isSpecturnInvuln = false
				npc.Color:Reset()
				d.madeEternalInvuln = false
			end
		end
		local target = d.madeEternalParent.Position
		local frame = d.madeEternalOffset+(npc.FrameCount-2*npc.FrameCount*d.madeEternalDirection)
		
		if d.madeEternalChangePlaces ~= nil then
			d.madeEternalOffset = mod:Lerp(d.madeEternalOffset, d.madeEternalChangePlaces, 0.1)
			if math.abs(d.madeEternalOffset-d.madeEternalChangePlaces) < 1 then
				d.madeEternalOffset = d.madeEternalChangePlaces
				d.madeEternalChangePlaces = nil
			end
		end
		
		local distance = math.min(d.madeEternalInitialOffset+(npc.FrameCount)/3, d.madeEternalDistance)

		local xvel = math.cos((frame / 16) + math.pi) * (distance) * (d.madeEternalSpeed)
		local yvel = math.sin((frame / 16) + math.pi) * (distance) * (d.madeEternalSpeed)
		
		local pos = Vector(target.X - xvel, target.Y - yvel)

		local direction = Vector(target.X - xvel, target.Y - yvel) - npc.Position

		if direction:Length() > 50 then
			direction:Resize(50)
		end
		
		npc.Position = mod:Lerp(npc.Position, pos, 0.6)
		--npc.Velocity = direction
		npc.Velocity = mod:Lerp(npc.Velocity, direction, 0.6)
		
		if not d.madeEternalAppear and npc.FrameCount > 1 then
			local poof = Isaac.Spawn(1000, 15, 0, npc.Position, Vector.Zero, npc):ToEffect()
			poof:FollowParent(npc)
			poof.DepthOffset = npc.DepthOffset+1
			npc.Visible = true
			d.madeEternalAppear = true
		end
		
		if npc:IsDead() or mod:isLeavingStatusCorpse(npc) then
			if childReal == true then
				mod:recalculateSpecturnOrbits(checkChildren)
			end
			--checkChildren[d.specturnPosition] = nil
			d.madeEternalParent = nil
		end
	else
		if d.madeEternalSpawn == true then
			npc.Color:Reset()
			d.madeEternalParent = nil
			npc:ClearEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET)
			npc.EntityCollisionClass = d.madeEternalEntColl
			npc.GridCollisionClass = d.madeEternalGridColl
		else
			npc:Kill()
		end
		d.isSpecturnInvuln = false
		d.imEternal = false
		mod.madeEternal[key] = nil
	end
end

function mod:makeEnemyEternal(npc, target, rotation, distance, makeInvuln, deathSpawn, initialOffset, speed, direction)
	local rand = npc:GetDropRNG()
	local data = mod:GetEntityData(npc)
	if makeInvuln == nil or makeInvuln == true then
		npc:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET)
		makeInvuln = true
		data.isSpecturnInvuln = true
	end
	if deathSpawn == nil then
		deathSpawn = true
	end
	if initialOffset == nil then
		initialOffset = 0
	end
	data.madeEternalEntColl = npc.EntityCollisionClass
	data.madeEternalGridColl = npc.GridCollisionClass
	if npc.Type == EntityType.ENTITY_THE_HAUNT and npc.Variant == 10 then --Little haunts are annoying cause of how they spawn
		data.madeEternalEntColl = EntityCollisionClass.ENTCOLL_ALL
	end
	npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
	npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
	--npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	--npc.Parent = target
	data.madeEternalParent = target
	data.madeEternalRotation = rotation or rand:RandomInt(75)
	data.madeEternalDistance = distance or 50
	data.madeEternalInitialOffset = initialOffset or 0
	data.madeEternalOffset = data.madeEternalRotation
	data.madeEternalDirection = direction or 0
	data.madeEternalSpeed = speed or 1
	data.madeEternalInvuln = makeInvuln
	data.madeEternalSpawn = deathSpawn
	data.imEternal = false
	data.removePoof = true
	npc.Visible = false
	
	--[[for _, poof in ipairs(Isaac.FindByType(1000, 15, -1, false, false)) do
		if poof.SpawnerType == npc.Type and poof.SpawnerVariant == npc.Variant and poof.Position:Distance(npc.Position) < 20 and poof.FrameCount < 2 then
			poof:Remove()
		end
	end]]
	
	table.insert(mod.madeEternal, {["npc"] = npc, ["target"] = target})
end