local mod = FiendFolio
local game = Game()
local fiendsHorn = mod.ITEM.COLLECTIBLE.FIENDS_HORN

local function trySpawnMinion(player, position)
	if Isaac.CountEntities(nil, 1000, mod.PICKUP.VARIANT.FIEND_MINION_EFFECT, 1) < 10 then
		local minion = Isaac.Spawn(1000, mod.PICKUP.VARIANT.FIEND_MINION_EFFECT, 1, position, Vector.Zero, player)
		minion.EntityCollisionClass = 4
		minion.Parent = player

		local data = mod:GetEntityData(minion)
		data.hollow = true
		data.canreroll = false
	end
end

mod:AddCollectibleCallback(ModCallbacks.MC_POST_NPC_DEATH, fiendsHorn, function(_, npc)
	local player = PlayerManager.FirstCollectibleOwner(fiendsHorn)
	local rng = player:GetCollectibleRNG(fiendsHorn)
	local luck = mod.GetTotalPlayerLuck(fiendsHorn)
	local boost = 0.025 * mod.GetTotalGameImmoralHearts(fiendsHorn)
	local chance = TearFlagsLib.GetChance(luck, 0.2 + boost, 0.35 + boost, 14, PlayerManager.GetNumCollectibles(fiendsHorn))

	if rng:RandomFloat() < chance then
		trySpawnMinion(player, npc.Position)
	end
end)