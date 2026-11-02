local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local THE_FUCK_OFF_ZONE = Vector(99999, 99999)
local PHYSICS_FLAGS = EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK

local LIGHTNING_CHARGE_DURATION = 40
local LIGHTNING_TRACER_COOLDOWN = 10
local LIGHTNING_DISTANCE_THRESHOLD = 80
local TEARS_SPIN_DURATION = 180
local TEARS_SPIN_SPAWN_FREQUENCY = 20
local TELEPORT_DISTANCE_THRESHOLD = 80
local TELEPORT_EDGE_THRESHOLD = Vector(40, 40)
local TELEPORT_SPIN_DURATION = 60
local DASHING_MAX_DURATION = 15
local DASHING_MAX_TOTAL_DURATION = 400
local DASH_ANGLE_THRESHOLD = 17.5
local ATTACK_COOLDOWN = 30

local SPEED_IDLE = 2
local SPEED_LIGHTNING_NAV = 2.5
local SPEED_SPINNING = 2
local SPEED_DASHING = 13

local COLOR_BULLETSPLASH = Color(0.5, 0.5, 0.5, 0.5, 0/255, 207/255, 252/255)
local COLOR_FIRE_BULLETTRAIL = Color(0.5, 0.5, 0.5, 1, 0, 167/255, 158/255)
local COLOR_INVISIBLE = Color(0, 0, 0, 0, 0, 0, 0)

local Attack = {
	LIGHTNING_CHARGE = 1,
	SPIN 			= 2,
	FIRE_SPIN		= 3,
	DASH 			= 4,
}

local AttackWeight = {
	[Attack.LIGHTNING_CHARGE]	= 1,
	[Attack.SPIN]	 			= 2,
	[Attack.FIRE_SPIN]	 		= 2,
	[Attack.DASH]	 			= 3,
}

local function randomPitch(lower, upper)
	lower = lower or 9
	upper = upper or 11

	local range = upper - lower
	local shift = math.random() * range
	return (lower + shift) / 10
end

local function spawnGenericSplash(position)
	local splash = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BIG_SPLASH, 0, position + Vector(0, 1), Vector.Zero, nil)
	local splash2 = Isaac.Spawn(1000, 14, 0, position, Vector.Zero, nil):ToEffect()
	splash2.Scale = 2.5

	sfx:Play(mod.Sounds.SplashLarge, 1, 0, false, randomPitch())
	sfx:Play(mod.Sounds.RaymondTeleport)
end

local function spawnGenericBulletSplash(position)
	local splash = Isaac.Spawn(1000, 16, 0, position + Vector(0, 1), Vector.Zero, nil):ToEffect()
	splash.SpriteScale = Vector.One * 0.65
	splash.SpriteOffset = Vector(0, -18)
	splash.Color = COLOR_BULLETSPLASH
end

local function flipReflection(npc, noSplash)
	local data = npc:GetData()
	data.isReflected = not data.isReflected

	if not noSplash then
		spawnGenericSplash(npc.Position)
	end
end

local function setReflection(npc, reflection, noSplash)
	local data = npc:GetData()
	if data.isReflected ~= reflection then
		flipReflection(npc, noSplash)
	end
end

local function getFurthestNewCorner(npc, rng)
	local room = game:GetRoom()
	local topLeft = room:GetTopLeftPos() + TELEPORT_EDGE_THRESHOLD
	local bottomRight = room:GetBottomRightPos() - TELEPORT_EDGE_THRESHOLD + Vector(0, 10)
	local topRight = Vector(bottomRight.X, topLeft.Y)
	local bottomLeft = Vector(topLeft.X, bottomRight.Y)

	local positions = {topLeft, topRight, bottomLeft, bottomRight}
	local target = npc:GetPlayerTarget()
	local valids = {}

	for _, position in pairs(positions) do
		if position:Distance(npc.Position) > TELEPORT_DISTANCE_THRESHOLD and position:Distance(target.Position) > TELEPORT_DISTANCE_THRESHOLD then
			table.insert(valids, position)
		end
	end

	return valids[rng:RandomInt(#valids) + 1]
end

local function getAngleDifference(one, two)
	local delta = math.abs(one - two) % 360
	return delta > 180 and 360 - delta or delta
end

local function getDashDirection(npc) -- Returns String: dashAnim, Int: dashAngle
	local target = npc:GetPlayerTarget()
	local angle = (target.Position - npc.Position):GetAngleDegrees()

	if angle > 90 then
		return "DownLeft", 135
	elseif angle > 0 then
		return "DownRight", 45
	elseif angle > -90 then
		return "UpRight", -45
	else
		return "UpLeft", -135
	end
end

local function didTargetCrossPerpendicularDash(npc, dashAngle)
	local target = npc:GetPlayerTarget()
	local angle = (target.Position - npc.Position):GetAngleDegrees()

	for _, testAngle in pairs({90, -90}) do
		if getAngleDifference(angle, dashAngle + testAngle) < DASH_ANGLE_THRESHOLD then
			return true
		end
	end

	return false
end

--[[mod:AddCallback(ModCallbacks.MC_USE_ITEM, function()
	for _, npc in pairs(Isaac.FindByType(mod.FF.Raymond.ID, mod.FF.Raymond.Var)) do
		npc:GetSprite():Play("DashStart")
	end
end, CollectibleType.COLLECTIBLE_D6)

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function()
	for _, npc in pairs(Isaac.FindByType(mod.FF.Raymond.ID, mod.FF.Raymond.Var)) do
		npc:GetSprite():Play("Idle02Start")
	end
end, CollectibleType.COLLECTIBLE_D20)]]

mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, function(_, projectile)
	local data = projectile:GetData()
	if data.raymondFireTear then
		local trail = Isaac.Spawn(1000, 111, 0, projectile.Position, RandomVector(), projectile):ToEffect()
		trail:Update()
		trail.Color = COLOR_FIRE_BULLETTRAIL
		trail.PositionOffset = projectile.PositionOffset
		trail.DepthOffset = -1000
		trail.SpriteScale = Vector.One * 0.75
	end

	if data.raymondBoomerangTear then
		data.raymondKillPosition = data.raymondKillPosition or projectile.SpawnerEntity.Position

		if data.raymondBoomerangBend and projectile.FrameCount > 0 then
			projectile.Velocity = projectile.Velocity:Rotated(data.raymondBoomerangBend)
		end

		if projectile.SpawnerEntity then
			projectile.Velocity = projectile.Velocity + (data.raymondKillPosition - projectile.Position):Resized(0.4)
			if projectile.Position:Distance(data.raymondKillPosition) < 5 then
				projectile:Die()
			end
		else
			projectile.FallingSpeed = 5
		end
	end
end, ProjectileVariant.PROJECTILE_TEAR)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, CallbackPriority.LATE, function(_, projectile, collider)
	if projectile:GetData().raymondFireTear and collider:ToPlayer() then
		projectile:AddProjectileFlags(ProjectileFlags.BLUE_FIRE_SPAWN)
	end
end, ProjectileVariant.PROJECTILE_TEAR)

--[[
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	for key, value in pairs(SoundEffect) do
		if sfx:IsPlaying(value) then
			print(key, "is playing. (ID:", value ..")")
			sfx:Stop(value)
		end
	end
end)
]]

return {
	Init = function(npc)
		local data = npc:GetData()
		data.rng = RNG()
		data.rng:SetSeed(npc.InitSeed, 35)

		data.isReflected = not game:GetRoom():IsMirrorWorld()
		data.isSpinning = false
		data.isDashing = false
		data.chargeMode = false
		data.doneDash = false
		data.forceDash = false
		data.navToMiddle = false
		data.lastAttack = 0
		data.referenceFrame = 0
		data.referenceFrame2 = 0
		data.lastAngle = data.rng:RandomInt(360)
		data.spinStartAngle = 0
		data.teleportShoots = 0
		data.dashingAngle = 0
		data.dashingString = ""
		data.lightningStorage = {}
		data.dummies = {}
		data.params = {}

		data.params.spin = ProjectileParams()
		data.params.spin.Variant = ProjectileVariant.PROJECTILE_TEAR
		data.params.spin.BulletFlags = ProjectileFlags.MEGA_WIGGLE
		data.params.spin.FallingSpeedModifier = 0
		data.params.spin.FallingAccelModifier = -0.1

		data.params.teleportSpin = ProjectileParams()
		data.params.teleportSpin.Variant = ProjectileVariant.PROJECTILE_TEAR
		data.params.teleportSpin.BulletFlags = ProjectileFlags.NO_WALL_COLLIDE
		data.params.teleportSpin.FallingSpeedModifier = 0
		data.params.teleportSpin.FallingAccelModifier = -0.15

		data.params.dash = ProjectileParams()
		data.params.dash.Variant = ProjectileVariant.PROJECTILE_TEAR
		data.params.dash.FallingSpeedModifier = 0
		data.params.dash.FallingAccelModifier = -0.11

		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
		npc.SplatColor = COLOR_INVISIBLE
	end,

	AI = function(npc)
		local data = npc:GetData()
		local sprite = npc:GetSprite()
		local rng = data.rng
		local target = npc:GetPlayerTarget()

		if sprite:IsFinished("Appear") then
			if game:GetRoom():IsMirrorWorld() then
				sprite:Play("Intro02")
			else
				sprite:Play("Intro01")
			end
		elseif sprite:IsFinished("Intro01") or sprite:IsFinished("Intro02") or sprite:IsFinished("SpinEnd") or sprite:IsFinished("SpinEnd02") then
			sprite:Play("Idle01")
			data.referenceFrame = npc.FrameCount
			npc:ClearEntityFlags(PHYSICS_FLAGS)
		elseif sprite:IsFinished("Idle02Start") or sprite:IsFinished("SpinEnd02ToIdle02") then
			if sprite:IsFinished("Idle02Start") then
				data.teleportShoots = 0
			end

			spawnGenericSplash(npc.Position)
			npc.Position = getFurthestNewCorner(npc, rng)
			npc.Velocity = Vector.Zero
			npc:AddEntityFlags(PHYSICS_FLAGS)
			flipReflection(npc)
			sfx:Play(mod.Sounds.RaymondGrunt)

			sprite:Play("SpinStart02")
		elseif sprite:IsFinished("SpinStart") then
			sprite:Play("SpinLoop")
		elseif sprite:IsFinished("SpinStart02") then
			sprite:Play("SpinLoop02")
			data.referenceFrame = npc.FrameCount
		elseif sprite:IsFinished("LightningStrikeStart") then
			sprite:Play("LightningStrikeLoop")
			data.referenceFrame = npc.FrameCount
			npc:AddEntityFlags(PHYSICS_FLAGS)
			sfx:Play(mod.Sounds.RaymondCharge)
			sfx:Play(SoundEffect.SOUND_THUNDER)
		elseif sprite:IsFinished("LightningStrike") then
			sprite:Play("Idle01")
			data.lightningStorage = {}
			npc:ClearEntityFlags(PHYSICS_FLAGS)
		elseif sprite:IsFinished("DashStart") then
			local dashAnim, dashAngle = getDashDirection(npc)
			sprite:Play("Dash" .. dashAnim)
			npc.Velocity = Vector.FromAngle(dashAngle) * SPEED_DASHING * 1.5
			sfx:Play(mod.Sounds.RaymondGrunt, 0.8, 2, false, 0.95)

			if not data.isDashing then
				data.referenceFrame2 = npc.FrameCount
			end

			data.isDashing = true
			data.dashingAngle = dashAngle
			data.dashingString = dashAnim
			data.referenceFrame = npc.FrameCount
		elseif sprite:IsFinished("Shoot01") or sprite:IsFinished("Shoot02") then
			if npc.FrameCount - data.referenceFrame2 >= DASHING_MAX_TOTAL_DURATION then
				data.isDashing = false
				sprite:Play("Idle01")
				data.referenceFrame = npc.FrameCount
			else
				sprite:Play("DashStart")
				sprite:SetFrame(2)

				if rng:RandomFloat() < 0.75 then
					flipReflection(npc)
				end
			end
		elseif sprite:IsFinished("Die") then
			npc.Visible = false
			npc:Die()
		end

		if sprite:IsPlaying("Die") then
			npc.Velocity = npc.Velocity * 0.6
		elseif data.navToMiddle then
			local targetOverride = game:GetRoom():GetCenterPos()
			local targetVelocity = (targetOverride - npc.Position):Resized(SPEED_LIGHTNING_NAV)
			npc.Velocity = mod.XalumLerp(npc.Velocity, targetVelocity, 0.1)

			if npc.Position:Distance(targetOverride) < LIGHTNING_DISTANCE_THRESHOLD then
				data.navToMiddle = false
				sprite:Play("LightningStrikeStart")
			end
		elseif sprite:IsPlaying("Idle01") then
			local targetVelocity = (target.Position - npc.Position):Resized(SPEED_IDLE)
			npc.Velocity = mod.XalumLerp(npc.Velocity, targetVelocity, 0.2)

			if npc.FrameCount - data.referenceFrame >= ATTACK_COOLDOWN then
				local attacks = {}
				for i = Attack.LIGHTNING_CHARGE, Attack.FIRE_SPIN do
					for j = 1, AttackWeight[i] do
						table.insert(attacks, i)
					end
				end

				if npc.HitPoints <= 1/3 * npc.MaxHitPoints then
					for i = 1, AttackWeight[Attack.DASH] do
						table.insert(attacks, Attack.DASH)
					end
				end

				local roll
				repeat
					roll = attacks[rng:RandomInt(#attacks) + 1]
				until roll ~= data.lastAttack
				data.lastAttack = roll

				if roll == Attack.DASH or data.forceDash then
					sprite:Play("DashStart")
					data.lastAttack = Attack.DASH
					data.forceDash = false
				elseif roll == Attack.LIGHTNING_CHARGE then
					data.navToMiddle = true
				elseif roll == Attack.SPIN then
					sprite:Play("SpinStart")
					sfx:Play(mod.Sounds.RaymondGrunt)
				elseif roll == Attack.FIRE_SPIN then
					sprite:Play("Idle02Start")
				end
			end
		elseif data.isSpinning then
			local timeDelta = npc.FrameCount - data.referenceFrame

			if timeDelta % TEARS_SPIN_SPAWN_FREQUENCY == 0 then
				local angle = data.lastAngle + 40
				data.lastAngle = angle

				for i = 0, 2 do
					npc:FireProjectiles(npc.Position, Vector.FromAngle(angle + 120 * i) * 7, 0, data.params.spin)
				end

				sfx:Play(SoundEffect.SOUND_BLOODSHOOT, 1, 0, false, randomPitch())
				spawnGenericBulletSplash(npc.Position)
			end

			local spinStrength = math.min(timeDelta / 2, 30) * 0.2
			local spinFrame = (data.spinStartAngle + timeDelta) / -10
			local spin = Vector(math.cos(spinFrame), math.sin(spinFrame)) * spinStrength
			local lurchStrength = math.max(0, 30 - timeDelta) / 30
			local lurch = lurchStrength * Vector.FromAngle(data.spinStartAngle)
			local lerpedSpin = mod.XalumLerp(npc.Velocity, spin, 0.1)
			local speed = npc.Velocity:Length()

			npc.Velocity = lerpedSpin + lurch + (target.Position - npc.Position):Resized(0.2) -- Nightmare nightmare nightmare nightmare nightmare nightmare nightmare
			npc.Velocity:Resize(math.min(speed, SPEED_SPINNING))

			if timeDelta >= TEARS_SPIN_DURATION then
				data.isSpinning = false
				sprite:Play("SpinEnd")
				sfx:Stop(SoundEffect.SOUND_ULTRA_GREED_SPINNING)
			end
		elseif sprite:IsPlaying("Dash" .. data.dashingString) then
			local timeDelta = npc.FrameCount - data.referenceFrame
			local currentAngle = npc.Velocity:GetAngleDegrees()
			npc.Velocity = npc.Velocity:Rotated(data.dashingAngle - currentAngle):Resized(SPEED_DASHING)

			if timeDelta >= DASHING_MAX_DURATION or didTargetCrossPerpendicularDash(npc, data.dashingAngle) then
				local attackVersion = rng:RandomFloat() < 0.5 and 1 or 2
				sprite:Play("Shoot0" .. attackVersion)

				if attackVersion == 2 then
					sfx:Play(mod.Sounds.RaymondIgnite, 1, 2, false, randomPitch())
				end
			end
		elseif sprite:IsPlaying("LightningStrikeStart") then
			npc.Velocity = npc.Velocity * 0.6 -- Slow the FUCK down!!!!!!
		elseif sprite:IsPlaying("Shoot01") or sprite:IsPlaying("Shoot02") then
			npc.Velocity = npc.Velocity * 0.8
		elseif not sprite:IsPlaying("SpinEnd") then
			npc.Velocity = npc.Velocity * 0.95
		end

		if sprite:IsPlaying("SpinLoop02") then
			local timeDelta = npc.FrameCount - data.referenceFrame

			if timeDelta >= TELEPORT_SPIN_DURATION then
				if data.teleportShoots >= 2 or data.forceDash then
					sprite:Play("SpinEnd02")
				else
					sprite:Play("SpinEnd02ToIdle02")
					data.teleportShoots = data.teleportShoots + 1
				end
			end
		end

		if sprite:IsPlaying("LightningStrikeLoop") then
			local timeDelta = npc.FrameCount - data.referenceFrame

			if timeDelta % LIGHTNING_TRACER_COOLDOWN == 0 then
				if not data.lightningStorage.Initialised then
					local rotationOffset = 360 * rng:RandomFloat()
					data.lightningStorage = {
						Points = {},
						Initialised = true,
					}

					for i = 1, 3 do
						data.lightningStorage.Points[i] = {}
						data.lightningStorage.Points[i][1] = npc.Position

						local angleFromRaymond = rotationOffset + 120 * i
						local endPoint = EntityLaser.CalculateEndPoint(npc.Position, Vector.FromAngle(angleFromRaymond), Vector.Zero, npc, 0)
						local midPoint = (endPoint + npc.Position) / 2

						local maximumDrift = math.min(
							EntityLaser.CalculateEndPoint(midPoint, Vector.FromAngle(angleFromRaymond + 90), Vector.Zero, npc, 0):Distance(midPoint),
							EntityLaser.CalculateEndPoint(midPoint, Vector.FromAngle(angleFromRaymond - 90), Vector.Zero, npc, 0):Distance(midPoint)
						)

						for j = 2, 3 do
							local driftEnd = EntityLaser.CalculateEndPoint(midPoint, Vector.FromAngle(angleFromRaymond + 90 + 180 * j), Vector.Zero, npc, 0)
							local driftInfluence = 0.7 + 0.2 * rng:RandomFloat()
							local driftStrength = maximumDrift * driftInfluence

							data.lightningStorage.Points[i][j] = midPoint + (driftEnd - midPoint):Resized(driftStrength)
						end

						data.lightningStorage.Points[i][4] = endPoint
					end
				end

				local currentPoint = math.floor((npc.FrameCount - data.referenceFrame) / LIGHTNING_TRACER_COOLDOWN + 1)
				if currentPoint <= 3 then
					for i = 1, 3 do
						local origin = data.lightningStorage.Points[i][currentPoint]
						local target = data.lightningStorage.Points[i][currentPoint+1]
						local targetDummy = mod:AddDummyEffect(npc, target - npc.Position)
						local tracer = Isaac.Spawn(1000, 175, 0, origin, Vector.Zero, npc):ToEffect()

						tracer.Parent = targetDummy
						tracer.Target = tracer
						tracer.Color = Color(1, 1, 1, 1)
						tracer.DepthOffset = -1000
						tracer.Timeout = LIGHTNING_CHARGE_DURATION - (npc.FrameCount - data.referenceFrame)

						local tracerSprite = tracer:GetSprite()
						tracerSprite:ReplaceSpritesheet(2, "gfx/nothing.png")
						tracerSprite:LoadGraphics()

						table.insert(data.dummies, originDummy)
						table.insert(data.dummies, targetDummy)
					end
				end
			end

			if timeDelta >= LIGHTNING_CHARGE_DURATION then
				sprite:Play("LightningStrike")
				setReflection(npc, false, true)
				sfx:Play(mod.Sounds.RaymondThunder, 1.75)
				sfx:Play(SoundEffect.SOUND_REDLIGHTNING_ZAP_BURST)
				game:GetRoom():DoLightningStrike()

				for _, dummy in pairs(data.dummies) do
					dummy:Remove()
				end

				data.dummies = {}

				for i = 1, 3 do
					for j = 1, 3 do
						local origin = data.lightningStorage.Points[i][j]
						local line = data.lightningStorage.Points[i][j+1] - origin
						local laser = EntityLaser.ShootAngle(2, origin, line:GetAngleDegrees(), 37, Vector.Zero, npc)
						laser:SetMaxDistance(line:Length())
						laser.Color = Color(1, 1, 1, 1, 1, 1, 1)
					end
				end
			end
		end

		if sprite:IsEventTriggered("SpinStart") then
			if sprite:IsPlaying("SpinStart") then
				data.referenceFrame = npc.FrameCount
				data.isSpinning = true
				npc.Velocity = (target.Position - npc.Position):Resized(SPEED_SPINNING)
				data.spinStartAngle = npc.Velocity:GetAngleDegrees()
				sfx:Play(SoundEffect.SOUND_ULTRA_GREED_SPINNING, 0.35, 0, true, 0.75)
			elseif sprite:IsPlaying("SpinStart02") then
				npc:FireProjectiles(npc.Position, (target.Position - npc.Position):Resized(13), 2, data.params.teleportSpin)
				sfx:Play(SoundEffect.SOUND_BLOODSHOOT, 1, 0, false, randomPitch())
				sfx:Play(SoundEffect.SOUND_CANDLE_LIGHT, 1, 0, false, randomPitch())
				sfx:Play(SoundEffect.SOUND_ULTRA_GREED_SPINNING, 0.45, 0, true, 1.1)
				spawnGenericBulletSplash(npc.Position)

				local centreTear
				local outerTears = {}

				for _, projectile in pairs(Isaac.FindByType(9), ProjectileVariant.PROJECTILE_TEAR) do
					if projectile.FrameCount == 0 then
						projectile:GetData().raymondBoomerangTear = true
						projectile:GetData().raymondFireTear = true

						if getAngleDifference(projectile.Velocity:GetAngleDegrees(), (target.Position - projectile.Position):GetAngleDegrees()) < 1 then
							centreTear = projectile
						else
							table.insert(outerTears, projectile)
						end
					end
				end

				for i, projectile in pairs(outerTears) do
					local angleDifference = getAngleDifference(projectile.Velocity:GetAngleDegrees(), centreTear.Velocity:GetAngleDegrees())
					local positivity = -2 * i + 3 -- If you ever ask me why this is here I will fucking cry okay
					angleDifference = angleDifference * positivity

					projectile.Velocity = projectile.Velocity:Rotated(3 * angleDifference)
					projectile:GetData().raymondBoomerangBend = -angleDifference / 10
				end
			end
		end

		if sprite:IsEventTriggered("Shoot") then
			npc:FireProjectiles(npc.Position, Vector(2, 6), 9, data.params.dash)
			sfx:Play(SoundEffect.SOUND_BLOODSHOOT, 1, 0, false, randomPitch())
			spawnGenericBulletSplash(npc.Position)

			local targerPosition = target.Position + target.Velocity * 3
			local angleDifference = getAngleDifference(0, (targerPosition - npc.Position):GetAngleDegrees())
			for _, projectile in pairs(Isaac.FindByType(9, ProjectileVariant.PROJECTILE_TEAR)) do
				if projectile.FrameCount == 0 then
					projectile.Velocity = projectile.Velocity:Rotated(angleDifference)
					projectile:GetData().skipRaymond = true
				end
			end

			if sprite:IsPlaying("Shoot02") then
				if data.isReflected then
					npc:FireProjectiles(npc.Position, (target.Position - npc.Position):Resized(7), 1, data.params.dash)
				else
					npc:FireProjectiles(npc.Position, (target.Position - npc.Position):Resized(7), 0, data.params.dash)
				end

				sfx:Play(SoundEffect.SOUND_BLOODSHOOT, 1, 0, false, randomPitch())

				for _, projectile in pairs(Isaac.FindByType(9, ProjectileVariant.PROJECTILE_TEAR)) do
					if projectile.FrameCount == 0 and not projectile:GetData().skipRaymond then
						projectile:GetData().raymondFireTear = true
					end
				end
			end
		end

		if sprite:IsEventTriggered("EyesIgnite") then
			sfx:Play(SoundEffect.SOUND_CANDLE_LIGHT, 1, 0, false, randomPitch())
		end

		if sprite:IsEventTriggered("Spark") then
			sfx:Play(mod.Sounds.RaymondIgnite, 1, 2, false, randomPitch())
		end

		if sprite:IsEventTriggered("Spin2End") then
			sfx:Stop(SoundEffect.SOUND_ULTRA_GREED_SPINNING)
			sfx:Play(mod.Sounds.RaymondGrunt, 0.5)
		end

		if sprite:IsEventTriggered("GenericSound") then
			sfx:Play(mod.Sounds.RaymondGrunt)
		end

		if sprite:IsEventTriggered("BucketClang") then
			sfx:Play(mod.Sounds.PvZBucket, 3)
		end

		if sprite:IsEventTriggered("Death") then
			sfx:Play(mod.Sounds.RaymondDeath)
		end

		if sprite:IsEventTriggered("LightningStrike") then
			sfx:Play(mod.Sounds.RaymondThunder, 1.75)
			sfx:Play(SoundEffect.SOUND_REDLIGHTNING_ZAP_BURST)
		end

		if sprite:IsEventTriggered("Explode") then
			mod.SpawnWhiteGhostExplosion(npc, true)
		end

		if npc.HitPoints <= 1/3 * npc.MaxHitPoints and not data.doneDash then
			data.doneDash = true
			data.forceDash = true
		end
	end,

	Render = function(npc)
		local data = npc:GetData()
		local mode = game:GetRoom():GetRenderMode()

		if mode == RenderMode.RENDER_WATER_ABOVE then
			npc.SpriteOffset = data.isReflected and Vector.Zero or THE_FUCK_OFF_ZONE
		elseif mode == RenderMode.RENDER_WATER_REFLECT then
			npc.SpriteOffset = data.isReflected and THE_FUCK_OFF_ZONE or Vector.Zero
		end
	end,

	Damage = function(npc, amount, flags, source, cooldown)
		if npc.HitPoints - amount < 0 then
			local sprite = npc:GetSprite()
			if not sprite:IsPlaying("Die") then
				npc.HitPoints = 1
				npc.EntityCollisionClass = 0
				npc:GetSprite():Play("Die")
			end
			
			if mod.CanRunUnlockAchievements() and game:GetRoom():GetType() == RoomType.ROOM_BOSS then
				FiendFolio.savedata.killedBosses = FiendFolio.savedata.killedBosses or {}
				FiendFolio.savedata.killedBosses["Raymond"] = true
			end

			setReflection(npc, false)
			sfx:Stop(SoundEffect.SOUND_ULTRA_GREED_SPINNING)
			return false
		end
	end,
}