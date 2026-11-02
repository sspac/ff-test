local mod = FiendFolio

local Settings = {
	MaxAmount = 15,

	BaseChance = 30,
	ChampionBonus = 10,
	MaxChanceLuck = 35,
	SpawnerMulti = 0.5,

	DamageBonus = 0.1,
	ExtraCopyBonus = 0.05,

	ProgressTextInterval = 5,
	FireworksDuration = 10 * 30,
}



-- Get the amount of friendly embryos
function mod:CountFriendlyEmbryos()
	local count = 0

	for i, embryo in pairs( Isaac.FindByType(EntityType.ENTITY_EMBRYO) ) do
		if embryo:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and not embryo:IsDead() then
			count = count + 1
		end
	end
	return count
end

-- Increase damage for every friendly embryo
function mod:SetBlastulationDamage(player, cacheFlags)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.BLASTULATION) then
		local extraCopies = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.BLASTULATION) - 1
		local bonus = extraCopies * Settings.ExtraCopyBonus

		local add = mod:CountFriendlyEmbryos() * (Settings.DamageBonus + bonus)
		player.Damage = player.Damage + add
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ITEM.COLLECTIBLE.BLASTULATION, mod.SetBlastulationDamage, CacheFlag.CACHE_DAMAGE)

-- Update the damage bonus for all players
function mod:UpdateBlastulationCache()
	for i, player in pairs( PlayerManager.GetPlayers() ) do
		if player:HasCollectible(mod.ITEM.COLLECTIBLE.BLASTULATION) then
			player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
			player:EvaluateItems()
		end
	end
end



-- Check if an entity should spawn a Blastulation embryo
function mod:ShouldSpawnBlastulationEmbryo(source)
	-- Check the source entity
	if source.Type == EntityType.ENTITY_EMBRYO
	or source:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)
	or not source.CanShutDoors or not source:IsActiveEnemy(true) then
		return false
	end


	-- Check if the max amount is reached
	if mod:CountFriendlyEmbryos() >= Settings.MaxAmount then
		return false
	end


	-- Always spawn one from bosses
	if source:IsBoss() and not source.Parent then
		return true

	else
		-- Get the highest luck from all players that have the item
		local highestLuck = 0

		for i, player in pairs( PlayerManager.GetPlayers() ) do
			if player:HasCollectible(mod.ITEM.COLLECTIBLE.BLASTULATION) and player.Luck > highestLuck then
				highestLuck = player.Luck
			end
		end

		-- Get the chance
		local championBonus = source:IsChampion() and Settings.ChampionBonus or 0
		local luckBonus = highestLuck * (100 - Settings.BaseChance) / Settings.MaxChanceLuck
		local chance = Settings.BaseChance + championBonus + luckBonus

		-- Lower chance for enemies spawned by other ones
		if source.SpawnerEntity then
			chance = chance * Settings.SpawnerMulti
		end

		local rng = PlayerManager.FirstCollectibleOwner(mod.ITEM.COLLECTIBLE.BLASTULATION):GetCollectibleRNG(mod.ITEM.COLLECTIBLE.BLASTULATION)
		return mod:Random(nil, nil, rng) <= chance / 100
	end
end

-- Spawn an embryo when an enemy dies
function mod:BlastulationDeath(entity)
	if mod:ShouldSpawnBlastulationEmbryo(entity) then
		local rng = RNG(entity.InitSeed)
		local picker = entity:IsBoss() and mod.EmbryoPickers.Boss or mod.EmbryoPickers.Enemy
		local chosen = picker:PickOutcome(rng)

		local pos = Game():GetRoom():FindFreeTilePosition(entity.Position, 0)
		local spawner = Game():GetNearestPlayer(entity.Position)
		Isaac.Spawn(EntityType.ENTITY_EMBRYO, chosen, 0, pos, Vector.Zero, spawner):Update()
		mod:PlaySoundCool(nil, SoundEffect.SOUND_PLOP)
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.ITEM.COLLECTIBLE.BLASTULATION, mod.BlastulationDeath)



-- Turn all embryos friendly
function mod:BlastulationEmbryoConvert(entity)
	if not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and PlayerManager.AnyoneHasCollectible(mod.ITEM.COLLECTIBLE.BLASTULATION) then
		local source = Game():GetNearestPlayer(entity.Position)
		entity:AddCharmed(EntityRef(source), -1)
		mod:UpdateBlastulationCache()


		-- Create the bestiary tracker
		local runData = mod.savedata.run
		runData.blastulationEmbryos = runData.blastulationEmbryos or {}

		-- Update bestiary completion
		if mod.BlastulationEmbryos[entity.Variant] and not runData.blastulationEmbryos[entity.Variant] then
			runData.blastulationEmbryos[entity.Variant] = true

			local total = mod:GetTableLength(mod.BlastulationEmbryos)
			local discovered = mod:GetTableLength(runData.blastulationEmbryos)

			-- CELEBRATE!!!
			if discovered >= total then
				Game():GetHUD():ShowItemText("You found every embryo!")

				for i, player in pairs( PlayerManager.GetPlayers() ) do
					if player:HasCollectible(mod.ITEM.COLLECTIBLE.BLASTULATION) then
						player:AnimateHappy()

						-- COOL FIREWORKS!!!!!
						local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FIREWORKS, 0, player.Position, Vector.Zero, player):ToEffect()
						effect:FollowParent(player)
						effect.Timeout = Settings.FireworksDuration
					end
				end

			-- Awesome progress text
			elseif discovered % Settings.ProgressTextInterval <= 0 then
				local pos = entity.Position + entity:GetNullOffset("OverlayEffect")
				local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.FF.Blastulation.ProgressText, 0, pos, Vector.Zero, entity)
				effect.TargetPosition = Vector(discovered, total)
			end
		end
	end
end