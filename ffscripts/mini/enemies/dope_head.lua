local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

function mod:dopeheadprojectileai(npc, sprite, data)
	if not data.Init then
		npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        npc:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS + EntityFlag.FLAG_NO_TARGET + EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK + EntityFlag.FLAG_NO_KNOCKBACK + EntityFlag.FLAG_NO_BLOOD_SPLASH)
        npc:AddEntityFlags(EntityFlag.FLAG_NO_DEATH_TRIGGER + EntityFlag.FLAG_HIDE_HP_BAR + EntityFlag.FLAG_NO_FLASH_ON_DAMAGE + EntityFlag.FLAG_NO_REWARD)
		npc.SplatColor = mod.ColorDankBlackReal
		data.State = "Chase"
		data.Init = true
	end

	if data.State == "Chase" then
		local player = game:GetNearestPlayer(npc.Position)
		local vec = mod:Lerp(npc.Velocity, (player.Position - npc.Position):Resized(10), 0.05)
		npc.Velocity = vec:Resized(math.max(vec:Length(), 10))

		local frame = math.floor(8 - ((mod:GetAngleDegreesButGood(vec:Rotated(215))+12.5)%360)/45)
		sprite:SetFrame("Rotate01", frame)

		if npc:CollidesWithGrid() then
			sfx:Play(SoundEffect.SOUND_BONE_BOUNCE, 0.7, 0, false, 0.8)
			data.State = "Collide"
			--mod:DestroyDopeHeadProjectile(npc)
		end
	elseif data.State == "Collide" then
		npc.Velocity = npc.Velocity * 0.925
		if not data.Anim then
			if npc.Velocity.X < 0 then
				data.Anim = "SpinR"
			else
				data.Anim = "SpinL"
			end
		end

		if sprite:IsFinished(data.Anim) then
			mod:DestroyDopeHeadProjectile(npc)
		else
			mod:spritePlay(sprite, data.Anim)
		end
	end
end

function mod:DestroyDopeHeadProjectile(npc)
	local rng = npc:GetDropRNG()
	local angle = mod:RandomAngle(rng)
	for i = 45, 360, 45 do
		local params = ProjectileParams()
		if rng:RandomFloat() <= 0.5 then
			params.Variant = 1
			params.Color = mod.ColorDopeHead
		else
			params.Variant = 0
			params.Color = mod.ColorDankBlackReal
		end
		npc:FireProjectiles(npc.Position, Vector(8,0):Rotated(i+angle), 0, params)
	end
	npc:Kill()
end

function mod:dopeheadai(npc, sprite, npcdata)
	local room = game:GetRoom()
	if not npcdata.init then
		npc:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_BLOOD_SPLASH)
		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
		npcdata.init = true
		npc.Velocity = Vector(1, 1)
		npcdata.prevx = FiendFolio.sign(npc.Velocity.X);
		npcdata.prevy = FiendFolio.sign(npc.Velocity.Y);
		npcdata.die = false
		mod:spritePlay(sprite, "idle")
		npc.SplatColor = mod.ColorDankBlackReal
	else
		if npcdata.die then
			npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.15)
			if sprite:IsEventTriggered("fuckoff") then
				npc:Kill()
			end
		else
			if npcdata.junksucked then --Handling beyond the timer is handled in Junkstrap AI
				npcdata.junksucked = npcdata.junksucked - 1
				if npcdata.junksucked <= 0 then
					npcdata.junksucked = nil
				end
			else
				if sprite:IsFinished("spinr") or sprite:IsFinished("spinl") then
					mod:spritePlay(sprite, "idle")
				end
				if(FiendFolio.sign(npc.Velocity.X) ~= npcdata.prevx or FiendFolio.sign(npc.Velocity.Y) ~= npcdata.prevy) then
					npcdata.prevx = FiendFolio.sign(npc.Velocity.X);
					npcdata.prevy = FiendFolio.sign(npc.Velocity.Y);
					npc.Velocity = npc.Velocity:Normalized() * 12
					if npcdata.prevx == 1 then
						sfx:Play(SoundEffect.SOUND_BONE_BOUNCE, 0.7, 0, false, 0.8)
						mod:spritePlay(sprite, "spinr")
					else
						mod:spritePlay(sprite, "spinl")
						sfx:Play(SoundEffect.SOUND_BONE_BOUNCE, 0.7, 0, false, 0.8)
					end
				end
				local d = mod:diagonalMove(npc, 2.5, true);
				npc.Velocity = mod:Lerp(npc.Velocity, d, 0.1)
			end
			if room:IsClear() and not mod.FindDoorShutter() then
				npcdata.die = true
				mod:spritePlay(sprite, "death")
				sfx:Play(SoundEffect.SOUND_DEVILROOM_DEAL, 1, 0, false, 1)
			end
		end
	end
end

if ModCallbacks.MC_POST_START_AMBUSH_WAVE then
mod:AddEntityCallback(ModCallbacks.MC_POST_START_AMBUSH_WAVE, mod.FF.DopeHead.ID, mod.FF.DopeHead.Var, nil, function(_, bossAmbush)
	if bossAmbush and game:GetRoom():GetType() == RoomType.ROOM_BOSSRUSH then
		for _, dope in ipairs(Isaac.FindByType(mod.FF.DopeHead.ID, mod.FF.DopeHead.Var)) do
			local npcdata = mod:GetEntityData(dope)
			if not npcdata.die then
				npcdata.die = true
				mod:spritePlay(dope:GetSprite(), "death")
				sfx:Play(SoundEffect.SOUND_DEVILROOM_DEAL, 1, 0, false, 1)
			end
		end
	end
end)
end