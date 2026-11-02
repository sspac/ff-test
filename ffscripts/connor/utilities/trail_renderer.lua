local mod = FiendFolio
local game = Game()

-- Utility code for rendering trails, like the ones for purgatory ghosts and the like. By Connor!
-- At minimum, all you need to do to is call "RenderTrail", probably in MC_PRE/POST_X_RENDER, and the rest is handled automatically.
-- Scroll down to "RenderTrail" to see details on all the settings you can provide via the table parameter.

-- GetData subtable for the renderer to store info on the entity.
local function GetRendererData(ent)
	local data = mod:GetEntityData(ent)

	local key = mod.Name .. "TrailRendererPath"
	if not data[key] then
		data[key] = {}
	end

	return data[key]
end

-- Clears an entity's tracked trail path, if any.
function mod:ClearTrailPath(ent)
	GetRendererData(ent).Trail = {}
end

-- Gets an entity's tracked trail path.
-- Note this is empty unless it is actively being updated with UpdateTrailPath / RenderTrail.
function mod:GetTrailPath(ent)
	local data = GetRendererData(ent)

	if not data.Trail then
		data.Trail = {}
	end

	return data.Trail
end

--Stolen from PROAPI
local function Lerp(first, second, percent)
	return (first + (second - first)*percent)
end

-- Updates an entity's tracked trail path, up to maxLength.
function mod:UpdateTrailPath(ent, maxLength)
	local path = mod:GetTrailPath(ent)

	
	local currentPos = ent.Position + ent.PositionOffset + ent:GetNullOffset("Trail")

	if #path == 0 or path[1]:Distance(currentPos) > 0 then
		table.insert(path, 1, currentPos)
	end

	local pathLength = 0
	local i = 1
	while i < #path and path[i] and path[i+1] and pathLength <= maxLength do
		pathLength = pathLength + path[i]:Distance(path[i+1])
		i = i + 1
	end

	while path[i+1] do
		table.remove(path, i+1)
	end

	return path
end

-- Given a table of positions representing a path, returns a new table of points along that path.
-- The distance between each point is <step>, which gets multiplied by <stepMult> after each point.
function mod:GetStepsAlongPath(path, step, stepMult)
	local subStep = step
	local newPath = {}
	local prev
	for i, pos in ipairs(path) do
		if prev then
			local dist = prev:Distance(pos)
			while dist > subStep do
				local newPos = Lerp(prev, pos, subStep/dist)
				table.insert(newPath, newPos)
				if stepMult then
					step = step * stepMult
					if step < 0.001 then
						return newPath
					end
				end
				dist = dist - subStep
				subStep = step
				prev = newPos
			end
			subStep = subStep - dist
		else
			table.insert(newPath, pos)
		end
		prev = pos
	end
	return newPath
end

local function GetRangeArg(arg)
	if type(arg) == "number" then
		return arg, arg
	elseif type(arg) == "table" then
		return arg[1] or 0, arg[2] or 0
	end
	return 0, 0
end

local function SaveSpriteState(spr)
	return {
		Sprite = spr,
		Anim = spr:GetAnimation(),
		Frame = spr:GetFrame(),
		IsPlaying = spr:IsPlaying(),
	}
end

local function RestoreSpriteState(sprState)
	local spr = sprState.Sprite
	spr:Play(sprState.Anim, true)
	spr:SetFrame(sprState.Frame)
	if not sprState.IsPlaying then
		spr:Stop()
	end
end

--[[
args = {
	MaxLength = 100,  -- Maximum distance of entity's position history to track in memory. Defaults to 100.
	SkipFirstPos = true  -- Whether to skip rendering part of the trail on the position of the entity itself. Defaults to true.
	Spacing = 10,  -- Distance between each rendered piece of the trail. Defaults to 10.
	SpacingMult = 0.9,  -- The "Spacing" is multiplied by this amount at each step, to gradually increase/decrease spacing. Defaults to 1.0.
	VelocitySpacing = 0,  -- If provided and > 0, increases the Spacing based on the entity's current velocity length, multiplied by this value.
	VelocitySpacingLimit = 10,  -- Limit on how much additional Spacing can be added due to the entity's velocity. Defaults to the Spacing value.
	VelocitySpacingLerp = 0.1,  -- Lerp strength whenever adding/removing velocity spacing. Defaults to 0.1.
	TrailSprite = sprite,  -- Sprite used for rendering the trail. Defaults to using the entity's Sprite.
	TrailAnim = "Trail",  -- Animation to use for the trail. Each frame is rendered once.
	TrailOutlineAnim = "TrailOutline",  -- Animation to use for the trail outline. Each frame is rendered once.
	RenderEntity = true,  -- Whether to render the entity itself after the trail is rendered. Defaults to false. Likely not needed if you use REPENTOGON's MC_PRE_X_RENDER callbacks.
	EntityOutlineAnim = "Outline", -- Outline animation for the entity itself, if desired. Always uses the entity's Sprite.
	Wiggle = {  -- Optional, makes the pieces of the trail wiggle back and forth.
		Speed = 1.0,
		Frequency = 1.0,  -- How many "waves" along the length of the trail. (higher = more dense)
		Amount = 2,  -- How far to wiggle side to side.
		Amount = {2, 4},  -- To wiggle different amounts at the {start, end} of the trail.
	},
	Pulse = {  -- Optional, makes the pieces of the trail pulse bigger and smaller.
		Speed = 1.0,
		Frequency = 1.0,  -- How many "pulses" along the length of the trail.
		Amount = 0.1,  -- How much to pulse, as a scale deviation (ie, this is 0.9 to 1.1).
		Amount = {0.2, 0.1},  -- To pulse different amounts at the {start, end} of the trail.
	},
}
]]
function mod:RenderTrail(ent, args)
	local data = GetRendererData(ent)

	local path = mod:UpdateTrailPath(ent, args.MaxLength or 100)

	local spacing = args.Spacing or 10
	local lastSpacing = data.LastSpacing or spacing

	local velSpacing = args.VelocitySpacing or 0
	local velLimit = args.VelocitySpacingLimit or spacing
	local velLerp = args.VelocitySpacingLerp or 0.1

	if velSpacing > 0 then
		spacing = Lerp(lastSpacing, spacing + math.min(ent.Velocity:Length() * velSpacing, velLimit), velLerp)
	end

	local trailPath = mod:GetStepsAlongPath(path, spacing * ent.SpriteScale.Y, args.SpacingMult)

	local realEntSprite = ent:GetSprite()

	-- TODO: Implement a better fix for non-integer playbackspeeds on the main entity sprite, maybe make the trail animations respect playbackspeed.
	if not data.EntitySpriteCopy then
		local newSprite = Sprite()
		newSprite:Load(realEntSprite:GetFilename())
		data.EntitySpriteCopy = newSprite
		local i = 0
		local layer
		repeat
			layer = realEntSprite:GetLayer(i)
			if layer then
				--print(i)
				--print(layer:GetSpritesheetPath())
				newSprite:ReplaceSpritesheet(i, layer:GetSpritesheetPath())
			end
			i = i + 1
		until not layer
		newSprite:LoadGraphics()
	end

	local entSprite = data.EntitySpriteCopy
	entSprite.Color = realEntSprite.Color
	entSprite.FlipX = realEntSprite.FlipX
	entSprite.FlipY = realEntSprite.FlipY
	entSprite.Offset = realEntSprite.Offset
	entSprite.Rotation = realEntSprite.Rotation
	entSprite.Scale = realEntSprite.Scale
	entSprite:Play(realEntSprite:GetAnimation() ~= "" and realEntSprite:GetAnimation() or realEntSprite:GetDefaultAnimation(), true)
	entSprite:SetFrame(realEntSprite:GetFrame())
	if not realEntSprite:IsPlaying() then
		entSprite:Stop()
	end

	local trailSprite = args.TrailSprite or entSprite

	local trailSpriteState = SaveSpriteState(trailSprite)

	if args.EntityOutlineAnim then
		local entSpriteState = SaveSpriteState(entSprite)
		entSprite:SetAnimation(args.EntityOutlineAnim, false)
		entSprite:Render(Isaac.WorldToScreen(trailPath[1]))
		RestoreSpriteState(entSpriteState)
	end

	local scale = Vector(trailSprite.Scale.X, trailSprite.Scale.Y)

	local currentFrame = Isaac.GetFrameCount()
	local lastUpdate = data.LastUpdate or currentFrame
	data.LastUpdate = lastUpdate

	local t = data.FrameCount or lastUpdate

	if currentFrame > lastUpdate and not game:IsPaused() then
		data.FrameCount = t + 1
		data.LastSpacing = spacing
	end

	local trailAnims = {}
	if args.TrailOutlineAnim then table.insert(trailAnims, args.TrailOutlineAnim) end
	if args.TrailAnim then table.insert(trailAnims, args.TrailAnim) end

	local trailOffset = args.SkipFirstPos ~= false and 1 or 0

	for _, anim in ipairs(trailAnims) do
		trailSprite:SetAnimation(anim)
		trailSprite:SetLastFrame()
		local animLength = trailSprite:GetFrame()
		for i=animLength, 0, -1 do
			local pos = trailPath[i+1+trailOffset]
			if pos then
				local t0 = (animLength - i + ent.InitSeed) % animLength
				local doWiggle = true
				local doPulse = true
				if args.Wiggle then
					local dir = (trailPath[i+2+trailOffset] or pos) - (trailPath[i+trailOffset] or pos)
					if dir:Length() > 0 then
						local wiggleSpeed = args.Wiggle.Speed or 1.0
						local wiggleFrequency = args.Wiggle.Frequency or 1.0
						local startWiggle, endWiggle = GetRangeArg(args.Wiggle.Amount)
						local wiggleAmount = Lerp(startWiggle, endWiggle, i / animLength)
						local n = (t0 + t * wiggleSpeed / 10) / animLength
						local wiggle = wiggleAmount * math.sin(2 * math.pi * n * wiggleFrequency)
						pos = pos + dir:Rotated(90):Resized(wiggle)
					end
				end
				if args.Pulse then
					local pulseSpeed = args.Pulse.Speed or 1.0
					local pulseFrequency = args.Pulse.Frequency or 1.0
					local startPulse, endPulse = GetRangeArg(args.Pulse.Amount)
					local pulseAmount = Lerp(startPulse, endPulse, i / animLength)
					local n = (t0 + t * pulseSpeed / 10) / animLength
					trailSprite.Scale = scale * (1.0 + pulseAmount * math.sin(2 * math.pi * n * pulseFrequency))
				end
				trailSprite:SetFrame(i)
				trailSprite:Render(Isaac.WorldToScreen(pos))
			end
		end
	end

	RestoreSpriteState(trailSpriteState)
	trailSprite.Scale = scale

	if args.RenderEntity then
		entSprite:Render(Isaac.WorldToScreen(trailPath[1]))
	end
end
