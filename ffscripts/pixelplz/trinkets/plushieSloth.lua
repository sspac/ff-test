local mod = FiendFolio
local game = Game()

local Settings = {
	BaseChance = 33,
	ExtraChance = 22,
}

local queuedSkip = false



-- Try to skip the current room / wave
local function trySkip(rng)
	local multi = PlayerManager.GetTotalTrinketMultiplier(mod.ITEM.TRINKET.PLUSHIE_SLOTH)

	if multi > 0 then
		local extraChance = (multi - 1) * Settings.ExtraChance
		local chance = Settings.BaseChance + extraChance

		if mod:Random(nil, nil, rng) <= chance / 100 then
			mod:skipCardRoom()
		end
	end

	queuedSkip = false
end



-- Try to skip new regular rooms
function mod:PlushieSlothNewRoom()
	mod.scheduleForUpdate(function()
		local level = game:GetLevel()
		local room = game:GetRoom()

		if level:GetCurrentRoomIndex() ~= level:GetStartingRoomIndex() -- Not the starting room
		and room:GetType() == RoomType.ROOM_DEFAULT -- Is a regular room
		and room:IsFirstVisit() then -- First visiting
			trySkip(rng)
		end
	end, 1, ModCallbacks.MC_POST_UPDATE, true)
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.ITEM.TRINKET.PLUSHIE_SLOTH, mod.PlushieSlothNewRoom)



-- Wait for the spawn pentagrams before trying to skip waves
function mod:PlushieSlothNewWave(effect)
	if not queuedSkip and effect.Variant == EffectVariant.SPAWN_PENTAGRAM then
		mod.scheduleForUpdate(function()
			local rng = RNG( game:GetRoom():GetSpawnSeed() )

			-- Get the wave offset
			local level = game:GetLevel()
			local waveOffset = Ambush.GetCurrentWave()

			if game:IsGreedMode() and level:GetCurrentRoomIndex() == level:GetStartingRoomIndex() then
				waveOffset = level.GreedModeWave
			end

			-- Offset the seed so different waves get different outcomes
			for i = 1, waveOffset do
				rng:Next()
			end
			trySkip(rng)

		end, 0, ModCallbacks.MC_POST_UPDATE, true)
		queuedSkip = true
	end
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, mod.PlushieSlothNewWave, EntityType.ENTITY_EFFECT)