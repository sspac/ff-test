local mod = FiendFolio
local game = Game()

local params = ProjectileParams()
params.Spread = 1.3

function mod:LarrikinAI(npc, sprite, data)
	local target = npc:GetPlayerTarget()
	local targetpos = mod:randomConfuse(npc, target.Position)
	local rand = npc:GetDropRNG()
	local room = game:GetRoom()
	
	if not data.init then
		data.state = "Idle"
		npc:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
		npc.StateFrame = -20
		data.init = true
	else
		npc.StateFrame = npc.StateFrame+1
	end

	if data.state == "Idle" then
		mod:spritePlay(sprite, "Shake")
		
		if not mod:isScareOrConfuse(npc) and room:CheckLine(npc.Position, targetpos, 3, 1, false, false) then
			if npc.StateFrame > 6 and mod:RandomInt(1, 30) == 1 then
				data.state = "Shoot"
				sprite:Play("Attack")
				data.shot = nil
			elseif npc.StateFrame > 90 then
				data.state = "Shoot"
				sprite:Play("Attack")
				data.shot = nil
			end
		end
	elseif data.state == "Shoot" then
		if sprite:IsFinished("Attack") then
			data.state = "Idle"
			npc.StateFrame = 0
			data.shot = nil
		elseif sprite:IsEventTriggered("Shoot") then
			local ran = mod:RandomInt(1,3)
			local poof = Isaac.Spawn(1000, 2, 5, npc.Position, npc.Velocity, npc):ToEffect()
			poof.SpriteOffset = Vector(0, -14)
			poof.DepthOffset = 14
			poof.Color = mod.ColorTelePurple
			--poof.SpriteScale = Vector(0.4, 0.4)
			poof:Update()
			npc:PlaySound(SoundEffect.SOUND_WEIRD_WORM_SPIT, 0.55, 0, false, 1.2)
			data.shot = true
			
			local projs = mod:FireProjectiles(npc, npc.Position, (target.Position-npc.Position):Resized(10), 2, params)
			local dist = target.Position:Distance(npc.Position)
			if dist < 120 then 
				dist = (120-dist)/240
			else
				dist = 0
			end
			local fallingaccel = 0+dist+mod:TrueRandomFloat(entrng)*0.1
			
			for i, proj in pairs(projs) do
				proj.FallingAccel = fallingaccel
				proj.FallingSpeed = 0
				local pSprite = proj:GetSprite()
				--proj.ProjectileFlags = proj.ProjectileFlags | ProjectileFlags.SMART
				--proj.HomingStrength = 0.35
				
				mod:makeCharmProj(npc, proj)
				mod:GetEntityData(proj).target = target
				--mod:GetEntityData(proj).psyclopia = true
				
				if i == ran then
					proj.Scale = 1.7
					proj.Parent = npc
					mod:GetEntityData(proj).projType = "psyclopia"
					mod:GetEntityData(proj).larrikin = true
					
					pSprite:Load("gfx/projectiles/projectile_psyclopia.anm2", true)
					  for i=0, room:GetFrameCount() % 61 do
						pSprite:Update()
					  end
					  mod:GetEntityData(proj).customProjSplat = "gfx/projectiles/projectile_psyclopia_splat.png"
				else
					proj.Color = mod.ColorDarkPurpleLarrikin
				end
				proj:Update()
			end
		end
	elseif data.state == "WarpOut" then
		npc.Velocity = Vector.Zero
		if sprite:IsFinished("TeleportUp") then
			npc:PlaySound(SoundEffect.SOUND_HELL_PORTAL2, 0.8, 0, false, 1.25)
			npc.Position = data.warpDest
			sprite:Play("TeleportDown")
			data.state = "WarpIn"
		end
	elseif data.state == "WarpIn" then
		npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.2)
		if sprite:IsFinished("TeleportDown") then
			data.state = "Idle"
			npc.StateFrame = 0
			data.warpDest = nil
		elseif sprite:IsEventTriggered("WarpIn") then
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
		end
	end
	
	if data.warpTime ~= nil then
		if room:GetGridCollisionAtPos(data.warpTime) == GridCollisionClass.COLLISION_NONE then
			data.state = "WarpOut"
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			sprite:Play("TeleportUp")
			sprite:RemoveOverlay()
			npc:PlaySound(SoundEffect.SOUND_HELL_PORTAL1, 0.8, 0, false, 1.25)
			data.warpDest = data.warpTime
			data.warpTime = nil
			data.warpVel = nil
		elseif room:GetGridCollisionAtPos(data.warpTime) ~= GridCollisionClass.COLLISION_PIT or room:GetGridCollisionAtPos(data.warpTime+data.warpVel:Resized(50)) ~= GridCollisionClass.COLLISION_PIT  then
			--[[local gridPos = room:GetGridPosition(room:GetGridIndex(data.warpTime))
			local newTarg = (data.warpTime-gridPos):Resized(50)+gridPos
			if room:GetGridCollisionAtPos(newTarg) == GridCollisionClass.COLLISION_NONE then
				data.state = "WarpOut"
				npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				sprite:Play("TeleportUp")
				sprite:RemoveOverlay()
				npc:PlaySound(SoundEffect.SOUND_HELL_PORTAL1, 0.8, 0, false, 1.25)
				data.warpDest = newTarg
				data.warpTime = nil
			else
				data.warpTime = nil
			end]]
			if room:GetGridCollisionAtPos(data.warpTime-data.warpVel:Resized(40)) == GridCollisionClass.COLLISION_NONE then
				data.state = "WarpOut"
				npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				sprite:Play("TeleportUp")
				sprite:RemoveOverlay()
				npc:PlaySound(SoundEffect.SOUND_HELL_PORTAL1, 0.8, 0, false, 1.25)
				data.warpDest = data.warpTime-data.warpVel:Resized(40)
				data.warpTime = nil
				data.warpVel = nil
			else
				data.warpTime = nil
				data.warpVel = nil
			end
		else
			data.warpTime = nil
			data.warpVel = nil
		end
	end
	
	if npc:IsDead() then
		for i=0,3 do
			local gibs = Isaac.Spawn(1000, 4, 0, npc.Position, RandomVector()*(math.random(10,120)/30), npc):ToEffect()
			local gSprite = gibs:GetSprite()
			gibs:Update()
			gSprite:SetFrame("rubble_alt", math.random(4))
			gSprite:ReplaceSpritesheet(0, "gfx/grid/rocks_chest.png")
			gSprite.Rotation = math.random(360)
			gSprite:LoadGraphics()
			gibs:Update()
		end
		npc:PlaySound(SoundEffect.SOUND_ANGEL_WING, 0.7, 0, false, 0.9)
	end
	
	npc.Velocity = npc.Velocity*0.7
end