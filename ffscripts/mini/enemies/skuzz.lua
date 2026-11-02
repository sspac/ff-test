local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector(0, 0)

function mod:skuzzai(npc, sprite, npcdata)
	if not npcdata.init then
		npcdata.init = true
		sprite.Offset = Vector(0, 0)
		npcdata.jumpytimer = npcdata.jumpytimer or math.random(45, 90)
		npcdata.state = npcdata.state or "idle"
		npcdata.stateframe = 0
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
		npcdata.bursting = 0
		--check bursting
		for _, player in ipairs(Isaac.FindByType(1, -1, -1, false, false)) do
			player = player:ToPlayer()
			if player:HasCollectible(377) then
				npc.CollisionDamage = 0
				npcdata.bursting = 1
			end
		end
	end
	if npcdata.state == "idle" then
		--set bursting
		if npcdata.bursting == 1 then
			sprite:Load("gfx/enemies/skuzzball/skuzzgriend.anm2",true)
			mod:spritePlay(sprite, "Appear")
			npcdata.bursting = 2
		end
		if not sprite:IsPlaying("land") then
			mod:spritePlay(sprite, "idle")
			npc.Velocity = mod:Lerp(npc.Velocity, Vector(0,0), 0.75)
		elseif sprite:IsFinished("land") then
			mod:spritePlay(sprite, "idle")
		else
			npc.Velocity = mod:Lerp(npc.Velocity, Vector(0,0), 0.4)
		end
		--just in case
		if not npcdata.jumpytimer then
			npcdata.jumpytimer = 250
		end
		if npcdata.jumpytimer <= 0 then
			npcdata.state = "hop"
			npc:PlaySound(SoundEffect.SOUND_FETUS_LAND,0.6,1,false,2.7)
			mod:spritePlay(sprite, "hopstart")
			npcdata.stateframe = 0;
			local feard = 0
			if npc:HasEntityFlags(EntityFlag.FLAG_FEAR) then
				feard = 50
			end
			local targetpos = mod:chooserandomlocationforskuzz(npc, 150 + (feard / 2), 50 + feard, not (npc:HasEntityFlags(EntityFlag.FLAG_FEAR) or npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION)))
			local lengthto = targetpos - npc.Position
			npc.Velocity = Vector(lengthto.X / 15 , lengthto.Y / 15) * 0.90
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			npc.GridCollisionClass = GridCollisionClass.COLLISION_NONE
		else
			npcdata.jumpytimer = npcdata.jumpytimer - 1
		end
	elseif npcdata.state == "hop" then
		if not sprite:IsPlaying("hopstart") then
			mod:spritePlay(sprite, "hop")
		elseif sprite:IsFinished("hopstart") then
			mod:spritePlay(sprite, "hop")
		end
		if npcdata.slingerOverride then
			npc.SpriteOffset = npc.SpriteOffset + Vector(0, npcdata.stateframe / 4 - 6)
		else
			sprite.Offset = Vector(0, -2 * (-0.025 * ((npcdata.stateframe - 30)^2) + 29.5))
		end
		if sprite.Offset.Y > 0 then
			sprite.Offset = Vector(0,0)
			npcdata.state = "idle"
			mod:spritePlay(sprite, "land")
			npc:PlaySound(SoundEffect.SOUND_FETUS_LAND,0.6,1,false,1.7)
			npcdata.jumpytimer = math.random(75, 120)
			npcdata.slingerOverride = false
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
		else
		npcdata.stateframe = npcdata.stateframe + 4
		end
	else
		npcdata.state = "idle"
	end
end