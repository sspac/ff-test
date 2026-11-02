-- Clickety Char --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

function mod:clicketyCharAI(npc, sprite, npcdata)
	local path = npc.Pathfinder
	local target = npc:GetPlayerTarget()
	local targetpos = mod:randomConfuse(npc, target.Position)
	mod.QuickSetEntityGridPath(npc, 900)

	if not npcdata.init then
		if npc.SubType == 1 then
			if not npcdata.state then
				npcdata.state = "pile"
			end
			npcdata.canDamage = false
			npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
			npc:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
			npc.HitPoints = 9.0
			npc.StateFrame = 150
		else
			npcdata.state = "idle"
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
			npcdata.canDamage = true
			npc.StateFrame = 0
		end
		npc.SplatColor = Color(0.15, 0.0, 0.0, 1.0, 0.1, 0.1, 0.1)
		npcdata.init = true
	end
	
	if npcdata.state == "idle" then
		npcdata.canDamage = true
		npc:ClearEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
		
		if mod:isScare(npc) then
			local targetvel = (targetpos - npc.Position):Resized(-7)
			npc.Velocity = mod:Lerp(npc.Velocity, targetvel,0.25)
		elseif game:GetRoom():CheckLine(npc.Position,targetpos,0,1,false,false) then
			local targetvel = (targetpos - npc.Position):Resized(4)
			npc.Velocity = mod:Lerp(npc.Velocity, targetvel,0.25)
		else
			path:FindGridPath(targetpos, 0.6, 900, true)
			npcdata.currentvelocity = npc.Velocity
		end
		
		if npc.Velocity:Length() > 0.3 then
			local angle = npc.Velocity:GetAngleDegrees()
			while angle < 0.0 do
				angle = angle + 360.0
			end
			
			local walkAnim = "WalkRight"
			if angle > 45.0 and angle <= 135.0 then
				walkAnim = "WalkDown"
			elseif angle > 135.0 and angle <= 225.0 then
				walkAnim = "WalkLeft"
			elseif angle > 225.0 and angle <= 315.0 then
				walkAnim = "WalkUp"
			end
			
			if not sprite:IsPlaying(walkAnim) then
				if sprite:IsPlaying("WalkRight") or
				   sprite:IsPlaying("WalkDown") or
				   sprite:IsPlaying("WalkLeft") or
				   sprite:IsPlaying("WalkUp") or 
				   sprite:IsPlaying("Idle")
				then
					local frame = sprite:GetFrame()
					sprite:Play(walkAnim, true)
					sprite:SetFrame(frame)
				else
					sprite:Play(walkAnim, true)
				end
			end
		else
			if not sprite:IsPlaying("Idle") then
				if sprite:IsPlaying("WalkRight") or
				   sprite:IsPlaying("WalkDown") or
				   sprite:IsPlaying("WalkLeft") or
				   sprite:IsPlaying("WalkUp") or 
				   sprite:IsPlaying("Idle")
				then
					local frame = sprite:GetFrame()
					sprite:Play("Idle", true)
					sprite:SetFrame(frame)
				else
					sprite:Play("Idle", true)
				end
			end
		end
	end
	
	if npcdata.state == "collapse" then
		npc:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
		npc.Velocity = nilvector
		if npc.StateFrame > 0 then
			npc.StateFrame = npc.StateFrame - 1
		end
	
		if sprite:IsFinished("Collapse") then
			npcdata.state = "pile"
		elseif not sprite:IsPlaying("Collapse") then
			sprite:Play("Collapse", true)
		end
		
		if sprite:IsEventTriggered("Shoot") then
			sfx:Play(SoundEffect.SOUND_FLAMETHROWER_END, 1, 0, false, math.random(90,110)/100)
			for i = 90, 360, 90 do
				local plume = Isaac.Spawn(1000, 147, 0, npc.Position + Vector(40, 0):Rotated(i), nilvector, npc):ToEffect()
				plume.SpriteScale = Vector(0.8,0.8)
				plume.SpawnerEntity = npc
				plume:Update()
			end
			mod.scheduleForUpdate(function()
				sfx:Play(SoundEffect.SOUND_FLAMETHROWER_END, 1, 0, false, math.random(90,110)/100)
				for i = 45, 360, 45 do
					local plume = Isaac.Spawn(1000, 147, 0, npc.Position + Vector(80, 0):Rotated(i), nilvector, npc):ToEffect()
					plume.SpriteScale = Vector(0.8,0.8)
					plume.SpawnerEntity = npc
					plume:Update()
				end
			end, 10, ModCallbacks.MC_POST_UPDATE, false)
		end
	end
	
	if npcdata.state == "pile" then
		npc:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
		npc.Velocity = nilvector
		
		if not sprite:IsPlaying("Pile") then
			sprite:Play("Pile", true)
		end
		
		if not npc:IsDead() then
			local charmanders = Isaac.FindByType(mod.FF.ClicketyChar.ID, mod.FF.ClicketyChar.Var, -1, true)
			local isFriendly = npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)
			local timeToDie = true
			for _, charmander in ipairs(charmanders) do
				if charmander.SubType == 0 and charmander:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) == isFriendly then
					timeToDie = false
					break
				elseif charmander.SubType == 1 and mod:GetEntityData(charmander).state == "collapse" then
					timeToDie = false
					break
				end
			end
			
			if timeToDie then
				for _, charmander in ipairs(charmanders) do
					if charmander:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) == isFriendly then
						charmander:Kill()
					end
				end
				npc:Kill()
			end
		end
		
		if npc.StateFrame > 0 then
			npc.StateFrame = npc.StateFrame - 1
		end
		if npc.StateFrame <= 0 then
			npcdata.state = "regen"
		end
	end
	
	if npcdata.state == "regen" then
		npc.Velocity = nilvector
		
		if sprite:IsFinished("Regen") then
			npcdata.state = "idle"
		elseif not sprite:IsPlaying("Regen") then
			sprite:Play("Regen", true)
		end
		
		if npc.SubType == 0 then
			npc:ClearEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
		elseif npc.SubType == 1 then
			npc:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
		end
		
		if sprite:IsEventTriggered("Shoot") then
			npc.SubType = 0
			npcdata.canDamage = true
			npc.StateFrame = 0
		end
	end
end

function mod:clicketyCharTakeDmg(entity, damage, flags, source, countdown)
	if not mod:GetEntityData(entity).canDamage then
		return false
	end
end

mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CallbackPriority.IMPORTANT, function(_, entity, damage, flags, source, countdown)
	if entity and entity.Variant == mod.FF.ClicketyChar.Var and 
	   flags & DamageFlag.DAMAGE_FIRE == DamageFlag.DAMAGE_FIRE and
	   source and source.SpawnerType == mod.FFID.Taiga and source.SpawnerVariant == mod.FF.ClicketyChar.Var
	then
		local tookDamage = entity:TakeDamage(damage / 2, flags - DamageFlag.DAMAGE_FIRE, source, countdown)
		if tookDamage then
			sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS, 1, 0, false, 1.0)
		end
		return false
	end
end, mod.FFID.Taiga)

function mod:clicketyCharKill(entity)
	local data = mod:GetEntityData(entity)
	if entity.SubType ~= 1 then
		if mod:shouldDoDeathAnimation(entity:ToNPC()) then
			local spawned = Isaac.Spawn(mod.FF.ClicketyChar.ID, mod.FF.ClicketyChar.Var, 1, entity.Position, nilvector, entity)
			
			local championID = entity:ToNPC():GetChampionColorIdx()
			if championID >= 0 then
				spawned:ToNPC():MakeChampion(0, championID)
			end
			
			mod:GetEntityData(spawned).state = "collapse"

			if (entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)) then
				spawned:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
			end

			if entity:GetData().AmonSpawned and entity.SpawnerEntity:Exists() and entity.SpawnerEntity:GetData().currentwave then
				for i, spawn in pairs(entity.SpawnerEntity:GetData().currentwave) do
					if spawn:Exists() and spawn.InitSeed == entity.InitSeed then
						entity.SpawnerEntity:GetData().currentwave[i] = spawned
						break
					end
				end
			end

			entity:Remove()
			spawned:Update()
		end
	end
end
