local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector(0, 0)

function mod:margeai(npc, sprite, npcdata)
	local room = game:GetRoom()
	if not npcdata.confuseangle then
		npcdata.confuseangle = math.random(360)
		npcdata.DarkRedChampionDeaths = 0
	end
	npcdata.confuseangle = npcdata.confuseangle + math.random(-30, 30)
	--fathead ai redux
	if npc:IsDead() and mod:shouldDoDeathEffect(npc) then
		if npcdata.DarkRedChampionDeaths < 1 then
			for i = 1, math.random(4,5), 1 do
				local vec = RandomVector()
				local g = math.random(15)
				local fly = mod.cheekyspawn(npc.Position + vec * 1.5, npc, npc.Position + vec * math.random(25, 45), 281, 0, 0)
			end
		end
		npcdata.DarkRedChampionDeaths = npcdata.DarkRedChampionDeaths + 1
	end
	local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	targetpos = mod:randomConfuse(npc, targetpos)
	local path = npc.Pathfinder
	if room:CheckLine(npc.Position,targetpos,0,1,false,false) or npc:HasEntityFlags(EntityFlag.FLAG_FEAR) or npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION) then
		local targetvelocity = (targetpos - npc.Position):Normalized() * 3.5
		if npc:HasEntityFlags(EntityFlag.FLAG_FEAR) then
			targetvelocity = targetvelocity * -1
		elseif npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION) then
			targetvelocity = Vector(3.5, 0):Rotated(npcdata.confuseangle)
		end
		local lerpy = 0.3
		if npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION) then
			lerpy = 0.4
		end
		npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, lerpy)
	else
		path:FindGridPath(targetpos, 0.5, 900, true)
	end
	--anim
	sprite.FlipX = false
	if npc.Velocity:Length() < 0.25 then
		sprite:SetFrame("Appear", 6)
	elseif math.abs(npc.Velocity.X) >= math.abs(npc.Velocity.Y) then
		sprite:SetFrame("WalkRight", npc.FrameCount % 22)
		if npc.Velocity.X < 0 then
			sprite:SetFrame("WalkLeft", npc.FrameCount % 22)
		end
	else
		sprite:SetFrame("WalkVert", npc.FrameCount % 22)
	end
end