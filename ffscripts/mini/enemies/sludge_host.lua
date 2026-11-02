local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector(0, 0)

function mod:sludgehostai(npc, sprite, npcdata)
	local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()
	if npcdata.init == nil then
		npcdata.init = true
		npcdata.invul = true
		npcdata.spread = math.random(27, 40)
		npcdata.shooting = false
		npcdata.stateframe = 0;
		npcdata.damagedown = 0;
		npcdata.alreadybombed = false
		npc.SplatColor = mod.ColorDankBlackReal
		npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
	end

	--state stuff
	if sprite:IsFinished("Appear") or sprite:IsFinished("Shoot") then
		mod:spritePlay(sprite, "Idle")
	elseif sprite:IsPlaying("Idle") or sprite:IsFinished("Idle") then
		npcdata.stateframe = npcdata.stateframe + 1;
		if npcdata.stateframe >= 25 and targetdistance <= 175 then
			mod:spritePlay(sprite, "Shoot")
			npcdata.stateframe = 0;
		end
	elseif sprite:IsPlaying("Bombed") or sprite:IsFinished("Bombed") then
		npcdata.damagedown = 0;
		npcdata.stateframe = npcdata.stateframe + 1;
		if (npcdata.stateframe >= 90) then
			mod:spritePlay(sprite, "Idle")
			npcdata.stateframe = 0;
		end
	end

	--stay still!
	npc.Velocity = mod:Lerp(npc.Velocity, Vector(0,0), 0.4)

	--shooting start
	if sprite:IsEventTriggered("shoot") then
		--spawn blots
		if not mod:isScareOrConfuse(npc) then
			npc:PlaySound(SoundEffect.SOUND_GOODEATH,0.7,2,false,0.8)
			if (not mod:isFriend(npc))
			or (mod:isFriend(npc) and mod.GetFriendlyEntityCount(mod.FF.Blot.ID, mod.FF.Blot.Var) < 6)
			then
				for i = npcdata.spread * -1, npcdata.spread, npcdata.spread * 2 do
					local blot = Isaac.Spawn(mod.FF.Blot.ID, mod.FF.Blot.Var, 0, npc.Position, Vector(math.min(0.03 * targetdistance * (math.random(8, 10) / 10), 3.5),0):Rotated(i + targetangle + math.random(-10, 10)), npc):ToNPC()
					local blotdata = mod:GetEntityData(blot)
					--print(blot.Velocity:Length())
					blotdata.downvelocity = -20;
					blotdata.downaccel = 2.5
					blot.Velocity = blot.Velocity * (math.random(12, 20)/7.5)
					blot.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
					blot.GridCollisionClass = GridCollisionClass.COLLISION_NONE
					blot:GetSprite().Offset = Vector(0, -1)
					blotdata.state = "air"
					blot:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				end
			end
		end
		--set shooting true
		npcdata.shooting = true
	elseif sprite:IsEventTriggered("vulnerable") then
		npc:PlaySound(SoundEffect.SOUND_ANIMAL_SQUISH,1,2,false,1)
		npcdata.invul = false
		npcdata.damagedown = 0;
		npc:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET)
		npcdata.alreadybombed = false
	elseif sprite:IsEventTriggered("invulnerable") then
		npc:PlaySound(SoundEffect.SOUND_ANIMAL_SQUISH,1,2,false,0.9)
		npcdata.invul = true
		npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
		--look cool
		if not mod:isScareOrConfuse(npc) then
			local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_BLACK, 0, npc.Position, Vector(0,0), npc):ToEffect();
			creep:Update();
			creep.Size = creep.Size * 2
			creep:GetSprite().Scale = creep:GetSprite().Scale * 2
			for i = 0, math.random(4, 6), 1 do
				local projectile = mod:LazySpawnProjectile(0, 0, npc.Position, RandomVector()  *math.random(2, 5), npc):ToProjectile();
				projectile.FallingSpeed = -30;
				projectile.FallingAccel = 2.5
				projectile.Color = mod.ColorDankBlackReal
				local projdata = mod:GetEntityData(projectile);
				projdata.creeptype = "black"
			end
		end
	elseif sprite:IsEventTriggered("shootstop") then
		npcdata.shooting = false
		npcdata.spread = math.random(27, 40)
	end
	--shooting stuff
	if not mod:isScareOrConfuse(npc) then
		if npcdata.shooting == true then
			mod:Lerp(npcdata.spread, 10, 0.1)
			if npc.FrameCount % math.random(3, 4) == 1 then
				npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT,1,2,false,1)
				local projectile = mod:LazySpawnProjectile(0, 0, npc.Position, Vector(math.min(math.floor(0.075 * targetdistance * (math.random(8, 10) / 10)), 15),0):Rotated(targetangle + math.random(npcdata.spread * -1, npcdata.spread)), npc):ToProjectile();
				projectile.FallingSpeed = -30;
				projectile.FallingAccel = 2.5
				projectile.Color = mod.ColorDankBlackReal
				local projdata = mod:GetEntityData(projectile);
				projdata.creeptype = "black"
			end
		end
		if npc.FrameCount % 30 == 1 then
			local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_BLACK, 0, npc.Position, Vector(0,0), npc):ToEffect()
			creep.SpriteScale = creep.SpriteScale * 1.5
			creep:Update()
		end
	end
end