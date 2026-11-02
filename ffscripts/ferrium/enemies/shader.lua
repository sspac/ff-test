local mod = FiendFolio
local game = Game()

function mod:shaderAI(npc)
	local sprite = npc:GetSprite()
	local target = npc:GetPlayerTarget()
	local data = mod:GetEntityData(npc)
	local room = game:GetRoom()
	local rand = npc:GetDropRNG()

	if room:GetFrameCount() == 0 then
		if mod:isFriend(npc) then
			data.state = "Idle"
			data.isJumping = 0
			mod:spritePlay(sprite, "Idle")
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
			npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
            npc:ClearEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
		end
	end

	if not data.init then
		if npc.SubType > 0 and not data.waited then
			npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			npc:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
			npc.Visible = false
			mod:makeWaitFerr(npc, mod.FFID.Ferrium, npc.Variant, npc.SubType, 60, false)
		elseif data.waited then
			data.state = "Waiting"
			npc.Visible = false
		end
		if npc.SubType > 0 then
			npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
        else
			data.state = "Idle"
		end
		data.init = true
        npc.SplatColor = Color(0, 0, 0, 1, 0, 0, 0)
		npc.StateFrame = rand:RandomInt(10)+5
	else
		npc.StateFrame = npc.StateFrame+1
	end

	if data.isJumping == 1 then
		data.JumpTimer = data.JumpTimer or 0
		data.JumpTimer = data.JumpTimer + 1
		local timerLimit = 60
		local dist = (npc.Position-data.playerPos):Length()
		if dist < 20 or data.JumpTimer > timerLimit then
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
		data.JumpTimer = nil
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
			npc:PlaySound(SoundEffect.SOUND_MEAT_JUMPS,1,2,false,1)
		else
			mod:spritePlay(sprite, "Jump")
		end
	elseif data.state == "JumpDown" then
		if sprite:IsFinished("Fall") then
			data.state = "Idle"
            if data.shaderLand then
                npc.StateFrame = 40
            else
                npc.StateFrame = -rand:RandomInt(15)
            end
		elseif sprite:IsEventTriggered("Land") then
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
			npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
            npc:ClearEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
            npc:PlaySound(SoundEffect.SOUND_MEAT_IMPACTS,1,2,false,1)

            if data.ignoreFirstLand then
                data.ignoreFirstLand = nil
            elseif not data.shaderLand then
                data.shaderLand = Isaac.Spawn(mod.FF.SlimShadyNova.ID, mod.FF.SlimShadyNova.Var, mod.FF.SlimShadyNova.Sub, npc.Position, Vector.Zero, npc):ToEffect()
                mod:GetEntityData(data.shaderLand).shaderSpawn = npc
                mod:GetEntityData(data.shaderLand).Init = true
                data.shaderLand:GetSprite():Play("ShaderGlow", true)
                data.shaderLand.DepthOffset = -100
                data.shaderLand.SpriteScale = Vector(1, 0.7)
                data.shaderLand:Update()
            elseif data.shaderLand:Exists() then
                local pos = data.shaderLand.Position
                local explosion = Isaac.Spawn(1000, 144, 1, pos, Vector.Zero, npc):ToEffect()
                explosion.Parent = npc
                explosion.SpriteScale = Vector(1.5, 1.5)
                local friend = mod:isFriend(npc)
                if friend then
                    mod:DamageEnemiesInRadius(pos, 50, 40, npc)
                else
                    mod:DamagePlayersInRadius(pos, 50, 1, npc)
                end
                npc:PlaySound(SoundEffect.SOUND_DEMON_HIT, 1, 0, false, 1)
                mod.scheduleForUpdate(function()
                    npc:PlaySound(SoundEffect.SOUND_DEMON_HIT, 0.7, 0, false, 1.15)
                    for i=1,4 do
                        local newPos = pos+Vector(0,75):Rotated(i*90)
                        local nextPos = newPos+Vector(0,60):Rotated(i*90)
                        local exp2 = Isaac.Spawn(1000, 144, 1, newPos, Vector.Zero, npc):ToEffect()
                        exp2.Parent = npc
                        exp2.SpriteScale = Vector(0.85, 0.85)
                        exp2:Update()
                        if friend then
                            mod:DamageEnemiesInRadius(newPos, 35, 40, npc)
                        else
                            mod:DamagePlayersInRadius(newPos, 35, 1, npc)
                        end

                        mod.scheduleForUpdate(function()
                            local exp3 = Isaac.Spawn(1000, 144, 1, nextPos, Vector.Zero, npc):ToEffect()
                            exp3.Parent = npc
                            exp3.SpriteScale = Vector(0.8,0.8)
                            exp3:Update()
                            if friend then
                                mod:DamageEnemiesInRadius(nextPos, 35, 40, npc)
                            else
                                mod:DamagePlayersInRadius(nextPos, 35, 1, npc)
                            end
                        end, 10)
                    end
                    mod.scheduleForUpdate(function()
                        npc:PlaySound(SoundEffect.SOUND_DEMON_HIT, 0.4, 0, false, 1.45)
                    end, 10)
                end, 15)

                local params = ProjectileParams()
                params.Color = mod.ColorShadyRed
                params.Scale = 1.5
                mod:SetGatheredProjectiles()
                for i=1,3 do
                    params.Acceleration = (i+2)^2
                    for j=1,4 do
                        npc:FireProjectiles(npc.Position, Vector(0,4):Rotated(45+90*j), 0, params)
                    end
                end
                for _,proj in ipairs(mod:GetGatheredProjectiles()) do
                    local pd = mod:GetEntityData(proj)
                    pd.projType = "customProjectileBehavior"
                    pd.customProjectileBehavior = {update = function(v, tab)
                        if v.FrameCount >= 10 then
                            v.Velocity = mod:Lerp(v.Velocity, v.Velocity:Resized(tab.speed), 0.3)
                        else
                            v.Velocity = mod:Lerp(v.Velocity, Vector.Zero, 0.05)
                            v.FallingSpeed = 0
                            v.FallingAccel = -0.1
                        end
                    end, speed = proj.Acceleration}
                end

                data.shaderLand:Remove()
                data.shaderLand = nil
            else
                data.shaderLand = Isaac.Spawn(mod.FF.SlimShadyNova.ID, mod.FF.SlimShadyNova.Var, mod.FF.SlimShadyNova.Sub, npc.Position, Vector.Zero, npc):ToEffect()
                mod:GetEntityData(data.shaderLand).shaderSpawn = npc
                mod:GetEntityData(data.shaderLand).Init = true
                data.shaderLand:GetSprite():Play("ShaderGlow", true)
                data.shaderLand.DepthOffset = -100
                data.shaderLand.SpriteScale = Vector(1, 0.7)
                data.shaderLand:Update()
            end
		else
			mod:spritePlay(sprite, "Fall")
		end
	elseif data.state == "Waiting" then
		npc.Velocity = Vector.Zero
		sprite:Play("Fall", true)
		data.state = "JumpDown"
        data.ignoreFirstLand = true
		npc:ClearEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
		npc.Visible = true
		npc.Position = npc.Position+RandomVector()*5
	end

	if data.state == "JumpUp" or data.state == "JumpDown" then
		npc.Velocity = (data.targetVel * 0.3) + (npc.Velocity * 0.6)
	else
		npc.Velocity = Vector.Zero
	end
end