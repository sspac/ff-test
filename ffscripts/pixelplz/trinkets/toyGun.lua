local mod = FiendFolio

local tierThresholds = {
	0, 8, 24, 40, 100,
}

-- THINGS THAT DONT WORK:
-- * Ramblin' Opal
-- * Cauldron Grimlin
-- * Chunk of Tar
-- * Sun Shard



function mod:ToyGunMakeGunslinger(id, entity, source, duration)
	if duration == -1 then -- A duration of -1 makes them friendly
		local npc = entity:ToNPC()

		if npc and mod:IsValidBountyEnemy(npc, true, true, true) -- Is a valid enemy
		and not mod:GetEntityData(npc).GunslingerData then -- Not already a gunslinger
			local tier = 1

			-- Go through each threshold and check if they are passed
			for i, entry in ipairs(tierThresholds) do
				if entity.MaxHitPoints >= entry then
					tier = i
				else
					break
				end
			end

			mod:MakeGunslinger(npc, tier)
		end
	end
end
--mod:AddCallback(ModCallbacks.MC_POST_STATUS_EFFECT_APPLY, mod.ToyGunMakeGunslinger, StatusEffect.CHARMED)