local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector(0, 0)

--calzone: maggots fnerocr
function mod:calzoneai(npc, sprite, npcdata)
	if npcdata.init == nil then
		npcdata.init = true
		npcdata.state = "idle"
		npcdata.statetimer = 0
		npcdata.statethreshold = math.random(5, 15)
		npcdata.leapnum = 0
		npcdata.leapthreshold = math.random(2, 4)
		npcdata.leaping = false
		npcdata.target = Vector(0,0)
		npcdata.DarkRedChampionDeaths = 0
	end

	if mod.TrueVoteOutcome then
		if not sprite:IsPlaying("Appear") then
			Isaac.Spawn(1000,19,0, npc.Position, nilvector, npc)
			Isaac.Explode(npc.Position, npc, 5)
			npc:Kill()
		end
	end

	if not npcdata.leaping then
		npc.Velocity = mod:Lerp(npc.Velocity, nilvector, 0.25)
	end

	--flipping
	if npcdata.state ~= "vomit" then
		npc.FlipX = npc.Velocity.X < 0
	end

	--state stuff
	if npcdata.state == "idle" then
		mod:spritePlay(sprite, "idle")
		npcdata.statetimer = npcdata.statetimer + 1
		if npc:HasEntityFlags(EntityFlag.FLAG_FEAR) then
			npcdata.statetimer = npcdata.statetimer + 2
		end
		if npcdata.statetimer > npcdata.statethreshold then
			--just took this from th mamapooter ok???
			local maggotlimit = 0
			local maggotnumber = 0
			if npc.Variant == mod.FF.Breadbin.Var then
				--breadbin
				for _,entity in ipairs(Isaac.GetRoomEntities()) do
					local etype = entity.Type
					local evar = entity.Variant
					if (etype == mod.FF.RolyPoly.ID and evar == mod.FF.RolyPoly.Var) then
						maggotnumber = maggotnumber + 1
					end
					if etype == mod.FF.Breadbin.ID and evar == mod.FF.Breadbin.Var then
						maggotlimit = maggotlimit + 2
					end
				end
			else
				--normal
				for _,entity in ipairs(Isaac.GetRoomEntities()) do
					local etype = entity.Type
					local evar = entity.Variant
					if (etype == 21 or etype == 23 or etype == 31 or etype == 243) then
						maggotnumber = maggotnumber + 1
					end
					if etype == mod.FF.Calzone.ID and evar == mod.FF.Calzone.Var then
						maggotlimit = maggotlimit + 2
					end
				end
			end
			--print(maggotnumber.." "..maggotlimit)
			if maggotnumber < maggotlimit and npcdata.leapnum >= npcdata.leapthreshold and not (npc:HasEntityFlags(EntityFlag.FLAG_FEAR) or npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION)) then
				npcdata.state = "vomit"
				npcdata.statetimer = 0
				npcdata.statethreshold = math.random(30, 45)
				npcdata.leapnum = 0
				npcdata.leapthreshold = math.random(2, 4)
				--flip
				npcdata.target = mod:chooserandomlocationforskuzz(npc, 175, 125)
				npc.FlipX = npcdata.target.X < npc.Position.X
			else
				npcdata.state = "leap"
				npcdata.statetimer = 0
				if(npc.SubType == 1) then
					npcdata.statethreshold = math.random(15, 30)
				elseif npc.Variant == 152 then
					npcdata.statethreshold = math.random(10, 25)
				else
					npcdata.statethreshold = math.random(5, 15)
				end
				npcdata.leapnum = npcdata.leapnum + 1
			end
		end
	elseif npcdata.state == "leap" then
		mod:spritePlay(sprite, "leap")
		if sprite:IsFinished("leap") then
			npcdata.state = "idle"
		elseif sprite:IsEventTriggered("startmove") then
			npcdata.leaping = true
			local targetpos = npc:GetPlayerTarget().Position
			if npc:HasEntityFlags(EntityFlag.FLAG_FEAR) then
				npc.Velocity = (targetpos - npc.Position):Resized(math.random(45, 60)/10) * -1
			else
				npc.Velocity = Vector(math.random(30, 45)/10, 0):Rotated(math.random(360))
			end
			npc:PlaySound(SoundEffect.SOUND_FETUS_JUMP,0.4,0,false,math.random(13, 16) / 10)
		elseif sprite:IsEventTriggered("stopmove") then
			npcdata.leaping = false
			npc:PlaySound(SoundEffect.SOUND_MEAT_JUMPS,0.6,0,false,math.random(10, 12) / 10)
		end
	elseif npcdata.state == "vomit" then
		mod:spritePlay(sprite, "vomit")
		if sprite:IsFinished("vomit") then
			npcdata.state = "idle"
		elseif sprite:IsEventTriggered("vomit") then
			if(npc.SubType == 1) then
				mod:shootMaggot(npc, npcdata.target, 2)
				npc:PlaySound(SoundEffect.SOUND_WHEEZY_COUGH, 1, 0, false, math.random(15, 18) / 10)
			elseif npc.Variant == 152 then
				mod:shootMaggot(npc, npcdata.target, 1, 7)
				npc:PlaySound(226, 1, 0, false, 1)
			else
				mod:shootMaggot(npc, npcdata.target, 1)
				npc:PlaySound(SoundEffect.SOUND_LEECH ,0.4,0,false, 0.65)
				npc:PlaySound(226, 1, 0, false, 1.3)
			end
		end
	end

	if npc:IsDead() and mod:shouldDoDeathEffect(npc) then
		if npcdata.DarkRedChampionDeaths < 2 then
			for i = 0, math.random(0, 1 - npcdata.DarkRedChampionDeaths), 1 do
				npcdata.target = mod:chooserandomlocationforskuzz(npc, 100, 75)
				if(npc.SubType == 1) then
					mod:shootMaggot(npc, npcdata.target, 2)
				elseif npc.Variant == 152 then
					mod:shootMaggot(npc, npcdata.target, 1, 7)
				else
					mod:shootMaggot(npc, npcdata.target, 1)
				end
			end
		end
		npcdata.DarkRedChampionDeaths = npcdata.DarkRedChampionDeaths + 1
	end
end