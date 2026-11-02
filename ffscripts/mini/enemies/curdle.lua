local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector(0, 0)

--curdle: like creepterum most death stuff is handled in the on hit
function mod:curdleai(npc, sprite, npcdata)
	local room = game:GetRoom()
	if not npcdata.init then
		npcdata.skin = true
		npcdata.state = "walk"
		npcdata.vomtimer = math.random(60, 90)
		npcdata.init = true
		npcdata.confuseangle = math.random(360)
	end

	npcdata.confuseangle = npcdata.confuseangle + math.random(-30, 30)

	local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	targetpos = mod:randomConfuse(npc, targetpos)
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()
	local path = npc.Pathfinder

	--creep
	if npc.FrameCount % 4 == 0 then
		local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, npc.Position, Vector(0,0), npc):ToEffect();
		creep.Scale = 0.75
		if npcdata.skin then
			creep:SetTimeout(math.floor(creep.Timeout * 0.6))
		else
			creep:SetTimeout(math.floor(creep.Timeout * 0.25))
		end
		creep:Update();
	end
	--death creep
	if npc:IsDead() then
		local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, npc.Position, Vector(0,0), npc):ToEffect();
		creep.SpriteScale = Vector(2, 1.33)
		creep:SetTimeout(math.floor(creep.Timeout * 0.4))
		creep:Update();
	end
	if npcdata.state == "walk" then
		--lots of this code copied from fathead

		if room:CheckLine(npc.Position,targetpos,0,1,false,false) or npc:HasEntityFlags(EntityFlag.FLAG_FEAR) or npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION) then
			local speed = 3
			if npcdata.skin == false then
				speed = 4
			end
			local targetvelocity = (targetpos - npc.Position):Normalized() * speed
			if npc:HasEntityFlags(EntityFlag.FLAG_FEAR) then
				targetvelocity = targetvelocity * -1
			end
			local lerpy = 0.25
			if npcdata.skin == false then
				lerpy = 0.3
			end
			if npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION) then
				targetvelocity = Vector(3.5, 0):Rotated(npcdata.confuseangle)
			end
			npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, lerpy)
		else
			if npcdata.skin == true then
				path:FindGridPath(targetpos, 0.4, 900, true)
			else
				path:FindGridPath(targetpos, 0.55, 900, true)
			end
		end

		--anim
		sprite.FlipX = false
		if npcdata.skin == true then
			if npc.Velocity:Length() < 0.25 then
				sprite:SetFrame("Appear", 20)
			elseif math.abs(npc.Velocity.X) >= math.abs(npc.Velocity.Y) then
				sprite:SetFrame("walkhori", npc.FrameCount % 22)
				if npc.Velocity.X < 0 then
					sprite.FlipX = true
				end
			else
				sprite:SetFrame("walkvert", npc.FrameCount % 22)
			end
		else
			if npc.Velocity:Length() < 0.25 then
				sprite:SetFrame("fleshbreak", 14)
			elseif math.abs(npc.Velocity.X) >= math.abs(npc.Velocity.Y) then
				sprite:SetFrame("walkhorinaked", npc.FrameCount % 22)
				if npc.Velocity.X < 0 then
					sprite.FlipX = true
				end
			else
				sprite:SetFrame("walkvertnaked", npc.FrameCount % 22)
			end
		end
		--vom logic
		if not npcdata.skin then
			npcdata.vomtimer = npcdata.vomtimer - 1
			if npc:HasEntityFlags(EntityFlag.FLAG_FEAR) or npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION) then
				npcdata.vomtimer = npcdata.vomtimer + 1
			end
			if npcdata.vomtimer <= 0 then
				npcdata.state = "vom"
				npcdata.vomtimer = math.random(60, 90)
			end
		end
	elseif npcdata.state == "break" then
		mod:spritePlay(sprite, "fleshbreak")
		npc.Velocity = mod:Lerp(npc.Velocity, Vector(0,0), 0.3)
		if sprite:IsFinished("fleshbreak") then
			npcdata.state = "walk"
		end
	elseif npcdata.state == "vom" then
		mod:spritePlay(sprite, "shoot")
		npc.Velocity = mod:Lerp(npc.Velocity, Vector(0,0), 0.3)
		if sprite:IsFinished("shoot") then
			npcdata.state = "walk"
		end
	end

	--event
	if sprite:IsEventTriggered("fleshbreak") then
		--not toe people snooping in my code: DONT DO THIS THIS IS TERRIBLE
		local dummy = Isaac.Spawn(666, 140, 0, npc.Position, Vector(0,0), npc):ToNPC();
		dummy:Kill()
		for i = 1, math.random(1, 2), 1 do
			local chunk = Isaac.Spawn(310, 1, 0, npc.Position, RandomVector():Resized(math.random(2, 4)), npc):ToNPC();
			chunk:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		end
	elseif sprite:IsEventTriggered("vomit") then
		npc:PlaySound(SoundEffect.SOUND_RAGMAN_4,1,0,false,math.random(150, 200) / 100)
		local projectile = mod:LazySpawnProjectile(0, 0, npc.Position, Vector(math.floor(0.05 * targetdistance * (math.random(8, 10) / 10), 6),0):Rotated(targetangle), npc):ToProjectile();
		projectile.FallingSpeed = -30;
		projectile.FallingAccel = 2
		projectile.Height = -10
		projectile:Update()
		mod:GetEntityData(projectile).special = "curdled"
		local projsprite = projectile:GetSprite()
		projsprite:Load("gfx/projectiles/002.035_balloon tear.anm2",true)
		projsprite:Play("RegularTear6", true)
		projsprite:ReplaceSpritesheet(0, "gfx/projectiles/tears_balloon.png")
		projsprite:LoadGraphics()
		projectile.Scale = 2.5
	end
end