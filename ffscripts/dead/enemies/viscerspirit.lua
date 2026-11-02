local mod = FiendFolio
local sfx = SFXManager()

function mod:viscerspiritAI(npc, sprite, d)
	if not d.found then
		-- Connects to a Dople, so mirror its position
		local position = npc.Position
		if npc.SubType == 1 then
			local dople = Isaac.FindByType(EntityType.ENTITY_DOPLE)
			if #dople > 0 then
				position = dople[1].Position + RandomVector() * 40
			end
		end


		local newparent = mod.FindClosestEnemyEffigy(position)
		if newparent then
			npc.Parent = newparent

			d.initialhp = npc.Parent.HitPoints

			local hpPercent = npc.Parent.HitPoints / npc.Parent.MaxHitPoints
			npc.MaxHitPoints = npc.MaxHitPoints + npc.Parent.MaxHitPoints
			npc.Parent.MaxHitPoints = npc.MaxHitPoints
			npc.Parent.HitPoints = npc.MaxHitPoints * hpPercent
			npc.HitPoints = npc.Parent.HitPoints

			if mod:GetEntityData(newparent).viscerspirited then
				mod:GetEntityData(newparent).viscerspirited = mod:GetEntityData(newparent).viscerspirited + 1
			else
				mod:GetEntityData(newparent).viscerspirited = 1
			end
			d.vec = (position - npc.Parent.Position):Resized(40)
			d.distoffset = math.random()
			d.veloffset = math.random()
			d.found = true
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			npc.PositionOffset = Vector(0, (-13 / 26) * 40)
			npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET)
			npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			sprite:Play("Appear")
		else
			npc:Kill()
		end
	end

	if sprite:IsFinished("Appear") then
		sprite:Play("Idle")
	end

	if npc.Parent then
		if mod:GetEntityData(npc.Parent).viscerspirited and npc.Parent.FrameCount > 10 then
			local data = mod:GetEntityData(npc.Parent)
			if data.viscerspirited > 1 then
				sfx:Play(SoundEffect.SOUND_VAMP_DOUBLE)
			else
				sfx:Play(SoundEffect.SOUND_VAMP_GULP)
			end
			local effect = Isaac.Spawn(1000, 49, 0, npc.Parent.Position, Vector.Zero, npc.Parent):ToEffect()
			effect:FollowParent(npc.Parent)
			effect.DepthOffset = npc.Parent.Position.Y * 1.25
			effect.SpriteOffset = Vector(0, -30 + npc.Size * -1.0)
			data.viscerspirited = nil
		end
		npc.MaxHitPoints = npc.Parent.MaxHitPoints
		npc.HitPoints = npc.Parent.HitPoints

		local targpos = npc.Parent.Position + d.vec
		local targvel = (targpos - npc.Position)
		npc.Velocity = targvel

		sprite.FlipX = npc.Velocity.X < 0

		local distwave = mod:PeriodicSine(npc.FrameCount, 60, d.distoffset, true)
		local dist = mod:Lerp(npc.Parent.Size + 7, npc.Parent.Size + 22, distwave)
		local velwave = mod:PeriodicSine(npc.FrameCount, 60, d.veloffset, true)
		local rot = mod:Lerp(1, 6, velwave)

		d.vec = d.vec:Rotated(rot):Resized(dist)

		if npc.FrameCount > 1 then
			if d.prevhitpoints and npc.HitPoints < d.prevhitpoints then
				npc:SetColor(Color(1,1,1,1,1,0,0),3,999,true,false)
			end

			d.prevhitpoints = npc.HitPoints

			if npc.HitPoints <= d.initialhp then
				npc:Kill()
			end
		end
	else
		npc:Kill()
	end
end