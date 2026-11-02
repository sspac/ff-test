local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

FiendFolio.WackierWeavers = true
function mod:weaverAI(npc, variant)
	local sprite = npc:GetSprite()
	local d = mod:GetEntityData(npc)
	mod:setTargetOfNPC(npc, d)
	local target = npc:GetPlayerTarget()
	local subt = npc.SubType
	local room = game:GetRoom()

	if target.Parent and target.Parent.InitSeed == npc.InitSeed then
		target = Isaac.GetPlayer(0)
	end

	if variant == 10 then
		d.numbutts = 25
		d.numtails = 1
		d.groundtime = 15
	elseif variant == 2 then
		d.numbutts = 2
		d.numtails = 1
		d.groundtime = 50
	elseif variant == 3 then
		d.numbutts = 2
		d.numtails = 1
		d.groundtime = 30
	elseif variant == mod.FF.Archer.Var then
		d.numbutts = 2
		d.numtails = 1
		d.groundtime = 30
	elseif variant == mod.FF.Diagetic.Var then
		d.numbutts = 1
		d.numtails = 1
		d.numbullets = 4
		d.groundtime = 50
	else
		d.numbutts = 1
		d.numtails = 1
		d.groundtime = 10
	end

	local butttime = 3
	local tailtime = 3
	local holeoffset = -0

	local weavespeed = 8
	local curvar = 1
	local curframe = 13
	local curlerp = 0.05
	if variant == 2 or variant == mod.FF.Archer.Var then
		weavespeed = 8
		curvar = 1.7
		curframe = 25
		curlerp = 0.09
	elseif variant == mod.FF.Diagetic.Var then
		weavespeed = 6
		curvar = 1.7
		curframe = 25
		curlerp = 0.15
	elseif variant ~= 1 then
		weavespeed = 6
		curvar = 1.3
		curframe = 19
		curlerp = 0.07
	end

	if subt == 0 or subt > 3 then
		if not d.init then
			if variant == mod.FF.Archer.Var then
				if npc.SubType == 4 then
					mod:makeWaitFerr(npc, npc.Type, npc.Variant, 0, 30)
				else
					d.state = "wait"
					if mod:CheckStage("Dross", {45}) then
						d.TearVar = 3
					elseif mod:CheckStage("Corpse", {34,43,44}) then
						d.TearVar = 0
					else
						d.TearVar = 4
					end
					npc.Visible = false
					npc.StateFrame = mod:RandomInt(-30,30)
					npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
					npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_HIDE_HP_BAR)
					npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				end
				d.Index = room:GetGridIndex(npc.Position)
				if room:GetFrameCount() <= 1 then
					room:SpawnGridEntity(d.Index, GridEntityType.GRID_PIT, 0, 0, 0)
					mod:UpdatePits()
				end
			else
				if variant == mod.FF.DreadWeaver.Var
				or variant == mod.FF.Thread.Var 
				or variant == mod.FF.Diagetic.Var
				or variant == mod.FF.Strand.Var then
					if npc.SubType == 4 then
						local dist = (variant == mod.FF.DreadWeaver.Var and 80 or 40)
						mod:makeWaitFerr(npc, npc.Type, npc.Variant, 0, dist)
					end
				end
				npc.StateFrame = -10
				d.state = "underground"
			end
		d.init = true
		d.prevpositions = {{npc.Position, d.state}}
		d.alpha = 1
	else
		npc.StateFrame = npc.StateFrame + 1
	end

		if d.slowdown then
			d.slowdown = d.slowdown - 1
			if d.slowdown < 1 then
				d.slowdown = nil
			end
			weavespeed = weavespeed * 0.1
		end

		local targpos = mod:confusePos(npc, target.Position)

		-- if there are multiple weavers, orbit the player
		if FiendFolio.WackierWeavers then
			local weavers = Isaac.FindByType(npc.Type, -1, -1, false, false)
			local sumOff = 0
			local first = true
			local useWeaves = {}
			for i, weave in ipairs(weavers) do
				if weave.SubType == 0 or weave.SubType > 3 then
					useWeaves[#useWeaves + 1] = weave
					sumOff = sumOff + (weave.InitSeed % 360)
					if first then
						sumOff = sumOff + (weave.FrameCount % 360)
						first = false
					end
				end
			end

			if #useWeaves > 1 then
				for i, weave in ipairs(useWeaves) do
					if i ~= 1 and GetPtrHash(weave) == GetPtrHash(npc) then
						local off = (360 / (#useWeaves - 1)) * (i - 1)
						local dist = 65
						if d.state ~= "underground" then
							dist = 30
						end

						targpos = targpos + Vector(dist, 0):Rotated(off + sumOff)
					end
				end
			end
		end

		local targvel = mod:reverseIfFear(npc, (targpos - npc.Position):Resized(weavespeed))
		npc.Velocity = mod:Lerp(npc.Velocity, targvel, curlerp)
		if d.state == "wait" then
			npc.Velocity = Vector.Zero
			if not d.stasis then
				npc.StateFrame = npc.StateFrame + 1
			end
			if npc.StateFrame >= 60 then
				d.state = "archerEmerge"
				npc.SpriteOffset = Vector(0,0)
				d.alpha = 1
				npc.Visible = true
				d.dontStuck = false
				npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
				mod:FlipSprite(sprite, npc.Position, targpos)
			else
				npc.Visible = false
			end
		elseif d.state == "archerEmerge" then
			npc.Velocity = Vector.Zero
			if sprite:IsFinished("ShootEmerge") then
				d.state = "archerIdle"
				npc.StateFrame = mod:RandomInt(0,20)
			elseif sprite:IsEventTriggered("Emerge") then
				npc:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_HIDE_HP_BAR)
				npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
				Isaac.Spawn(1000,132,0,npc.Position+Vector(0,10),Vector.Zero,npc)
				npc:PlaySound(mod.Sounds.SplashLargePlonkless,0.8,0,false,1.2)
			else
				mod:spritePlay(sprite, "ShootEmerge")
			end
		elseif d.state == "archerIdle" then
			npc.Velocity = Vector.Zero
			npc.StateFrame = npc.StateFrame + 1
			if npc.StateFrame > 60 then
				npc.StateFrame = 0
				d.state = "shoot"
			else
				mod:spritePlay(sprite, "ShootIdle")
			end
		elseif d.state == "shoot" then
			npc.Velocity = Vector.Zero
			if sprite:IsEventTriggered("JumpStart") then
				npc:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
				d.state = "surface"
				npc:PlaySound(SoundEffect.SOUND_BOSS2_DIVE, 0.7, 0, false, 1.2)
				Isaac.Spawn(1000,132,0,npc.Position+Vector(0,10),Vector.Zero,npc)
				npc.Velocity = mod:reverseIfFear(npc, (targpos - npc.Position):Resized(weavespeed - 2))
				d.killButt = nil
				d.lastcreepleft = nil
				d.spawndbutt = false
				d.spawndtail = false
				d.headnum = 1
				npc.StateFrame = 0
				mod.OccupiedGrids[d.Index] = "Open"
			elseif sprite:IsEventTriggered("Shoot") then
				mod:FlipSprite(sprite, npc.Position, targpos)
				local params = ProjectileParams()
				params.Variant = d.TearVar
				params.FallingAccelModifier = 0.8
				params.HeightModifier = -25
				for i = 1, mod:RandomInt(5,8) do
					params.Scale = 0.1 * mod:RandomInt(6, 12)
					params.FallingSpeedModifier = mod:RandomInt(-10,-5)
					npc:FireProjectiles(npc.Position, (target.Position - npc.Position):Resized(mod:RandomInt(6,10)):Rotated(mod:RandomInt(-30,30)), 0, params)
				end
				npc:PlaySound(SoundEffect.SOUND_BOSS_LITE_HISS, 0.7, 0, false, 1.2)
			end
			mod:spritePlay(sprite, "Shoot")
		elseif d.state == "underground" then
			npc.Visible = false
			mod:spritePlay(sprite, "Empty")
			npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
			if variant == 2 --[[and room:GetGridCollisionAtPos(npc.Position) ~= GridCollisionClass.COLLISION_PIT]] then
				npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
			else
				npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			end

			d.lastcreepleft = d.lastcreepleft or npc.Position + Vector(0,20)
			if d.lastcreepleft:Distance(npc.Position) > 15 and npc.FrameCount > 0 then
				if variant == 2 then
					npc:PlaySound(SoundEffect.SOUND_ROCK_CRUMBLE,0.3,0,false,math.random(90,110)/100)
					local crack = Isaac.Spawn(1000, 62, 0, npc.Position, Vector.Zero, npc):ToEffect()
					crack.Color = Color(0.5,0.5,0.5,1,0,0,0)
					crack:Update()
					mod:DestroyNearbyGrid(npc, 30)
				else
					--[[local pile = Isaac.Spawn(1000, 26, 7002, npc.Position, Vector.Zero, npc):ToEffect()
					local backdrop = game:GetRoom():GetBackdropType()
					if (REVEL and REVEL.STAGE and REVEL.STAGE.Glacier and REVEL.STAGE.Glacier:IsStage()) then
                        pile.Color = Color(1,1,1,1,-20 / 255,10 / 255,40 / 255)
					elseif backdrop == 10 or backdrop == 11 or backdrop == 12 then
						pile.Color = Color(1,1,1,1,60 / 255,-20 / 255,-20 / 255)
					elseif backdrop == 14 then
						pile.Color = Color(0.5,0.5,0.5,1,0,0,0)
					end
					pile:Update()]]
					if room:GetGridCollisionAtPos(npc.Position) == GridCollisionClass.COLLISION_NONE then
						local pile = Isaac.Spawn(1000, 146, 0, npc.Position, Vector.Zero, npc):ToEffect()
						pile:Update()
					end
				end
				d.lastcreepleft = npc.Position
			end

			if npc.StateFrame > d.groundtime then
				if room:GetGridCollisionAtPos(npc.Position) == GridCollisionClass.COLLISION_NONE and room:IsPositionInRoom(npc.Position, 15) then
					npc:PlaySound(SoundEffect.SOUND_MAGGOT_BURST_OUT,0.3,0,false,1.3 + math.random(3)/10)
					d.state = "surface"
					d.killButt = nil
					local pile = Isaac.Spawn(1000, 146, 0, npc.Position, Vector.Zero, npc):ToEffect()
					--[[local backdrop = game:GetRoom():GetBackdropType()
					if backdrop == 10 or backdrop == 11 or backdrop == 12 then
						pile.Color = Color(1,1,1,1,60 / 255,-20 / 255,-20 / 255)
					elseif backdrop == 14 then
						pile.Color = Color(0.5,0.5,0.5,1,0,0,0)
					end]]
					local dirt = pile:GetSprite()
					dirt:Load("gfx/enemies/weaver/weaver.anm2", true)
					mod:GetEntityData(pile).WeaverPile = true
					pile:Update()
					d.lastcreepleft = nil
					d.spawndbutt = false
					d.spawndtail = false
					if variant == 1 then
						if npc.Position:Distance(target.Position) < 140 then
							d.headnum = 2
						else
							d.headnum = 1
						end
					else
						if math.random(15) == 1 then
							d.headnum = 2
						else
							d.headnum = 1
						end
					end

					--Strand egg code handled in ferrium/enemies/strand.lua
					if variant == mod.FF.Strand.Var and not mod:isFriend(npc) and mod.IsActiveRoom() then
						local count = 0
						for _,ent in ipairs(Isaac.FindByType(mod.FF.StrandSack.ID, mod.FF.StrandSack.Var, mod.FF.StrandSack.Sub, false, false)) do
							count = count+1
						end
						d.StrandCount = d.StrandCount or 0
						if count <  6 and d.StrandCount % 3 == 0 then
							if not d.StrandDummyEffect or not mod:superExists(d.StrandDummyEffect) then
								d.StrandDummyEffect = mod:AddDummyEffect(npc, Vector.Zero)
							end
							d.FirstStrandEgg = Isaac.Spawn(mod.FF.StrandSack.ID, mod.FF.StrandSack.Var, mod.FF.StrandSack.Sub, npc.Position, Vector.Zero, npc):ToEffect()
							local dummy1 = mod:AddDummyEffect(d.FirstStrandEgg, Vector(0, 10))
							local line = Isaac.Spawn(mod.FF.StrandLine.ID, mod.FF.StrandLine.Var, mod.FF.StrandLine.Sub, npc.Position, Vector.Zero, npc):ToNPC()
							line:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
							line:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_DEATH_TRIGGER | EntityFlag.FLAG_NO_REWARD)
							line.Parent = d.StrandDummyEffect
							line.Target = dummy1
							mod:GetEntityData(d.FirstStrandEgg).MyStrand = npc
							mod:GetEntityData(d.FirstStrandEgg).StrandDummyEffect = dummy1
							d.StrandLine = line
						end
					end
					npc.StateFrame = 0
				end
			end
		elseif d.state == "surface" then
			npc.Visible = true
			if npc.Velocity.Y < 0 then
				mod:spritePlay(sprite, "HeadUp" .. d.headnum)
			else
				mod:spritePlay(sprite, "HeadDown" .. d.headnum)
			end
			if npc.Velocity.X < 0 then
				sprite.FlipX = true
			else
				sprite.FlipX = false
			end
			if d.descending then
				npc.Velocity = npc.Velocity * 0.7
				npc.SpriteOffset = Vector(0, npc.SpriteOffset.Y + 2.5)
				if npc.SpriteOffset.Y > 20 then
					d.state = "wait"
					npc.Velocity = Vector.Zero
					npc.Position = room:GetGridPosition(room:GetGridIndex(npc.Position))
					npc.Visible = false
					d.descending = false
				else
					d.alpha = d.alpha - 0.2
				end
			else
				local curve = 0 - math.sin(0.2 * npc.StateFrame / curvar) * 20
				local coll = room:GetGridCollisionAtPos(npc.Position)
				if npc.StateFrame > curframe and (coll ~= GridCollisionClass.COLLISION_NONE and coll ~= GridCollisionClass.COLLISION_PIT and variant ~= 2) then
					npc.StateFrame = curframe
					d.staystill = true
				end
				if variant == mod.FF.Archer.Var then
					curve = curve * 2
				end
				npc.SpriteOffset = Vector(0, curve)
				if curve <= -25 then
					npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				else
					npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
				end
			end
			if variant == mod.FF.Strand.Var then
				if not d.StrandDummyEffect or not mod:superExists(d.StrandDummyEffect) then
					d.StrandDummyEffect = mod:AddDummyEffect(npc, Vector.Zero)
				end

				d.StrandDummyEffect.ParentOffset = npc.SpriteOffset
			end
			if npc.StateFrame > curframe + 2 then
				--[[if coll == GridCollisionClass.COLLISION_PIT and room:HasWaterPits() then
					npc:PlaySound(mod.Sounds.SplashLargePlonkless,3,0,false,1)
					local effect = Isaac.Spawn(1000,7002,0,npc.Position,Vector.Zero,nil)
				else
					local pile = Isaac.Spawn(1000, 26, 7003, npc.Position, Vector.Zero, npc):ToEffect()
				end]]

				--[[local backdrop = game:GetRoom():GetBackdropType()
				if backdrop == 10 or backdrop == 11 or backdrop == 12 then
					pile.Color = Color(1,1,1,1,60 / 255,-20 / 255,-20 / 255)
				elseif backdrop == 14 then
					pile.Color = Color(0.5,0.5,0.5,1,0,0,0)
				end]]
				if variant == mod.FF.Archer.Var then
					d.stasis = true
					npc.StateFrame = mod:RandomInt(0,30)
					d.Index = mod:GetUnoccupiedPit(d.Index)
					mod.OccupiedGrids[d.Index] = "Closed"
					npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_HIDE_HP_BAR)
					npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
					if mod:CheckIndexForGrid(room:GetGridIndex(npc.Position), GridEntityType.GRID_PIT, GridCollisionClass.COLLISION_PIT) then
						npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_PITSONLY
						Isaac.Spawn(1000,132,0,npc.Position+Vector(0,10),Vector.Zero,npc)
						npc:PlaySound(mod.Sounds.SplashLarge,0.8,0,false,1.2)
						d.descending = true
						d.dontStuck = true
					else
						npc.Velocity = Vector.Zero
						npc.Visible = false
						d.state = "wait"
					end
				else
					local pile = Isaac.Spawn(1000, 146, 0, npc.Position, Vector.Zero, npc):ToEffect()
					local dirt = pile:GetSprite()
					dirt:Load("gfx/enemies/weaver/weaver.anm2", true)
					mod:GetEntityData(pile).WeaverPile = true
					pile:Update()
					npc:PlaySound(SoundEffect.SOUND_MAGGOT_ENTER_GROUND,0.3,0,false,1.3 + math.random(3)/10)
					d.state = "underground"

					if variant == mod.FF.Strand.Var and not mod:isFriend(npc) and mod.IsActiveRoom() then
						d.StrandCount = d.StrandCount or 1
						if d.StrandCount % 3 == 0 then
							local coll = room:GetGridCollisionAtPos(npc.Position)
							if coll == GridCollisionClass.COLLISION_NONE and d.FirstStrandEgg and d.FirstStrandEgg:Exists()
							and d.StrandLine and d.StrandLine:Exists() and room:CheckLine(npc.Position, d.FirstStrandEgg.Position, 3, false, false) then
								local egg = Isaac.Spawn(mod.FF.StrandSack.ID, mod.FF.StrandSack.Var, mod.FF.StrandSack.Sub, npc.Position, Vector.Zero, npc):ToEffect()
								local dummy1 = mod:AddDummyEffect(egg, Vector(0, 10))
								mod:GetEntityData(egg).OtherStrandEgg = d.FirstStrandEgg
								mod:GetEntityData(egg).StrandLine = d.StrandLine
								mod:GetEntityData(egg).StrandDummyEffect = dummy1
								d.StrandLine.Parent = dummy1
								mod:GetEntityData(d.FirstStrandEgg).MyStrand = nil
							else
								if d.FirstStrandEgg and d.FirstStrandEgg:Exists() then
									mod:GetEntityData(d.FirstStrandEgg).BreakStrand = true
								end
								if d.StrandLine and d.StrandLine:Exists() then
									d.StrandLine:Remove()
								end
							end
							d.StrandLine = nil
							d.FirstStrandEgg = nil
							d.StrandCount = npc:GetDropRNG():RandomInt(2)+1
						else
							d.StrandCount = d.StrandCount+1
						end
					end
				end
				if npc.Variant == 3 then
					d.slowdown = 10
				end
				npc.StateFrame = 0
			end
		end
		local offsetextra = 0
		if not d.staystill then
			offsetextra = (npc.StateFrame - 7.5) * -0.5
		end

		table.insert(d.prevpositions, 1, {
			state = d.state,
			pos = npc.Position,
			offset = npc.SpriteOffset.Y,
			offsete = offsetextra,
			velocity = npc.Velocity,
			alpha = d.alpha,
		})
		local totalbutts = butttime * d.numbutts
		local totalmore = totalbutts + tailtime * d.numtails
		if npc.Variant == mod.FF.Diagetic.Var then
			if #d.prevpositions > totalmore + 12 then
				table.remove(d.prevpositions, #d.prevpositions)
			end
		else
			if #d.prevpositions > totalmore + 1 then
				table.remove(d.prevpositions, #d.prevpositions)
			end
		end
		d.statstill = false

		if variant == mod.FF.Strand.Var and not mod:superExists(npc) then
			if d.StrandDummyEffect and d.StrandDummyEffect:Exists() then
				d.StrandDummyEffect:Remove()
			end
			if d.StrandLine and d.StrandLine:Exists() then
				d.StrandLine:Remove()
			end
		end

		--[[
		if d.prevpositions[butttime] then
			if d.prevpositions[butttime].state == "surface" and not d.spawndbutt then
				local butt = mod.spawnent(npc,d.prevpositions[butttime].pos, d.prevpositions[butttime].velocity, mod.FF.Weaver.ID, 0, 1)
				butt.Parent = npc
				npc.Child = butt
				mod:copyStatusEffects(npc, butt)
				butt:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				butt:Update()
				d.spawndbutt = true
			end
		end
		if d.prevpositions[tailtime] then
			if d.prevpositions[tailtime].state == "surface" and not d.spawndtail then
				local butt = mod.spawnent(npc,d.prevpositions[tailtime].pos, d.prevpositions[tailtime].velocity, mod.FF.Weaver.ID, 0, 2)
				butt.Parent = npc
				if npc.Child then
					butt.Child = npc.Child
					npc.Child.Child = butt
				end
				npc.Parent = butt
				mod:copyStatusEffects(npc, butt)
				butt:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				butt:Update()
				d.spawndtail = true
			end
		end]]

		for i = 1, d.numbutts do
			local timehere = butttime * i
			if d.prevpositions[timehere] then
				if d.prevpositions[timehere].state == "surface" and (d.prevpositions[timehere + 1].state == "underground" or d.prevpositions[timehere + 1].state == "shoot") then
					local butt = mod.spawnent(npc,d.prevpositions[timehere].pos, d.prevpositions[timehere].velocity, mod.FF.Weaver.ID, variant, 1)
					butt.Parent = npc
					mod:copyStatusEffects(npc, butt)
					butt:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
					mod:GetEntityData(butt).timeset = timehere
					mod:GetEntityData(butt).queuepos = i
					--butt:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
					butt.HitPoints = npc.HitPoints
					butt.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
					butt.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
					butt:Update()
				end
			end
		end
		for i = 1, d.numtails do
			local timehere = tailtime * i + totalbutts
			if d.prevpositions[timehere] then
				if d.prevpositions[timehere].state == "surface" and (d.prevpositions[timehere + 1].state == "underground" or d.prevpositions[timehere + 1].state == "shoot") then
					local tail = mod.spawnent(npc,d.prevpositions[timehere].pos, d.prevpositions[timehere].velocity, mod.FF.Weaver.ID, variant, 2)
					tail.Parent = npc
					mod:copyStatusEffects(npc, tail)
					tail:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
					mod:GetEntityData(tail).timeset = timehere
					--tail:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
					tail.HitPoints = npc.HitPoints
					tail.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
					tail.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
					tail:Update()
					d.tail = tail
				end
			end
		end
		if npc.Variant == mod.FF.Diagetic.Var then
			for i = 1, d.numbullets do
				local timehere = 2 * i + totalmore
				if d.prevpositions[timehere] then
					if d.prevpositions[timehere].state == "surface" and (d.prevpositions[timehere + 1].state == "underground" or d.prevpositions[timehere + 1].state == "shoot") then
						local proj = mod:LazySpawnProjectile(0,0,d.prevpositions[timehere].pos, d.prevpositions[timehere].velocity,npc):ToProjectile()
						proj.Color = mod.ColorWigglyMaggot
						proj.Scale = 0.3 + (0.5 * (4 - i))
						proj.FallingAccel = -0.1
						proj:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
						mod:GetEntityData(proj).projType = "diagetic"
						mod:GetEntityData(proj).timeset = timehere
						proj.Height = -6
						proj.Parent = npc
						proj.Child = d.tail
						if i == 1 then
							d.wormHead = proj
							mod:GetEntityData(proj).isWormHead = true
						else
							mod:GetEntityData(proj).wormHead = d.wormHead
						end
					end
				end
			end
		end

	--Butts
	elseif subt == 1 or subt == 2 then
		local timetime = d.timeset
		if subt == 2 then
			if npc.Parent then
				if mod:GetEntityData(npc.Parent).killButt then
					mod:GetEntityData(npc.Parent).killButt = nil
					npc.Visible = false
					npc:Remove()
				else
					if variant == mod.FF.Archer.Var then
						mod:FlipSprite(sprite, npc.Parent.Position, npc.Position)
					end
				end
			end
			mod:spritePlay(sprite, "BodyTail")
			if variant == 2 and npc:IsDead() and mod:shouldDoDeathEffect(npc) and (not npc.Parent or (mod:shouldDoDeathEffect(npc.Parent))) then
				for i = 90, 360, 90 do
					npc:FireProjectiles(npc.Position, Vector(0,13):Rotated(i), 0, ProjectileParams())
				end
			end
		else
			if (variant == 2 or variant == 3 or variant == 4) and d.queuepos == 2 then
				mod:spritePlay(sprite, "BodyMiddle2")
				if npc:IsDead() and mod:shouldDoDeathEffect(npc) and (not npc.Parent or (mod:shouldDoDeathEffect(npc.Parent))) then
					for i = 90, 360, 90 do
						npc:FireProjectiles(npc.Position, Vector(0,13):Rotated(i + 45), 0, ProjectileParams())
					end
				end
			else
				mod:spritePlay(sprite, "BodyMiddle")
			end
		end
		npc.StateFrame = npc.StateFrame + 1
		if npc.Parent and not mod:isStatusCorpse(npc.Parent) then
			--npc.Color = npc.Parent:GetColor()
			if npc.Parent:IsDead() and mod:shouldDoDeathEffect(npc.Parent) then
				if variant == 2 and mod:shouldDoDeathEffect(npc) then
					if subt == 2 then
						for i = 90, 360, 90 do
							npc:FireProjectiles(npc.Position, Vector(0,10):Rotated(i), 0, ProjectileParams())
						end
					elseif d.queuepos == 2 then
						for i = 90, 360, 90 do
							npc:FireProjectiles(npc.Position, Vector(0,10):Rotated(i + 45), 0, ProjectileParams())
						end
					end
				end
				npc:Kill()
			end
			local pd = mod:GetEntityData(npc.Parent)
			if pd.prevpositions then
				if pd.prevpositions[timetime] then
					local check = ((pd.prevpositions[timetime].state == "underground" or pd.prevpositions[timetime].state == "wait") or (pd.prevpositions[timetime].alpha <= 0))
					if check then
						--Isaac.ConsoleOutput("Removed")
						if ((variant == 3 and d.queuepos == 2) or (variant == mod.FF.Archer.Var and d.queuepos == 1)) and subt == 1 and not mod:GetEntityData(npc.Parent).dontStuck then
							npc.SubType = 3
							if variant == mod.FF.Archer.Var then
								mod:FlipSprite(sprite, npc.Position, npc.Position + npc.Velocity)
								mod:spritePlay(sprite, "TailStuck")
								npc.SpriteOffset = Vector(0,0)
								local params = ProjectileParams()
								params.Variant = mod:GetEntityData(npc.Parent).TearVar
								npc:FireProjectiles(npc.Position, Vector(8,0), 6, params)
								Isaac.Spawn(mod.FF.LargeWaterRipple.ID,mod.FF.LargeWaterRipple.Var,mod.FF.LargeWaterRipple.Sub,npc.Position,Vector.Zero,npc)
							else
								if math.random(2) == 1 then
									sprite.FlipX = true
								else
									sprite.FlipX = false
								end
							end
							npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
							npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
							sfx:Play(mod.Sounds.GravediggerDig, 0.5, 0, false, math.random(14,16)/10)
							mod:GetEntityData(npc.Parent).killButt = true
							npc.Parent:Update()
						else
							npc.Visible = false
							npc:Remove()
						end
					else
						local offset
						if variant == mod.FF.Archer.Var then
							if subt == 2 then
								timetime = timetime - 2
								offset = (pd.prevpositions[timetime].offset + pd.prevpositions[timetime].offsete * subt) - 10
								npc.SpriteOffset = Vector(0, offset)
								if npc.Parent and mod:GetEntityData(npc.Parent).state ~= "underground" then
									local rot = 90 + (Vector(npc.Parent.Position.X, npc.Parent.Position.Y + npc.Parent.SpriteOffset.Y) - Vector(npc.Position.X, npc.Position.Y + npc.SpriteOffset.Y)):GetAngleDegrees()
									if sprite.FlipX then
										rot = -rot
									end
									sprite.Rotation = rot
								end
								d.prev = offset
							else
								offset = pd.prevpositions[timetime].offset + pd.prevpositions[timetime].offsete * subt
								npc.SpriteOffset = Vector(0, offset) --* 1.3
							end
						else
							offset = pd.prevpositions[timetime].offset + pd.prevpositions[timetime].offsete * subt
							npc.SpriteOffset = Vector(0, offset) --* 1.3
						end
						if offset <= -25 or offset > 0 then
							npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
						else
							npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
						end
						npc.Position = pd.prevpositions[timetime].pos
						npc.Velocity = pd.prevpositions[timetime].velocity
						d.alpha = pd.prevpositions[timetime].alpha
						--mod:PrintColor(npc.Color)
					end
				end
			end
		else
			npc:Kill()
		end
	elseif subt == 3 then
		npc.Velocity = Vector.Zero
		if variant == mod.FF.Thread.Var then
			if sprite:IsFinished("TailStuck") then
				--npc:PlaySound(SoundEffect.SOUND_PLOP,1,2,false,1.2)
				npc:Remove()
			elseif (sprite:IsEventTriggered("SprayR") and not sprite.FlipX) or (sprite:IsEventTriggered("SprayL") and sprite.FlipX) then
				npc:PlaySound(SoundEffect.SOUND_HEARTOUT, 0.4, 0, false, 1.3)
				for i = -30, 30, 30 do
					local params = ProjectileParams()
					params.FallingSpeedModifier = -15 - math.random(10)/10
					params.FallingAccelModifier = 1.4 + math.random(2)/10
					npc:FireProjectiles(npc.Position, Vector(5, 0):Rotated(i) * math.random(7,10)/10, 0, params)
				end
			elseif(sprite:IsEventTriggered("SprayL") and not sprite.FlipX) or (sprite:IsEventTriggered("SprayR") and sprite.FlipX) then
				npc:PlaySound(SoundEffect.SOUND_HEARTOUT, 0.4, 0, false, 1.3)
				for i = -30, 30, 30 do
					local params = ProjectileParams()
					params.FallingSpeedModifier = -15 - math.random(10)/10
					params.FallingAccelModifier = 1.4 + math.random(2)/10
					npc:FireProjectiles(npc.Position, Vector(-5, 0):Rotated(i), 0, params)
				end
			elseif sprite:IsEventTriggered("Explosion") then
				npc:PlaySound(SoundEffect.SOUND_PLOP,1,2,false,0.7)
			else
				mod:spritePlay(sprite, "TailStuck")
			end
			if npc.Parent and (npc.Parent:IsDead() or mod:isStatusCorpse(npc.Parent)) then
				npc:Kill()
			end
		elseif variant == mod.FF.Archer.Var then
			if sprite:IsFinished("TailStuck") then
				sprite:Play("TailStuckLoop")
				npc.StateFrame = 0
			elseif sprite:IsPlaying("TailStuckLoop") and npc.StateFrame > 30 then
				sprite:Play("TailStuckEnd")
			elseif sprite:IsFinished("TailStuckEnd") then
				npc:Remove()
				mod:GetEntityData(npc.Parent).stasis = false
				npc.Parent.Position = room:GetGridPosition(mod:GetEntityData(npc.Parent).Index)
			end
			npc.StateFrame = npc.StateFrame + 1
			if npc.Parent and (npc.Parent:IsDead() or mod:isStatusCorpse(npc.Parent)) then
				npc:Kill()
			end
		end
	end
end

function mod:weaverDirtPileAI(effect)
	effect.Variant = 7000
	local sprite = effect:GetSprite()
	mod:spritePlay(sprite, "Another")
	if sprite:IsFinished("Another") then
		effect:Remove()
	end
end
function mod:weaverDirtPileOpeningAI(effect)
	--effect.Variant = 7000
	local sprite = effect:GetSprite()
	mod:spritePlay(sprite, "Ground")
	if sprite:IsFinished("Ground") then
		effect:Remove()
	end
end
function mod:kingpinDirtPileAI(effect)
	local sprite = effect:GetSprite()
	if not mod:GetEntityData(effect).Init then
		sprite:Play("Enter", true)
		mod:GetEntityData(effect).Init = true
	end
	--effect.Variant = 7000
	effect.Timeout = 100
	if sprite:IsFinished("Leave") then
		effect:Remove()
	elseif not sprite:IsPlaying("Leave") then
		if mod:GetEntityData(effect).Timeout and effect.FrameCount > mod:GetEntityData(effect).Timeout then
			sprite:Play("Leave", true)
		elseif not sprite:IsFinished("Enter") and not sprite:IsPlaying("Enter") then
			sprite:Play("Enter", true)
		end
	end
	if not mod:GetEntityData(effect).didIt then
		effect.SpriteScale = Vector(math.random(85,115)/100,math.random(85,115)/100)
		effect.SpriteRotation = -10 + math.random(20)
		if math.random(2) == 1 then
			effect:GetSprite().FlipX = true
		end
		mod:GetEntityData(effect).didIt = true
	end
end

function mod:preWeaverRenderColor(npc, offset)
	local d = mod:GetEntityData(npc)
	local alphamult = d.alpha or 1
	
	local s = npc:GetSprite()
	d.origAlpha = s.Color.A
	s.Color.A = s.Color.A * alphamult
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_NPC_RENDER, math.huge, mod.preWeaverRenderColor, mod.FF.Weaver.ID)

function mod:postWeaverRenderColor(npc, offset)
	local d = mod:GetEntityData(npc)
	if d.origAlpha ~= nil then
		local s = npc:GetSprite()
		s.Color.A = d.origAlpha
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_NPC_RENDER, math.huge, mod.postWeaverRenderColor, mod.FF.Weaver.ID)

function mod:checkWeaverRender(npc, offset)
	if npc.Variant == mod.FF.Archer.Var and npc.SubType == 2 then --This logic is completely backwards but it justs works lol!
		local room = game:GetRoom()
		if room:HasWater() then
			if room:GetRenderMode() == RenderMode.RENDER_WATER_REFLECT then --Sprite rotation on the Archer tail breaks reflections completely, so just don't bother reflecting
				npc.Visible = true
			else
				npc.Visible = false
			end
		else
			npc.Visible = true
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.checkWeaverRender, mod.FF.Weaver.ID)

function mod:checkWeaverCollision(npc1, npc2, mysteryBoolean)
  local d = mod:GetEntityData(npc1:ToNPC())
	if npc1.Parent and npc1.Parent.InitSeed == npc2.InitSeed then -- Prevent selfdamage from charm/bait
		return true
	elseif npc2.Parent and npc2.Parent.InitSeed == npc1.InitSeed then
		return true
	elseif npc1.Parent and npc2.Parent and npc1.Parent.InitSeed == npc2.Parent.InitSeed then
		return true
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, mod.checkWeaverCollision, mod.FF.Weaver.ID)

function mod:checkWeaverHurt(npc, damage, flag, source, countdown)
	--if npc.Variant == 3 then
	--	if npc.SubType == 2 or npc.SubType == 3 then
	--		if npc.Parent then
	--			npc.Parent:TakeDamage(damage, flag | DamageFlag.DAMAGE_CLONES, EntityRef(npc), 0)
	--		end
	--	elseif flag ~= flag | DamageFlag.DAMAGE_CLONES then
	--		return false
	--	end
	--end
	--if flag & DamageFlag.DAMAGE_CLONES == 0 then
	--	if npc.Parent then
	--		npc.Parent:TakeDamage(damage, flag & DamageFlag.DAMAGE_CLONES, EntityRef(npc), 0)
	--	end
	--	if npc.Child then
	--		npc.Child:TakeDamage(damage, flag & DamageFlag.DAMAGE_CLONES, EntityRef(npc), 0)
	--	end
	--end

	local data = mod:GetEntityData(npc)

	if npc.SubType ~= 0 and npc.Parent and mod:GetEntityData(npc.Parent).eternalFlickerspirited then
		return false
	end

	if flag == flag | DamageFlag.DAMAGE_POISON_BURN then -- Keep Poison/Burn Synced to once per 40 frames
		data.FFLastPoisonProc = data.FFLastPoisonProc or 0
		if Isaac.GetFrameCount() - data.FFLastPoisonProc < 40 then
			return false
		end
		data.FFLastPoisonProc = Isaac.GetFrameCount()
	end

	if npc.Variant == 3 and npc.SubType ~= 2 and npc.SubType ~= 3 and flag ~= flag | DamageFlag.DAMAGE_CLONES and flag ~= flag | DamageFlag.DAMAGE_POISON_BURN then
		return false
	elseif npc.SubType == 0 then
		local butts = Isaac.FindByType(npc.Type, npc.Variant)
		for _, butt in ipairs(butts) do
			if butt.Parent and butt.Parent.InitSeed == npc.InitSeed then
				butt:TakeDamage(damage, flag | DamageFlag.DAMAGE_CLONES, source, 0)
			end
		end
	elseif flag ~= flag | DamageFlag.DAMAGE_CLONES then
		if npc.SubType ~= 0 then
			if npc.Parent then
				data.IgnorePassedDamage = true
				npc.Parent:TakeDamage(damage, flag | DamageFlag.DAMAGE_CLONES, source, 0)
				data.IgnorePassedDamage = false
			end
		end
	elseif data.IgnorePassedDamage then
		return false
	end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.checkWeaverHurt, mod.FF.Weaver.ID)

function mod:DiageticProjectile(proj, data) --"diagetic" projType
	local timetime = data.timeset
	if data.isWormHead then
		data.PosLog = data.PosLog or {}
		data.PosLog[proj.FrameCount] = {["Pos"] = proj.Position, ["Vel"] = proj.Velocity}
	end

	if proj.FrameCount < 40 then
		local height = (0 - math.sin(0.2 * proj.FrameCount / 2.25) * 90) + 2
		if height < -6 then
			proj.Height = height
		end
		if data.isWormHead and proj.Parent and proj.Parent:Exists() then
			local pd = mod:GetEntityData(proj.Parent)
			proj.Position = pd.prevpositions[timetime].pos
			proj.Velocity = pd.prevpositions[timetime].velocity
		elseif data.wormHead and data.wormHead:Exists() and mod:GetEntityData(data.wormHead).PosLog then
			local dat = mod:GetEntityData(data.wormHead).PosLog[proj.FrameCount]
			if dat then
				proj.Position = dat.Pos
				proj.Velocity = dat.Vel
			end
		end
	elseif data.isWormHead then
		if proj.FrameCount > 200 then
			if game:GetRoom():GetGridCollisionAtPos(proj.Position) >= GridCollisionClass.COLLISION_WALL or proj.FrameCount > 300 then
				proj:Die()
			end
		elseif proj.FrameCount > 150 then
			proj.Velocity = mod:Lerp(proj.Velocity, proj.Velocity:Resized(10), 0.05)
		elseif proj.FrameCount > 90 then
			targetvel = (game:GetNearestPlayer(proj.Position).Position - proj.Position):Resized(10)
			proj.Velocity = mod:Lerp(proj.Velocity, targetvel, 0.05)
		else
			proj.Velocity = proj.Velocity * 0.99
		end
	elseif data.wormHead and data.wormHead:Exists() and mod:GetEntityData(data.wormHead).PosLog then
		local dat = mod:GetEntityData(data.wormHead).PosLog[proj.FrameCount]
		proj.Position = dat.Pos
		proj.Velocity = dat.Vel
	else
		proj:Die()
	end
end

--Run Weaver AI
function mod:checkWeaver(npc)
	mod:weaverAI(npc, npc.Variant)
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkWeaver, mod.FF.Weaver.ID)

mod:addCopyStatusHandler(FiendFolio.FF.Weaver.ID, FiendFolio.FF.Weaver.Var)
mod:addCopyStatusHandler(FiendFolio.FF.WeaverSr.ID, FiendFolio.FF.WeaverSr.Var)
mod:addCopyStatusHandler(FiendFolio.FF.DreadWeaver.ID, FiendFolio.FF.DreadWeaver.Var)
mod:addCopyStatusHandler(FiendFolio.FF.Thread.ID, FiendFolio.FF.Thread.Var)
mod:addCopyStatusHandler(FiendFolio.FF.Archer.ID, FiendFolio.FF.Archer.Var)
mod:addCopyStatusHandler(FiendFolio.FF.Strand.ID, FiendFolio.FF.Strand.Var)
mod:addCopyStatusHandler(FiendFolio.FF.Diagetic.ID, FiendFolio.FF.Diagetic.Var)