local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

mod.patzershellanim = {
	{-3, 100, 100},
	{3, 105, 100},
	{0, 100, 100},
	{-2, 100, 100},
	{2, 100, 100},
	{0, 100, 100}
}

--patzer - disc room real? the code for this is gonna be very complex and very messy
function mod:patzerai(npc, sprite, npcdata)
	local room = game:GetRoom()
	local target = npc:GetPlayerTarget()
	local targetpos = mod:confusePos(npc, target.Position)
	local targetangle = math.rad((targetpos - npc.Position):GetAngleDegrees())
	if not npcdata.init then
		npcdata.init = true
		npcdata.shell = Isaac.Spawn(666, 201, 0, npc.Position, Vector(0, 0), npc):ToNPC()
		mod:GetEntityData(npcdata.shell).parent = npc
		npcdata.shell.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
		npcdata.shell.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
		npcdata.movetimer = 45
		npcdata.movetimermax = 45
		npcdata.movin = 0
		npcdata.mainvert = false;
		npcdata.maincurve = 1;
		npcdata.offcurve = 1;
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
		--npc:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
		if not npc:HasEntityFlags(EntityFlag.FLAG_APPEAR) then 
			npcdata.shell:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			npcdata.shell:Update()
		end
	else
		if(not npc:IsDead()) and npcdata.shell:Exists() then
			table.insert(mod:GetEntityData(npcdata.shell).positions, 1, npc.Position)
			table.remove(mod:GetEntityData(npcdata.shell).positions, 46)
			table.insert(mod:GetEntityData(npcdata.shell).velocities, 1, npc.Velocity)
			table.remove(mod:GetEntityData(npcdata.shell).velocities, 46)
			npc.PositionOffset = Vector(0, math.sin(math.rad(npc.FrameCount * 4)) * 4)
		end
		if npcdata.movin == 0 then
			npc.Velocity = mod:Lerp(npc.Velocity, Vector(0,0), 0.75)
			if sprite:IsPlaying("moveover") then
				if sprite:IsFinished("moveover") then
					mod:spritePlay(sprite, "idle")
				end
			else
				mod:spritePlay(sprite, "idle")
			end
			if(npcdata.movetimer <= 0) then
				npcdata.movin = 1
				mod:spritePlay(sprite, "movestart")
			else
				npcdata.movetimer = npcdata.movetimer - 1
			end
		--start moving
		elseif npcdata.movin == 1 then
			npc.Velocity = mod:Lerp(npc.Velocity, Vector(0,0), 0.75)
			if sprite:IsEventTriggered("movestart") then
				npcdata.movin = 2
				npcdata.movetimer = 45
				mod:GetEntityData(npcdata.shell).movetimer = 45
				--target selection
				if math.abs(math.sin(targetangle)) > 0.5 then
					npcdata.mainvert = true
					if(npc.Position.Y > targetpos.Y) then
						npcdata.maincurve = -1
					else
						npcdata.maincurve = 1
					end
					if npc.Position.X > targetpos.X then
						npcdata.offcurve = -1
					else
						npcdata.offcurve = 1
					end
				else
					npcdata.mainvert = false
					npcdata.maincurve = 1
					if(npc.Position.X > targetpos.X) then
						npcdata.maincurve = -1
					end
					if npc.Position.Y > targetpos.Y then
						npcdata.offcurve = -1
					else
						npcdata.offcurve = 1
					end
				end
				if mod:isScare(npc) then
					npcdata.maincurve = -npcdata.maincurve
					npcdata.offcurve = -npcdata.offcurve
				end
			end
		--actual movement
		else
			--anim
			if sprite:IsPlaying("movestart") then
				if sprite:IsFinished("movestart") then
					mod:spritePlay(sprite, "move")
				end
			else
				mod:spritePlay(sprite, "move")
			end
			--velocity setting
			local targetVelocity = Vector(0, 0)
			local t = npcdata.movetimermax - npcdata.movetimer
			t = t * (2/3)
			if(npcdata.mainvert) then
				targetVelocity.Y = ((-0.045*(t - 15)^2) + 10) * npcdata.maincurve
				targetVelocity.X = ((-0.05*(t - 15)^2) + 7) * npcdata.offcurve
			else
				targetVelocity.X = ((-0.045*(t - 15)^2) + 10) * npcdata.maincurve
				targetVelocity.Y = ((-0.05*(t - 15)^2) + 7) * npcdata.offcurve
			end
			targetVelocity = targetVelocity * (2/3)
			npc.Velocity = mod:Lerp(npc.Velocity, targetVelocity, 0.3)
			--bouncex
			if(not room:IsPositionInRoom(Vector(npc.Position.X + npc.Velocity.X * 3, npc.Position.Y), 5)) then
				if(not npcdata.mainvert) then
					npcdata.maincurve = npcdata.maincurve * -1
				else
					npcdata.offcurve = npcdata.offcurve * -1
				end
			end
			--bouncey
			if(not room:IsPositionInRoom(Vector(npc.Position.X, npc.Position.Y + npc.Velocity.Y * 3), 5)) then
				if(npcdata.mainvert) then
					npcdata.maincurve = npcdata.maincurve * -1
				else
					npcdata.offcurve = npcdata.offcurve * -1
				end
			end
			--transfer
			if(npcdata.movetimer <= 0) then
				npcdata.movin = 0
				npcdata.movetimer = 45
				mod:spritePlay(sprite, "moveover")
			else
				npcdata.movetimer = npcdata.movetimer - 1
			end
		end
	end
	if(npc:IsDead()) then
		npcdata.shell:Kill()
	end
end

function mod:patzershellai(npc, sprite, npcdata)
	if (npcdata.parent == nil or npcdata.parent:IsDead() or mod:isStatusCorpse(npcdata.parent)) then
		npcdata.init = true
		npc:Kill()
	else
		if not npcdata.init then
			npcdata.init = true
			npcdata.positions = {}
			npcdata.velocities = {}
			for i = 1, 46, 1 do
				table.insert(npcdata.positions, npcdata.parent.Position)
			end
			for i = 1, 46, 1 do
				table.insert(npcdata.velocities, npcdata.parent.Velocity)
			end
			npcdata.movetimer = 69
			npcdata.movan = false
			npcdata.moveanim = 5
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
			npc:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET)
		else
			if(npcdata.movetimer ~= 69) then
				npcdata.movetimer = npcdata.movetimer - 1;
				if(npcdata.movetimer <= 0) then
					npcdata.moveanim = 0
					npcdata.movan = not npcdata.movan
					if(not npcdata.movan) then
						npcdata.movetimer = 69
					else
						npcdata.movetimer = 45
					end
				end
			end
			npcdata.moveanim = math.min(npcdata.moveanim + 1, 6)
			npc.PositionOffset = Vector(mod.patzershellanim[npcdata.moveanim][1], math.sin(math.rad(npc.FrameCount * 5)) * 4)
			sprite.Scale = Vector(mod.patzershellanim[npcdata.moveanim][2], mod.patzershellanim[npcdata.moveanim][3])
			mod:spritePlay(sprite, "idle")
			npc.Position = npcdata.positions[45]
			npc.Velocity = npcdata.velocities[45]
		end
	end
end

function mod:PatzerShellColl(npc, collider)
	local npcdata = mod:GetEntityData(npc)
	if npcdata.parent and npcdata.parent.InitSeed == collider.InitSeed then
		return true
	end
end