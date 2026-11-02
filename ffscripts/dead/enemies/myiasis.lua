local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector(0, 0)

function mod:RemapValue(value, valLow, valHigh, toLow, toHigh)
	return toLow + (value - valLow) * (toHigh - toLow) / (valHigh - valLow)
end

function mod:FistuloidMovement(npc, targpos, d, speed, sinlength, ampmin, ampmax)
	-- fun fact, i stole this fistuloid movement code from rev's aerotoma, which i also wrote
	-- fun fact 2: i stole aerotoma's movement code from a screenshot kil posted on the binding of isaac server
	-- https://discord.com/channels/123641386921754625/123961790529929218/400246736863363073
	-- pretty cool right?
	d.offset = d.offset or math.random()

	local wave = mod:PeriodicSine(npc.FrameCount, sinlength, d.offset)

	if not d.maxamplitude or math.abs(wave) < 0.1 then
		if not d.maxamplitude or not d.changedamplitude then
			d.maxamplitude = math.random(ampmin, ampmax)
			d.changedamplitude = true
		end
	elseif d.maxamplitude then
		d.changedamplitude = nil
	end

	local diff = targpos - npc.Position
	local dist = diff:Length()

	-- sin wave movement that gets smaller the closer **NOT AEROTOMA** is to the target, with a little rng thrown in via changing max amplitude whenever the wave resets.
	local amplitude = mod:RemapValue(dist, 200, 1000, d.maxamplitude, 0)
	local dir = diff / dist

	dir = dir:Rotated(wave * amplitude)
	npc.Velocity = dir * speed

	return dist
end

function mod:myiasisAI(npc, sprite, d)
	local room = game:GetRoom()
	if not d.init then
		if npc.SubType == 1 then
			d.state = "nohead"
			d.acceptingFellows = true
			npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			sprite:Play("AppearHeadless", true)
			Isaac.Spawn(1000, EffectVariant.POOF01, 0, npc.Position, nilvector, npc)
		else
			d.state = "idle"
			d.wormsource = npc
		end

		d.init = true
	end

	if d.state == "idle" then
		local target = npc:GetPlayerTarget()
		local targPos, distSquared
		targPos = target.Position
		for i = 45, 405, 90 do
			local targ = target.Position + Vector.FromAngle(i) * 40
			local dist = npc.Position:DistanceSquared(targ)
			if (not distSquared or dist < distSquared) and room:IsPositionInRoom(targ, 0) then
				targPos = targ
			end
		end

		local dist = mod:FistuloidMovement(npc, targPos, d, 2.5, 60, 40, 70)

		sprite.FlipX = npc.Velocity.X > 0

		if not d.cooldown then
			d.cooldown = math.random(20, 40)
		end

		d.cooldown = d.cooldown - 1
		if d.wormsource and GetPtrHash(npc) ~= GetPtrHash(d.wormsource) and (d.wormsource:IsDead() or not d.wormsource:Exists()) then -- where'd my head go?!
			local explosion = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0, npc.Position, Vector(0, 0), npc)
			explosion.PositionOffset = Vector(0, -10)
			d.state = "nohead"
			d.cooldown = nil
			d.wormsource = nil
			d.acceptingFellows = true
			sprite:Play("Idle02", true)
		elseif d.cooldown <= 0 and dist <= 150 and (dist <= 80 or ((npc.Position - target.Position):GetAngleDegrees() % 45 < 30)) then
			--print(dist)
			d.state = "shoot"
			d.cooldown = nil

			sprite.FlipX = target.Position.X > npc.Position.X
			if target.Position.Y < npc.Position.Y then
				if sprite.FlipX then
					d.shootdir = Vector.FromAngle(315)
				else
					d.shootdir = Vector.FromAngle(225)
				end

				d.anim = "Attack02"
			else
				if sprite.FlipX then
					d.shootdir = Vector.FromAngle(45)
				else
					d.shootdir = Vector.FromAngle(135)
				end

				d.anim = "Attack01"
			end

			sprite:Play(d.anim, true)
		else
			mod:spritePlay(sprite, "Idle01")
		end
	elseif d.state == "shoot" then
		npc.Velocity = -d.shootdir
		if sprite:IsEventTriggered("Shoot") then
			npc:PlaySound(SoundEffect.SOUND_MONSTER_ROAR_0,1,1,false,1.8)
			local pro = Isaac.Spawn(mod.FF.MyiasisProj.ID, mod.FF.MyiasisProj.Var, 0, npc.Position + d.shootdir * 20, d.shootdir * 14, npc)
			pro:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			mod:GetEntityData(pro).direction = d.shootdir
			mod:GetEntityData(pro).myiasis = d.wormsource
			pro.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS

            local anim = "Up"
			if d.shootdir.Y > 0 then
				anim = "Down"
			end

			pro:GetSprite():Play(anim, true)
			pro:GetSprite().FlipX = sprite.FlipX
			mod:GetEntityData(pro).anim = anim
			d.acceptingFellows = true
		end

		if sprite:IsFinished(d.anim) then
			d.state = "nohead"
		end
	elseif d.state == "nohead" then
		--Copying this over cos i'm lazy okay, just want this fixed
		if d.wormsource and GetPtrHash(npc) ~= GetPtrHash(d.wormsource) and (d.wormsource:IsDead() or not d.wormsource:Exists()) then -- where'd my head go?!
			local explosion = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0, npc.Position, Vector(0, 0), npc)
			explosion.PositionOffset = Vector(0, -10)
			d.cooldown = nil
			d.wormsource = nil
			d.acceptingFellows = true
			sprite:Play("Idle02", true)
		end
		if sprite:IsPlaying("AppearHeadless") then
			npc.Velocity = nilvector
		elseif (sprite:IsPlaying("Recover01") or sprite:IsPlaying("Recover02")) and not d.acceptingFellows then
			npc.Velocity = npc.Velocity * 0.8
		elseif (sprite:IsFinished("Recover01") or sprite:IsFinished("Recover02")) and not d.acceptingFellows then
			d.state = "idle"
		else
			mod:FistuloidMovement(npc, npc:GetPlayerTarget().Position, d, 1.5, 90, 40, 70)
			sprite.FlipX = npc.Velocity.X > 0
			mod:spritePlay(sprite, "Idle02")
		end
	end
end

function mod:myiasisProjectileAI(npc, sprite, d)
	if not d.myiasis or d.myiasis:IsDead() or not d.myiasis:Exists() or mod:isStatusCorpse(d.myiasis) then
		npc:Kill()
		return
	end

	local room = game:GetRoom()

	mod:spritePlay(sprite, d.anim)

	npc.Velocity = d.direction * 14

	npc.Position = room:ScreenWrapPosition(npc.Position, -120)

	if npc.FrameCount > 5 then
		local blubs = Isaac.FindByType(mod.FF.Myiasis.ID, mod.FF.Myiasis.Var, -1, false, false)
		for _, blub in ipairs(blubs) do
			--The old tried and true data flag
			if mod:GetEntityData(blub).acceptingFellows then
				if blub.Position:DistanceSquared(npc.Position) <= (npc.Size + blub.Size + 20) ^ 2 then
					mod:GetEntityData(blub).acceptingFellows = nil
					mod:GetEntityData(blub).wormsource = d.myiasis
					mod:GetEntityData(blub).state = "nohead"

					blub:ToNPC():PlaySound(SoundEffect.SOUND_GOOATTACH0,1,1,false,1)
					if d.anim == "Up" then
						blub:GetSprite():Play("Recover02", true)
					else
						blub:GetSprite():Play("Recover01", true)
					end

					npc:Remove()
					break
				end
			end
		end
	end
end