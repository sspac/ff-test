local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector(0, 0)

--fathead - farts dfies
function mod:fatheadai (npc, sprite, npcdata)
	local room = game:GetRoom()
	if not npcdata.confuseangle then
		npcdata.confuseangle = math.random(360)
	end
	npcdata.confuseangle = npcdata.confuseangle + math.random(-30, 30)
	--the dying is the farting baby
	if npc:IsDead() and mod:shouldDoDeathEffect(npc) then
		game:ButterBeanFart(npc.Position, 140, npc, true, false)
	end
	local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	targetpos = mod:randomConfuse(npc, targetpos)
	local path = npc.Pathfinder
	--we gotta get a move on here lets get a move on here
	if room:CheckLine(npc.Position,targetpos,0,1,false,false) or npc:HasEntityFlags(EntityFlag.FLAG_FEAR) or npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION) then
		local targetvelocity = (targetpos - npc.Position):Normalized() * 3.5
		if npc:HasEntityFlags(EntityFlag.FLAG_FEAR) then
			targetvelocity = targetvelocity * -1
		elseif npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION) then
			targetvelocity = Vector(3.5, 0):Rotated(npcdata.confuseangle)
		end
		local lerpy = 0.1
		if npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION) then
			lerpy = 0.3
		end
		npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, lerpy)
	else
		path:FindGridPath(targetpos, 0.5, 900, true)
	end
	--anim
	sprite.FlipX = false
	if npc.Velocity:Length() < 0.25 then
		sprite:SetFrame("Appear", 20)
	elseif math.abs(npc.Velocity.X) >= math.abs(npc.Velocity.Y) then
		sprite:SetFrame("WalkHori", npc.FrameCount % 22)
		if npc.Velocity.X < 0 then
			sprite.FlipX = true
		end
	else
		sprite:SetFrame("WalkVert", npc.FrameCount % 22)
	end
end