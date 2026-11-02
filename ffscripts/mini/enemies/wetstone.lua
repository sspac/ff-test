local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector(0, 0)

--wetstone ai - spits bubbles around in a consstant stream
--bubble grimace
function mod:wetstoneai(npc, sprite, npcdata)
	--stay in place
	npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
	npc.Velocity = nilvector

	--Isaac.ConsoleOutput(npc.State .. "\n")

	if npc.State ~= 16 then
		npc.State = 0
		npcdata.started = true
		--if active and bubbling, shoot bubbles
		if sprite:IsPlaying("bubble") then
			if not npcdata.bubbletimerset then
				npcdata.bubbletimer = math.random(20,30)
				npcdata.closeeyestimer = 18
				npcdata.bubbletimerset = true
			else
				npcdata.bubbletimer = npcdata.bubbletimer - 1;
			end
			if npcdata.bubbletimer <= 0 then
				--[[local bubblenumber = math.random(1,5)
				local randangle = 0
				--if bubblenumber >= 3 then
					for i = 1, bubblenumber-2, 1 do
						randangle = math.random(0,359)
						mod.ShootBubble(npc, -1, npc.Position + Vector(5,0):Rotated(randangle),Vector((math.random(20,40)/25),0):Rotated(randangle))
					end
				else
					randangle = math.random(0,359)
					mod.ShootBubble(npc, -1, npc.Position + Vector(5,0):Rotated(randangle),Vector((math.random(20,40)/100),0):Rotated(randangle))
				end]]
				local randangle = math.random(0,359)
				mod.ShootBubble(npc, -1, npc.Position + Vector(5,0):Rotated(randangle),Vector((math.random(20,40)/25),0):Rotated(randangle))
				npcdata.bubbletimer = math.random(20,30)
			end
		end
		--shut down on room clear
		if not sprite:IsPlaying("bubble")then
			sprite:Play("bubble", true);
		end
	elseif npc.State == 16 then
		if npcdata.started then
            sprite:Play("CloseEyes", true)
            npcdata.started = nil
		end
		if sprite:IsFinished("CloseEyes") then
		    sprite:Play("ClosedEyes", true)
		end
	end
end