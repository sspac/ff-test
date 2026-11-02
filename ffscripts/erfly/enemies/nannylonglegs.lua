local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

FiendFolio.NannyLongLegsWebs = {}

function mod:nannyLongLegsAI(npc)
	local sprite = npc:GetSprite()
	local d = mod:GetEntityData(npc)
	local target = npc:GetPlayerTarget()

	if not d.init then
		d.state = "idle"
		d.init = true
	else
		npc.StateFrame = npc.StateFrame + 1
	end

	local playerStepping
	d.playerStepTimer = d.playerStepTimer or 0
	d.playerStepTimer = d.playerStepTimer + 1
	for i = 1, game:GetNumPlayers() do
		local p = Isaac.GetPlayer(i - 1)
		local grident = game:GetRoom():GetGridEntityFromPos(p.Position)
		if grident and grident.Desc.Type == GridEntityType.GRID_SPIDERWEB and grident.Desc.State == 0 then
			playerStepping = true
			local gIdx = grident:GetGridIndex()
			FiendFolio.NannyLongLegsWebs[gIdx] = FiendFolio.NannyLongLegsWebs[gIdx] or {}
			FiendFolio.NannyLongLegsWebs[gIdx].triggered = true
			d.playerStepTimer = 0
		end
	end

	if d.state == "idle" then
		npc.Velocity = npc.Velocity * 0.75
		if not (sprite:IsPlaying("Blink") or sprite:IsPlaying("Angry Stop")) then
			mod:spritePlay(sprite, "Idle")
			if math.random(30) == 1 then
				mod:spritePlay(sprite, "Blink")
			end
		end
		if playerStepping then
			d.state = "pissed"
			npc.StateFrame = 0
			mod:spritePlay(sprite, "Angry Start")
		end
	elseif d.state == "shoot" then
		npc.Velocity = npc.Velocity * 0.75
		if sprite:IsFinished("Shoot") then
			npc.StateFrame = 0
			d.state = "idle"
		elseif sprite:IsEventTriggered("Shoot") then
			npc:PlaySound(SoundEffect.SOUND_LITTLE_SPIT,1,0,false,0.9)
			npc:FireProjectiles(npc.Position, (target.Position - npc.Position):Resized(8), 0, ProjectileParams())
		else
			mod:spritePlay(sprite, "Shoot")
		end
	elseif d.state == "pissed" then
		if not sprite:IsPlaying("Angry Start") then
				mod:CatheryPathFinding(npc, target.Position, {
				Speed = 10,
				Accel = 0.1,
				GiveUp = true
				})
			if npc.Velocity:Length() > 0.1 then
				mod:spritePlay(sprite, "Walk")
			else
				mod:spritePlay(sprite, "Idle Angry")
			end
			npc:PlaySound(mod.Sounds.CobWeb, 1 + 2*(90-math.min(npc.StateFrame,90))/90, math.random(4,8), false, 0.80 + math.random()*0.4)
			--[[
			if npc.StateFrame <= 90 then
				npc:PlaySound(mod.Sounds.CobWeb, 2.5*(90-npc.StateFrame)/90, math.random(4,8), false, 0.80 + math.random()*0.4)
				if game:GetRoom():GetFrameCount() % 4 < 2 then
					local cFade = 0.2 * (90-npc.StateFrame)/90
				    npc:SetColor(Color(1, 1, 1, 1, cFade, cFade, cFade), 2, 1, false, false)
				end
			end
			]]
			if (not playerStepping) and d.playerStepTimer > 7 then		-- 15
				d.state = "cautious"
				npc.StateFrame = 0
			end
			local grident = game:GetRoom():GetGridEntityFromPos(npc.Position)
			if grident and grident.Desc.Type == GridEntityType.GRID_SPIDERWEB and grident.Desc.State == 0 then
				local gIdx = grident:GetGridIndex()
				FiendFolio.NannyLongLegsWebs[gIdx]  = FiendFolio.NannyLongLegsWebs[gIdx] or {}
				FiendFolio.NannyLongLegsWebs[gIdx].triggered = true
			end
		end
	elseif d.state == "cautious" then
		npc.Velocity = npc.Velocity * 0.75
		if npc.StateFrame > 5 then		-- 60
			d.state = "idle"
			mod:spritePlay(sprite, "Angry Stop")
		else
			mod:spritePlay(sprite, "Idle Angry")
		end
		if playerStepping then
			d.state = "pissed"
			npc.StateFrame = 0
		end
	end
end

function mod:nannyLongLegsHurt(npc, damage, flag, source)
	local d = mod:GetEntityData(npc)
	if d.state == "idle" and npc:ToNPC().StateFrame > 10 then
		d.state = "shoot"
	end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	FiendFolio.NannyLongLegsWebs = {}
end)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	--local anyActive = false
	for wIdx, web in pairs(FiendFolio.NannyLongLegsWebs) do
		local wSprite = game:GetRoom():GetGridEntity(wIdx)
		if wSprite then
			wSprite = wSprite:GetSprite()
			web.amplitude = web.amplitude or 0
			web.state = web.state or 0
			
			local w = math.sin(web.state/16*math.pi) * web.amplitude/20 * 0.125
			wSprite.Scale = Vector(1+w, 1-w)
			
			--[[
			if web.state % 4 < 2 then
				local tFade = 1 + 0.4 * web.amplitude/20
				local oFade = 0.15 * web.amplitude/20
				wSprite:GetLayer(0):SetColor(Color(tFade, tFade, tFade, 1, oFade, oFade, oFade))
			else
				wSprite:GetLayer(0):SetColor(Color(1, 1, 1, 1, 0, 0, 0))
			end
			]]
				
			web.state = (web.state + 1) % 16
			
			if web.triggered then
				--mod:spritePlay(wSprite, "Swaying")
				anyActive = true
				web.amplitude = math.min(web.amplitude + 4, 20)
				web.triggered = false
			else
				--mod:spritePlay(wSprite, "Idle")
				if web.amplitude < 1 then
					FiendFolio.NannyLongLegsWebs[wIdx] = nil
				end
				web.amplitude = web.amplitude - 2
			end
		end
	end
	--[[
	if anyActive then
		sfx:Play(mod.Sounds.CobWeb, 1, math.random(8,12), false, 0.80 + math.random()*0.4)
	end
	]]
end)