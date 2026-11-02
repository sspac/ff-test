local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

function mod:slammerAI(npc)
	local room = game:GetRoom()
	local var = npc.Variant
	local path = npc.Pathfinder
	local sprite = npc:GetSprite()
	local npcd = mod:GetEntityData(npc)
	local r = npc:GetDropRNG()

	local entitynpc = npc:ToNPC()
	local target = npc:GetPlayerTarget()
	entitynpc.Target = target

	if room:GetFrameCount() == 0 then
		if mod:isFriend(npc) then
			npc.State = 3
			npcd.IsJumping = nil
		end
	end

	if npc.FrameCount <= 1 and var == 0 and ((REVEL and REVEL.STAGE.Glacier:IsStage()) or npcd.FromIceHazard) then
		npc.SplatColor = Color(0, 0.2, 0.8, 1, 0,20/255,70/255)
		sprite:ReplaceSpritesheet(0, "gfx/enemies/slamboy/slammerNEW_glacier.png")
		sprite:LoadGraphics()
	end

	if npcd.AshLeave and not npcd.unignited then
		if var == 5 or var == 6 then
			if npcd.LastAshSpawn then
				if npc.Position:Distance(npcd.LastAshSpawn) > 10 then
					if var == 5 then
						mod.SpawnAsh(npc, npc.Position)
					elseif var == 6 then
						local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_GREEN, 0, npc.Position, Vector.Zero, npc):ToEffect();
						creep.Timeout = 20
						creep:Update()
					end
					npcd.LastAshSpawn = npc.Position
				end
			else
				if var == 5 then
					mod.SpawnAsh(npc, npc.Position)
				elseif var == 6 then
					local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_GREEN, 0, npc.Position, Vector.Zero, npc):ToEffect();
					creep.Timeout = 20
					creep:Update()
				end
				npcd.LastAshSpawn = npc.Position
			end
		end
	end
	if npcd.IsJumping == 1 then
		npcd.JumpTimer = npcd.JumpTimer or 0
		npcd.JumpTimer = npcd.JumpTimer + 1
		local timerLimit = 60
		npc.Friction = 1
		local dist = (npc.Position - npcd.PlayerPos):Length()
		if dist < 20 or npcd.JumpTimer > timerLimit --[[and npcd.targetVelocity:Length() < 10]] then
			--npcd.targetVelocity = npcd.targetVelocity * 0.3
			npcd.targetVelocity = (npcd.PlayerPos - npc.Position):Resized(5)
			if var == 5 or var == 0 or var == 6 or var == 7 or var == 8 or var == mod.FF.Marzy.Var or var == mod.FF.Flinty.Var then
				npc.State = 9
				npcd.IsJumping = 0
				npcd.targetVelocity = Vector.Zero
			end
		elseif (var == 5 or var == 0 or var == 6) and dist < 40 then
			npcd.targetVelocity = (npcd.PlayerPos - npc.Position):Resized(2)
		else
			if var == 0 or var == 7 then
				npcd.targetVelocity = npcd.targetVelocity + -(npc.Position - npcd.PlayerPos):Normalized() * (dist / 65)
			elseif var == 4 or var == 8 or var == 9 then
				--npcd.targetVelocity = npcd.targetVelocity + Vector(-(npc.Position.X - npcd.PlayerPos.X), -(npc.Position.Y - npcd.PlayerPos.Y)):Normalized() * (dist / 25)
				npcd.targetVelocity = npcd.targetVelocity + -(npc.Position - npcd.PlayerPos):Normalized() * (dist / 25)
			elseif var == 1 then
				npcd.targetVelocity = npcd.targetVelocity + -(npc.Position - npcd.PlayerPos):Normalized() * (dist / 20)
			elseif var == 5 then
				npcd.targetVelocity = npcd.targetVelocity + -(npc.Position - npcd.PlayerPos):Normalized() * (dist / 65)
			elseif var < 4 then
				npcd.targetVelocity = npcd.targetVelocity + Vector(-(npc.Position.X - npcd.PlayerPos.X), -(npc.Position.Y - npcd.PlayerPos.Y)):Normalized() * (dist / 60)
			elseif var == mod.FF.Flinty.Var then
				npcd.targetVelocity = npcd.targetVelocity - (npc.Position - npcd.PlayerPos):Normalized() * (dist / 175)
			else
				npcd.targetVelocity = npcd.targetVelocity + Vector(-(npc.Position.X - npcd.PlayerPos.X), -(npc.Position.Y - npcd.PlayerPos.Y)):Normalized() * (dist / 30)
			end
			local arcvel = npcd.targetVelocity
			if arcvel:Length() >= dist then
				npcd.targetVelocity = arcvel:Resized(dist)
			end
		end
	else
		npcd.targetVelocity = Vector.Zero
		npcd.JumpTimer = nil
	end

	--Init
	if not npcd.init then
		if var > 1 and var < 4 then
			npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_DEATH_TRIGGER | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_FLASH_ON_DAMAGE)
			npc.SplatColor = Color(0.15, 0, 0, 1, 25 / 255, 25 / 255, 25 / 255)
		--else
			--npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
		end
		if var == 2 or var == 3 then
			npc:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
		elseif var == mod.FF.Marzy.Var then
			npc.SplatColor = mod.ColorStinkyCheese
		elseif var == mod.FF.Flinty.Var then
			npc.SplatColor = Color(0,0,0,1,0.25,0.25,0.25)
		end
		npcd.Wait = 0
		npcd.init = true
		if npcd.waited then
			npc.State = 9
			npc.Visible = true
			if var == mod.FF.Flinty.Var then
				sprite:Play("FallWait", true)
				npcd.FallWait = true
			else
				sprite:Play("Fall", true)
			end
		elseif npc.SubType == 1 then
			if npc.Variant == mod.FF.Doomer.Var and (mod:CheckStage("Gehenna", {47}) or mod:CheckStage("Sheol", {14}) or mod:CheckStage("Dark Room", {16})) then
				npc:Morph(mod.FF.WaitingDemonDoomer.ID, mod.FF.WaitingDemonDoomer.Var, mod.FF.WaitingDemonDoomer.Sub, -1)
				npcd.init = false
				npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			else
				mod:makeWaitFerr(npc, npc.Type, npc.Variant, npc.SubType, 60, false)
			end
		else
			npc.State = 3
		end
		npcd.dontBrim = true


	--Idle
	elseif npc.State == 3 then
		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
		if npcd.Wait == 0 then
			sprite:Play("Idle", 0)
			if var == 3 then
				npcd.waitrng = 0
			elseif var == 5 or var == 6 then
				npcd.waitrng = math.random(5,20) + 20
			elseif var == 1 then
				npcd.waitrng = math.random(10) + 15
			elseif var == 8 then
				npcd.waitrng = math.random(5)
			elseif var == mod.FF.Flinty.Var then
				if npc.Subtype == 0 then
					npcd.waitrng = math.random(10) + npc.Index*3
				else
					npcd.waitrng = math.random(10) + (npc.Index % 10)*2
				end
			elseif var == 2 then
				npcd.waitrng = 15 + math.random(10)
	  		else
				npcd.waitrng = math.random(10)
			end
		end
		npcd.Wait = npcd.Wait + 1
		if var > 1 and var < 4 then
			if room:IsClear() == true then
				npc.State = 15
			end
			if npcd.Wait > 20 + npcd.waitrng and not mod:isScareOrConfuse(npc) then
				npc.State = 8
				npcd.Wait = 0
			end
		elseif var == 1 then
			if npcd.Wait > 1 + npcd.waitrng and not mod:isScareOrConfuse(npc) then
				npc.State = 8
				npcd.Wait = 0
			end
		elseif var == 8 then
			if npcd.Wait > 15 + npcd.waitrng and not mod:isScareOrConfuse(npc) then
				if npcd.dontBrim then
					npcd.dontBrim = nil
					npc.State = 8
					npcd.Wait = 0
				else
					npc.State = 10
					npcd.Wait = 0
					npcd.brimState = nil
				end
			end
		elseif var == mod.FF.Marzy.Var then
			if npcd.Wait > 45 + npcd.waitrng and not mod:isScareOrConfuse(npc) then
				npc.State = 8
				npcd.Wait = 0
			end
	elseif var == mod.FF.Flinty.Var then
	  if npcd.Wait > 30 + npcd.waitrng and not mod:isScareOrConfuse(npc) then
				npc.State = 8
				npcd.Wait = 0
			end
		else
			if npcd.Wait > 10 + npcd.waitrng and not mod:isScareOrConfuse(npc) then
				npc.State = 8
				npcd.Wait = 0
			end
		end

	--Doomer attack
	elseif npc.State == 10 then
		npc.StateFrame = npc.StateFrame + 1
		if not npcd.brimState then
			if sprite:IsFinished("BrimstoneStart") then
				npcd.brimState = "firing"
			elseif sprite:IsEventTriggered("rrerr") then
				for i = 90, 360, 90 do
					local tracer = Isaac.Spawn(1000, 198, 0, npc.Position + Vector(10, 0):Rotated(i), Vector(0.001,0), npc):ToEffect()
					tracer.Timeout = 20
					tracer.TargetPosition = Vector(1,0):Rotated(i)
					tracer.LifeSpan = 15
					tracer:FollowParent(npc)
					if npc.SubType == 666 then
						tracer.SpriteScale = Vector(30,30)
					else
						tracer.SpriteScale = Vector(2,2)
					end
					tracer.Color = Color(1,0.2,0,0.3,0,0,0)
					tracer:Update()
				end
			elseif sprite:IsEventTriggered("Shoot") then
				local laserVar = 1
				if npc.SubType == 666 then
					laserVar = 13
					npc:PlaySound(SoundEffect.SOUND_BEAST_LASER,1,2,false,1)
				end
				for i = 90, 360, 90 do
					local laser = EntityLaser.ShootAngle(laserVar, npc.Position, i, 20, Vector(0, -10), npc)
					if i == 90 then
						laser.DepthOffset = -500
					end
					laser.Parent = npc
					laser:Update()
				end
				npc.StateFrame = 0
			else
				mod:spritePlay(sprite, "BrimstoneStart")
			end
		elseif npcd.brimState == "firing" then
			mod:spritePlay(sprite, "BrimstoneLoop")
			if npc.StateFrame > 20 then
				npcd.brimState = "end"
			end
		elseif npcd.brimState == "end" then
			if sprite:IsFinished("BrimstoneEnd") then
				npcd.Wait = 0
				npcd.init = true
				npcd.dontBrim = true
				npc.State = 3
			else
				mod:spritePlay(sprite, "BrimstoneEnd")
			end
		end


	--Jump Up
	elseif npc.State == 8 then
		if not npcd.IsJumping then
			if var > 1 and var < 4 then
				if room:IsClear() then
					npc.State = 15
				end
			end
		end

	--Flinty smoke
	if var == mod.FF.Flinty.Var and sprite:IsPlaying("Jump") and sprite:WasEventTriggered("Sound") then
	  local smoke = Isaac.Spawn(1000, 59, 0, npc.Position+RandomVector()*10, Vector(0,-5), npc):ToEffect()
	  smoke:SetTimeout(20)
	  smoke.Scale = 1000
	  local offsetY = sprite:GetFrame()-30
	  smoke.PositionOffset = Vector(0, -50*offsetY)
	end

		if sprite:IsFinished("Jump") then
			if var > 0 and var < 5 then
				npc.State = 9
				npcd.IsJumping = 0
				npcd.targetVelocity = Vector.Zero
			end
		elseif not sprite:IsPlaying("Jump") then
			sprite:Play("Jump", 0)
		elseif sprite:IsEventTriggered("GetPlayer") then
			if var == 0 or var == 7 or var == mod.FF.Flinty.Var then
				local dist = (npc.Position - target.Position):Length()
				local fgkhj = (target.Position - npc.Position):Normalized() * math.min(300,dist)

				npcd.PlayerPos = room:FindFreeTilePosition(npc.Position + fgkhj, 40) + (RandomVector())
			elseif var == 4 or var == 1 then
				local dist = (npc.Position - target.Position):Length()
				local fgkhj = (target.Position - npc.Position):Normalized() * math.min(200,dist)

				npcd.PlayerPos = room:FindFreeTilePosition(npc.Position + fgkhj, 40) + (RandomVector())
			elseif var == mod.FF.Doomer.Var or var == mod.FF.Marzy.Var then
				local dist = (npc.Position - target.Position):Length()
				local fgkhj = (target.Position - npc.Position):Normalized() * math.min(400,dist)
				fgkhj = fgkhj:Resized(fgkhj:Length() * 0.8) --idk it works
				npcd.PlayerPos = room:FindFreeTilePosition(npc.Position + fgkhj, 40) + (RandomVector())
			elseif var == 5 or var == 6 then
				local randtarg = mod:FindRandomFreePos(npc, 200, nil, true)
				local dist = (npc.Position - randtarg):Length()
				local fgkhj = (randtarg - npc.Position):Normalized() * math.min(300,dist)
				npcd.PlayerPos = room:FindFreeTilePosition(npc.Position + fgkhj, 40) + (RandomVector())
			else
				npcd.PlayerPos = room:FindFreeTilePosition(entitynpc.Target.Position, 40) + (RandomVector()*10)
			end
			npcd.AshLeave = true
			npcd.AshTable = {}
			npcd.IsJumping = 1
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
			npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
		elseif sprite:IsEventTriggered("Sound") then
			if (var == 0 or var > 3) and var ~= mod.FF.Flinty.Var then
				npc:PlaySound(SoundEffect.SOUND_MEAT_JUMPS,1,2,false,1)
			elseif var == 1 then
				npc:PlaySound(SoundEffect.SOUND_MEAT_JUMPS,1,2,false,1.4)
			elseif var == 2 then
				npc:PlaySound(SoundEffect.SOUND_SHELLGAME,1,2,false,0.7)
			end

	  -- Flinty's pit/s
	  if var == mod.FF.Flinty.Var then
		game:BombExplosionEffects(npc.Position, 20, TearFlags.TEAR_NORMAL, Color.Default, npc, 0.75, false, true, DamageFlag.DAMAGE_EXPLOSION)
		local pits = {npc.Position}
		local offsetX
		local offsetY
		if (npc.Position.X+20)%40 < 10 then offsetX = -1 end
		if (npc.Position.X+20)%40 > 30 then offsetX = 1 end
		if (npc.Position.Y+20)%40 < 10 then offsetY = -1 end
		if (npc.Position.Y+20)%40 > 30 then offsetY = 1 end
		if offsetX then table.insert(pits, npc.Position + Vector(40*offsetX, 0)) end
		if offsetY then table.insert(pits, npc.Position + Vector(0, 40*offsetY)) end

		for _, pos in pairs(pits) do
		  if mod.canGeneratePit(pos, 0, nil, true, true) then
			for i=1, 3 do
			  Isaac.Spawn(1000, 4, 0, room:GetGridPosition(room:GetGridIndex(pos)), RandomVector()*math.random()*5, npc)
			end
			local index = room:GetGridIndex(pos)
			room:SpawnGridEntity(index, 7, 0, 0, 0)
			mod:UpdatePits(index)
		  end
		  --npcd.jumpCountdown = 35
		end
	  end
		end



	--Jump Down
	elseif npc.State == 9 then
		if sprite:IsFinished("Fall") or sprite:IsFinished("FallWait") then
			npc.State = 3
		elseif not (sprite:IsPlaying("Fall") or sprite:IsPlaying("FallWait")) then
			sprite:Play("Fall", 0)
			--npc.Position = npcd.PlayerPos
		elseif sprite:IsEventTriggered("Blaze") then
			if not npcd.unignited and npcd.AshTable then
				npcd.AshLeave = false
				local ash = npcd.AshTable[#npcd.AshTable]
				mod:GetEntityData(ash).asplode = true
			end
		end
		if sprite:IsEventTriggered("Land") then
			if var == 0 or var > 3 then
				npc:PlaySound(SoundEffect.SOUND_MEAT_IMPACTS,1,2,false,1)
				if var == 5 and not npcd.unignited then
					local smoke = Isaac.Spawn(1000, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, npc.Position, Vector.Zero, npc):ToEffect()
					--smoke.Scale = 10
					smoke.SpriteScale = Vector(2,2)
					smoke.SpriteOffset = Vector(0,-10)
					smoke:Update()
				end
			elseif var == 1 then
				npc:PlaySound(SoundEffect.SOUND_MEAT_JUMPS,1,2,false,1.4)
			else
				npc:PlaySound(SoundEffect.SOUND_POT_BREAK,1,2,false,1)
			end
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
			npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
			if var > 1 and var < 4 then
				if room:IsClear() then
					npc.State = 15
				else
					game:ShakeScreen(6)
					local wave
					if not npcd.waited then
						wave = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SHOCKWAVE, 0, npc.Position, Vector.Zero, g):ToEffect()
						wave.Parent = npc
						wave.MaxRadius = 50
					end
				end
			else
				npc:ClearEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
			end
			if var == 4 and not npcd.waited then
				--Creep
				local creep = Isaac.Spawn(1000, 22, 0, npc.Position, Vector.Zero, npc)
				creep.SpriteScale = creep.SpriteScale * 2
				for i = 1, 3 do
					local creep = Isaac.Spawn(1000, 22, 0, npc.Position + (Vector.FromAngle(i * (360 / 3)) * 22), Vector.Zero, npc)
				end
				--Splatter
				local params = ProjectileParams()
				for i = 30, 360, 30 do
					local rand = r:RandomFloat()
					params.FallingSpeedModifier = -1 * (math.random(5, 20) + math.random());
					params.FallingAccelModifier = 2
					params.VelocityMulti = 0.65 + mod:RandomInt(0,4) * 0.2
					npc:FireProjectiles(npc.Position, Vector(0,4):Rotated(i-40+rand*80) + Vector.Zero, 0, params)
				end
			elseif var == 7 and not npcd.waited then
				local creep = Isaac.Spawn(1000, 22, 0, npc.Position, Vector.Zero, npc):ToEffect()
				creep.SpriteScale = creep.SpriteScale * 2
				creep:SetTimeout(60)
				creep:Update()
				local params = ProjectileParams()
				params.FallingAccelModifier = 0.3
				local choiceVec = (target.Position - npc.Position):Resized(5)
				for i = 72, 360, 72 do
					npc:FireProjectiles(npc.Position + choiceVec:Rotated(i):Resized(15), choiceVec:Rotated(i), 0, params)
				end
			elseif var == mod.FF.Marzy.Var and not npcd.waited then --Marzy land
				local cap = (mod.GetEntityCount(853) < mod.GetEntityCount(mod.FF.Marzy.ID, mod.FF.Marzy.Var) * 6)
				if cap then
					for i = 1, mod:RandomInt(1,2) do
						local maggotvel = (mod:FindRandomValidPathPosition(npc, 3) - npc.Position)/mod:RandomInt(20,25)
						FiendFolio.ThrowMaggot(npc.Position, maggotvel, -5, mod:RandomInt(-20, -10), npc)
					end
				end
				npcd.WormyShoot = 3
				npcd.WormPoint = npc.Position
				npcd.WormVec = RandomVector()
				local effect = Isaac.Spawn(1000,7,0,npc.Position,Vector.Zero,npc)
				effect.Color = mod.ColorStinkyCheese
				effect = Isaac.Spawn(1000,16,3,npc.Position,Vector.Zero,npc)
				effect.Color = mod.ColorStinkyCheese
				effect.SpriteScale = effect.SpriteScale * 0.6
			end
			npcd.waited = nil
		end

	--Flinty smoke
	if var == mod.FF.Flinty.Var and sprite:IsPlaying("Fall") and sprite:GetFrame() < 25 then
	  local smoke = Isaac.Spawn(1000, 59, 0, npc.Position+RandomVector()*15, Vector(0,-5), npc):ToEffect()
	  smoke:SetTimeout(10)
	  smoke:SetColor(Color(0,0,0,0.5,0,0,0), 0, 0, false, false)
	  smoke.Scale = 1000
	  local offsetY = sprite:GetFrame()
	  if offsetY > 6 then offsetY = 6 end
	  smoke.PositionOffset = Vector(0, -220+(offsetY*33.3))
	end



	--Ded
	elseif npc.State == 15 then
		if sprite:IsFinished("Off") then
			--[[for i = 1, 10 do
				local rock = Isaac.Spawn(1000, 4, 0, npc.Position, npc.Velocity+RandomVector()*3, npc):ToEffect()
				rock.Color = Color(1.5,1.5,1.5,1,0,0,0)
				rock:Update()
			end]]
			npc:Kill()
		else
			mod:spritePlay(sprite, "Off")
		end
	end
	if npc.Variant == mod.FF.Marzy.Var then
		npcd.WormyShoot = npcd.WormyShoot or -1
		npcd.WormyShoot = npcd.WormyShoot - 1
		npcd.WormPoint = npcd.WormPoint or npc.Position
		if npcd.WormyShoot >= 0 then
			local params = ProjectileParams()
			params.Color = mod.ColorWigglyMaggot
			params.FallingAccelModifier = -0.15
			params.BulletFlags = ProjectileFlags.NO_WALL_COLLIDE
			params.Scale = 0.6
			mod:SetGatheredProjectiles()
			for i = 0, 240, 120 do
				local shootvec = npcd.WormVec:Rotated(i):Resized(8)
				npc:FireProjectiles(npcd.WormPoint + shootvec:Resized(npcd.WormyShoot * 2), shootvec, 0, params)
			end
			for _, projectile in pairs(mod:GetGatheredProjectiles()) do
				local data = mod:GetEntityData(projectile)
				data.projType = "wigglyWorm"
				local dist = projectile.Position:Distance(npc.Position)
			end
		end
		if npc:IsDead() then
			--[[for i = 1, mod:RandomInt(1,2) do
				local maggotvel = (mod:FindRandomValidPathPosition(npc, 3) - npc.Position)/mod:RandomInt(20,25)
				FiendFolio.ThrowMaggot(npc.Position, maggotvel, -5, mod:RandomInt(-20, -10), npc)
			end]]
		end
	end
	npc.Velocity = (npcd.targetVelocity * 0.3) + (npc.Velocity * 0.6)
end

function mod:WigglyWormProjectile(projectile, data)
	data.WiggleCurve = data.WiggleCurve or 4
	data.WiggleAngle = data.WiggleAngle or 12
	projectile.Velocity = projectile.Velocity:Rotated(data.WiggleAngle)
	data.WiggleAngle = data.WiggleAngle + data.WiggleCurve
	if math.abs(data.WiggleAngle) > 12 then
		data.WiggleCurve = -data.WiggleCurve
	end
end

function mod:slammerHurt(npc, damage, flag, source)
	local variant = npc.Variant
	if variant == 2 or variant == 3 then
		return false
	end
  if variant == mod.FF.Flinty.Var then
		if source and source.Entity and source.Entity.Type == mod.FF.Flinty.ID and source.Entity.Variant == mod.FF.Flinty.Var then return false end
	end
	if flag & DamageFlag.DAMAGE_FIRE ~= 0 and source.Type ~= 1 then
		if variant == 0 then
			--[[npc:ToNPC():Morph(951, 5, 0, -1)
			return false]]
		elseif variant == 5 then
			return false
		end
	end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.slammerHurt, mod.FF.Slammer.ID)

--Run Slammer AI
function mod:checkSlammer(npc)

	mod:slammerAI(npc)
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkSlammer, mod.FF.Slammer.ID)

--[[Run Bouncer AI
function mod:checkBouncer(npc)
	mod:bouncerAI(npc)
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkSlammer, 951)]]