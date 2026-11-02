local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector(0, 0)

function mod:wobblesai(npc, sprite, npcdata)
	local target = npc:GetPlayerTarget()
	local targetpos = target.Position

	if not npcdata.init then
		npcdata.init = true;
		npcdata.state = "idle";
		npcdata.paddling = false;
		npcdata.statetimer = math.random(20, 30);
		npcdata.paddletarget = npc.Position;
		npcdata.inflated = false;
		npcdata.inflatecount = math.random(1, 3);
		npcdata.confvector = nil
		--npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
		npcdata.radius = 13;

		if (targetpos.X >= npc.Position.X) then
			sprite.FlipX = true;
		else
			sprite.FlipX = false;
		end
	end



	if npcdata.state == "idle" then
		mod:spritePlay(sprite, "idle");
		npcdata.statetimer = npcdata.statetimer - 1;
		if (npc:HasEntityFlags(EntityFlag.FLAG_FEAR) or npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION)) then
			npcdata.statetimer = npcdata.statetimer - 1;
		end
		if npcdata.statetimer <= 0 then
			if npcdata.inflatecount <= 0 and not npc:HasEntityFlags(EntityFlag.FLAG_FEAR) then
				npcdata.state = "inflatepaddle"
				npcdata.paddletarget = targetpos;

				npcdata.confvector = RandomVector()

				if (targetpos.X >= npc.Position.X) then
					sprite.FlipX = true;
				else
					sprite.FlipX = false;
				end
			else
				npcdata.state = "paddle"
				npcdata.paddletarget = targetpos;

				npcdata.confvector = RandomVector()
				if npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION) then
					targetpos = npcdata.confvector
				end

				if (targetpos.X >= npc.Position.X) then
					sprite.FlipX = true;
				else
					sprite.FlipX = false;
				end

				if npc:HasEntityFlags(EntityFlag.FLAG_FEAR) then
					sprite.FlipX = not sprite.FlipX
				end

			end
		end
	elseif npcdata.state == "paddle" then
		mod:spritePlay(sprite, "paddle");
		if sprite:IsFinished("paddle") then
			mod:spritePlay(sprite, "idle");
			npcdata.state = "idle";
			npcdata.statetimer = math.random(20, 30);
			npcdata.inflatecount = npcdata.inflatecount - 1;
		end
	elseif npcdata.state == "inflatepaddle" then
		mod:spritePlay(sprite, "inflatepaddle");
		if sprite:IsFinished("inflatepaddle") then
			npcdata.state = "inflated";
			npcdata.statetimer = math.random(45, 60);
			npcdata.inflatecount = npcdata.inflatecount - 1;
		end
	elseif npcdata.state == "inflated" then

		if npc.Velocity.X > 0 then
			sprite.FlipX = true;
		else
			sprite.FlipX = false;
		end

		if npcdata.statetimer > 0 then
			mod:spritePlay(sprite, "inflatedidle")
			npcdata.statetimer = npcdata.statetimer - 1;
			if (npc:HasEntityFlags(EntityFlag.FLAG_FEAR) or npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION)) then
				npcdata.statetimer = npcdata.statetimer - 3;
			end
		else
			mod:spritePlay(sprite, "deflate");
			if sprite:IsFinished("deflate") then
				npcdata.state = "idle";
				npcdata.statetimer = math.random(30, 40);
				npcdata.inflatecount = math.random(1, 3);
			end
		end
	end

	if npcdata.inflated == true then
		npc.Velocity = mod:Lerp(npc.Velocity, npc.Velocity:Resized(0.5), 0.05)
	elseif npcdata.paddling == true then
		npc.Velocity = mod:Lerp(npc.Velocity, npc.Velocity:Resized(0.25), 0.075)
	else
		npc.Velocity = mod:Lerp(npc.Velocity, npc.Velocity:Resized(0.25), 0.15)
	end

	if sprite:IsEventTriggered("paddle") then
		npc.Velocity = (npcdata.paddletarget - npc.Position):Resized(math.random(10, 12));
		if npc:HasEntityFlags(EntityFlag.FLAG_FEAR) then
			npc.Velocity = npc.Velocity * -1
		elseif npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION) then
			if npcdata.confvector then
				npc.Velocity = npcdata.confvector:Resized(npc.Velocity:Length())
			end
		end
		npcdata.paddling = true;
		npc:PlaySound(SoundEffect.SOUND_BLOBBY_WIGGLE, 0.5, 0, false, math.random(15, 20)/10);
		if npc.Velocity.X > 0 then
			sprite.FlipX = true;
		else
			sprite.FlipX = false;
		end
	elseif sprite:IsEventTriggered("paddleend") then
		npcdata.paddling = false;
	elseif sprite:IsEventTriggered("collision32") then
		npc:SetSize(32, Vector(1, 0.5), 15);
		npcdata.radius = 32;
	elseif sprite:IsEventTriggered("collision26") then
		npc:SetSize(26, Vector(1, 0.75), 18);
		npcdata.radius = 26;
		if sprite:IsPlaying("deflate") then
			npc:PlaySound(mod.Sounds.BaloonBounce, 1.5, 0, false, 1.5);
		end
	elseif sprite:IsEventTriggered("inflate") then
		npc.Velocity = (npcdata.paddletarget - npc.Position):Resized(math.random(10, 15));
		if npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION) then
			if npcdata.confvector then
				npc.Velocity = npcdata.confvector:Resized(npc.Velocity:Length())
			end
		end
		if npc.Velocity.X > 0 then
			sprite.FlipX = true;
		else
			sprite.FlipX = false;
		end

		npcdata.inflated = true;
		npc:PlaySound(mod.Sounds.Baloon, 1.5, 0, false, 3);
	elseif sprite:IsEventTriggered("deflate") then
		npcdata.inflated = false;
		npc:SetSize(13, Vector(1, 1), 12);
		npcdata.radius = 13;
	end

end