local mod = FiendFolio
local game = Game()

function mod:toadAI(npc)
	local sprite = npc:GetSprite()
	local target = npc:GetPlayerTarget()
	local data = mod:GetEntityData(npc)
	local room = game:GetRoom()
	local rand = npc:GetDropRNG()

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
		end
		if npc.SubType == 0 then
			data.state = "Idle"
		end
		data.init = true
		npc.StateFrame = rand:RandomInt(10)+5
	else
		npc.StateFrame = npc.StateFrame+1
	end

	if room:GetFrameCount() == 0 then
		if mod:isFriend(npc) then
			data.state = "Idle"
			mod:spritePlay(sprite, "Idle")
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
			npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
            npc:ClearEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
			data.isJumping = nil
			data.toadSequence = nil
		end
	end

	if data.isJumping == 1 then
		npc.Friction = 1
		local dist = (npc.Position-data.playerPos):Length()
		data.JumpTimer = data.JumpTimer or 0
		data.JumpTimer = data.JumpTimer + 1
		local timerLimit = 60
		if dist < 20 or data.JumpTimer > timerLimit then
			data.state = "JumpDown"
			data.isJumping = 0
			data.targetVel = Vector.Zero
			if data.toadSequence and data.toadSequence > 0 then
				sprite:Play("Idle", true)
				sprite:Play("QuickJump", true)
				data.state = "QuickJump"
			else
				data.toadSequence = nil
			end
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

            if not data.toadSequence then
                data.toadSequence = mod:RandomInt(2,4,rand)
            end
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
            if data.toadSequence then
                data.toadSequence = data.toadSequence-1
                if data.toadSequence == 0 then
                    data.toadSequence = nil
                    npc.StateFrame = -rand:RandomInt(20)
                else
                    npc.StateFrame = 45
                end
            else
                npc.StateFrame = -rand:RandomInt(20)
            end
		elseif sprite:IsEventTriggered("Land") then
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
			npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
            npc:ClearEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)

			npc:PlaySound(SoundEffect.SOUND_MEAT_IMPACTS,1,2,false,1)
		else
			mod:spritePlay(sprite, "Fall")
		end
	elseif data.state == "QuickJump" then
		if sprite:IsFinished("QuickJump") then

		elseif sprite:IsEventTriggered("Land") then
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
			npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
            npc:ClearEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)

			npc:PlaySound(SoundEffect.SOUND_MEAT_IMPACTS,1,2,false,1)
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

			if data.toadSequence then
                data.toadSequence = data.toadSequence-1
                if data.toadSequence == 0 then
                    data.toadSequence = nil
                end
            end
		elseif sprite:IsEventTriggered("Sound") then
			npc:PlaySound(SoundEffect.SOUND_MEAT_JUMPS,1,2,false,1)
		else
			mod:spritePlay(sprite, "QuickJump")
		end
	elseif data.state == "Waiting" then
		npc.Velocity = Vector.Zero
		sprite:Play("Fall", true)
		data.state = "JumpDown"
		npc:ClearEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
		npc.Visible = true
		npc.Position = npc.Position+RandomVector()*5
	end

	if data.state == "JumpUp" or data.state == "JumpDown" or data.state == "QuickJump" then
		npc.Velocity = (data.targetVel * 0.3) + (npc.Velocity * 0.6)
	else
		npc.Velocity = Vector.Zero
	end

    if npc:IsDead() and mod:shouldDoDeathEffect(npc) then
        local poof = Isaac.Spawn(1000, 16, 4, npc.Position, Vector.Zero, npc):ToEffect()
        poof.Color = mod.ColorDarkPurple
        npc:PlaySound(SoundEffect.SOUND_DEATH_CARD, 0.6, 0, false, mod:RandomInt(150,180,npc:GetDropRNG())/100)
        local aura = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HALO, 3, npc.Position, Vector.Zero, nil):ToEffect()
        aura.SpriteScale = Vector.Zero
        aura.Parent = Isaac.GetPlayer()
        table.insert(mod.toadCurseAuras, {scale = 0, frames = 0, friend = mod:isFriend(npc), aura = aura, shrinkVel = 0.001, shrinkAccel = 0.001})

		for i=1,7 do
			local randVel = RandomVector()*mod:getRoll(15,40,rand)/20
			local cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, 0, npc.Position, Vector.Zero, npc):ToEffect()
			cloud:SetTimeout(mod:getRoll(200,300,rand))
			cloud.Color = Color(0.5, 0, 0.5, 0)
			local randScale = mod:getRoll(80,150,rand)/100
            cloud.SpriteScale = Vector(0.5, 0.5)
            mod:GetEntityData(cloud).cosmeticDust = {scale = randScale, vel = randVel, alpha = 0.5}
		end
    end
end

function mod:toadCurseAuraUpdate(entry, key)
    if entry.aura and entry.aura:Exists() then
        if not entry.primed then
            entry.scale = mod:Lerp(entry.scale, 1, 0.3)
            entry.aura.SpriteScale = Vector(entry.scale, entry.scale)
            if 1-entry.scale < 0.1 then
                entry.scale = 1
                entry.primed = true
            end
        else
            if mod.IsActiveRoom() then
                entry.frames = entry.frames+1
                if entry.frames > 130 then
                    entry.aura:GetSprite():Stop()
                    entry.scale = math.max(0, entry.scale-entry.shrinkVel)
                    entry.shrinkVel = entry.shrinkVel+entry.shrinkAccel

                    entry.aura.SpriteScale = Vector(entry.scale, entry.scale)
                    if entry.scale <= 0 then
                        entry.aura:Remove()
                        mod.toadCurseAuras[key] = nil
                    end
                end

				if entry.frames % 7 == 0 then
					local pos = entry.aura.Position+Vector(entry.scale*65, 0):Rotated(entry.aura:GetDropRNG():RandomInt(360))
					local wisp = Isaac.Spawn(mod.FF.ToadFearWisps.ID, mod.FF.ToadFearWisps.Var, mod.FF.ToadFearWisps.Sub, pos, Vector.Zero, entry.aura):ToEffect()
				end

                if entry.friend then
                    local ents = Isaac.FindInRadius(entry.aura.Position, 80*entry.scale, EntityPartition.ENEMY)
                    for _, ent in ipairs(ents) do
                        if ent:IsActiveEnemy() and (not mod:isFriend(ent)) and (not ent:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)) then
                            ent:AddFear(EntityRef(entry.aura), 20)
                        end
                    end
                else
                    local players = Isaac.FindInRadius(entry.aura.Position, 80*entry.scale, EntityPartition.PLAYER)
                    for _, player in ipairs(players) do
                        player:AddFear(EntityRef(entry.aura), 5)
                    end
                end
            else
                entry.scale = math.max(0, entry.scale-0.15)
                entry.aura.SpriteScale = Vector(entry.scale, entry.scale)
                if entry.scale <= 0 then
                    entry.aura:Remove()
                    mod.toadCurseAuras[key] = nil
                end
            end
        end
    else
        mod.toadCurseAuras[key] = nil
    end
end

function mod:ToadFearWispsEffect(e)
	local d = mod:GetEntityData(e)
	local sprite = e:GetSprite()

	if not d.init then
		local rng = e:GetDropRNG()
		local anim = "Idle" .. rng:RandomInt(3)+1
		d.anim = anim
		sprite.FlipX = rng:RandomInt(2) > 0
		d.init = true
	end
	
	if sprite:IsFinished(d.anim) then
		e:Remove()
	else
		mod:spritePlay(sprite, d.anim)
	end
end