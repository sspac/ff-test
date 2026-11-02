local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector(0, 0)

--chorister: sing man
function mod:choristerai(npc,sprite,npcdata)
	local room = game:GetRoom()
	local path = npc.Pathfinder
	local target = npc:GetPlayerTarget()
	local targetpos = mod:confusePos(npc, target.Position)
	npc.SplatColor = Color(0,0,0,1,91 / 255,229 / 255,220 / 255);
	--init
	if not npcdata.trueinit then
		--spawn the godhead aura
		--local aura = mod.spawnent(npc, (npc.Position + Vector(0, -10)), npc.Velocity, 1000, 666, 0):ToEffect()
		--[[local aura = Isaac.Spawn(1000, 666, 0, npc.Position + Vector(0, -10), nilvector, npc):ToEffect()
		aura:FollowParent(npc)
		aura:Update()]]
		npcdata.trueinit = true
	end
	if not npcdata.init then
		npcdata.state = "move"
		npcdata.countdown = math.random (60, 180)
		npcdata.init = true
		npcdata.loopanim = false
	else
		npc.StateFrame = npc.StateFrame + 1
	end
	--main ai
	if npcdata.state == "move" then
		--set target for pathfinding
		--if you dont check this the game crashes
		if npc.FrameCount > 25 and not room:CheckLine(npc.Position,targetpos,0,1,false,false) then
			path:FindGridPath(targetpos, 0.5, 900, true)
		else
			npcdata.targetvelocity = mod:reverseIfFear(npc, (targetpos - npc.Position):Resized(3))
			npc.Velocity = mod:Lerp(npc.Velocity, npcdata.targetvelocity, 0.2)
		end
		--play animations
		if npc.Velocity:Length() > 0.1 then
			if math.abs(npc.Velocity.X) > math.abs(npc.Velocity.Y) then
				if npc.Velocity.X > 0 then
					mod:spritePlay(sprite, "WalkHori")
				else
					mod:spritePlay(sprite, "WalkHoriFlip")
				end
			else
				mod:spritePlay(sprite, "WalkVert")
			end
		else
			sprite:SetFrame("WalkVert", 0)
		end
		--countdown for sing
		if npcdata.countdown > 0 then
			npcdata.countdown = npcdata.countdown - 1
		else
			if (not mod:isScareOrConfuse(npc)) and (npc.Position - targetpos):LengthSquared() <= 120 ^ 2 then
				npcdata.state = "singprep"
			end
		end
	elseif npcdata.state == "singprep" then
		--slow down
		npc.Velocity = npc.Velocity * 0.8
		--sprite logic
		mod:spritePlay(sprite, "SingStart")
		if sprite:IsEventTriggered("singstart") then
			npcdata.state = "sing"
		end
	elseif npcdata.state == "sing" then
		--makesure man dont FLY
		npc.Velocity = npc.Velocity * 0.8
		--check if start on the loop
		if sprite:IsEventTriggered("singloopstart") then
			npc:PlaySound(SoundEffect.SOUND_UNHOLY, 1.4, 0, false, math.random(110,130)/100)
			npcdata.loopanim = true
			npcdata.shootOuts = 0
			npc.StateFrame = 0
		end
		--sprite logic
		if npcdata.loopanim then
			mod:spritePlay(sprite, "SingLoop")
			if npc.StateFrame % 10 == 1 and npcdata.shootOuts < 3 then
				for i = 90, 360, 90 do
					local pos = npc.Position + Vector(25 + 25 * npcdata.shootOuts, 0):Rotated(i + 45 * npcdata.shootOuts)
					local beam = Isaac.Spawn(1000, 19, 0, pos, nilvector, npc):ToEffect()
					beam.Parent = npc
					beam.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
					beam:Update()
				end
				npcdata.shootOuts = npcdata.shootOuts + 1
			end

			if npc.StateFrame > 40 then
				npcdata.state = "singend"
			end
		else
			mod:spritePlay(sprite, "SingStart")
		end
	elseif npcdata.state == "singend" then
		--makesure man dont FLY
		npc.Velocity = npc.Velocity * 0.8
		mod:spritePlay(sprite, "SingEnd")
		if sprite:IsEventTriggered("gobacktowalk") then
			npcdata.state = "move"
			npcdata.init = false
		end
	end
end

--choriseter's woobly aura
function mod:choristerauraai(npc)
	local sprite = npc:GetSprite();
	local parentsprite = npc.Parent:GetSprite();
	local npcdata = mod:GetEntityData(npc);
    
	if not npcdata.init then
		npcdata.bigness = 0
		npcdata.init = true
		npc.SpriteScale = nilvector
		npcdata.sizeupcounter = 0
		npcdata.sizedowncounter = 0
		npc.Color = Color(1,1,1,0.6,0,0,0)
	end
	if npc.Parent:IsDead() then
		npc:Remove()
	else
		--handle how big the
		if parentsprite:IsPlaying("WalkHori") or parentsprite:IsPlaying("WalkVert") then
			npcdata.bigness = 0
		end
		if parentsprite:IsEventTriggered("singstart") then
			npcdata.sizeupcounter = 8
		elseif parentsprite:IsEventTriggered("singend") then
			npcdata.sizedowncounter = 20
		end
		if npcdata.sizeupcounter > 0 then
			npcdata.bigness = npcdata.bigness + 0.625
			npcdata.sizeupcounter = npcdata.sizeupcounter - 1
		end
		if npcdata.sizedowncounter > 0 then
			npcdata.bigness = npcdata.bigness - 0.25
			npcdata.sizedowncounter = npcdata.sizedowncounter - 1
		end
		mod:spritePlay(sprite, "idle")
		npc.SpriteScale = Vector(npcdata.bigness, npcdata.bigness)
		--handle damage
		for i = 1, game:GetNumPlayers() do
			local player = Isaac.GetPlayer(i - 1)
			if (npc.Position - player.Position):LengthSquared() <= (npcdata.bigness * 20) ^ 2 then
				player:TakeDamage(1, 0, EntityRef(player), 0)
			end
		end
		--todo: add special case if charmed
	end
end

function mod:HijackedChoristerAura(effect)
	if effect.SubType == 170 then
		mod:blackMoonAura(effect)
	elseif effect.SubType == 171 then
		mod:blackMoonMiddle(effect)
	else
		mod:choristerauraai(effect)
	end
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.HijackedChoristerAura, 666)