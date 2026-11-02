local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector(0, 0)

function mod:boilersetshottimer(npcdata)
	local normal = 72
	local actual = normal - (npcdata.blotsfed * 22)
	npcdata.shoottimer = math.random(actual - (1 + npcdata.blotsfed), actual + (1 + npcdata.blotsfed))
end

function mod:boilerai(npc, sprite, npcdata)
	if not npcdata.init then
		npcdata.init = true
		npcdata.state = "idle"
		npcdata.shoottimer = math.random(68, 76)
		npcdata.blotprep = false
		npcdata.blotsfed = 0
	end
	if npcdata.state == "idle" then
		mod:spritePlay(sprite, "idle")
		if npc:HasEntityFlags(EntityFlag.FLAG_FEAR) then
			if sprite:GetFrame() == 24 then
				local target = npc:GetPlayerTarget().Position
				npc.Velocity = (npc.Position - target):Normalized() * 8.5
			end
			if sprite:GetFrame() < 23 and sprite:GetFrame() > 29 then
				npc.Velocity = mod:Lerp(npc.Velocity, Vector(0,0), 0.2)
			else
				npc.Velocity = mod:Lerp(npc.Velocity, Vector(0,0), 0.8)
			end
		else
			npc.Velocity = mod:Lerp(npc.Velocity, Vector(0,0), 0.8)
		end
		if npcdata.shoottimer <= 0 then
			npcdata.state = "shoot"
		end
		npcdata.blotprep = false
		for _, blotmaybe in ipairs(Isaac.GetRoomEntities()) do
			if blotmaybe.Type == Isaac.GetEntityTypeByName("Blot") and blotmaybe.Variant == Isaac.GetEntityVariantByName("Blot") and ((blotmaybe.Position - npc.Position):Length() <= 100) then
				npcdata.blotprep = true
			end
		end
		if npcdata.blotsfed >= 3 then
			npcdata.blotprep = false
		end
		if npc:HasEntityFlags(EntityFlag.FLAG_FEAR) or npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION) then
			npcdata.blotprep = false
			npcdata.shoottimer = npcdata.shoottimer + 1
		end

		if npcdata.blotprep == false then
			npcdata.shoottimer = npcdata.shoottimer - 1
		else
			for _, blotmaybe in ipairs(Isaac.GetRoomEntities()) do
				if blotmaybe.Type == Isaac.GetEntityTypeByName("Blot") and blotmaybe.Variant == Isaac.GetEntityVariantByName("Blot") and ((blotmaybe.Position - npc.Position):Length() <= 15) and blotmaybe:GetSprite().Offset.Y > - 25 and mod:GetEntityData(blotmaybe).downvelocity > 0 then
					npcdata.state = "rileup"
					npcdata.blotprep = false
					blotmaybe:Remove()
					npcdata.blotsfed = npcdata.blotsfed + 1
					npc.HitPoints = npc.HitPoints + 10
					local effect = Isaac.Spawn(1000,16,4,npc.Position+Vector(0,-20),Vector.Zero,npc)
					effect.Color = mod.ColorDankBlackReal
					effect.SpriteScale = Vector(0.7,0.7)
					break
				end
			end
		end
	elseif npcdata.state == "shoot" then
		npcdata.blotprep = false
		mod:spritePlay(sprite, "shoot")
		npc.Velocity = mod:Lerp(npc.Velocity, Vector(0,0), 0.6)
		if sprite:IsFinished("shoot") then
			npcdata.state = "idle"
			mod:boilersetshottimer(npcdata)
		end
	elseif npcdata.state == "rileup" then
		npcdata.blotprep = false
		mod:spritePlay(sprite, "rileup")
		npc.Velocity = mod:Lerp(npc.Velocity, Vector(0,0), 0.75)
		if sprite:IsFinished("rileup") then
			npcdata.shoottimer = 0
			npcdata.state = "wait"
		end
	elseif npcdata.state == "wait" then
		mod:spritePlay(sprite, "idle")
		npc.Velocity = mod:Lerp(npc.Velocity, Vector(0,0), 0.8)
		local isboiler = false
		for _, otherboilermaybe in ipairs(Isaac.GetRoomEntities()) do
			if otherboilermaybe.Type == Isaac.GetEntityTypeByName("Boiler") and otherboilermaybe.Variant == Isaac.GetEntityVariantByName("Boiler") and (not otherboilermaybe == npc) then
				isboiler = true
				if mod:GetEntityData(otherboilermaybe).shoottimer ~= nil and mod:GetEntityData(otherboilermaybe).shoottimer == 0 then
					npcdata.state = "idle"
					npcdata.shoottimer = math.random(3, 7)
				end
			end
		end
		if not isboiler then
			npcdata.state = "idle"
			npcdata.shoottimer = math.random(3, 7)
		end
	end
	if sprite:IsEventTriggered("shoot") then
		npc:PlaySound(SoundEffect.SOUND_SLOTSPAWN,0.7,0,false, 1.5)
		for i = 0, 315, 45 do
			local projectile = mod:LazySpawnProjectile(0, 0, npc.Position, Vector(5,0):Rotated(i), npc):ToProjectile();
				projectile.FallingSpeed = -0.1
				projectile.FallingAccel = -0.1
				projectile.Color = mod.ColorDankBlackReal
			if i % 90 == 0 then
				projectile.Scale = 1.75
				projectile.Velocity = Vector(7.5, 0):Rotated(i)
			else
				projectile.Scale = 1
			end
		end
	end
	if sprite:IsEventTriggered("whistle") then
		npc:PlaySound(mod.Sounds.SteamTrainWhistle,0.4,0,false, 1.5)
	end
	if sprite:IsEventTriggered("land") then
		npc:PlaySound(SoundEffect.SOUND_SLOTSPAWN,0.4,0,false, 1)
	end
	if npc:IsDead() then
		for i = 0, 315, 45 do
			local projectile = mod:LazySpawnProjectile(0, 0, npc.Position, Vector(5,0):Rotated(i), npc):ToProjectile();
				projectile.FallingSpeed = -0.1
				projectile.FallingAccel = -0.1
				projectile.Color = mod.ColorDankBlackReal
			if not (i % 90 == 0) then
				projectile.Scale = 1.75
				projectile.Velocity = Vector(7.5, 0):Rotated(i)
			else
				projectile.Scale = 1
			end
		end
		Isaac.Explode(npc.Position, npc, 5)
	end
end