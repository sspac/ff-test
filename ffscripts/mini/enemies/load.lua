local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector(0, 0)

--load ai - a massive pile of poo that spits an ipecac-esque turdball at isaac
function mod:loadai(npc, sprite, npcdata, var)
	--aesthetics
	mod:rancid(npc, 60, 180, 8, mod.rancidtable)
	--movement code
	local target = npc:GetPlayerTarget().Position;
	--initialize variables
	if not npcdata.init then
		npcdata.angle = math.atan((target.Y-npc.Position.Y)/(target.X-npc.Position.X));
		npcdata.anglevel = 0;
		npcdata.state = "move";
		npcdata.heavytimer = 0;
		npcdata.heavyangle = math.random(0,359);
		npcdata.heavypositionlast = npc.Position;
			if var == 11 then
			npcdata.shotdelay = math.random(30,60);
			else
			npcdata.shotdelay = math.random(30,90);
			end
		npcdata.npcstate = "slide";
		npcdata.init = true
		if npc.State ~= 11 then
			npc.State = 4
		end
		if var == mod.FF.CornLoad.Var then
			npc.SplatColor = mod.ColorBrowniePoop
		else
			npc.SplatColor = mod.ColorPoop
		end
		npcdata.StateFrame = 0
		npcdata.waitwhat = 0
		if npc.Variant == 10 then
			npc:SetSize(24, Vector(1, 0.75), 36);
		end
	end
	--event handling
	if (sprite:IsEventTriggered("splurchnoise")) then
		npc:PlaySound(SoundEffect.SOUND_MEAT_JUMPS,1,2,false,0.7)
	end
	if (sprite:IsEventTriggered("vomit")) then
		npc:PlaySound(SoundEffect.SOUND_BOSS_SPIT_BLOB_BARF,1,2,false,1.3)
		local constant = 0.025
		local shotspeed = Vector(target.X-npc.Position.X, target.Y-npc.Position.Y)*constant
		--fire the projectile
		local projvar
		if var == 11 then projvar = 5 else projvar = 3 end
		local projectile = mod:LazySpawnProjectile(projvar, 0, npc.Position, shotspeed, npc):ToProjectile();
		local projdata = mod:GetEntityData(projectile);
		projectile.FallingSpeed = -45;
		projectile.FallingAccel = 1.5;
		projectile.Scale = 2;
		projdata.special = "loadshot";
		if var == 11 then
			projectile.Scale = 2
			projdata.special2 = true
		end
		--spawn some flies for funsies
		local flynumber = math.random(3,5);
		for i=1, flynumber, 1 do
			Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TINY_FLY, 0, npc.Position, Vector((math.random()+math.random(3,5)),0):Rotated(math.random(0,359)), npc);
		end

	end

	if npc:IsDead() then
		npc.State = 17
	end

	if npc.State == 17 then
		npc.Velocity = nilvector;
		if sprite:IsFinished("death") then
			for i = 1, 15 do
				local bugcheck = math.random(1,6);
				Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.bugtable[bugcheck], 0, npc.Position, (RandomVector()*(math.random()+math.random(5,12))), npc);
			end
			npc:Kill()
		elseif not sprite:IsPlaying("death") then
		sprite:Play("death", true);
		end
	elseif npc.State == 4 then
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
		if npcdata.npcstate == "slide" then
			npcdata.StateFrame = npcdata.StateFrame + 1
			if npc:HasEntityFlags(EntityFlag.FLAG_FEAR) or npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION) then
				npcdata.StateFrame = npcdata.StateFrame - 1
			end
			if var == 11 then
				mod:heavymovement(npc, npcdata, 2, 0.01, 30, 90)
			else
				mod:heavymovement(npc, npcdata, 0.75, 0.05, 60, 180);
			end

			if npc:HasEntityFlags(EntityFlag.FLAG_FEAR) then
				local vec = (target - npc.Position + RandomVector():Resized(1.5)):Resized(-2.5)
				npc.Velocity = mod:Lerp(npc.Velocity, vec, 0.2)
			end

			if npcdata.StateFrame > npcdata.waitwhat + npcdata.shotdelay then
				npcdata.npcstate = "fire";
				npcdata.waitwhat = 60
				if var == 11 then
					npcdata.shotdelay = math.random(0,60);
				else
					npcdata.shotdelay = math.random(0,60);
				end
			end
			if not sprite:IsPlaying("idle") then
				sprite:Play("idle", true);
			end
		elseif npcdata.npcstate == "fire" then
			if sprite:IsFinished("fire") then
					npcdata.npcstate = "slide";
					npcdata.StateFrame = 0
					sprite:SetFrame("idle", 1);
			elseif not sprite:IsPlaying("fire") then
				sprite:Play("fire", true);
			end
			--slow down!
			if var == 11 then
				npc.Velocity = npc.Velocity * 0.8
			else
				npc.Velocity = npc.Velocity * 0.33;
			end
		end
	end
	if var == 11 then
	npc.Friction = 1.2
	if npc.FrameCount % (#mod.creepSpawnerCount * 5 + 5) == 1 then
		local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_SLIPPERY_BROWN, 0, npc.Position, nilvector, npc):ToEffect();
			creep.SpriteScale = Vector(2, 1.5);
			creep:Update()
		end
	end
end