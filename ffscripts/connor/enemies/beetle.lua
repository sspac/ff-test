local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local ZERO_VECTOR = Vector.Zero

local MOVE_SPEED = 5
local FOLLOW_RANGE = 160
local AVG_MOVE_TIME = 20
local AVG_IDLE_TIME = 10

local FLY_SPEED = 8
local GUARD_RADIUS = 30
local INTERCEPT_PREDICTION = 20

local GUARD_COOLDOWN = 20
local INTERCEPT_COOLDOWN = 40
local FAMILIAR_COOLDOWN = 10

local TIMER_VARIANCE = 0.2

local function VaryTimer(timer)
	local mult = (1-TIMER_VARIANCE) + TIMER_VARIANCE * 2 * (Random() % 101) / 100
	return math.ceil(timer * mult)
end

local function IsBeetle(ent)
	return (ent.Type == mod.FF.Beetle.ID and ent.Variant == mod.FF.Beetle.Var)
		or (ent.Type == EntityType.ENTITY_FAMILIAR and ent.Variant == mod.ITEM.FAMILIAR.BLUE_BEETLE)
end

local function IsFriendlyBeetle(ent)
	return IsBeetle(ent) and (ent.Type == EntityType.ENTITY_FAMILIAR or mod:isFriend(ent))
end

local function ShouldBeetleBlock(ent, proj)
	if IsBeetle(ent) and proj:Exists() and not proj:IsDead() then
		local isFriendly = IsFriendlyBeetle(ent)
		
		if proj.Type == EntityType.ENTITY_PROJECTILE then
			proj = proj:ToProjectile()
			return (isFriendly and not proj:HasProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER))
				or (not isFriendly and proj:HasProjectileFlags(ProjectileFlags.HIT_ENEMIES))
		elseif proj.Type == EntityType.ENTITY_TEAR then
			return not isFriendly
		end
	end
end

local function TriangleArea(a, b, c)
	return math.abs((b - a):Cross(c - a)) / 2
end

local function LineCircleCollision(circlePos, radius, lineStart, lineEnd)
	local minDist = 2 * TriangleArea(circlePos, lineStart, lineEnd) / lineStart:Distance(lineEnd)
	return minDist <= radius
end

local function FindProjToIntercept(beetle)
	local room = game:GetRoom()
	
	local possibleTargets = {}
	
	for _, proj in ipairs(Isaac.FindByType(EntityType.ENTITY_PROJECTILE)) do
		if ShouldBeetleBlock(beetle, proj) then
			table.insert(possibleTargets, proj)
		end
	end
	
	if not IsFriendlyBeetle(beetle) then
		for _, tear in ipairs(Isaac.FindByType(EntityType.ENTITY_TEAR)) do
			if ShouldBeetleBlock(beetle, tear) then
				table.insert(possibleTargets, tear)
			end
		end
	end
	
	if #possibleTargets == 0 then return end
	
	local isGuarding = beetle.Parent and beetle.Parent:Exists()
	local isGuardingPlayer = isGuarding and beetle.Parent:ToPlayer()
	local interceptMode = isGuardingPlayer or not isGuarding
	local guardRadius = interceptMode and (INTERCEPT_PREDICTION * FLY_SPEED) or GUARD_RADIUS
	local guardPoint = isGuarding and beetle.Parent.Position or beetle.Position
	
	for _, target in ipairs(possibleTargets) do
		local tData = mod:GetEntityData(target)
		local dist = guardPoint:Distance(target.Position)
		local targetMovingCloser = dist > guardPoint:Distance(target.Position + target.Velocity)
		local beetleFaster = target.Velocity:Length() < FLY_SPEED
		local tearComesWithinRange = LineCircleCollision(guardPoint, guardRadius, target.Position, target.Position + target.Velocity * INTERCEPT_PREDICTION)
		local alreadyTargeted = tData.ffBeetleTargeted and tData.ffBeetleTargeted > game:GetFrameCount()
		
		if not alreadyTargeted and (targetMovingCloser or beetleFaster) and tearComesWithinRange then
			local interceptPos
			local frame = 0
			
			if interceptMode then
				-- Intercept mode
				while frame <= INTERCEPT_PREDICTION do
					local possibleInterceptPos = target.Position + target.Velocity * (frame+1)
					local gridCol = room:GetGridCollisionAtPos(possibleInterceptPos)
					if gridCol >= GridCollisionClass.COLLISION_SOLID and target.GridCollisionClass >= EntityGridCollisionClass.GRIDCOLL_BULLET then
						-- The target won't be able to reach further than this.
						break
					end
					if gridCol == GridCollisionClass.COLLISION_NONE and room:CheckLine(beetle.Position, possibleInterceptPos, 3, 900) then
						local dist = beetle.Position:Distance(possibleInterceptPos)
						if dist / FLY_SPEED <= frame then
							interceptPos = possibleInterceptPos
							break
						end
					end
					frame = frame + 1
				end
				frame = frame + 1
			else
				local dir = (target.Position - guardPoint):Normalized()
				interceptPos = guardPoint + dir:Resized(beetle.Parent.Size + GUARD_RADIUS)
				frame = math.floor(beetle.Position:Distance(interceptPos) / FLY_SPEED)
			end
			
			if interceptPos and frame > 3 then
				tData.ffBeetleTargeted = game:GetFrameCount() + VaryTimer(frame) * (interceptMode and 0.25 or 0.75)
				return interceptPos, frame
			end
		end
	end
end

local function UpdateParent(beetle)
	if beetle.Type == EntityType.ENTITY_FAMILIAR then
		beetle.Parent = beetle:ToFamiliar().Player or game:GetNearestPlayer(beetle.Position)
		return
	elseif mod:isFriend(beetle) then
		beetle.Parent = game:GetNearestPlayer(beetle.Position)
		return
	end
	
	beetle = beetle:ToNPC()
	local data = mod:GetEntityData(beetle)
	local room = game:GetRoom()
	local nearby = Isaac.FindInRadius(beetle.Position, FOLLOW_RANGE, EntityPartition.ENEMY)
	
	local beetles = {}
	
	local target
	local targetDist
	
	for _, ent in ipairs(nearby) do
		if GetPtrHash(ent) ~= GetPtrHash(beetle) then
			local dist = ent.Position:Distance(beetle.Position)
			if ent.Type == beetle.Type and ent.Variant == beetle.Variant then
				table.insert(beetles, ent)
			elseif ent.Type ~= EntityType.ENTITY_FIREPLACE and (not target or dist < targetDist)
					and room:GetGridCollisionAtPos(ent.Position) == GridCollisionClass.COLLISION_NONE
					and room:CheckLine(beetle.Position, ent.Position, 1) then
				target = ent
				targetDist = dist
			end
		end
	end
	
	if not target then
		for _, pickup in ipairs(Isaac.FindInRadius(beetle.Position, FOLLOW_RANGE, EntityPartition.PICKUP)) do
			local dist = pickup.Position:Distance(beetle.Position)
			if (not target or dist < targetDist) and room:GetGridCollisionAtPos(pickup.Position) == GridCollisionClass.COLLISION_NONE
					and room:CheckLine(beetle.Position, pickup.Position, 1) then
				target = pickup
				targetDist = dist
			end
		end
	end
	
	beetle.Parent = target
	
	if not target then
		local centerPos = beetle.Position
		for _, otherBeetle in ipairs(beetles) do
			centerPos = centerPos + otherBeetle.Position
		end
		centerPos = centerPos / (#beetles+1)
		
		beetle.V1 = centerPos
	end
end

-- Note that both the enemy and familiar beetles call this function!
function mod:BeetleUpdate(beetle)
	local room = game:GetRoom()
	local sprite = beetle:GetSprite()
	local data = mod:GetEntityData(beetle)
	
	if beetle.State == NpcState.STATE_APPEAR_CUSTOM then
		return
	end
	
	if not data.ffBeetleTimer then
		data.ffBeetleTimer = 0
		data.ffBeetleAttackCooldown = 0
	end
	
	if beetle.State == NpcState.STATE_JUMP then
		if not beetle.Parent or not beetle.Parent:Exists()
				or beetle.Position:Distance(beetle.Parent.Position + (data.ffBeetleTargetOffset or ZERO_VECTOR)) < 40 then
			data.ffBeetleTimer = 0
		end
	else
		data.ffBeetleTimer = data.ffBeetleTimer - 1
	end
	
	if data.ffBeetleAttackCooldown > 0 then
		data.ffBeetleAttackCooldown = data.ffBeetleAttackCooldown - 1
	end
	
	if data.ffBeetleTimer <= 0 then
		UpdateParent(beetle)
		beetle.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
		if beetle.State ~= NpcState.STATE_IDLE then
			-- STOP
			beetle.State = NpcState.STATE_IDLE
			beetle.TargetPosition = ZERO_VECTOR
			data.ffBeetleTimer = VaryTimer(AVG_IDLE_TIME)
		elseif beetle.Parent and beetle.Parent:ToPlayer() and room:GetGridCollisionAtPos(beetle.Parent.Position) == GridCollisionClass.COLLISION_NONE
				and (beetle.Parent.Position:Distance(beetle.Position) > FOLLOW_RANGE or not room:CheckLine(beetle.Position, beetle.Parent.Position, 1)) then
			-- FLY TO PLAYER
			beetle.State = NpcState.STATE_JUMP
			local targetPos = beetle.Parent.Position + RandomVector() * 20
			beetle.TargetPosition = ZERO_VECTOR
			data.ffBeetleTimer = 1
			beetle.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
			data.ffBeetleTargetOffset = RandomVector() * (Random() % 30)
		else
			-- MOVE
			beetle.State = NpcState.STATE_MOVE
			
			local targetPos
			
			if beetle.Parent and room:CheckLine(beetle.Position, beetle.Parent.Position, 1) then
				targetPos = beetle.Parent.Position + RandomVector() * (beetle.Parent.Size + beetle.Size)
			elseif beetle:ToNPC() and beetle:ToNPC().V1:Length() > 0 then
				targetPos = beetle:ToNPC().V1 + RandomVector() * (Random() % 65)
			else
				-- Move randomly.
				targetPos = Isaac.GetFreeNearPosition(beetle.Position + RandomVector() * MOVE_SPEED * 20, beetle.Size)
			end
			
			beetle.TargetPosition = (targetPos - beetle.Position):Normalized()
			local dist = targetPos:Distance(beetle.Position)
			data.ffBeetleTimer = VaryTimer(math.min(5 + dist / MOVE_SPEED, AVG_MOVE_TIME))
			
			sprite.FlipX = beetle.TargetPosition.X < 0
		end
	elseif (beetle.State == NpcState.STATE_IDLE or beetle.State == NpcState.STATE_MOVE) and data.ffBeetleTimer % 5 == 0 and data.ffBeetleAttackCooldown <= 0 then
		local interceptPos, interceptFrames = FindProjToIntercept(beetle)
		if interceptPos then
			-- INTERCEPT
			beetle.State = NpcState.STATE_ATTACK
			beetle.TargetPosition = (interceptPos - beetle.Position):Normalized()
			data.ffBeetleTimer = interceptFrames
			sprite.FlipX = beetle.TargetPosition.X < 0
			beetle.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS
			local cooldown
			if beetle.Type == EntityType.ENTITY_FAMILIAR then
				cooldown = FAMILIAR_COOLDOWN
			elseif beetle.Parent and beetle.Parent:Exists() and not beetle.Parent:ToPlayer() then
				cooldown = GUARD_COOLDOWN
			else
				cooldown = INTERCEPT_COOLDOWN
			end
			data.ffBeetleAttackCooldown = VaryTimer(cooldown)
		end
	end
	
	local targetAnim, lerpStrength, speed, targetVel
	
	if beetle.State == NpcState.STATE_MOVE then
		targetAnim = "Walk"
		lerpStrength = 0.15
		speed = MOVE_SPEED
	elseif beetle.State == NpcState.STATE_JUMP then
		targetAnim = "Flying"
		lerpStrength = 0.2
		speed = FLY_SPEED
		local targetPos = beetle.Parent.Position + data.ffBeetleTargetOffset or ZERO_VECTOR
		beetle.TargetPosition = (targetPos - beetle.Position):Normalized()
		sprite.FlipX = beetle.TargetPosition.X < 0
	elseif beetle.State == NpcState.STATE_ATTACK then
		targetAnim = "Flying"
		lerpStrength = 0.5
		speed = FLY_SPEED
	else
		targetAnim = "Idle"
		lerpStrength = 0.25
		speed = 0
	end
	
	if sprite:GetAnimation() ~= targetAnim then
		sprite:Play(targetAnim, true)
	end
	
	beetle.Velocity = mod:Lerp(beetle.Velocity, beetle.TargetPosition:Resized(speed), lerpStrength)
end

function mod:NpcBeetleInit(npc)
	npc.Position = npc.Position + RandomVector() * (Random() % 20)

	if Random() % 2 == 0 then
		npc:GetSprite().FlipX = true
	end
end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, beetle)
	local data = mod:GetEntityData(beetle)
	local player = beetle.Player or Isaac.GetPlayer()
	
	-- Thanks Erf
	if player:HasCollectible(CollectibleType.COLLECTIBLE_HIVE_MIND) then
		beetle.SpriteScale = Vector(1.25,1.25)
		if not data.HiveMinded then
			beetle:SetSize(18, Vector(1.25,1.25), 12)
			data.HiveMinded = true
		end
	else
		beetle.SpriteScale = Vector(1,1)
		if data.HiveMinded then
			beetle:SetSize(13, Vector(1,1), 12)
			data.HiveMinded = nil
		end
	end
	
	if data.iFrames and data.iFrames > 0 then
		data.iFrames = data.iFrames - 1
		
		if beetle.FrameCount % 3 == 0 then
			beetle:SetColor(Color(1,1,1,0), 2, 1, false, false)
		end
	end
	
	mod:BeetleUpdate(beetle)
end, mod.ITEM.FAMILIAR.BLUE_BEETLE)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, beetle)
	beetle.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
	if beetle.SubType == 0 then
		beetle:GetSprite():ReplaceSpritesheet(0, "gfx/enemies/beetle/blue_beetle.png")
	elseif beetle.SubType == 1 then
		beetle:GetSprite():ReplaceSpritesheet(0, "gfx/enemies/beetle/ladybugs/fiendish_beetle.png")
	elseif beetle.SubType == 2 then
		beetle:GetSprite():ReplaceSpritesheet(0, "gfx/enemies/beetle/ladybugs/bastardly_beetle.png")
	elseif beetle.SubType == 3 then
		beetle:GetSprite():ReplaceSpritesheet(0, "gfx/enemies/beetle/ladybugs/friendly_beetle.png")
	elseif beetle.SubType == 4 then
		beetle:GetSprite():ReplaceSpritesheet(0, "gfx/enemies/beetle/ladybugs/skeletal_beetle.png")
	end
	beetle:GetSprite():LoadGraphics()
end, mod.ITEM.FAMILIAR.BLUE_BEETLE)

function mod:BeetleUpdate60(beetle)
	local sprite = beetle:GetSprite()
	local data = mod:GetEntityData(beetle)
	
	local currentFrame = Isaac.GetFrameCount()
	if game:IsPaused() or data.ffBeetleLastUpdate == currentFrame then return end
	data.ffBeetleLastUpdate = currentFrame
	
	if beetle.State == NpcState.STATE_APPEAR_CUSTOM then
		if not data.ffBeetleThrow then
			data.ffBeetleThrow = - (3 + 2 * mod:RandomInt(0, 100)/100)
			data.ffBeetleThrowAccel = 0.3
		end
		beetle.SpriteOffset = Vector(0, beetle.SpriteOffset.Y + data.ffBeetleThrow)
		if beetle.SpriteOffset.Y > 0 then
			beetle.SpriteOffset = ZERO_VECTOR
			data.ffBeetleThrow = nil
			data.ffBeetleThrowAccel = nil
			beetle.State = NpcState.STATE_INIT
		else
			data.ffBeetleThrow = data.ffBeetleThrow + data.ffBeetleThrowAccel
			if sprite:GetAnimation() ~= "Flying" then
				sprite:Play("Flying", true)
			end
			beetle.Velocity = mod:Lerp(beetle.Velocity, ZERO_VECTOR, 0.04)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_FAMILIAR_RENDER, mod.BeetleUpdate60, mod.ITEM.FAMILIAR.BLUE_BEETLE)

function mod:BeetleCollision(npc, collider)
	if npc.State == NpcState.STATE_ATTACK and not IsBeetle(collider) then
		return true
	end
	if mod:isFriend(npc) and IsBeetle(collider) then
		return false
	end
end

function mod:BlueBeetleCollision(beetle, collider)
	if ShouldBeetleBlock(beetle, collider) then
		local data = mod:GetEntityData(beetle)
		if (data.iFrames or 0) <= 0 then
			beetle:TakeDamage(mod:GetEntityData(beetle).HiveMinded and 0.5 or 1, 0, EntityRef(collider), 0)
			data.iFrames = 30
		end
		if beetle.SubType == 0 then
			collider:Die()
		else
			local proj = collider:ToProjectile()
			proj.Velocity = proj.Velocity*-1
			proj:AddProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER | ProjectileFlags.HIT_ENEMIES)
			if beetle.SubType == 1 then --Fiendish
				if beetle:GetDropRNG():RandomInt(2) == 0 then
					proj.CollisionDamage = proj.CollisionDamage*5
					local pd = mod:GetEntityData(proj)
					if not pd.critLightning or not pd.critLightning:Exists() then
						local rng = beetle:GetDropRNG()
						sfx:Play(mod.Sounds.CritShoot, 0.3, 0, false, mod:RandomInt(80,120,rng)/100)
						local critLightning = Isaac.Spawn(1000, 1737, 1, proj.Position, Vector.Zero, proj):ToEffect()
						critLightning.Parent = proj
						critLightning.Color = Color(1,1,1,0,0,0,1)
						critLightning:Update()
						pd.critLightning = critLightning
						pd.isImpSodaTear = true
					end
					proj.Color = Color(1.3,1.3,1.3,1,100/255,-150/255,100/255)
				end
			elseif beetle.SubType == 2 then --Bastardly
				mod:GetEntityData(proj).BastardlyBeetleTear = true
				proj.Color = Color(0.6, 0.6, 0.6, 1, 0, 0, 0)
			elseif beetle.SubType == 3 then --Friendly
				mod:GetEntityData(proj).FriendlyBeetleTear = true
				proj.CollisionDamage = proj.CollisionDamage*1.5
			elseif beetle.SubType == 4 then --Skeletal
				mod:GetEntityData(proj).SkeletalBeetleTear = true
				proj.Color = Color(proj.Color.R, proj.Color.G, proj.Color.B, proj.Color.A, 0.3, 0.3, 0.3)
			end
		end
	end
	--[[if collider:IsEnemy() and beetle.Position:Distance(beetle.Player.Position) < collider.Position:Distance(beetle.Player.Position) then
		return false
	end]]
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, CallbackPriority.LATE, mod.BlueBeetleCollision, mod.ITEM.FAMILIAR.BLUE_BEETLE)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, CallbackPriority.LATE, function(_, proj, collider)
	if collider.Type == EntityType.ENTITY_FAMILIAR and collider.Variant == mod.ITEM.FAMILIAR.BLUE_BEETLE then
		mod:BlueBeetleCollision(collider, proj)
	end
end)

function mod:ThrowBlueBeetle(spawner, pos, vel)
	pos = pos or spawner.Position
	vel = vel or (RandomVector() * mod:RandomInt(3,8))
	local beetle = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.BLUE_BEETLE, 0, pos, vel, spawner):ToFamiliar()
	beetle:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	beetle.State = NpcState.STATE_APPEAR_CUSTOM
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, item, rng, player, useFlags, slot)
	for _, beetle in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.BLUE_BEETLE)) do
		mod:ThrowBlueBeetle(player)
	end
end, CollectibleType.COLLECTIBLE_COMPOST)
