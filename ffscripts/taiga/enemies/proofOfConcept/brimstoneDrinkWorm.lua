-- brimstone drink worm proof-of-concept --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

function mod:brimstoneDrinkWormAI(npc, sprite, npcdata)
	if not npcdata.init then
		npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
		npcdata.state = "idle"
		npcdata.idletimer = math.random(15, 30)
		npcdata.burrowedtimer = 0
		npcdata.init = true
		npcdata.firstdig = false
		npcdata.burrowcheck = false
		npc.TargetPosition = npc.Position
	end
	npc.Position = npc.TargetPosition
	if not mod:InsideClodUpdate(npc, sprite, npcdata) then
		npc.Velocity = Vector.Zero
	end
	if npc.Child and not npc.Child:Exists() then
		npc.Child = nil
	end
	if npcdata.state == "idle" then
		if npcdata.idletimer > 0 then
			npcdata.idletimer = npcdata.idletimer - 1
			mod:spritePlay(sprite, "idle")
		else
			if npc.Child == nil then
				if npcdata.firstdig then
					mod:spritePlay(sprite, "diginspit")
				else
					mod:spritePlay(sprite, "diginspitless")
					npcdata.firstdig = true
					npcdata.extraVariableToFixABug = true
				end
				npcdata.state = "burrow"
			else
				npc:PlaySound(SoundEffect.SOUND_MAGGOTCHARGE,1,1,false,1.5)
				mod:spritePlay(sprite, "startsuckinboy")
				npcdata.state = "suck"
				if npc.Child then
					mod:GetEntityData(npc.Child).BeingSucked = true
				end
			end
		end
	elseif npcdata.state == "burrow" then
		if sprite:IsFinished("diginspit") or sprite:IsFinished("diginspitless") then
			npcdata.burrowedtimer = math.random(15,30)
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			mod:spritePlay(sprite, "burrowed")
		elseif sprite:IsFinished("digout") then
			mod:spritePlay(sprite, "idle")
			npcdata.idletimer = math.random(20, 40)
			npcdata.state = "idle"
		elseif not (sprite:IsPlaying("diginspit") or sprite:IsPlaying("digout") or sprite:IsPlaying("diginspitless")) then
			if npcdata.burrowedtimer <= 0 then
				mod:spritePlay(sprite, "digout")
				npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
				if npcdata.extraVariableToFixABug then
					local filter = function(ent) return not mod:GetEntityData(ent).WormClaimed end
					if not mod:TryEnterClod(npc, sprite, npcdata, filter) then
						npc.TargetPosition = mod:FindRandomValidPathPosition(npc, 2, 120)
						npcdata.extraVariableToFixABug = false
					end
				else
					local filter 
					if npc.Child and npc.Child:Exists() then
						filter = function(ent) 
							if npc.Child ~= nil then
								return game:GetRoom():CheckLine(ent.Position,npc.Child.Position,3) and not mod:GetEntityData(ent).WormClaimed
							else
								return not mod:GetEntityData(ent).WormClaimed
							end
						end
					else
						filter = function(ent) return not mod:GetEntityData(ent).WormClaimed end
					end
					if not mod:TryEnterClod(npc, sprite, npcdata, filter) then
						npc.TargetPosition = mod:brimstonedrinkwormfindpos(npc, npcdata)
					end
				end
				if npc.Child ~= nil then
					if sprite.FlipX and npc.Child.Position.X < npc.Position.X then
						sprite.FlipX = false
					elseif npc.Child.Position.X > npc.Position.X then
						sprite.FlipX = true
					end
				end
			else
				npcdata.burrowcheck = true
				npcdata.burrowedtimer = npcdata.burrowedtimer - 1
				for _, i in ipairs(Isaac.FindByType(666, 100, -1, false, false)) do
					if npcdata.burrowedtimer == mod:GetEntityData(i).burrowedtimer and GetPtrHash(i) ~= GetPtrHash(npc) and npcdata.burrowcheck == false then
						npcdata.burrowedtimer = npcdata.burrowedtimer + math.random(1, 3)
						--print(npcdata.burrowedtimer)
						--print(mod:GetEntityData(i).burrowedtimer)
					end
				end
				npcdata.burrowcheck = false
			end
		end
	elseif npcdata.state == "suck" then
		if sprite:IsFinished("startsuckinboy") then
			mod:spritePlay(sprite, "suck")
		elseif sprite:IsFinished("stopsuck") then
			mod:spritePlay(sprite, "idle")
			npcdata.idletimer = math.random(30, 45)
			npcdata.state = "idle"
		elseif sprite:IsFinished("catchbullet") then
			mod:spritePlay(sprite, "diginspit")
			npcdata.state = "burrow"
		elseif npc.Child == nil and not sprite:IsPlaying("catchbullet") then
			mod:spritePlay(sprite, "catchbullet")
			npc:PlaySound(SoundEffect.SOUND_LITTLE_SPIT,0.75,0,false,3)
		--elseif not sprite:IsPlaying("catchbullet") then
		--	mod:spritePlay(sprite, "stopsuck")
		end
	end

	if sprite:IsEventTriggered("spit") then
		npc:PlaySound(SoundEffect.SOUND_PLOP,1,1,false,2)
		
		local ball = Isaac.Spawn(120, 237, 1, npc.Position, Vector(0,0), npc)
		npc.Child = ball
		ball.Parent = npc
		mod:GetEntityData(ball).LastParentPosition = Vector(npc.Position.X, npc.Position.Y)
		ball:Update()
	end
end

function mod:brimstonedrinkwormfindpos(npc, npcdata)
	local room = game:GetRoom()
	local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local vptablelength = 1
	local validpositions = {}
	local size = room:GetGridSize()
	for i = 0, size do
		local grident = room:GetGridEntity(i)
		if ((not gridEntity) or (room:GetGridCollision(i) == GridCollisionClass.COLLISION_NONE and (gridEntity:GetType() ~= GridEntityType.GRID_SPIKES and gridEntity:GetType() ~ GridEntityType.GRID_SPIKES_ONOFF) or gridEntity:GetType() == GridEntityType.GRID_SPIDERWEB)) and room:IsPositionInRoom(room:GetGridPosition(i), 15) then
			if (mod:checkposdistancefroment(room:GetGridPosition(i), 1, -1, 100) 
			and mod:checkposdistancefroment(room:GetGridPosition(i), 666, 100, 40) 
			and (npc.Child == nil or (room:CheckLine(room:GetGridPosition(i),npc.Child.Position,3,1,false,false)) 
			and (room:GetGridPosition(i) - npc.Child.Position):Length() > 160)) 
			and not mod:IsCampfireWithinRadius(room:GetGridPosition(i), 40)
			then
				table.insert(validpositions, i)
				vptablelength = vptablelength + 1
			end
		end
	end
	if vptablelength == 1 then
		return npc.Position
	else
		return room:GetGridPosition(validpositions[math.random(1, vptablelength - 1)])
	end
end

function mod:brimstoneDrinkWormTakeDmg(npc, amount, flags, source, cooldown)
	if source.Type == 1000 and source.Variant == 71 then -- Player Brimstone Swirl
		local realSource = mod.XalumFindRealEntity(source)
		if realSource then
			source = {Type = realSource.SpawnerType, Variant = realSource.SpawnerVariant}
		end
	end

	if source.Type == 120 and source.Variant == 237 then
		return false
	end
end

-- Took this mostly from Madomme brimball thx Xalum
function mod:drinkWormBrimballAI(npc, sprite, npcdata)
	if npc:HasEntityFlags(EntityFlag.FLAG_APPEAR) then
		npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		sprite:Play("Appear", true)
	end

	if sprite:IsFinished("Appear") or sprite:IsFinished("Idle") then
		sprite:Play("Idle", true)
	elseif sprite:IsFinished("Disappear") then
		npc.Visible = false
	end
	
	npc.Velocity = Vector.Zero
	npc.SpriteOffset = Vector.Zero
	
	if npc.Parent and npc.Parent:Exists() then
		npcdata.LastParentPosition = Vector(npc.Parent.Position.X, npc.Parent.Position.Y)
	end

	if sprite:IsPlaying("Idle") and npcdata.BeingSucked then
		local targetAngle = (npc:GetPlayerTarget().Position - npc.Position):GetAngleDegrees()
		local laser = EntityLaser.ShootAngle(1, npc.Position, targetAngle, 15, Vector.Zero, npc.SpawnerEntity or npc)
		--laser:AddTearFlags(TearFlags.TEAR_WAIT)

		local poof = Isaac.Spawn(1000, 2, 5, npc.Position, Vector.Zero, npc):ToEffect()
		poof.SpriteScale = Vector.One * 2

		--[[local tracer = Isaac.Spawn(1000, 198, 0, npc.Position, Vector.Zero, npc):ToEffect()
        tracer.TargetPosition = Vector.FromAngle(targetAngle)
        tracer.LifeSpan = 33
        tracer.Timeout = 38
        tracer.SpriteScale = Vector(3, 0.0001)
        tracer.PositionOffset = Vector(0, 5)
        tracer.Color = Color(0.5, 0.2, 0, 0.8, 0, 0, 0)
        tracer:Update()]]--

		npcdata.laserParts = {Laser = laser}--, Tracer = tracer}

		sprite:Play("Disappear", true)
		sfx:Play(SoundEffect.SOUND_FAMINE_BURST, 1.5, 0, false, 0.8)
	end

	if npcdata.laserParts then
		if npcdata.laserParts.Laser:Exists() then
			local angle = npcdata.laserParts.Laser.AngleDegrees
			local targetAngle = (npcdata.LastParentPosition - npc.Position):GetAngleDegrees()
			npcdata.laserParts.Laser.AngleDegrees = targetAngle
			npcdata.laserParts.Laser.SpriteRotation = targetAngle - 90
			npcdata.laserParts.Laser.MaxDistance = (npcdata.LastParentPosition - npc.Position):Length()

			--[[if npcdata.laserParts.Tracer:Exists() then
				npcdata.laserParts.Tracer.TargetPosition = Vector.FromAngle(npcdata.laserParts.Laser.AngleDegrees)
			end]]--
		else
			npc:Remove()
		end
	end
end
