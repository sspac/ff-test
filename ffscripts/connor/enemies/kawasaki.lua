local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local PROJ_SPEED = 4
local PROJ_ACCEL = 0.1
local PROJ_HEIGHT = 25
local PROJ_EXPLODE_MIN_DISTANCE = 200

local MIN_SHOOT_DELAY = 30
local MAX_SHOOT_DELAY = 80

local function FindKawasakiProjectiles(npc)
	local list = {}
	
	for _, proj in pairs(Isaac.FindByType(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, true)) do
		if mod:GetEntityData(proj).isKawasakiProjectile and proj.SpawnerEntity and proj.SpawnerEntity.InitSeed == npc.InitSeed then
			table.insert(list, proj)
		end
	end
	
	return list
end

local function FindKawasakiProjectileToExplode(npc)
	local targetPos = npc:GetPlayerTarget().Position
	local projToExplode = nil
	local bestDist = PROJ_EXPLODE_MIN_DISTANCE
	
	for _, proj in pairs(FindKawasakiProjectiles(npc)) do
		local dist = proj.Position:Distance(targetPos)
		if dist < bestDist then
			projToExplode = proj:ToProjectile()
			bestDist = dist
		end
	end
	
	return projToExplode
end

function mod:KawasakiUpdate(npc)
	local data = mod:GetEntityData(npc)
	local sprite = npc:GetSprite()
	local target = npc:GetPlayerTarget()
	
	if not data.init then
		data.init = true
		npc.StateFrame = MAX_SHOOT_DELAY
	end
	
	if not npc.TargetPosition or npc.TargetPosition:Length() == 0 then
		npc.TargetPosition = npc.Position
	end
	npc.Position = npc.TargetPosition
	npc.Velocity = Vector.Zero
	
	if sprite:IsPlaying("Idle") then
		npc.StateFrame = npc.StateFrame - 1
	end
	
	if npc.StateFrame <= 0 and not (target:ToPlayer() and mod:isFriend(npc)) then
		local numProjectiles = #FindKawasakiProjectiles(npc)
		if numProjectiles >= 3 or (numProjectiles == 2 and Random() % 3 == 0) then
			local projToExplode = FindKawasakiProjectileToExplode(npc)
			if projToExplode then
				sprite:Play("ExplodeShot", true)
				npc:PlaySound(SoundEffect.SOUND_GRROOWL, 1, 0, false, 0.8)
				npc.Child = projToExplode
			end
		elseif not (target:ToPlayer() and mod:isFriend(npc)) then
			sprite:Play("Shoot", true)
		end
		npc.StateFrame = mod:RandomInt(MIN_SHOOT_DELAY, MAX_SHOOT_DELAY)
	end
	
	if sprite:IsEventTriggered("Shoot") then
		npc:PlaySound(SoundEffect.SOUND_GHOST_SHOOT, 1, 0, false, 0.8)
		
		local proj = mod:LazySpawnProjectile(ProjectileVariant.PROJECTILE_NORMAL, 0, npc.Position, Vector.Zero, npc):ToProjectile()
		proj:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE | ProjectileFlags.BOUNCE)
		proj.FallingAccel = -0.1
		proj.Scale = 3
		proj.Height = -PROJ_HEIGHT
		proj.Color = Color(1,1,1, 1, 0.35, 0, 0)
		mod:GetEntityData(proj).isKawasakiProjectile = true
		proj.Visible = false
	elseif sprite:IsEventTriggered("ExplodeShot") and npc.Child and npc.Child:Exists() and npc.Child:ToProjectile() then
		npc:PlaySound(SoundEffect.SOUND_MEATY_DEATHS, 1, 0, false, 0.8)
		
		local projToExplode = npc.Child:ToProjectile()
		
		local numProjectiles = mod:RandomInt(10, 14)
		for i=1, numProjectiles do
			local targetDir = target.Position - projToExplode.Position
			local projVel = targetDir:Resized(PROJ_SPEED) + RandomVector() * ((Random() % 101) / 100) * 2
			local projPos = projToExplode.Position + projVel + Vector(0, projToExplode.Height * 0.5)
			local proj = mod:LazySpawnProjectile(ProjectileVariant.PROJECTILE_NORMAL, 0, projPos, projVel, npc):ToProjectile()
			proj.FallingSpeed = mod:RandomInt(-20, -60)
			proj.FallingAccel = 1.5
		end
		projToExplode:Die()
		
		npc.Child = nil
	elseif sprite:IsFinished() then
		sprite:Play("Idle", true)
	end
end

function mod:KawasakiDeath(npc)
	npc:PlaySound(SoundEffect.SOUND_DEATH_BURST_LARGE, 1, 0, false, 1)
end

function mod:KawasakiProjectileUpdate(proj, data)
	if not data.isKawasakiProjectile then return end
	
	local npc = proj.SpawnerEntity and proj.SpawnerEntity:ToNPC()
	
	if not npc or not npc:Exists() then
		proj:Die()
		return
	end
	
	proj.Height = -PROJ_HEIGHT * (1 + math.sin(math.pi * proj.FrameCount / 20) / 4)
	
	if not data.kawasakiPathingSeed or (proj.FrameCount % 90 == 0 and Random() % 3 == 0) then
		data.kawasakiPathingSeed = Random()
	end
	
	local target = npc:GetPlayerTarget()
	
	mod:CatheryPathFinding(proj, target.Position, {
		Speed = PROJ_SPEED,
		Accel = PROJ_ACCEL,
		Interval = 30,
		UseDirectPath = (proj.Position:Distance(target.Position) < 40),
		IgnorePits = true,
		Threshold = 900,
		PathingSeed = data.kawasakiPathingSeed,
		GiveUp = true,
	})
	
	if proj.FrameCount > 0 and not data.init then
		proj.Visible = true
		data.init = true
		
		if proj.FrameCount == 1 then
			proj.Position = npc.Position + proj.Velocity:Resized(20)
			proj.Velocity = proj.Velocity:Resized(PROJ_SPEED)
			
			local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 5, proj.Position, Vector.Zero, npc):ToEffect()
			effect.DepthOffset = npc.Position.Y * 1.25
			effect.SpriteScale = effect.SpriteScale * 0.4
			effect.Color = Color(1,1,1,0.4)
			effect.SpriteOffset = Vector(0, proj.Height)
			effect:Update()
		end
	end
	
	for _, otherProj in pairs(Isaac.FindInRadius(proj.Position, proj.Size * proj.Scale, EntityPartition.BULLET)) do
		if mod:GetEntityData(otherProj).isKawasakiProjectile and otherProj.InitSeed ~= proj.InitSeed then
			local push = proj.Position:Distance(otherProj.Position) > 0 and (proj.Position - otherProj.Position):Resized(1) or RandomVector()
			proj.Velocity = proj.Velocity + push
		end
	end
	
	if proj.FrameCount % 5 == 0 then
		local effPos = proj.Position + Vector(0, proj.Height) + RandomVector() * 5
		local eff = Isaac.Spawn(EntityType.ENTITY_EFFECT, 111, 0, effPos, proj.Velocity:Rotated(180) * 0.5, proj):ToEffect()
		eff:GetSprite().PlaybackSpeed = 0.5
		eff:GetSprite().Scale = Vector(0.5, 0.5)
		eff.Color = Color(1,1,1, 0.75)
	end
end

local GLOW_SPRITE = Sprite()
GLOW_SPRITE:Load("gfx/enemies/kawasaki/kawasaki_projectile_glow.anm2", true)
GLOW_SPRITE:Play("Idle", true)
GLOW_SPRITE:Stop()

function mod:KawasakiProjectileRender(proj, data)
	if not data.isKawasakiProjectile then return end
	
	local npc = proj.SpawnerEntity and proj.SpawnerEntity:ToNPC()
	
	if not npc or not npc:Exists() then return end
	
	if not data.kawasakiGlow then
		data.kawasakiGlow = 0
	end
	
	if npc.Child and GetPtrHash(npc.Child) == GetPtrHash(proj) then
		data.kawasakiGlow = math.min((data.kawasakiGlow or 0) + 0.03, 1.0)
	elseif data.kawasakiGlow > 0 then
		data.kawasakiGlow = math.max((data.kawasakiGlow or 0) - 0.03, 0)
	end
	
	if data.kawasakiGlow > 0 then
		GLOW_SPRITE.Color = Color(1,1,1, data.kawasakiGlow * 0.9)
		local renderPos = Isaac.WorldToScreen(proj.Position + Vector(0, proj.Height - 4))
		GLOW_SPRITE:Render(renderPos)
	end
end
