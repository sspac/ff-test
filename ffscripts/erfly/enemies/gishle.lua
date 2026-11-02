local mod = FiendFolio
local game = Game()

local gishleBal = {
	speed = 5,
	speedSlow = 3.5,
	getOnDist = 60,
	scareDist = 60,
	scareFrames = 15,
	midairSpeed = 5,
	hopZVel = -3.5,
	jumpZVel = -8.6,

	bounceHeight = -11,
	xShotSpeed = 8,
}

local function FindTarBubbleGishle(npc) --edited so that it disregards eggs (spinneretch)
	local radius = 99999
	local target
	for _,ent in ipairs(Isaac.FindByType(mod.FF.TarBubble.ID, mod.FF.TarBubble.Var, -1, false, false)) do
		if ent.SubType ~= 1 then
			local can = npc.Pathfinder:HasPathToPos(ent.Position)
			local distance = npc.Position:Distance(ent.Position)
			if can and distance < radius and not mod:GetEntityData(ent).GishleTarget and not mod:GetEntityData(ent).LargeBubble then
				radius = distance
				target = ent
			end
		end
	end
	return target
end

function mod:gishleAI(npc)
	local sprite = npc:GetSprite()
	local d = mod:GetEntityData(npc)
	local target = npc:GetPlayerTarget()
	local playerPos = mod:randomConfuse(npc, target.Position)
	local rng = npc:GetDropRNG()
	local room = game:GetRoom()

	if not d.init then
		npc.SplatColor = mod.ColorDankBlackReal
		d.state = "Idle"
		d.tramp = FindTarBubbleGishle(npc)
		if d.tramp then
			mod:GetEntityData(d.tramp).GishleTarget = npc
		end
		d.init = true
	else
		npc.StateFrame = npc.StateFrame+1
	end

	if d.state == "Idle" then
		local trampolineSearch
		if mod:isScare(npc) or d.scareFrames then
			if d.scareFrames then
				if d.scareFrames > 0 then
					d.scareFrames = d.scareFrames-1
				else
					d.scareFrames = nil
				end
			end
			trampolineSearch = true
			npc.Velocity = mod:Lerp(npc.Velocity, (npc.Position-target.Position):Resized(gishleBal.speed), 0.3)
		elseif d.tramp and mod:superExists(d.tramp) then
			trampolineSearch = true
			local targetpos = mod:randomConfuse(npc, d.tramp.Position)

			if room:CheckLine(npc.Position, targetpos, 0, 1, false, false) then
				local targetvel = (targetpos - npc.Position):Resized(gishleBal.speed)
				npc.Velocity = mod:Lerp(npc.Velocity, targetvel, 0.3)
			else
				if npc.Pathfinder:HasPathToPos(target.Position, false) then
					npc.Pathfinder:FindGridPath(targetpos, gishleBal.speed/6.5, 900, true)
				else
					npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.3)
				end
			end

			if npc.Position:Distance(d.tramp.Position) < gishleBal.getOnDist then
				d.state = "HopOn"
			end
		else
			d.tramp = FindTarBubbleGishle(npc)
			if d.tramp then
				mod:GetEntityData(d.tramp).GishleTarget = npc
			end
		end

		if not trampolineSearch and not d.scareFrames then
			if npc.Position:Distance(target.Position) < gishleBal.scareDist then
				d.scareFrames = gishleBal.scareFrames
			end

			if not d.gishleWanderPos then
				d.gishleWanderPos = mod:FindRandomValidPathPosition(npc, nil, 60, 50, 120)
				npc.StateFrame = 0
			end
			local targetpos = mod:randomConfuse(npc, d.gishleWanderPos)
			if room:GetGridCollisionAtPos(npc.Position) > GridCollisionClass.COLLISION_NONE then
				local targetpos2 = mod:randomConfuse(npc, room:FindFreeTilePosition(npc.Position, 100))
				npc.Velocity = mod:Lerp(npc.Velocity, (targetpos2-npc.Position):Resized(gishleBal.speedSlow), 0.1)
			elseif npc.Position:Distance(targetpos) < 30 or npc.StateFrame > 30 then
				d.gishleWanderPos = mod:FindRandomValidPathPosition(npc, nil, 60, 50, 120)
				npc.StateFrame = 0
			elseif room:CheckLine(npc.Position, targetpos, 0, 1, false, false) then
				local targetvel = (targetpos - npc.Position):Resized(gishleBal.speedSlow)
				npc.Velocity = mod:Lerp(npc.Velocity, targetvel, 0.1)
			else
				if npc.Pathfinder:HasPathToPos(target.Position, false) then
					npc.Pathfinder:FindGridPath(targetpos, gishleBal.speedSlow/6.5, 900, true)
				else
					npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.1)
				end
			end
		end

		if npc.FrameCount % 6 == 0 then
			local splat = Isaac.Spawn(1000, EffectVariant.BLOOD_SPLAT, 0, npc.Position, Vector.Zero, npc):ToEffect()
			splat.Color = npc.SplatColor
			splat.SpriteScale = Vector(0.6, 0.6)
			splat:Update()
		end

		local numToAnim = {
			[0] = "WalkDown",
			[1] = "WalkLeft01",
			[2] = "WalkLeft02",
			[3] = "WalkUp",
			[4] = "WalkRight02",
			[5] = "WalkRight01",
		}
		local anim = math.floor(mod:GetAngleDegreesButGood(npc.Velocity:Rotated(-30))/60)
		mod:spritePlay(sprite, numToAnim[anim])

		if npc.PositionOffset.Y < 0 and not d.launchedEnemyInfo then
			d.launchedEnemyInfo = {zVel = 0, pos = true, collision = -40}
		end
	elseif d.state == "MidAir" then
	elseif d.state == "JumpAgain" then
		if sprite:IsFinished("JumpAgain") then
			d.state = "MidAir"
			local specFunction = function(ent, tab)
				if d.state == "MidAir" then
					if tab.zVel > -2 and not tab.gishleFalling then
						if sprite:IsFinished("AirTransition") then
							tab.gishleFalling = true
						else
							mod:spritePlay(sprite, "AirTransition")
						end
					elseif tab.zVel > 0 then
						mod:spritePlay(sprite, "InAir02")
					else
						mod:spritePlay(sprite, "InAir01")
					end
				end

				if d.tramp and mod:superExists(d.tramp) then
					npc.DepthOffset = d.tramp.DepthOffset+5
					npc.Velocity = mod:Lerp(npc.Velocity, (d.tramp.Position-npc.Position):Resized(gishleBal.midairSpeed), 0.3)

					if (npc.PositionOffset.Y+tab.zVel+tab.accel) >= gishleBal.bounceHeight and tab.gishleFalling then
						local result = tab.gishleFunc()
						if result then
							npc.PositionOffset = Vector(0, gishleBal.bounceHeight)
							d.launchedEnemyInfo = nil
						else
							d.tramp = nil
						end
					end
				elseif not tab.gishleFalling then
					d.tramp = FindTarBubbleGishle(npc)
					if d.tramp then
						mod:GetEntityData(d.tramp).GishleTarget = npc
					end
				end
				npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.3)
			end
			local landFuncCheck = function()
				if d.tramp and mod:superExists(d.tramp) and npc.Position:Distance(d.tramp.Position) < 30 then
					mod:GetEntityData(d.tramp).bounced = true
					d.tramp:GetSprite():Play("Boing", true)
					d.state = "JumpAgain"
					npc:PlaySound(mod.Sounds.BaloonBounce, 0.6, 0, false, mod:RandomInt(180,210,rng)/100)
					if rng:RandomInt(6) == 0 then
						npc:PlaySound(SoundEffect.SOUND_BABY_HURT, 0.8, 0, false, mod:RandomInt(90,110,rng)/100)
					end

					if not d.gishleShot then
						d.gishleShot = true
					else
						d.gishleShot = nil
					end
					
					local params = ProjectileParams()
					params.Variant = d.tramp.SubType == 10 and 3 or 0
					params.Color = (params.Variant == 3 and params.Color) or (d.tramp.SplatColor or mod.ColorDankBlackReal)
					for i=1,4 do
						local ang = 90*i
						if d.gishleShot then
							ang = ang+45
						end
						local vel = Vector(0,gishleBal.xShotSpeed):Rotated(ang)
						npc:FireProjectiles(d.tramp.Position, vel, 0, params)
					end
					params.FallingAccelModifier = 1.6
					--okay screw making it accurate, this doesn't work well for this purpose
					for i = 90, 360, 90 do
						params.FallingSpeedModifier = mod:RandomInt(-30,-5,rng)
						params.Scale = mod:RandomInt(5,8,rng)/10
						local vel = Vector(0,mod:RandomInt(23,45,rng)/10):Rotated(i+mod:RandomInt(-40,40,rng))
						npc:FireProjectiles(d.tramp.Position, vel, 0, params)
					end

					return true
				else
					d.state = "Land"
					d.tramp = nil
					npc:PlaySound(SoundEffect.SOUND_MEAT_IMPACTS, 1, 0, false, 1.3)
				end
			end
			local realLand = function()
				d.state = "Land"
				d.tramp = nil
				npc:PlaySound(SoundEffect.SOUND_MEAT_IMPACTS, 1, 0, false, 1.3)
				npc.DepthOffset = 0
			end
			d.launchedEnemyInfo = {zVel = gishleBal.jumpZVel, extraFunc = specFunction, gishleFunc = landFuncCheck, landFunc = realLand, pos = true, collision = -40}
		else
			mod:spritePlay(sprite, "JumpAgain")
		end

		npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.3)
	elseif d.state == "HopOn" then
		if sprite:IsFinished("Jump") then
			d.state = "MidAir"
		elseif sprite:IsEventTriggered("Jump") then
			local specFunction = function(ent, tab)
				if d.state == "MidAir" then
					if tab.zVel > -2 and not tab.gishleFalling then
						if sprite:IsFinished("AirTransition") then
							tab.gishleFalling = true
						else
							mod:spritePlay(sprite, "AirTransition")
						end
					elseif tab.zVel > 0 then
						mod:spritePlay(sprite, "InAir02")
					else
						mod:spritePlay(sprite, "InAir01")
					end
				end

				if d.tramp and mod:superExists(d.tramp) then
					npc.DepthOffset = d.tramp.DepthOffset+5
					npc.Velocity = mod:Lerp(npc.Velocity, (d.tramp.Position-npc.Position):Resized(gishleBal.midairSpeed), 0.3)

					if (npc.PositionOffset.Y+tab.zVel+tab.accel) >= gishleBal.bounceHeight and tab.gishleFalling then
						local result = tab.gishleFunc()
						if result then
							npc.PositionOffset = Vector(0, gishleBal.bounceHeight)
							d.launchedEnemyInfo = nil
						else
							d.tramp = nil
						end
					end
				elseif not tab.gishleFalling then
					d.tramp = FindTarBubbleGishle(npc)
					if d.tramp then
						mod:GetEntityData(d.tramp).GishleTarget = npc
					end
				end
				npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.3)
			end
			local landFuncCheck = function()
				if d.tramp and mod:superExists(d.tramp) and npc.Position:Distance(d.tramp.Position) < 30 then
					mod:GetEntityData(d.tramp).bounced = true
					d.tramp:GetSprite():Play("Boing", true)
					d.state = "JumpAgain"
					npc:PlaySound(mod.Sounds.BaloonBounce, 0.6, 0, false, mod:RandomInt(180,210,rng)/100)
					if rng:RandomInt(6) == 0 then
						npc:PlaySound(SoundEffect.SOUND_BABY_HURT, 0.8, 0, false, mod:RandomInt(90,110,rng)/100)
					end

					if not d.gishleShot then
						d.gishleShot = true
					else
						d.gishleShot = nil
					end
					
					local params = ProjectileParams()
					params.Variant = d.tramp.SubType == 10 and 3 or 0
					params.Color = (params.Variant == 3 and params.Color) or (d.tramp.SplatColor or mod.ColorDankBlackReal)
					for i=1,4 do
						local ang = 90*i
						if d.gishleShot then
							ang = ang+45
						end
						local vel = Vector(0,gishleBal.xShotSpeed):Rotated(ang)
						npc:FireProjectiles(d.tramp.Position, vel, 0, params)
					end
					params.FallingAccelModifier = 1.6
					--okay screw making it accurate, this doesn't work well for this purpose
					for i = 90, 360, 90 do
						params.FallingSpeedModifier = mod:RandomInt(-30,-5,rng)
						params.Scale = mod:RandomInt(5,8,rng)/10
						local vel = Vector(0,mod:RandomInt(23,45,rng)/10):Rotated(i+mod:RandomInt(-40,40,rng))
						npc:FireProjectiles(d.tramp.Position, vel, 0, params)
					end

					return true
				else
					d.state = "Land"
					d.tramp = nil
					npc:PlaySound(SoundEffect.SOUND_MEAT_IMPACTS, 1, 0, false, 1.3)
				end
			end
			local realLand = function()
				d.state = "Land"
				d.tramp = nil
				npc:PlaySound(SoundEffect.SOUND_MEAT_IMPACTS, 1, 0, false, 1.3)
				npc.DepthOffset = 0
			end
			d.launchedEnemyInfo = {zVel = gishleBal.jumpZVel, extraFunc = specFunction, gishleFunc = landFuncCheck, landFunc = realLand, pos = true, collision = -40}
		else
			mod:spritePlay(sprite, "Jump")
		end
		
		npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.3)
	elseif d.state == "Land" then
		if sprite:IsFinished("Land") then
			npc.StateFrame = 0
			d.state = "Idle"
		else
			mod:spritePlay(sprite, "Land")
		end

		npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.3)
	end
end