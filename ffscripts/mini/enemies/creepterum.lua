local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector(0, 0)

function mod:creepterumai(npc, sprite, npcdata)
	local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	npc:ClearEntityFlags(EntityFlag.FLAG_FREEZE | EntityFlag.FLAG_MIDAS_FREEZE)

	if not npcdata.init then
		npcdata.init = true;
		npcdata.living = true;
		npcdata.attacking = false;
		npcdata.attacktimer = math.random(90, 120)
		npcdata.attackloops = 0;
		npcdata.attackloopstarget = math.random(4,5);
		npcdata.blowtimer = math.random(30, 45);
		npcdata.slaves = {}
		npcdata.slaveangle = 0;
		npcdata.slavelength = 60;
		npcdata.confuseangle = math.random(360)
	end
	npcdata.confuseangle = npcdata.confuseangle + math.random(-30, 30)
	if not npcdata.living and game:GetRoom():IsClear() and sprite:IsPlaying("FallenIdle") then
		for _, slave in pairs(npcdata.slaves) do
			slave:Kill()
		end
		npc:Kill()
	end
	--slave control
	if #npcdata.slaves >= 3 then
		npcdata.slavelength = mod:Lerp(npcdata.slavelength, 0, 0.1);
	else
		npcdata.slavelength = mod:Lerp(npcdata.slavelength, 60, 0.1);
	end
	npcdata.slaveangle = npcdata.slaveangle + 1.5;
	mod:creepertumSlaveControl(npc, sprite, npcdata)
	if npcdata.living == true then
		--movement shit
		local targetvelocity = mod:diagonalMove(npc, 2.5, 1);

		if npc:HasEntityFlags(EntityFlag.FLAG_FEAR) then
			if (npc.Position - targetpos):Length() < 125 then
				targetvelocity = (npc.Position - targetpos):Resized(2.5)
			end
		elseif npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION) then
			targetvelocity = Vector(2.5, 0):Rotated(npcdata.confuseangle)
		end

		npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.15)
		--enemie logic
		if not npcdata.attacking then
			--not attacking
			if not (sprite:IsPlaying("AttackEnd") or sprite:IsPlaying("Recover")) then
				mod:spritePlay(sprite, "Walk")
			end
			if not (npc:HasEntityFlags(EntityFlag.FLAG_FEAR) or npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION)) then
				npcdata.attacktimer = npcdata.attacktimer - 1;
			end
			if npcdata.attacktimer <= 0 then
				npcdata.attacking = true
				npcdata.attackloops = 0;
				npcdata.attackloopstarget = math.random(4,5);
				npcdata.blowtimer = math.random(30, 45);
				mod:spritePlay(sprite, "AttackStart")
			end
		else
			--OHHHH KILL THEM ALL!!!
			if sprite:IsFinished("AttackStart") then
				mod:spritePlay(sprite, "AttackLoop")
			elseif sprite:IsPlaying("AttackLoop") then
				if sprite:GetFrame() == 19 then
					npcdata.attackloops = npcdata.attackloops + 1;
				end
				--this is where flies spawn ouggh
				npcdata.blowtimer = npcdata.blowtimer - 1;
				if npcdata.blowtimer <= 0 then
					npc:PlaySound(SoundEffect.SOUND_SUMMONSOUND, 0.6, 0, false, 1.2)
					if math.random(1, 4) == 4 then
						EntityNPC.ThrowSpider(npc.Position, npc, mod:chooserandomlocationforskuzz(npc, 100, 50), false, 0)
					else
						local fly = Isaac.Spawn(18, 0, 0, npc.Position, npc.Velocity + (targetpos - npc.Position):Resized(math.random(15, 25) / 10), npc):ToNPC();
						fly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
					end
					npcdata.blowtimer = math.random(20, 30);
				end
				--end that
			end
			if npcdata.attackloops >= npcdata.attackloopstarget then
				npcdata.attacking = false;
				mod:spritePlay(sprite, "AttackEnd")
				npcdata.attacktimer = math.random(90, 120)
			end
		end
	else
		npc.CanShutDoors = false
		if sprite:GetFrame() > 22 or not sprite:IsPlaying("Fall") then
			if npc:HasEntityFlags(EntityFlag.FLAG_FEAR) then
				if sprite:IsPlaying("FallenIdle") then
					if sprite:GetFrame() == 18 then
						npc.Velocity = (npc.Position - targetpos):Normalized() * 8.5
					end
					if sprite:GetFrame() < 17 and sprite:GetFrame() > 27 then
						npc.Velocity = mod:Lerp(npc.Velocity, Vector(0, 0), 0.15)
					else
						npc.Velocity = mod:Lerp(npc.Velocity, Vector(0, 0), 0.3)
					end
				else
					npc.Velocity = mod:Lerp(npc.Velocity, Vector(0, 0), 0.3)
				end
			else
				npc.Velocity = mod:Lerp(npc.Velocity, Vector(0, 0), 0.3)
			end
		end
		if sprite:IsPlaying("Fall") and sprite:GetFrame() == 1 then
			npc:PlaySound(SoundEffect.SOUND_SPIDER_COUGH, 1, 0, false, 1.60)
		elseif sprite:IsFinished("Fall") then
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
			npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
			mod:spritePlay(sprite, "FallenIdle")
		elseif not sprite:IsPlaying("Fall") then
			--actual logic
			if not npcdata.attacking then
				if not sprite:IsPlaying("Recover")then
					mod:spritePlay(sprite, "FallenIdle")
				end
				if #npcdata.slaves < 3 then
					if not (npc:HasEntityFlags(EntityFlag.FLAG_FEAR) or npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION)) then
						npcdata.attacktimer = npcdata.attacktimer - 1;
					end
				end
				if npcdata.attacktimer <= 0 then
					npcdata.attacking = true
					mod:spritePlay(sprite, "Spawn")
				end
			else
				if sprite:IsFinished("Spawn") then
					npcdata.attacking = false
					npcdata.attacktimer = math.random(80, 100)
				end
			end
		end
		--revival
		if npcdata.slavelength <= 2 and #npcdata.slaves >= 3 then
			for i = 1, #npcdata.slaves, 1 do
				npcdata.slaves[i]:Remove()
			end
			npcdata.slaves = {}
			--actually revive
			mod:spritePlay(sprite, "Recover")
		end
		--actually actually revive
		if sprite:IsPlaying("Recover") and sprite:GetFrame() >= 19 then
			npcdata.slavelength = 60
			npcdata.living = true
			npc.CanShutDoors = true
			npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
			npc:ClearEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET)
			mod:GetEntityData(npc).attacking = false
			mod:GetEntityData(npc).attacktimer = math.random(90, 120)
		end
	end

	--events n shit

	if sprite:IsEventTriggered("Shoot") then
		npc:PlaySound(SoundEffect.SOUND_SPIDER_COUGH, 1, 0, false, math.random(90,110)/100)
		npc:PlaySound(SoundEffect.SOUND_SUMMONSOUND, 0.6, 0, false, 1.2)
		for i = 1, math.random(2, 3), 1 do
			if math.random(1, 5) == 5 then
				EntityNPC.ThrowSpider(npc.Position, npc, mod:chooserandomlocationforskuzz(npc, 100, 50), false, 0)
			else
				local fly = Isaac.Spawn(18, 0, 0, npc.Position, npc.Velocity +  RandomVector():Resized(math.random(15, 25) / 10), npc):ToNPC();
				fly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			end
		end
	elseif sprite:IsEventTriggered("Spawn") then
		npc:PlaySound(SoundEffect.SOUND_SUMMONSOUND, 0.6, 0, false, 1)
		npc:PlaySound(SoundEffect.SOUND_SPIDER_COUGH, 1, 0, false, 0.8)
		for i = 1, math.random(3, 4), 1 do
			if math.random(1, 5) == 5 then
				EntityNPC.ThrowSpider(npc.Position, npc, mod:chooserandomlocationforskuzz(npc, 100, 50), false, 0)
			else
				local fly = Isaac.Spawn(18, 0, 0, npc.Position, npc.Velocity +  RandomVector():Resized(math.random(15, 25) / 10), npc):ToNPC();
				fly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			end
		end
		local slave = Isaac.Spawn(666, 131, 0, npc.Position, npc.Velocity +  RandomVector():Resized(math.random(15, 25) / 10), npc):ToNPC();
		slave:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET)
		slave.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
		slave:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		slave.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
		table.insert(npcdata.slaves, slave)
	end
end

function mod:creepertumSlaveControl(npc, sprite, npcdata)
	if #npcdata.slaves > 0 then
		for i = 1, #npcdata.slaves, 1 do
			local slave = npcdata.slaves[i]
			if npc:IsDead() then
				slave:Kill()
			end
			mod:spritePlay(slave:GetSprite(), "fly")
			local target = npc.Position + Vector(npcdata.slavelength, 0):Rotated(npcdata.slaveangle + ((i-1) * (360 / #npcdata.slaves)))
			local targetVel = (target - slave.Position):Resized(4)
			if (target - slave.Position):Length() > 2 then
				slave.Velocity = mod:Lerp(slave.Velocity, targetVel, 0.3)
			else
				slave.Velocity = mod:Lerp(slave.Velocity, targetVel, 0.1)
			end
		end
	end
end