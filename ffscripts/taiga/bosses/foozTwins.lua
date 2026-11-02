-- Fooz Twins

-- todo: RONALDINHO SOCCER, deal with velocity on freeze messing up some attacks

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector(0,0)

local foozBallsToChangeScaleOf = {} -- i love isaac modding i love isaac modding nightmare nightmare nightmare
local foozBallsToRebound = {}

local BALL_ORDER_TIMER = 40
local LOAF_STEP_SPEED = 4
local PASS_LIMIT = 8
local PASS_BALL_END_TIMER = 20
local PASS_BALL_END_LERP_POW = 1
local PASS_BALL_REV_TO_MAX = 24
local PASS_BALL_REV_POW = 1.5
local PASS_BALL_REV_MAX_VEL = 1
local PASS_BALL_REBOUND_VEL_MIN = 9
local PASS_BALL_PASSING_VEL = 9.25
local PASS_BALL_PASSING_LERP = 0.08
local PASS_BALL_PASSING_FULL_LERP_AT_FRAME = 20
local PASS_BALL_EXTRA_FULL_LERP_EVERY_X_FRAMES = 50
local PASS_TWIN_KICK_RADIUS = 55
local PASS_TWIN_KICK_PROJ_VEL = 10
local PASS_TWIN_KICK_PROJ_ANGLE_OFFSET = 25
local PASS_TWIN_KICK_PROJ_ANGLE_INIT_OFFSET = 25
local PASS_TWIN_KICK_PROJ_FALLING_ACCEL = 0.05
local PASS_TWIN_JUMP_DURATION = 21
local PASS_TWIN_JUMP_HEIGHT = -120
local PASS_MAX_ANGLE_CORRECTION = 90
local PASS_MAX_ANGLE_CORRECTION_PER_FRAME = 0
local PASS_STEP_SPEED = 8
local PASS_TIMEOUT_FRAMES = 240
local CYCLONE_TWIN_JUMP_MAX_SPEED = 16
local CYCLONE_TWIN_JUMP_HEIGHT = -20
local CYCLONE_TWIN_TORNADO_FRAMES = 300
local CYCLONE_TWIN_TORNADO_VEL = 7.25
local CYCLONE_TWIN_TORNADO_MAX_ANGLE_DIFF_PLAYER = 2.5
local CYCLONE_TWIN_TORNADO_MAX_ANGLE_DIFF_BALL = 6
local CYCLONE_TWIN_TORNADO_PUSH_FORCE = 8.75
local CYCLONE_TWIN_TORNADO_STARTUP_FRAMES = 60
local CYCLONE_TWIN_TORNADO_ENDING_FRAMES = 60
local CYCLONE_BALL_PUSH_FRAMES = 30
local CYCLONE_BALL_LERP_MULTI_FRAMES = 30
local GLOBE_TWIN_JUMP_DURATION = 45
local GLOBE_TWIN_JUMP_HEIGHT = -350
local GLOBE_TWIN_JUMP_TIMES_MAX = 6
local GLOBE_TWIN_JUMP_BULLET_SPEED = 7.5
local GLOBE_TWIN_JUMP_TARGET_PREDICTOR_MULT = 10
local GLOBE_TWIN_JUMP_FLANKING_EXTRA_DIST = 60
local GLOBE_TWIN_JUMP_TARGETING_RADIUS = 120
local GLOBE_TWIN_JUMP_FLANKING_ANGLE_MAX = 45
local GLOBE_TWIN_JUMP_TARGET_LERP = 0.8
local GLOBE_TWIN_JUMP_MAX_VEL = 18
local GLOBE_TWIN_JUMP_TARGET_ANGLE_MAX_DIFF = 120
local GLOBE_TWIN_JUMP_FALL_DELAY = 15
local GLOBE_BALL_MAX_VEL = 10
local GLOBE_BALL_LERP = 0.94

local FoozAttacks = {
	PENDING = -1,
	LOAFING_AROUND = 0,
	PASSING_DRILL = 1,
	WALKING_GLOBE = 2,
	CYCLONE_BROS = 3,
}

local FoozJumpType = {
	HOPPER = 0,
	SLAMMER_PLAYER = 1,
	SLAMMER_BALL = 2
}

local FoozDestructibleGrids = {}
FoozDestructibleGrids[GridEntityType.GRID_ROCK] = true
FoozDestructibleGrids[GridEntityType.GRID_ROCKT] = true
FoozDestructibleGrids[GridEntityType.GRID_ROCK_BOMB] = true
FoozDestructibleGrids[GridEntityType.GRID_ROCK_ALT] = true
FoozDestructibleGrids[GridEntityType.GRID_SPIDERWEB] = true
FoozDestructibleGrids[GridEntityType.GRID_TNT] = true
FoozDestructibleGrids[GridEntityType.GRID_POOP] = true
FoozDestructibleGrids[GridEntityType.GRID_STATUE] = true
FoozDestructibleGrids[GridEntityType.GRID_ROCK_SS] = true
FoozDestructibleGrids[GridEntityType.GRID_ROCK_SPIKED] = true
FoozDestructibleGrids[GridEntityType.GRID_ROCK_ALT2] = true
FoozDestructibleGrids[GridEntityType.GRID_ROCK_GOLD] = true

local function shouldShortCircuitTwinAttack(npc, npcdata)
	return npc.Parent == nil or npc.Parent:IsDead() or not npc.Parent:Exists() or 
	       npcdata.otherTwin == nil or npcdata.otherTwin:IsDead() or not npcdata.otherTwin:Exists()
end

function mod:foozTwinAI(npc, sprite, npcdata)
	mod:setTargetOfNPC(npc, npcdata)
	
	if not npcdata.init then
		npcdata.currentAttack = FoozAttacks.PENDING
		npcdata.pendingAttack = FoozAttacks.LOAFING_AROUND
		
		npcdata.attackRNG = RNG()
		npcdata.attackRNG:SetSeed(npc.InitSeed, 7)
		
		npc:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)
		npc:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_TARGET)
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
		npc.SpriteOffset = Vector(0,0)
		npc.PositionOffset = Vector(0,0)
		
		npcdata.init = true
		return
	end

	if sprite:IsPlaying("Appear") then
		return
	end
	
	if npcdata.currentAttack == FoozAttacks.PENDING then
		npcdata.currentAttack = npcdata.pendingAttack
		npcdata.pendingAttack = FoozAttacks.LOAFING_AROUND
	--elseif npc.Parent == nil or npc.Parent:IsDead() or not npc.Parent:Exists() or npcdata.otherTwin == nil or not npcdata.otherTwin:Exists() then
	--	npcdata.currentAttack = FoozAttacks.LOAFING_AROUND
	--	npcdata.pendingAttack = FoozAttacks.LOAFING_AROUND
	end
	
	if npcdata.currentAttack == FoozAttacks.LOAFING_AROUND then
		mod:foozTwinLoafingAI(npc, sprite, npcdata)
	elseif npcdata.currentAttack == FoozAttacks.PASSING_DRILL then
		mod:foozTwinPassingAI(npc, sprite, npcdata)
	elseif npcdata.currentAttack == FoozAttacks.WALKING_GLOBE then
		mod:foozTwinGlobeAI(npc, sprite, npcdata)
	elseif npcdata.currentAttack == FoozAttacks.CYCLONE_BROS then
		mod:foozTwinCycloneAI(npc, sprite, npcdata)
	end
end

function mod:foozTwinLoafingAI(npc, sprite, npcdata)
	-- Modified from ffscripts/erfly/enemies/bowler.lua
	npc:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_TARGET)
	npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
	npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
	npc.SpriteOffset = Vector(0,0)
	npc.PositionOffset = Vector(0,0)
	npc.SizeMulti = Vector(1, 1)
	npc.Visible = true
	
	npcdata.loafingAnimDir = npcdata.loafingAnimDir or "Down"
	
	if npcdata.loafingIsMoving then
		npcdata.loafingDirVec = npcdata.loafingDirVec or RandomVector():Resized(LOAF_STEP_SPEED)
		npc.Velocity = mod:Lerp(npc.Velocity, npcdata.loafingDirVec, 0.25)
		
		if math.abs(npc.Velocity.Y) > math.abs(npc.Velocity.X) then
			if npc.Velocity.Y > 0 then
				npcdata.loafingAnimDir = "Down"
			else
				npcdata.loafingAnimDir = "Up"
			end
		else
			npcdata.loafingAnimDir = "Hori"
			if npc.Velocity.X > 0 then
				sprite.FlipX = false
			else
				sprite.FlipX = true
			end
		end
	else
		npc.Velocity = npc.Velocity * 0.75
		npcdata.loafingDirVec = nil
	end
	
	local animFrame = 0
	if sprite:IsPlaying("WalkDown") or sprite:IsPlaying("WalkUp") or sprite:IsPlaying("WalkHori") then
		animFrame = sprite:GetFrame()
	end
	
	if sprite:IsEventTriggered("StartStep") or animFrame == 2 or animFrame == 18 then
		npcdata.loafingIsMoving = true
	elseif sprite:IsEventTriggered("StopStep") or animFrame == 9 or animFrame == 25 then
		npcdata.loafingIsMoving = false
		npc:PlaySound(SoundEffect.SOUND_SCAMPER, 0.5, 0, false, 0.6)
	end
	
	if not sprite:IsPlaying("Walk" .. npcdata.loafingAnimDir) then
		sprite:Play("Walk" .. npcdata.loafingAnimDir, true)
		sprite:SetFrame(animFrame)
	end
	
	if animFrame >= 31 then
		--npcdata.loafingAnimDir = nil -- Reset upon other attacks starting, not here, to prevent flickers to downwards anim
		npcdata.loafingIsMoving = nil
		npcdata.loafingDirVec = nil
		
		npcdata.currentAttack = FoozAttacks.PENDING
	end
end

local function findRandomFreePos(npc, radius, findnear, avoidplayer, avoidfire, player)
	-- Modified from the function of the same name in ffscripts/erfly/enemies/_shared.lua
	radius = radius or 0
	
	local validPositions = {}
	local validPositionsNear = {}
	local validPositionsFlank = {}
	
	local room = game:GetRoom()
	local size = room:GetGridSize()
	
	for i=0, size do
		local gridpos = room:GetGridPosition(i)
		
		if room:GetGridCollisionAtPos(gridpos) == GridCollisionClass.COLLISION_NONE and room:IsPositionInRoom(gridpos, 0) then
			if (avoidplayer == nil or (avoidplayer and (player.Position + (player.Velocity * GLOBE_TWIN_JUMP_TARGET_PREDICTOR_MULT)):Distance(gridpos) > 60)) 
			and (avoidfire == nil or (avoidfire and not mod:IsCampfireWithinRadius(gridpos, 40)))
			then
				table.insert(validPositions, gridpos)
				
				if (npc.Position + npc.Velocity * GLOBE_TWIN_JUMP_TARGET_PREDICTOR_MULT):Distance(gridpos) < radius then
					table.insert(validPositionsNear, gridpos)
					
					if npc.Velocity:Length() >= 0.5 then
						local gridAngle = (gridpos - npc.Position):GetAngleDegrees()
						local velAngle = npc.Velocity:GetAngleDegrees()
						local flankingAngle = math.min(math.abs(gridAngle - velAngle), 
						                               math.abs((gridAngle + 360) - velAngle), 
						                               math.abs(gridAngle - (velAngle + 360)))
						
						if flankingAngle <= GLOBE_TWIN_JUMP_FLANKING_ANGLE_MAX then
							table.insert(validPositionsFlank, gridpos)
						end
					end
				end
			end
		end
	end
	if #validPositionsFlank > 0 then
		return validPositionsFlank[math.random(#validPositionsFlank)]
	elseif #validPositionsNear > 0 then
		return validPositionsNear[math.random(#validPositionsNear)]
	elseif #validPositions > 0 then
		return validPositions[math.random(#validPositions)]
	else
		return room:GetRandomPosition(1)
	end
end

function mod:foozTwinJumpingAI(npc, sprite, npcdata, targetPos, jumpHeight, jumpDuration, landAnim, jumpAnim, jumpType)
	npcdata.jumpingState = npcdata.jumpingState or "Start"
	npcdata.jumpHeight = npcdata.jumpHeight or jumpHeight
	npcdata.jumpDuration = npcdata.jumpDuration or math.max(jumpDuration, 21)
	npcdata.jumpMaxDuration = npcdata.jumpMaxDuration or math.max(jumpDuration, 21)
	
	jumpAnim = jumpAnim or "JumpStart"
	jumpType = jumpType or FoozJumpType.HOPPER

	if npcdata.jumpingState == "Start" then
		npc:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_TARGET)
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
		
		npc.Velocity = nilvector
		npc.PositionOffset = Vector(0,0)
		npc.SpriteOffset = Vector(0,0)
		sprite.FlipX = false
		npc.SizeMulti = Vector(1, 1)
		npc.Visible = true
		
		if sprite:IsFinished(jumpAnim) then
			sprite:Play("JumpUpLoop")
			
			npcdata.jumpingState = "Up"
			if jumpType == FoozJumpType.HOPPER and npcdata.jumpDuration <= npcdata.jumpMaxDuration - math.ceil((npcdata.jumpMaxDuration - 21) / 2) then
				npcdata.jumpingState = "Transition"
			end
		elseif not sprite:IsPlaying(jumpAnim) then
			sprite:Play(jumpAnim)
		end
	end
	
	if npcdata.jumpingState == "Up" then
		npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_TARGET)
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
		
		npc.SpriteOffset = Vector(0,0)
		sprite.FlipX = false
		npc.SizeMulti = Vector(1, 1)
		npc.Visible = true
		
		if jumpType == FoozJumpType.HOPPER then
			npc.Velocity = (targetPos - npc.Position) / npcdata.jumpDuration
			npc.PositionOffset = Vector(0, math.sin((npcdata.jumpDuration / npcdata.jumpMaxDuration) * math.pi) ^ 0.5 * npcdata.jumpHeight)
		
			if not sprite:IsPlaying("JumpUpLoop") then
				sprite:Play("JumpUpLoop")
			end
			
			npcdata.jumpDuration = npcdata.jumpDuration - 1
			if npcdata.jumpDuration <= npcdata.jumpMaxDuration - math.ceil((npcdata.jumpMaxDuration - 21) / 2) then
				npcdata.jumpingState = "Transition"
			end
		elseif jumpType == FoozJumpType.SLAMMER_PLAYER or jumpType == FoozJumpType.SLAMMER_BALL then
			local velLerpMod = 0
			if npcdata.slammerJumpIsGo then
				if jumpType == FoozJumpType.SLAMMER_PLAYER then
					--local target = npc:GetPlayerTarget()
					--local targetPos = (target.Position + target.Velocity * GLOBE_TWIN_JUMP_TARGET_PREDICTOR_MULT)
					--npcdata.slammerJumpTargetPos = npcdata.slammerJumpTargetPos or targetPos
					--npcdata.slammerJumpTargetPos = npcdata.slammerJumpTargetPos * GLOBE_TWIN_JUMP_TARGET_LERP + targetPos * (1 - GLOBE_TWIN_JUMP_TARGET_LERP)
					
					--local ball = npc.Parent
					--npcdata.slammerJumpTargetPos = -1 * (ball.Position - game:GetRoom():GetCenterPos()) + game:GetRoom():GetCenterPos()
					
					local ball = npc.Parent
					local room = game:GetRoom()
					while npcdata.slammerJumpTargetPos == nil do
						local randPos = room:FindFreePickupSpawnPosition(room:GetRandomPosition(20), nil, true)
						if (randPos - npc.Position):Length() >= 160 then
							npcdata.slammerJumpTargetPos = randPos
						end
					end
					
					local dist = (npc.Position - npcdata.slammerJumpTargetPos):Length()
					if dist < 40 then
						npcdata.jumpingState = "Down"
						npcdata.slammerJumpIsGo = false
						npcdata.slammerJumpTargetVel = nilvector
					else
						npcdata.slammerJumpTargetVel = npcdata.slammerJumpTargetVel + -(npc.Position - npcdata.slammerJumpTargetPos):Normalized() * (dist / 65)
						if npcdata.slammerJumpTargetVel:Length() > GLOBE_TWIN_JUMP_MAX_VEL then
							npcdata.slammerJumpTargetVel = npcdata.slammerJumpTargetVel:Resized(GLOBE_TWIN_JUMP_MAX_VEL)
						end
					end
				else
					local ball = npc.Parent
					if ball and not shouldShortCircuitTwinAttack(npc, npcdata) then
						npcdata.slammerJumpTargetPos = ball.Position
					else
						npcdata.slammerJumpTargetPos = npc.Position
					end
					
					local dist = (npc.Position - npcdata.slammerJumpTargetPos):Length()
					npcdata.slammerJumpTargetVel = npcdata.slammerJumpTargetVel or nilvector
					npcdata.slammerJumpTargetVel = npcdata.slammerJumpTargetVel + -(npc.Position - npcdata.slammerJumpTargetPos):Normalized() * (dist / 65)
					
					velLerpMod = math.min(1, (game:GetFrameCount() - npcdata.jumpStartedOnFrame) / 65) ^ 3
					npcdata.slammerJumpTargetVel = npcdata.slammerJumpTargetVel * (1 - velLerpMod) + (npcdata.slammerJumpTargetPos - npc.Position) * velLerpMod
				end
			else
				npcdata.slammerJumpTargetVel = nilvector
			end
			
			npc.Velocity = (npcdata.slammerJumpTargetVel * (0.3 + 0.7 * velLerpMod)) + (npc.Velocity * (0.6 - 0.6 * velLerpMod))
			--if jumpType == FoozJumpType.SLAMMER_PLAYER then
			--	npcdata.slammerJumpMaxSpeed = math.max(npcdata.slammerJumpMaxSpeed or 0, npc.Velocity:Length())
			--	npc.Velocity = npc.Velocity:Resized(npcdata.slammerJumpMaxSpeed)
			--end
			
			npc.PositionOffset = Vector(0,0)
			
			if sprite:IsFinished("LongJumpUp") then
				npcdata.jumpingState = "Transition"
			elseif not sprite:IsPlaying("LongJumpUp") then
				sprite:Play("LongJumpUp")
			end
			
			if sprite:IsEventTriggered("GetPlayer") then
				local target = npc:GetPlayerTarget()
				
				npcdata.slammerJumpIsGo = true
				npcdata.jumpStartedOnFrame = game:GetFrameCount()
				npcdata.slammerJumpInitialTargetAngle = mod:reverseIfFear(npc, target.Position - npc.Position):GetAngleDegrees()
			end
		end
	end
	
	if npcdata.jumpingState == "Transition" then
		npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_TARGET)
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
		
		npc.SpriteOffset = Vector(0,0)
		sprite.FlipX = false
		npc.SizeMulti = Vector(1, 1)
		npc.Visible = true
		
		if jumpType == FoozJumpType.HOPPER then
			npc.Velocity = (targetPos - npc.Position) / npcdata.jumpDuration
			npc.PositionOffset = Vector(0, math.sin((npcdata.jumpDuration / npcdata.jumpMaxDuration) * math.pi) ^ 0.5 * npcdata.jumpHeight)
			
			if sprite:IsFinished("JumpTransition") then
				sprite:Play("JumpDownLoop")
				npcdata.jumpingState = "Down"
			elseif not sprite:IsPlaying("JumpTransition") then
				sprite:Play("JumpTransition")
			end
			
			npcdata.jumpDuration = npcdata.jumpDuration - 1
			if npcdata.jumpDuration <= 0 then
				npcdata.jumpingState = "Land"
			end
		elseif jumpType == FoozJumpType.SLAMMER_PLAYER or jumpType == FoozJumpType.SLAMMER_BALL then
			local target = npc:GetPlayerTarget()
			local velLerpMod = 0
			if npcdata.slammerJumpIsGo then
				if jumpType == FoozJumpType.SLAMMER_PLAYER then
					--local targetPos = (target.Position + target.Velocity * GLOBE_TWIN_JUMP_TARGET_PREDICTOR_MULT)
					--npcdata.slammerJumpTargetPos = npcdata.slammerJumpTargetPos or targetPos
					--npcdata.slammerJumpTargetPos = npcdata.slammerJumpTargetPos * GLOBE_TWIN_JUMP_TARGET_LERP + targetPos * (1 - GLOBE_TWIN_JUMP_TARGET_LERP)
					
					local dist = (npc.Position - npcdata.slammerJumpTargetPos):Length()
					if dist < 40 then
						npcdata.jumpingState = "Down"
						npcdata.slammerJumpIsGo = false
						npcdata.slammerJumpTargetVel = nilvector
					else
						npcdata.slammerJumpTargetVel = npcdata.slammerJumpTargetVel + -(npc.Position - npcdata.slammerJumpTargetPos):Normalized() * (dist / 65)
						if npcdata.slammerJumpTargetVel:Length() > GLOBE_TWIN_JUMP_MAX_VEL then
							npcdata.slammerJumpTargetVel = npcdata.slammerJumpTargetVel:Resized(GLOBE_TWIN_JUMP_MAX_VEL)
						end
					end
				else
					local ball = npc.Parent
					if ball and not shouldShortCircuitTwinAttack(npc, npcdata) then
						npcdata.slammerJumpTargetPos = ball.Position
					else
						npcdata.slammerJumpTargetPos = npc.Position
					end
					
					local dist = (npc.Position - npcdata.slammerJumpTargetPos):Length()
					npcdata.slammerJumpTargetVel = npcdata.slammerJumpTargetVel or nilvector
					npcdata.slammerJumpTargetVel = npcdata.slammerJumpTargetVel + -(npc.Position - npcdata.slammerJumpTargetPos):Normalized() * (dist / 65)
					
					velLerpMod = math.min(1, (game:GetFrameCount() - npcdata.jumpStartedOnFrame) / 65) ^ 2
					npcdata.slammerJumpTargetVel = npcdata.slammerJumpTargetVel * (1 - velLerpMod) + (npcdata.slammerJumpTargetPos - npc.Position) * velLerpMod
				end
			else
				npcdata.slammerJumpTargetVel = nilvector
			end
			
			npc.Velocity = (npcdata.slammerJumpTargetVel * (0.3 + 0.7 * velLerpMod)) + (npc.Velocity * (0.6 - 0.6 * velLerpMod))
			--if jumpType == FoozJumpType.SLAMMER_PLAYER then
			--	npcdata.slammerJumpMaxSpeed = math.max(npcdata.slammerJumpMaxSpeed or 0, npc.Velocity:Length())
			--	npc.Velocity = npc.Velocity:Resized(npcdata.slammerJumpMaxSpeed)
			--end
			
			npc.PositionOffset = Vector(0,0)
			
			if jumpType == FoozJumpType.SLAMMER_PLAYER then
				--npcdata.slammerJumpInitialTargetAngle = npcdata.slammerJumpInitialTargetAngle or (target.Position - npc.Position):GetAngleDegrees()
				--local targetAngle = (target.Position - npc.Position):GetAngleDegrees()
				--local targetAngleDiff = math.min(math.abs(targetAngle - npcdata.slammerJumpInitialTargetAngle),
				--                                 math.abs((targetAngle + 360) - npcdata.slammerJumpInitialTargetAngle),
				--                                 math.abs(targetAngle - (npcdata.slammerJumpInitialTargetAngle + 360)))
				--npcdata.jumpDuration = npcdata.jumpDuration - 1
				--if npcdata.jumpDuration <= 0 or npc:CollidesWithGrid() or targetAngleDiff >= GLOBE_TWIN_JUMP_TARGET_ANGLE_MAX_DIFF then
				--	npcdata.slammerJumpTargetVel = nilvector
				--	npcdata.jumpingState = "Down"
				--end
			else
				local dist = (npc.Position - npcdata.slammerJumpTargetPos):Length()
				if dist < 10 then
					local ball = npc.Parent
					if ball and not shouldShortCircuitTwinAttack(npc, npcdata) then
						npc:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_TARGET)
						npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
						npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
						
						npc.Velocity = nilvector
						npc.SpriteOffset = Vector(0,0)
						npc.PositionOffset = Vector(0,0)
						sprite.FlipX = false
						npc.SizeMulti = Vector(1, 1)
						npc.Visible = true
						
						npcdata.jumpingState = nil
						npcdata.jumpHeight = nil
						npcdata.jumpDuration = nil
						npcdata.jumpMaxDuration = nil
						npcdata.jumpStartedOnFrame = nil
						npcdata.slammerJumpTargetPos = nil
						npcdata.slammerJumpIsGo = nil
						npcdata.slammerJumpTargetVel = nil
						npcdata.slammerJumpMaxSpeed = nil
						npcdata.slammerJumpInitialTargetAngle = nil
						npcdata.jumpingDelay = nil
						return true
					else
						npcdata.jumpingState = "Down"
						npcdata.slammerJumpIsGo = false
						npcdata.slammerJumpTargetVel = nilvector
					end
				end
			end
		end
	end
	
	if npcdata.jumpingState == "Down" then
		npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_TARGET)
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
		
		npc.SpriteOffset = Vector(0,0)
		sprite.FlipX = false
		npc.SizeMulti = Vector(1, 1)
		npc.Visible = true
		
		npcdata.jumpingDelay = (npcdata.jumpingDelay or 0) + 1
		
		if jumpType == FoozJumpType.HOPPER then
			npc.Velocity = (targetPos - npc.Position) / npcdata.jumpDuration
			npc.PositionOffset = Vector(0, math.sin((npcdata.jumpDuration / npcdata.jumpMaxDuration) * math.pi) ^ 0.5 * npcdata.jumpHeight)
			
			if not sprite:IsPlaying("JumpDownLoop") then
				sprite:Play("JumpDownLoop")
			end
			
			npcdata.jumpDuration = npcdata.jumpDuration - 1
			if npcdata.jumpDuration <= 0 then
				npcdata.jumpingState = "Land"
			end
		elseif jumpType == FoozJumpType.SLAMMER_PLAYER or jumpType == FoozJumpType.SLAMMER_BALL then
			npc.Velocity = (npcdata.slammerJumpTargetVel * 0.3) + (npc.Velocity * 0.6)
			npc.PositionOffset = Vector(0,0)
			
			if sprite:IsFinished("LongJumpDown") then
				npcdata.jumpingState = "Land"
			elseif sprite:IsPlaying("LongJumpUp") then
				-- do nothing
			elseif not sprite:IsPlaying("LongJumpDown") and npcdata.jumpingDelay > GLOBE_TWIN_JUMP_FALL_DELAY then
				sprite:Play("LongJumpDown")
			end
		end
	end
	
	if npcdata.jumpingState == "Land" then
		npc:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_TARGET)
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
		
		npc.Velocity = nilvector
		npc.SpriteOffset = Vector(0,0)
		npc.PositionOffset = Vector(0,0)
		sprite.FlipX = false
		npc.SizeMulti = Vector(1, 1)
		npc.Visible = true
		
		if sprite:IsEventTriggered("Shoot") then
			if jumpType ~= FoozJumpType.SLAMMER_PLAYER then
				npc:PlaySound(SoundEffect.SOUND_MEAT_IMPACTS, 1.0, 0, false, (9.5 + math.random()) / 10)
			end
			npcdata.jumpingHasLanded = true
		end
		
		if landAnim == nil then
			npcdata.jumpingState = nil
			npcdata.jumpHeight = nil
			npcdata.jumpDuration = nil
			npcdata.jumpMaxDuration = nil
			npcdata.jumpStartedOnFrame = nil
			npcdata.slammerJumpTargetPos = nil
			npcdata.slammerJumpIsGo = nil
			npcdata.slammerJumpTargetVel = nil
			npcdata.slammerJumpMaxSpeed = nil
			npcdata.slammerJumpInitialTargetAngle = nil
			npcdata.jumpingDelay = nil
			return true
		elseif sprite:IsFinished(landAnim) then
			sprite:Play(landAnim)
			npcdata.jumpingState = nil
			npcdata.jumpHeight = nil
			npcdata.jumpDuration = nil
			npcdata.jumpMaxDuration = nil
			npcdata.jumpStartedOnFrame = nil
			npcdata.slammerJumpTargetPos = nil
			npcdata.slammerJumpIsGo = nil
			npcdata.slammerJumpTargetVel = nil
			npcdata.slammerJumpMaxSpeed = nil
			npcdata.slammerJumpInitialTargetAngle = nil
			npcdata.jumpingDelay = nil
			return true
		elseif not sprite:IsPlaying(landAnim) then
			sprite:Play(landAnim)
		end
	end
	
	return false
end

function mod:getFoozTwinPassPosition(npc, isLeft)
	local room = game:GetRoom()
	
	local topLeft = room:GetTopLeftPos()
	local bottomRight = room:GetBottomRightPos()
	
	local bestPosition = nil
	local bestPositionYDist = math.huge
	
	local x
	if isLeft then
		x = topLeft.X + 20
	else
		x = bottomRight.X - 20
	end
	
	while bestPosition == nil do
		for y = topLeft.Y + 20, bottomRight.Y - 20, 40 do
			local gridCol = room:GetGridCollisionAtPos(Vector(x,y))
			if gridCol == GridCollisionClass.COLLISION_NONE then
				local yDist = math.abs(npc.Position.Y - y)
				if yDist < bestPositionYDist then
					bestPosition = Vector(x, y)
					bestPositionYDist = yDist
				end
			end
		end
		
		if bestPosition == nil then
			if isLeft then
				x = x + 40
			else
				x = x - 40
			end
		end
		
		if x > bottomRight.X or x < topLeft.X then
			break
		end
	end
	
	if bestPosition == nil then
		if isLeft then
			return Vector(topLeft.X + 30, npc.Position.Y)
		else
			return Vector(bottomRight.X - 30, npc.Position.Y)
		end
	else
		if isLeft then
			return bestPosition + Vector(10, 0)
		else
			return bestPosition + Vector(-10, 0)
		end
	end
end

local function twinIsCloseToPassingWall(twin, targetY)
	local wallY
	if twin.Position.Y < targetY then
		wallY = game:GetRoom():GetBottomRightPos().Y
	else
		wallY = game:GetRoom():GetTopLeftPos().Y
	end
	
	return math.abs(twin.Position.Y - wallY) <= PASS_TWIN_KICK_RADIUS
end

function mod:foozTwinPassKickAI(npc, sprite, npcdata)
	local ball = npc.Parent
	if ball and (ball.Position - npc.Position):Length() <= PASS_TWIN_KICK_RADIUS then
		npcdata.passingState = "Kick"
		
		local balldata = mod:GetEntityData(ball)
		local ballsprite = ball:GetSprite()
		
		balldata.state = "Passing"
		balldata.passTarget = npcdata.otherTwin
		balldata.passAngleCorrection = 0
		balldata.passKickTimeout = PASS_TIMEOUT_FRAMES
		balldata.tornadoPushedBy = {}
		balldata.tornadoPushLerpMultiFrames = 0
		
		balldata.timesPassed = (balldata.timesPassed or 0) + 1
		if balldata.timesPassed >= PASS_LIMIT then
			mod:GetEntityData(npcdata.otherTwin).passingState = "Idle"
		end
		
		local target = ball:ToNPC():GetPlayerTarget()
		if target.Index == npc.Index and target.InitSeed == npc.InitSeed then
			target = npcdata.otherTwin
		end
		balldata.pursueTarget = target
		local targetPosition = target.Position
		if mod:isConfuse(npc) then
			local room = game:GetRoom()
			local topLeftY = room:GetTopLeftPos().Y
			local bottomRightY = room:GetBottomRightPos().Y
			local y = math.random() * (bottomRightY - topLeftY) + topLeftY
			targetPosition = Vector(targetPosition.X, y)
		end
		local targetVel = (targetPosition - ball.Position):Resized(PASS_BALL_PASSING_VEL)
		ball.Velocity = targetVel
		
		if balldata.timesPassed < PASS_LIMIT then
			local endingX
			if npcdata.passingIsLeft then
				endingX = game:GetRoom():GetBottomRightPos().X - 20
			else
				endingX = game:GetRoom():GetTopLeftPos().X + 20
			end
			local endingY = ball.Position.Y + ((endingX - ball.Position.X) / targetVel.X) * targetVel.Y
			
			if math.abs(npcdata.otherTwin.Position.Y - endingY) > PASS_TWIN_KICK_RADIUS and
			   not twinIsCloseToPassingWall(npcdata.otherTwin, endingY)
			then
				mod:GetEntityData(npcdata.otherTwin).passingState = "Step"
				
				if npcdata.otherTwin.Position.Y < endingY then
					mod:GetEntityData(npcdata.otherTwin).passStepAnimDir = "Down"
					mod:GetEntityData(npcdata.otherTwin).passStepDirVec = Vector(0, PASS_STEP_SPEED)
				else
					mod:GetEntityData(npcdata.otherTwin).passStepAnimDir = "Up"
					mod:GetEntityData(npcdata.otherTwin).passStepDirVec = Vector(0, -1 * PASS_STEP_SPEED)
				end
				
				if npc.Index > npcdata.otherTwin.Index then
					npcdata.otherTwin:Update()
				end
			end
		end
		
		local params = ProjectileParams()
		params.FallingAccelModifier = PASS_TWIN_KICK_PROJ_FALLING_ACCEL - 0.1
		local dist = npc.Position - ball.Position
		local projPosition = ball.Position + dist:Resized(dist:Length() / 2)
		for i = 0, 1 do
			npc:FireProjectiles(projPosition, 
			                    targetVel:Rotated(PASS_TWIN_KICK_PROJ_ANGLE_INIT_OFFSET + PASS_TWIN_KICK_PROJ_ANGLE_OFFSET * i):Resized(PASS_TWIN_KICK_PROJ_VEL), 
			                    0, 
			                    params)
		end
		for i = 0, 1 do
			npc:FireProjectiles(projPosition, 
			                    targetVel:Rotated((PASS_TWIN_KICK_PROJ_ANGLE_INIT_OFFSET + PASS_TWIN_KICK_PROJ_ANGLE_OFFSET * i) * -1):Resized(PASS_TWIN_KICK_PROJ_VEL), 
			                    0, 
			                    params)
		end
		
		local targetXDist = targetPosition.X - ball.Position.X
		local targetYDist = targetPosition.Y - ball.Position.Y
		balldata.pursueParity = npcdata.passingIsLeft
		
		local dir = nil
		if math.abs(targetXDist) > math.abs(targetYDist) then
			if targetXDist > 0 then
				dir = "Right"
			else
				dir = "Left"
			end
		else
			if targetYDist < 0 then
				dir = "Down"
			else
				dir = "Up"
			end
		end
		
		ballsprite:Play("Roll" .. dir .. "Fast", true)
		ballsprite:SetFrame((balldata.passRollFrame or 0) % 8)
		table.insert(foozBallsToChangeScaleOf, {NPC = ball, Scale = Vector(1,1)})
		
		npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT, 1.0, 0, false, (9 + math.random() * 2) / 10)
		npc:PlaySound(mod.Sounds.FoozTwinsKick, 1.0, 0, false, (9 + math.random() * 2) / 10)
		
		sfx:Play(SoundEffect.SOUND_MEATY_DEATHS, 0.6, 0, false, 1.4 + math.random() * 0.2)
		if (balldata.impactSoundCooldown or 0) <= 0 then 
			sfx:Play(mod.Sounds.FoozTwinsImpact, 0.9, 0, false, 0.90 + math.random() * 0.2)
			balldata.impactSoundCooldown = 30
		end
		
		return true
	end
	
	return false
end

function mod:foozTwinPassingAI(npc, sprite, npcdata)
	npcdata.loafingAnimDir = nil
	npcdata.passingState = npcdata.passingState or "Start"
	
	local isShortCircuitingAttack = shouldShortCircuitTwinAttack(npc, npcdata)
	
	::foozTwinPassingStateSelect::
	
	if isShortCircuitingAttack and not (npcdata.passingState == "Start" or npcdata.passingState == "Kick" or npcdata.passingState == "Step") then
		npcdata.passingState = "Finish"
	end
	
	if npcdata.passingState == "Start" or (npcdata.passingState == "Finish" and npcdata.jumpingState ~= nil and npcdata.jumpingState ~= "Start") then
		-- jump to corresponding side of room
		if isShortCircuitingAttack and (npcdata.jumpingState == nil or npcdata.jumpingState == "Start") then
			npcdata.passingState = "Finish"
			goto foozTwinPassingStateSelect
		end
		
		if npcdata.passingInitialPosition == nil then
			local otherTwin = npcdata.otherTwin
			
			local leftTwin, rightTwin
			if otherTwin.Position.X < npc.Position.X then
				leftTwin = otherTwin
				rightTwin = npc
			else
				leftTwin = npc
				rightTwin = otherTwin
			end
			
			mod:GetEntityData(leftTwin).passingIsLeft = true
			mod:GetEntityData(rightTwin).passingIsLeft = false
			
			mod:GetEntityData(leftTwin).passingInitialPosition = mod:getFoozTwinPassPosition(leftTwin, true)
			mod:GetEntityData(rightTwin).passingInitialPosition = mod:getFoozTwinPassPosition(rightTwin, false)
		end
		
		local landAnim = "JumpLandToKick"
		if isShortCircuitingAttack and npcdata.jumpStateWhenBeganShortCircuiting == nil then
			npcdata.jumpStateWhenBeganShortCircuiting = npcdata.jumpingState
		end
		if npcdata.passingWillGoad or npcdata.passingState == "Finish" or (isShortCircuitingAttack and npcdata.jumpStateWhenBeganShortCircuiting ~= "Land") then
			landAnim = "JumpLand"
		end
		
		local finishedJump = mod:foozTwinJumpingAI(npc, sprite, npcdata, npcdata.passingInitialPosition, PASS_TWIN_JUMP_HEIGHT, PASS_TWIN_JUMP_DURATION, landAnim)
		if finishedJump then
			if isShortCircuitingAttack then
				npcdata.passingState = "Finish"
			elseif npcdata.passingState ~= "Finish" then
				if npcdata.passingWillGoad then
					npcdata.passingState = "Goad"
				else
					npcdata.passingState = "Receiving"
				end
			end
			npcdata.jumpingHasLanded = nil
		end
		
		if npcdata.jumpingHasLanded and not (npcdata.passingWillGoad or npcdata.passingState == "Finish" or (isShortCircuitingAttack and npcdata.jumpStateWhenBeganShortCircuiting ~= "Land")) then
			if npcdata.passingIsLeft then
				sprite.FlipX = false
			else
				sprite.FlipX = true
			end
		else
			sprite.FlipX = false
		end
	end
	
	if npcdata.passingState == "Goad" then
		-- taunt at the ball if designated
		npc:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_TARGET)
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
		
		npc.Velocity = nilvector
		npc.SpriteOffset = Vector(0,0)
		npc.PositionOffset = Vector(0,0)
		npc.SizeMulti = Vector(1, 1)
		npc.Visible = true
		
		npcdata.passingGoadState = npcdata.passingGoadState or 0
		if sprite:IsEventTriggered("StartFlex") then
			npcdata.passingGoadState = 1
			mod:GetEntityData(npc.Parent).state = "PassGoad"
			mod:GetEntityData(npc.Parent).goadTarget = npc
		elseif sprite:IsEventTriggered("StopFlex") then
			npcdata.passingGoadState = 2
		end
		
		if npcdata.passingGoadState == 0 then
			sprite.FlipX = false
		elseif npcdata.passingGoadState == 1 then
			if npc.SubType == mod.FF.FoozTwinRed.Sub and npc.Parent.Position.X > npc.Position.X then
				sprite.FlipX = true
			elseif npc.SubType == mod.FF.FoozTwinWhite.Sub and npc.Parent.Position.X < npc.Position.X then
				sprite.FlipX = true
			else
				sprite.FlipX = false
			end
		else
			if npcdata.passingIsLeft then
				sprite.FlipX = false
			else
				sprite.FlipX = true
			end
		end
		
		if sprite:IsFinished("TauntToKick") then
			npcdata.passingState = "Receiving"
			mod:GetEntityData(npc.Parent).state = "PassConnect"
			mod:GetEntityData(npc.Parent).passTarget = npc
			mod:GetEntityData(npc.Parent).passLerpFrames = 0
		elseif not sprite:IsPlaying("TauntToKick") then
			sprite:Play("TauntToKick", true)
		end
	end
	
	if npcdata.passingState == "Receiving" then
		npc:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_TARGET)
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
		
		npc.Velocity = nilvector
		npc.SpriteOffset = Vector(0,0)
		npc.PositionOffset = Vector(0,0)
		npc.SizeMulti = Vector(1, 1)
		npc.Visible = true
		
		if npcdata.passingIsLeft then
			sprite.FlipX = false
		else
			sprite.FlipX = true
		end
		
		if not sprite:IsPlaying("KickIdle") then
			sprite:Play("KickIdle", true)
		end
		
		mod:foozTwinPassKickAI(npc, sprite, npcdata)
	end
	
	if npcdata.passingState == "Kick" then
		npc:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_TARGET)
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
		
		npc.Velocity = nilvector
		npc.SpriteOffset = Vector(0,0)
		npc.PositionOffset = Vector(0,0)
		npc.SizeMulti = Vector(1, 1)
		npc.Visible = true
		
		if npcdata.passingIsLeft then
			sprite.FlipX = false
		else
			sprite.FlipX = true
		end
		
		if npc.Parent == nil or not npc.Parent:Exists() or 
		   mod:GetEntityData(npc.Parent).timesPassed == nil or 
		   mod:GetEntityData(npc.Parent).timesPassed >= PASS_LIMIT
		then
			if sprite:IsFinished("QuickKickToIdle") then
				npcdata.passingState = "Finish"
				mod:GetEntityData(npcdata.otherTwin).passingState = "Finish"
				if npc.Index > npcdata.otherTwin.Index then
					npcdata.otherTwin:Update()
				end
			elseif not sprite:IsPlaying("QuickKickToIdle") then
				sprite:Play("QuickKickToIdle", true)
			end
		else
			if sprite:IsFinished("QuickKick") then
				npcdata.passingState = "Receiving"
				goto foozTwinPassingStateSelect
			elseif not sprite:IsPlaying("QuickKick") then
				sprite:Play("QuickKick", true)
			end
		end
	end
	
	if npcdata.passingState == "Idle" then
		npc:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_TARGET)
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
		
		npc.Velocity = nilvector
		npc.SpriteOffset = Vector(0,0)
		npc.PositionOffset = Vector(0,0)
		npc.SizeMulti = Vector(1, 1)
		npc.Visible = true
		
		if npcdata.passingIsLeft then
			sprite.FlipX = false
		else
			sprite.FlipX = true
		end
		
		if not sprite:IsPlaying("IdleHori") then
			local startingFrame = 0
			if sprite:IsPlaying("KickIdle") or sprite:IsPlaying("Idle") then
				startingFrame = sprite:GetFrame()
			end
			
			sprite:Play("IdleHori", true)
			sprite:SetFrame(startingFrame)
		end
	end
	
	if npcdata.passingState == "Step" then
		npc:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_TARGET)
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
		npc.SpriteOffset = Vector(0,0)
		npc.PositionOffset = Vector(0,0)
		npc.SizeMulti = Vector(1, 1)
		npc.Visible = true
		
		if npcdata.passStepAnimVer == nil then
			if npcdata.attackRNG:RandomInt(2) == 1 then
				npcdata.passStepAnimVer = "A"
			else
				npcdata.passStepAnimVer = "B"
			end
		end
	
		if npcdata.passStepIsMoving then
			npc.Velocity = mod:Lerp(npc.Velocity, npcdata.passStepDirVec, 0.25)
		else
			npc.Velocity = npc.Velocity * 0.75
		end
		
		if sprite:IsEventTriggered("StartStep") then
			npcdata.passStepIsMoving = true
		elseif sprite:IsEventTriggered("StopStep") then
			npcdata.passStepIsMoving = false
			npc:PlaySound(SoundEffect.SOUND_SCAMPER, 0.5, 0, false, 0.6)
		end
		
		if mod:foozTwinPassKickAI(npc, sprite, npcdata) then
			goto foozTwinPassingStateSelect
		end
		
		if sprite:IsFinished("Step" .. npcdata.passStepAnimDir .. npcdata.passStepAnimVer) then
			npcdata.passStepAnimDir = nil
			npcdata.passStepIsMoving = nil
			npcdata.passStepDirVec = nil
			npcdata.passStepAnimVer = nil
			
			npcdata.passingState = "Receiving"
			goto foozTwinPassingStateSelect
		elseif not sprite:IsPlaying("Step" .. npcdata.passStepAnimDir .. npcdata.passStepAnimVer) then
			sprite:Play("Step" .. npcdata.passStepAnimDir .. npcdata.passStepAnimVer, true)
		end
	end
	
	if npcdata.passingState == "Finish" then
		npc:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_TARGET)
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
		
		npc.Velocity = nilvector
		npc.SpriteOffset = Vector(0,0)
		npc.PositionOffset = Vector(0,0)
		sprite.FlipX = false
		npc.SizeMulti = Vector(1, 1)
		npc.Visible = true
		
		npcdata.jumpingState = nil
		npcdata.jumpHeight = nil
		npcdata.jumpDuration = nil
		npcdata.jumpMaxDuration = nil
		npcdata.jumpStartedOnFrame = nil
		npcdata.jumpingHasLanded = nil
		npcdata.jumpingDelay = nil
		npcdata.jumpStateWhenBeganShortCircuiting = nil
		
		npcdata.passingState = nil
		npcdata.passingInitialPosition = nil
		npcdata.passingIsLeft = nil
		npcdata.passingWillGoad = nil
		npcdata.passingGoadState = nil
		
		npcdata.passStepAnimDir = nil
		npcdata.passStepIsMoving = nil
		npcdata.passStepDirVec = nil
		npcdata.passStepAnimVer = nil
		
		npcdata.currentAttack = FoozAttacks.LOAFING_AROUND
		mod:foozTwinLoafingAI(npc, sprite, npcdata)
	end
end

local function foozTwinGlobeBounceFinish(npc, sprite, npcdata)
	npc:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_TARGET)
	npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
	npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
	
	npc.Velocity = nilvector
	npc.SpriteOffset = Vector(0,0)
	npc.PositionOffset = Vector(0,0)
	sprite.FlipX = false
	npc.SizeMulti = Vector(1, 1)
	npc.Visible = true
	
	npcdata.jumpingState = nil
	npcdata.jumpHeight = nil
	npcdata.jumpDuration = nil
	npcdata.jumpMaxDuration = nil
	npcdata.jumpStartedOnFrame = nil
	npcdata.jumpingHasLanded = nil
	npcdata.slammerJumpTargetPos = nil
	npcdata.slammerJumpIsGo = nil
	npcdata.slammerJumpTargetVel = nil
	npcdata.slammerJumpMaxSpeed = nil
	npcdata.slammerJumpInitialTargetAngle = nil
	npcdata.jumpingDelay = nil
	
	npcdata.globeTimesJumped = nil
	
	npcdata.currentAttack = FoozAttacks.LOAFING_AROUND
	mod:foozTwinLoafingAI(npc, sprite, npcdata)
	
	if (npcdata.currentAttack == FoozAttacks.LOAFING_AROUND or npcdata.currentAttack == FoozAttacks.PENDING) and 
	   npcdata.otherTwin and 
	   (mod:GetEntityData(npcdata.otherTwin).currentAttack == FoozAttacks.LOAFING_AROUND or mod:GetEntityData(npcdata.otherTwin).currentAttack == FoozAttacks.PENDING)
	then
		if npc.Parent then
			mod:GetEntityData(npc.Parent).waitingToOrderAttack = BALL_ORDER_TIMER
		end
	end
end

function mod:foozTwinGlobeBounceAI(npc, sprite, npcdata)
	::foozTwinBounceStateSelect::

	npcdata.globeTimesJumped = npcdata.globeTimesJumped or 0
	
	if shouldShortCircuitTwinAttack(npc, npcdata) then
		if npcdata.globeTimesJumped == 0 and (npcdata.jumpingState == nil or npcdata.jumpingState == "Start") then
			foozTwinGlobeBounceFinish(npc, sprite, npcdata)
			return
		else
			npcdata.globeTimesJumped = GLOBE_TWIN_JUMP_TIMES_MAX
		end
	end
	
	local jumpAnim = "LongJumpBounce"
	if npcdata.globeTimesJumped == 0 then
		jumpAnim = "LongJumpStart"
	end
	
	if sprite:IsEventTriggered("Shoot") then
		for i = 0, 5 do
			npc:FireProjectiles(npc.Position, Vector(GLOBE_TWIN_JUMP_BULLET_SPEED,0):Rotated(360*i/6), 0, ProjectileParams())
		end
		
		npc:PlaySound(SoundEffect.SOUND_MEAT_IMPACTS, 1.0, 0, false, (9.5 + math.random()) / 10)
		npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT, 1.0, 0, false, (9 + math.random() * 2) / 10)
	end
	
	local landAnim = nil
	if npcdata.globeTimesJumped >= GLOBE_TWIN_JUMP_TIMES_MAX - 1 then
		landAnim = "JumpLand"
	end
	
	if mod:foozTwinJumpingAI(npc, sprite, npcdata, npc.Position, GLOBE_TWIN_JUMP_HEIGHT, GLOBE_TWIN_JUMP_DURATION, landAnim, jumpAnim, FoozJumpType.SLAMMER_PLAYER) then
		npcdata.globeTimesJumped = npcdata.globeTimesJumped + 1
		if npcdata.globeTimesJumped >= GLOBE_TWIN_JUMP_TIMES_MAX then
			foozTwinGlobeBounceFinish(npc, sprite, npcdata)
		else
			if npc.Parent and npcdata.globeTimesJumped >= GLOBE_TWIN_JUMP_TIMES_MAX - 1 then
				mod:GetEntityData(npc.Parent).state = "GlobeEnd"
			end
			
			goto foozTwinBounceStateSelect
		end
	end
end

local function getBalancingFallingSpriteOffsetMulti(sprite)
	local frame = sprite:GetFrame()
	
	if frame <= 35 then
		return 1
	elseif frame == 36 then
		return 0.95
	elseif frame == 37 then
		return 0.9
	elseif frame == 38 then
		return 0.85
	elseif frame == 39 then
		return 0.8
	elseif frame == 40 then
		return 0.75
	elseif frame == 41 then
		return 0.375
	else
		return 0
	end
end

function mod:foozTwinGlobeBalanceAI(npc, sprite, npcdata)
	::foozTwinBalanceStateSelect::
	
	npcdata.balancingState = npcdata.balancingState or "Jump"
	
	if npcdata.balancingState == "Jump" then
		if shouldShortCircuitTwinAttack(npc, npcdata) and (npcdata.jumpingState == nil or npcdata.jumpingState == "Start") then
			npcdata.balancingState = "Landed"
			npcdata.isShortCircuiting = true
			goto foozTwinBalanceStateSelect
		end
		
		local jumpAnim = "LongJumpStart"
		local landAnim = "JumpLand"
		if mod:foozTwinJumpingAI(npc, sprite, npcdata, npc.Position, GLOBE_TWIN_JUMP_HEIGHT, GLOBE_TWIN_JUMP_DURATION, landAnim, jumpAnim, FoozJumpType.SLAMMER_BALL) then
			local ball = npc.Parent
			if ball and not shouldShortCircuitTwinAttack(npc, npcdata) then
				mod:GetEntityData(ball).state = "GlobeWait"
				npcdata.balancingState = "Balancing"
				npcdata.waitingToBalance = true
				goto foozTwinBalanceStateSelect
			else
				npcdata.balancingState = "Landed"
				npcdata.isShortCircuiting = true
				goto foozTwinBalanceStateSelect
			end
		end
	elseif npcdata.balancingState == "Balancing" then
		npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_TARGET)
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
					
		npc.Velocity = nilvector
		npc.PositionOffset = Vector(0,0)
		npc.SizeMulti = Vector(1, 1)
		npc.Visible = false
		
		if shouldShortCircuitTwinAttack(npc, npcdata) then
			if npcdata.waitingToBalance or sprite:IsPlaying("LongJumpDown") then
				npcdata.balancingState = "Jump"
				npcdata.jumpingState = "Down"
				npcdata.slammerJumpTargetVel = nilvector
				npcdata.waitingToBalance = nil
				goto foozTwinBalanceStateSelect
			else
				npcdata.balancingState = "Falling"
				if npc.Parent then
					npc.Position = npc.Parent.Position
				end
				sprite:Play("RollVertStop", true)
				sprite:SetFrame(30)
				goto foozTwinBalanceStateSelect
			end
		end
	elseif npcdata.balancingState == "Falling" then
		npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_TARGET)
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
		
		npcdata.balancingLastBallVel = npcdata.balancingLastBallVel or Vector(0,0)
		npc.Velocity = npcdata.balancingLastBallVel:Resized(1) * -1
		npc.PositionOffset = Vector(0,0)
		npc.SizeMulti = Vector(1, 1)
		npc.Visible = true
		
		npc.SpriteOffset = npcdata.balancingLastSpriteOffset * getBalancingFallingSpriteOffsetMulti(sprite)
		
		if sprite:IsEventTriggered("Sound") then
			npcdata.balancingState = "Landed"
			npc:PlaySound(SoundEffect.SOUND_MEAT_IMPACTS, 1.0, 0, false, (9.5 + math.random()) / 10)
			goto foozTwinBalanceStateSelect
		end
	elseif npcdata.balancingState == "Landed" then
		npc:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_TARGET)
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
		
		npc.Velocity = nilvector
		npc.SpriteOffset = Vector(0,0)
		npc.PositionOffset = Vector(0,0)
		sprite.FlipX = false
		npc.SizeMulti = Vector(1, 1)
		npc.Visible = true
		
		if sprite:IsFinished("RollVertStop") or sprite:IsFinished("RollHoriStop") or npcdata.isShortCircuiting then
			npcdata.jumpingState = nil
			npcdata.jumpHeight = nil
			npcdata.jumpDuration = nil
			npcdata.jumpMaxDuration = nil
			npcdata.jumpStartedOnFrame = nil
			npcdata.jumpingHasLanded = nil
			npcdata.slammerJumpTargetPos = nil
			npcdata.slammerJumpIsGo = nil
			npcdata.slammerJumpTargetVel = nil
			npcdata.slammerJumpMaxSpeed = nil
			npcdata.slammerJumpInitialTargetAngle = nil
			npcdata.jumpingDelay = nil
			
			npcdata.balancingState = nil
			npcdata.balancingLastBallVel = nil
			npcdata.balancingLastSpriteOffset = nil
			npcdata.waitingToBalance = nil
			npcdata.isShortCircuiting = nil
			
			npcdata.currentAttack = FoozAttacks.LOAFING_AROUND
			mod:foozTwinLoafingAI(npc, sprite, npcdata)
			
			if (npcdata.currentAttack == FoozAttacks.LOAFING_AROUND or npcdata.currentAttack == FoozAttacks.PENDING) and 
			   npcdata.otherTwin and 
			   (mod:GetEntityData(npcdata.otherTwin).currentAttack == FoozAttacks.LOAFING_AROUND or mod:GetEntityData(npcdata.otherTwin).currentAttack == FoozAttacks.PENDING)
			then
				if npc.Parent then
					mod:GetEntityData(npc.Parent).waitingToOrderAttack = BALL_ORDER_TIMER
				end
			end
		end
	end
	
	return
end

function mod:foozTwinGlobeAI(npc, sprite, npcdata)
	npcdata.loafingAnimDir = nil
	
	if npcdata.globeBalancer then
		mod:foozTwinGlobeBalanceAI(npc, sprite, npcdata)
	else
		mod:foozTwinGlobeBounceAI(npc, sprite, npcdata)
	end
end

local function alignPositionToGrid(pos)
	local x = math.floor(pos.X / 40) * 40 + 20
	local y = math.floor(pos.Y / 40) * 40 + 20
	
	return Vector(x,y)
end

local function getTornadoPosition(tornadoPos, tornadoAngle)
	return tornadoPos + Vector(math.cos(tornadoAngle / 180 * math.pi) * 21.5, math.sin(tornadoAngle / 180 * math.pi) * 8)
end

function mod:foozTwinCycloneAI(npc, sprite, npcdata)
	npcdata.loafingAnimDir = nil
	npcdata.cycloneState = npcdata.cycloneState or "Start"
	
	local isShortCircuitingAttack = shouldShortCircuitTwinAttack(npc, npcdata)
	
	::foozTwinCycloneStateSelect::
	
	if isShortCircuitingAttack then
		if npcdata.cycloneState == "Start" or npcdata.cycloneState == "Wait" or npcdata.cycloneState == "Jump" then
			npc:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_TARGET)
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
			npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
			
			npc.Velocity = nilvector
			npc.SpriteOffset = Vector(0,0)
			npc.PositionOffset = Vector(0,0)
			npc.SizeMulti = Vector(1, 1)
			npc.Visible = true
			sprite.FlipX = false
			
			npcdata.cycloneState = nil
			npcdata.cycloneTauntState = nil
			npcdata.cycloneFocalPoint = nil
			npcdata.cycloneFocalAngle = nil
			npcdata.cycloneJumpState = nil
			npcdata.cycloneJumpDuration = nil
			npcdata.cycloneJumpMaxDuration = nil
			npcdata.cycloneSpiralFrames = nil
			npcdata.cycloneSpiralAngle = nil
			npcdata.cycloneTornadoFrames = nil
			npcdata.cycloneTargetingBallCooldown = nil
			npcdata.cycloneHasPushedBall = nil
			npcdata.lastCycloneUpdate = nil
			npcdata.cycloneLanded = nil
			
			mod:GetEntityData(npc.Parent).waitingToOrderAttack = BALL_ORDER_TIMER
			
			npcdata.currentAttack = FoozAttacks.LOAFING_AROUND
			mod:foozTwinLoafingAI(npc, sprite, npcdata)
			return
		elseif npcdata.cycloneState == "DoubleBoost" or npcdata.cycloneState == "SlowDown" then
			npcdata.cycloneState = "Split"
		elseif npcdata.cycloneState == "Tornado" then
			local focalAngle = npcdata.attackRNG:RandomInt(360)
			
			npcdata.cycloneState = "Split"
			npcdata.cycloneFocalPoint = npc.Position
			npcdata.cycloneFocalAngle = focalAngle
			npcdata.cycloneSpiralAngle = npc.Velocity:GetAngleDegrees()
			npcdata.cycloneSpiralFrames = CYCLONE_TWIN_TORNADO_ENDING_FRAMES
			npc.Velocity = getTornadoPosition(npcdata.cycloneFocalPoint, npcdata.cycloneFocalAngle) - npc.Position
			
			local otherTwin = npcdata.otherTwin
			if otherTwin and otherTwin:Exists() and not otherTwin:IsDead() then
				local otherdata = mod:GetEntityData(otherTwin)
				
				otherdata.cycloneState = "Split"
				otherdata.cycloneFocalPoint = npc.Position
				otherdata.cycloneFocalAngle = (focalAngle + 180) % 360
				otherdata.cycloneSpiralAngle = npc.Velocity:GetAngleDegrees()
				otherdata.cycloneSpiralFrames = CYCLONE_TWIN_TORNADO_ENDING_FRAMES
				otherTwin.Velocity = getTornadoPosition(otherdata.cycloneFocalPoint, otherdata.cycloneFocalAngle) - otherTwin.Position
			end
		end
	end
	
	if npcdata.cycloneState == "Start" then
		-- taunt at the other twin
		npc:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_TARGET)
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
		
		npc.Velocity = nilvector
		npc.SpriteOffset = Vector(0,0)
		npc.PositionOffset = Vector(0,0)
		npc.SizeMulti = Vector(1, 1)
		npc.Visible = true
		
		npcdata.cycloneTauntState = npcdata.cycloneTauntState or 0
		if sprite:IsEventTriggered("StartFlex") then
			npcdata.cycloneTauntState = 1
		elseif sprite:IsEventTriggered("StopFlex") then
			npcdata.cycloneTauntState = 2
		end
		
		if npcdata.cycloneTauntState == 0 then
			sprite.FlipX = false
		elseif npcdata.cycloneTauntState == 1 then
			if npc.SubType == mod.FF.FoozTwinRed.Sub and npcdata.otherTwin.Position.X > npc.Position.X then
				sprite.FlipX = true
			elseif npc.SubType == mod.FF.FoozTwinWhite.Sub and npcdata.otherTwin.Position.X < npc.Position.X then
				sprite.FlipX = true
			else
				sprite.FlipX = false
			end
		else
			if npcdata.otherTwin.Position.X > npc.Position.X then
				sprite.FlipX = false
			else
				sprite.FlipX = true
			end
		end
		
		if sprite:IsFinished("TauntToTornado") then
			npcdata.cycloneState = "Wait"
		elseif not sprite:IsPlaying("TauntToTornado") then
			sprite:Play("TauntToTornado", true)
		end
	end
	
	if npcdata.cycloneState == "Wait" then
		npc:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_TARGET)
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
		
		npc.Velocity = nilvector
		npc.SpriteOffset = Vector(0,0)
		npc.PositionOffset = Vector(0,0)
		npc.SizeMulti = Vector(1, 1)
		npc.Visible = true
		
		if not sprite:IsPlaying("IdleHori") then
			sprite:Play("IdleHori", true)
		end
		
		if npcdata.otherTwin.Position.X > npc.Position.X then
			sprite.FlipX = false
		else
			sprite.FlipX = true
		end
		
		if mod:GetEntityData(npcdata.otherTwin).cycloneState == "Wait" then
			npcdata.cycloneState = "Jump"
			mod:GetEntityData(npcdata.otherTwin).cycloneState = "Jump"
			
			if npc.Index > npcdata.otherTwin.Index then
				npcdata.otherTwin:Update()
			end
		end
	end
	
	if npcdata.cycloneState == "Jump" then
		local otherTwin = npcdata.otherTwin
		
		-- bring them together
		if npcdata.otherTwin.Position.X > npc.Position.X then
			sprite.FlipX = false
		else
			sprite.FlipX = true
		end
		
		if npcdata.cycloneFocalPoint == nil then
			local room = game:GetRoom()
			
			local initialPos = alignPositionToGrid((otherTwin.Position - npc.Position) / 2 + npc.Position)
			if room:GetGridCollisionAtPos(initialPos) ~= GridCollisionClass.COLLISION_NONE then
				initialPos = room:FindFreePickupSpawnPosition(initialPos, 40)
			end
			
			npcdata.cycloneFocalPoint = initialPos
			mod:GetEntityData(otherTwin).cycloneFocalPoint = initialPos
			
			if npcdata.otherTwin.Position.X > npc.Position.X then
				npcdata.cycloneFocalAngle = 180
				mod:GetEntityData(otherTwin).cycloneFocalAngle = 0
			else
				npcdata.cycloneFocalAngle = 0
				mod:GetEntityData(otherTwin).cycloneFocalAngle = 180
			end
		end
		
		npcdata.cycloneJumpState = npcdata.cycloneJumpState or 1
		if sprite:IsEventTriggered("StartJump") then
			npcdata.cycloneJumpState = 2
		elseif sprite:IsEventTriggered("StopJump") then
			npcdata.cycloneJumpState = 3
			npc:PlaySound(SoundEffect.SOUND_MEAT_IMPACTS, 1.0, 0, false, (9.5 + math.random()) / 10)
		end
		
		if npcdata.cycloneJumpDuration == nil then
			local npcJumpFrameLen = math.max(math.ceil((getTornadoPosition(npcdata.cycloneFocalPoint, npcdata.cycloneFocalAngle) - npc.Position):Length() / CYCLONE_TWIN_JUMP_MAX_SPEED), 8)
			local otherJumpFrameLen = math.max(math.ceil((getTornadoPosition(mod:GetEntityData(otherTwin).cycloneFocalPoint, mod:GetEntityData(otherTwin).cycloneFocalAngle) - npc.Position):Length() / CYCLONE_TWIN_JUMP_MAX_SPEED), 8)
			local jumpFrameLen = math.max(npcJumpFrameLen, otherJumpFrameLen)
			
			npcdata.cycloneJumpDuration = jumpFrameLen
			mod:GetEntityData(otherTwin).cycloneJumpDuration = jumpFrameLen
			
			npcdata.cycloneJumpMaxDuration = jumpFrameLen
			mod:GetEntityData(otherTwin).cycloneJumpMaxDuration = jumpFrameLen
		end
		
		if npcdata.cycloneJumpState == 1 then
			npc:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_TARGET)
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
			npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
			
			npc.Velocity = nilvector
			npc.SpriteOffset = Vector(0,0)
			npc.PositionOffset = Vector(0,0)
			npc.SizeMulti = Vector(1, 1)
			npc.Visible = true
		elseif npcdata.cycloneJumpState == 2 then
			npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_TARGET)
			npc:ClearEntityFlags(EntityFlag.FLAG_KNOCKED_BACK | EntityFlag.FLAG_APPLY_IMPACT_DAMAGE)
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
			npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
			
			local tornadoPos = getTornadoPosition(npcdata.cycloneFocalPoint, npcdata.cycloneFocalAngle)
			npc.Velocity = (tornadoPos - npc.Position):Resized((tornadoPos - npc.Position):Length() / npcdata.cycloneJumpDuration)
			npc.SpriteOffset = Vector(0,0)
			npc.PositionOffset = Vector(0, math.sin((npcdata.cycloneJumpDuration / npcdata.cycloneJumpMaxDuration) * math.pi) ^ 0.5 * CYCLONE_TWIN_JUMP_HEIGHT)
			npc.SizeMulti = Vector(1, 1)
			npc.Visible = true
		else
			npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
			npc:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_KNOCKED_BACK | EntityFlag.FLAG_APPLY_IMPACT_DAMAGE)
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
			npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
			
			npc.Position = getTornadoPosition(npcdata.cycloneFocalPoint, npcdata.cycloneFocalAngle)
			npc.Velocity = nilvector
			npc.SpriteOffset = Vector(0,0)
			npc.PositionOffset = Vector(0,0)
			npc.SizeMulti = Vector(1, 1)
			npc.Visible = true
		end
		
		if npcdata.cycloneJumpState == 1 then
			if not sprite:IsPlaying("TornadoStartStart") then
				sprite:Play("TornadoStartStart", true)
			end
		elseif npcdata.cycloneJumpState == 2 then
			npcdata.cycloneJumpDuration = npcdata.cycloneJumpDuration - 1
			if npcdata.cycloneJumpDuration <= 2 then
				if not sprite:IsPlaying("TornadoStartEnd") then
					sprite:Play("TornadoStartEnd", true)
				end
			elseif sprite:IsFinished("TornadoStartStart") then
				sprite:Play("TornadoStartLoop", true)
			end
		elseif npcdata.cycloneJumpState == 3 then
			if sprite:IsFinished("TornadoStartEnd") then
				npcdata.cycloneState = "DoubleBoost"
			end
		end
	end
	
	if npcdata.cycloneState == "DoubleBoost" then
		-- TOGETHER WE CAN SHOW THE WORLD WHAT WE CAN DO
		npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
		npc:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_KNOCKED_BACK | EntityFlag.FLAG_APPLY_IMPACT_DAMAGE)
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
		
		npc.SpriteOffset = Vector(0,0)
		npc.PositionOffset = Vector(0,0)
		sprite.FlipX = false
		npc.SizeMulti = Vector(1, 1)
		npc.Visible = true
		
		if (npcdata.lastCycloneUpdate or 0) ~= game:GetFrameCount() then
			local otherTwin = npcdata.otherTwin
			local otherdata = mod:GetEntityData(otherTwin)
			
			if (npcdata.cycloneSpiralFrames or 0) >= CYCLONE_TWIN_TORNADO_STARTUP_FRAMES then
				npcdata.cycloneState = "Tornado"
				otherdata.cycloneState = "Tornado"
				
				local focalPoint = (otherTwin.Position - npc.Position) / 2 + npc.Position
				if npc.SubType == mod.FF.FoozTwinRed.Sub then
					npc.Position = focalPoint
					npc.Velocity = Vector.FromAngle(npcdata.cycloneSpiralAngle):Resized(4)
				else
					otherTwin.Position = focalPoint
					npc.Velocity = Vector.FromAngle(otherdata.cycloneSpiralAngle):Resized(4)
				end
				
				goto foozTwinCycloneStateSelect
			end
			
			local focalPoint = (otherTwin.Position - npc.Position) / 2 + npc.Position
			npcdata.cycloneFocalPoint = focalPoint
			otherdata.cycloneFocalPoint = focalPoint
			
			npc.Position = getTornadoPosition(npcdata.cycloneFocalPoint, npcdata.cycloneFocalAngle)
			otherTwin.Position = getTornadoPosition(otherdata.cycloneFocalPoint, otherdata.cycloneFocalAngle)
			
			if npcdata.cycloneSpiralAngle == nil then
				local spiralAngle = npcdata.attackRNG:RandomInt(360)
				npcdata.cycloneSpiralAngle = spiralAngle
				otherdata.cycloneSpiralAngle = spiralAngle
				npcdata.cycloneSpiralFrames = 0
				otherdata.cycloneSpiralFrames = 0
			end
			
			local spiralAngle = npcdata.cycloneSpiralAngle
			local spiralFrames = npcdata.cycloneSpiralFrames
			npcdata.cycloneFocalPoint = npcdata.cycloneFocalPoint + Vector.FromAngle(spiralAngle):Resized(spiralFrames / (CYCLONE_TWIN_TORNADO_STARTUP_FRAMES / 4))
			otherdata.cycloneFocalPoint = otherdata.cycloneFocalPoint + Vector.FromAngle(spiralAngle):Resized(spiralFrames / (CYCLONE_TWIN_TORNADO_STARTUP_FRAMES / 4))
			npcdata.cycloneFocalAngle = (npcdata.cycloneFocalAngle - (5 + math.ceil(25 * spiralFrames / CYCLONE_TWIN_TORNADO_STARTUP_FRAMES))) % 360
			otherdata.cycloneFocalAngle = (otherdata.cycloneFocalAngle - (5 + math.ceil(25 * spiralFrames / CYCLONE_TWIN_TORNADO_STARTUP_FRAMES))) % 360
			
			npcdata.cycloneSpiralAngle = spiralAngle + 12
			otherdata.cycloneSpiralAngle = spiralAngle + 12
			npcdata.cycloneSpiralFrames = math.min(spiralFrames + 1, CYCLONE_TWIN_TORNADO_STARTUP_FRAMES)
			otherdata.cycloneSpiralFrames = math.min(spiralFrames + 1, CYCLONE_TWIN_TORNADO_STARTUP_FRAMES)
			
			npc.Velocity = getTornadoPosition(npcdata.cycloneFocalPoint, npcdata.cycloneFocalAngle) - npc.Position
			otherTwin.Velocity = getTornadoPosition(otherdata.cycloneFocalPoint, otherdata.cycloneFocalAngle) - otherTwin.Position
			
			npcdata.lastCycloneUpdate = game:GetFrameCount()
			otherdata.lastCycloneUpdate = game:GetFrameCount()
		end
		
		if 337.5 <= npcdata.cycloneFocalAngle or npcdata.cycloneFocalAngle < 22.5 then
			sprite:SetFrame("TornadoRotate", 8)
		elseif 22.5 <= npcdata.cycloneFocalAngle and npcdata.cycloneFocalAngle < 67.5 then
			sprite:SetFrame("TornadoRotate", 6)
		elseif 67.5 <= npcdata.cycloneFocalAngle and npcdata.cycloneFocalAngle < 112.5 then
			sprite:SetFrame("TornadoRotate", 4)
		elseif 112.5 <= npcdata.cycloneFocalAngle and npcdata.cycloneFocalAngle < 157.5 then
			sprite:SetFrame("TornadoRotate", 2)
		elseif 157.5 <= npcdata.cycloneFocalAngle and npcdata.cycloneFocalAngle < 202.5 then
			sprite:SetFrame("TornadoRotate", 0)
		elseif 202.5 <= npcdata.cycloneFocalAngle and npcdata.cycloneFocalAngle < 247.5 then
			sprite:SetFrame("TornadoRotate", 14)
		elseif 247.5 <= npcdata.cycloneFocalAngle and npcdata.cycloneFocalAngle < 292.5 then
			sprite:SetFrame("TornadoRotate", 12)
		elseif 292.5 <= npcdata.cycloneFocalAngle and npcdata.cycloneFocalAngle < 337.5 then
			sprite:SetFrame("TornadoRotate", 10)
		end
		sprite:Stop()
	end
	
	if npcdata.cycloneState == "Tornado" then
		-- kirby tornado behaviour time
		if npc.SubType == mod.FF.FoozTwinRed.Sub then
			npcdata.cycloneTornadoFrames = (npcdata.cycloneTornadoFrames or CYCLONE_TWIN_TORNADO_FRAMES) - 1
			if npcdata.cycloneTornadoFrames <= 0 then
				local otherTwin = npcdata.otherTwin
				local otherdata = mod:GetEntityData(otherTwin)
				
				npcdata.cycloneState = "SlowDown"
				otherdata.cycloneState = "SlowDown"
				
				npcdata.cycloneFocalPoint = npc.Position
				otherdata.cycloneFocalPoint = npc.Position
				
				local focalAngle = npcdata.attackRNG:RandomInt(360)
				npcdata.cycloneFocalAngle = focalAngle
				otherdata.cycloneFocalAngle = (focalAngle + 180) % 360
				
				npcdata.cycloneSpiralAngle = npc.Velocity:GetAngleDegrees()
				otherdata.cycloneSpiralAngle = npc.Velocity:GetAngleDegrees()
				npcdata.cycloneSpiralFrames = CYCLONE_TWIN_TORNADO_ENDING_FRAMES
				otherdata.cycloneSpiralFrames = CYCLONE_TWIN_TORNADO_ENDING_FRAMES
				
				npc.Position = getTornadoPosition(npcdata.cycloneFocalPoint, npcdata.cycloneFocalAngle)
				otherTwin.Position = getTornadoPosition(otherdata.cycloneFocalPoint, otherdata.cycloneFocalAngle)
				
				otherTwin:Update()
				goto foozTwinCycloneStateSelect
			end
		
			npc:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_TARGET)
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
			npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
			
			npc.SpriteOffset = Vector(0,0)
			npc.PositionOffset = Vector(0,0)
			npc.SizeMulti = Vector(1.5, 1)
			npc.Visible = true
			sprite.FlipX = false
			
			local target = npc:GetPlayerTarget()
			local ball = npc.Parent
			
			local targetAngleDiff = CYCLONE_TWIN_TORNADO_MAX_ANGLE_DIFF_PLAYER
			local targetAngle
			if ((target.Position - npc.Position):Length() < (ball.Position - npc.Position):Length() or 
			    mod:GetEntityData(ball).tornadoPushLerpMultiFrames > 0 or
			    (npcdata.cycloneTargetingBallCooldown or 0) < 0) and
			   npcdata.cycloneHasPushedBall
			then
				targetAngle = mod:reverseIfFear(npc, mod:confusePos(npc, target.Position) - npc.Position):GetAngleDegrees()
				if targetAngle < 0 then
					targetAngle = targetAngle + 360
				end
				if (npcdata.cycloneTargetingBallCooldown or 0) < 0 then
					npcdata.cycloneTargetingBallCooldown = (npcdata.cycloneTargetingBallCooldown or 0) + 1
				else
					npcdata.cycloneTargetingBallCooldown = 0
				end
			else
				targetAngleDiff = CYCLONE_TWIN_TORNADO_MAX_ANGLE_DIFF_BALL
				
				targetAngle = (mod:confusePos(npc, ball.Position) - npc.Position):GetAngleDegrees()
				if targetAngle < 0 then
					targetAngle = targetAngle + 360
				end
				npcdata.cycloneTargetingBallCooldown = (npcdata.cycloneTargetingBallCooldown or 0) + 1
			end
			if (npcdata.cycloneTargetingBallCooldown or 0) >= 30 then
				npcdata.cycloneTargetingBallCooldown = -60
			end
			
			local tornadoAngle = npc.Velocity:GetAngleDegrees()
			if math.abs(targetAngle - tornadoAngle) < targetAngleDiff or 
			   math.abs((targetAngle - 360) - tornadoAngle) < targetAngleDiff or 
			   math.abs(targetAngle - (tornadoAngle - 360)) < targetAngleDiff
			then
				tornadoAngle = targetAngle
			else
				local angleDistA = targetAngle - tornadoAngle
				local angleDistB = (targetAngle - 360) - tornadoAngle
				local angleDistC = targetAngle - (tornadoAngle - 360)
				
				if math.abs(angleDistA) < math.abs(angleDistB) and math.abs(angleDistA) < math.abs(angleDistC) then
					if angleDistA < 0 then
						tornadoAngle = tornadoAngle + targetAngleDiff * -1
					else
						tornadoAngle = tornadoAngle + targetAngleDiff
					end
				elseif math.abs(angleDistB) < math.abs(angleDistC) then
					if angleDistB < 0 then
						tornadoAngle = tornadoAngle + targetAngleDiff * -1
					else
						tornadoAngle = tornadoAngle + targetAngleDiff
					end
				else
					if angleDistC < 0 then
						tornadoAngle = tornadoAngle + targetAngleDiff * -1
					else
						tornadoAngle = tornadoAngle + targetAngleDiff
					end
				end
			end
			npc.Velocity = Vector.FromAngle(tornadoAngle):Resized(CYCLONE_TWIN_TORNADO_VEL)
			
			npcdata.otherTwin.Position = npc.Position
			npcdata.otherTwin.Velocity = npc.Velocity
			
			if not sprite:IsPlaying("TornadoLoop") then
				sprite:Play("TornadoLoop", true)
			end
		else
			npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_TARGET)
			npc:ClearEntityFlags(EntityFlag.FLAG_KNOCKED_BACK | EntityFlag.FLAG_APPLY_IMPACT_DAMAGE)
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
			
			npc.SpriteOffset = Vector(0,0)
			npc.PositionOffset = Vector(0,0)
			--npc.Position = npcdata.otherTwin.Position
			--npc.Velocity = nilvector
			sprite.FlipX = false
			npc.SizeMulti = Vector(1, 1)
			npc.Visible = false
			
			--npc:RemoveStatusEffects()
			--mod:removeStatusEffects(npc, true)
		end
	end
	
	if npcdata.cycloneState == "SlowDown" then
		-- slow the spinning back down in prep for the end
		npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
		npc:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_KNOCKED_BACK | EntityFlag.FLAG_APPLY_IMPACT_DAMAGE)
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
		
		npc.SpriteOffset = Vector(0,0)
		npc.PositionOffset = Vector(0,0)
		sprite.FlipX = false
		npc.SizeMulti = Vector(1, 1)
		npc.Visible = true
		
		local ball = npc.Parent
		local balldata = mod:GetEntityData(ball)
		
		for i = #(balldata.tornadoPushedBy), 1, -1 do
			local pusher = balldata.tornadoPushedBy[i]
			if pusher.Index == npc.Index and pusher.InitSeed == npc.InitSeed then
				table.remove(balldata.tornadoPushedBy, i)
			end
		end
		
		if (npcdata.lastCycloneUpdate or 0) ~= game:GetFrameCount() then
			local otherTwin = npcdata.otherTwin
			local otherdata = mod:GetEntityData(otherTwin)
			
			if (npcdata.cycloneSpiralFrames or 0) <= 0 then
				npcdata.cycloneState = "Split"
				otherdata.cycloneState = "Split"
				
				goto foozTwinCycloneStateSelect
			end
			
			local focalPoint = npcdata.cycloneFocalPoint
			if npcdata.cycloneSpiralFrames < 120 then
				local focalPoint = (otherTwin.Position - npc.Position) / 2 + npc.Position
				npcdata.cycloneFocalPoint = focalPoint
				otherdata.cycloneFocalPoint = focalPoint
			end
			
			npc.Position = getTornadoPosition(npcdata.cycloneFocalPoint, npcdata.cycloneFocalAngle)
			otherTwin.Position = getTornadoPosition(otherdata.cycloneFocalPoint, otherdata.cycloneFocalAngle)
			
			if npcdata.cycloneSpiralAngle == nil then
				local spiralAngle = npcdata.attackRNG:RandomInt(360)
				npcdata.cycloneSpiralAngle = spiralAngle
				otherdata.cycloneSpiralAngle = spiralAngle
				npcdata.cycloneSpiralFrames = 0
				otherdata.cycloneSpiralFrames = 0
			end
			
			local spiralAngle = npcdata.cycloneSpiralAngle
			local spiralFrames = npcdata.cycloneSpiralFrames
			npcdata.cycloneFocalPoint = npcdata.cycloneFocalPoint + Vector.FromAngle(spiralAngle):Resized(spiralFrames / (CYCLONE_TWIN_TORNADO_ENDING_FRAMES / 4))
			otherdata.cycloneFocalPoint = otherdata.cycloneFocalPoint + Vector.FromAngle(spiralAngle):Resized(spiralFrames / (CYCLONE_TWIN_TORNADO_ENDING_FRAMES / 4))
			npcdata.cycloneFocalAngle = (npcdata.cycloneFocalAngle - (15 + math.ceil(15 * spiralFrames / CYCLONE_TWIN_TORNADO_ENDING_FRAMES))) % 360
			otherdata.cycloneFocalAngle = (otherdata.cycloneFocalAngle - (15 + math.ceil(15 * spiralFrames / CYCLONE_TWIN_TORNADO_ENDING_FRAMES))) % 360
			
			npcdata.cycloneSpiralAngle = spiralAngle + 12
			otherdata.cycloneSpiralAngle = spiralAngle + 12
			npcdata.cycloneSpiralFrames = math.min(spiralFrames - 1, CYCLONE_TWIN_TORNADO_ENDING_FRAMES)
			otherdata.cycloneSpiralFrames = math.min(spiralFrames - 1, CYCLONE_TWIN_TORNADO_ENDING_FRAMES)
			
			npc.Velocity = getTornadoPosition(npcdata.cycloneFocalPoint, npcdata.cycloneFocalAngle) - npc.Position
			otherTwin.Velocity = getTornadoPosition(otherdata.cycloneFocalPoint, otherdata.cycloneFocalAngle) - otherTwin.Position
			
			npcdata.lastCycloneUpdate = game:GetFrameCount()
			otherdata.lastCycloneUpdate = game:GetFrameCount()
		end
		
		if 337.5 <= npcdata.cycloneFocalAngle or npcdata.cycloneFocalAngle < 22.5 then
			sprite:SetFrame("TornadoRotate", 8)
		elseif 22.5 <= npcdata.cycloneFocalAngle and npcdata.cycloneFocalAngle < 67.5 then
			sprite:SetFrame("TornadoRotate", 6)
		elseif 67.5 <= npcdata.cycloneFocalAngle and npcdata.cycloneFocalAngle < 112.5 then
			sprite:SetFrame("TornadoRotate", 4)
		elseif 112.5 <= npcdata.cycloneFocalAngle and npcdata.cycloneFocalAngle < 157.5 then
			sprite:SetFrame("TornadoRotate", 2)
		elseif 157.5 <= npcdata.cycloneFocalAngle and npcdata.cycloneFocalAngle < 202.5 then
			sprite:SetFrame("TornadoRotate", 0)
		elseif 202.5 <= npcdata.cycloneFocalAngle and npcdata.cycloneFocalAngle < 247.5 then
			sprite:SetFrame("TornadoRotate", 14)
		elseif 247.5 <= npcdata.cycloneFocalAngle and npcdata.cycloneFocalAngle < 292.5 then
			sprite:SetFrame("TornadoRotate", 12)
		elseif 292.5 <= npcdata.cycloneFocalAngle and npcdata.cycloneFocalAngle < 337.5 then
			sprite:SetFrame("TornadoRotate", 10)
		end
		sprite:Stop()
	end
	
	if npcdata.cycloneState == "Split" then
		-- break apart
		npc:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_TARGET)
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
		
		npc.SpriteOffset = Vector(0,0)
		npc.PositionOffset = Vector(0,0)
		npc.SizeMulti = Vector(1, 1)
		npc.Visible = true
		sprite.FlipX = false
		
		if npcdata.cycloneLanded == nil then
			npcdata.cycloneLanded = false
		end
		if sprite:IsEventTriggered("Sound") then
			npcdata.cycloneLanded = true
			npc:PlaySound(SoundEffect.SOUND_MEAT_IMPACTS, 1.0, 0, false, (9.5 + math.random()) / 10)
		end
		
		if npc.Velocity:Length() > 5 then
			npc.Velocity = npc.Velocity:Resized(5)
		end
		if npcdata.cycloneLanded == true then
			npc.Velocity = npc.Velocity * 0.75
		end
		
		if sprite:IsFinished("TornadoEnd") then
			npcdata.cycloneState = nil
			npcdata.cycloneTauntState = nil
			npcdata.cycloneFocalPoint = nil
			npcdata.cycloneFocalAngle = nil
			npcdata.cycloneJumpState = nil
			npcdata.cycloneJumpDuration = nil
			npcdata.cycloneJumpMaxDuration = nil
			npcdata.cycloneSpiralFrames = nil
			npcdata.cycloneSpiralAngle = nil
			npcdata.cycloneTornadoFrames = nil
			npcdata.cycloneTargetingBallCooldown = nil
			npcdata.cycloneHasPushedBall = nil
			npcdata.lastCycloneUpdate = nil
			npcdata.cycloneLanded = nil
			
			if npc.Parent then 
				mod:GetEntityData(npc.Parent).waitingToOrderAttack = BALL_ORDER_TIMER
			end
			
			npcdata.currentAttack = FoozAttacks.LOAFING_AROUND
			mod:foozTwinLoafingAI(npc, sprite, npcdata)
		elseif not sprite:IsPlaying("TornadoEnd") then
			sprite:Play("TornadoEnd", true)
		end
	end
end

function mod:foozBallAI(npc, sprite, npcdata)
	mod:setTargetOfNPC(npc, npcdata)
	
	if not npcdata.init then
		local twins = Isaac.FindByType(mod.FF.FoozTwinRed.ID, mod.FF.FoozTwinRed.Var)
		for _, twin in ipairs(twins) do
			if twin.SubType == mod.FF.FoozTwinRed.Sub and npcdata.redTwin == nil and twin.Parent == nil then
				npcdata.redTwin = twin
			elseif twin.SubType == mod.FF.FoozTwinWhite.Sub and npcdata.whiteTwin == nil and twin.Parent == nil then
				npcdata.whiteTwin = twin
			end
			
			if npcdata.redTwin ~= nil and npcdata.whiteTwin ~= nil then
				break
			end
		end
		
		if npcdata.redTwin == nil or npcdata.whiteTwin == nil then
			npc:Remove()
		else
			npcdata.redTwin.Parent = npc
			npcdata.whiteTwin.Parent = npc
			
			mod:GetEntityData(npcdata.redTwin).otherTwin = npcdata.whiteTwin
			mod:GetEntityData(npcdata.whiteTwin).otherTwin = npcdata.redTwin
			
			mod:copyStatusEffects(npc, npcdata.redTwin)
			mod:copyStatusEffects(npc, npcdata.whiteTwin)
		end
		
		npcdata.state = "Idle"
		npcdata.waitingToOrderAttack = BALL_ORDER_TIMER
		
		npcdata.attackRNG = RNG()
		npcdata.attackRNG:SetSeed(npc.InitSeed, 7)
		
		npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		sprite:Play("Appear", true)
		
		npcdata.init = true
		return
	end
	
	if sprite:IsPlaying("Appear") then
		if sprite:IsEventTriggered("Land") then
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
			sfx:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS, 0.9, 0, false, 1)
		elseif sprite:IsEventTriggered("SoftLand") then
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
			sfx:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS, 0.7, 0, false, 2)
		elseif sprite:IsEventTriggered("Bounce") then
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		elseif sprite:IsEventTriggered("Sound") then
			sfx:Play(mod.Sounds.FoozTwinsAppear, 1, 0, false, 1)
		end
		return
	else
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
	end
	
	local touchingGrid = npc:CollidesWithGrid()
	local velLength = npc.Velocity:Length()
	if not npcdata.touchingGrid and touchingGrid and velLength >= 0.5 then
		--sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 0.55, 0, false, 1.9 + math.random() * 0.2)
		sfx:Play(SoundEffect.SOUND_MEATY_DEATHS, 0.6, 0, false, 1.4 + math.random() * 0.2)
		if velLength >= 1 then game:ShakeScreen(4) end
		if (npcdata.impactSoundCooldown or 0) <= 0 then 
			sfx:Play(mod.Sounds.FoozTwinsImpact, 0.9, 0, false, 0.90 + math.random() * 0.2)
			npcdata.impactSoundCooldown = 60
		end
	end
	npcdata.impactSoundCooldown = math.max((npcdata.impactSoundCooldown or 0) - 1, 0)
	npcdata.touchingGrid = touchingGrid
	
	if velLength >= 1 and (npcdata.splatCooldown or 0) <= 0 then
		local splat = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_SPLAT, 0, npc.Position + RandomVector():Resized(math.random() * 7), Vector.Zero, npc)
		splat.SpriteScale = splat.SpriteScale * (0.575 + math.random() * 0.075)
		splat:Update()
		npcdata.splatCooldown = math.max(4, math.ceil(8 - velLength))
	end
	npcdata.splatCooldown = math.max((npcdata.splatCooldown or 0) - 1, 0)
	
	if npcdata.state ~= "Idle" and npcdata.state ~= "PassEnd" and npcdata.state ~= "GlobeWait" and npcdata.state ~= "GlobeChase" and npcdata.state ~= "GlobeEnd" then
		npcdata.idleRollFrame = nil
		npcdata.idleScaleFrame = nil
	end
	
	if npcdata.state ~= "PassGoad" and npcdata.state ~= "PassConnect" and npcdata.state ~= "Passing" or npcdata.state == "PassEnd" then
		npcdata.goadTarget = nil
		npcdata.revUp = nil
		npcdata.goadedRollFrame = nil
		npcdata.passRollFrame = nil
		npcdata.passTarget = nil
		npcdata.pursueTarget = nil
		npcdata.pursueParity = nil
		npcdata.timesPassed = nil
		npcdata.passEndTimer = nil
		npcdata.passAngleCorrection = nil
		npcdata.passKickTimeout = nil
		npcdata.passLerpFrames = nil
	end
	
	npcdata.tornadoPushedBy = npcdata.tornadoPushedBy or {}
	if npcdata.state == "PassGoad" or npcdata.state == "PassConnect" or npcdata.state == "Passing" or npcdata.state == "PassEnd" or 
	   npcdata.state == "GlobeWait" or npcdata.state == "GlobeChase" or npcdata.state == "GlobeEnd" 
	then
		npcdata.tornadoPushedBy = {}
	end
	npcdata.tornadoPushLerpMultiFrames = npcdata.tornadoPushLerpMultiFrames or 0
		
	for i = #(npcdata.tornadoPushedBy), 1, -1 do
		local pusher = npcdata.tornadoPushedBy[i]
		if not pusher:Exists() or mod:GetEntityData(pusher).cycloneState ~= "Tornado" then
			table.remove(npcdata.tornadoPushedBy, i)
		end
	end
	
	if npcdata.state == "Idle" or npc:IsDead() then
		mod:foozBallIdleAI(npc, sprite, npcdata)
	elseif npcdata.state == "PassGoad" or npcdata.state == "PassConnect" or npcdata.state == "Passing" or npcdata.state == "PassEnd" then
		mod:foozBallPassingAI(npc, sprite, npcdata)
	elseif npcdata.state == "GlobeWait" or npcdata.state == "GlobeChase" or npcdata.state == "GlobeEnd" then
		mod:foozBallGlobeAI(npc, sprite, npcdata)
	end
	if #(npcdata.tornadoPushedBy) <= 0 then
		npcdata.tornadoPushLerpMultiFrames = math.max(0, npcdata.tornadoPushLerpMultiFrames - 1)
	end
	
	if (not (npcdata.redTwin and npcdata.redTwin:Exists() and not npcdata.redTwin:IsDead())) or
	   (not (npcdata.whiteTwin and npcdata.whiteTwin:Exists() and not npcdata.whiteTwin:IsDead()))
	then
		return
	end
	
	if npcdata.waitingToOrderAttack ~= nil then
		npcdata.waitingToOrderAttack = npcdata.waitingToOrderAttack - 1
		if npcdata.waitingToOrderAttack <= 0 then
			local selectedAttack
			repeat
				selectedAttack = npcdata.attackRNG:RandomInt(3)
			until (selectedAttack ~= npcdata.lastAttackSelected)
			npcdata.lastAttackSelected = selectedAttack
			
			if selectedAttack == 1 then
				mod:GetEntityData(npcdata.redTwin).pendingAttack = FoozAttacks.PASSING_DRILL
				mod:GetEntityData(npcdata.whiteTwin).pendingAttack = FoozAttacks.PASSING_DRILL
				
				if npcdata.attackRNG:RandomInt(2) == 1 then
					mod:GetEntityData(npcdata.redTwin).passingWillGoad = true
					mod:GetEntityData(npcdata.whiteTwin).passingWillGoad = false
				else
					mod:GetEntityData(npcdata.redTwin).passingWillGoad = false
					mod:GetEntityData(npcdata.whiteTwin).passingWillGoad = true
				end
			elseif selectedAttack == 2 then
				mod:GetEntityData(npcdata.redTwin).pendingAttack = FoozAttacks.CYCLONE_BROS
				mod:GetEntityData(npcdata.whiteTwin).pendingAttack = FoozAttacks.CYCLONE_BROS
			else
				mod:GetEntityData(npcdata.redTwin).pendingAttack = FoozAttacks.WALKING_GLOBE
				mod:GetEntityData(npcdata.whiteTwin).pendingAttack = FoozAttacks.WALKING_GLOBE
				
				if npcdata.attackRNG:RandomInt(2) == 1 then
					mod:GetEntityData(npcdata.redTwin).globeBalancer = true
					mod:GetEntityData(npcdata.whiteTwin).globeBalancer = false
					
					npcdata.globeBalancer = npcdata.redTwin
					npcdata.globeBouncer = npcdata.whiteTwin
				else
					mod:GetEntityData(npcdata.redTwin).globeBalancer = false
					mod:GetEntityData(npcdata.whiteTwin).globeBalancer = true
					
					npcdata.globeBalancer = npcdata.whiteTwin
					npcdata.globeBouncer = npcdata.redTwin
				end
			end
			
			npcdata.waitingToOrderAttack = nil
		end
	end
	
	if npc.Velocity:Length() > 3 then
		local mult = mod:getBasegameVelocityMultiplier(npc)
		for _,grid in ipairs(mod.GetGridEntities()) do
			if FoozDestructibleGrids[grid:GetType()] then
				if (grid.Position - (npc.Position + npc.Velocity * mult)):Length() <= 30 + npc.Size * math.max(npc.SizeMulti.X, npc.SizeMulti.Y) then
					grid:Destroy()
				end
			end
		end
	end
end

function mod:foozBallIdleAI(npc, sprite, npcdata, lerpMulti, ignoreRollFrameUpdate, doNotUpdateVel)
	if #(npcdata.tornadoPushedBy) >= 1 then
		npc.Velocity = npc.Velocity:Resized(CYCLONE_TWIN_TORNADO_PUSH_FORCE)
	end
	
	local target = npc:GetPlayerTarget()
	local speed = npc.Velocity:Length()
	local targvel = mod:reverseIfFear(npc, mod:confusePos(npc, target.Position) - npc.Position):Resized(speed)
	
	npcdata.idleRollFrame = npcdata.idleRollFrame or 0
	npcdata.idleScaleFrame = npcdata.idleScaleFrame or 0
	
	local spriteScale = Vector(1,1)
	if speed < 0.5 then
		if #(npcdata.tornadoPushedBy) <= 0 and doNotUpdateVel ~= true then
			npc.Velocity = npc.Velocity * 0.9
		end
		
		local scaleMult = 0
		if npcdata.idleScaleFrame % 32 < 16 then
			scaleMult = npcdata.idleScaleFrame % 16 / 16
		else
			scaleMult = 1 - npcdata.idleScaleFrame % 16 / 16
		end
		spriteScale = Vector(1 + 0.05 * scaleMult, 1 - 0.05 * scaleMult)
		
		npcdata.idleScaleFrame = npcdata.idleScaleFrame + 1
	else
		if #(npcdata.tornadoPushedBy) <= 0 and doNotUpdateVel ~= true then
			local pushLerpMulti = math.max(0, math.min(1, 1 - npcdata.tornadoPushLerpMultiFrames / CYCLONE_BALL_LERP_MULTI_FRAMES))
			npc.Velocity = mod:Lerp(npc.Velocity, targvel, 0.15 * (lerpMulti or 1) * pushLerpMulti) * 0.98
		end
		
		if not ignoreRollFrameUpdate then
			if speed > 3 then
				npcdata.idleRollFrame = npcdata.idleRollFrame + 2
			else
				npcdata.idleRollFrame = npcdata.idleRollFrame + 1
			end
		end
		
		npcdata.idleScaleFrame = 0
	end
	
	local dir = nil
	if math.abs(npc.Velocity.X) > math.abs(npc.Velocity.Y) then
		if npc.Velocity.X > 0 then
			dir = "Right"
		else
			dir = "Left"
		end
	else
		if npc.Velocity.Y < 0 then
			dir = "Up"
		else
			dir = "Down"
		end
	end
	
	sprite:Play("Roll" .. dir, true)
	sprite:SetFrame(math.floor(npcdata.idleRollFrame % 32 / 2))
	table.insert(foozBallsToChangeScaleOf, {NPC = npc, Scale = spriteScale})
end

function mod:foozBallPassingAI(npc, sprite, npcdata)
	if npcdata.passKickTimeout ~= nil then
		npcdata.passKickTimeout = npcdata.passKickTimeout - 1
		if npcdata.passKickTimeout <= 0 then
			npcdata.passKickTimeout = nil
			goto foozBallPassingEndOfAttack
		end
	end

	::foozBallPassingStateSelect::

	if npcdata.state == "PassGoad" then
		if npcdata.goadTarget == nil or not npcdata.goadTarget:Exists() then
			goto foozBallPassingEndOfAttack
		end
		
		local targetPosition = npcdata.goadTarget.Position
		local targetXDist = targetPosition.X - npc.Position.X
		local targetYDist = targetPosition.Y - npc.Position.Y
		
		local dir = nil
		if math.abs(targetXDist) > math.abs(targetYDist) then
			if targetXDist > 0 then
				dir = "Right"
			else
				dir = "Left"
			end
		else
			if targetYDist < 0 then
				dir = "Down"
			else
				dir = "Up"
			end
		end
		
		npcdata.revUp = (npcdata.revUp or 0) + 1
		npcdata.goadedRollFrame = (npcdata.goadedRollFrame or 0) + (math.min(npcdata.revUp, PASS_BALL_REV_TO_MAX) ^ PASS_BALL_REV_POW)
	
		sprite:Play("Roll" .. dir, true)
		sprite:SetFrame(math.floor(npcdata.goadedRollFrame / ((PASS_BALL_REV_TO_MAX ^ PASS_BALL_REV_POW) / 2)) % 16)
		table.insert(foozBallsToChangeScaleOf, {NPC = npc, Scale = Vector(1,1)})
		
		local velLength = ((math.min(npcdata.revUp, PASS_BALL_REV_TO_MAX) / PASS_BALL_REV_TO_MAX) ^ PASS_BALL_REV_POW) * PASS_BALL_REV_MAX_VEL
		npc.Velocity = (targetPosition - npc.Position):Resized(velLength)
	end
	
	if npcdata.state == "Passing" then
		npc.Velocity = npc.Velocity:Resized(PASS_BALL_PASSING_VEL)
		
		if npc.Velocity:Length() < 3 then
			goto foozBallPassingEndOfAttack
		end
		
		if npcdata.pursueTarget == nil or
		   not npcdata.pursueTarget:Exists() or 
		   npcdata.pursueParity ~= ((npcdata.pursueTarget.Position.X - npc.Position.X) > 0) or
		   npc:CollidesWithGrid()
		then
			if npcdata.timesPassed >= PASS_LIMIT then
				npcdata.state = "PassEnd"
			else
				npcdata.state = "PassConnect"
				npcdata.passLerpFrames = 0
				
				local room = game:GetRoom()
				if (npcdata.passTarget == nil or 
				    not npcdata.passTarget:Exists()) and 
				   (npcdata.redTwin == nil or 
				    not npcdata.redTwin:Exists() or
				    npcdata.whiteTwin == nil or
				    not npcdata.whiteTwin:Exists())
				then
					goto foozBallPassingEndOfAttack
				elseif not room:CheckLine(npc.Position, npcdata.passTarget.Position, 0) then
					local leftTwin, rightTwin
					if npcdata.redTwin.Position.X < npcdata.whiteTwin.Position.X then
						leftTwin = npcdata.redTwin
						rightTwin = npcdata.whiteTwin
					else
						leftTwin = npcdata.whiteTwin
						rightTwin = npcdata.redTwin
					end
					
					if npc.Velocity.X > 0 then
						npcdata.passTarget = rightTwin
					else
						npcdata.passTarget = leftTwin
					end
				end
			end
			goto foozBallPassingStateSelect
		end
		
		if not mod:isConfuse(npc) then
			npcdata.passAngleCorrection = (npcdata.passAngleCorrection or 0)
			if npcdata.passAngleCorrection < PASS_MAX_ANGLE_CORRECTION then
				local velAngle = npc.Velocity:GetAngleDegrees()
				local targAngle = (npcdata.pursueTarget.Position - npc.Position):GetAngleDegrees()
				
				local angleDiffA = targAngle - velAngle
				local angleDiffB = (targAngle + 360) - velAngle
				local angleDiffC = targAngle - (velAngle + 360)
				
				local angleDiff
				if math.abs(angleDiffA) < math.abs(angleDiffB) and math.abs(angleDiffA) < math.abs(angleDiffC) then
					angleDiff = angleDiffA
				elseif math.abs(angleDiffB) < math.abs(angleDiffC) then
					angleDiff = angleDiffB
				else
					angleDiff = angleDiffC
				end
				
				local angleChange = math.min(PASS_MAX_ANGLE_CORRECTION_PER_FRAME, math.abs(angleDiff), PASS_MAX_ANGLE_CORRECTION - npcdata.passAngleCorrection)
				npcdata.passAngleCorrection = npcdata.passAngleCorrection + angleChange
				if angleDiff < 0 then angleChange = angleChange * -1 end
				npc.Velocity = npc.Velocity:Rotated(angleChange)
			end
		end
		
		local dir = nil
		if math.abs(npc.Velocity.X) > math.abs(npc.Velocity.Y) then
			if npc.Velocity.X > 0 then
				dir = "Right"
			else
				dir = "Left"
			end
		else
			if npc.Velocity.Y < 0 then
				dir = "Up"
			else
				dir = "Down"
			end
		end
		
		if npcdata.passRollFrame == nil then
			npcdata.passRollFrame = (math.floor((math.floor((npcdata.goadedRollFrame or 0) / ((PASS_BALL_REV_TO_MAX ^ PASS_BALL_REV_POW) / 2)) % 16) / 4) + 1) * 2
		else
			npcdata.passRollFrame = npcdata.passRollFrame + 1
		end
	
		sprite:Play("Roll" .. dir .. "Fast", true)
		sprite:SetFrame(npcdata.passRollFrame % 8)
		table.insert(foozBallsToChangeScaleOf, {NPC = npc, Scale = Vector(1,1)})
	end
	
	if npcdata.state == "PassConnect" then
		npc.Velocity = npc.Velocity:Resized(PASS_BALL_PASSING_VEL)
		
		if npcdata.passTarget == nil or not npcdata.passTarget:Exists() then
			goto foozBallPassingEndOfAttack
		end
		
		local targetPosition = npcdata.passTarget.Position
		local targetXDist = targetPosition.X - npc.Position.X
		local targetYDist = targetPosition.Y - npc.Position.Y
		
		local dir = nil
		if math.abs(targetXDist) > math.abs(targetYDist) then
			if targetXDist > 0 then
				dir = "Right"
			else
				dir = "Left"
			end
		else
			if targetYDist < 0 then
				dir = "Down"
			else
				dir = "Up"
			end
		end
		
		if npcdata.passRollFrame == nil then
			npcdata.passRollFrame = (math.floor((math.floor((npcdata.goadedRollFrame or 0) / ((PASS_BALL_REV_TO_MAX ^ PASS_BALL_REV_POW) / 2)) % 16) / 4) + 1) * 2
		else
			npcdata.passRollFrame = npcdata.passRollFrame + 1
		end
	
		sprite:Play("Roll" .. dir .. "Fast", true)
		sprite:SetFrame(npcdata.passRollFrame % 8)
		table.insert(foozBallsToChangeScaleOf, {NPC = npc, Scale = Vector(1,1)})
		
		local targvel = (targetPosition - npc.Position):Resized(PASS_BALL_PASSING_VEL)
		local lerpMulti = math.min(1, npcdata.passLerpFrames / PASS_BALL_PASSING_FULL_LERP_AT_FRAME)
		if npcdata.passLerpFrames > PASS_BALL_PASSING_FULL_LERP_AT_FRAME then
			lerpMulti = lerpMulti + (npcdata.passLerpFrames - PASS_BALL_PASSING_FULL_LERP_AT_FRAME) / PASS_BALL_EXTRA_FULL_LERP_EVERY_X_FRAMES
		end
		local lerp = math.min(0.5, PASS_BALL_PASSING_LERP * lerpMulti)
		npc.Velocity = mod:Lerp(npc.Velocity, targvel, lerp)
		npcdata.passLerpFrames = npcdata.passLerpFrames + 1
	end
	
	if npcdata.state == "PassEnd" then
		npcdata.passKickTimeout = nil
		
		local ignoreRollFrameUpdate = false
		if npcdata.idleRollFrame == nil then
			npcdata.idleRollFrame = (math.floor((npcdata.passRollFrame or 0) / 2) + 1) * 8
			ignoreRollFrameUpdate = true
		end
		
		npcdata.passEndTimer = (npcdata.passEndTimer or 0) + 1
		if npcdata.passEndTimer <= PASS_BALL_END_TIMER and npc.Velocity:Length() > 3 then
			mod:foozBallIdleAI(npc, sprite, npcdata, math.min((npcdata.passEndTimer / PASS_BALL_END_TIMER) ^ PASS_BALL_END_LERP_POW, 1), ignoreRollFrameUpdate)
		else
			goto foozBallPassingEndOfAttackNoTwinHandling
		end
	end
	
	goto foozBallPassingStateFinish
	
	::foozBallPassingEndOfAttack::
	
	if npcdata.redTwin and npcdata.redTwin:Exists() and mod:GetEntityData(npcdata.redTwin).currentAttack == FoozAttacks.PASSING_DRILL then
		mod:GetEntityData(npcdata.redTwin).passingState = "Finish"
	end
	if npcdata.whiteTwin and npcdata.whiteTwin:Exists() and mod:GetEntityData(npcdata.whiteTwin).currentAttack == FoozAttacks.PASSING_DRILL then
		mod:GetEntityData(npcdata.whiteTwin).passingState = "Finish"
	end
	
	::foozBallPassingEndOfAttackNoTwinHandling::
	
	npcdata.state = "Idle"
	npcdata.waitingToOrderAttack = BALL_ORDER_TIMER
	
	local ignoreRollFrameUpdate = false
	if npcdata.idleRollFrame == nil then
		if npcdata.passRollFrame ~= nil then
			npcdata.idleRollFrame = (math.floor(npcdata.passRollFrame / 2) + 1) * 8
			ignoreRollFrameUpdate = true
		elseif npcdata.goadedRollFrame ~= nil then
			npcdata.idleRollFrame = math.floor(npcdata.goadedRollFrame / ((PASS_BALL_REV_TO_MAX ^ PASS_BALL_REV_POW) / 2)) + 1
			ignoreRollFrameUpdate = true
		end
	end
	
	npcdata.goadTarget = nil
	npcdata.revUp = nil
	npcdata.goadedRollFrame = nil
	npcdata.passRollFrame = nil
	npcdata.passTarget = nil
	npcdata.pursueTarget = nil
	npcdata.pursueParity = nil
	npcdata.timesPassed = nil
	npcdata.passEndTimer = nil
	npcdata.passAngleCorrection = nil
	npcdata.passKickTimeout = nil
	npcdata.passLerpFrames = nil
	
	mod:foozBallIdleAI(npc, sprite, npcdata, nil, ignoreRollFrameUpdate)
	
	::foozBallPassingStateFinish::
end

function mod:foozBallGlobeAI(npc, sprite, npcdata)
	local balancer = npcdata.globeBalancer
	local balancerData = mod:GetEntityData(balancer)
	local balancerSprite = balancer:GetSprite()
	
	local updateVelInIdle = true
	
	if npcdata.state == "GlobeWait" then
		balancer.Position = npc.Position
		balancerData.waitingToBalance = nil
		
		if balancerSprite:IsFinished("RollVertStart") then
			npcdata.state = "GlobeChase"
		elseif balancerSprite:IsFinished("LongJumpDown") then
			balancerSprite:Play("RollVertStart", true)
			npc:PlaySound(SoundEffect.SOUND_MEAT_IMPACTS, 1.0, 0, false, (9.5 + math.random()) / 10)
		elseif not (balancerSprite:IsPlaying("LongJumpDown") or balancerSprite:IsPlaying("RollVertStart")) then
			balancerSprite:Play("LongJumpDown", true)
		end
	end
	
	if npcdata.state == "GlobeChase" or npcdata.state == "GlobeEnd" then
		local target = npc:GetPlayerTarget()
		if target.Index == balancer.Index and target.InitSeed == balancer.InitSeed then
			target = npcdata.globeBouncer
		end
		local targetVel = mod:reverseIfFear(npc, mod:confusePos(npc, target.Position) - npc.Position):Resized(GLOBE_BALL_MAX_VEL)
		
		balancer.Position = npc.Position
		balancerData.balancingLastBallVel = npc.Velocity
		
		local dir = nil
		if math.abs(targetVel.X) > math.abs(targetVel.Y) then
			if balancerSprite:IsEventTriggered("StartFall") then
				balancerData.balancingState = "Falling"
				if npc.Index > balancer.Index then
					balancer:Update()
				end
				
				npcdata.state = "Idle"
				goto foozBallGlobeEndOfAttack
			end
		
			if not (balancerSprite:IsPlaying("RollHoriLoop") or balancerSprite:IsPlaying("RollHoriStop")) then
				local frame = 0
				if balancerSprite:IsPlaying("RollVertLoop") or balancerSprite:IsPlaying("RollVertStop") then
					frame = balancerSprite:GetFrame()
				end
				
				local anim = "RollHoriLoop"
				if npcdata.state == "GlobeEnd" then
					anim = "RollHoriStop"
				end
				balancerSprite:Play(anim, true)
				balancerSprite:SetFrame(frame)
			end
			
			if targetVel.X > 0 then
				balancerSprite.FlipX = false
			else
				balancerSprite.FlipX = true
			end
		else
			if balancerSprite:IsEventTriggered("StartFall") then
				balancerData.balancingState = "Falling"
				if npc.Index > balancer.Index then
					balancer:Update()
				end
				
				npcdata.state = "Idle"
				goto foozBallGlobeEndOfAttack
			end
			
			if not (balancerSprite:IsPlaying("RollVertLoop") or balancerSprite:IsPlaying("RollVertStop")) then
				local frame = 0
				if balancerSprite:IsPlaying("RollHoriLoop") or balancerSprite:IsPlaying("RollHoriStop") then
					frame = balancerSprite:GetFrame()
				end
				
				local anim = "RollVertLoop"
				if npcdata.state == "GlobeEnd" then
					anim = "RollVertStop"
				end
				balancerSprite:Play(anim, true)
				balancerSprite:SetFrame(frame)
			end
			
			balancerSprite.FlipX = false
		end
		
		npc.Velocity = npc.Velocity * GLOBE_BALL_LERP + targetVel * (1 - GLOBE_BALL_LERP)
	end
	
	::foozBallGlobeEndOfAttack::
	
	mod:foozBallIdleAI(npc, sprite, npcdata, nil, nil, updateVelInIdle)
end

function mod:foozBallRender(npc)
	local sprite = npc:GetSprite()
	if sprite:IsPlaying("Death") then
		if sprite:IsEventTriggered("BloodStart") then
			sfx:Play(mod.Sounds.FoozTwinsDeath, 1, 0, false, 1)
		end
	end
end

mod:AddPriorityCallback(ModCallbacks.MC_POST_UPDATE, CallbackPriority.EARLY, function()
	for _, fooz in ipairs(foozBallsToChangeScaleOf) do
		if fooz.NPC and fooz.NPC:Exists() then
			fooz.NPC.SpriteScale = fooz.NPC.SpriteScale * fooz.Scale
		end
	end

	foozBallsToChangeScaleOf = {}
	
	for _, pushdata in ipairs(foozBallsToRebound) do
		local fooz = pushdata.Fooz
		local twin = pushdata.Twin
		
		--local mult = mod:getBasegameVelocityMultiplier(fooz)
		--fooz.Position = fooz.Position - fooz.Velocity * mult
		local angle = fooz.Velocity:GetAngleDegrees()
		if 60 < angle and angle < 90 then
			angle = 60
		elseif 90 <= angle and angle < 120 then
			angle = 120
		elseif -60 > angle and angle > -90 then
			angle = -60
		elseif -90 >= angle and angle > -120 then
			angle = -120
		elseif 0 < angle and angle < 20 then
			angle = 20
		elseif -20 < angle and angle <= 0 then
			angle = -20
		elseif 160 < angle and angle <= 180 then
			angle = 160
		elseif -180 <= angle and angle < -160 then
			angle = -160
		end
		fooz.Velocity = Vector.FromAngle(angle):Resized(CYCLONE_TWIN_TORNADO_PUSH_FORCE)
		--fooz.Position = fooz.Position + fooz.Velocity * mult
		
		mod:GetEntityData(fooz).tornadoPushedBy = mod:GetEntityData(fooz).tornadoPushedBy or {}
		table.insert(mod:GetEntityData(fooz).tornadoPushedBy, twin)
		mod:GetEntityData(fooz).tornadoPushLerpMultiFrames = CYCLONE_BALL_LERP_MULTI_FRAMES
		
		twin:PlaySound(mod.Sounds.FoozTwinsKick, 1.0, 0, false, (9 + math.random() * 2) / 10)
		twin:PlaySound(mod.Sounds.FoozTwinsCycloneBallHit, 1.1, 0, false, (9 + math.random() * 2) / 10)
		
		sfx:Play(SoundEffect.SOUND_MEATY_DEATHS, 0.5, 0, false, 1.4 + math.random() * 0.2)
		if (mod:GetEntityData(fooz).impactSoundCooldown or 0) <= 0 then 
			sfx:Play(mod.Sounds.FoozTwinsImpact, 0.8, 0, false, 0.90 + math.random() * 0.2)
			mod:GetEntityData(fooz).impactSoundCooldown = 30
		end
	end
	
	foozBallsToRebound = {}
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	foozBallsToChangeScaleOf = {}
end)

function mod:isFoozPartsOfDifferentBosses(npc1, npc2)
	if npc1.Type == mod.FF.FoozTwinRed.ID and npc1.Variant == mod.FF.FoozTwinRed.Var then
		if npc2.Type == mod.FF.FoozTwinRed.ID and npc2.Variant == mod.FF.FoozTwinRed.Var then
			if not (mod:GetEntityData(npc1).otherTwin and 
			        mod:GetEntityData(npc1).otherTwin.Index == npc2.Index and 
			        mod:GetEntityData(npc1).otherTwin.InitSeed == npc2.InitSeed)
			then
				return true
			end
		elseif npc2.Type == mod.FF.FoozTwinsBall.ID and npc2.Variant == mod.FF.FoozTwinsBall.Var then
			if not (npc1.Parent and 
			        npc1.Parent.Index == npc2.Index and 
			        npc1.Parent.InitSeed == npc2.InitSeed)
			then
				return true
			end
		end
	elseif npc1.Type == mod.FF.FoozTwinsBall.ID and npc1.Variant == mod.FF.FoozTwinsBall.Var then
		if npc2.Type == mod.FF.FoozTwinRed.ID and npc2.Variant == mod.FF.FoozTwinRed.Var then
			if not (npc2.Parent and 
			        npc2.Parent.Index == npc1.Index and 
			        npc2.Parent.InitSeed == npc1.InitSeed)
			then
				return true
			end
		elseif npc2.Type == mod.FF.FoozTwinsBall.ID and npc2.Variant == mod.FF.FoozTwinsBall.Var then
			return true
		end
	end
end

mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, function(_, npc, collider, low)
	if mod:isFoozPartsOfDifferentBosses(npc, collider) then
		return
	end
	
	if npc.Type == mod.FF.FoozTwinRed.ID and npc.Variant == mod.FF.FoozTwinRed.Var then
		local npcdata = mod:GetEntityData(npc)
		
		if npc.Parent and 
		   npc.Parent.Index == collider.Index and 
		   npc.Parent.InitSeed == collider.InitSeed and
		   not (mod:isDamagableByStatus(npc, collider) or mod:isDamagableByStatus(collider, npc)) and
		   not npcdata.cycloneState == "Tornado"
		then
			local ball = npc.Parent
			local balldata = mod:GetEntityData(ball)
			if balldata.state == "Passing" or balldata.state == "PassConnect" then
				return true
			end
		elseif npcdata.otherTwin ~= nil and
		       npcdata.otherTwin.Index == collider.Index and
			   npcdata.otherTwin.InitSeed == collider.InitSeed
		then
			if npcdata.cycloneState == "Jump" or npcdata.cycloneState == "DoubleBoost" or npcdata.cycloneState == "SlowDown" or npcdata.cycloneState == "Split" then
				return true
			end
		elseif collider.Type == mod.FFID.Boss and collider.Variant == mod.FF.FoozTwinsBall.Var then
			if npcdata.cycloneState == "Tornado" and mod:GetEntityData(collider).state ~= "PassGoad" then
				table.insert(foozBallsToRebound, {Fooz = collider, Twin = npc})
				npcdata.cycloneTargetingBallCooldown = -60
				npcdata.cycloneHasPushedBall = true
				
				npc.Velocity = (npc.Position - collider.Position):Resized(npc.Velocity:Length())
				collider.Velocity = (collider.Position - npc.Position):Resized(collider.Velocity:Length())
				return true
			end
		end
	elseif npc.Type == mod.FF.FoozTwinsBall.ID and npc.Variant == mod.FF.FoozTwinsBall.Var then
		local npcdata = mod:GetEntityData(npc)
		if npcdata.state == "Passing" or npcdata.state == "PassConnect" then
			if mod:GetEntityData(npc).redTwin and 
			   mod:GetEntityData(npc).redTwin.Index == collider.Index and 
			   mod:GetEntityData(npc).redTwin.InitSeed == collider.InitSeed  and
			   not (mod:isDamagableByStatus(npc, collider) or mod:isDamagableByStatus(collider, npc))
			then
				return true
			elseif mod:GetEntityData(npc).whiteTwin and 
				   mod:GetEntityData(npc).whiteTwin.Index == collider.Index and 
				   mod:GetEntityData(npc).whiteTwin.InitSeed == collider.InitSeed  and
				   not (mod:isDamagableByStatus(npc, collider) or mod:isDamagableByStatus(collider, npc))
			then
				return true
			end
		end
	end
end, mod.FFID.Boss)

mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function(_, npc, offset)
	if npc.Variant == mod.FF.FoozTwinsBall.Var and not npc:IsDead() then
		local npcdata = mod:GetEntityData(npc)
		if (npcdata.state == "GlobeWait" or npcdata.state == "GlobeChase" or npcdata.state == "GlobeEnd") and npcdata.globeBalancer and npcdata.globeBalancer:Exists() then
			local balancer = npcdata.globeBalancer
			local balancerData = mod:GetEntityData(balancer)
			local balancerSprite = balancer:GetSprite()
			
			balancerData.balancingLastSpriteOffset = Vector(0, -40) * npc.SpriteScale
			balancer.SpriteOffset = balancerData.balancingLastSpriteOffset
			
			local renderPosition = Isaac.WorldToRenderPosition(npc.Position + balancer.PositionOffset) + offset
			balancerSprite:Render(renderPosition)
			
			balancer.Position = npc.Position -- okay hear me out
		end
	end
end, mod.FFID.Boss)

mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, -1 * math.huge, function(_, npc, amount, flags, source, countdown)
	if npc.Variant == mod.FF.FoozTwinRed.Var and npc.Parent and npc.Parent.Type == mod.FFID.Boss and npc.Parent.Variant == mod.FF.FoozTwinsBall.Var then
		npc.Parent:TakeDamage(amount, flags, source, countdown)
		return false
	end
end, mod.FFID.Boss)

mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, math.huge, function(_, npc, amount, flags, source, countdown)
	if npc.Variant == mod.FF.FoozTwinsBall.Var then
		local npcdata = mod:GetEntityData(npc)
		
		if npcdata.redTwin and npcdata.redTwin:Exists() then
			mod:applyFakeDamageFlash(npcdata.redTwin)
		end
		
		if npcdata.whiteTwin and npcdata.whiteTwin:Exists() then
			mod:applyFakeDamageFlash(npcdata.whiteTwin)
		end
	end
end, mod.FFID.Boss)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
	local playCycloneSound = false
	local cycloneSoundVolume = 0
	local cycloneSoundPitch = 0
	
	local playRollingSound = false
	local rollingSoundVolume = 0
	local rollingSoundPitch = 0
	
	if not game:IsPaused() then
		local fooztwins = Isaac.FindByType(mod.FF.FoozTwinRed.ID, mod.FF.FoozTwinRed.Var)
		local foozballs = Isaac.FindByType(mod.FF.FoozTwinsBall.ID, mod.FF.FoozTwinsBall.Var)
		
		for _, twin in ipairs(fooztwins) do
			local data = mod:GetEntityData(twin)
			local cycloneState = data.cycloneState
			if not twin:IsDead() and twin.Parent and not twin.Parent:IsDead() and (cycloneState == "DoubleBoost" or cycloneState == "Tornado" or cycloneState == "SlowDown") then
				local mult = 1
				if cycloneState == "DoubleBoost" then
					mult = math.max(0, math.min(1, (data.cycloneSpiralFrames or 0) / CYCLONE_TWIN_TORNADO_STARTUP_FRAMES)) ^ 0.5
				elseif cycloneState == "SlowDown" then
					mult = math.max(0, math.min(1, (data.cycloneSpiralFrames or 0) / CYCLONE_TWIN_TORNADO_ENDING_FRAMES)) ^ 0.5
				end
				cycloneSoundVolume = math.max(cycloneSoundVolume, 0.3 * mult)
				cycloneSoundPitch = math.max(cycloneSoundPitch, 1.5 * mult)
				
				playCycloneSound = true
			end
		end
		
		for _, ball in ipairs(foozballs) do
			if not ball:IsDead() and (ball.Velocity:Length() >= 0.5 or mod:GetEntityData(ball).state == "PassGoad") then
				local maxSpeed = 3
				if mod:GetEntityData(ball).state == "PassGoad" then
					maxSpeed = PASS_BALL_REV_MAX_VEL
				end
				
				local mult = math.max(0.33, math.min(1, ball.Velocity:Length() / maxSpeed)) ^ 0.25
				rollingSoundVolume = math.max(rollingSoundVolume, 1.0 * mult)
				rollingSoundPitch = math.max(rollingSoundPitch, 0.5 * mult)
				
				playRollingSound = true
			end
		end
	end
	
	if playCycloneSound and not sfx:IsPlaying(mod.Sounds.FoozTwinsCyclone) then
		sfx:Play(mod.Sounds.FoozTwinsCyclone, cycloneSoundVolume, 0, true, cycloneSoundPitch)
	elseif playCycloneSound and sfx:IsPlaying(mod.Sounds.FoozTwinsCyclone) then
		sfx:AdjustVolume(mod.Sounds.FoozTwinsCyclone, cycloneSoundVolume)
		sfx:AdjustPitch(mod.Sounds.FoozTwinsCyclone, cycloneSoundPitch)
	elseif not playCycloneSound and sfx:IsPlaying(mod.Sounds.FoozTwinsCyclone) then
		sfx:Stop(mod.Sounds.FoozTwinsCyclone)
	end
	
	if playRollingSound and not sfx:IsPlaying(mod.Sounds.FoozTwinsRoll) then
		sfx:Play(mod.Sounds.FoozTwinsRoll, rollingSoundVolume, 0, true, rollingSoundPitch)
	elseif playRollingSound and sfx:IsPlaying(mod.Sounds.FoozTwinsRoll) then
		sfx:AdjustVolume(mod.Sounds.FoozTwinsRoll, rollingSoundVolume)
		sfx:AdjustPitch(mod.Sounds.FoozTwinsRoll, rollingSoundPitch)
	elseif not playRollingSound and sfx:IsPlaying(mod.Sounds.FoozTwinsRoll) then
		sfx:Stop(mod.Sounds.FoozTwinsRoll)
	end
end)

-- fix for meat cleaver royally screwing everything up
mod:AddPriorityCallback(ModCallbacks.MC_PRE_USE_ITEM, math.huge, function()
	local bosses = Isaac.FindByType(FiendFolio.FFID.Boss)
	for _, npc in ipairs(bosses) do
		if npc.Variant == mod.FF.FoozTwinRed.Var or npc.Variant == mod.FF.FoozTwinsBall.Var then
			local data = mod:GetEntityData(npc)
			
			data.FFMeatCleaverCachedNoTarget = npc:HasEntityFlags(EntityFlag.FLAG_NO_TARGET)
			data.FFMeatCleaverCachedCollisionClass = npc.EntityCollisionClass
			
			npc:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET)
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
		end
	end
end, CollectibleType.COLLECTIBLE_MEAT_CLEAVER)

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function()
	local bosses = Isaac.FindByType(FiendFolio.FFID.Boss)
	for _, npc in ipairs(bosses) do
		if npc.Variant == mod.FF.FoozTwinRed.Var or npc.Variant == mod.FF.FoozTwinsBall.Var then
			local data = mod:GetEntityData(npc)
			npc.EntityCollisionClass = data.FFMeatCleaverCachedCollisionClass or npc.EntityCollisionClass
			
			if data.FFMeatCleaverCachedNoTarget then
				npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
			end
		end
	end
end, CollectibleType.COLLECTIBLE_MEAT_CLEAVER)

mod:addCopyStatusHandler(FiendFolio.FF.FoozTwinRed.ID, FiendFolio.FF.FoozTwinRed.Var)
mod:addCopyStatusHandler(FiendFolio.FF.FoozTwinsBall.ID, FiendFolio.FF.FoozTwinsBall.Var)

-- fooz twins boss rush spawners
-- this is a bit silly but oh well
-- if only ambush.xml supported subtypes
function mod:foozBossRushPreSpawn(et, ev, es, pos, vel, sp, seed)
	if et == mod.FFID.Boss then
		if ev == mod.FF.FoozTwinsBewm.Var then
			return {mod.FF.FoozTwinRed.ID, mod.FF.FoozTwinRed.Var, mod.FF.FoozTwinRed.Sub, seed}
		elseif ev == mod.FF.FoozTwinsBoom.Var then
			return {mod.FF.FoozTwinWhite.ID, mod.FF.FoozTwinWhite.Var, mod.FF.FoozTwinWhite.Sub, seed}
		end
	end
end
