local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

--this [FILE] makes projectiles have special effects and aesthetics! i'll kill you

-- Contains callbacks that run for ALL projectiles. Merging such logic into singular shared callbacks allows for more optimization.
-- Call your generic projectile logic from here to save on GetData calls and whatnot.
-- Side thought: Running callbacks on ProjectileVariant.PROJECTILE_NORMAL instead of calling functions from here MIGHT not be worth it
-- considering that the callbacks here will run anyway, and normal projectiles are by far the most common. Other variants though, sure go for it.


-- TODO: Make it so that more instances of generic projectile callbacks across the mod are functions called from the shared callbacks here.
-- Namely MC_POST_PROJECTILE_UPDATE, MC_PRE_PROJECTILE_COLLISION
-- Might also be able to migrate more projectile death effects to MC_POST_PROJECTILE_DEATH


-- Stores Update/PreCollision/PostCollision/Death callbacks for FF projectile types identified by a string stored as `data.projType`
local FF_PROJECTILE_TYPE_FUNCS = {
	["dank slime"] = {
		Death = function(projectile, data)
			Isaac.Spawn(mod.FF.TarBubble.ID, mod.FF.TarBubble.Var, 0, projectile.Position, Vector.Zero, projectile.SpawnerEntity or projectile)
		end,
	},
	["septic slime"] = {
		Death = function(projectile, data)
			local slime = Isaac.Spawn(mod.FF.TarBubble.ID, mod.FF.TarBubble.Var, 8, projectile.Position, Vector.Zero, projectile.SpawnerEntity or projectile)

			local sprite = slime:GetSprite()
			sprite:ReplaceSpritesheet(0, "gfx/bosses/tsar/slime_septic.png")
			sprite:LoadGraphics()
		end,
	},
	["pee slime"] = {
		Death = function(projectile, data)
			local slime = Isaac.Spawn(mod.FF.TarBubble.ID, mod.FF.TarBubble.Var, 9, projectile.Position, Vector.Zero, projectile.SpawnerEntity or projectile)

			local sprite = slime:GetSprite()
			sprite:ReplaceSpritesheet(0, "gfx/bosses/tsar/slime_pee.png")
			sprite:LoadGraphics()
		end
	},
	["poop slime"] = {
		Death = function(projectile, data)
			local slime = Isaac.Spawn(mod.FF.TarBubble.ID, mod.FF.TarBubble.Var, 10, projectile.Position, Vector.Zero, projectile.SpawnerEntity or projectile)

			local sprite = slime:GetSprite()
			sprite:ReplaceSpritesheet(0, "gfx/bosses/tsar/slime_poop.png")
			sprite:LoadGraphics()
		end
	},
	["thrownbomb"] = {
		Update = function(v, d)
			if not d.replacesprite then
				local s = v:GetSprite()
				s:Load("gfx/projectiles/projectile_bomb.anm2", true)
				if d.projTypeS then
					s:Play("Golden", true)
				elseif d.pinkBomb then
					s:Play("Red", true)
				elseif d.poopBomb then
					s:Play("Poop", true)
				elseif d.copperBomb then
					s:Play("Copper", true)
				else
					s:Play("Normal", true)
				end
				d.replacesprite = true
			end
			v.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			if v:IsDead() then
				if d.projTypeS then
					local bomb = Isaac.Spawn(4, 0, 0, v.Position, v.Velocity, v)
					bomb.SpawnerEntity = v.SpawnerEntity
					local bs = bomb:GetSprite()
					bs:Load("gfx/projectiles/goldbomb.anm2",true)
					bs:Play("Pulse",true)
				elseif d.pinkBomb then
					local bomb = Isaac.Spawn(4, 13, 0, v.Position, v.Velocity, v):ToBomb()
					bomb:ToBomb():SetExplosionCountdown(20)
					bomb.SpawnerEntity = v.SpawnerEntity
				elseif d.copperBomb then
					local bomb = Isaac.Spawn(4, 923, 0, v.Position, v.Velocity, v):ToBomb()
					bomb.ExplosionDamage = bomb.ExplosionDamage * 1.85
					mod:GetEntityData(bomb).FFCopperBomb = true
					bomb:ToBomb():SetExplosionCountdown(20)
					bomb.SpawnerEntity = v.SpawnerEntity
				elseif d.poopBomb then
					local bomb = Isaac.Spawn(4, 9, 0, v.Position, v.Velocity, v):ToBomb()
					bomb:ToBomb():SetExplosionCountdown(20)
					bomb.SpawnerEntity = v.SpawnerEntity
				else
					local bomb = Isaac.Spawn(4, 0, 0, v.Position, v.Velocity, v)
					bomb.SpawnerEntity = v.SpawnerEntity
				end
				v:Remove()
			end
		end,
	},
	["buckbomb"] = {
		Update = function(v, d)
			if not d.replacesprite then
				local s = v:GetSprite()
				s:Load("gfx/projectiles/projectile_bomb.anm2", true)
				if d.projTypeS then
					s:Play("Golden", true)
				else
					s:Play("Normal", true)
				end
				d.replacesprite = true
			end
			v.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			if v:IsDead() then
				--local snagger = mod.FindClosestEntity(v.Position,100,mod.FF.Snagger.ID,mod.FF.Snagger.Var,0)

				--if snagger ~= nil then
					local bomb = Isaac.Spawn(5, 40, 1, v.Position, v.Velocity:Resized(math.min(v.Velocity:Length(), 7)), v)
					bomb:GetSprite():Play("Idle", true)
					bomb.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
					mod:GetEntityData(bomb).buckBomb = true
					bomb.SpawnerEntity = v.SpawnerEntity
					bomb:Update()
					if d.projTypeS then
						local bs = bomb:GetSprite()
						bs:Load("gfx/projectiles/goldbomb.anm2",true)
						bs:Play("Pulse",true)
					end
				--else
				--	Isaac.Explode(v.Position, v, 10)
				--end

				--if d.projTypeS then
				--local bs = bomb:GetSprite()
				--bs:Load("gfx/projectiles/goldbomb.anm2",true)
				--bs:Play("Pulse",true)
				--end
				v:Remove()
			end
		end,
	},
	["NoColl"] = {
		Update = function(v, d)
			v.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		end,
	},
	["CricBod"] = {
		Death = function(v, d)
			sfx:Play(SoundEffect.SOUND_MEAT_IMPACTS, 1, 0, false, 1.5)
			local vec = RandomVector()*5
			for i = 90, 360, 90 do
				local projectile = mod:LazySpawnProjectile(0, 0, v.Position + vec:Rotated(i), vec:Rotated(i), v):ToProjectile()
				projectile.FallingSpeed = -10
				projectile.FallingAccel = 1.5
				projectile.ProjectileFlags = v.ProjectileFlags
			end
		end,
	},
	["CricBod2"] = {
		Death = function(v, d)
			sfx:Play(SoundEffect.SOUND_MEAT_IMPACTS, 1, 0, false, 1.5)
			local vec = Vector(5,0)
			for i = 90, 360, 90 do
				local projectile = mod:LazySpawnProjectile(0, 0, v.Position + vec:Rotated(i), vec:Rotated(i), v):ToProjectile()
				projectile.FallingSpeed = -10
				projectile.FallingAccel = 1.5
				projectile.ProjectileFlags = v.ProjectileFlags
			end
		end,
	},
	["yummer"] = {
		Death = function(v, d)
			sfx:Play(SoundEffect.SOUND_MEAT_IMPACTS, 1, 0, false, 1.5)
			local vec = Vector(9,0)
			for i = 45, 360, 45 do
				local projectile = mod:LazySpawnProjectile(0, 0, v.Position + vec:Rotated(i), vec:Rotated(i), v):ToProjectile()
				projectile.FallingSpeed = -10
				projectile.FallingAccel = 1.5
				projectile.ProjectileFlags = v.ProjectileFlags
			end
		end
	},
	["superGrimace"] = {
		Update = function(v, d)
			v.Velocity = v.Velocity * math.max(0.5,(1 - v.FrameCount / 200))
		end,
		Death = function(v, d)
			for i = 90, 360, 90 do
				local shootvec = Vector(9,0):Rotated(i)
				local proj = mod:LazySpawnProjectile(0,0,v.Position + shootvec:Resized(10), shootvec, v):ToProjectile()
				mod:makeProjectileConsiderFriend(v.SpawnerEntity, proj)
				proj:Update()
			end
			sfx:Play(SoundEffect.SOUND_DEATH_BURST_SMALL)
		end,
	},
	["GraterShot"] = {
		Death = function(v, d)
			local creep = Isaac.Spawn(1000, 26, 0, v.Position, mod.nilvector, v):ToEffect()
			creep.SpriteScale = Vector(4, 4)
			creep:SetTimeout(100)
			creep:Update()
		end,
	},
	["boomerang"] = {
		Update = function(v, d)
			--[[if not sfx:IsPlaying(SoundEffect.SOUND_ULTRA_GREED_SPINNING) then
				sfx:Play(SoundEffect.SOUND_ULTRA_GREED_SPINNING, 0.2, 0, true, 1)
			end
			if v:IsDead() then
				sfx:Stop(SoundEffect.SOUND_ULTRA_GREED_SPINNING)
			end]]
			if v.Position:Distance(d.origpos) < 3 and v.FrameCount > 20 then
				v.Velocity = mod.nilvector
				v.FallingAccel = 1
			end
			if d.state == 1 then
				if v.Velocity:Length() > 10 then
					v.Velocity = v.Velocity:Resized(15)
				elseif v.Velocity:Length() < 10 then
					v.Velocity = v.Velocity * 1.08
				end
				if v.Velocity:Length() < 2.5 then
					v.Velocity = v.Velocity * 1.08
				end
			else
				v.Velocity = v.Velocity * 0.92
				if v.Velocity:Length() < 2.5 then
					v.Velocity = v.Velocity * 0.92
				end
				if v.Velocity:Length() < 0.5 then
					v.Velocity = v.Velocity * -1
					d.state = 1
				end
			end
		end,
	},
	["dank trail"] = {
		Update = function(v, d)
			if v.FrameCount % 3 == 0 then
				local creep = Isaac.Spawn(1000, 26, 0, v.Position+RandomVector()*10, mod.nilvector, v):ToEffect()
				creep:SetTimeout(150)
				creep:Update()
			end
		end,
	},
	["septic trail"] = {
		Update = function(v, d)
			if v.FrameCount % 3 == 0 then
				local c = Isaac.Spawn(1000, 23, 0, v.Position+RandomVector()*10, mod.nilvector, v):ToEffect()
				c.Timeout = 150
			end
		end,
		Death = function(v, d)
			local c = Isaac.Spawn(1000, 23, 0, v.Position, mod.nilvector, v)
			c.SpriteScale = Vector(2.5, 2.5)
			c:Update()
		end,
	},
	["quick septic trail"] = {
		Update = function(v, d)
			if v.FrameCount % 3 == 0 then
				local c = Isaac.Spawn(1000, 23, 0, v.Position, mod.nilvector, v):ToEffect()
				c.SpriteScale = Vector(0.8, 0.8)
				c:Update()
				c.Timeout = 45
			end
		end,
	},
	["boomerang2"] = {
		Update = function(v, d)
			--[[if not sfx:IsPlaying(SoundEffect.SOUND_ULTRA_GREED_SPINNING) then
				sfx:Play(SoundEffect.SOUND_ULTRA_GREED_SPINNING, 0.2, 0, true, 1)
			end
			if v:IsDead() then
				sfx:Stop(SoundEffect.SOUND_ULTRA_GREED_SPINNING)
			end]]
			v.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
			if d.origparent and not mod:IsReallyDead(d.origparent) then
				d.origpos = d.origparent.Position
			end
			if d.origpos then
				d.rot = d.rot or 0
				local resize = 10
				if d.rot == 0 or d.fasterReturn then
					resize = 12
				end
				local targetvel = (d.origpos - v.Position):Resized(resize)
				d.rot = d.rot / (1 + (v.FrameCount * 0.001))
				v.Velocity = mod:Lerp(v.Velocity, targetvel, 0.01 + (v.FrameCount*0.001)):Rotated(d.rot)
				local returnDist = d.fadeOut and d.fadeOut * 10 or 15
				if v.Position:Distance(d.origpos) < returnDist and v.FrameCount > 20 then
					if v.Parent then
						mod:GetEntityData(v.Parent).npcState = "Submerge"
						--sfx:Stop(SoundEffect.SOUND_ULTRA_GREED_SPINNING)
						if d.fadeOut then
							d.projType = nil
							mod:FadeOut(v, d.fadeOut)
							mod.scheduleForUpdate(function()
								sfx:Play(SoundEffect.SOUND_BONE_DROP,1,2,false,1.3)
								v:Remove()
							end, d.fadeOut)
						else
							sfx:Play(SoundEffect.SOUND_BONE_DROP,1,2,false,1.3)
							v:Remove()
						end
					end
				end
			end
			if v.Parent then
				if v.Parent:IsDead() then
					v.FallingSpeed = 1
				end
				if mod:GetEntityData(v.Parent).npcState == "Appear" then
					v.Parent = nil
				end
			else
				v.FallingSpeed = 1
			end
		end,
	},
	["blot"] = {
		Update = function(v, d)
			local s = v:GetSprite()
			if not d.anim then
				s:Load("gfx/enemies/blot/monster_blot.anm2",true)
				d.anim = mod:getRandomBlotSprite()
				s:ReplaceSpritesheet(0, "gfx/enemies/blot/monster_blot_"..d.anim.name..".png")
				s:LoadGraphics()
				s:Play("InAir",false)
			end
			s.Offset = Vector(0,-10)
		end,
		Death = function(v, d)
			local blot = mod.spawnent(v, v.Position, mod.nilvector, mod.FF.Blot.ID, mod.FF.Blot.Var)
			mod:GetEntityData(blot).anim = d.anim
			blot:GetSprite():ReplaceSpritesheet(0, "gfx/enemies/blot/monster_blot_"..d.anim.name..".png")
			blot:GetSprite():LoadGraphics()
			--if not blot:ToNPC().Pathfinder:HasPathToPos(blot:GetPlayerTarget().Position, false) then blot:ToNPC():Morph(950,0,0,-1) end--make sure theyre not spawned at a position where the player cant reach them
			--fiddle with this some more as it seems to think of way too many positions that really are reachable as unreachable
		end,
	},
	["triplesplit"] = {
		Update = function(v, d)
			local vec
			if d.target then
				if d.target:IsDead() then
					vec = v.Velocity
				else
					vec = (d.target.Position - v.Position):Resized(5)
				end
			else
				vec = v.Velocity
			end

			v.Velocity = mod:Lerp(v.Velocity, vec, 0.3)
			v.Height = -23
			v.FallingSpeed = 0
			if v.FrameCount > 25 then
				for i = -30, 30, 30 do
					local projectile = mod:LazySpawnProjectile(0, 0, v.Position, v.Velocity:Resized(8):Rotated(i), v):ToProjectile()
					if i == 0 then
						projectile.Scale = 1
					else
						projectile.Scale = 0.5
					end
					projectile.Color = mod.ColorPsyGrape
				end
				local effect = Isaac.Spawn(1000, 2, 0, v.Position, mod.nilvector, v):ToEffect()
				effect.Color = mod.ColorPsyGrape
				effect:Update()
				sfx:Play(SoundEffect.SOUND_DEATH_BURST_SMALL, 0.75)
				v:Die()
			end
		end,
	},
	["acidic splot"] = {
		Death = function(v, d)
			local creep = Isaac.Spawn(1000, 23, 0, v.Position, mod.nilvector, v):ToEffect()
			creep:SetColor(Color(0, 0, 0, 1, 99 / 255, 56 / 255, 74 / 255), 60, 99999, true, false)
			if d.creepTimer then
				creep:SetTimeout(d.creepTimer)
			end
			creep:Update()
		end,
	},
	["acidic piss"] = {
		Death = function(v, d)
			local creep = Isaac.Spawn(1000, 24, 0, v.Position, mod.nilvector, v):ToEffect()
			creep:SetColor(Color(0,0,0,1,180 / 255,180 / 255,30 / 255), 0, 99999, true, false)
			creep:Update()
		end,
	},
	["ogreCreep"] = {
		PostCollision = function(proj, data, collider)
			if collider.Type == 1 and proj.ProjectileFlags ~= proj.ProjectileFlags | ProjectileFlags.CANT_HIT_PLAYER then
				local player = collider:ToPlayer()
				player:AddSlowing(EntityRef(proj.SpawnerEntity or proj), 120, 0.8, mod.ColorNormal)
				mod:GetEntityData(player).CustomDuskDebuffSlow = true
			elseif collider.Type >= 10 then
				collider:AddSlowing(EntityRef(proj),120,1,Color(1.5,1.5,1.5,1,0,0,0))
			end
		end,
		Death = function(v, d)
			if v.ProjectileFlags == v.ProjectileFlags | ProjectileFlags.CANT_HIT_PLAYER then
				local creep = Isaac.Spawn(1000,44,0,v.Position,mod.nilvector,v)
				creep:Update()
			else
				local room = game:GetRoom()
				if not room:GetGridEntityFromPos(v.Position) and room:IsPositionInRoom(v.Position, 0) then
					Isaac.GridSpawn(10, 0, v.Position, true)
				end
			end
		end,
	},
	["dwellerGodhead"] = {
		PostCollision = function(proj, data, collider)
			if proj.Child then
				proj.Child:GetSprite():Play("Disappear", true)
				proj.Child.Parent = proj.Child
			end
		end,
	},
	["bloodafter"] = {
		Death = function(v, d)
			local creep = Isaac.Spawn(1000, 22, 0, v.Position, mod.nilvector, v):ToEffect()
			creep:SetTimeout(math.random(30,75))
		end,
	},
	["coal"] = {
		Update = function(v, d)
			v.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			v.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
			v.SpriteRotation = v.SpriteRotation + 30
			if v:IsDead() then
				local timeout = d.timeout or 200
				local burntime = d.burntime or 50
				mod.SpawnGunpowder(v.SpawnerEntity,v.Position, timeout, burntime)
				local vec = (RandomVector()*20)
				for i = 1, 6 do
					local vec2 = vec:Rotated(360/6 * i - 15 + math.random(30)):Resized(math.random(25,40))
					mod.SpawnGunpowder(v.SpawnerEntity,v.Position + vec2, timeout, burntime)

					local smoke = Isaac.Spawn(1000, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, v.Position + vec2 * 0.2, vec2 * 0.15, v):ToEffect()
					smoke.SpriteRotation = math.random(360)
					smoke.RenderZOffset = 300
					smoke:Update()
				end
				--[[local num = math.random(3,5)
				for i = 1, num do
					local r = Isaac.Spawn(1000, 4, 0, v.Position + Vector(0, 1):Rotated(i*(360/num)):Resized(math.random(3, 5)*math.random(3)), mod.nilvector, nil)
					r.Color = Color(0.6,0.6,0.9,1,0,0,0)
					r:Update()
				end]]
				sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE,0.15,2,false,1.6)
				local tearpoof = Isaac.Spawn(1000,mod.FF.SootyTearPoof.Var, mod.FF.SootyTearPoof.Sub, v.Position, mod.nilvector, v):ToEffect()
				tearpoof.SpriteOffset = v.SpriteOffset
				v:Remove()
			end
		end,
	},
	["coalButActuallyRock"] = {
		Update = function(v, d)
			--v.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			--v.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
			v.SpriteRotation = v.SpriteRotation + 30
			if v:IsDead() then
				sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE,0.15,2,false,1.2)
				local tearpoof = Isaac.Spawn(1000,mod.FF.SootyTearPoof.Var, mod.FF.SootyTearPoof.Sub, v.Position, mod.nilvector, v):ToEffect()
				tearpoof:GetSprite():Load("gfx/projectiles/sooty_tear_rock.anm2",true)
				tearpoof.SpriteOffset = v.SpriteOffset
				v:Remove()
			end
		end,
	},
	["coal2"] = {
		Update = function(v, d)
			v.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			v.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
			v.SpriteRotation = v.SpriteRotation + 30
			if v:IsDead() then
				local vec = (RandomVector()*8)
				if d.projSpeed then
					vec = vec:Resized(d.projSpeed)
				end
				local numberofflames = 6
				for i = 1, numberofflames do
					local fire = Isaac.Spawn(1000,7005, 1, v.Position, vec:Rotated((360/numberofflames) * i), v.SpawnerEntity)
					if v.SpawnerEntity then
						fire.Parent = v.SpawnerEntity
					end
					fire:Update()
				end
				--[[local num = math.random(3,5)
				for i = 1, num do
					local r = Isaac.Spawn(1000, 4, 0, v.Position + Vector(0, 1):Rotated(i*(360/num)):Resized(math.random(3, 5)*math.random(3)), mod.nilvector, nil)
					r.Color = Color(0.6,0.6,0.9,1,0,0,0)
					r:Update()
				end]]
				sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE,0.15,2,false,1.5)
				sfx:Play(mod.Sounds.FireFizzle, 0.4, 0, false, 1.3)
				local tearpoof = Isaac.Spawn(1000,mod.FF.SootyTear2Poof.Var, mod.FF.SootyTear2Poof.Sub, v.Position, mod.nilvector, v):ToEffect()
				tearpoof.SpriteOffset = v.SpriteOffset
				v:Remove()
			end
		end,
	},
	["coalRadioactive"] = {
		Update = function(v, d)
			v.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			v.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
			v.SpriteRotation = v.SpriteRotation + 30
			if v:IsDead() then
				local ash = mod.FindClosestUnlitPowder(v.Position, v)
				if ash and ash.Position:Distance(v.Position) < 40 then
					mod:GetEntityData(ash).flaming = true
				end
				sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE,0.15,2,false,1.5)
				sfx:Play(mod.Sounds.FireFizzle, 0.4, 0, false, 1.3)
				local tearpoof = Isaac.Spawn(1000,mod.FF.SootyTear2Poof.Var, mod.FF.SootyTear2Poof.Sub, v.Position, mod.nilvector, v):ToEffect()
				tearpoof:GetSprite():Load("gfx/projectiles/sooty_tear_radioactive.anm2",true)
				tearpoof.SpriteOffset = v.SpriteOffset
				for i = -30, 30, 30 do
					local smoke = Isaac.Spawn(1000, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, v.Position, Vector(0,-10):Rotated(i), v)
					--smoke.SpriteScale = Vector(1,1)
					smoke.SpriteOffset = Vector(0, -10)
					smoke.Color = Color(0.5,1.5,1,1,0,0,0)
					smoke:Update()
				end
				v:Remove()
			end
		end,
	},
	["HoneyCreep"] = {
		Death = function(v, d)
			local honeycolor = Color(1,1,1,1,0,0,0)
			honeycolor:SetColorize(5.5, 3.5, 1, 1)
			local creep = Isaac.Spawn(1000, EffectVariant.CREEP_BROWN, 0, v.Position, mod.nilvector, v):ToEffect()
			creep.SpriteScale = Vector(2, 1.25)
			creep:SetTimeout(creep.Timeout + 90)
			creep:Update()
			creep:GetSprite().Color = honeycolor
		end,
	},
	["PusyCreep"] = {
		Death = function(v, d)
			local creep = Isaac.Spawn(1000, EffectVariant.CREEP_BROWN, 0, v.Position, mod.nilvector, v):ToEffect()
			creep.SpriteScale = Vector(2, 1.25)
			creep:SetTimeout(creep.Timeout + 70)
			creep:Update()
		end,
	},
	["Radioactive"] = {
		Update = function(v, d)
			d.Height = v.Height
			if not d.customProjSplat then
				d.customProjSplat = "gfx/projectiles/radioactiveSplat.png"
			end
			if v.FrameCount % 5 == 0 then
				local trail = Isaac.Spawn(1000, 111, 0, v.Position, mod.nilvector, v):ToEffect()
				trail:GetSprite().Offset = Vector(0, v.Height * 0.75)
				local color = Color(1,1,1,0.5,0.3,1,0)
				color:SetColorize(1,1,1,1)
				trail.Color = color
				trail.SpriteScale = Vector(0.5, 0.5)
				trail:Update()
			end
			if v.ProjectileFlags == v.ProjectileFlags | ProjectileFlags.NO_WALL_COLLIDE then
				v.Velocity = v.Velocity * 1.01
				if v.FrameCount % 1 == 0 then
					local blood = Isaac.Spawn(1000, 7, 0, v.Position, mod.nilvector, v)
					blood.SpriteScale = Vector(0.4,0.4)
					blood.Color = Color(0.2, 0.2, 0.2, 0.1, 0, 0, 0)
					blood:Update()
				end
				if v.FrameCount > 70 then
					v:Remove()
				end
			end
		end,
	},
	["killerNeedle"] = {
		Update = function(v, d)
			v.SpriteRotation = v.Velocity:GetAngleDegrees()
		end,
	},
	["crackWave"] = {
		Death = function(v, d)
			local wave3 = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SHOCKWAVE, 0, v.Position, Vector.Zero, v):ToEffect()
			wave3.Parent = v
			wave3.MaxRadius = -30
		end,
	},
	["TrashFart"] = {
		Death = function(proj, data)
			game:ButterBeanFart(proj.Position, 140, proj, true, false)
		end,
	},
	["DangerFart"] = {
		Death = function(proj, data)
			local range = 40
			if data.fartscale then
				range = range * data.fartscale
			end
			mod:FakerFart(proj.SpawnerEntity, proj.Position, range, 1.5)
			--[[game:Fart(proj.Position, range, proj.SpawnerEntity, 1, 0)
			mod:FakeFart(proj.SpawnerEntity, proj.Position, range)]]
			--game:BombExplosionEffects(proj.Position, 9, TearFlags.TEAR_POISON, Color(0, 0, 0, 0, 0, 0, 0), proj, 1.3, false, true)
		end,
	},
	["CharmFart"] = {
		Death = function(proj, data)
			game:CharmFart(proj.Position, 40, proj)
		end,
	},
	["BruiseFart"] = {
		Death = function(proj, data)
			for _, enemy in ipairs(Isaac.FindInRadius(proj.Position, 9999, EntityPartition.ENEMY | EntityPartition.PLAYER)) do
				if enemy:ToNPC() and proj:HasProjectileFlags(ProjectileFlags.HIT_ENEMIES) ~= enemy:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and mod:checkIfStatusLogicIsApplied(enemy, false) and enemy.Position:Distance(proj.Position) < enemy.Size * math.max(enemy.SizeMulti.X, enemy.SizeMulti.Y) + 120 then
					FiendFolio.AddBruise(enemy, proj, 120, 1, 1)
				elseif enemy.Type == 1 and enemy.Position:Distance(proj.Position) < enemy.Size * math.max(enemy.SizeMulti.X, enemy.SizeMulti.Y) + 120 and not proj:HasProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER) then
					local data = mod:GetEntityData(enemy)
					data.lastComposterBruise = enemy.FrameCount
				end
			end

			game:ButterBeanFart(proj.Position, 120, proj, false, false)
			local fartCloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FART, 0, proj.Position, Vector.Zero, proj)
			local fartSprite = fartCloud:GetSprite()
			fartSprite.Color = Color(0.4, 0.4, 0.4, 1.0, 40/255, 0/255, 40/255, 1.0, 1.0, 1.0, 1)
		end,
	},
	["dangCorn"] = {
		Update = function (proj, data)
			local sprite = proj:GetSprite()
			sprite.Rotation = sprite.Rotation + 20
			mod:spritePlay(sprite, "Projectile")
		end
	}
}

--[[
function mod.getProjDebug(v)
	print("Velocity:" .. v.Velocity:GetAngleDegrees())
	print(v.ProjectileFlags)
	print("Type:" .. v.Variant)
	print("R:" .. v.Color.R)
	print("G:" .. v.Color.G)
	print("G:" .. v.Color.G)
	print("B:" .. v.Color.B)
	print("A:" .. v.Color.A)
	print("RO:" .. v.Color.RO)
	print("GO:" .. v.Color.GO)
	print("BO:" .. v.Color.BO)
end
]]

--[[
function mod.ensureFlashingTearProjectiles(v,d)
	if v.Variant == 4 then
		if not d.becameFlashing then
			d.becameFlashing = true
			local sprite = v:GetSprite()
			local anim
			--Thanks Nicalis for not letting me just get what's playing
			for i = 1, 13 do
				if sprite:IsPlaying("RegularTear" .. i) then
					anim = "RegularTear" .. i
				end
			end

			if anim then
				sprite:Load("gfx/projectiles/flashingTearProj.anm2", true)
				sprite:Play(anim, true)
			end

			--local oldScale = v.Scale
			--sprite:Load("gfx/projectiles/flashingTearProj.anm2", true)
			--sprite:Play("RegularTear6", true)
			--v.Scale = oldScale
		end
	end
end
]]

-- MC_POST_PROJECTILE_UPDATE
function mod:OnProjUpdate(proj)
	local data = mod:GetEntityData(proj)

	--mod.ensureFlashingTearProjectiles(proj, data)

	if proj.FrameCount == 1 and data.creeptype == "brown" then
		proj.SplatColor = mod.ColorBrowniePoop
	end

	if proj.FrameCount % 5 == 0 and data.special == "curdled" then
		local trail = Isaac.Spawn(1000, 111, 0, proj.Position, mod.nilvector, proj):ToEffect()
		trail:GetSprite().Offset = Vector(0, proj.Height * 0.75)
	end

	if data.projType then
		local projfunc = mod:Access(FF_PROJECTILE_TYPE_FUNCS, data.projType, "Update")
		if projfunc then
			projfunc(proj, data)
		end
	end

	mod.erflyProjectiles(proj, data)
	mod.orbitalprojupdate(proj, data)
	mod.puntedProjectiles(proj, data)
	mod.warbleProjectiles(proj, data)
	mod.sensoryGrimaceProjectiles(proj, data)
	mod.anemoneProjectiles(proj, data)
	mod.ferriumProj(proj, data)
	mod.cakeProj(proj, data)
	mod:IdolatorLustProjectileUpdate(proj, data)
	mod:connorPostProjUpdate(proj, data)
	mod.dryWheezeProj(proj, data)
	mod:projectileFlags(proj, data)
	--mod.getProjDebug(proj)
	mod.babyCraterTears(proj, data)
	mod:babyBubblesProjectiles(proj, data)
	mod:TiyanakProjectileUpdate(proj, data)
end
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, mod.OnProjUpdate)

-- MC_POST_PROJECTILE_RENDER
function mod:OnProjRender(proj)
	local data = mod:GetEntityData(proj)

	mod:IdolatorLustProjectileRender(proj, data)
	mod:KawasakiProjectileRender(proj, data)
end
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_RENDER, mod.OnProjRender)

-- Functions to run before a projectile hits a specific entity.
local PRE_ENTITY_COLLISION_FUNCS = {
	[mod.FFID.Boss] = {
		[mod.FF.Dusk.Var] = function(proj, collider)
			if proj.SpawnerEntity and proj.SpawnerEntity.Parent and proj.SpawnerEntity.Parent.InitSeed == collider.InitSeed then
				return true
			end
		end,
		[mod.FF.DuskHand.Var] = function(proj, collider)
			if proj.SpawnerEntity and collider.Parent and proj.SpawnerEntity.Parent and proj.SpawnerEntity.Parent.InitSeed == collider.Parent.InitSeed then
				return true
			end
		end,
		[mod.FF.Kingpin.Var] = function(proj, collider)
			if proj.SpawnerEntity and proj.SpawnerEntity.Type == mod.FF.Kingpin.ID and proj.SpawnerEntity.Variant == mod.FF.Kingpin.Var and mod:isInSegmentsOf(collider, proj.SpawnerEntity) then
				return true
			end
		end,
		[mod.FF.Tapeworm.Var] = function(proj, collider)
			if proj.SpawnerEntity and proj.SpawnerEntity.Type == mod.FF.Tapeworm.ID and proj.SpawnerEntity.Variant == mod.FF.Tapeworm.Var and mod:isInSegmentsOf(collider, proj.SpawnerEntity) then
				return true
			end
		end,
	},
	[mod.FF.Bola.ID] = {
		[mod.FF.Bola.Var] = function(proj, collider)
			if proj.SpawnerEntity and proj.SpawnerEntity.Parent and proj.SpawnerEntity.Parent.InitSeed == collider.InitSeed then
				return true
			end
		end,
	},
	[mod.FF.MrGob.ID] = {
		[mod.FF.MrGob.Var] = function(proj, collider)
			if proj.SpawnerEntity and proj.SpawnerEntity.Parent and proj.SpawnerEntity.Parent.InitSeed == collider.InitSeed then
				return true
			elseif proj.SpawnerEntity and proj.SpawnerEntity.Child and proj.SpawnerEntity.Child.InitSeed == collider.InitSeed then
				return true
			end
		end,
	},
}

-- MC_PRE_PROJECTILE_COLLISION
function mod:PreProjColl(proj, collider, collidedFirst)
	local data = mod:GetEntityData(proj)

	if proj.FrameCount < 3 then
		--For charmed projectiles, otherwise they just hit the enemy that fired it immediately.
		if (data.projType or data.special) and proj.SpawnerEntity then
			if proj.SpawnerType == collider.Type and proj.SpawnerVariant == collider.Variant then
				return true
			end
		end
	end

	local entitycolfunc = mod:Access(PRE_ENTITY_COLLISION_FUNCS, collider.Type, collider.Variant)
	if entitycolfunc and entitycolfunc(proj, data) then
		return true
	end

	if data.projType then
		local func = mod:Access(FF_PROJECTILE_TYPE_FUNCS, data.projType, "PreCollision")
		if func and func(proj, data, collider) then
			return true
		end
	end

	local ferrium = mod.ferriumPreProjectileCollision(proj, collider, collidedFirst)
	if ferrium ~= nil then
		return ferrium
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, mod.PreProjColl)

-- MC_POST_PROJECTILE_COLLISION
function mod:PostProjColl(proj, collider)
	local data = mod:GetEntityData(proj)

	if data.projType then
		local func = mod:Access(FF_PROJECTILE_TYPE_FUNCS, data.projType, "PostCollision")
		if func then
			func(proj, data, collider)
		end
	end

	if data.isImpSodaTear and collider:IsEnemy() then
		data.hasImpSodaProcced = data.hasImpSodaProcced or {}
		if not data.hasImpSodaProcced[collider.InitSeed] then
			mod:doCriticalHitFx(proj.Position, collider, proj)
			data.hasImpSodaProcced[collider.InitSeed] = true
		end
	end

	if data.BastardlyBeetleTear then
		if collider:IsEnemy() and not collider:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) then
			local mult = mod.getTrinketMultiplierAcrossAllPlayers(TrinketType.TRINKET_SECOND_HAND)+1
			collider:AddSlowing(EntityRef(proj), 80*mult, 0.66, Color(0.8, 0.8, 0.8, 1, 0, 0, 0))
		end
	end

	if data.FriendlyBeetleTear and collider:IsEnemy() then
		if not collider:HasEntityFlags(EntityFlag.FLAG_NO_REWARD) then
			mod:GetEntityData(collider).electrumDeath = function()
				local heart = Isaac.Spawn(5, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF, collider.Position, Vector.Zero, collider):ToPickup()
				heart.Timeout = mod.FriendBalancing.HeartTimeout
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_COLLISION, mod.PostProjColl)

local CREEP_VARIANTS = {
	["brown"] = EffectVariant.CREEP_SLIPPERY_BROWN,
	["green"] = EffectVariant.CREEP_GREEN,
	["black"] = EffectVariant.CREEP_BLACK,
	["white"] = EffectVariant.CREEP_WHITE,
	["red"] = EffectVariant.CREEP_RED,
}

-- MC_POST_PROJECTILE_DEATH
function mod:OnProjDeath(proj)
	local data = mod:GetEntityData(proj)

	if data.projType then
		local func = mod:Access(FF_PROJECTILE_TYPE_FUNCS, data.projType, "Death")
		if func then
			func(proj, data)
		end
	end

	--creep check
	local creepvariant = data.creeptype and CREEP_VARIANTS[data.creeptype]
	if creepvariant then
		local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, creepvariant, 0, proj.Position, mod.nilvector, proj):ToEffect()
		if data.creepsize then
			creep.SpriteScale = data.creepsize
		end
		if data.creepduration then
			creep:SetTimeout(data.creepduration)
		end
		creep:Update()
	end

	-- worm check
	if data.wormchance then
		if data.wormchecknumber then
			for i = 1, data.wormchecknumber, 1 do
				local rando = math.random(1, data.wormchance.Y)
				if rando <= data.wormchance.X then
					Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WORM, 0, proj.Position, mod.nilvector, proj)
				end
			end
		else
			local rando = math.random(1, data.wormchance.Y)
			if rando <= data.wormchance.X then
				Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WORM, 0, proj.Position, mod.nilvector, proj)
			end
		end
	end

	--fly check
	if data.flychance then
		if data.flychecknumber then
			for i = 1, data.flychecknumber, 1 do
				local rando = math.random(1, data.wormchance.Y)
				if rando <= data.flychance.X then
					Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TINY_FLY, 0, proj.Position, mod.nilvector, proj)
				end
			end
		else
			local rando = math.random(1, data.flychance.Y)
			if rando <= data.flychance.X then
				Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TINY_FLY, 0, proj.Position, mod.nilvector, proj)
			end
		end
	end

	--splattering
	if data.special then
		if data.special == "loadshot" then
			--pool of creep
			local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_SLIPPERY_BROWN, 0, proj.Position, mod.nilvector, proj):ToEffect()
			creep.SpriteScale = Vector(4.5, 3.5)
			if data.special2 then
				creep:SetTimeout(280)
			else
				--doesnt change color, will need fixin
				creep.Color = Color(0,0,0,1,102 / 255,61 / 255,40 / 255)
			end
			creep:Update()
			--explosion
			Isaac.Explode(proj.Position, proj, 2)
			--tear splatter
			if data.special2 then
				Isaac.Spawn(295, 0, 0, proj.Position, mod.nilvector, proj)
			else
				local tearnumber = math.random(6,10)
				for I = 1, tearnumber, 1 do
					local corncheck = math.random(1,4)
					if corncheck ~= 4 then
						--normal tear
						local projectile2 = mod:LazySpawnProjectile(ProjectileVariant.PROJECTILE_PUKE, 0, proj.Position, (RandomVector()*(math.random()+math.random(6,10))), proj):ToProjectile()
						local projdata2 = mod:GetEntityData(proj)
						projectile2.FallingSpeed = -(math.random(20,35))
						projectile2.FallingAccel = 2
						projdata2.creeptype = "brown"
						projdata2.creepsize = Vector(0.6,0.5)
						local s = projectile2:GetSprite()
						s:ReplaceSpritesheet(0, "gfx/projectiles/cornpoop_projectile.png")
						s:LoadGraphics()
					else
						--corn tear, for funsies
						local projectile2 = mod:LazySpawnProjectile(ProjectileVariant.PROJECTILE_CORN, 0, proj.Position, (RandomVector()*(math.random()+math.random(3,7))), proj):ToProjectile()
						local projdata2 = mod:GetEntityData(proj)
						projectile2.FallingSpeed = -(math.random(15,30))
						projectile2.FallingAccel = 2.5
						projdata2.creeptype = "brown"
						projdata2.wormchance = Vector(1,4)
						projdata2.wormchecknumber = 2
						projdata2.flychance = Vector(1,2)
					end
				end
			end
		elseif data.special == "curdled" then
			local projnum = math.random(6, 8)
			for i = 1, projnum, 1 do
				local projectile2 = mod:LazySpawnProjectile(0, 0, proj.Position, Vector(1,0):Rotated((i * 360/projnum) + math.random(-15, 15)):Resized(math.random(5, 8)), proj):ToProjectile()
				projectile2.FallingSpeed = -1 * math.random(15, 20)
				projectile2.FallingAccel = 2
				projectile2.Scale = math.random(7, 15)/10
				--projectile2:GetSprite():ReplaceSpritesheet(0, "gfx/projectiles/tears_balloon.png")
				projectile2:GetSprite():LoadGraphics()
				Isaac.Spawn(1000, 14, 1, proj.Position, mod.nilvector, proj)
				sfx:Play(SoundEffect.SOUND_MEAT_IMPACTS, 1, 0, false, 1.5)
			end
		end
	end

	if data.customProjSplat then
		local splatGfx = data.customProjSplat
		FiendFolio.scheduleForUpdate(function()
			local splats = Isaac.FindByType(1000, 11, 0, false, false)
			for _, splat in pairs(splats) do
				if splat.FrameCount == 0 and splat.Position:Distance(proj.Position) == 0 then
					local sprite = splat:GetSprite()
					sprite:ReplaceSpritesheet(0, splatGfx)
					sprite:LoadGraphics()
				end
			end
		end, 0)
	end

	if data.tooth then
		sfx:Play(SoundEffect.SOUND_BOIL_HATCH, 0.3, 0, false, 1)
	end

	if data.customProjSound then
		sfx:Play(data.customProjSound[1], data.customProjSound[2], 0, false, data.customProjSound[3])
	end

	if data.makeSplat then
		local splat = Isaac.Spawn(1000, data.makeSplat, 0, proj.Position, Vector.Zero, proj)
		splat.SpriteOffset = Vector(0, proj:ToProjectile().Height)
		splat:SetColor(proj.Color, 999, 1, false, false)
		if data.customProjSplat then
			local splatGfx = data.customProjSplat
			local sprite = splat:GetSprite()
			sprite:ReplaceSpritesheet(0, splatGfx)
			sprite:LoadGraphics()
		end
		if data.toothParticles then
			for i=0,2 do
				local particle = Isaac.Spawn(1000, 35, 1, proj.Position, RandomVector(), proj)
				particle:SetColor(data.toothParticles, 999, 1, false, false)
			end
		end
	end

	mod:DesolatorProjectileDeath(proj, data)
	mod:catinsuranceProjDeath(proj, data)

	if data.BastardlyBeetleTear then
		Isaac.Spawn(1000, EffectVariant.PLAYER_CREEP_BLACK, 0, proj.Position, Vector.Zero, proj)
	end
	if data.SkeletalBeetleTear then
		local rng = proj:GetDropRNG()
		for i=1,2 do
			local tear = Isaac.Spawn(2, TearVariant.BONE, 0, proj.Position-proj.Velocity:Resized(8), proj.Velocity:Rotated(rng:RandomInt(360)), proj):ToTear()
			tear.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			mod.scheduleForUpdate(function()
				tear.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
			end, 2)
			tear.CollisionDamage = proj.CollisionDamage
			tear:GetSprite():ReplaceSpritesheet(0, "gfx/tears_brokenbone.png", true)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_DEATH, mod.OnProjDeath)
