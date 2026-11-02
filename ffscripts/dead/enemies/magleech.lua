local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector(0, 0)

local magleechSuckableEnts = {
	{mod.FF.WombPillar.ID, mod.FF.WombPillar.Var, Pillar = true}, -- womb pillar
	{mod.FF.UteroPillar.ID, mod.FF.UteroPillar.Var, Pillar = true} -- utero pillar
}

local magleechSuckableGrids = {
	[GridEntityType.GRID_ROCK] = true,
	[GridEntityType.GRID_ROCKT] = true,
	[GridEntityType.GRID_ROCK_BOMB] = true,
	[GridEntityType.GRID_ROCK_ALT] = true,
	[GridEntityType.GRID_ROCK_SS] = true,
	[GridEntityType.GRID_WALL] = true,
	[GridEntityType.GRID_DOOR] = true
}

function mod:GetMagleechTargets(npc)
	local room = game:GetRoom()
	local path = npc.Pathfinder
	local target = npc:GetPlayerTarget()
	local tpos = target.Position
	local targets = {}
	local badtargets = {}
	local leechbuds = Isaac.FindByType(npc.Type, npc.Variant, -1, false, false)
	for _, leech in ipairs(leechbuds) do
		local d = mod:GetEntityData(leech)
		if d.suckon then
			badtargets[#badtargets + 1] = d.suckon.Position
		end
	end

	for _, suckable in ipairs(magleechSuckableEnts) do
		local ents = Isaac.FindByType(suckable[1], suckable[2], -1, false, false)
		for _, ent in ipairs(ents) do
			if not ent:IsDead() then
				targets[#targets + 1] = {Position = ent.Position, Entity = ent, Pillar = suckable.Pillar}
			end
		end
	end

	for i = 0, room:GetGridSize() do
		local grid = room:GetGridEntity(i)
		if grid and grid.State ~= 2 and magleechSuckableGrids[grid.Desc.Type] then
			if grid.Desc.Type ~= GridEntityType.GRID_WALL or not room:IsPositionInRoom(grid.Position, 0) then
				targets[#targets + 1] = {Position = grid.Position, Grid = grid}
			end
		end
	end

	local outtargets = {}
	-- find targets that align with player, then add to out table if pathable
	for _, targ in ipairs(targets) do
		local pos = targ.Position
		local offs = {}
		if math.abs(pos.X - tpos.X) < 80 then
			-- magleech paths to the target's position offset by half a grid, so that it can connect cleanly to the correct side
			-- picks the direction that puts magleech closest to the player
			if pos.Y > tpos.Y then
				offs[#offs + 1] = Vector(0, -1)
			else
				offs[#offs + 1] = Vector(0, 1)
			end
		end

		if math.abs(pos.Y - tpos.Y) < 80 then
			if pos.X > tpos.X then
				offs[#offs + 1] = Vector(-1, 0)
			else
				offs[#offs + 1] = Vector(1, 0)
			end
		end

		for _, off in ipairs(offs) do
			local fullpos = pos + off * 40
			if room:CheckLine(tpos, fullpos, 1, 0, false, false) and path:HasPathToPos(fullpos, false) then
				-- avoid targeting similar spots to other leeches
				local isbad
				for _, bad in ipairs(badtargets) do
					if bad:DistanceSquared(fullpos) < 100 ^ 2 then
						isbad = true
						break
					end
				end

				if not isbad then
					outtargets[#outtargets + 1] = {Entity = targ.Entity, Pillar = targ.Pillar, Grid = targ.Grid, Position = targ.Position, Offset = off, OffPosition = fullpos}
				end
			end
		end
	end

	if #outtargets > 0 then
		return outtargets
	else
		return
	end
end

function mod:magleechAI(npc, sprite, d)
	local room = game:GetRoom()
	local path = npc.Pathfinder
	if not d.init then
		d.init = true
		d.state = "idle"
	end

	npc.StateFrame = npc.StateFrame + 1

	if d.stuntime then
		d.stuntime = d.stuntime - 1
		if d.stuntime <= 0 then
			d.stuntime = nil
		end
	end

	if d.state == "idle" then
		local targetpos = npc:GetPlayerTarget().Position
		if npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION) or npc:HasEntityFlags(EntityFlag.FLAG_FEAR) or not path:HasPathToPos(targetpos, false) then
			targetpos = mod:runIfFear(npc, mod:FindRandomValidPathPosition(npc), nil, true)
		elseif npc.StateFrame > 30 and math.random(1, 8) == 1 then
			local targets = mod:GetMagleechTargets(npc)
			if targets then
				local pick = targets[math.random(1, #targets)]
				d.suckon = pick
				d.state = "seek"
				npc.StateFrame = 0
			end
		end

		if d.stuntime then
			npc.Velocity = npc.Velocity * 0.8
		else
			path:FindGridPath(targetpos, 0.55, 0, false)
		end
	elseif d.state == "seek" then
		local cancel = npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION) or npc:HasEntityFlags(EntityFlag.FLAG_FEAR)
		if d.suckon.Entity and (not d.suckon.Entity:Exists() or d.suckon.Entity:IsDead()) then
			cancel = true
		end

		if d.suckon.Grid and d.suckon.Grid.State == 2 then
			cancel = true
		end

		if cancel then
			d.state = "idle"
			d.suckon = nil
			npc.StateFrame = 0
		else
			if d.suckon.Entity then
				d.suckon.Position = d.suckon.Entity.Position
				d.suckon.OffPosition = d.suckon.Position + d.suckon.Offset * 40
			end

			local targetpos = d.suckon.OffPosition

			local targDist = npc.Position:DistanceSquared(targetpos)
			if npc.Position:DistanceSquared(targetpos) <= (40 + npc.Size) ^ 2 then
				if targDist <= 20 ^ 2 then
					local collide

					npc.Velocity = (npc.Velocity * 0.9) + (d.suckon.Position - npc.Position):Resized(0.5)

					if d.suckon.Entity then
						local dist = npc.Position:DistanceSquared(d.suckon.Entity.Position)
						if dist <= (npc.Size + d.suckon.Entity.Size) ^ 2 or npc:CollidesWithGrid() then
							collide = true
						end
					elseif npc:CollidesWithGrid() then
						collide = true
					end

					if collide then
						npc:PlaySound(SoundEffect.SOUND_GOOATTACH0,1,1,false,1)
						d.suckpos = npc.Position
						d.sucktime = math.random(30, 50)
						d.state = "suck"
						npc.StateFrame = 0
					end
				else
					npc.Velocity = (npc.Velocity * 0.9) + (d.suckon.OffPosition - npc.Position):Resized(0.5)
				end
			else
				path:FindGridPath(targetpos, 0.55, 0, false)
			end
		end
	elseif d.state == "suck" then
		local cancel
		if d.suckon.Entity and (not d.suckon.Entity:Exists() or d.suckon.Entity:IsDead()) then
			cancel = true
		end

		if d.suckon.Grid and d.suckon.Grid.State == 2 then
			cancel = true
		end

		local finish
		if cancel then
			d.state = "idle"
			finish = true
		else
			if d.suckon.Entity then
				d.suckpos = d.suckon.Entity.Position + d.suckon.Offset:Resized(npc.Size + d.suckon.Entity.Size)
				if d.suckon.Pillar then
					mod:GetEntityData(d.suckon.Entity).hurting = true
				end
			end

			npc.Velocity = d.suckpos - npc.Position

			local suckAnim = "01"
			if npc.StateFrame > d.sucktime / 3 then
				suckAnim = "02"
			end

			if npc.StateFrame > d.sucktime then
				npc:PlaySound(SoundEffect.SOUND_MEATY_DEATHS,1,1,false,1)
				d.state = "charge"
				d.chargedirection = d.suckon.Offset
				finish = true
			else
				local dir
				if math.abs(d.suckon.Offset.X) > 0 then
					dir = "Hori"
					sprite.FlipX = d.suckon.Offset.X > 0
				else
					sprite.FlipX = false
					if d.suckon.Offset.Y < 0 then
						dir = "Down"
					else
						dir = "Up"
					end
				end

				if d.collideanimdone then
					mod:spritePlay(sprite, "Suck" .. dir .. suckAnim)
				else
					if not d.collideanim then
						d.collideanim = "Collide" .. dir
						sprite:Play(d.collideanim, true)
					end

					if sprite:IsFinished(d.collideanim) then
						d.collideanimdone = true
					end
				end
			end
		end

		if finish then
			d.suckon = nil
			d.suckpos = nil
			d.sucktime = nil
			d.collideanimdone = nil
			d.collideanim = nil
			npc.StateFrame = 0
		end
	elseif d.state == "charge" then
		npc.Velocity = (npc.Velocity * 0.5) +  d.chargedirection * 12

		local params = ProjectileParams()
		local level = game:GetLevel()
		local stage = level:GetStage()
		local stageType = level:GetStageType()

		npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT,1,0,false,1.3)
		for i = 1, math.random(2) do
			params.Variant = ProjectileVariant.PROJECTILE_BONE
			if stage == LevelStage.STAGE4_1 or stage == LevelStage.STAGE4_2 then
				if stageType == StageType.STAGETYPE_ORIGINAL or math.random(1, 4) ~= 1 then
					params.Variant = ProjectileVariant.PROJECTILE_NORMAL
				end
			end

			npc:FireBossProjectiles(1, npc.Position - d.chargedirection * 40, 0, params)
		end

		if math.abs(npc.Velocity.Y) > math.abs(npc.Velocity.X) then
			sprite.FlipX = false
			if npc.Velocity.Y < 0 then
				mod:spritePlay(sprite, "ChargeDown")
			else
				mod:spritePlay(sprite, "ChargeUp")
			end
		else
			mod:spritePlay(sprite, "ChargeHori")
			sprite.FlipX = npc.Velocity.X > 0
		end

		if (npc:CollidesWithGrid() and npc.StateFrame > 10) or npc.StateFrame >= 150 then
			d.state = "idle"
			d.stuntime = math.random(15, 30)
			d.chargedirection = nil
			npc.StateFrame = 0
		end
	end

	if d.state == "idle" or d.state == "seek" then
		local ind = room:GetGridIndex(npc.Position)
		if room:GetGridPath(ind) < 900 then
			room:SetGridPath(ind, 900)
		end

		if math.abs(npc.Velocity.Y) > math.abs(npc.Velocity.X) then
			sprite.FlipX = false
			if npc.Velocity.Y < 0 then
				mod:spritePlay(sprite, "Move Up")
			else
				mod:spritePlay(sprite, "Move Down")
			end
		else
			mod:spritePlay(sprite, "Move Hori")
			sprite.FlipX = npc.Velocity.X < 0
		end
	end
end