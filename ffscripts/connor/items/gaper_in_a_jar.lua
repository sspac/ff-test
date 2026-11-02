local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local VECTOR_ZERO = Vector.Zero
local VECTOR_ONE = Vector(1, 1)
local KCOLOR_DEFAULT = KColor(1,1,1,1)

local DISALLOW_COLLECTION = {
	{ EntityType.ENTITY_SHOPKEEPER, 1 },
	{ EntityType.ENTITY_SHOPKEEPER, 4 },
	{ mod.FFID.Tech },
	{ mod.FF.DungeonMaster.ID, mod.FF.DungeonMaster.Var },
}

local DISALLOW_DEATH_EFFECTS = {
	{ EntityType.ENTITY_SWARM },
}

local THROWN_SPIN_SPEED = 15
local THROWN_DAMAGE_HP_MULT = 1.0

local COLOR_JAR_RGB = {
	R = 25,
	G = 25,
	B = 10,
}
local COLOR_JAR_OFFSET = { COLOR_JAR_RGB.R/255, COLOR_JAR_RGB.G/255, COLOR_JAR_RGB.B/255 }
local COLORMOD_JAR = Color(0, 0, 0, 1, COLOR_JAR_OFFSET[1], COLOR_JAR_OFFSET[2], COLOR_JAR_OFFSET[3])

local ITEM_DESC = Isaac.GetItemConfig():GetCollectible(mod.ITEM.COLLECTIBLE.GAPER_IN_A_JAR).Description
local EMPTY_JAR_NAME = "Nothing in a Jar"
local EMPTY_JAR_DESC = "Fill it!"
local FALLBACK_MONSTER_NAME = "Monster"

local function GetJarName(jarContents)
	if jarContents then
		return (jarContents.Name or FALLBACK_MONSTER_NAME) .. " in a Jar", ITEM_DESC
	end
	return EMPTY_JAR_NAME, EMPTY_JAR_DESC
end

local DEFAULT_JAR_CONTENTS = {
	Type = EntityType.ENTITY_GAPER,
	Variant = 1,
	SubType = 0,
	Name = "Gaper",
	Anm2 = "gfx/010.001_gaper.anm2",
	Anim = "WalkVert",
	Overlay = "Head",
	HP = 10,
	Size = 13,
	Scale = 1,
	Spritesheets = {},
}

local function GetDefaultJarContents()
	local data = StageAPI.DeepCopy(DEFAULT_JAR_CONTENTS)

	if FFGRACE and FFGRACE.STAGE and FFGRACE.STAGE.Boiler and FFGRACE.STAGE.Boiler:IsStage() then
		for _, sheet in pairs(mod:Access(FFGRACE, "StageSkins", "Boiler", EntityType.ENTITY_GAPER.." "..1) or {}) do
			for _, layer in pairs(sheet[1]) do
				local filepath = sheet[2]
				data.Spritesheets[layer] = filepath .. ".png"
			end
		end
	else
		local suffix = nil

		local levelstage = game:GetLevel():GetStage()
		local stagetype = game:GetLevel():GetStageType()

		if levelstage == LevelStage.STAGE1_1 or levelstage == LevelStage.STAGE1_2 then
			if stagetype == StageType.STAGETYPE_REPENTANCE then
				suffix = "_downpour"
			elseif stagetype == StageType.STAGETYPE_REPENTANCE_B then
				suffix = "_dross"
			end
		elseif levelstage == LevelStage.STAGE2_1 or levelstage == LevelStage.STAGE2_2 then
			if stagetype == StageType.STAGETYPE_AFTERBIRTH then
				suffix = "_downpour"
			end
		end

		if suffix then
			data.Spritesheets[0] = "gfx/monsters/classic/monster_000_bodies01" .. suffix .. ".png"
			data.Spritesheets[1] = "gfx/monsters/classic/monster_017_gaper" .. suffix .. ".png"
		end
	end

	return data
end

local FALLBACK_SPRITE_DATA = {
	Anm2 = "gfx/005.100_collectible.anm2",
	Anim = "ShopIdle",
	Spritesheets = {
		[1] = "gfx/ui/minimap_questionmark.png"
	},
}
local FALLBACK_SPRITE_DIMS = nil

--------------------------------------------------
-- Make the blacklist

local JAR_BLACKLIST = {}

local BlacklistMode = {
	NO_COLLECT = 1,
	NO_DEATH_EFFECT = 2,
}

local function AddToBlacklist(id, var, subt, mode)
	var = var or -1
	subt = subt or -1
	
	if not JAR_BLACKLIST[id] then
		JAR_BLACKLIST[id] = {}
	end
	if not JAR_BLACKLIST[id][var] then
		JAR_BLACKLIST[id][var] = {}
	end
	JAR_BLACKLIST[id][var][subt] = mode
end

function mod:DisallowGaperJarCollection(id, var, subt)
	AddToBlacklist(id, var, subt, BlacklistMode.NO_COLLECT)
end

function mod:DisallowGaperJarDeathEffects(id, var, subt)
	AddToBlacklist(id, var, subt, BlacklistMode.NO_DEATH_EFFECT)
end

for _, tab in pairs(DISALLOW_COLLECTION) do
	mod:DisallowGaperJarCollection(tab[1], tab[2], tab[3])
end

for _, tab in pairs(DISALLOW_DEATH_EFFECTS) do
	mod:DisallowGaperJarDeathEffects(tab[1], tab[2], tab[3])
end

local function CheckBlacklist(id, var, subt)
	local tab = JAR_BLACKLIST[id] or JAR_BLACKLIST[-1]
	if not tab then return false end
	tab = tab[var] or tab[-1]
	if not tab then return false end
	return tab[subt] or tab[-1] or nil
end

local function CollectionBlacklisted(id, var, subt)
	return CheckBlacklist(id, var, subt) == BlacklistMode.NO_COLLECT
end

local function DeathEffectBlacklisted(id, var, subt)
	return CheckBlacklist(id, var, subt) == BlacklistMode.NO_DEATH_EFFECT
end

--------------------------------------------------
-- SPRITE PROCESSING NONSENSE

-- Images require a name to be created. Currently, they don't need to be unique though, so we can use this name for all of them.
local IMAGE_NAME = "FF_GAPER_IN_A_JAR"

-- The size of the image used to render the contents of the jar.
-- 1x is pixel perfect for an item sprite, but the enemy silhouette gets crunchy. Looks cool though!
-- 2x is a quality increase while still being reasonably consistent.
local IMAGE_RESOLUTION = 1

-- Multiplier on the size of the enemy sprite visible inside the jar. Basically creates visible padding.
local IMAGE_SCALE = 0.75

local UP = Vector(0, -1)
local DOWN = Vector(0, 1)
local LEFT = Vector(-1, 0)
local RIGHT = Vector(1, 0)

-- Returns `minX, maxX, minY, maxY` corresponding to the maximum area within the ANM2's current frame
-- where the actual spritesheet may be rendered. Basically this is a bounding box that includes the
-- "empty space" surrounding the actual sprites in the "crop" boxes.
-- Does not include LayerState modifications.
local function GetSpriteBounds(spr)
	-- Gather the corner points for the frame current visible on each layer.
	-- Basically the space cropped from the spritesheets.
	local points = {}
	for _, tab in pairs({{Frame=spr:GetFrame(), AnimData=spr:GetCurrentAnimationData()}, {Frame=spr:GetOverlayFrame(), AnimData=spr:GetOverlayAnimationData()}}) do
		local frame = tab.Frame
		local animData = tab.AnimData
		if animData then
			for _, animLayer in ipairs(animData:GetAllLayers()) do
				if animLayer:IsVisible() then
					local animFrame = animLayer:GetFrame(frame)
					if animFrame and animFrame:IsVisible() then
						local layerid = animLayer:GetLayerID()
						local w = animFrame:GetWidth()
						local h = animFrame:GetHeight()
						for _, offset in pairs({Vector(0, 0), Vector(w, 0), Vector(0, h), Vector(w, h)}) do
							local frameScale = animFrame:GetScale()
							local frameOffset = offset * frameScale - animFrame:GetPivot() * frameScale
							local pos = animFrame:GetPos() * frameScale + frameOffset:Rotated(animFrame:GetRotation())
							table.insert(points, pos)
						end
					end
				end
			end
		end
	end

	-- Get the min/max X/Y from the gathered points above.
	local minX, maxX, minY, maxY
	for _, point in ipairs(points) do
		minX = minX and math.min(minX, point.X) or point.X
		maxX = maxX and math.max(maxX, point.X) or point.X
		minY = minY and math.min(minY, point.Y) or point.Y
		maxY = maxY and math.max(maxY, point.Y) or point.Y
	end
	minX = math.floor(minX or 0)
	maxX = math.ceil(maxX or 0)
	minY = math.floor(minY or 0)
	maxY = math.ceil(maxY or 0)

	return minX, maxX, minY, maxY
end

-- Generates an Image cropped to only the visible pixels in the current frame of the provided Sprite.
function mod:CreateCroppedImage(spr, alphaThreshold, buffer)
	-- Get the initial box, which encompasses all of the crop boxes from the spritesheets.
	local minX, maxX, minY, maxY = GetSpriteBounds(spr)

	local initialWidth = maxX - minX
	local initialHeight = maxY - minY

	-- Offset required to center the sprite relative to its anm2 root.
	local offset = -Vector((minX + maxX) / 2, (minY + maxY) / 2)

	-- Create an image of the exact size of our initial bounding box.
	-- By default, this will be all transparent pixels.
	local image = Renderer.CreateImage(initialWidth, initialHeight, IMAGE_NAME)

	-- Render the sprite onto the image.
	-- ANY rendering operations performed within the function passed to RenderToImage will be applied to the image only.
	Renderer.RenderToImage(image, function()
		local origScale = spr.Scale
		local origOffset = spr.Offset
		local origRot = spr.Rotation
		local origFlipX = spr.FlipX
		local origFlipY = spr.FlipY
		local origColor = Color.Lerp(spr.Color, Color.Default, 0)  -- copy

		spr.Scale = VECTOR_ONE
		spr.Offset = offset
		spr.Rotation = 0
		spr.FlipX = false
		spr.FlipY = false
		spr.Color = Color.Default

		local imageCenter = Vector(initialWidth/2, initialHeight/2)
		spr:Render(imageCenter)

		spr.Scale = origScale
		spr.Offset = origOffset
		spr.Rotation = origRot
		spr.FlipX = origFlipX
		spr.FlipY = origFlipY
		spr.Color = origColor
	end)

	-- Next we're gonna re-evaluate the min/max X/Y by parsing ALL THE PIXELS. You heard me!
	local minX, maxX, minY, maxY

	-- GetTexelRegion returns a byte string for all of the pixels in the specified region.
	-- Basically each pixel is 4 bytes: R G B A
	-- In this case, I am fetching the entire image I previously rendered from the current anm2 frame.
	-- This is actually very efficient, since we can get the whole string in one call,
	-- then parse it entirely from within lua by reading bytes from the string.
	-- Compared to GetTexel we can get way more information with way better performance.
	local imageBytes = image:GetTexelRegion(0, 0, initialWidth, initialHeight)
	local imageByteSize = #imageBytes

	if alphaThreshold == -1 then
		for i = 1, imageByteSize, 4 do
			local r, g, b, a = imageBytes:byte(i, i+3)
			if a > alphaThreshold then
				alphaThreshold = 1
			end
		end
	end

	for i = 1, imageByteSize, 4 do
		local r, g, b, a = imageBytes:byte(i, i+3)
		if a >= (alphaThreshold or 255) then
			-- Compute the row and column of this pixel.
			local pixelIndex = (i-1)/4
			local row = math.floor(pixelIndex / initialWidth)
			local col = pixelIndex % initialWidth
			local x = col
			local y = row
			-- Update our min/max coordinates for visible pixels.
			minX = minX and math.min(minX, x) or x
			maxX = maxX and math.max(maxX, x) or x
			minY = minY and math.min(minY, y) or y
			maxY = maxY and math.max(maxY, y) or y
		end
	end

	if not minX or not maxX or not minY or not maxY then
		return Renderer.CreateImage(0, 0, IMAGE_NAME)
	end

	buffer = buffer or 1
	minX = math.floor(minX - buffer)
	maxX = math.ceil(maxX + 1 + buffer)
	minY = math.floor(minY - buffer)
	maxY = math.ceil(maxY + 1 + buffer)

	-- We now have the coordinates needed to crop the image tightly.
	local croppedWidth = maxX - minX
	local croppedHeight = maxY - minY

	-- Create a new image of our desired size, and render the first image onto it.
	-- You can render images onto other images as much as you'd like.
	local croppedImage = Renderer.CreateImage(croppedWidth, croppedHeight, IMAGE_NAME)
	Renderer.RenderToImage(croppedImage, function()
		local src = SourceQuad(Vector(minX, minY), Vector(maxX, minY), Vector(minX, maxY), Vector(maxX, maxY))
		local dst = DestinationQuad(Vector(0, 0), Vector(croppedWidth, 0), Vector(0, croppedHeight), Vector(croppedWidth, croppedHeight))
		image:Render(src, dst, KCOLOR_DEFAULT)
	end)

	return croppedImage
end

local function LoadSprite(data, providedSprite)
	local spr = providedSprite or Sprite()
	spr:Load(data.Anm2, true)
	spr:SetFrame(data.Anim, data.Frame or 0)
	if data.Overlay then
		spr:SetOverlayFrame(data.Overlay, data.OverlayFrame or 0)
	end
	if data.Spritesheets then
		for layer, gfx in pairs(data.Spritesheets) do
			spr:ReplaceSpritesheet(layer, gfx)
		end
		spr:LoadGraphics()
	end
	spr:Stop()
	spr:Update()
	return spr
end

-- Area within the jar sprite where the enemy should be rendered/centered.
local JAR_CONTENT_BOX = {
	Pos = Vector(8,9),
	Width = 17,
	Height = 18,
}

local function InitJarSprite(data)
	local sprite = LoadSprite(data)

	-- Image containing the tightly cropped current frame of the enemy's animation.
	local enemyImage = mod:CreateCroppedImage(sprite, -1, 1)

	if enemyImage:GetWidth() == 0 or enemyImage:GetHeight() == 0 then
		enemyImage = mod:CreateCroppedImage(LoadSprite(FALLBACK_SPRITE_DATA), 255, 1)
	end

	local enemyWidth = enemyImage:GetWidth()
	local enemyHeight = enemyImage:GetHeight()

	-- Image that will contain the little silhouette of the enemy for inside of the jar.
	local jarImage = Renderer.CreateImage(32 * IMAGE_RESOLUTION, 32 * IMAGE_RESOLUTION, IMAGE_NAME)
	local jarWidth = jarImage:GetWidth()
	local jarHeight = jarImage:GetHeight()

	Renderer.RenderToImage(jarImage, function()
		-- I didn't end up needing to do this, but you can load pngs as images too.
		--[[
		local emptyJarImage = Renderer.LoadImage("gfx/items/collectibles/collectibles_gaper_in_a_jar.png")
		emptyJarImage:Render(
			SourceQuad(Vector(0,0), Vector(32, 0), Vector(0, 32), Vector(32, 32)),
			DestinationQuad(Vector(0,0), Vector(32 * IMAGE_RESOLUTION, 0), Vector(0, 32 * IMAGE_RESOLUTION), Vector(32 * IMAGE_RESOLUTION, 32 * IMAGE_RESOLUTION)),
			KCOLOR_DEFAULT)
		]]

		-- Computes the scale/etc we need to render to sprite to fit nicely within the jar.
		local scale = math.min(math.min(JAR_CONTENT_BOX.Width * IMAGE_RESOLUTION / enemyWidth, JAR_CONTENT_BOX.Height * IMAGE_RESOLUTION / enemyHeight) * IMAGE_SCALE, 1)
		local mid = (JAR_CONTENT_BOX.Pos + Vector(JAR_CONTENT_BOX.Width, JAR_CONTENT_BOX.Height) / 2) * IMAGE_RESOLUTION
		local src = SourceQuad(Vector(0,0), Vector(enemyWidth, 0), Vector(0, enemyHeight), Vector(enemyWidth, enemyHeight))
		local dst = DestinationQuad(
			mid + 0.5*scale*Vector(-enemyWidth, -enemyHeight),
			mid + 0.5*scale*Vector(enemyWidth, -enemyHeight),
			mid + 0.5*scale*Vector(-enemyWidth, enemyHeight),
			mid + 0.5*scale*Vector(enemyWidth, enemyHeight))

		-- You can render images using shaders! With custom inputs!
		-- Here I'm not doing anything special, just the default ColorOffset shader with params to render the image as one flat color.
		-- But its still a nice little example of how to use RenderWithShader.
		-- Reminder that here I am rendering an Image using a shader to another Image!
		local clipPaneNormal = Renderer.GetClipPaneNormal()
		local clipPaneThreshold = Renderer.GetClipPaneThreshold()
		enemyImage:RenderWithShader(src, dst, KCOLOR_DEFAULT, Renderer.GetShaderByType(0), {
			ColorizeIn = { 0, 0, 0, 1 },
			ColorOffsetIn = COLOR_JAR_OFFSET,
			TextureSize = { enemyWidth, enemyHeight },
			PixelationAmount = 0,
			ClipPlane = { clipPaneNormal.X, clipPaneNormal.Y, clipPaneThreshold },
		})
	end)

	-- Store the dimensions and SourceQuads alongside the images for later use.
	return {
		EnemyImage = enemyImage,
		Dimensions = {
			Width = enemyWidth,
			Height = enemyHeight,
			MidPoint = Vector(enemyWidth/2, enemyHeight/2)
		},
		EnemyQuad = SourceQuad(Vector(0,0), Vector(enemyWidth, 0), Vector(0, enemyHeight), Vector(enemyWidth, enemyHeight)),
		JarImage = jarImage,
		JarQuad = SourceQuad(Vector(0,0), Vector(jarWidth, 0), Vector(0, jarHeight), Vector(jarWidth, jarHeight)),
	}
end

--------------------------------------------------
-- DATA TABLES

local JAR_SPRITE_CACHE = {}

local function GetPlayerKey(player)
	-- Player InitSeeds are inconsistent with Tainted Lazarus & co-op.
	-- However, using collectible RNG seeds seems to work, even if potentially breakable.
	if player:GetPlayerType() == PlayerType.PLAYER_LAZARUS2_B then
		return ""..player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_INNER_EYE):GetSeed() -- flip sucks
	end
	return ""..player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_SAD_ONION):GetSeed()
end

local function GetAllJarData()
	local rundata = FiendFolio.savedata.run
	if not rundata.GAPER_IN_A_JAR_DATA then
		rundata.GAPER_IN_A_JAR_DATA = {
			PLAYER = {},
			DROPPED = {},
		}
	end
	return rundata.GAPER_IN_A_JAR_DATA
end

local function GetDroppedJarData()
	local data = GetAllJarData()
	return data.DROPPED
end

local function GetJarData(player)
	local data = GetAllJarData()
	local key = GetPlayerKey(player)
	
	if not data.PLAYER[key] then
		data.PLAYER[key] = {}
	end
	
	return data.PLAYER[key]
end

local function GetJarSlot(player, slot)
	return GetJarData(player)[""..slot]
end

local function SetJarSlot(player, slot, newdata, newsprite)
	GetJarData(player)[""..slot] = newdata
	
	-- Set (or clear) the cached sprite for this slot.
	local key = GetPlayerKey(player)
	if JAR_SPRITE_CACHE[key] then
		JAR_SPRITE_CACHE[key][slot] = newsprite
	end
end

local function GetJarSprite(player, slot)
	local key = GetPlayerKey(player)
	
	if not JAR_SPRITE_CACHE[key] then
		JAR_SPRITE_CACHE[key] = {}
	end
	
	if not JAR_SPRITE_CACHE[key][slot] then
		local data = GetJarSlot(player, slot)
		if data then
			JAR_SPRITE_CACHE[key][slot] = InitJarSprite(data)
		end
	end
	
	return JAR_SPRITE_CACHE[key][slot]
end

local function GetJarSpriteForPedestal(seed, andRemove)
	local key = "I"..seed
	local spriteData = JAR_SPRITE_CACHE[key]
	if andRemove then
		JAR_SPRITE_CACHE[key] = nil
	elseif not spriteData then
		local jarContents = GetDroppedJarData()[""..seed]
		if jarContents then
			spriteData = InitJarSprite(jarContents)
			JAR_SPRITE_CACHE[key] = spriteData
		end
	end
	return spriteData
end

local function SetJarSpriteForPedestal(seed, spriteData)
	local key = "I"..seed
	JAR_SPRITE_CACHE[key] = spriteData
end

-- Swaps the jar data between the primary and secondary slots.
local function SwapJarData(player)
	local jarData1 = GetJarSlot(player, ActiveSlot.SLOT_PRIMARY)
	local jarData2 = GetJarSlot(player, ActiveSlot.SLOT_SECONDARY)
	
	local jarSprite1 = GetJarSprite(player, ActiveSlot.SLOT_PRIMARY)
	local jarSprite2 = GetJarSprite(player, ActiveSlot.SLOT_SECONDARY)
	
	SetJarSlot(player, ActiveSlot.SLOT_PRIMARY, jarData2, jarSprite2)
	SetJarSlot(player, ActiveSlot.SLOT_SECONDARY, jarData1, jarSprite1)
end

local function GetNormalizedNameFromConfig(config)
	if config then
		return config:GetName():gsub("#", ""):gsub("_", " "):lower():gsub("^%l", string.upper):gsub(" %l", string.upper)
	end
end

local function ShouldBeHomingProjectile(config)
	if config then
		if config:HasEntityTags(EntityTag.HOMING_SOUL) then
			return true
		end
		if config.Type == EntityType.ENTITY_LITTLE_HORN and config.Variant == 1 then
			return true -- Dark Ball
		end
	end
	return false
end

local function CreateJarDataForEnemy(enemy)
	local config = EntityConfig.GetEntity(enemy.Type, enemy.Variant, enemy.SubType)
	local spr = enemy:GetSprite()
	local data = {
		Type = enemy.Type,
		Variant = enemy.Variant,
		SubType = enemy.SubType,
		Name = GetNormalizedNameFromConfig(config) or FALLBACK_MONSTER_NAME,
		Anm2 = spr:GetFilename(),
		Anim = spr:GetAnimation(),
		Frame = spr:GetFrame(),
		Overlay = spr:GetOverlayAnimation(),
		OverlayFrame = spr:GetOverlayFrame(),
		HP = enemy.MaxHitPoints,
		Size = enemy.Size,
		Scale = enemy:ToNPC() and enemy:ToNPC().Scale or 1,
		Color = enemy.Color,
		Homing = ShouldBeHomingProjectile(config),
		Spritesheets = {},
	}
	if data.Type == EntityType.ENTITY_BALL_AND_CHAIN then
		data.Overlay = nil
		data.OverlayFrame = nil
	end
	for i = 0, spr:GetLayerCount() do
		local layerState = spr:GetLayer(i)
		if layerState then
			local spritesheet = layerState:GetSpritesheetPath()
			if spritesheet ~= layerState:GetDefaultSpritesheetPath() then
				data.Spritesheets[i] = spritesheet
			end
		end
	end
	return data
end

--------------------------------------------------
-- ACTIVE CODE

local function HasJarInSlot(player, slot)
	return player:GetActiveItem(slot) == mod.ITEM.COLLECTIBLE.GAPER_IN_A_JAR
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, item, rng, player, useflags, activeslot)
	if useflags & UseFlag.USE_CARBATTERY ~= 0 or useflags & UseFlag.USE_MIMIC ~= 0 or activeslot < ActiveSlot.SLOT_PRIMARY or activeslot > ActiveSlot.SLOT_POCKET2 then
		return {Discharge = false, Remove = false, ShowAnim = false}
	end

	local d = mod:GetEntityData(player)
	if d.holdingFFItem then
		d.holdingFFItem = nil
		d.holdingFFItemSlot = nil
		d.previousHeldGaperJarSlot = activeslot
		player:AnimateCollectible(mod.ITEM.COLLECTIBLE.GAPER_IN_A_JAR, "HideItem", "PlayerPickup")
		sfx:Play(SoundEffect.SOUND_URN_CLOSE)
	else
		d.holdingFFItem = mod.ITEM.COLLECTIBLE.GAPER_IN_A_JAR
		d.holdingFFItemSlot = activeslot
		d.previousHeldGaperJarSlot = nil
		player:AnimateCollectible(mod.ITEM.COLLECTIBLE.GAPER_IN_A_JAR, "LiftItem", "PlayerPickup")
		sfx:Play(SoundEffect.SOUND_URN_OPEN)
	end
	return {Discharge = false}
end, mod.ITEM.COLLECTIBLE.GAPER_IN_A_JAR)

local function CanBePutInJar(ent)
	if ent:IsBoss() or mod:isFriend(ent) or CollectionBlacklisted(ent.Type, ent.Variant, ent.SubType) then
		return false
	end
	return ent.Type == EntityType.ENTITY_SHOPKEEPER or ent:IsActiveEnemy()
end

local function TryCollectEnemy(player, pos)
	local target
	local targetDist

	for _, ent in pairs(Isaac.FindInRadius(pos, 40)) do
		local dist = ent.Position:Distance(player.Position)
		if CanBePutInJar(ent) and (not targetDist or dist < targetDist) then
			target = ent
			targetDist = dist
		end
	end

	return target
end

local function SpawnClubHitbox(player, dir)
    local variant = KnifeVariant.BONE_CLUB

    local pos = player.Position + Vector(-30, -10) + dir:Resized(45) + player.Velocity
    local knife = Isaac.Spawn(EntityType.ENTITY_KNIFE, variant, KnifeSubType.CLUB_HITBOX, pos, mod.nilvector, player):ToKnife()
    local sprite = knife:GetSprite()
    sprite:Play("Swing", true)

    knife.Visible = false
    knife:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
    knife.Parent = player
    knife:SetIsSwinging(true)
    knife.CollisionDamage = 0
end

local function GaperInAJarSwing(player, aim, slot)
	sfx:Play(SoundEffect.SOUND_FETUS_JUMP)

	local eff = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, player.Position, VECTOR_ZERO, player):ToEffect()
	eff:GetSprite():Load("gfx/effects/effect_jarswing.anm2", true)
	eff:GetSprite():Play("Swing", true)
	eff:FollowParent(player)
	eff.ParentOffset = aim:Resized(10 * player.SpriteScale.X) + Vector(0, -10)
	eff:Update()
	eff.Rotation = -aim:GetAngleDegrees() + 90
	eff.RenderZOffset = 1

	local target = TryCollectEnemy(player, player.Position + aim:Resized(30))
				or TryCollectEnemy(player, player.Position + aim:Resized(30) + player.Velocity*5)
	SpawnClubHitbox(player, aim)

	if target then
		Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 1, target.Position, VECTOR_ZERO, player):ToEffect()
		SetJarSlot(player, slot, CreateJarDataForEnemy(target))
		target:Remove()
		sfx:Play(mod.Sounds.GaperInAJarCollect)
	end
end

local function GaperInAJarThrow(player, aim, slot)
	sfx:Play(SoundEffect.SOUND_SHELLGAME)

	local jarContents = GetJarSlot(player, slot)
	local jarSpriteData = GetJarSprite(player, slot)

	local numProjectiles = 1

	if player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
		numProjectiles = numProjectiles + 1
	end

	local hasEternalCarBattery = player:HasTrinket(mod.ITEM.TRINKET.ETERNAL_CAR_BATTERY)
	if hasEternalCarBattery then
		numProjectiles = numProjectiles + mod:RandomInt(3, 5)
	end

	for i=1, numProjectiles do
		local vel = aim:Resized(10) + player:GetTearMovementInheritance(aim)

		if i > 1 then
			vel = vel:Rotated(mod:RandomFloat(-15, 15)) * mod:RandomFloat(0.75, 0.95)
		end

		local proj = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, mod.FF.GaperInAJarProjectile.Var, 0, player.Position, vel, player):ToProjectile()
		proj:AddProjectileFlags(ProjectileFlags.HIT_ENEMIES | ProjectileFlags.CANT_HIT_PLAYER | ProjectileFlags.ANY_HEIGHT_ENTITY_HIT)

		if jarContents.Homing then
			proj:AddProjectileFlags(ProjectileFlags.SMART)
		end

		local sprite = proj:GetSprite()
		LoadSprite(jarContents, sprite)

		local data = mod:GetEntityData(proj)
		data.ffGaperJarSpriteData = jarSpriteData
		data.ffGaperJarProjData = jarContents
		proj.CollisionDamage = jarContents.HP * THROWN_DAMAGE_HP_MULT
		proj.FallingAccel = -0.1
		proj.FallingSpeed = 0
		proj.Height = (-10 - (jarSpriteData.Dimensions.Height * 0.75)) * jarContents.Scale
		proj.Scale = jarSpriteData.Dimensions.Width / 15
		proj.Size = jarContents.Size * jarContents.Scale
		proj.SpriteScale = Vector(jarContents.Scale, jarContents.Scale)
		if jarContents.Color then
			proj.Color = jarContents.Color
		end
		proj:Update()
	end

	if player:HasTrinket(mod.ITEM.ROCK.ELECTRUM) then
		local rng = player:GetTrinketRNG(mod.ITEM.ROCK.ELECTRUM)
		local mult = mod.GetGolemTrinketPower(player, mod.ITEM.ROCK.ELECTRUM)
		local itemConfig = Isaac:GetItemConfig():GetCollectible(mod.ITEM.COLLECTIBLE.GAPER_IN_A_JAR)
		mod:electrumShock(player, mult, rng, itemConfig)
	end

	SetJarSlot(player, slot, nil)

	if player:GetActiveItem(slot) == mod.ITEM.COLLECTIBLE.GAPER_IN_A_JAR then
		local pData = mod:GetEntityData(player)
		for i=1, numProjectiles do
			mod:ExcelsiorActiveLogic(player, pData, mod.ITEM.COLLECTIBLE.GAPER_IN_A_JAR, UseFlag.USE_OWNED, slot)
		end
		if player:GetActiveCharge() > 0 then
			player:DischargeActiveItem(slot)
		elseif player:HasCollectible(mod.ITEM.COLLECTIBLE.DADS_BATTERY) then
			mod:addChargeDebt(player, pData, slot, 1)
		end

		if hasEternalCarBattery then
			if mod:RandomFloat() < 0.5 then
				player:RemoveCollectible(mod.ITEM.COLLECTIBLE.GAPER_IN_A_JAR, false, slot, false)
				if not FiendFolio.ACHIEVEMENT.CORRUPTION:IsUnlocked(true) then
					FiendFolio.ACHIEVEMENT.CORRUPTION:Unlock()
				end
			end
			game:ShakeScreen(15)
		end
	end
end

-- Called from "...\ffscripts\erfly\main.lua"
-- Thanks again Erfly for the "held up" active item functionality!
function mod:useGaperInAJar(player, aim, slot)
	if not slot then return end
	
	if GetJarSlot(player, slot) then
		GaperInAJarThrow(player, aim, slot)
	else
		GaperInAJarSwing(player, aim, slot)
	end
end

local function GaperInAJarEidModifierCondition(descObj)
	if descObj and descObj.ObjType == EntityType.ENTITY_PICKUP
			and descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE
			and descObj.ObjSubType == mod.ITEM.COLLECTIBLE.GAPER_IN_A_JAR then
		return true
	end
	return false
end

local function GaperInAJarEidModifierCallback(descObj)
	local ent = descObj.Entity
	if ent and ent.Type == EntityType.ENTITY_PICKUP
			and ent.Variant == PickupVariant.PICKUP_COLLECTIBLE
			and ent.SubType == mod.ITEM.COLLECTIBLE.GAPER_IN_A_JAR then
		local jarContents = GetDroppedJarData()[""..ent.InitSeed]
		local name = GetJarName(jarContents)
		descObj.Name = name
	end
	return descObj
end

if EID then
	EID:addDescriptionModifier("ffGaperInAJarModifier", GaperInAJarEidModifierCondition, GaperInAJarEidModifierCallback)
end

-- Retrieves jar contents from a touched item pedestal.
-- This is now mainly fallback logic, since most cases should be caught by the rgon callbacks.
local function RetrieveDroppedJarContents()
	local droppedJarData = GetDroppedJarData()

	for key, droppedJarContents in pairs(droppedJarData) do
		if droppedJarContents.LastTouched and game:GetFrameCount() - droppedJarContents.LastTouched <= 1 then
			droppedJarData[key] = nil
			return {
				Contents = droppedJarContents,
				SpriteData = GetJarSpriteForPedestal(key, true),
			}
		end
	end
end

-- Handle the player swapping the contents of the jar between primary/secondary slots (ie, with schoolbag).
-- This doesn't catch every instance (only the ones manually triggered by the player), but we'll handle other cases as best we can.
mod:AddPriorityCollectibleCallback(ModCallbacks.MC_PRE_PLAYER_POCKET_ITEMS_SWAP, CallbackPriority.LATE, mod.ITEM.COLLECTIBLE.GAPER_IN_A_JAR, function(_, player)
	local primary = player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)
	local secondary = player:GetActiveItem(ActiveSlot.SLOT_SECONDARY)

	if primary > 0 and secondary > 0 and (primary == mod.ITEM.COLLECTIBLE.GAPER_IN_A_JAR or secondary == mod.ITEM.COLLECTIBLE.GAPER_IN_A_JAR) then
		SwapJarData(player)
	end
end)

-- Remove the jar contents from the given slot, and see if we can move them to a nearby item pedestal.
local function TryDropJarContents(player, slot)
	local jarContents = GetJarSlot(player, slot)

	if not jarContents then return end

	mod.scheduleForUpdate(function()
		local droppedJarData = GetDroppedJarData()

		-- Check if it was placed onto an item pedestal...
		local nearestPedestal, nearestDist
		for _, pedestal in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, mod.ITEM.COLLECTIBLE.GAPER_IN_A_JAR)) do
			local dist = pedestal.Position:Distance(player.Position)
			if not droppedJarData[""..pedestal.InitSeed] and (not nearestDist or dist < nearestDist) then
				nearestPedestal = pedestal
				nearestDist = dist
			end
		end

		if nearestPedestal then
			-- Save the contents of the jar for this specific item pedestal.
			droppedJarData[""..nearestPedestal.InitSeed] = jarContents
			SetJarSpriteForPedestal(nearestPedestal.InitSeed, GetJarSprite(player, slot))
		end
	end, 0)

	-- Regardless, clear the contents for this slot.
	SetJarSlot(player, slot, nil)
end

-- Check the jars currently held by the player. Move contents if necessary. Track whether we're currently holding jars in each slot.
function mod:CheckCurrentGaperJars(player)
	local playerData = mod:GetEntityData(player)

	local hasJarPrimary = HasJarInSlot(player, ActiveSlot.SLOT_PRIMARY)
	local hasJarSecondary = HasJarInSlot(player, ActiveSlot.SLOT_SECONDARY)
	local hasJarPocket = HasJarInSlot(player, ActiveSlot.SLOT_POCKET)

	local hasPrimaryJarContents = GetJarSlot(player, ActiveSlot.SLOT_PRIMARY)
	local hasSecondaryJarContents = GetJarSlot(player, ActiveSlot.SLOT_SECONDARY)

	-- If we didn't notice the active items get swapped, move the contents here.
	if hasJarPrimary and not hasJarSecondary and not hasPrimaryJarContents and hasSecondaryJarContents then
		SwapJarData(player)
	elseif not hasJarPrimary and hasJarSecondary and hasPrimaryJarContents and not hasSecondaryJarContents then
		SwapJarData(player)
	end

	playerData.ffHadGaperJar = {
		[ActiveSlot.SLOT_PRIMARY] = hasJarPrimary,
		[ActiveSlot.SLOT_SECONDARY] = hasJarSecondary,
		[ActiveSlot.SLOT_POCKET] = hasJarPocket,
	}

	-- Remove any jar content somehow left in an invalid slot.
	for slot=0,2 do
		local jarContents = GetJarSlot(player, slot)
		if jarContents and not HasJarInSlot(player, slot) then
			TryDropJarContents(player, slot)
		end
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.ITEM.COLLECTIBLE.GAPER_IN_A_JAR, mod.CheckCurrentGaperJars)

-- When a jar is added, attempt to load its contents from elsewhere, or initialize appropriately.
function mod:HandleAddedGaperInAJar(id, charge, firstTime, slot, varData, player)
	if slot > -1 and player:GetActiveItem(slot) == mod.ITEM.COLLECTIBLE.GAPER_IN_A_JAR then
		if slot == ActiveSlot.SLOT_PRIMARY and player:GetActiveItem(ActiveSlot.SLOT_SECONDARY) == mod.ITEM.COLLECTIBLE.GAPER_IN_A_JAR then
			-- The player picked up a second jar, so the contents should have moved.
			SwapJarData(player)
		end

		local jarContents = GetJarSlot(player, slot)

		if not jarContents then
			local jarData = GetJarData(player)

			-- Newly aquired jar. If pre-existing contents have been queued, apply them here.
			if jarData.queuedJarContents then
				if jarData.queuedJarContents.Contents then
					-- There are queued contents. Add them.
					SetJarSlot(player, slot, jarData.queuedJarContents.Contents, jarData.queuedJarContents.SpriteData)
				end
				jarData.queuedJarContents = nil
			else
				-- Nothing is queued, so see if we can retrieve contents from a touched item pedestal.
				local retrieved = RetrieveDroppedJarContents()
				if retrieved then
					SetJarSlot(player, slot, retrieved.Contents, retrieved.SpriteData)
				elseif firstTime then
					SetJarSlot(player, slot, GetDefaultJarContents())
				end
			end
		end
	end

	mod:CheckCurrentGaperJars(player)
	game:GetHUD():PostUpdate()
end
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.HandleAddedGaperInAJar, mod.ITEM.COLLECTIBLE.GAPER_IN_A_JAR)

-- When a jar is removed, try to determine which slot it was dropped from, and handle appropriately.
function mod:HandleRemovedGaperInAJar(player)
	local playerData = mod:GetEntityData(player)

	local removedSlot = nil

	if playerData.ffHadGaperJar then
		-- Special handling for when the player was holding two jars, since you'll typically drop the primary one and the secondary one moves into its spot instantly.
		if playerData.ffHadGaperJar[ActiveSlot.SLOT_PRIMARY] and playerData.ffHadGaperJar[ActiveSlot.SLOT_SECONDARY]
		and HasJarInSlot(player, ActiveSlot.SLOT_PRIMARY) and not HasJarInSlot(player, ActiveSlot.SLOT_SECONDARY) then
			removedSlot = ActiveSlot.SLOT_PRIMARY
		else
			for slot=0,2 do
				if playerData.ffHadGaperJar[slot] and not HasJarInSlot(player, slot) then
					removedSlot = slot
					break
				end
			end
		end
	end

	if removedSlot then
		TryDropJarContents(player, removedSlot)
	end

	mod:CheckCurrentGaperJars(player)
end
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, mod.HandleRemovedGaperInAJar, mod.ITEM.COLLECTIBLE.GAPER_IN_A_JAR)

-- Pre collision with a player: Track when last touched and whether the colliding player's item queue is empty.
function mod:GaperJarPrePedestalCollision(pedestal, collider)
	if pedestal.SubType == mod.ITEM.COLLECTIBLE.GAPER_IN_A_JAR then
		local player = collider:ToPlayer()
		if player then
			local jarContents = GetDroppedJarData()[""..pedestal.InitSeed]
			if jarContents then
				jarContents.LastTouched = game:GetFrameCount()
			end
			mod:GetEntityData(pedestal).gaperJarPrePickup = player.QueuedItem.Item == nil
		end
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, CallbackPriority.EARLY, mod.GaperJarPrePedestalCollision, PickupVariant.PICKUP_COLLECTIBLE)

-- Post collision with a player: If the jar was added to the queue, move the contents appropriately.
function mod:GaperJarPostPedestalCollision(pedestal, collider)
	local data = mod:GetEntityData(pedestal)

	if data.gaperJarPrePickup then
		local player = collider:ToPlayer()
		if player then
			local queuedItem = player.QueuedItem.Item
			if queuedItem and queuedItem:IsCollectible() and queuedItem.ID == mod.ITEM.COLLECTIBLE.GAPER_IN_A_JAR then
				local droppedJarData = GetDroppedJarData()
				local key = ""..pedestal.InitSeed
				local jarContents = droppedJarData[key]

				if jarContents and jarContents.LastTouched == game:GetFrameCount() then
					-- Move the jar contents into the queue.
					droppedJarData[key] = nil

					GetJarData(player).queuedJarContents = {
						Contents = jarContents,
						SpriteData = GetJarSpriteForPedestal(key, true),
					}
					mod:GetEntityData(player).hasQueuedGaperJar = true
				end

				-- Fake changing the item's name.
				local name, desc = GetJarName(jarContents)
				game:GetHUD():ShowItemText(name, desc)
			end
		end

		data.gaperJarPrePickup = nil
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, mod.GaperJarPostPedestalCollision, PickupVariant.PICKUP_COLLECTIBLE)

--------------------------------------------------
-- DETECT NEWLY SPAWNED JARS

local jarLastPickedFromPool
local jarLastSpawned

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
	jarLastPickedFromPool = nil
	jarLastSpawned = nil
end)

--[[mod:AddCallback(ModCallbacks.MC_PRE_GET_COLLECTIBLE, function()
	if jarLastPickedFromPool == nil then
		jarLastPickedFromPool = game:GetFrameCount()
		return mod.ITEM.COLLECTIBLE.GAPER_IN_A_JAR
	end
end)]]

mod:AddPriorityCallback(ModCallbacks.MC_POST_GET_COLLECTIBLE, CallbackPriority.EARLY, function(_, itemType)
	if itemType == mod.ITEM.COLLECTIBLE.GAPER_IN_A_JAR then
		jarLastPickedFromPool = game:GetFrameCount()
	end
end)

function mod:GaperJarPreSpawn(id, variant, subType)
	jarLastSpawned = game:GetFrameCount()
end

function mod:GaperJarPreRoomSpawn(id, variant, subType)
	if id == EntityType.ENTITY_PICKUP and variant == PickupVariant.PICKUP_COLLECTIBLE and subType == mod.ITEM.COLLECTIBLE.GAPER_IN_A_JAR then
		jarLastSpawned = game:GetFrameCount()
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_ROOM_ENTITY_SPAWN, mod.GaperJarPreRoomSpawn)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pedestal)
	if pedestal.SubType == mod.ITEM.COLLECTIBLE.GAPER_IN_A_JAR then
		local currentFrame = game:GetFrameCount()
		if jarLastPickedFromPool == currentFrame or (jarLastSpawned == currentFrame and game:GetRoom():GetFrameCount() > -1) then
			GetDroppedJarData()[""..pedestal.InitSeed] = GetDefaultJarContents()
		end
	end
end, PickupVariant.PICKUP_COLLECTIBLE)

--------------------------------------------------
-- "THROWN ENEMY" PROJECTILE CODE

mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_RENDER, function(_, proj, renderOffset)
	local data = mod:GetEntityData(proj)
	local projData = data.ffGaperJarProjData
	local spriteData = data.ffGaperJarSpriteData

	if not projData or not spriteData then return end

	local currentFrame = Isaac.GetFrameCount()
	if not game:IsPaused() and (data.ffGaperJarProjLastRender or 0) < currentFrame then
		data.ffGaperJarProjRotation = (data.ffGaperJarProjRotation or 0) + THROWN_SPIN_SPEED * (proj.Velocity.X < 0 and -1 or 1)
		data.ffGaperJarProjLastRender = currentFrame
	end

	local rot = (data.ffGaperJarProjRotation or 0) % 360

	local spriteDims = spriteData.Dimensions

	if spriteData.EnemyImage then
		local src = spriteData.EnemyQuad
		local mid = Vector(spriteDims.Width, spriteDims.Height) * 0.5
		local pos = Isaac.WorldToScreen(proj.Position + Vector(0, proj.Height)) + renderOffset - game:GetRoom():GetRenderScrollOffset()
		local dst = DestinationQuad(src:GetTopLeft(), src:GetTopRight(), src:GetBottomLeft(), src:GetBottomRight())
		dst:Translate(pos - mid)
		dst:Rotate(rot, pos)
		spriteData.EnemyImage:Render(src, dst, KCOLOR_DEFAULT)
		return false
	else
		local spr = proj:GetSprite()
		spr.Rotation = rot
		spr.Offset = (spriteDims.MidPoint * -1 * (projData.Scale or 1)):Rotated(rot)
	end
end, mod.FF.GaperInAJarProjectile.Var)

mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, function(_, proj)
	local projData = mod:GetEntityData(proj).ffGaperJarProjData

	if not projData then return end

	if proj:CollidesWithGrid() then
		proj:Kill()
	end

	if projData.Color then
		proj.Color = projData.Color
	end
end, mod.FF.GaperInAJarProjectile.Var)

mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_DEATH, function(_, proj)
	local projData = mod:GetEntityData(proj).ffGaperJarProjData

	if not projData then return end

	local id = projData.Type
	local var = projData.Variant
	local subt = projData.SubType

	if DeathEffectBlacklisted(id, var, subt) then
		id = EntityType.ENTITY_GUSHER
		var = 1
		subt = 0
	end

	local thrownEnemy = Isaac.Spawn(id, var, subt, proj.Position, VECTOR_ZERO, nil):ToNPC()
	thrownEnemy:AddCharmed(EntityRef(Isaac.GetPlayer()), -1)
	thrownEnemy.Scale = projData.Scale
	thrownEnemy.MaxHitPoints = projData.HP
	if projData.Color then
		thrownEnemy.Color = projData.Color
	end
	thrownEnemy:SetColor(Color(0,0,0,0), 2, 999, false, false)
	thrownEnemy:Kill()
	thrownEnemy:Update()
	if not thrownEnemy:IsDead() then
		thrownEnemy:Kill()
		thrownEnemy:Update()
		for _, eff in pairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.POOF01)) do
			if eff.FrameCount == 0 and eff.Position:Distance(proj.Position) < 1 then
				eff:Remove()
			end
		end
	end
	if not thrownEnemy:IsDead() then
		thrownEnemy:Remove()
	end

	for _, fly in pairs(Isaac.FindByType(EntityType.ENTITY_ETERNALFLY)) do
		if fly.FrameCount == 0 then
			fly:Remove()
		end
	end

	for _, eff in pairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.BULLET_POOF)) do
		if eff.FrameCount == 0 and eff.Position:Distance(proj.Position) < 1 then
			eff:Remove()
		end
	end

	for _, tear in pairs(Isaac.FindByType(EntityType.ENTITY_TEAR)) do
		tear = tear:ToTear()
		if tear.FrameCount == 0 and tear:HasTearFlags(TearFlags.TEAR_CHARM) then
			tear:ToTear():ClearTearFlags(TearFlags.TEAR_CHARM)
			if tear.Color.R == 1 and tear.Color.G == 0 and tear.Color.B == 1 then
				tear.Color = Color(1,1,1,1)
			end
		end
	end
end, mod.FF.GaperInAJarProjectile.Var)

--------------------------------------------------
-- RENDERING STUFF

-- Remnants of legacy rendering.
local function RenderJarSprite(jarSpriteData, pos, offset, scale, alpha)
	local sprite = jarSpriteData.Sprite
	local dims = jarSpriteData.Dimensions

	if not sprite or not dims then return end

	local jarScale = dims and (32 / math.max(dims.Width, dims.Height)) * 0.4 or 1
	local jarOffset = dims and Vector(0, 2) - Vector(dims.MidPoint.X  * jarScale, dims.MidPoint.Y * jarScale) or VECTOR_ZERO

	scale = scale or VECTOR_ONE
	offset = offset or VECTOR_ZERO

	sprite.Color.A = alpha or 1
	sprite.Scale = jarScale * scale
	sprite.Offset = (jarOffset + offset) * scale
	sprite:Render(pos)
end

local ITEM_SPRITE_QUAD = DestinationQuad(Vector(0, 0), Vector(32, 0), Vector(0, 32), Vector(32, 32))

local function RenderJarImage(jarSpriteData, pos, scale, pivot)
	local dst = ITEM_SPRITE_QUAD:Copy()
	dst:Translate(pos)
	-- The second param for Scale is a render-space point to use as the pivot when scaling.
	-- Using the Pivot of the anm2 frame we are rendering on top of, we can replicate the squish and stretch.
	dst:Scale(scale, pos + pivot)
	jarSpriteData.JarImage:Render(jarSpriteData.JarQuad, dst, KCOLOR_DEFAULT)
end

-- Renders the jar silhouette on top of the given jar sprite (ie, `pickup:GetSprite()` or `player:GetHeldSprite()`).
local function RenderOverJarSprite(pos, sprite, layer, jarSpriteData)
	local layerState = sprite:GetLayer(layer)
	local animData = sprite:GetCurrentAnimationData()
	local layerData = animData and animData:GetLayer(layer)
	local frameData = layerData and layerData:GetFrame(sprite:GetFrame())
	if layerState and frameData then
		local scale = frameData:GetScale()
		local pivot = frameData:GetPivot()
		local offset = sprite.Offset + frameData:GetPos() + layerState:GetPos() - pivot
		if jarSpriteData.JarImage then
			RenderJarImage(jarSpriteData, pos + offset, scale, pivot)
		else
			RenderJarSprite(jarSpriteData, pos, offset + Vector(16, 16), scale, sprite.Color.A)
		end
		return offset
	end
end

function mod:GaperJarPickupRender(pedestal)
	if pedestal.SubType ~= mod.ITEM.COLLECTIBLE.GAPER_IN_A_JAR or game:GetLevel():GetCurses() & LevelCurse.CURSE_OF_BLIND ~= 0 or pedestal:IsBlind() then return end

	local jarContents = GetDroppedJarData()[""..pedestal.InitSeed]

	if not jarContents then return end

	local jarSpriteData = GetJarSpriteForPedestal(pedestal.InitSeed)

	if jarSpriteData then
		RenderOverJarSprite(Isaac.WorldToScreen(pedestal.Position), pedestal:GetSprite(), 1, jarSpriteData)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_RENDER, mod.GaperJarPickupRender, PickupVariant.PICKUP_COLLECTIBLE)

local function RenderHeldUpJar(player, jarSpriteData, renderOffset, slot)
	if jarSpriteData and player:IsFullSpriteRendering() then
		local heldSprite = player:GetHeldSprite()
		local heldLayer = heldSprite:GetLayer(1)

		if heldLayer and heldLayer:GetSpritesheetPath() == "gfx/items/collectibles/collectibles_gaper_in_a_jar.png" then
			local pos = Isaac.WorldToScreen(player.Position) + renderOffset + player:GetFlyingOffset() - game:GetRoom():GetRenderScrollOffset()
			local offset = RenderOverJarSprite(pos, heldSprite, 1, jarSpriteData)
			if slot and offset then
				mod:RenderExcelsiorSparkles(player, slot, pos + offset, 1, 1, VECTOR_ZERO)
			end
		end
	end
end

function mod:GaperInAJarUsingRender(player, renderOffset)
	local pData = mod:GetEntityData(player)
	local usingSlot = pData.holdingFFItemSlot or pData.previousHeldGaperJarSlot
	if usingSlot and player:IsHoldingItem() and (pData.holdingFFItem == mod.ITEM.COLLECTIBLE.GAPER_IN_A_JAR or pData.previousHeldGaperJarSlot) then
		local jarSpriteData = GetJarSprite(player, usingSlot)
		RenderHeldUpJar(player, jarSpriteData, renderOffset, usingSlot)
	else
		pData.previousHeldGaperJarSlot = nil
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PLAYER_RENDER, mod.ITEM.COLLECTIBLE.GAPER_IN_A_JAR, mod.GaperInAJarUsingRender)

function mod:GaperInAJarQueuedRander(player, pData, renderOffset)
	if pData.hasQueuedGaperJar then
		if player:IsHoldingItem() then
			local jarData = GetJarData(player)
			local queuedItem = player.QueuedItem.Item

			if queuedItem and queuedItem:IsCollectible() and queuedItem.ID == mod.ITEM.COLLECTIBLE.GAPER_IN_A_JAR and jarData.queuedJarContents then
				RenderHeldUpJar(player, jarData.queuedJarContents.SpriteData, renderOffset)
				return
			end
		end
		pData.hasQueuedGaperJar = nil
	end
end

function mod:GaperInAJarHudRender(player, slot, renderPos, alpha, scale, chargeBarPos)
	local jarSpriteData = GetJarSprite(player, slot)

	if jarSpriteData then
		renderPos = renderPos + game.ScreenShakeOffset
		if jarSpriteData.JarImage then
			RenderJarImage(jarSpriteData, renderPos, Vector(scale, scale), VECTOR_ZERO)
		else
			RenderJarSprite(jarSpriteData, renderPos, Vector(16, 16), Vector(scale, scale), alpha)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYERHUD_RENDER_ACTIVE_ITEM, mod.GaperInAJarHudRender, mod.ITEM.COLLECTIBLE.GAPER_IN_A_JAR)
