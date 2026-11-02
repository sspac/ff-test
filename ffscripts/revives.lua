local mod = FiendFolio
local game = Game()

function mod.HasSoulOfLazarusRevive(player)
	return player:GetCard(0) == Card.CARD_SOUL_LAZARUS
		or player:GetCard(1) == Card.CARD_SOUL_LAZARUS
		or player:GetCard(2) == Card.CARD_SOUL_LAZARUS
		or player:GetCard(3) == Card.CARD_SOUL_LAZARUS
		or player:GetEffects():HasNullEffect(NullItemID.ID_LAZARUS_SOUL_REVIVE)
end

local function _SkipIfPlayerHasCollectible(id)
	return function(player)
		return player:HasCollectible(id)
	end
end

-- Functions in this table are called in order to evaluate revive effects.
-- If a function returns true, the remaining checks in that tier are skipped without reviving the player.
-- This is used to split up the revive effects' priority with vanilla revive checks.
-- For example, everything underneath the 1UP check will not run (and therefore not revive) if the player has 1UP.
-- Functions should be defined like `mod.TryMyRevive(player, data, effects)`
-- If you want to revive the player, call `player:Revive()`! then modify health as desired.
FF_REVIVE_CHECKS = {
	-- High priority revives that are intended to trigger before EVERYTHING else, where possible.
	HIGH_PRIORITY = {
		mod.CheckReviveMeCommandRevive,
		mod.TryFrogPuppetRevive,
		mod.TryCursedUrnRevive,
	},
	-- Normal revives, split up by vanilla effects.
	NORMAL_PRIORITY = {
		mod.HasSoulOfLazarusRevive,
			mod.TryJesusRockRevive,
			mod.TryPakChoiRevive,
		_SkipIfPlayerHasCollectible(CollectibleType.COLLECTIBLE_1UP),
		function(player) return player:GetPlayerType() == PlayerType.PLAYER_LAZARUS end,
			mod.TrySoulShardsRevive,
			mod.TryPhoenixElixerRevive,
		_SkipIfPlayerHasCollectible(CollectibleType.COLLECTIBLE_DEAD_CAT),
			mod.TryDeadDogRevive,
		_SkipIfPlayerHasCollectible(CollectibleType.COLLECTIBLE_INNER_CHILD),
			mod.TryCraigsPipeRevive,
			mod.TryCharacterSelectRevive,
		_SkipIfPlayerHasCollectible(CollectibleType.COLLECTIBLE_LAZARUS_RAGS),
		_SkipIfPlayerHasCollectible(CollectibleType.COLLECTIBLE_ANKH),
		_SkipIfPlayerHasCollectible(CollectibleType.COLLECTIBLE_JUDAS_SHADOW),
			mod.TryDevilsHarvestRevive,
	},
	-- Revives that should be checked late, after all vanilla revives and most others.
	LOW_PRIORITY = {
		mod.TryIsaacDotChrRevive,
	},
}

local function ProcessRevives(player, effectsList)
	local data = mod:GetEntityData(player)

	-- Skip everything for malice minions and stuff like Found Soul
	if data.MaliceMinion or player.Variant ~= PlayerVariant.PLAYER then return end

	if player:GetMainTwin() and GetPtrHash(player) ~= GetPtrHash(player:GetMainTwin()) then
		-- We check the non-main twin's revives from the main twin's callback.
		return
	end

	local effects = player:GetEffects()

	local twin = player:GetOtherTwin()
	local twinData = twin and mod:GetEntityData(twin)
	local twinEffects = twin and twin:GetEffects()

	for _, func in ipairs(effectsList) do
		if func(player, data, effects) then
			return
		end

		if twin and twin:Exists() then
			if player:IsDead() then
				if twin:IsDead() then
					if func(twin, twinData, twinEffects) then
						return
					end
				end
				if not twin:IsDead() then
					player:Revive()
				end
			end
			if not player:IsDead() then
				if twin:IsDead() then
					twin:Revive()
				end
				if twin:GetHearts() < player:GetHearts() then
					twin:AddHearts(player:GetHearts() - twin:GetHearts())
				elseif player:GetHearts() < twin:GetHearts() then
					player:AddHearts(twin:GetHearts() - player:GetHearts())
				end
			end
		end

		if not player:IsDead() or not player:Exists() then
			return
		end
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_TRIGGER_PLAYER_DEATH, CallbackPriority.IMPORTANT, function(_, player) ProcessRevives(player, FF_REVIVE_CHECKS.HIGH_PRIORITY) end)
mod:AddPriorityCallback(ModCallbacks.MC_PRE_TRIGGER_PLAYER_DEATH, CallbackPriority.EARLY, function(_, player) ProcessRevives(player, FF_REVIVE_CHECKS.NORMAL_PRIORITY) end)
mod:AddPriorityCallback(ModCallbacks.MC_TRIGGER_PLAYER_DEATH_POST_CHECK_REVIVES, CallbackPriority.LATE, function(_, player) ProcessRevives(player, FF_REVIVE_CHECKS.LOW_PRIORITY) end)
