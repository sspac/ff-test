local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector(0, 0)

function mod:baroai(npc, sprite, d)
	local target = npc:GetPlayerTarget()
	if not d.init then
		d.npcstate = "idle"
		--npc.SplatColor = Color(0,0,0,1,20 / 255,10 / 255,10 / 255);
		npc.SplatColor = Color(0.7,0.7,0.7)
		d.extrawait = mod:RandomInt(-80,-40)
		d.init = true
		d.targetvelocity = ((target.Position - npc.Position):Normalized()*2):Rotated(-50+math.random(100))
	elseif d.init then
		npc.Velocity = (d.targetvelocity * 0.3) + (npc.Velocity * 0.7)
		d.targetvelocity = d.targetvelocity * 0.99
	end


	if npc.State == 17 then
		npc.Velocity = nilvector
		if sprite:IsFinished("Death") then
			npc:Kill()
			--mod.spawnent(npc, npc.Position, nilvector, 281, 0)
			Isaac.Spawn(281, 0, 0, npc.Position, nilvector, npc);
			for i = 1, 10 do
				local bugcheck = math.random(1,6)
				Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.bugtable[bugcheck], 0, npc.Position, (RandomVector()*(math.random()+math.random(5,12))), npc);
			end
		elseif not sprite:IsPlaying("Death") then
			sprite:Play("Death", true)
		end
	else
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
		if d.npcstate == "idle" then
			if not sprite:IsPlaying("Idle")
				then sprite:Play("Idle")
			end
			if npc.StateFrame > 80 + d.extrawait and not mod:isScareOrConfuse(npc) then
				if mod.GetEntityCountConsiderFriend(npc, 281) + mod.GetEntityCountConsiderFriend(npc, 222) > 10 then
					npc.StateFrame = 40
					d.targetvelocity = mod:reverseIfFear(npc, ((mod:confusePos(npc, target.Position) - npc.Position):Normalized()*2):Rotated(-50+math.random(100)))
				elseif not mod:isScareOrConfuse(npc) then
					sprite:Play("Shoot")
					npc:PlaySound(SoundEffect.SOUND_RAGMAN_3 ,1,2,false,0.9)
					d.npcstate = "attack"
				end
			end

		elseif d.npcstate == "attack" then
			if sprite:IsEventTriggered("shoot") then
				npc:PlaySound(SoundEffect.SOUND_MONSTER_ROAR_0,1,2,false,0.8)
				for i = 1, 15 do
					local bugcheck = math.random(1,6);
					Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.bugtable[bugcheck], 0, npc.Position, (RandomVector()*(math.random()+math.random(5,12))), npc);
				end
				local targcoord = mod:intercept(npc, target, 50)
				local shootvec = targcoord:Normalized() * 13
				--mod.cheekyspawn(npc.Position + shootvec:Resized(10), npc, npc.Position + shootvec:Resized(13), 950, 2, 0)
				if math.random(3) == 1 then
					local flyball = mod.spawnent(npc, npc.Position + shootvec:Resized(10), shootvec, mod.FF.FlyBundle.ID, mod.FF.FlyBundle.Var, mod.FF.FlyBundleRing.Sub)
					flyball:GetSprite():Load("gfx/projectiles/flyball_ring.anm2",true)
					mod:GetEntityData(flyball).Vel = shootvec
				else
					local flyball = mod.spawnent(npc, npc.Position + shootvec:Resized(10), shootvec, mod.FF.FlyBundle.ID, mod.FF.FlyBundle.Var)
					flyball:GetSprite():Load("gfx/projectiles/flyball_swarm.anm2",true)
					mod:GetEntityData(flyball).Vel = shootvec
				end
			end
			if sprite:IsFinished("Shoot") then
				d.npcstate = "idle"
				d.targetvelocity = mod:reverseIfFear(npc, ((mod:confusePos(npc, target.Position) - npc.Position):Normalized()*2):Rotated(-50+math.random(100)))
				npc.StateFrame = 0
				d.extrawait = mod:RandomInt(30,60)
			end
		end
	end
	npc.StateFrame = npc.StateFrame + 1
end

--mod.baronum = {2, 2, 2, 3, 3, 3, 3}
mod.baronum = {3, 3, 3, 4, 4, 5}
mod.flakflies = {}

--flyballAI
function mod.flakCannonFlyAI(v)
	local d = mod:GetEntityData(v)
	local sprite = v:GetSprite()
	local target = v:GetPlayerTarget()
	v.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
	v.Velocity = d.Vel or v.Velocity
	if v.State == 11 then
        local vec = RandomVector()
        local ran = math.random(#mod.baronum)
        local num = mod.baronum[ran]
        for i = 1, num do
            local g = math.random(30)
            local spawnVar = 281
            if v.SubType == 1 then
                spawnVar = 222
            end
            local fly = mod.cheekyspawn(v.Position + vec:Rotated((360 / num) * i - 15 + g) * 15, v, v.Position + vec:Rotated((360 / num) * i + g) * 100, spawnVar, 0, 0)
            fly.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
        end
        v:Kill()
	elseif target then
		if not sprite:IsPlaying("Idle") then
			sprite:Play("Idle")
		end
		local speed = 13 - 0.03 * v.FrameCount
		v.Velocity = v.Velocity:Resized(math.max(0.2,speed))
		if v.FrameCount > 50 or v:CollidesWithGrid() then v:TakeDamage(1, 0, EntityRef(nil), 0) end
	else
		v:TakeDamage(1, 0, EntityRef(target), 0)
	end

end