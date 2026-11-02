local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector(0, 0)

--cistern ai - hive but bubbles. We all know what's up.
function mod:cisternai(npc, sprite, npcdata)
	local overlayFrame = sprite:GetOverlayFrame()
	local target = npc:GetPlayerTarget()
	local r = npc:GetDropRNG()
	local room = game:GetRoom()
	
	-- Isaac.DebugString(npc.State)
	-- Isaac.DebugString(npc.FrameCount)
	
	npcdata.fuckoff = true

	--attack cooldown
		if sprite:IsOverlayPlaying("HeadAttack") and sprite:GetOverlayFrame() < 1 then
			npc.V1 = Vector(130, npc.V1.Y)
		end
	--despawn all flies
	for _, entity in ipairs(Isaac.GetRoomEntities()) do
		if entity.SpawnerType == npc.Type and entity.SpawnerVariant == npc.Variant then
			if entity.Type == EntityType.ENTITY_FLY or entity.Type == EntityType.ENTITY_ATTACKFLY or entity.Type == EntityType.ENTITY_POOTER then
				entity:Remove()
			end
		end
	end
	if npc.State == NpcState.STATE_ATTACK then
		if overlayFrame == 0 then
			if sfx:IsPlaying(SoundEffect.SOUND_WHEEZY_COUGH) then
				sfx:Stop(SoundEffect.SOUND_WHEEZY_COUGH)
				npc:PlaySound(mod.Sounds.CisternAttack, 1, 0, false, math.random(90,110)/100)
			end
		elseif overlayFrame == 5 then
			local vec = (target.Position - npc.Position):Normalized()
				if (#Isaac.FindByType(mod.FF.BubbleFly.ID, mod.FF.BubbleFly.Var, mod.FF.BubbleFly.Sub, false, false)
				+ #Isaac.FindByType(mod.FF.BubbleSpider.ID, mod.FF.BubbleSpider.Var, mod.FF.BubbleSpider.Sub, false, false)
				+ #Isaac.FindByType(EntityType.ENTITY_ATTACKFLY, 0, 0, false, false)
				+ #Isaac.FindByType(EntityType.ENTITY_SPIDER, 0, 0, false, false)
				) >= 6 then
					mod.ShootBubble(npc, 3, npc.Position+vec*5, vec*(math.random(55,75)/20))
				else
					mod.ShootBubble(npc, 3+math.random(2), npc.Position+vec*5, vec*(math.random(55,75)/20))
				end
			for i = 1, 2 do
				mod.ShootBubble(npc, math.random(2)-1, npc.Position+vec:Rotated(-30+i*20)*5, vec:Rotated(-15+i*10)*(math.random(55,75)/20))
			end
		end
	end

	--bubble on death
	if npc:IsDead() and mod:shouldDoDeathEffect(npc) then
		local bubblenumber = math.random (5,9)
		local randangle = 0
		for i=1, bubblenumber, 1 do
			randangle = math.random(0,359)
			mod.ShootBubble(npc, -1, npc.Position + Vector(5,0):Rotated(randangle),Vector((math.random(20,40)/20),0):Rotated(randangle))
		end
	end

	if sfx:IsPlaying(SoundEffect.SOUND_SCARED_WHIMPER) then
		sfx:Stop(SoundEffect.SOUND_SCARED_WHIMPER)
		npc:PlaySound(mod.Sounds.CisternWhimper, 1, 0, false, math.random(90,110)/100)
	end
end