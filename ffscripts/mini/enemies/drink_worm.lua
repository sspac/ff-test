local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector(0, 0)

function mod:drinkwormai(npc, sprite, npcdata)
	if not npcdata.init then
		npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
		npcdata.state = "idle"
		npcdata.idletimer = math.random(15, 30)
		npcdata.burrowedtimer = 0
		npcdata.init = true
		npcdata.firstdig = false
		npcdata.burrowcheck = false
		npc.TargetPosition = npc.Position
	end
	if REPENTOGON then
		npc:UpdateDirtColor()
	end
	npc.Position = npc.TargetPosition
	if not mod:InsideClodUpdate(npc, sprite, npcdata) then
		npc.Velocity = Vector.Zero
	end
	if npcdata.state == "idle" then
		if npcdata.idletimer > 0 then
			npcdata.idletimer = npcdata.idletimer - 1
			mod:spritePlay(sprite, "idle")
		else
			if npcdata.projectile == nil then
				if npcdata.firstdig then
					mod:spritePlay(sprite, "diginspit")
				else
					mod:spritePlay(sprite, "diginspitless")
					npcdata.firstdig = true
					npcdata.extraVariableToFixABug = true
				end
				npcdata.state = "burrow"
			else
				npc:PlaySound(SoundEffect.SOUND_MAGGOTCHARGE,1,1,false,1.5)
				mod:spritePlay(sprite, "startsuckinboy")
				npcdata.state = "suck"
			end
		end
	elseif npcdata.state == "burrow" then
		if sprite:IsFinished("diginspit") or sprite:IsFinished("diginspitless") then
			npcdata.burrowedtimer = math.random(15,30)
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			mod:spritePlay(sprite, "burrowed")
		elseif sprite:IsFinished("digout") then
			mod:spritePlay(sprite, "idle")
			npcdata.idletimer = math.random(20, 40)
			npcdata.state = "idle"
		elseif not (sprite:IsPlaying("diginspit") or sprite:IsPlaying("digout") or sprite:IsPlaying("diginspitless")) then
			if npcdata.burrowedtimer <= 0 then
				mod:spritePlay(sprite, "digout")
				npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
				if REPENTOGON then
					npc:UpdateDirtColor(true)
				end
				if npcdata.extraVariableToFixABug then
					local filter = function(ent) return not mod:GetEntityData(ent).WormClaimed end
					if not mod:TryEnterClod(npc, sprite, npcdata, filter) then
						npc.TargetPosition = mod:FindRandomValidPathPosition(npc, 2, 120)
						npcdata.extraVariableToFixABug = false
					end
				else
					local filter
					if npcdata.projectile and npcdata.projectile:Exists() then
						filter = function(ent)
							if npcdata.projectile ~= nil then
								return game:GetRoom():CheckLine(ent.Position,npcdata.projectile.Position,3) and not mod:GetEntityData(ent).WormClaimed
							else
								return not mod:GetEntityData(ent).WormClaimed
							end
						end
					else
						filter = function(ent) return not mod:GetEntityData(ent).WormClaimed end
					end
					if not mod:TryEnterClod(npc, sprite, npcdata, filter) then
						npc.TargetPosition = mod:drinkwormfindpos(npc, npcdata)
					end
				end
				if npcdata.projectile ~= nil then
					if sprite.FlipX and npcdata.projectile.Position.X < npc.Position.X then
						sprite.FlipX = false
					elseif npcdata.projectile.Position.X > npc.Position.X then
						sprite.FlipX = true
					end
				end
			else
				npcdata.burrowcheck = true
				npcdata.burrowedtimer = npcdata.burrowedtimer - 1
				for _, i in ipairs(Isaac.FindByType(666, 100, -1, false, false)) do
					if npcdata.burrowedtimer == mod:GetEntityData(i).burrowedtimer and GetPtrHash(i) ~= GetPtrHash(npc) and npcdata.burrowcheck == false then
						npcdata.burrowedtimer = npcdata.burrowedtimer + math.random(1, 3)
						--print(npcdata.burrowedtimer)
						--print(mod:GetEntityData(i).burrowedtimer)
					end
				end
				npcdata.burrowcheck = false
			end
		end
	elseif npcdata.state == "suck" then
		if sprite:IsFinished("startsuckinboy") then
			mod:spritePlay(sprite, "suck")
		elseif sprite:IsFinished("stopsuck") then
			mod:spritePlay(sprite, "idle")
			npcdata.idletimer = math.random(30, 45)
			npcdata.state = "idle"
		elseif sprite:IsFinished("catchbullet") then
			mod:spritePlay(sprite, "diginspit")
			npcdata.state = "burrow"
		elseif (npcdata.projectile ~= nil) then
			if (npc.Position - npcdata.projectile.Position):Length() <= 10 then
				npcdata.projectile:Remove()
				mod:spritePlay(sprite, "catchbullet")
				npc:PlaySound(SoundEffect.SOUND_LITTLE_SPIT,0.75,0,false,3)
			else
				local anglebetween = (npc.Position - npcdata.projectile.Position):GetAngleDegrees()
				npcdata.projectile.Velocity = mod:Lerp(npcdata.projectile.Velocity, Vector(15, 0):Rotated(anglebetween), 0.075)
			end
		elseif not sprite:IsPlaying("catchbullet") then
			mod:spritePlay(sprite, "stopsuck")
		end
	end
	--projectiley shit
	if sprite:IsEventTriggered("spit") then
		npc:PlaySound(SoundEffect.SOUND_PLOP,0.4,1,false,2)
		npcdata.projectile = mod:LazySpawnProjectile(0, 0, npc.Position, Vector(0,0), npc):ToProjectile();
		npcdata.projectile.FallingSpeed = -3
		npcdata.projectile.FallingAccel = -0.1
		--npcdata.projectile:AddHeight(-5)
	end
	if npcdata.projectile then
		if npcdata.projectile.FallingAccel >= 0.15 and npcdata.projectile.FallingSpeed >= 0 and not (npc:HasEntityFlags(EntityFlag.FLAG_FEAR) or npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION)) then
			npcdata.projectile.FallingAccel = -0.1
		end
		if npcdata.projectile:CollidesWithGrid() or npcdata.projectile:IsDead() then
			npcdata.projectile = nil
		end
		if (npc:IsDead() or npc:HasEntityFlags(EntityFlag.FLAG_FEAR) or npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION) or mod:isLeavingStatusCorpse(npc)) and npcdata.projectile ~= nil then
			npcdata.projectile.FallingAccel = 1
		end
	end
end

function mod:checkposdistancefroment(pos, typeoguy, variant, distance)
	--put variant as -1 to just find any
	local ents = Isaac.FindByType(typeoguy, variant, -1, false, false)
	for _, i in ipairs(ents) do
		if (pos - i.Position):Length() < distance then
			return false
		elseif typeoguy == 1 and (pos - (i.Position + (i.Velocity * 8))):Length() < distance then
			return false
		end
	end
	return true;
end

function mod:drinkwormfindpos(npc, npcdata)
	local room = game:GetRoom()
	local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local vptablelength = 1
	local validpositions = {}
	local size = room:GetGridSize()
	for i = 0, size do
		local grident = room:GetGridEntity(i)
		if ((not grident) or (room:GetGridCollision(i) == GridCollisionClass.COLLISION_NONE and (grident:GetType() ~= GridEntityType.GRID_SPIKES and grident:GetType() ~ GridEntityType.GRID_SPIKES_ONOFF) or grident:GetType() == GridEntityType.GRID_SPIDERWEB)) and room:IsPositionInRoom(room:GetGridPosition(i), 15) then
			if (mod:checkposdistancefroment(room:GetGridPosition(i), 1, -1, 100)
			and mod:checkposdistancefroment(room:GetGridPosition(i), 666, 100, 40)
			and (npcdata.projectile == nil or (room:CheckLine(room:GetGridPosition(i),npcdata.projectile.Position,3,1,false,false))
			and (room:GetGridPosition(i) - npcdata.projectile.Position):Length() > 80))
			and not mod:IsCampfireWithinRadius(room:GetGridPosition(i), 40)
			then
				table.insert(validpositions, i)
				vptablelength = vptablelength + 1
			end
		end
	end
	if vptablelength == 1 then
		return npc.Position
	else
		return room:GetGridPosition(validpositions[math.random(1, vptablelength - 1)])
	end
end

--DRUNK WORM BEGINS
function mod:doProjectilesLoveMe(npc, returnCount)
	local entitycount = {}
	for index,proj in ipairs(Isaac.FindByType(9, -1, -1, EntityPartition.BULLET, true)) do
		if proj.SpawnerEntity and (proj.SpawnerEntity.InitSeed == npc.InitSeed) then
			table.insert(entitycount, proj)
		end
	end
	if returnCount then
		return #entitycount
	else
		if #entitycount > 0 then
			return true
		else
			return false
		end
	end
end

-- i didn't move drunk worm into its own file because mini didn't make it and i dont want to mess with erf's stuff (- catinsurance)
-- that is okay cat I will move them anyway
function mod:drunkwormai(npc, sprite, d)
	if not d.init then
		d.state = "idle"
		d.init = true
		npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
		npc.TargetPosition = npc.Position
	else
		npc.StateFrame = npc.StateFrame + 1
	end

	if REPENTOGON then
		npc:UpdateDirtColor()
	end

	if d.state == "idle" then
		mod:spritePlay(sprite, "idle")
		d.KillAllBabies = true
		if (npc.StateFrame > 5 and math.random(10) == 1) or npc.StateFrame > 30 then
			d.state = "spitout"
			d.vec = RandomVector()
			d.ang = 0
			d.KillAllBabies = nil
		end
	elseif d.state == "spitout" then
		if sprite:IsFinished("spitfull") then
			d.state = "diggyhole"
		elseif sprite:IsEventTriggered("spit") then
			d.vec = d.vec or RandomVector()
			local vec = d.vec:Resized(math.random(9, 12)):Rotated(d.ang * 120)
			local proj = mod:LazySpawnProjectile(0,0,npc.Position, vec, npc):ToProjectile()
			mod:GetEntityData(proj).projType = "drunkworm"
			proj:AddProjectileFlags(ProjectileFlags.BOUNCE)
			proj.SpawnerEntity = npc
			proj:AddScale(1)
			proj.Height = -50
			proj.SpriteOffset = Vector(0, -30)
			proj.FallingAccel = 0
			proj.FallingSpeed = 0
			proj:Update()
			d.ang = d.ang + 1

			npc:PlaySound(SoundEffect.SOUND_LITTLE_SPIT,0.75,0,false,math.random(70,80)/100)
			for i = -60, 60, 30 do
				local smoke = Isaac.Spawn(1000, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, npc.Position, Vector(0, -5):Rotated(i - 10 + math.random(20)), npc):ToEffect()
				smoke.SpriteRotation = math.random(360)
				smoke.Color = Color(1,1,1,0.5,0.7,0,0)
				smoke.SpriteScale = smoke.SpriteScale * math.random(70,100)/100
				smoke.SpriteOffset = Vector(0, -50)
				smoke.RenderZOffset = 500
				smoke:Update()
			end
			local poof = Isaac.Spawn(1000, 16, 960, npc.Position, nilvector, npc):ToEffect()
			if sprite.FlipX then
				poof:GetSprite().FlipX = true
			end
			poof.Color = Color(1,1,1,0.3,0,0,0)
			poof.RenderZOffset = 100
			poof.SpriteOffset = Vector(0, -55)
			poof.SpriteScale = Vector(0.5,0.5)
			poof:FollowParent(npc)
			poof:Update()
		else
			mod:spritePlay(sprite, "spitfull")
		end
	elseif d.state == "diggyhole" then
		if sprite:IsFinished("digin") then
			d.state = "comeOut"
			npc.StateFrame = 0
			d.spawned = false
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		elseif sprite:IsEventTriggered("dig1") then

		elseif sprite:IsEventTriggered("dig2") then
			npc.CollisionDamage = 0
		else
			mod:spritePlay(sprite, "digin")
		end
	elseif d.state == "comeOut" then
		if d.spawned then
			if sprite:IsFinished("digout") then
				npc.CollisionDamage = 1
				d.askingforadvice = false
				if mod:doProjectilesLoveMe(npc) then
					d.state = "suck"
					d.suckAttempts = 0
				else
					d.state = "idle"
				end
				npc.StateFrame = 0
			elseif sprite:IsEventTriggered("dig1") then
				npc.CollisionDamage = 1
			else
				mod:spritePlay(sprite, "digout")
			end
		else
			if (npc.StateFrame >= 15 and math.random(15) == 1) or npc.StateFrame > 45 then
				npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
				if not mod:TryEnterClod(npc, sprite, d) then
					local pos = mod:FindRandomFreePos(npc, 120, false, true, true)
					npc.Position = pos
					npc.TargetPosition = npc.Position
					if REPENTOGON then
						npc:UpdateDirtColor(true)
					end
				end
				d.askingforadvice = true
				d.spawned = true
			end
		end
	elseif d.state == "suck" then
		mod:spritePlay(sprite, "suck")
		if sprite:IsEventTriggered("suck") then
			d.sucking = true
			d.suckAttempts = d.suckAttempts + 1
			npc:PlaySound(SoundEffect.SOUND_PORTAL_SPAWN,0.3,0,false,math.random(190,210)/100)
		elseif sprite:IsEventTriggered("stop") then
			d.sucking = false
		end
		if d.sucking then
			local vec = Vector(-40, 20)
			if sprite.FlipX then
				vec = Vector(vec.X * -1, vec.Y)
			end
			vec = vec:Rotated(-30 + math.random(60))
			local smoke = Isaac.Spawn(1000, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 960, npc.Position + vec, vec:Resized(-7), npc):ToEffect()
			smoke.SpriteRotation = math.random(360)
			smoke.Color = Color(1,1,1,0.1,0.5,0.5,0.5)
			smoke.SpriteScale = smoke.SpriteScale * math.random(70,100)/100
			smoke.SpriteOffset = Vector(0, -25)
			smoke.RenderZOffset = 500
			mod:GetEntityData(smoke).shrink = 0.95
			smoke:Update()
	else
			if not mod:doProjectilesLoveMe(npc) or d.suckAttempts > 4 then
				d.state = "idle"
				npc.StateFrame = 0
				d.KillAllBabies = true
			end
		end
	end
	npc.Position = npc.TargetPosition
	if not mod:InsideClodUpdate(npc, sprite, d) then
		npc.Velocity = Vector.Zero
	end
end

function mod.drunkwormProj(v,d)
	if d.projType == "drunkworm" then
		v.SpriteOffset = mod:Lerp(v.SpriteOffset, nilvector, 0.1)
		if v.SpawnerEntity and v.SpawnerEntity:Exists() and not mod:isStatusCorpse(v.SpawnerEntity) then
			local vd = mod:GetEntityData(v.SpawnerEntity)
			v.FallingAccel = -0.1
			v.FallingSpeed = 0
			if v.Height < -20 then
				v.Height = v.Height + 1
			end
			v.SpriteOffset = mod:Lerp(v.SpriteOffset, nilvector, 0.1)
			if vd.sucking then
				v.Velocity = mod:Lerp(v.Velocity, (v.SpawnerEntity.Position - v.Position):Resized(11), 0.1)
			else
				if vd.state == "suck" then
					v.Velocity = v.Velocity * 0.9
				else
					v.Velocity = v.Velocity * 0.93
				end
			end
			if v.SpawnerEntity.Position:Distance(v.Position) < 10 and vd.state == "suck" then
				v:Die()
			end
			if vd.askingforadvice then
				if v.Position.X > v.SpawnerEntity.Position.X then
					v.SpawnerEntity:GetSprite().FlipX = true
				else
					v.SpawnerEntity:GetSprite().FlipX = false
				end
				vd.askingforadvice = nil
			end
			if vd.KillAllBabies then
				v.SpawnerEntity = nil
				v.FallingAccel = 0.5
			end
		else
			v.FallingAccel = 0.5
		end
	end
end