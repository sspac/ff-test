local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector(0, 0)

function mod:skuzzballai(npc, sprite, npcdata)
	if not npcdata.init then
		npcdata.init = true
		sprite.Offset = Vector(0, 0)
		npcdata.jumpytimer = math.random(40, 80)
		npcdata.state = "idle"
		npcdata.stateframe = 0
		npcdata.lookdown = "not"
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
		npcdata.spidernumber = 6
		npcdata.spiderlist = {0, 6, 12, 18, 24, 30}
		npcdata.size = "big"
		npcdata.jumpsize = "big"
		npcdata.jumpstartdone = false
		npcdata.isCorpse = mod:CheckStage("Corpse", {34,43,44})
		--check bursting
		for _, player in ipairs(Isaac.FindByType(1, -1, -1, false, false)) do
			player = player:ToPlayer()
			if player:HasCollectible(CollectibleType.COLLECTIBLE_BURSTING_SACK) then
				npc.CollisionDamage = 0
				npcdata.bursting = 1
			end
		end
	end
	local isCorpse = npcdata.isCorpse
	if npcdata.state == "idle" then
		npcdata.stateframe = npcdata.stateframe + 1;
		mod:spritePlay(sprite, "idle")
		if npcdata.stateframe >= npcdata.jumpytimer then
			npcdata.state = "jumpprep"
			npcdata.stateframe = 0
			mod:spritePlay(sprite, "jumpprep")
		end
		npc.Velocity = mod:Lerp(npc.Velocity, Vector(0,0), 0.8)
	elseif npcdata.state == "jumpprep" then
		mod:spritePlay(sprite, "jumpprep")
		npc.Velocity = mod:Lerp(npc.Velocity, Vector(0,0), 0.9)
	elseif npcdata.state == "jump" then
		if npcdata.jumpsize == "big" then
		npcdata.stateframe = npcdata.stateframe + 4;
		sprite.Offset = Vector(0, -2 * (-0.01 * ((npcdata.stateframe - 60)^2) + 45))
		else
		npcdata.stateframe = npcdata.stateframe + 5;
		sprite.Offset = Vector(0, -1.5 * (-0.01 * ((npcdata.stateframe - 60)^2) + 45))
		end
		if npcdata.stateframe <= 60  then
			if npcdata.jumpstartdone then
				mod:spritePlay(sprite, "jumpup")
			else
				mod:spritePlay(sprite, "jumpstart")
				if sprite:IsFinished("jumpstart") then
					npcdata.jumpstartdone = true
				end
			end
		elseif npcdata.lookdown == "not" or npcdata.lookdown == "shift" then
			npcdata.lookdown = "shift"
			mod:spritePlay(sprite, "jumpshift")
		else
			mod:spritePlay(sprite, "jumpdown")
			npcdata.lookdown = "yes"
		end
		if sprite:IsFinished("jumpshift") then
			npcdata.lookdown = "yes"
		end
		if sprite.Offset.Y >= 0 then
			npcdata.state = "land"
			npc:PlaySound(SoundEffect.SOUND_MEAT_IMPACTS,1,2,false,1.3)
			npcdata.stateframe = 0
			sprite.Offset = Vector(0, 0)
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
			mod:spritePlay(sprite, "land")
			npcdata.lookdown = "not"
		end
	elseif npcdata.state == "land" then
		mod:spritePlay(sprite, "land")
		npc.Velocity = mod:Lerp(npc.Velocity, Vector(0,0), 0.5)
	end
	if sprite:IsFinished("jumpprep") then
		npcdata.state = "jump"
		npc:PlaySound(SoundEffect.SOUND_MEAT_JUMPS,1,2,false,1.4)
		npcdata.stateframe = 0;
		local feard = 0
		if npc:HasEntityFlags(EntityFlag.FLAG_FEAR) then
			feard = 50
		end
		local targetpos = mod:chooserandomlocationforskuzz(npc, 150 + (feard / 2), 50 + feard, not (npc:HasEntityFlags(EntityFlag.FLAG_FEAR) or npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION)))
		local lengthto = targetpos - npc.Position
		npcdata.jumpsize = npcdata.size
		if npcdata.jumpsize == "big" then
			npc.Velocity = Vector(lengthto.X / 30 , lengthto.Y / 30) * 0.90
		else
			npc.Velocity = Vector(lengthto.X / 18 , lengthto.Y / 18) * 0.90
		end
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		npc.GridCollisionClass = GridCollisionClass.COLLISION_NONE
	end
	if sprite:IsFinished("land") then
		npcdata.stateframe = 0
		npcdata.state = "idle"
		if npcdata.jumpsize == "big" then
			npcdata.jumpytimer = math.random(45, 70)
		else
			npcdata.jumpytimer = math.random(30, 45)
		end
	end
	--spider logic
	if npc:IsDead() then
		for i = npcdata.spidernumber, 1, -1 do
			EntityNPC.ThrowSpider(npc.Position, npc, mod:chooserandomlocationforskuzz(npc, 100, 50), false, 0)
		end
		mod.spawnent(npc, npc.Position, Vector(0,0), 666, 60, 0)
		for i = 1, math.random(4, 7), 1 do
			local gibs = Isaac.Spawn(1000, 5, 0, npc.Position, RandomVector()*(math.random(4, 7)), npc):ToEffect();
			gibs:GetSprite():Load("gfx/enemies/skuzzball/skuzzgib.anm2",true)
			if isCorpse then
				gibs:GetSprite():ReplaceSpritesheet(0, "gfx/enemies/skuzzball/skuzzgib_corpse.png")
			else
				gibs:GetSprite():ReplaceSpritesheet(0, "gfx/enemies/skuzzball/skuzzgib.png")
			end
			gibs:GetSprite():LoadGraphics()
			gibs:Update()
		end
		for i = 1, 2, 1 do
			local gibs = Isaac.Spawn(1000, 5, 3, npc.Position, RandomVector()*(math.random(3, 7)), npc):ToEffect();
			gibs:GetSprite():Load("gfx/enemies/skuzzball/skuzzgib.anm2",true)
			if isCorpse then
				gibs:GetSprite():ReplaceSpritesheet(0, "gfx/enemies/skuzzball/skuzzgib_corpse.png")
			else
				gibs:GetSprite():ReplaceSpritesheet(0, "gfx/enemies/skuzzball/skuzzgib.png")
			end
			gibs:GetSprite():LoadGraphics()
			gibs:Update()
		end
	else
		for i = npcdata.spidernumber, 1, -1 do
			if npc.HitPoints < npcdata.spiderlist[i] then
				npcdata.spidernumber = npcdata.spidernumber - 1
				EntityNPC.ThrowSpider(npc.Position, npc, mod:chooserandomlocationforskuzz(npc, 100, 50), false, 0)
				for _ = 1, math.random(2, 4), 1 do
					local gibs = Isaac.Spawn(1000, 5, 0, npc.Position, RandomVector()*(math.random(3, 6)), npc):ToEffect();
					gibs:GetSprite():Load("gfx/enemies/skuzzball/skuzzgib.anm2",true)
					if isCorpse then
						gibs:GetSprite():ReplaceSpritesheet(0, "gfx/enemies/skuzzball/skuzzgib_corpse.png")
					else
						gibs:GetSprite():ReplaceSpritesheet(0, "gfx/enemies/skuzzball/skuzzgib.png")
					end
					gibs:GetSprite():LoadGraphics()
					gibs:Update()
				end
			end
		end
	end
	--size logic
	if npc.HitPoints <= (npc.MaxHitPoints / 2) and npcdata.size == "big" then
		npcdata.size = "small"
		sprite:Load("gfx/enemies/skuzzball/skuzzballsmall.anm2",true)
		if isCorpse then
			mod:ReplaceEnemySpritesheet(npc, "gfx/enemies/skuzzball/skuzzballsmall_corpse", 0)
		else
			mod:ReplaceEnemySpritesheet(npc, "gfx/enemies/skuzzball/skuzzballsmall", 0)
		end
		if not npcdata.state == "jump" then
			npcdata.state = "land"
			mod:spritePlay(sprite, "land")
		end
		for i = 1, math.random(4, 7), 1 do
			local gibs = Isaac.Spawn(1000, 5, 0, npc.Position, RandomVector()*(math.random(4, 7)), npc):ToEffect();
			gibs:GetSprite():Load("gfx/enemies/skuzzball/skuzzgib.anm2",true)
			if isCorpse then
				gibs:GetSprite():ReplaceSpritesheet(0, "gfx/enemies/skuzzball/skuzzgib_corpse.png")
			else
				gibs:GetSprite():ReplaceSpritesheet(0, "gfx/enemies/skuzzball/skuzzgib.png")
			end
			gibs:GetSprite():LoadGraphics()
			gibs:Update()
		end
	end
end