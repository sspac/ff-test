local mod = FiendFolio

local Settings = {
	BaseChance = 50,
	ExtraChance = 25,

	BaseDamage = 100,
	FuseTime = 30,
	FuseTimeGiga = 60,

	-- Size thresholds to pass for bigger bomb scales
	SizeThresholds = {
		{ EntitySize = 0,  BombScale = 0.65, },
		{ EntitySize = 13, BombScale = 1, },
		{ EntitySize = 20, BombScale = 1.4, },
		{ EntitySize = 50, BombScale = 2, },
	},
	MrMegaBonus = 8,
}



function mod:PlushieWrathEnemyDeath(entity)
	if entity:IsActiveEnemy(true) and not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
		-- Get the nearest player with the trinket
		local nearestPlayer
		local nearestDistance = 9999

		for i, player in pairs( PlayerManager.GetPlayers() ) do
			if player:HasTrinket(mod.ITEM.TRINKET.PLUSHIE_WRATH) then
				local distance = entity.Position:Distance(player.Position)

				if distance < nearestDistance then
					nearestPlayer = player
					nearestDistance = distance
				end
			end
		end

		-- Use the nearest player for spawning the bomb
		if nearestPlayer then
			local rng = nearestPlayer:GetTrinketRNG(mod.ITEM.TRINKET.PLUSHIE_WRATH)
			local multi = nearestPlayer:GetTrinketMultiplier(mod.ITEM.TRINKET.PLUSHIE_WRATH)
			local extraChance = (multi - 1) * Settings.ExtraChance
			local chance = Settings.BaseChance + extraChance

			if entity:IsBoss() or mod:Random(nil, nil, rng) <= chance / 100 then
				-- Get the bomb scale based on the entity's size
				local bombScale = 1

				local entityScale = 1 + (entity.Scale - 1) / 2
				local entitySize = entity.Size * mod:Lerp(entity.SizeMulti.X, entity.SizeMulti.Y, 0.5)
				local mrMegaBonus = nearestPlayer:HasCollectible(CollectibleType.COLLECTIBLE_MR_MEGA) and Settings.MrMegaBonus or 0
				local checkSize = (entitySize * entityScale) + mrMegaBonus

				-- Go through each threshold and check if they are passed
				for i, entry in ipairs( Settings.SizeThresholds ) do
					if checkSize >= entry.EntitySize then
						bombScale = entry.BombScale
					else
						break
					end
				end

				-- Get the bomb flags and variant
				local flags = nearestPlayer:GetBombFlags()
				local variant = bombScale >= 2 and BombVariant.BOMB_GIGA or nearestPlayer:GetBombVariant(flags, false)

				local bomb = Isaac.Spawn(EntityType.ENTITY_BOMB, variant, 0, entity.Position, Vector.Zero, nearestPlayer):ToBomb()
				bomb.Flags = flags
				bomb:SetLoadCostumes(true)
				mod:PlaySoundCool(nil, SoundEffect.SOUND_FETUS_LAND)

				-- Set the fuse time, size and damage
				if variant == BombVariant.BOMB_GIGA then
					bomb:SetExplosionCountdown(Settings.FuseTimeGiga)
				else
					bomb:SetExplosionCountdown(Settings.FuseTime)
					bomb.ExplosionDamage = Settings.BaseDamage * bombScale
					bomb:SetScale(bombScale)
					bomb.RadiusMultiplier = bombScale
				end

				-- Set the bomb flag source
				local data = mod:GetEntityData(bomb)
				data.ffOverrideBombFlagSource = mod.BombFlagSource.WRATHFUL_PLUSHIE
				Isaac.RunCallbackWithParam(FiendFolio.CALLBACK.FF_POLL_BOMBFLAGS, nil, bomb, nearestPlayer, mod.BombFlagSource.WRATHFUL_PLUSHIE)
				data.HasPolledBombFlags = true
			end
		end
	end
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.ITEM.TRINKET.PLUSHIE_WRATH, mod.PlushieWrathEnemyDeath)