local mod = FiendFolio
local game = Game()
local nilvector = Vector.Zero

function mod:cordifyAI(npc, variant)
	local sprite = npc:GetSprite()
	local d = mod:GetEntityData(npc)
	local target = npc:GetPlayerTarget()

	npc.Velocity = npc.Velocity * 0.2

	if not d.init then
		d.init = true
		d.state = "idle"
		d.timesdone = 0
		d.randval = math.random(10)
		npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
	else
		npc.StateFrame = npc.StateFrame + 1
	end

	if d.state == "idle" then
		mod:spritePlay(sprite, "Idle")
		if (not mod:isScareOrConfuse(npc)) and npc.StateFrame > 50 + d.timesdone + d.randval then
			local enmy = mod.FindClosestEntityPrimeMind(target.Position, 99999999, {npc}, true, true)
			if enmy and mod:CanBeInfectedByCordifySpores(enmy) then
				d.state = "attack"
			else
				if --[[game:GetRoom():IsClear()]] not mod.AreThereEntitiesButNotThisOne(mod.FF.Cordify.ID, nil, mod.FF.Cordify.Var) then
					d.state = "attack"
					d.suicidal = true
				else
					npc.StateFrame = npc.StateFrame - 10
				end
			end
		end
	elseif d.state == "attack" then
		if sprite:IsFinished("Shoot") then
			d.state = "idle"
			npc.StateFrame = 0
		elseif sprite:IsEventTriggered("Shoot") then
			if d.suicidal or mod:isScareOrConfuse(npc) then
				game:Fart(npc.Position, 80, npc, 1.6, 0)
				game:BombExplosionEffects(npc.Position, 8, TearFlags.TEAR_POISON, Color(0, 0, 0, 0, 0, 0, 0), npc, 1.3, false, true)
				npc:Kill()
			else
				d.randval = math.random(10)
				d.timesdone = d.timesdone + 10
				local enmy = mod.FindClosestEntityPrimeMind(target.Position, 99999999, {npc}, true, true)
				if enmy then
					mod:CordifySporeInfect(npc, enmy, 1, 1, true)
				else
					game:Fart(npc.Position, 40, npc, 1, 0)
				end
			end
		else
			mod:spritePlay(sprite, "Shoot")
		end
	end
end

mod.CordifySporeImmuneEnemies = {
	[mod.FF.Rosie.ID.." "..mod.FF.Rosie.Var] = true,
	[mod.FF.Posie.ID.." "..mod.FF.Posie.Var] = true,
	[mod.FF.BabySpider.ID.." "..mod.FF.BabySpider.Var] = true,
}
function mod:IsImmuneToCordifySpores(enmy)
	return mod:GetEntityData(enmy).cordified or mod.CordifySporeImmuneEnemies[enmy.Type.." "..enmy.Variant]
end

function mod:CanBeInfectedByCordifySpores(enmy)
	if mod:IsImmuneToCordifySpores(enmy)
	or mod:isStatusCorpse(enmy)
	or mod:GetEntityData(enmy).FFIsCircleSummon then
		return false
	else
		for _, v in ipairs(mod.blacklistedPrimeMind) do
			if v[3] then if enmy.Type == v[1] and enmy.Variant == v[2] and enmy.SubType == v[3] then return false end
			elseif v[2] then if enmy.Type == v[1] and enmy.Variant == v[2] then return false end
			elseif enmy.Type == v[1] then return false end
		end
	end
	return true
end

function mod:CordifySporeInfect(npc, enmy, soundVol, soundPitch, canInfect)
	local canInfect = canInfect or mod:CanBeInfectedByCordifySpores(enmy)
	if canInfect then
		if npc then
			npc:PlaySound(SoundEffect.SOUND_SUMMONSOUND, soundVol or 1, 1, false, soundPitch or 1)
		end
		mod:GetEntityData(enmy).cordified = true
		enmy:SetColor(mod.ColorToxicFart, 30, 1, true, false)
		local poof = Isaac.Spawn(1000, 15, 0, enmy.Position, nilvector, enmy):ToEffect()
		poof.Color = Color(1,2,1,1,0,0,0)
		poof:Update()
		local marker = Isaac.Spawn(1000, 1731, 0, enmy.Position, nilvector, enmy):ToEffect()
		marker:FollowParent(enmy)
		marker:Update()
		for i = 1, 3 do
			local gas = Isaac.Spawn(mod.FF.FFWhiteSmoke.ID, mod.FF.FFWhiteSmoke.Var, mod.FF.FFWhiteSmoke.Sub, enmy.Position, enmy.Velocity * 0.5, enmy)
			gas.DepthOffset = 40
			gas.PositionOffset = Vector(0,-10)
			mod:GetEntityData(gas).longonly = true
            gas.Color = Color(0.5, 1, 0.5, 0.5)
		end
	end
end

local markerXOffset = 2
function mod:cordifyMarker(e)
	mod:spritePlay(e:GetSprite(), "Idle")
	if e.Parent then
		e.TargetPosition = e.Parent.Position
		local overlayOffset = e.Parent:GetNullOffset("OverlayEffect")
		if overlayOffset:Length() > 0 then
			e.ParentOffset = overlayOffset + Vector(markerXOffset, -8)
		else
			e.ParentOffset = Vector(markerXOffset, -e.Parent.Size*3)
		end
		e.DepthOffset = -e.ParentOffset.Y + 1
	end
	if e.Parent and e.Parent:IsDead() or not e.Parent then
		game:Fart(e.TargetPosition, 40, e.Parent, 1, 0)
		game:BombExplosionEffects(e.TargetPosition, 8, TearFlags.TEAR_POISON, Color(0, 0, 0, 0, 0, 0, 0), e.Parent, 1, false, true)
		for i = 1, 6 do
			local gas = Isaac.Spawn(mod.FF.FFWhiteSmoke.ID, mod.FF.FFWhiteSmoke.Var, mod.FF.FFWhiteSmoke.Sub, e.TargetPosition, RandomVector() * math.random(1,3), e.Parent)
			mod:GetEntityData(gas).longonly = true
            gas.Color = Color(0.5, 1, 0.5, math.random(5,7) * 0.1)
		end
		if e.Parent and e.Parent:Exists() then
			mod:GetEntityData(e.Parent).cordified = false
		end
		e:Remove()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.cordifyMarker, 1731)