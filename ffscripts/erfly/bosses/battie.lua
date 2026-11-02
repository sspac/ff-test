local mod = FiendFolio
local game = Game()

--BattieAI
function mod:battyAI(npc, sprite, d)
	local room = game:GetRoom()
	local target = npc:GetPlayerTarget()
	local r = npc:GetDropRNG()


	if not d.init then
		d.init = true
		d.flapcount = 0
		d.extraframes = 0
		d.slamattackcount = 0
		d.chargeattackcount = 0
		d.state = "idle"
		local champSheet
		local champ
		if npc.SubType > 0 then
			champ = npc.SubType
		elseif mod:shouldBossBeChampion(npc) then
			local grng = mod:getRoomSpawnRNG()
			champ = mod:RandomInt(1,2,grng)
		end

		if champ == 1 then
			npc.SubType = 1
			d.foamy = true
			champSheet = "gfx/bosses/battie/battie_brown.png"
		elseif champ == 2 then
			npc.SubType = 2
			d.purple = true
			champSheet = "gfx/bosses/battie/battie_purple.png"
		end

		if champSheet then
			for i = 0, 4 do
				sprite:ReplaceSpritesheet(i, champSheet)
			end
			sprite:LoadGraphics()
		end
		FiendFolio.savedata.sawBattieBefore = true
	else
		npc.StateFrame = npc.StateFrame + 1
	end

	--Used for the death animation
	if npc.State ~= 11 then
		--Her default movement state, just flapping away.
		if d.state == "idle" then
			d.extraframes = 0
			mod:spritePlay(sprite, "Idle")
			npc.SpriteOffset = Vector(0, -25)
			if sprite:GetFrame() == 10 then
				--Flapcount determines rotation on velocity, so each flap is rotated by either -30 or 30 degrees
				--this is a dumb lazy way of doing it though.
				if d.flapcount == 0 then
					d.flapcount = 60
				else
					d.flapcount = 0
				end
				--Only updates her velocity in a flap every ten frames
				npc.Velocity = (target.Position-npc.Position):Resized(10):Rotated(-30 + d.flapcount)
				npc:PlaySound(mod.Sounds.WingFlap,0.5,0,false,math.random(70,90)/100)
			end
			--Ensures she's constantly slowing, so that she flaps and gets a boost, slowing afterwards
			npc.Velocity = npc.Velocity * 0.9
			if npc.StateFrame > 100 and r:RandomInt(10) == 0 then
				--Likely to spawn bats if there is only 1 or aren't any, but doesn't need to.
				local batcount = mod.GetBatCount()
				if (batcount < 1) or (batcount < 2 and r:RandomInt(3) == 0) then
					d.extraframes = 70
					d.spewstate = "bats"
					d.state = "spew"
				else
					--Isaac.ConsoleOutput(d.chargeattackcount .. ", " .. d.chargeattackcount / 3 .. "/ " .. d.slamattackcount .. "\n")
					--Math here is to ensure she has a balance of charging or slamming attacks.
					if r:RandomInt(3) == 0 or d.chargeattackcount / 3 >= d.slamattackcount then
						d.state = "slam"
						d.slamattackcount = d.slamattackcount + 1
						d.slamstate = 1
					else
						d.state = "charge"
						npc:PlaySound(SoundEffect.SOUND_MONSTER_YELL_B,1,1,false,1.3)
						d.chargeattackcount = d.chargeattackcount + 1
						d.chargestate = 1
                        npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
					end
				end
			end

		--Charging state, the big vertical dive
		elseif d.state == "charge" then

			--Initialise the charge, and set how many times she should charge
			if d.chargestate == 1 then
				npc.Velocity = npc.Velocity * 0.85
				if sprite:IsFinished("ChargeStart") then
					mod:spritePlay(sprite, "Charge")
					d.chargestate = 2
					d.chargehori = nil
					d.chargevert = nil
					npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
					d.chargecount = 0
					--Either 3 or 5 charges will occur
					d.maxcharges = 3 + r:RandomInt(3)
				else
					mod:spritePlay(sprite, "ChargeStart")
				end

			--Actually performing the charge
			elseif d.chargestate == 2 then
				if sprite:GetFrame() == 4 then
					npc:PlaySound(mod.Sounds.WingFlap,0.5,0,false,math.random(130,150)/100)
				end
				local add = Vector(0, 0)
				local homeStrength = 1.5
				if d.chargehori then
					if target.Position.Y > npc.Position.Y + 10 then
						add = Vector(0, homeStrength)
					elseif target.Position.Y < npc.Position.Y - 10 then
						add = Vector(0, -homeStrength)
					end

					npc.Velocity = Vector(20 * (d.chargehori or 1), 0)
				else
					if target.Position.X > npc.Position.X + 10 then
						add = Vector(homeStrength, 0)
					elseif target.Position.X < npc.Position.X - 10 then
						add = Vector(-homeStrength, 0)
					end

					npc.Velocity = Vector(0,20 * (d.chargevert or 1))
				end

				if d.foamy then
					npc.Velocity = npc.Velocity * 0.85
				end

				npc.Velocity = npc.Velocity + add
				--Move her to the top of the screen if she goes down far enough
				local chargecomplete
				if d.chargehori then
					if d.chargehori == -1 and npc.Position.X < -100 then
						chargecomplete = true
					elseif d.chargehori ~= -1 and npc.Position.X > room:GetGridWidth() * 40 + 100 then
						chargecomplete = true
					end
				else
					if d.chargevert == -1 and npc.Position.Y < -100 then
						chargecomplete = true
					elseif d.chargevert ~= -1 and npc.Position.Y > room:GetGridHeight() * 40 + 300 then
						chargecomplete = true
					end
				end

				if chargecomplete then
					if d.foamy then
						local negative = r:RandomInt(2)
						if negative == 0 then
							negative = -1
						end

						if d.chargehori then
							d.chargevert = negative
							d.chargehori = nil
						else
							d.chargehori = negative
							d.chargevert = nil
						end
					elseif d.purple then
						if d.chargevert == -1 then
							d.chargevert = 1
						else
							d.chargevert = -1
						end
					end

					if d.chargehori then
						if d.chargehori == -1 then
							npc.Position = Vector(room:GetGridWidth() * 40 + 100, target.Position.Y)
						else
							npc.Position = Vector(-100, target.Position.Y)
						end
					else
						if d.chargevert == -1 then
							npc.Position = Vector(target.Position.X, room:GetGridHeight() * 40 + 300)
						else
							npc.Position = Vector(target.Position.X, -100)
						end
					end

					--Since her babies are a threat, if they're all dead she'll want to go back to idle soon, so she can spawn more.
					if mod.GetBatCount() == 0 then
						d.chargecount = d.chargecount + 2
					else
						d.chargecount = d.chargecount + 1
					end
				end

				--The projectiles
				if not (d.chargecount > d.maxcharges) then
					if npc.FrameCount % 4 == 0 then
						local projectile = mod:LazySpawnProjectile(0, 0, npc.Position, Vector.Zero, npc):ToProjectile()
						projectile.ProjectileFlags = projectile.ProjectileFlags | ProjectileFlags.NO_WALL_COLLIDE
						projectile.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
						if d.purple then
							mod:GetEntityData(projectile).purplebattie = true
						end
					end
				end

				--Make her stop charging when she needs to
				if room:IsPositionInRoom(npc.Position, 0) then
					if d.chargecount > d.maxcharges then
						mod:spritePlay(sprite, "ChargeStop")
						npc:PlaySound(mod.Sounds.Skid,0.7,0,false,1.15)
						npc:ClearEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
						d.chargestate = 3
                        npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
					end
				else
					mod:spritePlay(sprite, "Charge")
				end

			--Stopping the charge, and returning her to idle
			elseif d.chargestate == 3 then
				npc.Velocity = npc.Velocity * 0.9
				if sprite:IsFinished("ChargeStop") then
					npc.StateFrame = 0
					d.state = "idle"
				--Shoot 8 tears in 8 directions
				elseif sprite:GetFrame() == 15 then
					npc:PlaySound(mod.Sounds.Tada,1,0,false,1.25)

					local params = ProjectileParams()
					--params.BulletFlags = params.BulletFlags | ProjectileFlags.TRIANGLE
					local count, speed = 8, 13
					if d.purple then
						count, speed = 5, 9
						params.BulletFlags = params.BulletFlags | ProjectileFlags.SMART
					end

					for i = 1, count do
						local ang = (360 / count) * i
						npc:FireProjectiles(npc.Position, Vector(0,speed):Rotated(-22.5+ang), 0, params)
					end


					--[[for i = 45, 360, 45 do
						local p = mod:LazySpawnProjectile(0, 0, npc.Position, Vector(0,14):Rotated(i), npc):ToProjectile()
						p.FallingSpeed = 0
						p.FallingAccel = -0.066
						p.ProjectileFlags = p.ProjectileFlags | ProjectileFlags.NO_WALL_COLLIDE

						mod:GetEntityData(p).projType = "boomerang"

					end]]

				else
					mod:spritePlay(sprite, "ChargeStop")
				end
			end

		--Spewing state, set up to play the animation, with a couple potential attacks
		elseif d.state == "spew" then
			npc.Velocity = npc.Velocity * 0.9
			if sprite:IsFinished("Spew") then
				d.state = "idle"
				--Extra frames are so batty might not have to wait as long for her next attack. Currently unused.
				npc.StateFrame = 0 + d.extraframes
			elseif sprite:IsEventTriggered("TrackPos") then
				d.pos = target.Position
			elseif sprite:IsEventTriggered("Shoot") then
				--Blarrrrghhh, unused currently, a champion might use it eventually.
				if d.spewstate == "proj" then
					local params = ProjectileParams()
					npc:FireBossProjectiles(10, d.pos, 10, params)
				--Cough up some bats
				elseif d.spewstate == "bats" then
					npc:PlaySound(SoundEffect.SOUND_WHEEZY_COUGH,1,0,false,1.25)
					local targvel = (d.pos - npc.Position)
					local rand = r:RandomInt(3)
					-- Foamies
					if d.foamy then
						for i = -30, 30, 60 do
							local bat = mod.spawnent(npc, npc.Position + targvel:Resized(40):Rotated(i), targvel:Resized(10):Rotated(i), mod.FF.Foamy.ID, mod.FF.Foamy.Var, 0)
							mod:GetEntityData(bat).quickcharge = true
							bat.HitPoints = bat.HitPoints * 0.5
							bat.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
						end
					--Fat bat
					elseif rand == 0 then
						local fatb = mod.spawnent(npc, npc.Position + targvel:Resized(40), targvel:Resized(10), 258)
						fatb.HitPoints = fatb.MaxHitPoints * 0.75
						--b.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
					--Two one tooths (One teeth?)
					elseif rand == 1 then
						for i = -30, 30, 60 do
							local bat = mod.spawnent(npc, npc.Position + targvel:Resized(40):Rotated(i), targvel:Resized(10):Rotated(i), 234, 0, 7000)
							bat.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
						end
					--Milk Teeth!!! Babies!
					else
						for i = -30, 30, 30 do
							local bat = mod.spawnent(npc, npc.Position + targvel:Resized(40):Rotated(i), targvel:Resized(10):Rotated(i), mod.FF.MilkTooth.ID, mod.FF.MilkTooth.Var, 7000)
							bat.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
						end

					end
				end
			else
				mod:spritePlay(sprite, "Spew")
			end

		--Her big fat slam attack!
		elseif d.state == "slam" then
			--Stops her velocity so she won't be affected by anything
			npc.Velocity = Vector.Zero

			--Initialises the slam attack
			if d.slamstate == 1 then
				if sprite:IsFinished("FlyUp") then
					npc.StateFrame = 0
					d.slamstate = 2
					npc.Position = d.targetpos
					npc.Visible = false
				elseif sprite:GetFrame() == 20 then
					--Entcoll change ensures she won't get hit when high up in the air
					npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
					d.targetpos = target.Position
				else
					mod:spritePlay(sprite, "FlyUp")
				end

			--This is where she finally comes down and causes a big fat slam!
			elseif d.slamstate == 2 then
				if sprite:IsFinished("FlyDown") then
					d.state = "idle"
					--She'll likely spew or charge soon!
					npc.StateFrame = 50
				--Called in the animation when she finally hits the ground
				elseif sprite:IsEventTriggered("SlamJam") then
					--The player can hit her again
					npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL

					--Some effects to make it look cool
					game:ShakeScreen(15)
					npc:PlaySound(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND,0.6,2,false,1.7)

					--Crackwave
					if not d.foamy then
						local wave = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SHOCKWAVE, 0, npc.Position, Vector.Zero, g):ToEffect()
						wave.Parent = npc
						wave.MaxRadius = 100
					end

					--Projectiles
					local params = ProjectileParams()
					params.TargetPosition = npc.Position
					local speedmulti = 1
					if d.foamy then
						speedmulti = 1.4
						params.Variant = ProjectileVariant.PROJECTILE_BONE
					end

					--Lots of normal tears
					if not d.purple then
						for i = 22.5, 360, 22.5 do
							npc:FireProjectiles(npc.Position, Vector(0,7 * speedmulti):Rotated(i), 0, params)
						end
					end

					-- champ: homing tears
					if d.purple then
						params.BulletFlags = params.BulletFlags | ProjectileFlags.SMART
						for i = 45, 360, 45 do
							npc:FireProjectiles(npc.Position, Vector(0,8 * speedmulti):Rotated(i), 0, params)
						end
					--A few curving tears
					else
						if d.foamy then
							params.Variant = 0
						end

						params.BulletFlags = params.BulletFlags | ProjectileFlags.BOOMERANG | ProjectileFlags.CURVE_LEFT
						for i = 45, 360, 45 do
							npc:FireProjectiles(npc.Position, Vector(0,10 * speedmulti):Rotated(i), 0, params)
						end
					end

					--[[for i = 45, 360, 45 do
						local p = mod:LazySpawnProjectile(0, 0, npc.Position, Vector(0,14):Rotated(i), npc):ToProjectile()
						p.FallingSpeed = 0
						p.FallingAccel = -0.066

						mod:GetEntityData(p).projType = "boomerang"

					end]]
				else
					if npc.StateFrame > 10 then
						mod:spritePlay(sprite, "FlyDown")
						npc.Visible = true
					end
				end
			end
		end
	end
end


function mod.battieprojupdate(v, d)
	if d.purplebattie and v:IsDead() then
		local vel = Vector(-8, 0)
		for i = 0, 180, 180 do
			local projectile = mod:LazySpawnProjectile(0, 0, v.Position + vel:Rotated(i), vel:Rotated(i), v):ToProjectile()
			projectile.FallingAccel = 0.7
		end
	end
end