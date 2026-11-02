local mod = FiendFolio

--Originally music maker, to armillery, to compass
--I have to make this into an enemy after like an year of not looking at this and I'm so scared to change anything

local color = Color(1, 1, 1, 1)
color:SetColorize(1, 1, 1, 1)

local translucent1 = Color(1, 1, 1, 0.5)
translucent1:SetColorize(1, 1, 1, 1)

local translucent2 = Color(1, 1, 1, 0.1)
translucent2:SetColorize(1, 1, 1, 1)

local purewhite = Color(1, 1, 1, 0.5, 1, 1, 1)
purewhite:SetColorize(1, 1, 1, 1)

local params = ProjectileParams()
params.Color = color
params.BulletFlags = params.BulletFlags | ProjectileFlags.NO_WALL_COLLIDE
params.FallingSpeedModifier = 0
params.FallingAccelModifier = -0.1
params.Variant = 4

local safeRange = 50

function mod:CompassAI(npc)
	local sprite = npc:GetSprite()
	local d = mod:GetEntityData(npc)
	local rng = npc:GetDropRNG()

	if not d.init then
		d.init = true
		d.xAngle = 0.05
		d.yAngle = 0.05
		d.zAngle = 0.05
		d.radius = 300
		d.State = "Appear"
		npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
	else
		npc.StateFrame = npc.StateFrame+1
	end

	--[[if npc.StateFrame > 1 then
		if not d.sphereProjectiles then
			d.sphereProjectiles = {}

			for xSeg = 0, segments/2-0.5 do
				d.sphereProjectiles[xSeg] = {}
				for i=0,1 do
					local realxSeg = (xSeg+segments/2*i)+segments/3.35
					local x = d.radius*math.cos(2*math.pi*realxSeg/segments)
					local y = d.radius*math.sin(2*math.pi*realxSeg/segments)
					d.sphereProjectiles[xSeg][i] = Isaac.Spawn(9, 0, 0, npc.Position+Vector(x, y), Vector.Zero, nil):ToProjectile()
					d.sphereProjectiles[xSeg][i]:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
				end
			end
		end
		local radX = math.rad(d.xAngle)
		local radY = math.rad(d.yAngle)

		for xSeg,tab in pairs(d.sphereProjectiles) do
			for i=0,1 do
				local proj = tab[i]
				local realxSeg = (xSeg+segments/2*i)+segments/3.35
				local x = d.radius*math.cos(2*math.pi*realxSeg/segments)*math.cos(radX)
				local y = d.radius*math.sin(2*math.pi*realxSeg/segments)

				proj.FallingSpeed = -0.01
				proj.FallingAccel = -0.1
				proj.Velocity = (Vector(x,y)+npc.Position)-proj.Position
				if i == 1 then
					local z = math.sqrt(d.radius^2-x^2-y^2)
					proj.Scale = z/d.radius*math.sin(radX)+1
					proj.DepthOffset = math.sin(radX)+1
				else
					local z = math.sqrt(d.radius^2-x^2-y^2)
					--proj.Scale = z/80*math.cos(radX)
					proj.Scale = z/d.radius*(1-math.sin(radX))
					proj.DepthOffset = 1-math.sin(radX)
				end
			end
		end
		d.xAngle = d.xAngle+4
		d.yAngle = d.yAngle+4
	end]]
	--okay my angles are all crazy and wackyjob so here it is
	--xAngle is pure flat. rotates it like a pizza. yAngle is idk, I'm guessing left right. zAngle is what's left. How I'm going to do that, who knows.
	if d.Sphering then
		local segments = 8
		local angle = 360/segments
		if not d.sphereProjectiles then
			d.sphereProjectiles = {}
			for j = 1, segments/2 do -- ring layer
				d.sphereProjectiles[j] = {}
				for t=-1,1,2 do -- DOME
					local zTemp = math.cos(math.rad(angle*j))*d.radius*t
					local xTemp = math.sqrt(math.abs(d.radius^2-zTemp^2))
					local radius2 = math.sqrt(math.abs(d.radius^2-xTemp^2))

					d.sphereProjectiles[j][t] = {}
					if j == segments/4 then
						d.sphereProjectiles[j][t][1] = {}
						local x = math.cos(math.rad(angle))*radius2
						local y = math.sqrt(radius2^2-x^2)
						--local proj = Isaac.Spawn(9, 0, 0, npc.Position+Vector(x, y), Vector.Zero, nil):ToProjectile()
						local proj = npc:FireProjectilesEx(npc.Position+Vector(x,y), Vector.Zero, 0, params)[1]
						mod:GetEntityData(proj).projType = "musicMaker"
						mod:GetEntityData(proj).compassEnt = npc
						d.sphereProjectiles[j][t][1][1] = proj
					elseif j == segments/2 then
						if t == -1 then
							for i = 1, segments/2 do --the ring itself, divided by 2 into halves
								d.sphereProjectiles[j][t][i] = {}
								local x = math.cos(math.rad(angle*i))*radius2
								local y = math.sqrt(radius2^2-x^2)
				
								for s=-1,1,2 do
									local z = math.sqrt(d.radius^2-x^2-y^2)*t
									--local proj = Isaac.Spawn(9, 0, 0, npc.Position+Vector(x, y)*s, Vector.Zero, nil):ToProjectile()
									local proj = npc:FireProjectilesEx(npc.Position+Vector(x,y)*s, Vector.Zero, 0, params)[1]
									mod:GetEntityData(proj).projType = "musicMaker"
									mod:GetEntityData(proj).compassEnt = npc
									d.sphereProjectiles[j][t][i][s] = proj
								end
							end
						end
					else
						for i = 1, segments/2 do --the ring itself, divided by 2 into halves
							d.sphereProjectiles[j][t][i] = {}
							local x = math.cos(math.rad(angle*i))*radius2
							local y = math.sqrt(radius2^2-x^2)
			
							for s=-1,1,2 do
								local z = math.sqrt(d.radius^2-x^2-y^2)*t
								--local proj = Isaac.Spawn(9, 0, 0, npc.Position+Vector(x, y)*s, Vector.Zero, nil):ToProjectile()
								local proj = npc:FireProjectilesEx(npc.Position+Vector(x,y)*s, Vector.Zero, 0, params)[1]
								mod:GetEntityData(proj).projType = "musicMaker"
								mod:GetEntityData(proj).compassEnt = npc
								d.sphereProjectiles[j][t][i][s] = proj
							end
						end
					end
				end
			end
		end
		local xAng = math.rad(d.xAngle)
		local yAng = math.rad(d.yAngle)
		local zAng = math.rad(d.zAngle)
		for layer, tab2 in pairs(d.sphereProjectiles) do
			local zTemp = math.cos(math.rad(angle*layer))*d.radius
			local xTemp = math.sqrt(d.radius^2-zTemp^2)
			local radius3 = math.sqrt(d.radius^2-xTemp^2)

			for t=-1,1,2 do --AAAAAAAAAAAAAAAAAAAAAAAA
				for xSeg, tab in pairs(tab2[t]) do
					local xOrig = math.cos(math.rad(angle*xSeg))*radius3
					local radius2 = math.sqrt(radius3^2-xOrig^2)
					--local yOrig = math.sqrt(radius2^2-xOrig^2)
					local xX = math.sin(xAng)*xOrig-math.cos(xAng)*radius2
					local yX = math.cos(xAng)*xOrig+math.sin(xAng)*radius2

					for s=-1,1,2 do
						local zX = math.sqrt(math.abs(d.radius^2-xX^2-yX^2))*s
						if zX == 0 then
							zX = 0.01
						end
						local tempZ = zX+(math.tan(zAng)*xX)
						local zZ = math.cos(zAng)*tempZ
						if zAng == 90 then --failsafe..
							zZ = xX
						end
						--local xZOld = math.sqrt(math.abs(d.radius^2-zZ^2-yX^2))
						local xZ = math.tan(math.atan(xX/zX)-zAng)*zZ
						if zAng == 0 then --failsafe
							xZ = xX
						end
						tempZ = zZ+(math.tan(yAng)*yX)
						local zY = math.cos(yAng)*tempZ
						if zAng == 90 then --failsafe..
							zY = xX
						end
						local yZ = math.tan(math.atan(yX/zZ)-yAng)*zY
						if yAng == 0 then --failsafe
							yZ = yX
						end
	
						local proj = tab[s]
						if proj and proj:Exists() then
							proj.FallingSpeed = 0
							proj.FallingAccel = -0.1
		
							proj.Velocity = (npc.Position+Vector(xZ,yZ)*s*t)-proj.Position
							--proj.Position = (npc.Position+Vector(xZ,yX)*s)
							
							if s == 1 then
								proj.Scale = (zY*s*t+d.radius)/d.radius
								proj.DepthOffset = zY*s*t
								--proj.Color = Color(1, 1, 1, 1, 0, 1, 0)
							else
								proj.Scale = (zY*s*t+d.radius)/d.radius
								proj.DepthOffset = zY*s*t
							end

							if npc.StateFrame > safeRange then
								if zY*s*t < 0 then
									--GOHERE
									proj.Color = translucent2
									proj.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
									mod:GetEntityData(proj).musicMakerNoHit = true
								else
									proj.Color = color
									proj.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
									mod:GetEntityData(proj).musicMakerNoHit = nil
								end
							else
								if zY*s*t < 0 then
									proj.Color = translucent2
									mod:GetEntityData(proj).musicMakerNoHit = true
								else
									proj.Color = translucent1
									mod:GetEntityData(proj).musicMakerNoHit = true
								end
								proj.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
							end

						end
						--[[zZ = zZ*s
						if zZ > 40 then
							proj.Color = Color(1, 1, 1, 1, 0, 1, 0)
						elseif zZ > 0 then
							proj.Color = Color(1, 1, 1, 1, 0, 0.3, 0.6)
						elseif zZ > -40 then
							proj.Color = Color(1, 1, 1, 1, 0.6, 0, 0.3)
						else
							proj.Color = Color(1, 1, 1, 1, 1, 0, 0)
						end]]
					end
				end
			end

			--[[d.yAngle = d.yAngle+target.Velocity.Y
			d.zAngle = d.zAngle+target.Velocity.X
			if target:ToPlayer() then
				local player = target:ToPlayer()
				if Input.IsMouseBtnPressed(0) == true or not (player:GetShootingInput().X == 0 and player:GetShootingInput().Y == 0) then
					d.xAngle = d.xAngle+1
				end
			end]]

			if npc.StateFrame > safeRange then
				d.yAngle = d.yAngle+0.1
				d.xAngle = d.xAngle-0.1
				d.zAngle = d.zAngle+math.sin(math.rad(npc.FrameCount*0.4))*0.2

				if d.radius > 250 then
					d.radius = d.radius-0.12
				end
			end
		end
	end
	if d.State == "Idle" then
		mod:spritePlay(sprite, "Idle")
	elseif d.State == "Appear" then
		if sprite:IsFinished("Awaken") then
			d.State = "Idle"
		elseif sprite:IsEventTriggered("Sound") then
			npc:PlaySound(SoundEffect.SOUND_MEAT_JUMPS, 0.6, 0, false, mod:RandomInt(160,170,rng)/100)
			npc:PlaySound(SoundEffect.SOUND_ANGEL_BEAM, 0.5, 0, false, mod:RandomInt(160,170,rng)/100)
			d.Sphering = true
		else
			mod:spritePlay(sprite, "Awaken")
		end
	end

	if not d.isSpecturned then
		if not d.initPos then
			d.initPos = npc.Position
		end
		npc.Velocity = d.initPos-npc.Position
	else
		d.initPos = nil
	end
end

function mod:CompassProj(v, d)
	if d.projType == "musicMaker" then
		if not mod:superExists(d.compassEnt) then
			local afterimage = Isaac.Spawn(mod.FF.GenericAfterimage.ID, mod.FF.GenericAfterimage.Var, mod.FF.GenericAfterimage.Sub, v.Position, Vector.Zero, v):ToEffect()
        	mod:GetEntityData(afterimage).customAfterimageData = {
                timeout = 10, color = purewhite, fade = true, sprite = v:GetSprite(),
            }
            afterimage.Parent = v
            afterimage.PositionOffset = v.PositionOffset
            afterimage.SpriteOffset = v.SpriteOffset
            afterimage.SpriteScale = v.SpriteScale
            afterimage:Update()
        	v:Remove()
		end
	end
end

mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, function(_, proj, coll)
	local data = mod:GetEntityData(proj)
	if data.projType == "musicMaker" and coll:ToPlayer() and data.musicMakerNoHit then
		return true
	end
end, 4)