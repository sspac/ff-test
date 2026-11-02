local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local dirToStr = {
	[Direction.NO_DIRECTION] = "",
	[Direction.DOWN] = "Down",
	[Direction.UP] = "Up",
	[Direction.LEFT] = "Side",
	[Direction.RIGHT] = "Side",
}

local dirToVec = {
	[Direction.NO_DIRECTION] = Vector(0,0),
	[Direction.LEFT] = Vector(-1,0),
	[Direction.UP] = Vector(0,-1),
	[Direction.RIGHT] = Vector(1,0),
	[Direction.DOWN] = Vector(0,1)
}

function mod:isCollidingWithPlayer(e, extraRad)
	for i = 1, game:GetNumPlayers() do
		local player = Isaac.GetPlayer(i - 1)
		if (player.Position - e.Position):Length() <= player.Size + e.Size + (extraRad or 0) then
			return true
		end
	end

	return false
end

for i = 1, 2 do
	local variant = mod.ITEM.FAMILIAR["MERN_"..i]
	mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, fam)
		fam:AddToOrbit(0)
	end, variant)

	mod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, function(_, fam, other, low)
		if other:ToProjectile() and mod:GetEntityData(other).CharmedMernProj == fam.Index .. " " .. fam.InitSeed then
			return true
		elseif other:ToProjectile() then
			other:Die()
		end
	end, variant)
end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam)
	local off = EntityFamiliar.GetOrbitDistance(0)
	local val = math.sin(math.rad(fam.FrameCount) * 8)
	local dist = off:Length() + (val ^ 2 + 0.5) * 20
	fam.OrbitDistance = off:Resized(dist)
  --  fam.OrbitSpeed = -fam.OrbitSpeed
	fam.Velocity = fam:GetOrbitPosition(fam.Player.Position - fam.Player.Velocity) - fam.Position
end, mod.ITEM.FAMILIAR.MERN_1)

function mod:mernsCherryBombProjectileDeath(tear, data)
	if data.DoCherryBombExplosion then
		explosion = Isaac.Spawn(1000, 1, 0, tear.Position, Vector.Zero, tear):ToEffect()
		explosion.SpriteScale = Vector(0.6, 0.6)
		explosion.DepthOffset = 10
		local crater = Isaac.Spawn(1000, 18, 0, tear.Position, Vector.Zero, tear):ToEffect()
		crater.SpriteScale = Vector(0.6, 0.6)

		local radius = 30
		for _, enemy in ipairs(Isaac.FindInRadius(tear.Position, radius, EntityPartition.ENEMY)) do
			if enemy:IsActiveEnemy() and (not mod:isFriend(enemy)) and (enemy:IsVulnerableEnemy() or mod:GetEntityData(enemy).FFCopperBombHitbox) then
				local damage = 10
				enemy:TakeDamage(damage, DamageFlag.DAMAGE_EXPLOSION | DamageFlag.DAMAGE_IGNORE_ARMOR, EntityRef(tear), 0)
			end
		end
		for _, pickup in ipairs(Isaac.FindInRadius(tear.Position, radius, EntityPartition.PICKUP)) do
			local dist = (radius+70)/pickup.Position:Distance(tear.Position)
			pickup.Velocity = (pickup.Position-tear.Position):Resized(dist)
			if pickup.Velocity:Length() > 10 then
				pickup.Velocity = pickup.Velocity:Resized(10)
			end
		end
	end
end

function FiendFolio.SpawnMernIpecac(pos, vel, spawner, lvl2)
	local isSuperpositioned = mod:isSuperpositionedPlayer(spawner.Player)
	local isSirenCharmed = mod:isSirenCharmed(spawner)

	if isSirenCharmed then
		local proj = mod:LazySpawnProjectile(0, 0, pos, vel, spawner):ToProjectile()

		proj.FallingSpeed = -15
		proj.FallingAccel = 1
		mod:GetEntityData(proj).CharmedMernProj = spawner.Index .. " " .. spawner.InitSeed

		return proj
	else
		local corn = Isaac.Spawn(2, 22, 0, pos, vel, spawner):ToTear()

		local sprite = corn:GetSprite()
		sprite:Load("gfx/009.005_corn projectile.anm2", true)

		corn.FallingSpeed = -15
		corn.FallingAcceleration = 1
		corn.Color = Color(1,0.8,0,1,0,0,0)


		if lvl2 then
			sprite:Play("Small0"..math.random(4))
			mod:GetEntityData(corn).DoCherryBombExplosion = true
		else
			sprite:Play("Big0"..math.random(4))
			corn.Scale = 2
			corn.TearFlags = TearFlags.TEAR_EXPLOSIVE
		end

		if isSuperpositioned then
			local tearcolor = Color.Lerp(corn.Color, Color(1,1,1,1,0,0,0), 0)
			tearcolor.A = tearcolor.A / 4
			corn.Color = tearcolor
		end

		return corn
	end
end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam)
	-- copied from mern_1
	local off = EntityFamiliar.GetOrbitDistance(0)
	local val = math.sin(math.rad(fam.FrameCount) * 8)
	local dist = off:Length() + (val ^ 2 + 0.5) * 20
	fam.OrbitDistance = off:Resized(dist)
	fam.Velocity = fam:GetOrbitPosition(fam.Player.Position - fam.Player.Velocity) - fam.Position

	local p = fam.Player
	local d = mod:GetEntityData(fam)
	local s = fam:GetSprite()
	local dir = p:GetFireDirection()
	local animdir = dirToStr[dir]
	d.animpre = d.animpre or "Float"
	d.cooldown = d.cooldown or 0

	if not (p:GetFireDirection() == Direction.NO_DIRECTION) and d.cooldown - fam.FrameCount <= 0 then
		d.animpre = "FloatShoot"
		d.cooldown = fam.FrameCount + 60
		s.FlipX = dir == Direction.LEFT

		FiendFolio.SpawnMernIpecac(fam.Position, dirToVec[dir]:Resized(11), fam, true)
	end

	if d.animpre == "Float" then
		local shootInput = p:GetFireDirection()
		if shootInput == Direction.NO_DIRECTION then
			animdir = "Down"
		end
		s.FlipX = dir == Direction.LEFT
	end

	s:SetFrame(d.animpre..animdir, fam.FrameCount % 15)

	if d.animpre == "FloatShoot" and d.cooldown - fam.FrameCount <= 50 then
		d.animpre = "Float"
	end

end, mod.ITEM.FAMILIAR.MERN_2)

for i = 3, 4 do
	mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, f)
		f.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
	end, mod.ITEM.FAMILIAR["MERN_"..i])
end

mod.MernWhitelist = {
	[EntityType.ENTITY_STONEY] = true,
	[EntityType.ENTITY_STONEHEAD] = true,
	[EntityType.ENTITY_POKY] = true,
}

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, f)
	local s = f:GetSprite()
	local d = mod:GetEntityData(f)
	local room = game:GetRoom()
	local isSirenCharmed = mod:isSirenCharmed(f)

	d.doneframe = d.doneframe or 0
	if room:GetFrameCount() == 0 then
		d.doneframe = f.FrameCount
	end

	if d.teleporttime then
		f.Velocity = f.Velocity * 0.8

		s:Play("Anger")

		if not d.target:Exists() or d.target:IsDead() or (d.target.Type == 1 and not isSirenCharmed) or (d.target.Type ~= 1 and isSirenCharmed) then
			d.teleporttime = false
			d.doneframe = f.FrameCount
			return
		end

		if (f.FrameCount - d.teleporttime) % 10 == 5 then
			if f.FrameCount - d.teleporttime < 25 then
				f.Position = room:GetRandomPosition(0)
				while isSirenCharmed and mod:isCollidingWithPlayer(f, 40) do
					f.Position = room:GetRandomPosition(0)
				end
			else
				f.Position = d.target.Position
				if isSirenCharmed then
					f.Position = room:GetClampedPosition(d.target.Position + RandomVector():Resized(d.target.Size + f.Size + 40), 0)
					while (f.Position - d.target.Position):Length() < d.target.Size + f.Size + 40 do
						f.Position = room:GetClampedPosition(d.target.Position + RandomVector():Resized(d.target.Size + f.Size + 40), 0)
					end
				end
				d.teleporttime = false
				d.doneframe = f.FrameCount
			end
			sfx:Play(SoundEffect.SOUND_HELL_PORTAL1, 0.5, 0, false, 1)
			f:SetColor(Color(1,1,1,1,1,1,1), 5, 5, true, false)
		end
	else
		if not d.dir or f.FrameCount % 15 == math.random(15) then
			d.dir = RandomVector()
		end

		if f.Velocity:Length() > 0.3 then
			if math.abs(f.Velocity.X) > math.abs(f.Velocity.Y) then
				s:Play("WalkHori")
				s.FlipX = f.Velocity.X < 0
			else
				s:Play("WalkVert")
				s.FlipX = false
			end
		else
			s:Play("Idle")
		end

		f.Velocity = f.Velocity + d.dir
		f.Velocity = f.Velocity:Resized(math.min(f.Velocity:Length() * 1.2, 2))

		if FiendFolio.IsActiveRoom() and (f.FrameCount - d.doneframe) >= 180 then
			if isSirenCharmed then
				local population = Isaac.FindInRadius(f.Position, 99999, EntityPartition.PLAYER)

				if #population > 0 then
					d.target = population[math.random(#population)]
					d.teleporttime = f.FrameCount
				end
			else
				local population = Isaac.FindInRadius(f.Position, 99999, EntityPartition.ENEMY)

				if #population > 0 then
					local found = false
					for i = 1, 30 do
						d.target = population[math.random(#population)]
						if mod.MernWhitelist[d.target.Type] or not d.target:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) then
							found = true
							break
						end
					end

					if found then
						d.teleporttime = f.FrameCount
					end
				end
			end
		end
	end
end, mod.ITEM.FAMILIAR.MERN_3)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, f)
	local s = f:GetSprite()
	local d = mod:GetEntityData(f)
	local room = game:GetRoom()
	local isSirenCharmed = mod:isSirenCharmed(f)

	d.doneframe = d.doneframe or 0
	if room:GetFrameCount() == 0 then
		d.doneframe = f.FrameCount
	end

	if f.Velocity:Length() > 0.3 then
		if math.abs(f.Velocity.X) > math.abs(f.Velocity.Y) then
			s:Play("WalkHori")
			s.FlipX = f.Velocity.X < 0
		else
			s:Play("WalkVert")
			s.FlipX = false
		end
	else
		s:Play("Idle")
	end

	if not d.target or not d.target:Exists() or d.target:IsDead() or (d.target.Type == 1 and not isSirenCharmed) or (d.target.Type ~= 1 and isSirenCharmed) then
		if not FiendFolio.IsActiveRoom() then
			d.target = nil
		else
			if isSirenCharmed then
				local population = Isaac.FindInRadius(f.Position, 99999, EntityPartition.PLAYER)

				if #population > 0 then
					d.target = population[math.random(#population)]
					d.doneframe = f.FrameCount
				else
					d.target = nil
				end
			else
				local found = false

				local population = Isaac.FindInRadius(f.Position, 99999, EntityPartition.ENEMY)
				if #population > 0 then
					for i = 1, 30 do
						d.target = population[math.random(#population)]
						if mod.MernWhitelist[d.target.Type] or not d.target:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) then
							found = true
							break
						end
					end
				end

				if found then
					d.doneframe = f.FrameCount
				else
					d.target = nil
				end
			end
		end
	end

	local pathTarget, size, speed
	if d.target then
		pathTarget = d.target.Position
		size = d.target.Size
		speed = 9
		if isSirenCharmed then speed = 5 end
	else
		local dir = f.Player:GetMovementVector()
		if dir:LengthSquared() < 0.1 then
			d.direction =  d.direction or Vector(0, 1)
		else
			d.direction = Vector(dir.X, dir.Y)
		end
		pathTarget = f.Player.Position - d.direction * 40
		size = f.Player.Size
		speed = 5
	end

	if d.target and f.FrameCount % 50 == 0 then
		s:PlayOverlay("Spit", true)
	end

	if s:IsOverlayPlaying("Spit") then
		f.Velocity = f.Velocity * 0.8

		--if s:IsEventTriggered("spit") then
		if s:GetOverlayFrame() == 3 then
			local corn = FiendFolio.SpawnMernIpecac(f.Position, (pathTarget - f.Position):Resized(10), f)

			corn.FallingSpeed = -20
		end
	else
		s:PlayOverlay("Attack", true)
	end

	local close = f.Position:DistanceSquared(pathTarget) < (size + f.Size + 10) ^ 2

	if not close and f.FrameCount - d.doneframe >= 40 then
		f.Velocity = f.Velocity * 0.8

		local bet = mod:Lerp(f.Position, pathTarget, math.random())
		bet = room:FindFreeTilePosition(bet, 1600)

		local orig = f.Position
		f.Position = bet

		if isSirenCharmed and mod:isCollidingWithPlayer(f, 20) then
			f.Position = orig
			return
		end

		sfx:Play(SoundEffect.SOUND_HELL_PORTAL1, 0.5, 0, false, 1)
		f:SetColor(Color(1,1,1,1,1,1,1), 5, 5, true, false)
		d.doneframe = f.FrameCount
	else
		mod:CatheryPathFinding(f, pathTarget, {
			Speed = speed,
			Accel = 0.3,
			Threshold = 600
		})
	end
end, mod.ITEM.FAMILIAR.MERN_4)