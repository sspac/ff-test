local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local MIN_SIZE = 0.7
local MAX_SIZE = 1.5

local MAX_KILLS = 15  -- # of kills to reach max size, then reset at the start of the next room.

local MIN_SPEED_MOD = -0.1
local MAX_SPEED_MOD = -0.3

local MIN_DAMAGE = 2
local MAX_DAMAGE = 5

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player)
	if player:HasTrinket(mod.ITEM.TRINKET.SISYPHEAN_BOULDER) then
		local scale = math.min((mod:GetEntityData(player).ffsavedata.SisypheanBoulderKills or 0) / MAX_KILLS, 1)
		player.MoveSpeed = player.MoveSpeed + mod:Lerp(MIN_SPEED_MOD, MAX_SPEED_MOD, scale)
	end
end, CacheFlag.CACHE_SPEED)

function mod:CheckSisypheanBoulder(player, data)
	if data.ffSisypheanBoulder and not player:HasTrinket(mod.ITEM.TRINKET.SISYPHEAN_BOULDER) then
		local boulder = mod:GetPointee(data.ffSisypheanBoulder)
		if boulder then
			boulder:Remove()
		end
		data.ffSisypheanBoulder = nil
	end
end

mod:AddTrinketCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.ITEM.TRINKET.SISYPHEAN_BOULDER, function(_, player)
	if not player:HasTrinket(mod.ITEM.TRINKET.SISYPHEAN_BOULDER) then
		return
	end

	local data = mod:GetEntityData(player)

	local boulder = mod:GetPointee(data.ffSisypheanBoulder) 

	if not boulder then
		boulder = Isaac.Spawn(mod.FF.RockBallMines.ID, mod.FF.RockBallMines.Var, mod.FF.RockBallMines.Sub, player.Position + Vector(40, 0), mod.nilvector, player):ToNPC()
		mod:GetEntityData(boulder).noBreakPlease = true
		mod:GetEntityData(boulder).isSisypheanBoulder = true
		data.ffSisypheanBoulder = EntityPtr(boulder)
		boulder:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		boulder:AddCharmed(EntityRef(player), -1)
		boulder:Update()
		boulder.V2 = Vector(0, -100)
		boulder:SetColor(Color(1,1,1,0), 20, 1, true, false)
		local scale = math.min((data.ffsavedata.SisypheanBoulderKills or 0) / MAX_KILLS, 1)
		boulder.Scale = mod:Lerp(MIN_SIZE, MAX_SIZE, scale)
	end

	if game:GetRoom():GetFrameCount() == 0 and (data.ffsavedata.SisypheanBoulderKills or 0) >= MAX_KILLS then
		data.ffsavedata.SisypheanBoulderKills = 0
		boulder.Scale = MIN_SIZE
		player:AddCacheFlags(CacheFlag.CACHE_SPEED, true)
	end

	boulder.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES

	local boulderData = mod:GetEntityData(boulder)

	boulderData.ffSisypheanBoulderCanFly = player.GridCollisionClass <= EntityGridCollisionClass.GRIDCOLL_WALLS

	local targetDist = boulder.Size * boulder.Scale + player.Size + 8

	local dist = boulder.Position:Distance(player.Position)

	if dist > targetDist then
		boulder.Position = player.Position + (boulder.Position - player.Position):Resized(targetDist)
		dist = targetDist
	end

	local targetPos = player.Position + player.Velocity:Resized(targetDist) --+ player.Velocity
	local distFromTarget = targetPos:Distance(boulder.Position)

	local targetVel = mod.nilvector

	data.ffSisypheanBoulderStruggling = false

	if player.Velocity:Length() > 0.1 then
		local rockSpeed = player.MoveSpeed * 11

		local subt = boulder.SubType
		if subt == mod.FF.RockBallTumbleweed.Sub or subt == mod.FF.RockBallFootball.Sub then
			rockSpeed = rockSpeed * 2
		else
			local scale = math.min((data.ffsavedata.SisypheanBoulderKills or 0) / MAX_KILLS, 1)
			local weight = mod:Lerp(0.1, 0.6, scale)
			local n = 1.0

			local a = targetDist * 0.7
			local b = targetDist * 1.7
			if distFromTarget > a then
				n = 1 - math.min((distFromTarget - a) / (b - a), 1)
				n = (1-weight) + n * weight
				data.ffSisypheanBoulderStruggling = true
			end

			player.Velocity = player.Velocity * n
			rockSpeed = rockSpeed * n
		end

		targetVel = (targetPos - boulder.Position):Resized(math.min(distFromTarget + player.Velocity:Length(), rockSpeed))
	end

	boulder.Velocity = mod:Lerp(boulder.Velocity, targetVel, 0.2)
end)

local blockSound = false

mod:AddCallback(ModCallbacks.MC_PRE_SFX_PLAY, function()
	if blockSound then
		blockSound = false
		return false
	end
end, SoundEffect.SOUND_STONE_IMPACT)

mod:AddCallback(ModCallbacks.MC_NPC_GRID_COLLISION, function(_, boulder, gridIndex, gridEntity)
	blockSound = mod:GetEntityData(boulder).CollidesWithGrid == true
end, 915)

function mod:SisypheanBoulderUpdate(boulder, data)
	if not data.isSisypheanBoulder then return end

	if data.ffSisypheanBoulderCanFly then
		boulder.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
		boulder.SpriteOffset = Vector(0, -4)
	else
		boulder.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
		boulder.SpriteOffset = Vector(0, 0)
	end

	local boulderIdx = room:GetGridIndex(boulder.Position)
	for i=0, 7 do
		local door = room:GetDoor(i)
		if door and door:IsOpen() then
			local idx1 = door:GetGridIndex()
			local idx2 = room:GetGridIndex(room:GetClampedPosition(room:GetDoorSlotPosition(i), 20))
			if boulderIdx == idx1 or boulderIdx == idx2 then
				boulder.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
				break
			end
		end
	end

	data.CollidesWithGrid = boulder:CollidesWithGrid()

	if boulder.SubType == mod.FF.RockBallFootball.Sub and not data.Landed and boulder.V2.Y == 0 then
		if sfx:IsPlaying(SoundEffect.SOUND_STONE_IMPACT) then
			sfx:Stop(SoundEffect.SOUND_STONE_IMPACT)
			sfx:Play(mod.Sounds.FootballPunt, 1, 0, false, 1)
		end
	end

	if data.Landed then
		boulder.V1.Y = 0
		boulder.V2.Y = 0
	elseif boulder.FrameCount > 1 and boulder.V1.Y == 0 then
		data.Landed = true
	end
end

function mod:SisypheanBoulderCollision(boulder, data, collider)
	if not data.isSisypheanBoulder then return end

	local colliderType = collider.Type
	if colliderType == EntityType.ENTITY_PLAYER or colliderType == EntityType.ENTITY_TEAR then
		return true
	elseif colliderType == EntityType.ENTITY_PROJECTILE and not collider:ToProjectile():HasProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER) then
		collider:Kill()
	elseif collider:IsVulnerableEnemy() and not collider:IsDead() and not collider:HasMortalDamage() then
		local player = boulder.SpawnerEntity and boulder.SpawnerEntity:ToPlayer()
		if not player then return end
		local d = mod:GetEntityData(player).ffsavedata
		if not d then return end

		local scale = (d.SisypheanBoulderKills or 0) / MAX_KILLS
		local power = mod.GetGolemTrinketPower(player, mod.ITEM.TRINKET.SISYPHEAN_BOULDER)
		collider:TakeDamage(mod:Lerp(MIN_DAMAGE, MAX_DAMAGE, scale) * power, 0, EntityRef(boulder), 0)

		if collider:IsDead() or collider:HasMortalDamage() then
			d.SisypheanBoulderKills = (d.SisypheanBoulderKills or 0) + 1
			if d.SisypheanBoulderKills <= MAX_KILLS then
				local newscale = (d.SisypheanBoulderKills or 0) / MAX_KILLS
				boulder.Scale = mod:Lerp(MIN_SIZE, MAX_SIZE, newscale)
				player:AddCacheFlags(CacheFlag.CACHE_SPEED, true)
			end
		end
	end
end

local sweaticon = Sprite()
sweaticon:Load("gfx/ui/ff_statuseffects.anm2", true)
sweaticon:Play("Sweaty", true)

function mod:SisypheanBoulderPostUpdate()
	sweaticon:Update()
end

function mod:SisypheanBoulderPlayerRender(player, data)
	if data.ffSisypheanBoulderStruggling then
		--local renderPos = Isaac.WorldToScreen(player.Position + Vector(20, -30 - player.Size))
		--sweaticon:Render(renderPos)
	end
end
