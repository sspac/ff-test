local mod = FiendFolio
local game = Game()
local nilvector = Vector.Zero

function mod:deadflyAI(npc)
	local sprite = npc:GetSprite()
	local d = mod:GetEntityData(npc)
	local target = npc:GetPlayerTarget()
	local r = npc:GetDropRNG()

	mod:beelzebubCheck(npc)

	if not d.init then
		d.state = "idle"
		d.init = true
		npc.SpriteOffset = Vector(0,-10)
		for i = 1, 3 do
			local eternalfriend = Isaac.Spawn(mod.FF.DeadFlyOrbital.ID, mod.FF.DeadFlyOrbital.Var, 0, npc.Position, nilvector, npc):ToNPC()
			eternalfriend.Parent = npc
			mod:GetEntityData(eternalfriend).rotval = (100 / 3) * i
			eternalfriend:Update()
		end
	else
		npc.StateFrame = npc.StateFrame + 1
	end

	if d.state == "idle" then
		mod:spritePlay(sprite, "Fly")
		d.target = d.target or mod:FindRandomFreePosAir(npc.Position, 150)
		if npc.StateFrame % 200 == 0 or (mod:isConfuse(npc) and npc.StateFrame % 20 == 0) then
			d.target = mod:FindRandomFreePosAir(npc.Position, 200)
		end
		local veccy = mod:reverseIfFear(npc, (d.target - npc.Position):Resized(3))
		npc.Velocity = mod:Lerp(npc.Velocity, veccy, 0.01)

		local distancech = target.Position:Distance(npc.Position)
		if (not mod:isScareOrConfuse(npc)) and (distancech < 120 or (npc.StateFrame > 30 and distancech < 130 and game:GetRoom():CheckLine(npc.Position, target.Position,3,1,false,false))) then
			d.state = "beginsicko"
		end
		if (not mod:isScareOrConfuse(npc)) and npc.StateFrame > 20 then
			if r:RandomInt(math.max(40 - (npc.StateFrame - 20), 2)) == 1 then
				d.state = "shoot"
			end
		end
	elseif d.state == "beginsicko" then
		npc.Velocity = npc.Velocity * 0.8
		if sprite:IsFinished("Fly2Start") then
			d.state = "sickomode"
			npc.StateFrame = 0
			npc.Velocity = (target.Position - npc.Position):Resized(8)
		elseif sprite:IsPlaying("Fly2Start") and sprite:GetFrame() == 6 then
			npc:PlaySound(mod.Sounds.ArcaneFizzle, 0.4, 0, false, 1.5)
		else
			mod:spritePlay(sprite, "Fly2Start")
		end
	elseif d.state == "sickomode" then
		mod:spritePlay(sprite, "Fly2")
		--Original shit movement
		--[[d.target = mod:FindRandomFreePosAir(npc.Position, 200)
		if npc.StateFrame % 60 == 0 or npc.Position:Distance(d.target) < 50 then
			d.target = mod:FindRandomFreePosAir(npc.Position, 200)
		end
		npc.Velocity = mod:Lerp(npc.Velocity, (d.target - npc.Position):Resized(15), 0.1)]]

		mod:diagonalMove(npc, 4)

		if npc.StateFrame % 5 == 0 then
			npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT,1,2,false,1)
			local params = ProjectileParams()
			params.BulletFlags = params.BulletFlags | ProjectileFlags.SMART
			npc:FireProjectiles(npc.Position, RandomVector()*7, 0, params)
		end
		if npc.StateFrame > 120 or mod:isScareOrConfuse(npc) then
			d.state = "endsicko"
		end
	elseif d.state == "endsicko" then
		npc.Velocity = npc.Velocity * 0.95
		if sprite:IsFinished("Fly1Start") then
			d.state = "idle"
			npc.StateFrame = 0
			d.target = nil
		elseif sprite:IsPlaying("Fly1Start") and sprite:GetFrame() == 5 then
			npc:PlaySound(mod.Sounds.GhostFizzle, 0.4, 0, false, 0.7)
		else
			mod:spritePlay(sprite, "Fly1Start")
		end
	elseif d.state == "shoot" then
		npc.Velocity = npc.Velocity * 0.95
		if sprite:IsFinished("Shoot") then
			d.state = "idle"
			npc.StateFrame = 0
			d.target = nil
		elseif sprite:IsEventTriggered("Shoot") then
			npc:PlaySound(mod.Sounds.MagicStrike,1.5,0,false,math.random()*0.5 + 1)
			local entity = mod.FindRandomEntityDeadfly()
			if entity then
				mod:GetEntityData(entity).eFlied = true
				--local eternalfriend = Isaac.Spawn(mod.FF.DeadFlyOrbital.ID, mod.FF.DeadFlyOrbital.Var, 1, npc.Position, nilvector, entity):ToNPC()
				local eternalfriend = mod.spawnent(npc, npc.Position, nilvector, mod.FF.DeadFlyOrbital.ID, mod.FF.DeadFlyOrbital.Var, 1):ToNPC()
				eternalfriend.Parent = entity
			else
				local vec = RandomVector()
				for i = 120, 360, 120 do
					local friend = mod.spawnent(npc, npc.Position + vec:Rotated(i):Resized(10), vec:Rotated(i):Resized(5), 18)
				end
			end
		else
			mod:spritePlay(sprite, "Shoot")
		end
	end
end

function mod:deadflyEternalFlyAI(npc)
	local sprite = npc:GetSprite()
	local d = mod:GetEntityData(npc)
	local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local subt = npc.SubType

	mod:beelzebubCheck(npc)

	if not d.init then
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
		npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		npc:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET)
		local rand = d.rotval or math.random(75)
		d.frameOffset = rand
		d.distance = d.distance or 50
		npc.StateFrame = 0
		npc.I1 = 0
		d.init = true
	end

	if sprite:IsFinished("TeleportIn") then
		d.AnimOverride = false
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
	end
	if d.AnimOverride then
		if sprite:IsPlaying("TeleportIn") or sprite:IsPlaying("TeleportOut") then
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		end
	else
		mod:spritePlay(sprite, "Fly")
	end

	if npc.Parent and not mod:isStatusCorpse(npc.Parent) then
		if mod:isFriend(npc.Parent) then
			npc:AddCharmed(EntityRef(npc.Parent), -1)
		end
		if subt == 1 then
			npc.Velocity = mod:Lerp(npc.Velocity, (npc.Parent.Position - npc.Position):Resized(4), 0.2)
			if npc.Parent.Position:Distance(npc.Position) < 40 then
				npc:Morph(mod.FF.DeadFlyOrbital.ID, mod.FF.DeadFlyOrbital.Var, 0, -1)
				npc.StateFrame = 0
			end
		else
			if d.AnimOverride or npc.EntityCollisionClass == EntityCollisionClass.ENTCOLL_NONE then
				npc.StateFrame = math.max(npc.StateFrame - 10, 0)
			else
				npc.StateFrame = npc.StateFrame + 1
			end
			npc.I1 = npc.I1 + 1
			local target = npc.Parent.Position
			local frame = npc.I1 + d.frameOffset
			local distance = math.min(npc.StateFrame/3, d.distance)

			local xvel = math.cos((frame / 16) + math.pi) * (distance)
			local yvel = math.sin((frame / 16) + math.pi) * (distance)

			local direction = (target - Vector(xvel, yvel)) - npc.Position

			if direction:Length() > d.distance then
				direction:Resize(d.distance)
			end

			npc.Velocity = mod:Lerp(npc.Velocity, direction, 0.5)

			local overlayOffset = npc.Parent:GetNullOffset("OverlayEffect")
			local hasIt = overlayOffset:Length() > 0
			if d.AnimOverride then
				if hasIt then
					npc.StateFrame = 0
					npc.Position = npc.Parent.Position
					sprite:Play("TeleportIn")
				end
			else
				if d.HasParentOverlay and not hasIt then
					sprite:Play("TeleportOut")
					d.AnimOverride = true
				end
			end
			d.HasParentOverlay = hasIt
		end
	else
		npc.Parent = nil
		npc:ClearEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET)
		npc:Morph(18, 0, 0, -1)
	end
end