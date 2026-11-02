local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

-- Shared callbacks for Fiend Folio's "Technical Entities" (type 150)

-- MC_POST_NPC_INIT
function mod:checkTechnicalInit(npc)
	local variant = npc.Variant
	local subtype = npc.SubType

	if variant == 0 then
		mod.dankSlimeInit(npc)
	elseif variant == 1 then -- Bubble
		local target = npc:GetPlayerTarget()
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
		if subtype < 4 then
			mod.BubbleTotal = mod.BubbleTotal or {}
			table.insert(mod.BubbleTotal, npc)
			if #mod.BubbleTotal > 100 then
				mod.BubbleTotal[1]:TakeDamage(1, 0, EntityRef(target), 0)
				table.remove(mod.BubbleTotal, 1)
			end
		end

		if Isaac.GetChallenge() == mod.challenges.dirtyBubble then
			local d = mod:GetEntityData(npc)
			d.Timeout = 250
		end
	elseif variant == 2 then
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
	elseif variant == 33 then --Toxic Cloud Spawner
		local cloud = Isaac.Spawn(1000,141,0,npc.Position,Vector.Zero,nil)
		if subtype == 0 then
			mod:GetEntityData(cloud).LeaveOnRoomClear = true
		end
		npc:Remove()
	elseif variant == 1000 then
		npc:Remove()
	elseif variant == mod.FF.SummonsMaker.Var then
		mod:summoningMarkerPostInit(npc)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT , mod.checkTechnicalInit, mod.FFID.Tech)

-- MC_NPC_UPDATE
--Run Technical AI, 950ai, technicalai
function mod:checkTechnical(npc)
	local variant = npc.Variant
	local subType = npc.SubType

	if variant ~= 10 and variant ~= 12 then
		if not npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
			npc:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
		end
	end

	if variant == 0 then
		mod:dankSlimeAI(npc, subType)
	elseif variant == 1 then
		mod:bubbleAI(npc)
	elseif variant == 2 then
		mod.flakCannonFlyAI(npc)
	elseif variant == 3 then
		mod:nimbuscloudai(npc, subType)
	elseif variant == 4 then
		mod:corpseAI(npc)
	elseif variant == 5 then
		mod:bonerocketAI(npc)
	elseif variant == 6 then
		if subType == 1 then
			mod:homingStingerProjectileAI(npc)
		elseif subType == mod.FF.StingerProjBeebee.Sub then
			mod:beebeeStingerProjectileAI(npc)
		else
			mod:stingerProjectileAI(npc)
		end
	elseif variant == 7 then
		mod:sporeProjectileAI(npc)
	elseif variant == 8 then
		mod:dogmeatProjectileAI(npc)
	elseif variant == 9 then
		mod:flyingMaggotAI(npc, subType)
	elseif variant == 10 then
		mod:waitingSpiderAI(npc, subType)
	elseif variant == 11 then
		mod:scytheRiderScytheAI(npc, subType)
	elseif variant == 12 then
		mod:hollowKnightProjectileAI(npc, npc:GetSprite(), mod:GetEntityData(npc))
	elseif variant == 13 then
		if subType == 10 then
			mod:technicianProjAI(npc)
		elseif subType == 20 then
			mod:owlStarProj(npc)
		else
			mod:wardenBallAI(npc)
		end
	elseif variant == 14 then
		mod:garyAI(npc)
	elseif variant == 15 then
		mod:floatingSporeAI(npc)
	elseif variant == 16 then
		mod:waitingWormAI(npc, subType)
	elseif variant == 17 then
		mod:bigHemoProjAI(npc)
	elseif variant == 18 then
		mod:horse(npc)
	elseif variant == 19 then
		mod:drsBone(npc)
	elseif variant == 20 then
		mod:dominatorChainBall(npc)
	elseif variant == 21 then
		mod:sternumRibsAI(npc, subType)
	elseif variant == 23 then
		mod:psionEgAI(npc, subType)
	elseif variant == 24 or variant == mod.FF.Miscarriage.Var then
		mod:amnioticAI(npc, subType)
	elseif variant == 25 then
		mod:davyCrockettAI(npc, subType)
	elseif variant == 26 then
		mod:nuclearWasteBarrelAI(npc, subType)
	elseif variant == 27 then
		mod:spiderRollerMineAI(npc, subType)
	elseif variant == 28 then
		mod:quackMineAI(npc, subType)
	elseif variant == mod.FF.DangerousDisc.Var then
		mod:dangerousDiscAI(npc)
	elseif variant == mod.FF.DangerousDiscGuide.Var then
		mod:dangerousDiscGuideAI(npc)
	elseif variant == mod.FF.HitcherPitchfork.Var then
		mod:pitchforkProjAI(npc)
	elseif variant == mod.FF.Hitbox.Var then
		mod:customHitboxAI(npc)
	elseif variant == mod.FF.MemberCardRelocator.Var then
		mod:memberCardRelocatorAI(npc)
	elseif variant == mod.FF.FriendFireball.Var then --in friend.lua
		mod:friendFireballUpdate(npc)
	elseif variant == mod.FF.HunkOfGunk.Var then --in ferrium scripts
		mod:hunkOfGunkAI(npc)
	elseif variant == mod.FF.DriedPaintMonster.Var then --in erfly scripts
		mod:driedPaintMonsterAI(npc)
	elseif variant == mod.FF.DelugeHelper.Var then
		mod:DelugeHelperAI(npc)
	elseif variant == mod.FF.CurseOfTheGateKeySpawner.Var then
		mod:curseOfTheGateKeySpawnerAI(npc)
	elseif variant == mod.FF.BigHornBigBomb.Var then
		mod:bigHornBigBombBigAssBigAI(npc)
	elseif variant > 999 and variant < 1010 then
		npc:Remove()
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkTechnical, mod.FFID.Tech)

-- MC_POST_NPC_RENDER
function mod:technicalRender(npc, offset)
	if npc.Variant == mod.FF.DelugeHelper.Var then
		mod:LaunchedEnemyRender(npc, mod:GetEntityData(npc))
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.technicalRender, mod.FFID.Tech)

-- MC_PRE_NPC_COLLISION
--150Coll, 150 Collision
function mod:checkTechnicalCollision(npc1, npc2, first)
	local var = npc1.Variant
	if var == 0 then
		mod:ReimplementKnifeDamage(npc1, npc2)
	elseif var == 1 then
		mod:ReimplementKnifeDamage(npc1, npc2)
		if npc1:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
			if npc2:IsEnemy() and not npc2:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then -- Enemies but no Friends
				if npc1.SubType ~= 17 then
					mod:GetEntityData(npc1).IsPopping = true
					npc1.State = 11
				end
				local mult = 1
				if npc1.SubType == 0 then
					mult = 0.75
				elseif npc1.SubType <= 3 then
					mult = mult * npc1.SubType
				end

				npc2:TakeDamage(3.5 * mult, 0, EntityRef(npc1), 0)

				if npc1.SubType == 13 or npc1.SubType == 15 or npc1.SubType == 16 then
					npc1.Velocity = mod.nilvector
					npc1.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
					npc1.HitPoints = 0
				end
			end
		else
			if npc2.Type == EntityType.ENTITY_PLAYER then
				local d = mod:GetEntityData(npc1)
				if d.BabyBubblesSpawning and d.BabyBubblesSpawning > 0 then
					return true
				end
			end
			if npc1.SubType == mod.FF.BubbleLeper.Sub or npc1.SubType == mod.FF.BubbleLargeLeper.Sub or npc1.SubType == mod.FF.BubbleProvidence.Sub then
				if npc2.Type == EntityType.ENTITY_FAMILIAR then
					return true
				end
				local d = mod:GetEntityData(npc1)
				npc1.Velocity = mod.nilvector
				npc1.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				npc1.HitPoints = 0
				d.IsPopping = true
				d.PoppedByDamage = d.PoppedByDamage or npc2.Type == EntityType.ENTITY_TEAR or npc2.Type == EntityType.ENTITY_KNIFE
				npc1.State = 11
			end
		end
	elseif var == 6 then
		if npc1.SubType == 0 then
			local effect = Isaac.Spawn(1000,7014,0,npc1.Position,mod.nilvector,nil)
			effect.SpriteRotation = npc1.SpriteRotation
			effect:Update()
			npc1:Remove()
		--[[elseif npc1.SubType == mod.FF.StingerProjBeebee.Sub then
			local effect = Isaac.Spawn(1000,7014,1,npc1.Position,mod.nilvector,nil)
			effect.SpriteRotation = npc1.SpriteRotation
			effect:Update()
			npc1:Remove()]]
		end
	elseif var == 13 then
		if npc1.SubType == 10 then
			if mod:isFriend(npc1) and mod:isFriend(npc2) then
				return false
			end
			mod:dieTechnicianProj(npc1)
			local randExt = math.random(45)
			for i = 45, 360, 45 do
				local spawner = npc1
				local laser = Isaac.Spawn(1000, 1737, 0, npc1.Position, Vector(0, 10):Rotated(i + randExt), npc1):ToEffect()
				laser:Update()
				laser.Parent = npc1.SpawnerEntity
				mod:GetEntityData(laser).vec = laser.Velocity:Rotated(-115)
				if mod:isFriend(npc1) then
					mod:GetEntityData(laser).DamageToDo = 15
				end
				--laser.SpriteScale = laser.SpriteScale * 0.5
				laser:Update()
			end
			return true
		elseif npc1.SubType == 20 then
			mod:owlStarProjColl(npc1)
		else
			if npc2.Type == 1 then
				sfx:Play(mod.Sounds.WardenHit, 1, 0, false, 1)
				local effect = Isaac.Spawn(1000,1728,0,npc2.Position,mod.nilvector,nil)
				npc1.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				mod:GetEntityData(npc1).jivin = true
				npc1:Update()
			end
		end
	elseif var == 20 then
		if npc2.Type == 1 then
			mod:GetEntityData(npc1).state = "control"
			npc1.Parent = npc2
		end
	elseif var == 23 then
		mod:ReimplementKnifeDamage(npc1, npc2)
		if not (npc2.Type and npc2.Variant == 23) then
			mod:GetEntityData(npc1).FFPsyEgKill = true
		end
	elseif var == 24 or var == mod.FF.Miscarriage.Var then
		mod:ReimplementKnifeDamage(npc1, npc2)
		if npc2:ToPlayer() then
			npc1:TakeDamage(10, 0, EntityRef(npc2), 0)
		end
	elseif var == 27 then
		mod:ReimplementKnifeDamage(npc1, npc2)
		if npc2:ToPlayer() then
			npc1:Kill()
		end
	elseif var == 28 then
		mod:ReimplementKnifeDamage(npc1, npc2)
	elseif var == mod.FF.RollingHollowKnight.Var then
		local data = mod:GetEntityData(npc1)
		if data.brain and npc2.InitSeed == data.brain.InitSeed and npc2.Index == data.brain.Index then
			return true
		end
	elseif var == mod.FF.Hitbox.Var then
		local data = mod:GetEntityData(npc1)
		if data.OnCollide then
			return data.OnCollide(npc1, npc2, first)
		end
	elseif var == mod.FF.FriendFireball.Var then
		return mod:FriendFireballCollide(npc1, npc2, first)
	elseif var == mod.FF.HunkOfGunk.Var then --in ferrium scripts
		return mod:hunkOfGunkColl(npc1, npc2, first)
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION , mod.checkTechnicalCollision, mod.FFID.Tech)

function mod:DoesKnifeDealDamageWhileIdle(knife)
	return (knife.Variant == KnifeVariant.MOMS_KNIFE or knife.Variant == KnifeVariant.SUMPTORIUM)
end

function mod:ReimplementKnifeDamage(ent, knife)
	if knife and knife:ToKnife() and not mod:isFriend(ent) then
		knife = knife:ToKnife()
		if (knife:IsFlying() or mod:DoesKnifeDealDamageWhileIdle(knife)) then
			ent:TakeDamage(knife.CollisionDamage, 0, EntityRef(knife.Parent), 0)
		end
	end
end

mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, function(_, tear, collider)
	if collider.Type == mod.FFID.Tech then
		if collider.Variant == mod.FF.Hitbox.Var then
			if collider.SpawnerEntity and collider.SpawnerEntity:Exists() and collider.SpawnerEntity:ToNPC() then
				tear:ForceCollide(collider.SpawnerEntity, true) --Doesn't erase it lol!!!
			end
			tear:Die()
			return true
		end
	end
end, TearVariant.ERASER)

-- MC_ENTITY_TAKE_DMG
--150Hurt
function mod:checkTechnicalHurt(npc, damage, flag, source, countdown)
	local var = npc.Variant
	if var == 22 then
		return false
	elseif var == mod.FF.SternumRib.Var then
		return false
	elseif var == mod.FF.RollingHollowKnight.Var then
		local data = mod:GetEntityData(npc)
		if flag == flag | DamageFlag.DAMAGE_POISON_BURN and data.brain then
			data.brain:TakeDamage(damage, flag | DamageFlag.DAMAGE_CLONES, source, 0)
		end
	elseif var == mod.FF.NuclearWaste.Var then
		return false
	elseif var == mod.FF.Hitbox.Var then
		local data = mod:GetEntityData(npc)
		if data.OnHurt then
			return data.OnHurt(npc, damage, flag, source, countdown)
		elseif data.Relay then
			local flags = flag
			if data.Clones then
				flags = flags | DamageFlag.DAMAGE_CLONES
			end

			if data.Relay == true then
				npc.SpawnerEntity:TakeDamage(damage, flags, source, countdown)
			else
				data.Relay:TakeDamage(damage, flags, source, countdown)
			end

			return false
		else
			return false
		end
	elseif var == mod.FF.FriendFireball.Var then
		if source and source.Entity then
			if mod:GetEntityData(source.Entity).IgnoreFriendFireball or npc.FrameCount < 5 then
			else
				if source.Entity:ToPlayer() or (source.Entity.SpawnerEntity and source.Entity.SpawnerEntity:ToPlayer()) then
					local d = mod:GetEntityData(npc)
					d.SuperExplode = true
					d.HitDirection = source.Entity.Velocity:Normalized()
				end
			end
		end
		return false
	elseif var == mod.FF.DriedPaintMonster.Var then
		if npc.FrameCount < 5 then
			return false
		end
	elseif var == mod.FF.HunkOfGunk.Var then
		mod:hunkOfGunkHurt(npc, damage, flag, source)
	end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG , mod.checkTechnicalHurt, mod.FFID.Tech)

-- MC_POST_ENTITY_KILL
--950Kill
function mod:checkTechnicalKill(npc)
	local var = npc.Variant
	if var == mod.FF.RollingHollowKnight.Var then
		local data = mod:GetEntityData(npc)
		if data.brain then
			--ew hacky workarounds ewwwww
			data.brain.HitPoints = 0
			data.brain:TakeDamage(0.001, 0, EntityRef(npc), 0)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.checkTechnicalKill, mod.FFID.Tech)

-- For ignoring effects like Euthenasia
function mod:checkTechnicalVanillaTearFlags(entity, pos, flags, source, damage)
	if entity.Type == mod.FF.Hitbox.ID and entity.Variant == mod.FF.Hitbox.Var then
		local data = mod:GetEntityData(entity)
		if data.IgnoreTearFlagEffects then
			return false
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_APPLY_TEARFLAG_EFFECTS, mod.checkTechnicalVanillaTearFlags)