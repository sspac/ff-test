local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

--Mother orb
function mod:debugToolAI(npc)
	local d = mod:GetEntityData(npc)
	local sprite = npc:GetSprite();

	if not d.init then
		d.init = true
		d.DamageCount = d.DamageCount or 0
		d.DingCount = d.DingCount or 0
		npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET)
		npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		npc.TargetPosition = npc.Position
	else
		npc.StateFrame = npc.StateFrame + 1
	end

	local mus = MusicManager()
	if mus:IsEnabled() then
		mus:Disable()
		mod:EnableManualCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.jukeboxResumeMusic)
	end

	npc.Position = npc.TargetPosition
	if d.DingCount > 0 then
		if d.DingCount == 2 then
			npc.Position = npc.TargetPosition + Vector(math.random(), 0):Rotated(math.random(360))
		elseif d.DingCount == 3 then
			npc.Position = npc.TargetPosition + Vector(math.random() * 2, 0):Rotated(math.random(360))
		elseif d.DingCount == 4 then
			npc.Position = npc.TargetPosition + Vector(math.random() * 5, 0):Rotated(math.random(360))
		end
	end

	npc.Velocity = nilvector
	npc.SpriteOffset = Vector(0, -40)
	mod:spritePlay(sprite, "Idle")
	if d.DingCount > 4 then
		MusicManager():Pause()
		MusicManager():Disable()
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
		npc.Color = Color(0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1)
		mod.motherFollowing = true
	end

	for _, player in ipairs(Isaac.FindByType(EntityType.ENTITY_PLAYER, 0)) do
		if player:ToPlayer():HasCollectible(CollectibleType.COLLECTIBLE_SUPLEX) then
			if player.Position:Distance(npc.Position) < 40 then
				while player.Position:Distance(npc.Position) < 40 do
					npc.Position = game:GetRoom():GetRandomPosition(1)
				end
			end
		end
	end

	if d.DingCount < 5 then
		local vol = math.min(0.5 + (d.DingCount * 0.5), 2)
		if npc.FrameCount % 1200 == 30 then
			sfx:Play(SoundEffect.SOUND_POWERUP1, vol, 0, false, 0.1)
		elseif npc.FrameCount % 1200 == 350 then
			sfx:Play(SoundEffect.SOUND_POWERUP3, vol, 0, false, 0.1)
		elseif npc.FrameCount % 1200 == 650 then
			sfx:Play(SoundEffect.SOUND_POWERUP1, vol, 0, false, 0.1)
		elseif npc.FrameCount % 1200 == 1020 then
			sfx:Play(SoundEffect.SOUND_POWERUP2, vol, 0, false, 0.1)
		end
	end

	d.MamaRotation = d.MamaRotation or math.random(360)
	d.MamaRotation = d.MamaRotation + 1 + d.DingCount

	local babies = Isaac.FindByType(3, mod.ITEM.FAMILIAR.BABY_ORB)
	local numBabs = #babies
	if numBabs > 0 then
		for i = 1, numBabs do
			local bd = mod:GetEntityData(babies[i])
			bd.MamasHere = npc
			bd.MamaIndex = i/numBabs
		end
	end
end

function mod:motherOrbHurt(npc, damage, flag, source)
    if flag & DamageFlag.DAMAGE_EXPLOSION ~= 0 then
        local d = mod:GetEntityData(npc)
        d.DamageCount = d.DamageCount + 1
        if d.DingCount < 5 then
            npc.Color = Color(math.random(200)/100, math.random(200)/100, math.random(200)/100, 1, 0, 0, 0)
        end
        if d.DamageCount % 2^d.DingCount == 0 then
            d.DingCount = d.DingCount + 1
            if d.DingCount == 5 --[[4]] then
                npc:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
                npc.Color = Color(0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1)
                npc:ToNPC():PlaySound(SoundEffect.SOUND_MOM_VOX_DEATH,10,0,false,0.1)
                --npc:ToNPC():PlaySound(mod.Sounds.mommies,10,0,false,0.4)
                npc.CollisionDamage = 100
				sfx:Stop(SoundEffect.SOUND_POWERUP1)
				sfx:Stop(SoundEffect.SOUND_POWERUP2)
				sfx:Stop(SoundEffect.SOUND_POWERUP3)
            elseif d.DingCount < 5 then
                npc:ToNPC():PlaySound(SoundEffect.SOUND_BEEP,10,0,false,math.random(5,20)/100)
            end
            d.DamageCount = 0
        end
        return false
    else
        return false
    end
end

function mod:motherOrbColl(npc1, npc2)
    local d = mod:GetEntityData(npc1:ToNPC())
    if d.DingCount > 4 and npc2.Type == 1 and not d.crasherSpawned then
        --[[if npc2.Type == 1 then
            local dweller = mod.spawnent(npc1,npc2.Position, nilvector, 960, 80)
            dweller:Update()
        end]]
        Isaac.Spawn(mod.FF.Freezer.ID, mod.FF.Freezer.Var, 0, npc1.Position, nilvector, npc1)
        local data = mod:GetEntityData(npc2).ffsavedata
		data.eternalClickeredBozo = true
		d.crasherSpawned = true
    end

	if npc2.Type == 1 then
		return false
	end
end

function mod:theFreezerAI(npc)
	local sprite = npc:GetSprite()
	local d = mod:GetEntityData(npc)
	npc.RenderZOffset = 1000000
	if mod:isFriend(npc) then
		npc:Remove()
		return
	end
	if not d.init then
		npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_DEATH_TRIGGER | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_FLASH_ON_DAMAGE | EntityFlag.FLAG_PERSISTENT)
		npc.Position = game:GetRoom():GetRandomPosition(1)
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		d.init = true
	end
	if d.RemoveOnFrame then
		if npc.FrameCount > d.RemoveOnFrame then
			npc:Remove()
		end
	end
	mod:spritePlay(sprite, "bigfreeze")
	if sprite:GetFrame() == 125 then
		npc:PlaySound(mod.Sounds.EpicTwinkleV,2,0,false,0.5)
	elseif sprite:IsEventTriggered("crash") then
		Isaac.ExecuteCommand("")
		npc:Remove()
	elseif sprite:GetFrame() == 109 then
		if mod.anyPlayerHas(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE, true) then
			mod.shampooDialogue = {}
			mod.shampooDialogue.Dialogue = {"oh crap"}
		end
	end
end