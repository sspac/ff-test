local mod = FiendFolio
local game = Game()

function mod:bladderAI(npc)
	local sprite = npc:GetSprite()
	local data = mod:GetEntityData(npc)
	local target = npc:GetPlayerTarget()
	local room = game:GetRoom()
	if not data.init then
		data.creep = 10
		data.anim = "piss baby"
		data.state = "Idle"
		npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
		data.initPos = npc.Position
		data.init = true
	else
		npc.StateFrame = npc.StateFrame+1
	end
	if not data.isSpecturnInvuln then
		if not data.initPos then
			data.initPos = npc.Position
		end
		npc.Velocity = data.initPos-npc.Position
	else
		data.initPos = nil
	end

	if REPENTOGON then
		npc:UpdateDirtColor()
	end

	if data.state == "Idle" then
		mod:spritePlay(sprite, "Shoot")
		if npc.StateFrame > 80 and (target.Position-npc.Position):Length() < 250 and not mod:isScareOrConfuse(npc) then
			if sprite:GetFrame() < 28 then
				sprite:Play("AttackBegin")
				data.state = "Challenge Pissing"
				sprite.PlaybackSpeed = 1
			else
				sprite.PlaybackSpeed = 1.5
			end
		end
		if sprite:IsEventTriggered("Shoot") then
			mod:PlaySound(SoundEffect.SOUND_WATER_DROP, npc, 0.7, 0.5)
			local splash = Isaac.Spawn(1000, EffectVariant.BLOOD_SPLAT, 0, npc.Position + Vector(0,10), Vector.Zero, npc):ToEffect()
			splash.Color = mod:CloneColor(mod.ColorLemonYellow, 0.5)
			splash.SpriteScale = Vector(0.25,0.25)
			splash:Update()
		end
	elseif data.state == "Challenge Pissing" then
		if sprite:IsFinished("AttackBegin") then
			local pAngle = math.floor(((data.lookAhead:GetAngleDegrees()+12.5)%360)/45)
			data.anim = mod.bladderAnim[pAngle+1]
			sprite:Play(data.anim)
		elseif sprite:IsEventTriggered("Shoot") then
			npc:PlaySound(SoundEffect.SOUND_MEAT_JUMPS, 0.6, 0, false, 1.1)
			npc:PlaySound(SoundEffect.SOUND_HEARTOUT, 0.7, 0, false, 1.3)
			local splash = Isaac.Spawn(1000, 12, 0, npc.Position+data.lookAhead:Resized(30)+Vector(0,-20), Vector.Zero, npc):ToEffect()
			splash.Color = Color(1.87, 1.5, 0, 1, 0, 0, 0)
			splash:Update()
			for i=1,3 do
				local params = ProjectileParams()
				--params.Variant = 4
				params.FallingSpeedModifier = -math.random(10,20)/12
				params.FallingAccelModifier = math.random(6,12)/8
				--params.Color = Color(1.87, 1.5, 0, 1, 0, 0, 0)
				params.Color = mod.ColorPeepPiss
				npc:FireProjectiles(npc.Position, data.lookAhead:Resized(3 + (i * math.random(2,4))):Rotated(math.random(-15,15)), 0, params)
			end
			data.creep = 0
			data.creepCount = 0
		elseif sprite:IsFinished(data.anim) then
			npc.StateFrame = 0
			data.state = "Idle"
		elseif sprite:IsEventTriggered("Aim") then
			data.lookAhead = mod:intercept(npc, target, 5)
		end
	end
	if data.creep < 9 then
		if data.creepCount % 1 == 0 then
			local scale = (20-data.creep)/20
			local creep = Isaac.Spawn(1000, 24, 0, npc.Position+data.lookAhead:Resized(25)*(data.creep + 1), Vector.Zero, npc):ToEffect()
			creep:SetTimeout(90-data.creep*2)
			creep.Scale = scale
			creep:Update()
			local splash = Isaac.Spawn(1000, 2, 2, creep.Position, Vector.Zero, npc):ToEffect()
			splash.Color = mod:CloneColor(mod.ColorLemonYellow, 0.75)
			splash.SpriteScale = Vector(scale, scale) * 0.85
			splash.DepthOffset = -200
			splash:Update()
			data.creep = data.creep+1
			local checkNext = npc.Position+data.lookAhead:Resized(25)*data.creep
			if room:GetGridCollisionAtPos(checkNext) ~= GridCollisionClass.COLLISION_NONE then
				data.creep = 9
			end
		end
		data.creepCount = data.creepCount+1
	end
end

function mod:bladderHurt(npc, damage, flag, source)
	if npc:GetData().state == "Idle" then
		npc = npc:ToNPC()
		npc.StateFrame = npc.StateFrame + (math.floor(damage * 5))
	end
end

mod.bladderAnim = {"AttackRight", "AttackDDRight", "AttackDown", "AttackDDLeft", "AttackLeft", "AttackDULeft", "AttackUp", "AttackDURight"}