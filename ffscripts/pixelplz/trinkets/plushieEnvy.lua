local mod = FiendFolio

local Settings = {
	BaseChance = 15,
	ExtraChance = 10,
	SplitDelay = 4,
}

TearFlagsLib.RegisterTearFlag("ENVIOUS")



-- Have a chance to apply the tear flag
function mod:PlushieEnvyPollTearFlag(entity, player, weaponFlag)
	local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.PLUSHIE_ENVY)
	local multi = PlayerManager.GetTotalTrinketMultiplier(mod.ITEM.TRINKET.PLUSHIE_ENVY)
	local extraChance = (multi - 1) * Settings.ExtraChance
	local chance = Settings.BaseChance + extraChance

	if mod:Random(nil, nil, rng) <= chance / 100 then
		TearFlagsLib.AddTearFlags(entity, TearFlagsLib.Flag.ENVIOUS)
	end
end
mod:AddTrinketCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, mod.ITEM.TRINKET.PLUSHIE_ENVY, mod.PlushieEnvyPollTearFlag)



-- Handle the tear flag
function mod:PlushieEnvyApplyTearFlag(entity, player)
	local npc = entity:ToNPC()

	if npc and npc:IsActiveEnemy(false) and not npc:IsInvincible() then
		-- Split the enemy after a short delay (to make it line up with the effect)
		mod.scheduleForUpdate(function()
			npc:TrySplit(player.Damage, EntityRef(player), false)
		end, Settings.SplitDelay)

		-- Effects
		mod:PlaySoundCool(nil, SoundEffect.SOUND_SHELLGAME, 0.5)

		local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CLEAVER_SLASH, 0, npc.Position, Vector.Zero, entity):ToEffect()
		effect:FollowParent(npc)
		effect.DepthOffset = npc.DepthOffset + 10
	end
end
mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, mod.PlushieEnvyApplyTearFlag, TearFlagsLib.Flag.ENVIOUS)