-- Split Ear --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local splitearBalance = {
	speedIdle = 6,
	bulletSpeed = 10,
	barrageBulletSpeed = 11,
	barrageDuration = 20,
	color = Color(1,0.3,0.3,0.7),
	colorTransparent = Color(1,1,1,0.6),
}
local bal = splitearBalance

function mod:splitearAI(npc, sprite, npcdata)
	local data = mod:GetEntityData(npc)
	local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetvel = (targetpos - npc.Position)	
	
	data.bal = splitearBalance
	bal = data.bal
	npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
	
	if not data.init then
        if npc.SubType == 0 or npc.SubType > 4 then data.dir = mod:RandomInt(1,4) else data.dir = npc.SubType end

        if data.dir == 1 then
            data.dir = Vector(-1, 1)
        elseif data.dir == 2 then
            data.dir = Vector(1, 1)
        elseif data.dir == 3 then
            data.dir = Vector(-1, -1)
        elseif data.dir == 4 then
            data.dir = Vector(1, -1)
        end

		
        sprite:Play("Appear")
		data.State = "Idle"
		--npc.Velocity = mod:Lerp(npc.Velocity, data.dir, 0.5)
        data.init = true
    end
	
	if sprite:IsFinished("Appear") then
		npc.Velocity = mod:Lerp(npc.Velocity, data.dir, 0.5)
	end
	--[[
	if sprite:IsFinished("Appear") then
		data.State = "Idle"
		data.dir = mathrandom(1,4)
		
		if data.dir == 1 then
            data.dir = Vector(-1, 1)
        elseif data.dir == 2 then
            data.dir = Vector(1, 1)
        elseif data.dir == 3 then
            data.dir = Vector(-1, -1)
        elseif data.dir == 4 then
            data.dir = Vector(1, -1)
        end		
		
		sprite:Play("Idle")
		npc.Velocity = mod:Lerp(npc.Velocity, data.dir, 0.5)
	end
	]]
	
	if not data.cochleaStopMoving then
		local angle = npc.Velocity:GetAngleDegrees()
    	npc.Velocity = npc.Velocity:Rotated((90 * math.floor((angle + 45) / 90 + 0.5) - (angle + 45))):Resized(math.min(npc.Velocity:Length() * 1.2, bal.speedIdle))
	else
		npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.2)
	end
	

	if data.State == "Idle" and (sprite:IsFinished("TeleportIn") or sprite:IsFinished("Appear")) then
		sprite:Play("Idle")
	end
	
	if data.State == "Hurt" then
		sprite:Play("TeleportOut")
		
		if sprite:IsEventTriggered("Shoot") then
			npc:PlaySound(SoundEffect.SOUND_HELL_PORTAL2, 0.8, 0, false, math.random(18,22)/20)
			
			local e = Isaac.Spawn(1000, 16, 0, npc.Position + Vector(0,-12), nilvector, npc):ToEffect()
			e.Color = bal.colorTransparent
			local params = ProjectileParams()
			for i = 1, 5 do
				npc:FireProjectiles(npc.Position,Vector.FromAngle(i*(360/5)):Resized(bal.bulletSpeed),0,params)
			end
		end
		
		if sprite:IsFinished("TeleportOut") then
			sprite:Play("TeleportIn")
			local gridtarget = mod:FindRandomFreePosAir(target.Position, 150, 300)
			npc.Position = gridtarget
			
			data.State = "Idle"
		end
	elseif data.State == "CochleaRetaliation" then
		if sprite:IsFinished("Shoot") then
			data.State = "Idle"
			sprite:Play("Idle", true)
			data.cochleaStopMoving = nil
		elseif sprite:IsEventTriggered("Shoot") then
			table.insert(mod.TearBarrage, {["Duration"] = 20, ["Pos"] = npc.Position, ["Tar"] = npc:GetPlayerTarget().Position, ["Spawner"] = npc})
            for key,entry2 in pairs(mod.TearBarrage) do
                if entry2.Spawner and entry2.Spawner.InitSeed == npc.InitSeed then
                    data.cochleaEarTableInfo = {key = key, vec = (entry2.Tar-entry2.Pos)}
                end
            end

			local color = Color(1,0.3,0.3,0.7)
            for i = 1, 6 do
                local line = mod:MakeLarynxLine(npc.Position, mod:RandomInt(15,25,npc:GetDropRNG()), 10, npc, color)
                line:FollowParent(npc)
            end
            local wave = mod:MakeLarynxWave(npc.Position, 30, 30, npc, color)
            wave:FollowParent(npc)

			npc:PlaySound(SoundEffect.SOUND_LARYNX_SCREAM_HI, 1, 0, false, (2 + (mod:RandomInt(-2,2, npc:GetDropRNG())/10)))
			game:ShakeScreen(10)
		elseif sprite:IsEventTriggered("Move") then
			npc.Velocity = data.cochleaMoveVector:Resized(1)
			data.cochleaMoveVector = nil
			data.cochleaStopMoving = nil
		elseif sprite:IsEventTriggered("ShootEnd") then
			if data.cochleaEarTableInfo then
				mod.TearBarrage[data.cochleaEarTableInfo.key] = nil
			end
			data.cochleaEarTableInfo = nil
		else
			mod:spritePlay(sprite, "Shoot")
		end

		if data.cochleaEarTableInfo then
			local entry2 = mod.TearBarrage[data.cochleaEarTableInfo.key]
            entry2.Pos = npc.Position
            entry2.Tar = npc.Position+data.cochleaEarTableInfo.vec

            if entry2.Duration <= 0 then
                data.cochleaEarTableInfo = nil
            end
		end
	end
	
	if npc:IsDead() and mod:shouldDoDeathEffect(npc) then
		mod.SplitEarDeath(npc)
	end
	
end

function mod.SplitEarDeath(npc)
	local color = splitearBalance.color
	local duration = splitearBalance.barrageDuration or 5
	local tar = npc:GetPlayerTarget().Position
	
	for i = 1, 6 do
		mod:MakeLarynxLine(npc.Position, mod:RandomInt(15,25), 10, npc, color)
    end
	
	mod:MakeLarynxWave(npc.Position, 30, 30, npc, color)
	
	npc:PlaySound(SoundEffect.SOUND_LARYNX_SCREAM_HI, 1, 0, false, (2 + (mod:RandomInt(-2,2)/10)))
	
	game:ShakeScreen(10)
	
	table.insert(mod.TearBarrage, {["Duration"] = duration, ["Pos"] = npc.Position, ["Tar"] = tar, ["Spawner"] = npc})
end	
	
function mod:TearBarrageUpdate(barrage)
	barrage.Duration = barrage.Duration or 30
	if barrage.Duration >= 0 then
		if barrage.Duration % 2 == 0 and barrage.Spawner:ToNPC() then
			local params = ProjectileParams()
			params.Scale = 1 + (mod:RandomInt(-4,4)/8)
			local p = barrage.Spawner:ToNPC():FireProjectilesEx(barrage.Pos + Vector(0,mod:RandomInt(0,12)):Rotated(mod:RandomInt(0,360)), (barrage.Tar - barrage.Pos):Resized(splitearBalance.barrageBulletSpeed + (mod:RandomInt(0,5)/5)), 0, params)[1]:ToProjectile()
			p.FallingSpeed = 0
			p.FallingAccel = -0.1
			
			local c = Isaac.Spawn(1000, EffectVariant.BLOOD_EXPLOSION, mod:RandomInt(2,3) , (barrage.Pos + Vector(0,-12)) + (Vector(0,mod:RandomInt(5,35)):Rotated(mod:RandomInt(0,360))), Vector(math.random(-5,5),math.random(-5,5)), barrage.Spawner):ToEffect()
			if barrage.Duration > 10 then
				for i = 1, 3 do
					local b = Isaac.Spawn(1000, 7, 0, barrage.Pos + (Vector(0,mod:RandomInt(0,80)):Rotated(mod:RandomInt(0,360))), nilvector, barrage.Spawner)
				end
			end
		end
		barrage.Duration = barrage.Duration - 1
	end	
end
		
function mod:SplitEarHurt(npc, damage, flag, source)
	if npc.Variant == mod.FF.SplitEar.Var then
		local dmgcheck = mod:RandomInt(0,12)
		if damage >= dmgcheck and not mod:GetEntityData(npc).cochleaDeathEffect and mod:GetEntityData(npc).State ~= "CochleaRetaliation" then
			
			mod:GetEntityData(npc).State = "Hurt"
		end
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CallbackPriority.LATE, mod.SplitEarHurt, mod.FF.SplitEar.ID)	