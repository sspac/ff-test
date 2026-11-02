local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

--Also includes muk and drooler okay?

function mod:craterFaceAI(npc)
	local d = mod:GetEntityData(npc)
	local sprite = npc:GetSprite();
	local target = npc:GetPlayerTarget()

	if not d.init then
		d.init = true
		d.npcstate = 1
		d.framecount = 0
		d.delay = -55 + math.random(15)
		sprite:Play("Walk",true)
		d.targetvelocity = ((target.Position - npc.Position):Normalized()*2):Rotated(-50+math.random(100))
	elseif d.init then
		d.orbit = math.sin((d.framecount) / 5)
		npc.StateFrame = npc.StateFrame + 1
		d.framecount = d.framecount + 1
		local targvec = mod:runIfFear(npc, d.targetvelocity, d.targetvelocity:Length())
		npc.Velocity = (targvec * 0.3) + (npc.Velocity * 0.7)
		d.targetvelocity = d.targetvelocity * 0.99
	end

	if npc.State == 17 then
		npc.Velocity = Vector.Zero
		if sprite:IsFinished("Death") then
			npc:Kill()
		elseif not sprite:IsPlaying("Death") then
			sprite:Play("Death", true)
		end
	else
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
		if d.npcstate == 1 then
			if sprite:IsFinished("AttackStart") then
				npc.StateFrame = 0
				d.framecount = 0
				d.npcstate = 2
			elseif not (sprite:IsPlaying("AttackStart") or sprite:IsPlaying("Walk")) then
				sprite:Play("Walk",true)
			end
			if sprite:IsPlaying("AttackStart") and sprite:GetFrame() == 1 then
				npc:PlaySound(SoundEffect.SOUND_MOUTH_FULL,0.7,0,false,math.random(120,140)/100)
			elseif sprite:IsPlaying("AttackStart") and sprite:GetFrame() == 13 then
				--npc:PlaySound(SoundEffect.SOUND_MONSTER_YELL_B,0.7,0,false,1)
			end
			if npc.Velocity.X <	0 then
				sprite.FlipX = true
			else
				sprite.FlipX = false
			end
			if npc.StateFrame > 54 + d.delay and not mod:isScareOrConfuse(npc) then
				--npc:PlaySound(SoundEffect.SOUND_RAGMAN_3,0.7,2,false,1.3)
				mod:spritePlay(sprite ,"AttackStart")
			end
		elseif d.npcstate == 2 then
			if not sprite:IsPlaying("AttackLoop") then
				sprite:Play("AttackLoop",true)
			end
			if npc.StateFrame % 3 == 0 then
			local offset
			local dir
			local vecshoot
				if sprite.FlipX then
					offset = 59
					dir = -1
					vecshoot = Vector(-2,-15)
				else
					offset = 32
					dir = 1
					vecshoot = Vector(2,-15)
				end
				local projectile = mod:LazySpawnProjectile(0, 0, npc.Position+vecshoot, Vector(0,5), npc):ToProjectile();
				local projdata = mod:GetEntityData(projectile);
				projectile.FallingSpeed = 0
				projectile.FallingAccel = -0.1
				projectile.ProjectileFlags = projectile.ProjectileFlags | ProjectileFlags.GHOST
				projdata.projType = "craterorbital"
				npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT,1,2,false,1)
				projdata.frameOffset = offset
				projdata.direction = dir
				projectile.Parent = npc
			end

			if npc.StateFrame == 54 or mod:isScareOrConfuse(npc) then
				sprite:Play("AttackRelease",true)
				npc.StateFrame = 0
				d.npcstate = 3
			end
		elseif d.npcstate == 3 then
			if sprite:IsEventTriggered("Shoot") then
				npc:PlaySound(SoundEffect.SOUND_MONSTER_YELL_A,0.7,0,false,1)
				--npc:PlaySound(SoundEffect.SOUND_RAGMAN_2,0.7,2,false,1.2)
				npc.StateFrame = 0
				d.npcstate = 4
			end
		elseif d.npcstate == 4 then
			if sprite:IsFinished("AttackRelease") then
				sprite:Play("Walk",true)
				d.targetvelocity = ((target.Position - npc.Position):Normalized()*2):Rotated(-50+math.random(100))
				npc.StateFrame = 0
				d.delay = math.random(15)
				d.npcstate = 1
			end
		end
	end
end

function mod:craterFaceHurt(npc, damage)
	local variant = npc.Variant
	if variant == 666 then --Blazer
		return false
	elseif variant == 69 then --Muk, Drooler
		if npc:ToNPC().State == 11 then
			return false
		end
	else --Craterface
		if npc:ToNPC().State == 17 then
			return false
		end
	end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.craterFaceHurt, mod.FF.Drooler.ID)

local function getcirclepoint(radius, degree)
	return Vector(radius * math.sin(degree), radius * math.cos(degree))
end

function mod.orbitalprojupdate(v,d)
	if d.projType == "craterorbital" then
	v.Color = mod.ColorNormal
	v.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE

		if v.Parent then
			local pd = mod:GetEntityData(v.Parent)
			if v.Parent:IsDead() or mod:isStatusCorpse(v.Parent) then
				d.targetvelocity = v.Velocity*2
				d.projType = "craterorbital2"
			elseif pd.npcstate < 4 then
				local target = v.Parent.Position
				local frame = v.FrameCount + d.frameOffset

				local xvel = math.cos(((frame * d.direction) / 8.5) + math.pi) * (50 + pd.orbit * 15)
				local yvel = math.sin(((frame * d.direction) / 8.5) + math.pi) * (50 + pd.orbit * 15)

				local direction = Vector(target.X - xvel, target.Y - yvel) - v.Position

				if direction:Length() > 50 then
					direction:Resize(50)
				end

				v.Velocity = direction
			elseif pd.npcstate == 4 then
				d.targetvelocity = v.Velocity*1.5
				d.projType = "craterorbital2"
			end
		else
			d.targetvelocity = v.Velocity*1.5
			d.projType = "craterorbital2"
		end
	elseif d.projType == "craterorbital2" then
		v.Color = mod.ColorNormal
		v.Velocity = (d.targetvelocity * 0.3) + (v.Velocity * 0.7)
		--v.FallingAccel = 0
		if not d.FrameCount then
			d.FrameCount = 0
		else
			d.FrameCount = d.FrameCount + 1
			if d.FrameCount > 300 then
				v:Remove()
			end
		end
		local grid = game:GetRoom():GetGridEntityFromPos(v.Position + v.Velocity)
		if grid then
			if grid:GetType() == GridEntityType.GRID_PILLAR and grid.State ~= 2 then
				v:Die()
			end
		end
	elseif d.projType == "mutantorbital" then
		d.radiusMod = d.radiusMod or 0
		v.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE

		if v.Parent and not (v.Parent:IsDead() or mod:isStatusCorpse(v.Parent)) then
			v.Height = -35
			v.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE

			local pd = mod:GetEntityData(v.Parent)

			if pd.radius then

				local vel = getcirclepoint(pd.radius + math.sin(d.radiusMod) * 9, d.offset)
				local target = v.Parent.Position
				--local frame = v.FrameCount --+ d.frameOffset

				--local xvel = math.cos(((frame + d.offset) / 8.5) + math.pi) * pd.radius
				--local yvel = math.sin(((frame + d.offset) / 8.5) + math.pi) * pd.radius
				--print(tostring(xvel)..", "..tostring(yvel))

				local direction = Vector(target.X - vel.X, target.Y - vel.Y) - v.Position

				if direction:Length() > 50 then
					direction:Resize(50)
				end

				v.Velocity = direction

				if d.offset >= 360 then d.offset = 0 else d.offset = d.offset + 0.1 end
				d.radiusMod = d.radiusMod + math.pi/math.random(3,12)

				if v.Parent:GetSprite():IsPlaying("Attack") or v.Parent:GetSprite():IsPlaying("Attack2") or v.Parent:GetSprite():IsPlaying("DoubleAttack") then
					v.Velocity = v.Velocity / 2
				end
			end
		else
			v.Velocity = v.Velocity * 0.9
			v.FallingAccel = 0.1
		end
	elseif d.projType == "foeorbital" then
		v.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
		if not v.Parent or v.Parent:IsDead() or mod:isStatusCorpse(v.Parent) then
			v.Velocity = v.Velocity * 0.9
			v.FallingAccel = 0.1
		end
	end
end

mod.mukbloodoffset = Vector(13,0)

--DroolerAI
function mod:mukAI(npc)
	local d = mod:GetEntityData(npc)
	local sprite = npc:GetSprite();
	local target = npc:GetPlayerTarget()

	if not d.init then
		d.init = true
		d.npcstate = "idlemove"
	else
		npc.StateFrame = npc.StateFrame + 1
	end

	if npc.State == 11 then
		if sprite:IsFinished("Death") then
			npc:Kill()
		elseif sprite:IsEventTriggered("bloodstart") then
			d.bleeding = true
		elseif not sprite:IsPlaying("Death") then
			sprite:Play("Death", true)
		end
		if d.bleeding then
			if npc.FrameCount % 2 == 0 then
			local blood = Isaac.Spawn(1000, 5, 0, npc.Position, RandomVector()*3, npc):ToEffect();
			blood:Update()

			local bloo2 = Isaac.Spawn(1000, 2, 0, npc.Position, RandomVector()*3, npc):ToEffect();
			bloo2.SpriteScale = Vector(1,1)
			bloo2.SpriteOffset = Vector(-3+math.random(14), -45+math.random(40))
			bloo2:Update()

			npc:PlaySound(SoundEffect.SOUND_MEAT_JUMPS,0.2,0,false,0.8)
			end
		end
	else
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
		d.bleeding = false

		if npc.Velocity.X > 0 then
			sprite.FlipX = true
		else
			sprite.FlipX = false
		end

		if d.npcstate == "idlemove" then
			if not sprite:IsPlaying("Walk") then
				sprite:Play("Walk", true)
			end
			if npc.FrameCount % 3 == 1 then
				local bloodoff = mod.mukbloodoffset
				if sprite.FlipX then
					bloodoff = mod.mukbloodoffset * -1
				end

				local blood = Isaac.Spawn(1000, 7, 0, npc.Position-bloodoff, Vector.Zero, npc)
				blood.SpriteScale = Vector(0.4,0.4)
				blood:Update()
			end
			local targetpos = mod:confusePos(npc, target.Position, 30)
			local vel = mod:reverseIfFear(npc, ((targetpos + target.Velocity*50) - npc.Position):Resized(3))
			npc.Velocity = mod:Lerp(npc.Velocity,vel,0.1)
			if npc.Position:Distance(target.Position) < 200 and npc.StateFrame > 60 and not mod:isScareOrConfuse(npc) then
				d.chargecount = 0
				d.chargestate = 1
				d.playerhit = false
				npc.StateFrame = 0
				sprite:Play("ChargeStart", true)
				d.npcstate = "charge!!!!!"
				npc:PlaySound(mod.Sounds.MukChargeUp,0.6,1,false,0.7)
			end
		elseif d.npcstate == "charge!!!!!" then
			local blood = Isaac.Spawn(1000, 7, 0, npc.Position, Vector.Zero, npc)
			blood.SpriteScale = Vector(0.4,0.4)
			blood:Update()
			if d.chargestate == 1 then
				if sprite:IsFinished("ChargeStart") then
				d.chargestate = 2
				end
			elseif d.chargestate == 2 then
				npc.Velocity = (target.Position - npc.Position):Resized(17)
				if target.Position.Y < npc.Position.Y then
					d.fireangle = "Up"
				else
					d.fireangle = "Down"
				end
				sprite:Play("Charge" .. d.fireangle .. "Loop", true)
				local sfxpitch = math.random(100,120) / 100
				npc:PlaySound(mod.Sounds.MukCharge,1,1,false,sfxpitch)
				d.chargecount = d.chargecount+1
				npc.StateFrame = 0
				d.chargestate = 3
			elseif d.chargestate == 3 then
				npc.Velocity = npc.Velocity * 0.95
				if npc.StateFrame > 20 then
					npc.Velocity = npc.Velocity * 0.8
					if sprite:IsFinished("Charge" .. d.fireangle .. "Miss") then
						if d.playerhit == true then
							d.npcstate = "laugh"
						elseif d.chargecount > 2 or mod:isScareOrConfuse(npc) then
							d.npcstate = "barf"
						else
							npc.StateFrame = 0
							d.chargestate = 2
						end
					else
						mod:spritePlay(sprite,"Charge" .. d.fireangle .. "Miss")
					end
				end
			end
		elseif d.npcstate == "barf" then
			npc.Velocity = npc.Velocity * 0.8
			if sprite:IsFinished("Barf") then
				d.npcstate = "idlemove"
			elseif sprite:IsEventTriggered("horksfx") then
				npc:PlaySound(SoundEffect.SOUND_DEATH_BURST_SMALL,1,0,false,0.7)
			elseif sprite:IsEventTriggered("vomsfx") then
				npc:PlaySound(mod.Sounds.MukVomit,1,1,false,1)
			elseif sprite:IsEventTriggered("creep") then
				d.Vomming = true
				npc.StateFrame = 1
			elseif not sprite:IsPlaying("Barf") then
				sprite:Play("Barf", true)
			end

			if d.Vomming then
				local creep = Isaac.Spawn(1000, 22, 0, npc.Position, Vector.Zero, npc):ToEffect()
				creep.SpriteScale = Vector(4.5, 3.5);
				creep.Parent = npc
				creep.Scale = npc.StateFrame / 6
				creep.SpawnerEntity = npc
				mod:GetEntityData(creep).Pool = true
				if npc.StateFrame > 5 then
					d.Vomming = false
				end
				creep:Update()
			end


		elseif d.npcstate == "laugh" then
			npc.Velocity = npc.Velocity * 0.8
			if sprite:IsFinished("ChargeHit") then
				d.npcstate = "idlemove"
			elseif sprite:IsEventTriggered("laughing sound") then
				npc:PlaySound(mod.Sounds.MukLaugh,1,1,false,1)
			else
				mod:spritePlay(sprite,"ChargeHit")
			end
		end
	end
end

function mod.mukDeathAnim(npc)
	local onCustomDeath = function(npc, deathAnim)
		deathAnim.State = 11
	end
	mod.genericCustomDeathAnim(npc, nil, nil, onCustomDeath)
end

--Blazer
function mod:blazerAI(npc)
	local room = game:GetRoom()
	local d = mod:GetEntityData(npc)
	local sprite = npc:GetSprite();
	local target = npc:GetPlayerTarget()

	if not d.init then
		d.init = true
		npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_BLOOD_SPLASH)
		d.npcstate = "idlemove"
		d.targetVelocity = Vector(1, 1):Resized(5)
	else
		npc.StateFrame = npc.StateFrame + 1
	end

	if room:IsClear() and npc.State ~= 11 then
		npc.State = 11
		npc:PlaySound(SoundEffect.SOUND_DEVILROOM_DEAL,1,1,false,1)
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	end

	if npc.State == 11 then
		npc.Velocity = Vector.Zero
		if sprite:IsFinished("Death") then
			npc:Kill()
		elseif not sprite:IsPlaying("Death") then
			sprite:Play("Death", true)
		end
	else
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL

		if d.npcstate == "idlemove" then
			if not sprite:IsPlaying("Idle") then
				sprite:Play("Idle", true)
			end

			if npc.Velocity.X < 0 then
				sprite.FlipX = true
			else
				sprite.FlipX = false
			end

			--[[if npc:CollidesWithGrid() == true then
			d.targetVelocity = mod.bounceOffWall(npc.Position, d.targetVelocity)
			end]]
			--npc.Velocity = (d.targetVelocity * 0.3) + (npc.Velocity * 0.6)
			mod:diagonalMove(npc, 2.5)

			if npc.Position:Distance(target.Position) < 200 and npc.StateFrame > 60 then
				d.prevvel = npc.Velocity
				d.chargecount = 0
				d.chargestate = 1
				d.playerhit = false
				npc.StateFrame = 0

				local targvec = target.Position - npc.Position
				if math.abs(targvec.X) > math.abs(targvec.Y) then
					d.fireangle = "Side"
				else
					d.fireangle = "Front"
				end
				sprite:Play("Charge" .. d.fireangle .. "Start", true)
				d.npcstate = "charge!!!!!"
				local sfxpitch = math.random(9,11) / 10
				npc:PlaySound(mod.Sounds.EpicTwinkle,1,1,false,sfxpitch)
			end
		elseif d.npcstate == "charge!!!!!" then

			if d.chargestate == 1 then
				if target.Position.X < npc.Position.X then
					sprite.FlipX = true
				else
					sprite.FlipX = false
				end
			else
				if npc.Velocity.X < 0 then
					sprite.FlipX = true
				else
					sprite.FlipX = false
				end
			end


			if d.chargestate == 1 then
				npc.Velocity = npc.Velocity * 0.9
				if sprite:IsFinished("Charge" .. d.fireangle .. "Start") then
				d.chargestate = 2
				end
			elseif d.chargestate == 2 then
				npc.Velocity = (target.Position - npc.Position):Resized(19.5)
				sprite:Play("Charge" .. d.fireangle, true)
				local sfxpitch = math.random(90,105) / 100
				npc:PlaySound(SoundEffect.SOUND_MONSTER_YELL_A,1,1,false,sfxpitch)
				d.chargecount = d.chargecount+1
				npc.StateFrame = 0
				d.chargestate = 3

				local fire = Isaac.Spawn(1000,7005, 2, npc.Position, Vector.Zero, npc):ToEffect()
				fire:Update()

			elseif d.chargestate == 3 then
				npc.Velocity = npc.Velocity * 0.95
				if npc.StateFrame > 20 then
					npc.Velocity = npc.Velocity * 0.8
					if d.chargecount > 0 then
						d.npcstate = "idlemove"
						local xvalue
						local yvalue
						if npc.Velocity.X > 0 then
							xvalue = 1
						else
							xvalue = -1
						end
						if npc.Velocity.Y > 0 then
							yvalue = 1
						else
							yvalue = -1
						end
						d.targetVelocity = Vector(xvalue, yvalue):Resized(5)
					else
						npc.StateFrame = 0
						d.chargestate = 2
						local targvec = target.Position - npc.Position
						if math.abs(targvec.X) > math.abs(targvec.Y) then
							d.fireangle = "Side"
						else
							d.fireangle = "Front"
						end
					end
				elseif npc.StateFrame < 16 then
					if npc.StateFrame % 2 == 0 then
					local fire = Isaac.Spawn(1000,7005, 2, npc.Position, Vector.Zero, npc)
					fire:Update()
					end
				end
			end
		end
	end
end

function mod:mukCollision(npc, player, mysteryBoolean)
  local d = mod:GetEntityData(npc:ToNPC())

  if npc.Variant == 69 and player.Type == 1 then
	if d.chargestate == 2 or d.chargestate == 3 then
		d.playerhit = true
	end
  end

end
mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION , mod.mukCollision, mod.FF.Drooler.ID)


--Run Craterface, Muk and Blazer AI
function mod:checkCraterFace(npc)
    local variant = npc.Variant
	if variant == mod.FF.Blazer.Var then
		mod:blazerAI(npc)
	elseif variant == mod.FF.Drooler.Var then
		mod:mukAI(npc)
	else
		mod:craterFaceAI(npc)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkCraterFace, mod.FF.Blazer.ID)
