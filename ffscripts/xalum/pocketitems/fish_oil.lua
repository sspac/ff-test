local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

mod:AddCallback(ModCallbacks.MC_USE_PILL, function(_, effect, player, flags, pillColor)
	local doHorseEffect = pillColor & PillColor.PILL_GIANT_FLAG > 0
	local strength = doHorseEffect and 2 or 1
	local data = mod.GetPersistentPlayerData(player)
	data.ffFishOilTracker = data.ffFishOilTracker and data.ffFishOilTracker + strength or strength

	player:AnimateHappy()
	if doHorseEffect then
		sfx:Play(SoundEffect.SOUND_POWERUP_SPEWER_AMPLIFIED, 1, 0, false, 1)
		sfx:Play(SoundEffect.SOUND_THUMBSUP_AMPLIFIED, 1, 0, false, 1)
		mod:trySayAnnouncerLine(mod.Sounds.VAPillHorseFishOil, flags, 20)
	else
		mod:trySayAnnouncerLine(mod.Sounds.VAPillFishOil, flags, 20)
	end
end, mod.ITEM.PILL.FISH_OIL)

mod:AddCallback(ModCallbacks.MC_USE_PILL, function(_, effect, player, flags, pillColor)
	local doHorseEffect = pillColor & PillColor.PILL_GIANT_FLAG > 0
	local strength = doHorseEffect and 2 or 1
	local data = mod.GetPersistentPlayerData(player)
	data.ffLemonJuiceTracker = data.ffLemonJuiceTracker and data.ffLemonJuiceTracker + strength or strength

	player:AnimateSad()
	if doHorseEffect then
		sfx:Play(SoundEffect.SOUND_THUMBSDOWN_AMPLIFIED, 1, 0, false, 1)
		mod:trySayAnnouncerLine(mod.Sounds.VAPillHorseLemonJuice, flags, 30)
	else
		mod:trySayAnnouncerLine(mod.Sounds.VAPillLemonJuice, flags, 20)
	end
end, mod.ITEM.PILL.LEMON_JUICE)

local OilVal = 1.8 --Loosely how much it scales by, previously 2.25

local function doFishOil(tearparams, player)
	local data = mod.GetPersistentPlayerData(player)
	if data.ffFishOilTracker and data.ffFishOilTracker > 0 then
		local multiplier = 1.5 * math.log(data.ffFishOilTracker / 3, 10) + OilVal
		tearparams.TearScale = tearparams.TearScale * multiplier
	end
end

local function doLemonJuice(tearparams, player)
	local data = mod.GetPersistentPlayerData(player)
	if data.ffLemonJuiceTracker and data.ffLemonJuiceTracker > 0 then
		local multiplier = 1.5 * math.log(data.ffLemonJuiceTracker / 3, 10) + OilVal
		tearparams.TearScale = tearparams.TearScale * 1 / multiplier
	end
end

function mod:fishOilTearHitParams(player, tearparams, weapontype, damagescale, teardisplacement, source)
	doFishOil(tearparams, player)
	doLemonJuice(tearparams, player)
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_TEAR_HIT_PARAMS, mod.fishOilTearHitParams)

mod:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, function(_, knife)
	local player = knife.Parent and knife.Parent:ToPlayer()

	if player then
		local data = mod.GetPersistentPlayerData(player)
		if (data.ffFishOilTracker or 0) + (data.ffLemonJuiceTracker or 0) > 0 then

			local fishOilScale = 1 
			local lemonJuiceScale = 1

			if (data.ffFishOilTracker or 0) > 0 then
				fishOilScale = 1.5 * math.log(data.ffFishOilTracker / 3, 10) + OilVal
			end
			if (data.ffLemonJuiceTracker or 0) > 0 then
				lemonJuiceScale = 1.5 * math.log(data.ffLemonJuiceTracker / 3, 10) + OilVal
			end

			knife.SpriteScale = Vector.One * fishOilScale / lemonJuiceScale
			if not mod.IsKnifeSwingable(knife) then
				knife.SizeMulti = knife.SpriteScale
			end
		end 
	end
end)