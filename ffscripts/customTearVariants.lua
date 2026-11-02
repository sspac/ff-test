-----------------------------------------------------------
-- Custom tear variants
-----------------------------------------------------------

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

-----------------------------------------------------------
-- Constants
-----------------------------------------------------------

-- Priorities used for changing the variants of tears
mod.TearVariantPriority = {
	-- Technical and other important variants; never overwritten
	[TearVariant.BOBS_HEAD] = 99999,
	[TearVariant.CHAOS_CARD] = 99999,
	[TearVariant.STONE] = 99999,
	[TearVariant.MULTIDIMENSIONAL] = 99999,
	[TearVariant.BELIAL] = 99999,
	[TearVariant.BALLOON] = 99999,
	[TearVariant.BALLOON_BRIMSTONE] = 99999,
	[TearVariant.BALLOON_BOMB] = 99999,
	[TearVariant.GRIDENT] = 99999,
	[TearVariant.KEY] = 99999,
	[TearVariant.KEY_BLOOD] = 99999,
	[TearVariant.ERASER] = 99999,
	[TearVariant.FIRE] = 99999,
	[TearVariant.SWORD_BEAM] = 99999,
	[TearVariant.TECH_SWORD_BEAM] = 99999,
	[mod.TEAR.BOOMERANG_RIB] = 99999,
	[50] = 99999, -- Fetus tears
	[mod.TEAR.BRICK] = 99999,
	[mod.FF.FireworkRocket.Var] = 99999,
	[mod.FF.ChubberTear.Var] = 99999,
	[mod.TEAR.LEMON_MISHAP] = 99999,
	[mod.TEAR.TRAINER_CARD] = 99999,
	[mod.FF.PocketRockitTear.Var] = 99999,
	[mod.TEAR.GANYMEDE] = 99999,
	[mod.TEAR.STAR] = 99999,
	[mod.TEAR.MAGIC_BULLET] = 99999,

	-- Random tear effect; probably shouldn't be overwritten
	[TearVariant.EGG] = 3,
	[TearVariant.COIN] = 3,
	[TearVariant.NEEDLE] = 3,
	[mod.TEAR.D10] = 3,
	[FiendFolio.TEAR.WARDING] = 3,
	[mod.TEAR.YAAI] = 3,

	-- Random tear effect; can be overwritten
	[TearVariant.TOOTH] = 2,
	[TearVariant.RAZOR] = 2,
	[TearVariant.BLACK_TOOTH] = 2,
	[TearVariant.FIST] = 2,
	[mod.TEAR.FORTUNE_COOKIE] = 2,
	[mod.TEAR.M90_BULLET] = 2,
	[mod.TEAR.MULTI_EUCLIDEAN] = 2,
	[mod.TEAR.LAWN_DART] = 2,
	[mod.TEAR.ANATHEMA] = 2,
	[mod.TEAR.TENNIS_BALL] = 2,
	[mod.TEAR.INFESTATION_0] = 2,

	-- Random tear effect; usually overwritten
	[TearVariant.GODS_FLESH] = 1,
	[TearVariant.GODS_FLESH_BLOOD] = 1,
	[TearVariant.EXPLOSIVO] = 1,
	[TearVariant.GLAUCOMA] = 1,
	[TearVariant.GLAUCOMA_BLOOD] = 1,
	[TearVariant.BOOGER] = 1,
	[TearVariant.SPORE] = 1,
	[mod.TEAR.HOMING_AMULET] = 1,
	[mod.TEAR.HOMING_AMULET_BLOOD] = 1,
	[mod.TEAR.EMOJI_GLASS] = 1,

	--Don't remember why chosen, but I'll let them be
	[FiendFolio.TEAR.ACUPUNCTURE_NEEDLE] = 0.9,
	[FiendFolio.TEAR.ACUPUNCTURE_NEEDLE_BLOOD] = 0.9,

	--She is above them.
	[mod.TEAR.FRIEND_BULLET] = 0.75,
	[mod.TEAR.GOLEMS_AR_BULLET] = 0.75,

	-- Base tear appearance; try to keep these
	[TearVariant.EYE] = 0.5,
	[TearVariant.EYE_BLOOD] = 0.5,
	[TearVariant.SCHYTHE] = 0.5,
	[mod.TEAR.HORNCOB_PILL] = 0.5,

	-- Base tear appearance; always overwritten
	[TearVariant.METALLIC] = 0,
	[TearVariant.LOST_CONTACT] = 0,
	[TearVariant.DIAMOND] = 0,
	[TearVariant.BONE] = 0,
	[TearVariant.ICE] = 0,
	[TearVariant.ROCK] = 0,
	[mod.TEAR.PIN] = 0,
	[mod.TEAR.PIN_BLOOD] = 0,
	[mod.TEAR.MODEL_ROCKET] = 0,
	[mod.TEAR.RADIOACTIVE] = 0,
	
	-- Truly base tears; should never override anything
	[TearVariant.BLUE] = -1,
	[TearVariant.BLOOD] = -1,
	[TearVariant.CUPID_BLUE] = -1,
	[TearVariant.CUPID_BLOOD] = -1,
	[TearVariant.FIRE_MIND] = -1,
	[TearVariant.DARK_MATTER] = -1,
	[TearVariant.MYSTERIOUS] = -1,
	[TearVariant.PUPULA] = -1,
	[TearVariant.PUPULA_BLOOD] = -1,
	[TearVariant.NAIL] = -1,
	[TearVariant.NAIL_BLOOD] = -1,
	[TearVariant.HUNGRY] = -1,
	[mod.TEAR.FROG] = -1,
	[mod.TEAR.FROG_BLOOD] = -1,
	[mod.TEAR.PRANK_COOKIE] = -1,
}

-- Tear variants considered bloody; used in changing variants of tears
mod.BloodyTears = {
	[TearVariant.BLOOD] = true,
	[TearVariant.CUPID_BLOOD] = true,
	[TearVariant.PUPULA_BLOOD] = true,
	[TearVariant.GODS_FLESH_BLOOD] = true,
	[TearVariant.NAIL_BLOOD] = true,
	[TearVariant.GLAUCOMA_BLOOD] = true,
	[TearVariant.EYE_BLOOD] = true,
	[mod.TEAR.HOMING_AMULET_BLOOD] = true,
	[mod.TEAR.FROG_BLOOD] = true,
	[mod.TEAR.PIN_BLOOD] = true,
}

-- Tear variants that correspond directly to a bloody variant
mod.RegularToBlood = {
	[TearVariant.BLUE] = TearVariant.BLOOD,
	[TearVariant.CUPID_BLUE] = TearVariant.CUPID_BLOOD,
	[TearVariant.PUPULA] = TearVariant.PUPULA_BLOOD,
	[TearVariant.GODS_FLESH] = TearVariant.GODS_FLESH_BLOOD,
	[TearVariant.NAIL] = TearVariant.NAIL_BLOOD,
	[TearVariant.GLAUCOMA] = TearVariant.GLAUCOMA_BLOOD,
	[TearVariant.EYE] = TearVariant.EYE_BLOOD,
	[mod.TEAR.HOMING_AMULET] = mod.TEAR.HOMING_AMULET_BLOOD,
	[mod.TEAR.FROG] = mod.TEAR.FROG_BLOOD,
	[mod.TEAR.PIN] = mod.TEAR.PIN_BLOOD,
}

-----------------------------------------------------------
-- Custom Callbacks
-----------------------------------------------------------

-- FF_CUSTOM_TEAR_RENDER
-- Function args: EntityTear tear, int variant, table data, Vector offset
-- Optional args: int variant
-- Return type: void
--
-- Called when a custom tear variant is rendered.
function mod:renderCustomTear(tear, offset)
	local data = mod:GetEntityData(tear)
	if data.forceColor then
		tear.Color = data.forceColor
	end

	Isaac.RunCallbackWithParam("FF_CUSTOM_TEAR_RENDER", tear.Variant, tear, tear.Variant, data, offset)
	data.FFLastVariant = tear.Variant

	data.RocketTearPreviousLength = tear.Velocity:Length()
	if tear.Variant ~= mod.TEAR.MODEL_ROCKET then
		data.RocketTearPreviousSuffix = nil
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_TEAR_RENDER, mod.renderCustomTear)

-- FF_CUSTOM_TEAR_SPLAT
-- Function args: EntityTear tear, int variant, table data
-- Optional args: int variant
-- Return type: void
--
-- Called when a custom tear variant disappears upon impact with an enemy/grid/wall/floor. Should be used to handle visual/sound effects.
function mod:handleCustomTearSplat(tear)
	local data = mod:GetEntityData(tear)
	if data.ffNoSplat then return end

	if tear.Variant == mod.TEAR.BRICK then
		mod:brickTearSplat(tear)
		return
    end

	Isaac.RunCallbackWithParam("FF_CUSTOM_TEAR_SPLAT", tear.Variant, tear, tear.Variant, data)
end
mod:AddCallback(ModCallbacks.MC_POST_TEAR_DEATH, mod.handleCustomTearSplat)

-----------------------------------------------------------
-- Helper Functions
-----------------------------------------------------------

-- Returns the priority tear variant between two variants, returning
function mod:getPriorityTearVariant(var1, var2)
	local priority1 = mod.TearVariantPriority[var1] or 0
	local priority2 = mod.TearVariantPriority[var2] or 0
	return (priority1 >= priority2 and var1) or var2
end

-- Returns if a tear variant is bloody or not
function mod:isBloodyTearVariant(var)
	return mod.BloodyTears[var] == true
end

-- Converts a tear to a tear variant respecting tear variant priority and whether or not the tear is bloody
function mod:changeTearVariant(tear, var, bloodvar, force)
	local origvar = tear.Variant
	if ((mod.TearVariantPriority[origvar] or 0) <= mod.TearVariantPriority[var] or force) then
		local tdata = mod:GetEntityData(tear)
		local mass = tear.Mass -- WHY DOES CHANGEVARIANT AFFECT MASS EXCUSE ME?????????
		local changedVariant = false
		if bloodvar and tdata.IsBloodyTear then
			if bloodvar ~= origvar then
				tear:ChangeVariant(bloodvar)
				changedVariant = true
			end
		else
			if var ~= origvar then
				tear:ChangeVariant(var)
				changedVariant = true
			end
		end
		tear.Mass = mass

		if changedVariant then
			if mod.BloodyTears[tear.Variant] then
				tdata.IsBloodyTear = true
			end

			tear:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

			--this gets cleared by changevariant for some reason ugh
			if tear.TearFlags & TearFlags.TEAR_FLAT == TearFlags.TEAR_FLAT then
				tear.SizeMulti = tear.SizeMulti * Vector(1, 1.5)
			end
			tear:ResetSpriteScale()
		end

		if var ~= tdata.FFLastVariant then
			tdata.FFCustomTearSprite = nil
			tdata.FFLastVariant = var
		end
	end
end

-- Converts a tear to a random tear variant
function mod:changeToRandomTearVariant(tear, force)
	local variants = {}
	for k,v in pairs(mod.TearVariantPriority) do
		if v ~= 99999 then
			table.insert(variants, k)
		end
	end

	if tear.Variant == TearVariant.SCHYTHE then
		tear.Scale = tear.Scale / 2
	end

	local var = variants[math.random(#variants)]
	if var ~= tear.Variant then
		mod:changeTearVariant(tear, var, nil, force)
	end
end

-- Converts a tearparams to a tear variant respecting tear variant priority and whether or not the tear is bloody
function mod:changeTearParamsVariant(tearparams, var, bloodvar, force)
	local origvar = tearparams.TearVariant
	if ((mod.TearVariantPriority[origvar] or 0) <= mod.TearVariantPriority[var] or force) then
		if bloodvar and mod:isBloodyTearVariant(origvar) then
			tearparams.TearVariant = bloodvar
		else
			tearparams.TearVariant = var
		end
	end
end

-- Sets a tear to be bloody
function mod:makeTearBloody(tear)
	mod:GetEntityData(tear).IsBloodyTear = true
	local bloodvar = mod.RegularToBlood[tear.Variant]
	if bloodvar then
		mod:changeTearVariant(tear, bloodvar)
	end
end

-- Calculates the sprite scale for a tear with 1 sprite-based visual size
function mod:getTearScale1(tear)
	local sprite = tear:GetSprite()
	local scale = tear.Scale
	local sizeMulti = tear.SizeMulti

	return Vector((scale * sizeMulti.X) / 2.55, (scale * sizeMulti.Y) / 2.55)
end

-- Calculates the sprite scale for a tear with 6 different sprite-based visual size changes (should be consistent with basegame tear variants)
function mod:getTearScale6(tear)
	local sprite = tear:GetSprite()
	local scale = tear.Scale
	local sizeMulti = tear.SizeMulti
	local flags = tear.TearFlags

	if scale > 2.55 then
        return Vector((scale * sizeMulti.X) / 2.55, (scale * sizeMulti.Y) / 2.55)
	elseif flags & TearFlags.TEAR_GROW == TearFlags.TEAR_GROW or flags & TearFlags.TEAR_LUDOVICO == TearFlags.TEAR_LUDOVICO then
		if scale <= 0.675 then
			return Vector((scale * sizeMulti.X) / 0.5, (scale * sizeMulti.Y) / 0.5)
		elseif scale <= 2.175 then
			local adjustedBase = math.ceil((scale - 0.175) / 0.25) * 0.25 + 0.175
			return Vector((scale * sizeMulti.X) / adjustedBase, (scale * sizeMulti.Y) / adjustedBase)
		else
			return Vector((scale * sizeMulti.X) / 2.55, (scale * sizeMulti.Y) / 2.55)
		end
    else
        return sizeMulti
	end
end

-- Calculates the sprite scale for a tear with 13 different sprite-based visual size changes (should be consistent with basegame tear variants)
function mod:getTearScale13(tear)
	local sprite = tear:GetSprite()
	local scale = tear.Scale
	local sizeMulti = tear.SizeMulti
	local flags = tear.TearFlags

	if scale > 2.55 then
        return Vector((scale * sizeMulti.X) / 2.55, (scale * sizeMulti.Y) / 2.55)
	elseif flags & TearFlags.TEAR_GROW == TearFlags.TEAR_GROW or flags & TearFlags.TEAR_LUDOVICO == TearFlags.TEAR_LUDOVICO then
		if scale <= 0.3 then
			return Vector((scale * sizeMulti.X) / 0.25, (scale * sizeMulti.Y) / 0.25)
		elseif scale <= 0.55 then
			local adjustedBase = math.ceil((scale - 0.175) / 0.25) * 0.25 + 0.175
			return Vector((scale * sizeMulti.X) / adjustedBase, (scale * sizeMulti.Y) / adjustedBase)
		elseif scale <= 1.175 then
			local adjustedBase = math.ceil((scale - 0.175) / 0.125) * 0.125 + 0.175
			return Vector((scale * sizeMulti.X) / adjustedBase, (scale * sizeMulti.Y) / adjustedBase)
		elseif scale <= 2.175 then
			local adjustedBase = math.ceil((scale - 0.175) / 0.25) * 0.25 + 0.175
			return Vector((scale * sizeMulti.X) / adjustedBase, (scale * sizeMulti.Y) / adjustedBase)
		else
			return Vector((scale * sizeMulti.X) / 2.55, (scale * sizeMulti.Y) / 2.55)
		end
    else
        return sizeMulti
	end
end

function mod:handleTearScale13Anims(tear, prefix)
	local sprite = tear:GetSprite()
	local scale = tear.Scale
	
	prefix = prefix or "Regular"
	
	local anim
	if scale <= 0.3 then
		anim = prefix .. "Tear1"
	elseif scale <= 0.55 then
		anim = prefix .. "Tear2"
	elseif scale <= 0.675 then
		anim = prefix .. "Tear3"
	elseif scale <= 0.8 then
		anim = prefix .. "Tear4"
	elseif scale <= 0.925 then
		anim = prefix .. "Tear5"
	elseif scale <= 1.05 then
		anim = prefix .. "Tear6"
	elseif scale <= 1.175 then
		anim = prefix .. "Tear7"
	elseif scale <= 1.425 then
		anim = prefix .. "Tear8"
	elseif scale <= 1.675 then
		anim = prefix .. "Tear9"
	elseif scale <= 1.925 then
		anim = prefix .. "Tear10"
	elseif scale <= 2.175 then
		anim = prefix .. "Tear11"
	elseif scale <= 2.55 then
		anim = prefix .. "Tear12"
	else
		anim = prefix .. "Tear13"
	end
	
	if not sprite:IsPlaying(anim) then
		local frame = sprite:GetFrame()
		sprite:Play(anim, true)
		sprite:SetFrame(frame)
	end

	local spritescale = mod:getTearScale13(tear)
	local layers = sprite:GetAllLayers()
	for _, layer in ipairs(layers) do
		layer:SetSize(spritescale)
	end
end

-- Returns the tear poof EffectVariant for a tear based on scale and whether or not it splatted on the ground or not
-- NOTE: Modified from Sbody's Missing Tear GFX mod
function mod:getNormalTearPoofVariant(scale, height)
	--if scale > 1.8625 then
	--	if height < -5 then
	--		return TEAR_POOF_A_LARGE    -- Wall impact
	--	else
	--		return TEAR_POOF_B_LARGE    -- Floor impact
	--	end
	if scale > 0.8 then
		if height < -5 then
			return EffectVariant.TEAR_POOF_A    -- Wall impact
		else
			return EffectVariant.TEAR_POOF_B    -- Floor impact
		end
	elseif scale > 0.4 then
		return EffectVariant.TEAR_POOF_SMALL
	else
		return EffectVariant.TEAR_POOF_VERYSMALL
	end
end

-- Calculates the tearparams scale for a given player/damage/flags
function mod:getTearParamsScale(player, damage, flags, forceTears)
	local scale = 1.0
	local playertype = player:GetPlayerType()
	if playertype == PlayerType.PLAYER_EVE_B then
		scale = scale * 0.8
	elseif playertype == PlayerType.PLAYER_JACOB then
		scale = scale * 0.9
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK) then
		scale = scale * 0.7
	elseif player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
		scale = scale * 0.5
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_DEAD_ONION) then
		scale = scale * 1.5
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_PROPTOSIS) or player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_PROPTOSIS) then
		scale = scale * 3.0
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_PISCES) or player:GetZodiacEffect() == CollectibleType.COLLECTIBLE_PISCES then
		scale = scale * 1.25
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_PUPULA_DUPLEX) then
		scale = scale * 3.0
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_TROPICAMIDE) then
		scale = (scale + 0.2) * 1.25
	end
	if (1.0 < scale) then
		scale = math.log(scale) + 1.0
	end
	scale = math.sqrt(damage) * 0.23 + scale * 0.55 + damage * 0.01
	if (forceTears or player:HasWeaponType(WeaponType.WEAPON_TEARS) or player:HasWeaponType(WeaponType.WEAPON_BOMBS)) and
	   flags & TearFlags.TEAR_EXPLOSIVE == TearFlags.TEAR_EXPLOSIVE and
	   flags & TearFlags.TEAR_LUDOVICO == TearFlags.TEAR_NORMAL
	then
		scale = scale * 0.5
	end
	return scale
end

-----------------------------------------------------------
-- Miscellaneous
-----------------------------------------------------------

-- Determines whether or not a tear should be bloody
mod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, function(_, tear)
	if mod.BloodyTears[tear.Variant] then
		mod:GetEntityData(tear).IsBloodyTear = true
	end
end)

mod:AddCallback(TearFlagsLib.Callback.POST_CLEAR_LUDOVICO_FLAGS, function(_, entity, player)
	local data = mod:GetEntityData(entity)
	if entity.Type == EntityType.ENTITY_TEAR then
		data.IsBloodyTear = nil
		if mod.BloodyTears[entity.Variant] then
			data.IsBloodyTear = true
		end
	end

	-- putting these here for optimization purposes
	data.FFBeansInfo = {}
end)
