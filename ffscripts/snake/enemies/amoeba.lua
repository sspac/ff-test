local mod = FiendFolio
local game = Game()
local nilvector = Vector.Zero

mod.diagDirections = {
	Vector(1,1),   -- down right
	Vector(1,-1),  -- top right
	Vector(-1,1),  -- down left
	Vector(-1,-1), -- top left
}

function mod:BlowEnemiesAway(pos, radius, strength, exceptType, restrictType)
	local exceptType = exceptType or -1
	local restrictType = restrictType or -1
	
	for _, ent in pairs(Isaac.FindInRadius(pos, radius, 0xffffffff)) do
		local isExcepted =        ent.Type == exceptType
		local isCorrectType =     ent.Type == restrictType or (ent:IsEnemy() or ent.Type == 1)
		local isKnockbackImmune = ent:HasEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
		
		if isCorrectType and not isExcepted and not isKnockbackImmune then
			local entityVec = (ent.Position - pos)
			ent.Velocity = ent.Velocity + entityVec:Resized(strength)
		end
	end
end

function mod:AmoebaPreCollision(npc, npc2, low)
	-- ignore all enemy collisions except from other amoebas
	if npc2.Type > 9 and npc2.Type ~= mod.FF.Amoeba.ID and npc2.Variant ~= mod.FF.Amoeba.Var then
		return true
	end
end

function mod:AmoebaHurt(npc, damage, flag, source)
	local d = mod:GetEntityData(npc)
	if d.state == "Puffed" then
		npc.HitPoints = npc.HitPoints + damage * 0.2
	end
end

function mod:AmoebaUpdate(npc)
	-- get stuff
	local d = mod:GetEntityData(npc)
	local sprite = npc:GetSprite()
	local rng = npc:GetDropRNG()
	
	-- variables for amoeba
	local speedNormal = 4
	local speedPuffed = 2.8
	local sizeNormal = 10
	local sizePuffed = 48
	local timeUnpuffed = 40
	local timePuffed = 30
	
	-- init
	if not d.init then
		local subt = npc.SubType
		local initialPuffState = (subt & 1 == 0) and "Normal" or "Puffed"
		if not d.setSplatColor then
			local color = Color(1,1,1,1,0.51,0.38,0.54)
			color:SetColorize(1,1,1,1)
			npc.SplatColor = color
			d.setSplatColor = true
		end

		local appearAnimName = "Appear" .. initialPuffState
		sprite:Play(appearAnimName)
		
		if sprite:IsFinished(appearAnimName) then
			npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
			d.speed = speedNormal
			
			-- start direction
			local dir = (subt >> 1 & 7)
			if dir == 0 then
				dir = rng:RandomInt(4)+1
			end
			npc.Velocity = Vector(1,0):
						   Rotated(-45 + 90 * dir):
						   Resized(d.speed)
			
			d.state = initialPuffState
			d.timer = (initialPuffState == "Normal") and 0 or -10
			d.init = true
		else
			return
		end
	end
	
	-- on death
	if npc:IsDead() then
		local poof = nil
		local color = nil
		
		if d.state == "Puffed" then
			mod:BlowEnemiesAway(npc.Position, 250, 12)

			color = Color(npc.SplatColor.R, npc.SplatColor.G, npc.SplatColor.B, 0.75, npc.SplatColor.RO * 1.25, npc.SplatColor.GO * 1.25, npc.SplatColor.BO * 1.25)
			poof = Isaac.Spawn(1000, 16, 5, npc.Position - Vector(0, 10), nilvector, npc)
		else
			color = Color(npc.SplatColor.R, npc.SplatColor.G, npc.SplatColor.B, 0.5, npc.SplatColor.RO, npc.SplatColor.GO, npc.SplatColor.BO)
			poof = Isaac.Spawn(1000, 16, 0, npc.Position - Vector(0, 10), nilvector, npc)
		end

		color:SetColorize(1,1,1,1)
		poof:GetSprite().Color = color
		poof:Update()
	end
	
	-- timer
	if d.timer then
		d.timer = d.timer + 1
	end
	
	-- normal
	if d.state == "Normal" then
		d.speed = speedNormal
		npc.Size = sizeNormal
		
		if d.timer > timeUnpuffed then
			sprite:Play("PuffUp")
			
			-- slow down before puffing
			if sprite:IsEventTriggered("Slow") then
				d.speed = d.speed * 0.6
			
			-- blow enemies away if theyre too close and increase size
			elseif sprite:IsEventTriggered("Burst") then
				mod:BlowEnemiesAway(npc.Position, 48, 6, npc.Type) -- blows other enemies away
				mod:BlowEnemiesAway(npc.Position, 68, 4, -1, npc.Type) -- blows other amoebas away
				npc.Size = sizePuffed
			
			-- puff
			elseif sprite:IsEventTriggered("Puff") then
				d.state = "Puffed"
				npc:PlaySound(mod.Sounds.Baloon, 1, 0, false, 4)
				d.timer = 0
			end
		elseif not sprite:IsPlaying("Deflate") then
			sprite:Play("Idle")
		end
	
	-- puffed up
	elseif d.state == "Puffed" then
		d.speed = speedPuffed
		npc.Size = sizePuffed
		
		if d.timer > timePuffed then
			sprite:Play("Deflate")
			
			if sprite:IsEventTriggered("Unpuff") then
				npc:PlaySound(mod.Sounds.BaloonBounce, 1, 0, false, 2)
				npc.Size = sizeNormal
				d.speed = speedNormal
				d.state = "Normal"
				d.timer = 0
			end
		elseif not sprite:IsPlaying("PuffUp") then
			sprite:Play("IdlePuffed")
		end
	end
	
	-- move diagonally
	local newVel = Vector(d.speed, d.speed)
	
	if npc.Velocity.X < 0 then
		newVel.X = newVel.X * -1
	end
	if npc.Velocity.Y < 0 then
		newVel.Y = newVel.Y * -1
	end
	
	if (math.abs(npc.Velocity.X) > d.speed) then
		npc.Velocity.X = npc.Velocity.X * 0.86
	end
	if (math.abs(npc.Velocity.Y) > d.speed) then
		npc.Velocity.Y = npc.Velocity.Y * 0.86
	end
	npc.Velocity = mod:Lerp(npc.Velocity, newVel, 0.08)
end