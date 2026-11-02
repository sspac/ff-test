local mod = FiendFolio
local game = Game()

function mod:danglerAI(npc)
	local room = game:GetRoom()
	local sprite = npc:GetSprite()
	local d = mod:GetEntityData(npc)
	local target = npc:GetPlayerTarget()
	npc.SplatColor = Color(0,0,0,1,20 / 255,10 / 255,10 / 255);

	local velocity = mod:reverseIfFear(npc,(mod:confusePos(npc,target.Position) - npc.Position):Resized(2.3))
	npc.Velocity = (npc.Velocity*0.95) + (velocity*0.05)

	--Setup
	if not d.init then
		d.state = 1
		d.init = true
		d.skin = math.random(4)
		local eternalfriend = Isaac.Spawn(96, 0, 0, npc.Position, Vector(0,0), npc):ToNPC()
		eternalfriend.Parent = npc
		eternalfriend:Update()
		mod:lastJudgementAutoResprite(npc, data, sprite)
	else
		npc.StateFrame = npc.StateFrame + 1
	end

	--Idle
	if d.state == 1 then
		if not sprite:IsPlaying("Head0" .. d.skin) then
			sprite:Play("Head0" .. d.skin, true)
		end
		local distance = target.Position:Distance(npc.Position)
		if distance < 360 and room:CheckLine(target.Position,npc.Position,3,900,false,false) and not mod:isScareOrConfuse(npc) then
			if npc.StateFrame > 28 then
				d.state = 2
			end
		end
	end

	--Shooting
	if d.state == 2 then
		if sprite:IsFinished("AttackHead0" .. d.skin) then
			npc.StateFrame = 1
			d.state = 1
		else
			mod:spritePlay(sprite, "AttackHead0" .. d.skin)
			if sprite:IsEventTriggered("Shoot") then
				npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT,1,0,false,1)
				local params = ProjectileParams()
				params.BulletFlags = params.BulletFlags | ProjectileFlags.GREED
				for i = -1,1 do
					local spreadshot = math.random(4,12)-8
					npc:FireProjectiles(npc.Position, velocity:Resized(8):Rotated(i*spreadshot*10), 0, params)
				end
			end
		end
	end
end