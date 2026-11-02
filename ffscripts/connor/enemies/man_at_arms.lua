local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local ZERO_VECTOR = Vector.Zero

local CHAIN_MAX_SINGLE_HIT_DAMAGE_PERCENT = 0.5
local CHAIN_SPACING = 12
local REEL_START_SPEED = 0.0
local REEL_ACCELERATION = 0.2
local DEFAULT_CHAIN_LENGTH = 125
local PULLED_STUN_DURATION = 10

function mod:ManAtArmsPreUpdate(man)
	if man.Variant ~= mod.FF.ManAtArms.Var then return end
	
	local data = mod:GetEntityData(man)
	local ball = man.Child and man.Child.Child
	
	if not ball then return end
	
	local gettingPulled = (((mod:GetEntityData(ball).ffManAtArmsBallStrength or 0) > 0) or data.ffManAtArmsFalling) and man.Position:Distance(ball.Position) > data.ffManAtArmsChainLength * 0.99
	
	if gettingPulled then
		data.ffManAtArmsPullCounter = PULLED_STUN_DURATION
	end
	
	if data.ffManAtArmsPullCounter and data.ffManAtArmsPullCounter > 0 then
		data.ffManAtArmsPullCounter = data.ffManAtArmsPullCounter - 1
		
		man.Velocity = mod:Lerp(man.Velocity, (man.Position - ball.Position):Resized(5), 0.05)
		
		local spr = man:GetSprite()
		if spr:GetAnimation() ~= "FallIn" then
			local dir = man.Position - ball.Position
			local anim = "Hori"
			if math.abs(dir.Y) > math.abs(dir.X) then
				anim = (dir.Y < 0) and "Up" or "Down"
			else
				spr.FlipX = (dir.X < 0)
			end
			if not spr:IsPlaying(anim) then
				spr:Play(anim, true)
			end
		end
		
		mod:ManAtArmsUpdate(man)
		return true
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.ManAtArmsPreUpdate, mod.FF.ManAtArms.ID)

local function FindBall(man)
	if game:GetRoom():GetFrameCount() > 1 then
		return
	end
	
	-- BasementRenevator bitwise stuff
	local idx = man.SubType & 15
	
	local ball
	local ballDist
	
	for _, foundBall in pairs(Isaac.FindByType(mod.FF.ManAtArmsBall.ID, mod.FF.ManAtArmsBall.Var)) do
		if not foundBall.Parent and foundBall.SubType == idx then
			local dist = man.Position:Distance(foundBall.Position)
			if not ball or not ballDist or dist < ballDist then
				ball = foundBall
				ballDist = dist
			end
		end
	end
	
	return ball
end

function mod:ManAtArmsUpdate(man)
	if man.Variant ~= mod.FF.ManAtArms.Var then return end
	
	local data = mod:GetEntityData(man)
	
	if not man:IsDead() and not data.ffManAtArmsInit then
		data.ffManAtArmsInit = true
		
		local chainLength = DEFAULT_CHAIN_LENGTH
		
		if man.SubType > 0 then
			-- BasementRenevator bitwise stuff
			chainLength = ((man.SubType >> 4) & 63) * 10
		end
		
		local ball = FindBall(man) or Isaac.Spawn(mod.FF.ManAtArmsBall.ID, mod.FF.ManAtArmsBall.Var, 0, man.Position + Vector(-5, -10), ZERO_VECTOR, man)
		local chain = Isaac.Spawn(mod.FF.ManAtArmsChain.ID, mod.FF.ManAtArmsChain.Var, 0, (man.Position + ball.Position)/2, ZERO_VECTOR, man)
		data.ffManAtArmsChainLength = math.max(chainLength, man.Position:Distance(ball.Position))
		
		man.Child = chain
		chain.Child = ball
		ball.Parent = chain
		chain.Parent = man
	end
	
	local chain = man.Child
	local ball = chain and chain.Child
	
	local spr = man:GetSprite()
	local anim = spr:GetAnimation()
	local overlay = ""
	
	if anim == "Up" or anim == "Down" or anim == "Hori" then
		overlay = "Head"..spr:GetAnimation()
	end
	
	if not chain or not chain:Exists() then
		if not data.ffManAtArmsBarked then
			data.ffManAtArmsBarked = true
			man:PlaySound(mod.Sounds.ManAtArmsExpose, 1.0, 0, false, 1.0)
		end
		overlay = overlay .. "_Exposed"
	end
	
	if spr:GetOverlayAnimation() ~= overlay then
		if overlay == "" then
			spr:RemoveOverlay()
		else
			spr:PlayOverlay(overlay, true)
		end
	end
	
	local ballFalling = ball and ball:Exists() and mod:GetEntityData(ball).ffManAtArmsBallFalling
	
	if not data.ffManAtArmsFalling and ballFalling then
		data.ffManAtArmsFalling = true
	end
	
	if data.ffManAtArmsFalling then
		if not ballFalling then
			data.ffManAtArmsFalling = false
			man.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
			return
		end
		man.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
		local targetPos = room:GetGridPosition(mod:GetEntityData(ball).ffManAtArmsBallFalling)
		if targetPos:Distance(man.Position) < 40 and spr:GetAnimation() ~= "FallIn" then
			spr:Play("FallIn")
			spr.FlipX = man.Velocity.X < 0
			man:PlaySound(mod.Sounds.ManAtArmsFall, 1.0, 0, false, 1.0)
		end
		if not man:IsDead() and spr:IsFinished("FallIn") then
			ball:Remove()
			chain:Remove()
			man.SplatColor = Color(1,1,1,0)
			man:Kill()
			Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 1, targetPos, Vector.Zero, man)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.ManAtArmsUpdate, mod.FF.ManAtArms.ID)

function mod:ManAtArmsTakeDamage(man, damage, damageFlags, damageSource)
	if man.Variant ~= mod.FF.ManAtArms.Var then return end
	
	if man.Child and man.Child:Exists() then
		return false
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CallbackPriority.EARLY, mod.ManAtArmsTakeDamage, mod.FF.ManAtArms.ID)

function mod:ManAtArmsChainTakeDamage(chain, damage, damageFlags, damageSource, damageCountdown)
	if chain.Variant ~= mod.FF.ManAtArmsChain.Var then return end
	
	local maxDamage = math.ceil(chain.MaxHitPoints * CHAIN_MAX_SINGLE_HIT_DAMAGE_PERCENT)
	
	if damage > maxDamage then
		chain:TakeDamage(maxDamage, damageFlags, damageSource, damageCountdown)
		return false
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CallbackPriority.EARLY, mod.ManAtArmsChainTakeDamage, mod.FF.ManAtArmsChain.ID)

function mod:ManAtArmsBallFix(ball)
	if ball.Variant ~= mod.FF.ManAtArmsBall.Var then return end
	
	ball.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS
	ball.I1 = 0
	ball.I2 = 0
end

function mod:ManAtArmsBallInit(ball)
	if ball.Variant ~= mod.FF.ManAtArmsBall.Var then return end
	
	mod:ManAtArmsBallFix(ball)
	mod:GetEntityData(ball).ffManAtArmsBallSpawnPos = ball.Position
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.ManAtArmsBallInit, mod.FF.ManAtArmsBall.ID)

function mod:ManAtArmsBallUpdate(ball)
	if ball.Variant ~= mod.FF.ManAtArmsBall.Var then return end
	
	local room = game:GetRoom()
	local ballData = mod:GetEntityData(ball)
	
	mod:ManAtArmsBallFix(ball)
	
	if ball.FrameCount == 0 and ballData.ffManAtArmsBallSpawnPos then
		ball.Position = ballData.ffManAtArmsBallSpawnPos
		ball.Velocity = Vector.Zero
	end
	
	if not ballData.ffManAtArmsBallFalling then
		local currentGridIdx = room:GetGridIndex(ball.Position)
		if currentGridIdx > -1 then
			local gridEntity = room:GetGridEntity(currentGridIdx)
			if gridEntity and gridEntity:ToPit() and gridEntity.CollisionClass == GridCollisionClass.COLLISION_PIT then
				ballData.ffManAtArmsBallFalling = currentGridIdx
			end
		end
	end
	
	if ballData.ffManAtArmsBallFalling then
		ball.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
		ball.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		
		local targetPos = room:GetGridPosition(ballData.ffManAtArmsBallFalling)
		ball.Velocity = (targetPos - ball.Position) * 0.1
		ball.Color = Color.Lerp(ball.Color, Color(0,0,0,0), 0.1)
		ball.Scale = ball.Scale * 0.9
		ball.PositionOffset = mod:Lerp(ball.PositionOffset, Vector(0, 50), 0.2)
	end
	
	local chain = ball.Parent
	if not chain or not chain:Exists() then
		--[[if game:GetRoom():IsClear() then
			ball:Kill()
		end]]
		return
	end
	local man = chain.Parent
	if not man or not man:Exists() then return end
	local manData = mod:GetEntityData(man)
	
	local dist = man.Position:Distance(ball.Position)
	
	if ballData.ffManAtArmsBallFalling then
		ballData.ffManAtArmsReelSpeed = (ballData.ffManAtArmsReelSpeed or REEL_START_SPEED) + REEL_ACCELERATION
		manData.ffManAtArmsChainLength = math.max(0, math.min(manData.ffManAtArmsChainLength, dist) - ballData.ffManAtArmsReelSpeed)
		ballData.ffManAtArmsBallStrength = 1.0
	elseif ballData.ffManAtArmsBallBuffer and ballData.ffManAtArmsBallBuffer > 0 then
		ballData.ffManAtArmsBallBuffer = ballData.ffManAtArmsBallBuffer - 1
	else
		ballData.ffManAtArmsBallStrength = math.max((ballData.ffManAtArmsBallStrength or 0) - 0.05, 0)
	end
	
	local chainLength = manData.ffManAtArmsChainLength
	
	if dist >= chainLength then
		local diff = dist - chainLength
		
		local velAngle = ball.Velocity:GetAngleDegrees() % 360
		local angleToMan = (man.Position - ball.Position):GetAngleDegrees() % 360
		local angleDiff = math.min(math.abs(angleToMan - velAngle), math.abs(velAngle - angleToMan))
		
		local speed = ball.Velocity:Length()
		local minSpeed = 0.5
		local maxSpeed = 1.5
		
		if speed > minSpeed and angleDiff >= 5 then
			if speed >= maxSpeed then
				ballData.ffManAtArmsBallStrength = 1
			else
				ballData.ffManAtArmsBallStrength = math.max(ballData.ffManAtArmsBallStrength, (speed - minSpeed) / (maxSpeed - minSpeed))
			end
		end
		
		local ballStrength = ballData.ffManAtArmsBallStrength or 0
		local manStrength = (1 - ballStrength)
		
		if not ballData.ffManAtArmsBallFalling then
			local ballTargetPos = man.Position + (ball.Position - man.Position):Resized(chainLength + ballStrength * diff)
			local ballTargetVel = ballTargetPos - ball.Position
			ball.Velocity = mod:Lerp(ball.Velocity, ballTargetVel, manStrength / 2)
		end
		
		local manTargetPos = ball.Position + (man.Position - ball.Position):Resized(chainLength + manStrength * diff)
		local manTargetVel = manTargetPos - man.Position
		man.Velocity = mod:Lerp(man.Velocity, manTargetVel, ballStrength / 2)
	end
	
	ballData.ffManAtArmsBallLastVel = ball.Velocity
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.ManAtArmsBallUpdate, mod.FF.ManAtArmsBall.ID)

function mod:ManAtArmsChainInit(chain)
	if chain.Variant ~= mod.FF.ManAtArmsChain.Var then return end
	
	chain.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
	chain.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
	chain.Visible = false
	chain:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	chain:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
	chain.SplatColor = Color(0,0,0,0)
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.ManAtArmsChainInit, mod.FF.ManAtArmsChain.ID)

local CHAIN_OFFSETS = {
	[Direction.UP] = Vector(0, 0),
	[Direction.DOWN] = Vector(0, -10),
	[Direction.LEFT] = Vector(-20, 0),
	[Direction.RIGHT] = Vector(20, 0),
}

local function GetChainPosOffset(man)
	local anim = man:GetSprite():GetAnimation()
	local dir = Direction.DOWN
	
	if anim == "Up" then
		dir = Direction.UP
	elseif anim == "Hori" then
		dir = man:GetSprite().FlipX and Direction.RIGHT or Direction.LEFT
	end
	
	return CHAIN_OFFSETS[dir] * man.Scale
end

local function GetBallHeight(ball)
	if mod:GetEntityData(ball).ffManAtArmsBallFalling then
		return 0
	end
	return ball.SpriteOffset.Y + ball.PositionOffset.Y
end

function mod:ManAtArmsChainUpdate(chain)
	if chain.Variant ~= mod.FF.ManAtArmsChain.Var then return end
	
	chain.Visible = false
	
	local data = mod:GetEntityData(chain)
	local ball = chain.Child
	local man = chain.Parent and chain.Parent:ToNPC()
	
	if not ball or not ball:Exists() or not man or not man:Exists() then
		chain:Die()
		return
	end
	
	local ballFalling = mod:GetEntityData(ball).ffManAtArmsBallFalling
	
	data.ffManAtArmsChainPosOffset = mod:Lerp((data.ffManAtArmsChainPosOffset or ZERO_VECTOR), GetChainPosOffset(man), 0.5)
	local startPos = man.Position + data.ffManAtArmsChainPosOffset
	local endPos = ball.Position
	
	local startOffset = Vector(0, -30) * man.Scale + man.SpriteOffset + man.PositionOffset
	local endOffset = ballFalling and Vector(0,0) or (ball.SpriteOffset + ball.PositionOffset)
	
	local dir = (endPos - startPos)
	local angle = dir:GetAngleDegrees()
	
	-- Buffer
	startPos = startPos + dir:Resized(-5)
	endPos = endPos + dir:Resized(-10)
	
	local fallingIn = (man:GetSprite():GetAnimation() == "FallIn")
	local dist = fallingIn and 0 or startPos:Distance(endPos)
	local visualAngle = ((startPos + startOffset) - (endPos + endOffset)):GetAngleDegrees()
	
	chain.Position = (ball.Position + man.Position) / 2
	chain.Velocity = ZERO_VECTOR
	chain.SpriteRotation = angle
	chain.SizeMulti = Vector(math.max((dist - man.Size - ball.Size) / (chain.Size*2), 1), 1)
	
	if not data.ffManAtArmsChainSegments then
		data.ffManAtArmsChainSegments = {}
	end
	local segments = data.ffManAtArmsChainSegments
	
	local i = 1
	while (i == 1 and not ballFalling) or i*CHAIN_SPACING < dist do
		if not segments[i] then
			segments[i] = Isaac.Spawn(mod.FF.ManAtArmsChainEffect.ID, mod.FF.ManAtArmsChainEffect.Var, mod.FF.ManAtArmsChainEffect.Sub, chain.Position, ZERO_VECTOR, chain):ToEffect()
			segments[i]:GetSprite():SetFrame((i % 2 == 0) and "Idle1" or "Idle2", 0)
		end
		segments[i].Position = startPos + dir:Resized(i*CHAIN_SPACING)
		segments[i].SpriteRotation = visualAngle
		segments[i].PositionOffset = mod:Lerp(startOffset, endOffset, (i*CHAIN_SPACING) / dist)
		
		i = i + 1
	end
	
	for j = #segments, i, -1 do
		segments[j]:Remove()
		segments[j] = nil
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.ManAtArmsChainUpdate, mod.FF.ManAtArmsChain.ID)

function mod:ManAtArmsChainBreak(chain)
	if chain.Variant ~= mod.FF.ManAtArmsChain.Var then return end
	
	sfx:Play(SoundEffect.SOUND_ANIMA_BREAK)
	
	if chain.Parent then
		chain.Parent.Child = nil
	end
	if chain.Child then
		chain.Child.Parent = nil
	end
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.ManAtArmsChainBreak, mod.FF.ManAtArmsChain.ID)

function mod:ManAtArmsChainEffectUpdate(eff)
	if eff.SubType ~= mod.FF.ManAtArmsChainEffect.Sub then return end
	
	if not eff.SpawnerEntity or not eff.SpawnerEntity:Exists() or eff.SpawnerEntity:IsDead() then
		Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CHAIN_GIB, 0, eff.Position, RandomVector() * mod:RandomInt(1,3), eff)
		eff:Remove()
		return
	end
	
	eff.Color = eff.SpawnerEntity:GetColor()
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.ManAtArmsChainEffectUpdate, mod.FF.ManAtArmsChainEffect.Var)
