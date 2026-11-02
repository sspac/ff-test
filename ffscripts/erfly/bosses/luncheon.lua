local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero


-- HELPER STUFF:)
function mod:calculateDir(npc, vector)
	vector = vector or npc.Velocity
	local sprite = npc:GetSprite()
	local d = mod:GetEntityData(npc)
	local rotAMNT = 0.5

	if math.abs(vector.X) > math.abs(vector.Y) then
		d.dir = "Hori"
		if vector.X > 0 then
			sprite.FlipX = false
		else
			sprite.FlipX = true
		end
	else
		mod:GetEntityData(npc).dist = 27
		rotAMNT = 0.1
		if vector.Y > 0 then
			d.dir = "Down"
		else
			d.dir = "Up"
		end
	end
	local rot = (((vector:GetAngleDegrees() + 45) % 90) - 45) * rotAMNT
	if sprite.FlipX then
		rot = rot * -1
	end
	npc.SpriteRotation = rot
end



--LUNCHEON LUNCHEON LUNCHEON
--The fat fucker himself
function mod:luncheonAI(npc)
	local sprite = npc:GetSprite()
	local d = mod:GetEntityData(npc)

	if not d.init then
		d.init = true

		--Then regular init stuff for the fella
		npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
		mod.DeadWorms = 0 --Resets on a spawn
		d.state = "summon"
	else
		npc.StateFrame = npc.StateFrame + 1
	end

	npc.Velocity = npc.Velocity * 0.1

	if d.state == "idle" then
		if d.hurt then
			if not sprite:IsPlaying("Flinch") then
				sprite:Play("Flinch", false)
				npc:PlaySound(SoundEffect.SOUND_MONSTER_GRUNT_1,1,0,false,math.random(8,12)/10)
			end
		else
			mod:spritePlay(sprite, "Idle")
			mod.DeadWorms = mod.DeadWorms or 0
			if mod.DeadWorms > 1 then
                d.state = "shakey"
                d.sprayVec = 1
                mod.DeadWorms = mod.DeadWorms - 2
			end
			if npc.StateFrame > 30 and mod.GetEntityCount(mod.FF.Tapeworm.ID, mod.FF.Tapeworm.Var) < 4 then
				d.state = "summon"
			end
		end
		if sprite:IsFinished("Flinch") then
			d.hurt = false
		end
		mod.DeadWorms = mod.DeadWorms or 0
	elseif d.state == "summon" then
		d.hurt = false
		if sprite:IsFinished("Spit") then
			d.state = "idle"
		elseif sprite:IsEventTriggered("Spit") then
			npc:PlaySound(mod.Sounds.LuncheonVom, 1, 0, false, math.random(90,110)/100)
			local threatHead, threatBody, threatTail = -45 + math.random(0, 1) * 90, -45 + math.random(0, 1) * 90, -45 + math.random(0, 1) * 90
			for i = -45, 45, 90	 do
				local ball = Isaac.Spawn(mod.FF.WormBall.ID,mod.FF.WormBall.Var,0,npc.Position,Vector(0,8):Rotated(i),npc)
				ball:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				ball.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE


				local bd = mod:GetEntityData(ball)
				bd.Target = npc.Position + Vector(0,130):Rotated(i)

				local ballsprite = ball:GetSprite()
				bd.Color = {}
				for j = 0, 2 do
                    local rand
					if (j == 0 and i == threatHead) or (j == 1 and i == threatBody) or (j == 2 and i == threatTail) then
						rand = math.random(2)
					else
						rand = math.random(2) + 2
					end

					bd.Color[j + 1] = rand
					ballsprite:ReplaceSpritesheet(j, "gfx/bosses/luncheon/" .. mod.TapeColors[rand].anm2 .. "_segments_connected.png")
				end
				ballsprite:LoadGraphics()

				ball:Update()

			end

		elseif sprite:IsEventTriggered("Cronch") then
			npc:PlaySound(mod.Sounds.CronchyWorms, 2, 0, false, math.random(70,80)/100)
		elseif sprite:IsEventTriggered("Slurp") then
			npc:PlaySound(mod.Sounds.CartoonSlurp, 1, 0, false, math.random(50,70)/100)
		else
			mod:spritePlay(sprite, "Spit")
		end
	elseif d.state == "shakey" then
		d.hurt = false
		if sprite:IsFinished("Shake") then
			d.state = "idle"
		elseif sprite:IsEventTriggered("Shake") then
			Game():ShakeScreen(5)
			for _,egg in ipairs(Isaac.FindByType(mod.FF.TapewormEgg.ID, mod.FF.TapewormEgg.Var, -1, EntityPartition.ENEMY, true)) do
				mod:GetEntityData(egg).dying = true
			end
		elseif sprite:IsEventTriggered("Spray") then
			d.sprayVec = d.sprayVec * -1
			--npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT,1,2,false,1)


			local params = ProjectileParams()
			params.HeightModifier = -50
			for i = 1, 6 do
				local shotspeed = (Vector(5 * d.sprayVec, math.random(7,14)/2):Rotated(-70+math.random(140)))
				params.Scale = math.random(7, 10) / 10
				params.FallingSpeedModifier = -20 + math.random(10);
				params.FallingAccelModifier = 1.4 + math.random(10)/10;
				npc:FireProjectiles(npc.Position + shotspeed * 4, shotspeed, 0, params)
			end
		elseif sprite:IsEventTriggered("Swish") then
			npc:PlaySound(SoundEffect.SOUND_FETUS_JUMP, 1, 0, false, math.random(130,150)/100)
			Game():ShakeScreen(5)
		else
			mod:spritePlay(sprite, "Shake")
		end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, npc)
	if npc.Variant == mod.FF.Luncheon.Var and game:GetRoom():GetType() == RoomType.ROOM_BOSSRUSH then
		npc.Position = Vector(560, 255)
	end
end, mod.FF.Luncheon.ID)

--Tapeworm bollocks
mod.TapeColors = {
    [1] = {name = "pinky", color = Color(1,1,1,1,0,0,0), anm2 = "petunia"},
    [2] = {name = "redford", color = Color(2,0.5,0.5,1,0,0,0), anm2 = "greg"},
    [3] = {name = "whiteboi", color = Color(5,5,5,1,0,0,0), anm2 = "minkus"},
    [4] = {name = "slapbass", color = Color(0.1,0.1,0.1,1,0,0,0), anm2 = "boris"}
}



-- TAPEWORM!!!!!!!!!
function mod:CountTapewormDead()
    mod.DeadWorms = mod.DeadWorms or 0
    mod.DeadWorms = mod.DeadWorms + 1
    
    for _, luncheon in pairs(Isaac.FindByType(mod.FF.Luncheon.ID, mod.FF.Luncheon.Var, -1, false, false)) do
        luncheon:TakeDamage(25, DamageFlag.DAMAGE_CLONES, EntityRef(npc), 0)
        mod:GetEntityData(luncheon).hurt = true
    end
end

function mod:tapewormAI(npc, subt)
	local sprite = npc:GetSprite()
	local d = mod:GetEntityData(npc)
	local target = npc:GetPlayerTarget()
	if target.Type == mod.FF.Tapeworm.ID and target.Variant == mod.FF.Tapeworm.Var and mod:isInSegmentsOf(target, npc) then
		target = Isaac.GetPlayer(0)
	end
	local targetpos = mod:confusePos(npc, target.Position)
	local path = npc.Pathfinder
	local rotval = 0.5


	if not d.init then
		npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
		local rand = d.ColorID or math.random(4)
		--rand = 4
		if d.ColorID then
			d.landing = true
		end
		d.ColorID = rand
		d.Color = mod.TapeColors[rand].name
		--npc.Color = mod.TapeColors[rand].color
		if npc.Parent or npc.Child then
			sprite:ReplaceSpritesheet(0, "gfx/bosses/luncheon/" .. mod.TapeColors[rand].anm2 .. "_segments_connected.png")
			d.hasAltSpritesheet = true
		else
			sprite:ReplaceSpritesheet(0, "gfx/bosses/luncheon/" .. mod.TapeColors[rand].anm2 .. "_segments.png")
		end
		sprite:LoadGraphics()
		d.init = true
	else
		npc.StateFrame = npc.StateFrame + 1
	end

	d.dist = 37
	if npc.Velocity:Length() > 0.1 then
		mod:calculateDir(npc)
	else
		--sprite:SetFrame("Head_Hori", 0)
		d.dir = "Hori"
	end

	if d.AAAHELP then
		d.shootcount = d.shootcount or 0
		d.shootcount = d.shootcount + 1

		npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT,1,2,false,1)
		local params = ProjectileParams()
		local shotspeed = ((target.Position - npc.Position)*0.04):Rotated(-10+math.random(20))
		shotspeed = shotspeed:Resized(6)
		params.Scale = math.random(2, 10) / 10
		params.FallingSpeedModifier = -20 + math.random(10);
		params.FallingAccelModifier = 1.1 + math.random(2)/10;
		params.HeightModifier = 20
		params.Variant = 4
		npc:FireProjectiles(npc.Position, shotspeed, 0, params)

		if d.shootcount > 6 then
			d.AAAHELP = false
			d.shootcount = 0
		end
	end

	if mod:isLeavingStatusCorpse(npc) then
		mod:CountTapewormDead()
	end

	if npc.Parent and mod:isLeavingStatusCorpse(npc.Parent) then
		npc.Parent = nil
	end

	if npc.Child and mod:isLeavingStatusCorpse(npc.Child) then
		npc.Child = nil
	end

	--Spawn a completely random one
	if subt == 0 then
		npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		if npc.StateFrame == 1 then
			--TODO : MAKE THIS LESS SHIT
			local head = Isaac.Spawn(mod.FF.Tapeworm.ID, mod.FF.Tapeworm.Var, 1, npc.Position, nilvector, npc)
			local body = Isaac.Spawn(mod.FF.Tapeworm.ID, mod.FF.Tapeworm.Var, 2, npc.Position, nilvector, npc)
			local tail = Isaac.Spawn(mod.FF.Tapeworm.ID, mod.FF.Tapeworm.Var, 3, npc.Position, nilvector, npc)


			head.Child = body
			body.Parent = head
			body.Child = tail
			tail.Parent = body

			head.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			body.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			tail.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			npc:Remove()
		end



	--Head
	elseif subt == 1 then
		npc.RenderZOffset = 400
		if d.landing then
			if sprite:IsFinished("Head_Land") then
				d.landing = false
			else
				mod:spritePlay(sprite, "Head_Land")
			end
			npc.Velocity = npc.Velocity * 0.9
		elseif npc.Child and mod:GetEntityData(npc.Child).egglaying then
			mod:spritePlay(sprite, "EggLay_Head")
			npc.Velocity = mod:SnapVector(npc.Velocity * 0.9, 180)
		else
			if not npc.Child and d.hasAltSpritesheet then
				d.hasAltSpritesheet = false
				sprite:ReplaceSpritesheet(0, "gfx/bosses/luncheon/" .. mod.TapeColors[d.ColorID].anm2 .. "_segments.png")
				sprite:LoadGraphics()
			end
			if d.chargetell then
				if sprite:IsFinished("ChargeTell_Head_" .. d.lastdir) then
					d.chargetell = false
				elseif sprite:IsEventTriggered("Charge") then
					d.chargin = true
					npc:PlaySound(SoundEffect.SOUND_MONSTER_ROAR_0,1,2,false,math.random(13,15)/10)
				else
					mod:spritePlay(sprite, "ChargeTell_Head_" .. d.lastdir)
				end
			elseif d.chargin then
				mod:spritePlay(sprite, "Charge_Head_" .. d.dir)
			else
				sprite:SetFrame("Head_" .. d.dir, npc.FrameCount % 19)
				if npc.FrameCount % 19 == 10 then
					npc:PlaySound(mod.Sounds.WormScoot, 0.2, 0, false, math.random(97,103)/100)
				end
			end

			if d.Color == "pinky" then
				--local targvel = (target.Position - npc.Position):Resized(5)
				--npc.Velocity = mod:Lerp(npc.Velocity, targvel, 0.07):Rotated(math.sin((npc.InitSeed + npc.FrameCount) / 7) * 3)
				if npc.FrameCount % 19 == 10 then
					d.rot = d.rot or 30
					d.rot = d.rot * -1
					local targvel = (targetpos - npc.Position):Resized(15):Rotated(d.rot)
					npc.Velocity = mod:Lerp(npc.Velocity, targvel, 0.5)
				else
					npc.Velocity = npc.Velocity * 0.95
				end
			elseif d.Color == "redford" then
				if d.chargin then
					npc.Velocity = d.chargevel:Resized(15)
					if npc:CollidesWithGrid() then
						d.chargin = false
						npc.StateFrame = 0
					end
				elseif d.chargetell then
					npc.Velocity = npc.Velocity * 0.9
				else
					local targvel = (targetpos - npc.Position):Resized(2)
					npc.Velocity = mod:Lerp(npc.Velocity, targvel, 0.7)
					if npc.StateFrame > 15 and math.random(10) == 1 and not mod:isScareOrConfuse(npc) then
						d.chargetell = true
						mod:calculateDir(npc)
						d.lastdir = d.dir
						d.chargevel = npc.Velocity
					end
				end
			elseif d.Color == "whiteboi" then
				local pdist = target.Position:Distance(npc.Position)
				if (pdist < 200 and Game():GetRoom():CheckLine(target.Position,npc.Position,3,900,false,false)) then
					npc.Velocity = mod:Lerp(npc.Velocity, (target.Position - npc.Position):Resized(-3 - ((200 - pdist) / 100)), 0.15)
					npc.StateFrame = 161
				else
					if npc.StateFrame > 160 or not d.walktarg then
						--Find a random position in the room to walk to
						local validPositions = {}
						local room = Game():GetRoom()
						local size = room:GetGridSize()
						for i=0, size do
							local gridpos = room:GetGridPosition(i)
							if path:HasPathToPos(gridpos, false) and not room:GetGridEntity(i) then
								table.insert(validPositions, gridpos)
							end
						end
						if #validPositions > 0 then
							d.walktarg = validPositions[math.random(#validPositions)]
						else
							d.walktarg = npc.Position
						end
						npc.StateFrame = 0
					end
					if npc.Position:Distance(d.walktarg) > 30 then
						if Game():GetRoom():CheckLine(npc.Position,d.walktarg,0,1,false,false) then
							local targetvel = (d.walktarg - npc.Position):Resized(2)
							npc.Velocity = mod:Lerp(npc.Velocity, targetvel,0.2)
						else
							path:FindGridPath(d.walktarg, 0.2, 900, true)
						end
					else
						d.walktarg = nil
					end
				end
			elseif d.Color == "slapbass" then
				if npc.FrameCount % 19 == 10 then
					local targvel = (targetpos - npc.Position):Resized(15)
					if math.random(2) == 1 or mod:isConfuse(npc) then
						targvel = RandomVector()*15
					end
					npc.Velocity = mod:Lerp(npc.Velocity, targvel, 0.5)
				end
				npc.Velocity = npc.Velocity * 0.9
			end
		end


	--Body
	elseif subt == 2 then
		npc.RenderZOffset = -300 --Enables datamining features
		local creeppos = npc.Position

		--Follow parent
		if npc.Parent then

			if mod:GetEntityData(npc.Parent).Color == "whiteboi" then
				if d.dir == "Down" then
					d.dist = d.dist - 15
				elseif d.dir == "Up" then
					d.dist = d.dist - 10
				end
			end

			creeppos = npc.Parent.Position
			--npc.Position = npc.Parent.Position - mod:SnapVector(npc.Parent.Velocity:Resized(dist), 90)
			local parentvel = mod:SnapVector(npc.Parent.Velocity, 90):Rotated((((npc.Parent.Velocity:GetAngleDegrees() + 45) % 90) - 45) * rotval)
			npc.Position = mod:Lerp(npc.Position, (npc.Parent.Position - parentvel:Resized(d.dist)), 0.6)
			npc.Velocity = mod:Lerp(npc.Velocity, parentvel, 0.6)


		--Or if parent is dead
		else
			if not npc.Parent and d.hasAltSpritesheet then
				d.hasAltSpritesheet = false
				sprite:ReplaceSpritesheet(0, "gfx/bosses/luncheon/" .. mod.TapeColors[d.ColorID].anm2 .. "_segments.png")
				sprite:LoadGraphics()
			end

			local speed, friction, randChance, maxRotation = 15, 0.9, .5, 50
			if d.Color == "pinky" then
				friction = 0.95
				randChance = .25
				maxRotation = 30
			elseif d.Color == "redford" then
				randChance = 0
			elseif d.Color == "whiteboi" then
				randChance = .75
				maxRotation = 0
				friction = 0.85
				speed = 20
			end

			if npc.FrameCount % 19 == 10 then
				local targvel = (target.Position - npc.Position):Resized(speed):Rotated(math.random(-maxRotation, maxRotation))
				if math.random() < randChance then
					targvel = RandomVector()*speed
				end
				npc.Velocity = mod:Lerp(npc.Velocity, targvel, 0.5)
			end
			npc.Velocity = npc.Velocity * friction

		end

		local creepPeriod = 5

		--Animation
		if d.landing then
			if sprite:IsFinished("Body_Land") then
				d.landing = false
			else
				mod:spritePlay(sprite, "Body_Land")
			end
			npc.Velocity = npc.Velocity * 0.9
		elseif npc.Child and mod:GetEntityData(npc.Child).egglaying then
			mod:spritePlay(sprite, "EggLay_Body")
			d.egglaying = true
		elseif npc.Parent and mod:GetEntityData(npc.Parent).chargetell then
			d.egglaying = false
			local pd = mod:GetEntityData(npc.Parent)
			d.chargetell = true
			d.lastdir = pd.lastdir
			mod:spritePlay(sprite, "ChargeTell_Body_" .. pd.lastdir)
		elseif npc.Parent and mod:GetEntityData(npc.Parent).chargin then
			d.egglaying = false
			d.dist = d.dist + 5
			d.chargetell = false
			d.chargin = true
			creepPeriod = 2
			mod:spritePlay(sprite, "Charge_Body_" .. d.dir)
		else
			d.chargetell = false
			d.egglaying = false
			d.chargin = false
			sprite:SetFrame("Body_" .. d.dir, npc.FrameCount % 19)
		end
		--Body effects
		if d.Color == "pinky" then
			if npc.FrameCount % creepPeriod == 1 then
				local creep = Isaac.Spawn(1000, 22, 0, npc.Position, nilvector, npc):ToEffect();
				creep.Color = Color(10,15,15,1,0,0,0)
				creep.SpriteRotation = npc.SpriteRotation
				creep:SetTimeout(30)
				creep:Update()
			end
		elseif d.Color == "redford" then
			local amount = 20
			if d.chargin then amount = 5 end
			if npc.FrameCount % amount == 1 then
				local params = ProjectileParams()
				params.FallingAccelModifier = -0.05
				params.FallingSpeedModifier = 0
				npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT,1,2,false,1)
				npc:FireProjectiles(npc.Position, nilvector, 0, params)
			end
		elseif d.Color == "whiteboi" then
			--aahelp at the start
		elseif d.Color == "slapbass" then
			if npc.FrameCount % creepPeriod == 1 then
				local creep = Isaac.Spawn(1000, 26, 0, npc.Position, nilvector, npc):ToEffect();
				creep.SpriteRotation = npc.SpriteRotation
				creep:SetTimeout(50)
				creep:Update()
			end
		end


	--ASSSSSSSS
	elseif subt == 3 then
		npc.RenderZOffset = -600
		d.dist = d.dist - 5
		if d.landing then
			if sprite:IsFinished("Tail_Land") then
				d.landing = false
			else
				mod:spritePlay(sprite, "Tail_Land")
			end
			npc.Velocity = npc.Velocity * 0.9
		elseif d.egglaying then
			if sprite:IsFinished("EggLay_Tail") then
				d.egglaying = false
				npc.StateFrame = 0
			elseif sprite:IsEventTriggered("Spawn") then
				npc:PlaySound(SoundEffect.SOUND_PLOP,0.7,2,false,1.07)
				local egg = Isaac.Spawn(mod.FF.TapewormEgg.ID, mod.FF.TapewormEgg.Var, d.ColorID, npc.Position + npc.Velocity:Resized(-50), nilvector, npc):ToNPC();
				egg:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				egg:GetSprite():Play("Appear", true)
				if sprite.FlipX then
					egg:GetSprite().FlipX = true
				end
				egg:Update()
			else
				mod:spritePlay(sprite, "EggLay_Tail")
			end
		elseif npc.Parent and mod:GetEntityData(npc.Parent).chargetell then
			local pd = mod:GetEntityData(npc.Parent)
			d.chargetell = true
			d.lastdir = pd.lastdir
			mod:spritePlay(sprite, "ChargeTell_Tail_" .. pd.lastdir)
		elseif npc.Parent and mod:GetEntityData(npc.Parent).chargin then
			d.dist = d.dist + 5
			d.chargetell = false
			d.chargin = true
			mod:spritePlay(sprite, "Charge_Tail_" .. d.dir)
		else
			sprite:SetFrame("Tail_" .. d.dir, npc.FrameCount % 19)
			if npc.Parent then
				if npc.StateFrame > 15 and math.random(25) == 1 and d.dir == "Hori" and (not d.egglaying) and Game():GetRoom():GetGridCollisionAtPos(npc.Position + npc.Velocity:Resized(-50)) == GridCollisionClass.COLLISION_NONE and mod.GetEntityCount(mod.FF.Luncheon.ID, mod.FF.Luncheon.Var) > 0 and mod.GetEntityCount(mod.FF.TapewormEgg.ID, mod.FF.TapewormEgg.Var, d.ColorID) < 1 then
					d.egglaying = true
				end
			else
				local speed, friction, randChance, maxRotation = 6, 0.92, .5, 180
				if d.Color == "pinky" then
					friction = 0.95
					randChance = .4
					maxRotation = 60
					speed = 7.5
				elseif d.Color == "redford" then
					randChance = .2
					friction = .9
				elseif d.Color == "whiteboi" then
					randChance = .85
					maxRotation = 0
					friction = 0.85
					speed = 4
				end

				if npc.FrameCount % 19 == 10 then
					local targvel = (target.Position - npc.Position):Resized(speed):Rotated(math.random(-maxRotation, maxRotation))
					if math.random() < randChance then
						targvel = RandomVector()*speed
					end
					npc.Velocity = targvel
				end
				npc.Velocity = npc.Velocity * friction
			end
		end



		if npc.Parent then
			--npc.Position = npc.Parent.Position - mod:SnapVector(npc.Parent.Velocity:Resized(dist), 90)
			local parentvel = mod:SnapVector(npc.Parent.Velocity, 90):Rotated((((npc.Parent.Velocity:GetAngleDegrees() + 45) % 90) - 45) * rotval)
			npc.Position = mod:Lerp(npc.Position, (npc.Parent.Position - parentvel:Resized(d.dist)), 0.6)
			npc.Velocity = mod:Lerp(npc.Velocity, parentvel, 0.6)


		else
			if not npc.Parent and d.hasAltSpritesheet then
				d.hasAltSpritesheet = false
				sprite:ReplaceSpritesheet(0, "gfx/bosses/luncheon/" .. mod.TapeColors[d.ColorID].anm2 .. "_segments.png")
				sprite:LoadGraphics()
			end
		end
		local rot = (((npc.Velocity:GetAngleDegrees() + 45) % 90) - 45) * rotval
		if sprite.FlipX then
			rot = rot * -1
		end
		npc.SpriteRotation = rot
	end
end

function mod:tapewormDeath(npc, subt)
    mod:CountTapewormDead()
end

function mod:tapewormRemoveAI(npc, subt)
	if npc.FrameCount == 0 then
		if npc.SpawnerEntity and npc.SpawnerEntity.FrameCount > 0 then
			for _, luncheon in pairs(Isaac.FindByType(mod.FF.Luncheon.ID, mod.FF.Luncheon.Var, -1, false, false)) do
				if not mod:GetEntityData(luncheon).spawnInsignia then
					mod:GetEntityData(luncheon).spawnInsignia = true
					Isaac.Spawn(5, 100, FiendFolio.ITEM.COLLECTIBLE.WORM_INSIGNIA, luncheon.Position + Vector(0,-5), nilvector, luncheon)
				end
				luncheon:TakeDamage(1000, DamageFlag.DAMAGE_CLONES, EntityRef(npc), 0)
				mod:GetEntityData(luncheon).hurt = true
			end
		end
	end
end

mod:addCopyStatusHandler(FiendFolio.FF.Tapeworm.ID, FiendFolio.FF.Tapeworm.Var)



-- TAPEWORM (EGG)!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
function mod:tapewormEggAI(npc, subt)
	local sprite = npc:GetSprite()
	local d = mod:GetEntityData(npc)
	local target = npc:GetPlayerTarget()

	if not d.init then
		npc.RenderZOffset = -750
		npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
		d.init = true
	else
		npc.StateFrame = npc.StateFrame + 1
	end

	if subt == 0 then
		npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		if npc.StateFrame == 1 then
			local rand = math.random(4)
			local egg = Isaac.Spawn(mod.FF.TapewormEgg.ID, mod.FF.TapewormEgg.Var, rand, npc.Position, nilvector, npc):ToNPC();
			egg:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			egg:GetSprite():Play("Appear", true)
			egg:Update()
			npc:Remove()
		end
	end

	npc.Velocity = npc.Velocity * 0.8

	if d.dying or mod.GetEntityCount(mod.FF.Luncheon.ID, mod.FF.Luncheon.Var) < 1 then
		if sprite:IsFinished("Death") or sprite:IsEventTriggered("Explode") then
			npc:BloodExplode()
			npc:Remove()
		else
			mod:spritePlay(sprite, "Death")
		end
	else
		if not d.appeared then
			if sprite:IsFinished("Appear") then
				d.appeared = true
				d.state = "idle"
			else
				mod:spritePlay(sprite, "Appear")
			end
		else
			--Petunia
			if subt == 1 then
				if d.state == "idle" then
					mod:spritePlay(sprite, "Idle")
					if npc.StateFrame > 30 and math.random(5) == 1 then
						d.state = "attack"
						d.targvec = target.Position - npc.Position
						if math.abs(d.targvec.X) > math.abs(d.targvec.Y) then
							d.dir = "Hori"
						else
							if d.targvec.Y > 0 then
								d.dir = "Down"
							else
								d.dir = "Up"
							end
						end

						if d.targvec.X > 0 then
							sprite.FlipX = false
						else
							sprite.FlipX = true
						end
					end
				elseif d.state == "attack" then
					if sprite:IsFinished("Puke_" .. d.dir) then
						d.state = "idle"
						npc.StateFrame = 0
					elseif sprite:IsEventTriggered("Shoot") then
						npc:PlaySound(SoundEffect.SOUND_SPEWER,1,0,false,1.3)
						d.vomming = true
						d.vomcount = 0
						d.prevVom = npc.Position
					else
						mod:spritePlay(sprite, "Puke_" .. d.dir)
					end
				end

				if d.vomming then
					d.vomcount = d.vomcount + 1
					local pos = d.prevVom + d.targvec:Resized(7)
					d.prevVom = pos
					local creep = Isaac.Spawn(1000, 22, 0, pos, nilvector, npc):ToEffect();
					creep.Color = Color(10,15,15,1,0,0,0)
					creep.Scale = ((d.vomcount + 10) / 80)
					creep.SpriteScale = creep.SpriteScale * 2.5
					creep:SetTimeout(24)
					creep:Update()

					--[[local blood = Isaac.Spawn(1000, 2, 960, pos, nilvector, npc):ToEffect()
					blood.Scale = 0.5
					blood.Color = Color(10,15,15,1,0,0,0)
					blood:Update()]]

					if d.vomcount > 14 then
						d.vomming = false
					end
				end
			--Greg
			elseif subt == 2 then
				if d.state == "idle" then
					mod:spritePlay(sprite, "Idle")
					if npc.StateFrame > 120 and math.random(15) == 1 then
						mod:flipToTarget(npc, target, 0)
						d.state = "attack"
						d.targpos = target.Position
						if target.Position.Y < npc.Position.Y then
							d.animpos = "Up"
						else
							d.animpos = "Down"
						end
					end
				elseif d.state == "attack" then
					if sprite:IsFinished("Slam_" .. d.animpos) then
						d.state = "idle"
						npc.StateFrame = 0
					elseif sprite:IsEventTriggered("Slam") then
						Game():ShakeScreen(5)
						local vec = (d.targpos - npc.Position):Resized(1)
						local crack = Isaac.Spawn(1000, 72, 0, npc.Position, vec, npc):ToEffect()
						crack.Rotation = vec:GetAngleDegrees()
						crack:Update()
					else
						mod:spritePlay(sprite, "Slam_" .. d.animpos)
					end
				end
			--Minkus
			elseif subt == 3 then
				mod:spritePlay(sprite, "Hop")
				if sprite:IsEventTriggered("Hop") then
					local pdist = target.Position:Distance(npc.Position)
					if pdist > 200 then
						d.targvec = RandomVector():Resized(10)
					else
						d.targvec = (npc.Position - target.Position):Resized(10)
					end
					if npc.Position.X < (npc.Position + d.targvec).X then
						sprite.FlipX = false
					else
						sprite.FlipX = true
					end
					npc.Velocity = mod:Lerp(npc.Velocity, d.targvec, 0.9)
					d.SHOOTBOI = true
				end
			--Boris
			elseif subt == 4 then
				mod:spritePlay(sprite, "Idle")
				if npc.FrameCount % 20 == 1 then
					local creep = Isaac.Spawn(1000, 26, 980, npc.Position, nilvector, npc):ToEffect();
					creep.SpriteScale = creep.SpriteScale * 3
					--creep:GetSprite().Scale = creep:GetSprite().Scale * 0.1
					creep:SetTimeout(150)
					creep:Update()
				end

			end
			if d.SHOOTBOI then
				d.shootcount = d.shootcount or 0
				d.shootcount = d.shootcount + 1

				npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT,0.2,2,false,1)
				local params = ProjectileParams()
				local shotspeed = (npc.Velocity * -2):Resized(4):Rotated(-10+math.random(20))
				params.Scale = math.random(2, 10) / 10
				params.FallingSpeedModifier = -20 + math.random(10);
				params.FallingAccelModifier = 1.1 + math.random(2)/10;
				params.HeightModifier = -30
				params.Variant = 4
				npc:FireProjectiles(npc.Position, shotspeed, 0, params)

				if d.shootcount > 6 then
					d.SHOOTBOI = false
					d.shootcount = 0
				end
			end
		end

	end
end

--Fuckin boris >:(
function mod:borisCreepPool(e)
	local sprite = e:GetSprite()
	local d = mod:GetEntityData(e)
	--e.SpriteScale = e.SpriteScale * 3
	if e.FrameCount < 80 then
		if not d.smalled then
			e.SpriteScale = e.SpriteScale * 0.1
			e.SpriteRotation = math.random(360)
			d.smalled = true
		end
		--sprite.Scale = sprite.Scale * 1.15
		e.SpriteScale = e.SpriteScale * 1.032
	end
end

function mod:wormBall(npc)
    local sprite = npc:GetSprite()
    local d = mod:GetEntityData(npc)
	d.Target = d.Target or Vector(0,0)
	local dist = npc.Position:Distance(d.Target)
	npc.Velocity = mod:Lerp(npc.Velocity, (d.Target - npc.Position):Resized(dist / 10), 0.3)
	mod:spritePlay(sprite, "Launch")

	d.fallAccel = d.fallAccel or -10
	d.fallAccel = math.min(d.fallAccel + 1, 10)
	d.yOff = d.yOff or -50
	d.yOff = d.yOff + d.fallAccel

	npc.SpriteOffset = Vector(0, d.yOff)

	if npc.SpriteOffset.Y > -5 then
		local numsegments = 3
		d.segs = {}

		for i = 1, numsegments do
			local spawnSeg = 2
			if i == 1 then
				--Spawn head the first time
				spawnSeg = 1
			elseif i == numsegments then
				--Spawn tail the last time
				spawnSeg = 3
			end

			local seg = Isaac.Spawn(mod.FF.Tapeworm.ID, mod.FF.Tapeworm.Var, spawnSeg, npc.Position, nilvector, npc)
			--Parenting handling
			d.segs[i] = seg
			if d.segs[i - 1] then
				d.segs[i - 1].Child = seg
				seg.Parent = d.segs[i - 1]
			end
			--Color stuff
			local sd = mod:GetEntityData(seg)
			sd.ColorID = d.Color[i] or math.random(4)
			--Don't appear normally
			seg:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

			--Make head flip
			if not seg.Parent then
				local flippy = 1
				if math.random(2) == 1 then flippy = -1 end
				seg.Velocity = Vector(5,0):Rotated(-10 + math.random(20)) * flippy
			end

			seg:Update()
		end

		npc:Remove()
	end
end