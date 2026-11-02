local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector(0, 0)

mod.ransackedtable = {
	--Sackboy (Weight 20)
	{mod.FF.Sackboy.ID, mod.FF.Sackboy.Var, 20},
	--Bony (weight 30)
	{EntityType.ENTITY_BONY, 0, 30},
	--Dweller (weight 20)
	{mod.FF.Dweller.ID, mod.FF.Dweller.Var, 20},
	--Resident (weight 10)
	{mod.FF.Resident.ID, mod.FF.Resident.Var, 10},
}

function mod:ransackedRandomSelection()
	local sum = 0

	for _,i in ipairs(mod.ransackedtable) do
		sum = sum + i[3]
	end

	local randy = math.random(0, sum-1)

	for _,i in ipairs(mod.ransackedtable) do
		if randy < i[3] then
			return i
		end
		randy = randy - i[3]
	end
	return 1;
end

function mod:ransackedai(npc, sprite, npcdata)
	npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
	if (npcdata.init == nil) then
		npcdata.framesuntilquiver = 70
		npcdata.lastframesuntilquiver = npcdata.framesuntilquiver
		npcdata.state = "idle"
		npc.SplatColor = mod.ColorPureWhite
		npcdata.init = true
	end
	npc.Velocity = Vector.Zero
	mod.QuickSetEntityGridPath(npc)
	if npcdata.state == "idle" then
		mod:spritePlay(sprite, "idle")
		npcdata.framesuntilquiver = npcdata.framesuntilquiver - 1
		if npcdata.framesuntilquiver <= 0 then
			npcdata.state = "quiver"
			mod:spritePlay(sprite, "quiver")
			npcdata.framesuntilquiver = npcdata.lastframesuntilquiver - math.random(8, 10)
			npcdata.lastframesuntilquiver = npcdata.framesuntilquiver
			if npcdata.framesuntilquiver <= 0 then
				npcdata.state = "hatch"
			end
		end
	elseif npcdata.state == "quiver" then
		if sprite:IsFinished("quiver") then
			npcdata.state = "idle"
		end
	elseif npcdata.state == "hatch" then
		mod:spritePlay(sprite, "hatch")
	end
	if sprite:IsEventTriggered("hatch") then
		--hantch
		local sack = mod:ransackedRandomSelection()
		if npc.SubType == 0 then
			local spawned = Isaac.Spawn(sack[1], sack[2], 0, npc.Position, Vector(0,0), npc):ToNPC()
			spawned:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		end
		Isaac.Spawn(1000, 667, 0, npc.Position + Vector (0,-8), Vector(0,0), npc)
		npc:Kill();
	end
end

function mod:ransackedwebai(npc)
	mod:spritePlay(npc:GetSprite(), "webcorpse")
	npc.DepthOffset = 1
	npc:GetSprite().Offset = Vector(0, 0)
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.ransackedwebai, 667)