local mod = FiendFolio

local Settings = {
	BaseChance = 50,
	ExtraChance = 25,
	BossDuration = 5 * 30,
}



function mod:PlushieLustPlayerDMG(entity, amount, flags, source, countdown, extraSource)
	local player = entity:ToPlayer()
	local npc = source.Entity and source.Entity:ToNPC()

	if npc and npc:IsActiveEnemy(false) and not extraSource -- Only charm valid enemies through contact damage
	and not npc:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) then -- Can be charmed
		local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.PLUSHIE_LUST)
		local multi = player:GetTrinketMultiplier(mod.ITEM.TRINKET.PLUSHIE_LUST)
		local extraChance = (multi - 1) * Settings.ExtraChance
		local chance = Settings.BaseChance + extraChance

		if mod:Random(nil, nil, rng) <= chance / 100 then
			local wasCharmed = npc:HasEntityFlags(EntityFlag.FLAG_CHARM)
			local duration = npc:IsBoss() and Settings.BossDuration or -1
			npc:AddCharmed(EntityRef(player), duration)

			-- Effects
			if not wasCharmed and npc:HasEntityFlags(EntityFlag.FLAG_CHARM) then
				npc:SetColor(Color(1,1,1, 1, 0.6,0,0.4), 12, 1, true, false)
				mod:PlaySoundCool(nil, SoundEffect.SOUND_KISS_LIPS1)
			end
		end
	end
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, mod.ITEM.TRINKET.PLUSHIE_LUST, mod.PlushieLustPlayerDMG, EntityType.ENTITY_PLAYER)