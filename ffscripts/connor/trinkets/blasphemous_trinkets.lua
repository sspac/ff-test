local mod = FiendFolio
local game = Game()

local BLASPHEMOUS_TRINKET_CHANCE = 0.02

local BLASPHEMOUS_SHADER_NAME = "shaders/fiendfolio/coloroffset_blasphemous"
--[[
local fmt = Renderer.VertexAttributeFormat
mod.BLASPHEMOUS_SHADER = Renderer.LoadShader(BLASPHEMOUS_SHADER_NAME, {
	{"Position", fmt.POSITION},
	{"Color", fmt.COLOR},
	{"TexCoord", fmt.TEX_COORD},
	{"ColorizeIn", fmt.VEC4},
	{"ColorOffsetIn", fmt.VEC3},
	{"TextureSize", fmt.VEC2},
	{"PixelationAmount", fmt.FLOAT},
	{"ClipPlane", fmt.VEC3},
})
]]
local ALLOW_GOLDEN_STACKING = true

function mod:HasBlasphemousShader(sprite)
	return sprite:HasCustomShader(BLASPHEMOUS_SHADER_NAME)
end

function mod:AddBlasphemousShader(sprite)
	sprite:SetCustomShader(BLASPHEMOUS_SHADER_NAME)
end

function mod:RemoveBlasphemousShader(sprite)
	sprite:ClearCustomShader()
	sprite.Color:SetColorize(1,1,1,0)
end

local function AllowBlasphemousTrinket(id)
	return id > 0 and (ALLOW_GOLDEN_STACKING or id <= TrinketType.TRINKET_ID_MASK)
end

function mod:MakePickupTrinketBlasphemous(pickup)
	if pickup.Type == EntityType.ENTITY_PICKUP and pickup.Variant == PickupVariant.PICKUP_TRINKET and AllowBlasphemousTrinket(pickup.SubType) then
		local trackedTrinket = mod.TrinketTracker:GetDataForPickup(pickup, true)
		trackedTrinket.Data.IsBlasphemousTrinket = true
	end
end

function mod:IsPickupTrinketBlasphemous(pickup)
	if pickup.Type == EntityType.ENTITY_PICKUP and pickup.Variant == PickupVariant.PICKUP_TRINKET and AllowBlasphemousTrinket(pickup.SubType) then
		local trackedTrinket = mod.TrinketTracker:GetDataForPickup(pickup)
		if trackedTrinket and trackedTrinket.Data.IsBlasphemousTrinket then
			return true
		end
	end
end

function mod:TriggerBlasphemousDamageCache(player)
	player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
	if player:GetPlayerType() == mod.PLAYER.BRIEND and not mod:IsBriendTwin(player) then
		player:GetOtherTwin():AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
	end
end

function mod:MakePlayerTrinketBlasphemous(player, slot)
	if AllowBlasphemousTrinket(player:GetTrinket(slot)) then
		local trackedTrinket = mod.TrinketTracker:GetDataForPlayerSlot(player, slot, true)
		trackedTrinket.Data.IsBlasphemousTrinket = true
		mod:TriggerBlasphemousDamageCache(player)
	end
end

function mod:IsPlayerTrinketBlasphemous(player, slot)
	if AllowBlasphemousTrinket(player:GetTrinket(slot)) then
		local trackedTrinket = mod.TrinketTracker:GetDataForPlayerSlot(player, slot, true)
		if trackedTrinket and trackedTrinket.Data.IsBlasphemousTrinket then
			return true
		end
	end
end

function mod:IsQueuedTrinketBlasphemous(player)
	local trackedTrinket = mod.TrinketTracker:GetDataForPlayerQueue(player)
	if trackedTrinket and AllowBlasphemousTrinket(trackedTrinket.Type) and trackedTrinket.Data.IsBlasphemousTrinket then
		return true
	end
end

function mod:PlayerHasBlasphemousTrinket(player, includeQueue, trinket)
	return mod.TrinketTracker:QueryPlayer(player, function(trackedTrinket)
		if AllowBlasphemousTrinket(trackedTrinket.Type) and trackedTrinket.Data.IsBlasphemousTrinket then
			return true
		end
	end, includeQueue, trinket)
end

-- Finds the single most recent smelted trinket matching the given trinketType (and optional gulpTime) and makes it Blasphemous if it is not already.
function mod:MakeLatestSmeltedTrinketBlasphemous(player, trinketType, gulpTime, ignoreGoldenState)
	if AllowBlasphemousTrinket(trinketType) then
		local trackedTrinket = mod.TrinketTracker:GetDataForPlayerSmelted(player, trinketType, gulpTime, ignoreGoldenState, true)[1]
		if trackedTrinket and not trackedTrinket.Data.IsBlasphemousTrinket then
			trackedTrinket.Data.IsBlasphemousTrinket = true
			mod:TriggerBlasphemousDamageCache(player)
			mod:RefreshHistoryHUD()
		end
	end
end

mod:AddCallback(mod.TrinketTracker.Callbacks.PLAYER_TRINKET_ADDED, function(_, player, trackedTrinket, oldLocation)
	if trackedTrinket.Data.IsBlasphemousTrinket then
		mod:TriggerBlasphemousDamageCache(player)
	end
end)

-- Sync all TrinketTracker data between Briend twins. The data of one of the copies will just be lost if the trinket is dropped, since only one trinket gets dropped.
-- This should be fine, though this can possibly be moved to Briend's file or cleaned up once I get around to updating the TrinketTracker.
mod:AddPriorityCallback(mod.TrinketTracker.Callbacks.PLAYER_TRINKET_ADDED, CallbackPriority.EARLY, function(_, player, trackedTrinket, oldLocation)
	if player:GetPlayerType() ~= mod.PLAYER.BRIEND then return end

	local otherTwin = player:GetOtherTwin()

	if otherTwin and not trackedTrinket.Data.BriendSynced then
		local fromSlot, toSlot
		for i=0,1 do
			if not fromSlot and player:GetTrinket(i) == trackedTrinket.Type then
				fromSlot = i
			end
			if not toSlot and otherTwin:GetTrinket(i) == trackedTrinket.Type then
				toSlot = i
			end
		end

		if fromSlot and toSlot then
			local twinTrackedTricket = mod.TrinketTracker:GetDataForPlayerSlot(otherTwin, toSlot, true)
			for k,v in pairs(StageAPI.DeepCopy(trackedTrinket.Data)) do
				twinTrackedTricket.Data[k] = v
			end
			trackedTrinket.Data.BriendSynced = true
			twinTrackedTricket.Data.BriendSynced = true
			Isaac.RunCallbackWithParam(mod.TrinketTracker.Callbacks.PLAYER_TRINKET_ADDED, twinTrackedTricket.Type, otherTwin, twinTrackedTricket, oldLocation)
		end
	end
end)

mod:AddCallback(mod.TrinketTracker.Callbacks.PLAYER_TRINKET_REMOVED, function(_, player, trackedTrinket, oldLocation)
	if trackedTrinket.Data.IsBlasphemousTrinket then
		mod:TriggerBlasphemousDamageCache(player)
	end
end)

mod:AddCallback(mod.TrinketTracker.Callbacks.PLAYER_EVALUATE_TRINKET, function(_, player, trackedTrinket, cacheFlag)
	if trackedTrinket.Data.IsBlasphemousTrinket then
		player.Damage = player.Damage + 1
	end
end, CacheFlag.CACHE_DAMAGE)

function mod:UpdateBlasphemousTrinket(pickup)
	local sprite = pickup:GetSprite()
	local trackedTrinket = mod.TrinketTracker:GetDataForPickup(pickup)
	if mod:HasBlasphemousShader(sprite) and (not trackedTrinket or not trackedTrinket.Data.IsBlasphemousTrinket) then
		mod:RemoveBlasphemousShader(sprite)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.UpdateBlasphemousTrinket, PickupVariant.PICKUP_TRINKET)

function mod:GetNumBlasphemousTrinkets(player)
	local count = 0
	mod.TrinketTracker:QueryPlayer(player, function(trackedTrinket)
		if trackedTrinket.Data.IsBlasphemousTrinket then
			count = count + 1
		end
	end)
	local pennies = player:GetInnateTrinketGroup("PENNY_ALBUM_BLASPHEMOUS")
	for pennyID, amount in pairs(pennies) do
		count = count + amount
	end
	return count
end

local BLASPHEMOUS_OUTLINE_RED = 200/255

function mod:PreRenderBlasphemousShader(sprite, pos)
	if not game:IsPaused() then
		local color = sprite.Color
		color:SetColorize(1,1,1, (color:GetColorize().A + 0.001) % 1)
	end
	-- Renders the red outline
	local color = Color.Lerp(sprite.Color, Color.Default, 0)  -- copy
	local alpha = color.A
	local flags = sprite:GetRenderFlags()
	sprite:SetRenderFlags(sprite:GetRenderFlags() & ~AnimRenderFlags.GOLDEN)
	sprite.Color:SetTint(0,0,0, alpha)
	sprite.Color:SetOffset(BLASPHEMOUS_OUTLINE_RED, 0, 0)
	local offset = Vector(sprite.Offset.X, sprite.Offset.Y)
	local scale = sprite.Scale
	for _, offsetoffset in pairs({Vector(1,0), Vector(0,1), Vector(-1,0), Vector(0,-1)}) do
		sprite.Offset = offset + offsetoffset * scale
		sprite:Render(pos)
	end
	sprite.Offset = offset
	sprite.Color = color
	sprite:SetRenderFlags(flags)
end

local IMAGE_SIZE = 256
local IMAGE_CENTER = 0.5 * Vector(IMAGE_SIZE, IMAGE_SIZE)
local OUT_SIZE = 128
local OUT_CENTER = 0.5 * Vector(OUT_SIZE, OUT_SIZE)
local SOURCE_QUAD = SourceQuad(Vector(0,0), Vector(IMAGE_SIZE,0), Vector(0,IMAGE_SIZE), Vector(IMAGE_SIZE,IMAGE_SIZE))
local DESTINATION_QUAD = DestinationQuad(Vector(0,0), Vector(OUT_SIZE,0), Vector(0,OUT_SIZE), Vector(OUT_SIZE,OUT_SIZE))
local RENDER_COLOR = KColor(1,1,1,1)
local IMAGE = Renderer.CreateImage(IMAGE_SIZE, IMAGE_SIZE, "FF_BLASPHEMOUS_TRINKET")

mod:AddCallback(mod.TrinketTracker.Callbacks.PRE_RENDER_TRINKET, function(_, sprite, pos, trackedTrinket)
	local entity = trackedTrinket.Location.Entity and trackedTrinket.Location.Entity.Ref
	if trackedTrinket.Data.IsBlasphemousTrinket and (not entity or not mod:GetEntityData(entity).BlasphemousTransform) then
		if not mod:HasBlasphemousShader(sprite) then
			mod:AddBlasphemousShader(sprite)
		end

		local a = sprite.Color.A
		sprite.Color.A = 1
		local offset = Vector(sprite.Offset.X, sprite.Offset.Y)
		sprite.Offset = offset * 2
		local scale = Vector(sprite.Scale.X, sprite.Scale.Y)
		sprite.Scale = scale * 2

		local sparkleLayer = sprite:GetLayer("sparkle")
		local sparkleColor = nil
		Renderer.RenderToImage(IMAGE, function(controller)
			controller:Clear()
			if sparkleLayer then
				sparkleColor = sparkleLayer:GetColor()
				sparkleLayer:SetColor(Color(0,0,0,1,BLASPHEMOUS_OUTLINE_RED))
				sprite:RenderLayer(1, IMAGE_CENTER)
				sparkleLayer:SetVisible(false)
			end
			mod:PreRenderBlasphemousShader(sprite, IMAGE_CENTER)
			sprite:Render(IMAGE_CENTER)
		end)
		if sparkleLayer then
			sparkleLayer:SetColor(sparkleColor)
			sparkleLayer:SetVisible(true)
		end

		sprite.Color.A = a
		sprite.Offset = offset
		sprite.Scale = scale

		local dst = DESTINATION_QUAD:Copy()
		dst:Translate(pos - OUT_CENTER)
		RENDER_COLOR.Alpha = a
		IMAGE:Render(SOURCE_QUAD, dst, RENDER_COLOR)

		return true
	end
end)

-- Rough fix for AnimateTrinket
mod:AddPriorityCallback(ModCallbacks.MC_PRE_PLAYER_RENDER, CallbackPriority.LATE, function(_, player, renderOffset)
	local d = mod:GetEntityData(player)
	local sprite = player:GetHeldSprite()
	if mod:HasBlasphemousShader(sprite) and not mod:IsQueuedTrinketBlasphemous(player) then
		local frame = sprite:GetFrame()
		-- TODO: the IsVisible check is primarily for the outline being rendered onto the room transition. Could probably be handled better.
		-- TODO: Add something to repentogon to better handle new animations starting (preferably, the custom shaders should not be retained, I think thats swapanm2)
		-- also could probably use more extra anim support
		if not player:IsVisible() or player:IsExtraAnimationFinished() or 
		   ((frame < (d.BlasphemousHeldSpriteFrame or 0) or not player:IsHeldItemVisible()) and not (mod:IsQueuedTrinketBlasphemous(player) or d.mammoniteRockTP))
		then
			mod:RemoveBlasphemousShader(sprite)
			d.BlasphemousHeldSpriteFrame = nil
			return
		end
		local renderPos = Isaac.WorldToScreen(player.Position) + renderOffset + player:GetFlyingOffset() - game:GetRoom():GetRenderScrollOffset()
		mod:PreRenderBlasphemousShader(sprite, renderPos)
		d.BlasphemousHeldSpriteFrame = frame
	elseif d.BlasphemousHeldSpriteFrame then
		d.BlasphemousHeldSpriteFrame = nil
	end
end)

-- lol
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_RENDER, function(_, pickup, renderOffset)
	local sprite = pickup:GetSprite()
	if pickup.Variant ~= PickupVariant.PICKUP_TRINKET and mod:HasBlasphemousShader(sprite) and pickup:IsVisible() then
		local renderPos = Isaac.WorldToScreen(pickup.Position) + renderOffset + - game:GetRoom():GetRenderScrollOffset()
		mod:PreRenderBlasphemousShader(sprite, renderPos)
	end
end)


-- Detect newly spawned trinkets to potentially convert to blasphemous ones.
local spawnedTrinket = -1

function mod:detectTrinketSpawn(eType, eVariant, eSubType, pos, vel, spawner, seed)
	spawnedTrinket = seed
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
	if pickup.InitSeed == spawnedTrinket and mod.ACHIEVEMENT.BLASPHEMOUS_TRINKETS:IsUnlocked() and pickup.Variant == PickupVariant.PICKUP_TRINKET
			and AllowBlasphemousTrinket(pickup.SubType) and pickup.SubType <= TrinketType.TRINKET_ID_MASK then
		local rng = RNG()
		rng:SetSeed(pickup.InitSeed + game:GetSeeds():GetStartSeed(), 35)
		if rng:RandomFloat() < BLASPHEMOUS_TRINKET_CHANCE then
			mod:MakePickupTrinketBlasphemous(pickup)
		end
	end
	spawnedTrinket = -1
end, PickupVariant.PICKUP_TRINKET)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	spawnedTrinket = -1
end)