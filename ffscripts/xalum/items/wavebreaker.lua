local mod = FiendFolio
local sfx = SFXManager()
local positionsCache = {}

local function doEntityRemoveEffect(position)
	sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE)

	for i = 1, 3 do
		local gib = Isaac.Spawn(1000, 4, 0, position, RandomVector(), nil)
		gib:Update()
	end
end

mod:AddPriorityTrinketCallback(ModCallbacks.MC_POST_NPC_INIT, CallbackPriority.EARLY, mod.ITEM.TRINKET.WAVEBREAKER, function(_, npc)
	if mod.IsWatingEntity(npc) then
		table.insert(positionsCache, npc.Position)
		npc:Remove()
	end
end)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, CallbackPriority.EARLY, function()
	if #positionsCache > 0 then
		for _, position in pairs(positionsCache) do
			doEntityRemoveEffect(position)
		end

		mod.AnyPlayerDo(function(player)
			if player:HasTrinket(mod.ITEM.TRINKET.WAVEBREAKER) then
				player:AnimateTrinket(mod.ITEM.TRINKET.WAVEBREAKER, "UseItem")
			end
		end)

		positionsCache = {}
	end
end)