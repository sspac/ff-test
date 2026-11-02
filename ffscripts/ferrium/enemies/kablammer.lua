local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

function mod:kablammerAI(npc)
	local sprite = npc:GetSprite()
	local target = npc:GetPlayerTarget()
	local data = mod:GetEntityData(npc)
	local room = game:GetRoom()
	local rand = npc:GetDropRNG()
	
	if not data.init then
		if (npc.SubType == 1 or npc.SubType == 3) and not data.waited then
			npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			npc:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
			npc.Visible = false
			mod:makeWaitFerr(npc, mod.FFID.Ferrium, npc.Variant, npc.SubType, 60, false)
		elseif data.waited then
            if npc.SubType == 1 then
    			data.state = "Waiting"
	    		npc.Visible = false
                npc.SubType = 0
            end
		end
		if npc.SubType > 0 then
			npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		end
        npc.StateFrame = rand:RandomInt(10)+5
        if data.dead then
            data.state = "Death"
		elseif npc.SubType == 0 then
			data.state = "Idle"
        elseif npc.SubType > 1 then
            npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            data.state = "waitforit"
            local effect = Isaac.Spawn(1000, 30, 0, npc.Position, Vector.Zero, nil)
			effect.Parent = npc
			effect:Update()
			mod:GetEntityData(effect).drillbit = true
            npc.Visible = false
            data.targetEffect = effect
            npc.StateFrame = 0
            data.beepIndicator = 1
            --data.state = "HEREITCOMES"
        end
		data.init = true
		npc:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
	else
		npc.StateFrame = npc.StateFrame+1
	end
	
	if data.isJumping == 1 then
		npc.Friction = 1
		local dist = (npc.Position-data.playerPos):Length()
		if dist < 20 then
			data.state = "JumpDown"
			data.isJumping = 0
			data.targetVel = Vector.Zero
		elseif dist < 40 then
			data.targetVel = (data.playerPos-npc.Position):Resized(2)
		else
			--data.targetVel = npcd.targetVel + -(npc.Position - npcd.PlayerPos):Normalized() * (dist / 65)
			data.targetVel = data.targetVel+ -(npc.Position-data.playerPos):Resized(dist/65)
			local arcVel = data.targetVel
			if arcVel:Length() >= dist then
				data.targetVel = arcVel:Resized(dist)
			end
		end
	else
		data.targetVel = Vector.Zero
	end
	
	if data.state == "Idle" then
		if npc.StateFrame > 45 and not mod:isScareOrConfuse(npc) then
			data.state = "JumpUp"
			npc.StateFrame = 0
		else
			mod:spritePlay(sprite, "Idle")
		end
	elseif data.state == "JumpUp" then
		if sprite:IsFinished("Jump") then
			--[[data.state = "JumpDown"
			data.IsJumping = 0
			data.targetVel = Vector.Zero]]
		elseif sprite:IsEventTriggered("GetPlayer") then
			local dist = (npc.Position - target.Position):Length()
			local fgkhj = (target.Position - npc.Position):Normalized() * math.min(300,dist)
			local checkSpot = npc.Position+fgkhj
			local gridEnt = room:GetGridEntityFromPos(target.Position)
			if gridEnt ~= nil and gridEnt ~= (GridEntityType.GRID_LOCK or GridEntityType.GRID_SPIKES or GridEntityType.GRID_PIT or GridEntityType.GRID_WALL or GridEntityType.GRID_PILLAR) then
				data.playerPos = (npc.Position+fgkhj) + (RandomVector())
			else
				data.playerPos = room:FindFreeTilePosition(npc.Position + fgkhj, 40) + (RandomVector())
			end
			
			data.isJumping = 1
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
			npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
		elseif sprite:IsEventTriggered("Sound") then
			npc:PlaySound(SoundEffect.SOUND_SHELLGAME,1,2,false,0.7)
		else
			mod:spritePlay(sprite, "Jump")
		end
	elseif data.state == "JumpDown" then
		if sprite:IsFinished("Fall") then
			data.state = "Idle"
			npc.StateFrame = -rand:RandomInt(15)
		elseif sprite:IsEventTriggered("Land") then
            npc:PlaySound(SoundEffect.SOUND_SCYTHE_BREAK, 1, 0, false, mod:getRoll(90,110,rand)/100)
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
			npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
		else
			mod:spritePlay(sprite, "Fall")
		end
	elseif data.state == "Waiting" then
		npc.Velocity = Vector.Zero
		sprite:Play("Fall", true)
		data.state = "JumpDown"
		npc:ClearEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
		npc.Visible = true
		npc.Position = npc.Position+RandomVector()*5
    elseif data.state == "Death" then
        if sprite:IsFinished("Death") then
            if target and target:ToPlayer() then
                local td = mod:GetEntityData(target).ffsavedata
                if td then
                    td.RunEffects.kablammerSchedule = td.RunEffects.kablammerSchedule or {}
                    local ra = mod:getRoll(300,1000,rand)
                    table.insert(td.RunEffects.kablammerSchedule, ra)
                end
            end
            npc:Remove()
        elseif sprite:IsEventTriggered("Sound") then
            game:BombExplosionEffects(npc.Position, 40, 0, Color(1, 1, 1, 1, 0, 0, 0), npc, 1, false, true)
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            data.left = true
        else
            mod:spritePlay(sprite, "Death")
        end

        if npc.FrameCount % 4 == 0 and not data.left then
            local smoke = Isaac.Spawn(1000, 59, 0, npc.Position+RandomVector()*15, Vector(0,-5), npc):ToEffect()
            smoke:SetTimeout(10)
            smoke:SetColor(Color(0,0,0,0.5,0,0,0), 0, 0, false, false)
            smoke.Scale = 1000
        end
    elseif data.state == "HEREITCOMES" then
        if sprite:IsFinished("Impact") then
            game:BombExplosionEffects(npc.Position, 80, 0, Color(1, 1, 1, 1, 0, 0, 0), npc, 1.75, false, true)
            game:ShakeScreen(20)
            local rangle = rand:RandomInt(360)
            for i=0,8 do
                local params = ProjectileParams()
                params.Variant = 9
                npc:FireProjectiles(npc.Position, Vector(12, 0):Rotated(i*40+rangle), 0, params)
            end
            npc:Remove()
        elseif sprite:IsEventTriggered("Land") then
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            if data.targetEffect then
                data.targetEffect:Remove()
            end
            npc:PlaySound(SoundEffect.SOUND_SCYTHE_BREAK, 1, 0, false, mod:getRoll(90,110,rand)/100)
        else
            mod:spritePlay(sprite, "Impact")
        end

        if sprite:GetFrame() < 16 then
            local smoke = Isaac.Spawn(1000, 59, 0, npc.Position+RandomVector()*15, Vector(0,-5), npc):ToEffect()
            smoke:SetTimeout(10)
            smoke:SetColor(Color(0,0,0,0.5,0,0,0), 0, 0, false, false)
            smoke.Scale = 1000
            local offsetY = sprite:GetFrame()
            if offsetY > 6 then offsetY = 6 end
            smoke.PositionOffset = Vector(0, -220+(offsetY*33.3))
        end
    elseif data.state == "waitforit" then
        if npc.StateFrame > 3*data.beepIndicator+1 and data.beepIndicator < 4 then
            data.beepIndicator = data.beepIndicator+1
            npc:PlaySound(SoundEffect.SOUND_BEEP, 1, 0, false, 1.25)
        end
        if npc.StateFrame > 16 then
            data.state = "HEREITCOMES"
            sprite:Play("Impact", true)
            npc.Visible = true
        end
    end

	if data.state == "JumpUp" or data.state == "JumpDown" then
		npc.Velocity = (data.targetVel * 0.3) + (npc.Velocity * 0.6)
	else
		npc.Velocity = Vector.Zero
	end
end

function mod.kablammerDeathAnim(npc)
	local onCustomDeath = function(npc, deathAnim)
		mod:GetEntityData(deathAnim).dead = true
	end
	mod.genericCustomDeathAnim(npc, "Death", true, onCustomDeath, true, false)
end

function mod:kablammerPlayerUpdate(player, data)
    if data.ffsavedata.RunEffects.kablammerSchedule then
        local tab = data.ffsavedata.RunEffects.kablammerSchedule
        for key,time in ipairs(tab) do
            tab[key] = time-1
            if time < 0 then
                local slamy = Isaac.Spawn(mod.FF.Kablammer.ID, mod.FF.Kablammer.Var, 2, player.Position, Vector.Zero, player)
                slamy:Update()
                table.remove(tab, key)
            end
        end
    end
end

local wrenchParam = ProjectileParams()
wrenchParam.Variant = ProjectileVariant.PROJECTILE_GRID
wrenchParam.Scale = 0.5

function mod:BendyPeashooterAI(npc)
	local sprite = npc:GetSprite()
	local d = mod:GetEntityData(npc)
	local target = npc:GetPlayerTarget()

	if not d.init then
		npc.SplatColor = mod.ColorDankBlackReal
		d.State = "Idle"
		d.init = true
	else
		npc.StateFrame = npc.StateFrame+1
	end

	if not d.isSpecturned then
		if not d.initPos then
			d.initPos = npc.Position
		end
		npc.Velocity = d.initPos-npc.Position
	else
		d.initPos = nil
	end

	if d.State == "Idle" then
		if npc.StateFrame > 90 then
			d.State = "Fire"
		end

		mod:spritePlay(sprite, "idle")
	elseif d.State == "Fire" then
		if sprite:IsFinished("shoot") then
			d.State = "Idle"
			npc.StateFrame = 0
		elseif sprite:IsEventTriggered("fire") then
			local proj = npc:FireProjectilesEx(npc.Position, (target.Position-npc.Position):Resized(6), 0, wrenchParam)[1]
			proj:Update()
			mod:GetEntityData(proj).projType = "WrenchBend"
			proj:SetShadowSize(0.2)
			local ps = proj:GetSprite()
			ps:Load("gfx/enemies/bendy_peashooter/bendy_wrench.anm2", true)
			proj:Update()
			npc:PlaySound(mod.Sounds.WrenchShoot, 5, 0, false, mod:RandomInt(90,110,npc:GetDropRNG())/100)
		else
			mod:spritePlay(sprite, "shoot")
		end

		sprite.FlipX = (target.Position-npc.Position).X < 0
	end
end

function mod:WrenchProj(v, d)
	if d.projType == "WrenchBend" then
		local sprite = v:GetSprite()
		if d.HitTarget then
			mod:spritePlay(sprite, "Invisible")
			
			d.LastHitFrame = d.LastHitFrame or 0
			if v.FrameCount-d.LastHitFrame > 3 then
				d.LeftTarget = true
			end

			if d.LeftTarget and mod:superExists(d.HitTarget) then
				local tVel = (d.HitTarget.Position-v.Position)
                local difference = mod:GetAngleDifference(v.Velocity, tVel)
                if difference < 180 then
                    v.Velocity = v.Velocity:Rotated(-16):Resized(6)
                else
                    v.Velocity = v.Velocity:Rotated(16):Resized(6)
                end
			end
		else
			mod:spritePlay(sprite, "Idle")
		end

		v.FallingSpeed = 0
		v.FallingAccel = -0.065
	end
end

function mod:WrenchProjColl(proj, coll, bool)
	local d = mod:GetEntityData(proj)
	if d.projType == "WrenchBend" and (coll:ToNPC() or coll:ToPlayer()) then
		local npc
		local player
		local goAhead
		proj = proj:ToProjectile()
		if coll:ToNPC() then
			npc = coll:ToNPC()
			coll = coll:ToNPC()
			if proj:HasProjectileFlags(ProjectileFlags.HIT_ENEMIES) then
				goAhead = true
			end
		else
			player = coll:ToPlayer()
			coll = coll:ToPlayer()
			if not proj:HasProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER) then
				goAhead = true
			end
		end

		if goAhead then
			if not d.HitTarget or d.LeftTarget then
				d.HitTarget = coll
				sfx:Play(mod.Sounds.WrenchHit, 5, 0, false, mod:RandomInt(90,110,proj:GetDropRNG())/100)
			end
			if d.HitTarget and GetPtrHash(d.HitTarget) == GetPtrHash(coll) then
				d.LastHitFrame = proj.FrameCount
				d.LeftTarget = nil

				if player then
					player:TakeDamage(1, 0, EntityRef(proj), 0)
				elseif npc then
					npc:TakeDamage(2, 0, EntityRef(proj), 0)
				end
			end
			return true
		end
	end
end

local tryRender = {}
mod:AddCallback(ModCallbacks.MC_PRE_RENDER, function()
	tryRender = {}
end)

mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_RENDER, function(_, proj)
	local d = mod:GetEntityData(proj)
	if d.projType == "WrenchBend" and mod:IsNormalRender(false) and not tryRender[proj.InitSeed] then
		tryRender[proj.InitSeed] = true
		if d.HitTarget and d.LastHitFrame and d.LastHitFrame == proj.FrameCount then
			local sprite = proj:GetSprite()
			local afterimage = Isaac.Spawn(mod.FF.GenericAfterimage.ID, mod.FF.GenericAfterimage.Var, mod.FF.GenericAfterimage.Sub, proj.Position, Vector.Zero, proj):ToEffect()
			mod:GetEntityData(afterimage).customAfterimageData = {
				timeout = 25, sprite = sprite, anim = "Big", animFrame = 1, vel = Vector(proj.Velocity.X, proj.Velocity.Y)/5, customFunc = function(e, entry)
					local s = e:GetSprite()
					if e.FrameCount % 6 == 5 then
						s.Rotation = s.Rotation+15
					end
					if e.FrameCount > 11 then
						s:Play("Blurry", true)
					end
					if e.FrameCount > 10 and not entry.fade then
						entry.fadeCalc = 0.15
						entry.fade = true
					end
					e.Velocity = entry.vel
				end,
			}
			afterimage.SpriteOffset = Vector(0, proj.Height/2)
			afterimage.SpriteScale = Vector(0.65,0.65)
			afterimage.DepthOffset = proj.FrameCount
			afterimage:Update()
		end
	end
end, ProjectileVariant.PROJECTILE_GRID)