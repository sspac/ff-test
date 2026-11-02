local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

function mod:sniffleAI(npc)
	local room = game:GetRoom()
	local path = npc.Pathfinder
	local d = mod:GetEntityData(npc)
	local sprite  = npc:GetSprite()
	local params = ProjectileParams()
	local target = npc:GetPlayerTarget()

	local speed = 6
	local acc = 0.2
	local attackint = 40
	if npc.Variant == mod.FF.DryWheeze.Var then
		attackint = 52
	end
	local projspeed = 10

	if npc.Variant == 10 and not d.init then
		d.init = true
		npc:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
	end

		if target.Position.X < npc.Position.X then
			sprite.FlipX = true
		else
			sprite.FlipX = false
		end

		if npc.Velocity:Length() > 1 then
			if math.abs(npc.Velocity.Y) > math.abs(npc.Velocity.X) and not npc.Variant == mod.FF.DryWheeze.Var then
					if npc.Variant == 0 then
						mod:spritePlay(sprite, "WalkVert")
					--[[elseif npc.Variant == 10 then
						if npc.Velocity.Y < 0 then
							mod:spritePlay(sprite, "WalkUp")
						else
							mod:spritePlay(sprite, "WalkDown")
						end]]
					end
				else
					if npc.Velocity.X < 0 then
						if sprite.FlipX then
							mod:spritePlay(sprite, "WalkRight")
						else
							mod:spritePlay(sprite, "WalkLeft")
						end
					else
						if sprite.FlipX then
							mod:spritePlay(sprite, "WalkLeft")
						else
							mod:spritePlay(sprite, "WalkRight")
						end
					end
				end
			else
				if npc.Variant == 0 then
					sprite:SetFrame("WalkVert", 0)
				elseif npc.Variant == 10 then
					sprite:SetFrame("WalkRight", 0)
				end
			end
		--FindGridPath(npc, target.Position + target.Velocity*15, speed, acc, false, 100, false, false)

		local targetpos = mod:confusePos(npc, target.Position)
			local distanceabs = npc.Position:Distance(targetpos)

			if (not mod:isScareOrConfuse(npc)) and distanceabs < 250 and room:CheckLine(npc.Position,targetpos,0,3,false,false) then
				local extravec = 0
				if distanceabs < 175 then
					extravec = distanceabs / 3
				end

				local gangang = 145
				if not d.rotang then
					d.rotang = gangang + (target.Position - npc.Position):GetAngleDegrees()
				else
					if math.abs(math.abs(d.rotang) - math.abs(gangang + (target.Position - npc.Position):GetAngleDegrees())) > 1 then
						d.rotang = gangang + (target.Position - npc.Position):GetAngleDegrees()
					end
				end

				local tpa = target.Position
				--tpa = target.Position + (target.Position - npc.Position):Resized(distanceabs + extravec):Rotated(90+targdistance:GetAngleDegrees())
				tpa = target.Position + (target.Position + npc.Position):Resized(distanceabs + extravec):Rotated(d.rotang)



				--Isaac.ConsoleOutput((target.Position + npc.Position):GetAngleDegrees() .. "\n")
				--Isaac.ConsoleOutput(90 % 13.2 .. "\n")

				if npc.Position:Distance(tpa) > 10 then
					d.targetvelocity = (tpa - npc.Position):Resized(speed)
					npc.Velocity = mod:Lerp(d.targetvelocity, npc.Velocity, 0.8)
				else
					npc.Velocity = npc.Velocity * 0.8
				end

			else
				if room:CheckLine(npc.Position,targetpos,0,1,false,false) or mod:isScare(npc) then
					d.targetvelocity = mod:reverseIfFear(npc, (targetpos - npc.Position):Resized(speed))
					npc.Velocity = mod:Lerp(d.targetvelocity, npc.Velocity, 0.8)
				else
					 mod:CatheryPathFinding(npc, targetpos, {
						Speed = speed,
						Accel = acc,
						Interval = 1,
						GiveUp = true
					 })
				end
			end

	if npc.State == NpcState.STATE_MOVE then
		sprite:PlayOverlay("Head", true)
		if npc.StateFrame > attackint and math.random(3) == 1 and room:CheckLine(npc.Position, target.Position + target.Velocity*5,3,1,false,false)
				and not mod:isScareOrConfuse(npc) and not (mod:isFriend(npc) and target:ToPlayer()) then
			npc.StateFrame = 0
			npc.State = NpcState.STATE_ATTACK
		end

	elseif npc.State == NpcState.STATE_ATTACK then
		if npc.Variant == 0 then
				--npc.Velocity = Vector.Zero + (npc.Velocity * 0.6)
				--sprite:SetFrame("WalkVert", 0)
			if sprite:IsOverlayFinished("Shoot") then
				npc.StateFrame = 0
				npc.State = NpcState.STATE_MOVE
			elseif npc.StateFrame == 2 then
				npc:PlaySound(mod.Sounds.SniffleShoot,1,0,false,math.random(9,11)/10)
			elseif npc.StateFrame == 7 then
				params.Scale = 1
				params.FallingSpeedModifier = 0
				params.FallingAccelModifier = 0
				local targcoord = mod:intercept(npc, target, projspeed)
				local shootvec = targcoord:Normalized() * projspeed
				npc:FireProjectiles(npc.Position, shootvec, 0, params)
			else
				mod:spriteOverlayPlay(sprite, "Shoot")
			end
		elseif npc.Variant == 10 then
			npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.4)
			if sprite:IsOverlayFinished("Shoot") then
				npc.StateFrame = 0
				npc.State = NpcState.STATE_MOVE
			elseif npc.StateFrame == 2 then
				npc:PlaySound(mod.Sounds.SniffleShoot,1,0,false,math.random(9,11)/10)
			elseif npc.StateFrame == 7 then
				local targcoord = mod:intercept(npc, target, projspeed)
				local shootvec = targcoord:Normalized() * projspeed
				local proj = mod:LazySpawnProjectile(1, 0, npc.Position, shootvec, npc):ToProjectile()
				proj.Scale = 1
				proj.FallingSpeed = 0
				proj.FallingAccel = 0
				mod:GetEntityData(proj).projType = "DryWheeze"
				mod:GetEntityData(proj).rand = npc:GetDropRNG()
				mod:GetEntityData(proj).target = target
				local pSprite = proj:GetSprite()
				pSprite:Load("gfx/projectiles/skull_shot.anm2", true)
				if mod:CheckStage("Ashpit", {46,59}) then
					pSprite:ReplaceSpritesheet(0, "gfx/projectiles/skull_shot_ashpit.png")
					pSprite:LoadGraphics()
				end
				if mod:isFriend(npc) then
					proj.ProjectileFlags = proj.ProjectileFlags | ProjectileFlags.CANT_HIT_PLAYER | ProjectileFlags.HIT_ENEMIES
					mod:GetEntityData(proj).friend = true
					pSprite:Play("friendly", true)
				elseif mod:isCharm(npc) then
					proj.ProjectileFlags = proj.ProjectileFlags | ProjectileFlags.HIT_ENEMIES
					mod:GetEntityData(proj).charm = true
					pSprite:Play("friendly", true)
				else
					pSprite:Play("spin", true)
				end
				proj:Update()
			else
				mod:spriteOverlayPlay(sprite, "Shoot")
			end
		end
	else
		npc.State = NpcState.STATE_MOVE
		sprite:PlayOverlay("Head", true)
	end
	npc.StateFrame = npc.StateFrame + 1
end

function mod.dryWheezeProj(v, d)
	if d.projType == "DryWheeze" then
		if v:IsDead() then
			sfx:Play(SoundEffect.SOUND_BONE_BREAK, 0.6, 0, false, math.random(80, 120)/100)
			for i=0,2 do
				local dir
				if i==0 then
					dir = (d.target.Position-v.Position):Resized(1+(20+d.rand:RandomInt(20))/10)
				else
					dir = RandomVector()*((2*i)+d.rand:RandomInt(20*i)/10)
				end
				local proj = mod:LazySpawnProjectile(1, 0, v.Position, dir, v):ToProjectile()
				if math.random(2) == 1 then
					local sprite = proj:GetSprite()
					sprite:Load("gfx/002.030_black tooth tear.anm2", true)
					sprite:ReplaceSpritesheet(0, "gfx/projectiles/white_tooth.png")
					sprite:LoadGraphics()
					sprite:Play("Tooth2Move", false)
					mod:GetEntityData(proj).tooth = true
				end
				proj.FallingAccel = (d.rand:RandomInt(10)+8)/10
				proj.FallingSpeed = -(30+d.rand:RandomInt(120))/5
				if d.friend then
					proj.ProjectileFlags = proj.ProjectileFlags | ProjectileFlags.CANT_HIT_PLAYER | ProjectileFlags.HIT_ENEMIES
				elseif d.charm then
					proj.ProjectileFlags = proj.ProjectileFlags | ProjectileFlags.HIT_ENEMIES
				end
				proj:Update()
			end
		end
	end
end

--Run Sniffle AI
function mod:checkSniffle(npc)
	mod:sniffleAI(npc)
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkSniffle, mod.FF.Sniffle.ID)
