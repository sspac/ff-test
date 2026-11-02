local mod = FiendFolio



-- Spawn creep easily
---@param type EffectVariant Creep variant.
---@param spawner Entity | nil Creep spawner.
---@param position Vector Spawn position.
---@param scale number? Sprite scale, defaults to `1`.
---@param timeout number? Defaults to `124`.
---@return EntityEffect
function FiendFolio:QuickCreep(type, spawner, position, scale, timeout)
	---@type EntityEffect
	---@diagnostic disable-next-line: assign-type-mismatch
	local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, type, 0, position, Vector.Zero, spawner):ToEffect()
	creep.SpriteScale = Vector.One * (scale or 1)

	if timeout then
		creep:SetTimeout(timeout)
	end

	creep:Update()
	return creep
end



-- Wave of spawns
---@param waveScript function The function to run when the wave reaches a new position.
---@param spawner Entity? The entity the spawns belong to.
---@param startPos Vector? The position the wave should start from. If not given but a spawner is, it will use the spawner's position. If neither are given it will default to the room's center.
---@param angle number? The angle the wave should go in. Defaults to `0`.
---@param distance number? The distance between each spawn. Defaults to `40`.
---@param delay integer? The delay between each spawn in frames. Defaults to `5`.
---@param amount integer? The number of spawns to do before stopping. Defaults to `10`. The wave will also stop if the next position would be out of bounds.
---@param instantSpawn boolean? Setting it to `true` will make the first spawn in the wave instant, otherwise it spawns after `delay`.
---@param angleOffset Vector? Random offset for the angle between spawns. `X` should be the minimum and `Y` should be the maximum.
---@return EntityEffect timer The timer.
function FiendFolio:CreateSpawnWave(waveScript, spawner, startPos, angle, distance, delay, amount, instantSpawn, angleOffset)
	amount = amount or 10

	local func = function(timer)
		-- Get the next position
		local vector = Vector.FromAngle(angle or 0):Resized(distance or 40)
		if angleOffset then -- Random offset
			vector = vector:Rotated(mod:Random(angleOffset.X, angleOffset.Y))
		end

		local pos = timer.Position + vector

		-- If the next position is in the room, otherwise get removed
		if amount > 0 and Game():GetRoom():IsPositionInRoom(pos, 0) then
			timer.Position = pos
			timer.LifeSpan = timer.LifeSpan + 1
			waveScript(pos, spawner, timer)

		else
			timer:Remove()
		end
	end

	-- Create the timer
	local timer = Isaac.CreateTimer(func, delay or 5, amount, false)
	timer.Position = startPos or spawner and spawner.Position or Game():GetRoom():GetCenterPos()
	timer.LifeSpan = 0 -- Keep track of the number of spawns
	timer.Timeout = amount -- Keep track of the max number of spawns

	-- If the delay is 0 or less then force the updates otherwise there is still a 1 frame delay
	if delay <= 0 then
		for i = 1, amount do
			timer:Update()
		end

	-- Instantly spawn the first one
	elseif instantSpawn then
		timer:Update()
	end

	return timer
end



-- Dust effect
---@param pos Vector
---@param velocity? Vector Defaults to `Vector.Zero`.
---@param scale? number The size of the dust particle. Defaults to `0.5`.
---@param color? Color
---@param duration? number The duration of the dust. Defaults to a random number between 15 and 30.
---@return EntityEffect effect
function FiendFolio:SpawnDust(pos, velocity, scale, color, duration)
	local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, 0, pos, velocity or Vector.Zero, nil):ToEffect()
	local sprite = effect:GetSprite()

	-- Set the scale
	scale = scale or 0.5
	sprite.Scale = Vector.One * scale

	-- Set the color
	if color then
		sprite:GetLayer(0):SetColor(color)
	end

	-- Set the duration
	duration = duration or math.random(15, 30)
	effect.Timeout = duration
	effect.LifeSpan = duration

	effect:Update()
	return effect
end